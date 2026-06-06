--工具自动生成
---@class PartnerProto.AllPartnerInfoRes
---@field manuallyUnLockSlot number[] @已手动解锁的阵容槽位(不包括本就是解锁的槽)
---@field arrayMasterInfo PartnerProto.ArrayMasterInfo @阵容大师信息

---@class PartnerProto.PartnerInfo
---@field id number 
---@field cfgId number 
---@field fightState number @ 0:空闲 1:出战 2:助战
---@field slot number @槽位
---@field score number @评分
---@field level number @等级
---@field exp number @当前经验
---@field starLevel number @星级
---@field breakLevel number @突破等级
---@field advanceLevel number @进阶等级
---@field lock boolean @是否锁定
---@field acquireTime number @获取时间
---@field aptitudes PartnerProto.Aptitude[] @资质(总值)
---@field aptitudeDiff PartnerProto.Aptitude[] @ 洗髓资质变化值
---@field undeterminedAptitude PartnerProto.Aptitude[] @待确认的洗髓结果
---@field isResonance boolean @是否处于共鸣状态，等级提升至最低的出战位伙伴等级(助战位伙伴专用)
---@field isResonanceTarget boolean @是否是被共鸣的目标，等级会被助战位上的伙伴引用（出战位伙伴专用）

---@class PartnerProto.Aptitude
---@field id number @资质id
---@field value number @资质值

---@class PartnerProto.UnLockPartnerSlot
---@field id number @阵容槽位id

---@class PartnerProto.ConfirmWashingResultReq
---@field partnerId number 
---@field save boolean @ true:保存 false:取消

---@class PartnerProto.LoadOrUnloadPartnerReq
---@field id number @伙伴id
---@field slot number @上阵所选槽位(为空表示卸下)

---@class PartnerProto.ArrayMasterInfo
---@field arrayMasterLv number 
---@field arrayAttr PartnerProto.ArrayAttr[] @附加属性

---@class PartnerProto.ArrayAttr
---@field attrId number @属性id
---@field value number @ 属性值

---@class PartnerProto.LockOrUnlockPartnerReq
---@field partnerId number 

---@class PartnerProto.ResetPartnerReq
---@field partnerId number 

---@class PartnerProto.UpgradePartnerReq
---@field partnerId number 

---@class PartnerProto.EvolvePartnerReq
---@field partnerId number 
---@field evolveType number @ 1:突破 2：进阶

---@class PartnerProto.UpPartnerStarLvReq
---@field partnerId number @升星伙伴ID
---@field selfMaterialCost number[] @本体材料消耗(partnerId)
---@field campMaterialCost number[] @同阵营材料消耗(partnerId)
---@field anyMaterialCost number[] @任意材料消耗(partnerId)

---@class PartnerProto.FastPartnerUpStarLvReq
---@field upPartnerStarLvReq PartnerProto.UpPartnerStarLvReq[] @ 请求快捷升星的伙伴Id列表

---@class PartnerProto.FastPartnerUpStarLvRes
---@field partnerId number[] @ 快捷升星后获得的伙伴
---@field returnItem PartnerProto.ReturnItem[] @ 返还的道具

---@class PartnerProto.PartnerLevelUpReq
---@field partnerId number 
---@field number number @升几级

---@class PartnerProto.WashingPartnerReq
---@field partnerId number 
---@field number number @ 洗髓次数

---@class PartnerProto.PartnerStarLvUpRes
---@field fromPartnerCfg number 
---@field toPartnerCfg number 

---@class PartnerProto.PartnerUpdateRes
---@field removePartner number[] @删除的伙伴
---@field newPartner PartnerProto.PartnerInfo[] @新增的伙伴

---@class PartnerProto.ResetReturnReq
---@field partnerId number 

---@class PartnerProto.ResetReturnDetails
---@field returnExp number 
---@field returnItem PartnerProto.ReturnItem[] 

---@class PartnerProto.ReturnItem
---@field itemCfgId number 
---@field count number 

---@class PartnerProto.PartnerChangeRes
---@field partnerChangeRecords PartnerProto.PartnerChangeRecord[] 

---@class PartnerProto.PartnerChangeRecord
---@field partnerId number 
---@field partnerInfo PartnerProto.PartnerInfo @ 为空表示删除

---@class PartnerProto.PartnerTransformReq
---@field mainPartnerId number @需要转化的伙伴ID
---@field subPartnerId number[] @需要转化的子伙伴ID列表

---@class PartnerProto.PartnerTransformRes
---@field mainPartnerId number @转化后的伙伴ID
---@field subPartnerId number[] @转化后的伙伴ID列表

---@class PartnerProto.OperatePartner
---@field partnerId number 

---@class PartnerProto.PartnerRebornRes
---@field newPartnerCfgId number @重生后的伙伴
---@field sourcePartnerId number @原伙伴
---@field transactionId number @事务id

---@class PartnerProto.ConfirmPartnerRebornReq
---@field partnerId number 
---@field transactionId number @事务id
---@field save boolean 

