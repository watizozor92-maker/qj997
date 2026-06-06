--工具自动生成
---@class CommonProtos.FightSkill
---@field skillId number 
---@field level number 
---@field skillPoint number @技能点：升级需要判定

---@class CommonProtos.FightAttribute
---@field type number @属性类型
---@field num number @属性值

---@class CommonProtos.MasterLevel
---@field wearBar number @ 穿戴栏
---@field num number @ 等级

---@class CommonProtos.MasterAttrInfo
---@field id number @equip_master表id
---@field isLock boolean @是否上锁
---@field fightAttribute CommonProtos.FightAttribute[] @属性信息

---@class CommonProtos.FightPosAttribute
---@field type number @属性类型
---@field num number @属性值
---@field pos number @所在坑位
---@field level number @属性等级

---@class CommonProtos.CustomizeAttribute
---@field attribute CommonProtos.FightPosAttribute 
---@field color number @属性颜色
---@field isPercentage boolean @是否百分比
---@field showId number @ 显示Id

---@class CommonProtos.FightInfo
---@field fightAttribute CommonProtos.FightAttribute[] @属性信息

---@class CommonProtos.ExtraAttr
---@field column number[] @额外属性列信息
---@field luckyNumber number @幸运值
---@field extraAttrLevel number @等级
---@field attGroup number @属性分组
---@field strengthenGroup number @属性强化组id
---@field qualityCoefficient double @ 品质系数
---@field entryAttrCopy CommonProtos.EntryAttrCopy[] @额外属性生成的卓越属性的copy

---@class CommonProtos.EntryAttrCopy
---@field number number @第几条卓越属性
---@field attrUnit CommonProtos.AttrUnit @卓越属性

---@class CommonProtos.AttrUnit
---@field type number 
---@field num number 
---@field starLv number 

---@class CommonProtos.EquipEntryAttrVo
---@field type number @词条类型
---@field num number @属性值
---@field pos number @所在坑位
---@field level number @属性等级
---@field entryId number @ 词条来源
---@field increaseTimes number @增益次数
---@field initNum number @基础属性值

---@class CommonProtos.EquipExtInfo
---@field level number @等级
---@field strengthen number @强化
---@field append number @追加
---@field score number @初始评分
---@field grade number @品阶
---@field autoAttr CommonProtos.FightAttribute[] @自定义扩展属性
---@field additionalAttr CommonProtos.FightAttribute[] @附加属性
---@field entryAttr CommonProtos.EquipEntryAttrVo[] @词条属性
---@field durable number @装备耐久度
---@field swimFlag boolean @游泳标识
---@field runFlag boolean @奔跑标识
---@field flyFlag boolean @飞行标识
---@field gemSubType number @宝石子类型
---@field extraAttrs CommonProtos.ExtraAttr[] @额外属性信息
---@field remainExp number @宝石的剩余经验
---@field strengthenActivate CommonProtos.ActivateAttr[] @强化手动激活属性
---@field appendActivate CommonProtos.ActivateAttr[] @追加手动激活属性
---@field luckAttrs CommonProtos.LuckAttrs[] @幸运属性
---@field initScore number @战力初始评分
---@field godLv number @装备神化等级
---@field runeBaseAttr CommonProtos.FightAttribute[] @符文基础属性
---@field runeSpecialAttr CommonProtos.FightAttribute[] @符文特殊属性
---@field runeOfStrength CommonProtos.FightAttribute[] @符文之力
---@field entryGrade number @词条潜能对应的词条品阶
---@field attrsOfEntryPotential CommonProtos.FightAttribute[] @词条潜能对应的属性
---@field gradeAttr CommonProtos.FightAttribute[] @装备基础属性
---@field feedLevel number @喂养等级
---@field originMagicAttrs CommonProtos.FightAttribute[] @魔法属性
---@field regenerateToAttr CommonProtos.FightAttribute[] @再生属性
---@field currentExperience number @当前等级经验

---@class CommonProtos.ActivateAttr
---@field level number @等级
---@field type number @属性类型
---@field num number @属性值

---@class CommonProtos.LuckAttrs
---@field type number @属性类型
---@field num number @属性值

---@class CommonProtos.InitEntryAttrs
---@field type number @属性类型
---@field num number @属性值

---@class CommonProtos.GradeToAttr
---@field type number @属性类型
---@field num number @属性值

---@class CommonProtos.InitAttrsCopy
---@field type number @属性类型
---@field num number @属性值

---@class CommonProtos.GemExtInfo
---@field skillInfo CommonProtos.EquipSkillInfo[] @装备技能

---@class CommonProtos.EquipSkillInfo
---@field skillId number 
---@field skillLv number 

---@class CommonProtos.ItemExtInfo
---@field equipExtInfo CommonProtos.EquipExtInfo @装备
---@field gemExtInfo CommonProtos.GemExtInfo @装备技能

---@class CommonProtos.RoleBaseInfo
---@field name string 
---@field career number 
---@field sex number 
---@field level number 

---@class CommonProtos.ItemGmExt
---@field nameColor number @道具名字颜色
---@field name string @道具名字
---@field sweepLevel number @扫光等级
---@field gemInfo CommonProtos.GmGemInfo[] @宝石信息
---@field strengthen number @强化标识
---@field append number @追加标识
---@field strengthenAttr CommonProtos.FightAttribute[] @强化属性
---@field appendAttr CommonProtos.FightAttribute[] @追加属性
---@field customizeInfo CommonProtos.CustomizeInfo[] @自定义属性信息
---@field field number @外观模型ID
---@field shape number @内观模型ID
---@field effectId number @内观特效ID
---@field wearLimit CommonProtos.FightAttribute[] @穿戴限制

---@class CommonProtos.CustomizeInfo
---@field sortPos number @分类位置
---@field sortName string @自定义属性分类名字
---@field sortNameColor number @分类名称颜色
---@field customAttr CommonProtos.CustomizeAttribute[] @自定义属性

---@class CommonProtos.GmGemInfo
---@field gemPos number 
---@field gemItem CommonProtos.Item 

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
---@field tradeLimitTime number @九九交易行购买的物品，可上架时间限制

---@class CommonProtos.IntTupleBean
---@field first number 
---@field second number 

---@class CommonProtos.TupleBean
---@field first string 
---@field second string 

---@class CommonProtos.Career
---@field baseCareer number @ 根职业
---@field careerRank number @ 职业等级
---@field careerNum number @ 职业编号

