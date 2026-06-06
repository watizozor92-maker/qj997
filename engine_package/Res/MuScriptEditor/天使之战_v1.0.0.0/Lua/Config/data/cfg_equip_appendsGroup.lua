-- 此文件工具自动生成，不要修改
---@class cfg_equip_appendsGroup_column
---单独的序列=组ID*1000+等级
---@field id number @序列 column=1 A
---同一id为同一组
---@field group number @组id column=2 B
---策划使用
---@field note string @备注 column=3 C
---@field lv number @追加等级 column=4 D
---属性id#属性值|属性id#属性值
---@field att IntListList @追加属性 column=5 E
---不填表示该追加等级不显示文字提示
---@field tips string @提示 column=6 F

local local_att = {
    att_1={},

}

local cfg_equip_appendsGroup =
{
	{id=1001, att=local_att.att_1, tips=""},
	{id=1002, lv=1, att={{201011,4},{201021,4}}, tips="追加攻击力+%s"},
	{id=1003, lv=2, att={{201011,8},{201021,8}}, tips="追加攻击力+%s"},
	{id=1004, lv=3, att={{201011,12},{201021,12}}, tips="追加攻击力+%s"},
	{id=1005, lv=4, att={{201011,16},{201021,16}}, tips="追加攻击力+%s"},
	{id=2001, group=2, note="魔法攻击", att=local_att.att_1, tips=""},
	{id=2002, group=2, note="魔法攻击", lv=1, att={{202011,4},{202021,4}}, tips="追加魔法攻击+%s"},
	{id=2003, group=2, note="魔法攻击", lv=2, att={{202011,8},{202021,8}}, tips="追加魔法攻击+%s"},
	{id=2004, group=2, note="魔法攻击", lv=3, att={{202011,12},{202021,12}}, tips="追加魔法攻击+%s"},
	{id=2005, group=2, note="魔法攻击", lv=4, att={{202011,16},{202021,16}}, tips="追加魔法攻击+%s"},
	{id=3001, group=3, note="防御力", att=local_att.att_1, tips=""},
	{id=3002, group=3, note="防御力", lv=1, att={{206011,4}}},
	{id=3003, group=3, note="防御力", lv=2, att={{206011,8}}},
	{id=3004, group=3, note="防御力", lv=3, att={{206011,12}}},
	{id=3005, group=3, note="防御力", lv=4, att={{206011,16}}},
	{id=4001, group=4, note="[盾牌]防御力", att=local_att.att_1, tips=""},
	{id=4002, group=4, note="[盾牌]防御力", lv=1, att={{206011,5}}},
	{id=4003, group=4, note="[盾牌]防御力", lv=2, att={{206011,10}}},
	{id=4004, group=4, note="[盾牌]防御力", lv=3, att={{206011,15}}},
	{id=4005, group=4, note="[盾牌]防御力", lv=4, att={{206011,20}}},
	{id=5001, group=5, note="攻击/魔法/诅咒", att=local_att.att_1, tips=""},
	{id=5002, group=5, note="攻击/魔法/诅咒", lv=1, tips="攻击力/魔法攻击力/诅咒能力增加+%s"},
	{id=5003, group=5, note="攻击/魔法/诅咒", lv=2, att={{201011,8},{201021,8},{202011,8},{202021,8},{205011,8},{205021,8}}, tips="攻击力/魔法攻击力/诅咒能力增加+%s"},
	{id=5004, group=5, note="攻击/魔法/诅咒", lv=3, att={{201011,12},{201021,12},{202011,12},{202021,12},{205011,12},{205021,12}}, tips="攻击力/魔法攻击力/诅咒能力增加+%s"},
	{id=5005, group=5, note="攻击/魔法/诅咒", lv=4, att={{201011,16},{201021,16},{202011,16},{202021,16},{205011,16},{205021,16}}, tips="攻击力/魔法攻击力/诅咒能力增加+%s"},
	{id=6001, group=6, note="生命恢复", att=local_att.att_1, tips=""},
	{id=6002, group=6, note="生命恢复", lv=1, att={{207063,100}}, tips="生命自动回复+%s"},
	{id=6003, group=6, note="生命恢复", lv=2, att={{207063,200}}, tips="生命自动回复+%s"},
	{id=6004, group=6, note="生命恢复", lv=3, att={{207063,300}}, tips="生命自动回复+%s"},
	{id=6005, group=6, note="生命恢复", lv=4, att={{207063,400}}, tips="生命自动回复+%s"},
}

local defaults = {group=1, note="物理攻击", lv=0, att={{201011,4},{201021,4},{202011,4},{202021,4},{205011,4},{205021,4}}, tips="追加防御力+%s"}
local mt = {__index = defaults}
for _, v in ipairs(cfg_equip_appendsGroup) do
	setmetatable(v, mt)
end

return cfg_equip_appendsGroup