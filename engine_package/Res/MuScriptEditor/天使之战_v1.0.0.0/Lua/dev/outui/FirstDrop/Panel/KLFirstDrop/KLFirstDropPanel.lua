---@class KLFirstDropPanel:UIKmlLuaPanelBase
---@field view KLFirstDropPanelView
local KLFirstDropPanel = class(UIKmlLuaPanelBase)
local this = KLFirstDropPanel

---创建时调用一次
function this:Init()
    SL.HideMainPanel()
    self.items = {}
    self.message = {}
    GUI:DataListInitData(self.view.datalist, function()
        return #self.showList
    end, function(realIndex)
        return self:DataListItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:DataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:SetToggleOnValueChange(self.view.toggle1, self, self.OnToggleChange, 1)
    GUI:SetToggleOnValueChange(self.view.toggle2, self, self.OnToggleChange, 2)
    GUI:SetToggleOnValueChange(self.view.toggle3, self, self.OnToggleChange, 3)
    GUI:AddOnClickEvent(self.view.close_btn, self, self.ClosePanel)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_FIRST_DROP_PANEL, self.RES_FIRST_DROP_PANEL, self)
end

---界面显示时调用一次
function this:Show()
end

---创建或者刷新界面数据时调用
function this:Refresh()
    
    self.cfg = SL:GetConfigTable("cfg_firstDrop")
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_FIRST_DROP_PANEL)
    local tbl = SL:GetConfig("cfg_string", 39001)
    GUI:Text_setString(self.view.txt_desc, "")

    self.dataListText2 =string.split(tbl.text,"#")
    GUI:DataListInitData(self.view.contentlist2, function()
        return table.count(self.dataListText2)
    end, function()
    end, function()
    end, function(realIndex)
        local dataInfo = self.dataListText2[realIndex + 1]
        local preview_tittle = GUI:GetChildControl(self.view.contentlist2, realIndex, 'preview_tittle2')
        GUI:Text_setText(preview_tittle,dataInfo)
    end)

    GUI:DataListUpdateData(self.view.contentlist2,true)
end

function this:RES_FIRST_DROP_PANEL(_, message)
    self.message = message
    self:SetShow(1)
end

function this:OnToggleChange(_, type, event)
    if event[1] then
        self:SetShow(type)
    end
end

function this:SetShow(type)
    self.showList = {}
    for k, v in pairs(self.cfg) do
        if v.type >= type then
            local data = {
                cfg = v,
                type = type,
                message = self.message[tostring(v.id)] and self.message[tostring(v.id)][tostring(type)] or nil
            }
            table.insert(self.showList, data)
        end
    end
    GUI:DataListUpdateData(self.view.datalist)
end

function this:DataListItemGetFunc(realIndex)
    local item = GUI:UIPanel_Open("dev/outui/FirstDrop/Item/KLFirstDrop/KLFirstDropItem", self.view.datalist, self, nil,
        true, function(firstDropItem)
        local kmlControl = firstDropItem.view.root
        if self.items[kmlControl] == false then
            self.items[kmlControl] = firstDropItem
            self:DataListItemUpdateFunc(realIndex, kmlControl)
        else
            self.items[kmlControl] = firstDropItem
        end
    end)
    return item.view.root
end

function this:DataListItemUpdateFunc(realIndex, kmlcontrol)
    if not self.items[kmlcontrol] then
        self.items[kmlcontrol] = false
        return
    end
    self.items[kmlcontrol]:UpdateData(self.showList[realIndex + 1])
end

function this:ClosePanel()
    GUI:UIPanel_Close("dev/outui/FirstDrop/Panel/KLFirstDrop/KLFirstDropPanel")
end

function this:Hide()
end

function this:Close()
    SL.ShowMainPanel()
end

return this
