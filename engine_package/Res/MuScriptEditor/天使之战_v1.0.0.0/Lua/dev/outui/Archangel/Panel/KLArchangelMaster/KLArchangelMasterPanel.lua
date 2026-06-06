---@class KLArchangelMasterPanel:UIKmlLuaPanelBase
---@field view KLArchangelMasterPanelView
---@field tbl cfg_equip_angelSuit_column[]
local KLArchangelMasterPanel = class(UIKmlLuaPanelBase)
local this = KLArchangelMasterPanel
function this:AsyncLoadUI()
end

local ActionState = {
    CanAction = enum(1),
    NoAction = enum(2),
    Action = enum(3),
}
---创建时调用一次
function this:Init()

    GUI:DataListInitData(self.view.suit_datalist, function()
        return #self.tbl
    end, function(realIndex)
    end, function(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:SuitUpdateItem(realIndex, kmlcontrol)
    end)
end

function this:SuitUpdateItem(realIndex, kmlcontrol)
    --local att_text = self.view.suit_datalist:GetChildControl(realIndex, "att_text")
    local att_text = GUI:GetChildControl(self.view.suit_datalist, realIndex, "att_text")
    GUI:Text_setString(att_text, "大天使天赋点+" .. tostring(self.tbl[realIndex + 1].Count))
    --local info_text = self.view.suit_datalist:GetChildControl(realIndex, "info_text")
    local info_text = GUI:GetChildControl(self.view.suit_datalist, realIndex, "info_text")
    --local wearcount_text = self.view.suit_datalist:GetChildControl(realIndex, "wearcount_text")
    local wearcount_text = GUI:GetChildControl(self.view.suit_datalist, realIndex, "wearcount_text")
    local text
    local actionCount = self.tbl[realIndex + 1].actionCount and self.tbl[realIndex + 1].actionCount or self.tbl[realIndex + 1].wearingCount
    GUI:Text_setString(info_text, self.tbl[realIndex + 1].text)
    if actionCount == self.tbl[realIndex + 1].wearingCount then
        GUI:Text_setString(wearcount_text, "<color='#00ff00'>(" .. tostring(actionCount) .. "/" .. tostring(self.tbl[realIndex + 1].wearingCount) .. ")</color>")
    else
        GUI:Text_setString(wearcount_text, "<color='#ff2323'>(" .. tostring(actionCount) .. "/" .. tostring(self.tbl[realIndex + 1].wearingCount) .. ")</color>")
    end

    --local ok_btn = self.view.suit_datalist:GetChildControl(realIndex, "ok_btn")
    local ok_btn = GUI:GetChildControl(self.view.suit_datalist, realIndex, "ok_btn")
    --local no_btn = self.view.suit_datalist:GetChildControl(realIndex, "no_btn")
    local no_btn = GUI:GetChildControl(self.view.suit_datalist, realIndex, "no_btn")
    --local done = self.view.suit_datalist:GetChildControl(realIndex, "done")
    local done = GUI:GetChildControl(self.view.suit_datalist, realIndex, "done")

    if self.tbl[realIndex + 1].actionInfo == ActionState.Action then
        -- 已激活
        GUI:setVisible(ok_btn, false)
        GUI:setVisible(no_btn, false)
        GUI:setVisible(done, true)
    elseif self.tbl[realIndex + 1].actionInfo == ActionState.CanAction then
        -- 可激活未激活
        GUI:setVisible(ok_btn, true)
        GUI:setVisible(no_btn, false)
        GUI:setVisible(done, false)
        GUI:AddOnClickEvent(ok_btn, self, function()
            -- 激活协议
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_ACTIVE_ANGEL_TALENT, self.tbl[realIndex + 1].id)
        end)
    else
        -- 不可激活
        GUI:setVisible(ok_btn, false)
        GUI:setVisible(no_btn, true)
        GUI:setVisible(done, false)
    end

end
---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.mask, self, self.CLosePanel)
    GUI:AddOnClickEvent(self.view.close, self, self.CLosePanel)
    SL:RegisterLUAEvent(LUA_ANGEL_TALENT_ACTIVE, self.LUA_ANGEL_TALENT_ACTIVE, self)
end
---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
    SL:RefreshPanelALLRedPoint("KLArchangelTalentPanel")
    self:LoadTable()
    GUI:DataListUpdateData(self.view.suit_datalist)
end

function this:CLosePanel()
    GUI:UIPanel_Close("dev/outui/Archangel/Panel/KLArchangelMaster/KLArchangelMasterPanel")
end

function this:LUA_ANGEL_TALENT_ACTIVE(_, message)
    self:Refresh()
end

function this:CanMasterAction(cfgId)
    local equip = SL:GetWearBarsData(9)
    ---@type cfg_equip_angelSuit_column
    local tbl = SL:GetConfig("cfg_equip_angelSuit", cfgId, "id")
    local wearCount = 0
    ---@type table @<组，装备等级[]>
    local equipGroup = {}
    for i, v in pairs(equip) do
        local suit = SL:GetConfig("cfg_equip_angelGroup", v.cfgId, "id").angelEquipSuit
        if not equipGroup[suit] then
            equipGroup[suit] = {}
        end
        table.insert(equipGroup[suit], InfoManager.archangeEquipInfo:GetEquipLevelInfo(v.id).level)
    end
    --- 给同组的排序
    for _, v in pairs(equipGroup) do
        table.sort(v)
    end

    local angelLv = table.copy(tbl.angelLv)
    --- 循环判断条件
    for i, v in pairs(angelLv) do
        if equipGroup[v[1]] then
            --- 给同组的排序(小到大)

            --- 找到改组中符合条件的最小的移除
            --- 同时符合条件的件数+1
            local count = 0
            local num = 1
            while num <= #equipGroup[v[1]] do
                if equipGroup[v[1]][num] >= v[3] then
                    table.remove(equipGroup[v[1]], num)
                    wearCount = wearCount + 1
                    count = count + 1
                    if count == v[2] then
                        break
                    end
                else
                    num = num + 1
                end
            end
        end
    end
    return wearCount


end

function this:Close()
    InfoManager.archangeEquipInfo:CanMasterAction()
end

function this:LoadTable()
    self.tbl = {}
    local career = SL:GetMetaValue(EMetaVarGetKey.ME_CAREER_TAB_COLUMN)
    ---@type cfg_equip_angelSuit_column[]
    local data = SL:FindConfigs("cfg_equip_angelSuit", "type", 2)
    local action = {}
    local canAction = {}
    local noAction = {}
    for _, v in pairs(data) do
        local actionCount = self:CanMasterAction(v.id)
        if v.career == career.baseCareer then
            if InfoManager.archangeEquipInfo:IsMasterAction(v.id) then
                -- 已激活
                v.actionInfo = ActionState.Action
                table.insert(action, v)
            elseif actionCount == v.wearingCount then
                -- 可激活未激活
                v.actionInfo = ActionState.CanAction
                v.actionCount = actionCount
                table.insert(canAction, v)
            else
                -- 不可激活
                v.actionInfo = ActionState.NoAction
                v.actionCount = actionCount
                table.insert(noAction, v)
            end
        end
    end
    table.sort(action, function(a, b)
        return a.id < b.id
    end)
    table.sort(canAction, function(a, b)
        return a.id < b.id
    end)
    table.sort(noAction, function(a, b)
        return a.id < b.id
    end)
    table.insertArray(self.tbl, canAction)
    table.insertArray(self.tbl, noAction)
    table.insertArray(self.tbl, action)
end

return this
