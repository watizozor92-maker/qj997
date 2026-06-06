---@class KLUIChallengeBossHurtItem:UIKmlLuaPanelBase
---@field view KLUIChallengeBossHurtItemView
local KLUIChallengeBossHurtItem = class(UIKmlLuaPanelBase)
local this = KLUIChallengeBossHurtItem
---创建时调用一次
function this:Init()
    
end

---创建或者刷新界面数据时调用
function this:Refresh()
    
end

function this:RefreshItem(data,mapId,rank,panel)
    self.mapId = mapId
    self.panel = panel
    self.data = data
    --self.monsterid = self.data
    
    self.name = self.data.name
    self.hurt = self.data.hurt
    self.hurt = math.floor(self.hurt)
    self.hurtStr = self.panel:GetSimpleNumber(self.hurt,"")
    self.rank = rank
    self.rank_img = self.panel:GetRankImg(self.rank)
    GUI:Text_setString(self.view.name,self.name)
    GUI:Text_setString(self.view.value,tostring(self.hurtStr))
    GUI:Image_loadTexture(self.view.rank_img,self.rank_img,"Atlas/UIChallengeBoss.spriteatlas")
end



---注册UI事件和服务器消息
function this:RegistEvents()
    --GUI:AddOnClickEvent(self.view.btn,self,self.Onclick)
end

function this:Onclick()
    SL:Pathfinding(self.mapId, 1, self.x, self.y)
end




function this:OnclickIcon()
    self.panel:HideSelectLevel()
    GUI:setVisible(self.view.level_select,true)
    self.panel:SelectLevel(self.level,self)
end


function this:Close()
end

return this
