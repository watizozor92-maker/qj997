---@class KLUIBuffInfoListPanel:UIKmlLuaPanelBase
---@field view KLUIBuffInfoListPanelView
---@field args table<number,Buff>
local KLUIBuffInfoListPanel = class(UIKmlLuaPanelBase)
local this =KLUIBuffInfoListPanel
---创建时调用一次
function this:Init()
    self.buffTemplateList = {}
    self.curClickId = 0
end

---创建或者刷新界面数据时调用
function this:Refresh()
  
    local buffNotCfgIdList = {}
    if not table.isNullOrEmpty(self.buffTemplateList) then
        for cfgId, temp in pairs(self.buffTemplateList) do
            local isBuff = false
            for _, buffTbl in pairs(self.args) do
                if cfgId == buffTbl.cfgId then
                    isBuff = true
                end
            end
            if not isBuff then
                table.insert(buffNotCfgIdList,cfgId)
            end
        end
    end
    for _,NotCfgId in pairs(buffNotCfgIdList) do
        GUI:UIPanel_Close(nil,self.buffTemplateList[NotCfgId])
        if self.curClickId == NotCfgId then
            GUI:UIPanel_Close("dev/ui/MainUI/Panel/KLUIBuffInfo/KLUIBuffInfoPanel")
        end
        self.buffTemplateList[NotCfgId] = nil
    end
    for i, v in pairs(self.args) do
        if not self.buffTemplateList[v.cfgId] then
            local buffTemplate = GUI:UIPanel_Open("dev/ui/MainUI/Item/KLBuffInfo/KLBuffInfoItem",self.view.buffInfo_list,self,v,true)
            self.buffTemplateList[v.cfgId] = buffTemplate
            GUI:AddOnClickEvent(self.buffTemplateList[v.cfgId].view.control_circlebar,self,self.OnClickBtn,v)
        else
            self.buffTemplateList[v.cfgId].args = v
            self.buffTemplateList[v.cfgId]:Refresh()
        end
        if self.curClickId == v.cfgId then
            local panel = GUI:GetUI("dev/ui/MainUI/Panel/KLUIBuffInfo/KLUIBuffInfoPanel")
            if panel then
                panel.args = v
                panel:Refresh()
            end
        end
    end
end

function this:OnClickBtn(_,v)
    self.curClickId = v.cfgId
    GUI:UIPanel_Open("dev/ui/MainUI/Panel/KLUIBuffInfo/KLUIBuffInfoPanel",nil,nil,v)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    --GUI:AddOnClickEvent(self.view.closeBtn,self,self.Close)
    SL:RegisterLUAEvent(LUA_EVENT_MAIN_PLAYER_DIE, self.LUA_EVENT_MAIN_PLAYER_DIE, self) --主角死亡
end

function this:LUA_EVENT_MAIN_PLAYER_DIE()
    self:Clear()
    GUI:UIPanel_Close("dev/ui/MainUI/Panel/KLUIBuffInfoList/KLUIBuffInfoListPanel")
end


function this:Close()
    self:Clear()
    GUI:UIPanel_Close("dev/ui/MainUI/Panel/KLUIBuffInfo/KLUIBuffInfoPanel")
    GUI:UIPanel_Close("dev/ui/MainUI/Panel/KLUIBuffInfoList/KLUIBuffInfoListPanel")
end
---清除数据
function this:Clear()
    ---@param buffTemplate KLBuffInfoItem
    for i, buffTemplate in pairs(self.buffTemplateList) do
        GUI:UIPanel_Close(nil,buffTemplate)
    end
    self.buffTemplateList = {} 
end
return this
