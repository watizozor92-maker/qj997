---@class KLGuideManager
KLGuideManager = {}
local this = KLGuideManager

function this.Init()
    this.showPanelList = {}
    this.now_guide_id_list = {}
    this.now_guide_next_list = {}
    
    this.rear_guide_list = {}
    this.first_guide_list = {}
    this.now_guide_to_first_guide = {}
    this.now_guide_to_pre_guide = {}
    this.career_last_guide = {}
    this.allTaskOnClickId = {}
    this.allTaskOnClick = {}
    this.InitData()
    this.RegistEvents()
    
end

function this.RegistEvents()
    SL:RegisterLUAEvent(LUA_EVENT_OPEN_UI,this.LUA_EVENT_OPEN_UI)
    SL:RegisterLUAEvent(LUA_EVENT_MAIN_UI_VISIBLE_AFTER,this.LUA_EVENT_MAIN_UI_VISIBLE_AFTER)
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN,this.LUA_EVENT_CLOSEWIN)
    
    SL:RegisterLUAEvent(LUA_EVENT_TASK_NEW,this.LUA_EVENT_TASK_NEW)
    SL:RegisterLUAEvent(LUA_EVENT_TASK_FINISH,this.LUA_EVENT_TASK_FINISH)
    SL:RegisterLUAEvent(LUA_EVENT_LEVELCHANGE,this.LUA_EVENT_LEVELCHANGE)
    
    SL:RegisterLUAEvent(LUA_EVENT_ENTER_MAP,this.LUA_EVENT_ENTER_MAP)
    --SL:RegisterLUAEvent(LUA_EVENT_CHANGESCENE,this.LUA_EVENT_CHANGESCENE)
    SL:RegisterLUAEvent(LUA_EVENT_BAG_CHANGE_AFTER,this.LUA_EVENT_BAG_CHANGE_AFTER)
    --SL:RegisterLUAEvent(LUA_EVENT_BAG_CHANGE_AFTER,this.LUA_EVENT_BAG_CHANGE_AFTER)

    SL:AddRedDotConditionFunc("checkTaskOnClick",this.checkTaskOnClick)
end

function this:LUA_EVENT_BAG_CHANGE_AFTER()
    this.UpdateGuide()
end

function this:LUA_EVENT_CHANGESCENE()
    this.UpdateGuide()
end

function this:LUA_EVENT_ENTER_MAP()
    this.Reset()
end

function this:LUA_EVENT_TASK_NEW()
    this.UpdateGuide()
end

function this:LUA_EVENT_TASK_FINISH()
    SL:ScheduleOnce(0.1,function()
        this.UpdateGuide() 
    end)
end

function this:LUA_EVENT_LEVELCHANGE()
    this.UpdateGuide()
end

function this.InitData()
    local rookie_guide_tbl = SL:GetConfigTable('cfg_rookie_guide')
    for _, rookieInfo in pairs(rookie_guide_tbl) do
        local rear_id = rookieInfo["rearGuide"]
        if rear_id then
            table.insert(this.rear_guide_list, rear_id)
        end
    end

    for _, rookieInfo in pairs(rookie_guide_tbl) do
        local now_id = rookieInfo["id"]
        if not table.contains(this.rear_guide_list, now_id) then
            table.insert(this.first_guide_list, rookieInfo)
        end
    end

    -- 保存每个引导的起始引导
    for _, rookieInfo in pairs(this.first_guide_list) do
        local nowId = rookieInfo["id"]
        local rearId = rookieInfo["rearGuide"]
        this.now_guide_to_first_guide[nowId] = nowId
        while rearId ~= 0 do
            this.now_guide_to_first_guide[rearId] = nowId
            rearId = SL:GetConfig('cfg_rookie_guide', rearId).rearGuide
        end
        
    end

    -- 保存当前引导的上一个引导
    for _, rookieInfo in pairs(rookie_guide_tbl) do
        local nowId = rookieInfo["id"]
        local rearId = rookieInfo["rearGuide"]
        if rearId ~= 0 then
            this.now_guide_to_pre_guide[rearId] = nowId
        end
    end
    -- 获取每个职业的最后一个引导
    for _, rookieInfo in pairs(rookie_guide_tbl) do
        local sequence = rookieInfo["sequence"]
        for i, v in pairs(sequence) do
            if this.career_last_guide[v[1]] == nil then
                this.career_last_guide[v[1]] = {sort = v[2],id = rookieInfo.id}
            else
                if this.career_last_guide[v[1]].sort < v[2] then
                    this.career_last_guide[v[1]] = {sort = v[2],id = rookieInfo.id}
                elseif this.career_last_guide[v[1]].sort == v[2] and this.career_last_guide[v[1]].id < rookieInfo.id then
                    this.career_last_guide[v[1]] = {sort = v[2],id = rookieInfo.id}
                end
            end
        end
    end
end

function this.getMaxGuideId()
    if this.career_last_guide then
        local job = SL:GetMetaValue(EMetaVarGetKey.JOB)
        if this.career_last_guide[0] and this.career_last_guide[0].sort > this.career_last_guide[job].sort then
            return this.career_last_guide[0].id
        else
            return this.career_last_guide[job].id
        end
    end
