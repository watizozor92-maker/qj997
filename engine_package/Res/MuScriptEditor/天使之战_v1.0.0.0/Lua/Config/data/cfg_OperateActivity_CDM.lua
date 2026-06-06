-- 此文件工具自动生成，不要修改
---@class cfg_OperateActivity_CDM_column
---唯一编号 
---recharge需要填此id
---@field id number @id column=1 A
---10100：跨服
---20100：周末
---@field text string @策划备注 column=2 B
---关联cfg_OperateActivity_all表mainGroup字段，代表第几期活动
---@field mainGroup number @框架组 column=3 C
---填recharge表类型：16
---后端需要这个字段和id来拿数据
---@field rechargeType number @充值类型 column=4 D
---1.付费礼包
---2.一键购买
---3.免费礼包
---@field bugType number @购买类型 column=5 E
---道具id#数量|道具id#数量|道具id#数量
---@field itemCount IntListList @礼包内容 column=6 F
---
---bugType=1时填关联一件购买的id
---bugType=2时填被划掉的价格
---@field parameter number @类型参数 column=7 G
---填图片名称，根据mainGroup组填
---一个组只填第一个数据即可
---@field img string @背景图 column=8 H
---[[客户端不使用]]@field   @ column=9 I
---[[客户端不使用]]@field   @ column=10 J
---[[客户端不使用]]@field   @ column=11 K
---[[客户端不使用]]@field   @ column=12 L
---[[客户端不使用]]@field   @ column=13 M
---[[客户端不使用]]@field   @ column=14 N
---[[客户端不使用]]@field   @ column=15 O
---[[客户端不使用]]@field   @ column=16 P
---[[客户端不使用]]@field   @ column=17 Q
---[[客户端不使用]]@field   @ column=18 R
---[[客户端不使用]]@field   @ column=19 S
---[[客户端不使用]]@field   @ column=20 T
---[[客户端不使用]]@field   @ column=21 U
---[[客户端不使用]]@field   @ column=22 V
---[[客户端不使用]]@field   @ column=23 W
---[[客户端不使用]]@field   @ column=24 X
---[[客户端不使用]]@field   @ column=25 Y
---[[客户端不使用]]@field   @ column=26 A
---[[客户端不使用]]@field   @ column=27 AA
---[[客户端不使用]]@field   @ column=28 AB
---[[客户端不使用]]@field   @ column=29 AC
---[[客户端不使用]]@field   @ column=30 AD
---[[客户端不使用]]@field   @ column=31 AE
---[[客户端不使用]]@field   @ column=32 AF
---[[客户端不使用]]@field   @ column=33 AG
---[[客户端不使用]]@field   @ column=34 AH

