---@class KLShopMallPanel:UIKmlLuaPanelBase
---@field view KLShopMallPanelView
local KLShopMallPanel = class(UIKmlLuaPanelBase)
local this =KLShopMallPanel
local subTabItemPath = "dev/ui/ShopMall/Item/KLShopMallSubTab/KLShopMallSubTabItem"
---创建时调用一次
function this:Init()
    self.pageCount = 1
    self.AllGoodList={}
    ---@type MallProtos.MallGoods[]
    self.goodsList = {}
    ---@type table<KingML.KmlControl,KLShopMallGoodsItem>
    self.goodsItem = {}
    ---@type table<number,MallProtos.MallGoods>
    self.goodsListMap = {}
    ---@type table<number,KLShopMallGoodsItem>
    self.goodsItemMap = {}
    self.homeToggleMap = {}
    self.curSelectTabTbl = 1
    local isRecharge = false
    if self.args then
        ---@type cfg_menu_layer_column
        local tabId = nil
        if type(self.args) == "table" then
            tabId = tonumber(self.args[1])
        else
            tabId = tonumber(self.args)
        end
        if SL:HasConfig("cfg_menu_layer", tabId) then
            local jumpTbl = SL:GetConfig("cfg_menu_layer", tabId)
            self.jumpHomeTabId = jumpTbl.parentID
            self.jumpSubTabId = jumpTbl.id
        else
            isRecharge = true
        end
    end
    local level = SL:GetMetaValue(EMetaVarGetKey.LEVEL)
    ---@type cfg_menu_layer_column[]
    local homeTabConfigs = {}
    ---@type cfg_menu_layer_column[]
    local tblList = SL:GetConfigTable("cfg_menu_layer")
    for _, v in pairs(tblList) do
        if v.parentID == 1000 and v.level <= level and (v.lieMoSeason ==0 or v.lieMoSeason == InfoManager.uiHuntingDemonsInfo:GetCurSeason()) then
            table.insert(homeTabConfigs,v)
        end
    end
    GUI:DataListInitData(self.view.money_list,
                         function()
                             return #self.money end,
                         function(realIndex) end,
                         nil,
                         function(realIndex,item)
                             return self:ItemUpdateFun(realIndex,item) end,
                         nil)
    GUI:DataListInitData(self.view.ShopMallGoodsList,
                         function()
                             return self:ShopMallCountGetFun() end,
                         function(realIndex)
                             return self:ShopMallItemGetFun(realIndex) end,
                         nil,
                         function(realIndex,item)
                             return self:ShopMallItemUpdateFun(realIndex,item) end,
                         nil)

    for k,homeTabConfig in pairs(homeTabConfigs) do
        ---@type KLShopMallHomeTabItem
        local homeTab = GUI:UIPanel_Open("dev/ui/ShopMall/Item/KLShopMallHomeTab/KLShopMallHomeTabItem",self.view.TopHomeToggleGroup,self,homeTabConfig,true, function(homeTab)
            local jump = (self.jumpHomeTabId and self.jumpHomeTabId == homeTabConfig.id) or (not self.jumpHomeTabId and k == 1 and not isRecharge)
            if jump then
                GUI:Toggle_setIsOn(homeTab.view.KmlShopMallHomeTab,true)
                self:RefreshSubTab(homeTabConfig.id)
                self.jumpHomeTabId = nil
            end

            GUI:SetToggleOnValueChange(homeTab.view.KmlShopMallHomeTab,self,self.HomeTabOnToggle,homeTabConfig.id)
            self.homeToggleMap[homeTabConfig.id] = homeTab.view.KmlShopMallHomeTab
        end)
    end

    GUI:SetParent(self.view.dianshuchongzhi_btn,GUI:GetRectTransform(self.view.TopHomeToggleGroup))
    GUI:SetToggleGroup(self.view.dianshuchongzhi_btn,self.view.TopHomeToggleGroup)
    GUI:SetParent(self.view.zhigou_btn,GUI:GetRectTransform(self.view.TopHomeToggleGroup))
    GUI:SetToggleGroup(self.view.zhigou_btn,self.view.TopHomeToggleGroup)
    GUI:SetActive(self.view.LeftSubToggleGroup,true)
    
    if isRecharge then
        self.curSelectTabTbl = nil
        GUI:SetTogDefaultThis(self.view.dianshuchongzhi_btn)
        GUI:SetTogDefaultThis(self.view.zhigou_btn)
        self:dianshuchongzhi_btnOnClick(nil, nil, { true })        
        self:zhigou_btnOnClick(nil, nil, { true })
    end
    --self.hasInit = 

    local mountId = InfoManager.mountInfo.ride_mount_id
    if InfoManager.mountInfo.isHasOwnerMount and not InfoManager.mountInfo.isRankShowMount then
    mountId = 0
    end
    local behaviour = EBehaviourType_Stand.Stand
    local rotation = mountId == 0 and 50 or 10
    SL:UIModel_Recycle(self.curShowRole)
    local roleInfoExtData = InfoManager.cardShapeShiftInfo:DeepCopy(SL:MeData_GetRoleExtInfo().roleInfoExtData)
    for k, v in pairs(roleInfoExtData.equip) do
        local i,j = SL:GetWearBarAndPosBaseEquipIndex(v.index)
        local equip = SL:GetMetaValue("EQUIP_TARGET_DATA", i,j)
        if equip then
            local strengthLevel = EquipFunc.GetEquipStrengthLevel(equip)
            v.gmExtInfo.luaExt=string.format("{\"strengthlv\":%d}", strengthLevel)
        end
    end
    -- self.curShowRole = SL:UIModel_Create(GUI:GetRectTransform(self.view.img2),SL:GetMetaValue(EMetaVarGetKey.UID),SL:MeData_GetCareer(),SL:MeData_GetLevel(),SL:GetMetaValue(EMetaVarGetKey.USER_NAME),mountId,EAction.Stand,behaviour,roleInfoExtData,0,-100,-76,120,0,rotation,0)
    -----------------------beibao--------------

    local bag_info = string.split(SL:GetConfig("cfg_global", 6).value, '#')
    local forbidNum = 0
    local increaseRow, needLockRow
    self.maxHor = tonumber(bag_info[1])
    self.maxVet = tonumber(bag_info[2])

    local function openBag()
    ---@type KLUIBagTileScrollViewItem
    ---@param bagTileScrollView KLUIBagTileScrollViewItem
    GUI:UIPanel_Open("dev/ui/Common/Item/KLUIBagTileScrollView/KLUIBagTileScrollViewItem", self.view.img1, self,
    {
    itemList = SL:GetMetaValue("BAG_DATA")[1],
    id = EBagTileScrollViewId.Bag,
    forbidCount = SL:GetMetaValue("BAG_FORBID_COUNT") - forbidNum,
    hor = self.maxHor,
    vet = self.maxVet,
    forbidClickCallback = self.forbidClick,
    dragEndCallback = self.dragEnd,
    JumpSelectId = self.JumpSelectId,
    parent = self,
    contentScale = 1.33,
    y=-1,
    },true,function(bagTileScrollView)
    self.bagTileScrollView = bagTileScrollView
    self.bagTileScrollView:ResetPos()
    self.bagTileScrollView:RefreshInfo()
    GUI:setContentSize(self.bagTileScrollView.view.BagTileScrollViewPrefab, 345, 335)
    GUI:setPosition(self.bagTileScrollView.view.BagTileScrollViewPrefab, 13, -268)
    GUI:setContentSize(self.bagTileScrollView.view.prefabBagTileScrollView_, 345, 335)
    if needLockRow and needLockRow > 0 then
    self.bagTileScrollView:RefreshRedGrid(needLockRow * self.maxVet)
    end
    if self.bagInfoChangeCallBack then
    self.bagInfoChangeCallBack()
    self.bagInfoChangeCallBack = nil
    end
    end)
    end
    if SL:GetIsWebGL() then
    openBag()
    else
    if not self.bagTileScrollView then
    openBag()
    else
    --预加载打开刷新背包
    local itemList = SL:GetMetaValue("BAG_DATA")[1]
    local forbidCount = SL:GetMetaValue("BAG_FORBID_COUNT") - forbidNum
    self.bagTileScrollView.itemList = itemList
    self.bagTileScrollView.forbidCount = forbidCount
    self.bagTileScrollView.hor = self.maxHor
    self.bagTileScrollView.vet = self.maxVet
    self.bagTileScrollView.id = EBagTileScrollViewId.Bag
    self.bagTileScrollView.forbidClickCallback = self.forbidClick
    self.bagTileScrollView.dragEndCallback = self.dragEnd
    self.bagTileScrollView.JumpSelectId = self.JumpSelectId
    self.bagTileScrollView.parent = self

    self.bagTileScrollView:RefreshForbidGrid(forbidCount)
    self.bagTileScrollView:ResetPos()
    self.bagTileScrollView:RefreshItemByItem(itemList,function()
    ---@param v KLBagItemItem
    for i, v in pairs(self.bagTileScrollView.indexToItem) do
    v:RegistEvents()
    end
    end)
    if needLockRow and needLockRow > 0 then
    self.bagTileScrollView:RefreshRedGrid(needLockRow * self.maxVet)
    end

    end
    end
    
