-- 此文件工具自动生成，不要修改
---@class cfg_Monster_dropItem_column
---唯一id
---[[客户端不使用]]@field id number @id column=1 A
---怪物表中id，1为魂兽boss掉落专用 2为会员地图魂兽boss掉落专用3为神器boss掉落专用
---@field monsterId number @怪物id column=2 B
---中文名
---@field monsterName string @怪物名字 column=3 C
---mbox表中id
---@field mboxId number @盒子序号 column=4 D
---中文名
---@field mboxName string @盒子名字 column=5 E
---概率亿分比
---[[客户端不使用]]@field rate number @掉落概率 column=6 F
---计算几次随机
---@field times string @次数 column=7 G
local cfg_Monster_dropItem =
{
	{monsterId=10001, monsterName="幼龙", mboxId=1, mboxName="祝福宝石", times="3#5"},
	{monsterId=10001, monsterName="幼龙", mboxId=2, mboxName="灵魂宝石"},
	{monsterId=10002, monsterName="蜘蛛", mboxId=3, mboxName="生命宝石"},
	{monsterId=10002, monsterName="蜘蛛", mboxId=4, mboxName="玛雅之石", times="2#2"},
	{monsterId=10004, monsterName="牛怪", mboxId=1, mboxName="祝福宝石", times="1"},
	{monsterId=10004, monsterName="牛怪", mboxId=3, mboxName="生命宝石", times="1"},
	{monsterId=10005, monsterName="蛮牛怪", mboxId=2, mboxName="灵魂宝石", times="1"},
	{monsterId=10005, monsterName="蛮牛怪", mboxId=4, mboxName="玛雅之石", times="1"},
}

local defaults = {times="2#4"}
local mt = {__index = defaults}
for _, v in ipairs(cfg_Monster_dropItem) do
	setmetatable(v, mt)
end

return cfg_Monster_dropItem