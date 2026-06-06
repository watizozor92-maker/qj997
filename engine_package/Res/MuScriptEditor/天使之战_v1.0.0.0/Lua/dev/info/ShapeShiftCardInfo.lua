---@class ShapeShiftCardInfo @变身卡牌
ShapeShiftCardInfo = class()
local this = ShapeShiftCardInfo

--region dataStruct
---@class BagShapeShiftCard
---@field id number
---@field cfgid number
---@field entry table
---@field base table
---@field type number
---@field quality number
---@field group number
---@field breakLuck number
---@field tbl cfg_card_shapeshift_column

---@class ShapeShiftMessage
---@field part ShapeShiftCardMessage[]

---@class ShapeShiftCardMessage
---@field luck number
---@field unlock boolean
---@field card CardMessage

---@class CardMessage
---@field id number
---@field cfgid number
---@field entry table
---@field base table
--endregion

function this:ctor()

end

function this:Reset()
    if self.timer then
        SL:UnSchedule(self.timer)
        self.timer = nil
    end
    SL:SetMetaValue(EMetaVarSetKey.SET_OUT_RELEASE_LIMIT_SKILL)
    SL:SetMetaValue(EMetaVarSetKey.SET_OUT_ME_SHAPE_MONSTER)
    self.shiftMonsterGroup = 0
    self.cardDataIsReady = false
    self.allPartsInfo = {}
    self.eachCardCount = {}
    self.shiftSkill = {}
    self.allTransferSkillList = {}
    self.transferGroupCDList = {}
    self.onHookTransferSkill = {}
end

function this:Init()
    self:InitData()
    self:RegistMessages()
end

function this:InitData()
    ---@type cfg_card_shapeshift_column[]
    self.cfg_card_shapeshift = SL:GetConfigTable("cfg_card_shapeshift")
    self.allPartsInfo = {}
    self.eachCardCount = {}
    self.shiftSkill = {}
    self.allTransferSkillList = {}
    self.transferGroupCDList = {}
    self.onHookTransferSkill = {}
    self.cardDataIsReady = false
end

function this:RegistMessages()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_TRANSFER_CARD_PART_INFO, self.RES_TRANSFER_CARD_PART_INFO, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_TRANSFER_CARD_MODEL_VIEW, self.RES_TRANSFER_CARD_MODEL_VIEW, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_TRANSFER_CARD_BAG, self.RES_TRANSFER_CARD_BAG, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_TRANSFER_CARD_REWARD_PANEL, self.RES_TRANSFER_CARD_REWARD_PANEL, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_TRANSFER_CARD_DURATION, self.RES_TRANSFER_CARD_DURATION, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_TRANSFER_CARD_CD,self.RES_TRANSFER_CARD_CD,self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_TRANSFER_CARD_SETTING,self.RES_TRANSFER_CARD_SETTING,self)

    SL:RegisterLUAEvent(LUA_EVENT_TAKE_ON_EQUIP, self.RefreshShiftCardSkill, self)
    SL:RegisterLUAEvent(LUA_EVENT_TAKE_OFF_EQUIP, self.RefreshShiftCardSkill, self)
    SL:RegisterLUAEvent(LUA_EVENT_ONHOOK_STATE_CHANGE, self.LUA_EVENT_ONHOOK_STATE_CHANGE, self)
end

function this:RES_TRANSFER_CARD_PART_INFO(_, message)
    message = self:RefreshCardPartKeyToNumber(message)
    if message and table.count(message) > 1 then
        self.allPartsInfo = message
    else
        for i, v in pairs(message) do
            self.allPartsInfo[i] = v
            SL:onLUAEvent(LUA_SHAPE_CARD_PART_INFO_CHANGE, i)
        end
    end

    self:RefreshShiftCardSkill()
    ---@type KLShapeShiftCardMainPanel
    local ui = GUI:GetUI("dev/outui/ShapeShiftCard/Panel/KLShapeShiftCardMain/KLShapeShiftCardMainPanel")
    if ui then
        ui:RefreshMainRedPoint()
    else
        SL:RefreshPanelALLRedStateKmlByCondition("checkShapeShiftCardRedDot")
    end
    self.cardDataIsReady = true
end

