---@class KLSalesTipsPanel:UIKmlLuaPanelBase
---@field view KLSalesTipsPanelView
local KLSalesTipsPanel = class(UIKmlLuaPanelBase)
local this = KLSalesTipsPanel
---创建时调用一次
function this:Init()
    self.init = false
    self.selectindex = 1
    self.toggleList = {}
    ---@type cfg_stall_column
    self.tbl = SL:GetConfig("cfg_stall", self.args.cfgId, "id")
    for i = 1, #self.tbl.money do
        self.toggleList[i] =  self.view["toggle_" .. i]
        GUI:Image_loadTexture(self.view["img_coin_unit_" .. i], tostring(self.tbl.money[i]), "Atlas/UIBagPanel.spriteatlas")
        GUI:setVisible(self.view["priceNode_" .. i],true)
        GUI:Text_setString(self.view["txt_price_unit_" .. i], tostring(self.tbl.mPrice[i]))
    end
    GUI:Image_setType(self.view.fill_attach,EImageType.Filled,EImageFillMethod.Horizontal)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn_close, self, self.ClosePanel)
    GUI:Slider_addOnEvent(self.view.price_slider, self, self.PriceChange)
    GUI:AddOnClickEvent(self.view.number_add, self, function()
        self:NumChange(1)
    end)
    GUI:AddOnClickEvent(self.view.number_minus, self, function()
        self:NumChange(-1)
    end)
    GUI:Input_SetOnEndEdit(self.view.txt_number, self, self.InputValueChange)
    
    GUI:AddOnClickEvent(self.view.btn, self, self.BtnClick)
    
    for i = 1, #self.tbl.money do
        GUI:Input_SetOnEndEdit(self.view["txt_price_unit_" .. i], self, self.InputPriceValue)
        GUI:SetToggleOnValueChange(self.toggleList[i],self,self.PriceUnitChange,{selectindex = i, money = self.tbl.money[i]}) 
    end
    GUI:SetTogDefaultThis(self.toggleList[1])
end

function this:PriceUnitChange(kmlCtrl, eventData, args)
    if args[1] then
        local value = GUI:Slider_getPercent(self.view.price_slider)
        local percent = tonumber(value) / (self.tbl.topPrice[self.selectindex] - self.tbl.mPrice[self.selectindex])
        
        self.selectUnit = eventData.money
        self.selectindex = eventData.selectindex
        GUI:Image_loadTexture(self.view.img_coin_total, tostring(self.tbl.money[self.selectindex]), "Atlas/UIBagPanel.spriteatlas")
        self.maxPrice = self.tbl.topPrice[self.selectindex] > 0 and self.tbl.topPrice[self.selectindex] or 99999
        self.minPrice = self.tbl.lPrice[self.selectindex] > 0 and self.tbl.lPrice[self.selectindex] or 1
        
        GUI:Slider_setMinPercent(self.view.price_slider, self.minPrice)
        GUI:Slider_setMaxPercent(self.view.price_slider, self.maxPrice)
        local value = tonumber(GUI:Text_getString(self.view["txt_price_unit_" .. self.selectindex]))
        GUI:Slider_setPercent(self.view.price_slider,value)
        SL:ScheduleOnce(Time.deltaTime * 4,function()
            if percent ~= 0 then
                self:PriceChange(_,value)
            end
        end)
    end
end

function this:NumChange(index)
    local value = tonumber(self:ReduceDay(GUI:Text_getString(self.view.txt_number)))
    value = value + self.tbl.minNumber * index
    if value < self.tbl.minNumber then
        value = self.maxNum
    end
    if self.maxNum < value then
        value = math.floor(self.maxNum / self.tbl.minNumber)
        value = value * self.tbl.minNumber
    end
    local count = math.floor(value / self.tbl.minNumber)
     
    if self.tbl.money[self.selectindex] == EMonthType.MonthCardTime then
        GUI:Text_setString(self.view.txt_price_total,
            tostring(tonumber(self:ReduceDay(GUI:Text_getString(self.view["txt_price_unit_" .. self.selectindex]))) * value) .. "天")
    else
        GUI:Text_setString(self.view.txt_price_total,
            tostring(tonumber(self:ReduceDay(GUI:Text_getString(self.view["txt_price_unit_" .. self.selectindex]))) * count))
    end

    GUI:Text_setString(self.view.txt_number, tostring(value))
    if self.args.cfgId == EMonthType.MonthCardTime then
        GUI:Text_setString(self.view.txt_number, tostring(value) .. "天")
    end
