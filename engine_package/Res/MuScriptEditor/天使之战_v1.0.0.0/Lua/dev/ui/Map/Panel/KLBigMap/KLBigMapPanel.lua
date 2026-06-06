---@class KLBigMapPanel:UIKmlLuaPanelBase
---@field view KLBigMapPanelView
local KLBigMapPanel = class(UIKmlLuaPanelBase)
local this = KLBigMapPanel

---@class MapMoveListItemData
---@field isGroup boolean
---@field isRoot boolean
---@field groupExpand boolean
---@field children cfg_mapMove_column[]
---@field data cfg_mapMove_column

---创建时调用一次
function this:Init()

    --self.controlMap = {}
    --self.mapMoveTabList = {}
    self.mapMoveGroup = {}
    ---@type MapMoveListItemData[]
    self.mapMoveListData = {}
    ---随机传送道具相关初始化
    self:InitDeliveryItemData()
    ---定点传送道具相关初始化
    self:InitFixedPointItemData()
    self.MapBtnPointTempList = {}---temp列表保存 

    self.MonsterPointPool = TablePool()---大地图
    self.monsterPointTempList = {}---temp列表保存 
    --[[    self.specialMonsterPointPool = TablePool()---大地图
        self.specialMonsterPointTempList = {}---temp列表保存]]

    -- ---@type cfg_mapMove_column[]
    -- local mapMoveTabList = SL:GetConfigTable("cfg_mapMove")
    -- for _, v in pairs(mapMoveTabList) do
    --     if SL:CheckCalculateConditionGroup(v.mapUIShow) then
    --         if v.group and v.group ~= 0 then
    --             --如果有分组
    --             if not self.mapMoveGroup[v.group] then
    --                 self.mapMoveGroup[v.group] = {}

    --                 ---@type MapMoveListItemData
    --                 local item = {}
    --                 item.isGroup = true
    --                 item.data = v
    --                 item.isRoot = true
    --                 table.insert(self.mapMoveListData, item)
    --             end
    --             ---@type MapMoveListItemData
    --             local item = {}
    --             item.isGroup = false
    --             item.data = v
    --             item.isRoot = false
    --             table.insert(self.mapMoveGroup[v.group], item)
    --         else
    --             ---@type MapMoveListItemData
    --             local item = {}
    --             item.isGroup = false
    --             item.data = v
    --             item.isRoot = true
    --             table.insert(self.mapMoveListData, item)
    --         end

    --     end
    -- end
    -- --填充children
    -- for _, v in pairs(self.mapMoveListData) do
    --     if v.isGroup then
    --         v.children = self.mapMoveGroup[v.data.group]
    --     end
    -- end
    --[[    GUI:DataListInitData(self.view.TransferList, function() return self:TransferListCountGetFun() end,
                function(realIndex) return self:TransferListGetFun(realIndex) end,
                nil,
                function(realIndex,item) self:TransferListUpdateFun(realIndex,item) end,
                nil)]]
    GUI:OSAScrollView_Initialized(self.view.TransferScrollView, self.TransferItemGetFun, self.TransferItemUpdateFun, self)
    GUI:OSAScrollView_SetItemSizeGetFun(self.view.TransferScrollView, self.TransferItemSizeGetFun, self)
    ---@type table<string,UIKmlLuaPanelBase>
    self.iconMap = {}
    ---@type table<string,KLMapMonsterPointCircleItem>
    self.monsterCircleiconMap = {}
    self.sceneImgWidth, self.sceneImgHeight = GUI:getSizeDelta(self.view.img_scene)
    self.showedRoadPoints = {}

    self.mapIconVisibleInfo = {}
    ---@type KLMiniMapPanel
    local minimapPanel = GUI:GetUI("dev/ui/Map/Panel/KLMiniMap/KLMiniMapPanel")
    if minimapPanel then
        for k, v in pairs(minimapPanel.mapIconVisibleInfo) do
            self.mapIconVisibleInfo[k] = v
        end
    end
    self.teamPosTimer = nil
    self.teamPlayerPosIconList = {
        [1] = { icon = self.view.img_player_icon_1 ,name = self.view.img_player_icon_Name_1},
        [2] = { icon = self.view.img_player_icon_2 ,name = self.view.img_player_icon_Name_2},
        [3] = { icon = self.view.img_player_icon_3 ,name = self.view.img_player_icon_Name_3},
        [4] = { icon = self.view.img_player_icon_4 ,name = self.view.img_player_icon_Name_4},
        [5] = { icon = self.view.img_player_icon_5 ,name = self.view.img_player_icon_Name_5},
    }
end

function this:GuideToShowMap(moveMapId)
    local index = 1
    for i, v in ipairs(self.mapMoveListData) do
        if v.data.id == moveMapId then
            index = i
            break
        end
    end
    GUI:OSAScrollView_ScrollTo(self.view.TransferScrollView, index - 1)
end

function this:TransferItemSizeGetFun(index)
    local data = self.mapMoveListData[index + 1]
    if data.isRoot then
        return 47
    end
    return 34
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

--[[function this:TransferListCountGetFun()
    return #self.mapMoveListData
end]]

--[[function this:TransferListGetFun()
    local itemPanel = GUI:UIPanel_Open("dev/ui/Map/Item/KLBigMapTransferItem/KLBigMapTransferItemItem",self.view.TransferList,self,nil,true)
    self.controlMap[itemPanel.view.root.kmlControl] = itemPanel
    return itemPanel.view.root.kmlControl
end]]

--[[
function this:TransferListUpdateFun(realIndex,item)
    ---@type KLBigMapTransferItemItem
    local itemPanel = self.controlMap[item]
    itemPanel:RefreshUI(self.mapMoveListData[realIndex + 1], function()
        self:RefreshListData()
        --GUI:DataListUpdateData(self.view.TransferList)
        self:RefreshTransferList()
    end)
end
]]

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

