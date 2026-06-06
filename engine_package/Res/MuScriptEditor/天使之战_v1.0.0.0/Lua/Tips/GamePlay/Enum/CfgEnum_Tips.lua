---@class EEquipSlotType
EEquipSlotType = {
    None = enum(0),
    Weapon = enum(1), -- 武器
    OffHandWeapon = enum(2), -- 副手
    TwoHandWeapon = enum(3), -- 双手武器
    Helmet = enum(4), -- 头盔
    Armor = enum(5), -- 衣服
    Glove = enum(6), -- 手套
    Pant = enum(7), -- 裤子
    Boot = enum(8), -- 鞋子
    Necklace = enum(9), -- 项链
    LeftEarring = enum(10), -- 左耳环
    RightEarring = enum(11), -- 右耳环
    LeftRing = enum(12), -- 左戒指
    RightRing = enum(13), -- 右戒指
    Wing = enum(14), -- 翅膀
    Guard = enum(15), -- 守护
    LeftArtifact = enum(16), --左神器
    RightArtifact = enum(17), --右神器
    Banner = enum(18), --旗帜
    PriestHawk = enum(19), --天鹰

    ArchangelWeapon = enum(71), -- 天使武器
    ArchangelOffHandWeapon = enum(72), -- 天使副手
    ArchangelTwoHandWeapon = enum(73), -- 天使双手武器
    ArchangelHelmet = enum(74), -- 天使头盔
    ArchangelArmor = enum(75), -- 天使衣服
    ArchangelGlove = enum(76), -- 天使手套
    ArchangelPant = enum(77), -- 天使裤子
    ArchangelBoot = enum(78), -- 天使鞋子

    FashionWeapon = enum(101), -- 时装主手武器
    FashionOffHandWeapon = enum(102), -- 时装副手武器
    FashionTwoHandWeapon = enum(103), -- 时装双手武器
    FashionHelmet = enum(104), -- 时装头盔
    FashionArmor = enum(105), -- 时装铠甲
    FashionGlove = enum(106), -- 时装护手
    FashionPant = enum(107), -- 时装护腿
    FashionBoot = enum(108), -- 时装鞋子
    FashionNecklace = enum(109), -- 时装项链
    FashionLeftEarring = enum(110), -- 时装左耳环
    FashionRightEarring = enum(111), -- 时装右耳环
    FashionLeftRing = enum(112), -- 时装左戒指
    FashionRightRing = enum(113), -- 时装右戒指
    FashionWing = enum(114), -- 时装翅膀
    FashionGuard = enum(115), -- 时装守护
    FashionTotalArmor = enum(116), --时装全身

}

--101：时装主手武器，102：时装副手武器，103：双手武器，104：时装头盔，105：时装铠甲，106：时装护手
--，107：时装护腿，108：时装鞋子，109：时装项链，110：时装左耳环，111：时装右耳环，112：时装左戒指，113：时装右耳环，114：时装翅膀，115：时装守护

---@class PosEquipType
PosEquipType = {
    None = enum(0),
    LeftWeapon = enum(1), --左手武器
    Armor = enum(2), --衣服
    Glove = enum(3), --手套
    Pant = enum(4), -- 裤子
    Boot = enum(5), -- 鞋子
    Helmet = enum(6), -- 头盔
    RightWeapon = enum(7), --右手武器
    LeftRing = enum(8), -- 左戒指
    RightRing = enum(9), -- 右戒指
    LeftEarring = enum(10), -- 左耳环
    RightEarring = enum(11), -- 右耳环
    Necklace = enum(12), -- 项链
    Wing = enum(13), -- 翅膀
    Guard = enum(14), --守护
    LeftArtifact = enum(16), --左神器
    RightArtifact = enum(17), --右神器
}

