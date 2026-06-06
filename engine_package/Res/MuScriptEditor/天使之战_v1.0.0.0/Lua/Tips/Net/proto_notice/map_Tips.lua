--工具自动生成
---@class MapProtos.ChangePosRes
---@field id number 
---@field x number 
---@field y number 
---@field reason string 

---@class MapProtos.PlayerEnterMapRes
---@field id number 
---@field x number 
---@field y number 
---@field width number 
---@field height number 

---@class MapProtos.ChangeMapRes
---@field cfgId number 
---@field line number 
---@field x number 
---@field y number 

---@class MapProtos.ReliveRes
---@field id number 
---@field x number 
---@field y number 
---@field dir number 
---@field hp number 
---@field mp number 
---@field shield number 
---@field agSto number 

---@class MapProtos.SwitchFightModelRes
---@field fightModel number 

---@class MapProtos.TryEnterMapRes
---@field cfgId number 
---@field mapId number 
---@field line number 
---@field role MapProtos.RoundPlayer 
---@field mainSkill CommonProtos.FightSkill 

---@class MapProtos.ChangeMapReq
---@field cfgId number 
---@field line number 
---@field x number 
---@field y number 

---@class MapProtos.WalkRes
---@field id number 
---@field x number 
---@field y number 
---@field walkType number 

---@class MapProtos.ChangeDirRes
---@field id number 
---@field dir number 

---@class MapProtos.WalkReq
---@field x number 
---@field y number 
---@field time number 
---@field walkType number 
---@field fromX number 
---@field fromY number 
---@field dir number 

---@class MapProtos.JumpReq

---@class MapProtos.JumpRes
---@field id number @起跳

---@class MapProtos.StandbyReq
---@field standbyType number @ 待机方式

---@class MapProtos.StandbyRes
---@field standbyType number @ 待机方式
---@field id number 

---@class MapProtos.ChangeDirReq
---@field dir number 

---@class MapProtos.Equip
---@field index number @装备索引
---@field cfgId number 
---@field id number 
---@field durability number 
---@field gmExtInfo MapProtos.GmExt 
---@field modelExtInfo MapProtos.ModelExt 

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

---@class MapProtos.GmExt
---@field sweepLevel number @扫光等级
---@field field number @外观模型
---@field shape number @内观模型
---@field luaExt string @lua扩展属性

---@class MapProtos.ModelExt
---@field strengthLevel number 
---@field grade number 
---@field feedLevel number @喂养等级

---@class MapProtos.EquipPet
---@field id number @召唤兽Id
---@field cfgId number @道具配置Id
---@field x number @x坐标
---@field y number @y坐标

---@class MapProtos.IconInfo
---@field pos number @位置(0-9)
---@field playEffect string @播放效果(0图片名称 1特效ID)
---@field effect string @图片名或者特效ID
---@field x number @X坐标 (为空时默认X=0)
---@field y number @Y坐标 (为空时默认Y=0)
---@field autoFill number @自动补全空白位置0,1(0=掉 1=不掉) 被删除位置空缺时
---@field isSelf number @【只对人物的顶戴有效】是否只有自己看见(0=所有人都可以看见 1=仅仅自己可以看见)

