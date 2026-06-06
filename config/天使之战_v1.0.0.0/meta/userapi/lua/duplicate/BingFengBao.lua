BingFengBao = {}
local this = BingFengBao
local filename = "BingFengBao"


this.msgID = LuaMessageIdToClient.RES_BING_FENG_BAO

function this.getData(actor)
    local tab = {}

    local masterRid = BingFengBao.getMaster() --占领者ID
    local zlTime = 0
    if masterRid == 0 then
        zlTime = 0
    else
        zlTime = API.GetInt(getactor(masterRid), "占领时长")
    end
    local actorName =  "无"
    if masterRid ~= 0 then
        actorName = getbaseinfo(getactor(masterRid), "rolename")
    end

    local CurrentUnionId = BingFengBao.getMasterCurrentUnionId() --获取临时当前占领的战盟ID 
    local CurrentUnionName = "无"
    if CurrentUnionId ~= 0 then
        CurrentUnionName = getunioninfo(actor, CurrentUnionId).unionname
    end


    local LinShiUnionId = BingFengBao.getMasterLinShiUnionId() --获取临时占领的战盟ID 3分钟占领战盟ID
    local LinShiUnionName = "无"
    if LinShiUnionId ~= 0 then
        LinShiUnionName = getunioninfo(actor, LinShiUnionId).unionname
    end

    local MasterUnionId = this.getMasterUnionId() --获取占领的战盟ID 最终
    local MasterUnionName = "暂无"
    if MasterUnionId ~= 0 then
        MasterUnionName = getunioninfo(actor, MasterUnionId).unionname
    end


    tab = {
        masterRid = masterRid,
        zlTime = zlTime,
        CurrentUnionName=CurrentUnionName,
        LinShiUnionName = LinShiUnionName,
        MasterUnionName = MasterUnionName,
        actorName=actorName,
        isOpen = BingFengBao.isOpen(),
    }

    -- tab.data = data

    return tab
end

--玩家是否在占领区域
function this.checkActorIsInZhanLingQv(actor)
    local isIn = false

    local bfgOccupyPosition = string.splitInt(ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.BFG_OCCUPY_POSITION), "#")
    local starX = bfgOccupyPosition[2]
    local starY = bfgOccupyPosition[3]
    local width = bfgOccupyPosition[4]
    local height = bfgOccupyPosition[5]

    local x, y = getbaseinfo(actor, "x"), getbaseinfo(actor, "y")
    --ZzpTest.print("玩家", actor:toString(), "检测玩家区域x",x,"y",y, "starX",starX, "starY",starY, "width",width, "height",height)
    --error(actor, "玩家", actor:toString(), "检测玩家区域x",x,"y",y, "starX",starX, "starY",starY, "width",width, "height",height)
    if x >= starX and x <= starX + width and y >= starY and y <= starY + height then
        isIn = true
    end
    return isIn
end

--打开/关闭占领按钮
function this.openZhanLingButton(actor)
    if BingFengBao.isOpen() and BingFengBao.IsPlayerInRoland(actor) then
        local open = this.checkActorIsInZhanLingQv(actor)
        if open then
            this.sendDataToClient(actor)
        end
        sendluamsg(actor, this.msgID, { sendType = 10, open = open })
    end
end

--移动后回调
function BingFengBao.move(actor)
    if BingFengBao.isOpen() then
        this.openZhanLingButton(actor)
    end
end

--占领详情面板数据刷新
function this.SendData(actor)
    -- messagebox(actor,"发送更新前")
    local data = this.getData(actor)
    sendluamsg(actor, this.msgID, { sendType = 998, data = data })
end

function this.sendDataToClient(actor)
    local data = {
        sendType = 999,
        data = this.getData(actor),
    }
    sendluamsg(actor, this.msgID, data)
end

function this.Click(actor, msgData)
    local mainPage = msgData.mainPage
    local subPage = msgData.subPage
    local par = msgData.par
    if mainPage == 1 then
        BingFengBao.ZhanLing(actor)
    elseif mainPage == 2 then

    end
end

