--工具自动生成
---@class DupBravetestProtos.BraveTestPanelRes
---@field activityId number @ 所属活动id
---@field level number @层数
---@field special number[] @已领取特殊奖励LEVEL_ID
---@field flag number @flag客戶端用
---@field isMaxLv number @ 副本已完成最高层级

---@class DupBravetestProtos.QuickHangUpPanelRes
---@field remainCount number @剩余次数

---@class DupBravetestProtos.BraveChallengeResult
---@field result boolean @是否挑战成功
---@field leftTime number @剩余时间 秒

---@class DupBravetestProtos.BraveTestTaskRecord
---@field waveNumber number @当前波束
---@field monsterNumber number @当前剩余怪物数量

---@class DupBravetestProtos.SpecialRewardReq
---@field levelId number @领取关卡数

---@class DupBravetestProtos.NewFloorRes
---@field floor number @解锁的最新层级

---@class DupBravetestProtos.HangUpIncomeReq
---@field actId number @活动id

---@class DupBravetestProtos.HangUpIncomeRes
---@field startTime number @开始时间
---@field freeCount number @免费次数
---@field reward DupBravetestProtos.Reward[] @挂机奖励

---@class DupBravetestProtos.Reward
---@field itemCfg number @itemCfg
---@field count number @数量

---@class DupBravetestProtos.MatchBraveTestMap
---@field actId number 

---@class DupBravetestProtos.FastHangUpRes
---@field isOk boolean 

---@class DupBravetestProtos.ReceiveRewardHangUpRes
---@field reward DupBravetestProtos.Reward[] @挂机奖励
---@field isOk boolean 

---@class DupBravetestProtos.OnHookReq
---@field id number @cfg_brave_test_map表的ID
---@field op number @0开始，1结束

---@class DupBravetestProtos.OnHookRes
---@field id number @cfg_brave_test_map表的ID
---@field op number @0开始，1结束

---@class DupBravetestProtos.FastHangUpReward
---@field item CommonProtos.Item[] 

---@class DupBravetestProtos.GetBraveTestInfoReq
---@field flag number @客户端flag需求

