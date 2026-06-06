---@class RoleEffInfo @注释
RoleEffInfo = class()
local this = RoleEffInfo

---检查的装备强化孔位
local checkEquipStrengthPart = {
    [EEquipSlotType.Helmet] = 1,
    [EEquipSlotType.Armor] = 1,
    [EEquipSlotType.Glove] = 1,
    [EEquipSlotType.Pant] = 1,
    [EEquipSlotType.Boot] = 1,
}

local maxEffPart = 999

local equipEffBone = {
    [EEquipSlotType.Helmet] = {
        { bone = "Bip01 Head", effectId = 70001 }
    },
    [EEquipSlotType.Armor] = {
        { bone = "Bip01 L UpperArm", effectId = 70002 },
        { bone = "Bip01 R UpperArm", effectId = 70003 }
    },
    [EEquipSlotType.Glove] = {
        { bone = "Bip01 L Forearm", effectId = 70006 },
        { bone = "Bip01 R Forearm", effectId = 70007 }
    },
    [EEquipSlotType.Pant] = {
        { bone = "Bip01 L Calf", effectId = 70004 },
        { bone = "Bip01 R Calf", effectId = 70005 }
    },
    [EEquipSlotType.Boot] = {
        { bone = "Bip01 L Foot", effectId = 70008 },
        { bone = "Bip01 R Foot", effectId = 70009 }
    },
    [maxEffPart] = {
        bone = "Bip01 Spine1"
    },
}

local equipEffBoneStr = {
    [EEquipSlotType.Helmet] = "Helmet",
    [EEquipSlotType.Armor] = "Armor",
    [EEquipSlotType.Glove] = "Glove",
    [EEquipSlotType.Pant] = "Pant",
    [EEquipSlotType.Boot] = "Boot",
    [maxEffPart] = "maxEffPart",
}

function this:ctor()

end

function this:Init()
    self:Reset()
    self:InitData()
    self:RegistMessages()
end

function this:InitData()
    self.curEffStrength = 0
    self.maxEffStrength = 0
    self.strengthEffs = {}
    self.equipEffBind = {}
    self.equipEffUIBind = {}
    self.canUIRole = false
    local globalCfg = SL:GetConfig("cfg_global", 360001)
    local tabs = string.split(globalCfg.value, '|')
    for _, v in ipairs(tabs) do
        local sp = string.split(v, '#')
        local lv = tonumber(sp[1])
        local list = {}
        self.maxEffStrength = math.max(self.maxEffStrength, lv)
        if sp[2] then
            for i = 2, #sp do
                table.insert(list, tonumber(sp[i]))
            end
            table.insert(self.strengthEffs, { lv = lv, path = tonumber(sp[2]), pathList = list })
        end
    end
end

function this:RegistMessages()
    SL:RegisterLUAEvent(LUA_EVENT_LOGIN_MAP, self.LUA_EVENT_LOGIN_MAP, self)
    SL:RegisterLUAEvent(LUA_EVENT_EXIT_GAME, self.LUA_EVENT_EXIT_GAME, self)
    SL:RegisterLUAEvent(LUA_EVENT_ROLEMODEL_ONLOAD_ALL, self.LUA_EVENT_ROLEMODEL_ONLOAD_ALL, self)
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_EQUIP_CHANGE, self.LUA_EVENT_PLAYER_EQUIP_CHANGE, self)
    SL:RegisterLUAEvent(LUA_EVENT_STRENGTH_OK, self.LUA_EVENT_STRENGTH_OK, self)
    SL:RegisterLUAEvent(LUA_EVENT_ROLEMODEL_SINGLE_ONLOAD, self.LUA_EVENT_ROLEMODEL_SINGLE_ONLOAD, self)
end

