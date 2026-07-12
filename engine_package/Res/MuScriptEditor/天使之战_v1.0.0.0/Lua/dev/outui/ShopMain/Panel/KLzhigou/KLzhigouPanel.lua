---@class KLzhigouPanel:UIKmlLuaPanelBase
---@field view KLzhigouPanelView
local KLzhigouPanel = class(UIKmlLuaPanelBase)
local this =KLzhigouPanel
function this:AsyncLoadUI()
end
---创建时调用一次
function this:Init()
    self.goodsList = {}
    GUI:DataListInitData(self.view.RechargeGoodsList, function() 
        return self:GetAllShowGoods() 
    end,function() 
    end,function() 
    end, function(realIndex) 
        self:ItemUpdateFun(realIndex)
    end)
    SL:KeepOpenPanel("KLzhigouPanel",true)
    self.all_img = {}
    self.all_img[4001]="recharge01"
    self.all_img[4002]="recharge02"
    self.all_img[4003]="recharge03"
    self.all_img[4004]="recharge04"
    self.all_img[4005]="recharge05"
    self.all_img[4006]="recharge06"
    self.all_img[4007]="recharge07"
    self.all_img[4008]="recharge08"
    self.all_img[4009]="recharge09"
end
--请求充值
function this:BuyOnClick(_,eventData)
    GUIUtil.SDKPay(eventData.rechargeData,1)
end
function this:ItemUpdateFun(realIndex)
    local data = self.goodsList[realIndex + 1]
    local FirstReward = GUI:GetChildControl(self.view.RechargeGoodsList, realIndex, 'FirstReward')
    local showItems = GUI:GetChildControl(self.view.RechargeGoodsList, realIndex, 'showItems')
    local item_Tisp = GUI:GetChildControl(self.view.RechargeGoodsList, realIndex, 'item_Tisp')
    local img_reward = GUI:GetChildControl(self.view.RechargeGoodsList, realIndex, 'img_reward')
    local txt_reward = GUI:GetChildControl(self.view.RechargeGoodsList, realIndex, 'txt_reward')
    local btn_buy = GUI:GetChildControl(self.view.RechargeGoodsList, realIndex, 'btn_buy')
    local priceCount = GUI:GetChildControl(self.view.RechargeGoodsList, realIndex, 'priceCount')
    local item_goods2 = GUI:GetChildControl(self.view.RechargeGoodsList, realIndex, "item2")
    --不显示首充赠送
    data.isShowFirst = false
    --是否是首充
    GUI:SetActive(FirstReward,data.isShowFirst)
    --展示首充道具
    if data.isShowFirst then
        local itemRewards = {}
       
        local showRewards = {}
        for _, v in pairs(itemRewards) do
            if v[1] == SL:MeData_GetCareer().baseCareer then--基础职业
                table.insert(showRewards,v)
            end
        end
        GUI:HideAllChilds(showItems)
        for i = 1, table.count(showRewards)  do
            local itemId = showRewards[i][2]
            local item = GUI:Item_Create(showItems, {
                width = "50",
                height = "50",
                itemid = itemId,
                mfixsize = "80,80",
                tips = "1",
                itemcustomcount = Misc.GetSampleNumberString(showRewards[i][3])
            })
            GUI:AddOnClickEvent(item, self, function()
                SL:OpenTips(nil, itemId)
            end)
        end
    end   
      
    local itemData = data.rechargeData.gain[1]
    local name = SL:GetConfig("cfg_item", itemData[1]).name
    --加载道具图片
    GUI:Item_setItemId(item_goods2, itemData[1])
    --获得道具数量
    GUI:Text_setString(txt_reward, name.." x"..tostring(itemData[2]))
    --请求购买
    local price = "￥"..tostring(data.rechargeData.amount)
   
    GUI:Button_setTitleText(btn_buy,price)
    GUI:AddOnClickEvent(btn_buy,self,self.BuyOnClick,{ rechargeData = data.rechargeData})
    GUI:AddOnClickEvent(item_Tisp, self, function()
        self:item_TispOnClick(data)
    end)    
end
function this:GetAllShowGoods()
    return table.count(self.goodsList)
