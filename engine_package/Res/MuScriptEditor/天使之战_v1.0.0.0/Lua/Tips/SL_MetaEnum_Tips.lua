---@author 卢玉轩
---@see SL
---元变量枚举
local this = SL

---@class EMetaVarSetKey
EMetaVarSetKey = {
    MAIL_CURRENT_ID = "MAIL_CURRENT_ID", --(已实现)
    -----------------------原变量设置-----------------------
    ---当前聊天频道(当前聊天频道只有聊天界面上的，先这么处理一下，感觉不合理)
    CUR_CHAT_CHANNEL = "CUR_CHAT_CHANNEL",
    ---设置选择的目标ID
    ---@param param1 number 目标角色 ID
    SELECT_TARGET_ID = "SELECT_TARGET_ID", --(已实现)
    ---设置战斗模式（请用EMetaVarSetKey.SET_PKMODE代替）
    ---@param param1 EPKMode PK 模式
    ATTACK_STATE = "ATTACK_STATE",
    FUNCDOCK_PARAM = "FUNCDOCK_PARAM",
    CLIPBOARD_TEXT = "CLIPBOARD_TEXT",
    DROPITEM_FLY_WORLD_POSITION = "DROPITEM_FLY_WORLD_POSITION",
    QUICK_USE_NUM = "QUICK_USE_NUM",
    GUIDE_EVENT_BEGAN = "GUIDE_EVENT_BEGAN",
    GUIDE_EVENT_END = "GUIDE_EVENT_END",
    INTERNAL_SKILL_ONOFF = "INTERNAL_SKILL_ONOFF",
    ---修改PC端屏幕分辨率
    ---@param param1 number 宽
    ---@param param2 number 高
    ---@param param3 boolean 是否全屏 (可选，默认 true)
    WIN_DEVICE_SIZE = "WIN_DEVICE_SIZE",
    STALL_SELECT_ID = "STALL_SELECT_ID",
    PC_CHAT_INPUT_FILL = "PC_CHAT_INPUT_FILL",
    TEAM_STATUS_PERMIT = "TEAM_STATUS_PERMIT",
    ADD_STATUS_PERMIT = "ADD_STATUS_PERMIT",
    DEAL_STATUS_PERMIT = "DEAL_STATUS_PERMIT",
    SHOW_STATUS_PERMIT = "SHOW_STATUS_PERMIT",
    ---设置主角朝向
    TURN_DIR = "TURN_DIR", --(已实现)
    USER_TO_MOVE = "USER_TO_MOVE",
    ---设置PC持续攻击目标ID（不确认和选择目标是不是同一个） --与 EMetaVarSetKey.SELECT_TARGET_ID 功能重复
    SELECT_SHIFT_ATTACK_ID = "SELECT_SHIFT_ATTACK_ID", --(已实现)
    DROP_TYPE_ISRECEIVE = "DROP_TYPE_ISRECEIVE",
    AUTOUSE_MAKEINDEX_BY_POS = "AUTOUSE_MAKEINDEX_BY_POS",
    ---开始自动挂机:返空
    BATTLE_AFK_BEGIN = "BATTLE_AFK_BEGIN", --(已实现)
    ---结束自动挂机:返空
    BATTLE_AFK_END = "BATTLE_AFK_END", --(已实现)
    ---开始自动寻路
    ---@param mapID number 地图ID cfg_map_info表可为string
    ---@param mapX number 坐标x可为string
    ---@param mapY number 坐标y可为string
    BATTLE_MOVE_BEGIN = "BATTLE_MOVE_BEGIN", --(已实现)
    ---结束自动寻路
    BATTLE_MOVE_END = "BATTLE_MOVE_END", --(已实现)
    ---设置挂机拾取道具类型都为可拾取
    BATTLE_PICK_BEGIN = "BATTLE_PICK_BEGIN", --(已实现)
    ---设置挂机拾取道具类型都为不可拾取
    BATTLE_PICK_END = "BATTLE_PICK_END", --(已实现)
    ---@param param1 number @hurtType,cfg_damage_number配置表id
    ---@param param2 @customType 可选--XAXISMOVECURVE YAXISMOVECURVE ALPHACURVE SCALECURVE ALIGNTYPE
    ---@param param3 number @曲线运行速度,默认1
    ---@param param4 number @动画曲线偏移值
    ---@param param5 number @参数alignType 对齐方式(Fill 方向 0:Center 1:Left 2 Right)
    SET_HURT_STYLE = "SET_HURT_STYLE", --(已实现)--设置战斗飘字样式
    ---param1 @hurtType cfg_damage_number配置表id
    ---param2 @customType 可选--XAXISMOVECURVE YAXISMOVECURVE ALPHACURVE SCALECURVE
    RESET_HURT_STYLE = "RESET_HURT_STYLE", --(已实现)--重置战斗飘字样式
    RESETALL_HURT_STYLE = "RESETALL_HURT_STYLE", --(已实现)--重置所有战斗飘字样式
    ---@param param1 float @持续时间，秒
    SET_HURT_DURATIONTIME = "SET_HURT_DURATIONTIME", --(已实现)--飘字持续时间
    --- 刷新装备流光
    ---@param go UnityEngine.GameObject | "control" 对象或测试标识
    ---@param streamCfgId number 流光配置 ID
    EQUIP_STREAMER_REFRESH = "EQUIP_STREAMER_REFRESH", --(已实现)  ---刷新装备流光
    --- 连击技能释放
    COMBOSKILL_RELEASE = "COMBOSKILL_RELEASE", --(已实现)  ---连击技能释放
    --- 连击技能替换
    ---@param skills table
    ---@param level number
    COMBOSKILL_CHANGE = "COMBOSKILL_CHANGE", --(已实现)    ---连击技能替换
    --- 连击技能开关
    ---@param isOpen boolean
    COMBOSKILL_SWITCH = "COMBOSKILL_SWITCH", --(已实现)    ---连击技能开关
    ---设置连击技能进度值
    ---@param value number
    COMBOSKILL_SET_VALUE = "COMBOSKILL_SET_VALUE", ---设置连击值
    NPC_NAME_OFFSET = "SET_NPC_NAME_OFFSET",
    ---设置快捷栏数据
    ---@param index number 快捷栏索引
    ---@param id number 物品/技能 ID（0 表示清空）
    ---@param type number 类型指明道具还是技能
    FAST_ITEM_ID_LIST = "FAST_ITEM_ID_LIST", ---快速使用道具列表
    ---设置技能展示类型
    ---@param param1 number 展示类型
    SKILL_SETTING_SHOW_TYPE = "SKILL_SETTING_SHOW_TYPE", --获取技能展示类型 ESkillType
    ---设置技能轮盘展示的技能
    ---@param tbl table 技能数据表
    SKILL_SHOW_LIST = "SKILL_SHOW_LIST", ----根据展示类型设置技能id列表
    ---设置当前PK模式
    ---@param pkMode EPKMode
    ---@param isSave boolean 是否保存设置 (可选，默认 true)
    SET_PKMODE = "SET_PKMODE", -- (已实现)设置当前PK模式
    ---设置是否不能更改PK模式
    ---@param isNotChangePKMode boolean
    SET_ISNOTCHANGEPKMODE = "SET_ISNOTCHANGEPKMODE", -- (已实现)设置是否不能更改PK模式
    ---设置背景声音音量
    ---@param value number
    SET_BACKGROUND_SOUND = "SET_BACKGROUND_SOUND", --(已实现)设置背景声音音量
    ---设置音效音量
    ---@param value number
    SET_SOUND_EFFECT = "SET_SOUND_EFFECT", --(已实现)设置音效音量
    ---设置语音音量
    ---@param value number @设置的音量（0~100之间）
    SET_VOICE = "SET_VOICE", --(已实现)设置语音音量
    ---设置摇杆类型
    ---@param value ETickModel 1 固定，2 移动
    SET_ROCKER_TYPE = "SET_ROCKER_TYPE", --(已实现)设置摇杆类型
    ---设置杀怪范围
    ---@param value number @范围，1~8之间
    ---@param isSave boolean @是否保存设置到服务器
    SET_KILL_RANGE = "SET_KILL_RANGE", --(已实现)设置杀怪范围
    ---设置自动吃加血药百分比值
    ---@param value number
    SET_EAT_HP_PILL_PERCENTAGE = "SET_EAT_HP_PILL_PERCENTAGE", --(已实现)设置自动吃加血药百分比值
    ---设置自动吃加蓝药百分比值
    ---@param value number
    SET_EAT_MP_PILL_PERCENTAGE = "SET_EAT_MP_PILL_PERCENTAGE", --(已实现)设置自动吃加蓝药百分比值
    ---设置是否自动反击
    ---@param value boolean
    SET_IS_COUNTERATTACK = "SET_IS_COUNTERATTACK", --(已实现)设置是否自动反击
    ---设置挂机是否返回原点
    ---@param value boolean
    SET_IS_COMEBACK_HOOKPOINT = "SET_IS_COMEBACK_HOOKPOINT", --(已实现)设置挂机是否返回原点
    ---设置返回挂机点的等待时间
    ---@param value number
    SET_COMEBACK_HOOKPOINT_WAIT_TIEM = "SET_COMEBACK_HOOKPOINT_WAIT_TIEM", --(已实现)设置返回挂机点的等待时间
    ---设置召唤技能
    ---@param value number 技能id
    SET_CALL_SKILL = "SET_CALL_SKILL", --(已实现)设置召唤技能
    ---设置自动战斗释放的技能方案
    ---@param value number
    SET_HOOK_ATUO_RELEASE_SKILL_PLAN = "SET_HOOK_ATUO_RELEASE_SKILL_PLAN", --(已实现)设置自动战斗释放的技能方案
    ---设置自动战斗释放的技能
    ---@param skillId number @cfg_skill的id
    ---@param value number @是添加还是移除，nil表示移除，非nil表示添加
    SET_HOOK_ATUO_RELEASE_SKILL = "SET_HOOK_ATUO_RELEASE_SKILL", --(已实现)设置自动战斗释放的技能
    ---设置自动拾取物品列表
    ---@param pickUpId number cfg_pickdrop_condition表id
    ---@param value number true保存至后端
    SET_ATUO_PICKUP_ITEM = "SET_ATUO_PICKUP_ITEM", --(已实现)设置自动拾取物品列表
    ---设置隐藏玩家模型类型
    ---@param value EHideType
    SET_HIDE_PLAYER_MODEL_TYPE = "SET_HIDE_PLAYER_MODEL_TYPE", --(已实现)设置隐藏玩家模型类型
    ---设置隐藏玩家技能特效类型
    ---@param value EHideType
    SET_HIDE_PLAYER_SKILL_EFFECT_TYPE = "SET_HIDE_PLAYER_SKILL_EFFECT_TYPE", --(已实现)设置隐藏玩家技能特效类型
    ---设置隐藏玩家翅膀类型
    ---@param value EHideType
    SET_HIDE_PLAYER_WING_TYPE = "SET_HIDE_PLAYER_WING_TYPE", --(已实现)设置隐藏玩家翅膀类型
    ---设置隐藏自己翅膀类型
    ---@param value EHideType
    SET_HIDE_ME_WING_TYPE = "SET_HIDE_ME_WING_TYPE", --(已实现)设置隐藏自己翅膀类型
    ---设置隐藏玩家足迹类型
    ---@param value EHideType
    SET_HIDE_PLAYER_FOOTPRINT_TYPE = "SET_HIDE_PLAYER_FOOTPRINT_TYPE", --设置隐藏玩家足迹类型
    ---设置是否隐藏召唤兽
    ---@param value boolean
    SET_IS_HIDE_CALL_MONSTER = "SET_IS_HIDE_CALL_MONSTER", --设置是否隐藏召唤兽
    ---设置是否隐藏怪物模型
    ---@param value boolean
    SET_IS_HID_MONSTER_MODEL = "SET_IS_HID_MONSTER_MODEL", --(已实现)设置是否隐藏怪物模型
    ---设置是否隐藏怪物技能特效
    ---@param value boolean
    SET_IS_HID_MONSTER_SKILL_EFFECT = "SET_IS_HID_MONSTER_SKILL_EFFECT", --(已实现)设置是否隐藏怪物技能特效
    ---设置是否限制玩家显示数量
    ---@param value boolean
    SET_IS_LIMIT_PLAYER_SHOW_COUNT = "SET_IS_LIMIT_PLAYER_SHOW_COUNT", --(已实现)设置是否限制玩家显示数量
    ---设置限制玩家显示数量
    ---@param value number
    SET_LIMIT_PLAYER_SHOW_COUNT = "SET_LIMIT_PLAYER_SHOW_COUNT", --(已实现)设置限制玩家显示数量
    ---设置省电模式
    ---@param value EGameQualityType
    SET_POWER_SAVING_MODE = "SET_POWER_SAVING_MODE", --(已实现)设置省电模式
    SET_LEFT_GENERATE_INVITE_CODE_COUNT = "SET_LEFT_GENERATE_INVITE_CODE_COUNT", --(已实现)设置剩余生成邀请码次数
    ---设置是否自动接受组队邀请
    SET_IS_AUTO_ACCEPT_TEAM_INVITATION = "SET_IS_AUTO_ACCEPT_TEAM_INVITATION", --(已实现)设置自动接受组队邀请
    ---设置点击地面移动
    ---@param value number 1-点击地面移动，2-点击地面不移动
    SET_IS_CLICK_FLOOR_MOVE = "SET_IS_CLICK_FLOOR_MOVE", --(已实现)设置是否限制玩家点击地板移动
    ---设置离线挂机技能
    ---@param skills table
    SET_OFFLINE_HOOK_SKILLS = "SET_OFFLINE_HOOK_SKILLS", --设置离线挂机技能
    ---设置挂机拾取品阶
    ---@param group number cfg_pickdrop_condition表id
    ---@param pickUpGrade EPickUpGrade
    SET_PICKUP_GRADE = "SET_PICKUP_GRADE", --(已实现)设置挂机拾取品阶
    ---设置是否允许场景点击/触摸
    ---@param canTouch boolean 是否允许
    SET_IS_CAN_SCENE_TOUCH = "SET_IS_CAN_SCENE_TOUCH", --是否可以点击场景地面
    --- 设置属性偏移值
    ---@param offsetTbl table<number, number>
    SET_ROLE_ATTR_VALUE_OFFSET = "SET_ROLE_ATTR_VALUE_OFFSET", --设置属性偏移值
    --- 设置玩家头顶图标
    ---@param rid number 角色id
    ---@param iconName string TopTag资源里的图片名
    SET_ROLE_HEAD_ICON = "SET_ROLE_HEAD_ICON", --设置玩家头顶图标
    ---在角色身上播放特效模型
    ---@param rid number 角色 ID
    ---@param id number cfg_model_effect id
    ---@param offset Vector3 偏移 (可选，默认 Vector3.zero)
    ---@param isOnly boolean 是否唯一 (可选，默认 false)
    ---@param loopType EPlayEffectOverType 循环模式 (可选，默认 EPlayEffectOverType.None)
    ---@param callBack function 播放回调 (可选)
    ---@param scale number 缩放 (可选，不填使用 cfg_model_effect 的 scale)
    SET_EFFECT_ON_ROLE = "SET_EFFECT_ON_ROLE", --在玩家身上设置特效
    --- 停止玩家身上特效模型
    ---@param rid number 角色 ID
    ---@param id number cfg_model_effect id
    RECYCLE_EFFECT_ON_ROLE = "RECYCLE_EFFECT_ON_ROLE", --回收玩家身上特效
    ---停止玩家身上的所有特效模型
    ---@param rid number 角色 ID
    ---@param id number 主特效 ID (可选)
    ---@param secId number 次级特效 ID (可选)
    RECYCLE_ALL_EFFECT_ON_ROLE = "RECYCLE_ALL_EFFECT_ON_ROLE", --回收玩家身上所有特效
    --- 设置系统功能任务状态
    ---@param systemName string 功能名
    ---@param state boolean 状态
    SET_SYSTEM_FUNCTION_TASK_STATE = "SET_SYSTEM_FUNCTION_TASK_STATE", --设置系统功能任务状态
    ---部分功能限制技能释放，仅可释放传入skill
    ---@param skillTbl table @可释放技能list，结构 = { skillId = level, skillId = level }
    SET_OUT_RELEASE_LIMIT_SKILL = "SET_OUT_RELEASE_LIMIT_SKILL", --功能限制技能释放（仅可释放传入skill）
    ---玩家模型改变为怪物模型设置持久化
    ---@param monsterId number @cfg_monster id
    SET_OUT_ME_SHAPE_MONSTER = "SET_OUT_ME_SHAPE_MONSTER", --设置玩家模型变换（防止玩家重置还原模型）
    ---设置当前仓库页码
    ---@param page number 页码
    SET_STORAGE_CURPAGE = "SET_STORAGE_CURPAGE", --(已实现)设置仓库当前页
    ---设置 C# Main 环境标识
    ---@param env any 环境 (可填："","test","release")
    CS_MAIN_ENV = "CS_MAIN_ENV", --CS.Main.instance.env (已实现)
    ---设置是否重启标记
    ---@param isRestart boolean 是否重启
    CS_MAIN_IS_RESTART = "CS_MAIN_IS_RESTART", --CS.Main.instance.isRestart
    ---设置重启参数
    ---@param args any 重启参数
    CS_MAIN_RESTART_ARGS = "CS_MAIN_RESTART_ARGS",
    ---设置 iOS 从后台盒子返回时的重启标记
    ---@param isIOSRestartFromBackBox boolean 是否从后台盒子返回重启
    CS_MAIN_IS_IOS_RESTART_FROMBACK_BOX = "CS_MAIN_IS_IOS_RESTART_FROMBACK_BOX",
    ---设置 FirstEngine 上一次登录的服务器 ID
    ---@param userId number 用户 ID
    ---@param gameId number 游戏 ID
    ---@param sId number 服务器 ID
    FIRST_ENGINE_LAST_SERVER_ID = "FIRST_ENGINE_LAST_SERVER_ID", --设置上次服务器id
    ---设置是否启用 PC 平台模式
    ---@param isSet boolean 是否启用
    ---@param name string 平台名/标识
    SET_IS_PC_PLATFORM = "SET_IS_PC_PLATFORM",
    ---设置拾取范围
    ---@param range number 拾取范围
    SETTING_PICK_RANGE = "SETTING_PICK_RANGE", --设置拾取范围
    --- 设置玩家当前骑乘的坐骑id
    ---@param rid number
    ---@param mountId number
    SET_PLAYER_MOUNTID = "SET_PLAYER_MOUNTID", --设置玩家当前骑乘的坐骑id
}



