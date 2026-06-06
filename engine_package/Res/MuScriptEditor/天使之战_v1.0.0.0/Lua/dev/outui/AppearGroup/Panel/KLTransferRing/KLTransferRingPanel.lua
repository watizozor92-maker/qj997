---@class KLTransferRingPanel:UIKmlLuaPanelBase
---@field view KLTransferRingPanelView
---@field curRingItem KLTransferRingItem
---@field curRingId number
---@field serverRingId number
local KLTransferRingPanel = class(UIKmlLuaPanelBase)
local this = KLTransferRingPanel

---创建时调用一次
function this:Init()
    GUI:DataListInitData(self.view.loopscrollviewData,
            function()
                return self:ItemCountFunc()
            end,
            function(realIndex)
                return self:ItemGetFunc(realIndex)
            end,
            function(realIndex, kmlCtrl)
                return self:ItemInitFunc(realIndex, kmlCtrl)
            end,
            function(realIndex, kmlCtrl)
                return self:ItemUpdateFunc(realIndex, kmlCtrl)
            end
    )

    GUI:DataListInitData(self.view.datalist11,
            function()
                return self:AttrCountFunc()
            end,
            function(realIndex)
                return self:AttrItemGetFunc(realIndex)
            end,
            function(realIndex, kmlCtrl)
                return self:AttrItemInitFunc(realIndex, kmlCtrl)
            end,
            function(realIndex, kmlCtrl)
                return self:AttrItemUpdateFunc(realIndex, kmlCtrl)
            end)

    ---@type RingData[]
    self.ringData = {}
    ---@type {str:string,sort:number}[]
    self.attrData = {}
    ---@type table<KingML.KmlControl,KLTransferRingItem>
    self.ringItems = {}
end

--region 变身戒指

function this:ItemCountFunc()
    return #self.ringData
end

function this:ItemGetFunc(realIndex)
    ---@type KLTransferRingItem
    local item = GUI:UIPanel_Open("dev/outui/AppearGroup/Item/KLTransferRing/KLTransferRingItem", self.view.loopscrollviewData, self, nil, true, 
                                  function(uiItem)
                                      self.ringItems[uiItem.view.root] = uiItem
                                      self:ItemUpdateFunc(realIndex, uiItem.view.root)
                                  end)

    return item.view.root
end

function this:ItemInitFunc()

end

---@param realIndex number
---@param kmlCtrl KingML.KmlControl
function this:ItemUpdateFunc(realIndex, kmlCtrl)
    local item = self.ringItems[kmlCtrl]
    if item == nil then
        return
    end
    local luaIndex = realIndex + 1

    local dt = self.ringData[luaIndex]
    local isSelect = dt.itemId == self.curRingId
    item:UpdateUI(dt, isSelect)
end

--endregion

--region Attr
function this:AttrCountFunc()
    return #self.attrData
end

function this:AttrItemGetFunc()
end

function this:AttrItemInitFunc()

end

---@param realIndex number
function this:AttrItemUpdateFunc(realIndex)
    local txtInfo = GUI:GetChildControl(self.view.datalist11, realIndex, 'TxtInfo')
    local luaIndex = realIndex + 1

    local dt = self.attrData[luaIndex]

    GUI:Text_setString(txtInfo, dt.str)

end

--endregion

---创建或者刷新界面数据时调用
function this:Refresh()
    SL:onLUAEvent(TRANSFER_RING_PREVIEW_SELECT_CHANGE)
    --SL:SendLuaNetMsg(LuaMessageIdToSever.GET_SHAPE_RING)
    self:GET_SHAPE_RING(_, InfoManager.appearInfo.ringData)
end

