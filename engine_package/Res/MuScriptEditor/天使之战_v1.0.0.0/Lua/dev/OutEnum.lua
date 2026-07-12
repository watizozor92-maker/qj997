---@class E_FashionType
E_FashionType = {
    Appear = 1, --外观
    Title = 2, --称号
    TransferRing = 3, --首饰盒
    Change = 4, --幻化
    Render = 5, --染色
}

---@class E_TitleTimeType
E_TitleTimeType = {
    NotLimit = 1, ---1不限时 
    Limit = 2, ---2限时 
    UntilNext = 3, ---3持续到下次该活动开启
    Realtime = 4, ---4 排行榜实时刷新
}

---@class E_TitleBelong
E_TitleBelong = {
    Role = 1, ---1角色归属
    Account = 2, ---2账号归属
}

---@class E_AppearEquipType
E_AppearEquipType = {
    Weapon = enum(1), -- 武器
    OffHandWeapon = enum(), -- 副手
    TwoHandWeapon = enum(), -- 双手武器
    Helmet = enum(), -- 头盔
    Armor = enum(), -- 铠甲
    Glove = enum(), -- 护手
    Pant = enum(), -- 护腿
    Boot = enum(), -- 鞋子
    Guard = enum(), --守护
    Wing = enum(), --翅膀
    SuitBody = enum(), --时装全身套装
}
---@class E_JewelryEquipType
E_JewelryEquipType = {
    Necklace = enum(9), -- 项链
    LeftEarring = enum(10), --左耳环
    RightEarring = enum(11), -- 右耳环
    LeftRing = enum(12), -- 左戒指
    RightRing = enum(13), -- 右戒指
}
---@class E_AppearTypeStr
E_AppearTypeStr = {
    [E_AppearEquipType.Weapon] = "主手武器",
    [E_AppearEquipType.OffHandWeapon] = "副手武器",
    [E_AppearEquipType.TwoHandWeapon] = "双手武器",
    [E_AppearEquipType.Helmet] = "头盔",
    [E_AppearEquipType.Armor] = "铠甲",
    [E_AppearEquipType.Glove] = "护手",
    [E_AppearEquipType.Pant] = "护腿",
    [E_AppearEquipType.Boot] = "鞋子",
    [E_AppearEquipType.Guard] = "守护",
    [E_AppearEquipType.Wing] = "翅膀",
    [E_AppearEquipType.SuitBody] = "时装全身套装",
}

---@class E_AppearSuitSlot
E_AppearSuitSlot = { E_AppearEquipType.Helmet, E_AppearEquipType.Armor, E_AppearEquipType.Glove, E_AppearEquipType.Pant, E_AppearEquipType.Boot }


---@class E_AppearType2StrPart
E_AppearType2StrPart = {
    [E_AppearEquipType.Weapon] = {
        EEquipSlotType.Weapon,
        EEquipSlotType.FashionWeapon,
        EEquipSlotType.ArchangelWeapon,
    },
    [E_AppearEquipType.OffHandWeapon] = {
        EEquipSlotType.OffHandWeapon,
        EEquipSlotType.FashionOffHandWeapon,
        EEquipSlotType.ArchangelOffHandWeapon,
    },
    [E_AppearEquipType.TwoHandWeapon] = {
        EEquipSlotType.TwoHandWeapon,
        EEquipSlotType.FashionTwoHandWeapon,
        EEquipSlotType.ArchangelTwoHandWeapon,
    },
    [E_AppearEquipType.Helmet] = {
        EEquipSlotType.Helmet,
        EEquipSlotType.FashionHelmet,
        EEquipSlotType.ArchangelHelmet,
    },
    [E_AppearEquipType.Armor] = {
        EEquipSlotType.Armor,
        EEquipSlotType.FashionArmor,
        EEquipSlotType.ArchangelArmor,
    },
    [E_AppearEquipType.Glove] = {
        EEquipSlotType.Glove,
        EEquipSlotType.FashionGlove,
        EEquipSlotType.ArchangelGlove,
    },
    [E_AppearEquipType.Pant] = {
        EEquipSlotType.Pant,
        EEquipSlotType.FashionPant,
        EEquipSlotType.ArchangelPant,
    },
    [E_AppearEquipType.Boot] = {
        EEquipSlotType.Boot,
        EEquipSlotType.FashionBoot,
        EEquipSlotType.ArchangelBoot,
    },
    [E_AppearEquipType.Guard] = {
        EEquipSlotType.Guard,
        EEquipSlotType.FashionGuard,
    },
    [E_AppearEquipType.Wing] = {
        EEquipSlotType.Wing,
        EEquipSlotType.FashionWing,
    },
    [E_AppearEquipType.SuitBody] = {
        EEquipSlotType.FashionTotalArmor,
    },
}

