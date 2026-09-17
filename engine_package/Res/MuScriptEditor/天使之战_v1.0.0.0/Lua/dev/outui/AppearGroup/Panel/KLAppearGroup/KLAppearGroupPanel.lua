---@class KLAppearGroupPanel:UIKmlLuaPanelBase
---@field view KLAppearGroupPanelView
local KLAppearGroupPanel = class(UIKmlLuaPanelBase)
local this = KLAppearGroupPanel

---@type table<E_FashionType,UIKmlLuaControl>
local togs = {}
local togToPanel = {
    [E_FashionType.Title] = "dev/outui/AppearGroup/Panel/KLTitle/KLTitlePanel",
    [E_FashionType.Appear] = "dev/outui/AppearGroup/Panel/KLAppear/KLAppearPanel",
    [E_FashionType.TransferRing] = "dev/outui/AppearGroup/Panel/KLTransferRing/KLTransferRingPanel",
    [E_FashionType.Change] = "dev/outui/AppearGroup/Panel/KLSuit/KLSuitPanel",
    [E_FashionType.Render] = "dev/outui/AppearGroup/Panel/KLRender/KLRenderPanel",
}
local togTitle = {
    [E_FashionType.Title] = "Tittle",
    [E_FashionType.Appear] = "外观",
    [E_FashionType.TransferRing] = "首饰",
    [E_FashionType.Change] = "幻化",
    [E_FashionType.Render] = "染色",
}

---创建时调用一次
function this:Init()

    togs[E_FashionType.Title] = self.view.TogTitle
    togs[E_FashionType.Appear] = self.view.TogAppear
    togs[E_FashionType.TransferRing] = self.view.TogBox
    togs[E_FashionType.Change] = self.view.TogChange
    togs[E_FashionType.Render] = self.view.TogRender

    for i, v in pairs(togs) do
        GUI:SetToggleOnValueChange(v, self, self.TogOnClick, i)
    end
    local showTogTitle = table.count(InfoManager.appearInfo.titleData.title) > 0
    local showTogRing = table.count(InfoManager.appearInfo.ringData.title) > 0
    GUI:setVisible(self.view.TogTitle, showTogTitle)
    GUI:setVisible(self.view.TogBox, showTogRing)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    SL.HideMainPanel()
    local page = self.args or E_FashionType.Title

    if self.args and type(self.args) == "table" then
        page = self.args.type
        self.isFromBag = self.args.isFromBag
    else
        page = self.args or E_FashionType.Title
        self.isFromBag = false
    end

    local togItem = togs[page]
    if togItem then
        GUI:SetTogDefaultThis(togItem)
    else
        GUI:SetTogDefaultThis(self.view.TogAppear)
    end
end

---注册UI事件和服务器消息
function this:RegistEvents()
    --[[GUI:SetToggleOnValueChange(self.view.TogAppear, self, self.TogAppearOnClick)
    GUI:SetToggleOnValueChange(self.view.TogTitle, self, self.TogTitleOnClick)
    GUI:SetToggleOnValueChange(self.view.TogBox, self, self.TogBoxOnClick)
    GUI:SetToggleOnValueChange(self.view.TogChange, self, self.TogChangeOnClick)
    GUI:SetToggleOnValueChange(self.view.TogRender, self, self.TogRenderOnClick)]]
    GUI:AddOnClickEvent(self.view.Btn_Close, self, self.OnClick_Btn_Close)
end

function this:OnClick_Btn_Close()
    GUI:UIPanel_Close("dev/outui/AppearGroup/Panel/KLAppearPreview/KLAppearPreviewPanel")
    GUI:UIPanel_Close(self.lastOpenUI)
    GUI:UIPanel_Close("dev/outui/AppearGroup/Panel/KLAppearGroup/KLAppearGroupPanel")
end

function this:TogOnClick(kmlCtrl, eventData, args)
    local isOn = args[1]
    if isOn then
        if self.curPage == eventData then
            return
        end
        GUI:UIPanel_Open("dev/outui/AppearGroup/Panel/KLAppearPreview/KLAppearPreviewPanel")
        self.lastOpenUI = togToPanel[eventData]
        GUI:UIPanel_Open(self.lastOpenUI)
        GUI:Text_setText(self.view.Text_Title, togTitle[eventData])
    else
        GUI:UIPanel_Close(self.lastOpenUI)
    end
end

function this:TogAppearOnClick(kmlCtrl, eventData, args)
    if args[1] then
        if self.curPage == E_FashionType.Appear then
            return
        end

        self.curPage = E_FashionType.Appear
        GUI:UIPanel_Open("dev/outui/AppearGroup/Panel/KLAppearPreview/KLAppearPreviewPanel")
        GUI:UIPanel_Open("dev/outui/AppearGroup/Panel/KLAppear/KLAppearPanel")
    else
        GUI:UIPanel_Close("dev/outui/AppearGroup/Panel/KLAppear/KLAppearPanel")
    end

end

function this:TogTitleOnClick(kmlCtrl, eventData, args)
    if args[1] then
        if self.curPage == E_FashionType.Title then
            return
        end
        self.curPage = E_FashionType.Title
        GUI:UIPanel_Open("dev/outui/AppearGroup/Panel/KLAppearPreview/KLAppearPreviewPanel")
        GUI:UIPanel_Open("dev/outui/AppearGroup/Panel/KLTitle/KLTitlePanel")
    else
        GUI:UIPanel_Close("dev/outui/AppearGroup/Panel/KLTitle/KLTitlePanel")
    end

end

function this:TogBoxOnClick(kmlCtrl, eventData, args)
    if args[1] then
        if self.curPage == E_FashionType.TransferRing then
            return
        end
        self.curPage = E_FashionType.TransferRing
        GUI:UIPanel_Open("dev/outui/AppearGroup/Panel/KLAppearPreview/KLAppearPreviewPanel")
        GUI:UIPanel_Open("dev/outui/AppearGroup/Panel/KLTransferRing/KLTransferRingPanel")

    else
        GUI:UIPanel_Close("dev/outui/AppearGroup/Panel/KLTransferRing/KLTransferRingPanel")
    end

end

function this:TogChangeOnClick(kmlCtrl, eventData, args)
    if args[1] then
        if self.curPage == E_FashionType.Change then
            return
        end
        self.curPage = E_FashionType.Change
        GUI:UIPanel_Open("dev/outui/AppearGroup/Panel/KLAppearPreview/KLAppearPreviewPanel")
        GUI:UIPanel_Open("dev/outui/AppearGroup/Panel/KLSuit/KLSuitPanel")

    else
        GUI:UIPanel_Close("dev/outui/AppearGroup/Panel/KLSuit/KLSuitPanel")
    end

end

function this:TogRenderOnClick(kmlCtrl, eventData, args)
    if args[1] then
        if self.curPage == E_FashionType.Render then
            return
        end
        self.curPage = E_FashionType.Render
        GUI:UIPanel_Open("dev/outui/AppearGroup/Panel/KLAppearPreview/KLAppearPreviewPanel")
        GUI:UIPanel_Open("dev/outui/AppearGroup/Panel/KLRender/KLRenderPanel")
    else
        GUI:UIPanel_Close("dev/outui/AppearGroup/Panel/KLRender/KLRenderPanel")
    end

end

function this:Close()
    self.curPage = nil
    if self.isFromBag then
        GUI:UIPanel_Open("dev/outui/FashionEquip/Panel/KLFashionEquip/KLFashionEquipPanel")
    end
end

return this
