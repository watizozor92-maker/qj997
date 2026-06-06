---@class KLGemSlateBagPanel:UIKmlLuaPanelBase
---@field view KLGemSlateBagPanelView
local KLGemSlateBagPanel = class(UIKmlLuaPanelBase)
local this =KLGemSlateBagPanel
function this:AsyncLoadUI()
        end
---创建时调用一次
function this:Init()
    self:InitData(self.args)
    local bag_info = string.split(SL:GetConfig("cfg_global",6).value,'#')
    self.maxHor = tonumber(bag_info[1])
    self.maxVet = tonumber(bag_info[2])

    ---@type KLUIBagTileScrollViewItem
    ---@param bagTileScrollView KLUIBagTileScrollViewItem
    GUI:UIPanel_Open("dev/ui/Common/Item/KLUIBagTileScrollView/KLUIBagTileScrollViewItem", self.view.root,self,
        {
            itemList=self.args.itemList,
            id=E_BagTileScrollViewType.GemInLay,
            hor = tonumber(bag_info[1]),
            vet = tonumber(bag_info[2]),
            canDrag = false,
            itemClick = (self.args and self.args.itemClickCallBack),
            callBackUI = self.args.callBackUI},
            true,
            function(bagTileScrollView)
                self.bagTileScrollView = bagTileScrollView
            end)
        
end

function this:InitData(data)
    self.x=(data and data.x)or 0
    self.y=(data and data.y)or 0
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.closeBtn, self, self.closeBtn)
    GUI:AddOnClickEvent(self.view.decomposeGem_Btn, self, self.OnClickDecomposeGem_Btn)
    GUI:AddOnClickEvent(self.view.combineGem_Btn, self, self.OnClickCombineGem_Btn)
    GUI:AddOnClickEvent(self.view.combineSlate_Btn, self, self.OnClickCombineSlate_Btn)
    --SL:RegisterLUAEvent(Event.BagInfo_Change, self.BagInfo_Change, self)
    SL:RegisterLUAEvent(LUA_EVENT_REFRESH_GEM_SLATE_INFO, self.BagInfo_Change, self)
    
end
---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
    local x = self.x
    local y = self.y

    self.bagType=self.args and self.args.bagType or nil
    if self.bagType==E_GemInlayType.Slate then
        GUI:SetActive(self.view.combineSlate_Btn,true)
        GUI:SetActive(self.view.combineGem_Btn,false)
    else
        GUI:SetActive(self.view.combineSlate_Btn,false)
        GUI:SetActive(self.view.combineGem_Btn,true)
    end
    GUI:setPosition(self.view.root, x, y)
end

function this:Close()

end

function this:closeBtn()
    GUI:UIPanel_Close("dev/ui/UIForgeGroup/Panel/KLUIForgeGroup/KLUIForgeGroupPanel")
	GUI:UIPanel_Close("dev/outui/Bag/Panel/KLGemSlateBag/KLGemSlateBagPanel")
	GUI:UIPanel_Close("dev/outui/Equip/Panel/KLGemInlay/KLGemInlayPanel")
end

---@param eventData {index:number,item:CommonProtos.Item}[]
function this:BagInfo_Change(eventId, eventData)
    local itemList={}
    if self.bagType==E_GemInlayType.Gem then
        itemList=self:GetGemItems()
    elseif self.bagType==E_GemInlayType.Slate then
        itemList=self:GetSlateItems()
    end
    self.bagTileScrollView:RefreshItemByItem(itemList)
    
end
    

function this:GetSlateItems()
    local data = {}
    local bagItemTabl = SL:GetMetaValue("BAG_DATA")[1]

    if bagItemTabl then
        for _, v in pairs(bagItemTabl) do
            if SL:HasConfig("cfg_equip_stoneBoard", v.cfgId, "id") then
                table.insert(data, v)
            end
        end
    end
    return SL.Bag:SortItemList(data) 
end

function this:GetGemItems()
    local data = {}
    local bagItemTabl = SL:GetMetaValue("BAG_DATA")[1]

    if bagItemTabl then
        for _, v in pairs(bagItemTabl) do
            if SL:HasConfig("cfg_equip_gem", v.cfgId, "id") then
                table.insert(data, v)
            end
        end
    end
    return SL.Bag:SortItemList(data) 
end

function this:OnClickDecomposeGem_Btn()
    ---@type KLUIForgeGroupPanel
    local tmpUI=GUI:GetUI("dev/ui/UIForgeGroup/Panel/KLUIForgeGroup/KLUIForgeGroupPanel")
    if tmpUI then
        GUI:Toggle_setIsOn(tmpUI.view.decomposeToggle,true)
    end
end

function this:OnClickCombineGem_Btn()
    GUI:UIPanel_Close("dev/ui/UIForgeGroup/Panel/KLUIForgeGroup/KLUIForgeGroupPanel")
    GUI:UIPanel_Close("dev/outui/Bag/Panel/KLGemSlateBag/KLGemSlateBagPanel")
	GUI:UIPanel_Close("dev/outui/Equip/Panel/KLGemInlay/KLGemInlayPanel")

    GUI:UIPanel_Open("dev/outui/UISynthesis/Panel/KLUISynthesis/KLUISynthesisPanel",nil,nil,{})
end

function this:OnClickCombineSlate_Btn()
    GUI:UIPanel_Close("dev/ui/UIForgeGroup/Panel/KLUIForgeGroup/KLUIForgeGroupPanel")
    GUI:UIPanel_Close("dev/outui/Bag/Panel/KLGemSlateBag/KLGemSlateBagPanel")
	GUI:UIPanel_Close("dev/outui/Equip/Panel/KLGemInlay/KLGemInlayPanel")

    GUI:UIPanel_Open("dev/outui/UISynthesis/Panel/KLUISynthesis/KLUISynthesisPanel",nil,nil,{})
end

return this
