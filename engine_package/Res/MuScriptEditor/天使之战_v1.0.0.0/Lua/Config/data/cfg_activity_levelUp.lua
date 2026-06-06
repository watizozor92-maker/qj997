-- 此文件工具自动生成，不要修改
---@class cfg_activity_levelUp_column
---@field id number @唯一id column=1 A
---@field level number @等级条件 column=2 B
---不配则不限制
---@field Places string @限定名额 column=3 C
---职业id#道具id#数量|职业id#道具id#数量
---@field basicItem IntListList @普通道具奖励 column=4 D
---满足时显示已激活
---@field conditions string @特殊奖励满足条件 column=5 E
---职业id#道具id#数量|职业id#道具id#数量
---@field specialItem IntList @特殊道具奖励 column=6 F
---职业id#道具id#数量|职业id#道具id#数量
---@field specialTips string @特殊道具文本 column=7 G
---@field specialButton string @特殊按钮文字 column=8 H

local local_basicItem = {
    basicItem_1={{10050001,100},{50030002,2},{10020001,1000}},

}

local local_specialItem = {
    specialItem_1={10040001,300},

}

local cfg_activity_levelUp =
{
	{id=1001, level=50, conditions="1201#1", specialTips="vip1专属", specialButton="成为vip1"},
	{id=1002, level=75, specialTips="vip2专属", specialButton="成为vip2"},
	{id=1003, level=100, basicItem={{10050001,200},{50030002,5},{10020001,2000}}, specialItem={10040001,500}, specialTips="vip2专属", specialButton="成为vip2"},
	{id=1004, level=125, basicItem={{10050001,200},{50030002,5},{50040076,20}}, conditions="1201#3", specialItem={10040001,800}, specialTips="vip3专属", specialButton="成为vip3"},
	{id=1005, level=150, basicItem={{10050001,200},{50030003,3},{50040077,40}}, conditions="1201#3", specialItem={10040001,1000}, specialTips="vip3专属", specialButton="成为vip3"},
	{id=1006, level=175, basicItem={{10050001,500},{50030003,5},{50040075,40}}, conditions="1201#4", specialItem={10040001,1200}, specialTips="vip4专属", specialButton="成为vip4"},
	{id=1007, level=200, basicItem={{10050001,500},{50030004,3},{50040061,100}}, conditions="1201#4", specialItem={10040001,1500}, specialTips="vip4专属", specialButton="成为vip4"},
	{id=1008, level=225, basicItem={{10050001,800},{50030004,5},{50040061,200}}, conditions="1201#5", specialItem={10040001,2000}, specialTips="vip5专属", specialButton="成为vip5"},
	{id=1009, level=250, basicItem={{10050001,800},{50030004,8},{50040028,300}}, conditions="1201#6", specialItem={10040001,3000}, specialTips="vip6专属", specialButton="成为vip6"},
	{id=1010, level=275, Places="30", basicItem={{10050001,800},{50030005,2},{50040028,600}}, conditions="1201#6", specialItem={10040001,5000}, specialTips="vip6专属", specialButton="成为vip6"},
	{id=1011, level=300, Places="5", basicItem={{10050001,800},{50030005,5},{50040097,300}}, conditions="1201#7", specialItem={10040001,10000}, specialTips="vip7专属", specialButton="成为vip7"},
}

local defaults = {Places="", basicItem={{10050001,100},{50030002,2},{10020001,1000}}, conditions="1201#2", specialItem={10040001,300}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_activity_levelUp) do
	setmetatable(v, mt)
end

return cfg_activity_levelUp