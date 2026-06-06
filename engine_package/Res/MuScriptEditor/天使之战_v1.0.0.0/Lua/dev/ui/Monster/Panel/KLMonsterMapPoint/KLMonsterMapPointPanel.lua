---@class KLMonsterMapPointPanel:UIKmlLuaPanelBase
---@field view KLMonsterMapPointPanelView
local KLMonsterMapPointPanel = class(UIKmlLuaPanelBase)
local this = KLMonsterMapPointPanel
---创建时调用一次
function this:Init()
    self.is_open = true
    this.mapMonsterSelect = {}
    this.oldSelectItem = nil
    if GUI:IsWebGLAsync() then
        this.click_interval = 500
    else
        this.click_interval = 100
    end
    GUI:DataListInitData(self.view.loopscrollviewData, function()
        return self:ItemCountFunc()
    end, function(realIndex)
        return self:ItemGetFunc(realIndex)
    end, function(realIndex, kmlCtrl)
        return self:ItemInitFunc(realIndex, kmlCtrl)
    end, function(realIndex, kmlCtrl)
        return self:ItemUpdateFunc(realIndex, kmlCtrl)
    end, function(realIndex)
        return self:ItemSizeGetFunc(realIndex)
    end)
    self.mapMonsterData = {} 
    self.nextDoRevTime = Time.time+Time.deltaTime
    self.change_y = true
    self.updateID = SL:Schedule(self.updateID,0,0.2,-1,function()
        self:Update()
    end)

    ---@type table<KingML.KmlControl,KLMonsterMapPointItemItem>
    self.MapItems = {}
end
function this:Update()
    if not self.nextDoRevTime then
        return
    end
    if Time.time>self.nextDoRevTime then
        self.nextDoRevTime = nil
        self:RefresfAll()
    end
end

function this:RefresfAll()
    self.mapMonsterData = {} 
    local mapId = SL:GetMetaValue(EMetaVarGetKey.MAP_ID)
    for i, v in pairs(SL:FindConfigs('cfg_mongen', "mapid", mapId)) do
        if v.monsterShowList == 1 then
            v.reliveTime = 0
            table.insert(self.mapMonsterData, v)
        end
    end
    local monsterPoints = SL:GetMapMonsterStatus()
    if monsterPoints then
        for i=1,#self.mapMonsterData,1 do
            local monsterid = self.mapMonsterData[i].monsterid
            local id = self.mapMonsterData[i].id
            for _, v in pairs(monsterPoints) do
                if v.groupId == id and v.configId == monsterid then
                    if v.reliveTime and v.reliveTime ~= 0 then
                        self.mapMonsterData[i].reliveTime = v.reliveTime
                    end
                end
            end
        end
        table.sort(self.mapMonsterData,function(a,b)
            if a.reliveTime == b.reliveTime then
                if a.grading == b.grading then
                    return  a.id < b.id
                else
                    return  a.grading < b.grading
                end
            else
                return  a.reliveTime < b.reliveTime
            end
        end)
    end
    GUI:DataListUpdateData(self.view.loopscrollviewData)
    if not next(self.mapMonsterData) then
        GUI:UIPanel_Close("dev/ui/Monster/Panel/KLMonsterMapPoint/KLMonsterMapPointPanel")
        return
    else
        if self.change_y then
            self.change_y = false
            GUI:setPositionY(self.view.root,0)
        end
    end
end


function this:ItemCountFunc()
    return #self.mapMonsterData
end

function this:ItemGetFunc(realIndex)
    ---@type KLUISkillPageItem
    local item = GUI:UIPanel_Open("dev/ui/Monster/Item/KLMonsterMapPointItem/KLMonsterMapPointItemItem", self.view.loopscrollviewData, self, nil, true)
    local luaIndex = realIndex + 1
    if not this.mapMonsterSelect[luaIndex] then
        this.mapMonsterSelect[luaIndex] = {}
    end
    this.mapMonsterSelect[luaIndex] = false
    
    local kmlCtrl = item.view.root
    self.MapItems[kmlCtrl] = item
    return kmlCtrl
end

---@param kmlCtrl KingML.KmlControl
function this:ItemInitFunc(realIndex, kmlCtrl)

end

