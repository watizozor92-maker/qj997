---@class GUI
GUI = {}
local this = GUI
---添加点击事件
---@param handle UIKmlLuaControlHandler 控件处理器
---@param ui any 界面对象,默认self就行
---@param callback function 点击回调
---@param eventData any 传递给回调的数据
---@param clickSoundId number 点击音效ID,不填的话默认id用20019，点击UI时的音效
function this:AddOnClickEvent(handle, ui, callback, eventData,clickSoundId) end

---设置 Toggle 值改变事件
---@param control UIKmlLuaControlHandler 控件处理器
---@param ui any 界面对象(默认self就行)
---@param callback function 值改变回调
---@param eventData any 传递给回调的数据
---@return any
function this:SetToggleOnValueChange(control, ui, callback, eventData) end

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
---@return boolean|Vector2 是否成功|本地坐标
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

--- 设置控件属性。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param attrName string 属性名称。具体可以查看KML说明文档
--- @param attrValue any 属性值。
function this:SetAttr(control,attrName,attrValue) end

--- 获取控件属性字符串。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param attrName string 属性名称。具体可以查看KML说明文档
--- @return string 属性值的字符串形式。字符串，PS:输入框获取的值是当前输入框内的值。并不是Kml里面的值。
function this:GetAttr(control,attrName) end

--- 设置附属控件属性。
--- @param control UIKmlLuaControlHandler 主控件句柄。
--- @param attachId string 附属控件ID。
--- @param attrName string 属性名称。
--- @param attrValue any 属性值。
function this:SetAttachAttr(control,attachId,attrName,attrValue) end

--- 获取附属控件的 RectTransform。
--- @param control UIKmlLuaControlHandler 主控件句柄。
--- @param attachId string 附属控件ID。
--- @return UnityEngine.RectTransform 附属控件的 RectTransform 对象。
function this:GetAttachRectTransform(control,attachId) end

--只能获取通过SetAttachAttr设置过的属性,没有考虑非字符串的情况，暂时不提供
--function this:GetAttachAttr(control,attachId,attrName)
--    control = UIKmlLuaControlGlobalHolder:GetKmlLuaControl(control)
--    if control.kmlControl then
--        local attachKmlControl = control.kmlControl:FindControl(control.kmlControl,attachId)
--        if attachKmlControl then
--            attachKmlControl:GetSingleAttrString(attrName)
--        end
--    end
--end
--region Common
--- 设置控件本地坐标。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param x number X 坐标。
--- @param y number Y 坐标。
function this:setPosition(control, x, y) end

--- 设置控件本地 X 坐标。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param value number X 坐标值。
function this:setPositionX(control, value) end

--- 设置控件本地 Y 坐标。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param value number Y 坐标值。
function this:setPositionY(control, value) end

--- 设置控件本地 Z 坐标。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param value number Z 坐标值。
function this:setPositionZ(control, value) end

--- 获取控件本地坐标。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @return number,number,number 本地坐标的 X, Y, Z 值。
function this:getPosition(control) end

--- 获取控件本地坐标。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @return number,number,number 本地坐标的 X, Y, Z 值。
function this:GetLocalPosition(control) end

--- 设置控件本地坐标。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param x number X 坐标。
--- @param y number Y 坐标。
--- @param z number Z 坐标，默认为 0。
function this:setLocalPosition(control, x, y, z) end

--- 获取控件世界坐标。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @return number,number,number 世界坐标的 X, Y, Z 值。
function this:GetWorldPosition(control) end

--- 设置控件世界坐标。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param x number X 坐标。
--- @param y number Y 坐标。
--- @param z number Z 坐标。
function this:SetWorldPosition(control, x, y, z) end

--- 获取控件本地 X 坐标。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @return number 本地 X 坐标。
function this:getPositionX(control) end

--- 获取控件本地 Y 坐标。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @return number 本地 Y 坐标。
function this:getPositionY(control) end

--- 设置控件锚点。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param x number 水平锚点（0中 1左 2右）。
--- @param y number 垂直锚点（0中 1上 2下）。
function this:setAnchorPoint(control, x, y) end

--- 设置高级锚点。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param x number X 轴锚点位置。
--- @param y number Y 轴锚点位置。
function this:SetAnchorAdvanced(control, x, y) end

--- 获取控件锚点。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @return number,number 水平和垂直锚点值。
function this:getAnchorPoint(control) end

--- 设置控件内容尺寸。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param sizeW number 宽度。
--- @param sizeH number 高度。
function this:setContentSize(control, sizeW, sizeH) end

--- 获取控件尺寸偏差（sizeDelta）。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @return number,number 宽度和高度偏差。
function this:getSizeDelta(control) end

--- 获取控件包围盒尺寸（相对于主画布）。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @return number,number 宽度和高度。
function this:getBoundingBox(control) end

--- 设置控件的 Tag。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param tag string 标签字符串。
function this:setTag(control, tag) end

--- 获取控件的 Tag。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @return string 标签字符串。
function this:getTag(control) end

--- 设置控件的名称。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param name string 名称字符串。
function this:setName(control, name) end

--- 获取控件的名称。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @return string 名称字符串。
function this:getName(control) end

--- 设置控件是否灰态显示。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param grey boolean 是否灰态。
function this:setGrey(control, grey) end

--- 设置控件旋转角度（Z 轴）。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param rotation number 旋转角度值。
function this:setRotation(control, rotation) end

--- 获取控件旋转角度（Z 轴）。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @return number 旋转角度值。
function this:getRotation(control) end

--- 设置控件全轴旋转。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param rotation Vector3 旋转欧拉角。
function this:setAllRotation(control, rotation) end

--- 获取控件全轴旋转。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @return UnityEngine.Vector3 旋转欧拉角对象。
function this:getAllRotation(control) end

--- 设置控件本地 X 轴旋转偏斜。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param rotation number 旋转角度。
function this:setRotationSkewX(control, rotation) end

--- 设置控件本地 Y 轴旋转偏斜。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param rotation number 旋转角度。
function this:setRotationSkewY(control, rotation) end

--- 获取本地欧拉角。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @return number,number,number X, Y, Z 轴欧拉角。
function this:GetLocalEulerAngles(control) end

