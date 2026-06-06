---@class KLUIMonthGainItemTipsPanel:UIKmlLuaPanelBase
---@field view KLUIMonthGainItemTipsPanelView
---@field closeTime number @关闭时间
local KLUIMonthGainItemTipsPanel = class(UIKmlLuaPanelBase)
local this = KLUIMonthGainItemTipsPanel

---创建时调用一次
function this:Init()
    self.closeTime = 3
end

---创建或者刷新界面数据时调用
function this:Refresh()
    if not self.info then
        self.info = {}
    end
    --("reward":{"10040001":600},"param":"7001","type":1)
    for k, v in pairs(self.args.reward) do
        local tempTable = {
            cfgId = tonumber(k),
            count = tonumber(v),
        }
        table.insert(self.info, tempTable)
    end
    GUI:Text_setString(self.view.showTxt,self.args.str) 
    GUI:DataListInitData(self.view.rewards, function()
        return table.count(self.info)
    end, function(realIndex)
        return self:DataListItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:DataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:DataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    GUI:DataListUpdateData(self.view.rewards)
    --到达时间后关闭
    SL:ScheduleOnce(self.closeTime,function()
        self:ClosePanle()
    end)
end

function this:DataListItemGetFunc(realIndex)

end

function this:DataListItemInitFunc(realIndex, kmlcontrol)

end

function this:DataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.info[realIndex + 1]
    local item = GUI:GetChildControl(self.view.rewards,realIndex,'item_')
    local count = data.count
    if type(data.count) == "number" then
        count = math.floor(data.count)
    end
    --itemInfo = SL:GetPosItemInfo("bag", data.cfgId)
    --if not itemInfo then
    --    itemInfo = SL:GetPosItemInfo("mail", data.cfgId)
    --end
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
    
    GUI:AddOnClickEvent(self.view.CloseBG,self,self.ClosePanle)
end

function this:ClosePanle()
    GUI:UIPanel_Close("dev/outui/RechargeMonthlycard/Panel/KLUIMonthGainItemTipsPanel/KLUIMonthGainItemTipsPanel")
end

function this:SetTitle(type,atlas,src)
    if atlas ~= nil and src ~= nil    then
        GUI:Image_loadTexture(self.view.title,src,atlas)
    elseif type == 0 then
        GUI:Image_loadTexture(self.view.title,"title_Reward","Atlas/UIMisc.spriteatlas")
    else
        GUI:Image_loadTexture(self.view.title,"title_TaskReward","Atlas/UIMisc.spriteatlas")
    end
    
end

function this:Close()
    self.info = {}
end

return this
