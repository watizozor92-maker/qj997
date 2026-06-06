-- 此文件工具自动生成，不要修改
---@class cfg_master_skilltalent_column
---第1位：职业天赋1，技能天赋2，通用天赋3
---第23位：根职业
---第4位：系
---第5位：行
---第6位：阶
---@field id number @唯一id，天赋id column=1 A
---天赋名称
---@field name string @天赋名称 column=2 B
---天赋类型
---1技能天赋；2职业天赋；3技能
---@field type number @天赋类型 column=3 C
---默认职业归属
---引援career职业表
---格式：所属根职业
---0为全职业
---多职业之间用#分割
---@field career IntList @所属职业 column=4 D
---天赋所属的天赋系
---@field series number @所属天赋系 column=5 E
---天赋处于当前天赋系的哪一行
---@field row number @天赋所在行 column=6 F
---天赋处于当前行的哪一阶
---@field steps number @天赋所在阶数 column=7 G
---天赋最低最高等级
---格式：最小等级#最大等级
---@field minMaxLevel IntList @天赋最低最高等级 column=8 H
---配置资源路径
---@field icon string @jiangudebihu2 column=9 I
---1.type=2时配置这个字段，引用cfg_master_protalent表id
---2.type=3时配置这个字段，引用cfg_skill表id
---@field proTalentId number @职业天赋id column=10 J

local local_career = {
    career_1={1},
    career_2={2},
    career_3={3},

}

local local_minMaxLevel = {
    minMaxLevel_1={0,2},
    minMaxLevel_2={},

}

