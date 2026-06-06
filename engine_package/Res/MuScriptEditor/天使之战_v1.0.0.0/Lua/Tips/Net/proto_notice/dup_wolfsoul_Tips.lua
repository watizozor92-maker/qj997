--工具自动生成
---@class DupWolfSoulProtos.BindDefensePlatformReq
---@field defensePlatformId number @ 神狼护台id,即monsterId

---@class DupWolfSoulProtos.LoginWolfSoulSuccessRes
---@field wolfSoulTotalHealth number @狼魂总血量
---@field wolfSoulHealth number @ 狼魂剩余血量
---@field currentRound number @ 当前轮次
---@field rank number @ 个人排名
---@field killPoint number @ 个人击杀点数
---@field dupLeftTime number @ 下一波剩余时间
---@field remainder number @ 副本剩余时间，单位：毫秒
---@field wolfSoulId number @狼魂守护台id

---@class DupWolfSoulProtos.WolfSoulGlobalInfoUpdateRes
---@field updateType number @ 见上文中定义的枚举 WSGlobalUpdateType
---@field value number 

---@class DupWolfSoulProtos.WolfSoulKillPointUpdateRes
---@field personalKillPoint number @ 个人击杀点数

---@class DupWolfSoulProtos.WolfSoulRewardPanelRes
---@field win boolean 
---@field rankRecords DupWolfSoulProtos.WolfSoulRankRecord[] 

---@class DupWolfSoulProtos.WolfSoulRankRecord
---@field wolfSoulGrade number @ 评级，见枚举WolfSoulGrade
---@field rid number 
---@field playerName string @ 玩家名字
---@field career CommonProtos.Career @ 职业
---@field level number @ 等级
---@field killScores number @ 击杀积分
---@field rewardExp number @ 奖励经验

---@class DupWolfSoulProtos.BoundStateRes
---@field boundState number @ 0: 未绑定 1:绑定中 2:已绑定

