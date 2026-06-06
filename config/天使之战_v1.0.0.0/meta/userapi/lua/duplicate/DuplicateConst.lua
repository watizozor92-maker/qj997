-- 副本类型
DuplicateType = {
    DEVIL_SQUARE = 10001,
    BLOODY_CASTLE = 11001,
    BRAVE_TEST = 12001,
    MONSTER_ATTACK = 13001,
    WAR_ALLIANCE = 14001,
    WOLF_SOUL = 15001,
    RED_FORTRESS = 17001,
    PRIVILEGE_BOSS = 18001,
    BIG_SECRET_REALM = 19001,
    KUN_DUN = 21001,
    DIVINE_TRADE_ROUTE = 22001,
    GODS_DESCENDED = 23001,
    COMBO_TEST = 24001,
    KALIMA_TEMP = 25001,
    ROLAND_SEIGE = 16001,
    SECRET_REALM_BOSS = 26001,
    BING_FENG_BAO = 28001,
}

-- 副本阶段
DuplicateState = {
    PREPARE = 1, --准备阶段
    FIGHT = 2,   --战斗阶段
    FINISH = 3,  --结算阶段
    CLOSED = 4,  -- 副本销毁
}

-- 设置副本阶段
SetDuplicateStateConst = {
    TO_FIGHT = 1,  --转为战斗阶段
    TO_FINISH = 2, --转为结算阶段
    TO_CLOSED = 3  --副本关闭并销毁
}

-- 限制进入检查结果
EnterLimitResultConst = {
    ALLOW = 1, -- 允许
    LEVEL = 2, -- 等级不足
    COUNT = 3, -- 活动次数不足
    ITEM = 4,  -- 道具不足
    REFUSE = 5 --拒绝
}

-- 副本全局表id
RepGlobalConfig = {
    PREPARE_MAX_COUNT = 10001001,
    DEVIL_SQUARE_SCORE_EXP = 10001003,
    DEVIL_SQUARE_MULTIPLE_REWARD = 10001005,
    BLOODY_CASTLE_GATE_MONSTER = 11001003,
    BLOODY_CASTLE_CRYSTAL_MONSTER = 11001005,
    BLOODY_CASTLE_MULTIPLE_REWARD = 11001006,
    BRAVE_TEST_LEVEL = 12001001,
    --@Deprecated WOLF_SOUL_ALL_REPID = 15001001,
    WOLF_SOUL_HATE_TO_PLATFORM = 15001002,
    bigSecretRealm = {
        -- 大秘境钥匙itemID
        KEY_ID = 19001001,
        -- 通关后，钥匙默认升级时间，单位秒
        KEY_LEVEL_UP_TIMEOUT = 19001002,
        -- 奖励领取次数
        REWARD_COUNT = 19001003,
        -- 通关后，奖励默认不领取时间，单位秒
        REWARD_TIMEOUT = 19001004,
        -- 大秘境挑战刷新时间：1#X，每天X点刷新；2#X，每周一早上X点刷新
        REFRESH_TIME = 19001005,
        -- 大秘境开启扫荡条件
        SWEEP_CONDITION = 19001006,
    },
    ROLAND_SEIGE = {
        FIRST_OPEN_TIME = 16001001,
        NEED_UNION_SIZE = 16001002,
        TRANSFER_POINT = 16001003,
        FIRST_TASK = 16001005,
        AOE_DAMAGE_FIX = 16001006,
        DEFEND_RELIVE_POINT = 16001007,
        ATTACK_RELIVE_POINT = 16001008,
        OCCUPY_PROGRESS_TIME = 16001012,
        OCCUPY_AREA = 16001013,
        PERSONAL_REWARD = 16001014,
        LEADER_REWARD = 16001015,
        WIN_UNION_REWARD = 16001016,
        FAIL_UNION_REWARD = 16001017,
        PERSONAL_LIMIT_SCORE = 16001020,
        ATTACK_BUILDING_SCORE = 16001022,
        KILL_SCORE = 16001023,
        HURT_SCORE = 16001024,
        OCCUPY_SCORE = 16001025,
        STAY_SCORE = 16001026,
    },
    KALIMA_TEMP = {
        SWEEP_TIME = 27000001,
    },
}

