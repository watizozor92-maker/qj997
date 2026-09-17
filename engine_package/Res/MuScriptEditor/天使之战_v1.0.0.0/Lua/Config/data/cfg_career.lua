-- 此文件工具自动生成，不要修改
---@class cfg_career_column
---@field id number @id column=1 A
---职业的名称
---@field name string @职业名称 column=2 B
---1剑士 2魔法师 3弓箭手 4魔剑士 5圣导师   6召唤师 7白法
---@field baseCareer number @所属职业 column=3 C
---表示在该职业树的第几层
---@field careerRank number @职业等级 column=4 D
---转职到本职业需要完成的任务
---使用cfg_task表的id
---格式 任务ID#任务ID
---@field task IntList @转职任务 column=5 E
---转职到本职业的要求等级
---@field level number @达到等级 column=6 F
---人物升到level字段设定等级且未达到当前职业时是否能获得经验（如果level字段数据位空则不受该字段影响）
---0或不填：不可获得经验
---1:未完成转职，可获得经验#经验最多存储到当前升级经验的n% 
---2:未完成转职，可获得经验且正常升级
---@field isExpAdd IntList @是否获得经验 column=7 G
---格式：属性点数
---@field freeAtt IntList @可分配属性点 column=8 H
---填写该职业所开放的穿戴栏；填空则不开放穿戴栏（cfg_wearing_bar/id）；
---@field careerWearBar IntList @职业穿戴栏 column=9 I
---引援cfg_model_default
---@field modelId number @转职展示模型id column=10 J
---自由分配推荐加点
---力#敏#体#智#统
---@field careerRec IntListList @额外加点 column=11 K
---转职成功后是否弹出转职窗口
---0或空：不弹出
---1：弹出
---@field window number @转职窗口 column=12 L
---读cfg_skill表技能id，多个用#分隔
---@field unlockskill IntList @解锁技能（ui显示） column=13 M
---道具id
---修正id引援cfg_equip_correct表id 填0则不修正
---@field unlockItem IntList @解锁装备（ui显示） column=14 N
---仅前端显示使用
---格式:内容
---@field rewardText string @转职奖励 column=15 O
---当前职业升级时播放特效
---索引cfg_model_effect表内的特效id
---不填则无升级特效
---@field upGradeEffect number @升级特效 column=16 P
---
---一直挂载在人物身上，索引cfg_model_effect表内的特效id
---不填则无特效
---@field careerEffect number @职业特效 column=17 Q
---职业进阶后是否免费立刻洗点
---0=否
---1=是
---如果不是，则继承转职前的加点方案位。（例如转之前选择的第二套，转职后选择转职后的加点第二套）
---@field wash number @进阶洗点 column=18 R
---当有多套加点方案时，限时相对应的图片及属性图
---格式：职业名#属性图|职业名#属性图
---@field recPicture string @切换加点相关图片 column=19 S
---当有多套加点方案时，文字备注：加点策略#加点优势|加点策略#加点优势
---@field recText string @切换加点文字介绍 column=20 T

local local_task = {
    task_1={},
    task_2={666610},
    task_3={666606},
    task_4={6666042},

}

local local_isExpAdd = {
    isExpAdd_1={2},
    isExpAdd_2={},

}

local local_freeAtt = {
    freeAtt_1={},

}

local local_careerWearBar = {
    careerWearBar_1={1,9},

}

local local_careerRec = {
    careerRec_1={{3,2,0,0,0}},
    careerRec_2={{4,2,0,0,0}},
    careerRec_3={{0,2,0,3,0}},
    careerRec_4={{0,2,0,4,0}},
    careerRec_5={{1,5,0,0,0},{0,1,0,5,0}},
    careerRec_6={{0,2,0,5,0},{5,2,0,0,0}},
    careerRec_7={{4,1,0,0,0}},

}

local local_unlockskill = {
    unlockskill_1={},

}

local local_unlockItem = {
    unlockItem_1={},

}

