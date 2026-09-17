---@class KLNewTopMapPanel:UIKmlLuaPanelBase
---@field view KLNewTopMapPanelView
local KLNewTopMapPanel = class(UIKmlLuaPanelBase)
local this =KLNewTopMapPanel

local PkModeToSrc = {
    [EPKMode_Out.AllAttack] = 'btn_quanbu',
    [EPKMode_Out.Peace] = 'btn_heping',
    [EPKMode_Out.Team] = 'btn_duiwu',
    [EPKMode_Out.Union] = 'btn_zhanmeng',
}

---创建时调用一次
function this:Init()
    GUI:SetZIndex(self.view.maptransfer_panel, 5000)
    GUI:setVisible(self.view.maptransfer_panel, false)
    GUI:setVisible(self.view.open_transfer2, true)
    GUI:setVisible(self.view.open_transfer, false)
    self.TransPoint = {}
    self.IsTrans=false
    self.buffInfoList = {}
    self.pkModeTemplateList = {}
    self.MapBtnPointTempList = {}
    ---@type MapMoveListItemData[]
    self.mapMoveListData = {}
    ---@type cfg_mapMove_column[]
    local mapMoveTabList = SL:GetConfigTable("cfg_mapMove")
    for _, v in pairs(mapMoveTabList) do
        if SL:CheckCalculateConditionGroup(v.mapUIShow) then
            if v.group and v.group ~= 0 then
                --如果有分组
                if not self.mapMoveGroup[v.group] then
                    self.mapMoveGroup[v.group] = {}

                    ---@type MapMoveListItemData
                    local item = {}
                    item.isGroup = true
                    item.data = v
                    item.isRoot = true
                    table.insert(self.mapMoveListData, item)
                end
                ---@type MapMoveListItemData
                local item = {}
                item.isGroup = false
                item.data = v
                item.isRoot = false
                table.insert(self.mapMoveGroup[v.group], item)
            else
                ---@type MapMoveListItemData
                local item = {}
                item.isGroup = false
                item.data = v
                item.isRoot = true
                table.insert(self.mapMoveListData, item)
            end

        end
    end
    --填充children
    for _, v in pairs(self.mapMoveListData) do
        if v.isGroup then
            v.children = self.mapMoveGroup[v.data.group]
        end
    end
    GUI:OSAScrollView_Initialized(self.view.TransferScrollView, self.TransferItemGetFun, self.TransferItemUpdateFun, self)
    GUI:OSAScrollView_SetItemSizeGetFun(self.view.TransferScrollView, self.TransferItemSizeGetFun, self)

    --self:OnClick_ShowBuff()
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.Btn_SwitchLine, self, self.OnClick_Btn_SwitchLine)
    GUI:AddOnClickEvent(self.view.btn_autoFight, self, self.OnClick_AutoFight)
    GUI:AddOnClickEvent(self.view.btn_onHook, self, self.OnClick_OnHook)
    GUI:AddOnClickEvent(self.view.btn_changeLine, self, self.OnClick_Btn_SwitchLine)
    GUI:AddOnClickEvent(self.view.btn_openMap, self, self.OnClick_OpenMap)
    GUI:AddOnClickEvent(self.view.btn_showBuff, self, self.OnClick_ShowBuff)
    GUI:AddOnClickEvent(self.view.Btn_AtkModeCloseMask, self, self.Btn_AtkModeCloseMaskOnClick)
    GUI:AddOnClickEvent(self.view.btn_pkMode, self, self.OnClickAtkModelMenuToggle)
    GUI:AddOnClickEvent(self.view.close_transfer,self, self.CloseTransferPanel)
    GUI:AddOnClickEvent(self.view.open_transfer,self, function()
        GUI:SetActive(self.view.btnBg,true)
        GUI:SetActive(self.view.open_transfer,false)
        GUI:SetActive(self.view.open_transfer2,true)
    end)    
    GUI:AddOnClickEvent(self.view.open_transfer2,self, function()
        GUI:SetActive(self.view.btnBg,false)
        GUI:SetActive(self.view.open_transfer2,false)
        GUI:SetActive(self.view.open_transfer,true)
    end)
    
    --SL:RegisterLUAEvent(LUA_EVENT_PLAYER_MAPPOS_CHANGE,self.OnPlayerMapPosChange,self)
    SL:RegisterLUAEvent(LUA_EVENT_MAPINFOCHANGE,self.LUA_EVENT_NPC_LEAVE_NEAR,self)  --切换不同地图
    SL:RegisterLUAEvent(LUA_EVENT_FIGHTEND,self.LUA_EVENT_FIGHTEND,self)
    SL:RegisterLUAEvent(LUA_EVENT_CHANGESCENE, self.RefreshMapLineBtn, self)  --地图改变
    SL:RegisterLUAEvent(LUA_EVENT_LOGIN_MAP, self.RefreshMapLineBtn, self)  --地图改变
    SL:RegisterLUAEvent(LUA_EVENT_ONHOOK_STATE_CHANGE,self.LUA_EVENT_ONHOOK_STATE_CHANGE,self)  --切换挂机模式
    SL:RegisterLUAEvent(LUA_EVENT_BUFFCHANHE, self.RefreshBuff, self)--主角buff改变事件
    SL:RegisterLUAEvent(LUA_EVENT_MAIN_PLAYER_DIE, self.LUA_EVENT_MAIN_PLAYER_DIE, self) --主角死亡
    --SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, self.LUA_EVENT_CLOSEWIN, self)---buff界面关闭
    --SL:RegisterLUAEvent(LUA_EVENT_PKMODE_CHANGE, self.LUA_EVENT_PKMODE_CHANGE, self)--战斗模式切换
    --SL:RegisterLUAEvent(LUA_EVENT_SWITCH_PKMODE, self.LUA_EVENT_SWITCH_PKMODE, self)---战斗模式切换
    --SL:RegisterLUAEvent(LUA_EVENT_CROSS_SERVER_PK_MODE, self.LUA_EVENT_CROSS_SERVER_PK_MODE, self)---跨服战斗模式切换
    SL:RegisterLUAEvent(LUA_EVENT_LEVELCHANGE, self.LUA_EVENT_LEVELCHANGE, self)--主角等级改变事件