E_BagTileScrollViewType = {
    Strength = 10000,
    GemInLay = 10001,
}

---@class E_ItemType
E_ItemType = {
    None = enum(0),
    Coin = enum(1),
    Equip = enum(2),
    Medicine = enum(3),
    Box = enum(4),
    Materials = enum(5),
    TriggerItem = enum(6),
    SkillBook = enum(7),
}
---@class E_ItemSubType_Equip
E_ItemSubType_Equip = {
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
    FashionWeapon = 101, --时装武器
    FashionSecWeapon = 102, --时装副手
    FashionHelmet = 104, --时装头盔
    FashionFaceTowel = 105, --时装面巾
    FashionArmor = 106, --时装衣服
    FashionGlove = 107, --时装手套
    FashionPant = 108, --时装护腿
    FashionBoot = 109, --时装鞋子
    Mount = 10001, --坐骑
}

----开服活动页签
EOpenServerType = {
    BossKill = 10001, --BOSS首杀
    GoldBossKill = 10002, --黄金怪首杀
    StrengtPlacard = 20001, --强化冲榜
    SupplementPlacard = 20002, --追加冲榜
    EquipDropFirst = 20003, --装备首爆
    LevelAthletics = 20004, --等级竞技
    ExcellenceAthletics = 20005, --卓越竞技
    JewelryAthletics = 20006, --首饰竞技
}

---@class EActivityType
EActivityType = {
    DevilSquare = enum(10001), --恶魔广场
    BloodyCastle = enum(11001), --血色城堡
    FieryDragon = enum(13001), --血色城堡
    RedFort = enum(17001), --血色城堡
    PrivilegeBoss = enum(18001), --特权Boss
    WolfSoulFortress = enum(15001), --狼魂要塞
    QuintonInvasion = enum(21001), --昆顿
    LoranSiege = enum(16001), --罗兰攻城战
    BingFengBao = enum(28001), --冰风攻城战
}

ECrossServerActivityMapId = {
    QuintonInvasion = enum(21009), --昆顿
}

---@class E_OutTriggerItemType
E_OutTriggerItemType = {
    FriendLikeItem = 12, --好友亲密度道具
    GuardSkin = 13, --守护皮肤
    TransferRing = 14, --变身戒指
}

---@class EDuplicateType
EDuplicateType = {
    StartCopy = enum(1),
    FinishCopy = enum(2),
    DestroyCopy = enum(3),
}

---@class EDuplicateState @副本阶段
EDuplicateState = {
    ---准备阶段
    PREPARE = enum(1),
    ---战斗阶段
    FIGHT = enum(2),
    ---结算阶段
    FINISH = enum(3),
    ---副本销毁
    CLOSED = enum(4),
}

---@class EUnionLeaderOperateType
EUnionLeaderOperateType = {
    Election = 1, --竞选
    Campaign = 2, --弹劾
    Replace = 3     --取代
}

---@class EGuideShowType @新手引导显示方式
---@field Content number @1：文本+箭头
---@field Highlight number @2：控件高亮
---@field Mask number @3：黑幕
---@field ToProp number @4：指向道具
EGuideShowType = {
    Content = enum(1), ---1：文本+箭头
    Highlight = enum(), ---2：控件高亮
    Mask = enum(), ---3：黑幕
    ToProp = enum(), ---4：指向道具
}
---@class EnterLimitResultConst @新手引导显示方式
-- EnterLimitResultConst = {
--     ALLOW = enum(1), -- 允许
--     LEVEL = enum(2), -- 等级不足
--     COUNT = enum(3), -- 活动次数不足
--     ITEM = enum(4), -- 道具不足
--     REFUSE = enum(5), --拒绝
-- }
EnterLimitResultConst = {
    NONE = enum(0), -- 允许
    ALLOW = enum(1), -- 允许
    REFUSE = enum(2), --拒绝
    BREAK = enum(3), --解散
    CLOSED = enum(4) --关闭面板
    
}

