---@class KLUnionActivityPanel:UIKmlLuaPanelBase
---@field view KLUnionActivityPanelView
local KLUnionActivityPanel = class(UIKmlLuaPanelBase)
local this =KLUnionActivityPanel
---创建时调用一次
function this:Init()
    self.items = {}
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_UNION_ACTIVITY_DATA)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    local tbl = SL:GetConfigTable("cfg_activity_rule")
    local itemPath = "dev/outui/Union/Item/KLUnionActivity/KLUnionActivityItem"

    self.activityDatas = {}
    ---@param v cfg_activity_rule_column
    for _ , v in pairs(tbl) do
        if v.initType == 2 then
            if table.isNullOrEmpty(self.items[v.id]) and SL:CheckCondition(v.condition) then
                --战盟活动
                GUI:UIPanel_Open(itemPath, self.view.layout3, self, {activityId = v.id}, true, function(item)
                    self.items[v.id] = item
                    local data = self.activityDatas[v.id]
                    if data then
                        item:SetOpen(data.open)
                    end
                end)
            end
        end
    end
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.BtnClose, self, self.CloseSelf)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_UNION_ACTIVITY_DATA, self.RES_UNION_ACTIVITY_DATA, self)
end

function this:RES_UNION_ACTIVITY_DATA(id, message)
    self.activityDatas = {}
    for k, v in pairs(message) do
        self.activityDatas[v.activityid] = v
        if self.items[v.activityid] then
            self.items[v.activityid]:SetOpen(v.open)
        end
    end
end

function this:CloseSelf()
    GUI:UIPanel_Close("dev/ui/Union/Panel/KLUnionToggleList/KLUnionToggleListPanel")
    GUI:UIPanel_Close(self.filePath)
    SL.ShowMainPanel()
end

function this:Close()
    self.items = {}
    GUI:UIPanel_Close("dev/outui/Union/Item/KLUnionActivity/KLUnionActivityItem")
    GUI:UIPanel_Close("dev/outui/Union/Panel/KLUnionBossMain/KLUnionBossMainPanel")
end

return this
