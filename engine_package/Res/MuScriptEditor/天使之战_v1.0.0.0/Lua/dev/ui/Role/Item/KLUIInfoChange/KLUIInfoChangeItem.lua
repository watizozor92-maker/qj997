---@class KLUIInfoChangeItem:UIKmlLuaPanelBase
---@field view KLUIInfoChangeItemView
local KLUIInfoChangeItem = class(UIKmlLuaPanelBase)
local this =KLUIInfoChangeItem
---创建时调用一次
function this:Init()
    ---@type KLUIInfoPanel
    self.baseUI = self.args.baseUI
end

---创建或者刷新界面数据时调用
function this:Refresh()
    
end

function this:RefreshUI(v, dcNum, mcNum, zzNum, time)
    if self.isShow then
        self.baseUI:RefreshTotalItemNum()
    end
  
    if SL:HasConfig("cfg_att_info", v.type) and SL:HasConfig("cfg_string",63) then
        local info = SL:GetConfig("cfg_att_info",v.type)
        GUI:Image_setAlpha(self.view.img_effect, 0)
        GUI:Image_setAlpha(self.view.img_up, 0)
        GUI:Text_setTextColorAlpha(self.view.text_attr, 0)
        local numStr = tostring(v.num)
        local dcNumStr = tostring(dcNum)
        if info.remarks == EAttInfoType.percentage then
            numStr = tostring(v.num / 100) .. "%"
            dcNumStr = tostring(dcNum / 100).."%"
        end

        if v.num > 0 then
            GUI:Text_setTextColor(self.view.text_attr, "#5EFF0000")
            GUI:setRotation(self.view.img_up, "0")
            GUI:Text_setString(self.view.text_attr, info.name.." + "..numStr)
            
            if dcNum ~= 0 and v.type == EMUCharacterAttrType.maxDC then
                GUI:Text_setString(self.view.text_attr, "攻击力".." + "..dcNumStr.." ~ "..numStr)
            elseif mcNum ~= 0 and v.type == EMUCharacterAttrType.maxMC then
                GUI:Text_setString(self.view.text_attr, "魔法攻击力".." + "..mcNum.." ~ "..numStr)
            elseif zzNum ~= 0 and v.type == EMUCharacterAttrType.maxZuZhou then
                GUI:Text_setString(self.view.text_attr, "诅咒攻击力".." + "..zzNum.." ~ "..numStr)
            end
        else
            GUI:Text_setTextColor(self.view.text_attr, "#FF1A0000")
            GUI:setRotation(self.view.img_up, "180")
            GUI:Text_setString(self.view.text_attr, info.name.."  "..numStr)
            if dcNum ~= 0 and v.type == EMUCharacterAttrType.maxDC then
                GUI:Text_setString(self.view.text_attr, "攻击力"..dcNumStr.." ~ "..numStr)
            elseif mcNum ~= 0 and v.type == EMUCharacterAttrType.maxMC then
                GUI:Text_setString(self.view.text_attr, "魔法攻击力"..mcNum.." ~ "..numStr)
            elseif zzNum ~= 0 and v.type == EMUCharacterAttrType.maxZuZhou then
                GUI:Text_setString(self.view.text_attr, "诅咒攻击力"..zzNum.." ~ "..numStr)
            end
        end
    end
    self.hideTime = time
end

function this:ShowUI()
    self.isShow = true
    GUI:SetActive(self.view.item_root, true)
    ---重置
    if self.scheduleHideId then
        SL:UnSchedule(self.scheduleHideId)
        self.scheduleHideId = nil
    end
    self.alpha = 0
    GUI:Image_setAlpha(self.view.img_effect, self.alpha)
    GUI:Image_setAlpha(self.view.img_up, self.alpha)
    GUI:Text_setTextColorAlpha(self.view.text_attr, self.alpha)
    ---开始展示
    self.scheduleShowId = SL:Schedule(self.scheduleShowId, 0, Time.deltaTime, -1, function()
        self.alpha = self.alpha + 0.1
        GUI:Image_setAlpha(self.view.img_effect, self.alpha)
        GUI:Image_setAlpha(self.view.img_up, self.alpha)
        GUI:Text_setTextColorAlpha(self.view.text_attr, self.alpha)
        if self.alpha >= 1 then
            SL:UnSchedule(self.scheduleShowId)
            self.scheduleShowId = nil
            self.scheduleHideId = SL:Schedule(self.scheduleHideId, self.hideTime, Time.deltaTime, -1, function()
                self.alpha = self.alpha - 0.1
                GUI:Image_setAlpha(self.view.img_effect, self.alpha)
                GUI:Image_setAlpha(self.view.img_up, self.alpha)
                GUI:Text_setTextColorAlpha(self.view.text_attr, self.alpha)
                if self.alpha <= 0 then
                    SL:UnSchedule(self.scheduleHideId)
                    self.scheduleHideId = nil
                    self.isShow = false
                    GUI:SetActive(self.view.item_root, false)
                    self.baseUI:RefreshTotalItemNum()
                end
            end)
        end
    end)
end

---注册UI事件和服务器消息
function this:RegistEvents()
end

function this:Close()
    if self.scheduleShowId then
        SL:UnSchedule(self.scheduleShowId)
    end
    if self.scheduleHideId then
        SL:UnSchedule(self.scheduleHideId)
    end
end

return this
