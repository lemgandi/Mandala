--[[

   A mandala viewer for the PlayDate game console. Mainly an excuse to experiment with sprites.

   copyright(c) Charles Shapiro August 2024

--]]

import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/crank"
import "CoreLibs/strict"

gfx = playdate.graphics

MandalaGFX = {}
MandalaGFX["Star"] = {gfx.image.new("Images/Star.png")}
MandalaGFX["Spiral"] = {gfx.image.new("Images/Spiral.png")}
MandalaGFX["Line"] = {gfx.image.new("Images/Line.png")}

local CurrentRotation = 0
local ShapeName="Line"

local GameState = {}


function setupMandala()

   for kk,vv in pairs(MandalaGFX)
   do
      table.insert(vv,gfx.sprite.new(vv[1]))
   end
   
   GameState["which"]="Line"
   playdate.datastore.write(GameState)
   
   GameState=playdate.datastore.read()
   ShapeName=GameState["which"]
   
   MandalaGFX[ShapeName][2]:moveTo(200,120)
   MandalaGFX[ShapeName][2]:add()

   gfx.setImageDrawMode(gfx.kDrawModeNXOR)

   
end
-- Main Line starts Here

setupMandala()

function playdate.update()
   do
      local crankTicks=playdate.getCrankTicks(180)

      if crankTicks ~= 0 then
	 CurrentRotation = CurrentRotation + crankTicks	 
	 MandalaGFX[ShapeName][2]:setRotation(CurrentRotation,1,2)
      end      
      gfx.sprite.update()
      MandalaGFX[ShapeName][1]:draw(0,0)
   end   
end
