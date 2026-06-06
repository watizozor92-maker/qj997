-- 此文件工具自动生成，不要修改
---@class cfg_equip_quality_column
---排列序号
---id需要连续，不可在中间断掉
---@field id number @id column=1 A
---评分区间
---格式：评分下限#评分上限
---@field stage IntList @评分等级 column=2 B
---策划用
---@field name string @备注 column=3 C
---装备可拥有词条下限
---程序生成装备时使用 决定装备在该品阶最少拥有的词条数量
---@field minimum number @词条下限 column=4 D
---装备可拥有词条上限
---程序生成装备时使用 决定装备在该品阶最多拥有的词条数量
---@field maximums number @词条上限 column=5 E
---装备词条数量：词条数#权重|词条数#权重
---@field count IntListList @词条数量 column=6 F
---装备左上角附加logo
---直接填资源文件名
---@field logo string @附加logo column=7 G

local local_count = {
    count_1={{1,50},{2,50}},

}

local cfg_equip_quality =
{
	{id=1, stage={0,99}, name="白装", minimum=0, maximums=0, count={{0,100}}, logo=""},
	{id=2, stage={100,299}, name="卓越", minimum=1, maximums=2, logo="img_icon_excellent"},
	{id=3, stage={300,399}, name="套装", minimum=1, maximums=4, logo="img_icon_suit"},
}

local defaults = {count={{1,50},{2,50}}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_equip_quality) do
	setmetatable(v, mt)
end

return cfg_equip_quality