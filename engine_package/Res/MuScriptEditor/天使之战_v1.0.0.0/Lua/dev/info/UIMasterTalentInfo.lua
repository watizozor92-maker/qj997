---@class UIMasterTalentInfo @注释
---@field FactionsCfg table<number,cfg_master_ui_column>
UIMasterTalentInfo = class()
local this = UIMasterTalentInfo

function this:ctor()

end

function this:Init()
    self:Reset()
    self:InitData()
    self:RegistMessages()
end

function this:InitData()
    local lockStr = SL:GetConfig("cfg_global", 4016).value
    local locktbl = string.split(lockStr, "#")
    self.lockSeries = {}
    for k, v in pairs(locktbl) do
        self.lockSeries[k] = tonumber(v)
    end
end

function this:RegistMessages()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_MASTER_RED_DOT_INFO, self.RES_MASTER_RED_DOT_INFO, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_MASTER_INFO, self.RES_MASTER_INFO, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_MASTER_CHANGE_INFO, self.RES_MASTER_CHANGE_INFO, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_OPEN_MASTER_TYPE, self.RES_OPEN_MASTER_TYPE, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_EXCHANGE_MASTER_EXP, self.RES_EXCHANGE_MASTER_EXP, self)
    SL:RegisterLUAEvent(LUA_EVENT_LEVELCHANGE, self.LUA_EVENT_LEVELCHANGE, self) --主角等级改变事件
end

function this:LUA_EVENT_LEVELCHANGE()
    SL:RefreshPanelALLRedPoint("KLUISystemLeftPanel")
end

---响应：启用大师系列   回 ： type  series：选中启用的系列
function this:RES_OPEN_MASTER_TYPE(id, message)
    if message then
        local type = tonumber(message["type"])
        self.TalentSeriesList[type] = tonumber(message["series"])
    end
end

---响应：大师信息
---{type = 类型,
---series = 系列,
---points = 天赋点数,
---exchangedExpTimes = 已兑换次数,
---level = 等级,
---exp= 当前经验,
---isFree = 是否免费,
---talent = 天赋信息有多个{{id = 配置id, level， series系列}，{id = 配置id, level， series系列}}}
function this:RES_MASTER_INFO(id, message)
    if message then
        -- local type = tonumber(message["type"])
        -- self.TalentSeriesList[type] = tonumber(message["series"])
        -- if self.TalentDatalist[type] then
        --     self.TalentDatalist[type] = {}
        -- end
        -- self:RefreshMasterInfo(message)
        self.TalentNewDatalist = {}
        self:RefreshNewMasterInfo(message)
        SL:onLUAEvent(LUA_EVENT_MASTER_DATA_CHANGE, message)
    end
end

---响应：大师变化信息
---{type = 类型,
---series = 系列,
---points = 天赋点数,
---exchangedExpTimes = 已兑换次数,
---level = 等级,
---exp= 当前经验,
---isFree = 是否免费,
---talent = 天赋信息有多个{{id = 配置id, level， series系列}，{id = 配置id, level， series系列}}}
function this:RES_MASTER_CHANGE_INFO(id, message)
    if message then
        self:RefreshNewMasterInfo(message)
        SL:onLUAEvent(LUA_EVENT_MASTER_SKILL_DATA_CHANGE, message)
    end
end

---是否可升级
function this:IsCanUpLevel(id, series, step, type, isShowTips)
    local skillLv = self:GetMasterLevel(type, series, id)
    local totalNum, frontTalent, consumPoint = self:GetNowTalentLevelInfo(id, skillLv)

    --满级
    if not totalNum and not frontTalent and not consumPoint then
        return true
    end
    ---前置点数
    local frontPoint = self:GetUpperTalentUserPoint(id, type)
    ---前置点数是否满足
    local isPoint = frontPoint >= totalNum
    ---前置天赋是否点亮
    local isFrontTalent = self:GetMasterLevel(type, series, frontTalent) > 0
    local allPoint = self:GetTalentPoint(type, series)
    if totalNum > 0 and consumPoint > allPoint then
        if isShowTips then
            SL:TipMessage(SL:GetConfig('cfg_string', 242).text, 1, NoticeType.NoticeMid) --"点数不足",
            return false
        end
    end
    if type == EMasterTalentType.SKILL then
        if frontTalent > 0 and not isFrontTalent then
            if isShowTips then
                SL:TipMessage(SL:GetConfig('cfg_string', 243).text, 1, NoticeType.NoticeMid) --"前置天赋等级不足",
            end
            return false
        end
        if not isPoint then
            if isShowTips then
                SL:TipMessage(SL:GetConfig('cfg_string', 243).text, 1, NoticeType.NoticeMid) --"前置天赋等级不足",
            end
            return false
        end
    elseif type == EMasterTalentType.CAREER then
        if not isPoint then
            if isShowTips then
                SL:TipMessage(SL:GetConfig('cfg_string', 244).text, 1, NoticeType.NoticeMid) --"在该天赋页内已投入的点数不足",
            end
            return false
        end
    end
    return true
