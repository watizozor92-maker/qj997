-- 此文件工具自动生成，不要修改
---@class cfg_character_create_column
---填写根职业id
---@field id number @唯一id column=1 A
---@field name string @职业名称 column=2 B
---该服务器角色等级限制
---不填则无此限制
---@field conditionLv number @创角等级不能写否则报错 column=3 C
---创角界面显示内容
---@field conditionsText string @创角条件文本说明 column=4 D
---解锁存在限制条件的价格，货币：RMB，单位：元
---@field price number @超前解锁价格 column=5 E
---工程内具体对应资源路径
---@field path string @模型文件 column=6 F
---@field image string @图片名称 column=7 G
---显示于角色界面主属性
---格式：属性id；读取cfg_att_info/id
---@field primaryAttribute number @职业主属性 column=8 H
---\n换行，文本居中显示
---@field description string @职业说明 column=9 I
---0=不显示；1=显示
---@field isShow number @显示创建 column=10 J
---x#y#z
---@field modelPosition string @位置 column=11 K
---x#y#z
---@field modelRotation string @旋转 column=12 L
---x#y#z
---@field modelScale string @大小 column=13 M
---仅策划用：
---文件名称为1+根职业id
---资源地址svn://192.168.10.123/712_2.0_XW/Client/Project/712_2.0/Assets/Art/AtlasRes/Sprites/MUIcon
---@field icon number @头像 column=14 N
---角色创建时所在的地点
---格式：地图id#X坐标#Y坐标
---@field set IntList @初生点配置 column=15 O
---格式：道具id#修正id|道具id#修正id
---道具id读取cfg_item/id
---修正id读取cfg_equip_correct/id
---@field wearEquip IntListList @初始装备穿戴 column=16 P
---格式：技能id#技能等级技能id#技能等级
---引援skill表技能id
---@field skill IntListList @初始技能 column=17 Q
---创角展示模型；格式：模型id#模型id，读取cfg_model_charactor表id；展示部位骨骼、头部、身体、手部、腿部、鞋子，注意模型部位不能相同
---@field showModel IntList @展示模型 column=18 R
---创角展示技能，目前界面预留两个技能展示界面，超出不显示；引援cfg_skill_info表id
---@field showSkill IntList @展示技能 column=19 S
---仓角列表图标；填写图标文件名称
---@field listIcon string @列表图标 column=20 T
---格式：属性id#属性id；展示顺序根据配置顺序
---属性id读取cfg_att_info/id
---@field attShow IntList @属性展示 column=21 U
---创角时是否解锁该职业的创建
---0：不解锁
---1：解锁
---@field unlock number @创建解锁 column=22 V
---需要填1
---@field unlockbutton number @角色卡解锁 column=23 W
---@field unlockLv number @角色等级限制 column=24 X

local local_set = {
    set_1={1001,124,125},

}

local local_wearEquip = {
    wearEquip_1={{20310111,0},{20220111,0}},
    wearEquip_2={},

}

local local_skill = {
    skill_1={},

}

local local_showModel = {
    showModel_1={},

}

local local_showSkill = {
    showSkill_1={},

}

local local_attShow = {
    attShow_1={10001,10002,10003,10004},

}

local cfg_character_create =
{
	{id=1, name="Dark Knight", conditionsText="", path="Model/Face/newface02", primaryAttribute=1, description="ThekingdomofwarriorsdescendantsofbraveheroesAmeleeorientedclassbuiltonformidablephysicalstrengthandswordsmanshipCapableofwieldingavarietyofweaponsincludingswordsaxesandpolearms KingdomofmagiciansbackerofArkaEndowedwithpowerfulmanaabletocastoffensivemagicfreely", icon=11, wearEquip={{20310111,0}}, showSkill={1011001,1011012}, listIcon="swordMan", unlockbutton=0, unlockLv=0},
	{id=2, name="Dark Wizard", conditionsText="", path="Model/Face/newface01", image="txt_magic", primaryAttribute=3, description="KingdomofmagiciansbackerofArkaEndowedwithpowerfulmanaabletocastoffensivemagicfreely", modelPosition="-86#-175#100", modelRotation="0#218#0", icon=12, wearEquip=local_wearEquip.wearEquip_2, showModel={20230002,20110204,20020187,20090174,20150172,20050214}, showSkill={1012001,1012014}, listIcon="magic", unlockbutton=0, unlockLv=0},
	{id=3, name="Fairy Elf", conditionsText="", path="Model/Face/newface03", image="txt_archer", primaryAttribute=2, description="KingdomofElvesdwellersofNoriaTheirprimaryweaponsarebowsandcrossbowsWheninpartiestheirsupportandsummoningmagicplayanextraordinaryrole", modelPosition="-67#-189#100", modelRotation="0#180#0", modelScale="1650#1650#1650", icon=13, set={1004,180,120}, wearEquip={{20130111,0},{3000104,0}}, showModel={20230003,20110205,20020188,20090175,20150173,20050215}, showSkill={1013001,1013002}, listIcon="archer", unlockbutton=0, unlockLv=0},
	{id=4, name="Magic Gladiator", conditionsText="角色达到220级解锁/角色卡解锁", path="Model/Face/newface04", description="AhybridtypeclasspossessingthecourageofwarriorsandthewisdomofmagiciansItcanperformmeleeattacksaswellasfreelycastvariouskindsofmagic", modelPosition="-60#-150#100", modelRotation="0#192#0", icon=14, showModel=local_showModel.showModel_1, unlockLv=220},
	{id=5, name="Dark Lord", conditionsText="角色达到280级解锁/角色卡解锁", path="Model/Face/newface05", description="AmonarchstyleclasswithpowerfulcharismaItorganizespartieswithsupremeleadershipaccompaniedbypetsDarkHawkandBlackKingHorsethatassistincombat", modelPosition="-60#-160#100", modelRotation="0#-160#0", icon=15, showModel=local_showModel.showModel_1, unlockLv=280},
	{id=6, name="Summoner", conditionsText="角色达到380级解锁/角色卡解锁", path="Model/Face/newface06", description="Wieldingcursemagicwithpowerfulspiritandinsightitcansummonotherworldlycreaturestocastformidablespells", modelPosition="-60#-180#100", modelRotation="0#180#0", modelScale="1650#1650#1650", icon=16, set={1052,47,225}, showModel=local_showModel.showModel_1, unlockLv=380},
	{id=7, name="Light Wizard", conditionsText="角色卡解锁", path="Model/Face/newface01_guangming", description="PossessingthetraitsofbothLightMageandHolyScholarblessedwithakindandimpartialmindSpecializesinlongrangecombatandlightattributemagic", icon=12, wearEquip=local_wearEquip.wearEquip_2, showModel={20020017,20050017,20090022,20110080,20150057}, unlockLv=999},
}

local defaults = {conditionLv=0, price=0, image="txt_swordMan", primaryAttribute=0, isShow=1, modelPosition="-68#-160#100", modelRotation="0#-173#0", modelScale="1000#1000#1000", set={1001,124,125}, wearEquip={{20310111,0},{20220111,0}}, skill={}, showModel={20230001,20110203,20020186,20090173,20150171,20050213}, showSkill={}, listIcon="", attShow={10001,10002,10003,10004}, unlock=1, unlockbutton=1}
local mt = {__index = defaults}
for _, v in ipairs(cfg_character_create) do
	setmetatable(v, mt)
end

return cfg_character_create