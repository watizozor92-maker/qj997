---@class KLWolfSoulFortressSummonItem:UIKmlLuaPanelBase
---@field view KLWolfSoulFortressSummonItemView
---@field data {}
local KLWolfSoulFortressSummonItem = class(UIKmlLuaPanelBase)
local this = KLWolfSoulFortressSummonItem

---创建时调用一次
function this:Init()
end

function this:InitData()

end
---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btnSummon, self, self.SummonOnclick)
end

---召唤
function this:SummonOnclick()
    if self.data then
        ---召唤次数有限制
        if InfoManager.wolfSoulFortressInfo.summonCount > InfoManager.wolfSoulFortressInfo.nowWolfSoulCfg.guardians then
            SL:TipMessage( SL:GetConfig('cfg_string', 332).text, 1, NoticeType.NoticeMid )--"召唤次数已满！",
            return
        end
        ---只有准别阶段可以召唤
        if InfoManager.wolfSoulFortressInfo.state > 1 then
            SL:TipMessage( SL:GetConfig('cfg_string', 333).text, 1, NoticeType.NoticeMid )--"准备阶段外不能召唤！",
            return
        end
        ---道具需求
        local haveCount = SL:GetBagItemCount(self.data[2])
        if haveCount < self.data[3] then
            SL:TipMessage( SL:GetConfig('cfg_string', 431).text, 1, NoticeType.NoticeMid )--"战盟资金不足，无法召唤！",
            return
        end
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_WOLF_SOUL_SUMMON, self.data[1])
    end
end

---界面显示时调用一次
function this:Show()
end

---创建或者刷新界面数据时调用
function this:Refresh()
end
---类型#货币#数量
function this:RefreshItem(message)
    self.data = message.data
    self.index = message.index
    if self.data then
        ---@type cfg_monster_column
        local monsterCfg = SL:GetConfig("cfg_monster", self.data[1])
        ---@type cfg_item_column
        local itemCfg = SL:GetConfig("cfg_item", self.data[2])
        GUI:Text_setString(self.view.name, monsterCfg.name)
        GUI:Text_setString(self.view.btnSummon, string.format("%s:<color=#EDD194FF>%s</color>", itemCfg.name, self.data[3]))
        self:InitModel(monsterCfg)
    end
    GUI:SetActive(self.view.specialBg,false)
    GUI:SetActive(self.view.specialBg_2,false)
    ---策划说写死...
    if self.index  == 1 then
        
    elseif self.index  == 2 then
        GUI:SetActive(self.view.specialBg,true)
        GUI:Text_setString(self.view.textSpecial,"最多同时攻击3个单位")
    else
        GUI:SetActive(self.view.specialBg,true)
        GUI:SetActive(self.view.specialBg_2,true)
        GUI:Text_setString(self.view.textSpecial,"最多同时攻击5个单位")
        GUI:Text_setString(self.view.textSpecial_2,"额外造成5%生命上上限伤害")
    end
    GUI:Image_loadTexture(self.view.rank,"quality_"..self.index, "Atlas/UIWolfSoulFortress.spriteatlas")
end

function this:InitModel(monsterCfg)
    local appr = monsterCfg.appr
    local path = SL:GetConfigMultiKeys('cfg_model_monster', appr, 'id').path
    GUI:Model_setSrc(self.view.model, path)
end

function this:Close()
end

return this