---@class PosEquip
PosEquip = {
    [PosEquipType.None] = EEquipSlotType.None,
    [PosEquipType.LeftWeapon] = EEquipSlotType.Weapon,
    [PosEquipType.Armor] = EEquipSlotType.Armor,
    [PosEquipType.Glove] = EEquipSlotType.Glove,
    [PosEquipType.Pant] = EEquipSlotType.Pant,
    [PosEquipType.Helmet] = EEquipSlotType.Helmet,
    [PosEquipType.RightWeapon] = EEquipSlotType.OffHandWeapon,
    [PosEquipType.LeftRing] = EEquipSlotType.LeftRing,
    [PosEquipType.RightRing] = EEquipSlotType.RightRing,
    [PosEquipType.LeftEarring] = EEquipSlotType.LeftEarring,
    [PosEquipType.RightEarring] = EEquipSlotType.RightEarring,
    [PosEquipType.Necklace] = EEquipSlotType.Necklace,
    [PosEquipType.Wing] = EEquipSlotType.Wing,
    [PosEquipType.LeftArtifact] = EEquipSlotType.LeftArtifact,
    [PosEquipType.RightArtifact] = EEquipSlotType.RightArtifact,
}

---交易行额外分类
---@class EItemTypeExt
EItemTypeExt = {
    All = enum(0),
    Public = enum(100),
    PreBuy = enum(101),
    MinePreBuy = enum(100000)
}

---@class EAttrRemarkType
EAttrRemarkType = {
    None = enum(0),
    Number = enum(1),
    Dimi = enum(2), -- 万分比
    Percentage = enum(3), -- 百分比（策划废弃了该字段，相关逻辑先进行注释）
}

---@class EShaderType
EShaderType = {
    Normal = 0, --ColorSet
    ColorAdd = 1, --ColorAdd
    ColorScreen = 2, --ColorScreen
}

---@class MUEResourceType
MUEResourceType = {
    GoldMoney = enum(10010001), -- 金币
    MiracleCurrency = enum(10020001), -- 奇迹币
    BindMiracleCurrency = enum(10030001), -- 绑定奇迹币
    DiaMond = enum(10040001), -- 钻石
    BindDiaMond = enum(10050001), -- 绑定钻石
    VipPoint = enum(10130001), -- 会员精华
    Exp = 10080001, --经验
    UnionExp = 10090001, --战盟经验
    UnionGx = 10120001, --战盟贡献
    UnionMoney = 10100001, --战盟资金

    ----item 未配置----
    MeltingPoint = enum(10050002), -- 熔炉点
    WelfareDiamond = enum(10070002), -- 福利钻石
    Token = enum(10080002), -- 代币
    Prestige = enum(10990001), -- 声望
    UnionPrestige = 10030003, -- 战盟声望（这里咋还用enum？）
    WarStageExp = 11000003, --战阶经验
    PartnerExp = 11000002, -- 伙伴经验值
    TalentExp = 10090002, --天赋经验
    LastDayActivity = 10980001, --活跃度
    UnionBadge = 10030004, --战盟徽章
    DispatchValue = 100008001, --派遣积分
    PinkDiamond = 10070002, ---粉钻
    UnionCoin = 100005001, --战盟币
    WelfareDiamond = enum(10070002), -- 福利钻石
    ArchangelWelfareCoin = enum(10210001), -- 大天使福利积分
}

---@class EResourceTypeIndex @货币资源图片索引
EResourceTypeIndex = {
    [MUEResourceType.GoldMoney] = 1, -- 金币
    [MUEResourceType.MiracleCurrency] = 2, -- 奇迹币
    [MUEResourceType.BindMiracleCurrency] = 3, -- 绑定奇迹币
    [MUEResourceType.DiaMond] = 4, -- 钻石
    [MUEResourceType.MeltingPoint] = 5, -- 熔炉点
    [MUEResourceType.BindDiaMond] = 6, -- 绑定钻石
    [MUEResourceType.WelfareDiamond] = 7, -- 福利钻石
}

