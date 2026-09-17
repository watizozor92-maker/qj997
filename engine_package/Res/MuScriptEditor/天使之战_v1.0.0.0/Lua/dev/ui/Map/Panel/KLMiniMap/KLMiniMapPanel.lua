---@class KLMiniMapPanel:UIKmlLuaPanelBase
---@field view KLMiniMapPanelView
local KLMiniMapPanel = class(UIKmlLuaPanelBase)
local this =KLMiniMapPanel
---创建时调用一次
function this:Init()
    --self.sceneImgWidth = self.view.img_scene:GetWidth()
    --self.sceneImgHeight = self.view.img_scene:GetHeight()
    self.sceneImgWidth,self.sceneImgHeight = GUI:getSizeDelta(self.view.img_scene)
    ---@type table<string,UIKmlLuaPanelBase>
    self.iconMap = {}
    self.TransPoint = {}
    self.IsTrans=false

    self.MonsterPointMinPool = TablePool() ---小地图
    self.monsterPointMinTempList = {}---小地图temp列表保存

    self.mapIconVisibleInfo = {}
    local s = SL:GetConfig("cfg_global",280).value
    local strs = string.split(s,'#')
    self.monsterCheckN =tonumber(strs[1])
    self.monsterLimitCount =tonumber(strs[2])
end

function this:Show()
    -- if SL:GetIsWebGL() then
    --     GUI:Text_setTextAlignment(self.view.txt_title,"21")
    -- else
    --     GUI:Text_setTextAlignment(self.view.txt_title,"01")
    -- end
end

---创建或者刷新界面数据时调用
function this:Refresh()
    
    self:OnPlayerMapPosChange()
    self:OnPlayerTurnDir(_,SL:GetMetaValue(EMetaVarGetKey.DIR))
    self:SetTransferIcon()
    self:SetNpcIcon()
    -- local mapName = SL:GetMetaValue(EMetaVarGetKey.MAP_NAME)
    -- local mapLine = SL:GetMetaValue(EMetaVarGetKey.MAP_LINE)
    -- ---@type cfg_map_info_column
    -- local mapInfo = SL:GetConfig("cfg_map_info", SL:GetMetaValue(EMetaVarGetKey.MAP_ID))
    -- if mapInfo and mapInfo.nopositionmove == 0 then
    --     GUI:Text_setString(self.view.txt_title,string.format("%s<color=#E6E600>[%s线]</color>",mapName,mapLine))
    -- else
    --     GUI:Text_setString(self.view.txt_title,string.format("%s",mapName))
    -- end
    self.TransPoint = SL:GetAllTransferPointById()
    self:ShowMonsterPointMin()

    --if mapInfo and mapInfo.nopositionmove == 0 then
    --    GUI:setVisible(self.view.btn_switch_line, true)
    --else
    --    GUI:setVisible(self.view.btn_switch_line, false)
    --end
 
    --self.timeId = SL:Schedule(self.timeId,0,1,-1,function()
    --    self:ShowMonsterPointMinUpdate()
    --end)

    local onHookState = SL:GetMetaValue(EMetaVarGetKey.GET_ONHOOK_STATE)
    self:SetOnHookIcon(onHookState)
    local name = SL:GetCurServerName()
    GUI:Text_setString(self.view.txt_server,name)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    SL:RegisterLUAEvent(LUA_EVENT_FIGHTEND,self.LUA_EVENT_FIGHTEND,self)
    SL:RegisterLUAEvent(LUA_EVENT_MAPINFOCHANGE,self.LUA_EVENT_NPC_LEAVE_NEAR,self)  --切换不同地图
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_TURN_DIR,self.OnPlayerTurnDir,self)
    SL:RegisterLUAEvent(LUA_EVENT_MAPINFOCHANGE,self.MapEventChange,self)
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_MAPPOS_CHANGE,self.OnPlayerMapPosChange,self)
    --GUI:AddOnClickEvent(self.view.btn_switch_line,self,self.BtnSwitchLineOnClick)
    GUI:AddOnClickEvent(self.view.btn_bg,self,self.BtnBgOnClick)

    SL:RegisterLuaNetMsg(MessageDef.ResUpdateViewMessage, self.ShowMonsterPointMin, self)
    SL:RegisterLuaNetMsg(MessageDef.ResMonsterEnterViewMessage, self.ShowMonsterPointMin, self)
    SL:RegisterLuaNetMsg(MessageDef.ResWalkMessage, self.ResWalkMessage, self)
    SL:RegisterLuaNetMsg(MessageDef.ResFightResultMessage, self.ResFightResultMessage, self)
    
    --GUI:AddOnClickEvent(self.view.btn_fightLog, self, self.OnClick_btn_fightLog)
    --GUI:AddOnClickEvent(self.view.btn_onHook, self, self.OnClick_btn_onHook)
    --GUI:AddOnClickEvent(self.view.btn_autoFight, self, self.OnClick_btn_autoFight)
    SL:RegisterLUAEvent(LUA_EVENT_ONHOOK_STATE_CHANGE,self.LUA_EVENT_ONHOOK_STATE_CHANGE,self)
