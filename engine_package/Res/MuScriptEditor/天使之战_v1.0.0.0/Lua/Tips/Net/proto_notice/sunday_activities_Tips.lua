--工具自动生成
---@class SundayActivityProto.GoldArmyTaskInfo
---@field goldArmyTask SundayActivityProto.GoldArmyTask[] 

---@class SundayActivityProto.GoldArmyTask
---@field taskId number 
---@field taskGoalRecord TaskProtos.TaskGoalRecord 
---@field state number @状态 0已完成 1未完成 2未领取

---@class SundayActivityProto.ReceiveGoldArmyRewardReq
---@field id number 

---@class SundayActivityProto.SundayGiftPacksMenu
---@field giftPackDetail SundayActivityProto.GiftPackDetail[] 

---@class SundayActivityProto.GiftPackDetail
---@field id number 
---@field leftBuyCount number @ 剩余购买次数

---@class SundayActivityProto.BuySundayGiftPackReq
---@field id number @礼包id

