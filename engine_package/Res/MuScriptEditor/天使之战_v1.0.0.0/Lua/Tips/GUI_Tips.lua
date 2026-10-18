---@class GUI
GUI = {}
local this = GUI
this.luaTable = {}
this.allChildMats = {}

---添加点击事件
---@param handle UIKmlLuaControlHandler 控件处理器
---@param ui any 界面对象,默认self就行
---@param callback function 点击回调
---@param eventData any 传递给回调的数据
---@param clickSoundId number 点击音效ID,不填的话默认id用20019，点击UI时的音效,填-1或者其他音效表里面没有的id，表示点击不播放音效
---@param clickInterval number 点击间隔(毫秒)，仅对当前控件生效，不填则使用全局默认间隔
function this:AddOnClickEvent(handle, ui, callback, eventData,clickSoundId,clickInterval) end

---设置 Toggle 值改变事件
---@param control UIKmlLuaControlHandler 控件处理器
---@param ui any 界面对象(默认self就行)
---@param callback function 值改变回调
---@param eventData any 传递给回调的数据
---@param clickInterval number 点击间隔(毫秒)，仅对当前控件生效，不填则使用全局默认间隔
---@return any
function this:SetToggleOnValueChange(control, ui, callback, eventData, clickInterval) end

---设置 ToggleGroup
---@param control UIKmlLuaControlHandler 控件处理器
---@param parentControl UIKmlLuaControl 父 ToggleGroup 控件
function this:SetToggleGroup(control, parentControl) end

---设置 Slider 值改变事件
---@param control UIKmlLuaControlHandler 控件处理器
---@param ui any 界面对象(默认self就行);
---@param callback function 值改变回调
---@param eventData any 传递给回调的数据
---@return any
function this:SetSliderOnValueChange(control, ui, callback, eventData) end

---初始化 DataList 数据
---@param handler UIKmlLuaControlHandler 控件处理器
---@param ItemCountFunc function 获取列表数量的函数
---@param ItemGetFunc function 获取 Item 实例的函数 (可选)
---@param ItemInitFunc function Item 初始化回调
---@param ItemUpdateFunc function Item 刷新回调
---@param ItemSizeFunc function 无限滚动列表下不等距回调函数 (可选)
---@param isUpdateDataNotSroll boolean 刷新数据时是否不滚动，默认为 false
---@return void 初始化只需要调用一次，刷新界面的时候调用 DataListUpdateData
function this:DataListInitData(handler, ItemCountFunc, ItemGetFunc, ItemInitFunc, ItemUpdateFunc, ItemSizeFunc,isUpdateDataNotSroll) end

---刷新 DataList 数据
---@param control UIKmlLuaControlHandler 控件处理器
---@param immediately boolean 是否立即刷新，默认为 false。防止同一帧多次刷新增大消耗，如需立即获取子控件则传 true。
---@param callBack function 刷新完成后的回调
---@param scrollindex number 滚动到的索引，默认为 -1 (不滚动)
function this:DataListUpdateData(control, immediately,callBack,scrollindex) end

---强制将 DataList 的刷新全部改成同一帧，减少闪烁问题
---代价：同一帧调用多次会有多次消耗，如果有这种情况，自行外置控制刷新
---@param b boolean 是否全局立即刷新
function GUI:SetDataListGlobalImmediately(b) end

---移除所有子控件
---@param control UIKmlLuaControlHandler 控件处理器
function this:RemoveAllChildren(control) end

---从父节点移除
---@param control UIKmlLuaControlHandler 控件处理器
function this:RemoveFromParent(control) end

---获取父控件处理器
---@param control UIKmlLuaControlHandler 控件处理器
---@return UIKmlLuaControlHandler 父控件处理器
function this:GetParent(control) end

---通过 Transform 获取父物体
---@param control UIKmlLuaControlHandler 控件处理器
---@return UnityEngine.Transform 父物体的 Transform
function this:GetParentByTransform(control) end

---获取父物体的 Transform
---@param control UIKmlLuaControlHandler 控件处理器
---@return UnityEngine.RectTransform 父物体的 RectTransform
function this:GetParentTransform(control) end

---设置父物体
---@param control UIKmlLuaControlHandler 待设置的控件处理器
---@param parent UnityEngine.Transform 父物体 Transform,Unity对象,通过GUI:GetRectTransform接口获得;
---@param worldPositionStays boolean 是否保持世界坐标，默认为 false
---@return boolean 是否设置成功
function this:SetParent(control, parent,worldPositionStays) end

---获取所有子控件处理器
---@param handle UIKmlLuaControlHandler 控件处理器
---@return UIKmlLuaControlHandler[] 子控件处理器列表
function this:GetChildren(handle) end

---获取子控件数量
---@param handle UIKmlLuaControlHandler 控件处理器
---@return number 子控件总数
function this:GetChildrenCount(handle) end

---获取处于激活状态的子控件数量
---@param handle UIKmlLuaControlHandler 控件处理器
---@return number 激活的子控件数量
function this:GetActiveChildrenCount(handle) end

---通过索引获取子控件处理器
---@param handle UIKmlLuaControlHandler 控件处理器
---@param index number 索引 (从 0 开始)
---@return UIKmlLuaControlHandler 子控件处理器，不存在则返回 nil
function this:GetChildrenByIndex(handle,index) end

