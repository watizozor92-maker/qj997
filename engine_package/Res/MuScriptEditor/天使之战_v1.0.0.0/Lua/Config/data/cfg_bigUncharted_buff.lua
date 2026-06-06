-- 此文件工具自动生成，不要修改
---@class cfg_bigUncharted_buff_column
---唯一ID
---@field id number @唯一id column=1 A
---策划备注
---[[客户端不使用]]@field cehua string @备注 column=2 B
---对应钥匙等级可抢网的副本
---@field text string @描述 column=3 C
---1：小怪类型
---2：BOSS类型
---3：小怪+BOSS
---@field type number @增幅对象 column=4 D
---关联att_info的ID，不填则怪物全属性增幅
---@field att IntList @增幅属性 column=5 E
---增幅上限#增幅下限，中间取一个数值，所有属性用该增幅
---万分比
---@field attNumber IntList @增幅区间 column=6 F

local local_attNumber = {
    attNumber_1={2000,3000},

}

local cfg_bigUncharted_buff =
{
	{id=1, text="今日秘境挑战：小怪血量+%s", type=1, att={207011}},
	{id=2, text="今日秘境挑战：BOSS攻击+%s", type=2, att={201011,201021}},
	{id=3, text="今日秘境挑战：所有怪物属性+%s", type=3, attNumber={1000,2000}},
}

local defaults = {att={201011,201021,207011}, attNumber={2000,3000}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_bigUncharted_buff) do
	setmetatable(v, mt)
end

return cfg_bigUncharted_buff