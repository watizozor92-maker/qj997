PickUpItem = {}
local this = {}

function PickUpItem.sendSettings(actor)
    local msg = this.getSettings(actor)
    sendluamsg(actor, LuaMessageIdToClient.RES_PICK_ITEM_SETTING, msg)
end

function this.getSettings(actor)
    local extPickUpSetting = getinnerusedextdata(actor, "extPickUpSetting") or {}
    local pickNames = extPickUpSetting.filterNames or {}
    local filterNames = ""
    if pickNames and #pickNames > 0 then
        filterNames = table.concat(pickNames, "，")
    end
    local value = ConfigDataManager.getTableValue("cfg_global", "value", "id", 230)
    value = string.tonumber(value)
    local playerPickRange = extPickUpSetting.playerPickRange or value
    local msg = { playerPickRange = playerPickRange, filterNames = filterNames }
    return msg
end

function PickUpItem.setPickName(actor, msg)
    local names = msg.filterNames or ""
    names = string.gsub(names, "，", ",")
    names = string.gsub(names, '^"?(.-)"?$', '%1')
    local v = string.split(names, ",")
    local filterNames = {}
    for i, name in ipairs(v) do
        local trimmedName = string.trim(name)
        if trimmedName ~= "" then
            table.insert(filterNames, trimmedName)
        end
    end
    local value = ConfigDataManager.getTableValue("cfg_global", "value", "id", 230)
    value = string.tonumber(value)
    local playerPickRange = math.floor(msg.playerPickRange or value)
    setinnerusedextdata(actor, { extPickUpSetting = { filterNames = filterNames, playerPickRange = playerPickRange } })
end

LoginEventListerTable:eventLister("0", "道具拾取", PickUpItem.sendSettings)
MessageRouter:register(LuaMessageIdToSever.REQ_GET_PICK_UP_SETTINGS, PickUpItem.sendSettings)
