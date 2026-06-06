---@class KLUnionMemberListPanel:UIKmlLuaPanelBase
---@field view KLUnionMemberListPanelView
local KLUnionMemberListPanel = class(UIKmlLuaPanelBase)
local this = KLUnionMemberListPanel
---创建时调用一次
function this:Init()
    -- 是否升序， nil表示不参与
    this.levelUpArrow = nil
    this.jobUpArrow = nil
    this.stateUpArrow = nil

    this.methodCompareList = {
        this.SortByState,
        this.SortByJob,
        this.SortByLevel,
        this.SortByName,
    }
    

end

-- 按照名字升降序
-- 1表示true,-1表示false, 0表示equal
-- 其他类似
function this.SortByName(a, b)
    if a.name < b.name then
        return 1
    end

    return -1
end

function this.SortByLevel(a, b)
    if a.level == b.level then
        return 0
    end

    if this.levelUpArrow == false then
        if a.level < b.level then
            return 1
        else
            return -1
        end
    else
        if a.level <= b.level then
            return -1
        else
            return 1
        end
    end
end

function this.SortByJob(a, b)
    if a.position == b.position then
        return 0
    end

    if this.jobUpArrow == false then
        if a.position < b.position then
            return -1
        else
            return 1
        end
    else
        if a.position <= b.position then
            return 1
        else
            return -1
        end
    end
end

function this.SortByState(a, b)
    if a.onlineState == b.onlineState then

        -- 都是在线， 不比较
        if a.onlineState == 1 then
            return 0

            -- 都是离线， 比较离线时间
        else
            if this.stateUpArrow == false then
                if a.time < b.time then
                    return 1
                else
                    return -1
                end
            else
                if a.time <= b.time then
                    return -1
                else
                    return 1
                end
            end
        end
    end

    if this.stateUpArrow == false then
        if a.onlineState < b.onlineState then
            return 1
        else
            return -1
        end
    else
        if a.onlineState <= b.onlineState then
            return -1
        else
            return 1
        end
    end
end

-- 排序行会成员
function this.SortMemberList()

    -- 先按在线情况， 在按职位，等级，名称排序
    table.sort(SL:UnionInfo_GetUnionMemberList(), function(a, b)
        local num = this.methodCompareList[1](a, b)
        if num == 0 then

            num = this.methodCompareList[2](a, b)

            if num == 0 then

                num = this.methodCompareList[3](a, b)
                if num == 0 then
                    return this.methodCompareList[4](a, b) == 1 and true or false
                else
                    return num == 1 and true or false
                end

            else
                return num == 1 and true or false
            end

        else
            return num == 1 and true or false
        end
    end)

end

---创建或者刷新界面数据时调用
function this:Refresh()
    SL:ReqViewUnionMessage()
    SL:SendLuaNetMsg(LuaMessageIdToSever.GET_DAILY_ACTIVITY_ACTIVITY_LIST)
    SL.HideMainPanel()
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.closeBtn, self, self.closeBtn)
    SL:RegisterLUAEvent(LUA_EVENT_VIEW_UNION, self.ResViewUnionMessage, self)
    SL:RegisterLUAEvent(LUA_EVENT_VIEW_UNION_CHANGE, self.ResViewUnionChangeMessage, self)
    GUI:AddOnClickEvent(self.view.title_level, self, self.title_level)
    GUI:AddOnClickEvent(self.view.title_position, self, self.title_position)
    GUI:AddOnClickEvent(self.view.title_state, self, self.title_state)
    GUI:AddOnClickEvent(self.view.shen_he, self, self.shen_he)
end

---@param message UnionProto.ViewUnionRes
function this:ResViewUnionChangeMessage(_, message)
    self:ResViewUnionMessage(_, message)
end


function this:Setshen_heTipText()
    local unionInfo = SL:UnionInfo_GetUnionMemberList()
    local allnum = table.count(unionInfo)
    local onlinenum = 0
    if unionInfo and allnum > 0 then
        for i, v in pairs(unionInfo) do
            if v.onlineState == 1 then
                onlinenum = onlinenum + 1
            end
        end
    end
    local linestr = onlinenum.."/"..allnum
    local tipdes ="连续".."<color=#00ff00>".."3天".. "</color>".."活跃成员少于".."<color=#00ff00>".."5人".. "</color>".."战盟可能会被解散"
    local linedes = "在线人数".."<color=#00ff00>"..linestr.. "</color>"
    GUI:Text_setString(self.view.tips, tipdes)
    GUI:Text_setString(self.view.on_line_tips, linedes)
end

function this:shen_he()
    GUI:UIPanel_Open("dev/ui/Union/Panel/KLUnionApplyList/KLUnionApplyListPanel")
end

function this:title_position()
    self:ResetArrow()

    if this.jobUpArrow == nil then
        this.jobUpArrow = true
        GUI:setVisible(self.view.position_sort_up_black, true)
    else
        if this.jobUpArrow then
            this.jobUpArrow = false
            GUI:setVisible(self.view.position_sort_down_black, true)
        else
            this.jobUpArrow = true
            GUI:setVisible(self.view.position_sort_up_black, true)
        end
    end

    this.levelUpArrow = nil
    this.stateUpArrow = nil

    this.methodCompareList = {
        this.SortByJob,
        this.SortByState,
        this.SortByLevel,
        this.SortByName,
    }
    this.SortMemberList()
    GUI:DataListUpdateData(self.view.union_data_list)
end

