---@class BingFengBaoInfo
BingFengBaoInfo = class()
local this = BingFengBaoInfo
local BFG_OCCUPY_POSITION = 670007          -- 冰风堡攻城战占领坐标，地图id#X#Y#width#height
local BFG_POSITION_POSITION = 670008          -- 冰风堡地图传送数据，地图id##x#y#6

function this:ctor()

end

function this:Reset()
    self.data = {}
    self.init = true
    self.red_state = false
    self.redCheckStr = "checkADamo"
    self:RecoverEffect()
end

function this:Init()
    self:Reset()
    local value = SL:GetConfig("cfg_global", BFG_OCCUPY_POSITION).value
    self.occupyConfig = ToolFunc.AnalysisStr(value,nil,{"#"})
    
    local posValue = SL:GetConfig("cfg_global", BFG_POSITION_POSITION).value
    self.config = ToolFunc.AnalysisStr(posValue,nil,{"#"})
    self:RegistMessages()
end

function this:RegistMessages()
   SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_BING_FENG_BAO,self.msgData,self) 
   SL:RegisterLUAEvent(LUA_EVENT_MAIN_PLAYER_DIE,self.LUA_EVENT_MAIN_PLAYER_DIE,self) 
   SL:RegisterLUAEvent(LUA_EVENT_ENTER_MAP,self.LUA_EVENT_ENTER_MAP,self)
end

function this:LUA_EVENT_ENTER_MAP(_,msgData)
    local path = "dev/outui/Activity/Panel/KLBingFengBaoButton/KLBingFengBaoButtonPanel"
    local isInBingFengMap = self:IsInBingFengMap()
    if not isInBingFengMap then
        GUI:UIPanel_Close(path)
    end
end

function this:LUA_EVENT_MAIN_PLAYER_DIE(_,msgData)
    local isInBingFengMap = self:IsInBingFengMap()
    if not isInBingFengMap then
        return
    end
    self.open = false
    self:refresh_PanelInfo(self.open)
end

function this:IsInBingFengMap()
    local mapLine = SL:GetMetaValue(EMetaVarGetKey.MAP_LINE)
    local mapId = SL:GetMetaValue(EMetaVarGetKey.MAP_ID)
    return (mapLine == self.config[4] and mapId == self.config[1])
end

function this:msgData(msgId,msgData)
    local path = "dev/outui/Activity/Panel/KLBingFengBaoButton/KLBingFengBaoButtonPanel"
    local ui = GUI:GetUI(path)
    local isInBingFengMap = self:IsInBingFengMap()
    if not isInBingFengMap then
        GUI:UIPanel_Close(path)
    end
    
    if msgData.sendType == 10 then  --打开/关闭占领按钮
        self.open = msgData.open
        if self.open then
            if not ui then 
                GUI:UIPanel_Open(path,nil,nil,{open = self.open})
            end
        else
            if ui and not self.data.isOpen then 
                GUI:UIPanel_Close(path)
            end
        end

        self:refresh_PanelInfo(self.open)
    elseif msgData.sendType == 998 then
        self.data = ToolFunc:tblkeytonumber(msgData.data)
        self:refresh_PanelInfo(self.open)
    elseif msgData.sendType == 999 then
        self.data = ToolFunc:tblkeytonumber(msgData.data)
    end

    local mapLine = SL:GetMetaValue(EMetaVarGetKey.MAP_LINE)
    local mapId = SL:GetMetaValue(EMetaVarGetKey.MAP_ID)
    local isInBingFengMap = (mapLine == self.config[4] and mapId == self.config[1])
    if (self.data.isOpen and self.data.isOpen) and isInBingFengMap and SL:GetMetaValue(EMetaVarGetKey.MAP_LINE) == 6 and not self.effect then
        self.effect = true
        
        local path = SL:GetConfig("cfg_global", 670011).value
        SL:CreateSceneItemModel(path, function(res)
            self.effect = res
            res.transform:SetLocalPosition(226, 1.7, 237.12)
            res.transform:SetLocalScale(4.5, 9.13, 4.5)
            
        end)
    end

    if (self.data and not self.data.isOpen and isInBingFengMap) then
        GUI:UIPanel_Close(path)
        self:RecoverEffect()
    end
end

function this:RecoverEffect()   
    if self.effect and type(self.effect) ~= "boolean" then
        SL:RecycleSceneItemModel(self.effect)
        self.effect = nil
    end
end

function this:refresh_PanelInfo(open)
    --刷新对应界面
    local path = "dev/outui/Activity/Panel/KLBingFengBaoButton/KLBingFengBaoButtonPanel"
    local ui = GUI:GetUI(path)
    if ui then
        ui:Refresh(open)
    else
        GUI:UIPanel_Open(path,nil,nil,{open = open})
    end
end

--玩家是否在占领区域
function this.CheckActorIsInZhanLingQv(actor)
    local isIn = false
    local starX = self.occupyConfig[2]
    local starY = self.occupyConfig[3]
    local width = self.occupyConfig[4]
    local height = self.occupyConfig[5]
    local pos= SL:MeData_GetCoord()
    
    if pos.x >= starX and pos.x <= starX + width and pos.y >= starY and pos.y <= starY + height then
        isIn = true
    end
    return isIn
end