---@param kmlCtrl KingML.KmlControl
function this:ItemUpdateFunc(realIndex, kmlCtrl)
    local item = self.MapItems[kmlCtrl]
    local luaIndex = realIndex + 1
    local List = self.mapMonsterData[luaIndex]
    local isSelect = this.mapMonsterSelect[luaIndex]
    if isSelect then
        this.oldSelectItem = item
    end
    if luaIndex % 2 == 0 then
        GUI:SetActive(self.MapItems[kmlCtrl].view.MainBg,true)
        --GUI:Image_loadTexture(self.MapItems[kmlCtrl].view.BG, "monsterlist2", "Atlas/TS_Common.spriteatlas")
    else
        GUI:SetActive(self.MapItems[kmlCtrl].view.MainBg,false)
        --GUI:Image_loadTexture(self.MapItems[kmlCtrl].view.BG, "monsterlist1", "Atlas/TS_Common.spriteatlas")
    end
    item:UpdateUI(List, self.OnClickGoButton, isSelect, luaIndex)
end

function this:OnClickGoButton(data, luaIndex)
    if data then
        --点击做一下间隔，防止玩家一直点会卡
        if not this.click_time then
            this.click_time =  SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME)
        else
            local server_time =  SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME)
            if this.click_time + this.click_interval > server_time then
                return
            end
            this.click_time =  SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME)
        end
        if data.instruction[1] and data.instruction[1] ~= "" then
            SL:ShortcutDO(data.instruction[1])
        else
            --local mongenCfg = SL:GetConfig("cfg_mongen", data.groupId)
            local mapMoveCfg = SL:GetConfigMultiKeys("cfg_mapMove", data.mapid, "mapID")
            local Pos = string.split(data.coordinates, '#')
            --ShortcutMgr.Do({ "moveTo", mapMoveCfg.id, tonumber(Pos[1]), tonumber(Pos[2]) })
            ---{ "moveTo", 1, 150, 167}"moveTo", mapMoveCfg.id, tonumber(Pos[1]), tonumber(Pos[2])
            SL:StopOnHook(true)
            local line = SL:GetMetaValue(EMetaVarGetKey.MAP_LINE)
            local map_id = SL:GetMetaValue(EMetaVarGetKey.MAP_ID)
            this.pos_monster_id = data.monsterid
            local x = tonumber(Pos[1])
            local y = tonumber(Pos[2])
            this.map_data = {map_id, line, x, y}
            SL:Pathfinding(map_id, line, x, y,this.PointPosEnd,this.pos_monster_id)
        end
        for i, v in pairs(this.mapMonsterSelect) do
            if luaIndex == i then
                this.mapMonsterSelect[i] = true
            else
                this.mapMonsterSelect[i] = false
            end
        end
        if this.oldSelectItem then
            this.oldSelectItem:SetSelect(false)
            this.oldSelectItem = self
        else
            this.oldSelectItem = self
        end

        self:SetSelect(true)
    end
end

function this.PointPosEnd(pos)
    --SL:LogError(this.pos_monster_id .. "    " ..x .. "  ".. y)
    --SL:StartOnHook(true,true,this.pos_monster_id)
    if pos and pos.x and pos.z then
        SL:Pathfinding( this.map_data[1],  this.map_data[2], pos.x, pos.z,this.BossPointOnHook)
    else
        SL:StartOnHook(true,true,this.pos_monster_id)
    end
end

function this.BossPointOnHook(pos)
    SL:StartOnHook(true,true,this.pos_monster_id)
end

