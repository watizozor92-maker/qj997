---@class KLShowStallGoodsItem:UIKmlLuaPanelBase
---@field view KLShowStallGoodsItemView
local KLShowStallGoodsItem = class(UIKmlLuaPanelBase)
local this = KLShowStallGoodsItem
---创建时调用一次
function this:Init()

end

---注册UI事件和服务器消息
function this:RegistEvents() 
    GUI:AddOnClickEvent(self.view.btn_goods_item, self, self.ItemOnClick)
    GUI:AddOnClickEvent(self.view.btn_buy, self, self.BtnBuyOnClick)
    GUI:AddOnClickEvent(self.view.btn_xiajia, self, self.BtnDownOnClick)
end

function this:ItemOnClick()
    --SL:OpenTips(nil,self.itemData.itemCfgId)
    -- SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_ShowStall_GOODS_INFO, {self.itemData.itemId, self.itemData.ownerId })
    -- GUI:UIPanel_Open("dev/outui/ShowStall/Panel/KLShowStallBuy/KLShowStallBuyPanel", nil, nil, self.itemData)

    -- SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_TRADE_GOODS_INFO, {self.itemData.itemId, self.itemData.ownerId })
    -- GUI:UIPanel_Open("dev/outui/Trade/Panel/KLTradeBuy/KLTradeBuyPanel", nil, nil, self.itemData)
end

function this:IsCanBuy()
    if EquipFunc.GetItemIsBind(self.itemData.coinType) then
        local count = SL:GetBagBindItemCount()
        if count >= self.itemData.price then
            return true
        end
    end
    local count = SL:GetBagItemCount(self.itemData.coinType,false)
    if count >= self.itemData.totalPrice then
        return true
    end
    return false
end


function this:BtnBuyOnClick()
    if InfoManager.redNameInfo:IsLimitTrade() then
        SL:TipMessage( SL:GetConfig('cfg_string', 58002).text, 1, NoticeType.NoticeMid )
        return
    end
    
    if not self:IsCanBuy() then
        SL:TipMessage("当前货币不足",1, NoticeType.NoticeMid)
        return
    end
    ---@type KLTradeGoodsItemData
    local data = self.itemData
    if data.publicity == 1 then
        SL:CommonTipsMessage({ stringTblID = 225,
                               title = "提示",
                               callback = function()
                                   SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_TRADE_PRE_ORDER, { data.itemCfgId, data.itemId, data.type, data.ownerId })
                               end
        })
    else
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_TRADE_BUY_GOODS, { data.itemCfgId, data.itemId, data.type, self.itemData.count, data.ownerId })
    end
end

function this:BtnDownOnClick()
    local data = { self.itemData.itemCfgId, self.itemData.itemId }
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_TRADE_OFF_GOODS, data)
end

---创建或者刷新界面数据时调用
function this:Refresh()
end

