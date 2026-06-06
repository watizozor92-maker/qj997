---@class UIFruitInfo @注释
UIFruitInfo = class()
local this = UIFruitInfo

function this:ctor()

end

function this:Init()
    self:Reset()
    self:InitData()
    self:RegistMessages()
end

function this:InitData()
end

function this:RegistMessages()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.C_USE_FRUIT_RESULT,self.C_USE_FRUIT_RESULT,self)

    SL:RegisterLUAEvent(LUA_EVENT_BAG_CHANGE_AFTER,self.LUA_EVENT_BAG_CHANGE_AFTER,self)
end

function this:C_USE_FRUIT_RESULT(_,message)
    if message then
        ---分配点数
        self.distributionPoint = message["totalFirstLevelAttrs"] and message["totalFirstLevelAttrs"] or 0
        if self.isFirstOpenGame then
            self.isFirstOpenGame = false
            SL:RefreshPanelALLRedPoint("KLAttrPanel")   
        end
    end
end

function this:LUA_EVENT_BAG_CHANGE_AFTER(id,message)
    if not message then
        return
    end
    SL:RefreshPanelALLRedPoint("KLAttrPanel")
end

---是否有果实可使用
function this:IsFruitCanUse()
    if SL:MeData_Check() then
        ---@type cfg_global_column
        local cfg = SL:GetConfig("cfg_global",3003)
        if SL:MeData_GetLevel() < tonumber(cfg.value) then--是否满足开放等级
            return false
        end
        local items = SL:GetMetaValue(EMetaVarGetKey.STD_ITEMS)
        if items and #items > 0 then
            for i, v in pairs(items[1]) do
                if SL:HasConfig("cfg_item",v.cfgId) then
                    ---@type cfg_item_column
                    local item = SL:GetConfig("cfg_item",v.cfgId)
                    if item.type == 3 and item.subType == 99 and SL:HasConfig("cfg_fruit",v.cfgId) then--是否满足果实类型并且果实表中是否配了
                        ---@type cfg_fruit_column
                        local fruitCfg = SL:GetConfig("cfg_fruit",v.cfgId)
                        if SL:HasConfig("cfg_att_info",fruitCfg.attribute) then
                            ---@type cfg_att_info_column
                            local attCfg = SL:GetConfig("cfg_att_info",fruitCfg.attribute)
                            if attCfg.base == 1 then --1级属性需要满足点数未达上限方可显示红点
                                if self.fruitMaxNum > self.distributionPoint then
                                    return true
                                end
                            else
                                return true
                            end
                        end
                    end
                end
            end
        end
        return false
    end

    return false
end

function this:Reset()
    ---果实点数上限
    self.fruitMaxNum = tonumber(SL:GetConfig("cfg_global",3001).value)
    self.distributionPoint = 0
    ---第一次进入游戏
    self.isFirstOpenGame = true
end 