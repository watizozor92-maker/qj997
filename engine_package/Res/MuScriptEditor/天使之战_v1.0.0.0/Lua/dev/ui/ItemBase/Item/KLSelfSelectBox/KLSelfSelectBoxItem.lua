---@class KLSelfSelectBoxItem:UIKmlLuaPanelBase
---@field view KLSelfSelectBoxItemView
local KLSelfSelectBoxItem = class(UIKmlLuaPanelBase)
local this = KLSelfSelectBoxItem
---创建时调用一次
function this:Init()

end

---创建或者刷新界面数据时调用
function this:Refresh()
end

function this:InitData(arg, panel, count)
    --self.go:SetActive(true)
    self.awradItem = SL:GetConfig("cfg_item", arg)
    self.parentPanel = panel
    self.SelectCount = 0
    GUI:Text_setString(self.view.numbertext, tostring(self.SelectCount))
    self:ShowModel(arg, count)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.addbtn, self, self.addbtnOnClick)
    GUI:AddOnClickEvent(self.view.decbtn, self, self.decbtnOnClick)
    GUI:AddOnClickEvent(self.view.itemicon, self, self.ItemOnClick)
    GUI:Input_SetOnEndEdit(self.view.numbertext, self, self.InputChange)
end

function this:decbtnOnClick()
    if self.SelectCount > 0 then
        self.SelectCount = self.SelectCount - 1
        GUI:Text_setString(self.view.numbertext, tostring(self.SelectCount))
        self.parentPanel:SetItemCount(self.awradItem.id, -1)
    end
end

function this:addbtnOnClick()
    if self.parentPanel.curCount < self.parentPanel.totleCount then
        self.SelectCount = self.SelectCount + 1
        GUI:Text_setString(self.view.numbertext, tostring(self.SelectCount))
        self.parentPanel:SetItemCount(self.awradItem.id, 1)
    else
        SL:TipMessage(SL:GetConfig('cfg_string', 323).text, 1, NoticeType.NoticeMid )--"已达到可选择上限",
    end
end

function this:InputChange()
    local text = GUI:Text_getString(self.view.numbertext)
    if not tonumber(text) then
        text = self.SelectCount
    end
    local inputValue = tonumber(text)
    local curCount = self.parentPanel.curCount - self.SelectCount
    if curCount < self.parentPanel.totleCount then
        local count = self.parentPanel.totleCount - curCount
        if inputValue > count then
            inputValue = count
        elseif inputValue < 0 then
            inputValue = 0
        end
        self.SelectCount = inputValue
        GUI:Text_setString(self.view.numbertext, tostring(inputValue))
        self.parentPanel:InputItemCount(self.awradItem.id, inputValue)
    else
        GUI:Text_setString(self.view.numbertext, 0)
        self.parentPanel:InputItemCount(self.awradItem.id, 0)
    end

end

function this:Close()
end

function this:ItemOnClick()
    SL:OpenTips("", self.awradItem.id)
end

function this:ShowModel(id, count)
    GUI:Item_UpdataData(self.view.itemicon, {
        itemid = id,
        itemcount = count
    })
    GUI:Item_setItemId(self.view.itemicon, id)

    --if self.itemModel then
    --	GUI:Item_UpdataData(self.itemModel, {
    --		itemid = id,
    --	})
    --end
    --self.itemModel = GUI:Item_Create(self.view.itemicon, {
    --	width = "45",
    --	height = "45",
    --	itemid = id,
    --	noclip = "1",
    --	mfixsize = "100,100",
    --	bgtype = "0",
    --	count = 0,
    --})
end

return this