function this:Reset()
    if self.equipEffBind then
        for i, v in pairs(self.equipEffBind) do
            ---回收特效
            for _, k in pairs(v) do
                SL:StopRoleEffect(false, self.meId, k)
            end
        end
    end
    if self.equipEffUIBind then
        for i, v in pairs(self.equipEffUIBind) do
            ---回收特效
            for _, k in pairs(v) do
                SL:StopRoleEffect(true, self.meId, k)
            end
        end
    end
    self.equipEffBind = {}
    self.equipEffUIBind = {}
    self.meId = 0
    self.curEffStrength = 0
    self.canUIRole = false
end

function this:RefreshStrengthEff(effStrength)
    self.curEffStrength = effStrength
end

---设置装备部位特效绑定
---@param equipPart number 绑定部位
---@param bind boolean 是否绑定
function this:SetEquipEffBind(isUIRole, rid, equipPart, isBind, isCache)
    if isBind then
        if not isUIRole and isCache and self.equipEffBind[equipPart] then -- 已经存在绑定就不再绑定
            return
        end
        -- 绑定特效
        local effBone = equipEffBone[equipPart]
        local effects = {}
        for _, v in pairs(effBone) do
            local effect = SL:ReleaseRoleNodeMapEffect(isUIRole, rid, v.bone, v.effectId, nil, nil, isUIRole and 600 or 0)
            if effect and isCache then
                table.insert(effects, effect)
            end
        end
        if isCache then
            if isUIRole then
                self.equipEffUIBind[equipPart] = effects
            else
                self.equipEffBind[equipPart] = effects
            end
        end
    elseif isCache then
        local effects = self.equipEffBind[equipPart]
        if isUIRole then
            local effects = self.equipEffUIBind[equipPart]
            if effects == nil then
                return
            end
            for k, v in pairs(effects) do
                SL:StopRoleEffect(isUIRole, rid, v)
            end
            self.equipEffUIBind[equipPart] = nil
        end
        if effects == nil then
            return
        end
        ---回收特效
        for i, v in pairs(effects) do
            SL:StopRoleEffect(isUIRole, rid, v)
        end
        self.equipEffBind[equipPart] = nil
    end
end

---设置装备强化特效绑定
function this:SetStrengthEff(isUIRole, rid, strength, isBind, isCache)
    if isCache then
        local cacheEffects = self.equipEffBind[maxEffPart]
        if isUIRole then
            cacheEffects = nil
        end

        if cacheEffects then
            ---回收特效
            for _, v in pairs(cacheEffects) do
                SL:StopRoleEffect(isUIRole, rid, v)
            end
        end
        if not isUIRole then
            self.equipEffBind[maxEffPart] = nil
        else
            self.equipEffUIBind[maxEffPart] = nil
        end
    end

    if not isBind then return end

    for i, v in pairs(self.strengthEffs) do
        if v.lv == strength then
            if isBind then
                local effBone = equipEffBone[maxEffPart]
                local effects = {}
                for _, eff in pairs(v.pathList) do
                    local effect = SL:ReleaseRoleNodeMapEffect(isUIRole, rid, effBone.bone, eff, nil, nil,
                        isUIRole and 300 or 0)
                    if effect and isCache then
                        table.insert(effects, effect)
                    end
                end
                if isCache then
                    if isUIRole then
                        self.equipEffUIBind[maxEffPart] = effects
                    else
                        self.equipEffBind[maxEffPart] = effects
                    end
                    -- self.equipEffBind[maxEffPart] = effects
                end
            end
        end
    end
end

