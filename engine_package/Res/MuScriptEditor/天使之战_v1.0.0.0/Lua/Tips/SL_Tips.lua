---@class SL
SL = {}
local this = SL
this.autoStopScheduleCache = {}
this.LoginManager = {}
this.NpcShop = {}
this.Mail = {}
this.RoleAtt = {}
this.Friend = {}
this.Bag = {}
this.StoreHouse = {}
this.Scene = {}
this.SceneEffect = {}
this.Time = {}
this.Equip = {}
this.MainCamera = {}
this.Constructor_In = {}
this.Union = {}
this.SceneEditorManager = {}
this.PCSkillInfoMgr = {}
this.Skill = {}
this.Role = {}
this.NetManager_Req = {}
this.SDKMgr = {}
this.Main = {}
this.NetManager = {}
this.UIManager = {}
this.UIStaticParameter = {}
this.Http = {}
this.GamePlay = {}
this.LoginInfo = {}
this.SceneManager = {}
this.Queue = {}
this.BtTree = {}
this.LauncherUI = {}
this.MapMaskMgr = {}
this.LeanTween = {}
this.CSPreScene = {}
this.SL2D = {}
this.DropItem = {}
this.UniWebViewMgr = {}
this.CreateRoleScene = {}
this.Head = {}
this.Map = {}
this.GM = {}
this.AutoFight = {}
this.PCOperation = {}
this.replaceEngineFunc = {}
this.modifyPrefabSprite = {}
this.message = {}
this.SettingData = {}
this.Transform = {}
this.equipVarGetFunc = {}

---发送 Lua 网络消息
---@param msgId number 消息 ID
---@param data any 消息数据，会自动进行 json 编码
function SL:SendLuaNetMsg(msgId, data) end

---发送通用内置服务器消息请求
---@param method MessageDef 枚举
---@param data any 数据类型查看MessageDef枚举值的注释
function SL:SendInnerNetReq(method, data) end

---注册 Lua 网络消息监听
---@param msgId number 消息 ID
---@param func function 回调函数
---@param baseUI UIKmlLuaPanelBase 所属界面对象 (可选)
function SL:RegisterLuaNetMsg(msgId, func, baseUI) end

---取消注册 Lua 网络消息监听
---@param eventId number 消息 ID
---@param func function 回调函数
---@param selfOwner any 所属对象
function SL:UnRegisterLuaNetMsg(eventId, func, selfOwner) end

---延迟批量处理网络消息
---@param msgId number 消息 ID
---@param msgData any 消息数据，会缓存到批量列表中
---@param delayTime number|nil 延迟时间，nil 或 <= 0 时立即调用。
---@param handleFunc function 批量处理回调，格式为 handleFunc(owner, msgList, msgId)
---@param owner any 回调所属对象，必须传
function SL:DelayHandleNetMsg(msgId, msgData, delayTime, handleFunc, owner) end

---清理延迟批量处理网络消息缓存
---@param msgId number|nil 消息 ID
---@param owner any|nil 回调所属对象
function SL:ClearDelayHandleNetMsg(msgId, owner) end

---注册 Lua 事件监听
---@param eventId any 事件 ID
---@param func function 回调函数
---@param baseUI UIKmlLuaPanelBase 所属界面对象 (可选)
function SL:RegisterLUAEvent(eventId, func, baseUI) end

---取消注册 Lua 事件监听
---@param eventId any 事件 ID
---@param func function 回调函数
---@param selfOwner any 所属对象
function SL:UnRegisterLUAEvent(eventId, func, selfOwner) end

---延迟批量处理 Lua 事件
---@param eventId any 事件 ID
---@param delayTime number|nil 延迟时间，nil 或 <= 0 时立即调用
---@param handleFunc function 批量处理回调，格式为 handleFunc(owner, eventDataList, eventId)
---@param owner any 回调所属对象，必须传
---@param ... any 单次事件的可变参数，会按触发次数缓存到批量列表中
function SL:DelayHandleLuaEvent(eventId, delayTime, handleFunc, owner, ...) end

---清理延迟批量处理 Lua 事件缓存
---@param eventId any|nil 事件 ID
---@param owner any|nil 回调所属对象
function SL:ClearDelayHandleLuaEvent(eventId, owner) end

---派发 Lua 事件
---@param eventID any 事件 ID
---@param ... any 传递的参数
---@return any
function this:onLUAEvent(eventID, ...) end

---注册触发器 (只能注册单个)
---@param triggerId any 触发器 ID
---@param func function 回调函数
---@param selfOwner any 所属对象
function this:RegisterTrigger(triggerId, func, selfOwner) end

---取消注册触发器
---@param triggerId any 触发器 ID
function this:UnRegisterTrigger(triggerId) end

---派发触发器事件
---@param eventID any 触发器 ID
---@param ... any 传递的参数
---@return any
function this:onTriggerEvent(eventID, ...) end

---检查是否已注册某个事件
---@param eventID any 事件 ID
---@return boolean 是否注册了指定事件
function this:HasRegisterEvent(eventID) end

---检查是否已注册某个触发器事件
---@param triggerId number 触发器ID
---@return boolean
function this:HasRegisterTriggerEvent(triggerId) end

---获取配置字段并转换为列表
---@param name string 配置表名
---@param key string 键名
---@param value any 键值
---@return table[] @多行表集合或者空表
function this:GetConfigFieldToList(name, key, value) end

---获取整个配置表
---@param name string 配置表名
---@return table
function SL:GetConfigTable(name) end

---获取单条配置数据
---@param name string 配置表名
---@param id any 配置 ID
---@param key string 键名，默认为 "id"
---@param isMul boolean 是否获取多条
---@return table
function SL:GetConfig(name, id, key, isMul) end

---检查是否存在某条配置
---@param name string 配置表名
---@param id any 配置 ID
---@param key string 键名，默认为 "id"
---@param isMul boolean 是否多选
---@return boolean
function SL:HasConfig(name, id, key, isMul) end

---获取双键配置数据
---@param name string 配置表名
---@param id1 any 第一个键值
---@param id2 any 第二个键值
---@param key1 string 第一个键名
---@param key2 string 第二个键名
---@param key2Index number 第二个键的索引 (可选)
---@return table @name所指定的表的某一行，或者nil
function SL:GetConfigTwoKeys(name, id1, id2, key1, key2, key2Index) end

---检查是否存在双键配置
---@param name string 配置表名
---@param id1 any 第一个键值
---@param id2 any 第二个键值
---@param key1 string 第一个键名
---@param key2 string 第二个键名
---@param key2Index number 第二个键的索引 (可选)
---@return boolean @是否有该配置
function SL:HasConfigTwoKeys(name, id1, id2, key1, key2, key2Index) end

---查找符合条件的配置列表
---@param name string 配置表名
---@param key string 键名
---@param value any 键值
---@return table[] 多行表集合或者空表
function SL:FindConfigs(name, key, value) end

---获取多键配置数据
---@param name string 配置表名
---@param ... any 键值列表
---@return table
function SL:GetConfigMultiKeys(name, ...) end

