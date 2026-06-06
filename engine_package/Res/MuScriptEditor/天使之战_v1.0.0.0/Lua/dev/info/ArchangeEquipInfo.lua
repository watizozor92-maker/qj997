---@class ArchangeEquipInfo
---@field archangeInfo table<number,table> @大天使装备的信息
---@field angelSuitAction number[] @天赋大师激活的id
---@field angelTalenet table @天赋信息
---@field talentPoint number @天赋点信息
---@field canBreakthrough table @可突破的装备
---@field isInitBreakthrough boolean
---@field isMasterRed boolean @天赋大师红点
---@field archangeGrailInfo table @装备圣杯信息
---@field canGrailStrength table @可升级的圣杯
---@field decomposeSetting table<number,boolean> @分解筛选设置
ArchangeEquipInfo = class()
local this = ArchangeEquipInfo

function this:Init()
    --self.archangeEquip = {}

    self:RegistMessages()
    self:Reset()
end

function this:Reset()
    self.archangeGrailInfo = {}
    self.archangeInfo = {}
    if self.masterActionSchedule then
        SL:UnSchedule(self.masterActionSchedule)
        self.masterActionSchedule = nil
    end
    if self.timer then
        SL:UnSchedule(self.timer)
        self.timer = nil
    end
    self.talentPoint = 0
    self.angelTalenet = {}
    self.allGrailInfo = {}
    self.angelSuitAction = {}
    self.canBreakthrough = {}
    self.canGrailStrength = {}
    self.grailSuitList = {}
    self.canBtCount = {}
    self.isMasterRed = false
    self.isTalent = false
    self.isInitBreakthrough = false
    self.alreadyResetPoint = true
end

function this:RegistMessages()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_ALL_ANGEL_EQUIPMENT_ATTR_INFO, self.RES_ALL_ANGEL_EQUIPMENT_ATTR_INFO,
        self)                                                                                                          -- 响应所有天使装备成长属性信息
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_ANGEL_TALENT_ACTIVE_INFO, self.RES_ANGEL_TALENT_ACTIVE_INFO, self)   -- 响应天赋大师激活的id
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_ANGEL_EQUIPMENT_CAN_BREAK, self.RES_ANGEL_EQUIPMENT_CAN_BREAK, self) -- 响应天使装备可以突破
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_ANGEL_EQUIPMENT_ATTR_INFO, self.RES_ANGEL_EQUIPMENT_ATTR_INFO, self) -- 响应天使装备成长属性信息
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_DESTROY_ANGEL_EQUIPMENT, self.RES_DESTROY_ANGEL_EQUIPMENT, self)     -- 响应天使装备删除
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_ANGEL_TALENT_INFO, self.RES_ANGEL_TALENT_INFO, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_ALL_GRAIL_INFO, self.RES_ALL_GRAIL_INFO, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_GRAIL_ENTRY_INFO, self.RES_GRAIL_ENTRY_INFO, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_ANGEL_EQUIP_EXP_BOOST_INFO, self.RES_ANGEL_EQUIP_EXP_BOOST_INFO, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_EQUIP_OPT_ENTRY_INFO, self.RES_EQUIP_OPT_ENTRY_INFO, self)
    SL:RegisterLUAEvent(LUA_EVENT_BAG_CHANGE_AFTER, self.LUA_EVENT_BAG_CHANGE_AFTER, self)
    SL:RegisterLUAEvent(LUA_EVENT_MONEYCHANGE, self.LUA_EVENT_BAG_CHANGE_AFTER, self)
    SL:RegisterLUAEvent(LUA_EVENT_ENTER_MAP, self.LoginReq, self)
end

