---@class KLSiegeRewardPanel:UIKmlLuaPanelBase
---@field view KLSiegeRewardPanelView
---@field Reward1DataList table<number,{id:number,count:number}>
---@field Reward2DataList table<number,{id:number,count:number}>
---@field Reward3DataList table<number,{id:number,count:number}>
---@field Reward4DataList table<number,{rank:number,rewardList:table<number,{id:number,count:number}>}>
local KLSiegeRewardPanel = class(UIKmlLuaPanelBase)
local this =KLSiegeRewardPanel
function this:AsyncLoadUI()
end
---创建时调用一次
function this:Init()
    self:InitText()
    GUI:DataListInitData(self.view.Reward1DataList,function()
        return self:GetReward1DataListItemCountFunc()
    end,function(realIndex)
        return self:GetReward1DataListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:GetReward1DataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:GetReward1DataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    
    GUI:DataListInitData(self.view.Reward2DataList,function()
        return self:GetReward2DataListItemCountFunc()
    end,function(realIndex)
        return self:GetReward2DataListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:GetReward2DataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:GetReward2DataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    
    GUI:DataListInitData(self.view.Reward3DataList,function()
        return self:GetReward3DataListItemCountFunc()
    end,function(realIndex)
        return self:GetReward3DataListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:GetReward3DataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:GetReward3DataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    
    GUI:DataListInitData(self.view.Reward4DataList,function()
        return self:GetReward4DataListItemCountFunc()
    end,function(realIndex)
        return self:GetReward4DataListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:GetReward4DataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:GetReward4DataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    self:GetAllRewardData()
    self:GetPersonalRewardData()
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn_close,self,self.BtnCloseClick)
end
function this:BtnCloseClick()
    GUI:UIPanel_Close("dev/outui/LoranSiege/Panel/KLSiegeReward/KLSiegeRewardPanel")
    GUI:UIPanel_Open("dev/outui/LoranSiege/Panel/KLSiegeMain/KLSiegeMainPanel")
end
---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
    SL.HideMainPanel()
end

function this:Close()
    for i, v in pairs(self.Reward4ItemsList) do
        if v then
            GUI:UIPanel_Close(nil,v)
        end
    end
    self.Reward4ItemsList = {}
end

---初始化文本信息
function this:InitText()
    GUI:Text_setString(self.view.LeftInfoText1,SL:GetConfig("cfg_rule_text",16001).location)
    GUI:Text_setString(self.view.LeftInfoText2,SL:GetConfig("cfg_rule_text",16002).location)
    GUI:Text_setString(self.view.LeftInfoText3,SL:GetConfig("cfg_rule_text",16003).location)
    GUI:Text_setString(self.view.LeftInfoText4,SL:GetConfig("cfg_rule_text",16004).location)
end

---获取所有奖励数据
function this:GetAllRewardData()
    self.Reward1DataList = {}
    self:GetRewardData(16001015,self.Reward1DataList)
    self.Reward2DataList = {}
    self:GetRewardData(16001016,self.Reward2DataList)
    self.Reward3DataList = {}
    self:GetRewardData(16001017,self.Reward3DataList)
    GUI:DataListUpdateData(self.view.Reward1DataList,true)
    GUI:DataListUpdateData(self.view.Reward2DataList,true)
    GUI:DataListUpdateData(self.view.Reward3DataList,true)
end

---获取单个奖励信息
---@param id number @cfg_repGlobal表id
---@param list table @存储的列表
function this:GetRewardData(id,list)
    ---@type cfg_repGlobal_column
    local cfg1 = SL:GetConfig("cfg_repGlobal",id)
    local strList = string.split(cfg1.value,"|")
    for i, v in ipairs(strList) do
        local data = string.split(v,"#")
        local itemID = tonumber(data[1])
        local itemCount = tonumber(data[2])
        table.insert(list,{id = itemID,count = itemCount})
    end
end

---获取个人奖励信息
function this:GetPersonalRewardData()
    self.Reward4DataList = {}

    ---@type cfg_repGlobal_column
    local cfg1 = SL:GetConfig("cfg_repGlobal",16001014)
    local strList = string.split(cfg1.value,"|")

    for i, v in ipairs(strList) do
        local str2List = string.split(v,"&")
        local rank = ""
        local rewardList = {}
        for z, a in ipairs(str2List) do
            local str3List = string.split(a,"#")
            if z == 1 then
                --名次相同显示一个
                if str3List[1] == str3List[2] then
                    rank = "第"..str3List[1].."名"
                else
                    rank = "第"..str3List[1].."名~".."第"..str3List[2].."名"
                end
            else
                table.insert(rewardList,{id = tonumber(str3List[1]),count = tonumber(str3List[2])})
            end
        end
        table.insert(self.Reward4DataList,{rank = rank,rewardList = rewardList})
    end
    GUI:DataListUpdateData(self.view.Reward4DataList,true)

end

-------------------胜利方战盟盟主奖励---------------------------

function this:GetReward1DataListItemCountFunc()
    return #self.Reward1DataList
end

function this:GetReward1DataListItemGetFunc(realIndex)
end

function this:GetReward1DataListItemInitFunc(realIndex, kmlcontrol)

end

function this:GetReward1DataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.Reward1DataList[realIndex + 1]

    local item = GUI:GetChildControl(self.view.Reward1DataList,realIndex,'Reward1_Item')
    GUI:Item_UpdataData(item, {
        itemid = data.id,
        itemcustomcount = data.count,
    })
    GUI:AddOnClickEvent(item, self, function()
        SL:OpenTips(nil, data.id)
    end)
end
--------------------------------------------

-------------------胜利方战盟成员奖励---------------------------

function this:GetReward2DataListItemCountFunc()
    return #self.Reward2DataList
end

function this:GetReward2DataListItemGetFunc(realIndex)
end

function this:GetReward2DataListItemInitFunc(realIndex, kmlcontrol)

end

function this:GetReward2DataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.Reward2DataList[realIndex + 1]

    local item = GUI:GetChildControl(self.view.Reward2DataList,realIndex,'Reward2_Item')
    GUI:Item_UpdataData(item, {
        itemid = data.id,
        itemcustomcount = data.count,
    })
    GUI:AddOnClickEvent(item, self, function()
        SL:OpenTips(nil, data.id)
    end)
end
--------------------------------------------

-------------------失败方战盟成员奖励---------------------------

function this:GetReward3DataListItemCountFunc()
    return #self.Reward3DataList
end

function this:GetReward3DataListItemGetFunc(realIndex)
end

function this:GetReward3DataListItemInitFunc(realIndex, kmlcontrol)

end

function this:GetReward3DataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.Reward3DataList[realIndex + 1]

    local item = GUI:GetChildControl(self.view.Reward3DataList,realIndex,'Reward3_Item')
    GUI:Item_UpdataData(item, {
        itemid = data.id,
        itemcustomcount = data.count,
    })
    GUI:AddOnClickEvent(item, self, function()
        SL:OpenTips(nil, data.id)
    end)
end
--------------------------------------------

-------------------个人奖励预览---------------------------

function this:GetReward4DataListItemCountFunc()
    return #self.Reward4DataList
end

function this:GetReward4DataListItemGetFunc(realIndex)
    ---@type KLPersonalRewardItem
    local item = GUI:UIPanel_Open("dev/outui/LoranSiege/Item/KLPersonalReward/KLPersonalRewardItem", self.view.Reward4DataList, self, nil, true, function(panel)
        local data = self.Reward4DataList[realIndex + 1]
        self.Reward4ItemsList[panel.view.root] = panel
        panel:SetRankTextAndReward(data)
    end)
    if not self.Reward4ItemsList then
        ---@type table<KingML.KmlControl,KLPersonalRewardItem>
        self.Reward4ItemsList = {}
    end
    local kmlCtrl = item.view.root
    return kmlCtrl
end

function this:GetReward4DataListItemInitFunc(realIndex, kmlcontrol)

end

function this:GetReward4DataListItemUpdateFunc(realIndex, kmlcontrol)
    if self.Reward4ItemsList[kmlcontrol] then
        local data = self.Reward4DataList[realIndex + 1]
        local item = self.Reward4ItemsList[kmlcontrol]
        item:SetRankTextAndReward(data)
    end
end
--------------------------------------------


return this