end

---点击战斗日志
function this:OnClick_btn_fightLog()
    if SL:GetMetaValue(EMetaVarGetKey.IN_SAFE_AREA) then
        SL:TipMessage("安全区不能自动战斗", 1, NoticeType.NoticeMid)
        return
    end
    ---@type KLUIHurtExpPanel
    local KLUIHurtExpPanel = GUI:GetUI("dev/ui/MainUI/Panel/KLUIHurtExp/KLUIHurtExpPanel")
    if KLUIHurtExpPanel then
        KLUIHurtExpPanel:ShowOrHideInfos()
        --GUI:Button_loadTextureNormal(self.view.btn_fightLog, KLUIHurtExpPanel.isShow and "btn_rizhi_shou" or "btn_rizhi", "Atlas/UIMainPanel_Out.spriteatlas")
    else
        SL:TipMessage(SL:GetConfig('cfg_string',49001).text, 1, NoticeType.NoticeMid)
    end
end

---点击挂机设置
function this:OnClick_btn_onHook()
    GUI:UIPanel_Open("dev/outui/Hook/Panel/KLHookHelp/KLHookHelpPanel")
end

---点击自动战斗
function this:OnClick_btn_autoFight()
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
        elseif PrivilegeCardManager.onHookType == EOnHookType.Patrol then
            self:OnClickPatrolBtn()
        end
    elseif onHookState == EAutoOnHookStatus.OnHooking then
        SL:StopOnHook(true)
    end
end

function this:SetOnHookIcon(onHookState)
    if PrivilegeCardManager.onHookType == EOnHookType.Situ then
        --GUI:setVisible(self.view.btn_autoFight,true)
        GUI:setVisible(self.view.Model_AutoFightEff, onHookState == EAutoOnHookStatus.OnHooking)
        --GUI:Button_loadTextureNormal(self.view.btn_fightLog, onHookState == EAutoOnHookStatus.OnHooking and "btn_rizhi_shou" or "btn_rizhi", "Atlas/UIMainPanel_Out.spriteatlas")
        if onHookState == EAutoOnHookStatus.OnHooking then
            --GUI:Button_loadTextureNormal(self.view.btn_autoFight,"btn_pauseFight","Atlas/UIMainPanel_Out.spriteatlas")
        elseif onHookState == EAutoOnHookStatus.StopOnHook then
            --GUI:Button_loadTextureNormal(self.view.btn_autoFight,"btn_autoFight","Atlas/UIMainPanel_Out.spriteatlas")
        end
    elseif PrivilegeCardManager.onHookType == EOnHookType.Patrol then
        ---巡逻挂机走另一断逻辑
        --if PrivilegeCardManager.patrolOnHookState then
        --    GUI:setVisible(self.view.btn_autoFight,false)
        --else
        --    GUI:setVisible(self.view.btn_autoFight,true)
        --end
    end
end


function this:LUA_EVENT_ONHOOK_STATE_CHANGE(_,onHookState)
    self:SetOnHookIcon(onHookState)
end

function this:LUA_EVENT_FIGHTEND(id,data)
    self.IsTrans = false
end

function this:LUA_EVENT_NPC_LEAVE_NEAR(_,dir)
    self.IsTrans = false
    self.TransPoint = SL:GetAllTransferPointById()
end

function this:OnPlayerTurnDir(_,dir)
    GUI:setRotation(self.view.img_player_icon,(dir+1)*-45)
end

function this:MapEventChange()
    for k, _ in pairs(self.iconMap) do
        self:RemoveIcon(k)
    end
    self:Refresh()
end

