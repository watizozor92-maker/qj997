--工具自动生成
---@class FriendProto.FriendInfo
---@field rid number @玩家id
---@field name string 
---@field career number 
---@field sex number 
---@field level number 
---@field relation number @所属关系：0:陌生人 1好友 2宿敌 3黑名单 4申请列表
---@field friendLove number @好感度、仇恨值
---@field online number @ 在线状态 0:离线 1:在线
---@field unionName string @ 行会/战盟的名称
---@field hasUnreadMsg number @ 是否有未读消息 0:没有 1:有

---@class FriendProto.FriendInfoRes
---@field type number 
---@field friends FriendProto.FriendInfo[] 

---@class FriendProto.OpenFriendPanelReq
---@field type number @ 0:陌生人 1好友 2宿敌 3黑名单 4申请列表

---@class FriendProto.SearchFriendReq
---@field name string @玩家名(支持模糊查询)

---@class FriendProto.SearchFriendRes
---@field friendInfo FriendProto.FriendInfo[] 

---@class FriendProto.RecommendFriendsRes
---@field friendInfo FriendProto.FriendInfo[] 

---@class FriendProto.AddFriendReq
---@field type number @1好友，4黑名单
---@field rid number 

---@class FriendProto.FriendChangeRes
---@field type number @ 1:好友 2:宿敌 3:黑名单 4:申请列表
---@field changeType number @ 1:添加 2:移除 3:修改
---@field friend FriendProto.FriendInfo[] @ 好友信息

---@class FriendProto.DeleteFriendReq
---@field type number @1好友 2宿敌 3黑名单 4申请列表
---@field rid number 

---@class FriendProto.CheckApplyReq
---@field targetId number 
---@field flag boolean @true:同意 false:拒绝

---@class FriendProto.FriendLogsReq
---@field type number 
---@field targetId number 

---@class FriendProto.FriendLogsRes
---@field type number @ 2:宿敌 3:黑名单
---@field FriendLog FriendProto.FriendLog[] 

---@class FriendProto.FriendLog
---@field time number @  日志记录的时间
---@field mapCfgId number @  日志记录的地点(地图)

---@class FriendProto.ReqClearMsgUnreadState
---@field friendRid number @ 好友rid

