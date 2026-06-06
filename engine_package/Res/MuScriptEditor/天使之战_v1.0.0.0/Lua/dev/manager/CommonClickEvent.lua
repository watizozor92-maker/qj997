-- ---@class CommonClickEvent
-- CommonClickEvent = {}
-- local this = CommonClickEvent

-- function this.Init()
    
-- end

-- 按钮点击处理工具类（增强版，支持释放监听）
CommonClickEvent = {}
local this = CommonClickEvent

-- 存储按钮的最后点击时间
local lastClickTimes = {}

-- 默认点击间隔(毫秒)
this.defaultInterval = 400

function this.AddOnClickEvent(handle, ui, callback, eventData, interval)
    local clickInterval = interval or this.defaultInterval
    
    -- 点击处理函数
    local function onButtonClick(...)
        local now = os.clock() * 1000
        local lastTime = lastClickTimes[handle] or 0
        
        if now - lastTime >= clickInterval then
            lastClickTimes[handle] = now
            callback(...)
        end
    end
    
    GUI:AddOnClickEvent(handle, ui, onButtonClick, eventData)
end

function this.clearClickRecord(handle)
    lastClickTimes[handle] = nil
end

function this.clearAllRecords()
    lastClickTimes = {}
end



