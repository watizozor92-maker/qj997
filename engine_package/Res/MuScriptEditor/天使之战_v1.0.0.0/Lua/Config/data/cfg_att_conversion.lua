-- 此文件工具自动生成，不要修改
---@class cfg_att_conversion_column
---唯一ID
---根职业*100+序列
---@field id number @ID column=1 A
---属性名称
---@field attr string @属性 column=2 B
---属性中文名称及备注
---@field name string @名称及注释 column=3 C
---1点力量转换的属性（万分比）
---@field strength number @力量 column=4 D
---1点敏捷转换的属性（万分比）
---@field agility number @敏捷 column=5 E
---1点智力转换的属性（万分比）
---@field intelligence number @智力 column=6 F
---1点体力转换的属性（万分比）
---@field stamina number @体力 column=7 G
---1点统帅转换的属性（万分比）
---@field command number @统帅 column=8 H
---1点其他属性转化的属性（万分比）
---其他属性填写att_info中ID
---格式：属性ID#转化比
---@field another IntList @其他属性 column=9 I
---默认职业归属
---引援career职业表
---格式：所属职业#职业等级
---多职业之间用|分隔
---@field career IntListList @职业 column=10 J
---需要显示的1级属性id，配置了属性id的，则改属性只在该1级属性下显示，没有配置则默认显示  填-1则不在2级页签显示
---@field display number @显示1级属性id column=11 K

local local_another = {
    another_1={},
    another_2={206011,5000},

}

local local_career = {
    career_1={{1,1},{1,2},{1,3},{1,4}},
    career_2={{2,1},{2,2},{2,3},{2,4}},
    career_3={{3,1},{3,2},{3,3},{3,4}},
    career_4={{4,1},{4,2},{4,3},{4,4}},
    career_5={{5,1},{5,2},{5,3},{5,4}},
    career_6={{6,1},{6,2},{6,3},{6,4}},
    career_7={{7,1},{7,2},{7,3},{7,4}},

}

