-- 此文件工具自动生成，不要修改
---@class cfg_rep_QuestSweep_column
---引援cfg_rep的层级id
---@field repid number @扫荡id column=1 A
---前端显示的文本
---@field layer string @扫荡层数 column=2 B
---扫荡消耗的道具
---@field deplete IntList @消耗道具 column=3 C
---扫荡额外消耗的道具，额外消耗为空时，则不显示
---@field extra IntList @额外消耗 column=4 D
---特殊掉落道具
---配置格式：道具id#数量
---@field drop IntListList @掉落奖励 column=5 E

local local_extra = {
    extra_1={80000301,2},

}

local cfg_rep_QuestSweep =
{
	{repid=20001, layer="卡利玛神庙第1层", deplete={80000201,1}, drop={{80000401,1}}},
	{repid=20002, layer="卡利玛神庙第2层", deplete={80000202,1}, drop={{80000402,1}}},
	{repid=20003, layer="卡利玛神庙第3层", deplete={80000203,1}, drop={{80000403,1}}},
	{repid=20004, layer="卡利玛神庙第4层", deplete={80000204,1}, drop={{80000404,1}}},
	{repid=20005, layer="卡利玛神庙第5层", deplete={80000205,1}, drop={{80000405,1}}},
	{repid=20006, layer="卡利玛神庙第6层", deplete={80000206,1}, drop={{80000406,1}}},
	{repid=20007, layer="卡利玛神庙第7层", deplete={80000207,1}, drop={{80000407,1}}},
}

local defaults = {extra={80000301,2}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_rep_QuestSweep) do
	setmetatable(v, mt)
end

return cfg_rep_QuestSweep