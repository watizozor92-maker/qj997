-- 此文件工具自动生成，不要修改
---@class cfg_task_target_column
---第1位:占位符
---第2、3、4位:任务目标类型
---第5、6、7位：任务编号
---@field id number @编号 column=1 A
---备注
---@field dec string @备注 column=2 B
---主界面任务文本，“\n”换行显示
---@field mainuiName string @主界面UI任务名 column=3 C
---1：获得道具 2：杀怪 3：地图移动 4：对话NPC 5：等级 6：使用道具 7：提交道具 8：穿戴 9：拥有战盟 10：学习技能 11：穿戴指定装备 12通关副本 13通关指定副本 14合成 15回收 16强化 17黄金挑战（勇士任务） 18对怪造成伤害 32：NPC商店购买道具 49：跑环 50：查看界面 51：杀怪（造成伤害计算数量） 52：强化（进行强化）
---@field taskGoalType number @任务目标类型 column=4 D
---任务需要完成的目标的参数
---对应目标类型：
---格式： 先对应前一字段的值 当taskGoalType=x时：字段内填写参数
---taskGoalType=1：道具id
---taskGoalType=2：怪物id
---taskGoalType=3：地图id
---taskGoalType=4：NPCid
---taskGoalType=5：空
---taskGoalType=6：道具id
---taskGoalType=7：道具id
---taskGoalType=8：品阶
---taskGoalType=9：空
---taskGoalType=10：技能id；为空则不限制技能，学习任一技能即可
---taskGoalType=11：空着
---taskGoalType=12：副本类型ID
---taskGoalType=13：副本ID
---taskGoalType=14：合成菜单ID
---taskGoalType=16：部位  不填=任意一个部位
---taskGoalType=18：怪物ID
---taskGoalType=49：可以不填
---taskGoalType=50：1=查看界面；2=点击按钮
---taskGoalType=52：0或空=强化计次，1=强化成功计次
---@field taskGoalParam number @目标参数 column=5 E
---taskGoalType=2：布怪id#布怪id（cfg_mongen/id）；填空则无此要求
---taskGoalType=8：装备部位id#装备部位id（填空无此要求）
---taskGoalType=10: 技能等级
---taskGoalType=11: 装备道具id#装备道具id
---taskGoalType=16：强化等级
---taskGoalType=18：地图ID
---taskGoalType=32：道具id  （可配置多个，购买其中一个即可）
---taskGoalType=49：可以不填
---taskGoalType=50：1=引导
---taskGoalType=52：部位#部位  不填=任意一个部位
---@field taskGoalParam2 IntList @目标参数2 column=6 F
---taskGoalType=50：taskGoalParam=1 UI名称；taskGoalParam=2 面板id#按钮名称
---@field taskGoalParam3 StringList @目标参数3 column=7 G
---任务所需数量
---可以为空
---格式：先对应taskGoalType字段的值 当taskGoalType=x时：字段内填写参数
---taskGoalType=1：道具数量
---taskGoalType=2：怪物数量
---taskGoalType=3：空
---taskGoalType=4：空
---taskGoalType=5：等级
---taskGoalType=6：使用道具的次数
---taskGoalType=7：道具数量
---taskGoalType=8：装备数量
---taskGoalType=9：空
---taskGoalType=10：空
---taskGoalType=11: 装备数量
---taskGoalType=12：次数
---taskGoalType=13：次数
---taskGoalType=14：数量
---taskGoalType=15：次数
---taskGoalType=16：部位数量
---taskGoalType=17：次数
---taskGoalType=18：伤害量
---taskGoalType=32：道具数量
---taskGoalType=49：环任务总数
---taskGoalType=52：强化次数
---@field goalCount number @目标数量 column=8 H
---0：接取任务后记录任务进度
---1：创建角色后记录任务进度
---不填默认为0
---@field recordType number @任务进度记录类型 column=9 I
---1：直接点击前往指令
---
--->1：弹出控件
---@field extraControlNum number @额外控件数量 column=10 J
---每一个控件的名字；
---例：名字1#名字2#名字3；
---extraControlNum>1时生效；
---@field extraControlName StringList @额外控件名字 column=11 K
---conditions条件表格式；检测是否满组条件，满足条件时隐藏额外控件
---@field extraControlConditions StringList @额外控件隐藏条件 column=12 L
---transfer#传送ID#X坐标#Y坐标：未填坐标则传送到该地图的默认传送点，传送ID参考mapMove表id
---transferNPC#NPCID：传送到NPC位置，并交互，NPCID参考npc_list表ID
---moveTo#传送ID#X坐标#Y坐标：寻路，并将坐标设为主动目标，传送ID参考mapMove表id
---moveToNPC#NPCID：寻路至该NPC位置，并交互，NPCID参考npc_list表ID
---openUI#UI名#[0,1] 0=不关闭界面 1=关闭界面   任务界面专用
---openUIpanel#UI名#[0,1]#参数  0=不关闭界面 1=关闭界面  参数为子页签所需要锁定的参数名（可以不填）  通用（任务界面+每日目标）
---moveToRandom#传送ID#X1坐标#Y1坐标#X2坐标#Y2坐标#X3坐标#Y3坐标
---寻路，并将多个坐标随机选择一个作为设为主动目标
---传送ID参考mapMove表id
---transferRandom#传送ID#X1坐标#Y1坐标#X2坐标#Y2坐标#X3坐标#Y3坐标
---从多个坐标中，随机选择一个坐标进行传送，直接传到该坐标位置
---传送ID参考mapMove表id
---特殊界面引导需要配置cfg_rookie_guide
---@field instruction StringListList @快捷指令 column=13 M
---格式：待机时间（s）
---0或不填：表示不开启
---
---备注：待机多长时间后，开启自动模式。自动寻路并前往目标处。
---@field autoTask number @自动任务模式 column=14 N
---备注：到达目标位置后，是否开启自动战斗。
---1 ：开启
---0或不填：关闭
---@field autoFight number @自动战斗 column=15 O
---备注：到达目标位置后，是否开启自动对话npc
---1：开启
---0或不填：关闭
---@field autoDialogue number @自动对话 column=16 P

local local_taskGoalParam2 = {
    taskGoalParam2_1={},
    taskGoalParam2_2={1},

}

local local_taskGoalParam3 = {
    taskGoalParam3_1={""},

}

local local_extraControlName = {
    extraControlName_1={""},
    extraControlName_2={"小怪挂机","提升输出","锻造装备"},
    extraControlName_3={"小怪挂机","恶魔广场","血色城堡","提升输出","锻造装备"},
    extraControlName_4={"合成","商城"},

}

local local_extraControlConditions = {
    extraControlConditions_1={""},

}

