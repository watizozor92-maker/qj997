--工具自动生成
---@class EquipProto.EquipIndex
---@field index number @装备部位
---@field equip CommonProtos.Item 

---@class EquipProto.AllEquipRes
---@field equipIndex EquipProto.EquipIndex[] @所有的基础装备信息

---@class EquipProto.PutOnTheEquipReq
---@field lid number @ rid 或者 宝宝等id，扩展使用
---@field indexOfEquip number @装备位置
---@field index number @道具index

---@class EquipProto.PutOnTheEquipRes
---@field lid number @ rid 或者 宝宝等id，扩展使用
---@field putOn EquipProto.EquipIndex @穿上的装备

---@class EquipProto.TakeOffEquipReq
---@field lid number @ rid 或者 宝宝等id，扩展使用
---@field index number @位置

---@class EquipProto.TakeOffEquipRes
---@field lid number @ rid 或者 宝宝等id，扩展使用
---@field takeOff EquipProto.EquipIndex 

---@class EquipProto.FashionEquip
---@field pos number 
---@field item CommonProtos.Item[] 

---@class EquipProto.PutOnTheFashionEquipReq

---@class EquipProto.PutOnTheFashionEquipRes

---@class EquipProto.TakeOffFashionEquipReq

---@class EquipProto.TakeOffFashionEquipRes

---@class EquipProto.ActiveFashionReq
---@field bagIdx number @背包索引

---@class EquipProto.ActiveFashionRes
---@field bagIdx number @背包索引
---@field equipIdx number @装备索引

---@class EquipProto.StrengthFashionReq
---@field itemId number @背包索引

---@class EquipProto.FashionChangeRes
---@field fashions EquipProto.FashionEquip[] 

---@class EquipProto.StrengthFashionRes
---@field pos number 
---@field item CommonProtos.Item 
---@field ret boolean @成功 true

---@class EquipProto.EquipStrengthenReq
---@field index number @穿戴索引

---@class EquipProto.EquipStrengthenRes
---@field index number @穿戴索引
---@field oldLv number @原来的等级
---@field newLv number @new等级

---@class EquipProto.EquipStrengthen2Req
---@field equipIndex number @主装备索引
---@field auxiliaryMaterials EquipProto.Materials[] @辅助材料

---@class EquipProto.EquipStrengthen2Res
---@field equipIndex number @索引
---@field oldLv number @原来的等级
---@field newLv number @new等级

---@class EquipProto.EquipAppendReq
---@field index number @装备索引

---@class EquipProto.EquipAppendRes
---@field index number @装备索引
---@field oldLv number @原来的等级
---@field newLv number @new等级

---@class EquipProto.EquipAppend2Req
---@field index number @装备索引
---@field auxiliaryMaterials EquipProto.Materials[] @辅助材料

---@class EquipProto.EquipAppend2Res
---@field index number @装备索引
---@field oldLv number @原来的等级
---@field newLv number @new等级

---@class EquipProto.EquipTransferReq
---@field fromIndex number @原始索引：装备或者背包
---@field toIndex number @目标索引：装备或者背包
---@field appendFlag number @0 不转移 1转移
---@field strengthenFlag number @0 不转移 1转移

---@class EquipProto.EquipTransferRes
---@field fromItem CommonProtos.Item 
---@field toItem CommonProtos.Item 
---@field reqData EquipProto.EquipTransferReq 

---@class EquipProto.EquipOverlayReq
---@field mainIndex number @主装备或者背包索引
---@field costIndex number @副装备或者背包索引
---@field entryAttr EquipProto.LockEntryAttr[] @词条属性
---@field luckyStone EquipProto.CostLuckyStone[] @幸运石

---@class EquipProto.LockEntryAttr
---@field attrId number 
---@field attrValue number 
---@field attrPos number 
---@field level number 

---@class EquipProto.CostLuckyStone
---@field cfgId number 
---@field count number 

---@class EquipProto.EquipOverlayRes
---@field costIndex number @装备或者背包索引
---@field mainEquip CommonProtos.Item 
---@field isSuccess number @0 叠加失败 1 叠加成功

---@class EquipProto.EquipSynthesis2Req
---@field formulaId number @合成公式Id;
---@field mainSynMaterials EquipProto.Materials[] @主材料信息;
---@field auxiliarySynMaterials EquipProto.Materials[] @辅助材料信息;

---@class EquipProto.Materials
---@field lid number 
---@field count number 

---@class EquipProto.EquipSynthesis2Res
---@field formulaId number @合成公式Id;
---@field isSuccess boolean @合成结果;
---@field item CommonProtos.Item @合成成功的道具

