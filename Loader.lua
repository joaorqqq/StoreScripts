-- [[ ScriptStore Loader - Versão Transparente ]]

local scriptURL = "https://raw.githubusercontent.com/joaorqqq/StoreScripts/refs/heads/main/Main.lua"

-- 1. Verificação de Executor e Funções
local function verificar()
    local executor = (identifyexecutor and identifyexecutor()) or "Desconhecido"
    
    -- Notificação de início
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "ScriptStore",
        Text = "Executando via: " .. executor,
        Duration = 3
    })

    -- Checa se o executor aguenta o tranco (Firebase precisa de request)
    if not request and not http_request and not syn.request then
        warn("AVISO: Seu executor pode ter problemas com o sistema de Likes/Upload (falta de 'request').")
    end
end

-- 2. Carregamento Principal
local function carregar()
    local success, content = pcall(function()
        return game:HttpGet(scriptURL)
    end)

    if success then
        local rodar, erro = loadstring(content)
        if rodar then
            rodar()
        else
            warn("Erro no código principal: " .. tostring(erro))
        end
    else
        warn("Falha ao conectar ao GitHub. Verifique o link ou sua conexão.")
    end
end

verificar()
carregar()