---根据 ID 获取子控件处理器
---@param handler UIKmlLuaControlHandler 控件处理器
---@param id string 子控件 ID,目标子控件的唯一标识符
---@return UIKmlLuaControlHandler 子控件处理器，未找到返回 nil
function this:GetChildById(handler, id) end

---根据 Tag 获取第一个子控件处理器
---@param handler UIKmlLuaControlHandler 控件处理器
---@param tag string 目标子控件的gameobject tag
---@return UIKmlLuaControlHandler 子控件处理器，未找到返回 nil
function this:GetChildByTag(handler, tag) end

---添加子物体
---@param control UIKmlLuaControlHandler 父控件
---@param child UIKmlLuaControlHandler 子控件
function this:AddChild(control, child) end

---根据 ID 移除子物体
---@param control UIKmlLuaControlHandler 父控件
---@param id string 子控件 ID
function this:RemoveChildById(control, id) end

---将坐标转换到世界空间
---@param control UIKmlLuaControlHandler 控件处理器
---@param x number 相对控件control的X 坐标，局部坐标
---@param y number 相对控件control的Y 坐标，局部坐标
---@param z number 相对控件control的Z 坐标，默认为 0，局部坐标
---@return Vector3 世界坐标
function this:ConvertToWorldSpace(control, x, y,z) end

---将坐标转换到节点空间 (本地空间)
---@param control UIKmlLuaControlHandler 控件处理器
---@param x number 世界 X 坐标
---@param y number 世界 Y 坐标
---@return Vector3 本地坐标。相对于control的局部坐标，建议使用 ConvertToLocalSpace。
function this:ConvertToNodeSpace(control, x, y) end

---将坐标转换到本地空间
---@param control UIKmlLuaControlHandler 控件处理器
---@param x number 世界 X 坐标
---@param y number 世界 Y 坐标
---@param z number 世界 Z 坐标，默认为 0
---@return Vector3 本地坐标（局部坐标），相对于control的局部坐标
function this:ConvertToLocalSpace(control, x, y,z) end

---添加触摸/交互事件
---@param handle UIKmlLuaControlHandler 控件处理器
---@param ui UIKmlLuaPanelBase 界面对象
---@param callback function 事件回调，参数为 (ui, handle, eventName, systemData)
function this:AddOnTouchEvent(handle, ui, callback) end

---停止所有动作/移除 UIEvent 组件
---@param control UIKmlLuaControlHandler 控件处理器
function this:StopAllActions(control) end

---设置 DropDown 值改变事件
---@param control UIKmlLuaControlHandler 控件处理器
---@param ui UIKmlLuaPanelBase 界面对象
---@param callback function 值改变回调
---@param eventData any 传递给回调的数据
function this:SetDropDownOnValueChange(control, ui, callback, eventData) end

---根据面板名称获取 Transform
---@param panelName string 面板名称
---@return UnityEngine.Transform 面板 Transform
function this:GetPanelTransform(panelName) end

---获取控件的 Transform
---@param panelName string 面板名称
---@param controlName string 控件名称
---@return UnityEngine.RectTransform 控件的 RectTransform
function this:GetControlTransform(panelName, controlName) end

---获取 RectTransform
---@param control UIKmlLuaControlHandler 控件处理器
---@return UnityEngine.RectTransform 控件的 RectTransform
function this:GetRectTransform(control) end

---克隆控件
---@param panelName string 面板名称
---@param controlName string 待克隆的控件名称
---@param index number 层级，和控件属性zindex一个意思
---@return UIKmlLuaControlHandler 克隆出来的控件处理器
function this:CloneControl(panelName, controlName, index) end

---删除克隆出来的控件
---@param panelName string 面板名称
---@param controlName string :控件名称-如果是通过GUI:CloneControl创建的控件，要删除的话，克隆的控件id的controlName_clonePanel
function this:DelCloneControl(panelName, controlName) end

---屏幕坐标转矩形内的世界坐标
---@param control UIKmlLuaControlHandler 参考控件处理器
---@param position Vector2 屏幕坐标
---@return boolean|Vector3 是否成功|世界坐标
function this:ScreenPointToWorldPointInRectangle(control,position) end

---屏幕坐标转矩形内的本地坐标
---@param control UIKmlLuaControlHandler 参考控件处理器
---@param position Vector2 屏幕坐标
---@return boolean, Vector2 是否成功, 本地坐标
function this:ScreenPointToLocalPointInRectangle(control,position) end

--- 将面板加入主界面隐藏/显示控制 
---@param control UIKmlLuaPanelBase 界面对象
function this:AddMainPanelUIHideShowPos(control) end

---设置 Prefab 控件加载完毕的回调
---@param control UIKmlLuaControlHandler Prefab 控件处理器
---@param callback function 加载完毕回调
function this:SetOnPrefabControlLoaded(control,callback) end

---创建视频播放控件
---@param parentHandler UIKmlLuaControlHandler 父节点处理器
---@param luaTable table 控件配置表
---@return UIKmlLuaControlHandler @创建出来的对象
function this:UIVideo_Create(parentHandler, luaTable) end

---视频是否正在播放
---@param control UIKmlLuaControlHandler 视频控件处理器
---@param path string 视频组件相对路径
---@return boolean 是否在播放
function this:IsVideoPlaying(control, path) end

---控件是否在滚动视图内
---@param panelName string 面板名称
---@param controlName string 控件名称
---@return boolean
function this:IsInScrollView(panelName,controlName) end

---添加 UI 拖拽功能
---@param control UIKmlLuaControlHandler 控件处理器
function this:AddOnlyUIDragable(control) end

