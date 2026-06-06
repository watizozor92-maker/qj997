---@class KLBraveTrialsItem:UIKmlLuaPanelBase
---@field view KLBraveTrialsItemView
---@field baseUI KLBraveTrialsPanel
local KLBraveTrialsItem = class(UIKmlLuaPanelBase)
local this =KLBraveTrialsItem
---创建时调用一次
function this:Init()
end

---创建或者刷新界面数据时调用
function this:Refresh()
end

---@param info cfg_rep_column
function this:RefreshUI(info, isSelect)
    if info.id == self.args.firstLevel then
        GUI:Image_loadTexture(self.view.btn_level, "Texture/tower_gate.png")
        GUI:Image_loadTexture(self.view.img_level_select, "Texture/tower_gateoutline.png")
        GUI:setPositionY(self.view.img_level_select, "-10")
        GUI:setPositionY(self.view.level_reward, "-40")
        GUI:setPositionY(self.view.img_title_bg, "22")
    elseif info.id == self.args.finalLevel then
        GUI:Image_loadTexture(self.view.btn_level, "Texture/tower_top.png")
        GUI:Image_loadTexture(self.view.img_level_select, "Texture/tower_topoutline.png")
        GUI:setPositionY(self.view.img_level_select, "0")
        GUI:setPositionY(self.view.level_reward, "-143")
        GUI:setPositionY(self.view.img_title_bg, "-200")
    else
        GUI:Image_loadTexture(self.view.btn_level, "Texture/tower_special.png")
        GUI:Image_loadTexture(self.view.img_level_select, "Texture/tower_specialoutline.png")
        GUI:setPositionY(self.view.img_level_select, "0")
        GUI:setPositionY(self.view.level_reward, "0")
        GUI:setPositionY(self.view.img_title_bg, "-38")
    end
    --self.isSelect = isSelect
    if isSelect then
        GUI:SetActive(self.view.img_level_select, true)
        GUI:SetActive(self.view.img_title_select, true)
    else
        GUI:SetActive(self.view.img_level_select, false)
        GUI:SetActive(self.view.img_title_select, false)
    end
    GUI:Text_setString(self.view.text_title, info.name[1])
    GUI:AddOnClickEvent(self.view.btn_level, self, self.RefreshLevelMainInfo, info.id)
    self.rewardId = info.UIreward[1][1]
    GUI:Item_setItemId(self.view.level_reward, self.rewardId)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.img_level_reward_click, self, self.ShowItemTips)
end

function this:ShowItemTips()
    SL:OpenTips(nil, self.rewardId)
end

function this:RefreshLevelMainInfo(_, eventData)
    --if not self.isSelect then
        GUI:SetActive(self.view.img_level_select, true)
        GUI:SetActive(self.view.img_title_select, true)
        self.baseUI:RefreshLevelMainInfo(eventData, self)
        --self.isSelect = true
    --end
end

function this:HideChoseBG()
    GUI:SetActive(self.view.img_level_select, false)
    GUI:SetActive(self.view.img_title_select, false)
    --self.isSelect = false
end

function this:Close()
end

return this