end

---获取天赋点数
function this:GetTalentPoint(type, series)
    type = tonumber(type)
    if not self.TalentPointList[type] then
        return 0
    end
    if type == EMasterTalentType.COMMON then
        return self.TalentPointList[type]
    end
    if not self.TalentPointList[type][series] then
        return 0
    end
    return self.TalentPointList[type][series]
end

---获取最大可升级数
function this:GetMaxPoint(id, lv, maxLevel, type, series)
    local addLv = 0
    local point = 0
    local allPoint = self:GetTalentPoint(type, series)
    for i = lv, maxLevel - 1 do
        local cfg = self:GetMasterCfg(id, lv + 1)
        if cfg then
            if point + cfg.consumPoint > allPoint then
                break
            end
            addLv = addLv + 1
            point = point + cfg.consumPoint
        end
    end
    return addLv
end

---刷新信息
function this:RefreshMasterInfo(message)
    local type = tonumber(message["type"])
    local points = tonumber(message["points"])
    if type == EMasterTalentType.COMMON then
        self.TalentPointList[type] = points
    else
        if not self.TalentPointList[type] then
            self.TalentPointList[type] = {}
        end
        self:RefreshPointInfo(message)
    end
    if not self.TalentDatalist[type] then
        self.TalentDatalist[type] = {}
    end
    local talentList = message["talent"]
    for i, v in pairs(talentList) do
        local series = tonumber(v["series"])
        local cfgId = tonumber(v["cfgId"])
        local level = tonumber(v["level"])
        if type == EMasterTalentType.COMMON then
            self.TalentDatalist[type][cfgId] = level
        else
            if not self.TalentDatalist[type][series] then
                self.TalentDatalist[type][series] = {}
            end
            self.TalentDatalist[type][series][cfgId] = level
        end
    end
    if type == EMasterTalentType.COMMON then
        self.RedDataList[EMasterTalentType.COMMON] = points > 0 and self:GetCommonTalentIsCanAddPoint()
        SL:RefreshPanelALLRedPoint("KLUISystemLeftPanel")
        SL:onLUAEvent(LUA_EVENT_MASTER_RED_DOT_CHANGE)
    end
end

---获取当前天赋的等级信息
---@return cfg_master_info_column
function this:GetNowTalentLevelInfo(id, level)
    local cfg = self:GetMasterCfg(id, level + 1)
    if cfg then
        return cfg.frontNum, cfg.frontTalent, cfg.consumPoint
    end
    return nil, nil, nil
end

---获取当前类型选择的系列
function this:GetNowTypeSelectSeries(type)
    if not self.TalentSeriesList[type] then
        return 0
    end
    return self.TalentSeriesList[type]
end

---获取当前天赋的等级
function this:GetMasterLevel(type, series, cfgId)
    if not self.TalentDatalist[type] then
        return 0
    end
    ---通用的无系列分类
    if type == EMasterTalentType.COMMON then
        if not self.TalentDatalist[type][cfgId] then
            return 0
        end
        return self.TalentDatalist[type][cfgId]
    end
    if not self.TalentDatalist[type][series] then
        return 0
    end
    if not self.TalentDatalist[type][series][cfgId] then
        return 0
    end
    return self.TalentDatalist[type][series][cfgId]
end

