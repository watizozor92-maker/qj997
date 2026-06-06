---@class KLTradeHomePanel:UIKmlLuaPanelBase
---@field view KLTradeHomePanelView
local KLTradeHomePanel = class(UIKmlLuaPanelBase)
local this =KLTradeHomePanel
local TexT_Minus_18 = 18 -- 大于6个字所用字体大小
local TexT_18 = 16 --6个字所用字体大小
local TexT_Add_18 = 12 -- 大于6个字所用字体大小

local FilterEntryAttCfgs
local SortTypeCfgs = 
{ 
  { name = "排序"},
  { name = "时间↑", filed = "listingTime", order = "asc"},
  { name = "时间↓", filed = "listingTime", order = "desc"},
  { name = "价格↑", filed = "totalPrice", order = "asc"},
  { name = "价格↓", filed = "totalPrice", order = "desc"},
}
local CareerTypeCfgs
local QualityTypeCfgs

---@class TradeCatalogueItem
---@field isRoot boolean 是否是根节点
---@field isCategory boolean 是否是分类节点
---@field name string 名称
---@field isCategoryExpand boolean 是否展开分类
---@field children TradeCatalogueItem[] 子节点
---@field parent TradeCatalogueItem 父节点
---@field rootType number
---@field subType number

---@class TradeSearchFilter 交易行筛选
---@field type number 类型
---@field subType number 子类型
---@field grade number 品质
---@field job number 职业
---@field entryNums number 词条编号

---@class TradeSearchPageParam 交易行分页参数
---@field page number 页码
---@field size number 数量
---@field lastId number 最后一个商品的ID

---@class TradeSearchRequest 交易行请求DTO
---@field searchType number 全部=1，公示=2，预购=3
---@field filters TradeSearchFilter 筛选条件，键值对类型
---@field sort table 排序条件，多条件，list类型
---@field pageParam TradeSearchPageParam 分页参数，页码、数量、

