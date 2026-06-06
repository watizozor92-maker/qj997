---@class KLActivityPreviewPanel:UIKmlLuaPanelBase
---@field view KLActivityPreviewPanelView
---@field bgLessHeight number
---@field bgMoreHeight number
---@field moreHeight number
---@field moreHeight number
---@field all_item KLActivityPreviewItem[]
---@field dataList {leftTime:number,id:number,open:boolean,cfg:cfg_activity_rule_column,isPreview:boolean}
local KLActivityPreviewPanel = class(UIKmlLuaPanelBase)
local this = KLActivityPreviewPanel

---创建时调用一次
function this:Init()
    --self.activityPool = TablePool()
    --self.activityList = {}
    self.all_item = {}
    self.all_item_index = {}
    self.lastCount = 0
    self.listLessHeight = 75
    self.listMoreHeight = 75 * 3
    self.bgLessHeight = 130
    self.bgMoreHeight = 130 + 75 * 2
    self.bgWidth = GUI:GetControlWidth(self.view.bg)
    GUI:DataListInitData(self.view.previewItems, function()
        return self:BtnDataListItemCountFunc()
    end, function(realIndex)
        return self:BtnDataListItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:BtnDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:BtnDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    --self:RefreshTimeText()
    --if not self.timer then
    --    self.timer = Timer.StartLoopForever(1, self.RefreshTimeText, self)
    --end

    --[[    local panel2 = GUI:GetUI("dev/ui/Monster/Panel/KLMonsterMapPoint/KLMonsterMapPointPanel")
        if panel2 then
            panel2:HidePanel()
        end]]
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btnClose, self, self.OnClickClose)

    SL:RegisterLUAEvent(LUA_EVENT_ACTIVITYPREVIEW_CHANGE, self.InitActivityItem, self)
    SL:RegisterLUAEvent(LUA_EVENT_LEVELCHANGE, self.InitActivityItem, self)
end

function this:BtnDataListItemCountFunc()
    return table.count(self.dataList)
end

function this:BtnDataListItemGetFunc(realIndex)
    ---@type KLActivityPreviewItem
    local item = GUI:UIPanel_Open("dev/outui/Activity/Item/KLActivityPreview/KLActivityPreviewItem", self.view.previewItems, self, nil, true)

    self.all_item[item.view.root] = item
    self.all_item_index[realIndex + 1] = item
    return item.view.root
end

function this:BtnDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:BtnDataListItemUpdateFunc(realIndex, kmlcontrol)
    local tempData = {
        index = realIndex + 1,
        data = self.dataList[realIndex + 1]
    }

    self.all_item[kmlcontrol]:InitData(tempData.index, tempData.data)
    self.all_item[kmlcontrol]:RefreshItem()
end

function this:InitActivityItem()
    self.dataList = {}
    local maxCount = 0
    for k, v in pairs(InfoManager.activityPreviewInfo.previewInfo) do
        if SL:MeData_GetLevel() >= v.cfg.level and maxCount < 3 then
            if v.open and SL:MeData_GetLevel() >= v.cfg.level and v.cfg.open == 1 then
                --活动开启中
                if Time.GetServerTime() < v.leftTime then
                    maxCount = maxCount + 1
                    table.insert(self.dataList, v)
                end
            else
                if v.isPreview then
                    maxCount = maxCount + 1
                    table.insert(self.dataList, v)
                end
            end
        end
    end
    local count = table.count(self.dataList)
    if count > 0 then
        GUI:SetActive(self.view.panelRoot, true)
        --[[if table.count(self.dataList) == 1 then
            GUI:SetActive(self.view.title1,true)
            GUI:SetActive(self.view.title2,false)
            GUI:SetActive(self.view.title3,false)
        elseif table.count(self.dataList) == 2 then
            GUI:SetActive(self.view.title1,false)
            GUI:SetActive(self.view.title2,true)
            GUI:SetActive(self.view.title3,false)
        elseif table.count(self.dataList) == 3 then
            GUI:SetActive(self.view.title1,false)
            GUI:SetActive(self.view.title2,false)
            GUI:SetActive(self.view.title3,true)
        end]]
        self:RefreshTimeText()
        if not self.timer then
            --self.timer = Timer.StartLoopForever(1, self.RefreshTimeText, self)
            self.timer = SL:Schedule(self.timer, 0, 1, -1, self.RefreshTimeText, self)
        end
    else
        self:RefreshTimeText()
        GUI:SetActive(self.view.panelRoot, false)
        if self.timer then
            --Timer.Stop(self.timer)
            SL:UnSchedule(self.timer)
            self.timer = nil
        end
    end
    if count < self.lastCount then
        for i = count + 1, self.lastCount do
            if self.all_item_index[i] then
                self.all_item_index[i]:Hide()
            end
        end
        self.lastCount = count
    elseif count > self.lastCount then
        for i = self.lastCount + 1, count do
            if self.all_item_index[i] then
                self.all_item_index[i]:Show()
            end
        end
        self.lastCount = count
    end
end

function this:InitActivityItem_2()
    self:Recycle()
    for k, v in pairs(InfoManager.activityPreviewInfo.previewInfo) do
        ---@type KLActivityPreviewItem
        local item = self.activityPool:Pop()
        if not next(item) then
            item = GUI:UIPanel_Open("dev/outui/Activity/Item/KLActivityPreview/KLActivityPreviewItem", self.view.previewItems, self, nil, true)
        end
        self.activityList[k] = item
        item:InitData(k, v)
        item:RefreshItem()
        if SL:MeData_GetLevel() >= v.cfg.level then
            if v.open and SL:MeData_GetLevel() >= v.cfg.level and v.cfg.open == 1 then
                --活动开启中
                if Time.GetServerTime() < v.leftTime then
                    item:SetActiveUI(true)
                else
                    item:SetActiveUI(false)
                    self.activityPool:Push(item)
                end
            else
                if v.isPreview then
                    item:SetActiveUI(true)
                else
                    item:SetActiveUI(false)
                    self.activityPool:Push(item)
                end
            end
        else
            item:SetActiveUI(false)
            self.activityPool:Push(item)
        end
    end
    self:RefreshTimeText()
    if not self.timer then
        self.timer = SL:Schedule(self.timer, 0, 1, -1, self.RefreshTimeText, self)
    end
end

function this:RefreshTimeText()
    GUI:DataListUpdateData(self.view.previewItems)
end

function this:Recycle()
    for _, v in pairs(self.activityList) do
        v:SetActiveUI(false)
        self.activityPool:Push(v)
    end
end

function this:Close()
    if self.timer then
        SL:UnSchedule(self.timer)
        self.timer = nil
    end
end

return this
