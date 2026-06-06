---@class KLReviveTipPanel:UIKmlLuaPanelBase
---@field view KLReviveTipPanelView
local KLReviveTipPanel = class(UIKmlLuaPanelBase)
local this = KLReviveTipPanel
---创建时调用一次
function this:Init()
    self.leftcfg = {}
    self.rightcfg = {}
    local global = SL:GetConfig("cfg_global", 850002).value
    local split = string.split(global, "|")
    local mapNpc = {}
    for k, v in pairs(split) do
        local split2 = string.split(v, "#")
        local mapId = tonumber(split2[1])
        local npcList = SL:GetConfig("cfg_npclist", tonumber(split2[2]))
        if mapNpc[mapId] == nil then
            mapNpc[mapId] = {}
        end
        table.insert(mapNpc[mapId], npcList)
    end
    self.mapNpc = mapNpc
end

---创建或者刷新界面数据时调用
function this:Refresh()
    --logError("KillerId: "..tostring(InfoManager.uiHookInfo.killerId))
    local mapId = SL:GetMetaValue(EMetaVarGetKey.MAP_ID)
    if self.args then
        if SL:HasConfig("cfg_string", 61001) then
            GUI:Text_setString(self.view.informationText, string.format(SL:GetConfig("cfg_string", 61001).text, self.args.place, self.args.killer))
        else
            GUI:Text_setString(self.view.informationText, "您在<color=#3AB8F1>" .. self.args.place .. "</color>被" .. "<color=#FF0000>" .. self.args.killer .. "</color>" .. "击杀，请选择复活方式。")
        end
        --GUI:Text_setString(self.view.informationText, "您在<color=#3AB8F1>" .. self.args.place .. "</color>被" .. "<color=#FF0000>" .. self.args.killer .. "</color>" .. "击杀")
        if SL:HasConfig("cfg_map_info", self.args.mapId) then

            ---@type cfg_map_info_column
            local mapcfg = SL:GetConfig("cfg_map_info", self.args.mapId)

            ---@type cfg_revive_column
            self.leftcfg = SL:GetConfig("cfg_revive", mapcfg.rebirthType[1])

            ---@type cfg_revive_column
            self.rightcfg = SL:GetConfig("cfg_revive", mapcfg.rebirthType[2])
            
            GUI:Button_setTitleText(self.view.RightBtn,self.rightcfg.name)
            self.countDownTimer = tonumber(SL:GetConfig("cfg_global", 116).value)

            if self.countDown then
                SL:UnSchedule(self.countDown)
                self.countDown = nil
            end
            self.countDown = SL:Schedule(self.countDown,0,1,self.countDownTimer + 1,function()
                self:CountDownText()
            end)
        end
        if InfoManager.skillInfo.killMeMonsterId ~= nil then
            self.monsterId = InfoManager.skillInfo.killMeMonsterId
            self:CheckBtnsShowState(InfoManager.skillInfo.killMeMonsterId)
            InfoManager.skillInfo:ResetKillMeMonsterId()
        else
            GUI:setVisible(self.view.txt_titleMed, false)
            GUI:setVisible(self.view.layout_med, false)
            GUI:setVisible(self.view.txt_titleDef, false)
            GUI:setVisible(self.view.txt_defence, false)
            GUI:setVisible(self.view.layout_def, false)
            GUI:setVisible(self.view.layout_damage, false)
            --GUI:setContentSize(self.view.KLReviveTip_Panel, 450, 220)
            GUI:setContentSize(self.view.bg_mid, 530, 90)
        end
    end
    
    GUI:SetActive(self.view.RightBtn,false)
    --GUI:setPosition(self.view.LeftBtn,0,-64)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.LeftBtn, self, self.OnClickLeftBtn)
    GUI:AddOnClickEvent(self.view.RightBtn, self, self.OnClickRightBtn)
    SL:RegisterLUAEvent(LUA_EVENT_ME_RELIVE, self.ResReliveMessage, self)
    GUI:AddOnClickEvent(self.view.btn_med, self, self.BtnClickCallBack, 0)
    GUI:AddOnClickEvent(self.view.btn_duanzao, self, self.BtnClickCallBack, 1)
    GUI:AddOnClickEvent(self.view.btn_buff1, self, self.BtnClickCallBack, 2)
    GUI:AddOnClickEvent(self.view.btn_buff2, self, self.BtnClickCallBack, 3)
    GUI:AddOnClickEvent(self.view.btn_guard, self, self.BtnClickCallBack, 5)
    GUI:AddOnClickEvent(self.view.btn_wing, self, self.BtnClickCallBack, 4)