--- 设置本地欧拉角。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param x number X 轴旋转。
--- @param y number Y 轴旋转。
--- @param z number Z 轴旋转。
function this:SetLocalEulerAngles(control,x,y,z) end

--- 获取世界欧拉角。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @return number,number,number X, Y, Z 轴欧拉角。
function this:GetEulerAngles(control) end

--- 设置世界欧拉角。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param x number X 轴旋转。
--- @param y number Y 轴旋转。
--- @param z number Z 轴旋转。
function this:SetEulerAngles(control,x,y,z) end

--- 设置控件是否可见。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param visible boolean 是否可见（默认 false）。
function this:setVisible(control, visible) end

--- 获取控件是否可见（activeSelf）。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @return boolean 是否可见。
function this:getVisible(control) end

--- 设置控件 CanvasGroup 透明度。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param alpha number 透明度（0-1）。
function this:setAlpha(control, alpha) end

--- 获取控件 CanvasGroup 透明度。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @return number 透明度值（默认 1）。
function this:getAlpha(control) end

--- 设置控件本地缩放。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param scale number 缩放比例。
function this:setScale(control, scale) end

--- 获取控件本地缩放。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @return number,number,number 本地缩放的 X, Y, Z 值。
function this:getScale(control) end

--- 设置控件本地 X 轴缩放。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param scale number 缩放比例。
function this:setScaleX(control, scale) end

--- 获取控件本地 X 轴缩放。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @return number 本地 X 轴缩放值。
function this:getScaleX(control) end

--- 设置控件本地 Y 轴缩放。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param scale number 缩放比例。
function this:setScaleY(control, scale) end

--- 获取控件本地 Y 轴缩放。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @return number 本地 Y 轴缩放值。
function this:getScaleY(control) end

--- 设置控件水平翻转。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param value boolean 是否翻转。
function this:setFlippedX(control, value) end

--- 获取控件是否水平翻转。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @return boolean 是否已翻转。
function this:getFlippedX(control) end

--- 设置控件垂直翻转。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param value boolean 是否翻转。
function this:setFlippedY(control, value) end

--- 获取控件是否垂直翻转。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @return boolean 是否已翻转。
function this:getFlippedY(control) end

--- 设置控件层级顺序（SiblingIndex）。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param value number 层级索引。
function this:setLocalZOrder(control, value) end

--- 获取 3D 锚点位置。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @return UnityEngine.Vector3 3D 锚点位置坐标。
function this:GetAnchoredPosition3D(control) end

--- 获取锚点位置（anchoredPosition）。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @return UnityEngine.Vector2 锚点位置坐标。
function this:GetAnchoredPosition(control) end

--- 设置锚点位置（anchoredPosition）。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param pos Vector2 锚点坐标。
function this:SetAnchoredPosition(control,pos) end

---设置控件是否启用点击/交互
---@param control UIKmlLuaControlHandler 控件句柄
---@param value boolean 是否启用
function this:setTouchEnabled(control, value) end

---获取控件是否启用点击/交互
---@param control UIKmlLuaControlHandler 控件句柄
---@return boolean 是否启用
function this:getTouchEnabled(control) end

--- 延迟启用控件点击。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param delay number 延迟时间（秒）。
--- @return number Timer 对象 ID。
function this:delayTouchEnabled(control, delay) end

--- 设置控件是否吞噬触摸事件。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param value boolean 是否吞噬。
function this:setSwallowTouches(control, value) end

--- 获取控件是否吞噬触摸事件。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @return boolean 是否吞噬。
function this:getSwallowTouches(control) end

--- 设置控件射线检测目标状态。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param value boolean 是否作为射线检测目标。true为不可点击；false为可点击
function this:SetRaycastTarget(control, value) end

--- 获取控件射线检测目标状态。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @return boolean 是否作为射线检测目标。true表示不可点击，false表示可点击
function this:GetRaycastTarget(control) end

--- 设置对象隐藏显示（带旋转动画激活属性）。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param isActive boolean 是否激活。
function GUI:SetActive(control, isActive) end

--region Image
--- 加载纹理图片。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param src string 图片资源路径。
--- @param atlas string 图集路径。
function GUI:Image_loadTexture(control, src, atlas) end

--- 设置图片是否为圆形类型。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param isCircle boolean 是否为圆形。
function this:Image_SetCircleType(control, isCircle) end

--- 设置图片纹理对象。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param tex UnityEngine.Texture 纹理对象。
function GUI:Image_SetTexture(control, tex) end

--- 获取纹理的宽高。
--- @param tex UnityEngine.Texture 纹理对象。
--- @return number,number 宽度和高度（如果纹理为空则返回 0,0）。
function GUI:Image_GetTextureWidthAndHeight(tex) end

--- 设置图片填充值。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param fillAmount number 填充比例（0-1）。
function this:Image_setFillAmount(control,fillAmount) end

--- 设置图片九宫格切分。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param scale9l number 距离左边的像素值。
--- @param scale9r number 距离右边的像素值。
--- @param scale9t number 距离上边的像素值。
--- @param scale9b number 距离下边的像素值。
function GUI:Image_setScale9Slice(control, scale9l, scale9r, scale9t, scale9b) end

--- 设置图片是否变灰。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param isGrey boolean 是否变灰。
function GUI:Image_setGrey(control, isGrey) end

--- 设置图片透明度。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param value number 透明度值（0-1）。
function GUI:Image_setAlpha(control, value) end

--- 设置图片类型及填充属性。
--- @param handle UIKmlLuaControlHandler 控件句柄。
--- @param type number 图片类型。
--- @param fillMethod EImageFillMethod 填充方法（默认 Radial360）。
--- @param fillOrigin number 填充起点（默认 2）。
--- @param fillClockwise boolean 是否顺时针（默认 true）。
function this:Image_setType(handle,type,fillMethod,fillOrigin,fillClockwise) end

--- 切换是否绘制矩形。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param isEnabled boolean 是否启用绘制。
function this:Image_SwitchDrawRect(control,isEnabled) end

--- 设置绘制矩形的顶点。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param vertexes table 顶点数据列表。
function this:Image_SetVertexes2DrawRect(control,vertexes) end

