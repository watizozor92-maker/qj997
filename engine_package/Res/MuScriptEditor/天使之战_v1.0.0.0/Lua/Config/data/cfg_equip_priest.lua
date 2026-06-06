-- 此文件工具自动生成，不要修改
---@class cfg_equip_priest_column
---序号
---@field id number @id column=1 A
---188天鹰189黑王马（item表subtype对应）
---@field type number @类型 column=2 B
---等级
---@field hawkLv number @天鹰等级 column=3 C
---升至下等级的经验
---@field hawkExp number @天鹰所需经验 column=4 D
---天鹰升级增加属性
---@field hawkAtt IntListList @天鹰属性 column=5 E
---[[客户端不使用]]@field   @ column=6 F
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

local local_hawkAtt = {
    hawkAtt_1={{200041,15},{213022,1}},
    hawkAtt_2={{200041,10}},

}

local cfg_equip_priest =
{
	{id=1, hawkLv=1, hawkExp=1100},
	{id=2, hawkLv=2, hawkExp=8500},
	{id=3, hawkLv=3, hawkExp=25500},
	{id=4, hawkLv=4, hawkExp=54500},
	{id=5, hawkLv=5, hawkExp=97900},
	{id=6, hawkLv=6, hawkExp=158100},
	{id=7, hawkLv=7, hawkExp=237500},
	{id=8, hawkLv=8, hawkExp=338500},
	{id=9, hawkLv=9, hawkExp=463500},
	{id=10, hawkLv=10, hawkExp=614900},
	{id=11, hawkLv=11, hawkExp=795100},
	{id=12, hawkLv=12, hawkExp=1006500},
	{id=13, hawkLv=13, hawkExp=1251500},
	{id=14, hawkLv=14, hawkExp=1532500},
	{id=15, hawkLv=15, hawkExp=1851900},
	{id=16, hawkLv=16, hawkExp=2212100},
	{id=17, hawkLv=17, hawkExp=2615500},
	{id=18, hawkLv=18, hawkExp=3064500},
	{id=19, hawkLv=19, hawkExp=3561500},
	{id=20, hawkLv=20, hawkExp=4108900},
	{id=21, hawkLv=21, hawkExp=4709100},
	{id=22, hawkLv=22, hawkExp=5364500},
	{id=23, hawkLv=23, hawkExp=6077500},
	{id=24, hawkLv=24, hawkExp=6850500},
	{id=25, hawkLv=25, hawkExp=7685900},
	{id=26, hawkLv=26, hawkExp=8586100},
	{id=27, hawkLv=27, hawkExp=9548100},
	{id=28, hawkLv=28, hawkExp=10595900},
	{id=29, hawkLv=29, hawkExp=11699500},
	{id=30, hawkLv=30, hawkExp=12882900},
	{id=31, hawkLv=31, hawkExp=14143100},
	{id=32, hawkLv=32, hawkExp=15482500},
	{id=33, hawkLv=33, hawkExp=16903500},
	{id=34, hawkLv=34, hawkExp=18408500},
	{id=35, hawkLv=35, hawkExp=19999900},
	{id=36, hawkLv=36, hawkExp=21680100},
	{id=37, hawkLv=37, hawkExp=23451500},
	{id=38, hawkLv=38, hawkExp=25316500},
	{id=39, hawkLv=39, hawkExp=27277500},
	{id=40, hawkLv=40, hawkExp=29336900},
	{id=41, hawkLv=41, hawkExp=31497100},
	{id=42, hawkLv=42, hawkExp=33760500},
	{id=43, hawkLv=43, hawkExp=36129500},
	{id=44, hawkLv=44, hawkExp=38606500},
	{id=45, hawkLv=45, hawkExp=41193900},
	{id=46, hawkLv=46, hawkExp=43894100},
	{id=47, hawkLv=47, hawkExp=46709500},
	{id=48, hawkLv=48, hawkExp=49642500},
	{id=49, hawkLv=49, hawkExp=52695500},
	{id=50, hawkLv=50, hawkExp=55870900},
	{id=56, type=19, hawkLv=1, hawkExp=1100, hawkAtt=local_hawkAtt.hawkAtt_2},
	{id=57, type=19, hawkLv=2, hawkExp=8500, hawkAtt=local_hawkAtt.hawkAtt_2},
	{id=58, type=19, hawkLv=3, hawkExp=25500, hawkAtt=local_hawkAtt.hawkAtt_2},
	{id=59, type=19, hawkLv=4, hawkExp=54500, hawkAtt=local_hawkAtt.hawkAtt_2},
	{id=60, type=19, hawkLv=5, hawkExp=97900, hawkAtt=local_hawkAtt.hawkAtt_2},
	{id=61, type=19, hawkLv=6, hawkExp=158100, hawkAtt=local_hawkAtt.hawkAtt_2},
	{id=62, type=19, hawkLv=7, hawkExp=237500, hawkAtt=local_hawkAtt.hawkAtt_2},
	{id=63, type=19, hawkLv=8, hawkExp=338500, hawkAtt=local_hawkAtt.hawkAtt_2},
	{id=64, type=19, hawkLv=9, hawkExp=463500, hawkAtt=local_hawkAtt.hawkAtt_2},
	{id=65, type=19, hawkLv=10, hawkExp=614900, hawkAtt=local_hawkAtt.hawkAtt_2},
	{id=66, type=19, hawkLv=11, hawkExp=795100, hawkAtt=local_hawkAtt.hawkAtt_2},
	{id=67, type=19, hawkLv=12, hawkExp=1006500, hawkAtt=local_hawkAtt.hawkAtt_2},
	{id=68, type=19, hawkLv=13, hawkExp=1251500, hawkAtt=local_hawkAtt.hawkAtt_2},
	{id=69, type=19, hawkLv=14, hawkExp=1532500, hawkAtt=local_hawkAtt.hawkAtt_2},
	{id=70, type=19, hawkLv=15, hawkExp=1851900, hawkAtt=local_hawkAtt.hawkAtt_2},
	{id=71, type=19, hawkLv=16, hawkExp=2212100, hawkAtt=local_hawkAtt.hawkAtt_2},
	{id=72, type=19, hawkLv=17, hawkExp=2615500, hawkAtt=local_hawkAtt.hawkAtt_2},
	{id=73, type=19, hawkLv=18, hawkExp=3064500, hawkAtt=local_hawkAtt.hawkAtt_2},
	{id=74, type=19, hawkLv=19, hawkExp=3561500, hawkAtt=local_hawkAtt.hawkAtt_2},
	{id=75, type=19, hawkLv=20, hawkExp=4108900, hawkAtt=local_hawkAtt.hawkAtt_2},
	{id=76, type=19, hawkLv=21, hawkExp=4709100, hawkAtt=local_hawkAtt.hawkAtt_2},
	{id=77, type=19, hawkLv=22, hawkExp=5364500, hawkAtt=local_hawkAtt.hawkAtt_2},
	{id=78, type=19, hawkLv=23, hawkExp=6077500, hawkAtt=local_hawkAtt.hawkAtt_2},
	{id=79, type=19, hawkLv=24, hawkExp=6850500, hawkAtt=local_hawkAtt.hawkAtt_2},
	{id=80, type=19, hawkLv=25, hawkExp=7685900, hawkAtt=local_hawkAtt.hawkAtt_2},
	{id=81, type=19, hawkLv=26, hawkExp=8586100, hawkAtt=local_hawkAtt.hawkAtt_2},
	{id=82, type=19, hawkLv=27, hawkExp=9548100, hawkAtt=local_hawkAtt.hawkAtt_2},
	{id=83, type=19, hawkLv=28, hawkExp=10595900, hawkAtt=local_hawkAtt.hawkAtt_2},
	{id=84, type=19, hawkLv=29, hawkExp=11699500, hawkAtt=local_hawkAtt.hawkAtt_2},
	{id=85, type=19, hawkLv=30, hawkExp=12882900, hawkAtt=local_hawkAtt.hawkAtt_2},
	{id=86, type=19, hawkLv=31, hawkExp=14143100, hawkAtt=local_hawkAtt.hawkAtt_2},
	{id=87, type=19, hawkLv=32, hawkExp=15482500, hawkAtt=local_hawkAtt.hawkAtt_2},
	{id=88, type=19, hawkLv=33, hawkExp=16903500, hawkAtt=local_hawkAtt.hawkAtt_2},
	{id=89, type=19, hawkLv=34, hawkExp=18408500, hawkAtt=local_hawkAtt.hawkAtt_2},
	{id=90, type=19, hawkLv=35, hawkExp=19999900, hawkAtt=local_hawkAtt.hawkAtt_2},
	{id=91, type=19, hawkLv=36, hawkExp=21680100, hawkAtt=local_hawkAtt.hawkAtt_2},
	{id=92, type=19, hawkLv=37, hawkExp=23451500, hawkAtt=local_hawkAtt.hawkAtt_2},
	{id=93, type=19, hawkLv=38, hawkExp=25316500, hawkAtt=local_hawkAtt.hawkAtt_2},
	{id=94, type=19, hawkLv=39, hawkExp=27277500, hawkAtt=local_hawkAtt.hawkAtt_2},
	{id=95, type=19, hawkLv=40, hawkExp=29336900, hawkAtt=local_hawkAtt.hawkAtt_2},
	{id=96, type=19, hawkLv=41, hawkExp=31497100, hawkAtt=local_hawkAtt.hawkAtt_2},
	{id=97, type=19, hawkLv=42, hawkExp=33760500, hawkAtt=local_hawkAtt.hawkAtt_2},
	{id=98, type=19, hawkLv=43, hawkExp=36129500, hawkAtt=local_hawkAtt.hawkAtt_2},
	{id=99, type=19, hawkLv=44, hawkExp=38606500, hawkAtt=local_hawkAtt.hawkAtt_2},
	{id=100, type=19, hawkLv=45, hawkExp=41193900, hawkAtt=local_hawkAtt.hawkAtt_2},
	{id=101, type=19, hawkLv=46, hawkExp=43894100, hawkAtt=local_hawkAtt.hawkAtt_2},
	{id=102, type=19, hawkLv=47, hawkExp=46709500, hawkAtt=local_hawkAtt.hawkAtt_2},
	{id=103, type=19, hawkLv=48, hawkExp=49642500, hawkAtt=local_hawkAtt.hawkAtt_2},
	{id=104, type=19, hawkLv=49, hawkExp=52695500, hawkAtt=local_hawkAtt.hawkAtt_2},
	{id=105, type=19, hawkLv=50, hawkExp=55870900, hawkAtt=local_hawkAtt.hawkAtt_2},
}

local defaults = {type=18, hawkAtt={{200041,15},{213022,1}}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_equip_priest) do
	setmetatable(v, mt)
end

return cfg_equip_priest