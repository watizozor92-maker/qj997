---@class KLDailyActivityItem:UIKmlLuaPanelBase
---@field view KLDailyActivityItemView
local KLDailyActivityItem = class(UIKmlLuaPanelBase)
local this =KLDailyActivityItem
---创建时调用一次
function this:Init()
    --一个显示地图名字
    self.itemPool = TablePool()
    ----@type UIKmlLuaControl[]
    self.itemList = {}
    --一个显示怪物数量
    self.itemPool_2 = TablePool()
    ----@type UIKmlLuaControl[]
    self.itemList_2 = {}
end

---创建或者刷新界面数据时调用
function this:Refresh()
    --GUI:SetActive(self.view.btn_go,self.args)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn_go,self,self.BtnGoOnClick)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.MONSTER_ATTACK_BOSS_INFO,self.MONSTER_ATTACK_BOSS_INFO,self)
end

----怪物来袭
function this:MONSTER_ATTACK_BOSS_INFO(_,message)
    local mapList = {}
    for k,v in pairs(message) do
        if not mapList[v.mapCfgId] then
            mapList[v.mapCfgId] = { }
        end
        table.insert(mapList[v.mapCfgId],v)
    end
    table.sort(mapList,function(a,b)
        if a < b then
            return true
        end
        return false
    end)
    self:RefreshMonsterInfo(mapList)
end

function this:BtnGoOnClick()
    local tbl = SL:GetConfig("cfg_activity_rule", self.data.id)
    ---狼魂要塞
    if self.data.id == EActivityType.WolfSoulFortress then
        ---@type cfg_rep_column
        local tempTbl = InfoManager.wolfSoulFortressInfo:GetCfgByOpenServerDay()
        local wolfSoulFortressInfo = InfoManager.activityPreviewInfo:GetActivityInfo(EActivityType.WolfSoulFortress)
        if not wolfSoulFortressInfo.open then
            SL:TipMessage(SL:GetConfig('cfg_string',250).text, 1, NoticeType.NoticeMid)--"活动未开启",
            return
        end
        ---没有公会
        if SL:MeData_GetUnionId() == 0 then
            SL:TipMessage(SL:GetConfig('cfg_string', 433).text, 1, NoticeType.NoticeMid )
            return
        end
        if tempTbl then
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_ENTER_DUPLICATE, tempTbl.id)
        end
    elseif tbl.mapid and table.count(tbl.mapid) >0 and tbl.mapid[1] == 21000 then
        --进入跨服神之国度
        local cond, message = InfoManager.godsDescendInfo.CheckActivityConditionMapId(self.data.id)
        if cond then
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_GOTO_CROSS_MAP,{})
        else
            SL:TipMessage(message, 1, NoticeType.NoticeMid)
        end
    elseif self.data.id == EActivityType.LoranSiege then--罗兰攻城战
        ---@type cfg_system_switch_column
        local systemCfg = SL:GetConfig("cfg_system_switch", 207)
        local isMeet = SL:GetMetaValue(EMetaVarGetKey.IS_OPEN_SYSTEMFUNCTION, systemCfg.systemName)
        if not isMeet then
            SL:TipMessage(SL:GetConfig('cfg_string',250).text, 1, NoticeType.NoticeMid)--"活动未开启",
            return
        end
    else
        shortcutOutMgr.DO(self.data.panel)
        GUI:UIPanel_Close("dev/outui/DailyGoal/Panel/KLDailyGoalMain/KLDailyGoalMainPanel")
    end
end

function this:Close()
    self:Recycle()
    if self.timer then
        --Timer.Stop(self.timer)
        SL:UnSchedule(self.timer)
        self.timer = nil
    end
end