local local_itemCount = {
    itemCount_1={},
    itemCount_2={{50030003,1},{10020001,1000}},
    itemCount_3={{10040001,10},{50030003,1},{10020001,1000}},
    itemCount_4={{10040001,50},{60010002,10},{50030001,10},{50032224,2}},
    itemCount_5={{10040001,400},{50040028,200},{50030002,20},{50030003,15}},
    itemCount_6={{10040001,600},{50010010,80},{50030002,40},{50030003,40}},
    itemCount_7={{10040001,800},{50040061,80},{50040074,40},{50030002,20}},
    itemCount_8={{10040001,900},{50040061,100},{50040057,40},{50030003,20}},
    itemCount_9={{10040001,1000},{50040097,30},{50040077,20},{50030004,5}},
    itemCount_10={{10040001,1200},{50040097,40},{50040075,20},{50030004,5}},
    itemCount_11={{60010002,10},{50030002,5},{50030003,5},{50030001,10}},
    itemCount_12={{50010010,80},{50030004,2},{50030002,5},{50030003,5}},
    itemCount_13={{50040097,30},{50030004,5},{50030002,15},{50030003,15}},
    itemCount_14={{50010010,200},{50040028,200},{50040074,30},{50030002,20}},
    itemCount_15={{50040097,40},{50010010,75},{50040057,30},{50030003,20}},
    itemCount_16={{50010010,200},{50040061,50},{50040077,10},{50030004,1}},
    itemCount_17={{50040097,55},{50040061,60},{50040075,10},{50030004,1}},
    itemCount_18={{50010010,300},{50040097,40},{50040061,40},{50030005,1}},
    itemCount_19={{10040001,300},{50040028,300},{50030002,20},{50030003,20}},
    itemCount_20={{10040001,500},{50040061,40},{50030002,40},{50030003,40}},
    itemCount_21={{10040001,800},{50010010,175},{50040074,40},{50030002,20}},
    itemCount_22={{10040001,900},{50040061,120},{50040057,40},{50030003,20}},
    itemCount_23={{10040001,1000},{50010010,250},{50040077,20},{50030004,5}},
    itemCount_24={{10040001,1200},{50040061,140},{50040075,20},{50030004,5}},
    itemCount_25={{10040001,1500},{50010010,300},{50040061,80},{50030005,1}},
    itemCount_26={{50032224,10},{50030002,10},{50030003,10},{50030001,10}},
    itemCount_27={{50040097,10},{50030004,5},{50030002,15},{50030003,15}},
    itemCount_28={{50040061,70},{50030004,5},{50030002,20},{50030003,20}},
    itemCount_29={{50040097,20},{50040061,80},{50040074,30},{50040057,30}},
    itemCount_30={{50040061,120},{50040100,20},{50040077,10},{50040075,10}},
    itemCount_31={{50040097,50},{50040059,50},{50030005,2},{50030004,5}},
    itemCount_32={{50040097,70},{50040076,60},{50030005,2},{50030004,10}},
    itemCount_33={{40011103,1},{50040097,50},{50040061,100},{50030005,1}},
    itemCount_34={{10040001,300},{50040028,400},{50030002,30},{50030003,30}},
    itemCount_35={{10040001,500},{50040061,80},{50030002,30},{50030003,30}},
    itemCount_36={{10040001,800},{50010010,200},{50040074,40},{50030002,20}},
    itemCount_37={{10040001,900},{50040061,130},{50040057,40},{50030003,20}},
    itemCount_38={{10040001,1000},{50010010,250},{50040077,20},{50030004,10}},
    itemCount_39={{10040001,1200},{50040061,170},{50040075,20},{50030004,10}},
    itemCount_40={{10040001,1500},{50010010,450},{50040061,80},{50030005,2}},
    itemCount_41={{50032224,10},{50030002,10},{50030003,10},{50030001,20}},
    itemCount_42={{50040097,15},{50030004,5},{50030002,20},{50030003,20}},
    itemCount_43={{50040061,100},{50030004,8},{50030002,30},{50030003,30}},
    itemCount_44={{50040097,20},{50040061,120},{50040057,60},{50040074,60}},
    itemCount_45={{50040061,150},{50040100,20},{50040077,20},{50040075,20}},
    itemCount_46={{50040097,50},{50040059,150},{50030005,3},{50030004,10}},
    itemCount_47={{50040097,80},{50040076,30},{50030005,3},{50030004,10}},
    itemCount_48={{40011104,1},{50040097,50},{50040061,100},{50030005,5}},
    itemCount_49={{10040001,500},{10020001,160000},{50030003,100},{50030004,50}},
    itemCount_50={{10040001,1300},{10020001,480000},{50030003,200},{50030004,100}},

}

