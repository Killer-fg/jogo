local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local UIS=game:GetService("UserInputService")
local TweenService=game:GetService("TweenService")
local p=Players.LocalPlayer
local rem=RS:WaitForChild("Remotes")
local Config=require(RS.Shared.Config)

local gui=Instance.new("ScreenGui"); gui.Name="MutationUI"; gui.ResetOnSpawn=false; gui.Parent=p.PlayerGui
local function round(x,r) local u=Instance.new("UICorner");u.CornerRadius=UDim.new(0,r or 14);u.Parent=x end
local top=Instance.new("Frame"); top.Size=UDim2.fromOffset(330,92);top.Position=UDim2.new(.5,-165,0,18);top.BackgroundColor3=Color3.fromRGB(17,22,20);top.BackgroundTransparency=.08;top.Parent=gui;round(top,18)
local title=Instance.new("TextLabel");title.Size=UDim2.new(1,-20,0,42);title.Position=UDim2.fromOffset(10,5);title.BackgroundTransparency=1;title.Font=Enum.Font.GothamBold;title.TextScaled=true;title.TextColor3=Color3.fromRGB(126,255,91);title.Parent=top
local next=Instance.new("TextLabel");next.Size=UDim2.new(1,-20,0,30);next.Position=UDim2.fromOffset(10,50);next.BackgroundTransparency=1;next.Font=Enum.Font.GothamMedium;next.TextScaled=true;next.TextColor3=Color3.new(1,1,1);next.Parent=top
local dna=Instance.new("TextLabel");dna.Size=UDim2.fromOffset(220,52);dna.Position=UDim2.fromOffset(18,125);dna.BackgroundColor3=Color3.fromRGB(17,22,20);dna.Font=Enum.Font.GothamBold;dna.TextScaled=true;dna.TextColor3=Color3.fromRGB(170,255,140);dna.Parent=gui;round(dna)
local function button(text,pos)
 local b=Instance.new("TextButton");b.Size=UDim2.fromOffset(170,52);b.AnchorPoint=Vector2.new(1,1);b.Position=pos;b.BackgroundColor3=Color3.fromRGB(72,190,62);b.TextColor3=Color3.new(1,1,1);b.Font=Enum.Font.GothamBold;b.TextScaled=true;b.Text=text;b.Parent=gui;round(b);return b
end
local up=button("UPGRADES",UDim2.new(1,-18,1,-80))
local reb=button("REBIRTH",UDim2.new(1,-18,1,-18))
local panel=Instance.new("Frame");panel.Size=UDim2.fromOffset(310,250);panel.Position=UDim2.new(1,-328,1,-392);panel.BackgroundColor3=Color3.fromRGB(15,20,17);panel.Visible=false;panel.Parent=gui;round(panel,18)
for i,k in ipairs({"Mutation","DNA","Speed"}) do
 local b=Instance.new("TextButton");b.Size=UDim2.new(1,-24,0,60);b.Position=UDim2.fromOffset(12,12+(i-1)*72);b.BackgroundColor3=Color3.fromRGB(39,86,42);b.TextColor3=Color3.new(1,1,1);b.Font=Enum.Font.GothamBold;b.TextScaled=true;b.Text="UPGRADE "..string.upper(k);b.Parent=panel;round(b);b.Activated:Connect(function() rem.BuyUpgrade:FireServer(k) end)
end
up.Activated:Connect(function() panel.Visible=not panel.Visible end)
reb.Activated:Connect(function() rem.Rebirth:FireServer() end)
local function update()
 local m=p:GetAttribute("Mutation") or 0; local d=p:GetAttribute("DNA") or 0
 title.Text="🧬 "..math.floor(m).." MUTATION"
 dna.Text="🧬 DNA: "..math.floor(d)
 local nxt
 for _,v in ipairs(Config.Mutations) do if v.Need>m then nxt=v;break end end
 next.Text=nxt and ("NEXT: "..nxt.Name.." • "..math.floor(m).."/"..nxt.Need) or "MAX MUTATION"
end
for _,a in ipairs({"Mutation","DNA","MutationName"}) do p:GetAttributeChangedSignal(a):Connect(update) end
update()
local mouse=p:GetMouse()
mouse.Button1Down:Connect(function()
 local t=mouse.Target;if t then rem.Smash:FireServer(t) end
end)
rem.FX.OnClientEvent:Connect(function(kind)
 local old=top.Size; TweenService:Create(top,TweenInfo.new(.12),{Size=UDim2.fromOffset(350,102)}):Play()
 task.delay(.13,function() TweenService:Create(top,TweenInfo.new(.18),{Size=old}):Play() end)
end)