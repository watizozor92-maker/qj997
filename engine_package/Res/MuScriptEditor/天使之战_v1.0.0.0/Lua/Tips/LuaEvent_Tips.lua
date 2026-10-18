--对外事件

LUA_EVENT_ROLE_PROPERTY_INITED = enum(1000000)  --(已实现)  玩家角色属性初始化完毕
LUA_EVENT_ROLE_PROPERTY_CHANGE = enum()  --(已实现)  玩家属性变化时
LUA_EVENT_ROLE_ATTR_CHANGE_BEFORE = enum()  --(已实现)  玩家属性变化前
---等级改变
---@param level number 当前等级
---@param oldlevel number 之前等级
LUA_EVENT_LEVELCHANGE = enum()  --(已实现)  等级改变
LUA_EVENT_REINLEVELCHANGE = enum()  --转生等级改变
---经验改变
---@param exp number 当前全部经验
LUA_EVENT_EXPCHANGE = enum()  --(已实现) EXP改变
LUA_EVENT_BATTERYCHANGE = enum()  --(已实现)  --电池电量改变
LUA_EVENT_NETCHANGE = enum()    --网络状态改变
LUA_EVENT_PKMODECHANGE = enum()  --(已实现)  pk模式改变
LUA_EVENT_AUTOMOVEBEGIN = enum()  --(已实现)  自动寻路开始
LUA_EVENT_AUTOMOVEEND = enum()  --(已实现) 	自动寻路结束
LUA_EVENT_AUTOPICKBEGIN = enum()    --自动捡物开始
LUA_EVENT_AUTOPICKEND = enum()    --自动捡物结束
LUA_EVENT_MAINBUFFUPDATE = enum()  --(已实现)  主玩家buff刷新
LUA_EVENT_BUFFUPDATE = enum()  --(已实现)   通用buff刷新
LUA_TRIGGER_BUFF_WHEN_DEAD = enum()  --(已实现)  死亡时清空buff
LUA_EVENT_TALKTONPC = enum()  --(已实现)  与NPC对话
LUA_EVENT_CHANGESCENE = enum()  --(已实现)      --切换地图(包含同地图)  --(已实现) 
---@param message MapProtos.ChangeMapRes 服务器返回消息
LUA_EVENT_MAPINFOCHANGE = enum()  --(已实现)     --	切换地图(不同地图)  --(已实现) 
LUA_EVENT_MAPINFOINIT = enum()  --(已实现)    --地图初始化
LUA_EVENT_MAP_STATE_CHANGE = enum()  --(已实现)    --地图状态改变
LUA_EVENT_MAP_SIEGEAREA_CHANGE = enum()   --地图攻城区域状态改变
---@param panelName string 界面名字
LUA_EVENT_CLOSEWIN = enum()  --(已实现)   -- 界面关闭
LUA_EVENT_DEVICE_ROTATION_CHANGED = enum()  --(已实现)   --设备方向改变
LUA_EVENT_MONEYCHANGE = enum()  --(已实现)    --货币变化
LUA_EVENT_GUILD_MAIN_INFO = enum()  --行会信息刷新
LUA_EVENT_GUILD_CREATE = enum()  --	行会创建消耗
LUA_EVENT_GUILD_WORLDLIST = enum()  --	世界行会列表刷新
LUA_EVENT_GUILD_APPLYLIST = enum()  --入会申请列表刷新
LUA_EVENT_GUILDE_ALLY_APPLY_UPDATE = enum()   --	结盟申请列表刷新
LUA_EVENT_TRADE_MONEY_CHANGE = enum()  --对方交易货币改变
LUA_EVENT_TRADE_MY_MONEY_CHANGE = enum()  --	自己交易货币改变
LUA_EVENT_TRADE_STATUS_CHANGE = enum()   --	对方交易状态改变
LUA_EVENT_TRADE_MY_STATUS_CHANGE = enum()  --	自己交易状态改变
LUA_EVENT_ADDFIREND = enum()  --(已实现)  添加好友
LUA_EVENT_REMFIREND = enum()   --删除好友
LUA_EVENT_JOIN_TEAM = enum()  --	加入队伍
LUA_EVENT_LEAVE_TEAM = enum()  -- 离开队伍
LUA_EVENT_TEAM_INFO_CHANGE = enum()  -- 队伍变化
LUA_EVENT_TEAM_PLAYER_HP_CHANGE = enum()  -- 队伍玩家血量变化


LUA_EVENT_TARGET_CAHNGE = enum()  --(已实现)   --目标改变
LUA_EVENT_ACTOR_OWNER_CHANGE = enum()  --目标归属改变