local cfg_OperateActivity_CDM =
{
	{id=10101, text="0", rechargeType=16, bugType=3, itemCount=local_itemCount.itemCount_2},
	{id=10102, text="6", rechargeType=16, itemCount={{60010002,6},{50030002,5},{50030003,5},{50030001,10}}},
	{id=10103, text="30", rechargeType=16, itemCount={{50010010,80},{50030004,1},{50030002,5},{50030003,5}}},
	{id=10104, text="30", rechargeType=16, itemCount={{50040097,15},{50030004,1},{50030002,5},{50030003,5}}},
	{id=10105, rechargeType=16, itemCount={{50010010,150},{50040028,50},{50040074,30},{50030002,10}}},
	{id=10106, rechargeType=16, itemCount={{50040097,15},{50040028,50},{50040057,30},{50030003,10}}},
	{id=10107, text="168", rechargeType=16, itemCount={{50010010,240},{50040061,50},{50040077,10},{50030004,2}}},
	{id=10108, text="198", rechargeType=16, itemCount={{50040097,60},{50040061,50},{50040075,10},{50030004,2}}},
	{id=10109, text="328", rechargeType=16, itemCount={{50010010,400},{50040097,100},{50040061,50},{50030005,1}}},
	{id=20101, text="跨服一键购买", rechargeType=16, bugType=2, itemCount=local_itemCount.itemCount_1, parameter=956},
	{id=10201, text="0", mainGroup=2, bugType=3, itemCount=local_itemCount.itemCount_3, parameter=20201},
	{id=10202, text="6", mainGroup=2, parameter=20201},
	{id=10203, text="28", mainGroup=2, itemCount=local_itemCount.itemCount_5, parameter=20201},
	{id=10204, text="66", mainGroup=2, itemCount=local_itemCount.itemCount_6, parameter=20201},
	{id=10205, mainGroup=2, itemCount=local_itemCount.itemCount_7, parameter=20201},
	{id=10206, text="128", mainGroup=2, itemCount=local_itemCount.itemCount_8, parameter=20201},
	{id=10207, text="168", mainGroup=2, itemCount=local_itemCount.itemCount_9, parameter=20201},
	{id=10208, text="228", mainGroup=2, itemCount=local_itemCount.itemCount_10, parameter=20201},
	{id=10209, text="328", mainGroup=2, itemCount={{10040001,1500},{50010010,200},{50040061,50},{50030005,2}}, parameter=20201},
	{id=20201, text="周末一键购买", mainGroup=2, bugType=2, itemCount=local_itemCount.itemCount_1, parameter=1150},
	{id=10301, text="0", mainGroup=3, bugType=3, itemCount=local_itemCount.itemCount_2, parameter=20301},
	{id=10302, text="6", mainGroup=3, itemCount=local_itemCount.itemCount_11, parameter=20301},
	{id=10303, text="28", mainGroup=3, itemCount=local_itemCount.itemCount_12, parameter=20301},
	{id=10304, text="66", mainGroup=3, itemCount=local_itemCount.itemCount_13, parameter=20301},
	{id=10305, mainGroup=3, itemCount=local_itemCount.itemCount_14, parameter=20301},
	{id=10306, text="128", mainGroup=3, itemCount=local_itemCount.itemCount_15, parameter=20301},
	{id=10307, text="168", mainGroup=3, itemCount=local_itemCount.itemCount_16, parameter=20301},
	{id=10308, text="228", mainGroup=3, itemCount=local_itemCount.itemCount_17, parameter=20301},
	{id=10309, text="328", mainGroup=3, itemCount=local_itemCount.itemCount_18, parameter=20301},
	{id=20301, text="周末一键购买", mainGroup=3, bugType=2, itemCount=local_itemCount.itemCount_1, parameter=2000},
	{id=10401, text="0", mainGroup=4, bugType=3, itemCount=local_itemCount.itemCount_3, parameter=20401},
	{id=10402, text="6", mainGroup=4, parameter=20401},
	{id=10403, text="28", mainGroup=4, itemCount=local_itemCount.itemCount_5, parameter=20401},
	{id=10404, text="66", mainGroup=4, itemCount=local_itemCount.itemCount_6, parameter=20401},
	{id=10405, mainGroup=4, itemCount=local_itemCount.itemCount_7, parameter=20401},
	{id=10406, text="128", mainGroup=4, itemCount=local_itemCount.itemCount_8, parameter=20401},
	{id=10407, text="168", mainGroup=4, itemCount=local_itemCount.itemCount_9, parameter=20401},
	{id=10408, text="228", mainGroup=4, itemCount=local_itemCount.itemCount_10, parameter=20401},
	{id=10409, text="328", mainGroup=4, itemCount={{10040001,1500},{50040061,200},{50040061,50},{50030005,2}}, parameter=20401},
	{id=20401, text="周末一键购买", mainGroup=4, bugType=2, itemCount=local_itemCount.itemCount_1, parameter=1150},
	{id=10501, text="0", mainGroup=5, bugType=3, itemCount=local_itemCount.itemCount_2, parameter=20501},
	{id=10502, text="6", mainGroup=5, itemCount=local_itemCount.itemCount_11, parameter=20501},
	{id=10503, text="28", mainGroup=5, itemCount=local_itemCount.itemCount_12, parameter=20501},
	{id=10504, text="66", mainGroup=5, itemCount=local_itemCount.itemCount_13, parameter=20501},
	{id=10505, mainGroup=5, itemCount=local_itemCount.itemCount_14, parameter=20501},
	{id=10506, text="128", mainGroup=5, itemCount=local_itemCount.itemCount_15, parameter=20501},
	{id=10507, text="168", mainGroup=5, itemCount=local_itemCount.itemCount_16, parameter=20501},
	{id=10508, text="228", mainGroup=5, itemCount=local_itemCount.itemCount_17, parameter=20501},
	{id=10509, text="328", mainGroup=5, itemCount=local_itemCount.itemCount_18, parameter=20501},
	{id=20501, text="周末一键购买", mainGroup=5, bugType=2, itemCount=local_itemCount.itemCount_1, parameter=2000},
	{id=10601, text="0", mainGroup=6, bugType=3, itemCount=local_itemCount.itemCount_3, parameter=20601},
	{id=10602, text="6", mainGroup=6, parameter=20601},
	{id=10603, text="28", mainGroup=6, itemCount=local_itemCount.itemCount_19, parameter=20601},
	{id=10604, text="66", mainGroup=6, itemCount=local_itemCount.itemCount_20, parameter=20601},
	{id=10605, mainGroup=6, itemCount=local_itemCount.itemCount_21, parameter=20601},
	{id=10606, text="128", mainGroup=6, itemCount=local_itemCount.itemCount_22, parameter=20601},
	{id=10607, text="168", mainGroup=6, itemCount=local_itemCount.itemCount_23, parameter=20601},
	{id=10608, text="228", mainGroup=6, itemCount=local_itemCount.itemCount_24, parameter=20601},
	{id=10609, text="328", mainGroup=6, itemCount=local_itemCount.itemCount_25, parameter=20601},
	{id=20601, text="周末一键购买", mainGroup=6, bugType=2, itemCount=local_itemCount.itemCount_1, parameter=1150},
	{id=10701, text="0", mainGroup=7, bugType=3, itemCount=local_itemCount.itemCount_2, parameter=20701},
	{id=10702, text="6", mainGroup=7, itemCount=local_itemCount.itemCount_26, parameter=20701},
	{id=10703, text="28", mainGroup=7, itemCount=local_itemCount.itemCount_27, parameter=20701},
	{id=10704, text="66", mainGroup=7, itemCount=local_itemCount.itemCount_28, parameter=20701},
	{id=10705, mainGroup=7, itemCount=local_itemCount.itemCount_29, parameter=20701},
	{id=10706, text="128", mainGroup=7, itemCount=local_itemCount.itemCount_30, parameter=20701},
	{id=10707, text="168", mainGroup=7, itemCount=local_itemCount.itemCount_31, parameter=20701},
	{id=10708, text="228", mainGroup=7, itemCount=local_itemCount.itemCount_32, parameter=20701},
	{id=10709, text="328", mainGroup=7, itemCount=local_itemCount.itemCount_33, parameter=20701},
	{id=20701, text="周末一键购买", mainGroup=7, bugType=2, itemCount=local_itemCount.itemCount_1, parameter=2000},
	{id=10801, text="0", mainGroup=8, bugType=3, itemCount=local_itemCount.itemCount_3, parameter=20801},
	{id=10802, text="6", mainGroup=8, parameter=20801},
	{id=10803, text="28", mainGroup=8, itemCount=local_itemCount.itemCount_19, parameter=20801},
	{id=10804, text="66", mainGroup=8, itemCount=local_itemCount.itemCount_20, parameter=20801},
	{id=10805, mainGroup=8, itemCount=local_itemCount.itemCount_21, parameter=20801},
	{id=10806, text="128", mainGroup=8, itemCount=local_itemCount.itemCount_22, parameter=20801},
	{id=10807, text="168", mainGroup=8, itemCount=local_itemCount.itemCount_23, parameter=20801},
	{id=10808, text="228", mainGroup=8, itemCount=local_itemCount.itemCount_24, parameter=20801},
	{id=10809, text="328", mainGroup=8, itemCount=local_itemCount.itemCount_25, parameter=20801},
	{id=20801, text="周末一键购买", mainGroup=8, bugType=2, itemCount=local_itemCount.itemCount_1, parameter=1150},
	{text="0", mainGroup=9, bugType=3, itemCount=local_itemCount.itemCount_2, parameter=20901},
	{text="6", mainGroup=9, itemCount=local_itemCount.itemCount_26, parameter=20901},
	{text="28", mainGroup=9, itemCount=local_itemCount.itemCount_27, parameter=20901},
	{text="66", mainGroup=9, itemCount=local_itemCount.itemCount_28, parameter=20901},
	{mainGroup=9, itemCount=local_itemCount.itemCount_29, parameter=20901},
	{text="128", mainGroup=9, itemCount=local_itemCount.itemCount_30, parameter=20901},
	{text="168", mainGroup=9, itemCount=local_itemCount.itemCount_31, parameter=20901},
	{text="228", mainGroup=9, itemCount=local_itemCount.itemCount_32, parameter=20901},
	{text="328", mainGroup=9, itemCount=local_itemCount.itemCount_33, parameter=20901},
	{id=20901, text="周末一键购买", mainGroup=9, bugType=2, itemCount=local_itemCount.itemCount_1, parameter=2000},
	{id=11001, text="0", mainGroup=10, bugType=3, itemCount=local_itemCount.itemCount_3, parameter=21001},
	{id=11002, text="6", mainGroup=10, parameter=21001},
	{id=11003, text="28", mainGroup=10, itemCount=local_itemCount.itemCount_34, parameter=21001},
	{id=11004, text="66", mainGroup=10, itemCount=local_itemCount.itemCount_35, parameter=21001},
	{id=11005, mainGroup=10, itemCount=local_itemCount.itemCount_36, parameter=21001},
	{id=11006, text="128", mainGroup=10, itemCount=local_itemCount.itemCount_37, parameter=21001},
	{id=11007, text="168", mainGroup=10, itemCount=local_itemCount.itemCount_38, parameter=21001},
	{id=11008, text="228", mainGroup=10, itemCount=local_itemCount.itemCount_39, parameter=21001},
	{id=11009, text="328", mainGroup=10, itemCount=local_itemCount.itemCount_40, parameter=21001},
	{id=21001, text="周末一键购买", mainGroup=10, bugType=2, itemCount=local_itemCount.itemCount_1, parameter=1150},
	{id=11101, text="0", mainGroup=11, bugType=3, itemCount=local_itemCount.itemCount_2, parameter=21101},
	{id=11102, text="6", mainGroup=11, itemCount=local_itemCount.itemCount_41, parameter=21101},
	{id=11103, text="28", mainGroup=11, itemCount=local_itemCount.itemCount_42, parameter=21101},
	{id=11104, text="66", mainGroup=11, itemCount=local_itemCount.itemCount_43, parameter=21101},
	{id=11105, mainGroup=11, itemCount=local_itemCount.itemCount_44, parameter=21101},
	{id=11106, text="128", mainGroup=11, itemCount=local_itemCount.itemCount_45, parameter=21101},
	{id=11107, text="168", mainGroup=11, itemCount=local_itemCount.itemCount_46, parameter=21101},
	{id=11108, text="228", mainGroup=11, itemCount=local_itemCount.itemCount_47, parameter=21101},
	{id=11109, text="328", mainGroup=11, itemCount=local_itemCount.itemCount_48, parameter=21101},
	{id=21101, text="周末一键购买", mainGroup=11, bugType=2, itemCount=local_itemCount.itemCount_1, parameter=2000},
	{id=11201, text="0", mainGroup=12, bugType=3, itemCount=local_itemCount.itemCount_3, parameter=21201},
	{id=11202, text="6", mainGroup=12, parameter=21201},
	{id=11203, text="28", mainGroup=12, itemCount=local_itemCount.itemCount_34, parameter=21201},
	{id=11204, text="66", mainGroup=12, itemCount=local_itemCount.itemCount_35, parameter=21201},
	{id=11205, mainGroup=12, itemCount=local_itemCount.itemCount_36, parameter=21201},
	{id=11206, text="128", mainGroup=12, itemCount=local_itemCount.itemCount_37, parameter=21201},
	{id=11207, text="168", mainGroup=12, itemCount=local_itemCount.itemCount_38, parameter=21201},
	{id=11208, text="228", mainGroup=12, itemCount=local_itemCount.itemCount_39, parameter=21201},
	{id=11209, text="328", mainGroup=12, itemCount=local_itemCount.itemCount_40, parameter=21201},
	{id=21201, text="周末一键购买", mainGroup=12, bugType=2, itemCount=local_itemCount.itemCount_1, parameter=1150},
	{id=11301, text="0", mainGroup=13, bugType=3, itemCount=local_itemCount.itemCount_2, parameter=21301},
	{id=11302, text="6", mainGroup=13, itemCount=local_itemCount.itemCount_41, parameter=21301},
	{id=11303, text="28", mainGroup=13, itemCount=local_itemCount.itemCount_42, parameter=21301},
	{id=11304, text="66", mainGroup=13, itemCount=local_itemCount.itemCount_43, parameter=21301},
	{id=11305, mainGroup=13, itemCount=local_itemCount.itemCount_44, parameter=21301},
	{id=11306, text="128", mainGroup=13, itemCount=local_itemCount.itemCount_45, parameter=21301},
	{id=11307, text="168", mainGroup=13, itemCount=local_itemCount.itemCount_46, parameter=21301},
	{id=11308, text="228", mainGroup=13, itemCount=local_itemCount.itemCount_47, parameter=21301},
	{id=11309, text="328", mainGroup=13, itemCount=local_itemCount.itemCount_48, parameter=21301},
	{id=21301, text="周末一键购买", mainGroup=13, bugType=2, itemCount=local_itemCount.itemCount_1, parameter=2000},
	{id=11401, text="0", mainGroup=14, rechargeType=16, bugType=3, itemCount=local_itemCount.itemCount_2, parameter=21401},
	{id=11402, text="6", mainGroup=14, rechargeType=16, itemCount={{10040001,100},{10020001,28000},{50030003,30},{50030004,15}}, parameter=21401},
	{id=11403, text="30", mainGroup=14, rechargeType=16, itemCount=local_itemCount.itemCount_49, parameter=21401},
	{id=11404, text="30", mainGroup=14, rechargeType=16, itemCount=local_itemCount.itemCount_49, parameter=21401},
	{id=11405, mainGroup=14, rechargeType=16, itemCount=local_itemCount.itemCount_50, parameter=21401},
	{id=11406, mainGroup=14, rechargeType=16, itemCount=local_itemCount.itemCount_50, parameter=21401},
	{id=11407, text="168", mainGroup=14, rechargeType=16, itemCount={{10040001,2000},{10020001,680000},{50040061,150},{50030004,200}}, parameter=21401},
	{id=11408, text="198", mainGroup=14, rechargeType=16, itemCount={{10040001,2300},{10020001,980000},{50040061,200},{50030004,200}}, parameter=21401},
	{id=11409, text="328", mainGroup=14, rechargeType=16, itemCount={{10040001,3300},{10020001,1680000},{50040061,300},{50030004,300}}, parameter=21401},
	{id=21401, text="合服一键购买", mainGroup=14, rechargeType=16, bugType=2, itemCount=local_itemCount.itemCount_1, parameter=1050},
}

local defaults = {id=10901, text="98", mainGroup=1, rechargeType=20, bugType=1, itemCount={{10040001,50},{60010002,10},{50030001,10},{50032224,2}}, parameter=20101, img="bg_runActive_direct_1"}
local mt = {__index = defaults}
for _, v in ipairs(cfg_OperateActivity_CDM) do
	setmetatable(v, mt)
end

return cfg_OperateActivity_CDM