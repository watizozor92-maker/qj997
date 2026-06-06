--工具自动生成
---@class DupSiegeProtos.SiegePanel
---@field occupyUnion string @ 占领战盟
---@field unionLeaders UserProtos.RoleInfo[] @ 战盟盟主列表(包括盟主、副盟主)
---@field openTime number @ 攻城开启时间
---@field siegeId number @攻城战Id

---@class DupSiegeProtos.RegistrationInfoRes
---@field unionRecords DupSiegeProtos.UnionRecord[] 
---@field itemCfgId number @ 报名所需道具
---@field count number @数量
---@field isSignUp boolean @是否报名

---@class DupSiegeProtos.UnionRecord
---@field unionName string @ 战盟名
---@field itemCfgId number @ 缴纳道具
---@field count number @ 缴纳道具数量

---@class DupSiegeProtos.RegisterSiegeReq
---@field count number @ 缴纳道具数量
---@field siegeId number @攻城战Id

---@class DupSiegeProtos.MercenaryList
---@field mercenaryInfos DupSiegeProtos.MercenaryInfo[] 

---@class DupSiegeProtos.MercenaryInfo
---@field monsterCfgId number @ 部署的怪物id(取cfg_monster表id)
---@field count number @ 购买的数量
---@field x number @ x坐标
---@field y number @ y坐标

---@class DupSiegeProtos.DeployMercenaryReq
---@field mercenaryInfos DupSiegeProtos.MercenaryInfo[] 

---@class DupSiegeProtos.SiegeScoreRankUpdateRes
---@field occupyUnion string @当前占领战盟
---@field unionRank number @战盟排名
---@field selfRank number @我的排名
---@field score number @我的积分

---@class DupSiegeProtos.OccupyOrganTimeRes
---@field startTime number @开始时间
---@field endTime number @结束时间
---@field rate number @进度条百分比

---@class DupSiegeProtos.OccupyOrganPanelReq
---@field organId number @1 机关一  2 机关二

---@class DupSiegeProtos.OccupyOrganPanelRes
---@field occupyName string @占领机关名称

---@class DupSiegeProtos.SiegeIdReq
---@field siegeId number @攻城战Id

