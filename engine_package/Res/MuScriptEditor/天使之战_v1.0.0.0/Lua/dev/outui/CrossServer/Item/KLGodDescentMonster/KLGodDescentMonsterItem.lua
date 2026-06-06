---@class KLGodDescentMonsterItem:UIKmlLuaPanelBase
---@field view KLGodDescentMonsterItemView
local KLGodDescentMonsterItem = class(UIKmlLuaPanelBase)
local this =KLGodDescentMonsterItem

---创建时调用一次
function this:Init()
    local monsterId = self.args.id
    self.monsterId = tostring(monsterId)
    self.cfgId = self.args.cfgId
    ---@type cfg_monster_column
    local tbl = SL:GetConfig('cfg_monster', monsterId)
    GUI:Text_setString(self.view.txt_Name, tbl.name)
    local pic = self.args.pic
    GUI:Image_loadTexture(self.view.img_info, pic, "Atlas/KLCrossServer.spriteatlas")
    
    self:UpdateMonsterData()
end

--刷新数据
function this:UpdateMonsterData()
    local datas = InfoManager.godsDescendInfo.GetMonsterInfosByCfgId(self.monsterId)
    if not datas then
        datas = {}
    end
    GUI:Text_setString(self.view.txt_Status, "<color=#FF2323>未刷新</color>")
    GUI:Text_setString(self.view.txt_Status2, "<color=#FF2323>未刷新</color>")
    local index = 1
    local allKilled = true
    ---@param data {id:number, cfgid:number, name:string, state:number, ownerid:number, ownername:string}
    for _, data in pairs(datas) do
        local view = index == 1 and self.view.txt_Status or self.view.txt_Status2
        if data.ownername and not string.isNullOrEmpty(data.ownername) then
            GUI:Text_setString(view, string.format("<color=#00ff00>%s</color>", data.ownername))
        else
            GUI:Text_setString(view, "<color=#FF2323>无归属</color>")
        end
        if data.state ~= 2 then
            --已死亡
            allKilled = false
        end
        index = index + 1
    end
    GUI:setVisible(self.view.img_kill, allKilled and table.count(datas) > 0)
end

---注册UI事件和服务器消息
function this:RegistEvents()
end

---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
end

function this:Close()
end

return this
