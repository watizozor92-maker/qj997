--工具自动生成
---@class SiegeProtos.SiegePanel
---@field occupyUnion string @ 占领战盟
---@field unionLeaders UserProtos.RoleInfo[] @ 战盟盟主列表(包括盟主、副盟主)
---@field openTime number @ 攻城开启时间

---@class SiegeProtos.RegistrationInfoRes
---@field unionRecords SiegeProtos.UnionRecord[] 
---@field itemCfgId number @ 报名所需道具

---@class SiegeProtos.UnionRecord
---@field unionName string @ 战盟名
---@field itemCfgId number @ 缴纳道具
---@field count number @ 缴纳道具数量

---@class SiegeProtos.RegisterSiegeReq
---@field count number @ 缴纳道具数量

---@class SiegeProtos.MercenaryList
---@field mercenaryInfos SiegeProtos.MercenaryInfo[] 

---@class SiegeProtos.MercenaryInfo
---@field monsterCfgId number @ 部署的怪物id(取cfg_monster表id)
---@field x number @ x坐标
---@field y number @ y坐标

---@class SiegeProtos.DeployMercenaryReq
---@field mercenaryInfos SiegeProtos.MercenaryInfo[] 

