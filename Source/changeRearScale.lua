--[[

   Change scale of still shape

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
local myShape

function drawShape(sh,sc)

   local xPlace,yPlace = computeScaleXY(sc)
   sh:drawScaled(xPlace,yPlace,sc,sc)
   
end

function drawScaleScreenBackground()
   DrawBanner("Change Still Shape Size",nil,0)
end

function drawScaleScreen(cf,sh)
   
   gfx.clear()
   
   drawScaleScreenBackground()

   myShape = sh
   if cf.rearscale then
      drawShape(myShape,cf.rearscale)
   else
      drawShape(myShape,1)
   end
   
end

function readScaleScreen(cf)

   local oldScale=cf.scale
   local newScale=0.5
   local retVal = nil
   
   if playdate.buttonJustPressed(playdate.kButtonB) then
      retVal = "kButtonB"
   elseif playdate.buttonJustPressed(playdate.kButtonUp) then
      newScale = newScale + 0.1
      gfx.clear()
      drawScaleScreenBackground()
      drawShape(myShape,newScale)
   elseif playdate.buttonJustPressed(playdate.kButtonDown) then
      newScale = newScale - 0.1
      if newScale < 0.5 then
	 newScale = 1
      end
      gfx.clear()
      drawScaleScreenBackground()
      drawShape(myShape,newScale)
   elseif playdate.buttonJustPressed(playdate.kButtonLeft) then
      newScale = 1
      gfx.clear()
      drawScaleScreenBackground()
      drawShape(myShape,newScale)
   elseif playdate.buttonJustPressed(playdate.kButtonA) then
      retVal = newScale
   end
   
   return retVal
end