end

function this:OpenShop()
    GUI:UIPanel_Close("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel")
    if GUI:GetUI("dev/ui/Bag/Panel/KLDepots/KLDepotsPanel") then
        GUI:UIPanel_Close("dev/ui/Bag/Panel/KLDepots/KLDepotsPanel")
    end
    local shop_id = SL:GetMetaValue("GET_NPC_SHOPID", 100101)
    SL:OpenNPCShop(shop_id)
end

function this:BtnClickCallBack(_, type)
    local mapId = tonumber(SL:GetMetaValue(EMetaVarGetKey.MAP_ID))
    if type == 0 then
        if PrivilegeCardManager.iswithStore() then
            --SL:HideAllKmlPanel()
            self:OnClickLeftBtn()
            self:OpenShop()
            return
        end
        ---@type cfg_npclist_column
        local tbl = SL:GetConfig("cfg_npclist", 100101)
        if tbl.mapId ~= mapId then
            SL:CommonTipsMessage({
                    title = "提示",
                    showTips = "是否进行传送",
                    callback = function()
                        self:OnClickLeftBtn()
                        self.type = type
                    end
                })
            return
        end
    elseif type == 4 then
        ---@type cfg_npclist_column
        local tbl = SL:GetConfig("cfg_npclist", 100404)
        if tbl.mapId ~= mapId then
            SL:CommonTipsMessage({title="提示", showTips="是否进行传送", callback = function()
                self:OnClickLeftBtn()
                self.type = type
            end})
            return
        end
    elseif type == 2 then
        local map_id = SL:GetMetaValue(EMetaVarGetKey.MAP_ID)
        local mapNpc = self.mapNpc
        local curMapNpc = mapNpc[map_id]
        if table.isNullOrEmpty(curMapNpc) then
            SL:CommonTipsMessage({title="提示", showTips="是否进行传送", callback = function()
                self:OnClickLeftBtn()
                self.type = type
            end})
            return
        end
    end
    self:OnClickLeftBtn()
    self.type = type
end

function this:GoByMedicine()
    local instruction = {"moveToNPC","100101"}
    local medId
    if self.monsterId then
        local monsterTbl = SL:GetConfig("cfg_monster", self.monsterId)
        medId = monsterTbl.RecommendedPotion
    end
    SL:ShortcutDO(instruction, nil, nil, function()
        InfoManager.mainUIInfo:SetReliveBuyItemId(medId)
        SL:TalkToNpc(tonumber(instruction[2]))
    end)
end

function this:GoDuanZaoPage()
    GUI:UIPanel_Open("dev/ui/UIForgeGroup/Panel/KLUIForgeGroup/KLUIForgeGroupPanel", _, _, {
        showLight = true, forgeGroupType = EForgeGroupType.Strength
    })
    -- ---@type cfg_MainPanelUI_column
    -- local tbl = SL:GetConfig("cfg_MainPanelUI",EMainUIBottomFuncType.Forge,"id")
    -- SL:onLUAEvent(LUA_EVENT_OPENMAINSYSTEMFUNCTION,tbl.systemId)
end

function this:GoNpc()
    local map_id = SL:GetMetaValue(EMetaVarGetKey.MAP_ID)
    local mapNpc = self.mapNpc
    local curMapNpc = mapNpc[map_id]
    if table.isNullOrEmpty(curMapNpc) then
        local instruction = {"moveToNPC","100104"}
        SL:ShortcutDO(instruction, nil, nil, function()
            SL:TalkToNpc(tonumber(instruction[2]))
        end)
        return
    end
    local playerPos = SL:MeData_GetCoord()
    local min = nil
    for k, v in pairs(curMapNpc) do
        local npcPos = Dot2(v.x,v.y)
        local distance = SL:GetPointDistanceSQ(playerPos, npcPos)
        if not min then
            min = {id = v.id, distance = distance}
        end
        if min.distance > distance then
            min = {id = v.id, distance = distance}
        end
    end
    SL:FGRunToNpc(min.id)
end

