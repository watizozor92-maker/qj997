---@class KLOverlayBagPanel:UIKmlLuaPanelBase
---@field view KLOverlayBagPanelView

local KLOverlayBagPanel = class(UIKmlLuaPanelBase)
local this = KLOverlayBagPanel
---创建时调用一次
function this:Init()
    self:InitData(self.args)
    local bag_info = string.split(SL:GetConfig("cfg_global",6).value,'#')
    self.maxHor = tonumber(bag_info[1]) + 20
    self.maxVet = tonumber(bag_info[2])
    EquipFunc:ReplaceEquipBagButton({self.view.person_shop_btn,self.view.storage_btn,self.view.recycle_btn,self.view.tidy_btn})
    
    
    GUI:UIPanel_Open("dev/ui/Common/Item/KLUIBagTileScrollView/KLUIBagTileScrollViewItem", self.view.root,self,
            {
                -- itemList = self.args.itemList,
                id = EBagShowType.EquipAdd,
                --forbidCount = SL:GetMetaValue("BAG_FORBID_COUNT"),
                hor = self.maxHor,
                vet = self.maxVet,
                canDrag = false,
                forbidClickCallback = self.forbidClick,
                itemClick = self.args and  self.args.itemClick,
                selectList = {},
                callBackUI = self.args and self.args.callBackUI
            },false,function(bagTileScrollView)
                ---@type KLUIBagTileScrollViewItem
                self.bagTileScrollView = bagTileScrollView
                self.bagTileScrollView:RefreshItemByItem(self.args.itemList)
            end)
end

---初始化数据
function this:InitData(data)
    self.x = (data and data.x) or 0
    self.y = (data and data.y) or 0
end

---创建或者刷新界面数据时调用
function this:Refresh()
    local x = self.x
    local y = self.y
    GUI:setPosition(self.view.root, x, y)
    if self.args and self.args.itemList then
        
    end
end

function this:RefreshItem(itemlist)
    if itemlist then
        self.bagTileScrollView:RefreshItemByItem(itemlist)
    end
end


---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.closeBtn, self, self.ClosePanel)

    GUI:AddOnClickEvent(self.view.person_shop_btn, self, self.personBtn)
    GUI:AddOnClickEvent(self.view.storage_btn, self, self.personBtn)
    GUI:AddOnClickEvent(self.view.recycle_btn, self, self.personBtn)
    GUI:AddOnClickEvent(self.view.tidy_btn, self, self.personBtn)
end

function this:personBtn()
    SL:MessageTip({id=502})
end

function this:ClosePanel()
    local overlay = GUI:GetUI("dev/outui/Equip/Panel/KLEquipOverlay/KLEquipOverlayPanel")
    if overlay then
        overlay:ClosePanel()
    end
end

function this:Close()

end

return this
