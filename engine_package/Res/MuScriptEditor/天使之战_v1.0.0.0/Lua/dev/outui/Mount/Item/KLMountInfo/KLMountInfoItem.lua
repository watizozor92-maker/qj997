---@class KLMountInfoItem:UIKmlLuaPanelBase
---@field view KLMountInfoItemView
---@field baseUI KLMountStorePanel
local KLMountInfoItem = class(UIKmlLuaPanelBase)
local this =KLMountInfoItem
---创建时调用一次
function this:Init()
    GUI:SetZIndex(self.view.wear_mount_icon, 400)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    ---@type cfg_mount_column
    local mount_tbl = SL:GetConfig("cfg_mount",self.args.mountId)
    ---@type cfg_item_column
    local itemTbl = SL:GetConfig("cfg_item",mount_tbl.itemId)
    ---@type cfg_color_column
    local colorTbl = SL:GetConfig("cfg_color",itemTbl.color)
    GUI:setVisible(self.view.select,self.args.mountId == self.baseUI.curSelectMount)
    local mountName = self.args.mountName
    local mountData = InfoManager.mountInfo:GetMountData(self.args.mountId)
    if mountData and mountData.level > 0 then
        mountName = mountName.."+"..mountData.level
    end
    GUI:Text_setString(self.view.mountName,GUIUtil.GetColorText(mountName,colorTbl.color))
    self:UpdateGainState()

    local mount_model_tbl = SL:GetConfig("cfg_mount_model",mount_tbl.mountId,"id")
    local modelPath = mount_model_tbl.path
    local scale = mount_tbl.scale2.. ",".. mount_tbl.scale2 ..",".. mount_tbl.scale2


    ---@type cfg_model_charactor_column
    local model_tbl = SL:GetConfig("cfg_model_charactor",itemTbl.shape[1],"id")
    GUI:Model_setSrc(self.view.item_model,modelPath,nil,"0,200,0",nil,"50,50")
    --GUI:SetEulerAngles(self.view.item_model,model_tbl.inrotate[1],model_tbl.inrotate[2],model_tbl.inrotate[3])
    --GUI:setScale(self.view.item_model,mount_tbl.scale2)
    GUI:setVisible(self.view.wear_mount_icon,self.args.mountId == InfoManager.mountInfo:GetDefaultMountId())
    self:ShowRed()
--[[    if self.endTimer then
        SL:UnSchedule(self.endTimer)
        self.endTimer = nil
    end
    local endDayTime = tonumber(self.args.endTime)*1000
    local leftTime = endDayTime - Time.GetServerTime()
    GUI:setVisible(self.view.endTime,leftTime>0)

    if leftTime>0 then
        self.endTimer = SL:Schedule(self.endTimer,0,1,-1,function()
            local leftTime1 = endDayTime - Time.GetServerTime()
            if leftTime1 <= 0 then
                SL:UnSchedule(self.endTimer)
                self.endTimer = nil
            else
                local time_str = "<color=#ff2323>剩余："..GUIUtil.FormatTimeDHM_S(leftTime1//1000) .."</color>"
                GUI:Text_setString(self.view.endTime,time_str)
            end
        end)
    end]]
end

function this:RefreshArgs(args)
    self.args = args
    self:Refresh()
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.selectToggle,self,self.OnValueChangeSelectToggle)
    GUI:AddOnClickEvent(self.view.tipClick,self,self.OnClickTip)
    SL:RegisterLUAEvent(LUA_EVENT_SET_DEFAULT_RIDE, self.LUA_EVENT_SET_DEFAULT_RIDE, self)
    
    SL:RegisterLUAEvent(LUA_EVENT_MOUNT_EQUIP_CHANGE, self.ShowRed, self)
end

function this:ShowRed()
    local mountData = InfoManager.mountInfo:GetMountData(self.args.mountId)
    if mountData ~= nil then
        local tbl = SL:GetConfig("cfg_mount", self.args.mountId)
        ---@type cfg_mount_levelUp_column
        local lvTbl = SL:GetConfigTwoKeys("cfg_mount_levelUp", tbl.type, mountData.level, "type", "level")
        if not table.isNullOrEmpty(lvTbl.deplete) then
            --可升级红点
            if SL:GetBagItemCount(lvTbl.deplete[1]) >= lvTbl.deplete[2] then
                GUI:setVisible(self.view.red, true)
                return
            end
        end
        local bagItems = InfoManager.mountInfo:GetBagItems()
        for _, v in pairs(bagItems) do
            local subType = SL:GetConfig("cfg_item", v.cfgId).subType
            local pos = InfoManager.mountInfo:GetPosBySubType(subType)
            local equip = InfoManager.mountInfo:GetMountEquipByPos(self.args.mountId, pos)
            if not equip then
                GUI:setVisible(self.view.red, true)
                return
            else
                local nowGrade = SL:GetConfig("cfg_equip_entryLib", equip.cfgId).initialRating
                local grade = SL:GetConfig("cfg_equip_entryLib", v.cfgId).initialRating
                if grade > nowGrade then
                    GUI:setVisible(self.view.red, true)
                    return
                end
            end
        end
        GUI:setVisible(self.view.red, false)
    else
        GUI:setVisible(self.view.red, false)
    end
end

function this:LUA_EVENT_SET_DEFAULT_RIDE()
    GUI:setVisible(self.view.wear_mount_icon,self.args.mountId == InfoManager.mountInfo:GetDefaultMountId())
end

function this:OnValueChangeSelectToggle(_,_,data)
    self.baseUI:SelectMount(self.args.mountId,self.args.index)
end

function this:UpdateGainState()
    ---@type cfg_mount_column
    local tbl = SL:GetConfig("cfg_mount", self.args.mountId)
    if InfoManager.mountInfo:GetMountData(self.args.mountId) == nil then
        local enough = SL:GetBagItemCount(tbl.itemId) > 0
        GUI:setVisible(self.view.gainTip, not enough)
        GUI:setVisible(self.view.activeTip, enough)
    else
        GUI:setVisible(self.view.gainTip, false)
        GUI:setVisible(self.view.activeTip, false)    
    end
end

---刷新选中
function this:UpdateSelect(selectMount)
    GUI:setVisible(self.view.select, self.args.mountId == selectMount)
end
function this:OnClickTip()
    if InfoManager.mountInfo:GetMountData(self.args.mountId) ~= nil then
        ---@type cfg_mount_column
        local mountTbl = SL:GetConfig("cfg_mount", self.args.mountId)
        --mountId = self.args.mountId, cfgId=mountTbl.itemId, hideBtn = true}
        SL:OpenTips(nil,mountTbl.itemId,nil,nil,nil,{hideBtn = true,clickControl = self.view.root})
        --GUI:UIPanel_Open("dev/outui/Mount/Panel/KLMountTip/KLMountTipPanel",nil,nil,{mountId = self.args.mountId, cfgId=mountTbl.itemId, hideBtn = true})
    end
end

function this:Close()
    if self.endTimer then
        SL:UnSchedule(self.endTimer)
        self.endTimer = nil
    end
end

return this
