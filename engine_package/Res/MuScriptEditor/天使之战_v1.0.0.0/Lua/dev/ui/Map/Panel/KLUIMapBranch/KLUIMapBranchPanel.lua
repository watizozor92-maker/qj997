---@class KLUIMapBranchPanel:UIKmlLuaPanelBase
---@field view KLUIMapBranchPanelView
---@field mapBranchItemList KLMapBranchItem[]
---@field cfgLineInfo table<number,{mapInfoId:number,mapMoveId:number}>
local KLUIMapBranchPanel = class(UIKmlLuaPanelBase)
local this =KLUIMapBranchPanel
---创建时调用一次
function this:Init()
    
end

E_MapType = {
    Normal = enum(0),
    Gold = enum(1),
    NormalAndGold = enum(2),
}
---创建或者刷新界面数据时调用
function this:Refresh()
    ---@type cfg_map_line_column
    self.mapLineInfo = SL:GetConfig("cfg_map_line", SL:GetMetaValue(EMetaVarGetKey.MAP_ID))
    self.mapLine = SL:GetMetaValue(EMetaVarGetKey.MAP_LINE)
    ---@type cfg_mapMove_column
    self.mapMoveId = SL:GetConfigMultiKeys("cfg_mapMove", SL:GetMetaValue(EMetaVarGetKey.MAP_ID), "mapID").id
    self.cfgLineInfo = self:GetLineInfo()
    InfoManager.mainUIInfo.mapLine =  self.mapLine
    InfoManager.mainUIInfo.cfgLineInfo =  self:GetLineInfo()
    self.serverLineInfo = {}
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_MAP_INFO,self.cfgLineInfo[E_MapType.Normal].mapInfoId)
    if self:IsHasGoldLine() then
        GUI:setVisible(self.view.gold_toggle,true)
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_MAP_INFO,self.cfgLineInfo[E_MapType.Gold].mapInfoId)
    else
        GUI:setVisible(self.view.gold_toggle,false)
    end
    
    if self:CurrentIsInGoldMap() then
        self.select_type = E_MapType.Gold
        GUI:Toggle_setIsOn(self.view.gold_toggle,true)
    else
        self.select_type = E_MapType.Normal
        GUI:Toggle_setIsOn(self.view.normal_toggle,true)
    end

    self.mapBranchItemList = {}
    self.goldBranchItemList = {}
    GUI:ToggleGroup_AllowSwitChoff(self.view.switch_branch_togglegroup,true)
    
end

function this:RefreshLineState(currentLine,allLine,isGlod)
    local currentLineStr = "当前线路：%d"
    if isGlod and not self:CurrentIsInGoldMap() then
        GUI:Text_setString(self.view.currentLine_txt,string.format("当前线路：%d",0))
    elseif not isGlod and self:CurrentIsInGoldMap() then
        GUI:Text_setString(self.view.currentLine_txt,string.format(currentLineStr,0))
    else
        GUI:Text_setString(self.view.currentLine_txt,string.format(currentLineStr,currentLine))
    end
    local allLineLineStr = "线路总数：%d"
    GUI:Text_setString(self.view.allLine_txt,string.format(allLineLineStr,allLine))
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.closeBtn, self, self.CloseSelf)
    GUI:AddOnClickEvent(self.view.redName_btn, self, self.OpenRedNameTips)
    GUI:SetToggleOnValueChange(self.view.gold_toggle,self,self.ToggleGoldOnValueChange)
    GUI:SetToggleOnValueChange(self.view.normal_toggle,self,self.ToggleNormalOnValueChange)
    --SL:RegisterLuaNetMsg(MessageDef.ResThisMapLineInfoMessage, self.ResThisMapLineInfoMessage, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_MAP_INFO , self.RES_MAP_INFO , self)
end

---@param message OutMapProtos.LineInfo[]
function this:RES_MAP_INFO(_, message)
    if message then
        self:ChangeDataStruct(message)
        self:RefreshLineInfo(self.serverLineInfo[E_MapType.Normal])
        
--[[        local line = SL:GetConfig("cfg_map_info", message["1"].mapCfgId)
        local goldmap = line.goldmap
        if self.select_type ~= goldmap then
            return
        end
        if goldmap == E_MapType.Gold then
            if self.serverLineInfo[E_MapType.Gold] then
                self:RefreshLineInfo(self.serverLineInfo[E_MapType.Gold],true)
            end
        else
            self:RefreshLineInfo(self.serverLineInfo[E_MapType.Normal])
        end]]
    end
end

--[[---@param message MapProtos.MapLinesInfo
function this:ResThisMapLineInfoMessage(_, message)
    if message then
        self.mapLinesInfo = message
        self:RefreshLineInfo(message)
    end
end]]

---@param message OutMapProtos.LineInfo[]
function this:ChangeDataStruct(message)
    local data = {}
    local line = SL:GetConfig("cfg_map_info", message["1"].mapCfgId)
    local isGold = line.goldmap == 1
    for i, v in pairs(message) do
        if isGold then
            if not self.serverLineInfo[E_MapType.Gold] then
                self.serverLineInfo[E_MapType.Gold] = {}
            end
            self.serverLineInfo[E_MapType.Gold][tonumber(v.line)] = v
        else
            if not self.serverLineInfo[E_MapType.Normal] then
                self.serverLineInfo[E_MapType.Normal] = {}
            end
            self.serverLineInfo[E_MapType.Normal][tonumber(v.line)] = v
        end
    end
    return data
