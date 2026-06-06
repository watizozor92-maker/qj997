--工具自动生成
---@class RankProto.RankListReq
---@field type number @ 榜单分类(大类)
---@field branch number @ 榜单分支(小类)
---@field major number @ 榜单对象(排行对象)

---@class RankProto.RankList
---@field type number @ 榜单分类
---@field branch number @ 榜单分支
---@field major number @ 榜单对象
---@field rankData RankProto.RankData[] 

---@class RankProto.RankData
---@field rankNo number @ 排行名次
---@field name string @ 名称
---@field value number @ 值
---@field rid number @ 玩家id
---@field itemId number @ 物品id
---@field career number @ 玩家职业  1:剑士 2:魔法师 3:弓箭手
---@field unionName string @ 战盟/行会名称
---@field rankType number @ 榜单分类
---@field rankBranch number @ 榜单分支
---@field fightValue number @角色/盟主战力值
---@field careerCfgId number @对应职业表id
---@field unionId number @战盟id

