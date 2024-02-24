ESX = exports['es_extended']:getSharedObject()

local TimerrCL = true

RegisterCommand('sad', function() 

    Start()

end)

function timerxd(pe)
    Wait(pe)
    TimerrCL = true
end



RegisterNetEvent('gx_npcrobbery:client:progress')
AddEventHandler('gx_npcrobbery:client:progress', function(pe)
    
    if TimerrCL then
        if lib.progressCircle({
            duration = 10 * 1000,
            position = 'middle',
            useWhileDead = false,
            canCancel = true,
            disable = {
                move = false,
                car = true,
            }
        }) then 
        
            print('CONTROLASTE EL TERRITORIO') 
            TimerrCL = false
            return timerxd(pe)
        else 
            print('NO PUDISTE!') 
            TimerrCL = false
            return timerxd(pe)
        end
    end

end)


function drawTxt(x,y, width, height, scale, text, r,g,b,a, outline)
	SetTextFont(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropshadow(0, 0, 0, 0,255)
	SetTextDropShadow()
	if outline then SetTextOutline() end

	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(x - width/2, y - height/2 + 0.005)
end

function npcAttack(data)


end

function rounds(data, npcAttack)
local contai = 1
print(data.rondas)
    while contai <= data.rondas  do
        print(npcAttack.npc)

        AddRelationshipGroup(data.name)

        RequestModel(npcAttack.npc)
        while not HasModelLoaded(npcAttack.npc) do
            Citizen.Wait(0)
        end
        local CharPed1 = CreatePed(3, GetHashKey(npcAttack.npc), npcAttack.coord, 87.6832, 1.2370, false, false)
        local CharPed2 = CreatePed(3, GetHashKey(npcAttack.npc), npcAttack.coord, 87.6832, 1.2370)
        local CharPed3 = CreatePed(3, GetHashKey(npcAttack.npc), npcAttack.coord, 87.6832, 1.2370, false, false)
        SetPedRandomComponentVariation(CharPed1)
        SetPedRandomComponentVariation(CharPed2)
        SetPedRandomComponentVariation(CharPed3)
        SetPedRelationshipGroupHash(CharPed1, data.name)
        SetPedRelationshipGroupHash(CharPed2, data.name)
        SetPedRelationshipGroupHash(CharPed3, data.name)
        GiveWeaponToPed(CharPed1, GetHashKey(npcAttack.weapon), 250, false, true)
        GiveWeaponToPed(CharPed2, GetHashKey(npcAttack.weapon), 250, false, true)
        GiveWeaponToPed(CharPed3, GetHashKey(npcAttack.weapon), 250, false, true)
        TaskCombatPed(CharPed1, GetPlayerPed(-1))
        TaskCombatPed(CharPed2, GetPlayerPed(-1))
        TaskCombatPed(CharPed3, GetPlayerPed(-1))
        SetPedAccuracy(CharPed1, 100) -- 0-100 Punteria
        SetPedAccuracy(CharPed2, 100) -- 0-100 Punteria
        SetPedAccuracy(CharPed3, 100) -- 0-100 Punteria
        SetPedDropsWeaponsWhenDead(CharPed1, false) -- Para que no tire su arma
        SetPedDropsWeaponsWhenDead(CharPed2, false) -- Para que no tire su arma
        SetPedDropsWeaponsWhenDead(CharPed3, false) -- Para que no tire su arma
        SetPedArmour(CharPed1, 100) -- 0-100 Chaleco
        SetPedArmour(CharPed2, 100) -- 0-100 Chaleco
        SetPedArmour(CharPed3, 100) -- 0-100 Chaleco
        Citizen.Wait(data.time_rondas)
        contai = contai + 1
    end


end

function NPCstart(data)

local contai = 1
  -- recorre
    -- condición con name
    -- recorre npcattack
    for i = 1, #Config.ZoneRobbery do
        if data.name == Config.ZoneRobbery[i].Zone.name then
            for e = 1, #Config.ZoneRobbery[i].Zone.NpcAttack do
            
                npcAttack = Config.ZoneRobbery[i].Zone.NpcAttack[e]
                print("ola => ", json.encode(npcAttack))

                rounds(data, npcAttack)

               

            end


        
        end

    end


end

RegisterNetEvent('gx_npcrobbery:client:access', function(data)

    print("0-2 => ", data.name)

    local result = TriggerEvent('gx_npcrobbery:client:progress', 2500)
            NPCstart(data)




end)

RegisterNetEvent('gx_npcrobbery:client:start')
AddEventHandler('gx_npcrobbery:client:start', function(_, data) 

    lib.registerContext({
        id = 'open_gxnpcrobbery',
        title = data.Zone.name,
        options = {
          {
            title = 'Start Robbery!!',
            descriptiion = 'u can ere start robbery!!',
            icon = 'play',
            onSelect = function()

                for i = 1, #Config.ZoneRobbery do
                    if data.Zone.name == Config.ZoneRobbery[i].Zone.name then
                        print('0-1 => ',data.Zone.name)
                        TriggerEvent('gx_npcrobbery:client:access', data.Zone)
                    
                    end
                end
               --miTemporizador:iniciar()
               
               --local result = TriggerEvent('gx_npcrobbery:client:progress', 2500)
               
                --return print(result)
            end,
          },
          {
            title = 'Teasure',
            description = 'here u get a surprais!',
            icon = 'gift',
            disabled = true,
            onSelect = function()
              print("Pressed the button!")
            end,
            
          },
    
        }
      })
     
      lib.showContext('open_gxnpcrobbery')

end)




Citizen.CreateThread(function() 


    while true do
        Citizen.Wait(3)
        local ped = PlayerPedId()
        
        for i = 1, #Config.ZoneRobbery do
            local dist = #(vector3(Config.ZoneRobbery[i].Zone.coords) - GetEntityCoords(ped))
            local data = Config.ZoneRobbery[i]
            if dist <= 0.8 then
                ESX.ShowFloatingHelpNotification("Presiona ~r~[E]~s~ para Dominar ~r~"..data.Zone.name, vector3(data.Zone.coords))
                
                --TriggerServerEvent('gx_npcrobbery:server:timer', 10)

                    if dist <= 0.8 then
                        if IsControlJustPressed(0, 38) then
                            print('aeaeaeaeae')
                            
                            print(json.encode(data.Zone.NpcAttack))
                            TriggerEvent('gx_npcrobbery:client:start', TimerrCL, data)
                            break
                            Wait(500)
                        end
                    end
                --break
                
            end
        end
        
    end


end)




function Start()
    -- INICIO CAR NPC ATTACK

    local ped = GetHashKey('a_m_m_rurmeth_01')
    RequestModel(ped)
    while not HasModelLoaded(ped) do
        Citizen.Wait(0)
    end

    local card = GetHashKey('taxi')
    RequestModel(card)
    while not HasModelLoaded(card) do
        Citizen.Wait(0)
    end


    methtruck2 = CreateVehicle(card, 94.2550, 3458.7771, 39.7593, 10.5330, true, false)
    SetVehicleColours(methtruck2, 90, 90)
    oke, Group = AddRelationshipGroup("Methhouse")
    methpedtruckdriver2 = CreatePedInsideVehicle(methtruck2, 12,ped, -1, true, false)
    methpedtruck2 = CreatePedInsideVehicle(methtruck2, 12, ped, 0, true, false)
    methpedtruck3 = CreatePedInsideVehicle(methtruck2, 12,ped, 1, true, false)
    methpedtruck4 = CreatePedInsideVehicle(methtruck2, 12,ped, 2, true, false)


    TaskVehicleGotoNavmesh(methpedtruckdriver2, methtruck2, 2421.13, 4973.95, 46.04, 30.0, 156, 5.0)
    SetPedRelationshipGroupHash(methpedtruckdriver2, Group)                      

    SetPedRelationshipGroupHash(methpedtruck2, Group) -- methpedtruck2 now works, but he is kinda stupid :D
    SetEntityCanBeDamagedByRelationshipGroup(methpedtruckdriver2, false, Group)  SetEntityCanBeDamagedByRelationshipGroup(methpedtruck2, false, Group)
    GiveWeaponToPed(methpedtruckdriver2, "WEAPON_PISTOL", 400, false, true)      GiveWeaponToPed(methpedtruck2, "WEAPON_PISTOL", 400, false, true)
    SetPedCombatAttributes(methpedtruckdriver2, 1, true)                         SetPedCombatAttributes(methpedtruck2, 1, true)
    SetPedCombatAttributes(methpedtruckdriver2, 2, true)                         SetPedCombatAttributes(methpedtruck2, 2, true)
    SetPedCombatAttributes(methpedtruckdriver2, 5, true)	                        SetPedCombatAttributes(methpedtruck2, 5, true)
    SetPedCombatAttributes(methpedtruckdriver2, 16, true)                        SetPedCombatAttributes(methpedtruck2, 16, true)
    --[[ SetPedCombatAttributes(methpedtruckdriver2, 26, true) ]]                SetPedCombatAttributes(methpedtruck2, 26, true)
    --[[ SetPedCombatAttributes(methpedtruckdriver2, 46, true)  ]]               SetPedCombatAttributes(methpedtruck2, 46, true)
    --[[ SetPedCombatAttributes(methpedtruckdriver2, 52, true) ]]                SetPedCombatAttributes(methpedtruck2, 52, true)
    SetPedFleeAttributes(methpedtruckdriver2, 0, 0)                              SetPedFleeAttributes(methpedtruck2, 0, 0)
    SetPedPathAvoidFire(methpedtruckdriver2, 1)                                  SetPedPathAvoidFire(methpedtruck2, 1)
    SetPedAlertness(methpedtruckdriver2,3)                                       SetPedAlertness(methpedtruck2,3)
    --[[ SetPedFiringPattern(methpedtruckdriver2, 0xC6EE6B4C) ]]                         SetPedAccuracy(methpedtruck2, 30)
    SetPedAccuracy(methpedtruckdriver2, 30)                                      --[[ SetPedFiringPattern(methpedtruck2, 0xC6EE6B4C) ]]
    SetPedArmour(methpedtruckdriver2, 100)                                       SetPedArmour(methpedtruck2, 100)
    TaskCombatPed(methpedtruckdriver2, GetPlayerPed(-1), 0, 16)                  TaskCombatPed(methpedtruckdriver2, GetPlayerPed(-1), 0, 16)
    --[[ TaskVehicleChase(methpedtruckdriver2, GetPlayerPed(-1))   ]]            SetPedVehicleForcedSeatUsage(methpedtruck2, methpedtruck, 0, 1)
    --[[ SetTaskVehicleChaseBehaviorFlag(methpedtruckdriver2, 262144, true) ]]
    SetDriverAbility(methpedtruckdriver2, 1.0)
    --SetPedAsEnemy(methpedtruckdriver2, true)                                   --SetPedAsEnemy(methpedtruck2, true)
    SetPedDropsWeaponsWhenDead(methpedtruckdriver2, false)                       SetPedDropsWeaponsWhenDead(methpedtruck2, false)
        
    SetPedRelationshipGroupHash(methpedtruck3, Group)                      SetPedRelationshipGroupHash(methpedtruck4, Group) -- methpedtruck4 now works, but he is kinda stupid :D
    SetEntityCanBeDamagedByRelationshipGroup(methpedtruck3, false, Group)  SetEntityCanBeDamagedByRelationshipGroup(methpedtruck4, false, Group)
    GiveWeaponToPed(methpedtruck3, "WEAPON_PISTOL", 400, false, true)      GiveWeaponToPed(methpedtruck4, "WEAPON_PISTOL", 400, false, true)
    SetPedCombatAttributes(methpedtruck3, 1, true)                         SetPedCombatAttributes(methpedtruck4, 1, true)
    SetPedCombatAttributes(methpedtruck3, 2, true)                         SetPedCombatAttributes(methpedtruck4, 2, true)
    SetPedCombatAttributes(methpedtruck3, 5, true)	                        SetPedCombatAttributes(methpedtruck4, 5, true)
    SetPedCombatAttributes(methpedtruck3, 16, true)                        SetPedCombatAttributes(methpedtruck4, 16, true)
    SetPedCombatAttributes(methpedtruck3, 26, true)                        SetPedCombatAttributes(methpedtruck4, 26, true)
    SetPedCombatAttributes(methpedtruck3, 46, true)                        SetPedCombatAttributes(methpedtruck4, 46, true)
    SetPedCombatAttributes(methpedtruck3, 52, true)                        SetPedCombatAttributes(methpedtruck4, 52, true)
    SetPedFleeAttributes(methpedtruck3, 0, 0)                              SetPedFleeAttributes(methpedtruck4, 0, 0)
    SetPedPathAvoidFire(methpedtruck3, 1)                                  SetPedPathAvoidFire(methpedtruck4, 1)
    SetPedAlertness(methpedtruck3,3)                                       SetPedAlertness(methpedtruck4,3)
    --[[ SetPedFiringPattern(methpedtruck3, 0xC6EE6B4C) ]]                         SetPedAccuracy(methpedtruck4, 30)
    SetPedAccuracy(methpedtruck3, 30)                                      --[[ SetPedFiringPattern(methpedtruck4, 0xC6EE6B4C) ]]
    SetPedArmour(methpedtruck3, 100)                                       SetPedArmour(methpedtruck4, 100)
    TaskCombatPed(methpedtruck3, GetPlayerPed(-1), 0, 16)                  TaskCombatPed(methpedtruck4, GetPlayerPed(-1), 0, 16)
    SetPedVehicleForcedSeatUsage(methpedtruck3, methtruck2, 0, 1)             SetPedVehicleForcedSeatUsage(methpedtruck4, methtruck2, 0, 1)
        
    SetPedDropsWeaponsWhenDead(methpedtruck3, false)                       SetPedDropsWeaponsWhenDead(methpedtruck4, false)



    --[[
    methpedtruck = CreateVehicle(card, 94.2550, 3458.7771, 39.7593, 10.5330, true, false)
    SetVehicleColours(methpedtruck, 2, 2)
    oke, Group = AddRelationshipGroup("Methhouse")
    methpedtruckdriver = CreatePedInsideVehicle(methpedtruck, 12, ped, -1, true, false)
    --Pheli1 = CreatePedInsideVehicle(methpedtruck, 12, ped, 0, true, false)
    TaskVehicleGotoNavmesh(methpedtruckdriver, methpedtruck, 33.7996, 3682.8708, 39.6799, 29.5784, 156, 5.0)
    SetPedRelationshipGroupHash(methpedtruckdriver, Group)
    SetEntityCanBeDamagedByRelationshipGroup(methpedtruckdriver, false, Group)
    GiveWeaponToPed(methpedtruckdriver, "WEAPON_PISTOL", 400, false, true)
    SetPedCombatAttributes(methpedtruckdriver, 1, true)  
    SetPedFleeAttributes(methpedtruckdriver, 0, 0) 
    SetPedPathAvoidFire(methpedtruckdriver, 1)  
    SetPedAlertness(methpedtruckdriver,3)
    SetPedArmour(methpedtruckdriver, 100)    
    --TaskCombatPed(methpedtruckdriver, GetPlayerPed(-1), 0, 16)
    SetDriverAbility(methpedtruckdriver, 1.0)
    SetPedDropsWeaponsWhenDead(methpedtruckdriver, false)

    Pheli1 = CreatePedInsideVehicle(methpedtruck, 12, Group, 0, true, false)
    SetPedRelationshipGroupHash(Pheli1, Group)    
    SetEntityCanBeDamagedByRelationshipGroup(Pheli1, false, Group)
    GiveWeaponToPed(Pheli1, "WEAPON_PISTOL", 400, false, true)
    SetPedCombatAttributes(Pheli1, 1, true)
    SetPedFleeAttributes(Pheli1, 0, 0)
    SetPedPathAvoidFire(Pheli1, 1)
    SetPedAlertness(Pheli1,1)
    SetPedAccuracy(Pheli1, 30)
    SetPedArmour(Pheli1, 100)
    SetPedVehicleForcedSeatUsage(Pheli1, methpedtruck, 0, 1)
    SetPedDropsWeaponsWhenDead(Pheli1, false)


]]



    --then
end