--点击占领
function BingFengBao.ZhanLing(actor)
    --检测攻城战活动是否开启
    if not BingFengBao.isOpen() then
        messagebox(actor, "攻城战尚未开启")
        return
    end

    --检测角色是否有战盟
    local unionId = getbaseinfo(actor, "guildid")
    if unionId == 0 then
        messagebox(actor, "没有加入战盟，无法占领")
        -- gameDebug.assertPrintTrace(false, getbaseinfo(actor,"rid") .. "请求占领，未处于一个战盟中！")
        return
    end
        --本人就取消占领
    if BingFengBao.getMaster() == getbaseinfo(actor, "rid") then
        BingFengBao.setMaster(0)
        BingFengBao.setMasterCurrentUnionId(0)
        API.SetInt(actor, "占领时长", 0)
        API.SetInt(actor, "上次增加积分的时间", 0)
        this.SendData(actor)
        this.ChangeBuff(actor,false)
        ZzpTest.print("玩家", actor:toString(), "点击 取消占领")
        return
    end
    --检测体力是否<800 --stamina
    local stamina = getattrinfo(actor, "stamina")
    if stamina >= 800 then
        messagebox(actor, "体力属性超过800，无法占领")
        -- gameDebug.assertPrintTrace(false, getbaseinfo(actor,"rid") .. "请求占领，体力属性超过800！")
        return
    end

    --检测当前是否有人占领
    if BingFengBao.getMaster() ~= 0 then
        messagebox(actor, "当前被其他玩家占领，无法占领")
        -- gameDebug.assertPrintTrace(false, getbaseinfo(actor,"rid") .. "请求占领，当前被其他玩家占领！")
        return
    end
    if isdead(actor) then
        messagebox(actor, "死亡，无法占领")
        return
    end

    if not this.checkActorIsInZhanLingQv(actor) then
        messagebox(actor, "位置不在王座范围，无法占领")
        return
    end
    --设置占领者
    BingFengBao.setMaster(getbaseinfo(actor, "rid"))
    BingFengBao.setMasterCurrentUnionId(unionId)
    messagebox(actor, "占领成功")
    --添加限制移动BUFF
    this.ChangeBuff(actor,true)
    local unioninfoData = getunioninfo(actor, unionId)
    local unionName = unioninfoData.unionname or "未知战盟"
    local rolename = getbaseinfo(actor, "rolename") or "未知角色"
    BingFengBao.SendMsgToAllPlayer("", StringIdConst.TEXT56007, unionName, rolename)
    this.SendData(actor)
end

--玩家1秒心跳
GameEvent.add(EventCfg.onRoleseCond, function(actor)
    if BingFengBao.isOpen() then
        if BingFengBao.IsPlayerInRoland(actor) then

            if BingFengBao.getMaster() ~= getbaseinfo(actor, "rid") then
                this.SendData(actor)
                return
            end

            --检测占领范围
            if not this.checkActorIsInZhanLingQv(actor) then
                BingFengBao.setMaster(0)
                BingFengBao.setMasterCurrentUnionId(0)
                API.SetInt(actor, "占领时长", 0)
                API.SetInt(actor, "上次增加积分的时间", 0)
                this.ChangeBuff(actor, false)
                this.SendData(actor)
                ZzpTest.print("玩家", actor:toString(), "玩家心跳检测不在范围 取消占领")
                return
            end


            --添加占领时长
            local zlTime = API.GetInt(actor, "占领时长") + 1
            API.SetInt(actor, "占领时长", zlTime)
            local ZhanLingTime = string.tonumber(ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.BFG_OCCUPY_TIME))

            if zlTime >= ZhanLingTime then
                --设置临时占领战盟
                local unionId = getbaseinfo(actor, "guildid")

                if BingFengBao.getMasterLinShiUnionId() ~= unionId then
                    BingFengBao.setMasterLinShiUnionId(unionId)
                end
                local jiFenTime = API.GetInt(actor, "上次增加积分的时间")
                if jiFenTime == 0 or zlTime >= (jiFenTime + ZhanLingTime) then
                    -- 增加积分
                    callonserial(actor, "add_zhan_ling_ji_fen", 1)
                    API.SetInt(actor, "上次增加积分的时间", zlTime)
                end
            end
            this.SendData(actor)
        end

    end
