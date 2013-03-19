module(...,package.seeall)

--lua json parser. couldn't get prefs to work for shit
local json = require("json")

--scores file name
local scoresFileName = "triforce.json"

--scoring prototype
scores = {totalScore=0,highestGameScore=0,[3]=0,[4]=0,[5]=0,[6]=0,[7]=0,[8]=0,powerUps={},completedLevels={}}

--internal functions
local function saveScores(table, filename)
    -- print("[SCORING] Saving '"..tostring(table).."' to '"..filename.."'")
    local path = system.pathForFile( filename, system.DocumentsDirectory)
    local file = io.open(path, "w")
    if file then
        local contents = json.encode(table)
        file:write( contents )
        io.close( file )
        -- print("[SCORING] Saved '"..tostring(table).."' to '"..filename.."' Successfully")
        return true
    else
        return false
    end
end

local function getScores(filename)
    -- print("[SCORING] Trying to open up '"..filename.."'")
    local path = system.pathForFile( filename, system.DocumentsDirectory)
    local contents = ""
    local myTable = {}
    local file = io.open( path, "r" )
    if file then
         local contents = file:read( "*a" )
         myTable = json.decode(contents);
         io.close( file )
         -- print("[SCORING] We found and returned '"..filename.."'")
         return myTable
    end
    return nil
end

--external functions
function saveWord(word)
    local curScores = getScores(scoresFileName)
    if (curScores == nil) then
        curScores = scores
    end
    curScores.totalScore = curScores.totalScore + #word
    if #word >= 3 and #word <= 8 then
        curScores[#word] = curScores[#word] + 1
    end
    -- print("[SCORING] Just saved '"..word.."' and the new total score is '"..curScores.totalScore.."'")
    return saveScores(curScores, scoresFileName)
end

function savePowerUp(pup)
    --pup must be a static lua table
    local curScores = getScores(scoresFileName)
    if (curScores == nil) then
        curScores = scores
    end
    if pup then
        table.insert(curScores.powerUps, pup)
    end
    -- print("[SCORING] Just added the Power Up '"..tostring(pup).."'")
    return saveScores(curScores, scoresFileName)
end

function removePowerUp(pup)
    --pup must be a static lua table
    local curScores = getScores(scoresFileName)
    if (curScores == nil) then
        curScores = scores
    end
    if pup then
        table.remove(curScores.powerUps, pup)
    end
    -- print("[SCORING] Just removed the Power Up '"..tostring(pup).."'")
    return saveScores(curScores, scoresFileName)
end

function saveCompleteLevel(level)
    --[[level must be a static lua table matching the following:
        local level = {n = 3, highScore = 43958, time = 23409234}
    ]]--
    local curScores = getScores(scoresFileName)
    if (curScores == nil) then
        curScores = scores
    end
    if pup then
        table.insert(curScores.completedLevels, level)
    end
    -- print("[SCORING] Just added the completed Level '"..tostring(level).."'")
    return saveScores(curScores, scoresFileName)
end

function removeCompleteLevel(level)
    --[[level must be a static lua table matching the following:
        local level = {n = 3, highScore = 43958, time = 23409234}
    ]]--
    local curScores = getScores(scoresFileName)
    if (curScores == nil) then
        curScores = scores
    end
    if pup then
        table.remove(curScores.completedLevels, level)
    end
    -- print("[SCORING] Just removed the completed Level '"..tostring(level).."'")
    return saveScores(curScores, scoresFileName)
end
