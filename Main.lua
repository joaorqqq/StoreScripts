-- [[ ScriptStore.lua - Plataforma de Scripts ]]
-- Autor: joaorqqq

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LP = Players.LocalPlayer

-- URL DO SEU BANCO DE DADOS
local FirebaseURL = "https://aleatoria-4cd46-default-rtdb.firebaseio.com/Scripts"

-- [[ INTERFACE NATIVA ]]
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "ScriptStore_App"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 580, 0, 430)
MainFrame.Position = UDim2.new(0.5, -290, 0.5, -215)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame)

-- Janela de Código Fonte (Pop-up)
local SourceFrame = Instance.new("Frame", ScreenGui)
SourceFrame.Size = UDim2.new(0, 500, 0, 380)
SourceFrame.Position = UDim2.new(0.5, -250, 0.5, -190)
SourceFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
SourceFrame.Visible = false
SourceFrame.ZIndex = 10
Instance.new("UICorner", SourceFrame)

local SourceText = Instance.new("TextBox", SourceFrame)
SourceText.Size = UDim2.new(1, -20, 1, -60)
SourceText.Position = UDim2.new(0, 10, 0, 10)
SourceText.MultiLine = true
SourceText.ReadOnly = true
SourceText.TextXAlignment = "Left"
SourceText.TextYAlignment = "Top"
SourceText.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
SourceText.TextColor3 = Color3.fromRGB(0, 255, 100)
SourceText.ClearTextOnFocus = false
SourceText.Text = ""

local CloseSource = Instance.new("TextButton", SourceFrame)
CloseSource.Size = UDim2.new(1, 0, 0, 40)
CloseSource.Position = UDim2.new(0, 0, 1, -40)
CloseSource.Text = "FECHAR VISUALIZADOR"
CloseSource.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
CloseSource.TextColor3 = Color3.new(1,1,1)
CloseSource.MouseButton1Click:Connect(function() SourceFrame.Visible = false end)

-- [[ NAVBAR ]]
local Nav = Instance.new("Frame", MainFrame)
Nav.Size = UDim2.new(1, 0, 0, 50)
Nav.BackgroundTransparency = 1
local NavLayout = Instance.new("UIListLayout", Nav)
NavLayout.FillDirection = "Horizontal"
NavLayout.Padding = UDim.new(0, 10)
NavLayout.HorizontalAlignment = "Center"
NavLayout.VerticalAlignment = "Center"

local function CreateNavBtn(text)
    local b = Instance.new("TextButton", Nav)
    b.Size = UDim2.new(0, 110, 0, 35)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.SourceSansBold
    Instance.new("UICorner", b)
    return b
end

local btnLoja = CreateNavBtn("Loja 🛒")
local btnPostar = CreateNavBtn("Publicar 🚀")
local btnPerfil = CreateNavBtn("Perfil 👤")

local SearchBox = Instance.new("TextBox", MainFrame)
SearchBox.Size = UDim2.new(0, 150, 0, 30)
SearchBox.Position = UDim2.new(1, -165, 0, 60)
SearchBox.PlaceholderText = "🔍 Buscar..."
SearchBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
SearchBox.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", SearchBox)

-- [[ CONTAINERS ]]
local Container = Instance.new("ScrollingFrame", MainFrame)
Container.Size = UDim2.new(1, -20, 1, -110)
Container.Position = UDim2.new(0, 10, 0, 100)
Container.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
Container.CanvasSize = UDim2.new(0, 0, 0, 0)
Container.AutomaticCanvasSize = "Y"
Container.ScrollBarThickness = 4
local ListLayout = Instance.new("UIListLayout", Container)
ListLayout.Padding = UDim.new(0, 8)

local PostFrame = Instance.new("Frame", MainFrame)
PostFrame.Size = Container.Size
PostFrame.Position = Container.Position
PostFrame.Visible = false
PostFrame.BackgroundTransparency = 1

-- Formulário de Upload
local InpName = Instance.new("TextBox", PostFrame)
InpName.Size = UDim2.new(1, -40, 0, 40)
InpName.Position = UDim2.new(0, 20, 0, 10)
InpName.PlaceholderText = "Nome do Script"
InpName.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
InpName.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", InpName)

local InpUrl = Instance.new("TextBox", PostFrame)
InpUrl.Size = UDim2.new(1, -40, 0, 160)
InpUrl.Position = UDim2.new(0, 20, 0, 60)
InpUrl.PlaceholderText = "Cole a URL RAW do GitHub ou o código aqui..."
InpUrl.MultiLine = true
InpUrl.TextYAlignment = "Top"
InpUrl.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
InpUrl.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", InpUrl)

local btnFinalPost = Instance.new("TextButton", PostFrame)
btnFinalPost.Size = UDim2.new(1, -40, 0, 50)
btnFinalPost.Position = UDim2.new(0, 20, 0, 230)
btnFinalPost.Text = "SUBIR PARA A NUVEM 🚀"
btnFinalPost.BackgroundColor3 = Color3.fromRGB(0, 150, 80)
btnFinalPost.TextColor3 = Color3.new(1,1,1)
btnFinalPost.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", btnFinalPost)

