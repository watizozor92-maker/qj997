-- 全局表配置id
GlobalConfigId = {
    CHAT_FONT_LIMIT = 9,                    -- 聊天发送文字上限
    TEAM_MEMBER_MAX = 121,                  -- 队伍最大人数限制
    DUPLICATE_TIME_OUT = 106,               -- 副本断线重连时间，单位s，超过时间将玩家踢出副本
    DEFENSE_TIME = 807,                     -- pk值防卫状态持续时间
    MONSTER_FIRST_ATTACK_TIME_LIMIT = 811,  -- 怪物首刀攻击归属时长限制
    MONSTER_MAX_HURT_TIME_LIMIT = 812,      -- 怪物最高伤害归属时长限制
    COMBO_SKILL_INFO = 1501,                -- 连击技能信息
    CHANGE_NAME_COST_WITHOUT_CARD = 1600,   -- 【无改名卡】战盟/角色改名消耗配置
    CHANGE_NAME_CARD_COST = 1602,           -- 【有改名卡】战盟/角色改名消耗配置
    GOLD_TASK_COUNT = 2001,                 --勇士任务次数限制
    GOLD_TASK_LEVEL_LIMIT = 2002,           --勇士任务等级限制
    GOLD_TASK_FREE_LIMIT = 2003,            --勇士任务免费限制
    GOLD_TASK_FLUSH_COST = 2004,            --勇士任务付费刷新
    SECRET_REALM_INIT = 2005,               -- 秘境BOSS挑战初始化次数
    SECRET_REALM_STEP = 2006,               -- 秘境BOSS挑战每日刷新增加次数
    SECRET_REALM_MAX_COUNT = 2007,          -- 秘境BOSS挑战次数上限
    OPEN_MASTER_SERIES_COST = 4001,         -- 大师之路 单次启用职业天赋系消耗货币（格式：货币id#数量）
    MASTER_TALENT_RESET_COST = 4002,        -- 大师之路 职业天赋洗点消耗货币（格式：货币id#数量）
    JOB_TALENT_DAY_COUNT = 4004,            -- 大师之路 职业天赋每日兑换经验次数
    OPEN_MASTER_JOB_CD = 4005,              -- 大师之路 启用职业天赋冷却时间（单位：秒）
    MASTER_TALENT_SKILL_RESET_COST = 4007,  -- 大师之路 技能天赋洗点消耗货币（格式：货币id#数量）
    OPEN_MASTER_SKILL_CD = 4009,            -- 大师之路 启用技能天赋冷却时间（单位：秒）
    MASTER_TALENT_COMMON_RESET_COST = 4011, --大师之路 通用天赋洗点消耗货币（格式：货币id#数量）
    COMMON_TALENT_POINTS = 4012,            -- 大师之路 角色等级每升1级给的通用天赋点数
    COMMON_TALENT_MAX_LEVEL = 4013,         -- 大师之路 多少级开始停止获得天赋点开始获得通用天赋点
    SKILL_TALENT_DAY_COUNT = 4014,          -- 大师之路 技能天赋每日兑换经验次数
    COMMON_TALENT_LEVEL_POINT = 4015,       -- 大师之路 超过多少级开始每级给1点
    MASTER_TALENT_TIER_NEED_POINT = 4016,   -- 大师之路 每个阶段解锁需要的点数
    OFFLINE_ON_HOOK_TIMEOUT = 6001,         -- 离线挂机功能超时时间（分钟）
    OFFLINE_ON_HOOK_LEVEL = 810001,         -- 离线挂机功能开启等级
    OFFLINE_ON_HOOK_EXP_LIMIT = 6004,       -- 离线挂机可积攒经验上限
    EXONERATION_CHARM_MINUS_COUNT = 10001,  -- 免罪符使用减少PK值的规则
    SAFETY_AREA_BUFF_CONFIG = 15005,        -- 安全区域buff配置id
    SAFETY_AREA_MAP_CONFIG = 15006,         -- 安全区域buff地图id配置
    OPEN_SERVER_ACT_RANK = 17001,           -- 开服活动全服排行配置
    RESET_ANGEL_TALENT_COST = 22001,        -- 重置天使天赋点数消耗配置
    TRANSFER_WITHIN_MAP = 25003,            -- 地图内定点传送功能
    TWO_SUIT_CHART_ATTR = 280001,           -- 总览属性（2套）
    THREE_SUIT_CHART_ATTR = 280002,         -- 总览属性（3套）
    FOUR_SUIT_CHART_ATTR = 280003,          -- 总览属性（4套）
    FORGE_EQUIP_ATTR_LIMIT = 300001,        -- 强化时部分装备得属性，不受到强化额外属性公式得影响，配置格式：装备部位（part）#属性id
    DURABILITY_WEAPON_TYPE = 320001,        -- 耐久度——武器类型
    DURABILITY_ARMOR_TYPE = 320002,         -- 耐久度——防具类型
    DURABILITY_GUARD_TYPE = 320003,         -- 耐久度——守护类型
    DURABILITY_JEWELRY_TYPE = 320004,       -- 耐久度——首饰类型
    DURABILITY_ARMOR_REDUCE_RANGE = 320005, -- 耐久度——防具属性减少区间
    DURABILITY_CAREER_ATTR = 320006,        -- 耐久度——职业属性
    DURABILITY_JEWELRY_SAFE = 320007,       -- 耐久度——首饰单次触发耐久消耗积累时间（安全区）
    DURABILITY_JEWELRY_UNSAFE = 320008,     -- 耐久度——首饰单次触发耐久消耗积累时间（非安全区）
    DURABILITY_REPAIR_COST = 320009,        -- 耐久度——装备修理消耗道具
    DURABILITY_GUARD_PARAM = 320010,        -- 耐久度——守护耐久抵抗参数
    DURABILITY_AUTO_REPAIR_VALUE = 320011,  -- 耐久度——自动修理阈值
    DURABILITY_STRENGTH_VALUE1 = 320012,    -- 耐久度——0-4级耐久度强化值
    DURABILITY_STRENGTH_VALUE2 = 320013,    -- 耐久度——5-9级耐久度强化值
    DURABILITY_STRENGTH_VALUE3 = 320014,    -- 耐久度——9-Maxlevel耐久度强化值
    DURABILITY_DEDUCT_TIME = 320015,        -- 耐久度——扣除1点消耗的时间
    DURABILITY_REPAIR_COST1 = 320016,       -- 耐久度——修理1点消耗的道具数量
    GOLD_LINE_PRIVILEGE = 330001,           -- 黄金线路特权
    DIE_COST_ITEM_BY_PLAYER = 340001,       -- 玩家被玩家击杀死亡掉落金币比例
    DIE_COST_ITEM_BY_MONSTER = 340002,      -- 玩家被怪物击杀死亡掉落金币比例
    ELITEMM_MAX_VALUE = 350001,             -- 精灵MM卡 buff数值上限
    LOOP_TASK_OPEN_LEVEL = 29001,           -- 跑环任务开启等级
    PLAYER_KILL_RESET_TIEM = 440001,        -- 玩家击杀怪物记录重置时间
    WORLD_DROP_MBOX_RESET_TIEM = 450001,    -- 全服掉落mbox次数记录重置时间
    PLAYER_DROP_MBOX_RESET_TIEM = 460001,    -- 玩家掉落mbox次数记录重置时间
    DROP_BUFF_GOLOBAL_RECORD = 470001,      -- 掉落buff消减450001比例
    STRENGTH_PERSON_BROADCAST = 490001,     -- 物品强化显示播报的最小等级（个人）
    STRENGTH_SYSTEM_BROADCAST = 490002,     -- 物品强化显示播报的最小等级（全服）
    APPEAR_SYSTEM_BROADCAST = 490003,       -- 物品追加显示播报的最小等级（全服）
    BFG_CHAMPION_REWARD = 670001,           -- 冰风谷攻城盟主奖励
    BFG_DEPUTY_CHAMPION_REWARD = 670002,    -- 冰风谷攻城副盟主奖励
    BFG_MEMBER_REWARD = 670003,             -- 冰风谷攻城成员奖励
    BFG_PARTICIPATE_REWARD = 670004,        -- 冰风谷攻城参与奖励
    BFG_MVP_REWARD = 670005,                -- 冰风谷攻城MVP奖励
    BFG_OCCUPY_TIME = 670006,               -- 冰风堡攻城战真实占领时间（s）
    BFG_OCCUPY_POSITION = 670007,           -- 冰风堡攻城战占领坐标，地图id#X#Y#width#height
    BFG_GO_POSITION = 670008,               -- 冰风堡攻城战点击前往的传送坐标，配置格式：地图id#x#y#线路id
    BFG_FIRST_OPEN_TIME = 670010,           -- 冰风堡攻城战首次开启时间，开服多少天
    BFG_DIE_REVIVE_DOT = 670012,            -- 冰风堡攻城战死亡复活点 配置格式：地图id#干线id#坐标#范围
    OFFLINE_ON_HOOK_ACCOUNT_LIMIT = 740001,   -- 离线挂机功能账号限制开关
    LINE_ALLOT_RULE_FORBIDDEN_CFG = 830001, -- 线路随机（均匀）规则禁用线路
    SILVER_PRIVILEGE_BUFF = 840001,         -- 白银特权新手buff
    MIRACLES_SOUL = 910001,                 -- 奇遇之魂
    MIRACLES_SOUL_KILL_REWARD = 910002,     -- 奇遇之魂击杀奖励
    PLAYER_MAX_SD_VALUE = 920001,           -- 玩家最大护盾值
}