-- 响应所有天使装备信息
function this:RES_ALL_ANGEL_EQUIPMENT_ATTR_INFO(_, message)
    if message then
        if self.isInitBreakthrough then
            local messagePanel = GUI:GetUI("dev/outui/Message/Panel/KLHorseRaceLamp/KLHorseRaceLampPanel")
            if messagePanel then
                for i, v in pairs(message) do
                    if v.level ~= self.archangeInfo[tonumber(i)].level then
                        local equip = SL:GetWearEquipByItemId(tonumber(i))
                        if equip then
                            local itemTbl = SL:GetConfig("cfg_item", equip.cfgId, "id")
                            local color = SL:GetConfig("cfg_color", itemTbl.color, "id").color
                            local text = "<color=\"" .. color .. "\">" .. tostring(itemTbl.name) .. "</color>"
                            messagePanel:AddArchangelExp(v.level, text)
                        end
                    end
                end
            end
        end
        for i, v in pairs(message) do
            self.archangeInfo[tonumber(i)] = { level = v.level, rank = v.rank, exp = v.exp }
            self.archangeGrailInfo[tonumber(i)] = v.grails
        end

        if self.isInitBreakthrough == false then
            self.isInitBreakthrough = true
            local equip = SL:GetWearBarsData(9)
            for i, v in pairs(equip) do
                self:CanBreakthrough(v.id, v.cfgId)
            end

            if table.count(self.canBreakthrough) > 0 then
                SL:RefreshPanelALLRedPoint("KLUISystemLeftPanel")
            end
        end



        --self:RefreshGrailSuitInfo()
        --if self.masterActionSchedule then
        --    SL:UnSchedule(self.masterActionSchedule)
        --end
        --self.masterActionSchedule = SL:ScheduleOnce(0.1, function()
        --    self.isMasterRed = self:CanMasterAction()
        --    if self.isMasterRed then
        --        SL:RefreshPanelALLRedPoint("KLUISystemLeftPanel")
        --    end
        --end)
    end
end

-- 响应天赋大师激活的id
function this:RES_ANGEL_TALENT_ACTIVE_INFO(_, message)
    if message then
        for i, v in pairs(message) do
            table.insert(self.angelSuitAction, v)
        end
    end
    SL:onLUAEvent(LUA_ANGEL_TALENT_ACTIVE, self.angelSuitAction)
end

-- 响应天使装备可以突破
function this:RES_ANGEL_EQUIPMENT_CAN_BREAK(_, message)
    --SL:onLUAEvent(LUA_ANGEL_EQUIPMENT_CAN_BREAK)
    self:CanBreakthrough(message)
    SL:RefreshPanelALLRedPoint("KLUISystemLeftPanel")
end

-- 响应天使装备成长属性信息
function this:RES_ANGEL_EQUIPMENT_ATTR_INFO(_, message)
    if message then
        for i, v in pairs(message) do
            self.archangeInfo[tonumber(i)] = v
        end
    end
end

function this:RES_DESTROY_ANGEL_EQUIPMENT(_, message)
    if message then
        self.archangeInfo[tonumber(message)] = nil
    end
end

function this:RES_ANGEL_TALENT_INFO(_, message)
    if message then
        self.talentPoint = message.talentPoint
        self.angelTalenet = message.talentInfo
        self.alreadyResetPoint = message.alreadyResetPoint
    end
    self.isTalent = self:CanAddTalent()
    if self.isTalent then
        SL:RefreshPanelALLRedPoint("KLUISystemLeftPanel")
    end
end

---刷新圣杯套装 无参初始化
---@param cfgId number @变化圣杯道具id
---@param isPutOn boolean @nil 卸下
function this:RefreshGrailSuitInfo(cfgId, isPutOn)
    if not self.grailSuitList then
        self.grailSuitList = {}
    end
    if cfgId then
        ---@type cfg_equip_angelGrail_column
        local tbl = SL:GetConfig("cfg_equip_angelGrail", cfgId)
        if not self.grailSuitList[tbl.grailGrade] then
            self.grailSuitList[tbl.grailGrade] = {}
        end
        if not self.grailSuitList[tbl.grailGrade][tbl.grailQuality] then
            self.grailSuitList[tbl.grailGrade][tbl.grailQuality] = 0
        end
        if isPutOn then
            self.grailSuitList[tbl.grailGrade][tbl.grailQuality] = self.grailSuitList[tbl.grailGrade][tbl.grailQuality] +
                1
        else
            self.grailSuitList[tbl.grailGrade][tbl.grailQuality] = self.grailSuitList[tbl.grailGrade][tbl.grailQuality] -
                1
        end
    else
        self.grailSuitList = {}
        self.grailQualityCount = 4
        for _, v in pairs(self.allGrailInfo) do
            --for _, k in pairs(v) do
            if v.active then
                ---@type cfg_equip_angelGrail_column
                local tbl = SL:GetConfig("cfg_equip_angelGrail", v.itemConfigId)
                if not self.grailSuitList[tbl.grailGrade] then
                    self.grailSuitList[tbl.grailGrade] = {}
                end
                if not self.grailSuitList[tbl.grailGrade][tbl.grailQuality] then
                    self.grailSuitList[tbl.grailGrade][tbl.grailQuality] = 0
                end
                self.grailSuitList[tbl.grailGrade][tbl.grailQuality] = self.grailSuitList[tbl.grailGrade]
                    [tbl.grailQuality] + 1
            end
            --end
        end
    end