---@param itemData KLTradeGoodsItemData
function this:UpdateData(itemData)
    self.itemData = itemData
    local isDown = false
    if tonumber(itemData.ownerId)  == SL:MeData_GetId() then
        isDown =true
    end
    if not isDown then
        GUI:setVisible(self.view.btn_buy, true)
        GUI:setVisible(self.view.btn_xiajia, false)
    else
        GUI:setVisible(self.view.btn_buy, false)
        GUI:setVisible(self.view.btn_xiajia, true)
    end
    
    
    GUI:SetOnPrefabControlLoaded(self.view.scroll_text_template, function()
        GUI:Text_setString(self.view.txt_item_name, itemData.itemName)
        local color = EquipFunc.GetEquipOrItemNameColor(itemData.itemCfgId)
        GUI:Text_setTextColor(self.view.txt_item_name, color)
        GUI:Item_setItemId(self.view.item, itemData.itemCfgId)
    end)
    
    if itemData.itemCfgId == EMonthType.MonthCardTime then
        --GUI:Item_UpdataData(self.view.item, { itemcount = 1 })
        GUI:Text_setString(self.view.itemCount, "")
        GUI:SetActive(self.view.monthCardText,true)
        GUI:Text_setString(self.view.monthCardText,itemData.count.."天")
    else
        GUI:SetActive(self.view.monthCardText,false)
        --GUI:Item_UpdataData(self.view.item, { itemcount = itemData.count })
        local numStr = ""
        if itemData.count > 1 then
            numStr = tostring(itemData.count)
        end
        GUI:Text_setString(self.view.itemCount, numStr)
    end
    
    GUI:Image_loadTexture(self.view.img_coin_type,self:GetCoinIcon(tonumber(itemData.coinType)),"Atlas/UIBagPanel.spriteatlas")
    local totalPrice = itemData.totalPrice
    local ownCount = SL:GetBagItemCount(tonumber(itemData.coinType))
    GUI:Text_setTextColor(self.view.txt_price,ownCount >= totalPrice and "#00ff00" or "#FF2323")
    GUI:Text_setString(self.view.txt_price,tostring(totalPrice))
    GUI:Image_loadTexture(self.view.img_coin_type, tostring(itemData.coinType), "Atlas/UIBagPanel.spriteatlas")
    GUI:Text_setString(self.view.txt_price, tostring(totalPrice))
    if itemData.publicity == 1 then
        GUI:SetActive(self.view.img_favor_count, true)
        local preOrder = table.count(itemData.preOrder)
        if preOrder >= 1 then
            GUI:Image_loadTexture(self.view.img_favor_count, "ty_ico_star", "Atlas/TS_Common.spriteatlas")
            GUI:Text_setString(self.view.txt_favor_count, tostring(preOrder))
        else
            GUI:Image_loadTexture(self.view.img_favor_count, "ty_ico_star_bg", "Atlas/TS_Common.spriteatlas")
            GUI:Text_setString(self.view.txt_favor_count, "")
        end
    else
        GUI:SetActive(self.view.img_favor_count, false)
    end
    
    local roleId = SL:GetMetaValue(EMetaVarGetKey.UID)
    if tostring(roleId) == itemData.ownerId then
        GUI:setVisible(self.view.icon_career, true)
        GUI:setVisible(self.view.icon_career_bg, true)
        local job = SL:GetMetaValue(EMetaVarGetKey.JOB)
        GUI:Image_loadTexture(self.view.icon_career, "1" .. tostring(job), "Atlas/KLTradePanel.spriteatlas")
    else
        GUI:setVisible(self.view.icon_career, false)
        GUI:setVisible(self.view.icon_career_bg, false)
    end
    

    self:Tick()

    self:ShowQualityUI()

    local strengthLevel = self.itemData.strengthLv or 0
    local appendLv = self.itemData.appendLv or 0
    GUI:Text_setString(self.view.strengthLevel_, strengthLevel ~= 0 and ("+" .. strengthLevel) or "")
    GUI:Text_setString(self.view.appendLevel_, appendLv ~= 0 and EquipFunc.GetEquipAppendLevelStr(appendLv) or "")
    local cfgId = itemData.itemCfgId
    local img_quality = self.view.imgQuality
    GUI:setVisible(img_quality, false)
    local entryLib = nil
    if SL:HasConfig('cfg_equip_entryLib', cfgId) then
         entryLib = SL:GetConfig('cfg_equip_entryLib', cfgId)
    end
    local is_zhuoyue = false
    if entryLib then
        local qualityTbl = SL:GetConfigTable("cfg_equip_quality")
        ---@param v cfg_equip_quality_column
        for _, v in pairs(qualityTbl) do
            if not string.isNullOrEmpty(v.logo) and entryLib.initialRating >= v.stage[1] and entryLib.initialRating <= v.stage[2] then
                GUI:setVisible(img_quality, true)
                GUI:Image_loadTexture(img_quality, v.logo, "Atlas/UIBagPanel.spriteatlas")
                if v.id == 2 then
                  is_zhuoyue = true
                end
                break
            end
        end
    end
    --卓越词条数量
    local entryCount = 0
    if self.itemData.entries then
        entryCount = table.count(self.itemData.entries)
    end
    if is_zhuoyue and entryCount > 0 then
        GUI:Image_loadTexture(img_quality, "zhuo_"..entryCount, "Atlas/UIBagPanel.spriteatlas")
        GUI:setContentSize(img_quality,23,52)
    else
        GUI:SetImageNativeSize(img_quality)
    end
    self.itemData.cfgId = self.itemData.itemCfgId
    local show = EquipFunc.CheckBagEquipIsBetter(self.itemData)
    if show then
        GUI:setVisible(self.view.arrow_, true)
        if SL:CheckEquipWear(self.itemData) == 1 then
            GUI:Image_loadTexture(self.view.arrow_, "ty_green", "Atlas/FG_TradePanel.spriteatlas")
        else
            GUI:Image_loadTexture(self.view.arrow_, "ty_yellow", "Atlas/FG_TradePanel.spriteatlas")
        end
    else
        GUI:setVisible(self.view.arrow_, false)
    end
    GUI:setVisible(self.view.xingyun, false)
    if self.itemData.luckAttr and not table.isNullOrEmpty(self.itemData.luckAttr) then
        GUI:setVisible(self.view.xingyun, true)
    end
end

function this:ShowQualityUI()
    --if self.qualityItem then
    --    self.qualityItem:SetData(self.itemData.itemCfgId, self.itemData.entrysize)
    --else
    --    if not GUI:IsWebGLAsync() then
    --        self.qualityItem = GUI:UIPanel_Open("dev/ui/Common/Item/KLEquipQualityEntry/KLEquipQualityEntryItem",
    --                self.view.root, self, { cfgId = self.itemData.itemCfgId, entryCount = self.itemData.entrysize }, true)
    --    else
    --        GUI:UIPanel_Open("dev/ui/Common/Item/KLEquipQualityEntry/KLEquipQualityEntryItem",
    --                self.view.root, self, { cfgId = self.itemData.itemCfgId, entryCount = self.itemData.entrysize }, true,
    --            function ( tempUI )
    --                self.qualityItem = tempUI
    --            end)
    --    end
    --end

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

function this:Close()
    if self.qualityItem then
        GUI:UIPanel_Close(nil, self.qualityItem)
        self.qualityItem = nil
    end
end

function this:Tick()
    if not self.itemData or not self.itemData.time then
        return false
    end
    self.itemData.time = self.itemData.time - 1
    if self.itemData.time <= 0 then
        GUI:Text_setString(self.view.txt_count_down, "")
        return true
    else
        if self.itemData.time <= 3*60*60 or self.itemData.publicityStatue then
            local timeInfo = SL:SecondToHMS(math.floor(self.itemData.time))
            local timeStr = string.format("%02s:%02s:%02s",timeInfo.h,timeInfo.m,timeInfo.s)
            local timeName = self.itemData.publicityStatue and "公示中" or "下架时间"
            GUI:Text_setString(self.view.txt_count_down, timeName .. " " .. timeStr)
        else
            GUI:Text_setString(self.view.txt_count_down, "")
        end
    end
end

return this