--region Button
--- 加载按钮多种状态的纹理。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param Normalfilepath string 正常状态图片路径。
--- @param Pressedfilepath string 按下状态图片路径（可选）。
--- @param Disabledfilepath string 禁用状态图片路径（可选）。
--- @param atlas string 图集路径。
--- @param highlightedfilePath string 高亮状态图片路径（可选）。
function GUI:Button_loadTextures(control, Normalfilepath, Pressedfilepath, Disabledfilepath, atlas,highlightedfilePath) end

--- 设置控件颜色（通用）。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param color string 颜色字符串（如 "#FFFFFF"）。
function GUI:setColor(control,color) end

--- 设置按钮正常状态纹理。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param Normalfilepath string 图片路径。
--- @param atlas string 图集路径。
function GUI:Button_loadTextureNormal(control, Normalfilepath, atlas) end

--- 设置按钮按下状态纹理。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param Pressedfilepath string 图片路径。
--- @param atlas string 图集路径。
function GUI:Button_loadTexturePressed(control, Pressedfilepath, atlas) end

--- 设置按钮高亮状态纹理。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param highlightedPath string 悬浮图片名;。
--- @param atlas string 悬浮图片图集名。
function GUI:Button_loadTextureHighlighted(control, highlightedPath, atlas) end

--- 设置按钮禁用状态纹理。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param Disabledfilepath string 图片路径。
--- @param atlas string 图集路径。
function GUI:Button_loadTextureDisabled(control, Disabledfilepath, atlas) end

--- 设置按钮标题文字。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param value string 文字内容。
function GUI:Button_setTitleText(control, value) end

--- 获取按钮标题文字。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @return string 文字内容。
function GUI:Button_getTitleText(control) end

--- 设置按钮标题颜色。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param color string 颜色字符串。
function GUI:Button_setTitleColor(control, color) end

--- 设置按钮标题字体大小。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param value number 字体大小。
function GUI:Button_setTitleFontSize(control, value) end

--- 设置按钮标题字体。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param fonttype string 字体名称/路径。如果使用引擎内置的字体，填“MSYH”（微软雅黑）或者其他内置字体名称(不通用，可忽略)，如果外部自定义字体，填字体的相对路径，“Font/xxx.xxx”。
function GUI:Button_setTitleFontName(control, fonttype) end

--- 设置按钮标题文本最大行宽。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param value number 最大宽度值。
function GUI:Button_setMaxLineWidth(control, value) end

--- 设置按钮标题描边效果。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param color string 描边颜色。
--- @param outline number 描边粗细。
function GUI:Button_titleEnableOutline(control, color, outline) end

--- 禁用按钮标题描边效果。
--- @param control UIKmlLuaControlHandler 控件句柄。
function GUI:Button_titleDisableOutLine(control) end

--- 设置按钮是否高亮/可点击。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param value boolean 是否启用。false：设置为禁用；true：设置为不禁用
function GUI:Button_setBright(control, value) end

--- 设置按钮是否变灰。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param isGrey boolean 是否变灰。true：置灰；false：不置灰
function GUI:Button_setGrey(control, isGrey) end

--- 设置按钮九宫格切分。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param scale9l number 距离左边的像素值。
--- @param scale9r number 距离右边的像素值。
--- @param scale9t number 距离上边的像素值。
--- @param scale9b number 距离下边的像素值。
function GUI:Button_setScale9Slice(control, scale9l, scale9r, scale9t, scale9b) end

--- 设置控件颜色 RGBA（0-1 范围）。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param r number 红色分量。取值范围0-1
--- @param g number 绿色分量。取值范围0-1
--- @param b number 蓝色分量。取值范围0-1
--- @param a number 透明度分量。取值范围0-1
function this:SetImageAlpha(control, r, g, b, a) end

--- 设置 GridLayoutGroup 控件的子物体对齐方式。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param cellAlign string 对齐方式名称。00：MiddleCenter；01：UpperCenter；02：LowerCenter；10：MiddleLeft；11:UpperLeft;12:LowerLeft;20:MiddleRight;21:UpperRight;22:LowerRight;默认：MiddleCenter
function this:SetGridLayoutGroupChildAlignment(control, cellAlign) end

--- 设置图片为原始尺寸。
--- @param control UIKmlLuaControlHandler 控件句柄。
function this:SetImageNativeSize(control) end

--- 设置输入控件的文本内容。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param str string 文本内容。
function this:SetInputText(control, str) end

--- 获取输入控件的文本内容。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @return string 文本内容。
function this:GetInputText(control) end

--- 设置输入控件是否启用。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param value boolean 是否启用。
function this:SetInputEnable(control, value) end

--region Text
--- 设置文本内容。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param value string 文本内容。
function GUI:Text_setString(control, value) end

--- 获取文本内容。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @return string 文本内容。
function GUI:Text_getString(control) end

--- 设置文本颜色。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param color string 颜色字符串。
function GUI:Text_setTextColor(control, color) end

--- 设置文本内容（与 Text_setString 功能相同）。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param str string 文本内容。
function GUI:Text_setText(control, str) end

--- 设置文本透明度。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param alpha number 透明度值（0-1）。
function GUI:Text_setTextColorAlpha(control, alpha) end

--- 设置文本字体大小。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param value number 字体大小。
function GUI:Text_setFontSize(control, value) end

--- 设置文本字体名称/类型。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param fonttype string 字体路径。如果使用引擎内置的字体，填“MSYH”（微软雅黑）或者其他内置字体名称(不通用，可忽略)，如果外部自定义字体，填字体的相对路径，“Font/xxx.xxx”。
function GUI:Text_setFontName(control, fonttype) end

--- 启用文本描边效果。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param color string 描边颜色。
--- @param outline number 描边粗细。
function GUI:Text_enableOutline(control, color, outline) end

--- 启用文本下划线。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param underLineType number 下划线类型（1在底部2在中间,0表示取消下划线,默认 0）。
--- @param color string 下划线颜色（可选）。
function GUI:Text_enableUnderline(control, underLineType,color) end

--- 设置文本最大行宽。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param value number 最大宽度。
function GUI:Text_setMaxLineWidth(control, value) end

--- 禁用文本描边效果。
--- @param control UIKmlLuaControlHandler 控件句柄。
function GUI:Text_disableOutLine(control) end

