---@class KLUIChallengeBossPosItem:UIKmlLuaPanelBase
---@field view KLUIChallengeBossPosItemView
local KLUIChallengeBossPosItem = class(UIKmlLuaPanelBase)
local this = KLUIChallengeBossPosItem
---创建时调用一次
function this:Init()

end

---创建或者刷新界面数据时调用
function this:Refresh()

end

function this:RefreshItem(data, mapId, panel)
    self.isOpen = true
    self.mapId = mapId
    self.panel = panel
    self.data = data
    self.monsterId = self.data.monsterId
    --self.monsterid = self.data
    self.x = self.data.x
    self.y = self.data.y
    self.relivetime = self.data.reviveTime
    --SL:LogError(self.relivetime)
    local tab = SL:GetConfigMultiKeys('cfg_repfairyland', self.mapId, 'id')

    local monster_tab = SL:GetConfigMultiKeys('cfg_monster', self.mapId, 'id')
    --local map_info = SL:FindConfigs("cfg_map_info","id",self.mapId)
    local name = self.data.monsterName

    local pos = "坐标 " .. self.x .. "," .. self.y
    self.is_dead = false
    GUI:Text_setString(self.view.name, name)
    GUI:Text_setString(self.view.pos_str, pos)
    GUI:Text_setString(self.view.info, "待击杀")
    if self.relivetime and self.relivetime ~= 0 and self.relivetime ~= "0" then
        self.relivetime = tonumber(self.relivetime)
        GUI:setVisible(self.view.info, false)
        GUI:setVisible(self.view.revive_time, true)
        local current_time = Time.GetServerTime()
        self.relivetime = math.ceil((self.relivetime - current_time) / 1000)
        if self.relivetime > 0 then
            SL:ScheduleOnce(self.relivetime + 0.5, function()
                self:RefreshData()
            end)
            GUI:SetControl_time(self.view.revive_time, self.relivetime)
            self.is_dead = true
        else
            GUI:setVisible(self.view.info, true)
            GUI:setVisible(self.view.revive_time, false)
        end
    else
        GUI:setVisible(self.view.info, true)
        GUI:setVisible(self.view.revive_time, false)
    end
 
    self:ReqFirst()
end

function this:RefreshData()
    if not self.isOpen then
        return
    end
    self.panel:GetBossList()
end

function this:HideItem()
    GUI:setVisible(self.view.level_select, false)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn, self, self.Onclick)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.SECRET_REALM_HURT_TOP1, self.FirstInfo, self)
end

function this:Onclick()
    SL:Pathfinding(self.mapId, 1, self.x, self.y,self.PosEnd)
end

function this:PosEnd()
    SL:StartOnHook(true,true,self.monsterId)
end

function this:ReqFirst()
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_SECRET_REALM_HURT_TOP1, { monsterId = self.monsterId })
end

function this:FirstInfo(id, message)
    if not self.isOpen then
        return
    end
    if self.is_dead then
        return
    end
    if message and message.monsterId and message.monsterId == self.monsterId then
        if message.name then
            local str = "伤害第一：" .. message.name
            GUI:Text_setString(self.view.info, str)
        end
    end
end

function this:RefreshFirstData()

end

function this:Close()
    self.isOpen = false
end

return this
