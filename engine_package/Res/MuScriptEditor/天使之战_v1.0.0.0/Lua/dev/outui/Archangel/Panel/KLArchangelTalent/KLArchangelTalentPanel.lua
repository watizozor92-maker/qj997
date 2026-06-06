---@class KLArchangelTalentPanel:UIKmlLuaPanelBase
---@field view KLArchangelTalentPanelView
---@field careerid number @当前角色的根职业
---@field talentTypeList cfg_equip_angelTalentGroup_column[]
---@field angelTalentList table<number,cfg_equip_angelTalent_column[]> @cfg_equip_angelTalent_column额外带当前等级
---@field angelTalentItem KLTalentItem[]
---@field nameItemList KLTalentNameItem[]
---@field masterRed
local KLArchangelTalentPanel = class(UIKmlLuaPanelBase)
local this = KLArchangelTalentPanel
function this:AsyncLoadUI()
end
---创建时调用一次
function this:Init()
    self.angelTalentItem = {}
    self.nameItemList = {}
    self.alreadyIncrementId = -1
    self.careerid = SL:GetConfig("cfg_career", SL:GetMetaValue(EMetaVarGetKey.ME_CAREER_TAB_COLUMN).id, "id").baseCareer
    self.talentTypeList = SL:FindConfigs("cfg_equip_angelTalentGroup", "Career", self.careerid)

    GUI:DataListInitData(self.view.talentName_data, function()
        return #self.talentTypeList
    end, function(realIndex)
        return self:TalentNameGetItem(realIndex)
    end, function(realIndex, kmlcontrol)
        --return self:DataListItemInit(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:TalentNameUpdateItem(realIndex, kmlcontrol)
    end)

    GUI:DataListInitData(self.view.talent_data, function()
        return #self.angelTalentList
    end, function(realIndex)
        return self:DataListGetItem(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:DataListItemInit(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:DataUpdateItem(realIndex, kmlcontrol)
    end)

    InfoManager.archangeEquipInfo:CanMasterAction()

end

function this:DataListGetItem(realIndex)
    ---@type KLTalentItem
    local item = GUI:UIPanel_Open("dev/outui/Archangel/Item/KLTalent/KLTalentItem", self.view.talent_data, self, _, true,function(item)

        item:UpdateUI(self.angelTalentList[realIndex + 1])
    end)
    self.angelTalentItem[realIndex + 1] = item --realIndex做索引，滑动列表的时候可能会有问题
    return item.view.root
end
function this:DataListItemInit(realIndex, kmlcontrol)

end
function this:DataUpdateItem(realIndex, kmlcontrol)
    --local data=self.angelTalentList[realIndex+1]
    if not GUI:IsUILoading(self.angelTalentItem[realIndex + 1]) then
        self.angelTalentItem[realIndex + 1]:UpdateUI(self.angelTalentList[realIndex + 1])
    end

end

function this:TalentNameGetItem(realIndex)
    ---@type KLTalentNameItem
    local item = GUI:UIPanel_Open("dev/outui/Archangel/Item/KLTalentName/KLTalentNameItem", self.view.talentName_data, self, _, true)
    self.nameItemList[realIndex + 1] = item
    
    return item.view.root
end

function this:TalentNameUpdateItem(realIndex, kmlcontrol)
    self.nameItemList[realIndex + 1]:UpdateUI(self.talentTypeList[realIndex + 1],self.talentGroup)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.reset_talent, self, self.ResetTalentPanel)
    GUI:AddOnClickEvent(self.view.tip_mask, self, self.ClostTip)
    GUI:AddOnClickEvent(self.view.tip_cancel, self, self.ClostTip)
    GUI:AddOnClickEvent(self.view.tip_sure, self, self.ResetTalent)
    GUI:AddOnClickEvent(self.view.talent_master, self, self.TalentMaster)
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, self.LUA_EVENT_CLOSEWIN, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_ANGEL_TALENT_INFO, self.RES_ANGEL_TALENT_INFO, self)
end
---界面显示时调用一次
function this:Show()

end
---创建或者刷新界面数据时调用
function this:Refresh()
    self.talentGroup = nil

    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_ANGEL_TALENT)
    if not InfoManager.archangeEquipInfo.isMasterRed then
        if self.masterRed then
            GUI:setVisible(self.masterRed, false)
        end
        return
    end
    if not self.masterRed then
        self.masterRed = GUI:Image_Create(self.view.talent_master, {
            atlas = "Atlas/Common.spriteatlas",
            src = "bg_gemred",
            width = "20",
            height = "20",
            a = "21",
            x = "0",
            y = "8",
            z = "-500",
        })
    else
        GUI:setVisible(self.masterRed, true)
    end
