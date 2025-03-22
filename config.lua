return {
    DrawMarker = true, -- Eğer marker istemiyorsanız buraya false yazın
    EnableFadeOut = true, -- Eğer ekranın solmasını istemiyorsanız bunu devre dışı bırakın

    Elevators = {
        -- Bu sadece bir örnektir 

        [1] = {
            name = 'Ambulance', -- textUI'de gösterilecek isim
            coords = { -- Tabloya koyduğunuz koordinatların sırası, menüde aynı sırayla görünecek, örneğin:
                vector3(296.04, -1447.08, 29.96),  -- 1. kat
                vector3(334.68, -1432.24, 46.52),  -- 2. kat
                vector3(367.8, -1393.6, 76.16)     -- 3. kat ve devamı
            },
            jobs = {'ambulance', 'police'}, -- Eğer iş kontrolü istemiyorsanız buraya false yazın
            Password = "1234" -- Bu asansör için belirlenen şifre
        },
        [2] = {
            name = 'Maze Bank',
            coords = {
                vector3(-69.96, -799.96, 44.24),   -- 1. kat  
                vector3(-75.72, -815.12, 326.16)   -- 2. kat   
            },
            jobs = false,
            Password = "5678" -- Bu asansör için belirlenen şifre
        },
    }
}