--- 设置文本对齐方式。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param value string 对齐方式字符串。两位数-第一位 0(左对齐),1(左右居中),2(右对齐)-第二位:0(上对齐),1(上下居中),2(下对齐)
function GUI:Text_setTextAlignment(control, value) end

--- 设置文本显示区域尺寸。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param value table 尺寸表 {width = number, height = number}。
function GUI:Text_setTextAreaSize(control, value) end

--- 设置文本水平溢出模式。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param value string 溢出模式字符串。
function GUI:Text_sethorwrap(control, value) end

--- 设置文本是否多行显示/自动换行。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param value string 是否多行（"1" 或 "0"）。
function GUI:Text_setmline(control, value) end

--- 设置富文本中的道具/装备信息。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param value string 道具信息字符串。
function GUI:RichText_setchatiteminfo(control, value) end

--region TextAtlas
--- 设置艺术字属性。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param stringValue string 数字文本。
--- @param charMapFile string 相当于kml属性src。
--- @param itemWidth number 单个字符宽度。
--- @param itemHeight number 单个字符高度。
--- @param atlas string 图集路径。atlas和src的规则遵循kml属性文档
function GUI:TextAtlas_setProperty(control, stringValue, charMapFile, itemWidth, itemHeight,atlas) end

--- 设置艺术字文字内容。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param stringValue string 文字内容。
function GUI:TextAtlas_setString(control, stringValue) end

--- 获取艺术字文字内容。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @return string 文字内容。
function GUI:TextAtlas_getString(control) end

--region Slider
--- 设置滑动条背景图片。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param src string 图片路径。
--- @param atlas string 图集路径。
function GUI:Slider_loadBarTexture(control, src, atlas) end

--- 设置滑动条进度图片。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param src string 图片路径。
--- @param atlas string 图集路径。
function GUI:Slider_loadProgressBarTexture(control, src, atlas) end

--- 设置滑动条滑块正常状态图片。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param src string 图片路径。
--- @param atlas string 图集路径。
function GUI:Slider_loadSlidBallTextureNormal(control, src, atlas) end

--- 设置滑动条当前进度百分比。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param value number 进度值（0-100 或根据范围决定）。
function GUI:Slider_setPercent(control, value) end

--- 获取滑动条当前进度百分比。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @return number 当前进度值。
function GUI:Slider_getPercent(control) end

--- 设置滑动条最大进度值。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param value number 最大进度值。
function GUI:Slider_setMaxPercent(control, value) end

--- 设置滑动条最小进度值。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param value number 最小进度值。
function GUI:Slider_setMinPercent(control, value) end

--- 为滑动条添加数值改变事件回调。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param ui UIKmlLuaPanelBase 面板对象。
--- @param callback function 回调函数。
--- @param eventData any 事件自定义数据。
function GUI:Slider_addOnEvent(control, ui, callback, eventData) end

--- 设置道具/物品 ID。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param itemId number|string 道具配置 ID。
function GUI:Item_setItemId(control, itemId) end

--- 设置道具/物品数量。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param itemCount string|number 道具数量。
function GUI:Item_setItemCount(control, itemCount) end

--- 批量更新道具数据。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param luaTable table 属性键值对表。
function GUI:Item_UpdataData(control, luaTable) end

--- 设置道具旋转（不建议使用，优先使用 RotateAni）。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param rotate string 旋转值。
function GUI:Item_Rotate(control, rotate) end

--- 设置道具旋转动画。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param rotate string 旋转参数。逗号隔开，不填相当于停止播放旋转;
---rotate元素：isRotationAxis，speed，typeRotation
---isRotationAxis：0 绕x轴,1:绕y轴,2:绕z轴旋转,3 绕世界坐标x轴,4:绕世界坐标y轴,5:绕世界坐标z轴旋转
---speed：旋转速度
---typeRotation：0或者1
---0：绕世界坐标旋转
---1：绕自己旋转
function GUI:RotateAni(control, rotate) end

--- 设置道具缩放。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param scale number 缩放比例。
function GUI:Item_Scale(control, scale) end

--- 设置模型资源及参数。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param src string 模型路径。
--- @param scale string 缩放值。
--- @param rotate string 旋转值。
--- @param pos string 位置偏移。
--- @param mfixsize string 固定尺寸参数。
--- @param atlas string 图集路径（如果使用 2D 图片）。
function GUI:Model_setSrc(control, src, scale, rotate, pos,mfixsize,atlas) end

--- 设置模型通用参数。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param scale string 缩放值（不填则不设置）。
--- @param rotate string 旋转值（不填则不设置）。
--- @param pos string 位置偏移（不填则不设置）。
--- @param mfixsize string 固定尺寸参数（不填则不设置）。
function GUI:Model_setParam(control, scale, rotate, pos,mfixsize) end

--- 设置模型是否启用裁剪。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param value number 是否裁剪（"1" 或 "0"）。
function GUI:Model_setnoclip(control, value) end

--- 设置模型材质参数。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param path string 模型资源的相对路径，可以用层级面板查看。
--- @param matIndex number 材质索引（从 0 开始）。
--- @param propType number 属性类型1-float,2-vector4 设置texture的offset和scale,3-color,4-vector4，普通Vector4对象
--- @param propName string :属性名称，通过Shader脚本上面的属性名称获得。
--- @param propValue any 属性值。
function GUI:Model_setMatParam(control,path,  matIndex,  propType, propName, propValue) end

--- 设置模型多材质资源。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param pathList string[] 作用物体路径，模型资源的相对路径
--- @param pathMatList table[][] 材质的资源路径，pathList里面的每个对应pathMatList里面一个table，一个物体可能会有多个材质。
function GUI:Model_setMaterials(control,pathList,pathMatList) end

---@param control UIKmlLuaControlHandler mdoel,effect,item组件适用
---@return boolean 是否正在加载中
function GUI:Model_IsLoading(control) end

--- 设置 Toggle 图片。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param atlas string 图集路径。
--- @param src string 正常状态图片路径。
--- @param pimg string 选中状态图片路径。
function GUI:Toggle_setSrc(control, atlas, src, pimg) end

--- 设置 Toggle 是否选中。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param isOn boolean 是否选中。
function this:Toggle_setIsOn(control, isOn) end