---响应：红点信息
---{type = 类型,
---points = 天赋点数,
---exchangedExpTimes = 已兑换次数,
---level = 等级,
function this:RES_MASTER_RED_DOT_INFO(id, message)
    if message then
        for i, v in pairs(message) do
            -- self:RefreshRedDataList(v)
        end
        SL:RefreshPanelALLRedPoint("KLUISystemLeftPanel")
        SL:onLUAEvent(LUA_EVENT_MASTER_RED_DOT_CHANGE)
    end
end

---响应：兑换大师经验
---{type = 类型,
---points = 天赋点数,
---exchangedExpTimes = 已兑换次数,
---level = 等级,
function this:RES_EXCHANGE_MASTER_EXP(id, message)
    if message then
        self:RefreshRedDataList(message)
        SL:RefreshPanelALLRedPoint("KLUISystemLeftPanel")
        SL:onLUAEvent(LUA_EVENT_MASTER_RED_DOT_CHANGE)
    end
end

---刷新红点信息
function this:RefreshRedDataList(message)
    local exchangedExpTimes = tonumber(message["exchangedExpTimes"])
    local points = tonumber(message["points"])
    local type = tonumber(message["type"])
    local level = tonumber(message["level"])
    self.RedDataList[type] = false
    if type == EMasterTalentType.COMMON then
        self.RedDataList[EMasterTalentType.COMMON] = points > 0 and self:GetCommonTalentIsCanAddPoint()
        self.TalentPointList[type] = points
    else
        if not self.TalentPointList[type] then
            self.TalentPointList[type] = {}
        end
        self:RefreshPointInfo(message)
        local maxCount = self:GetTalentMaxCount(type)
        local proLevelCfg = self:GetProLevelCfg(level)
        local skillLevelCfg = self:GetSkillLevelCfg(level)
        --职业天赋有兑换次数且不满级
        if type == EMasterTalentType.CAREER
            and proLevelCfg and proLevelCfg.exp > 0
            and maxCount - exchangedExpTimes > 0 then
            self.RedDataList[EMasterTalentType.CAREER] = true
        end
        --技能天赋有兑换次数且不满级
        if type == EMasterTalentType.SKILL
            and skillLevelCfg and skillLevelCfg.exp > 0
            and maxCount - exchangedExpTimes > 0 then
            self.RedDataList[EMasterTalentType.SKILL] = true
        end
    end
end

---通用天赋是否可加点
function this:GetCommonTalentIsCanAddPoint()
    local cfg = SL:GetConfigTable("cfg_master_commontalent")
    ---@param v cfg_master_commontalent_column
    for i, v in pairs(cfg) do
        --筛选自己职业或者全职业（0为全职业）
        if table.contains(v.career, SL:MeData_GetCareer().baseCareer) or table.contains(v.career, 0) then
            local lv = self:GetMasterLevel(EMasterTalentType.COMMON, nil, v.id)
            if lv < v.minMaxLevel[2] then
                return true
            end
        end
    end
    return false
end

---刷新天赋点数据
function this:RefreshPointInfo(message)
    -- local type = tonumber(message["type"])
    -- local seriesPoints = message["seriesPoints"]
    -- for i, v in pairs(seriesPoints) do
    --     local series = tonumber(v["series"])
    --     local points = tonumber(v["points"])
    --     if not self.TalentPointList[type][series] then
    --         self.TalentPointList[type][series] = 0
    --     end
    --     self.TalentPointList[type][series] = points
    -- end
    self.talentPoint = message["points"]
end

---主界面是否有红点（3个类型有一个红点主界面按钮就显示红点）
function this:GetIsMainRed()
    if not table.isNullOrEmpty(self.RedDataList) then
        for i, v in pairs(self.RedDataList) do
            ---@type cfg_system_switch_column
            local switchCfg = SL:GetConfig("cfg_system_switch", EMasterTalentSystemSwitchID[i])
            if v == true and SL:MeData_GetLevel() >= switchCfg.needLevel then
                return true
            end
        end
    end

    return false
end

---获取天赋最大兑换次数
function this:GetTalentMaxCount(type)
    if not self.talentMaxExchangeCountList[type] then
        if type == EMasterTalentType.CAREER then
            ---@type cfg_global_column
            self.talentMaxExchangeCountList[type] = tonumber(SL:GetConfig("cfg_global", 4004).value)
        end
        if type == EMasterTalentType.SKILL then
            ---@type cfg_global_column
            self.talentMaxExchangeCountList[type] = tonumber(SL:GetConfig("cfg_global", 4014).value)
        end
    end
    return self.talentMaxExchangeCountList[type]
end

---获取玩家职业的所有派系
---@param class number @1职业天赋；2技能天赋
---@return table<number,cfg_master_ui_column>
function this:GetFactionsCfg(class)
    if not self.FactionsCfg[class] then
        self.FactionsCfg[class] = {}
        local cfg = SL:GetConfigTable("cfg_master_ui")
        ---@param v cfg_master_ui_column
        for i, v in pairs(cfg) do
            if table.contains(v.career, SL:MeData_GetCareer().baseCareer) or table.contains(v.career, 0) then
                if v.class == class then
                    table.insert(self.FactionsCfg[class], v)
                end
            end
        end
        table.sort(self.FactionsCfg[class], function(a, b)
            return a.id < b.id
        end)
    end
    return self.FactionsCfg[class]
end

---获取cfg_master_info数据
---@return cfg_master_info_column
function this:GetMasterCfg(id, lv)
    if SL:HasConfigTwoKeys('cfg_master_info', id, lv, 'talentId', 'level') then
        return SL:GetConfigTwoKeys('cfg_master_info', id, lv, 'talentId', 'level')
    end
    return nil
end

---获取cfg_master_proLevel数据
---@return cfg_master_proLevel_column
function this:GetProLevelCfg(level)
    if SL:HasConfig("cfg_master_proLevel", level) then
        return SL:GetConfig("cfg_master_proLevel", level)
    end
    return nil
end

---获取cfg_master_skillLevel数据
---@return cfg_master_skillLevel_column
function this:GetSkillLevelCfg(level)
    if SL:HasConfig("cfg_master_skillLevel", level) then
        return SL:GetConfig("cfg_master_skillLevel", level)
    end
    return nil
end

---获取当前等级消耗点数数
function this:GetNowUsePoint(id, lv)
    local point = 0
    for i = 1, lv do
        local cfg = self:GetMasterCfg(id, i)
        if cfg then
            point = point + cfg.consumPoint
        end
    end
    return point
end

---获取上一层使用点数
function this:GetUpperTalentUserPoint(id, type)
    local point = 0
    ---上层天赋
    local talentUpperList = {}
    if type == EMasterTalentType.CAREER then
        ---@type cfg_master_protalent_column
        local nowCfg = SL:GetConfig("cfg_master_protalent", id)
        if self.TalentDatalist[EMasterTalentType.CAREER] and self.TalentDatalist[EMasterTalentType.CAREER][nowCfg.series] then
            for i, v in pairs(self.TalentDatalist[EMasterTalentType.CAREER][nowCfg.series]) do
                point = self:GetNowUsePoint(i, v) + point
            end
        end

        return point
    elseif type == EMasterTalentType.SKILL then
        ---@type cfg_master_skilltalent_column
        local nowCfg = SL:GetConfig("cfg_master_skilltalent", id)
        ---@type cfg_master_skilltalent_column
        local upCfg = nil
        local cfg = SL:GetConfigTable("cfg_master_skilltalent")
        ---@param v cfg_master_skilltalent_column
        for i, v in pairs(cfg) do
            if table.contains(v.career, SL:MeData_GetCareer().baseCareer) or table.contains(v.career, 0) then
                if nowCfg.id ~= v.id and nowCfg.series == v.series and nowCfg.row == v.row and nowCfg.steps - 1 == v.steps then
                    upCfg = v
                    break
                end
            end
        end
        if upCfg and self.TalentDatalist then
            if upCfg.steps == 0 and upCfg.type == 2 then
                if self.TalentDatalist[EMasterTalentType.CAREER]
                    and self.TalentDatalist[EMasterTalentType.CAREER][upCfg.series]
                    and self.TalentDatalist[EMasterTalentType.CAREER][upCfg.series][upCfg.proTalentId] then
                    point = self:GetNowUsePoint(upCfg.proTalentId,
                        self.TalentDatalist[EMasterTalentType.CAREER][upCfg.series][upCfg.proTalentId])
                end
            else
                if self.TalentDatalist[EMasterTalentType.SKILL]
                    and self.TalentDatalist[EMasterTalentType.SKILL][upCfg.series]
                    and self.TalentDatalist[EMasterTalentType.SKILL][upCfg.series][upCfg.id] then
                    point = self:GetNowUsePoint(upCfg.id,
                        self.TalentDatalist[EMasterTalentType.SKILL][upCfg.series][upCfg.id])
                end
            end
        end
        return point
    end
    return point
end

---刷新信息
function this:RefreshNewMasterInfo(message)
    self.talentPoint = message.points
    if not self.TalentNewDatalist then
        self.TalentNewDatalist = {}
    end
    local talentList = message["talent"] or {}
    for i, v in pairs(talentList) do
        local series = tonumber(v["series"])
        local cfgId = tonumber(v["cfgId"])
        local level = tonumber(v["level"])
        if not self.TalentNewDatalist[series] then
            self.TalentNewDatalist[series] = {}
        end
        self.TalentNewDatalist[series][cfgId] = level
    end
    self:RebuildUsedTalentPoint()
end

---获取当前天赋的等级
function this:GetNewMasterLevel(series, cfgId)
    if not self.TalentNewDatalist[series] or not self.TalentNewDatalist[series][cfgId] then
        local cfg = SL:GetConfig("cfg_master_protalent", cfgId)

        return cfg and cfg.minMaxLevel[1] or 0
    end

    return self.TalentNewDatalist[series][cfgId]
end

function this:GetNewMasterInfo()
    return self.TalentNewDatalist
end

-- 刷新已用天赋点
function this:RebuildUsedTalentPoint()
    self.usedTalentPoint = {}
    if table.isNullOrEmpty(self.TalentNewDatalist) then
        return
    end
    for series, talentMap in pairs(self.TalentNewDatalist) do
        for cfgId, level in pairs(talentMap) do
            if level > 0 then
                local proCfg = SL:GetConfig("cfg_master_protalent", cfgId)
                local tier = proCfg and proCfg.tier or 0
                local cfgInfo = SL:FindConfigs("cfg_master_info", "talentId", cfgId)
                if tier > 0 and cfgInfo then
                    for _, v in pairs(cfgInfo) do
                        if v.level and v.level <= level then
                            local p = tonumber(v.consumPoint) or 0
                            if p > 0 then
                                if not self.usedTalentPoint[tier] then
                                    self.usedTalentPoint[tier] = {}
                                end
                                self.usedTalentPoint[tier][series] = (self.usedTalentPoint[tier][series] or 0) + p
                            end
                        end
                    end
                end
            end
        end
    end
end


-- 获取某系列已用天赋点
function this:GetUsedTalentPoint(series)
    if not series then
        return 0
    end
    series = tonumber(series) or series
    if not self.usedTalentPoint then
        return 0
    end
    local used = 0
    for _, seriesPointMap in pairs(self.usedTalentPoint) do
        used = used + (seriesPointMap[series] or 0)
    end
    return used or 0
end

-- 获取某层（可选某系列）已用天赋点
function this:GetUsedTalentPointByTier(tier, series)
    tier = tonumber(tier) or 0
    if tier <= 0 or not self.usedTalentPoint or not self.usedTalentPoint[tier] then
        return 0
    end
    if series ~= nil then
        series = tonumber(series) or series
        return self.usedTalentPoint[tier][series] or 0
    end
    local used = 0
    for _, point in pairs(self.usedTalentPoint[tier]) do
        used = used + (point or 0)
    end
    return used
end

-- 是否解锁系列某层
function this:IsUnLockseries(series, tier)

    if tier == nil then 
        return
    end
    tier = tonumber(tier) or 0
    if tier <= 1 then
        return true
    end
    local lock = self.lockSeries[tier] or 0
    local used = self:GetUsedTalentPointByTier(tier - 1)
    return used > lock
end

function this:GetUnLockSeriesCSondition(tier)
    return self.lockSeries[tier] or 0
end

function this:GetNewMasterPoint()
    return self.talentPoint or 0
end

function this:Reset()
    ---天赋信息
    self.TalentDatalist = {}
    ---天赋选择的系列
    self.TalentSeriesList = {}
    ---天赋点数数据
    self.TalentPointList = {}
    self.talentPoint = 0
    self.usedTalentPoint = {}
    ---新的天赋信息
    self.TalentNewDatalist = {}
    self.FactionsCfg = {}
    ---红点信息
    self.RedDataList = {
        [EMasterTalentType.CAREER] = false,
        [EMasterTalentType.SKILL] = false,
        [EMasterTalentType.COMMON] = false,
        [EMasterTalentType.Archange] = false,
    }
    self.talentMaxExchangeCountList = {}
end
