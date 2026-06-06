---@class KLFastItem:UIKmlLuaPanelBase
---@field view KLFastItemView
local KLFastItem = class(UIKmlLuaPanelBase)
local this = KLFastItem
---创建时调用一次
function this:Init()
    GUI:SetZIndex(self.view.add_img_0, 210)
end

---创建或者刷新界面数据时调用
function this:RefreshItem(args)
    self.args = args
    self.cdTime = 0
    ---@type number[]
    local fastItems = SL:GetMetaValue(EMetaVarGetKey.FAST_ITEM_ID_LIST)

    if self.args.itemIndex == 1 then
        if SL:HasConfig("cfg_item", fastItems[1]) then
            local ownerCount = SL:GetBagItemCount(fastItems[1])
            if ownerCount <= 0 then
                self.args.cfgId = InfoManager.mainUIInfo.mpShowModeItemId
            end
        else
            self.args.cfgId = InfoManager.mainUIInfo.mpShowModeItemId
        end
    end

    if self.args.itemIndex == 2 then
        if SL:HasConfig("cfg_item", fastItems[2]) then
            local ownerCount = SL:GetBagItemCount(fastItems[2])
            if ownerCount <= 0 then
                self.args.cfgId = InfoManager.mainUIInfo.hpShowModeItemId
            end
        else
            self.args.cfgId = InfoManager.mainUIInfo.hpShowModeItemId
        end
    end

    if self.args.cfgId ~= 0 and fastItems[self.args.itemIndex] == self.args.cfgId then
        ---@type cfg_item_column
        local tbl = SL:GetConfig("cfg_item", self.args.cfgId)
        if tbl and #tbl.coolingTime > 0 then
            self.cdTime = tbl.coolingTime[1] / 1000
            self.cdTime = math.max(self.cdTime, tbl.coolingTime[1] / 1000)
        end
        for i, useCdGroupData in ipairs(tbl.useCdGroup) do
            if useCdGroupData[1] == tbl.Group then
                self.cdTime = math.max(self.cdTime, useCdGroupData[2] / 1000)
            end
        end
    end
    if self.args.cfgId ~= 0 and (fastItems[self.args.itemIndex] == self.args.cfgId or self.args.itemIndex == 5) then
        self.args.count = SL:GetBagItemCount(self.args.cfgId)
    else
        self.args.count = 0
    end

    if self.args.cfgId ~= 0 and self.args.count == 0 and fastItems[self.args.itemIndex] == self.args.cfgId then
        self.args.cfdId = 0
        SL:SetMetaValue(EMetaVarGetKey.FAST_ITEM_ID_LIST, self.args.itemIndex, 0, 0)
    end
    if self.anim then
        GUI:DOKill(self.anim)
        self.anim = nil
    end
    if self.args.cfdId == 0 or self.args.count == 0 then
        if self.args.cfgId > 0 and self.args.count == 0 then
            GUI:setVisible(self.view.add_img_0, true)
            GUI:setColor(self.view.light1, "#FFFFFFFF")
            self.anim = GUI:DOAlphaImage(self.view.light1, 0, 1)
            GUI:TweenSetLoops(self.anim, -1)
            GUI:TweenSetEase(self.anim, ELeanTweenType.pingPong)

        else
            GUI:setVisible(self.view.add_img_0, false)
        end

        GUI:SetCirclebar_startper(self.view.control_circlebar, 0)
        if self.args.cfgId ~= 0 and fastItems[self.args.itemIndex] ~= self.args.cfgId then
            GUI:Item_setItemId(self.view.shortcut_item, self.args.cfgId)
            GUI:Item_UpdataData(self.view.shortcut_item, { itemcount = 0 })
        end
        GUI:setVisible(self.view.shortcut_item,
            self.args.cfgId ~= 0 and fastItems[self.args.itemIndex] ~= self.args.cfgId)
        --GUI:SetZIndex(self.view.count_attach,201)
        local isShowNoItem = false

        if self.args.itemIndex <= 2 then
            if SL:HasConfig("cfg_item", fastItems[2]) then
                local ownerCount = SL:GetBagItemCount(fastItems[2])
                if ownerCount <= 0 then
                    isShowNoItem = true
                end
            else
                isShowNoItem = true
            end
        end

        if self.args.itemIndex == 1 then
            if not isShowNoItem then
                if SL:HasConfig("cfg_item", fastItems[1]) then
                    local ownerCount = SL:GetBagItemCount(fastItems[1])
                    if ownerCount <= 0 then
                        isShowNoItem = true
                    end
                else
                    isShowNoItem = true
                end
            else
                isShowNoItem = false
            end
        end
        GUI:SetZIndex(self.view.noItem, 0)
        GUI:setVisible(self.view.noItem, self.args.cfgId ~= 0 and fastItems[self.args.itemIndex] ~= self.args.cfgId)
        GUI:setVisible(self.view.fastItemTip,
            self.args.cfgId ~= 0 and fastItems[self.args.itemIndex] ~= self.args.cfgId and isShowNoItem)
        GUI:SetCirclebar_endper(self.view.control_circlebar, 0)
        if self.args.cfgId ~= 0 and fastItems[self.args.itemIndex] ~= self.args.cfgId and isShowNoItem then
            SL:onLUAEvent(LUA_EVENT_BUBBLETIPS_POSY, { posY = 40 })
        end
    else
        GUI:setVisible(self.view.shortcut_item, true)
        GUI:setVisible(self.view.add_img_0, false)
        GUI:Item_setItemId(self.view.shortcut_item, self.args.cfgId)
        GUI:Item_UpdataData(self.view.shortcut_item, { itemcount = self.args.count })
        GUI:setVisible(self.view.noItem, false)
    end

    if fastItems[1] > 0 and fastItems[2] > 0 then
        SL:onLUAEvent(LUA_EVENT_BUBBLETIPS_POSY, { posY = 0 })
    end
