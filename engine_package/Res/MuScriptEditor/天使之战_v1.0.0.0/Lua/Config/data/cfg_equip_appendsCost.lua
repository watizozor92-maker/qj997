-- 此文件工具自动生成，不要修改
---@class cfg_equip_appendsCost_column
---@field id number @id column=1 A
---@field costGroupId number @消耗组 column=2 B
---描写装备信息，方便查看
---@field description string @描述 column=3 C
---追加等级
---@field level number @追加等级 column=4 D
---分噱当前追加等级进行判断，若：
---1——继续在锻造界面执行追加操作
---2——在合成界面执行追加操作
---@field muneType number @操作界面 column=5 E
---万分比
---@field rate number @追加成功率（服务端） column=6 F
---(前端被100整除)万分比
---@field rateClient number @追加成功率（客户端） column=7 G
---追加失败后的等级
---@field failLevel number @追加失败后的等级 column=8 H
---格式：0（否）/ 1（是）
---备注：当玩家此装备首次强化到该等级时，全服展示跑马灯
---@field firstRate number @是否开启跑马灯 column=9 I
---备注：不填表示该强化等级不显示文字提示
---@field tips string @下一阶段文字提示(前端) column=10 J
---消耗道具：道具id#数量
---@field cost IntListList @道具消耗（合成） column=11 K
---消耗道具：道具id#数量
---@field coincost IntList @背包非显示道具的消耗（合成） column=12 L
---索引cfg_equip_appendsCost_v2表id，当muneType=1时，使用本字段的消耗
---若使用多个宝石进行强化，则通过“#”链接
---@field appendCost IntList @消耗道具（锻造） column=13 M

local local_cost = {
    cost_1={},
    cost_2={{50030004,2}},
    cost_3={{50030004,4}},
    cost_4={{50030004,6}},
    cost_5={{50030004,8}},

}

local local_coincost = {
    coincost_1={},
    coincost_2={10020001,1000},
    coincost_3={10020001,2000},
    coincost_4={10020001,4000},
    coincost_5={10020001,6000},
    coincost_6={10020001,8000},
    coincost_7={10020001,12000},
    coincost_8={10020001,16000},
    coincost_9={10020001,0},

}

local local_appendCost = {
    appendCost_1={1,2},
    appendCost_2={},
    appendCost_3={5,6},

}