---设置神器特效绑定
function this:SetEquipDeifyEffBind(isUIRole, rid, equip, equipPart, isCache)
    if equip then
        local deifyLevel = EquipFunc.GetEquipDeifyLevel(equip)
        local cfg = SL:GetConfigTwoKeys('cfg_grai_distillation', equip.cfgId, deifyLevel, 'type', 'level')
        if #cfg.effectInfo > 0 then
            if isCache and self.equipEffBind[equipPart] then
                if self.equipEffBind[equipPart][equip.cfgId] then --已经存在特效就不绑定
                    return
                end
                self:SetEquipDeifyEffBind(isUIRole, rid, nil, equipPart, isCache)
            end
            local effects = {}
            for i, v in pairs(cfg.effectInfo) do
                local effect = SL:ReleaseRoleNodeMapEffect(isUIRole, rid, v[2], tonumber(v[1]), nil, nil,
                    isUIRole and 300 or 0)
                if effect and isCache then
                    table.insert(effects, effect)
                end
            end
            if isCache then
                self.equipEffBind[equipPart] = {
                    [equip.cfgId] = effects
                }
            end
        end
        return
    end

    if isCache then
        local equipEffs = self.equipEffBind[equipPart]
        if equipEffs == nil then
            return
        end
        for i, v in pairs(equipEffs) do
            for _, k in pairs(v) do
                SL:StopRoleEffect(isUIRole, rid, k)
            end
        end
        self.equipEffBind[equipPart] = nil
    end
end

---设置装备的特效
function this:SetEquipEff(isUIRole, rid, equips)
    local isMe = SL:GetMetaValue(EMetaVarGetKey.ACTOR_IS_MAINPLAYER, rid)
    if isMe then
        self.meId = rid
    end
    -- 找到最小强化等级
    local minStrength = 99999
    local equip
    local effectEquip = {}
    -- 检查装备强化孔位
    for i, v in pairs(checkEquipStrengthPart) do
        equip = nil
        for _, k in pairs(equips) do
            if k.index then
                local _, pos = SL:GetWearBarAndPosBaseEquipIndex(k.index)
                if pos == i then
                    equip = equips[k.index]
                    break
                end
            else
                equip = equips[i]
                break
            end
        end

        if equip then
            local strength = EquipFunc.GetEquipStrengthLevel(equip)
            minStrength = math.min(strength, minStrength)
        else
            minStrength = 0
            -- self:SetEquipEffBind(isUIRole, rid, i, false, isMe)
        end
    end

    -- 获取特效等级
    local effStrength = nil
    for i, v in ipairs(self.strengthEffs) do
        if minStrength >= v.lv then
            effStrength = v.lv
        end
    end
    local isShow = minStrength >= self.maxEffStrength

    for i, v in pairs(checkEquipStrengthPart) do
        self:SetEquipEffBind(isUIRole, rid, i, isShow, isMe)
    end

    if not isUIRole and isMe then
        if self.curEffStrength == effStrength then
            return
        end
        self.curEffStrength = effStrength
    end
    self:SetStrengthEff(isUIRole, rid, effStrength, not isMe or self.curEffStrength ~= nil, isMe)
end

function this:LUA_EVENT_LOGIN_MAP()
    self.canUIRole = true
end

function this:LUA_EVENT_EXIT_GAME()
    self.canUIRole = false
    self.equipEffBind = {}
    self.equipEffUIBind = {}
end

---角色模型加载完成
function this:LUA_EVENT_ROLEMODEL_ONLOAD_ALL(_, msg)
    if msg.RoleType ~= ERoleType.Player and msg.RoleType ~= ERoleType.Me then
        return
    end
    self:SetEquipEff(self.canUIRole and msg.data.isUI, msg.data.id, msg.data.equips)
end

---玩家装备数据变化
function this:LUA_EVENT_PLAYER_EQUIP_CHANGE(_, msg)
    if msg and msg.opera == 0 then
        return
    end
    --自己装备
    local equips = SL:GetWearBarsData(1)
    local rid = SL:GetMetaValue(EMetaVarGetKey.UID)
    self:SetEquipEff(false, rid, equips)
end

---装备强化成功
function this:LUA_EVENT_STRENGTH_OK()
    self:LUA_EVENT_PLAYER_EQUIP_CHANGE()
end

---单个模型加载完成
function this:LUA_EVENT_ROLEMODEL_SINGLE_ONLOAD(_, msg)
    --if msg.flag == "Wing" then
    --    local animator = msg.go:GetComponent(typeof(Animator))
    --    if IsNil(animator) then
    --        return
    --    end
    --    animator:SetTrigger("idle")
    --end
end