---移除 UI 拖拽功能
---@param control UIKmlLuaControlHandler 控件处理器
function this:RemoveOnlyUIDragable(control) end

---设置全局像素完美开关
---@param b boolean 是否开启像素完美，默认为 true
function this:SetGlobalPixelPerfect(b) end

---设置序列帧重新播放
---@param control UIKmlLuaControlHandler 序列帧控件处理器
function this:SetFramesReplay(control) end

function this:SetAttr(control, attrName, attrValue) end

function this:GetAttr(control, attrName) end

function this:SetAttachAttr(control, attachId, attrName, attrValue) end

function this:SetGlobalPositionEven(enable) end

function this:GetAttachRectTransform(control, attachId) end

function this:setPosition(control, x, y) end

function this:setPositionX(control, value) end

function this:setPositionY(control, value) end

function this:setPositionZ(control, value) end

function this:getPosition(control) end

function this:GetLocalPosition(control) end

function this:setLocalPosition(control, x, y, z) end

function this:GetWorldPosition(control) end

function this:SetWorldPosition(control, x, y, z) end

function this:getPositionX(control) end

function this:getPositionY(control) end

function this:setAnchorPoint(control, x, y) end

function this:SetAnchorAdvanced(control, x, y) end

function this:getAnchorPoint(control) end

function this:setContentSize(control, sizeW, sizeH) end

function this:getSizeDelta(control) end

function this:getBoundingBox(control) end

function this:setTag(control, tag) end

function this:getTag(control) end

function this:setName(control, name) end

function this:getName(control) end

function this:setGrey(control, grey) end

function this:setRotation(control, rotation) end

function this:getRotation(control) end

function this:setAllRotation(control, rotation) end

function this:getAllRotation(control) end

function this:setRotationSkewX(control, rotation) end

function this:setRotationSkewY(control, rotation) end

function this:GetLocalEulerAngles(control) end

function this:SetLocalEulerAngles(control, x, y, z) end

function this:GetEulerAngles(control) end

function this:SetEulerAngles(control, x, y, z) end

function this:setVisible(control, visible) end

function this:getVisible(control) end

function this:setAlpha(control, alpha) end

function this:getAlpha(control) end

function this:setScale(control, scale) end

function this:getScale(control) end

function this:setScaleX(control, scale) end

function this:getScaleX(control) end

function this:setScaleY(control, scale) end

function this:getScaleY(control) end

function this:setFlippedX(control, value) end

function this:getFlippedX(control) end

function this:setFlippedY(control, value) end

function this:getFlippedY(control) end

function this:setLocalZOrder(control, value) end

function this:GetAnchoredPosition3D(control) end

function this:GetAnchoredPosition(control) end

function this:SetAnchoredPosition(control, pos) end

function this:setTouchEnabled(control, value) end

function this:getTouchEnabled(control) end

function this:delayTouchEnabled(control, delay) end

function this:setSwallowTouches(control, value) end

function this:getSwallowTouches(control) end

function this:SetRaycastTarget(control, value) end

function this:GetRaycastTarget(control) end

function GUI:SetActive(control, isActive) end

function GUI:Image_loadTexture(control, src, atlas) end

function this:Image_SetCircleType(control, isCircle) end

function GUI:Image_SetTexture(control, tex) end

function GUI:Image_GetTextureWidthAndHeight(tex) end

function this:Image_setFillAmount(control, fillAmount) end

function GUI:Image_setScale9Slice(control, scale9l, scale9r, scale9t, scale9b) end

function GUI:Image_setGrey(control, isGrey) end

function GUI:Image_setAlpha(control, value) end

function this:Image_setType(handle, type, fillMethod, fillOrigin, fillClockwise) end

function this:Image_SwitchDrawRect(control, isEnabled) end

function this:Image_SetVertexes2DrawRect(control, vertexes) end

function GUI:Button_loadTextures(control, Normalfilepath, Pressedfilepath, Disabledfilepath, atlas, highlightedfilePath) end

function GUI:setColor(control, color) end

function GUI:Button_loadTextureNormal(control, Normalfilepath, atlas) end

function GUI:Button_loadTexturePressed(control, Pressedfilepath, atlas) end

function GUI:Button_loadTextureHighlighted(control, highlightedPath, atlas) end

function GUI:Button_loadTextureDisabled(control, Disabledfilepath, atlas) end

function GUI:Button_setTitleText(control, value) end

function GUI:Button_getTitleText(control) end

function GUI:Button_setTitleColor(control, color) end

function GUI:Button_setTitleFontSize(control, value) end

function GUI:Button_setTitleFontName(control, fonttype) end

function GUI:Button_setMaxLineWidth(control, value) end

function GUI:Button_titleEnableOutline(control, color, outline) end

function GUI:Button_titleDisableOutLine(control) end

function GUI:Button_setBright(control, value) end

function GUI:Button_setGrey(control, isGrey) end

function GUI:Button_setScale9Slice(control, scale9l, scale9r, scale9t, scale9b) end

function this:SetImageAlpha(control, r, g, b, a) end

function this:SetGridLayoutGroupChildAlignment(control, cellAlign) end

function this:SetImageNativeSize(control) end

function this:SetInputText(control, str) end

function this:GetInputText(control) end

function this:SetInputEnable(control, value) end

function GUI:Text_SetGlobalMinTextRenderDelta(val) end

function GUI:Text_setString(control, value) end

function GUI:Text_getString(control) end

