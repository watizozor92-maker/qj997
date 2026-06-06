---@class KLShopMallBuyUIPanel:UIKmlLuaPanelBase
---@field view KLShopMallBuyUIPanelView
local KLShopMallBuyUIPanel = class(UIKmlLuaPanelBase)
local this = KLShopMallBuyUIPanel
---创建时调用一次
function this:Init()
    ---@type MallProtos.MallGoods
    local data = self.args
    ---@type cfg_shopMall_column
    self.config = SL:GetConfig("cfg_shopMall", data.goodsId)
    EquipFunc.tipsHeight = 0
    SL:OpenTips("mall", self.config.itemId,nil,nil,nil,{hideMask=true})
end

---创建或者刷新界面数据时调用
function this:Refresh()
    GUI:Text_setString(self.view.InputFieldLevel, "1")
    self:RefreshTotalPrice()
    if EquipFunc.tipsHeight and EquipFunc.tipsHeight ~= 0 then
        self:UpdateHeight(EquipFunc.tipsHeight)
    end
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.ClickMask, self, self.ClickMaskOnClick)
    GUI:AddOnClickEvent(self.view.BtnBuy, self, self.BtnBuyOnClick)
    GUI:Input_SetOnEndEdit(self.view.InputFieldLevel, self, self.InputFieldLevelOnEndEdit)
    GUI:AddOnClickEvent(self.view.BtnLevelAdd, self, self.BtnLevelAddOnClick)
    GUI:AddOnClickEvent(self.view.BtnLevelMinus, self, self.BtnLevelMinusOnClick)
end

function this:BtnLevelAddOnClick()
    local text = GUI:Text_getString(self.view.InputFieldLevel)
    local inputNum = tonumber(text)
    GUI:Text_setString(self.view.InputFieldLevel, tostring(inputNum + 1))
    self:CheckInput()
    self:RefreshTotalPrice()
end

function this:BtnLevelMinusOnClick()
    local text = GUI:Text_getString(self.view.InputFieldLevel)
    local inputNum = tonumber(text)
    inputNum = inputNum - 1
    GUI:Text_setString(self.view.InputFieldLevel, tostring(inputNum))
    self:CheckInput()
    self:RefreshTotalPrice()
end

function this:InputFieldLevelOnEndEdit(_, _, eventData)
    local text = eventData[1]
    GUI:Text_setString(self.view.InputFieldLevel, tostring(text))
    self:CheckInput()
    self:RefreshTotalPrice()
end

function this:RefreshTotalPrice()
    local text = GUI:Text_getString(self.view.InputFieldLevel)
    local inputNum = tonumber(text)
    local totalPrice = self.config.price[2] * inputNum
    GUI:Text_setString(self.view.TextTotalPrice, tostring(totalPrice))
    local ownCount = SL:GetMetaValue(EMetaVarGetKey.MONEY,self.args.coinType)
    if self.args.coinType == 10050001 then
        ownCount = ownCount + SL:GetMetaValue(EMetaVarGetKey.MONEY,10040001) --加上钻石
    end
    GUI:Text_setTextColor(self.view.TextTotalPrice, ownCount >= totalPrice and "#00ff00" or "#ff2323")
    GUI:Image_loadTexture(self.view.icon_money, tostring(self.config.price[1]), "Atlas/TS_Common.spriteatlas")
end

function this:ClickMaskOnClick()
    GUI:UIPanel_Close("dev/ui/ShopMall/Panel/KLShopMallBuyUI/KLShopMallBuyUIPanel")
    local itemGetPathPanel = GUI:GetUI("dev/ui/Tips/Panel/KLIUItemTipsOther/KLIUItemTipsOtherPanel")
    if itemGetPathPanel then
        GUI:UIPanel_Close("dev/ui/Tips/Panel/KLIUItemTipsOther/KLIUItemTipsOtherPanel")
    end
    local MountTipPanel = GUI:GetUI("dev/outui/Mount/Panel/KLMountTip/KLMountTipPanel")
    if MountTipPanel then
        GUI:UIPanel_Close("dev/outui/Mount/Panel/KLMountTip/KLMountTipPanel")
    end
end

function this:BtnBuyOnClick()
    local coin = SL:GetMetaValue(EMetaVarGetKey.MONEY,self.config.price[1])
    if self.config.price[1] == 10050001 then
        coin = coin + SL:GetMetaValue(EMetaVarGetKey.MONEY,10040001) --加上钻石
    end
    if coin < self.config.price[2] * tonumber(GUI:Text_getString(self.view.InputFieldLevel)) then
        
        if self.config.price[1] == 10040001 then
            --钻石
            GUI:UIPanel_Close("dev/ui/ShopMall/Panel/KLShopMallBuyUI/KLShopMallBuyUIPanel")
            SL:CommonTipsMessage({ stringTblID = 235,
                                   showTips = "钻石不足，是否前往充值",
                                   callback = self.GotoRecharge,
                                   ui = self
            })
        else
            SL:TipMessage( SL:GetConfig('cfg_string', 269).text, 1, NoticeType.NoticeMid )--货币不足
        end
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
    
    local text = GUI:Text_getString(self.view.InputFieldLevel)
    local inputNum = tonumber(text)
    if coin < self.config.price[2] * tonumber(GUI:Text_getString(self.view.InputFieldLevel)) then

        if self.config.price[1] == 10040001 then
            --钻石
            GUI:UIPanel_Close("dev/ui/ShopMall/Panel/KLShopMallBuyUI/KLShopMallBuyUIPanel")
            SL:CommonTipsMessage({ stringTblID = 235,
                                   showTips = "钻石不足，是否前往充值",
                                   callback = self.GotoRecharge,
                                   ui = self
            })
        else
            SL:TipMessage( SL:GetConfig('cfg_string', 269).text, 1, NoticeType.NoticeMid )--货币不足
        end
        return
    end
    SL:RequestBuyShopMallGoods(self.config.id, inputNum)
    GUI:UIPanel_Close("dev/ui/ShopMall/Panel/KLShopMallBuyUI/KLShopMallBuyUIPanel")
end

function this:GotoRecharge()
    GUI:UIPanel_Close("dev/outui/ShopMain/Panel/KLShopMain/KLShopMainPanel")
    GUI:UIPanel_Open("dev/outui/ShopMain/Panel/KLShopMain/KLShopMainPanel",nil,nil,{2})
end

function this:Close()
    GUI:UIPanel_Close("dev/outui/Mount/Panel/KLMountTip/KLMountTipPanel")
    SL:CloseTips()
    self:UnRegistEvents()
end

function this:CheckInput()
    local inputStr = GUI:Text_getString(self.view.InputFieldLevel)
    local inputNum = tonumber(inputStr)
    if not inputNum then
        GUI:Text_setString(self.view.InputFieldLevel, "1")
        self:RefreshTotalPrice()
        return
    end
    local maxCount = 99
    if self.config.limitBuy ~= 0 then
        ---@type MallProtos.MallGoods
        local data = self.args
        maxCount = data.limitCount
    end
    if inputNum >= maxCount then
        GUI:Text_setString(self.view.InputFieldLevel, tostring(maxCount))
        self:RefreshTotalPrice()
        return
    end
    if inputNum <= 0 then
        GUI:Text_setString(self.view.InputFieldLevel, tostring(maxCount))
        self:RefreshTotalPrice()
        return
    end
end

function this:UpdateHeight(bg_height)
    local add = (bg_height - 156) / 2
    GUI:setPositionY(self.view.root, add)
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
