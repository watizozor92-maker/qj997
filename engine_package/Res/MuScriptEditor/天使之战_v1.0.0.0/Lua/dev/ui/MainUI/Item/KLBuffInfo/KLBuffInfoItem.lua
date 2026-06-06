---@class KLBuffInfoItem:UIKmlLuaPanelBase
---@field view KLBuffInfoItemView
---@field args Buff
local KLBuffInfoItem = class(UIKmlLuaPanelBase)
---创建时调用一次
function KLBuffInfoItem:Init()
    self.timer = nil
end

---创建或者刷新界面数据时调用
function KLBuffInfoItem:Refresh()
    GUI:SetCirclebar_startper(self.view.control_circlebar,1)
    ---@type cfg_buff_column
    local buffTbl = SL:GetConfig("cfg_buff",self.args.cfgId)
    local leftTime = self.args.endTime - Time.GetServerTime()
    local buffTotalTime = self.args.totalTime --buffTbl.buffTotalTime > 0 and buffTbl.buffTotalTime or leftTime
    if not buffTotalTime then
        buffTotalTime = buffTbl.buffTotalTime > 0 and buffTbl.buffTotalTime or leftTime
    end
    if SL:HasConfig("cfg_buff_Calculation",self.args.cfgId) then
        local cfg = SL:GetConfig("cfg_buff_Calculation", self.args.cfgId)
        if cfg.type == 2 then
            leftTime = InfoManager.guardPetInfo.MM_ShowTime - Time.GetServerTime()
            local animInfoList= string.split(SL:GetConfig("cfg_global",560001).value,"#")
            buffTotalTime = tonumber(animInfoList[3])
            ----时间结束  刷新buff面板
            if leftTime > 0 then
                if self.timer then
                    SL:UnSchedule(self.timer)
                end
                self.timer = SL:ScheduleOnce(leftTime/1000,function()
                    self:Refresh()
                end)
            end
        end
    end
    local startper = leftTime/buffTotalTime * 100
    leftTime = math.floor(leftTime / 1000)
    startper = math.floor(startper) 
    if buffTbl then
        GUI:Image_loadTexture(self.view.control_circlebar,buffTbl.showIcon,"Atlas/Buff_iconOut.spriteatlas")
    end
    GUI:SetControl_time(self.view.control_circlebar,leftTime)
    GUI:SetCirclebar_startper(self.view.control_circlebar,startper)
    --logError("startper=="..startper)
    if self.args.bufferLayer and tonumber(self.args.bufferLayer) > 1 then
        GUI:Text_setString(self.view.text_layer,tostring(self.args.bufferLayer))
    else
        GUI:Text_setString(self.view.text_layer,"")
    end
end

---注册UI事件和服务器消息
function KLBuffInfoItem:RegistEvents()
    --GUI:AddOnClickEvent(self.view.control_circlebar,self,self.OnClickBtn)
end

function KLBuffInfoItem:OnClickBtn()
   GUI:UIPanel_Open("dev/ui/MainUI/Panel/KLUIBuffInfo/KLUIBuffInfoPanel",nil,nil,self.args)
end

function KLBuffInfoItem:Close()
    if self.timer then
        SL:UnSchedule(self.timer)
    end
    self.timer = nil
    --GUI:UIPanel_Close("dev/ui/MainUI/Panel/KLUIBuffInfo/KLUIBuffInfoPanel")
end

return KLBuffInfoItem
