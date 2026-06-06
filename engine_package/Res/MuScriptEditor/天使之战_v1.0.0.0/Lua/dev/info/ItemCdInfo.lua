---@class ItemCdInfo
ItemCdInfo = class()
local this = ItemCdInfo

function this:ctor()

end

function this:Reset()

end

function this:Init()
    self:RegistMessages()
    local ItemCdMgr = SL:Get_G()['ItemCdMgr']
    ItemCdMgr.SetUseItemCd = function(useItem)
        if useItem then
            if ItemCdMgr.cdGroupItem[useItem.id].remainCd <= Time.GetServerTime()  then
                local groupTime = ItemCdMgr.cdGroupItem[useItem.id].useCdGroup[1] and ItemCdMgr.cdGroupItem[useItem.id].useCdGroup[1][2] / 1000 or 0
                local maxTime = math.max(groupTime,ItemCdMgr.cdGroupItem[useItem.id].coolingTime)
                ItemCdMgr.SetData(useItem.id,maxTime)
            end
        end
    end
end

function this:RegistMessages()
    
end