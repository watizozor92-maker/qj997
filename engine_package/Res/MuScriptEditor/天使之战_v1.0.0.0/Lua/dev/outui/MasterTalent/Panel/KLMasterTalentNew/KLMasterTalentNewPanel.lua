---@class KLMasterTalentNewPanel:UIKmlLuaPanelBase
---@field view KLMasterTalentNewPanelView
local KLMasterTalentNewPanel = class(UIKmlLuaPanelBase)
local this = KLMasterTalentNewPanel

---创建时调用一次
function this:Init()
    SL:HideMainPanel()
    self.content = {}
    ---@type table<any, KLMasterTalentContentItem>
    self.contentItems = {}
    self.contentHeight = {}
    GUI:DataListInitData(self.view.content_list, function()
        return #self.content
    end, function(realIndex)
        return self:ContentItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:ContentItemUpdateFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:ContentItemSizeFunc(realIndex, kmlcontrol)
    end)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.closeBtn, self, self.ClosePanel)

    SL:RegisterLUAEvent(LUA_EVENT_MASTER_DATA_CHANGE, self.RES_MASTER_INFO, self)
    SL:RegisterLUAEvent(LUA_EVENT_MASTER_SKILL_DATA_CHANGE, self.RES_MASTER_INFO, self)
end

---界面显示时调用一次
function this:Show()
end

---创建或者刷新界面数据时调用
function this:Refresh()
    ---@type cfg_master_protalent_column[]
    self.masterProtalentCfg = SL:GetConfigTable("cfg_master_protalent")
    self:LoadPanel()
end

function this:LoadPanel()
    local data = {}
    -- 获取职业
    local carrer = SL:MeData_GetCareer()
    for k, v in pairs(self.masterProtalentCfg) do
        if table.isNullOrEmpty(v.career) or table.contains(v.career, carrer.baseCareer) or table.contains(v.career, 0) then
            -- 存储方式 tier -> series -> cfg
            if not data[v.tier] then
                data[v.tier] = {}
            end
            data[v.tier][v.series] = data[v.tier][v.series] or {}
            table.insert(data[v.tier][v.series], { cfg = v })
        end
    end

    self.maxTier = 0
    for k, v in pairs(data) do
        self.maxTier = math.max(self.maxTier, k)
    end
    for k, v in pairs(data) do
        local max = math.max(v[1] and #v[1] or 80, v[2] and #v[2] or 80, v[3] and #v[3] or 80)
        local numy = math.ceil(max / 3)
        local height = numy * 80 + (numy - 1) * 20
        self.contentHeight[k] = height > 80 and height or 80
    end
    self.content = data
    GUI:DataListUpdateData(self.view.content_list, false, function()
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_MASTER_INFO)
    end)
end

function this:RES_MASTER_INFO()
    self:RefreshPanel()
end

function this:RefreshPanel()
    for k, v in pairs(self.contentItems) do
        v:RefreshPanel()
    end
    local count = InfoManager.masterTalentInfo:GetNewMasterPoint() or 0
    GUI:Text_setString(self.view.talent_count, string.format("天赋点总数：%d", count))
    local usedCount = InfoManager.masterTalentInfo:GetUsedTalentPoint(1) or 0
    GUI:Text_setString(self.view.info_count1, string.format("勇猛：%d", usedCount))
    usedCount = InfoManager.masterTalentInfo:GetUsedTalentPoint(2) or 0
    GUI:Text_setString(self.view.info_count2, string.format("保护：%d", usedCount))
    usedCount = InfoManager.masterTalentInfo:GetUsedTalentPoint(3) or 0
    GUI:Text_setString(self.view.info_count3, string.format("愤怒：%d", usedCount))
end

function this:ContentItemGetFunc(realIndex)
    ---@type KLMasterTalentContentItem
    local item = GUI:UIPanel_Open("dev/outui/MasterTalent/Item/KLMasterTalentContent/KLMasterTalentContentItem",
        self.view.content_list, self, _, true, function(item)
            local kmlcontrol = item.view.root
            if self.contentItems[kmlcontrol] == false then
                self.contentItems[kmlcontrol] = item
                self:ContentItemUpdateFunc(realIndex, item.view.root)
            else
                self.contentItems[kmlcontrol] = item
            end
        end)
    return item.view.root
end

function this:ContentItemUpdateFunc(realIndex, kmlcontrol)
    if not self.contentItems[kmlcontrol] then
        self.contentItems[kmlcontrol] = false
        return
    end
    local lineInfo = {line1 = true, line2 = true}
    if realIndex == 0 then
        lineInfo.line2 = false
    end
    if realIndex == #self.content - 1 then
        lineInfo.line1 = false
    end
    self.contentItems[kmlcontrol]:UpdateData(self.content[realIndex + 1], self.contentHeight[realIndex + 1], self.maxTier,lineInfo)
end

function this:ContentItemSizeFunc(realIndex, kmlcontrol)
    return Vector2(970, self.contentHeight[realIndex + 1] + 30)
end

function this:ClosePanel()
    GUI:UIPanel_Close("dev/outui/MasterTalent/Panel/KLMasterTalentNew/KLMasterTalentNewPanel")
end

function this:Hide()
end

function this:Close()
    SL:ShowMainPanel()
end

return this
