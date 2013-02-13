envAPI.os = {}

function envAPI.os.run(env,file,...)
    print("OSPROXY")
    computerTerminal.osRun(env,file,unpack(arg))
end

function envAPI.os.pullEvent(filter)
    local evData = {envAPI.os.pullEventRaw(filter)}
    if evData[1] == "terminate" then

    end
    return unpack(evData)
end

function envAPI.os.pullEventRaw(filter)
    return coroutine.yield(filter)
end

function envAPI.os.clock()
    return timeManager.getCurrentTime()
end