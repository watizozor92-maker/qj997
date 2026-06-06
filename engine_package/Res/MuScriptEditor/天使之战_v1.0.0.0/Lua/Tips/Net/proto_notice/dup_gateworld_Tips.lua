--工具自动生成
---@class GateWorldProtos.GateWroldInfo
---@field floor number @层数
---@field conditionsIndex number[] @完成条件的下标，空表示未完成

---@class GateWorldProtos.FloorInfoReq
---@field actId number @活动ID
---@field floor number @层数

---@class GateWorldProtos.FloorPanelInfoRes
---@field unlockFloor number @已解锁的层数
---@field infos GateWorldProtos.GateWroldInfo[] @各层信息
---@field leftCount number @副本剩余挑战次数
---@field entryway number @入口数量
---@field flag number 

---@class GateWorldProtos.GateWorldNpcPoint
---@field npcId number @npc唯一ID
---@field cfgId number @地图id
---@field line number @地图分线
---@field x number 
---@field y number 
---@field floor number @活动层数

---@class GateWorldProtos.ChallengeResult
---@field isSuccess boolean @T:挑战成功
---@field leftTime number @自动退出倒计时 单位秒
---@field star number @ 星级
---@field item CommonProtos.Item[] @ 奖励道具

---@class GateWorldProtos.FloorEntryWay
---@field floor number @副本层数
---@field entryway number @入口数量

---@class GateWorldProtos.ChallengeNPC
---@field actId number @活动ID
---@field floor number @活动层数
---@field npcId number @npc唯一ID

---@class GateWorldProtos.AllNpcPoint
---@field npcPoint GateWorldProtos.GateWorldNpcPoint[] 

---@class GateWorldProtos.GateWorldTask
---@field rid number 
---@field count number @ 当前任务进度
---@field maxCount number @ 总进度
---@field conditionsIndex number[] @ 已完成的条件

---@class GateWorldProtos.BuyCountReq
---@field activityId number 
---@field index number 

---@class GateWorldProtos.BuyCountRes
---@field count number 

