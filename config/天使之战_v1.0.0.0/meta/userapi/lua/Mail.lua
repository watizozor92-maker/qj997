Mail = {}
local this = {}



function Mail.levelUp(actor,level)
    if level >= 40 then
        local roleWorld = getplaydef(actor,"T$_levelUp_40")
        if roleWorld then
            return
        end
        sendconfigmailbyrid(actor,actor:toString(),999999,{ [10020001] = 50000,[30030306] = 1,[40010701] = 1,[50010003] = 3,[50010005] = 3,[10040001] = 100})
        setplaydef(actor,"T$_levelUp_40",1)
    end

    if level >= 5 then
        local roleWorld = getplaydef(actor,"T$_levelUp_5")
        if roleWorld then
            return
        end
        local career = tonumber(getbaseinfo(actor, "getbasecareer"))
        if career == 1 then
            sendconfigmailbyrid(actor,actor:toString(),888888,{ [88888801] = 2,[88888802] = 1,[88888803] = 1,[88888804] = 1,[88888805] = 1,
                                                                [88888806] = 1,[60030062] = 1,[60030060] = 1,[60030063] = 1
            })
        elseif career == 2 then
            sendconfigmailbyrid(actor,actor:toString(),888888,{ [66666601] = 1,[66666602] = 1,[66666603] = 1,[66666604] = 1,[66666605] = 1,
                                                                [66666606] = 1,[66666607] = 1,[60030004] = 1,[60030011] = 1,[60030002] = 1
            })
        elseif career == 3 then
            sendconfigmailbyrid(actor,actor:toString(),888888,{ [77777701] = 1,[77777702] = 1,[77777703] = 1,[77777704] = 1,[77777705] = 1,
                                                                [77777706] = 1,[77777707] = 1,[60030030] = 1,[60030032] = 1,[60030033] = 1
            })
        end
        setplaydef(actor,"T$_levelUp_5",1)
    end
end



function Mail.taskComplete(actor,taskId)
    --local career = tonumber(getbaseinfo(actor, "getbasecareer"))
    --if career == 1 then
    --    if taskId ~= 10029 then
    --        return
    --    end
    --
    --elseif career == 2 then
    --    if taskId ~= 20029 then
    --        return
    --    end
    --elseif career == 3 then
    --    if taskId ~= 30029 then
    --        return
    --    end
    --elseif career > 3 then
    --    return
    --end
    --sendconfigmailbyrid(actor,actor:toString(),999999,{ [10020001] = 50000,[30030306] = 1,[40010701] = 1,[50010003] = 3,[50010005] = 3,[10040001] = 100})

end
