-- 此文件工具自动生成，不要修改
---@class cfg_model_default_column
---唯一ID
---1=战士，2=法师，3=弓箭，4=魔剑，5=圣导，6=召唤
---@field id number @编号 column=1 A
---身体骨骼
---@field body number @身体骨骼 column=2 B
---头盔
---@field head number @头部 column=3 C
---盔甲
---@field armor number @身体 column=4 D
---手套
---@field hand number @手 column=5 E
---裤子
---@field pants number @裤子 column=6 F
---鞋子
---@field boot number @鞋子 column=7 G
---影子
---@field shadow number @影子 column=8 H
---策划自用
---[[客户端不使用]]@field remark string @备注 column=9 I
local cfg_model_default =
{
	{id=1, body=20230001, head=201101011, armor=20020002, hand=200901011, pants=201501011, boot=200501011},
	{id=2, head=201102011, armor=20020001, hand=200902011, pants=201502011, boot=200502011},
	{id=3, body=20230003, head=201103011, armor=20020003, hand=200903011, pants=201503011, boot=200503011},
	{id=4, body=20230001, head=20100004, armor=20020004, hand=20090009, pants=20150044, boot=20050004},
	{id=5, head=20100005, armor=20020005, hand=20090010, pants=20150045, boot=20050005},
	{id=6, body=20230003, head=20100006, armor=20020006, hand=20090011, pants=20150046, boot=20050006},
	{id=7, head=20110080, armor=20020017, hand=20090022, pants=20150057, boot=20050017},
	{id=101, body=20230001, head=20400011, armor=20600011, hand=20700011, pants=20900011, boot=20900011},
	{id=102, head=20400031, armor=20600031, hand=20700031, pants=20800031, boot=20900031},
	{id=103, body=20230003, head=20400141, armor=20600141, hand=20700141, pants=20800141, boot=20900141},
	{id=201, body=20230001, head=20110071, armor=20020008, hand=20090013, pants=20150048, boot=20050008},
	{id=202, head=20110070, armor=20020007, hand=20090012, pants=20150047, boot=20050007},
	{id=203, body=20230003, head=20110072, armor=20020009, hand=20090014, pants=20150049, boot=20050009},
	{id=301, body=20230001, head=20110075, armor=20020012, hand=20090017, pants=20150052, boot=20050012},
	{id=302, head=20110074, armor=20020011, hand=20090016, pants=20150051, boot=20050011},
	{id=303, body=20230003, head=20110076, armor=20020013, hand=20090018, pants=20150053, boot=20050013},
}

local defaults = {body=20230002, shadow=20170001}
local mt = {__index = defaults}
for _, v in ipairs(cfg_model_default) do
	setmetatable(v, mt)
end

return cfg_model_default