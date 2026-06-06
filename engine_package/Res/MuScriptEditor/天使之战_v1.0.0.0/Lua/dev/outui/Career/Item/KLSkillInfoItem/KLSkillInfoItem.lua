---@class KLSkillInfoItem:UIKmlLuaPanelBase
---@field view KLSkillInfoItemView
local KLSkillInfoItem = class(UIKmlLuaPanelBase)
local this = KLSkillInfoItem
---创建时调用一次
function KLSkillInfoItem:Init()
    
end

---创建或者刷新界面数据时调用
function KLSkillInfoItem:Refresh()
end

---注册UI事件和服务器消息
function KLSkillInfoItem:RegistEvents()
    GUI:AddOnClickEvent(self.view.Bg,self,self.BgOnClick)
end

function this:BgOnClick()
    --SL:ShowSkillTip(self.skillID,self.skillLevel)
end

function KLSkillInfoItem:Close()
end

function this:InitData(id,level)
    self.skillID = id
    self.skillLevel = level
    ---@type cfg_skill_info_column
    local skillInfo = SL:GetConfigMultiKeys('cfg_skill_info',self.skillID,self.skillLevel,'skillID','skillLevel')
    GUI:Image_loadTexture(self.view.ImageSkillIcon,skillInfo.icon,"Atlas/UIOutSkillIcon.spriteatlas")
    GUI:Text_setString(self.view.TextSkillName,skillInfo.name)
end

return KLSkillInfoItem
