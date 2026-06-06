---@class KLFirstDropItem:UIKmlLuaPanelBase
---@field view KLFirstDropItemView
local KLFirstDropItem = class(UIKmlLuaPanelBase)
local this = KLFirstDropItem

---创建时调用一次
function this:Init()
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

function this:UpdateData(data)
    ---@type cfg_item_column
    local itemCfg = SL:GetConfig("cfg_item", data.cfg.id)
    GUI:Text_setString(self.view.name, data.cfg.muneText)
    if SL:HasConfig("cfg_color", itemCfg.color) then
        local color = SL:GetConfig("cfg_color", itemCfg.color)
        GUI:Text_setTextColor(self.view.name, color.color)
    end
    local rewardStr = ""
    for k, v in pairs(data.cfg.reward[data.type]) do
        local item = SL:GetConfig("cfg_item", v[1])
        rewardStr = rewardStr .. item.name .. "*" .. v[2] .. ","
    end
    if not string.isNullOrEmpty(rewardStr) then
        rewardStr = string.sub(rewardStr, 1, string.len(rewardStr) - 1)
    end
    GUI:Text_setString(self.view.reward, rewardStr)
    if data.message then
        GUI:Text_setString(self.view.player, data.message.name)
        GUI:Text_setString(self.view.num, "0")
    else
        GUI:Text_setString(self.view.player, "无")
        GUI:Text_setString(self.view.num, "1")
    end
end

function this:Hide()
end

function this:Close()
end

return this
