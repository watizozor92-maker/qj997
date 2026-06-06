---@class KLTalentNameItem:UIKmlLuaPanelBase
---@field view KLTalentNameItemView
---@field talentType cfg_equip_angelTalentGroup_column
local KLTalentNameItem = class(UIKmlLuaPanelBase)
local this = KLTalentNameItem

---创建时调用一次
function this:Init()
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.name_bg, self, self.LoadTalent)
end
---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
end

---@param talentType cfg_equip_angelTalentGroup_column
function this:UpdateUI(talentType,talentGroup)
    self.talentType = talentType
    local atlas = "Atlas/UIArchangel.spriteatlas"
    GUI:Image_loadTexture(self.view.talent_name, talentType.talentGroupIcon[2], atlas)
    GUI:Image_loadTexture(self.view.talent_icon, talentType.talentGroupIcon[1], atlas)
    if talentGroup then
        self:Select(talentGroup)
    end
end

function this:LoadTalent()
    self.baseUI:LoadTalent(self.talentType.talentGroup)
end

function this:Select(talentGroup)
    if talentGroup == self.talentType.talentGroup then
        local src = self.talentType.talentGroupMenuIcon
        self.baseUI:ChangeBG(src)
    end
    
    GUI:setVisible(self.view.select, talentGroup == self.talentType.talentGroup)
end
function this:Close()
end

return this
