---@class KLUIRankListPanel:UIKmlLuaPanelBase
---@field view KLUIRankListPanelView
---@field leftCfgDataList table<number,cfg_rank_column>
---@field titleCfgDataList table<number,cfg_rank_column>
---@field allCfgDataList table<number,table<number,table<number,cfg_rank_column>>>
local KLUIRankListPanel = class(UIKmlLuaPanelBase)
local this =KLUIRankListPanel
---创建时调用一次
function this:Init()
    ---@type cfg_global_column
    local globalCfg = SL:GetConfig("cfg_global",16)
    GUI:Text_setString(self.view.TimeText,"排行榜每"..globalCfg.value.."分钟刷新一次")

    GUI:setContentSize(self.view.bg,809,430)
    ---左侧复选框cfg数据（根据类型）
    self.leftCfgDataList = {}
    ---顶部选择框cfg数据
    self.titleCfgDataList = {}
    ---所有cfg数据（根据类型归类）
    self.allCfgDataList = {}
    
    ---排行榜玩家信息
    self.playerSeverDataList = {}
    
    ---选择的玩家id
    self.selectPlayerId = 0
    self.worshipList = {}
    
    ---当前选择的跨服榜单
    self.nowRootType = 1
    
    self.nowRootTypeNameStrList = {[1] = "本服榜",[2] = "跨服榜"}
    self.rankType = 0
    
    GUI:DataListInitData(self.view.LeftDataList,function()
        return self:LeftDataListItemCountFunc()
    end,function(realIndex)
        return self:LeftDataListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:LeftDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:LeftDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    
    GUI:DataListInitData(self.view.TitleDatalist,function()
        return self:TitleDatalistItemCountFunc()
    end,function(realIndex)
        return self:TitleDatalistItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:TitleDatalistItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:TitleDatalistItemUpdateFunc(realIndex, kmlcontrol)
    end)
    
    GUI:DataListInitData(self.view.PlayerDataList,function()
        return self:PlayerDataListItemCountFunc()
    end,function(realIndex)
        return self:PlayerDataListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:PlayerDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:PlayerDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    
    self:GetCfgData()
end

---创建或者刷新界面数据时调用
function this:Refresh()
    self:InitMyRankInfo()
end

---根据根排行榜获取左侧按钮
function this:GetRootTypeLeftButton()
    local subTypeList = {}
    self.leftCfgDataList = {}
    --[[for i, roottypeList in ipairs(self.allCfgDataList) do
        table.insert(self.leftCfgDataList,{buttonType = i, toggleType = i .. "_0", name = self.nowRootTypeNameStrList[i]})
        for z, v in pairs(roottypeList) do
            if self.nowRootType == v[1].roottype then
                table.insert(subTypeList,v[1])
            end
        end
        --排个序再把数据添加到左侧按钮列表中
        if #subTypeList > 0 then
            table.sort(subTypeList,function(a, b) 
                return a.type < b.type
            end)
            for z, v in ipairs(subTypeList) do
                v.toggleType = i .. "_" .. v.type
                table.insert(self.leftCfgDataList,v)
            end
            subTypeList = {}
        end
    end]]
    
    local roottypeList = self.allCfgDataList[self.nowRootType]
    for z, v in pairs(roottypeList) do
        table.insert(subTypeList,v[1])
    end
    --排个序再把数据添加到左侧按钮列表中
    if #subTypeList > 0 then
        table.sort(subTypeList,function(a, b)
            return a.type < b.type
        end)
        for z, v in ipairs(subTypeList) do
            v.toggleType = self.nowRootType .. "_" .. v.type
            table.insert(self.leftCfgDataList,v)
        end
    end
end

---获取排行榜表数据
function this:GetCfgData()
    local cfg = SL:GetConfigTable("cfg_rank")
    local nowType = 0
    ---@param v cfg_rank_column
    for i, v in pairs(cfg) do
        if SL:CheckCondition(v.condition) then
            if nowType ~= v.type then
                nowType = v.type
            end
            if not self.allCfgDataList[v.roottype] then
                self.allCfgDataList[v.roottype] = {}
            end
            if not self.allCfgDataList[v.roottype][nowType] then
                self.allCfgDataList[v.roottype][nowType] = {}
            end
            table.insert(self.allCfgDataList[v.roottype][nowType],v)
        end
    end
    
    if #self.allCfgDataList > 0 then
        for i, roottypeList in pairs(self.allCfgDataList) do
            for z, v in pairs(roottypeList) do
                if #v > 0 then
                    table.sort(v,function(a, b)
                        return a.id < b.id
                    end)
                end
            end
        end
    end
    self:GetRootTypeLeftButton()
    GUI:DataListUpdateData(self.view.LeftDataList, nil, function()
        SL:RefreshPanelALLRedPoint("KLUIRankListPanel")
    end)
end

---初始化个人排名信息
function this:InitMyRankInfo(info,rankNo)
    local rankValue = -1
    if rankNo then
        rankValue = rankNo
    end
    local name = SL:GetMetaValue(EMetaVarGetKey.USER_NAME)
    self:SetPlayerName(self.view.MyRank_Name,name)
    if info and info.value then--排行榜有值的情况下
        self:SetRankShowInfo(self.view.MyRank_UnionName, info.value)
    else--排行榜没有值的情况下直接拿自身数据
        if self.rankType == 4 and info and info.score then
            self:SetRankShowInfo(self.view.MyRank_UnionName, info.score)
        else
            local myValue = "无"
            ---1.等级排行榜
            ---2.勇气试炼排行榜
            ---3.战力排行榜
            if self.rankType == 1 then
                myValue = SL:MeData_GetLevel()
            elseif self.rankType == 2 then
            elseif self.rankType == 3 then
                myValue = SL:MeData_GetFightValue()
            end
            self:SetRankShowInfo(self.view.MyRank_UnionName, myValue)
        end
    end
    self:SetPlayerLv(self.view.MyRank_LV, "")
    self:SetRankValueIconOrText(self.view.MyRank_RankText,self.view.MyRank_RankIcon,self.view.MyRank_NoRank,rankValue)
    self:SetPlayerHead(self.view.MyRank_HeadIcon,SL:MeData_GetCareer())
    --self:SetRankBG(self.view.MyRank_BG,rankValue)
end

---设置玩家等级
function this:SetPlayerLv(Control,lv)
    GUI:Text_setString(Control,tostring(lv))
end

function this:SetRankShowInfo(control, value)
    local name = ""
    ---1.等级排行榜
    ---2.勇气试炼排行榜
    ---3.战力排行榜
    if self.rankType == 1 then
        name = "等级："
    elseif self.rankType == 2 then
        name = "层数："
    elseif self.rankType == 3 then
        name = "战力："
        value = SL:GetSimpleNumber(value,1)
    elseif self.rankType == 4 then
        name = "圣杯总评分："
        if value ~= "无" then
            value = SL:GetSimpleNumber(value,1)
        end
    end
    GUI:Text_setString(control, name .. value)
end

---设置玩家名字
function this:SetPlayerName(Control,name)
    GUI:Text_setString(Control,name)
end

---设置玩家战盟名字
function this:SetPlayerUnionName(Control,unionName)
    if not unionName or unionName == "" then
        GUI:Text_setString(Control,"战盟:无")
        return
    end
    GUI:Text_setString(Control,"战盟:"..unionName)
end

---设置玩家头像
---@param career CommonProtos.Career @职业数据
function this:SetPlayerHead(Control,career)
     if career.baseCareer == 1 then
        GUI:Image_loadTexture(Control,"111","Atlas/FG_AttrPanel.spriteatlas")
        --GUI:Image_loadTexture(Control,"Art/AtlasRes/Sprites/FG_AttrPanel/111.png")
        return
    end
     if career.baseCareer == 2 then
        GUI:Image_loadTexture(Control,"122","Atlas/FG_AttrPanel.spriteatlas")
        --GUI:Image_loadTexture(Control,"Art/AtlasRes/Sprites/FG_AttrPanel/122.png")
        return
    end
     if career.baseCareer == 3 then
        GUI:Image_loadTexture(Control,"133","Atlas/FG_AttrPanel.spriteatlas")
        --GUI:Image_loadTexture(Control,"Art/AtlasRes/Sprites/FG_AttrPanel/133.png")
        return
    end
     if career.baseCareer == 4 then
        GUI:Image_loadTexture(Control,"144","Atlas/FG_AttrPanel.spriteatlas")
        --GUI:Image_loadTexture(Control,"Art/AtlasRes/Sprites/FG_AttrPanel/144.png")
        return
    end
    if career.baseCareer == 5 then
        GUI:Image_loadTexture(Control,"155","Atlas/FG_AttrPanel.spriteatlas")
        --GUI:Image_loadTexture(Control,"Art/AtlasRes/Sprites/FG_AttrPanel/155.png")
        return
    end
    if career.baseCareer == 6 then
         GUI:Image_loadTexture(Control,"166","Atlas/FG_AttrPanel.spriteatlas")
        --GUI:Image_loadTexture(Control,"Art/AtlasRes/Sprites/FG_AttrPanel/166.png")
        return
    end
    if career.baseCareer == 7 then
         GUI:Image_loadTexture(Control,"177","Atlas/FG_AttrPanel.spriteatlas")
        --GUI:Image_loadTexture(Control,"Art/AtlasRes/Sprites/FG_AttrPanel/177.png")
        return
    end
    --GUI:Image_loadTexture(Control,"1"..career.baseCareer,"Atlas/MUIcon.spriteatlas")
end

---根据排名显示图片或文字
function this:SetRankValueIconOrText(Control_Text,Control_Image,Control_Image2,rankValue)
    rankValue = tonumber(rankValue)
    GUI:SetActive(Control_Text,false)
    GUI:SetActive(Control_Image,false)
    if Control_Image2 then
        GUI:SetActive(Control_Image2,false)
    end
    if rankValue == -1 then
        if Control_Image2 then
            GUI:SetActive(Control_Image2,true)
        end
        return
    end
    if rankValue > 0 and rankValue < 4 then
        GUI:SetActive(Control_Image,true)
        GUI:Image_loadTexture(Control_Image,"S_icon"..rankValue,"Atlas/UIRankListPanel.spriteatlas")
        return
    end
    GUI:SetActive(Control_Text,true)
    GUI:Text_setString(Control_Text,tostring(rankValue))
end

---根据排名显示背景图
function this:SetRankBG(Control,rankValue)
    rankValue = tonumber(rankValue)
    if rankValue == -1 then
        GUI:Image_loadTexture(Control,"Pic_My","Atlas/UIRankListPanel.spriteatlas")
        return
    end
    if rankValue > 0 and rankValue < 4 then
        GUI:Image_loadTexture(Control,"Pic_"..rankValue,"Atlas/UIRankListPanel.spriteatlas")
        return
    end
    GUI:Image_loadTexture(Control,"Pic_4","Atlas/UIRankListPanel.spriteatlas")
end

--------------------------------左侧复选框（父类）-------------------------------------------------------
function this:LeftDataListItemCountFunc()
    return #self.leftCfgDataList
end

function this:LeftDataListItemGetFunc(realIndex)

end

function this:LeftDataListItemInitFunc(realIndex, kmlcontrol)

end

function this:LeftDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.leftCfgDataList[realIndex + 1]
    local _button = GUI:GetChildControl(self.view.LeftDataList,realIndex,'LeftButton')
    GUI:SetID(_button, "LeftButton_" .. data.toggleType)
    local isShowMainButton = data and data.buttonType
    if isShowMainButton then
        GUI:setContentSize(_button,148,41)
        GUI:Button_loadTextureNormal(_button,"btn_cebian2","Atlas/FG_Common.spriteatlas")
        if self.nowRootType == data.buttonType then
            GUI:Button_loadTextureNormal(_button,"btn_cebian1","Atlas/FG_Common.spriteatlas")
        end
        GUI:AddOnClickEvent(_button,self,self.OnClickRefreshLeftButton,{data = data,button = _button})
        GUI:Button_setTitleText(_button,data.name)
        GUI:Button_setTitleFontSize(_button,18)
    else
        --GUI:setContentSize(_button,112,37)
        GUI:setContentSize(_button,148,41)
        GUI:Button_loadTextureNormal(_button,"btn_cebian2","Atlas/FG_Common.spriteatlas")
        GUI:AddOnClickEvent(_button,self,self.LeftOnClick,{data = data,button = _button})
        if self.rankType == 0 then
            self:LeftOnClick(_button,{data = data,button = _button})
        end
        GUI:Button_setTitleText(_button,data.name)
        GUI:Button_setTitleFontSize(_button,18)
    end
end

---点击选择排行榜
---@param control UIKmlLuaControl
---@param eventData {data:cfg_rank_column,button:UIKmlLuaControl}
function this:LeftOnClick(control, eventData)
    if self.rankType ~= eventData.data.type then
        self.rankType = eventData.data.type
        local isShowMainButton = eventData.data and eventData.data.buttonType
        if self.selectLeftButton1 then
            GUI:Button_loadTextureNormal(self.selectLeftButton1,isShowMainButton and "btn_cebian2" or "btn_cebian2","Atlas/FG_Common.spriteatlas")
            self.selectLeftButton1 = nil
        end
        self.selectLeftButton1 = eventData.button
        self.titleCfgDataList = self.allCfgDataList[eventData.data.roottype][eventData.data.type]
        GUI:Button_loadTextureNormal(self.selectLeftButton1,isShowMainButton and "btn_cebian1" or "btn_cebian1","Atlas/FG_Common.spriteatlas")
        GUI:DataListUpdateData(self.view.TitleDatalist)
    end
end

---点击刷新左侧按钮
---@param control UIKmlLuaControl
function this:OnClickRefreshLeftButton(control, eventData)
    if self.nowRootType ~= eventData.data.buttonType then
        self.nowRootType = eventData.data.buttonType
        self.rankType = 0
        if self.selectLeftButton1 then
            self.selectLeftButton1 = nil
        end
        self:GetRootTypeLeftButton()
        GUI:DataListUpdateData(self.view.LeftDataList)
    end
end

------------------------------------------------------------------------------------------------

--------------------------------顶部复选框（子类）-------------------------------------------------------
function this:TitleDatalistItemCountFunc()
    return #self.titleCfgDataList
end

function this:TitleDatalistItemGetFunc(realIndex)

end

function this:TitleDatalistItemInitFunc(realIndex, kmlcontrol)

end

function this:TitleDatalistItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.titleCfgDataList[realIndex + 1]
    local _toggle = GUI:GetChildControl(self.view.TitleDatalist,realIndex,'TitleToggle')
    local _toggleText = GUI:GetChildControl(self.view.TitleDatalist,realIndex,'TitleToggleText')
    GUI:Text_setString(_toggleText,data.careerName)
    GUI:SetToggleOnValueChange(_toggle,self,self.TitleOnToggle,data)
    if realIndex == 0 then
        if GUI:Toggle_getIsOn(_toggle) == "1" then
            self:TitleOnToggle(_toggle, data)
        else
            GUI:Toggle_setIsOn(_toggle,true)
        end
    end
end

---@param control UIKmlLuaControl
---@param eventData cfg_rank_column
function this:TitleOnToggle(control, eventData)
    if GUI:Toggle_getIsOn(control) == "1"  and self.titleId ~= eventData.id then
        self.titleId = eventData.id
        GUI:Text_setString(self.view.RewardText,eventData.rewardText)
        if eventData.type == 4 then
            ---首次生成列表需要默认选中第一个并且生成玩家模型
            self.reqOtherRoleInfo = true
            ---选中的玩家
            self.selectPlayerIndex = 0
            self.selectPlayerId = 0
            local reqData = {}
            reqData["type"] = eventData.roottype - 1
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_ANGEL_GRAIL_RANKING_INFO,reqData)
        else
            ---首次生成列表需要默认选中第一个并且生成玩家模型
            self.reqOtherRoleInfo = true
            ---选中的玩家
            self.selectPlayerIndex = 0
            self.selectPlayerId = 0
            local reqData = {}
            reqData["career"] = eventData.career
            reqData["type"] = eventData.type
            reqData["roottype"] = eventData.roottype
            SL:SendLuaNetMsg(LuaMessageIdToSever.LOAD_RANK_DATA,reqData)
        end
    end
end

------------------------------------------------------------------------------------------------

--------------------------------排行榜玩家信息-------------------------------------------------------
function this:PlayerDataListItemCountFunc()
    return #self.playerSeverDataList
end

function this:PlayerDataListItemGetFunc(realIndex)
end

function this:PlayerDataListItemInitFunc(realIndex, kmlcontrol)

end

function this:PlayerDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.playerSeverDataList[realIndex + 1]
    local _button = GUI:GetChildControl(self.view.PlayerDataList,realIndex,'PlayerItem_Button',kmlcontrol)
    local _selectImg = GUI:GetChildControl(self.view.PlayerDataList,realIndex,'PlayerItem_Select',kmlcontrol)
    local _bg = GUI:GetChildControl(self.view.PlayerDataList,realIndex,'PlayerItem_BG',kmlcontrol)
    local _headIcon = GUI:GetChildControl(self.view.PlayerDataList,realIndex,'PlayerItem_HeadIcon',kmlcontrol)
    local _rankText = GUI:GetChildControl(self.view.PlayerDataList,realIndex,'PlayerItem_RankText',kmlcontrol)
    local _rankIcon = GUI:GetChildControl(self.view.PlayerDataList,realIndex,'PlayerItem_RankIcon',kmlcontrol)
    local _name = GUI:GetChildControl(self.view.PlayerDataList,realIndex,'PlayerItem_Name',kmlcontrol)
    local _unionName = GUI:GetChildControl(self.view.PlayerDataList,realIndex,'PlayerItem_UnionName',kmlcontrol)
    local _lv = GUI:GetChildControl(self.view.PlayerDataList,realIndex,'PlayerItem_LV',kmlcontrol)
    local _id = data["actor"]["id"]
    local rankNo = realIndex + 1
    self:SetRankBG(_bg,rankNo)
    self:SetPlayerHead(_headIcon,{baseCareer = data["career"]})
    self:SetRankValueIconOrText(_rankText,_rankIcon,nil,rankNo)
    local serverName = ""
    if self.nowRootType == 2 and data["serverid"] then
        serverName = "S"..data["serverid"].."."
    end
    self:SetPlayerName(_name,serverName..data["name"])
    if self.rankType == 2 then
        self:SetPlayerLv(_lv,"")
    else
        self:SetPlayerLv(_lv,data["level"])
    end
    self:SetRankShowInfo(_unionName, data.value)
    GUI:AddOnClickEvent(_button,self,self.OnClickPlayer,{realIndex,data,_selectImg})

    GUI:SetActive(_selectImg,false)
    local isSelect = false
    if self.selectPlayerId == 0 and self.selectPlayerIndex == 0 and self.selectPlayerIndex == realIndex then
        isSelect = true
    end
    if self.selectPlayerId > 0 and self.selectPlayerId == _id then
        isSelect = true
    end
    if isSelect then
        GUI:SetActive(_selectImg,true)
        self.selectItem = _selectImg
        self.selectPlayerId = _id
        self.selectPlayerServerId = data.serverid
        GUI:SetActive(self.view.LockButton,true)
        if self.rankType == 4 then
            GUI:SetActive(self.view.WorshipButton,true)
            GUI:setPositionX(self.view.LockButton,58)
            if (self.worshipList and self.worshipList[tostring(_id)] == 1) or self.remaindTimes == 0 then
                GUI:SetActive(self.view.WorshipButton,false)
                GUI:setPositionX(self.view.LockButton, -48)
            end
        else
            GUI:SetActive(self.view.WorshipButton,false)
            GUI:setPositionX(self.view.LockButton,-48)
        end
        if self.selectPlayerId == SL:GetMetaValue(EMetaVarGetKey.UID) then
            GUI:SetActive(self.view.LockButton,false)
            GUI:SetActive(self.view.WorshipButton,false)
            self:ShowMyRole()
        else
            if self.reqOtherRoleInfo then--避免多次请求
                self.reqOtherRoleInfo = false
                self.otherRoleInfo = nil
                SL.Friend:ReqOtherRoleInfoMessage(self.selectPlayerId, 1)
            end
        end
    end
end

---@param control UIKmlLuaControl
function this:OnClickPlayer(control, eventData)
    if self.selectItem then
        GUI:SetActive(self.selectItem,false)
        self.selectItem = nil
    end
    self.selectPlayerIndex = eventData[1]
    self.selectItem = eventData[3]
    self.selectPlayerId = eventData[2]["actor"]["id"]
    self.selectPlayerServerId = eventData[2].serverid
    GUI:SetActive(self.selectItem,true)
    GUI:SetActive(self.view.LockButton,true)
    if self.rankType == 4 then
        GUI:SetActive(self.view.WorshipButton,true)
        GUI:setPositionX(self.view.LockButton, 58)
        if (self.worshipList and self.worshipList[tostring(self.selectPlayerId)] == 1) or self.remaindTimes == 0 then
            GUI:SetActive(self.view.WorshipButton,false)
            GUI:setPositionX(self.view.LockButton, -48)
        end
    else
        GUI:SetActive(self.view.WorshipButton,false)
        GUI:setPositionX(self.view.LockButton, -48)
    end
    if self.selectPlayerId == SL:GetMetaValue(EMetaVarGetKey.UID) then
        self:ShowMyRole()
        GUI:SetActive(self.view.LockButton,false)
        GUI:SetActive(self.view.WorshipButton,false)
    else
        self.otherRoleInfo = nil
        SL.Friend:ReqOtherRoleInfoMessage(self.selectPlayerId, 1)
    end
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
    GUI:Image_loadTexture(self.view.bg,iconName,"Atlas/UIRankListPanel.spriteatlas")
    GUI:setContentSize(self.view.bg,mountId == 0 and 809 or 988,430)
    GUI:setPosition(self.view.bg, mountId == 0 and 85 or 0, -45)
    GUI:setPositionY(self.view.mountModel, mountId == 0 and -170 or -205)
    GUI:setPositionX(self.view.mountModel, mountId == 0 and 12 or 70)
    SL:UIModel_Recycle(self.curShowRole)
    self.curShowRole = SL:UIModel_Create(GUI:GetRectTransform(self.view.mountModel),SL:GetMetaValue(EMetaVarGetKey.UID),SL:MeData_GetCareer(),SL:MeData_GetLevel(),SL:GetMetaValue(EMetaVarGetKey.USER_NAME),mountId,EAction.Stand,behaviour,SL:MeData_GetRoleExtInfo().roleInfoExtData,-50,0,-76,170,0,rotation,0)
end

---@param message UserProtos.OtherRoleInfoRes
function this:ResOtherRoleInfoMessage(id, message)
    if message.type == 1 and self.selectPlayerId == message.role.rid then
        --local model_list, equip_list = self:GetPlayerRoleInfo(message.role)
        --self:CreateRole(model_list, equip_list)
        self.otherRoleInfo = message
        --SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_OTHER_MOUNT_RANK,message.role.rid)
        self:RES_OTHER_MOUNT_RANK(_, 0)
    end