function this:GoShopPage(type)
    local param = {}
    local tbls = SL:GetConfigTable("cfg_shopMall")
    ---@param v cfg_shopMall_column
    for _, v in pairs(tbls) do
        ---@type cfg_item_column
        local itemTbl = SL:GetConfig("cfg_item", v.itemId)
        if type == 1 then
            if itemTbl.type == E_ItemType.Equip and itemTbl.subType == E_ItemSubType_Equip.ShouHu then
                table.insert(param, v.id)
            end
        else
            if itemTbl.type == E_ItemType.Medicine and itemTbl.subType == 1 then
                table.insert(param, v.id)
            end
        end
    end
    GUI:UIPanel_Open("dev/outui/ShopMain/Panel/KLShopMain/KLShopMainPanel", _, _, {
        1, 1030, param
    })
    -- ---@type cfg_MainPanelUI_column
    -- local tbl = SL:GetConfig("cfg_MainPanelUI",EMainUIBottomFuncType.Shop,"id")
    -- -- if isClick[1] then
    -- SL:onLUAEvent(LUA_EVENT_OPENMAINSYSTEMFUNCTION,tbl.systemId)
end

function this:GoHeChengNpc()
    local ins = {"moveToNPC","100404"}
    SL:ShortcutDO(ins, nil, nil, function()
            SL:TalkToNpc(tonumber(ins[2]))
        end)
end

--[[--倒计时
this.countDownTimer = 60
function this.CountDownText()
    if this.countDownTimer <= 0 then return end
    this.countDownTimer = this.countDownTimer - 1
    this.obj_text_reviveCountDown:SetText(string.format("回到重生点(%02d)", this.countDownTimer))
    if this.countDownTimer <= 0 then
        --this:Revive(1)
        if this.countDown then
            this.registInBaseUI:Stop_Timer(this.countDown)
        end
        this:HideMe()
    end
end]]

--倒计时

function this:CountDownText()
    if self.countDownTimer <= 0 then
        return
    end
    self.countDownTimer = self.countDownTimer - 1
    GUI:Button_setTitleText(self.view.LeftBtn,string.format("免费复活(%02d)", self.countDownTimer))
    --GUI:Text_setString(self.view.LeftBtnText, string.format("免费复活(%02d)", self.countDownTimer))
    --self.obj_text_reviveCountDown:SetText(string.format("免费复活(%02d)", self.countDownTimer))
    --GUI:setSwallowTouches(self.view.LeftBtn,true)
    if self.countDownTimer <= 0 then
        --self:Revive(1)
        --GUI:setSwallowTouches(self.view.LeftBtn,false)0000
        GUI:Button_setTitleText(self.view.LeftBtn,"免费复活")
        self:ReviveType(self.leftcfg.id, self.leftcfg.type)
        self:OnCloseButton()
        if self.countDown then
            SL:UnSchedule(self.countDown)
            self.countDown = nil
        end
    end
end

---通知复活
---@param message MapProtos.ReliveRes
function this:ResReliveMessage(_, message)
    if message.id ~= SL:GetMetaValue(EMetaVarGetKey.UID) then
        return
    end
    local type = self.type
    self:OnCloseButton()
    SL:ScheduleOnce(Time.deltaTime, function()
    if type == 0 then
        self:GoByMedicine()
    elseif type == 1 then
        self:GoDuanZaoPage()
    elseif type == 2 then
        self:GoNpc()
    elseif type == 3 then
        self:GoShopPage(2)
    elseif type == 4 then
        self:GoHeChengNpc()
    elseif type == 5 then
        self:GoShopPage(1)
    end
    end)
    -- if true then
    --     local instruction = {"moveToNPC","100104"}
    --     SL:ShortcutDO(instruction)
    --     return
    -- end
end

function this:OnCloseButton()
    GUI:UIPanel_Close("dev/ui/Revive/Panel/KLReviveTip/KLReviveTipPanel")
end

function this:OnClickLeftBtn()
    if self.leftcfg then
        self:ReviveType(self.leftcfg.id, self.leftcfg.type)
        --self:OnCloseButton()
    end
end

function this:OnClickRightBtn()
    if self.rightcfg then
        self:ReviveType(self.rightcfg.id, self.rightcfg.type)
    end
end

function this:ReviveType(id, type)
    if InfoManager.bingFengBaoInfo:IsInBingFengMap() and type == 6 then
        SL:ReqPlayerReliveMessage(7, type)
        return
    end

    SL:ReqPlayerReliveMessage(id, type)
    --self:OnCloseButton()
end

function this:OnClose()
--[[    local panel = GUI:UIPanel_Open("dev/ui/MainUI/Panel/KLUIPlayerInfo/KLUIPlayerInfoPanel",nil,nil,nil,false,function(panel)
        GUI:SetAnchoredPosition(panel.view.root,Vector2.New(0, -1420))
        GUI:DOAnchorPos(GUI:GetRectTransform(panel.view.root), Vector2.New(0, 0),0.5)
    end)]]
    if self.countDown then
        SL:UnSchedule(self.countDown)
        self.countDown = nil
    end
    SL.ShowMainPanel()
end

