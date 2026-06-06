---@class KLPopoverPanel:UIKmlLuaPanelBase
---@field view KLPopoverPanelView
local KLPopoverPanel = class(UIKmlLuaPanelBase)
local this = KLPopoverPanel

---创建时调用一次
function this:Init()
    self.shownum = 5 ---默认显示前3个预告提示
    self.popoverTimetbl = {}
    self.isShowBagTips = false
    GUI:DataListInitData(self.view.leftdatalist, function()
        return self:DataListItemCountFunc()
    end, function(realIndex)
        return self:DataListItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:DataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:DataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    self.PopoverHandleFun = {
        [PopoverType.Tip_MonthCardQJQuota] = self.Tip_MonthCardQJQuota
    }
    -- self.updateTime = SL:Schedule(self.updateTime,0,Time.deltaTime,-1,function()
        
    -- end)

    self:LUA_EVENT_MAIN_PLAYER_DIE()
    --摆动气泡
    self:DotweenPopover()


end

function this.Tip_MonthCardQJQuota()
    SL:CommonTipsMessage({
        stringTblID = 461,
    })
end

function this:DataListItemCountFunc()
    return #self.popoverTimetbl
end
function this:DataListItemGetFunc(realIndex)
end
function this:DataListItemInitFunc(realIndex, kmlcontrol)
    --SL:Log('DataListItemInitFunc'..tostring(realIndex))
end
function this:DataListItemUpdateFunc(realIndex, kmlcontrol)
    --local iconitem = self.view.leftdatalist:GetChildControl(realIndex, 'iconitem')
    local iconitem = GUI:GetChildControl(self.view.leftdatalist, realIndex, 'iconitem')
    local txt_time = GUI:GetChildControl(self.view.leftdatalist, realIndex, 'txt_time')
    local idx = realIndex + 1
    local info = self.popoverTimetbl[idx]
    if info and idx <= self.shownum then
        local atlas = "Atlas/KLMainPanelIcon.spriteatlas"
        GUI:Image_loadTexture(iconitem, info.icon, atlas)
        GUI:SetImageNativeSize(iconitem)
        
        GUI:AddOnClickEvent(iconitem, self, self.ClickPopoverType, info.id)
        GUI:setVisible(iconitem, true)
    else
        GUI:setVisible(iconitem, false)
    end
    local time = Time.GetServerTime()
    if info.destoryTime then
        local delta = info.destoryTime - time
        delta = delta > 0 and delta or 0
        GUI:setVisible(txt_time, true)
        GUI:Text_setString(txt_time, Time.FormatTimeMS(delta))
        self.timeView[info.id] = {time = info.destoryTime, view = txt_time}
        self:StartTimeViewCountDown()
    else
        GUI:setVisible(txt_time, false)
    end
end

--气泡点击，跳转界面
function this:ClickPopoverType(control, eventData)
    if eventData ~= PopoverType.Tip_MonthCard then
        --判断是否不是已读消失
        local isReadOut = self:GetReadOutPopoverById(eventData)
        if isReadOut then
            self:DelPopoverById(eventData)--删除气泡显示
        end

    end
    --logError("点击的气泡id = "..eventData)

    --暂时缺跳转各界面接口,都先打开加点界面
    if (eventData == PopoverType.Tip_attribute) then
        SL:OpenKLAttrPanel()
    end
    if eventData == PopoverType.Tip_efficiency then
    end
    if eventData == PopoverType.Tip_auction then
    end
    if eventData == PopoverType.Tip_mail then
        GUI:UIPanel_Open("dev/ui/Mail/Panel/KLMail/KLMailPanel")
    end
    if eventData == PopoverType.Tip_testimonial then
    end
    if eventData == PopoverType.Tip_brave_trials then
    end
    if eventData == PopoverType.Tip_partner_incubation then
    end
    if eventData == PopoverType.Tip_partner_dispatch then
    end
    if eventData == PopoverType.Tip_task_dispatch then
    end
    if (eventData == PopoverType.Tip_fashion) then
    end
    if (eventData == PopoverType.Tip_inventory) then
        GUI:UIPanel_Open("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel")
    end
    if (eventData == PopoverType.Tip_assist) then
    end
    if (eventData == PopoverType.Tip_equipment_replacement) then
    end
    if (eventData == PopoverType.Tip_StrengthMaster) then
    end
    if (eventData == PopoverType.Tip_AddMaster) then
    end
    if (eventData == PopoverType.Tip_RefinedMaster) then
    end
    if (eventData == PopoverType.Tip_StarMaster) then
    end
    --新增体验翅膀提示
    if eventData == PopoverType.Tip_Experiencewings then
    end
    if (eventData == PopoverType.Tip_AiHook) then
    end
    if eventData == PopoverType.Tip_team then
        GUI:UIPanel_Open("dev/ui/Team/Panel/KLUITeamMain/KLUITeamMainPanel", _, _, { panelType = 4 })
    end
    if (eventData == PopoverType.Tip_union_trade) then
        --[[        local message = {stringTblID=230,
                    showTips = "战盟拍卖已开启，是否前往竞拍？",
                    title = "提示",
                    callback = function()
                        GUI:UIPanel_Open("dev/outui/Trade/Panel/KLTradeMain/KLTradeMainPanel",nil,nil,"toggle_trade_union")
                    end
                }]]
        SL:CommonTipsMessage({ stringTblID = 230,
                               showTips = "战盟拍卖已开启，是否前往竞拍？",
                               title = "提示",
                               callback = function()
                                   GUI:UIPanel_Open("dev/outui/Trade/Panel/KLTradeMain/KLTradeMainPanel", nil, nil, "toggle_trade_union")
                               end
        })
    end
    if (eventData == PopoverType.Tip_friends) then
        GUI:UIPanel_Open("dev/ui/FriendSys/Panel/KLFriendMain/KLFriendMainPanel",nil,nil,{type=EFriendRelation.Friend})
        SL.HideMainPanel()
    end

    if eventData == PopoverType.Tip_MonthCard then

        local desc = "您的月卡剩余时间小于24小时,交易行交易税将\n提升至20%,是否购买增加月卡时间?"
        GUI:UIPanel_Open("dev/ui/Common/Panel/KLUICommonTips/KLUICommonTipsPanel", nil, nil,
                { showTips = desc,
                  callback = function()
                      GUI:UIPanel_Open("dev/outui/MonthCard/Panel/KLUIMonthCardMain/KLUIMonthCardMainPanel")
                  end,
                  callbackData = nil,
                  ui = self })
    end

    if eventData == PopoverType.Tip_GoldPrivilege then
        local stringId, stringFormat
        local time = PrivilegeCardManager.GetPrivilegeRemainTime(1)
        if time > 0 then
            stringId = 444
            local timeStr = SL:TimeFormatToStr(math.floor(time / 1000))
            stringFormat = { tostring(timeStr) }
        else
            stringId = 446
            stringFormat = nil
        end
        SL:CommonTipsMessage({
            stringTblID = stringId,
            stringTblFormat = stringFormat,
            sureBtnText = "兑换特权",
            callback = function()
                if InfoManager.monthCardInfo:IsHaveMonthCardRights("privilege") then
                    GUI:UIPanel_Open("dev/outui/MonthCard/Panel/KLUIMonthCardMain/KLUIMonthCardMainPanel", nil, nil, { type = "privilege" })
                else
                    GUI:UIPanel_Open("dev/outui/MonthCard/Panel/KLUIMonthCardMain/KLUIMonthCardMainPanel")
                end
            end,
            cancelCallBack = function()
                PrivilegeCardManager.SetHideGoldPopover(true)
            end })
    end

    if eventData == PopoverType.Tip_DiamondPrivilege then
        local stringId, stringFormat
        local time = PrivilegeCardManager.GetPrivilegeRemainTime(2) / 1000
        if time > 0 then
            stringId = 445
            local timeStr = SL:TimeFormatToStr(math.floor(time / 1000))
            stringFormat = { tostring(timeStr) }
        else
            stringId = 447
            stringFormat = nil
        end
        SL:CommonTipsMessage({
            stringTblID = stringId,
            stringTblFormat = stringFormat,
            sureBtnText = "兑换特权",
            callback = function()
                if InfoManager.monthCardInfo:IsHaveMonthCardRights("privilege") then
                    GUI:UIPanel_Open("dev/outui/MonthCard/Panel/KLUIMonthCardMain/KLUIMonthCardMainPanel", nil, nil, { type = "privilege" })
                else
                    GUI:UIPanel_Open("dev/outui/MonthCard/Panel/KLUIMonthCardMain/KLUIMonthCardMainPanel")
                end
            end,
            cancelCallBack = function()
                PrivilegeCardManager.SetHideDiamondPopover(true)
            end })
    end
    if eventData == PopoverType.Tip_EquipFix then
        self:FixEquipClick()
    end
    if (eventData == PopoverType.Tip_FaceTrade) then
        local str = InfoManager.faceTradeInfo:GetApplyTipText()
        SL:CommonTipsMessage({
                               showTips = str,
                               title = "提示",
                               cancelCallBack = function()
                                    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_FACE_TRADE_REJECT)
                               end,
                               callback = function()
                                    if SL:Out_IsInCopy() then
                                        local stringTbl = SL:GetConfig("cfg_string", 59004)
                                        SL:TipMessage(stringTbl.text, 1, NoticeType.NoticeMid)
                                        return
                                    end
                                    if InfoManager.faceTradeInfo:CheckTradeApplyCondition() then
                                        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_FACE_TRADE_AGREE)
                                    else
                                        local Global = SL:GetConfig("cfg_string", 59001)
                                        SL:TipMessage(Global.text, 1, NoticeType.NoticeMid)
                                    end
                               end
        })
    end
    if (eventData == PopoverType.Tip_NewPlayerBuff) then
        if PrivilegeCardManager.goldFGPrivilege and PrivilegeCardManager.GetPrivilegeFGRemainTime(1) >= 0 then
            SL:CommonTipsMessage({ stringTblID = 65001,
                               ui = self,
                               sureBtnText = "前往领取",
                               cancelBtnText = "前往领取",
                                callback = self.NewPlayerBuffClick,
                                isShowCancelBtn = false,
                               })
        else
            SL:CommonTipsMessage({ stringTblID = 65001,
                               ui = self,
                               sureBtnText = "开通特权",
                               cancelBtnText = "前往领取",
                               callback =  function()
                                GUI:UIPanel_Open("dev/outui/MonthCard/Panel/KLMonthCardNew/KLMonthCardNewPanel")
                               end,
                                cancelCallBack = self.NewPlayerBuffClick
                               })
        end
    end
    if eventData == PopoverType.Tip_FriendsApplication then
        GUI:UIPanel_Open("dev/ui/FriendSys/Panel/KLFriendMain/KLFriendMainPanel",nil,nil,{type=EFriendRelation.Friend})
        GUI:UIPanel_Open("dev/ui/FriendSys/Panel/KLFriendAdd/KLFriendAddPanel", _, _, {showApplicationInfo = true})
        SL.HideMainPanel()
    end
    local handleFun = self.PopoverHandleFun[eventData]
    if handleFun then
        handleFun()
    end