LUA_EVENT_PLAYER_BEHAVIOR_STATE_CAHNGE = enum()  --(已实现)   --玩家行为状态改变（站立、走、跑等）
LUA_EVENT_PLAYER_ACTION_BEGIN = enum()  --(已实现)  --主玩家行为动作开始（站立、走、跑等）
LUA_EVENT_PLAYER_ACTION_COMPLETE = enum()  --(已实现)  --主玩家行为动作结束（站立、走、跑等）
LUA_EVENT_NET_PLAYER_ACTION_BEGIN = enum()  --(已实现)  --网络玩家行为动作开始（站立、走、跑等）
LUA_EVENT_NET_PLAYER_ACTION_COMPLETE = enum()  --(已实现)  --网络玩家行为动作结束（站立、走、跑等）
LUA_EVENT_MONSTER_ACTION_BEGIN = enum()  --(已实现)   --怪物行为动作开始（站立、走、跑等）
LUA_EVENT_MONSTER_ACTION_COMPLETE = enum()  --(已实现)   --怪物行为动作结束（站立、走、跑等）

LUA_EVENT_SKILL_INIT = enum()  --(已实现)  --初始化技能
LUA_EVENT_SKILL_ADD = enum()  --(已实现)  --新增技能
LUA_EVENT_SKILL_DEL = enum()  --(已实现)  --	删除技能
LUA_EVENT_SKILL_UPDATE = enum()  --(已实现)  --	技能更新
LUA_TRIGGER_SKILL_GET_TARGETIDS = enum()
LUA_TRIGGER_SKILL_CUSTOM_PLAYER_ANI_PLAY_TIME = enum()
LUA_TRIGGER_SKILL_CUSTOM_PLAYER_ANI_CROSS_FADE_TIME = enum()
---技能释放触发器
---@param skill Skill 当前技能对象
---@param skillId number 技能 cfg_skill的ID
---@param targetId number 目标 ID
---@param targetCoord Dot2 目标坐标
---@param targetIds table 多目标 ID 列表
---@param isFightResult boolean 是否播放目标特效
---@return boolean 为true时，释放技能时停止上次正在播放的技能
LUA_TRIGGER_SKILL_RELEASE = enum() --技能释放触发,isStopCurSkill为true时，释放技能时停止当前技能

LUA_EVENT_PLAYER_MAPPOS_CHANGE = enum()  --(已实现)  --主玩家位置改变

---@param id number 玩家id
LUA_EVENT_MAIN_PLAYER_REVIVE = enum()  --(已实现)  --主玩家复活
---@param id number 玩家id
LUA_EVENT_NET_PLAYER_REVIVE = enum()  --(已实现)  --网络玩家复活
---@param id number 怪物id
LUA_EVENT_MONSTER_REVIVE = enum()  --(已实现)  --怪物复活
---@param id number 玩家id
LUA_EVENT_MAIN_PLAYER_DIE = enum()  --(已实现)  --主玩家死亡
---@param id number 玩家id
LUA_EVENT_NET_PLAYER_DIE = enum()  --(已实现)  --网络玩家死亡
---@param id number 怪物id
LUA_EVENT_MONSTER_DIE = enum()  --(已实现)  --怪物死亡