---@class EquipProto.EquipGemPos
---@field equipIndex number @装备索引
---@field gemPos number @宝石部位
---@field item CommonProtos.Item @道具

---@class EquipProto.EquipGemPosUnLock
---@field pos number @装备部位
---@field gemPos number @宝石部位

---@class EquipProto.AllEquipGemRes
---@field equipGemPos EquipProto.EquipGemPos[] @所有的装备宝石

---@class EquipProto.AllEquipGemUnLockRes
---@field equipGemPosUnLock EquipProto.EquipGemPosUnLock[] @所有的装备宝石解锁

---@class EquipProto.PutOnGemReq
---@field lid number @ rid 或者 宝宝等id，扩展使用
---@field equipIndex number @装备索引
---@field idxOfBagItem number @背包道具【宝石】index
---@field gemPos number @ 宝石位置
---@field rank number @宝石阶数

---@class EquipProto.PutOnGemRes
---@field lid number @ rid 或者 宝宝等id，扩展使用
---@field putOn EquipProto.EquipGemPos @穿上的宝石
---@field takeOff EquipProto.EquipGemPos @脱掉的宝石

---@class EquipProto.BatchPutOnGemReq
---@field putOnGemInfos EquipProto.PutOnGemInfo[] @一键镶嵌的所有宝石

---@class EquipProto.PutOnGemInfo
---@field lid number @ rid 或者 宝宝等id，扩展使用
---@field equipIndex number @装备索引
---@field idxOfBagItem number @背包道具【宝石】index
---@field gemPos number @ 宝石位置

---@class EquipProto.BatchPutOnGemRes
---@field putOnGemResults EquipProto.PutOnGemResult[] @一键批量装宝石的结果

---@class EquipProto.PutOnGemResult
---@field lid number @ rid 或者 宝宝等id，扩展使用
---@field putOn EquipProto.EquipGemPos @穿上的宝石
---@field takeOff EquipProto.EquipGemPos @脱掉的宝石

---@class EquipProto.GemStrengthReq
---@field equipIndex number @要强化的宝石的索引
---@field gemPos number @要强化的宝石在部位的哪个孔
---@field idxOfBagItem number[] @给目标宝石强化用到的背包里的宝石索引

---@class EquipProto.GemStrengthRes
---@field oldLevel number @宝石的旧等级
---@field newLevel number @宝石的新等级
---@field remainExp number @剩余经验
---@field equipIndex number @目标宝石的装备索引
---@field gemPos number @要强化的宝石在部位的哪个孔

---@class EquipProto.TakeOffGemReq
---@field lid number @ rid 或者 宝宝等id，扩展使用
---@field equipIndex number @装备索引
---@field gemPos number @ 宝石位置

---@class EquipProto.TakeOffGemRes
---@field lid number @ rid 或者 宝宝等id，扩展使用
---@field takeOff EquipProto.EquipGemPos @脱掉的宝石

---@class EquipProto.MountInfo
---@field mountId number @坐骑Id-cfgId;
---@field mountName string @坐骑名字;
---@field nameColorId number @坐骑名字颜色;
---@field acquireTimeMills number @获得时间
---@field level number @坐骑等级
---@field putOnMountEquips EquipProto.PutOnMountEquip[] @坐骑拥有的装备集合

---@class EquipProto.PutOnMountReq
---@field lid number @ rid 或者 宝宝等id，扩展使用
---@field idxOfBagItem number @背包道具【坐骑】index

---@class EquipProto.TakeOffMountReq
---@field mountId number @坐骑Id

---@class EquipProto.AllMountInfoRes
---@field mountInfo EquipProto.MountInfo[] 
---@field curRideMountId number @当前骑乘坐骑Id 0代表当前坐骑没有骑乘

---@class EquipProto.RideMountReq
---@field targetMountId number 

---@class EquipProto.RideMountRes
---@field rid number 
---@field targetMountId number 

---@class EquipProto.CancelMountReq
---@field targetMountId number 

---@class EquipProto.CancelMountRes
---@field rid number 
---@field targetMountId number 

---@class EquipProto.HideMountReq
---@field rid number 
---@field targetMountId number 
---@field hideType number @0 自动隐藏 1 手动隐藏

---@class EquipProto.HideMountRes
---@field rid number 
---@field targetMountId number 
---@field hideType number 

---@class EquipProto.ExposeMountReq
---@field rid number 
---@field targetMountId number 
---@field exposeType number @0 自动暴露 1 手动暴露

---@class EquipProto.ExposeMountRes
---@field rid number 
---@field targetMountId number 
---@field exposeType number 

