eventManager = {}
eventManager.simulationStatus = "paused"
eventManager.eventQueue = {}
eventManager.registrations = {}

function eventManager.register(comp)
    eventManager.registrations[comp] = {comp.co,""}
end

function eventManager.queueEvent(evTable)
    table.insert(eventManager.eventQueue,evTable)
end

function eventManager.processEvent()
    local evData = table.remove(eventManager.eventQueue,1)
    if evData ~= nil then
        for k,v in pairs(eventManager.registrations)
            if coroutine.status(v[1]) ~= "dead" then
                if v[2] == evData[1] or v[2] == "" or v[2] == "co_startup" then
                    envAPI.operatingComp = k
                    local yield
                    timeManager.startMeasure()
                    if v[2] == "co_startup" then
                        yield = coroutine.resume()
                    else
                        yield = coroutine.resume(v[1],unpack(evData))
                    end
                    timeManager.stopMeasure()
                    if yield and type(yield) ~= "string" then yield = nil end
                    if yield == nil then yield = "" end
                    v[2] = yield
                end
            end
        end
    end
end

function eventManager.resumeSimulation()
    eventManager.simulationStatus = "running"
    os.queueEvent("sim_resume")
end

function eventManager.pauseSimulation()
    eventManager.simulationStatus = "paused"
end

function eventManager.exitSimulation()
    eventManager.simulationStatus = "exit"
end

function eventManager.reset()
    eventManager.simulationStatus = "exit_r"
end

function eventManager.simulationCo()
    while eventManager.simulationStatus ~= "exit" do
        while eventManager.simulationStatus ~= "paused" and eventManager.simulationStatus ~= "exit_r" do
            if #eventQueue > 0 then
                local startProc = os.clock()
                eventManager.processEvent()
                local timeTaken = os.clock() - startProc
                if timeTaken < 0.05 then timeManager.delayTime(0.05-timeTaken) end
            else
                timeManager.delayTime(0.05)
            end
            sleep(timeManager.simulationStepSleep)
        end

        if eventManager.simulationStatus == "exit_r" then
            eventManager.simulationStatus = "paused"
            eventManager.registrations = {}
            eventManager.eventQueue = {}
            os.queueEvent("sim_reset")
        end
        os.pullEvent("sim_resume")
    end
end