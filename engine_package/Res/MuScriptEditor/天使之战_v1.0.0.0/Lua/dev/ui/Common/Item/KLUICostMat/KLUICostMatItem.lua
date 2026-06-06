---@class KLUICostMatItem:UIKmlLuaPanelBase
---@field view KLUICostMatItemView
local KLUICostMatItem = class(UIKmlLuaPanelBase)
local this =KLUICostMatItem
---创建时调用一次
function this:Init()
    
end

---创建或者刷新界面数据时调用
---@param id number @物品id
---@param needCount number @需求数量
function this:Refresh(id,needCount)
    if id then
        ---@type cfg_item_column
        local cfgData = SL:GetConfig("cfg_item",id)
        local bagCount = SL:GetBagItemCount(id)
        GUI:Text_setString(self.view.TextName,cfgData.name)
        if needCount then
            local countTextColor = bagCount >= needCount and "#00ff00" or "#ff2323"
            GUI:Text_setString(self.view.TextCount,"<color="..countTextColor..">"..bagCount.."</color>/"..needCount)
        else
            GUI:Text_setString(self.view.TextCount,bagCount)
        end
        local data = {
            width = "30",
            height = "30",
            itemid = id,
            z = -3001,
            mfixsize = "80,80",
            bgtype = "0",
            itemcount = nil,
        }
        if self.item then
            GUI:Item_UpdataData(self.item, data)
        else
            self.item = GUI:Item_Create(self.view.Model, data)
        end
    end
    
end

---注册UI事件和服务器消息
function this:RegistEvents()
end

function this:Close()
end

return this