LUA_EVENT_CAREER_CHANGED = enum()  --(已实现)  --职业改变事件
LUA_EVENT_DEPLOY_ATTR = enum()  --(已实现)  --分配点数完成
LUA_EVENT_RESET_POINT = enum()  --(已实现)  --洗点完成
---退出游戏
LUA_EVENT_PLAYER_LOGIN = enum()  --(已实现)  --账号登录
---角色退出
LUA_EVENT_PLAYER_LOGOUT = enum()  --(已实现)  --账号登出
---角色登录
---@param rid number 角色id
LUA_EVENT_ROLE_LOGIN = enum()  --(已实现)  --角色登录
LUA_EVENT_ROLE_LOGOUT = enum()  --(已实现)  --角色登出
---创建角色
---@param role UserProtos.RoleInfo
LUA_EVENT_CREATEROLE = enum()  --(已实现)  --创建角色
---删除角色
---@param role UserProtos.RoleInfo[]
LUA_EVENT_DELETEROLE = enum()  --(已实现)  --删除角色
LUA_EVENT_OPENMAINSYSTEMFUNCTION = enum()  --(已实现)  --打开主界面系统功能
LUA_EVENT_AGSTOCHANGE = enum()  --(已实现)  --技能值改变
LUA_EVENT_SHIELDCHANGE = enum()  --(已实现)  --护盾值改变
--- 血量改变
---@param hpData HpData 血量数据
LUA_EVENT_HPCHANGE = enum()  --(已实现) --血量改变
---蓝量改变
---@param mpData MpData 蓝量数据
LUA_EVENT_MPCHANGE = enum()  --(已实现) --蓝量改变
LUA_EVENT_ROLE_HP_CHANGE = enum()  --(已实现) --怪物或者角色血量改变
LUA_EVENT_SELECT_ROLE = enum()  --(已实现) --选择角色-手动点击或者攻击的时候选中玩家或者怪物
LUA_EVENT_HIDE_BOSS_HP = enum()  --(已实现) --隐藏boss血条
LUA_EVENT_CANCEL_HIDE_BOSS_HP = enum()  --(已实现) --取消隐藏boss血条
LUA_EVENT_HIDE_RIGHT_BTN_VIEW = enum()  --(已实现) --隐藏右侧按钮窗口
LUA_EVENT_BUFFCHANHE = enum()  --(已实现)  --buff改变
LUA_EVENT_FREEBUFFCHANHE = enum()  --(已实现)  --免费buff改变
LUA_EVENT_ME_CREATE_SUCCESS = enum()  --(已实现)  --主角创建成功
LUA_EVENT_EXPAND_RIGHTSYSTEMFUNCTION = enum()  --(已实现)  --展开主界面左边系统功能
---@param skillItem KLUISkillItem 技能的KLUISkillItem脚本 table
LUA_EVENT_SELECT_SKILL_UI = enum()  --(已实现)  --选择技能
---登录进入地图
---@param cfgId number 地图id
LUA_EVENT_LOGIN_MAP = enum()  --(已实现)  --登录进入地图
----------回收----------
LUA_EVENT_Item_Recover = enum()--道具回收成功
---------分解----------
LUA_EVENT_Item_Resolve = enum()--道具分解成功
LUA_EVENT_PANEL_Add_SUCCESS = enum()  --(已实现)  --界面添加成功
LUA_EVENT_PANEL_LOAD_SUCCESS = enum()  --(已实现)  --界面加载成功,异步加载有延迟
LUA_EVENT_INNER_PANEL_LOAD_SUCCESS = enum() --内部UIManager 的UI加载完成
---进入游戏地图
---@param isChangeMap boolean 是否切换地图触发
LUA_EVENT_ENTER_MAP = enum()  --(已实现)  --进入游戏地图
LUA_EVENT_JOYSTICK_MOVE = enum()  --(已实现)  -- 摇杆控制人物移动
---功能预告功能开始
---@param id number cfg_preview表的id
LUA_EVENT_PREVIEW_OPEN = enum()  --(已实现)  --功能预告功能开始
LUA_EVENT_PREVIEW_OVER = enum()  --(已实现)  --功能预告功能结束
LUA_EVENT_HURT_BEGIN = enum()  --(已实现)  --开始飘字
LUA_EVENT_HURT_END = enum()  --(已实现)  --结束飘字
LUA_EVENT_NPC_ARRIVE_NEAR = enum() --(已实现)到达NPC附近
LUA_EVENT_NPC_LEAVE_NEAR = enum() -- (已实现)离开NPC附近
---背包锁定格子解锁
---@param count number 未解锁数量
LUA_EVENT_BAG_UNLOCK = enum()  --(已实现)  --背包锁定格子解锁
LUA_EVENT_STORAGE_UNLOCK = enum()  --(已实现)  -- 仓库锁定格子解锁
--- 背包道具整理完成
---@param itemList BagProtos.BagItem[] 整理后道具数据
LUA_EVENT_BAG_SORT = enum()  --(已实现)  -- 背包道具整理完成
LUA_EVENT_BAG_CHANGE_BEFORE = enum()  --(已实现)  -- 背包变化之前
LUA_EVENT_BAG_CHANGE_AFTER = enum()  --(已实现)  -- 背包变化之后
LUA_EVENT_USE_ITEM_AFTER = enum()  --(已实现)  -- 使用物品之后
LUA_EVENT_INIT_SHORT_CUT = enum()  --(已实现)  -- 初始化快捷栏
LUA_EVENT_RESET_ATTACK_ROLE = enum()  --(已实现)  -- 重置攻击目标
LUA_EVENT_COMBOSKILL_PROGRESS = enum() --连击技能蓄能条进度
LUA_EVENT_PKMODE_CHANGE = enum()  --(已实现)  --战斗模式改变
LUA_EVENT_SWITCH_PKMODE = enum()  --(已实现)  --切换战斗模式
LUA_EVENT_NPC_CREATE = enum() --（已实现） -- NPC被创建的时候
LUA_EVENT_PLAYER_CREATE = enum() --（已实现） -- 玩家被创建的时候
-----召唤兽
---召唤物 状态改变
LUA_EVENT_SUMMON_MODE_CHANGE = enum()  --(已实现) 
---召唤物 存活状态改变
LUA_EVENT_SUMMON_ALIVE_CHANGE = enum()  --(已实现) 
---玩家穿戴装备
---@param putOn EquipProto.EquipIndex 穿上的装备
LUA_EVENT_TAKE_ON_EQUIP = enum()  --(已实现)  --玩家穿戴装备
---玩家脱掉装备
---@param takeOff EquipProto.EquipIndex 脱下的装备
LUA_EVENT_TAKE_OFF_EQUIP = enum()  --(已实现)    --玩家脱掉装备
---角色装备数据操作
---@param patchData EquipChangeData 装备数据
LUA_EVENT_PLAYER_EQUIP_CHANGE = enum()  --(已实现)  --角色装备数据操作
---@param pos number 点击的穿戴部位
---@param wearBarType EEquipWearBarType 穿戴栏类型
LUA_EVENT_EQUIP_GRID_CLICK = enum() --(已实现) 穿戴蓝部位点击事件
LUA_TRIGGER_EQUIP_GET_PUT_SLOT = enum()
LUA_EVENT_TASK_FINISH = enum()  --(已实现)  -- 任务完成，状态是完成的，等待提交
LUA_EVENT_TASK_NEW = enum()  --(已实现)  -- 任务领取
LUA_EVENT_TASK_SUBMIT = enum()  --(已实现)  -- 任务提交后，任务结束了，这个时候任务已经完成了，信息已经被删除了，
LUA_EVENT_TASK_CHANGE = enum()  --(已实现)  -- 任务改变

