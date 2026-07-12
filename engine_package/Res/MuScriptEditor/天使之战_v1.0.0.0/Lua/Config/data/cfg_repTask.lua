-- 此文件工具自动生成，不要修改
---@class cfg_repTask_column
---当前任务ID
---@field id number @唯一id column=1 A
---策划备注
---@field cehua string @备注 column=2 B
---任务名
---@field name string @任务名 column=3 C
---任务描述
---@field UItext string @任务描述 column=4 D
---下一个任务ID
---@field nextID number @下一个任务ID column=5 E
---1、杀怪
---2、杀指定的怪
---3、拾取指定道具到指定npc对话   走交接任务判定
---@field type number @任务类型 column=6 F
---1、杀怪数量
---2、怪物ID#数量
---3、道具ID#npclistID
---@field param IntList @任务参数 column=7 G
---完成任务后立刻获得的奖励
---格式：道具ID#数量#权重|道具ID#数量#权重|道具ID#数量#权重
---@field reward IntListList @任务奖励 column=8 H
---@field moveTo IntList @前往地点 column=9 I

local local_param = {
    param_1={100},
    param_2={21010001,101201},
    param_3={46001,1},
    param_4={46002,1},
    param_5={46003,1},
    param_6={2},

}

local local_reward = {
    reward_1={},
    reward_2={{1253000199,1,1}},

}

local local_moveTo = {
    moveTo_1={},
    moveTo_2={93,114},
    moveTo_3={107,161},
    moveTo_4={93,204},
    moveTo_5={94,237},
    moveTo_6={82,134},

}

