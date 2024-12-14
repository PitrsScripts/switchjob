Config = {}


Config.Notifications = {
    type = 'ox' -- ox/okok
}


Config.CommandName = 'changejob'
Config.Cooldown = 15
Config.CooldownMessage = 'The job can be changed once every 15 seconds.\n%s seconds remaining.'
Config.SwitchMessage = 'You are now employed as %s.'



Config.Discord = {

	Enable = true, --true/false
	Message = '**%s** changed his job from **%s** to **%s**.',
	Webhook = '',
	Name = 'CHANGEJOB | LOG',
	Image = 'https://i.imgur.com/PpJ0Ffh.png',
	Color = 3092790 -- Log Color  https://www.rapidtables.com/convert/number/hex-to-decimal.html
}
