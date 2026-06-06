---@class ToolFunc
ToolFunc = {}
local this = ToolFunc

---通过和背包里面的数量对比，获取对应颜色的富文本，小于返回红色，大于返回绿色
---不传str，默认文本为 背包数量/count
function this.GetRichTextByComparison(cfgId, count, str)
	local hadCount = SL:GetBagItemCount(cfgId)
	local txt = str and str or (GUIUtil.GetNotCarrySampleNumberString(hadCount) .. "/" .. GUIUtil.GetNotCarrySampleNumberString(count))
	
	if hadCount >= count then
		return GUIUtil.GetColorText(txt, EColor[EGradColor.green]), EGradColor.green
	else
		return GUIUtil.GetColorText(txt, EColor[EGradColor.red]), EGradColor.red
	end
end

---解析类似字符""2#10040001#2000|3#10040001#3000"
---@param analysisSep @解析字符，默认为{"|","#"}
function this.AnalysisStr(input,isCancelTonumber,analysisSep,unit)
	local result = {}
	local analysisSep = analysisSep and analysisSep or {"|","#"}
	local entries = string.split(input, analysisSep[1])
	for _, entry in ipairs(entries) do
		if analysisSep[2] then
			local fields = string.split(entry, analysisSep[2])
			local outData = fields
			if not isCancelTonumber then
				outData = {}
				for i, v in ipairs(fields) do
					outData[i] = (unit and tonumber(v) / unit or tonumber(v))
				end
			end
			table.insert(result, outData)
		else
			if not isCancelTonumber then
				table.insert(result, (unit and tonumber(entry) / unit or tonumber(entry)))
			else
				table.insert(result, entry)
			end
		end
	end
	return result
end

---模糊匹配字符后面的数字，如input为tranf_132,str="-",则匹配132
---@param input string 输入字符
---@param analysisSep string 匹配的分割符,默认为"_"
function this.MatchStr(input,analysisSep)
    -- 如果input为空，则设为空字符串
    local input = input or ""
    -- 如果analysisSep未提供，默认使用"_"
    local separator = analysisSep or "_"
    
    -- 查找最后一个分隔符的位置
    local pos = 0
    local lastPos = 0
    while true do
        pos = string.find(input, separator, pos + 1, true)
        if not pos then break end
        lastPos = pos
    end
    
    if lastPos > 0 then
        -- 提取最后一个分隔符后的数字部分
        local numStr = string.sub(input, lastPos + 1)
        local num = tonumber(numStr)
        return num
    end
    
    return nil
end

---获取基础属性的展示数据
function this.GetBaseAttr(baseAttr)
	local baseAttrList = {}
	if not baseAttr then
		return baseAttrList
	end
	local max1
	local min1
	local max2
	local min2
	local max3
	local min3
	local max4
	local min4
	local max5
	local min5
	for i, v in pairs(baseAttr) do
		if v.type == 201011 then
			max1 = v
		elseif v.type == 201021 then
			min1 = v
		elseif v.type == 202011 then
			max2 = v
		elseif v.type == 202021 then
			min2 = v
		elseif v.type == 205021 then
			max3 = v
		elseif v.type == 205011 then
			min3 = v
		elseif v.type == 203021 then
			max4 = v
		elseif v.type == 203011 then
			min4 = v
		elseif v.type == 200011 then
			min5 = v
		elseif v.type == 200021 then
			max5 = v
		end
	end
	if max1 and min1 then
		local _value = min1.num .. "~" .. max1.num
		table.insert(baseAttrList, { name = "攻击力", value = _value })
	end
	if max2 and min2 then
		local _value = min2.num .. "~" .. max2.num
		table.insert(baseAttrList, { name = "魔法攻击力", value = _value })
	end
	if max3 and min3 then
		local _value = min3.num .. "~" .. max3.num
		table.insert(baseAttrList, { name = "诅咒攻击力", value = _value })
	end
	if max4 and min4 then
		local _value = min4.num .. "~" .. max4.num
		table.insert(baseAttrList, { name = "天鹰攻击力", value = _value })
	end
	if max5 and min5 then
		local _value = min5.num .. "~" .. max5.num
		table.insert(baseAttrList, { name = "攻击力", value = _value })
	end
	for i, v in pairs(baseAttr) do
		if v.type == 201011 or v.type == 201021 or v.type == 202011 or v.type == 202021 or v.type == 205021 or v.type == 205011 or v.type == 203021 or v.type == 203011 or v.type == 200011 or v.type == 200021 then
		else
			local cfg = SL:GetConfig("cfg_att_info", v.type)
			local _name = cfg.name
			local _value = EquipFunc.GetAttrValueText(cfg, v.num)
			if this.chenckAttrShow(v.type) then
				table.insert(baseAttrList, { name = _name, value = _value, type = v.type })
			end
		end
	end
	return baseAttrList
