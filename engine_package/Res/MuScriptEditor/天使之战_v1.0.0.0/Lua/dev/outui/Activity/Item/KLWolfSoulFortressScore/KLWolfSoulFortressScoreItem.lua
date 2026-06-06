---@class KLWolfSoulFortressScoreItem:UIKmlLuaPanelBase
---@field view KLWolfSoulFortressScoreItemView
---@field all_item {}
local KLWolfSoulFortressScoreItem = class(UIKmlLuaPanelBase)
local this = KLWolfSoulFortressScoreItem

---创建时调用一次
function this:Init()
    self.all_item = {}
    GUI:DataListInitData(self.view.itemDataList, function()
        return self:BtnDataListItemCountFunc()
    end, function(realIndex)
        return self:BtnDataListItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:BtnDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:BtnDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
end

---注册UI事件和服务器消息
function this:RegistEvents()
end
---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
end
---@param message {index:number,data:{score:number,career:number,level:number,name:string,rank:number,rid:string}}
function this:RefreshItem(message)
    self.data = message.data
    self.index = message.index
    if self.data then
        if self.data.rank < 4 then
            GUI:SetActive(self.view.rankImg,true)
            GUI:SetActive(self.view.myRank,false)
            
            GUI:Image_loadTexture(self.view.rankImg,"rank_"..self.data.rank, "Atlas/UIWolfSoulFortress.spriteatlas")
            GUI:Image_loadTexture(self.view.rankBg,"rankBg_"..self.data.rank, "Atlas/UIWolfSoulFortress.spriteatlas")
        else
            GUI:SetActive(self.view.rankImg,false)
            GUI:SetActive(self.view.myRank,true)
            GUI:Text_setString(self.view.myRank, tostring(self.data.rank))
            GUI:Image_loadTexture(self.view.rankBg,"rankBg_4", "Atlas/UIWolfSoulFortress.spriteatlas")

        end
        GUI:Text_setString(self.view.myRank, tostring(self.data.rank))
        GUI:Text_setString(self.view.myName, tostring(self.data.name))
        local career = self.data.career
        ---@type cfg_career_column[]
        local career_tbl = SL:GetConfigTable("cfg_career")
        for _, v in pairs(career_tbl) do
            if v.baseCareer == career then
                GUI:Text_setString(self.view.myCareer, v.name)
                break
            end
        end
        GUI:Text_setString(self.view.myLevel, tostring(self.data.level))
        GUI:Text_setString(self.view.myScore, tostring(self.data.score))
        self.reward = InfoManager.wolfSoulFortressInfo:GetNowRankReward(self.data.rank)
    end
    GUI:DataListUpdateData(self.view.itemDataList)
end

function this:BtnDataListItemCountFunc()
    local count = 0
    if self.reward then
        count = #self.reward
    end
    return count
end

function this:BtnDataListItemGetFunc(realIndex)
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

function this:BtnDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:BtnDataListItemUpdateFunc(realIndex, kmlcontrol)

end

function this:Close()
end

return this