---@class EItemSubType_Equip
EItemSubType_Equip = {
    None = 0,
    MainWeapon = 1, --主手武器
    SecWeapon = 2, --副手武器
    MainSecWeapon = 3, --主副手武器
    TouKun = 4, --头盔
    MianJin = 5, --面巾
    Cloth = 6, --铠甲
    Hushou = 7, --护手
    HuTui = 8, --护腿
    XieZi = 9, --鞋子
    XiangLian = 10, --项链
    JieZhi = 11, --戒指
    ErHuan = 12, --耳环
    ChiBang = 13, --翅膀
    ShouHu = 14, --守护
    Title = 15, --称号
    ZuoQi = 16, --坐骑
    VipBadge = 17, --会员徽记
    PriestHawk = 18, --天鹰
    PriestHorse = 19, --黑王
    SuitBody = 20, --时装全身套装，
    Archangel = 22, --大天使
    FashionWeapon = 101, --时装武器
    FashionSecWeapon = 102, --时装副手
    FashionHelmet = 104, --时装头盔
    FashionFaceTowel = 105, --时装面巾
    FashionArmor = 106, --时装衣服
    FashionGlove = 107, --时装手套
    FashionPant = 108, --时装护腿
    FashionBoot = 109, --时装鞋子
}
--装备部位：1=臂章2=盔甲3=斧头4=书本5=鞋子6=弓7=弩8=耳坠9=手套10=头像11=头盔12=狼牙棒13=坐骑14=项链15=裤子16=指环17=影子18=盾牌
--19=长矛20=权杖21=刀22=翅膀23=身体骨骼24=物品道具25=货币101=单手剑102=双手剑103=单手斧104=双手斧105=单手杖106=双手杖111=权杖114=弓箭袋115=弩箭袋
---@class EModelCharactorPart
EModelCharactorPart = {
    None = 0,
    BiZhang = 1,
    KuiJia = 2,
    FuTou = 3,
    ShuBen = 4,
    XieZi = 5,
    Gong = 6,
    Nu = 7,
    ErZui = 8,
    ShouTao = 9,
    TouXiang = 10,
    TouKui = 11,
    LangYaBang = 12,
    ZuoQi = 13,
    XiangLian = 14,
    KuZi = 15,
    ZhiHuan = 16,
    YingZi = 17,
    DunPai = 18,
    ChangMao = 19,
    QuanZhang = 20,
    Dao = 21,
    ChiBang = 22,
    ShengTiGuGe = 23,
    WuPingDaoJu = 24,
    HuoBi = 25,
    DanShouJian = 101,
    ShuangShouJian = 102,
    DanShouFu = 103,
    ShuangShouFu = 104,
    DanShouZhang = 105,
    ShuangShouZhang = 106,
    QuanZhang = 111,
    GongJianDai = 114,
    NuJianDai = 115,
}
---@class EEquipSlotName
EEquipSlotName = {

    [EItemSubType_Equip.MainWeapon] = "主手武器",
    [EItemSubType_Equip.SecWeapon] = "副手武器",
    [EItemSubType_Equip.MainSecWeapon] = "主副手武器",
    [EItemSubType_Equip.TouKun] = "头盔",
    [EItemSubType_Equip.MianJin] = "面巾",
    [EItemSubType_Equip.Cloth] = "铠甲",
    [EItemSubType_Equip.Hushou] = "护手",
    [EItemSubType_Equip.HuTui] = "护腿",
    [EItemSubType_Equip.XieZi] = "鞋子",
    [EItemSubType_Equip.XiangLian] = "项链",
    [EItemSubType_Equip.JieZhi] = "戒指",
    [EItemSubType_Equip.ErHuan] = "耳环",
    [EItemSubType_Equip.ChiBang] = "翅膀",
    [EItemSubType_Equip.ShouHu] = "守护",
    [EItemSubType_Equip.Title] = "称号",
    [EItemSubType_Equip.ZuoQi] = "坐骑",
    [EItemSubType_Equip.VipBadge] = "会员徽记",
    [EItemSubType_Equip.PriestHawk] = "天鹰",
    [EItemSubType_Equip.PriestHorse] = "黑王",
    [EItemSubType_Equip.SuitBody] = "套装",
}

