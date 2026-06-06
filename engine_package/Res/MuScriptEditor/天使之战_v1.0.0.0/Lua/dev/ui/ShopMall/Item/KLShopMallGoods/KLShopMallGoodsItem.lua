---@class KLShopMallGoodsItem:UIKmlLuaPanelBase
---@field view KLShopMallGoodsItemView
local KLShopMallGoodsItem = class(UIKmlLuaPanelBase)
local this = KLShopMallGoodsItem
---创建时调用一次
function this:Init()
    GUI:SetOnPrefabControlLoaded(self.view.light, function()
        GUI:setContentSize(self.view.RawImage, 114, 100)
        GUI:setScaleY(self.view.RawImage, 0.5)
    end)
end

---创建或者刷新界面数据时调用
function this:Refresh()
end

---@param data MallProtos.MallGoods
function this:RefreshItem(data)
    self:HideLight()
    self.data = data
    ---@type cfg_shopMall_column
    local config = SL:GetConfig("cfg_shopMall", data.goodsId)
    self.config = config
    if not config then
        return
    end
    GUI:SetActive(self.view.HotIcon,config.hot == 1)
    GUI:Text_setString(self.view.txt_goods_title, config.itemName)
    local color = SL:GetItemColor(config.itemId)
    GUI:Text_setTextColor(self.view.txt_goods_title, "#ffffff")
    
    local level = SL:GetMetaValue(EMetaVarGetKey.LEVEL)
    if next(config.level) and config.level[1] > level then
        --显示等级限制
        GUI:Text_setString(self.view.Text_Condition, string.format("需要等级：%d", config.level[1]))
        GUI:Text_setTextColor(self.view.Text_Condition, "#ED2E2E")
    else
        --显示职业限制or不显示
        ---@type cfg_career_column
        local careerConfig
        if #config.occupation ~= 0 then
            --有职业限制
            local baseCareer = SL:GetMetaValue(EMetaVarGetKey.JOB)
            for _, v in pairs(config.occupation) do
                if baseCareer == v[1] then
                    careerConfig = self:GetCareerTbl(v[1], v[2])
                end
            end
        end
        GUI:Text_setString(self.view.Text_Condition, careerConfig and "职业：" .. careerConfig.name or "")
        GUI:Text_setTextColor(self.view.Text_Condition, self:CareerCheck(careerConfig) and "#FFFFFF" or "#ED2E2E")
    end
    local itemCount = data.count ~= 1 and tostring(data.count) or ""

    --[[if self.item then
        self.view.img_goods_icon.kmlControl:HideAllChilds()
    end
    self.item = GUI:Item_Create(self.view.img_goods_icon, {
        width = "100",
        height = "100",
        itemid = config.itemId,
        tips = "1",
        mfixsize = "100,100",
        bgscale = "0,0",
        itemCount = itemCount,
        textpos = "-20,20,0"
    })]]
    GUI:Item_setItemId(self.view.item_goods, config.itemId)
    GUI:Item_setItemCount(self.view.item_goods,itemCount)
    if config.limitBuy == 0 then
        GUI:Text_setString(self.view.txt_purchase_limitation, "")
    elseif config.limitBuy == 1 then
        --每日限购
        GUI:Text_setString(self.view.txt_purchase_limitation, "今日限购" .. data.limitCount .. "次")
    elseif config.limitBuy == 2 then
        --每周限购
        GUI:Text_setString(self.view.txt_purchase_limitation, "周限购" .. data.limitCount .. "次")
    elseif config.limitBuy == 3 then
        GUI:Text_setString(self.view.txt_purchase_limitation, "月限购" .. data.limitCount .. "次")
    elseif config.limitBuy == 4 then
        GUI:Text_setString(self.view.txt_purchase_limitation, "终身限购" .. data.limitCount .. "次")
    end
    GUI:setGrey(self.view.Bg, config.limitBuy ~= 0 and data.limitCount <= 0)

    local coinType = config.price[1]
    GUI:SetActive(self.view.img_money_icon,false)
    GUI:Image_loadTexture(self.view.img_money_icon, tostring(coinType), "Atlas/TS_Common.spriteatlas")
--[[    if coinType == 10010001 then
        GUI:Image_loadTexture(self.view.img_money_icon, "img_bag_01", "Atlas/UIBagPanel.spriteatlas")
    elseif coinType == 10020001 then
        GUI:Image_loadTexture(self.view.img_money_icon, "img_bag_02", "Atlas/UIBagPanel.spriteatlas")
    elseif coinType == 10030001 then
        GUI:Image_loadTexture(self.view.img_money_icon, "img_bag_03", "Atlas/UIBagPanel.spriteatlas")
    elseif coinType == 10040001 then
        GUI:Image_loadTexture(self.view.img_money_icon, "img_bag_04", "Atlas/UIBagPanel.spriteatlas")
    end]]
    local coinName = SL:GetConfig("cfg_item",config.price[1]).name
    if not coinName then
        coinName = ""
    end
    GUI:Text_setString(self.view.txt_price, tostring(config.price[2]).." "..config.priceText)
