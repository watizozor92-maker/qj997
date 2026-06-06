--工具自动生成
---@class EfficiencyProtos.ReceiveEfficiencyRewardReq
---@field id number @cfg_efficiency表的主键id，表示要领取的主键奖励

---@class EfficiencyProtos.EfficiencyRewardInfoRes
---@field id number[] @cfg_efficiency表的主键id，表示已经领取过的主键奖励

---@class EfficiencyProtos.EfficiencyMagnificationRes
---@field efficiencyMagnificationInfos EfficiencyProtos.EfficiencyMagnificationInfo[] 

---@class EfficiencyProtos.EfficiencyMagnificationInfo
---@field id number @cfg_efficiency表的主键id
---@field level number @cfg_efficiency_promote表中的条件等级

---@class EfficiencyProtos.EfficiencyBuyReq
---@field id number @cfg_efficiency的主键id，表示要购买的奇迹币收益

---@class EfficiencyProtos.EfficiencyBuyInfoRes
---@field id number[] @cfg_efficiency的主键id，表示已经购买的奇迹币收益

---@class EfficiencyProtos.ExperiencePotionRes
---@field endTime number @经验药水的过期时间
---@field isFirst boolean @经验药水是否为第一次弹出
---@field cfgId number @目前经验药水的cfgId

---@class EfficiencyProtos.EfficiencyBuyRateRes
---@field id number[] @效率系统--爆率提升--已经购买的cfg