end
---注册UI事件和服务器消息
function this:RegistEvents()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_RECHARGE_ACTION,self.RES_RECHARGE_ACTION,self)
    SL:RegisterLUAEvent(LUA_EVENT_Open_MainButtonList, self.LUA_EVENT_Open_MainButtonList, self)     
    GUI:AddOnClickEvent(self.view.closeBtn, self, self.OnClickcloseBtn)
    GUI:AddOnClickEvent(self.view.BtnReturn, self, self.ReturnMall)
end
function this:item_TispOnClick(data)  
    local itemData = data.rechargeData.gain[1] 
    SL:OpenTips(nil, itemData[1],nil,nil,nil,{hideMask=false,hideBtn = true})
    --SL:OpenTips(nil, itemData[1])
end
function this:LUA_EVENT_Open_MainButtonList()
    SL:HideMainPanel()
end
function this:RES_RECHARGE_ACTION(_,message)
    if message.type == "1" then
        self:RefreshShowGoodInfoMess(_, message.data.list)
        if self.refreshTimer then
            SL:UnSchedule(self.refreshTimer)
            self.refreshTimer = nil
        end
        local endDayTime = tonumber(message.data.endDayTime)*1000
        local leftTime = endDayTime - Time.GetServerTime()
        GUI:setVisible(self.view.countDownRoot,leftTime>0)

        if leftTime>0 then
            self.refreshTimer = SL:Schedule(self.refreshTimer,0,1,-1,function()
                local leftTime1 = endDayTime - Time.GetServerTime()
                if leftTime1 <= 0 then
                    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_RECHARGE_ACTION, {type=1, action="panel"})
                    SL:UnSchedule(self.refreshTimer)
                    self.refreshTimer = nil
                else
                    local time_str = "<color=#ff2323>"..GUIUtil.FormatTimeDHM_S(leftTime1//1000) .."</color>"
                    GUI:Text_setString(self.view.refreshTime,time_str)
                end
            end)
        end
    end
end
---@param message 
--rechargeId:number cfg_recharge表内id
--isShowFirst:boolean 是否需要展示首充奖励 true展示
--isRewardFirst：boolean 首次首充还是重置首充 true首次首充
function this:RefreshShowGoodInfoMess(_,message)
    self.goodsList = {}
    local data = message
    local allGoods = {}
    for _, v in pairs(data) do
        if type(v) == "table" then
            v.rechargeData = SL:GetConfig("cfg_recharge",tonumber(v.rechargeId))
            table.insert(allGoods,v)
        end
    end
    table.sort(allGoods,function(a,b)
        return a.rechargeData.amount < b.rechargeData.amount --按照价格高低排序
    end)
    self.goodsList = allGoods
    GUI:DataListUpdateData(self.view.RechargeGoodsList)
end
function this:RefreshShowGoodInfos()
    local allGoods = SL:FindConfigs("cfg_recharge", "type", 22)
    local all_data = {}
    for i, v in ipairs(allGoods) do
        all_data[i]={}
        all_data[i].rechargeData = allGoods[i]
    end
    table.sort(all_data,function(a,b)
        return a.rechargeData.amount < b.rechargeData.amount --按照价格高低排序
    end)
    self.goodsList = all_data
    GUI:DataListUpdateData(self.view.RechargeGoodsList)
end
---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
    self:RefreshShowGoodInfos()
end

function this:Hide()
end

function this:Close()
    if self.refreshTimer then
        SL:UnSchedule(self.refreshTimer)
        self.refreshTimer = nil
    end
    --GUI:UIPanel_Close("dev/outui/ShopMain/Panel/KLzhigou/KLzhigouPanel")
end
function this:OnClickcloseBtn()
    GUI:UIPanel_Close("dev/outui/ShopMain/Panel/KLzhigou/KLzhigouPanel")    
end

function this:ReturnMall()
    GUI:UIPanel_Close("dev/outui/ShopMain/Panel/KLzhigou/KLzhigouPanel")
    local PlayerInfoPanel = GUI:GetUI("dev/ui/MainUI/Panel/KLUIPlayerInfo/KLUIPlayerInfoPanel")
    PlayerInfoPanel:OpenShop(nil,nil,{true})
end
return this
