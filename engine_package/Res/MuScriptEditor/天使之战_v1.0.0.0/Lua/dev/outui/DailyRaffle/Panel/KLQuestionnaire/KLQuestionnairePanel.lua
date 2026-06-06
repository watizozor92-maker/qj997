---@class KLQuestionnairePanel:UIKmlLuaPanelBase
---@field view KLQuestionnairePanelView
local KLQuestionnairePanel = class(UIKmlLuaPanelBase)
local this =KLQuestionnairePanel
---创建时调用一次
function this:Init()
    SL.HideMainPanel()
    self.isClose = false
    self.is_man = -1
    self.code_num = nil
    self.is_jieshu = -1
    self.is_like = -1
    self.phone_num = nil

    self.one_1 = false
    self.one_2 = false
    self.one_3 = false
    self.one_4 = false
    self.one_5 = false
    self.one_6 = false
end


---创建或者刷新界面数据时调用
function this:Refresh()
   -- SL:SendLuaNetMsg(LuaMessageIdToSever.GET_DAILY_ACTIVITY_INFO)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_BIND_PHONE,self.RES_BIND_PHONE,self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_GENERATE_VERIFICATION_CODE,self.RES_GENERATE_VERIFICATION_CODE,self)
    
    GUI:AddOnClickEvent(self.view.btn_close,self,self.CloseOnclick)
    GUI:AddOnClickEvent(self.view.btnStart,self,self.Bind)
    GUI:Input_SetOnValueChange(self.view.pnone_number_input, self, self.TextChange)
    GUI:Input_SetOnValueChange(self.view.year_input, self, self.CodeChange)

    GUI:SetToggleOnValueChange(self.view.nanBtn, self, self.ManOnClick)
    GUI:SetToggleOnValueChange(self.view.nvBtn, self, self.WomanOnClick)
    GUI:SetToggleOnValueChange(self.view.jiechu1Btn, self, self.JieChu1OnClick)
    GUI:SetToggleOnValueChange(self.view.jiechu2Btn, self, self.JieChu2OnClick)
    GUI:SetToggleOnValueChange(self.view.xihuan1Btn, self, self.Like1OnClick)
    GUI:SetToggleOnValueChange(self.view.xihuan2Btn, self, self.Like2OnClick)
end

function this:CloseOnclick()
    GUI:UIPanel_Close("dev/outui/DailyRaffle/Panel/KLQuestionnaire/KLQuestionnairePanel")
end

function this:Close()
    self.isClose = true
end

function this:TextChange(a, b,eventData)
    if self.isClose then
        return
    end
    local messageStr = eventData[1]
    if string.isNullOrEmpty(messageStr) then
        self.phone_num = messageStr
    else
        local is_have = self:contains_non_digit(messageStr)
        if is_have then
            messageStr = self:remove_non_digits(messageStr)
            GUI:Text_setString(self.view.pnone_number_input,messageStr)
        end
        self.phone_num = messageStr
    end
    --SL:LogError("手机号输入："..self.phone_num)
end

function this:contains_non_digit(str)
    return string.match(str, "%D") ~= nil
end
 
-- 去除字符串中的非数字字符
function this:remove_non_digits(str)
    return string.gsub(str, "%D", "")
end

function this:CodeChange(a, b,eventData)
    if self.isClose then
        return
    end
    local messageStr = eventData[1]
    local is_have = self:contains_non_digit(messageStr)
    if is_have then
        messageStr = self:remove_non_digits(messageStr)
        GUI:Text_setString(self.view.year_input,messageStr)
    end
    self.code_num = messageStr
end

function this:SendCode()
    if not self:CheckPhoneNumber() then
        return
    end
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_GENERATE_VERIFICATION_CODE,tonumber(self.phone_num))
end

function this:CheckPhoneNumber()
    if string.isNullOrEmpty(self.phone_num) then
        SL:TipMessage( SL:GetConfig("cfg_string",465).text, 1, NoticeType.NoticeMid )
        return false
    else
        if #self.phone_num ~= 11 then
            SL:TipMessage( SL:GetConfig("cfg_string",467).text, 1, NoticeType.NoticeMid )
            return false
        end
        local pattern = "^1[3-9]%d%d%d%d%d%d%d%d%d$"
        local is_phone = string.match(self.phone_num, pattern) ~= nil
        if not is_phone then
            SL:TipMessage( SL:GetConfig("cfg_string",467).text, 1, NoticeType.NoticeMid )
            return false
        end
    end
    return true