end, filename)

-- 角色死亡
GameEvent.add(EventCfg.onPlaydie, function(actor, dieInfo, killInfo)
    local killerType = killInfo.type
    if killerType ~= MapObjectType.PLAYER then
        return
    end
    if BingFengBao.isOpen() then
        if BingFengBao.getMaster() == getbaseinfo(actor, "rid") then
            BingFengBao.setMaster(0)
            BingFengBao.setMasterCurrentUnionId(0)
            API.SetInt(actor, "占领时长", 0)
            API.SetInt(actor, "上次增加积分的时间", 0)
            this.ChangeBuff(actor,false)
            ZzpTest.print("玩家", actor:toString(), "死亡 取消占领")

            -- 击杀占领玩家加分
            local killerId = killInfo.id
            local killer = getactor(actor, killerId)
            if killer ~= nil then
                callonserial(killer, "add_zhan_ling_ji_fen", 1)
            end
        end
        -- 设置积分 击杀者 积分加1
        -- 在冰风谷
        --local killerId = killInfo.id
        --local killer = getactor(actor, killerId)
        --
        --if killer ~= nil then
        --    local unionId = getbaseinfo(actor, "guildid")
        --    unionId = tonumber(unionId) or 0
        --    if BingFengBao.IsPlayerInRoland(killer) and unionId > 0 and BingFengBao.checkAddZhanLingJiFenOnePlayer(actor, dieInfo.id) then
        --        this.addZhanLingJiFen(killer, 1)
        --    end
        --end
    end
end, filename)

function add_zhan_ling_ji_fen(actor, num)
    this.addZhanLingJiFen(actor, num)
end

-- 重载配置
GameEvent.add(EventCfg.onReloadScript, function(actor)
    this.sendDataToClient(actor)
end, filename)

-- 登录
GameEvent.add(EventCfg.onLoginEnd, function(actor)
    this.sendDataToClient(actor)
end, filename)

--获取冰封堡战役是否开启
function BingFengBao.isOpen()
    local activityInfo = getactivityinfo(DuplicateType.BING_FENG_BAO) or {}
    local isOpen = activityInfo.open or false
    local canOpen = BingFengBao.CanOpenActivity()
    return isOpen and canOpen
end

function BingFengBao.logout(actor)
    if BingFengBao.getMaster() ~= getbaseinfo(actor, "rid") then
        return
    end
    BingFengBao.setMaster(0)
    BingFengBao.setMasterCurrentUnionId(0)
    API.SetInt(actor, "占领时长", 0)
    API.SetInt(actor, "上次增加积分的时间", 0)
    this.ChangeBuff(actor,false)
end

function BingFengBao.enterMap(actor, mapCfgId)
    if BingFengBao.isOpen() and this.IsPlayerInRoland(actor) then
        --检测角色是否有战盟
        local unionId = getbaseinfo(actor, "guildid")
        if unionId == 0 then
            setplayersetting(actor, 1, 0)
        else
            setplayersetting(actor, 1, 5)
        end
    end
end

-- 获取首次开启时间
function this.GetFirstOpenTime()
    local firstOpenTimeString = string.tonumber(ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.BFG_FIRST_OPEN_TIME))

    local firstOpenTimeStringSplit = string.split(firstOpenTimeString, "#")
    local day = tonumber(firstOpenTimeStringSplit[1])
    local hour =0
    local minute = 0
    return day, hour, minute
end

-- 是否可以开启
function BingFengBao.CanOpenActivity()
    -- local openDays = getbaseinfo("serveropendays")
    -- local day, hour, minute = this.GetFirstOpenTime()
    -- if openDays < day then
    --     return false
    -- end
    return true
end

--获取冰封堡占领者ID
function BingFengBao.getMaster()
    return API.GetDBNum("冰封堡占领者ID")
end

