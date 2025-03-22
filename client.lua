local QBCore = exports['qb-core']:GetCoreObject()
local hasTextUi = false
local cfg = require 'config'

local function enterElevator(zone, eleId)
    local options = {}
    for i = 1, #zone do
        for k,v in pairs(zone[i]) do
            options[k] = {value = k, label = ('Kat %s'):format(k)}
        end
    end

    local input = lib.inputDialog('Kat Menüsü', {
        { type = 'select', label = 'Kat Seç', options = options}
    })

    if not input then return end

    -- Şifre girişi
    local passwordInput = lib.inputDialog('Şifre Girişi', {
        { type = 'input', label = 'Şifre' }
    })

    -- Seçilen asansörün şifresini kontrol et
    if not passwordInput or passwordInput[1] ~= cfg.Elevators[eleId].Password then
        lib.notify({ title = 'Hata', description = 'Yanlış şifre!', type = 'error' })
        return
    end

    for i = 1, #zone do
        if input[1] then
            local coords = zone[i][tonumber(input[1])]

            if cfg.EnableFadeOut then
                DoScreenFadeOut(800)
                while not IsScreenFadedOut() do Wait(0) end
                DoScreenFadeIn(800)
                SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, false, false, false, true)
            else
                SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, false, false, false, true)
            end
        end
    end
end

local elevators, currentZone = {}, {}

local function onEnter(self)
    if cfg.Elevators[self.eleId] then
        currentZone[#currentZone + 1] = cfg.Elevators[self.eleId].coords
    end
end

local function onExit(self)
    lib.hideTextUI()
    table.wipe(currentZone)
end

local function nearbyElevator(self)
    if cfg.Elevators[self.eleId] and not IsEntityDead(PlayerPedId()) then
        if type(cfg.Elevators[self.eleId].jobs) == 'table' then 
            for _, jobName in pairs(cfg.Elevators[self.eleId].jobs) do
                if QBCore.Functions.GetPlayerData().job.name == jobName then

                    if cfg.DrawMarker then
                        DrawMarker(2, self.coords.x, self.coords.y, self.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 30, 150, 30, 222, false, false, 0, true, false, false, false)
                    end

                    if self.isClosest and self.currentDistance < 1.2 then
                        if not hasTextUi then
                            hasTextUi = true
                            lib.showTextUI(('[E] - Giriş %s'):format(cfg.Elevators[self.eleId].name))
                        end

                        if IsControlJustReleased(0, 38) then
                            lib.hideTextUI()
                            enterElevator(currentZone, self.eleId) -- eleId'yi geçiyoruz
                        end

                    elseif hasTextUi then
                        hasTextUi = false
                        lib.hideTextUI()
                    end
                end
            end
        elseif type(cfg.Elevators[self.eleId].jobs) == 'boolean' then

            if cfg.DrawMarker then
                DrawMarker(2, self.coords.x, self.coords.y, self.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 30, 150, 30, 222, false, false, 0, true, false, false, false)
            end
            
            if self.isClosest and self.currentDistance < 1.2 then
                if not hasTextUi then
                    hasTextUi = true
                    lib.showTextUI(('[E] - Giriş %s'):format(cfg.Elevators[self.eleId].name))
                end

                if IsControlJustReleased(0, 38) then
                    lib.hideTextUI()
                    enterElevator(currentZone, self.eleId) -- eleId'yi geçiyoruz
                end

            elseif hasTextUi then
                hasTextUi = false
                lib.hideTextUI()
            end
        end
    end
end

local function setupElevators()
    for k,v in pairs(cfg.Elevators) do
        for i = 1, #v.coords, 1 do
            elevators[i] = lib.points.new({
                coords = v.coords[i],
                distance = 6.0,
                eleId = k,
                onEnter = onEnter,
                onExit = onExit,
                nearby = nearbyElevator
            })
        end
    end
end

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    setupElevators()
end)

AddEventHandler('QBCore:Client:OnJobUpdate', function(job)
    QBCore.Functions.GetPlayerData().job = job
end)

AddEventHandler('QBCore:Client:OnPlayerLogout', function()
    QBCore.Functions.GetPlayerData().job = {}
end)

AddEventHandler('onResourceStart', function(name)
    if GetCurrentResourceName() == name then
        setupElevators()
    end
end)