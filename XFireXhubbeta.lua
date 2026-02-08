local totalScripts = 2
local carregados = 0

local inicio = tick()

local function scriptCarregado()
	carregados += 1
	
	if carregados >= totalScripts then
		local tempo = tick() - inicio
		print(string.format("%.2f segundos para scripts carregarem", tempo))
	end
end

task.spawn(function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/FIAT258/fiathub2/main/brookhavenxfirexhub.lua"))()
	scriptCarregado()
end)

task.spawn(function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/FIAT258/fiathub2/main/minimizarfirex.lua"))()
	scriptCarregado()
end)
return {
    Version = "1.11"
}
end
