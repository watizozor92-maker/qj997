---@class KLUIConsumerRankingPanel:UIKmlLuaPanelBase
---@field view KLUIConsumerRankingPanelView
---@field leftCfgDataList table<number,cfg_rank_column>
---@field titleCfgDataList table<number,cfg_rank_column>
---@field allCfgDataList table<number,table<number,table<number,cfg_rank_column>>>
local KLUIConsumerRankingPanel = class(UIKmlLuaPanelBase)
local this =KLUIConsumerRankingPanel
---创建时调用一次
function this:Init()
    if self.args then
        self.mainOperateActivityInfo = self.args.OperateActivityInfo
    end
    self.allCfgDataList = {}
    
    ---排行榜玩家信息
    self.all_rank = {}
    
    ---选择的玩家id
    self.selectPlayerId = ""
    self.reqOtherRoleInfo = true
    GUI:DataListInitData(self.view.PlayerDataList,function()
        return self:PlayerDataListItemCountFunc()
    end,function(realIndex)
        return self:PlayerDataListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:PlayerDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:PlayerDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    self.reward_all_item ={}
    local tip_str = SL:GetConfig("cfg_string",28002).text
    GUI:Text_setString(self.view.RewardText,tip_str)
    
end

---创建或者刷新界面数据时调用
function this:Refresh()
    if self.args and self.args.showType then
        if self.args.showType == 1 then
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_WEEKEN_ACTIVE_INFO, { subType = EOperateActivityActivityType.ConsumerRanking })
        else
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_MAIN_ACTIVE_INFO, { subType = EOperateActivityActivityType.ConsumerRanking })
        end
    end
end

function this:LUA_EVENT_MAINOPERATEACTIVITY_CHANGE()
    self:InitMyRankInfo()
    self:InitRankList()
    GUI:DataListUpdateData(self.view.PlayerDataList)
    local leftTime = self.mainOperateActivityInfo:GetOADJSTimeBySubType(EOperateActivityActivityType.ConsumerRanking)
    GUI:SetControl_time(self.view.refreshTime, leftTime)
end

---初始化个人排名信息
function this:InitMyRankInfo()
    local consumerRank = self.mainOperateActivityInfo.operateMainActivityData.consumerRank
    local rankValue = 0
    local money = 0
    if consumerRank and consumerRank.ownInfo then
        money = consumerRank.ownInfo.money
    end
    if consumerRank and consumerRank.ownInfo and consumerRank.rank then
        local my_rid = SL:GetMetaValue(EMetaVarGetKey.USER_ID)
        for k, v in pairs(consumerRank.rank) do
            if v.rid == my_rid then
                rankValue = tonumber(k)
            end
        end
    end
    
    --local name = SL:GetMetaValue(EMetaVarGetKey.USER_NAME)
    local money_str = "累计充值" .. tostring(money) .. "元"
    local rank_str = "第"..rankValue .. "名"
    GUI:Text_setString(self.view.MyRank_money,money_str)
    if rankValue > 0 then--排行榜有值的情况下
        GUI:Text_setString(self.view.MyRank_RankText,rank_str)
        GUI:setVisible(self.view.MyRank_RankText, true)
        GUI:setVisible(self.view.MyRank_no, false)
    else--排行榜没有值的情况下直接拿自身数据
        local myValue = "无"
        GUI:setVisible(self.view.MyRank_RankText, false)
        GUI:setVisible(self.view.MyRank_no, true)
    end
end



--------------------------------排行榜玩家信息-------------------------------------------------------

-- "consumerRank":{"ownInfo":{"money":48,"name":"艾比盖高尔","rid":"19130817457520640"},
    
-- "rank":{"1":{"money":48,"name":"艾比盖高尔","rid":"19130817457520640"},"2":{"money":6,"name":"黛西格林","rid":"19130817443788800"}}},

