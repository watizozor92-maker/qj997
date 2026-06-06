---@class KLCommonItem:UIKmlLuaPanelBase
---@field view KLCommonItemView
local KLCommonItem = class(UIKmlLuaPanelBase)
local this =KLCommonItem

---@class BuiltItemParames
---@field itemid number cfg_item表对应id
---@field mfixsize string 例如 80,80 表示限定在80*80的框内,会自动计算缩放和位置
---@field mpos string 例如 45,45,45，表示模型的位置设置成45,45,45
---@field mrotate string 例如 45,45,45，表示模型的旋转设置成45,45,45.
---@field mscale string 例如 45,45,45 表示模型的缩放设置成45,45,45
---@field itemcount number 道具数量
---@field itemcustomcount string  自定义数量显示，传入字符串类型，会覆盖itemcount的值
---@field bgtype string 含义：是否显示背景框图， 默认值：1 -- 0：不显示 1：显示
---@field tips string  含义：为1注册点击事件有响应
---@field atlas string  bgimg所在图集
---@field bgimg string 含义：背景图，支持九宫格属性,填写方式和img的src一致

---@class OutItemParames 外置道具Item参数,下面的参数外部没传入，默认使用内部逻辑
---@field topLeftIconAtlas string  左上角Icon所在图集
---@field topLeftIconImg string 左上角Icon图片名字
---@field rankStr string 品阶显示，类似1D，2D这种
---@field isUseParentSize boolean 是否使用父对象的宽高

---创建时调用一次
function this:Init()

end

---注册UI事件和服务器消息
function this:RegistEvents()
	GUI:AddOnClickEvent(self.view.root,self,function()
		SL:OpenTips(nil, self.data.itemid)
	end)
end
---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
end

---@param data BuiltItemParames 内置道具Item组件参数
---@param outData OutItemParames 外置通用道具Item参数
function this:RefreshData(data,outData)
	self.data = data
	self.outData = outData or {}
	GUI:SetZIndex(self.view.outNode,202)
	GUI:Item_UpdataData(self.view.item,data)
	if data.width and data.height then
		GUI:setContentSize(self.view.root,data.width,data.height)
		GUI:setContentSize(self.view.outNode,data.width,data.height)
	end
	
	if self.outData.isUseParentSize then
		local w,h = GUI:getSizeDelta(self.view.root)
		GUI:setContentSize(self.view.item,w,h)
		GUI:setContentSize(self.view.outNode,w,h)
	end
	
	if self.outData.ta then
		--GUI:SetAttr(self.view.count_attach,"ta",self.outData.ta)
	end
	
	if self.data.tipscallback then
		GUI:AddOnClickEvent(self.view.root,self,self.data.tipscallback)
	end
	
	GUI:setVisible(self.view.img_leftTop,false)
	GUI:setVisible(self.view.txt_rank,false)
	GUI:setVisible(self.view.img_arrow,false)
	self:ImgLeftTopDeal()
	self:TxtRankDeal()
end

function this:ImgLeftTopDeal()
	local topLeftIconAtlas =  self.outData.topLeftIconAtlas or "Atlas/UIBagPanel_Out.spriteatlas"
	local topLeftIconImg = self.outData.topLeftIconImg
	local img_quality = self.view.img_leftTop
	if topLeftIconAtlas and topLeftIconImg then
		GUI:setVisible(img_quality,true)
		GUI:Image_loadTexture(img_quality, topLeftIconImg, topLeftIconAtlas)
	else
		---@type cfg_item_column
		local itemCfg = SL:GetConfig("cfg_item",self.data.itemid)
		if itemCfg.type == E_ItemType.Equip then --装备根据 cfg_equip_quality 表处理
			local entryLib = nil
			if SL:HasConfig('cfg_equip_entryLib', self.data.itemid) then
				entryLib = SL:GetConfig('cfg_equip_entryLib', self.data.itemid)
			end
			GUI:setVisible(img_quality, false)
			if entryLib then
				local qualityTbl = SL:GetConfigTable("cfg_equip_quality")
				---@param v cfg_equip_quality_column
				for _, v in pairs(qualityTbl) do
					if not string.isNullOrEmpty(v.logo) and entryLib.initialRating >= v.stage[1] and entryLib.initialRating <= v.stage[2] then
						GUI:setVisible(img_quality, true)
						GUI:Image_loadTexture(img_quality, v.logo, topLeftIconAtlas)
						break
					end
				end
			end
		end
	end
	GUI:SetImageNativeSize(self.view.img_leftTop)
end

function this:TxtRankDeal()
	local rankStr =  self.outData.rankStr
	if rankStr then
		GUI:setVisible(self.view.txt_rank,true)
		GUI:Text_setString(self.view.txt_rank,rankStr)
	else
		---@type cfg_item_column
		local itemCfg = SL:GetConfig("cfg_item",self.data.itemid)
		if itemCfg.type == E_ItemType.Equip then
			if not (#itemCfg.wearBarID == 0 or itemCfg.wearBarID[1] < 4 or itemCfg.wearBarID[1] == EEquipWearBar.Suit
					or SL:HasConfig("cfg_equip_strengthen", self.data.itemid)) then
				local rank = SL:GetEquipValue(EMetaVarGetKey.EQUIP_RANK, "equip", self.data.itemid, SL:GetMetaValue(EMetaVarGetKey.UID))
				GUI:Text_setString(self.view.txt_rank, rank ~= 0 and rank.."D" or "")
				GUI:setVisible(self.view.txt_rank,true)
			end
		end
	end
end

function this:Hide()
end

function this:Close()
end

return this
