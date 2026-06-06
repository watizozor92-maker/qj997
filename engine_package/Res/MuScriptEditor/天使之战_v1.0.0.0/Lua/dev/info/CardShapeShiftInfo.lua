---@class CardShapeShiftInfo @注释
CardShapeShiftInfo = class()
local this = CardShapeShiftInfo

function this:ctor()

end

function this:Reset()
    
end

function this:Init()
    self:InitData()
    self:RegistMessages()
end

function this:InitData()
end

function this:RegistMessages()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_FSPREVIEW_LIST, self.RES_FSPREVIEW_LIST, self)
end

---判断是否有满足条件拍脸图
function this:LUA_EVENT_ENTER_MAP()
    self.needOpenUI = {}
    self.open_server_day = 0
    if SL:GetEnterRoleRes() and  SL:GetEnterRoleRes().openServerTime then
        local defTime = os.time() - SL:GetEnterRoleRes().openServerTime / 1000
        if defTime > 0 then
            self.open_server_day = math.ceil(defTime / 86400)
        end
    end
    local level = SL:GetMetaValue("LEVEL")
    ---@type cfg_system_foreshow_column[]
    local cfg_system_foreshow = SL:GetConfigTable("cfg_system_foreshow")
    for i, v in pairs(cfg_system_foreshow) do
        local needShow = true
        if v.needLevel == 0 then
            needShow = false
        else
            if v.needLevel and v.needLevel > level then
                needShow = false
            end
        end

        if v.needDay == 0 then
            needShow = false
        else
            if needShow and ((v.needDay and v.needDay > self.open_server_day) or (v.endTime and v.endTime < self.open_server_day)) then
                --needShow = false
            end
        end

        if needShow and self.needShowPanel[v.id] then
            self.needOpenUI[#self.needOpenUI + 1] = v.id
        end
    end
    if #self.needOpenUI > 0 then
        SL.HideMainPanel()
        GUI:CloseAllUIWithoutMainUI()
        local uiID = table.remove(self.needOpenUI, 1)
        local tbl = SL:GetConfig("cfg_system_foreshow", uiID)
        GUI:UIPanel_Open(tbl.screenName, nil, nil, uiID)
    end
end

function this:REFRESH_NEXT_CARD_SHAPE_UI()
    if self.needOpenUI and #self.needOpenUI > 0 then
        SL.HideMainPanel()
        GUI:CloseAllUIWithoutMainUI()

        local uiID = table.remove(self.needOpenUI, 1)
        local tbl = SL:GetConfig("cfg_system_foreshow", uiID)
        GUI:UIPanel_Open(tbl.screenName, nil, nil, uiID)
    end
end

function this:RES_FSPREVIEW_LIST(_, message)
    self.needShowPanel = {}
    for i, v in pairs(message) do
        self.needShowPanel[v] = true
    end
    self:LUA_EVENT_ENTER_MAP()
end

---@param pool TablePool
function this:DeepCopy(t,pool)
    --local InTable = {};
    local function Func(t)
        if type(t) ~= "table" then
            return t;
        end
        local NewTable =pool and pool:Pop() or  {}
        --InTable[t] = NewTable
        for k,v in pairs(t) do
            NewTable[Func(k)] = Func(v)
        end
        return setmetatable(NewTable, getmetatable(t))
    end
    return Func(t)
end