---@class KLChallengeBossPanel:UIKmlLuaPanelBase
---@field view KLChallengeBossPanelView
local KLChallengeBossPanel = class(UIKmlLuaPanelBase)
local this = KLChallengeBossPanel
local panelIdToPath = {
    [EBossChallengeType.Gold] = "dev/outui/ChallengeBoss/Item/KLUIGoldBoss/KLUIGoldBossItem",
    [EBossChallengeType.Field] = "dev/outui/ChallengeBoss/Item/KLUIOutdoorBoss/KLUIOutdoorBossItem",
    --[EBossChallengeType.Secret] = "dev/outui/ChallengeBoss/Item/KLUISecretBoss/KLUISecretBossItem",
    [EBossChallengeType.Privilege] = "dev/outui/ChallengeBoss/Item/KLUIPrivilegeBoss/KLUIPrivilegeBossItem",
    [EBossChallengeType.Sanctuary] = "dev/outui/ChallengeBoss/Item/KLUISanctuaryBoss/KLUISanctuaryBossItem",
    [EBossChallengeType.GoldTroops] = "dev/outui/ChallengeBoss/Item/KLGoldenTroops/KLGoldenTroopsItem",
    [EBossChallengeType.KunDunDevil] = "dev/outui/ChallengeBoss/Item/KLKunDunDevil/KLKunDunDevilItem",
}

---创建时调用一次
function this:Init()
    SL.HideMainPanel()
    GUI:UIPanel_Close("dev/outui/ChallengeBoss/Panel/KLPrivilegeBossOpen/KLPrivilegeBossOpenPanel")
end

---创建或者刷新界面数据时调用
function this:Refresh()
    --SL:LogTable(self.args,true)
    local tabType = {}
    local defaultTab = 0
    local tbl = SL:GetConfigTable("cfg_BOSS_challenge")
    for i, v in ipairs(tbl) do
        if tabType[v.monsterType] == nil then
            tabType[v.monsterType] = true
            if defaultTab == 0 then
                defaultTab = v.monsterType
            end
        end
    end
    
    if self.args and self.args.monsterType then
        --MonsterType 1黄金 ，2野外，3秘境，4特权
        self.monsterId = self.args.monsterId
        ---转换一下，策划说按cfg_BOSS_challenge表的type走,之前黄金和野外是反的 ,需求又变了
        -- if self.args.monsterType == 2 then
        --     self.args.monsterType = 1
        -- elseif self.args.monsterType == 1 then
        --     self.args.monsterType = 2
        -- end

        defaultTab = self.args.monsterType
        --[[if self.args.monsterType == 2 then
            --self.view.boss_1_toggle:SetTogDefaultThis()
            GUI:SetTogDefaultThis(self.view.boss_1_toggle)
        elseif self.args.monsterType == 1 then
            --self.view.boss_2_toggle:SetTogDefaultThis()
            GUI:SetTogDefaultThis(self.view.boss_2_toggle)
        elseif self.args.monsterType == 3 then
            --self.view.boss_3_toggle:SetTogDefaultThis()
            GUI:SetTogDefaultThis(self.view.boss_3_toggle)
        elseif self.args.monsterType == 4 then
            --self.view.boss_4_toggle:SetTogDefaultThis()
            GUI:SetTogDefaultThis(self.view.boss_4_toggle)
        elseif self.args.monsterType == 6 then
            --self.view.boss_4_toggle:SetTogDefaultThis()
            GUI:SetTogDefaultThis(self.view.boss_6_toggle)
        end]]

    else
        self.monsterId = nil
        --self.view.boss_1_toggle:SetTogDefaultThis()
        --GUI:SetTogDefaultThis(self.view.boss_1_toggle)
    end
    
    if tabType[defaultTab] then
        GUI:SetTogDefaultThis(self.view["boss_"..defaultTab.."_toggle"])
        return
    else
        SL:LogError("页签 "..defaultTab.." 没有开放")
    end
    -- local level = InfoManager.newVipInfo.vipLevel
    -- if level > 0 or PrivilegeCardManager.HavePriviege() then
    -- else
    --     GUI:setVisible(self.view.boss_4,false)
    -- end
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:SetToggleOnValueChange(self.view.boss_1_toggle, self, self.Boss1Click)
    GUI:SetToggleOnValueChange(self.view.boss_2_toggle, self, self.Boss2Click)
    GUI:SetToggleOnValueChange(self.view.boss_4_toggle, self, self.Boss4Click)
    GUI:SetToggleOnValueChange(self.view.boss_5_toggle, self, self.Boss5Click)
    GUI:SetToggleOnValueChange(self.view.boss_6_toggle, self, self.Boss6Click)
    GUI:SetToggleOnValueChange(self.view.boss_7_toggle, self, self.OnValueChange_Boss_Toggle, EBossChallengeType.GoldTroops)
    GUI:SetToggleOnValueChange(self.view.boss_8_toggle, self, self.OnValueChange_Boss_Toggle, EBossChallengeType.KunDunDevil)
    GUI:AddOnClickEvent(self.view.btn_close, self, self.CloseOnclick)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.NEAREST_MONSTER, self.MonserPos, self)

    SL:RegisterLUAEvent(LUA_EVENT_CHALLENGE_BOSS_MONSTER_POS, self.LUA_EVENT_CHALLENGE_BOSS_MONSTER_POS, self)
