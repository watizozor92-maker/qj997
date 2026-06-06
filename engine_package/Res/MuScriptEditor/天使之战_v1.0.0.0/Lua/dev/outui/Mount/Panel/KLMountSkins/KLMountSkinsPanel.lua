---@class KLMountSkinsPanel:UIKmlLuaPanelBase
---@field view KLMountSkinsPanelView
local KLMountSkinsPanel = class(UIKmlLuaPanelBase)
local this =KLMountSkinsPanel
function this:AsyncLoadUI()
end
---创建时调用一次
function this:Init()
    self.skins = {}
    self.skinSelects = {}
    GUI:DataListInitData(self.view.skinDatas, function()
        return table.count(self.skins)
    end, function()
        
    end, function()
        
    end, function(realIndex)
        ---@type cfg_mount_skin_column
        local skin = self.skins[realIndex + 1]
        local btnSelect = GUI:GetChildControl(self.view.skinDatas, realIndex, 'btnSelect')
        local mountIcon = GUI:GetChildControl(self.view.skinDatas, realIndex, 'mountIcon')
        local notSelect = GUI:GetChildControl(self.view.skinDatas, realIndex, 'notSelect')
        local select = GUI:GetChildControl(self.view.skinDatas, realIndex, 'select')
        local lock = GUI:GetChildControl(self.view.skinDatas, realIndex, 'lock')
        local name = GUI:GetChildControl(self.view.skinDatas, realIndex, 'name')
        GUI:Text_setString(name, skin.name)
        local tbl = SL:GetConfig("cfg_mount", skin.skinid)
        GUI:Image_loadTexture(mountIcon, tbl.itemId, "Atlas/MountIcon.spriteatlas")
        self.skinSelects[skin.skinid] = {select = select, notSelect = notSelect, lock = lock}
        --显示皮肤拥有状态
        local mountData = self:GetMountData()
        if mountData then
            local isThis = mountData.curSkin == skin.skinid
            GUI:setVisible(lock,  not  InfoManager.mountInfo:CheckRideOwnSkin(self.mountId, skin.skinid))
            GUI:setVisible(select, isThis)
            GUI:setVisible(notSelect, not isThis)
        else
            GUI:setVisible(lock, true)
            GUI:setVisible(select, skin.skinid == self.mountId)
            GUI:setVisible(notSelect, skin.skinid ~=  self.mountId)
        end
        
        GUI:AddOnClickEvent(btnSelect, self, self.SkinOnClick, skin)
    end)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn_useSkin, self, self.UseSkin)
    SL:RegisterLUAEvent(LUA_EVENT_MOUNT_BUY_SKIN_CHANGE, self.LUA_EVENT_MOUNT_BUY_SKIN_CHANGE, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_SET_SKIN_MOUNT, self.RES_SET_SKIN_MOUNT, self)
end

---切换皮肤
function this:UseSkin()
    local mountData = self:GetMountData()
    if mountData and mountData.curSkin ~= self.nowSkin and  InfoManager.mountInfo:CheckRideOwnSkin(self.mountId, self.nowSkin)  then
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_SET_SKIN_MOUNT, {id=self.mountId, skinid = self.nowSkin})
    end
end

---购买皮肤响应
function this:LUA_EVENT_MOUNT_BUY_SKIN_CHANGE(_, id)
    if id == self.mountId then
        for skinId, v in pairs(self.skinSelects) do
            if skinId == 0 then
                GUI:setVisible(v.lock, false)
            else
                GUI:setVisible(v.lock,  not  InfoManager.mountInfo:CheckRideOwnSkin(self.mountId, skinId))
            end
        end
        --self:ChangeSkin(self.nowSkin)
        local mountData = self:GetMountData()
        if  InfoManager.mountInfo:CheckRideOwnSkin(self.mountId, self.nowSkin) then
            GUI:Text_setString(self.view.btn_useSkin,  self.nowSkin == mountData.curSkin and "<color=#00ff00>已启用</color>" or "启用")
        else
            GUI:Text_setString(self.view.btn_useSkin,  "<color=#FF2323>皮肤未解锁</color>")
        end
    end
end
---设置皮肤响应
function this:RES_SET_SKIN_MOUNT(_, message)
    if self.mountId == message.mountId then
        GUI:Text_setString(self.view.btn_useSkin, self.nowSkin == message.curSkin and "<color=#00ff00>已启用</color>" or "启用")
    end
end

function this:GetMountData()
    return InfoManager.mountInfo:GetMountData(self.mountId)
end

---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
    local mountId = self.args
    self.mountId = mountId
    local skins = InfoManager.mountInfo:GetMountSkins(mountId)
    if not skins then return end
    ---@type cfg_mount_column
    local tbl = SL:GetConfig("cfg_mount", mountId)
    table.insert(self.skins, {skinid = mountId, name = tbl.name, mountId = mountId})
    table.concatTable(self.skins, skins)
    
    local mountData = InfoManager.mountInfo:GetMountData(mountId)
    GUI:setVisible(self.view.rideLock,  mountData == nil)
    GUI:setVisible(self.view.btn_useSkin,  mountData ~= nil)
    if  mountData ~= nil then
        GUI:Text_setString(self.view.btn_useSkin, "<color=#00ff00>已启用</color>")
    end
    self.skinSelects = {}
    self:ChangeSkin( mountData and  mountData.curSkin or self.mountId)
    GUI:DataListUpdateData(self.view.skinDatas, true)
end

function this:ChangeSkin(skinId)
    if self.nowSkin and self.skinSelects[self.nowSkin] then
        GUI:setVisible(self.skinSelects[self.nowSkin].select, false)
        GUI:setVisible(self.skinSelects[self.nowSkin].notSelect, true)
    end
    self.nowSkin = skinId
    if self.skinSelects[self.nowSkin] then
        GUI:setVisible(self.skinSelects[self.nowSkin].select, true)
        GUI:setVisible(self.skinSelects[self.nowSkin].notSelect, false)
    end
    local mountData = self:GetMountData()
    if not mountData then
        return
    end
    if  InfoManager.mountInfo:CheckRideOwnSkin(self.mountId, skinId) then
        GUI:Text_setString(self.view.btn_useSkin, skinId == mountData.curSkin and "<color=#00ff00>已启用</color>" or "启用")
    else
        GUI:Text_setString(self.view.btn_useSkin,  "<color=#FF2323>皮肤未解锁</color>")
    end
end

---@param skin cfg_mount_skin_column
function this:SkinOnClick(a, skin)
    if self.nowSkin == skin.skinid then
        return
    end
    self:ChangeSkin(skin.skinid)
    ---@type KLMountDisplayPanel
    local ui = GUI:GetUI("dev/outui/Mount/Panel/KLMountDisplay/KLMountDisplayPanel")
    if ui then
        ui:ShowModel(skin.skinid)
        ui:ShowBuyRideSkin(skin)
    end
end

function this:Hide()
end

function this:Close()
end

return this
