---@class KLEquipBagPanel:UIKmlLuaPanelBase
---@field view KLEquipBagPanelView
local KLEquipBagPanel = class(UIKmlLuaPanelBase)
local this = KLEquipBagPanel
---创建时调用一次
function this:Init()
    self:InitData(self.args)
    local bag_info = string.split(SL:GetConfig("cfg_global", 6).value, '#')
    self.maxHor = tonumber(bag_info[1]) + 20
    self.maxVet = tonumber(bag_info[2])

    EquipFunc:ReplaceEquipBagButton({ self.view.person_shop_btn, self.view.storage_btn, self.view.recycle_btn, self.view.tidy_btn })

    local x = self.x
    local y = self.y
    GUI:setPosition(self.view.root, x, y)
    ---@param win KLUIBagTileScrollViewItem
    GUI:UIPanel_Open("dev/ui/Common/Item/KLUIBagTileScrollView/KLUIBagTileScrollViewItem", self.view.root, self,
            {
                itemList = self.args.itemList,
                id = self.args.bagType,
                --forbidCount = SL:GetMetaValue("BAG_FORBID_COUNT"),
                hor = self.maxHor,
                vet = self.maxVet,
                canDrag = false,
                forbidClickCallback = self.forbidClick,
                itemClick = self.args and self.args.itemClickCallBack,
                selectList = self.args and self.args.selectList,
                callBackUI = self.args and self.args.callBackUI
            }, true, function(win)
                self.bagTileScrollView = win
                ---打开界面会刷新道具，此处注释
                --if self.args and self.args.itemList then
                --    self.bagTileScrollView:RefreshItemByItem(self.args.itemList)
                --end
            end)
end

---初始化数据
function this:InitData(data)
    self.x = (data and data.x) or 0
    self.y = (data and data.y) or 0
    self.bagType = (data and data.bagType) or EBagShowType.EquipTransfer
end

---创建或者刷新界面数据时调用
function this:Refresh()
    self.bagType = (self.args and self.args.bagType) or EBagShowType.EquipTransfer
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.closeBtn, self, self.CloseSelf)
    GUI:AddOnClickEvent(self.view.person_shop_btn, self, self.personBtn)
    GUI:AddOnClickEvent(self.view.storage_btn, self, self.personBtn)
    GUI:AddOnClickEvent(self.view.recycle_btn, self, self.personBtn)
    GUI:AddOnClickEvent(self.view.tidy_btn, self, self.personBtn)
end

function this:personBtn()
    SL:MessageTip({id=502})
end

function this:RefreshBagItemShow(itemList)
    self.bagTileScrollView:RefreshItemByItem(itemList)
end

function this:CloseSelf()
    self.args.callBackUI:CloseSelf()
    --GUI:UIPanel_Close("dev/ui/Bag/Panel/KLEquipBag/KLEquipBagPanel")
    --GUI:UIPanel_Close("dev/ui/Equip/Panel/KLUIEquipTransfer/KLUIEquipTransferPanel")
    --GUI:UIPanel_Close("dev/ui/UIForgeGroup/Panel/KLUIForgeGroup/KLUIForgeGroupPanel")
end

function this:Close()
end

return this