LoopTaskConfig = {
    task_target_id = 2001001,
    task_id = 80001,
}

MonsterConfigId = {
    HUOLONG = 10008
}

-- 道具id
ItemConfigId = {
    EXONERATION_CHARM = 70700026, -- 免罪符id
    EXP = 10080001,
    JOB_TALENT_ID = 1016001,
    SKILL_TALENT_ID = 1017001,
    ELITEMM = 100000004,
    SCORE = 10240001, --积分
    BIND_QI_JI_MONEY = 10030001,
    GOLD = 10010001,
}

SkillConfigId = {
    DEMON_HERMIT_SKILL_ID = 1016012, -- 恶灵召唤技能id
    DEMON_HERMIT_COMMON_ONE_SKILL_ID = 1016017, -- 恶灵召唤普通攻击1
    DEMON_HERMIT_COMMON_TWO_SKILL_ID = 1016018, -- 恶灵召唤普通攻击2
    DEMON_HERMIT_COMMON_THREE_SKILL_ID = 1016019, -- 恶灵召唤普通攻击3
}

-- 道具类型
ItemType = {
    COIN = 1, --货币
    ---装备道具
    EQUIP = 2,
    --- 药品，使用以后直接加血和加蓝
    DRUG = 3,
    BOX = 4,      -- 宝箱
    MATERIAL = 5, --材料
    TRIGGER = 6,  --触发类物品；
    TRANSFER_CARD = 8
}


