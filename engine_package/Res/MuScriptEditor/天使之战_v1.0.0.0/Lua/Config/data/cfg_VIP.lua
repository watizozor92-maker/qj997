-- 此文件工具自动生成，不要修改
---@class cfg_VIP_column
---@field id number @id column=1 A
---@field grade number @VIP等级 column=2 B
---@field VIPpack number @VIP礼包 column=3 C
---@field expack number @专属礼包 column=4 D
---@field greatpack number @超值礼包 column=5 E
---覆盖式
---@field goldway IntList @黄金线路 column=6 F
---覆盖式
---@field tqboss number @特权boss column=7 G
---覆盖式
---@field rate IntList @攻速加成 column=8 H
---叠加式
---@field castle IntList @血色城堡每日次数 column=9 I
---叠加式
---@field plaza IntList @恶魔广场每日次数 column=10 J
---覆盖式
---@field exp IntList @经验加成 column=11 K
---叠加式
---@field attributepoint IntList @赠送额外属性点 column=12 L
---覆盖式
---@field recycle number @回收金币提升 column=13 M
---覆盖式
---@field explosiverate IntList @卓越装爆率提升 column=14 N
---覆盖式
---@field tax number @交易行税率下降 column=15 O
---@field text string @特权描述 column=16 P

local local_castle = {
    castle_1={},

}

local local_plaza = {
    plaza_1={10001,0},
    plaza_2={10001,1},

}

local local_attributepoint = {
    attributepoint_1={10070001,30},
    attributepoint_2={10070001,50},

}

