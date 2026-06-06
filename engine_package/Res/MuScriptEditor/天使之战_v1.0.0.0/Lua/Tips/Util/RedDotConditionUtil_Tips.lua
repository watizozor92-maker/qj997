---@class RedDotConditionUtil @注释
RedDotConditionUtil = class()
local this = RedDotConditionUtil

---@class RedDotResult
---@field compareSign string  @比较符号
---@field compareValue number @目标值
---@field fieldName string @比较条件中文名


---@type RedDotResult
this.redDotResult = {}

---@class redDotFunc
this.redDotFunc = {}

local conditionFunc = {}---判断方法

this.moduleRedConditionFunc = {}

---@param tbl1 table
---@param tbl2 table
function this.redDotFunc.CombineTable(tbl1, tbl2)
    local count = #tbl1
    for i = 1, #tbl2 do
        tbl1[count + i] = tbl2[i]
    end
end
---@param tblL table
---@param tblR table
---@return table
function this.redDotFunc.FindAllBracketPair(tblL, tblR)
    if not tblL or #tblL == 0 then
        return tblR
    elseif not tblR or #tblR == 0 then
        return tblL
    end
    local tbl = {}
    local index = #tblL
    local temp = {}
    this.redDotFunc.CombineTable(temp, tblL)
    for i = 1, #tblR do
        local isFind = false
        local len = #temp
        repeat
            if temp[len] < tblR[i] then
                local t = {}
                t.left = temp[len]
                t.right = tblR[i]
                tbl[i] = t
                index = index - 1
                isFind = true
                table.remove(temp, len)
            end
            len = len - 1
        until (isFind)
    end
    return tbl
end

---@param tbl1 table
---@param tbl2 table
---@return table
function this.redDotFunc.BlendTable(tbl1, tbl2)
    local tbl = {}
    local count = #tbl1
    for i = 1, #tbl1 do
        tbl[i] = tbl1[i]
    end
    for i = 1, #tbl2 do
        tbl[i + count] = tbl2[i]
    end
    return tbl
end

---两个数值比较大小
---@param num1 number @现有的值
---@param compareStr string @比较符号
---@param num2 number @比较目标值
---@return boolean
function this.redDotFunc.Compare(num1, compareStr, num2)

    num1 = tonumber(num1)
    num2 = tonumber(num2)

    if not num1 or not compareStr or not num2 then
        logError("比较参数传递错误")
        return nil
    end

    this.redDotResult.compareSign = compareStr
    this.redDotResult.compareValue = num2

    if compareStr == ">" then
        return num1 > num2
    elseif compareStr == "=" then
        return num1 == num2
    elseif compareStr == "<" then
        return num1 < num2
    elseif compareStr == ">=" then
        return num1 >= num2
    elseif compareStr == "<=" then
        return num1 <= num2
    elseif compareStr == "!=" then
        return num1 ~= num2
    end
    return nil
end

---判断两个值是否相等
---@param num1 number @现有值
---@param num2 number @比较值
---@return boolean
function this.redDotFunc.Equal(num1, num2)

    this.redDotResult.compareValue = num2
    this.redDotResult.compareSign = "="

    return num1 == num2
end

---找到指定符号在字符串中的所有下标
---@param str string
---param char string
---return table 
function this.redDotFunc.FindAllIndex(str, char)
    if not this.FindAllIndexTables then
        this.FindAllIndexTables = {}
    end
    if not this.FindAllIndexTables[str] then
        this.FindAllIndexTables[str] = {}
    end
    local t = this.FindAllIndexTables[str][char]
    if t then
        return t
    end
    local isFind = true
    local index = -1
    local sign = 1
    local tbl = {}
    local num = 1
    char = "%" .. char
    while isFind do
        _, index = string .find(str, char, sign)
        if index then
            isFind = true
            sign = index + 1
            tbl[num] = index --保存第x个左括号的下标)
            num = num + 1
        else
            isFind = false
        end
    end
    return tbl
end

---获取比较符，和比较符后面一位的字符串下标
---@param condition string
---@return string,string
function this.redDotFunc.GetComparerSign(condition)
    local firstIndex, lastIndex = nil, nil
    if string.find(condition, ">=", 1) then
        firstIndex, lastIndex = string.find(condition, ">=", 1)
        return ">=", lastIndex
    elseif string.find(condition, "<=", 1) then
        firstIndex, lastIndex = string.find(condition, "<=", 1)
        return "<=", lastIndex
    elseif string.find(condition, "!=", 1) then
        firstIndex, lastIndex = string.find(condition, "!=", 1)
        return "!=", lastIndex
    elseif string.find(condition, ">", 1) then
        firstIndex, lastIndex = string.find(condition, ">", 1)
        return ">", lastIndex
    elseif string.find(condition, "<", 1) then
        firstIndex, lastIndex = string.find(condition, "<", 1)
        return "<", lastIndex
    elseif string.find(condition, "=", 1) then
        firstIndex, lastIndex = string.find(condition, "=", 1)
        return "=", lastIndex
    else
        return nil, nil
    end
end

---获取符号后的到结尾的目标值
---@param condition string
---@param index number
---@return number
function this.redDotFunc.GetTargetValue(condition, index)
    local targetValue = string.match(condition, "(%d+)", index)
    targetValue = tonumber(targetValue) or 0
    return targetValue
end
---（通过条件）获取符号后的到结尾的目标值
function this.redDotFunc.GetTargetValueByCondition(condition)
    local _, lastIndex = this.redDotFunc.GetComparerSign(condition)
    local target = this.redDotFunc.GetTargetValue(condition, lastIndex)
    return target
end

---比较条件格式为 目标类型#比较符#参数，例：checkLevel#>=#40
---@param condition string
---@param currentValue number
---@return boolean
function this.redDotFunc.ComparerForABType(condition, currentValue)
    local sign, lastIndex = this.redDotFunc.GetComparerSign(condition)
    local target = this.redDotFunc.GetTargetValue(condition, lastIndex)

    this.redDotResult.compareSign = sign
    this.redDotResult.compareValue = target

    ---@type boolean
    local value = this.redDotFunc.Compare(currentValue, sign, target)
    return value
end

---获取中括号之间的数值
---@param condition string
---@return string
function this.redDotFunc.GetStringInParentheses(condition)
    local firstIndex = string.find(condition, "%[", 1)
    local lastIndex = string .find(condition, "%]", firstIndex + 1)
    local str = string.sub(condition, firstIndex + 1, lastIndex - 1)
    return str
end

