--https://zhuanlan.zhihu.com/p/139549412 @参考地址

---不包括UIPanel和非UITemplate。（他们只能重载打开界面或者重新load template的时候生效。是直接用新mod覆盖老的，和hotfix_normal机制不一样。）
---Lua中可以新加变量
---有以下几种情况不能热重载
---（1）修改了原来table中已经有数据的变量（如果变量是nil，那不影响）
---（2）外部有对其函数有引用。（上面链接中有处理方式，但是不太合适。）
---(3) 修改的Lua文件的文件名如果是在_G里面没有找到则无法更新里面的函数。例如Defines里面定义的全局table

local specialTo = {
    Scene_EventContainer = 'GamePlay/Scene/Scene',
    Scene_MessageContainer = 'GamePlay/Scene/Scene',
    GUI_Attr = 'devCore/GUI/GUI',
    GUI_CreateUI = 'devCore/GUI/GUI',
    SL_Meta = 'devCore/SL',
    SL_MetaEnum = 'devCore/SL',
    SL_Sys = 'devCore/SL',
}

local specialModule = {
    ["Module/SlotManager"] = true,
    ["Module/ModuleMainBase"] = true,
    ["Module/ModuleConfig"] = true,
    ["Module/ModuleManager"] = true,
}

function hotfix(filename)
    local isModule = string.startsWith(filename, "Module/") and not specialModule[filename]
    local moduleName
    if isModule then
        moduleName = string.match(filename, "Module/[%w]+/([%w]+)")
    end

    if string.contains(filename, 'UI/Panel/') then
        hotfix_uipanel(filename, isModule, moduleName)
    elseif string.contains(filename, 'UI/Template/') then
        hotfix_uitemplate(filename, isModule, moduleName)
    else
        hotfix_normal(filename, isModule, moduleName)
    end

end

function hotfixConfig(filename)
    logError('hotfixConfig',filename)
    if GUI:GetUI('dev/ui/Common/Panel/KLUICommonTips/KLUICommonTipsPanel') then
        return
    end
    if Scene.isInScene then
        SL:CommonTipsMessage({showTips = "配置发生变化,需要返回登入生效",sureBtnText="返回登入",isShowCancelBtn=false,
                              callback=function()
                                  ConfigManager.ClearAllLuaConfig()
                                  ConfigManager.RebuildCfgPost()
                                  SL:onLUAEvent(LUA_EVENT_CLEAR_ALL_LUA_CONFIG)
                                  if LoginInfo.IsSDK() then
                                      if LoginInfo.IsOutSDK() then
                                          MuInterface.Instance:LogoutAccount()
                                          SL:QuitGame()
                                      else
                                          SL:QuitGame()
                                      end
                                  else
                                      SL:QuitGame()
                                  end
                              end})
    else
        SL:CommonTipsMessage({showTips = "配置发生变化", isShowCancelBtn=false,
                              callback=function()
                                  ConfigManager.ClearAllLuaConfig()
                                  ConfigManager.RebuildCfgPost()
                                  SL:onLUAEvent(LUA_EVENT_CLEAR_ALL_LUA_CONFIG)
                              end})
    end
end


--界面关闭的情况
function hotfix_uipanel(filename, moduleName)
    --界面关闭之后，删除了界面。重写打开后。rtengineRequire 重写加载了Lua界面逻辑
end

function hotfix_uitemplate(filename, isModule, moduleName)
    local oldModule
    local newModule
    if package.loaded[filename] then
        oldModule = package.loaded[filename]
        package.loaded[filename] = nil
    else
        if DebugFlag.LogEnable then
            log('不需要替换 = ' .. filename)
        end
        return
    end
    local evnRequire = isModule and requireM or require
    local ok, err = pcall(evnRequire, filename)
    --if(package.loaded[filename] )then
    --    --log("new package.loaded not null")
    --end
    if not ok then
        package.loaded[filename] = oldModule
        logError('reload lua file failed.' .. err)
        return
    end
    newModule = package.loaded[filename]
    local Env = isModule and GetModuleENV(moduleName)[moduleName .. "Main"] or _G
    local envTemplates = Env['luaComponentTemplates']
    for k, v in pairs(envTemplates) do
        if v == oldModule then
            table.copyFrom(envTemplates[k],newModule)
            package.loaded[filename] = envTemplates[k]
            break
        end
    end

    if DebugFlag.LogEnable then
        log('替换 完成 = ' .. filename)
    end
end

