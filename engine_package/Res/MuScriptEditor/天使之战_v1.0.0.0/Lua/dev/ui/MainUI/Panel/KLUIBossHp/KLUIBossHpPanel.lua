---@class KLUIBossHpPanel:UIKmlLuaPanelBase
---@field view KLUIBossHpPanelView
local KLUIBossHpPanel = class(UIKmlLuaPanelBase)
local this = KLUIBossHpPanel
---创建时调用一次
function this:Init()
    GUI:DataListInitData(self.view.drop_data_list,
            function()
                return #self.allDrop
            end,
            function(realIndex)
                return self:FastDataListItemGetFunc(realIndex)
            end,
            nil,
            function(realIndex, kmlcontrol)
                return self:FastDataListItemUpdateFunc(realIndex, kmlcontrol)
            end)
    self.drop_all_item = {}
    self.updateID = SL:Schedule(self.updateID, 0, 2, -1, function()
        self:Update()
    end)
    -- 关掉战斗日志
    GUI:UIPanel_Close("dev/ui/MainUI/Panel/KLUIHurtExp/KLUIHurtExpPanel")
end

local maxDixtance = 10
function this:Update()
    if not self.parm or not self.parm.id then
        return
    end
    local role = SL:GetRoleById(self.parm.id)
    if not role then
        SL:CloseBossHp()
        return
    end
    local playerPos = SL:GetMetaValue(EMetaVarGetKey.MAP_PLAYER_POS)
    if not playerPos then
        return
    end

    local distance = SL:GetPointDistance(playerPos, role.data.OldCoord)
    if distance > maxDixtance then
        SL:CloseBossHp()
        return
    end
    self:CheckPKMode()
end

---创建或者刷新界面数据时调用
function this:Refresh()
end

function this:RefreshUI(parm,role)
    if self.parm and self.parm.id and self.parm.id == parm.id then
        self:CheckPKMode()
        return
    end
    self.parm = parm
    SL:onLUAEvent(LUA_EVENT_HIDE_RIGHT_BTN_VIEW)
    local is_player = SL:GetMetaValue(EMetaVarGetKey.ACTOR_IS_PLAYER, self.parm.id)
    local role = SL:GetRoleById(self.parm.id)
    local hp = SL:GetMetaValue(EMetaVarGetKey.ACTOR_HP, self.parm.id)
    if not hp then
        hp = 0
    end
    local maxhp = SL:GetMetaValue(EMetaVarGetKey.ACTOR_MAXHP, self.parm.id)
    if not maxhp then
        maxhp = 1
    end
    if self.parm and self.parm.role then
        is_player = true
        hp= self.parm.role.hp
        maxhp= self.parm.role.maxHp
    end
    local value = Mathf.Ceil(hp / maxhp * 100)

    local is_att = ""
    if is_player then
        is_att = SL:GetMetaValue(EMetaVarGetKey.Check_PKMODE_IS_ATTACK_PLAYER, self.parm.id)
    end
    self.allDrop = {}

    -- self.ownerRid = InfoManager.monsterAffiliationInfo:GetMonsterAffiliationByRid(self.parm.id)
    -- self.maxHurt_Rid = InfoManager.monsterAffiliationInfo:GetMonsterMaxHurtByRid(self.parm.id)
    --[[self.ownerRid = InfoManager.monsterAffiliationInfo:GetMonsterAffiliationByRid(self.parm.id)
    self.maxHurt_Rid = InfoManager.monsterAffiliationInfo:GetMonsterAffiliationByRid(self.parm.id)]]

    self:RefreshName()
    GUI:SetLoadingbar_startper(self.view.sliderHp, value)
    GUI:SetLoadingbar_startper(self.view.sliderHp2, value)
    GUI:SetLoadingbar_startper(self.view.sliderHp3, value)
    self:CheckHpColor()
    -- self:CheckQiangDuoBtn()
    if self.parm and self.parm.role then
        local baseCareer = self.parm.role.career.baseCareer
        local src = "1" .. baseCareer
        if baseCareer == 7 then
            GUI:Image_loadTexture(self.view.icon,"177","Atlas/FG_AttrPanel.spriteatlas")
        else            
            GUI:Image_loadTexture(self.view.icon, src, "Atlas/MUIcon.spriteatlas")
        end
    elseif is_player then
        local baseCareer = role.data.career.baseCareer
        local src = "1" .. baseCareer
        if baseCareer == 7 then
            GUI:Image_loadTexture(self.view.icon,"177","Atlas/FG_AttrPanel.spriteatlas")
        else            
            GUI:Image_loadTexture(self.view.icon, src, "Atlas/MUIcon.spriteatlas")
        end
    else
        local cdfId = role.data.serverData.cfgId
        local src = SL:GetConfig("cfg_monster", cdfId).icon
        GUI:Image_loadTexture(self.view.icon, src, "Atlas/Monster_icon.spriteatlas")
    end
    GUI:DataListUpdateData(self.view.drop_data_list)
