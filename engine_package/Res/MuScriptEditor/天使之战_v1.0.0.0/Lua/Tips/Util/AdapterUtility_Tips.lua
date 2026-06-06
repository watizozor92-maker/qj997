--适配工具
AdapterUtility = {}
local this = AdapterUtility

local lastSafeArea = CS.UnityEngine.Rect(0, 0, 0, 0)
local lastLandscapeState = ""

---编辑器下测试刘海屏
local isEditorTest = false
this.curScreenWidth = 0
this.curScreeHeight = 0

--特殊机型可能需要特殊处理
local cfg_mobile_special = {
    { brand = "COOLPAD", model = "SEA-A0", notchHeight = 50 },
    { brand = "MI", model = "M2007J1SC", notchHeight = 50 },
}

local function CheckSpecial(brand, model)
    local upBrand = string.upper(brand)
    for k, v in pairs(cfg_mobile_special) do
        if string.contains(upBrand, v.brand) and v.model == model then
            return true, v.notchHeight
        end
    end

    return false, 0
end

function this.Refresh()
    if not UIManager.adapter_WindowCanvasUI then return end
    local orientation = Screen.orientation:ToString()
    if lastLandscapeState == orientation then return end

    local safeArea = MobileInfo.Instance.SafeArea
    local srcScreenWidth = LoginManager.srcScreenWidth
    local srcScreenHeight = LoginManager.srcScreenHeight
    if LoginInfo.IsSDK() then
        local brand = MuInterface.Instance:getDeviceBrand()
        local model = MuInterface.Instance:getSystemModel()
        local ret, notchHeight = CheckSpecial(brand, model)
        if ret then
            if orientation == "Portrait" then
                safeArea = CS.UnityEngine.Rect(0, notchHeight, srcScreenWidth, srcScreenHeight - 2 * notchHeight)
            else
                safeArea = CS.UnityEngine.Rect(notchHeight, 0, srcScreenWidth - 2 * notchHeight, srcScreenHeight)
            end
        end
    end

    if isEditorTest then
        if orientation == "Portrait" then
            safeArea = CS.UnityEngine.Rect(0, 0, srcScreenWidth, srcScreenHeight - 100)
        else
            safeArea = CS.UnityEngine.Rect(100, 0, srcScreenWidth - 200, srcScreenHeight)
        end
    end

    lastLandscapeState = orientation
    
    if safeArea ~= lastSafeArea then
        lastSafeArea = safeArea

        local anchorMin = safeArea.position
        local anchorMax = safeArea.position + safeArea.size
        if orientation == "Portrait" then
            anchorMin.x = 0
            anchorMin.y = anchorMin.y / srcScreenHeight
            anchorMax.x = 1
            anchorMax.y = anchorMax.y / srcScreenHeight
        else
            anchorMin.x = anchorMin.x / srcScreenWidth
            anchorMin.y = 0
            anchorMax.x = anchorMax.x / srcScreenWidth
            anchorMax.y = 1

        end
        logNoFlag("anchorMin=("..anchorMin.x ..","..anchorMin.y..")" ,"anchorMax=("..anchorMax.x ..","..anchorMax.y..")")
        UIManager.adapter_WindowCanvasUI.anchorMin = anchorMin
        UIManager.adapter_WindowCanvasUI.anchorMax = anchorMax
    end
end

---@return void @走cfg_phoneModel适配了，后续看情况是否需求启动,如果cfg_phoneModel配置里面没找到，调用这个
function this.SetResolution()
    if Main.isWindows and (LoginInfo.IsBox() or LoginInfo.IsBoxSDK()) then
        AdapterUtility.SetCurScreenWidthAndHeight(Screen.width,Screen.height)
        return
    end
    local srcScreenWidth = LoginManager.srcScreenWidth
    local srcScreenHeight = LoginManager.srcScreenHeight
    local screenRatio = srcScreenWidth / srcScreenHeight;
    local defaultWidth = Main.wInitScreenSize
    local defaultHeight = Main.hInitScreenSize
    local defaultRoata = defaultWidth / defaultHeight
    local useOrigin = true
    if useOrigin then 
        --if CS.MobileInfo.Instance.IsEmulator then
        --以高度适配
        if screenRatio >= defaultRoata then
            local newHeight = LoginManager.srcScreenHeight
            local newWidth = Mathf.Ceil(newHeight*screenRatio)
            logNoFlag('以高度适配:newWidth='..newWidth..' newHeight='..newHeight.." 原始分辨率="..srcScreenWidth..'*'..srcScreenHeight)
            LoginManager.setScreenWidth = newWidth
            LoginManager.setScreenHeight = newHeight
            if not Main.isWebGLBrowser then
                Screen.SetResolution(newWidth,newHeight,Main.IsCanFullScreen())
            end
        else
            local newWidth =LoginManager.srcScreenWidth
            local newHeight = Mathf.Ceil(newWidth/screenRatio)
            LoginManager.setScreenWidth = newWidth
            LoginManager.setScreenHeight = newHeight
            logNoFlag('以宽度适配:newWidth='..newWidth..' newHeight='..newHeight.." 原始分辨率="..srcScreenWidth..'*'..srcScreenHeight)
            if not Main.isWebGLBrowser then
                Screen.SetResolution(newWidth,newHeight,Main.IsCanFullScreen())
            end
        end
    else
        --以高度适配
        if screenRatio >= defaultRoata then
            local newHeight = Mathf.Min(Screen.height,defaultHeight)
            local newWidth = Mathf.Ceil(newHeight*screenRatio)
            logNoFlag('以高度适配:newWidth='..newWidth..' newHeight='..newHeight.." 原始分辨率="..srcScreenWidth..'*'..srcScreenHeight)
            LoginManager.setScreenWidth = newWidth
            LoginManager.setScreenHeight = newHeight
            if not Main.isWebGLBrowser then
                Screen.SetResolution(newWidth,newHeight,Main.IsCanFullScreen())
            end
        else
            local newWidth =Mathf.Min(Screen.width,defaultWidth)
            local newHeight = Mathf.Ceil(newWidth/screenRatio)
            LoginManager.setScreenWidth = newWidth
            LoginManager.setScreenHeight = newHeight
            logNoFlag('以宽度适配:newWidth='..newWidth..' newHeight='..newHeight.." 原始分辨率="..srcScreenWidth..'*'..srcScreenHeight)
            if not Main.isWebGLBrowser then
                Screen.SetResolution(newWidth,newHeight,Main.IsCanFullScreen())
            end
        end 
    end
    AdapterUtility.SetCurScreenWidthAndHeight(Screen.width,Screen.height)