--- 获取 Toggle 是否选中。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @return number 选中状态（未选中状态）或"1"(选中状态)
function this:Toggle_getIsOn(control) end

--- 设置 ToggleGroup 是否允许全部取消选中。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param isAllow boolean 是否允许取消, 。
function this:ToggleGroup_AllowSwitChoff(control,isAllow) end

--region loadingbar
--- 设置加载条/进度条初始百分比。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param stringValue number 百分比值。
function GUI:SetLoadingbar_startper(control, stringValue) end

--- 设置倒计时/计时器时间。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param stringValue number 时间值（秒）。
--- @param timeEndCallback function 结束回调。
function GUI:SetControl_time(control, stringValue,timeEndCallback) end

--- 设置控件移动至目标位置。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param stringValue string 目标位置坐标字符串。
function GUI:SetControl_moveto(control, stringValue) end

--- 设置圆形进度条初始百分比。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param stringValue number 百分比值。0-100
function GUI:SetCirclebar_startper(control, stringValue) end

--- 设置圆形进度条结束百分比。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param stringValue number 百分比值。0-100
function GUI:SetCirclebar_endper(control, stringValue) end

--- 设置圆形进度条变化时间。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param stringValue number 时间值（秒）。
function GUI:SetCirclebar_time(control, stringValue) end

--- 设置滑动区域滚动位置。
--- @param control UIKmlLuaControlHandler @控件句柄。
--- @param stringValue number @滚动位置值（0-1）。如果是scrollview控件，0-1；如果是loopscrollview控件，表示的是要滚动条第几个item（是个整数值）
function GUI:SetScrollView_scrollpos(control, stringValue) end

--region inputfield
--- 设置输入框数值改变回调。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param ui UIKmlLuaPanelBase 面板对象。
--- @param callback function 回调函数。
--- @param eventData any 事件自定义数据。
function this:Input_SetOnValueChange(control, ui, callback, eventData) end

--- 设置输入框结束编辑回调。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param ui UIKmlLuaPanelBase 面板对象。
--- @param callback function 回调函数。
--- @param eventData any 事件自定义数据。
function this:Input_SetOnEndEdit(control, ui, callback, eventData) end

--- 设置输入框内容类型。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param type number 内容类型。0：没有限制；1：自动纠错；2：只允许输入整数；3：允许输入小数；4：只能输入字母和数字；5：名字，首字母自动大写；6：邮箱格式的输入；7：密码（输入内容自动隐藏）；8：Pin码输入，只允许输入数字；9：自定义输入规则
function this:Input_SetContentType(control, type) end

--- 设置输入框最大字符数（已废弃，建议用 Input_SetMaxTextCount）。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param maxCount number 最大字符数。
function this:SetMaxTextCount(control, maxCount) end

--- 设置输入框最大字符数。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param maxCount number 最大字符数。
function this:Input_SetMaxTextCount(control, maxCount) end

--- 获取控件所在的最近的 Canvas 层级。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @return number sortingOrder 层级值（未找到则返回 -1），相当于kml属性zindex。数字(排序层级)，数字越大越显示在上面。
function this:GetNearCanvasZindex(control) end

--- 设置 Toggle 是否选中（不触发事件通知）。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param isOn boolean 是否选中。
function GUI:SetIsOnWithoutNotify(control, isOn) end

--- 设置玩家角色显示信息。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param model_list string 模型列表。
--- @param equip_list string 装备列表。
--- @param ani string 动画名称（可选）。
function GUI:SetPlayerRoleInfo(control, model_list, equip_list,ani) end

--- 设置玩家角色动画动作。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param ani string 动画名称。
function GUI:SetPlayerRoleAni(control, ani) end

--- 设置界面模型流光
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param strameCfgId number 配置 ID。
function GUI:SetStreamAttr(control, strameCfgId) end

--- 重置流属性配置。
--- @param control UIKmlLuaControlHandler 控件句柄。
function GUI:ResetStreamAttr(control) end

--- 设置控件动画停止状态。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param isStop boolean 是否停止。
function GUI:SetControlAnimation_stop(control, isStop) end

--- 获取控件内部 ID。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @return string 控件 ID。
function GUI:GetID(control) end

--- 获取控件全局唯一标识 UUID。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @return string UUID。
function GUI:GetUUID(control) end

--- 设置控件内部 ID。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param id string 控件 ID。
function GUI:SetID(control, id) end

--- 获取下拉列表当前选中的数值。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @return number 选中的索引或值。
function GUI:GetDropDownValue(control) end

--- 获取控件属性中记录的宽度。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @return number 宽度。
function GUI:GetControlWidth(control) end

--- 获取控件属性中记录的高度。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @return number 高度。
function GUI:GetControlHeight(control) end

--- 初始化 OSA 滑动区域。
--- @param handler UIKmlLuaControlHandler 控件句柄。
--- @param itemGetFun function 获取列表项的回调。
--- @param itemUpdateFun function 更新列表项的回调。
--- @param ui UIKmlLuaPanelBase 面板对象。
function this:OSAScrollView_Initialized(handler,itemGetFun,itemUpdateFun,ui) end

--- 刷新 OSA 列表数据量。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param count number 列表项总数。
function this:OSAScrollView_RefreshList(control,count) end

--- 设置 OSA 列表项尺寸获取回调。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param itemSizeGetFun function 获取尺寸的回调。
--- @param ui UIKmlLuaPanelBase 面板对象。
function this:OSAScrollView_SetItemSizeGetFun(control,itemSizeGetFun,ui) end

--- 滚动 OSA 列表到指定项。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param index number 要滚动到的索引。
--- @param duration number 滚动耗时（秒，默认 0,选填）。
--- @param normalizedOffsetFromViewportStart number 列表项偏移（范围0-1）（默认 0，选填）。
--- @param normalizedPositionOfItemPivotToUse number 列表项偏移所用锚点（范围0-1）（默认 0，选填）。
function this:OSAScrollView_ScrollTo(control,index,duration,normalizedOffsetFromViewportStart,normalizedPositionOfItemPivotToUse) end

--- 获取 OSA 列表所有当前显示的项。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @return table 列表项集合。
function this:OSAScrollView_GetAllItems(control) end