---主界面气泡提示
LUA_EVENT_BUBBLETIPS_POSY = enum()  --(已实现)气泡y移动自适应
LUA_EVENT_BUBBLETIPS_ADD = enum()  --(已实现)气泡添加
LUA_EVENT_BUBBLETIPS_DEL = enum()  --(已实现)气泡删除
LUA_EVENT_ACTIVITYTIMETIPS_ADD = enum()  --(已实现)   --活动列表预告气泡添加
LUA_EVENT_ACTIVITYTIMETIPS_DEL = enum()  --(已实现)   --活动列表预告气泡删除
LUA_EVENT_ACTIVITYTIMETIPS_DELALL = enum()  --(已实现)   --活动列表预告气泡删除全部
LUA_EVENT_ACTIVITYTIMETIPS_DELTYPE = enum()  --(已实现)   --活动列表预告气泡删除同类型
---怪物仇恨
LUA_EVENT_HATE_TARGET_HP_CHANGE = enum()  --(已实现)  --仇恨目标HP改变
LUA_EVENT_TARGET_HATE = enum()  --(已实现)  --仇恨目标改变
LUA_EVENT_MONSTER_TARGET_HATE = enum()  --(已实现)  --怪物仇恨目标改变

--聊天
---@param message ChatProto.ResChat 聊天消息
LUA_EVENT_CHAT_RECEIVE = enum()       --(已实现)  --聊天消息接收
LUA_EVENT_CHAT_RECEIVE_NOTICE = enum()       --(已实现)  --系统聊天消息接收
LUA_EVENT_CHAT_LINK_POS = enum()       --(已实现)  --聊天点击位置寻路

---邮件
LUA_EVENT_RECEIVE_EMAIL = enum() --(已实现)有新的邮件,在登陆时有未读邮件会触发
LUA_EVENT_MAIL_STATE_CHANGE = enum() -- (已实现)邮件状态更新

LUA_EVENT_STORE_HOUSE_INFO_CHANGE = enum()--(仓库数据改变)

--设置
LUA_SELECT_CALL_SKILL = enum() --(已实现)选择召唤技能

LUA_EVENT_STORE_HOUSE_PAGE = enum()--(仓库页数改变)
LUA_EVENT_UI_SHOW_ME_PATH_MOVE = enum()----自动寻路中
LUA_EVENT_UI_SHOW_ME_PATH_STOP = enum()----自动寻路停止
LUA_TRIGGER_CAN_RUN = enum() --自定义是否可以跑

LUA_EVENT_FIGHTBEGINF = enum()  --(已实现)  战斗开始
LUA_EVENT_FIGHTEND = enum()  --(已实现)  战斗结束


LUA_EVENT_FASTITEM_SET_SELECT = enum() --技能设置界面快捷使用设置选中item

LUA_EVENT_EXIT_GAME = enum() -- (已实现)退出游戏

--触发器
---@param go UnityEngine.GameObject 设置流光的对象，作为EQUIP_STREAMER_REFRESH参数
---@param roleId number 角色id
---@param itemCfgId number 道具配置id
---@param strengthLevel number 强化等级
LUA_TRIGGER_SET_STREAM = enum()
LUA_TRIGGER_SET_ACTORNAMECOLOR = enum() --红名名字颜色触发器