end

function this:LUA_EVENT_LEVELCHANGE()
    self:RefreshPlayerInfo()
end

function this:OnClickAtkModelMenuToggle()
    self:RefreshPKModeItem()
end

function this:Btn_AtkModeCloseMaskOnClick()
    GUI:setVisible(self.view.AtkModePanel, false)
    GUI:setVisible(self.view.AtkModeClosePanel, false)
end

function this:OnClickBuffMenuexpandBtn()
    --GUI:setVisible(self.view.buffMenufoldBtn, true)
    GUI:UIPanel_Close("dev/ui/MainUI/Panel/KLUIBuffInfoList/KLUIBuffInfoListPanel")
    GUI:Image_loadTexture(self.view.btn_showBuff,"BUFF","Atlas/NewMainPanel.spriteatlas")
end

function this:LUA_EVENT_CLOSEWIN(id,panelName)
    if panelName == "KLUIBuffInfoListPanel" then
        self:OnClickBuffMenuexpandBtn()
    end
end

function this:LUA_EVENT_MAIN_PLAYER_DIE()
    table.clear(self.buffInfoList)
    GUI:UIPanel_Close("dev/ui/MainUI/Panel/KLUIBuffInfoList/KLUIBuffInfoListPanel")
end

--刷新buff
---@param eventId number
---@param eventData BuffChangeData
function this:RefreshBuff(eventId, eventData)
    --logError("接收="..eventData.buff.cfgId)
    if not eventData then
        return
    end
    local rid = SL:GetMetaValue("MAIN_ACTOR_ID")
    if eventData.roleId and rid ~= tostring(eventData.roleId) then
        return
    end
    --0:Add 1:Remove 2:Update
    if string.isNullOrEmpty(eventData.buff.buffTbl.showIcon) then
        -- 图标为空不显示
        return
    end
    ---@type cfg_buff_column
    local buffTbl =  SL:GetConfig("cfg_buff",eventData.buff.cfgId)
    local totalTime = eventData.buff.serverBuff and eventData.buff.serverBuff.totalTime or buffTbl.buffTotalTime
    self:UpdateBuff(eventData.updateType,{cfgId = eventData.buff.cfgId,totalTime=totalTime,endTime = eventData.buff.endTime,buffText=eventData.buff.buffText,bufferLayer = eventData.buff.layers})