end

---@param message OutMapProtos.LineInfo[]
function this:RefreshLineInfo(message,isGlod)
    if message then

        self:RefreshLineState(SL:GetMetaValue(EMetaVarGetKey.MAP_LINE),#message,isGlod)

        --table.sort(message, function(a,b)
        --    return a.line < b.line
        --end)
        local maxCount = self.mapLineInfo.lineState[#self.mapLineInfo.lineState]
        --local sliderCount = self:GetSliderCount(self.mapLineInfo.sidelineCount)
        --maxCount = maxCount * sliderCount
        for i, v in ipairs(self.mapBranchItemList) do
            v:HideItemUI()
        end
        for i, v in ipairs(self.serverLineInfo[E_MapType.Normal]) do
            local showCondition,entryCondition = SL:LineCondition(v.mapCfgId,v.line)
            if ConditionManager.Check4D(showCondition) then
                if not self.mapBranchItemList[i] then
                    self.mapBranchItemList[i] = GUI:UIPanel_Open("dev/ui/Map/Item/KLMapBranch/KLMapBranchItem",self.view.branch_layout,self,nil,true)
                end
                self.mapBranchItemList[i]:RefreshUI(self.cfgLineInfo[E_MapType.Normal][i], v.playerCount, maxCount,false,self.mapLineInfo.pkline,self.mapLineInfo.id,entryCondition,self.mapLineInfo.lineName[i])
                self.mapBranchItemList[i]:SetOnValueChange(self.ToggleChangeEvent, self)
            end
        end
        
        if self.serverLineInfo[E_MapType.Gold] then
            for i, v in ipairs(self.goldBranchItemList) do
                v:HideItemUI()
            end
            for i, v in ipairs(self.serverLineInfo[E_MapType.Gold]) do
                local showCondition,entryCondition = self:LineCondition(v.mapCfgId,v.line)
                if ConditionManager.Check4D(showCondition) then
                    if not self.goldBranchItemList[i] then
                        self.goldBranchItemList[i] = GUI:UIPanel_Open("dev/ui/Map/Item/KLMapBranch/KLMapBranchItem",self.view.branch_layout,self,nil,true)
                    end
                    self.goldBranchItemList[i]:RefreshUI(self.cfgLineInfo[E_MapType.Gold][i], v.playerCount, maxCount,true,self.mapLineInfo.pkline,self.mapLineInfo.id,entryCondition)
                    self.goldBranchItemList[i]:SetOnValueChange(self.ToggleChangeEvent, self)
                end
            end
        end
        
--[[        if not isGlod then
            self.select_type = E_MapType.Normal 
            for i, v in ipairs(message) do
                
                if not self.mapBranchItemList[i] then
                    self.mapBranchItemList[i] = GUI:UIPanel_Open("dev/ui/Map/Item/KLMapBranch/KLMapBranchItem",self.view.branch_layout,self,nil,true)
                end
                self.mapBranchItemList[i]:RefreshUI(self.cfgLineInfo[E_MapType.Normal][i], v.playerCount, maxCount,false,self.mapLineInfo.pkline,self.mapLineInfo.id)
                self.mapBranchItemList[i]:SetOnValueChange(self.ToggleChangeEvent, self)
            end
        else
            self.select_type = E_MapType.Gold 
            for i, v in ipairs(message) do
                i = tonumber(i)
                if not self.mapBranchItemList[i] then
                    self.mapBranchItemList[i] = GUI:UIPanel_Open("dev/ui/Map/Item/KLMapBranch/KLMapBranchItem",self.view.branch_layout,self,nil,true)
                end
                self.mapBranchItemList[i]:RefreshUI(self.cfgLineInfo[E_MapType.Gold][i], v.playerCount, maxCount,true,self.mapLineInfo.pkline,self.mapLineInfo.id)
                self.mapBranchItemList[i]:SetOnValueChange(self.ToggleChangeEvent, self)
            end
        end]]
    end
end
function this:GetSliderCount(sidelineCount)
    local openTime = SL:GetOpenServerDay()
    for _,v in pairs(sidelineCount) do
        if openTime >= v[1] and openTime <= v[2] then
            return v[3]
        end
    end
    return 1
end
function this:ToggleNormalOnValueChange(_,_,value)
    if value[1] then
        self:RefreshLineInfo(self.serverLineInfo[E_MapType.Normal])
    end
end

function this:ToggleGoldOnValueChange(_,_,value)
    if value[1] then
        self:RefreshLineInfo(self.serverLineInfo[E_MapType.Gold],true)
    end
end

function this:ToggleChangeEvent(_, eventData)
    self.mapLine = eventData.data
    InfoManager.mainUIInfo.mapLine = eventData.data
end

function this:CloseSelf()
    GUI:UIPanel_Close("dev/ui/Map/Panel/KLUIMapBranch/KLUIMapBranchPanel")
    SL.ShowMainPanel()
end

function this:SwitchBranchClick(isGoldMap)
    SL:ClearOnArriveCallBack()
    SL:showTransferAnimation()
    SL:ScheduleOnce(0.8, function()
        if isGoldMap then
            SL:ReqTransfer(nil,InfoManager.mainUIInfo.mapLine,InfoManager.mainUIInfo.cfgLineInfo[E_MapType.Gold].mapMoveId,{type = 1})
            --SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_MAP_MOVE_TRANSFER, {id = InfoManager.mainUIInfo.cfgLineInfo[E_MapType.Gold].mapMoveId, line = InfoManager.mainUIInfo.mapLine})
            --SL:MapTransfer(nil,InfoManager.mainUIInfo.mapLine,InfoManager.mainUIInfo.cfgLineInfo[E_MapType.Gold].mapMoveId)
        else
            SL:ReqTransfer(nil,InfoManager.mainUIInfo.mapLine,InfoManager.mainUIInfo.cfgLineInfo[E_MapType.Normal].mapMoveId,{type = 1})
            --SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_MAP_MOVE_TRANSFER, {id = InfoManager.mainUIInfo.cfgLineInfo[E_MapType.Normal].mapMoveId, line = InfoManager.mainUIInfo.mapLine})
            --SL:MapTransfer(nil,InfoManager.mainUIInfo.mapLine,InfoManager.mainUIInfo.cfgLineInfo[E_MapType.Normal].mapMoveId)
        end
    end)
    --MapTransfer
    self:CloseSelf()