LUA_EVENT_OPEN_SERVER_DAY_CHANGE = enum() --(已实现)开服天数改变
---挂机状态改变
---@param EAutoOnHookStatus EAutoOnHookStatus 挂机状态
---@param OnHooking boolean 上一次的挂机状态可为nil
---@param isOnHook boolean 配合OnHooking 判断是否请求开始/停止挂机可为nil
---@param isReq boolean 是否发送客户端触发开始挂机可为nil
LUA_EVENT_ONHOOK_STATE_CHANGE = enum() --(已实现)挂机状态改变

LUA_EVENT_OPEN_UI = enum() --打开UI面板

--好友
LUA_EVENT_FRIEND_LIST_CHANGE = enum() --好友数据变化
---@param dir EDirection 方向
LUA_EVENT_PLAYER_TURN_DIR = enum() --主角朝向
--地图
LUA_EVENT_BIG_MAP_OPEN = enum() --大地图打开
LUA_EVENT_BIG_MAP_CLOSE = enum()--大地图关闭
LUA_EVENT_MIN_MAP_OPEN = enum() --小地图打开
LUA_EVENT_MIN_MAP_CLOSE = enum()--小地图关闭

--守护
LUA_EVENT_GUARDPET_OFF = enum() --守护脱下
LUA_EVENT_GUARDPET_PUT = enum() --守护穿戴
LUA_EVENT_GUARDPET_CREATE = enum() --守护被创建
--红名
LUA_EVENT_PKVALUECHANGE = enum()  --PK值改变

LUA_EVENT_REFRESH_ATTACK_SKILL = enum() --刷新技能攻击操作界面

LUA_EVENT_MAIN_UI_VISIBLE = enum() --主界面显示/隐藏事件

LUA_EVENT_TO_UNITY = enum() --壳工程发送数据到Unity

LUA_EVENT_TO_UNITY_TRADE = enum() --壳工程发送数据到Unity（交易行）

LUA_EVENT_ENTRY_MAP_LOADING_PANEL_CLOSE = enum() --进入地图加载界面关闭

LUA_EVENT_MOUNT_ISON = enum() --场景中坐骑骑乘事件

LUA_EVENT_PLAYER_ENTER_MAP = enum() -- ResPlayerEnterMapMessage

MESSAGE_ACCEPT = enum() --文字提示消息

LUA_EVENT_FIGHT_RESULT = enum() --战斗结果包

LUA_EVENT_OWNER_CHANGE = enum() --归属改变事件

LUA_EVENT_ROLE_TRANSFER = enum() --传送事件

LUA_EVENT_ENTER_UNION = enum() --进入战盟

LUA_EVENT_UNION_ALL_INFO = enum() --战盟所有信息

LUA_EVENT_APPLY_JOIN_UNION = enum() --同意加入战盟

LUA_EVENT_UNION_DETAIL = enum() -- 单个战盟信息

LUA_EVENT_VIEW_UNION = enum() -- 战盟信息响应

LUA_EVENT_VIEW_UNION_CHANGE = enum() -- 详细信息实时变更

LUA_EVENT_UNION_MEMBER_DYNAMIC = enum() --战盟成员动态信息

LUA_EVENT_UNION_NAME_VIEW = enum() --改名视图

LUA_EVENT_QUIT_UNION = enum() --退出战盟

LUA_EVENT_UNION_MEMBER_CHANGE = enum() --成员实时变更

LUA_EVENT_CREATE_PLAYER_SUCCESS = enum() --创建玩家成功事件

LUA_EVENT_ME_RELIVE = enum() --主角复活事件

LUA_EVENT_ROLE_INFO = enum() --角色信息

LOADING_PANEL_HIDE = enum()

LUA_EVENT_MAP_MONSTER_STATUS = enum() --地图中所有怪物状态
LUA_EVENT_MAP_MONSTER_STATUS_CHANGE = enum() --单个怪物状态通知

LUA_EVENT_DROPITEM_OUT_OF_VIEW = enum() --掉落道具移除事件
LUA_TRIGGER_DROPITEM_IS_CUSTOM_PLAYAUDIO = enum()--掉落自定义播放音效

LUA_EVENT_FIGHT_ATT_CHANGE = enum() --有属性变化
LUA_EVENT_UNION_APPLICATION_LIST = enum() --申请列表

LUA_EVENT_ACTOR_IN_OF_VIEW = enum()
LUA_EVENT_ACTOR_Update_OF_VIEW = enum() --视野更新
LUA_EVENT_PET_SKILL_CD_CHANGE = enum() --宠物技能cd改变事件

