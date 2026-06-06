require "dev/CfgPost/cfg_pk_count_post"
require "dev/CfgPost/cfg_newarea_offerreward_post"
require "dev/CfgPost/cfg_equip_angelTalentLv_post"
--案例
--cfg_att_score_post = class()
--local this = cfg_att_score_post
--this.isInit = false
-----@return void @使用时才调用
--function this.InitOnUse()
--    if this.isInit then
--        return
--    end
--    this.isInit = true
--    local cfgTable = SL:GetConfigTable('cfg_att_score')
--    ---@param v cfg_att_score_column
--    for k, v in pairs(cfgTable) do
--
--    end
--end