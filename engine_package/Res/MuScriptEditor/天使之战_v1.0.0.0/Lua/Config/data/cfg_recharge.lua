-- 此文件工具自动生成，不要修改
---@class cfg_recharge_column
---根据同一个页签内的唯一id 顺序排序 ，id越小越靠前
---@field id number @唯一id column=1 A
---[[客户端不使用]]@field text string @策划备注 column=2 B
---准确的程序要用
---@field name string @组名 column=3 C
---1:充值档位
---2：月卡类型
---3：首充豪礼
---4：每日礼包
---5：单物品礼
---6：每周礼包
---7:终身礼包
---8、VIP礼包
---9：新手礼包
---10:投资基金
---11:每日累充
---12：开服连充
---13：每日馈赠
---14：月卡礼包
---15：钻石礼包
---16：运营活动-直冲礼包                                                                                                                                                                              17：运营活动-累充                                                                                                                                                                                18：运营活动-钻石礼包                                                                                                                                                                                19：运营活动-消费排行
---20：周末活动-直冲礼包
---21：生态服白银卡
---22：生态服黄金卡
---@field type number @充值类型 column=4 D
---对应功能表格id，无关联表格则不用填写
---@field parameter number @类型参数 column=5 E
---去Count_count表取id
---@field Countkey number @限购key column=6 F
---充值给的道具
---格式：道具id#数量|道具id#数量
---道具id关联item表
---@field gain IntListList @获得货币 column=7 G
---当type=1or2时,充值所需金额  单位元
---@field amount number @价格参数 column=8 H
---1、amount字段为空或0时，读取该字段，消耗配置道具
---2、道具id#数量
---@field item IntListList @消耗道具    column=9 I

local local_gain = {
    gain_1={{10040001,480}},
    gain_2={{10040001,980}},
    gain_3={},
    gain_4={{30031062,1},{30032003,1}},

}

local local_item = {
    item_1={},
    item_2={{10050001,0}},

}

