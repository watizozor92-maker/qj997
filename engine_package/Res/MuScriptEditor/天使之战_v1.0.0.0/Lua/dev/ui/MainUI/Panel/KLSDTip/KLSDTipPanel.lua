---@class KLSDTipPanel:UIKmlLuaPanelBase
---@field view KLSDTipPanelView
local KLSDTipPanel = class(UIKmlLuaPanelBase)
local this = KLSDTipPanel
---创建时调用一次
function this:Init()

end

---创建或者刷新界面数据时调用
function this:Refresh()
    if self.args then
        GUI:Text_setString(self.view.des, self.args.content)
        GUI:setPositionY(self.view.bg, self.args.y)
        GUI:setPositionX(self.view.bg, self.args.x)
        GUI:setContentSize(self.view.bg, self.args.width, self.args.height)
    end
end

---注册UI事件和服务器消息
function this:RegistEvents()
    SL:RegisterLUAEvent(LUA_EVENT_SHIELDCHANGE, self.RefreshShield, self)--主角护盾值改变事件
    SL:RegisterLUAEvent(LUA_EVENT_AGSTOCHANGE, self.RefreshAgsto, self)--主角技能值改变事件
    SL:RegisterLUAEvent(LUA_EVENT_COMBOVALUE_CHANGE, self.RefreshComboValue, self)--主角技能值改变事件
    GUI:AddOnClickEvent(self.view.root, self, self.ColsePanel)
end

function this:RefreshShield()
    if self.args and self.args.type == "SD" then
        local shield = math.floor(Global.CurSD)
        local maxShield = math.floor(Global.MaxSD)
        local des = "防护值（SD）：" .. shield .. "/" .. maxShield
        GUI:Text_setString(self.view.des, des)
    end

end

function this:RefreshAgsto()
    if self.args and self.args.type == "AG" then
        local agsto = math.floor(Global.CurAG)
        local maxAgsto = math.floor(Global.MaxAG)
        local des = "技能值（AG）：" .. agsto .. "/" .. maxAgsto
        GUI:Text_setString(self.view.des, des)
    end
end

function this:RefreshComboValue(_, data)
    if self.args and self.args.type == "连击" then
        local des = "连击技 <color=#1ADD2FFF>" .. data .. "</color>%\n连击技会对周围目标造成伤害,且对主目标额外造成大量伤害\n连击能量达到100%后会自动施放连击技"
        GUI:Text_setString(self.view.des, des)
    end
end

function this:ColsePanel()
    GUI:UIPanel_Close("dev/ui/MainUI/Panel/KLSDTip/KLSDTipPanel")
end

function this:Close()
end

return this
