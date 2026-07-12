-- 此文件工具自动生成，不要修改
---@class cfg_fruit_column
---引用cfg_item表中ID
---@field id number @ID column=1 A
---果实中文名称
---@field name string @果实名称 column=2 B
---果实面板原画中，果实ICON的图标
---@field icon string @果实图标 column=3 C
---果实面板原画中，果实ICON的位置
---@field location StringList @果实位置 column=4 D
---果实增加属性
---引用cfg_att_info表中ID
---@field attribute number @属性 column=5 E
---@field group number @果实组 column=6 F
---增加属性重新分配界面的属性排序
---@field index number @果实属性排序 column=7 G
---id列表
---@field itemids StringList @同类ID column=8 H

local local_location = {
    location_1={"-104","0"},
    location_2={"127","16"},
    location_3={"-146","163"},
    location_4={"-104","-120"},

}

local local_itemids = {
    itemids_1={""},

}

local cfg_fruit =
{
	{id=30030304, name="力  量", icon="lianji", attribute=10001, index=1, itemids={"30030304","1233030499"}},
	{id=30030303, name="敏  捷", icon="agility", location=local_location.location_2, attribute=10002, index=2, itemids={"30030303","1233030399"}},
	{id=30030302, name="体  力", icon="strength", location=local_location.location_3, attribute=10004, index=3, itemids={"30030302","1233030299"}},
	{id=30030301, name="智  力", icon="intelligence", location=local_location.location_4, attribute=10003, index=4, itemids={"30030301","1233030199"}},
	{id=1233030499, name="力  量", icon="lianji", attribute=10001, index=1},
	{id=1233030399, name="敏  捷", icon="agility", location=local_location.location_2, attribute=10002, index=2},
	{id=1233030299, name="体  力", icon="strength", location=local_location.location_3, attribute=10004, index=3},
	{id=1233030199, name="智  力", icon="intelligence", location=local_location.location_4, attribute=10003, index=4},
}

local defaults = {location={"-104","0"}, group=1, itemids={""}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_fruit) do
	setmetatable(v, mt)
end

return cfg_fruit