function this:RES_TRANSFER_CARD_MODEL_VIEW(_, message)
    if tonumber(message["2"]) == 0 then
        local monsterId = AppearInfo.GetCacheMeMonsterId(tonumber(message["1"]))
        SL:SetMetaValue(EMetaVarSetKey.SET_OUT_ME_SHAPE_MONSTER)
        SL:RefreshToShowMonster(tonumber(message["1"]), monsterId)
    else
        for i, v in pairs(self.cfg_card_shapeshift) do
            if v.group == tonumber(message["2"]) then
                SL:SetMetaValue(EMetaVarSetKey.SET_OUT_ME_SHAPE_MONSTER, v.model)
                SL:RefreshToShowMonster(tonumber(message["1"]), v.model)
                break
            end
        end
    end

    if SL:GetMetaValue(EMetaVarGetKey.ACTOR_IS_MAINPLAYER, tonumber(message["1"])) then
        if self.cardDataIsReady then
            self.shiftMonsterGroup = tonumber(message["2"])
            SL:onLUAEvent(LUA_EVENT_REFRESH_ATTACK_SKILL)
            if tonumber(message["2"]) == 0 then
                SL:SetMetaValue(EMetaVarSetKey.SET_OUT_RELEASE_LIMIT_SKILL)
                self:LUA_EVENT_ONHOOK_STATE_CHANGE()
            else
                if self.shiftSkill[self.shiftMonsterGroup] then
                    SL:SetMetaValue(EMetaVarSetKey.SET_OUT_RELEASE_LIMIT_SKILL, self:GetUnLockShiftSkill())
                end
            end
            ---@type KLUISystemLeftPanel
            local ui = GUI:GetUI("dev/ui/MainUI/Panel/KLUISystemLeft/KLUISystemLeftPanel")
            if ui then
                ui:ShapeShiftStateChangeRefreshUI()
            end
            ---@type KLUISkillInfoPanel
            local ui_2 = GUI:GetUI("dev/ui/Skill/Panel/KLUISkillInfo/KLUISkillInfoPanel")
            if ui_2 then
                ui_2:RefreshNormalSkillPanel()
            end
        end
    end
end