end

function this.NewPlayerBuffClick()
    local map_id = SL:GetMetaValue(EMetaVarGetKey.MAP_ID)
    local global = SL:GetConfig("cfg_global", 800002).value
    local split = string.split(global, "|")
    local mapNpc = {}
    for k, v in pairs(split) do
        local split2 = string.split(v, "#")
        local mapId = tonumber(split2[1])
        local npcList = SL:GetConfig("cfg_npclist", tonumber(split2[2]))
        if mapNpc[mapId] == nil then
            mapNpc[mapId] = {}
        end
        table.insert(mapNpc[mapId], npcList)
    end
    local curMapNpc = mapNpc[map_id]
    if table.isNullOrEmpty(curMapNpc) then
        SL:MessageTip({id = 71001	})
        return
    end
    local playerPos = SL:MeData_GetCoord()
    local min = nil
    for k, v in pairs(curMapNpc) do
        local npcPos = Dot2(v.x,v.y)
        local distance = SL:GetPointDistanceSQ(playerPos, npcPos)
        if not min then
            min = {id = v.id, distance = distance}
        end
        if min.distance > distance then
            min = {id = v.id, distance = distance}
        end
    end
    SL:FGRunToNpc(min.id)
end

function this:GetRepairCost(v, fixCostNum)
    local price = 0
    ---@type cfg_item_column
    local tbl = SL:GetConfig("cfg_item", v.cfgId)
    if tbl.Durability ~= 0 then
        local now = EquipFunc.GetDurability(v)
        local max = EquipFunc.GetMaxDurability(v)
        local delta = max - now
        price = delta * fixCostNum
    end
    return price