--1：主手武器
--2：副手武器
--3：双手武器
--4：头盔
--7：衣服
--8：护手
--10：护腿
--11：鞋子
--20：项链
--21：耳环
--28：守护
--25：戒指
--49：翅膀
---@class EEquipStrPartName
EEquipStrPartName = {
    [EEquipSlotType.Weapon] = "主手武器",
    [EEquipSlotType.OffHandWeapon] = "副手武器",
    [EEquipSlotType.TwoHandWeapon] = "双手武器",
    [EEquipSlotType.Helmet] = "头盔",
    [EEquipSlotType.Armor] = "衣服",
    [EEquipSlotType.Glove] = "护手",
    [EEquipSlotType.Pant] = "护腿",
    [EEquipSlotType.Boot] = "鞋子",
    [EEquipSlotType.Necklace] = "项链",
    [EEquipSlotType.RightEarring] = "右耳环",
    [EEquipSlotType.LeftEarring] = "左耳环",
    [EEquipSlotType.Guard] = "守护",
    [EEquipSlotType.LeftRing] = "左戒指",
    [EEquipSlotType.RightRing] = "右戒指",
    [EEquipSlotType.Wing] = "翅膀",
}

---@class EMUCharacterAttrType
EMUCharacterAttrType = {
    strength = 10001, -- 力量
    agility = 10002, -- 敏捷
    intelligence = 10003, -- 智力
    spirit = 10004, -- 体力
    maxDC = 201011, -- 攻击上限
    minDC = 201021, -- 攻击下限
    maxMC = 202011, -- 魔攻上限
    minMC = 202021, -- 魔攻下限
    minSC = 9, -- 道术下限 --无用
    maxSC = 10, -- 道术上限 --无用
    minZuZhou = 205011, -- 诅咒下限
    maxZuZhou = 205021, -- 诅咒上限
    armor = 206011, -- 防御力
    maxHp = 207011, -- 最大生命值
    maxMp = 208011, -- 最大魔法值
    missRate = 211011, -- 防御率
    hitRate = 209011, -- 攻击率
    luckHit = 28, -- 幸运一击 --无用
    damageIncreaseRate = 311112, -- 伤害加成
    atkSpeed = 213022, -- 攻速加成
    moveSpeed = 318022, -- 移速加成
    lead = 10005, -- 统帅 和表格名字有出入
    AniSpeed = 213011, --动画时间（服务器计算）+同时参与主角CD时间计算
    CDReduce = 321012, --cd冷却缩减  

}


--药品类型
---@class EDrugType
EDrugType = {
    ContinueHeal = enum(1), --持续回复
    MomentHeal = enum(2), --瞬间回复
    Gain = enum(3), --增益道具
    Other = enum(7), --其他消耗品
    ExpPotion = enum(9), --经验药水
}
---@class EDrugTypeStr
EDrugTypeStr = {
    [EDrugType.ContinueHeal] = "持续回复",
    [EDrugType.MomentHeal] = "瞬间回复",
    [EDrugType.Gain] = "增益道具",
    --[EDrugType.ContinueHealHP] = "持续回血",
    --[EDrugType.ContinueHealMP] = "持续回蓝",
    --[EDrugType.ContinueHealHPMP] = "持续回血回蓝",
    --[EDrugType.MomentHealHP] = "瞬间回血",
    --[EDrugType.MomentHealMP] = "瞬间回蓝",
    --[EDrugType.MomentHealHPMP] = "瞬间回血回蓝",
    [EDrugType.Other] = "其他消耗品",
    [EDrugType.ExpPotion] = "经验药水",
}

