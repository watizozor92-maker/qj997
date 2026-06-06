---@class KLTradeRecordPanel:UIKmlLuaPanelBase
---@field view KLTradeRecordPanelView
local KLTradeRecordPanel = class(UIKmlLuaPanelBase)
local this = KLTradeRecordPanel

---@class TradeRecordItemData
---@field cointype number
---@field itemname string
---@field price number
---@field tradetypename string
---@field count number
---@field time string
---@field traderecordtype number

---创建时调用一次
function this:Init()
    GUI:OSAScrollView_Initialized(self.view.osa_list_record, self.TradeRecordItemGetFun, self.TradeRecordItemUpdateFun, self)
    ---@type TradeRecordItemData[]
    self.recordListData = {}
    self.recordItems = {}
end

function this:TradeRecordItemGetFun(index)
    local item = GUI:UIPanel_Open("dev/outui/Trade/Item/KLTradeRecord/KLTradeRecordItem", self.view.osa_list_record, self, 
                                  nil, true, function(uiitem)
         self.recordItems[uiitem.view.root] = uiitem
         self:TradeRecordItemUpdateFun(uiitem, index)
    end)
    return item
end

---@param item KLTradeRecordItem
function this:TradeRecordItemUpdateFun(item, index)
    local tItem = self.recordItems[item.view.root]
    if tItem == nil then
        return
    end
    item:UpdateItem(self.recordListData[index + 1], index)
end

function this:GetCoinIcon(coinType)
    if coinType == 10010001 then
        return "img_bag_01"
    elseif coinType == 10020001 then
        return "img_bag_02"
    elseif coinType == 10030001 then
        return "img_bag_03"
    elseif coinType == 10040001 then
        return "img_bag_04"
    end
end

---注册UI事件和服务器消息
function this:RegistEvents()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_TRADE_RECORD, self.RES_TRADE_RECORD, self)
end

function this:RES_TRADE_RECORD(_, message)
    table.clear(self.recordListData)
    if message then
        for _, v in pairs(message) do
            table.insert(self.recordListData, v)
        end
    end
    table.sort(self.recordListData,function(a,b)
        return tonumber(a.time) > tonumber(b.time)
    end)

    GUI:OSAScrollView_RefreshList(self.view.osa_list_record, #self.recordListData)
end

---@param a TradeRecordItemData
---@param b TradeRecordItemData
function this.RecordSortFun(a,b)
    return tonumber(a.time) >= tonumber(b.time)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_TRADE_RECORD)
end

function this:Close()
end

return this
