---@class  KLCrossServerIntroducePanel:UIKmlLuaPanelBase
---@field view  KLCrossServerIntroducePanelView
local  KLCrossServerIntroducePanel = class(UIKmlLuaPanelBase)
local this =  KLCrossServerIntroducePanel
---创建时调用一次
function this:Init()
    SL.HideMainPanel()
    GUI:DataListInitData(self.view.activity_panel_dl,function()
        return self:BtnDataListItemCountFunc()
    end,function(realIndex)
        return self:BtnDataListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:BtnDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:BtnDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    self.all_item = {}
    self.allActivity = {
    }
    local activity_1 = SL:GetConfig("cfg_global",11004)
    local one = SL:Split(activity_1.value, "|")
    --SL:LogTable(activity_1,true)
    table.insert(self.allActivity,{id=11004,name="跨服系统",data=one})
    local activity_2 = SL:GetConfig("cfg_global",11005)
    local two = SL:Split(activity_2.value, "|")
    --SL:LogTable(activity_2,true)
    table.insert(self.allActivity,{id=11005,name="诸神降临",data=two})
end

---创建或者刷新界面数据时调用
function this:Refresh()
    self.select_id = self.allActivity[1].id
    GUI:DataListUpdateData(self.view.activity_panel_dl)
    self:SelectActicity()
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn_close,self,self.CloseOnclick)
    --SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_PRIVILEGE_BOSS_PANEL,self.RES_PRIVILEGE_BOSS_PANEL,self)
end

function this:CloseOnclick()
    GUI:UIPanel_Close("dev/outui/CrossServer/Panel/KLCrossServerIntroduce/KLCrossServerIntroducePanel")
end



function this:BtnDataListItemCountFunc()
    return #self.allActivity
end

function this:BtnDataListItemGetFunc(realIndex)
    local index = realIndex + 1
    local data = self.allActivity[index]
    local item = GUI:UIPanel_Open("dev/outui/CrossServer/Item/KLUCrossServerMainBtnItem/KLUCrossServerMainBtnItem",self.view.activity_panel_dl,self,nil,true)
    self.all_item[index] = item
    self.all_item[index]:RefreshItem(data,self.select_id,self)
    if data.id == self.select_id then
        self.LevelBtn = self.all_item[index]
    end
    return item.view.root
end

function this:BtnDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:BtnDataListItemUpdateFunc(realIndex, kmlcontrol)
    local index = realIndex + 1
    local data = self.allActivity[index]
    self.all_item[index]:RefreshItem(data,self.select_id,self)
    if data.id == self.select_id then
        self.LevelBtn = self.all_item[index]
    end
end

function this:HideSelect()
    if self.LevelBtn then
        self.LevelBtn:HideItem()
    end
end

function this:Select(id,Btn)
    self.LevelBtn = Btn
    self.select_id = id
    self:SelectActicity()
end

function this:SelectActicity()
    local one 
    for i=1,#self.allActivity,1 do
        if self.allActivity[i].id == self.select_id then
            one = self.allActivity[i]
        end
    end
    if one then
        if one.data[1] then
            local title_and_con = string.split(one.data[1],'&')
            GUI:setVisible(self.view.text1_title,true)
            GUI:setVisible(self.view.text1,true)
            GUI:setVisible(self.view.text1_space,true)
            GUI:Text_setString(self.view.text1_title,title_and_con[1])
            GUI:Text_setString(self.view.text1,title_and_con[2])
        else
            GUI:setVisible(self.view.text1_title,false)
            GUI:setVisible(self.view.text1,false)
            GUI:setVisible(self.view.text1_space,false)
        end
        if one.data[2] then
            local title_and_con = string.split(one.data[2],'&')
            GUI:setVisible(self.view.text2_title,true)
            GUI:setVisible(self.view.text2,true)
            GUI:setVisible(self.view.text2_space,true)
            GUI:Text_setString(self.view.text2_title,title_and_con[1])
            GUI:Text_setString(self.view.text2,title_and_con[2])
        else
            GUI:setVisible(self.view.text2_title,false)
            GUI:setVisible(self.view.text2,false)
            GUI:setVisible(self.view.text2_space,false)
        end
        if one.data[3] then
            local title_and_con = string.split(one.data[3],'&')
            GUI:setVisible(self.view.text3_title,true)
            GUI:setVisible(self.view.text3,true)
            GUI:setVisible(self.view.text3_space,true)
            GUI:Text_setString(self.view.text3_title,title_and_con[1])
            GUI:Text_setString(self.view.text3,title_and_con[2])
        else
            GUI:setVisible(self.view.text3_title,false)
            GUI:setVisible(self.view.text3,false)
            GUI:setVisible(self.view.text3_space,false)
        end
    end
end


function this:Close()
    
end


return this