function this:CheckBtnsShowState(monsterTblId)
    -- GUI:setVisible(self.view.txt_titleMed, true)
    -- GUI:setVisible(self.view.layout_med, true)
    ---药品建议
    local monsterTbl = SL:GetConfig("cfg_monster", monsterTblId)
    local itemCfg = SL:GetConfig("cfg_item", monsterTbl.RecommendedPotion)
    local own = SL:GetBagItemCount(monsterTbl.RecommendedPotion)
    GUI:setVisible(self.view.txt_titleMed, own <= 0)
    GUI:setVisible(self.view.layout_med, own <= 0)
    GUI:Text_setString(self.view.txt_needMed, string.format("所需<color=#FF0000>[%s]</color>不足", itemCfg.name))
    ---推荐防御
    local showdefText = false
    local attValue = SL:GetMetaValue(EMetaVarGetKey.GET_ATTR_VALUE_BY_ID, 206011)
    local delta = monsterTbl.RecommendedDef - attValue
    if delta <= 0 then
        GUI:setVisible(self.view.txt_defence, false)
    else
        showdefText = true
        GUI:setVisible(self.view.txt_defence, true)
        GUI:Text_setString(self.view.txt_defence, string.format("推荐防御%s（<color=#FF0000>不足%s</color>）",
            monsterTbl.RecommendedDef, delta))
    end
    ---锻造装备
    local equipSlot = {EEquipSlotType.Armor, EEquipSlotType.Helmet, EEquipSlotType.Glove, EEquipSlotType.Pant, EEquipSlotType.Boot}
    local baseWearBar = SL:GeCareerBaseWearBar(SL:MeData_GetCareer())
    local show_strengthen = false
    for _, v in pairs(equipSlot) do
        local equipData = SL:MeData_GetEquipByPosAndWearBar(v, baseWearBar)
        if not equipData then
            show_strengthen = true
            break
        end
        local strengthen = EquipFunc.GetEquipStrengthLevel(equipData)
        if strengthen < 15 then
            show_strengthen = true
            break
        end
    end
    -- 强制隐藏：死亡复活界面“锻造装备”按钮
    show_strengthen = false
    GUI:setVisible(self.view.btn_duanzao, false)
    ---领取状态
    local show_buff1 = true
    local buffList = InfoManager.skillInfo.InitBuffList
    if table.count(buffList) > 0 then
        local global1 = SL:GetConfig("cfg_global", 850001)
        local split = string.split(global1.value, "#")
        for _, v in pairs(split) do
            local id = tonumber(v)
            if buffList[id] then
                show_buff1 = false
                break
            end
        end
    end
    -- 强制隐藏：死亡复活界面“领取状态”按钮
    show_buff1 = false
    GUI:setVisible(self.view.btn_buff1, false)
    ---BUFF卷轴
    local show_buff2 = true
    if table.count(buffList) > 0 then
        local global2 = SL:GetConfig("cfg_global", 850003)
        local split = string.split(global2.value, "#")
        for _, v in pairs(split) do
            local id = tonumber(v)
            if buffList[id] then
                show_buff2 = false
                break
            end
        end
    end
    GUI:setVisible(self.view.btn_buff2, show_buff2)
    GUI:setVisible(self.view.layout_def, show_strengthen or show_buff1 or show_buff2)
    ---守护天使
    local show_guard = false
    if not SL:MeData_GetEquipByPosAndWearBar(EEquipSlotType.Guard, baseWearBar) then
        show_guard = true
    end
    GUI:setVisible(self.view.btn_guard, show_guard)
    ---合成翅膀
    local show_wing = false
    local meLv = SL:GetMetaValue(EMetaVarGetKey.LEVEL)
    if meLv >= 150 and not SL:MeData_GetEquipByPosAndWearBar(EEquipSlotType.Wing, baseWearBar) then
        show_wing = true
    end
    GUI:setVisible(self.view.btn_wing, show_wing)
    GUI:setVisible(self.view.layout_damage, show_guard or show_wing)
    GUI:setVisible(self.view.txt_titleDef, showdefText or show_strengthen or show_buff1 or show_buff2 or show_guard or show_wing)

    GUI:setVisible(self.view.Root_monsterKillInfo, true)
    local baseHeight = 90
    if showdefText then
        baseHeight = baseHeight + 60
    end
    if show_strengthen or show_buff1 or show_buff2 then
        baseHeight = baseHeight + 50
    end
    if show_guard or show_wing then
        baseHeight = baseHeight + 47
    end
    --GUI:setContentSize(self.view.img9, 530, baseHeight)
end

return this
