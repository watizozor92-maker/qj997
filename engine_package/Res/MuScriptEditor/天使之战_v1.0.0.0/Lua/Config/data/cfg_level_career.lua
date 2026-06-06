-- 此文件工具自动生成，不要修改
---@class cfg_level_career_column
---等级，大于等于此等级的玩家生效
---@field id number @等级 column=1 A
---索引task表对应ID任务
---@field taskID number @任务ID column=2 B
---完成taskID后所每级可自由分配点数
---额外增加
---格式：根职业ID#额外增加属性点|根职业ID#额外增加属性点
---@field Att IntListList @完成任务后加点奖励 column=3 C
---属性点数量
---@field Attbonus number @超过对应等级时每级补发属性点 column=4 D
local cfg_level_career =
{
	{id=221, taskID=666606, Attbonus=1},
	{id=381, taskID=666614, Att={{1,2},{2,2},{3,2}}, Attbonus=1},
}

local defaults = {Att={{1,1},{2,1},{3,1}}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_level_career) do
	setmetatable(v, mt)
end

return cfg_level_career