end

function this:FixEquipClick()
    GUI:UIPanel_Open("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel", nil, nil, {showFixLight = true})
    -- local global = SL:GetConfig("cfg_global", 320016)
    -- local split = string.split(global.value, "#")
    -- local fixCostNum = tonumber(split[2])
    -- local equips = SL:GetTotalWearEquips()
    -- local totalPrice = 0
    -- local repairList = {}
    -- if not table.isNullOrEmpty(equips) then
    --     for _, list in pairs(equips) do
    --         for _, v in pairs(list) do
    --             local price = self:GetRepairCost(v, fixCostNum)
    --             if price > 0 then
    --                 totalPrice = totalPrice + price
    --                 table.insert(repairList, v.id)
    --             end
    --         end
    --     end
    -- end
    -- if totalPrice == 0 then
    --     SL:onLUAEvent(LUA_EVENT_BUBBLETIPS_DEL, PopoverType.Tip_EquipFix)
    -- else
    --     GUI:UIPanel_Open("dev/outui/Bag/Panel/KLBagRepairConfirm/KLBagRepairConfirmPanel", nil, nil,
    --             { totalPrice = totalPrice, list = repairList})
    -- end
end

---创建或者刷新界面数据时调用
function this:Refresh()
    GUI:setVisible(self.view.Bg, true)
    --刷新显示气泡
    self:RefreshUI()

    local tbl = SL:GetConfig("cfg_popover", PopoverType.Tip_MonthCard)
    local tbl_gold = SL:GetConfig("cfg_popover", PopoverType.Tip_GoldPrivilege)
    local tbl_diamond = SL:GetConfig("cfg_popover", PopoverType.Tip_DiamondPrivilege)
    self.MonthTime = SL:Schedule(self.MonthTime, 0, 1, -1, function()
        if InfoManager.monthCardInfo:IsHaveDayTime() and not self:isInArray(self.popoverTimetbl, tbl.id) then
            ---小于1天 大于0时才显示
            self:SetPopoverData(PopoverType.Tip_MonthCard)
            self:RefreshUI()
        else
            if not InfoManager.monthCardInfo:IsHaveDayTime() then
                self:DelPopoverById(PopoverType.Tip_MonthCard)
            end
        end
        if not PrivilegeCardManager.isautoRecovery() then
            self:LUA_EVENT_BAG_CHANGE_AFTER()
        else
            if GUI:GetUI("dev/outui/Bag/Panel/KLBagButtonTips/KLBagButtonTipsPanel") then
                GUI:UIPanel_Close("dev/outui/Bag/Panel/KLBagButtonTips/KLBagButtonTipsPanel")
            end
            self:DelPopoverById(PopoverType.Tip_inventory)
        end
        
        if PrivilegeCardManager.GetDiamondPrivilegePopoverState() then
            if not self:isInArray(self.popoverTimetbl, tbl_diamond.id) then
                self:SetPopoverData(PopoverType.Tip_DiamondPrivilege)
                self:RefreshUI()
            end
        else
            self:DelPopoverById(PopoverType.Tip_DiamondPrivilege)
        end

        if PrivilegeCardManager.GetGoldPrivilegePopoverState() then
            if not self:isInArray(self.popoverTimetbl, tbl_gold.id) then
                self:SetPopoverData(PopoverType.Tip_GoldPrivilege)
                self:RefreshUI()
            end
        else
            self:DelPopoverById(PopoverType.Tip_GoldPrivilege)
        end
        
        
    end)
    
    local friendApplyList = SL:GetFriendData(EFriendRelation.ApplyList)
    if friendApplyList and table.count(friendApplyList) > 0 then
        SL:onLUAEvent(LUA_EVENT_BUBBLETIPS_ADD, {id = PopoverType.Tip_FriendsApplication})
    end
