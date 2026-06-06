---@class KLGainItemTipsPanel:UIKmlLuaPanelBase
---@field view KLGainItemTipsPanelView
---@field closeTime number @关闭时间
local KLGainItemTipsPanel = class(UIKmlLuaPanelBase)
local this = KLGainItemTipsPanel

---创建时调用一次
function this:Init()
    self.closeTime = 3
end

---创建或者刷新界面数据时调用
function this:Refresh()
    self.closeTime = 3
    if not self.info then
        self.info = {}
    end
    local data2Message = {}
    for k, v in pairs(self.args) do
        if type(v) == "table" then
            data2Message[k] = {
                cfgId = v["cfgId"],
                count = SL:GetSimpleNumber(v["count"] and tonumber(v["count"]) or 1, 0),
                id = v.id,
            }
        else
            data2Message[#data2Message + 1] = {
                cfgId = k,
                count = SL:GetSimpleNumber(tonumber(v), 0),
            }
        end
    end
    for k, v in pairs(data2Message) do
        local tempTable = {
            cfgId = v.cfgId,
            count = v.count,
            id = v.id
        }
        
        table.insert(self.info, tempTable)
    end
    
    
    GUI:DataListInitData(self.view.rewards, function()
        return table.count(self.info)
    end, function(realIndex)
        return self:DataListItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:DataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:DataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    local count = table.count(self.info)
    if count > 5 then
        GUI:SetAttr(self.view.layout,"cella","10")
        local h = GUI:GetHeight(self.view.layout)
        GUI:setContentSize(self.view.layout,70 * count + count * 10,h)
    else
        GUI:SetAttr(self.view.layout,"cella","00")
    end
    
    GUI:ForceRebuildLayoutImmediate(self.view.layout)
    GUI:DataListUpdateData(self.view.rewards,nil,function()
        GUI:SetScrollView_scrollpos(self.view.scrollview,"0")
    end)
    
    --到达时间后关闭
    self.Schedule1 = SL:ScheduleOnce(self.closeTime,function()
        self:ClosePanle()
    end)
end

function this:DataListItemGetFunc(realIndex)

end

function this:DataListItemInitFunc(realIndex, kmlcontrol)

end

function this:DataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.info[realIndex + 1]
    --local item = self.view.rewards:GetChildControl(realIndex, "item_")
    local item = GUI:GetChildControl(self.view.rewards, realIndex, "item_")
    local count = data.count
    if type(data.count) == "number" then
        count = math.floor(data.count)
    end
    local itemInfo = SL:GetPosItemInfo("bag", data.cfgId, data.id)
    if not itemInfo then
        itemInfo = SL:GetPosItemInfo("mail", data.cfgId, data.id)
    end
    
    if not data.cfgId and itemInfo then
        data.cfgId = itemInfo.cfgId
    end
    GUI:Item_UpdataData(item, {
        itemid = data.cfgId,
        itemcustomcount = count,
    })

    GUI:AddOnClickEvent(item, self, function()
        if data.id then
            SL:OpenTips("", tonumber(data.cfgId), tonumber(data.id), 0, itemInfo,nil,nil,function(item)
                self.tipsPanel = item
            end)
        else
            SL:OpenTips("", tonumber(data.cfgId), nil, 0, nil,nil,nil,function(item)
                self.tipsPanel = item
            end)
        end
    end)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    
    GUI:AddOnClickEvent(self.view.CloseBG,self,self.ClosePanle)
end

function this:ClosePanle()
    GUI:UIPanel_Close(nil,self.tipsPanel)
    GUI:UIPanel_Close("dev/ui/Tips/Panel/KLGainItemTips/KLGainItemTipsPanel")
end

function this:SetTitle(type,atlas,src)
    --if atlas ~= nil and src ~= nil    then
    --    GUI:Image_loadTexture(self.view.title,src,atlas)
    --elseif type == 0 then
    --    GUI:Image_loadTexture(self.view.title,"title_Reward","Atlas/UIMisc.spriteatlas")
    --else
    --    GUI:Image_loadTexture(self.view.title,"title_TaskReward","Atlas/UIMisc.spriteatlas")
    --end
    --GUI:SetActive(self.view.title,true)
end

function this:Close()
    if  self.Schedule1 then
        SL:UnSchedule( self.Schedule1)
        self.Schedule1 = nil
    end
    self.info = {}
end

return this