end

---@param item UIKmlLuaControl
function this:ItemUpdateFun(index,item)
    local moneyId = self.money[index + 1]
    local moneyIcon = GUI:GetChildById(item,"img_money_icon")
    GUI:Image_loadTexture(moneyIcon,moneyId,"Atlas/UIBagPanel.spriteatlas")
    local btnTip = GUI:GetChildById(item,"btn_money_tip")
    GUI:AddOnClickEvent(btnTip,self,self.BtnAddOnClick,moneyId)
    local textMoneyCount = GUI:GetChildById(item,"text_money_count")
    GUI:Text_setString(textMoneyCount,tostring(SL:GetMetaValue(EMetaVarGetKey.MONEY, moneyId)))
end

function this:ShopMallCountGetFun()
    return #self.goodsList
end

function this:ShopMallItemGetFun(realIndex)
    ---@type KLShopMallGoodsItem
    local item = GUI:UIPanel_Open("dev/ui/ShopMall/Item/KLShopMallGoods/KLShopMallGoodsItem",self.view.ShopMallGoodsList,self,nil,true,function(item)
        local needRefresh = self.goodsItem[item.view.root] == false --经历过刷新失败的情况
        self.goodsItem[item.view.root] = item
        if needRefresh then
            self:ShopMallItemUpdateFun(realIndex,item.view.root)
        end
    end )

    return item.view.root
