-- 此文件工具自动生成，不要修改
---@class cfg_equip_strengthenCost_v2_column
---@field id number @id column=1 A
---描写装备信息，方便查看
---@field description string @描述 column=2 B
---使用该宝石的最低等级限制
---@field level number @强化等级 column=3 C
---强化成功后增加的等级
---@field successLevel number @强化等级 column=4 D
---万分比
---@field rate number @强化成功率（服务端） column=5 E
---万分比
---@field rateClient number @强化成功率（客户端） column=6 F
---强化失败后的等级
---@field failLevel number @强化失败后的等级 column=7 G
---格式：0（否）/ 1（是）
---备注：当玩家此装备首次强化到该等级时，全服展示跑马灯，玩家个人前端弹窗
---填0则在强化成功时，仅弹出 强化成功的动效
---@field firstRate number @是否开启特效 column=8 H
---备注：不填表示该强化等级不显示文字提示
---@field tips string @文字提示(前端) column=9 I
---消耗道具：道具id#数量
---@field costTag IntList @消耗道具 column=10 J

local local_costTag = {
    costTag_1={1253000399,1},
    costTag_2={50030003,1},

}

local cfg_equip_strengthenCost_v2 =
{
	{id=1, description="祝福宝石", rate=10000, rateClient=10000, tips="本级失败不掉级", costTag={1253000299,1}},
	{id=2, description="灵魂宝石（普通）", rate=6000, rateClient=6000},
	{id=3, description="灵魂宝石（普通）（初始）", rate=6000, rateClient=6000},
	{id=4, description="灵魂宝石（卓越）"},
	{id=5, description="灵魂宝石（卓越）（初始）"},
	{id=6, description="灵魂宝石（套装）"},
	{id=7, description="灵魂宝石（套装）（初始）"},
	{id=8, description="灵魂宝石（镶宝）", rate=4000, rateClient=4000},
	{id=9, description="灵魂宝石（镶宝）（初始）", rate=4000, rateClient=4000},
	{id=10, description="祝福宝石（绑定）", rate=10000, rateClient=10000, tips="本级失败不掉级", costTag={50030002,1}},
	{id=11, description="灵魂宝石（普通）（绑定）", rate=6000, rateClient=6000, costTag=local_costTag.costTag_2},
	{id=12, description="灵魂宝石（普通）（初始）（绑定）", rate=6000, rateClient=6000, costTag=local_costTag.costTag_2},
	{id=13, description="灵魂宝石（卓越）（绑定）", costTag=local_costTag.costTag_2},
	{id=14, description="灵魂宝石（卓越）（初始）（绑定）", costTag=local_costTag.costTag_2},
	{id=15, description="灵魂宝石（套装）（绑定）", costTag=local_costTag.costTag_2},
	{id=16, description="灵魂宝石（套装）（初始）（绑定）", costTag=local_costTag.costTag_2},
	{id=17, description="灵魂宝石（镶宝）（绑定）", rate=4000, rateClient=4000, costTag=local_costTag.costTag_2},
	{id=18, description="灵魂宝石（镶宝）（初始）（绑定）", rate=4000, rateClient=4000, costTag=local_costTag.costTag_2},
}

local defaults = {level=0, successLevel=1, rate=5000, rateClient=5000, failLevel=0, firstRate=0, tips="失败退到0级", costTag={1253000399,1}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_equip_strengthenCost_v2) do
	setmetatable(v, mt)
end

return cfg_equip_strengthenCost_v2