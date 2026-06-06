---@class KLUIRechargeDirectGiftItem:UIKmlLuaPanelBase
---@field view KLUIRechargeDirectGiftItemView
local KLUIRechargeDirectGiftItem = class(UIKmlLuaPanelBase)
local this =KLUIRechargeDirectGiftItem
--直购礼包-礼包
---创建时调用一次
function this:Init()
    self.itemDatas = {}
    self.allItem = {}
    GUI:DataListInitData(self.view.itemsDataList,function()
        return table.count(self.itemDatas)
    end,function(realIndex)
        local itemId = self.itemDatas[realIndex + 1].itemId
        local itemCount = self.itemDatas[realIndex + 1].itemNum
        local item = GUI:Item_Create(self.view.itemsDataList,{
            width = 60,
            height = 60,
            itemid = itemId,
            --mfixsize = "80,80",
            tips = "1",
            itemcustomcount = itemCount,
        })
        GUI:AddOnClickEvent(item,self,function()
            SL:OpenTips(nil,itemId)
        end)
        self.allItem[realIndex + 1] = item
        return item.kmlControl
    end,function(realIndex, kmlcontrol)

    end,function(realIndex, kmlcontrol)
        local itemId = self.itemDatas[realIndex + 1].itemId
        local itemCount = self.itemDatas[realIndex + 1].itemNum
        local item = self.allItem[realIndex + 1]
        GUI:Item_setItemId(item,itemId)
        GUI:Item_setItemCount(item,itemCount)
        GUI:AddOnClickEvent(item,self,function()
            SL:OpenTips(nil,itemId)
        end)
    end)
end

function this:ConfirmBuy()
    if self.rechargeCfg then
        local count,totalcount = InfoManager.countInfo:GetLimitAndTotalCountByKey(self.rechargeCfg.Countkey)
        if count > 0 then
            GUIUtil.SDKPay(self.rechargeCfg,1)
        else
            SL:TipMessage("已达购买次数上限",1,NoticeType.NoticeMid)
        end
    end
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.buyBtn,self,self.ConfirmBuy)
    SL:RegisterLUAEvent(LUA_EVENT_RUNACTIVE_DIRECT_COUNT_CHANGE, self.LUA_EVENT_RUNACTIVE_DIRECT_COUNT_CHANGE, self)
end

function this:LUA_EVENT_RUNACTIVE_DIRECT_COUNT_CHANGE()
    if self.rechargeCfg and self.rechargeCfg.Countkey then
        local count,totalcount = InfoManager.countInfo:GetLimitAndTotalCountByKey(self.rechargeCfg.Countkey)
        local color = "#00FF00"
        if count <= 0 then
            color = "#FF0000"
            GUI:SetActive(self.view.redDot,false)
            GUI:Text_setString(self.view.priceText,"已购买")
        end
        GUI:Text_setString(self.view.countText,string.format("<color=%s>限购次数:%d</color>",color,count))
    end
end

--- @param self.args cfg_OperateActivity_CDM_column
---创建或者刷新界面数据时调用
function this:Refresh()
    if self.args then
        --道具列表
        self.itemDatas = {}
        if self.args.itemCount and table.count(self.args.itemCount) > 0 then
            for k,v in ipairs(self.args.itemCount) do
                table.insert(self.itemDatas,{itemId=v[1],itemNum=v[2]})
            end
        end
        GUI:DataListUpdateData(self.view.itemsDataList)
        --礼包名、价格
        self.rechargeCfg = SL:GetConfigTwoKeys("cfg_recharge",self.args.id,self.args.rechargeType,"parameter","type")
        if self.rechargeCfg then
            local costStr
            if self.rechargeCfg.amount > 0 then
                costStr = string.format("%d元",self.rechargeCfg.amount)
                GUI:SetActive(self.view.redDot,false)
            else
                costStr = "免费"
                GUI:SetActive(self.view.redDot,true)
            end
            GUI:Text_setString(self.view.priceText,costStr)
            GUI:Text_setString(self.view.nameText,self.rechargeCfg.name)
        end
        if not self.args.index or self.args.index < 1 then
            self.args.index = 1
        elseif self.args.index > 4 then
            self.args.index = 4
        end
        GUI:Image_loadTexture(self.view.bg,string.format("giftBg_%d",self.args.index),"Atlas/UIRunActive_Direct.spriteatlas")
    end
    --限购次数
    self:LUA_EVENT_RUNACTIVE_DIRECT_COUNT_CHANGE()
end

function this:RefreshItem(args)
    self.args = args
    self:Refresh()
end

function this:Close()
    SL:UnRegisterLUAEvent(LUA_EVENT_RUNACTIVE_DIRECT_COUNT_CHANGE, self.LUA_EVENT_RUNACTIVE_DIRECT_COUNT_CHANGE, self)
end

return this
