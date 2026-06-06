---@class KLUITeamHeadItem:UIKmlLuaPanelBase
---@field view KLUITeamHeadItemView
local KLUITeamHeadItem = class(UIKmlLuaPanelBase)
local this =KLUITeamHeadItem
---创建时调用一次
function this:Init()
    
end

---创建或者刷新界面数据时调用
function this:Refresh()
end

---注册UI事件和服务器消息
function this:RegistEvents()
end

---显示数据
---@param info TeamProto.TeamMember
---@param leaderId number @队长id
function this:ShowInfo(info,leaderId)
    self.data = info
    self.leaderId = leaderId
    --self:SetHeadIcon(info.roleInfo.career)
    self:SetLevel(info.roleInfo.level)
    self:SetName(info.roleInfo.name)
    self:SetCaptainIcon(info.roleInfo.rid == leaderId)
    if info.hp then
        self:SetHpSlider(info.hp,info.maxHp)
    end
    self:SetFar(false)
    self:SetLine(info.roleInfo.roleInfoExt.breakLineState == 1)
end

---设置头像
---@param career CommonProtos.Career @职业数据
function this:SetHeadIcon(career)
    GUI:Image_loadTexture(self.view.sp_careerIcon,"1"..career.baseCareer,"Atlas/MUIcon.spriteatlas")
end

---设置等级
---@param level number @等级
function this:SetLevel(level)
    GUI:Text_setString(self.view.lab_level,"LV."..level)
    GUI:Text_setTextColor(self.view.lab_level,"#E6E600")
end

---设置名字
---@param name string @名字
function this:SetName(name)
    GUI:Text_setString(self.view.lab_name,name)
    GUI:Text_setTextColor(self.view.lab_name,"#4C98FF")
end

---设置队长图标
---@param isCaptain boolean @是否是队长
function this:SetCaptainIcon(isCaptain)
    GUI:SetActive(self.view.sp_captain,isCaptain)
    --[[GUI:setPosition(self.view.lab_name,-3,10)
    if isCaptain then
        GUI:setPosition(self.view.lab_name,23,10)
    end]]
end

---设置血量百分比
---@param hp number @当前血量
---@param maxHp number @当前最大血量
function this:SetHpSlider(hp,maxHp)
    GUI:SetLoadingbar_startper(self.view.sl_hp,hp/maxHp*100)
end

---设置远离显隐
---@param isFar boolean @是否远离
function this:SetFar(isFar)
    GUI:SetActive(self.view.img_far,isFar)
end

---设置离线显隐
---@param isLine boolean @是否离线
function this:SetLine(isLine)
    GUI:SetActive(self.view.img_offLineBg,isLine)
end

---设置选中
function this:SetSelectImage(isSelect)
    GUI:SetActive(self.view.img_selectionEffect,isSelect)
end

function this:Close()
end

return this
