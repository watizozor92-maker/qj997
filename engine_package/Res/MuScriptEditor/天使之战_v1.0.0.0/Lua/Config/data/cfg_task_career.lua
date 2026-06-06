-- 此文件工具自动生成，不要修改
---@class cfg_task_career_column
---排序用
---@field order number @排序 column=1 A
---id5位数主线任务
---第1位：根职业id
---第2 、3、4、5位：表示编号
---id六位数为支线任务
---第一位：任务类型
---第二三位：根职业
---第四五六位：编号
---@field id number @编号 column=2 B
---任务名
---@field title string @任务名 column=3 C
---1一次性任务
---2每日任务（每日重新接取）
---3循环任务
---[[客户端不使用]]@field taskType number @任务模式 column=4 D
---任务显示图标1=主线
---2=支线
---3=日常
---4=转职
---5=循环
---目前任务类型区分也用了此字段
---@field uiTitleType number @UI任务类型 column=5 E
---读取cfg_npclist表id
---@field npcGet number @接任务NPC column=6 F
---直接填写
---
---填写对应文本路径
---@field diaLogGet string @接任务对话 column=7 G
---1:自动完成任务并自动获取奖励
---2:手动领取奖励完成任务
---[[客户端不使用]]@field autoFinish number @自动完成任务 column=8 H
---接任务的等级下限
---备注：当角色等级大于/等于等级下限时，自动接取任务
---@field levelMin number @等级下限 column=9 I
---接任务的等级上限
---备注：当角色等级大于等级上限时，不可以接取任务
---@field levelMax number @等级上限 column=10 J
---该任务的前置任务，完成前置任务才能接取该任务
---checkFinishTask[任务id]检查任务是否完成。
---&表示且   |表示或
---加道具判断的话就 checkBagItem[cfgId]>=数量，条件之间是与的关系就用&，或就用|（丨之间需要加（））
---@field preTask StringListList @前置任务 column=11 K
---该任务的后置任务，完成该任务才能接取后置任务
---多个后置任务：任务1#任务2
---注意：必须配置，不配会导致任务刷新不及时，重登后才刷
---@field postTask IntList @后置任务 column=12 L
---只有设定职业才能接到该任务
---参考career表，多个职业|分隔
---0表示全职业
---@field careerLimit IntListList @职业限制 column=13 M

local local_postTask = {
    postTask_1={666610},

}

local local_careerLimit = {
    careerLimit_1={{0}},

}

local cfg_task_career =
{
	{order=1, id=666601, title="一转任务1接取", npcGet=100307, diaLogGet="是否接取一转任务1，开始完成一转转职之旅", levelMin=150, preTask={{"checkBagItem[10010001]>=1000000"}}, postTask={666602}},
	{order=2, id=666603, title="一转任务2接取", npcGet=100307, diaLogGet="是否接取一转任务2，开始完成一转转职之旅", levelMin=150, preTask={{"checkFinishTask[666602]"}}},
	{order=3, id=666605, title="二转任务1接取", npcGet=100114, diaLogGet="是否接取二转任务1，开始完成二转转职之旅", levelMin=220, postTask={666606}},
	{order=4, id=666607, title="二转任务2接取", npcGet=100114, diaLogGet="是否接取二转任务2，开始完成二转转职之旅", levelMin=220, preTask={{"checkFinishTask[666606]"}}, postTask={666608}, careerLimit={{1,1}}},
	{order=5, id=666609, title="三转任务1接取", diaLogGet="是否接取三转任务1，开始完成三转转职之旅", levelMin=380, preTask={{"checkFinishTask[666608]&checkBagItem[10010001]>=5000000"}}, postTask=local_postTask.postTask_1, careerLimit={{1,2}}},
	{order=6, id=6666091, title="三转任务1接取", diaLogGet="是否接取三转任务1，开始完成三转转职之旅", levelMin=380, preTask={{"checkFinishTask[666606]&checkBagItem[10010001]>=5000000"}}, postTask=local_postTask.postTask_1, careerLimit={{2,2},{3,2}}},
	{order=7, id=666611, title="三转任务2接取", diaLogGet="是否接取三转任务2，开始完成三转转职之旅", levelMin=400, preTask={{"checkFinishTask[666610]&checkBagItem[10010001]>=7000000"}}, postTask={666612,60666121,60666122}},
	{order=8, id=666613, title="三转任务3接取", diaLogGet="是否接取三转任务3，开始完成三转转职之旅", levelMin=400, preTask={{"checkFinishTask[666612]&checkBagItem[10010001]>=10000000"}}, postTask={666614}},
}

local defaults = {uiTitleType=4, npcGet=100902, levelMax=0, preTask={{"(checkFinishTask[6666041]&checkBagItem[10010001]>=3000000)"},{"(checkFinishTask[6666042]&checkBagItem[10010001]>=3000000)"},{"(checkFinishTask[6666043]&checkBagItem[10010001]>=3000000)"}}, postTask={6666041,6666042,6666043}, careerLimit={{0}}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_task_career) do
	setmetatable(v, mt)
end

return cfg_task_career