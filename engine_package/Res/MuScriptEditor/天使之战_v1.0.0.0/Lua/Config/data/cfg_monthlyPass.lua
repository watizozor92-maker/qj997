-- 此文件工具自动生成，不要修改
---@class cfg_monthlyPass_column
---itemid
---@field id number @序列 column=1 A
---数字越小优先级越高，若同时开通，则按照优先级顺序给予特权
---@field order number @月卡优先级 column=2 B
---@field name string @策划备注 column=3 C
---单位:秒
---@field time number @持续时间 column=4 D
---@field maxCount number @单次最多购买数量 column=5 E
---1：永久限购
---2：每月限购
---3：每周限购
---4：每日限购
---不配置则不限购
---@field limitType number @限购类型 column=6 F
---@field limitCount number @限购数量 column=7 G
---单位小时
---@field firstInCome number @首次获得时赠送的三倍时间 column=8 H
---单位小时
---@field dayInCome number @每日赠送的三倍时间 column=9 I
---1是 0否
---@field chat number @是否解锁聊天 column=10 J
---1是 0否
---@field stall number @是否解锁交易行 column=11 K
---格式 item表
---类型#子类型|类型#子类型
---@field banType IntListList @不能交易的材料类型 column=12 L
---1是 0否
---@field inCome number @是否解锁三倍收益 column=13 M
---1是 0否
---@field pickUp number @是否解锁自动拾取 column=14 N
---1是 0否
---@field recovery number @是否解锁自动回收 column=15 O
---1是 0否
---@field privilege number @是否解锁兑换特权 column=16 P
local cfg_monthlyPass =
{
	{id=30030306, order=1, name="月卡", time=2592000, maxCount=10, limitType=1, limitCount=0, firstInCome=0, dayInCome=0, chat=0, stall=0, banType={}, inCome=0, pickUp=0, recovery=0, privilege=0},
	{id=30030307, order=2, name="日卡", time=86400, maxCount=10, limitType=1, limitCount=0, firstInCome=0, dayInCome=0, chat=0, stall=0, banType={{5,2}}, inCome=0, pickUp=0, recovery=0, privilege=0},
}
return cfg_monthlyPass