end

function this:ShopMallItemUpdateFun(realIndex,item)
    if not self.goodsItem[item] then
        self.goodsItem[item] = false
        return
    end
    local data = self.goodsList[realIndex + 1]
    local goodsItem = self.goodsItem[item]
    goodsItem:RefreshItem(data)
    if self.args and type(self.args) == "table" and self.args.lightItems then
        if table.contains(self.args.lightItems, data.goodsId) then
            goodsItem:ShowLight()
        end
    end
    GUI:SetID(goodsItem.view.ButtonBg, "ButtonBg"..tostring(data.goodsId))
    self.goodsListMap[data.goodsId] = data
    self.goodsItemMap[data.goodsId] = goodsItem
    --logError("realIndex2----"..realIndex)
    if self.guideId and self.selectId and self.selectId == data.goodsId then
        local panel = GUI:GetChildById(item,"ButtonBg"..tostring(self.selectId).."_clonePanel")
        if panel then
            KLGuideManager.HidePointControlGuide(self.guideId)
        end
        if self.co then
            Coroutine.Stop(self.co)
            self.co = nil
        end
        self.co = Coroutine.Start(function()
            Coroutine.WaitForEndOfFrame()
            KLGuideManager.AddPointControlGuide("KLShopMallPanel", "ButtonBg"..tostring(self.selectId), self.guideId)
            self.btnSelectItem = item
        end)
    end
    if self.btnSelectItem and self.guideId and GUI:getVisible(self.btnSelectItem) == false then
        KLGuideManager.HidePointControlGuide(self.guideId)
    end
end

