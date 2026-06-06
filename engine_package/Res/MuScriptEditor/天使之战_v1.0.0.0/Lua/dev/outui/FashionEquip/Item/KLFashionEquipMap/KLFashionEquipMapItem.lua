---@class KLFashionEquipMapItem:UIKmlLuaPanelBase
---@field view KLFashionEquipMapItemView
---@field fashionCfg cfg_FashionGuide_column
local KLFashionEquipMapItem = class(UIKmlLuaPanelBase)
local this =KLFashionEquipMapItem

---创建时调用一次
function this:Init()
    GUI:DataListInitData(self.view.datalist3, function()
        return table.count(self.textLists)
    end, function()
        
    end, function()
        
    end, function(realIndex)
        local txt_info = GUI:GetChildControl(self.view.datalist3, realIndex, 'txt_info')
        local text = self.textLists[realIndex + 1]
        GUI:Text_setString(txt_info, text)
        GUI:Text_setTextColor(txt_info, self.isActive and "#00ff00" or "#999999")
    end)
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

function this:RefreshMapCfg(globalId, stringId, isActive)
    self.isActive = isActive
    self.textLists = {}
    ---@type cfg_string_column
    local stringTbl = SL:GetConfig("cfg_string", stringId)
    GUI:Text_setString(self.view.txt_title, stringTbl.text)
    GUI:Text_setTextColor(self.view.txt_title, isActive and "#00ff00" or "#FFFFFF")
    ---@type cfg_global_column
    local global = SL:GetConfig("cfg_global", globalId)
    local count = 0
    local split = string.split(global.value, "|")
    for _, v in pairs(split) do
        local split2 = string.split(v, "#")
        local attId = tonumber(split2[1])
        local value = tonumber(split2[2])
        local str = EquipFunc.GetAttText(attId, value, "：")
        table.insert(self.textLists, str)
        count = count + 1
    end
    local itemSize = 32
    local paddingUp = 40
    local paddingDown = 20
    local height = count * itemSize + paddingUp + paddingDown + 5 * (count - 1)
    GUI:setContentSize(self.view.itemBg, 369, height)
    GUI:setContentSize(self.view.root, 369, height)
    GUI:DataListUpdateData(self.view.datalist3)
end

function this:UpdateProgress()
    
end

function this:Hide()
end

function this:Close()
end

return this