---@return Vector2
function this:ItemSizeGetFunc(realIndex)
    local x = 208
    local y = 39
    return Vector2(x, y)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    
    local panel = GUI:GetUI("dev/ui/Preview/Panel/KLActivityTip/KLActivityTipPanel")
    if GUI:getVisible(self.view.bgImg) then
        if panel then
            panel:SetUIMapPoint(false)
        end
        GUI:setRotation(self.view.closeBtn, 0)
    else
        if panel then
            panel:SetUIMapPoint(true)
        end
    end
    local panel2 = GUI:GetUI("dev/outui/Activity/Panel/KLActivityPreview/KLActivityPreviewPanel")
    if panel2 then
        panel2:OnClickClose()
    end
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.closeBtn, self, self.OnClickCloseButton)
    GUI:AddOnClickEvent(self.view.closeBtn_2, self, self.OnClickCloseButton)
    GUI:AddOnClickEvent(self.view.closeBtn_3, self, self.OnClickCloseButton)
    SL:RegisterLuaNetMsg(MessageDef.ResMapMonsterStatusMessage, self.ResMapMonsterStatusMessage, self)
    SL:RegisterLUAEvent(LUA_EVENT_UI_SHOW_ME_PATH_STOP, self.LUA_EVENT_UI_SHOW_ME_PATH_STOP, self)
    SL:RegisterLuaNetMsg(MessageDef.ResPlayerChangeMapMessage, self.ResPlayerChangeMapMessage, self)

    SL:RegisterLUAEvent(LUA_EVENT_MAP_MONSTER_STATUS, self.LUA_EVENT_MAP_MONSTER_STATUS, self) --地图怪物状态
    SL:RegisterLUAEvent(LUA_EVENT_MAP_MONSTER_STATUS_CHANGE, self.LUA_EVENT_MAP_MONSTER_STATUS_CHANGE, self)  --地图怪物状态改变
end

function this:UnRegistEvents()
    SL:UnRegisterLUAEvent(LUA_EVENT_MAP_MONSTER_STATUS, self.LUA_EVENT_MAP_MONSTER_STATUS, self) --地图怪物状态
    SL:UnRegisterLUAEvent(LUA_EVENT_MAP_MONSTER_STATUS_CHANGE, self.LUA_EVENT_MAP_MONSTER_STATUS_CHANGE, self)  --地图怪物状态改变
end

function this:ResPlayerChangeMapMessage()
    self.mapMonsterData = {}

    for i, v in pairs(SL:GetConfigFieldToList('cfg_mongen', "mapid", SL:GetMetaValue(EMetaVarGetKey.MAP_ID))) do
        if v.monsterShowList == 1 then
            table.insert(self.mapMonsterData, v)
        end
    end
    if not next(self.mapMonsterData) then
        GUI:UIPanel_Close("dev/ui/Monster/Panel/KLMonsterMapPoint/KLMonsterMapPointPanel")
        return
    end
end
function this:LUA_EVENT_UI_SHOW_ME_PATH_STOP(_, data)
    if this.oldSelectItem then
        this.oldSelectItem:SetSelect(false)
        for i, v in pairs(this.mapMonsterSelect) do
            this.mapMonsterSelect[i] = false
        end
    end
end
function this:ResMapMonsterStatusMessage(_, message)
    if message then
        GUI:DataListUpdateData(self.view.loopscrollviewData)
    end
end
function this:HidePanel()
    GUI:setVisible(self.view.bgImg, false)
    for i, v in pairs(self.MapItems) do
        v:SetSelect(false)
    end
    --if panel then
    --    panel:SetUIMapPoint(false)
    --end
    GUI:setRotation(self.view.closeBtn, -180)
end
function this:OnClickCloseButton()
    local panel = GUI:GetUI("dev/ui/Preview/Panel/KLActivityTip/KLActivityTipPanel")
    if GUI:getVisible(self.view.bgImg) then
        GUI:setVisible(self.view.bgImg, false)
        for i, v in pairs(self.MapItems) do
            v:SetSelect(false)
        end
        if panel then
            panel:SetUIMapPoint(false)
        end
        GUI:setRotation(self.view.closeBtn, -180)
    else
        GUI:setVisible(self.view.bgImg, true)
        GUI:DataListUpdateData(self.view.loopscrollviewData)
        GUI:setRotation(self.view.closeBtn, 0)
        if panel then
            panel:SetUIMapPoint(true)
        end
    end
    local panel2 = GUI:GetUI("dev/outui/Activity/Panel/KLActivityPreview/KLActivityPreviewPanel")
    if panel2 then
        panel2:OnClickClose()
    end
end


function this:Close()
    self.is_open = false
    self:UnRegistEvents()
    if self.updateID then
        SL:UnSchedule(self.updateID)
        self.updateID = nil
    end
end

function this:LUA_EVENT_MAP_MONSTER_STATUS( ... )
    if not self.is_open then
        return
    end
    self.nextDoRevTime = Time.time+Time.deltaTime
end

function this:LUA_EVENT_MAP_MONSTER_STATUS_CHANGE( _id,message )
    if not self.is_open then
        return
    end
    self.nextDoRevTime = Time.time+Time.deltaTime
end

return this
