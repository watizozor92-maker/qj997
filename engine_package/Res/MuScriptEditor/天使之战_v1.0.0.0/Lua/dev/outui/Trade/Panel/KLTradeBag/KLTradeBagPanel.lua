---@class KLTradeBagPanel:UIKmlLuaPanelBase
---@field view KLTradeBagPanelView
local KLTradeBagPanel = class(UIKmlLuaPanelBase)
local this = KLTradeBagPanel
---创建时调用一次
function this:Init()
    self:InitData(self.args)
    local bag_info = string.split(SL:GetConfig("cfg_global", 6).value, '#')
    self.maxHor = tonumber(bag_info[1]) + 20
    self.maxVet = tonumber(bag_info[2])
    --Stall
    if not self.bagTileScrollView then
        GUI:UIPanel_Open("dev/ui/Common/Item/KLUIBagTileScrollView/KLUIBagTileScrollViewItem", self.view.frame, self,
            {
                itemList = self.args.itemList,
                id = EBagShowType.TradeLine,
                forbidCount = 0,
                hor = self.maxHor,
                vet = self.maxVet,
                canDrag = false,
                itemClick = self.args and self.args.itemClick,
                callBackUI = self.args and self.args.callBackUI,
                contentScale = 1.31,
                y=4,
            }, false, function(bagTileScrollView)
                ---@type KLUIBagTileScrollViewItem
                self.bagTileScrollView = bagTileScrollView

                local x = self.x
                local y = self.y

                GUI:setContentSize(self.bagTileScrollView.view.BagTileScrollViewPrefab, 359, 382)
                GUI:setPosition(self.bagTileScrollView.view.BagTileScrollViewPrefab, 3, -7)

                GUI:setContentSize(self.bagTileScrollView.view.prefabBagTileScrollView_, 359, 382)

                GUI:setPosition(self.view.root, x, y)

                if self.args and self.args.itemList then
                    self.bagTileScrollView:RefreshItemByItem(self.args.itemList)
                end
            end)
    end
    if self.timer then
        SL:UnSchedule(self.timer)
    end
    self.timer = SL:ScheduleOnce(0.1,function()  
        GUI:setVisible(self.view.frame,true)
    end)
end

---初始化数据
function this:InitData(data)
    self.x = (data and data.x) or 0
    self.y = (data and data.y) or 0
end

---创建或者刷新界面数据时调用
function this:Refresh()

end

function this:RefreshItem(itemlist)
    if self.bagTileScrollView and itemlist then
        self.bagTileScrollView:RefreshItemByItem(itemlist, function()
            self.bagTileScrollView:RefreshInfo()
        end, self)
    end
end

---注册UI事件和服务器消息
function this:RegistEvents()
    --GUI:AddOnClickEvent(self.view.closeBtn, self, self.ClosePanel)
end

function this:ClosePanel()

end

function this:Close()
    GUI:UIPanel_Close("dev/ui/Common/Item/KLUIBagTileScrollView/KLUIBagTileScrollViewItem")
    if self.timer then
        SL:UnSchedule(self.timer)
    end
end

return this