IdType = {
    -- ======= 内置 =======
    USER = 1,
    ITEM = 2,
    LOG = 3,
    -- BUFF = 4,  -- 已注释
    MAIL = 5,
    SOCIAL = 6,
    STALL = 7,
    UNION = 8,
    ACTIVITY = 9,
    BOX = 10,
    KS_FUTURE = 11,
    USER_ROLE = 12,
    -- 充值
    ORDER = 13,
    CHAT = 14,
    REPLICA = 15,
    -- ======= 内置 =======
    BOX_DROP = 20,



}





--- 触发类物品子类型
TriggerSubType = {
    CAREER_TRANSFER_CARD = 15,-- 转职卡
}

--- 道具子类型
ItemSubType = {
    EQUIP_BOX = 1,    -- 装备宝箱
    QJCOIN = 2,       -- 奇迹币
    DIAMOND = 4,      -- 钻石
    BIND_QJCOIN = 3,  -- 绑定奇迹币
    BIND_DIAMOND = 5, -- 绑定钻石
    --- 换购货币
    REPLACEMONEY = 51,
    -- 大天使经验药水
    ANGEL_EXP = 96,
    -- 大天使经验加成药水
    ANGEL_EXP_BOOST = 97,
    -- 经验加成药
    EXP_BOOST = 98,
    MOUNT = 10001,
}

-- cfg_string表subType字典
StringSubType = {
    SYSTEM = "系统",
    UNION = "战盟"
}

