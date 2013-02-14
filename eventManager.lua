eventManager = {}
eventManager.eventQueue = {}
eventManager.registrations = {}

function eventManager.register(comp)
    eventManager.registrations[comp] = {comp.co,""}
end

function processEvent()
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
                        yield = coroutine.resume(v[1])
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