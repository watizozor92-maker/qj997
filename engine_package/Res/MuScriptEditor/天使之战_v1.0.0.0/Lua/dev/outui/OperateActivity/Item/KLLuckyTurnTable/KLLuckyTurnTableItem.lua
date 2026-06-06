---@class KLLuckyTurnTableItem:UIKmlLuaPanelBase
---@field view KLLuckyTurnTableItemView
local KLLuckyTurnTableItem = class(UIKmlLuaPanelBase)
local this = KLLuckyTurnTableItem

---创建时调用一次
function this:Init()
    self.reward = nil

end

---注册UI事件和服务器消息
function this:RegistEvents()
end
---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
end
function this:SetBgGrey(value)
    GUI:Image_setGrey(self.view.BG, value)
end
function this:SetReTimes()
    if self.data.num == 999999 then
        return
    end
    if self.reCount - 1 < 0 then
        return
    end
    self.reCount = self.reCount - 1
    if self.reCount > 0 then
        GUI:Text_setString(self.view.reTimes, "剩余"..tostring(self.reCount).."份")
        self:SetBgGrey(false)
    else
        GUI:Text_setString(self.view.reTimes, "")
        self:SetBgGrey(true)
    end
end
function this:InitCount(countData)
    self.reCount = countData
    if self.reCount > 0 and self.data.num ~= 999999 then
        GUI:Text_setString(self.view.reTimes,"剩余"..tostring(self.reCount).."份")
        self:SetBgGrey(false)
    elseif self.data.num ~= 999999 then
        GUI:Text_setString(self.view.reTimes, "")
        self:SetBgGrey(true)
    else
        GUI:Text_setString(self.view.reTimes, "")
    end
end
function this:UpDataUI(data)
    self.data = data
    self.careerId = SL:GetMetaValue(EMetaVarGetKey.JOB)
    GUI:SetActive(self.view.Selected, false)
    GUI:Text_setString(self.view.Count, "")
    if self.data.type == 2 then
        GUI:SetActive(self.view.Flag, true)
        GUI:Image_loadTexture(self.view.BG, "bg_xiyou", "Atlas/QJ5_UITreasureHunt.spriteatlas")
        GUI:Image_loadTexture(self.view.Flag, "img_xiyou", "Atlas/QJ5_UITreasureHunt.spriteatlas")
    elseif self.data.type == 1 then
        GUI:SetActive(self.view.Flag, true)
        GUI:Image_loadTexture(self.view.BG, "bg_jipin", "Atlas/QJ5_UITreasureHunt.spriteatlas")
        GUI:Image_loadTexture(self.view.Flag, "img_jipin", "Atlas/QJ5_UITreasureHunt.spriteatlas")
    else
        GUI:SetActive(self.view.Flag, false)
        GUI:Image_loadTexture(self.view.BG, "bg_putong", "Atlas/QJ5_UITreasureHunt.spriteatlas")
    end
    for i, v in pairs(self.data.item) do
        if v[1] == self.careerId then
            self:ShowCoustIcon(v)
            GUI:Text_setString(self.view.Count, tostring(v[3]))
            return
        end
    end
end
---@param v table @例：{1,800502016,1}
function this:ShowCoustIcon(v)
    local data = {
        itemid = v[2],
        mfixsize = "74,74",
        tips = "1",
        width = "74",
        height = "74",
        bgtype = "0"
    }
    if self.ItemList then
        GUI:Item_UpdataData(self.ItemList, data)
    else
        self.ItemList = GUI:Item_Create(self.view.Point, data)
    end
    GUI:AddOnClickEvent(self.ItemList, self, function()
        SL:OpenTips(nil, data.itemid)
    end)
end
function this:ShowSelect()
    GUI:SetActive(self.view.Selected, true)
end
function this:HideSelect()
    GUI:SetActive(self.view.Selected, false)
end
function this:Hide()
end

function this:Close()
    self.ItemList = nil
end

return this