---@class PartnerProto.PartnerRaffleInfoVo
---@field cfgId number @ 配置id
---@field times number @次数： 1 或者 多次
---@field totalTimes number @总次数
---@field lastMills number @上次操作时间
---@field remainTimes number @剩余次数
---@field lastFreeMills number @上次免费执行时间

---@class PartnerProto.PartnerRaffleInfoRes
---@field infos PartnerProto.PartnerRaffleInfoVo[] @抽卡信息
---@field wishCfgId number[] @当前心愿单
---@field boxRewardCfgId number @宝箱领取奖励配置id
---@field lastBuyTipMills number @ 上次购买提醒
---@field buyNoTip boolean @当日不再提示
---@field setCampRes PartnerProto.PartnerRaffleCampRes @设置阵营

---@class PartnerProto.RaffleReward
---@field pos number @位置信息
---@field partnerCfgId number @ 伙伴id
---@field item CommonProtos.Item @ 返还的道具 | 纯道具

---@class PartnerProto.PartnerRaffleRewardRes
---@field infos PartnerProto.PartnerRaffleInfoVo[] @抽卡信息

---@class PartnerProto.PartnerRaffleSubmitReq
---@field cfgId number @ 配置id
---@field times number @次数： 1 或者 多次

---@class PartnerProto.PartnerRaffleSubmitRes
---@field infos PartnerProto.PartnerRaffleInfoVo[] @抽卡信息
---@field reward PartnerProto.RaffleReward[] 

---@class PartnerProto.SetPartnerWishReq
---@field cfgId number[] @卡信息

---@class PartnerProto.ViewPartnerWishRes
---@field cfgId number[] @卡信息

---@class PartnerProto.PartnerRaffleCampInfo
---@field camp number @阵营
---@field lock boolean @未解锁true， 已解锁false

---@class PartnerProto.PartnerRaffleCampRes
---@field info PartnerProto.PartnerRaffleCampInfo[] @卡信息
---@field useSetCamp number @玩家设置阵营
---@field lastSetCampMills number @上次设置阵营时间

---@class PartnerProto.SetPartnerRaffleCampReq
---@field camp number @当前位置
---@field unlock boolean @解锁

---@class PartnerProto.PartnerHatchInfoRes
---@field hatchInfo PartnerProto.HatchInfo[] 
---@field unprompted boolean 

---@class PartnerProto.PartnerRaffleBoxRewardReq

---@class PartnerProto.HatchInfo
---@field slotId number @槽位id
---@field itemId number 
---@field endTime number @结束时间

---@class PartnerProto.PartnerInputEggReq
---@field bagIndex number 

---@class PartnerProto.PartnerInputEggRes
---@field successOrNot boolean 

---@class PartnerProto.AccelerationHatchReq
---@field slot number @孵化槽id
---@field count number 
---@field closePrompt boolean 

---@class PartnerProto.AccelerationHatchRes
---@field successOrNot boolean 
---@field errorType number @错误类型  0：加速材料不足  1：已经孵化完成  2:请求的数量不足以完成孵化

---@class PartnerProto.OpenPartnerEggReq
---@field slot number @孵化槽id

---@class PartnerProto.OpenPartnerEggRes
---@field successOrNot boolean 
---@field rewardInfo PartnerProto.RewardInfo[] 

---@class PartnerProto.RewardInfo
---@field itemcfgId number 
---@field count number 

---@class PartnerProto.PartnerCallReq
---@field partnerId number 

---@class PartnerProto.PartnerCallRes
---@field partnerId number 
---@field ok boolean 
---@field skillCastTime number @上次使用的技能的时间（毫秒值）

---@class PartnerProto.PartnerReCallReq
---@field partnerId number 

---@class PartnerProto.PartnerSkillReq
---@field partnerId number 

---@class PartnerProto.PartnerSkillRes
---@field partnerId number 
---@field ok boolean 

---@class PartnerProto.PartnerRaffleBoxRewardRes
---@field itemList CommonProtos.Item[] 

---@class PartnerProto.PartnerRaffleBuyReq
---@field cfgId number @抽卡配置id
---@field count number @购买数量
---@field noTip boolean @当日不再提示

---@class PartnerProto.PartnerRaffleBuyRes
---@field itemList CommonProtos.Item[] 
---@field lastBuyTipMills number @ 上次购买提醒
---@field buyNoTip boolean @当日不再提示

---@class PartnerProto.RolePartnerInfoReq
---@field rid number @角色id

---@class PartnerProto.RolePartnerInfoRes
---@field totalScore number @伙伴总评分
---@field manuallyUnLockSlot number[] @已手动解锁的阵容槽位(不包括本就是解锁的槽)
---@field arrayMasterInfo PartnerProto.ArrayMasterInfo @阵容大师信息
---@field partnerRecords PartnerProto.PartnerChangeRecord[] @阵容伙伴信息
---@field playerLevel number @玩家等级

