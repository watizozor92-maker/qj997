---@class KLUIExpMessagePanel:UIKmlLuaPanelBase
---@field view KLUIExpMessagePanelView
local KLUIExpMessagePanel = class(UIKmlLuaPanelBase)
local this =KLUIExpMessagePanel
---创建时调用一次
function this:Init()
	SL:KeepOpenPanel("KLUIExpMessagePanelKml",true)
end

---创建或者刷新界面数据时调用
function this:Refresh()

end

---注册UI事件和服务器消息
function this:RegistEvents()
	SL:RegisterLuaNetMsg(LuaMessageIdToClient.BOBBLE_POINT_SHOW,self.BubbleExpMsg,self)
end

---@param message {exp:number,expAddRate:number,fromType:number 是否泡点}
function this:BubbleExpMsg(_,message)
	if message then
		local text
		if message.fromType == 1 then
			return
			--  text = string.format("*#EXP %d(+%d%%)",message.exp,math.floor(message.expAddRate/100 + 0.5),"%")
		else
			text = string.format("EXP %d(+%d%%)",message.exp,math.floor(message.expAddRate/100 + 0.5),"%")
		end
		
		SL:ExpTipMessage(text,nil,nil,2.5)
	end
	
end

function this:Close()
end

return this

