timeManager = {}
timeManager.cTime = 0
timeManager.simulationStepSleep = 1

function timeManager.startMeasure()
    timeManager.measureStart = os.clock()
end

function timeManager.delayTime(timeDelay)
    timeManager.cTime = timeManager.cTime + timeDelay
end

function timeManager.getCurrentTime()
    if timeManager.measureStart == nil then
        return timeManager.cTime
    else
        return timeManager.cTime + (os.clock() - timeManager.measureStart)
    end
end

function timeManager.stopMeasure()
    timeManager.cTime = timeManager.cTime + (os.clock() - timeManager.measureStart)
    timeManager.measureStart = nil
end