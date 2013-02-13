vTerm = {}
vTerm.terms = {}
vTerm.activeTerm = nil
vTerm.termFuncs = {}

function vTerm.setActiveTerm(newTermName)
    vTerm.activeTerm = vTerm.terms[newTermName]
    term.setCursorBlink(vTerm.activeTerm.blink)
    term.setCursorPos(vTerm.activeTerm.cX,vTerm.activeTerm.cY)
    term.setTextColor(vTerm.activeTerm.texCol)
    term.setBackgroundColor(vTerm.activeTerm.bgCol)
    vTerm.fullRedraw()

end

function vTerm.dropAllTerms()
    vTerm.terms = {}
    vTerm.activeTerm = nil
end

function vTerm.activeExec(tName,tFunc,...)
    if vTerm.activeTerm and vTerm.activeTerm.name == tName then
        tFunc(unpack(arg))
    end
end

function vTerm.fullRedraw()

    term.clear()

    
    if vTerm.activeTerm then
        local texCol,bgCol = vTerm.activeTerm.texCol,vTerm.activeTerm.bgCol
        local cX,cY = vTerm.activeTerm.cX,vTerm.activeTerm.cY
        for y=1,vTerm.activeTerm.h,1 do
            term.setCursorPos(1,y)
            for x=1,vTerm.activeTerm.w,1 do
                if texCol ~= vTerm.activeTerm.data[x][y].texCol then term.setTextColor(vTerm.activeTerm.data[x][y].texCol) texCol = vTerm.activeTerm.data[x][y].texCol end
                if bgCol ~= vTerm.activeTerm.data[x][y].bgCol then term.setBackgroundColor(vTerm.activeTerm.data[x][y].bgCol) bgCol = vTerm.activeTerm.data[x][y].bgCol end
                term.write(vTerm.activeTerm.data[x][y].char)
            end
        end
        term.setCursorPos(vTerm.activeTerm.cX,vTerm.activeTerm.cY)
        term.setTextColor(vTerm.activeTerm.texCol)
        term.setBackgroundColor(vTerm.activeTerm.bgCol)
    end

end

function vTerm.redraw(sX,sY,w,h)
    if vTerm.activeTerm then
        local texCol,bgCol = vTerm.activeTerm.texCol,vTerm.activeTerm.bgCol
        local cX,cY = vTerm.activeTerm.cX,vTerm.activeTerm.cY
        for dY = sY,sY+h-1 do
            term.setCursorPos(sX,dY)
            for dX = sX,sX+w-1 do
                if vTerm.activeTerm:isValidCursorPos(dX,dY) then
                    if texCol ~= vTerm.activeTerm.data[dX][dY].texCol then term.setTextColor(vTerm.activeTerm.data[dX][dY].texCol) texCol = vTerm.activeTerm.data[dX][dY].texCol end
                if bgCol ~= vTerm.activeTerm.data[dX][dY].bgCol then term.setBackgroundColor(vTerm.activeTerm.data[dX][dY].bgCol) bgCol = vTerm.activeTerm.data[dX][dY].bgCol end
                    term.write(vTerm.activeTerm.data[dX][dY].char)  
                else
                    term.setCursorPos(dX+1,dY)
                end
            end
        end
        term.setCursorPos(vTerm.activeTerm.cX,vTerm.activeTerm.cY)
        term.setTextColor(vTerm.activeTerm.texCol)
        term.setBackgroundColor(vTerm.activeTerm.bgCol)
    end
    
end

function vTerm.makeTerm(termName,w,h,isColor)
    local newTerm = {}
    local dW,dH = term.getSize()
    w = w or dW
    h = h or dH
    newTerm.w = w
    newTerm.h = h
    newTerm.cX = 1
    newTerm.cY = 1
    newTerm.texCol = colors.white
    newTerm.bgCol = colors.black
    newTerm.isColor = isColor
    newTerm.blink = true
    newTerm.name = termName
    newTerm.data = vTerm.getBlankTerm(w,h,colors.black)

    setmetatable(newTerm,{__index=vTerm.termFuncs})
    vTerm.terms[termName] = newTerm
    return newTerm
