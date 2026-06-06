---@class KLHookPointItem:UIKmlLuaPanelBase
---@field view KLHookPointItemView
---@field mapItems table<number,KLHookPointMapItem>
local KLHookPointItem = class(UIKmlLuaPanelBase)
local this =KLHookPointItem
---创建时调用一次
function this:Init()
    
    SL:KeepOpenPanel("KLHookPointItemKml",true)
    local cfgTbl = SL:GetConfigTable("cfg_hanguppoints")
    self.cfgDatas = {}
    self.mapDatas = {}
    local level = SL:GetMetaValue(EMetaVarGetKey.LEVEL)
    local levelRecommend
    local powersList = {}
    local minLevelMap
    local minLevel
    local allTable = SL:GetConfigTable("cfg_VIP")
    local goldway = {}
    ---@param value cfg_VIP_column
    for key, value in pairs(allTable) do
        if value.grade == InfoManager.newVipInfo.vipLevel then
            goldway = value.goldway
        end
    end
    local tempData = {}
    ---@param cfg cfg_hanguppoints_column
    for _, cfg in pairs(cfgTbl) do
        if SL:HasConfig("cfg_mapMove", cfg.mapMoveID) then
            if not self.cfgDatas[cfg.mapMoveID] then
                self.cfgDatas[cfg.mapMoveID] = {}
                --找到玩家当前等级解锁的最高等级的地图
                ---@type cfg_mapMove_column
                local mapMove = SL:GetConfig("cfg_mapMove", cfg.mapMoveID)
                local isMove = cfg.type ~= 1  or (cfg.type == 1 and table.contains(goldway,mapMove.mapID))
                tempData[cfg.mapMoveID] = isMove
                table.insert(self.mapDatas, {mapMoveId=cfg.mapMoveID,isMove = isMove})
                if isMove then
                    if not levelRecommend or level >= mapMove.level then
                        levelRecommend = cfg.mapMoveID
                    end
                    --找到等级最低的地图
                    if not minLevelMap or mapMove.level < minLevel then
                        minLevelMap = cfg.mapMoveID
                        minLevel = mapMove.level
                    end
                end
            end
            if not self.cfgDatas[cfg.mapMoveID][cfg.monsterGroup] then
                self.cfgDatas[cfg.mapMoveID][cfg.monsterGroup] = {}
                --找到每个地图等级最高的怪物，存入powersList
                if not powersList[cfg.mapMoveID] then
                    ---@type cfg_monster_column
                    local monster = SL:GetConfig("cfg_monster", cfg.monsterGroup)
                    powersList[cfg.mapMoveID] = monster.sword
                else
                    ---@type cfg_monster_column
                    local monster = SL:GetConfig("cfg_monster", cfg.monsterGroup)
                    if monster.sword > powersList[cfg.mapMoveID] then
                        powersList[cfg.mapMoveID] = monster.sword
                    end
                end
            end
            table.insert(self.cfgDatas[cfg.mapMoveID][cfg.monsterGroup], { coordinates = cfg.coordinates, count = cfg.monsterNum }) 
        end
    end
    --正常显示在玩家当前战力对比能打过的最高级怪物所在的地图上
    local powerRecommend
    local definse = SL:GetMetaValue("GET_ATTR_VALUE_BY_ID", EMUCharacterAttrType.armor)
    level = SL:GetMetaValue(EMetaVarGetKey.LEVEL)
    for k, v in pairs(powersList) do
        if definse >= v then
            ---@type cfg_mapMove_column
            local thisLv = SL:GetConfig("cfg_mapMove", k)
            if not powerRecommend and level > thisLv.level then
                powerRecommend = k
            elseif powerRecommend then
                ---@type cfg_mapMove_column
                local lv = SL:GetConfig("cfg_mapMove", powerRecommend)
                local isMove = tempData[k]
                if isMove and level > thisLv.level and thisLv.level >= lv.level and v >= powersList[powerRecommend] then
                    powerRecommend = k
                end
            end
        end
    end
    --满足a条件的怪物所在地图玩家未解锁时，显示在当前解锁的最高等级地图上
    local finalRecommend = powerRecommend
    if not powerRecommend then
        --所有地图的怪物战力都比不过的时候，显示在最低等级的地图上
        finalRecommend = minLevelMap
    else
        ---@type cfg_mapMove_column
        local mapMove = SL:GetConfig("cfg_mapMove", powerRecommend)
        local isMove = tempData[mapMove.mapID]
        if isMove and level < mapMove.level then
            finalRecommend = levelRecommend
        end
    end
    self.finalRecommend = finalRecommend
    self.selectItemIndex = finalRecommend
    if InfoManager.uiHookInfo.selectHookPointMapItem then
        self.selectItemIndex = InfoManager.uiHookInfo.selectHookPointMapItem
        self.nowClick = InfoManager.uiHookInfo.selectHookPointMapItem
    end
    GUI:DataListInitData(self.view.mapDataList,function()
        return self:MapDataListItemCountFunc()
    end,function(realIndex)
        return self:MapDataListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:MapDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:MapDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    self.mapItems = {}
    self.monsterItems = {}
    if self.args and self.args.monsterId then
        self:SelectToShowMonster(self.args.monsterId)
    end
end

function this:GuideToShowMonster(mapMoveId,monsterId)
    self.selectItemIndex = mapMoveId
    self.selectItemMonsterId = monsterId
    self:Refresh()
end
function this:SelectToShowMonster(monsterId)
    self.selectItemIndex = self:GetMoveIdByMonsterId(monsterId)
    self.selectItemMonsterId = monsterId
    self.isShowSelectEffect = true
end

function this:GetMoveIdByMonsterId(monsterId)
    local mapMoveId
    for mapId, data in pairs(self.cfgDatas) do
        for id, v in pairs(data) do
            if id == monsterId then
                return mapId
            end
        end
    end
    return mapMoveId
end

--地图
function this:MapDataListItemCountFunc()
    return #self.mapDatas
end

function this:MapDataListItemGetFunc(realIndex)
    local item = GUI:UIPanel_Open("dev/outui/Hook/Item/KLHookPointMap/KLHookPointMapItem",
            self.view.mapDataList, self, {}, true)
    self.mapItems[item.view.root] = item
    return item.view.root
end

function this:MapDataListItemInitFunc(realIndex, kmlcontrol)

end

function this:MapDataListItemUpdateFunc(realIndex, kmlcontrol)
    local index = realIndex + 1
    local data = self.mapDatas[index]
    self.mapItems[kmlcontrol]:SetData(data)
    if self.nowClick and data.mapMoveId == self.nowClick then
        self.mapItems[kmlcontrol]:SetOn()
        self.selectItem = self.mapItems[kmlcontrol]
        self.nowClick = data.mapMoveId
    end
    if data.mapMoveId == self.finalRecommend then
        self.mapItems[kmlcontrol]:SetIsRecommended()
    end
    if not self.first and data.mapMoveId == self.selectItemIndex then
        self.first = true
        --[[
                这里这么调用是因为该界面是通过事件创建的，RegistEvents在事件完成之前注册不上
                在面板里refreshUI刷新数据 抛LUA_EVENT_UI_HOOK_MAP_CLICK事件就会接收不到
                因此主动调用一下回调
            ]]
        self:LUA_EVENT_UI_HOOK_MAP_CLICK(_, {selectItem=self.mapItems[kmlcontrol],data=data})
    end
end

---注册UI事件和服务器消息
function this:RegistEvents()
    SL:RegisterLUAEvent(LUA_EVENT_UI_HOOK_MAP_CLICK, self.LUA_EVENT_UI_HOOK_MAP_CLICK, self)
end

--地图点击回调
function this:LUA_EVENT_UI_HOOK_MAP_CLICK(id, ItemData)
    if self.selectItem then
        self.selectItem:SetOff()
        self.selectItem = nil
    end
    self.selectItem = ItemData.selectItem
    self.selectItem:SetOn()
    local data = ItemData.data.mapMoveId
    self.nowClick = data
    InfoManager.uiHookInfo.selectHookPointMapItem = ItemData.data.mapMoveId
    ---@type cfg_mapMove_column
    local cfg = SL:GetConfig("cfg_mapMove", data)
    local level = SL:GetMetaValue(EMetaVarGetKey.LEVEL)
    level = 9999
    if level < cfg.level then
        SL:TipMessage(SL:GetConfig('cfg_string',272).text,1, NoticeType.NoticeLeftBottom)--"角色等级不足", 
    else
        self:Recycle()
        local datas = self.cfgDatas[data]
        if datas then
            --按照等级从小到大排序
            local tempList = table.keys(datas)
            table.sort(tempList, function(a, b)
                ---@type cfg_monster_column
                local cfgA = SL:GetConfig("cfg_monster", a)
                ---@type cfg_monster_column
                local cfgB = SL:GetConfig("cfg_monster", b)
                return cfgA.exp < cfgB.exp
            end)
            local index = 1
            for i, v in ipairs(tempList) do
                if self.selectItemMonsterId == v then
                    index = i
                end
                table.insert(self.monsterItems, GUI:UIPanel_Open("dev/outui/Hook/Item/KLHookPointMonster/KLHookPointMonsterItem", self.view.layout3,
                        self, {mapId = cfg.mapID, id = v, posData = datas[v], level = level}, true,function(item)  
                            GUI:SetID(item.view.Bg,tostring(v))
                            GUI:setName(item.view.Bg,tostring(v))
                            if self.isShowSelectEffect and v == self.selectItemMonsterId then
                                item:SetSelectEffect()
                                self.isShowSelectEffect = false
                            end
                        end))
            end
            if index-1 == #tempList -1 then
                GUI:SetScrollView_scrollpos(self.view.scrollview2, 1)
            else
                GUI:SetScrollView_scrollpos(self.view.scrollview2, (index-1)/#tempList)
            end
        end
    end
end

function this:Recycle()
    for _, v in pairs(self.monsterItems) do
        GUI:UIPanel_Close(_, v)
    end
    table.clear(self.monsterItems)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    self.nowClick = nil
    self.first = false
    if string.isNullOrEmpty(self.mapDatas)  then
        return
    end
    --刷新滚动列表 并跳转到指定项
    GUI:DataListUpdateData(self.view.mapDataList)
    local index = 0
    for k, v in pairs(self.mapDatas) do
        if v.mapMoveId == self.selectItemIndex then
            index = k
            break
        end
    end
    GUI:SetScrollView_scrollpos(self.view.mapScroll, index - 1)
    GUI:DataListUpdateData(self.view.mapDataList)
end

function this:Close()
    KLGuideManager.UiHide("KLOnHookPanel")
    SL:KeepOpenPanel("KLHookPointItemKml",false)
end

return this
