--工具自动生成
---@class TeamProto.MarryInfo
---@field nan UserProtos.RoleInfo 
---@field nv UserProtos.RoleInfo 
---@field createTime number @结婚时间戳

---@class TeamProto.MarryReq
---@field toRid number @和谁结婚

---@class TeamProto.AskMarryRes
---@field fromRid number @和谁结婚

---@class TeamProto.AgreeMarryReq
---@field fromRid number @接受来自fromRid的结婚
---@field agree number @1 同意； 0 拒绝

---@class TeamProto.AgreeMarryRes
---@field rid number @MarryReq.toRid
---@field res number @ 当1表示同意 ; 拒绝的是0.
---@field marryInfo TeamProto.MarryInfo 
---@field marryState number @ 结婚状态(0:未婚 1:已婚 2:离婚中 3:离婚失败)

---@class TeamProto.MarryInfoRes
---@field marryState number @ 结婚状态
---@field drafterId number @ 离婚发起者id,0表示空
---@field marryId number @ 婚姻信息id，为0表示为空

---@class TeamProto.TeamInfo
---@field teamId number @ 队伍id
---@field leaderId number @ 队长rid
---@field teamMember TeamProto.TeamMember[] @ 成员列表

---@class TeamProto.TeamMember
---@field roleInfo UserProtos.RoleInfo @ 玩家信息
---@field mapId number 
---@field mapLine number 
---@field hp number @ 当前血量
---@field maxHp number @ 最大血量
---@field offLine boolean @ 是否断线

---@class TeamProto.OperationTarget
---@field targetRid number @ 操作对象rid
---@field listType number @ 1:附近玩家 2:我的好友 3:战盟成员

---@class TeamProto.ReqPlayerList
---@field listType number @ 1:附近玩家 2:我的好友 3:战盟成员

---@class TeamProto.PlayerList
---@field listType number @ 1:附近玩家 2:我的好友 3:战盟成员
---@field nearbyPlayer TeamProto.Player[] 

---@class TeamProto.Player
---@field roleInfo UserProtos.RoleInfo 
---@field invitationState number @ 邀请状态; 0:未邀请 1:已邀请

---@class TeamProto.InvitationList
---@field invitation TeamProto.Invitation[] 

---@class TeamProto.Invitation
---@field teamId number 
---@field roleInfo UserProtos.RoleInfo 

---@class TeamProto.ApplicationList
---@field roleInfo UserProtos.RoleInfo[] 

---@class TeamProto.NearbyTeamList
---@field nearbyTeam TeamProto.NearbyTeam[] 

---@class TeamProto.NearbyTeam
---@field teamId number @ 队伍id
---@field roleInfo UserProtos.RoleInfo @ 队长
---@field count number @ 现有人数
---@field applyState number @ 申请状态 0:未申请 1:已申请

---@class TeamProto.ApplyTeamInfo
---@field teamId number 

---@class TeamProto.ReplyInvitation
---@field agree number @ 0:拒绝 1:同意
---@field leaderRid number @ 队长rid

---@class TeamProto.ReplyApply
---@field agree number @ 0:拒绝 1:同意
---@field targetRid number @ 目标对象rid

---@class TeamProto.PublishRecruitInfoReq
---@field activityId number 
---@field lowerLevel number 
---@field upperLevel number 

---@class TeamProto.TeamMemberHpChangeRes
---@field targetRid number 
---@field hp number @当前血量
---@field maxHp number @最大血量

---@class TeamProto.CreateTeamAndInviteReq
---@field targetRid number 

---@class TeamProto.TeamLoseRes
---@field teamId number @ 队伍id

---@class TeamProto.TeamLoseByLeaderRes
---@field leaderRid number @ 队伍id

---@class TeamProto.reqTeamId
---@field rid number @玩家id

---@class TeamProto.resRoleTeamId
---@field rid number @玩家id
---@field teamId number 