---创建时调用一次
function this:Init()
    GUI:OSAScrollView_Initialized(self.view.scrollview_catalogue,nil,self.CatalogueItemUpdateFun,self)
    GUI:OSAScrollView_SetItemSizeGetFun(self.view.scrollview_catalogue, self.CatalogueItemSizeFun, self)
    ---@type TradeCatalogueItem[]
    self.catalogueDataList = {}
    self:GenCatalogue()
    
    self.selectedItemData = self.catalogueDataList[1]
    ---@type TradeSearchRequest
    self.tradeSearchRequest = {
        searchType = 1,
        filters = {
        },
        sort = {},
        pageParam = {
            page = 1,
            size = 100, -- 一页多少个
        }
    }
    if SL:HasConfig("cfg_global", 860001) then
        self.tradeSearchRequest.pageParam.size = tonumber(SL:GetConfig("cfg_global", 860001).value)
    end

    if self.args == 3 then
        GUI:setVisible(self.view.btn_filter_quality,false)
        GUI:setVisible(self.view.btn_filter_level,false)
    else
        GUI:setVisible(self.view.btn_filter_quality,true)
        GUI:setVisible(self.view.btn_filter_level,true)
    end
    FilterEntryAttCfgs = EquipFunc.GetEquipAttNameList()
    
    --初始化阶数筛选
    self:CreateFilterBtn(FilterEntryAttCfgs, "btn_filter_level_", "stallShow", self.view.layout_level)

    -- 初始化品质筛选
    QualityTypeCfgs = {}
    table.insert(QualityTypeCfgs, { name = "品质"})
    local qualityCfgs = SL:GetConfigTable("cfg_equip_quality")
    for i, v in pairs(qualityCfgs) do
        table.insert(QualityTypeCfgs, v)
    end
    self:CreateFilterBtn(QualityTypeCfgs, "btn_filter_quality_", "name", self.view.layout_146)

    -- 初始化职业筛选
    local temp = {}
    CareerTypeCfgs = {}
    local careerCfgs = SL:GetConfigTable("cfg_career")
    for i, v in pairs(careerCfgs) do
        local cfg = temp[v.baseCareer]
        if cfg == nil or cfg.careerRank > v.careerRank then
            temp[v.baseCareer] = v
        end
    end
    table.insert(CareerTypeCfgs, { name = "职业" })
    for i, v in pairs(temp) do
        table.insert(CareerTypeCfgs, v)
    end
    self:CreateFilterBtn(CareerTypeCfgs,"btn_filter_career_", "name", self.view.layout_171)
    
    -- 初始化排序
    self:CreateFilterBtn(SortTypeCfgs, "btn_sort_", "name", self.view.layout_161)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn_filter_level,self,self.BtnFilterLevelOnClick)
    GUI:AddOnClickEvent(self.view.btn_sort,self,self.BtnSortOnClick)
    GUI:AddOnClickEvent(self.view.btn_filter_career,self,self.BtnFilterCareerOnClick)
    GUI:AddOnClickEvent(self.view.btn_filter_quality,self,self.BtnFilterQualityOnClick)
    GUI:AddOnClickEvent(self.view.btn_dropdown_mask,self,self.BtnDropdownMaskOnClick)
    for i = 1, #FilterEntryAttCfgs do
        GUI:AddOnClickEvent(self.view["btn_filter_level_" .. i],self,self.BtnFilterLevelItemOnClick,i)
    end
    self.lastSelectedLevelItem = self.view["btn_filter_level_1"]
    for i = 1, #SortTypeCfgs do
        GUI:AddOnClickEvent(self.view["btn_sort_" .. i],self,self.BtnSortItemOnClick,i)
    end
    self.lastSelectedSortItem = self.view["btn_sort_1"]
    for i = 1, #CareerTypeCfgs do
        GUI:AddOnClickEvent(self.view["btn_filter_career_".. i], self, self.BtnFilterCareerItemOnClick, i)
    end
    self.lastSelectedCareerItem = self.view["btn_filter_career_1"]
    for i = 1, 4 do
        GUI:AddOnClickEvent(self.view["btn_filter_quality_".. i],self,self.BtnFilterQualityItemOnClick,i)
    end
    self.lastSelectedQualityItem = self.view["btn_filter_quality_1"]

    --[[SL:RegisterLUAEvent(LUA_EVENT_TRADE_BUY_REQUEST,self.RequestRefreshGoodsList,self)

    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_TRADE_MY_PRE_GOODS,self.RequestRefreshGoodsList,self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_TRADE_BUY_GOODS,self.RequestRefreshGoodsList,self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_TRADE_PRE_ORDER,self.RES_TRADE_PRE_ORDER,self)]]
end

