local this = {}

local envDebug = nil

function handlerequest(actor, uid, msgID, msgData)
    info("handlerequest-msgid", actor, msgID, msgData)
    envDebug = envDebug or getenv("debug")
    if envDebug and actor ~= nil and actor:toString() ~= "0" then
        local last_lua_message = {
            ["uid"]     = uid,
            ["msgID"]   = msgID,
            ["msgData"] = msgData
        }
        setplaydef(actor, "J$gm_last_lua", last_lua_message)
    end
    --error("角色加成方式")
    --error(msgID)
    -- 发送客户端GM指令 SL:SendLuaNetMsg(1,{})  可运行到这里
    if msgID == 1 then
        -- rolelist =  getrolelist(actor,uid)
        -- print(rolelist)
    elseif msgID == 2 then
        -- setsysvar("G1",100)
        -- result =  getsysvar("G1")
        -- print(result)
        -- 装备相关
    elseif msgID == LuaMessageIdToSever.SETTING_EQUIP_APPEAR then
        EquipAndAppear.settingequipappear(actor, msgData)        -- 保存装备外观|幻化
    elseif msgID == LuaMessageIdToSever.GET_EQUIP_APPEAR then
        EquipAndAppear.getequipappear(actor, msgID)              -- 获取装备外观
    elseif msgID == LuaMessageIdToSever.EQUIP_FASHION then
        EquipAndAppear.equipfashion(actor, msgData)              -- 装备幻化
    elseif msgID == LuaMessageIdToSever.ACT_EQUIP_COLOR then
        EquipAndAppear.actquipcolor(actor, msgData)              -- 装备染色
    elseif msgID == LuaMessageIdToSever.GET_EQUIP_COLOR then
        EquipAndAppear.getequipcolor(actor, msgID)               -- 获取装备染色信息
    elseif msgID == LuaMessageIdToSever.SETTING_EQUIP_COLOR then
        EquipAndAppear.settingequipcolor(actor, msgData)         -- 保存装备染色
    elseif msgID == LuaMessageIdToSever.REQ_ITEM_DECOMPOSITION then
        ItemRecycling.decompositionlua(actor, msgID, msgData)    -- 装备分解
    elseif msgID == LuaMessageIdToSever.GET_TITLE then
        EquipAndAppear.gettitleinfo(actor, msgID)                -- 获取称号信息
    elseif msgID == LuaMessageIdToSever.SET_TITLE then
        EquipAndAppear.settingtitleappear(actor, msgID, msgData) -- 设置当前称号
    elseif msgID == LuaMessageIdToSever.GET_SHAPE_RING then
        EquipAndAppear.getshapering(actor, msgID)                -- 获取变身戒指信息
    elseif msgID == LuaMessageIdToSever.GET_GUARD_APPEAR then
        EquipAndAppear.getguardappear(actor, msgID)              -- 获取守护皮肤信息
    elseif msgID == LuaMessageIdToSever.SET_SHAPE_RING then
        EquipAndAppear.wearshapering(actor, msgData)             -- 穿戴变身戒指
    elseif msgID == LuaMessageIdToSever.REQ_STRENGTH_EQUIP then
        EquipAndAppear.luastrengthequip(actor, msgData)          -- 请求装备强化
    elseif msgID == LuaMessageIdToSever.REQ_APPEND_EQUIP then
        EquipAndAppear.luaappendequip(actor, msgData)            -- 请求装备追加
    elseif msgID == LuaMessageIdToSever.REQ_EQUIP_FASHION then
        EquipAndAppear.getallequipfashion(actor)                 -- 请求已激活幻化外观
    elseif msgID == LuaMessageIdToSever.REQ_UPDATE_EQUIP_ORNAMENTS then
        EquipAndAppear.ssupdate(actor, msgData)                  -- 请求首饰升级
    elseif msgID == LuaMessageIdToSever.REQ_EQUIP_REGENERATION then
        EquipAndAppear.regeneration(actor, msgData)              -- 请求装备再生
    elseif msgID == LuaMessageIdToSever.REQ_UP_EQUIP_REGENERATION then
        EquipAndAppear.getupregenerationattr(actor, msgData)     -- 请求装备上次洗练数据
    elseif msgID == LuaMessageIdToSever.REQ_REPLACE_REGENERATION_ATTR then
        EquipAndAppear.confirmreplaceentry(actor, msgData)       -- 请求替换装备再生属性
    elseif msgID == LuaMessageIdToSever.REQ_STRENGTH_REGENERATION_ATTR then
        EquipAndAppear.strengthregenerationattr(actor, msgData)  -- 请求强化装备再生属性
    elseif msgID == LuaMessageIdToSever.REQ_ACT_EQUIP_ORNAMENTS then
        EquipAndAppear.actssattr(actor, msgData)                 -- 请求首饰属性激活
    elseif msgID == LuaMessageIdToSever.REQ_TRANSFER_EQUIP then
        -- 装备相关结束
        EquipAndAppear.luatransferequip(actor, msgData)      -- 请求装备属性转移
    elseif msgID == LuaMessageIdToSever.GET_TEAM_RECRUIT then
        Team.getteamrecruitlua(actor, msgID)                 -- 获取组队喊话信息
    elseif msgID == LuaMessageIdToSever.LEADER_AGREE_APPLY then
        Team.leaderAgreeApply(actor, msgID)                  -- 队长一键同意申请记录
    elseif msgID == LuaMessageIdToSever.GET_RESET_FRUIT_COUNT then
        FruitScript.toGetResetCount(actor)                   -- 获取重置果实次数
    elseif msgID == LuaMessageIdToSever.S_RESET_FRUIT then
        FruitScript.resetFruit(actor, msgData)               -- 重置果实
    elseif msgID == LuaMessageIdToSever.GET_MOUNSTER_COUNT_BY_MAP then
        DuplicateCommon.getmonstercountbymap(actor, msgData) -- 根据地图信息获取怪物数量
    elseif msgID == LuaMessageIdToSever.SET_FRIEND_DEGREE then
        Friend.sendflower(actor, msgID, msgData)             -- 好友送花
    elseif msgID == LuaMessageIdToSever.GET_DEVIL_SQUARE_PANEL then
        DevilSquare.ReqGetPanelInfo(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_RECIVE_DEVIL_SQUARE_REWARD then
        DevilSquare.ReqReciveRewardDevilSquare(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_ENTER_DUPLICATE then
        DuplicateCommon.ReqEnterDupLicate(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_QUIT_DUPLICATE then
        DuplicateCommon.ReqQuitDuplicate(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_CHANGE_DUPLICATE_STATE then
        DuplicateCommon.ReqChangeDupState(actor, msgData)
    elseif msgID == LuaMessageIdToSever.GET_DAILY_ACTIVITY_INFO then
        DailyActivity.getActivityInfo(actor)
    elseif msgID == LuaMessageIdToSever.GET_DAILY_ACTIVITY_REWARD then
        DailyActivity.receiveBoxReward(actor, msgData)
    elseif msgID == LuaMessageIdToSever.GET_DAILY_ACTIVITY_ACTIVITY_LIST then
        DailyActivity.getActivityList(actor)
    elseif msgID == LuaMessageIdToSever.LOAD_RANK_DATA then
        RankScript.loadRankData(actor, msgData)             -- 请求排行榜数据
    elseif msgID == LuaMessageIdToSever.STOP_REFRESH_RANK_DATA then
        RankScript.stopRefreshData(actor)                   -- 停止自动刷新排行榜数据
    elseif msgID == LuaMessageIdToSever.PLAYER_IS_ON_LINE_REQ then
        Chat.playerIsOnLineReq(actor, msgData)              -- 玩家是否在线
    elseif msgID == LuaMessageIdToSever.RECRUIT_INFO_REQ then
        Chat.reqRecruitInfo(actor, msgData)                 -- 发送招募信息
    -- elseif msgID == LuaMessageIdToSever.GET_GOLD_TASK_INFO then
    --     GoldTask.SendTaskInfo(actor)
    -- elseif msgID == LuaMessageIdToSever.FLUSH_GOLD_TASK_POOL then
    --     GoldTask.FlushGoldTaskPool(actor)
    -- elseif msgID == LuaMessageIdToSever.ACCEPT_GOLD_TASK then
    --     GoldTask.AcceptTask(actor, msgData)
    -- elseif msgID == LuaMessageIdToSever.SUBMIT_GOLD_TASK then
    --     GoldTask.SubmitTask(actor, msgData)
    -- elseif msgID == LuaMessageIdToSever.GIVE_UP_GOLD_TASK then
    --     GoldTask.GiveUpTask(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_BLOODY_CASTLE_PANEL then
        BloodyCastle.ReqGetPanelInfo(actor, msgData) -- 请求血色城堡面板
    elseif msgID == LuaMessageIdToSever.REQ_GET_ACTIVITY_COUNT then
        DuplicateCommon.ReqGetActivityLeftCount(actor, msgData) -- 请求活动剩余次数
    elseif msgID == LuaMessageIdToSever.REQ_EQUIP_OVERLAY then
        EquipOverlay.reqEquipOverlay(actor, msgData)
    elseif msgID == LuaMessageIdToSever.GET_ALREADY_USE_POINTS then
        FruitScript.toGetAlreadyUsePoints(actor)        -- 获取已经使用的点数
    elseif msgID == LuaMessageIdToSever.REQ_BLOODY_CASTLE_GIVE_NPC then
        BloodyCastle.ReqGive2NPC(actor)                 -- 给武器给NPC
    elseif msgID == LuaMessageIdToSever.REQ_GET_UNION_INFO then
        UnionChangeLeader.sendUnionInfo(actor)
    elseif msgID == LuaMessageIdToSever.REQ_UNION_ACTIVITY_DATA then
        Union.UnionActivity.getUnionActivity(actor)
    elseif msgID == LuaMessageIdToSever.REQ_RECIVE_BLOODY_CASTLE_SETTLEMENT then
        BloodyCastle.ReqReciveReward(actor, msgData)
    elseif msgID == LuaMessageIdToSever.MONSTER_ATTACK_BOSS_INFO then
        MonAtk.reqMonsterInfo(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_CHANGE_DUPLICATE_TEAM_STATE then
        DuplicateTeam.changeTeamPrepareState(actor, msgData) -- 修改副本队伍状态
    elseif msgID == LuaMessageIdToSever.REQ_UNION_RUN_FOR_LEADER_DATA then
        UnionChangeLeader.RunForLeader.getRunForLeaderData(actor)
    elseif msgID == LuaMessageIdToSever.REQ_PLAYER_RUN_FOR_LEADER then
        UnionChangeLeader.RunForLeader.actorRunForLeader(actor)
    elseif msgID == LuaMessageIdToSever.REQ_PLAYER_RUN_FOR_LEADER_VOTE then
        UnionChangeLeader.RunForLeader.actorVoteRunForLeader(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_DUPLICATE_TEAM_ENTER then
        DuplicateTeam.leaderDoTeamEnter(actor)     -- 组队进入副本
    elseif msgID == LuaMessageIdToSever.REQ_SET_ROLE_ATT_ADD_WAY then
        RoleAttr.setRoleAttAddWay(actor, msgData) -- 设置角色属性加成方式
    elseif msgID == LuaMessageIdToSever.REQ_GET_ROLE_ATT_ADD_WAY then
        RoleAttr.getRoleAttAddWay(actor)                           -- 获取角色属性加成方式
    elseif msgID == LuaMessageIdToSever.REQ_ITEM_SYNTHESIS then
        ItemSynthesis.synthesis(actor, msgData)                    -- 装备合成
    -- elseif msgID == LuaMessageIdToSever.REQ_GET_UNION_ARMBAND_INFO then
    --     UnionArmbands.sendArmbandInfo(actor)                       -- 获取ArmBand信息
    -- elseif msgID == LuaMessageIdToSever.REQ_UNION_ARMBAND_LEVEL_UP then
    --     UnionArmbands.levelupUnionArmband(actor)                   -- 升级ArmBand
    -- elseif msgID == LuaMessageIdToSever.REQ_UNION_ARMBAND_STRONG then
    --     UnionArmbands.strongArmband(actor)                         -- 强化ArmBand
    elseif msgID == LuaMessageIdToSever.REQ_TRADE_LISTING_GOODS then
        -- Trade.worldTradeListing(actor, msgData)                    -- 交易行上架商品
        TradeService.listItem(actor,msgData)
    elseif msgID == LuaMessageIdToSever.REQ_TRADE_OFF_GOODS then
        -- Trade.worldOffShelfGoods(actor, msgData)                   -- 交易行下架商品
        TradeService.delistedGood(actor,msgData)
    elseif msgID == LuaMessageIdToSever.REQ_GET_TRADE_GOODS then
        -- Trade.getTradeWorldGoods(actor, msgData)                   -- 交易行搜索商品信息
        TradeService.getListingGoods(actor, msgData)
    -- elseif msgID == LuaMessageIdToSever.REQ_TRADE_PUBLICITY_GOODS then
    --     Trade.getPublicityGoods(actor, msgData)                    -- 交易行获取公示区域商品
    -- elseif msgID == LuaMessageIdToSever.REQ_TRADE_MY_PRE_GOODS then
    --     Trade.getPreBuyGoods(actor, msgData)                       -- 交易行获取预购
    elseif msgID == LuaMessageIdToSever.REQ_TRADE_BUY_GOODS then
        -- Trade.bugWorldGoods(actor, msgData)                        -- 交易行购买商品
        TradeService.buyGood(actor,msgData)
    elseif msgID == LuaMessageIdToSever.REQ_TRADE_RECORD then
        -- Trade.getWorldTradeRecord(actor)                           -- 交易行交易记录
        TradeService.getWorldTradeRecord(actor)
    elseif msgID == LuaMessageIdToSever.REQ_TRADE_MY_SHELVES then
        -- Trade.getWorldMyListing(actor)                             -- 交易行上架商品信息
        TradeService.getWorldMyListing(actor)
    elseif msgID == LuaMessageIdToSever.REQ_TRADE_PRE_ORDER then
        -- Trade.preWorldGoods(actor, msgData)                        -- 交易行预购商品
        TradeService.preWorldGoods(actor,msgData)
    elseif msgID == LuaMessageIdToSever.REQ_GET_UNION_IMPEACH_INFO then
        UnionChangeLeader.Impeach.sendImpeachInfo(actor)           -- 获取弹劾信息
    elseif msgID == LuaMessageIdToSever.REQ_UNION_IMPEACH_LEADER then
        UnionChangeLeader.Impeach.actorImpeach(actor)              -- 弹劾盟主
    elseif msgID == LuaMessageIdToSever.REQ_UNION_IMPEACH_VOTE then
        UnionChangeLeader.Impeach.actorVoteImpeach(actor, msgData) -- 弹劾投票
    -- elseif msgID == LuaMessageIdToSever.REQ_BOSS_BOUNTY_DATA then
    --     BossBounty.GetBountyInfo(actor)
    -- elseif msgID == LuaMessageIdToSever.REQ_BOUNTY_MONSTER_REWARD then
    --     BossBounty.ReqReceiveMonsterAward(actor, msgData)
    -- elseif msgID == LuaMessageIdToSever.REQ_BOUNTY_GROUP_REWARD then
    --     BossBounty.ReqReceiveGroupAward(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_TRADE_GOODS_INFO then
        -- Trade.getGoodsInfo(actor, msgData)
        TradeService.getGoodsInfo(actor,msgData)
    elseif msgID == LuaMessageIdToSever.REQ_WAR_ALLIANCE_PANEL_INFO then
        WarAlliance.GetWarAlliancePanelInfo(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_WAR_ALLIANCE_GOODS_DETAIL then
        Auction.GetGoodsDetailInfo(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_WAR_ALLIANCE_BID_GOODS then
        Auction.PlayerBidOnItem(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_WAR_ALLIANCE_BUY_NOW then
        Auction.PlayerBuyNow(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_WAR_ALLIANCE_UPDATE_GOODS then
        Auction.GetSomeGoods(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_OFFLINE_ON_HOOK_INFO then
        onHook.getOffLineOnHookInfo(actor)              -- 请求获取离线挂机信息
    elseif msgID == LuaMessageIdToSever.REQ_RECEIVE_OFFLINE_ON_HOOK_EXP then
        onHook.reqReceiveOfflineOnHookExp(actor)        -- 请求领取离线挂机经验
    elseif msgID == LuaMessageIdToSever.REQ_MASTER_INFO then
        Master.reqMasterInfo(actor, msgData)            -- 请求：大师信息
    -- elseif msgID == LuaMessageIdToSever.REQ_OPEN_MASTER_TYPE then
    --    Master.reqOpenMasterType(actor, msgData)        -- -- 请求：启用大师系列
    --elseif msgID == LuaMessageIdToSever.REQ_EXCHANGE_MASTER_EXP then
    --    Master.reqExchangeMasterExp(actor, msgData)     -- 请求：兑换大师经验
    --elseif msgID == LuaMessageIdToSever.REQ_RESET_MASTER then
    --    Master.reqResetMaster(actor, msgData)           -- 请求：重置大师天赋
    elseif msgID == LuaMessageIdToSever.REQ_UPGRADE_MASTER_TALENT then
        Master.reqUpgradeMasterTalent(actor, msgData)   -- 请求：升级大师天赋
    elseif msgID == LuaMessageIdToSever.REQ_ENTER_WAR_ALLIANCE then
        WarAlliance.ReqEnterWarAlliance(actor, msgData) -- 请求进入战盟boss副本
    elseif msgID == LuaMessageIdToSever.REQ_GET_MONTH_PRIVILEGE_DATA then
        PrivilegeMonth.sendPrivilegeData(actor)
    elseif msgID == LuaMessageIdToSever.REQ_CHECK_MONTH_PRIVILEGE_IS_OPEN then
        PrivilegeMonth.sendHasPrivilege(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_EXIT_WAR_ALLIANCE then
        WarAlliance.reqExitWarAlliance(actor)
    elseif msgID == LuaMessageIdToSever.REQ_MAP_INFO then
        GoldLine.GetGoldMapInfo(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_GET_ROLE_ATTR_POINT_PROGRAMME then
        RoleAttr.getPrivilegeAttrPointProgramme(actor)
    elseif msgID == LuaMessageIdToSever.REQ_SET_ROLE_ATTR_POINT_PROGRAMME then
        RoleAttr.setPrivilegeAttrPointProgramme(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_CHANGE_ROLE_ATTR_POINT_PROGRAMME then
        RoleAttr.changePrivilegeAttrPointProgramme(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_WAR_ALLIANCE_HAS_QUALIFY then
        Auction.ShowAutionPanel(actor)
    elseif msgID == LuaMessageIdToSever.REQ_UNION_TASK_DATA then
        UnionMemberTask.sendUnionTaskData(actor)
    elseif msgID == LuaMessageIdToSever.REQ_SUBMIT_UNION_TASK then
        UnionMemberTask.submitUnionTask(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_MONSTER_COUNT_BY_ID then
        DuplicateCommon.getmonstercountbyid(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_GOTO_CROSS_MAP then
        CrossMap.Enter(actor)
    elseif msgID == LuaMessageIdToSever.REQ_SCHEME_INFO then
        -- EquipGem.schemeInfo(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_GEM_PUT_ON then
        EquipGem.putOnGemOrSlabstone(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_GEM_TAKE_OFF then
        EquipGem.takeOffGemOrSlabstone(actor, msgData)
    -- elseif msgID == LuaMessageIdToSever.REQ_SCHEME_SWITCH then
        -- EquipGem.schemeSwitch(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_KUNDUN_ENTER then
        KunDun.EnterKunDun(actor, msgData)
    -- elseif msgID == LuaMessageIdToSever.REQ_GODS_DESCENDED_DATA then
    --     GodsDescended.sendMonsterStateData(actor)
    elseif msgID == LuaMessageIdToSever.REQ_WOLF_SOUL_SUMMON then
        WolfSoul.ReqSummonWarder(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_STALL_POSITION then
        Stall.stallPosition(actor, msgData)                    -- 获取摆摊信息
    elseif msgID == LuaMessageIdToSever.REQ_START_STALL then
        Stall.startStall(actor, msgData)                       -- 开始摆摊
    elseif msgID == LuaMessageIdToSever.REQ_END_STALL then
        Stall.endStall(actor, msgData)                         -- 结束摆摊
    elseif msgID == LuaMessageIdToSever.REQ_STALL_GOODS then
        Stall.getStallGoods(actor, msgData)                    -- 获取摊位商品信息
    elseif msgID == LuaMessageIdToSever.REQ_DELETE_BAG_ITEM then
        Stall.deleteItem(actor, msgData)                       -- 减少背包内道具的数量
    elseif msgID == LuaMessageIdToSever.REQ_SET_PATROL then
        -- onHook.setOfflineState(actor, msgData)                 -- 设置离线挂机状态
    elseif msgID == LuaMessageIdToSever.REQ_ITEM_RECOVERY then
        ItemRecycling.recovery(actor, msgData)                 -- 装备回收
    elseif msgID == LuaMessageIdToSever.REQ_CANCEL_FSPREVIEW then
        FaceShootPreview.ReqCancelTodayPreview(actor, msgData) -- 拍照预告取消今日提醒
    elseif msgID == LuaMessageIdToSever.REQ_RECHARGE then
        Recharge.request(actor, msgData)                       -- 充值请求
    elseif msgID == LuaMessageIdToSever.REQ_CHANGE_ROLE_NAME then
        Player.changeRoleName(actor, msgData)                  -- 修改角色名字
    elseif msgID == LuaMessageIdToSever.REQ_CHANGE_UNION_NAME then
        Union.changeUnionName(actor, msgData)                  -- 修改战盟名字
    elseif msgID == LuaMessageIdToSever.REQ_ROLE_IS_FIRST_CHANGE_NAME then
        Player.getRoleChangeNameInfo(actor)                    -- 获取角色是否为首次改名
    -- elseif msgID == LuaMessageIdToSever.REQ_RECHARGE_TRADE_INFO then
    --     Trade.sendRecharge(actor)                              -- 发送月卡充值信息
    elseif msgID == LuaMessageIdToSever.REQ_COMBO_SKILL_UP then
        Skill.ComboSkillUp(actor)                              -- 升级连击技能
    -- elseif msgID == LuaMessageIdToSever.REQ_OTHER_GEM_EQUIP_INFO then
        -- EquipGem.getOtherGemScheme(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_RECHARGE_ACTION then
        Recharge.requestAction(actor, msgData)
    -- elseif msgID == LuaMessageIdToSever.REQ_ALL_SERVER_FIRST_KILL_INFO then
    --     GoldFirstKill.getFirstKillInfo(actor)
    -- elseif msgID == LuaMessageIdToSever.REQ_RECEIVE_FIRST_KILL_ENVELOPE then
    --     GoldFirstKill.receiveFirstKillAward(actor, msgData)
    -- elseif msgID == LuaMessageIdToSever.REQ_RECEIVE_PERSONAL_FIRST_KILL_AWARD then
    --     GoldFirstKill.SubmitTask(actor, msgData)
    -- elseif msgID == LuaMessageIdToSever.REQ_ANGLE_BENEFIT_INFO then
    --     AngelBenefit.getAllAngleBenefitInfo(actor)
    -- elseif msgID == LuaMessageIdToSever.REQ_RECEIVE_ANGLE_BENEFIT_REWARD then
    --     AngelBenefit.receiveScoreReward(actor, msgData)
    -- elseif msgID == LuaMessageIdToSever.REQ_SUBMIT_ANGLE_BENEFIT_TASK then
    --     AngelBenefit.submitTask(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_RECEIVE_LOGIN_REWARD then
        SevenLogin.receiveLoginReward(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_RECEIVE_RECHARGE_LOGIN_REWARD then
        RechargeSevenReceive.receiveLoginReward(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_RECEIVE_ANGEL_WEAPON_REWARD then
        AngelWeapon.receiveTaskReward(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_PERSONAL_LEVEL_REWARD_INFO then
        LevelReward.getLevelRewardInfo(actor)
    elseif msgID == LuaMessageIdToSever.REQ_RECEIVE_LEVEL_REWARD then
        LevelReward.receiveLevelReward(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_GENERATE_VERIFICATION_CODE then
        DailyLotteryDraw.generateVerificationCode(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_BIND_PHONE then
        DailyLotteryDraw.bindPhone(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_LUCK_DRAW then
        DailyLotteryDraw.luckDraw(actor)
    elseif msgID == LuaMessageIdToSever.REQ_LUCK_DRAW_INFO then
        DailyLotteryDraw.sendInfo(actor)
    elseif msgID == LuaMessageIdToSever.REQ_WINGS_TASK_INFO then
        -- Wings.SendWingsTask(actor)
    elseif msgID == LuaMessageIdToSever.REQ_SUBMIT_WINGS_TASK then
        -- Wings.SubmitChapterTask(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_RECEIVE_WINGS_CHAPTER_AWARD then
        -- Wings.ReceiveChapterAward(actor)
    elseif msgID == LuaMessageIdToSever.REQ_ANGEL_TALENT then
        AngelMajorTalent.getTalentInfo(actor)
    elseif msgID == LuaMessageIdToSever.REQ_ADD_ANGEL_TALENT_POINT then
        AngelMajorTalent.addTalentPoint(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_RESET_ANGEL_TALENT_POINT then
        AngelMajorTalent.resetTalentPoint(actor)
    elseif msgID == LuaMessageIdToSever.REQ_ACTIVE_ANGEL_TALENT then
        AngelMajorTalent.activateTalent(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_NPC_CHEST_GOODS_INFO then
        NpcChest.sendShopGoodsInfoList(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_BUY_NPC_CHEST then
        NpcChest.buyGoods(actor, msgData)
    elseif msgID == LuaMessageIdToSever.COMBO_TEST_PANEL_INFO then
        ComboTest.ReqComboTestPanelInfo(actor)
    elseif msgID == LuaMessageIdToSever.COMBO_TEST_REWARD then
        ComboTest.rewardByLevel(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_SWEEP_THROUGH_DUNGEONS then
        DuplicateCommon.sweepThroughDungeons(actor, msgData[1], msgData[2])
    elseif msgID == LuaMessageIdToSever.REQ_BIG_SECRET_REALM_PANEL_INFO then
        BigSecretRealm.getPanelInfo(actor)
    elseif msgID == LuaMessageIdToSever.REQ_BIG_SECRET_REALM_CHANGE_RECEIVE_STATUS then
        BigSecretRealm.setReceiveStatus(actor)
    elseif msgID == LuaMessageIdToSever.REQ_BIG_SECRET_REALM_KEY_LEVEL_UP then
        BigSecretRealm.keyLevelUp(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_BIG_SECRET_REALM_RECEIVE_REWARD then
        BigSecretRealm.receiveReward(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_TRANSFER_WITHIN_MAP then
        MapMoveTransfer.transferWithinMap(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_SETTING_RECYCLING_TYPE then
        ItemRecycling.setItemRecyclingType(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_GET_RECYCLING_TYPE then
        ItemRecycling.getItemRecyclingType(actor)
    elseif msgID == LuaMessageIdToSever.REQ_BIG_SECRET_REALM_SWEEP then
        BigSecretRealm.sweep(actor, msgData)
    -- elseif msgID == LuaMessageIdToSever.REQ_SANCTUARY_BOSS_ENTER_MAP then
    --     SanctuaryBoss.enterMap(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_CROSS_MAP_TRANSFER_TO_NPC then
        CrossMap.Transfer2NPC(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_USE_SELF_CHOICE_BOX then
        UseSelfChoiceBox.use(actor, msgData)
    -- elseif msgID == LuaMessageIdToSever.REQ_MONSTER_HUNT_RANK then
    --     MonsterHunt.RankList(actor)
    -- elseif msgID == LuaMessageIdToSever.REQ_MONSTER_HUNT_INFO then
    --     MonsterHunt.Info(actor)
    elseif msgID == LuaMessageIdToSever.REQ_MAIN_ACTIVE_INFO then
        OperationalActivities.openSubActive(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_CHANGE_SKIP_ANIMATION then
        TurntableRaffle.changeSkipAnimation(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_TURNTABLE_RAFFLE_DRAWING then
        TurntableRaffle.drawing(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_RECEIVE_TURNTABLE_RAFFLE_REWARD then
        TurntableRaffle.receiveAccumulateReward(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_TURNTABLE_REWARD_COUNT_INFO then
        TurntableRaffle.getRewardCountInfo(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_WEEK_CHANGE_SKIP_ANIMATION then
        WeekTurntableRaffle.changeSkipAnimation(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_WEEK_TURNTABLE_RAFFLE_DRAWING then
        WeekTurntableRaffle.drawing(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_WEEK_RECEIVE_TURNTABLE_RAFFLE_REWARD then
        WeekTurntableRaffle.receiveAccumulateReward(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_WEEK_TURNTABLE_REWARD_COUNT_INFO then
        WeekTurntableRaffle.getRewardCountInfo(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_ROLAND_SEIGE_GET_MAIN_PANEL then
        RolandSeige.ReqMainPanel(actor)
    elseif msgID == LuaMessageIdToSever.REQ_KUN_DUN_AUCTION_BIDDING then
        KunDunAuction.PlayerBidding(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_UPDATE_ROLE_SETTING then
        RoleSetting.updateState(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_CUSTOME_TRANSFER then
        CustomTransmit.DoTransmit(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_TARGET_VIP_LV then
        RoleSetting.getTargetVipLv(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_CLOSE_DEMON_HERMIT_SKILL then
        Skill.closeDemonHermitSkill(actor)
    elseif msgID == LuaMessageIdToSever.REQ_WEEKEN_ACTIVE_INFO then
        WeekActives.openSubActive(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_CAREER_TRANSFER then
        PlayerCareerTransfer.careerTransfer(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_FIRST_DROP_PANEL then
        FirstDrop.reqPanle(actor)
    elseif msgID == LuaMessageIdToSever.REQ_ACTIVITY_INFO then
        Activity.ActivityChange(actor, msgData)
    elseif msgID == 90001025 then
        LianJi.onHandlereQuest(actor, msgData)
    elseif msgID == TaskLoopManager.msgID then
        TaskLoopManager.onHandlereQuest(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_SET_SHORTCUTS then
        Shortcut.setGuard(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_EQUIP_REPAIR then
        EquipDurability.reqEquipRepair(actor, msgData, false)
    elseif msgID == LuaMessageIdToSever.REQ_EQUIP_AUTO_REPAIR then
        EquipDurability.changeAutoRepair(actor)
    elseif msgID == LuaMessageIdToSever.REQ_PICK_UP_NAMES then
        PickUpItem.setPickName(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_ACTIVATE_EQUIP_LUCKY then
        Equip_XingYun.XingYun(actor, msgData)
     elseif msgID == LuaMessageIdToSever.REQ_AUTO_BUY_POTION_OPTION then
        AutoBuyPotionScript.setBuyOption(actor, msgData)
    elseif msgID == LuaMessageIdToSever.REQ_VIEW_PANEL_TASK then
        TaskHandler.TriggerTaskGoal(actor, TaskTargetType.VIEW_CLIENT_PANEL, msgData.panelId)
    elseif msgID == LuaMessageIdToSever.REQ_CHECK_DELETE_ROLE then
        Player.reqCanDeleteRole(uid)
    elseif msgID == LuaMessageIdToSever.REQ_GET_TEAM_MEMBER_POSITION then
        Team.reqGetTeamMemberPosition(actor)
    elseif msgID == LuaMessageIdToSever.KALIMA_TEMP_PANEL_INFO then
        KalimaTemp.ReqComboTestPanelInfo(actor)
    else
        MessageRouter:triggerType(msgID, actor, msgData)
    end
end

function login(play)
    -- local info = getrolelist(play,getbaseinfo(play, "uid"))--local 自定义变量 = 接口事件名称（默认参数【自定义名称】，参数1，参数2...）
    -- error(info)--打印返回数据
    setcddelay(play,0.15)
    GameEvent.push(EventCfg.onLoginEnd, play)
    gameDebug.debug(CountManager.login, play)
    gameDebug.debug(DailyActivity.login, play)
    gameDebug.debug(Activity.LogIn, play)
    gameDebug.debug(EquipGuard.login, play)
    -- gameDebug.debug(GoldFirstKill.login, play)
    gameDebug.debug(Union.sendLeaderOnlineStateMsg, play)
    -- gameDebug.debug(Wings.Login, play)
    gameDebug.debug(PrivilegeMonth.login, play)
    gameDebug.debug(Master.login, play)
    gameDebug.debug(onHook.login, play)
    gameDebug.debug(CrossMap.EnterView, play, play)
    --gameDebug.debug( EquipAndAppear.playerequipstrength(play,0)
    --gameDebug.debug( Trade.sendRecharge, play)
    gameDebug.debug(TaskHandler.sendTaskState, play)
    gameDebug.debug(PreferentialGift.CheckPreferentialGift, play)
    LoginEventListerTable:triggerEvent("0", play)
    gameDebug.debug(ExpBoost.login, play)
    gameDebug.debug(DailyLotteryDraw.login, play)
    gameDebug.debug(SevenLogin.login, play)
    gameDebug.debug(RechargeSevenReceive.login, play)
    gameDebug.debug(LevelReward.login, play)
    gameDebug.debug(AngelWeapon.login, play)
    gameDebug.debug(AngelMajorTalent.sendActiveTalentInfo, play)
    gameDebug.debug(ComboTest.login, play)
    gameDebug.debug(BigSecretRealm.login, play)
    gameDebug.debug(Player.UpdateFightValue, play)
    gameDebug.debug(HpMpRecover.recover, play)
    gameDebug.debug(RoleSetting.login, play)
    gameDebug.debug(EquipAndAppear.login, play)
    gameDebug.debug(FruitScript.toGetAlreadyUsePoints, play)
    gameDebug.debug(AutoBuyPotionScript.sendBuyOption, play)
    gameDebug.debug(MonsterScript.loginAddBuff, play)
    gameDebug.debug(onHook.setOfflineState, play, 4)
    gameDebug.debug(TradeService.loginCheck,play)
    --gameDebug.debug( OperationalActivities.openActive, play)
end

function exit(actor)
    jprint("exit事件触发")
    info(actor, "exit事件触发") 
    -- gameDebug.debug(Pet.ClearPet, actor)
    local time = getbaseinfo("now")
    setplaydef(actor, "T$offlinetime", time)
    Skill.closeDemonHermitSkill(actor)
    onhookstop(actor)
end

function logout(actor)
    info(actor, "logout事件触发")
    onHook.logout(actor)
    gameDebug.debug(Player.UpdateFightValue, actor)
    gameDebug.debug(Skill.closeDemonHermitSkill, actor)
    gameDebug.debug(FaceToFaceTrade.onPlayerLogout, actor)
    OfflineOnHookFSM.clearPickUpItems(actor)
    onHook.canHook(actor)
    gameDebug.debug(BingFengBao.logout, actor)
    gameDebug.debug(DuplicateTeam.logout, actor)
    gameDebug.debug(Pet.ClearPet, actor)
    
end


function run(actor)
    --测试内网，看看能不能更新上去
end

function walk(actor)
end

function jump(actor)

end

function removeskillevent(actor, removeSkillList)

end

function releaseskill(actor, skillid, skilllevel, targetlist)

    if not EquipDurability.canRelease(actor) then
        return false
    end

    if not AGAndSD.CanRelease(actor, skillid, skilllevel) then
        return false
    end

    local success, errorInfo = xpcall(Skill.addSkillCD, debug.traceback, actor, skillid, skilllevel)
    if not success then
        error("技能加CD错误！！！", actor:toString(), skillid, skilllevel)
        return false
    end
   

    if LianJi.checkOpen(actor) then
        -- 记录连击技能
        local comboTypes = ConfigDataManager.getTableValue("cfg_skill", "comboType", "id", skillid) or ""
        if string.isNullOrEmpty(comboTypes) then
            -- 不是连击技能
            API.SetTable(actor, VarCfg.ZC_ComboSkillInfo, {}, 1)
        else
            local nowMillis = getbaseinfo("now")
            local comboTable = API.GetTable(actor, VarCfg.ZC_ComboSkillInfo, 1) or {}
            if string.contains(comboTypes, "" .. LianJi.comboType.qishou) then
                API.SetTable(actor, VarCfg.ZC_ComboSkillInfo, { nowMillis = nowMillis, type = LianJi.comboType.qishou, skillId = skillid }, 1)
            else
                API.SetTable(actor, VarCfg.ZC_ComboSkillInfo, {}, 1)
            end
            if next(comboTable) then
                -- 3秒内
                if nowMillis - comboTable.nowMillis <= 3000 then
                    if comboTable.type == LianJi.comboType.qishou and string.contains(comboTypes, "" .. LianJi.comboType.xianjie) then
                        -- 上一个是起手技，这次是衔接技
                        API.SetTable(actor, VarCfg.ZC_ComboSkillInfo, { nowMillis = nowMillis, type = LianJi.comboType.xianjie, skillId = skillid }, 1)
                    elseif comboTable.type == LianJi.comboType.xianjie and string.contains(comboTypes, "" .. LianJi.comboType.zhongjie) and comboTable.skillId ~= skillid then
                        -- 上一个是衔接技，这次是终结技，且不同的技能
                        API.SetTable(actor, VarCfg.ZC_ComboSkillInfo, { isCombo = 1, nowMillis = nowMillis, type = LianJi.comboType.zhongjie, skillId = skillid }, 1)
                    end
                end
            end
        end
    end

    
    Skill.releaseSkill(actor, skillid)
    return true
end

function triggertaskrefresh(actor, type, param)
    --统一走lua触发任务刷新接口
    TaskHandler.TriggerTaskGoal(actor, type, param)
end

function levelup(actor, level, oldlevel)
    LevelUpEventListerTable:triggerEvent("0", actor, level)
    RoleAttr.levelup(actor, level, oldlevel)
    CareerTask.roleLevelUp(actor, level, oldlevel)
    --处理职业解锁
    CareerUnlock.unlock(actor, level)
    -- Wings.TryInitWingsTask(actor)
    Master.levelup(actor, level, oldlevel)
    -- Mail.levelUp(actor, level)
    Buffer.levelUp(actor, level)
    PreferentialGift.CheckPreferentialGift(actor)
    SevenLogin.updateLoginInfo(actor)
    RechargeSevenReceive.updateLoginInfo(actor)
    RankScript.updateByType(actor, RANK_TYPES.levelType)
    Privilege.conditionActPrivilege(actor)
    Team.levelUp(actor)
end

function taskprogresscomplete(actor, taskId)
    Mail.taskComplete(actor, taskId)
    Buffer.taskProgressComplete(actor, taskId)
end

function taskcomplete(actor, taskId)
    FaceShootPreview.TaskCompleted(actor, taskId)
end

-- @description 玩家活动改变事件
-- @param 玩家对象；活动id；1-开启，0-关闭
-- @return
function activitychange(actor, activityId, action)
    Activity.ActivityChange(actor, activityId, action)
end

-- @description 开启活动，系统执行
-- @param 系统对象，id和mapid均为0；活动id；1-开启，0-关闭
-- @return
function systemactivitychange(system, activityId, action)
    if MonAtk.isMonAtkActivity(tonumber(activityId)) then
        MonAtk.run(activityId, action)
    elseif tonumber(activityId) == DuplicateType.WAR_ALLIANCE and tonumber(action) == 0 then
        WarAlliance.ClearThisTimeGameData()
    elseif tonumber(activityId) == DuplicateType.WOLF_SOUL and tonumber(action) == 1 then
        WolfSoul.OpenDuplicate(system)
    -- elseif tonumber(activityId) == DuplicateType.GODS_DESCENDED then
    --     GodsDescended.sysActivityChange(activityId, action)
    elseif tonumber(activityId) == DuplicateType.KUN_DUN then
        KunDun.Run(action)
    elseif activityId == DuplicateType.ROLAND_SEIGE and action == 1 then
        -- 罗兰峡谷攻城战活动开启
        RolandSeige.OpenDuplicate(system)
    elseif activityId == DuplicateType.BING_FENG_BAO then
        BingFengBao.activityChange(system, activityId, action)
    end
end


---击杀玩家事件
---@param actor any 攻击玩家对象
---@param diePlayer any 死亡玩家对象
function killplayer(actor, diePlayer)
    gameDebug.debug(PKSystem.onPlayerKilled, actor, diePlayer)
    Friend.enemyaddbefore(diePlayer, actor)
    RedFortress.KillPlayer(actor, diePlayer)
    UnionTask.killPlayerEvent(actor, diePlayer)
    KunDun.KillPlayer(actor, diePlayer)
    RolandSeige.KillPlayer(actor, diePlayer)
    gameDebug.debug(Player.killPlayer, actor, diePlayer)
end

---玩家被攻击事件
---@param actor any 玩家对象
---@param fightParam any 被攻击参数 caster：攻击者对象、target：被攻击者对象、mapid：地图id、skillid：技能id、skilllevel：技能等级、castertype：攻击者类型、targettype：被攻击者类型
function underattack(actor, fightParam)
    RoleAttr.hurtRecoverHpMp(actor, fightParam)
    EquipGem.setGemRecovery(actor, fightParam)
    MonsterScript.OnUnderAttack(actor, fightParam)
    StateManager.judgeHpMp(actor)
end

---击杀怪物事件
---@param actor any 玩家对象
---@param monsterId any 怪物唯一ID
---@param monsterCfgId number 怪物configId
---@param monsterName string 怪物名称
---@param pointX number 怪物X坐标
---@param pointY number 怪物Y坐标
---@param activityId number 活动id
---@param monsterLevel number 怪物等级
function killmon(actor, monsterId, monsterCfgId, monsterName, pointX, pointY, activityId, monsterLevel, mongenCfgId)
    gameDebug.debug(RoleAttr.killMonsterRecoverHpMp, actor)
    gameDebug.debug(PKSystem.onMonsterKilled,actor, monsterCfgId,monsterLevel)
    GameEvent.push(EventCfg.onKillMon, actor, monsterId, monsterCfgId, monsterName, monsterLevel, pointX, pointY)
    UnionTask.killMonsterEvent(actor, monsterCfgId)
end

---使用道具事件
---@param actor any 玩家对象
---@param itemConfigId number 道具configId
---@param count number 使用数量
function useitemtrigger(actor, itemConfigId, count)
    local itemInfo = (ConfigDataManager.getTable("cfg_item", "id", itemConfigId) or { [1] = {} })[1]
    if table.isNullOrEmpty(itemInfo) then
        return
    end
    gameDebug.debug(PKSystem.onItemUsed,actor, itemConfigId)
    gameDebug.debug(EquipAndAppear.useItem, actor, itemInfo)
    gameDebug.debug(CareerChange.useItemChangeCareer, actor, itemConfigId)
    GameEvent.push(EventCfg.onUseItem, actor, itemConfigId, count, itemInfo.name)
    FruitScript.handleUseFruit(actor, itemConfigId, count)                 -- 果实使用后处理
    RandomChest.generateChestItem(actor, itemConfigId, count)              -- 随机宝箱生成道具
    ExpBoost.useExperienceBoostItem(actor, itemConfigId, count)            -- 经验加成道具处理
    -- PrivilegeMonth.usePrivilegeCard(actor, itemConfigId, count)            -- 特权卡使用处理
    EliteMM.use(actor, itemConfigId)
    --掉落倍率道具使用处理
    MonsterScript.useDropRateItem(actor, itemConfigId, count)
    gameDebug.debug(Master.useItem, actor, itemConfigId, count)
end

---玩家转职事件
---@param actor any 玩家对象
---@param transferCareerNum number 转职次数
---@param careerName string 转职名称
function transfercareer(actor, transferCareerNum, careerName)
    RoleAttr.transferCareer(actor, careerName)
    CareerTask.transferCareer(actor)
    RankScript.updateSelfData(actor, RANK_FIELD_TYPE.career)
    local roleName = getrolefield(actor, "role.basic.name")
    -- 转职成功发送公告消息
    noticeTip.noticeinfo(actor, StringIdConst.JOB_CHANGE, roleName, transferCareerNum, careerName)
end

---玩家进入视野事件
---@param actor any 玩家对象
---@param targetPlayer any 进入视野的玩家对象
function playerenterview(actor, targetPlayer)
    gameDebug.debug(PKSystem.playerEnterView, actor, targetPlayer)
    gameDebug.debug(Skill.playerEnterView, actor, targetPlayer)
    DuplicateCommon.PlayerEnterView(actor, targetPlayer) -- 副本中玩家进入视野
    EquipAndAppear.playerequipview(actor, targetPlayer)
    CrossMap.EnterView(actor, targetPlayer)
    SceneMap.playerEnterView(actor, targetPlayer)
    Skill.playerequipview(actor, targetPlayer)
    -- EquipAndAppear.playerequipstrength(actor, targetPlayer) --玩家进入视野发送装备强化信息
end

--- 怪物进入视野事件
---@param actor any 玩家对象
---@param monsterActor any 怪物对象
---@param monsterCfgId number 怪物configId
function monsterenterview(actor, monsterActor, monsterCfgId)
    MonsterScript.MonsterEnterView(actor, monsterActor, monsterCfgId)
end

--- 穿戴装备后触发
function takeonequip(actor, pos, oldItemId, itemId, itemCfgId, wearBar, oldItemList)
    gameDebug.debug(EquipAndAppear.equipChange, actor)
    gameDebug.debug(EquipChart.equipChange, actor, itemCfgId)
    gameDebug.debug(EquipGuard.putGuardEquip, actor, itemCfgId)
    gameDebug.debug(EquipAndAppear.checkCanTransfer, actor, oldItemId, itemCfgId)
    gameDebug.debug(EquipMaster.triggerEquipMaster, actor)
    gameDebug.debug(EquipAndAppear.updateluaextattr, actor)
    gameDebug.debug(this.equipchangeflushtask, actor, pos, itemId)
    gameDebug.debug(AngelWeapon.updateTaskInfo, actor)
    gameDebug.debug(Shortcut.afterPuton, actor, itemCfgId)
    gameDebug.debug(EquipGem.updateGemAttr, actor)
    -- 调整剑士双持武器属性
    gameDebug.debug(EquipAndAppear.updateAdjustEquipAttr, actor, pos, wearBar,itemCfgId)
    gameDebug.debug(Equip_JiNeng.updateSkill, actor)
    gameDebug.debug(Master.refreshMasterTalentAttr, actor)

    -- 这行必须是最后一个，新增往上放
    gameDebug.debug(EquipAndAppear.specialAttrUpdate, actor)
end

--- 脱下装备后触发
function takeoffequip(actor, pos, itemId, itemCfgId, wearBar)
    gameDebug.debug(EquipAndAppear.equipChange, actor)
    gameDebug.debug(EquipChart.equipChange, actor, itemCfgId)
    EquipGuard.takeOffGuardEquip(actor, itemCfgId)
    EquipMaster.triggerEquipMaster(actor)
    EquipAndAppear.updateluaextattr(actor)
    gameDebug.debug(Equip_JiNeng.updateSkill, actor)
    gameDebug.debug(EquipGem.updateGemAttr, actor)
    -- EquipAndAppear.playerequipstrength(actor, 0) --发送玩家装备强化信息
    -- 刷新装备任务进度
    this.equipchangeflushtask(actor, pos, itemId)
    AngelWeapon.updateTaskInfo(actor)
    Shortcut.afterTakeOff(actor, itemCfgId)
    gameDebug.debug(EquipAndAppear.updateAdjustEquipAttr, actor, pos, wearBar)
    gameDebug.debug(Master.refreshMasterTalentAttr, actor)
    -- 这行必须是最后一个，新增往上放
    gameDebug.debug(EquipAndAppear.specialAttrUpdate, actor)
end

function weaponchange(actor, oldIndex, newIndex, itemId)
    local res = { oldIndex = oldIndex, newIndex = newIndex, itemId = itemId }
    sendluamsg(actor, LuaMessageIdToClient.RES_WEAPON_CHANGE_AUTO, res)
end

function this.equipchangeflushtask(actor)
    TaskHandler.TriggerTaskGoal(actor, TaskTargetType.EQUIP_APPEND)
    TaskHandler.TriggerTaskGoal(actor, TaskTargetType.PARTS_STRENGTHEN_LV)
    TaskHandler.TriggerTaskGoal(actor, TaskTargetType.JEWELRY_LV_UP)
    TaskHandler.TriggerTaskGoal(actor, TaskTargetType.EXCELLENCE_ATTR)
    TaskHandler.TriggerTaskGoal(actor, TaskTargetType.EQUIP_EXCELLENCE_ATTR_COUNT)
    TaskHandler.TriggerTaskGoal(actor, TaskTargetType.EQUIP_APPEND_TOTAL_LV)
    TaskHandler.TriggerTaskGoal(actor, TaskTargetType.SPECIFIC_STAGE_EQUIP)
    TaskHandler.TriggerTaskGoal(actor, TaskTargetType.INLAID_GEMSTONES)
    TaskHandler.TriggerTaskGoal(actor, TaskTargetType.TAKE_ON_GRAIL_COUNT)
    TaskHandler.TriggerTaskGoal(actor, TaskTargetType.STRENGTHEN_GRAIL)
end

-- 装备生效事件   是否生效 通过参数的布尔值判断
function equipeffectbyboolean(actor, map, effect)
    -- 获取影响的装备位置
    local effectPos = {}
    for k, v in pairs(map) do
        table.insert(effectPos, gameequip.pos(k))
    end
    -- sendluamsg(actor, LuaMessageIdToClient.RES_GEM_SCHEME, { ["触发了生效事件"] = map })
end

--[[function itemchange(actor, ids, cfgId, oldCount, newCount, change)
-- 请在batchitemchange事件中处理相关逻辑
end]]

--物品变化
function batchitemchange(actor, itemChangeList)
    local function doAutoUse(player, itemCfgId, count)
        local autoUse = ConfigDataManager.getTableValue("cfg_item", "autouse", "id", itemCfgId)
        if not string.isNullOrEmpty(autoUse) then
            local useItemAtt = ConfigDataManager.getTableValue("cfg_item", "useitematt", "id", itemCfgId)
            if not string.isNullOrEmpty(useItemAtt) then
                local att = string.splitInt(useItemAtt, "#")
                local i, v = att[1], att[2]
                local attName = attrid2name(actor, i)
                if not string.isNullOrEmpty(attName) then
                    local has = getattrinfo(actor, attName)
                    if has >= v then
                        useitembycfgid(player, itemCfgId, count)
                    end
                end
            else
                useitembycfgid(player, itemCfgId, count)
            end
        end
    end
    --- 物品变化
    local function itemchangeOne(actor, ids, cfgId, oldCount, newCount, change)
        --EquipGuard.initGuardEquip(actor, ids, cfgId, oldCount, newCount)
        -- 任务进度刷新
        if tonumber(oldCount) < tonumber(newCount) then
            local count = tonumber(newCount) - tonumber(oldCount)
            TaskHandler.TriggerTaskGoal(actor, TaskTargetType.RE_GET_ITEM, { cfgId, count })
        end
        if newCount > oldCount then
            AutoBuyPotionScript.coinChange(actor, cfgId)
            -- Privilege.getPrivilegeCard(actor, cfgId, newCount - oldCount)
            doAutoUse(actor, cfgId, newCount - oldCount)
            --装备萤石孔位需要外置生成
            EquipGem.EquipToBag(actor, ids[1], cfgId)
            EquipGem.GenerateGemEntries(actor, ids[1], cfgId)
        end

        -- 道具变少触发
        if newCount < oldCount then
            Shortcut.itemChange(actor, cfgId, newCount)
        end
    end

    for _, itemChangeInfo in pairs(itemChangeList) do
        itemchangeOne(actor,
                itemChangeInfo.ids,
                itemChangeInfo.cfgid,
                itemChangeInfo.oldcount,
                itemChangeInfo.newcount,
                itemChangeInfo.change)
    end
end


function addmonthcardbefore(actor, cfgId, count)

end

-- 不入包的道具获取
function nobagitemchange(actor, itemList)
    for _, itemInfo in pairs(itemList) do
        EquipAndAppear.titleenterbag(actor, itemInfo.cfgid)
    end
end

-- @description 副本阶段更新
-- @param 系统id；地图唯一id；副本类型；副本阶段(1-准备 2-战斗 3-结算)；下一阶段开始时间戳；配置id(cfg_rep的id)
-- @return
function dupstateupdate(system, id, dupType, state, nextStateStartTime, configId)
    if dupType == DuplicateType.DEVIL_SQUARE then
        -- 恶魔广场
        DevilSquare.DevilSquareStateUpdate(system, id, state, nextStateStartTime, configId)
    elseif dupType == DuplicateType.BLOODY_CASTLE then
        -- 血色城堡
        BloodyCastle.BloodyCastleStateUpdate(system, id, state, nextStateStartTime, configId)
    elseif dupType == DuplicateType.RED_FORTRESS then
        -- 赤色要塞
        RedFortress.RedFortressStateUpdate(system, id, state, nextStateStartTime, configId)
    elseif dupType == DuplicateType.WAR_ALLIANCE then
        -- 战盟boss
        WarAlliance.WarAllianceStateUpdate(system, id, state, nextStateStartTime, configId)
    elseif dupType == DuplicateType.WOLF_SOUL then
        WolfSoul.DupStateUpdate(system, id, state, nextStateStartTime, configId)
    elseif dupType == DuplicateType.KUN_DUN then
        KunDun.DupStateUpdate(system, id, state, nextStateStartTime, configId)
    elseif dupType == DuplicateType.COMBO_TEST then
        ComboTest.ComboStateUpdate(system, id, state, nextStateStartTime, configId)
    elseif dupType == DuplicateType.BIG_SECRET_REALM then
        BigSecretRealm.DupStateUpdate(system, id, state, nextStateStartTime, configId)
    elseif dupType == DuplicateType.ROLAND_SEIGE then
        RolandSeige.DupStateUpdate(system, id, state, nextStateStartTime, configId)
    elseif dupType == DuplicateType.KALIMA_TEMP then
        KalimaTemp.ComboStateUpdate(system, id, state, nextStateStartTime, configId)
    end
end

-- @description 副本秒钟心跳
-- @param
-- @
function duplicatesecondheart(system)
    local mapId = getbaseinfo(system, "unimapid")
    local dupInfo = getduplicate(mapId)
    if dupInfo == nil then
        return
    end
    local dupType = dupInfo["type"]
    local state = dupInfo["state"]
    local dupConfig = dupInfo["dupcfgid"]
    if dupType == DuplicateType.WOLF_SOUL then
        WolfSoul.SecondHeart(mapId, dupConfig, state)
    elseif dupType == DuplicateType.ROLAND_SEIGE then
        RolandSeige.DupSecondHeart(mapId, dupConfig, state)
    elseif dupType == DuplicateType.KUN_DUN then
        KunDun.DupSecondHeart(mapId, dupConfig, state)
    elseif dupType == DuplicateType.DEVIL_SQUARE then
        DevilSquare.DupSecondHeart(mapId, dupConfig, state)
    elseif dupType == DuplicateType.BLOODY_CASTLE then
        BloodyCastle.DupSecondHeart(mapId, dupConfig, state)
    end
end

-- 副本3秒钟心跳
function duplicate3secondheart(system)
    local mapId = getbaseinfo(system, "unimapid")
    local dupInfo = getduplicate(mapId)
    if dupInfo == nil then
        return
    end
    local dupType = dupInfo["type"]
    local state = dupInfo["state"]
    local dupConfig = dupInfo["dupcfgid"]
    if dupType == DuplicateType.ROLAND_SEIGE then
        RolandSeige.Dup3SecondHeart(mapId, dupConfig, state)
    end
end

-- 副本5秒钟心跳
function duplicate5secondheart(system)
    local mapId = getbaseinfo(system, "unimapid")
    local dupInfo = getduplicate(mapId)
    if dupInfo == nil then
        return
    end
    local dupType = dupInfo["type"]
    local state = dupInfo["state"]
    local dupConfig = dupInfo["dupcfgid"]
    if dupType == DuplicateType.RED_FORTRESS then
        RedFortress.Dup5SecondHeart(mapId, dupConfig, state)
    end
end

-- @description 怪物死亡掉落经验事件，归属者触发，主要处理怪物经验
-- @param 归属者;默认掉落经验；怪物配置id;x坐标;y坐标
-- @return 经验值
function monsterdieexp(actor, exp, monCfgId, monsterId, x, y)
    local mapId = getbaseinfo(actor, "unimapid")

    local mapInfo = getmapinfobyid(mapId)

    -- 指定地图增加经验倍率
    local map_exp_rate = ConfigDataManager.getTableValue("cfg_map_info", "exprate", "id", mapInfo.cfgid)
    if string.tonumber(map_exp_rate) > 0 then
        exp = exp * (1 + map_exp_rate / 100)
    end


    local finalExp = exp

    local share, teamExp = Team.getShareExp(actor, monsterId, exp,monCfgId)
    if share then
        return teamExp
    end
    -- 经验衰减
    local decayRate = MonsterScript.GetExpDecayRate(actor, monCfgId)
    finalExp = math.round(finalExp * decayRate)
    return finalExp
end

-- function getexp(actor, originExp, fromType, innerAddRate)
--     if fromType == 2 then
--         local teamExpBonus = Team.getExpBonus(actor)
--         return originExp * teamExpBonus
--     end
-- end


function getexpafter(actor, exp, fromType)
    if fromType == 2 then
        local mapId = getbaseinfo(actor, "unimapid")
        local dupInfo = getduplicate(mapId)
        if dupInfo ~= nil then
            local dupType = dupInfo["type"]
            if dupType == DuplicateType.DEVIL_SQUARE then
                DevilSquare.AddExp(actor, mapId, exp)
            elseif dupType == DuplicateType.BLOODY_CASTLE then
                BloodyCastle.AddExp(actor, mapId, exp)
            end
        end
    end
end

-- @description 玩家进入副本事件
-- @param 玩家对象；地图唯一id；副本类型；副本阶段(1-准备 2-战斗 3-结算)；下一阶段开始时间戳；配置id(cfg_rep的id)
-- @return
function afterenterduplicate(actor, mapId, dupType, state, nextStateStartTime, configId)
    if dupType == DuplicateType.DEVIL_SQUARE then
        -- 恶魔广场
        DevilSquare.AfterPlayerEnterDevilSquare(actor, mapId, state, nextStateStartTime, configId)
    elseif dupType == DuplicateType.BLOODY_CASTLE then
        -- 血色城堡
        BloodyCastle.AfterPlayerBloodyCaster(actor, mapId, state, nextStateStartTime, configId)
    elseif dupType == DuplicateType.RED_FORTRESS then
        -- 赤色要塞
        RedFortress.AfterRedFortressEnter(actor, mapId, state, nextStateStartTime, configId)
    elseif dupType == DuplicateType.WAR_ALLIANCE then
        -- 战盟boss
        WarAlliance.AfterEnterWarAlliance(actor, mapId, state, nextStateStartTime, configId)
    elseif dupType == DuplicateType.WOLF_SOUL then
        -- 狼魂要塞
        WolfSoul.AfterEnterWolfSoul(actor, mapId, state, nextStateStartTime, configId)
    elseif dupType == DuplicateType.COMBO_TEST then
        -- 连击试炼
        ComboTest.AfterEnterComboTest(actor, mapId, state, nextStateStartTime, configId)
    elseif dupType == DuplicateType.BIG_SECRET_REALM then
        -- 大秘境副本
        BigSecretRealm.AfterEnterBigSecretRealm(actor, mapId, state, nextStateStartTime, configId)
    elseif dupType == DuplicateType.ROLAND_SEIGE then
        -- 罗兰峡谷攻城战
        RolandSeige.AfterEnterRoland(actor, mapId, state, nextStateStartTime, configId)
    elseif dupType == DuplicateType.KUN_DUN then
        -- 昆顿
        KunDun.AfterEnterKunDun(actor, mapId, state, nextStateStartTime, configId)
    elseif dupType == DuplicateType.KALIMA_TEMP then
        -- 卡利马神庙
        KalimaTemp.AfterEnterComboTest(actor, mapId, state, nextStateStartTime, configId)
    end

    -- 进入副本后 刷新战盟任务
    UnionTask.enterDuplicate(actor, configId)
end

-- @description 退出副本事件
-- @param 玩家对象；地图唯一id；副本类型；副本阶段(1-准备 2-战斗 3-结算)；下一阶段开始时间戳；配置id(cfg_rep的id)
-- @return
function afterquitduplicate(actor, mapId, dupType, state, nextStateStartTime, configId)
    sendluamsg(actor, LuaMessageIdToClient.RES_QUIT_DUPLICATE, configId)
    if dupType == DuplicateType.RED_FORTRESS then
        -- 赤色要塞
        RedFortress.AfterRedFortressQuit(actor, mapId, state, nextStateStartTime, configId)
    elseif dupType == DuplicateType.ROLAND_SEIGE then
        -- 罗兰攻城战
        RolandSeige.OnQuitDup(actor, mapId, state, nextStateStartTime, configId)
    end
end

-- @description 玩家进入地图事件(所有地图，包括普通地图)
-- @param 玩家对象；上一个地图配置id；当前地图配置id
-- @return
function entermap(actor, lastMapCfgId, mapCfgId)
    gameDebug.debug(TaskHandler.TriggerTaskGoal, actor, TaskTargetType.ENTER_MAP_LINE)
    gameDebug.debug(DevilSquare.EnterAllMapDS, actor, lastMapCfgId, mapCfgId)
    gameDebug.debug(BloodyCastle.EnterAllMapDS, actor, lastMapCfgId, mapCfgId)
    gameDebug.debug(RedFortress.EnterAllMap, actor, lastMapCfgId, mapCfgId)
    gameDebug.debug(CrossMap.CheckEnterCrossMap, actor, lastMapCfgId, mapCfgId)
    gameDebug.debug(TaskHandler.sendTaskState, actor)
    gameDebug.debug(RoleAttr.enterMap, actor, mapCfgId)
    gameDebug.debug(BingFengBao.enterMap, actor, mapCfgId)
end

function leavemap(actor, reason)
    gameDebug.debug(HpMpRecover.record, actor)
end

-- @description 地图怪物死亡事件,此时怪物还未从副本中移除
-- @param 系统对象；地图唯一id；击杀者对象；死亡怪物的配置id
-- @return
function mapmonsterdie(system, mapId, killer, monCfgId, monActor)
       --怪物死亡触发活动、任务等功能数据更新
    MonsterScript.MonsterDieTrigger(monActor, { mapid = mapId, monstercfg= monCfgId,killer=killer:toString()})

    -- 昆顿怪物死亡
    KunDun.MonsterDie(mapId, killer, monCfgId, monActor)
    if table.getKey(CountDownMonsterIds, monCfgId) then
        setsysvar(monActor, "G$_monsterDieTime" .. tostring(monCfgId), os.time())
    end
    local mapInfo = getmapinfobyid(mapId)
    if mapInfo["isdup"] == true then
        -- 是副本
        local dupInfo = getduplicate(mapId)
        local dupType = dupInfo["type"]
        if dupType == DuplicateType.DEVIL_SQUARE then
            DevilSquare.KillMonterInDevilSquare(killer,mapId,monCfgId)
        elseif dupType == DuplicateType.BLOODY_CASTLE then
            BloodyCastle.BloodyCastleOnMonsterDie(mapId, killer, monCfgId)
        elseif dupType == DuplicateType.WAR_ALLIANCE then
            callonserial(killer, "waralliancemonsterdie", mapId, killer, monCfgId)
        elseif dupType == DuplicateType.COMBO_TEST then
            ComboTest.ComboTestMonsterDie(mapId, killer, monCfgId, monActor)
        elseif dupType == DuplicateType.BIG_SECRET_REALM then
            BigSecretRealm.BigSecretRealmMonsterDie(mapId, killer, monCfgId, monActor)
        elseif dupType == DuplicateType.KALIMA_TEMP then
            KalimaTemp.ComboTestMonsterDie(mapId, killer, monCfgId, monActor)
        end
    end
    local monData = MonsterExtData.get(monActor)
    monData.beAttackedList = {}
    monData:save(monActor)
end

function waralliancemonsterdie(killer, mapId, acotr, monCfgId)
    WarAlliance.OnKillWarAllianceMonster(mapId, acotr, monCfgId)
end

-- @description 地图怪物死亡事件,此时怪物已经从副本中移除
-- @param 系统对象；地图唯一id；击杀者对象；死亡怪物的配置id
-- @return
function mapmonsterremove(system, mapId, killer, monCfgId)
    local mapInfo = getmapinfobyid(mapId)
    if mapInfo["isdup"] == true then
        -- 是副本
        local dupInfo = getduplicate(mapId)
        local dupType = dupInfo["type"]
        if dupType == DuplicateType.RED_FORTRESS then
            RedFortress.OnMonsterDie(mapId, killer)
        elseif dupType == DuplicateType.WOLF_SOUL then
            WolfSoul.MapMonsterRemove(mapId, killer, monCfgId)
        elseif dupType == DuplicateType.ROLAND_SEIGE then
            RolandSeige.MapMonsterRemove(mapId, killer, monCfgId)
        end
    end
end

-- @description 用药之后触发自动买药
-- @param 玩家对象
-- @return
function autobuydrug(actor)
    -- 触发自动买药
    AutoBuyPotionScript.autoBuyPotions(actor)
end

---跑马灯事件
---@param actor any 玩家对象
---@param stringId number cfg_string表配置id
---@param text string 跑马灯消息文本
function horselampevent(actor, stringId, ...)
    noticeTip.noticeinfo(actor, stringId, ...)
end

function pickupitembefore(actor, items)
    local function pickUpItem(actor, items)
        local allow = MonAtk.pickUpItem(actor, items)
        if allow ~= nil then
            return allow
        end
        return nil
    end

    local offlinePickLog = {}
    local isOffline = isofflineplay(actor)
    local result = {}
    for _, item in pairs(items) do
        local ret = pickUpItem(actor, { item })
        if ret == nil then
            ret = { allow = true }
        end
        result[item.id] = ret
        local auto = item.auto
        if auto then
            if isOffline then
                local cfgid = item.cfgid
                local count = ret.count or item.count
                offlinePickLog[cfgid] = (offlinePickLog[cfgid] or 0) + count
            end
        end
    end
    if not table.isEmpty(offlinePickLog) then
        -- gameDebug.print(actor, "玩家拾取物品，物品列表：", offlinePickLog)
        OfflineOnHookFSM.writePickUpItem(actor, offlinePickLog)
    end
    return result
end


function pickupitem(actor, itemCfgId, itemId, count, luaExtDta)
    if not table.isNullOrEmpty(luaExtDta) then
        -- 宝箱掉落道具拾取
        if luaExtDta.fromBox then
            local dropRecord = PlayerBoxDropRecord.get(actor)
            dropRecord:removeDropItem(itemId, luaExtDta.dropId)
            dropRecord:save(actor)
            info("玩家拾取宝箱掉落道具，dropId：" .. (luaExtDta.dropId) .. "，道具ID：" .. itemCfgId .. "，数量：" .. count)
        end
    end
end



-- 物品拾取前触发
--[[function pickupitemfrontex(actor, items)
    --请使用 pickupitembefore 替代
    local allow = MonAtk.pickUpItem(actor, items)
    if allow ~= nil then
        return allow
    end
    return nil
end]]

-- 怪物死亡掉落物品
function monsterdiedropitem(actor, data)
    MonAtk.monsterDieDrop(actor, data)
    MonsterScript.monsterDieDropTip(actor, data)
end

-- 丢道具
function dropitemfrontex(actor, cfgId, id, rid)
    CustomTransmit.throwsItem(actor, cfgId, id, rid)
end

-- @description 背包变化事件
-- @param 玩家对象 索引  放入或 取出
-- @return
function bagchange(actor, index, state)
    -- 取出物品触发自动买药
    if state == 0 then
        AutoBuyPotionScript.autoBuyPotions(actor)
    end
end

-- 玩家死亡
function playdie(actor, dieInfo, killInfo)
    gameDebug.debug(PKSystem.onPlayerDie, actor, dieInfo, killInfo)
    gameDebug.debug(DuplicateCommon.playerDie, actor, dieInfo, killInfo)
    Pet.ClearPet(actor)
    ComboTest.playerDie(actor)
    RedFortress.PlayerDie(actor)
    GameEvent.push(EventCfg.onPlaydie, actor, dieInfo, killInfo)
    gameDebug.debug(FaceToFaceTrade.onPlayerDie, actor)
end

---装备回收事件
function recovery(actor, data, reward)
    ItemRecycling.recyclingRateReward(actor, reward)
    TaskHandler.TriggerTaskGoal(actor, TaskTargetType.RECOVERY, data)
    TaskHandler.TriggerTaskGoal(actor, TaskTargetType.RECOVERY_GET_APPOINT_ITEM, reward)
end



---攻击触发，攻击对象掉血之后触发
function attack(actor, fightData)
    --local caster = fightData["caster"]
    --local target = fightData["target"]
    --local mapId = fightData["mapid"]
    --local skillId = fightData["skillid"]
    --local skillLevel = fightData["skilllevel"]
    --local casterType = fightData["castertype"]
    --local targetType = fightData["targettype"]
    local targetHurt = fightData["targethurt"]
    --local mapCfgId = fightData["mapcfgid"]
    --local targetCfgId = fightData["targetcfgid"]
    --Buffer.OnAttack(actor, fightData["target"])

    EquipGem.setSpeedBonus(actor)
    --EquipGuard.guardHpChange(actor, targetHurt)

    if fightData.castertype == MapObjectType.PLAYER then
        Player.setLastAttackTime(actor, getbaseinfo(actor, "nowsec"))
        KunDun.Attack(actor, fightData)
        PlayerFight.AttackTrigger(actor, fightData)
    end
    RolandSeige.Attack(actor, fightData)
end

-- @description 玩家复活事件
-- @param 玩家对象
-- @return
function revival(actor, type)
    GameEvent.push(EventCfg.onRevival, actor)
    RedFortress.PlayerRelive(actor)
    WarAlliance.playerRelive(actor, type)
    RolandSeige.PlayerRelive(actor)
    BingFengBao.PlayerRelive(actor)
    EliteMM.giveBuff(actor)
end

-- @description 不管大退，小退还是断开连接都会执行
-- @param 玩家对象
-- @return
function quit(actor)
    DuplicateCommon.OfflineQuitGame(actor)
    -- Union.sendLeaderOnlineStateMsg(play)
    Chat.onQuitGame(actor)
end

-- 创建角色事件
function creatrole(actor)
    sendluamsg(actor, LuaMessageIdToClient.RES_CREATE_ROLE, "")
    Privilege.conditionActPrivilege(actor)
    noticeTip.noticeinfo(actor, StringIdConst.TEXT37001)
end

-- 玩家加入战盟前
function guildaddmember(actor)
    -- UnionArmbands.onEnterUnion(actor)
end

function guildaddmemberafter(actor, union_id)
    -- UnionArmbands.onEnterUnion(actor)
end

-- 玩家退出战盟前
function guilddelmemberbefore(actor)
    -- UnionArmbands.onQuitUnion(actor)
    UnionChangeLeader.clearRunForLeaderMember(actor)
end

---通知刷新外置任务目标
function updateexternaltaskgoal(actor, taskModule, taskId, type, goalId, goalCount, realParam)
    if table.contains({ TaskTargetType.LAST_KILL_MONSTER, TaskTargetType.FIRST_ATTACK_MONSTER, TaskTargetType.KILL_TYPE_MONSTER, TaskTargetType.HURT_MAP_MONSTER, TaskTargetType.KILL_MONSTER_COUNT }, type) then
        -- 瞬间可能多次触发任务刷新的，不能用参数传进来的这个goalCount，会有异步多线程问题。通过接口同步拿最新的
        local taskList = gettasklist(actor)
        for _, taskInfo in pairs(taskList) do
            if taskInfo.taskid == taskId then
                for key, goalInfo in pairs(taskInfo.taskgoal) do
                    goalCount = goalInfo.count
                    break
                end
                break
            end
        end
    end
    local count = TaskGoal.FlushTaskCount(actor, type, goalId, goalCount, realParam)
    if count ~= goalCount then
        onlyupdatetaskgoal(actor, taskModule, taskId, goalId, count)
    end
end

-- -- 交易行预购成功
-- function preoredrsuccess(actor, ownId, itemId)
--     Trade.changeItemInfo(actor, ownId, itemId)
-- end

--充值事件
function recharge(actor, rechargeData)
    Recharge.OnRecharge(actor, rechargeData)
end

--1秒心跳
function rolesecondheart(actor)
    --秒级心跳尽量不要加东西
     GameEvent.push(EventCfg.onRoleseCond, actor)
    gameDebug.debug(BingFengBao.roleSecondHeart, actor)
end

--3秒心跳
function role3secondheart(actor)
    gameDebug.debug(HpMpRecover.recoverMP3sec, actor)
    -- 安全区buff
    Buffer.safetyAreaBuff(actor)
    -- 经验药水过期检测，防止角色退出，时间间隔函数失效
    ExpBoost.expBoostExpireCheck(actor)
end

--5秒心跳
function role5secondheart(actor)
    gameDebug.debug(RandomChest.checkBoxDrop,actor)
    --玩家称号过期检查
    EquipAndAppear.checktitleovertime(actor)
    --玩家变身戒指过期检查
    EquipAndAppear.checkringovertime(actor)
    EquipDurability.onTime(actor)
end

--10秒心跳
function role10secondheart(actor)
    -- 记录玩家离线挂机的最后时间
    onHook.recordLastTime(actor)
    Privilege.checkTimeOut(actor)
    PrivilegeMonth.checkTimeOut(actor)
    MonsterScript.ResetDecayMboxRecordCheck(actor)
end

-- --分钟心跳
-- function roleminuteheart(actor)
--     MonsterScript.ResetDecayMboxRecordCheck(actor)
-- end

--小时心跳
function rolehourheart(actor)
    DailyLotteryDraw.flushDailyLotteryDraw(actor)
    -- 连击试炼增加副本次数
    ComboTest.roleHourHeart(actor)
end

--- 跨天执行，凌晨执行
function rolemidnightheart(actor)
    gameDebug.printLine(actor, "rolemidnightheart")
    ZeroEventListerTable:triggerEvent("0", actor)
    SevenLogin.midNightUpdate(actor)
    AngelWeapon.updateTaskInfo(actor)
    RechargeSevenReceive.midNightUpdate(actor)
    GameEvent.push(EventCfg.onNewDay, actor)
end

--- 活动次数重置后触发
---@param actor table 玩家对象
---@param activityId number 活动ID
---@param count number 重置后次数
function afteractivitycountreset(actor, activityId, count)
    VipPrivilege.entryCountHandler(actor, activityId)
end

-- @description 脚本计算角色最终属性
-- @param 玩家对象
-- @return
function calcplayfinalattr(actor)
    return RoleAttr.CalcPlayFinalAttr(actor)
end

-- @description 内置传送拦截事件,做自定义传送
-- @param 玩家对象 当前x坐标 当前y坐标 原目标x坐标 原目标y坐标
-- @return 拦截结果 {result= true,reason = "ttt", ignoreNotice = false}
-- true标识拦截，执行脚本内逻辑,放弃原传送,false 标识放行,执行原传送; reason为拦截原因说明; ignoreNotice为是否忽略向客户端发送拦截提示,默认发送
function customtotransmit(actor, targetMap, targetLine, currX, currY, x, y, fromMapMove)
    return CustomTransmit.CustomToTransmit(actor, targetMap, targetLine, currX, currY, x, y, fromMapMove)
end

--次事件触发的时候玩家还未进入地图，所以使用actor作为参数的命令还无法使用
function enterscene(actor, srcMapId, targetMapId)
    local srcMapCfgId, _ = gamemap.parseMapKey(srcMapId)
    local targetMapCfgId, _ = gamemap.parseMapKey(targetMapId)

    local srcServerType = ConfigDataManager.getTableValue("cfg_map_info", "servertype", "id", srcMapCfgId)
    local targetServerType = ConfigDataManager.getTableValue("cfg_map_info", "servertype", "id", targetMapCfgId)
    --从跨服进入本服的时候执行这个
    if srcServerType ~= nil and targetServerType ~= nil and srcServerType ~= targetServerType then
        if tonumber(targetServerType) == 1 then
            local x, y = CustomTransmit.GetPointFromMapMove(targetMapCfgId)
            return {
                x = x,
                y = y
            }
        end
    end
    return nil
end

--- 怪物死亡事件(掉落之前触发计算掉落道具)
---@param monsterActor table 怪物对象
---@param dieParam table 怪物死亡参数
function monsterdiem(monsterActor, monsterCfgId, killerId, ownerId, maxHurtRid, mapId, mongenCfgId, dieParam)
    local dropResult = MonsterScript.MonsterDieCulDrop(monsterActor, dieParam)
    return dropResult
end



--宠物召唤后触发
function callpetafter(actor, petCfgId, petId)
    Pet.onCall(actor, petCfgId, petId)
end

--- 传送后事件
function aftertransmit(actor)
    onHook.afterTransmit(actor)
end

---物品进背包后触发
---@param actor 玩家对象
---@param itemId 道具唯一id
---@param itemCfgId 道具配置id
---@param index 背包索引
function addbag(actor, itemId, itemCfgId, index, actionDesc)
    -- 如果道具是装备，查看是否是否还在（有可能被回收等不在背包了）
    local type = ConfigDataManager.getTableValue("cfg_item", "type", "id", itemCfgId)
    if tonumber(type) == ItemType.EQUIP then
        local itemInfo = getequipinfo(actor, itemId, 1)
        if itemInfo == nil then
            info("addbag事件，装备不在背包了，rid:" .. actor:toString() .. ",itemId:", itemId, "itemCfgId:", itemCfgId)
            return
        end
    end
    
    if actionDesc ~= "装备-脱装" then
        -- 道具来源信息
        gameDebug.debug(ItemFrom.setFrom, actor, itemId, itemCfgId, actionDesc)
    end

    -- 大秘境钥匙等级初始化
    BigSecretRealm.initKeyLevel(actor, itemCfgId)
    Shortcut.store(actor, itemCfgId, index)
    gameDebug.debug(EquipAndAppear.init, actor, itemId, itemCfgId)
    -- 装备首曝信息
    gameDebug.debug(FirstDrop.onItemAdded, actor, itemId, itemCfgId)
    --物品进入背包事件
    GameEvent.push(EventCfg.addbag, actor, itemId, itemCfgId, index)
end

--- 战盟创建后触发，初始化战盟数据
function loadguild(actor)
    UnionTask.onUnionCreate(actor)
end

--- 战盟解散后触发，清理战盟数据
function guildclosebefore(actor)
    UnionTask.onUnionClose(actor)
end

function createmap(sys, uniqueMapId)
    local mapCfgId, mapLine = gamemap.parseMapKey(uniqueMapId)
    jprint("地图被创建", uniqueMapId, mapCfgId, mapLine)

    GameMapHeart.AddMap(uniqueMapId)
end

function destroymap(sys, uniqueMapId)
    local mapCfgId, mapLine = gamemap.parseMapKey(uniqueMapId)
    jprint("地图被销毁", uniqueMapId, mapCfgId, mapLine)

    GameMapHeart.RemoveMap(uniqueMapId)
end

function attrupdate(actor, mapobjecttype)
    if mapobjecttype == nil then
        mapobjecttype = getbaseinfo(actor, "mapobjecttype")
    end
    if mapobjecttype == MapObjectType.PLAYER then
        gameDebug.debug(Skill.attrUpdated, actor)
        local attackSpeedBonus = getattrinfo(actor, "attackSpeedBonus")
        local attackSpeedBonusValue = attackSpeedBonus * 10000
        attackSpeedBonusValue = 10000 + attackSpeedBonusValue
        updateparam(actor, 4, attackSpeedBonusValue)
        RankScript.updateByType(actor, RANK_TYPES.FightValueType)
    elseif mapobjecttype == MapObjectType.MONSTER or mapobjecttype == MapObjectType.PET then
        local monsterMoveSpeed = getattrinfo(actor, "monsterMoveSpeed")
        if monsterMoveSpeed ~= 0 then
            local monInfo = getmonsterinfo(actor)
            local monsterId = monInfo["cfgid"]
            local aiId = ConfigDataManager.getTableValue("cfg_monster", "ai", "id", monsterId)
            local strWalkTime = ConfigDataManager.getTableValue("cfg_monster_ai", "walktime", "id", aiId)
            if not string.isNullOrEmpty(strWalkTime) then
                local walkTime = tonumber(strWalkTime)
                --monsterMoveSpeed 值是负数的
                local newWalkTime = walkTime - walkTime * monsterMoveSpeed
                --jprint("monster attrupdate", monsterId, aiId, walkTime, newWalkTime)
                setmonsterwalktime(actor, newWalkTime)
            end
        end
    end
end

-- 角色删除后触发
function afterdeleterole(actor)
    gameDebug.debug(Player.deleteRoleAfter,actor)
    UnionChangeLeader.clearRunForLeaderMember(actor)
    RankScript.clearSelfData(actor)
end

--地图心跳事件，lua内部触发
-- function lua_mapsecondheart(uniMapId, mapId)
-- end

--地图3秒心跳事件，lua内部触发
-- function lua_map3secondheart(uniMapId, mapId)

-- end

-- --地图5秒心跳事件，lua内部触发
-- function lua_map5secondheart(uniMapId, mapId)
-- end

--- 离线挂机战斗获得经验事件
---@param actor 玩家对象
---@param exp 经验值
function getofflineexp(actor, exp)
    onHook.saveOfflineFightExp(actor, exp)
end

-- 获取摆摊位置
function stallmapinfo(actor, stallPosition)
    Stall.sendStallPosition(actor, stallPosition)
end
--  buffFromType:buff来源 = 1:道具，2:技能，99:脚本
function buffeffect(targetActor, buffCfgId, casterActor, hurtTotal, targetTotal, layers, buffFromType, buffId)
    Buffer.buffeffect(targetActor, buffCfgId, layers, buffFromType, buffId, casterActor)
end

function buffeffectafter(targetActor, buffCfgId, casterActor, hurtTotal, targetTotal, layers, buffFromType, buffId)
    Buffer.buffeffectafter(targetActor, buffCfgId, layers, buffFromType, buffId)
end
-- reason 1:正常失效, 2:由于同一buff叠加层数触发失效
function bufflose(actor, buffCfgId, ownerId, reason)
    -- gameDebug.print(actor, "触发buff关闭事件", buffCfgId, ownerId, reason)
    Buffer.bufflose(actor, buffCfgId, reason)
end

--- 商城购买道具后触发
function buymallgoodsafter(actor, is_success, goods_id)
    local SUCCESS_STATE = 1

    -- 触发任务刷新
    if tonumber(is_success) == SUCCESS_STATE then
        TaskHandler.TriggerTaskGoal(actor, TaskTargetType.MALL_BUY_GOODS, goods_id)
    end
end

--- 购买NPC商城道具后触发 is_success 是否购买成功，1:成功，0:失败  item_id 和 item_count在购买成功后才会返回
function buynpcshopgoodsafter(actor, is_success, item_id, item_count)
    if tonumber(is_success) == 1 then
        TaskHandler.TriggerTaskGoal(actor, TaskTargetType.NPC_MALL_BUY_GOODS, item_id)
    end
end

--- 分配属性点后触发
function afterdeployattrpoint(actor)
    TaskHandler.TriggerTaskGoal(actor, TaskTargetType.DEPLOY_ATTR_POINT, true)
end

-- 进入地图后初始化怪物
function initmonster(monster, monsterCfgId)
    MonsterAttribute.Initmonster(monster, monsterCfgId)
end

function showgetrewardpanel(actor, items)
    sendluamsg(actor, LuaMessageIdToClient.COMMON_REWARD_PANEL, items)
end

function setcombovaluebefore(actor, skillCfgId, skillLevel, skill)
    return Skill.calculationComboValue(actor, skillCfgId, skillLevel, skill)
end

-- 内置任务状态改变
function taskchange(actor, taskId, state, data)
    TaskHandler.onTaskChange(actor, taskId, state)
end

--- 销毁物品触发
---@param actor table 玩家对象
---@param cfgId number 道具配置id
---@param itemId number 道具唯一id
function destroyitem(actor, cfgId, itemId)
    Shortcut.tryRemoveItem(actor, cfgId, itemId)
end

--- 怪物复活
function monsterrelive(monster, monsterCfgId)
    MonsterAttribute.Initmonster(monster, monsterCfgId)
end

--- 自动回收道具
function autorecoverybefore(actor)
    return ItemRecycling.autoRecycling(actor)
end

-- 玩家设置改变
function settingchange(actor, type, oldValue, value)
    gameDebug.debug(KunDun.FightModelChange, actor, type, value)
    RolandSeige.RolandSettingChange(actor, tonumber(type), tonumber(value))
end



--- 世界聊天成功触发
function worldchatsuccess(actor)
    sendluamsg(actor, LuaMessageIdToClient.RES_WORLD_CHAT_SUCCESS, true)
end

--- 外置聊天频道触发事件
function outversionchatevent(actor, param)
    Chat.OutVersionChant(actor, param)
end

--- 技能升级事件
function levelupskillevent(actor, skillInfo)
    info("[levelupskillevent]", skillInfo)
    Skill.levelUp(actor, skillInfo)
end

--- 角色改名成功触发
function checkusernameok(actor, oldName, newName)
    RankScript.updateSelfData(actor, RANK_FIELD_TYPE.name)
end

--- 行会改名, 加入或退出行会成功触发
function guildnamechange(actor, guildId, guildName)
    RankScript.updateSelfData(actor, RANK_FIELD_TYPE.unionname)
end


function useitembefore(actor, param)
    local items = param.items
    for bogIndex, count in pairs(items) do
        local item = getbagiteminfo(actor, bogIndex)
        local cfgId = tonumber(item.cfgid)
        if cfgId == ItemConfigId.ELITEMM then
            return EliteMM.canUse(actor, cfgId)
        end
    end
end


--- 穿戴装备前用于外置过滤
function filtertakeonequip(actor, param)
    local bagIndex = param.bagindex
    local iteminfo = getbagiteminfo(actor, bagIndex, 0)
    return EquipAndAppear.filterTakeOneEquip(actor, iteminfo, true, true)
end




function groupcreate(leder, teamId)
    Team.sendExpBonusMsg(leder)
end


function groupaddmember(actor)
    local teamId = getbaseinfo(actor,"teamid")
    Team.sendExpBonusMsgAll(teamId)
end


function leavegroup(actor, teamId)
    Team.sendExpBonusMsgAll(teamId)
    Team.sendExpBonusMsg(actor)
end


function picktask(actor, taskid)
    TaskLoopManager.clear(actor, taskid)
end

-- 玩家在加入队伍时,玩家触发
function startgroup(actor, teamId)
    Team.sendEquipInfo(actor)
end

-- 队长在创建队伍时,队长触发
function groupcreate(actor)
    Team.sendEquipInfo(actor)
end

-- 当队伍成功加入新成员,队长触发该事件
function groupaddmember(actor)
    Team.sendEquipInfo(actor)
end

-- 玩家发动离队后,玩家触发
function leavegroup(actor, teamId)
    Team.quitAfter(actor, teamId)
    gameDebug.debug(DuplicateTeam.leaveTeam, actor, teamId)
end
-- 在更换队长后, 新队长触发
function changeleaderafter(actor, teamId, newLeaderId)
    Team.sendEquipInfo(actor)
end