---将配置字符串转换为数字映射表 (格式: 1#2&2#4)
---@param s string @(参考格式:1#2&2#4)
---@return table<number, number>
function SL:CfgConvertToNumberMap(s) end

---将配置字符串转换为二维数字数组 (格式: 1#2#3|1#4 或 1#2#3|1#4&2#5)
---@param s string @(参考格式:1#2#3|1#4或者 1#2#3|1#4&2#5)
---@return number[][]
function SL:CfgConvertToNumberArray2D(s) end

---将配置字符串转换为三维数字数组 (格式: 1#2&3#4|1#4&5#6)
---@param s string @(参考格式:1#2&3#4|1#4&5#6)
---@return number[][][]
function SL:CfgConvertToNumberArray3D(s) end

---将配置字符串转换为数字数组 (格式: 1#2#3#4)
---@param s string 参考格式:1#2#3#4
---@return number[]
function SL:CfgConvertToNumberArray(s) end

---将配置字符串转换为字符串数组 (格式: test0#tes1#test2)
---@param s string @(参考格式:test0#tes1#test2)
---@return string[]
function SL:CfgConvertToStringArray(s) end

---将配置字符串转换为二维字符串数组 (格式: 1#2#3|1#4)
---@param s string @(参考格式:test#2#3|1#test2)
---@return string[][]
function SL:CfgConvertToStringArray2D(s) end

---输出错误日志
function this:LogError(...) end

---输出普通日志
function this:Log(...) end

---输出警告日志
function this:LogWarning(...) end

---格式化输出 table 内容
---@param t table 目标 table
---@param isError boolean 是否作为错误日志输出，可选，默认为 false,不受GM面板日志开关控制,否则是log,受GM面板日志开关控制
---@param recursive boolean 是否递归输出，可选，默认为 true
---@param isTryCatch boolean 是否启用异常捕获，可选，默认为 false
---@param pre string 前缀字符串,可选，默认为空字符串
function this:LogTable(t, isError, recursive, isTryCatch, pre) end

---将血量数值转换为带单位的显示 (十亿: E, 十万: W)
---@param hp number 血量数值
---@param pointBit number 保留几位小数，可选，默认为 2
---@return string
function this:HPUnit(hp, pointBit) end

---获取字符串的 UTF8 字节长度
---@param str string 字符串
---@return number
function this:GetUTF8ByteLen(str) end

---将数字转换为带千分位分隔符的字符串
---@param num number|string 数字
---@return string
function this:GetThousandSepString(num) end

---十六进制字符串转十进制
---@param hexStr string 十六进制字符串，如 "0xBA"
---@return string 十进制字符串
function this:HexToInt(hexStr) end

---计算字符串的 MD5
---@param str string 字符串
---@return string MD5 值
function this:GetStrMD5(str) end

---@param jsonStr string
---@param isFilter boolean
---@return table
---字符串转json
function SL:JsonDecode(jsonStr, isFilter) end

---将 table 编码为 JSON 字符串
---@param jsonData table 目标 table
---@param isFilter boolean 是否过滤违禁词，默认为 true
---@return string JSON 字符串
function SL:JsonEncode(jsonData, isFilter) end

---判断文件是否存在
---@param path string 文件路径
---@param isLuaFile boolean 是否为 Lua 文件，默认为 false
---@return boolean
function SL:IsFileExist(path, isLuaFile) end

---拆分字符串
---@param str string 目标字符串
---@param delimiter string 分隔符
---@return table
function SL:Split(str, delimiter) end

---将数字转换为万、亿等简化单位
---@param num number 数字
---@param places number 保留小数位数
---@return string
function SL:GetSimpleNumber(num, places) end

---将时间秒数格式化为字符串 (天时分 或 时分秒)
---@param time number 毫秒
---@return string
function SL:TimeFormatToStr(time) end

---将秒数转换为天、时、分、秒
---@param sec number 秒数
---@param isToStr boolean 是否返回字符串，默认为 false
---@param isSimple boolean 是否简化显示 (天大于 0 时仅显示天)，默认为 false
---@return string|table 如果 isToStr 为 true 返回字符串，否则返回 {d, h, m, s} table
function SL:SecondToHMS(sec, isToStr, isSimple) end

---发起 HTTP GET 请求
---@param url string 链接地址
---@param httpCB function 请求回调，参数为 (success, text)
function this:HTTPRequestGet(url, httpCB) end

---发起 HTTP POST 请求
---@param url string 链接地址
---@param httpCB function 请求回调，参数为 (success, text)
---@param suffix string POST 请求数据，如 "username=post&password=6789"
---@param head table 请求头，可选
function this:HTTPRequestPost(url, httpCB, suffix, head) end

---将正常横排显示中文文本转换为竖排显示文本
---@param str string @源文本
---@return string @竖排文本
function SL:ChineseToVertical(str) end

---将阿拉伯数字转换为中文大写数字
---@param num number @阿拉伯数字
---@return string @中文大写数字字符串
function SL:NumberToChinese(num) end

---获取数字的高16位值
---@param value number @输入数字
---@return number @数字的高16位
function SL:GetH16Bit(value) end

---获取数字的低16位值
---@param value number @输入数字
---@return number @数字的低16位
function SL:GetL16Bit(value) end

---将十六进制颜色字符串转换为 Color 对象
---@param hexStr string 十六进制颜色字符串，如 "#ff00ff"
---@return Color @Color对象
function this:ConvertColorFromHexString(hexStr) end

---深拷贝 table
---@param data any 目标数据
---@return any 拷贝后的数据
function this:CopyData(data) end

---哈希表转换为排序后的数组
---@param hashTab table 目标哈希表
---@param sortFunc fun(akey:any,aValue:any,bKey:any,bValue:any) 排序函数 (可选),缺省的话按照table的key值从小到大排序
---@return table 排序后的数组
function this:HashToSortArray(hashTab, sortFunc) end

---加载/热重载 Lua 文件
---@param file string 文件路径
---@param className string 类名 (可选，用于返回值)
---@param reload boolean 是否热重载，默认为 false,已经require过的lua如果要想重新加载，需要填true
---@return table 加载后的模块
function this:Require(file, className, reload) end

---加载并拆分文本文件内容，H5平台无效，可以用SL:LoadAssetAsync接口代替。
---@param path string 文件路径
---@param delimiter string 分隔符
---@param isLua boolean 是否是lua文件，true:path是相对Lua文件夹的路径，false:相对于Res文件夹的路径
---@param callback function 加载完成回调，参数为 (readResult)，readResult是分割后的字符串
---@return table 拆分后的结果数组
function this:LoadTxtFile(path, delimiter, isLua, callback) end

---计算两坐标间的平方距离
---@param pt1 Dot2 起始坐标
---@param pt2 Dot2 结束坐标
---@return number 距离平方
function this:GetPointDistanceSQ(pt1, pt2) end

---计算两坐标间的距离
---@param pt1 Dot2 起始坐标
---@param pt2 Dot2 结束坐标
---@return number 两点距离
function this:GetPointDistance(pt1, pt2) end

---计算二维向量长度
---@param pt Dot2|Vector2|Vector3  @向量坐标
---@return number @长度
function this:GetPointLength(pt) end

---获取二维向量长度平方
---@param pt Dot2|Vector2|Vector3  @向量坐标
---@return number @长度平方
function this:GetPointLengthSQ(pt) end

---获取两个二维点的中点坐标
---@param pt1 Dot2|Vector2|Vector3 @点1 {x, y}
---@param pt2 Dot2|Vector2|Vector3 @点2 {x, y}
---@return Dot2  @坐标点
function this:GetMidPoint(pt1, pt2) end

---两二维点坐标相加
---@param pt1 Dot2|Vector2|Vector3 点1 {x, y}
---@param pt2 Dot2|Vector2|Vector3 点2 {x, y}
---@return Dot2  @坐标点
function this:GetAddPoint(pt1, pt2) end

---两二维点标相减
---@param pt1 Dot2|Vector2|Vector3 点1 {x, y}
---@param pt2 Dot2|Vector2|Vector3 点2 {x, y}
---@return Dot2  @坐标点
function this:GetSubPoint(pt1, pt2) end

---向量归一化
---@param pt Dot2|Vector2|Vector3 向量 {x, y}
---@return Dot2  @坐标点
function this:GetNormalizePoint(pt) end

---计算两个二维向量之间的夹角 (弧度)
---@param pt1 table|Vector2|Vector3 向量1 {x, y}
---@param pt2 table|Vector2|Vector3 向量2 {x, y}
---@return number 夹角 (弧度)
function this:GetPointAngle(pt1, pt2) end

---计算两个二维向量之间的夹角 (角度)
---@param pt1 table|Vector2|Vector3 向量1 {x, y}
---@param pt2 table|Vector2|Vector3 向量2 {x, y}
---@return number 夹角 (度)
function this:GetPointRotate(pt1, pt2) end

---创建 Dot2 对象
---@param x number X 坐标
---@param z number Z 坐标
---@return table Dot2 对象
function this:GetNewDot(x, z) end

---计算向量的tan弧度值
---@param pt table|Vector2|Vector3 向量 {x, y}
---@return number 角度 (弧度)
function this:GetPointAngleSelf(pt) end

---计算向量的tan角度值
---@param pt table|Vector2|Vector3 向量 {x, y}
---@return number 角度 (度)
function this:GetPointRotateSelf(pt) end

---开启定时器
---@param selfSche any 所属对象，用于存储定时器 ID
---@param callDelay number 延迟开始时间 (秒)
---@param callPerTime number 每次间隔时间 (秒),如果需要每帧调用，填0
---@param callCount number 执行次数 (-1 为无限次)
---@param callback function 定时回调函数
---@param ... any 传递给回调的参数
---@return number 定时器 ID
function this:Schedule(selfSche, callDelay, callPerTime, callCount, callback, ...) end

---开启单次定时器
---@param time number 延迟时间 (秒)
---@param callback function 回调函数
---@param ... any 传递给回调的参数
---@return number 定时器 ID
function this:ScheduleOnce(time, callback, ...) end

---开启自动停止定时器
---@param owner any 生命周期所属对象，界面关闭时会自动停止
---@param selfSchedule table|nil 上一次调用返回的定时器句柄，首次调用传 nil
---@param callDelay number 延迟开始时间 (秒)
---@param callPerTime number 每次间隔时间 (秒),如果需要每帧调用，填0
---@param callCount number 执行次数 (-1 为无限次)
---@param callback function 定时回调函数
---@param ... any 传递给回调的参数
---@return table|nil 定时器句柄
function this:ScheduleAutoStop(owner, selfSchedule, callDelay, callPerTime, callCount, callback, ...) end

---开启自动停止单次定时器
---@param owner any 生命周期所属对象，界面关闭时会自动停止
---@param selfSchedule table|nil 上一次调用返回的定时器句柄，首次调用传 nil
---@param time number 延迟时间 (秒)
---@param callback function 回调函数
---@param ... any 传递给回调的参数
---@return table|nil 定时器句柄
function this:ScheduleOnceAutoStop(owner, selfSchedule, time, callback, ...) end

---停止自动停止定时器
---@param owner any 生命周期所属对象
---@param selfSchedule table|nil 定时器句柄，不传则停止 owner 下所有自动停止定时器
function this:UnScheduleAutoStop(owner, selfSchedule) end

---停止定时器
---@param scheduleID number 定时器 ID,SL:Schedule或者SL:ScheduleOnce的返回值
function this:UnSchedule(scheduleID) end

---开启无限循环定时器
---@param time number 间隔时间 (秒)
---@param func function 回调函数
---@param ... any 方法参数
---@return number 定时器 ID
function this:StartLoopForever(time, func, ...) end

---存储字符到本地 (持久化)
---@param key string 键名
---@param data string 数据，会自动进行 json 编码
function this:SetLocalString(key, data) end

---获取存储字符到本地的字符串
---@param key string 键名
---@param default string 默认值，如果不存在则返回此值
---@return string 解码后的数据
function this:GetLocalString(key, default) end

---创建一个角色静态模型
---@param parent UnityEngine.Transform 父节点 Transform
---@param rid number 角色 ID
---@param career CommonProtos.Career 职业
---@param level number 等级
---@param name string 名字
---@param mountId number 坐骑 ID
---@param action EAction 动作枚举
---@param behaviour EBehaviourType 行为枚举
---@param roleData UserProtos.RoleInfoExt 角色扩展数据
---@param _poX number X 坐标
---@param _poY number Y 坐标
---@param _poZ number Z 坐标
---@param _scale number 缩放比例
---@param _rotX number X 轴旋转
---@param _rotY number Y 轴旋转
---@param _rotZ number Z 轴旋转
---@param state EFSMState 状态机状态
---@param animName string 动画名称 (可选)
---@return Role 角色对象
function this:UIModel_Create(parent, rid, career, level, name, mountId, action, behaviour, roleData, _poX, _poY, _poZ, _scale, _rotX, _rotY, _rotZ, state, animName) end

---更新已存在的 UI 角色模型
---@param role Role 待更新的角色对象
---@param parent UnityEngine.Transform 父节点 Transform
---@param rid number 角色 ID
---@param career CommonProtos.Career 职业
---@param level number 等级
---@param name string 名字
---@param mountId number 坐骑 ID
---@param action EAction 动作枚举
---@param behaviour EBehaviourType 行为枚举
---@param roleData UserProtos.RoleInfoExt 角色扩展数据
---@param _poX number X 坐标
---@param _poY number Y 坐标
---@param _poZ number Z 坐标
---@param _scale number 缩放比例
---@param _rotX number X 轴旋转
---@param _rotY number Y 轴旋转
---@param _rotZ number Z 轴旋转
---@param state EFSMState 状态机状态
---@param animName string 动画名称 (可选)
function this:UIModel_Update(role, parent, rid, career, level, name, mountId, action, behaviour, roleData, _poX, _poY, _poZ, _scale, _rotX, _rotY, _rotZ, state, animName) end

---回收一个角色静态模型
---@param role Role 待回收的角色对象
function this:UIModel_Recycle(role) end

---获取当前战斗状态
---@return boolean 是否处于战斗状态
function this:GetBattleState() end

---设置战斗状态
---@param state boolean 是否开启战斗状态
function this:SetBattleState(state) end

---获取全部活动信息
---@return table 活动信息列表
function this:GetAllActivityData() end

---获取全部活动预告信息
---@return table 活动预告信息列表,返回参数详情：activityId:cfg_activity_rule 的id,time:结束时间(毫秒）
--table: {
--    10001:
--    {
--        activityId:10001
--        time:1772518500003
--    }
-- }
function this:GetAllActivityAnnounceData() end

---修改角色外观（武器、衣服、特效） (废弃了，这里修改的是内置外置数据，外观现在走外置)
---@param equipIndex number @装备索引
---@param state number @ 1展示 0隐藏
function this:Setfeature(equipIndex, equip, state) end

---播放角色升级特效
---@param id number 角色 ID
function this:PlayUpGradeEffect(id) end

---场景特效平滑移动
---@param modelObject SceneEffect|UnityEngine.Transform| UnityEngine.GameObject 场景特效对象|或者Unity对象
---@param endPos Vector3 目标位置
---@param time number 移动时间 (秒)
---@param onComplete function 完成回调
function this:EffectDoMove(modelObject, endPos, time, onComplete) end

---UI 特效平滑移动
---@param modelObject UIModel UI 特效对象,SL:AddModelEffect返回的值
---@param endPos Vector3 目标位置
---@param time number 移动时间 (秒)
---@param onComplete function 完成回调
function this:UIEffectDoMove(modelObject, endPos, time, onComplete) end

--------------套装---------------
---获取套装激活的装备数量
---@param cfgId number 套装cfg_equip_suit表的id
---@return number 激活数量
function this:GetSuitActiveCount(cfgId) end

---获取套装内装备及效果信息
---@param cfgId number 套装 ID
---@return table<number, {cfgId:number, isActive:boolean}>, table<number, {attId:number, attNum:number, isActive:boolean}[]>
function SL:GetSuitEquipInfoList(cfgId) end

---播放受击飘字
---@param text string 飘字文本
---@param hurtType EHurtType 受击类型 cfg_damage_number配置表id
---@param targetId number 目标角色唯一 ID，不填默认为主角
---@param buffId number 关联的 Buff ID (可选)
function SL:PlayHurt(text, hurtType, targetId, buffId) end

---播放自定义飘字标签
---@param targetId number @角色唯一id 不填或者0，会在主角头上跳字
---@param text string 飘字文本
---@param color Color 颜色
---@param fontSize number 字号
---@param hurtAnimName string 飘字动画名称
---@param playTime number 飘字动画播放时间
---@param finishCallBack function 完成回调，参数为 (head:RoleHead,hurtLabel:HurtLabel)
function this:PlayHurtLabel(targetId, text, color, fontSize, hurtAnimName, playTime, finishCallBack) end

---检查装备是否满足穿戴要求
---@param item CommonProtos.Item 装备数据
---@return number 1: 满足穿戴要求, 0: 不满足穿戴要求
function this:CheckEquipWear(item) end

---获取指定穿戴栏的装备数据
---@param wearBarID number 穿戴栏 ID (EEquipWearBarType),一般与cfg_wearing_bar对应
---@return table<number, CommonProtos.Item> 部位对应的装备数据
function this:GetWearBarsData(wearBarID) end

---获取职业对应的基础穿戴栏
---@param career CommonProtos.Career 职业数据
---@return number @基础穿戴栏ID
function this:GeCareerBaseWearBar(career) end

---获取所有已穿戴的装备
---@return table<number, table<number, CommonProtos.Item>> table<穿戴栏id, table<部位, 装备数据>>
function this:GetTotalWearEquips() end

---根据唯一 ID 获取已穿戴的装备
---@param id number @装备唯一 ID
---@return CommonProtos.Item @装备数据
function this:GetWearEquipByItemId(id) end

---穿上装备
---@param equip CommonProtos.Item 装备数据
---@param wearBarId number 指定穿戴栏 ID (可选，第几套套装 对应 cfg_item表 wearBarID字段，不填默认读wearBarID[1])
function this:PutOnEquip(equip, wearBarId) end

---脱下装备
---@param wearBarId number 穿戴栏 ID
---@param pos number 装备位 (EEquipSlotType)
function this:TakeOffEquip(wearBarId, pos) end

---获取背包中指定配置 ID 的物品总数
---@param cfgId number 物品配置ID
---@return number @总数量
function this:GetBagItemCount(cfgId) end

---获取指定货币的总数
---@param cfgId number @货币物品配置 ID
---@return number @货币数量
function this:GetTotalCoinBaseId(cfgId) end

---根据唯一 ID 获取背包物品信息
---@param itemId number 物品唯一 ID
---@return CommonProtos.Item @物品数据
function this:GetItemInfoByItemId(itemId) end

---获取cfgId在背包中的道具索引
---@param cfgId number 道具配置表id
---@field specify number @有多个道具索引，是否指定获取 0或者nil:随机  1:指定最小位置的，2:指定最大位置的
---@return number 道具索引
function this:GetSlotBaseOnCfgId(cfgId, specify) end

---获取仓库中指定配置 ID 的物品总数
---@param cfgId number 物品配置 ID
---@return number 总数量
function this:GetStorageItemCount(cfgId) end

---获取背包格子的深拷贝映射表 (用于模拟计算)
---@return table<number, number> ---已经使用的格子id   
function this:GetCopyDeepUseCellDict() end

---获取背包未使用的格子列表
---@return table<number, number>
function this:GetBagNotUseCellDict() end

---回收背包未使用格子列表
---@param notuseCellDict table
function this:RecycleBagNotUseCellDict(notuseCellDict) end

---判断道具是否可以放入背包
---@param cfgId number 物品配置 ID
---@param count number 数量
---@param useCellDict table 已使用格子映射 (当前道具占用背包格子的数据，不填默认是主角自己的背包)
---@param notuseCellDict table 未使用格子映射 (SL:GetBagNotUseCellDict()获得，注意用完之后需要用SL:RecycleBagNotUseCellDict(notuseCellDict)回收一下)
---@return boolean 是否可以放入背包
function this:CanPutToBag(cfgId, count, useCellDict, notuseCellDict) end

---获取第一个仓库格子的深拷贝映射表 (用于模拟计算), 已经使用的格子id
---@return table<number, number> @格子id 
function this:GetCopyDeepUseCellDict1() end

---判断仓库物品是否可以放入背包
---@param cfgId number 物品配置 ID
---@param count number 数量
---@param useCellDict table 已使用格子映射 (第几页， 不填默认第一页)
---@return boolean 是否可以放入
function this:CanPutToBag1(cfgId, count, useCellDict) end

---请求丢弃物品 (背包)
---@param index number 背包索引
---@return boolean 是否请求成功
function this:ReqGiveUpItemMessage(index) end

---请求将物品从背包移动到仓库
---@param BagIndex number 背包索引
---@param storeIndex number 仓库索引
function this:ReqBagToStoreMessage(BagIndex, storeIndex) end

---请求销毁物品 (背包)
---@param index number 背包索引
---@return boolean 是否请求成功
function this:ReqDestroyItemMessage(index) end

---请求背包扩容
---@param useItem number 是否优先使用扩容道具 (1: 是, 0: 否)
function this:ReqBagAddCapacityMessage(useItem) end

--------------道具基础---------------
---场景内创建掉落物品
---@param itemData MapProtos.RoundItem 掉落物数据
---@param isPlayEffect boolean 是否播放掉落特效
function this:CreateItem(itemData, isPlayEffect) end

---回收场景掉落物品
---@param id number 掉落物唯一 ID
function this:RecycleItem(id) end

---请求丢弃物品 (仓库)
---@param index number 仓库索引
---@return boolean 是否请求成功
function this:ReqStoreGiveUpItemMessage(index) end

---请求使用物品 (底层协议)
---@param index number 背包索引
---@param count number 数量
---@param notice boolean 是否广播
---@return boolean 是否请求成功
function this:ReqUseItemMessage(index, count, notice) end

---使用物品 (业务层封装)
---@param cfgId number 物品配置 ID
---@param id number 物品唯一 ID
---@param count number 数量，默认为 1
---@param notice boolean 是否广播
function this:UseItem(cfgId, id, count, notice) end

---请求使用自选宝箱
---@param boxIndex number 宝箱在背包中的索引
---@param info BagProtos.SelfChoiceBoxInfo[] 选择的道具列表
function this:ReqUseSelfChoiceBoxMessage(boxIndex, info) end

--------------音效---------------
---播放音效
---@param groupID number 音效组 ID
---@param name string 音效资源名称
---@param loop boolean 是否循环
---@param volume number 音量 (0-1)
---@param target UnityEngine.GameObject 挂载对象
---@param fadeIn number 淡入时间
---@param delay number 延迟播放时间
---@param speed number 播放速度
---@return table 音效对象
function this:PlaySound(groupID, name, loop, volume, target, fadeIn, delay, speed) end

---根据配置表 ID 和字段类型播放音效
---@param cfgType EAudioPlayByCfgType 资源表类型
---@param id number 对应的配置 ID
---@param soundType ESoundFieldType 资源表中的音效字段
---@return table 音效对象
function this:PlaySoundByTypeAndId(cfgType, id, soundType) end

---停止所有音效播放
function this:StopAllAudio() end

---停止指定音效
---@param audio table 音效对象,SL:PlayActionAudio SL:PlaySkillSound SL:PlaySound SL:PlayBGM会返回的对象
function this:StopSound(audio) end

---播放动作关联音效
---@param audioActionId number cfg_audio 表 ID
---@return table 音效对象
function this:PlayActionAudio(audioActionId) end

---播放技能关联音效
---@param audioSkillId number cfg_audio 表 ID
---@param delay number 延迟播放时间 (秒),默认是0
---@return table @音效对象
function this:PlaySkillSound(audioSkillId, delay) end

---设置技能特效停止时是否同时停止绑定的技能音效
---@param isStop boolean true表示特效停止时停止音效，false表示音效自然播放完成
function this:SetSkillEffectStopAudioOnStop(isStop) end

---获取技能特效停止时是否同时停止绑定的技能音效
---@return boolean true表示特效停止时停止音效
function this:GetSkillEffectStopAudioOnStop() end

---播放背景音乐 (BGM)
---@param mapId number ID（参数2为false时读取cfg_map_info表id，反之为cfg_audio 表id）;
---@param isNotMap boolean 是否非地图背景音乐 (可选)
function this:PlayBGM(mapId, isNotMap) end

--------------召唤兽-----------------
---获取当前主角召唤兽的技能 ID
---@return number 技能 ID，不存在则返回 nil
function this:GetSummonBeastsSkillID() end

---根据技能id获取召唤兽的cfg_pet的表数据（不推荐使用，外置自行可读表）
---@param SkillId number 技能 ID (可选，默认获取当前主角的)
---@return cfg_pet_column 配置数据，不存在则返回 nil
function this:GetSummonBeastsPetCfgData(SkillId) end

---获取当前玩家拥有的召唤兽角色对象
---@return Role 角色对象，不存在则返回 nil
function this:GetMeSummonBeastsRole() end

---在控件上创建红点
---@param handler UIKmlLuaControlHandler 目标控件处理器
---@param offset number[] 偏移量 {x, y}
---@return UIKmlLuaControlHandler 红点控件处理器
function this:CreateRedPoint(handler, offset) end

---触发红点打开事件
---@param kmlLuaControl UIKmlLuaControlHandler 控件处理器
function this:AddRedPoint(kmlLuaControl) end

---刷新指定面板上的所有红点状态
---@param panelName string 面板名称 (controlId)
function this:RefreshPanelALLRedPoint(panelName) end

---根据条件类型刷新所有相关面板的红点状态
---@param condition EConditionType 条件类型
function this:RefreshPanelALLRedStateKmlByCondition(condition) end

---添加红点条件自定义判定函数
---@param condition EConditionType 条件类型
---@param callBack function 判定函数，返回 boolean
function this:AddRedDotConditionFunc(condition, callBack) end

---隐藏指定控件上的红点
---@param targetNode UIKmlLuaControlHandler 目标控件处理器
function this:HideRedPoint(targetNode) end

-------------地图点传送--------------
---根据地图id返回传送点列表
---@return cfg_transfer_point_column[]
---@return table
---@param mapId number @cfg_transfer_point表mapId
function SL:GetAllTransferPointById(mapId) end

---传送等级条件是否满足"checkLevel>=20"
---@return boolean
---@param condition string
function SL:CheckCalculateConditionGroup(condition) end

---地图该点位是否可传送点
---@return boolean,table
---@param x number
---@param y number
---@param mapId number @地图id
function SL:CheckPointCanTrans(x, y, mapId) end

---判断玩家当前位置是否看可触发传送
---@return boolean,table
function SL:CheckPlayerPointCanTrans() end

---获取传送定点id
---@return number @cfg_transfer_point表id
function SL:GetTransferPointId() end

---发送传送定点消息
---@param id number cfg_transfer_point 表 ID
function SL:SendTransferPointMessage(id) end

---随机传送
---@param id number 随机传送 ID
function SL:SendRandomTransPortMessage(id) end

---传送到 NPC 附近
---@param id number NPC ID
---@param show boolean 是否显示传送特效 (可选)
---@param npcId number @NPC配置表ID
---@param show boolean 是否显示面板 T:显示
function SL:SendTransferToNpcMessage(npcId, show) end

---获取玩家背包内可放入快捷栏的道具列表
---@return CommonProtos.Item[] 道具列表
function SL:GetIsFastItemList() end

-----------------------道具回收------------------------------
---获取玩家背包内可回收的道具列表
---@param cfgNameStr string 表名不填默认为cfg_recovery
---@return CommonProtos.Item[] 可回收道具列表
function SL:GetCanRecycleItemList(cfgNameStr) end

---获取玩家自动回收类型设置
---@param cfgNameStr string 表名不填默认为cfg_recovery
---@return number[] 自动回收类型列表
function SL:GetAutoRecoverTypeSetData(cfgNameStr) end

---获取玩家是否开启自动拾取勾选
---@return boolean 是否开启自动拾取勾选
function SL:GetPlayerAutoPickIsOpen() end

---获取玩家某一id类型勾选状态
---@return boolean
function SL:GetRecoverTypeState(id, cfgNameStr) end

---获取玩家是否开启自动回收勾选
---@return boolean 是否开启自动回收勾选
function SL:GetPlayerAutoRecoverIsOpen() end

---设置玩家自动拾取勾选
---@param isOpen boolean 自动拾取勾选是否开启
function SL:SetPlayerAutoPick(isOpen) end

---设置玩家自动回收勾选
---@param isOpen string 玩家自动回收勾选是否开启
function SL:SetPlayerAutoRecover(isOpen) end

---设置玩家自动回收类型勾选
---@param id number
---@param isOpen boolean
function SL:SetAutoRecoverType(id, isOpen, cfgNameStr) end

---请求自动拾取设置更改
---@param isOpen boolean
function SL:SendPlayerAutoPickChange(isOpen) end

---怪物和玩家角色的技能与攻击特效显示（不建议使用）
---@param id number
function SL:ReleaseEffect(id) end

---道具的特效显示
---@param id number @道具特效ID
function SL:ShowGroundEffect(id) end

---显示传送特效
function SL:ShowTeleportationEffect() end

---刷新主角高度
function SL:RefreshHeight_Me() end

---清除主角选中状态
function SL:ResetSelectTarget_Me() end

---设置主角动画触发器
---@param triggerName string 动画状态机上面的trigger名称
function SL:SetAnimatorTrigger_Me(triggerName) end

---设置指定角色动画触发器
---@param roleId number 角色唯一 ID
---@param triggerName string 动画状态机上面的trigger名称
function SL:SetAnimatorTrigger(roleId, triggerName) end

---播放主角动画
---@param animName string 动画名称
---@param crossFadeTime number 上个动画渐变过来的时 (可选)
---@param speed number 播放速度 (可选)
---@param stopAnyTime number 是否在播放后停在stopAnyTime秒处 (可选)
---@param layer number 动画层级 (可选)，-1表示所有层级，非-1，对应动画资源上面的层级
---@param loop boolean 是否循环 (可选)，默认false
function SL:SetAnimatorName_Me(animName, crossFadeTime, speed, stopAnyTime, layer, loop) end

---播放指定角色动画
---@param roleId number 角色唯一 ID
---@param animName string 动画名称
---@param crossFadeTime number 上个动画渐变过来的时 (可选)
---@param speed number 播放速度 (可选)
---@param stopAnyTime number 是否在播放后停在stopAnyTime秒处 (可选)
---@param layer number 动画层级 (可选)
---@param loop boolean 是否循环 (可选)，默认false
---@param specifyRole Role 指定的角色对象 (可选)，一般不用
function SL:SetAnimatorName(roleId, animName, crossFadeTime, speed, stopAnyTime, layer, loop, specifyRole) end

---判断角色是否正在播放技能动画
---@param roleId number 角色唯一 ID
---@return boolean 是否正在播放
function SL:IsSkillAnimPlaying(roleId) end

---获取动画状态的时长
---@param rid number 角色唯一 ID
---@param stateName string 动画状态名称
---@param animatorControllerName string 控制器名称 (可选),.controller后缀的动画资源文件名,例如AniCtr_712Role
---@return number, number, number 时长, 速度, 实际播放时长
function SL:GetAnimatorStateLength(rid, stateName, animatorControllerName) end

---设置角色朝向
---@param roleId number 角色唯一 ID
---@param dir EDirection 朝向枚举
function SL:SetDirection(roleId, dir) end

---判断角色是否正在播放指定动画
---@param roleId number 角色唯一 ID
---@param animName string 动画名称
---@return boolean 是否正在播放
function SL:IsAnimtorPlaying(roleId, animName) end

---缩放主角模型
---@param x number X 缩放值
---@param y number Y 缩放值
---@param z number Z 缩放值
function SL:SetModelScale_Me(x, y, z) end

---重置主角模型缩放
function SL:ResetModelScale_Me() end

---缩放指定角色模型
---@param roleId number 角色唯一 ID
---@param x number X 缩放值
---@param y number Y 缩放值
---@param z number Z 缩放值
function SL:SetModelScale(roleId, x, y, z) end

---重置指定角色模型缩放
---@param roleId number 角色唯一 ID
function SL:ResetModelScale(roleId) end

---设置角色Hud（Head）的高度，仅主角自己看着有效
---@param rid number 角色唯一 ID
---@param height number 高度偏移量
function SL:SetHeadHeight(rid, height) end

---重置角色Hud（Head）的高度，仅主角自己看着有效
---@param rid number 角色唯一 ID
function SL:ResetHeadHeight(rid) end

--- 升级特效显示
function SL:ShowUpgradeEffects() end

---请求自动回收设置更改
function SL:SendPlayerAutoRecoverChange(isOpen) end

---请求自动回收类型更改
---@param idList number[] @cfg_recovery表的id列表
---@param changeList boolean[] @是否勾选列表，顺序与idList对应，true为勾选，false为不勾选
---@param cfgNameStr string @配置表名称，默认为"cfg_recovery"
function SL:SendPlayerAutoRecoverTypeChange(idList, changeList, cfgNameStr) end

---判断玩家是否满足自动回收勾选条件
---@return boolean
function SL:CheckPlayerCanOpenAutoRecover() end

---请求回收
---@param indexList BagProtos.RecoveryItemReq @背包内道具的索引；indexList中的元素是{idxOfBags，count}；dxOfBags：number类型，表示道具在背包中的索引，count：number类型，表示道具的数量
function SL:SendRecoverItem(indexList) end

-----------------------道具分解------------------------------
---获取玩家背包内可分解的道具列表
---@return CommonProtos.Item[] 可分解的道具列表
function SL:GetPlayerDecomposeItemList() end

---获取自动分解类型勾选
---@return number[]
function this:GetPlayerAutoDecomposeType(cfgNameStr) end

---设置自动分解类型
---@param id number @cfg_recovery表的id，具体某一类型的勾选
---@param open boolean 是否勾选
---@param cfgNameStr string @配置表名称
function this:SetPlayerAutoDecomposeType(id, open, cfgNameStr) end

---请求分解
---@param indexList number[] @背包内道具的索引，行+列，再+10000，例：第五行第六列，索引就为10506
function SL:SendDecomposeItem(indexList) end

---打开分解界面
---@param openCallBack function 界面打开回调，无参数
function this:OpenEquipDecomposeUI(openCallBack) end

---打开锻造界面
---@param forgeGroupType EForgeGroupType 枚举类型
---@param equipSlot EEquipSlotType 枚举类型
---@param openCallBack function 界面打开回调，无参数
function this:OpenForgeGroupUI(forgeGroupType, equipSlot, openCallBack) end

---获取任务状态
---@param taskId number 任务 ID
---@return TaskState 任务状态枚举
function this:GetTaskState(taskId) end

---飘字提示
---@param content string 提示内容
---@param showTime number 显示时长 (秒) (可选)
---@param noticeType NoticeType 提示类型 (可选)
---@return table 提示对象
function this:TipMessage(content, showTime, noticeType) end

---关闭SL:TipMessage对应打开的界面
function this:CloseTipMessage() end

---经验飘字提示
---@param text string 文本内容
---@param fontName string 字体名称 (可选)
---@param id number 配置 ID (可选，默认 114)
---@param showTime number 显示时长 (可选)
function SL:ExpTipMessage(text, fontName, id, showTime) end

---显示通用提示框
---@param message KLUICommonTipsData 提示框数据
function SL:CommonTipsMessage(message) end

---关闭通用提示框
function SL:CloseCommonTipsMessage() end

---显示通用文本提示框
---@param message {str-提示内用:string, title-标题:string} 提示框数据
function SL:CommonStrTipsMessage(message) end

---设置 NPC 头顶图标
---@param npcId number NPC ID
---@param headIcon string 图标资源路径
function SL:SetNpcIcon(npcId, headIcon) end

---根据配置 ID 获取 NPC 角色对象
---@param cfgId number npclist配置表中的ID
---@return Role NPC 角色对象
function this:GetRoleBaseNpcId(cfgId) end

---根据道具 ID 打开获取途径面板
---@param _equip_pos string 打开的位置
---@param _cfgId number 物品配置 ID
---@param _id number 物品唯一 ID
---@param _count number 数量
---@param _ui UIKmlLuaPanelBase 源面板对象 (可选)
---@param _callBack function 回调函数 (可选)
---@param _item any 物品数据 (可选)
---@param _info any 额外信息 (可选)
function SL:CommonItemGetPath(_equip_pos, _cfgId, _id, _count, _ui, _callBack, _item, _info) end

---获取 NPC 相关的任务状态
---@param npcId number NPC ID
---@return number 1: 已完成, 0: 进行中, -1: 无任务
function this:GetInNpcTaskState(npcId) end

---尝试穿戴装备
function this:WearEquip() end

---尝试使用道具（快捷飘窗）
function this:UseBoxItem() end

---隐藏快捷飘窗的所有 Item
function this:HideBoxItem() end

---删除所有装备（飘窗相关）
function this:DelAllEquip() end

---添加快捷飘窗对应的 BoxItem
---@param boxItem BoxItemData 飘窗项数据
function this:AddBoxItem(boxItem) end

---删除快捷飘窗对应 ID 的 Item
---@param itemId number 物品配置 ID
function this:DeleteBoxItem(itemId) end

---刷新快捷提示界面
function this:UpdateUseTipPanel() end

---获取已显示的快捷飘窗 Item
---@return BoxItemData 飘窗项数据
function this:GetShowBoxItem() end

---获取当前可穿戴的装备
---@return BagProtos.BagItem,number,number @装备数据,几转装备,穿戴部位
function this:GetShowEquip() end

---移除当前的快捷飘窗 Item
function this:ReMoveNowItem() end

---设置特殊需要显示快捷弹窗的物品 ID
---@param cfgId number 物品配置 ID
function this:SetShowSpecialShowBoxItem(cfgId) end

---获取物品名称
---@param item CommonProtos.Item 物品数据
---@return string 物品名称
function this:GetItemNameByItemData(item) end

---获取装备需求属性列表
---@param cfgId number cfg_equip_entryLib配置表中的ID
---@return table 需求属性列表
function this:GetNeedAttrList(cfgId) end

---是否技能书类型
---@param cfgId number 物品配置id cfg_item标id
---@return boolean 是否是技能书
function this:CheckIsSkillBookType(cfgId) end

---检查装备基础职业是否满足要求
---@param equip CommonProtos.Item 装备数据
---@return boolean 是否满足
function this:CheckEquipBaseCareer(equip) end

---与身上穿戴装备比较初始评分
---@param equip CommonProtos.Item 待比较的装备数据
---@return number 1: 高于, 0: 等于, -1: 低于
function this:CompareInitGrage(equip) end

---获取自己身上与指定配置id对比的装备信息
---@param cfgId number @装备配置表id
---@return {cfgId:number, id:number} 身上对应的装备配置 ID 和唯一 ID，没有则返回 nil
function this:GetCompareEquip(cfgId) end

---隐藏大地图
function this:HideBigMap() end

---显示大地图
function this:ShowBigMap() end

---显示传送动画
function this:showTransferAnimation() end

---设置自动范围拾取配置（配置了才会进行自动范围拾取）
---@param count number 拾取数量
---@param interval number 拾取间隔 (秒)
---@param speed number 拾取速度
function this:StartFastPickUp(count, interval, speed) end

---停止自动范围拾取
function this:StopFastPickUp() end

---添加好友
---@param rid number @角色id
function this:AddFriend(rid) end

---删除好友
---@param rid number @角色id
function this:DelFriend(rid) end

---获取指定id玩家是否是好友
---@param rid number @角色id
---@return boolean @指定id玩家是否是好友
function this:CheckIsFriend(rid) end

---添加黑名单
---@param rid number @角色id
function this:AddBlackList(rid) end

---移除黑名单
---@param rid number @角色id
function this:DelBlackList(rid) end

---移除宿敌
---@param rid number @角色id
function this:DelEnemyList(rid) end

---获取指定id玩家是否在黑名单中
---@param rid number @角色id
---@return boolean @指定id玩家是否在黑名单中
function this:CheckIsInBlackList(rid) end

---获取好友，黑名单, 好友申请列表
---@param type number @类型 1 好友  3黑名单  4好友申请列表
---@return FriendProto.FriendInfo[] @指定类型数据列表
function this:GetFriendData(type) end

---处理好友申请
---@param rid number @角色id
---@param agree number @ 1同意 0拒绝
function this:HandleAddFriendRequest(rid, agree) end

---设置围绕主人转圈类型的守护表现行为参数
---@param guardPet GuardPet 守护兽对象
---@param args {circleSpeed:number, circleRadius:number} 动作参数，circleRadius 范围 0-1
function this:SetGuardPetActionArgs(guardPet, args) end

---创建守护
---@param data {id:number, cfgId:number, x:number, y:number, isUI:boolean} 创建数据
---@return Role 守护兽角色对象
function this:CreateGuardPet(data) end

---快捷指令处理
---@param params string[] 快捷指令数据 (参数 1 为指令名称)
---@param callBack function 指令完成回调 (可选)
---@param menuLayerParam any 菜单层级参数 (可选)
---@param moveToArriveCallBack function 移动到达回调 (可选)
---@param taskGoal any 任务目标信息 (可选)
---@return boolean 是否执行成功或特定指令的结果
function this:ShortcutDO(params, callBack, menuLayerParam, moveToArriveCallBack, taskGoal) end

---主角直线移动
---@param moveDir Vector3 移动方向
---@param isRun boolean 是否跑步
---@param isTrack boolean 是否追踪
---@param isResetSelectAction boolean 是否重置选择动作
---@return boolean 是否成功开始移动
function this:LineMoveTo(moveDir, isRun, isTrack, isResetSelectAction) end

---重置主角直线移动状态
function this:ResetLineMove() end

---清除延迟技能释放
function this:ClearDelaySkill() end

---设置角色头顶PK文字
---@param role Player 玩家对象
---@param text string 图标文本
---@param color Color 颜色
---@param fontName string 字体名称
---@param extensionName string 扩展名
---@param fontSize number 字号
---@param x number X 偏移
---@param y number Y 偏移
---@param z number Z 偏移
---@param isSkipGlobalOutlineCondition boolean 是否跳过全局描边条件
function this:SetPkIcon(role, text, color, fontName, extensionName, fontSize, x, y, z, isSkipGlobalOutlineCondition) end

---设置红名颜色变化
---@param role Player 玩家对象
---@param color Color 文字颜色
function this:SetRedNameColorChange(role, color) end

---刷新角色名字颜色
---@param role Player 玩家对象
function this:SetActorNameColor(role) end

---根据角色id获取角色对象
---@param roleId number 角色唯一 ID
---@return Role 角色对象
function this:GetRoleById(roleId) end

---屏幕坐标转 UI 本地坐标
---@param target UIKmlLuaControl 目标控件
---@param x number 屏幕 X 坐标
---@param y number 屏幕 Y 坐标
---@return boolean, Vector2 是否转换成功, 本地坐标
function this:ScreenPointToLocalPointInRectangle(target, x, y) end

---打开等待/加载 UI
---@param args table 参数 {isTips:boolean, msg:string, waitTimeClose:number, timeOutCallBack:function} 例如:{isTips=true,msg = "断线重连中(1)",waitTimeClose=45,timeOutCallBack=nil}
function this:OpenWaitingUI(args) end

---隐藏等待/加载 UI
function this:HideWaitingUI() end

---获取 UI 相机
---@return UnityEngine.Camera UI 相机对象
function this:GetUICamera() end

---刷新角色外观
---@param id number 角色唯一 ID
---@param appearList table<EEquipSlotType, number> 外观部件列表
function this:RefreshAppear(id, appearList) end

---将角色外观变成怪物的形象
---@param id number 角色唯一 ID
---@param monsterCfgId number 怪物配置 ID
function this:RefreshToShowMonster(id, monsterCfgId) end

---刷新角色称号
---@param id number 角色唯一 ID
---@param titleCfgId number 称号配置 ID
function this:RefreshTitle(id, titleCfgId) end

---获取带颜色的富文本
---@param msg string 文本内容
---@param color Color 颜色 如：#FFFFFF
---@return string 富文本
function this:GetColorText(msg, color) end

---截取字符串指定长度后与指定字符串拼接
---@param str string 源字符串
---@param campLength number 截断长度
---@param postStr string 后缀字符串 (如 "...")
---@return string 处理后的字符串
function this:CampString(str, campLength, postStr) end

---地图寻路移动
---@param x number 目标 X 坐标
---@param y number 目标 Y 坐标
---@param cfgMapMoveId number 寻路配置 ID (可选)
---@param onArrive function 到达回调 (可选)
---@param includeSelf boolean 是否包含自身 (可选)
---@param isUIShow_MePathMove boolean 是否显示移动路径 UI (可选)
---@param toNpc boolean 是否是移动到 NPC (可选)
---@param line number 寻路地图线路 (可选)
function this:MapMove(x, y, cfgMapMoveId, onArrive, includeSelf, isUIShow_MePathMove, toNpc, line) end

---获取装备的词条属性列表
---@param item CommonProtos.Item 装备数据
---@return table 词条属性列表
function this:GetEquipEntrys(item) end

---获取服务器开服天数
---@return number 开服天数
function this:GetOpenServerDay() end

---创建场景中的物品模型
---@param resPath string res下的资源路径
---@param loadCallback function 加载完成回调，参数为 (Transform)
function this:CreateSceneItemModel(resPath, loadCallback) end

---回收场景中的物品模型
---@param go UnityEngine.Transform 模型 Transform
function this:RecycleSceneItemModel(go) end

---同步加载资源
---@param path string 资源路径
---@param type System.Type 资源类型
---@param cacheTime number 缓存时间 (可选)
---@return any 资源对象
function this:LoadAsset(path, type, cacheTime) end

---异步加载资源
---@param path string 资源路径
---@param callback function 加载完成回调，参数为 (res)
---@return Coroutine| table 协程对象和资源请求对象|资源加载句柄request
function this:LoadAssetAsync(path, callback) end

---下载资源包
---@param groupname string 资源组名称
---@param packageIndex number 包索引 (可选，默认 2)
---@param onDownloading fun(currentSize:number, totalSize:number)|nil 下载中回调，参数为(已下载大小, 总大小)
---@param onComplete fun()|nil 下载完成回调
---@return number 总下载大小（字节）
function this:DownloadPackage(groupname, packageIndex, onDownloading, onComplete) end

---释放资源请求对象
---@param request UnityEngine.ResourceRequest 资源请求对象
function this:DisposeAsset(request) end

---设置并使用自定义主角动画控制器
---@param resPath string 资源相对应Assets/Res的路径，包括后缀。注意Assets/Res/Animator路径下的资源无法单独加载，可以放到Assets/Res/Common下面
---@return Coroutine 协程对象
function this:SetUseCustomPlayerAnimatorController(resPath) end

---获取聊天频道名称字符串
---@param channel EChatChannelType 频道枚举
---@return string 频道名称
function this:ChatInfo_GetChatTypeStr(channel) end

---保存聊天发送的物品信息
---@param itemInfo CommonProtos.Item @保存的道具信息
function this:ChatInfo_AddChaItemInfo(itemInfo) end

---获取当前是否在队伍中
---@return boolean 是否在队伍中
function this:TeamInfo_IsInTeam() end

---获取聊天目标信息
---@param playerId number 玩家Id
---@return ChatProto.ResChat[] @聊天记录列表
function this:ChatInfo_GetChaTargetInfo(playerId) end

---获取指定频道的聊天记录
---@param channel EChatChannelType @频道
---@param num number @获取聊天数量，默认不填可以全部获取 EChatChannelType.All的话会超过50条，其他频道最多保存50条。指定数量少一点可以减少界面刷新消耗
---@return ChatProto.ResChat[] @聊天记录列表
function this:ChatInfo_GetChatInfo(channel, num) end

---请求移除与指定id的玩家的私聊信息
---@param rid number @角色ID
function this:ChatInfo_FriendShow(rid) end

---获取未读好友消息数量
---@return boolean 是否有未读消息
function this:ChatInfo_FriendLookTipShow() end

---获取好友提示信息
---@param rid number 角色 ID
---@return string 提示信息
function this:ChatInfo_GetFriendTip(rid) end

---设置其他玩家展示的装备
---@param equipIndex number 装备索引
function this:FriendInfo_SetOtherPlayerEquips(equipIndex) end

---添加角色 ID 到已发送好友申请列表
---@param rid number 角色ID
function this:FriendInfo_AddIdToAlreadySendFriendReq(rid) end

---获取推荐好友列表
---@return FriendProto.FriendInfo[]  推荐好友列表
function this:FriendInfo_GetRecommendFriends() end

---设置下一次好友推荐刷新时间
function this:FriendInfo_SetNextTime() end

---获取下一次好友推荐刷新时间
---@return number 时间戳
function this:FriendInfo_GetNextTime() end

---获取与好友的聊天历史记录
---@param friendId number @玩家角色Id
---@return number[] @聊天历史id列表
function this:FriendInfo_GetChatHistory(friendId) end

---获取好友消息内容
---@param msgId number @消息Id
---@return ChatProto.ResChatExt @单条聊天数据
function this:FriendInfo_GetMsg(msgId) end

---获取队伍队长 ID
---@return number 队长 ID
function this:TeamInfo_GetLeaderId() end

---获取当前队伍 ID
---@return number 队伍 ID
function this:TeamInfo_GetTeamId() end

---获取邮件列表映射表
---@return table<number, MailProto.MailInfo> 邮件列表
function this:MailInfo_GetMailTbl() end

---获取GM面板设置的 shader名字
---@return string shader名字
function this:GmInfo_GetDiffuseFlowing() end

---获取已显示的快捷飘窗 Item
---@return BoxItemData 飘窗项数据
function this:UiBoxTipsInfo_GetShowBoxItem() end

---卸载所有uiBoxTipsInfo脚本的注册事件和注册消息
function this:UiBoxTipsInfo_UnRegistAll() end

---获取任务奖励预览信息
---@return table 奖励信息
function this:TaskInfo_GetPreviewRewardInfo() end

---获取所有任务数据
---@return table<number,TaskProtos.TaskRecord> @任务列表<任务id,数据>
function this:TaskInfo_GetAllTasks() end

---获取所有任务 ID 列表
---@return number[] 任务 ID 列表
function this:TaskInfo_GetAllIds() end

---设置移动过程中的击杀怪物范围和回调
---@param range number 范围
---@param moveCallBack function 移动回调
---@param attackMonsterCfgId number 攻击怪物配置 ID
---@param instruction string 指令
---@param maxSearAStarCount number 最大寻路搜索次数
---@param goal any 目标
---@param customDoFunc function 自定义执行函数
function this:SetTaskKillMonsterRangeOnMoving(range, moveCallBack, attackMonsterCfgId, instruction, maxSearAStarCount, goal, customDoFunc) end

---判断是否是战盟盟主
---@return boolean 是否是盟主
function this:UnionInfo_IsBoos() end

---获取战盟当前人数
---@return number 战盟人数
function this:UnionInfo_GetAllNum() end

---判断是否有战盟管理权限
---@return boolean 是否有权限
function this:UnionInfo_IsPowerMan() end

---获取战盟成员列表
---@return UnionProto.UnionMemberInfo[] @行会成员列表
function this:UnionInfo_GetUnionMemberList() end

---设置战盟成员列表
---@param unionMemberInfo table 成员列表数据
function this:UnionInfo_SetUnionMemberList(unionMemberInfo) end

---根据cfg_career表id和cfg_task表id,获取获取进行任务时cfg_system_switch表数据
---@param careerTblId number 职业表 ID
---@param taskId number 任务 ID
---@return table 按钮信息
function this:CfgSystemSwitchPost_GetSystemBtnGetTaskInfo(careerTblId, taskId) end

---根据cfg_career表id和cfg_task表id,获取完成任务时cfg_system_switch表数据(不建议使用)
---@param careerTblId number 职业表 ID
---@param taskId number 任务 ID
---@return table 按钮信息
function this:CfgSystemSwitchPost_GetSystemBtnFinishedTaskInfo(careerTblId, taskId) end

---根据面板名称获取显示/隐藏配置
---@param panelName string 面板名称
---@return cfg_showHideUI_column 系统信息配置
function this:CfgShowHideUIPost_GetSystemInfoByPanelName(panelName) end

---获取属性基础配置表
---@return table<number, cfg_att_info_column> 属性配置表
function this:CfgAttInfoPost_GetCfgBaseTbl() end

---根据根职业，职业等级，职业编号信息获取职业表id,职业名称等数据
---@param careerInfo CommonProtos.Career 职业信息
---@return number 职业配置 id cfg_career表id字段
---@return string 职业配置 name cfg_career表name字段
---@return number 职业配置 upGradeEffect cfg_career表upGradeEffect字段
---@return number 职业配置 careerRankName cfg_career表careerRankName字段
---@return number 职业配置 nextCareerNum cfg_career表nextCareerNum字段
function this:CfgCareerPost_GetCfgCareerId(careerInfo) end

---根据职业 ID 获取职业名称
---@param careerId number cfg_career职业配置表的ID
---@return string 职业名称
function this:CfgCareerPost_GetCfgCareerName(careerId) end

---设置气泡界面是否需适配移动位置
---@param isMove boolean 是否移动
function this:MainUIManager_SetMovePopoverPos(isMove) end

---获取角色进入场景的返回数据
---@return UserProtos.EnterRoleRes 返回进入场景的角色数据
function this:GetEnterRoleRes() end

---获取当前是否已进入游戏场景
---@return boolean 是否在游戏中
function this:GetIsInGame() end

---获取连击技能 ID
---@return number 技能 ID
function this:GetComboSkillId() end

---获取当前服务器名称
---@return string 服务器名称
function this:GetCurServerName() end

---获取所有服务器结构信息
---@return ServerListStruct 服务器列表结构json文件格式
function this:GetServerStruct() end

---获取当前选择服特殊类型
---@return EServerSpecType 特殊类型
function this.LoginManager:GetCurServerSpecType() end

---获取当前选择服原始开服时间
---@return string 原始开服时间，格式yyyy-MM-dd HH:mm:ss
function this.LoginManager:GetCurServerOpenServerTime() end

---获取玩家上次选择的技能 ID
---@return number 技能 ID
function this.LoginManager:GetSelectSkillId() end

---设置玩家当前选择的技能 ID
---@param id number 技能 ID
function this.LoginManager:SetSelectSkillId(id) end

---获取上次登录的账号
---@return string 账号名称
function this.LoginManager:GetLastAccount() end

---设置游戏场景进入状态
---@param inGame boolean 是否在场景中
function this.LoginManager:SetInGame(inGame) end

---设置是否进行登录校验
---@param isCheck boolean 是否校验
function this.LoginManager:SetIsLoginCheck(isCheck) end

---获取登录响应数据
---@return UserProtos.LoginRes 登录响应数据
function this.LoginManager:GetLoginRes() end

---获取登录响应中的角色信息
---@return UserProtos.RoleInfo 角色信息
function this.LoginManager:GetLoginRes_Role() end

---获取当前登录的 OpenID
---@return string OpenID
function this.LoginManager:GetOpenId() end

---获取登录响应中的解锁列表
---@return number[] 解锁列表
function this.LoginManager:GetLoginRes_UnlockList() end

---请求删除角色
---@param message UserProtos.RemoveRoleReq 删除角色请求
function this.LoginManager:RemoveRole(message) end

---请求添加角色响应
---@param message UserProtos.CreateRoleRes 添加角色响应
function this.LoginManager:AddRoleRes(message) end

---获取当前服务器 ID
---@return number 服务器 ID
function this.LoginManager:GetCurServer_Sid() end

---获取当前渠道 ID
---@return number 渠道 ID
function this.LoginManager:GetChannelId() end

---获取职业解锁数据
---@param careerId number cfg_character_create表ID
---@return boolean 职业是否解锁
function this.LoginManager:GetCareerUnlockData(careerId) end

---刷新职业解锁列表
---@param id number 职业 ID
function this.LoginManager:RefreshCareerUnlockList(id) end

---获取是否为 Xtra 版本
---@return boolean 是否是 Xtra
function this:GetIsXtra() end

---获取是否为 WebGL 版本
---@return boolean 是否是 WebGL
function this:GetIsWebGL() end

---获取是否为 WebGL 浏览器环境
---@return boolean 是否是 WebGL 浏览器
function this:GetIsWebGLBrowser() end

---获取当前游戏类型
---@return number 游戏类型（"1":盒子，"2":盒子SDK,"3":外部sdk,"4":新白包，"":老白包）
function this:GetGameType() end

---获取主角数据对象
---@return MeData 主角数据对象
function this:GetMeData() end

---获取主角当前等级
---@return number 角色等级
function this:MeData_GetLevel() end

---获取主角当前战力
---@return number 角色战力
function this:MeData_GetFightValue() end

---获取主角当前坐标
---@return Dot2 坐标对象
function this:MeData_GetCoord() end

---获取主角性别
---@return number 性别 (0: 女, 1: 男)
function this:MeData_GetSex() end

---获取主角特殊属性值
---@param attrType EMUCharacterAttrType 属性类型
---@return number 属性值
function this:MeData_GetSpecialAttrValue(attrType) end

---获取主角职业信息
---@return CommonProtos.Career 职业信息
function this:MeData_GetCareer() end

---检查强化大师是否可以激活
---@return boolean 是否可以激活
function this:MeData_CheckStrengthMasterCanActive() end

---检查追加大师是否可以激活
---@return boolean 是否可以激活
function this:MeData_CheckAppendMasterCanActive() end

---获取主角所属战盟 ID
---@return number 战盟 ID
function this:MeData_GetUnionId() end

---根据物品唯一 ID 获取其在背包中的索引
---@param id number 物品唯一 ID
---@return number 背包索引
function this:MeData_GetIndexBaseOnItemId(id) end

---获取主角角色 ID
---@return number 角色唯一 ID
function this:MeData_GetId() end

---回收指定角色对象
---@param id number 角色唯一 ID
function this:RecycleRole(id) end

---停止主角移动
---@param isRestSelectTarget boolean 是否重置当前目标 (可选)
---@param isStopMove boolean 是否强制停止移动 (可选)
---@param OldCoord Dot2 目标坐标 (可选)
---@return boolean 是否成功停止
function this:Me_StopMove(isRestSelectTarget, isStopMove, OldCoord) end

---获取主角角色扩展信息
---@return UserProtos.RoleInfoExt 角色扩展信息
function this:MeData_GetRoleExtInfo() end

---获取主角当前队伍 ID
---@return number 队伍 ID 0-为没有加入组队，非0-为加入组队的队伍id
function this:MeData_GetTeamId() end

---检查主角数据是否已初始化
---@return boolean 是否初始化
function this:MeData_Check() end

---执行路径寻路移动
---@param dstPos Dot2 目标坐标
---@param stopRange number 停止距离
---@param stopCellCount number 停止格子数 (可选)
---@param onArrive function 到达回调 (可选)
---@param isRun boolean 是否跑步 (可选)
---@param isTrack boolean 是否追踪 (可选)
---@param isResetSelectAction boolean 是否重置选择动作 (可选)
---@param isUIShow_MePathMove boolean 是否显示移动路径 UI (可选)
---@param isMoveOver boolean 是否移动结束回调 (可选)
---@param isFearMove boolean 是否为恐惧移动 (可选)
---@param isSkipCanNotOperCheck boolean 是否跳过不可操作检查 (可选)
---@param isClickTerrain boolean 是否点击地面触发 (可选)
---@param monsterId number 追踪的怪物 ID (可选)
---@return boolean 是否成功开始寻路
function this:PathMoveTo(dstPos, stopRange, stopCellCount, onArrive, isRun, isTrack, isResetSelectAction, isUIShow_MePathMove, isMoveOver, isFearMove, isSkipCanNotOperCheck, isClickTerrain, monsterId) end

---清除主角移动到达的回调函数
function this:ClearOnArriveCallBack() end

---获取指定角色的当前移动状态
---@param rid number 角色唯一 ID
---@return boolean, Dot2 是否正在移动, 目标坐标
function this:GetCurMoveStatus(rid) end

---获取主角拥有的指定技能对象
---@param skillId number 技能 ID
---@return Skill 技能对象
function this:MeData_GetSkill(skillId) end

---根据物品配置 ID 获取其在背包中的数据
---@param cfgId number 物品配置 ID
---@return CommonProtos.Item 物品数据
function this:MeData_GetCfgBaseOnItemId(cfgId) end

---获取主角当前地图坐标
---@return number, number X 坐标, Z 坐标
function this:MeData_Pos() end

---创建玩家角色对象
---@param message UserProtos.RoleInfo 玩家信息
---@param asycinitImmediately boolean 是否立即异步初始化 (可选)
---@param canNoMe boolean 是否允许非主角 (可选)
---@return Player 玩家角色对象
function this:CreatePlayer(message, asycinitImmediately, canNoMe) end

---根据 NPC ID 检查对话按钮是否可见
---@param npcId number NPC cfg_npclist配置表中的ID
---@return boolean 是否可见
function this:GetTalkBtnVisByNpcId(npcId) end

---触发与 NPC 的对话
---@param npcId number cfg_npclist配置表中的ID
---@param forFinishTask boolean 是否需要完成任务 (可选)
---@param isQuickInstructions boolean 是否是快捷指令触发 (可选)
---@param npcuuid number NPC AddMainPanelUIHideShowPos唯一 ID (可选)
function this:TalkToNpc(npcId, forFinishTask, isQuickInstructions, npcuuid) end

---请求与 NPC 对话 (底层协议)
---@param uiType number 对话界面类型 (ReqUiType),0:npc，1：挂机
---@param key string NPC 标识，格式为 "npcCfgId#npcId",npcCfgId:cfg_npclist的id。npcId:唯一id没有的话就不发
---@param openInRange boolean openInRange boolean 是否在范围内打开 (默认true) true:检查范围 false:不检查范围
---@param finishTask boolean 是否刷新任务进度
function this:ReqNpcTalk(uiType, key, openInRange, finishTask) end

---设置主角点击普攻按钮场景中范围特效的大小
---@param releaseRange number 释放范围
function this:SelectAttackModel(releaseRange) end

---设置技能自动释放开关
---@param v boolean 是否开启
function this:Skill_SetSkillAutoReleaseSwitch(v) end

---设置是否优先请求移动
---@param b boolean 是否优先 (默认 true)
function this:Me_ReqMoveFirst(b) end

---触发主角移动到目标点
---@param dstPos Dot2 目标坐标
---@param stopRange number 停止距离
---@param stopCellCount number 停止格子数
---@param onArriveData any 到达后的数据或回调
---@param isRun boolean 是否跑步
---@param isTrack boolean 是否追踪
---@param isResetSelectAction boolean 是否重置选择动作
---@param isUIShow_MePathMove boolean 是否显示移动路径 UI
---@param isClickTerrain boolean 是否点击地面触发
---@return boolean 是否触发成功
function this:Me_TriggerToMove(dstPos, stopRange, stopCellCount, onArriveData, isRun, isTrack, isResetSelectAction, isUIShow_MePathMove, isClickTerrain) end

---获取摊位是否可以移动
---@return boolean 是否可以移动
function this:Me_GetSellerIsCanMove() end

---获取主角指定穿戴栏和部位的装备
---@param pos EEquipSlotType 装备穿戴部位
---@param wearBar number 穿戴栏配置 ID (cfg_wearing_bar)
---@return CommonProtos.Item 装备数据
function this:MeData_GetEquipByPosAndWearBar(pos, wearBar) end

---获取是否展开系统功能
---@return boolean 是否展开
function this:GetIsExpandSystemFunction() end

---向 UI 模型添加特效
---@param t UIModelData 特效参数表
function this:AddModelEffect(t) end

---检查是否拥有时装
---@return boolean 是否拥有时装
function this:CheckOwnFashion() end

---根据装备索引获取穿戴栏 ID 和装备位
---@param index number 装备索引
---@return number, EEquipSlotType 穿戴栏 ID, 装备位
function this:GetWearBarAndPosBaseEquipIndex(index) end

---检查指定穿戴栏是否拥有时装
---@param wearBar number 穿戴栏 ID
---@return boolean 是否拥有
function this:CheckOwnTargetWearbarFashion(wearBar) end

---请求地图怪物状态信息
---@param mapId number 地图 ID
---@return boolean 是否请求成功
function this:ReqMapMonsterStatusMessage(mapId) end

---请求 NPC 商店商品信息
---@param shopId number 商店 ID,cfg_npcShop表shopId字段
---@param callback function 响应回调
---@param ui any 回调挂载的 UI 对象（lua关键字self）
function this.NpcShop:ReqNpcShopInfo(shopId, callback, ui) end

---请求购买 NPC 商店商品
---@param shopId number 商店 ID,(cfg_npcShop表shopId字段)
---@param goodsId number 商品配置 ID,NpcShopProto.NpcShopGoods.goodsId
---@param count number 购买数量
---@param callback function 响应回调
---@param ui any 回调挂载的 UI 对象
function this.NpcShop:ReqBuyShopGoods(shopId, goodsId, count, callback, ui) end

---请求删除邮件
---@param mailIdList number[] 邮件ID列表
function this.Mail:ReqDeleteMail(mailIdList) end

---获取所有邮件列表
---@return table<number, MailProto.MailInfo> 邮件列表
function this.Mail:GetAllMail() end

---请求领取邮件附件
---@param mailIds number[] 邮件ID列表
function this.Mail:GetMail(mailIds) end

---根据职业获取属性换算信息
---@param career CommonProtos.Career 职业信息
---@return table 换算信息
function this.RoleAtt:GetAttConversionInfoByCareer(career) end

---请求属性加点分配
---@param data table 加点数据
---@param n number 操作类型
function this.RoleAtt:ReqDeployAttrPoint(data, n) end

---请求所有战盟列表信息
function this:ReqAllUnionMessage() end

---请求一键申请加入战盟
function this:ReqAllApplyMessage() end

---请求指定战盟的详细信息
---@param unionId number 战盟 ID
function this:ReqUnionDetailsMessage(unionId) end

---请求查看当前所属战盟的信息
function this:ReqViewUnionMessage() end

---请求战盟成员动态信息
function this:ReqUnionMemberDynamicMessage() end

---请求退出当前战盟
function this:ReqQuitUnionMessage() end

---请求修改战盟名称
---@param warAllianceName string 战盟名称
function this:ReqChangeUnionNameMessage(warAllianceName) end

---请求创建战盟
---@param union_name string 战盟名称
---@param flagIndex number 战盟图标索引
function this:ReqCreateUnionMessage(union_name, flagIndex) end

---请求修改战盟公告
---@param desTxt string 公告文本
function this:ReqChangeAnnouncementMessage(desTxt) end

---请求踢出战盟成员
---@param memberId number 成员角色 ID
function this:ReqKickOutUnionMemberMessage(memberId) end

---请求更换战盟职位
---@param memberRid number 成员角色 ID
---@param type number 职位类型 (1: 禅让盟主, 2: 设为副盟主, 3: 设为战斗队长, 4: 设为精英, 5: 设为成员)
function this:ReqChangePositionMessage(memberRid, type) end

---请求更新战盟信息（臂章和名称）
---@param name string 战盟名称
---@param unionArmband number 臂章索引
function this:ReqUpdateUnionInfoMessage(name, unionArmband) end

---设置角色头顶的 VIP 名称样式
---@param rid number 角色唯一 ID
---@param fontPath string 字体资源路径
---@param vipName string VIP 名字
---@param offsetX number X 轴偏移
---@param y number Y 轴偏移
---@param fontOffsetX number 字体 X 轴偏移
---@param isShowLeft boolean 是否显示在左侧
---@return boolean 是否设置成功
function this:SetHeadVipName(rid, fontPath, vipName, offsetX, y, fontOffsetX, isShowLeft) end

---请求打开指定类型的好友界面
---@param type number 界面类型 (0:陌生人 1好友 2宿敌 3黑名单 4申请列表)
function this.Friend:ReqOpenFriendPanelMessage(type) end

---请求推荐好友列表
function this.Friend:ReqRecommendFriendsMessage() end

---请求根据关键字搜索好友
---@param str string 搜索玩家名称关键字
function this.Friend:ReqSearchFriendMessage(str) end

---请求添加好友或操作
---@param type number 操作类型 1好友，4黑名单
---@param rid number 目标角色ID
function this.Friend:ReqAddFriendMessage(type, rid) end

---请求获取其他玩家详细信息
---@param otherId number @玩家角色ID
---@param type number 请求类型 1 角色基本信息 2 装备信息
function this.Friend:ReqOtherRoleInfoMessage(otherId, type) end

---请求好友相关日志信息
---@param type EFriendRelation @日志类型 1：好友 2：宿敌 3：黑名单 4：申请列表
---@param targetId number @目标角色ID
function this.Friend:ReqFriendLogsMessage(type, targetId) end

---将一维索引转换为二维坐标（行列）
---@param index number 背包索引
---@return number, number 行, 列
function this.Bag:GetHorAndVetWithInt(index) end

--根据行列获取背包行列索引 例如：hor=5, vet=4 返回504  hor=14, vet=3 返回1403
---@param hor number 行
---@param vet number 列
---@return number 行列索引
function this.Bag:GetIntWithHorAndVet(hor, vet) end

---对物品列表进行排序
---@param itemList CommonProtos.Item[] @物品列表
---@return table<number,CommonProtos.Item> @<行列组合键值，道具数据>
function this.Bag:SortItemList(itemList) end

---根据页码和行列坐标获取背包索引
---@param page number 页码
---@param hor number 行
---@param vet number 列
---@return number 背包索引
function this.Bag:GetIndexWithPageHorAndVet(page, hor, vet) end

---根据页码和行列坐标获取仓库索引
---@param page number 页码
---@param hor number 行
---@param vet number 列
---@return number 仓库索引
function this.StoreHouse:GetIndexWithPageHorAndVet(page, hor, vet) end

---设置自定义阻挡数据范围
---@param leftBottom Dot2 左下角坐标
---@param rightTop Dot2 右上角坐标
function this.Scene:SetCustomResistanceData(leftBottom, rightTop) end

---设置跨图寻路到达目标点后的回调函数
---@param func function 回调函数
function this.Scene:SetTransMapMoveToPointCallbackFunc(func) end

---获取距离某个点最近的非阻挡点
---@param findDot2 Dot2 目标点
---@param range number 搜索范围 不能是负数
---@param includeSelf boolean 是否包含自身坐标
---@return Dot2 非阻挡点坐标
function this.Scene:GetFindNearNpcAvilPoint(findDot2, range, includeSelf) end

---设置场景当前选择的技能 ID（用于 选中技能，点地面某一位置释放）
---@param skillId number 技能 ID
function this.Scene:SetSelectSkill(skillId) end

---设置当前场景名称
---@param name string 场景名称
function this.Scene:SetSceneName(name) end

---设置场景环境光颜色和强度
---@param ambientColor Color 环境光颜色 (可选，默认Color(0.305, 0.305, 0.305))
---@param intensity number 整体光照强度 (可选，默认 1)
---@param terrainIntensity number 地形光照强度 (可选，默认 1)
---@param r number 255制环境光R值，ambientColor为空时生效 (可选)
---@param g number 255制环境光G值，ambientColor为空时生效 (可选)
---@param b number 255制环境光B值，ambientColor为空时生效 (可选)
---@param a number 255制环境光A值，ambientColor为空时生效 (可选，默认255)
function this.Scene:SetAmbientColor(ambientColor, intensity, terrainIntensity, r, g, b, a) end

---根据配置表 ID 添加模型特效
---@param effectType ESceneEffectType 特效类型
---@param id number 唯一标识
---@param cfgId number 配置 ID (cfg_model_effect)
---@param x number X 坐标
---@param z number Z 坐标
---@param offset Vector3 偏移量 (可选)
---@param playOverType EPlayEffectOverType 播放结束处理类型 (可选)
---@param playCallBack function 播放结束回调 (可选)
---@param secId number 次要 ID (可选)
---@param playNum number 播放次数 (可选)
---@return SceneEffect 特效对象
function this.SceneEffect:AddModelEffectByCfgId(effectType, id, cfgId, x, z, offset, playOverType, playCallBack, secId, playNum) end

---直接通过资源路径添加场景特效
---@param effectType ESceneEffectType 特效类型
---@param id number 唯一标识
---@param modelPath string 模型资源路径
---@param playTime number 播放时长
---@param x number X 坐标
---@param z number Z 坐标
---@param offset Vector3 偏移量 (可选)
---@param playerOverType EPlayEffectOverType 播放结束处理类型 (可选)
---@param playCallback function 播放结束回调 (可选)
---@param secId number 次要 ID (可选)
---@param playNum number 播放次数 (可选)
---@param scale number 缩放比例 (可选)
---@return SceneEffect 特效对象
function this.SceneEffect:AddEffect(effectType, id, modelPath, playTime, x, z, offset, playerOverType, playCallback, secId, playNum, scale) end

---判断指定标识的特效是否存在
---@param effectType ESceneEffectType 特效类型
---@param id number 唯一标识
---@param secId number 次要 ID (可选)
---@return boolean 是否存在
function this.SceneEffect:IsExist(effectType, id, secId) end

---移除指定的场景特效
---@param effectType ESceneEffectType 特效类型
---@param id number 唯一标识
---@param secId number 次要 ID (可选)
function this.SceneEffect:RemoveEffect(effectType, id, secId) end

---获取当前服务器时间戳 (毫秒)
---@return number 服务器时间
function this.Time:GetServerTime() end

---格式化秒数为时分秒字符串 (HH:MM:SS)
---@param time number 总毫秒
---@return string 格式化后的字符串
function this.Time:FormatTimeHMS(time) end

---解析 JSON 字符串为 Lua 表
---@param txt string JSON 文本
---@return table Lua 表对象
function this:DecodeJson(txt) end

---显示装备不可穿戴的提示
---@param itemInfo CommonProtos.Item 装备数据
function this.Equip:ShowCantEquipTip(itemInfo) end

---请求从仓库取出物品
---@param storeIndex number 仓库索引
function this.Equip:ReqStoreTakeButtonMessage(storeIndex) end

---请求将物品存入仓库
---@param bagIndex number 背包索引
---@param storePage number 仓库页码
function this.Equip:ReqBagPutStoreButtonMessage(bagIndex, storePage) end

---获取装备唯一ID在装备位中的索引
---@param itemId number 物品唯一 ID
---@return number 装备索引
function this.Equip:GetIndexBaseOnItemId(itemId) end

---获取主相机控制对象
---@return MainCamera 主相机对象
function this.MainCamera:GetMainCamera() end

---获取 Unity 相机组件
---@return UnityEngine.Camera 相机组件
function this.MainCamera:GetCamera() end

---重置相机位置和旋转到主视角
function this.MainCamera:ResetCameraToMain() end

---设置场景相机的观察参数
---@param isLockCamera boolean 是否锁定相机,false设置成3d视
---@param orbitAngles Vector2 轨道角度 3D视角初始角 (可选)
---@param distance number 观察距离 3D视角距离主角的距离，用来调整远近
---@param minVerticalAngle number 最小付视
---@param maxVerticalAngle number 最大仰角
---@param mindistance number 最小拉近距离 (可选，默认 5)
---@param obstructionMask number 遮挡层掩码 根据预制体上面的Layer 做2的幂次加和(可以缺省 默认为0(可选)
---@param alignDelayDis number 镜头位移延迟速度 (可选)镜头前后位移速度(可以缺省 默认为0.01）
---@param alignSmoothRange number 镜头平滑旋转范围 (可选)镜头旋转速度(角度 可以缺省 默认为45）
---@param alignNoSmoothMin number 镜头直接设置旋转的最小值 (可选)可以缺省 默认为3
---@param alignNoDelayDis number 镜头直接设置位移的最小值 (可选)可以缺省 默认为0.001
---@param height number 目标高度 (可选，默认 2)
---@param width number 目标宽度 (可选，默认 0.6)
---@param nearheigh number 拉近后的视角高度偏移 (可选，默认 1.8)
function this.MainCamera:SetLookCamera(isLockCamera, orbitAngles, distance, minVerticalAngle, maxVerticalAngle, mindistance, obstructionMask, alignDelayDis, alignSmoothRange, alignNoSmoothMin, alignNoDelayDis, height, width, nearheigh) end

---设置 3D 相机参数
---@param distance number 3D视角距离主角的距离，用来调整远近
---@param minVerticalAngle number 最小俯视
---@param maxVerticalAngle number 最大仰角
function this.MainCamera:Set3DCameraParams(distance, minVerticalAngle, maxVerticalAngle) end

---设置自定义相机移动参数
---@param isCustomCameraMove boolean 是否开启自定义相机移动
---@param isDragMoveCamera boolean 是否开启拖拽移动相机
---@param isZhanQiMove boolean 是否开启战旗移动模式
---@param moveIntervalStopTime number 每次移动间隔停止时间 (可选)
function this.MainCamera:SetCustomCameraMove(isCustomCameraMove, isDragMoveCamera, isZhanQiMove, moveIntervalStopTime) end

---启用或禁用 Bloom (全屏泛光) 后处理效果
---@param isEnable boolean 是否启用
---@param bloomThreshold number 泛光阈值 (可选，默认 0.9)
---@param bloomIntensity number 泛光强度 (可选，默认 1)
function this.MainCamera:EnableBloom(isEnable, bloomThreshold, bloomIntensity) end

---设置自动旋转到玩家移动视角
---@param isauto boolean 是否自动移动视角
---@param euleranglesX number 移动视角的 X 轴欧拉角
---@param checkinterval number 检查时间间隔 (秒) (可选，默认 0.3)
function this.MainCamera:SetAutoRotation(isauto, euleranglesX, checkinterval) end

---设置相机碰撞的高度和宽度 (常用于切换坐骑)
---@param height number 目标高度 (可选，默认 2)
---@param width number 目标宽度 (可选，默认 0.6)
---@param nearheight number 拉近后的视角高度偏移 (可选，默认 1.8)
function this.MainCamera:SetHitHeightAndWidth(height, widht, nearheight) end

---设置相机位置和旋转角度
---@param localPos Vector3 本地坐标
---@param localrotation Vector3 本地旋转
---@param distance number 距离(不为nil,不设置localPos)
function this.MainCamera:SetCameraCustomParam(localPos, localrotation, distance) end

---重置相机位置和旋转
function this.MainCamera:ResetCameraCustomParam() end

---设置相机偏移
---@param offset Vector3 偏移量
function this:SetOffset2CSPreScene(offset) end

---计算角色到主相机的单位向量
---@return Vector3 单位向量
function this:ComputeRole2MainCamera() end

---更新主相机父节点位置
function this:UpdateMainCameraPos() end

---创建 UIEffect 实例
---@return UIEffect UIEffect 对象
function this.Constructor_In:UIEffect() end

---获取服务器返回的战盟申请列表信息
---@return table 申请列表信息
function this.Union:GetApplyListInfo() end

---请求设置战盟加入限制
---@param autoAccept boolean 是否自动接受 0不开启  1开启
---@param needLevel number 等级需求
---@param fightValue number 战力需求
function this.Union:ReqUnionSettingMessage(autoAccept, needLevel, fightValue) end

---请求全部同意战盟申请
function this.Union:ReqAllAgreeMessage() end

---请求全部拒绝战盟申请
function this.Union:ReqAllRejectMessage() end

---请求处理单个战盟申请
---@param targetRid number 目标角色 ID
---@param isAgree boolean 是否同意
function this.Union:ReqAgreeUnionApplyMessage(targetRid, isAgree) end

---请求申请加入指定战盟
---@param unionId number 战盟 ID
function this.Union:ReqApplyJoinUnionMessage(unionId) end

---设置场景编辑器进度状态
---@param pType number 进度类型
function this.SceneEditorManager:SetProgressState(pType) end

---隐藏所有 KML 界面
function this:HideAllKmlPanel() end

---获取 PC 技能信息管理器实例
---@return PCSkillInfoMgr 管理器实例
function this.PCSkillInfoMgr:GetPcSkillInfoMgr() end

---判断是否可以释放指定技能
---@param targetId number 目标角色 ID
---@param skillId number 技能配置 ID
---@param level number 技能等级
---@param skillOwnerId number 技能拥有者 ID
---@return ESkillReleaseError 释放结果错误码(是否满足释放条件)
function this.Skill:IsCanReleaseSkill(targetId, skillId, level, skillOwnerId) end

---判断指定角色是否正在快速移动（如冲锋）
---@param rid number 角色唯一 ID
---@return boolean 是否快速移动中
function this.Skill:IsQuickMoving(rid) end

---设置技能特效时长是否使用配置表中的播放时间
---@param useSkillEffectPlayTime boolean 是否使用
function this.Skill:SetUseSkillEffectPlayTime(useSkillEffectPlayTime) end

---移动到目标点并攻击
---@param skillId number 技能配置 ID
---@param targetId number 目标角色 ID (默认不填，目标位置。可选)
---@param targetCoord Dot2 目标坐标 (可选)
---@param isSkipCanNotOperCheck boolean 默认不填，是否跳过特殊bufff检查(不可操作buff等，可选)
---@param isMoveToTargetCoord  boolean 是否移动到目标点
function this.Skill:MoveToAttack(skillId, targetId, targetCoord, isSkipCanNotOperCheck, isMoveToTargetCoord) end

---设置释放技能时是否允许移动
---@param b boolean 是否允许,默认false。nil或者false，表示需要技能播放完成后才能移动。true：可以在技能播放过程中操作摇杆或者寻路移动
function this.Skill:SetGlobalIsCanMoveOnPlaySkill(b) end

---请求升级技能
---@param skillId number 技能配置 ID
function this:ReqUpSkillMessage(skillId) end

---异步创建场景特效
---@param effectPath string 特效资源路径
---@param loadEffectCallBack function 创建成功回调，参数为 (ResourceRequest)
function this:CreateSceneEffect(effectPath, loadEffectCallBack) end

---回收场景特效对象
---@param go UnityEngine.GameObject 特效对象
function this:RecycleSceneEffect(go) end

---设置角色受击飘字检查函数
---@param func function 检查函数，返回 boolean
function this.Role:SetShowHurtLabel(func) end

---请求随机角色名
---@param careerId number 职业 ID
---@param dissatisfiedName string 不满意的旧名称 (可选)
function this.NetManager_Req:ReqRandomRoleNameMessage(careerId, dissatisfiedName) end

---请求创建角色
---@param roleName string 角色名称
---@param sex number 性别 默认是1
---@param career number 职业配置 ID cfg_character_create表id
---@param inviteCode string 邀请码 (可选)
function this.NetManager_Req:ReqCreateRoleMessage(roleName, sex, career, inviteCode) end

---请求解锁职业
---@param uid number 用户 ID
---@param careerId number 职业 ID
---@return boolean 是否请求成功
function this.NetManager_Req:ReqUnLockUserCareerMessage(uid, careerId) end

---请求删除角色
---@param rid number 角色 ID
function this.NetManager_Req:ReqRemoveRoleMessage(rid) end

---请求进入角色场景
---@param rid number 角色 ID
---@param clientType number 客户端类型
---@param width number 屏幕宽度
---@param height number 屏幕高度
---@param reconnect boolean 是否是断线重连
---@param isSimulator boolean 是否是模拟器
---@return boolean 是否请求成功
function this.NetManager_Req:ReqEnterRoleMessage(rid, clientType, width, height, reconnect, isSimulator) end

---提交游戏数据到 SDK
---@param dataType number 数据类型
---@param eventType string 事件类型
---@param roleId number 角色 ID
---@param roleName string 角色名称
---@param roleLevel number 角色等级
---@param moneyNum number 持有金币数
---@param unionId number 战盟 ID
---@param unionName string 战盟名称
---@param figheValue number 战力值
---@param vipLevel number VIP 等级
---@param additionalParameters string 额外参数
---@return boolean 是否提交成功
function this.SDKMgr:SubmitGameData(dataType, eventType, roleId, roleName, roleLevel, moneyNum, unionId, unionName, figheValue, vipLevel, additionalParameters) end

---打开 SDK 客服界面
function this.SDKMgr:OpenCustomerService() end

---获取 SDK 相关的 URL
---@param type string 类型 (1: 云手机, 2: 三端互通, 3: 微端下载, 4: VIP 客服, 5: 绑定手机)
function this.SDKMgr:GetURL(type) end

---获取 WebGL 版 SDK 信息
---@param type string 类型
function this.SDKMgr:GetWebGLSDKInfo(type) end

-----获取游戏版本【没用，废弃】
-----@return number|EVersion  @Normal = 0,QJ5 = 1,TSJL = 2,XW = 3
function this.Main:GetVersion() end

---判断是否在编辑器环境下
---@return boolean 是否是编辑器
function this.Main:IsEditor() end

---判断是否在安卓平台上
---@return boolean 是否是安卓
function this.Main:IsAndroid() end

---判断是否在 iOS 平台上
---@return boolean 是否是 iOS
function this.Main:IsIos() end

---判断是否连接到本地服务器
---@return boolean 是否是本地服务器
function this.Main:IsLocalServer() end

---判断是否在 Windows 平台上
---@return boolean 是否是 Windows
function this.Main:IsWindows() end

---判断是否在 WebGL 平台上
---@return boolean 是否是 WebGL
function this.Main:IsWebGL() end

---加载并更新资源组
---@param gameId number 游戏 ID
---@param groupname string 组名称
---@param engineVersion string 引擎版本
---@param gmResVersion string 资源版本
---@param updateCalLBack function 更新回调
---@param needRestartGameCallBack function 需要重启游戏的回调
function this.Main:LoadAndUpdateGroup(gameId, groupname, engineVersion, gmResVersion, updateCalLBack, needRestartGameCallBack) end

---重置游戏,会清空所有数据,包括角色数据,场景数据,网络数据等,通常用来热更重启lua，资源加载等
function this.Main:Restart() end

---打印网络消息日志
---@param id number 消息 ID
---@param message any 消息内容
function this.NetManager:PrintMessage(id, message) end

---关闭网络连接
function this.NetManager:Close() end

---执行异步逻辑切换
---@param isAsync boolean 是否异步
---@param func function 执行函数
---@param ... any 传递给函数的参数
function this:Async_SwitchAsync(isAsync, func, ...) end

---显示不隐藏已有界面的 UI
---@param panelName string 面板名称
---@param args any 参数 (可选)
---@param animation any 动画参数 (可选)
---@param isSync boolean 是否同步加载 (可选)
---@return table UI 面板对象
function this.UIManager:ShowNotHideUI(panelName, args, animation, isSync) end

---隐藏指定 UI 面板
---@param name string 面板名称
---@param animation any 动画参数 (可选)
---@param isSwitchPnl boolean 是否是切换面板 (可选)
function this.UIManager:Hide(name, animation, isSwitchPnl) end

---显示功能性 UI 面板
---@param panelName string 面板名称
---@param args any 参数 (可选)
---@param animation any 动画参数 (可选)
---@param isSync boolean 是否同步加载 (可选)
---@return table UI 面板对象
function this.UIManager:ShowFunctionUI(panelName, args, animation, isSync) end

---获取删除角色的服务器 URL
---@return string 服务器 URL
function this.UIStaticParameter:GetDeleteServerUrl() end

---获取创建角色的服务器 URL
---@return string 服务器 URL
function this.UIStaticParameter:GetCreateServerUrl() end

---打印不带标签的日志
---@param ... any 日志内容，不限类型
function this:logNoFlag(...) end

---发起 WWW 请求
---@param url string 请求 URL
---@param form UnityEngine.WWWForm 表单数据
---@param callBack function 成功回调
---@param callBackData any 传递给回调的数据
---@param errorCallBack function 错误回调
function this.Http:RequestWWW(url, form, callBack, callBackData, errorCallBack) end

---设置游戏基础信息（用于打点等）
---@param UID string 用户 ID
---@param name string 用户名
---@param roleId number 角色 ID
---@param roleName string 角色名称
---@param serverID number 服务器 ID
---@param platformID number 平台 ID
---@param gameid number 游戏 ID
---@param serverName string 服务器名称
---@param boxUID string 盒子 UID
function this.GamePlay:SetGameInfo(UID, name, roleId, roleName, serverID, platformID, gameid, serverName, boxUID) end

---判断是否为 SDK 模式
---@return boolean 是否是 SDK
function this.LoginInfo:IsSDK() end

---判断是否为盒子 SDK 模式
---@return boolean 是否是盒子 SDK
function this.LoginInfo:IsBoxSDK() end

---判断是否为盒子版
---@return boolean 是否是盒子版
function this.LoginInfo:IsBox() end

---判断是否为外部 SDK
---@return boolean 是否是外部 SDK
function this.LoginInfo:IsOutSDK() end

---判断是否为白包
---@return boolean 是否是白包
function this.LoginInfo:IsWhitePkg() end

---加载指定路径的场景
---@param path string 场景资源路径
---@param callback function 加载完成回调
function this.SceneManager:Load(path, callback) end

---创建一个新的队列对象
---@return Queue 队列实例
function this.Queue:New() end

---获取行为树对象
---@return BehaviorTree 行为树对象
function this.BtTree:BehaviorTree() end

---获取行为树事件对象
---@return BehaviorEvent 行为事件对象
function this.BtTree:BehaviorEvent() end

---设置指定角色的活动阵营和排名
---@param rid number 角色唯一 ID
---@param camp number 阵营 ID
---@param rank number 排名
function this:SetRoleActivityCamp(rid, camp, rank) end

---初始化错误日志监听工具
function this:InitErrorLogTool() end

---构建 WWWForm 表单对象
---@param fieldTbl table<string, string|number> 字段映射表
---@return UnityEngine.WWWForm 表单对象
function this:GetWWWForm(fieldTbl) end

---添加回调到字体过滤模式 (针对某些平台的显示优化)
---@param val string 字体名
function this:AddCallBack2FontFilterMode(val) end

---关闭启动器 UI
function this.LauncherUI:Close() end

---移除启动器 UI 的所有 Lua 委托
function this.LauncherUI:RemoveAllLuaDelegate() end

---判断启动器 UI 是否打开
---@return boolean 是否打开
function this.LauncherUI:IsOpen() end

function this:GetCommandLineArgs() end

---重启应用程序
function this:RestartApplication() end

---设置鼠标指针样式
---@param tex UnityEngine.Texture2D 指针贴图
---@param offset Vector2 偏移位置
function this:SetCursor(tex, offset) end

---通过路径查找场景中的 GameObject
---@param path string 层级路径
---@return UnityEngine.GameObject 查找到的对象
function this:GameObjectFind(path) end

---实例化 Unity 对象
---@param obj UnityEngine.Object 源对象
---@param parent UnityEngine.Transform 父节点 (可选)
---@param worldPositionStays boolean 是否保持世界坐标 (可选，默认 false)
---@return UnityEngine.Object 实例化后的对象
function this:GameObjectInstantiate(obj, parent, worldPositionStays) end

---立即销毁 Unity 对象
---@param obj UnityEngine.Object 待销毁对象
---@param allowDestroyingAssets boolean 是否允许销毁资源 (可选，默认 false)
function this:DestroyObjectImmediate(obj, allowDestroyingAssets) end

---创建资源加载追踪器
---@return TCFramework.ResourceLoadTracker 追踪器实例
function this:CtorResourceLoadTracker() end

---判断场景编辑器操作类型是否为关闭
---@return boolean 是否为关闭
function this:IsSceneEditorOperTypeClose() end

---获取对象的四个点的世界坐标
---@param obj UnityEngine.GameObject|UnityEngine.Component @对象的组件
---@return Vector4 @(minX, minY, maxX, maxY)
function this:GetWorldCorners(obj) end

--获取对象或者对象的子对象身上的RectTransform组件
---@param obj UnityEngine.GameObject|UnityEngine.Component @对象或者对象身上的组件
---@param path string @路径 可缺省（代表在对象自身上找）
---@return UnityEngine.UI.Button 组件对象
function this:GetButtonComp(obj, path) end

---获取指定路径下的 RectTransform 组件
---@param obj UnityEngine.GameObject 根对象
---@param path string 相对路径 (可选)
---@return UnityEngine.RectTransform 组件对象
function this:GetRectTransfomComp(obj, path) end

---获取指定路径下的 RectGuideMask 组件 (引导遮罩)
---@param obj UnityEngine.GameObject 根对象
---@param path string @路径 可缺省（代表在对象自身上找）
---@return TCFramework.RectGuideMask 组件对象
function this:GetRectGuideMaskComp(obj, path) end

---获取对象或者对象的子对象身上的Toggle组件
---@param obj UnityEngine.GameObject|UnityEngine.Component @对象或者对象身上的组件
---@param path string @路径 可缺省（代表在对象自身上找）
---@return UnityEngine.UI.Toggle 组件对象
function this:GetToggleComp(obj, path) end

---设置地图遮罩矩形范围
---@param v1 Vector2 左上角
---@param v2 Vector2 右下角
function this.MapMaskMgr:SetRect(v1, v2) end

---设置地图警示遮罩矩形范围
---@param v1 Vector2 左上角
---@param v2 Vector2 右下角
---@param y number 高度偏移 (可选，默认 0.1)
function this.MapMaskMgr:SetAlertRect(v1, v2, y) end

---设置地图警示遮罩的透明度
---@param alpha number 透明度值 (0-1)
function this.MapMaskMgr:SetAlertAlpha(alpha) end

---销毁地图遮罩实体
function this.MapMaskMgr:DestroyEntity() end

---创建一个 C# 的字符串字典对象
---@return System.Collections.Generic.Dictionary`2[[System.String, mscorlib],[System.String, mscorlib]] 字典对象
function this:CreateCSDictionary() end

---执行数值插值动画
---@param from number 起始值
---@param to number 目标值
---@param duration number 时长
---@param setter fun(param:number) 赋值回调
---@param leanType ELeanTweenType 缓动类型 (可选)
---@param onComplateFunc function 完成回调 (可选)
---@return table tween动画对象
function this.LeanTween:To(from, to, duration, setter, leanType, onComplateFunc) end

---获取鼠标点击线性投射到地面点的世界坐标
---@param camera UnityEngine.Camera 相机对象
---@return number,number,number 世界坐标 x,y,z
function this.CSPreScene:LinearCastGround(camera) end

---移除 C# PreScene 的所有 Lua 委托【登录模块不对外开放，接口移除】
function this.CSPreScene:RemoveAllLuaDelegate() end

---播放序列帧动画组件
---@param go UnityEngine.GameObject 目标对象
---@param beginFrame number 起始帧
---@param fps number 帧率
---@param isLoop boolean 是否循环
---@param isInUIShow boolean 是否在 UI 中显示
function this:PlaySpriteFrameAnimation(go, beginFrame, fps, isLoop, isInUIShow) end

---停止序列帧动画组件
---@param go UnityEngine.GameObject 目标对象
function this:StopSpriteFrameAnimation(go) end

---添加自定义绑定的 Mono 组件
---@param gObj UnityEngine.GameObject 目标对象
---@param luaAwake function Awake 回调
---@param luaOnEnable function OnEnable 回调
---@param luaStart function Start 回调
---@param luaUpdate function Update 回调
---@param luaOnDisable function OnDisable 回调
---@param luaOnDestroy function OnDestroy 回调
---@return CustomBindMono 组件实例
function this:AddCustonBindMono(gObj, luaAwake, luaOnEnable, luaStart, luaUpdate, luaOnDisable, luaOnDestroy) end

---移除自定义绑定的 Mono 组件及其回调
---@param gObj UnityEngine.GameObject 目标对象
function this:RemoveCustomBindMono(gObj) end

---设置玩家连击技能特效的隐藏类型
---@param isShow boolean 是否显示
function this:SetPlayerComboSkillEffectType(isShow) end

---@param message {oldIndex:number, newIndex:number, itemId:number} 交换信息 oldIndex,newIndex指装备索引，itemId指装备id
function this:SwitchEquipSlot(message) end

---根据系统 ID 获取主界面 UI 配置信息
---@param systemId string 系统 ID
---@return cfg_MainPanelUI_column 配置信息
function this:cfg_MainPanelUI_post_GetSystemInfoBySystemId(systemId) end

---根据面板名称获取主界面 UI 配置信息
---@param systemName string 面板名称
---@return cfg_MainPanelUI_column 配置信息
function this:cfg_MainPanelUI_post_GetSystemInfoByPanelName(systemName) end

---动态修改角色坐骑模型路径及相关参数
---@param rid number 角色 ID
---@param mountModelPath string 坐骑模型路径
---@param rideMountRoleHangPoint string 骑乘挂点名称
---@param mountModelScale number 坐骑缩放
---@param mountRotation table<number, number> 坐骑旋转角度 {x, y, z}
---@param mountPosOffsetX number X 轴偏移
---@param mountPosOffsetY number Y 轴偏移
---@param mountPosOffsetZ number Z 轴偏移
---@param rideMountRoleHpHeight number 骑乘时的血条高度
function this:ModifyMountModelPath(rid, mountModelPath, rideMountRoleHangPoint, mountModelScale, mountRotation, mountPosOffsetX, mountPosOffsetY, mountPosOffsetZ, rideMountRoleHpHeight) end

---设置需要预加载的资源路径
---@param path string 资源路径
function this:SetPreLoadAssetPath(path) end

---获取已预加载的资源对象
---@param path string 资源路径
---@return UnityEngine.GameObject 资源对象
function this:GetPreLoadAsset(path) end

---获取角色头顶部件
---EHeadPart.HP_Part 返回 CSSpriteMesh，可用 SL.Head.CSSpriteMesh 接口获取和设置属性
---EHeadPart.Union_Name_Part 返回 CSLabel，可用 SL.Head.CSLabel 接口获取和设置属性
---EHeadPart.Name_Part 返回 CSLabel，可用 SL.Head.CSLabel 接口获取和设置属性
---EHeadPart.Vip_Name_Part 返回 CSLabel，可用 SL.Head.CSLabel 接口获取和设置属性
---EHeadPart.Pk_Level_Part 返回 CSLabel，可用 SL.Head.CSLabel 接口获取和设置属性
---EHeadPart.Level_Icon_Part 返回 CSSpriteMesh，可用 SL.Head.CSSpriteMesh 接口获取和设置属性
---EHeadPart.Hook_Part 返回 CSLabel，可用 SL.Head.CSLabel 接口获取和设置属性
---EHeadPart.Lab_Title_Part 返回 CSLabel，可用 SL.Head.CSLabel 接口获取和设置属性
---EHeadPart.Title_Part 返回 CSSpriteMesh，可用 SL.Head.CSSpriteMesh 接口获取和设置属性
---EHeadPart.Icon_Part 返回 CSSpriteMesh，可用 SL.Head.CSSpriteMesh 接口获取和设置属性
---EHeadPart.Talk_Part 返回 CSMultiLabel，可用 SL.Head.CSMultiLabel 接口获取和设置属性
---EHeadPart.Talk_Name_Part 返回 CSMultiLabel，可用 SL.Head.CSMultiLabel 接口获取和设置属性
---EHeadPart.StallName_Part 返回 CSSellerMultiLabel，可用 SL.Head.CSSellerMultiLabel 接口获取和设置属性
---@param rid number 角色 ID
---@param e_headPart EHeadPart 头顶部件枚举
---@return CSLabel|CSSpriteMesh|CSMultiLabel|CSSellerMultiLabel|nil 头顶部件组件
function this:GetHeadPart(rid, e_headPart) end

---获取角色头顶部件对象
---@param rid number 角色 ID
---@param e_headPart number 部位类型 (EHeadPartType)
---@param instantiateGo UnityEngine.GameObject 实例化后的对象
---@param pos Vector3 本地坐标
---@param scale Vector3 本地缩放
---@param rotate Vector3 本地旋转
---@param type UnityEngine.Component 组件类型
---@return any 部位对象
function this:GetHeadPart_out(rid, e_headPart, instantiateGo, pos, scale, rotate, type) end

---回收角色头顶部件对象
---@param rid number 角色 ID
---@param e_headPart number 部位类型 (EHeadPartType)
function this:RecycleHeadPart_out(rid, e_headPart) end

---在角色骨骼节点上发布特效
---@param isUIRole boolean 是否是 UI 角色
---@param rid number 角色 ID
---@param nodeName string 骨骼节点名称 (如 "Body")
---@param effectId number 特效配置 ID (cfg_model_effect)
---@param id number 唯一标识 (可选)
---@param secId number 次要标识 (可选)
---@param sortLayer number 渲染层级 (越大越靠前)
---@param effectOverType EPlayEffectOverType 特效结束处理类型
---@param isSameModePathOnlyOne boolean (可选,默认true) true：相同资源路径，如果id和secId相同的情况下，只会播放一个，防止内存泄露。false：代码需要注意释放特效，否则会内存泄露
---@param loadEffectCallBack function 创建成功回调，参数为 (ResourceRequest)
---@return RoleEffect 特效对象
function this:ReleaseRoleNodeMapEffect(isUIRole, rid, nodeName, effectId, id, secId, sortLayer, effectOverType, isSameModePathOnlyOne, loadEffectCallBack) end

---在角色骨骼节点上挂载模型
---@param isUIRole boolean 是否是 UI 角色
---@param rid number 角色 ID
---@param nodeName string 骨骼节点名称.例如 LeftHand,RightHand,LeftWeapon,RightWeapon,Body,BuffspineParent(后背),EffectRoot(脚底),Wing。其他更细的骨骼点请咨询引擎人员
---@param modelCharactorId number 模型配置 ID (cfg_model_charactor)
---@param id number 唯一标识 (可选) 
---@param secId number 次要标识 (可选)
---@param sortLayer number 特效层级，越大越上面，一般UI上面才需要调整。(可选)
---@param isSameModePathOnlyOne boolean (可选,默认true) true：相同资源路径，如果id和secId相同的情况下，只会播放一个，防止内存泄露。false：代码需要注意释放特效，否则会内存泄露
---@return RoleEffect 特效模型对象,可作为SL:StopRoleEffect参数传入
function this:ReleaseRoleNodeMapModel(isUIRole, rid, nodeName, modelCharactorId, id, secId, sortLayer, isSameModePathOnlyOne) end

---在角色中心点发布特效
---@param isUIRole boolean 是否是 UI 角色
---@param rid number 角色 ID
---@param effectId number 特效配置 ID (cfg_model_effect)
---@param id number 唯一标识 (可选)
---@param secId number 次要标识 (可选)
---@param sortLayer number 渲染层级 (可选)
---@param isSameModePathOnlyOne boolean (可选,默认true) true：相同资源路径，如果id和secId相同的情况下，只会播放一个，防止内存泄露。false：代码需要注意释放特效，否则会内存泄露
---@return RoleEffect 特效对象
function this:ReleaseRoleEffect(isUIRole, rid, effectId, id, secId, sortLayer, isSameModePathOnlyOne) end

---播放角色特效的动画或触发器
---@param roleEffect RoleEffect 角色特效对象
---@param animName string 动画名称
---@param triggerName string 触发器名称 (可选)
function this:PlayRoleEffectAnim(roleEffect, animName, triggerName) end

---停止并回收指定的角色特效
---@param isUIRole boolean 是否是 UI 角色
---@param rid number 角色 ID
---@param effect RoleEffect 待停止的特效对象
function this:StopRoleEffect(isUIRole, rid, effect) end

---获取当前的资源加载模式
---@return number 加载模式 0:编辑器 1:编辑器里面的ab包模式 2:包里面
function this:GetResourceLoadMode() end

---将地图格子坐标转换为世界坐标
---@param tx number 格子 X 坐标
---@param tz number 格子 Z 坐标
---@return number, number, number 世界 X, Y, Z 坐标
function this:TileToWorld(tx, tz) end

---将世界坐标转换为地图格子坐标
---@param tx number 世界 X 坐标
---@param tz number 世界 Z 坐标
---@return number, number 格子 X, Z 坐标
function this:WorldToTile(tx, tz) end

---获取指定格子坐标的 Cell 对象
---@param x number 格子 X 坐标
---@param z number 格子 Z 坐标
---@return Cell 格子对象
function this:GetCell(x, z) end

---设置是否开启自动吃药功能
---@param isCanAutoEatPill boolean 是否开启
function this:SetAutoEatPill(isCanAutoEatPill) end

---设置角色头顶显示的名称
---@param rid number 角色 ID
---@param name string 角色名称
---@param isRichText boolean 是否包含富文本 (可选)
function this:SetRoleName(rid, name, isRichText) end

---加载 Sprite 图片资源
---@param base any 挂载对象
---@param path string 资源路径
---@param callback function 加载完成回调
---@param data any 传递给回调的数据
function this:LoadSprite(base, path, callback, data) end

---设置角色头顶的图片图标 (Sprite)
---@param rid number 角色 ID
---@param path string 图片资源路径
---@param isOffset boolean 是否需要偏移 (可选)
function this:SetRoleHeadIcon(rid, path, isOffset) end

---设置角色头顶标签是否启用全局描边
---@param isoutline boolean 是否启用 (默认 true)
function this:SetRoleHeadGlobalOutline(isoutline) end

---设置角色攻击时是否不强制转向,用来比如一些箭塔攻击人的时候
---@param rid number 角色 ID
---@param b boolean 是否开启
function this:SetAttackNoDirection(rid, b) end

---设置安全区内角色是否可以跑步
---@param rid number 角色 ID
---@param flag boolean 是否允许跑步，true(可以run)/false(默认不可以)
function this:SetSafeAreaIsCanRunFlag(rid, flag) end

---判断当前是否为 2D 渲染模式
---@return boolean 是否是 2D 模式
function this:Is2D() end

---创建并生成飞向主角的场景掉落道具
---@param id number 掉落物唯一 ID
---@param cfgId number 物品配置 ID
---@param count number 数量
---@param flyTime number 飞行时长 (秒)
function this:CreateFlyToMeDropItem(id, cfgId, count, flyTime) end

---设置自动战斗逻辑是否在执行完拾取道具后再进行
---@param isAfterExecutionPickUpItem boolean 是否开启
function this:SetAutoFightIsAfterExecutionPickUpItem(isAfterExecutionPickUpItem) end

---设置自动战斗的全局时间间隔
---@param v number 间隔时长 (秒)
function this:SetGlobalAutoFightTimeInterval(v) end

---获取当前是否为审核包状态
---@return boolean 是否是审核包
function this:GetIsShenHe() end

---在 UI 上创建红月框架序列帧动画
---@param spriteFrame any 序列帧组件对象,首次传进来是nil属于正常
---@param modelPath string 资源路径
---@param parent UnityEngine.Transform 父节点
---@param callback fun(gameObject:UnityEngine.GameObject,name:string) 加载完成回调
---@param isHadBoxCollider boolean 是否包含碰撞体 (可选,默认 false)
---@return any 序列帧组件对象，返回的是spriteFrame这个对象
function this.SL2D:UI_CreateRedMoonFrame(spriteFrame, modelPath, parent, callback, isHadBoxCollider) end

---播放红月框架序列帧动画
---@param spriteFrame any 序列帧组件对象
---@param isloop boolean 是否循环 (可选，默认 true)
---@return any 序列帧组件对象
function this.SL2D:UI_PlayRedMoonFrame(spriteFrame, isloop) end

---回收红月框架序列帧动画对象
---@param spriteFrame any 序列帧组件对象
function this.SL2D:UI_RecycleRedMoonFrame(spriteFrame) end

---启用或禁用线性管线渲染
---@param b boolean 是否启用
function this:EnableLinearPipeline(b) end

---启用或禁用低质量场景渲染
---@param b boolean 是否启用
function this:EnableLowQualityScene(b) end

---设置掉落道具的拾取等待时间
---@param dropItem DropItem 掉落物对象
---@param waitPickUpTime number 拾取等待结束的时间戳
function this.DropItem:SetWaitPickUpTime(dropItem, waitPickUpTime) end

---设置全局掉落物名称背景图
---@param pngPath string 图片资源路径，包括后缀名
function this.DropItem:SetGlobalNameBG(pngPath) end

---设置全局掉落物名称字体大小
---@param fontSize number 字号 (可选，默认 16)
function this.DropItem:SetGlobalFontSize(fontSize) end

---设置掉落物隐藏的相关参数
---@param hideDropItemType EHideDropItemType 隐藏类型；0不隐藏,1隐藏模型,2隐藏全部特效,3，隐藏非光柱特效
---@param maxShowDropItemCount number 最大显示数量
function this.DropItem:SetHideDropItemInfo(hideDropItemType, maxShowDropItemCount) end

---设置寻路脚印的显示状态
---@param isShow boolean 是否显示 true:显示脚印, false:隐藏脚印
function this:SetPathFindFootShowStatus(isShow) end

---获取 Lua 全局表 _G
---@return table _G 表
function this:Get_G() end

---获取 Lua package 表
---@return table package 表
function this:Get_Package() end

---设置 UI 界面内武器是否背在背后，默认是背在背后的
---@param b boolean true:背在背后，false:不背在背后
function this:SetWeaponAttackBack_UI(b) end

---设置安全区内武器是否背在背后，默认是背在背后的
---@param b boolean true:背在背后，false:不背在背后
function this:SetWeaponAttackBack_SafeCell(b) end

---设置水中武器是否背在背后，默认是背在背后的
---@param b boolean true:背在背后，false:不背在背后
function this:SetWeaponAttackBack_InWater(b) end

---设置玩家头顶战盟名称的显示位置
---@param headPartOfUnionNamePos EHeadPartOfUnionNamePos 位置枚举
function this:SetHeadPartOfUnionPos(headPartOfUnionNamePos) end

---设置是否拾取所有类型的掉落道具
---@param param boolean 是否开启
function this:PickUpAllTypeDropItem(param) end

---设置自动拾取是否启用模糊匹配
---@param param boolean 是否开启
function this:SetDropItemVagueMatch(param) end

---设置自动拾取模糊匹配的具体参数信息
---@param param1 string 匹配关键词
---@param param2 boolean 是否启用
function this:SetDropItemVagueMatchInfo(param1, param2) end

---设置自动战斗是否跳过非和平模式判断（用于和平模式下能攻击玩家，也需服务器处理和平模式（不掉血））
---@param isSkipFightCheckPKMode boolean 是否跳过
function this:SetIsSkipFightCheckPKMode(isSkipFightCheckPKMode) end

---设置 WebView 绑定的 RectTransform 区域
---@param webRect UnityEngine.RectTransform RectTransform 组件
function this.UniWebViewMgr:SetUITransform(webRect) end

---设置 WebView 的屏幕旋转方向
---@param orientation UnityEngine.ScreenOrientation 旋转方向 
function this.UniWebViewMgr:SetOrientation(orientation) end

---设置 WebView 旋转后的延迟加载时间
---@param delayTime number 延迟时间 (秒)
function this.UniWebViewMgr:SetOrientationDelayTime(delayTime) end

---设置 WebView 是否显示工具栏
---@param showToolbar boolean 是否显示
function this.UniWebViewMgr:SetShowToolbar(showToolbar) end

---设置 WebView 的物理后退按钮是否生效
---@param enabled boolean 是否生效
function this.UniWebViewMgr:SetBackBtnEnabled(enabled) end

---设置 WebView 界面关闭的回调函数
---@param onWebViewClosed fun() 关闭回调
function this.UniWebViewMgr:SetOnShouldClose(onWebViewClosed) end

---设置 WebView 开始加载页面的回调函数
---@param onPageStarted fun(url:string) 开始加载回调
function this.UniWebViewMgr:SetOnPageStarted(onPageStarted) end

---设置 WebView 加载进度更改的回调函数
---@param onPageProgressChanged fun(url:string,progress:number) 进度更改回调
function this.UniWebViewMgr:SetOnPageProgressChanged(onPageProgressChanged) end

---设置 WebView 页面加载完成的回调函数
---@param onWebViewLoaded fun(code:number, url:string) 加载完成回调
function this.UniWebViewMgr:SetOnPageFinished(onWebViewLoaded) end

---设置 WebView 与 Unity 通信的消息接收回调
---@param onMessageReceived fun(scheme:string, path:string, args:table<string, string>) 消息接收回调
function this.UniWebViewMgr:SetOnMessageReceived(onMessageReceived) end

---Unity和UniWebView通信
---@param javascript string @游戏调用的js函数  eg."startGame(1);"
---@param onExeScriptBack fun(rawMessage:string) @执行完成回调
function this.UniWebViewMgr:EvaluateJavaScript(javascript, onExeScriptBack) end

---设置WebView页面透明度
---@param alpha number @透明度  默认1.0   0.0f:网页背景透明 
function this.UniWebViewMgr:SetAlpha(alpha) end

---设置WebView背景颜色
---@param colorStr string @颜色值  例如：#ffffffff 
function this.UniWebViewMgr:SetBackgroundColor(colorStr) end

---是否在加载的是否显示旋转菊花
---@param isShow boolean @是否显示
function this.UniWebViewMgr:SetShowSpinnerWhileLoading(isShow) end

---设置正在加载提示文本
---@param spinnerStr string @显示文本
function this.UniWebViewMgr:SetSpinnerText(spinnerStr) end

---打开WebView
---@param url string @网址
---@param isAutoShow boolean @是否自动显示 当缺省时为true
function this.UniWebViewMgr:OpenUrl(url, isAutoShow) end

---设置加载url显示或者隐藏
---@param isShow boolean @是否显示
function this.UniWebViewMgr:ShowOrHide(isShow) end

---重新加载当前url
function this.UniWebViewMgr:Reload() end

---清理缓存
function this.UniWebViewMgr:CleanCache() end

---刷新显示框
function this.UniWebViewMgr:UpdateFrame() end

---关闭WebView
function this.UniWebViewMgr:CloseWebView() end

---创建单独UniWebView实例
---@return UniWebViewBridge
function this.UniWebViewMgr:CreateInstance() end

---设置是否使用引擎自动战斗逻辑
---@param isUseEngineAutoFight boolean
function this:SetIsUseEngineAutoFight(isUseEngineAutoFight) end

---设置角色头顶部位的初始化缩放值
---@param heardPart EHeadPart
---@param scaleX number
---@param scaleY number
---@param scaleZ number
function this.Head:SetHeadPartScale(heardPart, scaleX, scaleY, scaleZ, childScale) end

---设置角色头顶部位的初始化缩放值
---@param heardPart EHeadPart
---@param fontsize number
function this.Head:SetHeadPartFontSize(heardPart, fontsize) end

---设置角色头顶部位的初始化位置
---@param heardPart EHeadPart
---@param x number
---@param y number
---@param z number
function this.Head:SetHeadPartPosition(heardPart, x, y, z) end

---设置怪物头顶名字x轴偏移
---@param offsetX number
function this.Head:SetMonsterHeadNameOffsetX(offsetX) end

---设置角色头顶图片信息
---@param rid EHeadPart
---@param headPart EHeadPart
---@param index ERoleHeadSprite
---@param atlasName string
---@param spriteName string
---@param fillAmount string
---@param scaleX number
---@param scaleY number
---@param scaleZ number
function this.Head:SetHeadPartSprite(rid, headPart, index, atlasName, spriteName, fillAmount, scaleX, scaleY, scaleZ) end

---设置角色头顶文字信息
---@param rid number 角色 ID
---@param headPart EHeadPart 部位
---@param content string 内容
---@param fontSize number 字体大小
---@param fontRes string 字体资源
function this.Head:SetHeadPartLabel(rid, headPart, content, fontSize, fontRes) end

---设置是否开启全局渲染队列自定义
---@param b boolean 是否开启
function this.Head:SetGlobalRenderQueueOpen(b) end

---获取全局渲染队列配置
---@return table 渲染队列数据
function this.Head:GetGlobalRenderQueueConfig() end

---开关设置头顶HUD减少相机近大远小的影响
---@param isOpen boolean 是否开启 (可选，默认 false)
---@param fixedScreenSize number 固定屏幕大小 (可选，默认 0.025)
---@param scaleClamp1 number 缩放下限 (可选，默认 1)
---@param scaleClamp2 number 缩放上限 (可选，默认 2)
---@param globalScale number 全局缩放 (可选，默认 1)
function this.Head:SetGlobalIgnoreScaleOpen(isOpen, fixedScreenSize, scaleClamp1, scaleClamp2, globalScale) end

---设置类型头顶HUD减少相机近大远小的影响
---@param eHeadType_IgnoreScale EHeadType_IgnoreScale 忽略缩放类型
---@param isAdd boolean 是否添加 (可选，默认 false)
function this.Head:SetGlobalAddIgnoreScaleByType(eHeadType_IgnoreScale, isAdd) end

---移除角色头顶信息
---@param rid number 角色 ID
function this.Head:RemoveAllHeadPart(rid) end

---设置 CSLabel 单个属性
---@param component CSLabel CSLabel 组件
---@param propertyType EHeadPropType_CSLabel 属性枚举
---@param value any 属性值
---@return boolean 是否设置成功
function this.Head.CSLabel:SetProperty(component, propertyType, value) end

---获取 CSLabel 单个属性
---@param component CSLabel CSLabel 组件
---@param propertyType EHeadPropType_CSLabel 属性枚举
---@return any 属性值
function this.Head.CSLabel:GetProperty(component, propertyType) end

---设置 CSSpriteMesh 单个属性
---@param component CSSpriteMesh CSSpriteMesh 组件
---@param propertyType EHeadPropType_CSSpriteMesh 属性枚举
---@param value any 属性值
---@return boolean 是否设置成功
function this.Head.CSSpriteMesh:SetProperty(component, propertyType, value) end

---获取 CSSpriteMesh 单个属性
---@param component CSSpriteMesh CSSpriteMesh 组件
---@param propertyType EHeadPropType_CSSpriteMesh 属性枚举
---@return any 属性值
function this.Head.CSSpriteMesh:GetProperty(component, propertyType) end

---设置 CSMultiLabel 单个属性
---@param component CSMultiLabel CSMultiLabel 组件
---@param propertyType EHeadPropType_CSMultiLabel 属性枚举
---@param value any 属性值
---@return boolean 是否设置成功
function this.Head.CSMultiLabel:SetProperty(component, propertyType, value) end

---获取 CSMultiLabel 单个属性
---@param component CSMultiLabel CSMultiLabel 组件
---@param propertyType EHeadPropType_CSMultiLabel 属性枚举
---@return any 属性值
function this.Head.CSMultiLabel:GetProperty(component, propertyType) end

---设置 CSSellerMultiLabel 单个属性
---@param component CSSellerMultiLabel CSSellerMultiLabel 组件
---@param propertyType EHeadPropType_CSSellerMultiLabel 属性枚举
---@param value any 属性值
---@return boolean 是否设置成功
function this.Head.CSSellerMultiLabel:SetProperty(component, propertyType, value) end

---获取 CSSellerMultiLabel 单个属性
---@param component CSSellerMultiLabel CSSellerMultiLabel 组件
---@param propertyType EHeadPropType_CSSellerMultiLabel 属性枚举
---@return any 属性值
function this.Head.CSSellerMultiLabel:GetProperty(component, propertyType) end

---设置 CSSpriteRender 单个属性
---@param component CSSpriteRender CSSpriteRender 组件
---@param propertyType EHeadPropType_CSSpriteRender 属性枚举
---@param value any 属性值
---@return boolean 是否设置成功
function this.Head.CSSpriteRender:SetProperty(component, propertyType, value) end

---获取 CSSpriteRender 单个属性
---@param component CSSpriteRender CSSpriteRender 组件
---@param propertyType EHeadPropType_CSSpriteRender 属性枚举
---@return any 属性值
function this.Head.CSSpriteRender:GetProperty(component, propertyType) end

---同地图寻路目标点是否可到达
---@param targetDot Dot2 目标点
---@param maxSearAStarCount number 可选,默认值100,最大搜索A*次数,越大越耗时
---@return boolean 是否可到达
function this.Map:CommonMapFindPathIsArrive(targetDot, maxSearAStarCount) end

---切换 GM 日志状态
function this.GM:ToggleGMLog() end

---切换显示 GM 面板
function this.GM:ToggleOpenGMPanel() end

---切换显示 UI 点击信息
function this.GM:ToggleShowClickUI() end

---是否所有 GM 日志都已开启
---@return boolean
function this.GM:IsAllGMLogOpen() end

---是否开启了显示点击 UI
---@return boolean
function this.GM:IsShowClickUIOpen() end

---设置自动战斗都查找目标位置使用挂机点位置
---@param isUseHookPointSelectionTarget boolean 是否使用挂机点
function this.AutoFight:SetIsUseHookPointSelectionTarget(isUseHookPointSelectionTarget) end

---设置自动战斗非和平模式下优先攻击玩家
---@param isNotPeacePkModePriorityAttackPlayer boolean 是否优先攻击玩家
function this.AutoFight:SetIsNotPeacePkModePriorityAttackPlayer(isNotPeacePkModePriorityAttackPlayer) end

---设置是否判断可以移动过去拾取道具
---@param isDecideCanMoveToAutoPickUpItem boolean 是否判断移动
function this.AutoFight:SetIsDecideCanMoveToAutoPickUpItem(isDecideCanMoveToAutoPickUpItem) end

---设置自动战斗是否可以使用普攻
---@param autoFightIsUseNormalAttack boolean 是否使用普攻
function this.AutoFight:SetAutoFightIsUseNormalAttack(autoFightIsUseNormalAttack) end

---设置离开游戏是否关闭自动挂机
---@param isLeaveGameStopAutoHook boolean 是否停止挂机
function this.AutoFight:SetIsLeaveGameStopAutoHook(isLeaveGameStopAutoHook) end

---请求结束自动挂机
function this.AutoFight:ReqEndAutoPlayGameMessage() end

---请求开始自动挂机
function this.AutoFight:ReqStartAutoPlayGameMessage() end

---设置点击地面是否关闭自动挂机
---@param isClickFloorStopHook boolean 是否点击地面停止
function this.AutoFight:SetIsClickFloorStopHook(isClickFloorStopHook) end

---设置角色挂机点位置
---@param x number 坐标 X
---@param z number 坐标 Z
function this.AutoFight:SetHookPoint(x, z) end

---获取默认设置数据
---@return table
function this:GetDefaultSettingData() end

---启用/禁用 PC 操作平台
---@param bool boolean 是否启用
function this:SetPCPlatform(bool) end

---绑定 PC 按键响应
---@param name string 标识
---@param keyCode UnityEngine.KeyCode 按键码
---@param callBack function 回调函数
function this.PCOperation:BindKeyMap(name, keyCode, callBack) end

---设置 PC 右键怪物时是否不触发连续攻击
---@param isLoop boolean true：只攻击一次
function this.PCOperation:SetRightClickMonsterLoop(isLoop) end

---设置 PC 开始使用指定技能持续攻击当前目标, 无选中目标时不生效
---@param skillId number 技能 ID
function this.PCOperation:LoopAttack2SingleTarget(skillId) end

---PC 关闭持续攻击当前目标
function this.PCOperation:StopLoopAttack2SingleTarget() end

---PC 设置右键怪物无选中技能时，是否使用普通攻击
---@param set boolean 是否使用
function this.PCOperation:SetNoSelectSkillUseCommonAttack(set) end

---PC 设置右键空地是否移动
---@param isMove boolean 是否移动
function this.PCOperation:SetPcRightClickEmptyMove(isMove) end

---设置是否渲染地图格子
---@param isRenderMapGrid boolean 是否渲染
function this.Map:SetRenderMapGrid(isRenderMapGrid) end

---设置替换引擎方法的逻辑
---@param funcType EReplaceEngineFunc 替换类型
---@param func function 替换函数
function this:SetReplaceEngineFunc(funcType, func) end

---获取职业配置表数据
---@param career CommonProtos.Career 职业信息
---@return cfg_career_column @职业配置表
function this:GetCareerTbl(career) end

---获取系统总内存大小 (KB, Android 和 iOS 有效)
---@return number 内存大小，单位 KB
function this:GetSystemTotalMemorySize() end

---设置外部默认字体贴图修改成Point模式，字会更尖锐
---@param v string 字体资源路径
function this:SetOutDefaultFontToPoint(v) end

---获取与目标的关系类型
---@param targetId number 目标 ID
---@return ERelationshipType
function this:GetERelationshipType(targetId) end

---设置最大飘字显示数量
---@param maxHurtLableLimitCount number 最大数量 (可选，默认 15)
function this:SetMaxHurtLableLimitCount(maxHurtLableLimitCount) end

---设置角色头顶血条动画播放速度（值越小速度越快）
---@param hpAnimationSpeed number 速度值
function this.Head:SetHpAnimationSpeed(hpAnimationSpeed) end

---设置与 NPC 交谈内容
---@param rid number 角色 ID
---@param content string 交谈内容 (为空则回收)
function this.Head:SetNpcTalk(rid, content) end

---当前是否有任何操作输入
---@return boolean
function this:IsAnyOperation() end

---设置 Loading 面板延迟关闭时间
---@param time number | string 延迟时间
function this:SetDelayTime2LoadingPanel(time) end

---设置地图渲染地块大小和地图视口大小
---@param blockWidth number @地图地块宽,nil或者值不大于0表示不改变
---@param blockHeight number @地图地块高,nil或者值不大于0表示不改变
---@param viewWidth number @地图视口宽,nil或者值不大于0表示不改变
---@param viewHeight number @地图视口高,nil或者值不大于0表示不改变
function this:SetTerrainBlockAndViewSize(blockWidth, blockHeight, viewWidth, viewHeight) end

---设置点击释放技能是否开启自动战斗（默认为 true, 不会改变战斗状态）
---@param isClickReleaseSkillStartAutoHook boolean 是否开启
function this:SetIsClickReleaseSkillStartAutoHook(isClickReleaseSkillStartAutoHook) end

---设置怪物名字颜色(适用怪物，召唤兽)
---@param rid number 角色 ID
---@param color string 颜色字符串 (如 "#FFFFFF")
function this.Head:SetMonsterNameColor(rid, color) end

---设置角色头顶信息的缩放
---@param rid number 角色 ID
---@param scaleX number X 缩放
---@param scaleY number Y 缩放
---@param scaleZ number Z 缩放
function this.Head:SetHeadScale(rid, scaleX, scaleY, scaleZ) end

---修改预制体中的图片精灵
---@param go UnityEngine.GameObject 对象
---@param path string 子物体路径
---@param atlasName string 图集名称
---@param spriteName string 精灵名称
---@param type any 组件类型 (可选)
function this:ModifyPrefabSprite(go, path, atlasName, spriteName, type) end

---设置进入副本是否开启自动战斗
---@param isEnterCopyMapStartAutoHook boolean 是否开启
function this.AutoFight:SetIsEnterCopyMapStartAutoHook(isEnterCopyMapStartAutoHook) end

---获取是否开启"全部拾取"开关
---（对应设置界面中的一键全拾选项，开启后拾取所有掉落物）
---@return boolean 返回 true 表示已开启全部拾取
function this:GetPickAllDropItem() end

---获取当前是否处于游戏场景中
---（用于过滤非场景环境下不应执行的逻辑，如城镇、副本外等）
---@return boolean 返回 true 表示角色当前在场景内
function this:GetIsScene() end

---获取玩家设置的自动拾取范围（格数）
---（为 0 或 nil 时表示不限制范围，拾取全屏可见道具）
---@return number|nil 拾取范围格数，未设置时返回 nil 或 0
function this:GetSettingPickRange() end

---获取是否开启模糊拾取开关
---（开启后会按 vaguePickList 中的关键词模糊匹配物品名称进行拾取）
---@return boolean 返回 true 表示已开启模糊拾取
function this:GetVaguePickFlag() end

---发送拾取地图掉落物的网络请求
---@param itemId number 掉落物的服务器唯一 ID
---@param type number  拾取类型（0 走过去拾取 1 范围拾取）
function this:ReqPickUpMapItemMessage(itemId, type) end

---获取自动战斗技能优先级列表
---（列表元素为 skillId，顺序即为行为树中技能的释放优先级）
---@return number[] 技能 ID 数组，按优先级从高到低排列
function this:GetAutoUseSkillList() end

---获取回归挂机点的等待时间（秒）
---@return number 等待时长，单位：秒
function this:GetComebackHookPointTime() end

---获取角色当前设置的挂机点坐标
---@return Dot2 挂机点的地图坐标{x, y}
function this.AutoFight:GetHookPoint() end

---获取是否需要回归挂机点
---@return boolean 返回 true 表示当前应执行回归挂机点逻辑
function this.AutoFight:GetIsComebackHookPoint() end

---保存挂机设置
function this:SaveHookSetting() end

---设置主角守护是否拾取道具
---@param isCanPickUpItem @是否开启自动拾取功能
function this:SetMeGuardIsCanPickUp(isCanPickUpItem) end

---设置是否显示攻击范围特效
---@param isShowAttackRangeEffect @是否显示攻击范围特效
function this:SetIsShowAttackRangeEffect(isShowAttackRangeEffect) end

--设置是否开启自动战斗拾取功能
---@param isOpenAutoFightPickUpItem @是否开启自动拾取功能
function this.AutoFight:SetIsOpenAutoFightPickUpItem(isOpenAutoFightPickUpItem) end

---守护移动到目标位置
---@param rid number @角色id
---@param x number @x轴坐标
---@param y number @y轴坐标
---@param arriveFunc function @到达目标点回调函数
function this:GuardMoveToPoint(rid, x, y, arriveFunc) end

---根据传入特效和索引值以及参数，设置特效shader参数
---@param go GameObject 特效对象(必须有SmdimportCollect脚本)
---@param index number Renderer第几个材质球
---@param property table<number,table<number,table<number,string>>> 材质球shader上设置的参数(需要组装,参照流光配置)
function this:SetObjMatParam(go, index, property) end

---获取提示广播消息提示列表
---@return table<number,{cond:string,stack:string}>
function this.message:GetMessData() end

---清理提示广播消息提示列表（处理完后清理）
function this.message:ClearMessData() end

---获取跑马灯广播消息列表
---@return table<number,{cond:string,stack:string}>
function this.message:GetHorseRaceLampMessData() end

---清理跑马灯广播消息列表（处理完后清理）
function this.message:ClearHorseRaceLampMessData() end

---获取攻击目标死亡是否停止攻击
---@return boolean
function this.AutoFight:GetIsTargetDieStopAtk() end

---获取挂机设置中已学习的公共伤害技能,群体技能集合
function this.SettingData:GetGroupSave() end

---获取挂机设置中已学习的buff技能集合
---@return table
function this.SettingData:GetBuffSave() end

---获取挂机设置中已学习的召唤技能集合
---@return table
function this.SettingData:GetSummonSave() end

---刷新挂机设置技能
---@return table
function this.SettingData:RefreshSkillByGroup() end

---获取自动战斗初始点（帅选目标使用）
---@return boolean
function this.AutoFight:GetStartingPoint() end

---获取自动战斗攻击范围
---@return number
function this.AutoFight:GetAttackRange() end

---获取自动战斗攻击目标
---@return number
function this.AutoFight:GetAutoFightTargetId() end

---设置自动战斗攻击目标
---@param targetId number
function this.AutoFight:SetAutoFightTargetId(targetId) end

---设置自动战斗技能释放结果类型
---@param releaseSkillError ESkillReleaseError
function this.AutoFight:SetAutoFightReleaseSkillError(releaseSkillError) end

function this.Transform:Get(target) end

function this.Transform:GetGameObject(target) end

function this.Transform:GetPosition(target) end

function this.Transform:SetPosition(target, x, y, z) end

function this.Transform:GetLocalPosition(target) end

function this.Transform:SetLocalPosition(target, x, y, z) end

function this.Transform:GetLocalScale(target) end

function this.Transform:SetLocalScale(target, x, y, z) end

function this.Transform:GetEulerAngles(target) end

function this.Transform:SetEulerAngles(target, x, y, z) end

function this.Transform:GetLocalEulerAngles(target) end

function this.Transform:SetLocalEulerAngles(target, x, y, z) end

function this.Transform:GetParent(target) end

function this.Transform:SetParent(target, parent, worldPositionStays) end

function this.Transform:SetActive(target, isActive) end

function this.Transform:IsActiveSelf(target) end

---元变量实现
---获取元变量的值
---@param key string | EMetaVarGetKey 元变量键名（通常传枚举名字符串）
---@param param1 any 参数1
---@param param2 any 参数2
---@param ... any 额外参数
---@return any 元变量值
function this:GetMetaValue(key, param1, param2, ...) end

---设置元变量的值
---@param key string | EMetaVarSetKey 元变量键名（通常传枚举名字符串）
---@param param1 any 参数1
---@param param2 any 参数2
---@param ... any 额外参数
function this:SetMetaValue(key, param1, param2, ...) end

---打印所有元变量Key
function this:PrintMetaKey() end

---打印所有能获取的元变量
function this:PrintAllMetaValue() end

---检查条件组合是否满足
---@param conditionStr string 条件组合（示例：CheckLevel>=90&(CheckJob=1|CheckJob=2)）
---@return boolean 是否满足
function this:CheckCondition(conditionStr) end

---获取颜色配置数据
---@param colorID number @颜色表配置ID
---@return cfg_color_column @颜色配置数据
function this:GetColorCfg(colorID) end

---关闭聊天界面 (手机端)
function this:CloseChatUI() end

---打开聊天界面 (手机端)
---@param _type EChatChannelType|number 初始频道类型 (空或者-1综合，2世界，6附近，4战盟，7队伍，0系统)
---@return UIKmlLuaPanelBase 界面对象
function this:OpenChatUI(_type) end

---设置聊天综合频道不显示的聊天类型
---@param close_list number[] 屏蔽的频道类型列表 例如{9,8}表示不显示好友和私聊消息，详细类别可查看EChatChannelType
function this:SetCloseChatType(close_list) end

---发送聊天消息
---@param channel number 频道类型 (0:系统, 1:战斗, 2:世界, 3:当前, 4:战盟, 5:招募, 6:附近, 7:队伍, 8:私聊, 9:好友)
---@param message string 消息内容
---@param toRid number 私聊目标角色 ID
---@param lidList table 道具链接列表
function this:SendChat(channel, message, toRid, lidList) end

---关闭添加好友界面
---@return boolean 是否成功关闭
function SL:CloseAddFriendUI() end

---打开添加好友界面
---@return UIKmlLuaPanelBase 界面对象
function SL:OpenAddFriendUI() end

---打开黑名单界面
---@return UIKmlLuaPanelBase 界面对象
function SL:OpenAddBlackListUI() end

---屏幕坐标转换为世界坐标
---@param screenX number 屏幕 X 坐标
---@param screenY number 屏幕 Y 坐标
---@return Vector3 世界坐标
function SL:ConvertScreen2WorldPos(screenX, screenY) end

---世界坐标转换为屏幕坐标
---@param worldX number 世界 X 坐标
---@param worldY number 世界 Y 坐标
---@return Vector2 屏幕坐标
function SL:ConvertWorldPos2Screen(worldX, worldY) end

---在场景中进行射线检测
---@param x number 屏幕 X 坐标
---@param y number 屏幕 Y 坐标
---@param layerMask number 碰撞层掩码
---@return UnityEngine.GameObject,number,number,number 包括碰撞物体、碰撞点 X 坐标、碰撞点 Y 坐标、碰撞点 Z 坐标
function SL:RaycastScene(x, y, layerMask) end

---获取视野内的怪物数量
---@param noPetOfMainPlayer boolean @true不包含自己的宠物,反之包含
---@param noPetOfNetPlayer boolean @false包含别人的宠物,反之不包含
---@return number 怪物数量
function SL:FindMonsterInCurrViewField(noPetOfMainPlayer, noPetOfNetPlayer) end

---获取视野内的玩家数量
---@param noMainPlayer boolean 是否排除自己,false 包含自己,反之不包含
---@return number 玩家数量
function SL:FindPlayerInCurrViewField(noMainPlayer) end

---请求读取邮件
---@param mailIds table 邮件ID列表
function this:RequestReadMail(mailIds) end

---一键提取所有邮件附件
function this:GetAllMailItems() end

---提取单封邮件附件
---@param mailId number 邮件ID
function this:GetMailItems(mailId) end

---请求提交任务
---@param taskId number 任务 ID
---@param multiple number 奖励倍数 (可选)
function this:ReqSubmitTaskMessage(taskId, multiple) end

---接取任务
---@param taskId number @任务ID
function this:ReqAcceptTaskMessage(taskId) end

---打开背包界面
function this:OpenKLBagPanel() end

---打开属性加点界面
function this:OpenKLAttrPanel() end

---打开快捷装备提示 UI
function this:OpenUseEquipBagTipsUI() end

---   自动刷新数据，无需手动维护。
---3. 外部可通过 SL:OpenActivityTimingTask() / SL:CloseActivityTimingTask() 等接口
---   动态添加或移除活动提示，面板内部通过 LUA_EVENT_ACTIVITYTIMETIPS_* 系列事件接收。
---4. 面板内包含「查看全天活动」按钮，可扩展跳转到全天活动总览界面。
---
---## 调用注意事项
---1. 【前置条件】仅在主界面显示时有效：内部通过 SL:GetIsShowMainUI() 判断，
---   若当前主界面处于隐藏状态（如战斗界面、全屏面板打开时），
---   调用本函数**不会打开面板**，静默跳过。
---2. 【重复调用安全】面板内 id2ActInfos 对同一 activityId 做了去重，
---   重复调用不会产生重复数据项。
---3. 【生命周期】面板在 KLActivityTipPanel:RegistEvents() 中注册了多个事件监听，
---   面板关闭不会被自动清理回调。面板关闭（CloseBtnClick）仅调用 UIPanel_Close，
---   下一次重新打开时 Init() 会重新初始化所有数据表和事件注册。
---4. 【数据依赖】面板运行依赖 cfg_activity_rule 配置表、
---   DataManager.activityInfo.activityList / announceList 服务器数据，
---   在未登录或数据未就绪时调用，面板打开后列表为空。
---5. 【与其他提示面板的关系】本面板与 KLBagTipsPanel（快捷装备提示）、
---   KLPopoverPanel（气泡提示）属同一 "Preview" 模块下的三个提示面板，
---   可同时存在，相互独立。
function this:OpenActivityTipsUI() end

---打开气泡提示 UI
function this:OpenBubbleTipsUI() end

---添加气泡提醒
---@param id number cfg_popover 表 ID
function this:AddBubbleTips(id) end

---删除气泡提醒
---@param id number cfg_popover 表 ID
function this:DelBubbleTips(id) end

---开启限时活动计时提示
---@param id number cfg_activity_rule 表 ID
---@param name string 活动名称
---@param icon string 活动图标资源名
---@param type number 提示类型 (0:预告, 1:进行中)
---@param endtime number 结束时间戳 (毫秒)
function this:OpenActivityTimingTask(id, name, icon, type, endtime) end

---关闭指定 ID 的限时活动提示
---@param id number cfg_activity_rule 表 ID
function this:CloseActivityTimingTask(id) end

---关闭所有限时活动提示
function this:CloseActivityTimingTaskAll() end

---根据类型关闭限时活动提示
---@param type number 提示类型 (0:预告, 1:进行中)
function this:CloseActivityTimingTaskByType(type) end

---检查是否需要显示装备快捷提示
---@param bagItem BagProtos.BagItem 背包物品数据
---@return boolean 是否显示
function this:CheckIsShowEquipBoxTip(bagItem) end

---检查是否需要显示技能书快捷提示
function this:CheckIsShowSkillBoxTip() end

---检查是否需要显示属性点快捷提示
---@return boolean 是否显示
function this:CheckIsShowAttributeBoxTip() end

---显示本地公告
---@param widget UIKmlLuaControlHandler 父节点处理器
---@param data table 公告数据 (Msg, FColor, FSize, X, Y, Count, Time)
function SL:ShowLocalNoticeByType(widget, data) end

---释放技能
---@param skillID number 技能 ID
function SL:RequestLaunchSkill(skillID) end

---技能释放表现
---@param rid number 释放者角色唯一 ID,如果是主角，会同时发送战斗技能消息包
---@param skillId number 技能 cfg_item的ID
---@param targetId number 目标角色唯一 ID,没有目标的话可不填
---@param targetCoord Dot2 目标坐标 
---@param targetIds table 多个目标 ID 列表，有多个目标时填写（可选）
---@param skillItemCfgId number 技能物品配置 cfg_item ID（可选）
---@param caromCfgId number 连击配置 ID（无效字段）
---@param isComboSkill boolean 是否连击技能（可选）
---@param isFightResult boolean 是否是战斗回包调用（默认true），一般不用填写
function SL:ReleaseSkill(rid, skillId, targetId, targetCoord, targetIds, skillItemCfgId, caromCfgId, isComboSkill, isFightResult) end

---为角色添加技能
---@param rid number 角色唯一 ID
---@param skillId number 技能 ID
---@param level number 技能等级
function SL:AddSkill(rid, skillId, level) end

---请求创建队伍
function SL:RequestCreateTeam() end

---请求拒绝组队邀请
---@param leaderRid number @队长角色ID
function SL:RequestRefuseTeamInvite(leaderRid) end

---请求同意组队邀请
---@param leaderRid number 队长角色ID
function SL:RequestAgreeTeamInvite(leaderRid) end

---请求申请入队
---@param teamID number 队伍 ID
function SL:RequestApplyAgree(teamID) end

---请求获取入队申请/邀请列表
function SL:RequestApplyData() end

---请求获取附近队伍列表
function SL:RequestNearTeam() end

---请求退出队伍
function SL:ReqQuitTeam() end

---请求发送组队邀请
---@param rid number 目标角色 ID
---@param type number 邀请类型，默认为 1
function SL:ReqSendTeamInvitation(rid, type) end

---请求同意入队申请
---@param rid number @申请者角色ID
function SL:ReqAgreeReplyApply(rid) end

---请求拒绝入队申请
---@param rid number @申请者角色ID
function SL:ReqRefuseReplyApply(rid) end

---请求将成员踢出队伍
---@param rid number 目标角色 ID
---@param type number 踢出类型，默认为 1
function SL:ReqKickOutMember(rid, type) end

---请求转移队长权限
---@param rid number 目标角色 ID
---@param type number 转移类型，默认为 1
function SL:ReqChangeCaptain(rid, type) end

---请求获取附近玩家列表
---@param type number 列表类型，默认为 1
function SL:ReqPlayerList(type) end

---请求获取队伍信息
function SL:ReqTeamInfo() end

---请求清空所有申请/邀请列表
function SL:ReqClearAllRequestList() end

---检查进入地图的等级限制
---@param mapMoveId number cfg_mapMove 表 ID
---@return boolean 是否满足等级条件
function SL:MapLevelConditionCheck(mapMoveId) end

---检查进入地图的会员等级限制
---@param mapid number cfg_map_info 表 ID
---@return boolean 是否满足会员条件
function SL:MapVipCondtitionCheck(mapid) end

---传送到地图传送点
---@param mapId number 目标地图 cfg_map_info ID
---@param line number 目标分线 ID (可选，默认为 1)
---@param mapMoveId number cfg_mapMove 表 ID (可选)
function SL:MapTransfer(mapId, line, mapMoveId) end

---传送到指定地图坐标
---@param mapMoveId number 根据type类型填入地图Id
---@param x number 目标 X 坐标
---@param y number 目标 Y 坐标
---@param range number 传送半径
---@param type number 传送类型 1 自定义坐标传送 mapMoveId取cfg_map_info中的id 2 带坐标快捷指令传送 mapMoveId取cfg_mapMove中的id
---@param line number 目标分线 ID
function SL:MapTransferXY(mapMoveId, x, y, range, type, line) end

---获取目标地图名称
---@param mapId number 地图 ID
---@return string 地图名称
function SL:GetDestinationMapName(mapId) end

---获取装备相关数值
---@param key string EMetaVarGetKey 中的键名
---@param param1 any 参数1
---@param param2 any 参数2
---@return any 装备数值
function this:GetEquipValue(key, param1, param2, ...) end

---根据位置获取物品信息
---@param equip_pos string 装备位置 ("bag"-背包 "equip"-装备，"depot"-仓库，"mail"-邮件，"chat"-聊天，"otherEquip"-其他人的装备)
---@param cfgId number 物品配置 ID（可填nil）
---@param id number 物品唯一 ID
---@return CommonProtos.Item 物品数据
function this:GetPosItemInfo(equip_pos, cfgId, id) end

---根据装备唯一id获取装备的穿戴栏和装备位
---@param id number @装备唯一id
---@return number,number @cfg_activity_rule表id（穿戴栏）,装备位
function this:GetEquipWearBarIdPos(id) end

---获取物品在背包中的索引
---@param id number 物品唯一 ID
---@return number 背包索引
function this:GetBagIndex(id) end

---装备 Tips 界面打开
---@param _equip_pos string 装备位置
---@param _cfgId number 物品配置 ID
---@param _id number 物品唯一 ID
---@param _info any 额外信息
---@param isMulti boolean 是否允许多开
---@param callback function 回调函数
---@return UIKmlLuaPanelBase 界面对象
function SL:OpenEquipTips(_equip_pos, _cfgId, _id, _info, isMulti, callback) end

---装备对比 Tips 界面打开
---@param _cfgId number 物品配置 ID
---@param _id number 物品唯一 ID
---@param _info any 额外信息
function SL:OpenEquipTipsComparsion(_cfgId, _id, _info) end

---道具 Tips 界面打开
---@param _equip_pos string 物品位置
---@param _cfgId number 物品配置 ID
---@param _id number 物品唯一 ID
---@param _count number 数量
---@param _info any 额外信息
---@param isMulti boolean 是否允许多开
---@param callback function 回调函数
---@return UIKmlLuaPanelBase 界面对象
function SL:OpenItemTips(_equip_pos, _cfgId, _id, _count, _info, isMulti, callback) end

---打开战盟界面
function SL:OpenUnion() end

---关闭所有 Tips
function this:CloseTips() end

---打开物品 Tips (自动识别装备或道具)
---@param _equip_pos string 物品位置
---@param _cfgId number 物品配置 ID
---@param _id number 物品唯一 ID
---@param _count number 数量
---@param item any 物品对象
---@param info any 额外信息
---@param isMulti boolean 是否允许多开
---@param callback function 回调函数
---@return UIKmlLuaPanelBase 界面对象
function SL:OpenTips(_equip_pos, _cfgId, _id, _count, item, info, isMulti, callback) end

---检查怪物是否显示血条
---@param _cfgId number 怪物配置 ID(cfg_monster表id)
---@return boolean 是否显示
function SL:MonsterIsShowHP(_cfgId) end

---打开 Boss 血条
---@param _id number Boss 实例 ID(在视野中的怪物)
function SL:OpenBossHp(_id) end

---关闭 Boss 血条
function SL:CloseBossHp() end

---获取当前地图怪物状态
---@return table<number,MapProtos.MonsterStatus> 怪物状态数据
function SL:GetMapMonsterStatus() end

---获取 Boss 掉落组所有数据
---@param cfgId number Boss 配置 ID
---@return table 掉落数据列表
function SL:GetBossALlDrop(cfgId) end

---主界面引导入口展开/收起
---@param isExpand boolean 是否展开
function SL:OpenGuideEnter(isExpand) end

---显示技能 Tips
---@param skillId number 技能 ID
---@param skillLevel number 技能等级
---@return UIKmlLuaPanelBase 界面对象
function this:ShowSkillTip(skillId, skillLevel) end

---请求购买商城商品
---@param goodsId number 商品 ID，cfg_shopMall中的ID
---@param count number 购买数量
function this:RequestBuyShopMallGoods(goodsId, count) end

---请求商城商品列表信息
---@param tabId number 页签 ID
function this:RequestShopMallGoodsInfo(tabId) end

---获取装备上附带的技能信息
---@param equip CommonProtos.Item 装备数据
---@return table 技能信息列表
function this:GetEquipSkills(equip) end

---设置被屏蔽的功能列表
---@param panelList string[] 界面路径列表
function this:KLSetBlockedFunction(panelList) end

---检查指定功能是否被屏蔽
---@param panelName string 界面路径
---@return boolean 是否屏蔽
function this:IsBlockedFunction(panelName) end

---打开 NPC 对话框
---@param content string 对话内容
---@return UIKmlLuaPanelBase 界面对象
function this:OpenNPCTalk(content) end

---禁用到达 NPC 时自动完成对话任务的功能
function this:BanAutoFinishNpcTalkTask() end

---NPC 名称位置偏移
---@param cfgid number @cfg_npclist 配置 ID
---@param x number @X 轴偏移
---@param y number @Y 轴偏移
function this:NpcNameOffest(cfgid, x, y) end

---创建怪物模型
---@param uiParent UIKmlLuaControlHandler 父节点处理器
---@param cfgId number 怪物配置 ID
---@param scale table 缩放比例 {x, y, z}
---@param rotation table 旋转角度 {x, y, z}
---@param callBack function 创建完成回调
---@return UIModel 模型对象
function this:CrateMonsterModel(uiParent, cfgId, scale, rotation, callBack) end

---退出选角界面
function this:QuitSelectRoleUI() end

---退出游戏
function this:QuitGame() end

---恢复默认基础设置
function this:ReplyDefaultBaseSetting() end

---恢复默认显示设置
function this:ReplyDefaultShowSetting() end

---恢复拾取设置
function this:ReplyDefaultPickUpSetting() end

---复制邀请码到剪贴板
---@param code string 邀请码内容
function this:CopyInviteCode(code) end

---弹出获得奖励弹窗
---@param data table 奖励数据列表 {cfgId, count}
---@param type number 弹窗类型 (0:奖励领取, 1:任务奖励)
---@param atlas string 自定义标题图集 (可选)
---@param src string 自定义标题图片名 (可选)
---@param isfomat boolean 是否格式化道具数量 (可选)
function this:OpenRewardTips(data, type, atlas, src, isfomat) end

---弹出获得奖励 (基于物品列表)
---@param itemList CommonProtos.Item[] 物品数据列表
---@param type number 弹窗类型
---@param atlas string 自定义标题图集 (可选)
---@param src string 自定义标题图片名 (可选)
function this:OpenRewardTipsByItemList(itemList, type, atlas, src) end

---获取仓库物品在容器中的索引
---@param id number 物品唯一 ID
---@return number 容器索引
function this:GetDepotsIndex(id) end

---获取当前仓库打开的页码
---@return number 页码
function this:GetDepotsCurPage() end

---通过界面名获取系统功能开关信息
---@param panelName string 界面名称
---@return cfg_system_switch_column 系统功能配置数据
function this:GetSystemInfoByPanelName(panelName) end

---设置是否开启自动反击
---@param autoCounterattack boolean 是否开启
function this:SetIsAutoCounterattack(autoCounterattack) end

---执行自动反击逻辑
---@param isStart boolean 是否开始反击
function this:AutoCounterattack(isStart) end

---控制系统功能入口图标的可见性
---@param path string 图标路径
---@param isVisible boolean 是否可见
function this:ControlSystemPortalVisible(path, isVisible) end

---开启自动挂机
---@param isReq boolean 是否向服务器请求
---@param isHandCall boolean 是否手动开启
---@param attackMonsterCfgId number 目标攻击怪物配置 ID (可选)
function this:StartOnHook(isReq, isHandCall, attackMonsterCfgId) end

---暂停挂机
---@param isImmediateRecoverOnHook boolean 恢复时是否立即继续
---@param waitTime number 暂停时间 (秒)
function this:PauseOnHook(isImmediateRecoverOnHook, waitTime) end

---停止挂机
---@param isReq boolean 是否向服务器请求
---@param noStopAction boolean 是否不停止当前动作
function this:StopOnHook(isReq, noStopAction) end

---停止脚本控制的自动移动
function this:StopScriptAutoMove() end

---寻路功能 (支持跨地图传送)
---@param mapId number 目标地图 ID
---@param line number 目标分线 ID
---@param x number 目标 X 坐标
---@param y number 目标 Y 坐标
---@param arriveFunc function 到达后的回调
---@param monsterId number 寻路途中需优先攻击的怪物配置 ID (可选)
function this:Pathfinding(mapId, line, x, y, arriveFunc, monsterId) end

---执行路径搜索
---@param oldCoord table 起始坐标
---@param dstPos table 目标坐标
---@param stopRange number 停止距离
---@param stopCellCount number 停止格子数
---@param searchPath table 预设路径 (可选)
---@return boolean, table 是否到达, 路径列表
function this:SearchPath(oldCoord, dstPos, stopRange, stopCellCount, searchPath) end

---根据类型打开设置界面页签
---@param settingType number 设置页签类型  (0,基础设置，1，显示设置，3，挂机设置，4，拾取设置)
---@return UIKmlLuaPanelBase 界面对象
function this:OpenSettingPanel(settingType) end

---打开 NPC 商店界面
---@param shopId number cfg_NPCShop 表中的 ShopId
---@return UIKmlLuaPanelBase 界面对象
function this:OpenNPCShop(shopId) end

---请求 NPC 商店商品信息
---@param shopId number cfg_NPCShop 表中的 ShopId
function this:RequestNPCShopGoodsInfo(shopId) end

---设置主界面显示时是否屏蔽指定界面
---@param panelName string 界面名称
---@param isBlock boolean 是否屏蔽
function this:SetMainUIBlockDisplayUI(panelName, isBlock) end

---检查指定界面在主界面显示时是否被屏蔽
---@param panelName string 界面名称
---@return boolean 是否屏蔽
function this:IsMainUIBlockDisplayUI(panelName) end

---请求骑乘坐骑(不推荐使用一般外置会重新定义)
---@param mountId number 坐骑 ID
function this:ReqRideMount(mountId) end

---请求取消骑乘坐骑(不推荐使用一般外置会重新定义)
---@param mountId number 坐骑 ID
function this:ReqCancelRideMount(mountId) end

---请求穿戴坐骑装备
---@param rid number 角色 ID
---@param index number 坐骑装备位索引
function this:ReqPutOnMountItem(rid, index) end

---请求脱下坐骑(不推荐使用一般外置会重新定义)
---@param mountId number 坐骑 ID
function this:ReqTakeOffMount(mountId) end

---请求上马(不推荐使用一般外置会重新定义)
---@param rid number 角色 ID
---@param mountId number 坐骑 ID
---@param isHand boolean 是否手动操作
function this:ReqOnMount(rid, mountId, isHand) end

---请求下马(不推荐使用一般外置会重新定义)
---@param rid number 角色 ID
---@param mountId number 坐骑 ID
---@param isHand boolean 是否手动操作
function this:ReqDownMount(rid, mountId, isHand) end

---通用消息提示接口 (飘窗、跑马灯等)
---@param messageData table 消息数据 {id:number-配置表id,contentFromServer:boolean-是否来自服务器,content:string-内容, params:string[]-替换参数}
function this:MessageTip(messageData) end

---设置死亡时是否保持界面开启
---@param panelName string 界面路径
---@param isOpen boolean 是否保持开启
function this:KeepOpenPanel(panelName, isOpen) end

---创建活动专属掉落物品
---@param cfgId number 物品配置 ID
---@param dropId string 掉落 ID
---@param x number X 坐标
---@param y number Y 坐标
function this:CreateActivityDropItem(cfgId, dropId, x, y) end

---为玩家角色附加活动临时武器外观
---@param rid number 角色 ID
---@param cfgId number 物品配置 ID (0 为移除)
function this:AttachActivityWeapon(rid, cfgId) end

---设置地图网格阻挡点
---@param x number X 坐标
---@param z number Z 坐标
---@param isAdd boolean 是否添加/移除阻挡
function this:SetResistancePoint(x, z, isAdd) end

---将视野内的玩家模型全部替换为指定的怪物模型
---@param isToMonster boolean 是否开启替换
---@param toMonsterId table 职业对应的怪物 ID 映射表
function this:SetAllViewPlayerToMonster(isToMonster, toMonsterId) end

---触发地图格子关联的逻辑
---@param sceneId number 场景 ID
---@param x number X 坐标
---@param y number Y 坐标
---@param roleId number 角色 ID
function this:CellTrigger(sceneId, x, y, roleId) end

---发起 SDK 支付流程
---@param rechargeTbl table cfg_recharge 表配置数据
---@param count number 充值数量
---@param extraParams table 扩展参数
function this:SDKPay(rechargeTbl, count, extraParams) end

---刷新角色头顶显示信息
---@param roleId number 角色唯一 ID
function this:RefreshHead(roleId) end

---异步加载 UI 资源
---@param path string 资源路径
---@param baseUI UIKmlLuaPanelBase 所属界面对象
---@param cacheTime number 缓存时间 (秒)
function this:LoadUIAssetAsync(path, baseUI, cacheTime) end

---设置活动阵营名称列表
---@param campNameList string[] 阵营名称列表
function this:SetCampNameList(campNameList) end

---获取小黑屋信息
---@return RoleProtos.RoleDarkRoomInfoRes
function this:GetDarkRoomInfo() end

---请求：离开小黑屋
function this:ReqLeaveDarkRoomMessage() end

---设置是否显示角色称号
---@param isShowRoleTitle boolean 是否显示
function this:SetIsShowRoleTitle(isShowRoleTitle) end

---设置职业对应的默认展示模型 ID
---@param baseCareer number 基础职业 ID
---@param modelCfgId number 模型配置 ID
function this:SetRoleCareerDefaultModelCfgId(baseCareer, modelCfgId) end

---清空职业默认展示模型列表
function this:ClearRoleCareerDefaultModelCfgIdList() end

---在系统浏览器中打开 URL
---@param url string 目标网址
function this:OpenURL(url) end

---显示大爆相关的飘字效果
---@param str string 显示的数值字符串
function this:ShowBigBangFloatingWords(str) end

---请求领取盒子特权礼包
function this:ReqReceivePrivilegeGiftMessage() end

---触发屏幕震动效果
---@param count number 震动次数
---@param level number 震动强度等级
---@param seconds number 震动持续时间 (可选)
---@param quake number 震动幅度 (可选)
---@param interval number 震动间隔 (可选)
---@param quakeInterval number 震动频率 (可选)
function this:ScreenVibration(count, level, seconds, quake, interval, quakeInterval) end

---清空所有系统功能的开启状态
function this:ClearSystemFunctionState() end

---获取开服指定天数和小时的时间戳
---@param days number 开服第几天
---@param hour number 目标小时 (0-23)
---@return number 开服第几天第几个小时的时间戳（毫秒）
function this:GetEndTimeStamp(days, hour) end

---获取服务器当天的24点整的时间戳（毫秒）
---@return number @当天的24点整的时间戳（毫秒）
function this:GetCurDayEndTime() end

---根据传入的时间戳（毫秒），获取传入时间戳当天0点的时间戳
---@param timeStamp number @时间戳（毫秒）
---@return number @当天0点的时间戳（毫秒）
function this:GetThatDayZeroTimeStampByTimeStamp(timeStamp) end

---设置自动挂机时的优先攻击目标
---@param rid number 目标角色 ID
function this:SetHookAttackTargetId(rid) end

---分发选择服务器的事件
---@param server table 服务器数据对象
function this:DispatchSelectServer(server) end

---根据角色所在服 ID 获取服务器信息
---@param sid number 服务器 ID
---@return ServerStruct 服务器数据
function this:GetServerInfoByRole(sid) end

---获取最近登录过的服务器列表
---@return ServerStruct[] 最近服务器列表
function this:GetRecentServer() end

---获取服务器角色列表
---@return table
function this:GetServerRoleList() end

---获取所有可用服务器列表
---@return ServerStruct[] 服务器列表
function this:GetServerList() end

---请求领取活动预览奖励 
---@param cfgId number 活动配置 ID
function this:ReqReceivePreviewRewardMessage(cfgId) end

---获取当前是否为 PC 平台环境
---@return boolean
function this:GetIsPcPlatform() end

---分发开启主系统功能的事件
---@param message any 事件参数
function this:LUA_EVENT_OPENMAINSYSTEMFUNCTION(message) end

---请求整理背包物品
function this:ReqTidyItemMessage() end

---请求交换背包物品位置
---@param toIndex number 目标索引
---@param fromIndex number 起始索引
function this:ReqSwapItemMessage(toIndex, fromIndex) end

---请求首充界面信息【请求协议已经废弃了】
function this:ReqFirstRechargeViewMessage() end

---请求发起交易申请
---@param roleId number 目标角色 ID
function this:ReqTradeMessage(roleId) end

---请求重置属性点
function this:ReqResetAttrPointMessage() end

---请求使用邀请函/感谢信道具(废弃，协议不在使用)
function this:ReqUseLetterMessage() end

---根据角色名称请求查找角色 ID
---@param name string 角色名字
function this:ReqFindRidByNameMessage(name) end

---请求交换仓库物品位置
---@param fromIndex number 起始索引
---@param toIndex number 目标索引
function this:ReqSwapStoreItemMessage(fromIndex, toIndex) end

---请求将物品从仓库移动到背包
---@param storeIndex number 仓库索引
---@param BagIndex number 背包索引
function this:ReqStoreToBagMessage(storeIndex, BagIndex) end

---请求仓库扩容
---@param useItem number 是否优先使用扩容道具 (1: 是, 0: 否)
---@param curStorePage number 当前仓库页码
function this:ReqStoreAddCapacityMessage(useItem, curStorePage) end

---请求增加仓库页数
---@param useItem number 是否优先使用道具
function this:ReqStoreAddPageMessage(useItem) end

---请求整理指定页码的仓库物品
---@param storePage number 仓库页码
function this:ReqTidyStoreItemMessage(storePage) end

---请求角色复活
---@param id number 角色ID
---@param type number 复活类型 (cfg_revive中的type字段值)
function this:ReqPlayerReliveMessage(id, type) end

---设置是否显示角色头顶的血条
---@param rid number 角色唯一 ID
---@param isShow boolean 是否显示
function this:ShowOrHideHeadHp(rid, isShow) end

---请求兑换激活码
---@param cdkey string 激活码字符串
function this:ReqCdKeyMessage(cdkey) end

---请求生成邀请码
function this:ReqCreateInviteCodeMessage() end

---检查是否所有 UI 资源已加载完成
---@return boolean
function this:IsAllLoad() end

---设置是否显示指定角色的头顶信息
---@param rid number 角色 ID
---@param isShow boolean 是否显示
function this:ShowOrHideHead(rid, isShow) end

---设置角色模型是否受系统显示设置控制
---@param rid number 角色 ID
---@param isModelShowSettingControl boolean 是否受控
function this:SetIsRoleModelShowSettingControl(rid, isModelShowSettingControl) end

---在场景中创建一个临时怪物实例 (主要用于展示或剧情)
---@param rid number 实例唯一 ID
---@param cfgId number 怪物配置 ID
---@param x number X 坐标
---@param y number Y 坐标 (高度)
---@param z number Z 坐标
function this:CreateMonster(rid, cfgId, x, y, z) end

---将一个角色的模型绑定到另一个角色的节点下
---@param bind_node_rid number 父级角色 ID
---@param need_bind_rid number 需要绑定的子级角色 ID
---@param x number 相对 X 偏移（可选，默认0）
---@param y number 相对 Y 偏移（可选，默认0）
---@param z number 相对 Z 偏移（可选，默认0）
---@param xR number 相对 X 旋转，X轴旋转（可选，默认0）
---@param yR number 相对 Y 旋转，Y轴旋转（可选，默认0）
---@param zR number 相对 Z 旋转，Z轴旋转（可选，默认0）
function this:SetRoleBindToRoleModeNode(bind_node_rid, need_bind_rid, x, y, z, xR, yR, zR) end

---强制设置角色的动作、状态和行为类型
---@param rid number 角色 ID
---@param action EAction 动作枚举
---@param state EFSMState 状态机枚举
---@param behaviour EBehaviourType 行为树枚举
function this:SetCreateRoleAction(rid, action, state, behaviour) end

---直接控制角色模型的显示与隐藏
---@param rid number 角色 ID
---@param isShow boolean 是否显示
function this:SetRoleModelIsShow(rid, isShow) end

---回收创建怪物模型
---@param rid number 角色id ID
function this:RecycleCreateMonster(rid) end

---设置指定角色当前锁定的技能 ID
---@param rid number 角色 ID
---@param skillId number 技能 ID
function this:SetSelectRoleSkillId(rid, skillId) end

---设置自动挂机时禁用的技能
---@param skillId number 技能 ID
---@param isNoRelease boolean 是否禁用
function this:SetHookNoReleaseSkill(skillId, isNoRelease) end

---设置主角当前选中的目标角色 ID
---@param targetId number 目标角色 ID
function this:SetSelectTargetId(targetId) end

---打开 996 交易行界面 (仅限移动端)
function this:OpenTrading996() end

---确认或拒绝 996 交易行的物品收货
---@param mailId number 关联的邮件 ID
---@param isConfirm boolean 是否确认购买 (true: 确认, false: 拒绝)
function this:Check996BuyItem(mailId, isConfirm) end
