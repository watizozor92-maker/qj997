---@class KLChangeAttrSchemePanel:UIKmlLuaPanelBase
---@field view KLChangeAttrSchemePanelView
local KLChangeAttrSchemePanel = class(UIKmlLuaPanelBase)
local this =KLChangeAttrSchemePanel
---创建时调用一次
function this:Init()
    self.isShow = false
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.closeBtn, self, self.CloseSelf)
    GUI:AddOnClickEvent(self.view.edit_btn, self, self.edit_btn)
    GUI:AddOnClickEvent(self.view.btn_first_scheme, self, self.btn_first_scheme)
    GUI:AddOnClickEvent(self.view.btn_second_scheme, self, self.btn_second_scheme)
    GUI:AddOnClickEvent(self.view.btn_choice_scheme_show, self, self.btn_choice_scheme_show)
    GUI:AddOnClickEvent(self.view.btn_exchange_point, self, self.btn_exchange_point)
    GUI:AddOnClickEvent(self.view.edit_CloseBtn, self, self.edit_CloseBtn)
    GUI:AddOnClickEvent(self.view.edit_Cancel, self, self.edit_CloseBtn)
    GUI:AddOnClickEvent(self.view.edit_Enter, self, self.edit_Enter)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    self.firstName = "加点方案1"
    self.secondName = "加点方案2"
    if PrivilegeCardManager.freeFirstSwitchInfo then
        if PrivilegeCardManager.freeFirstSwitchInfo.name then
            self.firstName = PrivilegeCardManager.freeFirstSwitchInfo.name
        end
    end
    if PrivilegeCardManager.freeSecondSwitchInfo then
        if PrivilegeCardManager.freeSecondSwitchInfo.name then
            self.secondName = PrivilegeCardManager.freeSecondSwitchInfo.name
        end
    end
    GUI:Button_setTitleText(self.view.btn_first_scheme, self.firstName)
    GUI:Button_setTitleText(self.view.btn_second_scheme, self.secondName)
    self.attrType = PrivilegeCardManager.currentAttrType
    if self.attrType == 1 then
        GUI:Text_setString(self.view.name_input, self.firstName)
    else
        GUI:Text_setString(self.view.name_input, self.secondName)
    end
end

function this:edit_btn()
    if self.isShow then
        self:btn_choice_scheme_show()
    end
    GUI:Text_setString(self.view.attr_Name_Input, "")
    GUI:setVisible(self.view.edit_panel, true)
end

function this:btn_choice_scheme_show()
    if self.isShow then
        GUI:setVisible(self.view.layout_scheme, false)
    else
        GUI:setVisible(self.view.layout_scheme, true)
        if self.attrType == 1 then
            GUI:Button_loadTextureNormal(self.view.btn_first_scheme,"bg_holidayDraw","Atlas/UITeamMainInfoPanel_Out.spriteatlas")
            GUI:Button_loadTextureNormal(self.view.btn_second_scheme,"img_mainRBbg","Atlas/UITeamMainInfoPanel_Out.spriteatlas")
        else
            GUI:Button_loadTextureNormal(self.view.btn_first_scheme,"img_mainRBbg","Atlas/UITeamMainInfoPanel_Out.spriteatlas")
            GUI:Button_loadTextureNormal(self.view.btn_second_scheme,"bg_holidayDraw","Atlas/UITeamMainInfoPanel_Out.spriteatlas")
        end
    end
    self.isShow = not self.isShow
end

function this:btn_first_scheme()
    GUI:Text_setString(self.view.name_input, self.firstName)
    self:btn_choice_scheme_show()
    self.attrType = 1
end

function this:btn_second_scheme()
    GUI:Text_setString(self.view.name_input, self.secondName)
    self:btn_choice_scheme_show()
    self.attrType = 2
end

function this:btn_exchange_point()
    if self.attrType ~= PrivilegeCardManager.currentAttrType then
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_CHANGE_ROLE_ATTR_POINT_PROGRAMME, self.attrType)
        PrivilegeCardManager.attrNeedRefresh = true
    end
    self:CloseSelf()
end

function this:edit_Enter()
    local textName = GUI:GetInputText(self.view.attr_Name_Input)
    if string.isNullOrEmpty(textName) then
        SL:TipMessage( SL:GetConfig('cfg_string',275).text, 1, NoticeType.NoticeMid )--"名称不能为空",
    elseif string.find(textName, "%s") ~= nil then
        SL:TipMessage( SL:GetConfig('cfg_string',276).text,1, NoticeType.NoticeMid )--"名称中不能包含空格", 
    elseif self:GetStrLen(textName) >= 10 then
        SL:TipMessage( SL:GetConfig('cfg_string',277).text,1, NoticeType.NoticeMid )--"名称过长", 
    else
        GUI:SetActive(self.view.edit_panel, false)
        if self.attrType == 1 then
            self.firstName = textName
            GUI:Button_setTitleText(self.view.btn_first_scheme, self.firstName)
        else
            self.secondName = textName
            GUI:Button_setTitleText(self.view.btn_second_scheme, self.secondName)
        end
        GUI:Text_setString(self.view.name_input, textName)
        PrivilegeCardManager.SendMessageSetFreeAttrInfo(self.attrType, nil, textName)
    end
end

function this:edit_CloseBtn()
    GUI:setVisible(self.view.edit_panel, false)
end

function this:CloseSelf()
    GUI:UIPanel_Close(self.filePath)
end

function this:Close()
end

function this:GetStrLen(inputstr)
    if not inputstr or type(inputstr) ~= "string" or #inputstr <= 0 then
        return nil
    end
    local length = 0  -- 字符的个数
    local i = 1
    while true do
        local lengthCount = 1
        local curByte = string.byte(inputstr, i)
        local byteCount = 1
        if curByte > 239 then
            byteCount = 4  -- 4字节字符
            lengthCount = 2
        elseif curByte > 223 then
            lengthCount = 2
            byteCount = 3  -- 汉字
        elseif curByte > 128 then
            byteCount = 2  -- 双字节字符
        else
            byteCount = 1  -- 单字节字符
        end
        i = i + byteCount
        length = length + lengthCount
        if i > #inputstr then
            break
        end
    end
    return length
end

return this