end

---刷新总圣杯属性
---@param info table @镶嵌卸下时发生变化的圣杯属性，缺省刷新全部
---@param isAdd boolean @true 镶嵌， false 卸下
function this:RefreshAllGrailAttrInfo()
    local grailAllAttrList = {}
    for _, info in pairs(self.allGrailInfo) do
        if info.active then
            for _, v in pairs(info.main) do
                if not grailAllAttrList[v.attrId] then
                    grailAllAttrList[v.attrId] = 0
                end
                grailAllAttrList[v.attrId] = grailAllAttrList[v.attrId] + v.value
            end
            for _, k in pairs(info.secondary) do
                for _, v in pairs(k) do
                    if not grailAllAttrList[v.attrId] then
                        grailAllAttrList[v.attrId] = 0
                    end
                    grailAllAttrList[v.attrId] = grailAllAttrList[v.attrId] + v.value
                end
            end
        end
    end
    return grailAllAttrList
end

function this:GetGrailGroupInfo(group)
    if self.grailSuitList then
        return self.grailSuitList[group]
    end
end

function this:GetGrailSuitCount(group, level)
    local count = 0
    if self.grailSuitList[group] then
        for i = 1, self.grailQualityCount do
            if self.grailSuitList[group][i] then
                if level <= i then
                    count = count + self.grailSuitList[group][i]
                end
            end
        end
    end
    return count
end

--- 获取装备的等级信息
---@param itemId number @装备的唯一ID
---@return table <string,number> @level = 等级, exp = 经验, rank=等阶
function this:GetEquipLevelInfo(itemId)
    if self.archangeInfo and self.archangeInfo[itemId] then
        return {
            level = self.archangeInfo[itemId].level,
            exp = self.archangeInfo[itemId].exp,
            rank = self.archangeInfo[itemId].rank,
        }
    end
    return nil
end

--- 获取  全身大天使装备的总等级
---@return number
function this:GetEquipTotalLevel()
    local total = 0
    local equip = SL:GetWearBarsData(9)
    for i, v in pairs(equip) do
        local level = self:GetEquipLevelInfo(v.id).level
        total = total + level
    end
    return total
end

---根据当前等阶获取等级上限
---@param rank number @当前等阶
---@param itemCfgId number @item配置表id
---@return number @等级上限
function this:GetMaxLevel(rank, itemCfgId)
    ---@type cfg_equip_angelAtt_column[]
    local tbl = SL:FindConfigs("cfg_equip_angelAtt", "angelGrade", rank)
    if tbl ~= nil and table.count(tbl) > 0 then
        return tbl[1].angelMaxLv
    end
    return 0
end

---根据当前配置id获取等阶上限
---@param itemCfgId number @item配置表id
---@return number @等阶
function this:GetMaxRank(itemCfgId)
    ---该装备所在的组
    local group = SL:GetConfig("cfg_equip_angelGroup", itemCfgId, "id").angelEquipGroup
    local basicAttTbl = SL:FindConfigs("cfg_equip_angelAtt", "ornamentsGroup", group)
    table.sort(basicAttTbl, function(a, b)
        return a.lv > b.lv
    end)
    return basicAttTbl[1].angelGrade
end

---判断大师天赋是否已激活
---@param cfgId number @表id
function this:IsMasterAction(cfgId)
    if self.angelSuitAction then
        return table.contains(self.angelSuitAction, cfgId)
    end
    return false
end