--设置冰封城堡占领者ID
function BingFengBao.setMaster(actorId)
    API.SetDBNum("冰封堡占领者ID", actorId)
end

--获取临时当前占领的战盟ID
function BingFengBao.getMasterCurrentUnionId()
    return API.GetDBNum("冰封堡临时当前占领战盟ID")
end

--设置临时占领的战盟ID
function BingFengBao.setMasterCurrentUnionId(unionId)
    API.SetDBNum("冰封堡临时当前占领战盟ID", unionId)
end


--获取临时占领的战盟ID
function BingFengBao.getMasterLinShiUnionId()
    return API.GetDBNum("冰封堡临时占领战盟ID")
end

--设置临时占领的战盟ID
function BingFengBao.setMasterLinShiUnionId(unionId)
    API.SetDBNum("冰封堡临时占领战盟ID", unionId)
end

--获取城堡归属的战盟ID
function BingFengBao.getMasterUnionId()
    return API.GetDBNum("冰封堡占领战盟ID")
end

--设置城堡归属的战盟ID
function BingFengBao.setMasterUnionId(unionId)
    API.SetDBNum("冰封堡占领战盟ID", unionId)
end

--获取占领积分
function this.getZhanLingJiFen(actor)
    local jifen = API.GetInt(actor, "占领积分")
    return jifen
end

function this.checkAddZhanLingJiFenOnePlayer(actor,rid)
    local jifen = API.GetInt(actor, "占领积分"..rid,0)
    jifen=tonumber(jifen) or 0
    if jifen==0 then
        API.SetInt(actor, "占领积分"..rid,1,0)
    end
    return jifen==0
end

--玩家添加击杀积分 每击杀1人增加1点
function this.addZhanLingJiFen(actor, num)
    local jifen = this.getZhanLingJiFen(actor)
    API.SetInt(actor, "占领积分", jifen + num)


    --存榜
    this.setJiFenRank(actor)
end

--设置占领积分榜
function this.setJiFenRank(actor)
    local tRank = this.getJiFenRank()
    local jifen = this.getZhanLingJiFen(actor)
    if jifen <= 0 then
        return
    end
    local nowTime = os.time()
    local rid = getbaseinfo(actor, "rid")
    local isInRank = false

    if #tRank > 0 then
        for i = 1, #tRank do
            if tRank[i].rid == rid then
                isInRank = i
                break
            end
        end
    end

    if isInRank then
        tRank[isInRank].jifen = jifen
        tRank[isInRank].updateTime = nowTime
    else
        tRank[#tRank + 1] = {}
        tRank[#tRank].rid = rid
        tRank[#tRank].jifen = jifen
        tRank[#tRank].updateTime = nowTime
    end

    table.sort(tRank,
        function(a, b)
            if a.jifen == b.jifen then
                return a.updateTime < b.updateTime
            else
                return a.jifen > b.jifen
            end
        end
    )

    if #tRank > 5 then
        for i = 5 + 1, #tRank do
            table.remove(tRank, i)
        end
    end
    API.SetDBTable("积分占领榜", tRank)
end

--获取本次占领积分榜
function this.getJiFenRank()
    local tRank = API.GetDBTable("积分占领榜") or {}
    return tRank
end

-- 获取所有参与的玩家{actor,...}
function this.GetAllParticipatingPlayers()
    local tab = {}
    local allPlayers = getallplayer()
    for i = 1, #allPlayers do
        local rid = allPlayers[i]
        local actor = getactor(rid)
        table.insert(tab, { actor = actor, rid = rid })
    end
    return tab
end

-- 玩家是否在冰封堡地图中
function BingFengBao.IsPlayerInRoland(actor)
    local mapId = getbaseinfo(actor, "mapid")
    local line = getbaseinfo(actor, "line")
    local mapCfgId = string.splitInt(ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.BFG_OCCUPY_POSITION), "#")[1]
    local cfgLine = string.splitInt(ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.BFG_GO_POSITION), "#")[4]

    if mapId == mapCfgId and line == cfgLine then
        return true
    end
    return false
end

function BingFengBao.checkTransmit(actor, targetMap, targetLine, x, y)
    if not BingFengBao.isOpen() then
        return false
    end
    if BingFengBao.getMaster() == getbaseinfo(actor, "rid") then
        return true, "当前处于冰风堡攻城占领状态，无法传送"
    end

    local mapTbl = ConfigDataManager.getById("cfg_mapMove", 4002)

    local mapCfgId = string.splitInt(ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.BFG_OCCUPY_POSITION), "#")[1]
    local cfgLine = string.splitInt(ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.BFG_GO_POSITION), "#")[4]

    if targetMap == mapCfgId and targetLine == cfgLine and x == tonumber(mapTbl.mapx) and y == tonumber(mapTbl.mapy) then
        --messagebox(actor,"当前处于冰风堡攻城状态，无法传送到该位置")
        return true, "当前处于冰风堡攻城状态，无法传送到该位置"
    end

    return false