end

function this:LoadTalent(talentGroup)
    self.talentGroup = talentGroup
    --self.angelTalenet = InfoManager.archangeEquipInfo:GetTalent(talentGroup)
    self.angelTalentList = {}
    ---@type cfg_equip_angelTalent_column[]
    local data = SL:FindConfigs("cfg_equip_angelTalent", "talentGroup", talentGroup)
    table.sort(data, function(a, b)
        return a.talent < b.talent
    end)

    for _, v in pairs(self.nameItemList) do
        v:Select(talentGroup)
    end
    local num = 0
    for i, v in pairs(data) do
        if num < v.talent then
            num = v.talent
        end
        if not self.angelTalentList[v.talent] then
            self.angelTalentList[v.talent] = {}
        end
        v.curlv = 0
        if self.angelTalenet and self.angelTalenet[tostring(v.talentGroup)] and self.angelTalenet[tostring(v.talentGroup)][tostring(v.id)] then
            v.curlv = self.angelTalenet[tostring(v.talentGroup)][tostring(v.id)]
        end
        table.insert(self.angelTalentList[v.talent], v)
    end
    for i = 1, num do
        if not self.angelTalentList[i] then
            self.angelTalentList[i] = {}
        end
    end
    GUI:DataListUpdateData(self.view.talent_data)
    self:GetTalentGroupCostPoint()
end

function this:ResetTalentPanel()
    GUI:setVisible(self.view.tip, true)
    if InfoManager.archangeEquipInfo.alreadyResetPoint then
        GUI:setVisible(self.view.cost_item, true)
        GUI:setPositionX(self.view.cost_text, 0)
        local costStr = SL:GetConfig("cfg_global", 22001, "id").value
        local cost = string.split(costStr, "#")
        GUI:Item_setItemId(self.view.cost_item, cost[1])
        local bagCount = SL:GetBagItemCount(tonumber(cost[1]))
        if bagCount >= tonumber(cost[2]) then
            GUI:Text_setTextColor(self.view.cost_text, "#FFFFFF")
        else
            GUI:Text_setTextColor(self.view.cost_text, "#ff2323")
        end
        GUI:Text_setString(self.view.cost_text, cost[2])
    else
        GUI:setVisible(self.view.cost_item, false)
        GUI:setPositionX(self.view.cost_text, -20)
        GUI:Text_setString(self.view.cost_text, "本次免费")
    end
end

function this:ResetTalent()
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_RESET_ANGEL_TALENT_POINT)
    GUI:setVisible(self.view.tip, false)
end

---在KLTalentNameItem中调用
function this:ChangeBG(src)
    ---@type KLUIMasterTalentMainPanel
    local talentMain = GUI:GetUI("dev/outui/MasterTalent/Panel/KLUIMasterTalentMain/KLUIMasterTalentMainPanel")
    if talentMain then
        talentMain:BGChange(src, "")
    end
end

