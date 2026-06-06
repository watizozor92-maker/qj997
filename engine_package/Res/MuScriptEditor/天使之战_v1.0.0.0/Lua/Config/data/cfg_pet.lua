-- 此文件工具自动生成，不要修改
---@class cfg_pet_column
---技能id+两位编号
---[[客户端不使用]]@field id number @召唤兽id column=1 A
---策划备注
---[[客户端不使用]]@field name string @名称 column=2 B
---参数1：1装备、2技能
---参数2：装备id/技能id
---参数3：技能等级
---示例：1#20055，2#10101#1
---[[客户端不使用]]@field condition IntListList @激活条件 column=3 C
---对应cfg_monster表id
---[[客户端不使用]]@field mid number @怪物id column=4 D
---召唤兽根据角色属性进行增加
---格式：属性ID#加成比率（万比）
---[[客户端不使用]]@field attributeRole intLis @角色继承属性加成 column=5 E
---（Buffid调用cfg_buff表id）多个Buff按配置顺序排队触发
---格式：Buffid#权重&Buffid#权重|Buffid#权重&Buffid#权重；
---@field buffid IntListList @buffID column=6 F

local local_buffid = {
    buffid_1={},
    buffid_2={{130000411,1}},
    buffid_3={{130000412,1}},

}

local cfg_pet =
{
	{},
	{},
	{},
	{buffid=local_buffid.buffid_2},
	{buffid=local_buffid.buffid_3},
	{},
	{},
	{},
	{buffid=local_buffid.buffid_2},
	{buffid=local_buffid.buffid_3},
	{},
	{},
	{},
	{buffid=local_buffid.buffid_2},
	{buffid=local_buffid.buffid_3},
	{},
	{},
	{},
	{buffid=local_buffid.buffid_2},
	{buffid=local_buffid.buffid_3},
	{},
	{},
	{},
	{buffid=local_buffid.buffid_2},
	{buffid=local_buffid.buffid_3},
	{},
	{},
	{},
	{buffid=local_buffid.buffid_2},
	{buffid=local_buffid.buffid_3},
	{},
	{},
	{},
	{buffid=local_buffid.buffid_2},
	{buffid=local_buffid.buffid_3},
	{},
}

local defaults = {buffid={}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_pet) do
	setmetatable(v, mt)
end

return cfg_pet