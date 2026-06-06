local util = require 'xlua.util'
local coroutineRunner = CS.Main.instance

---@class Coroutine
Coroutine = {}

---@return UnityEngine.Coroutine
function Coroutine.Start(...)
    if DebugFlag.Coroutine then
        if DebugFlag.LogEnable then
            log('Coroutine.Start')
        end
    end
    return coroutineRunner:StartCoroutine(util.cs_generator(DebugFlag.CoroutineDebugStack,...))
end

---@return userdata @如果需要大量调用协程的地方，使用这个接口，可以跳过取堆栈的逻辑，避免研发中卡顿严重（能不能协程就不用）
function Coroutine.StartNoDebugStack(...)
    if DebugFlag.Coroutine then
        if DebugFlag.LogEnable then
            log('Coroutine.Start')
        end
    end
    return coroutineRunner:StartCoroutine(util.cs_generator(false,...))
end


function Coroutine.Stop(c)
    if DebugFlag.Coroutine then
        if DebugFlag.LogEnable then
            log('Coroutine.Stop')
        end
    end
    if c == nil then
        return
    end
    coroutineRunner:StopCoroutine(c)
end

function Coroutine.StopAll()
    if DebugFlag.Coroutine then
        if DebugFlag.LogEnable then
            log('Coroutine.StopAll')
        end
    end
    coroutineRunner:StopAllCoroutines()
end

function Coroutine.Yield(enumerator)
    if DebugFlag.Coroutine then
        if DebugFlag.LogEnable then
            log('Coroutine.Yield')
        end
    end
    coroutine.yield(enumerator)
end

function Coroutine.Wait(time)
    if DebugFlag.Coroutine then
        if DebugFlag.LogEnable then
            log('Coroutine.Wait')
        end
    end
    coroutine.yield(CS.UnityEngine.WaitForSeconds(time))
end
local waitForEndOfFrame = CS.UnityEngine.WaitForEndOfFrame()
--local waitForEndOfFrame = CS.UnityEngine.WaitForSeconds(Time.deltaTime)
function Coroutine.WaitForEndOfFrame()
    if DebugFlag.Coroutine then
        if DebugFlag.LogEnable then
            log('Coroutine.WaitForEndOfFrame')
        end
    end
    coroutine.yield(nil)
    --coroutine.yield(waitForEndOfFrame)
end

function Coroutine.Break()
    if DebugFlag.Coroutine then
        if DebugFlag.LogEnable then
            log('Coroutine.Break')
        end
    end
    coroutine.yield(util.move_end)
end