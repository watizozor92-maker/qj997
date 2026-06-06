---@class KLCommonGainItemShowPanel:UIKmlLuaPanelBase
---@field view KLCommonGainItemShowPanelView
local KLCommonGainItemShowPanel = class(UIKmlLuaPanelBase)
local this = KLCommonGainItemShowPanel
function this:AsyncLoadUI()
end
---创建时调用一次
function this:Init()
    self.closeTime = 3
    GUI:DataListInitData(self.view.rewards, function()
        return table.count(self.info)
    end, function(realIndex)
        return self:DataListItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:DataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:DataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    if self.args and self.args.reward then
        self.info = self.args.reward
        if table.count(self.info) > 6 then
            local h=  math.ceil(table.count(self.info)/6) * 70 +  math.floor(table.count(self.info)/6) * 10
            GUI:setContentSize(self.view.scrollviewList,900,h)
        end
        if self.args.str then
            GUI:Text_setString(self.view.showTxt, self.args.str)
        else
            GUI:Text_setString(self.view.showTxt, "")
        end
        GUI:DataListUpdateData(self.view.rewards)
        --到达时间后关闭
       self.timer=SL:Schedule(self.timer,self.closeTime, 1,1,function()
            self:ClosePanel()
        end)
    end
end
function this:DataListItemGetFunc(realIndex)
end
function this:DataListItemInitFunc(realIndex, kmlcontrol)
end
function this:DataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.info[realIndex + 1]
    local item = GUI:GetChildControl(self.view.rewards, realIndex, 'item')
    local count = data.count
    if type(data.count) == "number" then
        count = math.floor(data.count)
    end
    
    GUI:Item_UpdataData(item, {
        itemid = data.cfgId,
        itemcustomcount = count,
    })
    GUI:AddOnClickEvent(item, self, function()
        SL:OpenTips("", tonumber(data.cfgId))
    end)
end
---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.CloseBG, self, self.ClosePanel)
end

function this:ClosePanel()
    GUI:UIPanel_Close("dev/outui/OperateActivity/Panel/KLCommonGainItemShow/KLCommonGainItemShowPanel")
end

function this:SetTitle(type, atlas, src)
    if atlas ~= nil and src ~= nil then
        GUI:Image_loadTexture(self.view.title, src, atlas)
    elseif type == 0 then
        GUI:Image_loadTexture(self.view.title, "title_Reward", "Atlas/UIMisc.spriteatlas")
    else
        GUI:Image_loadTexture(self.view.title, "title_TaskReward", "Atlas/UIMisc.spriteatlas")
    end

end

function this:Close()
    if self.timer then
        SL:UnSchedule(self.timer)
    end
    self.timer = nil
    self.info = {}
end

return this