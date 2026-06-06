--工具自动生成
---@class DupWorldBossProtos.WorldBossInfoReq
---@field activityId number @ 活动id

---@class DupWorldBossProtos.WorldBossRankItem
---@field rank number @排名
---@field name string @名称(玩家昵称)
---@field hurt number @伤害值
---@field career CommonProtos.Career @ 职业
---@field set number @性别
---@field appearIdx number[] @装备外观：装备索引
---@field equip MapProtos.Equip[] 
---@field roleId number @角色id
---@field level number @等级
---@field unionId number 
---@field unionName string 
---@field unionPos number 
---@field teamId number 

---@class DupWorldBossProtos.WorldBossInfoRes
---@field rankItem DupWorldBossProtos.WorldBossRankItem[] @排名
---@field selfItem DupWorldBossProtos.WorldBossRankItem @自己的信息

---@class DupWorldBossProtos.WorldBossRewardInfoRes
---@field resultRankItem DupWorldBossProtos.WorldBossRankItem[] @结果
---@field selfResultItem DupWorldBossProtos.WorldBossRankItem @自己的信息

---@class DupWorldBossProtos.LastWorldBossRankInfoRes
---@field rankItem DupWorldBossProtos.WorldBossRankItem[] @排名
---@field selfResultItem DupWorldBossProtos.WorldBossRankItem @自己的信息
---@field fudaiConfigId number @福袋配置id

---@class DupWorldBossProtos.ReqRelive
---@field reliveType number @复活类型

---@class DupWorldBossProtos.ResDupPhaseInfo
---@field enterMapTime number @玩家进入副本时间
---@field begingPhaseTime number @开始阶段的世界

---@class DupWorldBossProtos.buffInfo
---@field type number @ 1: 玩家进入地图buff 2: 福袋生成buff
---@field buffId number 

---@class DupWorldBossProtos.bossHp
---@field hp number @当前血量 
---@field maxHp number @最大血量

---@class DupWorldBossProtos.openBossHp
---@field open boolean @ 1:打开 0：关闭

