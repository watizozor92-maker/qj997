---@class KLUnionApplyListPanel:UIKmlLuaPanelBase
---@field view KLUnionApplyListPanelView
local KLUnionApplyListPanel = class(UIKmlLuaPanelBase)
local this =KLUnionApplyListPanel
---创建时调用一次
function this:Init()
    GUI:SetAsLastSibling(self.view.img_bgBg)
    GUI:setContentSize(self.view.AutoPassBackground, 23, 23)
    GUI:setContentSize(self.view.AutoPassCheckmark, 25, 25)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    self:RefreshUnionApplicationList()
    self:SetMemberList()
end


---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn_close, self, self.btn_close)
    GUI:AddOnClickEvent(self.view.btn_allAgree, self, self.btn_allAgree)
    GUI:AddOnClickEvent(self.view.btn_allRefuse, self, self.btn_allRefuse)
    GUI:AddOnClickEvent(self.view.mask, self, self.mask)
    GUI:SetToggleOnValueChange(self.view.AutoPass, self, self.AutoPassChange)
    SL:RegisterLUAEvent(LUA_EVENT_UNION_APPLICATION_LIST, self.UnionApplicationList, self)
end

function this:mask()
    self:btn_close()
end

function this:UnionApplicationList()
    self:SetMemberList()
end

function this:AutoPassChange(_,_, systemData)
    if systemData[1] then
        self.AutoPass = 1
    else
        self.AutoPass = 0
    end
end

function this:btn_close()
    SL.Union:ReqUnionSettingMessage(self.AutoPass,GUI:Text_getString(self.view.InputField_level), 0)
    GUI:UIPanel_Close("dev/ui/Union/Panel/KLUnionApplyList/KLUnionApplyListPanel")
end

function this:btn_allAgree()
    if InfoManager.loranSiegeInfo:GetIsOpen() then
        SL:TipMessage(SL:GetConfig("cfg_string",16005).text ,1, NoticeType.NoticeMid)
        return
    end
    SL.Union:ReqAllAgreeMessage()
end

function this:btn_allRefuse()
    SL.Union:ReqAllRejectMessage()
end

function this:Close()
end

-- 刷新
function this:RefreshUnionApplicationList()
    --[[	self.AutoPass = PlayerPrefs.GetInt(RoleManager.meData.id.."unionAutoPass",0)
        self.InputField_level = PlayerPrefs.GetInt(RoleManager.meData.id.."unionInputField_level",0)]]
    local applyListInfo = SL.Union:GetApplyListInfo()
    if applyListInfo then
        --if unionInfo.ServerApplyListInfo.unionSetting.autoAccept ~= 0 then
        self.AutoPass = applyListInfo.unionSetting.autoAccept
        --end
        --if unionInfo.ServerApplyListInfo.unionSetting.needLevel ~= 0 then
        self.InputField_level = applyListInfo.unionSetting.needLevel
    else
        self.AutoPass = 1
        self.InputField_level = 0
        self.InputFieldMark= 0
    end

    if self.AutoPass == 1 then
        GUI:Toggle_setIsOn(self.view.AutoPass, true)
    else
        GUI:Toggle_setIsOn(self.view.AutoPass, false)
    end
    GUI:Text_setString(self.view.InputField_level, tostring(self.InputField_level))
end

function this:SetMemberList()
    GUI:DataListInitData(self.view.union_data_list, function()
        return table.count(SL.Union:GetApplyListInfo().applyInfo)
    end,
            function()

            end,
            function()

            end,
            function(realIndex)
                local unionInfo = SL.Union:GetApplyListInfo().applyInfo[realIndex + 1]
                local name = GUI:GetChildControl(self.view.union_data_list, realIndex, 'name')
                local level = GUI:GetChildControl(self.view.union_data_list, realIndex, 'level')
                local career = GUI:GetChildControl(self.view.union_data_list, realIndex, 'career')
                GUI:Text_setString(name, unionInfo.name)
                GUI:Text_setString(level, tostring(unionInfo.level))
                if unionInfo.career == 1 then
                    GUI:Text_setString(career, "战士")
                elseif unionInfo.career == 2 then
                    GUI:Text_setString(career, "法师")
                elseif unionInfo.career == 3 then
                    GUI:Text_setString(career, "弓箭手")
                end

                local refuse_btn = GUI:GetChildControl(self.view.union_data_list, realIndex, 'refuse_btn')
                local agree_btn = GUI:GetChildControl(self.view.union_data_list, realIndex, 'agree_btn')
                GUI:AddOnClickEvent(refuse_btn, self, self.refuse_btn, {playerInfo = unionInfo})
                GUI:AddOnClickEvent(agree_btn, self, self.agree_btn, {playerInfo = unionInfo})
            end)

    GUI:DataListUpdateData(self.view.union_data_list)
    GUI:setVisible(self.view.Text_NoApplyTips, table.count(SL.Union:GetApplyListInfo().applyInfo) == 0)
end

function this:refuse_btn(_, eventData)
    local playerInfo = eventData.playerInfo
    SL.Union:ReqAgreeUnionApplyMessage(playerInfo.rid,0)
end

function this:agree_btn(_, eventData)
    if InfoManager.loranSiegeInfo:GetIsOpen() then
        SL:TipMessage(SL:GetConfig("cfg_string",16005).text ,1, NoticeType.NoticeMid)
        return
    end
    local playerInfo = eventData.playerInfo
    SL.Union:ReqAgreeUnionApplyMessage(playerInfo.rid,1)
end

return this
