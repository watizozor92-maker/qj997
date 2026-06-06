---@class UnionBossInfo
---@field inChallengeBoss boolean @是否正在挑战boss
UnionBossInfo = class()
local this = UnionBossInfo
local UnionBossTaskPanelPath = "dev/outui/Union/Panel/KLUnionBossTask/KLUnionBossTaskPanel"

function this:Init()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_WAR_ALLIANCE_TASK_INFO,self.RES_WAR_ALLIANCE_TASK_INFO,self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_WAR_ALLIANCE_STATE_INFO,self.RES_WAR_ALLIANCE_STATE_INFO,self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_WAR_ALLIANCE_EXIT,self.RES_WAR_ALLIANCE_EXIT,self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_WAR_ALLIANCE_OPEN_AUCTION,self.RES_WAR_ALLIANCE_OPEN_AUCTION,self)
    SL:RegisterLUAEvent(LUA_EVENT_UNION_APPLICATION_LIST, self.LUA_EVENT_UNION_APPLICATION_LIST, self)
end

function this:RES_WAR_ALLIANCE_OPEN_AUCTION()
    ---@type KLPopoverPanel
    local popoverPanel = GUI:GetUI("dev/ui/Preview/Panel/KLPopover/KLPopoverPanel")
    popoverPanel:SetPopoverData(17)
    popoverPanel:RefreshUI()
end


function this:RES_WAR_ALLIANCE_EXIT()
    ---@type KLUILeftUpPanel
    local leftUpPanel = GUI:GetUI("dev/ui/MainUI/Panel/KLUILeftUp/KLUILeftUpPanel")
    leftUpPanel:HookTaskPanel(nil)
    self.inChallengeBoss = false
    GUI:UIPanel_Close(UnionBossTaskPanelPath)
end

function this:RES_WAR_ALLIANCE_STATE_INFO(_,message)
    self.dupEndTime = tonumber(message["2"])
    if message["1"] == 3 then
        self:RES_WAR_ALLIANCE_EXIT()
    end
end

function this:RES_WAR_ALLIANCE_TASK_INFO(_,message)
    self.inChallengeBoss = true
    ---@type KLUILeftUpPanel
    local leftUpPanel = GUI:GetUI("dev/ui/MainUI/Panel/KLUILeftUp/KLUILeftUpPanel")
    leftUpPanel:HookTaskPanel(self:GetUnionBossTaskPanel(message))
    
    --隐藏地图传送点
    local config = SL:GetConfig("cfg_repGlobal",14001003).value
    local transPoints = string.split(config,"|")
    local p = message.nowCount >= message.totalCount and 1 or 0
    ---@type KLMiniMapPanel
    local minimapPanel = GUI:GetUI("dev/ui/Map/Panel/KLMiniMap/KLMiniMapPanel")
    if minimapPanel then
        for i = 1, #transPoints do
            local transPointId = string.split(transPoints[i],"#")[2]
            minimapPanel:SetMapIconVisible("MapTransferIcon" .. transPointId,i < p + message.phrase)
        end
    end

end

function this:GetUnionBossTaskPanel(message)
    local panel = GUI:GetUI(UnionBossTaskPanelPath)
    if not panel then
        panel = GUI:UIPanel_Open(UnionBossTaskPanelPath)
    end
    panel:SetData(message)
    return panel
end

function this:Reset()
    
end


-----------战盟申请列表--start-----------
function this:LUA_EVENT_UNION_APPLICATION_LIST()
    local ApplyListInfo = SL.Union:GetApplyListInfo()
    self.checkUnionReqRed = false
    if ApplyListInfo and ApplyListInfo.applyInfo and table.count(ApplyListInfo.applyInfo) > 0 then
        self.checkUnionReqRed = true
    end
    SL:RefreshPanelALLRedStateKmlByCondition("checkUnionReq")
end

function this:checkUnionReq()
    return self.checkUnionReqRed or false
end
-----------战盟申请列表--end-----------