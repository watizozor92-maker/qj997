--构建四叉树
---@class quadTree
QuadTree = class()

function  QuadTree:ctor(rect, max_objects, max_level, level)
    self._rect = rect
    self._max_objects = max_objects or 8
    self._max_level = max_level or 4
    self._level = level
    self._trees = {}
    self._objects = {}
end

--分裂树
function QuadTree:SplitTree()
    local width = self._rect.width/2
    local height = self._rect.height/2
    local x = self._rect.x + width
    local y = self._rect.y + height
    local level = self._level + 1
    self._trees[1] = QuadTree({ x = x + width, y = y + height, width = width, height = height},self._max_objects,self._max_level,level)
    self._trees[2] = QuadTree({ x = x, y = y + height, width = width, height = height},self._max_objects,self._max_level,level)
    self._trees[3] = QuadTree({ x = x, y = y, width = width, height = height},self._max_objects,self._max_level,level)
    self._trees[4] = QuadTree({ x = x + width , y = y, width = width, height = height},self._max_objects,self._max_level,level)
end
--
--- y—————————————————h
--- |       |       |
--- |    2  |   1   |
--- |       |       |
--- |————————————————
--- |       |       |
--- |    3  |   4   |
--- |       |       |
--- x—————————————————w
---
--所属子树index
function QuadTree:GetTreeIndexs(rect)
    local treeIndexs = {}

    local c_x = self._rect.x + self._rect.width/2
    local c_y = self._rect.y + self._rect.height/2

    local is_left = rect.x < c_x
    local is_top = rect.y > c_y
    local end_left = rect.x + rect.width < c_x
    local end_top = rect.y + rect.height > c_y
    --1
    if (is_top and not end_left) or (not is_left and end_top) then
        table.insert( treeIndexs,1)
    end
    --2
    if (is_top and end_left) or (is_left and end_top ) then
        table.insert( treeIndexs,2)
    end
    --3
    if (not is_top and end_left) or (is_left and not end_top) then
        table.insert( treeIndexs,3)
    end
    --4
    if (not is_top and not end_left) or (not is_left and not end_top) then
        table.insert( treeIndexs,4)
    end
    return treeIndexs
end

--插入
function QuadTree:Insert(rect)
    if self._trees and next(self._trees) then
        local treeIndexs = self:GetTreeIndexs(rect)
        for k,index in ipairs(treeIndexs) do
            self._trees[index]:insert(rect)
        end
        return
    end
    table.insert( self._objects,rect)
    if #self._objects > self._max_objects and self._level <= self._max_level then
        if not (self._trees and next(self._trees)) then
            self:SplitTree()
        end
        for i,k in ipairs(self._objects) do
            local k_indexs = self:GetTreeIndexs(k)
            for _,index in ipairs(k_indexs) do
                self._trees[index]:insert(k)
            end
        end
        self._objects = {}
    end

end
--
function QuadTree:HashCode(_object)
    local tag = _object.x..'_'.._object.y.."_".._object.width.."_".._object.height
    return tag
end

--列表相加 并且去重
function QuadTree:TableAdd(table1, table2)
    local hashTags = {}
    local newTables = table1 or {}
    for _,value in ipairs(newTables) do
        hashTags[self:HashCode(value)] = true
    end
    if table2 and next(table2) then
        for _,value in ipairs(table2) do
            local hashtag = self:HashCode(value)
            if not hashTags[hashtag] then
                hashTags[hashtag] = true
                table.insert( newTables,value)
            end
        end
    end
    return newTables
end

--取回同一组object
function QuadTree:Retrieve(rect)
    local newObjects = self._objects
    if self._trees and next(self._trees) then
        local treeIndexs = self:GetTreeIndexs(rect)
        for _,index in ipairs(treeIndexs) do
            newObjects = self:TableAdd(newObjects,self._trees[index]:retrieve(rect))
        end
    end
    return newObjects
end

function QuadTree:clearTree()
    self._objects = {}
    for _,tree in pairs(self._trees) do
        tree:clearTree()
    end
end

function QuadTree:dumpTree()
    sys.log("[quadTree]-level="..self._level)
    if self._objects and next(self._objects) then
        sys.log("[quadTree]-objects:")
        sys.dump(self._objects)
    end
    for index,child_tree in pairs(self._trees) do
        sys.log("[quadTree]-index="..index)
        child_tree:dumpTree()
    end
end