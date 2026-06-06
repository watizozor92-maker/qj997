--工具自动生成
---@class ActivityProtos.ActivityListRes
---@field activityInfos ActivityProtos.ActivityInfo[] 

---@class ActivityProtos.ReceiveAwardReq
---@field multiple number @奖励倍数

---@class ActivityProtos.ActivityStatus
---@field activityId number 
---@field leftCount number 
---@field leftCdMills number @剩余cd时间（单位：毫秒）
---@field flag number 
---@field close boolean @true:活动关闭，默认打开

---@class ActivityProtos.ActivityInfo
---@field activityId number 
---@field beginTime number @ 开始时间
---@field endTime number @ 结束时间
---@field isOpen boolean @ 开启状态

---@class ActivityProtos.EnterActivityReq
---@field activityId number 
---@field flag number 

---@class ActivityProtos.ResCanEnterActivity
---@field activityId number 

---@class ActivityProtos.EnterActivitySecOk
---@field activityId number 

---@class ActivityProtos.ResEnterPriDupStatus
---@field activityId number @ 活动id
---@field enterStatus number @ 1：成功  0：失败

---@class ActivityProtos.EnterActivityByNpcReq
---@field activityId number[] 

---@class ActivityProtos.DupOptionListRes
---@field dupOptionList ActivityProtos.DupOption[] 

---@class ActivityProtos.EnterDupByRecruitReq
---@field recruiterRid number @ 招募者rid

---@class ActivityProtos.DupOption
---@field activityId number @ 活动id
---@field dupStage number @ 副本阶数

---@class ActivityProtos.ReqEnterDuplicate
---@field activityId number 
---@field duptype number 

---@class ActivityProtos.EnterDupResultRes
---@field dupOption ActivityProtos.DupOption 
---@field conditionPass boolean @ 条件是否通过
---@field enterCountDown number @ 进入副本的倒计时时间,单位毫秒

---@class ActivityProtos.DupStateRes
---@field dupOption ActivityProtos.DupOption 
---@field dupState number @ 副本状态 1:准备阶段 2:战斗阶段 3:结束阶段 4:活动开始倒计时阶段
---@field countDownTime number @ 倒计时时间(单位毫秒)
---@field totalDownTime number @ 副本结束倒计时(单位毫秒)

---@class ActivityProtos.QuitDupSuccess
---@field actId number @ 活动ID

---@class ActivityProtos.DupPointRankUpdateRes
---@field dupMembers ActivityProtos.DupRankMember[] @ 积分排名

---@class ActivityProtos.DupRankMember
---@field rankNo number @ 排名
---@field name string @ 名字
---@field score number @ 积分

---@class ActivityProtos.DupFinishRes
---@field totalScore number @ 总积分
---@field rank number @ 排名
---@field totalExp number @ 获得的总经验值
---@field scoreAward ActivityProtos.DupAward[] @ 积分奖励
---@field rankAware ActivityProtos.DupAward[] @ 排名奖励
---@field autoReceiveTime number @ 自动领取时间
---@field activityType number @ 活动类型 0:恶魔广场 1:血色城堡
---@field maxExpRecord number @ 最大经验记录
---@field dps number @ 通关秒伤
---@field killCount number @ 总杀怪数量
---@field okTotalTimeS number @过关总时间（秒)
---@field rateAward ActivityProtos.DupAward[] @ 评分奖励
---@field activityId number @活动id

---@class ActivityProtos.DupAward
---@field itemCfgId number @ 道具configId
---@field count number @ 数量

---@class ActivityProtos.EnterDupLeftCountRes
---@field activityId number 
---@field leftCount number 

---@class ActivityProtos.DailyActivityTask
---@field cfgId number 
---@field count number @活动剩余次数
---@field vipAddTimes number @VIP添加活动次数

---@class ActivityProtos.ResDailyActivityTask
---@field activityValue number 
---@field task ActivityProtos.DailyActivityTask[] 
---@field potionsTimes number @VIP添加药水次数
---@field leftActivityValue number @剩余活跃度

---@class ActivityProtos.ReqGetRewardBox
---@field cfgId number 

