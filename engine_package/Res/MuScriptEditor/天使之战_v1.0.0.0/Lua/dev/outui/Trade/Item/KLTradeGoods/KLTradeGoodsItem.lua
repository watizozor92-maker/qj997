---@class KLTradeGoodsItem:UIKmlLuaPanelBase
---@field view KLTradeGoodsItemView
local KLTradeGoodsItem = class(UIKmlLuaPanelBase)
local this = KLTradeGoodsItem
---创建时调用一次
function this:Init()

end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn_goods_item, self, self.ItemOnClick)
    GUI:AddOnClickEvent(self.view.btn_buy, self, self.BtnBuyOnClick)
    GUI:AddOnClickEvent(self.view.btn_xiajia, self, self.BtnDownOnClick)
    
    SL:RegisterTrigger(LUA_TRIGGER_TRAD_GOODS_MESSAGE,self.TipsShow,self)
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
    if data.publicityStatue then
        SL:CommonTipsMessage({ stringTblID = 225,
                               title = "提示",
                               callback = function()
                                   SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_TRADE_PRE_ORDER, { data.itemCfgId, data.itemId, data.type, data.ownerId })
                               end
        })
    else
        SL:CommonTipsMessage({ 
                                 showTips = "是否确认购买？", 
                                 callback = function() 
                                     SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_TRADE_BUY_GOODS, { data.itemCfgId, data.itemId, data.type, self.itemData.count, data.ownerId }) 
                                 end
                             })
        --SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_TRADE_BUY_GOODS, { data.itemCfgId, data.itemId, data.type, self.itemData.count, data.ownerId })
    end
end

function this:BtnDownOnClick()
       local data = { self.itemData.itemCfgId, self.itemData.itemId }
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_TRADE_OFF_GOODS, data)
end

function this:TipsShow(message)
    local item = message.items[1]
    SL:OpenTips("",item.cfgId,item.id,item.count,item)
    return true
end

function this:ItemOnClick()
    if self.clickFun then
        self.clickFun(self.buyUI, self)
        return
    end
    --SL:OpenTips(nil,self.itemData.itemCfgId)
    local type = SL:GetMetaValue(EMetaVarGetKey.ITEMTYPE, self.itemData.itemCfgId)
    local subType = SL:GetMetaValue(EMetaVarGetKey.ITEMSUBTYPE, self.itemData.itemCfgId)
    if type == 9 and subType == 1 then
        SL:OpenTips(nil, self.itemData.itemCfgId, self.itemData.itemId, nil, nil)
    else
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_TRADE_GOODS_INFO, { self.itemData.itemId, self.itemData.ownerId })
    end
    --GUI:UIPanel_Open("dev/outui/Trade/Panel/KLTradeBuy/KLTradeBuyPanel", nil, nil, self.itemData)
end

---创建或者刷新界面数据时调用
function this:Refresh()

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
    SL:CommonItemGetPath(nil,self.itemData.coinType)
    return false
end

---@class KLTradeGoodsItemData 上架道具实体信息
---@field itemCfgId number 商品配置Id
---@field itemId number 商品Id
---@field itemName string 商品名字
---@field entries table 词条信息
---@field entrySize number 词条属性数量
---@field entryNums table 筛选词条编号
---@field appendLv number 追加等级
---@field strengthLv number 强化等级
---@field grade number 品质
---@field ownerId string 商品所属人Id
---@field count number 商品数量
---@field unitPrice number 商品单价
---@field totalPrice number 商品总价
---@field job table 职业
---@field coinType number 货币类型
---@field publicityTime number 公示时间段
---@field upShelfDuration number 竞拍时间段
---@field tax table 税率
---@field subType number 商品子类型
---@field type number 商量类型
---@field preOrder table 预购人员Id列表
---@field publicityStatue boolean 是不是公示期间
---@field listingTime number 上架时间
---@field serverId number 服务器ID
---@field luaExtData string @lua扩展数据

