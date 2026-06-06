---@class KLActivityTipItem:UIKmlLuaPanelBase
---@field view KLActivityTipItemView
local KLActivityTipItem = class(UIKmlLuaPanelBase)
local this =KLActivityTipItem
---创建时调用一次
function this:Init()
    
end

---创建或者刷新界面数据时调用
function this:Refresh()
end

function this:UpdateUI(data)
    self.data= data
    local leftTime = math.floor(data.activityEndTime / 1000)
    if leftTime < 0 then
        --self:CloseActivityTimeTip(_,info.activityId)
    end
    local atlas = "Atlas/KmlBubbleTipsUI.spriteatlas"
    local str = "剩余时间"
    local statesrc = "act_open"
    if data.activityType == EListDataType.AnnounceList then
        str = "即将开启"
        statesrc = "act_wait"
    end
    --部分资源没有，默认devil_icon
    local iconsrc = "devil_icon" --info.activityIcon
    GUI:Image_loadTexture(self.view.state,statesrc ,atlas)
    GUI:Image_loadTexture(self.view.icon,iconsrc ,atlas)
    GUI:Text_setString(self.view.name, data.activityName)
    GUI:Text_setString(self.view.destimetxt, str)
    GUI:SetControl_time(self.view.endtime,leftTime)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.activityitem, self, self.OnClickGoButton)
end

function this:OnClickGoButton()
    if self.data.activityType == EListDataType.AnnounceList then
        SL:TipMessage( "活动暂未开启", 1, NoticeType.NoticeMid )
    else
        SL:TipMessage( "对应跳转地图/界面功能暂未完成", 1, NoticeType.NoticeMid )
        --进行中活动根据活动id 跳转不同界面或地图
        if self.data.activityId == EActivityType.UnionAttackCity then

        end
    end
end

function this:Close()
end

return this