function this:InitRankList()
    local consumerRank = self.mainOperateActivityInfo.operateMainActivityData.consumerRank
    self.all_rank = {}
    if consumerRank then
        local rank = consumerRank.rank
        --SL:LogTable(rank,true)
        for i = 1, 10, 1 do
            if rank[tostring(i)] then
                local tab = rank[tostring(i)]
                tab.rank = i
                table.insert(self.all_rank,tab)
            else
                table.insert(self.all_rank,{name="",rid="",money=0,rank = i})
            end
        end
    end
    if table.count(self.all_rank) > 0 and not string.isNullOrEmpty(self.all_rank[1].rid) then
        self.selectPlayerId = self.all_rank[1].rid
        self.selectPlayerName = tostring(self.all_rank[1].name)

    else
        self.selectPlayerId = ""
        self.selectPlayerName = "虚位以待"
    end
    GUI:Text_setString(self.view.user_name,self.selectPlayerName)
    if string.isNullOrEmpty(self.selectPlayerId) or self.selectPlayerId == SL:GetMetaValue(EMetaVarGetKey.USER_ID) then
        GUI:SetActive(self.view.LockButton,false)
    else
        GUI:SetActive(self.view.LockButton,true)
    end
    if string.isNullOrEmpty(self.selectPlayerId) then
        SL:UIModel_Recycle(self.curShowRole)
        GUI:setVisible(self.view.player_block, true)
        GUI:setVisible(self.view.xuwei, true)
    elseif self.selectPlayerId == SL:GetMetaValue(EMetaVarGetKey.USER_ID) then
        GUI:setVisible(self.view.player_block, false)
        self:ShowMyRole()
        GUI:setVisible(self.view.xuwei, false)
    else
        GUI:setVisible(self.view.xuwei, false)
        GUI:setVisible(self.view.player_block, false)
        if self.reqOtherRoleInfo then--避免多次请求
            self.reqOtherRoleInfo = false
            self.otherRoleInfo = nil
            SL.Friend:ReqOtherRoleInfoMessage(tonumber(self.selectPlayerId), 1)
        end
    end
end

function this:PlayerDataListItemCountFunc()
    return #self.all_rank
end

function this:PlayerDataListItemGetFunc(realIndex)
    local data = self.all_rank[realIndex + 1]
    local item = GUI:UIPanel_Open("dev/outui/ConsumerRanking/Item/KLRankItem/KLRankItem", self.view.PlayerDataList, self, {}, true)
    self.reward_all_item[realIndex + 1] = item
    
    return item.view.root
end

function this:PlayerDataListItemInitFunc(realIndex, kmlcontrol)

end

function this:PlayerDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.all_rank[realIndex + 1]
    self.reward_all_item[realIndex + 1]:RefreshItem(data, self.selectPlayerId, self,self.mainOperateActivityInfo)

end



function this:OnClickPlayer(data)
    self.selectPlayerId = data.rid
    self.selectPlayerName = tostring(data.name)
    if self.selectPlayerId == SL:GetMetaValue(EMetaVarGetKey.USER_ID) then
        self:ShowMyRole()
        GUI:SetActive(self.view.LockButton,false)
    else
        GUI:SetActive(self.view.LockButton,true)
        self.otherRoleInfo = nil
        SL.Friend:ReqOtherRoleInfoMessage(tonumber(self.selectPlayerId), 1)
    end
    GUI:Text_setString(self.view.user_name,self.selectPlayerName)
end