---创建或者刷新界面数据时调用
function this:Refresh()
    SL.HideMainPanel()
    GUI:setVisible(self.view.txt_pos, false)
    GUI:Slider_setPercent(self.view.slider_map_size, 1.5)
    self:SetDeliveryItem()
    self:SetFixedPointItem()
    GUI:AddOnClickEvent(self.view.Delivery_Item, self, function()
        local count = SL:GetBagItemCount(self.DeliveryItemID)
        local DeliveryItemJumpPathList = self.DeliveryItemJumpPathList
        if count < 1 then
            SL:CommonTipsMessage({ stringTblID = 494,
                                   ui = self,
                                   sureBtnText = "确定",
                                   cancelBtnText = "取消",
                                   callback = function()
                                       if GUI:GetUI("dev/ui/Map/Panel/KLBigMap/KLBigMapPanel") then
                                           self:BtnCloseOnClick()
                                       end
                                       shortcutOutMgr.DO(DeliveryItemJumpPathList)
                                   end })
            return
        end
        local item_Data = SL:MeData_GetCfgBaseOnItemId(self.DeliveryItemID)
        if item_Data then
            self.isUseDelivery = true
            self:ClearAllRoadPoint()
            SL:UseItem(self.DeliveryItemID, item_Data.id, 1)
        end
    end)

    --GUI:DataListUpdateData(self.view.TransferList)
    local jumpListIndex
    if self.args then
        local jumpIndex = tonumber(self.args[1])
        jumpListIndex = self:RefreshListDataWithJumpIndex(jumpIndex)
    end
    self:RefreshTransferList()
    if jumpListIndex then
        GUI:OSAScrollView_ScrollTo(self.view.TransferScrollView, jumpListIndex - 1)
    end
    local mapId = SL:GetMetaValue(EMetaVarGetKey.MAP_ID)
    ---@type cfg_map_info_column
    local mapInfo = SL:GetConfig("cfg_map_info", mapId)
    self.initMapScale = mapInfo.showSize or 1
    self.initPivot = { 0.5, 0.5 }
    self.iconScale = 1 / self.initMapScale
    if mapInfo.showPosition then
        self.initPivot = mapInfo.showPosition
        GUI:SetAnchorAdvanced(self.view.panel_scene, self.initPivot[1], self.initPivot[2])
        GUI:setPosition(self.view.panel_scene, 0, 0)
    end
    GUI:setScale(self.view.panel_scene, self.initMapScale)
    GUI:setScale(self.view.img_player_icon, self.iconScale)
    local mapFile = SL:GetMetaValue(EMetaVarGetKey.MINIMAP_FILE)
    GUI:Image_loadTexture(self.view.img_scene, string.format("Texture/%s.png", mapFile))
    self:SetTransferIcon()
    self:SetNpcIcon()
    self:SetOtherIcon()
    self:ZoomMap(1.5)

    self:ShowPlayerIcon()
    --self:SetMonsterCircel()
    self:ShowCurPath()
    SL:ReqMapMonsterStatusMessage(mapId)

    ---设置npc传送列表
    GUI:AddOnClickEvent(self.view.btn_npc_transfer1, self, self.TransferToCompoundNpc)
    ---地图名称
    GUI:Text_setString(self.view.text_map_name, SL:GetMetaValue(EMetaVarGetKey.MAP_NAME))

    --[[    if not SL:GetIsWebGL() then
            GUI:setAnchorPoint(self.view.btn_close, 2, 1)
            GUI:setPosition(self.view.btn_close, 4, -48)
        end]]

    self:SetNpcTransferCondition(100404, self.view.Level_npc_transfer1, self.view.cost_npc_transfer1, self.view.label_npc_transfer1)
    self:SetNpcTransferCondition(100101, self.view.Level_npc_shop1, self.view.cost_npc_shop1, self.view.label_npc_shop1)
    
    self:HideAllTeamPos()
    local teamInfo = SL:GetMetaValue(EMetaVarGetKey.TEAM_MEMBER_INFO)
    if not table.isNullOrEmpty(teamInfo.teamMember) then
        self.teamPosTimer = SL:Schedule(self.teamPosTimer, 0, 5, -1, function()
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_GET_TEAM_MEMBER_POSITION)
        end)
    end
end
function this:RES_GET_TEAM_MEMBER_POSITION(_, message)
    if message then
        for index,teamPos in pairs(self.teamPlayerPosIconList) do
            GUI:SetActive(teamPos.icon, false)
            for i, v in pairs(message) do
                if tonumber(i) == index then
                    self:SetPlayerPos(tonumber(i), v.x, v.y,v.rid)
                    break
                end
            end
        end

    end
end
function this:SetPlayerPos(index, posX, posY,rid)
    local teamInfo = SL:GetMetaValue(EMetaVarGetKey.TEAM_MEMBER_INFO)
    if not table.isNullOrEmpty(teamInfo.teamMember) then
        local x = posX / 256 * self.sceneImgWidth - self.sceneImgWidth / 2
        local z = posY / 256 * self.sceneImgHeight - self.sceneImgHeight / 2
        GUI:setPosition(self.teamPlayerPosIconList[index].icon, x, z)
        GUI:setRotation(self.teamPlayerPosIconList[index].icon, 0)
        for _,v in pairs(teamInfo.teamMember) do
            if v.roleInfo.rid == rid then
                GUI:Text_setText(self.teamPlayerPosIconList[index].name,v.roleInfo.name)
                break
            end
        end
        GUI:SetActive(self.teamPlayerPosIconList[index].icon, true)
    end
end
function this:TeamInfoChange(_, message)
    message = ToolFunc:tblkeytonumber(message)
    local isShowTeamUI = message and message.teamMember and table.count(message.teamMember) > 1 ---大于1个人才显示队友
    if isShowTeamUI then
        self.teamPosTimer = SL:Schedule(self.teamPosTimer, 0, 5, -1, function()
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_GET_TEAM_MEMBER_POSITION)
        end)
    else
        self:HideAllTeamPos()
        if self.teamPosTimer then
            SL:UnSchedule(self.teamPosTimer)
            self.teamPosTimer = nil
        end
    end