---获取某件装备的满级属性
---@param cfgId number @表id
---@return table,number @满级属性，满级时的等级
function this:GetMaxAtt(cfgId)
    ---该装备所在的组
    local group = SL:GetConfig("cfg_equip_angelGroup", cfgId, "id").angelEquipGroup
    local basicAttTbl = SL:FindConfigs("cfg_equip_angelAtt", "ornamentsGroup", group)
    table.sort(basicAttTbl, function(a, b)
        return a.lv > b.lv
    end)
    return basicAttTbl[1].basicAtt, basicAttTbl[1].lv
end

---是否拥有大天使装备
---@param itemId number @装备的唯一ID
function this:IsHaveArchangeEquip(itemId)
    if itemId and self.archangeInfo and self.archangeInfo[itemId] then
        return true
    end
    return false
end

--- 是否可以突破
--- @param itemId number @装备的唯一ID
--- @param cfgId number @装备配置id
--- @return boolean
function this:CanBreakthrough(itemId, cfgId)
    local info = self:GetEquipLevelInfo(itemId)
    if not itemId then
        return false
    end
    if not cfgId then
        local equip = SL:GetWearEquipByItemId(itemId)
        if not equip then
            return false
        end
        cfgId = equip.cfgId
    end
    if not info then
        return false
    end
    local level = info.level                    -- 装备当前等级
    local rank = info.rank                      -- 装备当前阶数
    local maxLv = self:GetMaxLevel(rank, cfgId) -- 装备当前阶数最大等级
    local maxRank = self:GetMaxRank(cfgId)

    if level == maxLv and rank ~= maxRank then
        local group = SL:GetConfig("cfg_equip_angelGroup", cfgId, "id").angelEquipGroup
        ---@type cfg_equip_angelAtt_column
        local tbl = SL:GetConfigTwoKeys("cfg_equip_angelAtt", info.level, group, "lv", "ornamentsGroup")
        for _, cost in pairs(tbl.breakMaterial) do
            if SL:GetBagItemCount(cost[1]) < cost[2] then
                if not table.contains(self.canBtCount, itemId) then
                    table.insert(self.canBtCount, itemId)
                end
                if table.contains(self.canBreakthrough, itemId) then
                    table.removeByValue(self.canBreakthrough, itemId)
                end
                return false
            end
        end
        if table.contains(self.canBtCount, itemId) then
            table.removeByValue(self.canBtCount, itemId)
        end
        if not table.contains(self.canBreakthrough, itemId) then
            table.insert(self.canBreakthrough, itemId)
        end
        return true
    end
    return false
end

--- 获取可以加点的天赋
function this:CanAddTalent()
    InfoManager.masterTalentInfo.RedDataList[EMasterTalentType.Archange] = false
    if self.talentPoint <= 0 then
        return false
    end
    local careerid = SL:GetConfig("cfg_career", SL:GetMetaValue(EMetaVarGetKey.ME_CAREER_TAB_COLUMN).id, "id")
        .baseCareer
    ---@type cfg_equip_angelTalentGroup_column[]
    local talentTypeList = SL:FindConfigs("cfg_equip_angelTalentGroup", "Career", careerid)
    local talentNum = {}
    for i, v in pairs(self.angelTalenet) do
        talentNum[i] = 0
        for _, talenet in pairs(v) do
            talentNum[i] = talenet + talentNum[i]
        end
    end
    ---遍历页签
    for i, v in pairs(talentTypeList) do
        ---@type cfg_equip_angelTalent_column[]
        local talentList = SL:FindConfigs("cfg_equip_angelTalent", "talentGroup", v.talentGroup)
        for _, talent in pairs(talentList) do
            if self.angelTalenet[v.talentGroup] and self.angelTalenet[v.talentGroup][talent.id] then
                --- 该天赋已加点
                if self.angelTalenet[v.talentGroup][talent.id] < talent.talentMaxLv then
                    --- 未达最大等级
                    --红点
                    InfoManager.masterTalentInfo.RedDataList[EMasterTalentType.Archange] = true
                    return true
                end
            else
                local num = talentNum[tostring(i)] and talentNum[tostring(i)] or 0
                if num >= talent.talentRequest then
                    --红点
                    InfoManager.masterTalentInfo.RedDataList[EMasterTalentType.Archange] = true
                    return true
                end
            end
        end
    end
    return false
end