local cfg_career =
{
	{id=1, name="Swordsman", isExpAdd=local_isExpAdd.isExpAdd_2, modelId=1, careerRec=local_careerRec.careerRec_1, window=0, rewardText=""},
	{id=4, name="Knight", careerRank=2, task={6666041}, level=150, modelId=1, careerRec=local_careerRec.careerRec_1},
	{id=10, name="Blade Knight", careerRank=3, task={666608}, level=220, modelId=201, careerRec=local_careerRec.careerRec_2},
	{id=7, name="Temple Knight", careerRank=4, task=local_task.task_2, level=380, modelId=301, careerRec=local_careerRec.careerRec_2, rewardText="可分配的职业点数70点"},
	{id=2, name="Magician", baseCareer=2, isExpAdd=local_isExpAdd.isExpAdd_2, modelId=2, window=0, rewardText=""},
	{id=5, name="Wizard", baseCareer=2, careerRank=2, task=local_task.task_4, level=150, modelId=2},
	{id=11, name="Soul Master", baseCareer=2, careerRank=3, task=local_task.task_3, level=220, modelId=202, careerRec=local_careerRec.careerRec_4},
	{id=8, name="Archmage", baseCareer=2, careerRank=4, task=local_task.task_2, level=380, modelId=302, careerRec=local_careerRec.careerRec_4, rewardText="可分配的职业点数70点", careerEffect=70},
	{id=3, name="Elf", baseCareer=3, isExpAdd=local_isExpAdd.isExpAdd_2, modelId=3, careerRec={{1,4,0,0,0}}, window=0, rewardText=""},
	{id=6, name="Muse Elf", baseCareer=3, careerRank=2, task={6666043}, level=150, modelId=3, careerRec={{1,4,0,0,0},{0,1,0,4,0}}},
	{id=12, name="High Elf", baseCareer=3, careerRank=3, task=local_task.task_3, level=220, modelId=203, careerRec=local_careerRec.careerRec_5},
	{id=9, name="Elf Ranger", baseCareer=3, careerRank=4, task=local_task.task_2, level=380, modelId=303, careerRec=local_careerRec.careerRec_5, rewardText="可分配的职业点数70点"},
	{id=401, name="Magic Gladiator", baseCareer=4, isExpAdd=local_isExpAdd.isExpAdd_2, modelId=4, careerRec=local_careerRec.careerRec_6, window=0, rewardText=""},
	{id=402, name="Blade Master", baseCareer=4, careerRank=2, task=local_task.task_2, level=380, modelId=4, careerRec=local_careerRec.careerRec_6, rewardText="可分配的职业点数70点"},
	{id=501, name="Lord Emperor", baseCareer=5, isExpAdd=local_isExpAdd.isExpAdd_2, modelId=5, careerRec=local_careerRec.careerRec_7, window=0, rewardText=""},
	{id=502, name="Priest", baseCareer=5, careerRank=2, task=local_task.task_2, level=380, modelId=5, careerRec=local_careerRec.careerRec_7, rewardText="可分配的职业点数70点"},
	{id=601, name="Summoner", baseCareer=6, isExpAdd=local_isExpAdd.isExpAdd_2, modelId=6, window=0, rewardText=""},
	{id=602, name="Summon Master", baseCareer=6, careerRank=2, task=local_task.task_4, level=150, modelId=6},
	{id=603, name="Summon Wizard", baseCareer=6, careerRank=3, task=local_task.task_2, level=380, modelId=6, rewardText="可分配的职业点数70点"},
	{id=701, name="Light Mage", baseCareer=7, isExpAdd=local_isExpAdd.isExpAdd_2, modelId=7, careerRec=local_careerRec.careerRec_1, window=0, rewardText=""},
	{id=702, name="Holy Mage", baseCareer=7, careerRank=2, task=local_task.task_4, level=150, modelId=7, careerRec=local_careerRec.careerRec_1},
	{id=703, name="Holy Master", baseCareer=7, careerRank=3, task=local_task.task_2, level=380, modelId=7, careerRec=local_careerRec.careerRec_2, rewardText="可分配的职业点数70点"},
}

local defaults = {baseCareer=1, careerRank=1, task={}, level=0, isExpAdd={2}, freeAtt={}, careerWearBar={1,9}, careerRec={{0,2,0,3,0}}, window=1, unlockskill={}, unlockItem={}, rewardText="可分配的职业点数20点", upGradeEffect=55, careerEffect=0, wash=0, recPicture="", recText=""}
local mt = {__index = defaults}
for _, v in ipairs(cfg_career) do
	setmetatable(v, mt)
end

return cfg_career