---@class KLMasterTalentContentItem:UIKmlLuaPanelBase
---@field view KLMasterTalentContentItemView
local KLMasterTalentContentItem = class(UIKmlLuaPanelBase)
local this = KLMasterTalentContentItem

---创建时调用一次
function this:Init()
    self.iconItem = {
        [1] = {},
        [2] = {},
        [3] = {},
    }

    self.serieslist = {
        [1] = {},
        [2] = {},
        [3] = {},
    }
    local series1Info = { index = 1, series = self.view.serieslist1 }
    local series2Info = { index = 2, series = self.view.serieslist2 }
    local series3Info = { index = 3, series = self.view.serieslist3 }
    GUI:DataListInitData(self.view.serieslist1, function()
        return #self.serieslist[1]
    end, function(realIndex)
        return self:ItemGetFunc(realIndex, series1Info)
    end, function(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:ItemUpdateFunc(realIndex, kmlcontrol, series1Info)
    end)


    GUI:DataListInitData(self.view.serieslist2, function()
        return #self.serieslist[2]
    end, function(realIndex)
        return self:ItemGetFunc(realIndex, series2Info)
    end, function(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:ItemUpdateFunc(realIndex, kmlcontrol, series2Info)
    end)

    GUI:DataListInitData(self.view.serieslist3, function()
        return #self.serieslist[3]
    end, function(realIndex)
        return self:ItemGetFunc(realIndex, series3Info)
    end, function(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:ItemUpdateFunc(realIndex, kmlcontrol, series3Info)
    end)
end

---注册UI事件和服务器消息
function this:RegistEvents()
end

---界面显示时调用一次
function this:Show()
end

---创建或者刷新界面数据时调用
function this:Refresh()
end

---@param data table @series -> cfg_master_protalent_column[]
function this:UpdateData(data, height, maxTier, lineInfo)
    if not data then return end
    self.serieslist[1] = data[1] or {}
    self.serieslist[2] = data[2] or {}
    self.serieslist[3] = data[3] or {}
    self.maxTier = maxTier
    table.sort(self.serieslist[1], function(a, b)
        return a.cfg.place < b.cfg.place
    end)
    table.sort(self.serieslist[2], function(a, b)
        return a.cfg.place < b.cfg.place
    end)
    table.sort(self.serieslist[3], function(a, b)
        return a.cfg.place < b.cfg.place
    end)
    local cfg = self.serieslist[1][1].cfg
    self.tier = cfg.tier
    local str = SL:NumberToChinese(self.tier)
    GUI:Text_setString(self.view.tier, string.format("第%s阶梯", str))
    if self.tier < maxTier then
        local str = SL:NumberToChinese(self.tier + 1)
        local condition = InfoManager.masterTalentInfo:GetUnLockSeriesCSondition(self.tier + 1)
        GUI:Text_setString(self.view.tierInfo, string.format("(当前阶梯加点数大于%d可解锁第%s阶梯)", condition, str))
        GUI:setVisible(self.view.tierInfo, true)
    else
        -- GUI:Text_setString(self.view.tierInfo, "")
        GUI:setVisible(self.view.tierInfo, false)
    end
    GUI:DataListUpdateData(self.view.serieslist1)
    GUI:DataListUpdateData(self.view.serieslist2)
    GUI:DataListUpdateData(self.view.serieslist3)

    if height then
        self:SetSize(height)
    end

    if not table.isNullOrEmpty(lineInfo) then
        if lineInfo.line1 == nil then
            lineInfo.line1 = true
        elseif lineInfo.line2 == nil then
            lineInfo.line2 = true
        end
        GUI:setVisible(self.view.line1, lineInfo.line1)
        GUI:setVisible(self.view.line2, lineInfo.line2)
    end
end

function this:RefreshPanel()
    self:UpdateData(self.serieslist, nil, self.maxTier)
end

function this:SetSize(height)
    GUI:setContentSize(self.view.gridview1, 230, height)
    GUI:setContentSize(self.view.gridview6, 230, height)
    GUI:setContentSize(self.view.gridview9, 230, height)
    GUI:setContentSize(self.view.img2, 257, height + 20)
    GUI:setContentSize(self.view.img3, 257, height + 20)
    GUI:setContentSize(self.view.img4, 257, height + 20)
    GUI:setContentSize(self.view.line1, 14, (height + 20) / 2 - 35)
    GUI:setContentSize(self.view.line2, 14, (height + 20) / 2 - 35)
    GUI:setContentSize(self.view.layout1, 970, height + 20)
end

function this:ItemGetFunc(realIndex, seriesInfo)
    ---@type KLMasterTalentIconItem
    local item = GUI:UIPanel_Open("dev/outui/MasterTalent/Item/KLMasterTalentIcon/KLMasterTalentIconItem",
        seriesInfo.series, self, _, true, function(item)
            local kmlcontrol = item.view.root
            if self.iconItem[seriesInfo.index][kmlcontrol] == false then
                self.iconItem[seriesInfo.index][kmlcontrol] = item
                self:ItemUpdateFunc(realIndex, item.view.root, seriesInfo)
            else
                self.iconItem[seriesInfo.index][kmlcontrol] = item
            end
        end)
    return item.view.root
end

function this:ItemUpdateFunc(realIndex, kmlcontrol, seriesInfo)
    if not self.iconItem[seriesInfo.index][kmlcontrol] then
        self.iconItem[seriesInfo.index][kmlcontrol] = false
        return
    end
    local data = self.serieslist[seriesInfo.index][realIndex + 1]

    self.iconItem[seriesInfo.index][kmlcontrol]:UpdateData(data)
end

function this:Hide()
end

function this:Close()
end

return this