function this:AnalysisRingAttrData()
    table.clear(self.attrData)
    ---@type table<number,number>
    local attrId2Val = {}
    for _, v in pairs(self.ringData) do
        ---@type cfg_fashion_column
        local fashionTbl = SL:GetConfig("cfg_fashion", v.itemId)
        if fashionTbl then
            for _, attr in pairs(fashionTbl.att) do
                local attrId = attr[1]
                local attrVal = attr[2]

                if attrId and attrVal then
                    if not attrId2Val[attrId] then
                        attrId2Val[attrId] = attrVal
                    else
                        attrId2Val[attrId] = attrId2Val[attrId] + attrVal
                    end
                end
            end
        end
    end

    --策划要求 最大(小)攻击力提高 最大(小)魔法攻击力   最大(小)攻击力   最大(小)诅咒攻击力 合并写死
    local hasAtkUp
    local hasAtk
    local hasMagic
    local hasCurse

    if attrId2Val[200011] and attrId2Val[200021] then
        local str
        if attrId2Val[200011] == attrId2Val[200021] then
            str = "<color=#FFFFFF>攻击力提高:</color>" .. attrId2Val[200011]
        else
            str = "<color=#FFFFFF>攻击力提高:</color>" .. attrId2Val[200011] .. "~" .. attrId2Val[200021]
        end

        ---@type cfg_att_info_column
        local attrTbl = SL:GetConfig("cfg_att_info", 200011)
        table.insert(self.attrData, { str = str, sort = attrTbl.sort })
        hasAtkUp = true
    end

    if attrId2Val[201011] and attrId2Val[201021] then
        local str
        if attrId2Val[201011] == attrId2Val[201021] then
            str = "<color=#FFFFFF>攻击力:</color>" .. attrId2Val[201021]
        else
            str = "<color=#FFFFFF>攻击力:</color>" .. attrId2Val[201021] .. "~" .. attrId2Val[201011]
        end

        ---@type cfg_att_info_column
        local attrTbl = SL:GetConfig("cfg_att_info", 201011)
        table.insert(self.attrData, { str = str, sort = attrTbl.sort })

        hasAtk = true
    end

    if attrId2Val[202011] and attrId2Val[202021] then
        local str
        if attrId2Val[202011] == attrId2Val[202021] then
            str = "<color=#FFFFFF>魔法攻击力:</color>" .. attrId2Val[202021]
        else
            str = "<color=#FFFFFF>魔法攻击力:</color>" .. attrId2Val[202021] .. "~" .. attrId2Val[202011]
        end

        ---@type cfg_att_info_column
        local attrTbl = SL:GetConfig("cfg_att_info", 202011)
        table.insert(self.attrData, { str = str, sort = attrTbl.sort })
        hasMagic = true
    end

    if attrId2Val[205011] and attrId2Val[205021] then
        local str
        if attrId2Val[205011] == attrId2Val[205021] then
            str = "<color=#FFFFFF>诅咒攻击力:</color>" .. attrId2Val[205011]
        else
            str = "<color=#FFFFFF>诅咒攻击力:</color>" .. attrId2Val[205011] .. "~" .. attrId2Val[205021]
        end
        ---@type cfg_att_info_column
        local attrTbl = SL:GetConfig("cfg_att_info", 205011)
        table.insert(self.attrData, { str = str, sort = attrTbl.sort })
        hasCurse = true
    end

    for attrId, attrVal in pairs(attrId2Val) do
        local isAdd
        if attrId == 200011 or attrId == 200021 then
            isAdd = not hasAtkUp
        elseif attrId == 201011 or attrId == 201021 then
            isAdd = not hasAtk
        elseif attrId == 202011 or attrId == 202021 then
            isAdd = not hasMagic
        elseif attrId == 205011 or attrId == 205021 then
            isAdd = not hasCurse
        else
            isAdd = true
        end

        if isAdd then
            ---@type cfg_att_info_column
            local attrTbl = SL:GetConfig("cfg_att_info", attrId)
            local str
            if attrTbl.remarks == 1 then
                str = "<color=#FFFFFF>" .. attrTbl.name .. ":</color>" .. attrVal
            else
                str = "<color=#FFFFFF>" .. attrTbl.name .. ":</color>" .. (attrVal / 100) .. "%"
            end
            table.insert(self.attrData, { str = str, sort = attrTbl.sort })
        end
    end

    table.sort(self.attrData, function(a, b)
        return a.sort < b.sort
    end)

end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.BtnClose, self, self.BtnCloseOnClick)
    GUI:AddOnClickEvent(self.view.BtnCancel, self, self.BtnCancelOnClick)
    GUI:AddOnClickEvent(self.view.BtnSure, self, self.BtnSureOnClick)

    SL:RegisterLuaNetMsg(LuaMessageIdToClient.GET_SHAPE_RING, self.GET_SHAPE_RING, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_PUTOON_RING, self.RES_PUTOON_RING, self)
end

function this:RES_PUTOON_RING(_, message)
    self.serverRingId = message
end


--[[

{
			curWearRing: --当前穿戴的变身戒指，怪物id
			"title":{
			1:{ -- key是下标
				"monsterId": --要变身的怪物id
				"ringAttr" : {} --戒指属性
				"getTime": --获取时间的秒数
				"time"： --有效期，有效期截止的秒数，-1为永久
				"itemId":
			}
			}
	}
]]

---@alias RingData {time:number,limitTime:boolean,ringAttr:table,getTime:number,itemId:number}
---@param message {curWearRing:number,title:RingData[]}
function this:GET_SHAPE_RING(_, message)
    self.serverRingId = message.curWearRing
    self.curRingId = message.curWearRing

    table.clear(self.ringData)
    local meTbl
    for _, v in pairs(message.title) do
        if self.serverRingId == v.confId then
            meTbl = v
        else
            table.insert(self.ringData, v)
        end
    end

    table.sort(self.ringData, function(a, b)
        return a.itemId < b.itemId
    end)

    if meTbl then
        table.insert(self.ringData, 1, meTbl)
    end

    GUI:DataListUpdateData(self.view.loopscrollviewData)

    self:AnalysisRingAttrData()
    GUI:DataListUpdateData(self.view.datalist11)
end

function this:BtnSureOnClick()
    SL:CommonTipsMessage({
        stringTblID = 209,
        titlePos = {x= 0,y=-26},
        title = "提示",
        callback = function()
            SL:SendLuaNetMsg(LuaMessageIdToSever.SET_SHAPE_RING, { monsterId = self.curRingId })
            self:BtnCloseOnClick()
        end
    })
end

function this:BtnCancelOnClick()
    if self.curRingId == self.serverRingId then
        self:BtnCloseOnClick()
        return
    end

    self:BtnSureOnClick()
end

function this:BtnCloseOnClick()
    GUI:UIPanel_Close("dev/outui/AppearGroup/Panel/KLTransferRing/KLTransferRingPanel")
    GUI:UIPanel_Close("dev/outui/AppearGroup/Panel/KLAppearGroup/KLAppearGroupPanel")
    GUI:UIPanel_Close("dev/outui/AppearGroup/Panel/KLAppearPreview/KLAppearPreviewPanel")
end

function this:Close()
    self.curRingItem = nil
    self.curRingId = nil
    self.serverRingId = nil
end

---@param ringItem KLTransferRingItem
function this:RingItemOnClick(ringItem, ringId)
    if self.curRingItem then
        self.curRingItem:SetIsSelect(false)
    end

    if self.curRingItem and self.curRingId == ringId then
        self.curRingId = nil
        self.curRingItem = nil
    else
        self.curRingItem = ringItem
        self.curRingId = ringId
        ringItem:SetIsSelect(true)
    end

    SL:onLUAEvent(TRANSFER_RING_PREVIEW_SELECT_CHANGE, self.curRingId)

end

return this

