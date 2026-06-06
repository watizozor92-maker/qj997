---@class KLUIChatSelectTypeItem:UIKmlLuaPanelBase
---@field view KLUIChatSelectTypeItemView
local KLUIChatSelectTypeItem = class(UIKmlLuaPanelBase)
local this = KLUIChatSelectTypeItem
---创建时调用一次
function this:Init()
    
end

---创建或者刷新界面数据时调用
function this:Refresh()
end

---@param chanPanel KLUIChatPanel
function this:RefreshItem(channel,chanPanel,nameData)
    self.channel = channel
    self.chanPanel = chanPanel
    self.nameData = nameData
    local typeStr = SL:ChatInfo_GetChatTypeStr(self.channel)

    if self.nameData then
        typeStr = self.nameData.submitName
        self:SelectBG(self.nameData.rid == chanPanel.submitId)
    else
        self:SelectBG(channel == chanPanel.allType)
    end
    if self.nameData and self.nameData.onLine then
        if self.nameData.onLine == "1" then
            GUI:Text_setTextColor(self.view.name,"#8E8E8E")
        else
            GUI:Text_setTextColor(self.view.name,"#FFFFFF")
        end
    else
        GUI:Text_setTextColor(self.view.name,"#FFFFFF")
        
    end
    GUI:Text_setString(self.view.name,typeStr)
    
    
end

---注册UI事件和服务器消息
function this:RegistEvents()
    --GUI:AddOnClickEvent(self.view.button_id,self,self.BtnOnClick)
    GUI:AddOnClickEvent(self.view.root, self, self.SelectType)
end

function this:SelectType()
    if not self.nameData then
        self.chanPanel:ZongSelectType(self.channel)
    else
        self.chanPanel:SelectName(self.nameData)
    end
end

function this:SelectBG(isActive)
    if isActive then
        GUI:Image_loadTexture(self.view.bg,"bg_select_yes","Atlas/UIChatPanelOut.spriteatlas")
    else
        GUI:Image_loadTexture(self.view.bg,"bg_select_no","Atlas/UIChatPanelOut.spriteatlas")
    end
end


function this:Close()
end


return this