LUA_EVENT_DROPITEM_IN_OF_VIEW = enum() --道具进入视野

LUA_EVENT_ROLE_SETTING_PK_MODE_CHANGE = enum() --角色设置-战斗模式改变事件

LUA_TRIGGER_CLICK_ROLE = enum() --点击角色触发器

LUA_EVENT_Req_SelectSkill_Change = enum()--快捷技能改变

LUA_EVENT_FastUseItem = enum()--快捷使用道具

LUA_EVENT_Close_MainButtonList = enum()--主界面按钮列表关闭
LUA_EVENT_Open_MainButtonList = enum()--主界面按钮列表打开
LUA_EVENT_PICK_UP_SETTING_CHANGE = enum() -- 拾取设置改变事件


LUA_EVENT_LOADING_PANEL_HIDE = enum() --  loading panel 关闭
LUA_EVENT_LEFT_OPEN_MESSAGE = enum() --  LeftOpenMessage
LUA_EVENT_MUBOX_INFO = enum() --  ResMuBoxInfoMessage

LUA_EVENT_SCENE_DATA_LOAD_FINISHED = enum() --场景数据加载完成

LUA_TRIGGER_CHECK_PKMODE_RELATION = enum() --判断当前模式玩家之间的关系

LUA_TRIGGER_CHECK_PKMODE_IS_ATTACK = enum() --判断当前模式玩家是否能被攻击

LUA_EVENT_MOUNTID_CHANGE = enum() --角色坐骑id改变事件

LUA_EVENT_ROLE_ACTION_CHANGE = enum() -- 角色行为改变事件

LUA_EVENT_ROLE_SETTING_INFO = enum() -- 角色设置信息事件
LUA_EVENT_CLICK_MOVE = enum() -- 点击移动事件
---@param skillId number 技能id
LUA_EVENT_ME_RELEASE_SKILL = enum() --主角释放技能事件
LUA_TRIGGER_ME_RELEASE_SKILL_Custom_REQ_FIGHT_PARAMS = enum()--自定义技能播放数据

LUA_EVENT_TRADE_HP_IS_SHOW = enum() --判断当前玩家是否能显示血条
LUA_EVENT_ROLE_PRE_RECYCLE = enum() --角色将要回收事件
LUA_EVENT_ROLE_RECYCLE = enum() --移除场景中的玩家事件

LUA_TRIGGER_RELEASE_HOOK_SKILL = enum() --判断释放那个挂机技能

LUA_EVENT_GAME_START = enum() --游戏启动事件

--模型加载完成
LUA_EVENT_ROLEMODEL_ONLOAD_ALL = enum() --所有模型加载完成,参数 rid
LUA_EVENT_LOW_MEMORY = enum() --内存不足回调
LUA_EVENT_REMOVEMAPOBJECT = enum() -- 场景角色移除事件
LUA_EVENT_ROLEMODEL_SINGLE_ONLOAD = enum() --单个模型加载完成回调

LUA_TRIGGER_ROLE_IS_BE_ATTACK = enum() -- 角色是否可以被攻击
LUA_TRIGGER_ME_DIE_IS_NO_HIDE_ALL_UI = enum() --主角死亡是否不关闭所有UI
LUA_EVENT_PLAYER_POS_CHANGE = enum() --玩家位置改变事件
---登入场景加载完成
LUA_EVENT_LOGINSCENE_LOADED = enum()--登入场景加载完成

--跑马灯
LUA_HORSE_RACE_LAMP = enum() --接收跑马灯消息事件
LUA_EVENT_AUTO_RECEIVE_TASK_REWARD = enum() --自动领取任务奖励
LUA_TRIGGER_AUTO_FIGHT_COMEBACK_IS_CHANGE_PKMODE = enum() --自动反击是否改变当前战斗模式
LUA_TRIGGER_ME_CUSTOM_RELEASESKILL = enum()--自定义技能释放条件
LUA_TRIGGER_FAST_RANGE_PICKUP = enum()--范围自动拾取触发器
LUA_TRIGGER_HORSE_RACE_CFG_DATA_FROM_SERVER_DATA = enum()--自定义服务器过来的id=-1或者id=-2的数据，和cfg_string里面的数据一致

