---@class KLUIChallengeBossItem:UIKmlLuaPanelBase
---@field view KLUIChallengeBossItemView
local KLUIChallengeBossItem = class(UIKmlLuaPanelBase)
local this = KLUIChallengeBossItem
---创建时调用一次
function this:Init()
    GUI:DataListInitData(self.view.line_data_list,function()
        return self:BossBtnDataListItemCountFunc()
    end,function(realIndex)
        return self:BossBtnDataListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:BossBtnDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:BossBtnDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    self.glod_boss_level_btn_all_item = {}
end

---创建或者刷新界面数据时调用
function this:Refresh()
    
end

function this:RefreshItem(data)
    self.data = data
    self.monsterid = data.monsterid
    self.cfg_BOSS_challenge = SL:GetConfigMultiKeys("cfg_BOSS_challenge",data.id,"id")
    InfoManager.uiHuntingDemonsInfo:SetIntegralInControl(self.view.Integral_BG,self.view.Integral_Text,self.monsterid)
    local tab = SL:GetConfigMultiKeys('cfg_monster', self.monsterid, 'id')
    local name = tab.name
    local level = data.level
    local appr = tab.appr
    local path = SL:GetConfigMultiKeys('cfg_model_monster', appr, 'id').path
    self.mapId = data.mapId
    self.mapMoveId = data.mapMoveId
    local monster_level = SL:GetConfig('cfg_monster', self.monsterid, 'id').level
    local nameStr = "<color=#e6e600>Lv." .. monster_level .. "</color> " .. name
    GUI:Text_setString(self.view.name,nameStr)
    local mscale = ""
    if self.data.size then
        local scale = math.ceil(self.data.size/100)
        mscale = scale .. "," .. scale .. "," .. scale
    end
    GUI:Model_setSrc(self.view.monster,path,mscale)
    if self.data.offset and #self.data.offset >= 2 then
        GUI:setPosition(self.view.monster,self.data.offset[1],self.data.offset[2])
       end
    self.all_line = {}
    self.all_MoveId = {}
    for i, v in ipairs(self.mapId) do
        table.insert(self.all_line,v)
    end
    for i, v in ipairs(self.mapMoveId) do
        table.insert(self.all_MoveId,v)
    end
    GUI:setVisible(self.view.img_select,false)
    GUI:DataListUpdateData(self.view.line_data_list)
end

function this:GetMonsterCount()
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_MONSTER_COUNT_BY_ID, {id=self.data.id,state=1})
end

---注册UI事件和服务器消息
function this:RegistEvents()

end


function this:OnclickIcon()
    
end


function this:BossBtnDataListItemCountFunc()
    return #self.all_line
end

function this:BossBtnDataListItemGetFunc(realIndex)
    local item = GUI:UIPanel_Open("dev/outui/ChallengeBoss/Item/KLUIChallengeBossLineItem/KLUIChallengeBossLineItem",self.view.line_data_list,self,{is_copy =2},true, 
            function(_item)
        local kmlCtrl = _item.view.root
        self.glod_boss_level_btn_all_item[kmlCtrl] = _item
        self:BossBtnDataListItemUpdateFunc(realIndex,kmlCtrl)
    end)
    
   return item.view.root
end

function this:BossBtnDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:BossBtnDataListItemUpdateFunc(realIndex, kmlcontrol)
    if self.glod_boss_level_btn_all_item[kmlcontrol] then
        local data = self.all_line[realIndex + 1]
        local move = self.all_MoveId[realIndex + 1]
        self.glod_boss_level_btn_all_item[kmlcontrol]:RefreshItem(self.monsterid,data,move,self,nil,self.cfg_BOSS_challenge,realIndex+1)
    end
end

function this:ShowSelectImg()
    GUI:setVisible(self.view.img_select,true)
end

function this:Close()
end

return this
