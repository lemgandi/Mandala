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
   -- MandalaGFX["Line"][2]:setCenter(0.5,0.429)
   MandalaGFX["Line"][2]:moveTo(200,120)
   MandalaGFX["Line"][2]:add()

   gfx.setImageDrawMode(gfx.kDrawModeNXOR)

   
end
-- Main Line starts Here

setupMandala()

function playdate.update()
   do
      local crankTicks=playdate.getCrankTicks(180)

      if crankTicks ~= 0 then
	 currentRotation = currentRotation + crankTicks	 
	 MandalaGFX["Line"][2]:setRotation(currentRotation,1,2)
      end      
      gfx.sprite.update()
      MandalaGFX["Line"][1]:draw(0,0)
      local cx,cy = MandalaGFX["Line"][2]:getCenterPoint():unpack()
      cx = cx*400
      cy = cy*240
--      print("cx:",cx,"cy:",cy) cx:200 cy:120
      gfx.drawCircleAtPoint(cx,cy,5)
   end   
end