function this:HomeTabOnToggle(control,customData,eventData)
    if eventData[1] and self.curSelectTabTbl ~= customData then
        self.curSelectTabTbl = customData
        self:RefreshSubTab(customData)
    end
end

function this:RefreshSubTab(homeTabId)
    if self.subWins[subTabItemPath] then
        for _, win in pairs(self.subWins[subTabItemPath]) do
            GUI:UIPanel_Close(subTabItemPath,win)
        end
        table.clear(self.subWins[subTabItemPath])
    end
    local level = SL:GetMetaValue(EMetaVarGetKey.LEVEL)
    ---@type cfg_menu_layer_column[]
    local subTabConfigs = {}
    ---@type cfg_menu_layer_column[]
    local tblList = SL:GetConfigTable("cfg_menu_layer")
    for _, v in pairs(tblList) do
        if v.parentID == homeTabId and v.level <= level and (v.lieMoSeason ==0 or v.lieMoSeason == InfoManager.uiHuntingDemonsInfo:GetCurSeason()) then
            table.insert(subTabConfigs,v)
        end
    end
    if table.isNullOrEmpty(subTabConfigs) then
        self.goodsList = {}
        self.pageCount = 1
        GUI:Text_setText(self.view.pageCount,tostring(self.pageCount))
        GUI:DataListUpdateData(self.view.ShopMallGoodsList)
    end
    for k,subTabConfig in pairs(subTabConfigs) do
        ---@type KLShopMallSubTabItem
        GUI:UIPanel_Open(subTabItemPath,self.view.LeftSubToggleGroup,self,subTabConfig,true, function(subTab)
            if (self.jumpSubTabId and self.jumpSubTabId == subTabConfig.id) or (not self.jumpSubTabId and k == 1) then
                GUI:Toggle_setIsOn(subTab.view.ToggleLevel,true)
                self:SubTabOnToggle(_,subTabConfig,{true})
                self.jumpSubTabId = nil
            end
            GUI:SetToggleOnValueChange(subTab.view.ToggleLevel,self,self.SubTabOnToggle,subTabConfig)
        end)

    end
end

---@param customData cfg_menu_layer_column
function this:SubTabOnToggle(_,customData,eventData)
    if eventData[1] then
        GUI:SetActive(self.view.ShopMallItems,true)
        SL:RequestShopMallGoodsInfo(customData.id)
        self.curSelectSubTabTbl = customData
        self:RefreshMoneyInfo()
    end
end

---创建或者刷新界面数据时调用
function this:Refresh()
    SL.HideMainPanel()
    self:RefreshMoneyInfo()

    if SL:GetIsWebGL() then
        --GUI:setAnchorPoint(self.view.CloseBtn,1,1)
        --GUI:setPosition(self.view.CloseBtn,0,0)
    end
    self.lightItems = nil
    if self.args and type(self.args) == "table" and self.args.lightItems then
        self.lightItems = self.args.lightItems
    end
end

