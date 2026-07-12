-- 此文件工具自动生成，不要修改
---@class cfg_task_column
---id5位数主线任务
---第1位：根职业id
---第2 、3、4、5位：表示编号
---id六位数为支线任务
---第一位：任务类型
---第二三位：根职业
---第四五六位：编号
---@field id number @编号 column=1 A
---任务名
---@field title string @任务名 column=2 B
---1一次性任务
---2每日任务（每日重新接取）
---3循环任务
---[[客户端不使用]]@field taskType number @任务模式 column=3 C
---任务显示图标1=主线
---2=支线
---3=日常
---4=转职
---5=循环
---目前任务类型区分也用了此字段
---@field uiTitleType number @UI任务类型 column=4 D
---读取cfg_task_target 表id
---格式：任务目标id#任务目标id
---@field taskTargetId IntList @任务目标ID column=5 E
---读取cfg_npclist表id
---@field npcGet number @接任务NPC column=6 F
---直接填写
---
---填写对应文本路径
---@field diaLogGet string @接任务对话 column=7 G
---交任务的对应NPCID
---@field npcDone number @交任务NPC column=8 H
---直接填写
---
---填写对应文本路径
---@field diaLogDone string @交任务对话 column=9 I
---1:自动完成任务并自动获取奖励
---2:手动领取奖励完成任务
---[[客户端不使用]]@field autoFinish number @自动完成任务 column=10 J
---接任务的等级下限
---备注：当角色等级大于/等于等级下限时，自动接取任务
---@field levelMin number @等级下限 column=11 K
---接任务的等级上限
---备注：当角色等级大于等级上限时，不可以接取任务
---@field levelMax number @等级上限 column=12 L
---该任务的前置任务，完成前置任务才能接取该任务
---checkFinishTask[任务id]检查任务是否完成。
---&表示且   |表示或
---加道具判断的话就 checkBagItem[cfgId]>=数量，条件之间是与的关系就用&，或就用|
---@field preTask StringListList @前置任务 column=13 M
---该任务的后置任务，完成该任务才能接取后置任务
---多个后置任务：任务1#任务2
---注意：必须配置，不配会导致任务刷新不及时，重登后才刷
---[[客户端不使用]]@field postTask IntList @后置任务 column=14 N
---接取该任务后，对应互斥任务将无法接取
---[[客户端不使用]]@field mutexTask IntList @互斥任务 column=15 O
---只有设定职业才能接到该任务
---参考career表，多个职业|分隔
---0表示全职业
---[[客户端不使用]]@field careerLimit IntListList @职业限制 column=16 P
---奖励道具组以及奖励道具组的数量
---格式：道具id#道具数量#修正id#绑定道具（0：非绑定，1：绑定）|道具id#道具数量#修正id#绑定道具
---修正id引援cfg_equip_correct表id，填0不生效
---@field rewardItem IntListList @奖励道具信息 column=17 Q
---为1时该任务进行中显示怪物列表，空或0则不显示
---@field monsterlist number @是否显示怪物列表 column=18 R
---用于rookie_guide（测试字段）
---@field group IntList @引导组 column=19 S
---格式：奖励道具组id#奖励道具组id
---道具组id引援cfg_box_group表
---[[客户端不使用]]@field rewardBoxGroup IntList @奖励道具组 column=20 T
---接取任务所消耗的道具，格式：道具ID#数量丨道具ID#数量
---@field consume IntListList @接取任务消耗道具 column=21 U

local local_preTask = {
    preTask_1={{"checkFinishTask[666603]"}},

}

local local_rewardItem = {
    rewardItem_1={{10010002,2000,0,1}},
    rewardItem_2={{10070001,10,0,0}},

}

local local_group = {
    group_1={},

}

local local_consume = {
    consume_1={},

}

local cfg_task =
{
	{id=900001, title="双怪物测试", uiTitleType=2, taskTargetId={1002008,1002012}, preTask={{"checkFinishTask[130081]"}}, rewardItem={}},
	{id=10001, title="对话酒店老板娘", uiTitleType=1, taskTargetId={1004001}, preTask={}, rewardItem={{30010002,10,0,1},{30010012,10,0,1}}},
	{id=10002, title="对话幻影导师", uiTitleType=1, taskTargetId={1004005}, preTask={{"checkFinishTask[10001]"}}},
	{id=10006, title="提升等级到6级", uiTitleType=1, taskTargetId={1005006}, preTask={{"checkFinishTask[10002]"}}},
	{id=10007, title="对话酒店老板娘，买小药", uiTitleType=1, taskTargetId={1001001}, preTask={{"checkFinishTask[10006]"}}, rewardItem={{10010002,2000,0,1},{10080001,1200,0,1}}},
	{id=10012, title="提升等级到20级", uiTitleType=1, taskTargetId={1005020}, preTask={{"checkFinishTask[10007]"}}},
	{id=10013, title="前往冰风谷", uiTitleType=1, taskTargetId={1003001}, preTask={{"checkFinishTask[10012]"}}},
	{id=666602, title="击杀怪物获取帝王之书", taskTargetId={6066602}, levelMin=150, preTask={{"checkFinishTask[666601]"}}, rewardItem=local_rewardItem.rewardItem_2, consume={{10010001,1000000}}},
	{id=6666041, title="击杀怪物获取断魂之剑", taskTargetId={60666041}, levelMin=150, preTask=local_preTask.preTask_1, rewardItem=local_rewardItem.rewardItem_2},
	{id=6666042, title="击杀怪物获取先知之魂", taskTargetId={60666042}, levelMin=150, preTask=local_preTask.preTask_1, rewardItem=local_rewardItem.rewardItem_2},
	{id=6666043, title="击杀怪物获取精灵之泪", taskTargetId={60666043}, levelMin=150, preTask=local_preTask.preTask_1, rewardItem=local_rewardItem.rewardItem_2},
	{id=666606, title="击杀怪物获取荣誉之戒", taskTargetId={6066606}, levelMin=220, preTask={{"checkFinishTask[666605]"}}, rewardItem={{10070001,20,0,0}}, consume={{10010001,3000000}}},
	{id=666608, title="击杀怪物获取暗黑之石", taskTargetId={6066608}, levelMin=220, preTask={{"checkFinishTask[666607]"}}, rewardItem={{100000001,1,0,0}}},
	{id=666610, title="击杀怪物获取三转任务物品", levelMin=380, preTask={{"checkFinishTask[666609]"}}, rewardItem={{10070001,70,0,0}}, consume={{10010001,10000000}}},
}

local defaults = {uiTitleType=4, taskTargetId={60666101,60666102,60666103}, npcGet=0, diaLogGet="", npcDone=0, diaLogDone="感谢您勇士，请收下这些。", levelMin=0, levelMax=0, rewardItem={{10010002,2000,0,1}}, monsterlist=0, group={}, consume={}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_task) do
	setmetatable(v, mt)
end

return cfg_task