---@class KLForgingMasterItem:UIKmlLuaPanelBase
---@field view KLForgingMasterItemView
local KLForgingMasterItem = class(UIKmlLuaPanelBase)
local this =KLForgingMasterItem

---创建时调用一次
function this:Init()
    GUI:DataListInitData(self.view.DataList_Attr, function()
        return table.count(self.attrDatas)
    end, function()
        
    end, function()
        
    end, function(readIndex, kmlCtrl)
        local text_Attr = GUI:GetChildControl(self.view.DataList_Attr, readIndex, "Text_Attr")
        local attr = self.attrDatas[readIndex + 1]
        ---@type cfg_att_info_column
        local cfg = SL:GetConfig("cfg_att_info", attr.id)
        if cfg.remarks == 1 then
            GUI:Text_setText(text_Attr, cfg.name.. "  " .. attr.value)
        else
            GUI:Text_setText(text_Attr, cfg.name.. "  " .. ToolFunc.NumberToStringRemoveZero(attr.value / 100) .. "%")
        end
        GUI:Text_setTextColor(text_Attr, self.color)
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
    self.attrDatas = {}
end

---更新
function this:UpdateItem(data)
    ---@type cfg_equip_master_column
    local cfg = data.cfg
    GUI:Text_setText(self.view.Text_Progress, (data.current > 0 and string.format("<color=#00ff00>%d</color>", data.current) or tostring(data.current)) .. "/" .. data.total)
    GUI:Text_setText(self.view.Text_Title, cfg.note..cfg.lv)
    self.color = data.current >= data.total and "#00ff00" or "#FFFFFF"
    GUI:Text_setTextColor(self.view.Text_Title, self.color)
    GUI:Text_setTextColor(self.view.Text_Progress, self.color)
    self.attrDatas = {}
    local career = SL:MeData_GetCareer().baseCareer
    for i, v in pairs(cfg.att) do
        if career == v[1] then
            table.insert(self.attrDatas, {
                id = v[2],
                value = v[3]
            })
        end
    end
    
    local attrCount = table.count(self.attrDatas)
    local height = 43 + attrCount * 40 + (attrCount - 1) * 4
    GUI:setContentSize(self.view.root, GUI:GetWidth(self.view.root), height)
    GUI:DataListUpdateData(self.view.DataList_Attr)
end

function this:Hide()
end

function this:Close()
end

return this