end

function this:CheckPKMode()
    -- self:CheckQiangDuoBtn()
    self:CheckHpColor()
    self:RefreshName()
end

-- function this:CheckHpColor()
--     local is_player = SL:GetMetaValue(EMetaVarGetKey.ACTOR_IS_PLAYER, self.parm.id)
--     local is_att = ""
--     if is_player then
--         is_att = SL:GetMetaValue(EMetaVarGetKey.Check_PKMODE_IS_ATTACK_PLAYER, self.parm.id)
--     end
--     local is_owner = true
--     local userid = SL:GetMetaValue("USER_ID")
--     userid = tonumber(userid)
--     local is_monster = SL:GetMetaValue(EMetaVarGetKey.ACTOR_IS_MONSTER, self.parm.id)
--     ----怪物的血条显示规则和玩家的不一样
--     if is_monster then
--         if not self.ownerRid or self.ownerRid == 0 or self.ownerRid == userid then
--             is_owner = true
--         else
--             is_owner = false
--         end
--         local role = SL:GetRoleById(self.parm.id)
--         local cdfId = role.data.serverData.cfgId
--         local mgroup = SL:GetConfig("cfg_monster", cdfId).mgroup
--         local hate = 0
--         if mgroup and #mgroup > 0 then
--             hate = SL:GetConfig("cfg_boss_drop", mgroup[1], "mgroup").droptype
--         end
--         --SL:LogError("hate-----"..cdfId.. "  "..hate)
--         self.hate = hate
--         if hate == 0 then
--             GUI:setVisible(self.view.sliderHp, true)
--             GUI:setVisible(self.view.sliderHp2, false)
--             GUI:setVisible(self.view.sliderHp3, false)
--         elseif hate == 1 then
--             local hateId = self.maxHurt_Rid
--             if hateId and hateId ~= 0 then
--                 if userid == hateId then
--                     GUI:setVisible(self.view.sliderHp, true)
--                     GUI:setVisible(self.view.sliderHp2, false)
--                     GUI:setVisible(self.view.sliderHp3, false)
--                 else
--                     GUI:setVisible(self.view.sliderHp, false)
--                     GUI:setVisible(self.view.sliderHp2, false)
--                     GUI:setVisible(self.view.sliderHp3, true)
--                 end
--             else
--                 GUI:setVisible(self.view.sliderHp, true)
--                 GUI:setVisible(self.view.sliderHp2, false)
--                 GUI:setVisible(self.view.sliderHp3, false)
--             end
--         elseif hate == 2 then
--             GUI:setVisible(self.view.sliderHp, true)
--             GUI:setVisible(self.view.sliderHp2, false)
--             GUI:setVisible(self.view.sliderHp3, false)
--         elseif hate == 3 then
--             local hateId = self.maxHurt_Rid
--             if hateId and hateId ~= 0 then
--                 if userid == hateId then
--                     GUI:setVisible(self.view.sliderHp, true)
--                     GUI:setVisible(self.view.sliderHp2, false)
--                     GUI:setVisible(self.view.sliderHp3, false)
--                 else
--                     GUI:setVisible(self.view.sliderHp, false)
--                     GUI:setVisible(self.view.sliderHp2, false)
--                     GUI:setVisible(self.view.sliderHp3, true)
--                 end
--             else
--                 GUI:setVisible(self.view.sliderHp, true)
--                 GUI:setVisible(self.view.sliderHp2, false)
--                 GUI:setVisible(self.view.sliderHp3, false)
--             end
--         elseif hate == 4 then
--             GUI:setVisible(self.view.sliderHp, true)
--             GUI:setVisible(self.view.sliderHp2, false)
--             GUI:setVisible(self.view.sliderHp3, false)
--         elseif hate == 5 then
--             if is_owner then
--                 GUI:setVisible(self.view.sliderHp, true)
--                 GUI:setVisible(self.view.sliderHp2, false)
--                 GUI:setVisible(self.view.sliderHp3, false)
--             else
--                 GUI:setVisible(self.view.sliderHp, false)
--                 GUI:setVisible(self.view.sliderHp2, false)
--                 GUI:setVisible(self.view.sliderHp3, true)
--             end
--         end

