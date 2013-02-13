envAPI = {}
envAPI._G = envAPI
operatingComp = nil
dofile("envAPI_fs.lua")
dofile("envAPI_os.lua")
dofile("envAPI_term.lua")

local simpleWrapFunctions = {"tostring","type","tonumber"}
for k,v in pairs(simpleWrapFunctions) do
    envAPI[v] = function(...)
                    return _G[v](unpack(arg))
                end
end

function envAPI.print(str)
    return print("ENVAPI::"..str)
end

function envAPI.error(str)
    envAPI.print("ENV_ERROR::"..str)
end

function setOperatingComp(comp)
    operatingComp = comp
end


function getOperatingComp()
    return operatingComp
return 