---@class EGuideFinishType @新手引导步骤结束方式
---@field AnyClick number @2:点击任意地方
---@field ClickControl number @1:点击控件
EGuideFinishType = {
    AnyClick = enum(2), --点击任意地方
    ClickControl = enum(1), --点击控件
}

--请求修改组队状态
DupTeamChangeState = {
    READY = 1, --准备
    REFUSE = 2, --拒绝
    BREAK = 3, --解散
    CLOSED = 4  --关闭面板
}

---坐骑装备孔位
EMountEquipPos = {
    HeadPos = enum(51), --头
    NecklancePos = enum(52), --项圈
    FrontLegPos = enum(53), --前爪
    HindLegPos = enum(54), --后爪
    TailPos = enum(55), --尾巴
}

---坐骑tip类型
EMountTipType = {
    OtherUIOpen = enum(0), --其他UI打开
    BagUIOpen = enum(1), --背包打开
    StoreUIOpen = enum(2), --仓库打开
    MountUIOpen = enum(3), --坐骑UI打开
}

---大师之路页签类型
EMasterTalentType = {
    CAREER = enum(1), --职业天赋
    COMMON = enum(2), --通用天赋
    SKILL = enum(3), --技能天赋
    Archange = enum(4), --大天使天赋
    
}

---大师之路页签类型排序
EMasterTalentSortType = {
    [EMasterTalentType.Archange] = 1, --大天使天赋
    [EMasterTalentType.CAREER] = 2, --职业天赋
    [EMasterTalentType.COMMON] = 3, --通用天赋
    [EMasterTalentType.SKILL] = 4, --技能天赋
}

---大师之路页签ID
EMasterTalentSystemSwitchID = {
    [EMasterTalentType.Archange] = 11001, --大天使天赋
    [EMasterTalentType.SKILL] = 11002, --技能天赋
    [EMasterTalentType.COMMON] = 11003, --通用天赋
    [EMasterTalentType.CAREER] = 11004, --职业天赋
}

---大师之路页签名字
EMasterTalentName = {
    [EMasterTalentType.CAREER] = "职业天赋", --职业天赋
    [EMasterTalentType.SKILL] = "技能天赋", --技能天赋
    [EMasterTalentType.COMMON] = "通用天赋", --通用天赋
    [EMasterTalentType.Archange] = "大天使天赋", --大天使天赋
}

---大师之路页签对应界面
EMasterTalentPanelPath = {
    [EMasterTalentType.CAREER] = "dev/outui/MasterTalent/Panel/KLUICareerTalent/KLUICareerTalentPanel", --职业天赋
    [EMasterTalentType.SKILL] = "dev/outui/MasterTalent/Panel/KLUISkillTalent/KLUISkillTalentPanel", --技能天赋
    [EMasterTalentType.COMMON] = "dev/outui/MasterTalent/Panel/KLUICommonTalent/KLUICommonTalentPanel", --通用天赋
    [EMasterTalentType.Archange] = "dev/outui/Archangel/Panel/KLArchangelTalent/KLArchangelTalentPanel", --大天使天赋
}