local local_instruction = {
    instruction_1={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=13001"}},
    instruction_2={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=13002"}},
    instruction_3={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=13003"}},
    instruction_4={{"openUIPanel","dev/outui/Map/Panel/KLNewTopMap/KLNewTopMapPanel","0","1"}},
    instruction_5={{"moveToNPC","100101"}},
    instruction_6={},
    instruction_7={{"moveToRandom","2","26","234","19","206","49","238","51","197","71","216","90","235"}},
    instruction_8={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel"},{"openUIPanel","dev/outui/ShopMain/Panel/KLShopMain/KLShopMainPanel"},{"openUIPanel","dev/ui/UIForgeGroup/Panel/KLUIForgeGroup/KLUIForgeGroupPanel"}},
    instruction_9={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel"},{"openUIPanel","dev/ui/Preview/Panel/KLPreview/KLPreviewPanel","1","togType=2&subType=2"},{"openUIPanel","dev/ui/Preview/Panel/KLPreview/KLPreviewPanel","1","togType=2&subType=1"},{"openUIPanel","dev/outui/ShopMain/Panel/KLShopMain/KLShopMainPanel"},{"openUIPanel","dev/ui/UIForgeGroup/Panel/KLUIForgeGroup/KLUIForgeGroupPanel"}},
    instruction_10={{"openUIPanel","dev/outui/Synthesis/Panel/KLSynthesisMenu/KLSynthesisMenuPanel"},{"openUIPanel","dev/outui/ShopMain/Panel/KLShopMain/KLShopMainPanel"}},
    instruction_11={{"openUIPanel","dev/outui/ChallengeBoss/Panel/KLChallengeBoss/KLChallengeBossPanel"}},
    instruction_12={{"moveToNPC","100401"}},
    instruction_13={{"openUIPanel","dev/ui/UIForgeGroup/Panel/KLUIForgeGroup/KLUIForgeGroupPanel"}},
    instruction_14={{"moveToNPC","100103"}},
    instruction_15={{"moveToNPC","100403"}},

}

local cfg_task_target =
{
	{id=2001001, dec="日常任务", mainuiName="提交装备，送属性点", taskGoalType=49, goalCount=300, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Task/Panel/KLTaskLoop/KLTaskLoopPanel","1"}}},
	{id=1002001, mainuiName="击杀<color=#00FF00>蜘蛛</color>", taskGoalParam=10002, goalCount=10, extraControlName=local_extraControlName.extraControlName_1, instruction={{"moveToRandom","1","190","117","190","133"}}, autoFight=1},
	{id=1002002, mainuiName="击杀<color=#00FF00>幼龙</color>", taskGoalParam=10001, goalCount=10, extraControlName=local_extraControlName.extraControlName_1, instruction={{"moveTo","1","189","137"}}, autoFight=1},
	{id=1002003, mainuiName="击杀<color=#00FF00>牛怪</color>", taskGoalParam=10004, goalCount=10, extraControlName=local_extraControlName.extraControlName_1, instruction={{"moveToRandom","1","168","87","159","72","150","82","142","69","144","59","137","57","136","74","126","78"}}, autoFight=1},
	{id=1002004, mainuiName="击杀<color=#00FF00>猎犬怪</color>", taskGoalParam=20004, goalCount=10, extraControlName=local_extraControlName.extraControlName_1, instruction={{"moveToRandom","1","85","124","74","124","62","117","69","143"}}, autoFight=1},
	{id=1002005, mainuiName="击杀<color=#00FF00>蛮牛怪</color>", taskGoalParam=10005, goalCount=10, extraControlName=local_extraControlName.extraControlName_1, instruction={{"moveToRandom","1","86","140","73","137","59","130","63","148","90","151"}}, autoFight=1},
	{id=1002006, mainuiName="击杀<color=#00FF00>黑巫师</color>", taskGoalParam=10007, goalCount=10, extraControlName=local_extraControlName.extraControlName_1, instruction={{"moveToRandom","1","105","169","116","171","128","173","137","176","146","173","134","181","116","177"}}, autoFight=1},
	{id=1002007, mainuiName="击杀<color=#00FF00>蜘蛛</color>", taskGoalParam=10002, goalCount=10, extraControlName=local_extraControlName.extraControlName_1, instruction={{"moveTo","2","148","127"}}, autoFight=1},
	{id=1002008, mainuiName="击杀<color=#00FF00>勾尾蝎</color>", taskGoalParam=20002, goalCount=10, extraControlName=local_extraControlName.extraControlName_1, instruction={{"moveTo","2","155","148"}}, autoFight=1},
	{id=1002009, mainuiName="击杀<color=#00FF00>大哥布林</color>", taskGoalParam=20003, goalCount=10, extraControlName=local_extraControlName.extraControlName_1, instruction={{"moveToRandom","2","113","76","128","56","102","45","93","69","74","84","71","101","49","80"}}, autoFight=1},
	{id=1002010, mainuiName="击杀<color=#00FF00>瓢虫怪</color>", taskGoalParam=20005, goalCount=10, extraControlName=local_extraControlName.extraControlName_1, instruction={{"moveToRandom","2","56","103","92","97","78","116","97","133","62","141","44","148","149","145"}}, autoFight=1},
	{id=1002011, mainuiName="击杀<color=#00FF00>树妖</color>", taskGoalParam=20006, goalCount=10, extraControlName=local_extraControlName.extraControlName_1, instruction={{"moveToRandom","2","69","155","98","130","152","191","113","204","93","201","53","174","155","227"}}, autoFight=1},
	{id=1002012, mainuiName="击杀<color=#00FF00>石巨人</color>", taskGoalParam=20009, goalCount=10, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_7, autoFight=1},
	{id=1002013, mainuiName="击杀<color=#00FF00>雪虫</color>", taskGoalParam=40001, goalCount=15, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=40001"}}, autoFight=1},
	{id=1002014, mainuiName="击杀<color=#00FF00>寒冰魔</color>", taskGoalParam=40002, goalCount=15, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=40002"}}, autoFight=1},
	{id=1002015, mainuiName="击杀<color=#00FF00>蓝魔怪</color>", taskGoalParam=40003, goalCount=15, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=40003"}}, autoFight=1},
	{id=1002016, mainuiName="击杀<color=#00FF00>暗杀者</color>", taskGoalParam=50002, goalCount=15, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=50002"}}, autoFight=1},
	{id=1002017, mainuiName="击杀<color=#00FF00>雪人</color>", taskGoalParam=40004, goalCount=15, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=40004"}}, autoFight=1},
	{id=1002018, mainuiName="击杀<color=#00FF00>雪人王</color>", taskGoalParam=40005, goalCount=15, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=40005"}}, autoFight=1},
	{id=1002019, mainuiName="击杀<color=#00FF00>骷髅兵</color>", taskGoalParam=10003, goalCount=20, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=10003"}}, autoFight=1},
	{id=1002020, mainuiName="击杀<color=#00FF00>毒虫</color>", taskGoalParam=50001, goalCount=20, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=50001"}}, autoFight=1},
	{id=1002021, mainuiName="击杀<color=#00FF00>独眼巨人</color>", taskGoalParam=50003, goalCount=20, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=50003"}}, autoFight=1},
	{id=1002022, mainuiName="击杀<color=#00FF00>幽灵</color>", taskGoalParam=50004, goalCount=20, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=50004"}}, autoFight=1},
	{id=1002023, mainuiName="击杀<color=#00FF00>骷髅弓箭手</color>", taskGoalParam=50005, goalCount=20, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=50005"}}, autoFight=1},
	{id=1002024, mainuiName="击杀<color=#00FF00>地狱猎犬怪</color>", taskGoalParam=50006, goalCount=20, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=50006"}}, autoFight=1},
	{id=1002025, mainuiName="击杀<color=#00FF00>地狱蜘蛛</color>", taskGoalParam=50007, goalCount=20, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=50007"}}, autoFight=1},
	{id=1002026, mainuiName="击杀<color=#00FF00>骷髅战士</color>", taskGoalParam=50009, goalCount=20, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=50009"}}, autoFight=1},
	{id=1002027, mainuiName="击杀<color=#00FF00>死灵巫师</color>", taskGoalParam=50010, goalCount=20, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=50010"}}, autoFight=1},
	{id=1002028, mainuiName="击杀<color=#00FF00>毒牛怪</color>", taskGoalParam=50011, goalCount=20, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=50011"}}, autoFight=1},
	{id=1002029, mainuiName="击杀<color=#00FF00>暗黑骑士</color>", taskGoalParam=50008, goalCount=20, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=50008"}}, autoFight=1},
	{id=1002030, mainuiName="击杀<color=#00FF00>鬼魂</color>", taskGoalParam=60001, goalCount=30, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=60001"}}, autoFight=1},
	{id=1002031, mainuiName="击杀<color=#00FF00>剧毒鬼魂</color>", taskGoalParam=60002, goalCount=30, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=60002"}}, autoFight=1},
	{id=1002032, mainuiName="击杀<color=#00FF00>诅咒巫师</color>", taskGoalParam=60003, goalCount=30, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=60003"}}, autoFight=1},
	{id=1002033, mainuiName="击杀<color=#00FF00>牛魔王</color>", taskGoalParam=60004, goalCount=30, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=60004"}}, autoFight=1},
	{id=1002034, mainuiName="击杀<color=#00FF00>恶魔</color>", taskGoalParam=60005, goalCount=30, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=60005"}}, autoFight=1},
	{id=1002035, mainuiName="击杀<color=#00FF00>死神骑士</color>", taskGoalParam=60006, goalCount=30, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=60006"}}, autoFight=1},
	{id=1002036, mainuiName="击杀<color=#00FF00>死神戈登</color>", taskGoalParam=60007, goalCount=30, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=60007"}}, autoFight=1},
	{id=1002037, mainuiName="击杀<color=#00FF00>小巴哈姆特</color>", taskGoalParam=70001, goalCount=50, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=70001"}}, autoFight=1},
	{id=1002038, mainuiName="击杀<color=#00FF00>死亡美人鱼</color>", taskGoalParam=70002, goalCount=50, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=70002"}}, autoFight=1},
	{id=1002039, mainuiName="击杀<color=#00FF00>蓝翼海怪</color>", taskGoalParam=70003, goalCount=50, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=70003"}}, autoFight=1},
	{id=1002040, mainuiName="击杀<color=#00FF00>大巴哈姆特</color>", taskGoalParam=70004, goalCount=50, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=70004"}}, autoFight=1},
	{id=1002041, mainuiName="击杀<color=#00FF00>银弓海怪</color>", taskGoalParam=70005, goalCount=50, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=70005"}}, autoFight=1},
	{id=1002042, mainuiName="击杀<color=#00FF00>巫师王</color>", taskGoalParam=70006, goalCount=50, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=70006"}}, autoFight=1},
	{id=1002043, mainuiName="击杀<color=#00FF00>铁脊怪</color>", taskGoalParam=80001, goalCount=60, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=80001"}}, autoFight=1},
	{id=1002044, mainuiName="击杀<color=#00FF00>巨齿兽</color>", taskGoalParam=80002, goalCount=60, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=80002"}}, autoFight=1},
	{id=1002045, mainuiName="击杀<color=#00FF00>铁轮战士</color>", taskGoalParam=80003, goalCount=60, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=80003"}}, autoFight=1},
	{id=1002046, mainuiName="击杀<color=#00FF00>破坏骑士</color>", taskGoalParam=80004, goalCount=60, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=80004"}}, autoFight=1},
	{id=1002047, mainuiName="击杀<color=#00FF00>黑炎魔</color>", taskGoalParam=80005, goalCount=60, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=80005"}}, autoFight=1},
	{id=1002048, mainuiName="击杀<color=#00FF00>丛林树精灵</color>", taskGoalParam=11001, goalCount=70, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=11001"}}, autoFight=1},
	{id=1002049, mainuiName="击杀<color=#00FF00>丛林残暴者</color>", taskGoalParam=11002, goalCount=70, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=11002"}}, autoFight=1},
	{id=1002050, mainuiName="击杀<color=#00FF00>丛林暗杀者</color>", taskGoalParam=11003, goalCount=70, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=11003"}}, autoFight=1},
	{id=1002051, mainuiName="击杀<color=#00FF00>丛林生命体</color>", taskGoalParam=11004, goalCount=70, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=11004"}}, autoFight=1},
	{id=1002052, mainuiName="击杀<color=#00FF00>丛林女巫师</color>", taskGoalParam=11005, goalCount=70, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=11005"}}, autoFight=1},
	{id=1002053, mainuiName="击杀<color=#00FF00>丛林召唤者</color>", taskGoalParam=11010, goalCount=70, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=11010"}}, autoFight=1},
	{id=1002054, mainuiName="击杀<color=#00FF00>阿卡摩斯</color>", taskGoalParam=90002, goalCount=80, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=90002"}}, autoFight=1},
	{id=1002055, mainuiName="击杀<color=#00FF00>恶灵</color>", taskGoalParam=90001, goalCount=80, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=90001"}}, autoFight=1},
	{id=1002056, mainuiName="击杀<color=#00FF00>风后</color>", taskGoalParam=90003, goalCount=80, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=90003"}}, autoFight=1},
	{id=1002057, mainuiName="击杀<color=#00FF00>蓝魔龙</color>", taskGoalParam=90004, goalCount=80, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=90004"}}, autoFight=1},
	{id=1002058, mainuiName="击杀<color=#00FF00>恶灵王</color>", taskGoalParam=90005, goalCount=80, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=90005"}}, autoFight=1},
	{id=1002059, mainuiName="击杀<color=#00FF00>幻影骑士</color>", taskGoalParam=90006, goalCount=80, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=90006"}}, autoFight=1},
	{id=1002060, mainuiName="击杀<color=#00FF00>红魔龙</color>", taskGoalParam=90007, goalCount=80, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=90007"}}, autoFight=1},
	{id=1002061, mainuiName="击杀<color=#00FF00>裂角狼</color>", taskGoalParam=12002, goalCount=100, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=12002"}}, autoFight=1},
	{id=1002062, mainuiName="击杀<color=#00FF00>金甲兽</color>", taskGoalParam=12003, goalCount=100, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=12003"}}, autoFight=1},
	{id=1002063, mainuiName="击杀<color=#00FF00>半兽人</color>", taskGoalParam=12004, goalCount=100, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=12004"}}, autoFight=1},
	{id=1002064, mainuiName="击杀<color=#00FF00>刀刃猎手</color>", taskGoalParam=12005, goalCount=100, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=12005"}}, autoFight=1},
	{id=1002065, mainuiName="击杀<color=#00FF00>寒冰刺客</color>", taskGoalParam=12006, goalCount=100, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=12006"}}, autoFight=1},
	{id=1002066, mainuiName="击杀<color=#00FF00>狂巨人</color>", taskGoalParam=12007, goalCount=100, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=12007"}}, autoFight=1},
	{id=1002067, mainuiName="击杀<color=#00FF00>疯魔</color>", taskGoalParam=12001, goalCount=100, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=12001"}}, autoFight=1},
	{id=1002068, mainuiName="击杀<color=#00FF00>屠杀者</color>", taskGoalParam=12008, goalCount=100, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=12008"}}, autoFight=1},
	{id=1002073, mainuiName="击杀<color=#00FF00>假面巫</color>", taskGoalParam=13001, goalCount=150, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_1, autoFight=1},
	{id=1002074, mainuiName="击杀<color=#00FF00>毒步妖</color>", taskGoalParam=13002, goalCount=150, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_2, autoFight=1},
	{id=1002075, mainuiName="击杀<color=#00FF00>恐惧天使</color>", taskGoalParam=13003, goalCount=150, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_3, autoFight=1},
	{id=1002090, mainuiName="击杀<color=#00FF00>真面巫</color>", taskGoalParam=13001, goalCount=150, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_1, autoFight=1},
	{id=1002091, mainuiName="击杀<color=#00FF00>剧毒步妖</color>", taskGoalParam=13002, goalCount=150, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_2, autoFight=1},
	{id=1002092, mainuiName="击杀<color=#00FF00>恐惧大天使</color>", taskGoalParam=13003, goalCount=150, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_3, autoFight=1},
	{id=1002076, mainuiName="击杀<color=#00FF00>冰之魔犬</color>", taskGoalParam=14001, goalCount=200, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=14001"}}, autoFight=1},
	{id=1002077, mainuiName="击杀<color=#00FF00>冰之魔象</color>", taskGoalParam=14002, goalCount=200, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=14002"}}, autoFight=1},
	{id=1002078, mainuiName="击杀<color=#00FF00>冰之巨魔</color>", taskGoalParam=14003, goalCount=200, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=14003"}}, autoFight=1},
	{id=1002079, mainuiName="击杀<color=#00FF00>冰之魔蛛</color>", taskGoalParam=14004, goalCount=200, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=14004"}}, autoFight=1},
	{id=1002080, mainuiName="击杀<color=#00FF00>冰铁剑魂</color>", taskGoalParam=14005, goalCount=200, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=14005"}}, autoFight=1},
	{id=1002081, mainuiName="击杀<color=#00FF00>树妖</color>", taskGoalParam=16001, goalCount=300, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=16001"}}, autoFight=1},
	{id=1002082, mainuiName="击杀<color=#00FF00>毒树妖</color>", taskGoalParam=16002, goalCount=300, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=16002"}}, autoFight=1},
	{id=1002083, mainuiName="击杀<color=#00FF00>闪电巨人</color>", taskGoalParam=16007, goalCount=300, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=16007"}}, autoFight=1},
	{id=1002084, mainuiName="击杀<color=#00FF00>暗影爪牙</color>", taskGoalParam=16004, goalCount=300, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=16004"}}, autoFight=1},
	{id=1002085, mainuiName="击杀<color=#00FF00>暗影骑士</color>", taskGoalParam=16005, goalCount=300, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=16005"}}, autoFight=1},
	{id=1002086, mainuiName="击杀<color=#00FF00>残忍的树妖</color>", taskGoalParam=16003, goalCount=300, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=16003"}}, autoFight=1},
	{id=1002087, mainuiName="击杀<color=#00FF00>暗影武士</color>", taskGoalParam=16006, goalCount=300, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=16006"}}, autoFight=1},
	{id=1002088, mainuiName="击杀<color=#00FF00>幽灵巨人</color>", taskGoalParam=16008, goalCount=300, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=16008"}}, autoFight=1},
	{id=1002089, mainuiName="击杀<color=#00FF00>火焰巨人</color>", taskGoalParam=16009, goalCount=300, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel","1","monsterId=16009"}}, autoFight=1},
	{id=1003001, mainuiName="前往<color=#00FF00>冰风谷</color>", taskGoalType=3, taskGoalParam=1003, goalCount=0, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_4},
	{id=1003002, mainuiName="前往<color=#00FF00>地下城</color>", taskGoalType=3, taskGoalParam=1002, goalCount=0, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_4},
	{id=1003003, mainuiName="前往<color=#00FF00>失落之塔1</color>", taskGoalType=3, taskGoalParam=1005, goalCount=0, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_4},
	{id=1003004, mainuiName="前往<color=#00FF00>亚特兰蒂斯</color>", taskGoalType=3, taskGoalParam=1008, goalCount=0, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_4},
	{id=1003005, mainuiName="前往<color=#00FF00>死亡沙漠</color>", taskGoalType=3, taskGoalParam=1009, goalCount=0, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_4},
	{id=1003006, mainuiName="前往<color=#00FF00>幽暗森林</color>", taskGoalType=3, taskGoalParam=1034, goalCount=0, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_4},
	{id=1003007, mainuiName="前往<color=#00FF00>天空之城</color>", taskGoalType=3, taskGoalParam=1011, goalCount=0, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_4},
	{id=1003008, mainuiName="前往<color=#00FF00>坎特鲁废墟</color>", taskGoalType=3, taskGoalParam=1038, goalCount=0, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_4},
	{id=1003009, mainuiName="前往<color=#00FF00>坎特鲁遗址</color>", taskGoalType=3, taskGoalParam=1039, goalCount=0, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_4},
	{id=1003010, mainuiName="前往<color=#00FF00>冰霜之城</color>", taskGoalType=3, taskGoalParam=1058, goalCount=0, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_4},
	{id=1003011, mainuiName="前往<color=#00FF00>安宁池</color>", taskGoalType=3, taskGoalParam=1057, goalCount=0, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_4},
	{id=1004001, mainuiName="对话<color=#00FF00>酒吧老板娘·莉亚</color>", taskGoalType=4, taskGoalParam=100101, goalCount=0, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_5, autoDialogue=1},
	{id=1004002, mainuiName="对话<color=#00FF00>精灵·安吉拉</color>", taskGoalType=4, taskGoalParam=100401, goalCount=0, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_12, autoDialogue=1},
	{id=1004003, mainuiName="对话<color=#00FF00>酒店老板娘\n</color>购买中瓶药水", taskGoalType=4, taskGoalParam=100101, goalCount=0, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_5, autoDialogue=1},
	{id=1004004, mainuiName="对话<color=#00FF00>酒店老板娘\n</color>购买大瓶药水", taskGoalType=4, taskGoalParam=100101, goalCount=0, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_5, autoDialogue=1},
	{id=1004005, mainuiName="对话<color=#00FF00>幻影导师</color>\n领取<color=#00FF00>「新手BUFF」</color>", taskGoalType=4, taskGoalParam=100104, goalCount=0, extraControlName=local_extraControlName.extraControlName_1, instruction={{"moveToNPC","100104"}}, autoDialogue=1},
	{id=1004006, mainuiName="对话<color=#00FF00>幻影导师</color>\n领取<color=#00FF00>「新手BUFF」</color>", taskGoalType=4, taskGoalParam=100402, goalCount=0, extraControlName=local_extraControlName.extraControlName_1, instruction={{"moveToNPC","100402"}}, autoDialogue=1},
	{id=1004007, mainuiName="对话<color=#00FF00>玛雅哥布林</color>\n了解<color=#00FF00>「合成设置」</color>", taskGoalType=4, taskGoalParam=100404, goalCount=0, extraControlName=local_extraControlName.extraControlName_1, instruction={{"moveToNPC","100404"}}, autoDialogue=1},
	{id=1004008, mainuiName="对话<color=#00FF00>赤色要塞报名官</color>\n了解<color=#00FF00>「赤色活动」</color>", taskGoalType=4, taskGoalParam=100113, goalCount=0, extraControlName=local_extraControlName.extraControlName_1, instruction={{"moveToNPC","100113"}}, autoDialogue=1},
	{id=1005006, mainuiName="继续杀怪\n升级到<color=#00FF00>6级</color>", taskGoalType=5, goalCount=6, recordType=1, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_6, autoFight=1},
	{id=1005010, mainuiName="继续杀怪\n升级到<color=#00FF00>10级</color>", taskGoalType=5, goalCount=10, recordType=1, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_6, autoFight=1},
	{id=1005020, mainuiName="继续杀怪\n升级到<color=#00FF00>20级</color>", taskGoalType=5, goalCount=20, recordType=1, extraControlName=local_extraControlName.extraControlName_1, instruction={{"moveToRandom","1","127","170","137","177","133","184"}}, autoFight=1},
	{id=1005021, mainuiName="继续杀怪\n升级到<color=#00FF00>20级</color>", taskGoalType=5, goalCount=20, recordType=1, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_7, autoFight=1},
	{id=1005030, mainuiName="继续杀怪\n升级到<color=#00FF00>30级</color>", taskGoalType=5, goalCount=30, recordType=1, extraControlNum=3, extraControlName=local_extraControlName.extraControlName_2, instruction=local_instruction.instruction_8},
	{id=1005040, mainuiName="继续杀怪\n升级到<color=#00FF00>40级</color>", taskGoalType=5, goalCount=40, recordType=1, extraControlNum=3, extraControlName=local_extraControlName.extraControlName_2, instruction=local_instruction.instruction_8},
	{id=1005050, mainuiName="继续杀怪\n升级到<color=#00FF00>50级</color>", taskGoalType=5, goalCount=50, recordType=1, extraControlNum=3, extraControlName=local_extraControlName.extraControlName_2, instruction=local_instruction.instruction_8},
	{id=1005060, mainuiName="提升等级到<color=#00FF00>60级</color>", taskGoalType=5, goalCount=60, recordType=1, extraControlNum=5},
	{id=1005070, mainuiName="提升等级到<color=#00FF00>70级</color>", taskGoalType=5, goalCount=70, recordType=1, extraControlNum=5},
	{id=1005080, mainuiName="提升等级到<color=#00FF00>80级</color>", taskGoalType=5, goalCount=80, recordType=1, extraControlNum=5},
	{id=1005090, mainuiName="提升等级到<color=#00FF00>90级</color>", taskGoalType=5, goalCount=90, recordType=1, extraControlNum=5},
	{id=1005100, mainuiName="提升等级到<color=#00FF00>100级</color>", taskGoalType=5, goalCount=100, recordType=1, extraControlNum=5},
	{id=1005110, mainuiName="提升等级到<color=#00FF00>110级</color>", taskGoalType=5, goalCount=110, recordType=1, extraControlNum=5},
	{id=1005120, mainuiName="提升等级到<color=#00FF00>120级</color>", taskGoalType=5, goalCount=120, recordType=1, extraControlNum=5},
	{id=1005130, mainuiName="提升等级到<color=#00FF00>130级</color>", taskGoalType=5, goalCount=130, recordType=1, extraControlNum=5},
	{id=1005140, mainuiName="提升等级到<color=#00FF00>140级</color>", taskGoalType=5, goalCount=140, recordType=1, extraControlNum=5},
	{id=1005150, mainuiName="提升等级到<color=#00FF00>150级</color>", taskGoalType=5, goalCount=150, recordType=1, extraControlNum=5},
	{id=1005160, mainuiName="提升等级到<color=#00FF00>160级</color>", taskGoalType=5, goalCount=160, recordType=1, extraControlNum=5},
	{id=1005170, mainuiName="提升等级到<color=#00FF00>170级</color>", taskGoalType=5, goalCount=170, recordType=1, extraControlNum=5},
	{id=1005180, mainuiName="提升等级到<color=#00FF00>180级</color>", taskGoalType=5, goalCount=180, recordType=1, extraControlNum=5, autoFight=1},
	{id=1005190, mainuiName="提升等级到<color=#00FF00>190级</color>", taskGoalType=5, goalCount=190, recordType=1, extraControlNum=5, autoFight=1},
	{id=1005200, mainuiName="提升等级到<color=#00FF00>200级</color>", taskGoalType=5, goalCount=200, recordType=1, extraControlNum=5},
	{id=1005210, mainuiName="提升等级到<color=#00FF00>210级</color>", taskGoalType=5, goalCount=210, recordType=1, extraControlNum=5},
	{id=1005220, mainuiName="提升等级到<color=#00FF00>220级</color>", taskGoalType=5, goalCount=220, recordType=1, extraControlNum=5},
	{id=1005230, mainuiName="提升等级到<color=#00FF00>230级</color>", taskGoalType=5, goalCount=230, recordType=1, extraControlNum=5},
	{id=1005240, mainuiName="提升等级到<color=#00FF00>240级</color>", taskGoalType=5, goalCount=240, recordType=1, extraControlNum=5},
	{id=1005250, mainuiName="提升等级到<color=#00FF00>250级</color>", taskGoalType=5, goalCount=250, recordType=1, extraControlNum=5},
	{id=1005260, mainuiName="提升等级到<color=#00FF00>260级</color>", taskGoalType=5, goalCount=260, recordType=1, extraControlNum=5},
	{id=1005270, mainuiName="提升等级到<color=#00FF00>270级</color>", taskGoalType=5, goalCount=270, recordType=1, extraControlNum=5},
	{id=1005280, mainuiName="提升等级到<color=#00FF00>280级</color>", taskGoalType=5, goalCount=280, recordType=1, extraControlNum=5},
	{id=1005290, mainuiName="提升等级到<color=#00FF00>290级</color>", taskGoalType=5, goalCount=290, recordType=1, extraControlNum=5},
	{id=1005300, mainuiName="提升等级到<color=#00FF00>300级</color>", taskGoalType=5, goalCount=300, recordType=1, extraControlNum=5},
	{id=1005310, mainuiName="提升等级到<color=#00FF00>310级</color>", taskGoalType=5, goalCount=310, recordType=1, extraControlNum=5},
	{id=1005320, mainuiName="提升等级到<color=#00FF00>320级</color>", taskGoalType=5, goalCount=320, recordType=1, extraControlNum=5},
	{id=1005330, mainuiName="提升等级到<color=#00FF00>330级</color>", taskGoalType=5, goalCount=330, recordType=1, extraControlNum=5},
	{id=1005340, mainuiName="提升等级到<color=#00FF00>340级</color>", taskGoalType=5, goalCount=340, recordType=1, extraControlNum=5},
	{id=1005350, mainuiName="提升等级到<color=#00FF00>350级</color>", taskGoalType=5, goalCount=350, recordType=1, extraControlNum=5},
	{id=1005360, mainuiName="提升等级到<color=#00FF00>360级</color>", taskGoalType=5, goalCount=360, recordType=1, extraControlNum=5},
	{id=1005370, mainuiName="提升等级到<color=#00FF00>370级</color>", taskGoalType=5, goalCount=370, recordType=1, extraControlNum=5},
	{id=1005380, mainuiName="提升等级到<color=#00FF00>380级</color>", taskGoalType=5, goalCount=380, recordType=1, extraControlNum=5},
	{id=1005390, mainuiName="提升等级到<color=#00FF00>390级</color>", taskGoalType=5, goalCount=390, recordType=1, extraControlNum=5},
	{id=1005400, mainuiName="提升等级到<color=#00FF00>400级</color>", taskGoalType=5, goalCount=400, recordType=1, extraControlNum=5},
	{id=1000001, mainuiName="第1次转职", taskGoalType=5, goalCount=150, recordType=1, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_6},
	{id=1000002, mainuiName="第2次转职", taskGoalType=5, goalCount=220, recordType=1, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_6},
	{id=1078012, dec="支线任务", taskGoalType=11, taskGoalParam2={21300011,21310011,21320011,21325011,21340011,21310501,21310601,21310701,21310801,21310901,21311001}, recordType=1, extraControlNum=2, extraControlName=local_extraControlName.extraControlName_4, instruction=local_instruction.instruction_10},
	{id=1078013, dec="支线任务", taskGoalType=11, taskGoalParam2={21300021,21310021,21320021,21325021,21330021,21340021,21320501,21320601,21320701,21320801,21320901,21321001}, recordType=1, extraControlNum=2, extraControlName=local_extraControlName.extraControlName_4, instruction=local_instruction.instruction_10},
	{id=1078014, dec="支线任务", taskGoalType=11, taskGoalParam2={21300031,21310031,21320031,21325031,21330031,21340031,21330501,21330601,21330701,21330801,21330901,21331001}, recordType=1, extraControlNum=2, extraControlName=local_extraControlName.extraControlName_4, instruction=local_instruction.instruction_10},
	{id=1008001, mainuiName="开启<color=#f0d396>「转职任务」</color>\n寻找<color=#00FF00>「帝王之书」</color>", taskGoalType=7, taskGoalParam=50020004, goalCount=10, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_11},
	{id=1008002, mainuiName="开启<color=#f0d396>「转职任务」</color>\n寻找<color=#00FF00>「断魂之剑」</color>", taskGoalType=7, taskGoalParam=50020006, goalCount=5, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_11},
	{id=1008003, mainuiName="开启<color=#f0d396>「转职任务」</color>\n寻找<color=#00FF00>「先知之魂」</color>", taskGoalType=7, taskGoalParam=50020005, goalCount=5, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_11},
	{id=1008004, mainuiName="开启<color=#f0d396>「转职任务」</color>\n寻找<color=#00FF00>「精灵之泪」</color>", taskGoalType=7, taskGoalParam=50020007, goalCount=5, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_11},
	{id=1008005, mainuiName="开启<color=#f0d396>「转职任务」</color>\n寻找<color=#00FF00>「深渊之眼」</color>", taskGoalType=7, taskGoalParam=50020008, goalCount=5, extraControlNum=0, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_6},
	{id=1008006, mainuiName="开启<color=#f0d396>「转职任务」</color>\n寻找<color=#00FF00>「荣誉戒指」</color>", taskGoalType=7, taskGoalParam=50020012, goalCount=20, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_11},
	{id=1008007, mainuiName="开启<color=#f0d396>「转职任务」</color>\n寻找<color=#00FF00>「暗黑之石」</color>", taskGoalType=7, taskGoalParam=50020013, goalCount=5, extraControlNum=0, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_6},
	{id=1008008, mainuiName="开启<color=#f0d396>「转职任务」</color>\n寻找<color=#00FF00>「炽炎魔的火种」</color>", taskGoalType=7, taskGoalParam=50020009, goalCount=20, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_11},
	{id=1008009, mainuiName="开启<color=#f0d396>「转职任务」</color>\n寻找<color=#00FF00>「丛林召唤者的角」</color>", taskGoalType=7, taskGoalParam=50020010, goalCount=10, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_11},
	{id=1008010, mainuiName="开启<color=#f0d396>「转职任务」</color>\n寻找<color=#00FF00>「天魔菲尼斯的羽毛」</color>", taskGoalType=7, taskGoalParam=50020011, goalCount=2, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_11},
	{id=1050001, dec="支线任务", mainuiName="查看<color=#00FF00>游戏攻略</color>", taskGoalType=50, taskGoalParam=1, taskGoalParam3={"dev/ui/Preview/Panel/KLPreview/KLPreviewPanel","togType=1"}, goalCount=0, recordType=0, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/ui/Preview/Panel/KLPreview/KLPreviewPanel","1","togType=1"}}},
	{id=1050002, dec="支线任务", mainuiName="查看<color=#00FF00>游戏玩法</color>", taskGoalType=50, taskGoalParam=1, taskGoalParam3={"dev/ui/Preview/Panel/KLPreview/KLPreviewPanel","togType=2"}, goalCount=0, recordType=0, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/ui/Preview/Panel/KLPreview/KLPreviewPanel","1","togType=2"}}},
	{id=1050003, dec="支线任务", mainuiName="查看<color=#00FF00>装备首爆</color>", taskGoalType=50, taskGoalParam=1, taskGoalParam3={"dev/outui/FirstDrop/Panel/KLFirstDrop/KLFirstDropPanel"}, goalCount=0, recordType=0, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/FirstDrop/Panel/KLFirstDrop/KLFirstDropPanel"}}},
	{id=1050004, dec="支线任务", mainuiName="查看<color=#00FF00>游戏月卡</color>", taskGoalType=50, taskGoalParam=1, taskGoalParam3={"dev/outui/MonthCard/Panel/KLMonthCardNew/KLMonthCardNewPanel"}, goalCount=0, recordType=0, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/MonthCard/Panel/KLMonthCardNew/KLMonthCardNewPanel"}}},
	{id=1050005, dec="支线任务", mainuiName="查看<color=#00FF00>游戏商城</color>", taskGoalType=50, taskGoalParam=1, taskGoalParam2=local_taskGoalParam2.taskGoalParam2_2, taskGoalParam3={"dev/outui/ShopMain/Panel/KLShopMain/KLShopMainPanel"}, goalCount=0, recordType=0, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/ShopMain/Panel/KLShopMain/KLShopMainPanel"}}},
	{id=1050006, dec="支线任务", mainuiName="查看<color=#00FF00>交易行</color>", taskGoalType=50, taskGoalParam=1, taskGoalParam2=local_taskGoalParam2.taskGoalParam2_2, taskGoalParam3={"dev/outui/Trade/Panel/KLTradeMain/KLTradeMainPanel"}, goalCount=0, recordType=0, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/outui/Trade/Panel/KLTradeMain/KLTradeMainPanel"}}},
	{id=1050007, dec="支线任务", mainuiName="查看<color=#00FF00>装备锻造</color>", taskGoalType=50, taskGoalParam=1, taskGoalParam2=local_taskGoalParam2.taskGoalParam2_2, taskGoalParam3={"dev/ui/UIForgeGroup/Panel/KLUIForgeGroup/KLUIForgeGroupPanel"}, goalCount=0, recordType=0, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_13},
	{id=1050008, mainuiName="打开背包，修理装备1次", taskGoalType=50, taskGoalParam=2, taskGoalParam2=local_taskGoalParam2.taskGoalParam2_2, taskGoalParam3={"KLUIBagPanel","btn_fix"}, goalCount=0, recordType=0, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel"},{"ClickButton","KLUIBagPanel","btn_fix"}}},
	{id=1009001, dec="支线任务", mainuiName="<color=#00FF00>加入战盟</color>", taskGoalType=9, goalCount=0, recordType=0, extraControlName=local_extraControlName.extraControlName_1, instruction={{"openUIPanel","dev/ui/Union/Panel/KLUnionToggleList/KLUnionToggleListPanel"}}},
	{id=1001001, mainuiName="对话<color=#00FF00>酒店老板娘\n</color>购买小瓶药水*20", taskGoalType=1, taskGoalParam=30010002, goalCount=20, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_5, autoDialogue=1},
	{id=1001002, mainuiName="对话<color=#00FF00>酒店老板娘\n</color>购买小瓶药水*40", taskGoalType=1, taskGoalParam=30010002, goalCount=40, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_5, autoDialogue=1},
	{id=1001003, mainuiName="对话<color=#00FF00>精灵·安吉拉\n</color>购买小瓶药水*20", taskGoalType=1, taskGoalParam=30010002, goalCount=20, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_12, autoDialogue=1},
	{id=1001004, mainuiName="对话<color=#00FF00>精灵·安吉拉\n</color>购买小瓶药水*40", taskGoalType=1, taskGoalParam=30010002, goalCount=40, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_12, autoDialogue=1},
	{id=1016001, dec="支线任务", mainuiName="任意装备强化1次", taskGoalType=52, taskGoalParam=0, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_13},
	{id=1032201, dec="支线任务", mainuiName="购买技能\n<color=#00FF00>火球术</color>", taskGoalType=32, taskGoalParam2={60030004}, recordType=1, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_14, autoDialogue=1},
	{id=1032202, dec="支线任务", mainuiName="购买技能\n<color=#00FF00>真空波术</color>", taskGoalType=32, taskGoalParam2={60030011}, recordType=1, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_14, autoDialogue=1},
	{id=1032203, dec="支线任务", mainuiName="购买技能\n<color=#00FF00>掌心雷术</color>", taskGoalType=32, taskGoalParam2={60030003}, recordType=1, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_14, autoDialogue=1},
	{id=1032204, dec="支线任务", mainuiName="购买技能\n<color=#00FF00>瞬间移动术</color>", taskGoalType=32, taskGoalParam2={60030006}, recordType=1, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_14, autoDialogue=1},
	{id=1032205, dec="支线任务", mainuiName="购买技能\n<color=#00FF00>陨石术</color>", taskGoalType=32, taskGoalParam2={60030002}, recordType=1, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_14, autoDialogue=1},
	{id=1032206, dec="支线任务", mainuiName="购买技能\n<color=#00FF00>冰封术</color>", taskGoalType=32, taskGoalParam2={60030007}, recordType=1, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_14, autoDialogue=1},
	{id=1032207, dec="支线任务", mainuiName="购买技能\n<color=#00FF00>火龙术</color>", taskGoalType=32, taskGoalParam2={60030005}, recordType=1, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_14, autoDialogue=1},
	{id=1032208, dec="支线任务", mainuiName="购买技能\n<color=#00FF00>龙卷风术</color>", taskGoalType=32, taskGoalParam2={60030008}, recordType=1, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_14, autoDialogue=1},
	{id=1032301, dec="支线任务", mainuiName="购买技能\n<color=#00FF00>哥布林召唤之石</color>", taskGoalType=32, taskGoalParam2={60030030}, recordType=1, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_15, autoDialogue=1},
	{id=1032302, dec="支线任务", mainuiName="购买技能\n<color=#00FF00>石巨人召唤之石</color>", taskGoalType=32, taskGoalParam2={60030031}, recordType=1, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_15, autoDialogue=1},
	{id=1032303, dec="支线任务", mainuiName="购买技能\n<color=#00FF00>暗杀者召唤之石</color>", taskGoalType=32, taskGoalParam2={60030032}, recordType=1, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_15, autoDialogue=1},
	{id=1032304, dec="支线任务", mainuiName="购买技能\n<color=#00FF00>雪人王召唤之石</color>", taskGoalType=32, taskGoalParam2={60030033}, recordType=1, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_15, autoDialogue=1},
	{id=1032305, dec="支线任务", mainuiName="购买技能\n<color=#00FF00>暗黑骑士召唤之石</color>", taskGoalType=32, taskGoalParam2={60030034}, recordType=1, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_15, autoDialogue=1},
	{id=6066601, dec="转职任务", mainuiName="开启<color=#f0d396>【一转转职任务1】</color>", taskGoalType=5, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_4, autoFight=1},
	{id=6066602, dec="转职任务", mainuiName="开启<color=#f0d396>【转职任务】</color>\n寻找<color=#1ADD1F>【帝王之书】</color>", taskGoalType=7, taskGoalParam=50020004, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_4, autoFight=1},
	{id=6066603, dec="转职任务", mainuiName="开启<color=#f0d396>【一转转职任务2】</color>", taskGoalType=5, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_4, autoFight=1},
	{id=60666041, dec="转职任务", mainuiName="开启<color=#f0d396>【转职任务】</color>\n寻找<color=#1ADD1F>【断魂之剑】</color>", taskGoalType=7, taskGoalParam=50020006, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_4, autoFight=1},
	{id=60666042, dec="转职任务", mainuiName="开启<color=#f0d396>【转职任务】</color>\n寻找<color=#1ADD1F>【先知之魂】</color>", taskGoalType=7, taskGoalParam=50020005, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_4},
	{id=60666043, dec="转职任务", mainuiName="开启<color=#f0d396>【转职任务】</color>\n寻找<color=#1ADD1F>【精灵之泪】</color>", taskGoalType=7, taskGoalParam=50020007, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_4},
	{id=6066605, dec="转职任务", mainuiName="开启<color=#f0d396>【二转转职任务1】</color>", taskGoalType=5, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_4, autoFight=1},
	{id=6066606, dec="转职任务", mainuiName="开启<color=#f0d396>【转职任务】</color>\n寻找<color=#1ADD1F>【荣誉戒指】</color>", taskGoalType=7, taskGoalParam=50020012, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_4},
	{id=6066607, dec="转职任务", mainuiName="开启<color=#f0d396>【二转转职任务2】</color>", taskGoalType=5, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_4, autoFight=1},
	{id=6066608, dec="转职任务", mainuiName="开启<color=#f0d396>【转职任务】</color>\n寻找<color=#1ADD1F>【暗黑之石】</color>", taskGoalType=7, taskGoalParam=50020013, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_4},
	{id=6066609, dec="转职任务", mainuiName="开启<color=#f0d396>【三转转职任务1】</color>", taskGoalType=5, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_4, autoFight=1},
	{id=60666101, dec="转职任务", mainuiName="寻找<color=#1ADD1F>【炽炎魔的火种】</color>", taskGoalType=7, taskGoalParam=50020009, goalCount=3, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_4},
	{id=60666102, dec="转职任务", mainuiName="寻找<color=#1ADD1F>【丛林召唤者的角】</color>", taskGoalType=7, taskGoalParam=50020010, goalCount=3, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_4},
	{id=60666103, dec="转职任务", mainuiName="寻找<color=#1ADD1F>【天魔菲尼斯的羽毛】</color>", taskGoalType=7, taskGoalParam=50020011, goalCount=3, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_4},
	{id=6066611, dec="转职任务", mainuiName="开启<color=#f0d396>【三转转职任务2】</color>", taskGoalType=5, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_4, autoFight=1},
	{id=6066612, dec="转职任务", mainuiName="击杀<color=#00FF00>暗黑防御者</color>", taskGoalParam=700061, goalCount=10, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_6},
	{id=60666121, dec="转职任务", mainuiName="击杀<color=#00FF00>暗黑咒术师</color>", taskGoalParam=700062, goalCount=10, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_6},
	{id=60666122, dec="转职任务", mainuiName="击杀<color=#00FF00>暗黑扫荡者</color>", taskGoalParam=700063, goalCount=10, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_6},
	{id=6066613, dec="转职任务", mainuiName="开启<color=#f0d396>【三转转职任务3】</color>", taskGoalType=5, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_4, autoFight=1},
	{id=6066614, dec="转职任务", mainuiName="击杀<color=#00FF00>暗黑指挥官</color>", taskGoalParam=700060, extraControlName=local_extraControlName.extraControlName_1, instruction=local_instruction.instruction_6},
}

local defaults = {dec="主线任务", mainuiName="穿戴<color=#00FF00>翅膀</color>", taskGoalType=51, taskGoalParam=0, taskGoalParam2={}, taskGoalParam3={""}, goalCount=1, recordType=0, extraControlNum=1, extraControlName={"小怪挂机","恶魔广场","血色城堡","提升输出","锻造装备"}, extraControlConditions={""}, instruction={{"openUIPanel","dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel"},{"openUIPanel","dev/ui/Preview/Panel/KLPreview/KLPreviewPanel","1","togType=2&subType=2"},{"openUIPanel","dev/ui/Preview/Panel/KLPreview/KLPreviewPanel","1","togType=2&subType=1"},{"openUIPanel","dev/outui/ShopMain/Panel/KLShopMain/KLShopMainPanel"},{"openUIPanel","dev/ui/UIForgeGroup/Panel/KLUIForgeGroup/KLUIForgeGroupPanel"}}, autoTask=0, autoFight=0, autoDialogue=0}
local mt = {__index = defaults}
for _, v in ipairs(cfg_task_target) do
	setmetatable(v, mt)
end

return cfg_task_target