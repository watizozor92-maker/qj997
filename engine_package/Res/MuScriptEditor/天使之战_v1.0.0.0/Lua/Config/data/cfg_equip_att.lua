-- 此文件工具自动生成，不要修改
---@class cfg_equip_att_column
---词条库id
---@field id number @词条库id column=1 A
---词条名称要与实际数值对上
---@field name string @词条名称 column=2 B
---1：物理输出卓越
---2：法术输出卓越
---3：防具卓越
---4：首饰(耳环)卓越
---5：翅膀(2代)卓越/特殊属性
---6：翅膀(3代)卓越/特殊属性
---10:翅膀（2.5代）卓越/特殊属性
---11：坐骑随机词条
---@field group number @词条组 column=3 C
---格式：属性id#数值下限#数值上限#权重
---
---权重越高越容易出现，权重影响的是随机到这条属性的几率，不影响属性的数值
---
---引用att_info表id
---@field att IntListList @  column=4 D
---@field stallNum number @交易行筛选词条编号 column=5 E
---@field stallShow string @交易行词条筛选显示 column=6 F
---词条名称要与实际数值对上
---@field refineName string @洗练缩写词条名称 column=7 G

local local_att = {
    att_1={{303012,1000,1000,1000}},
    att_2={{200031,1,1,1000}},
    att_3={{200042,200,200,1000}},
    att_4={{213021,7,7,1000}},
    att_5={{207041,1250,1250,1000}},
    att_6={{208042,1250,1250,1000}},
    att_7={{329081,500,500,1000}},
    att_8={{317012,300,300,1000}},

}

