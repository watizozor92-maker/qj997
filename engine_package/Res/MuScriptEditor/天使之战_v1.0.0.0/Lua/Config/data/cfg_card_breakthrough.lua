-- 此文件工具自动生成，不要修改
---@class cfg_card_breakthrough_column
---填写变身卡牌道具id
---@field id number @唯一id column=1 A
---策划备注
---[[客户端不使用]]@field remarks string @备注 column=2 B
---格式：卡牌道具id#权重|卡牌道具id#权重
---@field result IntListList @突破后卡牌 column=3 C
---突破消耗同级卡牌数量
---@field expend number @突破消耗 column=4 D
---突破成功概率
---单位：万比
---@field probability number @突破概率 column=5 E
---突破失败所增加的幸运值，满一百后百分百成功
---填0则不显示
---@field luckPoint number @幸运值 column=6 F

local local_result = {
    result_1={{80010211,50},{80010221,50}},
    result_2={{80010311,50},{80010321,50}},

}

local cfg_card_breakthrough =
{
	{id=80010115},
	{id=80010125},
	{id=80010215, result=local_result.result_2},
	{id=80010225, result=local_result.result_2},
	{id=80020115, result={{80020211,1}}},
	{id=80020215, result={{80020311,1}}},
	{id=80030115, result={{80030211,1}}},
	{id=80030215, result={{80030311,1}}},
}

local defaults = {result={{80010211,50},{80010221,50}}, expend=2, probability=10000, luckPoint=0}
local mt = {__index = defaults}
for _, v in ipairs(cfg_card_breakthrough) do
	setmetatable(v, mt)
end

return cfg_card_breakthrough