---@param message BagShapeShiftCard[]
function this:RES_TRANSFER_CARD_BAG(_, message)
    self.allCardInfo = {}
    self.eachCardCount = {}
    if message then
        for i, v in pairs(message) do
            ---@type cfg_item_column
            local item_tbl = SL:GetConfig("cfg_item", v.cfgid)
            ---@type cfg_card_shapeshift_column
            local card_tbl = SL:GetConfig("cfg_card_shapeshift", v.cfgid)
            local info = {}
            info.id = v.id
            info.cfgid = v.cfgid
            info.entry = v.entry
            info.base = v.base
            info.breakLuck = v.breakluck
            info.type = item_tbl.subType
            info.quality = card_tbl.quality
            info.group = card_tbl.group
            info.tbl = card_tbl
            self.allCardInfo[#self.allCardInfo + 1] = info
            if self.eachCardCount[info.cfgid] then
                self.eachCardCount[info.cfgid] = self.eachCardCount[info.cfgid] + 1
            else
                self.eachCardCount[info.cfgid] = 1
            end
        end
    end
    table.sort(self.allCardInfo, function(a, b)
        if a.subType ~= b.subType then
            return a.subType < b.subType
        else
            if a.quality ~= b.quality then
                return a.quality > b.quality
            else
                return a.cfgid > b.cfgid
            end
        end
    end)
    SL:onLUAEvent(LUA_SHAPE_CARD_BAG_CHANGE)
    ---@type KLShapeShiftCardMainPanel
    local ui = GUI:GetUI("dev/outui/ShapeShiftCard/Panel/KLShapeShiftCardMain/KLShapeShiftCardMainPanel")
    if ui then
        ui:RefreshMainRedPoint()
    else
        SL:RefreshPanelALLRedStateKmlByCondition("checkShapeShiftCardRedDot")
    end
end

function this:RES_TRANSFER_CARD_REWARD_PANEL(_, message)
    GUI:UIPanel_Open("dev/outui/ShapeShiftCard/Panel/KLShapeShiftCardAward/KLShapeShiftCardAwardPanel", nil, nil, message)
end

function this:RES_TRANSFER_CARD_DURATION(_, message)
    ---@type KLUISystemLeftPanel
    local ui = GUI:GetUI("dev/ui/MainUI/Panel/KLUISystemLeft/KLUISystemLeftPanel")
    if ui then
        ui:RefreshTransferDurationCD(tonumber(message["2"]))
    end
end

function this:RES_TRANSFER_CARD_CD(_, message)
    self.transferGroupCDList = {}
    for i, v in pairs(message) do
        self.transferGroupCDList[tonumber(i)] = v
    end
end

function this:RES_TRANSFER_CARD_SETTING(_, message)
    for i, v in pairs(message) do
        self.onHookTransferSkill[tonumber(i)] = v
    end
end

function this:isShiftMonster()
    if self.cardDataIsReady then
        if self.shiftMonsterGroup and self.shiftMonsterGroup > 0 then
            return true
        end
    end
    return false
end

function this:RefreshCardPartKeyToNumber(message)
    if message and next(message) then
        local tbl = {}
        for i, v in pairs(message) do
            local tbl_1 = {}
            for j, k in pairs(v) do
                tbl_1[tonumber(j)] = k
            end
            tbl[tonumber(i)] = tbl_1
        end
        return tbl
    end
end

function this:RefreshShiftCardSkill()
    self.equip = SL:GetTotalWearEquips()
    local shiftSkill = {}
    if self.equip[1] then
        for i, v in pairs(self.allPartsInfo) do
            if self.equip[1][i] then
                for ii, vv in pairs(v) do
                    if vv.card and table.count(vv.card) > 0 then
                        ---@type cfg_card_shapeshift_column
                        local tbl = SL:GetConfig("cfg_card_shapeshift", vv.card.cfgid)
                        if #tbl.skill > 0 then
                            if shiftSkill[tbl.group] then
                                if shiftSkill[tbl.group] < tbl.level then
                                    shiftSkill[tbl.group] = tbl.level
                                end
                            else
                                shiftSkill[tbl.group] = tbl.level
                            end
                        end
                    end
                end
            end
        end
        self.shiftSkill = {}
        for i, v in pairs(shiftSkill) do
            self.shiftSkill[i] = {}
            self.shiftSkill[i].unlockSkill = self:GetUnLockShiftSkill(i, v)
            self.shiftSkill[i].lockSkill = self:GetLockShiftSkill(i, v)
            self.shiftSkill[i].allSkill = self:GetAllShiftSkill(i, v)
            self.shiftSkill[i].level = v
            self.shiftSkill[i].group = i
            self:CacheAllTransferSkillByGroup(i)
        end
        SL:onLUAEvent(LUA_EVENT_SHAPE_SHIFT_CARD_SKILL_CHANGE)
    end
end

---获取变身后解锁技能
function this:GetUnLockShiftSkill(group, level)
    group = group or self.shiftMonsterGroup
    level = level or self.shiftSkill[self.shiftMonsterGroup].level
    local skill = {}
    for i, v in pairs(self.cfg_card_shapeshift) do
        if v.group == group and v.level == level then
            for j, k in pairs(v.skill) do
                ---@type cfg_skill_column
                local cfg = SL:GetConfig("cfg_skill", k[1])
                if cfg.type == 0 then
                    skill[k[1]] = k[2]
                end
            end
        end
    end
    return skill
end

---获取变身后锁定技能
function this:GetLockShiftSkill(group, level)
    group = group or self.shiftMonsterGroup
    level = level or self.shiftSkill[self.shiftMonsterGroup].level
    local skill = {}
    for i, v in pairs(self.cfg_card_shapeshift) do
        if v.group == group and v.level > level then
            for j, k in pairs(v.skill) do
                ---@type cfg_skill_column
                local cfg = SL:GetConfig("cfg_skill", k[1])
                if cfg.type == 0 then
                    if skill[k[1]] then
                        if skill[k[1]] > v.level then
                            skill[k[1]] = v.level
                        end
                    else
                        skill[k[1]] = v.level
                    end
                end
            end
        end
    end
    return skill
end

function this:GetAllShiftSkill(group, level)
    group = group or self.shiftMonsterGroup
    level = level or self.shiftSkill[self.shiftMonsterGroup].level
    local skill = {}
    for i, v in pairs(self.cfg_card_shapeshift) do
        if v.group == group and v.level == level then
            for _, k in pairs(v.skill) do
                ---@type cfg_skill_column
                local cfg = SL:GetConfig("cfg_skill", k[1])
                skill[k[1]] = { level = k[2], group = cfg.group, unLock = true }
            end
        elseif v.group == group and v.level > level then
            for _, k in pairs(v.skill) do
                if not skill[k[1]] then
                    ---@type cfg_skill_column
                    local cfg = SL:GetConfig("cfg_skill", k[1])
                    skill[k[1]] = { level = k[2], group = cfg.group, unLock = false }
                end
            end
        end
    end
    return skill
end

function this:CacheAllTransferSkillByGroup(group)
    if self.shiftSkill and self.shiftSkill[group] then
        if not self.allTransferSkillList then
            self.allTransferSkillList = {}
        end
        for i, v in pairs(self.shiftSkill[group].allSkill) do
            self.allTransferSkillList[i] = v
        end
    end
end

function this:GetTransferSkillInfoBySkillId(id)
    if self.allTransferSkillList then
        return self.allTransferSkillList[id]
    end
end

---挂机模式优先自动释放变身技能
function this:LUA_EVENT_ONHOOK_STATE_CHANGE()
    local state = SL:GetMetaValue(EMetaVarGetKey.GET_ONHOOK_STATE)
    if state == EAutoOnHookStatus.OnHooking then
        if self:isShiftMonster() then
            ---已经变身
            return
        else
            ---是否可变身
            if self.shiftSkill then
                local nowTime = Time.GetServerTime()
                local maxGroup = 0
                local minCD
                ---遍历所有变身
                for i, v in pairs(self.shiftSkill) do
                    ---是否设置可变身
                    if not self.onHookTransferSkill[i] or self.onHookTransferSkill[i] == 1 then
                        ---是否cd
                        if not self.transferGroupCDList[i] or self.transferGroupCDList[i] <= nowTime then
                            if maxGroup < i then
                                maxGroup = i
                            end
                        else
                            local time = self.transferGroupCDList[i] - nowTime
                            if time > 0 then
                                if not minCD then
                                    minCD = time
                                elseif minCD > time then
                                    minCD = time
                                end
                            end
                        end
                    end
                end
                ---可变身
                if maxGroup > 0 then
                    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_TRANSFORMATION, maxGroup)
                else
                    ---全部cd则倒计时判断变身
                    if self.timer then
                        SL:UnSchedule(self.timer)
                        self.timer = nil
                    end
                    if minCD then
                        self.timer = SL:ScheduleOnce((minCD / 1000) + 1, function()
                            self:LUA_EVENT_ONHOOK_STATE_CHANGE()
                        end)
                    end
                end
            end
        end
    else
        if self.timer then
            SL:UnSchedule(self.timer)
            self.timer = nil
        end
    end
