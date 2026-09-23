local function part(name,size,pos,color)
 local p=Instance.new("Part");p.Name=name;p.Size=size;p.Position=pos;p.Anchored=true;p.Color=color;p.Material=Enum.Material.SmoothPlastic;p.Parent=workspace;return p
end
local base=part("MutationLab",Vector3.new(150,2,150),Vector3.new(0,-1,0),Color3.fromRGB(35,39,37))
local spawn=Instance.new("SpawnLocation");spawn.Size=Vector3.new(12,1,12);spawn.Position=Vector3.new(0,.5,0);spawn.Anchored=true;spawn.Neutral=true;spawn.Color=Color3.fromRGB(80,255,80);spawn.Parent=workspace
local defs={{"Crate",0,5,Color3.fromRGB(130,90,50)},{"Barrel",10,12,Color3.fromRGB(60,180,70)},{"Rock",25,25,Color3.fromRGB(100,100,100)},{"Car",50,60,Color3.fromRGB(80,140,220)},{"Tank",100,150,Color3.fromRGB(70,90,60)}}
for row,d in ipairs(defs) do
 for i=1,5 do
  local x=-45+(i-1)*22
  local z=-45+(row-1)*22
  local p=part(d[1],Vector3.new(8+row,6+row,8+row),Vector3.new(x,(6+row)/2,z),d[4])
  p:SetAttribute("MutationNeed",d[2]);p:SetAttribute("DNAReward",d[3])
  local bill=Instance.new("BillboardGui");bill.Size=UDim2.fromOffset(140,45);bill.StudsOffset=Vector3.new(0,6+row/2,0);bill.AlwaysOnTop=true;bill.Parent=p
  local l=Instance.new("TextLabel");l.Size=UDim2.fromScale(1,1);l.BackgroundTransparency=1;l.TextColor3=Color3.new(1,1,1);l.TextStrokeTransparency=.2;l.Font=Enum.Font.GothamBold;l.TextScaled=true;l.Text=d[1].." • "..d[2].." 🧬";l.Parent=bill
 end
end
for i=1,18 do
 local a=i/18*math.pi*2; local p=part("LabWall",Vector3.new(10,18,3),Vector3.new(math.cos(a)*72,9,math.sin(a)*72),Color3.fromRGB(25,45,31));p.CFrame=CFrame.new(p.Position)*CFrame.Angles(0,-a,0)
end
workspace.FallenPartsDestroyHeight=-40