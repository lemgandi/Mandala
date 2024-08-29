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
local currentRotation = 0
function setupMandala()

   for kk,vv in pairs(MandalaGFX)
   do
      table.insert(vv,gfx.sprite.new(vv[1]))
   end
   
   MandalaGFX["Spiral"][1]:draw(0,0)
   MandalaGFX["Line"][2]:moveTo(200,120)
   MandalaGFX["Line"][2]:add()

end
-- Main Line starts Here

setupMandala()

function playdate.update()
   do
      local crankTicks=playdate.getCrankTicks(180)

      if crankTicks ~= 0 then
	 currentRotation = currentRotation + crankTicks	 
	 MandalaGFX["Line"][2]:setRotation(currentRotation)
      end
      
      gfx.sprite.update()
   end   
end
