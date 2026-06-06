--工具自动生成
---@class DupGardBossProtos.GardBossInfoReq
---@field activityId number @ 活动id

---@class DupGardBossProtos.GardBossRankItem
---@field rank number @排名
---@field name string @名称(战盟排行存放战盟名称，个人排行存放玩家昵称)
---@field hurt number @伤害值

---@class DupGardBossProtos.GardBossInfoRes
---@field unionRank DupGardBossProtos.GardBossRankItem[] @战盟排行
---@field playerRank DupGardBossProtos.GardBossRankItem[] @个人排行
---@field selfUnionRank number @通过这个值去unionRank里面找
---@field selfPlayerRank number @通过这个值去playerRank里面找
---@field gardBossCfgId number @cfg_gardBoss表的ID
---@field type number @0：打开界面的时候，1：副本内部
---@field activityId number @活动ID
---@field attrAdditionInfo string @属性加成信息，格式：属性名称#加成的值（是一个具体的数值或者一个百分比），示例：伤害#10%,防御#1000

---@class DupGardBossProtos.EnterGardBossReq
---@field gardBossRuleCfgId number @cfg_gardBossRule表ID

---@class DupGardBossProtos.EnterGardBossRes
---@field gardBossRuleCfgId number @cfg_gardBossRule表ID

---@class DupGardBossProtos.GardBossRewardInfoRes
---@field hurtTotal number @总伤害
---@field rank number @排名
---@field rewards CommonProtos.Item[] @奖励

---@class DupGardBossProtos.GardBossReliveReq
---@field type number @0免费复活，1付费复活

---@class DupGardBossProtos.GardBossPlayerDieRes
---@field playerId number 
---@field mapId number 
---@field gardBossRuleCfgId number 
---@field hurt number @扣除伤害（可能用不到）

