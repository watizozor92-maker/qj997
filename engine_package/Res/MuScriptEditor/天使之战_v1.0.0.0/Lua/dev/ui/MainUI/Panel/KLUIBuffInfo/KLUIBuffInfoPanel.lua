---@class KLUIBuffInfoPanel:UIKmlLuaPanelBase
---@field view KLUIBuffInfoPanelView
local KLUIBuffInfoPanel = class(UIKmlLuaPanelBase)
---创建时调用一次
function KLUIBuffInfoPanel:Init()
    --local cfg_buff_Calculation = SL:GetConfig("cfg_buff_Calculation")
end

---创建或者刷新界面数据时调用
function KLUIBuffInfoPanel:Refresh()
    if self.timer then
        SL:UnSchedule(self.timer)
        self.timer = nil
    end
--[[    local MMId = 100000004
    local itemMM = SL:GetConfig("cfg_item",MMId)]]
    ---@type cfg_buff_column
    local buffTbl = SL:GetConfig("cfg_buff",self.args.cfgId)
    local des = self:GetBuffDesc(buffTbl)
    --[[local des = SL:GetMetaValue(EMetaVarGetKey.GET_BUFF_DESCRIDE,self.args.cfgId)
    if self.args.buffText then
        des = self.args.buffText
    end]]
    local endTime = self.args.endTime
    if buffTbl then
        if SL:HasConfig("cfg_buff_Calculation",self.args.cfgId) then
            local cfg = SL:GetConfig("cfg_buff_Calculation", self.args.cfgId)
            if cfg.type == 2 then
                endTime = InfoManager.guardPetInfo.MM_ShowTime
            end
        end
        if endTime > 0 then
            self.timer = SL:Schedule(self.timer,0,1,-1,function()
                local leftTime = endTime - Time.GetServerTime()
                if leftTime <= 0 then
                    SL:UnSchedule(self.timer)
                    self.timer = nil
                    self:ClosePanel()
                else
                    local time_str = "<color=#ff2323>"..self:GetTime(leftTime) .."</color>"
                    local str = buffTbl.buffName .. "\n".. time_str .. "\n" ..des
                    GUI:Text_setString(self.view.des,str)
                    --[[local x,y = GUI:getSizeDelta(self.view.buffBg)
                    GUI:setPositionY(self.view.buffBg,78 - y + 28)]]
                end
            end)
        else
            local str = buffTbl.buffName .. "\n" ..des
            --特权卡永久使用特殊处理
            if self.args.cfgId == 30000011 or self.args.cfgId == 30000012 or self.args.cfgId == 30000013 then
                str = buffTbl.buffName .. "\n".. "<color=#e6e600>已永久激活</color>" .. "\n" ..des
            end
            GUI:Text_setString(self.view.des,str)
            --[[local x,y = GUI:getSizeDelta(self.view.buffBg)
            GUI:setPositionY(self.view.buffBg,78 - y + 28)]]
        end
    end
    
end

function KLUIBuffInfoPanel:GetTime(_second)
    local second = math.floor(_second/1000)
    local day = math.floor(second / (3600 * 24))
    local hour = math.floor(second % (3600 * 24) / 3600)
    local minute = math.floor(second % 3600 / 60)
    local sec = math.floor(second % 60)
    local str = ""
    if day>0 then
        str = str ..day ..  "天"
    end
    if hour>0 then
        str = str ..hour ..  "小时"
    end
    if minute>0 then
        str = str ..minute ..  "分"
    end
    str = str ..sec ..  "秒"
    return str
end

---注册UI事件和服务器消息
function KLUIBuffInfoPanel:RegistEvents()
    GUI:AddOnClickEvent(self.view.maskBtn,self,self.ClosePanel)
end

function KLUIBuffInfoPanel:ClosePanel()
    if self.timer then
        SL:UnSchedule(self.timer)
        self.timer = nil
    end
    GUI:UIPanel_Close(nil,self)
end

function KLUIBuffInfoPanel:Close()
    if self.timer then
        SL:UnSchedule(self.timer)
        self.timer = nil
    end
end

---@param buffTbl cfg_buff_column
function KLUIBuffInfoPanel:GetBuffDesc(buffTbl)
    if buffTbl.buffType ~= 3 then
        return buffTbl.buffText
    end
    -- 调整属性类
    local des = ""
    ---@type cfg_att_info_column
    local attCfg
    local attInfo = {}
    local buffAttValue
    for i, v in pairs(buffTbl.buffParam) do
        attCfg = SL:GetConfig("cfg_att_info", v[1])
        buffAttValue = InfoManager.roleOtherInfo:GetBuffAttValue(buffTbl.id, v[1])
        if buffAttValue then
            table.insert(attInfo, EquipFunc.GetAttrValueText(attCfg, buffAttValue))
        end
    end
    if #attInfo > 0 and not string.contains(buffTbl.buffText, "s") then
        return buffTbl.buffText
    end
    if #attInfo == 1 then
        des = string.format(buffTbl.buffText, attInfo[1])
    elseif #attInfo == 2 then
        des = string.format(buffTbl.buffText, attInfo[1], attInfo[2])
    elseif #attInfo == 3 then
        des = string.format(buffTbl.buffText, attInfo[1], attInfo[2], attInfo[3])
    elseif #attInfo == 4 then
        des = string.format(buffTbl.buffText, attInfo[1], attInfo[2], attInfo[3], attInfo[4])
    elseif #attInfo == 5 then
        des = string.format(buffTbl.buffText, attInfo[1], attInfo[2], attInfo[3], attInfo[4], attInfo[5])
    else
        des = buffTbl.buffText
    end
    
    return des
end

return KLUIBuffInfoPanel