local cfg_master_skilltalent =
{
	{id=201111, name="突袭", type=3, minMaxLevel=local_minMaxLevel.minMaxLevel_2, icon="tuxi2", proTalentId=1040001},
	{id=201112, name="突袭冷却降低", steps=1, icon="2019"},
	{id=201113, name="突袭提升施法距离", steps=2, icon="2020"},
	{id=201114, name="突袭后首次伤害提升", steps=3, icon="2021"},
	{id=201121, name="血腥风暴", type=3, row=2, minMaxLevel=local_minMaxLevel.minMaxLevel_2, icon="xuexingfengbao2", proTalentId=1014030},
	{id=201122, name="血腥风暴伤害提升", row=2, steps=1, icon="2022"},
	{id=201123, name="血腥风暴命中提升伤害", row=2, steps=2, icon="2023"},
	{id=201124, name="血腥风暴范围增加", row=2, steps=3, icon="2024"},
	{id=201131, name="剑术", type=2, row=3, minMaxLevel=local_minMaxLevel.minMaxLevel_2, icon="10002", proTalentId=101121},
	{id=201132, name="剑术冰冻概率提升", row=3, steps=1, icon="2025"},
	{id=201133, name="袭风刺触发剑士概率提升", row=3, steps=2, icon="2026"},
	{id=201134, name="对剑术冰冻的目标伤害提升", row=3, steps=3, icon="2027"},
	{id=201211, name="格挡", type=2, series=2, minMaxLevel=local_minMaxLevel.minMaxLevel_2, icon="10018", proTalentId=101261},
	{id=201212, name="格挡概率提升", series=2, steps=1, icon="2028"},
	{id=201213, name="格挡成功获免疫增益", series=2, steps=2, icon="2029"},
	{id=201214, name="格挡成功获SD值", series=2, steps=3, icon="2030"},
	{id=201221, name="坚固的庇护", type=3, series=2, row=2, minMaxLevel=local_minMaxLevel.minMaxLevel_2, icon="jiangudebihu2", proTalentId=1040004},
	{id=201222, name="坚固庇护持续时间增长", series=2, row=2, steps=1, icon="2031"},
	{id=201223, name="坚固庇护额外增加护盾", series=2, row=2, steps=2, icon="2032"},
	{id=201224, name="坚固庇佑护盾免伤增益", series=2, row=2, steps=3, icon="2033"},
	{id=201231, name="坚固的庇护", type=3, series=2, row=3, minMaxLevel=local_minMaxLevel.minMaxLevel_2, icon="jiangudebihu2", proTalentId=1040004},
	{id=201232, name="坚固庇护冷却降低", series=2, row=3, steps=1, icon="2034"},
	{id=201233, name="坚固庇护根据人数获得免伤", series=2, row=3, steps=2, icon="2035"},
	{id=201234, name="坚固庇护人数提升", series=2, row=3, steps=3, icon="2036"},
	{id=202111, name="极光术", type=3, career=local_career.career_2, minMaxLevel=local_minMaxLevel.minMaxLevel_2, icon="12140100", proTalentId=1040005},
	{id=202112, name="极光术伤害提升", career=local_career.career_2, steps=1, icon="2001"},
	{id=202113, name="极光术超越一击", career=local_career.career_2, steps=2, icon="2002"},
	{id=202114, name="极光术超越一击附加溢伤", career=local_career.career_2, steps=3, icon="2003"},
	{id=202121, name="爆炎术", type=3, career=local_career.career_2, row=2, minMaxLevel=local_minMaxLevel.minMaxLevel_2, icon="13180100", proTalentId=1040006},
	{id=202122, name="爆炎术伤害提升", career=local_career.career_2, row=2, steps=1, icon="2004"},
	{id=202123, name="爆炎术溅射", career=local_career.career_2, row=2, steps=2, icon="2005"},
	{id=202124, name="爆炎术溅射范围提升", career=local_career.career_2, row=2, steps=3, icon="2006"},
	{id=202131, name="流星石", type=3, career=local_career.career_2, row=3, minMaxLevel=local_minMaxLevel.minMaxLevel_2, icon="12240100", proTalentId=1040007},
	{id=202132, name="流星石伤害提升", career=local_career.career_2, row=3, steps=1, icon="2007"},
	{id=202133, name="流星石概率降低冷却", career=local_career.career_2, row=3, steps=2, icon="2008"},
	{id=202134, name="流星石范围提升", career=local_career.career_2, row=3, steps=3, icon="2009"},
	{id=202211, name="毒炎术", type=3, career=local_career.career_2, series=2, minMaxLevel=local_minMaxLevel.minMaxLevel_2, icon="danduyan2", proTalentId=1040008},
	{id=202212, name="毒炎术伤害提升", career=local_career.career_2, series=2, steps=1, icon="2010"},
	{id=202213, name="毒炎术增加减防效果", career=local_career.career_2, series=2, steps=2, icon="2011"},
	{id=202214, name="毒炎术减防效果附加溢伤", career=local_career.career_2, series=2, steps=3, icon="2012"},
	{id=202221, name="掌心雷", type=3, career=local_career.career_2, series=2, row=2, minMaxLevel=local_minMaxLevel.minMaxLevel_2, icon="12050100", proTalentId=1040009},
	{id=202222, name="掌心雷伤害提升", career=local_career.career_2, series=2, row=2, steps=1, icon="2013"},
	{id=202223, name="掌心雷概率致盲", career=local_career.career_2, series=2, row=2, steps=2, icon="2014"},
	{id=202224, name="掌心雷致盲降低目标伤害", career=local_career.career_2, series=2, row=2, steps=3, icon="2015"},
	{id=202231, name="地牢术", type=3, career=local_career.career_2, series=2, row=3, minMaxLevel=local_minMaxLevel.minMaxLevel_2, icon="12260100", proTalentId=1040010},
	{id=202232, name="地牢术禁锢概率提升", career=local_career.career_2, series=2, row=3, steps=1, icon="2016"},
	{id=202233, name="地牢术禁锢降低冷却", career=local_career.career_2, series=2, row=3, steps=2, icon="2017"},
	{id=202234, name="地牢术范围和命中人数提升", career=local_career.career_2, series=2, row=3, steps=3, icon="2018"},
	{id=202111, name="闪避", type=3, career=local_career.career_3, minMaxLevel=local_minMaxLevel.minMaxLevel_2, icon="shanbi2", proTalentId=1040011},
	{id=202112, name="闪避冷却降低", career=local_career.career_3, steps=1, icon="2037"},
	{id=202113, name="闪避10次增加护盾", career=local_career.career_3, steps=2, icon="2038"},
	{id=202114, name="闪避护盾增加免伤", career=local_career.career_3, steps=3, icon="2039"},
	{id=202121, name="聚击", type=3, career=local_career.career_3, row=2, minMaxLevel=local_minMaxLevel.minMaxLevel_2, icon="juji2", proTalentId=1040012},
	{id=202122, name="聚击伤害提升", career=local_career.career_3, row=2, steps=1, icon="2040"},
	{id=202123, name="聚击概率额外射出箭数", career=local_career.career_3, row=2, steps=2, icon="2041"},
	{id=202124, name="聚击命中箭矢概率击飞", career=local_career.career_3, row=2, steps=3, icon="2042"},
	{id=202131, name="毒箭", type=3, career=local_career.career_3, row=3, minMaxLevel=local_minMaxLevel.minMaxLevel_2, icon="dujian2", proTalentId=1040013},
	{id=202132, name="毒箭伤害提升", career=local_career.career_3, row=3, steps=1, icon="2043"},
	{id=202133, name="毒箭增加减防效果", career=local_career.career_3, row=3, steps=2, icon="2044"},
	{id=202134, name="毒箭减防效果附近溢伤", career=local_career.career_3, row=3, steps=3, icon="2045"},
	{id=202211, name="祝福", type=3, career=local_career.career_3, series=2, minMaxLevel=local_minMaxLevel.minMaxLevel_2, icon="13200100", proTalentId=1040014},
	{id=202212, name="祝福效果提升", career=local_career.career_3, series=2, steps=1, icon="2046"},
	{id=202213, name="祝福驱散所有负责效果", career=local_career.career_3, series=2, steps=2, icon="2047"},
	{id=202214, name="祝福增加移速", career=local_career.career_3, series=2, steps=3, icon="2048"},
	{id=202221, name="组队治疗", type=3, career=local_career.career_3, series=2, row=2, minMaxLevel=local_minMaxLevel.minMaxLevel_2, icon="13220100", proTalentId=1040015},
	{id=202222, name="组队治疗效果提升", career=local_career.career_3, series=2, row=2, steps=1, icon="2049"},
	{id=202223, name="组队治疗范围提升", career=local_career.career_3, series=2, row=2, steps=2, icon="2050"},
	{id=202224, name="组队治疗附加持续治疗效果", career=local_career.career_3, series=2, row=2, steps=3, icon="2051"},
	{id=202231, name="幻影", type=3, career=local_career.career_3, series=2, row=3, minMaxLevel=local_minMaxLevel.minMaxLevel_2, icon="13230100", proTalentId=1040016},
	{id=202232, name="幻影冷却降低", career=local_career.career_3, series=2, row=3, steps=1, icon="2052"},
	{id=202233, name="幻影隐身状态减伤", career=local_career.career_3, series=2, row=3, steps=2, icon="2053"},
	{id=202234, name="幻影破隐首次伤害提升", career=local_career.career_3, series=2, row=3, steps=3, icon="2054"},
}

local defaults = {type=1, career={1}, series=1, row=1, steps=0, minMaxLevel={0,2}, proTalentId=0}
local mt = {__index = defaults}
for _, v in ipairs(cfg_master_skilltalent) do
	setmetatable(v, mt)
end

return cfg_master_skilltalent