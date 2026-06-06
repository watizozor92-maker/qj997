--工具自动生成
---@class GuildSiegeProto.GuildSiegeInfoRes
---@field activityId number @活动id
---@field lastWeekRank GuildSiegeProto.SiegeRank @上周排名
---@field grade number @本次评级 1：甲 2：乙 3：丙 4：丁（0表示无）
---@field continuousWinCount number @连胜次数
---@field openTime number @活动的开启时间（毫秒时间戳）
---@field breakWinCount number @终结连胜次数

---@class GuildSiegeProto.SiegeRank
---@field grade number @评级 1：甲 2：乙 3：丙 4：丁（0表示无）
---@field rankNo number @排名的名次（0表示无）

---@class GuildSiegeProto.SiegeStatisticalRes
---@field record GuildSiegeProto.SiegeStatistical[] 

---@class GuildSiegeProto.SiegeStatistical
---@field rankNo number @名次
---@field unionName string @战盟名称
---@field totalScore number @积分
---@field siegePlayerStatistical GuildSiegeProto.SiegePlayerStatistical[] @玩家信息统计
---@field totalHurt number @战盟对王座的总伤害

---@class GuildSiegeProto.SiegePlayerStatistical
---@field rankNo number @名次
---@field playerName string @玩家名称
---@field score number @玩家积分
---@field occupyCount number @攻占建筑数量
---@field repairCount number @修复数量
---@field killEnemyNum number @击杀敌对阵营数量
---@field rid number 
---@field career CommonProtos.Career @ 职业

---@class GuildSiegeProto.AgainstTableRes
---@field againstRecord GuildSiegeProto.AgainstRecord[] 
---@field unionRankNo number @我的战盟总战力排行

---@class GuildSiegeProto.AgainstRecord
---@field grade number @评级 1：甲 2：乙 3：丙 4：丁（0表示无）
---@field unionRecord GuildSiegeProto.AgainstUnionRecord[] @战盟列表

---@class GuildSiegeProto.AgainstUnionRecord
---@field unionId number @战盟id
---@field unionArmband number @战盟标志
---@field unionName string @战盟名称
---@field unionFight number @战盟总战力

---@class GuildSiegeProto.RepAirStatueReq
---@field airStatue number @1.外门雕像  3.中门雕像  5.内门雕像

---@class GuildSiegeProto.RepAirStatueRes
---@field startTime number @开始时间
---@field endTime number @结束时间

---@class GuildSiegeProto.WarGodListRes
---@field warGodList GuildSiegeProto.WarGodList[] 
---@field endView GuildSiegeProto.SendSiegeEndViewRes 

---@class GuildSiegeProto.WarGodList
---@field rid number 
---@field personalScore number @个人总积分
---@field rankInfo GuildSiegeProto.RankInfo[] 
---@field career number 
---@field name string 
---@field position number 

---@class GuildSiegeProto.RankInfo
---@field type number @1击杀敌对阵营数量 2摧毁建筑数 3修复雕像数 4变身战车获得积分
---@field rank number 
---@field score number 

---@class GuildSiegeProto.WarGodPraiseReq
---@field rid number 

---@class GuildSiegeProto.WarGodPraiseRes
---@field warGodPraise GuildSiegeProto.WarGodPraise 

---@class GuildSiegeProto.WarGodPraise
---@field rid number 
---@field isPraise boolean @是否点赞

---@class GuildSiegeProto.SendSiegeEndViewRes
---@field rank number @排名
---@field score number @战盟总积分
---@field awardInfo GuildSiegeProto.AwardInfo[] @道具id
---@field group number @1甲 2乙 3丙 4丁

---@class GuildSiegeProto.AwardInfo
---@field cfgId number @itemCfgId
---@field count number @数量
---@field type number @1.普通掉落 2.稀有掉落 3.连胜掉落 4.终结连胜掉落

---@class GuildSiegeProto.UseGoHomeSkillRes
---@field cdMills number @ cd时间（毫秒）

---@class GuildSiegeProto.BuildingConditionRes
---@field buildingInfo GuildSiegeProto.BuildingCondition[] 
---@field worldLevel number @cfg_guild_siegebuild  表Id字段

---@class GuildSiegeProto.UpdateBuilding
---@field buildingInfo GuildSiegeProto.BuildingCondition[] 

---@class GuildSiegeProto.BuildingCondition
---@field type number @1.外雕像 2.外门 3.中雕像 4.中城门 5.内雕像 6 .内城门 7. 王座
---@field monsterId number 
---@field buildingState number @建筑状态 1. 无敌  2.普通 3.被摧毁
---@field Hp number @当前血量
---@field maxHp number @最大血量

---@class GuildSiegeProto.GuildSiegeDataRes
---@field siegeStatistical GuildSiegeProto.SiegeStatisticalRes 

---@class GuildSiegeProto.ThroneHarmDataRes
---@field harmDataInfo GuildSiegeProto.HarmDataInfo[] 

---@class GuildSiegeProto.HarmDataInfo
---@field unionName string 
---@field Damagevalue number @伤害值

---@class GuildSiegeProto.CampSwapRes
---@field campInfo GuildSiegeProto.UnionCampInfo[] 

---@class GuildSiegeProto.UnionCampInfo
---@field unionId number 
---@field unionName string 
---@field camp number @ 1 攻城方 2防守方

---@class GuildSiegeProto.SiegeStatisticsRes
---@field record GuildSiegeProto.SiegeStatistical[] 

---@class GuildSiegeProto.TradeLineEndTimeRes
---@field endTime number 

---@class GuildSiegeProto.GuardTimeMessageRes
---@field time number 

---@class GuildSiegeProto.GuildSiegeAnnounceRes
---@field openTime number 
---@field isFirst boolean 