---@param data UserProtos.RoleInfo
function this:GetPlayerRoleInfo(data)
    local role_param = { "body", "head", "armor", "hand", "pants", "boot" }
    local wear_list_str = ""
    local model_list_str = ""
    local equipInfo = data.roleInfoExt.equip
    if equipInfo then
        local default_tbl = SL:GetConfig("cfg_model_default", data.career.baseCareer)
        local model_list = {}
        for _, v in pairs(role_param) do
            model_list[v] = default_tbl[v]
        end
        for _, v in ipairs(equipInfo) do
            ---@type cfg_item_column
            local itemInfo = SL:GetConfig("cfg_item", v.cfgId)
            if itemInfo and itemInfo.type == 2 then
                if itemInfo.subType == 1 then
                    if wear_list_str == "" then
                        wear_list_str = "WeaponRspineParent#" .. itemInfo.field[1]
                    else
                        wear_list_str = wear_list_str .. ",WeaponRspineParent#" .. itemInfo.field[1]
                    end
                elseif itemInfo.subType == 2 then
                    if wear_list_str == "" then
                        wear_list_str = "WeaponLspineParent#" .. itemInfo.field[1]
                    else
                        wear_list_str = wear_list_str .. ",WeaponLspineParent#" .. itemInfo.field[1]
                    end
                elseif itemInfo.subType == 3 then
                    if wear_list_str == "" then
                        wear_list_str = "WeaponRspineParent#" .. itemInfo.field[1]
                    else
                        wear_list_str = wear_list_str .. ",WeaponRspineParent#" .. itemInfo.field[1]
                    end
                elseif itemInfo.subType == 13 then
                    if wear_list_str == "" then
                        wear_list_str = "Wing#" .. itemInfo.field[1]
                    else
                        wear_list_str = wear_list_str .. ",Wing#" .. itemInfo.field[1]
                    end
                elseif itemInfo.subType == 30 then
                    if wear_list_str == "" then
                        wear_list_str = "BuffspineParent#" .. itemInfo.field[1]
                    else
                        wear_list_str = wear_list_str .. ",BuffspineParent#" .. itemInfo.field[1]
                    end
                else
                    local point = ""
                    ---@type cfg_model_charactor_column
                    local model_tbl = SL:GetConfig("cfg_model_charactor", itemInfo.field[1])
                    if model_tbl then
                        if model_tbl.part == 23 then
                            point = "body"
                        elseif model_tbl.part == 11 then
                            point = "head"
                        elseif model_tbl.part == 2 then
                            point = "armor"
                        elseif model_tbl.part == 9 then
                            point = "hand"
                        elseif model_tbl.part == 15 then
                            point = "pants"
                        elseif model_tbl.part == 5 then
                            point = "boot"
                        end
                        if point ~= "" then
                            model_list[point] = itemInfo.field[1]
                        end
                    end
                end
            end
        end
        for _, v in pairs(model_list) do
            if model_list_str == "" then
                model_list_str = v
            else
                model_list_str = model_list_str .. "#" .. v
            end
        end
    end
    return model_list_str, wear_list_str
end

---显示自己的模型
function this:ShowMyRole()
    --local role = {roleInfoExt = {equip=RoleManager.meData.equips,mountId = RoleManager.meData.MountId},career = SL:MeData_GetCareer()}
    --local model_list, equip_list = self:GetPlayerRoleInfo(role)
    --self:CreateRole(model_list, equip_list)
    local mountId = InfoManager.mountInfo.ride_mount_id
    if InfoManager.mountInfo.isHasOwnerMount and not InfoManager.mountInfo.isRankShowMount then
        mountId = 0
    end
    local behaviour = EBehaviourType_Stand.Stand
    if self.selectPlayerIndex == 0 and mountId  == 0 then
        behaviour = EBehaviourType_Stand.Sit
    end
    local iconName = mountId == 0 and "S_BG" or "rank_mount_bg"
    local rotation = mountId == 0 and 50 or 10 
    -- GUI:setPositionY(self.view.mountModel, mountId == 0 and -170 or -205)
    -- GUI:setPositionX(self.view.mountModel, mountId == 0 and 0 or 70)
    SL:UIModel_Recycle(self.curShowRole)
    self.curShowRole = SL:UIModel_Create(GUI:GetRectTransform(self.view.mountModel),SL:GetMetaValue(EMetaVarGetKey.UID),SL:MeData_GetCareer(),SL:MeData_GetLevel(),SL:GetMetaValue(EMetaVarGetKey.USER_NAME),mountId,EAction.Stand,behaviour,SL:MeData_GetRoleExtInfo().roleInfoExtData,-50,0,-76,170,0,rotation,0)
end

---@param message UserProtos.OtherRoleInfoRes
function this:ResOtherRoleInfoMessage(id, message)
    if message.type == 1 and self.selectPlayerId == tostring(message.role.rid) then
        self.otherRoleInfo = message
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_OTHER_MOUNT_RANK,message.role.rid)
    end
end