function hotfix_normal(filename, isModule, moduleName)
    logNoFlag("start hotfix:" .. filename)
    --若此lua文件无返回值 则需要从_G中取数据
    --bGTable为true表示需要从_G中取数据  false表示从package.loaded中取数据
    local bGTable = false
    local namearr = string.split(filename, "/")
    local namestr = namearr[#namearr]
    local orginFilename = nil
    local orginModName = nil
    if specialTo[namestr] then
        orginFilename = specialTo[namestr]
        local strs = string.split(orginFilename, "/")
        orginModName = strs[#strs]
    end
    local modGName = orginModName or namestr
    local envTbl = isModule and GetModuleENV(moduleName) or _G
    local oldModuleG
    local oldModule
    local oldOrginModule
    if package.loaded[filename] then
        oldModule = package.loaded[filename]
        package.loaded[filename] = nil
        if orginFilename then
            oldOrginModule = package.loaded[orginFilename]
            package.loaded[orginFilename] = nil
        end
        if (type(oldModule) == "boolean") then
            oldModuleG = envTbl[modGName]
            if not oldModuleG then
                package.loaded[filename] = oldModule
                if orginFilename then
                    package.loaded[filename] = oldOrginModule
                end
                logError('reload lua file failed.' .. filename .. ' lua名字和_G中变量名不对应')
                return
            end
            envTbl[modGName] = nil
            bGTable = true
            --log("oldModule type is "..type(oldModule))
        end
        --log('this file exist in package.loaded')
    else
        logNoFlag('不需要替换 = ' .. filename)
        --logError('this file is not loaded: '..filename)
        return
    end
    local evnRequire = isModule and requireM or require
    if orginFilename then
        local oOk, oErr = pcall(evnRequire, orginFilename)
        if not oOk then
            logError('reload lua file failed.' .. oErr)
            return
        end
    end
    local ok, err = pcall(evnRequire, filename)
    --if(package.loaded[filename] )then
    --    --log("new package.loaded not null")
    --end

    if not ok then
        package.loaded[filename] = oldModule
        if orginFilename then
            package.loaded[filename] = oldOrginModule
        end

        envTbl[modGName] = oldModuleG
        logError('reload lua file failed.' .. err)
        return
    end
    --如果想要保留旧文件的数据 需要启用下面的逻辑

    local newModule = bGTable and envTbl[modGName] or package.loaded[filename]

    local updated_tables = {}
    if (type(newModule) == "table") then
        --print("newModule is table")
        if (bGTable == true) then
            update_table(newModule, oldModuleG, updated_tables)
        else
            update_table(newModule, oldModule, updated_tables)
        end
    else
        --print("newModule not table。 type is "..type(newModule))
        --print("oldModule type is "..type(oldModule))
    end

    if (bGTable == true) then
        if oldModuleG.OnReload ~= nil then
            oldModuleG:OnReload()
        end
    else
        if oldModule.OnReload ~= nil then
            oldModule:OnReload()
        end
    end
    package.loaded[filename] = oldModule
    if orginFilename then
        package.loaded[orginFilename] = oldOrginModule
    end

    envTbl[modGName] = oldModuleG
    if DebugFlag.LogEnable then
        log('替换 完成 = ' .. filename)
    end
end

function update_func(new_func, old_func)
    assert("function" == type(new_func))
    assert("function" == type(old_func))

    -- Get upvalues of old function.
    local old_upvalue_map = {}
    if ("function" == type(old_func)) then
        for i = 1, math.huge do
            local name, value = debug.getupvalue(old_func, i)
            if not name then break end
            old_upvalue_map[name] = value
        end
    end

    -- Update new upvalues with old.
    for i = 1, math.huge do
        local name, value = debug.getupvalue(new_func, i)
        if not name then break end
        --print('set up value: name:',name)
        local old_value = old_upvalue_map[name]
        if old_value then
            debug.setupvalue(new_func, i, old_value)
        end
    end
end

function update_table(new_table, old_table, updated_tables)
    assert("table" == type(new_table))
    assert("table" == type(old_table))

    -- Compare 2 tables, and update old table.
    for key, value in pairs(new_table) do
        local old_value = old_table[key]
        local type_value = type(value)
        if type_value == "function" then
            update_func(value, old_value)
            update_func_eventOrMessageManager(value, old_value)
            old_table[key] = value
        elseif type_value == "table" then
            if (updated_tables[value] == nil) then
                updated_tables[value] = true
                update_table(value, old_value, updated_tables)
            end
        elseif old_value == nil then
            --如果旧表里面没有这个字段，就新加进去
            old_table[key] = value
        else
            if type(old_value) ~= type_value then
                if DebugFlag.LogEnable then
                    log('字段修改无法热重载,自行确定是否有问题 = ' .. key .. ' oldType = ' .. hotfixGetPrintString(type(old_value)) .. ' newType = ' .. hotfixGetPrintString(type_value))
                end
            else
                if old_value ~= value then
                    if DebugFlag.LogEnable then
                        log('字段修改无法热重载,自行确定是否有问题 = ' .. key .. ' oldValue = ' .. hotfixGetPrintString(old_value) .. ' newValue = ' .. hotfixGetPrintString(value))
                    end
                end
            end
        end
    end

    -- Update metatable.
    local old_meta = debug.getmetatable(old_table)
    local new_meta = debug.getmetatable(new_table)
    ---有些元表设置了自己，会导致死循环（类似Vector4）,Vector4的判等被重载了
    if type(old_meta) == "table" and type(new_meta) == "table" then
        if old_meta.IsSelfMetatable and old_meta:IsSelfMetatable() then
            return
        end
        if old_meta ~= old_table and new_meta ~= new_table then
            update_table(new_meta, old_meta, updated_tables)
        end
    end
end

---@param eventManagerBase EventManagerBase
function update_func_eventOrMessageManager(newFunc, oldFunc)
    EventManager.HotFix_UpdateFunc(newFunc, oldFunc)
    NetManager.HotFix_UpdateFunc(newFunc, oldFunc)
end

function hotfixGetPrintString(v)
    if v == nil then
        return 'nil'
    end
    return tostring(v)
end

function hotfixKmlLua(keyPath)
    logNoFlag('hotfixKmlLua='..keyPath)
    local viewPath = keyPath.."View"
    local panelPath = string.empty
    
    if string.contains(keyPath, "Assets/Lua/") then
        panelPath = string.replace(keyPath, "Assets/Lua/", "")
        viewPath = string.replace(viewPath, "Assets/Lua/", "")
    else
        logNoFlag('CS.TCFramework.StreamingAssetsFile712.XTRADevResBundlesDir='..CS.TCFramework.StreamingAssetsFile712.XTRADevResBundlesDir)
        panelPath = string.replace(keyPath, CS.TCFramework.StreamingAssetsFile712.XTRADevResBundlesDir..'Lua/', "")
        viewPath = string.replace(viewPath, CS.TCFramework.StreamingAssetsFile712.XTRADevResBundlesDir..'Lua/', "")
    end
    panelPath = string.replace(keyPath, "Lua/", "")
    viewPath = string.replace(viewPath, "Lua/", "")
    logNoFlag(viewPath)
    logNoFlag(panelPath)
    local lastIndex = string.lastIndexOf(panelPath,'/')
    local className = string.sub(panelPath,lastIndex+1)
    logNoFlag(className)
    local panel = GUI:GetUI(panelPath,true)
    
    local args = nil
    local realPanelPath = ""
    if panel then
        if panel.baseUI then
            args = panel.baseUI.args
            realPanelPath = panel.baseUI.filePath
        else
            args = panel.args
            realPanelPath = panel.filePath
        end 
    end
    --界面正开着
    if not string.isNullOrEmpty(realPanelPath) then
        logNoFlag('realPanelPath='..realPanelPath)
        UnPreLoadUI_Item(panelPath)
        if GUI:InPreLoadUI(realPanelPath) then
            GUI:UnPreLoadUI(realPanelPath)
        else
            GUI:UIPanel_Close(realPanelPath)
        end
        _G[className] = nil
        _G[className.."View"] = nil
        local outLuaEnv = GetOutLuaEnv()
        if outLuaEnv then
            outLuaEnv[realPanelPath] = nil
            outLuaEnv[realPanelPath.."View"] = nil 
        end
        package.loaded[viewPath] = nil
        package.loaded[panelPath] = nil
        GUI:UIPanel_Open(realPanelPath,nil,nil,args)
        logNoFlag('热重载完成='..realPanelPath)
        return true
    else
        UnPreLoadUI_Item(panelPath)
        if GUI:InPreLoadUI(panelPath) then
            GUI:UnPreLoadUI(panelPath)
        end
        _G[className] = nil
        _G[className.."View"] = nil
        local outLuaEnv = GetOutLuaEnv()
        if outLuaEnv then
            outLuaEnv[keyPath] = nil
            outLuaEnv[keyPath.."View"] = nil
        end
        package.loaded[viewPath] = nil
        package.loaded[panelPath] = nil
        logNoFlag('热重载完成='..realPanelPath)
        return true
    end
    return false
end

function UnPreLoadUI_Item(path)
    local copys = table.copy(GUI.preloadUIs)
    local isReturn = false
    ---@param v UIKmlLuaPanelBase
    for k, v in pairs(copys) do
        local copyVs = table.copy(v)
        ---@param v2 UIKmlLuaPanelBase
        for k2, v2 in pairs(copyVs) do
            if GUI:InPreLoadUI(v2.filePath) then
                local copySubWins = table.copy(v2.subWins)
                for k3, v3 in pairs(copySubWins) do
                    local copysV3 = table.copy(v3)
                    ---@param v4 UIKmlLuaPanelBase
                    for k4, v4 in pairs(copysV3) do
                        if v4.filePath == path then
                            GUI:UnPreLoadUI(v2.filePath)
                        end 
                    end
                end
            end
        end
    end
end

function reopenKmlLua()
    
end