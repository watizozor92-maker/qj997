--客户端需要跨系统的全局数据 代码可更改 只是在这里统一定义和调取
Global = {}
function Global.Reset()
    Global.LianJiOpenState = false
    Global.LianJiAutoState = false;--连击系统自动状态
    Global.LianJiData = {}; --连击执行顺序
    Global.TeQuanState = false;
    Global.CurSD = 0; --当前sd
    Global.MaxSD = 0; --最大sd
    Global.CurAG = 0; --当前AG
    Global.MaxAG = 0; --最大AG
    Global.DashiOpenState = false;--大师是否开启
end

-- ---根据道具id打开获取途径面板
-- ---@param _equip_pos string @打开的位置
-- ---@param _cfgId number @表id
-- ---@param _id number @唯一id
-- ---@param _count number @数量
-- ---@param _ui UIKmlLuaPanelBase @从什么面板打开的
-- ---@param _callBack function @回调
-- function SL:CommonItemGetPath(_equip_pos, _cfgId, _id, _count, _ui, _callBack, _item, _info)
--     if _cfgId then
--         local tipsKml = SL:OpenTips(_equip_pos, _cfgId, _id, _count, _item, _info)

--         ---@type cfg_item_column
--         local itemCfg = SL:GetConfig("cfg_item", _cfgId)
--         if itemCfg.Quickshopping and table.count(itemCfg.Quickshopping) > 0 then
--             local posX, posY = GUI:getPosition(tipsKml.view.root)
--             local w, h = GUI:getSizeDelta(tipsKml.view.panel_bg)
--             GUI:UIPanel_Open("dev/ui/Common/Panel/KLItemGetPath/KLItemGetPathPanel", nil, nil,
--                     { itemId = _cfgId, pos = { posX + 358, posY }, width = w, height = h, ui = _ui, callBack = _callBack, info = _info })
--         end
--     end
-- end

--[[--打开tips
function SL:OpenTips(_equip_pos,_cfgId,_id,_count,item,info,isMulti,callBack,nextLV)
    if _cfgId then
        return GUI:UIPanel_Open("dev/outui/Tips/Panel/KLTipLayout/KLTipLayoutPanel",nil,nil, 
        {
                cfgId=_cfgId,id=_id,equip_pos=_equip_pos,info=info,count = _count, nextLV = nextLV, item = item;
            },isMulti,callBack
        )
    end
end]]





