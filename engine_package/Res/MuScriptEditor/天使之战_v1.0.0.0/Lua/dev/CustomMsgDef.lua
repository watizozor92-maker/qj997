

local curNum = 0

local function MsgEnum(startNum)
    curNum = startNum or curNum + 1
	return curNum
end



---@class CustomMsgDef
CustomMsgDef = {

    BubbleExpMsg = MsgEnum(1000000),
    DecomposeMsg = MsgEnum(2000007),
    CReqTest2 = MsgEnum(),
    CReqTest3 = MsgEnum(),

}
---@class LuaMessageIdToClient
---@field GET_DAILY_ACTIVITY_INFO DailyActivity
---@field GET_DAILY_ACTIVITY_ACTIVITY_LIST DailyActivityActivity[]
---!!!!!!!!!!!!!!!!!!!!直接找服务器要，拷贝过来!!!!!!!!!!!!!!!!!!!!!
-- 发给客户端的消息id
LuaMessageIdToClient = {
    TIPS = 1000000, -- 统一tips，客户端直接显示msgData
    BOBBLE_POINT_SHOW = 1000100,
    PK_VALUE_CHANGE = 1000001,

    -- 装备相关
    GET_EQUIP_APPEAR = 1000002,          -- 获取装备外观
    GET_EQUIP_COLOR = 1000003,           -- 获取装备染色

    GET_DAILY_ACTIVITY_INFO = 1000004,   -- 获取每日目标信息
    GET_DAILY_ACTIVITY_REWARD = 1000005, -- 领取每日目标奖励
    GET_TITLE = 1000006,                 -- 获取称号信息
    MAP_MOVE_RESULT = 1000007,           -- 角色请求传送结果
    GET_SHAPE_RING = 1000008,            -- 获取变身戒指信息
    OTHER_ROLE_APPEAR = 1000009,         -- 其他玩家的外观信息

    TEAM_RECRUIT_CHANGE = 1000010,       -- 组队喊话信息发生改变

    HORSE_LAMP = 1000011,                -- 跑马灯
    STRENGTH_EQUIP_RESULT = 1000012,     -- 强化装备结果
    MONSTER_COUNT_RESULT = 1000013,      -- 根据地图信息获取怪物数量结果
    NEAREST_MONSTER = 1000014,           -- 获取最近的怪物坐标结果
    FRIEND_DEGREE_CHANGE = 1000015,      -- 好友好感度改变
    RES_DEVIL_SQUARE_PANEL = 1000016,    -- 恶魔广场面板数据回包
    APPEND_EQUIP_RESULT = 1000017,       -- 追加装备结果
    RES_ACTIVITY_LIST = 1000018,         -- 活动列表数据
    RES_ACTIVITY_CHANGE = 1000019,       -- 活动改变回包
    DEVIL_SQUARE_STATE = 1000020,        -- 恶魔广场阶段
    PLAYER_IS_ON_LINE_RES = 1000021,     -- 玩家是否在线回包
    COMMON_REWARD_PANEL = 1000022,       -- 通用奖励面板回包

    -- 守护相关
    EQUIP_GUARD_RES = 1000030,     -- 单个守护信息
    EQUIP_GUARD_ALL_RES = 1000031, -- 全部守护信息
    -- 守护相关

    GET_DAILY_ACTIVITY_ACTIVITY_LIST = 1000032, -- 获取每日目标活动列表

    SEND_RANK_DATA_TO_CLIENT = 1000033,         -- 排行榜数据回包
    RES_DEVIL_SQUARE_TASK = 1000034,            -- 恶魔广场任务数据

    SET_AUTO_BUY_POTION_RESULT = 1000035,       -- 设置自动购买药水结果
    CURRENT_AUTO_BUY_POTION_RESULT = 1000036,   -- 当前自动购买药水状态
    RES_TRANSFER_EQUIP = 1000037,               -- 转移装备属性响应
    RES_DEVIL_SQUARE_SETTLEMENT = 1000038,      -- 恶魔广场结算
    RES_QUIT_DUPLICATE = 1000039,               -- 退出副本回包

    RES_PRIVILEGE_RESULT = 1000040,             -- 获取特权项结果
    RES_CAN_TRANSFER = 1000041,                 -- 穿装后给客户端回转移属性包

    RES_SEND_GET_REWARD_MSG = 1000042,          -- [通用] 弹出领取奖励提示框
    RES_BLOODY_CASTLE_PANEL = 1000043,          -- 血色城堡面板信息响应
    RES_BLOODY_CASTLE_STATE_UPDATE = 1000045,   -- 血色城堡阶段响应
    CHAT = 1000046,                             -- 聊天框消息
    RES_BLOODY_CASTLE_TASK_UPDATE = 1000047,    -- 血色城堡任务响应

    PRIVILEGE_INFO_TIP = 1000048,               -- 特权提示

    RES_ITEM_DECOMPOSITION = 1000049,           -- 道具分解回包

    ---活动相关
    RES_GOLD_TASK_INFO = 1000050, -- 响应黄金任务信息

    -- 勇者试炼
    BRAVE_TEST_PANEL_INFO = 1000051,    -- 响应勇者试炼面板信息

    BLOODY_CASTLE_SWORD_VIEW = 1000052, -- 血色城堡大天使剑视野包

    -- 角色属性/果实
    C_USE_FRUIT_RESULT = 1000053,     -- 使用果实回包
    C_RESET_FRUIT_COUNT = 1000054,    -- 果实重置次数回包

    RES_GET_ACTIVITY_COUNT = 1000055, -- 活动剩余次数
    BRAVE_TEST_REWARD = 1000056,      -- 响应勇者试炼领取奖励

    RES_EQUIP_OVERLAY = 1000057,      -- 响应装备叠加结果

    -- 秘境副本
    SECRET_REALM_DAMAGE = 1000058,                   -- 秘境副本实时伤害
    SECRET_REALM_COUNT = 1000059,                    -- 秘境副本可挑战次数

    BRAVE_TEST_STATE = 1000060,                      -- 勇者试炼副本状态变化响应
    SETTING_TITLE_APPEAR = 1000061,                  -- 保存称号外观回包

    RES_UNION_ACTIVITY_DATA = 1000062,               -- 发送战盟活动数据
    RES_UNION_RUN_FOR_LEADER_DATA = 1000063,         -- 发送战盟竞选数据
    RES_GET_UNION_INFO = 1000064,                    -- 战盟信息

    SEND_SECRET_REALM_MONSTER_COUNT = 1000065,       -- 发送秘境副本怪物数量
    RES_PUTOON_RING = 1000066,                       -- 穿戴变身戒指
    RES_BLOODY_CASTLE_SETTLEMENT = 1000067,          -- 血色结算
    RES_EQUIP_FASHION = 1000068,                     -- 响应已激活幻化数据

    USE_FRUIT_RESULT = 1000069,                      -- 使用果实结果

    MONSTER_ATTACK_BOSS_INFO = 1000070,              -- 响应怪物来袭刷怪信息

    AFTER_ENTER_SECRET_REALM = 1000071,              -- 进入秘境副本成功

    RES_DUPLICATE_TEAM_INFO = 1000072,               -- 副本组队

    RES_PLAYER_RUN_FOR_LEADER = 1000073,             -- 玩家发起竞选
    RES_PLAYER_RUN_FOR_LEADER_VOTE = 1000074,        -- 玩家竞选投票
    RES_BREAK_DUPLICATE_TEAM = 1000075,              -- 副本组队解散
    RES_ACT_EQUIP_FASHION = 1000076,                 -- 外观激活回包
    RES_SETTING_EQUIP_APPEAR = 1000077,              -- 装备外观保存回包
    RES_UPDATE_EQUIP_ORNAMENTS = 1000078,            -- 装备首饰升级回包
    RES_UNLOCK_EQUIP_ORNAMENTS = 1000079,            -- 装备首饰属性解锁回包
    RES_ACT_EQUIP_ORNAMENTS = 1000080,               -- 装备首饰激活属性回包
    RES_ROLE_ATT_ADD_WAY = 1000081,                  -- 返回角色属性加成方式

    --SECRET_REALM_BOSS_LIST = 1000082,                -- 秘境BOSS列表信息
    BRAVE_TEST_STAGE_REWARD = 1000083,               -- 响应勇者试炼领取阶段大奖
    RES_ITEM_SYNTHESIS = 1000084,                    -- 返回装备合成信息
    SECRET_REALM_COUNT_ZEROED = 1000085,             -- 秘境挑战次数为零
    SECRET_REALM_HURT_TOP1 = 1000086,                -- 秘境挑战造成伤害排名第一信息
    OTHER_NOTICE = 1000087,                          -- 推送其他公告信息

    RES_SEND_UNION_ARMBAND_INFO = 1000088,           -- 发送战盟臂章信息
    RES_UNION_ARMBAND_LEVEL_UP = 1000089,            -- 战盟臂章等级提升
    RES_UNION_ARMBAND_STRONG = 1000090,              -- 战盟臂章强化

    RES_SEND_UNION_IMPEACH_INFO = 1000091,           -- 战盟弹劾推送信息
    RES_UNION_IMPEACH_LEADER = 1000092,              -- 战盟弹劾
    RES_UNION_IMPEACH_VOTE = 1000093,                -- 战盟弹劾投票

    RES_TRADE_LISTING_GOODS = 1000094,               -- 返回交易行上架
    RES_TRADE_OFF_GOODS = 1000095,                   -- 返回交易行下架
    RES_GET_TRADE_GOODS = 1000096,                   -- 返回交易行商品信息
    RES_TRADE_PUBLICITY_GOODS = 1000097,             -- 返回交易行公示区商品
    RES_TRADE_MY_PRE_GOODS = 1000098,                -- 返回交易行预购商品
    RES_TRADE_BUY_GOODS = 1000099,                   -- 返回交易行购买商品
    RES_TRADE_RECORD = 10000100,                     -- 返回交易行交易记录
    RES_TRADE_MY_SHELVES = 10000101,                 -- 返回交易行我上架信息
    RES_TRADE_PRE_ORDER = 10000102,                  -- 返回交易行预购商品

    TRIPLE_INCOME_INFO = 10000103,                   -- 响应三倍收益
    RES_GUARD_APPEAR = 10000104,                     -- 响应守护皮肤数据
    RES_EQUIP_REGENERATION = 10000105,               -- 响应装备再生
    RES_UP_REGENERATION_ATTR = 10000106,             -- 响应上一次再生词条

    RES_BOSS_BOUNTY_DATA = 10000107,                 -- 响应boss悬赏数据
    BOSS_BOUNTY_CHANGE = 10000108,                   -- 响应boss悬赏数据变化
    RES_REPLACE_REGENERATION_ATTR = 10000109,        -- 响应替换再生属性
    RES_STRENGTH_REGENERATION_ATTR = 10000110,       -- 响应强化再生属性
    RES_TITLE_CHANGE_UPDATE = 10000111,              -- 玩家称号变化视野包更新
    RES_RING_CHANGE_UPDATE = 10000112,               -- 玩家变身戒指变化视野包更新

    RES_UNION_LEADER_ON_LINE_STATE = 10000113,       -- 战盟盟主在线状态变动协议

    RES_RECHARGE_ITEM = 10000114,                    --充值获得的物品

    RES_ALL_MOUNT_INFO = 10000115,                   -- 返回全部坐骑信息
    RES_RIDING_MOUNT = 10000116,                     -- 返回骑乘坐骑
    RES_CANCEL_RIDING_MOUNT = 10000117,              -- 返回取消骑乘坐骑
    RES_MOUNT_STORE_TO_BAG = 10000118,               -- 返回脱下坐骑
    RES_MOUNT_BAG_TO_STORE = 10000119,               -- 返回穿戴坐骑
    RES_ALL_MOUNT_ATT_INFO = 10000120,               -- 返回全部坐骑属性信息

    RES_WAR_ALLIANCE_BOSS_PANEL = 10000121,          -- 战盟BOSS面板信息
    RES_WAR_ALLIANCE_OPEN_AUCTION = 10000122,        -- 战盟BOSS开启拍卖
    RES_WAR_ALLIANCE_AUCTION_GOODS = 10000123,       -- 战盟BOSS拍卖物品
    RES_WAR_ALLIANCE_AUCTION_UPDATE_INFO = 10000124, -- 战盟BOSS拍卖信息更新
    RES_WAR_ALLIANCE_STATE_INFO = 10000125,          -- 战盟BOSS状态信息
    RES_WAR_ALLIANCE_TASK_INFO = 10000126,           -- 战盟BOSS任务信息

    RES_KING_ROAD_TASK_INFO = 10000127,              -- 响应王道任务信息
    RES_KING_ROAD_TASK_CHANGE = 10000128,            -- 响应王道任务信息变化

    RES_WAR_ALLIANCE_OPEN_TRANSFER = 10000129,       -- 战盟BOSS开启玩家传送
    RES_PRIVILEGE_BOSS_PANEL = 10000130,             -- 特权BOSS面板信息响应
    RES_RED_FORTRESS_STATE_UPDATE = 10000131,        --赤色要塞阶段
    RES_RED_FORTRESS_PREPARE_COUNT = 10000132,       --赤色要塞准备阶段人数

    RES_MOUNT_PUT_ON_ITEM = 10000133,                -- 返回坐骑穿上装备
    RES_MOUNT_TAKE_OFF_ITEM = 10000134,              -- 返回座机脱下装备
    RES_MOUNT_DETAIL_INFO = 10000242,                 -- 返回坐骑信息
    RES_OFFLINE_ON_HOOK_INFO = 10000135,             -- 返回离线挂机信息

    -- 大师之路
    RES_MASTER_INFO = 10000136,                      -- 响应：大师信息
    RES_MASTER_CHANGE_INFO = 10000137,               -- 响应：大师变化信息
    RES_EXCHANGE_MASTER_EXP = 10000138,              -- 响应：兑换大师经验
    RES_OPEN_MASTER_TYPE = 10000139,                 -- 响应：启用大师系列
    RES_MASTER_RED_DOT_INFO = 10000140,              -- 响应：大师红点信息
    RES_GET_MONTHCARD_INFO = 10000141,               -- 响应获取月卡信息
    RES_MONTHCARD_CHANGE_INFO = 10000142,            -- 响应月卡变化信息
    RES_RECHARGE_TRADE_INFO = 10000193,              -- 交易行返回充值信息
    RES_GET_MONTH_PRIVILEGE_DATA = 10000143,         -- 获取获取月卡特权数据
    RES_CHECK_MONTH_PRIVILEGE_IS_OPEN = 10000144,    -- 检查月卡特权是否开启
    RES_MONTH_PRIVILEGE_TIME_OUT = 10000145,         -- 月卡特权过期
    RES_RED_FORTRESS_TASK_INFO = 10000146,           -- 赤色要塞任务面板信息
    RES_MONTHCARD_OVERTIME = 10000147,               -- 响应月卡过期提示
    RES_MONTHCARD_THREETIME = 10000148,              -- 响应领取三倍收益时间
    RES_PRIVILEGE_BOSS_STATUS = 10000149,            -- 特权BOSS状态返回

    RES_MAP_INFO = 10000150,                         --地图信息返回

    RES_WAR_ALLIANCE_EXIT = 10000151,                -- 战盟BOSS退出通知
    RES_RED_FORTRESS_SHRINKING_STAGE = 10000152,     --赤色要塞缩圈数据
    RES_CURRENT_RIDE_MOUNT = 10000153,               --返回当前骑乘坐骑id
    RES_RED_FORTRESS_KILL_RELIVE = 10000154,         --赤色要塞击杀或者复活提醒

    RES_GET_ROLE_ATTR_POINT_PROGRAMME = 10000155,    -- 获取加点方案数据
    RES_CHANGE_ROLE_ATTR_POINT_PROGRAMME = 10000156, -- 切换加点方案
    RES_RED_FORTRESS_SETTLEMENT_PANEL = 10000157,    -- 赤色要塞结算面板

    RES_OPEN_SERVER_FIRST_KILL_INFO = 10000158,      --开服活动首杀信息
    RES_GLOBAL_FIRST_KILL_CHANGE = 10000159,         --全服首杀变化消息
    RES_PERSONAL_FIRST_KILL_CHANGE = 10000160,       -- 个人首杀变化消息
    RES_MOUNT_LOGO = 10000161,                       -- 是否显示坐骑标志

    OPEN_SERVER_ACT_TYPE_RANK_INFO = 10000162,       -- 开服活动类型排行榜信息
    OPEN_SERVER_ACT_RANK_CHANGE = 10000163,          -- 开服活动类型排行榜数据变化消息
    OPEN_SERVER_ACT_REWARD_CHANGE = 10000164,        -- 开服活动玩家奖励变化信息
    RES_WAR_ALLIANCE_OPT_INFO = 10000165,            -- 战盟boss购买竞价操作信息回包
    RES_OTHER_MOUNT_RANK = 10000166,                 -- 返回其他人排行榜展示坐骑
    RES_WAR_ALLIANCE_SHOW_AUCTION_PANEL = 10000167,  -- 战盟boss拍卖面板是否显示

    RES_UNION_TASK_DATA = 10000168,                  -- 战盟任务数据
    RES_UNION_TASK_CHANGE = 10000169,                -- 战盟任务变化
    RES_SUBMIT_UNION_TASK = 10000170,                -- 提交战盟任务
    MONSTER_COUNT_RESULT_BY_ID = 10000171,           -- 根据BOSS表id获取怪物数量结果
    RES_GEM_SCHEME = 10000172,                       -- 萤石方案(包含石板)

    RES_SERVER_ID_INFO = 10000173,                   --玩家的服务器ID发送给目标

    RES_IN_OUT_CROSS_MAP = 10000174,                 --玩家进入退出跨服地图通知
    RES_GEM_CURRENT_SCHEME = 10000175,               -- 萤石当前方案详情(包含石板)
    RES_WOLF_SOUL_PREPARE_PANEL = 10000176,          -- 狼魂要塞准备阶段信息

    RES_GODS_DESCENDED_DATA = 10000177,              -- 发送诸神降临信息
    RES_GODS_DESCENDED_MONSTER_STATE_CHANGE = 10000178,     -- 诸神降临怪物状态变化
    RES_WOLF_SOUL_FIGHT_PANEL = 10000179,            -- 狼魂要塞战斗阶段面板信息
    RES_WOLF_SOUL_STATE = 10000180,                  -- 狼魂要塞阶段信息

    RES_STALL_POSITION = 10000182,                      -- 返回地图摆摊位置
    RES_WOLF_SOUL_SETTLEMENT_PANEL = 10000183,          -- 狼魂要塞结算面板
    RES_START_STALL = 10000184,                         -- 返回开始摆摊
    RES_END_STALL = 10000185,                           -- 返回结束摆摊
    RES_STALL_INFO = 10000186,                          -- 返回摊位信息
    RES_STALL_GOODS = 10000187,                         -- 返回摊位商品信息
    RES_QUIT_SECRET_REALM = 10000188,                   -- 返回秘境退出信息
    RES_PRIVILEGE_MONTH_BUBBLE_DATA = 10000189,         -- 月卡特权气泡数据

    RES_FSPREVIEW_LIST = 10000191,                      -- 拍脸预告
    RES_ROLE_IS_FIRST_CHANGE_NAME = 10000192,           -- 角色是否为首次改名
    RES_GEM_RECOVERY_HP_INFO = 10000194,                -- 萤石效果飘字
    RES_RECHARGE_ACTION                  = 10000200, -- 响应充值档位信息
    RES_ALL_COUNT_INFO  = 10000198,                     -- 玩家身上所有Count数据
    RES_UPDATE_COUNT_INFO = 10000199,                   -- 单个Count数据更新
    RES_TASK_STATES_TO_FUNC_ON = 10000201,              -- 任务控制系统功能
    RES_ALL_SERVER_FIRST_KILL_INFO          = 10000202, -- 响应全服首杀和红包数据
    RES_RECEIVE_FIRST_KILL_ENVELOPE         = 10000203, -- 响应领取全服首杀红包
    RES_RECEIVE_PERSONAL_FIRST_KILL_AWARD   = 10000204, -- 响应领取个人黄金首杀奖励
    RES_GOAL_FIRST_KILL_CHANGE              = 10000205, -- 黄金首杀任务变化包

    ---变身卡牌
    RES_TRANSFER_CARD_PART_INFO = 10000197,         -- 变身卡牌部位信息响应，响应信息
    RES_TRANSFER_CARD_BAG = 10000207,               -- 变身卡牌背包信息响应
    RES_TRANSFER_CARD_MODEL_VIEW = 10000228,        -- 变身视野包
    RES_TRANSFER_CARD_CD = 10000229,                -- 变身CD
    RES_TRANSFER_CARD_REWARD_PANEL = 10000237,      -- 变身卡牌奖励面板
    RES_TRANSFER_CARD_DURATION = 10000250,          -- 变身持续时间
    RES_CARD_BREAKTHROUGH_FAIL = 10000275,          -- 卡牌突破失败
    RES_TRANSFER_CARD_SETTING = 10000277,           -- 挂机变身设置信息
    --绑定手机号 每日抽奖
    RES_BIND_PHONE                          = 10000208, -- 绑定手机号相应
    RES_LUCK_DRAW                           = 10000209, -- 返回每日抽奖
    RES_LUCK_DRAW_INFO                      = 10000210, -- 返回每日抽奖信息
    RES_PRIVILEGE_CARD_ACTIVATION           = 10000211, -- 返回新开启特权卡信息
    RES_GENERATE_VERIFICATION_CODE          = 10000214, -- 返回验证码信息

    RES_PREFERENTIAL_BUTTON_PANEL_INFO      = 10000213, -- 返回优惠礼包显示按钮信息
    RES_EXP_BONUS_INFO = 10000212,                      -- 返回经验加成信息
    RES_TIME_LIMIT_GIFT                     = 10000215, -- 响应限时礼包
    RES_ALL_TIME_LIMIT_GIFT                 = 10000216, -- 响应所有限时礼包
    RES_EFFECIENCY_TAB_ACTIVE               = 10000217, -- 响应效率条件激活
    RES_EFFECIENCY_RED_DOT                  = 10000218, -- 响应效率页面红点信息
    RES_EFFECIENCY_REWARD_RESULT            = 10000219, -- 响应效率奖励领取结果
    --大天使福利
    RES_ANGLE_BENEFIT_INFO                  = 10000220, -- 响应大天使福利所有信息
    RES_RECEIVE_ANGLE_BENEFIT_REWARD        = 10000221, -- 响应领取大天使积分奖励
    RES_SUBMIT_ANGLE_BENEFIT_TASK           = 10000222, -- 响应提交大天使任务
    RES_ANGLE_BENEFIT_TASK_CHANGE           = 10000223, -- 响应大天使任务变化
    
    RES_PERSONAL_LEVEL_REWARD_INFO          = 10000226, -- 响应个人等级信息
    RES_RECEIVE_LEVEL_REWARD                = 10000227, -- 响应领取等级奖励
    
    RES_LOGIN_REWARD_INFO_CHANGE            = 10000231, -- 登录奖励数据变化包
    RES_RECEIVE_LOGIN_REWARD                = 10000232, -- 响应领取登录奖励

    RES_COMPETITION_RANK_INFO               = 10000224, -- 响应开服竞技排行信息
    RES_SINGLE_CHALLENGE_INFO        = 10000225, -- 响应开服竞技个人挑战领取信息
    RES_ANGEL_WEAPON_TASK_CHANGE            = 10000233, -- 响应大天使武器任务变化 
    RES_COMMON_REWARD_PANEL_WITH_PARAM      = 10000236, -- 通用奖励面板回包(支持传递类型和参数)

    RES_WINGS_TASK_INFO                     = 10000234, -- 响应翅膀任务信息
    RES_WINGS_TASK_CHANGE                   = 10000235, -- 响应翅膀任务信息变化

    RES_ANGEL_EQUIPMENT_ATTR_INFO           = 10000206, -- 响应天使装备成长属性信息
    RES_ANGEL_TALENT_INFO                   = 10000230, -- 响应天使天赋信息
    RES_ALL_ANGEL_EQUIPMENT_ATTR_INFO       = 10000238, -- 响应所有天使装备成长属性信息
    RES_ANGEL_EQUIPMENT_CAN_BREAK           = 10000239, -- 响应天使装备可以突破
    RES_ANGEL_TALENT_ACTIVE_INFO            = 10000240, -- 响应天赋大师激活的id
    RES_ANGEL_EQUIPMENT_BREAK_RESULT        = 10000195, -- 响应大天使装备突破结果
    RES_DESTROY_ANGEL_EQUIPMENT             = 10000248, -- 响应删除大天使装备

    RES_COMBO_SKILL_MODEL_VIEW = 10000241,              -- 连击技能视野包
    RES_NPC_CHEST_GOODS_INFO                = 10000243,  -- 返回袖珍罐子商品信息

    COMBO_TEST_PANEL_INFO                   = 10000244, -- 响应连击试炼面板信息
    COMBO_TEST_STATE                        = 10000245, -- 连击试炼副本状态变化响应
    RES_COMBO_TES_TASK_UPDATE               = 10000246, -- 连击试炼任务响应
    COMBO_REWARD_PANEL                      = 10000247, -- 连击奖励面板回包

    RES_COMMON_RED_POINT_MESSAGE            = 10000249, -- 服务器显示红点通用消息

    RES_GET_RECYCLING_TYPE                  = 10000251, -- 返回回收类型
    RES_BIG_SECRET_REALM_PANEL_INFO           = 10000252, -- 响应大天使秘境面板信息
    RES_BIG_SECRET_REALM_TASK_UPDATE          = 10000253, -- 响应大天使秘境任务更新
    RES_BIG_SECRET_REALM_CLEARANCE_PANEL_INFO = 10000254, -- 响应大天使秘境通关奖励弹窗信息
    RES_BIG_SECRET_REALM_RECEIVE_STATUS       = 10000255, -- 响应大天使秘境是否默认领取奖励
    RES_BIG_SECRET_REALM_KEY_LEVEL            = 10000256, -- 响应大天使秘境钥匙等级

    RES_RECHARGE_LOGIN_INFO_CHANGE          = 10000257, -- 充值七天登录奖励数据变化包
    RES_RECEIVE_RECHARGE_LOGIN_REWARD       = 10000258, -- 响应领取充值七天登录奖励
    RES_RECOVERY_REWARD                     = 10000259, -- 回收完成返回
    RES_MONSTER_FIRST_ATTACK_OWNER_CHANGE   = 10000260, --怪物首刀归属
    RES_CROSS_MAP_TRANSFER_TO_NPC           = 10000261, -- 跨服地图传送到NPC
    
    RES_GRAIL_ENTRY_INFO                    = 10000262, -- 响应天使圣杯词条信息
    RES_ALL_GRAIL_INFO                      = 10000263, -- 响应所有大天使圣杯信息
    RES_GRAIL_ENTRY_STRENGTHEN_RESULT       = 10000264, -- 响应天使圣杯词条强化结果
    RES_EQUIP_ALL_ENTRY_INFO                = 10000265, -- 响应天使装备镶嵌的所有圣杯词条信息
    RES_GRAIL_DECOMPOSE_RESULT              = 10000266, -- 响应天使圣杯分解结果
    RES_OTHER_ANGE_EQUIP_INFO               = 10000267, -- 响应其他角色大天使装备信息
    RES_OTHER_ANGE_GRAIL_INFO               = 10000268, -- 响应其他角色大天使圣杯信息
    RES_USE_SELF_CHOICE_BOX                 = 10000269, -- 打开自选宝箱响应
    RES_ANGEL_EQUIP_EXP_BOOST_INFO          = 10000270, -- 响应大天使装备经验加成信息
    RES_PLAYER_ENTER_VIEW_INFO              = 10000271, -- 响应玩家进入视野
    RES_ENTER_BIG_SECRET_REALM              = 10000272, -- 响应进入大天使秘境
    RES_MONSTER_HUNT_INFO                   = 10000273, -- 响应猎魔积分信息
    RES_MONSTER_HUNT_RANK                   = 10000274, -- 响应猎魔积分排行榜
    RES_MAIN_ACTIVE_INFO                    = 10000276, -- 响应：运营活动基础信息
    RES_TURNTABLE_RAFFLE_FREE_TIME            = 10000278, -- 响应转盘抽奖免费时间信息
    RES_TURNTABLE_RAFFLE_REWARD_IDS           = 10000279, -- 响应转盘抽奖奖励id列表
    RES_TURNTABLE_RAFFLE_REWARD_COUNT_INFO    = 10000280, -- 响应转盘抽奖奖励id列表
    RES_ROLAND_SEIGE_MAIN_PANEL               = 10000281, -- 响应罗兰攻城战主面板
    RES_ROLAND_SEIGE_STATE                    = 10000282, -- 响应罗兰攻城战副本阶段
    RES_GRAIL_RANKING_INFO                    = 10000283, -- 响应圣杯排行榜信息
    RES_GRAIL_RANKING_WORSHIP_INFO            = 10000284, -- 响应圣杯排行榜膜拜信息
    RES_ROLAND_SEIGE_TASK_PANEL               = 10000285, -- 响应罗兰攻城战任务面板信息
    RES_PLAYER_EQUIP_GRAIL_INFO               = 10000286, -- 响应指定玩家装备圣杯信息
    RES_ROLAND_PROGRESS_INFO                  = 10000287, -- 响应罗兰攻城战占领进度
    RES_ROLAND_MONSTER_LIST                   = 10000288, -- 响应罗兰攻城战地图怪物信息
    RES_EQUIP_OPT_ENTRY_INFO                  = 10000289, -- 响应穿脱天使装备时的装备圣杯词条信息
    RES_KUN_DUN_PANEL_INFO                    = 10000290, -- 响应昆顿面板数据
    RES_KUN_DUN_AUCTION_BUY_RESULT            = 10000291, -- 响应昆顿竞拍购买结果
    RES_KUN_DUN_AUCTION_PANEL_INFO            = 10000292, -- 响应昆顿竞拍面板信息
    RES_WORLD_CHAT_SUCCESS                    = 10000293, -- 响应世界喊话成功
    RES_WEAPON_CHANGE_AUTO                    = 10000294, -- 响应玩家武器自动调换
    RES_ROLE_SETTINGS                         = 10000295, -- 响应玩家基础设置
    RES_CUSTOME_TRANSFER                      = 10000296, -- 响应自定义传送
    RES_EQUIP_BIND_DATA_CHANGE                = 10000297, -- 响应装备bind数据变化
    RES_TARGET_VIP_LV                         = 10000298, -- 响应目标VIP等级
    RES_WEEKEN_GIFT                           = 10000299, -- 响应幸运周末活动
    RES_WEEK_TURNTABLE_RAFFLE_FREE_TIME       = 10000300, -- 响应幸运周末转盘抽奖免费时间信息
    RES_WEEK_TURNTABLE_RAFFLE_REWARD_IDS      = 10000301, -- 响应幸运周末转盘抽奖奖励id列表
    RES_WEEK_TURNTABLE_RAFFLE_REWARD_COUNT_INFO = 10000302, -- 响应幸运周末转盘抽奖奖励抽中次数
    RES_CAREER_TRANSFER_SUCCESS               = 10000303, -- 响应角色转职道具使用成功
    RES_FIRST_DROP_PANEL                       = 10000350, -- 响应装备首曝面板信息
    RES_EQUIP_SUIT_CHART                       = 10000450, -- 响应：装备套装图鉴
    RES_RIDE_OR_DOWN_MOUNT                     = 10000400, -- 骑乘或卸下坐骑
    RES_UP_LEVEL_MOUNT                         = 10000401, -- 升级坐骑
    RES_SET_MOUNT                              = 10000402, -- 设置默认坐骑
    RES_GET_ALL_MOUNT                          = 10000403, -- 获取所有坐骑
    RES_ACTIVE_MOUNT                           = 10000404, -- 激活坐骑
    RES_NO_SPEC_PRIVILEGE                      = 10000500, -- 响应: 特权不足
    --消息提示 移植
    AGAndSD_MsgID                              = 90001034,
    LianJi_MsgID                               = 90001025,    --连击系统
    TaskLoopMessage                            = 90015003,  --跑环任务
    MESSAGE_INFO                               = 90015002, -- 消息提示
    
    RES_SHORTCUTS_INFO                         = 10000550, -- 响应外置快捷栏信息
    RES_EQUIP_AUTO_REPAIR_STATE                = 10000600, -- 响应:自动修理状态
    RES_ELITE_MM                               = 10000650, -- 响应：精英MM
    RES_PICK_ITEM_SETTING                      = 10000700, -- 响应：自定义道具拾取
    RES_PLAYER_PRIVILEGES                      = 10000750, -- 响应玩家特权
    RES_ACTIVE_EQUIP_LUCKY_RESULT              = 10000800, -- 响应：激活装备幸运结果 
    RES_AUTO_BUY_POTION_SETTINGS               = 10000850, -- 响应：自动买药设置

    RES_THROWS_ITEM_TRANSFER                   = 10000900, -- 响应：丢道具传送

    RES_EQUIP_REFINE_RESULT                    = 10000950, -- 响应：装备洗练
    RES_EQUIP_REFINE_GEM_INFO                  = 10000951, -- 响应: 装备宝石洗练
    RES_EQUIP_RESTORE_GEM_INFO                 = 10000952, -- 响应: 装备还原宝石

    RES_BUFF_VALUES                            = 10001000, -- 响应：buff值
    RES_DURABILITY_CHANGE                      = 10001050, -- 响应：耐久度变化
    RES_NPC_BUFF_CD                            = 10001100, -- 响应：幻影导师npc交互回包
    RES_SYNTHESIS_PUT_BAG                      = 10001150, -- 响应：合成放入背包
    RES_BING_FENG_BAO                          = 10001250, -- 响应：冰封堡
    RES_CREATE_ROLE                            = 10001350,            -- 响应：创角成功

    RES_FACE_TRADE_APPLY                       = 10001300, -- 响应：面对面交易申请
    RES_FACE_TRADE_START                       = 10001301, -- 响应：面对面交易开始
    RES_FACE_TRADE_SUCCESS                     = 10001302, -- 响应：面对面交易成功
    RES_FACE_TRADE_CANCEL                      = 10001303, -- 响应：面对面交易取消
    RES_FACE_TRADE_UPDATE                      = 10001304, -- 响应：面对面交易交易栏更新
    RES_ATK_SPEED_ATTR                         = 10001400, -- 响应：攻速属性视野消息

    RES_TEAM_EQUIP_INFO                        = 10001500, -- 响应：组队装备信息
    RES_DELETE_ROLE_LIMIT                      = 10001550,-- 响应：是否可以删除角色
    RES_GET_TEAM_MEMBER_POSITION    = 10001600,            -- 响应：获取队友位置
    RES_UNION_DETAILS_INFO          = 10001650,            -- 响应：获取战盟详细信息
    RES_REGENERATION_RESULT                    = 10001651, -- 响应：再生词条生成结果
    RES_REGENERATION_EVOLUTION_RESULT          = 10001652, -- 响应：再生词条进化
    RES_KALIMA_TEMP_PANEL_INFO                 = 10001653, -- 响应：卡利马神庙面板信息
    KALIMA_TEMP_STATE                          = 10001654, -- 响应：卡利马神庙状态变化
    RES_CALIMA_TEMP_TASK_UPDATE                = 10001655, -- 响应：卡利马神庙任务响应
}
-- 服务器接收的消息id
LuaMessageIdToSever = {

    -- 装备相关
    SETTING_EQUIP_APPEAR = 2000001, -- 装备外观|幻化保存
    GET_EQUIP_APPEAR = 2000002, -- 获取装备外观
    EQUIP_FASHION = 2000003, -- 激活装备幻化
    ACT_EQUIP_COLOR = 2000004, -- 激活装备染色
    GET_EQUIP_COLOR = 2000005, -- 获取装备染色
    SETTING_EQUIP_COLOR = 2000006, -- 保存装备染色
    REQ_ITEM_DECOMPOSITION = 2000007, -- 装备分解
    GET_DAILY_ACTIVITY_INFO = 2000008, -- 获取每日目标信息
    GET_DAILY_ACTIVITY_REWARD = 2000009, -- 领取每日目标奖励
    GET_TITLE = 2000010, -- 获取称号信息
    SET_TITLE = 2000011, -- 保存称号信息
    REQ_MAP_MOVE = 2000012, -- 角色请求传送
    GET_SHAPE_RING = 2000013, -- 获取变身戒指信息
    SET_SHAPE_RING = 2000014, -- 穿戴变身戒指
    GET_TEAM_RECRUIT = 2000015, -- 获取组队招募信息
    REQ_STRENGTH_EQUIP = 2000016, -- 请求强化装备

    GET_MOUNSTER_COUNT_BY_MAP = 2000017, -- 根据地图信息获取怪物数量
    GET_NEAREST_MONSTER = 2000018, -- 获取最近的怪物坐标
    SET_FRIEND_DEGREE = 2000019, -- 设置好友好感度
    GET_DEVIL_SQUARE_PANEL = 2000020, -- 恶魔广场面板数据
    REQ_ENTER_DUPLICATE = 2000021, -- 请求进入副本
    REQ_APPEND_EQUIP = 2000022, -- 请求追加装备
    GET_DAILY_ACTIVITY_ACTIVITY_LIST = 2000023, -- 获取每日目标活动列表
    REQ_CHANGE_DUPLICATE_STATE = 2000024, -- 修改副本状态

    LOAD_RANK_DATA = 2000026, -- 请求排行榜数据
    STOP_REFRESH_RANK_DATA = 2000027, -- 停止自动刷新排行榜数据

    OPEN_OR_CLOSE_AUTO_BUY_POTION = 2000030, -- 打开或关闭自动购买药水
    PLAYER_IS_ON_LINE_REQ = 2000031, -- 玩家是否在线请求
    RECRUIT_INFO_REQ = 2000032, -- 招募信息请求

    GET_CURRENT_AUTO_BUY_POTION = 2000033, -- 当前自动购买药水状态
    REQ_QUIT_DUPLICATE = 2000034, -- 请求退出副本
    REQ_TRANSFER_EQUIP = 2000035, -- 请求转移装备属性

    GET_PRIVILEGES = 2000036, -- 获取已有的特权信息

    REQ_RECIVE_DEVIL_SQUARE_REWARD = 2000037, -- 请求领取恶魔广场通关奖励
    LEADER_AGREE_APPLY = 2000038, -- 组队队长一键同意申请列表
    REQ_BLOODY_CASTLE_PANEL = 2000039, -- 请求血色城堡面板数据

    -- 勇者试炼
    BRAVE_TEST_PANEL_INFO = 2000040, -- 请求勇者试炼面板信息

    ---活动相关
    GET_GOLD_TASK_INFO = 2000041, -- 获取黄金任务信息
    FLUSH_GOLD_TASK_POOL = 2000042, -- 刷新黄金任务池
    ACCEPT_GOLD_TASK = 2000043, -- 接取黄金任务
    SUBMIT_GOLD_TASK = 2000044, -- 提交黄金任务
    GIVE_UP_GOLD_TASK = 2000045, -- 放弃黄金任务

    -- 角色属性/果实
    GET_RESET_FRUIT_COUNT = 2000046, -- 获取重置果实次数
    S_RESET_FRUIT = 2000047, -- 重置果实

    REQ_GET_ACTIVITY_COUNT = 2000048, -- 活动剩余次数
    BRAVE_TEST_REWARD = 2000049, -- 勇者试炼领取奖励

    REQ_EQUIP_OVERLAY = 2000050, -- 请求装备叠加

    -- 秘境副本
    REQ_ENTER_SECRET_REALM = 2000051, -- 请求进入秘境副本
    REQ_EXIT_SECRET_REALM = 2000052, -- 请求离开秘境副本
    REQ_GET_SECRET_REALM_COUNT = 2000053, -- 请求秘境挑战次数

    GET_ALREADY_USE_POINTS = 2000054, -- 获取已使用果实点数

    REQ_UNION_ACTIVITY_DATA = 2000055, -- 获取战盟活动数据
    REQ_UNION_RUN_FOR_LEADER_DATA = 2000056, -- 战盟竞选数据
    REQ_GET_UNION_INFO = 2000057, -- 战盟信息
    REQ_BLOODY_CASTLE_GIVE_NPC = 2000058, -- 血色交付大天使武器

    GET_SECRET_REALM_MONSTER_COUNT = 2000059, -- 获取秘境副本怪物数量
    REQ_RECIVE_BLOODY_CASTLE_SETTLEMENT = 2000060, -- 领取血色结算奖励
    REQ_EQUIP_FASHION = 2000061, -- 请求已激活幻化数据

    MONSTER_ATTACK_BOSS_INFO = 2000062, -- 怪物来袭刷怪信息

    REQ_PLAYER_RUN_FOR_LEADER = 2000063, -- 玩家发起竞选
    REQ_PLAYER_RUN_FOR_LEADER_VOTE = 2000064, -- 玩家竞选投票
    REQ_CHANGE_DUPLICATE_TEAM_STATE = 2000065, -- 修改副本队伍状态
    REQ_DUPLICATE_TEAM_ENTER = 2000066, -- 组队进入副本
    REQ_UPDATE_EQUIP_ORNAMENTS = 2000067, -- 装备首饰升级请求
    REQ_UNLOCK_EQUIP_ORNAMENTS = 2000068, -- 装备首饰属性解锁请求
    REQ_ACT_EQUIP_ORNAMENTS = 2000069, -- 装备首饰激活属性请求

    REQ_SET_ROLE_ATT_ADD_WAY = 2000070, -- 设置角色属性加成方式
    REQ_GET_ROLE_ATT_ADD_WAY = 2000071, -- 获取角色属性加成方式

    BRAVE_TEST_STAGE_REWARD = 2000072, -- 勇者试炼领取阶段大奖

    GET_SECRET_REALM_MONSTER_LIST = 2000073, -- 获取秘境副本怪物列表信息

    REQ_ITEM_SYNTHESIS = 2000074, -- 请求装备合成

    REQ_SECRET_REALM_HURT_TOP1 = 2000075, -- 请求获取秘境副本指定怪物伤害第一信息

    REQ_GET_UNION_ARMBAND_INFO = 2000076, -- 请求战盟臂章信息
    REQ_UNION_ARMBAND_LEVEL_UP = 2000077, -- 请求战盟臂章升级
    REQ_UNION_ARMBAND_STRONG = 2000078, -- 请求战盟臂章强化

    REQ_GET_UNION_IMPEACH_INFO = 2000079, -- 请求战盟弹劾信息
    REQ_UNION_IMPEACH_LEADER = 2000080, -- 发起弹劾
    REQ_UNION_IMPEACH_VOTE = 2000081, -- 弹劾投票

    REQ_TRADE_LISTING_GOODS = 2000082, -- 请求交易行上架
    REQ_TRADE_OFF_GOODS = 2000083, -- 请求交易行下架
    REQ_GET_TRADE_GOODS = 2000084, -- 获取交易行商品信息
    REQ_TRADE_PUBLICITY_GOODS = 2000085, -- 获取交易行公示区商品
    REQ_TRADE_MY_PRE_GOODS = 2000086, -- 获取交易行预购商品
    REQ_TRADE_BUY_GOODS = 2000087, -- 请求交易行购买商品
    REQ_TRADE_RECORD = 2000088, -- 获取交易行交易记录
    REQ_TRADE_MY_SHELVES = 2000089, -- 获取交易行我上架信息
    REQ_TRADE_PRE_ORDER = 2000090, -- 请求交易行预购商品

    TRIPLE_INCOME_RECEIVE = 2000091, --领取三倍收益时间
    TRIPLE_INCOME_RETURN = 2000092, --归还三倍收益时间
    GET_GUARD_APPEAR = 2000093, -- 获取守护皮肤信息
    REQ_EQUIP_REGENERATION = 2000094, -- 请求装备再生
    REQ_UP_EQUIP_REGENERATION = 2000095, -- 请求装备上次洗练数据
    TRIPLE_INCOME_PANEL = 2000096, -- 三倍收益数据信息

    REQ_BOSS_BOUNTY_DATA = 2000097, -- 请求BOSS悬赏数据
    REQ_BOUNTY_MONSTER_REWARD = 2000098, -- 请求领取boss悬赏怪物奖励
    REQ_BOUNTY_GROUP_REWARD = 2000099, -- 请求领取boss悬赏层级奖励
    REQ_REPLACE_REGENERATION_ATTR = 2000100, -- 请求替换再生属性
    REQ_STRENGTH_REGENERATION_ATTR = 2000101, -- 请求强化再生属性

    REQ_ALL_MOUNT_INFO = 2000102, -- 获取全部坐骑信息
    REQ_RIDING_MOUNT = 2000103, -- 请求骑乘坐骑
    REQ_CANCEL_RIDING_MOUNT = 2000104, -- 请求取消骑乘坐骑
    REQ_MOUNT_STORE_TO_BAG = 2000105, -- 请求脱下坐骑
    REQ_MOUNT_BAG_TO_STORE = 2000106, -- 请求穿戴坐骑
    REQ_TRADE_GOODS_INFO = 2000107, -- 获取交易行商品信息

    REQ_KING_ROAD_TASK_INFO = 2000108, -- 请求王者之路任务信息
    REQ_SUBMIT_KING_ROAD_TASK = 2000109, -- 请求提交王者之路任务
    REQ_RECEIVE_KING_ROAD_CHAPTER_AWARD = 2000110, -- 请求领取王者之路章节奖励

    REQ_WAR_ALLIANCE_PANEL_INFO = 2000111, -- 请求战盟boss面板数据
    REQ_WAR_ALLIANCE_GOODS_DETAIL = 2000112, -- 请求战盟boss商品详情
    REQ_WAR_ALLIANCE_BID_GOODS = 2000113, -- 请求战盟boss竞拍商品
    REQ_WAR_ALLIANCE_BUY_NOW = 2000114, -- 请求战盟boss一口价购买
    REQ_WAR_ALLIANCE_UPDATE_GOODS = 2000115, -- 请求战盟boss更新商品
    REQ_PRIVILEGE_BOSS_PANEL = 2000116, -- 请求特权BOSS面板信息

    REQ_MOUNT_PUT_ON_ITEM = 2000117, -- 坐骑穿上装备
    REQ_MOUNT_TAKE_OFF_ITEM = 2000118, -- 座机脱下装备
    REQ_MOUNT_DETAIL_INFO = 2000119, -- 坐骑信息
    REQ_OFFLINE_ON_HOOK_INFO = 2000120, -- 请求获取离线挂机信息
    REQ_RECEIVE_OFFLINE_ON_HOOK_EXP = 2000121, -- 请求领取离线挂机经验奖励

    -- 大师之路
    REQ_MASTER_INFO = 2000122, -- 请求：大师信息
    REQ_OPEN_MASTER_TYPE = 2000123, -- 请求：启用大师系列
    REQ_EXCHANGE_MASTER_EXP = 2000124, -- 请求：兑换大师经验
    REQ_RESET_MASTER = 2000125, -- 请求：重置大师天赋
    REQ_UPGRADE_MASTER_TALENT = 2000126, -- 请求：升级大师天赋

    REQ_ENTER_WAR_ALLIANCE = 2000127, -- 请求进入战盟boss副本
    REQ_GET_MONTHCARD_INFO = 2000128, -- 请求获取月卡信息
    REQ_RECHARGE_TRADE_INFO = 2001576, -- 请求交易行充值信息
    REQ_GET_MONTH_PRIVILEGE_DATA = 2000129, -- 请求获取月卡特权数据
    REQ_CHECK_MONTH_PRIVILEGE_IS_OPEN = 2000130, -- 请求检查月卡特权是否开启
    REQ_EXCHANGE_MONTH_PRIVILEGE = 2000131, -- 请求兑换月卡特权
    REQ_RECEIVE_MONTHCARD_THREETIME = 2000132, -- 请求领取月卡三倍收益时间

    REQ_EXIT_WAR_ALLIANCE = 2000133, -- 请求退出战盟boss

    REQ_MAP_INFO = 2000134, --地图信息请求
    REQ_SET_MOUNT_IS_SHOW = 2000135, --设置坐骑是否隐藏

    REQ_GET_ROLE_ATTR_POINT_PROGRAMME = 2000136, -- 获取属性点方案
    REQ_SET_ROLE_ATTR_POINT_PROGRAMME = 2000137, -- 设置属性点方案
    REQ_CHANGE_ROLE_ATTR_POINT_PROGRAMME = 2000138, -- 修改属性方案
    REQ_UP_SHELF_MONTHCARD = 2000139, -- 请求上架月卡

    REQ_OPEN_SERVER_FIRST_KILL_INFO = 2000140, --请求开服活动首杀数据
    RECEIVE_GLOBAL_FIRST_KILL_AWARD = 2000141, --领取全服首杀奖励
    RECEIVE_PERSONAL_FIRST_KILL_AWARD = 2000142, --领取个人首杀奖励
    PRIVILEGE_BOSS_COUNT_INIT = 2000143, --初始化特权BOSS挑战次数
    REQ_SET_MOUNT_RANK = 2000144, --设置坐骑是否显示在排行榜
    REQ_BUY_MONTH_CARD = 2000145, --请求购买月卡
    CUSTOM_PLAYER_REVIVE = 2000146, --请求自定义复活

    REQ_OPEN_SERVER_ACT_TYPE_RANK_INFO = 2000147, --请求开服活动类型排行榜信息
    REQ_OPEN_SERVER_ACT_RANK_REWARD = 2000148, --请求领取开服活动类型排行榜奖励
    REQ_OPEN_SERVER_ACT_PERSONAL_REWARD = 2000149, --请求领取开服活动个人奖励
    REQ_OTHER_MOUNT_RANK = 2000150, -- 请求其他人排行榜展示坐骑
    REQ_WAR_ALLIANCE_HAS_QUALIFY = 2000151, -- 请求战盟boss是否能显示竞拍面板

    --组队相关
    REQ_TEAM_JOIN = 2000161,            -- 请求加入组队
    REQ_TEAM_AGREE_JOIN = 2000162,      -- 请求同意加入组队
    --组队相关 END
    REQ_UNION_TASK_DATA = 2001552, -- 请求战盟任务数据
    REQ_SUBMIT_UNION_TASK = 2001553, -- 请求提交战盟任务
    REQ_MONSTER_COUNT_BY_ID = 2001554, -- 请求获取怪物数量

    REQ_GOTO_CROSS_MAP = 2001555, --进入跨服神之国度
    REQ_GEM_PUT_ON = 2001556, -- 萤石/石板镶嵌请求
    REQ_GEM_TAKE_OFF = 2001557, -- 萤石/石板卸载请求
    REQ_SCHEME_SWITCH = 2001558, --  方案切换请求
    REQ_SCHEME_INFO = 2001559, --  方案详情请求

    REQ_OPEN_SERVER_ACT_RANK_ALL_REWARD = 2001560, --请求领取开服活动一键领取

    REQ_GODS_DESCENDED_DATA = 2001561, -- 请求诸神降临列表数据
    REQ_KUNDUN_ENTER = 2001562, -- 请求进入昆顿
    REQ_WOLF_SOUL_SUMMON = 2001563, -- 狼魂要塞请求召唤守卫
    REQ_STALL_POSITION = 2001564, -- 获取地图摆摊位置
    REQ_START_STALL = 2001565, -- 开始摆摊
    REQ_END_STALL = 2001566, -- 结束摆摊
    REQ_STALL_GOODS = 2001567, -- 获取摊位商品信息
    REQ_DELETE_BAG_ITEM = 2001568, -- 消耗背包内道具的数量
    REQ_SET_PATROL = 2001569, -- 设置挂机模式的接口  巡逻状态:1 原地状态:2 无状态:0
    REQ_ITEM_RECOVERY = 2001570, -- 装备回收

    REQ_CANCEL_FSPREVIEW = 2001571, -- 拍脸预告今日不再提示
    REQ_CHANGE_ROLE_NAME = 2001573, -- 请求更新角色名字
    REQ_CHANGE_UNION_NAME = 2001574, -- 请求更新战盟名字

    REQ_RECHARGE = 2001572, -- 请求代币充值

    REQ_ROLE_IS_FIRST_CHANGE_NAME = 2001575, -- 请求角色是否为首次改名

    REQ_COMBO_SKILL_UP = 2001577, -- 请求升级连击技能
    REQ_RECHARGE_ACTION = 2001583, -- 商业化通用消息
    REQ_OTHER_GEM_EQUIP_INFO = 2001584, -- 请求其他玩家装备的萤石/石板信息
    REQ_ALL_SERVER_FIRST_KILL_INFO = 2001585, -- 请求全服首杀和红包数据
    REQ_RECEIVE_FIRST_KILL_ENVELOPE = 2001586, -- 请求领取全服首杀红包
    REQ_RECEIVE_PERSONAL_FIRST_KILL_AWARD = 2001587, -- 请求领取个人首杀奖励

    ---变身卡牌
    REQ_TRANSFER_CARD_PART_INFO = 2001580, -- 变身卡牌请求部位信息
    REQ_TRANSFER_CARD_UNLOCK = 2001582, -- 变身卡牌请求解锁孔位
    REQ_TRANSFER_CARD_BAG = 2001588, -- 变身卡牌请求背包信息
    REQ_TRANSFER_CARD_EXCHANGE = 2001589, -- 变身卡牌兑换
    REQ_TRANSFER_CARD_SYNTHESIS = 2001594, -- 卡牌合成
    REQ_TRANSFER_CARD_RECOVER = 2001595, -- 卡牌回收
    REQ_TRANSFER_CARD_INLAY = 2001596, -- 卡牌镶嵌
    REQ_TRANSFER_CARD_PUTOFF = 2001597, -- 卡牌拆卸
    REQ_TRANSFORMATION = 2001611, -- 请求变身
    REQ_SYNTHESIS_ALL_CARD = 2001650, -- 请求一键合成卡牌 {卡牌类型，等级}
    REQ_BREAKTHROUGH_CARD = 2001651, -- 请求卡牌突破
    REQ_BREAKTHROUGH_CARD_ALL = 2001652, -- 请求一键卡牌突破 {卡牌类型，等级}
    REQ_TRANSFER_CARD_HANG_UP_SETTING = 2001654, -- 请求变身修改设置

    --绑定手机号 每日抽奖
    REQ_GENERATE_VERIFICATION_CODE = 2001590, -- 请求生成验证码
    REQ_BIND_PHONE = 2001591, -- 绑定手机号
    REQ_LUCK_DRAW = 2001592, -- 请求每日抽奖
    REQ_LUCK_DRAW_INFO = 2001593, -- 请求每日抽奖信息
    REQ_BUY_TIME_LIMIT_GIFT = 2001598, -- 请求购买限时礼包
    REQ_SAVE_EFFECIENCY_RED_DOT = 2001599, -- 保存效率页面红点
    REQ_GET_EFFECIENCY_REWARD = 2001600, -- 领取效率奖励
    REQ_CHECK_EFFECIENCY_ACTIVE = 2001601, -- 检查效率页面激活内容
    --大天使福利
    REQ_ANGLE_BENEFIT_INFO = 2001602, -- 获取大天使福利所有信息
    REQ_RECEIVE_ANGLE_BENEFIT_REWARD = 2001603, -- 请求领取大天使积分奖励
    REQ_SUBMIT_ANGLE_BENEFIT_TASK = 2001604, -- 请求提交大天使任务

    REQ_PERSONAL_LEVEL_REWARD_INFO = 2001609, -- 请求个人等级信息
    REQ_RECEIVE_LEVEL_REWARD = 2001610, -- 请求领取等级奖励

    REQ_RECEIVE_LOGIN_REWARD = 2001612, -- 请求领取登录奖励

    -- 请求开服竞技排行信息
    REQ_COMPETITION_RANK_INFO = 2001605, -- 请求开服竞技排行信息
    REQ_SINGLE_CHALLENGE_INFO = 2001606, -- 请求开服竞技个人挑战领取信息
    REQ_SINGLE_CHALLENGE_AWARD = 2001607, -- 请求领取开服竞技个人挑战奖励
    REQ_BUY_DISCOUNTS_GIFT = 2001608, -- 请求购买开服竞技特惠礼包
    REQ_RECEIVE_ANGEL_WEAPON_REWARD = 2001613, -- 请求领取大天使武器奖励

    REQ_WINGS_TASK_INFO = 2001614, -- 请求翅膀任务信息
    REQ_SUBMIT_WINGS_TASK = 2001615, -- 请求提交翅膀任务
    REQ_RECEIVE_WINGS_CHAPTER_AWARD = 2001616, -- 请求领取翅膀章节奖励

    REQ_BREAK_ANGEL_EQUIP = 2001617, -- 请求突破天使装备
    REQ_ANGEL_TALENT = 2001619, -- 请求天使天赋树信息
    REQ_ADD_ANGEL_TALENT_POINT = 2001620, -- 请求加点天使天赋
    REQ_RESET_ANGEL_TALENT_POINT = 2001621, -- 请求重置天使天赋点
    REQ_ACTIVE_ANGEL_TALENT = 2001622, -- 请求激活天使天赋大师
    REQ_ANGEL_EQUIP_ATTR = 2001625, -- 请求获取指定大天使装备的属性

    REQ_NPC_CHEST_GOODS_INFO = 2001623, -- 请求袖珍罐子商品信息
    REQ_BUY_NPC_CHEST = 2001624, -- 请求购买袖珍罐子商品

    KALIMA_TEMP_PANEL_INFO = 2001626, -- 请求连击试炼面板信息
    COMBO_TEST_REWARD = 2001627, -- 连击试炼领取奖励
    REQ_SWEEP_THROUGH_DUNGEONS = 2001628, -- 扫荡副本

    REQ_SETTING_RECYCLING_TYPE = 2001629, -- 设置回收类型
    REQ_GET_RECYCLING_TYPE = 2001630, -- 获取回收类型

    REQ_TRANSFER_WITHIN_MAP = 2001631, -- 地图内定点传送

    REQ_BIG_SECRET_REALM_PANEL_INFO = 2001632, -- 获取大天使秘境面板信息
    REQ_BIG_SECRET_REALM_CHANGE_RECEIVE_STATUS = 2001633, -- 修改大天使秘境是否默认领取奖励
    REQ_BIG_SECRET_REALM_KEY_LEVEL_UP = 2001634, -- 请求大天使秘境钥匙升级
    REQ_BIG_SECRET_REALM_RECEIVE_REWARD = 2001635, -- 请求领取大天使秘境奖励


    REQ_RECEIVE_RECHARGE_LOGIN_REWARD = 2001636, -- 请求领取充值七天登录奖励
    REQ_BIG_SECRET_REALM_SWEEP = 2001637, -- 请求扫荡大天使秘境

    REQ_CROSS_MAP_TRANSFER_TO_NPC = 2001638, -- 请求跨服传送到NPC
    REQ_SANCTUARY_BOSS_ENTER_MAP = 2001639, -- 请求进入圣域地图

    REQ_GET_ANGEL_GRAIL_INFO = 2001640, -- 请求获取天使圣杯信息
    REQ_INLAY_ANGEL_GRAIL = 2001641, -- 请求镶嵌天使圣杯
    REQ_UNLOAD_ANGEL_GRAIL = 2001642, -- 请求卸掉天使圣杯
    REQ_STRENGTHEN_ANGEL_GRAIL = 2001643, -- 请求强化天使圣杯
    REQ_GET_EQUIP_ALL_ENTRY_INFO = 2001644, -- 请求装备下所有圣杯词条信息
    REQ_ANGEL_GRAIL_DECOMPOSE = 2001645, -- 请求大天使圣杯分解
    REQ_USE_SELF_CHOICE_BOX = 2001646, -- 使用自选宝箱
    REQ_OTHER_ANGE_EQUIP_INFO = 2001647, -- 请求其他角色大天使装备信息
    REQ_OTHER_ANGE_GRAIL_INFO = 2001648, -- 请求其他角色大天使圣杯信息
    REQ_MONSTER_HUNT_RANK = 2001649, -- 请求猎魔积分排行榜
    REQ_MONSTER_HUNT_INFO = 2001653, -- 请求猎魔积分信息
    REQ_MAIN_ACTIVE_INFO = 2001655, -- 请求：运营活动基础信息
    REQ_CHANGE_SKIP_ANIMATION = 2001656, -- 请求修改转盘抽奖是否跳过动画
    REQ_TURNTABLE_RAFFLE_DRAWING = 2001657, -- 请求转盘抽奖
    REQ_RECEIVE_TURNTABLE_RAFFLE_REWARD = 2001658, -- 请求领取转盘抽奖累次奖励
    REQ_TURNTABLE_REWARD_COUNT_INFO = 2001659, -- 请求装盘抽奖奖励次数信息
    REQ_ROLAND_SEIGE_GET_MAIN_PANEL = 2001660, -- 请求罗兰攻城战主面板
    REQ_ANGEL_GRAIL_RANKING_INFO = 2001661, -- 请求大天使圣杯排行榜信息
    REQ_WORSHIP_ANGEL_GRAIL_RANKING = 2001662, -- 请求膜拜大天使圣杯排行榜
    REQ_PLAYER_EQUIP_GRAIL_INFO = 2001663, -- 请求指定玩家的大天使装备与圣杯信息
    REQ_REMAINING_ANGE_GRAIL_INFO = 2001664, -- 请求剩余的大天使圣杯信息
    REQ_KUN_DUN_AUCTION_BIDDING = 2001665, -- 昆顿玩家请求竞拍
    REQ_UPDATE_ROLE_SETTING = 2001666, -- 请求更新角色设置
    REQ_CUSTOME_TRANSFER = 2001667, -- 请求自定义传送
    REQ_TARGET_VIP_LV = 2001668, -- 请求目标VIP等级
    REQ_CLOSE_DEMON_HERMIT_SKILL = 2001669, -- 请求关闭恶魔召唤技能
    REQ_WEEKEN_ACTIVE_INFO = 2001670, -- 请求幸运周末活动信息
    REQ_WEEK_CHANGE_SKIP_ANIMATION = 2001671, -- 请求修改幸运周末转盘抽奖是否跳过动画
    REQ_WEEK_TURNTABLE_RAFFLE_DRAWING = 2001672, -- 请求幸运周末转盘抽奖
    REQ_WEEK_RECEIVE_TURNTABLE_RAFFLE_REWARD = 2001673, -- 请求领取幸运周末转盘抽奖累次奖励
    REQ_WEEK_TURNTABLE_REWARD_COUNT_INFO = 2001674, -- 请求装盘幸运周末抽奖奖励次数信息
    REQ_CAREER_TRANSFER = 2001675, -- 请求职业转换
    REQ_FIRST_DROP_PANEL = 2001700, -- 请求装备首曝信息
    REQ_ACTIVE_SUIT_CHART = 2001800, -- 请求：激活套装图鉴 参数：{id=配置表id}
    REQ_GET_ALL_MOUNT = 2001750, -- 坐骑_请求获取所有坐骑信息
    REQ_ACTIVE_MOUNT = 2001751, -- 坐骑_请求激活坐骑
    REQ_RIDE_OR_DOWN_MOUNT = 2001752, -- 坐骑_请求骑乘或卸下坐骑
    REQ_UP_LEVEL_MOUNT = 2001753, -- 坐骑_请求坐骑升级
    REQ_SET_MOUNT = 2001754, -- 坐骑_请求设置默认坐骑}
    REQ_ACTIVITY_INFO                          = 2001850, -- 请求：活动信息
    LianJi_MsgID = 90001025,
    REQ_EQUIP_REPAIR                           = 2001950, -- 请求：装备修理
    REQ_EQUIP_AUTO_REPAIR                      = 2001951, -- 请求：勾选与取消勾选自动修理
    REQ_PICK_UP_NAMES                          = 2002000, -- 请求：设置拾取名称
    REQ_ACTIVATE_EQUIP_LUCKY                   = 2002050, -- 请求：激活装备幸运
    REQ_AUTO_BUY_POTION_OPTION                 = 2002100, -- 请求：设置买药选项   
    REQ_GET_PICK_UP_SETTINGS                   = 2002001, -- 请求：获取拾取设置

    REQ_MAP_MOVE_TRANSFER                      = 2002150, -- 请求：cfg_mapMove传送，指定线
    REQ_THROWS_ITEM_TRANSFER                   = 2002151, -- 请求：丢道具传送
    
    REQ_EQUIP_REFINE                           = 2002200, -- 请求：装备洗练
    REQ_NPC_ADD_BUFF                           = 2002300, -- 请求：幻影导师npc交互
    REQ_VIEW_PANEL_TASK                        = 2002350, -- 请求：点击界面（任务用）

    REQ_SYNTHESIS_PUT_BAG                      = 2002400, -- 请求：合成放入背包
    REQ_SYNTHESIS_YING_SHI                     = 2002401, -- 请求：荧石合成
    REQ_SHOW_OR_HIDDEN_MOUNT                   = 2001754, -- 坐骑_请求显示或隐藏坐骑
    REQ_BING_FENG_BAO                          = 2002450, -- 请求：冰封堡相关
    REQ_AUTO_RANGE_PICKUP                      = 2002500, -- 请求：根据道具id自动范围拾取物品

    REQ_FACE_TRADE_APPLY                       = 2002550, -- 请求：面对面交易申请  targetRid
    REQ_FACE_TRADE_AGREE                       = 2002551, -- 请求：面对面交易同意
    REQ_FACE_TRADE_REJECT                      = 2002552, -- 请求：面对面交易拒绝
    REQ_FACE_TRADE_ADD_ITEM                    = 2002553, -- 请求：面对面交易添加物品 {itemId = itemId, index = index}
    REQ_FACE_TRADE_ADD_CURRENCY                = 2002554, -- 请求：面对面交易添加货币 {currencyId = currencyId, amount = amount}
    REQ_FACE_TRADE_REMOVE_ITEM                 = 2002555, -- 请求：面对面交易移交易栏除物品 itemId
    REQ_FACE_TRADE_TOGGLE_LOCK                 = 2002556, -- 请求：面对面交易切换锁定
    REQ_FACE_TRADE_TOGGLE_CONFIRM              = 2002557, -- 请求：面对面交易切换确认
    REQ_FACE_TRADE_CANCEL                      = 2002558, -- 请求：面对面交易取消

    REQ_TEAM_EQUIP_INFO                        = 2002600, -- 请求：队伍装备信息
    REQ_CUSTOM_TRANSFER                        = 2002152, -- 请求：自定义传送-新
    REQ_CHECK_DELETE_ROLE                     = 2002650,-- 请求：检查是否可以删除角色
    REQ_GET_TEAM_MEMBER_POSITION  = 2002700,               -- 请求：获取队友位置
    REQ_GET_UNION_DETAILS         = 2002750,               -- 请求：获取战盟详细信息
    REQ_EQUIP_REFINE_GEM                       = 2002201, -- 请求: 装备洗练石洗练
    REQ_EQUIP_RESTORE_GEM                      = 2002202, -- 请求: 装备装备还原宝石
    REQ_BAG_PROPS_SPLIT                        = 2002203, -- 请求: 背包道具拆分
    REQ_REGENERATION                           = 2002751, -- 请求装备再生词条生成
    REQ_EQUIP_REGENERATION_EVOLUTION           = 2002752, -- 请求装备再生词条进化
    KALIMA_TEMP_PANEL_INFO                     = 2002753, -- 请求卡利马神庙面板信息

    REQ_ACCEPT_PLAYER_CAREER_TASK            = 2002754,   -- 请求领取职业任务
}



    

---!!!!!!!!!!!!!!!!!!!!直接找服务器要，拷贝过来!!!!!!!!!!!!!!!!!!!!!

