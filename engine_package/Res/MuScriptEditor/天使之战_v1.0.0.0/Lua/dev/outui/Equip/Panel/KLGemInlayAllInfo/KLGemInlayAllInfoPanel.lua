---@class KLGemInlayAllInfoPanel:UIKmlLuaPanelBase
---@field view KLGemInlayAllInfoPanelView
local KLGemInlayAllInfoPanel = class(UIKmlLuaPanelBase)
local this =KLGemInlayAllInfoPanel
function this:AsyncLoadUI()
        end
---创建时调用一次
function this:Init()

    GUI:DataListInitData(self.view.datalist4, function()
        return self:CurrentCountFunc()
    end, function(realIndex)
        return self:CurrentGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:CurrentInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:CurrentUpdateFunc(realIndex, kmlcontrol)
    end)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.closeMaskBg, self, self.OnClickCloseMaskBg)
end
---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
    self.AllGemSuitList = {}
    for i, v in ipairs(InfoManager.gemSlateInfo.AllGemSuitCfgTbl) do
        local data = v
        local isActive = false
        if data.sortId<0 then
            if InfoManager.gemSlateInfo.maxLevelActiveGroupSuitCfgLst[data.gemCondition[1]] and data.id==InfoManager.gemSlateInfo.maxLevelActiveGroupSuitCfgLst[data.gemCondition[1]].id then
                isActive = true
            end
        end
        table.insert(self.AllGemSuitList,{data=data,isActive=isActive})
    end
    table.sort(self.AllGemSuitList,function(a, b)
        if not a.isActive and not b.isActive then
            return a.data.id < b.data.id
        end
        if a.isActive and b.isActive then
            return a.data.id < b.data.id
        end
        return a.isActive
    end)
    GUI:DataListUpdateData(self.view.datalist4)
end

function this:CurrentCountFunc()
    return #self.AllGemSuitList
end
function this:CurrentGetFunc(realIndex)
    
end
function this:CurrentInitFunc(realIndex,kmlcontrol)

end
function this:CurrentUpdateFunc(realIndex,kmlcontrol)
    ---@type cfg_equip_gemSuit_column
    local data = self.AllGemSuitList[realIndex + 1].data
    local isActive = self.AllGemSuitList[realIndex + 1].isActive
    local NotActive = GUI:GetChildControl(self.view.datalist4, realIndex, "NotActive")
    local ActiveTxt = GUI:GetChildControl(self.view.datalist4, realIndex, "ActiveTxt")
    
    GUI:SetActive(NotActive,false)
    GUI:SetActive(ActiveTxt,isActive)
    local txtShowColor="#FFFFFF"
    local titleColor="#e6e600"
    if not isActive then
        txtShowColor="#8E8E8E"
        titleColor="#8E8E8E"
    end
    local gemTitleParent = GUI:GetChildControl(self.view.datalist4, realIndex, "gemTitleParent")
    local attrInfoTxt = GUI:GetChildControl(self.view.datalist4, realIndex, "attrInfoTxt")
    local skillInfoTxt = GUI:GetChildControl(self.view.datalist4, realIndex, "skillInfoTxt")

    GUI:Text_setString(gemTitleParent,data.title)
    GUI:Text_setTextColor(gemTitleParent,titleColor)
    local attrStr=""
    for i,v in ipairs(data.suitAtt) do
        local tmpStr=SL:GetConfig("cfg_att_info", v[1]).showname..v[2].."  "
        attrStr=attrStr..tmpStr
    end
    -- local attrTbl = SL:GetConfig("cfg_att_info", v[1])
    GUI:Text_setString(attrInfoTxt,attrStr)
    GUI:Text_setTextColor(attrInfoTxt,txtShowColor)
    GUI:SetActive(attrInfoTxt,attrStr ~= "")
    GUI:Text_setString(skillInfoTxt,data.skillText)
    GUI:Text_setTextColor(skillInfoTxt,txtShowColor)
end

function this:OnClickCloseMaskBg()
    GUI:UIPanel_Close("dev/outui/Equip/Panel/KLGemInlayAllInfo/KLGemInlayAllInfoPanel")
end
    
function this:Close()
end

return this
