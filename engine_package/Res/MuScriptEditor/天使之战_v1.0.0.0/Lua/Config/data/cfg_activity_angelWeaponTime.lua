-- 此文件工具自动生成，不要修改
---@class cfg_activity_angelWeaponTime_column
---@field id number @id column=1 A
---@field taskGroup number @任务组 column=2 B
---condition
---@field condition string @开服天数 column=3 C
local cfg_activity_angelWeaponTime =
{
	{id=1, taskGroup=1},
	{id=2, taskGroup=2, condition="901#6&903#10"},
}

local defaults = {condition="901#1&903#5"}
local mt = {__index = defaults}
for _, v in ipairs(cfg_activity_angelWeaponTime) do
	setmetatable(v, mt)
end

return cfg_activity_angelWeaponTime