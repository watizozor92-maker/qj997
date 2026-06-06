---@class KLLevelItem:UIKmlLuaPanelBase
---@field view KLLevelItemView
---@field args cfg_rep_column
---@field baseUI KLActivityDetailPanel
local KLLevelItem = class(UIKmlLuaPanelBase)
local this =KLLevelItem
---创建时调用一次
function this:Init()
    
end

---创建或者刷新界面数据时调用
function this:Refresh()
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:SetToggleOnValueChange(self.view.KLLevel,self,self.LevelOnToggleValueChange)
    GUI:AddOnClickEvent(self.view.no_btn, self, self.OnClickS_no_btn)
end

function this:LevelOnToggleValueChange(id,agrs,data)
    local isToggle = data[1]
    if isToggle then
        SL:onLUAEvent(SELECT_LEVEL_STAGE,self.args)
    end
end

function this:RefreshItem(data)
    self.args = data
    local level = SL:GetMetaValue(EMetaVarGetKey.LEVEL)

    local levelRange = self.args.name[1]
    local color = "#ff2323"
    local isMeet = level >= self.args.level[1] and level <= self.args.level[2]
    if isMeet then
        color = "#ffffff"
    end

    self.tip_str = ""
    if level > self.args.level[2] then
        self.tip_str = "已超出该副本等级上限"
    elseif level < self.args.level[1] then
        self.tip_str = self.args.level[1] .. "级解锁"
        --GUI:Text_setTextColor(self.view.levelName,"#ff2323")
    end
    GUI:SetIsOnWithoutNotify(self.view.KLLevel,self.baseUI.curSelectLevelStage == self.args.repLevel)
    levelRange = GUIUtil.GetColorText(levelRange,color)
    GUI:Text_setString(self.view.levelName,levelRange)
    GUI:setVisible(self.view.noClick,not isMeet)
    GUI:setSwallowTouches(self.view.KLLevel,not isMeet)
    if isMeet then
        GUI:SetActive(self.view.no_btn,false)
    else
        GUI:SetActive(self.view.no_btn,true)
    end
end

function this:Close()
end

function this:OnClickS_no_btn()
    SL:TipMessage( self.tip_str,1, NoticeType.NoticeMid )
end

return this