function this:RefreshMoneyInfo()
    if self.curSelectSubTabTbl then
        self.money = self.curSelectSubTabTbl.money
        GUI:DataListUpdateData(self.view.money_list)
    end
    -- local count = 0
    -- local scoreCount = 0
    -- local name1 = 0
    -- local name2 = 0
    -- local money_infoTbl = string.split(SL:GetConfig("cfg_global",270001).value,'|')
    -- if money_infoTbl then
    --     local money_info1 = string.split(money_infoTbl[1],'#')
    --     if money_info1 then
    --         for i,v in pairs(money_info1) do
    --             if i > 1 then
    --                 count = count + SL:GetBagItemCount(tonumber(v),false)
    --             end
    --         end
    --         name1 = tonumber(v)
    --     end

    --     local money_info2 = string.split(money_infoTbl[2],'#')
    --     if money_info2 then
    --         for i,v in pairs(money_info2) do
    --             if i > 1 then
    --                 scoreCount = scoreCount + SL:GetBagItemCount(tonumber(v),false)
    --             end
    --         end
    --         name2 = money_info2[1]
    --     end
        
        
    --     -- GUI:Text_setString(self.view.coin_name,money_info1[1])
    --     -- GUI:TextAtlas_setString(self.view.scoreName,money_info2[1])
    --     -- GUI:Image_loadTexture(self.view.goldIcon, icon1,"Atlas/QJ5_ItemLooksIcon.spriteatlas")
    --     -- GUI:Image_loadTexture(self.view.diamondIcon, icon2,"Atlas/QJ5_ItemLooksIcon.spriteatlas")
    --     GUI:Text_setString(self.view.coin_count,tostring(count))
    --     GUI:Text_setString(self.view.scoreCount,tostring(scoreCount)) 
    -- end

    
    --[[    GUI:Text_setString(self.view.GoldCount,tostring(SL:GetBagItemCount(10010001)))
        GUI:Text_setString(self.view.QjCount,tostring(SL:GetBagItemCount(10020001)))
        GUI:Text_setString(self.view.QjBindCount,tostring(SL:GetBagItemCount(10030001)))
        GUI:Text_setString(self.view.DiamondCount,tostring(SL:GetBagItemCount(10040001)))]]
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.CloseBtn,self,self.CloseBtnOnClick)
    SL:RegisterLuaNetMsg(MessageDef.ResMallGoodsInfoMessage,self.ResMallGoodsInfoMessage,self)
    SL:RegisterLuaNetMsg(MessageDef.ResBuyMallGoodsMessage,self.ResBuyMallGoodsMessage,self)
    SL:RegisterLUAEvent(LUA_EVENT_MONEYCHANGE,self.RefreshMoneyInfo,self)
    GUI:SetToggleOnValueChange(self.view.dianshuchongzhi_btn,self,self.dianshuchongzhi_btnOnClick)    
    GUI:SetToggleOnValueChange(self.view.zhigou_btn,self,self.zhigou_btnOnClick)
    GUI:AddOnClickEvent(self.view.reduceBtn,self,self.reduceBtnOnClick)
    GUI:AddOnClickEvent(self.view.addBtn,self,self.addBtnOnClick)
    -- GUI:AddOnClickEvent(self.view.img7,self,self.img7OnClick)
    -- GUI:AddOnClickEvent(self.view.img14,self,self.img14OnClick)
    SL:RegisterLUAEvent(Event.BagInfo_Change, self.BagInfo_Change, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_SETTING_EQUIP_APPEAR, self.LUA_EVENT_TAKE_ON_EQUIP, self)
    --SL:RegisterLUAEvent(LUA_EVENT_TAKE_ON_EQUIP, self.LUA_EVENT_TAKE_ON_EQUIP, self)
    --[[    GUI:AddOnClickEvent(self.view.BtnGoldGetWayTip,self,self.BtnAddOnClick,10010001)
        GUI:AddOnClickEvent(self.view.BtnQjGetWayTip,self,self.BtnAddOnClick,10020001)
        GUI:AddOnClickEvent(self.view.BtnQjBindGetWayTip,self,self.BtnAddOnClick,10030001)
        GUI:AddOnClickEvent(self.view.BtnDiamondGetWayTip,self,self.BtnAddOnClick,10040001)]]
end
function this:LUA_EVENT_TAKE_ON_EQUIP()
    local mountId = InfoManager.mountInfo.ride_mount_id
    if InfoManager.mountInfo.isHasOwnerMount and not InfoManager.mountInfo.isRankShowMount then
        mountId = 0
    end
    local behaviour = EBehaviourType_Stand.Stand
    local rotation = mountId == 0 and 50 or 10
    -- SL:UIModel_Recycle(self.curShowRole)
    -- self.curShowRole = SL:UIModel_Create(GUI:GetRectTransform(self.view.img2),SL:GetMetaValue(EMetaVarGetKey.UID),SL:MeData_GetCareer(),SL:MeData_GetLevel(),SL:GetMetaValue(EMetaVarGetKey.USER_NAME),mountId,EAction.Stand,behaviour,SL:MeData_GetRoleExtInfo().roleInfoExtData,0,-90,-76,120,0,rotation,0)
