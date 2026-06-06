---@class KLPreviewEntrancePanel:UIKmlLuaPanelBase
---@field view KLPreviewEntrancePanelView
local KLPreviewEntrancePanel = class(UIKmlLuaPanelBase)
---创建时调用一次
function KLPreviewEntrancePanel:Init()
end

---创建或者刷新界面数据时调用
function KLPreviewEntrancePanel:Refresh()
    GUI:setVisible(self.view.effect, false)
    local info = self:GetPreviewInfo()
    --Scene.mapConfig.type 
    local mapInfo = SL:GetConfig("cfg_map_info", SL:GetMetaValue("MAP_ID"), "id")

    if not info or mapInfo.nopositionmove == 1 then
        GUI:SetActive(self.view.PreviewUIclick, false)
        GUI:setVisible(self.view.effect, false)
        return
    end
    GUI:SetActive(self.view.PreviewUIclick, true)
    --GUI:setVisible(self.view.effect, true)
    local icon = info["icon"]
    local atlas = icon[1]
    local src = icon[2]

    GUI:Image_loadTexture(self.view.icon, src, atlas)
    local name = info["name"][1][1]
    GUI:Text_setString(self.view.name, name)
end

---注册UI事件和服务器消息
function KLPreviewEntrancePanel:RegistEvents()
    GUI:AddOnClickEvent(self.view.PreviewUIclick, self, self.OpenPreviewPanel)
    SL:RegisterLUAEvent(LUA_EVENT_LEVELCHANGE, self.PreviewRefresh, self)

    SL:RegisterLuaNetMsg(MessageDef.ResPreviewRewardInfoMessage, self.PreviewRefresh, self)
end

function KLPreviewEntrancePanel:Close()
    SL:UnRegisterLUAEvent(Event.RoleUpGrade, self.PreviewRefresh, self)
    SL:UnRegisterLuaNetMsg(MessageDef.ResPreviewRewardInfoMessage, self.PreviewRefresh, self)
end

function KLPreviewEntrancePanel:PreviewRefresh(_, message)
    self:Refresh()
end

--获取需要显示的预告
function KLPreviewEntrancePanel:GetPreviewInfo()
    local result, info = InfoManager.qjAcademyInfo:GetGuideRedDot()
    local show = result or InfoManager.qjAcademyInfo:GetGamePlayRedDot()
    GUI:setVisible(self.view.effect, show)
    return info
end

function KLPreviewEntrancePanel:OpenPreviewPanel()
    self.preview = GUI:UIPanel_Open("dev/ui/Preview/Panel/KLPreview/KLPreviewPanel")
end

return KLPreviewEntrancePanel