end

function this:GetMonsterIcon(group)
    for i, v in pairs(self.cfg_card_shapeshift) do
        if v.group == group then
            ---@type cfg_monster_column
            local monster = SL:GetConfig("cfg_monster", v.model)
            if monster then
                return monster.icon, monster.name
            end
        end
    end
end

function this:GetMonsterModelId(group)
    group = group or self.shiftMonsterGroup
    for i, v in pairs(self.cfg_card_shapeshift) do
        if v.group == group then
            return v.model
        end
    end
end

function this:RefreshMainIconRedPoint()
    ---@type cfg_system_switch_column
    local cfg = SL:GetConfig("cfg_system_switch", 112)
    if cfg.needLevel > SL:GetMetaValue("LEVEL") then
        return false
    end
    local isOpen = SL:GetMetaValue(EMetaVarGetKey.IS_OPEN_SYSTEMFUNCTION, cfg.systemName)
    if not isOpen then
        return false
    end
    if self:RefreshCardShopRedPointInfo() then
        return true
    end
    if self:RefreshCardInlayRedPointInfo() then
        return true
    end
    if self:RefreshCardSynthesisRedPointInfo() then
        return true
    end
    if self:RefreshCardBreakRedPointInfo() then
        return true
    end
    return false
end

---刷新卡牌商城红点
function this:RefreshCardShopRedPointInfo()
    if not self.cfg_card_shop then
        ---@type cfg_card_shop_column[]
        self.cfg_card_shop = SL:GetConfigTable("cfg_card_shop")
    end
    for i, v in pairs(self.cfg_card_shop) do
        if SL:GetBagItemCount(v.exchangeConsume[1]) >= v.exchangeConsume[2] then
            return true
        end
    end
    return false
end

