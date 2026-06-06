---@class KLFashionMountTipPanel:UIKmlLuaPanelBase
---@field view KLFashionMountTipPanelView
local KLFashionMountTipPanel = class(UIKmlLuaPanelBase)
local this =KLFashionMountTipPanel
function this:AsyncLoadUI()
end
---创建时调用一次
function this:Init()
    GUI:DataListInitData(self.view.datalist_ride, function()
        return table.count(self.rides)
    end, function()
        
    end, function()
        
    end, function(realIndex)
        local mountIcon = GUI:GetChildControl(self.view.datalist_ride, realIndex, 'mountIcon')
        local rideData = self.rides[realIndex + 1]
        GUI:Image_loadTexture(mountIcon, rideData.cfgId, "Atlas/MountIcon.spriteatlas")
    end)

    GUI:DataListInitData(self.view.datalist_Name, function()
        return table.count(self.rides)
    end, function()

    end, function()

    end, function(realIndex)
        local name = GUI:GetChildControl(self.view.datalist_Name, realIndex, 'rideName')
        local rideData = self.rides[realIndex + 1]
        local tbl = SL:GetConfig("cfg_item", rideData.cfgId)
        GUI:Text_setString(name, tbl.name)
        GUI:Text_setTextColor(name, rideData.isActive and "#FFFFFF" or "#8A8A8A")
    end)

    GUI:DataListInitData(self.view.datalist_Info, function()
        return table.count(self.infos)
    end, function()

    end, function()

    end, function(realIndex)
        local num = GUI:GetChildControl(self.view.datalist_Info, realIndex, 'num')
        local value = GUI:GetChildControl(self.view.datalist_Info, realIndex, 'value')
        local info = self.infos[realIndex + 1]
        local color = info.isActive and "#FFFFFF" or "#8A8A8A"
        GUI:Text_setString(num, info.name)
        GUI:Text_setString(value, info.attrText)
        GUI:Text_setTextColor(num, color)
        GUI:Text_setTextColor(value, color)
    end)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.maskBg, self, self.CloseSelf)
end

function this:CloseSelf()
    GUI:UIPanel_Close(self.filePath)
end
---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
    local mountTbl = SL:GetConfig("cfg_mount", self.args)
    local rideList, suitEffect, suitSkill, activeNum = SL:GetSuitEquipInfoList(mountTbl.itemId, "mount")
    self.rides = rideList
    self.infos = {}
    for k, v in pairs(suitEffect) do
        local attrName = SL:GetConfig("cfg_att_info", v[1].attId).name
        local attrText = attrName.."+"..v[1].attNum
        table.insert(self.infos, {name = k.."只坐骑", isActive = v[1].isActive, attrText = attrText})
    end
    local titleName = "臻藏系列"
    local totalCount = #rideList
    GUI:Text_setString(self.view.titleText, string.format("%s（%d/%d）", titleName, activeNum, totalCount))
    local height1 = math.ceil(totalCount / 3) * 90
    GUI:setContentSize(self.view.gridview5, 322, height1)                          --模型每行90
    GUI:setContentSize(self.view.layout_Name, 322, totalCount * 30 + 5)     --名字文本每行30
    GUI:DataListUpdateData(self.view.datalist_ride, true)
    GUI:DataListUpdateData(self.view.datalist_Name, true)
    GUI:DataListUpdateData(self.view.datalist_Info, true)
end

function this:Hide()
end

function this:Close()
end

return this