end

function this.chenckAttrShow(attId)
	local attShow = SL:GetConfig("cfg_att_info", attId).attShow
	if attShow == 1 then
		return true
	end
	return false
end

function this.IsCanUseExpMedicine(cfgId)
	---@type cfg_item_column
	local itemTbl = SL:GetConfig("cfg_item", cfgId)
	if itemTbl.type == E_ItemType.Medicine and itemTbl.subType == 98 then
		if not InfoManager.roleTalentInfo:IsConditionMeet() then
			SL:TipMessage(SL:GetConfig('cfg_string', 62001).text, 1, NoticeType.NoticeMid)
			return false
		end
	end
	return true
end

function this.GetCostStrByIdAndCount(cfgId,count)
	return count .. SL:GetConfig("cfg_item",cfgId).name
end

function this.CheckCrossServerActivityIsEnter(cfgId,isShowTips)
	if SL:HasConfig("cfg_Cross_server",cfgId) then
		---@type cfg_Cross_server_column
		local cfg = SL:GetConfig("cfg_Cross_server",cfgId)
		local isOpen = SL:GetActivityInfo(cfg.activity).open
		if ConditionManager.Check5D(cfg.condition) and ConditionManager.Check5D(cfg.playerCondition) and isOpen then
			return true
		end
		
		if isShowTips then
			if not isOpen then
				SL:TipMessage("活动未开启", 1, NoticeType.NoticeMid)
			else
				SL:TipMessage("未到跨服时间或不满足条件", 1, NoticeType.NoticeMid)
			end
		end
	end
	
	return
end

function this.GetCrossServerIdByMapId(mapId)
	---@type cfg_map_info_column
	local cfg = SL:GetConfig("cfg_map_info",mapId)
	return cfg.crossService
end

---通过段位积分获取段位配置
---@param score number 积分
function this.GetRankCfgByScore(score)
	local tbl = SL:GetConfigTable("PVP_3v3_team_stage")
	local cfg
	---@param v PVP_3v3_team_stage_column
	for i, v in pairs(tbl) do
		if score >= v.points then
			cfg = v
		end
	end

	return cfg
end

---判断是否是外置的PK攻击模式
function this.CheckIsOutPKModel(pkMode)
	if pkMode >= 2000 then
		return true
	end
	return false
end

---获取前几位的值,和剩余位数的值，
function this.GetFirstNumber(value,place)
	local value = tostring(value)
	local first = string.sub(value, 1, place)
	local last = string.sub(value, place + 1, string.len(value))
	return tonumber(first),tonumber(last)
end

function this.IsInGodCountry()
	local mapId = SL:GetMetaValue(EMetaVarGetKey.MAP_ID)
	
	if mapId == 21000 then
		return true
	end
	return false
end

function this.TableKeyToNumber(tableData)
	local newTable = {}
	for k, v in pairs(tableData) do
		local numKey = tonumber(k)
		if numKey ~= nil then
			newTable[numKey] = v
		else
			newTable[k] = v
		end
	end
	return newTable
end

--获取矩形上所有的点（包括边框 + 内部）
function this.GetRectAllPoints(minX, maxX, minY, maxY)
	local points = {}
	
	-- 添加边框点
	-- 上边和下边
	for x = minX, maxX do
		table.insert(points, {x = x, y = minY}) -- 上边
		if minY ~= maxY then
			table.insert(points, {x = x, y = maxY}) -- 下边
		end
	end
	
	-- 左边和右边（排除已经添加的顶点）
	for y = minY + 1, maxY - 1 do
		table.insert(points, {x = minX, y = y}) -- 左边
		table.insert(points, {x = maxX, y = y}) -- 右边
	end
	
	-- 添加内部点
	for x = minX + 1, maxX - 1 do
		for y = minY + 1, maxY - 1 do
			table.insert(points, {x = x, y = y})
		end
	end
	
	return points
end

---@type RoleEffect
function this.SetFoot(rid, cfgId)
    local role = SL:GetRoleById(rid)
	if SL:HasConfig("cfg_item",cfgId) and role then
		---@type cfg_item_column
		local cfg =  SL:GetConfig("cfg_item",cfgId)
		---@type cfg_model_charactor_column
		local model_cfg = SL:GetConfig("cfg_model_charactor",cfg.field[1])
		local fieldposition = model_cfg.fieldposition[1]
		-- 屏蔽ReleaseEffect中关于设置中特效是否隐藏的逻辑
		role.data.isUI = true
		---@type RoleEffect
		role.roleEffectContainer:ReleaseEffect(cfg.field[1],0,model_cfg.path,nil,nil,nil,nil,{x=fieldposition[1],y=fieldposition[2],z=fieldposition[3]})
   		role.data.isUI = false
		return cfgId
	end
