--工具自动生成
---@class BufferProtos.RoundBuff
---@field id number @ buff id
---@field cfgId number @配置id
---@field x number 
---@field y number 
---@field endTime number 

---@class BufferProtos.BuffTypeValue
---@field type number 
---@field value string 

---@class BufferProtos.Buff
---@field id number 
---@field cfgId number 
---@field endTime number 
---@field buffJinGuExt BufferProtos.BuffJinGuExt[] @禁锢
---@field skillId number 
---@field buffValue BufferProtos.BuffTypeValue[] 
---@field layers number @层数(默认是1)
---@field totalTime number @总时长（单位毫秒）

---@class BufferProtos.BuffJinGuExt
---@field x number 
---@field y number 
---@field range number 

---@class BufferProtos.AddBufferRes
---@field buff BufferProtos.Buff 
---@field sourceId number @释放者
---@field ownerId number 

---@class BufferProtos.RemoveBufferRes
---@field buffId number 
---@field ownerId number 
---@field buffCfgId number 

---@class BufferProtos.BufferOnceMoveRes
---@field buff BufferProtos.Buff 
---@field move BufferProtos.Move[] 

---@class BufferProtos.BuffSource

---@class BufferProtos.HaloBufferOnceRes
---@field buff BufferProtos.Buff 
---@field x number 
---@field y number 
---@field range number 
---@field buffHurt BufferProtos.BuffHurt[] 

---@class BufferProtos.BufferOnceHurtRes
---@field sourceId number @当非地板 会有一个ID ，表示释放者
---@field buff BufferProtos.Buff 
---@field buffHurt BufferProtos.BuffHurt[] 
---@field ownerId number @buff 拥有者

---@class BufferProtos.BuffHurt
---@field id number 
---@field hp number 
---@field mp number 
---@field hurtType number 

---@class BufferProtos.Move
---@field id number 
---@field x number 
---@field y number 
---@field dir number @id 朝向

---@class BufferProtos.FreeBuffRes
---@field freeBuff BufferProtos.FreeBuff[] 

---@class BufferProtos.FreeBuff
---@field cfgId number 
---@field open boolean 
---@field closeTime number 

