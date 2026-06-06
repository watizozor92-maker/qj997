---@class Utility @公共函数
Utility = class()
local this = Utility

function this.IsNilOrEmptyString(str)
    return type(str) ~= 'string' or str == nil or #str == 0
end

----table operations
---@param tbl table
---@return number lua的table中的键值对数量
function this.GetLuaTableCount(tbl)
    local count = 0
    if (tbl) then
        for k, v in pairs(tbl) do
            count = count + 1
        end
    end
    return count
end

function this.IsNullTable(tbl)
    if (tbl and type(tbl) == 'table') then
        for k, v in pairs(tbl) do
            return false
        end
    end
    return true
end

function this.IsContainsKey(tbl, key)
    if this.IsNullTable(tbl) then
        return false
    end
    return tbl[key] ~= nil
end

function this.IsContainsValue(tbl, value)
    if this.IsNullTable(tbl) then
        return false
    end
    for k, v in pairs(tbl) do
        if v == value then
            return true
        end
    end
    return false
end

---移除对应value
---@return boolean 是否成功移除
function this.RemoveTableValue(tbl, value)
    if this.IsNullTable(tbl) then
        return false
    end
    for k, v in pairs(tbl) do
        if v == value then
            table.remove(tbl, k)
            return true
        end
    end
    return false
end

---不考虑元表,返回表中是否有该键
---@param tbl table 待检测的表
---@param key any 待检测的键
---@return boolean 表中是否包含了该键
function this.IsTruelyContainsKey(tbl, key)
    if tbl == nil or type(tbl) ~= "table" or key == nil then
        return false
    end
    return rawget(tbl, key) ~= nil
end

---获取表内第一个数据
---@param tbl table 表数据
---@return any 表的第一个value
function this.GetTableFirstValue(tbl)
    if tbl ~= nil and type(tbl) == 'table' then
        for k, v in pairs(tbl) do
            return v
        end
    end
end

---清空table
---@param tbl table 需要清空的table
function this.ClearTable(tbl)
    if tbl then
        for i, v in pairs(tbl) do
            tbl[i] = nil
        end
    end
end


---获取子物体
---@param parent UnityEngine.Transform
---@param name string
---@return UnityEngine.Transform 位置 
function this.FindChildren(parent, name, isNotAbnormal)
    if parent then
        local objs = parent.gameObject:GetComponentsInChildren(typeof(CS.UnityEngine.Transform))
        if objs then
            for i = 0, objs.Length - 1 do
                if objs[i].name == name then
                    return objs[i]
                end
            end
        end
        if not isNotAbnormal then
            logError("查找失败")
        end
    end
end

---获取数字的个，十，百，位
function this.GetNumberBit(number)
    local numberBit = {}
    table.insert(numberBit, number % 10)
    table.insert(numberBit, math.floor(number / 10))
    table.insert(numberBit, math.floor(number / 100))
    return numberBit
