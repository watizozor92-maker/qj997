-- 此文件工具自动生成，不要修改
---@class cfg_model_npc_column
---唯一ID
---@field id number @编号 column=1 A
---工程内具体对应资源标识
---@field path string @资源标识 column=2 B
---@field name string @备注 column=3 C
---npc对话头像
---配置格式：资源名称
---@field talkImage string @npc对话头像 column=4 D
local cfg_model_npc =
{
	{id=1, path="Model/Npc/npc001", name="仓库使者塞弗特", talkImage="NPChead0001"},
	{id=2, path="Model/Npc/npc002", name="铁匠汉斯", talkImage="NPChead0002"},
	{id=3, path="Model/Npc/npc003", name="魔导士 帕希", talkImage="NPChead0003"},
	{id=4, path="Model/Npc/npc004", name="驯兽师"},
	{id=5, path="Model/Npc/npc005", name="多普瑞恩家族管家"},
	{id=6, path="Model/Npc/npc006", name="市场传送师 朱丽亚", talkImage="NPChead0006"},
	{id=7, path="Model/Npc/npc007", name="流浪商人海罗德"},
	{id=8, path="Model/Npc/npc008", name="流浪商人马丁"},
	{id=9, path="Model/Npc/npc010", name="老板娘 莉雅"},
	{id=10, path="Model/Npc/npc010", name="老板娘 莉雅"},
	{id=11, path="Model/Npc/NPC011", name="老板娘莉娜"},
	{id=12, path="Model/Npc/npc012", name="幻影导师", talkImage="NPChead0012"},
	{id=13, path="Model/Npc/npc013", name="玛雅使者", talkImage="NPChead0013"},
	{id=14, path="Model/Npc/NPC014", name="守卫", talkImage="NPChead0014"},
	{id=15, path="Model/Npc/NPC015", name="少女安娜"},
	{id=16, path="Model/Npc/NPC016", name=""},
	{id=17, path="Model/Npc/NPC017", name="赤色要塞指挥官"},
	{id=18, path="Model/Npc/NPC020", name="流浪商人阿莱斯"},
	{id=19, path="Model/Npc/NPC021", name="卡隆"},
	{id=20, path="Model/Npc/NPC022", name="弟子黛彬"},
	{id=21, path="Model/Npc/NPC023", name="工匠尤达"},
	{id=22, path="Model/Npc/NPC025", name="精灵安吉拉"},
	{id=23, path="Model/Npc/NPC026", name="艾尔菲丝"},
	{id=24, path="Model/Npc/NPC027", name="荧之石管理员/符纹师如尼"},
	{id=25, path="Model/Npc/NPC028", name="魔炼接引人弗萨克"},
	{id=26, path="Model/Npc/NPC029", name="杰瑞敦"},
	{id=27, path="Model/Npc/NPC030", name="雷拉"},
	{id=28, path="Model/Npc/NPC031", name="摩尔塞"},
	{id=29, path="Model/Npc/NPC032", name="战盟使者罗兰斯", talkImage="NPChead0032"},
	{id=30, path="Model/Npc/NPC033", name="弥拉丘"},
	{id=31, path="Model/Npc/NPC034", name="玛雅哥布林", talkImage="NPChead0034"},
	{id=32, path="Model/Npc/NPC035", name="攻城投石车"},
	{id=33, path="Model/Npc/NPC036", name="攻城投石车"},
	{id=34, path="Model/Npc/NPC037", name="塞尔维斯"},
	{id=35, path="Model/Npc/NPC038", name="攻城卫兵"},
	{id=36, path="Model/Npc/NPC040", name="物资管理员 帕糜拉"},
	{id=37, path="Model/Npc/NPC041", name="物资管理员 安吉拉"},
	{id=38, path="Model/Npc/NPC043", name="长老"},
	{id=39, path="Model/Npc/NPC044", name="奥斯本（半裸）"},
	{id=40, path="Model/Npc/NPC045", name="奥斯本"},
	{id=41, path="Model/Npc/NPC046", name="雷亚"},
	{id=42, path="Model/Npc/NPC047", name="荧之石研究员/坐骑装备 蒙特"},
	{id=43, path="Model/Npc/NPC048", name="圣导士塞维娜"},
	{id=44, path="Model/Npc/NPC049", name="塞尔维亚"},
	{id=45, path="Model/Npc/NPC051", name="武器商人苏菲"},
	{id=46, path="Model/Npc/NPC052", name="魔导士露茜"},
	{id=47, path="Model/Npc/NPC053", name="竞技场卫兵"},
	{id=48, path="Model/Npc/NPC054", name="爆竹商人 罗嗒莎"},
	{id=49, path="Model/Npc/NPC055", name="暗黑血狼人扩雷"},
	{id=50, path="Model/Npc/NPC057", name="倒地的大天使使者", talkImage="NPChead0057"},
	{id=51, path="Model/Npc/NPC058", name="大天使的使者"},
	{id=52, path="Model/Npc/NPC059", name="樱花精灵"},
	{id=53, path="Model/Npc/NPC060", name="陆迦德"},
	{id=54, path="Model/Npc/Npc061", name="地下城幻影导师"},
	{id=55, path="Model/Npc/Npc062", name=""},
	{id=56, path="Model/Npc/Npc063", name="勇者大陆幻影导师"},
	{id=57, path="Model/Npc/NPc064", name="警卫队长摩伦"},
}

local defaults = {talkImage=""}
local mt = {__index = defaults}
for _, v in ipairs(cfg_model_npc) do
	setmetatable(v, mt)
end

return cfg_model_npc