end

---输入数量
function this:InputValueChange()
    if not GUI:GetUI("dev/outui/Trade/Panel/KLSalesTips/KLSalesTipsPanel") then
        return
    end
    local value = tonumber(self:ReduceDay(GUI:Text_getString(self.view.txt_number)))

    value = math.floor(value / self.tbl.minNumber)
    value = value * self.tbl.minNumber

    if self.maxNum < value then
        value = math.floor(self.maxNum / self.tbl.minNumber)
        value = value * self.tbl.minNumber
    end
    if value < self.tbl.minNumber then
        value = self.tbl.minNumber
    end
    local price_totalNum = tonumber(self:ReduceDay(GUI:Text_getString(self.view["txt_price_unit_" .. self.selectindex]))) * value /
    self.tbl.minNumber
    local price_total = tostring(math.floor(price_totalNum))
    if self.args.cfgId == EMonthType.MonthCardTime then
        GUI:Text_setString(self.view.txt_number, tostring(value) .. "天")
    else
        GUI:Text_setString(self.view.txt_number, tostring(value))
    end

    if self.tbl.money[self.selectindex] == EMonthType.MonthCardTime then
        GUI:Text_setString(self.view.txt_price_total, price_total .. "天")
    else
        GUI:Text_setString(self.view.txt_price_total, price_total)
    end
end

function this:ClosePanel()
    GUI:UIPanel_Close("dev/outui/Trade/Panel/KLSalesTips/KLSalesTipsPanel")
    GUI:UIPanel_Close("dev/ui/Tips/Panel/KLUIEquipTips/KLUIEquipTipsPanel")
    GUI:UIPanel_Close("dev/ui/Tips/Panel/KLIUItemTips/KLUIItemTipsPanel")
    GUI:UIPanel_Close("dev/ui/Tips/Panel/KLUIEquipTipsComparsion/KLUIEquipTipsComparsionPanel")
    GUI:UIPanel_Close("dev/outui/Archangel/Panel/KLArchangelGrailTips/KLArchangelGrailTipsPanel")
end

---创建或者刷新界面数据时调用
function this:Refresh()
    local itemTbl = SL:GetConfig("cfg_item", self.args.cfgId, "id")
    if itemTbl.type == E_ItemType.Equip then
        GUI:setPositionX(self.view.sales_panel, 0)
    else
        GUI:setPositionX(self.view.sales_panel, 45)
    end
    if self.args.IsNeedOffsetXPos then
        GUI:setPositionX(self.view.sales_panel, self.args.IsNeedOffsetXPos)
    end
    
    GUI:Image_loadTexture(self.view.img_coin_total, tostring(self.tbl.money[self.selectindex]), "Atlas/UIBagPanel.spriteatlas")
    self:RefreshParam()
    GUI:Slider_setPercent(self.view.price_slider, self.tbl.mPrice[self.selectindex])
    
    local value = self.tbl.mPrice[self.selectindex]
    local num = self.tbl.minNumber <= 0 and 1 or self.tbl.minNumber
    local count = math.floor(num / self.tbl.minNumber)
    if self.args.cfgId == EMonthType.MonthCardTime then
        GUI:Text_setString(self.view.txt_number, tostring(num) .. "天")
    else
        GUI:Text_setString(self.view.txt_number, tostring(num))
    end
    if self.tbl.money[self.selectindex] == EMonthType.MonthCardTime then
        GUI:Text_setString(self.view["txt_price_unit_" .. self.selectindex], tostring(value) .. "天")
        GUI:Text_setString(self.view.txt_price_total, tostring(tonumber(self:ReduceDay(num)) * value) .. "天")
    else
        GUI:Text_setString(self.view["txt_price_unit_" .. self.selectindex], tostring(value))
        GUI:Text_setString(self.view.txt_price_total, tostring(count * value))
    end
    -- 直接刷新会偶现数值没有被刷新的问题
    SL:ScheduleOnce(0.2, function()
        self.init = true
    end)
    GUI:ForceRebuildLayoutImmediate(self.view.layout1)
    local hight = GUI:GetHeight(self.view.layout1)
    local width = GUI:GetWidth(self.view.layout1)
    GUI:setContentSize(self.view.img_16,width,hight)
    self:SetTipPosition()
