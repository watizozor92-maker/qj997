RoleSetting = {}
local this = {}
local roleSettingKey = "T$role_type_value_settings"
local RoleSettingType = {
    enableCombo = 37, -- 是否开启连击显示
    showVip = 38, -- 是否开启VIP显示
    autoUseDrug = 39, -- 自动吃药比例
}

function RoleSetting.login(actor)
    sendluamsg(actor,LuaMessageIdToClient.RES_ROLE_SETTINGS, this.getStates(actor))
end

function RoleSetting.updateState(actor, msg)
    local type = msg.type or 0
    local value = msg.value
    for RoleType, typeValue in pairs(RoleSettingType) do
        if tonumber(type) == typeValue then
            local states = this.getStates(actor)
            states[type] = value
            setplaydef(actor, roleSettingKey, states)
        end
    end 
    sendluamsg(actor,LuaMessageIdToClient.RES_ROLE_SETTINGS, this.getStates(actor))
end

function this.getStates(actor)
    return getplaydef(actor, roleSettingKey) or {}
end


--- func desc 获取目标vip等级
---@param actor any
function RoleSetting.getTargetVipLv(actor, targetRids)
    if table.isNullOrEmpty(targetRids) then
        return
    end
    local info = {}
    for _, targetRid in ipairs(targetRids) do
        local lv = VipGiftPack.getTargetVipLv(actor, targetRid)
        info[targetRid] = lv
    end
    sendluamsg(actor, LuaMessageIdToClient.RES_TARGET_VIP_LV, info)
end