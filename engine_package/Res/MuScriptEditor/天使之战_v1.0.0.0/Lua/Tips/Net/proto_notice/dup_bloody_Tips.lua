--工具自动生成
---@class DupBloodyProtos.DupWeaponDrop
---@field rid number @ 持有者 (没有默认0)
---@field x number @ 掉落X坐标
---@field y number @ 掉落Y坐标

---@class DupBloodyProtos.PickWeapon
---@field rid number @ 道具捡起者ID

---@class DupBloodyProtos.ReqGiveNPCWeapon
---@field rid number @ 交还武器人ID

---@class DupBloodyProtos.ResGiveNPCWeapon
---@field rid number @ rid
---@field hasWeapon boolean @ T 有武器， F 没有武器
---@field phase number @当前阶段 6就可以完成任务了

---@class DupBloodyProtos.BloodProgress
---@field phase number @ 副本当前阶段
---@field targetId number @ 目标ID
---@field count number @ 当前进度
---@field maxCount number @ 任务目标数量
---@field itemList CommonProtos.Item[] @ 完成任务奖励

---@class DupBloodyProtos.BloodRateInfo
---@field phase number @ 副本当前阶段
---@field nextTimeMS number @本阶段结束的豪秒数(时间戳)
---@field rate string @评级

---@class DupBloodyProtos.dupMapBudingMonster
---@field gateStage number @ 可以攻击城门的阶段
---@field gateId number @ 城门ID
---@field sarcophagusStage number @ 可以攻击石棺的阶段
---@field sarcophagusId number @水晶石棺ID

---@class DupBloodyProtos.ClearBurialReq
---@field activityId number @活动id

---@class DupBloodyProtos.ClearBurialRes
---@field canClear boolean 
---@field count number 
---@field itemCfgId number 

---@class DupBloodyProtos.ClearTimeRes
---@field count number 
---@field itemCfgId number 
---@field activityId number 
---@field flag number 

---@class DupBloodyProtos.SpoilsOfWarInfo
---@field item DupBloodyProtos.SpoilsItem[] 

---@class DupBloodyProtos.SpoilsItem
---@field itemId number 
---@field count number 