-- [[ LÓGICA DO FIREBASE ]]

local function UpdateStat(id, stat)
    local current = 0
    pcall(function()
        current = tonumber(game:HttpGet(FirebaseURL.."/"..id.."/"..stat..".json")) or 0
    end)
    request({
        Url = FirebaseURL.."/"..id.."/"..stat..".json",
        Method = "PUT",
        Body = tostring(current + 1)
    })
end

local function CreateCard(id, info)
    local card = Instance.new("Frame", Container)
    card.Size = UDim2.new(1, -10, 0, 100)
    card.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Instance.new("UICorner", card)

    local title = Instance.new("TextLabel", card)
    title.Text = "  " .. info.Nome .. " | Autor: " .. info.Autor
    title.Size = UDim2.new(1, 0, 0, 30)
    title.TextColor3 = Color3.new(1,1,1)
    title.TextXAlignment = "Left"
    title.BackgroundTransparency = 1

    local stats = Instance.new("TextLabel", card)
    stats.Text = "  ❤️ " .. (info.Likes or 0) .. "  |  📥 " .. (info.Downloads or 0)
    stats.Position = UDim2.new(0, 0, 0, 30)
    stats.Size = UDim2.new(1, 0, 0, 20)
    stats.TextColor3 = Color3.new(0.6, 0.6, 0.6)
    stats.TextXAlignment = "Left"
    stats.BackgroundTransparency = 1

    local function b(txt, pos, color, callback)
        local btn = Instance.new("TextButton", card)
        btn.Size = UDim2.new(0, 110, 0, 30)
        btn.Position = pos
        btn.Text = txt
        btn.BackgroundColor3 = color
        btn.TextColor3 = Color3.new(1,1,1)
        Instance.new("UICorner", btn)
        btn.MouseButton1Click:Connect(callback)
    end

    b("Executar", UDim2.new(0, 10, 0, 60), Color3.fromRGB(0, 120, 200), function()
        UpdateStat(id, "Downloads")
        loadstring(game:HttpGet(info.Url))()
    end)

    b("Ver Código", UDim2.new(0, 130, 0, 60), Color3.fromRGB(80, 80, 80), function()
        SourceText.Text = "Carregando código fonte..."
        SourceFrame.Visible = true
        local success, code = pcall(function() return game:HttpGet(info.Url) end)
        SourceText.Text = success and code or "Erro ao carregar código."
    end)

    b("Amei ❤️", UDim2.new(0, 250, 0, 60), Color3.fromRGB(200, 50, 50), function()
        UpdateStat(id, "Likes")
    end)

    if info.Autor == LP.Name then
        b("Excluir", UDim2.new(1, -115, 0, 60), Color3.fromRGB(150, 0, 0), function()
            request({Url = FirebaseURL.."/"..id..".json", Method = "DELETE"})
            card:Destroy()
        end)
    end
end

local function Refresh(filter, onlyMine)
    for _, v in pairs(Container:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    local success, response = pcall(function() return game:HttpGet(FirebaseURL..".json") end)
    
    if success and response ~= "null" then
        local data = HttpService:JSONDecode(response)
        for id, info in pairs(data) do
            local searchMatch = not filter or info.Nome:lower():find(filter:lower())
            local userMatch = not onlyMine or info.Autor == LP.Name
            if searchMatch and userMatch then
                CreateCard(id, info)
            end
        end
    end
end

-- [[ EVENTOS ]]
btnLoja.MouseButton1Click:Connect(function() PostFrame.Visible = false; Container.Visible = true; Refresh() end)
btnPerfil.MouseButton1Click:Connect(function() PostFrame.Visible = false; Container.Visible = true; Refresh(nil, true) end)
btnPostar.MouseButton1Click:Connect(function() Container.Visible = false; PostFrame.Visible = true end)
SearchBox:GetPropertyChangedSignal("Text"):Connect(function() Refresh(SearchBox.Text) end)

btnFinalPost.MouseButton1Click:Connect(function()
    if InpName.Text ~= "" and InpUrl.Text ~= "" then
        request({
            Url = FirebaseURL..".json",
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({
                Nome = InpName.Text,
                Url = InpUrl.Text,
                Autor = LP.Name,
                Likes = 0,
                Downloads = 0
            })
        })
        InpName.Text = ""; InpUrl.Text = ""
        btnLoja:Invoke() -- Simula clique para atualizar
    end
end)

-- Botão de Fechar
local CloseMain = Instance.new("TextButton", MainFrame)
CloseMain.Size = UDim2.new(0, 30, 0, 30)
CloseMain.Position = UDim2.new(1, -35, 0, 5)
CloseMain.Text = "X"
CloseMain.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
CloseMain.TextColor3 = Color3.new(1,1,1)
CloseMain.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

Refresh()