local cfg_recharge =
{
	{id=201, name="月卡", type=2, parameter=30030306, Countkey=1, gain={{30030306,1}}, amount=128},
	{id=202, name="日卡", type=2, parameter=30030307, Countkey=2, gain={{30030307,1}}, amount=6},
	{id=10000006, name="充值档位58元", type=1, gain={{10040001,58}}, amount=58},
	{id=10000030, name="充值档位98元", type=1, gain={{10040001,98}}, amount=98},
	{id=10000068, name="充值档位128元", type=1, gain={{10040001,128}}, amount=128},
	{id=10000128, name="充值档位258元", type=1, gain={{10040001,258}}, amount=258},
	{id=10000328, name="充值档位328元", type=1, gain={{10040001,328}}, amount=328},
	{id=10000648, name="充值档位648元", type=1, gain={{10040001,648}}, amount=648},
	{id=10000998, name="充值档位998元", type=1, gain={{10040001,998}}, amount=998},
	{id=10002998, name="充值档位2998元", type=1, gain={{10040001,2998}}, amount=2998},
	{id=10005000, name="充值档位5888元", type=1, gain={{10040001,5888}}, amount=5888},
	{id=301, name="首充6元", type=3, parameter=301, gain={{10040001,60}}, amount=6},
	{id=302, name="首充48元", type=3, parameter=302, gain=local_gain.gain_1, amount=48},
	{id=303, name="首充98元", type=3, parameter=303, gain=local_gain.gain_2, amount=98},
	{id=304, name="首充42元", type=3, parameter=304, gain=local_gain.gain_1, amount=42},
	{id=305, name="首充50元", type=3, parameter=305, gain={{10040001,500}}, amount=50},
	{id=306, name="首充92元", type=3, parameter=306, gain=local_gain.gain_2, amount=92},
	{id=400, name="每日礼包0", type=4, parameter=1, Countkey=3, amount=0},
	{id=401, name="每日礼包6", type=4, parameter=2, Countkey=4, amount=6},
	{id=402, name="每日礼包12", type=4, parameter=3, Countkey=5, amount=12},
	{id=403, name="每日礼包30", type=4, parameter=4, Countkey=6, amount=30},
	{id=404, name="每日礼包98", type=4, parameter=5, Countkey=7, amount=98},
	{id=405, name="每日礼包168", type=4, parameter=6, Countkey=8, amount=168},
	{id=406, name="每日礼包228", type=4, parameter=7, Countkey=9, amount=228},
	{id=407, name="每日礼包328", type=4, parameter=8, Countkey=10, amount=328},
	{id=408, name="每日礼包598", type=4, parameter=9, Countkey=11, amount=598},
	{id=409, name="每日礼包68", type=4, parameter=10, Countkey=12, amount=68},
	{id=410, name="每日礼包98", type=4, parameter=11, Countkey=13, amount=98},
	{id=411, name="每日礼包188", type=4, parameter=12, Countkey=14, amount=188},
	{id=501, name="雷刃炎狼兽", type=5, parameter=501, Countkey=19, amount=98},
	{id=601, name="免费礼包", type=6, parameter=21, Countkey=44, amount=0},
	{id=602, name="首饰突破礼包", type=6, parameter=22, Countkey=45, amount=30},
	{id=603, name="变身突破礼包", type=6, parameter=23, Countkey=46, amount=168},
	{id=604, name="大天使材料礼包", type=6, parameter=24, Countkey=47, amount=238},
	{id=605, name="材料礼包", type=6, parameter=25, Countkey=48, amount=328},
	{id=701, name="技能觉醒礼包", type=7, parameter=7001, Countkey=16, amount=18},
	{id=702, name="连击进阶礼包", type=7, parameter=7002, Countkey=17, amount=128},
	{id=703, name="boss礼包", type=7, parameter=7003, Countkey=18, amount=128},
	{id=811, name="VIP1", type=8, parameter=811, Countkey=20, item={{10050001,1280}}},
	{id=812, name="VIP2", type=8, parameter=812, Countkey=21, item={{10050001,5280}}},
	{id=813, name="VIP3", type=8, parameter=813, Countkey=22, item={{10050001,9980}}},
	{id=814, name="VIP4", type=8, parameter=814, Countkey=23, item={{10050001,15580}}},
	{id=815, name="VIP5", type=8, parameter=815, Countkey=24, item={{10050001,23880}}},
	{id=816, name="VIP6", type=8, parameter=816, Countkey=25, item={{10050001,38880}}},
	{id=817, name="VIP7", type=8, parameter=817, Countkey=26, item={{10050001,58880}}},
	{id=821, name="VIP1专属礼包", type=8, parameter=821, Countkey=28, item=local_item.item_2},
	{id=822, name="VIP2专属礼包", type=8, parameter=822, Countkey=29, item=local_item.item_2},
	{id=823, name="VIP3专属礼包", type=8, parameter=823, Countkey=30, item=local_item.item_2},
	{id=824, name="VIP4专属礼包", type=8, parameter=824, Countkey=31, item=local_item.item_2},
	{id=825, name="VIP5专属礼包", type=8, parameter=825, Countkey=32, item=local_item.item_2},
	{id=826, name="VIP6专属礼包", type=8, parameter=826, Countkey=33, item=local_item.item_2},
	{id=827, name="VIP7专属礼包", type=8, parameter=827, Countkey=34, item=local_item.item_2},
	{id=831, name="VIP1超值礼包", type=8, parameter=831, Countkey=36, item={{10050001,680}}},
	{id=832, name="VIP2超值礼包", type=8, parameter=832, Countkey=37, item={{10050001,1680}}},
	{id=833, name="VIP3超值礼包", type=8, parameter=833, Countkey=38, item={{10050001,3280}}},
	{id=834, name="VIP4超值礼包", type=8, parameter=834, Countkey=39, item={{10050001,6880}}},
	{id=835, name="VIP5超值礼包", type=8, parameter=835, Countkey=40, item={{10050001,13800}}},
	{id=836, name="VIP6超值礼包", type=8, parameter=836, Countkey=41, item={{10050001,18800}}},
	{id=837, name="VIP7超值礼包", type=8, parameter=837, Countkey=42, item={{10050001,25800}}},
	{id=901, name="免费", type=9, parameter=9001, Countkey=80, amount=0},
	{id=902, name="经验药水", type=9, parameter=9002, Countkey=81, amount=18},
	{id=903, name="幸运宝石礼包", type=9, parameter=9003, Countkey=82, amount=128},
	{id=904, name="守护叠加礼包", type=9, parameter=9004, Countkey=83, amount=128},
	{id=905, name="大天使礼包", type=9, parameter=9005, Countkey=84, amount=328},
	{id=1401, name="畅享月卡", type=14, parameter=7001, Countkey=1021, amount=30},
	{id=1402, name="尊享月卡", type=14, parameter=7002, Countkey=1022, amount=98},
	{id=1403, name="双买月卡", type=14, parameter=7003, Countkey=1023, amount=108},
	{id=1001, name="投资基金礼包1", type=10, parameter=1, Countkey=85, amount=128},
	{id=1002, name="投资基金礼包2", type=10, parameter=2, Countkey=86, gain={{10040001,700}}, amount=38},
	{id=1003, name="钻石礼包0", type=15, parameter=1, Countkey=1401, item=local_item.item_2},
	{id=1004, name="钻石礼包68", type=15, parameter=2, Countkey=1402, item={{10050001,68}}},
	{id=1005, name="钻石礼包128", type=15, parameter=3, Countkey=1403, item={{10050001,128}}},
	{id=1006, name="钻石礼包388", type=15, parameter=4, Countkey=1404, item={{10050001,388}}},
	{id=1007, name="钻石礼包988", type=15, parameter=5, Countkey=1405, item={{10050001,988}}},
	{id=1008, name="钻石礼包1688", type=15, parameter=6, Countkey=1406, item={{10050001,1688}}},
	{id=1009, name="钻石礼包2988", type=15, parameter=7, Countkey=1407, item={{10050001,2988}}},
	{id=1010, name="钻石礼包6", type=15, parameter=8, Countkey=1408, item={{10050001}}},
	{id=2001, name="免费跨服幸运礼包", type=16, parameter=10101, Countkey=15001, amount=0},
	{id=2002, name="6元跨服宝石礼包", type=16, parameter=10102, Countkey=15002, amount=6},
	{id=2003, name="30元跨服变身礼包", type=16, parameter=10103, Countkey=15003, amount=30},
	{id=2004, name="30元跨服天使礼包", type=16, parameter=10104, Countkey=15004, amount=30},
	{id=2005, name="98元跨服变身礼包", type=16, parameter=10105, Countkey=15005, amount=98},
	{id=2006, name="98元跨服天使礼包", type=16, parameter=10106, Countkey=15006, amount=98},
	{id=2007, name="168元跨服变身礼包", type=16, parameter=10107, Countkey=15007, amount=168},
	{id=2008, name="198元跨服天使礼包", type=16, parameter=10108, Countkey=15008, amount=198},
	{id=2009, name="328元跨服终极礼包", type=16, parameter=10109, Countkey=15009, amount=328},
	{id=2010, type=16, parameter=20101, Countkey=15010, amount=798},
	{id=2011, name="免费合服幸运礼包", type=16, parameter=11401, Countkey=15131, amount=0},
	{id=2012, name="6元合服宝石礼包", type=16, parameter=11402, Countkey=15132, amount=6},
	{id=2013, name="30元合服变身礼包", type=16, parameter=11403, Countkey=15133, amount=30},
	{id=2014, name="30元合服天使礼包", type=16, parameter=11404, Countkey=15134, amount=30},
	{id=2015, name="98元合服变身礼包", type=16, parameter=11405, Countkey=15135, amount=98},
	{id=2016, name="98元合服天使礼包", type=16, parameter=11406, Countkey=15136, amount=98},
	{id=2017, name="168元合服变身礼包", type=16, parameter=11407, Countkey=15137, amount=168},
	{id=2018, name="198元合服天使礼包", type=16, parameter=11408, Countkey=15138, amount=198},
	{id=2019, name="328元合服终极礼包", type=16, parameter=11409, Countkey=15139, amount=328},
	{id=2020, type=16, parameter=21401, Countkey=15140, amount=798},
	{id=2021, name="免费周末幸运礼包", parameter=10201, Countkey=15011, amount=0},
	{id=2022, name="6元周末宝石礼包", parameter=10202, Countkey=15012, amount=6},
	{id=2023, name="28元周末变身礼包", parameter=10203, Countkey=15013, amount=28},
	{id=2024, name="66元周末天使礼包", parameter=10204, Countkey=15014, amount=66},
	{id=2025, name="98元周末变身礼包", parameter=10205, Countkey=15015, amount=98},
	{id=2026, name="128元周末天使礼包", parameter=10206, Countkey=15016, amount=128},
	{id=2027, name="168元周末变身礼包", parameter=10207, Countkey=15017, amount=168},
	{id=2028, name="228元周末天使礼包", parameter=10208, Countkey=15018, amount=228},
	{id=2029, name="328元周末终极礼包", parameter=10209, Countkey=15019, amount=328},
	{id=2030, parameter=20201, Countkey=15020, amount=899},
	{id=2031, name="免费周末幸运礼包", parameter=10301, Countkey=15021, amount=0},
	{id=2032, name="6元周末宝石礼包", parameter=10302, Countkey=15022, amount=6},
	{id=2033, name="28元周末变身礼包", parameter=10303, Countkey=15023, amount=28},
	{id=2034, name="66元周末天使礼包", parameter=10304, Countkey=15024, amount=66},
	{id=2035, name="98元周末变身礼包", parameter=10305, Countkey=15025, amount=98},
	{id=2036, name="128元周末天使礼包", parameter=10306, Countkey=15026, amount=128},
	{id=2037, name="168元周末变身礼包", parameter=10307, Countkey=15027, amount=168},
	{id=2038, name="228元周末天使礼包", parameter=10308, Countkey=15028, amount=228},
	{id=2039, name="328元周末终极礼包", parameter=10309, Countkey=15029, amount=328},
	{id=2040, parameter=20301, Countkey=15030, amount=1599},
	{id=2041, name="免费周末幸运礼包", parameter=10401, Countkey=15031, amount=0},
	{id=2042, name="6元周末宝石礼包", parameter=10402, Countkey=15032, amount=6},
	{id=2043, name="28元周末变身礼包", parameter=10403, Countkey=15033, amount=28},
	{id=2044, name="66元周末天使礼包", parameter=10404, Countkey=15034, amount=66},
	{id=2045, name="98元周末变身礼包", parameter=10405, Countkey=15035, amount=98},
	{id=2046, name="128元周末天使礼包", parameter=10406, Countkey=15036, amount=128},
	{id=2047, name="168元周末变身礼包", parameter=10407, Countkey=15037, amount=168},
	{id=2048, name="228元周末天使礼包", parameter=10408, Countkey=15038, amount=228},
	{id=2049, name="328元周末终极礼包", parameter=10409, Countkey=15039, amount=328},
	{id=2050, parameter=20401, Countkey=15040, amount=899},
	{id=2051, name="免费周末幸运礼包", parameter=10501, Countkey=15041, amount=0},
	{id=2052, name="6元周末宝石礼包", parameter=10502, Countkey=15042, amount=6},
	{id=2053, name="28元周末变身礼包", parameter=10503, Countkey=15043, amount=28},
	{id=2054, name="66元周末天使礼包", parameter=10504, Countkey=15044, amount=66},
	{id=2055, name="98元周末变身礼包", parameter=10505, Countkey=15045, amount=98},
	{id=2056, name="128元周末天使礼包", parameter=10506, Countkey=15046, amount=128},
	{id=2057, name="168元周末变身礼包", parameter=10507, Countkey=15047, amount=168},
	{id=2058, name="228元周末天使礼包", parameter=10508, Countkey=15048, amount=228},
	{id=2059, name="328元周末终极礼包", parameter=10509, Countkey=15049, amount=328},
	{id=2060, parameter=20501, Countkey=15050, amount=1599},
	{id=2061, name="免费周末幸运礼包", parameter=10601, Countkey=15051, amount=0},
	{id=2062, name="6元周末宝石礼包", parameter=10602, Countkey=15052, amount=6},
	{id=2063, name="28元周末变身礼包", parameter=10603, Countkey=15053, amount=28},
	{id=2064, name="66元周末天使礼包", parameter=10604, Countkey=15054, amount=66},
	{id=2065, name="98元周末变身礼包", parameter=10605, Countkey=15055, amount=98},
	{id=2066, name="128元周末天使礼包", parameter=10606, Countkey=15056, amount=128},
	{id=2067, name="168元周末变身礼包", parameter=10607, Countkey=15057, amount=168},
	{id=2068, name="228元周末天使礼包", parameter=10608, Countkey=15058, amount=228},
	{id=2069, name="328元周末终极礼包", parameter=10609, Countkey=15059, amount=328},
	{id=2070, parameter=20601, Countkey=15060, amount=899},
	{id=2071, name="免费周末幸运礼包", parameter=10701, Countkey=15061, amount=0},
	{id=2072, name="6元周末宝石礼包", parameter=10702, Countkey=15062, amount=6},
	{id=2073, name="28元周末变身礼包", parameter=10703, Countkey=15063, amount=28},
	{id=2074, name="66元周末天使礼包", parameter=10704, Countkey=15064, amount=66},
	{id=2075, name="98元周末变身礼包", parameter=10705, Countkey=15065, amount=98},
	{id=2076, name="128元周末天使礼包", parameter=10706, Countkey=15066, amount=128},
	{id=2077, name="168元周末变身礼包", parameter=10707, Countkey=15067, amount=168},
	{id=2078, name="228元周末天使礼包", parameter=10708, Countkey=15068, amount=228},
	{id=2079, name="328元周末终极礼包", parameter=10709, Countkey=15069, amount=328},
	{id=2080, parameter=20701, Countkey=15070, amount=1599},
	{id=2081, name="免费周末幸运礼包", parameter=10801, Countkey=15071, amount=0},
	{id=2082, name="6元周末宝石礼包", parameter=10802, Countkey=15072, amount=6},
	{id=2083, name="28元周末变身礼包", parameter=10803, Countkey=15073, amount=28},
	{id=2084, name="66元周末天使礼包", parameter=10804, Countkey=15074, amount=66},
	{id=2085, name="98元周末变身礼包", parameter=10805, Countkey=15075, amount=98},
	{id=2086, name="128元周末天使礼包", parameter=10806, Countkey=15076, amount=128},
	{id=2087, name="168元周末变身礼包", parameter=10807, Countkey=15077, amount=168},
	{id=2088, name="228元周末天使礼包", parameter=10808, Countkey=15078, amount=228},
	{id=2089, name="328元周末终极礼包", parameter=10809, Countkey=15079, amount=328},
	{id=2090, parameter=20801, Countkey=15080, amount=899},
	{id=2091, name="免费周末幸运礼包", parameter=10901, Countkey=15081, amount=0},
	{id=2092, name="6元周末宝石礼包", parameter=10901, Countkey=15082, amount=6},
	{id=2093, name="28元周末变身礼包", parameter=10901, Countkey=15083, amount=28},
	{id=2094, name="66元周末天使礼包", parameter=10901, Countkey=15084, amount=66},
	{id=2095, name="98元周末变身礼包", parameter=10901, Countkey=15085, amount=98},
	{id=2096, name="128元周末天使礼包", parameter=10901, Countkey=15086, amount=128},
	{id=2097, name="168元周末变身礼包", parameter=10901, Countkey=15087, amount=168},
	{id=2098, name="228元周末天使礼包", parameter=10901, Countkey=15088, amount=228},
	{id=2099, name="328元周末终极礼包", parameter=10901, Countkey=15089, amount=328},
	{id=2100, parameter=20901, Countkey=15090, amount=1599},
	{id=2101, name="免费周末幸运礼包", parameter=11001, Countkey=15091, amount=0},
	{id=2102, name="6元周末宝石礼包", parameter=11002, Countkey=15092, amount=6},
	{id=2103, name="28元周末变身礼包", parameter=11003, Countkey=15093, amount=28},
	{id=2104, name="66元周末天使礼包", parameter=11004, Countkey=15094, amount=66},
	{id=2105, name="98元周末变身礼包", parameter=11005, Countkey=15095, amount=98},
	{id=2106, name="128元周末天使礼包", parameter=11006, Countkey=15096, amount=128},
	{id=2107, name="168元周末变身礼包", parameter=11007, Countkey=15097, amount=168},
	{id=2108, name="228元周末天使礼包", parameter=11008, Countkey=15098, amount=228},
	{id=2109, name="328元周末终极礼包", parameter=11009, Countkey=15099, amount=328},
	{id=2110, parameter=21001, Countkey=15100, amount=899},
	{id=2111, name="免费周末幸运礼包", parameter=11101, Countkey=15101, amount=0},
	{id=2112, name="6元周末宝石礼包", parameter=11102, Countkey=15102, amount=6},
	{id=2113, name="28元周末变身礼包", parameter=11103, Countkey=15103, amount=28},
	{id=2114, name="66元周末天使礼包", parameter=11104, Countkey=15104, amount=66},
	{id=2115, name="98元周末变身礼包", parameter=11105, Countkey=15105, amount=98},
	{id=2116, name="128元周末天使礼包", parameter=11106, Countkey=15106, amount=128},
	{id=2117, name="168元周末变身礼包", parameter=11107, Countkey=15107, amount=168},
	{id=2118, name="228元周末天使礼包", parameter=11108, Countkey=15108, amount=228},
	{id=2119, name="328元周末终极礼包", parameter=11109, Countkey=15109, amount=328},
	{id=2120, parameter=21101, Countkey=15110, amount=1599},
	{id=2121, name="免费周末幸运礼包", parameter=11201, Countkey=15111, amount=0},
	{id=2122, name="6元周末宝石礼包", parameter=11202, Countkey=15112, amount=6},
	{id=2123, name="28元周末变身礼包", parameter=11203, Countkey=15113, amount=28},
	{id=2124, name="66元周末天使礼包", parameter=11204, Countkey=15114, amount=66},
	{id=2125, name="98元周末变身礼包", parameter=11205, Countkey=15115, amount=98},
	{id=2126, name="128元周末天使礼包", parameter=11206, Countkey=15116, amount=128},
	{id=2127, name="168元周末变身礼包", parameter=11207, Countkey=15117, amount=168},
	{id=2128, name="228元周末天使礼包", parameter=11208, Countkey=15118, amount=228},
	{id=2129, name="328元周末终极礼包", parameter=11209, Countkey=15119, amount=328},
	{id=2130, parameter=21201, Countkey=15120, amount=899},
	{id=2131, name="免费周末幸运礼包", parameter=11301, Countkey=15121, amount=0},
	{id=2132, name="6元周末宝石礼包", parameter=11302, Countkey=15122, amount=6},
	{id=2133, name="28元周末变身礼包", parameter=11303, Countkey=15123, amount=28},
	{id=2134, name="66元周末天使礼包", parameter=11304, Countkey=15124, amount=66},
	{id=2135, name="98元周末变身礼包", parameter=11305, Countkey=15125, amount=98},
	{id=2136, name="128元周末天使礼包", parameter=11306, Countkey=15126, amount=128},
	{id=2137, name="168元周末变身礼包", parameter=11307, Countkey=15127, amount=168},
	{id=2138, name="228元周末天使礼包", parameter=11308, Countkey=15128, amount=228},
	{id=2139, name="328元周末终极礼包", parameter=11309, Countkey=15129, amount=328},
	{id=2140, parameter=21301, Countkey=15130, amount=1599},
	{id=3001, name="月卡", type=21, Countkey=21001, gain=local_gain.gain_4, amount=58},
	{id=3002, name="月卡", type=23, Countkey=21002, gain={{30031063,1},{30032001,1}}, amount=12},
	{id=3003, name="月卡", type=23, Countkey=21003, gain={{30031064,1},{30032003,1}}, amount=328},
	{id=4001, name="月卡", type=22, Countkey=21001, gain=local_gain.gain_4, amount=58},
}

local defaults = {name="一键购买", type=20, parameter=0, Countkey=0, gain={}, amount=0, item={}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_recharge) do
	setmetatable(v, mt)
end

return cfg_recharge