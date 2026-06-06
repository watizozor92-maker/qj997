---@class KLUISynthesisPanel:UIKmlLuaPanelBase
---@field view KLUISynthesisPanelView
---@field needConsumeDataList table<number,{cfgId:number,count:number,SpecialIdList:table<number,number>}>
---@field specialDataList table<number,CommonProtos.Item>
---@field selectSpecialDataList table<number,CommonProtos.Item>
---@field nowCfg cfg_synthesis_column
local KLUISynthesisPanel = class(UIKmlLuaPanelBase)
local this =KLUISynthesisPanel
---创建时调用一次
function this:Init()
    ---选中的Type
    self.selectType = 0
    ---选中的SubType
    self.selectSubType = -1
    ---选中的SubTypeID
    self.selectSubTypeID = 0
    ---选中的cfgId
    self.selectCfgId = 0
    ---选中的特殊item
    self.selectData = nil
    ---需要的材料
    self.needConsumeDataList = {}
    ---特殊材料
    self.specialDataList = {}
    ---选中的特殊材料
    self.selectSpecialDataList = {}
    ---左侧按钮信息
    self.LeftButtonDataList = {}
    
    self.itemModelList = {}
    ---预览信息
    self.PreviewDataList = {}

    ---最大合成数量
    self.maxSynthesisCount = 0
    ---当前合成数量
    self.nowSynthesisCount = 1
    
    GUI:setPositionZ(self.view.Special, -300)

    GUI:DataListInitData(self.view.LeftButtonDataList,function()
        return self:LeftButtonDataListItemCountFunc()
    end,function(realIndex)
        return self:LeftButtonDataListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:LeftButtonDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:LeftButtonDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    
    GUI:DataListInitData(self.view.MaterialDataList,function()
        return self:MaterialDataListItemCountFunc()
    end,function(realIndex)
        return self:MaterialDataListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:MaterialDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:MaterialDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    
    GUI:DataListInitData(self.view.SpecialItemDataList,function()
        return self:SpecialItemDataListItemCountFunc()
    end,function(realIndex)
        return self:SpecialItemDataListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:SpecialItemDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:SpecialItemDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    
    GUI:DataListInitData(self.view.PreviewDataList,function()
        return self:PreviewDataListItemCountFunc()
    end,function(realIndex)
        return self:PreviewDataListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:PreviewDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:PreviewDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    SL.HideMainPanel()
    self:GetLeftButton()
    self:ShowRightInfo()
    self:OpenUISelectProduct()
end

---打开界面默认选中配方
function this:OpenUISelectProduct()
    local productId = self.args and self.args[1]
    if not productId then
        productId = 0
    end
    productId = tonumber(productId)
    local cfgList = {}
    local cfg = SL:GetConfigTable("cfg_synthesis")
    for i, v in pairs(cfg) do
        table.insert(cfgList,v)
    end
    table.sort(cfgList,function(a, b)
        return a.id < b.id
    end)
    local data = nil
    local type = 2
    ---@param v cfg_synthesis_column
    for i, v in ipairs(cfgList) do
        local isCan = false
        if productId == 0 and self.allCfgDataList[v.type] and self.allCfgDataList[v.type][v.subType] then
            for z, a in pairs(self.allCfgDataList[v.type][v.subType]) do
                if a.id == v.id then
                    isCan = true
                    break
                end
            end
        end
        for z, a in ipairs(v.productId) do
            if (isCan and productId == 0) or a[1] == productId then
                self.selectType = v.type
                self.selectSubType = v.subType
                if v.subType > 0 then
                    type = 3
                end
                data = v
                break
            end
        end
        if data then
            break
        end
    end
    if data then
        self:OnClickSelectLeftItemButton(_,{{data = data,type = type}})
    end
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.closeButton,self,self.OnClickCloseButton)
    GUI:AddOnClickEvent(self.view.SpecialCloseButton,self,self.OnClickCloseSpecial)
    GUI:AddOnClickEvent(self.view.SelectSpecialButton,self,self.OnClickCloseSpecial)
    GUI:AddOnClickEvent(self.view.SynthesisButton,self,self.OnClickSynthesisButton)
    
    GUI:AddOnClickEvent(self.view.BtnMinus,self,self.OnClickBtnMinus)
    GUI:AddOnClickEvent(self.view.BtnAdd,self,self.OnClickBtnAdd)
    GUI:Input_SetOnValueChange(self.view.Input,self,self.InputOnValueChange)
    
    GUI:AddOnClickEvent(self.view.PreviewButton,self,self.OnClickPreviewButton)
    GUI:AddOnClickEvent(self.view.PreviewCloseButton,self,self.ClosePreview)

    SL:RegisterLUAEvent(LUA_EVENT_BAG_CHANGE_AFTER, self.BagInfo_Change, self)
    SL:RegisterLUAEvent(LUA_EVENT_MONEYCHANGE, self.CoinInfo_Change,self)

    SL:RegisterLUAEvent(LUA_EVENT_TIPS_ONCLICK_REPLACE, self.LUA_EVENT_TIPS_ONCLICK_REPLACE, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_ITEM_SYNTHESIS,self.RES_ITEM_SYNTHESIS,self)

end

function this:OnClickPreviewButton()
    if GUI:getVisible(self.view.Preview) then
        self:ClosePreview()
        return
    end
    self:OnClickShowPreview()
end

---点击显示预览界面
function this:OnClickShowPreview()
    if self.nowCfg then
        GUI:setPositionX(self.view.root,-309)
        self.PreviewDataList = {}
        for i, v in ipairs(self.nowCfg.productId) do
            table.insert(self.PreviewDataList,tonumber(v[1]))
        end
        GUI:SetActive(self.view.Preview,true)
        GUI:DataListUpdateData(self.view.PreviewDataList)

    end
end

---关闭预览界面
function this:ClosePreview()
    if GUI:getVisible(self.view.Preview) then
        GUI:setPositionX(self.view.root,0)
        GUI:SetActive(self.view.Preview,false)
    end
end

--合成按钮
function this:OnClickSynthesisButton()
    if self.nowCfg then
        local isCan = self:MaterialIsCan(self.nowCfg)
        local count = #self.nowCfg.arbitrarily
        if count == 0 then
            if not isCan then
                SL:TipMessage( SL:GetConfig('cfg_string',281).text, 1, NoticeType.NoticeMid )--"合成材料不足！",
                return
            end
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_ITEM_SYNTHESIS,{self.nowCfg.id,self.nowSynthesisCount})
        else
            local specialList = {}
            for i, v in ipairs(self.needConsumeDataList) do
                if v.item then
                    table.insert(specialList,{itemId = v.item.id,itemIndex =SL:GetBagIndex(v.item.id)})
                end
                if v.cfgId == 0 then
                    isCan = false
                end
            end
            if not isCan then
                SL:TipMessage( SL:GetConfig('cfg_string',281).text,1, NoticeType.NoticeMid )--"合成材料不足！", 
                return
            end
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_ITEM_SYNTHESIS,{self.nowCfg.id,specialList})
        end
    end
end

---tips点击替换响应
function this:LUA_EVENT_TIPS_ONCLICK_REPLACE()
    if self.selectData.item then
        self.selectSpecialId = self.selectData.item.id
    end
    self:OpenSpecialUI(self.selectData)
end

---合成回包
function this:RES_ITEM_SYNTHESIS(_,message)
    if self.nowCfg then
        local list = {}
        for i, v in pairs(message) do
            table.insert(list,{cfgId = v.itemCfgId,count = v.count,id=v.itemId})
        end
        SL:OpenRewardTipsByItemList(list,0,"Atlas/UISynthesisPanel.spriteatlas","synthetic_success")
        self:ShowRightInfo(self.nowCfg)
    end
end

function this:BagInfo_Change(_,message)
    if message then
        GUI:DataListUpdateData(self.view.MaterialDataList)
        GUI:DataListUpdateData(self.view.LeftButtonDataList)
        if self.nowCfg then
            self:GetMaxCount(self.nowCfg)
        end
    end
end

function this:CoinInfo_Change(_,message)
    GUI:DataListUpdateData(self.view.MaterialDataList)
    GUI:DataListUpdateData(self.view.LeftButtonDataList)
    if self.nowCfg then
        self:GetMaxCount(self.nowCfg)
    end
end

function this:InputOnValueChange(a, b,eventData)
    local str = eventData[1]
    if string.isNullOrEmpty(str) then
        self.nowSynthesisCount = 1
    else
        local count = tonumber(str)
        if count <= 0 then
            count = 0
        end
        if count > 0 and count >= self.maxSynthesisCount then
            count = self.maxSynthesisCount
        end
        self.nowSynthesisCount = count
    end
    if not self.view.Input then
        return
    end
    GUI:Text_setString(self.view.Input,tostring(self.nowSynthesisCount))
    GUI:DataListUpdateData(self.view.MaterialDataList)
end
function this:OnClickBtnMinus()
    if self.nowSynthesisCount > 1 then
        self.nowSynthesisCount = self.nowSynthesisCount - 1
        self:BtnMinusRefresh()
    else
        if self.maxSynthesisCount > 0 then
            self.nowSynthesisCount = self.maxSynthesisCount
            self:BtnMinusRefresh()
        end
    end
end

function this:BtnMinusRefresh()
    if not self.view.Input then
        return
    end
    GUI:Text_setString(self.view.Input,tostring(self.nowSynthesisCount))
    GUI:DataListUpdateData(self.view.MaterialDataList)
end

function this:OnClickBtnAdd()
    if self.nowSynthesisCount + 1 > self.maxSynthesisCount then
        if self.isSynthesisUpperLimit then
            SL:TipMessage( SL:GetConfig('cfg_string',32001).text,1, NoticeType.NoticeMid )
            return
        end
        SL:TipMessage( SL:GetConfig('cfg_string',281).text,1, NoticeType.NoticeMid )--"合成材料不足！", 
        return
    end
    self.nowSynthesisCount = self.nowSynthesisCount + 1
    if not self.view.Input then
        return
    end
    GUI:Text_setString(self.view.Input,tostring(self.nowSynthesisCount))
    GUI:DataListUpdateData(self.view.MaterialDataList)
end

function this:OnClickCloseButton()
    GUI:UIPanel_Close("dev/outui/UISynthesis/Panel/KLUISynthesis/KLUISynthesisPanel")
    SL.ShowMainPanel()
end

function this:OnClickCloseSpecial()
    GUI:SetActive(self.view.Special,false)
    GUI:DataListUpdateData(self.view.MaterialDataList)
end

function this:Close()
end

---显示左侧按钮
function this:GetLeftButton()
    self.LeftButtonDataList = {}
    self.allCfgDataList = {}
    self.AllTypeList = {}
    local cfg = SL:GetConfigTable("cfg_synthesis")
    ---@param v cfg_synthesis_column
    for i, v in pairs(cfg) do
        local isCareer = false
        if #v.career > 0 then
            for z, a in ipairs(v.career) do
                if a[1] == SL:MeData_GetCareer().baseCareer and a[2] == SL:MeData_GetCareer().careerRank then
                    isCareer = true
                    break
                end
            end
        else
            isCareer = true
        end
        
        if isCareer and SL:MeData_GetLevel() >= v.level then
            if not self.allCfgDataList[v.type] then
                self.allCfgDataList[v.type] = {}
                table.insert(self.AllTypeList,v.type)
            end
            if not self.allCfgDataList[v.type][v.subType] then
                self.allCfgDataList[v.type][v.subType] = {}
            end
            table.insert(self.allCfgDataList[v.type][v.subType],v)
        end
    end
    table.sort(self.AllTypeList,function(a, b) 
        return a < b
    end)
    for i, v in ipairs(self.AllTypeList) do
        for z, a in pairs(self.allCfgDataList[v]) do
            table.insert(self.LeftButtonDataList,{type=1,data=a[1]})
            break
        end
        
    end
    
    GUI:DataListUpdateData(self.view.LeftButtonDataList)
end

---显示右侧信息
---@param cfg cfg_synthesis_column
function this:ShowRightInfo(cfg)
    self.nowCfg = nil
    self.needConsumeDataList = {}
    self.nowSynthesisCount = 1
    if cfg then
        GUI:Text_setString(self.view.ModelName,cfg.name)
        GUI:Text_setString(self.view.ModelDescription,cfg.description)
        GUI:SetActive(self.view.SuccessRateText,cfg.successOpen ~= 2)
        GUI:Text_setString(self.view.SuccessRateText,"<color=#00ff00>成功率："..(tonumber(cfg.successRate) / 100).."%</color>")
        GUI:SetActive(self.view.SynthesisButton,true)
        GUI:SetActive(self.view.MaterialTitle,true)
        local data = {
            width = "200",
            height = "200",
            itemid = cfg.productId[1][1],
            mfixsize = "200,200",
            itemcount = nil,
            bgtype = "0",
            raycast="1"
        }
        if self.item then
            GUI:SetActive(self.item, true)
            GUI:Item_UpdataData(self.item, data)
        else
            self.item = GUI:Item_Create(self.view.Model, data)
        end
        GUI:AddOnClickEvent(self.item, self, function()
            SL:OpenTips(nil, cfg.productId[1][1])
        end)
        self.nowCfg = cfg
        if #self.nowCfg.productId > 1 then
            GUI:SetActive(self.view.PreviewButton,true)
            self:OnClickShowPreview()
        else
            GUI:SetActive(self.view.PreviewButton,false)
            self:ClosePreview()
        end
        self:GetNeedConsumeData()
    else
        GUI:SetActive(self.view.PreviewButton,false)
        GUI:Text_setString(self.view.ModelName,"")
        GUI:Text_setString(self.view.ModelDescription,"")
        GUI:Text_setString(self.view.SuccessRateText,"")
        GUI:SetActive(self.view.SynthesisButton,false)
        GUI:SetActive(self.view.MaterialTitle,false)
        if self.item then
            GUI:SetActive(self.item, false)
        end
        GUI:SetActive(self.view.SelectCount,false)
        GUI:SetActive(self.view.SynthesisButton_Red,false)
        self:ClosePreview()
    end
    GUI:DataListUpdateData(self.view.MaterialDataList)
end

function this:GetNeedConsumeData()
    if self.nowCfg then
        ---是否显示选择次数按钮
        local isShowSelectCount = true
        for i, v in ipairs(self.nowCfg.arbitrarily) do
            table.insert(self.needConsumeDataList,{cfgId = 0,count = 0,SpecialIdList = {}})
            for z, a in ipairs(v) do
                table.insert(self.needConsumeDataList[i].SpecialIdList,tonumber(a))
                isShowSelectCount = false
            end
        end
        for i, v in ipairs(self.nowCfg.consumeItem) do
            table.insert(self.needConsumeDataList,{cfgId = tonumber(v[1]),count = tonumber(v[2])})
        end
        GUI:SetActive(self.view.SelectCount,isShowSelectCount)
        self:GetMaxCount(self.nowCfg)
        GUI:SetActive(self.view.SynthesisButton_Red,false)
        if self.maxSynthesisCount > 0 then
            self.nowSynthesisCount = 1
            GUI:SetActive(self.view.SynthesisButton_Red,true)
        end
        GUI:Text_setString(self.view.Input,tostring(self.nowSynthesisCount))
    end
end

---获取最大合成数量
---@param cfg cfg_synthesis_column
function this:GetMaxCount(cfg)
    self.maxSynthesisCount = 0
    for i, v in ipairs(cfg.consumeItem) do
        local cfgId = tonumber(v[1]) 
        local count = tonumber(v[2])
        local bagCount = SL:GetBagItemCount(cfgId)
        local maxCount = bagCount // count
        if i == 1 then
            self.maxSynthesisCount = maxCount
        else
            if self.maxSynthesisCount > maxCount then
                self.maxSynthesisCount = maxCount
            end
        end
    end
    if table.count(cfg.arbitrarily) > 0 then
        local arbitrarilyMaxCount = 0
        for i, v in ipairs(cfg.arbitrarily) do
            for z, a in ipairs(v) do
                local maxCount = SL:GetBagItemCount(tonumber(a))
                if i == 1 then
                    arbitrarilyMaxCount = maxCount
                else
                    if arbitrarilyMaxCount > maxCount then
                        arbitrarilyMaxCount = maxCount
                    end
                end
            end
        end
        self.maxSynthesisCount = Mathf.Min(self.maxSynthesisCount,arbitrarilyMaxCount)
    end
    ---是否有合成上限
    self.isSynthesisUpperLimit = false
    GUI:setVisible(self.view.MaxCountText,false)
    if cfg.synthesisType == 2 then
        self.isSynthesisUpperLimit = true
        if self.maxSynthesisCount > 10 then
            self.maxSynthesisCount = 10
        end
        if GUI:getVisible(self.view.SelectCount) then
            GUI:setPosition(self.view.MaxCountText,0,-230)
        else
            GUI:setPosition(self.view.MaxCountText,0,-265)
        end
        GUI:setVisible(self.view.MaxCountText,true)
    end
end

--------------------------------需要的材料-------------------------------------------------------
function this:MaterialDataListItemCountFunc()
    return #self.needConsumeDataList
end

function this:MaterialDataListItemGetFunc(realIndex)
end

function this:MaterialDataListItemInitFunc(realIndex, kmlcontrol)

end

function this:MaterialDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.needConsumeDataList[realIndex + 1]
    local cfgId = data.cfgId
    local count = data.count
    local _model = GUI:GetChildControl(self.view.MaterialDataList,realIndex,'MaterialItem_Model')
    local _addButton = GUI:GetChildControl(self.view.MaterialDataList,realIndex,'MaterialItem_AddButton')
    local _addButtonText = GUI:GetChildControl(self.view.MaterialDataList,realIndex,'MaterialItem_AddButtonText')
    local _text = GUI:GetChildControl(self.view.MaterialDataList,realIndex,'MaterialItem_Text')
    local _button = GUI:GetChildControl(self.view.MaterialDataList,realIndex,'MaterialItem_Button')
    GUI:setPositionZ(_text, -300)
    GUI:SetZIndex(_text,201)
    GUI:SetActive(_addButton,false)
    GUI:SetActive(_button,false)
    if cfgId > 0 then
        --GUI:SetActive(_model,true)
        GUI:SetActive(_button,true)
        
    else
        GUI:SetActive(_addButton,true)
    end
    local modelData = {
        width = "70",
        height = "70",
        itemid = cfgId,
        mfixsize = "70,70",
        itemcount = nil,
        raycast="1",
    }
    local countStr = self:GetCountStr(data)
    GUI:SetActive(_addButtonText,data.cfgId == 0)
    GUI:Item_UpdataData(_model, modelData)
    GUI:Text_setString(_text,countStr)
    GUI:AddOnClickEvent(_button,self,self.OnClickMaterialButton,{data})
    GUI:AddOnClickEvent(_addButton,self,self.OnClickMaterialAddButton,{data})
end

---获取数量的文本
function this:GetCountStr(data)
    if data.cfgId == 0 then
        return ""
    end
    if data.SpecialIdList then
        return ""
    end
    local bagCount = SL:GetBagItemCount(data.cfgId)
    local count = data.count
    if self.nowSynthesisCount > 0 then
        count = count * self.nowSynthesisCount
    end
    local color = count <= bagCount and "#00ff00" or "#ff2323"
    local n = ""
    local bagCountStr = tostring(SL:GetSimpleNumber(bagCount,1))
    local needCountStr = tostring(SL:GetSimpleNumber(count,1))
    if SL:GetUTF8ByteLen(bagCountStr) + SL:GetUTF8ByteLen(needCountStr) + 1 >= 7 then
        n = "\n"
    end
    return "<color="..color..">"..bagCountStr.."</color>"..n.."/"..needCountStr
end

---点击材料
function this:OnClickMaterialButton(_,eventData)
    local pos = nil
    ---特殊材料 需要tips打开之后替换
    if eventData[1].SpecialIdList then
        self.selectData = eventData[1]
        pos = "synthesis"
    end
    SL:OpenTips(pos, eventData[1].cfgId)
end

---点击选择特殊材料
function this:OnClickMaterialAddButton(_,eventData)
    self.selectData = eventData[1]
    self:OpenSpecialUI(eventData[1])
end

---打开特殊材料的界面
function this:OpenSpecialUI(eventData)
    GUI:SetActive(self.view.Special,true)
    if not self.isFirstOpenSpecial then--设置一下特殊材料选择界面的层级
        self.isFirstOpenSpecial = true
        GUI:SetZIndex(self.view.Special, 202)
    end
    local titleName = "选择"
    for i, v in ipairs(eventData.SpecialIdList) do
        if SL:HasConfig("cfg_item", v) then
            ---@type cfg_item_column
            local itemCfg = SL:GetConfig("cfg_item",v)
            local itemName = "<color=#00ff00>"..itemCfg.name.."</color>"
            if i == 1 then
                titleName = titleName..itemName
            else
                titleName = titleName.."/"..itemName
            end
        end
    end
    GUI:Text_setString(self.view.SpecialTitleText,titleName)
    self:GetBagSpecialItemList(eventData)
end

---获取背包中符合的特殊材料
function this:GetBagSpecialItemList(eventData)
    self.specialDataList = {}
    local items = SL:GetMetaValue(EMetaVarGetKey.STD_ITEMS)
    for i, v in pairs(items[1]) do
        if SL:HasConfig("cfg_item", v.cfgId) then
            local isCanAdd = true
            for z, a in ipairs(self.needConsumeDataList) do
                if (a.item and a.item.id == v.id) and (not eventData.item or (eventData.item and eventData.item.id ~= v.id)) then
                    isCanAdd = false
                    break
                end
            end
            if isCanAdd and table.contains(eventData.SpecialIdList,v.cfgId) then
                table.insert(self.specialDataList,v)
            end
        end
    end
    GUI:DataListUpdateData(self.view.SpecialItemDataList)
end

------------------------------------------------------------------------------------------------

--------------------------------特殊材料-------------------------------------------------------
function this:SpecialItemDataListItemCountFunc()
    return #self.specialDataList
end

function this:SpecialItemDataListItemGetFunc(realIndex)
end

function this:SpecialItemDataListItemInitFunc(realIndex, kmlcontrol)

end

function this:SpecialItemDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.specialDataList[realIndex + 1]
    local cfgId = data.cfgId
    local count = data.count
    local _model = GUI:GetChildControl(self.view.SpecialItemDataList,realIndex,'SpecialItem_Model')
    local _text = GUI:GetChildControl(self.view.SpecialItemDataList,realIndex,'SpecialItem_Text')
    local _button = GUI:GetChildControl(self.view.SpecialItemDataList,realIndex,'SpecialItem_Button')
    local _selectBG = GUI:GetChildControl(self.view.SpecialItemDataList,realIndex,'SpecialItem_SelectBG')
    local _selectGou = GUI:GetChildControl(self.view.SpecialItemDataList,realIndex,'SpecialItem_SelectGou')
    local _strengthText = GUI:GetChildControl(self.view.SpecialItemDataList,realIndex,'SpecialItem_StrengthText')
    local _appendText = GUI:GetChildControl(self.view.SpecialItemDataList,realIndex,'SpecialItem_AppendText')
    local modelData = {
        width = "70",
        height = "70",
        itemid = cfgId,
        mfixsize = "70,70",
        itemcount = nil,
    }
    GUI:Text_setString(_strengthText,"")
    GUI:Text_setString(_appendText,"")
    if data.luaExtData and data.luaExtData ~= "null" and data.luaExtData ~= "" then
        local str = SL:JsonDecode(data.luaExtData)
        if str["strengthlv"] and str["strengthlv"] > 0 then
            GUI:Text_setString(_strengthText,"+"..str["strengthlv"])
        end
        if str["appendlv"] and str["appendlv"] > 0 then
            GUI:Text_setString(_appendText,"+"..str["appendlv"])
        end
    end
    GUI:Item_UpdataData(_model, modelData)
    GUI:SetActive(_selectBG,false)
    GUI:SetActive(_selectGou,false)
    if self.selectSpecialId == data.id then
        self.selectSpecialItemBG = _selectBG
        self.selectSpecialItemGou = _selectGou
        GUI:SetActive(_selectBG,true)
        GUI:SetActive(_selectGou,true)
    end
    GUI:AddOnClickEvent(_button,self,self.OnClickSelectSpecialItemButton,{data,_selectBG,_selectGou})
end

---@param eventData CommonProtos.Item
function this:OnClickSelectSpecialItemButton(_,eventData)
    if self.selectSpecialItemBG then
        GUI:SetActive(self.selectSpecialItemBG,false)
        self.selectSpecialItemBG = nil
    end
    if self.selectSpecialItemGou then
        GUI:SetActive(self.selectSpecialItemGou,false)
        self.selectSpecialItemGou = nil
    end
    if self.selectSpecialId == eventData[1].id then
        SL:OpenTips(nil, eventData[1].cfgId,eventData[1].id)
    end
    self.selectSpecialId = eventData[1].id
    self.selectSpecialItemBG = eventData[2]
    self.selectSpecialItemGou = eventData[3]
    GUI:SetActive(self.selectSpecialItemBG,true)
    GUI:SetActive(self.selectSpecialItemGou,true)
    if self.selectData then
        self.selectData.cfgId = eventData[1].cfgId
        self.selectData.item = eventData[1]
    end
end

------------------------------------------------------------------------------------------------

--------------------------------预览界面-------------------------------------------------------
function this:PreviewDataListItemCountFunc()
    return #self.PreviewDataList
end

function this:PreviewDataListItemGetFunc(realIndex)
end

function this:PreviewDataListItemInitFunc(realIndex, kmlcontrol)

end

function this:PreviewDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.PreviewDataList[realIndex + 1]
    local _model = GUI:GetChildControl(self.view.PreviewDataList,realIndex,'Preview_Model')
    local _name = GUI:GetChildControl(self.view.PreviewDataList,realIndex,'Preview_Name')
    GUI:setPositionZ(_name, -300)
    ---@type cfg_item_column
    local itemCfg = SL:GetConfig("cfg_item",data)
    local colorID = itemCfg.color
    local textColor = SL:GetConfigMultiKeys('cfg_color', colorID, 'id').color
    GUI:Text_setString(_name,itemCfg.name)
    GUI:Text_setTextColor(_name,textColor)
    GUI:Item_setItemId(_model, data)
    GUI:AddOnClickEvent(_model, self, function()
        SL:OpenTips(nil, data)
    end)
end

------------------------------------------------------------------------------------------------

-----------------------------------左侧按钮-------------------------------------------------------
function this:LeftButtonDataListItemCountFunc()
    return #self.LeftButtonDataList
end

function this:LeftButtonDataListItemGetFunc(realIndex)
end

function this:LeftButtonDataListItemInitFunc(realIndex, kmlcontrol)

end

function this:LeftButtonDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.LeftButtonDataList[realIndex + 1]
    local cfgId = data.cfgId
    local count = data.count
    local _item = GUI:GetChildControl(self.view.LeftButtonDataList,realIndex,'LeftButton')
    local _button1 = GUI:GetChildControl(self.view.LeftButtonDataList,realIndex,'LeftButton_1')
    local _button2 = GUI:GetChildControl(self.view.LeftButtonDataList,realIndex,'LeftButton_2')
    local _button2_Arrow = GUI:GetChildControl(self.view.LeftButtonDataList,realIndex,'LeftButton_2_Arrow')
    local _button3 = GUI:GetChildControl(self.view.LeftButtonDataList,realIndex,'LeftButton_3')
    local _red1 = GUI:GetChildControl(self.view.LeftButtonDataList,realIndex,'RedDot_1')
    local _red2 = GUI:GetChildControl(self.view.LeftButtonDataList,realIndex,'RedDot_2')
    local _red3 = GUI:GetChildControl(self.view.LeftButtonDataList,realIndex,'RedDot_3')

    GUI:Button_loadTextureNormal(_button1,"btnA_02","Atlas/UISynthesisPanel.spriteatlas")
    GUI:Button_loadTextureNormal(_button2,"btnB_02","Atlas/UISynthesisPanel.spriteatlas")
    GUI:Button_loadTextureNormal(_button3,"btnC_02","Atlas/UISynthesisPanel.spriteatlas")
    GUI:SetActive(_button1,false)
    GUI:SetActive(_button2,false)
    GUI:SetActive(_button2_Arrow,false)
    GUI:SetActive(_button3,false)
    GUI:SetActive(_red1,false)
    GUI:SetActive(_red2,false)
    GUI:SetActive(_red3,false)
    GUI:SetEulerAngles(_button2_Arrow,0,0,0)
    local nowButton = _button1
    local nowButton2 = nil
    local isShow = self:RedDotIsShow(data.data,data.type)
    if data.type == 1 then
        --_item.rectTransform:SetSizeDelta(290,55)
        GUI:setContentSize(_item,290,55)
        GUI:SetActive(_button1,true)
        GUI:Button_setTitleText(_button1,data.data.typeName)
        GUI:SetActive(_red1,isShow)

        if self.selectType == data.data.type then
            GUI:Button_loadTextureNormal(_button1,"btnA_01","Atlas/UISynthesisPanel.spriteatlas")
        end
    elseif data.type == 2 then
        --_item.rectTransform:SetSizeDelta(290,45)
        GUI:setContentSize(_item,290,45)
        GUI:SetActive(_button2,true)
        GUI:SetActive(_red2,isShow)
        local name = data.data.subTypeName
        if data.data.subType == 0 then
            name = data.data.name
        end
        GUI:SetActive(_button2_Arrow,data.data.subType > 0)
        if self.selectSubTypeID == data.data.id then
            GUI:Button_loadTextureNormal(_button2,"btnB_01","Atlas/UISynthesisPanel.spriteatlas")
            GUI:SetEulerAngles(_button2_Arrow,0,0,90)
        end
        GUI:Button_setTitleText(_button2,name)
        nowButton = _button2
        nowButton2 = _button2_Arrow
    elseif data.type == 3 then
        --_item.rectTransform:SetSizeDelta(290,40)
        GUI:setContentSize(_item,290,40)
        GUI:Button_setTitleText(_button3,data.data.name)
        GUI:SetActive(_red3,isShow)
        if self.selectCfgId == data.data.id then
            GUI:Button_loadTextureNormal(_button3,"btnC_01","Atlas/UISynthesisPanel.spriteatlas")
        end
        GUI:SetActive(_button3,true)
        nowButton = _button3
    end
    GUI:AddOnClickEvent(nowButton,self,self.OnClickSelectLeftItemButton,{data})
end

function this:OnClickSelectLeftItemButton(_,eventData)
    local info = eventData[1]
    --默认第一条信息
    local defaultInfo = self.allCfgDataList[info.data.type][info.data.subType][1]
    if info.type == 1 then
        --选择相同的父类
        if info.data.type == self.selectType then
            --关闭页签 清除选中 保留上次选中
            self.selectType = 0
            self.selectCfgId = 0
        else
            self.selectType = info.data.type
            self.selectCfgId = defaultInfo.id
            --显示默认第一条信息
            self.selectSubType = defaultInfo.subType
            self.selectSubTypeID = defaultInfo.id
            self:ShowRightInfo(defaultInfo)
        end
    elseif info.type == 2 then
        local isSelectSubTypeID = info.data.id == self.selectSubTypeID
        --选择相同的子类
        if isSelectSubTypeID then
            --无子类
            if info.data.subType == 0 then
                return
            end
            --有子类清除一下选中
            self.selectSubType = -1
            self.selectSubTypeID = 0
        else
            --显示默认第一条信息
            self.selectSubType = info.data.subType
            self.selectSubTypeID = info.data.id
            self.selectCfgId = info.data.id
        end
        --无子类
        if info.data.subType == 0 then
            --显示当前选中数据
            self:ShowRightInfo(info.data)
        else
            --未选择相同的  反之显示上次选中数据
            if not isSelectSubTypeID then
                --关闭页签 清除选中 保留上次选中
                self:ShowRightInfo(defaultInfo)
            end
        end
    elseif info.type == 3 then
        --选择相同的子子类不操作
        if info.data.id == self.selectCfgId then
            return
        end
        --选择子子类数据
        self.selectSubType = info.data.subType
        self.selectCfgId = info.data.id
        self:ShowRightInfo(info.data)
    end
    self.LeftButtonDataList = {}
    --父类型列表
    local typeList = {}
    for i, v in ipairs(self.AllTypeList) do
        local data = self:SortCfgList(self.allCfgDataList[v])
        
        for z, a in ipairs(data) do
            --父类型列表中是否有该父类型
            if not table.contains(typeList,a.data[1].type) then
                table.insert(self.LeftButtonDataList,{type = 1,data = a.data[1]})
                table.insert(typeList,a.data[1].type)
            end
        end
        if self.selectType > 0 and v == info.data.type then
            for z, a in ipairs(data) do
                local subType = a.subType
                local isAdd = false
                for q, w in ipairs(a.data) do
                    if subType > 0 then
                        if not isAdd then
                            isAdd = true
                            table.insert(self.LeftButtonDataList,{type = 2,data = w})
                        end
                        if self.selectSubType == subType then
                            table.insert(self.LeftButtonDataList,{type = 3,data = w})
                        end
                    else
                        table.insert(self.LeftButtonDataList,{type = 2,data = w})
                    end
                end
            end
        end
    end

    self.selectSpecialId = 0
    GUI:DataListUpdateData(self.view.LeftButtonDataList)

end

---把表数据根据子类型排下序
---@return table<number,{subType:number,data:table<number,cfg_synthesis_column>}>
function this:SortCfgList(list)
    local copyList = {}
    for i, v in pairs(list) do
        table.insert(copyList,{subType = i,data = v})
    end
    table.sort(copyList,function(a, b) 
        return a.subType < b.subType
    end)
    return copyList
end

---红点是否显示
---@param cfg cfg_synthesis_column
---@param type number @按钮类型：1：1级按钮（判断下面所有材料是否充足） 2：2级按钮（判断下面材料是否充足） 3：3级按钮（只判断自己是否材料足够）
function this:RedDotIsShow(cfg,type)
    local isShowRed = true
    if type == 1 then
        isShowRed = false
        for i, v in pairs(self.allCfgDataList[cfg.type]) do
            for q, w in ipairs(v) do
                if self:MaterialIsCan(w) then
                    isShowRed = true
                    break
                end
            end
        end
    elseif type == 2 then
        if cfg.subType == 0 then
            for i, v in pairs(self.allCfgDataList[cfg.type][cfg.subType]) do
                if cfg.id == v.id then
                    if not self:MaterialIsCan(v) then
                        isShowRed = false
                        break
                    end
                end
            end
        else
            isShowRed = false
            for i, v in pairs(self.allCfgDataList[cfg.type][cfg.subType]) do
                if self:MaterialIsCan(v) then
                    isShowRed = true
                    break
                end
            end
        end
    elseif type == 3 then
        for i, v in pairs(self.allCfgDataList[cfg.type][cfg.subType]) do
            if cfg.id == v.id then
                if not self:MaterialIsCan(v) then
                    isShowRed = false
                    break
                end
            end
        end
    end
    return isShowRed
end

---@param cfg cfg_synthesis_column
function this:MaterialIsCan(cfg)
    local isArbitrarily = false
    if #cfg.arbitrarily > 0 then
        local arbitrarily = {}
        for i, v in ipairs(cfg.arbitrarily) do
            for z, a in ipairs(v) do
                if not arbitrarily[tonumber(a)] then
                    arbitrarily[tonumber(a)] = 1
                else
                    arbitrarily[tonumber(a)] = arbitrarily[tonumber(a)] + 1
                end
            end
        end
        for i, v in pairs(arbitrarily) do
            local bagCount = SL:GetBagItemCount(i)
            if bagCount >= v then
                isArbitrarily = true
                break
            end
        end
    else
        isArbitrarily = true
    end
    
    local isConsumeItem = true
    local consumeItem = {}
    for i, v in ipairs(cfg.consumeItem) do
        if not consumeItem[tonumber(v[1])] then
            consumeItem[tonumber(v[1])] = tonumber(v[2])
        else
            consumeItem[tonumber(v[1])] = consumeItem[tonumber(v[1])] + tonumber(v[2])
        end
    end
    for i, v in pairs(consumeItem) do
        local bagCount = SL:GetBagItemCount(i)
        local count = v
        if bagCount < count then
            isConsumeItem = false
            break
        end
    end
    return isArbitrarily and isConsumeItem
end

------------------------------------------------------------------------------------------------

return this