---大师之路页签对应背景图片路径
EMasterTalentPanelBGStr = {
    [EMasterTalentType.CAREER] = "Texture/bg_CareerTalent.png", --职业天赋
    [EMasterTalentType.SKILL] = "Texture/bg_SkillTalent.png", --技能天赋
    [EMasterTalentType.COMMON] = "Texture/bg_CommonTalent.png", --通用天赋
    [EMasterTalentType.Archange] = "Texture/img_lizhan.png", --大天使天赋
}
---@class PopoverType
PopoverType = {
    Tip_efficiency = 1,
    Tip_auction = 2,
    Tip_mail = 3,
    Tip_testimonial = 4,
    Tip_brave_trials = 5,
    Tip_partner_incubation = 6,
    Tip_partner_dispatch = 7,
    Tip_fashion = 8,
    Tip_attribute = 9,
    Tip_assist = 10,
    Tip_equipment_replacement = 11,
    Tip_inventory = 12,
    Tip_task_dispatch = 13,
    Tip_team = 15,
    Tip_union_trade = 17, --战盟拍卖
    Tip_friends = 19, --好友消息
    Tip_MonthCard = 20, --月卡提示
    Tip_GoldPrivilege = 21, --黄金特权
    Tip_DiamondPrivilege = 22, --钻石特权
    Tip_MonthCardQJQuota = 23, --月卡奇迹币限额
    Tip_EquipFix = 24, --装备修理
    Tip_FaceTrade = 25, --面对面交易
    Tip_NewPlayerBuff = 26, --新手BUFF和MM消失
    Tip_FriendsApplication = 27 --好友申请
}
EMonthType = {
    MonthCardTime = 30030305, --月卡时间
    MonthCard = 30030306,
    DailyCard = 30030307
}
---@class ERedFortstage @新手引导步骤结束方式
---赤色要塞
ERedFortstage = {
    Wait = enum(1),
    Fight = enum(2),
    ActivityEnd = enum(3),
}
---@class EOnHookType 挂机模式
EOnHookType = {
    No = enum(0), --非挂机状态
    Patrol = enum(1), --巡逻挂机
    Situ = enum(2), --原地挂机
    OffLine = enum(3), --离线挂机
}
ERechargeType = {
    RechargeMall = 1, --充值挡位
    MonthCardType = 2, --月卡类型
    FirstChargeGift = 3, --首充豪礼
    DailyGift = 4, --每日礼包
    MountGift = 5, --单物品礼包
    RechargeLink = 12, --连冲礼包
    MonthCardGift = 14,--月卡礼包
    DiamondRecharge = 18 ,---运营活动钻石礼包
    DiamondRechargeWeek = 188 ,---周末活动钻石礼包
    AddRecharge = 17 ,---运营活动累充礼包
    AddRechargeWeek = 177 ,---周末活动累充礼包
    NewMonthCard = 21, --生态服月卡
}

---@class E_QJ5_OpenServiceType
E_QJ5_OpenServiceType = {
    BossKill = enum(0), --boss 首杀
    Athletics = enum(), --开服竞技按钮
    BigWeal = enum(), --大天使奖励
    WingTask = enum(), --翅膀任务
    JewelryMaster = enum(), --首饰大师,/替换优化成大天使武器2.0
    --AngelWeapon = enum(), --大天使武器2.0
    SevendaysLogin = enum(), --七日登录
    LevelReward = enum(), --等级奖励
    --NewGiftbag = enum(), --新手礼包
    EquipmentFirstBlast = enum(), --装备首爆
    WildBossKill = enum(), --野外BOss首杀
}

---变身卡牌功能类型
E_ShapeShiftCardFuncType = {
    Inlay = enum(1),    --镶嵌
    House = enum(),         --牌库
    Synthesis = enum(),     --合成
    ExSynthesis = enum(),   --变身合成
    UnSynthesis = enum(),   --合成_卸下
    UnInlay = enum(),       --卸下
    Break = enum(),         --突破
    UnBreak = enum(),       --突破_卸下
    ExBreak = enum(),       --变身突破
}

---变身卡牌类型
E_ShapeShiftCardType = {
    Exchange = enum(1),     --变身卡牌
    Attr = enum(2),         --赋能卡牌
    GodAttr = enum(3),      --神赋卡牌
}

---商业化礼包状态
E_RechargeState = {
    CanGet = enum(1),--可领取
    NotComplete = enum(2),--未完成
    AlreadyGet = enum(3),--已领取
}

---翅膀任务状态
E_ChapterState = {
    ACCPT = enum(1),--已解锁
    FINISH = enum(2),--已完成
    REWARD = enum(3),--已领取
}

E_ArchangelGroupType = {
    Breakthrough = enum(1), --突破
 Grail = enum(2), -- 圣杯
    Decompose = enum(3), -- 分解
}