-- cfg_string表id字典
StringIdConst = {
    LEVEL_NOT_MATCH = 18,             -- 等级不符
    GET_HINT = 32,                    -- 获得提示
    ALL_SERVER_FIRST_KILL = 100,      -- 全服首杀通告
    JOB_CHANGE = 101,                 -- 成功转职
    LEVEL_INSUFFICIENT = 249,         -- 等级不足
    DUPLICATE_CAN_NOT_TRANSMIT = 116, -- 副本中无法传送
    TEXT253 = 253,                    -- 所需道具数量不足
    CURRENT_LEVEL_INSUFFICIENT = 263, -- 当前等级不足
    TEXT334 = 334,                    -- 买药钱不够
    TEXT335 = 335,                    -- 没有使用特权卡
    TEXT336 = 336,                    -- 该物品今日拾取达到上限
    TEXT337 = 337,                    -- 请先击杀BOSS
    TEXT338 = 338,                    -- 已领取
    TEXT339 = 339,                    -- 请求数据错误
    TEXT340 = 340,                    -- 任务未完成
    TEXT341 = 341,                    -- 你没有队伍
    TEXT342 = 342,                    -- 队伍已满
    TEXT343 = 343,                    -- 招募CD未结束
    TEXT344 = 344,                    -- 不能重复进入神之国度
    TEXT345 = 345,                    -- 地图传送配置不存在
    TEXT346 = 346,                    -- 背包道具不足
    TEXT347 = 347,                    -- 删除道具失败
    TEXT348 = 348,                    -- 道具不足，无法重置果实属性
    TEXT349 = 349,                    -- 请先提交当前任务
    TEXT350 = 350,                    -- 消耗扣除失败
    TEXT351 = 351,                    -- 道具不足，请补充道具
    TEXT352 = 352,                    -- 请先刷新任务池
    TEXT353 = 353,                    -- 等级未达到
    TEXT354 = 354,                    -- 活动次数已达上限
    TEXT355 = 355,                    -- 任务不存在
    TEXT356 = 356,                    -- 特殊耗材选择错误
    TEXT357 = 357,                    -- 背包内道具数量不够
    TEXT358 = 358,                    -- 合成失败
    TEXT359 = 359,                    -- 该坐骑无法穿戴装备
    TEXT360 = 360,                    -- 当前没有默认骑乘坐骑
    TEXT361 = 361,                    -- 当前没有骑乘坐骑
    TEXT362 = 362,                    -- 首杀数据不存在
    TEXT363 = 363,                    -- 领取错误
    TEXT364 = 364,                    -- 奖励已领取
    TEXT365 = 365,                    -- 奖励领取错误
    TEXT366 = 366,                    -- 奖励配置不存在
    TEXT367 = 367,                    -- 活动已关闭
    TEXT368 = 368,                    -- 购买的商品不存在，商品ID=%s
    TEXT369 = 369,                    -- 该道具不能上架交易行
    TEXT370 = 370,                    -- 交易行格子已满，无法上架新的商品
    TEXT371 = 371,                    -- 上架失败
    TEXT372 = 372,                    -- 世界交易行没有上架商品
    TEXT373 = 373,                    -- 商品已经被购买或已经下架，请重新选择
    TEXT374 = 374,                    -- 商品还在公示期，无法下架
    TEXT375 = 375,                    -- 不能下架别人的商品
    TEXT376 = 376,                    -- 没有那么多商品
    TEXT377 = 377,                    -- 商品还在公示期，无法购买
    TEXT378 = 378,                    -- 不能购买自己的商品
    TEXT379 = 379,                    -- 当前货币不足
    TEXT380 = 380,                    -- 商品不在公示期，无法预购
    TEXT381 = 381,                    -- 不能预购自己的商品
    TEXT382 = 382,                    -- 您已经预约过，无需再次预约
    TEXT383 = 383,                    -- 该道具不能上家交易行
    TEXT384 = 384,                    -- 剩余3倍收益时间不足
    TEXT385 = 385,                    -- 已领奖
    TEXT386 = 386,                    -- 请先闯关
    TEXT387 = 387,                    -- 该副本等级不存在
    TEXT388 = 388,                    -- 奖励数据未位置
    TEXT389 = 389,                    -- 奖励数据配置错误
    TEXT390 = 390,                    -- 活动暂未开启！
    TEXT391 = 391,                    -- 开服天数不足！
    TEXT392 = 392,                    -- 请先退出组队！
    TEXT393 = 393,                    -- 活动开启,战盟条件不满足
    TEXT394 = 394,                    -- 主装备不存在
    TEXT395 = 395,                    -- 副装备不存在
    TEXT396 = 396,                    -- 请选择相同装备
    TEXT397 = 397,                    -- 主装备或副装备没有卓越词条
    TEXT398 = 398,                    -- 副装备的词条主装备都已拥有
    TEXT399 = 399,                    -- 该装备不能叠加
    TEXT400 = 400,                    -- 最大配置词条为空
    TEXT401 = 401,                    -- 锁定词条数量错误
    TEXT402 = 402,                    -- 消耗配置为空
    TEXT403 = 403,                    -- 消耗叠加道具与配置道具不匹配
    TEXT404 = 404,                    -- 消耗配置小于锁定配置
    TEXT405 = 405,                    -- 当前未接取任务
    TEXT406 = 406,                    -- 职业不符合
    TEXT407 = 407,                    -- 没有达到最低使用要求等级
    TEXT408 = 408,                    -- 已超过使用等级上限
    TEXT409 = 409,                    -- 玩家不存在！
    TEXT410 = 410,                    -- 玩家模型不存在！
    TEXT411 = 411,                    -- 玩家已死亡！
    TEXT412 = 412,                    -- 道具不存在！
    TEXT413 = 413,                    -- 道具不在当前坐标！
    TEXT414 = 414,                    -- 道具不在当前角色附近！
    TEXT415 = 415,                    -- 找不到技能
    TEXT416 = 416,                    -- 非主动技能
    TEXT417 = 417,                    -- 玩家信息不存在
    TEXT418 = 418,                    -- 玩家对象不存在
    TEXT419 = 419,                    -- 死亡中
    TEXT420 = 420,                    -- 魔法值不足
    TEXT421 = 421,                    -- 自身血量不足
    TEXT422 = 422,                    -- 自身技能值不足
    TEXT423 = 423,                    -- 方向出错
    TEXT424 = 424,                    -- 技能配置错误
    TEXT425 = 425,                    -- 技能等级配置错误
    TEXT426 = 426,                    -- 没有该技能
    TEXT427 = 427,                    -- 地图信息不存在
    TEXT428 = 428,                    -- 安全区内无法攻击
    TEXT429 = 429,                    -- 当前[" %s "]状态, 无法普通攻击
    TEXT430 = 430,                    -- 当前[" %s "]状态, 无法使用技能
    TEXT436 = 436,                    -- 开槽失败，已增加幸运值
    TEXT454 = 454,                    -- 战盟名称修改权限
    TEXT462 = 462,                    -- 奇迹币额度不够提示
    TEXT467 = 467,                    -- 请输入正确的手机号
    TEXT468 = 468,                    -- 已经填写过问卷，无需重复填写
    TEXT469 = 469,                    -- 抽奖次数不足
    TEXT471 = 471,                    -- 当天抽奖次数已经用完，请明天再来
    TEXT478 = 478,                    -- 黄金地图限制文字提示
    TEXT482 = 482,                    -- 天赋点数不足
    TEXT483 = 483,                    -- 天赋前置点数不足
    TEXT491 = 491,                    -- 交易行寄售特权未开启提示
    TEXT495 = 495,                    -- 大秘境副本道具不足提示
    TEXT601 = 601,                    -- 运营活动-抽奖，抽中大奖播报
    TEXT27001 = 27001,                -- 猎魔积分争霸赛
    TEXT29001 = 29001,                -- 当前背包已满，无法卸下
    TEXT36001 = 36001,                -- 玩家被击杀
    TEXT37001 = 37001,                -- 创角登录公告
    TEXT43001 = 43001,                -- 强化播报---个人
    TEXT43002 = 43002,                -- 强化播报---全服
    TEXT43003 = 43003,                -- 追加播报---全服
    TEXT44001 = 44001,                -- 回收积分奖励
    TEXT45001 = 45001,                -- 血色恶魔副本满员后提示
    TEXT50001 = 50001,                -- 怪物来袭怪物逃跑提示
    TEXT50002 = 50002,                -- 精灵MM卡 cd提示文本
    TEXT51001 = 51001,                -- 首曝提示文本
    TEXT52001 = 52001,                -- 掉落提示
    TEXT48002 = 48002,                -- 红名玩家使用免罪符
    TEXT48001 = 48001,                -- 红名玩家死亡全服播报
    TEXT56001 = 56001,                -- 冰风堡攻城30分钟内开启，每5分钟推送一次
    TEXT56002 = 56002,                -- 冰风堡攻城5分钟内开启，每1分钟推送一次
    TEXT56003 = 56003,                -- 冰风谷攻城开启瞬间推送
    TEXT56004 = 56004,                -- 冰风谷攻城10分钟内结束，每1分钟推送一次
    TEXT56005 = 56005,                -- 冰风谷攻城战结束，并推送获胜战盟名
    TEXT56006 = 56006,                -- 冰风谷攻城战结束，无获胜战盟
    TEXT56007 = 56007,                -- 冰风谷攻城战暂时占领
    TEXT4891 = 4891,                  -- 宝箱获取道具世界聊天
    NO_REGENERATION             = 77001, -- 当前装备没有再生属性！
    REGENERATION_CONDITION_FAIL = 77002, -- 当前装备不满足再生条件！
    REGENERATION_EVOLUTION_MAX  = 77003, -- 当前装备再生属性进化已满！
    TEXT79001 = 79001,                -- 天赋未解锁
}

