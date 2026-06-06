--工具自动生成
---@class UserProtos.LoginReq
---@field sessionId number @此字段客户端不用管，这里是服务器内部过程中会追加该信息
---@field loginName string 
---@field sid number 
---@field pid number 
---@field token string 
---@field time number 
---@field sign string @验证字符串
---@field loginIp string 
---@field sdkId number @sdkId

---@class UserProtos.LoginReqExt

---@class UserProtos.RoleInfo
---@field rid number 
---@field name string 
---@field sex number 
---@field level number 
---@field career CommonProtos.Career 
---@field roleInfoExt UserProtos.RoleInfoExt @业务数据扩展信息

---@class UserProtos.RoleInfoExt
---@field exp number @ 经验
---@field shengwang number @ 声望
---@field shopId number @ 当有商店信息表示商店id，默认为0
---@field unionId number @ 战盟id
---@field unionName string @ 战盟名称
---@field position number @ 战盟职位:   1盟主 2副盟主 3战斗队长 4精英 5成员
---@field breakLineState number @ 断线状态；1：断线 0：在线
---@field freeAttrPoint number @ 可以分配属性点
---@field equip MapProtos.Equip[] @ 角色身上的装备
---@field mountId number @ 坐骑id
---@field teamId number @ 队伍id
---@field equipShowIdx number[] @装备
---@field currPoint CommonProtos.FightAttribute[] @当前点数
---@field expandExp number @ 扩展经验， 经验包
---@field rune MapProtos.Rune @角色符文
---@field firstrecharge number @首充
---@field totalrecharge number @总充值
---@field attAddWay number @角色属性加成方式
---@field roleAppear UserProtos.RoleAppearOut[] @角色外观
---@field shapeRing number @当前穿戴的变身戒指，怪物id，不穿显示0
---@field luaExtData string @lua扩展数据
---@field boxTradeTime number @盒子交易行上架时间，未上架默认为0
---@field boxTradeGoodsId string @盒子交易行商品id
---@field jiuJiuTradeTime number @九九交易行上架时间，未上架默认为0
---@field jiuJiuTradeGoodsId string @九九交易行商品id

---@class UserProtos.RoleAppearOut
---@field pos number 
---@field cfgId number 

---@class UserProtos.LoginRes
---@field uid number 
---@field role UserProtos.RoleInfo[] 
---@field kmlPort number @已废弃
---@field unlockList number[] @已经解锁的职业ID
---@field gid number @游戏ID
---@field closeCreateRole boolean @是否关闭了创角功能

---@class UserProtos.EnterRoleReq
---@field rid number 
---@field clientType number @ 1: PC 2: 移动端
---@field width number @ 分辨率宽
---@field height number @ 分辨率高
---@field reconnect boolean @ 是否是重连 false:正常登录 true: 重连后登录
---@field isSimulator boolean @ 是否是模拟器

---@class UserProtos.EnterRoleRes
---@field rid number 
---@field serverTime number 
---@field openServerTime number @开服时间
---@field beforeTransferCareer CommonProtos.Career @转职前职业
---@field cancelCd number @可以取消倒计时，此刻以前都可以撤销

---@class UserProtos.CreateRoleReq
---@field roleName string 
---@field sex number 
---@field career number 
---@field inviteCode string 

---@class UserProtos.CreateRoleRes
---@field role UserProtos.RoleInfo 

---@class UserProtos.RemoveRoleReq
---@field rid number @将角色id发送过来

---@class UserProtos.RemoveRoleRes
---@field uid number 
---@field role UserProtos.RoleInfo[] 

---@class UserProtos.RecoverRoleReq

---@class UserProtos.RecoverRoleRes
---@field uid number 
---@field role UserProtos.RoleInfo[] 

---@class UserProtos.RoleInfoReq
---@field rid number 

---@class UserProtos.OtherRoleInfoReq
---@field otherId number 
---@field type number @ 1 角色基本信息 2 装备信息

---@class UserProtos.RandomRoleNameReq
---@field careerId number @ 职业id
---@field dissatisfiedName string @ 上次生成不满意的名字

---@class UserProtos.RandomRoleNameRes
---@field uid number 
---@field roleName string 

---@class UserProtos.RoleSetting
---@field roleSettingType number 
---@field value string 

---@class UserProtos.RoleSettingReq
---@field roleSetting UserProtos.RoleSetting 

