---@class KLHuntingDemonsHallOfFamePanel:UIKmlLuaPanelBase
---@field view KLHuntingDemonsHallOfFamePanelView
local KLHuntingDemonsHallOfFamePanel = class(UIKmlLuaPanelBase)
local this =KLHuntingDemonsHallOfFamePanel
function this:AsyncLoadUI()
end
---创建时调用一次
function this:Init()
    self.isFirstOpen = true
    ---可携带勋章上限
    self.maxMedalNum = tonumber(SL:GetConfig("cfg_global",27003).value)
    ---当前勋章数量
    self.medalNum = 0
    ---前三名模型列表
    self.roleList = 
    {
        [1] = self.view.role_mid,
        [2] = self.view.role_left,
        [3] = self.view.role_right,
    }
    ---前三名积分文本列表
    self.roleIntegralList = 
    {
        [1] = self.view.role_mid_integral_Text,
        [2] = self.view.role_left_integral_Text,
        [3] = self.view.role_right_integral_Text,
    }
    ---前三名勋章数量文本列表
    self.roleItemNumberList = 
    {
        [1] = self.view.role_mid_item_Text,
        [2] = self.view.role_left_item_Text,
        [3] = self.view.role_right_item_Text,
    }
    ---前三名名字文本列表
    self.roleNameList = 
    {
        [1] = self.view.role_mid_name_Text,
        [2] = self.view.role_left_name_Text,
        [3] = self.view.role_right_name_Text,
    }
    self.jumpPath = {"openUIPanel","dev/ui/ShopMall/Panel/KLShopMall/KLShopMallPanel","1","2011"}
    local level = SL:GetMetaValue(EMetaVarGetKey.LEVEL)
    ---@type cfg_menu_layer_column[]
    local tblList = SL:GetConfigTable("cfg_menu_layer")
    for _, v in pairs(tblList) do
        if v.parentID == 2001 and v.level <= level and (v.lieMoSeason ==0 or v.lieMoSeason == InfoManager.uiHuntingDemonsInfo:GetCurSeason()) then
            self.jumpPath[4] = tostring(v.id)
        end
    end
    GUI:Item_setItemId(self.view.item,InfoManager.uiHuntingDemonsInfo.itemID)
    GUI:SetZIndex(self.view.roleTitle1,205)
    GUI:SetZIndex(self.view.roleTitle2,205)
    GUI:SetZIndex(self.view.roleTitle3,205)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.HelpButton,self,self.OnClickHelp)
    GUI:AddOnClickEvent(self.view.btn_go,self,self.OnClickGo)
    GUI:AddOnClickEvent(self.view.btn_shop,self,self.OnClickShop)
    GUI:AddOnClickEvent(self.view.item,self,self.OnClickShowTips)
    SL:RegisterLUAEvent(LUA_EVENT_REQ_HUNTING_DEMONS_THREE_PLAYER_END, self.LUA_EVENT_REQ_HUNTING_DEMONS_THREE_PLAYER_END, self)
    SL:RegisterLUAEvent(LUA_EVENT_HUNTING_DEMONS_RANK_DATA_CHANGE, self.LUA_EVENT_HUNTING_DEMONS_RANK_DATA_CHANGE, self)
    SL:RegisterLUAEvent(LUA_EVENT_HUNTING_DEMONS_INFO_CHANGE, self.LUA_EVENT_HUNTING_DEMONS_INFO_CHANGE, self)
end

---显示猎魔道具tips
function this:OnClickShowTips()
    SL:OpenTips("",InfoManager.uiHuntingDemonsInfo.itemID)
end

---猎魔信息变动
function this:LUA_EVENT_HUNTING_DEMONS_INFO_CHANGE()
    local isRest = true
    local time = InfoManager.uiHuntingDemonsInfo.resetSec * 1000
    if time > InfoManager.uiHuntingDemonsInfo.settleSec * 1000 then
        time = InfoManager.uiHuntingDemonsInfo.settleSec * 1000
        isRest = false
    end
    GUI:Text_setString(self.view.btn_go,"前往猎魔")
    GUI:Button_setGrey(self.view.btn_go,false)
    local count = (time - tonumber(SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME))) * 0.001 + 1
    local func = function()
        local now = tonumber(SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME))
        local deltaTime = time - now
        GUI:Text_setString(self.view.timeText, isRest
                and "离重置的剩余时间：".. self:FormatTimeHMS(deltaTime) or "离结算的剩余时间："..self:FormatTimeHMS(deltaTime))
        if deltaTime <= 0 then
            GUI:Text_setString(self.view.timeText, "活动未开启")
            GUI:Text_setString(self.view.btn_go,"等待下次开启")
            GUI:Button_setGrey(self.view.btn_go,true)
            self:UnScheduleTimer()
            if time > 0 then
                SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_MONSTER_HUNT_INFO)             
            end
        end
    end
    func()
    self.countDown = SL:Schedule(self.countDown, 0, 1, count, func)