end
function this:HideAllTeamPos()
    for _,v in pairs(self.teamPlayerPosIconList) do
        GUI:SetActive(v.icon, false)
    end
end
function this:TransferToCompoundNpc()
    --self:BtnCloseOnClick()
    SL:SendTransferToNpcMessage(100404, true)

end
function this:SetNpcTransferCondition(npcListId, levelText, costText, nameText)
    local npcList = SL:GetConfig("cfg_npclist", npcListId)
    local map_info = SL:GetConfig("cfg_map_info", npcList.mapId)
    local mapMove_info = SL:GetConfigMultiKeys("cfg_mapMove", npcList.mapId, "mapID")
    local levelCondition = false
    local CostCondition = true
    local mapId = SL:GetMetaValue(EMetaVarGetKey.MAP_ID)
    levelCondition = true
    if mapMove_info.level and mapMove_info.level ~= "" then
        levelCondition = mapMove_info.level <= SL:MeData_GetLevel()
    end
    if levelText then
        if mapMove_info.level == 0 then
            GUI:Text_setText(levelText, "")
        else
            GUI:Text_setText(levelText, tostring(mapMove_info.level))
        end
        GUI:Text_setText(levelText, "")
        GUI:Text_setTextColor(levelText, levelCondition and "#FFFFFF" or "#FF2323")
    end
    self.cost = map_info.transferCost
    if self.cost and self.cost[1] and self.cost[1][2] then
        CostCondition = self.cost[1][2] * InfoManager.redNameInfo:GetMapTransmissionCost() <= SL:GetBagItemCount(self.cost[1][1])
        --[[        if mapId == npcList.mapId then
                    CostCondition = true
                end]]
        if costText then
            --[[            if mapId == npcList.mapId then
                            GUI:Text_setString(costText, "0")
                        else
                            GUI:Text_setString(costText, self.cost[1][2] .. "" or "")
                        end]]
            --GUI:Text_setString(costText, self.cost[1][2] .. "" or "")
            --GUI:Text_setTextColor(costText, CostCondition and "#E6E600" or "#FF2323")
        end
    else
        CostCondition = true
        --GUI:Text_setString(costText, "0")
        --GUI:Text_setTextColor(costText, CostCondition and "#E6E600" or "#FF2323")
    end
    CostCondition = true
    if nameText then
        GUI:Text_setTextColor(nameText, (levelCondition and CostCondition) and "#FFFFFF" or "#FF2323")
    end
    return levelCondition, CostCondition
end
function this:RefreshTransferList()
    self.MapBtnPointTempList = {}
    GUI:OSAScrollView_RefreshList(self.view.TransferScrollView, #self.mapMoveListData)
end

---初始化随机传送道具信息
function this:InitDeliveryItemData()
    ---随机传送道具id
    self.DeliveryItemID = 60010001
    ---随机传送道具的跳转路径
    self.DeliveryItemJumpPathList = { "openUIPanel", "dev/outui/ShopMain/Panel/KLShopMain/KLShopMainPanel", "1", "1" }
    ---@type cfg_item_column
    local itemCfg = SL:GetConfig("cfg_item", self.DeliveryItemID)
    for i, v in ipairs(itemCfg.Quickshopping) do
        if v[1] == "2" and v[3] == "商城" and v[4] == "openUIPanel" then
            self.DeliveryItemJumpPathList = {}
            for z, a in ipairs(v) do
                if z > 3 then
                    table.insert(self.DeliveryItemJumpPathList, a)
                end
            end
            break
        end
    end
end

---初始化定点传送道具信息
function this:InitFixedPointItemData()
    ---@type cfg_global_column
    local globalCfg = SL:GetConfig("cfg_global", 25003)
    local strList = string.split(globalCfg.value, '#')
    ---定点传送道具id
    self.FixedPointItemID = tonumber(strList[1])
    ---定点传送道具所需数量
    self.FixedPointItemNeedCount = tonumber(strList[2])
    ---是否勾选了定点传送
    self.isSelectFixedPoint = false
    ---定点传送道具的跳转路径
    self.FixedPointItemJumpPathList = { "openUIPanel", "dev/outui/ShopMain/Panel/KLShopMain/KLShopMainPanel", "1", "1" }
    ---@type cfg_item_column
    local itemCfg = SL:GetConfig("cfg_item", self.FixedPointItemID)
    for i, v in ipairs(itemCfg.Quickshopping) do
        if v[1] == "2" and v[3] == "商城" and v[4] == "openUIPanel" then
            self.FixedPointItemJumpPathList = {}
            for z, a in ipairs(v) do
                if z > 3 then
                    table.insert(self.FixedPointItemJumpPathList, a)
                end
            end
            break
        end
    end
    self.isSelectFixedPoint = PlayerPrefs.GetInt("SelectFixedPoint" .. SL:GetMetaValue(EMetaVarGetKey.UID)) == 1
    GUI:Toggle_setIsOn(self.view.FixedPointToggle, self.isSelectFixedPoint)
end

---设置随机传送道具的数量，id，数量文本颜色
function this:SetDeliveryItem()
    local count = SL:GetBagItemCount(self.DeliveryItemID)
    local colorStr = "#fbd994"
    if count < 1 then
        colorStr = "#ff2323"
    end
    GUI:Item_UpdataData(self.view.Delivery_Item, {
        itemid = tostring(self.DeliveryItemID),
        itemcustomcount = SL:GetBagItemCount(self.DeliveryItemID),
    })
end

---设置定点传送道具的id
function this:SetFixedPointItem()
    local count = SL:GetBagItemCount(self.FixedPointItemID)
    local colorStr = "#fbd994"
    if count < 1 then
        colorStr = "#ff2323"
    end
    GUI:SetZIndex(self.view.FixedPointItemCount, 201)
    GUI:Text_setString(self.view.FixedPointItemCount, "<color=" .. colorStr .. ">" .. SL:GetSimpleNumber(SL:GetBagItemCount(self.FixedPointItemID), 1) .. "</color>")
    GUI:Item_UpdataData(self.view.FixedPointItem, {
        itemid = tostring(self.FixedPointItemID),
        itemcustomcount = "",
        mscale = "25,25,25",
    })
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnTouchEvent(self.view.img_drag, self, self.OnSceneTouch1)
    GUI:AddOnTouchEvent(self.view.img_scene, self, self.OnSceneTouch2)
    GUI:AddOnClickEvent(self.view.btn_close, self, self.BtnCloseOnClick)
    GUI:Slider_addOnEvent(self.view.slider_map_size, self, self.SliderMapSizeOnEvent)
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_MAPPOS_CHANGE, self.OnPlayerMapPosChange, self)
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_TURN_DIR, self.OnPlayerTurnDir, self)
    SL:RegisterLUAEvent(LUA_EVENT_BAG_CHANGE_AFTER, self.LUA_EVENT_BAG_CHANGE_AFTER, self)
    GUI:AddOnClickEvent(self.view.btn_map_zoom_in, self, self.BtnMapZoomInOnClick)
    GUI:AddOnClickEvent(self.view.btn_map_zoom_out, self, self.BtnMapZoomOutOnClick)
    GUI:AddOnClickEvent(self.view.FixedPointItem, self, self.BtnFixedPointItemOnClick)
    SL:RegisterLuaNetMsg(MessageDef.ResMapMonsterStatusMessage, self.ResMapMonsterStatusMessage, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_GET_TEAM_MEMBER_POSITION, self.RES_GET_TEAM_MEMBER_POSITION, self)
    SL:RegisterLUAEvent(LUA_EVENT_TEAM_INFO_CHANGE, self.TeamInfoChange,self)
    ---特别袖珍罐商店
    GUI:AddOnClickEvent(self.view.btn_npc_shop1, self, self.TransferToShopNpc)
    ---幻影导师
    GUI:AddOnClickEvent(self.view.btn_npc_buff, self, self.TransferToBuffNpc)
    ---点击传送恶魔广场NPC
    GUI:AddOnClickEvent(self.view.btn_npc_activity1, self, self.TransferToActivity1Npc)
    ---点击传送血色城堡NPC
    GUI:AddOnClickEvent(self.view.btn_npc_activity2, self, self.TransferToActivity2Npc)
    ---点击传送勇者大陆仓库NPC
    GUI:AddOnClickEvent(self.view.btn_npc_cangku1, self, self.TransferToCangku1Npc)
    ---点击传送仙踪林仓库NPC
    GUI:AddOnClickEvent(self.view.btn_npc_cangku2, self, self.TransferToCangku2Npc)
    ---点击传送幻术园仓库NPC
    GUI:AddOnClickEvent(self.view.btn_npc_cangku3, self, self.TransferToCangku3Npc)
    ---点击传送冰风谷仓库NPC
    GUI:AddOnClickEvent(self.view.btn_npc_cangku4, self, self.TransferToCangku4Npc)

    GUI:SetToggleOnValueChange(self.view.FixedPointToggle, self, self.FixedPointToggleChange)