function this:SetLoadingbar()
    local level = InfoManager.archangeEquipInfo:GetEquipTotalLevel()
    GUI:Text_setString(self.view.total_level_text, tostring(level))
    ---@type cfg_equip_angelSuit_column[]
    local tbl = SL:FindConfigs("cfg_equip_angelSuit", "type", 1)
    table.sort(tbl, function(a, b)
        return a.angelLv[1][1] < b.angelLv[1][1]
    end)
    local nextLevel = -1
    local talentNum = 0
    local career = SL:GetMetaValue(EMetaVarGetKey.ME_CAREER_TAB_COLUMN)
    local lastId = -1
    if self.alreadyIncrementId > 0 then
        for i, v in pairs(tbl) do
            if v.career == career.baseCareer then
                if v.angelLv[1][1] > level and lastId == self.alreadyIncrementId then
                    nextLevel = v.angelLv[1][1]
                    talentNum = v.Count
                    break
                end
                lastId = v.id
            end

        end
    else
        for i, v in pairs(tbl) do
            if v.career == career.baseCareer and v.angelLv[1][1] > level and lastId == self.alreadyIncrementId then
                nextLevel = v.angelLv[1][1]
                talentNum = v.Count
                break
            end
        end
    end

    if nextLevel <= 0 then
        GUI:SetLoadingbar_startper(self.view.loadingbar_lv, 100)
        GUI:Text_setString(self.view.exp_info_text, "天赋等级已满")
    else
        GUI:SetLoadingbar_startper(self.view.loadingbar_lv, level / nextLevel * 100)
        GUI:Text_setString(self.view.exp_info_text, "<color='#00ff00'>" .. tostring(level) .. "</color>/" .. tostring(nextLevel) .. "   距离下次获得<color='#00ff00'>" .. tostring(talentNum) .. "</color>天赋点还差<color='#00ff00'>" .. tostring(nextLevel - level) .. "</color>级")
    end

end

-- 响应天使天赋信息
function this:RES_ANGEL_TALENT_INFO(_, message)
    local talentPoint = message.talentPoint and message.talentPoint or 0
    self.angelTalenet = message.talentInfo
    if message.alreadyIncrementId then
        self.alreadyIncrementId = message.alreadyIncrementId
    end
    GUI:Text_setString(self.view.talent_num, tostring(talentPoint))
    --local costNum = message.allTalentPoint - self.talentPoint
    --GUI:Text_setString(self.view.talent_cost_num, tostring(costNum))
    GUI:DataListUpdateData(self.view.talentName_data)
    if self.talentGroup == nil then
        self.talentGroup = self.talentTypeList[1].talentGroup
    end
    self:LoadTalent(self.talentGroup)
    self:SetLoadingbar()
end

function this:GetTalentGroupCostPoint(group)
    group = group or self.talentGroup
    local num = 0
    if self.angelTalenet and self.angelTalenet[tostring(group)] then
        for i, v in pairs(self.angelTalenet[tostring(group)]) do
            local tbl = SL:FindConfigs("cfg_equip_angelTalentLv", "talentId", tonumber(i))
            table.sort(tbl, function(a, b)
                return a.level < b.level
            end)
            for j, k in ipairs(tbl) do
                if k.level <= v then
                    num = num + k.consumPoint
                end
            end
        end
    end
    GUI:Text_setString(self.view.talent_cost_num, tostring(num))
end

function this:LUA_EVENT_CLOSEWIN(_, message)
    if message == "KLArchangelMasterPanelKml" then
        if not InfoManager.archangeEquipInfo.isMasterRed then
            if self.masterRed then
                GUI:setVisible(self.masterRed, false)
            end
            return
        end
    end
end

function this:ClostTip()
    GUI:setVisible(self.view.tip, false)
end

function this:TalentMaster()
    GUI:UIPanel_Open("dev/outui/Archangel/Panel/KLArchangelMaster/KLArchangelMasterPanel")
end

function this:Close()
    SL:RefreshPanelALLRedPoint("KLUISystemLeftPanel")
end

return this