end




function this:CheckCode()
    if string.isNullOrEmpty(self.code_num) then
        SL:TipMessage( SL:GetConfig("cfg_string",466).text, 1, NoticeType.NoticeMid )
        return false
    else
        if #self.code_num ~= 4 then
            SL:TipMessage( SL:GetConfig("cfg_string",466).text, 1, NoticeType.NoticeMid )
            return false
        else
            local num = tonumber(self.code_num)
            local ServerTime = Time.GetServerTime()
            local seconds = math.floor(ServerTime / 1000)
            local year = os.date("*t", seconds).year
            if num < 1900 or num > year then
                SL:TipMessage( SL:GetConfig("cfg_string",466).text, 1, NoticeType.NoticeMid )
                return false
            end
        end
    end
    return true
end


function this:Bind()
    if self.is_man < 0 or (not self.one_1 and not self.one_2) then
        SL:TipMessage( SL:GetConfig("cfg_string",474).text, 1, NoticeType.NoticeMid )
        return
    end
    if not self:CheckCode() then
        return
    end
    if self.is_jieshu < 0 or (not self.one_3 and not self.one_4) then
        SL:TipMessage( SL:GetConfig("cfg_string",475).text, 1, NoticeType.NoticeMid )
        return
    end
    if self.is_like < 0 or (not self.one_5 and not self.one_6) then
        SL:TipMessage( SL:GetConfig("cfg_string",476).text, 1, NoticeType.NoticeMid )
        return
    end
    if not self:CheckPhoneNumber() then
        return
    end
    local tab = {is_man = self.is_man,year=self.code_num,is_jieshu=self.is_jieshu,is_like=self.is_like,phone=self.phone_num}
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_BIND_PHONE,tab)

end

function this:RES_BIND_PHONE(id, message)
    if message then
        --SL:TipMessage({ "<color=#00ff00>绑定成功</color>", 1, NoticeType.NoticeMid })
        if self.args.parent then
            self.args.parent:Refresh()
        end
        self:CloseOnclick()
    end
end

function this:RES_GENERATE_VERIFICATION_CODE()
    if message then
        SL:TipMessage( "<color=#00ff00>发送成功</color>", 1, NoticeType.NoticeMid )
    end
end




function this:ManOnClick(kmlCtrl, eventData, args)
    if args[1] then
        self.is_man = 1
        GUI:Toggle_setIsOn(self.view.nvBtn,false)
        self.one_1 = true
    else
        self.one_1 = false
    end
end
function this:WomanOnClick(kmlCtrl, eventData, args)
    if args[1] then
        self.is_man = 0
        GUI:Toggle_setIsOn(self.view.nanBtn,false)
        self.one_2 = true
    else
        self.one_2 = false
    end
end

function this:JieChu1OnClick(kmlCtrl, eventData, args)
    if args[1] then
        self.is_jieshu = 1
        GUI:Toggle_setIsOn(self.view.jiechu2Btn,false)
        self.one_3 = true
    else
        self.one_3 = false
    end
end
function this:JieChu2OnClick(kmlCtrl, eventData, args)
    if args[1] then
        self.is_jieshu = 0
        GUI:Toggle_setIsOn(self.view.jiechu1Btn,false)
        self.one_4 = true
    else
        self.one_4 = false
    end
end

function this:Like1OnClick(kmlCtrl, eventData, args)
    if args[1] then
        self.is_like = 1
        GUI:Toggle_setIsOn(self.view.xihuan2Btn,false)
        self.one_5 = true
    else
        self.one_5 = false
    end
end
function this:Like2OnClick(kmlCtrl, eventData, args)
    if args[1] then
        self.is_like = 0
        GUI:Toggle_setIsOn(self.view.xihuan1Btn,false)
        self.one_6 = true
    else
        self.one_6 = false
    end
end

return this
