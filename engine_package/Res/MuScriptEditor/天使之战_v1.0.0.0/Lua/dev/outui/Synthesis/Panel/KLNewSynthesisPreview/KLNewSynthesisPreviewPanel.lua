---@class KLNewSynthesisPreviewPanel:UIKmlLuaPanelBase
---@field view KLNewSynthesisPreviewPanelView
local KLNewSynthesisPreviewPanel = class(UIKmlLuaPanelBase)
local this =KLNewSynthesisPreviewPanel

---创建时调用一次
function this:Init()
    GUI:DataListInitData(self.view.DataList_Item, function()
        return #self.args
    end, nil, nil, function(realIndex)
        local item = GUI:GetChildControl(self.view.DataList_Item, realIndex, "item7")
        local itemId = self.args[realIndex + 1]
        GUI:Item_setItemId(item, itemId)
        GUI:AddOnClickEvent(item, self, function()
            SL:OpenTips(nil, itemId, nil, nil, nil, { posX = -280 })
        end)
    end)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.Btn_Close, self, self.OnClick_Btn_Close)
end
---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
    GUI:DataListUpdateData(self.view.DataList_Item, false, function()
        SL:ScheduleOnce(0.01, function()
            GUI:SetScrollView_scrollpos(self.view.scrollview3, "0")
        end)
    end)
end

function this:Hide()
end

function this:Close()
end

---点击关闭按钮
function this:OnClick_Btn_Close()
    GUI:UIPanel_Close(nil, self)
end

return this
