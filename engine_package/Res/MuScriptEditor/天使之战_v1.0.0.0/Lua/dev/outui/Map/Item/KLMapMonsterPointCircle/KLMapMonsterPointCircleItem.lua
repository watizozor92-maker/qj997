---@class KLMapMonsterPointCircleItem:UIKmlLuaPanelBase
---@field view KLMapMonsterPointCircleItemView
local KLMapMonsterPointCircleItem = class(UIKmlLuaPanelBase)
local this =KLMapMonsterPointCircleItem

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
        ---@type cfg_monsterPoint_column
        local tempTbl = self.args[1]
        local isShow = self.args[2]
        local showTextStr = ""
        if self.isMin and tempTbl.monsterCount then
            showTextStr = "X"..tempTbl.monsterCount
        else
            if not string.isNullOrEmpty(tempTbl.monsterName) and tempTbl.monsterCount > 0 then
                showTextStr = string.format("%s\nX%s",tempTbl.monsterName,tempTbl.monsterCount)
            end
        end
        GUI:Text_setString(self.view.text, showTextStr)
        GUI:setContentSize(self.view.bg,tempTbl.circleLenth,tempTbl.circleLenth)
        GUI:setContentSize(self.view.root,tempTbl.circleLenth,tempTbl.circleLenth)
        GUI:setContentSize(self.view.text,tempTbl.circleLenth - 30,tempTbl.circleLenth - 30)
        if self.args.mapIconVisibleInfo then
            GUI:setVisible(self.view.bg, self.args.mapIconVisibleInfo == "1")
        else
            GUI:setVisible(self.view.bg, true)
        end
    end
end

function this:FormatText(isMin)
    if self.args and type then
        ---@type cfg_monsterPoint_column
        local tempTbl = self.args[1]
        local isShow = self.args[2]
        local showTextStr = ""
        self.isMin = isMin
        if isMin and tempTbl.monsterCount then
            showTextStr = "X"..tempTbl.monsterCount
        else
            if not string.isNullOrEmpty(tempTbl.monsterName) and tempTbl.monsterCount > 0 then
                showTextStr = string.format("%s\nX%s",tempTbl.monsterName,tempTbl.monsterCount)
            end
        end
        GUI:Text_setString(self.view.text, showTextStr)
    end
end

function this:GetTextKml()
    return self.view.text
end

function this:Hide()
end

function this:Close()
end

return this
