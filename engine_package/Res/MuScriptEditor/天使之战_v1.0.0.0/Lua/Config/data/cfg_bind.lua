-- 此文件工具自动生成，不要修改
---@class cfg_bind_column
---以后新加类型时需要和程序沟通
---@field id number @id column=1 A
---策划看的备注
---@field remark string @备注 column=2 B
---0非绑 1绑定
---@field bind number @状态 column=3 C
---[[客户端不使用]]@field   @ column=4 D
local cfg_bind =
{
	{id=1, remark="系统发放"},
	{id=2, remark="怪物掉落", bind=0},
	{id=3, remark="任务"},
	{id=4, remark="首饰任务"},
	{id=5, remark="商城购买"},
	{id=6, remark="功能预告"},
	{id=7, remark="交易行购买", bind=0},
	{id=8, remark="狼魂要塞"},
	{id=9, remark="赤色要塞"},
	{id=10, remark="每日目标"},
	{id=11, remark="勇气试炼"},
	{id=12, remark="血色城堡"},
	{id=13, remark="开服活动"},
	{id=14, remark="排行榜"},
	{id=15, remark="BOSS悬赏"},
	{id=16, remark="勇士任务"},
}

local defaults = {bind=1}
local mt = {__index = defaults}
for _, v in ipairs(cfg_bind) do
	setmetatable(v, mt)
end

return cfg_bind