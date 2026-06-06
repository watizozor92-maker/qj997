--工具自动生成
---@class FightProtos.ObjectDieRes
---@field id number @ 对象id
---@field killerId number @击杀者id

---@class FightProtos.HurtTarget
---@field targetId number 
---@field hp number 
---@field mp number 
---@field buffer BufferProtos.Buff[] 
---@field hurtType number 
---@field x number @测试使用
---@field y number @测试使用
---@field targetName string @测试使用
---@field hate number @ 仇恨值
---@field hpChange number @血量变化， 正表示加数值
---@field shieldChange number @护盾值变化，负表示减数值
---@field delBuffIds number[] @删除buffId
---@field originalHurt number @伤害值（扣血不走这个）。某些特殊情形下，怪物不掉血（hpChange为0），但是伤害值仍旧返回给客户端，做一些显示上的用途，比如展示秒伤效果
---@field effectHurt number @可以造成的一个伤害（策划要求的）
---@field repeats number @重复攻击效果的次数

---@class FightProtos.FightResultRes
---@field skillId number 
---@field skillLv number 
---@field attackerId number 
---@field attackerHp number @释放技能先消耗HP, 这里给到客户端攻击者当前值
---@field attackerMp number @释放技能先消耗MP, 这里给到客户端攻击者当前值
---@field targetId number 
---@field x number 
---@field y number 
---@field target FightProtos.HurtTarget[] 
---@field move BufferProtos.Move[] 
---@field roundBuff BufferProtos.RoundBuff[] 
---@field fightResultType number @FightResultType
---@field attackerName string @测试时候使用攻击名字
---@field riseTime number @测试时候 抬手时间
---@field effectTime number @测试时候 生效时间
---@field clientOrder number @客户端透传参数
---@field itemCfgId number @ FightReq.itemCfgId
---@field caromCfgId number @连击请求时存在
---@field reason number @0：普通（客户端玩家攻击，怪物释放技能），1：服务端触发（玩家被动技能、玩家buffer等）

---@class FightProtos.FightReq
---@field skillId number 
---@field x number @目标位置（这种一般是地面 技能）
---@field y number @目标位置（这种一般是地面 技能）
---@field dir number @方向: 玩家发出技能的方向
---@field targetId number @主目标id（一般是指向性技能）
---@field otherIds number[] @ 副目标id（一般是指向性技能）
---@field clientOrder number @客户端透传参数
---@field time number @当前时间
---@field itemId number @ 技能道具id
---@field itemCfgId number @ 技能道具configId
---@field secondHurt number @秒伤值

---@class FightProtos.CaromReq
---@field skillId number 
---@field x number @目标位置（这种一般是地面 技能）
---@field y number @目标位置（这种一般是地面 技能）
---@field dir number @方向: 玩家发出技能的方向
---@field targetId number @主目标id（一般是指向性技能）
---@field otherIds number[] @ 副目标id（一般是指向性技能）
---@field clientOrder number @客户端透传参数
---@field time number @当前时间
---@field cfgId number @ 连击id

---@class FightProtos.BeSkillReadyRes
---@field skillId number 
---@field skillLv number 

---@class FightProtos.TimesCaromStartRes
---@field cfgId number @cfg_carom配置表id
---@field times number @次数限定
---@field startMills number @开始毫秒
---@field extendLast boolean @是否继承上次
---@field currTime number @当前次数

---@class FightProtos.UpdateComboSkill
---@field skillCfgId number @技能配置id
---@field skillLv number @技能等级

---@class FightProtos.ComboSkillInfoRes
---@field skillCfgId number @技能配置id
---@field skillLv number @技能等级

---@class FightProtos.FightLog
---@field fightLog FightProtos.FightDetailLog[] @战斗日志

---@class FightProtos.FightDetailLog
---@field targetId number @主目标id
---@field targetName string @主目标名称
---@field attackName string @攻击者名称
---@field fightLog string[] @战斗计算详情日志