---@param itemData KLTradeGoodsItemData
function this:UpdateData(itemData,isDown, searchType)
    self.itemData = itemData
    self.searchType = searchType
    GUI:SetOnPrefabControlLoaded(self.view.scroll_text_template, function()
        GUI:Text_setString(self.view.txt_item_name, self.itemData.itemName)
        local color = EquipFunc.GetEquipOrItemNameColor(tonumber(self.itemData.itemCfgId))
        GUI:Text_setTextColor(self.view.txt_item_name, color)
    end)
    GUI:Item_setItemId(self.view.item, itemData.itemCfgId)

    if itemData.itemCfgId == EMonthType.MonthCardTime then
        GUI:Item_UpdataData(self.view.item, { itemcount = 1 })
        GUI:SetActive(self.view.monthCardText, true)
        GUI:Text_setString(self.view.monthCardText, itemData.count .. "天")
    else
        GUI:SetActive(self.view.monthCardText, false)
        GUI:Item_UpdataData(self.view.item, { itemcount = itemData.count })
    end

    --GUI:Image_loadTexture(self.view.img_coin_type,self:GetCoinIcon(tonumber(itemData.cointype)),"Atlas/UIBagPanel.spriteatlas")
    local totalPrice = itemData.totalPrice
    local ownCount = 0
    local unit = ""
    if itemData.coinType == "30030305" then
        ownCount = InfoManager.monthCardInfo:GetMonthCardDayTime()
        unit = "天"
    else
        ownCount = SL:GetBagItemCount(tonumber(itemData.coinType), false)
    end
    if not isDown then
        GUI:setVisible(self.view.btn_buy, true)
        GUI:setVisible(self.view.btn_xiajia, false)
    else
        GUI:setVisible(self.view.btn_buy, false)
        GUI:setVisible(self.view.btn_xiajia, true)
    end
    GUI:Text_setTextColor(self.view.txt_price, ownCount >= totalPrice and "#00ff00" or "#FF2323")
    GUI:Text_setString(self.view.txt_price, tostring(math.ceil(totalPrice)) .. unit)
    GUI:Image_loadTexture(self.view.img_coin_type, tostring(itemData.coinType), "Atlas/UIBagPanel.spriteatlas")
    --GUI:Text_setString(self.view.txt_price, tostring(totalPrice))
    if itemData.publicityStatue then
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

    self:UpdateBuyClickFun(nil, nil)

    local strengthLevel = self.itemData.strengthLv or 0
    local appendLv = self.itemData.appendLv or 0
    GUI:Text_setString(self.view.strengthLevel_, strengthLevel ~= 0 and ("+" .. strengthLevel) or "")
    GUI:Text_setString(self.view.appendLevel_, appendLv ~= 0 and EquipFunc.GetEquipAppendLevelStr(appendLv) or "")
    local cfgId = itemData.itemCfgId
    local img_quality = self.view.imgQuality
    GUI:setVisible(img_quality, false)
    local itemCfg = SL:GetConfig("cfg_item", cfgId)
    if itemCfg.type ~= E_ItemType.Equip then
        GUI:setVisible(self.view.arrow_, false)
        GUI:setVisible(self.view.xinyun, false)
        return
    end
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
    -- 处理下正常 item 数据结构
    ---@type CommonProtos.Item
    local equip = {
        id = self.itemData.itemId,
        cfgId = self.itemData.itemCfgId,
        luaExtData = self.itemData.luaExtData,
    }
    if entryCount > 0 then
        equip.itemExtInfo = {
            equipExtInfo = {
                entryAttr = self.itemData.entries,
            }
        }
    end
    local show = EquipFunc.CheckBagEquipIsBetter(equip, "trade")
    if show then
        GUI:setVisible(self.view.arrow_, true)
        if SL:CheckEquipWear(self.itemData) == 1 then
            GUI:Image_loadTexture(self.view.arrow_, "ty_icon_arrow_small", "Atlas/TS_Common.spriteatlas")
        else
            GUI:Image_loadTexture(self.view.arrow_, "tips_yellow2", "Atlas/TS_Common.spriteatlas")
        end
    else
        GUI:setVisible(self.view.arrow_, false)
    end
    GUI:setVisible(self.view.xinyun, false)
    if self.itemData.luckAttr and not table.isNullOrEmpty(self.itemData.luckAttr) then
        GUI:setVisible(self.view.xinyun, true)
    end
end

function this:UpdateBuyClickFun(clickFun, ui)
    self.clickFun = clickFun
    self.buyUI = ui
end

function this:ShowQualityUI()
    if self.qualityItem then
        self.qualityItem:SetData(self.itemData.itemCfgId, self.itemData.entrySize)
    else
        -- GUI:UIPanel_Open("dev/ui/Common/Item/KLEquipQualityEntry/KLEquipQualityEntryItem",
        --     self.view.root, self, { cfgId = self.itemData.itemCfgId, entryCount = self.itemData.entrysize }, true,
        --     function(qualityItem)
        --         self.qualityItem = qualityItem
        --     end)
    end
end

--[[
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
]]

function this:Close()
    if self.qualityItem then
        GUI:UIPanel_Close(nil, self.qualityItem)
        self.qualityItem = nil
    end
end

function this:Tick()
    if not self.itemData or not self.itemData.time then
        if self.searchType == 2 then
            GUI:Text_setString(self.view.txt_count_down, "公示结束")
        else
            GUI:Text_setString(self.view.txt_count_down, "已下架")
        end
        return false
    end
    self.itemData.time = self.itemData.time - 1
    if self.itemData.time <= 0 then
        self.itemData.time = nil
        -- 时间结束
        if self.itemData.publicityStatue then
            self.itemData.publicityStatue = false
            if self.searchType == 2 then -- 如果在公示区
                GUI:Text_setString(self.view.txt_count_down, "公示结束")
                return false
            end
            self.itemData.time = math.floor(self.itemData.upShelfDuration / 1000)
        else
            -- 已经下架
            GUI:Text_setString(self.view.txt_count_down, self.searchType == 2 and "" or "已下架")
            return false
        end
    end
    if self.itemData.time <= 3 * 60 * 60 then
        local timeInfo = SL:SecondToHMS(math.floor(self.itemData.time))
        local timeStr = string.format("%02d:%02d:%02d", timeInfo.h, timeInfo.m, timeInfo.s)
        local timeName = self.itemData.publicityStatue and "公示中" or "下架时间"
        GUI:Text_setString(self.view.txt_count_down, timeName .. " " .. timeStr)
    else
        GUI:Text_setString(self.view.txt_count_down, "")
    end
end

return this
