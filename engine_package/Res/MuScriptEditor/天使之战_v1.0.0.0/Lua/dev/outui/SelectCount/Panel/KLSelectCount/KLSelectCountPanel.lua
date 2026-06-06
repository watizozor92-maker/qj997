---@class KLSelectCountPanel:UIKmlLuaPanelBase
---@field view KLSelectCountPanelView

---@class SelectData 需要传入的参数
---@field callbackUI UIKmlLuaPanelBase 打开该面板的UI
---@field sure function 确认按钮回调,两个number类型参数（唯一id,数量）
---@field itemid number item配置表id
---@field max number 最大数量,缺省则无数量上限
---@field id number 唯一id
local KLSelectCountPanel = class(UIKmlLuaPanelBase)
local this = KLSelectCountPanel
function this:AsyncLoadUI()
end
---创建时调用一次
function this:Init()

end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.Select_Mask, self, self.Cancel)
    GUI:AddOnClickEvent(self.view.BtnSure, self, self.Sure)
    GUI:AddOnClickEvent(self.view.BtnCancel, self, self.Cancel)
    GUI:AddOnClickEvent(self.view.showitem, self, self.OpenTips)
    GUI:AddOnClickEvent(self.view.subtract, self, function()
        self:AddAndSubtract(-1)
    end)
    GUI:AddOnClickEvent(self.view.add, self, function()
        self:AddAndSubtract(1)
    end)
    GUI:Input_SetOnEndEdit(self.view.Count, self, self.Input)
end

function this:AddAndSubtract(index)
    local count = tonumber(GUI:Text_getString(self.view.Count))
    self:Input(_, count + index)
end

function this:Input(_, inputCount)
    local count
    if inputCount then
        count = tonumber(inputCount)
    else
        count = tonumber(GUI:Text_getString(self.view.Count))
    end
    if count <= 0 then
        if self.args.max and self.args.max > 0 then
            count = self.args.max
        else
            count = 1
        end

    end
    if self.args.max and self.args.max > 0 and count > self.args.max then
        count = self.args.max
    end
    
    GUI:Text_setString(self.view.Count, tostring(count))
end

function this:Sure()
    local sure = self.args.sure
    local count = tonumber(GUI:Text_getString(self.view.Count))
    if self.args.callbackUI and sure then
        sure(self.args.callbackUI, self.args.id, count,self.args.itemid)
    end
    GUI:UIPanel_Close("dev/outui/SelectCount/Panel/KLSelectCount/KLSelectCountPanel")
end

function this:Cancel()
    GUI:UIPanel_Close("dev/outui/SelectCount/Panel/KLSelectCount/KLSelectCountPanel")
end

function this:OpenTips()
    SL:OpenTips(_, self.args.itemid, self.args.id)
end

---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
    GUI:Item_setItemId(self.view.showitem, self.args.itemid)
end

function this:Close()
end

return this