local cfg_VIP =
{
	{id=1, grade=1, VIPpack=811, expack=821, greatpack=831, goldway={1208,1308,1209,1309,1260,1360}, rate={213011,3}, plaza=local_plaza.plaza_2, exp={325012,1000}, attributepoint=local_attributepoint.attributepoint_1, explosiverate={319032,10}},
	{id=2, grade=2, VIPpack=812, expack=822, greatpack=832, goldway={1208,1308,1209,1309,1260,1360,1234,1334,1311,1411,1511,1238,1338}, rate={213011,6}, exp={325012,2500}, attributepoint=local_attributepoint.attributepoint_1, explosiverate={319032,25}, text="会员额外属性点：<color=#e6e600>60</color>\n<color=#00FF00>(可提前穿戴高阶装备)</color>|等级地图黄金线路解锁：<color=#e6e600>LV.65-LV.200</color>\n<color=#00FF00>(专属地图抢怪无压力)</color>|角色基础攻速提升：<color=#e6e600>4%</color>|VIP特权经验加成：<color=#e6e600>25%</color>|卓越装备爆率提升：<color=#e6e600>25%</color>|特权BOSS每日额外挑战次数：<color=#e6e600>1</color>|血色城堡、恶魔广场每日额外挑战次数：<color=#e6e600>1</color>"},
	{id=3, grade=3, VIPpack=813, expack=823, greatpack=833, goldway={1208,1308,1209,1309,1260,1360,1234,1334,1311,1411,1511,1238,1338,1239,1339,1358,1458,1558,1157}, rate={213011,9}, exp={325012,4000}, attributepoint={10070001,40}, explosiverate={319032,40}, text="会员额外属性点：<color=#e6e600>100</color>\n<color=#00FF00>(可提前穿戴高阶装备)</color>|等级地图黄金线路解锁：<color=#e6e600>LV.65-LV.350</color>\n<color=#00FF00>(专属地图抢怪无压力)</color>|角色基础攻速提升：<color=#e6e600>6%</color>|VIP特权经验加成：<color=#e6e600>40%</color>|卓越装备爆率提升：<color=#e6e600>40%</color>|特权BOSS每日额外挑战次数：<color=#e6e600>1</color>|血色城堡、恶魔广场每日额外挑战次数：<color=#e6e600>1</color>"},
	{id=4, grade=4, VIPpack=814, expack=824, greatpack=834, goldway={1208,1308,1209,1309,1260,1360,1234,1334,1311,1411,1511,1238,1338,1239,1339,1358,1458,1558,1157,12000,12001,12002}, rate={213011,15}, plaza=local_plaza.plaza_2, exp={325012,6000}, explosiverate={319032,60}, text="会员额外属性点：<color=#e6e600>150</color>\n<color=#00FF00>(可提前穿戴高阶装备)</color>|等级地图黄金线路解锁：<color=#e6e600>LV.65-LV.500</color>\n<color=#00FF00>(专属地图抢怪无压力)</color>|角色基础攻速提升：<color=#e6e600>10%</color>|VIP特权经验加成：<color=#e6e600>60%</color>|卓越装备爆率提升：<color=#e6e600>60%</color>|特权BOSS每日额外挑战次数：<color=#e6e600>1</color>|血色城堡、恶魔广场每日额外挑战次数：<color=#e6e600>2</color>"},
	{id=5, grade=5, VIPpack=815, expack=825, greatpack=835, goldway={1208,1308,1209,1309,1260,1360,1234,1334,1311,1411,1511,1238,1338,1239,1339,1358,1458,1558,1157,12000,12001,12002,12003,12004,12005}, rate={213011,20}, exp={325012,9000}, explosiverate={319032,90}, text="会员额外属性点：<color=#e6e600>200</color>\n<color=#00FF00>(可提前穿戴高阶装备)</color>|等级地图黄金线路解锁：<color=#e6e600>LV.65-LV.650</color>\n<color=#00FF00>(专属地图抢怪无压力)</color>|角色基础攻速提升：<color=#e6e600>13%</color>|VIP特权经验加成：<color=#e6e600>90%</color>|卓越装备爆率提升：<color=#e6e600>90%</color>|特权BOSS每日额外挑战次数：<color=#e6e600>1</color>|血色城堡、恶魔广场每日额外挑战次数：<color=#e6e600>2</color>"},
	{id=6, grade=6, VIPpack=816, expack=826, greatpack=836, goldway={1208,1308,1209,1309,1260,1360,1234,1334,1311,1411,1511,1238,1338,1239,1339,1358,1458,1558,1157,12000,12001,12002,12003,12004,12005,12006,12007,12008}, rate={213011,25}, plaza=local_plaza.plaza_2, exp={325012,12000}, explosiverate={319032,120}, text="会员额外属性点：<color=#e6e600>250</color>\n<color=#00FF00>(可提前穿戴高阶装备)</color>|等级地图黄金线路解锁：<color=#e6e600>LV.65-LV.800</color>\n<color=#00FF00>(专属地图抢怪无压力)</color>|角色基础攻速提升：<color=#e6e600>16%</color>|VIP特权经验加成：<color=#e6e600>120%</color>|卓越装备爆率提升：<color=#e6e600>120%</color>|特权BOSS每日额外挑战次数：<color=#e6e600>1</color>|血色城堡、恶魔广场每日额外挑战次数：<color=#e6e600>3</color>"},
	{id=7, grade=7, VIPpack=817, expack=827, greatpack=837, rate={213011,30}, exp={325012,15000}, explosiverate={319032,150}, text="会员额外属性点：<color=#e6e600>300</color>\n<color=#00FF00>(可提前穿戴高阶装备)</color>|等级地图黄金线路解锁：<color=#e6e600>LV.65-LV.1000</color>\n<color=#00FF00>(专属地图抢怪无压力)</color>|角色基础攻速提升：<color=#e6e600>20%</color>|VIP特权经验加成：<color=#e6e600>150%</color>|卓越装备爆率提升：<color=#e6e600>150%</color>|特权BOSS每日额外挑战次数：<color=#e6e600>1</color>|血色城堡、恶魔广场每日额外挑战次数：<color=#e6e600>3</color>"},
}

local defaults = {goldway={1208,1308,1209,1309,1260,1360,1234,1334,1311,1411,1511,1238,1338,1239,1339,1358,1458,1558,1157,12000,12001,12002,12003,12004,12005,12006,12007,12008,12009,12010,12011,12012}, tqboss=1, castle={}, plaza={10001,0}, attributepoint={10070001,50}, recycle=0, tax=0, text="会员额外属性点：<color=#e6e600>30</color>\n<color=#00FF00>(可提前穿戴高阶装备)</color>|等级地图黄金线路解锁：<color=#e6e600>LV.65-LV.130</color>\n<color=#00FF00>(专属地图抢怪无压力)</color>|角色基础攻速提升：<color=#e6e600>2%</color>|VIP特权经验加成：<color=#e6e600>10%</color>|卓越装备爆率提升：<color=#e6e600>10%</color>|特权BOSS每日额外挑战次数：<color=#e6e600>1</color>|血色城堡、恶魔广场每日额外挑战次数：<color=#e6e600>1</color>"}
local mt = {__index = defaults}
for _, v in ipairs(cfg_VIP) do
	setmetatable(v, mt)
end

return cfg_VIP