---@class ActivityProtos.ResSendRewardBox
---@field rewardBox ActivityProtos.RewardBox[] 

---@class ActivityProtos.RewardBox
---@field cfgId number 
---@field status number @0-不可领取  1-可领取 2-已领取 

---@class ActivityProtos.ActivityChangeRes
---@field type number @ 1.RoleActivity 2.MapACtivity
---@field roleActivity ActivityProtos.RoleActivityInfo @每日活动
---@field mapActivity ActivityProtos.MapActivitiyInfo @限时活动

---@class ActivityProtos.RoleActivityInfo
---@field activityValue number @活跃值
---@field task ActivityProtos.DailyActivityTask[] @任务信息
---@field boxes ActivityProtos.RewardBox[] @奖励宝箱
---@field vipAddTimes number @VIP添加活动次数
---@field potionsTimes number @VIP添加药水次数
---@field leftActivityValue number @剩余活跃度
---@field weekValue number @周活跃度

---@class ActivityProtos.MapActivitiyInfo
---@field mapactivitys ActivityProtos.MapActivity[] 

---@class ActivityProtos.MapActivity
---@field actId number 
---@field detail ActivityProtos.MapACtivityDetail 

---@class ActivityProtos.MapACtivityDetail
---@field cfgId number 
---@field status number @ 0-活动关闭 1-活动开始
---@field endTime number @ 结束时间(毫秒)
---@field nowTime number @ 服务器当前时间(毫秒)
---@field dailyTaskStatus number @日常限时活动状态：1.未开启，2.进行中，3.已结束
---@field nextOpenTime number @ 活动下次开启时间 0为不再开启
---@field todayWillOpen boolean @ 今天是否开启活动

---@class ActivityProtos.ReqActivityTimes
---@field type number @1.添加活动次数 2.添加兑换次数
---@field actId number @活动id

---@class ActivityProtos.GoldTaskRes
---@field finishTaskCount number @ 已完成任务数
---@field freeFlushLeftTimes number @免费刷新剩余次数
---@field payFlushLeftTimes number @付费刷新剩余次数
---@field taskGold ActivityProtos.GoldTask[] @ 任务列表
---@field maxTaskCount number @ 最大刷新次数

---@class ActivityProtos.GoldTask
---@field id number @任务id
---@field starLv number @星级
---@field finishCount number @完成次数
---@field state number @0：未领取 1：进行中 2：已完成

---@class ActivityProtos.GoldTaskId
---@field taskId number 

---@class ActivityProtos.DevilSquareKillCountUpdateRes
---@field killCount number @ 击杀数
---@field exp number @ 结算经验

---@class ActivityProtos.BloodyCastleDPSUpdateRes
---@field dps number @ 秒伤

---@class ActivityProtos.ActivityStartRemindRes
---@field activityId number @活动的配置ID
---@field startTime number @活动开始的时间（毫秒时间戳格式）
---@field gardBossCfgId number @gardBoss配置表的ID

---@class ActivityProtos.ActivityRetrievePanel
---@field info ActivityProtos.ActivityRetrieveInfo[] 
---@field potionsTimes number @ 药水兑换次数
---@field leftActivityValue number @ 剩余的昨日活跃度

---@class ActivityProtos.ActivityRetrieveInfo
---@field taskId number @ 活动ID
---@field useCount number @ 当前找回次数(已找回次数)
---@field maxCount number @ 找回上限
---@field lastActivityCount number @ 可找回的活跃度

---@class ActivityProtos.ReqRetrieveActivityLeftCount
---@field recoveryId number @ 找回表ID

---@class ActivityProtos.LastActivityInfo
---@field lastActivityId number @上次活动Id

---@class ActivityProtos.ActivityAnnounceRes
---@field announce ActivityProtos.Announce[] 

---@class ActivityProtos.Announce
---@field activityId number 
---@field time number 

---@class ActivityProtos.ReqDuplicateLeftCount
---@field actId number 

---@class ActivityProtos.ResDuplicateLeftCount
---@field actId number 
---@field count number 

