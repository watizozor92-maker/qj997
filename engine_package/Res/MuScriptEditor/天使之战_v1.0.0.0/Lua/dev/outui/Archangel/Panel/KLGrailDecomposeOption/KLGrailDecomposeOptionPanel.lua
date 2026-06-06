---@class KLGrailDecomposeOptionPanel:UIKmlLuaPanelBase
---@field view KLGrailDecomposeOptionPanelView
local KLGrailDecomposeOptionPanel = class(UIKmlLuaPanelBase)
local this = KLGrailDecomposeOptionPanel
function this:AsyncLoadUI()
end

---创建时调用一次
function this:Init()
    self.init = false
    self.data = {}
    local cfgStr = SL:GetConfig("cfg_global", 230001, "id").value
    local cfgValue = string.split(cfgStr, "|")
    for k, v in pairs(cfgValue) do
        local cfg = string.split(v, "#")
        self.data[k] = {}
        self.data[k].name = cfg[1]
        table.remove(cfg, 1)
        self.data[k].value = cfg
    end

    GUI:DataListInitData(self.view.option_list, function()
        return #self.data
    end, function(realIndex)
    end, function(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:OptionUpdateFunc(realIndex, kmlcontrol)
    end)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.close,self,self.ClosePanel)
end

---界面显示时调用一次
function this:Show()
end

---创建或者刷新界面数据时调用
function this:Refresh()
    self:LoadData()
    self.init = true
end

function this:LoadData()
    self.isClick = false
    for k, v in pairs(self.data) do
        local select = true
        for _, grailQuality in pairs(v.value) do
            if not InfoManager.archangeEquipInfo:GetDecomposeSetting(tonumber(grailQuality)) then
                select = false
                break
            end
        end
        self.data[k].select = select
    end
    GUI:DataListUpdateData(self.view.option_list,true)
    self.isClick = true
end

function this:OptionUpdateFunc(realIndex, kmlcontrol)
    local data = self.data[realIndex + 1]
    local name = GUI:GetChildControl(self.view.option_list, realIndex, "text_optionName")
    GUI:Text_setString(name, data.name)
    local option = GUI:GetChildControl(self.view.option_list, realIndex, "option")
    GUI:Toggle_setIsOn(option, data.select)
    if not self.init then
        GUI:SetToggleOnValueChange(option, self, self.OnClickOption, realIndex + 1)
    end
end

function this:OnClickOption(_, realIndex, eventData)
    if not self.isClick then
        return
    end
    local data = self.data[realIndex]
    InfoManager.archangeEquipInfo:SetDecomposeSetting(data.value, eventData[1])
    self:LoadData()
    InfoManager.archangeEquipInfo:SaveDecomposeSetting()
end

function this:Hide()
end

function this:ClosePanel()
    GUI:UIPanel_Close("dev/outui/Archangel/Panel/KLArchangelDecompose/KLArchangelDecomposePanel")
    GUI:UIPanel_Close("dev/outui/Archangel/Panel/KLArchangelGroup/KLArchangelGroupPanel")
end
function this:Close()
end

return this