--- 是否有可激活的大天使大师天赋
function this:CanMasterAction()
    if table.count(self.archangeInfo) == 0 then
        return false
    end
    local career = SL:GetMetaValue(EMetaVarGetKey.ME_CAREER_TAB_COLUMN)

    local equip = SL:GetWearBarsData(9)
    ---@type table @<组，装备等级[]>
    local equipGroup = {}
    for i, equipInfo in pairs(equip) do
        local suit = SL:GetConfig("cfg_equip_angelGroup", equipInfo.cfgId, "id").angelEquipSuit
        if not equipGroup[suit] then
            equipGroup[suit] = {}
        end
        table.insert(equipGroup[suit], InfoManager.archangeEquipInfo:GetEquipLevelInfo(equipInfo.id).level)
    end
    --- 给同组的排序
    for _, equipGroupInfo in pairs(equipGroup) do
        table.sort(equipGroupInfo)
    end
    ---@type cfg_equip_angelSuit_column[]
    local data = SL:FindConfigs("cfg_equip_angelSuit", "type", 2)
    for _, v in pairs(data) do
        local cfgId = v.id
        local actionCount = 0
        if v.career == career.baseCareer and not self:IsMasterAction(v.id) then
            ---@type cfg_equip_angelSuit_column
            local tbl = SL:GetConfig("cfg_equip_angelSuit", cfgId, "id")

            local angelLv = table.copy(tbl.angelLv)
            --- 循环判断条件
            for i, lvInfo in pairs(angelLv) do
                if equipGroup[lvInfo[1]] then
                    --- 找到改组中符合条件的最小的移除
                    --- 同时符合条件的件数+1
                    local count = 0
                    local num = 1
                    local isEnough = false
                    while num <= #equipGroup[lvInfo[1]] do
                        if equipGroup[lvInfo[1]][num] >= lvInfo[3] then
                            table.remove(equipGroup[lvInfo[1]], num)
                            actionCount = actionCount + 1
                            count = count + 1
                            if count == lvInfo[2] then
                                isEnough = true
                                break
                            end
                        else
                            num = num + 1
                        end
                    end
                    if not isEnough then
                        break
                    end
                end
            end
            if actionCount == v.wearingCount then
                self.isMasterRed = true
                return
            end
        end
    end
    self.isMasterRed = false
end

function this:LoginReq()
    if self.timer then
        SL:UnSchedule(self.timer)
        self.timer = nil
    end
    -- self.timer = SL:ScheduleOnce(2, function()
    --     SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_REMAINING_ANGE_GRAIL_INFO)
    -- end)
    self:GetLocalSetting()
    
end

function this:LUA_EVENT_BAG_CHANGE_AFTER(_, message)
    self:CanStrengthGrail()
    if table.count(self.canBtCount) == 0 then
        return
    end
    local equips = SL:GetWearBarsData(9)
    for i, v in pairs(equips) do
        self:CanBreakthrough(v.id, v.cfgId)
    end
end

------------------------------------圣杯----------------------------------------
---

function this:RES_ALL_GRAIL_INFO(_, message)
    for i, v in pairs(message) do
        self.allGrailInfo[tonumber(i)] = v
    end
    self:CanStrengthGrail()
    self:RefreshGrailSuitInfo()
end

function this:RES_GRAIL_ENTRY_INFO(_, message)
    for i, v in pairs(message) do
        self.allGrailInfo[tonumber(i)] = v
    end
    SL:onLUAEvent(LUA_EVENT_GRAIL_INFO_CHANGE)
end

function this:RES_EQUIP_OPT_ENTRY_INFO(_, message)
    if message then
        for i, v in pairs(message.res) do
            self:RefreshGrailSuitInfo(v.itemConfigId, message.opt == 1)
            self.allGrailInfo[tonumber(i)] = v.attrInfo
        end
    end
end