end

---------------------------------------------------------- 活动控制相关 -----------------------------------------------------------------

function BingFengBao.activityChange(system, activityId, action)
    if activityId == DuplicateType.BING_FENG_BAO and BingFengBao.CanOpenActivity() then
        if action == 1 then
            BingFengBao.OpenDuplicate(system)
        else
            BingFengBao.CloseDuplicate(system)
        end
    end
end

--系统活动发生变化
--GameEvent.add(EventCfg.onSysTemActivityChange, function(system, activityId, action)
--    if activityId == DuplicateType.ROLAND_SEIGE and BingFengBao.CanOpenActivity() then
--        if action == 1 then
--            BingFengBao.OpenDuplicate(system)
--        else
--            BingFengBao.CloseDuplicate(system)
--        end
--    end
--end, filename)

-- 开启冰封堡战役
function BingFengBao.OpenDuplicate(system)
    --清除活动相关数据  
    BingFengBao.clearData()

    --通知所有玩家 已开启冰攻
    BingFengBao.SendMsgToAllPlayer("",StringIdConst.TEXT56003)
end

function BingFengBao.SendMsgToAllPlayer(msg,msgid,...)
    local allPlayers = this.GetAllParticipatingPlayers()
    local args = { ... }
    for i = 1, #allPlayers do
        local actor = allPlayers[i].actor
      
        if msgid then
            local text = ConfigDataManager.getTableValue("cfg_string", "text", "id", msgid)
            if string.find(text, "%%") then
                local content = noticeTip.strreplace(text)
               
                if #args <= 0 then
                    gameDebug.print("noticeinfo params error", msgid, args)
                    return
                end
                text = string.format(content, ...)
              
            end

            noticeTip.noticeinfo(actor, msgid,...)
            noticeTip.sendMessage(actor, 16, 9, text, NoticeChannel.SYSTEM)
        else
            sendluamsg(actor, LuaMessageIdToClient.HORSE_LAMP, {
                cfgId = 1,
                content = "<color=#ffd119>"..msg.."</color>",
            })
            noticeTip.sendMessage(actor, 16, 9, msg, NoticeChannel.SYSTEM)
           
        end
    end
end

function BingFengBao.SendStartRemainMinutes(gametime, currenttime)
    -- 15分钟更新 频率每5分钟更新一次
    if gametime <= currenttime then
        return
    end

    local currentMinute = math.floor((gametime - currenttime) / 60)
    if currentMinute > 30 then
        return
    end

    if currentMinute > 5 and currentMinute % 5 == 0 then
        this.SendMsgToAllPlayer("",StringIdConst.TEXT56001,tostring(currentMinute))
    elseif currentMinute < 5 and currentMinute > 0 then
        this.SendMsgToAllPlayer("" ,StringIdConst.TEXT56002,tostring(currentMinute))
    end
end

function BingFengBao.SendEndRemainMinutes(gametime, currenttime)
    local endtime = gametime
    if endtime <= 0 then
        return
    end
    -- 10分钟更新 频率每1分钟更新一次
    if endtime <= currenttime then
        return
    end

    local currentMinute = math.floor((endtime - currenttime) / 60)
    if currentMinute > 10 then
        return
    end

    if currentMinute <= 10 and currentMinute > 0 then
        this.SendMsgToAllPlayer("",StringIdConst.TEXT56004,tostring(currentMinute))
    end
