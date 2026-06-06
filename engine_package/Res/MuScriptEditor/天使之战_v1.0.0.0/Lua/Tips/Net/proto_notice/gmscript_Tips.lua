--工具自动生成
---@class GmScriptProtos.GmScriptInfo
---@field tag string @ 脚本唯一标志
---@field content string @ 内容

---@class GmScriptProtos.LoadGmScriptMessageRes
---@field gmScriptInfo GmScriptProtos.GmScriptInfo[] 

---@class GmScriptProtos.InvalidGmScriptMessageRes
---@field tag string 

---@class GmScriptProtos.BindGmScriptMessageRes
---@field tag string @ 脚本唯一标志
---@field uriObj string[] @ 绑定到对象上

---@class GmScriptProtos.UnBindGmScriptMessageRes
---@field uriObj string @绑定到对象上
---@field tag string[] @脚本唯一标志

---@class GmScriptProtos.ClientGMCmd
---@field cmdName string @命令的名称
---@field params string[] @命令的参数

