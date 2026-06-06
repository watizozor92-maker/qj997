---@class KLChallengeBossSanctuaryMapPanel:UIKmlLuaPanelBase
---@field view KLChallengeBossSanctuaryMapPanelView
---@field itemList KLChallengeBossSanctuaryMapItem[]
---@field monsterMap cfg_mapMove_column[]
local KLChallengeBossSanctuaryMapPanel = class(UIKmlLuaPanelBase)
local this = KLChallengeBossSanctuaryMapPanel
function this:AsyncLoadUI()
end
---创建时调用一次
function this:Init()
    self.itemList = {}
    GUI:DataListInitData(self.view.dataList, function()
        return self:DataListItemCountFunc()
    end, function(realIndex)
        return self:DataListItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:DataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:DataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btnClose, self, self.BtnCloseOnClick)
    GUI:AddOnClickEvent(self.view.btnEnter, self, self.BtnEnterOnClick)
end

----关闭界面
function this:BtnCloseOnClick()
    GUI:UIPanel_Close("dev/outui/ChallengeBoss/Panel/KLChallengeBossSanctuaryMap/KLChallengeBossSanctuaryMapPanel")
end

function this:BtnEnterOnClick()
    if not self.selectItem then
        SL:TipMessage("请选中一个地图", 1, NoticeType.NoticeMid)
        return
    end
    if not self.selectItem.isLevel then
        SL:TipMessage("等级不足", 1, NoticeType.NoticeMid)
        return
    end
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_SANCTUARY_BOSS_ENTER_MAP, self.selectItem.data.id)

end

---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
    SL:HideMainPanel()
    self:InitMonsterMapData()
    GUI:DataListUpdateData(self.view.dataList)
end

function this:InitMonsterMapData()
    self.monsterMap = {}
    local tempTable = {}
    ----@type cfg_BOSS_challenge_column[]
    local boosCfgTable = SL:GetConfigTable("cfg_BOSS_challenge")
    for k, v in pairs(boosCfgTable) do
        if v.monsterType == EBossChallengeType.Sanctuary then
            ---圣域BOSS都在单独的图里
            ---@type cfg_mapMove_column
            local mapCfg = SL:GetConfig("cfg_mapMove", v.mapMoveId[1][1])
            tempTable[mapCfg.id] = mapCfg
        end
    end
    for k, v in pairs(tempTable) do
        table.insert(self.monsterMap, v)
    end
    ---@param a cfg_mapMove_column
    ---@param b cfg_mapMove_column
    table.sort(self.monsterMap, function(a, b)
        if a.level < b.level then
            return true
        end
        return false
    end)
end

function this:Hide()
end

function this:DataListItemCountFunc()
    return table.count(self.monsterMap)
end

function this:DataListItemGetFunc(realIndex)
    ---@type KLChallengeBossSanctuaryMapItem
    local tempItem = GUI:UIPanel_Open("dev/outui/ChallengeBoss/Item/KLChallengeBossSanctuaryMap/KLChallengeBossSanctuaryMapItem", self.view.dataList, self, nil, true)
    
    self.itemList[tempItem.view.root] = tempItem
    return tempItem.view.root
end

---@param kmlcontrol UIKmlLuaControl
function this:DataListItemInitFunc(realIndex, kmlcontrol)

end

function this:DataListItemUpdateFunc(realIndex, kmlcontrol)
    self.itemList[kmlcontrol]:InitData(realIndex + 1, self.monsterMap[realIndex + 1], self)
    self.itemList[kmlcontrol]:RefreshUI()
    ---其他地方跳转过来的的显示选中
    if self.args or InfoManager.sanctuaryBossInfo.sanctuaryMapId then
        local mapId = self.args or InfoManager.sanctuaryBossInfo.sanctuaryMapId
        if self.monsterMap[realIndex + 1].mapID == mapId then
            self.itemList[kmlcontrol]:SetSelected(true)

            self.args = nil
            InfoManager.sanctuaryBossInfo.sanctuaryMapId = nil
            self.selectItem = self.itemList[kmlcontrol]
        end
    end
end

---@param item KLChallengeBossSanctuaryMapItem
function this:ItemSelectOnClick(item)
    item:SetSelected(not item.isSelected)
    if self.selectItem and item.index ~= self.selectItem.index then
        self.selectItem:SetSelected(false)
    end
    if not item.isSelected then
        self.selectItem = nil
    else
        self.selectItem = item
    end
end

function this:Close()
    InfoManager.sanctuaryBossInfo.sanctuaryNpcId = nil
    SL:ShowMainPanel()
end

return this
