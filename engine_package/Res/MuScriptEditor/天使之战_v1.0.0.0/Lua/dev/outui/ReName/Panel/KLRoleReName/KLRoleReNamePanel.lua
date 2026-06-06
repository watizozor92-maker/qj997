---@class KLRoleReNamePanel:UIKmlLuaPanelBase
---@field view KLRoleReNamePanelView
local KLRoleReNamePanel = class(UIKmlLuaPanelBase)
local this = KLRoleReNamePanel
function this:AsyncLoadUI()
end
---创建时调用一次
function this:Init()
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.closeBtn, self, self.OnClickCloseBtn)
    GUI:AddOnClickEvent(self.view.cancelBtn, self, self.OnClickCloseBtn)
    GUI:AddOnClickEvent(self.view.okBtn, self, self.OnClickOkBtn)
    GUI:Input_SetOnEndEdit(self.view.input, self, self.OnValueChangeInputEnd)

    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_GET_UNION_INFO, self.ResUnionInfo, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_ROLE_IS_FIRST_CHANGE_NAME, self.RES_ROLE_IS_FIRST_CHANGE_NAME, self)
end

function this:OnClickCloseBtn()
    GUI:UIPanel_Close("dev/outui/ReName/Panel/KLRoleReName/KLRoleReNamePanel")
end

function this:OnClickOkBtn()
    if string.isNullOrEmpty(self.name) then
        GUI:UIPanel_Open("dev/outui/Activity/Panel/KLSure/KLSurePanel", nil, nil, { okFunc = function()
            GUI:UIPanel_Close("dev/outui/Activity/Panel/KLSure/KLSurePanel")
        end
        , content = "名字不能为空" })
        return
    end
    if self.ischangename and not self.isMeet then
        SL:TipMessage("道具不足，无法更改！", 1, NoticeType.NoticeMid)
        SL:CommonItemGetPath(nil, self.args.cfgId)
        return
    end

    if self.args.cfgId == 60090002 or self.args.cfgId == 1269000299 then
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_CHANGE_ROLE_NAME, { roleName = self.name })
    elseif self.args.cfgId == 60090003 or self.args.cfgId == 1269000399 then
        if not SL:CheckIsAllCN(self.name) then
            SL:TipMessage("战盟名称为中文字符，请重新输入" ,1, NoticeType.NoticeMid)
        end
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_CHANGE_UNION_NAME, { unionName = self.name })
    end
    GUI:UIPanel_Close("dev/outui/ReName/Panel/KLRoleReName/KLRoleReNamePanel")

end

function this:OnValueChangeInputEnd(_, _, eventData)
    self.name = eventData[1]
end

function this:ResUnionInfo(id, message)
    self.ischangename = message.ischangename == "1"
    self:RefreshData()
end

function this:RES_ROLE_IS_FIRST_CHANGE_NAME(id, message)
    self.ischangename = message == 1
    self:RefreshData()
end

---界面显示时调用一次
function this:Show()
    self.isMeet = false
    GUI:Image_loadTexture(self.view.title, self.args.title, "Atlas/TS_Common.spriteatlas")
    GUI:Text_setString(self.view.des, self.args.des or "")
    if self.args.cfgId == 60090003 or self.args.cfgId == 1269000399 then
        --战盟改名卡
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_GET_UNION_INFO)
    elseif self.args.cfgId == 60090002 or self.args.cfgId == 1269000299 then
        --角色改名卡
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_ROLE_IS_FIRST_CHANGE_NAME)
    end
end
---创建或者刷新界面数据时调用
function this:Refresh()
end

function this:RefreshData()
    ---@type cfg_global_column
    local tbl = SL:GetConfig("cfg_global", 1600, "id")
    local str = string.split(tbl.value, "|")
    str = string.split(str[1], "#")
    local costCfgId = tonumber(str[1])
    local costCount = tonumber(str[2])
    local ownerTicket = SL:GetBagItemCount(costCfgId)

    if self.ischangename then
        ---@type cfg_global_column
        tbl = SL:GetConfig("cfg_global", 1602, "id")
        str = string.split(tbl.value, "|")
        if self.args.cfgId == 60090002 or self.args.cfgId == 1269000299 then
            str = string.split(str[2], "#")
            local costCfgId1 = tonumber(str[1])
            local costCount1 = tonumber(str[2])

            local ownerTicket1 = SL:GetBagItemCount(costCfgId1)

            ownerTicket = ownerTicket1 < costCount1 and ownerTicket or ownerTicket1
            costCount = ownerTicket1 < costCount1 and costCount or costCount1
            costCfgId = ownerTicket1 < costCount1 and costCfgId or costCfgId1
        elseif self.args.cfgId == 60090003 or self.args.cfgId == 1269000399 then
            str = string.split(str[1], "#")
            local costCfgId2 = tonumber(str[1])
            local costCount2 = tonumber(str[2])

            local ownerTicket2 = SL:GetBagItemCount(costCfgId2)
            ownerTicket = ownerTicket2 < costCount2 and ownerTicket or ownerTicket2
            costCount = ownerTicket2 < costCount2 and costCount or costCount2
            costCfgId = ownerTicket2 < costCount2 and costCfgId or costCfgId2
        end

        self.isMeet = costCount <= ownerTicket
        local color = self.isMeet and "#00ff00" or "#ff2323"
        GUI:Text_setString(self.view.costCount, GUIUtil.GetColorText(costCount, color))
    else
        self.isMeet = true
        costCfgId = self.args.cfgId
        GUI:Text_setString(self.view.costCount, "首次免费")
    end
    if costCfgId == 10020001 then
         self.item_model = GUI:Item_Create(self.view.costItem, {
            width = "30",
            height = "30",
            x = "0",
            y = "0",
            z = "0",
            --mscale = 30 .. "," .. 30 .. "," .. 30,
            mfixsize="30,30",
            itemid = costCfgId,
            tips = "1",
            noclip = "1",
            bgtype = "0",
        })
    else
        self.item_model = GUI:Item_Create(self.view.costItem, {
            width = "30",
            height = "30",
            x = "0",
            y = "0",
            z = "0",
            --mscale = 630 .. "," .. 630 .. "," .. 630,
            mfixsize="30,30",
            itemid = costCfgId,
            tips = "1",
            noclip = "1",
            bgtype = "0",
        })
    end

end

function this:Close()
    self.item_model = nil
end

return this
