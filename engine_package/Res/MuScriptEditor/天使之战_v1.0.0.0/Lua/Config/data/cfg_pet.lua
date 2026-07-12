-- 此文件工具自动生成，不要修改
---@class cfg_pet_column
---技能id+两位编号
---@field id number @召唤兽id column=1 A
---策划备注
---[[客户端不使用]]@field name string @名称 column=2 B
---参数1：1装备、2技能
---参数2：装备id/技能id
---参数3：技能等级
---示例：1#20055，2#10101#1
---@field condition IntListList @激活条件 column=3 C
---对应cfg_monster表id
---[[客户端不使用]]@field mid number @怪物id column=4 D
---召唤兽根据角色属性进行增加
---格式：属性ID#加成比率（万比）
---[[客户端不使用]]@field attributeRole IntListList @角色继承属性加成 column=5 E
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
	{id=130300101},
	{id=130300102, condition={{2,1303001,2}}},
	{id=130300103, condition={{2,1303001,3}}},
	{id=130300104, condition={{2,1303001,4}}, buffid=local_buffid.buffid_2},
	{id=130300105, condition={{2,1303001,5}}, buffid=local_buffid.buffid_3},
	{id=130300201, condition={{2,1303002,1}}},
	{id=130300202, condition={{2,1303002,2}}},
	{id=130300203, condition={{2,1303002,3}}},
	{id=130300204, condition={{2,1303002,4}}, buffid=local_buffid.buffid_2},
	{id=130300205, condition={{2,1303002,5}}, buffid=local_buffid.buffid_3},
	{id=130300301, condition={{2,1303003,1}}},
	{id=130300302, condition={{2,1303003,2}}},
	{id=130300303, condition={{2,1303003,3}}},
	{id=130300304, condition={{2,1303003,4}}, buffid=local_buffid.buffid_2},
	{id=130300305, condition={{2,1303003,5}}, buffid=local_buffid.buffid_3},
	{id=130300401, condition={{2,1303004,1}}},
	{id=130300402, condition={{2,1303004,2}}},
	{id=130300403, condition={{2,1303004,3}}},
	{id=130300404, condition={{2,1303004,4}}, buffid=local_buffid.buffid_2},
	{id=130300405, condition={{2,1303004,5}}, buffid=local_buffid.buffid_3},
	{id=130300501, condition={{2,1303005,1}}},
	{id=130300502, condition={{2,1303005,2}}},
	{id=130300503, condition={{2,1303005,3}}},
	{id=130300504, condition={{2,1303005,4}}, buffid=local_buffid.buffid_2},
	{id=130300505, condition={{2,1303005,5}}, buffid=local_buffid.buffid_3},
	{id=130300601, condition={{2,1303006,1}}},
	{id=130300602, condition={{2,1303006,2}}},
	{id=130300603, condition={{2,1303006,3}}},
	{id=130300604, condition={{2,1303006,4}}, buffid=local_buffid.buffid_2},
	{id=130300605, condition={{2,1303006,5}}, buffid=local_buffid.buffid_3},
	{id=130300701, condition={{2,1303007,1}}},
	{id=130300702, condition={{2,1303007,2}}},
	{id=130300703, condition={{2,1303007,3}}},
	{id=130300704, condition={{2,1303007,4}}, buffid=local_buffid.buffid_2},
	{id=130300705, condition={{2,1303007,5}}, buffid=local_buffid.buffid_3},
	{id=21800001, condition={{1,21800001}}},
}

local defaults = {condition={{2,1303001,1}}, buffid={}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_pet) do
	setmetatable(v, mt)
end

return cfg_pet