--- 设置 OSA 列表是否可滚动。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param scrollable boolean 是否可滚动。
function this:OSAScrollView_SetScrollable(control,scrollable) end

--- 获取文本的最佳宽度和高度（Preferred Width/Height）。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @return number,number 最佳宽度和最佳高度。
function GUI:GetTextPreferredWH(control) end

--- 设置 RectTransform 的最小偏移（offsetMin）。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param x number|string X 轴偏移（传 '-' 表示保持原值）。
--- @param y number|string Y 轴偏移（传 '-' 表示保持原值）。
function GUI:SetOffsetMin(control,x,y) end

--- 获取 RectTransform 的最小偏移（offsetMin）。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @return number,number X 和 Y 轴偏移值。
function this:GetOffsetMin(control) end

--- 设置 RectTransform 的最大偏移（offsetMax）。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param x number|string X 轴偏移（传 '-' 表示保持原值）。
--- @param y number|string Y 轴偏移（传 '-' 表示保持原值）。
function GUI:SetOffsetMax(control,x,y) end

--- 获取 RectTransform 的最大偏移（offsetMax）。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @return number,number X 和 Y 轴偏移值。
function this:GetOffsetMax(control) end

--- 设置滑动区域的矩形遮罩数据。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param x number 遮罩位置 X。
--- @param y number 遮罩位置 Y。
--- @param width number 遮罩宽度。
--- @param height number 遮罩高度。
function GUI:SetScrollViewRectMaskData(control,x,y, width, height) end

--- 设置滑动区域列表项的默认尺寸。gridview,loopscrollview控件适用
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param width number 列表项宽度。
--- @param height number 列表项高度。
function GUI:SetScrollView_DefaultItemSize(control,width,height) end

--- 用来一个滚动条滚动的时候带动另外一个滚动条一起滚动，例如背包界面的道具和背景使用了另个滚动条
--- @param isSetOrRest number 设置或重置（1/0）。
--- @param uipanelid number 面板 ID。
--- @param uuid number 唯一标识。
--- @param scrollControlId number 主滑动控件 ID。
--- @param secuipanelid number 次级面板 ID。
--- @param secuuid number 次级面板唯一标识。
--- @param secscrollControlId number 次级滑动控件 ID。
function GUI:SetSecScrollView(isSetOrRest, uipanelid, uuid, scrollControlId, secuipanelid, secuuid,secscrollControlId) end

--- 为控件添加遮罩组件。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @return UnityEngine.UI.Mask 遮罩组件实例。
function GUI:AddMask(control) end

--- 移除控件的遮罩组件。
--- @param control UIKmlLuaControlHandler 控件句柄。
function GUI:RemoveMask(control) end

--- 为控件添加空的射线检测组件（UIEmpty4Raycast）。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @return UnityEngine.UI.UIEmpty4Raycast 组件实例。
function GUI:AddUIEmpty4Raycast(control) end

--- 强制立即重新构建布局。
--- @param control UIKmlLuaControlHandler 控件句柄。
function GUI:ForceRebuildLayoutImmediate(control) end

--- 设置特效 ID。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param id number 特效配置 ID。
function GUI:Effect_setEffectId(control, id) end

--- 设置特效是否循环播放。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param looping boolean 是否循环。
function this:Effect_setLooping(control,looping) end

--- 设置视频播放资源及参数。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param resPath string 视频资源路径。
--- @param vwidth number 视频宽度。
--- @param vheight number 视频高度。
--- @param playonwake string 是否唤醒时播放（"1"/"0"）。
--- @param loop string 是否循环（"1"/"0"）。
function GUI:SetVideo(control, resPath,vwidth,vheight,playonwake,loop) end

--- 设置视频显示尺寸。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param vwidth number 宽度。
--- @param vheight number 高度。
function GUI:SetVideoSize(control, vwidth, vheight) end

--- 播放视频。
--- @param control UIKmlLuaControlHandler 控件句柄。
function GUI:PlayVideo(control) end

--- 停止视频。
--- @param control UIKmlLuaControlHandler 控件句柄。
function GUI:StopVideo(control) end

--- 将控件设置为同级节点中的第一个（最底层）。
--- @param control UIKmlLuaControlHandler 控件句柄。
function this:SetAsFirstSibling(control) end

--- 将控件设置为同级节点中的最后一个（最顶层）。
--- @param control UIKmlLuaControlHandler 控件句柄。
function this:SetAsLastSibling(control) end

--- 设置 Toggle 默认为选中状态。
--- @param control UIKmlLuaControlHandler 控件句柄。
function this:SetTogDefaultThis(control) end

--- 获取 RectTransform 的矩形尺寸。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @return UnityEngine.Vector2 尺寸坐标。
function this:GetRectSize(control) end

--- 获取控件的宽度。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @return number 宽度值。
function this:GetWidth(control) end

--- 获取控件的高度。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @return number 高度值。
function this:GetHeight(control) end

--- 获取控件对应的 GameObject。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @return UnityEngine.GameObject 对象实例。
function this:GetGameObject(control) end

--- 隐藏控件的所有子物体。
--- @param control UIKmlLuaControlHandler 控件句柄。
function this:HideAllChilds(control) end

--- 设置富文本中的玩家 ID 信息。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param value string 玩家 ID 字符串。
function GUI:RichText_setchatplayerid(control, value) end

--- 图片颜色淡入淡出动画（循环）。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param fadeinTime number 淡入时间。
--- @param keepTime number 保持时间。
--- @param fadeoutTime number 淡出时间。
--- @param onComplateFunc function 完成回调。
--- @return LTSeq 动画序列对象。
function this:Image_DoColorFadeInKeepOut(control,fadeinTime,keepTime,fadeoutTime,onComplateFunc) end

--- 停止图片颜色淡入淡出动画。
--- @param sequence LTSeq 动画序列对象(Image_DoColorFadeInKeepOut的返回值)。
function this:Image_StopColorFadeInKeepOut(sequence) end

--- 设置控件锚点坐标缓动动画。
--- @param control UIKmlLuaControlHandler|UnityEngine.Transform|UnityEngine.RectTransform 目标控件。
--- @param targetVec2 Vector2 目标坐标（本地）。
--- @param time number 缓动时间（秒）。
--- @return table tween对象，可以作为其他tween接口的传入参数
function this:DOAnchorPos(control,targetVec2,time) end

