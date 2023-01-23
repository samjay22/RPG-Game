local StatusEffectsManager = {}


local ActiveEffects = {}


function StatusEffectsManager.RemoveEffect(Key)
	if ActiveEffects[Key] then
		ActiveEffects[Key]:Destroy()
	end
end

function StatusEffectsManager.NewEffect(Key, Image)
	
	local Template = script.Template:Clone()
	local Player = game.Players.LocalPlayer
	local PGUI = Player.PlayerGui.Display
	local Effects = PGUI.CharacterStats.Effects
	Template.Image = Image
	Template.Parent = Effects
	
	ActiveEffects[Key] = Template
	
end

return StatusEffectsManager
