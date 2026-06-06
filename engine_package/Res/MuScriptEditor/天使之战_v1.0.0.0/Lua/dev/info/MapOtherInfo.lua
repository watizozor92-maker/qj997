---@class MapOtherInfo 地图其他信息
MapOtherInfo = class()
local this = MapOtherInfo

function this:ctor()
    
end

function this:Init()
    self:RegistMessages()
end

function this:Reset()
end

function this:RegistMessages()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_THROWS_ITEM_TRANSFER, self.RES_THROWS_ITEM_TRANSFER, self)
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_MAPPOS_CHANGE, self.LUA_EVENT_PLAYER_MAPPOS_CHANGE,self)
    SL:RegisterLUAEvent(LUA_EVENT_ENTER_MAP, self.LUA_EVENT_ENTER_MAP, self)
end

---响应：丢道具传送
function this:RES_THROWS_ITEM_TRANSFER()
    if self.openTransfer then
        return
    end
    SL:CreateSceneItemModel("Effect/Scene/bingfenggu_chuansongmen.prefab", function(res)
        
        if self.transferEffect then
            SL:RecycleSceneItemModel(self.transferEffect)
            self.transferEffect = nil
        end
        self.transferEffect = res
        
        self.openTransfer = true
        ---@type Dot2
        local mePos = SL:MeData_GetCoord()
        local transferPointX, transferPointY = self:GetTransformPoint(mePos)
        self.transferPointDot = Dot2.New(transferPointX, transferPointY)
        --SL:LogError("传送点坐标："..self.transferPointDot.x..","..self.transferPointDot.z)
        self.transferEffect.transform.localPosition = Vector3.New(transferPointX + 1, 2.7, transferPointY - 1)
        local recycleTime = tonumber(SL:GetConfig("cfg_global", 540002).value)
        self.transferEffectTimer = SL:ScheduleOnce(recycleTime, function()
            self:RecycleSceneItem()
        end)
    end)
end

---进入地图
function this:LUA_EVENT_ENTER_MAP()
    if self.openTransfer then
        self:RecycleSceneItem()
    end
end

function this:RecycleSceneItem()
    if self.transferEffect then
        SL:UnSchedule(self.transferEffectTimer)
        SL:RecycleSceneItemModel(self.transferEffect)
        self.transferEffect = nil
        self.openTransfer = false
        self.transferEffectTimer = nil
    end
end

---获取传送点坐标
---@param mePos Dot2
function this:GetTransformPoint(mePos)
    if not SL:GetMetaValue(EMetaVarGetKey.MAP_IS_OBSTACLE, mePos.x - 1, mePos.z + 1) then -- 上
        return mePos.x - 1, mePos.z + 1
    end
    if not SL:GetMetaValue(EMetaVarGetKey.MAP_IS_OBSTACLE, mePos.x, mePos.z + 1) then -- 右上
        return mePos.x, mePos.z + 1
    end
    if not SL:GetMetaValue(EMetaVarGetKey.MAP_IS_OBSTACLE, mePos.x + 1, mePos.z + 1) then -- 右
        return mePos.x + 1, mePos.z + 1
    end
    if not SL:GetMetaValue(EMetaVarGetKey.MAP_IS_OBSTACLE, mePos.x + 1, mePos.z) then -- 右下
        return mePos.x + 1, mePos.z
    end
    if not SL:GetMetaValue(EMetaVarGetKey.MAP_IS_OBSTACLE, mePos.x + 1, mePos.z - 1) then -- 下
        return mePos.x + 1, mePos.z - 1
    end
    if not SL:GetMetaValue(EMetaVarGetKey.MAP_IS_OBSTACLE, mePos.x, mePos.z - 1) then -- 左下
        return mePos.x, mePos.z - 1
    end
    if not SL:GetMetaValue(EMetaVarGetKey.MAP_IS_OBSTACLE, mePos.x - 1, mePos.z - 1) then -- 左
        return mePos.x - 1, mePos.z - 1
    end
    if not SL:GetMetaValue(EMetaVarGetKey.MAP_IS_OBSTACLE, mePos.x - 1, mePos.z) then -- 左上
        return mePos.x - 1, mePos.z
    end
    
    return mePos.x, mePos.z
end

---玩家位置改变
function this:LUA_EVENT_PLAYER_MAPPOS_CHANGE()
    if not self.openTransfer then
        return
    end
    ---@type Dot2
    local mePos = SL:MeData_GetCoord()
    if Dot2.Distance(mePos, self.transferPointDot) < 0.1 then
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_THROWS_ITEM_TRANSFER)
    end
end