---改变装备上的圣杯
---@param equipId number @装备唯一id
---@param grailPos number @圣杯位置
---@param grailCfgId number @圣杯配置id
---@param grailId number @圣杯唯一id 缺省则为卸下
function this:GrailChange(equipId, grailPos, grailCfgId, grailId)
    if self.archangeGrailInfo[equipId] then
        local index = -1
        for i, v in pairs(self.archangeGrailInfo[equipId]) do
            if v.grailPosition == grailPos then
                index = i
                self:GrailInfoChange(tonumber(i))
                break
            end
        end
        ---刷新圣杯套装
        local cfgId
        if not grailCfgId then
            cfgId = self.archangeGrailInfo[equipId][index].itemConfigId
        else
            cfgId = grailCfgId
        end
        self:RefreshGrailSuitInfo(cfgId, grailId)

        self.archangeGrailInfo[equipId][index] = nil

        if grailId then
            self.archangeGrailInfo[equipId][grailId] = { grailPosition = grailPos, itemConfigId = grailCfgId }
        end
    else
        if grailId then
            self.archangeGrailInfo[equipId] = {}
            self.archangeGrailInfo[equipId][grailId] = { grailPosition = grailPos, itemConfigId = grailCfgId }
            self:RefreshGrailSuitInfo(grailCfgId, grailId)
        end
    end
    self:CanStrengthGrail()
end

---进入背包和从背包种移除，移除存储中的圣杯(后端唯一id会变，导致内存泄露)
---@param grailId number @圣杯唯一id
function this:GrailInfoChange(grailId, data)
    if self.allGrailInfo[grailId] and not data then
        self.allGrailInfo[grailId] = nil
    elseif self.allGrailInfo[grailId] and data then
        self.allGrailInfo[grailId] = data.attrInfo
    end
end

---获取大天使装备上的圣杯
---@param itemId @装备的唯一ID
function this:GetEquipGrail(itemId)
    if not itemId or not self.archangeGrailInfo[itemId] then
        return {}
    end
    return self.archangeGrailInfo[itemId]
end

---获取圣杯的信息
---@param itemId number @装备唯一id
function this:GetGrailInfo(itemId)
    if itemId then
        if self.allGrailInfo and self.allGrailInfo[itemId] then
            return self.allGrailInfo[itemId]
        end
    end
    return nil
end

function this:GetGrailStrengthLv(grailId)
    local info = self:GetGrailInfo(grailId)
    if info then
        return info.level
    end
    return 0
end

function this:GetGrailMaxStrengthLv(cfgId)
    local strengthenTbl = SL:GetConfig("cfg_equip_angelStrengthen", cfgId, "id")
    if not strengthenTbl then
        return nil
    end
    local strengthenInfo = SL:GetConfigTwoKeys("cfg_equip_angelStrengthenCost", strengthenTbl.costGroup, 0,
        "AngelstrengthenGroup", "AngelstrengthenSuccessRate")
    if not strengthenInfo then
        return nil
    end
    return strengthenInfo.AngelstrengthenLv
end

function this:CanStrengthGrail()
    for i, v in pairs(self.archangeGrailInfo) do
        if #v == 0 and self.canGrailStrength[i] then
            self.canGrailStrength[i] = nil
        end
        for grailId, grailInfo in pairs(v) do
            local info = self:GetGrailInfo(tonumber(grailId))
            if info and info.level < self:GetGrailMaxStrengthLv(grailInfo.itemConfigId) and not self:IsGrailEntryMax(info) then
                local strengthenTbl = SL:GetConfig("cfg_equip_angelStrengthen", grailInfo.itemConfigId, "id")
                local costTbl = SL:GetConfigTwoKeys("cfg_equip_angelStrengthenCost", strengthenTbl.costGroup, info.level,
                    "AngelstrengthenGroup", "AngelstrengthenLv")
                local isEnough = true
                for _, cost in pairs(costTbl.Angelstrengthencost) do
                    if SL:GetBagItemCount(cost[1]) < cost[2] then
                        isEnough = false
                        break
                    end
                end
                if isEnough then
                    -- 足够
                    if not self.canGrailStrength[i] then
                        self.canGrailStrength[i] = {}
                    end
                    table.insert(self.canGrailStrength[i], grailInfo.grailPosition)
                else
                    if self.canGrailStrength[i] then
                        table.removeByValue(self.canGrailStrength[i], grailInfo.grailPosition)
                        if table.count(self.canGrailStrength[i]) == 0 then
                            self.canGrailStrength[i] = nil
                        end
                    end
                end
            end
        end
    end
    if table.count(self.canGrailStrength) > 0 then
        --- 刷新红点
        SL:RefreshPanelALLRedPoint("KLUISystemLeftPanel")
    end
end

