UseSelfChoiceBox = {}

function UseSelfChoiceBox.use(actor, data)
    local result =  useselfchoicebox(actor, data)
    if not result then
        tipinfo(actor, "使用自选宝箱失败")
        sendluamsg(actor, LuaMessageIdToClient.RES_USE_SELF_CHOICE_BOX, {ok= 0})
    else
        sendluamsg(actor, LuaMessageIdToClient.RES_USE_SELF_CHOICE_BOX, {ok= 1})
    end
end