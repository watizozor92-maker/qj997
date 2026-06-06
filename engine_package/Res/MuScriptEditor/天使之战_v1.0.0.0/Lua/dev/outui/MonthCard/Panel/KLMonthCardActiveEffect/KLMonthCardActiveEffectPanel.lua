---@class KLMonthCardActiveEffectPanel:UIKmlLuaPanelBase
---@field view KLMonthCardActiveEffectPanelView
local KLMonthCardActiveEffectPanel = class(UIKmlLuaPanelBase)
local this = KLMonthCardActiveEffectPanel
function this:AsyncLoadUI()
end
---创建时调用一次
function this:Init()
end

---注册UI事件和服务器消息
function this:RegistEvents()
end
---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
    if self.args then
--[[        GUI:SetActive(self.view.MonthCard_ActiveIcon,false)
        if self.args.cfgId == EMonthType.MonthCard then
            GUI:Effect_Create(self.view.root, {
                effectid = "10002",
                mpos = "0,0,0",
                mscale = "1,1,1",
                mrotate = "0,0,0"
            })
        else
            GUI:Effect_Create(self.view.root, {
                effectid = "10003",
                mpos = "0,0,0",
                mscale = "1,1,1",
                mrotate = "0,0,0"
            })
        end]]
    end


    --[[        self.MonthTimer = SL:Schedule(self.MonthTimer,0, 1, 1, function()
                    GUI:SetActive(self.view.root,false)
            end)]]
end

function this:Close()
 
end

return this
