---@class UIHookInfo
UIHookInfo = class()
local this = UIHookInfo

function this:ctor()
end

function this:Reset()
    self.newMap = false
    self.hookReward = false
    this.checkOpen = true
    self.selectHookPointMapItem = nil
    self.autoPickUpText= ""
    self.playerPickRange = 8
    
    self.IsShowBagTips = false
end

function this:Init()
    self:InitData()
    self:RegistMessages()
end

function this:InitData()
    this.mapLvs = {}

    if SL.Head.SetHeadPartFontSize then
        local strList = string.split(SL:GetConfig("cfg_global",420001).value,"#")
        SL.Head:SetHeadPartFontSize(EHeadPart.Name_Part,tonumber(strList[1]))
        SL.Head:SetHeadPartScale(EHeadPart.Name_Part,tonumber(strList[2]),tonumber(strList[2]),tonumber(strList[2]))
        
    end 
   
    local tbl = SL:GetConfigTable("cfg_hanguppoints")
    ---@param v cfg_hanguppoints_column
    for _, v in pairs(tbl) do
        if not this.mapLvs[v.mapMoveID] then
            if SL:HasConfig("cfg_mapMove", v.mapMoveID) then
                ---@type cfg_mapMove_column
                local cfg = SL:GetConfig("cfg_mapMove", v.mapMoveID)
                this.mapLvs[v.mapMoveID] = cfg.level
            else
                SL:LogWarning("cfg_mapMove 表没有id为" .. v.mapMoveID .. "的值", "请检查cfg_hanguppoints 表mapMoveID字段 或cfg_mapMove表")
            end
        end    
    end
    self.newMap = false
    self.hookReward = false
    self.selectHookPointMapItem = nil
    self.IsShowBagTips = false
    this.checkOpen = true
end

function this:RegistMessages()
    SL:AddRedDotConditionFunc("checkHookNewMapAndReward",self.checkHookNewMapAndReward)
    SL:AddRedDotConditionFunc("checkHookReward",self.checkHookReward)
    SL:RegisterLUAEvent(LUA_EVENT_LEVELCHANGE, self.LUA_EVENT_LEVELCHANGE)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_OFFLINE_ON_HOOK_INFO, self.RES_OFFLINE_ON_HOOK_INFO)
    SL:RegisterLUAEvent(LUA_EVENT_ROLE_LOGIN, self.LUA_EVENT_ROLE_LOGIN)
    SL:RegisterLUAEvent(LUA_EVENT_ENTRY_MAP_LOADING_PANEL_CLOSE, self.LUA_EVENT_ENTER_MAP)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_PICK_ITEM_SETTING, self.RES_PICK_ITEM_SETTING, self)
end
function this:RES_PICK_ITEM_SETTING(_,message)
    if message then
        self.playerPickRange = message.playerPickRange
        self.autoPickUpText = message.filterNames
    end
end
function this.LUA_EVENT_ROLE_LOGIN(_, rid)
    local global = SL:GetConfig("cfg_global", 810001)
    local roles = SL:GetMetaValue(EMetaVarGetKey.PLAYER_CREATEROLE_HAVEROLE)
    if roles then
        for _, roleInfo in pairs(roles) do
            if roleInfo.rid == rid and roleInfo.level >= tonumber(global.value) then
                this.checkOpen = true
                SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_OFFLINE_ON_HOOK_INFO)
                break
            end
        end
    end
end

function this.LUA_EVENT_ENTER_MAP()
    if this.checkOpen then
        -- local tbl = SL:GetConfig("cfg_global", 810001)
        -- local needLv = tonumber(tbl.value)
        -- local myLv = SL:GetMetaValue(EMetaVarGetKey.LEVEL)
        -- if tonumber(myLv) >= needLv then
        --      GUI:UIPanel_Open("dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel", _, _, "HookInfoToggle", _, function()
        --          SL.HideMainPanel()
        --      end)
        -- end

        --[[GUI:UIPanel_Open("dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel", _, _, "HookInfoToggle", _, function()
            SL:HideMainPanel()
        end)]]
    end
    this.checkOpen = false
end
function this.checkHookNewMapAndReward()
    if this.newMap then
        return true
    end
    return this.checkHookReward()
end 

function this.checkHookReward()
    return this.hookReward
end 

function this.LUA_EVENT_LEVELCHANGE(_, level, old)
    for _, v in pairs(this.mapLvs) do
        if old < v and level >= v then
            this.newMap = true
            SL:RefreshPanelALLRedPoint("KLUISystemTopPanel")
            break
        end
    end
end

function this.RES_OFFLINE_ON_HOOK_INFO(id, message)
    this.hookReward = message.fightExp + message.freeExp > 0 and message.receiveExp == false
    SL:RefreshPanelALLRedPoint("KLOnHookPanel")
    SL:RefreshPanelALLRedPoint("KLUISystemTopPanel")
end

function this:SetNewMapRedClicked()
    this.newMap = false
    SL:RefreshPanelALLRedPoint("KLUISystemTopPanel")
end

function this:SetReceiveReward()
    self.receiveReward = true
end
