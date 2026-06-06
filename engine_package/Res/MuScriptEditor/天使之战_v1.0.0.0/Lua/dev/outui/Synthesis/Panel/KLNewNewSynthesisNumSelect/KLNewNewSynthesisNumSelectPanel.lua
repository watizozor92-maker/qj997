---@class KLNewNewSynthesisNumSelectPanel:UIKmlLuaPanelBase
---@field view KLNewNewSynthesisNumSelectPanelView
local KLNewNewSynthesisNumSelectPanel = class(UIKmlLuaPanelBase)
local this =KLNewNewSynthesisNumSelectPanel

---创建时调用一次
function this:Init()
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.Btn_Close, self, self.ClosePanel)
    GUI:SetSliderOnValueChange(self.view.price_slider, self, self.PriceChange)
    GUI:AddOnClickEvent(self.view.number_add, self, self.NumChange, 1)
    GUI:AddOnClickEvent(self.view.number_minus, self,  self.NumChange, -1)
    GUI:Input_SetOnEndEdit(self.view.txt_number, self, self.InputValueChange)

    GUI:AddOnClickEvent(self.view.Btn_Confirm, self, self.OnClick_Btn_Confirm)
end
---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
    self.count = 0
    self.maxCount = self.args.maxCount
    GUI:Slider_setMaxPercent(self.view.price_slider, self.maxCount)
    GUI:Slider_setPercent(self.view.price_slider, self.count)
    GUI:Text_setText(self.view.txt_number, tostring(self.count))
    SL:OpenTips("bag", self.args.cfgId, nil, nil, nil, { hideBtn = true, posX = 269, hideMask = true })
end

function this:Hide()
end

function this:Close()
end

function this:ClosePanel()
    GUI:UIPanel_Close("dev/outui/Synthesis/Panel/KLNewNewSynthesisNumSelect/KLNewNewSynthesisNumSelectPanel")
    SL:CloseTips()
end

function this:PriceChange(control,_,data)
    self.count = math.floor(data[1])
    GUI:Text_setText(self.view.txt_number, tostring(self.count))
end

function this:NumChange(_, add)
    local targetNum = self.count + add
    if targetNum < 0 or targetNum > self.maxCount then
        return
    end
    self.count = targetNum
    self.maxCount = self.maxCount
    GUI:Text_setText(self.view.txt_number, tostring(targetNum))
    GUI:Slider_setPercent(self.view.price_slider, targetNum)
end

function this:InputValueChange(_, _, eventData)
    local target = tonumber(eventData[1])
    if target > self.maxCount then
        self.count = self.maxCount
    elseif target < 0 then
        self.count = 0
    else
        self.count = target
    end
    
    GUI:Slider_setPercent(self.view.price_slider, self.count)
    GUI:Text_setText(self.view.txt_number, tostring(self.count))
end

function this:OnClick_Btn_Confirm()
    if self.args.callback then
        if self.maxCount > 0 then
            self.args.callback(self.baseUI, self.args.consumeItemIndex, self.count)
        else
            if self.count > 0 then
                SL:TipMessage("没有可选材料", 1, NoticeType.NoticeMid)
            end
        end
    end
    self:ClosePanel()
end

return this
