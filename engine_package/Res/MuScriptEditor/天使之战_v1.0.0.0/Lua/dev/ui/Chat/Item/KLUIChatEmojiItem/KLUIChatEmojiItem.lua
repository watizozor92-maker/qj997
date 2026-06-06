---@class KLUIChatEmojiItem:UIKmlLuaPanelBase
---@field view KLUIChatEmojiItemView
local KLUIChatEmojiItem = class(UIKmlLuaPanelBase)
local this = KLUIChatEmojiItem
---创建时调用一次
function this:Init()
    
end

---创建或者刷新界面数据时调用
function this:Refresh()
end

---@param chanPanel KLUIChatPanel
function this:RefreshItem(emoji_id,chanPanel)
    self.emoji_id = emoji_id
    self.chanPanel = chanPanel
    GUI:Image_loadTexture(self.view.emoji,self.emoji_id,"Atlas/Emoji.spriteatlas")
end

---注册UI事件和服务器消息
function this:RegistEvents()
    --GUI:AddOnClickEvent(self.view.button_id,self,self.BtnOnClick)
    GUI:AddOnClickEvent(self.view.root, self, self.SelectType)
end

function this:SelectType()
    self.chanPanel:AddEmoji(self.emoji_id)
end


function this:Close()
end


return this