end

function this:LUA_EVENT_ONHOOK_STATE_CHANGE(_,onHookState, isOnHook, isReq)
    self:SetOnHookIcon(onHookState)
end

---点击自动战斗
function this:OnClick_AutoFight()
    if SL:GetMetaValue(EMetaVarGetKey.IN_SAFE_AREA) then
        SL:TipMessage("安全区不能自动战斗", 1, NoticeType.NoticeMid)
        return
    end
    local onHookState = SL:GetMetaValue(EMetaVarGetKey.GET_ONHOOK_STATE)
    if onHookState == EAutoOnHookStatus.PauseOnHook then
        SL:StopOnHook(true)
        PrivilegeCardManager.StopPatrolOnHook()
    elseif onHookState == EAutoOnHookStatus.StopOnHook then
        if PrivilegeCardManager.onHookType == EOnHookType.Situ then
            if SL:GetMetaValue(EMetaVarGetKey.GET_IS_SAFEAREA) then
                return
            end
            SL:StartOnHook(true,true)
        end
    elseif onHookState == EAutoOnHookStatus.OnHooking then
        SL:StopOnHook(true)
    end
end

---点击自动挂机
function this:OnClick_OnHook()
    GUI:UIPanel_Open("dev/outui/Hook/Panel/KLHookHelp/KLHookHelpPanel")
end

---点击显示buff
function this:OnClick_ShowBuff()
    local panel =  GUI:GetUI("dev/ui/MainUI/Panel/KLUIBuffInfoList/KLUIBuffInfoListPanel")
    if not panel then
        panel = GUI:UIPanel_Open("dev/ui/MainUI/Panel/KLUIBuffInfoList/KLUIBuffInfoListPanel", nil, nil, self.buffInfoList)
    else
        panel.args = self.buffInfoList
        panel:Refresh()
    end
    --GUI:Image_loadTexture(self.view.btn_showBuff,"BUFFSelect","Atlas/NewMainPanel.spriteatlas")
end

function this:RefreshMapLineBtn()
    local mapId = SL:GetMetaValue(EMetaVarGetKey.MAP_ID)
    local cfgInfo = SL:GetConfig("cfg_map_info",mapId)
    if cfgInfo and cfgInfo.nopositionmove and cfgInfo.nopositionmove == 1 then
        GUI:setGrey(self.view.btn_changeLine,true)
    else
        GUI:setGrey(self.view.btn_changeLine,false)
    end
end
---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
    self.TransPoint = SL:GetAllTransferPointById()
    self.mapLine = SL:GetMetaValue(EMetaVarGetKey.MAP_LINE)
    self.mapName = SL:GetMetaValue(EMetaVarGetKey.MAP_NAME)
    self:OnPlayerMapPosChange()
    self:RefreshMapLineBtn()
    local onHookState = SL:GetMetaValue(EMetaVarGetKey.GET_ONHOOK_STATE)
    self:SetOnHookIcon(onHookState)
    --self:InitPKMode()
    --local jumpListIndex
    --if self.args then
    --    local jumpIndex = tonumber(self.args[1])
    --    jumpListIndex = self:RefreshListDataWithJumpIndex(jumpIndex)
    --end
    --self:RefreshTransferList()
    --if jumpListIndex then
    --    GUI:OSAScrollView_ScrollTo(self.view.TransferScrollView, jumpListIndex - 1)
    --end
    if self.args and self.args[1] == 1 then
        self:OnClick_OpenMap()
    end
    self:RefreshPlayerInfo()
    
end

function this:RefreshPlayerInfo()
    self.level = SL:GetMetaValue("LEVEL")
    local name = SL:GetMetaValue("USER_NAME")
    GUI:Text_setString(self.view.Text_playerLevel,"Lv."..self.level)
    GUI:Text_setString(self.view.Text_playerName,name)
end

