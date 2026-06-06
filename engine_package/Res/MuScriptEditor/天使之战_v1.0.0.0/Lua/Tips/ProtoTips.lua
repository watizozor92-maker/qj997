---@class DailyActivity
---@field activity_value number
---@field reset_time string
---@field daily_task daily_task[]
---@field daily_box daily_box[]

---@class daily_task
---@field task_id number
---@field target_id number
---@field taskgoal_type number
---@field goal_count number
---@field state number
---@field task_finish_count number

---@class daily_box
---@field box_id number
---@field ax_num number
---@field state number

---@class DailyActivityActivity
---@field activityid string
---@field open boolean

---@class RES_GET_MONTHCARD_INFO
---@field MonthCardCfgId MonthCardCfgId -- 三倍收益剩余时间，毫秒
---@field threetime string -- 三倍收益剩余时间，毫秒
---@field todayreceivethreetime string --今天是否领取了三倍收益时间

---@class MonthCardCfgId
---@field isopen string --该卡是否生效
---@field buycount string--该卡买了几次
---@field isfirstbuy string--是否是第一次购买
---@field vaildTime string--有效期（到期时间的时间戳）
---@field cfgId string--跟key一样，月卡的cfgId


---@class EquipProto.EquipIndex
---@field index number @装备部位
---@field equip CommonProtos.Item


---@class CommonProtos.ItemExtInfo
---@field equipExtInfo CommonProtos.EquipExtInfo @装备
---@field gemExtInfo CommonProtos.GemExtInfo @装备技能


---@class CommonProtos.Item
---@field id number
---@field cfgId number
---@field count number
---@field time number @创建时间
---@field bind boolean @是否绑定
---@field itemExtInfo CommonProtos.ItemExtInfo @装备扩展
---@field gmExtInfo CommonProtos.ItemGmExt @脚本扩展
---@field correctId number @装备修正Id
---@field endTime number @过期时间
---@field unTrade boolean @false可以上架  true无法上架
---@field luaExtData string @lua扩展数据

---@class UserProtos.RoleInfo
---@field rid number
---@field name string
---@field sex number
---@field level number
---@field career CommonProtos.Career
---@field roleInfoExt UserProtos.RoleInfoExt @业务数据扩展信息

---@class CommonProtos.Career
---@field baseCareer number @ 根职业
---@field careerRank number @ 职业等级
---@field careerNum number @ 职业编号

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

---@class UserProtos.OtherRoleInfoRes
---@field type number @ 请求所需数据类型 1 角色基本信息 2 属性信息 3技能信息 4装备信息
---@field role UserProtos.RoleInfo @玩家基本信息
---@field equipIndex EquipProto.EquipIndex[] @装备信息

---@class UserProtos.RoleAppearOut
---@field pos number
---@field cfgId number 

---@class MapProtos.Rune
---@field curRunePlate number @当前使用的符文盘
---@field holeReflectLevel MapProtos.HoleReflectLevel[] @符文盘的孔位对应的等级
---@field runePlate MapProtos.RunePlate[] @所有套方案对应的符文盘
---@field runePlateLevel number @符文盘等级

---@class MapProtos.HoleReflectLevel
---@field hole number @第几个符文孔
---@field level number @当前符文孔的等级

---@class MapProtos.RunePlate
---@field num number @第几套符文盘
---@field runePlateInfo MapProtos.RunePlateInfo[] @当前套符文盘的具体信息

---@class MapProtos.RunePlateInfo
---@field hole number @符文盘的第几个孔位
---@field runeItem CommonProtos.Item @当前孔位里面对应的符文道具

---@class CommonProtos.FightAttribute
---@field type number @属性类型
---@field num number @属性值

---@class recharge 充值记录
---@field totalRecharge number 总共充值金额
---@field lastRechargeTime number 上次充值时间（毫秒时间戳）
---@field gearPosition number 当前档位
---@field gearRecharge number 档位充值金额
---@field quit boolean 是否退档
---@field lsatGearChangeTime number 重置档位时间
---@field cost number 花费额度
---@field upperLimit number 额度上限

---@class GoldFirstKillProtos.RequestFirstKillRedEnvelope 请求领取全服首杀红包
---@field monsterId number @怪物id

---@class GoldFirstKillProtos.ResponseFirstKillRedEnvelope 响应领取全服首杀红包
---@field hasClaimed boolean @是否已领取红包 key是当前怪物id

---@class GoldFirstKillProtos.ResponseAllServerFirstKillData @全服首杀数据
---@field allServerData FirstKillRedEnvelopeProtos.AllServerFirstKillDataTable[] @全服首杀数据
---@field envelope table<number,boolean> @红包领取状态数据
---@field taskInfo table<number,boolean> @任务状态 1已接受 2已完成 3已提交

---@class FirstKillRedEnvelopeProtos.AllServerFirstKillDataTable @key是当前怪物id
---@field killer number @击杀者rid
---@field killerName string @击杀者名字
---@field killTime number @击杀时间，时间戳

---@class GoldFirstKillProtos.RequestPersonalGoldFirstKillReward
---@field monsterId number @当前怪物id

---@class GoldFirstKillProtos.ResponsePersonalGoldFirstKillRewardTable 响应领取个人黄金首杀奖励 @怪物id key
---@field status string @任务状态

---@class GoldFirstKillProtos.PersonalFirstKillTaskStatusChange 个人首杀任务状态变化包 @怪物id key
---@field status string @任务状态

---@class OpenServiceArchangelWelfareProtos.AngelWelfareRewardInfoRes
---@field awards number[] @已领的奖励
---@field serverReward number[] @全服领取奖励信息
---@field angelWelfareCount number @拥有的积分
---@field taskInfo OpenServiceArchangelWelfareProtos.TaskInfo[] @拥有的积分


---@class OpenServiceArchangelWelfareProtos.TaskInfo
---@field nowCount number @第几个奖励
---@field status number @全服的已领取次数