---@class EquipProto.MountStoreChangeRes
---@field mountChangeRecord EquipProto.MountChangeRecord[] 

---@class EquipProto.MountChangeRecord
---@field mountId number 
---@field mountInfo EquipProto.MountInfo @为空代表删除

---@class EquipProto.MountRecoverReq
---@field idxOfBagItem number 

---@class EquipProto.MountRecoverRes
---@field itemList CommonProtos.Item[] @分解获得的道具

---@class EquipProto.MountUpStarLvReq
---@field mountId number 
---@field MountUpMaterials EquipProto.MountUpMaterial[] 

---@class EquipProto.MountUpMaterial
---@field itemId number 
---@field count number 

---@class EquipProto.MountUpStarLvRes
---@field oldMountId number @升星前的坐骑id
---@field newMountId number @升星后的坐骑id

---@class EquipProto.PutOnPetReq
---@field idxOfBagItem number @背包道具【召唤兽】index

---@class EquipProto.PutOnPetRes
---@field rid number 
---@field cfgId number @召唤兽道具Id

---@class EquipProto.TakeOffPetReq
---@field petId number @Id

---@class EquipProto.TakeOffPetRes
---@field rid number 
---@field cfgId number @召唤兽道具Id

---@class EquipProto.FightPetReq
---@field targetPetId number 

---@class EquipProto.FightPetRes
---@field rid number 
---@field targetPetId number 

---@class EquipProto.CancelFightPetReq
---@field targetPetId number 

---@class EquipProto.CancelFightPetRes
---@field rid number 
---@field targetPetId number 

---@class EquipProto.OperatePetReq
---@field targetPetId number 
---@field type number @操作类型，1：隐藏召唤兽，2：显示召唤兽

---@class EquipProto.OperatePetRes
---@field targetPetId number 
---@field type number @操作类型，1：隐藏召唤兽，2：显示召唤兽
---@field ok boolean @操作是否成功

---@class EquipProto.OpenLooksPanelReq

---@class EquipProto.OpenLooksPanelRes

---@class EquipProto.EquipStrengthenExtraAttReq
---@field lid number @装备id
---@field attGroup number @属性分组
---@field bagIndexs number[] @背包道具
---@field buyItemIds number[] @购买道具

---@class EquipProto.EquipStrengthenExtraAttRes
---@field oldLv number @原来的等级
---@field newLv number @new等级
---@field targetEquip CommonProtos.Item @目标装备

---@class EquipProto.EquipRefineQualityExtraAttReq
---@field lid number @装备id
---@field attGroup number @属性分组

---@class EquipProto.EquipRefineQualityExtraAttRes
---@field targetEquip CommonProtos.Item @洗练目标装备

---@class EquipProto.EquipTransferExtraAttReq
---@field originalEquipLid number @原始装备
---@field targetEquipLid number @目标装备
---@field attGroup number @属性分组

---@class EquipProto.EquipTransferExtraAttRes
---@field originalEquip CommonProtos.Item @转移原始装备
---@field targetEquip CommonProtos.Item @转移目标装备
---@field attGroup number @属性分组

---@class EquipProto.MasterInfoReq
---@field type number @大师类型

---@class EquipProto.MasterInfo
---@field type number @大师类型
---@field isAll boolean @穿戴栏是否是0
---@field masterAttrInfo CommonProtos.MasterAttrInfo[] @属性信息

---@class EquipProto.MasterActivateReq
---@field masterId number @equip_master表id
---@field fightAttribute CommonProtos.FightAttribute[] @属性信息

---@class EquipProto.MasterActivateRes
---@field isSuccess boolean @激活结果;

---@class EquipProto.MasterChange
---@field type number @大师类型
---@field masterId number @equip_master表id
---@field isLock boolean @是否上锁
---@field fightAttribute CommonProtos.FightAttribute[] @属性信息

---@class EquipProto.MasterChangeRes
---@field masterChange EquipProto.MasterChange[] @大师信息

---@class EquipProto.UpdateMasterRes
---@field masterType number[] @大师类型

---@class EquipProto.EquipPurchaseListReq
---@field lid number @装备id
---@field attGroup number @属性分组

---@class EquipProto.EquipPurchaseListRes
---@field lid number @装备id
---@field attGroup number @属性分组
---@field isSuccess boolean @是否可以一键购买
---@field buyItemInfo EquipProto.BuyItemInfo[] @购物清单

---@class EquipProto.BuyItemInfo
---@field costInfo EquipProto.CostInfo @购买成本
---@field item CommonProtos.Item 