end
function this:TransferToShopNpc()
    --self:BtnCloseOnClick()
    SL:SendTransferToNpcMessage(100101, true)
end
function this:TransferToActivity1Npc()
    --self:BtnCloseOnClick()
    SL:SendTransferToNpcMessage(100406, true)
end
function this:TransferToBuffNpc()
    --self:BtnCloseOnClick()
    SL:SendTransferToNpcMessage(100104, true)
end
function this:TransferToActivity2Npc()
    --self:BtnCloseOnClick()
    SL:SendTransferToNpcMessage(100306, true)
end
function this:TransferToCangku1Npc()
    --self:BtnCloseOnClick()
    SL:SendTransferToNpcMessage(100107, true)
end
function this:TransferToCangku2Npc()
    --self:BtnCloseOnClick()
    SL:SendTransferToNpcMessage(100405, true)
end
function this:TransferToCangku3Npc()
    --self:BtnCloseOnClick()
    SL:SendTransferToNpcMessage(105201, true)
end
function this:TransferToCangku4Npc()
    --self:BtnCloseOnClick()
    SL:SendTransferToNpcMessage(100302, true)
end
---点击定点道具显示tips
function this:BtnFixedPointItemOnClick()
    SL:OpenTips("", self.FixedPointItemID)
end

function this:FixedPointToggleChange(control, eventData, value)
    self.isSelectFixedPoint = value[1]
    PlayerPrefs.SetInt("SelectFixedPoint" .. SL:GetMetaValue(EMetaVarGetKey.UID), value[1] and 1 or 0)
end

function this:LUA_EVENT_BAG_CHANGE_AFTER(_, message)
    if message then
        self:SetDeliveryItem()
        self:SetFixedPointItem()
    end
end

function this:OnSceneTouch1(_, touchType)
    if touchType == EUIEventName.OnBeginDrag then
        self.beginDragPos = SL:GetMetaValue(EMetaVarGetKey.MOUSE_MOVE_POS)
        self.beginMapPosX, self.beginMapPosY = GUI:getPosition(self.view.panel_scene)
    elseif touchType == EUIEventName.OnDrag then
        if not self.beginDragPos then
            return
        end
        local pos = SL:GetMetaValue(EMetaVarGetKey.MOUSE_MOVE_POS)
        local delta = pos - self.beginDragPos
        local finalPosX = self.beginMapPosX + delta[0]
        local finalPosY = self.beginMapPosY + delta[1]
        local fac = 1 / self.iconScale * 0.5
        if finalPosX < -self.sceneImgWidth * fac then
            finalPosX = -self.sceneImgWidth * fac
        elseif finalPosX > self.sceneImgWidth * fac then
            finalPosX = self.sceneImgWidth * fac
        end
        if finalPosY < -self.sceneImgHeight * fac then
            finalPosY = -self.sceneImgHeight * fac
        end
        if finalPosY > self.sceneImgHeight * fac then
            finalPosY = self.sceneImgHeight * fac
        end
        GUI:setPosition(self.view.panel_scene, finalPosX, finalPosY)
    elseif touchType == EUIEventName.OnEndDrag then
        self.beginDragPos = nil
    end
