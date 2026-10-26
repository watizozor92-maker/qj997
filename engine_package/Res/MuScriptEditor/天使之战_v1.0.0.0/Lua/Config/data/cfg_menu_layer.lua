-- 此文件工具自动生成，不要修改
---@class cfg_menu_layer_column
---这个id可以交由客户端定
---@field id number @唯一id column=1 A
---游戏主界面id=0
---三级页签数量大于等于2才显示页签选项
---@field parentID number @父页签id column=2 B
---数字越小优先越高
---@field index number @排序 column=3 C
---归属界面名称,主要方便配表备注用,数据可不作读取
---@field parentName string @父页签名称 column=4 D
---当前的页签显示名称
---@field name string @页签名称 column=5 E
---页签下方所显示的货币类型
---item表type=1的道具ID#ID#ID
---@field money IntList @该页签下方所显示货币 column=6 F
---达到该等级时才显示对应页签
---@field level number @显示等级 column=7 G
---猎魔勋章商城赛季条件，引用cfg_global表27006字段，不配或配0为没有显示条件
---@field lieMoSeason number @显示赛季 column=8 H

local local_money = {
    money_1={10240001},
    money_2={10040001},
    money_3={10210001},

}

local cfg_menu_layer =
{
	{id=1003, parentID=1000, index=2, parentName="商城", name="积分商城"},
	{id=1030, name="药水类", level=900},
	{id=1031, index=2, name="道具类"},
	{id=1032, index=3, name="职业卡", level=900},
	{id=3012, index=4, name="消耗类"},
	{id=3014, index=5, name="转职物品"},
	{id=1004, parentID=1000, index=3, parentName="瑞币", name="瑞币商店", money=local_money.money_2},
	{id=5001, parentID=1004, parentName="瑞币商店", name="增益类", money=local_money.money_2},
	{id=5002, parentID=1004, parentName="瑞币商店", name="职业卡", money=local_money.money_2},
	{id=1005, parentID=1000, index=4, parentName="大天使积分", name="大天使商城", money=local_money.money_3},
	{id=6001, parentID=1005, parentName="大天使商城", name="武器", money=local_money.money_3},
	{id=6002, parentID=1005, parentName="大天使商城", name="防具", money=local_money.money_3},
	{id=6003, parentID=1005, parentName="大天使商城", name="材料", money=local_money.money_3},
}

local defaults = {parentID=1003, index=1, parentName="积分商店", money={10240001}, level=0, lieMoSeason=0}
local mt = {__index = defaults}
for _, v in ipairs(cfg_menu_layer) do
	setmetatable(v, mt)
end

return cfg_menu_layer