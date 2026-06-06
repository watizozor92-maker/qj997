-- 此文件工具自动生成，不要修改
---@class cfg_equip_tips_column
---一个id为一个属性模块，增加新id需要与程序沟通，否则无法生效
---1=基础属性
---2=强化属性
---3=追加属性
---4=卓越属性
---5=萤石属性
---6=套装属性
---7=再生属性
---8=大天使-成长属性
---9=大天使-圣杯属性
---10=首饰属性
---@field id number @id column=1 A
---策划备注用
---@field remarks string @备注 column=2 B
---属性标题使用的图片文件名称
---此字段与 标题文字 字段互斥 两者填写一个即可 如果两者都填写 优先使用标题图片字段数据 不读标题文字数据
---@field picture string @标题图片 column=3 C
---属性标题使用的图片背景名称
---@field bg string @标题背景 column=4 D
---属性标题使用的文字
---此字段与 标题图片 互斥
---@field text string @标题文字 column=5 E
---属性标题使用文字时 文字的颜色 引援cfg_color表id
---@field textColor number @文字颜色 column=6 F
---具体模块下的属性名的颜色
---引援cfg_color表id
---@field attNameColor number @属性名称颜色 column=7 G
---具体模块下的属性值的颜色
---引援cfg_color表id
---@field attColor number @属性颜色 column=8 H
---具体模块下的属性背景图
---@field attBg string @属性背景图 column=9 I
---属性同段落类型在tips排序顺序
---@field sort number @属性段落内排列顺序 column=10 J
---0.不显示
---1.显示
---不填默认为0
---@field show number @是否显示 column=11 K
---属性在tips是否分段
---0或空：独立
---1：分组
---@field attGroup number @属性是否分段 column=12 L
---属性不同段落类型在tips排序顺序
---@field attGroupSort number @属性段落排列顺序 column=13 M
local cfg_equip_tips =
{
	{id=1, remarks="基础属性", picture="tips_attribute1", bg="img_tips_shuxing_di", attNameColor=255, attColor=255, sort=202, attGroup=-1, attGroupSort=-1},
	{id=2, remarks="强化属性", attNameColor=3007, attColor=3007, sort=601, attGroup=0, attGroupSort=6},
	{id=3, remarks="追加属性", sort=703},
	{id=4, remarks="卓越属性", picture="tips_attribute3", bg="img_tips_shuxing_di", sort=704},
	{id=5, remarks="萤石属性", text="镶宝  物品属性信息", textColor=4002, sort=1101, attGroup=0, attGroupSort=11},
	{id=6, remarks="套装属性", text="套装 物品属性信息", textColor=3007, attNameColor=255, attColor=255, sort=801, attGroup=0, attGroupSort=8},
	{id=7, remarks="再生属性", bg="img_tips_shuxing_di", text="再生属性", textColor=251, attNameColor=2672, attColor=2672, attBg="bg_tips_4", sort=9901, attGroupSort=99},
	{id=8, remarks="大天使-成长属性", picture="tips_attribute23", bg="img_tips_shuxing_di", textColor=4002, sort=9902, attGroupSort=99},
	{id=9, remarks="大天使-圣杯属性", picture="tips_attribute28", bg="img_tips_shuxing_di", textColor=4002, sort=9903, attGroupSort=99},
	{id=10, remarks="首饰属性", picture="tips_attribute21", bg="img_tips_shuxing_di", attNameColor=2672, attColor=3004, sort=9904, attGroupSort=99},
	{id=11, remarks="技能", sort=701},
	{id=12, remarks="幸运属性", attBg="", sort=702},
	{id=13, remarks="套装随机属性", attBg="", sort=402, attGroupSort=4},
}

local defaults = {picture="", bg="", text="", textColor=0, attNameColor=4001, attColor=4001, attBg="img_tips_shuxing_di", show=1, attGroup=1, attGroupSort=7}
local mt = {__index = defaults}
for _, v in ipairs(cfg_equip_tips) do
	setmetatable(v, mt)
end

return cfg_equip_tips