end

function vTerm.getBlankTerm(w,h,bgCol)
    local ret = {}
    
    for x=1,w,1 do
        ret[x] = {}
        for y=1,h,1 do

            ret[x][y] = { char = " ", texCol = colors.white, ["bgCol"] = bgCol }
        end
    end
    return ret
end

function vTerm.destroyTerm(termName)
    if vTerm.activeTerm.name == termName then
        vTerm.activeTerm = nil
    end
    vTerm.terms[termName] = nil
end

function vTerm.termFuncs:isValidCursorPos(x,y)
    x = x or self.cX
    y = y or self.cY
    if x < 1 or x > self.w then return false end
    if y < 1 or y > self.h then return false end
    return true
end

function vTerm.termFuncs:setCursorPos(ncX,ncY)
    if type(ncX) ~= "number" or type(ncY) ~= "number" then error("number,number expected got "..type(ncX)..","..type(ncY)) end

    self.cX = ncX
    self.cY = ncY
    vTerm.activeExec(self.name,term.setCursorPos,self.cX,self.cY)
end

function vTerm.termFuncs:setCursorBlink(bool)
    if type(bool) ~= "boolean" then
        errror("boolean expected, got "..type(bool))
    end
    self.blink = bool
    vTerm.activeExec(self.name,term.setCursorBlink,self.blink)
end

function vTerm.termFuncs:write(str)
    if type(str) ~= "string" then error("string expected, got "..type(str)) end

    local sData = self.data
    
    for i=1,string.len(str),1 do
        if (self.cX+i-1) > self.w then break end
        if self:isValidCursorPos(self.cX+i-1,self.cY) then
            sData[self.cX+i-1][self.cY].char = string.sub(str,i,i)
            sData[self.cX+i-1][self.cY].texCol = self.texCol
            sData[self.cX+i-1][self.cY].bgCol = self.bgCol
        end
    end
    local ocX = self.cX
    self.cX = self.cX + string.len(str)
    vTerm.activeExec(self.name,vTerm.redraw,ocX,self.cY,self.cX-ocX,1)
end

function vTerm.termFuncs:clear()
    self.data = vTerm.getBlankTerm(self.w,self.h,self.bgCol)
    vTerm.activeExec(self.name,term.clear)
end

function vTerm.termFuncs:clearLine()
    if self.cY >= 1 and self.cY <= self.h then
        for i=1,self.w,1 do
            self.data[i][self.cY].char = " "
        end
        vTerm.activeExec(self.name,term.clearLine)
    end

end

function vTerm.termFuncs:getSize()
    return self.w,self.h
end

function vTerm.termFuncs:getCursorPos()
    return self.cX,self.cY
end

function vTerm.termFuncs:setTextColor(texCol)
    if type(texCol) ~= "number" then error("number expected, got "..type(texCol)) end
    if not self.isColor and (texCol ~= colors.white and texCol ~= colors.black) then return end
    self.texCol = texCol
end

function vTerm.termFuncs:setBackgroundColor(bgCol)
    if type(bgCol) ~= "number" then error("number expected, got "..type(bgCol)) end
    if not self.isColor and (bgCol ~= colors.white and bgCol ~= colors.black) then return end
    self.bgCol = bgCol
end

function vTerm.termFuncs:isColor()
    return self.isColor
end

function vTerm.termFuncs:scroll(nLines)
    if type(nLines) ~= "number" then error("number expected, got "..type(nLines)) end

    if nLines >= self.h then
        self:clear()
    else
        for dY = 1,self.h,1 do

            for dX = 1, self.w, 1 do
                if dY + nLines > self.h then
                    self.data[dX][dY].char = " "
                else
                    self.data[dX][dY].char = self.data[dX][dY+nLines].char
                end
            end
        end
    end

    vTerm.activeExec(self.name,term.scroll,nLines)
end