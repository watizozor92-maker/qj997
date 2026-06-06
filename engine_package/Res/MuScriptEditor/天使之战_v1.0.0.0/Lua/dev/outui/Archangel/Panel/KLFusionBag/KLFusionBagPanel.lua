---@class KLFusionBagPanel:UIKmlLuaPanelBase
---@field view KLFusionBagPanelView
local KLFusionBagPanel = class(UIKmlLuaPanelBase)
local this = KLFusionBagPanel
function this:AsyncLoadUI()
end

---创建时调用一次
function this:Init()
    self:InitData(self.args)
    local bag_info = string.split(SL:GetConfig("cfg_global", 6).value, '#')
    self.maxHor = tonumber(bag_info[1]) + 20
    self.maxVet = tonumber(bag_info[2])

    GUI:UIPanel_Open("dev/ui/Common/Item/KLUIBagTileScrollView/KLUIBagTileScrollViewItem", self.view.root, self,
            {
                hor = self.maxHor,
                vet = self.maxVet,
                canDrag = false,
                forbidClickCallback = self.forbidClick,
                itemClick = self.args and self.args.itemClick,
                selectList = self.args and self.args.selectList,
                callBackUI = self.args and self.args.callBackUI,
                isShowEffect = true
            }, false, function(bagTileScrollView)
                ---@type KLUIBagTileScrollViewItem
                self.bagTileScrollView = bagTileScrollView
                if self.itemList then
                    self.bagTileScrollView:RefreshItemByItem(self.itemList)
                    self.itemList = nil
                end

            end)
end

---初始化数据
function this:InitData(data)
    self.x = (data and data.x) or 0
    self.y = (data and data.y) or 0
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.closeBtn, self, self.ClosePanel)

    GUI:AddOnClickEvent(self.view.person_shop_btn, self, self.personBtn)
    GUI:AddOnClickEvent(self.view.storage_btn, self, self.personBtn)
    GUI:AddOnClickEvent(self.view.recycle_btn, self, self.personBtn)
    GUI:AddOnClickEvent(self.view.tidy_btn, self, self.personBtn)
end

---界面显示时调用一次
function this:Show()
end

---创建或者刷新界面数据时调用
function this:Refresh()
    local x = self.x
    local y = self.y
    GUI:setPosition(self.view.root, x, y)
end

function this:RefreshItem(itemlist,callBackUI,callBack)
    if self.bagTileScrollView and itemlist then
        itemlist = self:SortItemList(itemlist)
        self.bagTileScrollView:RefreshItemByItem(itemlist, callBack, callBackUI)
        self.itemList = nil
    else
        self.itemList = self:SortItemList(itemlist)
    end
end

function this:RefreshGrailSelect(itemList)
    self.bagTileScrollView:RefreshSelect(itemList)
end

function this:personBtn()
    SL:TipMessage(SL:GetConfig('cfg_string', 286).text, 1, NoticeType.NoticeLeftBottom)   --"锻造中无法使用",
end

function this:Hide()
end

function this:ClosePanel()
    self.args.callBackUI:ClosePanel()
end

function this:Close()
end

---@param itemList CommonProtos.Item[]
---@return CommonProtos.Item[]
function this:SortItemList(itemList)
    local bag_str = SL:GetConfig("cfg_global", 6).value
    local bag_tbl = string.split(bag_str, '#')
    local bag_hor = tonumber(bag_tbl[1])
    local bag_vet = tonumber(bag_tbl[2])
    local use_cell_dict = {}
    local sortItemList = {}
    local cfg_id, now_hor, now_vet, is_put, hold_vet, hole_hor, item, now_hold_hor, now_judge_hor, now_hold_vet, now_judge_vet, now_cell_index
    local max_hor = bag_hor + 20
    for _, v in pairs(itemList) do
        cfg_id = v.cfgId
        now_hor = 1
        while now_hor <= max_hor do
            now_vet = 1
            while now_vet <= bag_vet do
                is_put = true
                ---@type cfg_item_column
                item = SL:GetConfig("cfg_item", cfg_id)
                hold_vet = item.holdGrid[1]
                hole_hor = item.holdGrid[2]
                now_hold_hor = 0
                while now_hold_hor < hole_hor do
                    now_judge_hor = now_hor + now_hold_hor
                    now_hold_vet = 0
                    while now_hold_vet < hold_vet do
                        now_judge_vet = now_vet + now_hold_vet
                        now_cell_index = now_judge_hor * 100 + now_judge_vet
                        if use_cell_dict[now_cell_index] or now_judge_vet > bag_vet then
                            is_put = false
                            break
                        end
                        now_hold_vet = now_hold_vet + 1
                    end
                    if not is_put then
                        break
                    end
                    now_hold_hor = now_hold_hor + 1
                end
                if is_put then
                    break
                end
                now_vet = now_vet + 1
            end
            if is_put then
                break
            end
            now_hor = now_hor + 1
        end

        local now_index = now_hor * 100 + now_vet
        sortItemList[now_index] = v

        now_hold_hor = 0
        while now_hold_hor < hole_hor do
            now_hold_vet = 0
            local now_hold_judge_hor = now_hor + now_hold_hor
            while now_hold_vet < hold_vet do
                local now_hold_judge_vet = now_vet + now_hold_vet
                now_cell_index = now_hold_judge_hor * 100 + now_hold_judge_vet
                use_cell_dict[now_cell_index] = true
                now_hold_vet = now_hold_vet + 1
            end
            now_hold_hor = now_hold_hor + 1
        end
    end
    return sortItemList
end

return this
