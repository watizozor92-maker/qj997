---@class KLQuintonInvasionRankListPanel:UIKmlLuaPanelBase
---@field view KLQuintonInvasionRankListPanelView
local KLQuintonInvasionRankListPanel = class(UIKmlLuaPanelBase)
local this = KLQuintonInvasionRankListPanel
function this:AsyncLoadUI()
end
---创建时调用一次
function this:Init()
    SL:KeepOpenPanel("KLQuintonInvasionRankListPanelKml", true)
    self.rank_all_item = {}
    self.select_type = 0
    self.player_rankList = {}
    self.team_rankList = {}
    local name_str = SL:GetConfig("cfg_repGlobal",21001008).value
    self.name_list = SL:Split(name_str,'#')
    for i=1,#self.name_list,1 do
        self.name_list[i] = self.name_list[i] .. "阵营"
    end
    GUI:DataListInitData(
        self.view.rankList,
        function()
            return self:RankDataListItemCountFunc()
        end,
        function(realIndex)
            return self:RankDataListItemGetFunc(realIndex)
        end,
        function(realIndex, kmlcontrol)
            return self:RankDataListItemInitFunc(realIndex, kmlcontrol)
        end,
        function(realIndex, kmlcontrol)
            return self:RankDataListItemUpdateFunc(realIndex, kmlcontrol)
        end
    )
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.desBtn, self, self.OnCliCkDesBtn)
    --GUI:AddOnClickEvent(self.view.exitBtn, self, self.OnCliCkExitBtn)
    GUI:SetToggleOnValueChange(self.view.personBtn, self, self.PersonBtnOnClick)
    GUI:SetToggleOnValueChange(self.view.teamBtn, self, self.TeamBtnOnClick)

    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_QUIT_DUPLICATE, self.RES_QUIT_SUCCESS, self)
end

function this:SetData(message)
    self.data = message
    self.player_rankList = {} --self.data.rankList
    if self.data.playerRank then
        for i = 1, 3, 1 do
            local id = tostring(i)
            if self.data.playerRank[id] then
                self.data.playerRank[id].rank = i
                table.insert(self.player_rankList, self.data.playerRank[id])
            else
                break
            end
        end
    end
    self.team_rankList = {} --self.data.rankList
    if self.data.factionRank then
        for i = 1, 3, 1 do
            local id = tostring(i)
            if self.data.factionRank[id] then
                self.data.factionRank[id].rank = i
                local name = self.name_list[self.data.factionRank[id].faction]
                self.data.factionRank[id].name = name
                table.insert(self.team_rankList, self.data.factionRank[id])
            else
                break
            end
        end
    end
    self:RefreshRank()
end

function this:OnCliCkDesBtn()
    local data = {
        content = "1、昆顿入侵可通过跨服入口-神之国度-昆顿入侵入口进入地图。\n2.活动开启后玩家进入活动后会被分为猎鹰阵营、巨龙阵营、苍狼阵营3个阵营。\n3、活动开启后每对昆顿造成一定伤害获得1点积分,获得1点积分所需的伤害会随着开服天数提升而提升。\n4、击杀其他玩家可以获得被击杀者20%的积分。\n5.活动结束后阵营积分第一的阵营可获得拍卖分红。\n6、活动结束后根据积分排名发放奖励。\n7、玩家每日只能获得一次积分奖励,获得每日活动排名奖励后再次参加活动将不能获得积分O\n8、排名奖励需积分大于30分才能领取。\n9、昆顿被击杀后还有概率在跨服拍卖行上架稀有坐骑,阵营积分第一阵营中的玩家个人积分超过30可获得拍卖分红。",
        title = "昆顿入侵规则说明"
    }
    GUI:UIPanel_Open("dev/outui/Activity/Panel/KLDescribeDetail/KLDescribeDetailPanel", nil, nil, data)
end

function this:OnCliCkExitBtn()
end

function this:PersonBtnOnClick(_, _, data)
    local isToggle = data[1]
    if isToggle then
        self.select_type = 1
        self:RefreshRank()
    end
end

function this:TeamBtnOnClick(_, _, data)
    local isToggle = data[1]
    if isToggle then
        self.select_type = 0
        self:RefreshRank()
    end
end

function this:RES_QUIT_SUCCESS(id, message)
    ---@type cfg_rep_column
    local tbl = SL:GetConfig("cfg_rep", message, "id")
    if tbl.type == EActivityType.QuintonInvasion then
        InfoManager.copActivityInfo.hideTask = false
        InfoManager.copActivityInfo.hideTeam = false
        GUI:UIPanel_Close("dev/outui/Activity/Panel/KLQuintonInvasionTaskProgress/KLQuintonInvasionTaskProgressPanel")
        GUI:UIPanel_Close("dev/outui/Activity/Panel/KLQuintonInvasionRankList/KLQuintonInvasionRankListPanel")
        
    end
end

---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
    GUI:SetIsOnWithoutNotify(self.view.teamBtn, true)
    self:RefreshRank()
end

function this:RefreshRank()
   

    GUI:DataListUpdateData(self.view.rankList)
end

function this:RankDataListItemCountFunc()
    local rankData = nil
    if self.select_type == 0 then
        rankData = self.team_rankList
    else
        rankData = self.player_rankList
    end
    return #rankData
end

function this:RankDataListItemGetFunc(realIndex)
    local rankData = nil
    if self.select_type == 0 then
        rankData = self.team_rankList
    else
        rankData = self.player_rankList
    end
    local index = realIndex + 1
    local data = rankData[index]
    local item =
        GUI:UIPanel_Open(
        "dev/outui/Activity/Item/KLQuintonInvasionRank/KLQuintonInvasionRankItem",
        self.view.rankList,
        self,
        data,
        true
    )
    self.rank_all_item[item.view.root] = item
    return item.view.root
end

function this:RankDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:RankDataListItemUpdateFunc(realIndex, kmlcontrol)
    local rankData = nil
    if self.select_type == 0 then
        rankData = self.team_rankList
    else
        rankData = self.player_rankList
    end
    local index = realIndex + 1
    local data = rankData[index]
    self.rank_all_item[kmlcontrol]:RefreshItem(data)
end

function this:SetVisible(isVisible)
    GUI:setVisible(self.view.root, isVisible)
end

function this:Close()
    InfoManager.copActivityInfo.hideTeam = false
end

return this