-- cfg_string表receiver字典
StringReceiverType = {
    SYSTEM_SELF = 1,        -- 系统频道自己可见
    SYSTEM_CURRENT_MAP = 2, -- 系统频道当前地图内玩家可见
    SYSTEM_SAME_UNION = 3,  -- 系统频道同战盟玩家可见
    SYSTEM_ALL = 4,         -- 系统频道全服玩家可见
    UNION_SELF = 5,         -- 战盟频道自己可见
    UNION_ALL = 6           -- 战盟频道同战盟玩家可见
}

-- 聊天频道
NoticeChannel = {
    SYSTEM = 0, -- 系统
    UNION = 4   -- 战盟
}

-- 进入副本组队限制
SecretRealmTeamLimit = {
    SINGLE = 0, -- 限制单人
    TEAM = 1,   -- 必须组队
    ALL = 2     -- 可单人可组队
}

-- 存储怪物死亡事件的怪物id——cfg_monster表id
CountDownMonsterIds = { 40006, 50012, 60008, 70007 }

-- 战盟
UnionConst = {
    UNION_ACTIVITY_INITTYPE = 2 -- 战盟活动类型
}

-- 玩家自定义变量
PlayerDefKey = {
    LOG_KILL_NOMAR_MONSTER_COUNT = "@LOG_KILL_NOMAR_MONSTER_COUNT",
    DUP_TEAM_READY = "@副本组队状态", --value是布尔类型
    DUP_TEAM_BELONG = "@副本组队归属", --value是cfg_rep表id
    ONLINE_DURATION = "T$玩家在线时长",
    LAST_LOG_RECORD_TIME = "T$上次日志记录时间戳",
    FACE_SHOOT_PREVIEW_NO_TIPS = "T$FACE_SHOOT_PREVIEW_NO_TIPS",
    FACE_SHOOT_PREVIEW_COMPLETED = "T$FACE_SHOOT_PREVIEW_COMPLETED",
    LEVEL_UP_TEST_MAIL_RECORD = "T$LEVEL_UP_TEST_MAIL_RECORD",
    LAST_PASSIVE_SKILL_TIME_BY_TRANSFER = "@LAST_PASSIVE_SKILL_TIME_BY_TRANSFER_",
    PLAYER_FIGHT_HURT_TYPE = "@PLAYER_FIGHT_HURT_TYPE",
    -- pk值变量key
    pkValue = {
        PK_VALUE = "T$pkvalue",
        LAST_ATTACK = "T$lastattackinfo",
        PK_REDUCE_TIME = "T$pkvaluereducetime",
        REDUCE_TIME = "T$reducetime"
    },
    -- 离线挂机变量key
    offline = {
        FIGHT_EXP = "T$offlineFightExp",
        FIGHT_START = "T$offlineFightStart",
        FIGHT_END = "T$offlineFightEnd",
        BUBBLE_POINT_START = "T$offlineBubblePointStart",
        BUBBLE_POINT_END = "T$offlineBubblePointEnd",
        BUBBLE_POINT_MAP = "T$offlineBubblePointMap",
        BUBBLE_POINT_EXP = "T$offlineBubblePointExp",
        IS_RECEIVE = "T$isReceiveOfflineExp",
        LAST_TIME = "T$offlineLastTime",
        TOTAL_EXP = "T$totalExp",
        IMMUTABLE_CACHE = "T$offlineImmutableCache"
    },
    -- 角色变量key
    player = {
        FIRST_CHANGE_NAME = "T$firstChangeName",
        EXP_BOOST_EXPIRE_TIME = "T$expBoostExpireTime",
        EXP_BOOST_EXPIRE_MARK = "T$expBoostExpireMark",
        EXP_BOOST_ATTR_VALUE = "T$expBoostAttrValue",
        CAREER_REC = "T$careerRec",
    },
    -- 战盟
    UNION = {
        UNION_TASK_KEY = "U$_UNION_TASK_DATA_KEY",
        UNION_TASK_RESET_KEY = "U$_UNION_TASK_RESET_DATA_KEY",
        UnionMemberTaskDataKey = "T$_UNION_MEMBER_TASK_DATA_KEY",
        UnionArmbandsKey = "T$_UNION_ARMBANDS_DATA",
        UnionArmbandsLevelUpLimitCacheKey = "G$_UNION_ARMBANDS_LEVELUP_LIMIT_CACHE_DATA",
        GLOBAL_DEFAULT_UNION_CREATE_DATA_KEY = "R$_GLOBAL_DEFAULT_UNION_CREATE_DATA_KEY"
    },
    -- 天赋
    angel = {
        ANGEL_TALENT_POINT_ALL_COUNT = "T$angelTalentPointAllCount",           -- 角色天赋点，用于重置天赋点用
        ANGEL_TALENT_POINT_COUNT = "T$angelTalentPointCount",                  -- 角色剩余天赋点
        ANGEL_TALENT_POINT_INFO = "T$angelTalentPointInfo",                    -- 天赋树加点信息
        ANGEL_TALENT_ALREADY_INCREMENT_ID = "T$angelTalentAlreadyIncrementId", -- 天赋点已增加过的cfg_equip_angelSuit表id
        ANGEL_TALENT_ACTIVE_ID = "T$angelTalentActiveId",                      -- 存储天赋大师任务已激活的id信息
        ANGEL_TALENT_ALREADY_LEARN_SKILL = "T$angelTalentAlreadyLearnSkill",   -- 天赋点已学习过的技能id集合
        ANGEL_EQUIP_EXP_BOOST_INFO = "T$angelEquipExpBoostInfo",               -- 大天使经验药水信息
        ANGEL_TALENT_POINT_ALREADY_RESET = "T$angelTalentPointAlreadyReset",   -- 大天使天赋点重置次数
    },
    -- 月卡礼包
    monthGift = {
        MONTH_GIFT_KEY = "T$_month_gift_month_pack_key",
        MONTH_GIFT_DAILY_KEY = "J$_month_gift_daily_pack_key"
    },
    -- 大天使秘境
    bigSecretRealm = {
        -- 剩余奖励次数
        REWARD_COUNT = "T$_bigSecretRealmRewardCount",
        -- 是否默认领取奖励
        IS_RECEIVE_REWARD = "T$_bigSecretRealmIsReceiveReward",
        -- 评分
        SCORE = "T$_bigSecretRealmScore_%s",
        -- 秘境钥匙等级
        KEY_LEVEL = "T$_bigSecretRealmKeyLevel",
        -- 秘境开始时间
        START_TIME = "T$_bigSecretRealmStartTime",
        -- 是否通关
        IS_PASSED_LEVEL = "T$_bigSecretRealmIsPassedLevel",
        -- 本次通关是否发送了钥匙邮件
        IS_SEND_EMAIL = "T$_bigSecretRealmIsSendEmail",
        -- 最新评分
        NEW_SCORE = "T$_bigSecretRealmNewScore",
        -- 刷新时间
        REFRESH_TIME = "T$_bigSecretRealmRefreshTime",
    },
    ---副本相关
    duplicate = {
        ---副本(层级)完成次数
        DUP_FLOOR_FINISH_COUNT = "T$dup_floor_finish_count",
        ---副本(类型)完成次数
        DUP_TYPE_FINISH_COUNT = "T$dup_type_finish_count"
    },
    -- 轮盘抽奖用户变量
    turntableRaffle = {
        RAFFLE_INFO = "T$rouletteRaffle",                    -- 轮盘抽奖基础信息
        RAFFLE_REWARD = "T$turntableRaffleReward",           -- 轮盘抽奖奖励数量记录，可抽取次数使用
        RAFFLE_REWARD_COUNT = "T$turntableRaffleRewardCount" -- 轮盘抽奖每个奖励抽奖次数记录，保底循环使用
    }, 
    -- 幸运周轮盘抽奖用户变量
    WeekTurntableRaffle = {
        RAFFLE_INFO = "T$week_rouletteRaffle",                    -- 轮盘抽奖基础信息
        RAFFLE_REWARD = "T$week_turntableRaffleReward",           -- 轮盘抽奖奖励数量记录，可抽取次数使用
        RAFFLE_REWARD_COUNT = "T$week_turntableRaffleRewardCount" -- 轮盘抽奖每个奖励抽奖次数记录，保底循环使用
    },
    skill = {
        DEMON_HERMIT_SKILL = "T$demonHermitSkill"            -- 玩家是否释放了魔隐者技能
    },
    LAST_EQUIP_SPECIAL_ATTR = "T$last_equip_special_attr", -- 玩家上次的装备特殊属性（基础攻击力、防御力加成）
    KILL_PLAYER_COUNT = "T$kill_player_count",             -- 玩家累计击杀人头数
}

