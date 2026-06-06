---@class SafeAreaPickUpManager
SafeAreaPickUpManager = {}
local this = SafeAreaPickUpManager

function this:Init()
    self:RegistEvents()
    self.dropItemList = {}
end

function this:Reset()
    self.dropItemList = {}
    self.hookState = EAutoOnHookStatus.StopOnHook
    self.moveId = nil
    if self.nextFrameWalk then
       SL:UnSchedule(self.nextFrameWalk)
       self.nextFrameWalk = nil 
    end
end


function this:RegistEvents()
    SL:RegisterLUAEvent(LUA_EVENT_ONHOOK_STATE_CHANGE, self.LUA_EVENT_ONHOOK_STATE_CHANGE, self)
    SL:RegisterLUAEvent(LUA_EVENT_CREATE_DROPITEM, self.LUA_EVENT_CREATE_DROPITEM, self)
    SL:RegisterLUAEvent(LUA_EVENT_REMOVEMAPOBJECT, self.LUA_EVENT_REMOVEMAPOBJECT, self)
    SL:RegisterLUAEvent(LUA_EVENT_ACTOR_Update_OF_VIEW, self.LUA_EVENT_ACTOR_Update_OF_VIEW, self)
    SL:RegisterTrigger(LUA_TRIGGER_MOVE_PICK_UP_ITEM, self.LUA_TRIGGER_MOVE_PICK_UP_ITEM, self)
end

--自动挂机状态变化
function this:LUA_EVENT_ONHOOK_STATE_CHANGE(_, state)
    self.hookState = state
end

function this:LUA_EVENT_CREATE_DROPITEM(_, item)
    --自动拾取不触发此逻辑
    if SL:GetPlayerAutoPickIsOpen() then
        -- --新需求 自动拾取需要等待4s后再拾取
        -- local isFastPickUp = SL:onTriggerEvent(LUA_TRIGGER_FAST_RANGE_PICKUP, item.dropGroupId,item.serverData.item.cfgId)
        -- if isFastPickUp == nil or isFastPickUp then
        --     item.waitPickUpTime = SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME) + self.autoPickWaitTime
        -- end
       return 
    end
    --自动战斗状态下不会触发此拾取逻辑
    if self.hookState == EAutoOnHookStatus.OnHooking then
       return 
    end
    local metaId = tonumber(SL:GetMetaValue(EMetaVarGetKey.USER_ID))
    --SL:GetMetaValue(EMetaVarGetKey.GET_IS_SAFEAREA) and 
    if not table.isNullOrEmpty(item.serverData.ownerId) and table.contains(item.serverData.ownerId,metaId) then
        table.insert(self.dropItemList, item)
    end
    --table.insert(self.dropItemList, item)
    self:PathMove() 
end

--寻路
function this:PathMove()
    if table.isNullOrEmpty(self.dropItemList) then
       return 
    end
    if self.hookState == EAutoOnHookStatus.OnHooking then
       return 
    end
    --自动拾取不触发此逻辑
    if SL:GetPlayerAutoPickIsOpen() then
       return 
    end
    if self.nextFrameWalk then
       SL:UnSchedule(self.nextFrameWalk)
       self.nextFrameWalk = nil 
    end
    --延迟一帧执行
    self.nextFrameWalk = SL:ScheduleOnce(Time.deltaTime, function()
        local item = self:GetNextDropItem()
            --logError("触发寻路000000000000")
        if item and not self.moveId then
            --logError("触发寻路111111111111111")
            local arriveFuncData = {}
		    arriveFuncData.IsAutoFight = false
		    arriveFuncData.callBack = function()
			    this.moveId = nil
	        end
            self.moveId = item.itemId
            SL:Me_StopMove(true, true)
            SL:Me_TriggerToMove(Dot2.New(math.round(item.serverData.x), math.round(item.serverData.y)), nil, nil,
         arriveFuncData, true, nil, nil, false, true)        
        end
    end)
end

--获取下一个拾取的对象
function this:GetNextDropItem()
    local dropItems = SL:GetMetaValue(EMetaVarGetKey.GET_MONSTER_DROP_ITEM_LIST)
    if not dropItems then
        return
    end
    for i = 1, #self.dropItemList, 1 do
        local item = self.dropItemList[i]
        --确保有这个凋落物
        if dropItems[item.itemId] then
            if i > 1 then
                for j = 1, i do
                    table.remove(self.dropItemList, 1)
                end 
            end
            return item
        end
    end
end

---凋落物被拾取
function this:LUA_EVENT_REMOVEMAPOBJECT(_, itemId)
   for k, v in pairs(self.dropItemList) do
        if v.itemId == itemId then
            if  self.moveId and itemId == self.moveId then
                self.moveId = nil
            end
            table.remove(self.dropItemList, k)
            self:PathMove()
            break
        end
   end 
end

---凋落物掉出视野
function this:LUA_EVENT_ACTOR_Update_OF_VIEW(_, message)
    if not table.isNullOrEmpty(message.removeId) then
       for _, removeId in pairs(message.removeId) do
            for k, item in pairs(self.dropItemList) do
                if item.itemId == removeId then
                    if  self.moveId and removeId == self.moveId then
                        self.moveId = nil
                    end
                    table.remove(self.dropItemList, k)
                    break
                end
            end 
       end 
    end
end
function this.LUA_TRIGGER_MOVE_PICK_UP_ITEM(_, item)
    if item.isPick then
        local roleId = SL:GetMetaValue(EMetaVarGetKey.USER_ID)
        if item.pickUpRid and tonumber(roleId) == item.pickUpRid then
            local global = SL:GetConfig("cfg_string", 60002)
            SL:TipMessage(global.text, 1, NoticeType.NoticeMid) 
        else
            local global = SL:GetConfig("cfg_string", 60001)
            SL:TipMessage(global.text, 1, NoticeType.NoticeMid) 
        end
    end
    return item.isPick
end
return this