---@class KLCalcPanel:UIKmlLuaPanelBase
---@field view KLCalcPanelView
local KLCalcPanel = class(UIKmlLuaPanelBase)
local this =KLCalcPanel
---创建时调用一次
function this:Init()
    self.nowNum = 0
    self.maxNum = self.args["maxNum"]
    ---是否关闭当前界面
    self.isClosePanel = 1
    if self.args and self.args["isClosePanel"] then
        self.isClosePanel = self.args["isClosePanel"]
    end
    self.x = self.args["x"]
    self.y = self.args["y"]
    if self.x then
        GUI:setPositionX(self.view.root,self.x)
    end
    if self.y then
        GUI:setPositionY(self.view.root,self.y)
    end
    self.callback = self.args["callback"]
    self.ins = self.args["ins"]
end

---创建或者刷新界面数据时调用
function this:Refresh()
    GUI:SetAsLastSibling(self.view.sureButton)
    self.nowNum = 0
    GUI:Text_setString(self.view.intro, self.args.intro or "增加点数")
    GUI:Text_setString(self.view.num, "0")
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.CloseBtn,self,self.CloseBtnOnClick)
    GUI:AddOnClickEvent(self.view.firstButton,self,self.firstButtonOnClick)
    GUI:AddOnClickEvent(self.view.twoButton,self,self.twoButtonOnClick)
    GUI:AddOnClickEvent(self.view.threeButton,self,self.threeButtonOnClick)
    GUI:AddOnClickEvent(self.view.fourButton,self,self.fourButtonOnClick)
    GUI:AddOnClickEvent(self.view.fiveButton,self,self.fiveButtonOnClick)
    GUI:AddOnClickEvent(self.view.sixButton,self,self.sixButtonOnClick)
    GUI:AddOnClickEvent(self.view.sevenButton,self,self.sevenButtonOnClick)
    GUI:AddOnClickEvent(self.view.eightButton,self,self.eightButtonOnClick)
    GUI:AddOnClickEvent(self.view.nineButton,self,self.nineButtonOnClick)
    GUI:AddOnClickEvent(self.view.zeroButton,self,self.zeroButtonOnClick)
    GUI:AddOnClickEvent(self.view.undoButton,self,self.undoButtonOnClick)
    GUI:AddOnClickEvent(self.view.sureButton,self,self.sureButtonOnClick)
end

function this:CloseBtnOnClick()
    GUI:UIPanel_Close("dev/ui/Common/Panel/KLCalc/KLCalcPanel")
    GUI:UIPanel_Close("dev/outui/SkillTips/Panel/KLUISkillUpTips/KLUISkillUpTipsPanel")
    if self.callback then
        self.callback(self.ins, self.nowNum)
    end
end

function this:firstButtonOnClick()
    self.nowNum = self.nowNum * 10 + 1
    self:SetNum()
end
function this:twoButtonOnClick()
    self.nowNum = self.nowNum * 10 + 2
    self:SetNum()
end
function this:threeButtonOnClick()
    self.nowNum = self.nowNum * 10 + 3
    self:SetNum()
end
function this:fourButtonOnClick()
    self.nowNum = self.nowNum * 10 + 4
    self:SetNum()
end
function this:fiveButtonOnClick()
    self.nowNum = self.nowNum * 10 + 5
    self:SetNum()
end
function this:sixButtonOnClick()
    self.nowNum = self.nowNum * 10 + 6
    self:SetNum()
end
function this:sevenButtonOnClick()
    self.nowNum = self.nowNum * 10 + 7
    self:SetNum()
end
function this:eightButtonOnClick()
    self.nowNum = self.nowNum * 10 + 8
    self:SetNum()
end
function this:nineButtonOnClick()
    self.nowNum = self.nowNum * 10 + 9
    self:SetNum()
end
function this:zeroButtonOnClick()
    self.nowNum = self.nowNum * 10
    self:SetNum()
end

function this:undoButtonOnClick()
    self.nowNum = self.nowNum//10
    self:SetNum()
end

function this:SetNum()
    if self.nowNum > self.maxNum then
        self.nowNum = self.maxNum
    end
    
    GUI:Text_setString(self.view.num, tostring(self.nowNum))
end

function this:sureButtonOnClick()
    if self.callback then
        self.callback(self.ins, self.nowNum)
    end
    if self.isClosePanel == 1 then
        GUI:UIPanel_Close("dev/ui/Common/Panel/KLCalc/KLCalcPanel")
    end
end

function this:Close()
end

return this
