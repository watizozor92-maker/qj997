---@class KLPkItem:UIKmlLuaPanelBase
---@field view KLPkItemView
local KLPkItem = class(UIKmlLuaPanelBase)
local this =KLPkItem
---创建时调用一次
function this:Init()
    
end

---创建或者刷新界面数据时调用
function this:Refresh()
    --GUI:Button_setTitleText(self.view.pk_name,self.args.pkName)
    if self.args.pk_name == "btn_atk_all" then
        logError(1)
    end
    GUI:Button_loadTextureNormal(self.view.pkBtn, self.args.pkName, "Atlas/NewMainPanel.spriteatlas")
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.pkBtn,self,self.OnClickPkBtn)
end

function this:OnClickPkBtn()
    if GUIUtil.IsCanMapLinePkModeChange() then
        SL:onLUAEvent(LUA_EVENT_SWITCH_PKMODE,self.args.pkMode)
    else
        SL:TipMessage(SL:GetConfig('cfg_string',54001).text, 1, NoticeType.NoticeMid )--"任务已完成！",
    end

end

function this:SetHide(hide)
    GUI:setVisible(self.view.root, hide)
end

function this:Close()
end

return this