---刷新卡牌镶嵌红点
function this:RefreshCardInlayRedPointInfo()
    if self.allPartsInfo then
        for i, v in pairs(self.allPartsInfo) do
            ---@type cfg_card_inlay_column
            local inlay = SL:GetConfig("cfg_card_inlay", tonumber(i))
            for j, k in pairs(v) do
                if k.unlock then
                    if not k.card or table.count(k.card) == 0 then
                        if self:GetPartHaveCardCheck(i) then
                            return true
                        end
                    end
                else
                    local rank = InfoManager.shapeShiftCardInfo:GetEquipRankByPart(i)
                    for ii, vv in ipairs(inlay.unlockParameter) do
                        if j == vv[1] then
                            if rank >= vv[2] then
                                return true
                            end
                        end
                    end
                    --if inlay.unlockNormal then
                    --    for ii, vv in ipairs(inlay.unlockNormal) do
                    --        if vv[1] == tonumber(j) then
                    --            if SL:GetBagItemCount(vv[2]) >= vv[3] then
                    --                return true
                    --            end
                    --        end
                    --    end
                    --end
                end
            end
        end
    end
    return false
end

---刷新卡牌牌库红点
function this:RefreshCardHouseRedPointInfo()
    return false
end

---刷新卡牌合成红点
function this:RefreshCardSynthesisRedPointInfo()
    for i, v in pairs(self.eachCardCount) do
        ---@type cfg_card_shapeshift_column
        local cfg = SL:GetConfig("cfg_card_shapeshift", i)
        if cfg.upAmount ~= 0 then
            if cfg.upAmount <= v then
                return true
            end
        end
    end
    return false
end

---刷新卡牌突破红点
function this:RefreshCardBreakRedPointInfo()
    for i, v in pairs(self.eachCardCount) do
        if SL:HasConfig("cfg_card_breakthrough", i) then
            ---@type cfg_card_breakthrough_column
            local cfg = SL:GetConfig("cfg_card_breakthrough", i)
            if cfg.expend ~= 0 then
                if cfg.expend <= v then
                    return true
                end
            end
        end
    end
    return false
end

function this:GetBagCardCountByCfgId(cfgId)
    return self.eachCardCount[cfgId] or 0
end

function this:GetPartHaveCardCheck(part)
    ---@type cfg_card_inlay_column
    local cfg = SL:GetConfig("cfg_card_inlay", part)
    if cfg.type == 1 then
        local partInfo = self.allPartsInfo[part]
        local limitList = {}
        for i, v in pairs(partInfo) do
            if v.card and table.count(v.card) > 0 then
                ---@type cfg_card_shapeshift_column
                local tbl = SL:GetConfig("cfg_card_shapeshift", v.card.cfgid)
                limitList[tbl.group] = true
            end
        end
        ---@type cfg_card_inlay_column
        local tbl = SL:GetConfig("cfg_card_inlay", part)
        for i, v in pairs(self.allCardInfo) do
            if tbl.type == v.type and not limitList[v.group] then
                return true
            end
        end
    else
        ---@type cfg_card_inlay_column
        local tbl = SL:GetConfig("cfg_card_inlay", part)
        for i, v in pairs(self.allCardInfo) do
            if tbl.type == v.type then
                return true
            end
        end
    end
    return false
end

function this:GetEquipRankByPart(part)
    if self.equip and self.equip[1] then
        if self.equip[1][part] then
            ---@type cfg_card_inlay_column
            local tbl = SL:GetConfig("cfg_card_inlay", part)
            if tbl.unlockType == 1 then
                ---@type cfg_item_column
                local item = SL:GetConfig("cfg_item", self.equip[1][part].cfgId)
                return item.rank
            else
                if self.equip[1][part].luaExtData ~= "null" and self.equip[1][part].luaExtData ~= "" then
                    local OutEquipData = SL:JsonDecode(self.equip[1][part].luaExtData,false)---json.decode(self.equip[1][part].luaExtData)
                    return OutEquipData.ssuplv or 0
                end
            end
        else
            return 0, true
        end
    end
    return 0
end