--副本组队限制
DupTeamType = {
    NONE = 0,
    PERSONAL = 1,
    TEAM = 2,
    UNION = 3
}

--请求修改组队状态
DupTeamChangeState = {
    READY = 1,  --准备
    REFUSE = 2, --拒绝
    BREAK = 3,  --解散
    CLOSED = 4  --关闭面板
}

--邮件表配置id
MailConfig = {
    RED_FORTRESS_REWARD = 17001,
    WOLF_SOUL_SUCCESS = 15001,
    WOLF_SOUL_FAIL = 15011,
    SERVER_FIRST_KILL_GOLD_BOSS = 110009,         --新服活动#全服首杀奖励
    END_TIME_GOLD_BOSS_REWARD = 110010,           --新服活动#黄金首杀奖励补发
    END_TIME_ANGLE_REWARD = 110011,               --新服活动#大天使福利奖励补发
    END_TIME_LEVEL_REWARD = 110012,               --新服活动#等级奖励补发
    END_TIME_ANGEL_WEAPON_REWARD = 110013,        --新服活动#大天使武器奖励补发
    END_TIME_LOGIN_REWARD = 110014,               --新服活动#七日登录奖励补发
    COMPETITION_RANK_REWARD = 110015,             --开服竞技#排行榜奖励
    COMPETITION_PERSONAL_REWARD = 110017,         --开服竞技#个人竞技奖励
    RECHARGE_SEVEN_REWARD = 110016,               --福利#七天登录奖励
    BIG_SECRET_REALM_KEY_LEVEL_UP = 19001,        -- 大秘境副本发放升级的钥匙
    BIG_SECRET_REALM_KEY_LEVEL_DOWN = 19002,      -- 大秘境副本发放降级的钥匙
    BIG_SECRET_REALM_QUIT_KEY_LEVEL_DOWN = 19003, -- 大秘境副本中途退出发放降级的钥匙
    BIG_SECRET_REALM_CURRENT_KEY_LEVEL = 19004,   -- 大秘境副本发放当前等级钥匙
    MONSTER_HUNT_INTEGRAL = 27001,                --猎魔积分争霸赛
    TURNTABLE_RAFFLE_ACCUMULATE_REWARDS = 900001, --轮盘抽奖累积奖励发放
    ROLAND_SEIGE_LEADER_REWARD = 406003,          --攻城战胜利方盟主奖励
    ROLAND_SEIGE_WIN_UNION_REWARD = 406001,       --攻城战胜利方全体奖励
    ROLAND_SEIGE_FAIL_UNION_REWARD = 406002,      --攻城战积分奖励
    ROLAND_SEIGE_PERSONAL_REWARD = 406004,        --攻城战个人积分奖励
    PK_RED_NAME_DROP_ITEM = 920001,               --红名-掉落道具惩罚
    PK_RED_NAME_DROP_EQUIP = 920002,              --红名-掉落装备惩罚
    PK_RED_NAME_DROP_COIN = 920004,               --红名-掉落金币惩罚
    PK_WHITE_NAME_DROP_ITEM = 920021,             --白名-掉落装备惩罚
    PK_WHITE_NAME_DROP_EQUIP = 920022,            --白名-掉落装备惩罚
    PK_WHITE_NAME_DROP_COIN = 920023,             --白名-掉落金币惩罚
    PK_YELLOW_NAME_DROP_ITEM = 920011,            --黄名-掉落装备惩罚
    PK_YELLOW_NAME_DROP_EQUIP = 920012,           --黄名-掉落装备惩罚
    PK_YELLOW_NAME_DROP_COIN = 920013,            --黄名-掉落金币惩罚
    BOX_DROP_RESEND = 940001,                     --宝箱未拾取道具补发
    BFB_VICTORY_AWARD = 950001,                   --冰风堡攻城战胜利奖
    BFB_PARTICIPATE_AWARD = 950002,               --冰风堡攻城战参与奖
    BFB_MVP_AWARD = 950003,                       --冰风堡攻城战MVP奖

}