----@class EBossChallengeType
EBossChallengeType={
    ---黄金
    Gold = enum(1),
    ---野外
    Field = enum(2),
    ---秘境
    Secret = enum(3),
    ---特权
    Privilege = enum(4),
    ---圣域
    Sanctuary = enum(5),
    ---跨服
    KuFu = enum(5),
    
    ---黄金部队
    GoldTroops = enum(7),
    ---昆顿魔王
    KunDunDevil = enum(8),
}


--圣杯代表的品质
---@class E_ArchangelGrailQuality
E_ArchangelGrailQuality= {
    Green = enum(1), --1绿色品质
    Blue = enum(2), --2蓝色品质
    Purple = enum(3), --3紫色品质
    Golden = enum(4), --4金色品质
    Color = enum(5), --5棱彩品质
}

--圣杯代表的品质
---@class E_ArchangelGrailQualityName
E_ArchangelGrailQualityName= {
    [E_ArchangelGrailQuality.Green] = "绿色", --1绿色品质
    [E_ArchangelGrailQuality.Blue] = "蓝色", --2蓝色品质
    [E_ArchangelGrailQuality.Purple] = "紫色", --3紫色品质
    [E_ArchangelGrailQuality.Golden] = "金色", --4金色品质
}

--圣杯代表的品质
---@class E_ArchangelGrailQualityColor
E_ArchangelGrailQualityColor= {
    [E_ArchangelGrailQuality.Green] = "#1add1f", --1绿色品质
    [E_ArchangelGrailQuality.Blue] = "#4ba7e8", --2蓝色品质
    [E_ArchangelGrailQuality.Purple] = "#df4be8", --3紫色品质
    [E_ArchangelGrailQuality.Golden] = "#e8d04b", --4金色品质
    [E_ArchangelGrailQuality.Color] = "#dce1e5", --5棱彩品质
}

--圣杯可融合位置
---@class E_ArchangelGrailstrPart
E_ArchangelGrailstrPart= {
    [EEquipSlotType.ArchangelWeapon] = "主手武器", 
    [EEquipSlotType.ArchangelOffHandWeapon] = "副手武器", 
    [EEquipSlotType.ArchangelTwoHandWeapon] = "主副手武器", 
    [EEquipSlotType.ArchangelHelmet] = "头盔",
    [EEquipSlotType.ArchangelArmor] = "铠甲",
    [EEquipSlotType.ArchangelGlove] = "护手",
    [EEquipSlotType.ArchangelPant] = "护腿",
    [EEquipSlotType.ArchangelBoot] = "鞋子",
}

---运营活动枚举类
--运营活动类型 对应OperateActivity_subActivity表内的subType
--用来发id给后端
EOperateActivityActivityType = {
    FirstGetOnActivity = enum(0), --初始上线请求
    RechargeDirect = enum(1), --直购
    OperateAddRecharge = enum(2), --累充请求
    luckyTurnTable = enum(3), --抽奖
    DiamondRecharge = enum(4), --钻石
    ConsumerRanking = enum(5), --消费排行
}

---技能界面显示类型
E_SkillShowType = {
    ---技能正常界面
    Normal = enum(1),
    ---变身技能界面
    Transfer = enum(2)
}

---@class EPKMode_Out
---@field AllAttack number @ 0, --全体模式
---@field Peace number @ 1, --和平模式
---@field Marry number @ 2, --夫妻模式 暂不用
---@field ShiTu number @ 3, --师徒模式 暂不用
---@field Team number @ 4, --组队模式
---@field Union number @ 5, --行会模式
---@field RedName number @ 6, --红名模式 暂不用
---@field Country number @ 7, --国家模式 暂不用
---@field Storm  number @ 8, --强攻模式 敌方：队友和盟友（包括自己）以外的目标 友方：队友和盟友（包括自己）
---@field Camp number @9, --阵营模式
---@field Robbery number @10, --掠夺模式
---@field Attack number @11, --攻方模式
---@field Defend number @12, --守方模式
EPKMode_Out = {
    AllAttack = 0, --全体模式
    Peace = 1, --和平模式
    Marry = 2, --夫妻模式 暂不用
    ShiTu = 3, --师徒模式 暂不用
    Team = 4, --组队模式
    Union = 5, --行会模式
    RedName = 6, --红名模式 暂不用
    Country = 7, --国家模式 暂不用
    Storm = 8, --强攻模式 敌方：队友和盟友（包括自己）以外的目标 友方：队友和盟友（包括自己）
    Camp = 9, --阵营模式
    Robbery = 10, --掠夺模式
    Attack = 11, --攻方模式
    Defend = 12, --守方模式
    Camp_out = 13, --阵营模式 --昆顿入侵的阵营模式
    --后面暂时不用
    --GoodAndEvil = 4, --善恶模式
    --
}