---@class UserProtos.RoleSettingRes
---@field roleSetting UserProtos.RoleSetting[] @基础设置
---@field hangUpSetting UserProtos.HangUpSettingReq @挂机设置
---@field skillShowType UserProtos.SkillShowType @技能显示设置
---@field inviteCount number @邀请码创建次数
---@field invite string @邀请码

---@class UserProtos.RoleInfoRes
---@field role UserProtos.RoleInfo 
---@field fightAttribute CommonProtos.FightAttribute[] @属性信息
---@field equipIndex EquipProto.EquipIndex[] @所有的装备信息
---@field masterInfo EquipProto.MasterInfo[] @装备大师信息
---@field luckys UserProtos.SynthesisLuckyInfo[] @合成一代幸运值

---@class UserProtos.RoleFruitInfoReq
---@field rid number 

---@class UserProtos.RoleFruitInfoRes
---@field fightAttribute CommonProtos.FightAttribute[] @属性信息

---@class UserProtos.OtherRoleInfoRes
---@field type number @ 请求所需数据类型 1 角色基本信息 2 属性信息 3技能信息 4装备信息
---@field role UserProtos.RoleInfo @玩家基本信息
---@field equipIndex EquipProto.EquipIndex[] @装备信息

---@class UserProtos.HeartReq
---@field clientTime number @客户端时间

---@class UserProtos.HeartRes
---@field nowTime number @服务器端时间

---@class UserProtos.QuitGameReq

---@class UserProtos.QuitGameRes
---@field loginName string 
---@field reason number @退出游戏原因

---@class UserProtos.QuitRoleReq

---@class UserProtos.QuitRoleRes
---@field uid number 
---@field role UserProtos.RoleInfo[] 
---@field unlockList number[] @已经解锁的职业ID

---@class UserProtos.DisplaceUserRes

---@class UserProtos.HangUpSettingReq
---@field killMonsterRange number @杀怪范围
---@field LongRangeCounterattack string @远距离反击
---@field returnPoint string @返回原位
---@field returnTime string @返回时间(单位秒)
---@field targetRange string @周身目标
---@field lessThan string @少于
---@field value string @使用类型
---@field buffSkill string @buff技能
---@field monomerSkill string @单体技能
---@field groupSkill string @群体技能
---@field summonSkill string @召唤技能
---@field autoPickUp UserProtos.AutoPickUp[] 
---@field QJ5partnerAutoKill number 
---@field QJ5autoRelease number 
---@field QJ5lessThan number 
---@field QJ5Skill string 
---@field QJ5UnSkill string 
---@field schemeId number 
---@field skillSetting string 

---@class UserProtos.AutoPickUp
---@field pickType number 
---@field canPick boolean 

---@class UserProtos.HangUpSettingRes
---@field hangUpSetting UserProtos.HangUpSettingReq @挂机设置

---@class UserProtos.SkillShowType
---@field showType number @显示类型
---@field allShow string @全显
---@field annulusType string @轮盘
---@field items string @快捷装备栏

---@class UserProtos.ClientLoadedReq

---@class UserProtos.ResRoleOthersData
---@field datas UserProtos.RoleOthersData[] 

---@class UserProtos.RoleOthersData
---@field dataType number @ 类型
---@field dataValue string @ 值

---@class UserProtos.UpdateEquipLooksReq
---@field equipIndex number[] 

---@class UserProtos.UpdateEquipLooks2Req
---@field itemId number[] @时装或者装备

---@class UserProtos.SetRoleAttAddWay
---@field way number @属性加成方式

---@class UserProtos.SynthesisLuckyRes
---@field luckys UserProtos.SynthesisLuckyInfo[] 

---@class UserProtos.SynthesisLuckyInfo
---@field id number @合成公式表ID
---@field number number @幸运值
---@field sucTimes number @成功次数

---@class UserProtos.InviteCodeRes
---@field code string @邀请码

---@class UserProtos.InviteCodeNumRes
---@field num number @数量

---@class UserProtos.CdKeyReq
---@field cdkey string 

---@class UserProtos.CdKeyRes
---@field items CommonProtos.Item[] @获得的物品

---@class UserProtos.UnLockUserCareerReq
---@field uid number 
---@field careerId number 

---@class UserProtos.UnLockUserCareerRes
---@field ok boolean 

---@class UserProtos.JiuJiuTradeTokenReq

---@class UserProtos.JiuJiuTradeTokenRes
---@field gameToken string @json串格式

---@class UserProtos.TradeLockRoleChangeRes
---@field roleId number @角色id
---@field tradeTime number @交易行上架时间，未上架锁定默认为0
---@field goodsId string @商品id