function GUI:Text_setMaxTextLength(control, limit) end

function GUI:Text_setTextColor(control, color) end

function GUI:Text_setText(control, str) end

function GUI:Text_setTextColorAlpha(control, alpha) end

function GUI:Text_setFontSize(control, value) end

function GUI:Text_setFontName(control, fonttype) end

function GUI:Text_enableOutline(control, color, outline) end

function GUI:Text_enableUnderline(control, underLineType, color) end

function GUI:Text_setMaxLineWidth(control, value) end

function GUI:Text_disableOutLine(control) end

function GUI:Text_setTextAlignment(control, value) end

function GUI:Text_setTextAreaSize(control, value) end

function GUI:Text_sethorwrap(control, value) end

function GUI:Text_setmline(control, value) end

function GUI:RichText_setchatiteminfo(control, value) end

function GUI:TextAtlas_setProperty(control, stringValue, charMapFile, itemWidth, itemHeight, atlas) end

function GUI:TextAtlas_setString(control, stringValue) end

function GUI:TextAtlas_getString(control) end

function GUI:Slider_loadBarTexture(control, src, atlas) end

function GUI:Slider_loadProgressBarTexture(control, src, atlas) end

function GUI:Slider_loadSlidBallTextureNormal(control, src, atlas) end

function GUI:Slider_setPercent(control, value) end

function GUI:Slider_getPercent(control) end

function GUI:Slider_setMaxPercent(control, value) end

function GUI:Slider_setMinPercent(control, value) end

function GUI:Slider_addOnEvent(control, ui, callback, eventData) end

function GUI:Item_setItemId(control, itemId) end

function GUI:Item_setItemCount(control, itemCount) end

function GUI:Item_UpdataData(control, luaTable) end

function GUI:Item_Rotate(control, rotate) end

function GUI:RotateAni(control, rotate) end

function GUI:Item_Scale(control, scale) end

function GUI:Model_setSrc(control, src, scale, rotate, pos, mfixsize, atlas) end

function GUI:Model_setParam(control, scale, rotate, pos, mfixsize) end

function GUI:Model_setnoclip(control, value) end

function GUI:Model_setMatParam(control, path, matIndex, propType, propName, propValue) end

function GUI:Model_setMaterials(control, pathList, pathMatList) end

function GUI:Model_IsLoading(control) end

function GUI:Toggle_setSrc(control, atlas, src, pimg) end

function this:Toggle_setIsOn(control, isOn) end

function this:Toggle_getIsOn(control) end

function this:ToggleGroup_AllowSwitChoff(control, isAllow) end

function GUI:SetLoadingbar_startper(control, stringValue) end

function GUI:SetControl_time(control, stringValue, timeEndCallback) end

function GUI:SetControl_moveto(control, stringValue) end

function GUI:SetCirclebar_startper(control, stringValue) end

function GUI:SetCirclebar_endper(control, stringValue) end

function GUI:SetCirclebar_time(control, stringValue) end

function GUI:SetScrollView_scrollpos(control, stringValue) end

function this:Input_SetOnValueChange(control, ui, callback, eventData) end

function this:Input_SetOnEndEdit(control, ui, callback, eventData) end

function this:Input_SetContentType(control, type) end

function this:SetMaxTextCount(control, maxCount) end

function this:Input_SetMaxTextCount(control, maxCount) end

function this:GetNearCanvasZindex(control) end

function GUI:SetIsOnWithoutNotify(control, isOn) end

function GUI:SetPlayerRoleInfo(control, model_list, equip_list, ani) end

function GUI:SetPlayerRoleAni(control, ani) end

function GUI:SetStreamAttr(control, strameCfgId) end

function GUI:ResetStreamAttr(control) end

function GUI:SetControlAnimation_stop(control, isStop) end

function GUI:GetID(control) end

function GUI:GetUUID(control) end

function GUI:SetID(control, id) end

function GUI:GetDropDownValue(control) end

function GUI:GetControlWidth(control) end

function GUI:GetControlHeight(control) end

function this:OSAScrollView_Initialized(handler, itemGetFun, itemUpdateFun, ui) end

function this:OSAScrollView_RefreshList(control, count) end

function this:OSAScrollView_SetItemSizeGetFun(control, itemSizeGetFun, ui) end

function this:OSAScrollView_ScrollTo(control, index, duration, normalizedOffsetFromViewportStart, normalizedPositionOfItemPivotToUse) end

function this:OSAScrollView_GetAllItems(control) end

function this:OSAScrollView_SetScrollable(control, scrollable) end

function GUI:GetTextPreferredWH(control) end

function GUI:SetOffsetMin(control, x, y) end

function this:GetOffsetMin(control) end

function GUI:SetOffsetMax(control, x, y) end

function this:GetOffsetMax(control) end

function GUI:SetScrollViewRectMaskData(control, x, y, width, height) end

function GUI:SetScrollView_DefaultItemSize(control, width, height) end

function GUI:SetSecScrollView(isSetOrReset, uipanelid, uuid, scrollControlId, secuipanelid, secuuid, secscrollControlId) end

function GUI:AddMask(control) end

function GUI:RemoveMask(control) end

function GUI:AddUIEmpty4Raycast(control) end

function GUI:ForceRebuildLayoutImmediate(control) end

function GUI:Effect_setEffectId(control, id) end

function this:Effect_setLooping(control, looping) end

function GUI:SetVideo(control, resPath, vwidth, vheight, playonwake, loop) end

