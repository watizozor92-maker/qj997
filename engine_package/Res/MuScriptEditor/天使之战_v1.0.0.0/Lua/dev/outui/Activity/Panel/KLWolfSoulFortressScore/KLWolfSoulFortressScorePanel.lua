---@class KLWolfSoulFortressScorePanel:UIKmlLuaPanelBase
------@field view KLWolfSoulFortressScorePanelView
---@field args {success:boolean,list:{score:number,career:number,level:number,name:string,rank:number,rid:string}[]}
---@field all_item KLWolfSoulFortressScoreItem[]
---@field myRankInfo {index:number,data:{score:number,career:number,level:number,name:string,rank:number,rid:string}}
local KLWolfSoulFortressScorePanel = class(UIKmlLuaPanelBase)
local this = KLWolfSoulFortressScorePanel
function this:AsyncLoadUI()
end
---创建时调用一次
function this:Init()
    self.all_item = {}
    GUI:DataListInitData(self.view.rankList, function()
        return self:BtnDataListItemCountFunc()
    end, function(realIndex)
        return self:BtnDataListItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:BtnDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:BtnDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    GUI:DataListInitData(self.view.itemDataList, function()
        return self:BtnDataListItemCountFunc_2()
    end, function(realIndex)
        return self:BtnDataListItemGetFunc_2(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:BtnDataListItemInitFunc_2(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:BtnDataListItemUpdateFunc_2(realIndex, kmlcontrol)
    end)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btnClose, self, self.CloseOnclick)
end

function this:CloseOnclick()
    GUI:UIPanel_Close("dev/outui/Activity/Panel/KLWolfSoulFortressScore/KLWolfSoulFortressScorePanel")
end

---界面显示时调用一次
function this:Show()

end
---创建或者刷新界面数据时调用
function this:Refresh()
    SL.HideMainPanel()
    if self.args then
        if self.args.success then
            GUI:Image_loadTexture(self.view.bgTitle, "win", "Atlas/UIWolfSoulFortress.spriteatlas")
        else
            GUI:Image_loadTexture(self.view.bgTitle, "loser", "Atlas/UIWolfSoulFortress.spriteatlas")
        end
        for k, v in pairs(self.args.list) do
            if v.rid == tostring(SL:GetMetaValue(EMetaVarGetKey.UID)) then
                GUI:Text_setString(self.view.myRank, tostring(v.rank))
                GUI:Text_setString(self.view.myName, tostring(v.name))
                local career = v.career
                ---@type cfg_career_column[]
                local career_tbl = SL:GetConfigTable("cfg_career")
                for _, v in pairs(career_tbl) do
                    if v.baseCareer == career then
                        GUI:Text_setString(self.view.myCareer, v.name)
                        break
                    end
                end
                GUI:Text_setString(self.view.myLevel, tostring(v.level))
                GUI:Text_setString(self.view.myScore, tostring(v.score))
                self.myRankInfo = v
                break
            end
        end
    end
    InfoManager.wolfSoulFortressInfo:GetCfgByOpenServerDay()
    if self.myRankInfo then
        self.reward = InfoManager.wolfSoulFortressInfo:GetNowRankReward(self.myRankInfo.rank)
    end
    GUI:DataListUpdateData(self.view.rankList)
    GUI:DataListUpdateData(self.view.itemDataList)
end

function this:BtnDataListItemCountFunc()
    return table.count(self.args.list)
end

function this:BtnDataListItemGetFunc(realIndex)
    local item = GUI:UIPanel_Open("dev/outui/Activity/Item/KLWolfSoulFortressScore/KLWolfSoulFortressScoreItem", self.view.rankList, self, nil, true)
    
    self.all_item[item.view.root] = item
    return item.view.root
end

function this:BtnDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:BtnDataListItemUpdateFunc(realIndex, kmlcontrol)
    local tempData = {
        index = realIndex + 1,
        data = self.args.list[tostring(realIndex + 1)]
    }
    self.all_item[kmlcontrol]:RefreshItem(tempData)
end

function this:BtnDataListItemCountFunc_2()
    local count = 0
    if self.reward then
        count = #self.reward
    end
    return count
end

function this:BtnDataListItemGetFunc_2(realIndex)
    local item = GUI:Item_Create(self.view.itemDataList, {
        width = "50",
        height = "50",
        itemid = self.reward[realIndex + 1].itemId,
        mfixsize = "80,80",
        tips = "1",
        itemcustomcount = self.reward[realIndex + 1].itemCount,
    })
    
    return item
end

function this:BtnDataListItemInitFunc_2(realIndex, kmlcontrol)
end

function this:BtnDataListItemUpdateFunc_2(realIndex, kmlcontrol)

end

function this:Close()
    SL.ShowMainPanel()
end

return this