---@class EquipProto.CostInfo
---@field cost number @需要金币
---@field lid number @itemId

---@class EquipProto.EquipExtraAttPurchaseError
---@field error string @失败原因

---@class EquipProto.GuardProgressReq
---@field lid number @itemId

---@class EquipProto.GuardAwakeningReq
---@field lid number @itemId

---@class EquipProto.GuardHeightSucRes
---@field isSuc boolean @是否成功

---@class EquipProto.StrengthenManualActivateReq
---@field index number @穿戴索引
---@field level number @激活等级

---@class EquipProto.AppendManualActivateReq
---@field index number @穿戴索引
---@field level number @激活等级

---@class EquipProto.ManualActivateRes
---@field isOk boolean 
---@field item CommonProtos.Item 

---@class EquipProto.TransferAttReq
---@field originalEquipIdx number @原始装备的装备索引
---@field targetEquipBagIdx number @目标装备的背包索引

---@class EquipProto.TransferAttRes
---@field targetEquip CommonProtos.Item @属性转移之后的目标装备
---@field autoTransfer boolean @是否为自动属性转移
---@field originalEquip CommonProtos.Item @属性转移的原始装备

---@class EquipProto.LuckInlayReq
---@field equipIdx number @幸运镶嵌的装备索引

---@class EquipProto.LuckInlayRes
---@field equip CommonProtos.Item @幸运镶嵌之后的装备

---@class EquipProto.EquipBarAttrRes
---@field id number @玩家id
---@field allEquipBarAttr EquipProto.AllEquipBarAttr[] 

---@class EquipProto.AllEquipBarAttr
---@field equipBarType number @装备栏类型 0：零转 1：一转 2：二转 3：三转 4：四转
---@field attribute EquipProto.Attribute[] 

---@class EquipProto.Attribute
---@field attrType number @属性类型
---@field attrNum number @属性数值

---@class EquipProto.EquipBarAttrReq
---@field id number @需要查看的玩家id

---@class EquipProto.EquipIncreaseReq
---@field idx number @背包中的装备
---@field pos number[] @增幅词条坑位

---@class EquipProto.EquipInheritanceReq
---@field idx number[] @背包中的装备

---@class EquipProto.EquipFusionReq
---@field idx number[] @背包中的装备

---@class EquipProto.EquipFusionRes
---@field fusionEquip CommonProtos.Item @预览待确认的装备

---@class EquipProto.EquipFusionOkReq
---@field idx number[] @背包中的装备
---@field isOk number @确认熔合（1），重置不需要发送请求

---@class EquipProto.EquipFusionOkRes
---@field fusionEquip CommonProtos.Item @熔合后的装备

---@class EquipProto.EquipIncreaseOkRes
---@field equip CommonProtos.Item @装备增幅

---@class EquipProto.EquipInheritanceOkRes
---@field equip CommonProtos.Item @装备传承

---@class EquipProto.EquipChangeRes
---@field equipList EquipProto.EquipIndex[] 

---@class EquipProto.UpEquipGodLvReq
---@field index number @穿戴索引

---@class EquipProto.UpEquipGodLvRes
---@field index number @穿戴索引
---@field oldLv number @原来的等级
---@field newLv number @new等级

---@class EquipProto.MountStrengthReq
---@field mountId number @坐骑的id，对应mount表的主键

---@class EquipProto.MountStrengthRes
---@field mountId number @强化升级成功之后，返回的坐骑id
---@field level number @强化升级之后对应的坐骑等级

---@class EquipProto.PutOnTheMountEquipReq
---@field putOnMountEquipInfo EquipProto.PutOnMountEquipInfo[] @穿戴的坐骑装备信息
---@field mountId number @要给哪个坐骑装备装备？这里是坐骑的mountId,对应mount表的主键id

---@class EquipProto.PutOnMountEquipInfo
---@field bagIdx number @坐骑装备在背包中的索引
---@field pos number @坐骑装备在坐骑上对应的穿戴部位

---@class EquipProto.PutOnTheMountEquipRes
---@field putOnMountEquip EquipProto.PutOnMountEquip[] @已经成功给坐骑穿上的装备的信息
---@field mountId number @给哪个坐骑穿装

---@class EquipProto.PutOnMountEquip
---@field mountEquip CommonProtos.Item @穿上的装备
---@field pos number @穿上的装备对应的部位

---@class EquipProto.PutOnTheMountEquipOneReq
---@field bagIdx number @给坐骑穿戴的装备在背包中的索引
---@field mountId number @要给哪个坐骑装备装备？这里是坐骑的mountId,对应mount表的主键id
---@field pos number @穿戴的部位