end

--单位毫秒
function this:FormatTimeHMS(time)
    time = time // 1000
    local s = time % 60
    local m = time // 60 % 60
    local h = time // 3600 % 24
    return string.format("%02d:%02d:%02d", h, m, s);
end

function this:UnScheduleTimer()
    if self.countDown then
        SL:UnSchedule(self.countDown)
    end
    self.countDown = nil
end

---猎魔排行榜数据变动
function this:LUA_EVENT_HUNTING_DEMONS_RANK_DATA_CHANGE()
    self:SetMedalNumText()
end

---请求前三名猎魔玩家数据完成
function this:LUA_EVENT_REQ_HUNTING_DEMONS_THREE_PLAYER_END()
    for i = 1, 3 do
        ---人物数据
        local data = InfoManager.uiHuntingDemonsInfo:GetTheFirstThreeRankData(i)
        local integral = ""
        local itemNum = ""
        local name = ""
        ---排行榜数据
        local rankData = InfoManager.uiHuntingDemonsInfo:GetRankDataIndex(i)
        if rankData and rankData.integral then
            integral = "杀怪积分："..SL:GetSimpleNumber(Mathf.Ceil(rankData.integral),1)
        end
        if rankData and rankData.medal then
            itemNum = "获得猎魔勋章："..SL:GetSimpleNumber(Mathf.Ceil(rankData.medal),1)
        end
        if rankData and rankData.roleInfo and rankData.roleInfo.name then
            name = rankData.roleInfo.name
        end
        GUI:Text_setString(self.roleIntegralList[i],integral)
        GUI:Text_setString(self.roleItemNumberList[i],itemNum)
        GUI:Text_setString(self.roleNameList[i],name)
        GUI:setVisible(self.roleList[i],false)
        if data then
            GUI:setVisible(self.roleList[i],true)
            local model_list, equip_list = InfoManager.uiHuntingDemonsInfo:GetPlayerRoleInfo(data.role)
            GUI:SetPlayerRoleInfo(self.roleList[i], model_list, equip_list)
        end
    end
end

---点击打开帮助页面
function this:OnClickHelp()
    local helpCfg=SL:GetConfig("cfg_rule_text",27001)
    if helpCfg then
        SL:CommonStrTipsMessage({title =helpCfg.menutxt,str=helpCfg.location})
    end
end

---点击前往猎魔
function this:OnClickGo()
    self.args.mainPanel:SelectTogglePanel(2)
end

---点击前往猎魔商店
function this:OnClickShop()
    SL:ShortcutDO(self.jumpPath)
    self.args.mainPanel:OnClickClose()

end

---界面显示时调用一次
function this:Show()
    self:LUA_EVENT_REQ_HUNTING_DEMONS_THREE_PLAYER_END()
    self:LUA_EVENT_HUNTING_DEMONS_RANK_DATA_CHANGE()
    self:LUA_EVENT_HUNTING_DEMONS_INFO_CHANGE()
end

---创建或者刷新界面数据时调用
function this:Refresh()
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_MONSTER_HUNT_RANK)
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_MONSTER_HUNT_INFO)
    self:SetMedalNumText()
end

---设置勋章数量文本
function this:SetMedalNumText()
    self.medalNum = SL:GetMetaValue(EMetaVarGetKey.MONEY,InfoManager.uiHuntingDemonsInfo.itemID)
    --SL:GetTotalCoinBaseId(InfoManager.uiHuntingDemonsInfo.itemID)
    GUI:Text_setString(self.view.NumText,"勋章："..self.medalNum)
end

function this:Hide()
end

function this:Close()
    self:UnScheduleTimer()
end

return this