end

function this:OnSceneTouch2(_, touchType)
    if touchType == EUIEventName.OnBeginDrag then
        self.beginDragPos = SL:GetMetaValue(EMetaVarGetKey.MOUSE_MOVE_POS)
        self.beginMapPosX, self.beginMapPosY = GUI:getPosition(self.view.panel_scene)
        self.oldSceneTouchType = EUIEventName.OnBeginDrag
    elseif touchType == EUIEventName.OnDrag then
        if not self.beginDragPos then
            return
        end
        local pos = SL:GetMetaValue(EMetaVarGetKey.MOUSE_MOVE_POS)
        local delta = pos - self.beginDragPos
        local finalPosX = self.beginMapPosX + delta[0]
        local finalPosY = self.beginMapPosY + delta[1]
        local fac = 1 / self.iconScale * 0.5
        if finalPosX < -self.sceneImgWidth * fac then
            finalPosX = -self.sceneImgWidth * fac
        elseif finalPosX > self.sceneImgWidth * fac then
            finalPosX = self.sceneImgWidth * fac
        end
        if finalPosY < -self.sceneImgHeight * fac then
            finalPosY = -self.sceneImgHeight * fac
        end
        if finalPosY > self.sceneImgHeight * fac then
            finalPosY = self.sceneImgHeight * fac
        end
        GUI:setPosition(self.view.panel_scene, finalPosX, finalPosY)
    elseif touchType == EUIEventName.OnEndDrag then
        self.beginDragPos = nil
    elseif touchType == EUIEventName.OnPointerClick then
        --点击拖拽的时候也会调用这个事件 需要判断一下是不是拖拽
        if self.oldSceneTouchType == EUIEventName.OnBeginDrag then
            self.oldSceneTouchType = nil
            return
        end
        local posX, posY = self:GetCurrentMousePosInMap()
        if SL.LoginInfo:IsSDK() or SL.LoginInfo:IsWhitePkg() then

        else
            GUI:setVisible(self.view.txt_pos, true)
            GUI:Text_setString(self.view.txt_pos, math.round(posX) .. ", " .. math.round(posY))
        end
        if self.isSelectFixedPoint then
            --选择了定点传送
            if not SL:GetMetaValue(EMetaVarGetKey.MAP_IS_OBSTACLE, math.round(posX), math.round(posY)) then
                --不为阻挡点
                local count = SL:GetBagItemCount(self.FixedPointItemID)
                local FixedPointItemJumpPathList = self.FixedPointItemJumpPathList
                if count < self.FixedPointItemNeedCount then
                    SL:CommonTipsMessage({ stringTblID = 497,
                                           ui = self,
                                           sureBtnText = "确定",
                                           cancelBtnText = "取消",
                                           callback = function()
                                               if GUI:GetUI("dev/ui/Map/Panel/KLBigMap/KLBigMapPanel") then
                                                   self:BtnCloseOnClick()
                                               end
                                               shortcutOutMgr.DO(FixedPointItemJumpPathList)
                                           end })
                    return
                end
                self:ClearAllRoadPoint()
                SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_TRANSFER_WITHIN_MAP, { math.round(posX), math.round(posY) })
            else
                SL:TipMessage(SL:GetConfig('cfg_string', 498).text, 1, NoticeType.NoticeMid)
            end
            return
        end
        ---@type ArriveFuncData
        local arriveFuncData = {}
        arriveFuncData.IsAutoFight = true
        arriveFuncData.callBack = function()
            local isSafe = SL:GetMetaValue(EMetaVarGetKey.IN_SAFE_AREA)
            if not isSafe then
                SL:StartOnHook(true, true)
            end
        end
        SL:StopOnHook(true)
        local roadRight = SL:Me_TriggerToMove(Dot2.New(math.round(posX), math.round(posY)), nil, nil, arriveFuncData, true, nil, nil, true, true)
        if roadRight then
            self:ShowCurPath()
            SL:onLUAEvent(LUA_EVENT_CLOSE_BOSS_PATH_CHECK)
        end
    elseif touchType == EUIEventName.onDoublePointerClick then
        if (SL:GetMetaValue("PLATFORM_MOBILE") or SL:GetMetaValue("H5PLAYMODE") or (not SL:GetIsXtra() and SL:GetMetaValue("WINPLAYMODE"))) and SL:GetMetaValue("IS_SDK_LOGIN") then
            return
        end
        self:ClearAllRoadPoint()
        local posX, posY = self:GetCurrentMousePosInMap()
        ---外置使用新协议，区分双击地图传送与其他传送
        --SL:MapTransferXY(0, math.round(posX), math.round(posY))
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_CUSTOME_TRANSFER, { x = posX, y = posY })
        SL:onLUAEvent(LUA_EVENT_CLOSE_BOSS_PATH_CHECK)
    end
end

function this:BtnCloseOnClick()
    GUI:OSAScrollView_SetScrollable(self.view.TransferScrollView, true)
    GUI:UIPanel_Close("dev/ui/Map/Panel/KLBigMap/KLBigMapPanel")
    --GUI:OSAScrollView_ScrollTo("")
end

