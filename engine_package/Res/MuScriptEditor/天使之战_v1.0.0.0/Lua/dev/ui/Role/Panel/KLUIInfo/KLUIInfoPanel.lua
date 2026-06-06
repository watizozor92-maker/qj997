---@class KLUIInfoPanel:UIKmlLuaPanelBase
---@field view KLUIInfoPanelView
local KLUIInfoPanel = class(UIKmlLuaPanelBase)
local this = KLUIInfoPanel
---创建时调用一次
function this:Init()
    GUI:DataListInitData(self.view.attr_datalist, function()
        return self:ItemCountFunc()
    end, function(realIndex)
        return self:ItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:ItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:ItemUpdateFunc(realIndex, kmlcontrol)
    end)
    ---@type cfg_global_column
    local tbl_str = SL:GetConfig("cfg_global", 84)
    if tbl_str then
        local tbl = string.split(tbl_str.value, '#')
        self.intervalTime = tonumber(tbl[1]) / 1000
        self.showTime = tonumber(tbl[2]) / 1000
    else
        self.intervalTime = 0.1
        self.showTime = 2
    end
    ---@type cfg_global_column
    local cfg = SL:GetConfig("cfg_global", 1702)
    self.limitIndex = cfg and tonumber(cfg.value) or 10
    ---@type KLUIInfoChangeItem[]
    self.attrItemList = {}
    self.totalQueue = {}
    self.tempMinAttrValue = {}
    self.attrQueue = {}
    self.tempAttrList = {}
    self.totalItemNum = 0
    self.itemIndex = 0
    self.listIsReady = false
end

function this:ItemCountFunc()
    return self.limitIndex
end

function this:ItemGetFunc(realIndex)
    local item = GUI:UIPanel_Open("dev/ui/Role/Item/KLUIInfoChange/KLUIInfoChangeItem", self.view.attr_datalist, self, { baseUI = self }, true)
    self.attrItemList[realIndex + 1] = item
    return item.view.root
end

function this:ItemInitFunc(realIndex, kmlcontrol)

end

function this:ItemUpdateFunc(realIndex, rectTrans)

end

---创建或者刷新界面数据时调用
function this:Refresh()
    GUI:DataListUpdateData(self.view.attr_datalist, nil, function()
        self.listIsReady = true
    end)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    SL:RegisterLUAEvent(LUA_EVENT_FIGHT_ATT_CHANGE, self.RoleDat_Me_FightAttrChange, self)
end

---@param message MapProtos.FightAttrInfoRes
function this:RoleDat_Me_FightAttrChange(_, message)
    ---最小攻击力
    local dcNum = 0
    ---最小魔法攻击力
    local mcNum = 0
    ---最小诅咒攻击力
    local zzNum = 0
    local tempAttrList = {}
    for i, v in pairs(message) do
        ---@type cfg_att_info_column
        local attrTbl = SL:GetConfig("cfg_att_info", v.type)
        local isMainShow = attrTbl.isMainshow
        local isShow = false
        if isMainShow[1] == 1 then
            isShow = true
        elseif isMainShow[1] == 2 then
            local baseCareer = SL:GetMetaValue(EMetaVarGetKey.JOB)
            if baseCareer == 2 then
                isShow = table.count(isMainShow, 2) >= 2
            else
                isShow = table.contains(isMainShow, baseCareer)
            end
        end

        if isShow then
            if v.type == EMUCharacterAttrType.minDC then
                dcNum = v.num
            elseif v.type == EMUCharacterAttrType.minMC then
                mcNum = v.num
            elseif v.type == EMUCharacterAttrType.minZuZhou then
                zzNum = v.num
            else
                table.insert(tempAttrList, v)
            end
        end
    end
    if #tempAttrList > 0 then
        if #self.totalQueue > 0 then
            local list = self.totalQueue[1]
            for i, v in ipairs(tempAttrList) do
                table.insert(list, v)
            end
            self.totalQueue[1] = list
        else
            self.totalQueue[#self.totalQueue + 1] = tempAttrList
            self.tempMinAttrValue[#self.totalQueue] = { minDC = dcNum, minMC = mcNum, minZZ = zzNum }
        end
        self:RefreshAttrQueue()
    end
end

function this:RefreshTotalItemNum()
    self.totalItemNum = self.totalItemNum - 1
    if self.totalItemNum <= 0 then
        self.totalItemNum = 0
        self.itemIndex = 0
        self:RefreshAttrQueue()
    end
end

function this:RefreshAttrQueue()
    if not self.listIsReady then
        return
    end
    if not self.scheduleId and self.totalItemNum == 0 then
        self.attrQueue = table.remove(self.totalQueue, 1)
        self.tempAttrList = table.remove(self.tempMinAttrValue, 1)
        if self.attrQueue then
            self.scheduleId = SL:Schedule(self.scheduleId, 0, self.intervalTime, -1, function()
                local data = table.remove(self.attrQueue, 1)
                if data then
                    self.itemIndex = self.itemIndex + 1
                    local ui = self.attrItemList[self.itemIndex]
                    ui:RefreshUI(data, self.tempAttrList.minDC, self.tempAttrList.minMC, self.tempAttrList.minZZ, self.showTime)
                    ui:ShowUI()
                    if self.itemIndex >= self.limitIndex then
                        self.itemIndex = 0
                    end
                    self.totalItemNum = self.totalItemNum + 1
                else
                    SL:UnSchedule(self.scheduleId)
                    self.scheduleId = nil
                end
            end)
        end
    end
end

function this:Close()
    if self.scheduleId then
        SL:UnSchedule(self.scheduleId)
        self.scheduleId = nil
    end
    self.totalQueue = {}
    self.tempMinAttrValue = {}
    self.attrQueue = {}
    self.tempAttrList = {}
    self.totalItemNum = 0
    self.itemIndex = 0
end

return this