local cfg_att_conversion =
{
	{id=101, name="最小物理攻击力", strength=1667, career=local_career.career_1, display=10001},
	{id=102, attr="maxDC", name="最大物理攻击力", strength=2500, career=local_career.career_1, display=10001},
	{id=103, attr="hitRate", strength=2500, agility=15000, career=local_career.career_1, display=10001},
	{id=104, attr="attackRatePK", name="PVP攻击成功率", agility=45000, career=local_career.career_1, display=10001},
	{id=105, attr="armor", name="防御值", agility=3000, career=local_career.career_1},
	{id=106, attr="missRate", name="PVE防御率", agility=3000, career=local_career.career_1},
	{id=107, attr="eraRatePK", name="PVP防御成功率", agility=5000, career=local_career.career_1},
	{id=108, attr="AniattackSpeed", name="攻击速度", agility=650, career=local_career.career_1},
	{id=109, attr="maxHP", name="生命值", stamina=30000, career=local_career.career_1, display=10004},
	{id=110, attr="maxMP", name="魔法值", intelligence=20000, career=local_career.career_1, display=10003},
	{id=111, attr="skillDamagPro", name="职业技能攻击力提升比例", intelligence=10, career=local_career.career_1, display=10003},
	{id=113, attr="hudunValue", name="护盾值（SD）", strength=12000, agility=12000, intelligence=12000, stamina=120000, another=local_another.another_2, career=local_career.career_1, display=-1},
	{id=114, attr="agValue", name="技能值（AG）", strength=1500, agility=2000, intelligence=10000, stamina=3000, career=local_career.career_1, display=-1},
	{id=115, attr="AttackPowerBonus", name="战斗威力加成", strength=1.25, career=local_career.career_1, display=10004},
	{id=116, attr="HPFieldRecoverPer", name="每3秒固定回复生命", stamina=100, career=local_career.career_1, display=10004},
	{id=117, attr="magicrecoveryspeed", name="每3秒固定回复魔力", intelligence=5000, career=local_career.career_1, display=10004},
	{id=118, attr="skillDamageAdd", name="技能攻击力", intelligence=10, career=local_career.career_1, display=10004},
	{id=119, attr="agAutomaticReply", name="每3秒固定回复AG值", intelligence=3000, career=local_career.career_1, display=-1},
	{id=201, name="最小物理攻击力", strength=1250, career=local_career.career_2, display=10001},
	{id=202, attr="maxDC", name="最大物理攻击力", strength=2500, career=local_career.career_2, display=10001},
	{id=203, attr="hitRate", strength=2500, agility=15000, career=local_career.career_2, display=10001},
	{id=204, attr="attackRatePK", name="PVP攻击成功率", agility=45000, career=local_career.career_2, display=10001},
	{id=205, attr="armor", name="防御值", agility=2500, career=local_career.career_2},
	{id=206, attr="missRate", name="PVE防御率", agility=3000, career=local_career.career_2},
	{id=207, attr="eraRatePK", name="PVP防御成功率", agility=2500, career=local_career.career_2},
	{id=208, attr="AniSpeedMagic", name="魔法攻击速度", agility=1000, career=local_career.career_2},
	{id=209, attr="maxHP", name="生命值", stamina=20000, career=local_career.career_2, display=10004},
	{id=210, attr="maxMP", name="魔法值", intelligence=20000, career=local_career.career_2, display=10003},
	{id=211, attr="minMC", name="最小魔法攻击力", intelligence=1112, career=local_career.career_2, display=10003},
	{id=212, attr="maxMC", name="最大魔法攻击力", intelligence=2500, career=local_career.career_2, display=10003},
	{id=213, attr="MagicDamage", name="魔法伤害", career=local_career.career_2, display=10003},
	{id=215, attr="hudunValue", name="护盾值（SD）", strength=12000, agility=12000, intelligence=12000, stamina=12000, another=local_another.another_2, career=local_career.career_2, display=-1},
	{id=216, attr="agValue", name="技能值（AG）", strength=2000, agility=2500, intelligence=2000, stamina=3000, career=local_career.career_2, display=-1},
	{id=217, attr="HPFieldRecoverPer", name="每3秒固定回复生命", stamina=100, career=local_career.career_2, display=10004},
	{id=218, attr="magicrecoveryspeed", name="每3秒固定回复魔力", career=local_career.career_2, display=10004},
	{id=219, attr="agAutomaticReply", name="每3秒固定回复AG值", stamina=2500, career=local_career.career_2, display=-1},
	{id=301, name="最小物理攻击力", strength=1250, agility=1250, career=local_career.career_3, display=10001},
	{id=302, attr="maxDC", name="最大物理攻击力", strength=2500, agility=2500, career=local_career.career_3, display=10001},
	{id=303, attr="hitRate", strength=2500, agility=15000, career=local_career.career_3, display=10001},
	{id=304, attr="attackRatePK", name="PVP攻击成功率", agility=6000, career=local_career.career_3, display=10001},
	{id=305, attr="armor", name="防御值", agility=1000, career=local_career.career_3},
	{id=306, attr="missRate", name="PVE防御率", agility=2500, career=local_career.career_3},
	{id=307, attr="eraRatePK", name="PVP防御成功率", agility=1000, career=local_career.career_3},
	{id=308, attr="AniattackSpeed", name="攻击速度", agility=200, career=local_career.career_3},
	{id=309, attr="maxHP", name="生命值", stamina=20000, career=local_career.career_3, display=10004},
	{id=310, attr="maxMP", name="魔法值", intelligence=15000, career=local_career.career_3, display=10003},
	{id=313, attr="hudunValue", name="护盾值（SD）", strength=12000, agility=12000, intelligence=12000, stamina=12000, another=local_another.another_2, career=local_career.career_3, display=-1},
	{id=314, attr="agValue", name="技能值（AG）", strength=3000, agility=2000, intelligence=2000, stamina=3000, career=local_career.career_3, display=-1},
	{id=315, attr="minMC", name="最小魔法攻击力", career=local_career.career_3, display=10003},
	{id=316, attr="maxMC", name="最大魔法攻击力", career=local_career.career_3, display=10003},
	{id=317, attr="HPFieldRecoverPer", name="每3秒固定回复生命", stamina=1000, career=local_career.career_3, display=10004},
	{id=318, attr="magicrecoveryspeed", name="每3秒固定回复魔力", career=local_career.career_3, display=10004},
	{id=319, attr="agAutomaticReply", name="每3秒固定回复AG值", stamina=2500, career=local_career.career_3, display=-1},
	{id=401, name="最小攻击力", strength=1500, intelligence=800, career=local_career.career_4, display=10001},
	{id=402, attr="maxDC", name="最大攻击力", strength=2500, intelligence=1250, career=local_career.career_4, display=10001},
	{id=403, attr="hitRate", strength=2500, agility=15000, career=local_career.career_4, display=10001},
	{id=404, attr="attackRatePK", name="PVP攻击成功率", agility=35000, career=local_career.career_4, display=10001},
	{id=405, attr="armor", name="防御值", agility=2000, career=local_career.career_4},
	{id=406, attr="missRate", name="PVE防御率", agility=3334, career=local_career.career_4},
	{id=407, attr="eraRatePK", name="PVP防御成功率", agility=2500, career=local_career.career_4},
	{id=408, attr="AniattackSpeed", name="攻击速度", agility=1000, career=local_career.career_4},
	{id=409, attr="maxHP", name="生命值", stamina=20000, career=local_career.career_4, display=10004},
	{id=410, attr="minMC", name="最小魔法攻击力", intelligence=1100, career=local_career.career_4, display=10003},
	{id=411, attr="maxMC", name="最大魔法攻击力", intelligence=2500, career=local_career.career_4, display=10003},
	{id=412, attr="maxMP", name="魔法值", intelligence=20000, career=local_career.career_4, display=10003},
	{id=414, attr="hudunValue", name="护盾值（SD）", strength=12000, agility=12000, intelligence=12000, stamina=12000, another=local_another.another_2, career=local_career.career_4, display=-1},
	{id=415, attr="agValue", name="技能值（AG）", strength=2000, agility=2500, intelligence=1500, stamina=3334, career=local_career.career_4, display=-1},
	{id=416, attr="AniSpeedMagic", name="魔法攻击速度", agility=500, career=local_career.career_4},
	{id=417, attr="HPFieldRecoverPer", name="每3秒固定回复生命", stamina=1000, career=local_career.career_4, display=10004},
	{id=418, attr="magicrecoveryspeed", name="每3秒固定回复魔力", career=local_career.career_4, display=10004},
	{id=419, attr="agAutomaticReply", name="每3秒固定回复AG值", stamina=2500, career=local_career.career_4, display=-1},
	{id=501, name="最小攻击力", strength=1500, intelligence=800, display=10001},
	{id=502, attr="maxDC", name="最大攻击力", strength=2500, intelligence=1250, display=10001},
	{id=503, attr="hitRate", strength=2500, agility=15000, display=10001},
	{id=504, attr="attackRatePK", name="PVP攻击成功率", agility=35000, display=10001},
	{id=505, attr="armor", name="防御值", agility=2500},
	{id=506, attr="missRate", name="PVE防御率", agility=3000},
	{id=507, attr="eraRatePK", name="PVP防御成功率", agility=1250},
	{id=508, attr="AniattackSpeed", name="攻击速度", agility=1000},
	{id=509, attr="maxHP", name="生命值", stamina=20000, display=10004},
	{id=510, attr="maxMP", name="魔法值", intelligence=20000, display=10003},
	{id=512, attr="skyhawksMinimumAttackPower", name="天鹰最小攻击力", display=10005},
	{id=513, attr="skyhawksMaximumAttackPower", name="天鹰最大攻击力", display=10005},
	{id=514, attr="blackHorseKingsAttackPower", name="黑马王攻击力", display=10005},
	{id=515, attr="hudunValue", name="护盾值（SD）", strength=12000, agility=12000, intelligence=12000, stamina=12000, another=local_another.another_2, display=-1},
	{id=516, attr="agValue", name="技能值（AG）", strength=3334, agility=2000, intelligence=1500, stamina=1000, command=3000, display=-1},
	{id=517, attr="AniSpeedMagic", name="魔法攻击速度"},
	{id=518, attr="HPFieldRecoverPer", name="每3秒固定回复生命", stamina=1000, display=10004},
	{id=519, attr="magicrecoveryspeed", name="每3秒固定回复魔力", display=10004},
	{id=520, attr="agAutomaticReply", name="每3秒固定回复AG值", stamina=2500, display=-1},
	{id=601, name="最小攻击力", strength=1400, career=local_career.career_6, display=10001},
	{id=602, attr="maxDC", name="最大攻击力", strength=2500, career=local_career.career_6, display=10001},
	{id=603, attr="hitRate", strength=2500, agility=15000, career=local_career.career_6, display=10001},
	{id=605, attr="armor", name="防御值", agility=3000, career=local_career.career_6},
	{id=606, attr="missRate", name="PVE防御率", agility=2500, career=local_career.career_6},
	{id=608, attr="AniSpeedBonus", name="攻击速度", career=local_career.career_6},
	{id=609, attr="maxHP", name="生命值", stamina=20000, career=local_career.career_6, display=10004},
	{id=610, attr="maxMP", name="魔法值", intelligence=17000, career=local_career.career_6, display=10003},
	{id=611, attr="minMC", name="最小魔法攻击力", intelligence=1100, career=local_career.career_6, display=10003},
	{id=612, attr="maxMC", name="最大魔法攻击力", intelligence=2500, career=local_career.career_6, display=10003},
	{id=613, attr="minimumCurseAttackPower", name="最小诅咒攻击力", intelligence=1110, career=local_career.career_6, display=10003},
	{id=614, attr="maximumCurseAttackPower", name="最大诅咒攻击力", intelligence=2500, career=local_career.career_6, display=10003},
	{id=615, attr="hudunValue", name="护盾值（SD）", strength=12000, agility=12000, intelligence=12000, stamina=12000, another=local_another.another_2, career=local_career.career_6, display=-1},
	{id=616, attr="agValue", name="技能值（AG）", strength=2000, agility=3000, intelligence=1500, stamina=3000, career=local_career.career_6, display=-1},
	{id=617, attr="AniSpeedMagic", name="魔法攻击速度", agility=500, career=local_career.career_6},
	{id=618, attr="HPFieldRecoverPer", name="每3秒固定回复生命", stamina=1000, career=local_career.career_6, display=10004},
	{id=619, attr="magicrecoveryspeed", name="每3秒固定回复魔力", career=local_career.career_6, display=10004},
	{id=620, attr="agAutomaticReply", name="每3秒固定回复AG值", stamina=2500, career=local_career.career_6, display=-1},
	{id=701, name="最小物理攻击力", strength=1250, career=local_career.career_7, display=10001},
	{id=702, attr="maxDC", name="最大物理攻击力", strength=2500, career=local_career.career_7, display=10001},
	{id=703, attr="hitRate", strength=2500, agility=15000, career=local_career.career_7, display=10001},
	{id=704, attr="attackRatePK", name="PVP攻击成功率", agility=40000, career=local_career.career_7, display=10001},
	{id=705, attr="armor", name="防御值", agility=3334, career=local_career.career_7},
	{id=706, attr="missRate", name="PVE防御率", agility=3334, career=local_career.career_7},
	{id=707, attr="eraRatePK", name="PVP防御成功率", agility=2500, career=local_career.career_7},
	{id=708, attr="AniSpeedMagic", name="魔法攻击速度", agility=1000, career=local_career.career_7},
	{id=709, attr="maxHP", name="生命值", stamina=20000, career=local_career.career_7, display=10004},
	{id=710, attr="maxMP", name="魔法值", intelligence=20000, career=local_career.career_7, display=10003},
	{id=711, attr="minMC", name="最小魔法攻击力", intelligence=2000, career=local_career.career_7, display=10003},
	{id=712, attr="maxMC", name="最大魔法攻击力", intelligence=3300, career=local_career.career_7, display=10003},
	{id=713, attr="MagicDamage", name="魔法伤害", career=local_career.career_7, display=10003},
	{id=714, attr="hudunValue", name="护盾值（SD）", strength=12000, agility=12000, intelligence=12000, stamina=12000, another=local_another.another_2, career=local_career.career_7, display=-1},
	{id=715, attr="agValue", name="技能值（AG）", strength=2000, agility=4000, intelligence=3000, stamina=2000, career=local_career.career_7, display=-1},
	{id=716, attr="HPFieldRecoverPer", name="每3秒固定回复生命", stamina=1000, career=local_career.career_7, display=10004},
	{id=717, attr="magicrecoveryspeed", name="每3秒固定回复魔力", career=local_career.career_7, display=10004},
	{id=718, attr="agAutomaticReply", name="每3秒固定回复AG值", stamina=2500, career=local_career.career_7, display=-1},
	{id=720, attr="skillDamagPro", name="职业技能攻击力提升比例", intelligence=2, career=local_career.career_7, display=10003},
}

local defaults = {attr="minDC", name="PVE攻击率", strength=0, agility=0, intelligence=0, stamina=0, command=0, another={}, career={{5,1},{5,2},{5,3},{5,4}}, display=10002}
local mt = {__index = defaults}
for _, v in ipairs(cfg_att_conversion) do
	setmetatable(v, mt)
end

return cfg_att_conversion