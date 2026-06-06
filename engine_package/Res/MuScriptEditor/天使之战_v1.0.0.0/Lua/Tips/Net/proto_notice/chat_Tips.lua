--工具自动生成
---@class ChatProto.ReqChat
---@field channel number @参见ChatChannel
---@field message string 
---@field toRid number @私聊目标玩家id
---@field lidList ChatProto.ChatItem[] 

---@class ChatProto.ChatItem
---@field lid number @道具的唯一Id
---@field type number @1 背包 2 装备

---@class ChatProto.ResChat
---@field msgId number @ 消息
---@field senderId number @ 发送者玩家id
---@field sendName string @ 发送者名字
---@field receiverId number @ 接受者rid
---@field msgType ChatProto.MsgType @ 消息类型
---@field channel number @ 频道类别 //参见ChatChannel
---@field message string @ 消息内容
---@field sendTime number @ 发送时间
---@field career number @ 发送者的职业(用以显示头像)
---@field teamId number @ 发送者队伍id(用于组队)
---@field itemList CommonProtos.Item[] @道具列表
---@field senderServerId number @ 发送者服务器sid

---@class ChatProto.OfflineMsg
---@field channel number 
---@field resChat ChatProto.ResChat[] 

---@class ChatProto.ChatHistoryReq
---@field channel number @ 频道类型
---@field targetId number @ 对象id
---@field startMsgId number @ 起始消息id

---@class ChatProto.ChatHistoryRes
---@field channel number @ 频道类型
---@field targetId number 
---@field resChat ChatProto.ResChat[] 
---@field hasMore boolean @ 消息是否还有更多

---@class ChatProto.HorseRaceLampRes
---@field content string @ 跑马灯显示内容

---@class ChatProto.TextNoticeRes
---@field id number @ 配置表id
---@field contentFromServer boolean @ false：表示客户端直接读取配置  true：表示从服务器获取内容
---@field content string @ 内容; 标志位为0时,此字段值为空
---@field tableType number @ 0：对应cfg_String表 1：对应cfg_hintMessage表
---@field params string[] @替换参数

---@class ChatProto.SendMsgByNpcRes
---@field type number @显示类型
---@field foregroundColor number @前景颜色
---@field backgroundColor number @背景颜色
---@field content string @文本内容
---@field roleName string @角色名称
---@field npcName string @npc名称
---@field npcId number @npcId
---@field sendTime number @发送时间

---@class ChatProto.SendCenterMsgRes
---@field foregroundColor number @前景颜色
---@field backgroundColor number @背景颜色
---@field content string @文本内容
---@field model number @模式
---@field endTime number @结束时间戳 毫秒
---@field timeLabel string @倒计时标签
---@field sendTime number @发送时间

---@class ChatProto.ClearDelayGotoRes
---@field type number @参数1
---@field sendTime number @发送时间

---@class ChatProto.GroupNoticeMsgRes
---@field foregroundColor number @前景颜色
---@field backgroundColor number @背景颜色
---@field content string @文本内容
---@field sendTarget string @发送对象(已转为大写)
---@field sendTime number @发送时间
---@field roleName string @玩家名称

---@class ChatProto.SendTopChatBoardMsgRes
---@field sendModel number @发送模式
---@field foregroundColor number @前景颜色
---@field backgroundColor number @背景颜色
---@field endTime number @结束时间戳 毫秒
---@field content string @文本内容
---@field showName number @是否显示发送者名称(0显示，1不显示)
---@field sendTime number @发送时间

---@class ChatProto.SendMoveMessageRes
---@field sendModel number @发送模式
---@field foregroundColor number @前景颜色
---@field backgroundColor number @背景颜色
---@field y number @y坐标
---@field count number @滚动次数
---@field content string @文本内容
---@field sendTime number @发送时间

---@class ChatProto.SendCustomMsgRes
---@field type number @消息类型
---@field content string @文本内容
---@field foregroundColor number @前景颜色
---@field backgroundColor number @背景颜色
---@field x number @x坐标
---@field y number @y坐标
---@field sendTime number @发送时间

---@class ChatProto.SendMsgNewRes
---@field foregroundColor number @前景颜色
---@field backgroundColor number @背景颜色
---@field content string @文本内容
---@field model number @消息类型
---@field endTime number @结束时间戳 毫秒
---@field sendTime number @发送时间

---@class ChatProto.SendDelayMsgRes
---@field content string @文本内容
---@field endTime number @结束时间戳 毫秒
---@field foregroundColor number @前景颜色
---@field backgroundColor number @背景颜色
---@field isChangeMapDel number @换地图是否删除 0=不删除 1=删除
---@field skip string @跳转字段
---@field x number @x坐标
---@field sendTime number @发送时间

---@class ChatProto.OnlineState
---@field toRid number 
---@field isOnline boolean 

---@class ChatProto.SendOnlineStateReq
---@field toRid number[] 

---@class ChatProto.SendOnlineStateRes
---@field onlineState ChatProto.OnlineState[] 

---@class ChatProto.FindRidByNameReq
---@field name string 

---@class ChatProto.FindRidByNameRes
---@field rid number 

---@class ChatProto.GameAnnounce
---@field announceId number @公告id
---@field type number @公告类型
---@field startTime number @开始时间
---@field endTime number @结束时间
---@field interval number @间隔时间
---@field content string @公告内容

---@class ChatProto.GameAnnounceRes
---@field gameAnnounceList ChatProto.GameAnnounce[] @有效的公告列表
---@field closeIds number[] @关闭的id列表

---@class ChatProto.RemovePrivateChatRes
---@field rid number 

---@class ChatProto.AllPrivateChatRes
---@field allPrivateChat ChatProto.AllPrivateChat[] 

---@class ChatProto.AllPrivateChat
---@field rid number 
---@field updateTime number 