function this:title_state()
    self:ResetArrow()

    if this.stateUpArrow == nil then
        this.stateUpArrow = true
        GUI:setVisible(self.view.state_sort_up_black, true)
    else
        if this.stateUpArrow then
            this.stateUpArrow = false
            GUI:setVisible(self.view.state_sort_down_black, true)
        else
            this.stateUpArrow = true
            GUI:setVisible(self.view.state_sort_up_black, true)
        end
    end

    this.levelUpArrow = nil
    this.jobUpArrow = nil

    this.methodCompareList = {
        this.SortByState,
        this.SortByJob,
        this.SortByLevel,
        this.SortByName,
    }
    this.SortMemberList()
    GUI:DataListUpdateData(self.view.union_data_list)
end

function this:title_level()

    self:ResetArrow()

    if this.levelUpArrow == nil then
        this.levelUpArrow = true
        GUI:setVisible(self.view.level_sort_up_black, true)
    else
        if this.levelUpArrow then
            this.levelUpArrow = false
            GUI:setVisible(self.view.level_sort_down_black, true)
        else
            this.levelUpArrow = true
            GUI:setVisible(self.view.level_sort_up_black, true)
        end
    end
    this.stateUpArrow = nil
    this.jobUpArrow = nil

    this.methodCompareList = {
        this.SortByLevel,
        this.SortByState,
        this.SortByJob,
        this.SortByName,
    }
    this.SortMemberList()
    GUI:DataListUpdateData(self.view.union_data_list)

end

-- 重置排序箭头
function this:ResetArrow()
    GUI:setVisible(self.view.level_sort_up_black, false)
    GUI:setVisible(self.view.level_sort_down_black, false)
    GUI:setVisible(self.view.position_sort_down_black, false)
    GUI:setVisible(self.view.position_sort_up_black, false)
    GUI:setVisible(self.view.state_sort_down_black, false)
    GUI:setVisible(self.view.state_sort_up_black, false)
end

function this:closeBtn()
    GUI:UIPanel_Close("dev/ui/Union/Panel/KLUnionMemberList/KLUnionMemberListPanel")
    GUI:UIPanel_Close("dev/ui/Union/Panel/KLUnionToggleList/KLUnionToggleListPanel")
    GUI:UIPanel_Close("dev/ui/Union/Panel/KLUnionInfo/KLUnionInfoPanel")
end

---@param message UnionProto.ViewUnionRes
function this:ResViewUnionMessage(_, message)
    SL:UnionInfo_SetUnionMemberList(message.unionInfo.unionMemberInfo)


    this.SortMemberList()

    GUI:DataListInitData(self.view.union_data_list, function()
        return table.count(SL:UnionInfo_GetUnionMemberList())
    end,
            function()

            end,
            function()

            end,
            function(realIndex)
                local unionInfo = SL:UnionInfo_GetUnionMemberList()[realIndex + 1]
                local name = GUI:GetChildControl(self.view.union_data_list, realIndex, 'name')
                local level = GUI:GetChildControl(self.view.union_data_list, realIndex, 'level')
                local position = GUI:GetChildControl(self.view.union_data_list, realIndex, 'position')
                local state = GUI:GetChildControl(self.view.union_data_list, realIndex, 'state')
                local meId = SL:GetMetaValue(EMetaVarGetKey.UID)
                local isMe = unionInfo.memberId == meId
                GUI:Text_setString(name, unionInfo.name)
                GUI:Text_setTextColor(name, isMe and "#00ff00" or "#ffffff")
                GUI:Text_setString(level, tostring(unionInfo.level))
                GUI:Text_setTextColor(level, isMe and "#00ff00" or "#ffffff")
                GUI:Text_setString(position, EUnionPositionToName[unionInfo.position])
                GUI:Text_setTextColor(position, string.replace(EUnionPositionToColor[unionInfo.position], '0x', '#'))
                if isMe and unionInfo.position ~= 1 and unionInfo.position ~= 2 then
                    GUI:Text_setTextColor(position, "#00ff00")
                end
                if unionInfo.onlineState == 1 then
                    GUI:Text_setString(state, "在线")
                    GUI:Text_setTextColor(state, "#00ff00")
                else
                    -- 离线时间计算
                    local leaveSecond = (Time.GetServerTime() - unionInfo.time)//1000
                    if leaveSecond < 3600 then
                        GUI:Text_setString(state, "离线")
                    elseif leaveSecond < 86400 then
                        GUI:Text_setString(state, string.format("离线%d小时", leaveSecond // 3600))
                    else
                        GUI:Text_setString(state, string.format("离线%d天", leaveSecond // 86400))
                    end

                    GUI:Text_setTextColor(state, "#ff2323")
                end
                
                local btn = GUI:GetChildControl(self.view.union_data_list, realIndex, 'datalist_panel_btn_')
                GUI:AddOnClickEvent(btn, self, self.memberOnClick, {unionInfo = unionInfo})

            end)

    GUI:DataListUpdateData(self.view.union_data_list)

    self:Setshen_heTipText()
    if SL:UnionInfo_IsPowerMan() then
        GUI:setVisible(self.view.shen_he, true)
    else
        GUI:setVisible(self.view.shen_he, false)
    end
end

function this:memberOnClick(_, eventData)
    local unionInfo = eventData.unionInfo
    if unionInfo.memberId == SL:GetMetaValue(EMetaVarGetKey.UID) then
        return
    end
    GUI:UIPanel_Open("dev/ui/Union/Panel/KLUnionMemberInfo/KLUnionMemberInfoPanel", nil, nil, {memberInfo=unionInfo})
end

function this:Close()
end

return this
