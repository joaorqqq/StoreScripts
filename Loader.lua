-- [[ ScriptStore Loader Oficial - v1.0.0 ]]
-- Link: https://raw.githubusercontent.com/joaorqqq/StoreScripts/refs/heads/main/Loader.lua

local scriptURL = "https://raw.githubusercontent.com/joaorqqq/StoreScripts/refs/heads/main/Main.lua"

-- 1. Verificação e Notificação
local function inicializar()
    local executor = (identifyexecutor and identifyexecutor()) or "Desconhecido"
    
    -- Notificação visual para o usuário
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "ScriptStore 🛒",
            Text = "Executando via: " .. executor,
            Duration = 4
        })
    end)

    -- Alerta técnico no console (F9)
    if not request and not http_request and not syn.request then
        warn("ScriptStore: Seu executor não possui a função 'request'. Recursos de Likes e Upload podem não funcionar.")
    end
end

-- 2. Carregamento Direto e Seguro
local function carregar()
    -- Tenta baixar o conteúdo do Main.lua
    local success, content = pcall(function()
        return game:HttpGet(scriptURL)
    end)

    if success and content then
        -- Tenta transformar o texto baixado em um script executável
        local rodar, erro = loadstring(content)
        if rodar then
            rodar() -- Executa a Loja (Main.lua)
        else
            warn("Erro de sintaxe no Main.lua: " .. tostring(erro))
        end
    else
        warn("Erro de conexão: Não foi possível baixar o Main.lua do GitHub.")
    end
end

-- Execução
inicializar()
carregar()