--- 设置控件世界坐标移动动画。
--- @param control UIKmlLuaControlHandler|UnityEngine.Transform|UnityEngine.RectTransform 目标控件。
--- @param targetVec3 Vector3 目标坐标（世界）。
--- @param time number 缓动时间（秒）。
--- @return table tween对象，可以作为其他tween接口的传入参数
function this:DOMove(control,targetVec3,time) end

--- 设置控件世界坐标 X 轴移动动画。
--- @param control UIKmlLuaControlHandler|UnityEngine.Transform|UnityEngine.RectTransform 目标控件。
--- @param targetX number 目标 X 轴坐标（世界）。
--- @param time number 缓动时间（秒）。
--- @return table tween对象，可以作为其他tween接口的传入参数
function this:DOMoveX(control,targetX,time) end

--- 设置控件世界坐标 Y 轴移动动画。
--- @param control UIKmlLuaControlHandler|UnityEngine.Transform|UnityEngine.RectTransform 目标控件。
--- @param targetY number 目标 Y 轴坐标（世界）。
--- @param time number 缓动时间（秒）。
--- @return table tween对象，可以作为其他tween接口的传入参数
function this:DOMoveY(control,targetY,time) end

--- 设置控件世界坐标 Z 轴移动动画。
--- @param control UIKmlLuaControlHandler|UnityEngine.Transform|UnityEngine.RectTransform 目标控件。
--- @param targetZ number 目标 Z 轴坐标（世界）。
--- @param time number 缓动时间（秒）。
--- @return table tween对象，可以作为其他tween接口的传入参数
function this:DOMoveZ(control, targetZ, time) end

--- 设置控件本地坐标移动动画。
--- @param control UIKmlLuaControlHandler|UnityEngine.Transform|UnityEngine.RectTransform 目标控件。
--- @param targetVec3 Vector3 目标坐标（本地）。
--- @param time number 缓动时间（秒）。
--- @return table tween对象，可以作为其他tween接口的传入参数
function this:DOMoveLocal(control,targetVec3,time) end

--- 设置控件本地坐标 X 轴移动动画。
--- @param control UIKmlLuaControlHandler|UnityEngine.Transform|UnityEngine.RectTransform 目标控件。
--- @param targetX number 目标 X 轴坐标（本地）。
--- @param time number 缓动时间（秒）。
--- @return table tween对象，可以作为其他tween接口的传入参数
function this:DOMoveLocalX(control, targetX, time) end

--- 设置控件本地坐标 Y 轴移动动画。
--- @param control UIKmlLuaControlHandler|UnityEngine.Transform|UnityEngine.RectTransform 目标控件。
--- @param targetY number 目标 Y 轴坐标（本地）。
--- @param time number 缓动时间（秒）。
--- @return table tween对象，可以作为其他tween接口的传入参数
function this:DOMoveLocalY(control, targetY, time) end

--- 设置控件本地坐标 Z 轴移动动画。
--- @param control UIKmlLuaControlHandler|UnityEngine.Transform|UnityEngine.RectTransform 目标控件。
--- @param targetZ number 目标 Z 轴坐标（本地）。
--- @param time number 缓动时间（秒）。
--- @return table tween对象，可以作为其他tween接口的传入参数
function this:DOMoveLocalZ(control, targetZ, time) end

--- 设置控件锚点坐标 X 轴移动动画。
--- @param control UIKmlLuaControlHandler|UnityEngine.Transform|UnityEngine.RectTransform 目标控件。
--- @param targetX number 目标 X 轴坐标（本地）。
--- @param time number 缓动时间（秒）。
--- @return table tween对象，可以作为其他tween接口的传入参数
function this:DOAnchorPosX(control,targetX,time) end

--- 设置控件锚点坐标 Y 轴移动动画。
--- @param control UIKmlLuaControlHandler|UnityEngine.Transform|UnityEngine.RectTransform 目标控件。
--- @param targetY number 目标 Y 轴坐标（本地）。
--- @param time number 缓动时间（秒）。
--- @return table tween对象，可以作为其他tween接口的传入参数
function this:DOAnchorPosY(control, targetY, time) end

--- 设置控件旋转动画。
--- @param control UIKmlLuaControlHandler|UnityEngine.Transform|UnityEngine.RectTransform 目标控件。
--- @param targetVec3 Vector3 目标旋转欧拉角。
--- @param time number 缓动时间（秒）。
--- @param leanRotateType ELeanRotateType 旋转类型（默认 CanBeyond360）。
--- @return table tween对象，可以作为其他tween接口的传入参数
function this:DORotate(control, targetVec3, time,leanRotateType) end

--- 设置控件环绕旋转动画。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param axis Vector3 旋转轴。
--- @param add number 旋转增量。
--- @param time number 缓动时间（秒）。
--- @param leanRotateRoundType ELeanRotateRoundType 环绕旋转类型（默认 RotateAroundLocal）。
--- @return table tween对象，可以作为其他tween接口的传入参数
function this:DORotateRound(control, axis,add, time,leanRotateRoundType) end

--- 设置控件缩放动画。
--- @param control UIKmlLuaControlHandler|UnityEngine.Transform|UnityEngine.RectTransform 目标控件。
--- @param targetVec3 Vector3 目标缩放比例。
--- @param time number 缓动时间（秒）。
--- @return table tween对象，可以作为其他tween接口的传入参数
function this:DOScale(control, targetVec3, time) end

--- 设置控件 CanvasGroup 透明度动画。
--- @param control UIKmlLuaControlHandler|UnityEngine.RectTransform 目标控件。
--- @param to number 目标透明度（0-1）。
--- @param time number 缓动时间（秒）。
--- @param isRecursive boolean 是否递归应用到子物体（默认 true）。
--- @param from number 初始透明度（可选）。
--- @return table tween对象，可以作为其他tween接口的传入参数
function this:DOAlphaCanvasGroup(control, to, time, isRecursive,from) end

