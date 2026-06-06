---@class KLSystemFunctionPanel:UIKmlLuaPanelBase
---@field view KLSystemFunctionPanelView
local KLSystemFunctionPanel = class(UIKmlLuaPanelBase)
local this =KLSystemFunctionPanel

---创建时调用一次
function this:Init()
    self.extraListData = { "兑换码", "切换角色", "返回登录"}
    --self.redControlDatas = {}
    GUI:DataListInitData(self.view.datalist_func, function()
        return table.count(self.systemIds)
    end, function()
    end, function()
    end, function(realIdx)
        local index = realIdx + 1
        local systemId = self.systemIds[index]
        local item_line = GUI:GetChildControl(self.view.datalist_func, realIdx, "item_line")
        local item_btn = GUI:GetChildControl(self.view.datalist_func, realIdx, "item_btn")
        --local red = GUI:GetChildControl(self.view.datalist_func, realIdx, "red")
        GUI:SetActive(item_line, index ~= table.count(self.systemIds))
        if table.contains(self.extraListData, systemId) then
            GUI:Button_setTitleText(item_btn, systemId)
            GUI:AddOnClickEvent(item_btn, self, self.OnClickSystemFunc, systemId)
            return
        end
        ---@type cfg_MainPanelUI_column
        local tbl = SL:GetConfig("cfg_MainPanelUI", systemId)
        GUI:Button_setTitleText(item_btn, tbl.dec)
        -- self.redControlDatas[tbl.btnName] = {isHasFind = true, subKml = red, 
        --     redDotItem = {isHasFind = true, redDotItem = red}}
            GUI:SetID(item_btn, tbl.btnName)
        --GUI:SetActive(red, false)
        GUI:AddOnClickEvent(item_btn, self, self.OnClickSystemFunc, tbl.systemId)
    end)
end

function this:OnClickSystemFunc(_, systemId)
    if table.contains(self.extraListData, systemId) then
        if systemId == "兑换码" then
            GUI:UIPanel_Open("dev/outui/Tips/Panel/KLRedemptionCodeTips/KLRedemptionCodeTipsPanel")
            GUI:UIPanel_Close(self.filePath)
        elseif systemId == "切换角色" then
            SL:QuitSelectRoleUI()
        elseif systemId == "返回登录" then
            if SL.LoginInfo:IsSDK() then
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

        return
    end
    SL:onLUAEvent(LUA_EVENT_OPENMAINSYSTEMFUNCTION,systemId)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn_close, self, self.CloseSelf)
end

function this:CloseSelf()
    GUI:UIPanel_Close(self.filePath)
end

---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
    self.systemIds = {}
    local tbls = SL:GetConfigTable("cfg_MainPanelUI")
    local count = 0
    ---@param v cfg_MainPanelUI_column
    for _, v in pairs(tbls) do
        if v.displayLocation == 3 then
            local isMeet = SL:GetMetaValue(EMetaVarGetKey.IS_OPEN_SYSTEMFUNCTION, v.systemId)
            if isMeet then
               table.insert(self.systemIds, v.id) 
               count = count + 1
            end
        end
    end
    table.sort(self.systemIds, function(a, b)
        ---@type cfg_MainPanelUI_column
        local tblA = SL:GetConfig("cfg_MainPanelUI", a)
        ---@type cfg_MainPanelUI_column
        local tblB = SL:GetConfig("cfg_MainPanelUI", b)
        return tblA.sort < tblB.sort
    end)
    table.insert(self.systemIds, 1, self.extraListData[1])
    table.insert(self.systemIds, self.extraListData[2])
    table.insert(self.systemIds, self.extraListData[3])
    GUI:DataListUpdateData(self.view.datalist_func, true, function()
        SL:ScheduleOnce(Time.deltaTime, function()
            SL:RefreshPanelALLRedPoint("KLSystemFunctionPanelKml") 
            KLGuideManager.UiShowGuide("KLSystemFunctionPanelKml")
        end)
    end)
    -- if SL:GetMetaValue(EMetaVarGetKey.IS_EMULATOR) then
    --     GUI:SetActive(self.view.ResolutionText,true)
        
    -- else
    --     GUI:SetActive(self.view.ResolutionText,false)
    -- end
end

function this:Hide()
end

function this:Close()
    SL:onLUAEvent(LUA_EVENT_MAIN_UI_BOTTOM_SYSTEM_CLOSE)
end

return this