end

---气泡倒计时计时器移除
function this:RecycleTimeView()
    if self.UpdateTimeSchedule then
        SL:UnSchedule(self.UpdateTimeSchedule)
    end
    self.UpdateTimeSchedule = nil
end

function this:StartTimeViewCountDown()
    if not self.UpdateTimeSchedule then
       self.UpdateTimeSchedule = SL:Schedule(self.UpdateTimeSchedule,
                            1, 1, -1, function()
                                if table.count(self.timeView) > 0 then
                                    local time = Time.GetServerTime()
                                    local remove = false
                                    for infoId, data in pairs(self.timeView) do
                                        local delta = data.time - time
                                        if delta <= 0 then
                                            for index, v in pairs(self.popoverTimetbl) do
                                                if v.id == infoId then
                                                    table.remove(self.popoverTimetbl, index)
                                                    remove = true
                                                    break
                                                end
                                            end
                                        end
                                        delta = delta > 0 and delta or 0
                                        GUI:Text_setString(data.view, Time.FormatTimeMS(delta))
                                    end
                                    if remove then
                                        self:RefreshUI()
                                    end
                                else
                                    --无倒计时气泡
                                    self:RecycleTimeView()
                                end
                            end)
                    end
end

--刷新面板icon
function this:RefreshUI()
    self.timeView = {}
    self:RecycleTimeView()
    if self.popoverTimetbl then
        local time = Time.GetServerTime()
        for i = #self.popoverTimetbl, 1, -1 do
            local tbl = self.popoverTimetbl[i]
            if tbl.destoryTime then
                ---判断是否拥有存在时间的气泡
                if time < tbl.destoryTime then
                    
                else
                    --超时的需要移除
                    table.remove(self.popoverTimetbl, i)
                end
            end
        end
    end
    GUI:DataListUpdateData(self.view.leftdatalist)