--技能特效
LUA_EVENT_SKILLEFFECT_ONLOAD = enum()--技能特效加载完成事件
LUA_TRIGGER_SKILLEFFECT_ISCANRELEASE = enum()--当前技能特效是否可以播放
LUA_EVENT_SKILLEFFECT_CUSTOM_Init = enum() --自定义特效表现
LUA_EVENT_SKILLEFFECT_CUSTOM_Update = enum() --自定义特效表现
LUA_EVENT_SKILLEFFECT_CUSTOM_ModelObjectLoaded = enum() --自定义特效表现
LUA_EVENT_SKILLEFFECT_CUSTOM_Stop = enum() --自定义特效表现
LUA_TRIGGER_SKILLEFFECT_NOT_PLAY_OTHER_TARGET_MOVE = enum() --是否播放非主目标的特效
LUA_TRIGGER_SKILLEFFECT_NOT_PLAY_OTHER_TARGET_END = enum() --是否播放非主目标的特效
--常规技能
LUA_TRIGGER_SKILLRESULT_CAN_RELEASESKILL = enum() -- 战斗回包是否可以进行特效表现

---掉落
LUA_EVENT_CREATE_DROPITEM = enum() -- 创建掉落物品事件
LUA_TRIGGER_DROPITEM_NAME_LOCALPOSITION_Z = enum()--掉落道具修改z轴，用来控制渲染层级，需要配合
---角色头顶
LUA_TRIGGER_ROLE_HEAD_UNION_NAME_CHANGE = enum() -- 角色头顶战盟名触发事件

LUA_EVENT_CLEAR_ALL_LUA_CONFIG = enum() --清理所有lua配置回调，再回调里面重新对一些初始化获取表格数据的逻辑重新获取

LUA_TRIGGER_CHECK_AUTO_FIGHT_ROLE_IS_BE_ATTACK = enum() -- 检测自动战斗目标是否能被攻击

LUA_TRIGGER_TRAD_GOODS_MESSAGE = enum() -- 交易行物品触发器

LUA_TRIGGER_SKILL_RELEASE_RANGE = enum() -- 技能释放范围触发器

LUA_TRIGGER_HAND_ATTACK_SELECT_TARGET = enum() --手动攻击选择目标触发器

LUA_EVENT_START_MESSAGE_TIP = enum() --跑马灯开始事件

LUA_TRIGGER_NPC_HEAD_NAME_COLOR_CHANGE = enum() --npc名字颜色改变触发器

LUA_EVENT_PLAYER_UNION_NAME_CHANGE = enum() --玩家战盟名改变事件

LUA_EVENT_PLAYER_NAME_CHANGE = enum() --玩家角色名改变事件

LUA_EVENT_MONSTER_NAME_CHANGE = enum() --怪物角色名改变事件

LUA_EVENT_PET_NAME_CHANGE = enum() --宠物角色名改变事件

LUA_TRIGGER_PLAYER_NAME_COLOR_CHANGE = enum() --玩家名字颜色改变触发器

LUA_TRIGGER_GAME_RECONNECT_TIP = enum() -- 游戏重连提示触发器

LUA_TRIGGER_GAME_RECONNECT_UI_SHOW = enum() --游戏重连界面显示触发器

LUA_TRIGGER_GAME_DISPLACE_USER_UI_SHOW = enum() --游戏异地登录显示触发器

LUA_TRIGGER_ROLE_HP_SPRITE_LOAD = enum() --角色血条图片加载触发器


LUA_TRIGGER_DROP_ITEM_NAME_CHANGE = enum() --道具掉落名字改变触发器
LUA_TRIGGER_DROP_ITEM_MODEL_ID = enum() --道具掉落模型修改
LUA_DO_CLICK_SCENE_NPC = enum() --点击场景中的npc

LUA_EVENT_GET_URL_CALLBACK = enum() -- webgl获取url返回

LUA_EVENT_CONTROL_UI_ONCLICK = enum() -- 控件点击事件

LUA_TRIGGER_HOOk_IS_AUTO_PICKUP = enum() --挂机是否自动拾取该物品触发器
LUA_TRIGGER_HOOk_IS_CAN_AUTO_ONEKEY_PICKUP = enum() --一键拾取是否生效

LUA_EVENT_PCPLATFORM_INIT_FINISH = enum() --PC初始化完成
LUA_EVENT_PC_RIGHT_SINGLE_CLICK = enum() --PC右键抬起时触发
LUA_EVENT_PC_RIGHT_SINGLE_CLICK_DOWN = enum() --PC单击左键或右键按下时触发
LUA_EVENT_PC_RIGHT_HOLD = enum() --PC右键长按
LUA_EVENT_PC_STOP_LOOP_ATTACK = enum() --PC中止持续攻击
LUA_EVENT_PC_START_LOOP_ATTACK = enum() --PC中止持续攻击
LUA_EVENT_PC_CLICK_EMPTY = enum() --PC点击地面

LUA_TRIGGER_HURT_SHOW = enum() --伤害飘字显示触发器
LUA_EVENT_PLAYER_PKMODE_CHANGE = enum() -- 玩家攻击模式改变事件
LUA_EVENT_FINISH_CHAT_NPC_TASK = enum() -- 完成对话npc任务