function this:InitPKMode()
    if not table.isNullOrEmpty(self.pkModeTemplateList) then
        ---@param pkModeTemplate KLPkItem
        for i, pkModeTemplate in pairs(self.pkModeTemplateList) do
            GUI:UIPanel_Close(nil, pkModeTemplate)
        end
    end

    self.pkModeTemplateList = {}
    local pkInfo = { 0, 1, 4, 5 }
    for i, pkMode in pairs(pkInfo) do
        local pkTemplateItem = GUI:UIPanel_Open("dev/ui/MainUI/Item/KLPk/KLPkItem", self.view.atkModelMenu, self, { pkMode = pkMode, pkName = PkModeToSrc[pkMode] }, true)
        table.insert(self.pkModeTemplateList, pkTemplateItem)
    end
    local pkMode = SL:GetMetaValue(EMetaVarGetKey.PKMODE)
    self:LUA_EVENT_PKMODE_CHANGE(_, pkMode)
    local count = table.count(self.pkModeTemplateList) - 1
    GUI:setContentSize(self.view.AtkModePanel, GUI:GetControlWidth(self.view.AtkModePanel), count * 34 + (count - 1) + 10)
end

---刷新pk模式item显隐
function this:RefreshPKModeItem()
    if InfoManager.loranSiegeInfo:IsMap() then
        SL:TipMessage(SL:GetConfig('cfg_string', 69001).text, 1, NoticeType.NoticeMid)
        return
    end
    GUI:setVisible(self.view.AtkModePanel, true)
    GUI:setVisible(self.view.AtkModeClosePanel, true)
    local pkMode = SL:GetMetaValue(EMetaVarGetKey.PKMODE)
    for _, v in pairs(self.pkModeTemplateList) do
        if v.args.pkMode == pkMode then
            v:SetHide(false)
        else
            v:SetHide(true)
        end
    end
end

function this:LUA_EVENT_PKMODE_CHANGE(_, pkMode)
    --GUI:Button_setTitleText(self.view.atkModelname, EPKModeToUI_Out[pkMode] or "")
    GUI:Image_loadTexture(self.view.btn_pkMode, PkModeToSrc[pkMode],"Atlas/NewMainPanel.spriteatlas")
    self:Btn_AtkModeCloseMaskOnClick()
end

function this:LUA_EVENT_SWITCH_PKMODE(_, pkMode)
    self:Btn_AtkModeCloseMaskOnClick()
    local curr_pkMode = SL:GetMetaValue(EMetaVarGetKey.PKMODE)
    if curr_pkMode == EPKMode.Camp then
        SL:TipMessage("当前地图无法切换pk模式", 1, NoticeType.NoticeMid)
        return
    end
    if curr_pkMode == EPKMode_Out.Camp_out then
        SL:TipMessage("当前地图无法切换pk模式", 1, NoticeType.NoticeMid)
        return
    end
    if GlobalLuaEventManager.isCrossServer and GlobalLuaEventManager.isCrossServer == 1 then
        if not SL:MeData_GetUnionId() or SL:MeData_GetUnionId() == 0 then
            if pkMode ~= 0 then
                SL:TipMessage("当前地图无法切换pk模式", 1, NoticeType.NoticeMid)
                return
            end
        else
            if pkMode ~= 5 then
                SL:TipMessage("当前地图无法切换pk模式", 1, NoticeType.NoticeMid)
                return
            end
        end
    end
    if InfoManager.loranSiegeInfo:IsMap() then
        SL:TipMessage(SL:GetConfig('cfg_string', 69001).text, 1, NoticeType.NoticeMid)
        return
    end
    local tip = SL:GetMetaValue(EMetaVarGetKey.PKMODE_CAN_USE, pkMode)
    if not string.isNullOrEmpty(tip) then
        SL:TipMessage(tip, 1, NoticeType.NoticeMid)
        return
    end
    SL:SetMetaValue(EMetaVarSetKey.SET_PKMODE, pkMode)
end

function this:LUA_EVENT_CROSS_SERVER_PK_MODE(_, pkMode)
    if GUI:getVisible(self.view.Img_AtkModeBg) then
        self:RefreshPKModeItem()
    end
    --SL:SetMetaValue(EMetaVarSetKey.SET_PKMODE, pkMode)
end