end

--获取是否已读消失
function this:GetReadOutPopoverById(memberId)
    if self.popoverTimetbl == nil then
        self.popoverTimetbl = {}
    end
    for index, popoverInfo in pairs(self.popoverTimetbl) do
        if popoverInfo.id == memberId then
            if popoverInfo.ReadDisappear then
                return popoverInfo.ReadDisappear
            end

        end
    end
end

-- 气泡重复，替换新气泡数据
function this:DelAddPopoverMemberById(tbl, memberId)
    if self.popoverTimetbl == nil then
        self.popoverTimetbl = {}
    end
    for index, popoverInfo in pairs(self.popoverTimetbl) do
        if popoverInfo.id == memberId then
            table.remove(self.popoverTimetbl, index)
            local popoverData = self:GetPopovertbl(tbl)
            table.insert(self.popoverTimetbl, index, popoverData)
        end
    end
end
--是否已存在
function this:isInArray(t, val)
    for index, v in ipairs(t) do
        if v.id then
            if v.id == val then
                return true, index
            end
        end
    end
    return false
end
--获取气泡数据
function this:GetPopovertbl(tbl)
    local Popovertbl = {}
    local Disappear = false  --限时消失目前已取消
    local ReadDisappear = true  --已读消失
    if tbl.disappeartype and tonumber(tbl.disappeartype) == 1 then
        --已读不消失
        ReadDisappear = false
    end
    Popovertbl.id = tbl.id
    Popovertbl.name = tbl.name
    Popovertbl.icon = tbl.icon
    Popovertbl.Disappear = Disappear
    Popovertbl.ReadDisappear = ReadDisappear
    Popovertbl.destoryTime = self:GetPopoverCountDestoryTiem(tbl.id)
    return Popovertbl
end
--获取气泡自动销毁时间
function this:GetPopoverCountDestoryTiem(id)
    if id == PopoverType.Tip_FaceTrade then
        return InfoManager.faceTradeInfo:GetApplyCountDown()
    end
end