function this:IsGrailEntryMax(grailInfo)
    for i, v in pairs(grailInfo.main) do
        if v.isMax == false then
            return false
        end
    end

    for i, v in pairs(grailInfo.secondary) do
        for _, j in pairs(v) do
            if j.isMax == false then
                return false
            end
        end
    end
    return true
end

function this:CanEquipHaveStrengthenGrail(itemId)
    if self.canGrailStrength[itemId] then
        return true
    else
        return false
    end
end

function this:CanEquipHaveGrail(itemId)
    if table.contains(self.equipRed, itemId) then
        return true
    else
        return false
    end
end

function this:CheckEquipRed()
    self.equipRed = {}
    local info = SL:GetWearBarsData(EEquipWearBarType.Archange)
    for i, v in pairs(info) do
        local item = v
        local id = v.id
        --- 判断空的孔
        local equipInfo = self:GetEquipLevelInfo(id)
        local hole, max = self:GetHole(equipInfo.rank, item.cfgId)
        for num = 1, hole do
            local isHave = false
            if self.archangeGrailInfo[id] then
                for _, j in pairs(self.archangeGrailInfo[id]) do
                    if j.grailPosition == num then
                        isHave = true
                        break
                    end
                end
            end
            if not isHave then
                local bagTbl = self:GetBagItem(num, i)
                if #bagTbl > 0 then
                    table.insert(self.equipRed, id)
                end
            end
        end
    end
end

--- 筛选背包物品
function this:GetBagItem(holeIndex, pos)
    local data = {}
    local bagItemTabl = SL:GetMetaValue("BAG_DATA")[1]
    if bagItemTabl then
        for _, v in pairs(bagItemTabl) do
            local tbl = nil
            if SL:HasConfig("cfg_equip_angelGrail", v.cfgId, "id") then
                tbl = SL:GetConfig("cfg_equip_angelGrail", v.cfgId, "id")
            end
            if pos then
                if tbl and table.contains(tbl.gradePosition, holeIndex) and table.contains(tbl.strPart, pos) then
                    table.insert(data, v)
                end
            else
                if tbl and table.contains(tbl.gradePosition, holeIndex) then
                    table.insert(data, v)
                end
            end
        end
    end
    return data
end

---@return number,number 解锁的孔位，总孔位
function this:GetHole(rank, cfgId)
    if not cfgId then
        return 0, 0
    end
    ---@type cfg_equip_angelGroup_column
    local tbl = SL:GetConfig("cfg_equip_angelGroup", cfgId, "id")
    if not rank or rank == 0 then
        return 0, table.count(tbl.grailOpen)
    end
    local grailOpen = table.copy(tbl.grailOpen)
    table.sort(grailOpen, function(a, b)
        return a[1] < b[1]
    end)
    --local rankIndex = 1
    for i, v in pairs(grailOpen) do
        if v[1] > rank then
            return grailOpen[i - 1][2], table.count(grailOpen)
        end
        if v[1] == rank then
            return grailOpen[i][2], table.count(grailOpen)
        end
    end
    return 0, table.count(grailOpen)
end

----------------------buff----------------
-- 响应经验加成buff
function this:RES_ANGEL_EQUIP_EXP_BOOST_INFO(_, message)
    local data
    if message then
        for i, v in pairs(message) do
            local fuffData
            if table.isNullOrEmpty(v) then
                local myId = SL:GetMetaValue("MAIN_ACTOR_ID")
                local buff_id = tonumber(i)
                local bufftbl = SL:GetConfig("cfg_buff", buff_id)
                local _buffText = bufftbl.buffText
                local time = -1
                fuffData = {
                    updateType = 1,
                    buff = { buffTbl = bufftbl, cfgId = buff_id, endTime = time, buffText = _buffText },
                    roleId =
                        myId
                }
            else
                local myId = SL:GetMetaValue("MAIN_ACTOR_ID")
                local buff_id = tonumber(i)
                local bufftbl = SL:GetConfig("cfg_buff", buff_id)
                local _buffText = bufftbl.buffText
                local time = v.delayTime
                fuffData = {
                    updateType = 0,
                    buff = { buffTbl = bufftbl, cfgId = buff_id, endTime = time, buffText = _buffText },
                    roleId =
                        myId
                }
            end

            SL:onLUAEvent(LUA_EVENT_BUFFCHANHE, fuffData)
        end
    end