---0=不在活动的提示弹窗内显示
---1=在活动的提示弹窗内显示
---@class EActivityRuleIsShowPop
EActivityRuleIsShowPop = {
    NotShowInPop = 0,
    ShowInPop = 1,
}
----1=活动进行中
----2=活动预告中
---@class EListDataType
EListDataType = {
    ActivityList = 1,
    AnnounceList = 2,
}

--技能书类型
---@class ESkillBookType
ESkillBookType = {
    Player = enum(1), --玩家技能书
    Monster = enum(2), --怪物技能书
}
---@class ESkillBookTypeStr
ESkillBookTypeStr = {
    [ESkillBookType.Player] = "玩家技能书",
    [ESkillBookType.Monster] = "怪物技能书",
}

--宝箱类型
---@class EBoxType
EBoxType = {
    Random = enum(1), --随机宝箱
    SelfSelectBox = enum(2), -- 自选宝箱
}
---@class EBoxTypeStr
EBoxTypeStr = {
    [EBoxType.Random] = "随机宝箱",
    [EBoxType.SelfSelectBox] = "自选宝箱",
}

--快捷使用类型
---@class EShortcutUserType
EShortcutUserType = {
    AttrPos = enum(1), --属性点
    NormalBox = enum(2), --技能书等正常道具
    WearEquip = enum(3), --可穿戴装备
    NoWearEquip = enum(4), --装备不符合穿戴条件
}

--快捷使用类型描述
---@class EShortcutUserTypeStr
EShortcutUserTypeStr = {
    [EShortcutUserType.AttrPos] = "立即加点",
    [EShortcutUserType.NormalBox] = "立即使用",
    [EShortcutUserType.WearEquip] = "立即装备",
    [EShortcutUserType.NoWearEquip] = "打开背包",
}


--材料类型
---@class EMaterialsType
EMaterialsType = {
    Ticket = enum(1), --门票
    TaskItem = enum(2), --任务道具
    GemCraft = enum(3), --宝石合成材料
    Other = enum(4), --其他材料
}
---@class EMaterialsTypeStr
EMaterialsTypeStr = {
    [EMaterialsType.Ticket] = "门票",
    [EMaterialsType.TaskItem] = "任务道具",
    [EMaterialsType.GemCraft] = "宝石合成材料",
    [EMaterialsType.Other] = "其他材料",
}

---@class EItemType
EItemType = {
    None = enum(0),
    Coin = enum(1),
    Equip = enum(2),
    Medicine = enum(3),
    Box = enum(4),
    Materials = enum(5),
    TriggerItem = enum(6),
    SkillBook = enum(7),
}

--触发类物品
---@class ETriggerItemType
ETriggerItemType = {
    RandomStone = enum(1), --随机传送石
    AppointStone = enum(2), --指定传送石
    SkillBook = enum(3), --技能书
    ActivityAddTimeProp = enum(4), --活动次数增加道具
    TransformProp = enum(5), --转职转换道具
    BagExpansion = enum(6), --背包扩展道具
    StoreExpansion = enum(7), --仓库扩展道具
    UnLockCareer = enum(8), --解锁职业
    AttributePointTrans = enum(9), --属性点重置道具
    Trepanning = enum(10), --开孔
    RemoveItemCount = enum(11), --消除道具数量

    LimitExperience = enum(13), --限时经验丹道具
    SummonMonsters = enum(15), --召唤怪物
    Sponsor = enum(16), --赞助
    ThankLetter = enum(99), --感谢信
}

