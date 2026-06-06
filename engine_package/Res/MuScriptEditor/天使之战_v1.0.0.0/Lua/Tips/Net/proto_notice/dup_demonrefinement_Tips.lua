--工具自动生成
---@class MoLianZhiDiProto.MLZDPanel
---@field unlockLevel number @ 解锁层数
---@field leftReceiveAwardCount number @ 剩余领奖次数

---@class MoLianZhiDiProto.MLZDPrepareInfo
---@field countDownMillis number @倒计时，单位：毫秒
---@field member MoLianZhiDiProto.MlzdMemberInfo[] 

---@class MoLianZhiDiProto.MlzdMemberInfo
---@field rid number 
---@field name string 
---@field career CommonProtos.Career 
---@field isLeader boolean 
---@field state number @ 0 未准备 1：已准备 2：已拒绝

---@class MoLianZhiDiProto.MLZDPrepareReq
---@field prepare boolean @ true 准备 false 拒绝

---@class MoLianZhiDiProto.EnterMLZDOption
---@field level number 

---@class MoLianZhiDiProto.MLZDDupInfo
---@field dupCfgId number @副本配置id
---@field phase number @阶段
---@field killProgress number @击杀进度
---@field killGoal number @击杀目标

---@class MoLianZhiDiProto.MLZDFinishPanel
---@field dupCfgId number 
---@field killCount number @击杀怪物数量
---@field freeReceive boolean @ 是否可以免费领取

---@class MoLianZhiDiProto.MlzdExitCountDown
---@field countDownMillis number @ 倒计时毫秒