function GUI:SetVideoSize(control, vwidth, vheight) end

function GUI:PlayVideo(control) end

function GUI:StopVideo(control) end

function GUI:PauseVideoByGameObject(gameObject) end

function GUI:ResumeVideoByGameObject(gameObject) end

function GUI:IsVideoPreparedByGameObject(gameObject) end

function this:SetAsFirstSibling(control) end

function this:SetAsLastSibling(control) end

function this:SetTogDefaultThis(control) end

function this:GetRectSize(control) end

function this:GetWidth(control) end

function this:GetHeight(control) end

function this:GetGameObject(control) end

function this:HideAllChilds(control) end

function GUI:RichText_setchatplayerid(control, value) end

function this:Image_DoColorFadeInKeepOut(control, fadeinTime, keepTime, fadeoutTime, onComplateFunc) end

function this:Image_StopColorFadeInKeepOut(sequence) end

function this:DOAnchorPos(control, targetVec2, time) end

function this:DOMove(control, targetVec3, time) end

function this:DOMoveX(control, targetX, time) end

function this:DOMoveY(control, targetY, time) end

function this:DOMoveZ(control, targetZ, time) end

function this:DOMoveLocal(control, targetVec3, time) end

function this:DOMoveLocalX(control, targetX, time) end

function this:DOMoveLocalY(control, targetY, time) end

function this:DOMoveLocalZ(control, targetZ, time) end

function this:DOAnchorPosX(control, targetX, time) end

function this:DOAnchorPosY(control, targetY, time) end

function this:DORotate(control, targetVec3, time, leanRotateType) end

function this:DORotateRound(control, axis, add, time, leanRotateRoundType) end

function this:DOScale(control, targetVec3, time) end

function this:DOAlphaCanvasGroup(control, to, time, isRecursive, from) end

function this:DOAlphaImage(control, to, time, isRecursive) end

function this:DOAlphaText(control, to, time, isRecursive) end

function this:DoColor(control, toColor, time, isRecursive) end

function this:DoColorText(control, toColor, time, isRecursive) end

function this:DOKill(t, callOnComplete) end

function this:TweenSetLoops(t, count) end

function this:TweenSetEase(t, type) end

function this:TweenIsComplete(t) end

function this:TweenSetRecursive(t, b) end

function this:TweenSetOnComplete(t, func) end

function this:TweenCreateSequence() end

function this:TweenSequenceAppend(seq, t) end

function this:TweenSequenceCancel(seq) end

function this:SetZIndex(control, zindex) end

function GUI:AddClippable(control) end

function GUI:RemoveClippable(control) end

function GUI:SetCircleMaskParams(control, radius, softness) end

function GUI:SetCustomTextMaterial(control, matResPath, isRecursion) end

function GUI:ResetCustomTextMaterial(control, isRecursion) end

function this:GetMaterial(control, path, index, isIncludeAllChildMats, customGameObject) end

function this:GetComponent(go, path, type_) end

function this:GetTextWidth(richText) end

function this:AddComponent(control, type_) end

function this:RemoveComponent(control, type_) end

function this:SetCustomImageMaterial(control, matResPath, isRecursion) end

function this:ResetCustomImageMaterial(control, isRecursion) end

---判断是否在 WebGL 环境下进行异步加载
---@return boolean
function GUI:IsWebGLAsync() end

---判断是否在 WebGL 浏览器环境下
---@return boolean
function GUI:IsWebGLBrowser() end

---判断是否在 WebGL 移动端浏览器环境下
---@return boolean
function GUI:IsWebGLMobileBrowser() end

---判断是否在边玩边下模式下
---@return boolean
function GUI:IsGMDownloadWhilePlaying() end

---根据路径获取界面对象
---@param filePath string 界面路径
---@param isIncludeSubPanels boolean 是否包含子面板，默认为 false
---@return UIKmlLuaPanelBase
function GUI:GetUI(filePath, isIncludeSubPanels) end

---通过界面名称（或者叫界面id）获取面板
---@param panelName string 面板名称 (controlId)
---@param isIncludeSubPanels boolean 是否包含子面板，默认为 false
---@return UIKmlLuaPanelBase 返回UI面板对象，或返回子面板对象
function GUI:GetUIByPanelName(panelName, isIncludeSubPanels) end

---判断界面是否正在加载中
---@param ui UIKmlLuaPanelBase 界面对象
---@return boolean
function GUI:IsUILoading(ui) end

---打开界面
---@param filePath string 界面路径
---@param parent UIKmlLuaControlHandler 挂载的父节点
---@param baseUI UIKmlLuaPanelBase 所属父界面对象
---@param args any 传递给界面的参数
---@param isMulti boolean 是否允许打开多个实例
---@param callback function 打开成功后的回调
---@param requireFun function 加载脚本的方法，默认为 requireOut
---@return UIKmlLuaPanelBase
function GUI:UIPanel_Open(filePath,parent,baseUI,args,isMulti,callback,requireFun) end

---关闭界面
---@param filePath string 界面lua路径
---@param uipanel UIKmlLuaPanelBase 可缺省，表示指定某个界面关闭，不填表示关闭所有filePath的界面
---@param uipanelId string 界面ID
---@param uipanels table 界面集合，默认为 self.uipanels
---@return void 上面的参数有一个找到即可
function GUI:UIPanel_Close(filePath,uipanel,uipanelId,uipanels) end

