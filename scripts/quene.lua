local quene = {}

function quene:add(entity, gameTick, unitNumberString)
    self[gameTick] = self[gameTick] or {}
    self[gameTick][unitNumberString] = entity
end

function quene:remove(gameTick, unitNumberString)
    self[gameTick][unitNumberString] = nil

    if not next(self[gameTick]) then
        self[gameTick] = nil
    end
end

return quene
