--工具自动生成
---@class DupRedFortressTwoProtos.ResWarPhaseInfo
---@field warPhase number @阶段 1初始阶段 2中期阶段  3 决赛阶段
---@field warBeginTime number @开始时间

---@class DupRedFortressTwoProtos.PlayerInfo
---@field id number @玩家id
---@field name string @名称(玩家昵称)
---@field career CommonProtos.Career @ 职业
---@field sex number @性别
---@field fightValue number @战力 

---@class DupRedFortressTwoProtos.ResWarKillInfo
---@field killer DupRedFortressTwoProtos.PlayerInfo @击杀者
---@field beKiller DupRedFortressTwoProtos.PlayerInfo @被杀者

---@class DupRedFortressTwoProtos.ReqScoreRankInfo
---@field activityId number @ 活动id

---@class DupRedFortressTwoProtos.ScoreRankItem
---@field rank number @排名
---@field name string @名称(玩家昵称)
---@field score number @积分
---@field killMonsterNum number @杀怪数
---@field killPlayerNum number @杀玩家数
---@field dieNum number @死亡数
---@field failPhase number @淘汰阶段   1初始阶段 2中期阶段  3 决赛阶段(未淘汰)

---@class DupRedFortressTwoProtos.SelfScoreRankItem
---@field rank number @排名
---@field name string @名称(玩家昵称)
---@field score number @积分
---@field killMonsterNum number @杀怪数
---@field killPlayerNum number @杀玩家数
---@field dieNum number @死亡数
---@field failPhase number @淘汰阶段   1初始阶段 2中期阶段  3 决赛阶段(未淘汰)
---@field leftNum number @剩余人数 玩家加假人

---@class DupRedFortressTwoProtos.QuitInfo
---@field reason number @1:晋级失败，2：人数不足 3:预备地图参与人数不足，活动取消
---@field warPhase number @阶段 0: 预备阶段 1初始阶段 2中期阶段  3 决赛阶段
---@field rank number @名次

---@class DupRedFortressTwoProtos.ResScoreRankInfo
---@field rankItem DupRedFortressTwoProtos.ScoreRankItem[] @排名

---@class DupRedFortressTwoProtos.ResAwardInfo
---@field rank number @排名
---@field score number @积分
---@field awardItems DupRedFortressTwoProtos.AwardItem[] @奖励的物品

---@class DupRedFortressTwoProtos.AwardItem
---@field itemConfigId number 
---@field count number 

