-- 此文件工具自动生成，不要修改
---@class cfg_equip_angelTalent_column
---@field id number @id column=1 A
---1.属性类
---2.技能类
---@field talentType number @天赋类型 column=2 B
---@field talentName string @天赋名称 column=3 C
---同组ID为同一个页签
---@field talentGroup number @天赋组 column=4 D
---天赋位于UI中的第几列
---@field talent number @天赋列数 column=5 E
---需要前置点数
---@field talentRequest number @天赋前置 column=6 F
---该天赋的最大等级
---@field talentMaxLv number @天赋最大等级 column=7 G
---填图片名称
---@field talentIcon string @天赋图标 column=8 H
local cfg_equip_angelTalent =
{
	{id=101},
	{id=102, talentType=2, talentName="纯洁狂热", talent=2, talentIcon="1015"},
	{id=103, talentName="无情连打", talent=3, talentRequest=50, talentIcon="1004"},
	{id=104, talentName="怪物猎人", talent=4, talentRequest=50, talentIcon="baofengxue"},
	{id=105, talentName="格斗技巧", talent=5, talentRequest=100, talentIcon="3007"},
	{id=106, talentName="全能大师", talent=6, talentRequest=100, talentIcon="zhufu"},
	{id=107, talentName="神圣攻击", talentIcon="2035"},
	{id=108, talentName="神圣减免", talent=3, talentRequest=50, talentIcon="3011"},
	{id=109, talentName="神圣加成", talent=6, talentRequest=100, talentIcon="3008"},
	{id=201, talentGroup=2},
	{id=202, talentType=2, talentName="神圣制裁", talentGroup=2, talent=2, talentIcon="1016"},
	{id=203, talentName="全力一击", talentGroup=2, talent=3, talentRequest=50, talentIcon="1002"},
	{id=204, talentName="致命一击", talentGroup=2, talent=4, talentRequest=50, talentIcon="3004"},
	{id=205, talentName="格斗技巧", talentGroup=2, talent=5, talentRequest=100, talentIcon="3007"},
	{id=206, talentName="全能大师", talentGroup=2, talent=6, talentRequest=100, talentIcon="zhufu"},
	{id=207, talentName="黑暗攻击", talentGroup=2, talentIcon="2032"},
	{id=208, talentName="黑暗减免", talentGroup=2, talent=3, talentRequest=50, talentIcon="3009"},
	{id=209, talentName="黑暗加成", talentGroup=2, talent=6, talentRequest=100, talentIcon="heianzhili"},
	{id=301, talentName="完美防守", talentGroup=3, talentIcon="1010"},
	{id=302, talentType=2, talentName="天使庇佑", talentGroup=3, talent=2, talentIcon="1017"},
	{id=303, talentName="生存大师", talentGroup=3, talent=3, talentRequest=50, talentIcon="1014"},
	{id=304, talentName="荒野达人", talentGroup=3, talent=4, talentRequest=50, talentIcon="2020"},
	{id=305, talentName="防御技巧", talentGroup=3, talent=5, talentRequest=100, talentIcon="1026"},
	{id=306, talentName="法师克星", talentGroup=3, talent=6, talentRequest=100, talentIcon="zhufu1"},
	{id=307, talentName="风暴攻击", talentGroup=3, talentIcon="2034"},
	{id=308, talentName="风暴减免", talentGroup=3, talent=3, talentRequest=50, talentIcon="8003130"},
	{id=309, talentName="风暴加成", talentGroup=3, talent=6, talentRequest=100, talentIcon="anbaoyanqh2"},
	{id=401, talentGroup=4},
	{id=402, talentType=2, talentName="纯洁狂热", talentGroup=4, talent=2, talentIcon="1015"},
	{id=403, talentName="无情连打", talentGroup=4, talent=3, talentRequest=50, talentIcon="1004"},
	{id=404, talentName="怪物猎人", talentGroup=4, talent=4, talentRequest=50, talentIcon="baofengxue"},
	{id=405, talentName="格斗技巧", talentGroup=4, talent=5, talentRequest=100, talentIcon="3007"},
	{id=406, talentName="全能大师", talentGroup=4, talent=6, talentRequest=100, talentIcon="zhufu"},
	{id=407, talentName="神圣攻击", talentGroup=4, talentIcon="2035"},
	{id=408, talentName="神圣减免", talentGroup=4, talent=3, talentRequest=50, talentIcon="3011"},
	{id=409, talentName="神圣加成", talentGroup=4, talent=6, talentRequest=100, talentIcon="3008"},
	{id=501, talentGroup=5},
	{id=502, talentType=2, talentName="神圣制裁", talentGroup=5, talent=2, talentIcon="1016"},
	{id=503, talentName="全力一击", talentGroup=5, talent=3, talentRequest=50, talentIcon="1002"},
	{id=504, talentName="致命一击", talentGroup=5, talent=4, talentRequest=50, talentIcon="3004"},
	{id=505, talentName="格斗技巧", talentGroup=5, talent=5, talentRequest=100, talentIcon="3007"},
	{id=506, talentName="全能大师", talentGroup=5, talent=6, talentRequest=100, talentIcon="zhufu"},
	{id=507, talentName="黑暗攻击", talentGroup=5, talentIcon="2032"},
	{id=508, talentName="黑暗减免", talentGroup=5, talent=3, talentRequest=50, talentIcon="3009"},
	{id=509, talentName="黑暗加成", talentGroup=5, talent=6, talentRequest=100, talentIcon="heianzhili"},
	{id=601, talentName="完美防守", talentGroup=6, talentIcon="1010"},
	{id=602, talentType=2, talentName="天使庇佑", talentGroup=6, talent=2, talentIcon="1017"},
	{id=603, talentName="生存大师", talentGroup=6, talent=3, talentRequest=50, talentIcon="1014"},
	{id=604, talentName="荒野达人", talentGroup=6, talent=4, talentRequest=50, talentIcon="2020"},
	{id=605, talentName="防御技巧", talentGroup=6, talent=5, talentRequest=100, talentIcon="1026"},
	{id=606, talentName="法师克星", talentGroup=6, talent=6, talentRequest=100, talentIcon="zhufu1"},
	{id=607, talentName="风暴攻击", talentGroup=6, talentIcon="2034"},
	{id=608, talentName="风暴减免", talentGroup=6, talent=3, talentRequest=50, talentIcon="8003130"},
	{id=609, talentName="风暴加成", talentGroup=6, talent=6, talentRequest=100, talentIcon="anbaoyanqh2"},
	{id=701, talentGroup=7},
	{id=702, talentType=2, talentName="纯洁狂热", talentGroup=7, talent=2, talentIcon="1015"},
	{id=703, talentName="无情连打", talentGroup=7, talent=3, talentRequest=50, talentIcon="1004"},
	{id=704, talentName="怪物猎人", talentGroup=7, talent=4, talentRequest=50, talentIcon="baofengxue"},
	{id=705, talentName="格斗技巧", talentGroup=7, talent=5, talentRequest=100, talentIcon="3007"},
	{id=706, talentName="全能大师", talentGroup=7, talent=6, talentRequest=100, talentIcon="zhufu"},
	{id=707, talentName="神圣攻击", talentGroup=7, talentIcon="2035"},
	{id=708, talentName="神圣减免", talentGroup=7, talent=3, talentRequest=50, talentIcon="3011"},
	{id=709, talentName="神圣加成", talentGroup=7, talent=6, talentRequest=100, talentIcon="3008"},
	{id=801, talentGroup=8},
	{id=802, talentType=2, talentName="神圣制裁", talentGroup=8, talent=2, talentIcon="1016"},
	{id=803, talentName="全力一击", talentGroup=8, talent=3, talentRequest=50, talentIcon="1002"},
	{id=804, talentName="致命一击", talentGroup=8, talent=4, talentRequest=50, talentIcon="3004"},
	{id=805, talentName="格斗技巧", talentGroup=8, talent=5, talentRequest=100, talentIcon="3007"},
	{id=806, talentName="全能大师", talentGroup=8, talent=6, talentRequest=100, talentIcon="zhufu"},
	{id=807, talentName="黑暗攻击", talentGroup=8, talentIcon="2032"},
	{id=808, talentName="黑暗减免", talentGroup=8, talent=3, talentRequest=50, talentIcon="3009"},
	{id=809, talentName="黑暗加成", talentGroup=8, talent=6, talentRequest=100, talentIcon="heianzhili"},
	{id=901, talentName="完美防守", talentGroup=9, talentIcon="1010"},
	{id=902, talentType=2, talentName="天使庇佑", talentGroup=9, talent=2, talentIcon="1017"},
	{id=903, talentName="生存大师", talentGroup=9, talent=3, talentRequest=50, talentIcon="1014"},
	{id=904, talentName="荒野达人", talentGroup=9, talent=4, talentRequest=50, talentIcon="2020"},
	{id=905, talentName="防御技巧", talentGroup=9, talent=5, talentRequest=100, talentIcon="1026"},
	{id=906, talentName="法师克星", talentGroup=9, talent=6, talentRequest=100, talentIcon="zhufu1"},
	{id=907, talentName="风暴攻击", talentGroup=9, talentIcon="2034"},
	{id=908, talentName="风暴减免", talentGroup=9, talent=3, talentRequest=50, talentIcon="8003130"},
	{id=909, talentName="风暴加成", talentGroup=9, talent=6, talentRequest=100, talentIcon="anbaoyanqh2"},
}

local defaults = {talentType=1, talentName="精确打击", talentGroup=1, talent=1, talentRequest=0, talentMaxLv=10, talentIcon="1001"}
local mt = {__index = defaults}
for _, v in ipairs(cfg_equip_angelTalent) do
	setmetatable(v, mt)
end

return cfg_equip_angelTalent