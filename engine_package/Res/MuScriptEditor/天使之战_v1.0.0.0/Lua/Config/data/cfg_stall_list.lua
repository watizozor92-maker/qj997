-- 此文件工具自动生成，不要修改
---@class cfg_stall_list_column
---@field id number @编号 column=1 A
---1.对应父类别id，不可填空
---2.注意 “0”“100”“200”对应“全部”“公示区”“预购”id已使用，不要复用  
---@field typeid number @父类别id column=2 B
---对应父类别名称
---@field typename string @父类别名称 column=3 C
---子类别id，无子类别时填0（除全部、公示区、预购）
---@field subtypeid number @子类别id column=4 D
---1无子类别，点击不展开，子类别id填空。
---0或空有子列别
---@field nosubtype number @无子类别标识 column=5 E
---无子类别时填空
---@field subtypename string @子类别名称 column=6 F
---[[客户端不使用]]@field   @ column=7 G
---[[客户端不使用]]@field   @ column=8 H
---[[客户端不使用]]@field   @ column=9 I
---[[客户端不使用]]@field   @ column=10 J
---[[客户端不使用]]@field   @ column=11 K
---[[客户端不使用]]@field   @ column=12 L
---[[客户端不使用]]@field   @ column=13 M
---[[客户端不使用]]@field   @ column=14 N
---[[客户端不使用]]@field   @ column=15 O
---[[客户端不使用]]@field   @ column=16 P
---[[客户端不使用]]@field   @ column=17 Q
---[[客户端不使用]]@field   @ column=18 R
---[[客户端不使用]]@field   @ column=19 S
---[[客户端不使用]]@field   @ column=20 T
---[[客户端不使用]]@field   @ column=21 U
---[[客户端不使用]]@field   @ column=22 V
---[[客户端不使用]]@field   @ column=23 W
---[[客户端不使用]]@field   @ column=24 X
---[[客户端不使用]]@field   @ column=25 Y
---[[客户端不使用]]@field   @ column=26 A
local cfg_stall_list =
{
	{id=0, typeid=0, typename="全部", nosubtype=1},
	{id=100, typeid=100, typename="公示区", nosubtype=1},
	{id=200, typeid=200, typename="预购", nosubtype=1},
	{id=20002, subtypeid=1, subtypename="武器"},
	{id=20003, subtypeid=2, subtypename="头盔"},
	{id=20004, subtypeid=3, subtypename="铠甲"},
	{id=20005, subtypeid=4, subtypename="护腿"},
	{id=20006, subtypeid=5, subtypename="护手"},
	{id=20007, subtypeid=6, subtypename="靴子"},
	{id=20008, subtypeid=7, subtypename="翅膀"},
	{id=20009, subtypeid=8, subtypename="守护"},
	{id=20010, subtypeid=9, subtypename="项链"},
	{id=20011, subtypeid=10, subtypename="指环"},
	{id=20012, subtypeid=11, subtypename="玛雅武器"},
	{id=20013, subtypeid=13, subtypename="坐骑"},
	{id=40001, typeid=4, typename="材料", subtypeid=1, subtypename="宝石"},
	{id=40002, typeid=4, typename="材料", subtypeid=2, subtypename="门票材料"},
	{id=40003, typeid=4, typename="材料", subtypeid=3, subtypename="翅膀材料"},
	{id=40005, typeid=4, typename="材料", subtypeid=4, subtypename="技能书"},
	{id=40006, typeid=4, typename="材料", subtypeid=5, subtypename="宝箱"},
	{id=50001, typeid=6, typename="货币", nosubtype=1},
}

local defaults = {typeid=2, typename="装备", subtypeid=0, nosubtype=0, subtypename=""}
local mt = {__index = defaults}
for _, v in ipairs(cfg_stall_list) do
	setmetatable(v, mt)
end

return cfg_stall_list