end

function this:CloseOnclick()
    GUI:UIPanel_Close("dev/outui/ChallengeBoss/Panel/KLChallengeBoss/KLChallengeBossPanel")
    SL.ShowMainPanel()
end

function this:Close()
    --[[GUI:UIPanel_Close("dev/outui/ChallengeBoss/Item/KLUIGoldBoss/KLUIGoldBossItem")
    GUI:UIPanel_Close("dev/outui/ChallengeBoss/Item/KLUIOutdoorBoss/KLUIOutdoorBossItem")
    GUI:UIPanel_Close("dev/outui/ChallengeBoss/Item/KLUISecretBoss/KLUISecretBossItem")
    GUI:UIPanel_Close("dev/outui/ChallengeBoss/Item/KLUIPrivilegeBoss/KLUIPrivilegeBossItem")
    GUI:UIPanel_Close("dev/outui/ChallengeBoss/Item/KLKuaFuBossInfo/KLKuaFuBossInfoItem")
    GUI:UIPanel_Close("dev/outui/ChallengeBoss/Item/KLUISanctuaryBoss/KLUISanctuaryBossItem")]]
    if self.openPanelPath then
        GUI:UIPanel_Close(self.openPanelPath)
    end
end

function this:OnValueChange_Boss_Toggle(tog, eventData, args)
    local isOn = args[1]
    local togT = self.view["boss_" .. eventData .. "_toggle_t"]
    --GUI:setColor(togT, isOn and "#FFFFFF" or "#999999")
    if isOn then
        self:ShowBossPanel(eventData)
    end
end

function this:Boss1Click(kmlCtrl, eventData, args)
    if args[1] then
        --GUI:setColor(self.view.boss_1_toggle_t, "#FFFFFF")
        self:ShowBossPanel(EBossChallengeType.Gold)
    else
        --GUI:setColor(self.view.boss_1_toggle_t, "#999999")
    end
end

function this:Boss2Click(kmlCtrl, eventData, args)
    if args[1] then
        self:ShowBossPanel(EBossChallengeType.Field)
        self.monsterId = nil
    else
        --GUI:setColor(self.view.boss_2_toggle_t, "#999999")
    end

end


function this:Boss4Click(kmlCtrl, eventData, args)
    if args[1] then
        --GUI:setColor(self.view.boss_4_toggle_t, "#FFFFFF")
        self:ShowBossPanel(EBossChallengeType.Privilege)
        self.monsterId = nil
    else
       --GUI:setColor(self.view.boss_4_toggle_t, "#999999")
    end
end

function this:Boss5Click(kmlCtrl, eventData, args)
    if args[1] then
        --GUI:setColor(self.view.boss_5_toggle_t, "#FFFFFF")
        self:ShowBossPanel(0)
        ---跨服boss不在表类型里
        self.monsterId = nil
        self.kuaFuInfoItem = GUI:UIPanel_Open("dev/outui/ChallengeBoss/Item/KLKuaFuBossInfo/KLKuaFuBossInfoItem",
                self.view.root, self)
    else
        --GUI:setColor(self.view.boss_5_toggle_t, "#999999")
        self.kuaFuInfoItem = nil
        GUI:UIPanel_Close("dev/outui/ChallengeBoss/Item/KLKuaFuBossInfo/KLKuaFuBossInfoItem")
    end
end

function this:Boss6Click(kmlCtrl, eventData, args)
    if args[1] then
        --GUI:setColor(self.view.boss_6_toggle_t, "#FFFFFF")
        self:ShowBossPanel(EBossChallengeType.Sanctuary)
        self.monsterId = nil
    else
        --GUI:setColor(self.view.boss_6_toggle_t, "#999999")
    end
end