function this:SetOnHookIcon(onHookState)
    if PrivilegeCardManager.onHookType == EOnHookType.Situ then
        GUI:setVisible(self.view.btn_autoFight,true)
        --GUI:setVisible(self.view.Model_AutoFightEff, onHookState == EAutoOnHookStatus.OnHooking)
        if onHookState == EAutoOnHookStatus.OnHooking then
            GUI:Image_loadTexture(self.view.btn_autoFight,"pause_1","Atlas/NewMainPanel.spriteatlas")
            SL:onLUAEvent(LUA_EVENT_HIDE_RIGHT_BTN_VIEW)
        elseif onHookState == EAutoOnHookStatus.StopOnHook then
            GUI:Image_loadTexture(self.view.btn_autoFight,"play_1","Atlas/NewMainPanel.spriteatlas")
        end
    elseif PrivilegeCardManager.onHookType == EOnHookType.Patrol then
        ---巡逻挂机走另一断逻辑
        if PrivilegeCardManager.patrolOnHookState then
            GUI:setVisible(self.view.btn_autoFight,false)
        else
            GUI:setVisible(self.view.btn_autoFight,true)
        end
    end
end

function this:UpdateBuff(updateType,data)
    if updateType == 1 then
        --移除
        self:AddOrRemoveBuff(data,false)
    elseif updateType == 2 or updateType == 0 then
        --更新
        self:AddOrRemoveBuff(data,true)
    end
    local panel =  GUI:GetUI("dev/ui/MainUI/Panel/KLUIBuffInfoList/KLUIBuffInfoListPanel")
    if panel then
        panel.args = self.buffInfoList
        panel:Refresh()
    end
end

function this:AddOrRemoveBuff(data,isAdd)
    local isContains = false
    local pos
    for i, v in pairs(self.buffInfoList) do
        if v.cfgId == data.cfgId then
            isContains = true
            pos = i
        end
    end
    if isContains and pos and not isAdd then
        table.remove(self.buffInfoList,pos)
    end
    if isAdd then
        if isContains then
            self.buffInfoList[pos] = data
        else
            table.insert(self.buffInfoList,data)
        end
    end
end

function this:Hide()
end

function this:Close()
    GUI:UIPanel_Close("dev/ui/MainUI/Panel/KLUIBuffInfoList/KLUIBuffInfoListPanel")
    table.clear(self.buffInfoList)
end

function this:OnClick_OpenMap()
    GUI:SetActive(self.view.maptransfer_panel,true)
    self:RefreshTransferList()
end

function this:OnClick_Btn_SwitchLine()
    SL.HideMainPanel()
    GUI:UIPanel_Open("dev/ui/Map/Panel/KLUIMapBranch/KLUIMapBranchPanel")
end

function this:OnPlayerMapPosChange()
    ---@type Dot2
    local pos = SL:GetMetaValue(EMetaVarGetKey.MAP_PLAYER_POS)
    GUI:Text_setString(self.view.Text_MapName,string.format("%s-%d,%d-%d线", self.mapName, pos.x, pos.z, self.mapLine))

    self:JudgeMapTransfer()
end

function this:LUA_EVENT_FIGHTEND(id,data)
    self.IsTrans = false
end

function this:LUA_EVENT_NPC_LEAVE_NEAR(_,dir)
    self.IsTrans = false
    self.TransPoint = SL:GetAllTransferPointById()
end

function this:JudgeMapTransfer()
    if #self.TransPoint == 0 then
        self.TransPoint = SL:GetAllTransferPointById()
        if #self.TransPoint == 0 then
            return
        end
    end

    if self.IsTrans == false then
        for i, v in pairs(self.TransPoint) do
            for j, k in pairs(EDirectionToDot2) do
                local disx = math.abs(v.point.position[1] - SL:MeData_GetCoord().x)
                local disz = math.abs(v.point.position[2] - SL:MeData_GetCoord().z)
                if math.sqrt(disx * disx + disz * disz) <= v.dis then
                    if v.point.condition then
                        local canTransfer = SL:CheckCalculateConditionGroup(v.point.condition)
                        if not canTransfer then
                            local condition = SL:Split(v.point.condition, "=")
                            local str = "等级不满足,"..condition[2].."等级后开启"
                            SL:TipMessage( str, 1, NoticeType.NoticeMid )
                            return
                        end
                    end

                    local cfgTable = SL:GetConfigTable('cfg_mapMove')

                    ---@param e cfg_mapMove_column
                    for q, e in pairs(cfgTable) do
                        if tonumber(e.mapID) == v.point.targetId then
                            self.TransMapId = v.point.id

                            self:SetTrans()
                            return
                        end
                    end
                end
            end
        end
    end
