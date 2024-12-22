local cooldown = {}

local function SendNotification(source, title, message, type, duration)
    if Config.Notifications.type == 'ox' then
        TriggerClientEvent('ox_lib:notify', source, {
            title = title,
            description = message,
            type = type
        })
    elseif Config.Notifications.type == 'okok' then
        TriggerClientEvent('okokNotify:Alert', source, title, message, duration, type)
    end
end

RegisterCommand(Config.CommandName, function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if cooldown[xPlayer.source] == nil or (GetGameTimer() - cooldown[xPlayer.source]) * 0.001 >= Config.Cooldown then
        MySQL.query('SELECT secondjob, secondjob_grade FROM users WHERE identifier = ?', {
            xPlayer.identifier
        }, function(result)
            if result[1] ~= nil and result[1].secondjob ~= nil and result[1].secondjob_grade ~= nil then
                MySQL.update('UPDATE users SET secondjob = @secondjob, secondjob_grade = @secondjob_grade WHERE identifier = @identifier', { 
                    secondjob = xPlayer.job.name,
                    secondjob_grade = xPlayer.job.grade,
                    identifier = xPlayer.identifier,
                }, function(rows)
                    if rows ~= 0 then
                        if Config.Discord.Enable then
                            SendToDiscord(string.format(Config.Discord.Message, xPlayer.name, xPlayer.job.name..' `'..xPlayer.job.grade..'`', result[1].secondjob.. ' `'..result[1].secondjob_grade..'`'))
                        end
                        xPlayer.setJob(result[1].secondjob, result[1].secondjob_grade)
                        xPlayer = ESX.GetPlayerFromId(xPlayer.source)

                        if Config.SwitchMessage ~= '' then
                            local message = string.format(Config.SwitchMessage, xPlayer.job.label..': '..xPlayer.job.grade_label)
                            SendNotification(source, 'Úspěch', message, 'success', 5000)
                        end
                        cooldown[xPlayer.source] = GetGameTimer()
                    end
                end)
            end
        end)
    else
        local cooldownTime = math.ceil(Config.Cooldown - (GetGameTimer() - cooldown[xPlayer.source]) * 0.001)
        local cooldownMessage = string.format(Config.CooldownMessage, cooldownTime)
        SendNotification(source, 'Chyba', cooldownMessage, 'error', 5000)
    end
end)


RegisterCommand("job", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local jobName = xPlayer.job.label
        local jobGrade = xPlayer.job.grade_label
        local jobMessage = string.format("Vaše aktuální práce je: %s (%s)", jobName, jobGrade)
        SendNotification(source, 'Informace', jobMessage, 'info', 5000)
    end
end, false)

if Config.Discord.Enable then
	SendToDiscord = function(msg)
		local embed = {{ color = Config.Discord.Color, description = msg }}
	        PerformHttpRequest(Config.Discord.Webhook, function(err, text, headers) end, 'POST', json.encode({username = Config.Discord.Name, embeds = embed, avatar_url = Config.Discord.Image}), { ['Content-Type'] = 'application/json' })
	end
end



MySQL.update('ALTER TABLE users ADD COLUMN IF NOT EXISTS secondjob VARCHAR(50) NOT NULL DEFAULT "unemployed"')
MySQL.update('ALTER TABLE users ADD COLUMN IF NOT EXISTS secondjob_grade INT(11) NOT NULL DEFAULT 0')