--     else
--         if string.isNullOrEmpty(is_att) then
--             GUI:setVisible(self.view.sliderHp, true)
--             GUI:setVisible(self.view.sliderHp2, false)
--             GUI:setVisible(self.view.sliderHp3, false)
--         else
--             GUI:setVisible(self.view.sliderHp, false)
--             GUI:setVisible(self.view.sliderHp2, true)
--             GUI:setVisible(self.view.sliderHp3, false)
--         end
--     end

-- end

function this:CheckHpColor()
    local is_player = SL:GetMetaValue(EMetaVarGetKey.ACTOR_IS_PLAYER, self.parm.id)
    local is_att = ""
    if is_player then
        is_att = SL:GetMetaValue(EMetaVarGetKey.Check_PKMODE_IS_ATTACK_PLAYER, self.parm.id)
    end
    local is_owner = true
    local userid = SL:GetMetaValue("UID")
    local is_monster = SL:GetMetaValue(EMetaVarGetKey.ACTOR_IS_MONSTER, self.parm.id)
    ----怪物的血条显示规则和玩家的不一样
    if is_monster then
        if not self.ownerRid or self.ownerRid == 0 or self.ownerRid == userid then
            is_owner = true
        else
            is_owner = false
        end
        local hate = InfoManager.monsterAffiliationInfo:GetMonsterAffiliationType(self.parm.id)
        self.hate = hate
        if hate == 0 then  --无归属
            GUI:setVisible(self.view.sliderHp, true)
            GUI:setVisible(self.view.sliderHp2, false)
            GUI:setVisible(self.view.sliderHp3, false)
        elseif hate == 1 then   --仇恨第一
            local hateId = InfoManager.monsterAffiliationInfo:GetMonsterAffiliationByRid(self.parm.id)
            if hateId and hateId ~= 0 then
                if userid == hateId then
                    GUI:setVisible(self.view.sliderHp, true)
                    GUI:setVisible(self.view.sliderHp2, false)
                    GUI:setVisible(self.view.sliderHp3, false)
                else
                    GUI:setVisible(self.view.sliderHp, false)
                    GUI:setVisible(self.view.sliderHp2, false)
                    GUI:setVisible(self.view.sliderHp3, true)
                end
            else
                GUI:setVisible(self.view.sliderHp, true)
                GUI:setVisible(self.view.sliderHp2, false)
                GUI:setVisible(self.view.sliderHp3, false)
            end
        elseif hate == 2 then  --尾刀
            GUI:setVisible(self.view.sliderHp, true)
            GUI:setVisible(self.view.sliderHp2, false)
            GUI:setVisible(self.view.sliderHp3, false)
        elseif hate == 3 then   --伤害第一
            local hateId = InfoManager.monsterAffiliationInfo:GetMonsterAffiliationByRid(self.parm.id)
            if hateId and hateId ~= 0 then
                if userid == hateId then
                    GUI:setVisible(self.view.sliderHp, true)
                    GUI:setVisible(self.view.sliderHp2, false)
                    GUI:setVisible(self.view.sliderHp3, false)
                else
                    GUI:setVisible(self.view.sliderHp, false)
                    GUI:setVisible(self.view.sliderHp2, false)
                    GUI:setVisible(self.view.sliderHp3, true)
                end
            else
                GUI:setVisible(self.view.sliderHp, true)
                GUI:setVisible(self.view.sliderHp2, false)
                GUI:setVisible(self.view.sliderHp3, false)
            end
        elseif hate == 4 then
            GUI:setVisible(self.view.sliderHp, true)
            GUI:setVisible(self.view.sliderHp2, false)
            GUI:setVisible(self.view.sliderHp3, false)
        elseif hate == 5 then
            local hateId = InfoManager.monsterAffiliationInfo:GetMonsterAffiliationByRid(self.parm.id)
            if hateId and hateId ~= 0 then
                GUI:setVisible(self.view.sliderHp, true)
                GUI:setVisible(self.view.sliderHp2, false)
                GUI:setVisible(self.view.sliderHp3, false)
            else
                GUI:setVisible(self.view.sliderHp, false)
                GUI:setVisible(self.view.sliderHp2, false)
                GUI:setVisible(self.view.sliderHp3, true)
            end
        end

    else
        if string.isNullOrEmpty(is_att) then
            GUI:setVisible(self.view.sliderHp, true)
            GUI:setVisible(self.view.sliderHp2, false)
            GUI:setVisible(self.view.sliderHp3, false)
        else
            GUI:setVisible(self.view.sliderHp, false)
            GUI:setVisible(self.view.sliderHp2, true)
            GUI:setVisible(self.view.sliderHp3, false)
        end
    end