local cfg_equip_att =
{
	{id=1, group=1, att=local_att.att_1, stallNum=4, stallShow="卓越一击", refineName="卓越一击概率+10%"},
	{id=2, name="攻击力 每20等级增加 1", group=1, att=local_att.att_2, stallNum=1, stallShow="(攻击力/魔法/诅咒)攻击力", refineName="攻击每20级+1"},
	{id=3, name="攻击力增加 +2%", group=1, att=local_att.att_3, stallNum=1, stallShow="(攻击力/魔法/诅咒)攻击力", refineName="攻击+2%"},
	{id=4, name="攻击(魔法)速度增加 +7", group=1, stallNum=2, stallShow="攻击速度", refineName="攻击(魔法)速度+7"},
	{id=5, name="杀死怪物时所获 (生命值/8)", group=1, att=local_att.att_5, stallNum=3, stallShow="击杀回复", refineName="杀怪所获 (生命值/8)"},
	{id=6, name="杀死怪物时所获 (魔法值/8)", group=1, att=local_att.att_6, stallNum=3, stallShow="击杀回复", refineName="杀怪所获 (魔法值/8)"},
	{id=7, group=2, att=local_att.att_1, stallNum=4, stallShow="卓越一击", refineName="卓越一击概率+10%"},
	{id=8, name="攻击力 每20等级增加 1", group=2, att=local_att.att_2, stallNum=5, stallShow="(攻击力/魔法/诅咒)攻击力", refineName="攻击每20级+1"},
	{id=9, name="攻击力增加 +2%", group=2, att=local_att.att_3, stallNum=5, stallShow="(攻击力/魔法/诅咒)攻击力", refineName="攻击+2%"},
	{id=10, name="攻击(魔法)速度增加 +7", group=2, stallNum=2, stallShow="攻击速度", refineName="攻击(魔法)速度+7"},
	{id=11, name="杀死怪物时所获 (生命值/8)", group=2, att=local_att.att_5, stallNum=3, stallShow="击杀回复", refineName="杀怪所获(生命值/8)"},
	{id=12, name="杀死怪物时所获 (魔法值/8)", group=2, att=local_att.att_6, stallNum=3, stallShow="击杀回复", refineName="杀怪所获(魔法值/8)"},
	{id=13, name="最大生命值增加 +4%", group=3, att={{207022,400,400,1000}}, stallNum=6, stallShow="最大生命值", refineName="最大生命值+4%"},
	{id=14, name="最大魔法值增加 +4%", group=3, att={{208023,400,400,1000}}, stallNum=7, stallShow="最大魔法值", refineName="最大魔法值+4%"},
	{id=15, name="伤害减少 +4%", group=3, att={{312012,400,400,1000}}, stallNum=8, stallShow="伤害减少", refineName="伤害减少+4%"},
	{id=16, name="伤害反射 +5%", group=3, att={{314012,500,500,1000}}, stallNum=9, stallShow="伤害反射", refineName="伤害反射+5%"},
	{id=17, name="防御成功率 +10%", group=3, att={{211022,1000,1000,1000}}, stallNum=10, stallShow="防御成功率", refineName="防御成功率+10%"},
	{id=18, name="杀死怪物时所获金增加 +30%", group=3, att={{319012,3000,3000,1000}}, stallNum=11, stallShow="杀怪金币加成", refineName="杀怪所获金+30%"},
	{id=19, name="最大生命增加 + 200", group=4, att={{207021,200,200,1000}}, stallNum=6, stallShow="最大生命值", refineName="最大生命+200"},
	{id=20, name="技能攻击力增加 + 17", group=4, att={{320011,17,17,1000}}, stallNum=12, stallShow="技能攻击力", refineName="技能攻击+17"},
	{id=21, name="精通攻击力/魔法攻击力增加 + 20", group=4, att={{200041,20,20,1000}}, stallNum=17, stallShow="攻击力/魔力", refineName="精通攻击/魔法攻击+20"},
	{id=22, name="精通卓越一击伤害增加 + 35", group=4, att={{303072,35,35,1000}}, stallNum=4, stallShow="卓越一击", refineName="精通卓越一击伤害+35"},
	{id=23, name="精通会心一击伤害增加 + 35", group=4, att={{305072,35,35,1000}}, stallNum=13, stallShow="会心一击", refineName="精通会心一击伤害+35"},
	{id=24, name="无视敌人防御力的概率增加 +3%", group=5, att=local_att.att_8, stallNum=14, stallShow="无视防御", refineName="无视防御概率+3%"},
	{id=25, name="魔法值增加 50+(强化等级)*5", group=5, att={{1229,50,50,1000}}, stallNum=7, stallShow="最大魔法值", refineName="魔法值+(50+(强化等级)*5)"},
	{id=26, name="生命值增加 50+(强化等级)*5", group=5, att={{1230,50,50,1000}}, stallNum=6, stallShow="最大生命值", refineName="生命值+(50+(强化等级)*5)"},
	{id=27, name="魔法值完全恢复几率提高 +5%", group=6, att={{329092,500,500,1000}}, stallNum=15, stallShow="受击概率恢复", refineName="魔法值完全恢复率+5%"},
	{id=28, name="完全恢复生命的概率增加 +5%", group=6, att=local_att.att_7, stallNum=15, stallShow="受击概率恢复", refineName="完全恢复生命概率+5%"},
	{id=29, name="反弹攻击力几率提高 +5%", group=6, att={{500003,500,500,1000}}, stallNum=16, stallShow="伤害反弹", refineName="反弹攻击几率+5%"},
	{id=30, name="无视敌人防御力的概率增加 +5%", group=6, att={{317012,500,500,1000}}, stallNum=14, stallShow="无视防御", refineName="无视防御概率+5%"},
	{id=31, name="职业增伤和减伤1", att={{166,100,1500,1000}}, refineName="职业增伤和减伤1"},
	{id=32, name="职业增伤和减伤2", att={{168,100,1500,1000}}, refineName="职业增伤和减伤2"},
	{id=33, name="职业增伤和减伤3", att={{170,100,1500,1000}}, refineName="职业增伤和减伤3"},
	{id=34, name="职业增伤和减伤4", att={{172,100,1500,1000}}, refineName="职业增伤和减伤4"},
	{id=35, name="职业增伤和减伤5", att={{174,100,1500,1000}}, refineName="职业增伤和减伤5"},
	{id=36, name="职业增伤和减伤6", att={{176,100,1500,1000}}, refineName="职业增伤和减伤6"},
	{id=37, name="职业增伤和减伤7", att={{178,100,1500,1000}}, refineName="职业增伤和减伤7"},
	{id=38, name="职业增伤和减伤8", att={{180,100,1500,1000}}, refineName="职业增伤和减伤8"},
	{id=39, name="职业增伤和减伤9", att={{182,100,1500,1000}}, refineName="职业增伤和减伤9"},
	{id=40, name="职业增伤和减伤10", att={{184,100,1500,1000}}, refineName="职业增伤和减伤10"},
	{id=41, name="职业增伤和减伤11", att={{186,100,1500,1000}}, refineName="职业增伤和减伤11"},
	{id=42, name="职业增伤和减伤12", att={{188,100,1500,1000}}, refineName="职业增伤和减伤12"},
	{id=43, name="魔法值增加 50+(强化等级)*5", group=8, att={{1229,50,50,10000}}, stallNum=6, stallShow="最大生命值", refineName="魔法值增加 50+(强化等级)*5"},
	{id=44, name="生命值增加 50+(强化等级)*5", group=8, att={{1230,50,50,10000}}, stallNum=7, stallShow="最大魔法值", refineName="生命值增加 50+(强化等级)*5"},
	{id=45, name="完全恢复生命的概率增加 +6%", group=8, att={{329081,600,600,10000}}, stallNum=15, stallShow="受击概率恢复", refineName="完全恢复生命的概率增加 6%"},
	{id=46, name="魔法值完全恢复几率提高 +6%", group=8, att={{329092,600,600,10000}}, stallNum=15, stallShow="受击概率恢复", refineName="魔法值完全恢复几率提高 +6%"},
	{id=47, name="攻击力增加 +2%", group=8, att={{200042,200,200,10000}}, stallNum=1, stallShow="(攻击力/魔法/诅咒)攻击力", refineName="攻击力增加 +2%"},
	{id=48, group=9, att=local_att.att_1, stallNum=4, stallShow="卓越一击", refineName="卓越一击概率+10%"},
	{id=49, name="攻击力 每20等级增加 2.0", group=9, att={{200031,2,2,1000}}, stallNum=1, stallShow="(攻击力/魔法/诅咒)攻击力", refineName="攻击每20级+2"},
	{id=50, name="增加 (攻击力/魔法/诅咒) 57", group=9, att={{200041,57,57,1000}}, stallNum=1, stallShow="(攻击力/魔法/诅咒)攻击力", refineName="(攻击力/魔法/诅咒)攻击力+57"},
	{id=51, name="攻击(魔法)速度增加 +7", group=9, stallNum=2, stallShow="攻击速度", refineName="攻击(魔法)速度+7"},
	{id=52, name="杀死怪物时所获 (生命值/8)", group=9, att=local_att.att_5, stallNum=3, stallShow="击杀回复", refineName="杀怪所获(生命值/8)"},
	{id=53, name="杀死怪物时所获 (魔法值/8)", group=9, att=local_att.att_6, stallNum=3, stallShow="击杀回复", refineName="杀怪所获(魔法值/8)"},
	{id=54, name="完全恢复生命的概率增加 +5%", group=10, att=local_att.att_7, stallNum=15, stallShow="受击概率恢复", refineName="完全恢复生命概率+5%"},
	{id=55, name="无视敌人防御力的概率增加 +3%", group=10, att=local_att.att_8, stallNum=14, stallShow="无视防御", refineName="无视防御概率+3%"},
	{id=56, name="双倍伤害几率 +4%", group=11, att={{304012,400,400,100}}, stallNum=16, stallShow="双倍一击", refineName="双倍伤害几率 +4%"},
	{id=57, name="无视目标防御 +5%", group=11, att={{317012,500,500,100}}, stallNum=14, stallShow="无视防御", refineName="无视目标防御 +5%"},
	{id=58, group=11, att={{303012,1000,1000,100}}, stallNum=4, stallShow="卓越一击", refineName="卓越一击概率 增加 +10%"},
	{id=59, name="(攻击力/魔法/诅咒)攻击力增加+等级/10", group=11, att={{200030,1,1,100}}, stallNum=1, stallShow="攻击力/魔力/诅咒", refineName="(攻击力/魔法/诅咒)攻击力增加+等级/10"},
	{id=60, name="(攻击力/魔法/诅咒)攻击力 +5%", group=11, att={{200042,500,500,100}}, stallNum=1, stallShow="攻击力/魔力/诅咒", refineName="(攻击力/魔法/诅咒)攻击力 +5%"},
	{id=61, name="攻击(魔法)速度增加 +10", group=11, att={{213021,10,10,100}}, stallNum=2, stallShow="攻击速度", refineName="攻击(魔法)速度增加 +10"},
	{id=62, name="杀怪回复AG值 +20", group=11, att={{1054,20,20,100}}, stallNum=17, stallShow="击杀回AG", refineName="杀怪回复AG值 +20"},
	{id=63, name="杀怪所获(生命值/8)", group=11, att={{207041,1250,1250,100}}, stallNum=3, stallShow="击杀回复", refineName="杀怪所获(生命值/8)"},
	{id=64, name="杀怪所获(魔法值/8)", group=11, att={{208042,1250,1250,100}}, stallNum=3, stallShow="击杀回复", refineName="杀怪所获(魔法值/8)"},
	{id=65, name="最大生命值增加 +6%", group=11, att={{207022,6,6,100}}, stallNum=6, stallShow="最大生命值", refineName="最大生命值增加 +6%"},
	{id=66, name="伤害减少 +6%", group=11, att={{312012,600,600,100}}, stallNum=8, stallShow="伤害减少", refineName="伤害减少 +6%"},
	{id=67, name="攻击速度增加+7", group=12, stallShow="攻击速度增加+7", refineName="攻击速度增加+7"},
	{id=68, name="卓越一击概率 增加 +4%", group=12, att={{303012,400,400,100}}, stallShow="卓越一击概率 增加 +4%", refineName="卓越一击概率 增加 +4%"},
	{id=69, name="幸运一击伤害概率增加+4%", group=12, att={{305012,400,400,100}}, stallShow="幸运一击伤害概率增加+4%", refineName="幸运一击伤害概率增加+4%"},
	{id=70, name="AG自动回复量+10", group=12, att={{207063,10,10,100}}, stallShow="AG自动回复量+10", refineName="AG自动回复量+10"},
	{id=71, name="最大魔法值增加+200", group=12, att={{208011,200,200,100}}, stallShow="最大魔法值增加+200", refineName="最大魔法值增加+200"},
}

local defaults = {name="卓越一击概率 增加 +10%", group=7, att={{213021,7,7,1000}}, stallNum=0, stallShow=""}
local mt = {__index = defaults}
for _, v in ipairs(cfg_equip_att) do
	setmetatable(v, mt)
end

return cfg_equip_att