---@class MapProtos.RoundPlayer
---@field id number 
---@field x number 
---@field y number 
---@field dir number 
---@field name string 
---@field career CommonProtos.Career @ 职业
---@field sex number 
---@field level number 
---@field hp number 
---@field maxHp number 
---@field mp number 
---@field maxMp number 
---@field pkValue number @ PK 值
---@field equip MapProtos.Equip[] 
---@field buff BufferProtos.Buff[] 
---@field teamId number @ 队伍id
---@field marryState number @ 结婚状态
---@field unionId number @ 行会id
---@field unionName string @ 行会名称
---@field position number @ 行会职位 1:盟主 2:副盟主 3:战斗队长 4:精英 5:成员
---@field showGray boolean @ 显示灰名
---@field marryId number @ 结婚对象id
---@field drafterId number @ 离婚发起者id
---@field moveSpeed number @ 移速时机提升
---@field equipTitleId number @ 佩戴称号id; 0表示无
---@field mountId number @ 坐骑id; 0表示无
---@field stallId number @ 摊位id,为0表示没有摊位
---@field pet MapProtos.EquipPet[] @ 召唤兽
---@field atkSpeed number @攻速实际提升
---@field nameColorId number @ 名字颜色; 值为color表中id,0表示默认
---@field bodyColorId number @ 身体颜色; 值为color表中id,0表示默认
---@field shield number @护盾值
---@field maxShield number @最大护盾值
---@field agsto number @技能值
---@field maxAgsto number @最大技能值
---@field siegeCamp number @ 攻城战阵营 0:中立; 1:攻城方; 2:守城方
---@field bloodyWeaponModelId number @血色城堡石棺掉落模型ID
---@field iconInfo MapProtos.IconInfo[] @顶戴花翎信息(GM脚本中使用)
---@field isRobot boolean @是否是机器人
---@field equipTitleId2 number @ 佩戴称号id; 0表示无   系统用
---@field appearIdx number[] @装备外观：装备索引
---@field isMultiOnHook number @是否处于多倍挂机,1是，0否(客户端要求int)
---@field achievementLevelId number @成就等级表ID
---@field fightCarState number @奇迹5攻城战战车状态； 1:表示战车状态 0:表示正常状态
---@field offline number @0:正常状态,1:离线挂机中
---@field walkSpeed number @走路速度（服务器计算的结果）
---@field runSpeed number @跑步速度（服务器计算的结果）
---@field atkCD number @攻击速度（服务器计算的结果）
---@field skillAniSpeed number @技能动画时间加成（服务器计算的结果）
---@field robberyModeRedName number @看到的视野中心的玩家名字是否变红，因为视野中心的玩家的攻击模式如果是掠夺模式的话，其它视野内玩家看它的名字会变红。1成立，0不成立
---@field fightModel number @该玩家的战斗模式 0：全体模式 1：和平模式 2：夫妻模式 4：组队模式 5：帮会模式 6：红名模式 8：强攻模式
---@field kmlVipId number @KMl脚本中玩家VIPID 0-未开通VIP
---@field aniSpeed number @攻击速度
---@field privilegeTitle number @特权称号
---@field mountShow boolean @坐骑是否显示

---@class MapProtos.PlayerEnterViewRes
---@field player MapProtos.RoundPlayer 

---@class MapProtos.RoundMonster
---@field id number 
---@field cfgId number 
---@field x number 
---@field y number 
---@field ownerId number 
---@field dir number 
---@field hp number 
---@field maxHp number 
---@field maxThreatName string @ 最大仇恨人的名字
---@field isPet boolean @是否是召唤兽
---@field masterId number @召唤兽主人的ID
---@field petCfgId number @召唤兽配置表的ID
---@field threatId number @仇恨目标
---@field nameColorId number @ 名字颜色; 值为color表中id,0表示默认
---@field bodyColorId number @ 身体颜色; 值为color表中id,0表示默认
---@field blockPoints MapProtos.BlockPoint[] 
---@field monExtraData MapProtos.MonExtraData @ 怪物额外属性
---@field iconInfo MapProtos.IconInfo[] @顶戴花翎信息(GM脚本中使用)
---@field scriptCreate boolean @true 脚本创建
---@field walkTime number @怪物行走时间
---@field isDead boolean @怪物是否是死亡状态
---@field isPartner boolean @是否是伙伴
---@field partnerId number @伙伴的ID
---@field mapId number @怪物所在地图ID(不是地图的配置ID)
---@field is3DOnHook boolean @是否在3D挂机场景中
---@field roundMonster_uuidForMsg number 
---@field masterTeamId number @伙伴合召唤兽主人的队伍ID
---@field masterUnionId number @伙伴合召唤兽主人的行会ID
---@field level number @等级
---@field luaExtData string @lua扩展数据

---@class MapProtos.MonExtraData
---@field wolfPlatformInfo MapProtos.WolfPlatformInfo 

---@class MapProtos.WolfPlatformInfo
---@field leftBoundCount number @ 神狼护台的剩余绑定次数
---@field platformBindState number @ 绑定状态,见下面定义的枚举PlatformBindState
---@field boundOwner number @ 绑定所属id

---@class MapProtos.BlockPoint
---@field x number @ x坐标
---@field y number @ y坐标
---@field blockPointType number @ 与枚举BlockPointType对应