---@class EquipProto.PutOnTheMountEquipOneRes
---@field mountEquip CommonProtos.Item @成功给坐骑穿上的装备信息
---@field mountId number @给哪个坐骑穿装
---@field pos number @穿戴的部位

---@class EquipProto.TakeOffTheMountEquipReq
---@field mountId number @一键拆卸的是哪个坐骑的装备，这里是坐骑mountId

---@class EquipProto.TakeOffTheMountEquipRes
---@field mountId number @一键拆卸的坐骑id

---@class EquipProto.TakeOffTheMountEquipOneReq
---@field pos number @脱下的单个装备的装备位
---@field mountId number @坐骑的id

---@class EquipProto.TakeOffTheMountEquipOneRes
---@field pos number @脱下的单个装备的部位
---@field mountId number @坐骑的id

---@class EquipProto.MountAttributeRes
---@field mountAttrs CommonProtos.FightAttribute[] @当前角色的所有坐骑属性

---@class EquipProto.RoleRuneRes
---@field rune MapProtos.Rune @角色符文

---@class EquipProto.UnLockRunePlateReq

---@class EquipProto.PourSoulReq
---@field hole number @第几个孔位

---@class EquipProto.IdentifyRuneReq
---@field bagIdx number @背包索引

---@class EquipProto.SuccinctReq
---@field bagIdx number @要洗练的符文的背包索引
---@field lockedAttrIds number[] @符文上锁了的基础属性id，这些基础属性不能洗练

---@class EquipProto.SuccinctRes
---@field runeBaseAttrs CommonProtos.FightAttribute[] @符文基础属性
---@field runeSpecialAttrs CommonProtos.FightAttribute[] @符文特殊属性
---@field runeOfStrength CommonProtos.FightAttribute[] @符文之力属性

---@class EquipProto.GiveUpSuccinctReq
---@field bagIdx number @符文对应的背包索引

---@class EquipProto.SaveSuccinctReq
---@field bagIdx number @符文对应的背包索引

---@class EquipProto.PutOnRuneReq
---@field num number @第几套符文盘
---@field hole number @第几个孔位
---@field bagIdx number @符文在背包中的索引

---@class EquipProto.TakeOffRuneReq
---@field num number @第几套符文盘
---@field hole number @第几个孔位

---@class EquipProto.AddRunePlateReq

---@class EquipProto.RuneAttrRes
---@field runeAttrs CommonProtos.FightAttribute[] @符文全部属性

---@class EquipProto.SaveRuneSuccinctRes
---@field bagIdx number @符文背包索引
---@field runeItem CommonProtos.Item @洗练之后的符文信息

---@class EquipProto.SwitchRunePlateReq
---@field num number @切换成第几套符文盘

---@class EquipProto.EntryPotentialActiveReq
---@field bagIdx number @装备背包索引

---@class EquipProto.EntryPotentialActiveRes
---@field bagIdx number @装备背包索引
---@field equip CommonProtos.Item @激活后的装备信息

---@class EquipProto.BrightSuccinctReq
---@field bagIdx number @装备背包索引

---@class EquipProto.BrightSuccinctRes
---@field entryGradeAfterSuccinct number @洗练之后的词条品阶
---@field attrsAfterSuccinct CommonProtos.FightAttribute[] @洗练之后重新生成的词条属性

---@class EquipProto.EntryPotentialSuccinctReq
---@field bagIdx number @装备背包索引

---@class EquipProto.EntryPotentialSuccinctRes
---@field entryGradeAfterSuccinct number @洗练之后的词条品阶
---@field attrsAfterSuccinct CommonProtos.FightAttribute[] @洗练之后重新生成的词条属性

---@class EquipProto.EntryPotentialGiveUpSuccinctReq
---@field bagIdx number @装备背包索引

---@class EquipProto.EntryPotentialSaveSuccinctReq
---@field bagIdx number @装备背包索引

---@class EquipProto.EntryPotentialSaveSuccinctRes
---@field bagIdx number @装备背包索引
---@field equip CommonProtos.Item @洗练之后的装备信息

---@class EquipProto.GradeAttrChangeRes
---@field index number @穿戴索引
---@field gradeAttr CommonProtos.FightAttribute[] @装备基础属性

---@class EquipProto.LuaExtDataChange
---@field itemId number @道具唯一Id
---@field luaExtData string @最新扩展数据

---@class EquipProto.CanTransferAttr
---@field oldItem CommonProtos.Item @原始装备
---@field newItem CommonProtos.Item @新装备