---关闭所有界面（支持排除指定界面）
---@param exceptFilePaths string[] 排除的文件路径列表（lua文件夹相对路径），可选。传入后对应路径的界面不会被关闭，支持多个，不填则关闭所有
---@param exceptsUIPanels UIKmlLuaPanelBase[] 排除的界面对象列表，可选。传入后对应的界面实例（GUI:UIPanel_Open返回的对象）不会被关闭，支持多个，不填则关闭所有
---@param exceptsUIPanelIds string[] 排除的界面ID列表，可选。传入后对应ID（控件uipanel的id值，即GUI:GetID(control)的返回值）的界面不会被关闭，支持多个，不填则关闭所有
---@return void 三个排除参数均为可选，只传nil则关闭所有界面；传入的参数按上述规则排除，其余全部关闭
function GUI:UIPanel_CloseAll(exceptFilePaths, exceptsUIPanels, exceptsUIPanelIds) end

---设置界面缓存时间
---@param path string 文件路径：要设置缓存时间的UI面板路径
---@param cacheTime number 缓存时间：缓存的持续时间，单位为秒，默认是300秒。0表示不做缓存，-1表示一直留在内存。UIPanel_Close 操作会调用OnHide。时间到了才会调用OnClose。
function GUI:SetUICacheTime(path,cacheTime) end

---获取界面缓存时间
---@param path string 文件路径: 要获取缓存时间的UI面板路径。
---@return number 返回UI面板的缓存时间，单位为秒，若无缓存则返回0。
function GUI:GetUICacheTime(path) end

---设置全局界面缓存时间
---@param time number 缓存时间（秒）
function GUI:SetGlobalUICacheTime(time) end

---获取全局界面缓存时间
---@return number 全局缓存时间（秒） 
function GUI:GetGlobalUICacheTime() end

---预加载界面
---@param path string UI面板路径
---@param count number 预加载数量，默认为 1
---@param baseUI UIKmlLuaPanelBase 所属父界面对象
---@param parent UIKmlLuaControlHandler 挂载的父节点
---@param args any 传递给界面的参数
---@param isMulti boolean 是否允许打开多个实例 一般是用在KLxxxItem的
---@param callback function 打开成功后的回调 如果打开界面要直接操作界面的话，最好将逻辑写在回调里面
---@param isWebGLForceLoad boolean WebGL 是否强制加载 H5上面默认是禁用预加载的，这个开关可以强制打开预加载
---@param isPreLoadShow boolean 预加载完成后是否立即显示预加载界面默认只是加载一下界面，不会调用Init，Show，Refresh。这个开关可以让正常打开界面一样走一下逻辑
function GUI:PreLoadUI(path,count,baseUI,parent,args,isMulti,callback,isWebGLForceLoad,isPreLoadShow) end

---判断界面是否在预加载列表中
---@param path string 界面路径
---@return boolean
function GUI:InPreLoadUI(path) end

---判断界面是否正在预加载显示中，
---@param baseUI UIKmlLuaPanelBase 界面对象
---@return boolean
function GUI:IsPreLoadShowing(baseUI) end

---关闭除主界面外的所有 UI
function GUI:CloseAllUIWithoutMainUI() end

---创建 UIPanel 控件
---@param parentHandler UIKmlLuaControlHandler 父节点处理器
---@param luaTable table 创建控件所需的数据表格。需要的数据就是kml控件的属性
---@return UIKmlLuaControlHandler
function GUI:UIPanel_Create(parentHandler, luaTable) end

---创建 Image 控件
---@param handler UIKmlLuaControlHandler 父节点处理器
---@param luaTable table 创建控件所需的数据表格。需要的数据就是kml控件的属性
---@return UIKmlLuaControlHandler
function GUI:Image_Create(handler, luaTable) end

---创建 Text 控件
---@param parentHandler UIKmlLuaControlHandler 父节点处理器
---@param luaTable table 创建控件所需的数据表格。需要的数据就是kml控件的属性
---@return UIKmlLuaControlHandler
function GUI:Text_Create(parentHandler, luaTable) end

---创建 Button 控件
---@param parentHandler UIKmlLuaControlHandler 父节点处理器
---@param luaTable table 创建控件所需的数据表格。需要的数据就是kml控件的属性
---@return UIKmlLuaControlHandler
function GUI:Button_Create(parentHandler, luaTable) end

---创建 CircleBar 控件
---@param parentHandler UIKmlLuaControlHandler 父节点处理器
---@param luaTable table 创建控件所需的数据表格。需要的数据就是kml控件的属性
---@return UIKmlLuaControlHandler
function GUI:CircleBar_Create(parentHandler, luaTable) end

---创建 CountDown 控件
---@param parentHandler UIKmlLuaControlHandler 父节点处理器
---@param luaTable table 创建控件所需的数据表格。需要的数据就是kml控件的属性
---@return UIKmlLuaControlHandler
function GUI:CountDown_Create(parentHandler, luaTable) end

---创建 DataList 控件
---@param parentHandler UIKmlLuaControlHandler 父节点处理器
---@param luaTable table 创建控件所需的数据表格。需要的数据就是kml控件的属性
---@return UIKmlLuaControlHandler
function GUI:DataList_Create(parentHandler, luaTable) end

---创建 Dropdown 控件
---@param parentHandler UIKmlLuaControlHandler 父节点处理器
---@param luaTable table 创建控件所需的数据表格。需要的数据就是kml控件的属性
---@return UIKmlLuaControlHandler
function GUI:Dropdown_Create(parentHandler, luaTable) end

