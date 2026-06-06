--工具自动生成
---@class DupHelpFightProtos.HelpFightListRes
---@field helpFightInfo DupHelpFightProtos.HelpFightInfo[] 
---@field cachet number @声望

---@class DupHelpFightProtos.HelpFightInfo
---@field career number @职业
---@field name string @名称
---@field level number @等级
---@field curBoosId number @通用boss表id
---@field activityId number @活动id
---@field rid number 
---@field x number 
---@field y number 

---@class DupHelpFightProtos.SeekHelpReq
---@field curBoosId number 

---@class DupHelpFightProtos.GoToHelpReq
---@field helpId number @发起助战的角色id
---@field curBoosId number @通用boss表id

---@class DupHelpFightProtos.HelpScoreListRes
---@field scoreInfo DupHelpFightProtos.HelpScoreInfo[] 

---@class DupHelpFightProtos.HelpScoreInfo
---@field name string 
---@field score number 

---@class DupHelpFightProtos.ThankLetterRes
---@field helperInfo DupHelpFightProtos.HelpRoleInfo[] 
---@field boosName string 
---@field boosLevel number 
---@field type number @1:黄金boss 2:卓越boss
---@field activityId number 

---@class DupHelpFightProtos.HelpRoleInfo
---@field career number @职业id
---@field name string @名称
---@field level number @等级
---@field rid number 

---@class DupHelpFightProtos.SendThankLetterReq
---@field rids number[] 
---@field type number @1:卓越boss 2:黄金boss
---@field text string @文本
---@field activityId number 
---@field index number 

---@class DupHelpFightProtos.SendThankLetterRes
---@field helpRoleInfo DupHelpFightProtos.HelpRoleInfo 
---@field type number @1:黄金boss 2:卓越boss
---@field text string 

---@class DupHelpFightProtos.GetLetterRewardReq
---@field type number @1:黄金boss 2:卓越boss

---@class DupHelpFightProtos.GotoHelpRes
---@field career number @职业id
---@field name string 
---@field curBoosId number 
---@field x number 
---@field y number 

---@class DupHelpFightProtos.UseLetterReq
---@field index number 

