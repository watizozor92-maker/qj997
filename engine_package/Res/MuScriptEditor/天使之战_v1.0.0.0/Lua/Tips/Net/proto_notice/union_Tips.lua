--工具自动生成
---@class UnionProto.UnionSetting
---@field autoAccept number @自动接受  0不开启  1开启
---@field needLevel number @招聘需要等级 ：0表示不限制
---@field fightValue number @战力值

---@class UnionProto.UnionInfo
---@field unionId number @行会id
---@field unionName string @行会名字
---@field unionLevel number @行会等级
---@field unionExp number @行会经验
---@field unionCapital number @ 行会资金
---@field grade string @战盟评分
---@field announcement string @招募公告
---@field unionArmband number @行会臂章
---@field leaderOnTime number @盟主上位时间
---@field unionMemberInfo UnionProto.UnionMemberInfo[] @成员信息

---@class UnionProto.UnionDetailsInfo
---@field unionId number @行会id
---@field unionName string @行会名字
---@field unionLevel number @行会等级
---@field memberNum number @行会人数
---@field masterName string @会长名字
---@field unionArmband number @行会臂章
---@field announcement string @招募公告
---@field maxMemberNum number @行会最大人数

---@class UnionProto.EnemyUnion
---@field unionId number 
---@field name string 
---@field time number 

---@class UnionProto.MemberDynamic
---@field type number @动态类型 1.修改职位 2.加入战盟 3.踢出战盟 4.离开战盟 5.敌对战盟
---@field time number @时间
---@field masterName string @盟主或副盟主名称
---@field memberName string @成员名称
---@field masterPosition number @盟主或副盟主名称的职位
---@field memberPosition number @成员职位
---@field changePosition number @成员变更后职位
---@field enemyName string @敌对战盟名称

---@class UnionProto.UnionListInfo
---@field unionName string @行会名称
---@field unionId number @行会id
---@field unionLevel number @行会等级
---@field unionExp number @行会经验
---@field unionNum number @成员数
---@field maxNum number @最大成员数
---@field state number @状态  0代表申请，1代表已申请，2代表已满员
---@field grade string @战盟评分

---@class UnionProto.UnionMemberInfo
---@field name string @名称
---@field memberId number @成员id
---@field level number @等级
---@field position number @1表示盟主，2表示副盟主，3表示战斗队长，4表示精英，5表示成员
---@field onlineState number @1表示在线，0表示不在线
---@field time number @离线时间
---@field fightValue number @ 战力
---@field devote number @  贡献值
---@field career number @需要职业  战士1 法师2 弓箭手3

---@class UnionProto.CreateUnionReq
---@field name string 
---@field unionArmband number 

---@class UnionProto.CreateUnionRes
---@field unionInfo UnionProto.UnionInfo 

---@class UnionProto.UnionDetailsReq
---@field unionId number @行会id

---@class UnionProto.UnionDetailsRes
---@field unionDetailsInfo UnionProto.UnionDetailsInfo 

---@class UnionProto.ViewUnionRes
---@field unionInfo UnionProto.UnionInfo 

---@class UnionProto.AllUnionRes
---@field unionListInfo UnionProto.UnionListInfo[] 

---@class UnionProto.ApplyJoinUnionReq
---@field unionId number @行会id

---@class UnionProto.ApplyJoinUnionRes
---@field unionId number @行会id
---@field applyStatus number @申请状态 0申请 1已申请 2满员

---@class UnionProto.UnionMemberChangeRes
---@field unionMemberInfo UnionProto.UnionMemberInfo[] 

---@class UnionProto.AgreeUnionApplyReq
---@field targetRid number 
---@field isAgree number 

---@class UnionProto.SendApplyListInfoRes
---@field unionSetting UnionProto.UnionSetting 
---@field applyInfo UnionProto.ApplyInfo[] @申请列表信息

---@class UnionProto.UnionApplyListRes
---@field applyInfo UnionProto.ApplyInfo[] 

---@class UnionProto.ApplyInfo
---@field rid number 
---@field name string @玩家名称
---@field level number @等级
---@field career number @需要职业  战士1 法师2 弓箭手3
---@field time number @申请时间
---@field fightValue number @战力值

---@class UnionProto.EnemyUnionList
---@field unionId number @敌对行会ID
---@field unionName string @敌对行会名称
---@field unionLevel number @敌对行会等级
---@field num number @敌对行会人数
---@field relation number @行会关系 1宣战，友好  2本盟  3敌对
---@field announcement string @公告
---@field unionArmband number @行会臂章
---@field unionMasterName string @敌对行会盟主名字
---@field grade string @战盟评分

---@class UnionProto.ModifyArmbandReq
---@field unionArmband number 

---@class UnionProto.ChangeAnnouncementReq
---@field announcement string 

---@class UnionProto.ChangeUnionNameViewRes
---@field isChange boolean @是否改过名

