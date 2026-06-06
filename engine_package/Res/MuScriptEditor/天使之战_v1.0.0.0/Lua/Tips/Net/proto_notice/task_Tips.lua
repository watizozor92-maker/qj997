--工具自动生成
---@class TaskProtos.SendAllTaskRes
---@field taskRecord TaskProtos.TaskRecord[] @ 当前任务列表
---@field complatedTaskIds number[] @ 已完成的任务列表

---@class TaskProtos.SendTaskInfoReq
---@field taskType number 

---@class TaskProtos.RoleTaskChangeRes
---@field TaskInfo TaskProtos.TaskInfo[] 

---@class TaskProtos.TaskInfo
---@field taskId number @仅用于删除任务
---@field records TaskProtos.TaskRecord @修改的任务

---@class TaskProtos.AcceptTaskReq
---@field taskId number 

---@class TaskProtos.checkAcceptTaskRes
---@field taskId number 
---@field canAccept boolean @是否可以领取 T: 可以领取 F:不可领取

---@class TaskProtos.GiveUpTaskReq
---@field taskId number 

---@class TaskProtos.SubmitTaskReq
---@field taskId number 
---@field multiple number @多倍领取 默认传1

---@class TaskProtos.TaskRewardRes
---@field item CommonProtos.Item[] @奖励的物品
---@field multiple number @多倍领取 默认传1

---@class TaskProtos.TaskRecord
---@field taskId number @任务ID
---@field taskGoalRecord TaskProtos.TaskGoalRecord[] @任务目标
---@field state number @任务状态 1:已接受 2：已完成 3:已提交 4:已放弃
---@field acceptTime number @接取时间
---@field param string @扩展
---@field boxReward CommonProtos.Item[] @道具组奖励

---@class TaskProtos.TaskGoalRecord
---@field goalId number @任务目标id
---@field goalType number @任务目标类型
---@field count number @当前完成进度
---@field maxCount number @总进度
---@field param number @目标扩展参数 - 可无意义
---@field isChange boolean @任务目标发生变化

---@class TaskProtos.clickTask
---@field taskId number @任务ID

---@class TaskProtos.EffectRecord
---@field cfgId number @任务ID
---@field state number @任务状态 1:已接受 2：已完成 3:已提交 4:已放弃
---@field acceptTime number @接取时间
---@field param1 string @扩展
---@field param2 string @扩展
---@field param3 string @扩展

---@class TaskProtos.EffectInfo
---@field id number @仅用于删除任务
---@field records TaskProtos.EffectRecord @修改的任务

---@class TaskProtos.RoleEffectChangeRes
---@field info TaskProtos.EffectInfo[] 

---@class TaskProtos.AchievementInfo
---@field battleStratumId number @战阶ID 
---@field taskinfo TaskProtos.AchievementTaskInfo[] @成就任务

---@class TaskProtos.AchievementChange
---@field taskInfo TaskProtos.AchievementTaskInfo[] @任务详情

---@class TaskProtos.AchievementTaskInfo
---@field taskId number @任务ID
---@field taskGoalRecord TaskProtos.TaskGoalRecord @任务目标

---@class TaskProtos.AchievementId
---@field id number @任务ID

---@class TaskProtos.UpBattleStratum
---@field id number @当前阶数
---@field result boolean @升级结果

---@class TaskProtos.ResBossFistKillPanel
---@field FirstKillinfo TaskProtos.BossFistKillInfo[] 

---@class TaskProtos.BossFistKillInfo
---@field bossId number @ 怪物ID
---@field bossType number @ Boss类型
---@field info TaskProtos.FirstKillerInfo[] @ 全服首杀玩家
---@field killTime number @ 首杀完成时间-毫秒
---@field reliveTime number @ 目标复活时间-毫秒
---@field redPacket number @ 0:不可领取 1:可领取 2:已领取
---@field personalReward number @ 0:不可领取 1:可领取 2:已领取

---@class TaskProtos.FirstKillerInfo
---@field rid number 
---@field career number 
---@field playerName string 

---@class TaskProtos.GetNewAreaRankBossReward
---@field mid number @ 怪物ID
---@field monType number @Boss类型
---@field type number @ 奖励类型 1:个人奖励 2:全服奖励 3:红包奖励

---@class TaskProtos.ReqRankInfo
---@field type number @排行榜类型

---@class TaskProtos.ResRankInfo
---@field type number @ 排行榜类型
---@field value number @ 值
---@field myRank number @ 我的排名
---@field rank TaskProtos.NewAreaRank[] 

---@class TaskProtos.NewAreaRank
---@field rid number 
---@field career number 
---@field name string 
---@field rankNum number @ 排行
---@field value number @ 值

---@class TaskProtos.ReqGetPersonalReward
---@field index number @ id

---@class TaskProtos.NewAreaRankRedPoint
---@field monsters TaskProtos.NewareaRankBoss[] @ 未领取的怪物信息
---@field rankValue TaskProtos.NewArearankValue[] @ 排行榜值
---@field offerReward TaskProtos.NewarearankOfferReward @ boss悬赏

---@class TaskProtos.NewarearankOfferReward
---@field cfgId number[] @ 未领取的配置ID 
---@field group number[] @ 未领取的组ID

---@class TaskProtos.NewareaRankBoss
---@field monsterId number 
---@field monsterType number 

---@class TaskProtos.NewArearankValue
---@field type number @ 活动类型
---@field value number @ 页签值
---@field rewardIds number[] @已领取奖励的ID

---@class TaskProtos.GetPersonalReward
---@field personalId number @ 个人奖励表ID

---@class TaskProtos.KingRoadTaskInfo
---@field taskChapters TaskProtos.KingRoadTaskChapter[] @ 任务章节
---@field ownChapterId number @当前所在章节

---@class TaskProtos.KingRoadTaskChapter
---@field id number 
---@field state number @-1未解锁 0未完成 1可领取 2 已完成
---@field kingRoadTaskRecords TaskProtos.KingRoadTaskRecord[] @任务记录

---@class TaskProtos.KingRoadChapterUpdate
---@field kingRoadTaskChapter TaskProtos.KingRoadTaskChapter 
---@field currentChapterId number 

---@class TaskProtos.KingRoadTaskRecord
---@field taskId number @任务ID
---@field taskGoalRecord TaskProtos.TaskGoalRecord @任务目标
---@field state number @任务状态 0已完成 1未完成 2未接受

---@class TaskProtos.ReqKingRoadAward
---@field chapterId number 
---@field taskId number @ 领取章节奖励时不传此值

---@class TaskProtos.ResOfferRewardPanle
---@field timesInfo TaskProtos.OfferFinishTimes[] @ 已经完成的次数
---@field receiveRewardId number[] @ 已经领取过的奖励cfgId
---@field receiveRewardGroup number[] @ 已经领取过的组奖励

---@class TaskProtos.OfferFinishTimes
---@field cfgId number 
---@field count number 

---@class TaskProtos.GetOfferReward
---@field type number @ 类型 1：单个奖励，2：组奖励
---@field index number @ 根据类型分别代表 cfgId/group