end

--[[
为指定角色添加或删除冰风暴相关buff
@param actor 目标角色对象
@param isAddbuff 布尔值，true表示添加buff，false表示删除buff
@buff 100500403 冰风暴buff1
@buff 100500406 冰风暴buff2
]]
function BingFengBao.ChangeBuff(actor,isAddbuff)
    if isAddbuff then
        addbuff(actor,100500403,1,nil, { })
        addbuff(actor,100500406,1,nil, { })
    else
        delbuff(actor,100500403)
        delbuff(actor,100500406)
    end
end

--关闭冰封堡战役
function BingFengBao.CloseDuplicate(system)

    local masterRid = BingFengBao.getMaster() --占领者ID
    local actorName = "无"
    if masterRid ~= 0 then
        local masterActor = getactor(masterRid)
        this.ChangeBuff(masterActor, false)
    end

    local LinShiUnionId = BingFengBao.getMasterLinShiUnionId() --获取临时占领的战盟ID

    local tRank = this.getJiFenRank()
    local nameStr = ""
    for i = 1, #tRank do
        local rid = tRank[i].rid
        local actor = getactor(rid)
        local name = getbaseinfo(actor, "rolename")
        if i == #tRank then
            nameStr = nameStr .. name .. "\\n"
        else
            nameStr = nameStr .. name .. "、"
        end
        if i == 2 and i ~= #tRank then
            nameStr = nameStr .. "\\n"
        end
    end

    if LinShiUnionId ~= 0 then
        local unionname = getunioninfo(LinShiUnionId).unionname
        BingFengBao.SendMsgToAllPlayer("", StringIdConst.TEXT56005, unionname, nameStr)
    else
        BingFengBao.SendMsgToAllPlayer("", StringIdConst.TEXT56006, nameStr)
    end

    BingFengBao.setMasterUnionId(LinShiUnionId) --设置城堡归属的战盟ID

    --计算并且发放奖励
    BingFengBao.sendReward()

    local allPlayers = this.GetAllParticipatingPlayers()
    for i = 1, #allPlayers do
        local actor = allPlayers[i].actor
        if this.IsPlayerInRoland(actor) then
            this.SendData(actor)
        end
    end

end

--计算并且发放奖励
-- 发送冰风堡攻城战的奖励
-- 根据玩家所属战盟和表现发放三种奖励：
-- 1. 优胜奖：仅发放给胜利战盟成员，根据职位分为三档（盟主、管理层、普通成员）
-- 2. 参与奖：发放给所有参与活动的有战盟玩家
-- 3. MVP奖：发放给占领累计时长前五名的玩家
-- 最后为所有参与者开启战令按钮
function BingFengBao.sendReward()
    local allPlayers = this.GetAllParticipatingPlayers()

    local tRank = this.getJiFenRank()
    local rewardData = BingFengBao.getReward()

    local unionId = BingFengBao.getMasterUnionId() --胜利战盟ID
    for i = 1, #allPlayers do
        local tReward = {}
        local actor = allPlayers[i].actor
        -- 检查是否在冰风谷
        local guildid = getbaseinfo(actor, "guildid")
        guildid = tonumber(guildid) or 0
        if this.IsPlayerInRoland(actor) and guildid > 0 then
            -- 优胜奖：	仅为胜利战盟发放。		
            -- 分为三档，对应盟主、管理层（副盟主、战斗队长）、普通成员。		
            -- 每档奖励均可配置。	
            if getbaseinfo(actor, "guildid") == unionId then
                local data = getrolesummaryinfobyrid(actor)
                local unionposition = data.unionposition
                tReward = rewardData.tReward[1][unionposition] or rewardData.tReward[1][0]
                sendconfigmailbyrid(actor, actor:toString(), MailConfig.BFB_VICTORY_AWARD, tReward)

            end

            -- 参与奖：	为活动期间所有有战盟的玩家发放。	
            -- 奖励可配置。
            sendconfigmailbyrid(actor, actor:toString(), MailConfig.BFB_PARTICIPATE_AWARD, rewardData.tReward[2])

            -- mvp奖：	为占领累计时长前五名玩家发放。
            -- 奖励可配置。
            for j = 1, #tRank do
                if getbaseinfo(actor, "rid") == tRank[j].rid then
                    sendconfigmailbyrid(actor, actor:toString(), MailConfig.BFB_MVP_AWARD, rewardData.tReward[3])
                end
            end
            this.openZhanLingButton(actor)
        end
    end
