API = {}

-----------------------------------------
---------------通用处理------------------
-----------------------------------------


-- 计算两点(x1,y1)和(x2,y2)之间的距离
function API.CalculateDistance(x1, y1, x2, y2)
    local dx = x2 - x1  -- 计算x坐标差值
    local dy = y2 - y1  -- 计算y坐标差值
    -- 返回平方根，即两点间的距离
    return math.sqrt(dx * dx + dy * dy)
end


function API.MapMove(actor, mapCfgId, line, x, y, range)
    info("接口管理传送")
    info(mapCfgId, "mapCfgId")


    if mapCfgId == 0 then
        mapCfgId = getbaseinfo(actor, "mapid")
    end
    if x ~= nil and y ~= nil then
        maptransfer(actor, x, y, mapCfgId, line, range)
    else
        maptransfer(actor, 0, 0, mapCfgId, line, 300)
    end
end

--根据角色名获取对象
function API.Name2Guid(name)
    local rid = getroleidbyname(name)
    local playerActor = getactor(rid)
    return playerActor
end

--获取指定范围内的成员列表
function API.GetRangeTeamList(actor, range)
    local list = API.GetTeamList(actor)
    local list1 = {}
    if next(list) then
        for i = 1, #list do
            local player = list[i]
            if player ~= actor then
                if getbaseinfo(actor, "mapid") == getbaseinfo(player, "mapid") then
                    local distance = mapobjectdistance(actor, actor, player)
                    -- info(distance, "distance")
                    if distance <= range then
                        table.insert(list1, player)
                    end
                end
            end
        end
    end
    -- info(#list1,"#list1")
    return list1
end

--获取队伍成员列表
function API.GetTeamList(actor)
    local list = {}
    local teamId = getbaseinfo(actor, "teamid")
    if teamId ~= 0 then
        local teamInfo = getteaminfo(actor, teamId)
        local allteammemberinfo = teamInfo.allteammemberinfo
        for i = 1, #allteammemberinfo do
            local rid = allteammemberinfo[i].rid
            local player = getactor(rid)
            table.insert(list, player)
        end
    end
    return list
end

--获取队伍平均等级
function API.GetTeamPingJunLevel(actor)
    local teamId = getbaseinfo(actor, "teamid")
    if teamId == 0 then
        return 0
    end
    local teamInfo = getteaminfo(actor, teamId)
    local allteammemberinfo = teamInfo.allteammemberinfo
    local allLevel = 0
    for i = 1, #allteammemberinfo do
        local rid = allteammemberinfo[i].rid
        local player = getactor(rid)
        local level = getbaseinfo(player, "level")
        allLevel = allLevel + level
    end
    local pinJunLevel = math.floor(allLevel / #allteammemberinfo)
    return pinJunLevel
end

--根据物品的唯一ID获取物品
function API.ItemId2WearBarAndPos(actor, itemId)
    local equipInfo = getequipinfo(actor, itemId, 1) or {}
    if not next(equipInfo) then
        return 1, nil
    end
    local cfgid = equipInfo.cfgid
    local wearBar = ConfigDataManager.getTableValue("cfg_item", "wearBarID", "id", cfgid)
    wearBar = tonumber(wearBar)
    local equipPos = gameequip.pos(equipInfo.equipindex)
    -- 23是战旗，额外处理
    if equipPos == 0 or equipPos == 23 or equipPos == 25 then
        local equipPosString = ConfigDataManager.getTableValue("cfg_item", "strPart", "id", cfgid)
        equipPosString = string.isNullOrEmpty(equipPosString) and "0" or equipPosString
        if string.find(equipPosString, "#") then
            local tab = string.split(equipPosString, "#")
            equipPos = tonumber(tab[1])
        else
            equipPos = tonumber(equipPosString)
        end
    end
    return wearBar, equipPos
end

--根据权重取下标
function API.GetQZ(tab)
    local idx = 0
    if tab == nil or #tab <= 0 then
        return 0
    end
    local Min, Max = 0, 0
    for i = 1, #tab do
        Max = Max + tab[i].qz
    end
    local RanNum = math.random(1, Max)
    for i = 1, #tab do
        Min = Min + tab[i].qz
        if RanNum <= Min then
            idx = i
            break
        end
    end
    return idx
end

--根据权重取不同下标
function API.GetQZWithout(tab, havdTab)
    local idx = 0
    if tab == nil or #tab <= 0 then
        return 0
    end
    local Min, Max = 0, 0
    for i = 1, #tab do
        if not table.contains(havdTab, i) then
            Max = Max + tab[i].qz
        end
    end
    local RanNum = math.random(1, Max)
    for i = 1, #tab do
        if not table.contains(havdTab, i) then
            Min = Min + tab[i].qz
            if RanNum <= Min then
                idx = i
                break
            end
        end
    end
    return idx
end

--检测CD
function API.checkCD(lastTime, cd)
    local nowTime = os.time()
    return nowTime - lastTime > cd
end

--复制表格
function API.deepCopy(original)
    local copy
    if type(original) == "table" then
        copy = {}
        for k, v in next, original, nil do
            copy[API.deepCopy(k)] = API.deepCopy(v)
        end
        setmetatable(copy, API.deepCopy(getmetatable(original)))
    else
        copy = original
    end
    return copy
end

--道具列表放大
function API.ItemListMulti(itemList, multi)
    local list = API.deepCopy(itemList)
    for k, v in pairs(list) do
        v[2] = v[2] * multi
    end
    return list
end

--道具名字列表转换为id
function API.ItemListNameToID(itemList)
    local list = {};
    for k, v in pairs(itemList) do
        local itemName = v[1];
        local itemNum = tonumber(v[2]);
        local itemID = ConfigDataManager.getTableValue("cfg_item", "id", "name", itemName)
        list[tonumber(itemID)] = itemNum
    end
    return list
end

---消耗 奖励  检查

function API.Check(check_str, have_count, itemNum)
    check_str = check_str or ">="
    -- info("来了66",check_str,have_count,itemNum,type(have_count),type(itemNum))
    local result = true;
    if check_str == ">" or check_str == nil then
        if have_count <= itemNum then
            result = false
        end
    elseif check_str == "<" then
        if have_count >= itemNum then
            result = false
        end
    elseif check_str == "==" then
        if have_count ~= itemNum then
            result = false
        end
    elseif check_str == ">=" then
        -- print("玩家等级123456==========>", have_count, itemNum)
        if have_count < itemNum then
            result = false
        end
        -- info("你干嘛",check_str,have_count,itemNum,type(have_count),type(itemNum),result)
    elseif check_str == "<=" then
        if have_count > itemNum then
            result = false
        end
    end
    return result
end

function API.CheckItem(actor, tcl, desc)
    if not next(tcl) then
        return false
    end
    for k, v in pairs(tcl) do
        if type(k) ~= "string" then
            local itemName = v[1];                --类型为变化或者道具时可用 道具名或者变量名
            local itemNum = tonumber(v[2]);       --对应类型需要的检查值
            local bangding = v[3] or v.bind;      --是否绑定 道具用 暂无用
            local item_type = v[4] or v.mold;     --类型 1或者nil道具 2 Int变量 3开服天数 4龙魂连击等级 5所有充值挡位 玩家等级 转职
            local var_type = v[5] or v.var_type;  --变量类型 nil 存盘 0日变量 1 缓存小退清零
            local check_str = v[6] or v.checkStr; -- == > < >= <=
            local def_str = v[7] or v.desc        --检查失败后的默认消息提示 不传没有
            -- info(v,itemName)
            if not item_type or item_type == 1 then
                local itemID = ConfigDataManager.getTableValue("cfg_item", "id", "name", itemName)
                local hasCount = getbagitemcountbyid(actor, itemID)

                if hasCount < itemNum then
                    if desc then
                        if desc ~= "" then
                            API.SendCenterMsg(actor, desc)
                        end
                    else
                        API.SendCenterMsg(actor, itemName .. "不足")
                    end
                    return false
                end
                --2 Int变量
            elseif item_type == 2 then
                local have_count = API.GetInt(actor, itemName, var_type)
                -- info(v,itemName,have_count)
                def_str = def_str or "变量不足！"
                if API.Check(check_str, have_count, itemNum) == false then
                    if def_str and desc ~= "" then
                        API.SendCenterMsg(actor, def_str)
                    end
                    return false
                end
                --3 开服天数
            elseif item_type == 3 then
                local have_count = tonumber(getserveropendays(actor))
                -- info("开服天数",have_count)
                if API.Check(check_str, have_count, itemNum) == false then
                    if def_str then
                        API.SendCenterMsg(actor, def_str)
                    end
                    return false
                end
            elseif item_type == 4 then
                -- local comboSkill = getrolefield(actor,"role.roleskill.comboskill")
                -- local have_count =  comboSkill.skillLv
                local have_count = API.GetInt(actor, VarCfg.ZC_NewDragonSoulComboLevel)
                if not API.Check(check_str, have_count, itemNum) then
                    if desc then
                        if desc ~= "" then
                            API.SendCenterMsg(actor, desc)
                        end
                    else
                        API.SendCenterMsg(actor, "龙魂连击等级不足")
                    end
                    return false
                end
            elseif item_type == 5 then
                if not RechargeStall.checkAllBuy(actor, desc) then
                    return
                end
            elseif item_type == "玩家等级" then
                local cur_level = tonumber(getbaseinfo(actor, "level")) or 0
                if API.Check(check_str, cur_level, itemNum) == false then
                    if desc then
                        if desc ~= "" then
                            API.SendCenterMsg(actor, desc)
                        end
                    else
                        API.SendCenterMsg(actor, "等级不足,需要" .. itemNum .. "级")
                    end
                    return false
                end
            elseif item_type == "转职" then
                local data = API.GetTable(actor, VarCfg.ZC_ZhuanZhiVar) or {}
                local count = data.count or 0;
                if API.Check(check_str, count, itemNum) == false then
                    if desc then
                        if desc ~= "" then
                            API.SendCenterMsg(actor, desc)
                        end
                    else
                        API.SendCenterMsg(actor, "请" .. itemNum .. "转后再来吧")
                    end
                    return false
                end
            end
        end
    end
    -- info("来了122133","成功了澳")
    return true
end

function API.takeItem(actor, tcl, desc)
    if not next(tcl) then
        return false
    end
    if API.CheckItem(actor, tcl) == false then
        return false
    end
    for k, v in pairs(tcl) do
        if type(k) ~= "string" then
            local itemName = v[1]
            local itemNum = tonumber(v[2])
            local bangding = v[3];
            local item_type = v[4] or v.mold; --检查 1或者nil道具 2 Int变量
            local var_type = v[5];
            if not item_type or item_type == 1 then
                local itemID = ConfigDataManager.getTableValue("cfg_item", "id", "name", itemName)
                removeitemfrombag(actor, itemID, itemNum, 9999, desc)
                --2 Int变量
            elseif item_type == 2 then
                local var = API.GetInt(actor, itemName, var_type)
                var = var - itemNum
                API.SetInt(actor, itemName, var, var_type)
            end
        end
    end
    return true
end

function API.GiveItem(actor, twp, desc, notPush)
    if not next(twp) then
        return false
    end
    local itemIdList = {};
    for k, v in pairs(twp) do
        local newTwp = {}
        local itemName = v[1]
        local itemNum = v[2]
        local bangding = v[3];
        local item_type = v[4]; --检查 1或者nil道具 2 Int变量
        local var_type = v[5];
        if not item_type or item_type == 1 then
            local itemID = ConfigDataManager.getTableValue("cfg_item", "id", "name", itemName)
            newTwp[itemID] = itemNum
            local id = additemmaptobag(actor, newTwp, bangding, 9999, desc)
            table.insert(itemIdList, { id = id, cfgId = itemID, count = itemNum, });
            --2 Int变量
        elseif item_type == 2 then
            local var = API.GetInt(actor, itemName, var_type)
            var = var + itemNum
            API.SetInt(actor, itemName, var, var_type)
        end
    end
    if #itemIdList > 0 and (not notPush) then
        -- info("走了没",itemIdList,LuaMessageIdToClient.COMMON_REWARD_PANEL)
        sendluamsg(actor, LuaMessageIdToClient.COMMON_REWARD_PANEL, itemIdList)
    end
    return true, itemIdList
end

---发送消息
function API.SendCenterMsg(actor, msg, color, log)
    if not color then
        tipinfo(actor, msg)
    else
        tipinfo(actor, "<color='" .. color .. "'>" .. msg .. "</color>")
    end
    if log then
        error(getbaseinfo(actor, "rolename"), msg)
    end
end

--打印表格消息
function API.PrintTable(table, level, key)
    if type(table) ~= "table" then
        info(table)
        return
    end
    level = level or 1
    local indent = ""
    for i = 1, level do
        indent = indent .. "  "
    end

    if key ~= "" and key ~= nil then
        -- info(tostring(key)..type(key));
        info(indent .. key .. " " .. "=" .. " " .. "{")
    else
        info(indent .. "{")
    end

    key = ""
    if type(table) == "table" then
        for k, v in pairs(table) do
            if type(v) == "table" then
                key = k
                API.PrintTable(v, level + 1, key)
            else
                local content = string.format("%s%s = %s", indent .. "  ", tostring(k), tostring(v))
                info(content)
            end
        end
    end

    info(indent .. "}")
end

-----------------------------------------
---------------伤害相关------------------
-----------------------------------------


--获取玩家当前剩余血量百分比
function API.GetHpPctNow(actor)
    local hpNow = getbaseinfo(actor, "hp")
    local hpMax = getattrinfo(actor, "maxHP")
    local hpPctNow = hpNow / hpMax
    return hpPctNow * 100
end

--获取玩家当前剩余蓝量百分比
-- function API.GetMpPctNow(play)
--     local hpNow = getbaseinfo(play,11)
--     local hpMax = getbaseinfo(play,12)
--     local hpPctNow = math.floor(hpNow/hpMax)
--     return hpPctNow*100
-- end

--获取对应百分比的血量
function API.GetHpPctNum(actor, pct)
    local hpMax = getattrinfo(actor, "maxHP")
    local hpPctNum = hpMax * (pct / 100)
    return hpPctNum
end

--获取对应百分比的蓝量
-- function API.GetMpPctNum(play,pct)
--     local mpMax = getbaseinfo(play,12)
--     local mpPctNum = mpMax*(pct/100)
--     return mpPctNum
-- end

--获取指定BUFF堆叠层数
function API.GetBuffState(actor, buffId)
    local buff_info = getbuffinfo(actor)
    local idx = 0
    if buff_info and next(buff_info) then
        for i = 1, #buff_info do
            if buff_info[i].buffcfgid == buffId then
                idx = buff_info[idx].layers
            end
        end
    end
    return idx
end

--获取指定BUFF数据
function API.GetBuffInfo(actor, buffId)
    local buff_info = getbuffinfo(actor)
    if buff_info and next(buff_info) then
        for i = 1, #buff_info do
            if buff_info[i].buffcfgid == buffId then
                return buff_info[i]
            end
        end
    end
    return
end


-----------------------------------------
---------------变量控制------------------
-----------------------------------------

--物品变量


--获取物品变量（注意此接口服务端只支持一种数据结构 map或list  不能都有）
--[[
    setDurability:是否初始化过耐久
    Durability:耐久度
    strengthlv:强化等级
    tZhuoYueAttIndex：卓越属性
    appendlv:追加等级
    IsLuck:是否激活幸运
    skillName：激活技能名
    zaisheng_attr:再生属性
]]
function API.GetItemData(actor, itemId, varName)
    local itemData = getitemextdata(actor, itemId) or {}
    return itemData["" .. varName]
end

--设置物品变量
function API.SetItemData(actor, itemId, varName, var)
    local itemData = getitemextdata(actor, itemId) or {}
    itemData["" .. varName] = var
    setitemextdata(actor, itemId, itemData)
end

---个人变量说明
---T$ 无类型限制 自动保存数据库
---J$ 无类型限制 天变量 存入数据库
---@ 下线不保存 小退清空



--- 获取玩家Int变量 默认为0 var_type nil 存盘 0日变量 1 缓存小退清零
function API.GetInt(actor, varName, var_type)
    local val = 0
    if var_type == 0 then
        val = getplaydef(actor, "J$" .. varName)
    elseif var_type == 1 then
        val = getplaydef(actor, "@" .. varName)
    else
        val = getplaydef(actor, "T$" .. varName)
    end
    return val or 0
end

---设置玩家Int变量 val类型必须是number
function API.SetInt(actor, varName, val, var_type)
    if type(val) ~= "number" then
        return
    end
    if var_type == 0 then
        return setplaydef(actor, "J$" .. varName, val)
    elseif var_type == 1 then
        return setplaydef(actor, "@" .. varName, val)
    else
        return setplaydef(actor, "T$" .. varName, val)
    end
end

---获取玩家string类型的变量 默认为 ""
function API.GetStr(actor, varName, var_type)
    local val = ""
    if var_type == 0 then
        val = getplaydef(actor, "J$" .. varName)
    elseif var_type == 1 then
        val = getplaydef(actor, "@" .. varName)
    else
        val = getplaydef(actor, "T$" .. varName)
    end
    return val or ""
end

---设置玩家string变量 val类型必须是string
function API.SetStr(actor, varName, val, var_type)
    if type(val) ~= "string" then
        return
    end
    if var_type == 0 then
        return setplaydef(actor, "J$" .. varName, val)
    elseif var_type == 1 then
        return setplaydef(actor, "@" .. varName, val)
    else
        return setplaydef(actor, "T$" .. varName, val)
    end
end

---获取玩家table类型的变量 默认为 nil
function API.GetTable(actor, varName, var_type)
    local val = nil
    if var_type == 0 then
        val = getplaydef(actor, "J$" .. varName)
    elseif var_type == 1 then
        val = getplaydef(actor, "@" .. varName)
    else
        val = getplaydef(actor, "T$" .. varName)
    end
    return val
end

---设置玩家table变量 val类型必须是table var_type 0天变量 1缓存变量 其它正常保存数据库变量
function API.SetTable(actor, varName, val, var_type)
    if type(val) ~= "table" then
        return
    end
    if var_type == 0 then
        setplaydef(actor, "J$" .. varName, val)
    elseif var_type == 1 then
        setplaydef(actor, "@" .. varName, val)
    else
        setplaydef(actor, "T$" .. varName, val)
        -- info("记录成功",val,getplaydef(actor,"T$"..varName))
    end
end

--- 获取玩家Int天变量 默认为0
function API.GetDayInt(actor, varName)
    local val = getplaydef(actor, "J$" .. varName) or 0
    return val
end

---设置玩家Int天变量 val类型必须是number
function API.SetDayInt(actor, varName, val)
    if type(val) ~= "number" then
        return
    end
    return setplaydef(actor, "J$" .. varName, val)
end

---获取玩家string类型的天变量 默认为 ""
function API.GetDayStr(actor, varName)
    local val = getplaydef(actor, "J$" .. varName) or ""
    return val
end

---设置玩家string天变量 val类型必须是string
function API.SetDayStr(actor, varName, val)
    if type(val) ~= "string" then
        return
    end
    return setplaydef(actor, "J$" .. varName, val)
end

---获取玩家table类型的天变量 默认为 nil
function API.GetDayTable(actor, varName)
    local val = getplaydef(actor, "J$" .. varName) or nil
    return val
end

---设置玩家table天变量 val类型必须是string
function API.SetDayTable(actor, varName, val)
    if type(val) ~= "table" then
        return
    end
    return setplaydef(actor, "J$" .. varName, val)
end

---全局变量说明
---G$ 服务器重启清除
---R$ 保存数据库
---Q$ 天变量 每天0点清空

--- 获取系统Int变量 值默认为0  默认类型为2  varType=1 服务器重启清除  =2存入数据库  =3每天0点清除
function API.GetDBNum(varName, varType)
    local fh = "R$"
    if varType == 1 then
        fh = "G$"
    elseif varType == 3 then
        fh = "Q$"
    end
    return getsysvar(fh .. "" .. varName) or 0
end

--- 设置系统Int变量 值默认为0  默认类型为2  varType=1 服务器重启清除  =2存入数据库  =3每天0点清除
function API.SetDBNum(varName, val, varType)
    if type(val) ~= "number" then
        return
    end
    local fh = "R$"
    if varType == 1 then
        fh = "G$"
    elseif varType == 3 then
        fh = "Q$"
    end
    return setsysvar(fh .. varName, val)
end

--- 获取系统string变量 值默认为""  默认类型为2  varType=1 服务器重启清除  =2存入数据库  =3每天0点清除
function API.GetDBStr(varName, varType)
    local fh = "R$"
    if varType == 1 then
        fh = "G$"
    elseif varType == 3 then
        fh = "Q$"
    end
    return getsysvar(fh .. "" .. varName) or ""
end

--- 设置系统string变量 值默认为""  默认类型为2  varType=1 服务器重启清除  =2存入数据库  =3每天0点清除
function API.SetDBStr(varName, val, varType)
    if type(val) ~= "string" then
        return
    end
    local fh = "R$"
    if varType == 1 then
        fh = "G$"
    elseif varType == 3 then
        fh = "Q$"
    end

    return setsysvar(fh .. varName, val)
end

--- 获取系统string变量 值默认为nil  默认类型为2  varType=1 服务器重启清除  =2存入数据库  =3每天0点清除
function API.GetDBTable(varName, varType)
    local fh = "R$"
    if varType == 1 then
        fh = "G$"
    elseif varType == 3 then
        fh = "Q$"
    end
    return getsysvar(fh .. "" .. varName) or nil
end

--- 设置系统table变量 值默认为nil  默认类型为2  varType=1 服务器重启清除  =2存入数据库  =3每天0点清除
function API.SetDBTable(varName, val, varType)
    if type(val) ~= "table" then
        return
    end
    local fh = "R$"
    if varType == 1 then
        fh = "G$"
    elseif varType == 3 then
        fh = "Q$"
    end

    return setsysvar(fh .. varName, val)
end

--- 获取系统string变量 值默认为nil  默认类型为2  varType=1 服务器重启清除  =2存入数据库  =3每天0点清除
function API.GetGuildDBTable(guild, varName)
    return getguilddef(guild,"U$"..varName) or nil
end

--- 设置系统table变量 值默认为nil  默认类型为2  varType=1 服务器重启清除  =2存入数据库  =3每天0点清除
function API.SetGuildDBTable(guild, varName,value)
    return setguilddef(guild,"U$"..varName,value)
end

function API.tblkeytonumber(tbl)
    local newTable = {}
    if tbl and next(tbl) then
        for key, value in pairs(tbl) do
            local newKey = tonumber(key) or key
            if type(value) == "table" then
                newTable[newKey] = API.tblkeytonumber(value)
            else
                newTable[newKey] = value
            end
        end
    end
    return newTable
end

---战盟变量说明
---U$ 无类型限制 存入数据库


---消耗 奖励  检查

--推送流光数据等级
function API.refreshLiuGuang(actor, itemId, val)
    local itemData = {}
    local val = val or EquipFunc.getEquipStrengthLevel(actor, itemId)
    itemData.strengthlv = val
    setequipgmext(actor, itemId, itemData)
end

function API.messageBox(actor, messageString, isMidden)
    if string.isNullOrEmpty(messageString) then
        return
    end
    isMidden = isMidden == nil and true or isMidden
    sendluamsg(actor, LuaMessageIdToClient.MESSAGE_INFO, { message = messageString, isMidden = isMidden })
end


function API.ItemEqulas(item_cfg1, item_cfg2)
    item_cfg1 = tonumber(item_cfg1)
    item_cfg2 = tonumber(item_cfg2)
    if tonumber(item_cfg1) == tonumber(item_cfg2) then
        return true
    end
    -- info("item_cfg1", item_cfg1, item_cfg2)
    if item_cfg1 == 50030002 and item_cfg2 == 1253000299 then
        return true
    elseif item_cfg1 == 50030004 and item_cfg2 == 1253000499 then
        return true
    elseif item_cfg1 == 50030003 and item_cfg2 == 1253000399 then
        return true
    elseif item_cfg1 == 1253000299 and item_cfg2 == 50030002 then
        return true
    elseif item_cfg1 == 1253000499 and item_cfg2 == 50030004 then
        return true
    elseif item_cfg1 == 1253000399 and item_cfg2 == 50030003 then
        return true
    end
    local bindEqualItem = ConfigDataManager.getTableValue("cfg_item", "bindEqualItem", "id", item_cfg1)
    if string.isNullOrEmpty(bindEqualItem) then
        return false
    end

    if tonumber(bindEqualItem) == tonumber(item_cfg2) then
        return true
    end
    return false
end

function API.GetBindItemCfgId(cfg_Id)
    local lockItem = ConfigDataManager.getTableValue("cfg_item", "lockitem", "id", cfg_Id)
    if lockItem ~= "" and lockItem == "2"  then
        return cfg_Id
    end
    if cfg_Id == 1253000299 then
        return 50030002
    elseif cfg_Id == 1253000499 then
        return 50030004
    elseif cfg_Id == 1253000399 then
        return 50030003
    end
    local bindEqualItem = ConfigDataManager.getTableValue("cfg_item", "bindEqualItem", "id", cfg_Id)
    if string.isNullOrEmpty(bindEqualItem) then
        return cfg_Id
    end
    return tonumber(bindEqualItem)
end

function API.GetNotBindItemCfgId(cfg_Id)
    local lockItem = ConfigDataManager.getTableValue("cfg_item", "lockitem", "id", cfg_Id)
    if lockItem ~= "" and lockItem == "1"  then
        return cfg_Id
    end
    if cfg_Id == 50030002 then
        return 1253000299
    elseif cfg_Id == 50030004 then
        return 1253000499
    elseif cfg_Id == 50030003 then
        return 1253000399
    end
    local bindEqualItem = ConfigDataManager.getTableValue("cfg_item", "bindEqualItem", "id", cfg_Id)
    if string.isNullOrEmpty(bindEqualItem) then
        return cfg_Id
    end
    return tonumber(bindEqualItem)
end

function API.GetCfgBindItemCfgId(cfg_Id)
    if cfg_Id == 50030002 then
        return 1253000299
    elseif cfg_Id == 50030004 then
        return 1253000499
    elseif cfg_Id == 50030003 then
        return 1253000399
    elseif cfg_Id == 1253000299 then
        return 50030002
    elseif cfg_Id == 1253000499 then
        return 50030004
    elseif cfg_Id == 1253000399 then
        return 50030003
    end
    local bindEqualItem = ConfigDataManager.getTableValue("cfg_item", "bindEqualItem", "id", cfg_Id)
    if string.isNullOrEmpty(bindEqualItem) then
        return 0
    end
    return tonumber(bindEqualItem) or 0
end