---@class MapProtos.MonsterEnterViewRes
---@field monster MapProtos.RoundMonster 

---@class MapProtos.ReqMapMonsterStatus
---@field mapId number @地图configID

---@class MapProtos.MonsterStatus
---@field groupId number 
---@field status number @0-死亡; 1-存活
---@field pointX number @X坐标
---@field pointY number @Y 坐标
---@field monsterId number @怪物唯一ID
---@field configId number @怪物configId
---@field clearTime number @清除时间
---@field mapCfgId number @ 地图cfgId
---@field reliveTime number @ 复活时间

---@class MapProtos.MapMonsterStatus
---@field monsterStatus MapProtos.MonsterStatus[] 

---@class MapProtos.RoundNpc
---@field id number 
---@field cfgId number 
---@field x number 
---@field y number 
---@field dir number 
---@field iconInfo MapProtos.IconInfo[] @顶戴花翎信息(GM脚本中使用)

---@class MapProtos.RoundStall
---@field id number @ 摊位id(stallId)
---@field x number 
---@field y number 
---@field rid number @ 摊主rid
---@field advertising string @ 摊位广告
---@field holderName string @ 摊主名称
---@field career CommonProtos.Career @ 摊主职业
---@field sex number @ 摊主性别
---@field equip MapProtos.Equip[] @ 摆摊时的装备快照
---@field appearIdx number[] @装备外观：装备索引

---@class MapProtos.NpcEnterViewRes
---@field npc MapProtos.RoundNpc 

---@class MapProtos.NpcRemoveViewRes
---@field npcId number[] 

---@class MapProtos.RoundItem
---@field item CommonProtos.Item 
---@field x number 
---@field y number 
---@field ownerId number[] 
---@field dropTime number @掉落时间
---@field ownerProtectedTime number @归属保护时间(ms)
---@field sourceX number @道具来源x坐标
---@field sourceY number @道具来源y坐标
---@field dropModel number @是否独立掉落：0不独立掉落，1独立掉落

---@class MapProtos.ItemEnterViewRes
---@field roundItem MapProtos.RoundItem 

---@class MapProtos.BuffEnterViewRes
---@field roundBuff BufferProtos.RoundBuff 

---@class MapProtos.StallEnterViewRes
---@field roundStall MapProtos.RoundStall 

---@class MapProtos.UpdateViewRes
---@field removeId number[] 
---@field player MapProtos.RoundPlayer[] 
---@field monster MapProtos.RoundMonster[] 
---@field npc MapProtos.RoundNpc[] 
---@field roundItem MapProtos.RoundItem[] 
---@field roundBuff BufferProtos.RoundBuff[] 
---@field roundStall MapProtos.RoundStall[] 

---@class MapProtos.MapObjectExitViewRes
---@field id number 

---@class MapProtos.PlayerReliveReq
---@field type number 
---@field reviveType number 

---@class MapProtos.SwitchFightModelReq
---@field fightModel number 

---@class MapProtos.DeliverByConfigReq
---@field cfgId number 

---@class MapProtos.HpMpChangeRes
---@field id number 
---@field hp number 
---@field mp number 
---@field type number 
---@field maxHp number 
---@field maxMp number 
---@field casterId number @如果掉血是被溅射伤害，则返回造成伤害者的ID

---@class MapProtos.ShieldChangeRes
---@field id number 
---@field shield number 
---@field type number 
---@field maxShield number 

---@class MapProtos.AgstoChangeRes
---@field id number 
---@field agsto number 
---@field type number 
---@field maxAgsto number 

---@class MapProtos.PickUpMapItemReq
---@field roundItemId number 
---@field pickUpType number @拾取类型 0 走过去拾取 1 范围拾取

---@class MapProtos.NoticeBean
---@field updateType number @ NoticeUpdateType
---@field updateValue number @更新值
---@field updateName string @更新值(字符串)

---@class MapProtos.NoticeViewTypeInfoRes
---@field id number 
---@field updateList MapProtos.NoticeBean[] @更新列表

---@class MapProtos.FightAttrInfoRes
---@field id number 
---@field fightAttribute CommonProtos.FightAttribute[] 
---@field type number @0:同步所有属性，1：同步部分属性
---@field noTip boolean @ 不提示属性变化信息，默认提示

