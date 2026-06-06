---@class shortcutOutMgr
shortcutOutMgr = {}
local this = shortcutOutMgr

function this.DO(params)
    if not params then
        return
    end
    local instruct = params[1]
    if instruct == "CloseUI" then
        GUI:UIPanel_Close(params[2])
        if params[3] == "1" then
            SL.ShowMainPanel()
        end
    end
    if instruct == "moveToNPCOpenPanel" then -- 跟 transferNPC 效果差不多，这个是走路过去后打开面板
        SL.ShowMainPanel()
        local npcId = tonumber(params[2])
        local ShortcutMgr = SL:Get_G()['ShortcutMgr']
        ShortcutMgr.RunToNpc(npcId)
    elseif instruct == "transferMapAndLine" then
        local mapMoveId = tonumber(params[2])
        local line = tonumber(params[3])
        SL:MapTransfer(nil, line, mapMoveId, { type = 1 })
    else
        SL:ShortcutDO(params)
    end
end