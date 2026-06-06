---@class KLAppearCostPanel:UIKmlLuaPanelBase
---@field view KLAppearCostPanelView
local KLAppearCostPanel = class(UIKmlLuaPanelBase)
local this = KLAppearCostPanel
---创建时调用一次
function this:Init()
    GUI:DataListInitData(self.view.datalist1,
            function()
                return self:ItemCountFunc()
            end,
            function(realIndex)
                return self:ItemGetFunc(realIndex)
            end,
            function(realIndex, kmlCtrl)
                return self:ItemInitFunc(realIndex, kmlCtrl)
            end,
            function(realIndex, kmlCtrl)
                return self:ItemUpdateFunc(realIndex, kmlCtrl)
            end)

    ---@type {cfgId:number,count:number}[]
    self.costItems = {}
end

function this:ItemCountFunc()
    return #self.costItems
end

function this:ItemGetFunc()

end

function this:ItemInitFunc()

end

function this:ItemUpdateFunc(realIndex)
    local bagItem = GUI:GetChildControl(self.view.datalist1, realIndex, 'Item')
    local luaIndex = realIndex + 1
    local dt = self.costItems[luaIndex]
    GUI:Item_setItemId(bagItem, dt.cfgId)

    GUI:AddOnClickEvent(bagItem, self, self.OnCostItemOnClick, dt.cfgId)

    local txtCount = GUI:GetChildControl(self.view.datalist1, realIndex, 'TxtCount')

    local ownCount = SL:GetBagItemCount(dt.cfgId)
    GUI:Text_setString(txtCount, tostring(dt.count))
    local colorStr = ownCount >= dt.count and "#ffffff" or "#ff0000"
    GUI:Text_setTextColor(txtCount, colorStr)

end

function this:OnCostItemOnClick(_, cfgId)
    return SL:OpenTips(nil, cfgId)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    self.selectCfgIds = self.args
    self:AnalysisData()
    GUI:DataListUpdateData(self.view.datalist1)
end

function this:AnalysisData()
    table.clear(self.costItems)

    local id2Count = {}
    for _, cfgId in pairs(self.selectCfgIds) do
        ---@type cfg_fashion_column
        local fashionTbl = SL:GetConfig("cfg_fashion", cfgId)

        for _, v in pairs(fashionTbl.deplete) do
            local itemId = v[1]
            local count = v[2]
            if not id2Count[itemId] then
                id2Count[itemId] = count or 0
            else
                id2Count[itemId] = id2Count[itemId] + count
            end
        end
    end

    for id, count in pairs(id2Count) do
        table.insert(self.costItems, { cfgId = id, count = count })
    end
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.BtnClose, self, self.BtnCloseOnClick)
    GUI:AddOnClickEvent(self.view.BtnActive, self, self.BtnActiveOnClick)
end

function this:CanActive()
    for _, v in pairs(self.costItems) do
        local ownCount = SL:GetBagItemCount(v.cfgId)
        if ownCount < v.count then
            return false
        end
    end

    return true
end

function this:BtnActiveOnClick()
    if not self:CanActive() then
        SL:TipMessage(SL:GetConfig('cfg_string', 253).text, 1, NoticeType.NoticeMid)-- "所需道具数量不足", 
        return
    end

    SL:SendLuaNetMsg(LuaMessageIdToSever.EQUIP_FASHION, { cfgIds = self.selectCfgIds })
    self:BtnCloseOnClick()
end

function this:BtnCloseOnClick()
    GUI:UIPanel_Close("dev/outui/AppearGroup/Panel/KLAppearCost/KLAppearCostPanel")
end

function this:Close()
end

return this