end

--清除活动相关数据
function BingFengBao.clearData()
    --清除占领数据
    local rid = BingFengBao.getMaster()
    if rid ~= 0 then
        API.SetInt(getactor(rid), "占领时长", 0)
        API.SetInt(getactor(rid), "上次增加积分的时间", 0)
        BingFengBao.setMaster(0)
        BingFengBao.setMasterCurrentUnionId(0)
        ZzpTest.print("活动开启，清理数据 取消占领")
    end
    --清除积分榜
    API.SetDBTable("积分占领榜", {})

    --清除占领战盟
    BingFengBao.setMasterLinShiUnionId(0)
    BingFengBao.setMasterUnionId(0)
    BingFengBao.setMasterCurrentUnionId(0)
end

-- 服务器分钟心跳，用于首次开启活动
-- function BingFengBao.ServerMinuteHeart()
--     local seconds = getbaseinfo("nowsec")
--     local now = TimeUtil.timeToDate(seconds)
--     local nowMin = now.min
--     local nowHour = now.hour
--     local day, hour, minute = this.GetFirstOpenTime()
--     if nowHour == hour and nowMin == minute then
--         local openDays = getbaseinfo("serveropendays")
--         if day == openDays then
--             -- 活动是否开启
--             local activityInfo = getactivityinfo(DuplicateType.BING_FENG_BAO)
--             if activityInfo ~= nil then
--                 local isOpen = activityInfo.open
--                 if isOpen then
--                     gameDebug.assertPrintTrace(false, "首次开启冰封堡战役活动已被开启")
--                     return
--                 end
--             end
--             -- 开启活动
--             openactivity(DuplicateType.BING_FENG_BAO)
--         end
--     end
-- end

function BingFengBao.ServerMinuteUpdate()
    if BingFengBao.CanOpenActivity() then
        -- 活动是否开启
        local activityInfo = getactivityinfo(DuplicateType.BING_FENG_BAO)
        if activityInfo ~= nil then
            local startTime = activityInfo.nextopentime
            local endTime = activityInfo.closetime
            local isOpen = activityInfo.open
            if isOpen then
                startTime = activityInfo.opentime
            end
            startTime = math.floor(startTime / 1000)
            endTime = math.floor(endTime / 1000)
            local startTimeObj = TimeUtil.timeToDate(startTime)
            local seconds = getbaseinfo("nowsec")
            local nowtimeobj = TimeUtil.timeToDate(seconds)
            if TimeUtil.datesIsSame(startTimeObj, nowtimeobj) then
                this.SendStartRemainMinutes(startTime, seconds)
                this.SendEndRemainMinutes(endTime, seconds)
            end
        end
    end
end

function BingFengBao.getReward()
    local rewardData = {}
    local guild1 = ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.BFG_CHAMPION_REWARD)
    local guild2 = ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.BFG_DEPUTY_CHAMPION_REWARD)
    local guild3 = ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.BFG_MEMBER_REWARD)
    local guild4 = ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.BFG_PARTICIPATE_REWARD)
    local guild5 = ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.BFG_MVP_REWARD)
    rewardData.tReward = {
        -- 优胜奖
        [1] = {
            --职位编号对应的奖励 1=盟主 2=副盟主 成员不确定是不是0
            [0] = string.toIntIntMap(guild3, "#", "|"),
            --盟主奖励
            [1] = string.toIntIntMap(guild1, "#", "|"),
            --副盟主奖励
            [2] = string.toIntIntMap(guild2, "#", "|")


        },
        -- 参与奖
        [2] = string.toIntIntMap(guild4, "#", "|"),
        -- mvp奖
        [3] = string.toIntIntMap(guild5, "#", "|"),
    }
    return rewardData
