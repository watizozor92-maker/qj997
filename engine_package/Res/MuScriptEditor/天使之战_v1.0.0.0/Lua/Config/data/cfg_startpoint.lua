-- 此文件工具自动生成，不要修改
---@class cfg_startpoint_column
---@field id number @安全区id column=1 A
---@field mapId string @所在地图 column=2 B
---@field name string @地图名称 column=3 C
---@field desc string @备注 column=4 D
---0或空：读取表格字段定义范围（读取point、range、rectRange）
---1：读取编辑器数据；直接读取地图数据，需要将区域中心点（point）配置在编辑器安全区内
---@field dataType number @区域范围生效类别 column=5 E
---1：安全区域，2：BUFF区域
---@field rangeType number @区域类别 column=6 F
---rangeType=2（BUFF），格式：调用cfg_buff表id
---@field rangeValue IntList @区域参数 column=7 G
---0或空：范围内全部目标，1：怪物，2：玩家
---@field targetObject number @目标对象 column=8 H
---区域中心点坐标，格式：X坐标#Y坐标
---@field point IntList @区域中心点坐标 column=9 I
---R距离
---@field range number @圆形范围 column=10 J
---长+宽（若圆形和矩形都配，则重叠生效）
---@field rectRange IntList @矩形范围 column=11 K
---安全区框框的特效外观代码
---
---引援model_effect表
---@field effectID number @外观代码 column=12 L
---0=不禁止,1=禁止
---@field throwItem number @禁止丢物 column=13 M
---0=不禁止,1=禁止
---@field isSafeNoMount number @禁止骑乘 column=14 N
---0=不禁止,1=禁止
---@field isSafeNoRun number @禁止奔跑 column=15 O
---0=不禁止,1=禁止
---@field isSafeNoMonster number @禁止怪物入内 column=16 P

local local_rangeValue = {
    rangeValue_1={},

}

local local_rectRange = {
    rectRange_1={},
    rectRange_2={24,18},

}

local cfg_startpoint =
{
	{id=1, mapId="1001", name="勇者大陆", point={135,127}, range=5, rectRange={60,60}},
	{id=2, mapId="1004", name="仙踪林", point={175,115}, rectRange=local_rectRange.rectRange_1, throwItem=1, isSafeNoMonster=0},
	{id=3, mapId="1052", name="幻术园", point={51,224}, rectRange=local_rectRange.rectRange_1, throwItem=1, isSafeNoMonster=0},
	{id=4, mapId="1003", name="冰风谷", point={211,40}, rectRange=local_rectRange.rectRange_1, throwItem=1, isSafeNoMonster=0},
	{id=5, mapId="1005", name="失落之塔", point={201,76}, rectRange={30,14}},
	{id=6, mapId="1008", name="亚特兰蒂斯", point={21,17}, range=11},
	{id=7, mapId="1009", name="死亡沙漠", point={210,50}, range=45, rectRange={100,30}},
	{id=8, mapId="1034", name="幽暗森林", point={83,10}, rectRange={22,18}},
	{id=9, mapId="1011", name="坎特鲁废墟", point={30,210}, range=17},
	{id=10, mapId="1038", name="坎特鲁遗址", point={77,107}, rectRange={30,18}},
	{id=11, mapId="1012", name="血色城堡", desc="血色城堡副本", point={14,8}, rectRange=local_rectRange.rectRange_1},
	{id=12, mapId="21000", name="神之国度", point={126,128}, rectRange={50,50}},
	{id=13, mapId="1057", name="安宁池", point={138,19}, rectRange={30,30}},
}

local defaults = {desc="", dataType=1, rangeType=1, rangeValue={}, targetObject=0, range=0, rectRange={24,18}, effectID=0, throwItem=0, isSafeNoMount=1, isSafeNoRun=1, isSafeNoMonster=1}
local mt = {__index = defaults}
for _, v in ipairs(cfg_startpoint) do
	setmetatable(v, mt)
end

return cfg_startpoint