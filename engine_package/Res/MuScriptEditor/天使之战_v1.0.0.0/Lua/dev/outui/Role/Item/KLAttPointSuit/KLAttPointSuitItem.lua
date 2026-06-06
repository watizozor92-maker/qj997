---@class KLAttPointSuitItem:UIKmlLuaPanelBase
---@field view KLAttPointSuitItemView
local KLAttPointSuitItem = class(UIKmlLuaPanelBase)
local this =KLAttPointSuitItem
---创建时调用一次
function this:Init()
    
end

---创建或者刷新界面数据时调用
function this:Refresh()
    local pic = self.args.pic
    local text = self.args.text
    local picInfo = string.split(pic,"#")
    
    GUI:Image_loadTexture(self.view.ImgSuitName,"Texture/" .. picInfo[1] .. ".png","")
    GUI:Image_loadTexture(self.view.ImgSuitPic,"Texture/" .. picInfo[2] .. ".png","")
    GUI:Text_setString(self.view.TextSuitAdvantage,text)
end

function this:BtnChoiceOnClick()
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_SET_ROLE_ATT_ADD_WAY,{self.args.index})
    GUI:UIPanel_Close("dev/outui/Role/Panel/KLAttPointSuitChoice/KLAttPointSuitChoicePanel")
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.BtnChoice,self,self.BtnChoiceOnClick)
end

function this:Close()
end

return this