end

function this:RefreshParam()
    self.maxPrice = self.tbl.topPrice[self.selectindex] > 0 and self.tbl.topPrice[self.selectindex] or 99999
    self.minPrice = self.tbl.lPrice[self.selectindex] > 0 and self.tbl.lPrice[self.selectindex] or 1
    GUI:Slider_setMaxPercent(self.view.price_slider, self.maxPrice)
    GUI:Slider_setMinPercent(self.view.price_slider, self.minPrice)
  
    
    -- local overlying = self.args.count
    local currentCount = self.args.count
    if self.args.cfgId == EMonthType.MonthCardTime then
        self.maxNum = InfoManager.monthCardInfo:GetMonthCardDayTime()
    elseif self:GetCoin(self.args.cfgId) then
        self.maxNum = currentCount
        self.maxNum = math.floor(self.maxNum / self.tbl.minNumber)
        self.maxNum = self.maxNum * self.tbl.minNumber
    else
        self.maxNum = currentCount
        self.maxNum = math.floor(self.maxNum / self.tbl.minNumber)
        self.maxNum = self.maxNum * self.tbl.minNumber
    end
    
end

function this:SetTipPosition()
    -- 计算获取途径面板的位置，使其更靠近按钮
    local tipsPanel = GUI:GetUI("dev/ui/Tips/Panel/KLIUItemTips/KLUIItemTipsPanel") or GUI:GetUI("dev/ui/Tips/Panel/KLUIEquipTips/KLUIEquipTipsPanel")
    if tipsPanel and tipsPanel.view.root then
        local height = GUI:GetHeight(self.view.img_16)
        local width = GUI:GetWidth(self.view.img_16)
        -- 获取当前tips面板的位置和尺寸
        local tipsX, tipsY = GUI:getPosition(tipsPanel.view.root)
        local tipsWidth = GUI:GetWidth(tipsPanel.view.panel_bg)
        local tipsHeight = GUI:GetHeight(tipsPanel.view.panel_bg)
        --if tipsPanel.isLeft then
        --    local tipsPanelX = tipsX + (242 / 2 + tipsWidth / 2)
        --    GUI:setPositionX(self.view.root, tipsX)
        --    GUI:setPositionX(tipsPanel.view.root, tipsPanelX)
        --else
        --    local tipsPanelX = tipsX - (242 / 2 + tipsWidth / 2)
        --    GUI:setPositionX(self.view.root, tipsX)
        --    GUI:setPositionX(tipsPanel.view.root, tipsPanelX)
        --end
        
        GUI:setPositionY(self.view.root, tipsY + (tipsHeight  - height) / 2)
        GUI:setPositionX(self.view.root, tipsX + (tipsWidth  + width) / 2)
    end
end

function this:PriceChange(_,value)
    if not self.init then
        return
    end
    if not GUI:GetUI("dev/outui/Trade/Panel/KLSalesTips/KLSalesTipsPanel") then
        return
    end
    local value = value or GUI:Slider_getPercent(self.view.price_slider)
    value = math.floor(tonumber(value))
    local num = GUI:Text_getString(self.view.txt_number)
    local count = math.floor(tonumber(self:ReduceDay(num)) / self.tbl.minNumber)
    if self.tbl.money[self.selectindex] == EMonthType.MonthCardTime then
        GUI:Text_setString(self.view["txt_price_unit_" .. self.selectindex], tostring(value) .. "天")
        GUI:Text_setString(self.view.txt_price_total, tostring(tonumber(self:ReduceDay(num)) * value) .. "天")
    else
        GUI:Text_setString(self.view["txt_price_unit_" .. self.selectindex], tostring(value))
        GUI:Text_setString(self.view.txt_price_total, tostring(count * value))
    end

    --local num = GUI:Text_getString(self.view.txt_number)
    --GUI:Text_setString(self.view.txt_price_total, tostring(tonumber(self:ReduceDay(num)) * value))
    if self.args.cfgId == EMonthType.MonthCardTime then
        GUI:Text_setString(self.view.txt_number, tostring(self:ReduceDay(num)) .. "天")
    end