function this:Close()
    if self.teamPosTimer then
        SL:UnSchedule(self.teamPosTimer)
        self.teamPosTimer = nil
    end
    if self.iconMap then
        for k, v in pairs(self.iconMap) do
            GUI:UIPanel_Close(_, v)
        end
        table.clear(self.iconMap)
    end
    if self.monsterCircleiconMap then
        for k, v in pairs(self.monsterCircleiconMap) do
            GUI:UIPanel_Close(_, v)
        end
        table.clear(self.monsterCircleiconMap)
    end
    --[[for _, point in pairs(self.showedRoadPoints) do
        point.kmlControl:Hide()
    end
    table.clear(self.showedRoadPoints)
    if self.roadPointStack then
        while not self.roadPointStack:IsEmpty() do
            local point = self.roadPointStack:Pop()
            point.kmlControl:Hide()
        end
    end]]
    self.MonsterPointPool:Clear()
    self.monsterPointTempList = {}---temp列表保存
    --[[    self.specialMonsterPointPool:Clear()
        self.specialMonsterPointTempList = {}---temp列表保存]]

    if self.DeliveryTimer then
        SL:UnSchedule(self.DeliveryTimer)
    end
    SL.ShowMainPanel()
end

function this:GetCurrentMousePosInMap()
    local pos = SL:GetMetaValue(EMetaVarGetKey.MOUSE_MOVE_POS)
    local _, relativePos = SL:ScreenPointToLocalPointInRectangle(self.view.panel_scene, pos[0], pos[1])
    local clickPosX = relativePos[0] + self.sceneImgWidth * self.initPivot[1]
    local clickPosY = relativePos[1] + self.sceneImgHeight * self.initPivot[2]
    clickPosX = clickPosX / self.sceneImgWidth * 256
    clickPosY = clickPosY / self.sceneImgHeight * 256
    return clickPosX, clickPosY
end

---@设置传送点图标
function this:SetTransferIcon()
    local mapId = SL:GetMetaValue(EMetaVarGetKey.MAP_ID)
    ---@type cfg_transfer_point_column[]
    local transferPoint = SL:FindConfigs('cfg_transfer_point', 'mapId', mapId)
    if transferPoint then
        for _, v in pairs(transferPoint) do
            local transferIcon = GUI:UIPanel_Open("dev/ui/Map/Item/KLMapTransferIcon/KLMapTransferIconItem", self.view.icon_parent, self, v, true)
            self:SetMapIcon("MapTransferIcon" .. v.id, transferIcon, v.position[1], v.position[2])
        end
    end

end

function this:SetNpcIcon()
    local mapId = SL:GetMetaValue(EMetaVarGetKey.MAP_ID)
    ---@type cfg_npclist_column[]
    local npcList = SL:FindConfigs('cfg_npclist', 'mapId', mapId)
    if npcList then
        for _, npcTbl in pairs(npcList) do
            local npcIcon = GUI:UIPanel_Open("dev/ui/Map/Item/KLMapNpcIcon/KLMapNpcIconItem", self.view.icon_parent, self, { npcTbl, true }, true)
            self:SetMapIcon("MapNpcIcon" .. npcTbl.id, npcIcon, npcTbl.x, npcTbl.y)
        end
    end
end

function this:SetMonsterCircel()
    local mapId = SL:GetMetaValue(EMetaVarGetKey.MAP_ID)
    local line = SL:GetMetaValue("MAP_LINE")
    ---@type cfg_monsterPoint_column[]
    local monsterPointList = SL:FindConfigs('cfg_monsterPoint', 'mapId', mapId)
    if monsterPointList then
        local monsterPointList2 = {}
        for k, v in pairs(monsterPointList) do
            if v.mapline then
                if table.contains(v.mapline, line) then
                    table.insert(monsterPointList2, v)
                end
            else
                table.insert(monsterPointList2, v)
            end
        end
        for _, monsterPointTbl in pairs(monsterPointList2) do
            local monsterPointIcon = GUI:UIPanel_Open("dev/outui/Map/Item/KLMapMonsterPointCircle/KLMapMonsterPointCircleItem", self.view.monsterCircelIcon_parent, self, { mapIconVisibleInfo = self.mapIconVisibleInfo[monsterPointTbl.id], monsterPointTbl, true }, true)
            local x = monsterPointTbl.pos[1]
            local y = monsterPointTbl.pos[2]
            self:SetMonsterCircleIcon("MapMonsterPoint" .. monsterPointTbl.id, monsterPointIcon, x, y)
        end
    end
end

function this:SetOtherIcon()
    local bingFengBaoInfo = InfoManager.bingFengBaoInfo
    if bingFengBaoInfo:IsInBingFengMap() then
        local icon = GUI:UIPanel_Open("dev/outui/Map/Item/KLMapOtherPoint/KLMapOtherPointItem", self.view.icon_parent, self, { icon = "ico_binFen", name = "冰风堡战役" }, true)
        self:SetMapIcon("BingFengIcon", icon, bingFengBaoInfo.occupyConfig[2], bingFengBaoInfo.occupyConfig[3])
    end
end

---@param id string
---@param item UIKmlLuaPanelBase
function this:SetMapIcon(id, item, x, y)
    if self.iconMap[id] then
        GUI:UIPanel_Close(_, self.iconMap[id])
        self.iconMap[id] = nil
    end
    --GUI:SetParent(icon,self.view.scene_group)
    --item.kmlControl:SetParent(self.view.icon_parent.kmlControl)
    local miniMapX = x / 256 * self.sceneImgWidth - self.sceneImgWidth / 2
    local miniMapY = y / 256 * self.sceneImgHeight - self.sceneImgHeight / 2
    GUI:setPosition(item.view.root, miniMapX, miniMapY)
    self.iconMap[id] = item

end

---@param id string
---@param item UIKmlLuaPanelBase
function this:SetMonsterCircleIcon(id, item, x, y)
    if self.monsterCircleiconMap[id] then
        GUI:UIPanel_Close(_, self.monsterCircleiconMap[id])
        self.monsterCircleiconMap[id] = nil
    end

    --GUI:SetParent(icon,self.view.scene_group)
    --item.kmlControl:SetParent(self.view.icon_parent.kmlControl)
    local miniMapX = x / 256 * self.sceneImgWidth - self.sceneImgWidth / 2
    local miniMapY = y / 256 * self.sceneImgHeight - self.sceneImgHeight / 2
    GUI:setPosition(item.view.root, miniMapX, miniMapY)
    GUI:setScale(item.view.root, 1 / GUI:getScale(self.view.panel_scene))
    self.monsterCircleiconMap[id] = item
    if self.mapIconVisibleInfo[id] then
        GUI:setVisible(item.view.root, self.mapIconVisibleInfo[id] == "1")
    end