end

function BingFengBao.roleSecondHeart(actor)
    BingFengBao.move(actor)
end

function BingFengBao.PlayerRelive(actor)
    if not BingFengBao.IsPlayerInRoland(actor) then
        return
    end
    local bfgDieReviveDot = string.splitInt(ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.BFG_DIE_REVIVE_DOT), "#")
    local mapCfgId = bfgDieReviveDot[1]
    local line = bfgDieReviveDot[2]
    local x = bfgDieReviveDot[3]
    local y = bfgDieReviveDot[4]
    local range = bfgDieReviveDot[4]
    maptransfer(actor, x, y, mapCfgId, line, range, 1)
end

--每秒心跳
function BingFengBao.serverSecondHeart()
    if BingFengBao.isOpen() then
        local rid = BingFengBao.getMaster()
        if rid ~= 0 then
            local actor = getactor(rid)

            if actor ~= nil then
                if  (BingFengBao.IsPlayerInRoland(actor) and this.checkActorIsInZhanLingQv(actor) )then
                    return
                end
                --ZzpTest.print("玩家", actor:toString(), "系统秒 取消占领  走这里了吗","11", BingFengBao.IsPlayerInRoland(actor),"22",this.checkActorIsInZhanLingQv(actor))
                --error(actor, "玩家", actor:toString(), "系统秒 取消占领  走这里了吗", BingFengBao.IsPlayerInRoland(actor), "x", x, "y", y)
                BingFengBao.ChangeBuff(actor,false)
                API.SetInt(actor, "占领时长", 0)
                API.SetInt(actor, "上次增加积分的时间", 0)
            end
            BingFengBao.setMaster(0)
            BingFengBao.setMasterCurrentUnionId(0)
            ZzpTest.print("玩家", actor:toString(), "系统秒 取消占领", actor)
        end
    end
end

MessageRouter:register(LuaMessageIdToSever.REQ_BING_FENG_BAO, function(actor, msgData)
    -- messagebox(actor,"msgID111="..this.msgID)
    -- messagebox(actor,"msgData.sendType="..msgData.sendType)
    -- messagebox(actor,"msgData.sendType="..type(msgData.sendType))
    if msgData.sendType == 1 then
        this.main(actor)
    elseif msgData.sendType == 2 then
        this.SendData(actor)
    elseif msgData.sendType == 3 then
        this.Click(actor, msgData)
    end
    return true
end)

-- -----------------------------------------------------------没有在用的------------------------------------------------------------------

function BingFengBao.open(actor)
    openactivity(DuplicateType.BING_FENG_BAO)
end

function BingFengBao.close(actor)
    closeactivity(DuplicateType.BING_FENG_BAO)
end

function BingFengBao.enter(actor)
    BingFengBao.ReqEnterDupLicate(actor)
end

function BingFengBao.clear(actor)
    BingFengBao.clearData()
end


-- 获取所有参与的战盟
function this.GetAllParticipatingUnions(mapId)
    local allUnion = {}
    local allPlayers = this.GetAllParticipatingPlayers(mapId)
    for _, actor in pairs(allPlayers) do
        local unionId = getbaseinfo(actor, "guildid")
        if not table.contains(allUnion, unionId) then
            table.insert(allUnion, unionId)
        end
    end
    return allUnion
end

-- 获取玩家的阵营
function this.GetCamp(actor, mapId)
    local defendUnionId = this.GetDefendUnionId(mapId)
    local selfUnionId = getbaseinfo(actor, "guildid")
    if tostring(defendUnionId) == tostring(selfUnionId) then
        return RolandConst.CAMP_TYPE.DEFEND
    else
        return RolandConst.CAMP_TYPE.ATTACK
    end
end

-- 玩家退出副本
function BingFengBao.OnQuitDup(actor, mapId, state, nextStateStartTime, configId)
    setplayersetting(actor, 1, 5)
end