end
function this:BagInfo_Change(_, eventData)
    if self.bagTileScrollView then
        --刷新背包
        local itemList = SL:GetMetaValue("BAG_DATA")[1]
        self.bagTileScrollView.itemList = itemList
        self.bagTileScrollView:RefreshItemByItem(itemList,function()
            ---@param v KLBagItemItem
            for i, v in pairs(self.bagTileScrollView.indexToItem) do
                v:RegistEvents()
            end
        end)
    end
end
function this:reduceBtnOnClick()
    if self.pageCount - 1 < 1 then
        return
    end
    self.pageCount = self.pageCount - 1
    GUI:Text_setText(self.view.pageCount,tostring(self.pageCount))
    self.goodsList = self:SelectItemData(self.pageCount)
    GUI:DataListUpdateData(self.view.ShopMallGoodsList)
    --GUI:SetScrollView_scrollpos(self.view.ShopMallItems,(self.pageCount-1)*6)
end
function this:addBtnOnClick()
    local maxPageCount = math.ceil(table.count(self.AllGoodList)/6)
    if self.pageCount + 1 > maxPageCount then
        return
    end
    self.pageCount = self.pageCount + 1
    GUI:Text_setText(self.view.pageCount,tostring(self.pageCount))
    self.goodsList = self:SelectItemData(self.pageCount)
    GUI:DataListUpdateData(self.view.ShopMallGoodsList)
    --GUI:SetScrollView_scrollpos(self.view.ShopMallItems,(self.pageCount-1)*6)
end

function this:img7OnClick()
    SL:OpenTips(nil, MUEResourceType.DiaMond,nil,nil, nil,{isShowAll = true,clickControl = self.view.img7})
end

function this:img14OnClick()
    SL:OpenTips(nil, 10240001,nil,nil, nil,{isShowAll = true,clickControl = self.view.img14})
end

function this:dianshuchongzhi_btnOnClick(data,value,event)
    if event[1] == true then
        self.curSelectTabTbl = nil
        GUI:SetActive(self.view.LeftSubToggleGroup,false)
        GUI:SetActive(self.view.ShopMallItems,false)
        GUI:SetActive(self.view.line,false)
        GUI:UIPanel_Open("dev/outui/ShopMain/Panel/KLRecharge/KLRechargePanel")
        self.money = {10240001,10250001}
        GUI:DataListUpdateData(self.view.money_list)
    else
        GUI:UIPanel_Close("dev/outui/ShopMain/Panel/KLRecharge/KLRechargePanel")
        GUI:SetActive(self.view.LeftSubToggleGroup,true)
        GUI:SetActive(self.view.line,true)
        GUI:SetActive(self.view.ShopMallItems,true)
    end
    --[[    self:CloseBtnOnClick()
    local Jump = string.split(SL:GetConfig("cfg_global",270002).value,'#')
    shortcutOutMgr.DO(Jump)
    SL:HideMainPanel()]]    
end
function this:zhigou_btnOnClick(data,value,event)
    if event[1] == true then
        self.curSelectTabTbl = nil
        GUI:SetActive(self.view.LeftSubToggleGroup,false)
        GUI:SetActive(self.view.ShopMallItems,false)
        GUI:SetActive(self.view.line,false)
        GUI:UIPanel_Open("dev/outui/ShopMain/Panel/KLzhigou/KLzhigouPanel")
        self.money = {10240001,10250001}
        GUI:DataListUpdateData(self.view.money_list)
    else
        GUI:UIPanel_Close("dev/outui/ShopMain/Panel/KLzhigou/KLzhigouPanel")
        GUI:SetActive(self.view.LeftSubToggleGroup,true)
        GUI:SetActive(self.view.line,true)
        GUI:SetActive(self.view.ShopMallItems,true)
    end
end
function this:BtnAddOnClick(_,cfgId)
    SL:CommonItemGetPath(nil,cfgId,nil,nil,self)
end

function this:CoinOnClick(_,cfgId)
    SL:OpenTips(nil,cfgId)
end

---@param message MallProtos.MallGoodsInfoRes
function this:ResMallGoodsInfoMessage(_,message)
    self.AllGoodList = message.goodsList
    self.pageCount = 1
    self.goodsList = message.goodsList-- self:SelectItemData(self.pageCount)
    GUI:Text_setText(self.view.pageCount,tostring(self.pageCount))
    GUI:DataListUpdateData(self.view.ShopMallGoodsList)
    GUI:SetScrollView_scrollpos(self.view.ShopMallItems,(self.pageCount-1)*6)
    if self.guideId then
        KLGuideManager.HidePointControlGuide(self.guideId)
    end