end

---@return UIKmlLuaControl
function this:PopRoadPoint()
    if not self.roadPointStack then
        self.roadPointStack = Stack:New()
    end
    local point
    if self.roadPointStack:Count() > 0 then
        point = self.roadPointStack:Pop()
    else
        point = GUI:Image_Create(self.view.monsterCircelIcon_parent, { ["src"] = "img_minimap__greenpoint", ["atlas"] = "Atlas/FG_MapPanel.spriteatlas", ["a"] = "12" })
    end
    GUI:setVisible(point, true)
    GUI:setScale(point, self.iconScale)
    return point
end

---@param point
function this:PushRoadPoint(point)
    GUI:setVisible(point, false)
    if not self.roadPointStack then
        self.roadPointStack = Stack:New()
    end
    self.roadPointStack:Push(point)
end

function this:ClearAllRoadPoint()
    for _, v in pairs(self.showedRoadPoints) do
        self:PushRoadPoint(v)
    end
    table.clear(self.showedRoadPoints)
end

function this:ShowCurPath()
    self:ClearAllRoadPoint()
    local path = SL:GetMetaValue(EMetaVarGetKey.MAP_PATH_POINTS)
    local index = SL:GetMetaValue(EMetaVarGetKey.MAP_CURRENT_PATH_INDEX)
    if not path or not path.n then
        return
    end
    for i = index, path.n, 4 do
        local p = path.list[i]
        local point = self:PopRoadPoint()
        GUI:setPosition(point, p.x / 256 * self.sceneImgWidth, p.z / 256 * self.sceneImgHeight)
        self.showedRoadPoints[i] = point
    end
end

function this:OnPlayerMapPosChange()
    local index = SL:GetMetaValue(EMetaVarGetKey.MAP_CURRENT_PATH_INDEX)
    index = index or 0
    for i = 1, index do
        local point = self.showedRoadPoints[i]
        if point then
            self:PushRoadPoint(point)
            self.showedRoadPoints[i] = nil
        end
    end
    self:RefreshPlayerIconPos()
    ---使用了随机传送
    if self.isUseDelivery then
        self.isUseDelivery = false
        --再次寻路
        self.DeliveryTimer = SL:Schedule(self.DeliveryTimer, 0, 0.1, -1, function()
            self:ShowCurPath()
        end)

    end
end

function this:ShowPlayerIcon()
    self:RefreshPlayerIconPos()
    self:OnPlayerTurnDir(_, SL:GetMetaValue(EMetaVarGetKey.DIR))
end
function this:RefreshPlayerIconPos()
    ---@type Dot2
    local pos = SL:GetMetaValue(EMetaVarGetKey.MAP_PLAYER_POS)
    local x = pos.x / 256 * self.sceneImgWidth - self.sceneImgWidth / 2
    local z = pos.z / 256 * self.sceneImgHeight - self.sceneImgHeight / 2
    GUI:setPosition(self.view.img_player_icon, x, z)
end

function this:OnPlayerTurnDir(_, dir)
    GUI:setRotation(self.view.img_player_icon, (dir + 1) * -45)
end

function this:SliderMapSizeOnEvent(_, _, value)
    local scale = value[1]
    self:ZoomMap(scale)
end

function this:ZoomMap(scale)
    GUI:setScale(self.view.panel_scene, scale * self.initMapScale)
    --随着地图变大缩小
    self.iconScale = 1 / (scale * self.initMapScale)
    --随着地图变大变大
    --self.iconScale_2 = 1 / ((3 - scale) * self.initMapScale)

    for _, icon in pairs(self.monsterCircleiconMap) do
        local textKml = icon:GetTextKml()
        local tempScale = self.iconScale
        if self.iconScale < 1 then
            tempScale = 1
        end
        if scale < 1.3 then
            icon:FormatText(true)
        else
            icon:FormatText(false)
        end
        GUI:setScale(textKml, tempScale)
    end
    for iconName, icon in pairs(self.iconMap) do
        if string.contains(iconName, "MapMonsterPoint") then
            GUI:setScale(icon.view.root, 1 * GUI:getScale(self.view.panel_scene))
        else
            GUI:setScale(icon.view.root, self.iconScale)
        end
    end
    for _, point in pairs(self.showedRoadPoints) do
        GUI:setScale(point, self.iconScale)
    end
    GUI:setScale(self.view.img_player_icon, self.iconScale)
    for _,v in pairs(self.teamPlayerPosIconList) do
        GUI:setScale(v.icon, self.iconScale)
    end
    if next(self.monsterPointTempList) then
        for _, v in pairs(self.monsterPointTempList) do
            v:setScale(1 / GUI:getScale(self.view.panel_scene))
        end
    end
end

function this:BtnMapZoomInOnClick()
    local percent = GUI:Slider_getPercent(self.view.slider_map_size)
    percent = percent + 0.2
    if percent > 2 then
        percent = 2
    end
    GUI:Slider_setPercent(self.view.slider_map_size, percent)
    self:ZoomMap(percent)
end

function this:BtnMapZoomOutOnClick()
    local percent = GUI:Slider_getPercent(self.view.slider_map_size)
    percent = percent - 0.2
    if percent < 1 then
        percent = 1
    end
    GUI:Slider_setPercent(self.view.slider_map_size, percent)
    self:ZoomMap(percent)
end