end
--根据机型在初始化的时候设置，策划觉得走低中高设置比较好
function this.SetResolutionWebGL()
    local cpuName = nil
    local mobileCfg = nil
    local isPhone = false
    --初始化MobileInfo 调用Init
    local safeArea = MobileInfo.Instance.SafeArea
    if CS.TCFramework.Platform.isIOS then
        isPhone = true
        cpuName = "iPhone"
        CS.UnityEngine.Debug.Log("IOS cpuName=iPhone");
    elseif CS.TCFramework.Platform.isAndroid then
        isPhone = true
        cpuName = CS.MobileInfo.Instance.CpuName or ""
        CS.UnityEngine.Debug.Log("Android cpuName="..cpuName);
    elseif GUI:IsWebGLAsync() then
        isPhone = true
    end
    local qualityType = EGameQualityType.PowerSave
    --if isPhone and CS.UnityEngine.Application.isMobilePlatform then
    if isPhone  then
        if qualityType == EGameQualityType.PowerSave then
            --mobileCfg = CS.UnityEngine.Application.platform == CS.UnityEngine.RuntimePlatform.IPhonePlayer and  cfg_appleModelGetItem(cpuName) or cfg_phoneModelGetItem(cpuName)
            if string.isNullOrEmpty(cpuName) then
                --如果拿不到CPU信息，java-readCpuInfo里面拿到信息里面不包含hardware，设置成省电模式
                AdapterUtility.SetResolution()
                DataManager.settingData:SetDefaultQualityType(EGameQualityType.Balance)
                CS.UnityEngine.Debug.Log("InitResolution cpuName is empty");
            elseif mobileCfg == nil then
                --如果拿到了CPU信息，但是不在配表内，打印一个报错，让其传到后台日志，手动添加
                logError("InitResolution mobileCfg is nil 手动添加一下=" .. cpuName);
                --UISettingMgr.SetResolution(1)
                AdapterUtility.SetResolution()
                DataManager.settingData:SetDefaultQualityType(EGameQualityType.PowerSave)
            else
                CS.UnityEngine.Debug.Log("InitResolution mobileCfg.resolution=" .. mobileCfg.resolution);
                UISettingMgr.SetResolution(mobileCfg.resolution)
                DataManager.settingData:SetDefaultQualityType(mobileCfg.quality + 1)
            end
        elseif qualityType == EGameQualityType.Balance then
            AdapterUtility.SetResolution()
        else
            if not Main.isWebGLBrowser then
                CS.UnityEngine.Screen.SetResolution(Main.wInitScreenSize, Main.hInitScreenSize, Main.IsCanFullScreen());
            end
        end
    end
end

--根据低中高设置分辨率
local lastGameQualityType = nil
local qualityResolution =
{
    [EGameQualityType.Strongest] = 1,
    [EGameQualityType.Balance] = 1,
    [EGameQualityType.PowerSave] = 1,
}
function this.SetResolutionV2(gameQualityType)
    if not gameQualityType then
        return
    end
    if lastGameQualityType == gameQualityType then
        return
    end
    lastGameQualityType = gameQualityType
    local scale = qualityResolution[gameQualityType] or 1
    if Main.isXtra or Main.isWindows then
        scale = 1
    end
    UISettingMgr.SetResolution(scale)
end 

function this.SetCurScreenWidthAndHeight(w,h)
    this.curScreenWidth = w
    this.curScreeHeight = h
end 