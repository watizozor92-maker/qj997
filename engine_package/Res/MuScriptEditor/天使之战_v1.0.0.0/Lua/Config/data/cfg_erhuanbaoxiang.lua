-- 此文件工具自动生成，不要修改
---@class cfg_erhuanbaoxiang_column
---唯一id
---[[客户端不使用]]@field id number @id column=1 A
---1=统计概率，从所有道具中抽取1个（按权重）
---2=独立概率，每个道具单独判断概率
---*每张表只允许使用1个类型
---[[客户端不使用]]@field type number @掉落类型 column=2 B
---策划备注
---[[客户端不使用]]@field beizhu string @ column=3 C
---道具id
---@field item number @道具id column=4 D
---数量区间，从中随机数量
---x#y，左右闭区间
---@field num string @数量 column=5 E
---掉落类型为1时，此处为：掉落次数#权重
---掉落类型为2时，此处为：掉落次数#概率（万分比）
---掉落次数填本次掉落之前已经掉落的次数，例如首次掉落，之前没掉过，这里就填0
---[[客户端不使用]]@field probability string @概率 column=6 F
---限制职业
---只有对应职业才会掉落
---不填不做限制
---格式：所属职业#职业等级|所属职业#职业等级
---[[客户端不使用]]@field career string @职业 column=7 G
---限制等级
---只有角色在对应等级区间内才会掉
---x#y，左右闭区间
---999999标识无限大
---不填不做限制
---[[客户端不使用]]@field level string @等级 column=8 H
---宝箱开启时概率携带的技能id#等级#携带概率（万分比）
---@field skillbaoxiang IntList @装备携带【技能】概率 column=9 I
---宝箱开启时概率携带的权重#等级
---@field strengthenbaoxiang IntListList @装携带【强化】概率 column=10 J
---宝箱开启时概率携带的幸运的概率（万分比）
---@field luckbaoxiang number @装备携带【幸运】概率 column=11 K
---宝箱开启时概率携带的追加的权重#等级
---@field appendsbaoxiang IntListList @装备携带【追加】概率 column=12 L

local local_skillbaoxiang = {
    skillbaoxiang_1={},

}

local local_strengthenbaoxiang = {
    strengthenbaoxiang_1={},

}

local local_appendsbaoxiang = {
    appendsbaoxiang_1={},

}

local cfg_erhuanbaoxiang =
{
	{item=2120010199},
	{item=2120011199},
	{num="8888#8888"},
	{num="1888#1888"},
	{num="1588#1588"},
	{num="1288#1288"},
	{num="588#588"},
	{num="388#388"},
	{num="288#288"},
	{num="188#188"},
	{num="88#88"},
	{item=10010001, num="1000000#1000000"},
	{item=10010001, num="3000000#3000000"},
	{item=10010001, num="5000000#5000000"},
	{item=10010001, num="10000000#10000000"},
	{item=2100020199},
	{item=2100020299},
	{item=2100020399},
	{item=2100020499},
	{item=2100020599},
	{item=2100020699},
	{item=2100020799},
	{item=2100020899},
	{item=2110001299},
	{item=2110002299},
	{item=2110003299},
	{item=2100020199},
	{item=2100020299},
	{item=2100020399},
	{item=2100020499},
	{item=2100020599},
	{item=2100020699},
	{item=2100020799},
	{item=2100020899},
	{item=2100001299},
	{item=1100700399},
	{item=1263000999},
	{item=1263002299},
	{item=1263002799},
	{item=1263002899},
	{item=1263002999},
	{item=1263508399},
	{item=1263510099},
	{item=2041012199},
	{item=2061012199},
	{item=2071012199},
	{item=2081012199},
	{item=2091012199},
	{item=2042012199},
	{item=2062012199},
	{item=2072012199},
	{item=2082012199},
	{item=2092012199},
	{item=2043012199},
	{item=2063012199},
	{item=2073012199},
	{item=2083012199},
	{item=2093012199},
	{item=1100700199},
	{item=1100700299},
	{item=2066052199},
	{item=2066052299},
	{item=2066052399},
	{item=2066052499},
	{item=2066052599},
	{item=2066061199},
	{item=2055052199},
	{item=2055052299},
	{item=2055052399},
	{item=2055052499},
	{item=2055052599},
	{item=2067022199},
	{item=2087022199},
	{item=2077022199},
	{item=2097022199},
	{item=1280034199},
	{item=1280034299},
	{item=1280034399},
	{item=1280034499},
	{item=2092042199},
	{item=2082042199},
	{item=2072042199},
	{item=2062042199},
	{item=2042042199},
	{item=2091042199},
	{item=2081042199},
	{item=2071042199},
	{item=2061042199},
	{item=2041042199},
}

local defaults = {item=10240001, num="1#1", skillbaoxiang={}, strengthenbaoxiang={}, luckbaoxiang=0, appendsbaoxiang={}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_erhuanbaoxiang) do
	setmetatable(v, mt)
end

return cfg_erhuanbaoxiang