local cfg_repTask =
{
	{id=11001001, cehua="血色广场1-第1阶段", name="阶段一", UItext="击杀出现的怪物", nextID=11001002, type=1, param=local_param.param_1},
	{id=11001002, cehua="血色广场1-第2阶段", name="阶段二", UItext="破坏城门", nextID=11001003, param={11001007,1}},
	{id=11001003, cehua="血色广场1-第3阶段", name="阶段三", UItext="击杀骷灵巫师", nextID=11001004, param={11001006,2}},
	{id=11001004, cehua="血色广场1-第4阶段", name="阶段四", UItext="破坏水晶灵柩", nextID=11001005, param={11001008,1}},
	{id=11001005, cehua="血色广场1-第5阶段", name="阶段五", UItext="交付大天使武器给受伤的大天使使者，获取任务奖励", type=3, reward=local_reward.reward_2},
	{id=11002001, cehua="血色广场2-第1阶段", name="阶段一", UItext="击杀出现的怪物", nextID=11002002, type=1, param=local_param.param_1},
	{id=11002002, cehua="血色广场2-第2阶段", name="阶段二", UItext="破坏城门", nextID=11002003, param={11002007,1}},
	{id=11002003, cehua="血色广场2-第3阶段", name="阶段三", UItext="击杀骷灵巫师", nextID=11002004, param={11002006,2}},
	{id=11002004, cehua="血色广场2-第4阶段", name="阶段四", UItext="破坏水晶灵柩", nextID=11002005, param={11002008,1}},
	{id=11002005, cehua="血色广场2-第5阶段", name="阶段五", UItext="交付大天使武器给受伤的大天使使者，获取任务奖励", type=3, reward=local_reward.reward_2},
	{id=11003001, cehua="血色广场3-第1阶段", name="阶段一", UItext="击杀出现的怪物", nextID=11003002, type=1, param=local_param.param_1},
	{id=11003002, cehua="血色广场3-第2阶段", name="阶段二", UItext="破坏城门", nextID=11003003, param={11003007,1}},
	{id=11003003, cehua="血色广场3-第3阶段", name="阶段三", UItext="击杀骷灵巫师", nextID=11003004, param={11003006,2}},
	{id=11003004, cehua="血色广场3-第4阶段", name="阶段四", UItext="破坏水晶灵柩", nextID=11003005, param={11003008,1}},
	{id=11003005, cehua="血色广场3-第5阶段", name="阶段五", UItext="交付大天使武器给受伤的大天使使者，获取任务奖励", type=3, reward=local_reward.reward_2},
	{id=11004001, cehua="血色广场4-第1阶段", name="阶段一", UItext="击杀出现的怪物", nextID=11004002, type=1, param=local_param.param_1},
	{id=11004002, cehua="血色广场4-第2阶段", name="阶段二", UItext="破坏城门", nextID=11004003, param={11004007,1}},
	{id=11004003, cehua="血色广场4-第3阶段", name="阶段三", UItext="击杀骷灵巫师", nextID=11004004, param={11004006,2}},
	{id=11004004, cehua="血色广场4-第4阶段", name="阶段四", UItext="破坏水晶灵柩", nextID=11004005, param={11004008,1}},
	{id=11004005, cehua="血色广场4-第5阶段", name="阶段五", UItext="交付大天使武器给受伤的大天使使者，获取任务奖励", type=3, reward=local_reward.reward_2},
	{id=11005001, cehua="血色广场5-第1阶段", name="阶段一", UItext="击杀出现的怪物", nextID=11005002, type=1, param=local_param.param_1},
	{id=11005002, cehua="血色广场5-第2阶段", name="阶段二", UItext="破坏城门", nextID=11005003, param={11005007,1}},
	{id=11005003, cehua="血色广场5-第3阶段", name="阶段三", UItext="击杀骷灵巫师", nextID=11005004, param={11005006,2}},
	{id=11005004, cehua="血色广场5-第4阶段", name="阶段四", UItext="破坏水晶灵柩", nextID=11005005, param={11005008,1}},
	{id=11005005, cehua="血色广场5-第5阶段", name="阶段五", UItext="交付大天使武器给受伤的大天使使者，获取任务奖励", type=3, reward=local_reward.reward_2},
	{id=11006001, cehua="血色广场6-第1阶段", name="阶段一", UItext="击杀出现的怪物", nextID=11006002, type=1, param=local_param.param_1},
	{id=11006002, cehua="血色广场6-第2阶段", name="阶段二", UItext="破坏城门", nextID=11006003, param={11006007,1}},
	{id=11006003, cehua="血色广场6-第3阶段", name="阶段三", UItext="击杀骷灵巫师", nextID=11006004, param={11006006,2}},
	{id=11006004, cehua="血色广场6-第4阶段", name="阶段四", UItext="破坏水晶灵柩", nextID=11006005, param={11006008,1}},
	{id=11006005, cehua="血色广场6-第5阶段", name="阶段五", UItext="交付大天使武器给受伤的大天使使者，获取任务奖励", type=3, reward=local_reward.reward_2},
	{id=11007001, cehua="血色广场7-第1阶段", name="阶段一", UItext="击杀出现的怪物", nextID=11007002, type=1, param=local_param.param_1},
	{id=11007002, cehua="血色广场7-第2阶段", name="阶段二", UItext="破坏城门", nextID=11007003, param={11007007,1}},
	{id=11007003, cehua="血色广场7-第3阶段", name="阶段三", UItext="击杀骷灵巫师", nextID=11007004, param={11007006,2}},
	{id=11007004, cehua="血色广场7-第4阶段", name="阶段四", UItext="破坏水晶灵柩", nextID=11007005, param={11007008,1}},
	{id=11007005, cehua="血色广场7-第5阶段", name="阶段五", UItext="交付大天使武器给受伤的大天使使者，获取任务奖励", type=3, reward=local_reward.reward_2},
	{id=11008001, cehua="血色广场8-第1阶段", name="阶段一", UItext="击杀出现的怪物", nextID=11008002, type=1, param=local_param.param_1},
	{id=11008002, cehua="血色广场8-第2阶段", name="阶段二", UItext="破坏城门", nextID=11008003, param={11008007,1}},
	{id=11008003, cehua="血色广场8-第3阶段", name="阶段三", UItext="击杀骷灵巫师", nextID=11008004, param={11008006,2}},
	{id=11008004, cehua="血色广场8-第4阶段", name="阶段四", UItext="破坏水晶灵柩", nextID=11008005, param={11008008,1}},
	{id=11008005, cehua="血色广场8-第5阶段", name="阶段五", UItext="交付大天使武器给受伤的大天使使者，获取任务奖励", type=3, reward=local_reward.reward_2},
	{id=11009001, cehua="血色广场9-第1阶段", name="阶段一", UItext="击杀出现的怪物", nextID=11009002, type=1, param=local_param.param_1},
	{id=11009002, cehua="血色广场9-第2阶段", name="阶段二", UItext="破坏城门", nextID=11009003, param={11009007,1}},
	{id=11009003, cehua="血色广场9-第3阶段", name="阶段三", UItext="击杀骷灵巫师", nextID=11009004, param={11009006,2}},
	{id=11009004, cehua="血色广场9-第4阶段", name="阶段四", UItext="破坏水晶灵柩", nextID=11009005, param={11009008,1}},
	{id=11009005, cehua="血色广场9-第5阶段", name="阶段五", UItext="交付大天使武器给受伤的大天使使者，获取任务奖励", type=3, reward=local_reward.reward_2},
	{id=11010001, cehua="血色广场10-第1阶段", name="阶段一", UItext="击杀出现的怪物", nextID=11010002, type=1, param=local_param.param_1},
	{id=11010002, cehua="血色广场10-第2阶段", name="阶段二", UItext="破坏城门", nextID=11010003, param={11010007,1}},
	{id=11010003, cehua="血色广场10-第3阶段", name="阶段三", UItext="击杀骷灵巫师", nextID=11010004, param={11010006,2}},
	{id=11010004, cehua="血色广场10-第4阶段", name="阶段四", UItext="破坏水晶灵柩", nextID=11010005, param={11010008,1}},
	{id=11010005, cehua="血色广场10-第5阶段", name="阶段五", UItext="交付大天使武器给受伤的大天使使者，获取任务奖励", type=3, reward=local_reward.reward_2},
	{id=16001001, name="阶段1", UItext="摧毁外城门", nextID=16001002, param=local_param.param_3, moveTo=local_moveTo.moveTo_2},
	{id=16001002, name="阶段2", UItext="摧毁中城门", nextID=16001003, param=local_param.param_4, moveTo=local_moveTo.moveTo_3},
	{id=16001003, name="阶段3", UItext="摧毁内城门", nextID=16001004, param=local_param.param_5, moveTo=local_moveTo.moveTo_4},
	{id=16001004, name="阶段4", UItext="占领罗兰之冠", type=5, param={1}, moveTo=local_moveTo.moveTo_5},
	{id=16001101, cehua="攻城战-守方任务", name="阶段1", UItext="守护外城门", nextID=16001102, param=local_param.param_3, moveTo=local_moveTo.moveTo_2},
	{id=16001102, cehua="攻城战-守方任务", name="阶段2", UItext="守护中城门", nextID=16001103, param=local_param.param_4, moveTo=local_moveTo.moveTo_3},
	{id=16001103, cehua="攻城战-守方任务", name="阶段3", UItext="守护内城门", nextID=16001104, param=local_param.param_5, reward={{10240001,10000,1}}, moveTo=local_moveTo.moveTo_4},
	{id=16001104, cehua="攻城战-守方任务", name="阶段4", UItext="守护罗兰之冠", type=5, param=local_param.param_6, moveTo=local_moveTo.moveTo_5},
	{id=21001001, cehua="昆顿入侵", name="昆顿入侵", UItext="击杀昆顿", param={21001001,1}, moveTo=local_moveTo.moveTo_6},
	{id=27001001, cehua="咒怨魔王", name="咒怨魔王", UItext="击杀小怪", nextID=27001002, type=1, param=local_param.param_6, moveTo=local_moveTo.moveTo_6},
	{id=27001002, cehua="咒怨魔王", name="咒怨魔王", UItext="击杀魔王", param={13006,1}, moveTo=local_moveTo.moveTo_6},
	{id=14001011, cehua="战盟boss第1天第1层", nextID=14001012, param={47001,1}},
	{id=14001012, cehua="战盟boss第1天第2层", nextID=14001013, param={47002,1}},
	{id=14001013, cehua="战盟boss第1天第3层", nextID=14001014, param={47003,1}},
	{id=14001014, cehua="战盟boss第1天第4层", nextID=14001015, param={47004,1}},
	{id=14001015, cehua="战盟boss第1天第5层", param={47005,1}},
	{id=14001021, cehua="战盟boss第2-第3天第1层", nextID=14001022, param={47006,1}},
	{id=14001022, cehua="战盟boss第2-第3天第2层", nextID=14001023, param={47007,1}},
	{id=14001023, cehua="战盟boss第2-第3天第3层", nextID=14001024, param={47008,1}},
	{id=14001024, cehua="战盟boss第2-第3天第4层", nextID=14001025, param={47009,1}},
	{id=14001025, cehua="战盟boss第2-第3天第5层", param={47010,1}},
	{id=14001031, cehua="战盟boss第4-第8天第1层", nextID=14001032, param={47011,1}},
	{id=14001032, cehua="战盟boss第4-第8天第2层", nextID=14001033, param={47012,1}},
	{id=14001033, cehua="战盟boss第4-第8天第3层", nextID=14001034, param={47013,1}},
	{id=14001034, cehua="战盟boss第4-第8天第4层", nextID=14001035, param={47014,1}},
	{id=14001035, cehua="战盟boss第4-第8天第5层", param={47015,1}},
	{id=14001041, cehua="战盟boss第9-第19天第1层", nextID=14001042, param={47016,1}},
	{id=14001042, cehua="战盟boss第9-第19天第2层", nextID=14001043, param={47017,1}},
	{id=14001043, cehua="战盟boss第9-第19天第3层", nextID=14001044, param={47018,1}},
	{id=14001044, cehua="战盟boss第9-第19天第4层", nextID=14001045, param={47019,1}},
	{id=14001045, cehua="战盟boss第9-第19天第5层", param={47020,1}},
	{id=14001051, cehua="战盟boss第20-第43天第1层", nextID=14001052, param={47021,1}},
	{id=14001052, cehua="战盟boss第20-第43天第2层", nextID=14001053, param={47022,1}},
	{id=14001053, cehua="战盟boss第20-第43天第3层", nextID=14001054, param={47023,1}},
	{id=14001054, cehua="战盟boss第20-第43天第4层", nextID=14001055, param={47024,1}},
	{id=14001055, cehua="战盟boss第20-第43天第5层", param={47025,1}},
	{id=14001061, cehua="战盟boss第44-第82天第1层", nextID=14001062, param={47026,1}},
	{id=14001062, cehua="战盟boss第44-第82天第2层", nextID=14001063, param={47027,1}},
	{id=14001063, cehua="战盟boss第44-第82天第3层", nextID=14001064, param={47028,1}},
	{id=14001064, cehua="战盟boss第44-第82天第4层", nextID=14001065, param={47029,1}},
	{id=14001065, cehua="战盟boss第44-第82天第5层", param={47030,1}},
	{id=14001071, cehua="战盟boss第83-第124天第1层", nextID=14001072, param={47031,1}},
	{id=14001072, cehua="战盟boss第83-第124天第2层", nextID=14001073, param={47032,1}},
	{id=14001073, cehua="战盟boss第83-第124天第3层", nextID=14001074, param={47033,1}},
	{id=14001074, cehua="战盟boss第83-第124天第4层", nextID=14001075, param={47034,1}},
	{id=14001075, cehua="战盟boss第83-第124天第5层", param={47035,1}},
	{id=14001081, cehua="战盟boss第125-后续天数第1层", nextID=14001082, param={47036,1}},
	{id=14001082, cehua="战盟boss第125-后续天数第2层", nextID=14001083, param={47037,1}},
	{id=14001083, cehua="战盟boss第125-后续天数第3层", nextID=14001084, param={47038,1}},
	{id=14001084, cehua="战盟boss第125-后续天数第4层", nextID=14001085, param={47039,1}},
	{id=14001085, cehua="战盟boss第125-后续天数第5层", param={47040,1}},
	{id=20001001, cehua="卡利玛神庙第1层", name="击杀任务", UItext="击杀昆顿", param={102500009,1}},
	{id=20001002, cehua="卡利玛神庙第2层", name="击杀任务", UItext="击杀昆顿", param={102500019,1}},
	{id=20001003, cehua="卡利玛神庙第3层", name="击杀任务", UItext="击杀昆顿", param={102500029,1}},
	{id=20001004, cehua="卡利玛神庙第4层", name="击杀任务", UItext="击杀昆顿", param={102500039,1}},
	{id=20001005, cehua="卡利玛神庙第5层", name="击杀任务", UItext="击杀昆顿", param={102500049,1}},
	{id=20001006, cehua="卡利玛神庙第6层", name="击杀任务", UItext="击杀昆顿", param={102500059,1}},
	{id=20001007, cehua="卡利玛神庙第7层", name="击杀任务", UItext="击杀昆顿", param={102500069,1}},
}

local defaults = {cehua="攻城战-攻方任务", name="击杀本层首领", UItext="击杀本层首领", nextID=0, type=2, param={21010001,101201}, reward={}, moveTo={}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_repTask) do
	setmetatable(v, mt)
end

return cfg_repTask