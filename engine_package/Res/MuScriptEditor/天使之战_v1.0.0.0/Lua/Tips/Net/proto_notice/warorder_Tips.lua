--工具自动生成
---@class WarOrderProtos.AllWarOrderInfo
---@field warOrderInfo WarOrderProtos.OneWarOrderInfo[] @一个战令信息

---@class WarOrderProtos.OneWarOrderInfo
---@field configId number @配置id
---@field level number @等级
---@field exp number @当前经验
---@field openFreeTimeS number @白银开启时间,秒， 没开启默认0
---@field openBuyTimeS number @黄金开启时间,秒， 没开启默认0
---@field dayCanExp number @当天还可以升级的经验
---@field warOrderInfoAward WarOrderProtos.WarOrderInfoAward[] @奖励领取情况
---@field payItem boolean @开通付费战令
---@field payItemTimeS number @开通付费战令的时间，即解锁的时间
---@field openTimeS number @开启的时间， 0为没开启
---@field warTaskGoalRecord WarOrderProtos.WarTaskGoalRecord[] @任务目标数据

---@class WarOrderProtos.WarTaskGoalRecord
---@field warTaskId number @任务id, cfg_waroder_task的id
---@field taskGoalRecord TaskProtos.TaskGoalRecord 
---@field taskStatus number @任务状态  1：接受，2： 完成 3： 领取

---@class WarOrderProtos.UpdateWarTaskGoalRecord
---@field warConfig number @配置id cfg_warOrder
---@field warTaskId number @任务id, cfg_waroder_task的id
---@field taskGoalRecord TaskProtos.TaskGoalRecord 
---@field taskStatus number @任务状态 1：接受，2： 完成 3： 领取

---@class WarOrderProtos.ReqAwardTask
---@field warConfig number @配置id cfg_warOrder
---@field taskConfigId number @配置id cfg_warOrderTask

---@class WarOrderProtos.ResAwardTask
---@field warConfig number @配置id cfg_warOrder
---@field taskConfigId number @配置id cfg_warOrderTask
---@field success boolean 
---@field err number 

---@class WarOrderProtos.WarOrderInfoAward
---@field level number @当前等级
---@field awardFree boolean @免费的奖励是否领取
---@field awardBuy boolean @付费的奖励是否领取	

---@class WarOrderProtos.ReqWarOrderAward
---@field configId number @配置id
---@field level number @等级

---@class WarOrderProtos.ResWarOrderAward
---@field warOrderInfo WarOrderProtos.OneWarOrderInfo @一个战令信息
---@field success boolean @是否成功
---@field err number @失败原因

---@class WarOrderProtos.ReqWarOrderAwardAll
---@field configId number @配置id

---@class WarOrderProtos.ResWarOrderAwardAll
---@field allWarOrderInfo WarOrderProtos.AllWarOrderInfo @一个战令信息
---@field success boolean @是否成功
---@field err number @失败原因

---@class WarOrderProtos.ReqWarOrderUpLevel
---@field configId number @配置id

---@class WarOrderProtos.ResWarOrderUpLevel
---@field warOrderInfo WarOrderProtos.OneWarOrderInfo @一个战令信息
---@field success boolean @是否成功
---@field err number @失败原因

---@class WarOrderProtos.ReqWarOrderExchange
---@field configId number @配置id
---@field ItemCount number @物品数量

---@class WarOrderProtos.ResWarOrderExchange
---@field warOrderInfo WarOrderProtos.OneWarOrderInfo @一个战令信息
---@field success boolean @是否成功
---@field err number @失败原因