function this:GetNextLevelUnLockAttr(group, level)
    local cardNextLevelUnLockTbl = {}
    if not cardNextLevelUnLockTbl[group] then
        local info = {}
        for _, v in pairs(self.cfg_card_shapeshift) do
            if v.group == group then
                --if #v.specialAtt > 0 then
                    info[v.level] = v.specialAtt
                --end
            end
        end
        if #info > 0 then
            cardNextLevelUnLockTbl[group] = info
        else
            return
        end
    end
    
    local normalAttr = {}
    if cardNextLevelUnLockTbl[group][1] then
        for _, v in ipairs(cardNextLevelUnLockTbl[group][1]) do
            normalAttr[v] = 1
        end
    end
    
    local info = {}
    if level < #cardNextLevelUnLockTbl[group] then
        for i = level + 1, #cardNextLevelUnLockTbl[group] do
            local attr = cardNextLevelUnLockTbl[group][i]
            local temp = {}
            if attr then
                for _, k in pairs(attr) do
                    if normalAttr[k] == 1 then
                        if not temp.normal then
                            temp.normal = 0
                        end
                        temp.normal = temp.normal + 1
                    else
                        if not temp.special then
                            temp.special = 0
                        end
                        temp.special = temp.special + 1
                    end
                end
            end
            info[#info + 1] = temp
        end
    end
    local eachLevel = true
    for i, v in ipairs(info) do
        if not v.normal or v.normal == 0 then
            eachLevel = false
            break
        end
    end
    return info, eachLevel
    
    --if level < #cardNextLevelUnLockTbl[group] then
    --    local info = {}
    --    for i = level + 1, #cardNextLevelUnLockTbl[group] do
    --        if cardNextLevelUnLockTbl[group][i].count >= 1 then
    --            if normalAttr ~=  then
    --                
    --            end
    --            info[#info + 1] = cardNextLevelUnLockTbl[group][i]
    --        else
    --            info[#info + 1] = 0
    --            eachLevel = false
    --        end
    --    end
    --    return info, eachLevel
    --end
end

---判断是否可一键
---@param funcType E_ShapeShiftCardFuncType 功能类型
---@param value number 合成-等级，突破-品质
function this:GetCardLevelOrQualityCanUpgrade(funcType, cardType, value)
    if funcType == E_ShapeShiftCardFuncType.Synthesis then
        for i, v in pairs(self.eachCardCount) do
            ---@type cfg_card_shapeshift_column
            local tbl = SL:GetConfig("cfg_card_shapeshift", i)
            ---@type cfg_item_column
            local item = SL:GetConfig("cfg_item", i)
            if tbl.level == value and item.subType == cardType and tbl.upAmount <= v and tbl.upAmount ~= 0 then
                return true
            end
        end
    elseif funcType == E_ShapeShiftCardFuncType.Break then
        for i, v in pairs(self.eachCardCount) do
            if SL:HasConfig("cfg_card_breakthrough", i) then
                ---@type cfg_card_breakthrough_column
                local tbl_break = SL:GetConfig("cfg_card_breakthrough", i)
                ---@type cfg_card_shapeshift_column
                local tbl_shape = SL:GetConfig("cfg_card_shapeshift", i)
                ---@type cfg_item_column
                local item = SL:GetConfig("cfg_item", i)
                if tbl_shape.quality == value and item.subType == cardType and tbl_break.expend <= v then
                    return true
                end
            end
        end
    end
    return false
end

function this:GetAllCardSkillByGroup(group, level)
    local skill = {}
    for i, v in pairs(self.cfg_card_shapeshift) do
        if v.group == group then
            if v.level == level then
                for _, k in pairs(v.skill) do
                    ---@type cfg_skill_info_column
                    local cfg = SL:GetConfigMultiKeys('cfg_skill_info', k[1], k[2], 'skillID', 'skillLevel')
                    skill[k[1]] = { lock = false, level = k[2], cardLevel = v.level, icon = cfg.icon, tips = cfg.tips, upgrade = false }
                end
            elseif v.level == level + 1 then
                for _, k in pairs(v.skill) do
                    ---@type cfg_skill_info_column
                    local cfg = SL:GetConfigMultiKeys('cfg_skill_info', k[1], k[2], 'skillID', 'skillLevel')
                    if not skill[k[1]] then
                        skill[k[1]] = { lock = true, level = k[2], cardLevel = v.level, icon = cfg.icon, tips = cfg.tips, upgrade = true }
                    else
                        if k[2] > skill[k[1]].level then
                            skill[k[1]].upgrade = true
                        end
                    end
                end
            elseif v.level > level + 1 then
                for _, k in pairs(v.skill) do
                    ---@type cfg_skill_info_column
                    local cfg = SL:GetConfigMultiKeys('cfg_skill_info', k[1], k[2], 'skillID', 'skillLevel')
                    if not skill[k[1]] then
                        skill[k[1]] = { lock = true, level = k[2], cardLevel = v.level, icon = cfg.icon, tips = cfg.tips, upgrade = false }
                    end
                end
            end
        end
    end
    return skill
end