GameEvent = {}

local _listeners = {}

function GameEvent.add(eventName, func, tag, priority)
    if not eventName then
        return
    end
    

    _listeners[eventName] = _listeners[eventName] or {}
    local eventListeners = _listeners[eventName]

    
    for _, v in ipairs(eventListeners) do
        if v[2] == tag then
            return
        end
    end

    if priority and #eventListeners >= priority then
        table.insert(eventListeners, priority, {func, tag})
    else
        table.insert(eventListeners, {func, tag})
    end
end

function GameEvent.remove(func)
	for eventName, eventListeners in pairs(_listeners) do
		for i = 1, #eventListeners do
			if eventListeners[i][1] == func then
				table.remove(eventListeners, i)
				if 0 == #_listeners[eventName] then
					_listeners[eventName] = nil
				end
				return
			end
		end
	end
end

function GameEvent.removeByNameAndTag(eventName, tag)
	assert(tag, "Tag must not be nil")
	local eventListeners = _listeners[eventName]
	if not eventListeners then return end

	for i = #eventListeners, 1, -1 do
		if eventListeners[i][2] == tag then
			table.remove(eventListeners, i)
			break
		end
	end

	if 0 == #eventListeners then
		_listeners[eventName] = nil
	end
end
function GameEvent.removeByTag(tag)
	assert(tag, "Tag must not be nil")
	for eventName, eventListeners in pairs(_listeners) do
		self.removeListenerByNameAndTag(eventName, tag)
	end
end

function GameEvent.removeAll()
	_listeners = {}
end



function GameEvent.push(eventName,...)
    local eventListeners = _listeners[eventName]
    if not eventListeners then
        return
    end
    for _, listener in ipairs(eventListeners) do
        local ok, stop = xpcall(listener[1], debug.traceback, ...)
        if ok then
            if stop then
                -- release_print(eventName,"???")
                break
            end
        else
            local tag = listener[2]
            local tarid = type(tag) == "string" and tag or (tag and tag.ID or 0)
            local err = string.format("名称%s  id=%s  %s" , eventName, tarid, debug.traceback())
            error(err,stop)
        end
    end
end




return GameEvent