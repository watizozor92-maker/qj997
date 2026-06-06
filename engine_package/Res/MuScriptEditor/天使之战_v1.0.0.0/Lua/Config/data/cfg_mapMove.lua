-- 此文件工具自动生成，不要修改
---@class cfg_mapMove_column
---@field id number @序号 column=1 A
---显示的名称[地图名称]
---@field mapName string @地图传送名称 column=2 B
---地图显示等级
---@field xianshilevel number @显示等级 column=3 C
---地图传送等级，优先级更高
---@field level number @传送等级 column=4 D
---格式对应conditions表
---@field conditions string @传送条件 column=5 E
---格式：地图id；读取cfg_map_info/id
---@field mapID number @地图号 column=6 F
---通过小地图传送到此地图所在的x坐标
---@field mapX number @x坐标 column=7 G
---通过小地图传送到此地图所在的y坐标
---@field mapY number @y坐标 column=8 H
---1、格式：x#y|x#y
---2、配置多点后，传送该地图时多点内随机传送
---3、多点随机传送mapX与mapY需配置为0
---@field poz IntListList @多点随机传送坐标 column=9 I
---在对应坐标的此范围内出生
---@field range number @范围 column=10 J
---checkLevel>99999时，不在传送列表显示
---@field mapUIShow string @地图传送列表界面显示 column=11 K
---地图传送分组
---填空或0则不存在分组
---@field group number @地图传送组 column=12 L
---同组读取首个传送组名称
---@field groupName string @地图传送组名称 column=13 M
---黄金传送组内固定两张地图：地图N与黄金·地图N，二者为一组goldgooup数据相同。 填空或0为该地图不在任何黄金传送组内
---@field goldgroup number @黄金传送组 column=14 N
---配置相同的传送组时，地图传送不切换线路。不同传送组、填空或0时均正常切换线路。
---@field linegroup number @分线传送组 column=15 O

local local_poz = {
    poz_1={},

}