end

function this.addRookieGuide(guideId)
    if this.showPanelList[guideId] == nil then
        if this.CheckUiIsActive(guideId) then
            this.showPanelList[guideId] = {}
            ---@type KLRookieGuidePanel
            GUI:UIPanel_Open("dev/outui/Guide/Panel/KLRookieGuide/KLRookieGuidePanel",nil, nil, {guideId=guideId}, true,
            function(panel)
                this.showPanelList[guideId] = panel
            end)
            
            if not table.contains(this.now_guide_id_list, guideId) then
                table.insert(this.now_guide_id_list, guideId)
            end
        end
    end
end

function this.CheckRookieGuide(guideId)
    if this.showPanelList[guideId] == nil then
        if this.CheckUiIsActive(guideId) then
            this.showPanelList[guideId] = {}
            ---@type KLRookieGuidePanel
            GUI:UIPanel_Open("dev/outui/Guide/Panel/KLRookieGuide/KLRookieGuidePanel",nil, nil, {guideId=guideId}, true,
            function(panel)
                this.showPanelList[guideId] = panel
            end)
            
            if not table.contains(this.now_guide_id_list, guideId) then
                table.insert(this.now_guide_id_list, guideId)
            end
        end
    end
end


function this:LUA_EVENT_MAIN_UI_VISIBLE_AFTER(info)
    local vis = info.vis
    local name = info.name
    if vis then
        SL:ScheduleOnce(0.1,function()
            this.UiShowGuide(name)
        end)
        --Coroutine.Start(this.UiShowGuide,name)
    else
        this.UiHide(name)
    end
end

---@param win UIKmlLuaPanelBase
function this:LUA_EVENT_OPEN_UI(win)
    if win then
        local openPanelName = win.panelName
        SL:ScheduleOnce(0.1,function()
            this.UiShowGuide(openPanelName)
        end)
        --Coroutine.Start(this.UiShowGuide,openPanelName)
        --this.UiShowGuide(openPanelName)
    end
end

function this.UiShowGuide(name)
    --Coroutine.Wait(0.1)
    --Coroutine.WaitForEndOfFrame()
    local already_first_guide_list = this.GetFirstGuideIdList()

    for _, rookie_info in pairs(this.first_guide_list) do
        local nowId = rookie_info["id"]
        if not table.contains(already_first_guide_list, nowId) then

            local conditions = rookie_info["conditions"]

            local panel_info = string.split(rookie_info["uiAddress"], '&')
            local panel_id = panel_info[1]
            if panel_id == name then
                if SL:CheckCondition(conditions) then
                    this.addRookieGuide(nowId)
                end
            end
        end
    end

    for _, nowId in pairs(this.now_guide_next_list) do
        local rookie_info = SL:GetConfig('cfg_rookie_guide', nowId)
        if not table.contains(already_first_guide_list, nowId) then
            local conditions = rookie_info["conditions"]
            local panel_info = string.split(rookie_info["uiAddress"], '&')
            local panel_id = panel_info[1]
            if panel_id == name then
                if SL:CheckCondition(conditions) then
                    this.CheckRookieGuide(nowId)
                end
            end
        end
    end
end

function this.HideGuide(guideId)
    local panel = this.showPanelList[guideId]
    if panel then
        GUI:UIPanel_Close(nil, panel)
        this.showPanelList[guideId] = nil
    end
end

function this:LUA_EVENT_CLOSEWIN(panelName)
    this.UiHide(panelName)
end

function this.UiHide(panelName)
    if not next(this.now_guide_next_list) and not next(this.now_guide_id_list) then
        return
    end

    for index, guideId in pairs(this.now_guide_id_list) do
        local rookie_info = SL:GetConfig('cfg_rookie_guide', guideId)
        local panel_info = string.split(rookie_info["uiAddress"], '&')
        local panel_id = panel_info[1]
        if panel_id == panelName then
            this.HideGuide(guideId)
            this.now_guide_id_list[index] = nil
        end
    end

    for index, guideId in pairs(this.now_guide_next_list) do
        local rookie_info = SL:GetConfig('cfg_rookie_guide', guideId)
        local panel_info = string.split(rookie_info["uiAddress"], '&')
        local panel_id = panel_info[1]
        if panel_id == panelName then
            this.HideGuide(guideId)
            this.now_guide_next_list[index] = nil
        end
    end
    
end

-- 获取正在引导的首个组id列表
function this.GetFirstGuideIdList()
    local resultList = {}

    for _, guideId in pairs(this.now_guide_id_list) do
        table.insert(resultList, guideId)
    end

    for _, guideId in pairs(this.now_guide_next_list) do
        local firstId = this.now_guide_to_first_guide[guideId]
        if firstId then
            table.insert(resultList, firstId) 
        end
    end
    
    return resultList
end

