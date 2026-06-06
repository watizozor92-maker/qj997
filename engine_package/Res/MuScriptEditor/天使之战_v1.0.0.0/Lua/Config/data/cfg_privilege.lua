-- 此文件工具自动生成，不要修改
---@class cfg_privilege_column
---@field id number @序列 column=1 A
---@field name string @名称 column=2 B
---特权功能类型，用于区分特权所属功能  1=月卡特权  2=特权卡
---@field type number @特权功能类型 column=3 C
---特权子类型，同类型的重复生效不会叠加效果，只叠加时间
---1=白银特权卡
---2=黄金特权卡
---3=钻石特权卡
---4=回收特权卡
---11=畅玩月卡
---12=尊享年卡
---@field minType number @子类型 column=4 D
---特权卡对应道具id
---@field item number @道具id column=5 E
---仅前端显示用，用于使用buff栏展示特权剩余时间
---@field buff number @buff id column=6 F
---buff增益效果的持续时间填
---格式:单位（分钟）
---填空表示永久生效
---@field time number @持续时间 column=7 G
---关联privilege_new表特权id
---注意：由特权卡获得的特权时间 读取特权卡配置的time时间
---@field privilege IntList @关联特权 column=8 H
---(引援cfg_model_charactor表)
---@field field number @外观道具模型 column=9 I
---1：每周限购
---2：永久限购
---不配置则不限购
---@field limitType number @限购类型 column=10 J
---@field limitCount number @限购数量 column=11 K
---@field maxCount number @单次最多购买数量 column=12 L
---价格（消耗月卡剩余时间）
---@field price number @价格 column=13 M

local local_privilege = {
    privilege_1={18,28},

}

local cfg_privilege =
{
	{id=72, name="畅玩卡", type=2, minType=12, item=30031062, buff=30000013, time=43200, field=0, limitType=0, limitCount=0, maxCount=0, price=0},
	{id=73, name="黄金卡(1天)", type=2, minType=12, item=30031063, buff=30000014, time=1440, privilege=local_privilege.privilege_1, field=0, limitType=0, limitCount=0, maxCount=0, price=0},
	{id=74, name="黄金卡(30天)", type=2, minType=12, item=30031064, buff=30000014, time=43200, privilege=local_privilege.privilege_1, field=0, limitType=0, limitCount=0, maxCount=0, price=0},
}

local defaults = {privilege={24,23,2,13,17,16,25,6,18,28}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_privilege) do
	setmetatable(v, mt)
end

return cfg_privilege