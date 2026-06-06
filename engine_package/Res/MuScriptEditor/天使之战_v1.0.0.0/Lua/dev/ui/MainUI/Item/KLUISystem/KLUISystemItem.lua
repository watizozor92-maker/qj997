---@class KLUISystemItem:UIKmlLuaPanelBase
---@field view KLUISystemItemView
---@field args cfg_MainPanelUI_column
local KLUISystemItem = class(UIKmlLuaPanelBase)
local this =KLUISystemItem
---创建时调用一次
function this:Init()
    
end

---创建或者刷新界面数据时调用
function this:Refresh()
    local btnId = self.args.btnName .. "Icon"
    GUI:SetID(self.view.sysIcon,btnId)
    --运营活动需要根据轮数活动的不同更改主界面图标
    if self.args.btnName == "BtnOperateActivity" then
        if InfoManager.mainOperateActivityInfo.isOperateActivityMainBtnShow then
            local spriteName = "button_zmhd" --初始图片
            if (not table.isNullOrEmpty(InfoManager.mainOperateActivityInfo.operateMainActivityData)) and
                    (not table.isNullOrEmpty(InfoManager.mainOperateActivityInfo.operateMainActivityData.operateActivityAllInfo)) then
                spriteName = InfoManager.mainOperateActivityInfo.operateMainActivityData.operateActivityAllInfo.showIcon
            end
            GUI:Image_loadTexture(self.view.sysIcon,spriteName,"Atlas/KLMainPanelIcon.spriteatlas")
        end
    elseif self.args.btnName == "BtnOperateActivitySecond" then
        if InfoManager.mainOperateActivitySecondInfo.isOperateActivityMainBtnShow then
            local spriteName = "button_zmhd" --初始图片
            if (not table.isNullOrEmpty(InfoManager.mainOperateActivitySecondInfo.operateMainActivityData)) and
                    (not table.isNullOrEmpty(InfoManager.mainOperateActivitySecondInfo.operateMainActivityData.operateActivityAllInfo)) then
                spriteName = InfoManager.mainOperateActivitySecondInfo.operateMainActivityData.operateActivityAllInfo.showIcon
            end
            GUI:Image_loadTexture(self.view.sysIcon,spriteName,"Atlas/KLMainPanelIcon.spriteatlas")
        end
    else
        GUI:Image_loadTexture(self.view.sysIcon,self.args.BtnImage,"Atlas/KLMainPanelIcon.spriteatlas")
    end
    if self.args.iconOffset and table.count(self.args.iconOffset) == 2 then
        GUI:setPosition(self.view.sysIcon, self.args.iconOffset[1], self.args.iconOffset[2])
    end
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.sysIcon,self,self.OnClickSystemIcon)
end

function this:OnClickSystemIcon()
    SL:onLUAEvent(LUA_EVENT_OPENMAINSYSTEMFUNCTION,self.args.systemId)
end

function this:Close()
    
end

return this