--添加气泡
function this:SetPopoverData(typeid)
    ---@type cfg_popover_column
    local tbl = SL:GetConfig("cfg_popover", typeid)
    if tbl.switch and tbl.switch == 1 then
        --switch=1 不显示
    else
        if self.popoverTimetbl == nil then
            self.popoverTimetbl = {}
        end
        if #self.popoverTimetbl > 0 then
            local isexist, index = self:isInArray(self.popoverTimetbl, tbl.id)
            if isexist then
                self:DelAddPopoverMemberById(tbl, tbl.id)
            else
                local popoverData = self:GetPopovertbl(tbl)
                table.insert(self.popoverTimetbl, 1, popoverData)
            end
        else
            local popoverData = self:GetPopovertbl(tbl)
            table.insert(self.popoverTimetbl, 1, popoverData)
        end
    end
end

-- 删除气泡
function this:DelPopoverById(memberId)
    if self.popoverTimetbl == nil then
        self.popoverTimetbl = {}
    end
    for index, popoverInfo in pairs(self.popoverTimetbl) do
        if popoverInfo.id == memberId then
            table.remove(self.popoverTimetbl, index)
            self:RefreshUI()
        end
    end
end

--气泡左右摆动
function this:DotweenPopover()
    --气泡闪烁动画
    self.anim = GUI:DOAlphaCanvasGroup(self.view.Bg, 0, 1)
    GUI:TweenSetLoops(self.anim,-1)
    GUI:TweenSetEase(self.anim,ELeanTweenType.pingPong)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    SL:RegisterLUAEvent(Event.SetPopoverData, self.OutSetPopoverData, self)
    SL:RegisterLUAEvent(Event.ClosePopover, self.ClosePopover, self)
    --SL:RegisterLUAEvent(LUA_EVENT_BUBBLETIPS_POSY, self.OutSetPosY, self)
    SL:RegisterLUAEvent(LUA_EVENT_BUBBLETIPS_ADD, self.OutSetPopoverData, self)
    SL:RegisterLUAEvent(LUA_EVENT_BUBBLETIPS_DEL, self.ClosePopover, self)
    --SL:RegisterLUAEvent(LUA_EVENT_FIGHTBEGINF,self.LUA_EVENT_FIGHTBEGINF,self)
    --SL:RegisterLUAEvent(LUA_EVENT_FIGHTEND,self.LUA_EVENT_FIGHTEND,self)
    SL:RegisterLUAEvent(LUA_EVENT_RECEIVE_EMAIL, self.LUA_EVENT_RECEIVE_EMAIL, self)
    -------------------------------------------------------------
    --属性点分配，
    SL:RegisterLUAEvent(LUA_EVENT_ROLE_PROPERTY_CHANGE, self.LUA_EVENT_ROLE_PROPERTY_CHANGE, self)
    ---刷新属性点变化
    SL:RegisterLUAEvent(LUA_EVENT_OPEN_UI, self.CloseMail, self)
    SL:RegisterLUAEvent(LUA_EVENT_MAIN_UI_VISIBLE, self.LUA_EVENT_MAIN_UI_VISIBLE, self)
    SL:RegisterLUAEvent(LUA_NewPlayer_MM_BUFF_CHANGE, self.LUA_NewPlayer_MM_BUFF_CHANGE, self)
    SL:RegisterLUAEvent(LUA_EVENT_MAIN_PLAYER_DIE, self.LUA_EVENT_MAIN_PLAYER_DIE, self)
end
function this:LUA_NewPlayer_MM_BUFF_CHANGE()
    if InfoManager.roleOtherInfo.isNewPlayerBuff or InfoManager.guardPetInfo.IsOpenMM then
        self:DelPopoverById(PopoverType.Tip_NewPlayerBuff)
        --logError("shanchu")
    end
end
function this:LUA_EVENT_MAIN_PLAYER_DIE()
    if not InfoManager.roleOtherInfo.isNewPlayerBuff and not InfoManager.guardPetInfo.IsOpenMM then
        self:SetPopoverData(PopoverType.Tip_NewPlayerBuff)
        self:RefreshUI()
        --logError("shuaixing")
    end
end
function this:LUA_EVENT_MAIN_UI_VISIBLE(_,data)
    if data then
        if data.name == "KLUISystemTopPanel" then
            self.isShowBagTips = data.vis
        end
    end