local cfg_mapMove =
{
	{id=1, mapName="勇者大陆", xianshilevel=1, mapID=1001, mapX=134, mapY=128, linegroup=1},
	{id=2, mapName="仙踪林", xianshilevel=1, mapID=1004, mapX=176, mapY=116, linegroup=2},
	{id=3, mapName="幻术园", xianshilevel=1, mapID=1052, mapX=51, mapY=224, linegroup=3},
	{id=6, mapName="幻术园2", xianshilevel=1, mapID=1052, mapX=100, mapY=57, linegroup=3},
	{id=7, mapName="幻术园3", xianshilevel=1, mapID=1052, mapX=194, mapY=144, linegroup=3},
	{id=4, mapName="冰风谷", xianshilevel=20, level=20, mapID=1003, mapX=202, mapY=44, linegroup=4},
	{id=4001, mapName="冰风谷2", xianshilevel=20, level=20, mapID=1003, mapX=25, mapY=25, linegroup=4},
	{id=4002, mapName="冰风谷3", xianshilevel=20, level=20, mapID=1003, mapX=224, mapY=216, linegroup=4},
	{id=4003, mapName="冰风谷4", xianshilevel=20, level=20, mapID=1003, mapX=69, mapY=178, linegroup=4},
	{id=5, mapName="地下城", xianshilevel=30, level=30, mapID=1002, mapX=108, mapY=239, linegroup=5},
	{id=5001, mapName="地下城2", xianshilevel=30, level=30, mapID=1102, mapX=229, mapY=123, linegroup=5},
	{id=5002, mapName="地下城3", xianshilevel=30, level=30, mapID=1202, mapX=6, mapY=85, linegroup=5},
	{id=8, mapName="失落之塔1", xianshilevel=40, level=40, mapID=1005, mapX=208, mapY=77, linegroup=6},
	{id=8001, mapName="失落之塔2", xianshilevel=40, level=40, mapID=1105, mapX=242, mapY=237, linegroup=6},
	{id=8002, mapName="失落之塔3", xianshilevel=40, level=40, mapID=1205, mapX=87, mapY=169, linegroup=6},
	{id=8003, mapName="失落之塔4", xianshilevel=40, level=40, mapID=1305, mapX=85, mapY=91, linegroup=6},
	{id=8004, mapName="失落之塔5", xianshilevel=40, level=40, mapID=1405, mapX=130, mapY=54, linegroup=6},
	{id=8005, mapName="失落之塔6", xianshilevel=40, level=40, mapID=1505, mapX=52, mapY=55, linegroup=6},
	{id=8006, mapName="失落之塔7", xianshilevel=40, level=40, mapID=1605, mapX=11, mapY=86, linegroup=6},
	{id=15, mapName="亚特兰蒂斯", xianshilevel=70, level=70, mapID=1008, mapX=23, mapY=19, linegroup=7},
	{id=15001, mapName="亚特兰蒂斯2", xianshilevel=70, level=70, mapID=1008, mapX=228, mapY=46, linegroup=7},
	{id=15002, mapName="亚特兰蒂斯3", xianshilevel=70, level=70, mapID=1008, mapX=58, mapY=176, linegroup=7},
	{id=17, mapName="死亡沙漠", xianshilevel=130, level=130, mapID=1009, mapX=190, mapY=58, linegroup=8},
	{id=17001, mapName="死亡沙漠2", xianshilevel=130, level=130, mapID=1009, mapX=104, mapY=144, linegroup=8},
	{id=19, mapName="幽暗森林", xianshilevel=170, level=170, mapID=1034, mapX=87, mapY=11, linegroup=9},
	{id=20, mapName="幽暗森林2", xianshilevel=170, level=170, mapID=1034, mapX=117, mapY=103, linegroup=9},
	{id=21, mapName="天空之城", xianshilevel=210, level=210, conditions="checkWearEquip[14]>0", mapID=1011, mapX=16, mapY=20, linegroup=10},
	{id=24, mapName="坎特鲁废墟", xianshilevel=250, level=250, mapID=1038, mapX=24, mapY=215, linegroup=11},
	{id=24001, mapName="坎特鲁废墟2", xianshilevel=250, level=250, mapID=1038, mapX=203, mapY=38, linegroup=11},
	{id=24002, mapName="坎特鲁废墟3", xianshilevel=250, level=250, mapID=103802, mapX=197, mapY=197, linegroup=11},
	{id=26, mapName="坎特鲁遗址", xianshilevel=290, level=290, mapID=1039, mapX=80, mapY=105, linegroup=12},
	{id=2601, mapName="坎特鲁遗址2", xianshilevel=290, level=290, mapID=103902, mapX=108, mapY=139, linegroup=12},
	{id=28, mapName="冰霜之城", xianshilevel=330, level=330, mapID=1058, mapX=216, mapY=205, linegroup=13},
	{id=2801, mapName="冰霜之城2", xianshilevel=330, level=330, mapID=105802, mapX=101, mapY=209, linegroup=13},
	{id=2802, mapName="冰霜之城3", xianshilevel=330, level=330, mapID=105803, mapX=194, mapY=24, linegroup=13},
	{id=31, mapName="安宁池", xianshilevel=370, level=370, mapID=1057, mapX=140, mapY=108, linegroup=14},
	{id=48, mapName="恶魔广场1", mapX=136, mapY=97, mapUIShow="checkLevel>99999"},
	{id=49, mapName="恶魔广场2", mapX=126, mapY=87, mapUIShow="checkLevel>99999"},
	{id=50, mapName="恶魔广场3", mapX=143, mapY=108, mapUIShow="checkLevel>99999"},
	{id=51, mapName="恶魔广场4", mapX=142, mapY=89, mapUIShow="checkLevel>99999"},
	{id=52, mapName="恶魔广场5", mapX=133, mapY=91, mapUIShow="checkLevel>99999"},
	{id=53, mapName="恶魔广场6", mapX=135, mapY=162, mapUIShow="checkLevel>99999"},
	{id=54, mapName="恶魔广场7", mapX=135, mapY=162, mapUIShow="checkLevel>99999"},
	{id=55, mapName="血色城堡", mapID=1012, mapX=12, mapY=5, mapUIShow="checkLevel>99999"},
	{id=16001, mapName="罗兰峡谷", mapID=16001, mapX=87, mapY=209, mapUIShow="checkLevel>99999"},
	{id=33, mapName="狼魂要塞", xianshilevel=1, mapID=1035, mapX=139, mapY=37, mapUIShow="checkLevel>99999"},
	{id=69, mapName="战盟BOSS", xianshilevel=70, level=0, mapID=10013, mapX=14, mapY=80, mapUIShow="checkLevel>99999"},
	{id=57, mapName="赤色要塞", xianshilevel=1, level=0, mapID=1019, mapX=121, mapY=180, mapUIShow="checkLevel>99999"},
	{id=73, mapName="菲利亚", xianshilevel=400, level=400, mapID=11003, mapX=235, mapY=150, linegroup=15},
	{id=74, mapName="尼克西斯湖", xianshilevel=400, level=400, mapID=11004, mapX=24, mapY=120, linegroup=16},
	{id=75, mapName="深渊地下城", xianshilevel=400, level=400, mapID=11005, mapX=133, mapY=133, linegroup=17},
	{id=12005, mapName="卡利玛神庙", mapID=1025, mapX=37, mapY=22, mapUIShow="checkLevel>99999"},
	{id=70001, mapName="巴卡斯兵营", mapID=1042, mapX=123, mapY=93, mapUIShow="checkLevel>99999"},
	{id=70002, mapName="巴卡斯休息室", mapID=1043, mapX=103, mapY=180, mapUIShow="checkLevel>99999"},
}

local defaults = {xianshilevel=0, level=1, conditions="", mapID=1010, poz={}, range=2, mapUIShow="", group=0, groupName="", goldgroup=0, linegroup=0}
local mt = {__index = defaults}
for _, v in ipairs(cfg_mapMove) do
	setmetatable(v, mt)
end

return cfg_mapMove