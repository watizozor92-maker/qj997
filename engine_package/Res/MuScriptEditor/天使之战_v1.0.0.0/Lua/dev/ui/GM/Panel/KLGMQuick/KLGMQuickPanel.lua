---@class KLGMQuickPanel:UIKmlLuaPanelBase
---@field view KLGMQuickPanelView
local KLGMQuickPanel = class(UIKmlLuaPanelBase)
local this =KLGMQuickPanel
local EGMType = 
{
    GMTools = "GM工具",
    --Log = "日志",
    --ShowClickUI = "显示点击UI",
    GMPanel = "GM面板"
}
local gmQuicks = { EGMType.GMPanel }
local gmQuicksClickFunc = {
    --[EGMType.Log]="OnClickGMLog",
    --[EGMType.ShowClickUI]="OnClickShowClickUI",
    [EGMType.GMPanel]="OnClickOpenGMPanel",
}

local localDefaultPrefs = 
{
    [EGMType.GMTools] = '0',
    --[EGMType.Log]='0',
    --[EGMType.ShowClickUI]='0',
}

local localPrefs = {}
local lastPos = string.empty
local lastUpdateTime = 0
local lastPosKey = "上次GM工具拖动位置"
---创建时调用一次
function this:Init()
    GUI:DataListInitData(self.view.datas, function()
        return self:ItemCountFunc()
    end, function(realIndex)
        return self:ItemGetFunc(realIndex)
    end, function(realIndex, kmlCtrl)
        return self:ItemInitFunc(realIndex, kmlCtrl)
    end, function(realIndex, kmlCtrl)
        return self:ItemUpdateFunc(realIndex, kmlCtrl)
    end, function(realIndex)
        return self:ItemSizeGetFunc(realIndex)
    end)

    for k, v in pairs(localDefaultPrefs) do
        if k == EGMType.GMPanel then
        --elseif k== EGMType.Log then
        --    localPrefs[k] = SL.GM:IsAllGMLogOpen() and "1" or "0"
        --elseif k==EGMType.ShowClickUI then
        --    localPrefs[k] = SL.GM:IsShowClickUIOpen() and "1" or "0"
        else
            local vp = SL:GetLocalString(k,v)
            localPrefs[k] = vp 
        end
    end
    GUI:AddOnlyUIDragable(self.view.btnGM)
    lastPos = SL:GetLocalString(lastPosKey,"0#0")
    local strs = string.split(lastPos,'#') 
    if table.count(strs)==2 then 
        GUI:setPosition(self.view.btnGM,tonumber(strs[1]),tonumber(strs[2]))
    end
    self.update = SL:Schedule(self.update,0,0,-1,self.Upadte,self)
end

function this:Upadte()
    if Time.time - lastUpdateTime>1 then
        local x,y = GUI:getPosition(self.view.btnGM)
        SL:SetLocalString(lastPosKey,x..'#'..y)
    end
end

function this:ItemCountFunc()
    return #gmQuicks
end

function this:ItemGetFunc(realIndex)
end

---@param kmlCtrl KingML.KmlControl
function this:ItemInitFunc(realIndex, kmlCtrl)

end

---@param kmlCtrl KingML.KmlControl
function this:ItemUpdateFunc(realIndex, kmlCtrl)
    local gmType = gmQuicks[realIndex+1]
    local clickCallBack = gmQuicksClickFunc[gmType] 
    local root = GUI:GetChildControl(self.view.datas, realIndex, 'btnSubGM')
    GUI:Text_setText(root,gmType)
    GUI:Image_loadTexture(root,localPrefs[gmType]=="1" and "button_interface_window54" or "bg_partnerStar_select",
            "Atlas/Common.spriteatlas")
    GUI:AddOnClickEvent(root,self,self[clickCallBack])
end

--function this:OnClickGMLog()
--    SL.GM:ToggleGMLog()
--    self:ToggleSave(EGMType.Log)
--    self:Refresh()
--end

--function this:OnClickShowClickUI()
--    SL.GM:ToggleShowClickUI()
--    self:ToggleSave(EGMType.ShowClickUI)
--    localPrefs[EGMType.ShowClickUI] = SL.GM:IsShowClickUIOpen() and "1" or "0"
--    self:Refresh()
--end

function this:OnClickOpenGMPanel()
    SL.GM:ToggleOpenGMPanel()
    self:ToggleSave(EGMType.GMPanel)
    self:Refresh()
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnTouchEvent(self.view.btnGM,self,self.OnClickBtnGM)
end

function this:OnClickBtnGM(_,touchType)
    if touchType == EUIEventName.OnBeginDrag then
        self.isDraging = true
    elseif touchType == EUIEventName.OnEndDrag then
        self.isDraging = false
    elseif touchType == EUIEventName.OnPointerUp then
        if not self.isDraging then
            self:ToggleSave(EGMType.GMTools)
            self:Refresh()
        end
    end

end

---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
    GUI:DataListUpdateData(self.view.datas)
    GUI:Image_loadTexture(self.view.btnGM,localPrefs[EGMType.GMTools]=="1" and "button_interface_window54" or "bg_partnerStar_select",
            "Atlas/Common.spriteatlas")
    GUI:SetActive(self.view.btnGMMenu,localPrefs[EGMType.GMTools]=="1") 
end

function this:ToggleSave(gmType)
    if localPrefs[gmType] == "1"  then
        localPrefs[gmType]="0"
    else
        localPrefs[gmType]="1"
    end
    if gmType == EGMType.GMPanel then
        return
    end
    SL:SetLocalString(gmType,localPrefs[gmType])
end

function this:Hide()
    GUI:RemoveOnlyUIDragable(self.view.btnGM)
    if self.update then
        SL:UnSchedule(self.update)
        self.update = nil
    end
end

function this:Close()
end

return this