LUA_TRIGGER_HAND_ATTACK_SELECT_TARGET = enum() --手动攻击选择目标触发器

LUA_EVENT_TRADE_RENDER_MAP = enum() --渲染地图触发器

LUA_EVENT_MODIFY_SKILLEFFECT_BINDWEAPON_DATA = enum() -- 修改霹雳回旋斩特效数据
LUA_TRIGGER_DROPITEM_NAME_LOCALPOSITION_Z = enum()--掉落道具修改z轴，用来控制渲染层级，需要配合
LUA_EVENT_TRADE_CLICK_ROLE_IS_AUTO_FIGHT = enum() --点击角色是否开启自动战斗触发器
LUA_EVENT_DROP_ITEM_MODEL_CREATE_SUCCESS = enum() --掉落道具模型创建完成事件
LUA_TRIGGER_CREATE_DROP_ITEM = enum() --创建掉落道具触发器
LUA_EVENT_ROLE_DIE_HPANIMATION_END = enum() --角色死亡血条动画播放完毕事件
LUA_EVENT_FASTRANGE_PICKUP_MESSAGE = enum() --自动范围拾取回包事件
LUA_TRIGGER_MOVE_PICK_UP_ITEM = enum() --移动拾取物品事件
LUA_EVENT_TITLE_POSITION_CHANGE = enum() --称号位置改变事件
LUA_EVENT_APPLICATION_FOCUS = enum() --焦点丢失

LUA_EVENT_TRADING996_IS_SHOW_CHANGED = enum() --996交易行入口状态变化（是否显示）

LUA_TRIGGER_CHANGE_CHAT_RECRUIT_TEXT = enum() --外置自定义招募文本
LUA_TRIGGER_MODIFY_AUTO_FIGHT_ATTACK_RANGE = enum() -- 修改自动战斗攻击范围触发器
LUA_TRIGGER_MODIFY_SKILL_EFFECT_PLAY_TIME = enum() --修改技能特效播放时间触发器
LUA_TRIGGER_ME_OPEN_WALK_TO_RUN = enum() --是否解锁走路到跑步的功能
LUA_EVENT_DROP_ITEM_REMOVE = enum() -- 掉落道具移除事件
LUA_TRIGGER_IS_ADD_HOOKSKILL = enum() -- 是否把技能加入自动战斗列表

LUA_EVENT_WILL_CLOSE_LOADING_PANEL =enum() --将要关闭loading界面(延迟x秒，用于关闭前将进度条提升至100%)
LUA_TRIGGER_CLICK_GROUND_MOVE_ARRIVE_CALLBACK = enum() --点击地面移动到达回调触发器
LUA_TRIGGER_PAUSE_HOOK = enum() --暂停挂机触发器
LUA_TRIGGER_ROLE_MOVE_IS_CHECK_SKILL_ANIMATION_PLAYING = enum() --角色移动是否检测技能动画是否在释放中
LUA_EVENT_CREATE_UNION = enum() --创建战盟消息回包事件
LUA_TRIGGER_MOUNT_ID_CHANGE = enum() -- 坐骑id改变触发器
LUA_EVENT_UNION_SETTING = enum() -- 战盟设置消息回包事件
LUA_EVENT_ROLE_PLAY_ANIMATION = enum() --角色动画播放事件
LUA_TRIGGER_CREATE_MONSTER_TOMBSTONE = enum() --创建怪物墓碑触发器
LUA_TRIGGER_IS_CAN_ATUO_USE_SDPILL = enum() --是否能自动使用回复护盾药水

LUA_EVENT_ITEM_LUA_EXT_DATA_CHANGED = enum() --道具扩展数据变化通知（包括身上穿戴和背包中的）
LUA_TRIGGER_CHAT_MESSAGE_PERSONAL = enum() --聊天消息触发器
LUA_EVENT_SKILL_CD_CHANGE = enum() --主角技能cd改变事件
LUA_EVENT_HOOK_SKILL_CHANGE = enum() --挂机技能改变事件

LUA_TRIGGER_DELAY_CLOSE_LOAINDGUI = enum() -- 延迟关闭loading界面触发器,登陆界面到选角界面
LUA_TRIGGER_GUARD_PICKUP_ITEM = enum() --守护拾取道具触发器


LUA_EVENT_DISCONNECT = enum() --Tcp断开连接
LUA_EVENT_RECONNECT = enum() --Tcp重连

LUA_TRIGGER_SET_AUTO_COUNTERATTACK_IS_RESET_SELECT = enum() --设置自动反击是否重置选中的目标
