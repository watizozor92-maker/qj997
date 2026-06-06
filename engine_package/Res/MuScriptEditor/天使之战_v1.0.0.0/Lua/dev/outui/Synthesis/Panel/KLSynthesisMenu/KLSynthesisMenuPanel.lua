---@class KLSynthesisMenuPanel:UIKmlLuaPanelBase
---@field view KLSynthesisMenuPanelView
local KLSynthesisMenuPanel = class(UIKmlLuaPanelBase)
local this =KLSynthesisMenuPanel

---创建时调用一次
function this:Init()
    GUI:DataListInitData(self.view.DataList_SynthesisEntrys, function()
        return table.count(self.entryDatas)
    end, nil, nil, function(realIndex, kmlcontrol)
        return self:ItemUpdate(realIndex, kmlcontrol)
    end)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.Btn_Close, self, self.OnClick_Btn_Close)
end
---界面显示时调用一次
function this:Show()
    SL:HideMainPanel()
end
---创建或者刷新界面数据时调用
function this:Refresh()
    self.entryDatas = {}
    local args = self.args
    if args then
        args = GUIUtil.tblkeytonumber(args)
        for _, v in ipairs(args) do
            local id = tonumber(v)
            local tbl = SL:GetConfig("cfg_synthesis_layer", id)
            if tbl then
                table.insert(self.entryDatas, tbl)
            end
        end
    else
        local tbl = SL:GetConfigTable("cfg_synthesis_layer")
        for _, v in ipairs(tbl) do
            table.insert(self.entryDatas, v)
        end
    end

    GUI:DataListUpdateData(self.view.DataList_SynthesisEntrys)
end

function this:Hide()
end

function this:Close()
end

function this:ItemUpdate(realIndex, kmlcontrol)
    local text_desc = GUI:GetChildControl(self.view.DataList_SynthesisEntrys, realIndex, "Text_Desc")
    local btn_enter = GUI:GetChildControl(self.view.DataList_SynthesisEntrys, realIndex, "Btn_Enter")
    ---@type cfg_synthesis_layer_column
    local cfg = self.entryDatas[realIndex + 1]
    GUI:Text_setText(text_desc, cfg.description)
    GUI:Button_setTitleText(btn_enter, cfg.name)
    GUI:AddOnClickEvent(btn_enter, self, self.OnClick_Btn_Entry, cfg)
end

---点击关闭按钮
function this:OnClick_Btn_Close()
    GUI:UIPanel_Close(nil, self)
    SL.ShowMainPanel()
end

---点击入口按钮
function this:OnClick_Btn_Entry(_, data)
    local path = string.isNullOrEmpty(data.part) and "dev/outui/Synthesis/Panel/KLNewSynthesis/KLNewSynthesisPanel" or data.part
    GUI:UIPanel_Open(path, nil, nil, { cfg = data})
    GUI:UIPanel_Close(nil, self)
end

return this
