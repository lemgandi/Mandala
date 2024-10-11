--[[

   A mandala viewer for the PlayDate game console. Mainly an excuse to experiment with sprites.

   copyright(c) Charles Shapiro August 2024
   
    This file is part of Mandala.
    Mandala is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    Mandala is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    You should have received a copy of the GNU General Public License
    along with Mandala.  If not, see <http://www.gnu.org/licenses/>.

--]]
import "CoreLibs/strict"
import "CoreLibs/graphics"

gfx = playdate.graphics
-- geom = playdate.geometry

-- 30 x 400 block in middle of screen
local LineAreaTop=85
local LineAreaSize = 61


function SetupCenterChangeScreen(currentOffset)
   local limitRect = playdate.geometry.rect.new(0,LineAreaTop,400,LineAreaSize)
   local banner="Up/Down to Change"

   DrawBanner(banner,32,30)
   
   gfx.fillRect(limitRect)
   
end

function ReadCenterChangeScreen()
   local retVal = nil

   
   if playdate.buttonJustPressed(playdate.kButtonA) then
      retVal = 0.512
   elseif playdate.buttonJustPressed(playdate.kButtonB) then
      retVal = 0.5
      print("Recenter some day")
   end
   
					
   return retVal
end
