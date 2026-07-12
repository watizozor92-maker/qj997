-- 此文件工具自动生成，不要修改
---@class cfg_buff_Calculation_column
---buff ID
---@field id number @buff ID column=1 A
---@field beizhu string @备注名称 column=2 B
---1、公式计算,配置后面的参数
---2、数值按等级读表cfg_jinglingmmBUFF
---@field type number @类型 column=3 C
---同组id 两buff属性同时生效时，取数值最大的buff生效
---@field group number @buff同源替换组 column=4 D
---buff值=等级*系数+属性公式值
---@field level number @等级系数 column=5 E
---属性公式值=基础值+属性id#万分比+属性id#万分比
---配置：基础值|属性id#万分比|属性id#万分比
---@field att IntListList @属性公式 column=6 F
---时间公式值=基础值+属性id#万分比+属性id#万分比
---配置：基础值|属性id#万分比|属性id#万分比
---秒数
---@field time IntListList @时间公式 column=7 G

local local_att = {
    att_1={},

}

local local_time = {
    time_1={},

}

local cfg_buff_Calculation =
{
	{id=110000701, beizhu="生命之光", group=1},
	{id=120001101, beizhu="守护之魂", group=2, att={{1000},{10002,20000},{10003,5000}}},
	{id=130000401, beizhu="守护之光", group=3, att={{2},{10003,1250}}},
	{id=130000301, beizhu="战神之力", group=4, att={{3},{10003,1428}}},
	{id=110000708, beizhu="生命之光（精灵MM）", type=2, group=1, att=local_att.att_1},
	{id=120001108, beizhu="守护之魂（精灵MM）", type=2, group=2, att=local_att.att_1},
	{id=130000408, beizhu="守护之光（精灵MM）", type=2, group=3, att=local_att.att_1},
	{id=130000308, beizhu="战神之力（精灵MM）", type=2, group=4, att=local_att.att_1},
	{id=101401012, beizhu="致命圣印", group=5, att={{500},{10005,11111}}},
}

local defaults = {type=1, level=0, att={{1200},{10004,10000},{10003,50000}}, time={}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_buff_Calculation) do
	setmetatable(v, mt)
end

return cfg_buff_Calculation