end

---注册UI事件和服务器消息
function this:RegistEvents()
    --SL:RegisterLuaNetMsg(MessageDef.ResBagChangeMessage, self.ResBagChangeMessage,self)
    SL:RegisterLUAEvent(LUA_EVENT_FASTITEM_CHANGE, self.BagChange, self)   --背包改变事件
    SL:RegisterLUAEvent(LUA_EVENT_USE_ITEM_AFTER, self.UseItemAfter, self) --道具使用事件
    GUI:AddOnClickEvent(self.view.useBtn, self, self.BtnUseClick)
    GUI:AddOnClickEvent(self.view.btnTips, self, self.BtnTipsClick)
end

function this:BtnTipsClick()
    self:PillNoEnough()
end

function this:BagChange(id, itemList)
    ---@type number[]
    local fastItems = SL:GetMetaValue(EMetaVarGetKey.FAST_ITEM_ID_LIST)
    -- if self.args.itemIndex == 1 then
    --     self.args.cfgId = fastItems[1]
    -- end

    -- if self.args.itemIndex == 2 then
    --     self.args.cfgId = fastItems[2]
    -- end

    if self.args.itemIndex == 1 then
        if SL:HasConfig("cfg_item", fastItems[1]) then
            local ownerCount = SL:GetBagItemCount(fastItems[1])
            if ownerCount <= 0 then
                self.args.cfgId = InfoManager.mainUIInfo.mpShowModeItemId
            end
        else
            self.args.cfgId = InfoManager.mainUIInfo.mpShowModeItemId
        end
    end

    if self.args.itemIndex == 2 then
        if SL:HasConfig("cfg_item", fastItems[2]) then
            local ownerCount = SL:GetBagItemCount(fastItems[2])
            if ownerCount <= 0 then
                self.args.cfgId = InfoManager.mainUIInfo.hpShowModeItemId
            end
        else
            self.args.cfgId = InfoManager.mainUIInfo.hpShowModeItemId
        end
    end
    if fastItems[1] > 0 and fastItems[2] > 0 then
        SL:onLUAEvent(LUA_EVENT_BUBBLETIPS_POSY, { posY = 0 })
    end
    local count = 0
    if self.args.cfgId ~= 0 then
        count = SL:GetBagItemCount(self.args.cfgId)
    end
    if count == self.args.count then
        return
    end
    self.args.count = count
    self:RefreshItem(self.args)
