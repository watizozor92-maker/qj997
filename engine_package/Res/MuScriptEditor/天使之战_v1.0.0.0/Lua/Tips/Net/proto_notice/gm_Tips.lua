--工具自动生成
---@class GmProtos.ExecGMReq
---@field command string @执行请求

---@class GmProtos.ExecGMRes
---@field ret string @返回结果

---@class GmProtos.ServerLogRes
---@field tag string @内容
---@field lines string[] @每行信息

---@class GmProtos.createRobotOrMonsterRes
---@field id number 
---@field x number 
---@field y number 

---@class GmProtos.PathItem
---@field path string @路径(文件夹或者文件名称)
---@field name string 
---@field type number @类型，0：文件夹，1：文件
---@field children GmProtos.PathItem[] 

---@class GmProtos.ScriptPath
---@field root GmProtos.PathItem 

---@class GmProtos.BreakPointState
---@field scriptKey string 
---@field lineNum number 
---@field state number 
---@field logs GmProtos.BreakPointLog[] 
---@field stackTrace GmProtos.BreakPointStackTrace[] 

---@class GmProtos.BreakPointStackTrace
---@field scriptKey string 
---@field token string 
---@field lineNum number 

---@class GmProtos.BreakPointLog
---@field id number 
---@field funcName string 
---@field stmt string 
---@field message string 
---@field lineNum number 
---@field level number 