---@class ETriggerItemTypeStr
ETriggerItemTypeStr = {
    [ETriggerItemType.RandomStone] = "随机传送石",
    [ETriggerItemType.AppointStone] = "指定传送石",
    [ETriggerItemType.SkillBook] = "技能书",
    [ETriggerItemType.ActivityAddTimeProp] = "活动次数增加道具",
    [ETriggerItemType.TransformProp] = "转职转换道具",
    [ETriggerItemType.BagExpansion] = "背包扩展道具",
    [ETriggerItemType.StoreExpansion] = "仓库扩展道具",
    [ETriggerItemType.UnLockCareer] = "解锁职业",
    [ETriggerItemType.AttributePointTrans] = "属性点重置道具",
}


--货币类型
---@class ECurrencyType
ECurrencyType = {
    Gold = enum(1), --金币
    QJCoin = enum(2), --奇迹币
    BoundQJCoin = enum(3), --绑定奇迹币
    Diamond = enum(4), --钻石
    BoundDiamond = enum(5), --绑定钻石
    Attribute = enum(6), --属性值
    DistributableAttribute = enum(7), --可分配属性值
    Exp = enum(8), --经验

    GradResources = enum(94), --战盟资源
    GradMoney = enum(95), --战盟资金
    GradExp = enum(96), --战盟经验
    Energy = enum(97), --活力
    Reputation = enum(98), --声望
}

---@class EEquipSuitType
EEquipSuitType = {
    EquipSuit = enum(0), -- 装备套装
    FashionSuit = enum(1), -- 时装套装
    AddSuit = enum(2), --叠加套装
}

---@class ECurrencyTypeStr
ECurrencyTypeStr = {
    [ECurrencyType.Gold] = "金币", --金币
    [ECurrencyType.QJCoin] = "奇迹币", --奇迹币
    [ECurrencyType.BoundQJCoin] = "绑定奇迹币", --绑定奇迹币
    [ECurrencyType.Diamond] = "钻石", --钻石
    [ECurrencyType.BoundDiamond] = "绑定钻石", --绑定钻石
    [ECurrencyType.Attribute] = "属性值", --属性值
    --[ECurrencyType.Token] = "代币", --代币
    [ECurrencyType.GradResources] = "战盟资源", --战盟资源
    [ECurrencyType.GradMoney] = "战盟资金", --战盟资金
    [ECurrencyType.GradExp] = "战盟经验", --战盟经验
    [ECurrencyType.Energy] = "活力", --活力
    [ECurrencyType.Reputation] = "声望", --声望
}

---@class ItemTypeTable
ItemTypeTable = {
    [EItemType.Coin] = ECurrencyType,
    [EItemType.Equip] = EItemSubType_Equip,
    [EItemType.Medicine] = EDrugType,
    [EItemType.SkillBook] = ESkillBookType,
    [EItemType.Box] = EBoxType,
    [EItemType.Materials] = EMaterialsType,
    [EItemType.TriggerItem] = ETriggerItemType,
}

---@class ItemTypeStrTable
ItemTypeStrTable = {
    [EItemType.Coin] = ECurrencyTypeStr,
    [EItemType.Equip] = EEquipSlotName,
    [EItemType.Medicine] = EDrugTypeStr,
    [EItemType.SkillBook] = ESkillBookTypeStr,
    [EItemType.Box] = EBoxTypeStr,
    [EItemType.Materials] = EMaterialsTypeStr,
    [EItemType.TriggerItem] = ETriggerItemTypeStr,
}


---@class EItemTypeName
EItemTypeName = {
    [EItemType.Coin] = "货币",
    [EItemType.Equip] = "装备",
    [EItemType.Medicine] = "药品",
    [EItemType.SkillBook] = "技能书",
    [EItemType.Box] = "宝箱",
    [EItemType.Materials] = "材料",
    [EItemType.TriggerItem] = "触发类物品",
    [EItemTypeExt.Public] = "公示区",
    [EItemTypeExt.PreBuy] = "预购",
    [EItemTypeExt.All] = "全部",
    [EItemTypeExt.MinePreBuy] = "我的预购",
}

