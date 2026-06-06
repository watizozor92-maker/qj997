---@class KLEquipDecomposeUIPanel:UIKmlLuaPanelBase
---@field view KLEquipDecomposeUIPanelView
---@field ChooseCfgData table<number,cfg_recovery_column>
---@field ChooseTypeItemList table<number,KLRecoverTypeItem>
---@field DecomposeGetData table<number,{cfgId:number,minCount:number,maxCount:number}>
---@field DecomposeCustomData table<number,{cfgId:number,count:number}>
---@field SelectEquipItemTranList table<UIKmlLuaControl,KLEquipDecomposeItemItem>
local KLEquipDecomposeUIPanel = class(UIKmlLuaPanelBase)
local this =KLEquipDecomposeUIPanel
---创建时调用一次
function this:Init()
    self.cfgNameStr = "cfg_recovery_out"
    self.ChooseTypeItemList = {}
    
    self.DecomposeGetData = {}
    self.DecomposeCustomData = {}
    self.DecomposeCustomItem = {}
    self.SelectItemDataList = {}
    self.SelectEquipItemTranList = {}
    
    ---分解获取的材料列表
    self.DecomposeGetMaterialList = {}
    ---选择的item数量
    self.selectItemCountList = {}
    
    GUI:DataListInitData(self.view.DecomposeGetDataList,function()
        return self:GetDataListItemCountFunc()
    end,function(realIndex)
        return self:GetDataListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:GetDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:GetDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    
    GUI:DataListInitData(self.view.DecomposeCustomDataList,function()
        return self:CustomDataListItemCountFunc()
    end,function(realIndex)
        return self:CustomDataListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:CustomDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:CustomDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    
    GUI:DataListInitData(self.view.EquipList,function()
        return self:EquipDataListItemCountFunc()
    end,function(realIndex)
        return self:EquipDataListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:EquipDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:EquipDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
end

---获取分解类型表数据
function this:GetCfgData()
    self.ChooseCfgData = {}
    ---@param v cfg_recovery_column
    for i, v in pairs(SL:GetConfigTable(self.cfgNameStr)) do
        if v.group==2 then
            table.insert(self.ChooseCfgData,v)
        end
    end
    table.sort(self.ChooseCfgData, function(a,b)
        return a.id<b.id
    end)
end

---创建分解类型选择列表
function this:CreatChooseTypeToggle()
    ---类型选择列表
    for k,homeTabConfig in pairs(self.ChooseCfgData) do
        ---@type KLRecoverTypeItem
        local homeTab = GUI:UIPanel_Open("dev/ui/Recover/Item/KLRecoverType/KLRecoverTypeItem",self.view.ChooseTypeCount,self,homeTabConfig,true)
        homeTab.id = homeTabConfig.id
        GUI:SetToggleOnValueChange(homeTab.view.KmlRecycleTypeItemTemplate,self,self.HomeTabOnToggle,homeTabConfig.id)
        table.insert(self.ChooseTypeItemList,homeTab)
    end
end

---@param control UIKmlLuaControl
function this:HomeTabOnToggle(control, eventData)
    SL:SetPlayerAutoDecomposeType(eventData,control:GetTogIsOn())
    self:RefreshGetData()
end

function this:RefreshChooseTypeItemList()
    local selectTogList = SL:GetPlayerAutoDecomposeType()
    for k,KLRecoverTypeItem in pairs(self.ChooseTypeItemList) do
        GUI:Toggle_setIsOn(KLRecoverTypeItem.view.KmlRecycleTypeItemTemplate,table.contains(selectTogList,KLRecoverTypeItem.id))
    end
end


---刷新收益材料和所需材料
function this:RefreshGetData(isUpdateCoin)
    ---@type table<number,boolean>
    self.selectItemList={}
    self.SelectItemIndexList={}
    self.SelectItemDataList={}

    ---@type table<number,{count:number,cfgId:number}>
    self.DecomposeGetData={}
    self.DecomposeCustomData={}
    ---@type number[]
    local typeList=SL:GetPlayerAutoDecomposeType()
    ---@param v CommonProtos.Item
    for i, v in pairs(SL:GetPlayerDecomposeItemList()) do
        local configData = SL:GetConfig("cfg_item", v.cfgId)
        if table.contains(typeList,configData.decomposeGroup) then
            local selectCount = 1
            if self.selectItemCountList[v.id] then
                selectCount = self.selectItemCountList[v.id]
            end
            local recycleCfg=SL:GetConfig(self.cfgNameStr,configData.decomposeGroup)
            local endGetMaterialList = {}
            local endNeedMaterialList = {}
            for z, a in ipairs(recycleCfg.material) do
                table.insert(endGetMaterialList,{[1] = a[1],[2] = a[2] * selectCount,[3] = a[3]})
            end
            for z, a in ipairs(recycleCfg.needMaterial) do
                table.insert(endNeedMaterialList,{[1] = a[1],[2] = a[2] * selectCount})
            end
            for k = 1, table.count(endGetMaterialList) do
                if not self:CheckExsit2(endGetMaterialList[k], self.DecomposeGetData) then
                    ---@type {minCount:number,maxCount:number,,cfgId:number}
                    local getType={}
                    getType.cfgId=endGetMaterialList[k][1]
                    getType.minCount=endGetMaterialList[k][2]
                    getType.maxCount=endGetMaterialList[k][3]
                    table.insert( self.DecomposeGetData,getType)
                end
            end
            for k = 1, table.count(endNeedMaterialList) do
                if not self:CheckExsit(endNeedMaterialList[k], self.DecomposeCustomData) then
                    ---@type {count:number,cfgId:number}
                    local getType={}
                    getType.cfgId=endNeedMaterialList[k][1]
                    getType.count=endNeedMaterialList[k][2]
                    if table.count(self.DecomposeCustomData) < 5 then
                        table.insert(self.DecomposeCustomData,getType)
                    end
                end
            end
            table.insert(self.SelectItemIndexList,{index = SL:MeData_GetIndexBaseOnItemId(v.id),count = selectCount})
            table.insert(self.SelectItemDataList,v)
            self.selectItemList[v.id]=true
        end
    end
    self:UpdateCoinData()
    if not isUpdateCoin then--货币刷新的时候不刷新除消耗以外的信息
        self:UpdateData()
    end
end

---根据背包内勾选刷新收益材料和所需材料
function this:ShowGetItemListBySelect(isUpdateCoin)
    self.SelectItemIndexList={}
    self.SelectItemDataList={}

    ---@type table<number,{count:number,cfgId:number}>
    self.DecomposeGetData={}
    self.DecomposeCustomData={}
    self.DecomposeGetMaterialList = {}
    ---@type number[]
    --local typeList=SL:GetPlayerAutoDecomposeType()
    ---@param v CommonProtos.Item
    for i, v in pairs(SL:GetPlayerDecomposeItemList()) do
        local configData = SL:GetConfig("cfg_item", v.cfgId)
        if self.selectItemList[v.id] then
            ---@type cfg_recovery_out_column
            local recycleCfg=SL:GetConfig(self.cfgNameStr,configData.decomposeGroup)
            local selectCount = 1
            if self.selectItemCountList[v.id] then
                selectCount = self.selectItemCountList[v.id]
            end
            local endGetMaterialList = {}
            local endNeedMaterialList = {}
            for z, a in ipairs(recycleCfg.material) do
                table.insert(endGetMaterialList,{[1] = a[1],[2] = a[2] * selectCount,[3] = a[3] * selectCount})
            end
            for z, a in ipairs(recycleCfg.needMaterial) do
                table.insert(endNeedMaterialList,{[1] = a[1],[2] = a[2] * selectCount})
            end
            for z = 1, selectCount do
                table.insert(self.DecomposeGetMaterialList,recycleCfg.material)
            end
            local material = self:GetMinAndMaxCount(endGetMaterialList)
            for k = 1, table.count(material) do
                if not self:CheckExsit2(material[k], self.DecomposeGetData) then
                    ---@type {minCount:number,maxCount:number,,cfgId:number}
                    local getType={}
                    getType.cfgId=material[k][1]
                    getType.minCount=material[k][2]
                    getType.maxCount=material[k][3]
                    table.insert( self.DecomposeGetData,getType)
                end
            end
            for k = 1, table.count(endNeedMaterialList) do
                if not self:CheckExsit(endNeedMaterialList[k], self.DecomposeCustomData) then
                    ---@type {count:number,cfgId:number}
                    local getType={}
                    getType.cfgId = endNeedMaterialList[k][1]
                    getType.count = endNeedMaterialList[k][2]
                    if table.count(self.DecomposeCustomData) < 5 then
                        table.insert(self.DecomposeCustomData,getType)
                    end
                end
            end
            table.insert(self.SelectItemIndexList,{index = SL:MeData_GetIndexBaseOnItemId(v.id),count = selectCount})
            table.insert(self.SelectItemDataList,v)
        end
    end
    self:UpdateCoinData()
    if not isUpdateCoin then--货币刷新的时候不刷新除消耗以外的信息
        self:UpdateData()
    end
end

---获取材料的最大最小值
function this:GetMinAndMaxCount(material)
    local endMaterialList = {}
    local materialCountList = {}
    for i, v in ipairs(material) do
        if not materialCountList[v[1]] then
            materialCountList[v[1]] = {}
        end
        table.insert(materialCountList[v[1]],v[2])
    end
    for i, v in pairs(materialCountList) do
        local minCount
        local maxCount
        for z, a in ipairs(v) do
            if not minCount then
                minCount = a
            end
            if not maxCount then
                maxCount = a
            end
            if a < minCount then
                minCount = a
            end
            if a > maxCount then
                maxCount = a
            end
        end
        local data = {}
        data[1] = i
        data[2] = minCount
        data[3] = maxCount
        table.insert(endMaterialList,data)
    end
    return endMaterialList
end

---根据权重获取最终获得的随机材料（所有）
function this:GetEndGetMaterial()
    self.endGetMaterialList = {}
    for i, v in ipairs(self.DecomposeGetMaterialList) do
        local itemList = {}
        for k = 1, table.count(v) do
            local cfgId = v[k][1]
            local count = v[k][2]
            local weights = v[k][3]
            if not itemList[cfgId] then
                itemList[cfgId] = {}
                itemList[cfgId].countList = {}
                itemList[cfgId].weightsList = {}
            end
            table.insert(itemList[cfgId].countList,count)
            table.insert(itemList[cfgId].weightsList,weights)
        end
        for z, a in pairs(itemList) do
            local count = self:GetRandomByWeight(a.countList,a.weightsList)
            if not self.endGetMaterialList[z] then
                self.endGetMaterialList[z] = count
            else
                self.endGetMaterialList[z] = self.endGetMaterialList[z] + count
            end
        end
    end
    
end

---根据权重获取最终获得的随机材料（单个）
function this:GetRandomByWeight(t, weights)
    local sum = 0
    for i = 1, #weights do
        sum = sum + weights[i]
    end
    local compareWeight = math.random(1, sum)
    local weightIndex = 1
    while sum > 0 do
        sum = sum - weights[weightIndex]
        if sum < compareWeight then
            return t[weightIndex]
        end
        weightIndex = weightIndex + 1
    end
    return nil
end

---刷新选中装备和获得的材料信息
function this:UpdateData()
    GUI:SetActive(self.view.Info,table.count(self.DecomposeGetData) > 0 or table.count(self.DecomposeCustomData) > 0)
    GUI:SetActive(self.view.decoIcon_1,table.count(self.DecomposeCustomData) > 0)
    GUI:SetActive(self.view.NoInfo,not (table.count(self.DecomposeGetData) > 0 or table.count(self.DecomposeCustomData) > 0))
    GUI:SetActive(self.view.EquipBg,table.count(self.DecomposeGetData) > 0 or table.count(self.DecomposeCustomData) > 0)
    GUI:DataListUpdateData(self.view.DecomposeGetDataList)
    GUI:DataListUpdateData(self.view.EquipList)
    ---刷新勾选
    ---EventManager.Dispatch(Event.RecoverSelectChange, self.selectItemList)
    SL:onLUAEvent(Event.RecoverSelectChange, self.selectItemList)
end

---刷新消耗材料信息
function this:UpdateCoinData()
    self.isCanDecompose = true
    for i, v in pairs(self.DecomposeCustomData) do
        if SL:GetBagItemCount(v.cfgId) < v.count then
            self.isCanDecompose = false
            break
        end
    end
    GUI:DataListUpdateData(self.view.DecomposeCustomDataList)
end

---@param list table<number,{count:number,cfgId:number}>
function this:CheckExsit(data,list)
    for i, v in pairs(list) do
        if v.cfgId==data[1] then
            v.count=v.count+data[2]
            return true
        end
    end
    return false
end

---@param list table<number,{minCount:number,maxCount:number,cfgId:number}>
function this:CheckExsit2(data,list)
    for i, v in pairs(list) do
        if v.cfgId==data[1] then
            v.minCount=v.minCount+data[2]
            v.maxCount=v.maxCount+data[3]
            return true
        end
    end
    return false
end

-------------------收益---------------------------

function this:GetDataListItemCountFunc()
    return #self.DecomposeGetData
end

function this:GetDataListItemGetFunc(realIndex)
end

function this:GetDataListItemInitFunc(realIndex, kmlcontrol)
    
end

function this:GetDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.DecomposeGetData[realIndex + 1]

    local item = GUI:GetChildControl(self.view.DecomposeGetDataList,realIndex,'GetItem')
    local countStr = data.minCount.."~"..data.maxCount
    if data.minCount == data.maxCount then
        countStr = data.minCount
    end
    GUI:Item_UpdataData(item, {
        itemid = data.cfgId,
        itemcustomcount = countStr,
    })
    GUI:AddOnClickEvent(item, self, function()
        SL:OpenTips(nil, data.cfgId)
    end)
end
--------------------------------------------

----------------------材料--------------------------
function this:CustomDataListItemCountFunc()
    return #self.DecomposeCustomData
end

function this:CustomDataListItemGetFunc(realIndex)
    ---@type KLUICostMatItem
    local item = GUI:UIPanel_Open("dev/ui/Common/Item/KLUICostMat/KLUICostMatItem", self.view.DecomposeCustomDataList, self, nil, true)
    if not self.DecomposeCustomItem then
        ---@type table<KingML.KmlControl,KLUICostMatItem>
        self.DecomposeCustomItem = {}
    end
    
    local kmlCtrl = item.view.root
    self.DecomposeCustomItem[kmlCtrl] = item
    return kmlCtrl
end

function this:CustomDataListItemInitFunc(realIndex, kmlcontrol)
    
end

function this:CustomDataListItemUpdateFunc(realIndex, kmlcontrol)
    local item = self.DecomposeCustomItem[kmlcontrol]

    local luaIndex = realIndex + 1
    local data = self.DecomposeCustomData[luaIndex]
    item:Refresh(data.cfgId,data.count)
end
-----------------------------------------------------

----------------------装备--------------------------
function this:EquipDataListItemCountFunc()
    return #self.SelectItemDataList
end

function this:EquipDataListItemGetFunc(realIndex)
    local item = GUI:UIPanel_Open("dev/outui/Equip/Item/KLEquipDecomposeItem/KLEquipDecomposeItemItem", 
            self.view.EquipList, self, nil, true)
    
    local kmlCtrl = item.view.root
    self.SelectEquipItemTranList[kmlCtrl] = item
    return kmlCtrl
end

function this:EquipDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:EquipDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.SelectItemDataList[realIndex + 1]
    local count = self.selectItemCountList[data.id]
    self.SelectEquipItemTranList[kmlcontrol]:RefreshData(data,count)
end
-----------------------------------------------------

---创建或者刷新界面数据时调用
function this:Refresh()
    self:RefreshGetData()
    --self:RefreshChooseTypeItemList()
    GUI:UIPanel_Close("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel")
    GUI:UIPanel_Close("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel")
    ---显示背包
    GUI:UIPanel_Open("dev/ui/Bag/Panel/KLRecoverBag/KLRecoverBagPanel", 
            nil, nil, 
            { 
                itemList = SL:GetPlayerDecomposeItemList(),
                bagType=EBagShowType.Decompose,
                itemClickCallBack=self.ClickItemCallBack,
                selectList=self.selectItemList,
                callBackUI=self,
                cfgNameStr=self.cfgNameStr
            }
    )
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.CloseButton, self, self.OnClickCloseButton)
    GUI:AddOnClickEvent(self.view.HelpButton, self, self.OnClickHelpButton)
    GUI:AddOnClickEvent(self.view.DecomposeButton, self, self.OnClickDecomposeButton)

    SL:RegisterLUAEvent(LUA_EVENT_BAG_CHANGE_AFTER, self.BagInfo_Change, self)
    SL:RegisterLUAEvent(LUA_EVENT_MONEYCHANGE, self.CoinInfo_Change,self)
    --SL:RegisterLUAEvent(LUA_EVENT_Item_Resolve, self.ResolveOver,self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_ITEM_DECOMPOSITION,self.DecomposeMsg,self)
    SL:RegisterLUAEvent(LUA_EVENT_FORGE_GROUP_PANEL_CLOSE, self.OnClickCloseButton, self)
end

---点击背包item回调
---@param itemControl KLBagItemItemView
---@param itemData CommonProtos.Item
function this:ClickItemCallBack(itemControl,itemData,itemSelf)
    ---是否选中
    local isSelect = self.selectItemCountList[itemData.id] and self.selectItemCountList[itemData.id] > 0
    if isSelect then
        self.selectItemCountList[itemData.id] = 0
    else
        if itemData.count > 1 then
            GUI:UIPanel_Open("dev/outui/SelectCount/Panel/KLSelectCount/KLSelectCountPanel", nil, nil, 
                    {
                        callbackUI = self,
                        sure = 
                        function(_,id,count)
                            self.selectItemCountList[id] = count
                            self:SetSelectItemState(itemControl,itemData,itemSelf,isSelect)
                        end,
                        itemid = itemData.cfgId,
                        max = itemData.count,
                        id = itemData.id
                    })
            return
        else
            self.selectItemCountList[itemData.id] = 1
        end
    end
    
    self:SetSelectItemState(itemControl,itemData,itemSelf,isSelect)
end

---设置选中的背包item图片状态
---@param itemControl KLBagItemItemView
---@param itemData CommonProtos.Item
function this:SetSelectItemState(itemControl,itemData,itemSelf,isSelect)
    itemSelf:SetSelectEffect(not isSelect,true)
    self.selectItemList[itemData.id] = not isSelect

    self:ShowGetItemListBySelect()
end

---分解回包
function this:DecomposeMsg(_,message)
    if message and next(message) then
        local list = {}
        for i, v in pairs(message) do
            table.insert(list,{cfgId = tonumber(i),count = tonumber(v)})
        end
        SL:OpenRewardTipsByItemList(list,0)
        --self.endGetMaterialList = {}
        self.selectItemCountList = {}
        self.selectItemList = {}
        self:ShowGetItemListBySelect()
    end
end

function this:ResolveOver(id,itemList)
    SL:OpenRewardTipsByItemList(itemList,0)
    self:ShowGetItemListBySelect()
end

--关闭页面
function this:OnClickCloseButton()
    GUI:UIPanel_Close("dev/ui/Equip/Panel/KLEquipDecomposeUI/KLEquipDecomposeUIPanel")
    GUI:UIPanel_Close("dev/ui/Bag/Panel/KLRecoverBag/KLRecoverBagPanel")
    GUI:UIPanel_Close("dev/ui/UIForgeGroup/Panel/KLUIForgeGroup/KLUIForgeGroupPanel")
end

--帮助页面
function this:OnClickHelpButton()
    local helpCfg=SL:GetConfig("cfg_rule_text",3)
    if helpCfg then
        SL:CommonStrTipsMessage({title =helpCfg.menutxt,str=helpCfg.location})
    end
end

--分解
function this:OnClickDecomposeButton()
    --SL:SendDecomposeItem(self.SelectItemIndexList)
    if not self.isCanDecompose then
        SL:TipMessage( SL:GetConfig('cfg_string',293).text,1, NoticeType.NoticeMid )--消耗材料不足
        return
    end

    --self:GetEndGetMaterial()
    --local customData = {}
    --local endGetMaterial = {}
    local selectItemIndexList = {}
    --for i, v in ipairs(self.DecomposeCustomData) do
    --    customData[tostring(v.cfgId)] = v.count
    --end
    --for i, v in pairs(self.endGetMaterialList) do
    --    endGetMaterial[tostring(i)] = v
    --end
    for i, v in ipairs(self.SelectItemIndexList) do
        selectItemIndexList[tostring(v.index)] = v.count
    end
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_ITEM_DECOMPOSITION, {selectItemIndexList})
end

function this:BagInfo_Change(eventId, eventData)
    if not eventData then
        return
    end
    self:ShowGetItemListBySelect()
end

function this:CoinInfo_Change(eventId, eventData)
    self:ShowGetItemListBySelect(true)
end

function this:Close()
end

return this
