-- 此文件工具自动生成，不要修改
---@class cfg_box_column
---@field id number @特权序号 column=1 A
---策划看，备注
---@field name string @名称 column=2 B
---给每个页签排个序，排序也按照页签顺序从小到大进行排序
---@field tab number @特权页签 column=3 C
---每个页签的名字
---@field tabName string @页签名 column=4 D
---1：专属BUFF
---2：每日礼包
---3：特权称号
---@field type number @特权类型 column=5 E
---1：BUFFid
---2：itemid#数量|itemid#数量
---3：itemid#数量
---@field param IntListList @特权参数 column=6 F
---0：不刷新
---1：每日刷新，1#X代表每日X点进行刷新
---2：每周刷新，2#X#Y代表每周X的Y点进行刷新
---[[客户端不使用]]@field time IntList @刷新时间 column=7 G
---进行文本描述
---@field text string @特权描述 column=8 H
local cfg_box =
{
	{id=1001, name="特权BUFF", tab=1, tabName="盒子特权", type=1, param={{40000010,40000020,40000030}}, text="使用当前账号登录奇乐盒子启动游戏即可解锁特权"},
	{id=2001, name="每日礼包", tab=2, tabName="每日礼包", type=2, text="使用当前账号登录奇乐盒子启动游戏每日可获得礼包"},
	{id=1002, name="特权称号", tab=1, tabName="特权称号", type=3, param={{21500020,1}}, text="使用当前账号登录奇乐盒子启动游戏即可解锁称号"},
}

local defaults = {param={{10020001,100},{10010001,10000}}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_box) do
	setmetatable(v, mt)
end

return cfg_box