end

function this:RES_OTHER_MOUNT_RANK(id,message)
    if self.otherRoleInfo then
        local mountId = message
        local behaviour = EBehaviourType_Stand.Stand
        if self.selectPlayerIndex == 0 then
            behaviour = EBehaviourType_Stand.Sit
        end
        local iconName = mountId == 0 and "S_BG" or "rank_mount_bg"
        local rotation = mountId == 0 and 50 or 10
        GUI:Image_loadTexture(self.view.bg,iconName,"Atlas/UIRankListPanel.spriteatlas")
        GUI:setPosition(self.view.bg, mountId == 0 and 85 or 0, -45)
        GUI:setContentSize(self.view.bg,mountId == 0 and 809 or 988,430)
        GUI:setPositionY(self.view.mountModel, mountId == 0 and -170 or -205)
        GUI:setPositionX(self.view.mountModel, mountId == 0 and 12 or 70)
        SL:UIModel_Recycle(self.curShowRole)
        SL:ScheduleOnce(0.05, function()
            self.curShowRole = SL:UIModel_Create(GUI:GetRectTransform(self.view.mountModel),self.otherRoleInfo.role.rid,self.otherRoleInfo.role.career,self.otherRoleInfo.role.level,self.otherRoleInfo.role.name,mountId,EAction.Stand,behaviour,self.otherRoleInfo.role.roleInfoExt,-50,0,-76,170,0,rotation,0)    
        end)
        
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
    SL:RegisterLUAEvent(LUA_EVENT_ROLE_INFO, self.ResOtherRoleInfoMessage, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_OTHER_MOUNT_RANK,self.RES_OTHER_MOUNT_RANK,self)

    GUI:AddOnClickEvent(self.view.CloseButton, self, self.OnClickCloseButton)
    GUI:AddOnClickEvent(self.view.LockButton, self, self.OnClickLockButton)
    GUI:AddOnClickEvent(self.view.WorshipButton, self, self.OnClickWorshipButton)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.SEND_RANK_DATA_TO_CLIENT,self.RankDataChange,self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_GRAIL_RANKING_INFO,self.RankGrailChange,self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_GRAIL_RANKING_WORSHIP_INFO,self.RES_GRAIL_RANKING_WORSHIP_INFO,self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_PLAYER_EQUIP_GRAIL_INFO,self.RES_PLAYER_EQUIP_GRAIL_INFO,self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_OTHER_ANGE_EQUIP_INFO, self.RES_OTHER_ANGE_EQUIP_INFO, self) -- 其它角色大天使装备信息