end
function this:LUA_EVENT_BAG_CHANGE_AFTER()
    ---@type cfg_redDot_new_column
    local cfg = SL:GetConfig("cfg_redDot_new",117)
    if cfg then
        if SL:CheckCalculateConditionGroup(cfg.condition) then
            if not InfoManager.uiHookInfo.IsShowBagTips and self.isShowBagTips then
                --self:SetPopoverData(PopoverType.Tip_inventory)
                if not GUI:GetUI("dev/outui/Bag/Panel/KLBagButtonTips/KLBagButtonTipsPanel") then
                    GUI:UIPanel_Open("dev/outui/Bag/Panel/KLBagButtonTips/KLBagButtonTipsPanel")
                end
                --self:RefreshUI()
            end
        else
            if GUI:GetUI("dev/outui/Bag/Panel/KLBagButtonTips/KLBagButtonTipsPanel") then
                GUI:UIPanel_Close("dev/outui/Bag/Panel/KLBagButtonTips/KLBagButtonTipsPanel")
            end
            --self:DelPopoverById(PopoverType.Tip_inventory)
        end 
    end
end

function this:LUA_EVENT_RECEIVE_EMAIL()
    self:SetPopoverData(PopoverType.Tip_mail)
    self:RefreshUI()
end

function this:CloseMail(_, message)
    if message.panelName == "KLMailPanel" then
        self:DelPopoverById(PopoverType.Tip_mail)
    end

end

function this:LUA_EVENT_ROLE_PROPERTY_CHANGE(id, data)
    local isshow = SL:CheckIsShowAttributeBoxTip()
    if isshow then
        ---显示快捷提示
        self:SetPopoverData(PopoverType.Tip_attribute)
        self:RefreshUI()
    else
        self:DelPopoverById(PopoverType.Tip_attribute)
    end
end

function this:Update()
    
end

-----设置气泡状态（屏蔽/显示）
--function this:LUA_EVENT_FIGHTBEGINF(id,data)
--    GUI:setVisible(self.view.Bg,false)
--end
-----设置气泡状态（屏蔽/显示）
--function this:LUA_EVENT_FIGHTEND(id,data)
--    GUI:setVisible(self.view.Bg,true)
--end

---

---外部设置气泡Y 坐标位置
function this:OutSetPosY(id, data)
    local panel = GUI:GetUI("dev/ui/ShopMall/Panel/KLShopMall/KLShopMallPanel")
    local npcpanel = GUI:GetUI("dev/ui/NPC/Panel/KLNPCShop/KLNPCShopPanel")
    --local popy = self.view.root.rectTransform:GetLocalPositionY()
    local popx,popy,popz = GUI:getPosition(self.view.root)
    --local tbl = cfg_showHideUI_post.GetSystemInfoByPanelName("KLPopoverPanel")
    local tbl = SL:CfgShowHideUIPost_GetSystemInfoByPanelName("KLPopoverPanel")
    if tbl then
        local showPos = tbl.showPos
        local pos = string.split(showPos, "#")
        if popy < -500 then
            if panel or npcpanel then
                --GUI:setLocalPosition(self.view.root,popx,tonumber(pos[2])+data.posY,popz)
                --SL:MainUIManager_SetMovePopoverPos(data.posY > 0)
            end
        else
            --GUI:setLocalPosition(self.view.root,popx,tonumber(pos[2])+data.posY,popz)
            --SL:MainUIManager_SetMovePopoverPos(data.posY > 0)
        end
    end
end


---外部设置气泡
function this:OutSetPopoverData(id, data)
    self:SetPopoverData(data.id)
    self:RefreshUI()
end

---关闭气泡
function this:ClosePopover(id, type)
    self:DelPopoverById(type)
end

function this:Close()
    if self.moveX then
        self.moveX:Kill()
        self.moveX = nil
    end
    if self.MonthTime then
        SL:UnSchedule(self.MonthTime)
        self.MonthTime = nil
    end
    if self.anim then
        GUI:DOKill(self.anim)
        self.anim = nil
        --logError("qipaohuishou")
    end
    if self.UpdateTimeSchedule then
        SL:UnSchedule(self.UpdateTimeSchedule)
    end
    self.UpdateTimeSchedule = nil
end

return this