---创建或者刷新界面数据时调用
function this:Refresh()
    local uiPath
    if self.args == 1 then
        uiPath = "dev/outui/Trade/Panel/KLTradeCommonGoods/KLTradeCommonGoodsPanel"
    elseif self.args == 2 then
        uiPath = "dev/outui/Trade/Panel/KLTradeUnionGoods/KLTradeUnionGoodsPanel"
    elseif self.args == 3 then
        uiPath = "dev/outui/Trade/Panel/KLTradeCrossServerGoods/KLTradeCrossServerGoodsPanel"
    end

    if uiPath then
        GUI:UIPanel_Open("dev/outui/Trade/Panel/KLTradeCommonGoods/KLTradeCommonGoodsPanel", nil, nil, nil, nil, function(panel)
            self.curGoodsPanel = panel
            self:RequestRefreshGoodsList()
        end)
    end
    
    GUI:OSAScrollView_RefreshList(self.view.scrollview_catalogue,#self.catalogueDataList)
end

function this:GenCatalogue()
    ---@type cfg_stall_list_column[]
    local tblList = SL:GetConfigTable("cfg_stall_list")
    ---@type table<number,cfg_stall_list_column[]>
    local groupList = {}
    local groupRank = {} --记录每个组的排序，按遍历顺序排列
    for _, v in pairs(tblList) do
        if (self.args == 3 and (v.typeid == 2 or v.typeid == 3 or v.typeid == 4)) or self.args ~= 3 then
            if not groupList[v.typeid] then
                groupList[v.typeid] = {}
                table.insert(groupRank,v.typeid)
            end
            table.insert(groupList[v.typeid],v)
        end
    end
    for _, v in pairs(groupRank) do
        ---@type TradeCatalogueItem
        local catalogueItem = {}
        catalogueItem.isRoot = true
        local child = groupList[v]
        catalogueItem.name = child[1].typename
        if #child > 1 then
            catalogueItem.children = {}
            for _, childData in pairs(child) do
                ---@type TradeCatalogueItem
                local childItem = {}
                childItem.name = childData.subtypename
                childItem.isCategory = false
                childItem.isRoot = false
                childItem.parent = catalogueItem
                childItem.rootType = childData.typeid
                childItem.subType = childData.subtypeid
                table.insert(catalogueItem.children, childItem)
            end
        end
        catalogueItem.isCategory = #child > 1
        catalogueItem.rootType = child[1].typeid
        catalogueItem.subType = nil
        table.insert(self.catalogueDataList, catalogueItem)
    end
end

---创建筛选按钮
function this:CreateFilterBtn(dataList, id, textKey, parent)
    for i, v in pairs(dataList) do
        GUI:Button_Create(parent, {
            id = id..i,
            text = v[textKey],
            height = 30,
            color = i == 1 and "#FFFFFF" or "#00000000",
            src="bg_btn_orange",
            atlas="Atlas/TS_Common.spriteatlas",
            outlinesize="1",
            outlinecolor="#000000",
            raycast="1"
        })
    end
end

---@param item UIKmlLuaControl
function this:CatalogueItemUpdateFun(item,index)
    local catalogueData = self.catalogueDataList[index+1]
    local txtName = GUI:GetChildById(item,"txt_name")
    local content = GUI:GetChildById(item,"btn_content")
    GUI:Text_setString(txtName,catalogueData.name)

    GUI:AddOnClickEvent(content,self,self.CatalogueItemOnClick,catalogueData)
    if catalogueData.isRoot then
        local select = true
        if table.isNullOrEmpty(catalogueData.children) then
            select =  self:IsSelectedCatalogueData(catalogueData)
        else
            if catalogueData.isCategoryExpand == true and select then
                select = true
            else
                select = false
            end
        end
        GUI:Image_loadTexture(content,self:IsSelectedCatalogueData(catalogueData) and "btn_cebian1" or "btn_cebian2","Atlas/FG_Common.spriteatlas")
        --GUI:Toggle_setSrc(item,"Atlas/Common.spriteatlas","button_interface_window20","button_interface_window23")
        GUI:setContentSize(content,147,44)
    else
        GUI:Image_loadTexture(content,self:IsSelectedCatalogueData(catalogueData) and "btn_cebian5" or "btn_cebian7","Atlas/FG_Common.spriteatlas")
        --GUI:Toggle_setSrc(item,"Atlas/Common.spriteatlas","bg1","ty_btn_light")
        GUI:setContentSize(content,112,37)
    end
end

function this:CatalogueItemSizeFun(index)
    local catalogueData = self.catalogueDataList[index+1]
    if catalogueData.isRoot then
        return 48
    else
        return 40
    end
end

function this:IsSelectedCatalogueData(catalogueData)
    return self.selectedCatalogueData == catalogueData or self.selectedItemData == catalogueData
end

---@param data TradeCatalogueItem
function this:CatalogueItemOnClick(_, data)
    if data.isCategory then
        data.isCategoryExpand = not data.isCategoryExpand
        self:RefreshCatalogueDataList()
        self.selectedCatalogueData = data
        self.selectedItemData = self.selectedCatalogueData.children[1]
        if data.isCategoryExpand then
            self.selectedItemData = self.selectedCatalogueData.children[1]
        end
        self.selectedItemData = nil
    else
        if data.isRoot then
            self.selectedCatalogueData = nil
        else
            self.selectedCatalogueData = data.parent
        end
        self.selectedItemData = data
    end
    GUI:OSAScrollView_RefreshList(self.view.scrollview_catalogue,#self.catalogueDataList)
    if data.rootType == 100 then -- 公示
        self.tradeSearchRequest.searchType = 2
    elseif data.rootType == 200 then -- 预购
        self.tradeSearchRequest.searchType = 3
    else
        self.tradeSearchRequest.searchType = 1
    end
    if self.tradeSearchRequest.searchType == 1 then
        self.tradeSearchRequest.filters.type = data.rootType > 0 and data.rootType or nil
        self.tradeSearchRequest.filters.subType = data.subType
    else
        self.tradeSearchRequest.filters.type = nil
        self.tradeSearchRequest.filters.subType = nil
    end
    self:RequestRefreshGoodsList()
end

function this:RefreshCatalogueDataList()
    local newCatalogueDataList = {}
    for _, v in pairs(self.catalogueDataList) do
        if v.isRoot then
            table.insert(newCatalogueDataList, v)
            if v.isCategory and v.isCategoryExpand then
                if v.children then
                    for _, child in pairs(v.children) do
                        table.insert(newCatalogueDataList, child)
                    end
                end
            end
        end
    end
    self.catalogueDataList = newCatalogueDataList
end

function this:RES_TRADE_PRE_ORDER(_,message)
    if message then
        SL:onLUAEvent(LUA_EVENT_TRADE_BUY_REQUEST)
    end
end

function this:BtnFilterQualityItemOnClick(item,index)
    local qualityCfg = QualityTypeCfgs[index]
    self.tradeSearchRequest.filters.grade = qualityCfg.id
    --GUI:Button_setTitleText(self.view.btn_filter_quality,qualityName)
    self:AutoSetText(self.view.btn_filter_quality_txt, qualityCfg.name)
    GUI:setVisible(self.view.dropdown_list_quality,false)
    GUI:setVisible(self.view.btn_dropdown_mask,false)

    self:RequestRefreshGoodsList()

    if self.lastSelectedQualityItem then
        GUI:setColor(self.lastSelectedQualityItem,"#00000000")
    end
    self.lastSelectedQualityItem = item
    GUI:setColor(item,"#FFFFFFFF")
end

function this:BtnFilterCareerItemOnClick(item,index)
    local careerCfg = CareerTypeCfgs[index]
    self.tradeSearchRequest.filters.job = careerCfg.baseCareer
    --GUI:Button_setTitleText(self.view.btn_filter_career,careerName)
    self:AutoSetText(self.view.btn_filter_career_txt, careerCfg.name)
    GUI:setVisible(self.view.dropdown_list_career,false)
    GUI:setVisible(self.view.btn_dropdown_mask,false)
    
    self:RequestRefreshGoodsList()

    if self.lastSelectedCareerItem then
        GUI:setColor(self.lastSelectedCareerItem,"#00000000")
    end
    self.lastSelectedCareerItem = item
    GUI:setColor(item,"#FFFFFFFF")
end

function this:BtnSortItemOnClick(item,index)
    local sortCfg = SortTypeCfgs[index]
    if string.isNullOrEmpty(sortCfg.filed) then
        self.tradeSearchRequest.sort = {}
    else
        self.tradeSearchRequest.sort = {
            { field = sortCfg.filed, order = sortCfg.order }
        }
    end
    --GUI:Button_setTitleText(self.view.btn_sort,sortName)
    self:AutoSetText(self.view.btn_sort_txt, sortCfg.name)
    GUI:setVisible(self.view.dropdown_list_order,false)
    GUI:setVisible(self.view.btn_dropdown_mask,false)

    self:RequestRefreshGoodsList()

    if self.lastSelectedSortItem then
        GUI:setColor(self.lastSelectedSortItem,"#00000000")
    end
    self.lastSelectedSortItem = item
    GUI:setColor(item,"#FFFFFFFF")
end

function this:BtnFilterLevelItemOnClick(item,index)
    local attCfg = FilterEntryAttCfgs[index]
    self.tradeSearchRequest.filters.entryNums = attCfg.stallNum
    --GUI:Button_setTitleText(self.view.btn_filter_level,levelName)
    --GUI:Text_setText(self.view.btn_filter_level_txt,levelName)
    self:AutoSetText(self.view.btn_filter_level_txt, attCfg.stallShow)
    GUI:setVisible(self.view.dropdown_list_level,false)
    GUI:setVisible(self.view.btn_dropdown_mask,false)

    self:RequestRefreshGoodsList()


    if self.lastSelectedLevelItem then
        GUI:setColor(self.lastSelectedLevelItem,"#00000000")
    end
    self.lastSelectedLevelItem = item
    GUI:setColor(item,"#FFFFFFFF")
end

function this:AutoSetText(control, str)
    if string.len(str) == 18 then --一个字3个字符，6个字
        GUI:Text_setFontSize(self.view.btn_filter_level_txt,TexT_18)
    elseif  string.len(str) > 18 then
        GUI:Text_setFontSize(self.view.btn_filter_level_txt,TexT_Add_18)
    else
        GUI:Text_setFontSize(self.view.btn_filter_level_txt,TexT_Minus_18)
    end
    GUI:Text_setText(control,str)
end

function this:BtnFilterLevelOnClick()
    self:CloseAllDropdownList(self.view.dropdown_list_level)
    local visible = GUI:getVisible(self.view.dropdown_list_level)
    GUI:setVisible(self.view.dropdown_list_level,not visible)
    GUI:setVisible(self.view.btn_dropdown_mask,not visible)
end

function this:BtnSortOnClick()
    self:CloseAllDropdownList(self.view.dropdown_list_order)
    local visible = GUI:getVisible(self.view.dropdown_list_order)
    GUI:setVisible(self.view.dropdown_list_order,not visible)
    GUI:setVisible(self.view.btn_dropdown_mask,not visible)
end

function this:BtnFilterQualityOnClick()
    self:CloseAllDropdownList(self.view.dropdown_list_quality)
    local visible = GUI:getVisible(self.view.dropdown_list_quality)
    GUI:setVisible(self.view.dropdown_list_quality,not visible)
    GUI:setVisible(self.view.btn_dropdown_mask,not visible)
end

function this:BtnFilterCareerOnClick()
    self:CloseAllDropdownList(self.view.dropdown_list_career)
    local visible = GUI:getVisible(self.view.dropdown_list_career)
    GUI:setVisible(self.view.dropdown_list_career,not visible)
    GUI:setVisible(self.view.btn_dropdown_mask,not visible)
end

function this:BtnDropdownMaskOnClick()
    self:CloseAllDropdownList()
    GUI:setVisible(self.view.btn_dropdown_mask,false)
end

function this:CloseAllDropdownList(except)
    if except ~= self.view.dropdown_list_career then
        GUI:setVisible(self.view.dropdown_list_career,false)
    end
    if except ~= self.view.dropdown_list_order then
        GUI:setVisible(self.view.dropdown_list_order,false)
    end
    if except ~= self.view.dropdown_list_quality then
        GUI:setVisible(self.view.dropdown_list_quality,false)
    end
    if except ~= self.view.dropdown_list_level then
        GUI:setVisible(self.view.dropdown_list_level,false)
    end
end

---请求交易行商品
function this:RequestRefreshGoodsList()
    self.curGoodsPanel:RequestRefreshGoodsList(self.tradeSearchRequest, true)
end

--region 事件



--endregion


function this:Close()
    GUI:UIPanel_Close("dev/outui/Trade/Panel/KLTradeCommonGoods/KLTradeCommonGoodsPanel")
    GUI:UIPanel_Close("dev/outui/Trade/Panel/KLTradeUnionGoods/KLTradeUnionGoodsPanel")
    GUI:UIPanel_Close("dev/outui/Trade/Panel/KLTradeCrossServerGoods/KLTradeCrossServerGoodsPanel")
end

return this