end

function this:OnClickCloseButton()
    GUI:UIPanel_Close("dev/outui/UIRankList/Panel/KLUIRankList/KLUIRankListPanel")
    SL.ShowMainPanel()
end

function this:OnClickLockButton()
    if not self.selectPlayerId or self.selectPlayerId == 0 then
        SL:TipMessage(SL:GetConfig('cfg_string',280).text,1,NoticeType.NoticeMid)--"请先选择查看的玩家",
        return
    end
    if self.rankType == 4 then
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_PLAYER_EQUIP_GRAIL_INFO, self.selectPlayerId)
    else
        GUI:SetActive(self.view.closeEquipUIButton,true)
        --角色装备信息dev/outui/Equip/Panel/KLEquipUI3/KLEquipUI3Panel
        GUI:UIPanel_Open("dev/outui/Equip/Panel/KLEquipUI3/KLEquipUI3Panel", _, _, {
            isOther = true,
            rid = self.selectPlayerId,
            isHideMainUI = true,
            callBack = function() GUI:SetActive(self.view.closeEquipUIButton,false) end,
            x = 0,
            z = -1000
        })
        self.otherRoleAngelEquipInfo = {}
        local serverId
        if self.nowRootType == 2 then
            serverId = self.selectPlayerServerId
        end
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_OTHER_ANGE_EQUIP_INFO, { rid = self.selectPlayerId, hostId = serverId })
    end