---@class EPKModeToUI_Out
EPKModeToUI_Out = {
    [EPKMode_Out.AllAttack] = '全体',
    [EPKMode_Out.Peace] = '和平',
    [EPKMode_Out.Marry] = '夫妻',
    [EPKMode_Out.ShiTu] = '师徒',
    [EPKMode_Out.Team] = '组队',
    [EPKMode_Out.Union] = '战盟',
    [EPKMode_Out.RedName] = '红名',
    [EPKMode_Out.Country] = '国家',
    [EPKMode_Out.Storm] = '强攻',
    [EPKMode_Out.Camp] = '阵营',
    [EPKMode_Out.Robbery] = '掠夺',
    [EPKMode_Out.Attack] = '攻方',
    [EPKMode_Out.Defend] = '守方',
    [EPKMode_Out.Camp_out] = '阵营',
}

---@class ERoleSetting_Out
---@field DragonSoulSkillShow @ 37， 连击技显隐设置
ERoleSettingType_Out = {
    DragonSoulSkillShow = 37,
    VIPHeadShow = 38,
    autoUseDrug = 39,
}

---@class E_UnionActivty
E_UnionActivty = {
    Boss = 14001,--战盟Boss
    WolfsoulFortress = 15001, -- 狼魂要塞
    Siege = 16001, -- 攻城战
}


---@class EChatChannelType
EChatChannelType_Out = {
    ALL = enum(-1), --综合
    SYSTEM = enum(0), --系统
    FIGHT = enum(1), --战斗
    WORLD = enum(2), --世界
    MAP_POINT_RAGE = enum(3), --当前
    UNION = enum(4), --公会
    RECRUIT = enum(5), --招募
    NEARBY = enum(6), --附近        
    TEAM = enum(7), --队伍
    PERSONAL = enum(8), --私聊
    FRIEND = enum(9), --好友聊天
    CORSS_SERVER = enum(101) --跨服聊天
}
EChatChannelTypeStr_Out = {
    SYSTEM = "系统", --系统
    FIGHT = "系统", --战斗
    WORLD = "世界", --世界
    MAP_POINT_RAGE = "当前", --当前
    UNION = "战盟", --公会
    RECRUIT = "招募", --招募
    NEARBY = "附近", --附近        
    TEAM = "队伍", --队伍
    PERSONAL = "私聊", --私聊
    FRIEND = "好友", --好友聊天
    CORSS_SERVER = "跨服" --跨服聊天
}
EOperateActivityType = {
    Cross = enum(0), --跨服
    Week =  enum(1), --周末
}

EBagTileScrollViewId_Out = {
    Synthesis = enum(101), --合成炉背包
    Other = enum(102), --其它需要自定义设置tips位置的背包
    GemSynthesis = enum(103), --萤石合成
}

---合成炉背包大小
ESynthesisBagSize = {
    H = 6,
    V = 8,
}

---循环任务背包大小
ELoopTaskBagSize = {
    H = 4,
    V = 8,
}
EElement = {
    [1] = "火",
    [2] = "水",
    [3] = "冰",
    [4] = "风",
    [5] = "雷",
    [6] = "土"
}
---@class EFGCharacterAttrType
EFGCharacterAttrType = {
    hitRate = 209011, -- 攻击率
    missRate = 211011, -- 防御率
    armor = 206011,---防御值
    maxHp = 207011, -- 最大生命值
    maxMp = 208011, -- 最大魔法值
    eraRate = 212011,---PVP防御率
    pvpattackRate = 210011,---Pvp攻击率
}
---@class EMUCharacterAttrType
EMUCharacterAttrType = {
    strength = 10001, -- 力量
    agility = 10002, -- 敏捷
    intelligence = 10003, -- 智力
    spirit = 10004, -- 体力
    command = 10005, -- 统帅
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
    Lucky = 326012,--锻造成功率增加
}

