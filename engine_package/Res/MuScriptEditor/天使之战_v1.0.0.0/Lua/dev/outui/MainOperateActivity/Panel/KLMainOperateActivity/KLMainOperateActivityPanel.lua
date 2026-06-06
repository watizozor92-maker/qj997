---@class KLMainOperateActivityPanel:UIKmlLuaPanelBase
---@field view KLMainOperateActivityPanelView
local KLMainOperateActivityPanel = class(UIKmlLuaPanelBase)
local this =KLMainOperateActivityPanel
function this:AsyncLoadUI()
end
---创建时调用一次
function this:Init()
    self.togDataList = {}
    GUI:DataListInitData(self.view.TogInfoList, function()
        return self:GetAllTogCount()
    end,function()
    end,function()
    end, function(realIndex)
        self:TogUpdateFun(realIndex)
    end)
end
function this:GetAllTogCount()
    return table.count(self.togDataList)
end
function this:togItemOnTog(control,isOn)
    if GUI:Toggle_getIsOn(control) == "1" or isOn then
        local subArgs={}
        if self.args then
            for key, value in pairs(self.args) do
                subArgs[key]=value
            end
        end
        subArgs.mainOperateData = control.mainOperateData
        subArgs.OperateActivityInfo = InfoManager.mainOperateActivityInfo
        subArgs.showType = EOperateActivityType.Cross
        GUI:UIPanel_Open(control.mainOperateData.subUIRoute,self.view.subParent,self,subArgs)
        self:OnClickMainOperateMask()
    else
        GUI:UIPanel_Close(control.mainOperateData.subUIRoute)
    end
end
function this:TogUpdateFun(realIndex)
    local data = self.togDataList[realIndex + 1]
    local index = realIndex+1
    local togItem = GUI:GetChildControl(self.view.TogInfoList, realIndex, 'togItem')
    local txt_togName = GUI:GetChildControl(self.view.TogInfoList, realIndex, 'txt_togName')

    togItem.index = index
    togItem.togId = data.id
    togItem.mainOperateData = data
    togItem.redControl = GUI:GetChildControl(self.view.TogInfoList, realIndex, 'img_redPoint')
    self.TogControlList[index] = togItem
    GUI:setName(togItem,data.togName)
    GUI:Text_setString(txt_togName,data.togShowName)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn_close,self,self.OnClickClose)
    SL:RegisterLUAEvent(LUA_EVENT_MAINOPERATEACTIVITY_CHANGE, self.RefreshTogAndTitleShow, self)
end
function this:OnClickClose()
    GUI:UIPanel_Close("dev/outui/MainOperateActivity/Panel/KLMainOperateActivity/KLMainOperateActivityPanel")
    SL.ShowMainPanel()
end
---界面显示时调用一次
function this:Show()
end

function this:RefreshTogState()
    for k, _ in ipairs(self.TogControlList) do
        GUI:SetActive(self.TogControlList[k],true) 
    end
end

function this:RefreshIndex()
    self:RefreshTogAndTitleShow()
    local allClose = true
    local showIndex = 0
    --默认选首个激活页签
    for i, value in ipairs(self.TogControlList) do
        if GUI:getVisible(value) then
            showIndex = i
            allClose = false
            break
        end
    end
    --优选传参页签
    --从外部跳转时,传cfg_sub_OperateActivity表内id
    if self.args and self.args.mainOperateActivityId then
        local tempID = tonumber(self.args.mainOperateActivityId)
        local realWanttedIndex = -1
        for _, value in ipairs(self.TogControlList) do
            if value.togId == tempID then
                realWanttedIndex = value.index
                break
            end
        end
        if realWanttedIndex>0 and GUI:getVisible(self.TogControlList[realWanttedIndex]) then
            showIndex = realWanttedIndex
        else
            SL:TipMessage("界面未激活，无法跳转",1,NoticeType.NoticeMid)
        end
    end
    --关闭所有子界面
    for _, v in pairs(self.TogControlList) do
        GUI:UIPanel_Close(v.mainOperateData.subUIRoute)
    end
    if showIndex > 0 and not allClose then
        GUI:Toggle_setIsOn(self.TogControlList[showIndex],true)
        self:togItemOnTog(self.TogControlList[showIndex],true)
    else
        SL:TipMessage("当前没有开启的活动",1,NoticeType.NoticeMid)
    end
end

--刷新活动标题
function this:RefreshTogAndTitleShow()
	local titleName = "好运假日" --初始标题
    if InfoManager.mainOperateActivityInfo.isOperateActivityMainBtnShow then
        if (not table.isNullOrEmpty(InfoManager.mainOperateActivityInfo.operateMainActivityData)) and
            (not table.isNullOrEmpty(InfoManager.mainOperateActivityInfo.operateMainActivityData.operateActivityAllInfo)) then
            titleName = InfoManager.mainOperateActivityInfo.operateMainActivityData.operateActivityAllInfo.showTitle
        end
    end
    GUI:Text_setString(self.view.txt_title,titleName)
	self:GetAllShowTogData()
end
function this:GetAllShowTogData()
	if InfoManager.mainOperateActivityInfo.isOperateHaveShowPanel then
		local showTbl = InfoManager.mainOperateActivityInfo.operateMainActivityData.allShowPanelData
		if not table.isNullOrEmpty(showTbl) then
			table.sort(showTbl,function(a,b)
				return a.sortId < b.sortId
			end)
            self.togDataList = showTbl
            GUI:DataListUpdateData(self.view.TogInfoList)
		end
	end
end

---创建或者刷新界面数据时调用
function this:Refresh()
    --self:GetAllShowTogData()
    self.TogControlList = {} --所有页签组件表
    SL.HideMainPanel()
    local isDelayCall = false
    if InfoManager.mainOperateActivityInfo.isOperateHaveShowPanel then
        local showTbl = InfoManager.mainOperateActivityInfo.operateMainActivityData.allShowPanelData
        if not table.isNullOrEmpty(showTbl) then
            table.sort(showTbl,function(a,b)
                return a.sortId < b.sortId
            end)
            self.togDataList = showTbl
            isDelayCall = true
            GUI:DataListUpdateData(self.view.TogInfoList,_,function()
                self:InitToggles()
                self:RefreshTogState()
                self:RefreshIndex()
                self:RefreshTogRedPointShow()
            end)
        end
    end
    if not isDelayCall then
        self:InitToggles()
        self:RefreshTogState()
        self:RefreshIndex()
        self:RefreshTogRedPointShow() 
    end
    
end

function this:InitToggles()
    for _ , v in pairs(self.TogControlList) do
        GUI:SetToggleOnValueChange(v, self, self.togItemOnTog)
    end
end

function this:RefreshTogRedPointShow()
    for _, v in pairs(self.TogControlList) do
        if InfoManager.mainOperateActivityInfo.operateMainActivityRedsTbl then
            if GUI:getVisible(v) then
                GUI:SetActive(v.redControl,InfoManager.mainOperateActivityInfo.operateMainActivityRedsTbl[v.mainOperateData.togName])
            end
        end
    end
end

function this:OnClickMainOperateMask()
    GUI:setVisible(self.view.img_mainOperateMask, true)
    if self.timer then
        SL:UnSchedule(self.timer)
    end
    self.timer = SL:ScheduleOnce(0.5, function()
        GUI:setVisible(self.view.img_mainOperateMask, false)
    end)
end
function this:Hide()
end
function this:Close()
    if self.timer then
        SL:UnSchedule(self.timer)
        self.timer = nil
    end
    SL.ShowMainPanel()
end

return this