end

function this:ReduceDay(value)
    ---去掉字符串末尾@天
    local tbl = string.split(value, "天")
    return tbl[1]
end

function this:InputPriceValue()
    if not self.init then
        return
    end
    if not GUI:GetUI("dev/outui/Trade/Panel/KLSalesTips/KLSalesTipsPanel") then
        return
    end
    local value = tonumber(self:ReduceDay(GUI:Text_getString(self.view["txt_price_unit_" .. self.selectindex])))
    local num = tonumber(self:ReduceDay(GUI:Text_getString(self.view.txt_number)))
    if self.maxPrice < value then
        value = self.maxPrice
    end
    if value < self.minPrice then
        value = self.minPrice
    end
    if self.tbl.money[self.selectindex] == EMonthType.MonthCardTime then
        GUI:Text_setString(self.view["txt_price_unit_" .. self.selectindex], tostring(value) .. "天")
        GUI:Text_setString(self.view.txt_price_total, tostring(tonumber(self:ReduceDay(num)) * value) .. "天")
    else
        local count = math.floor(num / self.tbl.minNumber)
        GUI:Text_setString(self.view["txt_price_unit_" .. self.selectindex], tostring(value))
        GUI:Text_setString(self.view.txt_price_total, tostring(count * value))
    end
    GUI:Slider_setPercent(self.view.price_slider, value)
end

function this:TipPrivilegePick()
    --交易行寄售需要特权才能上架
    SL:CommonTipsMessage({
        stringTblID = 491,
        showTips = "",
        ui = self,
        sureBtnText = "确定",
        cancelBtnText = "取消",
        callback = this.OpenFirsh
    })
end

function this:OpenFirsh()
    this:ClosePanel()
    GUI:UIPanel_Close("dev/outui/Trade/Panel/KLTradeMain/KLTradeMainPanel")
    GUI:UIPanel_Open("dev/outui/ShopMain/Panel/KLShopMain/KLShopMainPanel", nil, nil, { 2 })
end

function this:BtnClick()
    --if not InfoManager.monthCardInfo:IsHaveMonthCardRights("stall") then
    --    SL:TipMessage({ SL:GetConfig('cfg_string', 278).text, 1, NoticeType.NoticeMid })--"开通月卡后可使用交易行功能",
    --    return
    --end
    --暂时不判断特权就能上架
    --钻石特权卡解锁交易行上架功能
    -- if not PrivilegeCardManager.isSalesAdd() then
    --     self:TipPrivilegePick()
    --     return
    -- end
    if InfoManager.redNameInfo:IsLimitTrade() then
        SL:TipMessage( SL:GetConfig('cfg_string', 58002).text, 1, NoticeType.NoticeMid )
        return
    end
    local num = GUI:Text_getString(self.view.txt_number)
    local price = GUI:Slider_getPercent(self.view.price_slider)
    price = math.floor(tonumber(price))
    local data = {
        itemcfgid = tostring(self.args.cfgId),
        bagindex = tostring(self.args.index and self.args.index or 0),
        count = tostring(self:ReduceDay(num)),
        both = tostring(1),
        listingprice = tostring(price),
        totalprice = tostring(tonumber(price) * tonumber(self:ReduceDay(num))),
        money = self.selectUnit,
    }
    if self.args.cfgId == EMonthType.MonthCardTime then
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_UP_SHELF_MONTHCARD, data)
    else
        if not self.args.id then
            data.id = 0
        else
            data.id = tostring(self.args.id)
        end
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_TRADE_LISTING_GOODS, data)
    end
    self:ClosePanel()
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

function this:GetCoin(coinType)
    if coinType == 10010001 or coinType == 10020001 or coinType == 10030001 or coinType == 10040001 then
        return true
    end
    return false
end

function this:Close()

end

function this:GetItemCount(cfgId)
    if table.contains(MUEResourceType, cfgId) then
        return SL:GetBagItemCount(self.args.cfgId)
    end

    local bagCount = 0
    for page, v in pairs(SL:GetMetaValue("BAG_DATA")) do
        for i, item in pairs(v) do
            if item.bind == false then
                if item.cfgId == cfgId then
                    bagCount = bagCount + item.count
                end
            end
        end
    end
    return bagCount
end

return this
