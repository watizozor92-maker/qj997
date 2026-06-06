-- 此文件工具自动生成，不要修改
---@class cfg_monthcard_column
---@field id number @id column=1 A
---@field name string @名称 column=2 B
---1畅玩卡
---2至尊卡
---@field group number @分类 column=3 C
---@field itemid IntList @道具id column=4 D
---@field showtext string @道具介绍 column=5 E
---@field cost number @购买消耗 column=6 F
---@field price number @充值表关联 column=7 G
local cfg_monthcard =
{
	{id=1, name="畅玩卡", group=2, itemid={30031062,30032003}, showtext="解锁功能：世界聊天#解锁功能：随身商店#解锁功能：随身仓库#解锁功能：自动回收、拾取#解锁功能：自动维修、买药#解锁功能：交易行上架#解锁功能：面对面交易#解锁功能：材料解绑#解锁功能：宝石解绑#解锁功能：宝石爆率*200%", cost=88, price=3001},
	{id=2, name="至尊卡1天", group=2, itemid={30031063,30032001}, cost=12, price=3002},
	{id=3, name="至尊卡30天", group=2, itemid={30031064,30032003}, cost=328, price=3003},
}

local defaults = {showtext="解锁功能：交易行上架#解锁功能：面对面交易#解锁功能：材料解绑#解锁功能：宝石解绑#解锁功能：宝石爆率*200%"}
local mt = {__index = defaults}
for _, v in ipairs(cfg_monthcard) do
	setmetatable(v, mt)
end

return cfg_monthcard