NumConstant = {
    PROP_10000 = 10000,
}

-- 特权卡id——cfg_privilege表id
PrivilegeCardId = {
    SILVER1 = 30,
    SILVER2 = 31,
    SILVER3 = 32,
    SILVER4 = 33,
    GOLD1 = 40,
    GOLD2 = 41,
    DIAMOND1 = 50,
    DIAMOND2 = 51
}

PrivilegeCardMinType = {
    SILVER = 1,
    GOLD = 2,
    DIAMOND = 3,
    RECOVERY = 4,
    NEW_SILVER = 11,
}

--绑定表id
BindConfig = {
    WOLF_SOUL = 8
}

MapObjectType = {
    PLAYER = 1,
    MONSTER = 2,
    PET = 3,
    PARTNER = 4
}

SystemVarConst = {
    SERVER_START = "G$SERVER_START",
    FACE_SHOOT_PREVIEW_TASK_CACHE = "G$FACE_SHOOT_PREVIEW_TASK_CACHE",
    AUTO_RECOVERY_MAGIC_ROLE_INFO = "G$AUTO_RECOVERY_MAGIC_ROLE_INFO",
    -- 大天使秘境加成id
    BIG_SECRET_REALM_BONUS_INFO = "G$BIG_SECRET_REALM_BONUS_INFO",
    NORMAL_DAMAGE_TYPE_CACHE = "G$NORMAL_DAMAGE_TYPE_CACHE",             --战斗飘字缓存
    ELEMENTAL_DAMAGE_TYPE_CACHE = "G$ELEMENTAL_DAMAGE_TYPE_CACHE",       -- 元素战斗飘字缓存
    ROLAND_SEIGE = {
        FIRST_OPEN = "R$ROLAND_SEIGE_FIRST_OPEN",                        --罗兰峡谷攻城战副本首次开启标记
        DUPLICATE_ID = "G$ROLAND_SEIGE_DUPLICATE_ID",                    --罗兰峡谷攻城战副本地图id
        LAST_OCCUPY_UNION_ID = "R$ROLAND_SEIGE_LAST_OCCUPY_UNION_ID"     --罗兰峡谷攻城战上次占领战盟id
    },
    SECRET_REALM_INIT_VAR = "R$_SECRETREALMINITVAR",                     -- 秘境BOSS玩家变量初始化
    BIG_SECRET_REALM_INIT_VAR = "R$_BIGSECRETREALMINITVAR",              -- 大天使秘境玩家变量初始化
    FIRST_DROP_GLOBAL_RECORD = "R$_FIRST_DROP_GLOBAL_RECORD",            -- 装备首曝全局数据
    GLOBAL_DELETE_ROLE_INFO_UID = "R$_GLOBAL_DELETE_ROLE_INFO_UID_", --用户删除角色信息
}

