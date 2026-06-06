---@class KLPickUpPanel:UIKmlLuaPanelBase
---@field view KLPickUpPanelView
local KLPickUpPanel = class(UIKmlLuaPanelBase)
local this =KLPickUpPanel
---创建时调用一次
function this:Init()
    self.pickUpTemplateList = {}
end

---创建或者刷新界面数据时调用
function this:Refresh()
    local pickUpInfo = SL:GetMetaValue(EMetaVarGetKey.GET_ATUO_PICKUP_ITEM)
    local tblList = SL:GetConfigTable("cfg_pickdrop_condition")
    ---@param v cfg_pickdrop_condition_column
    for i, v in pairs(tblList) do
        local data = {name = v.groupName[1],pickUpId=v.id,isPickUp = pickUpInfo[v.id]}
        ---@type KLPickUpItem
        local pickUpTemplate = self.pickUpTemplateList[v.id]
        if not pickUpTemplate then
            pickUpTemplate = GUI:UIPanel_Open("dev/ui/Setting/Item/KLPickUp/KLPickUpItem",self.view.pickItemList,self,data,true)
        else
            pickUpTemplate.args = data
            pickUpTemplate:Refresh()
        end
        self.pickUpTemplateList[v.id] = pickUpTemplate
    end
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.BtnReDefault,self,self.ReDefaultOnClick)
end

function this:ReDefaultOnClick()
    SL:ReplyDefaultPickUpSetting()
    self:Refresh()
end

function this:Close()
end

return this