end

function this:SetOtherGrailInfo(grailInfo)
    for i, v in pairs(grailInfo) do
        self:RefreshOtherAllGrailAttrInfo(v)
    end
    self:RefreshOtherGrailSuitInfo(grailInfo)
end

---刷新总圣杯属性
---@param info table @镶嵌卸下时发生变化的圣杯属性，缺省刷新全部
---@param isAdd boolean @true 镶嵌， false 卸下
function this:RefreshOtherAllGrailAttrInfo(info, isAdd)
    if not self.otherGrailAllAttrList then
        self.otherGrailAllAttrList = {}
    end

    if not info.inlaid then
        ---未穿戴返回
        return
    end
    for _, v in pairs(info.main) do
        if not self.otherGrailAllAttrList[v.attrId] then
            self.otherGrailAllAttrList[v.attrId] = 0
        end
        self.otherGrailAllAttrList[v.attrId] = self.otherGrailAllAttrList[v.attrId] + v.value
    end
    for _, k in pairs(info.secondary) do
        for _, v in pairs(k) do
            if not self.otherGrailAllAttrList[v.attrId] then
                self.otherGrailAllAttrList[v.attrId] = 0
            end
            self.otherGrailAllAttrList[v.attrId] = self.otherGrailAllAttrList[v.attrId] + v.value
        end
    end
end

---刷新圣杯套装 无参初始化
---@param cfgId number @变化圣杯道具id
---@param isPutOn boolean @nil 卸下
function this:RefreshOtherGrailSuitInfo(grailInfo)
    self.otherGrailSuitList = {}
    for _, v in pairs(grailInfo) do
        ---@type cfg_equip_angelGrail_column
        local tbl = SL:GetConfig("cfg_equip_angelGrail", v.itemConfigId)
        if not self.otherGrailSuitList[tbl.grailGrade] then
            self.otherGrailSuitList[tbl.grailGrade] = {}
        end
        if not self.otherGrailSuitList[tbl.grailGrade][tbl.grailQuality] then
            self.otherGrailSuitList[tbl.grailGrade][tbl.grailQuality] = 0
        end
        self.otherGrailSuitList[tbl.grailGrade][tbl.grailQuality] = self.otherGrailSuitList[tbl.grailGrade]
            [tbl.grailQuality] + 1
    end
end

function this:GetOtherGrailSuitCount(group, level)
    local count = 0
    if self.otherGrailSuitList[group] then
        for i = 1, self.grailQualityCount do
            if self.otherGrailSuitList[group][i] then
                if level <= i then
                    count = count + self.otherGrailSuitList[group][i]
                end
            end
        end
    end
    return count
end

function this:ResetOtherInfo()
    self.otherGrailSuitList = {}
    self.otherGrailAllAttrList = {}
end

-----------分解筛选-----------
---分解设置
---@param grailQualitys table @圣杯品质列表
---@param isSelect boolean @true 选中， false 取消选中
function this:SetDecomposeSetting(grailQualitys, isSelect)
    if not table.isNullOrEmpty(grailQualitys) then
        for k, v in pairs(grailQualitys) do
            self.decomposeSetting[tonumber(v)] = isSelect
        end
    end
    SL:onLUAEvent(LUA_EVENT_GRAIL_DECOMPOSE_SETTING_CHANGE)
end
---分解设置保存
function this:SaveDecomposeSetting()
    local setting = SL:JsonEncode(self.decomposeSetting)
    local id = SL:MeData_GetId()
    SL:SetLocalString("grail_decompose_setting" .. tostring(id), setting)
end

function this:GetLocalSetting()
    self.decomposeSetting = {}
    local id = SL:MeData_GetId()
    local setting = SL:GetLocalString("grail_decompose_setting" .. tostring(id))
    if not string.isNullOrEmpty(setting) then
        local settingData = SL:JsonDecode(setting)
        for k, v in pairs(settingData) do
            self.decomposeSetting[tonumber(k)] = v
        end
        
    end
end

function this:GetDecomposeSetting(grailQuality)
    if table.isNullOrEmpty(self.decomposeSetting) or self.decomposeSetting[grailQuality] == nil then
        return true -- 默认开启
    else
        return self.decomposeSetting[grailQuality]
    end
end