end

function this:Close()
    if self.anim then
        GUI:DOKill(self.anim)
        self.anim = nil
    end
    if self.timer1 then
        SL:UnSchedule(self.timer1)
        self.timer1 = nil
    end

    if self.timer2 then
        SL:UnSchedule(self.timer2)
        self.timer2 = nil
    end
end

function this:UseItemAfter(id, message)
    if self.args.cfgId and self.args.cfgId ~= 0 then
        local tbl1 = SL:GetConfig("cfg_item", message.cfgId)
        if tbl1.type ~= 3 then
            return
        end

        local tbl2 = SL:GetConfig("cfg_item", self.args.cfgId)
        local is_one_froup = false
        if tbl1.useCdGroup and tbl1.useCdGroup[1] and tbl1.useCdGroup[1][1] and tbl2.useCdGroup and tbl2.useCdGroup[1] and tbl2.useCdGroup[1][1] and tbl1.useCdGroup[1][1] == tbl2.useCdGroup[1][1] then
            is_one_froup = true
        end
        if self.args.cfgId == message.cfgId or is_one_froup then
            self.use_time = os.time()
            GUI:SetCirclebar_startper(self.view.control_circlebar, 100)
            GUI:SetCirclebar_endper(self.view.control_circlebar, 0)
            GUI:SetCirclebar_time(self.view.control_circlebar, self.cdTime)
        end
    end
end

function this:BtnUseClick()
    if not self.use_time then
    else
        if self.cdTime > 0 and self.use_time + self.cdTime > os.time() then
            return
        end
    end
    if self.args.itemIndex == 5 then
        if self.args.cfgId ~= 0 then
            local equip = SL:GetMetaValue("BAG_DATA")[1]
            for _, item in pairs(equip) do
                if item.cfgId == self.args.cfgId then
                    SL:PutOnEquip(item)
                    return
                end
            end
        end
        if SL:GetConfig("cfg_string", 66001) then
            SL:TipMessage(SL:GetConfig("cfg_string", 66001).text, 1, NoticeType.NoticeMid)
        end
        return
    end
    ---@type number[]
    local fastItems = SL:GetMetaValue(EMetaVarGetKey.FAST_ITEM_ID_LIST)
    local count = SL:GetBagItemCount(self.args.cfgId)
    if self.args.cfgId == 0 or count == 0 then
        if (self.args.itemIndex == 1 or self.args.itemIndex == 2) and fastItems[self.args.itemIndex] ~= self.args.cfgId then
            self:PillNoEnough()
        else
            for _, v in pairs(EMainUIBottomFuncType) do
                local tbl = SL:GetConfig("cfg_MainPanelUI", v, "id")
                GUI:UIPanel_Close(tbl.command)
                SL:onLUAEvent(LUA_EVENT_CLOSEWIN, tbl.systemId)
            end
            SL.HideMainPanel()
            GUI:UIPanel_Open("dev/ui/Skill/Panel/KLUISkillSetting/KLUISkillSettingPanel", nil, nil,
                { settingType = ESkillSettingType.FastItem })
        end
    elseif fastItems[self.args.itemIndex] == self.args.cfgId then
        local index = SL:GetSlotBaseOnCfgId(self.args.cfgId)
        self:UseItem(index, 1)
    end
end

function this:PillNoEnough()
    if PrivilegeCardManager.iswithStore() then
        SL:HideAllKmlPanel()
        self:OpenShop()
    else
        SL:OpenCommonTipPanelById(2)
        --[[        SL:CommonTipsMessage({ stringTblID = 226, ui = self, sureBtnText = "取消", cancelBtnText = "传送", cancelCallBack = self.TransferToNpcShop,
                               cancelBtnImageData = { src = "button_interface_window7", atlas = "Atlas/Common.spriteatlas" },
                               cancelBtnColor = "#FFFFFF"})]]
        --[[        SL:CommonTipsMessage({ stringTblID = 226, ui = self, sureBtnText = "随身买药", cancelBtnText = "传送", cancelCallBack = self.TransferToNpcShop,
                               callback = self.OpenFirsh, littleTipsTextTable = { text = "<color='#FFFF00'>激活白银特权卡</color>", x = 100, y = -60 } ,
                               sureBtnImageData = { src = "button_interface_window6", atlas = "Atlas/Common.spriteatlas" }, cancelBtnImageData = { src = "button_interface_window7", atlas = "Atlas/Common.spriteatlas" },
                               cancelBtnColor = "#FFFFFF"})]]
    end