function this:OnPlayerMapPosChange()
    local mapFile = SL:GetMetaValue(EMetaVarGetKey.MINIMAP_FILE)
    GUI:Image_loadTexture(self.view.img_scene,string.format("Texture/%s.png",mapFile))
    ---@type Dot2
    local pos = SL:GetMetaValue(EMetaVarGetKey.MAP_PLAYER_POS)
    local x = pos.x/256*self.sceneImgWidth - self.sceneImgWidth/2
    local z = pos.z/256*self.sceneImgHeight - self.sceneImgHeight/2
    GUI:setPosition(self.view.img_scene,-x,-z)
    --GUI:Text_setString(self.view.txt_coord,pos.x..","..pos.z)
    
    self:JudgeMapTransfer()
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
        SL:TipMessage( string.format("等级不满足，%s等级后可传送", self.mapMoveTbl.level), 1, NoticeType.NoticeMid )
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

function this:SetMapIconVisible(id,visible)
    self.mapIconVisibleInfo[id] = visible and "1" or "0"
    if self.iconMap[id] then
        GUI:setVisible(self.iconMap[id].view.root, visible)
    end
end

---@param id string
---@param item UIKmlLuaPanelBase
function this:SetMapIcon(id, item, x, y)
    if self.iconMap[id] then
        GUI:UIPanel_Close(_,self.iconMap[id])
        self.iconMap[id] = nil
    end
    --GUI:SetParent(icon,self.view.scene_group)
    --item.kmlControl:SetParent(self.view.img_scene.kmlControl)
    local miniMapX=x/256*self.sceneImgWidth-self.sceneImgWidth/2
    local miniMapY=y/256*self.sceneImgHeight-self.sceneImgHeight/2
    GUI:setPosition(item.view.root,miniMapX,miniMapY)
    self.iconMap[id] = item

    if self.mapIconVisibleInfo[id] then
        GUI:setVisible(item.view.root,self.mapIconVisibleInfo[id] == "1")
    end
end
---@param id string
function this:RemoveIcon(id)
    if self.iconMap[id] then
        GUI:UIPanel_Close(_,self.iconMap[id])
        self.iconMap[id] = nil
    end
end

---@设置传送点图标
function this:SetTransferIcon()
    local mapId = SL:GetMetaValue(EMetaVarGetKey.MAP_ID)
    ---@type cfg_transfer_point_column[]
    local transferPoint = SL:FindConfigs('cfg_transfer_point', 'mapId', mapId)
    if transferPoint then
        for _,v in pairs(transferPoint) do
            local transferIcon = GUI:UIPanel_Open("dev/ui/Map/Item/KLMapTransferIcon/KLMapTransferIconItem",self.view.img_scene,self,v,true)
            self:SetMapIcon("MapTransferIcon" .. v.id,transferIcon,v.position[1],v.position[2])
        end
    end
end


function this:SetNpcIcon()
    local mapId = SL:GetMetaValue(EMetaVarGetKey.MAP_ID)
    ---@type cfg_npclist_column[]
    local npcList = SL:FindConfigs('cfg_npclist', 'mapId', mapId)
    if npcList then
        for _,npcTbl in pairs(npcList) do
            local npcIcon = GUI:UIPanel_Open("dev/ui/Map/Item/KLMapNpcIcon/KLMapNpcIconItem",self.view.img_scene,self,{npcTbl,false},true)
            self:SetMapIcon("MapNpcIcon" .. npcTbl.id,npcIcon,npcTbl.x,npcTbl.y)
        end
    end
end

function this:BtnSwitchLineOnClick()
    SL.HideMainPanel()
    GUI:UIPanel_Open("dev/ui/Map/Panel/KLUIMapBranch/KLUIMapBranchPanel")
end

function this:BtnBgOnClick()
    SL:ShowBigMap()
end
---设置怪物点---------------------------------------------------------------

