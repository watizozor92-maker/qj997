---@class SelfSelectBoxInfo @注释
SelfSelectBoxInfo = class()
local this = SelfSelectBoxInfo

function this:ctor()

end

function this:Init()
    self:Reset()
    self:InitData()
    self:RegistMessages()
end

function this:InitData()
end

function this:RegistMessages()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_USE_SELF_CHOICE_BOX,self.RES_USE_SELF_CHOICE_BOX,self)

end

---打开自选宝箱响应
function this:RES_USE_SELF_CHOICE_BOX(id,message)
    if message and self.useItems and next(self.useItems) then
        local list = {}
        for i, v in pairs(self.useItems) do
            local isAdd = false
            for z, a in ipairs(list) do
                if v.itemId == a.cfgId then
                    a.count = a.count + v.count
                    isAdd = true
                    break
                end
            end
            if not isAdd then
                table.insert(list,{cfgId = v.itemId,count = v.count})
            end
        end
        SL:OpenRewardTipsByItemList(list,0)
        self.useItems = {}
    end
end


function this:Reset()
    self.useItems = {}
end 