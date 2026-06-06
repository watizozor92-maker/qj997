-- 此文件工具自动生成，不要修改
---@class cfg_equip_appendsCost_v2_column
---@field id number @id column=1 A
---描写装备信息，方便查看
---@field description string @描述 column=2 B
---使用该宝石的最低等级限制
---@field level number @追加等级 column=3 C
---追加成功后增加的等级
---@field successLevel number @追加等级 column=4 D
---格式：0（否）/ 1（是）
---备注：当玩家此装备首次强化到该等级时，全服展示跑马灯
---@field firstRate number @是否开启跑马灯 column=5 E
---万分比
---@field rate number @追加成功率（服务端） column=6 F
---万分比
---@field rateClient number @追加成功率（客户端） column=7 G
---追加失败后的等级
---@field failLevel number @追加失败后的等级 column=8 H
---备注：不填表示该强化等级不显示文字提示
---@field tips string @下一阶段文字提示(前端) column=9 I
---消耗道具：道具id#数量
---@field costTag IntList @消耗道具 column=10 J

local local_costTag = {
    costTag_1={1253000499,1},
    costTag_2={50030004,1},

}

local cfg_equip_appendsCost_v2 =
{
	{id=1, description="生命宝石+1", tips="失败退到0级"},
	{id=2, description="生命宝石+2", tips="失败退到0级", costTag=local_costTag.costTag_2},
	{id=5, description="生命宝石+3", tips="本级失败不掉级"},
	{id=6, description="生命宝石+4", tips="本级失败不掉级", costTag=local_costTag.costTag_2},
}

local defaults = {level=0, successLevel=1, firstRate=0, rate=5000, rateClient=5000, failLevel=0, costTag={1253000499,1}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_equip_appendsCost_v2) do
	setmetatable(v, mt)
end

return cfg_equip_appendsCost_v2