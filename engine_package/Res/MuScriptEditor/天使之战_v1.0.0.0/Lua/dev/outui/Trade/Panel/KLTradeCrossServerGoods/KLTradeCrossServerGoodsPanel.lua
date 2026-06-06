---@class KLTradeCrossServerGoodsPanel:UIKmlLuaPanelBase
---@field view KLTradeCrossServerGoodsPanel
local KLTradeCrossServerGoodsPanel = class(UIKmlLuaPanelBase)
local this = KLTradeCrossServerGoodsPanel
---创建时调用一次
function this:Init()
    GUI:OSAScrollView_Initialized(self.view.osa_scrollview_crossServer_goods, self.UnionGoodsGetFun, self.UnionGoodsUpdateFun, self)
    self.goodsListData = {}
    -- self.refreshTimer = SL:Schedule(self.refreshTimer, 0, 3, -1, function()
    --     return self:RequestCurRefreshGoodsList()
    -- end)
    ---@type KLTradeCrossServerGoodsItem[]
    self.tradeUnionGoodsItems = {}
    self.tickTimer = SL:Schedule(self.tickTimer, 0, 1, -1, function()
        return self:Tick()
    end)
    self:RequestRefreshGoodsList()
end

function this:UnionGoodsGetFun()
    local item = GUI:UIPanel_Open("dev/outui/Trade/Item/KLTradeCrossServerGoods/KLTradeCrossServerGoodsItem", nil, self, nil, true)
    table.insert(self.tradeUnionGoodsItems, item)
    return item
end

---@param item KLTradeCrossServerGoodsItem
function this:UnionGoodsUpdateFun(item, index)
    local data = self.goodsListData[index + 1]
    item:SetData(data)
end

---注册UI事件和服务器消息
function this:RegistEvents()

end


---创建或者刷新界面数据时调用
function this:Refresh()
    
end

function this:Close()
    --SL:UnSchedule(self.refreshTimer)
    SL:UnSchedule(self.tickTimer)
end

function this:RequestRefreshGoodsList(type, subType, sortType, careerType, filterLevel, filterQuality)
    self.currentType = type or 2
    self.currentSubType = subType or 1
    self.currentSortType = sortType or 0
    self.currentCareerType = careerType or 0
    -- self.currentFilterLevel = filterLevel or 0
    -- self.currentFilterQuality = filterQuality or 0
    -- SL:LogError(self.currentType)
    -- SL:LogError(self.currentSubType)
    -- SL:LogError(self.currentSortType)
    -- SL:LogError(self.currentCareerType)
    self:RequestCurRefreshGoodsList()
end

function this:RequestCurRefreshGoodsList()
    if not self.currentType then
        return
    end
    --SL:LogError(self.currentType .."  ".. self.currentSubType.."  "..self.currentSortType.."  "..self.currentCareerType)
    self.goodsListData = {}
    local message = InfoManager.kundunInfo:KunDunTrade_GetInfo(self.currentType,self.currentSubType,self.currentSortType,self.currentCareerType)
    if message and next(message) then
        for k, v in ipairs(message) do
            self.goodsListData[k] = v
        end
    end
    GUI:OSAScrollView_RefreshList(self.view.osa_scrollview_crossServer_goods, #self.goodsListData)

end

function this:Tick()
    local refresh
    local items = GUI:OSAScrollView_GetAllItems(self.view.osa_scrollview_crossServer_goods)
    local remove_list = {}
    for i = 0, items.Count - 1 do
        local item = items[i]
        local expireData = item:Tick()
        if expireData then
            refresh = true
            --table.removeByValue(self.goodsListData, expireData)
            table.insert(remove_list,expireData.id)
            --table.remove( self.goodsListData,  i)
        end
    end
    if table.count(remove_list) > 0 then
        local new_list = {}
        for i = 1, #self.goodsListData, 1 do
            local is_add = true
            for j = 1, #remove_list, 1 do
                if remove_list[j] == self.goodsListData[i].id then
                    is_add = false
                    break
                end
            end
            if is_add then
                table.insert(new_list,self.goodsListData[i])
            end
        end
        self.goodsListData = new_list
    end
    if refresh then
        GUI:OSAScrollView_RefreshList(self.view.osa_scrollview_crossServer_goods, #self.goodsListData)
    end
end

return this