end

function this:CheckQiangDuoBtn(...)
    local rid = SL:GetMetaValue("MAIN_ACTOR_ID")
    rid = tonumber(rid)
    local is_monster = SL:GetMetaValue(EMetaVarGetKey.ACTOR_IS_MONSTER, self.parm.id)
    if not is_monster then
        GUI:setVisible(self.view.snatchBtn, false)
        return
    end
    local userid = SL:GetMetaValue("USER_ID")
    userid = tonumber(userid)
    local is_owner = true
    if not self.ownerRid or self.ownerRid == 0 or self.ownerRid == userid then
        is_owner = true
    else
        is_owner = false
    end
    local role = SL:GetRoleById(self.parm.id)
    local cdfId = role.data.serverData.cfgId
    local mgroup = SL:GetConfig("cfg_monster", cdfId).mgroup
    local hate = 0
    if mgroup and #mgroup > 0 then
        hate = SL:GetConfig("cfg_boss_drop", mgroup[1], "mgroup").droptype
    end
    if hate == 0 then
        GUI:setVisible(self.view.snatchBtn, false)
    elseif hate == 1 then
        local hateId = self.maxHurt_Rid
        if hateId and hateId ~= 0 then
            if userid == hateId then
                GUI:setVisible(self.view.snatchBtn, false)
            else
                GUI:setVisible(self.view.snatchBtn, true)
            end
        else
            GUI:setVisible(self.view.snatchBtn, false)
        end
    elseif hate == 2 then
        GUI:setVisible(self.view.snatchBtn, false)
    elseif hate == 3 then
        local hateId = self.maxHurt_Rid
        if hateId and hateId ~= 0 then
            if userid == hateId then
                GUI:setVisible(self.view.snatchBtn, false)
            else
                GUI:setVisible(self.view.snatchBtn, true)
            end
        else
            GUI:setVisible(self.view.snatchBtn, false)
        end
    elseif hate == 4 then
        GUI:setVisible(self.view.snatchBtn, false)
    elseif hate == 5 then
        if is_owner then
            GUI:setVisible(self.view.snatchBtn, false)
        else
            GUI:setVisible(self.view.snatchBtn, true)
        end
    end
