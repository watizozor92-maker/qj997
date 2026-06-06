-- 此文件工具自动生成，不要修改
---@class cfg_bagButton_column
---id
---@field id number @id column=1 A
---策划备注
---@field systemName string @ column=2 B
---填写引用文件名称，不填则不显示
---格式：贴图名称
---@field icon string @图标 column=3 C
---格式
---x#y#z
---@field position IntList @图标偏移 column=4 D
---1显示
---0不显示
---@field show number @是否显示 column=5 E
local cfg_bagButton =
{
	{id=1, systemName="背包-商店", icon="button_interface_person_buy"},
	{id=2, systemName="背包-仓库", icon="button_interface_storage", position={-45,36,0}},
	{id=3, systemName="背包-回收", icon="button_interface_sell", position={47,36,0}},
	{id=4, systemName="背包-整理", icon="button_interface_sort", position={138,36,0}},
}

local defaults = {position={-137,36,0}, show=1}
local mt = {__index = defaults}
for _, v in ipairs(cfg_bagButton) do
	setmetatable(v, mt)
end

return cfg_bagButton