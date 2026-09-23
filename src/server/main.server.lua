local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local DSS=game:GetService("DataStoreService")
local Config=require(RS.Shared.Config)
local store=DSS:GetDataStore("MutationV1")

local remotes=Instance.new("Folder"); remotes.Name="Remotes"; remotes.Parent=RS
local smash=Instance.new("RemoteEvent"); smash.Name="Smash"; smash.Parent=remotes
local buy=Instance.new("RemoteEvent"); buy.Name="BuyUpgrade"; buy.Parent=remotes
local rebirth=Instance.new("RemoteEvent"); rebirth.Name="Rebirth"; rebirth.Parent=remotes
local fx=Instance.new("RemoteEvent"); fx.Name="FX"; fx.Parent=remotes

local data={}
local function default() return {Mutation=0,DNA=0,Rebirths=0,MutationUpgrade=0,DNAUpgrade=0,SpeedUpgrade=0} end
local function stage(v)
 local best=Config.Mutations[1]
 for _,m in ipairs(Config.Mutations) do if v>=m.Need then best=m else break end end
 return best
end
local function apply(p)
 local d=data[p]; local c=p.Character if not d or not c then return end
 local hum=c:FindFirstChildOfClass("Humanoid"); if not hum then return end
 local s=stage(d.Mutation)
 hum.WalkSpeed=16+d.SpeedUpgrade*2
 p:SetAttribute("MutationName",s.Name)
 for _,n in ipairs({"BodyHeightScale","BodyWidthScale","BodyDepthScale","HeadScale"}) do
  local x=hum:FindFirstChild(n); if x then x.Value=s.Scale end
 end
 for _,v in ipairs(c:GetDescendants()) do
  if v:IsA("BasePart") and v.Name~="HumanoidRootPart" then v.Color=s.Color end
 end
end
local function sync(p)
 local d=data[p]; if not d then return end
 for k,v in pairs(d) do p:SetAttribute(k,v) end
 apply(p)
end
Players.PlayerAdded:Connect(function(p)
 local d
 pcall(function() d=store:GetAsync(tostring(p.UserId)) end)
 data[p]=type(d)=="table" and d or default()
 sync(p)
 p.CharacterAdded:Connect(function() task.wait(1); apply(p) end)
 task.spawn(function()
  while p.Parent do
   task.wait(1)
   local x=data[p]; if not x then break end
   local old=stage(x.Mutation).Name
   x.Mutation += (Config.MutationPerSecond+x.MutationUpgrade)*(1+x.Rebirths)
   sync(p)
   if stage(x.Mutation).Name~=old then fx:FireClient(p,"Mutation") end
  end
 end)
end)
local function save(p)
 local d=data[p]; if d then pcall(function() store:SetAsync(tostring(p.UserId),d) end) end
end
Players.PlayerRemoving:Connect(function(p) save(p); data[p]=nil end)
game:BindToClose(function() for _,p in ipairs(Players:GetPlayers()) do save(p) end end)

buy.OnServerEvent:Connect(function(p,kind)
 local d=data[p]; local cfg=Config.Upgrades[kind]; if not d or not cfg then return end
 local key=kind.."Upgrade"; local lvl=d[key] or 0
 local cost=math.floor(cfg.Base*(cfg.Growth^lvl))
 if d.DNA>=cost then d.DNA-=cost; d[key]=lvl+1; sync(p) end
end)
rebirth.OnServerEvent:Connect(function(p)
 local d=data[p]; if d and d.Mutation>=Config.RebirthNeed*(d.Rebirths+1) then
  d.Rebirths+=1; d.Mutation=0; sync(p); fx:FireClient(p,"Rebirth")
 end
end)
smash.OnServerEvent:Connect(function(p,target)
 local d=data[p]; if not d or typeof(target)~="Instance" or not target:IsDescendantOf(workspace) then return end
 local c=p.Character; local root=c and c:FindFirstChild("HumanoidRootPart")
 if not root or not target:IsA("BasePart") or (target.Position-root.Position).Magnitude>Config.SmashDistance then return end
 local need=target:GetAttribute("MutationNeed"); local reward=target:GetAttribute("DNAReward")
 if type(need)~="number" or type(reward)~="number" or d.Mutation<need or target:GetAttribute("Broken") then return end
 target:SetAttribute("Broken",true); target.CanCollide=false; target.Transparency=1
 d.DNA += math.floor(reward*(1+d.DNAUpgrade*.25)); sync(p); fx:FireClient(p,"Smash")
 task.delay(5,function() if target.Parent then target.Transparency=0; target.CanCollide=true; target:SetAttribute("Broken",false) end end)
end)