EOriginItemAction = {
    BIG_SECRET_REALM_REWARD = "大天使秘境通关奖励",
    TURNTABLE_RAFFLE_REWARDS = "轮盘抽奖奖励",
    TURNTABLE_RAFFLE_ACCUMULATE_REWARDS = "轮盘抽奖累次奖励",
    CAREER_TRANSFER_ITEM_SEND = "职业转换道具发放",

    FRIEND = "好友",
    FRUIT = "果实",
    GOLDTASK = "黄金任务",
    ITEM_COMPOSE = "物品合成",
    LEVEL_REWARD = "等级奖励",
    OFFLINE_HANGUP = "离线挂机",
    BLOOD_CASTLE = "血色城堡",
    DEMON_SQUARE = "恶魔广场",
    SECRET_REALM_BOSS = "秘境boss",
    GUILD_BOSS = "战盟BOSS",
    UNION_TASK = "战盟任务",
    FLUORESCENT_STONE = "荧石",
    DAILY_LOTTERY = "每日抽奖",
    EQUIPMENT_FIRST_SHOW = "装备首曝",
    TREASURE_MERCHANT = "宝箱商人",
    GM = "gm",
    RECHARGE_REWARD = "充值奖励",
    FIRST_RECHARGE_GIFT = "首充礼包",


    ANGELBENEFIT = "天使福利",
    ANGELWEAPON = "天使武器",
    AUTOBUYPOTION = "自动买药",
    BOSSBOUNTY = "boss悬赏",
    GOLDFIRSTKILL = "黄金首杀",
    SEVENRECEIVE = "七日连充",
    SEVENLOGIN = "七日登录",
    DAILYACTIVITY = "每日任务",
    ITEMRECYCLING = "物品回收",
    MONSTER_HUNT = "猎魔",
    COMBO_REWARD = "连击奖励",
    WOLF_SOUL = "狼魂要塞",
    DAILYRECHARGE = "每日累充",
    OPENSEVERRECHARGE = "开服连充",
    VIPPRIVILEGE = "VIP特权",
    DAILYGIVEAWAY = "每日赠送",
    OPERATEACTIVITY = "运营活动",
    DIAMONDPACK = "钻石礼包",
    WEEKACCUMULATEDRECHARGE = "周末累充",
    WEEKDIAMONDPACK = "周末钻石礼包",
    WINGS = "翅膀任务",
    RANDOMCHEST = "随机宝箱",
}

---@class EHeadPart_Out
EHeadPart_Out = {
    Name_BG_Part = enum(101),
    SD_Slider = enum(102)
}

---@class EHeadPart_Path_Out
EHeadPart_Path_Out = {
    [EHeadPart_Out.Name_BG_Part] = "NameBg",
}

---@class EHeadPart_Type_Out
EHeadPart_Type_Out = {
    [EHeadPart_Path_Out[EHeadPart_Out.Name_BG_Part]] = EHeadPart_Out.Name_BG_Part,
}
EMainUIBottomFuncType = {
    Role = 111,
    Forge = 104,
    Bag = 107,
    Skill = 102,
    Trade = 110,
    Shop = 202,
    Setting = 101,
    System = 238,
    Mail = 103,
    Friend = 108,
    Union = 105,
}

---@class  EForgeGroupType
EForgeGroupType = {
    Strength = enum(1), --强化
    Add = enum(), --追加         
    Gem = enum(), --镶宝
    Decompose = enum(), --分解
    Overlay380 = enum(), --380叠加
    Trans = enum(), --转移
    Deify = enum(), --神化
    StarMaster = enum(), --大师
    Jewelry = enum(), --首饰
    Regenerate = enum(), --再生
    Breakthrough = enum(), -- 突破（大天使装备）
    Lucky = enum(), -- 幸运（幸运装备）
}