end

---注册UI事件和服务器消息
function this:RegistEvents()
    SL:RegisterLUAEvent(LUA_EVENT_NET_PLAYER_DIE, self.PlayerDie, self)  --玩家死亡
    SL:RegisterLUAEvent(LUA_EVENT_MONSTER_DIE, self.MonsterDie, self)   --怪物死亡
    SL:RegisterLUAEvent(LUA_EVENT_ROLE_HP_CHANGE, self.HpChange, self)  --角色血量变化
    SL:RegisterLUAEvent(LUA_EVENT_HIDE_BOSS_HP, self.HideBossHp, self)    --隐藏boss血条
    SL:RegisterLUAEvent(LUA_EVENT_CANCEL_HIDE_BOSS_HP, self.CancelHideBossHp, self)     --取消隐藏boss血条
    SL:RegisterLUAEvent(LUA_EVENT_MONSTER_TARGET_HATE, self.HeatChange, self)     --怪物仇恨目标改变
    SL:RegisterLUAEvent(LUA_EVENT_MONSTER_AFFILIATION_CHANGE, self.LUA_EVENT_MONSTER_AFFILIATION_CHANGE, self) --归属改变

    GUI:AddOnClickEvent(self.view.KLUIBossHpButton, self, self.OnClickBossHp)
    GUI:AddOnClickEvent(self.view.snatchBtn, self, self.OnClickSnatchBtn)

    SL:RegisterLUAEvent(Event.CloseTeamTipsUI, self.CloseTeamTipsUI, self)
    GUI:AddOnClickEvent(self.view.closeBtn, self, self.OnClickCloseBtn)
end

function this:OnClickCloseBtn()
    self.parm = nil
    SL:CloseBossHp()
end

function this:CloseTeamTipsUI()
    self.isOnClick = false
end

function this:OnClickBossHp()
    if self.parm and self.parm.id then
        local role = SL:GetRoleById(self.parm.id)
        if role  then
            if role.RoleType == ERoleType.Player then
                self.isOnClick = true
                GUI:UIPanel_Open("dev/ui/FriendSys/Panel/KLFriendOperate/KLFriendOperatePanel", nil, nil, { rid = role.data.id, name = role.data.name })
                return
            end
        else
            if self.parm and self.parm.role then
                self.isOnClick = true
                GUI:UIPanel_Open("dev/ui/FriendSys/Panel/KLFriendOperate/KLFriendOperatePanel", nil, nil, { rid = self.parm.role.rid, name =self.parm.role.name })
                return
            end
        end
    end

end

function this:OnClickSnatchBtn()
    if not self.hate then
        return
    end
    local rid = SL:GetMetaValue("MAIN_ACTOR_ID")
    rid = tonumber(rid)
    if self.hate == 5 then
        if rid ~= self.ownerRid and self.ownerRid ~= 0 then
            SL:SetMetaValue(EMetaVarSetKey.SET_PKMODE, EPKMode.AllAttack)
            SL:SetSelectTargetId(self.ownerRid)
            SL:SetHookAttackTargetId(self.ownerRid)
            SL:StartOnHook(true)
        end
    else
        local hateId = self.maxHurt_Rid
        if hateId and hateId ~= 0 and hateId ~= rid then
            SL:SetMetaValue(EMetaVarSetKey.SET_PKMODE, EPKMode.AllAttack)
            SL:SetSelectTargetId(hateId)
            SL:SetHookAttackTargetId(hateId)
            SL:StartOnHook(true)
        end
    end
end

