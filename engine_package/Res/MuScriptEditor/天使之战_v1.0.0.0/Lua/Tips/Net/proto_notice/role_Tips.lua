--工具自动生成
---@class RoleProtos.DeployAttrPointReq
---@field attr CommonProtos.FightAttribute[] 
---@field type number 

---@class RoleProtos.DeployResult
---@field type number 
---@field attrInfo RoleProtos.DeployAttrInfo[] 

---@class RoleProtos.DeployAttrInfo
---@field attrId number 
---@field attrValue number 

---@class RoleProtos.NoticeAttrPointRes
---@field remain number @剩余

---@class RoleProtos.ResetAttrPointReq

---@class RoleProtos.TryResetAttrPointReq

---@class RoleProtos.TryResetAttrPointRes
---@field all number @剩余

---@class RoleProtos.ChangeNameRes
---@field rid number 
---@field name string @ 新名称

---@class RoleProtos.TransferCareerRes
---@field newCareer CommonProtos.Career 
---@field lastCareer CommonProtos.Career 
---@field cancelCd number @可以取消倒计时，此刻以前都可以撤销

---@class RoleProtos.CancelTransferCareerRes
---@field currCareer CommonProtos.Career 

---@class RoleProtos.VipInfo
---@field vipStage number @大级别
---@field vipStar number @小级别
---@field exp number @经验 改参数不再使用
---@field vipInitTime number @创建VIP时间
---@field lastTime number @最后一次更新时间
---@field exchangeTimes number @已兑换次数
---@field lastExchangeMills number @上次执行兑换的时间戳
---@field purchasedGiftBags RoleProtos.PurchasedGiftBags[] 
---@field vipStage2 number @尊享：大级别
---@field vipStar2 number @尊享：小级别
---@field unlockCfgIds number[] @已解锁 true
---@field rewardCfgIds number[] @领取礼包

---@class RoleProtos.PurchasedGiftBags
---@field type number @类型
---@field star number[] @星级

---@class RoleProtos.VipInitRes
---@field vipInfo RoleProtos.VipInfo 

---@class RoleProtos.VipChangeRes
---@field vipInfo RoleProtos.VipInfo 

---@class RoleProtos.VipUpReq

---@class RoleProtos.VipExchangeReq
---@field exchangeCfgId number @兑换请求

---@class RoleProtos.VipExchangeRes
---@field exchangeTimes number @已兑换次数
---@field lastExchangeMills number @上次执行兑换的时间戳

---@class RoleProtos.VipActivateReq
---@field way number @ 激活方式

---@class RoleProtos.VipActivateRes
---@field way number @ 激活方式
---@field vipInfo RoleProtos.VipInfo 
---@field vipStar number @小级别

---@class RoleProtos.VipUpRes
---@field vipStage number @大级别
---@field vipStar number @小级别

---@class RoleProtos.VipLvBean
---@field vipStage number @大级别
---@field vipStar number @小级别
---@field vipType number @vip类型,

---@class RoleProtos.ActiveVipLvReq
---@field vipLvBean RoleProtos.VipLvBean 

---@class RoleProtos.ActiveVipLvRes
---@field vipLvBean RoleProtos.VipLvBean 

---@class RoleProtos.UnlockVipReq
---@field way number @1 消耗道具解锁， 2花费人民币

---@class RoleProtos.UnlockVipRes
---@field vipInfo RoleProtos.VipInfo 

---@class RoleProtos.RewardVipReq
---@field vipStage number @大级别
---@field vipStar number @小级别

---@class RoleProtos.RewardVipRes
---@field vipInfo RoleProtos.VipInfo 
---@field rewards CommonProtos.Item[] @所有道具

---@class RoleProtos.BuyVipTimes
---@field actId number @ cfg_activity_rule.id
---@field times number @已购买次数

---@class RoleProtos.BuyVipTimesReq
---@field actId number @，cfg_activity_rule.id

---@class RoleProtos.BuyVipTimesChangeRes
---@field buyVipTimes RoleProtos.BuyVipTimes[] 

---@class RoleProtos.ReChargeReq
---@field cfgId number @礼包cfgid

---@class RoleProtos.ReChargeRes
---@field cfgId number @礼包cfgid
---@field success number @充值是否成功