function this:ShowBossPanel(type)
    --GUI:setVisible(self.view.gold_boss_panel, type == EBossChallengeType.Gold)
    if self.openPanelPath then
        GUI:UIPanel_Close(self.openPanelPath)
    end
    local path = panelIdToPath[type]
    if path then
        GUI:UIPanel_Open(path, self.view.root, self, nil, false,
        function (temp)
            temp:SelectBossType(self.monsterId)
        end)
        self.openPanelPath = path
    end
    --[[if type == EBossChallengeType.Gold then
        GUI:UIPanel_Open("dev/outui/ChallengeBoss/Item/KLUIGoldBoss/KLUIGoldBossItem",self.view.root,self,nil,false,
        function (temp)
            temp:SelectBossType(self.monsterId)
        end)
    else
        GUI:UIPanel_Close("dev/outui/ChallengeBoss/Item/KLUIGoldBoss/KLUIGoldBossItem")
    end
    if type == EBossChallengeType.Field then
        GUI:UIPanel_Open("dev/outui/ChallengeBoss/Item/KLUIOutdoorBoss/KLUIOutdoorBossItem",self.view.root,self,nil,false,
        function (temp)
            temp:SelectBossType(self.monsterId)
        end)
    else
        GUI:UIPanel_Close("dev/outui/ChallengeBoss/Item/KLUIOutdoorBoss/KLUIOutdoorBossItem")
    end
    if type == EBossChallengeType.Secret then
        GUI:UIPanel_Open("dev/outui/ChallengeBoss/Item/KLUISecretBoss/KLUISecretBossItem",self.view.root,self,nil,false,
        function (temp)
            temp:SelectBossType(self.monsterId)
        end)
    else
        GUI:UIPanel_Close("dev/outui/ChallengeBoss/Item/KLUISecretBoss/KLUISecretBossItem")
    end
    if type == EBossChallengeType.Privilege then
        GUI:UIPanel_Open("dev/outui/ChallengeBoss/Item/KLUIPrivilegeBoss/KLUIPrivilegeBossItem",self.view.root,self,nil,false,
        function (temp)
            temp:SelectBossType(self.monsterId)
        end)
    else
        GUI:UIPanel_Close("dev/outui/ChallengeBoss/Item/KLUIPrivilegeBoss/KLUIPrivilegeBossItem")
    end
    if type == EBossChallengeType.Sanctuary then
        GUI:UIPanel_Open("dev/outui/ChallengeBoss/Item/KLUISanctuaryBoss/KLUISanctuaryBossItem",self.view.root,self,nil,false,
        function (temp)
            temp:SelectBossType(self.monsterId)
        end)
    else
        GUI:UIPanel_Close("dev/outui/ChallengeBoss/Item/KLUISanctuaryBoss/KLUISanctuaryBossItem")
    end]]

end






function this:isJoin()
    if not self.last_num or self.last_num < 1 then
        return false
    end
    return true
end


function this:MonserPos(id, message)
    if not message then
        return
    end
    if not message.mapCfgId or not message.line or not message.monsterCfgId then
        return
    end
    if SL:GetMetaValue(EMetaVarGetKey.MAP_ID) == message.mapCfgId and SL:GetMetaValue(EMetaVarGetKey.MAP_LINE) == message.line then
    else
        --if InfoManager.redNameInfo:IsLimitTransferById(SL:GetMetaValue("MAIN_ACTOR_ID"),nil,1) then
        --    SL:TipMessage(SL:GetConfig('cfg_string', 262).text, 1, NoticeType.NoticeMid)--"pk值较高，无法传送",
        --    return
        --end
    end

    SL:StopOnHook(true)
    this.pos_monster_id = message.monsterCfgId
    GUI:UIPanel_Close("dev/outui/ChallengeBoss/Panel/KLChallengeBoss/KLChallengeBossPanel")
    this.map_data = { message.mapCfgId, message.line, message.x, message.y }
    SL:Pathfinding(message.mapCfgId, message.line, message.x, message.y, this.MonserPosEnd, this.pos_monster_id)
    SL.ShowMainPanel()
end

function this:MonserPosEnd(pos)
    --SL:StartOnHook(true,true)
    if pos and pos.x and pos.z then
        this.scheduleId = SL:ScheduleOnce(0.1, function()
            SL:Pathfinding(this.map_data[1], this.map_data[2], pos.x, pos.z, this.BossPointOnHook)
        end)
    else
        SL:StartOnHook(true, true, this.pos_monster_id)
    end
end

function this:BossPointOnHook()
    SL:StartOnHook(true, true, this.pos_monster_id)
end

function this:Close()
    self.monsterId = nil
    self:UnRegistEvents()
end




function this:UnRegistEvents()

end

function this:LUA_EVENT_CHALLENGE_BOSS_MONSTER_POS(_id, message)
    self:MonserPos(nil, message)
end

return this