end

function this:OnClickWorshipButton()
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_WORSHIP_ANGEL_GRAIL_RANKING, { type = self.nowRootType - 1, roleId = self.selectPlayerId })
end

---排行榜回包
function this:RankDataChange(_,message)
    GUI:setVisible(self.view.MyRank, true)
    GUI:setVisible(self.view.WorshipText, false)
    GUI:Button_setTitleText(self.view.LockButton, "查看装备")
    self.playerSeverDataList = {}
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
            table.insert(self.playerSeverDataList,data)
        end
        GUI:DataListUpdateData(self.view.PlayerDataList)
    end
end

function this:RankGrailChange(_, message)
    self.worshipList = message.roleIds or {}
    local totleTimes = tonumber(SL:GetConfig("cfg_global", 28002).value)
    self.remaindTimes = totleTimes - message.worshipCount < 0 and 0 or totleTimes - message.worshipCount
    GUI:Text_setString(self.view.WorshipText, "今日膜拜剩余次数：" .. self.remaindTimes)
    GUI:setVisible(self.view.WorshipText, true)
    GUI:Button_setTitleText(self.view.LockButton, "查看圣杯")
    self.playerSeverDataList = {}
    local count = 0
    if message and message.rankingInfo and message.rankingInfo.all then
        count = table.count(message.rankingInfo.all)
    end
    if count > 0 then
        GUI:setVisible(self.view.NoRankListImg, false)
        GUI:setVisible(self.view.RankList_Panel, true)
        for i = 1, count do
            local v = message.rankingInfo.all[tostring(i)]
            local info = {}
            info.name = v.roleName
            info.value = v.score
            info.serverid = v.serverId
            info.rankno = v.ranking
            info.career = v.career or 1
            info.actor = { id = tonumber(v.roleId) }
            self.playerSeverDataList[#self.playerSeverDataList + 1] = info
        end
        GUI:DataListUpdateData(self.view.PlayerDataList)
    else
        GUI:setVisible(self.view.NoRankListImg, true)
        GUI:setVisible(self.view.RankList_Panel, false)
    end
    local rankNo, rankMy
    if message and message.rankingInfo and message.rankingInfo.my then
        rankNo = message.rankingInfo.my.ranking
        rankMy = message.rankingInfo.my
    end
    self:InitMyRankInfo(rankMy, rankNo)
end

function this:RES_GRAIL_RANKING_WORSHIP_INFO(_, message)
    if message then
        self.worshipList = message.grailIds or {}
        local totleTimes = tonumber(SL:GetConfig("cfg_global", 28002).value)
        self.remaindTimes = totleTimes - message.worshipCount < 0 and 0 or totleTimes - message.worshipCount
        GUI:Text_setString(self.view.WorshipText, "今日膜拜剩余次数：" .. self.remaindTimes)
        if (self.worshipList and self.worshipList[tostring(self.selectPlayerId)] == 1) or self.remaindTimes == 0 then
            GUI:SetActive(self.view.WorshipButton,false)
            GUI:setPositionX(self.view.LockButton, -48)
        end
    end
end

function this:RES_PLAYER_EQUIP_GRAIL_INFO(_, message)
    if message then
        InfoManager.archangeEquipInfo:SetOtherGrailInfo(message.grail)
        GUI:UIPanel_Open("dev/outui/Archangel/Panel/KLArchangelGrail/KLArchangelGrailPanel", nil, nil, { isOther = true,z = -1000 })
    end
end

function this:RES_OTHER_ANGE_EQUIP_INFO(_, message)
    self.otherRoleAngelEquipInfo = {}
    if message then
        self.otherRoleAngelEquipInfo = message
    end
end

function this:GetOtherAngelEquipInfo(id)
    return self.otherRoleAngelEquipInfo[tostring(id)]
end

function this:Close()
    SL:SendLuaNetMsg(LuaMessageIdToSever.STOP_REFRESH_RANK_DATA)
    if self.curShowRole then
        SL:UIModel_Recycle(self.curShowRole)
        self.curShowRole = nil
    end
    
    self.otherRoleInfo = nil
end

return this