---更新数据
---@param data cfg_activity_rule_column 数据
function this:UpdateData(data)
    self.data = data
    GUI:SetID(self.view.root,"daily_activity_item_" .. self.data.id)
    GUI:Text_setString(self.view.txt_title,data.name)
    GUI:Image_loadTexture(self.view.img_bg,data.uiBg,"Atlas/DailyGoal.spriteatlas")
    GUI:Text_setString(self.view.txt_rule_content,data.uiTextRule)
    GUI:Text_setString(self.view.txt_condition,self:format_time(data.uiTextSynopsis))

    --self.view.list_reward.kmlControl:HideAllChilds()
    GUI:RemoveAllChildren(self.view.list_reward)
    for _,v in ipairs(data.uiReward) do
        local item = GUI:Item_Create(self.view.list_reward,{
            width = "60",
            height = "60",
            itemid = v,
            tips = "1",
            mfixsize = "60,60",
        })
        local btn = GUI:Button_Create(item,{
            width = "60",
            height = "60",
            color="#00000000",
            raycast="1",
            id ="ben222"
        })
        GUI:AddOnClickEvent(btn,self,self.ItemOnClick,v)
    end
    local myLevel = SL:GetMetaValue(EMetaVarGetKey.LEVEL)
    GUI:SetActive(self.view.btn_go,self.args and myLevel >= data.level)
    if data.id == EActivityType.FieryDragon then
        local myLevel = SL:GetMetaValue(EMetaVarGetKey.LEVEL)
        GUI:SetActive(self.view.monsterInfoRoot,self.args and myLevel >= data.level)
        SL:SendLuaNetMsg(LuaMessageIdToSever.MONSTER_ATTACK_BOSS_INFO,10008)
        if not self.timer then
--[[            self.timer = Timer.StartLoopForever(10,function()
                SL:SendLuaNetMsg(LuaMessageIdToSever.MONSTER_ATTACK_BOSS_INFO,10008)
            end, self)]]
            self.timer = SL:Schedule(self.timer,0,10,-1,function()
                SL:SendLuaNetMsg(LuaMessageIdToSever.MONSTER_ATTACK_BOSS_INFO,10008)
            end, self)
        end
    else
        GUI:SetActive(self.view.monsterInfoRoot,false)
    end
end

function this:RefreshMonsterInfo(message)
    self:Recycle()
    for k,v in pairs(message) do
        ---@type UIKmlLuaControl
        local item = self.itemPool:Pop()
        local item_2 = self.itemPool_2:Pop()
        ----@type cfg_map_info_column
        local mapCfg = SL:GetConfig("cfg_map_info",k)
        if not next(item) and not next(item_2) then
            item = GUI:Button_Create(self.view.monsterMapRoot,{
                id = "btn1",
                text = mapCfg.mapname,
                fontsize = "18",
                raycast = "1",
                color="#00000000",
                width="125",
                height = "18",
                textcolor =EColor[EGradColor.green]
            })
           GUI:AddOnClickEvent(item,self,function()
               SL:MapTransfer(tonumber(mapCfg.id),1)
           end)
            item_2 = GUI:Text_Create(self.view.monsterCountRoot,{
                text = string.format("剩余%s只",table.count(v)),
                ta = "01",
                fontsize = "18",
                src = ""
            })
        end
        --GUI:Text_setTextColor(item,EColor[EGradColor.green])
        GUI:Text_setTextColor(item_2,EColor[EGradColor.green])
        GUI:SetActive(item,true)
        GUI:SetActive(item_2,true)
        self.itemList[k] = item
        self.itemList_2[k] = item_2
    end
end

function this:Recycle()
    for _, v in pairs(self.itemList) do
        GUI:SetActive(v,false)
        self.itemPool:Push(v)
    end
    self.itemList = {}    
    for _, v in pairs(self.itemList_2) do
        GUI:SetActive(v,false)
        self.itemPool_2:Push(v)
    end
    self.itemList_2 = {}
end

function this:ItemOnClick(_,b)
    SL:OpenTips(nil,b)
end

function this:format_time(input)
    -- 验证是否为有效时间范围格式，并选择性替换
    local pattern = "^%d%d:%d%d:%d%d%-%d%d:%d%d:%d%d$"

    -- 仅当完全匹配时间格式时才进行替换
    if input:match(pattern) then
        return input:gsub("(%d%d:%d%d):%d%d", "%1", 2)  -- 替换两次确保安全
    else
        return input
    end
end

return this
