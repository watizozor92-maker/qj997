---@class KLSkillBagPanel:UIKmlLuaPanelBase
---@field view KLSkillBagPanelView
local KLSkillBagPanel = class(UIKmlLuaPanelBase)
local this = KLSkillBagPanel
---创建时调用一次
function this:Init()
    local bag_info = string.split(SL:GetConfig("cfg_global", 6).value, '#')
    self.maxHor = tonumber(bag_info[1])
    self.maxVet = tonumber(bag_info[2])
    local itemList_ = SL:GetIsFastItemList()
    local _itemList = SL.Bag:SortItemList(itemList_)
    ---@type KLUIBagTileScrollViewItem
    self.bagTileScrollView = GUI:UIPanel_Open("dev/ui/Common/Item/KLUIBagTileScrollView/KLUIBagTileScrollViewItem", self.view.bgGridRoot, self,
            {
                itemList = _itemList,
                id = EBagTileScrollViewId.Bag,
                hor = self.maxHor,
                vet = self.maxVet,
                canDrag = false,
                forbidClickCallback = self.forbidClick,
                itemClick = self.ClickItemCallBack,
                x=-3,
                y=53,
                contentScale = 1.32,
                callBackUI = self
            },true,function(bagTileScrollView)
                self.bagTileScrollView = bagTileScrollView
                GUI:setContentSize(self.bagTileScrollView.view.BagTileScrollViewPrefab, 360, 548)
                GUI:setPosition(self.bagTileScrollView.view.BagTileScrollViewPrefab, 51, -136.8)
                GUI:setContentSize(self.bagTileScrollView.view.prefabBagTileScrollView_, 360, 548)
            end)
    -- self:RefreshFastItemTip()

    -- EquipFunc:ReplaceEquipBagButton({self.view.person_shop_btn,self.view.storage_btn,self.view.recycle_btn,self.view.tidy_btn})

end

---创建或者刷新界面数据时调用
function this:Refresh()
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.closeBtn, self, self.closeBtn)
    SL:RegisterLUAEvent(Event.BagInfo_Change, self.BagInfo_Change, self)
    -- GUI:AddOnClickEvent(self.view.btn_fix, self, self.storage_btn)
    -- GUI:AddOnClickEvent(self.view.recycle_btn, self, self.recycle_btn)
    -- GUI:AddOnClickEvent(self.view.tidy_btn, self, self.tidy_btn)
    -- GUI:AddOnClickEvent(self.view.person_shop_btn, self, self.person_shop_btn)
    GUI:AddOnClickEvent(self.view.btn_storage, self, self.storage_btn)
    GUI:AddOnClickEvent(self.view.btn_sell, self, self.recycle_btn)
    GUI:AddOnClickEvent(self.view.btn_arrange, self, self.tidy_btn)
    GUI:AddOnClickEvent(self.view.btn_fix, self, self.FixEquipClick)
    SL:RegisterLUAEvent(LUA_EVENT_BAG_UNLOCK, self.LUA_EVENT_BAG_UNLOCK, self)
end

function this:LUA_EVENT_BAG_UNLOCK(_, count)
    self.bagTileScrollView:RefreshForbidGrid(count)
end

-- function this:person_shop_btn()
--     if PrivilegeCardManager.iswithStore() then
--         self:OpenShop()
--     else
--         SL:CommonTipsMessage({ stringTblID = 226, ui = self, sureBtnText = "随身买药", cancelBtnText = "传送", cancelCallBack = self.TransferToNpcShop,
--                                callback = self.OpenFirsh, littleTipsTextTable = { text = "<color='#FFFF00'>激活白银特权卡</color>", x = 100, y = -60 },
--                                sureBtnImageData = { src = "button_interface_window6", atlas = "Atlas/Common.spriteatlas" }, cancelBtnImageData = { src = "button_interface_window7", atlas = "Atlas/Common.spriteatlas" },
--                                cancelBtnColor = "#FFFFFF" })
--     end
-- end

function this:FixEquipClick()
    
end

function this:tidy_btn()
    GUI:UIPanel_Close("dev/ui/Common/Item/KLUIBagTileScrollView/KLUIBagTileScrollViewItem")
    self:Init()
end

function this:storage_btn()
    if PrivilegeCardManager.iswithWarehouse() then
        self:OpenStorage()
    else
        SL:CommonTipsMessage({ stringTblID = 227, ui = self, sureBtnText = "随身仓库", cancelBtnText = "传送", cancelCallBack = self.TransferToNpcStorage,
                               callback = self.OpenFirsh, littleTipsTextTable = { text = "<color='#FFFF00'>激活钻石特权卡</color>", x = 100, y = -60 },
                               sureBtnImageData = { src = "button_interface_window6", atlas = "Atlas/Common.spriteatlas" }, cancelBtnImageData = { src = "button_interface_window7", atlas = "Atlas/Common.spriteatlas" },
                               cancelBtnColor = "#FFFFFF" })
    end
end

function this:recycle_btn()
    self:CloseSkillPanel()

    GUI:UIPanel_Open("dev/ui/Recover/Panel/KLRecover/KLRecoverPanel")