function this:RES_OTHER_MOUNT_RANK(id,message)
    if self.otherRoleInfo then
        local mountId = message
        local behaviour = EBehaviourType_Stand.Stand
        if self.selectPlayerIndex == 0 and mountId == 0 then
            behaviour = EBehaviourType_Stand.Sit
        end
        local iconName = mountId == 0 and "S_BG" or "rank_mount_bg"
        local rotation = mountId == 0 and 50 or 10
        -- GUI:setPositionY(self.view.mountModel, mountId == 0 and -170 or -205)
        -- GUI:setPositionX(self.view.mountModel, mountId == 0 and 0 or 70)
        SL:UIModel_Recycle(self.curShowRole)
        self.curShowRole = SL:UIModel_Create(GUI:GetRectTransform(self.view.mountModel),self.otherRoleInfo.role.rid,self.otherRoleInfo.role.career,self.otherRoleInfo.role.level,self.otherRoleInfo.role.name,mountId,EAction.Stand,behaviour,self.otherRoleInfo.role.roleInfoExt,-50,0,-76,170,0,rotation,0)
    end
end

function this:CreateRole(model_list, equip_list)
    local ani = "idle"
    if self.selectPlayerIndex == 0 then
        ani = "Sit"
    end
    self.view.Role.kmlControl:SetSingleAttr("ani", ani)
    GUI:SetPlayerRoleInfo(self.view.Role, model_list, equip_list,ani)
end

------------------------------------------------------------------------------------------------

---注册UI事件和服务器消息
function this:RegistEvents()
    SL:RegisterLUAEvent(LUA_EVENT_MAINOPERATEACTIVITY_CHANGE, self.LUA_EVENT_MAINOPERATEACTIVITY_CHANGE, self)
    SL:RegisterLUAEvent(LUA_EVENT_MAINOPERATEACTIVITY_SECOND_CHANGE, self.LUA_EVENT_MAINOPERATEACTIVITY_CHANGE, self)
    SL:RegisterLUAEvent(LUA_EVENT_ROLE_INFO, self.ResOtherRoleInfoMessage, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_OTHER_MOUNT_RANK,self.RES_OTHER_MOUNT_RANK,self)

    --GUI:AddOnClickEvent(self.view.CloseButton, self, self.OnClickCloseButton)
    GUI:AddOnClickEvent(self.view.LockButton, self, self.OnClickLockButton)
    --SL:RegisterLuaNetMsg(LuaMessageIdToClient.SEND_RANK_DATA_TO_CLIENT,self.RankDataChange,self)
end

function this:OnClickCloseButton()
    GUI:UIPanel_Close("dev/outui/UIRankList/Panel/KLUIRankList/KLUIConsumerRankingPanel")
    SL.ShowMainPanel()
end

function this:OnClickLockButton()
    if not self.selectPlayerId or self.selectPlayerId == 0 then
        SL:TipMessage(SL:GetConfig('cfg_string',280).text,1,NoticeType.NoticeMid)--"请先选择查看的玩家",
        return
    end
    GUI:SetActive(self.view.closeEquipUIButton,true)
    --角色装备信息
    GUI:UIPanel_Open("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel", _, _, {
        isOther = true,
        rid = tonumber(self.selectPlayerId),
        isHideMainUI = true,
        callBack = function() GUI:SetActive(self.view.closeEquipUIButton,false) end,
        x = 17,
        z=-200
    })
end

---排行榜回包
function this:RankDataChange(_,message)
    self.all_rank = {}
    local count = table.count(message["rankDatas"])
    if count <= 0 then
        GUI:setVisible(self.view.NoRankListImg, true)
        GUI:setVisible(self.view.RankList_Panel, false)
    else
        self:InitMyRankInfo(message["myRankData"])
        GUI:setVisible(self.view.NoRankListImg, false)
        GUI:setVisible(self.view.RankList_Panel, true)
        for i = 1, count do
            local data = message["rankDatas"][tostring(i)]
            if data["actor"]["id"] == SL:GetMetaValue(EMetaVarGetKey.UID) then
                self:InitMyRankInfo(data,i)
            end
            table.insert(self.all_rank,data)
        end
        GUI:DataListUpdateData(self.view.PlayerDataList)
    end
end

function this:Close()
    SL:SendLuaNetMsg(LuaMessageIdToSever.STOP_REFRESH_RANK_DATA)
    SL:UIModel_Recycle(self.curShowRole)
    self.curShowRole = nil
    self.otherRoleInfo = nil
end

return this