function this.CheckUiIsActive(guideId)
    local rookieCfg = SL:GetConfig('cfg_rookie_guide', guideId)
    local address = rookieCfg.uiAddress
    local panelId
    if address then
        local panel_ui = GUI:GetUIByPanelName(panelId)
        if GUI:IsUILoading(panel_ui) then
            --界面还没加载完开始引导会定位出错
            return false
        end
        local contrTransform
        -- 弹出的特殊处理
        if table.contains(rookieCfg.showType, EGuideShowType.ToProp) then
            contrTransform = GUI:GetPanelTransform(address)
            panelId = address
        else
            
            local addrSplit = string.split(address, '&')
            panelId = addrSplit[1]
            local contrName = addrSplit[2]
            contrTransform = GUI:GetControlTransform(panelId, contrName)
    
            if panelId == "KLBigMapPanel" or (not string.isNullOrEmpty(rookieCfg.args) and GUI:GetPanelTransform(panelId))  then
                return true
            end
        end
        
        if MainUiStateManager.showPanelMap[panelId] ~= nil then
            return MainUiStateManager.showPanelMap[panelId]
        end

        if not contrTransform then
            return false
        end
        
        return contrTransform.gameObject.activeSelf
    end
    
    return false
end

-- 更新引导
function this.UpdateGuide()

    for index, guideId in pairs(this.now_guide_id_list) do
        local rookieCfg = SL:GetConfig('cfg_rookie_guide', guideId)
        local conditions = rookieCfg["conditions"]
        if not SL:CheckCondition(conditions) then
            this.HideGuide(guideId)
            this.now_guide_id_list[index] = nil
        end
    end

    for index, guideId in pairs(this.now_guide_next_list) do
        local rookieCfg = SL:GetConfig('cfg_rookie_guide', guideId)
        local conditions = rookieCfg["conditions"]
        if not SL:CheckCondition(conditions) then
            this.HideGuide(guideId)
            this.now_guide_next_list[index] = nil
        end
    end
    
    local already_first_guide_list = this.GetFirstGuideIdList()
    for _, guideInfo in pairs(this.first_guide_list) do
        local guideId = guideInfo["id"]
        if not table.contains(already_first_guide_list, guideId) then
            if SL:CheckCondition(guideInfo["conditions"]) then
                this.addRookieGuide(guideId)
            end
        end
    end
    
end

function this.SetNextGuide(rearId)
    local preId = this.now_guide_to_pre_guide[rearId]
    if preId then
        if table.contains(this.now_guide_id_list, preId) then
            this.HideGuide(preId)
            table.removeByValue(this.now_guide_id_list, preId)
            table.insert(this.now_guide_next_list, rearId)
            --Coroutine.Start(function()
            --    Coroutine.WaitForEndOfFrame()
            --    this.CheckRookieGuide(rearId)
            --end)

            SL:ScheduleOnce(0.1,function()
                this.CheckRookieGuide(rearId)
            end)

        elseif table.contains(this.now_guide_next_list, preId) then
            this.HideGuide(preId)
            table.removeByValue(this.now_guide_next_list, preId)
            table.insert(this.now_guide_next_list, rearId)
            --Coroutine.Start(function()
            --    Coroutine.WaitForEndOfFrame()
            --    this.CheckRookieGuide(rearId)
            --end)
            
            SL:ScheduleOnce(0.1,function()
                this.CheckRookieGuide(rearId)
            end)
        end
    end
end

function this.AddPointControlGuide(panelId, contrId, guideId)
    local panel = this.showPanelList[guideId]
    if panel then
        panel:AddPointControlGuide(panelId, contrId, guideId)
    end
end

function this.HidePointControlGuide(guideId)
    local panel = this.showPanelList[guideId]
    if panel then
        panel:HidePointControlGuide()
    end
end

function this.Reset()
    for guideId, showPanel in pairs(this.showPanelList) do
        this.HideGuide(guideId)
    end
    this.showPanelList = {}
    this.now_guide_id_list = {}
    this.now_guide_next_list = {}
    this.allTaskOnClickId = {}
    this.allTaskOnClick = {}
end

--checkTaskOnClick[110005]=1

--检查任务点击
function this.checkTaskOnClick(condition)
    if not this.allTaskOnClickId then
        return false
    end
    if not this.allTaskOnClickId[condition] then
        local conditionValue = string.split(condition, "=")[1]
        local split = string.split(conditionValue, "[")
        local id_str = split[2]
        id_str = string.replace(id_str,']')
        this.allTaskOnClickId[condition] = tonumber(id_str)
    end
    local id = this.allTaskOnClickId[condition]
    if this.allTaskOnClick[id] then
        return this.allTaskOnClick[id]
    end
    return false
end

function this.SetTaskOnClickStatus(taskId)
    local status = SL:GetTaskState(taskId)
    local cfg_task = SL:GetConfig("cfg_task",taskId)
    local tab = SL:GetConfig("cfg_task_target",cfg_task.taskTargetId[1])
    if status == 1 and tab.taskGoalType == 50 then
        this.allTaskOnClick[taskId] = true
        if tab.id == 1050006 then -- 查看交易行
            KLGuideManager.UiShowGuide("KLUISystemTopPanel")
        else
            KLGuideManager.UiShowGuide("KLUIPlayerInfoPanel")
        end
    end
end


return this