-- 此文件工具自动生成，不要修改
---@class cfg_card_att_column
---唯一id
---组id+两位编号
---@field id number @词条库id column=1 A
---策划用
---词条库备注
---[[客户端不使用]]@field name string @词条库备注 column=2 B
---数字相同的归属在同一词条组内
---@field group number @词条组 column=3 C
---变身卡牌词条品质
---1.蓝色
---2.金色
---3.红色
---@field quality number @词条品质 column=4 D
---用于卡牌下一级突破时替换词条，填写词条库id
---不填则替换本身
---@field breakthroughAtt number @突破替换词条 column=5 E
---格式：属性id#数值下限#数值上限#权重
---
---权重越高越容易出现，权重影响的是随机到这条属性的几率，不影响属性的数值
---
---引用att_info表id
---@field att IntListList @属性 column=6 F
---属性显示颜色，读取cfg_color表id
---@field color number @属性显示颜色 column=7 G

local local_att = {
    att_1={{303012,20,20,1000}},
    att_2={{303012,35,35,1000}},
    att_3={{303012,50,50,1000}},

}

local cfg_card_att =
{
	{id=101, quality=1, breakthroughAtt=201, att={{316021,50,50,1000}}, color=277},
	{id=102, quality=1, breakthroughAtt=202, att={{315021,50,50,1000}}, color=277},
	{id=103, quality=1, breakthroughAtt=203, att={{200041,5,5,1000}}, color=277},
	{id=104, quality=1, breakthroughAtt=204, att={{206011,35,35,1000}}, color=277},
	{id=105, quality=1, breakthroughAtt=205, att={{207011,370,370,1000}}, color=277},
	{id=106, quality=1, breakthroughAtt=206, att={{400002,35,35,1000}}, color=277},
	{id=107, quality=1, breakthroughAtt=207, att={{400001,35,35,1000}}, color=277},
	{id=108, quality=1, breakthroughAtt=208, att={{305012,20,20,1000}}, color=277},
	{id=109, quality=1, breakthroughAtt=209, att={{304012,20,20,1000}}, color=277},
	{id=110, quality=1, breakthroughAtt=210, color=277},
	{id=111, quality=1, breakthroughAtt=211, att={{305022,20,20,1000}}, color=277},
	{id=112, quality=1, breakthroughAtt=212, att={{304022,20,20,1000}}, color=277},
	{id=113, quality=1, breakthroughAtt=213, color=277},
	{id=201, group=2, quality=2, breakthroughAtt=401, att={{316021,70,70,1000}}, color=282},
	{id=202, group=2, quality=2, breakthroughAtt=402, att={{315021,70,70,1000}}, color=282},
	{id=203, group=2, quality=2, breakthroughAtt=403, att={{200041,10,10,1000}}, color=282},
	{id=204, group=2, quality=2, breakthroughAtt=404, att={{206011,50,50,1000}}, color=282},
	{id=205, group=2, quality=2, breakthroughAtt=405, att={{207011,520,520,1000}}, color=282},
	{id=206, group=2, quality=2, breakthroughAtt=406, att={{400002,50,50,1000}}, color=282},
	{id=207, group=2, quality=2, breakthroughAtt=407, att={{400001,50,50,1000}}, color=282},
	{id=208, group=2, quality=2, breakthroughAtt=408, att={{305012,35,35,1000}}, color=282},
	{id=209, group=2, quality=2, breakthroughAtt=409, att={{304012,35,35,1000}}, color=282},
	{id=210, group=2, quality=2, breakthroughAtt=410, att=local_att.att_2, color=282},
	{id=211, group=2, quality=2, breakthroughAtt=411, att={{305022,35,35,1000}}, color=282},
	{id=212, group=2, quality=2, breakthroughAtt=412, att={{304022,35,35,1000}}, color=282},
	{id=213, group=2, quality=2, breakthroughAtt=413, att=local_att.att_2, color=282},
	{id=301, group=3, quality=2, breakthroughAtt=501, att={{305042,40,40,1000}}, color=282},
	{id=302, group=3, quality=2, breakthroughAtt=502, att={{304042,40,40,1000}}, color=282},
	{id=303, group=3, quality=2, breakthroughAtt=503, att={{303042,40,40,1000}}, color=282},
	{id=304, group=3, quality=2, breakthroughAtt=504, att={{305062,40,40,1000}}, color=282},
	{id=305, group=3, quality=2, breakthroughAtt=505, att={{304062,40,40,1000}}, color=282},
	{id=306, group=3, quality=2, breakthroughAtt=506, att={{303062,40,40,1000}}, color=282},
	{id=307, group=3, quality=2, breakthroughAtt=507, att={{213011,6,6,1000}}, color=282},
	{id=308, group=3, quality=2, breakthroughAtt=508, att={{207071,45,45,1000}}, color=282},
	{id=309, group=3, quality=2, breakthroughAtt=509, att={{311012,60,60,1000}}, color=282},
	{id=310, group=3, quality=2, breakthroughAtt=510, att={{313012,60,60,1000}}, color=282},
	{id=401, group=4, att={{316021,100,100,1000}}},
	{id=402, group=4, att={{315021,100,100,1000}}},
	{id=403, group=4, att={{200041,15,15,1000}}},
	{id=404, group=4, att={{206011,70,70,1000}}},
	{id=405, group=4, att={{207011,750,750,1000}}},
	{id=406, group=4, att={{400002,70,70,1000}}},
	{id=407, group=4, att={{400001,70,70,1000}}},
	{id=408, group=4, att={{305012,50,50,1000}}},
	{id=409, group=4, att={{304012,50,50,1000}}},
	{id=410, group=4, att=local_att.att_3},
	{id=411, group=4, att={{305022,50,50,1000}}},
	{id=412, group=4, att={{304022,50,50,1000}}},
	{id=413, group=4, att=local_att.att_3},
	{id=501, group=5, att={{305042,60,60,1000}}},
	{id=502, group=5, att={{304042,60,60,1000}}},
	{id=503, group=5, att={{303042,60,60,1000}}},
	{id=504, group=5, att={{305062,60,60,1000}}},
	{id=505, group=5, att={{304062,60,60,1000}}},
	{id=506, group=5, att={{303062,60,60,1000}}},
	{id=507, group=5, att={{213011,9,9,1000}}},
	{id=508, group=5, att={{207071,65,65,1000}}},
	{id=509, group=5, att={{311012,80,80,1000}}},
	{id=510, group=5, att={{313012,80,80,1000}}},
	{id=601, group=6, att={{206041,60,60,1000}}},
	{id=602, group=6, att={{5000011,600,600,1000}}},
	{id=603, group=6, att={{5000012,600,600,1000}}},
	{id=604, group=6, att={{314051,600,600,1000}}},
	{id=605, group=6, att={{314052,600,600,1000}}},
	{id=606, group=6, att={{311212,120,120,1000}}},
	{id=607, group=6, att={{312212,120,120,1000}}},
	{id=608, group=6, att={{311112,120,120,1000}}},
	{id=609, group=6, att={{312112,120,120,1000}}},
	{id=701, group=7, quality=1, breakthroughAtt=801, att={{317012,100,100,1}}, color=277},
	{id=702, group=7, quality=1, breakthroughAtt=802, att={{317022,100,100,1}}, color=277},
	{id=703, group=7, quality=1, breakthroughAtt=803, att={{311212,250,250,1}}, color=277},
	{id=704, group=7, quality=1, breakthroughAtt=804, att={{312212,250,250,1}}, color=277},
	{id=705, group=7, quality=1, breakthroughAtt=805, att={{206041,80,80,1}}, color=277},
	{id=706, group=7, quality=1, breakthroughAtt=806, att={{5000011,800,800,1}}, color=277},
	{id=707, group=7, quality=1, breakthroughAtt=807, att={{5000012,800,800,1}}, color=277},
	{id=708, group=7, quality=1, breakthroughAtt=808, att={{314051,800,800,1}}, color=277},
	{id=709, group=7, quality=1, breakthroughAtt=809, att={{314052,800,800,1}}, color=277},
	{id=801, group=8, quality=2, breakthroughAtt=1001, att={{317012,200,200,1}}, color=282},
	{id=802, group=8, quality=2, breakthroughAtt=1002, att={{317022,200,200,1}}, color=282},
	{id=803, group=8, quality=2, breakthroughAtt=1003, att={{311212,500,500,1}}, color=282},
	{id=804, group=8, quality=2, breakthroughAtt=1004, att={{312212,500,500,1}}, color=282},
	{id=805, group=8, quality=2, breakthroughAtt=1005, att={{206041,120,120,1}}, color=282},
	{id=806, group=8, quality=2, breakthroughAtt=1006, att={{5000011,1200,1200,1}}, color=282},
	{id=807, group=8, quality=2, breakthroughAtt=1007, att={{5000012,1200,1200,1}}, color=282},
	{id=808, group=8, quality=2, breakthroughAtt=1008, att={{314051,1200,1200,1}}, color=282},
	{id=809, group=8, quality=2, breakthroughAtt=1009, att={{314052,1200,1200,1}}, color=282},
	{id=901, group=9, quality=2, breakthroughAtt=1101, att={{333052,900,900,1}}, color=282},
	{id=902, group=9, quality=2, breakthroughAtt=1102, att={{334052,900,900,1}}, color=282},
	{id=903, group=9, quality=2, breakthroughAtt=1103, att={{335052,900,900,1}}, color=282},
	{id=904, group=9, quality=2, breakthroughAtt=1104, att={{336052,900,900,1}}, color=282},
	{id=905, group=9, quality=2, breakthroughAtt=1105, att={{333042,900,900,1}}, color=282},
	{id=906, group=9, quality=2, breakthroughAtt=1106, att={{334042,900,900,1}}, color=282},
	{id=907, group=9, quality=2, breakthroughAtt=1107, att={{335042,900,900,1}}, color=282},
	{id=908, group=9, quality=2, breakthroughAtt=1108, att={{336042,900,900,1}}, color=282},
	{id=1001, group=10, att={{317012,300,300,1}}},
	{id=1002, group=10, att={{317022,300,300,1}}},
	{id=1003, group=10, att={{311212,750,750,1}}},
	{id=1004, group=10, att={{312212,750,750,1}}},
	{id=1005, group=10, att={{206041,160,160,1}}},
	{id=1006, group=10, att={{5000011,1600,1600,1}}},
	{id=1007, group=10, att={{5000012,1600,1600,1}}},
	{id=1008, group=10, att={{314051,1600,1600,1}}},
	{id=1009, group=10, att={{314052,1600,1600,1}}},
	{id=1101, group=11, att={{333052,1500,1500,1}}},
	{id=1102, group=11, att={{334052,1500,1500,1}}},
	{id=1103, group=11, att={{335052,1500,1500,1}}},
	{id=1104, group=11, att={{336052,1500,1500,1}}},
	{id=1105, group=11, att={{333042,1500,1500,1}}},
	{id=1106, group=11, att={{334042,1500,1500,1}}},
	{id=1107, group=11, att={{335042,1500,1500,1}}},
	{id=1108, group=11, att={{336042,1500,1500,1}}},
	{id=1201, group=12, att={{333022,1500,1500,1}}},
	{id=1202, group=12, att={{334022,1500,1500,1}}},
	{id=1203, group=12, att={{335022,1500,1500,1}}},
	{id=1204, group=12, att={{336022,1500,1500,1}}},
	{id=1205, group=12, att={{333032,1500,1500,1}}},
	{id=1206, group=12, att={{334032,1500,1500,1}}},
	{id=1207, group=12, att={{335032,1500,1500,1}}},
	{id=1208, group=12, att={{336032,1500,1500,1}}},
}

local defaults = {group=1, quality=3, breakthroughAtt=0, att={{303012,20,20,1000}}, color=58}
local mt = {__index = defaults}
for _, v in ipairs(cfg_card_att) do
	setmetatable(v, mt)
end

return cfg_card_att