---@class RoleProtos.RewardCount
---@field cfgId number 
---@field count number 

---@class RoleProtos.RechargeLastTime
---@field cfgId number 
---@field lastTime number 

---@class RoleProtos.DailyRewardReq

---@class RoleProtos.DailyRewardRes
---@field rewardCount RoleProtos.RewardCount[] @礼包cfgId：礼包已充值数量

---@class RoleProtos.TotalRewardReq

---@class RoleProtos.TotalRewardRes
---@field rewardCount RoleProtos.RewardCount[] @礼包cfgId：礼包已充值数量

---@class RoleProtos.FirstRewardReq

---@class RoleProtos.FirstRewardRes
---@field rewardCount RoleProtos.RewardCount[] @礼包cfgId：礼包已充值数量
---@field lastTime RoleProtos.RechargeLastTime[] @礼包cfgId: 上次成功领奖的时间

---@class RoleProtos.RewardTime
---@field cfgId number 
---@field count number @充值次数
---@field time number 

---@class RoleProtos.RewardHistoryInfoReq

---@class RoleProtos.RewardHistoryInfoRes
---@field rewardHistory RoleProtos.RewardTime[] @礼包cfgId：充值时间
---@field totalMoney number @总充值金额

---@class RoleProtos.BuyVipGiftBag
---@field type number 
---@field star number 

---@class RoleProtos.WelfareInfoReq
---@field uiId number @ 归属界面页签id

---@class RoleProtos.WelfareInfoRes
---@field uiId number @ 归属界面页签id
---@field alreadyBuy boolean @ 是否已购买
---@field selfCondition number @ 自身条件(等级或达成天数)
---@field welfareItems RoleProtos.WelfareItem[] @ 福利项

---@class RoleProtos.WelfareItem
---@field id number @ 福利项id(cfg_month_sponsorship表id)
---@field alreadyReceive boolean @ 是否已领取

---@class RoleProtos.BuyWelfareReq
---@field uiId number 

---@class RoleProtos.ReceiveWelfareReq
---@field id number @ 福利项id(cfg_month_sponsorship表id)

---@class RoleProtos.LimitRewardRes
---@field rewardCount RoleProtos.RewardCount[] @礼包cfgId：礼包已充值数量
---@field endTime number 

---@class RoleProtos.TransferCareerReq
---@field cfgId number @career职业表的配置id
---@field transferCareerIdx number @职业转换道具背包中的索引

---@class RoleProtos.OpenTransferCareerRes
---@field transferCareerIdx number @职业转换道具背包中的索引
---@field baseCareers number[] @职业转换道具id可以转职的所有根职业

---@class RoleProtos.NextCareersRes
---@field cfgId number[] @career职业表的配置id
---@field isFirst boolean @是否为第一次弹出给客户端

---@class RoleProtos.MenuIsDisplayRes
---@field menuId number[] 

---@class RoleProtos.ObtainWorldLevelRes
---@field worldLevel number @世界等级

---@class RoleProtos.ReceivePreviewRewardReq
---@field id number @预告主键id

---@class RoleProtos.ReceivePreviewRewardRes
---@field receiveInfos RoleProtos.ReceiveInfo[] @预告奖励领取信息

---@class RoleProtos.ReceiveInfo
---@field id number @预告主键id
---@field isReceive boolean @预告奖励是否已经领取

---@class RoleProtos.PinkDiamondInfoRes
---@field id number @百亿粉钻活动的 cfgId
---@field endTime number @全局百亿粉钻活动的结束时间
---@field roleEndContinuous number @角色获取粉钻结束时间
---@field roleEndShopTime number @角色粉钻商店结束时间
---@field roleEndTime number @角色百亿粉钻活动的结束时间

---@class RoleProtos.PinkDiamondSendRes
---@field receiveCount number @点击领取可以领取的道具数量 展示使用
---@field receivedCount number @已经领取的道具数量
---@field receiveMaxCount number @能够领取的最大的道具数量
---@field receivedCountCurDay number @当天已经领取过的道具数量
---@field receiveMaxCountCurDay number @当天能够领取的最大道具数量

---@class RoleProtos.TransferCareerByTaskReq

