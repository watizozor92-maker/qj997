--工具自动生成
---@class UiProtos.UiReq
---@field uiType number @ 参考ReqUiType
---@field key string @用#分割的字符串，npcCfgId#npcId
---@field funName string @ 调用方法名称
---@field args CommonProtos.TupleBean[] 
---@field openInRange boolean @是否在范围内打开 (默认TRUE) T:检查范围 F:不检查范围
---@field flushTask boolean @ 是否刷新任务进度 T:刷新 F:不刷新

---@class UiProtos.UiCloseReq
---@field uiType number @ 参考ReqUiType

---@class UiProtos.ResRefreshUi
---@field uiType number @ 参考ReqUiType
---@field key string @例如 npc 在地图的mapObjId
---@field msg string 
---@field args CommonProtos.TupleBean[] 

---@class UiProtos.MsgBoxRes
---@field msg string 

---@class UiProtos.FilterGlobalMsgRes
---@field type number @0=不过滤 1=过滤

---@class UiProtos.OpenHyperlinkRes
---@field panelId number @面板ID
---@field type number @1打开 2关闭

---@class UiProtos.AddButtonRes
---@field mainId number @主窗口ID
---@field iconId number @图标ID
---@field link string @图标路径

---@class UiProtos.DelButtonRes
---@field mainId number @主窗口ID
---@field iconId number @图标ID

---@class UiProtos.RedDotRes
---@field mainId number @主窗口ID
---@field buttonId string @按钮ID
---@field x number @x
---@field y number @y

---@class UiProtos.RedDelRes
---@field mainId number @主窗口ID
---@field buttonId string @按钮ID

---@class UiProtos.NavigationRes
---@field mainId number @主窗口ID
---@field buttonId number @按钮ID
---@field tip string @文字提示

---@class UiProtos.OpenNpceShowExRes
---@field npcId number @NPCID
---@field npcConfigId number @Npc表配置IDd
---@field tpRange number @距离NPC范围
---@field npcRange number @传送到NPC附近范围

---@class UiProtos.OpenWindowsRes
---@field panelId number @面板ID

---@class UiProtos.ViewPlayerRes
---@field rid number @角色ID
---@field panelId number @面板ID

---@class UiProtos.OpenNpcShow
---@field npcId number @NPCID
---@field npcConfigId number @NPC配置ID

---@class UiProtos.MapEffectRes
---@field id number @id
---@field mapId number @地图id
---@field x number @x
---@field y number @y
---@field effId number @特效ID
---@field times number @播放次数(0不限制次数, 大于0为播放次数)
---@field model number @模式(0所有人可见 1自己可见2组队可见 3行会成员可见 4敌对可见)
---@field rid number @角色ID
---@field type number @特效类型(1表示2D,2表示3D)

---@class UiProtos.DelMapEffectRes
---@field id number @id
---@field rid number @角色ID
---@field type number @特效类型(1表示2D,2表示3D)

---@class UiProtos.BagToTmpItemBoxReq
---@field lid number @道具唯一Id
---@field ItemBoxId number @OK框编号
---@field itemType UiProtos.ItemType[] @道具类型

---@class UiProtos.ItemType
---@field type number @父类型
---@field subType number @子类型

---@class UiProtos.BagToTmpItemBoxRes
---@field lid number @道具唯一Id
---@field ItemBoxId number @OK框编号

---@class UiProtos.TmpItemBoxToBagReq
---@field ItemBoxId number @OK框编号

---@class UiProtos.TmpItemBoxToBagRes
---@field ItemBoxId number @OK框编号

---@class UiProtos.UpdateItemGmExtRes
---@field type number @1 装备 2背包
---@field lid number 
---@field gmExt CommonProtos.ItemGmExt 

---@class UiProtos.RedDotList
---@field beans UiProtos.RedDotBean[] @红点列表

---@class UiProtos.RedDotBean
---@field redId number @红点id
---@field redValue number @红点value,有的地方可以需要显示数量，大于0是有，=0表示需要删除