end

function this:OpenRedNameTips()
    local helpCfg=SL:GetConfig("cfg_rule_text",4)
    if helpCfg then
        SL:CommonStrTipsMessage({title =helpCfg.menutxt,str=helpCfg.location})
    end
end

function this:GetLineInfo()
    local lineInfo = {}
    ---@type cfg_mapMove_column
    local mapMoveCfg = SL:GetConfigMultiKeys("cfg_mapMove", SL:GetMetaValue(EMetaVarGetKey.MAP_ID), "mapID")
    if mapMoveCfg.goldgroup == 0 then
        local map_line_table = SL:GetConfig("cfg_map_line",mapMoveCfg.mapID)
        lineInfo[E_MapType.Normal] = map_line_table.mapLine
        lineInfo[E_MapType.Normal].mapMoveId = mapMoveCfg.id
        lineInfo[E_MapType.Normal].mapInfoId = mapMoveCfg.mapID
        --lineInfo[E_MapType.Normal].map_line_table = map_line_table
    else
        ---@type cfg_mapMove_column[]
        local cfgs = SL:FindConfigs("cfg_mapMove","goldgroup",mapMoveCfg.goldgroup)
        for i, v in pairs(cfgs) do
            ---@type cfg_map_info_column
            local info = SL:GetConfig("cfg_map_info",v.mapID)
            if info.goldmap == 0 then
                lineInfo[E_MapType.Normal] = SL:GetConfig("cfg_map_line",v.mapID).mapLine
                lineInfo[E_MapType.Normal].mapMoveId = v.id
                lineInfo[E_MapType.Normal].mapInfoId = v.mapID
                --lineInfo[E_MapType.Normal].map_line_table = SL:GetConfig("cfg_map_line",v.mapID)
            else
                lineInfo[E_MapType.Gold] = SL:GetConfig("cfg_map_line",v.mapID).mapLine
                lineInfo[E_MapType.Gold].mapMoveId = v.id
                lineInfo[E_MapType.Gold].mapInfoId = v.mapID
                --lineInfo[E_MapType.Gold].map_line_table = SL:GetConfig("cfg_map_line",v.mapID)
            end
        end
    end
    return lineInfo
end
function this:LineCondition(mapID,lineId)
    local showCondition = ""
    local entryCondition =""
    local map_line_table = SL:GetConfig("cfg_map_line",mapID)
    if map_line_table then
        local showStr = map_line_table.showCondition
        local showStrList = string.split(showStr,'|')
        for _,strInput in pairs(showStrList) do
            local char = strInput:sub(1, 1)
            if char == lineId then
                showCondition = strInput:sub(3, string.len(strInput))
            end
        end

        local showStr2 = map_line_table.entryCondition
        local showStrList2 = string.split(showStr2,'|')
        for _,strInput in pairs(showStrList2) do
            local char = strInput:sub(1, 1)
            if char == lineId then
                entryCondition = strInput:sub(3, string.len(strInput))
            end
        end
    end
    return showCondition,entryCondition
end

function this:IsHasGoldLine()
    if self.cfgLineInfo[E_MapType.Gold] then
        return true
    end
    return false
end

function this:CurrentIsInGoldMap()
    ---@type cfg_map_info_column
    local infoCfg = SL:GetConfig("cfg_map_info",tonumber(SL:GetMetaValue(EMetaVarGetKey.MAP_ID)))
    return infoCfg.goldmap == 1
end

function this:Close()
    self.serverLineInfo = nil
end

return this
