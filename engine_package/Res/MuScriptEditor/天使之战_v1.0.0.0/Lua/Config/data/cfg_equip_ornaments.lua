-- 此文件工具自动生成，不要修改
---@class cfg_equip_ornaments_column
---首饰组x10+首饰等级
---@field id number @id column=1 A
---不同的组对应不同的首饰
---100：火之耳环
---1000：火之戒指
---10000：火之项链
---@field ornamentsGroup number @首饰组 column=2 B
---首饰等级
---@field lv number @首饰等级 column=3 C
---属性id#数值|属性id#数值
---@field basicAtt IntListList @基础属性 column=4 D
---首饰强化的最大等级
---@field strengthenmaxLevel number @最大强化等级 column=5 E
---首饰追加的最大等级
---@field appendsmaxLevel number @最大追加等级 column=6 F
---道具id#数量|道具id#数量
---@field lvDeplete IntListList @升级消耗 column=7 G
---属性id#数值|属性id#数值
---@field excellenceAtt IntListList @卓越属性 column=8 H
---道具id#数量|道具id#数量
---@field unlockDeplete IntListList @解锁消耗 column=9 I
local cfg_equip_ornaments =
{
}
return cfg_equip_ornaments