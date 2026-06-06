---@class KLItemSplitPanel:UIKmlLuaPanelBase
---@field view KLItemSplitPanelView
local KLItemSplitPanel = class(UIKmlLuaPanelBase)
local this = KLItemSplitPanel

---创建时调用一次
function this:Init()
    self.splitNum = 0
    self.maxNum = 100
    GUI:SetAttachAttr(self.view.slider,"fill_attach","type",2)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.sureBtn, self, self.Sure)
    GUI:AddOnClickEvent(self.view.cancelBtn, self, self.ClosePanel)
    GUI:AddOnClickEvent(self.view.close_btn, self.view, self.ClosePanel)
    GUI:SetSliderOnValueChange(self.view.slider, self, self.SliderChange)
    GUI:Input_SetOnEndEdit(self.view.input_num, self, self.InputNumEndEdit)
end

---界面显示时调用一次
function this:Show()
end

---创建或者刷新界面数据时调用
function this:Refresh()
    local count = self.args.count or 10
    self.maxNum = self.args.count and self.args.count - 1 or 100
    self.splitNum = 1
    self.pos = self:GetIndex()
    if self.pos == nil or count <= 1 then
        SL:MessageTip({id = 76001})
        self:ClosePanel()
        return
    end
    GUI:Text_setString(self.view.current_num, tostring(count))
    GUI:SetInputText(self.view.input_num, tostring(self.splitNum))
    GUI:Slider_setMaxPercent(self.view.slider, self.maxNum)
    GUI:Slider_setMinPercent(self.view.slider, 1)
end

function this:InputNumEndEdit()
    local numStr = GUI:GetInputText(self.view.input_num)
    local num = math.floor(tonumber(numStr))
    if num == nil then
        GUI:SetInputText(self.view.input_num, tostring(self.splitNum))
        return
    end
    if num < 1 then
        num = 1
        GUI:SetInputText(self.view.input_num, "1")
    end
    if num >= self.maxNum then
        num = self.maxNum
        GUI:SetInputText(self.view.input_num, tostring(self.maxNum))
    end
    self.splitNum = num
    GUI:Slider_setPercent(self.view.slider, num)
end

function this:SliderChange()
    local percent = GUI:Slider_getPercent(self.view.slider)
    percent = math.floor(tonumber(percent))
    self.splitNum = percent
    GUI:SetInputText(self.view.input_num, tostring(percent))
end

function this:Sure()
    local index = SL:GetBagIndex(self.args.id)
    local data = { index = index, count = self.splitNum, row = self.pos.h, column = self.pos.v }
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_BAG_PROPS_SPLIT, data)
    self:ClosePanel()
end

function this:GetIndex()
    local bag_info = string.split(SL:GetConfig("cfg_global", 6).value, '#')
    local maxHor = tonumber(bag_info[1])
    local maxVet = tonumber(bag_info[2])
    local holdGrid = SL:GetConfig('cfg_item', self.args.cfgId).holdGrid
    local holdHor = holdGrid[1]
    local holdVet = holdGrid[2]
    local useGridTable = SL:GetMetaValue(EMetaVarGetKey.GET_BAG_USE_GRID_TABLE)
    local useTable = useGridTable[1]
    for startHor = 1, maxHor do
        for startVet = 1, maxVet do
            if startHor + holdVet - 1 <= maxHor and startVet + holdHor - 1 <= maxVet then
                local canUse = true
                for nowHor = startHor, startHor + holdVet - 1 do
                    for nowVet = startVet, startVet + holdHor - 1 do
                        if useTable[this.GetIntWithHorAndVet(nowHor, nowVet)] == true then
                            canUse = false
                            break
                        end
                    end
                    if not canUse then
                        break
                    end
                end
                if canUse then
                    return { h = startHor, v = startVet }
                end
            end
        end
    end
    
    return nil
end

function this.GetIntWithHorAndVet(hor, vet)
    return hor * 100 + vet
end

function this:ClosePanel()
    GUI:UIPanel_Close("dev/outui/Bag/Panel/KLItemSplit/KLItemSplitPanel")
end

function this:Hide()
end

function this:Close()
end

return this