---@class RoleProtos.AlreadyBuyWelfare
---@field welfareId number[] 

---@class RoleProtos.MiniGameUpgradeReq
---@field id number @cfg_minigame表的id

---@class RoleProtos.MiniGameInfoRes
---@field id number @cfg_minigame 当前的id.
---@field failAddRate number @失败额外增加的概率.

---@class RoleProtos.GainExpRes
---@field exp number @获取的经验
---@field stringId number @分钟经验的string表对应的id
---@field actionDesc string @获取经验的动作

---@class RoleProtos.FistRecharge
---@field recharge number 

---@class RoleProtos.CDBean
---@field id number @玩家id
---@field roleType number @1玩家，2伙伴
---@field skillList RoleProtos.SkillCD[] @技能CD集合

---@class RoleProtos.SkillCD
---@field key number @技能 id
---@field endTime number @cd结束时间

---@class RoleProtos.FirstChargeViewRes
---@field count number @充值数量
---@field day number @天数
---@field receiveDay number[] @已领取的天数

---@class RoleProtos.FirstRechargeViewReq

---@class RoleProtos.FirstRechargeViewRes
---@field rechargeCount number @充值数
---@field receiveAmount number[] @ 已领取的选项
---@field id number @开服首充活动id

---@class RoleProtos.ReceiveFirstChargeReq
---@field day number @天数

---@class RoleProtos.SponsorViewRes
---@field activeId number @已激活赞助数，0表示一个都没有激活
---@field displayId number[] @ 显示的赞助id

---@class RoleProtos.ActiveSponsorReq
---@field activeId number 

---@class RoleProtos.RechargeDailyViewRes
---@field dailyDay number @累计充值天数
---@field alreadyId number[] @已领取的id
---@field id number @开服首充活动id

---@class RoleProtos.ReceiveRechargeDailyReq
---@field receiveId number @领取累计充值表的id
---@field amount number @领取选项

---@class RoleProtos.ReceiveFirstRechargeReq
---@field id number @开服首充活动id
---@field amount number @领取选项

---@class RoleProtos.FirstRechargeOpenStateRes
---@field isOpen boolean 

---@class RoleProtos.FirstRechargeReq
---@field firstChargeRMB number 
---@field actId number 

---@class RoleProtos.UnlockNewMapRes
---@field flag boolean @true:玩家在挂机点升级后，若解锁新地图会提示

---@class RoleProtos.ChangeNameReq
---@field changeName string 
---@field index number 

---@class RoleProtos.LimitTotalRechargeViewRes
---@field count number @充值数量
---@field receivedOrder number[] @已领取参数
---@field endTime number @结束时间

---@class RoleProtos.ResRoleAccumulatedRecharge
---@field accumulatedRecharge number @角色累计充值金额
---@field alreadyPurchasedVipGiftBag RoleProtos.BuyVipGiftBag[] @ 已经购买的vip礼包
---@field accumulatedRechargeLogs number[] @充值日志

---@class RoleProtos.ReceiveLimitTotalRechargeReq
---@field order number @领取参数

---@class RoleProtos.MonthlyCardViewRes
---@field plainCardEndTime number @畅想月卡结束时间
---@field seniorCardEndTime number @尊享月卡结束时间
---@field plainIsReceive boolean @畅想月卡是否可以领取
---@field seniorIsReceive boolean @尊享月卡是否可以领取

---@class RoleProtos.ReceiveMonthlyCardReq
---@field monthlyCardId number @1畅想月卡 2尊享月卡

---@class RoleProtos.ReceiveMonthlyCardRes
---@field itemList CommonProtos.Item[] @领取道具
---@field type number @激活类型 1畅销月卡 2尊享月卡 3组合月卡

---@class RoleProtos.AlsoFirstRecharge
---@field alsoFirstRecharge boolean 

---@class RoleProtos.RoleBasicAttrRes
---@field basicAttr CommonProtos.FightAttribute[] @角色基础属性模块的所有属性

---@class RoleProtos.RoleDarkRoomInfoRes
---@field unLockTime number @小黑屋结束时间
---@field lastCheatTime number @上次违规时间
---@field type number @违规类型
---@field cheatCount number @违规次数
---@field lockCount number @进小黑屋次数
---@field reason string @违规原因