-- 副本对象数据的key(结合setenvirvar命令使用)
DuplicateVarConst = {
    DEVIL_SQUARE_MONSTER_GEN_CONFIG = "1001", -- 恶魔广场刷怪配置id
    DEVIL_SQUARE_STATE_KILL_COUNT = "1002",   -- 恶魔广场当前波次的击杀数量
    DEVIL_SQUARE_STATE = "1003",              -- 恶魔广场当前波次
    DEVIL_SQUARE_NEXT_STATE_TIME = "1004",    -- 恶魔广场下一波次时间
    BLOODY_CASTLE_TASK_INFO = "2001",         -- 血色城堡当前任务数据
    BLOODY_CASTLE_TASK_PHASE = "2002",        -- 血色城堡当前任务阶段
    RED_FORTRESS_FIGHT_AREA = "7001",         -- 赤色要塞战斗区域
    RED_FORTRESS_PHASE = "7002",              -- 赤色要塞阶段
    WOLF_SOUL_GEN_MONSTER = "15001",          -- 狼魂要塞刷怪信息
    WOLF_SOUL_ALL_PLAYERS = "15002",          -- 狼魂要塞参与玩家信息
    WOLF_SOUL_WARDER_COUNT = "15003",         -- 狼魂要塞召唤物数量
    WOLF_SOUL_STATUE = "15004",               -- 狼魂要塞神狼雕像
    BIG_SECRET_REALM_TASK_INFO = "19001",     -- 大秘境当前任务数据
    COMBO_TEST_TASK_INFO = "20001",           -- 连击试炼当前任务数据
    ROLAND_SEIGE = {
        PLAYER_KEY_PREFIX = "ROLAND_RID_",    -- 罗兰攻城战玩家积分前缀
        UNION_SCORE_PREFIX = "ROLAND_UNION_", -- 罗兰攻城战战盟积分前缀
        DEFEND_TASK = "16001",                -- 罗兰攻城战守方任务
        ATTACK_TASK = "16002",                -- 罗兰攻城战攻方任务
        DEFEND_UNION = "16003",               -- 罗兰攻城战守方战盟ID
        ALL_MONSTER = "16004",                -- 罗兰攻城战所有怪物
    },
    KALIMA_TEMP_TASK_INFO = "20001",          -- 卡利马神庙当前任务数据
}

-- 恶魔广场玩家变量
DevilSquarePlayerConst = {
    DEVIL_SQUARE_MAP_INFO = "T$当前参与恶魔广场的信息",
    KILL_MONSTER_COUNT = "T$恶魔广场击杀怪物数量",
    KILL_MONSTER_EXP = "T$恶魔广场杀怪经验"
}

-- 血色城堡玩家变量
BloodyCastlePlayerConst = {
    BLOODY_CASTLE_MAP_INFO = "T$当前参与血色城堡的信息",
    KILL_MONSTER_COUNT = "T$血色城堡击杀怪物数量",
    KILL_MONSTER_EXP = "T$血色城堡杀怪经验",
    ARCHANGEL_SWORD_ID = "T$大天使宝剑ID"
}

--赤色要塞玩家变量
RedFortressPlayerConst = {
    MAP_INFO = "T$当前参与赤色要塞的信息",
    RELIVE_TIMES = "T$赤色要塞复活次数",
    KILL_SCORES = "T$赤色要塞击杀积分",
    KILL_COUNT = "T$赤色要塞击杀数量",
    PLAYER_RANK = "T$赤色要塞排名",
}

-- 血色城堡当前任务阶段
BloodyCastleTaskPhase = {
    ONE = 1,
    TWO = 2,
    THREE = 3,
    FOUR = 4,
    FIVE = 5
}

-- 大天使秘境当前任务阶段
BigSecretRealmTaskPhase = {
    ONE = 1,
    TWO = 2,
    THREE = 3,
}

-- 副本任务类型
DuplicateTaskType = {
    KILL_MONSTER_COUNT = 1,  -- 击杀指定数量的怪
    KILL_TARGET_MONSTER = 2, -- 击杀指定id的怪
    PICK_TARGET_ITEM = 3,    -- 血色拾取道具
    ROLAND_SEIGE_OCCUPY = 5  -- 罗兰攻城战占点
}

-- Boss类型
BossType = {
    GOLD_BOSS = 1,        -- 黄金boss
    FIELD_BOSS = 2,       -- 野外boss
    SECRET_REALM_BOSS = 3 -- 秘境boss
}

-- 副本刷新类型
FlushType = {
    DAY = 1, -- 按天刷新
    WEEK = 2 -- 安周刷新
}



RolandConst = {
    CAMP_TYPE = {
        ATTACK = 1,
        DEFEND = 2,
    }
}
