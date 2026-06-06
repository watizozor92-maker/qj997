---@class KLMonsterMapPointItemItem:UIKmlLuaPanelBase
---@field view KLMonsterMapPointItemItemView
local KLMonsterMapPointItemItem = class(UIKmlLuaPanelBase)
local this =KLMonsterMapPointItemItem
---创建时调用一次
function this:Init()
end

---创建或者刷新界面数据时调用
function this:Refresh()
end
function this:UpdateUI(data,OnClick,isSelect,luaIndex)
    ---@type MapProtos.MonsterStatus
    self.data= data
    self.Onclick=OnClick
    self.isSelect=isSelect
    self.luaIndex=luaIndex
    ---@type cfg_monster_column
    local monsterData=SL:GetConfig("cfg_monster",data.monsterid)
    local str = " <color=#FFB837>"..monsterData.name .." Lv." .. monsterData.level .."</color>"
    GUI:Text_setString(self.view.MonsterName,str)
    if not self.data.reliveTime or self.data.reliveTime == 0 then
        GUI:Text_setString(self.view.GoButtonText,"<color=#38FF26>前往</color>")
        GUI:setVisible(self.view.GoButtonText,true)
        GUI:setVisible(self.view.last_time,false)
    else
        local ServerTime = Time.GetServerTime()
        local reliveTime = self.data.reliveTime - ServerTime
        reliveTime = math.ceil(reliveTime/1000)
        GUI:setVisible(self.view.GoButtonText,false)
        GUI:setVisible(self.view.last_time,true)
        GUI:SetControl_time(self.view.last_time, reliveTime)
    end
    self:SetSelect(isSelect)
end
---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnTouchEvent(self.view.BG,self,function(ui, control, eventType, systemData)
        if eventType == EUIEventName.OnPointerClick then
            self.Onclick(self,self.data,self.luaIndex)
        end
    end)
            
end

function this:SetSelect(value)
    GUI:setVisible(self.view.select, value)
end
function this:Close()
    
end

return this