function this:ShowMonsterPointMinUpdate()
    if not self.showMonsterPointMinUpdateTime or Time.time-self.showMonsterPointMinUpdateTime<1 then
        return
    end
    self.showMonsterPointMinUpdateTime = Time.time
    if not self.needRemove then
        self.needRemove = {}
    end
    table.clear(self.needRemove)
    if not self.needAdd then
        self.needAdd = {}
    end
    table.clear(self.needAdd)
    if not self.tempShowMonster then
        self.tempShowMonster = {}
    end
    table.clear(self.tempShowMonster)
    
    
    local showMonster = SL:GetMetaValue("GET_MONSTER_DATA_LIST")
    local maxDist = 0
    local curShowCount = 0
    local meX,meZ = SL:MeData_Pos()
    for k, v in pairs(showMonster) do
        local ax = Mathf.Abs(v.pos.x-meX)
        local az = Mathf.Abs(v.pos.z-meZ)
        if (ax>0 or az>0) and  ax<=self.monsterCheckN and az<=self.monsterCheckN then
            if curShowCount<self.monsterLimitCount then
                self.tempShowMonster[v.data.id] = v
                curShowCount=curShowCount+1
            end
        end
    end
    for k, v in pairs(self.tempShowMonster) do
        local id = v.data.id
        if not self.monsterPointMinTempList[id] then
            self.needAdd[id] = v
        end
    end

    for k, v in pairs(self.monsterPointMinTempList) do
        local id = k
        if not self.tempShowMonster[id] then
            self.needRemove[id] = v
        end
    end

    for k, v in pairs(self.needRemove) do
        local id = k
        self.monsterPointMinTempList[id] = nil
        v:SetPanelXY(-3000,-3000)
        self.MonsterPointMinPool:Push(v)
    end

    for k, v in pairs(self.monsterPointMinTempList) do
        ---@type KLMapMonsterPointItem
        local monsterPointTemp = v
        local monster = SL:GetMetaValue("GET_MONSTER_DATA_BY_ID",k)
        if monster then
            local x = monster.pos.x / 256 * self.sceneImgWidth - self.sceneImgWidth / 2
            local y = monster.pos.z / 256 * self.sceneImgHeight - self.sceneImgHeight / 2
            if monsterPointTemp.x~=x or monsterPointTemp.y~=y then
                monsterPointTemp:SetPanelXY(x, y)
            end
        end
    end
   
    --local limitCount = 10
    --local index = 1
    for i, monster in pairs(self.needAdd) do
        --if index>limitCount then
        --    break
        --end
        --index =index+1
        ---@type KLMapMonsterPointItem
        local monsterPointTemp = self.MonsterPointMinPool:Pop()
        if next(monsterPointTemp) then
            self.monsterPointMinTempList[monster.data.id] = monsterPointTemp
            -- monsterPointTemp:SetActiveUI(true)
            local x = monster.pos.x / 256 * self.sceneImgWidth - self.sceneImgWidth / 2
            local y = monster.pos.z / 256 * self.sceneImgHeight - self.sceneImgHeight / 2
            monsterPointTemp:SetMonsterData(monster.data.id,x,y)
            monsterPointTemp:SetPanelXY(x, y)
            monsterPointTemp:SetPanelRotation(0)
            monsterPointTemp:setScale(1)
            monsterPointTemp:ShowNormalMonsterIcon(monster)
        else
            local monster_data = monster
            GUI:UIPanel_Open("dev/ui/Map/Item/KLMapMonsterPoint/KLMapMonsterPointItem", self.view.img_scene, self, nil, true,
            function (PointTemp)
                self.monsterPointMinTempList[monster_data.data.id] = PointTemp
                -- PointTemp:SetActiveUI(true)
                local x = monster_data.pos.x / 256 * self.sceneImgWidth - self.sceneImgWidth / 2
                local y = monster_data.pos.z / 256 * self.sceneImgHeight - self.sceneImgHeight / 2
                PointTemp:SetMonsterData(monster_data.data.id,x,y)
                PointTemp:SetPanelXY(x, y)
                PointTemp:SetPanelRotation(0)
                PointTemp:setScale(1)
                PointTemp:ShowNormalMonsterIcon(monster_data)
            end)
        end
    end
end

function this:ShowMonsterPointMin()
    if not self.showMonsterPointMinUpdateTime then
        self.showMonsterPointMinUpdateTime = Time.time
    end
end
---@param message FightProtos.FightResultRes
function this:ResFightResultMessage(_, message)
    if message then
        for _,v in pairs(message.target) do
            if v.hp <=0 and self.monsterPointMinTempList[v.targetId] then
                self.monsterPointMinTempList[v.targetId]:SetNormalDead()
            end
        end
    end
end
---@param message MapProtos.WalkRes
function this:ResWalkMessage(_, message)
    if message then
        if self.monsterPointMinTempList[message.id] then
            local pos = {}
            pos.x = message.x / 256 * self.sceneImgWidth - self.sceneImgWidth / 2
            pos.y = message.y / 256 * self.sceneImgHeight - self.sceneImgHeight / 2
            self.monsterPointMinTempList[message.id]:SetPanelXY(pos.x, pos.y)
        end
    end
end

function this:Close()
    self.showMonsterPointMinUpdateTime = nil
    if self.timeId then
        SL:UnSchedule(self.timeId)
        self.timeId= nil
    end
    self.monsterPointMinTempList = {}---temp列表保存
    self.MonsterPointMinPool:Clear()
    if self.iconMap then
        for k, v in pairs(self.iconMap) do
            GUI:UIPanel_Close(_,v)
        end
       table.clear(self.iconMap)
    end
end
------------------怪点end---------------------------------------------------------------------------
return this