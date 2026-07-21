local items = require("dev.outui.Activity.Panel.KLGoldChallenge.KLGoldChallengePanelView").items
---@class KLUIFruitPanel:UIKmlLuaPanelBase
---@field view KLUIFruitPanelView
---@field FruitAttDataList table<number,cfg_fruit_column> @果实表信息
---@field FruitPointTextList table<number,UIKmlLuaControl> @果实类型文本
---@field allFruitDataList table<number,CommonProtos.Item>
---@field AttDataList table<number,{type:number,point:number}> @属性加点列表
local KLUIFruitPanel = class(UIKmlLuaPanelBase)
local this =KLUIFruitPanel
---创建时调用一次
function this:Init()
    self.selectCalcData = nil
    
    self.FruitPointTextList = {}
    self.severAttList = {}

    ---一级属性
    self.firstAttTypeList = {}
    
    ---属性类型（百分比的）
    self.remarksAttTypeList = {}
    
    ---属性的名字
    self.AttNameStrList = {}
    
    ---所有次数的消耗信息
    self.consumeInfoList = {}
    local consumeCfg = string.split(SL:GetConfig("cfg_global",3002).value,'|')
    for i, v in ipairs(consumeCfg) do
        local strList = string.split(v,'#')
        self.consumeInfoList[tonumber(strList[1])] = {tonumber(strList[2]),tonumber(strList[3])}
    end
    
    ---背包里所有果实
    self.allFruitDataList = {}
    self.allFruitItemList = {}
    
    ---果实点数上限
    self.maxNum =  tonumber(SL:GetConfig("cfg_global",3001).value)
    ---重置次数
    self.ResetNum = 1
    ---货币id
    self.coinID = 0
    ---货币数量
    self.coinCount = 0
    ---货币是否足够
    self.isCoinEnough = true
    ---分配点数
    self.distributionPoint = 0

    ---果实属性信息
    self.FruitAttDataList = {}

    self.AttDataList = {}
    local fruitCfg = SL:GetConfigTable("cfg_fruit")
    local attrMap = {}
    ---@param v cfg_fruit_column
    for i, v in pairs(fruitCfg) do
        if not attrMap[v.attribute] then
            table.insert(self.FruitAttDataList,v)
            attrMap[v.attribute] = v
            
                ---@type cfg_att_info_column
            local attCfg = SL:GetConfig("cfg_att_info",v.attribute)
            if attCfg.base == 1 then
                table.insert(self.firstAttTypeList,v.attribute)
                table.insert(self.AttDataList,{type=v.attribute,index = v.index,point=0})
            end
            if attCfg.remarks == 2 then
                table.insert(self.remarksAttTypeList,v.attribute)
            end
            self.AttNameStrList[v.attribute] = v.name
        end
    end
    
    table.sort(self.AttDataList,function(a, b) 
        return a.index < b.index
    end)
    
    GUI:DataListInitData(self.view.FruitAttDataList,function()
        return self:FruitAttDataListItemCountFunc()
    end,function(realIndex)
        return self:FruitAttDataListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:FruitAttDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:FruitAttDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    GUI:DataListUpdateData(self.view.FruitAttDataList,_,function()
        self:SetAttText()
    end)
    
    GUI:DataListInitData(self.view.FruitDataList,function()
        return self:FruitDataListItemCountFunc()
    end,function(realIndex)
        return self:FruitDataListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:FruitDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:FruitDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    
    GUI:DataListInitData(self.view.AttDataList,function()
        return self:AttDataListItemCountFunc()
    end,function(realIndex)
        return self:AttDataListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:AttDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:AttDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    

end

---创建或者刷新界面数据时调用
function this:Refresh()
    SL:SendLuaNetMsg(LuaMessageIdToSever.GET_ALREADY_USE_POINTS)
    
    self:SetUsePointText()
    --self:SetAttText()
    self:GetBagAllFruit()

end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.closeButton,self,self.CloseButton)
    GUI:AddOnClickEvent(self.view.ClickMask,self,self.CloseResetPanelButton)
    GUI:AddOnClickEvent(self.view.CloseResetPanelBtn,self,self.CloseResetPanelButton)
    GUI:AddOnClickEvent(self.view.BtnReset,self,self.OpenResetPanelButton)
    GUI:AddOnClickEvent(self.view.HelpButton,self,self.OnClickShowHelp)
    
    GUI:AddOnClickEvent(self.view.ResetPanel_BtnReset,self,self.OnClickResetPanel_BtnReset)
    GUI:AddOnClickEvent(self.view.ResetPanel_BtnCancel,self,self.CloseResetPanelButton)
    SL:RegisterLUAEvent(LUA_EVENT_BAG_CHANGE_AFTER, self.BagInfo_Change, self)
    SL:RegisterLUAEvent(LUA_EVENT_MONEYCHANGE, self.CoinInfo_Change, self)

    SL:RegisterLuaNetMsg(LuaMessageIdToClient.C_USE_FRUIT_RESULT,self.C_USE_FRUIT_RESULT,self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.C_RESET_FRUIT_COUNT,self.C_RESET_FRUIT_COUNT,self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.USE_FRUIT_RESULT,self.USE_FRUIT_RESULT,self)
end

---使用果实结果
function this:USE_FRUIT_RESULT(_,message)
    --使用果实的效果
    if message then
        GUI:Image_loadTexture(self.view.FeedBackImg, "qianghuachenggong", "Atlas/FG_Fruit.spriteatlas")
    else
        GUI:Image_loadTexture(self.view.FeedBackImg, "qianghuashibai", "Atlas/FG_Fruit.spriteatlas")
    end
    GUI:SetActive(self.view.FeedBackImg,true)
    --GUI:setPosition(self.view.FeedBackImg,-112,0)
    SL:ScheduleOnce(1,function()
        GUI:SetActive(self.view.FeedBackImg,false)
    end)
--[[    SL:EffectDoMove(GUI:GetRectTransform(self.view.FeedBackImg),Vector2.New(646, 361),2,  function()
        GUI:SetActive(self.view.FeedBackImg,false)
    end)--]]
end

function this:C_USE_FRUIT_RESULT(_,message)
    self.severAttList = {}
    if message then
        self.distributionPoint = message["totalFirstLevelAttrs"] and message["totalFirstLevelAttrs"] or 0
        if message["attrPoints"] then
            for i, v in pairs(message["attrPoints"]) do
                self.severAttList[tonumber(i)] = tonumber(v)
            end
        end
    end
    
    SL:SendLuaNetMsg(LuaMessageIdToSever.GET_RESET_FRUIT_COUNT)
    self:SetUsePointText()
    self:SetAttText()
end

function this:C_RESET_FRUIT_COUNT(_,message)
    if message then
        self.ResetNum = message + 1
        if GUI:getVisible(self.view.ResetPanel) then
            GUI:SetActive(self.view.ResetPanel,false)
        end
    end
end

---@param eventData {index:number,item:CommonProtos.Item}[]
function this:BagInfo_Change(eventId, eventData)
    if not eventData then
        return
    end
    self:RefreshFruitDataList(eventData)
end

function this:CoinInfo_Change(eventId, eventData)
    if not GUI:getVisible(self.view.ResetPanel) then
        return
    end
    self:CreatCoinItem()
end

function this:CloseButton()
    SL:onLUAEvent(LUA_EVENT_FRUIT_PANEL_CLOSE)
end

---点击重置（重置界面中）
function this:OnClickResetPanel_BtnReset()
    if not self.isCoinEnough then
        SL:TipMessage(SL:GetConfig('cfg_string',246).text,1,NoticeType.NoticeMid)--"道具不足，请补充道具",
        return
    end
    local reqData = {}
    local allPoint = 0
    for i, v in pairs(self.AttDataList) do
        allPoint = allPoint + v.point
        reqData[tostring(v.type)] = v.point
    end
    if self.distributionPoint > 0 and allPoint == self.distributionPoint then
        SL:SendLuaNetMsg(LuaMessageIdToSever.S_RESET_FRUIT,reqData)
        return
    end
    SL:TipMessage(SL:GetConfig('cfg_string',279).text,1,NoticeType.NoticeMid)--"请将所有点数分配完毕！",
end

---关闭重置界面
function this:CloseResetPanelButton()
--[[    if self.selectCalcData then
        return
    end]]
    GUI:SetActive(self.view.ResetPanel,false)
end

---打开重置界面
function this:OpenResetPanelButton()
    self.selectCalcData = nil
    --GUI:SetActive(self.view.IsOpenCalcUI,false)
    ---属性
    for i, v in pairs(self.AttDataList) do
        v.point = 0
    end
    GUI:DataListUpdateData(self.view.AttDataList)
    self:SetResetNumText()
    self:SetDistributionPointText()
    self:CreatCoinItem()

    if not GUI:getVisible(self.view.ResetPanel) then
        GUI:SetActive(self.view.ResetPanel,true)
        GUI:SetZIndex(self.view.ResetPanel,205)
    end
end

---设置属性文本
function this:SetAttText()
    for i, v in pairs(self.FruitPointTextList) do
        local value = (self.severAttList and self.severAttList[i]) and self.severAttList[i] or 0
        local otherStr = ""
        if table.contains(self.remarksAttTypeList,i) then
            if value > 0 then
                value = value * 100
                local t1,t2 = math.modf(value)
                if t2 <= 0 then
                    value = t1
                end
            end
            otherStr = "%"
        end
        GUI:Text_setString(v,self.AttNameStrList[i].."：<color=#00ff00>".."+"..value..otherStr.."</color>")
    end
end

---生成货币模型和数量
function this:CreatCoinItem()
    if self.consumeInfoList[self.ResetNum] then
        self.coinID = self.consumeInfoList[self.ResetNum][1]
        self.coinCount = self.consumeInfoList[self.ResetNum][2]
    else
        self.coinID = self.consumeInfoList[#self.consumeInfoList][1]
        self.coinCount = self.consumeInfoList[#self.consumeInfoList][2]
    end
    
    local data = {
        width = "30",
        height = "30",
        itemid = self.coinID,
        noclip = "1",
        z = -3001,
        mfixsize = "30,30",
        itemcount = nil,
        bgtype="0",
    }
    if self.item then
        GUI:Item_UpdataData(self.item, data)
    else
        self.item = GUI:Item_Create(self.view.Model, data)
    end
    
    self.isCoinEnough = SL:GetBagItemCount(self.coinID) >= self.coinCount
    local color = self.isCoinEnough and "#00ff00" or "#ff2323"
    GUI:Text_setString(self.view.ConsumCount,"<color="..color..">"..SL:GetBagItemCount(self.coinID).."/"..tostring(self.coinCount).."</color>")
end

---设置重置次数文本
function this:SetResetNumText()
    GUI:Text_setString(self.view.ResetPanel_TextResetTimes,"第<color=#00ff00>"..self.ResetNum.."</color>次重置")
end

---设置可分配点数文本
function this:SetDistributionPointText()
    local allPoint = 0
    for i, v in pairs(self.AttDataList) do
        allPoint = allPoint + v.point
    end
    
    GUI:Text_setString(self.view.ResetPanel_TextPoint,"可分配点数："..(self.distributionPoint - allPoint))
end

---设置使用点数的文本
function this:SetUsePointText()
    self.isCanUse = self.distributionPoint < self.maxNum
    GUI:Text_setString(self.view.TextPintInfo,"已用点数："..self.distributionPoint.."/"..self.maxNum)
end

--------------------------------果实属性图标-------------------------------------------------------
function this:FruitAttDataListItemCountFunc()
    return #self.FruitAttDataList
end

function this:FruitAttDataListItemGetFunc(realIndex)
    
end

function this:FruitAttDataListItemInitFunc(realIndex, kmlcontrol)

end

function this:FruitAttDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.FruitAttDataList[realIndex + 1]
    local _item = GUI:GetChildControl(self.view.FruitAttDataList,realIndex,'FruitAttItem')
    local _icon = GUI:GetChildControl(self.view.FruitAttDataList,realIndex,'FruitAttItem_Icon')
    local _text = GUI:GetChildControl(self.view.FruitAttDataList,realIndex,'FruitAttItem_Text')

    GUI:Image_loadTexture(_icon,data.icon or "","Atlas/FG_Fruit.spriteatlas")
    GUI:setPosition(_item,tonumber(data.location[1]),tonumber(data.location[2]))

    self.FruitPointTextList[data.attribute] = _text
end

------------------------------------------------------------------------------------------------

--------------------------------背包里的果实-------------------------------------------------------
function this:FruitDataListItemCountFunc()
    return #self.allFruitDataList
end

---获取果实的物品信息
function this:GetFruitItemInfo(index, itemCfgId, isUse)
    if self.allFruitDataList[index].count > 0 and isUse then
        local item = SL:MeData_GetCfgBaseOnItemId(itemCfgId)
        if item then
            SL:OpenTips("bag", itemCfgId, item.id, item.count >= 10 and 10 or item.count)
            return true
        end
    else
        SL:CommonItemGetPath(nil, itemCfgId)
    end
    return false
end

function this:FruitDataListItemGetFunc(realIndex)
    local index = realIndex + 1
    local data = {
        width = "70",
        height = "70",
        tips = "1",
        z = -301,
        itemid = self.allFruitDataList[index].cfgId,
        itemcustomcount = self:GetFruitCountStr(self.allFruitDataList[index].count),
    }
    local item = GUI:Item_Create(self.view.FruitDataList, data)
    GUI:AddOnClickEvent(item, self, function()        
        local isUse = self.isCanUse
        if not table.contains(self.firstAttTypeList,self.allFruitDataList[index].type) then
            isUse = true
        end
        local items = self.allFruitDataList[index].items
        if items and #items > 0 then
            for _, v in ipairs(items) do
                if self:GetFruitItemInfo(index, tonumber(v), isUse) then
                    break
                end
            end
        else
            local cfgId = self.allFruitDataList[index].cfgId
            self:GetFruitItemInfo(index, cfgId, isUse)
        end
    end)
    
    self.allFruitItemList[item] = item
    return item
end

function this:FruitDataListItemInitFunc(realIndex, kmlcontrol)

end

function this:FruitDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.allFruitDataList[realIndex + 1]
    local item = self.allFruitItemList[kmlcontrol]
    GUI:Item_UpdataData(item, {
        itemid = data.cfgId,
        itemcustomcount = self:GetFruitCountStr(data.count),
    })
end

---获取果实数量的文本
function this:GetFruitCountStr(count)
    local color = count > 0 and "#00ff00" or "#ff2323"
    if count >= 99 then
        count = 99
    end
    return "<color="..color..">"..count.."</color>"
end

---获取背包里所有的果实
function this:GetBagAllFruit()
    self.allFruitDataList = {}
    for i, v in pairs(self.FruitAttDataList) do
        table.insert(self.allFruitDataList,{
            cfgId = v.id,
            type = v.attribute,
            count = SL:GetBagItemCount(v.id),
            items = v.itemids,
        })
    end
    GUI:DataListUpdateData(self.view.FruitDataList)
end

---刷新背包里所有的果实数量
function this:RefreshFruitDataList()
    for i, v in pairs(self.allFruitDataList) do
        v.count = SL:GetBagItemCount(v.cfgId)
    end
    GUI:DataListUpdateData(self.view.FruitDataList)
end

------------------------------------------------------------------------------------------------

--------------------------------分配点数-------------------------------------------------------
function this:AttDataListItemCountFunc()
    return #self.AttDataList
end

function this:AttDataListItemGetFunc(realIndex)
end

function this:AttDataListItemInitFunc(realIndex, kmlcontrol)

end

function this:AttDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.AttDataList[realIndex + 1]
    local _name = GUI:GetChildControl(self.view.AttDataList,realIndex,'AttItem_Name')
    local _btnMinus = GUI:GetChildControl(self.view.AttDataList,realIndex,'AttItem_BtnMinus')
    local _btnAdd = GUI:GetChildControl(self.view.AttDataList,realIndex,'AttItem_BtnAdd')
    local _text = GUI:GetChildControl(self.view.AttDataList,realIndex,'AttItem_Text')
    local _inputButton = GUI:GetChildControl(self.view.AttDataList,realIndex,'AttItem_InputButton')
    GUI:Text_setString(_name,self.AttNameStrList[data.type])
    self:SetInputText(_text,data.point)
    GUI:AddOnClickEvent(_btnMinus,self,self.OnClickMins,{data,_text})
    GUI:AddOnClickEvent(_btnAdd,self,self.OnClickAdd,{data,_text})
    GUI:AddOnClickEvent(_inputButton,self,self.OnClickShowCalcPanel,{data,_text})
end

function this:OnClickMins(_,eventData)
    if eventData[1].point > 0 then
        eventData[1].point = eventData[1].point - 1
        self:SetInputText(eventData[2],eventData[1].point)
    end
    self:SetDistributionPointText()
end

function this:OnClickAdd(_,eventData)
    local allPoint = 0
    for i, v in pairs(self.AttDataList) do
        allPoint = allPoint + v.point
    end
    if self.distributionPoint - allPoint > 0 then
        eventData[1].point = eventData[1].point + 1
        self:SetInputText(eventData[2],eventData[1].point)
    end
    self:SetDistributionPointText()
end

function this:OnClickShowCalcPanel(_,eventData)
    self.selectCalcData = eventData
    --GUI:SetActive(self.view.IsOpenCalcUI,true)
    
    local allPoint = 0
    for i, v in pairs(self.AttDataList) do
        allPoint = allPoint + v.point
    end
    GUI:UIPanel_Open("dev/ui/Common/Panel/KLCalc/KLCalcPanel",nil,nil, 
            {
                maxNum = self.distributionPoint - allPoint,
                ins = self,
                callback = self.CalcCallBack,
                intro = "增加点数"})
end

function this:CalcCallBack(addValue)
    if self.selectCalcData then
        self.selectCalcData[1].point = addValue
        self:SetInputText(self.selectCalcData[2],addValue)
        self.selectCalcData = nil
        --GUI:SetActive(self.view.IsOpenCalcUI,false)
        self:SetDistributionPointText()
    end
end

---@param control UIKmlLuaControl
---@param value string
function this:SetInputText(control,value)
    GUI:Text_setString(control,tostring(value))
end

------------------------------------------------------------------------------------------------

function this:OnClickShowHelp()
    local helpCfg=SL:GetConfig("cfg_rule_text",11)
    if helpCfg then
        SL:CommonStrTipsMessage({title =helpCfg.menutxt,str=helpCfg.location})
    end
end

function this:Close()
    GUI:SetActive(self.view.FeedBackImg,false)
end

return this
