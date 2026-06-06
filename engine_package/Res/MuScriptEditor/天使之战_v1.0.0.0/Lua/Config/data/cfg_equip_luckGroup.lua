-- 此文件工具自动生成，不要修改
---@class cfg_equip_luckGroup_column
---单独的序列=组ID*1000+等级
---@field id number @序列 column=1 A
---同一id为同一组
---@field group number @组id column=2 B
---策划使用
---@field note string @备注 column=3 C
---@field lv number @幸运等级 column=4 D
---属性id#属性值|属性id#属性值
---@field att IntListList @激活属性 column=5 E
---宝石id#宝石id|成功率增加（万分比）
---@field luckrate IntListList @强化灵魂宝石成功率率增加 column=6 F
---不填表示该追加等级不显示文字提示
---@field tips string @提示 column=7 G
local cfg_equip_luckGroup =
{
	{id=1001, group=1, note="幸运属性", lv=1, att={{305012,500}}, tips=""},
}

local defaults = {luckrate={{50030003,1253000399},{2500}}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_equip_luckGroup) do
	setmetatable(v, mt)
end

return cfg_equip_luckGroup