local QBCore = exports['qb-core']:GetCoreObject()

local canTake = false

CreateThread(function()
    local blip = AddBlipForCoord(Config.PawnLocation.coords.x, Config.PawnLocation.coords.y, Config.PawnLocation.coords.z)
    SetBlipSprite(blip, 93)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.7)
    SetBlipAsShortRange(blip, true)
    SetBlipColour(blip, 5)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(Lang:t('info.title'))
    EndTextCommandSetBlipName(blip)
end)

local coordonate = {
    {Config.PawnLocation.coords.x, Config.PawnLocation.coords.y +0.3, Config.PawnLocation.coords.z -1.0,"Wine buyer",248.86,0xC99F21C4,"a_m_y_business_01"},
}

Citizen.CreateThread(function()

    for _,v in pairs(coordonate) do
      RequestModel(GetHashKey(v[7]))
      while not HasModelLoaded(GetHashKey(v[7])) do
        Wait(1)
      end
  
      RequestAnimDict("amb@code_human_cower@male@idle_a")
      while not HasAnimDictLoaded("amb@code_human_cower@male@idle_a") do
        Wait(1)
      end
      ped =  CreatePed(4, v[6],v[1],v[2],v[3], 3374176, false, true)
      SetEntityHeading(ped, v[5])
      FreezeEntityPosition(ped, true)
      SetEntityInvincible(ped, true)
      SetBlockingOfNonTemporaryEvents(ped, true)
      TaskPlayAnim(ped,"amb@code_human_cower@male@idle_a","base", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
    end
end)

if Config.UseTarget then
    CreateThread(function()
        exports['qb-target']:AddBoxZone('WineShop', Config.PawnLocation.coords, Config.PawnLocation.length, Config.PawnLocation.width, {
            name = 'WineShop',
            heading = Config.PawnLocation.heading,
            minZ = Config.PawnLocation.minZ,
            maxZ = Config.PawnLocation.maxZ,
            debugPoly = Config.PawnLocation.debugPoly,
        }, {
            options = {
                {
                    type = 'client',
                    event = 'qb-pawnshop:client:openMenu',
                    icon = 'fas fa-ring',
                    label = 'Wine Buyer',
                },
            },
            distance = Config.PawnLocation.distance
        })
    end)
else
    CreateThread(function()
        local zone = BoxZone:Create(Config.PawnLocation.coords, Config.PawnLocation.length, Config.PawnLocation.width, {
            name = 'box_zone',
            heading = Config.PawnLocation.heading,
            minZ = Config.PawnLocation.minZ,
            maxZ = Config.PawnLocation.maxZ,
        })
        local pawnShopCombo = ComboZone:Create({ zone }, { name = 'wineshopZone', debugPoly = Config.PawnLocation.debugPoly })
        pawnShopCombo:onPlayerInOut(function(isPointInside)
            if isPointInside then
                exports['qb-menu']:showHeader({
                    {
                        header = Lang:t('info.title'),
                        txt = Lang:t('info.open_pawn'),
                        params = {
                            event = 'qb-pawnshop:client:openMenu'
                        }
                    }
                })
            else
                exports['qb-menu']:closeMenu()
            end
        end)
    end)
end

RegisterNetEvent('qb-pawnshop:client:openMenu', function()
    if Config.UseTimes then
        if GetClockHours() >= Config.TimeOpen and GetClockHours() <= Config.TimeClosed then
            local pawnShop = {
                {
                    header = Lang:t('info.title'),
                    isMenuHeader = true,
                },
                {
                    header = Lang:t('info.sell'),
                    txt = Lang:t('info.sell_pawn'),
                    params = {
                        event = 'qb-pawnshop:client:openPawn',
                        args = {
                            items = Config.PawnItems
                        }
                    }
                }
            }

            if canTake then
                pawnShop[#pawnShop + 1] = {
                    txt = '',
                    params = {
                        isServer = true,
                        args = {
                        }
                    }
                }
            end
            exports['qb-menu']:openMenu(pawnShop)
        else
            QBCore.Functions.Notify(Lang:t('info.pawn_closed', { value = Config.TimeOpen, value2 = Config.TimeClosed }))
        end
    else
        local pawnShop = {
            {
                header = Lang:t('info.title'),
                isMenuHeader = true,
            },
            {
                header = Lang:t('info.sell'),
                txt = Lang:t('info.sell_pawn'),
                params = {
                    event = 'qb-pawnshop:client:openPawn',
                    args = {
                        items = Config.PawnItems
                    }
                }
            }
        }

        if canTake then
            pawnShop[#pawnShop + 1] = {
                txt = '',
                params = {
                    isServer = true,
                    args = {
                    }
                }
            }
        end
        exports['qb-menu']:openMenu(pawnShop)
    end
end)

RegisterNetEvent('qb-pawnshop:client:openPawn', function(data)
    QBCore.Functions.TriggerCallback('qb-pawnshop:server:getInv', function(inventory)
        local PlyInv = inventory
        local pawnMenu = {
            {
                header = Lang:t('info.title'),
                isMenuHeader = true,
            }
        }
        for _, v in pairs(PlyInv) do
            for i = 1, #data.items do
                if v.name == data.items[i].item then
                    pawnMenu[#pawnMenu + 1] = {
                        header = QBCore.Shared.Items[v.name].label,
                        txt = Lang:t('info.sell_items', { value = data.items[i].price }),
                        params = {
                            event = 'qb-pawnshop:client:pawnitems',
                            args = {
                                label = QBCore.Shared.Items[v.name].label,
                                price = data.items[i].price,
                                name = v.name,
                                amount = v.amount
                            }
                        }
                    }
                end
            end
        end
        pawnMenu[#pawnMenu + 1] = {
            header = Lang:t('info.back'),
            params = {
                event = 'qb-pawnshop:client:openMenu'
            }
        }
        exports['qb-menu']:openMenu(pawnMenu)
    end)
end)


RegisterNetEvent('qb-pawnshop:client:pawnitems', function(item)
    local sellingItem = exports['qb-input']:ShowInput({
        header = Lang:t('info.title'),
        submitText = Lang:t('info.sell'),
        inputs = {
            {
                type = 'number',
                isRequired = false,
                name = 'amount',
                text = Lang:t('info.max', { value = item.amount })
            }
        }
    })
    if sellingItem then
        if not sellingItem.amount then
            return
        end

        if tonumber(sellingItem.amount) > 0 then
            TriggerServerEvent('qb-pawnshop:server:sellPawnItems', item.name, sellingItem.amount, item.price)
        else
            QBCore.Functions.Notify(Lang:t('error.negative'), 'error')
        end
    end
end)



RegisterNetEvent('qb-pawnshop:client:resetPickup', function()
    canTake = false
end)
