--[[

   A mandala viewer for the PlayDate game console. Mainly an excuse to experiment with sprites.

   copyright(c) Charles Shapiro August 2024

--]]

import "CoreLibs/graphics"
import "CoreLibs/sprites"

gfx = playdate.graphics

MandalaBackgrounds = {}
MandalaBackgrounds["Star"] = gfx.image.new("Images/Star.png")
MandalaBackgrounds["Spiral"] = gfx.image.new("Images/Spiral.png")



function setupMandala()
   
   MandalaBackgrounds["Spiral"]:draw(0,0)
   
end
-- Main Line starts Here

setupMandala()

function playdate.update()
   do
   end   
end