-- 地图id常量
MapIdConst = {
    BRAVE_CONTINENT = 1001,
    FAIRY_TRAIL_FOREST = 1004
}

-- 时间单位常量（以秒为单位，换算毫秒需`* TimeUnit.MILLISECOND`）
TimeUnit = {
    SECOND = 1,        -- 1秒
    MINUTE = 60,       -- 1分钟 = 60秒
    HOUR = 3600,       -- 1小时 = 3600秒
    DAY = 86400,       -- 1天 = 86400秒
    WEEK = 604800,     -- 1周 = 604800秒
    MONTH = 2592000,   -- 1个月 = 2592000秒（假设30天）
    YEAR = 31536000,   -- 1年 = 31536000秒（假设365天）
    MILLISECOND = 1000 -- 1000毫秒
}

--脚本增加属性的系统类型
ScriptAttrType = {
    TRANSFER_CARD = "transfer_card_attr"
}

PetConstant = {
    Tian_Ying = 60000612, -- 天鹰怪物id
}

LimitSkillType = {
    TRANSFER_CARD = "transfer_card"
}

-- 天使天赋类型
AngelTalentType = {
    ATTR = 1, -- 属性类天赋
    SKILL = 2 -- 技能类天赋
}

ItemAction = {
    ANGEL_TALENT_RESET_COST = "大天使天赋点重置消耗",
    TURNTABLE_RAFFLE_COST = "轮盘抽奖消耗",
    CAREER_TRANSFER_COST = "职业转换消耗",
    MIRACLES_SOUL_KILL_REWARD = "奇迹之魂击杀奖励",
    EQUIP_REGENERATION_COST = "装备再生词条消耗",
    EQUIP_REGENERATION_EVOLUTION_COST = "装备再生词条进化消耗",
}

SkillType = {
    ACTIVE = 0, --主动
    PASSIVE = 1 --被动
}

BuffTag = {
    CONTROL = 1
}

BuffId = {
    -- 大天使经验药水buffId
    ANGEL_EXP_BOOST_ID = 30039701
}

BuffSource = {
    TRANSFER_CARD = 1
}
--- 埋点类型
LogOpType = {
    MONSTER_HUNT = 1,         --猎魔勋章结算
    ROLAND_SEIGE = 2,         --罗兰峡谷攻城战结算
    TRADE = 3,                --交易行
    CAREER_AND_ATTR = 4,      ---@deprecated 职业及属性            
    B_AND_D_CHALLENGE = 5,    ---@deprecated 血色恶魔挑战次数         
    SUM_EQUIP_GRADE = 6,      ---@deprecated 穿戴装备阶数和           
    SUM_EQUIP_STRENTH = 7,    ---@deprecated 穿戴装备强化等级和          
    SUM_EQUIP_APPEND = 8,     ---@deprecated 穿戴装备追加等级和         
    COMBO_SKILL_LEVEL = 9,    ---@deprecated 龙魂连击等级           
    TRANSFER_CARD_SCORE = 10, ---@deprecated 变身卡牌评分           
    KILL_BOSS = 13,           ---@deprecated 击杀BOSS数量          
    KILL_GOLD_BOSS = 14,      ---@deprecated 击杀黄金怪数量         
    KILL_NOMAR_MONSTER = 15,  ---@deprecated 击杀小怪数量
    COUNT = 16,               -- COUNT计数
}
--- 邮件配置id
EmailConfig = {
    TRADE_BUY = 106004,             -- 交易行购买商品邮件
    TRADE_SUCCESSFUL_SOLD = 106011, -- 交易行成功出售邮件
    TRADE_PRE_FAILED = 106006,      -- 交易行预购失败
}
--- 技能威力来源
SkillPowerSource = {
    PHYSICAL = 1, -- 物理攻击
    SPELL = 2,    -- 法术攻击
}

--- 数学类型
MathType = {
    FLOOR = 1, -- 向下取整
    CEIL = 2,  -- 向上取整
    ROUND = 3, -- 四舍五入
    ABS = 4,   -- 取绝对值
    MAX = 5,   -- 取最大值
    MIN = 6,   -- 取最小值
    MOD = 7,   -- 取余数
    POW = 8,   -- 取幂
    SQRT = 9,  -- 取平方根
}

ServerType = {
    Game = 1,
    Cross = 2,
    Battle = 3,
}

CareerType = {
    JIAN_SHI = 1,       -- 剑士
    MO_FA_SHI = 2,      -- 法师
    GONG_JIAN_SHOU = 3, -- 弓箭手
    MO_JIAN_SHI = 4,    -- 魔剑士
    SHENG_DAO_SHI = 5,  -- 圣导师
    ZHAO_HUO_SHI = 6,   --召唤师
    GUANG_MING_FA_SHI = 7,   --光明法师
}

-- 玩家传送分配模式
MapLineMode = {
    DEFAULT = 0;    --0或空、原先默认规则，优先1线
    RANDOM = 1;     --随机
    EVEN = 2;       --均匀
}



MonterTypeConst = {
    NOMER = 1,
    GOLD = 2,
    BOSS = 3,
}

AppendLvShow = {
    [1] = "Z4",
    [2] = "Z8",
    [3] = "Z12",
    [4] = "Z16",
}

AttributeMergeType = {
    ADD = 0,                -- 0=累加: 服务端生效概率=A+B
    DEC_MUL_1 = 1,          -- 1=相减累乘 1 : 服务端生效概率=1-(1-A)*(1-B)*(1-C)*…...(1-E)
}