EAtkAttrType = {
    PhyMaxAtk = 201011,--最大物理攻击力
    PhyMinAtk = 201021,--最小物理攻击力
    MacMaxAtk = 202011,--最大魔法攻击力
    MacMinAtk = 202021,--最小魔法攻击力
    CurseMaxAtk = 205011,--最大诅咒攻击力
    CurseMinAtk = 205021,--最小诅咒攻击力
    
    
    MinAtkUp    = 200011,--最小攻击力提高
    MaxAtkUp    = 200021,--最大攻击力提高
}       

EAtkAttrTypeStr = {
    [EAtkAttrType.PhyMaxAtk] = "物理攻击力",
    [EAtkAttrType.PhyMinAtk] = "物理攻击力",
    [EAtkAttrType.MacMaxAtk] = "魔法攻击力",
    [EAtkAttrType.MacMinAtk] = "魔法攻击力",
    [EAtkAttrType.CurseMaxAtk] = "诅咒攻击力",
    [EAtkAttrType.CurseMinAtk] = "诅咒攻击力",
    [EAtkAttrType.MinAtkUp] = "最小攻击力提高",
    [EAtkAttrType.MaxAtkUp] = "最大攻击力提高",
}

EAtkAttrTypeTable = {
    [1]= {min = EAtkAttrType.PhyMinAtk,max = EAtkAttrType.PhyMaxAtk},
    [2]= {min =EAtkAttrType.MacMinAtk,max = EAtkAttrType.MacMaxAtk},
    [3]= {min =EAtkAttrType.CurseMinAtk,max = EAtkAttrType.CurseMaxAtk},
}

---@class ETipsParameter
ETipsParameter = {
    TipsWidth = 274,--tips宽度
    TipsElementHight = 19,--tips上元素的高度 16+ 5（间隔）
    TipsJobBgHight = 18,--职业背景高度
    EquipTipsHightOffset = 98,--装备tips高度偏移（有按钮）
    EquipTipsHightNotBtnOffset = 60,--装备tips高度偏移（无按钮）
    ItemTipsHightOffset = 15,--装备tips高度偏移（使用的是自适应没用按钮的影响）
    Box_Scroll_Offset_H = 20,--自选，随机宝箱滚动列表偏移高度
}

OutHorseRaceType = {
    1,2,3,4,5,17
}

---@class EEquipSlotType
---和表里的strPart对应
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
    Mount = enum(10001), --坐骑
    
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
EMapMoveConditionError=
{
    None = enum(0),---线路条件不满足
    Line = enum(1),---线路条件不满足
    Flying = enum(2),---翅膀条件不满足
    Level = enum(3),---等级不满足
    Coin = enum(4),---金币不满足
    RedName = enum(5),---红名不满足
}

---@class EEquipScaleType
EEquipScaleType = {
    None = enum(0),
    BagEquipScale = enum(1),
    ForgeEquipScale = enum(2),
    ForgeShowEquipScale = enum(3),
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
    Monster = enum(47),
    OpenPanel = enum(50),
    DamageMonster = enum(51),
    StudySkill = enum(61)
}
--快捷使用类型描述
---@class EShortcutUserTypeStr
EShortcutUserTypeStr = {
    [EShortcutUserType.AttrPos] = "立即加点",
    [EShortcutUserType.NormalBox] = "立即使用",
    [EShortcutUserType.WearEquip] = "进入背包",
    [EShortcutUserType.NoWearEquip] = "进入背包",
}

---@class ESynthesisAuxiliaryCostType
ESynthesisAuxiliaryCostType = {
    ---额外消耗
    extrit = enum(1),
    ---定向消耗
    dingxia = enum(),
    ---保护消耗
    baohu = enum(),
}

ESynthesisOpenPanelType = {
    ---数量选择
    NumSelect = enum(1),
    ---绑定选择
    BindSelect = enum(),
    ---道具选择
    ItemSelect = enum(),
}

---交易行货币类型
---@class ETradeCoinType
ETradeCoinType = {
    ---积分
    Score = 10240001,
}

---@class EUnionPositionToColor
EUnionPositionToColor = {
    [0] = "0xff8a00ff",
    [1] = "0xff8a00ff",
    [2] = "0xffc000ff",
    [3] = "0x90d210ff",
    [4] = "0x4cc5feff",
    [5] = "0xdce1e5ff"
}