local cfg_equip_appendsCost =
{
	{id=1, level=1, muneType=1, rate=0, rateClient=0, firstRate=0, cost=local_cost.cost_1, coincost=local_coincost.coincost_1, appendCost=local_appendCost.appendCost_3},
	{id=2, level=2, muneType=1, rate=0, rateClient=0, firstRate=0, cost=local_cost.cost_1, coincost=local_coincost.coincost_1, appendCost=local_appendCost.appendCost_1},
	{id=3, level=3, muneType=1, rate=0, rateClient=0, firstRate=0, cost=local_cost.cost_1, coincost=local_coincost.coincost_1, appendCost=local_appendCost.appendCost_1},
	{id=4, level=4, muneType=1, rate=0, rateClient=0, firstRate=0, cost=local_cost.cost_1, coincost=local_coincost.coincost_1, appendCost=local_appendCost.appendCost_1},
	{id=5, level=5, muneType=1, rate=0, rateClient=0, firstRate=0, cost=local_cost.cost_1, coincost=local_coincost.coincost_1, appendCost=local_appendCost.appendCost_1},
	{id=6, level=6, muneType=1, rate=0, rateClient=0, firstRate=0, cost=local_cost.cost_1, coincost=local_coincost.coincost_1, appendCost=local_appendCost.appendCost_1},
	{id=7, level=7, muneType=1, rate=0, rateClient=0, firstRate=0, cost=local_cost.cost_1, coincost=local_coincost.coincost_1, appendCost=local_appendCost.appendCost_1},
	{id=8, level=8, muneType=1, rate=0, rateClient=0, firstRate=0, cost=local_cost.cost_1, coincost=local_coincost.coincost_1, appendCost=local_appendCost.appendCost_1},
	{id=9, level=9, muneType=1, rate=0, rateClient=0, firstRate=0, cost=local_cost.cost_1, coincost=local_coincost.coincost_1, appendCost=local_appendCost.appendCost_1},
	{id=10, level=10, rate=9000, rateClient=9000, failLevel=8, tips="失败退到8级", cost=local_cost.cost_2, coincost=local_coincost.coincost_2},
	{id=11, level=11, rate=9000, rateClient=9000, failLevel=8, tips="失败退到8级", cost=local_cost.cost_2, coincost=local_coincost.coincost_2},
	{id=12, level=12, rate=9000, rateClient=9000, failLevel=8, tips="失败退到8级", cost=local_cost.cost_2, coincost=local_coincost.coincost_2},
	{id=13, level=13, rate=8500, rateClient=8500, failLevel=12, cost=local_cost.cost_3, coincost=local_coincost.coincost_3},
	{id=14, level=14, rate=8500, rateClient=8500, failLevel=12, tips="失败退到12级", cost=local_cost.cost_3, coincost=local_coincost.coincost_3},
	{id=15, level=15, rate=8500, rateClient=8500, failLevel=12, tips="失败退到12级", cost=local_cost.cost_3, coincost=local_coincost.coincost_3},
	{id=16, level=16, rate=8500, rateClient=8500, failLevel=12, tips="失败退到12级", cost=local_cost.cost_3, coincost=local_coincost.coincost_3},
	{id=17, level=17, rate=8000, rateClient=8000, failLevel=16, cost=local_cost.cost_4, coincost=local_coincost.coincost_4},
	{id=18, level=18, rate=8000, rateClient=8000, failLevel=16, tips="失败退到16级", cost=local_cost.cost_4, coincost=local_coincost.coincost_4},
	{id=19, level=19, rate=8000, rateClient=8000, failLevel=16, tips="失败退到16级", cost=local_cost.cost_4, coincost=local_coincost.coincost_4},
	{id=20, level=20, rate=8000, rateClient=8000, failLevel=16, tips="失败退到16级", cost=local_cost.cost_4, coincost=local_coincost.coincost_4},
	{id=21, level=21, rate=7500, rateClient=7500, failLevel=20, coincost=local_coincost.coincost_5},
	{id=22, level=22, rate=7500, rateClient=7500, failLevel=20, tips="失败退到20级", coincost=local_coincost.coincost_5},
	{id=23, level=23, rate=7500, rateClient=7500, failLevel=20, tips="失败退到20级", coincost=local_coincost.coincost_5},
	{id=24, level=24, rate=7500, rateClient=7500, failLevel=20, tips="失败退到20级", coincost=local_coincost.coincost_5},
	{id=25, level=25, failLevel=24, coincost=local_coincost.coincost_6},
	{id=26, level=26, failLevel=24, tips="失败退到24级", coincost=local_coincost.coincost_6},
	{id=27, level=27, failLevel=24, tips="失败退到24级", coincost=local_coincost.coincost_6},
	{id=28, level=28, failLevel=24, tips="失败退到24级", coincost=local_coincost.coincost_6},
	{id=29, level=29, rate=6500, rateClient=6500, failLevel=28, coincost=local_coincost.coincost_7},
	{id=30, level=30, rate=6500, rateClient=6500, failLevel=28, tips="失败退到28级", coincost=local_coincost.coincost_7},
	{id=31, level=31, rate=6500, rateClient=6500, failLevel=28, tips="失败退到28级", coincost=local_coincost.coincost_7},
	{id=32, level=32, rate=6500, rateClient=6500, failLevel=28, tips="失败退到28级", coincost=local_coincost.coincost_7},
	{id=33, level=33, rate=6000, rateClient=6000, failLevel=32, coincost=local_coincost.coincost_8},
	{id=34, level=34, rate=6000, rateClient=6000, failLevel=32, tips="失败退到32级", coincost=local_coincost.coincost_8},
	{id=35, level=35, rate=6000, rateClient=6000, failLevel=32, tips="失败退到32级", coincost=local_coincost.coincost_8},
	{id=36, level=36, rate=6000, rateClient=6000, failLevel=32, tips="失败退到32级", coincost=local_coincost.coincost_8},
	{id=37, level=37, rate=5500, rateClient=5500, failLevel=36, coincost=local_coincost.coincost_8},
	{id=38, level=38, rate=5500, rateClient=5500, failLevel=36, tips="失败退到36级", coincost=local_coincost.coincost_8},
	{id=39, level=39, rate=5500, rateClient=5500, failLevel=36, tips="失败退到36级", coincost=local_coincost.coincost_8},
	{id=40, level=40, rate=5500, rateClient=5500, failLevel=36, tips="失败退到36级", coincost=local_coincost.coincost_8},
	{id=2001, costGroupId=2, description="首饰消耗", level=1, muneType=1, rate=0, rateClient=0, firstRate=0, cost=local_cost.cost_1, coincost=local_coincost.coincost_1, appendCost=local_appendCost.appendCost_3},
	{id=2002, costGroupId=2, description="首饰消耗", level=2, muneType=1, rate=0, rateClient=0, firstRate=0, cost=local_cost.cost_1, coincost=local_coincost.coincost_1, appendCost=local_appendCost.appendCost_1},
	{id=2003, costGroupId=2, description="首饰消耗", level=3, muneType=1, rate=0, rateClient=0, firstRate=0, cost=local_cost.cost_1, coincost=local_coincost.coincost_1, appendCost=local_appendCost.appendCost_1},
	{id=2004, costGroupId=2, description="首饰消耗", level=4, muneType=1, rate=0, rateClient=0, firstRate=0, cost=local_cost.cost_1, coincost=local_coincost.coincost_1, appendCost=local_appendCost.appendCost_1},
	{id=2005, costGroupId=2, description="首饰消耗", level=5, muneType=1, rate=0, rateClient=0, firstRate=0, cost=local_cost.cost_1, coincost=local_coincost.coincost_1, appendCost=local_appendCost.appendCost_1},
	{id=2006, costGroupId=2, description="首饰消耗", level=6, muneType=1, rate=0, rateClient=0, firstRate=0, cost=local_cost.cost_1, coincost=local_coincost.coincost_1, appendCost=local_appendCost.appendCost_1},
	{id=2007, costGroupId=2, description="首饰消耗", level=7, muneType=1, rate=0, rateClient=0, firstRate=0, cost=local_cost.cost_1, coincost=local_coincost.coincost_1, appendCost=local_appendCost.appendCost_1},
	{id=2008, costGroupId=2, description="首饰消耗", level=8, muneType=1, rate=0, rateClient=0, firstRate=0, cost=local_cost.cost_1, coincost=local_coincost.coincost_1, appendCost=local_appendCost.appendCost_1},
	{id=2009, costGroupId=2, description="首饰消耗", level=9, muneType=1, rate=0, rateClient=0, firstRate=0, cost=local_cost.cost_1, coincost=local_coincost.coincost_1, appendCost=local_appendCost.appendCost_1},
	{id=2010, costGroupId=2, description="首饰消耗", level=10, rate=9000, rateClient=9000, failLevel=8, tips="失败退到8级", cost=local_cost.cost_2},
	{id=2011, costGroupId=2, description="首饰消耗", level=11, rate=9000, rateClient=9000, failLevel=8, tips="失败退到8级", cost=local_cost.cost_2},
	{id=2012, costGroupId=2, description="首饰消耗", level=12, rate=9000, rateClient=9000, failLevel=8, tips="失败退到8级", cost=local_cost.cost_2},
	{id=2013, costGroupId=2, description="首饰消耗", level=13, rate=8500, rateClient=8500, failLevel=12, cost=local_cost.cost_3},
	{id=2014, costGroupId=2, description="首饰消耗", level=14, rate=8500, rateClient=8500, failLevel=12, tips="失败退到12级", cost=local_cost.cost_3},
	{id=2015, costGroupId=2, description="首饰消耗", level=15, rate=8500, rateClient=8500, failLevel=12, tips="失败退到12级", cost=local_cost.cost_3},
	{id=2016, costGroupId=2, description="首饰消耗", level=16, rate=8500, rateClient=8500, failLevel=12, tips="失败退到12级", cost=local_cost.cost_3},
	{id=2017, costGroupId=2, description="首饰消耗", level=17, rate=8000, rateClient=8000, failLevel=16, cost=local_cost.cost_4},
	{id=2018, costGroupId=2, description="首饰消耗", level=18, rate=8000, rateClient=8000, failLevel=16, tips="失败退到16级", cost=local_cost.cost_4},
	{id=2019, costGroupId=2, description="首饰消耗", level=19, rate=8000, rateClient=8000, failLevel=16, tips="失败退到16级", cost=local_cost.cost_4},
	{id=2020, costGroupId=2, description="首饰消耗", level=20, rate=8000, rateClient=8000, failLevel=16, tips="失败退到16级", cost=local_cost.cost_4},
	{id=2021, costGroupId=2, description="首饰消耗", level=21, rate=7500, rateClient=7500, failLevel=20},
	{id=2022, costGroupId=2, description="首饰消耗", level=22, rate=7500, rateClient=7500, failLevel=20, tips="失败退到20级"},
	{id=2023, costGroupId=2, description="首饰消耗", level=23, rate=7500, rateClient=7500, failLevel=20, tips="失败退到20级"},
	{id=2024, costGroupId=2, description="首饰消耗", level=24, rate=7500, rateClient=7500, failLevel=20, tips="失败退到20级"},
	{id=2025, costGroupId=2, description="首饰消耗", level=25, failLevel=24},
	{id=2026, costGroupId=2, description="首饰消耗", level=26, failLevel=24, tips="失败退到24级"},
	{id=2027, costGroupId=2, description="首饰消耗", level=27, failLevel=24, tips="失败退到24级"},
	{id=2028, costGroupId=2, description="首饰消耗", level=28, failLevel=24, tips="失败退到24级"},
	{id=2029, costGroupId=2, description="首饰消耗", level=29, failLevel=28},
	{id=2030, costGroupId=2, description="首饰消耗", level=30, failLevel=28, tips="失败退到28级"},
	{id=2031, costGroupId=2, description="首饰消耗", level=31, failLevel=28, tips="失败退到28级"},
	{id=2032, costGroupId=2, description="首饰消耗", level=32, failLevel=28, tips="失败退到28级"},
	{id=2033, costGroupId=2, description="首饰消耗", level=33, failLevel=32},
	{id=2034, costGroupId=2, description="首饰消耗", level=34, failLevel=32, tips="失败退到32级"},
	{id=2035, costGroupId=2, description="首饰消耗", level=35, failLevel=32, tips="失败退到32级"},
	{id=2036, costGroupId=2, description="首饰消耗", level=36, failLevel=32, tips="失败退到32级"},
	{id=2037, costGroupId=2, description="首饰消耗", level=37, failLevel=36},
	{id=2038, costGroupId=2, description="首饰消耗", level=38, failLevel=36, tips="失败退到36级"},
	{id=2039, costGroupId=2, description="首饰消耗", level=39, failLevel=36, tips="失败退到36级"},
	{id=2040, costGroupId=2, description="首饰消耗", level=40, failLevel=36, tips="失败退到36级"},
}

local defaults = {costGroupId=1, description="通用消耗", muneType=2, rate=7000, rateClient=7000, failLevel=0, firstRate=0, tips="本级失败不掉级", cost={{50030004,8}}, coincost={10020001,0}, appendCost={}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_equip_appendsCost) do
	setmetatable(v, mt)
end

return cfg_equip_appendsCost