---创建 Effect 控件
---@param parentHandler UIKmlLuaControlHandler 父节点处理器
---@param luaTable table 创建控件所需的数据表格。需要的数据就是kml控件的属性
---@return UIKmlLuaControlHandler
function GUI:Effect_Create(parentHandler, luaTable) end

---创建 Equip 控件
---@param parentHandler UIKmlLuaControlHandler 父节点处理器
---@param luaTable table 创建控件所需的数据表格。需要的数据就是kml控件的属性
---@return UIKmlLuaControlHandler
function GUI:Equip_Create(parentHandler, luaTable) end

---创建 Frames 控件
---@param parentHandler UIKmlLuaControlHandler 父节点处理器
---@param luaTable table 创建控件所需的数据表格。需要的数据就是kml控件的属性
---@return UIKmlLuaControlHandler
function GUI:Frames_Create(parentHandler, luaTable) end

---创建 GridView 控件
---@param parentHandler UIKmlLuaControlHandler 父节点处理器
---@param luaTable table 创建控件所需的数据表格。需要的数据就是kml控件的属性
---@return UIKmlLuaControlHandler
function GUI:GridView_Create(parentHandler, luaTable) end

---创建 Input 控件
---@param parentHandler UIKmlLuaControlHandler 父节点处理器
---@param luaTable table 创建控件所需的数据表格。需要的数据就是kml控件的属性
---@return UIKmlLuaControlHandler
function GUI:Input_Create(parentHandler, luaTable) end

---创建 Item 控件
---@param parentHandler UIKmlLuaControlHandler 父节点处理器
---@param luaTable table 创建控件所需的数据表格。需要的数据就是kml控件的属性
---@return UIKmlLuaControlHandler
function GUI:Item_Create(handler, luaTable) end

---创建 ItemGroup 控件 (已废弃)
---@param parentHandler UIKmlLuaControlHandler 父节点处理器
---@param luaTable table 控件配置表
---@return UIKmlLuaControlHandler
function GUI:ItemGroup_Create(parentHandler, luaTable) end

---创建 Layout 控件
---@param parentHandler UIKmlLuaControlHandler 父节点处理器
---@param luaTable table 创建控件所需的数据表格。需要的数据就是kml控件的属性
---@return UIKmlLuaControlHandler
function GUI:Layout_Create(parentHandler, luaTable) end

---创建 LoadingBar 控件
---@param parentHandler UIKmlLuaControlHandler 父节点处理器
---@param luaTable table 创建控件所需的数据表格。需要的数据就是kml控件的属性
---@return UIKmlLuaControlHandler
function GUI:LoadingBar_Create(parentHandler, luaTable) end

---@return UIKmlLuaControlHandler
---@param parentHandler UIKmlLuaControlHandler
--function GUI:LuaLoopScrollView_Create(parentHandler, luaTable)
--    local parent = UIKmlLuaControlGlobalHolder:GetKmlLuaControl(parentHandler)
--    local p = parent and parent.kmlControl or nil
--    local control = CS.KmlResourceManager.Create(p,CS.KingML.KmlControlConsts.CONTROL_LUA_LOOP_SCROLLVIEW,luaTable)
--    if not Main.EnableOutLuaEnv then
--        return UIKmlLuaControl(control)
--    end
--    return UIKmlLuaControlGlobalHolder:AddKmlLuaControl(parentHandler.panel,UIKmlLuaControl(control))
--end
---创建 Model 控件
---@param parentHandler UIKmlLuaControlHandler 父节点处理器
---@param luaTable table 创建控件所需的数据表格。需要的数据就是kml控件的属性
---@return UIKmlLuaControlHandler
function GUI:Model_Create(parentHandler, luaTable) end

---@return UIKmlLuaControlHandler
---@param parentHandler UIKmlLuaControlHandler
--function GUI:ModelDropdown_Create(parentHandler, luaTable)
--    local parent = UIKmlLuaControlGlobalHolder:GetKmlLuaControl(parentHandler)
--    local p = parent and parent.kmlControl or nil
--    local control = CS.KmlResourceManager.Create(p,CS.KingML.KmlControlConsts.CONTROL_MODELDROPDOWN,luaTable)
--    if not Main.EnableOutLuaEnv then
--        return UIKmlLuaControl(control)
--    end
--    return UIKmlLuaControlGlobalHolder:AddKmlLuaControl(parentHandler.panel,UIKmlLuaControl(control))
--end
---创建 OSAScrollView 控件
---@param parentHandler UIKmlLuaControlHandler 父节点处理器
---@param luaTable table 创建控件所需的数据表格。需要的数据就是kml控件的属性
---@return UIKmlLuaControlHandler
function GUI:OSAScrollView_Create(parentHandler, luaTable) end

---创建 Panel 控件
---@param parentHandler UIKmlLuaControlHandler 父节点处理器
---@param luaTable table 创建控件所需的数据表格。需要的数据就是kml控件的属性
---@return UIKmlLuaControlHandler
function GUI:Panel_Create(parentHandler, luaTable) end

---创建 PercentImg 控件
---@param parentHandler UIKmlLuaControlHandler 父节点处理器
---@param luaTable table 创建控件所需的数据表格。需要的数据就是kml控件的属性
---@return UIKmlLuaControlHandler
function GUI:PercentImg_Create(parentHandler, luaTable) end

