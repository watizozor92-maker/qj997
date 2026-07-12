-- 此文件工具自动生成，不要修改
---@class cfg_firstDrop_column
---唯一id
---
---@field id number @id column=1 A
---策划备注
---@field text string @策划备注 column=2 B
---前端文本显示
---@field muneText string @前端文本显示 column=3 C
---装备掉落计数，根据全服装备掉落次数计数判断奖励组，每次判断时均判断最高掉落计数，例如：如某装备type=3，则同时进入首爆、二爆、三爆界面
---1——首爆
---2——二爆
---3——三爆
---@field type number @掉落计数 column=4 D
---卓越词条数量检测
---@field excellenceAtt number @卓越词条数量检测 column=5 E
---幸运词条数量检测
---@field luckyAtt number @幸运词条数量检测 column=6 F
---完成目标后，玩家可以获取的奖励
---配置格式：道具id#数量&道具id#数量|道具id#数量&道具id#数量，根绝type判断，进入相同界面的装备、其奖励如果多个用&隔开，不进入相同界面的装备其奖励用|隔开
---若为空则不显示
---@field reward intListListList @奖励 column=7 G
local cfg_firstDrop =
{
}
return cfg_firstDrop