function combineglobalvar(sysactor, varName, varData)
    if string.equalsIgnoreCase(varName, SYS_RECHARGE_INFO) then
        --无需在处理
    -- elseif string.equalsIgnoreCase(varName, SYS_TRADE_WORLD_GOODS) then
    --     Trade.combineglobalvar(varName,varData)
    elseif string.equalsIgnoreCase(varName, ROLE_STALL_START) then
        Stall.combineglobalvar(varName,varData)
    elseif string.equalsIgnoreCase(varName, PlayerDefKey.UNION.GLOBAL_DEFAULT_UNION_CREATE_DATA_KEY) then
        Union.combineglobalvar(varName)

    elseif string.equalsIgnoreCase(varName, AuctionConst.CAN_REWARD_UNIONS) then
        Auction.combineGlobalVar(varName, varData)
    elseif string.equalsIgnoreCase(varName, CURRENT_ACTIVE) then
        --- 清除活动
        OperationalActivities.combine()
        --- 检测当前是否有活动开启
        OperationalActivities.checkActive()
    elseif string.equalsIgnoreCase(varName, CURRENT_WEEKEN_ACTIVE) then
        --- 清除活动
        WeekActives.combine()
        --- 检测当前是否有活动开启
        WeekActives.checkActive()
    elseif string.equalsIgnoreCase(varName, SystemVarConst.ROLAND_SEIGE.LAST_OCCUPY_UNION_ID) then
        setsysvar(SystemVarConst.ROLAND_SEIGE.LAST_OCCUPY_UNION_ID, 0)
    elseif string.equalsIgnoreCase(varName, KunDun.KUN_DUN_TAG) then
        KunDun.combine()
    elseif string.equalsIgnoreCase(varName, SystemVarConst.BIG_SECRET_REALM_INIT_VAR) then
        BigSecretRealm.combine()
    elseif string.equalsIgnoreCase(varName, SystemVarConst.FIRST_DROP_GLOBAL_RECORD) then
        FirstDrop.combineGlobalVar(varData)
    else
        error("该全局变量未定义合并逻辑", varName)
    end
end

function combineserver()
    info("执行合服时触发")
    -- 排行榜全服刷新
    RankScript.updateAllRank()
    Player.resetAllKillPlayerCount()
end
