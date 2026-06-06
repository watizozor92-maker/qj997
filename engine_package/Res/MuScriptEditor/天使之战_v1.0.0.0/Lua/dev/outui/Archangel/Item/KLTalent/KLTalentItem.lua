---@class KLTalentItem:UIKmlLuaPanelBase
---@field view KLTalentItemView
---@field talentList cfg_equip_angelTalent_column[]
local KLTalentItem = class(UIKmlLuaPanelBase)
local this = KLTalentItem

---创建时调用一次
function this:Init()

    GUI:DataListInitData(self.view.talent_data, function()
        return #self.talentList
    end, function(realIndex)
        --return self:talentNameGetItem(realIndex)
    end, function(realIndex, kmlcontrol)
        --return self:DataListItemInit(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:TalentUpdateItem(realIndex, kmlcontrol)
    end)
end

function this:TalentUpdateItem(realIndex, kmlcontrol)
    local atlas = "Atlas/UIOutSkillIcon.spriteatlas"
    --local icon = self.view.talent_data:GetChildControl(realIndex, "icon")
    local icon = GUI:GetChildControl(self.view.talent_data, realIndex, "icon")
    --local bg = self.view.talent_data:GetChildControl(realIndex, "bg")
    local bg = GUI:GetChildControl(self.view.talent_data, realIndex, "bg")
    if self.talentList[realIndex + 1].talentType == 2 then
        GUI:Image_loadTexture(bg, "golden_frame", "Atlas/UIArchangel.spriteatlas")
    else
        GUI:Image_loadTexture(bg, "silver_frame", "Atlas/UIArchangel.spriteatlas")
    end
    GUI:Image_loadTexture(icon, self.talentList[realIndex + 1].talentIcon, atlas)
    GUI:AddOnClickEvent(icon, self, function()
        GUI:UIPanel_Open("dev/outui/Archangel/Panel/KLTalentTip/KLTalentTipPanel", _, _, { tbl = self.talentList[realIndex + 1], currentLv = self.talentList[realIndex + 1].curlv })
    end)
    --local level_text = self.view.talent_data:GetChildControl(realIndex, "level_text")
    local level_text = GUI:GetChildControl(self.view.talent_data, realIndex, "level_text")
    GUI:Text_setString(level_text, tostring(self.talentList[realIndex + 1].curlv) .. "/" .. tostring(self.talentList[realIndex + 1].talentMaxLv))

    --local icon_mask = self.view.talent_data:GetChildControl(realIndex, "icon_mask")
    local icon_mask = GUI:GetChildControl(self.view.talent_data, realIndex, "icon_mask")
    if self.talentList[realIndex + 1].curlv > 0 then
        GUI:setVisible(icon_mask, false)
    else
        GUI:setVisible(icon_mask, true)
    end
end
---注册UI事件和服务器消息
function this:RegistEvents()
end
---界面显示时调用一次
function this:Show()

end
---创建或者刷新界面数据时调用
function this:Refresh()

end

function this:UpdateUI(talentList)
    self.talentList = talentList
    GUI:DataListUpdateData(self.view.talent_data)
end

function this:Close()
end

return this