---@class MapProtos.UpdateEquipRes
---@field id number @id
---@field equip MapProtos.Equip 
---@field reason number @变化原因 参考 equip.EquipChangeReason

---@class MapProtos.EquipAppearRes
---@field id number @id
---@field appearIdx number[] 

---@class MapProtos.TransferPointReq
---@field id number @传送公式表ID

---@class MapProtos.TransferToNpc
---@field npcId number @NPC配置表ID
---@field displayPanel boolean @是否显示面板 T:显示

---@class MapProtos.RandomTransportReq
---@field mapId number @地图ID

---@class MapProtos.CustomizeTransportReq
---@field id number @根据不同类型，ID代表不同含义
---@field x number 
---@field y number 
---@field rang number @传送点范围
---@field type number @传送类型
---@field line number 

---@class MapProtos.TransferResult
---@field type number @传送表类型
---@field cfgId number @传送配置ID
---@field result boolean @传送结果
---@field message string @失败原因

---@class MapProtos.FocusMapObjReq

---@class MapProtos.NoticeFocusMapObj

---@class MapProtos.MapObjInfoReq
---@field id number 

---@class MapProtos.MapObjInfoRes
---@field monster MapProtos.RoundMonster 
---@field player MapProtos.RoundPlayer 
---@field npc MapProtos.RoundNpc 

---@class MapProtos.BossOwnerRes
---@field roundMonster MapProtos.RoundMonster 

---@class MapProtos.AutoPathfindingRes
---@field x number 
---@field y number 

---@class MapProtos.AutoPathfindingReq
---@field x number 
---@field y number 

---@class MapProtos.KillMobAtPointRes
---@field mapId number 
---@field x number 
---@field y number 
---@field range number 
---@field monsterNames string[] 

---@class MapProtos.VibrationInfo
---@field level number @震动级别
---@field count number @震动次数

---@class MapProtos.LineInfo
---@field line number @线
---@field roleCount number @人数

---@class MapProtos.MapLinesInfo
---@field lineInfo MapProtos.LineInfo[] 
---@field thisLine number @当前地图分线

---@class MapProtos.NpcTransferReq
---@field id number @传送公式表ID
---@field line number @线

---@class MapProtos.MonsterBtTransformRes
---@field monsterId number 
---@field modelId number @怪物模型ID
---@field size number @尺寸（万分比）

---@class MapProtos.MonsterBtAudioRes
---@field monsterId number 
---@field audioId number @音效表ID
---@field vol number @音量(万分比)

---@class MapProtos.MonsterBtAnimationRes
---@field monsterId number 
---@field name string @怪物状态机上动画的名称
---@field type number @0保持动画最后一帧，永久持续 , 1动画播放完成结束，持续时间为动画的时长 , 2动画循环播放，永久持续
---@field action number @0：默认情况，1：怪物吟唱动画
---@field skillAreaId number @cfg_monster_skillArea表的ID，使客户端知道动画播放过后会使用哪个技能攻击（通常是action=1的时候会带上这个参数）
---@field targetId number @攻击目标的ID，使客户端知道攻击目标，以放变实现技能范围显示（通常是action=1的时候会带上这个参数）

---@class MapProtos.HangUpPoint
---@field mapId number 
---@field x number 
---@field y number 
---@field line number 
---@field mongenId number 

---@class MapProtos.LastHangUpPointReq
---@field mapId number 
---@field line number 

---@class MapProtos.DieInfo
---@field dieCount number 
---@field buyCount number @付费次数

---@class MapProtos.CanTransferReq
---@field id number @传送公式表ID
---@field line number @线

---@class MapProtos.CanTransferFlagRes
---@field flag boolean @可以传送标志true：可传送；false：不可传送

---@class MapProtos.GuardPickItemReq
---@field itemId number 

---@class MapProtos.GuardPickItemRes
---@field rid number 
---@field itemId number 

---@class MapProtos.GuardPickUpItemReq
---@field ownerId number @拾取者id
---@field itemId number 
---@field type number 

---@class MapProtos.MonsterDieInfo
---@field id number @怪物唯一id
---@field monsterId number @monster表id
---@field reliveTime number @复活时间
---@field pointX number @X坐标
---@field pointY number @Y 坐标

---@class MapProtos.RobberyModeSkilledRes
---@field showText string @显示文本

