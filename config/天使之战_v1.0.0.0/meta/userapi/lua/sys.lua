function reloadscript(actor)
    local isdbg = getenv("debug");
    if isdbg then
        tipinfo(actor, "lua脚本重新加载")
    end
    if getbaseinfo(actor, "onhook") == 0 then
        GameEvent.push(EventCfg.onReloadScript, actor)
    end
end

function serverminuteheart(sysactor,serverType)
    gameDebug.debug(RolandSeige.ServerMinuteHeart)
    OperationalActivities.checkActive()
    WeekActives.checkActive()
    BigSecretRealm.initPlayerVar()
    MonsterScript.ResetGlobalDecayMboxRecordCheck()
    gameDebug.debug(BingFengBao.ServerMinuteUpdate)
end

function serversecondheart(sysactor,serverType)
    gameDebug.debug(TradeService.flushList)
    --暂时停用，有需要自行开启
    -- GameMapHeart.DoHeart()
    gameDebug.debug(BingFengBao.serverSecondHeart)
end

function server3secondheart(sysactor,serverType)
    
end

function server5secondheart(sysactor,serverType)
    -- Trade.flushWorldGoods()
    Stall.flushStall()
end




--- 服务器小时心跳
function serverhourheart(sysactor,serverType)

end

function servermiddlenight(sysactor,serverType)
    -- 服务器凌晨心跳
    gameDebug.debug(UnionTask.serverMiddleNight)
    -- Trade.serverMiddleNight()
    -- gameDebug.debug(GoldFirstKill.endTimeReward)
    -- gameDebug.debug(AngelBenefit.OnCloseMail)
    -- gameDebug.debug(SevenLogin.sendReward)
    -- gameDebug.debug(LevelReward.sendAllReward)
    -- gameDebug.debug(AngelWeapon.sendReward)
    -- gameDebug.debug(RechargeSevenReceive.sendReward)
    gameDebug.debug(OperationalActivities.checkActive)
    gameDebug.debug(WeekActives.checkActive)
end

function serverminuteclock(sysactor,serverType)
    info("触发整点分钟心跳", TimeUtil.timeFormat(getbaseinfo("nowsec")),serverType)
end

function serverhourclock(sysactor,serverType)
    info("触发整点小时心跳", TimeUtil.timeFormat(getbaseinfo("nowsec")),serverType)
    RankScript.sendReward(serverType)
    if serverType == ServerType.Game then
        RankScript.checkData()
    end
end


function startup(sysactor,host,serverType)
    -- 检测战盟竞选定时任务
    gameDebug.debug(UnionChangeLeader.startInitUnionDelayTask)
    -- gameDebug.debug(UnionArmbands.serverStart)
    -- 战斗公式缓存数据
    -- gameDebug.debug(FightDamageTypeCache.Cache)
    -- 缓存装备锻造大师数据
    gameDebug.debug(EquipMaster.cacheEquipMasterData)
    -- 更新排行榜信息
    gameDebug.debug(RankScript.updateAllRank)
    -- 缓存大师之路数据
    gameDebug.debug(Master.cacheMasterData)
    -- 记录开服时间
    gameDebug.debug(onHook.recordStartTime)
    -- 缓存拍脸预告数据
    gameDebug.debug(FaceShootPreview.CacheConfig)
    -- 初始化默认战盟
    gameDebug.debug(Union.DefaultUnion.initDefaultUnion)
    -- 初始化全局袖珍宝箱
    gameDebug.debug(NpcChest.initGlobalGoods)
    gameDebug.debug(OperationalActivities.checkActive)
    gameDebug.debug(WeekActives.checkActive)
    gameDebug.debug(EquipAndAppear.getAttrSpecial)
    gameDebug.debug(CareerTask.initLevelCareerRange)
end