end

function this:OpenShop()
    GUI:UIPanel_Close("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel")
    if GUI:GetUI("dev/ui/Bag/Panel/KLDepots/KLDepotsPanel") then
        GUI:UIPanel_Close("dev/ui/Bag/Panel/KLDepots/KLDepotsPanel")
    end
    local shop_id = SL:GetMetaValue("GET_NPC_SHOPID", 100101)
    SL:OpenNPCShop(shop_id)
end

--- 传送到NPC商店（NPC商店功能）
function this:TransferToNpcShop()
    local mapInfo = SL:GetConfig("cfg_map_info", SL:GetMetaValue("MAP_ID"), "id")
    if mapInfo.nopositionmove == 1 then
        SL:MessageTip({ id = 116 })
        return
    end
    --

    if self.timer1 then
        SL:UnSchedule(self.timer1)
        self.timer1 = nil
    end

    if self.timer2 then
        SL:UnSchedule(self.timer2)
        self.timer2 = nil
    end

    local levelCondition = false
    local CostCondition = false
    local npcList = SL:GetConfig("cfg_npclist", 100101)
    local map_info = SL:GetConfig("cfg_map_info", npcList.mapId)
    local mapMove_info = SL:GetConfigMultiKeys("cfg_mapMove", npcList.mapId, "mapID")
    local mapId = SL:GetMetaValue(EMetaVarGetKey.MAP_ID)
    levelCondition = mapMove_info.level <= SL:MeData_GetLevel()
    self.cost = map_info.transferCost
    if self.cost and self.cost[1] and self.cost[1][2] then
        CostCondition = self.cost[1][2] * InfoManager.redNameInfo:GetMapTransmissionCost() <=
            SL:GetBagItemCount(self.cost[1][1])
        if mapId == npcList.mapId then
            CostCondition = true
        end
    end
    if levelCondition and CostCondition then
        local ShortcutMgr = SL:Get_G()['ShortcutMgr']
        ShortcutMgr.RunToNpc(100101, function()
            local SceneTouch = SL:Get_G()['SceneTouch']
            local mapId_ = SL:GetMetaValue(EMetaVarGetKey.MAP_ID)
            if mapId_ == npcList.mapId then
                SceneTouch.ClickNpc(100101)
                local EventManager = SL:Get_G()['EventManager']
                EventManager.Dispatch(Event.UIShow_MePathMoveStop)
                SL:onLUAEvent(LUA_EVENT_UI_SHOW_ME_PATH_STOP)
            end
        end)
        --[[        self.timer1 = SL:ScheduleOnce(0.5, function()

            --SL:SendTransferToNpcMessage(100101, true,true)
        end)]]
        --[[        self.timer2 = SL:ScheduleOnce(2, function()
            if not GUI:GetUI("dev/ui/NPC/Panel/KLNPCShop/KLNPCShopPanel") then
                SL:OpenNPCShop(1)
            end
        end)]]
    else
        SL:TipMessage("传送条件不满足", 1, NoticeType.NoticeMid)
    end

    GUI:UIPanel_Close("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel")
end

function this:OpenFirsh()
    GUI:UIPanel_Close("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel")
    if GUI:GetUI("dev/ui/Bag/Panel/KLDepots/KLDepotsPanel") then
        GUI:UIPanel_Close("dev/ui/Bag/Panel/KLDepots/KLDepotsPanel")
    end
    GUI:UIPanel_Open("dev/outui/ShopMain/Panel/KLShopMain/KLShopMainPanel", nil, nil, { 2 })
end

function this:UseItem(index, count, notice)
    SL:ReqUseItemMessage(index, count, notice)
end

return this