---@class UnionProto.ChangeUnionNameReq
---@field name string 

---@class UnionProto.KickOutMemberReq
---@field memberRid number 

---@class UnionProto.ChangePositionReq
---@field memberRid number 
---@field type number @1禅让盟主 2设为副盟主 3设为战斗队长 4设为精英 5设为成员

---@class UnionProto.EnemyUnionReq
---@field unionId number @敌对行会Id

---@class UnionProto.EnemyUnionListRes
---@field isMaster number @是否盟主（包括副盟主）
---@field enemyUnionList UnionProto.EnemyUnionList[] @敌对行会列表

---@class UnionProto.DonateCapitalReq
---@field diamondValue number @捐献钻石数

---@class UnionProto.ImpeachMaster

---@class UnionProto.QuitUnionRes
---@field isQuit boolean 

---@class UnionProto.ChangeUnionNameViewReq

---@class UnionProto.EnemyUnionViewRes
---@field isReach boolean 

---@class UnionProto.EnemyUnionLestRes
---@field enemyUnionIds number[] @敌对行会Id列表

---@class UnionProto.ArmbandsInfo
---@field armbandsLevel number @臂章等级
---@field unionArmband number @行会臂章
---@field strongLevel number @强化等级
---@field unionLevel number @战盟等级
---@field levelConsumptionId number @升级消耗道具id
---@field levelConsumptionCount number @升级消耗道具数
---@field levelConsumptionOwnCount number @消费道具数量
---@field StrongConsumptionId number @强化消耗道具id
---@field StrongConsumptionCount number @强化道具消耗数量
---@field StrongConsumptionOwnCount number @强化消耗道具拥有数量
---@field armbandStrong UnionProto.ArmbandStrong[] @臂章强化等级 （根据类型对应的等级） 

---@class UnionProto.UnionArmbandsLevelRes
---@field armbandsInfo UnionProto.ArmbandsInfo @战盟臂章等级信息

---@class UnionProto.ArmbandsLevelChangeRes
---@field armbandsInfo UnionProto.ArmbandsInfo @战盟臂章等级信息

---@class UnionProto.ArmbandsStrongChangeRes
---@field armbandsInfo UnionProto.ArmbandsInfo @战盟臂章强化信息
---@field isSuccess boolean 

---@class UnionProto.UnionTaskInfo
---@field taskId number @任务ID
---@field count number @完成次数
---@field refreshTime number @刷新时间秒时间戳
---@field status number @1前往 2领取 3已领取

---@class UnionProto.SendUnionTaskListRes
---@field unionTaskInfo UnionProto.UnionTaskInfo[] 

---@class UnionProto.SubmitUnionTaskReq
---@field taskId number 

---@class UnionProto.SendOnOfflineRes
---@field rid number 
---@field isOnLine boolean @true上线   false下线

---@class UnionProto.UnionSalaryRes
---@field totalDevote number @战盟总贡献
---@field floorsDevote number @领取奖励保底贡献
---@field isReceive boolean @是否领取
---@field level number @工资等级
---@field devote number @自身贡献

---@class UnionProto.UnionBlessViewReq
---@field blessId number 

---@class UnionProto.UnionBlessViewRes
---@field level number @品质等级
---@field time number 

---@class UnionProto.UnionBlessExtractReq
---@field blessId number 
---@field isExtra boolean @是否额外消耗
---@field count number @抽卡次数

---@class UnionProto.BlessInfoRes
---@field info UnionProto.BlessInfo[] 
---@field white number 
---@field yellow number 
---@field green number 
---@field purple number 
---@field red number 

---@class UnionProto.BlessInfo
---@field cfgId number 
---@field rank number 
---@field count number 

---@class UnionProto.ArmbandsStrongUpReq
---@field type number @臂章类别

---@class UnionProto.ArmbandStrong
---@field first number 
---@field second number 

---@class UnionProto.UnionEventTypeRes
---@field type number @0: 不需要显示 1：弹劾 2：弹劾中 3：竞选 4：竞选中

---@class UnionProto.SelectUnionLeaderInfoRes
---@field rid number @发起者
---@field name string @战盟名字
---@field time number @发起截止时间

---@class UnionProto.UnionDevoteRefreshRes
---@field unionDevote number 

---@class UnionProto.ReceiveSalaryRes
---@field isSuc boolean @是否成功

---@class UnionProto.CanReceiveSalaryRes
---@field canReceive boolean 

---@class UnionProto.ChangeUnionNameByCardReq
---@field name string 
---@field index number 

---@class UnionProto.UnionMemberDetailInfo
---@field unionMemberInfo UnionProto.UnionMemberInfo[] @成员列表

---@class UnionProto.UnionMemberDynamic
---@field memberDynamic UnionProto.MemberDynamic[] @成员动态

---@class UnionProto.UpdateUnionInfo
---@field name string 
---@field unionArmband number 