--------------------大地图怪点-------------------------
function this:ShowMonsterPoint(message)
    for _, v in pairs(self.monsterPointTempList) do
        self.MonsterPointPool:Push(v)
    end
    self.monsterPointTempList = {}---temp列表保存

    local monsterPoints = message.monsterStatus
    for i, v in pairs(monsterPoints) do
        local x, y = 0
        x = v.pointX / 256 * self.sceneImgWidth - self.sceneImgWidth / 2
        y = v.pointY / 256 * self.sceneImgHeight - self.sceneImgHeight / 2
        if v.groupId ~= 0 then
            local monsterTbl = SL:GetConfig("cfg_monster", v.configId)
            local mongenTbl = SL:GetConfig("cfg_mongen", v.groupId)
            if monsterTbl and (monsterTbl.monsterShowIcon == 1 or monsterTbl.monsterShowName == 1 or monsterTbl.monsterShowLv == 1) then
                if (mongenTbl and mongenTbl.headpic == 1) or (mongenTbl and not next(mongenTbl)) then
                    local monsterPointTemp = self.MonsterPointPool:Pop()
                    if not next(monsterPointTemp) then
                        monsterPointTemp = GUI:UIPanel_Open("dev/ui/Map/Item/KLMapMonsterPoint/KLMapMonsterPointItem", self.view.icon_parent, self, nil, true)
                    end
                    self.monsterPointTempList[v.monsterId] = monsterPointTemp
                    monsterPointTemp:ShowBigMonsterIcon(v)
                    monsterPointTemp:SetPanelXY(x, y)
                    monsterPointTemp:SetPanelRotation(0)
                    monsterPointTemp:setScale(1 / GUI:getScale(self.view.panel_scene))
                    if v.status == 0 then
                        monsterPointTemp:SetDead()
                    else
                        monsterPointTemp:SetLive()
                    end
                end
            end
        else
            if SL:HasConfig("cfg_monster_attack", v.configId, "monid") then
                local monsterPointTemp = self.MonsterPointPool:Pop()
                if not next(monsterPointTemp) then
                    monsterPointTemp = GUI:UIPanel_Open("dev/ui/Map/Item/KLMapMonsterPoint/KLMapMonsterPointItem", self.view.icon_parent, self, nil, true)
                end
                self.monsterPointTempList[v.monsterId] = monsterPointTemp
                monsterPointTemp:ShowBigMonsterIcon(v)
                monsterPointTemp:SetPanelXY(x, y)
                monsterPointTemp:SetPanelRotation(0)
                monsterPointTemp:setScale(1 / GUI:getScale(self.view.panel_scene))
                if v.status == 0 then
                    monsterPointTemp:SetDead()
                else
                    monsterPointTemp:SetLive()
                end
            end
        end
    end
end

---@param message MapProtos.MapMonsterStatus
function this:ResMapMonsterStatusMessage(_, message)
    if message then
        --self:ShowMonsterPoint(message)
    end

end
--[[---设置当前地图中死亡的怪物状态
---@param message MapProtos.MonsterStatus[]
function this:MakeBigMapDeadMonsterIcon(message)
    for _, v in pairs(self.specialMonsterPointTempList) do
        v:SetActiveUI(false)
        self.specialMonsterPointPool:Push(v)
    end
    self.specialMonsterPointTempList = {}---temp列表保存

    for i, v in pairs(message) do
        if v.configId == 10008 then
            self:CreateSpecialMonsterIcon(v)
        else
            self:SetMonsterIcon(v)
        end
    end
end

---刷新地图怪点
---@param message MapProtos.MonsterStatus
function this:SetMonsterIcon(message)
    if self.monsterPointTempList[message.groupId] then
        self.monsterPointTempList[message.groupId]:SetActiveUI(true)
        if message.status == 0 then
            self.monsterPointTempList[message.groupId]:SetDead()
        else
            self.monsterPointTempList[message.groupId]:SetLive()
        end
    end
end
---刷新地图怪点
---@param message MapProtos.MonsterStatus
function this:SetSpecialMonsterIcon(message)
    if self.specialMonsterPointTempList[message.monsterId] then
        self.specialMonsterPointTempList[message.monsterId]:SetActiveUI(true)
        if message.status == 0 then
            self.specialMonsterPointTempList[message.monsterId]:SetDead()
        else
            self.specialMonsterPointTempList[message.monsterId]:SetLive()
        end
    end
end
---刷新地图怪点
---@param message MapProtos.MonsterStatus
function this:CreateSpecialMonsterIcon(message)
    ----@type cfg_monster_attack_column[]
    local cfg_monster_attackList =SL:GetConfigTable('cfg_monster_attack')
    if cfg_monster_attackList then
        local cfg_monster_attack = nil
        for k,v in pairs(cfg_monster_attackList) do
            if v.monid == message.configId then
                cfg_monster_attack = v
                break
            end
        end
        if cfg_monster_attack then
            local point = {[1] = message.pointX,[2] = message.pointY}
            local x, y = 0
            if table.count(point) > 1 then
                x = point[1]/256*self.sceneImgWidth - self.sceneImgWidth/2
                y = point[2]/256*self.sceneImgHeight - self.sceneImgHeight/2
            end
            ----@type KLMapMonsterPointItem
            local monsterPointTemp = self.specialMonsterPointPool:Pop()
            if not next(monsterPointTemp) then
                monsterPointTemp = GUI:UIPanel_Open("dev/ui/Map/Item/KLMapMonsterPoint/KLMapMonsterPointItem", self.view.icon_parent, self, nil, true)
            end
            --if not string.contains(monsterPointTemp.view.root.kmlControl.rectTransform.name,monsterPointTemp.panelName) then
            --    SL:LogError("dddddddddddddddddddddddd")
            --end
            self.specialMonsterPointTempList[message.monsterId] = monsterPointTemp
            monsterPointTemp:ShowBigMonsterIcon(cfg_monster_attack)
            monsterPointTemp:SetPanelXY(x, y)
            monsterPointTemp:SetPanelRotation(0)
            monsterPointTemp:setScale(1)
            monsterPointTemp:SetActiveUI(false)
        end
    end
    self:SetSpecialMonsterIcon(message)
end]]

return this