end

function this.RecycleFoot(rid, cfgId)
	local role = SL:GetRoleById(rid)
	if SL:HasConfig("cfg_item",cfgId) and role then
		---@type cfg_item_column
		local cfg =  SL:GetConfig("cfg_item",cfgId)
		---@type cfg_model_charactor_column
		local model_cfg = SL:GetConfig("cfg_model_charactor",cfg.field[1])
		return role.roleEffectContainer:StopEffect(cfg.field[1],0,model_cfg.path)
	end
end

---@param mod_1       第一个模型控件名称，通常用于默认展示
---@param mod_2       第二个模型控件名称，通常用于定制位置缩放的展示
---@param monsterTbl  怪物配置表，包含 appr（外观ID）、uipos（UI坐标偏移）、UIscale（UI缩放比例）等字段
---@param defScale    默认模型缩放值，默认为 22
---@param defSize     默认模型尺寸大小，默认为 300
---@param rotate      模型旋转角度（字符串格式），可选
function this.AutoSetUIMonsterModel(mod_1, mod_2,monsterTbl,defScale,defSize,rotate)
	local pos = nil
	local sizeScale = monsterTbl.UIscale
	local defScale = defScale or 22
	local defSize = defSize or 300
	local mfixsize
	local path = SL:GetConfigMultiKeys('cfg_model_monster', monsterTbl.appr, 'id').path
	if not table.isNullOrEmpty(monsterTbl.uipos)  then
		pos = string.format("%d,%d,%d",monsterTbl.uipos[1],monsterTbl.uipos[2],monsterTbl.uipos[3])
	end
	
	-- 如果存在自定义位置，则启用 mod_2 并设置模型参数；否则启用 mod_1
	if pos then
		GUI:setVisible(mod_1,false)
		GUI:setVisible(mod_2,true)
		local scale = string.format("%d,%d,%d",defScale,defScale,defScale)
		GUI:Model_setSrc(mod_2,path,scale,nil,pos)
	else
		GUI:setVisible(mod_1,true)
		GUI:setVisible(mod_2,false)
	end
	
	--没有配置缩放
	if sizeScale == 0 then
		mfixsize = string.format("%d,%d",defSize,defSize)
		GUI:Model_setSrc(mod_1,path,nil,rotate,pos,mfixsize)
	else
		if pos then --当同时配置了缩放和位置时
			local scale = string.format("%d,%d,%d",defScale*sizeScale,defScale*sizeScale,defScale*sizeScale)
			GUI:Model_setSrc(mod_2,path,scale,rotate,pos)
			GUI:setVisible(mod_1,false)
			GUI:setVisible(mod_2,true)
		else
			--只配置了缩放
			mfixsize = string.format("%d,%d",defSize*sizeScale,defSize*sizeScale)
			GUI:Model_setSrc(mod_1,path,nil,rotate,pos,mfixsize)
		end
	end
end

---数字转字符串移除无用的0
---@param num number
---@return string
function this.NumberToStringRemoveZero(num)
	local str = string.format("%.10f", num)  -- 转换为字符串，保留足够精度
	str = str:gsub("%.?0+$", "")             -- 去除小数点后的尾随零
	return str
end

---获取表里的一个键和对应的值
function this.getTableOneKeyAndValue(t)
	for k, v in pairs(t) do
		return k,v
	end
end