---创建 Prefab 控件
---@param parentHandler UIKmlLuaControlHandler 父节点处理器
---@param luaTable table 创建控件所需的数据表格。需要的数据就是kml控件的属性
---@return UIKmlLuaControlHandler
function GUI:Prefab_Create(parentHandler, luaTable) end

---创建 RichText 控件
---@param parentHandler UIKmlLuaControlHandler 父节点处理器
---@param luaTable table 创建控件所需的数据表格。需要的数据就是kml控件的属性
---@return UIKmlLuaControlHandler
function GUI:RichText_Create(parentHandler, luaTable) end

---创建 Role 控件
---@param parentHandler UIKmlLuaControlHandler 父节点处理器
---@param luaTable table 创建控件所需的数据表格。需要的数据就是kml控件的属性
---@return UIKmlLuaControlHandler
function GUI:Role_Create(parentHandler, luaTable) end

---创建 ScrollView 控件
---@param parentHandler UIKmlLuaControlHandler 父节点处理器
---@param luaTable table 控件配置表
---@return UIKmlLuaControlHandler
function GUI:ScrollView_Create(parentHandler, luaTable) end

---创建 Slider 控件
---@param parentHandler UIKmlLuaControlHandler 父节点处理器
---@param luaTable table 创建控件所需的数据表格。需要的数据就是kml控件的属性
---@return UIKmlLuaControlHandler
function GUI:Slider_Create(parentHandler, luaTable) end

---创建 TextAtlas 控件
---@param parentHandler UIKmlLuaControlHandler 父节点处理器
---@param luaTable table 创建控件所需的数据表格。需要的数据就是kml控件的属性
---@return UIKmlLuaControlHandler
function GUI:TextAtlas_Create(parentHandler, luaTable) end

---创建 Toggle 控件
---@param parentHandler UIKmlLuaControlHandler 父节点处理器
---@param luaTable table 创建控件所需的数据表格。需要的数据就是kml控件的属性
---@return UIKmlLuaControlHandler
function GUI:Toggle_Create(parentHandler, luaTable) end

---创建 ToggleGroup 控件
---@param parentHandler UIKmlLuaControlHandler 父节点处理器
---@param luaTable table 创建控件所需的数据表格。需要的数据就是kml控件的属性
---@return UIKmlLuaControlHandler
function GUI:ToggleGroup_Create(parentHandler, luaTable) end

---创建 UISysPanel 控件
---@param parentHandler UIKmlLuaControlHandler 父节点处理器
---@param luaTable table 创建控件所需的数据表格。需要的数据就是kml控件的属性
---@return UIKmlLuaControlHandler
function GUI:UISysPanel_Create(parentHandler, luaTable) end

---创建 UISysTemplate 控件
---@param parentHandler UIKmlLuaControlHandler 父节点处理器
---@param luaTable table 创建控件所需的数据表格。需要的数据就是kml控件的属性
---@return UIKmlLuaControlHandler
function GUI:UISysTemplate_Create(parentHandler, luaTable) end

---获取子控件
---@param handler UIKmlLuaControlHandler 父节点处理器
---@param childIndex number 子节点索引
---@param id string 子节点ID
---@param kmlControlHandler UIKmlLuaControlHandler KML控件处理器
---@return UIKmlLuaControlHandler
function this:GetChildControl(handler,childIndex,id,kmlControlHandler) end

---获取 PC 端的界面路径 (如果是 PC 平台且存在 PC 专有界面)
---@param filePath string 原始界面路径
---@return string 转换后的界面路径
function this:GetPath2UI_Pc(filePath) end

---设置 WebGL 常用界面面板
---@param uipath string 界面路径
---@param b boolean 是否常用
function GUI:SetWebGLCommonUsedUIPanel(uipath,b) end

---设置全局刷新 Item 的回调
---@param func function(cfgId:number, luaControl:UIKmlLuaControlHandler, panel:UIKmlLuaPanelBase) 刷新回调函数
function GUI:SetGlobalRefreshItemCallBack(func) end

---设置全局模型回调
---@param onloadCallback function 加载回调 func(luaControl, panel, tagName)
---@param onRecycleCallback function 回收回调 func(luaControl, panel, tagName)
function GUI:SetGlobalModelCallBack(onloadCallback,onRecycleCallback) end

---设置内部 UI 图片
---@param panelName string 面板名称
---@param transformPath string Transform 路径
---@param atlas string 图集路径，如果没有的话src表示的是Texture/路径;
---@param src string 如果atlas有值，表示图片的名字,如果atlas没有值的话src表示的是图片路径
---@param NativeSize boolean 是否使用原始尺寸
---@param x number X 坐标(可选)
---@param y number Y 坐标(可选)
---@param z number Z 坐标(可选)
---@param width number 宽度(可选)
---@param height number 高度(可选)
---@param scale9l number 九宫格左边距
---@param scale9b number 九宫格下边距
---@param scale9r number 九宫格右边距
---@param scale9t number 九宫格上边距
function this:SetInnerUIImage(panelName,transformPath,atlas,src,NativeSize,x,y,z,width,height,scale9l, scale9b, scale9r, scale9t) end

---设置内部 UI 文本
---@param panelName string 面板名称
---@param transformPath string Transform 路径
---@param fontType string 字体类型(可选)
---@param fontSize number 字体大小(可选)
---@param isoutline boolean 是否开启描边(可选)
---@param color Color 颜色(可选)
function this:SetInnerUIText(panelName,transformPath,fontType,fontSize,isoutline,color) end

function this:UIPanel_Open(filePath,parent,baseUI,args,isMulti,callback) end