--- 设置控件 Image 透明度动画。
--- @param control UIKmlLuaControlHandler|UnityEngine.RectTransform 目标控件。
--- @param to number 目标透明度（0-1）。
--- @param time number 缓动时间（秒）。
--- @param isRecursive boolean 是否递归应用到子物体（默认 true）。
--- @return table tween对象，可以作为其他tween接口的传入参数
function this:DOAlphaImage(control, to, time, isRecursive) end

--- 设置控件 Text 透明度动画。
--- @param control UIKmlLuaControlHandler|UnityEngine.RectTransform 目标控件。
--- @param to number 目标透明度（0-1）。
--- @param time number 缓动时间（秒）。
--- @param isRecursive boolean 是否递归应用到子物体（默认 true）。
--- @return table tween对象，可以作为其他tween接口的传入参数
function this:DOAlphaText(control, to, time,isRecursive) end

--- 设置控件颜色动画。
--- @param control UIKmlLuaControlHandler|UnityEngine.RectTransform 目标控件。
--- @param toColor Color 目标颜色。
--- @param time number 缓动时间（秒）。
--- @param isRecursive boolean 是否递归应用到子物体（默认 true）。
--- @return table tween对象，可以作为其他tween接口的传入参数
function this:DoColor(control,toColor,time,isRecursive) end

--- 设置文本颜色动画。
--- @param control UIKmlLuaControlHandler|UnityEngine.RectTransform 目标控件。
--- @param toColor Color 目标颜色。
--- @param time number 缓动时间（秒）。
--- @param isRecursive boolean 是否递归应用到子物体（默认 true）。
--- @return table tween对象，可以作为其他tween接口的传入参数
function this:DoColorText(control,toColor,time,isRecursive) end

--- 停止并清理动画。
--- @param t table tween对象，可以作为其他tween接口的传入参数
--- @param callOnComplete boolean 停止时是否触发完成回调（默认 false）。停止tween的时候是否调用GUI:TweenSetOnComplete设置的函数
function this:DOKill(t,callOnComplete) end

--- 设置动画循环次数。
--- @param t table tween对象
--- @param count number 循环次数（小于 0 表示无限循环）。
function this:TweenSetLoops(t,count) end

--- 设置动画缓动类型。
--- @param t table tween对象
--- @param type ELeanTweenType 缓动算法类型。
function this:TweenSetEase(t,type) end

--- 检查动画是否已完成。
--- @param t table tween对象
--- @return boolean 是否已完成。
function this:TweenIsComplete(t) end

--- 设置动画是否递归作用于子物体。
--- @param t table tween对象
--- @param b boolean 是否递归。
function this:TweenSetRecursive(t,b) end

--- 设置动画完成回调。
--- @param t table tween对象
--- @param func function 完成后的回调函数。
function this:TweenSetOnComplete(t,func) end

--- 创建动画序列。
--- @return LTSeq 动画序列对象。可以作为GUI:TweenSequenceAppend或者GUI:TweenSequenceCancel方法的参数
function this:TweenCreateSequence() end

--- 在动画序列后追加动画或延迟。
--- @param seq LTSeq 动画序列对象。GUI:TweenCreateSequence方法创建的对象。
--- @param t table|number tween对象或延迟秒数。
function this:TweenSequenceAppend(seq,t) end

--- 取消动画序列。
--- @param seq LTSeq 动画序列对象。 GUI:TweenCreateSequence方法创建的对象。
function this:TweenSequenceCancel(seq) end

--- 设置控件的渲染层级 ZIndex。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param zindex number 层级值。
function this:SetZIndex(control, zindex) end

--- 为控件添加可裁剪属性。
--- @param control UIKmlLuaControlHandler 控件句柄。
function GUI:AddClippable(control) end

--- 移除控件的可裁剪属性。
--- @param control UIKmlLuaControlHandler 控件句柄。
function GUI:RemoveClippable(control) end

--- 设置圆形遮罩参数。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param radius number 遮罩半径（默认 1）。
--- @param softness number 边缘羽化值（默认 0）。
function GUI:SetCircleMaskParams(control,radius,softness) end

--- 设置自定义文本材质。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param matResPath string 材质资源路径。
--- @param isRecursion boolean 是否递归应用到子文本。
function GUI:SetCustomTextMaterial(control,matResPath,isRecursion) end

--- 重置自定义文本材质。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param isRecursion boolean 是否递归。
function GUI:ResetCustomTextMaterial(control,isRecursion) end

--- 获取渲染器材质。
--- @param control UIKmlLuaControlHandler 控件句柄。
--- @param path string 子物体路径。
--- @param index number 材质索引（从 0 开始），isIncludeAllChildMats=false时有效，返回单个材质对象。否则返回材质数组
--- @param isIncludeAllChildMats boolean 是否包含所有子物体材质。
--- @param customGameObject UnityEngine.GameObject 自定义游戏对象（可选）。不为空的时候将替换control对象。
--- @return UnityEngine.Material|UnityEngine.Material[] 材质对象或材质列表，isIncludeAllChildMats为true时返回
--UnityEngine.Material[]，
--isIncludeAllChildMats为false时返回UnityEngine.Material
function this:GetMaterial(control,path,index,isIncludeAllChildMats,customGameObject) end

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

---关闭所有界面
---@param exceptFilePaths string[] 排除的文件路径列表（lua文件夹相对路径）
---@param exceptsUIPanels UIKmlLuaPanelBase[] 排除的界面对象列表（GUI:UIPanel_Open返回的对象）
---@param exceptsUIPanelIds string[] 排除的界面ID列表（控件uipanel的id的值GUI:GetID(control)）
function GUI:UIPanel_CloseAll(exceptFilePaths, exceptsUIPanels, exceptsUIPanelIds) end

---设置界面缓存时间
---@param path string 路径
---@param cacheTime number 默认是300。0表示不做缓存，-1表示一直留在内存。UIPanel_Close 操作会调用OnHide。时间到了才会调用OnClose。
function GUI:SetUICacheTime(path,cacheTime) end

---获取界面缓存时间
---@param path string 路径
---@return number 缓存时间，默认为 0
function GUI:GetUICacheTime(path) end

---设置全局界面缓存时间
---@param time number 缓存时间
function GUI:SetGlobalUICacheTime(time) end

---获取全局界面缓存时间
---@return number 全局缓存时间
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