end
function this:SelectItemData(page)
    local ItemList = {}
    if not table.isNullOrEmpty(self.AllGoodList) then
        for i,v in pairs(self.AllGoodList) do
            if i > (page-1)*6 and i <= page*6 then
                table.insert(ItemList,v)
            end
        end
    end
    return ItemList
end
---@param message MallProtos.BuyMallGoodsRes
function this:ResBuyMallGoodsMessage(_,message)
    self:Refresh()
    local goodsItem = self.goodsItemMap[message.goodsId]
    local goodsData = self.goodsListMap[message.goodsId]
    goodsData.limitCount = goodsData.limitCount - message.count
    goodsData.limitCount = goodsData.limitCount < 0 and 0 or goodsData.limitCount
    goodsItem:RefreshItem(goodsData)
    local isHighLight = self.lightItems and table.contains(self.lightItems, goodsItem.data.goodsId)
    if isHighLight then
        for _, v in pairs(self.goodsItem) do
            v:HideLight()
        end
        if self.args and type(self.args) == "table" and self.args.lightItems then
            self.args.lightItems = nil
        end
    end
    ---@type cfg_shopMall_column
    local shopTbl = SL:GetConfig("cfg_shopMall",message.goodsId)
    SL:OpenRewardTips({[goodsItem.config.itemId] = (message.count * shopTbl.count)},0)
end

function this:CloseBtnOnClick()
    GUI:UIPanel_Close("dev/ui/ShopMall/Panel/KLShopMall/KLShopMallPanel")
    GUI:UIPanel_Close("dev/outui/ShopMain/Panel/KLShopMain/KLShopMainPanel")
    GUI:UIPanel_Close("dev/outui/ShopMain/Panel/KLRecharge/KLRechargePanel")
    GUI:UIPanel_Close("dev/outui/ShopMain/Panel/KLzhigou/KLzhigouPanel")
    SL.ShowMainPanel()
end

function this:Close()
    SL:onLUAEvent(LUA_EVENT_MAIN_UI_BOTTOM_SYSTEM_CLOSE)
    SL:UnRegisterLuaNetMsg(MessageDef.ResMallGoodsInfoMessage,self.ResMallGoodsInfoMessage,self)
    if self.co then
        Coroutine.Stop(self.co)
        self.co = nil 
    end
    if self.guideId then
        KLGuideManager.HidePointControlGuide(self.guideId)
        self.btnSelectItem = nil
    end
    SL:UIModel_Recycle(self.curShowRole)
end

function this:GotoItemSubPage(itemId, guideId)
    local shopMallItem
    ---@type cfg_shopMall_column[]
    local tblList = SL:GetConfigTable("cfg_shopMall")
    for _, v in pairs(tblList) do
        if v.itemId == itemId then
            shopMallItem = v
            break
        end
    end
    if not shopMallItem then
        return
    end
    local subTabId = shopMallItem.subTab[1]
    self.jumpSubTabId = subTabId
    ---@type cfg_menu_layer_column
    local menuLayer = SL:GetConfig("cfg_menu_layer",subTabId)
    local homeTabId = menuLayer.parentID
    if self.homeToggleMap[homeTabId] then
        GUI:Toggle_setIsOn(self.homeToggleMap[homeTabId],true)
        --self:RefreshSubTab(homeTabId)
    end

    if guideId then
        self.guideId = guideId
        self.selectId = shopMallItem.id
--[[                Coroutine.Start(function()
                    Coroutine.WaitForEndOfFrame()
                    self.selectId = shopMallItem.id
                    KLGuideManager.AddPointControlGuide("KLShopMallPanel", "ButtonBg"..tostring(shopMallItem.id), guideId)
                end)]]
    end
    --self.goodsList = self:SelectItemData(self.pageCount)
    GUI:DataListUpdateData(self.view.ShopMallGoodsList)
end




return this
