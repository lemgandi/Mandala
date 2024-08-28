--[[

   A mandala viewer for the PlayDate game console. Mainly an excuse to experiment with sprites.

   copyright(c) Charles Shapiro August 2024

--]]

import "CoreLibs/graphics"
import "CoreLibs/sprites"

gfx = playdate.graphics

MandalaGFX = {}
MandalaGFX["Star"] = {gfx.image.new("Images/Star.png")}
MandalaGFX["Spiral"] = {gfx.image.new("Images/Spiral.png")}


function setupMandala()
   print(type(MandalaGFX))
   for kk,vv in pairs(MandalaGFX)
   do     
      table.insert(vv,gfx.sprite.new(vv[1]))
   end
   
--   MandalaGFX["Star"][1]:draw(0,0)
   MandalaGFX["Star"][2]:moveTo(100,100)
   MandalaGFX["Star"][2]:add()
   MandalaGFX["Star"][2]:setRotation(5)
   print("Visible:",MandalaGFX["Star"][2]:isVisible())
end
-- Main Line starts Here

setupMandala()

function playdate.update()
   do
   end   
end