end

function this:SetTrans()
    Coroutine.Start(self.ShowTransAni,self)
end

function this:ShowTransAni()
    if not SL:Me_GetSellerIsCanMove() then
        return
    end
    self.timeCount=0
    local transfer_info =  SL:GetConfig("cfg_transfer_point",self.TransMapId)
    local map_info =  SL:GetConfig("cfg_map_info",transfer_info.targetId)

    self.conditionCheck = map_info.intolv <= SL:MeData_GetLevel()
    self.cost = map_info.transferCost
    self.conditionCheck2 = true
    if self.cost and self.cost[1]  and self.cost[1][2] then
        self.conditionCheck2 = self.cost[1][2] * InfoManager.redNameInfo:GetMapTransmissionCost() <= SL:GetBagItemCount(self.cost[1][1])
    end
    if not self.conditionCheck then
        SL:TipMessage( string.format("等级不满足，%s等级后可传送", map_info.intolv), 1, NoticeType.NoticeMid )
        return
    end
    if not self.conditionCheck2 then
        SL:TipMessage( "金币不足,无法传送", 1, NoticeType.NoticeMid )
        return
    end
    self.IsTrans = true
    SL:SendTransferPointMessage(self.TransMapId)
    self.IsTrans=false
    --[[    SL:CommonTipsMessage({ stringTblID = 35005,
                               ui = self,
                               sureBtnText = "确定",
                               cancelBtnText = "取消",
                               cancelCallBack = function()
                                   self.IsTrans=false
                               end,
                               closeCallBack = function()
                                   self.IsTrans=false
                               end,
                               callback = function()
                                   SL:SendTransferPointMessage(self.TransMapId)
                                   self.IsTrans=false
                               end })]]

    --self:PlayTransAni()

end


function this:GuideToShowMap()

end

function this:RefreshListDataWithJumpIndex(jumpIndex)
    ---@type cfg_mapMove_column
    local jumpTbl = SL:GetConfig("cfg_mapMove", jumpIndex)
    if jumpTbl.group ~= 0 then
        --展开分组
        for _, v in pairs(self.mapMoveListData) do
            if v.isGroup and v.data.group == jumpTbl.group then
                if not v.groupExpand then
                    v.groupExpand = true
                    v.Select = false
                    self:RefreshListData()
                end
            end
        end
    end
    for k, v in pairs(self.mapMoveListData) do
        if not v.isGroup and v.data.id == jumpTbl.id then
            return k
        end
    end
end


function this:TransferItemSizeGetFun(index)
    local data = self.mapMoveListData[index + 1]
    if data.isRoot then
        return 50
    end
    return 43
end

function this:TransferItemGetFun()
    ---@type KLBigMapTransferItemItem
    local itemPanel = GUI:UIPanel_Open("dev/ui/Map/Item/KLBigMapTransferItem/KLBigMapTransferItemItem", self.view.TransferList, self, nil, true)
    return itemPanel
end

---@param item KLBigMapTransferItemItem
---@param index number
function this:TransferItemUpdateFun(item, index)
    self.MapBtnPointTempList[index + 1] = item
    item:RefreshUI(self.mapMoveListData[index + 1], function()
        self:RefreshListData()
        --GUI:DataListUpdateData(self.view.TransferList)
        self:RefreshTransferList()

    end, self.MapBtnPointTempList)

end

function this:RefreshListData()
    local newListData = {}
    for _, item in pairs(self.mapMoveListData) do
        if item.isRoot then
            table.insert(newListData, item)
            if item.isGroup and item.groupExpand and item.children then
                for _, child in pairs(item.children) do
                    table.insert(newListData, child)
                end
            end
        end
    end
    self.mapMoveListData = newListData
end

function this:RefreshTransferList()
    self.MapBtnPointTempList = {}
    GUI:OSAScrollView_RefreshList(self.view.TransferScrollView, #self.mapMoveListData)
end

function this:CloseTransferPanel()
    GUI:setVisible(self.view.maptransfer_panel, false)
end


return this
