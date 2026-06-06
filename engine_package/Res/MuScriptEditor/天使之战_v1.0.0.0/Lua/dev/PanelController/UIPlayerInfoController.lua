---@class UIPlayerInfoController
---@field isHideAllSystemFunction boolean @是否隐藏所有系统功能
UIPlayerInfoController = class()
local this = UIPlayerInfoController
--Begin以下部分为编辑器自动生成，不要修改，预制改了可以重新生成
--End上面部分为编辑器自动生成，不要修改，预制改了可以重新生成
function this.Init()
    this.eventContainer = EventContainer(EventManager)
    this.RegisterEvent()
    this.isHideAllSystemFunction = false
    this.hpProgressType = EHpProgressType.Number
    this.isHideTeamPanel = false
    this.isHideTaskPanel = false
    this.isFindRoadRideMount = false
    this.curRideMount = -1
    this.popoverDatas = {}
    this.BlockedFunctionList = {}
    this.systemFunction = {}
    this.isExpandSystemFunction = false
end
---@return void @数据清理
function this.Reset()
    this.ClearFreeBuffAdd()
    this.isHideTeamPanel = false
    this.isHideTaskPanel = false
    this.isFindRoadRideMount = false
    this.curRideMount = -1
    this.popoverDatas = {}
    this.BlockedFunctionList = {}
    this.isExpandSystemFunction = false
end

function this.RegisterEvent()
    this.eventContainer:Regist(Event.OpenSystemFunction, this.OpenSystemFunction)
end

function this.ClearFreeBuffAdd()
    this.freeBuffAdd = nil
    this.freeInfo = nil
end

---@param message BufferProtos.FreeBuffRes
function this.RefreshFreeBuffAdd(message)
    if not this.freeBuffAdd then
        this.freeBuffAdd = {}
        this.freeInfo = {}
    end
    table.clear(this.freeBuffAdd)
end

---@param type EFreeBuffAddType
---@param message BufferProtos.FreeBuff
function this.AddFreeBuffData(name, valueList, panel, showType, message)
    local value
    if type(valueList) == "table" then
        value = #valueList >= 1 and valueList[1] or 0
    else
        value = valueList
    end
    local data = {
        name = name,
        value = value,
        panel = panel,
        showType = showType,
        message = message,
    }
    this.freeBuffAdd[message.cfgId] = data
end
---是否隐藏所有系统功能
function this.SetIsHideAllSystemFunction(isHideAllSystemFunction)
    this.isHideAllSystemFunction = isHideAllSystemFunction
end

function this.ReviseHpProgressType(hpProgressType)
    this.hpProgressType = tonumber(hpProgressType)
end

function this.SetIsHideTeamPanel(isHide)
    this.isHideTeamPanel = isHide
 
end

function this.SetIsHideTaskPanel(isHide)
    this.isHideTaskPanel = isHide
 
end
---寻路自动自动骑乘坐骑
function this.SetIsFindRoadRideMount(isRide)
    this.isFindRoadRideMount = isRide
end

---寻路自动自动骑乘坐骑
function this.SetCurRideMount(mountId)
    this.curRideMount = mountId
end
---设置气泡数据
function this.SetPopoverData(data)
    local id = data[2]
    if not this.popoverDatas[id] then
        this.popoverDatas[id] = {}
    end
    this.popoverDatas[id].id = id

    if data.Length >= 3 then
        this.popoverDatas[id].icon = data[3]
    else
        this.popoverDatas[id].icon = "common"
    end

    if data.Length >= 4 then
        this.popoverDatas[id].disappeartype = tonumber(data[4])
    else
        this.popoverDatas[id].disappeartype = 0
    end

    if data.Length >= 5 then
        this.popoverDatas[id].disappeartype2 = tonumber(data[5])
    else
        this.popoverDatas[id].disappeartype2 = 0
    end
    this.popoverDatas[id].isKml = true
    EventManager.Dispatch(Event.SetPopoverData, this.popoverDatas[id])
end
---关闭气泡
function this.ClosePopover(data)
    local id = data[2]
    this.popoverDatas[id] = nil
    EventManager.Dispatch(Event.ClosePopover, id)
end
---设置屏蔽的功能
function this.SetBlockedFunction(param)
    for i = 2, param.Length - 1 do
        local systemName = param[i]
        this.BlockedFunctionList[systemName] = true
    end
end
---设置屏蔽的功能
function this.KLSetBlockedFunction(param)
    for i = 2, #param - 1 do
        local systemName = param[i]
        this.BlockedFunctionList[systemName] = true
    end
end

---开启系统功能界面
function this.OpenSystemFunction(id, data)
    if this.systemFunction[data] then
        this.systemFunction[data]()
    end
end

---展开系统功能
function this.ExpandSystemFunction(isExpand)
    this.isExpandSystemFunction = isExpand
    if isExpand then
       -- GUI:UIPanel_Close("dev/ui/MainUI/Panel/KLMainAttack/KLMainAttackPanel")
        this.isExpandSystemFunction = true
    else
        this.isExpandSystemFunction = false
       -- GUI:UIPanel_Open("dev/ui/MainUI/Panel/KLMainAttack/KLMainAttackPanel")
    end
end

return this