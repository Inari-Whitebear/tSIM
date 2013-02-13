world = {}
world.worlds = {}
local worldInj = {}


function world.create(name,w,d,h,cx,cy,cz)
    cx = cx or math.ceil(w/2)
    cy = cy or math.ceil(h/2)
    cz = cz or math.ceil(d/2)
    world.worlds[name] = {}
    local tW = world.worlds[name]
    tW.cx = cx
    tW.cy = cy
    tW.cz = cz
    tW.w = w
    tW.d = d
    tW.h = h
    tW.map = {}
    print("world id: " .. tostring(tW))
    for x=1,w,1 do
        tW.map[x] = {}
        for z=1,d,1 do
            tW.map[x][z] = {}
            for y=1,h,1 do
                tW.map[x][z][y] = blockRegistry.AIR
            end
        end
    end
    world.inject(tW)
    return tW
end

function world.inject(tab)
    setmetatable(tab,{__index=worldInj})
end

function worldInj:isValidCoord(x,y,z)
    local lx,ly,lz = self:getAbsCoords(x,y,z)
    print(lx.."//"..ly.."//"..lz)
    if lx <= 0  or lx > self.w then
        return false
    end
    if lz <= 0 or lz > self.d then
        return false
    end
    if ly <= 0 or ly > self.h then
        return false
    end
    print("valid")
    return true

end

function worldInj:setBlock(x,y,z,blockData)
    if not self:isValidCoord(x,y,z) then return false end
    local lx,ly,lz = self:getAbsCoords(x,y,z)

    self.map[lx][lz][ly] = blockData

end

function worldInj:getAbsCoords(wx,wy,wz)
    print("WID: "..tostring(self))
    return wx+self.cx,wy+self.cy,wz+self.cz
end

function worldInj:getBlock(x,y,z)
    if not self:isValidCoord(x,y,z) then return false end 
    local lx,ly,lz = self:getAbsCoords(x,y,z)
    return self.map[lx][lz][ly]
end