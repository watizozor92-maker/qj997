--工具自动生成
---@class DupCurrencyBossProtos.EnterCurrencyBossReq
---@field currencyBossCfgId number @ 通用boss配置表ID

---@class DupCurrencyBossProtos.EnterCurrencyBossRes
---@field currencyBossCfgId number @ 通用boss配置表ID

---@class DupCurrencyBossProtos.CurrencyBossInfoReq
---@field activityId number @ 活动id

---@class DupCurrencyBossProtos.BossItem
---@field id number @cfg_currencyBoss表的id
---@field name string @名称
---@field level number @级别
---@field hp number @血量
---@field isDead boolean @是否死亡
---@field reliveTime number @复活的时间，如果未死亡则为0
---@field monsterCfgId number @怪物配置表ID
---@field isBoss boolean @是否是BOSS
---@field remains number @剩余次数
---@field isClose boolean @是否结束
---@field recoverCount number @当前已经使用掉的恢复次数
---@field nextRecoverCountTime number @下次可以恢复次数的时间戳(单位毫秒)，如果无次数可以恢复，则为0
---@field group number 
---@field isReliveRemind boolean @是否复活提醒
---@field x number @boss的X坐标
---@field y number @boss的Y坐标
---@field hasAttended boolean @是否参与过该副本

---@class DupCurrencyBossProtos.CurrencyBossInfoRes
---@field bosses DupCurrencyBossProtos.BossItem[] @boss信息，

---@class DupCurrencyBossProtos.CurrencyBossRankListReq

---@class DupCurrencyBossProtos.RankItem
---@field rid number @角色ID
---@field name string @角色名称
---@field rank number @排名
---@field hurt number @伤害
---@field teams number[] @队伍成员

---@class DupCurrencyBossProtos.CurrencyBossRankListRes
---@field rankList DupCurrencyBossProtos.RankItem[] 
---@field self DupCurrencyBossProtos.RankItem 
---@field monsterId number 
---@field curBossId number 

---@class DupCurrencyBossProtos.CurrencyBossReliveReq
---@field type number @0免费复活，1付费复活

---@class DupCurrencyBossProtos.CurrencyBossRewardListRes
---@field rewards CommonProtos.Item[] @奖励
---@field injuryRankRewards CommonProtos.Item[] @伤害排名奖励
---@field duration number @通关时长（单位毫秒）
---@field starConditionsIndex number @专属BOSS评分，对应startConditions字段中项目的索引
---@field mopUpRemains number @剩余可使用的扫荡次数

---@class DupCurrencyBossProtos.CurrencyBossAddVipFrequencyReq
---@field currencyBossCfgId number @ 通用boss配置表ID

---@class DupCurrencyBossProtos.CurrencyBossReliveRemindReq
---@field currencyBossCfgId number @ 通用boss配置表ID
---@field ok boolean @是或者否

---@class DupCurrencyBossProtos.NoticeItem
---@field currencyBossCfgId number @通用boss配置ID
---@field reliveTime number @复活时间戳，单位毫秒

---@class DupCurrencyBossProtos.CurrencyBossReliveNoticeRes
---@field items DupCurrencyBossProtos.NoticeItem[] 

---@class DupCurrencyBossProtos.CurrencyBossMopUpReq
---@field currencyBossCfgId number @通用boss配置ID

---@class DupCurrencyBossProtos.CurrencyBossDieRes
---@field activityId number @活动id

---@class DupCurrencyBossProtos.GoldBossRankItem
---@field monsterCfgId number @--cfg_monsterid
---@field isDeath boolean @是否死亡
---@field status number @--0待击杀，1进行中，2，复活中(已死亡未复活)
---@field reliveTime number @复活的时间，如果未死亡则为0
---@field rid number @--状态为进行中，伤害第一的角色id
---@field name string @--状态为进行中，伤害第一的角色名字
---@field relivePosX number @死亡后复活位置的X坐标（怪物活着，值为0）
---@field relivePosY number @死亡后复活位置的Y坐标（怪物活着，值为0）
---@field monsterId number @怪物ID

---@class DupCurrencyBossProtos.GoldBossRankListRes
---@field rankList DupCurrencyBossProtos.GoldBossRankItem[] 
---@field self DupCurrencyBossProtos.GoldBossRankItem 

---@class DupCurrencyBossProtos.ScoreChangeRes
---@field starConditionsIndex number @对应startConditions字段中项目的索引

---@class DupCurrencyBossProtos.FieldBossAllInfoReq
---@field id number @页签 1-黄金怪 2-野外BOSS

---@class DupCurrencyBossProtos.FieldBossAllInfoRes
---@field id number @页签
---@field bosses DupCurrencyBossProtos.FieldBossItem[] @ 野外BOSS信息

---@class DupCurrencyBossProtos.FieldBossItem
---@field mapId number 
---@field mapLine number 
---@field posX number 
---@field posY number 
---@field bossNum number @boss数量
---@field cfgId number 