-- 解析cron表达式并生成时间段字符串
function this.ParseCronExpressionWithTimestamp(cronExpr, duration)
	-- 分割cron表达式
	local parts = {}
	for part in string.gmatch(cronExpr, "%S+") do
		table.insert(parts, part)
	end

	-- 提取分钟和小时部分
	local minutesPart = parts[2]  -- 第2个字段是分钟
	local hoursPart = parts[3]    -- 第3个字段是小时
	local minutes = {}
	local hours = {}

	-- 解析分钟字段中的各个时间点
	for minute in string.gmatch(minutesPart, "%d+") do
		table.insert(minutes, tonumber(minute))
	end

	-- 解析小时字段中的各个时间点
	for hour in string.gmatch(hoursPart, "%d+") do
		table.insert(hours, tonumber(hour))
	end

	-- 生成时间段表，包含时间戳
	local timeRanges = {}

	for _, hour in ipairs(hours) do
		for _, minute in ipairs(minutes) do
			local startHour = hour
			local startMinute = minute
			local totalEndMinutes = startMinute + duration
			local endHour = startHour + math.floor(totalEndMinutes / 60)
			local endMinute = totalEndMinutes % 60

			-- 创建时间表
			local timeRange = {}

			-- 计算今天的开始时间戳 (基于当前日期)
			local currentTime = os.date("*t")
			currentTime.hour = startHour
			currentTime.min = startMinute
			currentTime.sec = 0
			timeRange[1] = os.time(currentTime)

			-- 计算今天的结束时间戳
			currentTime.hour = endHour
			currentTime.min = endMinute
			timeRange[2] = os.time(currentTime)

			-- 格式化时间范围字符串
			local start_time = string.format("%02d:%02d", startHour, startMinute)
			local end_time = string.format("%02d:%02d", endHour, endMinute)
			timeRange[3] = start_time .. "-" .. end_time

			table.insert(timeRanges, timeRange)
		end
	end

	return timeRanges
end

function this.GetNotBindItemName(cfgId)
	---@type cfg_item_column
	local cfg =  SL:GetConfig("cfg_item",cfgId)
	if EquipFunc.GetItemIsBind(cfgId) then
		local noBindId = cfg.bindEqualItem
		if SL:HasConfig("cfg_item",noBindId) then
			return SL:GetConfig("cfg_item",noBindId).name
		end
	end
	return cfg.name
end

--表key转换成number类型
function this:tblkeytonumber(tbl)
	local newTable = {}
	if tbl and next(tbl) then
		for key, value in pairs(tbl) do
			local newKey = tonumber(key) or key
			if type(value) == "table" then
				newTable[newKey] = ToolFunc:tblkeytonumber(value)
			else
				newTable[newKey] = value
			end
		end
	end
	return newTable
end


-- 提取文本中的颜色代码,"红名恶徒「<color=#FF0000>詹姆斯维克利</color>」<color=#FF4400>伏诛于乱刃之下！</color>"，该函数将返回{"#FF0000", "#FF4400"}。
function this.GetRichTextColorCodes(text)
    if not text or type(text) ~= "string" then
        return {}
    end
    
    local colors = {}
    -- 使用模式匹配查找 <color=#XXXXXX> 格式的颜色标签
    for colorCode in string.gmatch(text, "<color=([^>]+)>") do
        table.insert(colors, colorCode)
    end
    
    return colors
end
---@param text string
---@param color string[]
-- 提取文本中的颜色代码,"红名恶徒「<color=#FF0000>詹姆斯维克利</color>」<color=#FF4400>伏诛于乱刃之下！</color>"，该函数将返回
--"红名恶徒「<color=#FFFFFF>詹姆斯维克利</color>」<color=#FF44FF>伏诛于乱刃之下！</color>"
-- 替换文本中的颜色代码为新的颜色代码
function this.ReplaceColorCodes(text, newColor)
    if not text or type(text) ~= "string" then
        return text
    end
    
    -- 将所有 <color=...> 替换为新的颜色
    local result = string.gsub(text, "<color=[^>]+>", "<color=" .. newColor .. ">")
    
    return result
end

function this.MixColorWithBlack(color, factor)
    if not color then
        return "#000000" -- 默认返回黑色
    end
    
    -- 如果颜色是以 # 开头的十六进制格式
    if type(color) == "string" and string.sub(color, 1, 1) == "#" then
        local r, g, b = tonumber("0x" .. string.sub(color, 2, 3)), 
                        tonumber("0x" .. string.sub(color, 4, 5)), 
                        tonumber("0x" .. string.sub(color, 6, 7))
        
        -- 将黑色 (0, 0, 0) 与原颜色混合
        local mixedR = math.floor(r * factor + 0 * (1 - factor))
        local mixedG = math.floor(g * factor + 0 * (1 - factor))
        local mixedB = math.floor(b * factor + 0 * (1 - factor))
        
        return string.format("#%02X%02X%02X", mixedR, mixedG, mixedB)
    else
        -- 如果颜色是 RGB 表或数组格式 {r, g, b}
        local r, g, b = color[1], color[2], color[3]
        if not (r and g and b) then
            return {0, 0, 0} -- 默认返回黑色
        end
        
        local mixedR = math.floor(r * factor + 0 * (1 - factor))
        local mixedG = math.floor(g * factor + 0 * (1 - factor))
        local mixedB = math.floor(b * factor + 0 * (1 - factor))
        
        return {mixedR, mixedG, mixedB}
    end
end