--endregion



--region Get
---@class EMetaVarGetKey
EMetaVarGetKey = {

    ---屏幕宽
    ---@return number @屏幕宽
    SCREEN_WIDTH = "SCREEN_WIDTH", --(已实现)
    ---屏幕高
    ---@return number @屏幕高
    SCREEN_HEIGHT = "SCREEN_HEIGHT", --(已实现)
    ---刘海屏信息
    ---@return boolean, {x:number, y:number, width:number, height:number} 是否有刘海, 安全区域
    NOTCH_PHONE_INFO = "NOTCH_PHONE_INFO", --(已实现)
    ---是否是 Android 平台
    ---@return boolean @是否是 Android 平台
    PLATFORM_ANDROID = "PLATFORM_ANDROID", --(已实现)
    ---是否是 iOS 平台
    ---@return boolean @是否是 iOS 平台
    PLATFORM_IOS = "PLATFORM_IOS", --(已实现)
    ---是否是 Windows 平台
    ---@return boolean @是否是 Windows 平台
    PLATFORM_WINDOWS = "PLATFORM_WINDOWS", --(已实现)
    ---是否是手机平台（包含 Android 和 iOS）
    ---@return boolean @是否是手机平台（包含 Android 和 iOS）
    PLATFORM_MOBILE = "PLATFORM_MOBILE", --(已实现)
    ---是否是 PC 操作模式
    ---@return boolean
    WINPLAYMODE = "WINPLAYMODE", --(已实现)
    ---是否是H5平台
    ---@return boolean
    H5PLAYMODE = "H5PLAYMODE", --(已实现)
    ---是否是 PC 操作模式（等同 WINPLAYMODE）
    ---@return boolean
    IS_PC_PLAY_MODE = "IS_PC_PLAY_MODE", --(已实现)
    ---操作模式（PC=1, 手机=2）
    ---@return number | nil
    CURRENT_OPERMODE = "CURRENT_OPERMODE", --(已实现)
    ---游戏 ID
    ---@return number 游戏 ID
    GAME_ID = "GAME_ID", --(已实现)
    ---渠道ID
    ---@return number @渠道ID
    CHANNEL_ID = "CHANNEL_ID", --(已实现)
    ---获取游戏安装包包名
    ---@return string 安装包包名（如 com.xxx.xxx）
    PACKAGE_NAME = "PACKAGE_NAME", --(已实现)

    ---获取游戏安装包VersionName
    ---@return string 安装包VersionName（如 3.3.3.0）
    PACKAGE_VERSION_NAME = "PACKAGE_VERSION_NAME", --(已实现)
    
    ---安装包版本名
    ---@return string
    VERSION_NAME = "VERSION_NAME", --(已实现)
    ---安装包版本号
    ---@return number
    VERSION_CODE = "VERSION_CODE", --(已实现)
    ---原始/本地客户端资源版本号
    ---@return string
    LOCAL_RES_VERSION = "LOCAL_RES_VERSION", --(已实现)
    ---热更客户端资源版本号
    ---@return string
    REMOTE_RES_VERSION = "REMOTE_RES_VERSION", --(已实现)
    ---PC 唯一设备 ID
    ---@return string @唯一设备ID
    DEVICE_UNIQUE_ID = "DEVICE_UNIQUE_ID", --(已实现)
    ---游戏帧率统计对象
    ---@return any
    FPS = "FPS", --(已实现)
    ---获取游戏帧率
    ---@return number 游戏帧率
    FPSVALUE = "FPSVALUE",
    ---网络类型（0:wifi, 1:蜂窝, -1:未识别）
    ---@return number @网络类型（0:wifi, 1:蜂窝, -1:未识别）
    NET_TYPE = "NET_TYPE", --(已实现)
    ---手机电量（0~100）
    ---@return number @手机电量（0~100）
    BATTERY = "BATTERY", --(已实现)
    ---是否是 SDK 登录
    ---@return boolean
    IS_SDK_LOGIN = "IS_SDK_LOGIN", --(已实现)
    ---服务器开关（param） --this.svTogGetFunc未实现，注释
    SERVER_OPTION = "SERVER_OPTION", --(已实现)
    ---设备唯一 ID
    ---@return string @唯一设备ID
    DEVICE_ID = "DEVICE_UNIQUE_ID", -- 设备唯一ID（已实现）
    ---获取设备型号
    ---@return string @设备型号
    DEVICE_TYPE = "DEVICE_TYPE", -- 设备类型(已实现)
    ---设备系统版本
    ---@return string @系统版本
    DEVICE_VERSION = "DEVICE_VERSION", --设备版本(已实现)
    ---是否是模拟器
    ---@return boolean
    IS_EMULATOR = "IS_EMULATOR", --是否是模拟器（Android）
    ---获取 C# Main 环境标识
    ---@return any
    CS_MAIN_ENV = "CS_MAIN_ENV", --CS.Main.instance.env (已实现)
    ---获取是否重启标记
    ---@return boolean
    CS_MAIN_IS_RESTART = "CS_MAIN_IS_RESTART", --CS.Main.instance.isRestart
    ---获取版本配置内容
    ---@return string
    CS_MAIN_VERSION_CFG_CONTENT = "CS_MAIN_VERSION_CFG_CONTENT",
    ---获取版本数据
    ---@return any
    CS_MAIN_VERSION_DATA = "CS_MAIN_VERSION_DATA", --CS.Main.instance.verData
    ---获取 iOS 从后台盒子返回时的重启标记
    ---@return boolean
    CS_MAIN_IS_IOS_RESTART_FROMBACK_BOX = "CS_MAIN_IS_IOS_RESTART_FROMBACK_BOX",
    -----@return boolean @sdk是否初始化
    ---[EMetaVarGetKey.CS_MUCALLBACK_ISSDKINIT] = function()
    ---    return CS.MUCallback.Instance.IsSdkInit
    ---end,
    ---获取 FirstEngine 上次登录服务器 ID（会根据审核服逻辑做过滤）
    ---@param lastAccount string 上次登录账号
    ---@param curGameId number 当前游戏 ID
    ---@return number 服务器 ID
    FIRST_ENGINE_LAST_SERVER_ID = "FIRST_ENGINE_LAST_SERVER_ID", --获取上次获取的CS.FirstEngineVersion.GetLastSId(lastAccount, curGameId)
    ---获取 UnityEngine.KeyCode 枚举
    ---@return any
    CS_KEYCODE_ENUM = "CS_KEYCODE_ENUM",
    ---获取 UnityEngine.Texture2D 的 System.Type
    ---@return System.Type
    CS_TEXTURE2D_TYPE = "CS_TEXTURE2D_TYPE",
    ---获取 StreamingScene 当前待显示的对象数量
    ---@return number
    CS_STREAMING_SCENE_OBJ_SHOW_COUNT = "CS_STREAMING_SCENE_OBJ_SHOW_COUNT",

    ---服务器ID
    ---@return string @ 服务器ID
    SERVER_ID = "SERVER_ID", --(已实现)
    ---服务器名字
    ---@return string @ 服务器ID
    SERVER_NAME = "SERVER_NAME", --(已实现)
    ---主服务器ID
    ---@return string @ 服务器ID
    MAIN_SERVER_ID = "MAIN_SERVER_ID", --(已实现)
    ---资源版本
    ---@return string @版本号
    RES_VERSION = "RES_VERSION", --(已实现)
    ---获取登录角色ID
    ---@return number @ 登录角色ID
    UID = "UID", --(已实现)
    ---登录角色信息
    ---@return RoleData @ 服务器ID
    LOGIN_DATA = "LOGIN_DATA", --(已实现)
    ---可恢复角色信息
    ---@return RoleData @ 可恢复角色信息
    RESTORE_ROLES = "RESTORE_ROLES", --(已实现)
    ---获取当前打开的NPC面板(txt面板)
    ---@return table @面板
    SERVER_VALUE = "SERVER_VALUE", --(已实现)
    ---获取当前对话NPC的ID
    ---@return number @ NPCID
    CURRENT_TALK_NPC_ID = "CURRENT_TALK_NPC_ID", --(已实现)
    ---获取当前对话NPC的Index
    ---@return number @ NPCID
    CURRENT_TALK_NPC_TYPEINDEX = "CURRENT_TALK_NPC_TYPEINDEX", --(已实现)
    CURRENT_TALK_NPC_LAYER = "CURRENT_TALK_NPC_LAYER", --(已实现)
    --M2_FORBID_SAY = "M2_FORBID_SAY", --(已实现)

    ---地图ID
    MAP_ID = "MAP_ID", --(已实现)
    ---地图名字
    MAP_NAME = "MAP_NAME", --(已实现)
    ---地图line
    MAP_LINE = "MAP_LINE", --(已实现)
    ---地图数据ID
    MAP_DATA_ID = "MAP_DATA_ID", --(已实现)
    ---获取地图区域水陆空
    MAP_AREA = "MAP_AREA", --(已实现)
    ---获取地图pvp
    MAP_PVP = "MAP_PVP", --(已实现)
    ---获取地图pve
    MAP_PVE = "MAP_PVE", --(已实现)
    ---获取地图eve
    MAP_EVE = "MAP_EVE", --(已实现)
    ---是否是安全区域
    IN_SAFE_AREA = "IN_SAFE_AREA", --(已实现)
    ---是否禁止职业和等级
    MAP_FORBID_LEVEL_AND_JOB = "MAP_FORBID_LEVEL_AND_JOB", --(已实现)
    ---地图数据是否加载完成（当前实现：true 表示未完成加载/下载中）
    ---@return boolean 是否加载完成
    MAP_DATA_LOADED = "MAP_DATA_LOADED", --(已实现)
    ---获取小地图文件路径
    ---@return string
    MINIMAP_FILE = "MINIMAP_FILE", --(已实现)
    ---地图获取宽度像素
    ---@return number
    MAP_SIZE_WIDTH_PIXEL = "MAP_SIZE_WIDTH_PIXEL", --(已实现)
    ---地图获取高度像素
    ---@return number
    MAP_SIZE_HEIGHT_PIXEL = "MAP_SIZE_HEIGHT_PIXEL", --(已实现)
    ---获取地图格子是否是阻挡
    ---@param param1 number @地图坐标X
    ---@param param2 number @地图坐标Z
    MAP_IS_OBSTACLE = "MAP_IS_OBSTACLE", --(已实现)
    ---地图计算路径坐标
    ---@return  Dot2[] @路径坐标
    MAP_PATH_POINTS = "MAP_PATH_POINTS", --(已实现)
    ---地图获取当前路径坐标index
    ---@return number @路径点索引
    MAP_CURRENT_PATH_INDEX = "MAP_CURRENT_PATH_INDEX", --(已实现)
    ---地图获取人物坐标
    MAP_PLAYER_POS = "MAP_PLAYER_POS", --(已实现)
    ---地图获取怪物列表位置等信息
    MAP_GET_MONSTERS = "MAP_GET_MONSTERS", --(已实现)
    --MAP_GET_PORTALS = "MAP_GET_PORTALS", --(已实现)
    FIND_IN_VIEW_PLAYER_LIST = "FIND_IN_VIEW_PLAYER_LIST", --(已实现)
    FIND_IN_VIEW_MONSTER_LIST = "FIND_IN_VIEW_MONSTER_LIST",
    FIND_IN_VIEW_NPC_LIST = "FIND_IN_VIEW_NPC_LIST",
    IN_SIEGE_AREA = "IN_SIEGE_AREA",
    ---获取背包最大行列数
    ---@return number, number 横向格子数, 纵向格子数
    GET_BAG_MAX_HOR_VERT = "GET_BAG_MAX_HOR_VERT",
    ---获取背包已使用格子表
    ---@return table<number,table<number, boolean>> 使用中的格子数据
    GET_BAG_USE_GRID_TABLE = "GET_BAG_USE_GRID_TABLE",
    ---获取仓库最大行列数
    ---@return number, number 横向格子数, 纵向格子数
    GET_STORE_HOUSE_MAX_HV = "GET_STORE_HOUSE_MAX_HV",
    ---获取仓库已使用格子表
    ---@return table<number,table<number, boolean>> 使用中的格子数据
    GET_STORE_HOUSE_USE_GRID_TABLE = "GET_STORE_HOUSE_USE_GRID_TABLE",
    --宠物
    PET_ALIVE = "PET_ALIVE",
    PET_LOCK_ID = "PET_LOCK_ID",

    --英雄
    USEHERO = "USEHERO",
    HERO_IS_ALIVE = "HERO_IS_ALIVE",
    HERO_IS_ACTIVE = "HERO_IS_ACTIVE", --(已实现)
    HERO_ID = "HERO_ID",
    HERO_STATES_SYS_VALUES = "HERO_STATES_SYS_VALUES", --(已实现)
    HERO_ACTIVES_STATES = "HERO_ACTIVES_STATES", --(已实现)
    HERO_STATE = "HERO_STATE",
    HERO_GUARDSTATE = "HERO_GUARDSTATE",
    HERO_GUARD_ISCLICK = "HERO_GUARD_ISCLICK", --(已实现)
    ---主角是否正在播放技能动作
    ---@return boolean
    IS_SKILL_ACTION_PLAYING = "IS_SKILL_ACTION_PLAYING", --是否正在释放技能
    ---寻路脚印是否显示
    ---@return boolean
    IS_FIND_PATH_SHOW_FOOT = "IS_FIND_PATH_SHOW_FOOT", --是否显示足迹
    ---获取主相机偏航角
    ---@return number 主相机偏航角
    MAIN_CAMERA_Y_ORBIT_ANGLE_Y = "MAIN_CAMERA_Y_ORBIT_ANGLE_Y", --主相机Y轴角度
    ---引擎是否锁定相机
    ---@return boolean
    ENGINE_IS_LOCK_CAMERA = "ENGINE_IS_LOCK_CAMERA", --是否锁定相机


    ---获取货币数量
    ---@param param1 number 类型 使用 MUEResourceType枚举值
    ---@return number 数量
    MONEY = "MONEY", --(已实现)
    MONEY_ASSOCIATED = "MONEY_ASSOCIATED", --(已实现)
    ---获取所有道具信息
    ---@return table<number,table<number, CommonProtos.Item>> 道具列表
    STD_ITEMS = "STD_ITEMS", --(已实现)
    ---根据道具index获取道具信息
    ---@param param1 number 背包物品索引
    ---@return CommonProtos.Item 道具信息
    ITEM_DATA = "ITEM_DATA", --(已实现)
    ---根据道具index或者名字获取道具数量
    ---@param param1 number 道具index
    ---@return number 道具数量
    ITEM_COUNT = "ITEM_COUNT", --(已实现)
    ---根据道具index获取道具名字
    ---@param param1 number 道具index
    ---@return string 道具名字
    ITEM_NAME = "ITEM_NAME", --(已实现)
    ---根据道具名字获取道具index
    ---@param param1 number 道具名字
    ---@alias Index_ItemData {index:number, item:CommonProtos.Item}
    ---@return Index_ItemData [] 背包内对应的格子索引和物品列表
    ITEM_INDEX_BY_NAME = "ITEM_INDEX_BY_NAME", --(已实现)
    ---获取道具名字颜色  通过itemIndex
    ---@param param1 number 背包物品索引
    ---@return number 对应cfg_color表id
    ITEM_NAME_COLOR = "ITEM_NAME_COLOR", --(已实现)
    ---获取道具名字颜色,”#FFFFFF”格式  通过itemIndex
    ---@param param1 number 背包物品索引
    ---@return string 对应cfg_color表color值
    ITEM_NAME_COLOR_VALUE = "ITEM_NAME_COLOR_VALUE", --(已实现)
    ---道具名字颜色ID, 颜色表ID
    ---@param param1 number 背包物品索引
    ---@return number 对应cfg_color表id
    ITEM_NAME_COLORID = "ITEM_NAME_COLORID", --(已实现)
    ITEM_PROMPT_DATA = "ITEM_PROMPT_DATA", --(已实现)
    ---获取物品自定义属性数据
    ---@param param1 number 物品唯一 ID（MakeIndex）
    ---@return table<number,CommonProtos.CustomizeInfo>
    ITEM_CUSTOM_ATTR = "ITEM_CUSTOM_ATTR", --(已实现)
    ITEM_IS_BIND = "ITEM_IS_BIND", --(已实现)
    ITEM_DATA_BY_MAKEINDEX = "ITEM_DATA_BY_MAKEINDEX", --(已实现)
    EQUIP_DATA_BY_MAKEINDEX = "EQUIP_DATA_BY_MAKEINDEX", --(已实现)
    ---根据MakeIndex获取仓库数据
    ---@param page number 仓库页码
    ---@return table | nil 仓库页数据
    STORAGE_DATA = "STORAGE_DATA", --(已实现)仓库数据
    --- 仓库禁用数量
    ---@param page number 仓库页码
    ---@return number 禁用格子数量
    STORAGE_FORBID_COUNT = "STORAGE_FORBID_COUNT", --(已实现)仓库禁用表
    --QUICKUSE_DATA_BY_MAKEINDEX = "QUICKUSE_DATA_BY_MAKEINDEX", --(已实现)
    LOOKPLAYER_DATA_BY_MAKEINDEX = "LOOKPLAYER_DATA_BY_MAKEINDEX", --(已实现)
    ---获取背包所有物品数据
    ---@return table<number,table<number, CommonProtos.Item>> @<页数,<位置,道具数据>>
    BAG_DATA = "BAG_DATA", --(已实现)
    -----获取快捷使用数据 返回table
    QUICKUSE_DATA = "QUICKUSE_DATA", --(已实现)
    ---获取物品能否自动使用
    ---@param param1 table 物品数据（需包含 autoUse 字段）
    ---@return boolean 是否可自动使用（当前实现固定返回 false）
    ITEM_CAN_AUTOUSE = "ITEM_CAN_AUTOUSE", --(已实现)
    --SKILLBOOK_CAN_USE = "SKILLBOOK_CAN_USE", --(已实现)
    --ITEM_BELONG_BY_MAKEINDEX = "ITEM_BELONG_BY_MAKEINDEX", --(已实现)
    --BAG_MAKEINDEX_BY_POS = "BAG_MAKEINDEX_BY_POS", --(已实现)
    --ITEM_ARTICLE_ENUM = "ITEM_ARTICLE_ENUM", --(已实现)

    --道具框
    --ITEM_SCALE = "ITEM_SCALE", --(已实现)

    --装备
    EQUIP_NAME = "EQUIP_NAME", --装备名字     --(已实现)
    EQUIP_GRADE = "EQUIP_GRADE", --装备品质     --(已实现)
    EQUIP_TWO_HANDED = "EQUIP_TWO_HANDED", --装备单双手   --(已实现)
    EQUIP_NEED_CAREER = "EQUIP_NEED_CAREER", --装备所需职业     --(已实现)
    EQUIP_WEAR_LIMIT = "EQUIP_WEAR_LIMIT", --装备穿戴要求     --(已实现)
    EQUIP_RANK = "EQUIP_RANK", --装备阶数     --(已实现)
    EQUIP_USE_LEVEL_LIMIT = "EQUIP_USE_LEVEL_LIMIT", --装备使用等级限制     --(已实现)
    EQUIP_BASE_ATTR = "EQUIP_BASE_ATTR", --装备基础属性     --(已实现)
    EQUIP_ENTRY_ATTR = "EQUIP_ENTRY_ATTR", --装备卓越属性     --(已实现)
    EQUIP_MAGIC_ATTR = "EQUIP_MAGIC_ATTR", --装备魔法属性     --(已实现)
    EQUIP_LUCK_ATTR = "EQUIP_LUCK_ATTR", --装备幸运属性     --(已实现)
    EQUIP_STRENGTHEN_LEVEL = "EQUIP_STRENGTHEN_LEVEL", --装备强化等级     --(已实现)
    EQUIP_STRENGTHEN_ATTR = "EQUIP_STRENGTHEN_ATTR", --装备强化属性     --(已实现)
    EQUIP_APPEND_ATTR = "EQUIP_APPEND_ATTR", --装备追加属性     --(已实现)
    EQUIP_REGENERATE_ATTR = "EQUIP_REGENERATE_ATTR", --装备再生属性     --(已实现)
    EQUIP_SKILL_ATTR = "EQUIP_SKILL_ATTR", --装备附带技能     --(已实现)
    EQUIP_TIPS_LEFT_BUTTON = "EQUIP_TIPS_LEFT_BUTTON", --装备在背包中的tip左边按钮     --(已实现)
    EQUIP_TIPS_RIGHT_BUTTON = "EQUIP_TIPS_RIGHT_BUTTON", --装备在背包中的tip左边按钮     --(已实现)
    ---检查是否拥有指定装备（按 cfgId）
    ---@param cfgId number 装备 cfgId
    ---@return boolean
    EQUIP_CHECK_EXIST_CFG = "EQUIP_CHECK_EXIST_CFG", --自己是否穿戴了某个cfgid的装备
    EQUIP_WEAR_BAR_ID = "EQUIP_WEAR_BAR_ID", --cfgid的穿戴栏

    ---是否自动挂机中:返回boolean
    ---@return boolean 是否自动挂机中
    BATTLE_IS_AFK = "BATTLE_IS_AFK", --(已实现)
    BATTLE_AFK_BEGIN = "BATTLE_AFK_BEGIN",
    BATTLE_AFK_END = "BATTLE_AFK_END",
    ---是否自动寻路中:返回boolean
    BATTLE_IS_AUTO_MOVE = "BATTLE_IS_AUTO_MOVE", --(已实现)
    BATTLE_MOVE_BEGIN = "BATTLE_MOVE_BEGIN",
    BATTLE_MOVE_END = "BATTLE_MOVE_END",
    ---是否自动捡物中
    ---@return boolean 是否自动捡物中
    BATTLE_IS_AUTO_PICK = "BATTLE_IS_AUTO_PICK", --(已实现)
    BATTLE_PICK_BEGIN = "BATTLE_PICK_BEGIN",
    BATTLE_PICK_END = "BATTLE_PICK_END",

    ---主玩家actorID
    ---@return string
    MAIN_ACTOR_ID = "MAIN_ACTOR_ID", --(已实现)
    --- 是否是玩家
    ---@return boolean
    ACTOR_IS_PLAYER = "ACTOR_IS_PLAYER", --(已实现)
    ---是否是网络玩家
    ---@param actorID number @角色id
    ---@return boolean 是否是网络玩家
    ACTOR_IS_NETPLAYER = "ACTOR_IS_NETPLAYER", --(已实现)
    ---是否是怪物
    ---@param actorID number @角色id
    ---@return boolean @是否是怪物
    ACTOR_IS_MONSTER = "ACTOR_IS_MONSTER", --(已实现)
    ---是否是NPC
    ---@param actorID number @角色id
    ---@return boolean @是否是NPC
    ACTOR_IS_NPC = "ACTOR_IS_NPC", --(已实现)
    ACTOR_IS_HERO = "ACTOR_IS_HERO", --(已实现)
    ACTOR_IS_HUMAN = "ACTOR_IS_HUMAN", --(已实现)
    ---获取角色名字
    ---@param actorID number @角色id
    ---@return string @角色名字
    ACTOR_NAME = "ACTOR_NAME", --(已实现)
    ---获取角色HP
    ---@param actorID number @角色id
    ---@return number @角色HP
    ACTOR_HP = "ACTOR_HP", --(已实现)
    ---获取角色最大HP
    ---@param actorID number @角色id
    ---@return number @角色最大HP
    ACTOR_MAXHP = "ACTOR_MAXHP", --(已实现)
    ---获取角色MP
    ---@param actorID number @角色id
    ---@return number @角色MP
    ACTOR_MP = "ACTOR_MP", --(已实现)
    ---获取角色最大MP
    ---@param actorID number @角色id
    ---@return number @角色最大MP
    ACTOR_MAXMP = "ACTOR_MAXMP", --(已实现)
    ---获取角色等级
    ---@param actorID number @角色id
    ---@return number @角色等级
    ACTOR_LEVEL = "ACTOR_LEVEL", --(已实现)
    ACTOR_JOB_ID = "ACTOR_JOB_ID", --(已实现)
    ---actor是否死亡
    ---@param param1 number @角色id
    ---@return boolean @角色是否死亡
    ACTOR_IS_DIE = "ACTOR_IS_DIE", --(已实现)
    ---获取actor归属ID
    ---@param param1 number @角色id
    ---@return number @对数对象id
    ACTOR_OWNER_ID = "ACTOR_OWNER_ID", --(已实现)
    Pet_OWNER_ID = "Pet_OWNER_ID", --(已实现)
    ---获取actor归属名字
    ---@param param1 number @角色id
    ---@string @归属对象的名字
    ACTOR_OWNER_NAME = "ACTOR_OWNER_NAME", --(已实现)
    ACTOR_BIGICON_ID = "ACTOR_BIGICON_ID", --(已实现)
    SELECT_TARGET_ID = "SELECT_TARGET_ID",
    TARGET_ATTACK_ENABLE = "TARGET_ATTACK_ENABLE", --(已实现)
    ACTOR_TEAM_STATE = "ACTOR_TEAM_STATE", --(已实现)
    ACTOR_GUILD_ID = "ACTOR_GUILD_ID", --(已实现)
    --- 主角是否加入行会
    ---@return boolean
    ACTOR_HAVE_GUIDE = "ACTOR_HAVE_GUIDE", --(已实现)
    ACTOR_GUILD_NAME = "ACTOR_GUILD_NAME", --(已实现)
    ACTOR_TYPE_INDEX = "ACTOR_TYPE_INDEX", --(已实现)
    ACTOR_DIR = "ACTOR_DIR", --(已实现)
    ACTOR_MAP_X = "ACTOR_MAP_X", --(已实现)
    ACTOR_MAP_Y = "ACTOR_MAP_Y", --(已实现)
    ACTOR_POSITION_X = "ACTOR_POSITION_X", --(已实现)
    ACTOR_POSITION_Y = "ACTOR_POSITION_Y", --(已实现)
    ACTOR_MASTER_ID = "ACTOR_MASTER_ID", --(已实现)
    ACTOR_HAVE_MASTER = "ACTOR_HAVE_MASTER", --(已实现)
    ACTOR_FACTION = "ACTOR_FACTION", --(已实现)
    ACTOR_IN_SAFE_ZONE = "ACTOR_IN_SAFE_ZONE", --(已实现)
    ACTOR_APPR_ID = "ACTOR_APPR_ID", --(已实现)
    ---获取actor挂接点 (！即取即用 避免存储使用)
    ---@param param1 number @actorID
    ---@return UnityEngine.Transform 模型的root节点或者nil
    ACTOR_MOUNT_NODE = "ACTOR_MOUNT_NODE", --(已实现)
    ---获取actor红名灰名:白=0 红=2 灰=3
    ---@param param1 number @角色id
    ---@return number 白=0 红=2 灰=3
    ACTOR_PKLV = "ACTOR_PKLV", --(已实现)
    ---actor是否在摆摊
    ---@param param1 number @actorID
    ACTOR_IS_IN_STALL = "ACTOR_IS_IN_STALL", --(已实现)
    ---获取actor摆摊名
    ---@param param1 number @actorID
    ACTOR_STALL_NAME = "ACTOR_STALL_NAME", --(已实现)
    ---获取actor是否是离线状态玩家
    ---@param param1 number @角色id
    ---@return boolean 是否是离线状态
    ACTOR_IS_OFFLINE = "ACTOR_IS_OFFLINE", --(已实现)
    ---actor是否是主玩家
    ---@param param1 number @actorID
    ACTOR_IS_MAINPLAYER = "ACTOR_IS_MAINPLAYER", --(已实现)
    ---actor是否是骑马状态
    ---@param param1 number @角色id
    ---@return boolean @是否是骑马状态
    ACTOR_IS_HORSEBACK_RADING = "ACTOR_IS_HORSEBACK_RADING", --(已实现)
    ---获取actor坐骑的主驾ID
    ---@param param1 number @actorID
    ACTOR_HORSE_MASTER_ID = "ACTOR_HORSE_MASTER_ID", --(已实现)
    ---获取actor是否在附近显示
    ---@param param1 number @actorID
    ACTOR_NEAR_SHOW = "ACTOR_NEAR_SHOW", --(已实现)
    ---获取actor是否在移动状态
    ---@param param1 number @actorID
    ACTOR_IS_MOVE = "ACTOR_IS_MOVE", --(已实现)
    ---获取主角id
    ---@return string @主角id
    USER_ID = "USER_ID", --(已实现)
    ACTOR_STOME_MODE = "ACTOR_STOME_MODE", --(已实现)
    ACTOR_RACE_SERVER = "ACTOR_RACE_SERVER", --(已实现)
    ACTOR_RACE_IMG = "ACTOR_RACE_IMG", --(已实现)
    ACTOR_HIDE_NAME = "ACTOR_HIDE_NAME", --(已实现)
    ACTOR_HIDE_HP_BAR = "ACTOR_HIDE_HP_BAR", --(已实现)
    ACTOR_NATION_ENEMY_PK = "ACTOR_NATION_ENEMY_PK", --(已实现)
    ACTOR_GM_DATA = "ACTOR_GM_DATA", --(已实现)
    ---角色是否死亡
    ---@param actorID number @角色id
    ---@return boolean @角色是否死亡
    ACTOR_IS_DEATH = "ACTOR_IS_DEATH", --(已实现)
    ACTOR_IS_BORN = "ACTOR_IS_BORN", --(已实现)
    ACTOR_IS_CAVE = "ACTOR_IS_CAVE", --(已实现)
    ---获取某角色身上所有buff数据
    ---@param actorID number @角色id，不填的话拿自己的
    ---@return BufferProtos.Buff[] @buff列表
    ACTOR_BUFF_DATA = "ACTOR_BUFF_DATA", --(已实现)
    --- actor是否有某个buff
    ---@param actorID number @角色id，如果为nil,则默认为玩家自己
    ---@param buffID number @buff的id
    ---@return boolean @是否有指定buff
    ACTOR_HAS_ONE_BUFF_BY_ID = "ACTOR_HAS_ONE_BUFF_BY_ID", --(已实现)
    --- actor是否有某个buff
    ---@param actorID number @角色id，如果为nil,则默认为玩家自己
    ---@param buffID number @cfg_buff表的id
    ---@return boolean
    ACTOR_HAS_ONE_BUFF_BY_CFG_ID = "ACTOR_HAS_ONE_BUFF_BY_CFG_ID", --(已实现)
    --- 获取actor身上某个buff数据
    ---@param actorID @角色id，如果为nil,则默认为玩家自己
    ---@param buffID number @全局唯一id
    ---@return table @buff数据
    ACTOR_BUFF_DATA_BY_ID = "ACTOR_BUFF_DATA_BY_ID", --(已实现)
    --- 获取actor身上某个buff数据
    ---@param buffCfgId number
    ---@return table
    ACTOR_BUFF_DATA_BY_CFG_ID = "ACTOR_BUFF_DATA_BY_CFG_ID", --(已实现)
    ---获取当前PK模式
    ---@return EPKMode
    PKMODE = "PKMODE", --(已实现)
    ---PK模式是否可以切换
    ---@param pkmode EPKMode 目标 PK 模式
    ---@param activityId number 活动规则 ID (可选，默认 0)
    ---@return string 限制提示（空字符串表示可切换）
    PKMODE_CAN_USE = "PKMODE_CAN_USE", --(已实现)
    PET_PKMODE = "PET_PKMODE", --(已实现)
    KFSTATE = "KFSTATE", --(已实现)
    ---当前服务器时间
    ---@return number 服务器时间戳（毫秒）
    SERVER_TIME = "SERVER_TIME", --(已实现)
    ---人物当前坐标X
    ---@return number @x坐标
    X = "X", --(已实现)
    ---人物当前坐标Y
    ---@return number @y坐标
    Y = "Y", --(已实现)
    ---根据气泡index获取气泡数据
    ---@param index number 索引
    ---@return table | nil 气泡数据
    BUBBLETIPS_INFO = "BUBBLETIPS_INFO", --(已实现)
    BONUSPOINT = "BONUSPOINT", --(已实现)
    ---是否是自动拾取状态
    ---@return number 是否自动拾取
    IS_PICK_STATE = "IS_PICK_STATE", --(已实现)
    ---PC端Y轴适配
    ---@return number
    PC_POS_Y = "PC_POS_Y", --(已实现)
    ---通过 cfg_menulayer 表中的组ID(group_id)获取该组界面配置信息
    ---@param groupID number 组 ID
    ---@return cfg_menu_layer_column | nil
    MENU_LAYERS_BY_GROUNP = "MENU_LAYERS_BY_GROUNP", --(已实现)
    ---黑夜当前状态
    DARK_STATE = "DARK_STATE", --(已实现)
    ---内观头发偏移配置
    UIMODEL_HAIR_OFFSET = "UIMODEL_HAIR_OFFSET", --(已实现)
    ---    内观装备偏移配置
    UIMODEL_EQUIP_OFFSET = "UIMODEL_EQUIP_OFFSET", --(已实现)
    ---屏幕点击状态
    ---@return boolean
    TOUCH_STATE = "TOUCH_STATE", --(已实现)
    ---首饰盒界面是否打开
    ---param1: 1: 自己人物、2：自己英雄、11：其他玩家人物、12：其他玩家英雄、21：交易行人物、22：交易行英雄
    BEST_RING_WIN_ISOPEN = "BEST_RING_WIN_ISOPEN", --(已实现)
    ---首饰盒开启状态
    ---param1: 1: 自己人物、2：自己英雄、11：其他玩家人物、12：其他玩家英雄、21：交易行人物、22：交易行英雄
    BEST_RING_OPENSTATE = "BEST_RING_OPENSTATE", --(已实现)
    ---检查当前类别功能菜单的某种按钮是否显示
    ---param1:功能类别 FuncDock.FuncDockType可查
    ---param2: 按钮类型 FuncDock.BtnOperatorType可查
    CHECK_FUNCBTN_SHOW = "CHECK_FUNCBTN_SHOW", --(已实现)
    ---鼠标当前位置
    ---@return Vector3
    MOUSE_MOVE_POS = "MOUSE_MOVE_POS", --(已实现)
    CHECK_MINIMAP_OPEN = "CHECK_MINIMAP_OPEN",
    TRADINGBANK_OPENSTATUS = "TRADINGBANK_OPENSTATUS",
    OPEN_SERVER_TIME = "OPEN_SERVER_TIME", --(已实现)
    OPEN_SERVER_DAY = "OPEN_SERVER_DAY", --(已实现)
    MERGE_SERVER_COUNT = "MERGE_SERVER_COUNT",
    MERGE_SERVER_TIME = "MERGE_SERVER_TIME", --(已实现)
    MERGE_SERVER_DAY = "MERGE_SERVER_DAY", --(已实现)
    BUFF_CONFIG = "BUFF_CONFIG",
    SHOW_STATUS_PERMIT = "SHOW_STATUS_PERMIT",
    GAMEPAD_MOVE_PARAM = "GAMEPAD_MOVE_PARAM",
    TARGET_MAPPOS_DIR = "TARGET_MAPPOS_DIR", --(已实现)
    --- 检测红点表对应id是否满足条件
    ---@param id number @红点表id
    ---@return boolean 是否满足
    CHECK_REDPOINT_ID = "CHECK_REDPOINT_ID",
    CTRL_PRESSED = "CTRL_PRESSED",
    PC_NP_STATUS = "PC_NP_STATUS",
    SELECT_SHIFT_ATTACK_ID = "SELECT_SHIFT_ATTACK_ID", --(已实现)
    IS_PICKABLE_DROPITEM = "IS_PICKABLE_DROPITEM", --(已实现)
    AUTOUSE_MAKEINDEX_BY_POS = "AUTOUSE_MAKEINDEX_BY_POS", --(已实现)
    CHECK_IN_GUIDE = "CHECK_IN_GUIDE", --(已实现)
    PICK_ACTORID_BY_POS = "PICK_ACTORID_BY_POS", --(已实现)
    ---附近队伍列表
    ---@return TeamProto.NearbyTeamList @附近队伍列表
    TEAM_NEAR = "TEAM_NEAR", --(已实现)
    ---队伍成员列表
    ---@return table
    TEAM_MEMBER_LIST = "TEAM_MEMBER_LIST", --(已实现)
    ---队伍信息数据
    ---@return table
    TEAM_MEMBER_INFO = "TEAM_MEMBER_INFO", --(已实现)
    ---当前队伍人数
    ---@return number
    TEAM_COUNT = "TEAM_COUNT", --(已实现)
    ---队伍最大人数
    ---@return number
    TEAM_MAC_COUNT = "TEAM_MAC_COUNT", --(已实现)
    ---是否是队伍成员
    ---@return boolean
    TEAM_IS_MEMBER = "TEAM_IS_MEMBER", --(已实现)
    ---是否在队伍中
    ---@return boolean
    TEAM_IS_IN = "TEAM_IS_IN", --(已实现)
    ---是否是队长
    ---@return boolean
    TEAM_IS_TEAM_LEADER = "TEAM_IS_TEAM_LEADER", --(已实现)
    ---允许组队状态
    ---@return boolean
    TEAM_STATUS_PERMIT = "TEAM_STATUS_PERMIT", --(已实现)
    ---入队申请列表
    ---@return TeamProto.ApplicationList @申请列表
    TEAM_APPLY = "TEAM_APPLY", --(已实现)
    ---func dock enum,返回值如下：data
    DOCKTYPE_NENUM = "DOCKTYPE_NENUM", --(已实现)
    ---邮件列表
    MAIL_LIST = "MAIL_LIST", --(已实现)
    ---根据邮件ID获取邮件
    MAIL_BY_ID = "MAIL_BY_ID", --(已实现)
    ---是否有邮件可以删除
    MAIL_HAVE_DEL_ITEM = "MAIL_HAVE_DEL_ITEM", --(已实现)
    ---当前邮件ID
    MAIL_CURRENT_ID = "MAIL_CURRENT_ID", --(已实现)
    AUCTION_BIDPRICE_MIN = "AUCTION_BIDPRICE_MIN", --(已实现)
    AUCTION_BIDPRICE_MAX = "AUCTION_BIDPRICE_MAX", --(已实现)
    AUCTION_BUYPRICE_MIN = "AUCTION_BUYPRICE_MIN", --(已实现)
    AUCTION_BUYPRICE_MAX = "AUCTION_BUYPRICE_MAX", --(已实现)
    AUCTION_DEFAULT_SHELF = "AUCTION_DEFAULT_SHELF", --(已实现)
    AUCTION_PUT_LIST_CNT = "AUCTION_PUT_LIST_CNT", --(已实现)
    AUCTION_MONEY = "AUCTION_MONEY", --(已实现)
    AUCTION_CAN_BID = "AUCTION_CAN_BID", --(已实现)
    AUCTION_CAN_BUY = "AUCTION_CAN_BUY", --(已实现)
    AUCTION_HAVE_MY_BIDDING = "AUCTION_HAVE_MY_BIDDING", --(已实现)
    AUCTION_ITEM_STATE = "AUCTION_ITEM_STATE", --(已实现)
    AUCTION_MY_SHOW_LIST = "AUCTION_MY_SHOW_LIST", --(已实现)
    --- 获取最大好友人数
    ---@return number
    FRIEND_MAX_COUNT = "FRIEND_MAX_COUNT", --(已实现)
    --- 根据角色id获取好友信息
    ---@param rid number @角色id
    ---@return FriendProto.FriendInfo @好友信息
    FRIEND_INFO_BY_UID = "FRIEND_INFO_BY_UID", --(已实现)
    --- 根据userName获取好友信息
    ---@param userName string @角色名称
    ---@return FriendProto.FriendInfo @好友信息
    FRIEND_INFO_BY_NAME = "FRIEND_INFO_BY_NAME", --(已实现)
    --- 是否是好友
    ---@param rid number @角色id
    ---@return boolean @是否是好友
    SOCIAL_IS_FRIEND = "SOCIAL_IS_FRIEND", --(已实现)
    --- 是否在黑名单
    ---@param rid number @角色id
    ---@return boolean @是否在黑名单
    SOCIAL_IS_BLICKLIST = "SOCIAL_IS_BLICKLIST", --(已实现)
    --- 获取好友列表
    ---@return table<number,FriendProto.FriendInfo> @好友列表
    FRIEND_LIST = "FRIEND_LIST", --(已实现)
    --- 获取黑名单数据
    ---@return table<number,FriendProto.FriendInfo> @黑名单列表
    FRIEND_BLACKLIST = "FRIEND_BLACKLIST", --(已实现)
    --- 好友申请列表
    ---@return FriendProto.FriendInfo[]  @好友申请列表
    FRIEND_APPLYLIST = "FRIEND_APPLYLIST", --(已实现)
    ADD_STATUS_PERMIT = "ADD_STATUS_PERMIT", --(已实现)
    --- 行会成员列表
    ---@return table
    GUILD_MEMBER_LIST = "GUILD_MEMBER_LIST", --(已实现)
    GUILD_APPLY_LIST = "GUILD_APPLY_LIST", --(已实现)
    GUILD_ALLY_APPLY_LIST = "GUILD_ALLY_APPLY_LIST", --(已实现)
    GUILD_WORLD_LIST = "GUILD_WORLD_LIST",
    GUILD_WORLD_TOTAL_PAGES = "GUILD_WORLD_TOTAL_PAGES",
    GUILD_CREATE = "GUILD_CREATE",
    GUILD_INFO = "GUILD_INFO",
    GUILD_OFFICIAL = "GUILD_OFFICIAL",
    GUILD_MEMBER_INFO = "GUILD_MEMBER_INFO",
    TARGET_ID = "TARGET_ID",
    TARGET_NAME = "TARGET_NAME",
    TRADE_DATA = "TRADE_DATA",
    TRADE_MY_LOCK_STATUS = "TRADE_MY_LOCK_STATUS", --(已实现)
    TRADE_OTHER_LOCK_STATUS = "TRADE_OTHER_LOCK_STATUS",
    DEAL_STATUS_PERMIT = "DEAL_STATUS_PERMIT",
    RANK_DATA_BY_TYPE = "RANK_DATA_BY_TYPE", --(已实现)
    MISSION_ITEM_ORDER = "MISSION_ITEM_ORDER",
    ---获取技能名字
    ---@param param1 number @技能id
    ---@return string @技能数据
    SKILL_NAME = "SKILL_NAME", --(已实现)
    ---获取技能图标
    ---@param param1 number @技能id
    ---@return string @图标名字
    SKILL_ICON_PATH = "SKILL_ICON_PATH", --(已实现)
    ---获取矩形技能图标
    ---@param param1 number @技能id
    ---@return string @技能数据
    SKILL_RECT_ICON_PATH = "SKILL_RECT_ICON_PATH", --(已实现)
    ---是否是开关型技能
    ----@param param1 number @技能id
    ---@return boolean @是否是开关型技能
    SKILL_IS_ONOFF_SKILL = "SKILL_IS_ONOFF_SKILL", --(已实现)
    ---技能是否开启
    ---@param param1 number @技能id
    ---@return boolean @技能是否开启
    SKILL_IS_ON_SKILL = "SKILL_IS_ON_SKILL", --(已实现)
    ---获取已学技能
    ---@param param1 boolean 是否排除普攻（未使用）
    ---@return table<number, Skill> 已学技能表
    LEARNED_SKILLS = "LEARNED_SKILLS", --(已实现)
    ---是否是主动技能
    ---@param param1 number @技能id
    ---@return boolean @是否是主动技能
    SKILL_IS_ACTIVE = "SKILL_IS_ACTIVE", --(已实现)
    ---获取技能数据
    ---@param skillId number @技能id
    ---@return Skill @技能数据
    SKILL_DATA = "SKILL_DATA", --(已实现)
    ---获取技能的等级熟练度数据
    ---@param param1 number @技能id
    ---@return table @熟练度数据
    SKILL_TRAIN_DATA = "SKILL_TRAIN_DATA", --(已实现)
    ---获取技能配置
    ---@param param1 number 技能 ID（未使用）
    ---@return table 技能配置数据 key,value
    SKILL_CONFIG = "SKILL_CONFIG", --(已实现)
    ---根据技能id获取其在轮盘中的索引
    ---@param skillId number @技能id
    ---@return number @技能栏索引
    SKILL_KEY = "SKILL_KEY", --(已实现)
    ---获取技能等级
    ---@param param1 number @技能id
    ---@return number @技能等级
    SKILL_LEVEL = "SKILL_LEVEL", --(已实现)
    ---获取技能展示类型设置
    ---@return number @1 全部 2：转盘
    SKILL_SETTING_SHOW_TYPE = "SKILL_SETTING_SHOW_TYPE", --(已实现) --获取技能展示类型 ESkillType
    ---获取技能展示列表
    ---@return number @技能id列表 ,列表中0表示该位置没有技能
    SKILL_SHOW_LIST = "SKILL_SHOW_LIST", --(已实现) --根据展示类型获取技能id列表
    ---获取主角显示的技能列表数据
    ---@return number[] @技能id列表
    SKILL_ID_LIST_DATA = "SKILL_ID_LIST_DATA", --(已实现)
    ---检查技能等级条件
    ---@param skillId number 技能 ID
    ---@param skillLv number 技能等级
    ---@return boolean
    SKILL_CHECK_LEVEL = "SKILL_CHECK_LEVEL", --(已实现)
    ---检查技能职业条件
    ---@param skillId number 技能 ID
    ---@param skillLv number 技能等级
    ---@return boolean
    SKILL_CHECK_CAREER = "SKILL_CHECK_CAREER", --(已实现)
    ---检查技能装备条件
    ---@param skillId number 技能 ID
    ---@param skillLv number 技能等级
    ---@return boolean
    SKILL_CHECK_EQUIP = "SKILL_CHECK_EQUIP", --(已实现)
    ---检查技能是否解锁
    ---@param skillId number 技能 ID
    ---@param skillLv number 技能等级
    ---@return boolean
    SKILL_CHECK_IS_UNLOCK = "SKILL_CHECK_IS_UNLOCK", --(已实现) SKILL_CHECK_LEVEL and SKILL_CHECK_CAREER and SKILL_CHECK_EQUIP
    ---检查技能消耗/需求条件
    ---@param skillId number 技能 ID
    ---@param skillLv number 技能等级
    ---@return boolean
    SKILL_CHECK_NEED = "SKILL_CHECK_NEED", --(已实现)
    ---检查技能是否可学习
    ---@param skillId number 技能 ID
    ---@return boolean
    SKILL_CHECK_CAN_LEARN = "SKILL_CHECK_CAN_LEARN", --(已实现) SKILL_CHECK_IS_UNLOCK and SKILL_CHECK_NEED
    ---检查技能是否可升级
    ---@param skillId number 技能 ID
    ---@param skillLv number 技能等级
    ---@return boolean 是否可以升级
    SKILL_CHECK_CAN_UPGRADE = "SKILL_CHECK_CAN_UPGRADE", --(已实现)
    ---检查技能红点（可学习/可升级/已解锁等）
    ---@param skillId number 技能 ID
    ---@param skillLv number 技能等级
    ---@return boolean
    SKILL_CHECK_RED_DOT = "SKILL_CHECK_RED_DOT",
    ---检查技能是否可释放
    ---@param skillId number 技能 ID
    ---@param targetId number 目标角色 ID
    ---@param targetCoord Dot2 目标坐标
    ---@param secTargetCoord Dot2 第二目标坐标，如果“第二目标坐标”不为空,表示判断secTargetCoord在攻击targetId（targetCoord）时，secTargetCoord是否能被攻击到
    ---@return boolean @Boolean或number(枚举值)对应技能无法释放原因
    SKILL_CHECK_CAN_USE = "SKILL_CHECK_CAN_USE",
    ---检查技能是否已学习
    ---@param skillId number 技能 ID
    ---@return boolean
    SKILL_CHECK_IS_LEARNED = "SKILL_CHECK_IS_LEARNED", --(已实现) 
    ---获取普攻技能 ID
    ---@return number | nil
    SKILL_GET_COMMON_ID = "SKILL_GET_COMMON_ID", --获取自己的普通技能Id
    ---获取主角职业配置表数据
    ---@return cfg_career_column | nil @主角职业配置表数据
    ME_CAREER_TAB_COLUMN = "ME_CAREER_TAB_COLUMN", --(已实现)
    ---获取快捷栏数据
    ---@return number[], number[] 快捷栏物品/技能 ID 列表, 快捷栏类型列表
    FAST_ITEM_ID_LIST = "FAST_ITEM_ID_LIST", --(已实现)
    ---背包最大格子数量
    ---@return number @格子数量
    MAX_BAG = "MAX_BAG", --(已实现)
    ---检测物品背包是否有富余格子数存放
    ---@param param1 number 物品 cfgId（未使用）
    ---@param param2 number 物品数量（未使用）
    ---@param param3 boolean 空间不足时是否提示（未使用）
    ---@return boolean 是否有富余格子数
    BAG_REMAIN_COUNT = "BAG_REMAIN_COUNT", --(已实现)
    --- 获取背包锁定格子数
    ---@return number 锁定格子数量
    BAG_FORBID_COUNT = "BAG_FORBID_COUNT", --(已实现)
    ---通过值获取地图缩放对应百分比
    ---@param param1 number @地图缩放值
    MAPSCALE_PER = "MAPSCALE_PER", --(已实现)
    ---通过百分比获取地图缩放值
    ---@param param1 number @百分比
    MAPSCALE_VALUE = "MAPSCALE_VALUE", --(已实现)
    ---除装备Map 显示持久的stdmode
    ---@return CommonProtos.Item[] @获取除装备外的持久的stdmode的物品
    EQUIPMAP_BY_STDMODE = "EQUIPMAP_BY_STDMODE", --(已实现)
    EX_SHOWLAST_MAP = "EX_SHOWLAST_MAP", --(已实现)
    ---通过stdmode获取装备位
    ---@param param1 number @装备的类型
    ---@return EEquipSlotType @返回装备位
    EQUIP_POS_BY_STDMODE = "EQUIP_POS_BY_STDMODE", --(已实现)
    ---获取cfg_att_score表的attribute字段（无效接口，cfg_att_score表不存在）
    ---@param param1 number @表中的key
    ATTR_CONFIG = "ATTR_CONFIG", --(已实现)
    ---通过 cfg_item_Suit表id获取cfg_equip_suit表的id（不推荐使用，外置可自行读表）
    ---@param param1 number @表中的suitid
    SUIT_CONFIG = "SUIT_CONFIG", --(已实现)
    ---根据道具数据获取物品类型
    ---@param cfgId number @道具Id （cfg_item表id）
    ---@return EItemType_Enum 道具类型
    ITEMTYPE = "ITEMTYPE", --(已实现)
    ---根据道具数据获取物品子类型
    ---@param cfgId number @道具Id （cfg_item表id）
    ---@return number @子类型
    ITEMSUBTYPE = "ITEMSUBTYPE", --(已实现)
    ---根据道具cfgId获取道具是否可以交易
    ITEM_IS_DEAL = "ITEM_IS_DEAL", --(已实现)
    ---根据道具cfgId获取道具顶部文本
    ITEM_TOP_DESC = "ITEM_TOP_DESC", --(已实现)
    ---根据道具cfgId获取道具中部文本
    ITEM_MID_DESC = "ITEM_MID_DESC", --(已实现)
    ---根据道具cfgId获取道具底部文本
    ITEM_BOTTOM_DESC = "ITEM_BOTTOM_DESC", --(已实现)
    ---通过商品Id获取商品信息
    ---@param param1 number @商品Id
    RECHARGE_PRODUCT_BY_ID = "RECHARGE_PRODUCT_BY_ID", --(已实现)
    ---是否接入第三方SDK
    IS_SDK_PAY = "IS_SDK_PAY", --(已实现)
    ---根据角色id获取摊位名字
    ---@return string
    SELL_SHOW_NAME = "SELL_SHOW_NAME", --(已实现)
    ---检测该合成页签是否显示  返 boolean
    ---@param param1 number @合成表page1
    ---@param param2 number @合成表page1 * 1000 + 合成表page2
    COMPOUND_CHECK_LIST_IS_SHOW = "COMPOUND_CHECK_LIST_IS_SHOW", --(已实现)
    ---获取合成页签名字  返 string
    ---param1: 合成表page1 * 1000 + 合成表page2
    COMPOUND_PAGE_NAME = "COMPOUND_PAGE_NAME", --(已实现)
    ---获取主角名字
    ---@return string @主角名字
    USER_NAME = "USER_NAME", --(已实现)
    ---获取主角所在的战盟名
    ---@return string
    UNION_NAME = "UNION_NAME", --(已实现)
    ---获取主角的根职业
    ---@return number @0：战士 1：法师 2：道士
    JOB = "JOB", --(已实现)
    ---获取主角等级
    ---@return number @主角等级
    LEVEL = "LEVEL", --(已实现)
    ---获取主角职业名字
    JOB_NAME = "JOB_NAME", --(已实现)
    ---获取主角性别(暂不支持分性别)
    SEX = "SEX", --(已实现)
    ---获取主角姓名
    REAL_USER_NAME = "REAL_USER_NAME", --(已实现)
    ---获取主角名字颜色（无效接口）
    USER_NAME_COLOR = "USER_NAME_COLOR", --(已实现)
    ---获取主角人物朝向
    ---@return number @0：上,1：右上,2：右,3：右下,4：下,5：左下,6：左,7：左上,0xff：无效位置
    DIR = "DIR", --(已实现)
    ---获取主角是否死亡
    USER_IS_DIE = "USER_IS_DIE", --(已实现)
    ---获取主角血量
    ---@return number @主角血量
    HP = "HP", --(已实现)
    ---获取主角最大血量
    ---@return number @主角最大血量
    MAXHP = "MAXHP", --(已实现)
    ---获取主角蓝量
    ---@return number @主角蓝量
    MP = "MP", --(已实现)
    ---获取主角最大蓝量
    ---@return number @主角最大蓝量
    MAXMP = "MAXMP", --(已实现)
    BURST = "BURST", --(已实现)
    BURST_DAM = "BURST_DAM", --(已实现)
    IMM_ATT = "IMM_ATT", --(已实现)
    IMM_MAG = "IMM_MAG", --(已实现)
    DROP = "DROP", --(已实现)
    ---@return number --- 幸运
    LUCK = "LUCK", --(已实现)
    AC = "AC", --(已实现)
    MAXAC = "MAXAC", --(已实现)
    MAC = "MAC", --(已实现)
    MAXMAC = "MAXMAC", --(已实现)
    DC = "DC", --(已实现)
    MAXDC = "MAXDC", --(已实现)
    MC = "MC", --(已实现)
    MAXMC = "MAXMC", --(已实现)
    SC = "SC", --(已实现)
    MAXSC = "MAXSC", --(已实现)
    HIT = "HIT", --(已实现)
    ---@return number --- 敏捷
    SPD = "SPD", --(已实现)
    ---@return number --- 获取主角当前经验值
    EXP = "EXP", --(已实现)
    ---@return number --- 获取主角最大经验值
    MAXEXP = "MAXEXP", --(已实现)
    ---获取主角当前攻速
    HITSPD = "HITSPD", --(已实现)
    HW = "HW",
    MAXHW = "MAXHW", --(已实现)
    BW = "BW",
    MAXBW = "MAXBW", --(已实现)
    WW = "WW",
    MAXWW = "MAXWW", --(已实现)
    --HUNGER = "HUNGER", --(已实现)
    DRESS = "DRESS",
    WEAPON = "WEAPON",
    RIGHTHAND = "RIGHTHAND",
    HELMET = "HELMET",
    NECKLACE = "NECKLACE", --(已实现)
    RINGR = "RINGR",
    RINGL = "RINGL",
    ARMRINGR = "ARMRINGR",
    ARMRINGL = "ARMRINGL",
    BUJUK = "BUJUK",
    BELT = "BELT",
    BOOTS = "BOOTS",
    CHARM = "CHARM",
    EQUIPBYPOS = "EQUIPBYPOS", --(已实现)
    -----------------------原变量获取-----------------------
    ---根据类型id获取属性值
    ---@param param1 number|EMUCharacterAttrType @属性id
    ---@return number @属性值
    GET_ATTR_VALUE_BY_ID = "GET_ATTR_VALUE_BY_ID", --(已实现)
    ---获取装备所有物品数据
    ---@return  table<number,table<number,CommonProtos.Item>>  @<cfg_wearing_bar的id,<EEquipSlotType,CommonProtos.Item>>
    EQUIP_DATA = "EQUIP_DATA", --(已实现)
    ---获取玩家对应装备位数据列表
    ---@param param1 EEquipSlotType @装备位置
    ---@return CommonProtos.Item[] @对应装备位的所有装备
    EQUIP_DATA_LIST = "EQUIP_DATA_LIST", --(已实现)
    EMBATTLE = "EMBATTLE",
    ---获取玩家的外观数据
    ---@return table<EEquipSlotType,number>
    FEATURE = "FEATURE", --(已实现)
    HAIR = "HAIR",
    EQUIP_POS_DATAS = "EQUIP_POS_DATAS",
    ---玩家的称号数据  --称号数据移至外置
    TITLES = "TITLES", --(已实现)
    ---获取玩家对应ID的称号数据 --称号数据移至外置
    TITLE_DATA_BY_ID = "TITLE_DATA_BY_ID", --(已实现)
    ---玩家激活的称号id --称号数据移至外置
    ACTIVATE_TITLE = "ACTIVATE_TITLE", --(已实现)
    INTERNAL_FORCE = "INTERNAL_FORCE",
    INTERNAL_MAXFORCE = "INTERNAL_MAXFORCE", --(已实现)
    INTERNAL_EXP = "INTERNAL_EXP", --(已实现)
    INTERNAL_MAXEXP = "INTERNAL_MAXEXP", --(已实现)
    INTERNAL_LEVEL = "INTERNAL_LEVEL", --(已实现)
    INTERNAL_DZ_CURVALUE = "INTERNAL_DZ_CURVALUE",
    INTERNAL_DZ_MAXVALUE = "INTERNAL_DZ_MAXVALUE", --(已实现)
    INTERNAL_SKILLS = "INTERNAL_SKILLS",
    INTERNAL_SKILL_DATA = "INTERNAL_SKILL_DATA", --(已实现)
    INTERNAL_SKILL_TRAIN_DATA = "INTERNAL_SKILL_TRAIN_DATA", --(已实现)
    INTERNAL_SKILL_ONOFF = "INTERNAL_SKILL_ONOFF",
    INTERNAL_SKILL_RECT_ICON_PATH = "INTERNAL_SKILL_RECT_ICON_PATH", --(已实现)
    INTERNAL_SKILL_NAME = "INTERNAL_SKILL_NAME", --(已实现)
    INTERNAL_SKILL_DESC = "INTERNAL_SKILL_DESC", --(已实现)
    MERIDIAN_DESC = "MERIDIAN_DESC", --(已实现)
    MERIDIAN_AUCPOINT_STATE = "MERIDIAN_AUCPOINT_STATE",
    MERIDIAN_OPEN_LIST = "MERIDIAN_OPEN_LIST",
    MERIDIAN_LV = "MERIDIAN_LV",
    ---获取已配置的连击技能列表
    ---@return table
    HAVE_COMBO_SKILLS = "HAVE_COMBO_SKILLS", --(已实现)
    ---获取指定连击技能数据
    ---@param param1 number 连击技能 ID
    ---@return any
    COMBO_SKILL_DATA = "COMBO_SKILL_DATA", --(已实现)
    ---获取指定连击技能等级
    ---@param param1 number 连击技能 ID
    ---@return number | nil
    COMBO_SKILL_TRAIN_DATA = "COMBO_SKILL_TRAIN_DATA", --(已实现)
    SET_COMBO_SKILLS = "SET_COMBO_SKILLS",
    OPEN_COMBO_NUM = "OPEN_COMBO_NUM",
    IS_LEARNED_INTERNAL = "IS_LEARNED_INTERNAL",
    EXTRA_COMBO_BJRATE = "EXTRA_COMBO_BJRATE", --(已实现)
    ---角色能否跑
    ---@return boolean @是否能跑
    CAN_RUN_ABLE = "CAN_RUN_ABLE", --(已实现)
    LOOK_USER_ID = "LOOK_USER_ID", --(已实现)
    LOOK_USER_NAME = "LOOK_USER_NAME", --(已实现)
    LOOK_USER_NAME_COLOR = "LOOK_USER_NAME_COLOR", --(已实现)
    PLAYER_INITED = "PLAYER_INITED", --(已实现)
    --- 剩余点数
    ---@return number @剩余属性点数
    REMAIN_ATTR_POINT = "REMAIN_ATTR_POINT", --(已实现)
    ---获取玩家登录区服列表
    ---@return ServerStruct[] @服务器列表
    PLAYER_LOGIN_SERVERLIST = "PLAYER_LOGIN_SERVERLIST", --(已实现)
    ---获取玩家选择登录区服数据
    ---@return ServerStruct 登录区服数据
    PLAYER_LOGIN_CURSERVER = "PLAYER_LOGIN_CURSERVER", --(已实现)
    ---获取玩家已创建角色数据
    ---@return UserProtos.RoleInfo[] 已创建角色数据
    PLAYER_CREATEROLE_HAVEROLE = "PLAYER_CREATEROLE_HAVEROLE", --(已实现)
    ---获取当前创角界面随机名称 返回 string
    ---@return string
    PLAYER_CREATEROLE_RANDOMNAME = "PLAYER_CREATEROLE_RANDOMNAME", --(已实现)
    ---获取职业解锁信息
    ---@param param1 number 职业根id
    ---@return boolean 是否解锁职业
    PLAYER_CREATEROLE_UNLOCKCAREER = "PLAYER_CREATEROLE_UNLOCKCAREER", --(已实现)
    ---获取buff描述
    ---@param cfgId number @buff的cfg_buffer表的id
    ---@return string @buff的描述
    GET_BUFF_DESCRIDE = "GET_BUFF_DESCRIDE", --(已实现)
    GEt_BUFF_BEHAVIOUR = "GEt_BUFF_BEHAVIOUR", --获取某个角色是否有某种buff行为
    ---获取某个角色是否有某种buff行为
    ---@param actorID number @角色id,如果是nil，就用自己
    ---@param stateType EBuffParamType_State
    ---@return boolean,Buff @是否有buff,Buff数据(如果有)
    IS_HAS_STATE_BUFF = "IS_HAS_STATE_BUFF", --获得某个角色是否有某种buff，和GEt_BUFF_BEHAVIOUR的区别是，GEt_BUFF_BEHAVIOUR有一些IS_HAS_STATE_BUFF的组合
    ---@param systemName string @cfg_system_switch systemName 系统名称
    ---@return boolean
    ---判断该功能是否开启
    IS_OPEN_SYSTEMFUNCTION = "IS_OPEN_SYSTEMFUNCTION", --(已实现)
    ---获取主角护盾值
    ---@return number @主角护盾值
    SHIELD = "SHIELD", --(已实现)
    ---获取主角最大护盾值
    ---@return number @主角最大护盾值
    MAXSHIELD = "MAXSHIELD", --(已实现)
    ---获取主角技能值
    ---@return number @主角技能值
    AGSTO = "AGSTO", --(已实现)
    ---获取主角最大技能值
    ---@return number @主角最大技能值
    MAXAGSTO = "MAXAGSTO", --(已实现)
    ---获取主角拓展经验
    ---@return number @主角拓展经验
    EXPANDEXP = "EXPANDEXP", --(已实现)
    ---获取某角色护盾值
    ---@param actorID number @角色id
    ---@return number @角色护盾值
    ACTOR_SHIELD = "ACTOR_SHIELD", --(已实现)
    ---获取某角色最大护盾值
    ---@param actorID number @角色id
    ---@return number @角色最大护盾值
    ACTOR_MAXSHIELD = "ACTOR_MAXSHIELD", --(已实现)
    ---获取某角色技能值
    ---@param actorID number @角色id
    ---@return number @角色技能值
    ACTOR_AGSTO = "ACTOR_AGSTO", --(已实现)
    ---获取某角色最大技能值
    ---@param actorID number @角色id
    ---@return number @角色最大技能值
    ACTOR_MAXAGSTO = "ACTOR_MAXAGSTO", --(已实现)
    ---根据传入道具id获取激活套装id列表
    ---@return number[] cfg_equip_suit的id列表
    ---@param id number @道具cfgId
    GET_EQUIPSUIT_BY_ID = "GET_EQUIPSUIT_BY_ID", --(已实现)---当前装备套装激活的套装id
    --- 获取免费buff
    ---@return table<number,BufferProtos.FreeBuff>
    GET_FREEBUFF = "GET_FREEBUFF", --(已实现) -- 获取免费buff 

    ---获取召唤兽当前状态
    ---@return number @EFSMState枚举,对应cfg_behaviour表里面的state
    GET_SUMMONBEASTS_STATE = "GET_SUMMONBEASTS_STATE", --(已实现)
    ---判断是否满足召唤兽激活条件
    ---@param skillId @技能id
    ---@return boolean
    SUMMONBEASTS_CONDITI_ON_CHECK = "SUMMONBEASTS_CONDITI_ON_CHECK", --(已实现)
    ---获取当前召唤兽的技能id
    ---@return number
    GET_SUMMONBEASTS_SKILL_ID = "GET_SUMMONBEASTS_SKILL_ID", --(已实现)
    ---获取当前召唤兽的怪物id
    ---@return number
    GET_SUMMONBEASTS_MONSTER_ID = "GET_SUMMONBEASTS_MONSTER_ID", --(已实现)
    ---获取当前召唤兽是否可召唤
    ---@return number
    SUMMONBEASTS_CAN_BEASTS_CHECK = "SUMMONBEASTS_CAN_BEASTS_CHECK", --(已实现)
    ---根据技能id获取召唤兽的cfg_pet的id
    ---@return number
    GET_SUMMONBEASTS_PET_ID = "GET_SUMMONBEASTS_PET_ID", --(已实现)
    ---根据技能id获取召唤兽的cfg_pet的表数据
    ---@return table @cfg_pet表数据
    GET_SUMMONBEASTS_PET_CFG_DATA = "GET_SUMMONBEASTS_PET_CFG_DATA",
    ---获取召唤兽当前存活状态
    ---@return number
    GET_SUMMONBEASTS_ALIVESTATE = "GET_SUMMONBEASTS_ALIVESTATE",

    ---获取NPC对话内容
    GET_NPC_TALK_CONTENT = "GET_NPC_TALK_CONTENT", -- (已实现)获取NPC对话内容
    ---获取视野内单一NPC的信息
    GET_NPC_INFOBYID = "GET_NPC_INFOBYID", --(已实现) -- 获取NPC信息
    ---获取NPC位置
    GET_NPC_POSITION = "GET_NPC_POSITION", -- (已实现)获取npc位置
    ---能否打开NPC功能面板
    IS_OPEN_NPCPANEL = "IS_OPEN_NPCPANEL", -- (已实现)是否可以打开NPC功能面板
    ---与视野内某NPC的距离
    NPC_DISTANCE = "NPC_DISTANCE", -- (已实现)与视野内某NPC的距离
    ---获取视野内的NPC
    SEE_NPC = "SEE_NPC", -- (已实现)视野内的npc
    ---通过cfgID获取模型
    GET_NPC_MODEL = "GET_NPC_MODEL", -- (已实现)通过npccfgID获取模型
    ---是否为任务对话 NPC
    ---@param cfgid number NPC 配置 ID
    ---@return boolean
    IS_TASK_NPC = "IS_TASK_NPC", -- (已实现)是否是任务NPC

    --- 根据npcid获取NPC商店的ShopId
    GET_NPC_SHOPID = "GET_NPC_SHOPID", -- (已实现)根据npcid获取NPC商店的ShopId
    ---获取玩家某一装备数据
    ---@param param1 number @穿戴栏id
    ---@param param2 number @穿戴位置
    ---@return CommonProtos.Item
    EQUIP_TARGET_DATA = "EQUIP_TARGET_DATA", --(已实现) --获取指定穿戴栏指定部位装备数据

    ---获取正在进行中的任务 ID 列表
    ---@return number[]
    PROCESS_TASK = "PROCESS_TASK",
    ---获取已完成任务 ID 列表
    ---@return number[] @ 已完成的任务列表
    ALL_FINISH_TASK = "ALL_FINISH_TASK",
    --pk模式
    Check_PKMODE_IS_ATTACK_PLAYER = "Check_PKMODE_IS_ATTACK_PLAYER", --(已实现)当前战斗模式是否能攻击

    ---获取怪物信息
    ---@param monsterId number 怪物唯一 ID
    ---@return Role | nil
    GET_MONSTER_DATA_BY_ID = "GET_MONSTER_DATA_BY_ID", --获取怪物信息
    ---获取视野内怪物List
    ---@return table<number, Role>
    GET_MONSTER_DATA_LIST = "GET_MONSTER_DATA_LIST", --获取视野内怪物列表
    ---获取地图boss列表(地图列表的怪
    ---@return any
    GET_MONSTER_BOSS_INFO_LIST = "GET_MONSTER_BOSS_INFO_LIST", --获取地图boss列表(地图列表的怪
    ---获取掉落道具列表
    ---@return table
    GET_MONSTER_DROP_ITEM_LIST = "GET_MONSTER_DROP_ITEM_LIST", --获取掉落道具信息
    ---获取主动仇恨目标
    ---@return number
    GET_PROACTIVELY_TARGET = "GET_PROACTIVELY_TARGET", ---(已实现)获取主动仇恨目标
    ---获取被动仇恨目标
    ---@return number
    GET_PASSIVE_TARGET = "GET_PASSIVE_TARGET", ---(已实现)获取被动目标
    ---获取仇恨目标列表
    ---@return HateTargetInfo[]
    GET_HATE_TARGETS = "GET_HATE_TARGETS", ---(已实现)获取仇恨目标列表
    ---根据条件获取周围的角色id集合
    ---@param coordX number x坐标
    ---@param coordZ number y坐标
    ---@param range number 范围
    ---@param count number 查找数量
    ---@param checkFunc number 查找判断回调
    ---@param roleType number 查找类型
    ---@param is3DHookFind number 是否是在挂机情况下查找
    ---@param excludeRoleTypes table 查找除该类型外的角色
    ---@return number[]
    GET_ROLE_BY_CONDITION = "GET_ROLE_BY_CONDITION", ---(已实现)根据条件获取周围的角色
    ---获取背景音乐音量
    ---@return number
    GET_BACKGROUND_SOUND = "GET_BACKGROUND_SOUND", --(已实现)获取背景声音音量
    ---获取音效音量
    ---@return number
    GET_SOUND_EFFECT = "GET_SOUND_EFFECT", --(已实现)获取音效音量
    ---获取语音音量
    ---@return number @当前音量
    GET_VOICE = "GET_VOICE", --(已实现)获取语音音量
    ---获取摇杆类型
    ---@return ETickModel
    GET_ROCKER_TYPE = "GET_ROCKER_TYPE", --(已实现)获取摇杆类型
    ---获取是否勾选点击地板移动
    ---@return ETickModel
    GET_CLICK_FLOOR_IS_SELECT = "GET_CLICK_FLOOR_IS_SELECT", --(已实现)获取是否勾选点地板移动
    ---获取杀怪范围
    ---@return number
    GET_KILL_RANGE = "GET_KILL_RANGE", --(已实现)获取杀怪范围
    ---获取自动吃加蓝药百分比值
    ---@return number
    GET_EAT_HP_PILL_PERCENTAGE = "GET_EAT_HP_PILL_PERCENTAGE", --(已实现)获取自动吃加血药百分比值
    ---获取自动吃加蓝药百分比值
    ---@return number
    GET_EAT_MP_PILL_PERCENTAGE = "GET_EAT_MP_PILL_PERCENTAGE", --(已实现)获取自动吃加蓝药百分比值
    ---获取是否自动反击
    ---@return boolean
    GET_IS_COUNTERATTACK = "GET_IS_COUNTERATTACK", --(已实现)获取是否自动反击
    ---获取挂机是否返回原点
    ---@return boolean
    GET_IS_COMEBACK_HOOKPOINT = "GET_IS_COMEBACK_HOOKPOINT", --(已实现)获取挂机是否返回原点
    ---获取返回挂机点的等待时间
    ---@return number
    GET_COMEBACK_HOOKPOINT_WAIT_TIEM = "GET_COMEBACK_HOOKPOINT_WAIT_TIEM", --(已实现)获取返回挂机点的等待时间
    ---获取召唤技能
    ---@return number
    GET_CALL_SKILL = "GET_CALL_SKILL", --(已实现)获取召唤技能
    ---获取自动战斗释放的技能方案
    ---@return number
    GET_HOOK_ATUO_RELEASE_SKILL_PLAN = "GET_HOOK_ATUO_RELEASE_SKILL_PLAN", --(已实现)获取自动战斗释放的技能方案
    ---获取自动战斗释放的技能
    ---@return table @勾选的所有挂机技能id
    GET_HOOK_ATUO_RELEASE_SKILL = "GET_HOOK_ATUO_RELEASE_SKILL", --(已实现)获取自动战斗释放的技能
    ---获取自动拾取物品列表
    ---@return table<number,boolean>
    GET_ATUO_PICKUP_ITEM = "GET_ATUO_PICKUP_ITEM", --(已实现)获取自动拾取物品列表
    ---获取视野内所有玩家数据
    ---@return table<number,Role> @<roleId,Role>
    GET_PLAYER_DATA_LIST = "GET_PLAYER_DATA_LIST",
    ---获取隐藏玩家模型类型
    ---@return number
    GET_HIDE_PLAYER_MODEL_TYPE = "GET_HIDE_PLAYER_MODEL_TYPE", --(已实现)获取隐藏玩家模型类型
    ---获取隐藏玩家技能特效类型
    ---@return number
    GET_HIDE_PLAYER_SKILL_EFFECT_TYPE = "GET_HIDE_PLAYER_SKILL_EFFECT_TYPE", --(已实现)获取隐藏玩家技能特效类型
    ---获取隐藏玩家翅膀类型
    ---@return number
    GET_HIDE_PLAYER_WING_TYPE = "GET_HIDE_PLAYER_WING_TYPE", --(已实现)获取隐藏玩家翅膀类型
    ---获取隐藏自己翅膀类型
    ---@return number
    GET_HIDE_ME_WING_TYPE = "GET_HIDE_ME_WING_TYPE", --(已实现)获取隐藏自己翅膀类型
    ---获取隐藏玩家足迹类型
    ---@return number
    GET_HIDE_PLAYER_FOOTPRINT_TYPE = "GET_HIDE_PLAYER_FOOTPRINT_TYPE", --获取隐藏玩家足迹类型
    ---获取是否隐藏召唤兽
    ---@return boolean
    GET_IS_HIDE_CALL_MONSTER = "GET_IS_HIDE_CALL_MONSTER", --获取是否隐藏召唤兽
    ---获取是否隐藏怪物模型
    ---@return boolean
    GET_IS_HID_MONSTER_MODEL = "GET_IS_HID_MONSTER_MODEL", --(已实现)获取是否隐藏怪物模型
    ---获取是否隐藏怪物技能特效
    ---@return boolean
    GET_IS_HID_MONSTER_SKILL_EFFECT = "GET_IS_HID_MONSTER_SKILL_EFFECT", --(已实现)获取是否隐藏怪物技能特效
    ---获取是否限制玩家显示数量
    ---@return boolean
    GET_IS_LIMIT_PLAYER_SHOW_COUNT = "GET_IS_LIMIT_PLAYER_SHOW_COUNT", --(已实现)获取是否限制玩家显示数量
    ---获取限制玩家显示数量
    ---@return number
    GET_LIMIT_PLAYER_SHOW_COUNT = "GET_LIMIT_PLAYER_SHOW_COUNT", --(已实现)获取限制玩家显示数量
    ---获取省电模式
    ---@return number
    GET_POWER_SAVING_MODE = "GET_POWER_SAVING_MODE", --(已实现)获取省电模式
    ---获取剩余生成邀请码次数
    ---@return number
    GET_LEFT_GENERATE_INVITE_CODE_COUNT = "GET_LEFT_GENERATE_INVITE_CODE_COUNT", --(已实现)获取剩余生成邀请码次数
    ---获取自动接受组队邀请设置
    ---@return number
    GET_IS_AUTO_ACCEPT_TEAM_INVITATION = "GET_IS_AUTO_ACCEPT_TEAM_INVITATION", --(已实现)获取自动接受组队邀请设置
    ---获取挂机拾取品阶
    ---@return table<cfg_pickdrop_condition表id, EPickUpGrade>
    GET_PICKUP_GRADE = "GET_PICKUP_GRADE", --(已实现)获取挂机拾取品阶

    ---获取所有未读邮件信息
    ---@return MailProto.MailInfo[] @未读邮件列表
    GET_MAIL_UNREAD = "GET_MAIL_UNREAD", --(已实现) 获取未读邮件
    ---获取存在未领取附件的邮件
    ---@return MailProto.MailInfo[] @存在未领取附件的邮件列表
    GET_MAIL_ITEMS = "GET_MAIL_ITEMS", --(已实现) 存在未领取道具的邮件
    ---安全区
    GET_IS_SAFEAREA = "GET_IS_SAFEAREA", --(已实现) 是否在安全区
    ---获取主角所有技能
    GET_ME_ALL_SKILL = "GET_ME_ALL_SKILL", --(获取玩家所有技能)
    ---获取仓库页数
    ---@return number 页数
    GET_STORAGE_MAX_PAGE = "GET_STORAGE_MAX_PAGE", --(获取仓库最大页数)
    --组队
    GET_TEAM_INFO = "GET_TEAM_INFO", --获取自己队伍信息
    --药品
    GET_MEDICINE_TYPE = "GET_MEDICINE_TYPE", --获取药品的类型
    ---获取挂机状态
    ---@return EAutoOnHookStatus 挂机状态
    GET_ONHOOK_STATE = "GET_ONHOOK_STATE", --获取挂机状态
    --- 获取玩家当前骑乘的坐骑id
    ---@param rid number
    ---@return number
    GET_PLAYER_MOUNTID = "GET_PLAYER_MOUNTID", --获取玩家当前骑乘的坐骑id
    ---获取主角装备穿戴栏
    ---@return number[] @穿戴栏 cfg_career表careerWearBar字段
    GET_OPEN_WEARBARS = "GET_OPEN_WEARBARS", --获取玩家职业的穿戴栏
    --- 根据属性类型获取玩家的强化，追加属性值
    ---@param type
    ---@return number
    GET_STRENGTH_ADD_ATTRIBUTE = "GET_STRENGTH_ADD_ATTRIBUTE", --根据属性类型获取玩家的属性值
    ---根据属性名获取对应cfg_att_conversion表信息（不推荐使用,建议直接外置读表）
    ---@param attribute string cfg_att_conversion表attr字段
    ---@return table cfg_att_conversion表数据
    GET_ADD_PER = "GET_ADD_PER",
    GetTimeStamp = "GetTimeStamp", --获取客户端本地时间戳
    GetOpenTimeStamp = "GetOpenTimeStamp", --获取开服时间的时间戳
    --- 是否解锁盒子特权
    ---@return  boolean @是否解锁盒子特权
    GET_BOX_PRIVILEGE = "GET_BOX_PRIVILEGE", -- 是否解锁特权
    --- 是否领取盒子每日奖励
    ---@return boolean @是否领取盒子每日奖励
    GET_BOX_DAILY_GIFT = "GET_BOX_DAILY_GIFT", -- 是否领取每日奖励
    ---获取连击技能数据
    ---@return table
    GET_COMBO_SKILL = "GET_COMBO_SKILL", --获取玩家连击技能
    --- 获取系统功能任务状态
    ---@param systemName string 功能名
    ---@return boolean | nil 状态（nil 表示未记录）
    GET_SYSTEM_FUNCTION_TASK_STATE = "GET_SYSTEM_FUNCTION_TASK_STATE", --获取系统功能任务状态
    ---获取当前选中的目标id
    ---@return number @角色rid
    GET_CUR_SELECT_TARGET_ID = "GET_CUR_SELECT_TARGET_ID", --获取当前选中的目标id
    --- 获取玩家当前是否上马
    ---@param rid number
    ---@return boolean
    GET_PLAYER_IS_ON_MOUNTID = "GET_PLAYER_IS_ON_MOUNTID", --获取玩家当前是否上马
    ---获取角色当前播放的动画名
    ---@param rid number 角色 ID
    ---@return string | nil
    ACTION_GET_CURRENT_ANIMNAME = "ACTION_GET_CURRENT_ANIMNAME", --获得当前正在播放的动画名称
    --- 获取位置是否在安全区内
    ---@param x number
    ---@param z number
    ---@return boolean
    GET_CELL_IS_SAFE_AREA = "GET_CELL_IS_SAFE_AREA", --获取位置是否在安全区内
    --- 获取角色是否骑乘坐骑
    ---@param rid number
    ---@return boolean | nil
    GET_PLAYER_IS_RIDE_MOUNT = "GET_PLAYER_IS_RIDE_MOUNT", --获取角色是否骑乘坐骑
    ---是否允许显示 996 交易行入口
    ---@return boolean
    CAN_TRADING996_SHOW = "CAN_TRADING996_SHOW",--996交易行入口是否显示
    --- 根据角色类型获取指定类型的所有角色
    ---@param roleType ERoleType
    ---@return table
    GET_ALL_ROLE_BY_ROLE_TYPE = "GET_ALL_ROLE_BY_ROLE_TYPE",--根据角色类型获取指定类型的所有角色
 
}

-----@class EServerTogKey
--EServerTogKey = {
--    SW_KEY_AUCTION = "SW_KEY_AUCTION", -- 服务器开关 拍卖
--    SW_KEY_ALL_FIGHTPAGES = "SW_KEY_ALL_FIGHTPAGES", -- 服务器开关 显示所有战斗页
--    SW_KEY_MISSTION = "SW_KEY_MISSTION", -- 服务器开关 任务
--    SW_KEY_SNDAITEMBOX = "SW_KEY_SNDAITEMBOX", -- 服务器开关 是否显示首饰盒
--    SW_KEY_TRADE_DEAL = "SW_KEY_TRADE_DEAL", -- 服务器开关 面对面交易 true/需要面对面
--    SW_KEY_AUTO_DRESS = "SW_KEY_AUTO_DRESS", -- 服务器开关 自动穿戴
--    SW_KEY_OPEN_F_EQUIP = "SW_KEY_OPEN_F_EQUIP", -- 服务器开关 时装是否开启首饰
--    SW_KEY_BIND_GOLD = "SW_KEY_BIND_GOLD", -- 服务器开关 开启元宝替换绑元
--    SW_KEY_NPC_BUTTON = "SW_KEY_NPC_BUTTON", -- 服务器开关 显示npc按钮
--    SW_KEY_NPC_NAME = "SW_KEY_NPC_NAME", -- 服务器开关 显示npc名字 1:不显示
--    SW_KEY_DROP_TIPS = "SW_KEY_DROP_TIPS", -- 服务器开关 显示绑定丢弃提示 0:显示
--    SW_KEY_EXP_IN_CHAT = "SW_KEY_EXP_IN_CHAT", -- 服务器开关 经验信息是否显示在聊天框 0：显示在聊天框
--    SW_KEY_SHOW_STALL_NAME = "SW_KEY_SHOW_STALL_NAME", -- 服务器开关 是否显示默认摊位名字  0：显示
--    SW_KEY_PLAYER_BLUE_BLOOD = "SW_KEY_PLAYER_BLUE_BLOOD", -- 服务器开关  是否显示蓝条HUD_SPRITE_MP   0: 显示
--    SW_KEY_ITEMTIPS_TOUBAO_SHOW = "SW_KEY_ITEMTIPS_TOUBAO_SHOW", -- 服务器开关  是否禁止双烈火    1：禁止
--    SW_KEY_ALL_TEAM_EXP = "SW_KEY_ALL_TEAM_EXP", -- 服务器开关 是否开启全队经验 true/false
--    SW_KEY_EQUIP_EXTRA_POS = "SW_KEY_EQUIP_EXTRA_POS", -- 服务器开关，是否有额外的装备位置  1= 开启 0 = 关闭
--}

------------------------------------枚举----------------------------------------------
---@class EItemFromUI_Enum
EItemFromUI_ENUM = {
    BAG = 1, -- 背包
    PALYER_EQUIP = 2, -- 玩家身上
    QUICK_USE = 3, -- 快捷栏
    STORAGE = 4, -- 仓库
    BAG_GOLD = 5, -- 背包金币
    SELL = 6, -- 摆摊
    REQUIRE = 7, -- npc商店
    TRADE = 8, -- 面对面交易
    STALL = 9,
    TRADE_GOLD = 10, -- 交易
    BEST_RINGS = 11, -- 极品首饰
    AUTO_TRADE = 12, -- 摆摊
    ITEMBOX = 13, -- 自定义UI ITEMBOX
    NPC_DO_SOMETHING = 14, -- NPC自定义放入框
    NEWTYPE = 15,
    HERO_BAG = 66, -- 英雄背包
    HERO_EQUIP = 67, -- 英雄装备
    HERO_BEST_RINGS = 68, -- 英雄极品首饰
    SSR_ITEM_BOX = 77, -- ssr 自定义ItemBox
    PETS_EQUIP = 78, -- 宠物装备
    SKILL_WIN = 79, -- PC 技能
    OTHER = 99          -- 其他
}

---@class EItemType_Enum
EItemType_Enum = {
    DruaAndSomething = 1, -- 道具表 StdMode 0~3 的道具
    SkillBook = 2, -- 技能书 道具表 StdMode 4  的道具
    Equip = 3, -- 装备
    Bundle = 4, -- 困束  道具表 StdMode 31  的道具
    Box = 5, -- 盒子  道具表 StdMode 200 的道具
    TreasureMap = 6, -- StdMode 为 101 的道具
    FashionItem = 7, -- 时装道具  道具表 StdMode 102 的道具
    MonsterCard = 8, -- 怪物卡片  道具表 StdMode 103 的道具
    SomethingCanUse = 9, -- 道具表 StdMode 为 49 的道具
    BoxKey = 10, -- 箱子钥匙  道具表 StdMode 40 的道具
    Collimator = 11, -- 准星道具  道具表 StdMode 47 的道具
    WishBox = 12, -- StdMode 为 96 的道具
    NewPet = 13, -- 宠物道具 道具表 StdMode 201 的道具
    Other = 99       -- 其他
}

---------------------------------------------------------------------------


---@class ESkillUIShowPage
ESkillUIShowPage = {

    Describe = enum(0),
    Setting = enum(),
    Drug = enum(),
}

EBagTileScrollViewId = {
    Bag = enum(),
    Storage = enum(),
    Recover = enum(),
}
---@class ESystemType
ESystemType = {
    UIPanel = enum(1), --界面
    Btn = enum(2), --按钮
}
---@class EAutoOnHookStatus
EAutoOnHookStatus = {
    OnHooking = enum(1), ---挂机中
    PauseOnHook = enum(2), --暂停挂机
    StopOnHook = enum(3), --停止挂机
}

---@class EChatChannelType
EChatChannelType = {
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
EChatChannelTypeStr = {
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

---外置替换引擎方法的枚举
---@class EReplaceEngineFunc
EReplaceEngineFunc = {
    ---替换职业表，外置职业表可能由更多索引
    CareerTbl_GetCareer = enum(),
    CheckSkillRedDotExt = enum(), --检查外部额外增加的技能升级红点条件
    ClickNpcCallback = enum(), --点击npc回调，返回true或者false来决定是否要替换原有逻辑
    CalcEquipGrade = enum(), --计算装备评分
    GetDropEquipExtraNameSuffix = enum(), --获取掉落装备的显示名称的后缀
    GetDropEquipExtraColor = enum(), --获取掉落装备的显示名称的颜色，如果没有则按照引擎算法显示
    CheckCanAutoTasking = enum(), --检查当前地图在长时间等待后可不可以自动做任务
    GetDropItemNameScale = enum(), --自定义掉落HUD名称显示的缩放比例
    CompareEquipEntrys = enum(), --比较两件装备的词条
    OnResTaskReward = enum(), --自定义任务完成奖励处理，替换当前的打开奖励面板
}

--endregion


