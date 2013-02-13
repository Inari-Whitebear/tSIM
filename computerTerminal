computerTerminal = {}
local computerTerminalInj = {}

function computerTerminal.new()
    local tab = {}
    tab.id = -1
    tab.label = ""
    tab.status = "off"
    tab.termIsColor = false
    tab.peripheral = {}
    tab.peripheral.type = "turtle"
    tab.peripheral.parent = tab
    computerTerminal.inject(tab)
    return tab
end

function computerTerminal.inject(tab)
    print("PREP:"..tostring(tab))
    setmetatable(tab,{__index=computerTerminalInj})
end

function computerTerminal.prepareEnv(inEnv)
    setmetatable(inEnv,{__index=envAPI._G})
end

function computerTerminalInj:fetchID()
    self.id = turtleManager.resolveLabel(self.label)
    if( self.id == -1 ) then
        self.id = turtleManager.requestNewID()
    end
end

function computerTerminal.osRun(tEnv,tProg,...)
    local fileFunc,err = loadfile(tProg)
    if fileFunc then
        setmetatable(tEnv,{__index=envAPI._G})
        setfenv(fileFunc,tEnv)
        local ok,err = pcall(function() fileFunc(unpack(arg)) end)
        if not ok then
            if err and err~="" then
                error(err)
            end
            return false
        end
        return true

    end
    if err and err~="" then
        error(err)
    end
    return false
end

function computerTerminal.isolatedCoroutine(comp)
    local comp = comp
    print("PPC")
    print("PGTYPE::"..type(_G))
    print("compenv::"..tostring(comp.env))
    print(type(comp.env.print))
    comp.env.print("ABC")
    setfenv(1,comp.env)

    print("PC")
    print("_GTYPE::"..type(_G))
    os.pullEvent("co_startup")
    os.run( {}, "testRun" )

    
    --run()
end

function computerTerminalInj:startCoroutine()
    self.co = coroutine.create(computerTerminal.isolatedCoroutine)
    self.status = "running"

    coroutine.resume(self.co,self)
end

function computerTerminalInj:startup()
    self.env = {}

    self:fetchID()
    computerTerminal.prepareEnv(self.env)
    turtleManager.register(self)
    fsRouting.prepareFolder(self)
    self.term = vTerm.makeTerm("term_"..self.id,turtle.defaultTermSize[1],turtle.defaultTermSize[2],self.termIsColor)
    eventManager.register(self)
    self:startCoroutine()
    
    print("got id:"..self.id)
end

function computerTerminalInj:execCode(LuaCode)
    print("TAB:"..tostring(self))
    print(type(LuaCode))
    local f,e = loadstring(LuaCode)
    if f then
        setfenv(f,self.env)
        res = {pcall(f)}
        local callRes = table.remove(res,1)
        if res then
            return true,unpack(res)
        else
            return false,res[1]
        end
    else
        return false,e
    end
end