end

function this:BagInfo_Change(_, eventData)
    local is_refresh = false
    for _, v in ipairs(eventData) do
        if v.item then
            local cfgId = v.item.cfgId
            if SL:HasConfig("cfg_item", cfgId) then
                local item = SL:GetConfig("cfg_item", cfgId)
                if item.isFast and item.isFast == 1 then
                    is_refresh = true
                end
            end
        else
            is_refresh = true
        end
    end
    if is_refresh then
        local itemList_ = SL:GetIsFastItemList()
        local _itemList = SL.Bag:SortItemList(itemList_)
        self.bagTileScrollView:RefreshItemByItem(_itemList)
        self.bagTileScrollView:RefreshInfo()
    end
    -- self:RefreshFastItemTip()
end

function this:RefreshFastItemTip()
    local isShow = false
    ---@type number[]
    local fastItems = SL:GetMetaValue(EMetaVarGetKey.FAST_ITEM_ID_LIST)
    if SL:HasConfig("cfg_item", fastItems[1]) then
        local ownerCount = SL:GetBagItemCount(fastItems[1])
        if ownerCount <= 0 then
            isShow = true
        end
    else
        isShow = true
    end

    if SL:HasConfig("cfg_item", fastItems[2]) then
        local ownerCount = SL:GetBagItemCount(fastItems[2])
        if ownerCount <= 0 then
            isShow = true
        end
    else
        isShow = true
    end
    GUI:setVisible(self.view.fastItemTip, isShow)
end

function this:closeBtn()
    self:CloseSkillPanel()
end

function this:Close()
end

function this:forbidClick()
    local bag_unlock_info = SL:GetConfig('cfg_global', 107).value
    local bag_unlock_split = string.split(bag_unlock_info, '#')
    local itemId = tonumber(bag_unlock_split[1])
    local needCount = tonumber(bag_unlock_split[2])
    GUI:UIPanel_Open("dev/ui/Common/Panel/KLCommonItemTips/KLCommonItemTipsPanel", nil, nil,
            {
                showTips = string.format("是否消耗%s扩充背包空间？", "背包石"),
                ui = self,
                cfgId = itemId,
                needCount = needCount,
                callback = self.UnlockGrid,
            })
end

function this:UnlockGrid()
    SL:ReqBagAddCapacityMessage(1)
end

---点击背包item回调
---@param itemData CommonProtos.Item
function this:ClickItemCallBack(_, itemData)
    SL:onLUAEvent(LUA_EVENT_FASTITEM_SET_SELECT, itemData.cfgId)
end

function this:CloseSkillPanel()
    GUI:UIPanel_Close("dev/ui/Bag/Panel/KLSkillBag/KLSkillBagPanel")
    GUI:UIPanel_Close("dev/ui/Skill/Panel/KLUISkillInfo/KLUISkillInfoPanel")
    GUI:UIPanel_Close("dev/ui/Skill/Panel/KLUISkillDescribe/KLUISkillDescribePanel")
    GUI:UIPanel_Close("dev/ui/Skill/Panel/KLUISkillSetting/KLUISkillSettingPanel")
    SL.ShowMainPanel()
end

function this:OpenFirsh()
    this:CloseSkillPanel()
    GUI:UIPanel_Open("dev/outui/ShopMain/Panel/KLShopMain/KLShopMainPanel", nil, nil, { 2 })
end

--- 传送到NPC商店（NPC商店功能）
function this:TransferToNpcShop()
    local mapInfo = SL:GetConfig("cfg_map_info", SL:GetMetaValue("MAP_ID"), "id")
    if mapInfo.nopositionmove == 1 then
        SL:MessageTip({ id = 116 })
        return
    end
    SL:showTransferAnimation()

    SL:ScheduleOnce(0.5, function()
        SL:SendTransferToNpcMessage(100101, true)
    end)
    SL:ScheduleOnce(2, function()

        if not GUI:GetUI("dev/ui/NPC/Panel/KLNPCShop/KLNPCShopPanel") then
            SL:OpenNPCShop(1)
        end

    end)
    GUI:UIPanel_Close("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel")
    this:CloseSkillPanel()
end

function this:OpenShop()
    this:CloseSkillPanel()

    local shop_id = SL:GetMetaValue("GET_NPC_SHOPID", 100101)
    SL:OpenNPCShop(shop_id)
end

--- 传送到NPC仓库
function this:TransferToNpcStorage()
    SL:showTransferAnimation()

    SL:ScheduleOnce(0.5, function()
        -- if SL:GetBattleState() then
        --     SL:TipMessage({ "战斗状态下禁止传送", 1, NoticeType.NoticeMid })
        --     return
        -- end
        SL:SendTransferToNpcMessage(100107, true)
    end)
    GUI:UIPanel_Close("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel")
    this:CloseSkillPanel()
end

function this:OpenStorage()
    this:CloseSkillPanel()
    GUI:UIPanel_Open("dev/ui/Bag/Panel/KLDepots/KLDepotsPanel", nil, nil, { x = -415, y = 0 })
    GUI:UIPanel_Open("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel")
    SL:HideMainPanel()
end

return this