---根据指定字符切割字符串
function this.redDotFunc.SplitString(condition, sign, startIndex, tbl)
    local index = string.find(condition, sign, startIndex)
    if index ~= nil then
        local str = string.sub(condition, startIndex, index - 1)
        table.insert(tbl, str)
        this.redDotFunc.SplitString(condition, sign, index + 1, tbl)
    else
        local str = string.sub(condition, startIndex, #condition)
        table.insert(tbl, str)
    end
end

---@param condition string
---@return boolean
conditionFunc[EConditionType.CheckLevel] = function(condition)
    if not RoleManager.meData then
        return false
    end
    ---@type number
    local level = RoleManager.meData.Level
    return this.redDotFunc.ComparerForABType(condition, level)
end
---@param condition string
---@return boolean
conditionFunc[EConditionType.CheckReNewLevel] = function(condition)
    --0415 目前还没有转生，后期补充
    return false
end

---@param condition string
---@return boolean
conditionFunc[EConditionType.CheckRunDay] = function(condition)
    local openTime = Time.FormatTimeYMDHMS(LoginManager.EnterRoleRes.openServerTime / 1000)

    --local curTime = Time.GetServerTime() --时间戳，单位毫秒
    local sign, lastIndex = this.redDotFunc.GetComparerSign(condition)
    local target = this.redDotFunc.GetTargetValue(condition, lastIndex)
    --开服年月日时分秒
    local year = string.sub(openTime, 1, 4)
    local month = string.sub(openTime, 6, 7)
    local day = string.sub(openTime, 9, 10)
    --local hour = string .sub(openTime, 12, 13)
    --local minute = string .sub(openTime, 15, 16)
    --local second = string.sub(openTime, 18, 19)

    --当前时间年月日
    local curYear = Time.GetYear()
    local curMonth = Time.GetMonth()
    local curDay = Time.GetDay()
    local days = 0

    --开服时间，天
    local openDate = os.time({ year = year, month = month, day = day })
    --当前时间，天
    local curDate = os.time({ year = curYear, month = curMonth, day = curDay })

    --以相隔24小时为一天
    --local disparity = curTime - openDate * 1000
    --local days = disparity / (24 * 60 * 60 * 1000)
    --days = math.ceil(days)
    --以自然日为一天
    days = math.abs(curDate - openDate) / (3600 * 24) + 1

    target = tonumber(target)
    return this.redDotFunc.Compare(days, sign, target)
end
---@param condition string
---@return boolean
conditionFunc[EConditionType.CheckVipLevel] = function(condition)

    local sign, lastIndex = this.redDotFunc.GetComparerSign(condition)
    local target = this.redDotFunc.GetTargetValue(condition, lastIndex)

    return this.redDotFunc.Compare(vipLevel, sign, target)
end
---@param condition string
---@return boolean
conditionFunc[EConditionType.CheckGender] = function(condition)

    local sign, lastIndex = this.redDotFunc.GetComparerSign(condition)
    local target = this.redDotFunc.GetTargetValue(condition, lastIndex)
    local gender = RoleManager.meData.sex
    target = tonumber(target)
    return this.redDotFunc.Equal(gender, Gender)
end
---@param condition string
---@return boolean
conditionFunc[EConditionType.CheckAbility] = function(condition)
    local number = this.redDotFunc.GetStringInParentheses(condition)
    number = tonumber(number)
    local ability = RoleManager.meData:GetRoleDate(number)
    local sign, lastIndex = this.redDotFunc.GetComparerSign(condition)
    local target = this.redDotFunc.GetTargetValue(condition, lastIndex)
    target = tonumber(target)
    return this.redDotFunc.Compare(ability, sign, target)
end
---@param condition string
---@return boolean
conditionFunc[EConditionType.CheckHasUnion] = function(condition)
    local unionId = RoleManager.meData.roleExtInfo.unionId

    if unionId == nil then
        return false
    end
    return not this.redDotFunc.Equal(unionId, 0)
end
---@param condition string
---@return boolean
conditionFunc[EConditionType.CheckHasTeam] = function(condition)
    local teamId = RoleManager.meData.teamId
    if teamId == nil then
        return false
    end
    return not this.redDotFunc.Equal(teamId, 0)
end
---@param condition string
---@return boolean
conditionFunc[EConditionType.CheckPKPoint] = function(condition)
    local pkPoint = RoleManager.meData.PkValue
    return this.redDotFunc.ComparerForABType(condition, pkPoint)
end
---@param condition string
---@return boolean
conditionFunc[EConditionType.CheckJob] = function(condition)
    local sign, lastIndex = this.redDotFunc.GetComparerSign(condition)
    local career = RoleManager.meData.career.baseCareer
    local job = this.redDotFunc.GetTargetValue(condition, lastIndex)
    return this.redDotFunc.Equal(career, job)
end
---@param condition string
---@return boolean
conditionFunc[EConditionType.CheckBagItem] = function(condition)
    local itemId = this.redDotFunc.GetStringInParentheses(condition)
    local itemCount = RoleManager.meData.bagInfo:GetItemCount(tonumber(itemId))
    local sign, lastIndex = this.redDotFunc.GetComparerSign(condition)
    local targetValue = this.redDotFunc.GetTargetValue(condition, lastIndex)
    tonumber(targetValue)
    return this.redDotFunc.Compare(itemCount, sign, targetValue)
end
---@param condition string
---@return boolean
conditionFunc[EConditionType.CheckVar] = function(condition)

    return false
end
---@param condition string
---@return boolean
conditionFunc[EConditionType.CheckHandWeapon] = function(condition)
    local type = this.redDotFunc.GetStringInParentheses(condition)
    local target = string.sub(condition, #condition)
    target = tonumber(target)
    local weaponId = nil
    if type == "Left" then
        weaponId = RoleManager.meData.weaponItemId
    elseif type == "Right" then
        weaponId = RoleManager.meData.weapon2ItemId
    end
    if weaponId == 0 then
        return false
    end
    local tbl = ConfigManager.Get_cfg_item(weaponId)
    return this.redDotFunc.Equal(tbl.twoHanded, target)
end
---@param condition string
---@return boolean
conditionFunc[EConditionType.CheckWearEquip] = function(condition)
    local typeStr = this.redDotFunc.GetStringInParentheses(condition)
    ---local type = EEquipSlotType[typeStr]
    typeStr = tonumber(typeStr)
    local equips = SL:GetMetaValue("EQUIP_DATA_LIST", typeStr) --穿戴在指定部位的所有装备
    if table.count(equips) > 0 then
        return true
    else
        if EEquipStrPartName[typeStr] then
            return false, "未穿戴" .. EEquipStrPartName[typeStr]
        end
        return false
    end
end
---@param condition string
---@return boolean
conditionFunc[EConditionType.CheckBagSize] = function(condition)
    local emptyGrid = RoleManager.meData.bagInfo:GetRemainTileCount()
    local sign, lastIndex = this.redDotFunc.GetComparerSign(condition)
    local targetValue = this.redDotFunc.GetTargetValue(condition, lastIndex)
    targetValue = tonumber(targetValue)
    return this.redDotFunc.Compare(emptyGrid, sign, targetValue)
end
---@param condition string
---@return boolean
conditionFunc[EConditionType.CanPutInBag] = function(condition)
    local str = this.redDotFunc.GetStringInParentheses(condition)
    local splitIndex = string .find(str, ',')
    local itemName = string.sub(str, 1, splitIndex - 1)
    local count = string.sub(str, splitIndex + 1)
    ---@type cfg_item_column
    local cfgItem = nil
    local cfgTbl = ConfigManager.GetConfigTable("cfg_item")
    for i = 1, #cfgTbl do
        if cfgTbl[i].name == itemName then
            cfgItem = cfgTbl[i]
        end
    end
    ---@type CommonProtos.Item
    local item = {}
    item.cfgId = cfgItem.id
    item.count = count

    return RoleManager.meData.bagInfo:CanPutToBag(item)
end

---@param condition string
---@return boolean
conditionFunc[EConditionType.Random] = function(condition)
    local value = this.redDotFunc.GetStringInParentheses(condition)
    value = tonumber(value)
    return value / 10000
end

---@param condition string
---@return boolean
conditionFunc[EConditionType.CheckUnusedAbility] = function(condition)
    local count = RoleManager.meData.roleExtInfo.remainAttrPoint
    local sign, lastIndex = this.redDotFunc.GetComparerSign(condition)
    local target = this.redDotFunc.GetTargetValue(condition, lastIndex)
    target = tonumber(target)
    return this.redDotFunc.Compare(count, sign, target)
end
---@param condition string
---@return boolean
conditionFunc[EConditionType.CheckUnreadMail] = function(condition)
    --local slotConfig = SlotManager.GetSlotConfigByIndex(SlotType.FunSlot, "UnreadEmailCount", 1)
    local count = 0
    for _, v in pairs(DataManager.mailInfo.mailTbl) do
        if v.state == 0 then
            count = count + 1
        end
    end
    local sign, lastIndex = this.redDotFunc.GetComparerSign(condition)
    local target = this.redDotFunc.GetTargetValue(condition, lastIndex)
    target = tonumber(target)
    return this.redDotFunc.Compare(count, sign, target)
end
---@param condition string
---@return boolean
conditionFunc[EConditionType.CheckFriendRequest] = function(condition)
    local count = DataManager.friendInfo.GetFriendApplyCount()
    local sign, lastIndex = this.redDotFunc.GetComparerSign(condition)
    local target = this.redDotFunc.GetTargetValue(condition, lastIndex)
    target = tonumber(target)
    return this.redDotFunc.Compare(count, sign, target)
end
---@param condition string
---@return boolean
conditionFunc[EConditionType.CheckUnreadMessage] = function(condition)
    local count = DataManager.chatInfo.GetUnreadMsgCount()
    local sign, lastIndex = this.redDotFunc.GetComparerSign(condition)
    local target = this.redDotFunc.GetTargetValue(condition, lastIndex)
    target = tonumber(target)
    return this.redDotFunc.Compare(count, sign, target)
end

---检测转装备是否可强化
conditionFunc[EConditionType.CheckEquipStrengthen] = function(condition)
    --return RoleManager.meData.equipInfo:CheckEquipStrength()
    local r = RedDotManager.GetCheckComparer(ERedCheckComparerType.CheckEquipStrength)
    if r == nil then
        r = RoleManager.meData.equipInfo:CheckEquipStrength()
        RedDotManager.SetCheckComparer(ERedCheckComparerType.CheckEquipStrength, r)
    end
    return r
end
---检测装备是否可追加
conditionFunc[EConditionType.CheckEquipAppends] = function(condition)
    --return RoleManager.meData.equipInfo:CheckEquipAppend()
    local r = RedDotManager.GetCheckComparer(ERedCheckComparerType.CheckEquipAppend)
    if r == nil then
        r = RoleManager.meData.equipInfo:CheckEquipAppend()
        RedDotManager.SetCheckComparer(ERedCheckComparerType.CheckEquipAppend, r)
    end
    return r
end
---检测装备是否可转移
conditionFunc[EConditionType.CheckEquipTransfer] = function(condition)
    local r = RedDotManager.GetCheckComparer(ERedCheckComparerType.CheckCanTrans)
    if r == nil then
        r = RoleManager.meData.equipInfo:CheckCanTrans()
        RedDotManager.SetCheckComparer(ERedCheckComparerType.CheckCanTrans, r)
    end
    return r
end

---检测装备是否可镶嵌宝石
conditionFunc[EConditionType.CheckEquipGem] = function(condition)
    local r = RedDotManager.GetCheckComparer(ERedCheckComparerType.CheckCanEquipGem)
    if r == nil then
        r = RoleManager.meData.equipInfo:CheckCanEquipGem()
        RedDotManager.SetCheckComparer(ERedCheckComparerType.CheckCanEquipGem, r)
    end
    return r
end
---检测技能是否可升级
conditionFunc[EConditionType.CheckSkillLevelUp] = function(condition)
    local r = RedDotManager.GetCheckComparer(ERedCheckComparerType.SKillIsConditionUpGarde)
    if r == nil then
        r = DataManager.muskillInfo.IsConditionUpGarde()
        RedDotManager.SetCheckComparer(ERedCheckComparerType.SKillIsConditionUpGarde, r)
    end
    return r
end

---检测会员是否可升级
conditionFunc[EConditionType.CheckVipLevelUp] = function(condition)
    return RoleManager.meDat
end
---检测可回收装备数量
conditionFunc[EConditionType.CheckRetrieve] = function(condition)
    local count = RoleManager.meData.equipInfo:GetRecycleCount()
    local sign, lastIndex = this.redDotFunc.GetComparerSign(condition)
    local target = this.redDotFunc.GetTargetValue(condition, lastIndex)
    target = tonumber(target)
    return this.redDotFunc.Compare(count, sign, target)
end

---检测职业等级
conditionFunc[EConditionType.CheckCareerRank] = function(condition)
    local count = RoleManager.meData.career.careerRank
    local sign, lastIndex = this.redDotFunc.GetComparerSign(condition)
    local target = this.redDotFunc.GetTargetValue(condition, lastIndex)
    target = tonumber(target)
    return this.redDotFunc.Compare(count, sign, target)
end

---检测玩家在地图中的时间
conditionFunc[EConditionType.CheckMapTime] = function(condition)
    local count = Time.time - LoginManager.enterMapTime
    local sign, lastIndex = this.redDotFunc.GetComparerSign(condition)
    local target = this.redDotFunc.GetTargetValue(condition, lastIndex)
    target = tonumber(target)
    return this.redDotFunc.Compare(count, sign, target)
end

---检测玩家血量比例
conditionFunc[EConditionType.CheckHP] = function(condition)
    local count = RoleManager.meData.Hp / RoleManager.meData.MaxHp
    local sign, lastIndex = this.redDotFunc.GetComparerSign(condition)
    local target = this.redDotFunc.GetTargetValue(condition, lastIndex)
    target = tonumber(target)
    target = target / 10000
    return this.redDotFunc.Compare(count, sign, target)
end

conditionFunc[EConditionType.checkMap] = function(condition)

    local targetValueStr = this.redDotFunc.GetStringInParentheses(condition)
    --return SL:MapLevelConditionCheck()
    local target = tonumber(string.sub(condition, #condition))
    if target == 0 then
        return not (Scene.mapConfig.id == tonumber(targetValueStr))
    else
        return Scene.mapConfig.id == tonumber(targetValueStr)
    end

end

---检测对比玩家等级和[世界等级-条件参数]
conditionFunc[EConditionType.CheckWorldLevel] = function(condition)
    local number = this.redDotFunc.GetStringInParentheses(condition)
    number = tonumber(number)
    local sign = this.redDotFunc.GetComparerSign(condition)
    local roleLevel = RoleManager.meData.Level
    local worldLevel = DataManager.worldLevel.worldLevel - number
    return this.redDotFunc.Compare(roleLevel, sign, worldLevel)
end

---检测套装所有装备equip_extraAtt_cost强化等级 CheckExtraAttSuitLevel[套装ID#附加属性分组#附加等级]=1
conditionFunc[EConditionType.CheckExtraAttSuitLevel] = function(condition)
    local targetValueStr = this.redDotFunc.GetStringInParentheses(condition)
    local targetValues = {}
    this.redDotFunc.SplitString(targetValueStr, "#", 1, targetValues)
    ---@type cfg_equip_suit_column

    this.redDotResult = targetValues

    local retCount = 0
    local suitItemId = ConfigManager.Get_cfg_equip_suit(tonumber(targetValues[1])).suitItemId
    for _, n in pairs(suitItemId) do
        local valueList = RoleManager.meData.equipInfo:GetWear380LevelListByCfgIdAndAttrType(n, tonumber(targetValues[2]))
        for _, value in pairs(valueList) do
            if this.redDotFunc.Compare(value, ">=", tonumber(targetValues[3])) then
                retCount = retCount + 1
            end
        end

    end
    if retCount == 7 then
        return true
    end
    return false
end

---检测身上指定部位（位置代码[itme表strPart字段id]）装备，只有要可强化（强化材料满足条件）的就return 1
conditionFunc[EConditionType.CheckExtraAttLevel] = function(condition)
    local targetValueStr = this.redDotFunc.GetStringInParentheses(condition)
    return RoleManager.meData.equipInfo.equip380Info:CheckExtraAttCanStrength(tonumber(targetValueStr))
end

local function GetIsNeedRed(condition)
    local sign, lastIndex = this.redDotFunc.GetComparerSign(condition)
    local target = this.redDotFunc.GetTargetValue(condition, lastIndex)
    return target == 1
end
---检测出战中的伙伴是否可以升级
conditionFunc[EConditionType.CheckPartnerUpgrade] = function(condition)
    if GetIsNeedRed(condition) then
        local funSlotConfig = SlotManager.GetSlotConfigByIndex(SlotType.FunSlot, "CheckPartnerUpgrade", 1)
        if funSlotConfig then
            return funSlotConfig:jumpFun()
        end
    else
        return false
    end
end

local function CheckIsShowRedByType(condition, slotName)
    if GetIsNeedRed(condition) then
        local funSlotConfig = SlotManager.GetSlotConfigByIndex(SlotType.FunSlot, slotName, 1)
        if funSlotConfig then
            return funSlotConfig:jumpFun()
        end
    else
        return false
    end
end

---检测出战中的伙伴是否可以洗髓
conditionFunc[EConditionType.CheckPartnerWashing] = function(condition)
    if GetIsNeedRed(condition) then
        local funSlotConfig = SlotManager.GetSlotConfigByIndex(SlotType.FunSlot, "CheckPartnerWashing", 1)
        if funSlotConfig then
            return funSlotConfig:jumpFun()
        end
    else
        return false
    end
end

conditionFunc[EConditionType.CheckPartnerArray] = function(condition)
    if GetIsNeedRed(condition) then
        local funSlotConfig = SlotManager.GetSlotConfigByIndex(SlotType.FunSlot, "CheckPartnerLineUp", 1)
        if funSlotConfig then
            return funSlotConfig:jumpFun()
        end
    else
        return false
    end
end

---检测任意玩家拥有的伙伴是否可以升星
conditionFunc[EConditionType.CheckPartnerUpstar] = function(condition)
    if GetIsNeedRed(condition) then
        local funSlotConfig = SlotManager.GetSlotConfigByIndex(SlotType.FunSlot, "CheckPartnerUpstar", 1)
        if funSlotConfig then
            return funSlotConfig:jumpFun()
        end
    else
        return false
    end
end

---检测升星所需的本体材料是否满足
local function CheckPartneroneself()

end

---检测升星所需的同阵营材料是否满足
local function CheckPartnercamp()

end

---检测升星所需的任意材料星级是否满足
local function CheckPartnerany()

end

---检测伙伴可洗髓的次数
local function CheckPartnerWashingtimes()

end

---检测伙伴可升级的次数
local function CheckPartnerUpgradetimes()

end

---检测伙伴是否达到洗髓上限
local function CheckPartnerWashinglimit()

end

---检测伙伴是否达到升级上限
local function CheckPartnerWUpgradelimit()

end

---检测孵化蛋是否可以开启
conditionFunc[EConditionType.CheckPartnerEgg] = function(condition)
    if GetIsNeedRed(condition) then
        local funSlotConfig = SlotManager.GetSlotConfigByIndex(SlotType.FunSlot, "CheckPartnerEgg", 1)
        if funSlotConfig then
            return funSlotConfig:jumpFun()
        end
    else
        return false
    end
end

---检测是否有免费招募次数
conditionFunc[EConditionType.CheckPartnerReffle] = function(condition)
    if GetIsNeedRed(condition) then
        local funSlotConfig = SlotManager.GetSlotConfigByIndex(SlotType.FunSlot, "CheckPartnerReffle", 1)
        if funSlotConfig then
            return funSlotConfig:jumpFun()
        end
    else
        return false
    end
end

---检测是否可以突破
conditionFunc[EConditionType.CheckPartnerBreak] = function(condition)
    if GetIsNeedRed(condition) then
        local funSlotConfig = SlotManager.GetSlotConfigByIndex(SlotType.FunSlot, "CheckPartnerBreak", 1)
        if funSlotConfig then
            return funSlotConfig:jumpFun()
        end
    else
        return false
    end
end

---检测是否可以免费刷新派遣任务
conditionFunc[EConditionType.CheckPartnerReffledispatch] = function(condition)
    if GetIsNeedRed(condition) then
        local funConfig = SlotManager.GetSlotConfigByIndex(SlotType.FunSlot, "CheckPartnerReffledispatch", 1)
        if funConfig then
            return funConfig:jumpFun()
        end
    else
        return false
    end
end
---检测自身是攻城方还是守城方
conditionFunc[EConditionType.CheckSiegeCamp] = function(condition)
    local sign, lastIndex = this.redDotFunc.GetComparerSign(condition)
    local target = this.redDotFunc.GetTargetValue(condition, lastIndex)

    --TODO 红点条件
    --0 判断自身是否为守城方
    if target == 0 then
        --local  me = RoleManager.meData.

        --1 判断自身是否为攻城方
    elseif target == 1 then

    end
end

---检测时装是否满足激活
conditionFunc[EConditionType.CheckFashionActivation] = function(condition)

end
---检测是否获取新称号
conditionFunc[EConditionType.CheckNewTitle] = function(condition)
    local sign, lastIndex = this.redDotFunc.GetComparerSign(condition)
    local target = this.redDotFunc.GetTargetValue(condition, lastIndex)

end

---检测玩家是否购买对应的礼包
conditionFunc[EConditionType.CheckSponsorShip] = function(condition)
    local targetValueStr = this.redDotFunc.GetStringInParentheses(condition)
    local targetValues = {}
    this.redDotFunc.SplitString(targetValueStr, "#", 1, targetValues)

    local welfares = RoleManager.meData.roleExtInfo.alreadyBuyWelfare
    local alreadyBuyWelfare = {}
    for m, v in pairs(welfares) do
        table.insert(alreadyBuyWelfare, tonumber(v))
    end

    for k, v in pairs(targetValues) do
        if not table.contains(alreadyBuyWelfare, tonumber(v)) then
            return false
        end
    end
    return true
end

-----检测是否完成成就任务
conditionFunc[EConditionType.CheckAchievementTask] = function(condition)
    local sign, lastIndex = this.redDotFunc.GetComparerSign(condition)
    local target = this.redDotFunc.GetTargetValue(condition, lastIndex)
    if target == 0 then
        return not this.HasFinishTask()
    elseif target == 1 then
        return this.HasFinishTask()
    end
end

---检测战阶经验是否满足升级经验
conditionFunc[EConditionType.CheckAchievementLevelExp] = function(condition)
    local sign, lastIndex = this.redDotFunc.GetComparerSign(condition)
    local target = this.redDotFunc.GetTargetValue(condition, lastIndex)
    if target == 0 then
        return not this.CanUpWarStage()
    elseif target == 1 then
        return this.CanUpWarStage()
    end
end

-----检测效率指定类型任务是否完成
conditionFunc[EConditionType.CheckEfficiencyTask] = function(condition)
    local targetValueStr = this.redDotFunc.GetStringInParentheses(condition)

end

---检测守护装备是否可以进阶
conditionFunc[EConditionType.CheckGuardstage] = function(condition)
    local targetValueStr = this.redDotFunc.GetStringInParentheses(condition)
    local targetValues = {}
    this.redDotFunc.SplitString(targetValueStr, "#", 1, targetValues)

    return RoleManager.meData.equipInfo.equipGuardInfo:CheckGuardCanUp(tonumber(targetValues[1]))
end

conditionFunc[EConditionType.CheckEquipWearingBar] = function(condition)
    local targetValueStr = this.redDotFunc.GetStringInParentheses(condition)
    local targetValues = {}
    this.redDotFunc.SplitString(targetValueStr, "#", 1, targetValues)

    return table.count(RoleManager.meData.bagInfo:GetSpecialWearBarEquipInBag(tonumber(targetValues[1]))) > 0 or
            table.count(RoleManager.meData.equipInfo:GetEquipListByWearBar(tonumber(targetValues[1]))) > 0
end

conditionFunc[EConditionType.CheckItemMail] = function(condition)
    for _, v in pairs(DataManager.mailInfo.mailTbl) do
        if v.state ~= 2 and table.count(v.items) > 0 then
            return true
        end
    end
    return false
end

conditionFunc[EConditionType.CheckFirstRechargep] = function(condition)

end

conditionFunc[EConditionType.CheckConductTask] = function(condition)
    local targetValueStr = this.redDotFunc.GetStringInParentheses(condition)
    return DataManager.taskInfo:GetIsInTask(tonumber(targetValueStr))
end

conditionFunc[EConditionType.checkTaskProgress] = function(condition)
    local targetValueStr = this.redDotFunc.GetStringInParentheses(condition)
    return DataManager.taskInfo:GetIsFinishTask(tonumber(targetValueStr))
end

---检测赞助是否激活
conditionFunc[EConditionType.CheckSponsorActive] = function(condition)

end
---检测赞助是否激活
conditionFunc[EConditionType.CheckSponsorLevel] = function(condition)
    return false
end
---检测守护装备是否可以觉醒
conditionFunc[EConditionType.CheckGuardawaken] = function(condition)
    local targetValueStr = this.redDotFunc.GetStringInParentheses(condition)
    local targetValues = {}
    this.redDotFunc.SplitString(targetValueStr, "#", 1, targetValues)
    return RoleManager.meData.equipInfo.equipGuardInfo:CheckGuardCanAwake(tonumber(targetValues[1]))
end

---检测装备是否可以激活卓越属性
conditionFunc[EConditionType.CheckequipActivation] = function(condition)
    local targetValueStr = this.redDotFunc.GetStringInParentheses(condition)
    local targetValues = {}
    this.redDotFunc.SplitString(targetValueStr, "#", 1, targetValues)
    if tonumber(targetValues[1]) == 1 then
        return RoleManager.meData.equipInfo.equipStrengthInfo:GetHaveEquipCanActiveEntryAttr()
    end
    return RoleManager.meData.equipInfo.equipStrengthInfo:GetEquipCanActiveEntryAttr(tonumber(targetValues[2]))
end


--检测按钮是否首次开启
conditionFunc[EConditionType.CheckButtonFirstOpen] = function(condition)
    --TODO 0419
    --local targetValueStr = this.redDotFunc.GetStringInParentheses(condition)
    local value = PlayerPrefs.GetInt(RoleManager.meData.id .. "isShowUnion", 0)
    return value == 0
end
--检测是否收到战盟审核信息
conditionFunc[EConditionType.CheckAuditInf] = function(condition)
    --local targetValueStr = this.redDotFunc.GetStringInParentheses(condition)

    --if tonumber(targetValue) == 1 then
    --    return DataManager.unionInfo:IsUnionCheckRedDot()
    --else
    --    return not DataManager.unionInfo:IsUnionCheckRedDot()
    --end
    return DataManager.unionInfo:IsUnionCheckRedDot()
end
--检测战盟臂章是否可以升级
conditionFunc[EConditionType.CheckGardarmbands] = function(condition)
    --local targetValueStr = this.redDotFunc.GetStringInParentheses(condition)
    --if tonumber(targetValue) == 1 then
    --    return DataManager.armBandInfo:CheckGardarmbands()
    --else
    --    return not DataManager.armBandInfo:CheckGardarmbands()
    --end
    return DataManager.armBandInfo:CheckGardarmbands()
end

--检测是否有可领取的战盟任务奖励
conditionFunc[EConditionType.CheckGardTaskreward] = function(condition)
    --local targetValueStr = this.redDotFunc.GetStringInParentheses(condition)

    --if tonumber(targetValue) == 1 then
    --    return DataManager.armBandInfo:CheckGardTaskReward()
    --else
    --    return not DataManager.armBandInfo:CheckGardTaskReward()
    --end
    return DataManager.armBandInfo:CheckGardTaskReward()
end
--检测是否有可领取的战盟工资
conditionFunc[EConditionType.CheckGardsalary] = function(condition)
    --TODO 0419
    --local targetValueStr = this.redDotFunc.GetStringInParentheses(condition)

    return DataManager.unionInfo:IsGetUnionSalaryRedDot()
end

--检测是否满足激活强化大师
conditionFunc[EConditionType.CheckStrengthenMaster] = function(condition)
    local targetValue = this.redDotFunc.GetTargetValueByCondition(condition)

    if tonumber(targetValue) == 1 then
        return RoleManager.meData.masterInfo:CheckStrengthMasterCanActive()
    else
        return not RoleManager.meData.masterInfo:CheckStrengthMasterCanActive()
    end
end
--检测是否满足激活追加大师
conditionFunc[EConditionType.CheckAppendMaster] = function(condition)
    local targetValue = this.redDotFunc.GetTargetValueByCondition(condition)

    if tonumber(targetValue) == 1 then
        return RoleManager.meData.masterInfo:CheckAppendMasterCanActive()
    else
        return not RoleManager.meData.masterInfo:CheckAppendMasterCanActive()
    end
end
--检测是否满足激活星级大师
conditionFunc[EConditionType.CheckStarMaster] = function(condition)
    local targetValue = this.redDotFunc.GetTargetValueByCondition(condition)

    if tonumber(targetValue) == 1 then
        return RoleManager.meData.masterInfo:CheckStarMasterCanActive()
    else
        return not RoleManager.meData.masterInfo:CheckStarMasterCanActive()
    end
end
--检测指定装备部位是否可强化
conditionFunc[EConditionType.CheckEquipAreaStrengthen] = function(condition)
    local targetValueStr = this.redDotFunc.GetStringInParentheses(condition)
    local targetValue = this.redDotFunc.GetTargetValueByCondition(condition)

    if tonumber(targetValue) == 1 then
        return RoleManager.meData.equipInfo.equipStrengthInfo:GetEquipCanStrength(tonumber(targetValueStr))
    else
        return not RoleManager.meData.equipInfo.equipStrengthInfo:GetEquipCanStrength(tonumber(targetValueStr))
    end
end
--检测指定装备部位是否可追加
conditionFunc[EConditionType.CheckEquipAreaAppends] = function(condition)
    local targetValueStr = this.redDotFunc.GetStringInParentheses(condition)
    local targetValue = this.redDotFunc.GetTargetValueByCondition(condition)

    if tonumber(targetValue) == 1 then
        return RoleManager.meData.equipInfo.equipStrengthInfo:GetEquipCanAppend(tonumber(targetValueStr))
    else
        return not RoleManager.meData.equipInfo.equipStrengthInfo:GetEquipCanAppend(tonumber(targetValueStr))
    end
end

--检测天赋是否可升级
conditionFunc[EConditionType.CheckGiftLevelUp] = function(condition)
    return false
end

--检测首充礼包是否可领取
conditionFunc[EConditionType.CheckFirstChargeCanGetReward] = function(condition)
    return DataManager.firstChargeInfo:GetFirstChargeRedDot()
end

--检测首充礼包对应天数是否可领取
conditionFunc[EConditionType.CheckFirstChargeDay] = function(condition)
    local targetValueStr = this.redDotFunc.GetStringInParentheses(condition)
    return DataManager.firstChargeInfo:GetFirstChargeRedDotState(tonumber(targetValueStr))
end

--检测每日礼包对应天数是否可领取
conditionFunc[EConditionType.CheckRechargeDaily] = function(condition)
    return DataManager.dailyGiftInfo:IsHasDailyAward()
end

--检测角色指定掉落包终生总计掉落次数
conditionFunc[EConditionType.CheckPropDropTime] = function(condition)
    ---TODO

    return false
end

---vip礼包是否可领取
conditionFunc[EConditionType.CheckVIPGiftPackClaimable] = function()
    return this.IsVIPGiftPackClaimable()
end

conditionFunc[EConditionType.CheckLogOn] = function(condition)
    if GetIsNeedRed(condition) then
        if DataManager.pinkDiamondInfo:IsActivePinkDiamondActivity() then
            local value = PlayerPrefs.GetInt(RoleManager.meData.id .. "CheckClickPinkDiamond", 0)
            return value == 0
        end
        return false
    else
        return false
    end
end

local function CheckActivityExchange(condition)
    if GetIsNeedRed(condition) then

    else
        return false
    end
end

---@param condition string
---@return boolean
conditionFunc[EConditionType.CheckWearItem] = function(condition)
    --logError("ItemWearComparer>>>>>>>>>>>>>>>>>>>>>>>>qiji5")
    local itemId = this.redDotFunc.GetStringInParentheses(condition)
    local count = 0
    local equipTbl = RoleManager.meData.equipInfo.equips
    for k, v in pairs(equipTbl) do
        for _, itemInfo in pairs(v) do
            if itemInfo.cfgId == tonumber(itemId) then
                count = count + 1
            end
        end
    end
    local sign, lastIndex = this.redDotFunc.GetComparerSign(condition)
    local targetCount = this.redDotFunc.GetTargetValue(condition, lastIndex)
    targetCount = tonumber(targetCount)
    return this.redDotFunc.Compare(count, sign, targetCount)
end
---@param condition string
---@return boolean
conditionFunc[EConditionType.CheckItems] = function(condition)
    --logError("ItemsComparer>>>>>>>>>>>>>>>>>>>>>>>>qiji5")
    local itemId = tonumber(this.redDotFunc.GetStringInParentheses(condition))
    local count = RoleManager.meData.bagInfo:GetItemCount(itemId)
    --local haveInBag = RoleManager.meData.bagInfo:IsHaveCfgIdItem(itemId)
    --if haveInBag then
    --    count = count + RoleManager.meData.bagInfo:GetItemCount(itemId)
    --end
    local equips = RoleManager.meData.equipInfo.equips
    for k, v in pairs(equips) do
        if v == itemId then
            count = count + 1
        end
    end
    local sign, lastIndex = this.redDotFunc.GetComparerSign(condition)
    local targetValue = this.redDotFunc.GetTargetValue(condition, lastIndex)
    targetValue = tonumber(targetValue)
    return this.redDotFunc.Compare(count, sign, targetValue)
end

---e
conditionFunc[EConditionType.CheckGoldTask] = function()
    return false
end


---[参数1=时间下限#参数2=时间上限]；检测玩家是否处于离线挂机状态的时间区间；例如：checkMultipleTime[5#10]=1，表示检测玩家是否处于离线挂机状态的第5-10秒之间
--local function CheckMultipleTime(condition)
--    local targetValueStr = this.redDotFunc.GetStringInParentheses(condition)
--    local targetValues = {}
--    this.redDotFunc.SplitString(targetValueStr, "#", 1, targetValues)
--    --等待多倍挂机提供真实数据接口
--    
--    
--    
--    return false
--end


---@param condition string
---@param return number
local function GetSignIndex(condition)
    local firstIndex, lastIndex = nil, nil
    if string.find(condition, ">", 1) then
        firstIndex, lastIndex = string.find(condition, ">", 1)

    elseif string.find(condition, "<", 1) then
        firstIndex, lastIndex = string.find(condition, "<", 1)

    elseif string.find(condition, "=", 1) then
        firstIndex, lastIndex = string.find(condition, "=", 1)

    elseif string.find(condition, "%[", 1) then
        firstIndex, lastIndex = string.find(condition, "%[", 1)
    end
    return firstIndex
end

---@param type EConditionType
---@param condition  string
---@return  boolean
local function CalculateSingleState(condition)
    local state = true
    local temp = false
    local errorMsg = ""
    local typeLastIndex = GetSignIndex(condition)

    local tp = nil
    if typeLastIndex == nil then
        return
    end
    local lastIndex = string.find(condition, "%[", 1)
    if lastIndex then
        tp = string.sub(condition, 1, lastIndex - 1)
    else
        tp = string.sub(condition, 1, typeLastIndex - 1)
    end

    if not this.typeToconditions then
        this.typeToconditions = {}
        --local tt = ConfigManager.GetConfigTable("cfg_conditions")
        if tt then
            for k, v in pairs(tt) do
                if v.conditionType == tp then
                    this.typeToconditions[v.conditionType] = v
                end
            end
        end
    end
    if this.typeToconditions[tp] then
        this.redDotResult.fieldName = this.typeToconditions[tp].name
    end

    local condFunc = conditionFunc[tp]
    if condFunc then
        temp, errorMsg = condFunc(condition)
    else
        local conditionTbl = this.moduleRedConditionFunc[tp]
        if conditionTbl then
            local func = conditionTbl[1]
            local base = conditionTbl[2]
            local args = conditionTbl[3]
            temp = func(base, condition, args)
        end
    end
    state = state and temp
    return state, errorMsg
end

---@param tbl table
---@return boolean
local function GetResult(tbl)
    local signs = tbl.signs
    local condition = tbl.condition
    local isLoop = false
    local signIndex = 1
    local condIndex = 1
    local result = false
    local errorMsg
    result, errorMsg = CalculateSingleState(condition[condIndex])
    condIndex = condIndex + 1
    if #signs > 0 and signs then
        repeat
            if signs[signIndex] == "&" then
                result = result and CalculateSingleState(condition[condIndex])
            elseif signs[signIndex] == "|" then
                result = result or CalculateSingleState(condition[condIndex])
            end
            signIndex = signIndex + 1
            condIndex = condIndex + 1
            if signIndex > #signs or condIndex > #condition then
                isLoop = true
            end
        until isLoop
    end
    return result, errorMsg
end

---@param cond string
---@return table
local function AnalyzingBracket(cond)
    if not this.AnalyzingBracketCond then
        this.AnalyzingBracketCond = {}
    end
    if this.AnalyzingBracketCond[cond] then
        local tbl = this.AnalyzingBracketCond[cond]
        tbl.result = false
        local isFindSign = string.find(cond, "%(")
        if not isFindSign then
            tbl.result, tbl.errorMsg = GetResult(tbl)
        else
            for i = 1, #tbl.condition do
                tbl.childs[i] = AnalyzingBracket(tbl.condition[i], tbl)
            end
            local result = tbl.childs[1] .result
            local childIndex = 2
            for i = 1, #tbl.signs do
                if tbl.signs[i] == "&" then
                    result = result and tbl.childs[childIndex].result
                elseif tbl.signs[i] == "|" then
                    result = result or tbl.childs[childIndex].result
                end
                childIndex = childIndex + 1
            end
            tbl.result = result
        end
        return tbl
    else
        local tbl = {}
        tbl.condition = {}
        tbl.signs = {}
        tbl.childs = {}
        tbl.result = false
        local isFindSign = string.find(cond, "%(")
        if not isFindSign then
            local signV = this.redDotFunc.FindAllIndex(cond, "|")
            local signH = this.redDotFunc.FindAllIndex(cond, "&")
            local allSigns = this.redDotFunc.BlendTable(signV, signH)
            table.sort(allSigns)
            for i = 1, #allSigns do
                local sign = string.sub(cond, allSigns[i], allSigns[i])
                tbl.signs[i] = sign
            end
            local index = 1
            for i = 1, #allSigns do
                local condi = string.sub(cond, index, allSigns[i] - 1)
                index = allSigns[i] + 1
                tbl.condition[i] = condi
            end
            local condi = string.sub(cond, index)
            local count = #tbl.condition
            tbl.condition[count + 1] = condi
            tbl.result = GetResult(tbl)
        else
            local leftBracket = this.redDotFunc.FindAllIndex(cond, "(")
            local rightBracket = this.redDotFunc.FindAllIndex(cond, ")")
            local BracketPairs = this.redDotFunc.FindAllBracketPair(leftBracket, rightBracket)
            tbl = CreateConditionTree(BracketPairs, cond)
            for i = 1, #tbl.condition do
                tbl.childs[i] = AnalyzingBracket(tbl.condition[i], tbl)
            end
            local result = tbl.childs[1] .result
            local childIndex = 2
            for i = 1, #tbl.signs do
                if tbl.signs[i] == "&" then
                    result = result and tbl.childs[childIndex].result
                elseif tbl.signs[i] == "|" then
                    result = result or tbl.childs[childIndex].result
                end
                childIndex = childIndex + 1
            end
            tbl.result = result
        end
        this.AnalyzingBracketCond[cond] = tbl
        return tbl
    end
end
---@param allPairs table
---@param conditions string
---@param table
local function CreateConditionTree(allPairs, conditions)
    local tbl = {}
    tbl.condition = {}
    tbl.signs = {}
    tbl.childs = {}
    tbl.result = false
    local tblIndex = 1
    local isRepeat = false
    local sIndex = 1
    local strIndex = 1
    repeat
        if sIndex > #conditions then
            isRepeat = true
        else
            local index = string.find(conditions, "%(", sIndex)
            if index then
                local subStr = string.sub(conditions, strIndex, index - 1)
                local signTblV = this.redDotFunc.FindAllIndex(subStr, "|")
                local signTblH = this.redDotFunc.FindAllIndex(subStr, "&")
                local signTbl = this.redDotFunc.BlendTable(signTblV, signTblH)
                table.sort(signTbl)
                local splitIndex = 1
                local count = #tbl.signs + 1
                for i = 1, #signTbl do
                    local sign = string.sub(subStr, signTbl[i], signTbl[i])
                    tbl.signs[count] = sign
                    count = count + 1
                end
                for i = 1, #signTbl do
                    local st = string.sub(subStr, splitIndex, signTbl[i] - 1)
                    tbl.condition[tblIndex] = st
                    tblIndex = tblIndex + 1
                    splitIndex = signTbl[i] + 1
                end
                local pair = {}
                pair.left = nil
                pair.right = nil
                for i = 1, #allPairs do
                    if allPairs[i].left == index then
                        pair .left = index
                        pair .right = allPairs[i].right
                    end
                end
                st = string.sub(conditions, pair.left + 1, pair.right - 1)
                tbl.condition[tblIndex] = st
                local index = pair.right + 1
                if index < #conditions then
                    local lastSign = string.sub(conditions, index, index)
                    local count = #tbl.signs + 1
                    tbl.signs[count] = lastSign
                end
                tblIndex = tblIndex + 1
                sIndex = pair.right + 2
                strIndex = pair.right + 2
            else
                if sIndex < #conditions then
                    local subStr = string.sub(conditions, sIndex, #conditions)
                    local signTblV = this.redDotFunc.FindAllIndex(subStr, "|")
                    local signTblH = this.redDotFunc.FindAllIndex(subStr, "&")
                    local signTbl = this.redDotFunc.BlendTable(signTblV, signTblH)
                    table.sort(signTbl)
                    local count = #tbl.signs + 1
                    for i = 1, #signTbl do
                        local sign = string.sub(subStr, signTbl[i], signTbl[i])
                        tbl.signs[count] = sign
                        count = count + 1
                    end
                    local splitIndex = 1
                    for i = 1, #signTbl do
                        local st = string.sub(subStr, splitIndex, signTbl[i] - 1)
                        tbl.condition[tblIndex] = st
                        tblIndex = tblIndex + 1
                        splitIndex = signTbl[i] + 1
                    end
                    local st = string.sub(subStr, splitIndex, #subStr)
                    tbl.condition[tblIndex] = st
                    tblIndex = tblIndex + 1
                end
                isRepeat = true
            end
        end
    until isRepeat
    return tbl
end

---计算条件组合的返回结果
---@param conditions string @条件组合 示例 CheckLevel>=90&(CheckJob=1|CheckJob=2)
---@return boolean @条件组合是否达到条件
function this.CalculateConditionGroup(conditions)
    if not RoleManager or not RoleManager.meData then
        return false
    end
    if string.isNullOrEmpty(conditions) then
        return true
    end
    if not this.sameFrameConditions then
        this.sameFrameConditions = {}
    end
    local cache = this.sameFrameConditions[conditions]
    if not cache then
        cache = {}
        cache.frameCount = 0
        this.sameFrameConditions[conditions] = cache
    end

    if cache.frameCount == Time.frameCount then
        return cache.result, cache.redDotResult, cache.tbl
    end
    local tblL = {}
    tblL = this.redDotFunc.FindAllIndex(conditions, "(")
    local tblR = {}
    tblR = this.redDotFunc.FindAllIndex(conditions, ")")
    local allPairs = {}
    allPairs = this.redDotFunc.FindAllBracketPair(tblL, tblR)
    local tbl = CreateConditionTree(allPairs, conditions)
    for i = 1, #tbl.condition do
        tbl.childs[i] = AnalyzingBracket(tbl.condition[i], tbl)
    end
    local result = tbl.childs[1].result
    local index = 2
    for i = 1, #tbl.signs do
        if tbl.signs[i] == "&" then
            if tbl.childs[index] ~= nil then
                result = result and tbl.childs[index].result
            end
        elseif tbl.signs[i] == "|" then
            if tbl.childs[index] ~= nil then
                result = result or tbl.childs[index].result
            end
        end
        index = index + 1
    end
    cache.frameCount = Time.frameCount
    cache.result = result
    cache.redDotResult = this.redDotResult
    cache.tbl = tbl
    return result, this.redDotResult, tbl
end

---解析XXXX[套装ID#附加属性分组#附加等级]=1类型的条件，以数组形式返回中括号中的数据
function this.GetInfoBetweenBraces(condition)

    if string.isNullOrEmpty(condition) then
        return
    end

    local targetValueStr = this.redDotFunc.GetStringInParentheses(condition)
    local targetValues = {}
    this.redDotFunc.SplitString(targetValueStr, "#", 1, targetValues)
    return targetValues
end
---@param conditionType EConditionType
---@param condFunc function
function this.RegisterConditionFunc(conditionType, condFunc, base, args)
    if not condFunc then
        return
    end
    if not this.moduleRedConditionFunc[conditionType] then
        this.moduleRedConditionFunc[conditionType] = {}
    end
    this.moduleRedConditionFunc[conditionType][1] = condFunc
    this.moduleRedConditionFunc[conditionType][2] = base
    this.moduleRedConditionFunc[conditionType][3] = args
end

----@param id string @表数据 condition
--- @return boolean @是否满足 
function this.CheckRedPointId(id)
    local keys = cfg_redDot_new_post.GetCfgById(id).tCondStr
    local conditions = cfg_redDot_new_post.GetCfgById(id).cfg.condition
    conditions = string.split(conditions, ",")
    if keys and #keys > 0 then
        local isSatisfy = false
        ---有可能多个条件，一个不满足直接返回
        for k, v in pairs(keys) do
            if conditionFunc[v] then
                isSatisfy = conditionFunc[v](conditions[k])
                if not isSatisfy then
                    return false
                end
            end
        end
        return isSatisfy
    end
    return false
end

----@param condition string @根据条件刷新
----@param callBack function @根据条件刷新
function this.AddRedDotConditionFunc(condition, callBack)
    if conditionFunc then
        conditionFunc[condition] = callBack
    end
end 