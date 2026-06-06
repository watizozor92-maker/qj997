-- 此文件工具自动生成，不要修改
---@class cfg_goldFirstKill_column
---引用cfg_monster表id
---@field id number @黄金怪id column=1 A
---[[客户端不使用]]@field beizhu string @策划备注 column=2 B
---格式：道具id#道具数量|道具id#道具数量
---@field serReward IntListList @全服首杀奖励 column=3 C
---格式：道具id#道具数量|道具id#道具数量
---@field perReward IntListList @个人首杀奖励 column=4 D
---格式：道具id#道具数量|道具id#道具数量
---@field redEnvelope IntListList @全服首杀红包奖励 column=5 E
---与redEnvelope对应，格式：奖励1权重#奖励2权重
---@field redEnvelopeWeight IntList @全服首杀红包奖励权重 column=6 F
---引用cfg_task_target表id字段
---@field taskId number @个人首杀任务目标 column=7 G
---transfer#传送ID#X坐标#Y坐标
---未填坐标则传送到该地图的默认传送点
---传送ID参考mapMove表id
---
---transferNPC#NPCID
---传送到NPC位置，并交互
---NPCID参考npc_list表ID
---
---moveTo#传送ID#X坐标#Y坐标
---寻路，并将坐标设为主动目标
---传送ID参考mapMove表id
---
---moveToNPC#NPCID
---寻路至该NPC位置，并交互
---NPCID参考npc_list表ID
---
---openUI#UI名#[0,1] 0=不关闭界面 1=关闭界面   任务界面专用
---
---openUIpanel#UI名#[0,1] 0=不关闭界面 1=关闭界面   通用（任务界面+每日目标）
---@field instruction StringListList @快捷指令 column=8 H
---按比例调整模型缩放（万分比）
---@field size number @UI上怪物缩放 column=9 I
---调整怪物UI偏移，X#Y，不配为默认位置
---@field offset IntList @UI上怪物偏移 column=10 J

local local_serReward = {
    serReward_1={{50040074,30}},
    serReward_2={{50040057,30}},
    serReward_3={{50040059,30}},
    serReward_4={{50040061,30}},
    serReward_5={{50040097,5}},
    serReward_6={{50040097,10}},
    serReward_7={{50040097,15}},

}

local local_perReward = {
    perReward_1={{50040074,10},{50030002,1},{10050001,10}},
    perReward_2={{50040057,10},{50030002,1},{10050001,10}},
    perReward_3={{50040059,10},{50030003,1},{10050001,10}},
    perReward_4={{50040061,10},{50030003,1},{10050001,10}},
    perReward_5={{50040061,10},{50010010,10},{10050001,20}},
    perReward_6={{50040097,1},{50010010,10},{10050001,20}},
    perReward_7={{50040097,1},{50010010,10},{10050001,30}},

}

local local_redEnvelope = {
    redEnvelope_1={{10050001,1},{10050001,2},{10050001,5}},

}

local local_redEnvelopeWeight = {
    redEnvelopeWeight_1={6500,3000,500},

}

local local_instruction = {
    instruction_1={{"openUIPanel","dev/outui/ChallengeBoss/Panel/KLChallengeBoss/KLChallengeBossPanel","1"}},

}

local local_offset = {
    offset_1={},

}

local cfg_goldFirstKill =
{
	{id=500003, serReward=local_serReward.serReward_1, perReward=local_perReward.perReward_1, taskId=2000001, size=3000},
	{id=500004, serReward=local_serReward.serReward_1, perReward=local_perReward.perReward_1, taskId=2000002, size=5000},
	{id=500001, serReward=local_serReward.serReward_1, perReward=local_perReward.perReward_1, taskId=2000003, size=3000},
	{id=500007, serReward=local_serReward.serReward_2, perReward=local_perReward.perReward_2, taskId=2000004},
	{id=500011, serReward=local_serReward.serReward_2, perReward=local_perReward.perReward_2, taskId=2000005},
	{id=500017, serReward=local_serReward.serReward_2, perReward=local_perReward.perReward_2, taskId=2000006, offset={0,35}},
	{id=500101, serReward=local_serReward.serReward_3, perReward=local_perReward.perReward_3, taskId=2000007, size=3000},
	{id=500018, serReward=local_serReward.serReward_3, perReward=local_perReward.perReward_3, taskId=2000008},
	{id=500024, serReward=local_serReward.serReward_3, perReward=local_perReward.perReward_3, taskId=2000009},
	{id=500025, perReward=local_perReward.perReward_4, taskId=2000010, size=3000},
	{id=500026, perReward=local_perReward.perReward_4, taskId=2000011},
	{id=500029, perReward=local_perReward.perReward_4, taskId=2000012, size=5000},
	{id=500030, perReward=local_perReward.perReward_5, taskId=2000013, size=6000},
	{id=500031, perReward=local_perReward.perReward_5, taskId=2000014},
	{id=500033, perReward=local_perReward.perReward_5, taskId=2000015},
	{id=500034, perReward=local_perReward.perReward_5, taskId=2000016, size=5000},
	{id=500032, perReward=local_perReward.perReward_5, taskId=2000017, size=4500},
	{id=500023, perReward=local_perReward.perReward_5, taskId=2000018, size=4500},
	{id=500037, serReward=local_serReward.serReward_5, perReward=local_perReward.perReward_6, taskId=2000019, size=4500},
	{id=500035, serReward=local_serReward.serReward_5, perReward=local_perReward.perReward_6, taskId=2000020, size=4500},
	{id=500036, serReward=local_serReward.serReward_5, perReward=local_perReward.perReward_6, taskId=2000021},
	{id=500038, serReward=local_serReward.serReward_6, taskId=2000022},
	{id=500039, serReward=local_serReward.serReward_6, taskId=2000023, size=3000},
	{id=500040, serReward=local_serReward.serReward_6, taskId=2000024, size=1500, offset={0,130}},
	{id=500043, serReward=local_serReward.serReward_6, taskId=2000025, size=3000},
	{id=500045, serReward=local_serReward.serReward_6, taskId=2000026, size=4500},
	{id=500047, serReward=local_serReward.serReward_6, taskId=2000027},
	{id=500048, serReward=local_serReward.serReward_7, taskId=2000028, size=4500},
	{id=500049, serReward=local_serReward.serReward_7, taskId=2000029, size=4500},
	{id=500050, serReward=local_serReward.serReward_7, taskId=2000030, size=4500},
	{id=500051, serReward=local_serReward.serReward_7, taskId=2000031, size=4500},
	{id=500052, serReward=local_serReward.serReward_7, taskId=2000032},
	{id=500055, serReward=local_serReward.serReward_7, taskId=2000033, size=4500},
}

local defaults = {serReward={{50040061,30}}, perReward={{50040097,1},{50010010,10},{10050001,30}}, redEnvelope={{10050001,1},{10050001,2},{10050001,5}}, redEnvelopeWeight={6500,3000,500}, instruction={{"openUIPanel","dev/outui/ChallengeBoss/Panel/KLChallengeBoss/KLChallengeBossPanel","1"}}, size=4000, offset={}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_goldFirstKill) do
	setmetatable(v, mt)
end

return cfg_goldFirstKill