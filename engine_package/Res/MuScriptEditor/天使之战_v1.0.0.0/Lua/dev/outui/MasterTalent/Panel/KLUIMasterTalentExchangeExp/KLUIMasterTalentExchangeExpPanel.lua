---@class KLUIMasterTalentExchangeExpPanel:UIKmlLuaPanelBase
---@field view KLUIMasterTalentExchangeExpPanelView
---@field DataList table<number,{costID:number,costCount:number,exchangeID:number,exchangeCount:number}>
local KLUIMasterTalentExchangeExpPanel = class(UIKmlLuaPanelBase)
local this =KLUIMasterTalentExchangeExpPanel
---创建时调用一次
function this:Init()

    GUI:SetImageNativeSize(self.view.title)
    
    self.DataList = {}
    self.exchangeCount = 0
    self.maxNum = 0
    
    GUI:DataListInitData(self.view.DataList,function()
        return self:DatalistItemCountFunc()
    end,function(realIndex)
        return self:DatalistItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:DatalistItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:DatalistItemUpdateFunc(realIndex, kmlcontrol)
    end)
    
    if self.args and self.args.type then
        if self.args.type == EMasterTalentType.CAREER then
            self:GetCfgData(4003)
        elseif self.args.type == EMasterTalentType.SKILL then
            self:GetCfgData(4008)
        end
    end
    
    if self.args and self.args.maxNum then
        self.maxNum = self.args.maxNum
    end
    
    if self.args and self.args.count then
        self.exchangeCount = self.maxNum - self.args.count
    end
    self:SetCountText()
end

function this:SetCountText()
    GUI:Text_setString(self.view.Text,"今日剩余兑换次数：<color=#00ff00>"..self.exchangeCount.."</color>/"..self.maxNum)
end

---获取兑换经验的数据
function this:GetCfgData(id)
    ---@type cfg_global_column
    local cfg = SL:GetConfig("cfg_global",id)
    local strList = string.split(cfg.value,'|')
    for i, v in ipairs(strList) do
        local infoArr = string.split(v,'#')
        local data = 
        {
            costID = infoArr[1],
            costCount = infoArr[2],
            exchangeID = infoArr[3],
            exchangeCount = infoArr[4],
        }
        table.insert(self.DataList,data)
    end
    GUI:DataListUpdateData(self.view.DataList)
end

--------------------------------兑换经验-------------------------------------------------------
function this:DatalistItemCountFunc()
    return #self.DataList
end

function this:DatalistItemGetFunc(realIndex)

end

function this:DatalistItemInitFunc(realIndex, kmlcontrol)

end

function this:DatalistItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.DataList[realIndex + 1]
    local _consumeItem = GUI:GetChildControl(self.view.DataList,realIndex,'ConsumeItem')
    local _consumeText = GUI:GetChildControl(self.view.DataList,realIndex,'ConsumeText')
    local _exchangeItem = GUI:GetChildControl(self.view.DataList,realIndex,'ExchangeItem')
    local _exchangeText = GUI:GetChildControl(self.view.DataList,realIndex,'ExchangeText')
    local _exchangeButton = GUI:GetChildControl(self.view.DataList,realIndex,'ExchangeButton')
    GUI:Item_setItemId(_consumeItem,data.costID)
    GUI:Item_setItemId(_exchangeItem,data.exchangeID)
    GUI:Text_setString(_consumeText,data.costCount)
    GUI:Text_setString(_exchangeText,data.exchangeCount)
    GUI:AddOnClickEvent(_exchangeButton,self,self.OnClickExchange,
            {
                costID = tonumber(data.costID),
                exchangeID = tonumber(data.exchangeID),
                costCount = tonumber(data.costCount),
                exchangeCount = tonumber(data.exchangeCount),
            })
    GUI:AddOnClickEvent(_consumeItem, self, function()
        SL:OpenTips(nil, tonumber(data.costID))
    end)
    GUI:AddOnClickEvent(_exchangeItem, self, function()
        SL:OpenTips(nil, tonumber(data.exchangeID))
    end)
end

---@param control UIKmlLuaControl
---@param eventData {costID:number,costCount:number,exchangeID:number,exchangeCount:number}
function this:OnClickExchange(control, eventData)
    if self.exchangeCount <= 0 then
        SL:TipMessage( SL:GetConfig('cfg_string',273).text, 1, NoticeType.NoticeMid )--"兑换次数不足",
        return
    end
    
    if SL:GetBagItemCount(eventData.costID) < eventData.costCount then
        SL:TipMessage( SL:GetConfig('cfg_string',269).text,1, NoticeType.NoticeMid )--"货币不足", 
        return
    end

    local costList = {}
    local exchangeList = {}
    table.insert(costList,{costItemCfgId = eventData.costID,costItemCount = eventData.costCount})
    table.insert(exchangeList,{itemCfgId = eventData.exchangeID,itemCount = eventData.exchangeCount})
    
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_EXCHANGE_MASTER_EXP,{type = self.args.type,cost = costList,award = exchangeList})
end

------------------------------------------------------------------------------------------------

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.CloseButton,self,self.OnClickCloseButton)
    GUI:AddOnClickEvent(self.view.MaskCloseButton,self,self.OnClickCloseButton)
    
    SL:RegisterLUAEvent(LUA_EVENT_MONEYCHANGE, self.CoinInfo_Change,self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_EXCHANGE_MASTER_EXP,self.RES_EXCHANGE_MASTER_EXP,self)
end

function this:RES_EXCHANGE_MASTER_EXP(_,message)
    if message then
        self.exchangeCount = self.maxNum - message["exchangedExpTimes"]
        self:SetCountText()
    end
end

---创建或者刷新界面数据时调用
function this:Refresh()
end

function this:CoinInfo_Change(_,message)
    GUI:DataListUpdateData(self.view.DataList)
end

function this:OnClickCloseButton()
    GUI:UIPanel_Close("dev/outui/MasterTalent/Panel/KLUIMasterTalentExchangeExp/KLUIMasterTalentExchangeExpPanel")
end

function this:Close()
end

return this
