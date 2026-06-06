---@class KLTitlePanel:UIKmlLuaPanelBase
---@field view KLTitlePanelView
---@field titleData TitleData[]
---@field curTitleItem KLTitleItem
---@field curTitleId number
---@field serverTitleId number
local KLTitlePanel = class(UIKmlLuaPanelBase)
local this = KLTitlePanel

---创建时调用一次
function this:Init()
    self.titleData = {}
    ---@type {str:string,sort:number}[]
    self.attrData = {}
    ---@type table<KingML.KmlControl,KLTitleItem>
    self.titleItems = {}

    ---@param realIndex number
    ---@param kmlCtrl KingML.KmlControl
    GUI:DataListInitData(self.view.loopscrollviewData,
            function()
                return #self.titleData
            end,
            function()
                ---@type KLTitleItem
                local item = GUI:UIPanel_Open("dev/outui/AppearGroup/Item/KLTitle/KLTitleItem", self.view.loopscrollviewData, self, nil, true)

                local kmlCtrl = item.view.root
                self.titleItems[kmlCtrl] = item
                return kmlCtrl
            end,
            nil,

            function(realIndex, kmlCtrl)
                local item = self.titleItems[kmlCtrl]
                local luaIndex = realIndex + 1
                local dt = self.titleData[luaIndex]
                local isSelect = dt.confId == self.curTitleId
                item:UpdateUI(dt, isSelect)
            end
    )

    ---@param realIndex number
    GUI:DataListInitData(self.view.datalist11,
            function()
                return #self.attrData
            end,
            nil,
            nil,
            function(realIndex,kmlCtrl)
                local txtInfo = GUI:GetChildControl(self.view.datalist11, realIndex, 'TxtInfo',kmlCtrl)
                local luaIndex = realIndex + 1
                local dt = self.attrData[luaIndex]
                GUI:Text_setString(txtInfo, dt.str)
            end)


end

---创建或者刷新界面数据时调用
function this:Refresh()
    --SL:SendLuaNetMsg(LuaMessageIdToSever.GET_TITLE)
    self:GET_TITLE(_, InfoManager.appearInfo.titleData)
end

function this:AnalysisTitleAttrData()
    table.clear(self.attrData)
    ---@type table<number,number>
    local attrId2Val = {}
    for _, v in pairs(self.titleData) do
        ---@type cfg_fashion_column
        local fashionTbl = SL:GetConfig("cfg_fashion", v.confId)
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
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.GET_TITLE, self.GET_TITLE, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.SETTING_TITLE_APPEAR, self.SETTING_TITLE_APPEAR, self)
end

function this:SETTING_TITLE_APPEAR(_, message)
    self.serverTitleId = tonumber(message)
end


--[[
{
    title{
        {
            obtainTime: -- 称号的获取时间
            expiresTime： -- 称号的到期时间（到期时间的时间戳） -1为永久 
            confId：
            type: -- 1永久 2限时 3活动限时
        },
        ...
    } -- 称号列表
    hidden: --是否隐藏称号
    curEquipTitle: --当前穿戴的称号
}
]]

---@alias TitleData {obtainTime:number,confId:number,type:number,expiresTime:number}
---@param message {title:TitleData[],curEquipTitle:number,hidden:boolean}
function this:GET_TITLE(_, message)
    self.serverTitleId = tonumber(message.curEquipTitle)
    self.curTitleId = tonumber(message.curEquipTitle)

    table.clear(self.titleData)
    local meTbl
    for _, v in pairs(message.title) do
        if self.serverTitleId == v.confId then
            meTbl = v
        else
            table.insert(self.titleData, v)
        end
    end

    table.sort(self.titleData, function(a, b)
        return a.confId < b.confId
    end)

    if meTbl then
        table.insert(self.titleData, 1, meTbl)
    end

    GUI:DataListUpdateData(self.view.loopscrollviewData)

    self:AnalysisTitleAttrData()
    GUI:DataListUpdateData(self.view.datalist11)

end

function this:BtnSureOnClick()
    SL:CommonTipsMessage({
        stringTblID = 209,
        titlePos = {x= 0,y=-26},
        title = "提示",
        callback = function()
            SL:SendLuaNetMsg(LuaMessageIdToSever.SET_TITLE, { title = self.curTitleId })
            self:BtnCloseOnClick()
        end
    })
end

function this:BtnCancelOnClick()
    if self.curTitleId == self.serverTitleId then
        self:BtnCloseOnClick()
        return
    end

    self:BtnSureOnClick()
end

function this:BtnCloseOnClick()
    GUI:UIPanel_Close("dev/outui/AppearGroup/Panel/KLTitle/KLTitlePanel")
    GUI:UIPanel_Close("dev/outui/AppearGroup/Panel/KLAppearGroup/KLAppearGroupPanel")
    GUI:UIPanel_Close("dev/outui/AppearGroup/Panel/KLAppearPreview/KLAppearPreviewPanel")
end

function this:Close()
    self.curTitleItem = nil
    self.curTitleId = nil
    self.serverTitleId = nil
    SL:onLUAEvent(TITLE_PREVIEW_SELECT_CHANGE)
end

---@param titleItem KLTitleItem
function this:TitleItemOnClick(titleItem, titleId)
    if self.curTitleItem then
        self.curTitleItem:SetIsSelect(false)
    end

    if self.curTitleItem and self.curTitleId == titleId then
        self.curTitleId = nil
        self.curTitleItem = nil
    else
        self.curTitleItem = titleItem
        self.curTitleId = titleId
        titleItem:SetIsSelect(true)
    end

    SL:onLUAEvent(TITLE_PREVIEW_SELECT_CHANGE, self.curTitleId)

end

return this
