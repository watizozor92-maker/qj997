---@class KLRecoverTypeItem:UIKmlLuaPanelBase
---@field view KLRecoverTypeItemView
local KLRecoverTypeItem = class(UIKmlLuaPanelBase)
local this =KLRecoverTypeItem
---创建时调用一次
function this:Init()
    ---@type cfg_recovery_column
    local config = self.args
    GUI:Text_setString(self.view.TypeText,config.groupName1)
    if config.typeList and next(config.typeList) then
        GUI:setPositionY(self.view.TypeText,10)
        GUI:setVisible(self.view.xiangxi,true)
    else
        GUI:setPositionY(self.view.TypeText,-1)
        GUI:setVisible(self.view.xiangxi,false)
    end
    GUI:setVisible(self.view.TypeText,true)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    GUI:AddOnClickEvent(self.view.xiangxi_btn, self, self.xiangxi_btn_OnClick)
end

---注册UI事件和服务器消息
function this:RegistEvents()
end

function this:Close()
end

function this:xiangxi_btn_OnClick()
    if not self.args or not self.args.typeList then
        return
    end
    self.baseUI:SetDetailBtn(self.view.xiangxi_btn)
    local ui = GUI:GetUI("dev/ui/Recover/Panel/KLRecoverDetailedSettings/KLRecoverDetailedSettingsPanel")
    if ui then
        if ui.data and ui.data.id == self.args.id then
            GUI:UIPanel_Close("dev/ui/Recover/Panel/KLRecoverDetailedSettings/KLRecoverDetailedSettingsPanel")
            return
        end
        GUI:UIPanel_Close("dev/ui/Recover/Panel/KLRecoverDetailedSettings/KLRecoverDetailedSettingsPanel")
    end
    local ui = GUI:UIPanel_Open("dev/ui/Recover/Panel/KLRecoverDetailedSettings/KLRecoverDetailedSettingsPanel",nil,nil,nil,nil,function (ui)
        
        ui:RefreshData(self.args)
    end)
end

return this
