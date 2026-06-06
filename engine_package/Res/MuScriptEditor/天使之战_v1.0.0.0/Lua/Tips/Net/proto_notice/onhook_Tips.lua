--工具自动生成
---@class OnhookProto.OffLineBenefit
---@field offLineOnHookTime number @离线挂机时长
---@field acquireExp number @ 获取的经验
---@field lastLogoutTime number @ 上次下线时间

---@class OnhookProto.MultiOnhookInfo
---@field status number @状态，0关闭，1开启中
---@field remains number @剩余时间（单位毫秒）
---@field earnings CommonProtos.Item[] @所有收益
---@field recoverys CommonProtos.Item[] @自动回收收益
---@field type number @1:打开界面,2:补充药水，0:其他
---@field duration number @挂机时长，单位秒

---@class OnhookProto.OfflineOnHookRes
---@field duration number @离线挂机时长（单位秒）
---@field fightDuration number @打怪时长（单位秒）
---@field fightExp number @打怪获得的经验
---@field freeDuration number @泡点时长（单位秒）
---@field freeExp number @泡点时长（单位秒）
---@field items number @获得道具个数
---@field doubleEquips number @双卓越装备个数
---@field singleEquips number @单卓越装备个数
---@field killerName string @如果被击杀，返回击杀者名称
---@field bagFull boolean @背包是否是满的