end
---格式化时间--(10小时22分20秒)
function this.FormatTime(time)
    time = time // 1000
    local s = string.format("%02s", time % 60)
    local m = string.format("%02s", time // 60 % 60)
    local h = string.format("%02s", time // 3600 % 24)
    local timeStr = ""
    if tonumber(h) ~= 0 then
        timeStr = h .. "时"
    end
    if tonumber(m) ~= 0 then
        timeStr = m .. "分"
    end
    timeStr = timeStr .. s .. "秒"
    return timeStr
end

---获取服务器开服自然天数(如果没有获取到服务器开服时间则返回-1)
function this.GetServerOpenDays()
    if LoginManager == nil or LoginManager.EnterRoleRes == nil then
        return -1
    end
    local defTime = Time.GetServerTime() - LoginManager.EnterRoleRes.openServerTime + LoginManager.millisecond
    if defTime > 0 then
        local day = math.ceil(defTime / 86400000)
        return day
    end
    return -1
end

---获取宝石品质底图（策划说不用配表的方式，直接写死）
---@param gemCfgId number
function this.GetGemQualitySpriteName(gemCfgId, isCircle)
    local atlasName = "UIGemBottom"
    local spriteName = "icon_bottom_rarity0"
    ---@type cfg_gem_column
    --local gemCfg = ConfigManager.Get_cfg_gem(gemCfgId)
    if not gemCfg then
        return
    end
    if gemCfg.gemSubType == 1 then
        if isCircle then
            spriteName = "icon_circle_rarity0"
        else
            spriteName = "icon_bottom_rarity0"
        end
    elseif gemCfg.gemSubType == 2 then
        if isCircle then
            spriteName = "icon_circle_rarity1"
        else
            spriteName = "icon_bottom_rarity1"
        end
    elseif gemCfg.gemSubType == 3 then
        if isCircle then
            spriteName = "icon_circle_rarity2"
        else
            spriteName = "icon_bottom_rarity2"
        end
    elseif gemCfg.gemSubType == 4 then
        if isCircle then
            spriteName = "icon_circle_rarity3"
        else
            spriteName = "icon_bottom_rarity3"
        end
    elseif gemCfg.gemSubType == 5 then
        if isCircle then
            spriteName = "icon_circle_rarity4"
        else
            spriteName = "icon_bottom_rarity4"
        end
    end
    return atlasName, spriteName
end

---设置角色头像
---@param panel  UIControl
---@param career string  @职业id
---@param imageCtrl UIControl @控件
function this.SetHeadPortrait(panel, career, imageCtrl)
    if career then
        panel:SetSprite("MUIcon", "1" .. career, imageCtrl)
    else
        panel:SetSprite("MUIcon", "11", imageCtrl)
    end
end



---格式化数据
function this.FormatNumber(count, integer_bit_notZero, isReplace_chinese_character)
    if not integer_bit_notZero then
        local str = count
        count = tonumber(count)
        if count >= 100000 and count < 10000000 then
            local num = string.format("%0.1f", count / 10000)
            str = num .. (isReplace_chinese_character and "w" or "万")
        elseif count > 10000000 then
            local num = string.format("%0.1f", count / 100000000)
            str = num .. (isReplace_chinese_character and "y" or "亿")
        end
        return str
    else
        local str = count
        if count >= 10000 and count < 100000000 then
            local num = string.format("%0.1f", count / 10000)
            if tonumber(num) == math.floor(num) then
                num = math.floor(num)
            end
            str = num .. (isReplace_chinese_character and "w" or "万")
        elseif count >= 100000000 then
            local num = tonumber(string.format("%0.1f", count / 100000000))
            if num < 10000 then
                str = (isReplace_chinese_character and "y" or "亿")
            elseif num >= 10000 and num < 100000000 then
                num = string.format("%0.1f", num / 10000)
                str = (isReplace_chinese_character and "z" or "兆")
            elseif num >= 100000000 then
                num = string.format("%0.1f", num / 100000000)
                str = (isReplace_chinese_character and "j" or "京")
            end
            if tonumber(num) == math.floor(num) then
                num = math.floor(num)
            end
            str = num .. str
        end
        return str
    end
end



---@param AIConfig cfg_partner_AI_column
---@param isNotHeadIcon boolean @是否不是头像
function this.GetModelPosAndScale(uiParent, AIConfig, isNotHeadIcon)
    local x, y = uiParent.transform:GetRectSize()

    local partnerModelScale = { 1, 1, 1 }
    local partnerModelPos = { 0, 0, 0 }
    if isNotHeadIcon then
        partnerModelScale = { AIConfig.scaleUI[1], AIConfig.scaleUI[2], AIConfig.scaleUI[3] }
        partnerModelPos = { AIConfig.posUI[1], AIConfig.posUI[2], AIConfig.posUI[3] }
    else
        partnerModelScale = { AIConfig.scale[1], AIConfig.scale[2], AIConfig.scale[3] }
        partnerModelPos = { AIConfig.pos[1], AIConfig.pos[2], AIConfig.pos[3] }
    end

    local scaleRatio = y / 100
    if x / 100 < y / 100 then
        scaleRatio = x / 100
    end
    partnerModelPos[2] = partnerModelPos[2] * y / 100
    partnerModelScale[1] = partnerModelScale[1] * scaleRatio
    partnerModelScale[2] = partnerModelScale[2] * scaleRatio
    partnerModelScale[3] = partnerModelScale[3] * scaleRatio

    return partnerModelPos, partnerModelScale
end
----@param srcDot Dot2
---@param searchRange number
function this.FindNearCanMovePoint(srcDot,searchRange)
    local dot = Dot2.New(srcDot.x,srcDot.z)
    for i = 1, searchRange do
        local targetDot = this.FindNearPoint(dot,i)
        if targetDot then
            return targetDot
        end
    end
    return dot 
end
----@param dctDot Dot2
---@param searchRange number
function this.FindNearPoint(dctDot,searchRange)
    for x = -searchRange, searchRange do
        for z = -searchRange, searchRange do
            if not CellManager.IsObstacle(dctDot.x+x,dctDot.z+z) then
                dctDot.x = dctDot.x + x
                dctDot.z = dctDot.z + z
                return dctDot
            end
        end
    end
end

local tempDot = Dot2.zero
local posDot = Dot2.zero
---@param skill Skill
----@param dot Dot2
----@param dctDot Dot2
---@param searchRange number
---@param stopCellCount number
function this.FindNearReleaseSkillPoint(skill,dot,dctDot,searchRange,stopCellCount)

    if dctDot.x == 0 and dctDot.z == 0 then
        posDot.x = dot.x
        posDot.z = dot.z
        return posDot
    end
    
    local minx = 0
    local minz = 0
    for x = -searchRange, searchRange do
        for z = -searchRange, searchRange do
            tempDot.x = x + dctDot.x
            tempDot.z = z + dctDot.z
            if Dot2.MaxDistance(tempDot,dot) > stopCellCount and not CellManager.IsObstacle(tempDot.x,tempDot.z) and skill:IsAttackRange(nil,dctDot,nil,tempDot) then
                local x1 = math.abs(dot.x-tempDot.x)
                local z1 = math.abs(dot.z-tempDot.z)
                local x2 = math.abs(dot.x-(dctDot.x +minx))
                local z2 = math.abs(dot.z-(dctDot.z +minz))
                if Mathf.Max(x1,z1) < Mathf.Max(x2,z2)  then
                    minx = x
                    minz = z
                end
            end
        end
    end
    
    posDot.x = dctDot.x + minx
    posDot.z = dctDot.z + minz

    return posDot
end

-- 判断UTF-8字符的字节长度
local function chsize(char)
    if not char then
        return 0
    elseif char > 240 then
        return 4
    elseif char > 225 then
        return 3
    elseif char > 192 then
        return 2
    else
        return 1
    end
end

-- 获取字符串的真实字符数量
function this.GetStringTotalIndex(str)
    local curIndex = 0
    local i = 1
    local lastCount = 1

    repeat
        lastCount = chsize(string.byte(str, i))
        i = i + lastCount
        curIndex = curIndex + 1
    until (lastCount == 0)

    return curIndex - 1
end

-- 将字符位置转换为字节位置
local function getTrueIndex(str, index)
    local curIndex = 0
    local i = 1
    local lastCount = 1

    repeat
        lastCount = chsize(string.byte(str, i))
        i = i + lastCount
        curIndex = curIndex + 1
    until (curIndex >= index)

    return i - lastCount
end

-- 截取UTF-8字符串的主函数
function this.SubStringUTF8(str, startIndex, endIndex)
    -- 处理负索引（从末尾开始）
    if startIndex < 0 then
        startIndex = this.GetStringTotalIndex(str) + startIndex + 1
    end

    if endIndex ~= nil and endIndex < 0 then
        endIndex = this.GetStringTotalIndex(str) + endIndex + 1
    end

    -- 执行截取
    if endIndex == nil then
        return string.sub(str, getTrueIndex(str, startIndex))
    else
        return string.sub(str, getTrueIndex(str, startIndex), getTrueIndex(str, endIndex + 1) - 1)
    end
end