--[[    local ownCount = SL:GetBagItemCount(config.price[1])
    GUI:Text_setTextColor(self.view.txt_price, ownCount >= config.price[2] and "#FFFFFF" or "#ED2E2E")]]
    self:RefreshMoneyColor()
end
function this:ShowLight()
    GUI:setVisible(self.view.light, true)
end
function this:HideLight()
    GUI:setVisible(self.view.light, false)
end
function this:RefreshMoneyColor()
    if not self.config then
        --logError("Not found self.config")
        return
    end
    --[[local ownCount = SL:GetMetaValue(EMetaVarGetKey.MONEY,self.config.price[1])
    if self.config.price[1] == 10050001 then
        ownCount = ownCount + SL:GetMetaValue(EMetaVarGetKey.MONEY,10040001) --加上钻石
    end]]
    local ownCount = SL:GetBagItemCount(self.config.price[1])
    GUI:Text_setTextColor(self.view.txt_price, ownCount >= self.config.price[2] and "#FFFFFF" or "#ED2E2E")
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn_bg, self, self.btn_bgOnClick)
    GUI:AddOnClickEvent(self.view.ButtonBg, self, self.ButtonBgOnClick)
    SL:RegisterLUAEvent(LUA_EVENT_MONEYCHANGE, self.RefreshMoneyColor,self)
end

function this:btn_bgOnClick()
    if self.config.limitBuy ~= 0 and self.data.limitCount <= 0 then
        return
    end
    SL:OpenTips(nil, self.config.itemId,nil,nil,nil,{hideMask=false,hideBtn = true})
    --GUI:UIPanel_Open("dev/ui/ShopMall/Panel/KLShopMallBuyUI/KLShopMallBuyUIPanel", _, _, self.data)
end
function this:ButtonBgOnClick()
    if self.config.limitBuy ~= 0 and self.data.limitCount <= 0 then
        return
    end
    --[[local coin = SL:GetMetaValue(EMetaVarGetKey.MONEY,self.config.price[1])
    if self.config.price[1] == 10050001 then
        coin = coin + SL:GetMetaValue(EMetaVarGetKey.MONEY,10040001) --加上钻石
    end]]
    local coin = SL:GetBagItemCount(self.config.price[1])
    
    if coin < self.config.price[2] then
        SL:CommonItemGetPath(nil, self.config.price[1])
--[[        if self.config.price[1] == 10040001 then
            --钻石
            GUI:UIPanel_Close("dev/ui/ShopMall/Panel/KLShopMallBuyUI/KLShopMallBuyUIPanel")
            SL:CommonTipsMessage({ stringTblID = 235,
                                   showTips = "钻石不足，是否前往充值",
                                   callback = self.GotoRecharge,
                                   ui = self
            })
        else
            SL:TipMessage( string.format("%s不足",self.config.priceText), 1, NoticeType.NoticeMid )--货币不足
        end]]
        SL:TipMessage( string.format("%s不足",self.config.priceText), 1, NoticeType.NoticeMid )--货币不足
        return
    end
    
    local level = SL:GetMetaValue(EMetaVarGetKey.LEVEL)
    if next(self.config.level) and self.config.level[1] > level then
        ---@type cfg_string_column
        local tbl = SL:GetConfig("cfg_string",117)
        SL:TipMessage( tbl.text, 1, NoticeType.NoticeMid )
        return
    end
    ---@type cfg_career_column
    local careerCheck
    if #self.config.occupation ~= 0 then
        --有职业限制
        local baseCareer = SL:GetMetaValue(EMetaVarGetKey.JOB)
        for _, v in pairs(self.config.occupation) do
            if baseCareer == v[1] then
                local careerConfig = self:GetCareerTbl(v[1], v[2])
                careerCheck = careerCheck or self:CareerCheck(careerConfig)
            end
        end
    else
        careerCheck = true
    end
    if not careerCheck then
        ---@type cfg_string_column
        local tbl = SL:GetConfig("cfg_string",490)
        SL:TipMessage( tbl.text, 1, NoticeType.NoticeMid )
        return
    end
    SL:CommonTipsMessage({   showTips = "是否确认购买？" ,
                             ui = self,
                             sureBtnText = "确定",
                             cancelBtnText = "取消",
                             callback = function()
                                 SL:RequestBuyShopMallGoods(self.config.id, 1)
                             end
    })
    
end
function this:Close()
end

---@param careerConfig cfg_career_column
function this:CareerCheck(careerConfig)
    if not careerConfig then
        return true
    end
    local selfCareer = SL:MeData_GetCareer()
    ---@type cfg_career_column
    local career = self:GetCareerTbl(selfCareer.baseCareer, selfCareer.careerRank)
    if careerConfig.baseCareer == career.baseCareer and careerConfig.careerRank <= career.careerRank then
        return true
    end
    return false
end


function this:GetCareerTbl(baseCareer, careerRank)
    ---@type cfg_career_column[]
    local tbls = SL:GetConfigTable("cfg_career")
    for k, v in pairs(tbls) do
        if v.baseCareer == baseCareer and v.careerRank == careerRank then
            return v
        end
    end
end

return this
