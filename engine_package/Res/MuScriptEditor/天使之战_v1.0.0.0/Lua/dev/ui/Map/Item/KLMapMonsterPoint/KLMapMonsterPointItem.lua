---@class KLMapMonsterPointItem:UIKmlLuaPanelBase
---@field view KLMapMonsterPointItemView
local KLMapMonsterPointItem = class(UIKmlLuaPanelBase)
local this = KLMapMonsterPointItem
---创建时调用一次
function this:Init()

end

---创建或者刷新界面数据时调用
function this:Refresh()
end
function this:SetActiveUI(val)
    if self.view.root.kmlControl:GetSource()==nil then
        return
    end
    GUI:SetActive(self.view.root, val)
end
function this:setScale(size)
    GUI:setScale(self.view.root, size)
end

function this:SetMonsterData(id,x,y)
    self.mosnterId = id
    self.x = x
    self.y = y
end

function this:SetPanelXY(x, y)
    GUI:setPosition(self.view.root, x, y)
end
function this:SetPanelRotation(rotation)
    GUI:setRotation(self.view.root, rotation)
end
function this:SetNormalDead()
    if self.data.type ~= MonsterType.NormalMonster then
        GUI:setGrey(self.view.Icon, true)
        GUI:Text_setString(self.view.Name, string.format("<color=%s>lv.%s%s</color>", "#706c6c",self.data.level , self.data.name))
    else
        GUI:setGrey(self.view.Icon, false)
        GUI:setVisible(self.view.Icon,false)
    end

end
function this:SetDead()
    GUI:Image_loadTexture(self.view.Icon, self.iconName, "Atlas/UIMapPanel.spriteatlas")
    GUI:Text_setString(self.view.Name, string.format("<color=%s>%s</color>", "#706c6c", self.txtName))
    if self.data.headPicture then
        SL:ScheduleOnce(self.data.headPicture, function()
            GUI:SetActive(self.view.Icon, true)
            GUI:Image_setGrey(self.view.Icon, true)
            GUI:SetImageNativeSize(self.view.Icon)
        end)
    else
        GUI:SetActive(self.view.Icon, true)
        GUI:Image_setGrey(self.view.Icon, true)
        GUI:SetImageNativeSize(self.view.Icon)
    end
end

function this:SetLive()
    GUI:SetActive(self.view.Icon, true)
    GUI:Image_setGrey(self.view.Icon, false)
    GUI:Image_loadTexture(self.view.Icon, self.iconName, "Atlas/UIMapPanel.spriteatlas")
    self:SetNormalTextColor()
    GUI:SetImageNativeSize(self.view.Icon)
end

-- 初始化或者刷新界面时调用（如果不需要刷新整个模板，另外写函数调用(推荐方式)）
function this:ShowBigMonsterIcon(v, isSpecial)
    GUI:SetActive(self.view.root, true)
    self.data = SL:GetConfig("cfg_monster",v.configId)
    self.iconName =  self.data.efficiencyLvIcon
    
    if  self.data.monsterShowIcon == 1 or isSpecial then
        GUI:SetActive(self.view.Icon, true)
        GUI:Image_loadTexture(self.view.Icon, self.iconName, "Atlas/UIMapPanel.spriteatlas")
    else
        GUI:SetActive(self.view.Icon, false)
    end
    GUI:SetImageNativeSize(self.view.Icon)
    GUI:SetActive(self.view.Lv, false)
    
    self.txtName = self:GetMonsterName(self.data,isSpecial)
    GUI:Text_setString(self.view.Name, self.txtName)
    self:SetNormalTextColor()
end

---@param monster cfg_monster_column
function this:GetMonsterName(monster,isSpecial)
    local txt = ""
    if  monster.monsterShowName == 1 or isSpecial then
        GUI:SetActive(self.view.Name, true)
        txt =  self.data.name
    end
    if  monster.monsterShowLv == 1 or isSpecial then
        txt = "lv." ..  self.data.level ..  self.data.name
    else
        GUI:SetActive(self.view.Lv, false)
    end
    return txt
end
---显示小怪图标
---@param monster cfg_monster_column
function this:ShowNormalMonsterIcon(monster)
    GUI:Text_setString(self.view.Name, self:GetMonsterName(monster))
    GUI:setGrey(self.view.Icon, false)
    GUI:SetActive(self.view.root, true)
    GUI:SetActive(self.view.Icon, true)
    GUI:SetActive(self.view.Lv, false)
    if monster then
        ---@type cfg_monster_column
        local monsterTbl = monster.data.monsterTbl
        self.data = monsterTbl
        if monsterTbl and monsterTbl.type and monsterTbl.level and monsterTbl.type ~= MonsterType.NormalMonster then
            if monsterTbl.efficiencyLvIcon then
                GUI:Image_loadTexture(self.view.Icon, monsterTbl.efficiencyLvIcon, "Atlas/UIMapPanel.spriteatlas")
            end
            if monsterTbl.name then
                self.txtName = "lv." .. monsterTbl.level .. monsterTbl.name
                self:SetNormalTextColor()
            else
                GUI:Text_setString(self.view.Name, "")
            end
        else
            GUI:Image_loadTexture(self.view.Icon, "img_minimap__shuaguaidian", "Atlas/UIMapPanel.spriteatlas")
            GUI:Text_setString(self.view.Name, "")
        end
    end
    GUI:SetImageNativeSize(self.view.Icon)

end

function this:SetNormalTextColor()
    if  self.data and self.data.txtColor then
        if SL:GetConfig("cfg_color", self.data.txtColor) then
            local strColor = SL:GetConfig("cfg_color", self.data.txtColor).color
            GUI:Text_setString(self.view.Name, string.format("<color=%s>%s</color>", strColor, self.txtName))
        end
    end
end
---注册UI事件和服务器消息
function this:RegistEvents()
end

function this:Close()
end

return this
