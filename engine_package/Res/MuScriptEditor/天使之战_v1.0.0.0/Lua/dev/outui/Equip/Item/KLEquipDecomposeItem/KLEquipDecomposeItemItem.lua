---@class KLEquipDecomposeItemItem:UIKmlLuaPanelBase
---@field view KLEquipDecomposeItemItemView
local KLEquipDecomposeItemItem = class(UIKmlLuaPanelBase)
local this =KLEquipDecomposeItemItem

---创建时调用一次
function this:Init()
    self.qualityItem = nil
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

function this:RefreshData(data,count)
    local _qualityiconname = ""

    local itemData = {
        itemid = data.cfgId,
        itemcustomcount = (count and count > 1) and count or "",
        qualityscale = 0.5,
        qualityiconname = _qualityiconname
    }
    GUI:Item_UpdataData(self.view.EquipItem, itemData)
    if SL:HasConfig('cfg_equip_entryLib', data.cfgId) then
        local entryCount = table.count(SL:GetEquipEntrys(data)) --EquipInfo.GetEntryAttrList(data))
        if not self.qualityItem then
            GUI:UIPanel_Open("dev/ui/Common/Item/KLEquipQualityEntry/KLEquipQualityEntryItem",
                    self.view.EquipItem_Quality, self, {cfgId = data.cfgId, entryCount = entryCount},true,function(qualityItem)
                        self.qualityItem = qualityItem
                        GUI:setVisible(self.qualityItem.view.root,true)
                    end)
        else
            self.qualityItem:SetData(data.cfgId, entryCount)
        end
    else
        if self.qualityItem then
            GUI:setVisible(self.qualityItem.view.root,false)
        end
    end
    GUI:AddOnClickEvent(self.view.EquipItem, self, function()
        SL:OpenTips("bag", data.cfgId,data.id,nil,nil,{hideBtn=true})
    end)
end

function this:Close()
    if self.qualityItem then
        GUI:UIPanel_Close(nil, self.qualityItem)
        self.qualityItem = nil
    end
end

return this