function this:PlayerDie(_, message)
    if self.parm.id == message then
        self.parm = nil
        SL:CloseBossHp()
    end
end
function this:MonsterDie(_, message)
    if self.parm and self.parm.id == message then
        self.parm = nil
        SL:CloseBossHp()
    end
end
function this:HpChange(_, message)
    if self.parm and self.parm.id == message.id then
        local hp = message.hp
        local maxhp = message.maxhp
        local value = Mathf.Ceil(hp / maxhp * 100)
        GUI:SetLoadingbar_startper(self.view.sliderHp, value)
        GUI:SetLoadingbar_startper(self.view.sliderHp2, value)
        GUI:SetLoadingbar_startper(self.view.sliderHp3, value)
    end
end

function this:FastDataListItemGetFunc(realIndex)
    local data = self.allDrop[realIndex + 1]
    local message = { cfgId = data, itemIndex = realIndex + 1 }
    local item = GUI:UIPanel_Open("dev/ui/MainUI/Item/KLBossHp/KLBossHpItem", self.view.drop_data_list, self, message, true)

    self.drop_all_item[item.view.root] = item
    return item.view.root
end

function this:FastDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.allDrop[realIndex + 1]
    self.drop_all_item[kmlcontrol]:RefreshItem(data)
end

function this:HideBossHp()
    if self.isOnClick then
        GUI:UIPanel_Close("dev/ui/Team/Panel/KLUITeamTips/KLUITeamTipsPanel")
    end
    -- 隐藏 Boss 血条界面
    GUI:setVisible(self.view.root, false)
end

function this:CancelHideBossHp()
    -- 取消隐藏 Boss 血条界面
    if self.parm and self.parm.id then
        GUI:setVisible(self.view.root, true)
        self:RefreshUI(self.parm)
    end
end

function this:HeatChange(_, message)
    if self.parm and message.id == self.parm.id then
        -- self:CheckQiangDuoBtn()
        self:CheckHpColor()
        self:RefreshName()
    end
end

---归属改变
---@param message RoleChangeData
function this:LUA_EVENT_MONSTER_AFFILIATION_CHANGE(_, message)
    if self.parm and message.rid == self.parm.id then
        -- self.ownerRid = message.ownerRid
        -- self.maxHurt_Rid = message.maxHurt
        self.ownerRid = InfoManager.monsterAffiliationInfo:GetMonsterAffiliationByRid(self.parm.id)
        self.maxHurt_Rid = InfoManager.monsterAffiliationInfo:GetMonsterAffiliationByRid(self.parm.id)
        -- self:CheckQiangDuoBtn()
        self:CheckHpColor()
        self:RefreshName()
    end
end

