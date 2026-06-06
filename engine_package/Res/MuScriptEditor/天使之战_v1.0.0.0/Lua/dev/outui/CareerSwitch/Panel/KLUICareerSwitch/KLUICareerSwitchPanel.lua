---@class KLUICareerSwitchPanel:UIKmlLuaPanelBase
---@field view KLUICareerSwitchPanelView
local KLUICareerSwitchPanel = class(UIKmlLuaPanelBase)
local this =KLUICareerSwitchPanel
function this:AsyncLoadUI()
end
---创建时调用一次
function this:Init()
    GUI:DataListInitData(self.view.career_datalist,
            function()
                return #self.showCareerList
            end, nil, nil,
            function(realIndex)
                local toggle = GUI:GetChildControl(self.view.career_datalist, realIndex, "careerToggle")
                local name = GUI:GetChildControl(self.view.career_datalist, realIndex, "name")
                if realIndex == 0 then
                    GUI:SetTogDefaultThis(toggle)
                    self.switchCareerId = self.showCareerList[realIndex + 1].id
                    self.switchName = self.showCareerList[realIndex + 1].name
                    self.switchCareerRec = self.showCareerList[realIndex + 1].careerRec
                end
                GUI:Text_setString(name, self.showCareerList[realIndex + 1].name)
                GUI:SetToggleOnValueChange(toggle, self, self.CareerToggleOnClick, self.showCareerList[realIndex + 1])
            end)
    
    self.switchItemCfg = {}
    if self.args then
        ---@type cfg_item_column
        self.switchItemCfg = SL:GetConfig("cfg_item", self.args)
    end
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.okBtn, self, self.CareerSwitchOnClick)
    GUI:AddOnClickEvent(self.view.closeBtn, self, self.CloseSelf)
    GUI:AddOnClickEvent(self.view.cancelBtn, self, self.CloseSelf)
    
    --SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_CAREER_TRANSFER_SUCCESS, self.RES_CAREER_TRANSFER_SUCCESS, self)
end
---界面显示时调用一次
function this:Show()

end
---创建或者刷新界面数据时调用
function this:Refresh()
    self.panelType = "switch"
    GUI:setVisible(self.view.switch_panel, true)
    self.showCareerList = {}
    local baseCareer = SL:GetMetaValue("JOB")
    ---@type cfg_character_create_column
    local tbl = SL:GetConfig("cfg_character_create", baseCareer)
    self.nowName = tbl.name
    GUI:Text_setString(self.view.switch_des, "您当前的职业为<color=#00ff00>" .. self.nowName .. "</color>，请选择要转换的职业")
    ---@type cfg_careerchange_column
    local careerCfg = SL:GetConfigTable("cfg_careerchange")
    for i, v in pairs(careerCfg) do
        if v.CareerID ~= baseCareer then
            self.showCareerList[#self.showCareerList + 1] = v
        end
    end
    GUI:DataListUpdateData(self.view.career_datalist)
end

function this:CareerSwitchOnClick()
    if self.panelType == "switch" then
        self.panelType = "sure"
        GUI:setVisible(self.view.switch_panel, false)
        GUI:setVisible(self.view.sure_panel, true)
        
        GUI:Text_setString(self.view.sure_text, "是否消耗" .. self.switchItemCfg.name .. "×1，从<color=#00ff00>" .. self.nowName .. "</color>转换为<color=#00ff00>" .. self.switchName .. "</color>，\n转换成功后将返回服务器选择页面")
    elseif self.panelType == "sure" then
        local data = {}
        data.careerChangeId = self.switchCareerId
        data.careerRec = { self.switchCareerRec - 1 }
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_CAREER_TRANSFER, data)
        self:QuitGame()
    elseif self.panelType == "result" then
    end
end

function this:CareerToggleOnClick(_, eventData, args)
    if args[1] then
        self.switchCareerId = eventData.id
        self.switchName = eventData.name
    end
end

function this:RES_CAREER_TRANSFER_SUCCESS()
    self.panelType = "result"
    GUI:setVisible(self.view.sure_panel, false)
    GUI:setVisible(self.view.result_panel, true)
    GUI:setVisible(self.view.cancelBtn, false)
    GUI:Button_setTitleText(self.view.okBtn, "确定")
    GUI:setPositionX(self.view.okBtn, 0)
end

function this:CloseSelf()
    if self.panelType == "result" then
        self:QuitGame()
    else
        GUI:UIPanel_Close("dev/outui/CareerSwitch/Panel/KLUICareerSwitch/KLUICareerSwitchPanel")
    end
end

function this:QuitGame()
    if SL.LoginInfo:IsSDK()then
        if SL.Main.IsWindows() then
            SL:QuitGame()
        else
            if SL.LoginInfo:IsOutSDK() then
                MuInterface.Instance:LogoutAccount()
            else
                SL:QuitGame()
            end
        end
    else
        SL:QuitGame()
    end
end

function this:Hide()
end

function this:Close()
end

return this
