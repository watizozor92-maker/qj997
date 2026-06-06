--工具自动生成
---@class SkillProtos.UpSkillReq
---@field skillId number 

---@class SkillProtos.SkillChangeRes
---@field skillInfo CommonProtos.FightSkill[] 

---@class SkillProtos.MainSkillRes
---@field skillInfo CommonProtos.FightSkill 

---@class SkillProtos.MasterKillInfo
---@field skillId number @技能ID
---@field skillLevel number @技能等级

---@class SkillProtos.MasterSkillAddTittle
---@field skillId number @ 大师技能ID

---@class SkillProtos.MasterSkill
---@field usedTittle number @已使用点数
---@field info SkillProtos.MasterKillInfo[] @技能等级

---@class SkillProtos.CaromSkill
---@field caromId number[] 

