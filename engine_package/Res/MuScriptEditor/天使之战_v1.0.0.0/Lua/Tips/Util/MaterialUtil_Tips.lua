---@class MaterialUtil @注释
---@field greyMat UnityEngine.Material
MaterialUtil = class()
local this = MaterialUtil
this.isHasInitShader = false
local editorMode = CS.ResourceLoadMgr.editorMode
local isGameBranch = CS.ResourceLoadMgr.isGameBranch
function this.GetGreyMat()
    if this.greyMat then
        return
    end
    if editorMode and not isGameBranch then
        local greyshader = ShaderEx.Find("UI/Grey712")
        if greyshader ~= nil then
            this.greyMat = CS.UnityEngine.Material(greyshader)
        end
    else
        if not this.isHasInitShader then
            return nil
        end
        local greyshader = ShaderEx.Find("UI/Grey712")
        if greyshader ~= nil then
            this.greyMat = CS.UnityEngine.Material(greyshader)
        end
    end
    return this.greyMat
end

function this.SetFloat(go,floatId, f)
    local rs = go:GetComponentsInChildren(typeof(CS.UnityEngine.Renderer))
    for i = 0, rs.Length - 1 do
        local r = rs[i]
        for j = 0, r.materials.Length - 1 do
            local mat = r.materials[j]
            if mat then
                if mat:HasProperty(floatId) then
                    mat:SetFloat(floatId,f)
                end
            end
        end
    end
end 