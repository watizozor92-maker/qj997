-- 此文件工具自动生成，不要修改
---@class cfg_gm_column
---排序编号
---@field id number @编号 column=1 A
---显示信息
---@field tipInfo string @信息 column=2 B
---命令内容
---@field command string @GM命令 column=3 C
local cfg_gm =
{
	{id=1, tipInfo="进入游戏按Tab键，开启GM输入面板", command="输入GM指令"},
	{id=2, tipInfo="掉落道具", command="@make cfg_item的id 1"},
	{id=3, tipInfo="怪物", command="@createMonster 怪物名称或id"},
	{id=4, tipInfo="添加技能，需要登录生效", command="@addskill skillId skillLv"},
	{id=5, tipInfo="创建邮件", command="@mail 标题 内容 物品 物品数量"},
	{id=6, tipInfo="增加经验", command="@addexp 经验值"},
	{id=7, tipInfo="学习所有技能，需要登录生效", command="@allskill"},
	{id=8, tipInfo="设置行会容纳人数， 需要登录生效", command="@setUnionMemberCount 数量"},
	{id=9, tipInfo="颁发称号", command="@addTitle itemId"},
	{id=10, tipInfo="清空背包", command="@cleanBag"},
	{id=11, tipInfo="道具入包", command="@makeItemToBag cfg_item的id 数量"},
	{id=12, tipInfo="魔法值和血量值加满", command="@restore 百分比HP 百分比MP(1-100数字不加%)"},
	{id=13, tipInfo="领取任务", command="@getTask cfg_task的id"},
	{id=14, tipInfo="完成任务", command="@完成任务 cfg_task的id"},
	{id=15, tipInfo="传送", command="@tp x y 地图名称 例：@tp 200 160 比奇城你 (只输入坐标默认在当前地图传送)"},
	{id=16, tipInfo="填满背包", command="@fullBag cfg_item的id(只能是道具占一格的非叠加道具id默认可以不写)"},
	{id=17, tipInfo="填满仓库", command="@fullStore cfg_item的id(只能是道具占一格的非叠加道具id默认可以不写)"},
	{id=18, tipInfo="清空仓库", command="@cleanStore"},
	{id=19, tipInfo="删除道具", command="@deleteItem cfg_item的id 数量"},
	{id=20, tipInfo="杀死坐标点怪物", command="@killPerformer x y"},
	{id=21, tipInfo="设置活跃度", command="@setActivityValue 100   （1-100数字）"},
	{id=22, tipInfo="完成活动任务", command="@finishActivityTask 1 1（cfg_activity_rule中的ID、需要完成的次数）"},
	{id=23, tipInfo="重置活动任务", command="@reseatDailyActivityTask"},
	{id=24, tipInfo="开启限时活动入口", command="@openActivityTimingTask 8"},
	{id=25, tipInfo="关闭限时活动入口", command="@closeActivityTimingTask 8"},
	{id=26, tipInfo="修改属性值", command="@addAttr 属性名称 增量"},
	{id=27, tipInfo="设置系统时间", command="@setTime 日期 时间(例：@setTime 2022-03-15 20:30)"},
	{id=28, tipInfo="设置属性", command="@setAttr 生命值 1000"},
	{id=29, tipInfo="修改技能参数", command="@skillConfig xxx 值"},
	{id=30, tipInfo="丢弃道具(背包)", command="@giveUpItem index 数量(index=10000+行数*100+列数)"},
	{id=31, tipInfo="召唤宠物", command="@petMonsterFight 1 1 (参数1:宠物ID;参数2:操作类型[1:召唤，2:取消])"},
	{id=32, tipInfo="生成自定义属性装备", command="@makeCustomizeEquipToBag 装备id 品阶id 卓越属性id 卓越属性值 （卓越属性要几个配几个)"},
	{id=33, tipInfo="清空所有伙伴", command="@clearPartner"},
	{id=34, tipInfo="导出线上角色", command="@useRole 角色名称"},
	{id=35, tipInfo="转职", command="@transferCareer 职业id"},
}
return cfg_gm