---@class EStartPointRangeType
EStartPointRangeType = {
    None = 0,
    Safe = 1,
    BuffArea = 2,
}

---@class EMasterInfoType
EMasterInfoType = {
    AddProp = 1, --增加属性
    StrongSkillHurtOrBuffOrGetSkill = 2, --增加技能伤害或者Buff伤害或获得一个技能
    DurableDec = 3, --耐久度减少
}

---@class EMasterInfoSubType_Skill
EMasterInfoSubType_Skill = {
    Hurt = 1,
    Buff = 2,
    GetSkill = 3,
}

---@class ESafeZoneType
ESafeZoneType = {
    None = 0,
    SafeArea = 1,
    NotSafeArea = 2,
}

---@class EVersionControl
EVersionControl = {
    GlobalTblID = 72, --对应cfg_global表id
    EngineVersion = 1, --引擎版本
    OriginalVersion = 2, --原始版本
}

---@class EEquipMasterType
EEquipMasterType = {
    StarMaster = enum(1), -- 星级大师
    StrengthMaster = enum(2), -- 强化大师
    AppendMaster = enum(3), -- 追加大师
}

---@class EEquipMasterCountType
EEquipMasterCountType = {
    Total = enum(0), -- 计算部位总和等级
    Part = enum(1) -- 计算每个部位等级
}
---@class EFreeBuffAddType
EFreeBuffAddType = {
    GlodDrop = 1, --金币掉落加成
    Exp = 2, --经验加成
    MoveSpeed = 3, --移速加成
    ItemRecycleGlod = 4, --道具回收金币加成
    EquipCrit = 5, --装备爆率加成
    monsterExp = 6, --击杀小怪经验加成
}

---@class EProportion
EProportion = {
    Value = 1, --数值
    ThousandTimesThan = 2, --万分比
    ThePercentage = 3, --百分比
}

---@class EVersionGlobalPostTypeType
EVersionGlobalPostTypeType = {
    Analysis = enum(1), -- 解析的
    Bool = enum(2), -- 布尔
    Number = enum(3), -- 数字
    String = enum(4), -- 字符串
    IntList = enum(5), --intList 和CSV格式一致
    StringList = enum(6),
}

---@class EGemTypeType
EGemTypeType = {
    Attack = enum(1),
    Def = enum(2),
}

---@class EGemSubTypeType
EGemSubTypeType = {
    Normal = enum(1),
    Good = enum(2),
    Rare = enum(3),
    ShiShi = enum(4),
    ChuanShuo = enum(5),
}

---@class SkillAssistTypeEx
SkillAssistTypeEx = {
    Single = enum(1), --单体
    Group = enum(), --群体
    Common = enum(), -- 公共
    General = enum(), -- 通用
}

---@class ETaskGoalType
ETaskGoalType = {
    GetItem = enum(1),
    KillMonster = enum(2),
    MapMove = enum(3),
    Talk = enum(4),
    Level = enum(5),
    UseItem = enum(6),
    Wear = enum(10),
    StudySkill = enum(61) 
}

---@class SubSkillAssistTypeEx
SubSkillAssistTypeEx = {
    Buff = enum(1), --状态
    Summon = enum(), --召唤
    Cure = enum(), -- 治疗
    Move = enum(), -- 移动
    Damage = enum(), -- 伤害技能
}

---@class EItemID
EItemID = {
    RoleNameChangeCard = 700100016, -- 角色改名卡
    UnionNameChangeCard = 700100017, -- 战盟改名卡
}

---@class EEquipWearBarType
EEquipWearBarType = {
    BaseEquip = enum(1), --基础穿戴栏
    ShengDaoShi = enum(2), --圣导师穿戴栏
    Angel = enum(3), --大天使l
    Freya = enum(4), --芙蕾雅
    Honor = enum(5), --荣誉套装
    Splendor = enum(6), --辉煌套装
    Archange = enum(9), --大天使装备
}