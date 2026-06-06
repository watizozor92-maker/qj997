---工具自动生成
---@class MessageDef
---activity.xml
---@field ReqActivityListMessage . @请求:查看活动列表
---@field ResActivityListMessage ActivityProtos.ActivityListRes @响应:活动列表
---@field ReqEnterActivityMessage ActivityProtos.EnterActivityReq @请求:前往活动
---@field ResActivityStatusMessage ActivityProtos.ActivityStatus @响应:活动状态
---@field ReqEnterDupMessage ActivityProtos.DupOption @请求:进入副本
---@field ResEnterDupResultMessage ActivityProtos.EnterDupResultRes @响应:进入副本的判定结果
---@field ReqGiveUpEnterDupMessage . @请求:放弃进入副本
---@field ResGiveUpEnterDupSuccessMessage . @响应:放弃进入副本成功
---@field ResUpdateDupStateMessage ActivityProtos.DupStateRes @响应:更新副本状态
---@field ReqQuitDupMessage . @请求:退出副本
---@field ResQuitDupSuccessMessage ActivityProtos.QuitDupSuccess @响应:退出副本成功
---@field ResDupScoreRankUpdateMessage ActivityProtos.DupPointRankUpdateRes @响应:副本积分排行更新
---@field ResDupFinishMessage ActivityProtos.DupFinishRes @响应:副本完成
---@field ReqReceiveAwardMessage ActivityProtos.ReceiveAwardReq @请求:领取奖励
---@field ReqRecruitDupMemberMessage . @请求:招募副本成员
---@field ReqEnterDupByRecruitMessage ActivityProtos.EnterDupByRecruitReq @请求:通过招募链接进入副本
---@field ResEnterDupLeftCountMessage ActivityProtos.EnterDupLeftCountRes @响应: 副本进入剩余次数
---@field ReqDailyActivityTaskMessage . @请求日常活动列表
---@field ResDailyActivityTaskMessage ActivityProtos.ResDailyActivityTask @发送日常活动列表
---@field ReqGetRewardBoxMessage ActivityProtos.ReqGetRewardBox @领取宝箱奖励宝箱
---@field ResSendRewardBoxMessage ActivityProtos.ResSendRewardBox @发送奖励宝箱状态
---@field ResActivityChangeMessage ActivityProtos.ActivityChangeRes @活动日常任务统一回包
---@field ReqEnterActivityByNpcMessage ActivityProtos.EnterActivityByNpcReq @请求:通过npc前往活动
---@field ReqGoldTaskMessage . @请求:查看黄金挑战任务
---@field ResGoldTaskMessage ActivityProtos.GoldTaskRes @响应：黄金挑战任务列表
---@field ReqReceiveGoldTaskMessage ActivityProtos.GoldTaskId @请求:领取黄金挑战任务
---@field ReqGiveUpGoldTaskMessage ActivityProtos.GoldTaskId @请求:放弃黄金挑战任务
---@field ReqReceiveGoldTaskAwardMessage ActivityProtos.GoldTaskId @请求:领取黄金挑战任务奖励
---@field ReqFlushGoldTaskMessage . @请求:刷新黄金挑战任务
---@field ReqDailyActivityAddTimesMesssageMessage ActivityProtos.ReqActivityTimes @请求: 日常活动添加活动次数
---@field ReqChangePotionsMesssageMessage . @请求: 一键兑换药水
---@field ResDevilSquareKillCountUpdateMessage ActivityProtos.DevilSquareKillCountUpdateRes @响应:恶魔广场杀怪数量更新
---@field ResBloodyCastleDPSUpdateMessage ActivityProtos.BloodyCastleDPSUpdateRes @响应:血色城堡秒伤更新
---@field ResActivityStartRemindMessage ActivityProtos.ActivityStartRemindRes @响应:活动开始提醒
---@field ResEnterPriDupStatusMessage ActivityProtos.ResEnterPriDupStatus @响应:进入个人副本状态
---@field ResCanEnterActivityMessage ActivityProtos.ResCanEnterActivity @响应:可以进入活动
---@field ReqEnterActivitySecOkMessage ActivityProtos.EnterActivitySecOk @请求:前往副本活动二次确认
---@field ReqOpenActivityRetrievePanelMessage . @请求:打开日常活动回收面板
---@field ResOpenActivityRetrievePanelMessage ActivityProtos.ActivityRetrievePanel @响应:日常活动回收面板
---@field ReqRetrieveActivityMessage ActivityProtos.ReqRetrieveActivityLeftCount @请求:找回活动剩余次数
---@field ReqRetrieveChangePotionsMessage . @请求:兑换药水
---@field ResLastActivityInfoMessage ActivityProtos.LastActivityInfo @响应:上次活动信息
---@field ResActivityAnnounceMessage ActivityProtos.ActivityAnnounceRes @响应:活动预告
---@field ReqDuplicateLeftCountMessage ActivityProtos.ReqDuplicateLeftCount @请求:请求活动剩余次数
---@field ResDuplicateLeftCountMessage ActivityProtos.ResDuplicateLeftCount @响应:活动的剩余次数
---bag.xml
---@field ReqBagInfoMessage . @返回背包信息
---@field ResBagInfoMessage BagProtos.BagInfoRes @返回背包信息
---@field ResBagChangeMessage BagProtos.BagChangeRes @背包发生变化
---@field ReqSwapItemMessage BagProtos.SwapItemReq @交换背包道具的格子
---@field ReqGiveUpItemMessage BagProtos.GiveUpItemReq @丢弃道具
---@field ReqTidyItemMessage BagProtos.TidyItemReq @整理道具
---@field ReqUseItemMessage BagProtos.UseItemReq @使用道具
---@field ReqDestroyItemMessage BagProtos.DestroyItemReq @销毁道具
---@field ReqSynthesisItemMessage BagProtos.SynthesisItemReq @请求：合成道具
---@field ResSynthesisItemMessage BagProtos.SynthesisItemRes @返回：合成道具
---@field ReqRecoveryItemMessage BagProtos.RecoveryItemReq @请求：回收道具
---@field ResRecoveryItemMessage BagProtos.RecoveryItemRes @返回：回收道具
---@field ResSwapItemMessage BagProtos.SwapItemRes @交换背包道具响应
---@field ReqResolveItemMessage BagProtos.ResolveItemReq @请求：分解道具
---@field ResResolveItemMessage BagProtos.ResolveItemRes @返回：分解道具
---@field ResLockBagGridMessage BagProtos.LockBagGridRes @返回：背包锁格子响应
---@field ResReceiveItemMessage BagProtos.ReceiveItemRes @返回：领取道具统一响应
---@field ResTidyItemMessage BagProtos.TidyItemRes @返回：整理道具响应
---@field ReqUseFruitMessage BagProtos.UseFruitReq @请求：使用果实道具
---@field ReqJudgeUseItemMessage BagProtos.JudgeUseItem @请求判断使用使用道具GM
---@field ResJudgeUseItemMessage BagProtos.JudgeUseItemRes @请求判断使用使用道具GM
---@field ReqUseItemGMMessage BagProtos.UseItemGM @请求使用使用道具GM
---@field ReqUseTransferItemMessage BagProtos.UseTransferItemReq @使用道具
---@field ReqQuickBuyMessage BagProtos.QuickBuyReq @快捷购买
---@field ReqUseSelfChoiceBoxMessage BagProtos.ReqSelfChoiceBox @请求：使用自选宝箱
---@field ResOpenBoxStrategyMessage BagProtos.OpenBoxStrategy @响应：开宝箱入包策略
---@field ReqBatchOpenBoxMessage BagProtos.UseItemReq @请求：批量使用宝箱
---@field ResBagExpansionMessage BagProtos.BagExpansionRes @响应背包扩容
---@field ReqResetFruitPointMessage BagProtos.ResetFruitPointReq @请求：重置果实点数
---@field ReqOpenFruitResetPageMessage . @请求：打开果实重置页面
---@field ResOpenFruitResetPageMessage BagProtos.OpenFruitResetPageRes @响应：打开果实重置页面
---@field ReqBagAddCapacityMessage BagProtos.BagAddCapacityReq @请求：背包扩容
---@field ResAutoPickupInfoMessage BagProtos.ResAutoPickupInfo @响应自动范围内捡道具
---@field ReqAutoPickUpRangeItemsMessage BagProtos.ReqAutoPickUpRangeItems @请求自动范围内捡道具
---box_stall.xml
---@field ReqBoxStallServerMessage BoxStallProto.BoxStallServerReq @请求：盒子交易行服务器
---@field ResBoxStallRuleMessage BoxStallProto.BoxStallRuleRes @响应：盒子交易行规则
---@field ResBoxStallInfoMessage BoxStallProto.BoxStallInfoRes @响应：转发盒子交易行服务器的json信息
---box_trade.xml
---@field ReqBoxTradeServerMessage BoxTradeProto.BoxTradeServerReq @请求：盒子交易行服务器
---@field ResBoxTradeRuleMessage BoxTradeProto.BoxTradeRuleRes @响应：盒子交易行规则
---@field ResBoxTradeInfoMessage BoxTradeProto.BoxTradeInfoRes @响应：转发盒子交易行服务器的json信息
---@field ResBoxTradeLockRoleChangeMessage BoxTradeProto.BoxTradeLockRoleChangeRes @响应：盒子交易行锁定角色变化信息
---@field ReqBoxTradeUnlockRoleMessage BoxTradeProto.UnlockRoleReq @请求：盒子交易行解锁角色
---@field ResBoxTradeItemsInfoMessage BoxTradeProto.BoxTradeItemsInfoRes @响应：交易行道具详细信息
---@field ReqBoxTradeItemsInfoMessage BoxTradeProto.BoxTradeItemsInfoReq @请求：交易行道具详细信息
---buffer.xml
---@field ResAddBufferMessage BufferProtos.AddBufferRes @通知客户端添加一条buff
---@field ResRemoveBufferMessage BufferProtos.RemoveBufferRes @通知客户端移除一条buff
---@field ResBufferOnceMoveMessage BufferProtos.BufferOnceMoveRes @执行一次移动buff
---@field ResHaloBufferOnceMessage BufferProtos.HaloBufferOnceRes @执行一次光环buff
---@field ResBufferOnceHurtMessage BufferProtos.BufferOnceHurtRes @执行一次伤害
---@field ResFreeBuffMessage BufferProtos.FreeBuffRes @自由buff响应
---chat.xml
---@field ReqChatMessage ChatProto.ReqChat @请求聊天
---@field ResChatMessage ChatProto.ResChat @聊天结果
---@field ResOfflineMsgMessage ChatProto.OfflineMsg @离线留言响应
---@field ResHorseRaceLampMessage ChatProto.HorseRaceLampRes @跑马灯响应
---@field ResTextNoticeMessage ChatProto.TextNoticeRes @文本通知响应
---@field ReqChatHistoryMessage ChatProto.ChatHistoryReq @请求聊天历史
---@field ResChatHistoryMessage ChatProto.ChatHistoryRes @聊天历史响应
---@field ResSendMsgByNpcMessage ChatProto.SendMsgByNpcRes @通过NPC发送广播信息
---@field ResSendCenterMsgMessage ChatProto.SendCenterMsgRes @发送居中显示信息
---@field ResClearDelayGotoMessage ChatProto.ClearDelayGotoRes @清除所有倒计时消息
---@field ResGroupNoticeMessage ChatProto.GroupNoticeMsgRes @发送自定义颜色消息
---@field ResTopChatBoardMsgMessage ChatProto.SendTopChatBoardMsgRes @发送聊天框固顶信息
---@field ResSendMoveMessage ChatProto.SendMoveMessageRes @发送屏幕滚动信息
---@field ResSendCustomMessage ChatProto.SendCustomMsgRes @屏幕任意坐标发送公告信息
---@field ResSendMsgNewMessage ChatProto.SendMsgNewRes @主屏幕弹出公告
---@field ResSendDelayMessage ChatProto.SendDelayMsgRes @显示倒计时信息提示
---@field ReqSendOnlineStateMessage ChatProto.SendOnlineStateReq @发送私聊列表ID
---@field ResSendOnlineStateMessage ChatProto.SendOnlineStateRes @发送私聊列表ID
---@field ReqFindRidByNameMessage ChatProto.FindRidByNameReq @请求：根据名字查找Rid
---@field ResFindIdByNameMessage ChatProto.FindRidByNameRes @响应：根据名字查找Rid
---@field ResGameAnnounceMessage ChatProto.GameAnnounceRes @游戏公告协议
---@field ReqRemovePrivateChatMessage ChatProto.RemovePrivateChatRes @请求：移除私聊玩家信息
---@field ResPrivateChatMessage ChatProto.AllPrivateChatRes @响应：私聊玩家信息
---count.xml
---@field ReqCountInfoMessage CountProtos.ReqCountInfo @请求计数
---@field ResCountInfoMessage CountProtos.ResCountInfo @响应计数
---@field ResNoticeCountInfoMessage CountProtos.NoticeCountInfoRes @响应：更新数量
---dup_angeltower.xml
---@field ResAngelTowerPanelMessage DupAngelTowerProtos.AngelTowerSelectionPanel @响应:天使之塔选择面板
---@field ReqEnterAngelTowerMessage . @请求:开启/重新挑战
---@field ResRemainMonsterCountMessage DupAngelTowerProtos.RemainMonsterCountRes @响应:天使之塔剩余怪物数量
---@field ReqResetAngelTowerMessage . @请求:重置天使之塔
---@field ReqSweepAngelTowerMessage . @请求:扫荡天使之塔
---@field ReqGoToTowerNextLevelMessage . @请求:前往下一层
---@field ResAngelTowerThisLevelOverMessage . @响应:天使之塔本层结束
---dup_bloody.xml
---@field ResUpdateBloodyTaskMessage DupBloodyProtos.BloodProgress @更新血色城堡任务进度响应
---@field ResDupWeaponDropMessage DupBloodyProtos.DupWeaponDrop @通知客户端-副本道具掉落
---@field ReqPickUpWeaponMessage DupBloodyProtos.PickWeapon @通知服务器-玩家捡起道具
---@field ResPickUpWeaponMessage DupBloodyProtos.PickWeapon @通知客户端-玩家捡起道具
---@field ReqGiveNPCWeaponMessage DupBloodyProtos.ReqGiveNPCWeapon @通知客户端-器交还武器
---@field ResGiveNPCWeaponMessage DupBloodyProtos.ResGiveNPCWeapon @通知客户端-器交还武器
---@field ResBloodyBudingMonsterIdMessage DupBloodyProtos.dupMapBudingMonster @通知客户端-建筑怪物的ID
---@field ReqClearBurialTimeViewMessage DupBloodyProtos.ClearBurialReq @通知服务器-清除冷却界面
---@field ResClearBurialTimeViewMessage DupBloodyProtos.ClearBurialRes @通知客户端-清除冷却界面
---@field ReqClearBurialTimeMessage DupBloodyProtos.ClearTimeRes @通知服务器-清除冷却时间
---@field ResBloodRateInfoMessage DupBloodyProtos.BloodRateInfo @通知副本评级信息
---@field ReqSpoilsOfWarMessage . @通知服务器-请求战利品
---@field ResSpoilsOfWarMessageMessage DupBloodyProtos.SpoilsOfWarInfo @通知客户端-战利品信息
---dup_bravetest.xml
---@field ResBraveTestPanelMessage DupBravetestProtos.BraveTestPanelRes @响应:勇者挑战面板
---@field ReqRQuickHangUpPanelMessage . @请求:快速挂机弹窗
---@field ResRQuickHangUpPanelMessage DupBravetestProtos.QuickHangUpPanelRes @响应:快速挂机弹窗
---@field ResBraveChallengeResultMessage DupBravetestProtos.BraveChallengeResult @响应:通知勇者试炼成功或者失败
---@field ResBraveTestTaskRecordMessage DupBravetestProtos.BraveTestTaskRecord @响应:通知勇者试炼任务进度刷新
---@field ReqSpecialRewardMessage DupBravetestProtos.SpecialRewardReq @请求:领取特殊奖励
---@field ResNewFloorMessage DupBravetestProtos.NewFloorRes @响应:解锁最新的层级
---@field ReqHangUpIncomeMessage DupBravetestProtos.HangUpIncomeReq @请求：获取伙伴挂机信息
---@field ResHangUpIncomeMessage DupBravetestProtos.HangUpIncomeRes @响应：伙伴挂机信息
---@field ReqFastHangUpMessage . @请求:快速挂机
---@field ReqBraveTestEnterMapMessage DupBravetestProtos.MatchBraveTestMap @请求: 进入副本地图
---@field ResFastHangUpMessage DupBravetestProtos.FastHangUpRes @请求:快速挂机
---@field ReqReceiveRewardHangUpMessage . @请求:领取挂机奖励
---@field ResReceiveRewardHangUpMessage DupBravetestProtos.ReceiveRewardHangUpRes @请求:领取挂机奖励
---@field ReqGetBraveTestInfoMessage DupBravetestProtos.GetBraveTestInfoReq @请求:勇者试炼面板数据
---@field ReqBraveTestOnHookMessage DupBravetestProtos.OnHookReq @请求:挂机
---@field ResBraveTestOnHookMessage DupBravetestProtos.OnHookRes @响应:挂机
---@field ResFastHangUpRewardMessage DupBravetestProtos.FastHangUpReward @响应:快速挂机奖励道具
---dup_cantrubattle.xml
---@field ResCanTruPanelMessage DupCantruBattleProtos.CanTruPanelRes @响应:坎特鲁战役面板
---@field ReqEnterCantruBattleMessage DupCantruBattleProtos.EnterCantruBattleReq @请求:开启挑战
---@field ResReliveConsumeMessage DupCantruBattleProtos.ReliveConsumeRes @响应:复活消费响应
---@field ReqReliveConsumeMessage . @请求:消费钻石复活
---dup_choiceroad.xml
---@field ResChoiceRoadPanelMessage DupChoiceRoadProtos.ChoiceRoadPlane @响应:抉择之路面板
---@field ReqChallengeChoiceRoadMessage DupChoiceRoadProtos.ChallengeChoiceRoad @请求:挑战抉择之路
---@field ReqChoiceRoadBuyLeftTimesMessage . @请求:购买剩余挑战次数
---@field ReqChoiceRoadRankInfoMessage . @请求:排行榜数据
---@field ResChoiceRoadRankPanelMessage DupChoiceRoadProtos.ChoiceRoadRank @响应:抉择之路排行榜面板
---@field ReqChoiceRoadLevelInfoMessage DupChoiceRoadProtos.ChoiceRoadLevelInfoReq @请求:关卡详细信息
---@field ResChoiceRoadLevelInfoMessage DupChoiceRoadProtos.ChoiceRoadLevelInfoRes @响应:关卡详细信息
---@field ResChallengeChoiceRoadResultMessage DupChoiceRoadProtos.ChoiceRoadResult @响应:挑战结果
---@field ReqChoiceRoadOpenPlaneMessage DupChoiceRoadProtos.ChoiceRoadOpenPlaneReq @请求:请求打开面板
---@field ResChoiceRoadBuyLeftTimesMessage DupChoiceRoadProtos.ChoiceRoadByTimes @响应:购买剩余次数
---dup_currencyboss.xml
---@field ReqEnterCurrencyBossMessage DupCurrencyBossProtos.EnterCurrencyBossReq @请求：进入通用boss副本
---@field ReqCurrencyBossInfoMessage DupCurrencyBossProtos.CurrencyBossInfoReq @请求：获得副本信息
---@field ResCurrencyBossInfoMessage DupCurrencyBossProtos.CurrencyBossInfoRes @响应：获得副本信息
---@field ReqCurrencyBossRankListMessage DupCurrencyBossProtos.CurrencyBossRankListReq @请求：获得副本排名信息
---@field ResCurrencyBossRankListMessage DupCurrencyBossProtos.CurrencyBossRankListRes @响应：获得副本排名信息
---@field ReqCurrencyBossReliveMessage DupCurrencyBossProtos.CurrencyBossReliveReq @请求：复活
---@field ResCurrencyBossRewardListMessage DupCurrencyBossProtos.CurrencyBossRewardListRes @响应：结算奖励信息
---@field ResEnterCurrencyBossMessage DupCurrencyBossProtos.EnterCurrencyBossRes @响应：进入通用boss副本
---@field ReqCurrencyBossAddVipFrequencyMessage DupCurrencyBossProtos.CurrencyBossAddVipFrequencyReq @请求：增加VIP次数
---@field ReqCurrencyBossReliveRemindMessage DupCurrencyBossProtos.CurrencyBossReliveRemindReq @请求：设置复活提醒
---@field ResCurrencyBossReliveRemindMessage . @响应：设置复活提醒
---@field ResCurrencyBossReliveNoticeMessage DupCurrencyBossProtos.CurrencyBossReliveNoticeRes @响应：boss复活倒计时通知
---@field ReqCurrencyBossMopUpMessage DupCurrencyBossProtos.CurrencyBossMopUpReq @请求：扫荡
---@field ResGoldBossRankListMessage DupCurrencyBossProtos.GoldBossRankListRes @响应：获得黄金BOSS副本排名信息
---@field ResScoreChangeMessage DupCurrencyBossProtos.ScoreChangeRes @响应：专属BOSS评变化通知
---@field ResCurrencyBossPickUpAllMessage . @响应：专属BOSS拾取完毕通知
---@field ResCurrencyBossDieMessage DupCurrencyBossProtos.CurrencyBossDieRes @响应：通用BOSS死亡响应
---@field ReqFieldBossAllInfoMessage DupCurrencyBossProtos.FieldBossAllInfoReq @请求：野外BOSS请求
---@field ResFieldBossAllInfoMessage DupCurrencyBossProtos.FieldBossAllInfoRes @响应：野外BOSS信息响应
---dup_demonrefinement.xml
---@field ReqMLZDPanelMessage . @请求: 查看魔炼之地面板
---@field ResMLZDInfoMessage MoLianZhiDiProto.MLZDPanel @响应: 魔炼之地面板信息
---@field ReqEnterMLZDMessage MoLianZhiDiProto.EnterMLZDOption @请求: 进入魔炼之地副本
---@field ResMLZDPreparePanelMessage MoLianZhiDiProto.MLZDPrepareInfo @响应: 准备面板
---@field ReqPrepareMLZDMessage MoLianZhiDiProto.MLZDPrepareReq @请求: 准备/拒绝进入魔炼之地
---@field ResMLZDDupInfoMessage MoLianZhiDiProto.MLZDDupInfo @响应: 魔炼之地副本信息
---@field ResMLZDDupFinishPanelMessage MoLianZhiDiProto.MLZDFinishPanel @响应: 魔炼之地结束面板
---@field ReqReceiveMLZDAwardMessage . @请求: 领取奖励
---@field ResMLZDExitCountDownMessage MoLianZhiDiProto.MlzdExitCountDown @响应: 魔炼之地结束退出倒计时
---dup_devilsquare.xml
---@field ReqStartFightPhaseNowMessage . @请求:立即开启战斗阶段
---dup_gardboss.xml
---@field ReqEnterGardBossMessage DupGardBossProtos.EnterGardBossReq @请求：进入战盟BOSS副本
---@field ResEnterGardBossMessage DupGardBossProtos.EnterGardBossRes @响应：进入战盟BOSS副本
---@field ReqGardBossInfoMessage DupGardBossProtos.GardBossInfoReq @请求：战盟BOSS副本信息
---@field ResGardBossInfoMessage DupGardBossProtos.GardBossInfoRes @响应：战盟BOSS副本信息
---@field ResGardBossRewardInfoMessage DupGardBossProtos.GardBossRewardInfoRes @响应：战盟BOSS副本结算奖励
---@field ReqGardBossReliveMessage DupGardBossProtos.GardBossReliveReq @请求：复活
---@field ResGardBossPlayerDieMessage DupGardBossProtos.GardBossPlayerDieRes @响应：玩家在副本中死亡
---dup_gateworld.xml
---@field ReqFloorEntryWayMessage GateWorldProtos.FloorInfoReq @请求:点击层数获取入口数量
---@field ResFloorEntryWayMessage GateWorldProtos.FloorEntryWay @响应:活动面板层数详情展示
---@field ReqFindGateWorldNPCMessage GateWorldProtos.FloorInfoReq @请求:请求一个可以挑战的NPC
---@field ResFindGateWorldNPCMessage GateWorldProtos.GateWorldNpcPoint @响应:NPC位置信息
---@field ReqTryEnterGateWorldMessage GateWorldProtos.ChallengeNPC @请求:点击发起挑战
---@field ResChallengeResultMessage GateWorldProtos.ChallengeResult @响应:挑战结果
---@field ResFloorPanelInfoMessage GateWorldProtos.FloorPanelInfoRes @响应:活动面板信息
---@field ResSendAllNpcPointMessage GateWorldProtos.AllNpcPoint @响应:活动开启后发送所有NPC位置
---@field ResGateWorldTaskRecordMessage GateWorldProtos.GateWorldTask @响应:异界之门任务进度
---@field ReqGateWorldBuyCountMessage GateWorldProtos.BuyCountReq @请求:异界之门购买次数
---@field ResGateWorldBuyCountMessage GateWorldProtos.BuyCountRes @响应:异界之门购买次数
---dup_guildSiege.xml
---@field ReqGuildSiegeInfoMessage . @请求：查看攻城战信息详情
---@field ResGuildSiegeInfoMessage GuildSiegeProto.GuildSiegeInfoRes @响应：攻城战面板详情
---@field ReqGuildSiegeStatisticalMessage . @请求：查看上周攻城战统计信息
---@field ResGuildSiegeStatisticalMessage GuildSiegeProto.SiegeStatisticalRes @响应：上周攻城战统计信息
---@field ReqAgainstTableMessage . @请求：查看攻城战对阵表
---@field ResGuildSiegeAgainstTableMessage GuildSiegeProto.AgainstTableRes @响应：攻城战对阵表
---@field ReqGoToGuildSiegeMessage . @请求：前往攻城战战场
---@field ReqRepAirStatueMessage GuildSiegeProto.RepAirStatueReq @请求：修复雕像
---@field ResRepAirStatueMessage GuildSiegeProto.RepAirStatueRes @响应：修复雕像
---@field ResWarGodListMessage GuildSiegeProto.WarGodListRes @响应：战神榜
---@field ReqWarGodPraiseMessage GuildSiegeProto.WarGodPraiseReq @请求：战神榜点赞
---@field ResWarGodPraiseMessage GuildSiegeProto.WarGodPraiseRes @响应：战神榜点赞
---@field ReqUseGoHomeSkillMessage . @请求：使用回城术
---@field ResUseGoHomeSkillMessage GuildSiegeProto.UseGoHomeSkillRes @响应：使用回城术结果
---@field ReqBecomeFightCarMessage . @请求：变身战车
---@field ReqReturnPersonMessage . @请求：恢复人形
---@field ReqGuildSiegeReliveMessage . @请求：攻城战原地复活
---@field ReqBuildingConditionMessage . @请求：建筑状态
---@field ResBuildingConditionMessage GuildSiegeProto.BuildingConditionRes @响应：建筑状态
---@field ReqGuildSiegeDataMessage . @请求：战场即时数据
---@field ResGuildSiegeDataMessage GuildSiegeProto.GuildSiegeDataRes @响应：战场即时数据
---@field ResThroneHarmDataMessage GuildSiegeProto.ThroneHarmDataRes @响应：王座被攻击时响应数据
---@field ReqGuildSiegeRecruitMessage . @请求：攻城战召唤盟友
---@field ResUpdateMonsterStateMessage GuildSiegeProto.UpdateBuilding @响应：更新怪物血量
---@field ResGuildSiegeCampSwapMessage GuildSiegeProto.CampSwapRes @响应：更新怪物血量
---@field ReqSiegeStatisticsMessage . @请求：统计界面
---@field ResSiegeStatisticsMessage GuildSiegeProto.SiegeStatisticsRes @响应：统计界面
---@field ResTradeLineEndTimeMessage GuildSiegeProto.TradeLineEndTimeRes @响应：交易行结束时间
---@field ResguardTimeMessage GuildSiegeProto.GuardTimeMessageRes @响应：守护时间
---@field ResGuildSiegeAnnounceMessage GuildSiegeProto.GuildSiegeAnnounceRes @响应：战盟开启时间以及生成对阵表状态
---dup_help_fight.xml
---@field ReqHelpFightListMessage . @请求:助战列表
---@field ResHelpFightListMessage DupHelpFightProtos.HelpFightListRes @响应:助战列表
---@field ReqSeekHelpMessage DupHelpFightProtos.SeekHelpReq @请求:求助
---@field ReqGoToHelpMessage DupHelpFightProtos.GoToHelpReq @请求:前往助战
---@field ResHelpScoreListMessage DupHelpFightProtos.HelpScoreListRes @响应:协助排行榜
---@field ResThankLetterMessage DupHelpFightProtos.ThankLetterRes @响应:感谢信
---@field ReqSendThankLetterMessage DupHelpFightProtos.SendThankLetterReq @请求:发送感谢信
---@field ResSendThankLetterMessage DupHelpFightProtos.SendThankLetterRes @响应:发送感谢信
---@field ReqGetLetterRewardMessage DupHelpFightProtos.GetLetterRewardReq @请求:领取感谢信
---@field ReqQuitHelpMessage . @请求:退出协助
---@field ResGotoHelpMessage DupHelpFightProtos.GotoHelpRes @响应:进入地图
---@field ResCloseHelpMessage . @响应:关闭协助
---@field ReqUseLetterMessage DupHelpFightProtos.UseLetterReq @请求:使用感谢信
---@field ReqDelHelpInfoMessage . @请求:删除求助信息
---dup_imperialfortress.xml
---@field ResImperialFortressMessage DupImperialFortressProtos.ImperialFortressSelectionPanel @响应:帝国要塞面板
---@field ReqEnterImperialFortressMessage DupImperialFortressProtos.EnterImperialFortressOption @请求:开启帝国要塞挑战
---dup_kalimatemple.xml
---@field ResKaLiMaTemplePanelMessage DupKaLiMaTempleProtos.KaLiMaTemplePanel @响应:卡利玛神庙面板
---@field ReqChallengeKaLiMaTempleMessage DupKaLiMaTempleProtos.ChallengeKaLiMaTemple @请求:挑战卡利玛神庙副本
---@field ResKaLiMaTempleTaskChangeMessage DupKaLiMaTempleProtos.DupTaskChange @响应:副本任务进度
---@field ResKaLiMaTempleChallengeResultMessage DupKaLiMaTempleProtos.KaLiMaChallengeResult @响应:卡利玛神庙挑战结果
---@field ReqSweepingUpKaLiMaTempleMessage DupKaLiMaTempleProtos.ChallengeKaLiMaTemple @请求:扫荡卡利玛神庙
---dup_monster_attack.xml
---@field ReqMonsterAttViewMessage DupMonsterAttackProtos.MonsterAttViewReq @请求:打开怪物袭击面板
---@field ResMonsterAttViewMessage DupMonsterAttackProtos.MonsterAttViewRes @响应:打开怪物袭击面板
---@field ReqGotoMonsterAttMessage DupMonsterAttackProtos.GotoMonsterAttReq @请求:前往怪物袭击地图
---dup_redfortress.xml
---@field ResUpdateScoreMessage DupRedFortressProtos.updateScoreRes @响应:刷新积分面板
---@field ResEndDupPanelMessage DupRedFortressProtos.endDupPanelRes @响应:副本结束面板
---@field ResDropOutMapMessage DupRedFortressProtos.dropOutMapRes @响应:玩家掉出地图
---@field ResMapZoomOutMessage DupRedFortressProtos.MapZoomOutRes @响应:地图缩小
---dup_redfortress_two.xml
---@field ReqRedFortressTwoRankInfoMessage DupRedFortressTwoProtos.ReqScoreRankInfo @请求：赤色要塞2排行信息
---@field ResRedFortressTwoRankInfoMessage DupRedFortressTwoProtos.ResScoreRankInfo @响应：赤色要塞2排行信息
---@field ResRedFortressTwoWarPhaseMessage DupRedFortressTwoProtos.ResWarPhaseInfo @响应：赤色要塞2战争阶段信息
---@field ResRedFortressTwoKillInfoMessage DupRedFortressTwoProtos.ResWarKillInfo @响应：赤色要塞2击杀信息
---@field ResRedFortressTwoSelfScoreInfoMessage DupRedFortressTwoProtos.SelfScoreRankItem @响应：赤色要塞2自己积分信息
---@field ResRedFortressTwoQuitInfoMessage DupRedFortressTwoProtos.QuitInfo @响应：赤色要塞2退出信息
---@field ResRedFortressTwoAwardInfoMessage DupRedFortressTwoProtos.ResAwardInfo @响应：赤色要塞2奖励信息
---dup_siege.xml
---@field ReqSiegePanelMessage . @请求:攻城战面板
---@field ResSiegePanelMessage DupSiegeProtos.SiegePanel @响应:攻城战面板
---@field ReqToTheSiegeMessage DupSiegeProtos.SiegeIdReq @请求:前往攻城
---@field ReqRegistrationInfoMessage DupSiegeProtos.SiegeIdReq @请求:攻城战报名详情
---@field ResRegistrationInfoMessage DupSiegeProtos.RegistrationInfoRes @响应:攻城战报名详情
---@field ReqRegisterSiegeMessage DupSiegeProtos.RegisterSiegeReq @请求:报名攻城战
---@field ReqDeployedMercenaryListMessage . @请求:查看已部署的佣兵
---@field ResMercenaryListMessage DupSiegeProtos.MercenaryList @响应:已部署的佣兵列表
---@field ReqDeployMercenaryMessage DupSiegeProtos.MercenaryList @请求:部署佣兵
---@field ResSiegeScoreRankUpdateMessage DupSiegeProtos.SiegeScoreRankUpdateRes @响应:积分排行
---@field ResOccupyOrganTimeMessage DupSiegeProtos.OccupyOrganTimeRes @响应:机关占领开始结束时间
---@field ResBreakProgressMessage . @响应:打断进度条
---@field ReqOccupySuccessMessage . @请求：占领机关成功请求
---@field ReqOccupyOrganPanelMessage DupSiegeProtos.OccupyOrganPanelReq @请求：占领机关战盟面板
---@field ResOccupyOrganPanelMessage DupSiegeProtos.OccupyOrganPanelRes @响应：占领机关战盟面板
---@field ReqOccupySeatMessage . @请求：占领椅子
---dup_wolfsoul.xml
---@field ResPlayWolfSoulCartoonMessage . @响应:播放狼魂要塞过场动画
---@field ResLoginWolfSoulSuccessMessage DupWolfSoulProtos.LoginWolfSoulSuccessRes @响应:成功登录狼魂要塞
---@field ResWolfSoulGlobalInfoUpdateMessage DupWolfSoulProtos.WolfSoulGlobalInfoUpdateRes @响应:狼魂要塞全局信息更新
---@field ResWolfSoulKillPointUpdateMessage DupWolfSoulProtos.WolfSoulKillPointUpdateRes @响应:狼魂要塞个人击杀点数更新
---@field ResWolfSoulRewardPanelMessage DupWolfSoulProtos.WolfSoulRewardPanelRes @响应:狼魂要塞结算奖励面板
---@field ReqBindDefensePlatformMessage DupWolfSoulProtos.BindDefensePlatformReq @请求:绑定神狼护台
---@field ResBoundStateMessage DupWolfSoulProtos.BoundStateRes @响应:自身绑定状态
---@field ReqWolfSoulGlobalInfoMessage . @请求:狼魂要塞全局信息
---@field ReqWolfSoulReliveMessage . @请求:狼魂要塞复活
---dup_worldboss.xml
---@field ReqWorldBossInfoMessage DupWorldBossProtos.WorldBossInfoReq @请求：世界BOSS副本信息
---@field ResWorldBossInfoMessage DupWorldBossProtos.WorldBossInfoRes @响应：世界BOSS副本信息
---@field ResWorldBossRewardInfoMessage DupWorldBossProtos.WorldBossRewardInfoRes @响应：世界BOSS副本结算奖励
---@field ResWorldBossPhaseInfoMessage DupWorldBossProtos.ResDupPhaseInfo @响应：世界BOSS副本阶段信息
---@field ResWorldBossBuffInfoMessage DupWorldBossProtos.buffInfo @响应：世界BOSSbuff信息
---@field ResWorldBossHpInfoMessage DupWorldBossProtos.bossHp @响应：世界boss血量信息
---@field ResWorldBossLastRankMessage DupWorldBossProtos.LastWorldBossRankInfoRes @响应：世界boss血量信息
---@field ReqWorldBossLastRankMessage . @请求：世界boss血量信息
---@field ReqWorldBossOpenBossHpMessage DupWorldBossProtos.openBossHp @请求打开世界boss血量界面
---efficiency.xml
---@field ReqReceiveEfficiencyRewardMessage EfficiencyProtos.ReceiveEfficiencyRewardReq @效率系统领取等级奖励 请求
---@field ResEfficiencyRewardInfoMessage EfficiencyProtos.EfficiencyRewardInfoRes @效率系统领取等级奖励具体信息 响应
---@field ResEfficiencyMagnificationMessage EfficiencyProtos.EfficiencyMagnificationRes @效率系统经验倍率具体信息 响应
---@field ReqEfficiencyBuyMessage EfficiencyProtos.EfficiencyBuyReq @效率系统奇迹币增益与爆率提升购买 请求
---@field ResEfficiencyBuyInfoMessage EfficiencyProtos.EfficiencyBuyInfoRes @效率系统奇迹币增益与爆率提升购买信息 响应
---@field ResExperiencePotionMessage EfficiencyProtos.ExperiencePotionRes @效率系统经验药水过期时间 响应
---@field ResEfficiencyBuyRateMessage EfficiencyProtos.EfficiencyBuyRateRes @效率系统已经购买的爆率提升 响应
---equip.xml
---@field ResAllEquipMessage EquipProto.AllEquipRes @所有装备信息
---@field ReqPutOnTheEquipMessage EquipProto.PutOnTheEquipReq @穿装
---@field ReqTakeOffEquipMessage EquipProto.TakeOffEquipReq @脱装
---@field ResPutOnTheEquipMessage EquipProto.PutOnTheEquipRes @穿装
---@field ResTakeOffEquipMessage EquipProto.TakeOffEquipRes @脱装
---@field ReqEquipStrengthenMessage EquipProto.EquipStrengthenReq @装备强化
---@field ResEquipStrengthenMessage EquipProto.EquipStrengthenRes @装备强化
---@field ResAllEquipGemMessage EquipProto.AllEquipGemRes @所有装备宝石信息
---@field ReqPutOnGemMessage EquipProto.PutOnGemReq @装宝石
---@field ResPutOnGemMessage EquipProto.PutOnGemRes @装宝石
---@field ReqTakeOffGemMessage EquipProto.TakeOffGemReq @脱掉宝石
---@field ResTakeOffGemMessage EquipProto.TakeOffGemRes @脱掉宝石
---@field ResAllEquipGemUnLockMessage EquipProto.AllEquipGemUnLockRes @所有宝石解锁信息
---@field ResMountStoreChangeMessage EquipProto.MountStoreChangeRes @坐骑仓库发生变化
---@field ReqPutOnMountMessage EquipProto.PutOnMountReq @装备坐骑
---@field ReqTakeOffMountMessage EquipProto.TakeOffMountReq @脱掉坐骑
---@field ResAllMountInfoMessage EquipProto.AllMountInfoRes @所有的激活的坐骑信息
---@field ReqRideMountMessage EquipProto.RideMountReq @骑乘坐骑请求
---@field ResRideMountMessage EquipProto.RideMountRes @骑乘坐骑响应
---@field ReqCancelMountMessage EquipProto.CancelMountReq @取消骑乘请求
---@field ResCancelMountMessage EquipProto.CancelMountRes @取消骑乘响应
---@field ReqHideMountMessage EquipProto.HideMountReq @隐藏坐骑请求
---@field ResHideMountMessage EquipProto.HideMountRes @隐藏坐骑响应
---@field ReqExposeMountMessage EquipProto.ExposeMountReq @暴露坐骑请求
---@field ResExposeMountMessage EquipProto.ExposeMountRes @暴露坐骑响应
---@field ReqPutOnPetMessage EquipProto.PutOnPetReq @装备召唤兽
---@field ResPutOnPetMessage EquipProto.PutOnPetRes @装备召唤兽响应
---@field ReqTakeOffPetMessage EquipProto.TakeOffPetReq @脱掉召唤兽
---@field ResTakeOffPetMessage EquipProto.TakeOffPetRes @脱掉召唤兽响应
---@field ReqFightPetMessage EquipProto.FightPetReq @召唤兽出战请求
---@field ResFightPetMessage EquipProto.FightPetRes @召唤兽出战响应
---@field ReqCancelFightPetMessage EquipProto.CancelFightPetReq @取消召唤兽出战请求
---@field ResCancelFightPetMessage EquipProto.CancelFightPetRes @取消召唤兽出战请求响应
---@field ReqEquipAppendMessage EquipProto.EquipAppendReq @装备追加请求
---@field ResEquipAppendMessage EquipProto.EquipAppendRes @装备追加响应
---@field ReqOperatePetMessage EquipProto.OperatePetReq @对召唤兽进行操作
---@field ResOperatePetMessage EquipProto.OperatePetRes @对召唤兽进行操作响应
---@field ReqEquipTransferMessage EquipProto.EquipTransferReq @装备转移
---@field ResEquipTransferMessage EquipProto.EquipTransferRes @装备转移响应
---@field ReqEquipOverlayMessage EquipProto.EquipOverlayReq @装备叠加
---@field ResEquipOverlayMessage EquipProto.EquipOverlayRes @装备叠加响应
---@field ReqEquipSynthesis2Message EquipProto.EquipSynthesis2Req @装备合成2代请求
---@field ResEquipSynthesis2Message EquipProto.EquipSynthesis2Res @装备合成2代响应
---@field ReqEquipStrengthen2Message EquipProto.EquipStrengthen2Req @装备强化2代请求
---@field ResEquipStrengthen2Message EquipProto.EquipStrengthen2Res @装备强化2代响应
---@field ReqEquipAppend2Message EquipProto.EquipAppend2Req @装备追加2代请求
---@field ResEquipAppend2Message EquipProto.EquipAppend2Res @装备追加2代响应
---@field ReqEquipStrengthenExtraAttMessage EquipProto.EquipStrengthenExtraAttReq @装备额外属性强化请求
---@field ResEquipStrengthenExtraAttMessage EquipProto.EquipStrengthenExtraAttRes @装备额外属性强化响应
---@field ReqEquipRefineQualityExtraAttMessage EquipProto.EquipRefineQualityExtraAttReq @装备额外属性品质系数洗练请求
---@field ResEquipRefineQualityExtraAttMessage EquipProto.EquipRefineQualityExtraAttRes @装备额外属性品质系数洗练响应
---@field ReqEquipTransferExtraAttMessage EquipProto.EquipTransferExtraAttReq @装备额外属性转移请求
---@field ResEquipTransferExtraAttMessage EquipProto.EquipTransferExtraAttRes @装备额外属性转移响应
---@field ReqEquipMasterInfoMessage EquipProto.MasterInfoReq @装备大师信息请求
---@field ResEquipMasterInfoMessage EquipProto.MasterInfo @装备大师信息响应
---@field ReqEquipMasterActivateMessage EquipProto.MasterActivateReq @装备大师激活等级请求
---@field ResEquipMasterActivateMessage EquipProto.MasterActivateRes @装备大师信息响应
---@field ResEquipMasterChangeMessage EquipProto.MasterChangeRes @装备大师信息响应
---@field ReqEquipPurchaseListMessage EquipProto.EquipPurchaseListReq @装备额外属性购买列表请求
---@field ResEquipPurchaseListMessage EquipProto.EquipPurchaseListRes @装备额外属性购买列表响应
---@field ResEquipExtraAttPurchaseErrorMessage EquipProto.EquipExtraAttPurchaseError @装备额外属性购买错误响应
---@field ReqGuardProgressMessage EquipProto.GuardProgressReq @请求：守护进阶
---@field ReqGuardAwakeningMessage EquipProto.GuardAwakeningReq @请求：守护觉醒
---@field ResGuardHeightSucMessage EquipProto.GuardHeightSucRes @响应：守护进阶觉醒是否成功
---@field ReqBatchPutOnGemMessage EquipProto.BatchPutOnGemReq @一键批量装宝石请求
---@field ResBatchPutOnGemMessage EquipProto.BatchPutOnGemRes @一键批量装宝石响应
---@field ReqGemStrengthMessage EquipProto.GemStrengthReq @宝石强化请求
---@field ResGemStrengthMessage EquipProto.GemStrengthRes @宝石强化响应
---@field ReqStrengthenManualActivateMessage EquipProto.StrengthenManualActivateReq @请求：激活强化属性
---@field ReqAppendManualActivateMessage EquipProto.AppendManualActivateReq @请求：激活追加属性
---@field ResStrengthenManualActivateMessage EquipProto.ManualActivateRes @响应：激活强化属性
---@field ResAppendManualActivateMessage EquipProto.ManualActivateRes @响应：激活追加属性
---@field ResUpdateMasterMessage EquipProto.UpdateMasterRes @前端用来及时更新大师页面
---@field ResTransferCareerDeleteSkillMessage . @转职后前端用来及时删除之前的技能效果
---@field ReqActiveFashionMessage EquipProto.ActiveFashionReq @请求：激活时装
---@field ResFashionChangeMessage EquipProto.FashionChangeRes @响应：时装变化信息
---@field ReqStrengthFashionMessage EquipProto.StrengthFashionReq @请求：强化
---@field ResStrengthFashionMessage EquipProto.StrengthFashionRes @响应：强化
---@field ResActiveFashionMessage EquipProto.ActiveFashionRes @请求：激活时装
---@field ReqTransferAttMessage EquipProto.TransferAttReq @请求：属性转移
---@field ResTransferAttMessage EquipProto.TransferAttRes @响应：属性转移
---@field ReqLuckInlayMessage EquipProto.LuckInlayReq @请求：幸运镶嵌
---@field ResLuckInlayMessage EquipProto.LuckInlayRes @响应：幸运镶嵌
---@field ResEquipBarAttrMessage EquipProto.EquipBarAttrRes @响应：装备栏属性变化
---@field ReqEquipBarAttrMessage EquipProto.EquipBarAttrReq @请求：装备栏属性变化
---@field ReqMountRecoverMessage EquipProto.MountRecoverReq @请求：坐骑分解
---@field ResMountRecoverMessage EquipProto.MountRecoverRes @响应：坐骑分解
---@field ReqMountUpStarLvMessage EquipProto.MountUpStarLvReq @请求：坐骑升星
---@field ResMountUpStarLvMessage EquipProto.MountUpStarLvRes @响应：坐骑升星
---@field ReqEquipBrightStrengthenMessage EquipProto.EquipStrengthenReq @请求：装备璀璨强化
---@field ResEquipBrightStrengthenMessage EquipProto.EquipStrengthenRes @响应：装备璀璨强化
---@field ReqEquipBrightAppendMessage EquipProto.EquipAppendReq @请求：装备璀璨追加
---@field ResEquipBrightAppendMessage EquipProto.EquipAppendRes @响应：装备璀璨追加
---@field ReqEquipIncreaseMessage EquipProto.EquipIncreaseReq @请求：增幅
---@field ReqEquipInheritanceMessage EquipProto.EquipInheritanceReq @请求：传承
---@field ReqEquipFusionMessage EquipProto.EquipFusionReq @请求：熔合
---@field ResEquipFusionMessage EquipProto.EquipFusionRes @响应：熔合
---@field ReqEquipFusionOkMessage EquipProto.EquipFusionOkReq @请求：确认熔合
---@field ResEquipFusionOkMessage EquipProto.EquipFusionOkRes @响应：确认熔合
---@field ResEquipIncreaseOkMessage EquipProto.EquipIncreaseOkRes @响应：确认增幅
---@field ResEquipInheritanceOkMessage EquipProto.EquipInheritanceOkRes @响应：确认传承
---@field ResEquipChangeMessage EquipProto.EquipChangeRes @已穿戴装备发生变化
---@field ReqUpEquipGodLvMessage EquipProto.UpEquipGodLvReq @装备神化
---@field ResUpEquipGodLvMessage EquipProto.UpEquipGodLvRes @装备神化
---@field ReqMountStrengthMessage EquipProto.MountStrengthReq @请求：坐骑强化升级
---@field ResMountStrengthMessage EquipProto.MountStrengthRes @响应：坐骑强化升级
---@field ReqPutOnTheMountEquipMessage EquipProto.PutOnTheMountEquipReq @请求：给坐骑一键穿装备
---@field ResPutOnTheMountEquipMessage EquipProto.PutOnTheMountEquipRes @响应：给坐骑一键穿装备
---@field ReqTakeOffTheMountEquipMessage EquipProto.TakeOffTheMountEquipReq @请求：一键拆卸坐骑的装备
---@field ResTakeOffTheMountEquipMessage EquipProto.TakeOffTheMountEquipRes @响应：一键拆卸坐骑的装备
---@field ReqTakeOffTheMountEquipOneMessage EquipProto.TakeOffTheMountEquipOneReq @请求：脱掉坐骑身上的一个装备
---@field ResTakeOffTheMountEquipOneMessage EquipProto.TakeOffTheMountEquipOneRes @响应：脱掉坐骑身上的一个装备
---@field ReqPutOnTheMountEquipOneMessage EquipProto.PutOnTheMountEquipOneReq @请求：给坐骑穿一件装备
---@field ResPutOnTheMountEquipOneMessage EquipProto.PutOnTheMountEquipOneRes @响应：给坐骑穿一件装备
---@field ResMountAttributeMessage EquipProto.MountAttributeRes @响应：发送全部坐骑属性
---@field ResRoleRuneMessage EquipProto.RoleRuneRes @响应：发送全部的角色符文信息
---@field ReqUnLockRunePlateMessage EquipProto.UnLockRunePlateReq @请求：解锁符文盘，其实也就是给符文盘升星
---@field ReqPourSoulMessage EquipProto.PourSoulReq @请求：给符文盘的孔位注灵，其实也就是给孔位升级
---@field ReqIdentifyRuneMessage EquipProto.IdentifyRuneReq @请求：鉴定符文
---@field ReqSuccinctMessage EquipProto.SuccinctReq @请求：洗练符文
---@field ReqGiveUpSuccinctMessage EquipProto.GiveUpSuccinctReq @请求：放弃洗练结果
---@field ReqSaveSuccinctMessage EquipProto.SaveSuccinctReq @请求：保存洗练结果
---@field ReqPutOnRuneMessage EquipProto.PutOnRuneReq @请求：往符文盘里面放符文
---@field ReqTakeOffRuneMessage EquipProto.TakeOffRuneReq @请求：从符文盘里面脱掉符文
---@field ReqAddRunePlateMessage EquipProto.AddRunePlateReq @请求：增加一个符文盘方案
---@field ResRuneAttrMessage EquipProto.RuneAttrRes @响应：符文全部属性
---@field ResSaveRuneSuccinctMessage EquipProto.SaveRuneSuccinctRes @响应：保存符文洗练结果
---@field ResSuccinctMessage EquipProto.SuccinctRes @响应：洗练符文
---@field ReqSwitchRunePlateMessage EquipProto.SwitchRunePlateReq @请求：切换符文盘
---@field ReqEntryPotentialActiveMessage EquipProto.EntryPotentialActiveReq @请求：词条潜能激活
---@field ResEntryPotentialActiveMessage EquipProto.EntryPotentialActiveRes @响应：词条潜能激活
---@field ReqBrightSuccinctMessage EquipProto.BrightSuccinctReq @请求：词条潜能璀璨洗练
---@field ResBrightSuccinctMessage EquipProto.BrightSuccinctRes @响应：词条潜能璀璨洗练
---@field ReqEntryPotentialSuccinctMessage EquipProto.EntryPotentialSuccinctReq @请求：词条潜能洗练
---@field ResEntryPotentialSuccinctMessage EquipProto.EntryPotentialSuccinctRes @响应：词条潜能洗练
---@field ReqEntryPotentialGiveUpSuccinctMessage EquipProto.EntryPotentialGiveUpSuccinctReq @请求：放弃词条潜能洗练结果
---@field ReqEntryPotentialSaveSuccinctMessage EquipProto.EntryPotentialSaveSuccinctReq @请求：保存词条潜能洗练结果
---@field ResEntryPotentialSaveSuccinctMessage EquipProto.EntryPotentialSaveSuccinctRes @响应：保存词条潜能洗练结果
---@field ResGradeAttrChangeMessage EquipProto.GradeAttrChangeRes @响应：基础属性变化通知
---@field ResLuaExtDataChangeMessage EquipProto.LuaExtDataChange @响应：装备扩展数据变化通知
---@field ResCanTransferAttrMessage EquipProto.CanTransferAttr @响应：装备穿戴后能否转移属性通知
---fight.xml
---@field ResObjectDieMessage FightProtos.ObjectDieRes @对象死亡
---@field ResFightResultMessage FightProtos.FightResultRes @技能释放结果
---@field ReqFightMessage FightProtos.FightReq @请求释放技能
---@field ReqStartAutoPlayGameMessage . @客户端触发开始挂机
---@field ReqEndAutoPlayGameMessage . @客户端触发停止挂机
---@field ResStartAutoPlayGameMessage . @服务器触发开始挂机
---@field ResEndAutoPlayGameMessage . @服务器触发停止挂机
---@field ReqCaromMessage FightProtos.CaromReq @请求释放连招技能
---@field ResBeSkillReadyMessage FightProtos.BeSkillReadyRes @响应：被动技能已准备
---@field ResTimesCaromStartMessage FightProtos.TimesCaromStartRes @响应: 次数连击开始
---@field ReqUpdateComboSkillMessage FightProtos.UpdateComboSkill @请求: 更新连击技能
---@field ReqComboValueMessage . @请求: 获取连击值
---@field ResComboSkillInfoMessage FightProtos.ComboSkillInfoRes @响应: 玩家连击技能
---@field ResFightLogMessage FightProtos.FightLog @技能伤害计算过程日志
---friend.xml
---@field ReqOpenFriendPanelMessage FriendProto.OpenFriendPanelReq @请求打开好友面板
---@field ResFriendInfoMessage FriendProto.FriendInfoRes @返回好友信息
---@field ReqSearchFriendMessage FriendProto.SearchFriendReq @请求好友查询
---@field ResSearchFriendMessage FriendProto.SearchFriendRes @好友查询响应
---@field ReqRecommendFriendsMessage . @请求系统推荐好友
---@field ResRecommendFriendsMessage FriendProto.RecommendFriendsRes @系统推荐好友响应
---@field ReqAddFriendMessage FriendProto.AddFriendReq @请求添加好友
---@field ResFriendChangeMessage FriendProto.FriendChangeRes @返回好友变化信息
---@field ReqDeleteFriendMessage FriendProto.DeleteFriendReq @请求删除好友
---@field ReqCheckApplyMessage FriendProto.CheckApplyReq @审批申请
---@field ReqFriendLogsMessage FriendProto.FriendLogsReq @请求好友日志
---@field ResFriendLogsMessage FriendProto.FriendLogsRes @返回好友日志
---@field ReqClearMsgUnreadStateMessage FriendProto.ReqClearMsgUnreadState @请求:清理好友消息未读状态
---gm.xml
---@field ReqGMMessage GmProtos.ExecGMReq @请求GM执行
---@field ResExecGMMessage GmProtos.ExecGMRes @GM执行返回
---@field ResServerLogMessage GmProtos.ServerLogRes @内容输入到GM面板中
---@field ResCreateRobotOrMonsterMessage GmProtos.createRobotOrMonsterRes @GM生成怪物或机器人返回id
---gmequip.xml
---@field ResAddHoleResMessage GmEquipProto.AddHoleRes @打宝石孔响应
---@field ResDelHoleMessage GmEquipProto.DelHoleRes @删除宝石孔响应
---@field ResGmPutOnGemMessage GmEquipProto.GmPutOnGemRes @镶嵌宝石响应
---@field ResGmTakeOffGemMessage GmEquipProto.GmTakeOffGemRes @脱掉宝石响应
---@field ResChangeStrengthMessage GmEquipProto.ChangeStrengthRes @改变强化标识响应
---@field ResChangeAppendMessage GmEquipProto.ChangeAppendRes @改变追加标识响应
---@field ResChangeEquipEntryAttrMessage GmEquipProto.ChangeEquipEntryAttrRes @改变卓越属性响应
---@field ResChangeStrengthOrAppendAttrMessage GmEquipProto.ChangeStrengthOrAppendAttrRes @改变强化或者追加属性响应
---@field ResChangeCustomizeAttrMessage GmEquipProto.ChangeCustomizeAttrRes @改变自定义属性响应
---@field ResChangeEquipSwimFlagMessage GmEquipProto.ChangeEquipSwimFlagRes @改变装备游泳标识
---@field ResChangeEquipRunFlagMessage GmEquipProto.ChangeEquipRunFlagRes @改变装备奔跑标识
---@field ResChangeEquipFlyFlagMessage GmEquipProto.ChangeEquipFlyFlagRes @改变装备飞天标识
---@field ResChangeEquipShapeMessage GmEquipProto.ChangeEquipShapeRes @改变装备内观模型
---@field ResChangeEquipEffectIdMessage GmEquipProto.ChangeEquipEffectIdRes @改变装备内观特效Id
---@field ResChangeEquipWearLimitMessage GmEquipProto.ChangeEquipWearLimitRes @改变装备穿戴限制
---gmscript.xml
---@field ResLoadGmScriptMessage GmScriptProtos.LoadGmScriptMessageRes @装载脚本
---@field ResInvalidGmScriptMessage GmScriptProtos.InvalidGmScriptMessageRes @脚本失效
---@field ResBindGmScriptMessage GmScriptProtos.BindGmScriptMessageRes @脚本绑定到对象上
---@field ResUnBindGmScriptMessage GmScriptProtos.UnBindGmScriptMessageRes @从对象上解绑脚本
---@field ResClientGMCmdMessage GmScriptProtos.ClientGMCmd @服务器发送给客户端的脚本命令
---@field ResClientInitGMCmdMessage GmScriptProtos.ClientGMCmd @初始化时发送给客户端的脚本命令
---kml.xml
---@field ReqKmlMessage KmlProtos.KmlReq @kml请求
---@field ResKmlMessage KmlProtos.KmlRes @kml响应
---lua.xml
---@field ReqLuaMessage LuaProtos.LuaReq @lua请求
---@field ResLuaMessage LuaProtos.LuaRes @lua响应
---mail.xml
---@field ReqGetMailListMessage . @获取邮件列表请求
---@field ResMailListMessage MailProto.MailList @邮件列表响应
---@field ResNewMailMessage MailProto.MsgRemind @新邮件响应
---@field ReqReadMailMessage MailProto.MailIdMsg @标记为已读请求
---@field ReqGetMailItemMessage MailProto.MailIdMsg @提取物品请求
---@field ResGetMailItemMessage MailProto.MailIdMsg @提取物品响应
---@field ReqDeleteMailMessage MailProto.MailIdMsg @删除邮件请求
---@field ResReadMailMessage MailProto.MailIdMsg @已读响应
---@field ResRoleMailChangeMessage MailProto.MailChangeRes @邮件改变统一回包
---mall.xml
---@field ReqMallGoodsInfoMessage MallProtos.MallGoodsInfoReq @请求商城商品信息
---@field ResMallGoodsInfoMessage MallProtos.MallGoodsInfoRes @商城商品信息列表响应
---@field ReqBuyMallGoodsMessage MallProtos.BuyMallGoodsReq @请求购买商品
---@field ResBuyMallGoodsMessage MallProtos.BuyMallGoodsRes @请求购买商品响应
---@field ResFlushMallGoodsMessage . @刷新商城商品响应
---@field ReqAutoBuyPotionMessage . @自动买药请求
---@field ReqBuyPotionMessage MallProtos.BuyPotionReq @随身商店买药请求
---map.xml
---@field ResChangePosMessage MapProtos.ChangePosRes @坐标改变
---@field ResPlayerEnterMapMessage MapProtos.PlayerEnterMapRes @通知进入地图
---@field ResPlayerChangeMapMessage MapProtos.ChangeMapRes @通知玩家切换地图
---@field ResReliveMessage MapProtos.ReliveRes @通知复活
---@field ResSwitchFightModelMessage MapProtos.SwitchFightModelRes @通知切换攻击模式
---@field ResTryEnterMapMessage MapProtos.TryEnterMapRes @通知尝试
---@field ReqPlayerChangeMapMessage MapProtos.ChangeMapReq @请求切换地图
---@field ResWalkMessage MapProtos.WalkRes @返回步行
---@field ResChangeDirMessage MapProtos.ChangeDirRes @返回转向
---@field ReqWalkMessage MapProtos.WalkReq @步行
---@field ReqLoginMapMessage . @请求进图地图
---@field ResPlayerEnterViewMessage MapProtos.PlayerEnterViewRes @玩家进入视野
---@field ResMonsterEnterViewMessage MapProtos.MonsterEnterViewRes @怪物进入视野
---@field ResNpcEnterViewMessage MapProtos.NpcEnterViewRes @npc进入视野
---@field ResUpdateViewMessage MapProtos.UpdateViewRes @更新玩家视野消息
---@field ResMapObjectExitViewMessage MapProtos.MapObjectExitViewRes @离开视野
---@field ReqPlayerReliveMessage MapProtos.PlayerReliveReq @请求复活
---@field ReqSwitchFightModelMessage MapProtos.SwitchFightModelReq @请求切换攻击模式
---@field ReqDeliverByConfigMessage MapProtos.DeliverByConfigReq @请求切换攻击模式
---@field ResHpMpChangeMessage MapProtos.HpMpChangeRes @血量和魔法变化
---@field ReqExitDuplicateMessage . @请求退出副本
---@field ResItemEnterViewMessage MapProtos.ItemEnterViewRes @GroundItem进入视野
---@field ReqPickUpMapItemMessage MapProtos.PickUpMapItemReq @拾取道具
---@field ResBuffEnterViewMessage MapProtos.BuffEnterViewRes @GroundBuff进入视野
---@field ResUpdateEquipMessage MapProtos.UpdateEquipRes @装备变化
---@field ResNoticeViewTypeInfoMessage MapProtos.NoticeViewTypeInfoRes @通知ViewTypeInfo变化
---@field ResStallEnterViewMessage MapProtos.StallEnterViewRes @GroundStall进入视野
---@field ReqTransferPointMessage MapProtos.TransferPointReq @定点传送
---@field ReqNpcTransferMessage MapProtos.NpcTransferReq @NPC传送
---@field ResFightAttrInfoMessage MapProtos.FightAttrInfoRes @属性变化通知
---@field ReqStandbyMessage MapProtos.StandbyReq @待机方式
---@field ResStandbyMessage MapProtos.StandbyRes @待机方式广播
---@field ReqJumpMessage MapProtos.JumpReq @起跳
---@field ResJumpMessage MapProtos.JumpRes @起跳
---@field ReqRandomTransportMessage MapProtos.RandomTransportReq @随机传送
---@field ReqCustomizeTransportMessage MapProtos.CustomizeTransportReq @自定义坐标传送
---@field ResMapMonsterStatusMessage MapProtos.MapMonsterStatus @发送地图中怪物状态
---@field ResMonsterStatusChangeMessage MapProtos.MonsterStatus @单个怪物状态通知
---@field ReqMapMonsterStatusMessage MapProtos.ReqMapMonsterStatus @请求地图中怪物状态
---@field ReqMapObjInfoMessage MapProtos.MapObjInfoReq @请求：查看地图对象
---@field ResMapObjInfoMessage MapProtos.MapObjInfoRes @响应：地图对象信息
---@field ResBossOwnerMessage MapProtos.BossOwnerRes @响应：怪物对象仇恨信息
---@field ResAutoPathfindingMessage MapProtos.AutoPathfindingRes @自动寻路
---@field ResKillMobAtPointMessage MapProtos.KillMobAtPointRes @自动寻路并杀怪
---@field ResStopKillMobAtPointMessage . @停止自动寻路和杀怪
---@field ReqAutoPathfindingMessage MapProtos.AutoPathfindingReq @开始自动寻路
---@field ReqStopPathfindingMessage . @停止自动寻路
---@field ReqFinishedPathfindingMessage . @自动寻路到达终点
---@field ResShieldChangeMessage MapProtos.ShieldChangeRes @护盾值变化
---@field ResAgstoChangeMessage MapProtos.AgstoChangeRes @技能值变化
---@field ReqTransferToNpcMessage MapProtos.TransferToNpc @传送到NPC附近请求
---@field ResTransferToNpcMessage MapProtos.TransferToNpc @传送到NPC附近响应
---@field ResGMTransferMessage MapProtos.CustomizeTransportReq @通知客户端GM脚本发起传送
---@field ReqGMTransferMessage MapProtos.CustomizeTransportReq @客户端发起GM脚本传送
---@field ResScreenVibrationMessage MapProtos.VibrationInfo @通知客户端屏幕震动响应
---@field ResNpcRemoveViewMessage MapProtos.NpcRemoveViewRes @npc移除视野
---@field ResTransferResultMessage MapProtos.TransferResult @传送结果返回
---@field ReqThisMapLineInfoMessage . @获得当前地图分线信息
---@field ResThisMapLineInfoMessage MapProtos.MapLinesInfo @返回获得当前地图分线信息
---@field ResEquipAppearMessage MapProtos.EquipAppearRes @装备外观变化
---@field ResMonsterBtTransformMessage MapProtos.MonsterBtTransformRes @怪物变换模型
---@field ResMonsterBtAudioMessage MapProtos.MonsterBtAudioRes @播放声音
---@field ResMonsterBtAnimationMessage MapProtos.MonsterBtAnimationRes @播放动画
---@field ReqRecordTheHangUpPointMessage MapProtos.HangUpPoint @请求记录挂机点
---@field ReqLastHangUpPointMessage MapProtos.LastHangUpPointReq @请求获取上次记录挂机点
---@field ResLastHangUpPointMessage MapProtos.HangUpPoint @上次记录挂机点响应
---@field ResDieInfoMessage MapProtos.DieInfo @玩家死亡信息
---@field ReqCanTransferMessage MapProtos.CanTransferReq @传送校验
---@field ResCanTransferFlagMessage MapProtos.CanTransferFlagRes @传送校验结果
---@field ReqGuardPickItemMessage MapProtos.GuardPickItemReq @守护捡道具请求
---@field ResGuardPickItemMessage MapProtos.GuardPickItemRes @守护捡道具响应
---@field ReqGuardPickUpItemMessage MapProtos.GuardPickUpItemReq @守护获取道具请求
---@field ResMonsterDieInfoMessage MapProtos.MonsterDieInfo @怪物死亡信息
---@field ResRobberyModeSkilledMessage MapProtos.RobberyModeSkilledRes @对打的双方只有有一方为掠夺模式，被击杀者被击杀之后的弹出消息
---mu_box.xml
---@field ReqReceivePrivilegeGiftMessage MuBoxProto.PrivilegeGiftReq @请求：领取每日礼包
---@field ResMuBoxInfoMessage MuBoxProto.MuBoxInfoRes @响应：奇迹盒子信息
---@field ReqUpdatePrivilegeTitleMessage MuBoxProto.UpdatePrivilegeTitleReq @请求：更新特权称号
---@field ReqBoxCdKeyMessage MuBoxProto.BoxCdKeyReq @请求：兑换礼包码
---@field ResMuBoxPopupConfigMessage MuBoxProto.MuBoxPopupConfigRes @响应：奇迹盒子推广弹窗配置
---npcshop.xml
---@field ReqNpcShopGoodsInfoMessage NpcShopProto.NpcShopGoodsInfoReq @请求npc商店商品信息
---@field ResNpcShopGoodsInfoMessage NpcShopProto.NpcShopGoodsInfoRes @npc商店商品信息列表响应
---@field ReqBuyShopGoodsMessage NpcShopProto.BuyShopGoodsReq @请求购买商店商品
---@field ResBuyShopGoodsMessage NpcShopProto.BuyShopGoodsRes @请求购买商店商品响应
---@field ReqBagItemTradeMessage NpcShopProto.BagItemTradeReq @背包物品出售请求
---@field ResBagItemTradeMessage NpcShopProto.BagItemTradeRes @背包物品出售响应
---@field ResFlushNpcShopGoodsMessage . @刷新npc商店商品响应
---@field ReqRefreshNpcShopGoodsMessage NpcShopProto.RefreshNpcShopGoodsReq @刷新npc商店商品请求
---@field ResRefreshNpcShopGoodsMessage NpcShopProto.RefreshNpcShopGoodsRes @刷新npc商店商品响应
---@field ResMarketInfoMessage NpcShopProto.NpcShopGoodsInfoRes @宠物集市信息列表响应
---onhook.xml
---@field ReqOffLineBenefitMessage . @获取离线挂机收益请求
---@field ResOffLineBenefitMessage OnhookProto.OffLineBenefit @离线挂机收益响应
---@field ReqReceiveOffLineExpMessage . @领取离线挂机经验请求
---@field ResMultiOnhookInfoMessage OnhookProto.MultiOnhookInfo @响应：多倍挂机信息
---@field ReqMultiOnhookAddTimeMessage . @请求：多倍挂机补充时间
---@field ReqMultiOnhookStartMessage . @请求：开始多倍挂机
---@field ReqMultiOnhookStopMessage . @请求：停止（暂停）多倍挂机
---@field ReqMultiOnhookInfoMessage . @请求：多倍挂机信息
---@field ReqOfflineOnHookMessage . @请求：离线挂机信息
---@field ResOfflineOnHookMessage OnhookProto.OfflineOnHookRes @响应：离线挂机信息
---@field ReqOfflineOnHookGetExpMessage . @请求：领取离线挂机经验
---partner.xml
---@field ResAllPartnerInfoMessage PartnerProto.AllPartnerInfoRes @响应：登录时发送所有伙伴信息
---@field ReqUnLockPartnerSlotMessage PartnerProto.UnLockPartnerSlot @请求：解锁阵容槽位
---@field ResUnlockPartnerSlotSuccessMessage PartnerProto.UnLockPartnerSlot @响应：解锁阵容槽位成功响应
---@field ReqLoadOrUnloadPartnerMessage PartnerProto.LoadOrUnloadPartnerReq @请求：伙伴上阵/下阵
---@field ReqUpgradeArrayMasterLvMessage . @请求：升级技能大师等级
---@field ResArrayMasterUpdateMessage PartnerProto.ArrayMasterInfo @响应：阵容大师信息更新
---@field ReqLockOrUnlockPartnerMessage PartnerProto.LockOrUnlockPartnerReq @请求：上锁/解锁伙伴
---@field ReqResetPartnerMessage PartnerProto.ResetPartnerReq @请求：重置伙伴
---@field ReqPartnerLevelUpMessage PartnerProto.PartnerLevelUpReq @请求：升级伙伴
---@field ReqEvolvePartnerMessage PartnerProto.EvolvePartnerReq @请求：进化(突破、进阶)伙伴
---@field ReqUpPartnerStarLvMessage PartnerProto.UpPartnerStarLvReq @请求：伙伴升星
---@field ReqWashingPartnerMessage PartnerProto.WashingPartnerReq @请求：伙伴洗髓
---@field ReqConfirmPartnerWashingResultMessage PartnerProto.ConfirmWashingResultReq @请求：确认伙伴洗髓结果(确定/取消)
---@field ReqResetReturnDetailsMessage PartnerProto.ResetReturnReq @请求：查看重置返还详情
---@field ResResetReturnDetailsMessage PartnerProto.ResetReturnDetails @响应：重置返还详情
---@field ResPartnerChangeMessage PartnerProto.PartnerChangeRes @响应：伙伴信息变化
---@field ResPartnerStarLvUpMessage PartnerProto.PartnerStarLvUpRes @响应：伙伴升星成功
---@field ReqFastPartnerUpStarLvMessage PartnerProto.FastPartnerUpStarLvReq @请求：伙伴快捷升星
---@field ResFastPartnerUpStarLvMessage PartnerProto.FastPartnerUpStarLvRes @响应：伙伴快捷升星结果
---@field ReqPartnerTransformMessage PartnerProto.PartnerTransformReq @请求：伙伴转化
---@field ResPartnerTransformMessage PartnerProto.PartnerTransformRes @响应：伙伴转化
---@field ReqPartnerRebornMessage PartnerProto.OperatePartner @请求：伙伴重生
---@field ResPartnerRebornMessage PartnerProto.PartnerRebornRes @响应：伙伴重生结果
---@field ReqConfirmPartnerRebornMessage PartnerProto.ConfirmPartnerRebornReq @请求：确认伙伴重生结果
---@field ResConfirmPartnerRebornMessage . @响应：伙伴重生确认完成
---@field ResEvolvePartnerMessage . @响应：伙伴进化成功
---@field ResPartnerRaffleInfoMessage PartnerProto.PartnerRaffleInfoRes @响应：抽卡信息
---@field ReqPartnerRaffleInfoMessage . @请求：抽卡信息
---@field ReqPartnerHatchInfoMessage . @请求：获取伙伴孵化信息
---@field ResPartnerHatchInfoMessage PartnerProto.PartnerHatchInfoRes @响应：伙伴孵化信息
---@field ReqPartnerInputEggMessage PartnerProto.PartnerInputEggReq @请求：孵化一个伙伴蛋
---@field ResPartnerInputEggMessage PartnerProto.PartnerInputEggRes @响应：孵化一个伙伴蛋
---@field ReqPartnerInputEggsMessage . @请求：一键孵化伙伴蛋
---@field ResPartnerInputEggsMessage PartnerProto.PartnerInputEggRes @响应：一键孵化伙伴蛋
---@field ReqPartnerRaffleSubmitMessage PartnerProto.PartnerRaffleSubmitReq @请求：抽卡提交
---@field ResPartnerRaffleSubmitMessage PartnerProto.PartnerRaffleSubmitRes @响应：抽卡提交
---@field ReqSetPartnerWishMessage PartnerProto.SetPartnerWishReq @请求：设置心愿单
---@field ReqAccelerationHatchMessage PartnerProto.AccelerationHatchReq @请求：加速孵化
---@field ResAccelerationHatchMessage PartnerProto.AccelerationHatchRes @响应：加速孵化
---@field ReqOpenPartnerEggMessage PartnerProto.OpenPartnerEggReq @请求：开启伙伴孵化蛋
---@field ResOpenPartnerEggMessage PartnerProto.OpenPartnerEggRes @响应：开启伙伴孵化蛋
---@field ReqViewPartnerWishMessage . @请求：查看心愿单
---@field ResViewPartnerWishMessage PartnerProto.ViewPartnerWishRes @响应：查看心愿单
---@field ReqSetPartnerRaffleCampMessage PartnerProto.SetPartnerRaffleCampReq @请求:设置-招募-阵营
---@field ReqPartnerRaffleBoxRewardMessage PartnerProto.PartnerRaffleBoxRewardReq @请求:累计-宝箱-领取
---@field ReqPartnerCallMessage PartnerProto.PartnerCallReq @请求:召唤出伙伴(如果已经有伙伴出战，则出战的伙伴会被替换)
---@field ReqPartnerReCallMessage PartnerProto.PartnerReCallReq @请求:召唤回伙伴
---@field ReqPartnerSkillMessage PartnerProto.PartnerSkillReq @请求:伙伴释放大招
---@field ResPartnerCallMessage PartnerProto.PartnerCallRes @响应：召唤伙伴
---@field ResPartnerSkillMessage PartnerProto.PartnerSkillRes @响应：伙伴释放技能(此协议只在释放失败时响应)
---@field ResPartnerRaffleBoxRewardMessage PartnerProto.PartnerRaffleBoxRewardRes @响应:累计-宝箱-领取
---@field ReqPartnerRaffleBuyMessage PartnerProto.PartnerRaffleBuyReq @请求:购买道具
---@field ResPartnerRaffleBuyMessage PartnerProto.PartnerRaffleBuyRes @响应:购买道具
---@field ResSetPartnerRaffleCampMessage PartnerProto.PartnerRaffleCampRes @响应:设置-招募-阵营
---@field ResReLockPartnerRaffleCampMessage . @响应:重新上锁-阵营
---@field ReqRolePartnerInfoMessage PartnerProto.RolePartnerInfoReq @请求:获取角色伙伴信息
---@field ResRolePartnerInfoMessage PartnerProto.RolePartnerInfoRes @响应:对应角色伙伴信息
---partner_lay.xml
---@field ResPartnerDispatchChangeMessage PartnerLayProto.PartnerDispatchChangeRes @伙伴派遣_变化
---@field ReqPartnerDispatchFlushMessage PartnerLayProto.PartnerDispatchFlushReq @伙伴派遣_刷新
---@field ReqPartnerDispatchAcceptMessage PartnerLayProto.PartnerDispatchAcceptReq @伙伴派遣_接受
---@field ReqPartnerDispatchUpSpeedMessage PartnerLayProto.PartnerDispatchUpSpeedReq @伙伴派遣_加速
---@field ReqPartnerDispatchStartMessage PartnerLayProto.PartnerDispatchStartReq @伙伴派遣_开始
---@field ReqPartnerDispatchRewardMessage PartnerLayProto.PartnerDispatchRewardReq @请求：伙伴派遣_领奖
---@field ResPartnerDispatchResultMessage PartnerLayProto.PartnerDispatchResultRes @伙伴派遣结果
---@field ResPartnerDispatchRewardMessage PartnerLayProto.PartnerDispatchRewardRes @响应：伙伴派遣_领奖
---@field ResDispatchFlushVipFreeCountMessage PartnerLayProto.DispatchFlushVipFreeCountRes @响应：vip已使用免费刷新次数
---rank.xml
---@field ReqRankListMessage RankProto.RankListReq @排行榜请求
---@field ResRankListMessage RankProto.RankList @排行榜返回
---recharge.xml
---@field ReqOpenRechargePanelMessage RechargeProtos.ReqRechargePanel @请求任务内容
---@field ResRechargePanelMessage RechargeProtos.ResRechargePanel @发送所有任务
---@field ReqRoleRechargeMessage RechargeProtos.ReqReCharge @充值 请求
---@field ResRoleRechargeMessage RechargeProtos.RechargeCount @充值 响应
---@field ReqRechargeOrderIdMessage RechargeProtos.ReqRechargeOrderId @充值-生成订单 请求
---@field ResRechargeOrderIdMessage RechargeProtos.ResRechargeOrderId @充值-生成订单 响应
---role.xml
---@field ReqDeployAttrPointMessage RoleProtos.DeployAttrPointReq @分配属性点
---@field ReqResetAttrPointMessage RoleProtos.ResetAttrPointReq @重置属性点
---@field ResNoticeAttrPointMessage RoleProtos.NoticeAttrPointRes @通知分配属性点:分配属性点请求，重置
---@field ReqTryResetAttrPointMessage RoleProtos.TryResetAttrPointReq @预重置属性点
---@field ResTryResetAttrPointMessage RoleProtos.TryResetAttrPointRes @预重置属性点
---@field ResChangeNameMessage RoleProtos.ChangeNameRes @修改名称
---@field ResTransferCareerMessage RoleProtos.TransferCareerRes @响应:转职成功
---@field ResVipInitMessage RoleProtos.VipInitRes @登录和创角：成功给消息
---@field ResVipChangeMessage RoleProtos.VipChangeRes @VIP更新响应
---@field ReqVipUpMessage RoleProtos.VipUpReq @VIP升级请求
---@field ReqVipActivateMessage RoleProtos.VipActivateReq @VIP激活
---@field ResVipActivateMessage RoleProtos.VipActivateRes @激活响应
---@field ReqVipExchangeMessage RoleProtos.VipExchangeReq @兑换 请求
---@field ResVipExchangeMessage RoleProtos.VipExchangeRes @兑换 响应
---@field ResVipUpMessage RoleProtos.VipUpRes @升级 响应
---@field ReqRechargeMessage RoleProtos.ReChargeReq @充值 请求
---@field ResRechargeMessage RoleProtos.ReChargeRes @充值 响应
---@field ReqDailyRewardMessage RoleProtos.DailyRewardReq @查看每日礼包已充值数量 请求
---@field ResDailyRewardMessage RoleProtos.DailyRewardRes @查看每日礼包已充值数量 响应
---@field ReqRewardHistoryInfoMessage RoleProtos.RewardHistoryInfoReq @查看充值历史记录 请求
---@field ResRewardHistoryInfoMessage RoleProtos.RewardHistoryInfoRes @查看充值历史记录 响应
---@field ReqTotalRewardMessage RoleProtos.TotalRewardReq @查看累计礼包已充值数量 请求
---@field ResTotalRewardMessage RoleProtos.TotalRewardRes @查看累计礼包已充值数量 响应
---@field ReqFirstRewardMessage RoleProtos.FirstRewardReq @查看钻石礼包首充领取数量 请求
---@field ResFirstRewardMessage RoleProtos.FirstRewardRes @查看钻石礼包首充领取数量 响应
---@field ReqBuyVipLevelGiftBagMessage RoleProtos.BuyVipGiftBag @购买VIP礼包 请求
---@field ResBuyVipLevelGiftBagMessage RoleProtos.BuyVipGiftBag @购买VIP礼包 响应
---@field ReqWelfareInfoMessage RoleProtos.WelfareInfoReq @查看福利(月卡、赞助、基金)详情请求
---@field ResWelfareInfoMessage RoleProtos.WelfareInfoRes @福利福利(月卡、赞助、基金)详情响应
---@field ReqBuyWelfareMessage RoleProtos.BuyWelfareReq @购买福利(月卡、赞助、基金)请求
---@field ReqReceiveWelfareMessage RoleProtos.ReceiveWelfareReq @领取福利(月卡、赞助、基金)奖励请求
---@field ReqLimitRewardMessage . @查看限时领取奖励 请求
---@field ResLimitRewardMessage RoleProtos.LimitRewardRes @查看限时领取奖励 响应
---@field ReqTransferCareerMessage RoleProtos.TransferCareerReq @转职请求
---@field ResNextCareersMessage RoleProtos.NextCareersRes @转职后的目标职业 响应
---@field ReqMenuIsDisplayMessage . @页签是否显示 请求
---@field ResMenuIsDisplayMessage RoleProtos.MenuIsDisplayRes @页签是否显示 响应
---@field ResOpenTransferCareerMessage RoleProtos.OpenTransferCareerRes @使用职业转换道具后打开页面 响应
---@field ResObtainWorldLevelMessage RoleProtos.ObtainWorldLevelRes @获取世界等级 响应
---@field ReqReceivePreviewRewardMessage RoleProtos.ReceivePreviewRewardReq @领取预告奖励 请求
---@field ResPreviewRewardInfoMessage RoleProtos.ReceivePreviewRewardRes @预告奖励领取信息 响应
---@field ReqCancelTransferCareerMessage . @请求：撤销-转职
---@field ResCancelTransferCareerMessage RoleProtos.CancelTransferCareerRes @响应：撤销-转职
---@field ResPinkDiamondInfoMessage RoleProtos.PinkDiamondInfoRes @响应：红钻信息
---@field ReqPinkDiamondRewardMessage . @请求：红钻领奖
---@field ResPinkDiamondRewardMessage RoleProtos.PinkDiamondSendRes @响应：红钻领奖
---@field ReqActiveVipLvMessage RoleProtos.ActiveVipLvReq @请求：激活vip等级
---@field ResActiveVipLvMessage RoleProtos.ActiveVipLvRes @响应：激活vip等级
---@field ReqUnlockVipMessage RoleProtos.UnlockVipReq @请求：解锁
---@field ResUnlockVipMessage RoleProtos.UnlockVipRes @响应：解锁
---@field ReqRewardVipMessage RoleProtos.RewardVipReq @请求：领取
---@field ResRewardVipMessage RoleProtos.RewardVipRes @响应：领取
---@field ReqPinkDiamondSendMessage . @请求：红钻面板展示信息
---@field ResPinkDiamondSendMessage RoleProtos.PinkDiamondSendRes @响应：红钻面板展示信息
---@field ReqTransferCareerByTaskMessage RoleProtos.TransferCareerByTaskReq @请求转职
---@field ResAlreadyBuyWelfareMessage RoleProtos.AlreadyBuyWelfare @响应：已购买的所有福利项(月卡、赞助等)
---@field ResTransferCareerByTaskMessage . @请求转职返回（只有成功才会发）
---@field ResMiniGameInfoMessage RoleProtos.MiniGameInfoRes @星云星图信息同步(也叫小游戏)
---@field ReqMiniGameUpgradeMessage RoleProtos.MiniGameUpgradeReq @星云星图升级(也叫小游戏)
---@field ResGainExpMessage RoleProtos.GainExpRes @响应：获取经验之后给客户端响应信息
---@field ResFirstRechargeMessage RoleProtos.FistRecharge @响应: 玩家首充信息
---@field ResCDChangedMessage RoleProtos.CDBean @玩家CD变化
---@field ResFirstChargeViewMessage RoleProtos.FirstChargeViewRes @首充奖励界面 响应
---@field ReqReceiveFirstChargeMessage RoleProtos.ReceiveFirstChargeReq @领取奖励 请求
---@field ReqFirstChargeViewMessage . @首充奖励界面 请求
---@field ReqSponsorViewMessage . @赞助界面 请求
---@field ResSponsorViewMessage RoleProtos.SponsorViewRes @赞助界面 响应
---@field ReqActiveSponsorMessage RoleProtos.ActiveSponsorReq @激活赞助 请求
---@field ReqRechargeDailyViewMessage . @累计充值界面 请求
---@field ResRechargeDailyViewMessage RoleProtos.RechargeDailyViewRes @累计充值界面 响应
---@field ReqReceiveRechargeDailyMessage RoleProtos.ReceiveRechargeDailyReq @领取累计充值 请求
---@field ReqBuyVipTimesMessage RoleProtos.BuyVipTimesReq @请求：购买vip次数
---@field ResBuyVipTimesChangeMessage RoleProtos.BuyVipTimesChangeRes @响应:购买vip次数变化
---@field ResUnlockNewMapMessage RoleProtos.UnlockNewMapRes @解锁新地图 响应
---@field ReqChangeNameMessage RoleProtos.ChangeNameReq @修改名称
---@field ReqRoleAccumulatedRechargeMessage . @请求：查询累计充值金额
---@field ResRoleAccumulatedRechargeMessage RoleProtos.ResRoleAccumulatedRecharge @响应：累计充值金额
---@field ReqReceiveLimitTotalRechargeMessage RoleProtos.ReceiveLimitTotalRechargeReq @请求 领取限时累计充值
---@field ReqMonthlyCardViewMessage . @请求 奇迹币月卡界面
---@field ResMonthlyCardViewMessage RoleProtos.MonthlyCardViewRes @响应 奇迹币月卡界面
---@field ReqReceiveMonthlyCardMessage RoleProtos.ReceiveMonthlyCardReq @请求 领取奇迹币月卡
---@field ResReceiveMonthlyCardMessage RoleProtos.ReceiveMonthlyCardRes @响应 领取奇迹币月卡
---@field ReqLimitTotalRechargeViewMessage . @请求 限时累计充值面板
---@field ResLimitTotalRechargeViewMessage RoleProtos.LimitTotalRechargeViewRes @响应 限时累计充值面板
---@field ReqFirstRechargeViewMessage RoleProtos.FirstRechargeViewReq @请求：首充活动界面
---@field ResFirstRechargeViewMessage RoleProtos.FirstRechargeViewRes @响应：首充活动界面
---@field ReqReceiveFirstRechargeMessage RoleProtos.ReceiveFirstRechargeReq @请求：领取首充活动
---@field ResFirstRechargeOpenStateMessage RoleProtos.FirstRechargeOpenStateRes @响应：首充刷新状态
---@field ReqFirstRechargeMessage RoleProtos.FirstRechargeReq @响应：首充充值
---@field ReqAlsoFirstRechargeMessage . @请求：首充记录
---@field ResAlsoFirstRechargeMessage RoleProtos.AlsoFirstRecharge @响应：首充记录
---@field ResRoleBasicAttrMessage RoleProtos.RoleBasicAttrRes @响应：发送角色基础属性信息
---@field ResRoleDeployAttrPointMessage RoleProtos.DeployResult @响应：角色加点成功
---schedule.xml
---@field ResFlushTypeMessage ScheduleProto.FlushTypeRes @刷新类型消息
---skill.xml
---@field ReqUpSkillMessage SkillProtos.UpSkillReq @技能学习或者升级
---@field ResSkillChangeMessage SkillProtos.SkillChangeRes @技能学习或者升级
---@field ResMainSkillMessage SkillProtos.MainSkillRes @普通攻击技能信息
---@field ReqMasterSkillAddTittleMessage SkillProtos.MasterSkillAddTittle @请求：大师技能加点
---@field ResMasterSkillTittleChangeMessage SkillProtos.MasterSkill @响应：大师技能点发生改变
---@field ReqResetMasterSkillTittleMessage . @请求：重置大师点数
---@field ResMasterSkillInfosMessage SkillProtos.MasterSkill @响应：大师技能信息详情
---@field ResResetMasterSkillTittleMessage . @响应：重置大师点数
---@field ResCaromSkillMessage SkillProtos.CaromSkill @所有连击技能
---@field ResSkillLockMessage SkillProtos.SkillChangeRes @响应：指定技能上锁
---@field ResSkillUnlockMessage SkillProtos.SkillChangeRes @响应：指定技能解锁
---stall.xml
---@field ReqBeginStallMessage StallProto.BeginStallReq @请求：开始摆摊
---@field ResBeginStallMessage StallProto.BeginStallRes @响应：开始摆摊
---@field ReqOpenStallMessage StallProto.OpenStallReq @请求：查看摊位
---@field ResStallInfoMessage StallProto.StallInfoRes @响应：摊位信息
---@field ReqAddStallItemMessage StallProto.AddStallItemReq @请求：上架物品
---@field ReqRemoveStallItemMessage StallProto.RemoveStallItemReq @请求：下架物品
---@field ReqOverStallMessage . @请求：收摊
---@field ReqUpdateStallInfoMessage StallProto.UpdateStallInfoReq @请求：修改摊位信息(广告)
---@field ReqBuyStallItemMessage StallProto.BuyStallItemReq @请求：购买物品
---@field ReqSalesRecordMessage . @请求：查看出售记录
---@field ResSalesRecordMessage StallProto.StallSalesRecordRes @响应：出售记录详情
---@field ResUpdateStallMessage StallProto.StallInfoRes @响应：摊位更新(仅更新数据,不弹开界面)
---store.xml
---@field ReqStoreMessage . @仓库请求
---@field ResStoreMessage StoreProto.StoreInfoRes @仓库请求返回
---@field ReqStoreToBagMessage StoreProto.storeToBagReq @背包拖到仓库请求
---@field ReqBagToStoreMessage StoreProto.BagToStoreReq @背包拖到仓库请求
---@field ResStoreChangeMessage StoreProto.StoreChangeRes @仓库信息改变响应
---@field ReqTidyStoreItemMessage StoreProto.TidyStoreItemReq @仓库整理请求
---@field ReqSwapStoreItemMessage StoreProto.SwapStoreItemReq @交换道具请求
---@field ResSwapStoreItemMessage StoreProto.SwapStoreItemRes @交换道具响应
---@field ResLockStoreGridMessage StoreProto.LockStoreGridRes @锁仓库格子响应
---@field ReqBagPutStoreButtonMessage StoreProto.BagPutStoreButtonReq @背包存入按钮请求
---@field ReqStoreTakeButtonMessage StoreProto.StoreTakeButtonReq @仓库按钮取出请求
---@field ReqStoreGiveUpItemMessage StoreProto.StoreGiveUpItemReq @仓库丢弃道具
---@field ReqStoreAddCapacityMessage StoreProto.StoreAddCapacityReq @仓库扩容
---@field ReqStoreAddPageMessage StoreProto.StoreAddPageReq @仓库扩页
---@field ResTidyStoreItemMessage StoreProto.TidyStoreItemRes @仓库整理请求
---sunday_activities.xml
---@field ReqGoldArmyTaskInfoMessage . @请求: 黄金部队任务信息
---@field ResGoldArmyTaskInfoMessage SundayActivityProto.GoldArmyTaskInfo @响应: 黄金部队任务信息
---@field ReqReceiveGoldArmyRewardMessage SundayActivityProto.ReceiveGoldArmyRewardReq @请求: 领取黄金部队任务奖励
---@field ReqSundayGiftPacksMenuMessage . @请求: 领取周日礼包菜单
---@field ResSundayGiftPacksMenuMessage SundayActivityProto.SundayGiftPacksMenu @响应: 周日礼包菜单
---@field ReqBuySundayGiftPacksMessage SundayActivityProto.BuySundayGiftPackReq @请求: 购买周日礼包
---talent.xml
---@field ReqTalentInfoMessage TalentProtos.TalentInfoReq @请求天赋信息
---@field ResTalentInfoMessage TalentProtos.TalentInfoResp @服务器返回天赋信息
---@field ResTalentInfoUpdateSynMessage TalentProtos.TalentInfoUpdateSyn @更新天赋部分信息
---@field ReqTalentExpExchangeMessage TalentProtos.TalentExpExchangeReq @请求兑换经验
---@field ReqTalentUpgradeMessage TalentProtos.TalentUpgradeReq @请求升级天赋
---@field ReqTalentResetMessage TalentProtos.TalentResetReq @请求重置天赋
---task.xml
---@field ResSendAllTaskMessage TaskProtos.SendAllTaskRes @发送所有任务
---@field ReqSendTaskInfoMessage TaskProtos.SendTaskInfoReq @请求任务内容
---@field ReqAcceptTaskMessage TaskProtos.AcceptTaskReq @接受任务
---@field ReqGiveUpTaskMessage TaskProtos.GiveUpTaskReq @放弃任务
---@field ReqSubmitTaskMessage TaskProtos.SubmitTaskReq @提交任务
---@field ResTaskRewardMessage TaskProtos.TaskRewardRes @发送任务奖励道具
---@field ResRoleTaskChangeMessage TaskProtos.RoleTaskChangeRes @玩家任务统一回包
---@field ReqClickTaskMessage TaskProtos.clickTask @当前选中的任务
---@field ReqCheckAcceptTaskMessage TaskProtos.AcceptTaskReq @是否可以领取任务-请求
---@field ResCheckAcceptTaskMessage TaskProtos.checkAcceptTaskRes @是否可以领取任务-响应
---@field ResGoldTaskUpdateMessage TaskProtos.TaskInfo @响应:黄金挑战任务更新
---@field ReqRoleEffectMessage . @请求:效率信息
---@field ResRoleEffectChangeMessage TaskProtos.RoleEffectChangeRes @响应:效率信息
---@field ResAchievementChangeMessage TaskProtos.AchievementChange @响应：玩家成就统一回包
---@field ReqUpAchievementBattleStratumMessage . @请求：升级战阶
---@field ResAchievementInfoMessage TaskProtos.AchievementInfo @响应：成就系统信息
---@field ReqSubmitAchievementTaskMessage TaskProtos.AchievementId @请求:提交任务
---@field ResUpAchievementBattleStratumMessage TaskProtos.UpBattleStratum @响应：升阶结果
---@field ReqBossFistKillInfoMessage . @请求: 开服竞技详情
---@field ResBossFistKillInfoMessage TaskProtos.ResBossFistKillPanel @响应：开服竞技详情
---@field ReqGetNewAreaRankBossRewardMessage TaskProtos.GetNewAreaRankBossReward @请求: 领取Boss首杀奖励
---@field ReqNewAreaRankInfoMessage TaskProtos.ReqRankInfo @请求: 请求开服竞技排行榜
---@field ResNewAreaRankInfoMessage TaskProtos.ResRankInfo @响应：开服竞技排行详情
---@field ReqNewAreaRankGetPersonalRewardMessage TaskProtos.ReqGetPersonalReward @请求: 领取开服竞技个人目标奖励
---@field ReqNewAreaRankRedPointMessage . @请求: 开服竞技红点信息
---@field ResNewAreaRankRedPointMessage TaskProtos.NewAreaRankRedPoint @响应：开服竞技红点信息
---@field ResNewAreaRankGetPersonalRewardMessage TaskProtos.GetPersonalReward @响应：开服竞技个人奖励领取结果
---@field ResKingRoadTaskInfoMessage TaskProtos.KingRoadTaskInfo @响应: 王者之路任务详情
---@field ReqReceiveKingRoadAwardMessage TaskProtos.ReqKingRoadAward @请求:领取王者之路任务奖励
---@field ResKingRoadChapterUpdateMessage TaskProtos.KingRoadChapterUpdate @响应: 王者之路任务章节更新
---@field ResOfferRewardBossPanelMessage TaskProtos.ResOfferRewardPanle @响应：boss悬赏面板
---@field ReqGetOfferBossRewardMessage TaskProtos.GetOfferReward @请求: 领取Boss悬赏奖励
---@field ResGetOfferBossRewardMessage TaskProtos.GetOfferReward @响应：boss悬赏奖励领取完成
---@field ReqGetOfferBossPanelMessage . @请求: 请求boss悬赏面板
---team.xml
---@field ReqMarryMessage TeamProto.MarryReq @结婚请求
---@field ResAskMarryMessage TeamProto.AskMarryRes @有人向你请求结婚
---@field ReqAgreeMarryMessage TeamProto.AgreeMarryReq @同意结婚请求
---@field ResAgreeMarryMessage TeamProto.AgreeMarryRes @同意结婚响应
---@field ReqDivorceMessage . @离婚请求
---@field ResMarryInfoMessage TeamProto.MarryInfoRes @结婚信息响应
---@field ReqCancelOrRejectDivorceMessage . @取消、拒绝离婚请求
---@field ReqCompulsoryDivorceMessage . @强制离婚请求
---@field ReqAgreeDivorceMessage . @同意离婚请求
---@field ReqMarryInfoMessage . @结婚信息获取请求
---@field ReqCreateTeamMessage . @请求:创建队伍
---@field ResTeamInfoMessage TeamProto.TeamInfo @响应:队伍信息
---@field ReqTeamInfoMessage . @请求队伍信息
---@field ReqQuitTeamMessage . @请求:离开队伍
---@field ReqPlayerListMessage TeamProto.ReqPlayerList @请求:玩家列表
---@field ResPlayerListMessage TeamProto.PlayerList @响应:玩家列表
---@field ReqSendTeamInvitationMessage TeamProto.OperationTarget @请求:发出队伍邀请
---@field ResTeamAlertMessage . @响应:邀请/申请的气泡提示
---@field ReqInviteListOrApplyListMessage . @请求:查看邀请/申请列表
---@field ResInvitationListMessage TeamProto.InvitationList @响应:邀请列表
---@field ResApplicationListMessage TeamProto.ApplicationList @响应:申请列表
---@field ReqReplyInvitationMessage TeamProto.ReplyInvitation @请求:回复邀请
---@field ReqNearbyTeamListMessage . @请求:查看附近队伍
---@field ResNearbyTeamListMessage TeamProto.NearbyTeamList @响应:附近队伍列表
---@field ReqApplyJoinTeamMessage TeamProto.ApplyTeamInfo @请求:申请加入队伍
---@field ReqReplyApplyMessage TeamProto.ReplyApply @请求:回复申请
---@field ReqKickOutMemberMessage TeamProto.OperationTarget @请求:踢出成员
---@field ReqChangeCaptainMessage TeamProto.OperationTarget @请求:转移队长
---@field ReqPublishRecruitInfoMessage TeamProto.PublishRecruitInfoReq @请求:发布招募信息
---@field ResTeamMemberHpChangeMessage TeamProto.TeamMemberHpChangeRes @响应:队员血条变化
---@field ReqCreateTeamAndInviteMessage TeamProto.CreateTeamAndInviteReq @请求:创建队伍并邀请玩家入队
---@field ResTeamLoseMessage TeamProto.TeamLoseRes @队伍已消失
---@field ResTeamLoseByLeaderMessage TeamProto.TeamLoseByLeaderRes @队伍已消失
---@field ReqTeamRoleTeamIdMessage TeamProto.reqTeamId @请求某个玩家的队伍id
---@field ResTeamRoleTeamIdMessage TeamProto.resRoleTeamId @返回某个玩家的队伍id
---@field ReqClearInviteOrApplyMessage . @清理邀请记录和申请记录
---tip.xml
---@field ResTipMessage TipProto.TipMsg @提示消息
---title.xml
---@field ReqGetTitleListMessage . @获取称号列表请求
---@field ResTitleListMessage TitleProto.TitleList @称号列表响应
---@field ReqEquipTitleMessage TitleProto.TitleId @装备称号/取消装备称号请求
---@field ReqGetTitleListMessage2Message . @获取称号列表请求
---@field ResTitleListMessage2Message TitleProto.TitleList2 @称号列表响应
---@field ReqEquipTitleMessage2Message TitleProto.EquipTitleReq @装备称号/取消装备称号请求
---@field ReqTitleStrengthenMessage TitleProto.TitleId @称号强化
---@field ResTitleStrengthenMessage TitleProto.TitleInfo2 @称号强化响应
---@field ReqTitleHiddenStateChangeMessage . @称号隐藏/取消隐藏请求
---@field ResTitleHiddenStateChangeMessage TitleProto.Hidden @称号隐藏/取消隐藏称号成功响应
---trade.xml
---@field ReqTradeMessage TradeProto.TradeReq @请求进行交易
---@field ResTradeMessage TradeProto.TradeRes @返回交易请求
---@field ReqAgreeTradeMessage TradeProto.AgreeTradeReq @同意交易
---@field ReqSetTradeProgressMessage TradeProto.SetTradeProgressReq @设置交易进度
---@field ResTradeStateChangeMessage TradeProto.TradeStateChangeRes @返回交易状态变化
---@field ResTradeStartMessage TradeProto.TradeInfo @交易开始
---@field ResTradeUpdateMessage TradeProto.TradeInfo @交易变化
---@field ReqAddItemToTradeMessage TradeProto.AddItemToTradeReq @添加物品请求
---@field ReqRemoveItemFromTradeMessage TradeProto.RemoveItemFromTradeReq @去除物品请求
---@field ResTradeGoodsMessage TradeProto.TradeGoodInfoRes @返回商品信息
---tradeline.xml
---@field ReqGoodsInfoMessage . @请求交易行商品信息
---@field ResGoodsInfoMessage TradeLineProto.GoodsInfoRes @交易行商品信息列表响应
---@field ReqMyShelvesMessage . @请求我的上架信息
---@field ResMyShelvesMessage TradeLineProto.MyShelvesRes @我的上架信息响应
---@field ReqUpShelfGoodsMessage TradeLineProto.UpShelfGoodsReq @请求上架商品
---@field ReqDownShelfGoodsMessage TradeLineProto.DownShelfGoodsReq @请求下架商品
---@field ReqBuyGoodsMessage TradeLineProto.BuyGoodsReq @请求购买商品
---@field ResBuyGoodsMessage . @购买商品响应
---@field ReqTradeLineRecordMessage . @请求查询交易行交易记录
---@field ResTradeLineRecordMessage TradeLineProto.TradeLineRecordRes @交易行交易记录响应
---@field ReqAuctionGoodsMessage TradeLineProto.AuctionGoodsReq @竞拍商品请求
---@field ResTradeLineGoodsUpdateMessage TradeLineProto.TradeLineGoodsUpdateRes @交易行商品更新响应
---@field ReqPreorderGoodsInfoMessage TradeLineProto.PreorderGoodsInfoReq @请求预购商品信息
---@field ResPreorderGoodsListMessage TradeLineProto.PreOrderGoodsListRes @预购商品列表响应
---@field ResBiddingFailMessage TradeLineProto.BiddingFailRes @奇迹5竞拍失败提示
---@field ReqBiddingGoodsInfoMessage . @请求竞拍商品信息
---@field ResBiddingGoodsInfoMessage TradeLineProto.BiddingGoodsListRes @响应竞拍商品信息
---@field ResBiddingResultMessage TradeLineProto.BiddingResultRes @响应竞拍商品信息
---@field ResGoodsOfGardBossVaildMessage TradeLineProto.GardBossVaild @交易行战盟boss是否有效攻击响应
---ui.xml
---@field ReqUiMessage UiProtos.UiReq @Ui请求操作
---@field ResRefreshUiMessage UiProtos.ResRefreshUi @重绘Ui
---@field ResMsgBoxMessage UiProtos.MsgBoxRes @响应：弹出提示框
---@field ReqUiCloseMessage UiProtos.UiCloseReq @关闭UI
---@field ResFilterGlobalMsgMessage UiProtos.FilterGlobalMsgRes @过滤全服信息提示
---@field ResOpenHyperlinkMessage UiProtos.OpenHyperlinkRes @使用脚本调出游戏面板
---@field ResAddButtonMessage UiProtos.AddButtonRes @添加自定义按钮
---@field ResDelButtonMessage UiProtos.DelButtonRes @删除自定义按钮
---@field ResRedDotMessage UiProtos.RedDotRes @添加按钮红点
---@field ResRedDelMessage UiProtos.RedDelRes @删除按钮红点
---@field ResNavigationMessage UiProtos.NavigationRes @新手界面引导功能
---@field ResOpenNpcShowExMessage UiProtos.OpenNpceShowExRes @自动寻路打开指定NPC面板
---@field ResOpenWindowsMessage UiProtos.OpenWindowsRes @查看人物角色面板
---@field ResViewPlayerMessage UiProtos.ViewPlayerRes @查看别人角色面板
---@field ResOpenNpcShowMessage UiProtos.OpenNpcShow @打开指定NPC面板
---@field ResMapEffectMessage UiProtos.MapEffectRes @在地图上播放场景特效
---@field ResDelMapEffectMessage UiProtos.DelMapEffectRes @删除地图特效
---@field ReqBagToTmpItemBoxMessage UiProtos.BagToTmpItemBoxReq @请求：从背包到TmpItemBox(ok框)
---@field ResBagToTmpItemBoxMessage UiProtos.BagToTmpItemBoxRes @返回：从背包到TmpItemBox(ok框)
---@field ReqTmpItemBoxToBagMessage UiProtos.TmpItemBoxToBagReq @请求: 从TmpItemBox(ok框)到背包
---@field ResTmpItemBoxToBagMessage UiProtos.TmpItemBoxToBagRes @返回：从TmpItemBox(ok框)到背包
---@field ResUpdateItemGmExtMessage UiProtos.UpdateItemGmExtRes @返回：改变道具名字和名字颜色响应
---@field ResRedDotListMessage UiProtos.RedDotList @红点列表
---union.xml
---@field ReqCreateUnionMessage UnionProto.CreateUnionReq @创建战盟
---@field ResCreateUnionMessage UnionProto.ViewUnionRes @响应:创建战盟
---@field ReqAllUnionMessage . @所有战盟信息请求
---@field ResAllUnionMessage UnionProto.AllUnionRes @所有战盟信息响应
---@field ReqUnionDetailsMessage UnionProto.UnionDetailsReq @单个战盟信息
---@field ResUnionDetailsMessage UnionProto.UnionDetailsRes @响应：单个战盟信息
---@field ReqViewUnionMessage . @战盟信息请求
---@field ResViewUnionMessage UnionProto.ViewUnionRes @战盟信息响应
---@field ReqApplyJoinUnionMessage UnionProto.ApplyJoinUnionReq @请求：申请加入
---@field ResApplyJoinUnionMessage UnionProto.ApplyJoinUnionRes @响应：申请加入
---@field ResEnterUnionMessage UnionProto.ViewUnionRes @响应: 给申请者响应战盟信息
---@field ReqAgreeUnionApplyMessage UnionProto.AgreeUnionApplyReq @请求:处理申请列表
---@field ResViewUnionChangeMessage UnionProto.ViewUnionRes @详细信息实时变更
---@field ResUnionMemberChangeMessage UnionProto.UnionMemberChangeRes @成员实时变更
---@field ReqSendApplyListInfoMessage . @请求：查看入会申请列表
---@field ResSendApplyListInfoMessage UnionProto.SendApplyListInfoRes @响应：查看入会申请列表
---@field ReqModifyArmbandMessage UnionProto.ModifyArmbandReq @请求：修改臂章
---@field ReqChangeAnnouncementMessage UnionProto.ChangeAnnouncementReq @请求：修改公告
---@field ReqAllApplyMessage . @请求：一键申请
---@field ReqQuitUnionMessage . @请求：退出战盟
---@field ReqAllAgreeMessage . @请求：一键同意
---@field ReqAllRejectMessage . @请求：一键拒绝
---@field ReqChangeUnionNameMessage UnionProto.ChangeUnionNameReq @请求：修改名称
---@field ReqKickOutUnionMemberMessage UnionProto.KickOutMemberReq @请求：踢出成员
---@field ReqEnemyUnionMessage UnionProto.EnemyUnionReq @请求：敌对战盟
---@field ReqUnionSettingMessage UnionProto.UnionSetting @请求:招募设置
---@field ResUnionSettingMessage UnionProto.UnionSetting @响应:招募设置
---@field ReqEnemyUnionListMessage . @请求:敌对战盟列表
---@field ResEnemyUnionListMessage UnionProto.EnemyUnionListRes @响应:敌对战盟列表
---@field ReqUnionNameViewMessage UnionProto.ChangeUnionNameViewReq @请求:改名视图
---@field ResUnionNameViewMessage UnionProto.ChangeUnionNameViewRes @响应:改名视图
---@field ReqDonateCapitalMessage UnionProto.DonateCapitalReq @请求:捐献资金
---@field ReqImpeachMasterMessage UnionProto.ImpeachMaster @请求:弹劾盟主
---@field ResUnionApplyListMessage UnionProto.UnionApplyListRes @响应:操作申请列表响应
---@field ResQuitUnionMessage UnionProto.QuitUnionRes @响应：退出战盟
---@field ReqEnemyUnionViewMessage . @请求：发起敌对行会界面
---@field ResEnemyUnionViewMessage UnionProto.EnemyUnionViewRes @响应：发起敌对行会界面
---@field ResLoginEnemyUnionMessage UnionProto.EnemyUnionLestRes @响应：登录发送敌对行会信息
---@field ReqChangePositionMessage UnionProto.ChangePositionReq @请求：更换职位
---@field ReqArmbandsViewMessage . @请求：打开战盟臂章等级界面
---@field ResArmbandsViewMessage UnionProto.UnionArmbandsLevelRes @响应：打开战盟臂章等级界面
---@field ReqArmbandsLevelUpMessage . @请求：臂章等级升级
---@field ResArmbandsLevelChangeMessage UnionProto.ArmbandsLevelChangeRes @响应：臂章等级升级
---@field ReqArmbandsStrongUpMessage UnionProto.ArmbandsStrongUpReq @请求：臂章强化升级
---@field ResArmbandsStrongChangeMessage UnionProto.ArmbandsStrongChangeRes @响应：臂章强化升级
---@field ReqSendUnionTaskListMessage . @请求：发送任务列表
---@field ResSendUnionTaskListMessage UnionProto.SendUnionTaskListRes @响应：发送任务列表
---@field ReqSubmitUnionTaskMessage UnionProto.SubmitUnionTaskReq @请求：领取任务奖励
---@field ResSendOnOfflineMessage UnionProto.SendOnOfflineRes @响应：上下线实时刷新
---@field ReqUnionSalaryMessage . @请求：战盟工资信息
---@field ResUnionSalaryMessage UnionProto.UnionSalaryRes @响应：战盟工资信息
---@field ReqReceiveSalaryMessage . @请求：领取战盟工资
---@field ReqUnionBlessViewMessage UnionProto.UnionBlessViewReq @请求：战盟赐福界面
---@field ResUnionBlessViewMessage UnionProto.UnionBlessViewRes @响应：战盟赐福界面
---@field ReqUnionBlessExtractMessage UnionProto.UnionBlessExtractReq @请求：抽取
---@field ReqBlessOneKeyExtractMessage UnionProto.UnionBlessExtractReq @请求：一键抽取
---@field ResBlessRankInfoMessage UnionProto.BlessInfoRes @响应：赐福获取道具阶级信息
---@field ResUnionEventTypeMessage UnionProto.UnionEventTypeRes @响应：战盟事件类型信息
---@field ReqInitiateSelectUnionLeaderMessage . @请求：战盟竞选
---@field ResSelectUnionLeaderInfoMessage UnionProto.SelectUnionLeaderInfoRes @响应：战盟竞选信息
---@field ResUnionDevoteRefreshMessage UnionProto.UnionDevoteRefreshRes @响应：战盟贡献实时刷新
---@field ResReceiveSalaryMessage UnionProto.ReceiveSalaryRes @响应：领取工资
---@field ResCanReceiveSalaryMessage UnionProto.CanReceiveSalaryRes @响应：能否领取工资
---@field ReqChangeUnionNameByCardMessage UnionProto.ChangeUnionNameByCardReq @请求：改名卡改名
---@field ReqUnionMemberInfoMessage . @请求：战盟成员信息
---@field ResUnionMemberInfoMessage UnionProto.UnionMemberDetailInfo @响应：战盟成员信息
---@field ReqUnionMemberDynamicMessage . @请求：战盟成员动态信息
---@field ResUnionMemberDynamicMessage UnionProto.UnionMemberDynamic @响应：战盟成员动态信息
---@field ReqUpdateUnionInfoMessage UnionProto.UpdateUnionInfo @请求：修改战盟臂章和名字
---@field ResUpdateUnionInfoMessage . @响应：修改战盟臂章和名字
---user.xml
---@field ReqLoginMessage UserProtos.LoginReq @请求登录
---@field ResLoginMessage UserProtos.LoginRes @登录返回
---@field ReqEnterRoleMessage UserProtos.EnterRoleReq @请求进入角色
---@field ResEnterRoleMessage UserProtos.EnterRoleRes @角色进入返回消息
---@field ReqCreateRoleMessage UserProtos.CreateRoleReq @请求创建角色
---@field ResCreateRoleMessage UserProtos.CreateRoleRes @返回创建角色
---@field ReqRemoveRoleMessage UserProtos.RemoveRoleReq @请求删除角色
---@field ResRemoveRoleMessage UserProtos.RemoveRoleRes @返回删除角色
---@field ReqRecoverRoleMessage UserProtos.RecoverRoleReq @请求恢复角色
---@field ResRecoverRoleMessage UserProtos.RecoverRoleRes @返回恢复角色
---@field ReqRoleInfoMessage UserProtos.RoleInfoReq @角色信息请求
---@field ResRoleInfoMessage UserProtos.RoleInfoRes @角色信息响应
---@field ReqRoleSettingMessage UserProtos.RoleSettingReq @角色设定请求
---@field ResRoleSettingMessage UserProtos.RoleSettingRes @角色设定响应
---@field ReqHeartMessage UserProtos.HeartReq @心跳请求
---@field ResHeartMessage UserProtos.HeartRes @心跳响应
---@field ReqQuitGameMessage UserProtos.QuitGameReq @请求大退出:退出游戏
---@field ResQuitGameMessage UserProtos.QuitGameRes @返回:大退出
---@field ReqQuitRoleMessage UserProtos.QuitRoleReq @请求小退出:退出角色,到选角列表
---@field ResQuitRoleMessage UserProtos.QuitRoleRes @返回小退出:退出角色,到选角列表
---@field ResDisplaceUserMessage UserProtos.DisplaceUserRes @被顶号
---@field ReqRandomRoleNameMessage UserProtos.RandomRoleNameReq @角色随机名字请求
---@field ResRandomRoleNameMessage UserProtos.RandomRoleNameRes @角色随机名字响应
---@field ReqHangUpSettingMessage UserProtos.HangUpSettingReq @请求保存挂机设置
---@field ResHangUpSettingMessage UserProtos.HangUpSettingRes @响应挂机设置
---@field ReqSkillShowTypeMessage UserProtos.SkillShowType @设置技能显示请求
---@field ResSkillShowTypeMessage UserProtos.SkillShowType @设置技能显示回包
---@field ReqClientLoadedMessage UserProtos.ClientLoadedReq @客户端进度条加载完毕
---@field ReqOtherRoleInfoMessage UserProtos.OtherRoleInfoReq @其他角色信息请求
---@field ResOtherRoleInfoMessage UserProtos.OtherRoleInfoRes @其他角色信息响应
---@field ReqRoleOthersDataMessage UserProtos.RoleOthersData @请求存储角色其他通用信息
---@field ResRoleOthersDataMessage UserProtos.ResRoleOthersData @响应存储角色其他通用信息
---@field ResMidnightEventMessage . @凌晨事件触发通知客户端响应
---@field ReqRoleFruitInfoMessage UserProtos.RoleFruitInfoReq @角色果实信息请求
---@field ResRoleFruitInfoMessage UserProtos.RoleFruitInfoRes @角色果实信息响应
---@field ReqUpdateEquipLooksMessage UserProtos.UpdateEquipLooksReq @改变角色外观请求
---@field ReqRoleSynthesisLuckyMessage . @请求： 获取角色合成一代幸运值信息
---@field ResRoleSynthesisLuckyMessage UserProtos.SynthesisLuckyRes @响应： 获取角色合成一代幸运值信息
---@field ReqCreateInviteCodeMessage . @请求： 生成邀请码
---@field ResCreateInviteCodeMessage UserProtos.InviteCodeRes @响应： 生成邀请码
---@field ResFreshInviteCodeMessage UserProtos.InviteCodeNumRes @响应： 刷新邀请码数量
---@field ReqCdKeyMessage UserProtos.CdKeyReq @请求：兑换码
---@field ResCdKeyMessage UserProtos.CdKeyRes @响应：兑换码
---@field ReqUpdateEquipLooks2Message UserProtos.UpdateEquipLooks2Req @改变角色外观请求
---@field ReqUnLockUserCareerMessage UserProtos.UnLockUserCareerReq @请求：解锁职业
---@field ResUnLockUserCareerMessage UserProtos.UnLockUserCareerRes @响应：解锁职业
---@field ReqSetAttAddWayMessage UserProtos.SetRoleAttAddWay @设置角色加成方式
---@field ResAttAddWayMessage UserProtos.SetRoleAttAddWay @获取角色加成方式
---@field ReqJiuJiuTradeTokenMessage UserProtos.JiuJiuTradeTokenReq @请求：九九交易行token
---@field ResJiuJiuTradeTokenMessage UserProtos.JiuJiuTradeTokenRes @响应：九九交易行token
---@field ResJiuJiuTradeLockRoleChangeMessage UserProtos.TradeLockRoleChangeRes @响应：九九交易行锁定角色变化信息
---warorder.xml
---@field ResAllWarOrderMessage WarOrderProtos.AllWarOrderInfo @响应所有战令信息
---@field ReqWarOrderUpLevelMessage WarOrderProtos.ReqWarOrderUpLevel @请求战令进阶
---@field ResWarOrderUpLevelMessage WarOrderProtos.ResWarOrderUpLevel @响应战令进阶
---@field ResUpdateOneWarOrderMessage WarOrderProtos.OneWarOrderInfo @更新一条战令信息
---@field ReqWarOrderExchangeMessage WarOrderProtos.ReqWarOrderExchange @兑换请求
---@field ResWarOrderExchangeMessage WarOrderProtos.ResWarOrderExchange @兑换响应
---@field ReqWarOrderAwardMessage WarOrderProtos.ReqWarOrderAward @请求战令领取
---@field ResWarOrderAwardMessage WarOrderProtos.ResWarOrderAward @响应战令领取
---@field ReqWarOrderAwardAllMessage WarOrderProtos.ReqWarOrderAwardAll @请求战令一键领取
---@field ResWarOrderAwardAllMessage WarOrderProtos.ResWarOrderAwardAll @响应战令一键领取
---@field ReqAllWarOrderMessage . @请求所有战令信息
---@field ReqWarOrderAwardTaskMessage WarOrderProtos.ReqAwardTask @请求战令某个任务的奖励
---@field ResWarOrderAwardTaskMessage WarOrderProtos.ResAwardTask @返回战令某个任务的奖励
---@field ResUpdateWarOderTaskGoalMessage WarOrderProtos.UpdateWarTaskGoalRecord @更新战令某个任务目标数据
MessageDef =
{
---activity.xml
	ReqActivityListMessage = 29001,--请求:查看活动列表
	ResActivityListMessage = 29002,--响应:活动列表
	ReqEnterActivityMessage = 29003,--请求:前往活动
	ResActivityStatusMessage = 29004,--响应:活动状态
	ReqEnterDupMessage = 29005,--请求:进入副本
	ResEnterDupResultMessage = 29006,--响应:进入副本的判定结果
	ReqGiveUpEnterDupMessage = 29007,--请求:放弃进入副本
	ResGiveUpEnterDupSuccessMessage = 29008,--响应:放弃进入副本成功
	ResUpdateDupStateMessage = 29009,--响应:更新副本状态
	ReqQuitDupMessage = 29010,--请求:退出副本
	ResQuitDupSuccessMessage = 29011,--响应:退出副本成功
	ResDupScoreRankUpdateMessage = 29012,--响应:副本积分排行更新
	ResDupFinishMessage = 29013,--响应:副本完成
	ReqReceiveAwardMessage = 29014,--请求:领取奖励
	ReqRecruitDupMemberMessage = 29015,--请求:招募副本成员
	ReqEnterDupByRecruitMessage = 29016,--请求:通过招募链接进入副本
	ResEnterDupLeftCountMessage = 29017,--响应: 副本进入剩余次数
	ReqDailyActivityTaskMessage = 29018,--请求日常活动列表
	ResDailyActivityTaskMessage = 29019,--发送日常活动列表
	ReqGetRewardBoxMessage = 29020,--领取宝箱奖励宝箱
	ResSendRewardBoxMessage = 29021,--发送奖励宝箱状态
	ResActivityChangeMessage = 29022,--活动日常任务统一回包
	ReqEnterActivityByNpcMessage = 29023,--请求:通过npc前往活动
	ReqGoldTaskMessage = 29024,--请求:查看黄金挑战任务
	ResGoldTaskMessage = 29025,--响应：黄金挑战任务列表
	ReqReceiveGoldTaskMessage = 29026,--请求:领取黄金挑战任务
	ReqGiveUpGoldTaskMessage = 29027,--请求:放弃黄金挑战任务
	ReqReceiveGoldTaskAwardMessage = 29028,--请求:领取黄金挑战任务奖励
	ReqFlushGoldTaskMessage = 29029,--请求:刷新黄金挑战任务
	ReqDailyActivityAddTimesMesssageMessage = 29030,--请求: 日常活动添加活动次数
	ReqChangePotionsMesssageMessage = 29031,--请求: 一键兑换药水
	ResDevilSquareKillCountUpdateMessage = 29032,--响应:恶魔广场杀怪数量更新
	ResBloodyCastleDPSUpdateMessage = 29033,--响应:血色城堡秒伤更新
	ResActivityStartRemindMessage = 29034,--响应:活动开始提醒
	ResEnterPriDupStatusMessage = 29035,--响应:进入个人副本状态
	ResCanEnterActivityMessage = 29036,--响应:可以进入活动
	ReqEnterActivitySecOkMessage = 29037,--请求:前往副本活动二次确认
	ReqOpenActivityRetrievePanelMessage = 29038,--请求:打开日常活动回收面板
	ResOpenActivityRetrievePanelMessage = 29039,--响应:日常活动回收面板
	ReqRetrieveActivityMessage = 29040,--请求:找回活动剩余次数
	ReqRetrieveChangePotionsMessage = 29041,--请求:兑换药水
	ResLastActivityInfoMessage = 29042,--响应:上次活动信息
	ResActivityAnnounceMessage = 29043,--响应:活动预告
	ReqDuplicateLeftCountMessage = 29044,--请求:请求活动剩余次数
	ResDuplicateLeftCountMessage = 29045,--响应:活动的剩余次数
---bag.xml
	ReqBagInfoMessage = 3001,--返回背包信息
	ResBagInfoMessage = 3002,--返回背包信息
	ResBagChangeMessage = 3003,--背包发生变化
	ReqSwapItemMessage = 3004,--交换背包道具的格子
	ReqGiveUpItemMessage = 3005,--丢弃道具
	ReqTidyItemMessage = 3006,--整理道具
	ReqUseItemMessage = 3007,--使用道具
	ReqDestroyItemMessage = 3008,--销毁道具
	ReqSynthesisItemMessage = 3009,--请求：合成道具
	ResSynthesisItemMessage = 3010,--返回：合成道具
	ReqRecoveryItemMessage = 3011,--请求：回收道具
	ResRecoveryItemMessage = 3012,--返回：回收道具
	ResSwapItemMessage = 3013,--交换背包道具响应
	ReqResolveItemMessage = 3014,--请求：分解道具
	ResResolveItemMessage = 3015,--返回：分解道具
	ResLockBagGridMessage = 3016,--返回：背包锁格子响应
	ResReceiveItemMessage = 3017,--返回：领取道具统一响应
	ResTidyItemMessage = 3018,--返回：整理道具响应
	ReqUseFruitMessage = 3019,--请求：使用果实道具
	ReqJudgeUseItemMessage = 3020,--请求判断使用使用道具GM
	ResJudgeUseItemMessage = 3021,--请求判断使用使用道具GM
	ReqUseItemGMMessage = 3022,--请求使用使用道具GM
	ReqUseTransferItemMessage = 3023,--使用道具
	ReqQuickBuyMessage = 3024,--快捷购买
	ReqUseSelfChoiceBoxMessage = 3025,--请求：使用自选宝箱
	ResOpenBoxStrategyMessage = 3026,--响应：开宝箱入包策略
	ReqBatchOpenBoxMessage = 3027,--请求：批量使用宝箱
	ResBagExpansionMessage = 3028,--响应背包扩容
	ReqResetFruitPointMessage = 3029,--请求：重置果实点数
	ReqOpenFruitResetPageMessage = 3030,--请求：打开果实重置页面
	ResOpenFruitResetPageMessage = 3031,--响应：打开果实重置页面
	ReqBagAddCapacityMessage = 3032,--请求：背包扩容
	ResAutoPickupInfoMessage = 3033,--响应自动范围内捡道具
	ReqAutoPickUpRangeItemsMessage = 3034,--请求自动范围内捡道具
---box_stall.xml
	ReqBoxStallServerMessage = 76001,--请求：盒子交易行服务器
	ResBoxStallRuleMessage = 76002,--响应：盒子交易行规则
	ResBoxStallInfoMessage = 76003,--响应：转发盒子交易行服务器的json信息
---box_trade.xml
	ReqBoxTradeServerMessage = 76001,--请求：盒子交易行服务器
	ResBoxTradeRuleMessage = 76002,--响应：盒子交易行规则
	ResBoxTradeInfoMessage = 76003,--响应：转发盒子交易行服务器的json信息
	ResBoxTradeLockRoleChangeMessage = 76004,--响应：盒子交易行锁定角色变化信息
	ReqBoxTradeUnlockRoleMessage = 76005,--请求：盒子交易行解锁角色
	ResBoxTradeItemsInfoMessage = 76006,--响应：交易行道具详细信息
	ReqBoxTradeItemsInfoMessage = 76007,--请求：交易行道具详细信息
---buffer.xml
	ResAddBufferMessage = 5001,--通知客户端添加一条buff
	ResRemoveBufferMessage = 5002,--通知客户端移除一条buff
	ResBufferOnceMoveMessage = 5003,--执行一次移动buff
	ResHaloBufferOnceMessage = 5004,--执行一次光环buff
	ResBufferOnceHurtMessage = 5005,--执行一次伤害
	ResFreeBuffMessage = 5006,--自由buff响应
---chat.xml
	ReqChatMessage = 15001,--请求聊天
	ResChatMessage = 15002,--聊天结果
	ResOfflineMsgMessage = 15003,--离线留言响应
	ResHorseRaceLampMessage = 15004,--跑马灯响应
	ResTextNoticeMessage = 15005,--文本通知响应
	ReqChatHistoryMessage = 15006,--请求聊天历史
	ResChatHistoryMessage = 15007,--聊天历史响应
	ResSendMsgByNpcMessage = 15008,--通过NPC发送广播信息
	ResSendCenterMsgMessage = 15009,--发送居中显示信息
	ResClearDelayGotoMessage = 15010,--清除所有倒计时消息
	ResGroupNoticeMessage = 15011,--发送自定义颜色消息
	ResTopChatBoardMsgMessage = 15012,--发送聊天框固顶信息
	ResSendMoveMessage = 15013,--发送屏幕滚动信息
	ResSendCustomMessage = 15014,--屏幕任意坐标发送公告信息
	ResSendMsgNewMessage = 15015,--主屏幕弹出公告
	ResSendDelayMessage = 15016,--显示倒计时信息提示
	ReqSendOnlineStateMessage = 15017,--发送私聊列表ID
	ResSendOnlineStateMessage = 15018,--发送私聊列表ID
	ReqFindRidByNameMessage = 15019,--请求：根据名字查找Rid
	ResFindIdByNameMessage = 15020,--响应：根据名字查找Rid
	ResGameAnnounceMessage = 15021,--游戏公告协议
	ReqRemovePrivateChatMessage = 15022,--请求：移除私聊玩家信息
	ResPrivateChatMessage = 15023,--响应：私聊玩家信息
---count.xml
	ReqCountInfoMessage = 64001,--请求计数
	ResCountInfoMessage = 64002,--响应计数
	ResNoticeCountInfoMessage = 64003,--响应：更新数量
---dup_angeltower.xml
	ResAngelTowerPanelMessage = 49001,--响应:天使之塔选择面板
	ReqEnterAngelTowerMessage = 49002,--请求:开启/重新挑战
	ResRemainMonsterCountMessage = 49003,--响应:天使之塔剩余怪物数量
	ReqResetAngelTowerMessage = 49004,--请求:重置天使之塔
	ReqSweepAngelTowerMessage = 49005,--请求:扫荡天使之塔
	ReqGoToTowerNextLevelMessage = 49006,--请求:前往下一层
	ResAngelTowerThisLevelOverMessage = 49007,--响应:天使之塔本层结束
---dup_bloody.xml
	ResUpdateBloodyTaskMessage = 47001,--更新血色城堡任务进度响应
	ResDupWeaponDropMessage = 47002,--通知客户端-副本道具掉落
	ReqPickUpWeaponMessage = 47003,--通知服务器-玩家捡起道具
	ResPickUpWeaponMessage = 47004,--通知客户端-玩家捡起道具
	ReqGiveNPCWeaponMessage = 47005,--通知客户端-器交还武器
	ResGiveNPCWeaponMessage = 47006,--通知客户端-器交还武器
	ResBloodyBudingMonsterIdMessage = 47007,--通知客户端-建筑怪物的ID
	ReqClearBurialTimeViewMessage = 47008,--通知服务器-清除冷却界面
	ResClearBurialTimeViewMessage = 47009,--通知客户端-清除冷却界面
	ReqClearBurialTimeMessage = 47010,--通知服务器-清除冷却时间
	ResBloodRateInfoMessage = 47011,--通知副本评级信息
	ReqSpoilsOfWarMessage = 47012,--通知服务器-请求战利品
	ResSpoilsOfWarMessageMessage = 47013,--通知客户端-战利品信息
---dup_bravetest.xml
	ResBraveTestPanelMessage = 56001,--响应:勇者挑战面板
	ReqRQuickHangUpPanelMessage = 56002,--请求:快速挂机弹窗
	ResRQuickHangUpPanelMessage = 56003,--响应:快速挂机弹窗
	ResBraveChallengeResultMessage = 56004,--响应:通知勇者试炼成功或者失败
	ResBraveTestTaskRecordMessage = 56005,--响应:通知勇者试炼任务进度刷新
	ReqSpecialRewardMessage = 56006,--请求:领取特殊奖励
	ResNewFloorMessage = 56007,--响应:解锁最新的层级
	ReqHangUpIncomeMessage = 56008,--请求：获取伙伴挂机信息
	ResHangUpIncomeMessage = 56009,--响应：伙伴挂机信息
	ReqFastHangUpMessage = 56010,--请求:快速挂机
	ReqBraveTestEnterMapMessage = 56011,--请求: 进入副本地图
	ResFastHangUpMessage = 56012,--请求:快速挂机
	ReqReceiveRewardHangUpMessage = 56013,--请求:领取挂机奖励
	ResReceiveRewardHangUpMessage = 56014,--请求:领取挂机奖励
	ReqGetBraveTestInfoMessage = 56015,--请求:勇者试炼面板数据
	ReqBraveTestOnHookMessage = 56016,--请求:挂机
	ResBraveTestOnHookMessage = 56017,--响应:挂机
	ResFastHangUpRewardMessage = 56018,--响应:快速挂机奖励道具
---dup_cantrubattle.xml
	ResCanTruPanelMessage = 50001,--响应:坎特鲁战役面板
	ReqEnterCantruBattleMessage = 50002,--请求:开启挑战
	ResReliveConsumeMessage = 50003,--响应:复活消费响应
	ReqReliveConsumeMessage = 50004,--请求:消费钻石复活
---dup_choiceroad.xml
	ResChoiceRoadPanelMessage = 59001,--响应:抉择之路面板
	ReqChallengeChoiceRoadMessage = 59002,--请求:挑战抉择之路
	ReqChoiceRoadBuyLeftTimesMessage = 59003,--请求:购买剩余挑战次数
	ReqChoiceRoadRankInfoMessage = 59004,--请求:排行榜数据
	ResChoiceRoadRankPanelMessage = 59005,--响应:抉择之路排行榜面板
	ReqChoiceRoadLevelInfoMessage = 59006,--请求:关卡详细信息
	ResChoiceRoadLevelInfoMessage = 59007,--响应:关卡详细信息
	ResChallengeChoiceRoadResultMessage = 59008,--响应:挑战结果
	ReqChoiceRoadOpenPlaneMessage = 59009,--请求:请求打开面板
	ResChoiceRoadBuyLeftTimesMessage = 59010,--响应:购买剩余次数
---dup_currencyboss.xml
	ReqEnterCurrencyBossMessage = 52001,--请求：进入通用boss副本
	ReqCurrencyBossInfoMessage = 52002,--请求：获得副本信息
	ResCurrencyBossInfoMessage = 52003,--响应：获得副本信息
	ReqCurrencyBossRankListMessage = 52004,--请求：获得副本排名信息
	ResCurrencyBossRankListMessage = 52005,--响应：获得副本排名信息
	ReqCurrencyBossReliveMessage = 52006,--请求：复活
	ResCurrencyBossRewardListMessage = 52007,--响应：结算奖励信息
	ResEnterCurrencyBossMessage = 52008,--响应：进入通用boss副本
	ReqCurrencyBossAddVipFrequencyMessage = 52009,--请求：增加VIP次数
	ReqCurrencyBossReliveRemindMessage = 52010,--请求：设置复活提醒
	ResCurrencyBossReliveRemindMessage = 52011,--响应：设置复活提醒
	ResCurrencyBossReliveNoticeMessage = 52012,--响应：boss复活倒计时通知
	ReqCurrencyBossMopUpMessage = 52013,--请求：扫荡
	ResGoldBossRankListMessage = 52014,--响应：获得黄金BOSS副本排名信息
	ResScoreChangeMessage = 52015,--响应：专属BOSS评变化通知
	ResCurrencyBossPickUpAllMessage = 52016,--响应：专属BOSS拾取完毕通知
	ResCurrencyBossDieMessage = 52017,--响应：通用BOSS死亡响应
	ReqFieldBossAllInfoMessage = 52018,--请求：野外BOSS请求
	ResFieldBossAllInfoMessage = 52019,--响应：野外BOSS信息响应
---dup_demonrefinement.xml
	ReqMLZDPanelMessage = 72001,--请求: 查看魔炼之地面板
	ResMLZDInfoMessage = 72002,--响应: 魔炼之地面板信息
	ReqEnterMLZDMessage = 72003,--请求: 进入魔炼之地副本
	ResMLZDPreparePanelMessage = 72004,--响应: 准备面板
	ReqPrepareMLZDMessage = 72005,--请求: 准备/拒绝进入魔炼之地
	ResMLZDDupInfoMessage = 72006,--响应: 魔炼之地副本信息
	ResMLZDDupFinishPanelMessage = 72007,--响应: 魔炼之地结束面板
	ReqReceiveMLZDAwardMessage = 72008,--请求: 领取奖励
	ResMLZDExitCountDownMessage = 72009,--响应: 魔炼之地结束退出倒计时
---dup_devilsquare.xml
	ReqStartFightPhaseNowMessage = 68001,--请求:立即开启战斗阶段
---dup_gardboss.xml
	ReqEnterGardBossMessage = 58001,--请求：进入战盟BOSS副本
	ResEnterGardBossMessage = 58002,--响应：进入战盟BOSS副本
	ReqGardBossInfoMessage = 58003,--请求：战盟BOSS副本信息
	ResGardBossInfoMessage = 58004,--响应：战盟BOSS副本信息
	ResGardBossRewardInfoMessage = 58005,--响应：战盟BOSS副本结算奖励
	ReqGardBossReliveMessage = 58006,--请求：复活
	ResGardBossPlayerDieMessage = 58007,--响应：玩家在副本中死亡
---dup_gateworld.xml
	ReqFloorEntryWayMessage = 54001,--请求:点击层数获取入口数量
	ResFloorEntryWayMessage = 54002,--响应:活动面板层数详情展示
	ReqFindGateWorldNPCMessage = 54003,--请求:请求一个可以挑战的NPC
	ResFindGateWorldNPCMessage = 54004,--响应:NPC位置信息
	ReqTryEnterGateWorldMessage = 54005,--请求:点击发起挑战
	ResChallengeResultMessage = 54006,--响应:挑战结果
	ResFloorPanelInfoMessage = 54007,--响应:活动面板信息
	ResSendAllNpcPointMessage = 54008,--响应:活动开启后发送所有NPC位置
	ResGateWorldTaskRecordMessage = 54009,--响应:异界之门任务进度
	ReqGateWorldBuyCountMessage = 54010,--请求:异界之门购买次数
	ResGateWorldBuyCountMessage = 54011,--响应:异界之门购买次数
---dup_guildSiege.xml
	ReqGuildSiegeInfoMessage = 60001,--请求：查看攻城战信息详情
	ResGuildSiegeInfoMessage = 60002,--响应：攻城战面板详情
	ReqGuildSiegeStatisticalMessage = 60003,--请求：查看上周攻城战统计信息
	ResGuildSiegeStatisticalMessage = 60004,--响应：上周攻城战统计信息
	ReqAgainstTableMessage = 60005,--请求：查看攻城战对阵表
	ResGuildSiegeAgainstTableMessage = 60006,--响应：攻城战对阵表
	ReqGoToGuildSiegeMessage = 60007,--请求：前往攻城战战场
	ReqRepAirStatueMessage = 60008,--请求：修复雕像
	ResRepAirStatueMessage = 60009,--响应：修复雕像
	ResWarGodListMessage = 60010,--响应：战神榜
	ReqWarGodPraiseMessage = 60011,--请求：战神榜点赞
	ResWarGodPraiseMessage = 60012,--响应：战神榜点赞
	ReqUseGoHomeSkillMessage = 60014,--请求：使用回城术
	ResUseGoHomeSkillMessage = 60015,--响应：使用回城术结果
	ReqBecomeFightCarMessage = 60016,--请求：变身战车
	ReqReturnPersonMessage = 60017,--请求：恢复人形
	ReqGuildSiegeReliveMessage = 60018,--请求：攻城战原地复活
	ReqBuildingConditionMessage = 60019,--请求：建筑状态
	ResBuildingConditionMessage = 60020,--响应：建筑状态
	ReqGuildSiegeDataMessage = 60021,--请求：战场即时数据
	ResGuildSiegeDataMessage = 60022,--响应：战场即时数据
	ResThroneHarmDataMessage = 60023,--响应：王座被攻击时响应数据
	ReqGuildSiegeRecruitMessage = 60024,--请求：攻城战召唤盟友
	ResUpdateMonsterStateMessage = 60025,--响应：更新怪物血量
	ResGuildSiegeCampSwapMessage = 60026,--响应：更新怪物血量
	ReqSiegeStatisticsMessage = 60027,--请求：统计界面
	ResSiegeStatisticsMessage = 60028,--响应：统计界面
	ResTradeLineEndTimeMessage = 60029,--响应：交易行结束时间
	ResguardTimeMessage = 60030,--响应：守护时间
	ResGuildSiegeAnnounceMessage = 60031,--响应：战盟开启时间以及生成对阵表状态
---dup_help_fight.xml
	ReqHelpFightListMessage = 67001,--请求:助战列表
	ResHelpFightListMessage = 67002,--响应:助战列表
	ReqSeekHelpMessage = 67003,--请求:求助
	ReqGoToHelpMessage = 67004,--请求:前往助战
	ResHelpScoreListMessage = 67005,--响应:协助排行榜
	ResThankLetterMessage = 67006,--响应:感谢信
	ReqSendThankLetterMessage = 67007,--请求:发送感谢信
	ResSendThankLetterMessage = 67008,--响应:发送感谢信
	ReqGetLetterRewardMessage = 67009,--请求:领取感谢信
	ReqQuitHelpMessage = 67010,--请求:退出协助
	ResGotoHelpMessage = 67011,--响应:进入地图
	ResCloseHelpMessage = 67012,--响应:关闭协助
	ReqUseLetterMessage = 67013,--请求:使用感谢信
	ReqDelHelpInfoMessage = 67014,--请求:删除求助信息
---dup_imperialfortress.xml
	ResImperialFortressMessage = 51001,--响应:帝国要塞面板
	ReqEnterImperialFortressMessage = 51002,--请求:开启帝国要塞挑战
---dup_kalimatemple.xml
	ResKaLiMaTemplePanelMessage = 69001,--响应:卡利玛神庙面板
	ReqChallengeKaLiMaTempleMessage = 69002,--请求:挑战卡利玛神庙副本
	ResKaLiMaTempleTaskChangeMessage = 69003,--响应:副本任务进度
	ResKaLiMaTempleChallengeResultMessage = 69004,--响应:卡利玛神庙挑战结果
	ReqSweepingUpKaLiMaTempleMessage = 69005,--请求:扫荡卡利玛神庙
---dup_monster_attack.xml
	ReqMonsterAttViewMessage = 66002,--请求:打开怪物袭击面板
	ResMonsterAttViewMessage = 66003,--响应:打开怪物袭击面板
	ReqGotoMonsterAttMessage = 66004,--请求:前往怪物袭击地图
---dup_redfortress.xml
	ResUpdateScoreMessage = 48001,--响应:刷新积分面板
	ResEndDupPanelMessage = 48002,--响应:副本结束面板
	ResDropOutMapMessage = 48003,--响应:玩家掉出地图
	ResMapZoomOutMessage = 48005,--响应:地图缩小
---dup_redfortress_two.xml
	ReqRedFortressTwoRankInfoMessage = 63001,--请求：赤色要塞2排行信息
	ResRedFortressTwoRankInfoMessage = 63002,--响应：赤色要塞2排行信息
	ResRedFortressTwoWarPhaseMessage = 63003,--响应：赤色要塞2战争阶段信息
	ResRedFortressTwoKillInfoMessage = 63004,--响应：赤色要塞2击杀信息
	ResRedFortressTwoSelfScoreInfoMessage = 63005,--响应：赤色要塞2自己积分信息
	ResRedFortressTwoQuitInfoMessage = 63006,--响应：赤色要塞2退出信息
	ResRedFortressTwoAwardInfoMessage = 63007,--响应：赤色要塞2奖励信息
---dup_siege.xml
	ReqSiegePanelMessage = 44001,--请求:攻城战面板
	ResSiegePanelMessage = 44002,--响应:攻城战面板
	ReqToTheSiegeMessage = 44003,--请求:前往攻城
	ReqRegistrationInfoMessage = 44004,--请求:攻城战报名详情
	ResRegistrationInfoMessage = 44005,--响应:攻城战报名详情
	ReqRegisterSiegeMessage = 44006,--请求:报名攻城战
	ReqDeployedMercenaryListMessage = 44007,--请求:查看已部署的佣兵
	ResMercenaryListMessage = 44008,--响应:已部署的佣兵列表
	ReqDeployMercenaryMessage = 44009,--请求:部署佣兵
	ResSiegeScoreRankUpdateMessage = 44010,--响应:积分排行
	ResOccupyOrganTimeMessage = 44011,--响应:机关占领开始结束时间
	ResBreakProgressMessage = 44012,--响应:打断进度条
	ReqOccupySuccessMessage = 44013,--请求：占领机关成功请求
	ReqOccupyOrganPanelMessage = 44014,--请求：占领机关战盟面板
	ResOccupyOrganPanelMessage = 44015,--响应：占领机关战盟面板
	ReqOccupySeatMessage = 44016,--请求：占领椅子
---dup_wolfsoul.xml
	ResPlayWolfSoulCartoonMessage = 46001,--响应:播放狼魂要塞过场动画
	ResLoginWolfSoulSuccessMessage = 46002,--响应:成功登录狼魂要塞
	ResWolfSoulGlobalInfoUpdateMessage = 46003,--响应:狼魂要塞全局信息更新
	ResWolfSoulKillPointUpdateMessage = 46004,--响应:狼魂要塞个人击杀点数更新
	ResWolfSoulRewardPanelMessage = 46005,--响应:狼魂要塞结算奖励面板
	ReqBindDefensePlatformMessage = 46006,--请求:绑定神狼护台
	ResBoundStateMessage = 46007,--响应:自身绑定状态
	ReqWolfSoulGlobalInfoMessage = 46008,--请求:狼魂要塞全局信息
	ReqWolfSoulReliveMessage = 46009,--请求:狼魂要塞复活
---dup_worldboss.xml
	ReqWorldBossInfoMessage = 61001,--请求：世界BOSS副本信息
	ResWorldBossInfoMessage = 61002,--响应：世界BOSS副本信息
	ResWorldBossRewardInfoMessage = 61003,--响应：世界BOSS副本结算奖励
	ResWorldBossPhaseInfoMessage = 61004,--响应：世界BOSS副本阶段信息
	ResWorldBossBuffInfoMessage = 61005,--响应：世界BOSSbuff信息
	ResWorldBossHpInfoMessage = 61006,--响应：世界boss血量信息
	ResWorldBossLastRankMessage = 61007,--响应：世界boss血量信息
	ReqWorldBossLastRankMessage = 61008,--请求：世界boss血量信息
	ReqWorldBossOpenBossHpMessage = 61009,--请求打开世界boss血量界面
---efficiency.xml
	ReqReceiveEfficiencyRewardMessage = 57001,--效率系统领取等级奖励 请求
	ResEfficiencyRewardInfoMessage = 57002,--效率系统领取等级奖励具体信息 响应
	ResEfficiencyMagnificationMessage = 57003,--效率系统经验倍率具体信息 响应
	ReqEfficiencyBuyMessage = 57004,--效率系统奇迹币增益与爆率提升购买 请求
	ResEfficiencyBuyInfoMessage = 57005,--效率系统奇迹币增益与爆率提升购买信息 响应
	ResExperiencePotionMessage = 57006,--效率系统经验药水过期时间 响应
	ResEfficiencyBuyRateMessage = 57007,--效率系统已经购买的爆率提升 响应
---equip.xml
	ResAllEquipMessage = 13001,--所有装备信息
	ReqPutOnTheEquipMessage = 13003,--穿装
	ReqTakeOffEquipMessage = 13004,--脱装
	ResPutOnTheEquipMessage = 13005,--穿装
	ResTakeOffEquipMessage = 13006,--脱装
	ReqEquipStrengthenMessage = 13007,--装备强化
	ResEquipStrengthenMessage = 13008,--装备强化
	ResAllEquipGemMessage = 13009,--所有装备宝石信息
	ReqPutOnGemMessage = 13010,--装宝石
	ResPutOnGemMessage = 13011,--装宝石
	ReqTakeOffGemMessage = 13012,--脱掉宝石
	ResTakeOffGemMessage = 13013,--脱掉宝石
	ResAllEquipGemUnLockMessage = 13014,--所有宝石解锁信息
	ResMountStoreChangeMessage = 13017,--坐骑仓库发生变化
	ReqPutOnMountMessage = 13018,--装备坐骑
	ReqTakeOffMountMessage = 13019,--脱掉坐骑
	ResAllMountInfoMessage = 13020,--所有的激活的坐骑信息
	ReqRideMountMessage = 13021,--骑乘坐骑请求
	ResRideMountMessage = 13022,--骑乘坐骑响应
	ReqCancelMountMessage = 13023,--取消骑乘请求
	ResCancelMountMessage = 13024,--取消骑乘响应
	ReqHideMountMessage = 13025,--隐藏坐骑请求
	ResHideMountMessage = 13026,--隐藏坐骑响应
	ReqExposeMountMessage = 13027,--暴露坐骑请求
	ResExposeMountMessage = 13028,--暴露坐骑响应
	ReqPutOnPetMessage = 13029,--装备召唤兽
	ResPutOnPetMessage = 13030,--装备召唤兽响应
	ReqTakeOffPetMessage = 13031,--脱掉召唤兽
	ResTakeOffPetMessage = 13032,--脱掉召唤兽响应
	ReqFightPetMessage = 13033,--召唤兽出战请求
	ResFightPetMessage = 13034,--召唤兽出战响应
	ReqCancelFightPetMessage = 13035,--取消召唤兽出战请求
	ResCancelFightPetMessage = 13036,--取消召唤兽出战请求响应
	ReqEquipAppendMessage = 13037,--装备追加请求
	ResEquipAppendMessage = 13038,--装备追加响应
	ReqOperatePetMessage = 13039,--对召唤兽进行操作
	ResOperatePetMessage = 13040,--对召唤兽进行操作响应
	ReqEquipTransferMessage = 13041,--装备转移
	ResEquipTransferMessage = 13042,--装备转移响应
	ReqEquipOverlayMessage = 13043,--装备叠加
	ResEquipOverlayMessage = 13044,--装备叠加响应
	ReqEquipSynthesis2Message = 13045,--装备合成2代请求
	ResEquipSynthesis2Message = 13046,--装备合成2代响应
	ReqEquipStrengthen2Message = 13047,--装备强化2代请求
	ResEquipStrengthen2Message = 13048,--装备强化2代响应
	ReqEquipAppend2Message = 13049,--装备追加2代请求
	ResEquipAppend2Message = 13050,--装备追加2代响应
	ReqEquipStrengthenExtraAttMessage = 13057,--装备额外属性强化请求
	ResEquipStrengthenExtraAttMessage = 13058,--装备额外属性强化响应
	ReqEquipRefineQualityExtraAttMessage = 13059,--装备额外属性品质系数洗练请求
	ResEquipRefineQualityExtraAttMessage = 13060,--装备额外属性品质系数洗练响应
	ReqEquipTransferExtraAttMessage = 13061,--装备额外属性转移请求
	ResEquipTransferExtraAttMessage = 13062,--装备额外属性转移响应
	ReqEquipMasterInfoMessage = 13063,--装备大师信息请求
	ResEquipMasterInfoMessage = 13064,--装备大师信息响应
	ReqEquipMasterActivateMessage = 13065,--装备大师激活等级请求
	ResEquipMasterActivateMessage = 13066,--装备大师信息响应
	ResEquipMasterChangeMessage = 13067,--装备大师信息响应
	ReqEquipPurchaseListMessage = 13068,--装备额外属性购买列表请求
	ResEquipPurchaseListMessage = 13069,--装备额外属性购买列表响应
	ResEquipExtraAttPurchaseErrorMessage = 13070,--装备额外属性购买错误响应
	ReqGuardProgressMessage = 13071,--请求：守护进阶
	ReqGuardAwakeningMessage = 13072,--请求：守护觉醒
	ResGuardHeightSucMessage = 13073,--响应：守护进阶觉醒是否成功
	ReqBatchPutOnGemMessage = 13074,--一键批量装宝石请求
	ResBatchPutOnGemMessage = 13075,--一键批量装宝石响应
	ReqGemStrengthMessage = 13076,--宝石强化请求
	ResGemStrengthMessage = 13077,--宝石强化响应
	ReqStrengthenManualActivateMessage = 13078,--请求：激活强化属性
	ReqAppendManualActivateMessage = 13079,--请求：激活追加属性
	ResStrengthenManualActivateMessage = 13080,--响应：激活强化属性
	ResAppendManualActivateMessage = 13081,--响应：激活追加属性
	ResUpdateMasterMessage = 13082,--前端用来及时更新大师页面
	ResTransferCareerDeleteSkillMessage = 13083,--转职后前端用来及时删除之前的技能效果
	ReqActiveFashionMessage = 13086,--请求：激活时装
	ResFashionChangeMessage = 13087,--响应：时装变化信息
	ReqStrengthFashionMessage = 13088,--请求：强化
	ResStrengthFashionMessage = 13089,--响应：强化
	ResActiveFashionMessage = 13090,--请求：激活时装
	ReqTransferAttMessage = 13091,--请求：属性转移
	ResTransferAttMessage = 13092,--响应：属性转移
	ReqLuckInlayMessage = 13093,--请求：幸运镶嵌
	ResLuckInlayMessage = 13094,--响应：幸运镶嵌
	ResEquipBarAttrMessage = 13095,--响应：装备栏属性变化
	ReqEquipBarAttrMessage = 13096,--请求：装备栏属性变化
	ReqMountRecoverMessage = 13097,--请求：坐骑分解
	ResMountRecoverMessage = 13098,--响应：坐骑分解
	ReqMountUpStarLvMessage = 13099,--请求：坐骑升星
	ResMountUpStarLvMessage = 13100,--响应：坐骑升星
	ReqEquipBrightStrengthenMessage = 13101,--请求：装备璀璨强化
	ResEquipBrightStrengthenMessage = 13102,--响应：装备璀璨强化
	ReqEquipBrightAppendMessage = 13103,--请求：装备璀璨追加
	ResEquipBrightAppendMessage = 13104,--响应：装备璀璨追加
	ReqEquipIncreaseMessage = 13105,--请求：增幅
	ReqEquipInheritanceMessage = 13106,--请求：传承
	ReqEquipFusionMessage = 13107,--请求：熔合
	ResEquipFusionMessage = 13108,--响应：熔合
	ReqEquipFusionOkMessage = 13109,--请求：确认熔合
	ResEquipFusionOkMessage = 13110,--响应：确认熔合
	ResEquipIncreaseOkMessage = 13111,--响应：确认增幅
	ResEquipInheritanceOkMessage = 13112,--响应：确认传承
	ResEquipChangeMessage = 13113,--已穿戴装备发生变化
	ReqUpEquipGodLvMessage = 13114,--装备神化
	ResUpEquipGodLvMessage = 13115,--装备神化
	ReqMountStrengthMessage = 13116,--请求：坐骑强化升级
	ResMountStrengthMessage = 13117,--响应：坐骑强化升级
	ReqPutOnTheMountEquipMessage = 13118,--请求：给坐骑一键穿装备
	ResPutOnTheMountEquipMessage = 13119,--响应：给坐骑一键穿装备
	ReqTakeOffTheMountEquipMessage = 13120,--请求：一键拆卸坐骑的装备
	ResTakeOffTheMountEquipMessage = 13121,--响应：一键拆卸坐骑的装备
	ReqTakeOffTheMountEquipOneMessage = 13122,--请求：脱掉坐骑身上的一个装备
	ResTakeOffTheMountEquipOneMessage = 13123,--响应：脱掉坐骑身上的一个装备
	ReqPutOnTheMountEquipOneMessage = 13124,--请求：给坐骑穿一件装备
	ResPutOnTheMountEquipOneMessage = 13125,--响应：给坐骑穿一件装备
	ResMountAttributeMessage = 13126,--响应：发送全部坐骑属性
	ResRoleRuneMessage = 13127,--响应：发送全部的角色符文信息
	ReqUnLockRunePlateMessage = 13128,--请求：解锁符文盘，其实也就是给符文盘升星
	ReqPourSoulMessage = 13129,--请求：给符文盘的孔位注灵，其实也就是给孔位升级
	ReqIdentifyRuneMessage = 13130,--请求：鉴定符文
	ReqSuccinctMessage = 13131,--请求：洗练符文
	ReqGiveUpSuccinctMessage = 13132,--请求：放弃洗练结果
	ReqSaveSuccinctMessage = 13133,--请求：保存洗练结果
	ReqPutOnRuneMessage = 13134,--请求：往符文盘里面放符文
	ReqTakeOffRuneMessage = 13135,--请求：从符文盘里面脱掉符文
	ReqAddRunePlateMessage = 13136,--请求：增加一个符文盘方案
	ResRuneAttrMessage = 13137,--响应：符文全部属性
	ResSaveRuneSuccinctMessage = 13138,--响应：保存符文洗练结果
	ResSuccinctMessage = 13139,--响应：洗练符文
	ReqSwitchRunePlateMessage = 13140,--请求：切换符文盘
	ReqEntryPotentialActiveMessage = 13141,--请求：词条潜能激活
	ResEntryPotentialActiveMessage = 13142,--响应：词条潜能激活
	ReqBrightSuccinctMessage = 13143,--请求：词条潜能璀璨洗练
	ResBrightSuccinctMessage = 13144,--响应：词条潜能璀璨洗练
	ReqEntryPotentialSuccinctMessage = 13145,--请求：词条潜能洗练
	ResEntryPotentialSuccinctMessage = 13146,--响应：词条潜能洗练
	ReqEntryPotentialGiveUpSuccinctMessage = 13147,--请求：放弃词条潜能洗练结果
	ReqEntryPotentialSaveSuccinctMessage = 13148,--请求：保存词条潜能洗练结果
	ResEntryPotentialSaveSuccinctMessage = 13149,--响应：保存词条潜能洗练结果
	ResGradeAttrChangeMessage = 13150,--响应：基础属性变化通知
	ResLuaExtDataChangeMessage = 13151,--响应：装备扩展数据变化通知
	ResCanTransferAttrMessage = 13152,--响应：装备穿戴后能否转移属性通知
---fight.xml
	ResObjectDieMessage = 6001,--对象死亡
	ResFightResultMessage = 6004,--技能释放结果
	ReqFightMessage = 6005,--请求释放技能
	ReqStartAutoPlayGameMessage = 6006,--客户端触发开始挂机
	ReqEndAutoPlayGameMessage = 6007,--客户端触发停止挂机
	ResStartAutoPlayGameMessage = 6008,--服务器触发开始挂机
	ResEndAutoPlayGameMessage = 6009,--服务器触发停止挂机
	ReqCaromMessage = 6010,--请求释放连招技能
	ResBeSkillReadyMessage = 6011,--响应：被动技能已准备
	ResTimesCaromStartMessage = 6012,--响应: 次数连击开始
	ReqUpdateComboSkillMessage = 6013,--请求: 更新连击技能
	ReqComboValueMessage = 6014,--请求: 获取连击值
	ResComboSkillInfoMessage = 6015,--响应: 玩家连击技能
	ResFightLogMessage = 6016,--技能伤害计算过程日志
---friend.xml
	ReqOpenFriendPanelMessage = 10001,--请求打开好友面板
	ResFriendInfoMessage = 10002,--返回好友信息
	ReqSearchFriendMessage = 10003,--请求好友查询
	ResSearchFriendMessage = 10004,--好友查询响应
	ReqRecommendFriendsMessage = 10005,--请求系统推荐好友
	ResRecommendFriendsMessage = 10006,--系统推荐好友响应
	ReqAddFriendMessage = 10007,--请求添加好友
	ResFriendChangeMessage = 10008,--返回好友变化信息
	ReqDeleteFriendMessage = 10009,--请求删除好友
	ReqCheckApplyMessage = 10010,--审批申请
	ReqFriendLogsMessage = 10011,--请求好友日志
	ResFriendLogsMessage = 10012,--返回好友日志
	ReqClearMsgUnreadStateMessage = 10013,--请求:清理好友消息未读状态
---gm.xml
	ReqGMMessage = 43003,--请求GM执行
	ResExecGMMessage = 43004,--GM执行返回
	ResServerLogMessage = 43006,--内容输入到GM面板中
	ResCreateRobotOrMonsterMessage = 43007,--GM生成怪物或机器人返回id
---gmequip.xml
	ResAddHoleResMessage = 45001,--打宝石孔响应
	ResDelHoleMessage = 45002,--删除宝石孔响应
	ResGmPutOnGemMessage = 45003,--镶嵌宝石响应
	ResGmTakeOffGemMessage = 45004,--脱掉宝石响应
	ResChangeStrengthMessage = 45005,--改变强化标识响应
	ResChangeAppendMessage = 45006,--改变追加标识响应
	ResChangeEquipEntryAttrMessage = 45007,--改变卓越属性响应
	ResChangeStrengthOrAppendAttrMessage = 45008,--改变强化或者追加属性响应
	ResChangeCustomizeAttrMessage = 45009,--改变自定义属性响应
	ResChangeEquipSwimFlagMessage = 45010,--改变装备游泳标识
	ResChangeEquipRunFlagMessage = 45011,--改变装备奔跑标识
	ResChangeEquipFlyFlagMessage = 45012,--改变装备飞天标识
	ResChangeEquipShapeMessage = 45013,--改变装备内观模型
	ResChangeEquipEffectIdMessage = 45014,--改变装备内观特效Id
	ResChangeEquipWearLimitMessage = 45015,--改变装备穿戴限制
---gmscript.xml
	ResLoadGmScriptMessage = 900001,--装载脚本
	ResInvalidGmScriptMessage = 900002,--脚本失效
	ResBindGmScriptMessage = 900003,--脚本绑定到对象上
	ResUnBindGmScriptMessage = 900004,--从对象上解绑脚本
	ResClientGMCmdMessage = 900005,--服务器发送给客户端的脚本命令
	ResClientInitGMCmdMessage = 900006,--初始化时发送给客户端的脚本命令
---kml.xml
	ReqKmlMessage = 800001,--kml请求
	ResKmlMessage = 800002,--kml响应
---lua.xml
	ReqLuaMessage = 74001,--lua请求
	ResLuaMessage = 74002,--lua响应
---mail.xml
	ReqGetMailListMessage = 9001,--获取邮件列表请求
	ResMailListMessage = 9002,--邮件列表响应
	ResNewMailMessage = 9003,--新邮件响应
	ReqReadMailMessage = 9004,--标记为已读请求
	ReqGetMailItemMessage = 9005,--提取物品请求
	ResGetMailItemMessage = 9006,--提取物品响应
	ReqDeleteMailMessage = 9007,--删除邮件请求
	ResReadMailMessage = 9008,--已读响应
	ResRoleMailChangeMessage = 9009,--邮件改变统一回包
---mall.xml
	ReqMallGoodsInfoMessage = 18001,--请求商城商品信息
	ResMallGoodsInfoMessage = 18002,--商城商品信息列表响应
	ReqBuyMallGoodsMessage = 18003,--请求购买商品
	ResBuyMallGoodsMessage = 18004,--请求购买商品响应
	ResFlushMallGoodsMessage = 18005,--刷新商城商品响应
	ReqAutoBuyPotionMessage = 18006,--自动买药请求
	ReqBuyPotionMessage = 18007,--随身商店买药请求
---map.xml
	ResChangePosMessage = 2001,--坐标改变
	ResPlayerEnterMapMessage = 2002,--通知进入地图
	ResPlayerChangeMapMessage = 2003,--通知玩家切换地图
	ResReliveMessage = 2004,--通知复活
	ResSwitchFightModelMessage = 2005,--通知切换攻击模式
	ResTryEnterMapMessage = 2006,--通知尝试
	ReqPlayerChangeMapMessage = 2007,--请求切换地图
	ResWalkMessage = 2008,--返回步行
	ResChangeDirMessage = 2011,--返回转向
	ReqWalkMessage = 2013,--步行
	ReqLoginMapMessage = 2016,--请求进图地图
	ResPlayerEnterViewMessage = 2017,--玩家进入视野
	ResMonsterEnterViewMessage = 2018,--怪物进入视野
	ResNpcEnterViewMessage = 2019,--npc进入视野
	ResUpdateViewMessage = 2020,--更新玩家视野消息
	ResMapObjectExitViewMessage = 2021,--离开视野
	ReqPlayerReliveMessage = 2022,--请求复活
	ReqSwitchFightModelMessage = 2024,--请求切换攻击模式
	ReqDeliverByConfigMessage = 2025,--请求切换攻击模式
	ResHpMpChangeMessage = 2026,--血量和魔法变化
	ReqExitDuplicateMessage = 2027,--请求退出副本
	ResItemEnterViewMessage = 2028,--GroundItem进入视野
	ReqPickUpMapItemMessage = 2029,--拾取道具
	ResBuffEnterViewMessage = 2030,--GroundBuff进入视野
	ResUpdateEquipMessage = 2031,--装备变化
	ResNoticeViewTypeInfoMessage = 2032,--通知ViewTypeInfo变化
	ResStallEnterViewMessage = 2034,--GroundStall进入视野
	ReqTransferPointMessage = 2035,--定点传送
	ReqNpcTransferMessage = 2036,--NPC传送
	ResFightAttrInfoMessage = 2037,--属性变化通知
	ReqStandbyMessage = 2038,--待机方式
	ResStandbyMessage = 2039,--待机方式广播
	ReqJumpMessage = 2040,--起跳
	ResJumpMessage = 2041,--起跳
	ReqRandomTransportMessage = 2042,--随机传送
	ReqCustomizeTransportMessage = 2043,--自定义坐标传送
	ResMapMonsterStatusMessage = 2044,--发送地图中怪物状态
	ResMonsterStatusChangeMessage = 2045,--单个怪物状态通知
	ReqMapMonsterStatusMessage = 2046,--请求地图中怪物状态
	ReqMapObjInfoMessage = 2049,--请求：查看地图对象
	ResMapObjInfoMessage = 2050,--响应：地图对象信息
	ResBossOwnerMessage = 2051,--响应：怪物对象仇恨信息
	ResAutoPathfindingMessage = 2052,--自动寻路
	ResKillMobAtPointMessage = 2053,--自动寻路并杀怪
	ResStopKillMobAtPointMessage = 2054,--停止自动寻路和杀怪
	ReqAutoPathfindingMessage = 2055,--开始自动寻路
	ReqStopPathfindingMessage = 2056,--停止自动寻路
	ReqFinishedPathfindingMessage = 2057,--自动寻路到达终点
	ResShieldChangeMessage = 2058,--护盾值变化
	ResAgstoChangeMessage = 2059,--技能值变化
	ReqTransferToNpcMessage = 2060,--传送到NPC附近请求
	ResTransferToNpcMessage = 2061,--传送到NPC附近响应
	ResGMTransferMessage = 2062,--通知客户端GM脚本发起传送
	ReqGMTransferMessage = 2063,--客户端发起GM脚本传送
	ResScreenVibrationMessage = 2064,--通知客户端屏幕震动响应
	ResNpcRemoveViewMessage = 2065,--npc移除视野
	ResTransferResultMessage = 2066,--传送结果返回
	ReqThisMapLineInfoMessage = 2067,--获得当前地图分线信息
	ResThisMapLineInfoMessage = 2068,--返回获得当前地图分线信息
	ResEquipAppearMessage = 2069,--装备外观变化
	ResMonsterBtTransformMessage = 2070,--怪物变换模型
	ResMonsterBtAudioMessage = 2071,--播放声音
	ResMonsterBtAnimationMessage = 2072,--播放动画
	ReqRecordTheHangUpPointMessage = 2073,--请求记录挂机点
	ReqLastHangUpPointMessage = 2074,--请求获取上次记录挂机点
	ResLastHangUpPointMessage = 2075,--上次记录挂机点响应
	ResDieInfoMessage = 2076,--玩家死亡信息
	ReqCanTransferMessage = 2077,--传送校验
	ResCanTransferFlagMessage = 2078,--传送校验结果
	ReqGuardPickItemMessage = 2079,--守护捡道具请求
	ResGuardPickItemMessage = 2080,--守护捡道具响应
	ReqGuardPickUpItemMessage = 2081,--守护获取道具请求
	ResMonsterDieInfoMessage = 2082,--怪物死亡信息
	ResRobberyModeSkilledMessage = 2083,--对打的双方只有有一方为掠夺模式，被击杀者被击杀之后的弹出消息
---mu_box.xml
	ReqReceivePrivilegeGiftMessage = 75001,--请求：领取每日礼包
	ResMuBoxInfoMessage = 75002,--响应：奇迹盒子信息
	ReqUpdatePrivilegeTitleMessage = 75003,--请求：更新特权称号
	ReqBoxCdKeyMessage = 75004,--请求：兑换礼包码
	ResMuBoxPopupConfigMessage = 75005,--响应：奇迹盒子推广弹窗配置
---npcshop.xml
	ReqNpcShopGoodsInfoMessage = 27001,--请求npc商店商品信息
	ResNpcShopGoodsInfoMessage = 27002,--npc商店商品信息列表响应
	ReqBuyShopGoodsMessage = 27003,--请求购买商店商品
	ResBuyShopGoodsMessage = 27004,--请求购买商店商品响应
	ReqBagItemTradeMessage = 27005,--背包物品出售请求
	ResBagItemTradeMessage = 27006,--背包物品出售响应
	ResFlushNpcShopGoodsMessage = 27007,--刷新npc商店商品响应
	ReqRefreshNpcShopGoodsMessage = 27008,--刷新npc商店商品请求
	ResRefreshNpcShopGoodsMessage = 27009,--刷新npc商店商品响应
	ResMarketInfoMessage = 27010,--宠物集市信息列表响应
---onhook.xml
	ReqOffLineBenefitMessage = 22001,--获取离线挂机收益请求
	ResOffLineBenefitMessage = 22002,--离线挂机收益响应
	ReqReceiveOffLineExpMessage = 22003,--领取离线挂机经验请求
	ResMultiOnhookInfoMessage = 22004,--响应：多倍挂机信息
	ReqMultiOnhookAddTimeMessage = 22005,--请求：多倍挂机补充时间
	ReqMultiOnhookStartMessage = 22006,--请求：开始多倍挂机
	ReqMultiOnhookStopMessage = 22007,--请求：停止（暂停）多倍挂机
	ReqMultiOnhookInfoMessage = 22008,--请求：多倍挂机信息
	ReqOfflineOnHookMessage = 22009,--请求：离线挂机信息
	ResOfflineOnHookMessage = 22010,--响应：离线挂机信息
	ReqOfflineOnHookGetExpMessage = 22011,--请求：领取离线挂机经验
---partner.xml
	ResAllPartnerInfoMessage = 53001,--响应：登录时发送所有伙伴信息
	ReqUnLockPartnerSlotMessage = 53002,--请求：解锁阵容槽位
	ResUnlockPartnerSlotSuccessMessage = 53003,--响应：解锁阵容槽位成功响应
	ReqLoadOrUnloadPartnerMessage = 53004,--请求：伙伴上阵/下阵
	ReqUpgradeArrayMasterLvMessage = 53005,--请求：升级技能大师等级
	ResArrayMasterUpdateMessage = 53006,--响应：阵容大师信息更新
	ReqLockOrUnlockPartnerMessage = 53007,--请求：上锁/解锁伙伴
	ReqResetPartnerMessage = 53008,--请求：重置伙伴
	ReqPartnerLevelUpMessage = 53009,--请求：升级伙伴
	ReqEvolvePartnerMessage = 53010,--请求：进化(突破、进阶)伙伴
	ReqUpPartnerStarLvMessage = 53011,--请求：伙伴升星
	ReqWashingPartnerMessage = 53012,--请求：伙伴洗髓
	ReqConfirmPartnerWashingResultMessage = 53013,--请求：确认伙伴洗髓结果(确定/取消)
	ReqResetReturnDetailsMessage = 53014,--请求：查看重置返还详情
	ResResetReturnDetailsMessage = 53015,--响应：重置返还详情
	ResPartnerChangeMessage = 53016,--响应：伙伴信息变化
	ResPartnerStarLvUpMessage = 53017,--响应：伙伴升星成功
	ReqFastPartnerUpStarLvMessage = 53018,--请求：伙伴快捷升星
	ResFastPartnerUpStarLvMessage = 53019,--响应：伙伴快捷升星结果
	ReqPartnerTransformMessage = 53020,--请求：伙伴转化
	ResPartnerTransformMessage = 53021,--响应：伙伴转化
	ReqPartnerRebornMessage = 53022,--请求：伙伴重生
	ResPartnerRebornMessage = 53023,--响应：伙伴重生结果
	ReqConfirmPartnerRebornMessage = 53024,--请求：确认伙伴重生结果
	ResConfirmPartnerRebornMessage = 53025,--响应：伙伴重生确认完成
	ResEvolvePartnerMessage = 53026,--响应：伙伴进化成功
	ResPartnerRaffleInfoMessage = 53027,--响应：抽卡信息
	ReqPartnerRaffleInfoMessage = 53028,--请求：抽卡信息
	ReqPartnerHatchInfoMessage = 53029,--请求：获取伙伴孵化信息
	ResPartnerHatchInfoMessage = 53030,--响应：伙伴孵化信息
	ReqPartnerInputEggMessage = 53031,--请求：孵化一个伙伴蛋
	ResPartnerInputEggMessage = 53032,--响应：孵化一个伙伴蛋
	ReqPartnerInputEggsMessage = 53033,--请求：一键孵化伙伴蛋
	ResPartnerInputEggsMessage = 53034,--响应：一键孵化伙伴蛋
	ReqPartnerRaffleSubmitMessage = 53035,--请求：抽卡提交
	ResPartnerRaffleSubmitMessage = 53036,--响应：抽卡提交
	ReqSetPartnerWishMessage = 53037,--请求：设置心愿单
	ReqAccelerationHatchMessage = 53038,--请求：加速孵化
	ResAccelerationHatchMessage = 53039,--响应：加速孵化
	ReqOpenPartnerEggMessage = 53040,--请求：开启伙伴孵化蛋
	ResOpenPartnerEggMessage = 53041,--响应：开启伙伴孵化蛋
	ReqViewPartnerWishMessage = 53042,--请求：查看心愿单
	ResViewPartnerWishMessage = 53043,--响应：查看心愿单
	ReqSetPartnerRaffleCampMessage = 53046,--请求:设置-招募-阵营
	ReqPartnerRaffleBoxRewardMessage = 53047,--请求:累计-宝箱-领取
	ReqPartnerCallMessage = 53048,--请求:召唤出伙伴(如果已经有伙伴出战，则出战的伙伴会被替换)
	ReqPartnerReCallMessage = 53049,--请求:召唤回伙伴
	ReqPartnerSkillMessage = 53050,--请求:伙伴释放大招
	ResPartnerCallMessage = 53051,--响应：召唤伙伴
	ResPartnerSkillMessage = 53052,--响应：伙伴释放技能(此协议只在释放失败时响应)
	ResPartnerRaffleBoxRewardMessage = 53053,--响应:累计-宝箱-领取
	ReqPartnerRaffleBuyMessage = 53054,--请求:购买道具
	ResPartnerRaffleBuyMessage = 53055,--响应:购买道具
	ResSetPartnerRaffleCampMessage = 53056,--响应:设置-招募-阵营
	ResReLockPartnerRaffleCampMessage = 53057,--响应:重新上锁-阵营
	ReqRolePartnerInfoMessage = 53058,--请求:获取角色伙伴信息
	ResRolePartnerInfoMessage = 53059,--响应:对应角色伙伴信息
---partner_lay.xml
	ResPartnerDispatchChangeMessage = 55002,--伙伴派遣_变化
	ReqPartnerDispatchFlushMessage = 55003,--伙伴派遣_刷新
	ReqPartnerDispatchAcceptMessage = 55004,--伙伴派遣_接受
	ReqPartnerDispatchUpSpeedMessage = 55005,--伙伴派遣_加速
	ReqPartnerDispatchStartMessage = 55006,--伙伴派遣_开始
	ReqPartnerDispatchRewardMessage = 55007,--请求：伙伴派遣_领奖
	ResPartnerDispatchResultMessage = 55008,--伙伴派遣结果
	ResPartnerDispatchRewardMessage = 55009,--响应：伙伴派遣_领奖
	ResDispatchFlushVipFreeCountMessage = 55010,--响应：vip已使用免费刷新次数
---rank.xml
	ReqRankListMessage = 12001,--排行榜请求
	ResRankListMessage = 12002,--排行榜返回
---recharge.xml
	ReqOpenRechargePanelMessage = 71001,--请求任务内容
	ResRechargePanelMessage = 71002,--发送所有任务
	ReqRoleRechargeMessage = 71003,--充值 请求
	ResRoleRechargeMessage = 71004,--充值 响应
	ReqRechargeOrderIdMessage = 71005,--充值-生成订单 请求
	ResRechargeOrderIdMessage = 71006,--充值-生成订单 响应
---role.xml
	ReqDeployAttrPointMessage = 25001,--分配属性点
	ReqResetAttrPointMessage = 25002,--重置属性点
	ResNoticeAttrPointMessage = 25003,--通知分配属性点:分配属性点请求，重置
	ReqTryResetAttrPointMessage = 25004,--预重置属性点
	ResTryResetAttrPointMessage = 25005,--预重置属性点
	ResChangeNameMessage = 25006,--修改名称
	ResTransferCareerMessage = 25007,--响应:转职成功
	ResVipInitMessage = 25008,--登录和创角：成功给消息
	ResVipChangeMessage = 25009,--VIP更新响应
	ReqVipUpMessage = 25010,--VIP升级请求
	ReqVipActivateMessage = 25011,--VIP激活
	ResVipActivateMessage = 25012,--激活响应
	ReqVipExchangeMessage = 25013,--兑换 请求
	ResVipExchangeMessage = 25014,--兑换 响应
	ResVipUpMessage = 25015,--升级 响应
	ReqRechargeMessage = 25016,--充值 请求
	ResRechargeMessage = 25017,--充值 响应
	ReqDailyRewardMessage = 25018,--查看每日礼包已充值数量 请求
	ResDailyRewardMessage = 25019,--查看每日礼包已充值数量 响应
	ReqRewardHistoryInfoMessage = 25020,--查看充值历史记录 请求
	ResRewardHistoryInfoMessage = 25021,--查看充值历史记录 响应
	ReqTotalRewardMessage = 25022,--查看累计礼包已充值数量 请求
	ResTotalRewardMessage = 25023,--查看累计礼包已充值数量 响应
	ReqFirstRewardMessage = 25024,--查看钻石礼包首充领取数量 请求
	ResFirstRewardMessage = 25025,--查看钻石礼包首充领取数量 响应
	ReqBuyVipLevelGiftBagMessage = 25026,--购买VIP礼包 请求
	ResBuyVipLevelGiftBagMessage = 25027,--购买VIP礼包 响应
	ReqWelfareInfoMessage = 25028,--查看福利(月卡、赞助、基金)详情请求
	ResWelfareInfoMessage = 25029,--福利福利(月卡、赞助、基金)详情响应
	ReqBuyWelfareMessage = 25030,--购买福利(月卡、赞助、基金)请求
	ReqReceiveWelfareMessage = 25031,--领取福利(月卡、赞助、基金)奖励请求
	ReqLimitRewardMessage = 25032,--查看限时领取奖励 请求
	ResLimitRewardMessage = 25033,--查看限时领取奖励 响应
	ReqTransferCareerMessage = 25034,--转职请求
	ResNextCareersMessage = 25035,--转职后的目标职业 响应
	ReqMenuIsDisplayMessage = 25036,--页签是否显示 请求
	ResMenuIsDisplayMessage = 25037,--页签是否显示 响应
	ResOpenTransferCareerMessage = 25038,--使用职业转换道具后打开页面 响应
	ResObtainWorldLevelMessage = 25039,--获取世界等级 响应
	ReqReceivePreviewRewardMessage = 25040,--领取预告奖励 请求
	ResPreviewRewardInfoMessage = 25041,--预告奖励领取信息 响应
	ReqCancelTransferCareerMessage = 25042,--请求：撤销-转职
	ResCancelTransferCareerMessage = 25043,--响应：撤销-转职
	ResPinkDiamondInfoMessage = 25044,--响应：红钻信息
	ReqPinkDiamondRewardMessage = 25045,--请求：红钻领奖
	ResPinkDiamondRewardMessage = 25046,--响应：红钻领奖
	ReqActiveVipLvMessage = 25047,--请求：激活vip等级
	ResActiveVipLvMessage = 25048,--响应：激活vip等级
	ReqUnlockVipMessage = 25049,--请求：解锁
	ResUnlockVipMessage = 25050,--响应：解锁
	ReqRewardVipMessage = 25051,--请求：领取
	ResRewardVipMessage = 25052,--响应：领取
	ReqPinkDiamondSendMessage = 25053,--请求：红钻面板展示信息
	ResPinkDiamondSendMessage = 25054,--响应：红钻面板展示信息
	ReqTransferCareerByTaskMessage = 25055,--请求转职
	ResAlreadyBuyWelfareMessage = 25056,--响应：已购买的所有福利项(月卡、赞助等)
	ResTransferCareerByTaskMessage = 25057,--请求转职返回（只有成功才会发）
	ResMiniGameInfoMessage = 25058,--星云星图信息同步(也叫小游戏)
	ReqMiniGameUpgradeMessage = 25059,--星云星图升级(也叫小游戏)
	ResGainExpMessage = 25060,--响应：获取经验之后给客户端响应信息
	ResFirstRechargeMessage = 25061,--响应: 玩家首充信息
	ResCDChangedMessage = 25062,--玩家CD变化
	ResFirstChargeViewMessage = 25063,--首充奖励界面 响应
	ReqReceiveFirstChargeMessage = 25064,--领取奖励 请求
	ReqFirstChargeViewMessage = 25065,--首充奖励界面 请求
	ReqSponsorViewMessage = 25066,--赞助界面 请求
	ResSponsorViewMessage = 25067,--赞助界面 响应
	ReqActiveSponsorMessage = 25068,--激活赞助 请求
	ReqRechargeDailyViewMessage = 25069,--累计充值界面 请求
	ResRechargeDailyViewMessage = 25070,--累计充值界面 响应
	ReqReceiveRechargeDailyMessage = 25071,--领取累计充值 请求
	ReqBuyVipTimesMessage = 25072,--请求：购买vip次数
	ResBuyVipTimesChangeMessage = 25073,--响应:购买vip次数变化
	ResUnlockNewMapMessage = 25074,--解锁新地图 响应
	ReqChangeNameMessage = 25075,--修改名称
	ReqRoleAccumulatedRechargeMessage = 25076,--请求：查询累计充值金额
	ResRoleAccumulatedRechargeMessage = 25077,--响应：累计充值金额
	ReqReceiveLimitTotalRechargeMessage = 25078,--请求 领取限时累计充值
	ReqMonthlyCardViewMessage = 25079,--请求 奇迹币月卡界面
	ResMonthlyCardViewMessage = 25080,--响应 奇迹币月卡界面
	ReqReceiveMonthlyCardMessage = 25081,--请求 领取奇迹币月卡
	ResReceiveMonthlyCardMessage = 25082,--响应 领取奇迹币月卡
	ReqLimitTotalRechargeViewMessage = 25083,--请求 限时累计充值面板
	ResLimitTotalRechargeViewMessage = 25084,--响应 限时累计充值面板
	ReqFirstRechargeViewMessage = 25085,--请求：首充活动界面
	ResFirstRechargeViewMessage = 25086,--响应：首充活动界面
	ReqReceiveFirstRechargeMessage = 25087,--请求：领取首充活动
	ResFirstRechargeOpenStateMessage = 25088,--响应：首充刷新状态
	ReqFirstRechargeMessage = 25089,--响应：首充充值
	ReqAlsoFirstRechargeMessage = 25090,--请求：首充记录
	ResAlsoFirstRechargeMessage = 25091,--响应：首充记录
	ResRoleBasicAttrMessage = 25092,--响应：发送角色基础属性信息
	ResRoleDeployAttrPointMessage = 25093,--响应：角色加点成功
---schedule.xml
	ResFlushTypeMessage = 19001,--刷新类型消息
---skill.xml
	ReqUpSkillMessage = 7001,--技能学习或者升级
	ResSkillChangeMessage = 7002,--技能学习或者升级
	ResMainSkillMessage = 7003,--普通攻击技能信息
	ReqMasterSkillAddTittleMessage = 7004,--请求：大师技能加点
	ResMasterSkillTittleChangeMessage = 7005,--响应：大师技能点发生改变
	ReqResetMasterSkillTittleMessage = 7006,--请求：重置大师点数
	ResMasterSkillInfosMessage = 7007,--响应：大师技能信息详情
	ResResetMasterSkillTittleMessage = 7008,--响应：重置大师点数
	ResCaromSkillMessage = 7009,--所有连击技能
	ResSkillLockMessage = 7010,--响应：指定技能上锁
	ResSkillUnlockMessage = 7011,--响应：指定技能解锁
---stall.xml
	ReqBeginStallMessage = 20001,--请求：开始摆摊
	ResBeginStallMessage = 20002,--响应：开始摆摊
	ReqOpenStallMessage = 20003,--请求：查看摊位
	ResStallInfoMessage = 20004,--响应：摊位信息
	ReqAddStallItemMessage = 20005,--请求：上架物品
	ReqRemoveStallItemMessage = 20006,--请求：下架物品
	ReqOverStallMessage = 20007,--请求：收摊
	ReqUpdateStallInfoMessage = 20008,--请求：修改摊位信息(广告)
	ReqBuyStallItemMessage = 20009,--请求：购买物品
	ReqSalesRecordMessage = 20010,--请求：查看出售记录
	ResSalesRecordMessage = 20011,--响应：出售记录详情
	ResUpdateStallMessage = 20012,--响应：摊位更新(仅更新数据,不弹开界面)
---store.xml
	ReqStoreMessage = 14001,--仓库请求
	ResStoreMessage = 14002,--仓库请求返回
	ReqStoreToBagMessage = 14003,--背包拖到仓库请求
	ReqBagToStoreMessage = 14004,--背包拖到仓库请求
	ResStoreChangeMessage = 14005,--仓库信息改变响应
	ReqTidyStoreItemMessage = 14006,--仓库整理请求
	ReqSwapStoreItemMessage = 14007,--交换道具请求
	ResSwapStoreItemMessage = 14008,--交换道具响应
	ResLockStoreGridMessage = 14009,--锁仓库格子响应
	ReqBagPutStoreButtonMessage = 14010,--背包存入按钮请求
	ReqStoreTakeButtonMessage = 14011,--仓库按钮取出请求
	ReqStoreGiveUpItemMessage = 14012,--仓库丢弃道具
	ReqStoreAddCapacityMessage = 14013,--仓库扩容
	ReqStoreAddPageMessage = 14014,--仓库扩页
	ResTidyStoreItemMessage = 14015,--仓库整理请求
---sunday_activities.xml
	ReqGoldArmyTaskInfoMessage = 70001,--请求: 黄金部队任务信息
	ResGoldArmyTaskInfoMessage = 70002,--响应: 黄金部队任务信息
	ReqReceiveGoldArmyRewardMessage = 70003,--请求: 领取黄金部队任务奖励
	ReqSundayGiftPacksMenuMessage = 70004,--请求: 领取周日礼包菜单
	ResSundayGiftPacksMenuMessage = 70005,--响应: 周日礼包菜单
	ReqBuySundayGiftPacksMessage = 70006,--请求: 购买周日礼包
---talent.xml
	ReqTalentInfoMessage = 62001,--请求天赋信息
	ResTalentInfoMessage = 62002,--服务器返回天赋信息
	ResTalentInfoUpdateSynMessage = 62003,--更新天赋部分信息
	ReqTalentExpExchangeMessage = 62004,--请求兑换经验
	ReqTalentUpgradeMessage = 62005,--请求升级天赋
	ReqTalentResetMessage = 62006,--请求重置天赋
---task.xml
	ResSendAllTaskMessage = 24001,--发送所有任务
	ReqSendTaskInfoMessage = 24002,--请求任务内容
	ReqAcceptTaskMessage = 24004,--接受任务
	ReqGiveUpTaskMessage = 24005,--放弃任务
	ReqSubmitTaskMessage = 24006,--提交任务
	ResTaskRewardMessage = 24007,--发送任务奖励道具
	ResRoleTaskChangeMessage = 24014,--玩家任务统一回包
	ReqClickTaskMessage = 24015,--当前选中的任务
	ReqCheckAcceptTaskMessage = 24016,--是否可以领取任务-请求
	ResCheckAcceptTaskMessage = 24017,--是否可以领取任务-响应
	ResGoldTaskUpdateMessage = 24018,--响应:黄金挑战任务更新
	ReqRoleEffectMessage = 24019,--请求:效率信息
	ResRoleEffectChangeMessage = 24020,--响应:效率信息
	ResAchievementChangeMessage = 24021,--响应：玩家成就统一回包
	ReqUpAchievementBattleStratumMessage = 24022,--请求：升级战阶
	ResAchievementInfoMessage = 24023,--响应：成就系统信息
	ReqSubmitAchievementTaskMessage = 24024,--请求:提交任务
	ResUpAchievementBattleStratumMessage = 24025,--响应：升阶结果
	ReqBossFistKillInfoMessage = 24026,--请求: 开服竞技详情
	ResBossFistKillInfoMessage = 24027,--响应：开服竞技详情
	ReqGetNewAreaRankBossRewardMessage = 24028,--请求: 领取Boss首杀奖励
	ReqNewAreaRankInfoMessage = 24029,--请求: 请求开服竞技排行榜
	ResNewAreaRankInfoMessage = 24030,--响应：开服竞技排行详情
	ReqNewAreaRankGetPersonalRewardMessage = 24031,--请求: 领取开服竞技个人目标奖励
	ReqNewAreaRankRedPointMessage = 24032,--请求: 开服竞技红点信息
	ResNewAreaRankRedPointMessage = 24033,--响应：开服竞技红点信息
	ResNewAreaRankGetPersonalRewardMessage = 24034,--响应：开服竞技个人奖励领取结果
	ResKingRoadTaskInfoMessage = 24035,--响应: 王者之路任务详情
	ReqReceiveKingRoadAwardMessage = 24036,--请求:领取王者之路任务奖励
	ResKingRoadChapterUpdateMessage = 24037,--响应: 王者之路任务章节更新
	ResOfferRewardBossPanelMessage = 24038,--响应：boss悬赏面板
	ReqGetOfferBossRewardMessage = 24039,--请求: 领取Boss悬赏奖励
	ResGetOfferBossRewardMessage = 24040,--响应：boss悬赏奖励领取完成
	ReqGetOfferBossPanelMessage = 24041,--请求: 请求boss悬赏面板
---team.xml
	ReqMarryMessage = 16001,--结婚请求
	ResAskMarryMessage = 16002,--有人向你请求结婚
	ReqAgreeMarryMessage = 16003,--同意结婚请求
	ResAgreeMarryMessage = 16004,--同意结婚响应
	ReqDivorceMessage = 16005,--离婚请求
	ResMarryInfoMessage = 16006,--结婚信息响应
	ReqCancelOrRejectDivorceMessage = 16007,--取消、拒绝离婚请求
	ReqCompulsoryDivorceMessage = 16008,--强制离婚请求
	ReqAgreeDivorceMessage = 16009,--同意离婚请求
	ReqMarryInfoMessage = 16010,--结婚信息获取请求
	ReqCreateTeamMessage = 16020,--请求:创建队伍
	ResTeamInfoMessage = 16021,--响应:队伍信息
	ReqTeamInfoMessage = 16022,--请求队伍信息
	ReqQuitTeamMessage = 16023,--请求:离开队伍
	ReqPlayerListMessage = 16024,--请求:玩家列表
	ResPlayerListMessage = 16025,--响应:玩家列表
	ReqSendTeamInvitationMessage = 16026,--请求:发出队伍邀请
	ResTeamAlertMessage = 16027,--响应:邀请/申请的气泡提示
	ReqInviteListOrApplyListMessage = 16028,--请求:查看邀请/申请列表
	ResInvitationListMessage = 16029,--响应:邀请列表
	ResApplicationListMessage = 16030,--响应:申请列表
	ReqReplyInvitationMessage = 16031,--请求:回复邀请
	ReqNearbyTeamListMessage = 16032,--请求:查看附近队伍
	ResNearbyTeamListMessage = 16033,--响应:附近队伍列表
	ReqApplyJoinTeamMessage = 16034,--请求:申请加入队伍
	ReqReplyApplyMessage = 16035,--请求:回复申请
	ReqKickOutMemberMessage = 16036,--请求:踢出成员
	ReqChangeCaptainMessage = 16037,--请求:转移队长
	ReqPublishRecruitInfoMessage = 16038,--请求:发布招募信息
	ResTeamMemberHpChangeMessage = 16039,--响应:队员血条变化
	ReqCreateTeamAndInviteMessage = 16040,--请求:创建队伍并邀请玩家入队
	ResTeamLoseMessage = 16041,--队伍已消失
	ResTeamLoseByLeaderMessage = 16042,--队伍已消失
	ReqTeamRoleTeamIdMessage = 16043,--请求某个玩家的队伍id
	ResTeamRoleTeamIdMessage = 16044,--返回某个玩家的队伍id
	ReqClearInviteOrApplyMessage = 16045,--清理邀请记录和申请记录
---tip.xml
	ResTipMessage = 101001,--提示消息
---title.xml
	ReqGetTitleListMessage = 21001,--获取称号列表请求
	ResTitleListMessage = 21002,--称号列表响应
	ReqEquipTitleMessage = 21003,--装备称号/取消装备称号请求
	ReqGetTitleListMessage2Message = 21004,--获取称号列表请求
	ResTitleListMessage2Message = 21005,--称号列表响应
	ReqEquipTitleMessage2Message = 21006,--装备称号/取消装备称号请求
	ReqTitleStrengthenMessage = 21007,--称号强化
	ResTitleStrengthenMessage = 21008,--称号强化响应
	ReqTitleHiddenStateChangeMessage = 21009,--称号隐藏/取消隐藏请求
	ResTitleHiddenStateChangeMessage = 21010,--称号隐藏/取消隐藏称号成功响应
---trade.xml
	ReqTradeMessage = 8001,--请求进行交易
	ResTradeMessage = 8002,--返回交易请求
	ReqAgreeTradeMessage = 8003,--同意交易
	ReqSetTradeProgressMessage = 8006,--设置交易进度
	ResTradeStateChangeMessage = 8007,--返回交易状态变化
	ResTradeStartMessage = 8008,--交易开始
	ResTradeUpdateMessage = 8009,--交易变化
	ReqAddItemToTradeMessage = 8010,--添加物品请求
	ReqRemoveItemFromTradeMessage = 8011,--去除物品请求
	ResTradeGoodsMessage = 8012,--返回商品信息
---tradeline.xml
	ReqGoodsInfoMessage = 23001,--请求交易行商品信息
	ResGoodsInfoMessage = 23002,--交易行商品信息列表响应
	ReqMyShelvesMessage = 23003,--请求我的上架信息
	ResMyShelvesMessage = 23004,--我的上架信息响应
	ReqUpShelfGoodsMessage = 23005,--请求上架商品
	ReqDownShelfGoodsMessage = 23006,--请求下架商品
	ReqBuyGoodsMessage = 23007,--请求购买商品
	ResBuyGoodsMessage = 23008,--购买商品响应
	ReqTradeLineRecordMessage = 23009,--请求查询交易行交易记录
	ResTradeLineRecordMessage = 23010,--交易行交易记录响应
	ReqAuctionGoodsMessage = 23011,--竞拍商品请求
	ResTradeLineGoodsUpdateMessage = 23012,--交易行商品更新响应
	ReqPreorderGoodsInfoMessage = 23013,--请求预购商品信息
	ResPreorderGoodsListMessage = 23014,--预购商品列表响应
	ResBiddingFailMessage = 23015,--奇迹5竞拍失败提示
	ReqBiddingGoodsInfoMessage = 23016,--请求竞拍商品信息
	ResBiddingGoodsInfoMessage = 23017,--响应竞拍商品信息
	ResBiddingResultMessage = 23018,--响应竞拍商品信息
	ResGoodsOfGardBossVaildMessage = 23019,--交易行战盟boss是否有效攻击响应
---ui.xml
	ReqUiMessage = 28001,--Ui请求操作
	ResRefreshUiMessage = 28002,--重绘Ui
	ResMsgBoxMessage = 28003,--响应：弹出提示框
	ReqUiCloseMessage = 28004,--关闭UI
	ResFilterGlobalMsgMessage = 28005,--过滤全服信息提示
	ResOpenHyperlinkMessage = 28006,--使用脚本调出游戏面板
	ResAddButtonMessage = 28007,--添加自定义按钮
	ResDelButtonMessage = 28008,--删除自定义按钮
	ResRedDotMessage = 28009,--添加按钮红点
	ResRedDelMessage = 28010,--删除按钮红点
	ResNavigationMessage = 28011,--新手界面引导功能
	ResOpenNpcShowExMessage = 28012,--自动寻路打开指定NPC面板
	ResOpenWindowsMessage = 28013,--查看人物角色面板
	ResViewPlayerMessage = 28014,--查看别人角色面板
	ResOpenNpcShowMessage = 28015,--打开指定NPC面板
	ResMapEffectMessage = 28016,--在地图上播放场景特效
	ResDelMapEffectMessage = 28017,--删除地图特效
	ReqBagToTmpItemBoxMessage = 28018,--请求：从背包到TmpItemBox(ok框)
	ResBagToTmpItemBoxMessage = 28019,--返回：从背包到TmpItemBox(ok框)
	ReqTmpItemBoxToBagMessage = 28020,--请求: 从TmpItemBox(ok框)到背包
	ResTmpItemBoxToBagMessage = 28021,--返回：从TmpItemBox(ok框)到背包
	ResUpdateItemGmExtMessage = 28022,--返回：改变道具名字和名字颜色响应
	ResRedDotListMessage = 28023,--红点列表
---union.xml
	ReqCreateUnionMessage = 17001,--创建战盟
	ResCreateUnionMessage = 17002,--响应:创建战盟
	ReqAllUnionMessage = 17003,--所有战盟信息请求
	ResAllUnionMessage = 17004,--所有战盟信息响应
	ReqUnionDetailsMessage = 17005,--单个战盟信息
	ResUnionDetailsMessage = 17006,--响应：单个战盟信息
	ReqViewUnionMessage = 17007,--战盟信息请求
	ResViewUnionMessage = 17008,--战盟信息响应
	ReqApplyJoinUnionMessage = 17009,--请求：申请加入
	ResApplyJoinUnionMessage = 17010,--响应：申请加入
	ResEnterUnionMessage = 17011,--响应: 给申请者响应战盟信息
	ReqAgreeUnionApplyMessage = 17012,--请求:处理申请列表
	ResViewUnionChangeMessage = 17013,--详细信息实时变更
	ResUnionMemberChangeMessage = 17014,--成员实时变更
	ReqSendApplyListInfoMessage = 17015,--请求：查看入会申请列表
	ResSendApplyListInfoMessage = 17016,--响应：查看入会申请列表
	ReqModifyArmbandMessage = 17017,--请求：修改臂章
	ReqChangeAnnouncementMessage = 17018,--请求：修改公告
	ReqAllApplyMessage = 17019,--请求：一键申请
	ReqQuitUnionMessage = 17020,--请求：退出战盟
	ReqAllAgreeMessage = 17021,--请求：一键同意
	ReqAllRejectMessage = 17022,--请求：一键拒绝
	ReqChangeUnionNameMessage = 17023,--请求：修改名称
	ReqKickOutUnionMemberMessage = 17024,--请求：踢出成员
	ReqEnemyUnionMessage = 17025,--请求：敌对战盟
	ReqUnionSettingMessage = 17026,--请求:招募设置
	ResUnionSettingMessage = 17027,--响应:招募设置
	ReqEnemyUnionListMessage = 17028,--请求:敌对战盟列表
	ResEnemyUnionListMessage = 17029,--响应:敌对战盟列表
	ReqUnionNameViewMessage = 17030,--请求:改名视图
	ResUnionNameViewMessage = 17031,--响应:改名视图
	ReqDonateCapitalMessage = 17032,--请求:捐献资金
	ReqImpeachMasterMessage = 17033,--请求:弹劾盟主
	ResUnionApplyListMessage = 17034,--响应:操作申请列表响应
	ResQuitUnionMessage = 17035,--响应：退出战盟
	ReqEnemyUnionViewMessage = 17036,--请求：发起敌对行会界面
	ResEnemyUnionViewMessage = 17037,--响应：发起敌对行会界面
	ResLoginEnemyUnionMessage = 17038,--响应：登录发送敌对行会信息
	ReqChangePositionMessage = 17039,--请求：更换职位
	ReqArmbandsViewMessage = 17040,--请求：打开战盟臂章等级界面
	ResArmbandsViewMessage = 17041,--响应：打开战盟臂章等级界面
	ReqArmbandsLevelUpMessage = 17042,--请求：臂章等级升级
	ResArmbandsLevelChangeMessage = 17043,--响应：臂章等级升级
	ReqArmbandsStrongUpMessage = 17044,--请求：臂章强化升级
	ResArmbandsStrongChangeMessage = 17045,--响应：臂章强化升级
	ReqSendUnionTaskListMessage = 17046,--请求：发送任务列表
	ResSendUnionTaskListMessage = 17047,--响应：发送任务列表
	ReqSubmitUnionTaskMessage = 17048,--请求：领取任务奖励
	ResSendOnOfflineMessage = 17049,--响应：上下线实时刷新
	ReqUnionSalaryMessage = 17050,--请求：战盟工资信息
	ResUnionSalaryMessage = 17051,--响应：战盟工资信息
	ReqReceiveSalaryMessage = 17052,--请求：领取战盟工资
	ReqUnionBlessViewMessage = 17053,--请求：战盟赐福界面
	ResUnionBlessViewMessage = 17054,--响应：战盟赐福界面
	ReqUnionBlessExtractMessage = 17055,--请求：抽取
	ReqBlessOneKeyExtractMessage = 17056,--请求：一键抽取
	ResBlessRankInfoMessage = 17057,--响应：赐福获取道具阶级信息
	ResUnionEventTypeMessage = 17058,--响应：战盟事件类型信息
	ReqInitiateSelectUnionLeaderMessage = 17059,--请求：战盟竞选
	ResSelectUnionLeaderInfoMessage = 17060,--响应：战盟竞选信息
	ResUnionDevoteRefreshMessage = 17061,--响应：战盟贡献实时刷新
	ResReceiveSalaryMessage = 17062,--响应：领取工资
	ResCanReceiveSalaryMessage = 17063,--响应：能否领取工资
	ReqChangeUnionNameByCardMessage = 17064,--请求：改名卡改名
	ReqUnionMemberInfoMessage = 17065,--请求：战盟成员信息
	ResUnionMemberInfoMessage = 17066,--响应：战盟成员信息
	ReqUnionMemberDynamicMessage = 17067,--请求：战盟成员动态信息
	ResUnionMemberDynamicMessage = 17068,--响应：战盟成员动态信息
	ReqUpdateUnionInfoMessage = 17069,--请求：修改战盟臂章和名字
	ResUpdateUnionInfoMessage = 17070,--响应：修改战盟臂章和名字
---user.xml
	ReqLoginMessage = 1001,--请求登录
	ResLoginMessage = 1002,--登录返回
	ReqEnterRoleMessage = 1003,--请求进入角色
	ResEnterRoleMessage = 1004,--角色进入返回消息
	ReqCreateRoleMessage = 1005,--请求创建角色
	ResCreateRoleMessage = 1006,--返回创建角色
	ReqRemoveRoleMessage = 1007,--请求删除角色
	ResRemoveRoleMessage = 1008,--返回删除角色
	ReqRecoverRoleMessage = 1009,--请求恢复角色
	ResRecoverRoleMessage = 1010,--返回恢复角色
	ReqRoleInfoMessage = 1011,--角色信息请求
	ResRoleInfoMessage = 1012,--角色信息响应
	ReqRoleSettingMessage = 1013,--角色设定请求
	ResRoleSettingMessage = 1014,--角色设定响应
	ReqHeartMessage = 1016,--心跳请求
	ResHeartMessage = 1017,--心跳响应
	ReqQuitGameMessage = 1018,--请求大退出:退出游戏
	ResQuitGameMessage = 1019,--返回:大退出
	ReqQuitRoleMessage = 1020,--请求小退出:退出角色,到选角列表
	ResQuitRoleMessage = 1021,--返回小退出:退出角色,到选角列表
	ResDisplaceUserMessage = 1022,--被顶号
	ReqRandomRoleNameMessage = 1023,--角色随机名字请求
	ResRandomRoleNameMessage = 1024,--角色随机名字响应
	ReqHangUpSettingMessage = 1025,--请求保存挂机设置
	ResHangUpSettingMessage = 1026,--响应挂机设置
	ReqSkillShowTypeMessage = 1027,--设置技能显示请求
	ResSkillShowTypeMessage = 1028,--设置技能显示回包
	ReqClientLoadedMessage = 1029,--客户端进度条加载完毕
	ReqOtherRoleInfoMessage = 1030,--其他角色信息请求
	ResOtherRoleInfoMessage = 1031,--其他角色信息响应
	ReqRoleOthersDataMessage = 1032,--请求存储角色其他通用信息
	ResRoleOthersDataMessage = 1033,--响应存储角色其他通用信息
	ResMidnightEventMessage = 1034,--凌晨事件触发通知客户端响应
	ReqRoleFruitInfoMessage = 1035,--角色果实信息请求
	ResRoleFruitInfoMessage = 1036,--角色果实信息响应
	ReqUpdateEquipLooksMessage = 1037,--改变角色外观请求
	ReqRoleSynthesisLuckyMessage = 1038,--请求： 获取角色合成一代幸运值信息
	ResRoleSynthesisLuckyMessage = 1039,--响应： 获取角色合成一代幸运值信息
	ReqCreateInviteCodeMessage = 1040,--请求： 生成邀请码
	ResCreateInviteCodeMessage = 1041,--响应： 生成邀请码
	ResFreshInviteCodeMessage = 1042,--响应： 刷新邀请码数量
	ReqCdKeyMessage = 1043,--请求：兑换码
	ResCdKeyMessage = 1044,--响应：兑换码
	ReqUpdateEquipLooks2Message = 1045,--改变角色外观请求
	ReqUnLockUserCareerMessage = 1046,--请求：解锁职业
	ResUnLockUserCareerMessage = 1047,--响应：解锁职业
	ReqSetAttAddWayMessage = 1048,--设置角色加成方式
	ResAttAddWayMessage = 1049,--获取角色加成方式
	ReqJiuJiuTradeTokenMessage = 1050,--请求：九九交易行token
	ResJiuJiuTradeTokenMessage = 1051,--响应：九九交易行token
	ResJiuJiuTradeLockRoleChangeMessage = 1052,--响应：九九交易行锁定角色变化信息
---warorder.xml
	ResAllWarOrderMessage = 65001,--响应所有战令信息
	ReqWarOrderUpLevelMessage = 65002,--请求战令进阶
	ResWarOrderUpLevelMessage = 65003,--响应战令进阶
	ResUpdateOneWarOrderMessage = 65004,--更新一条战令信息
	ReqWarOrderExchangeMessage = 65005,--兑换请求
	ResWarOrderExchangeMessage = 65006,--兑换响应
	ReqWarOrderAwardMessage = 65007,--请求战令领取
	ResWarOrderAwardMessage = 65008,--响应战令领取
	ReqWarOrderAwardAllMessage = 65009,--请求战令一键领取
	ResWarOrderAwardAllMessage = 65010,--响应战令一键领取
	ReqAllWarOrderMessage = 65011,--请求所有战令信息
	ReqWarOrderAwardTaskMessage = 65012,--请求战令某个任务的奖励
	ResWarOrderAwardTaskMessage = 65013,--返回战令某个任务的奖励
	ResUpdateWarOderTaskGoalMessage = 65014,--更新战令某个任务目标数据
}