function this:RefreshName()
    local title = ""
    local color = "#FF3939"
    local hateName = ""
    self.ownerRid = InfoManager.monsterAffiliationInfo:GetMonsterAffiliationByRid(self.parm.id)
    self.maxHurt_Rid = InfoManager.monsterAffiliationInfo:GetMonsterAffiliationByRid(self.parm.id)
    if self.parm then
        self.allDrop = {}
        local is_player = SL:GetMetaValue(EMetaVarGetKey.ACTOR_IS_PLAYER, self.parm.id)
        local name = SL:GetMetaValue(EMetaVarGetKey.ACTOR_NAME, self.parm.id)
        local role = SL:GetRoleById(self.parm.id)
        if not role or not role.data then
            if self.parm and self.parm.role then
            else
                return
            end
        end
        local userid = SL:GetMetaValue("USER_ID")
        userid = tonumber(userid)
        if self.parm and self.parm.role then
            local level = self.parm.role.level
            name = self.parm.role.name
            title = "Lv." .. level .. " " .. name
            GUI:setVisible(self.view.snatchBtn, false)
        elseif is_player then
            local level = SL:GetMetaValue(EMetaVarGetKey.ACTOR_LEVEL, self.parm.id)
            title = "Lv." .. level .. " " .. name
            GUI:setVisible(self.view.snatchBtn, false)
        else
            local all_drop = SL:GetConfig('cfg_monster', role.data.serverData.cfgId, 'id').UIDrop
            if all_drop and #all_drop > 0 then
                local baseCareer = SL:GetMetaValue(EMetaVarGetKey.JOB)
                for _, one_reward in ipairs(all_drop) do
                    if one_reward[1] == baseCareer then
                        table.insert(self.allDrop, { cfgId = one_reward[2] })
                    end
                end
            end
            local level = SL:GetConfig("cfg_monster", role.data.serverData.cfgId).level
            local bosstype = SL:GetConfig("cfg_monster", role.data.serverData.cfgId).type
            if bosstype == 2 then
                color = "#E6E600"
            end
            ----显示怪物的仇恨目标
            -- local hateId = self.maxHurt_Rid
            local hateId
            local hateName1 = ""
            if hateId and hateId ~= 0 then
                local hName = SL:GetMetaValue(EMetaVarGetKey.ACTOR_NAME, tonumber(hateId))
                if hName then
                    hateName1 = "<color=#FFFFFF>" .. hName .. "</color>"
                end
            end
            ----显示怪物的归属玩家
            local hateName2 = ""
            if self.ownerRid and self.ownerRid ~= 0 then
                local hName = SL:GetMetaValue(EMetaVarGetKey.ACTOR_NAME, tonumber(self.ownerRid))
                if hName then
                    hateName2 = "<color=#FFFFFF>" .. hName .. "</color>"
                end
            end

            -- local hateName = ""
            -- local cdfId = role.data.serverData.cfgId
            -- local mgroup = SL:GetConfig("cfg_monster", cdfId).mgroup
            -- local hate = 0
            -- if mgroup and #mgroup > 0 then
            --     hate = SL:GetConfig("cfg_boss_drop", mgroup[1], "mgroup").droptype
            -- end
            -- if hate == 0 then
            --     hateName = hateName1
            -- elseif hate == 1 then
            --     hateName = hateName1
            -- elseif hate == 2 then
            --     hateName = hateName1
            -- elseif hate == 3 then
            --     hateName = hateName1
            -- elseif hate == 4 then
            --     hateName = hateName1
            -- elseif hate == 5 then
            --     hateName = hateName2
            -- end
            local target_name = InfoManager.monsterAffiliationInfo:GetMonsterAffiliationNameByRid(self.parm.id)
            local hate = InfoManager.monsterAffiliationInfo:GetMonsterAffiliationType(self.parm.id)
            if not is_player and GUIUtil.IsCanMapLinePkModeChange() then
                GUI:setVisible(self.view.snatchBtn, self.ownerRid ~= userid)
            else
                GUI:setVisible(self.view.snatchBtn, false)
            end
            if hate == 0 then  --无归属
                hateName = "无归属"
            elseif hate == 1 then   --仇恨第一
                if target_name and not string.isNullOrEmpty(target_name) then
                    hateName = "归属:".. target_name
                end
            elseif hate == 2 then  --尾刀
                hateName = "击杀者"
            elseif hate == 3 then   --伤害第一
                if target_name and not string.isNullOrEmpty(target_name) then
                    hateName = "归属:".. target_name
                end
            elseif hate == 4 then   --4参与者
                hateName = "参与者"
            elseif hate == 5 then   --5首刀
                if target_name and not string.isNullOrEmpty(target_name) then
                    hateName = "归属:".. target_name
                end
            end

            title = "Lv." .. level .. " " .. name
        end
    end
    GUI:Text_setString(self.view.guishu, hateName)
    GUI:Text_setString(self.view.name, title)
    GUI:Text_setTextColor(self.view.name, color)
end

function this:Close()
    self.ownerRid = 0
    self.parm = nil
    if self.updateID then
        SL:UnSchedule(self.updateID)
        self.updateID = nil
    end
end

return this
