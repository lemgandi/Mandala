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

function drawScaleScreen(cf,sh)
   
   gfx.clear()
   
   DrawBanner("Change Still Shape Size",nil,0)
   
   local xPlace = 0
   local yPlace = 0
   local scale = 1
   
   if cf.rearscale then
      scale = cf.rearscale
      xPlace,yPlace = computeScaleXY(scale)
   end
   sh:drawScaled(xPlace,yPlace,scale)
					   
end

function readScaleScreen(cf)

   local oldScale=cf.scale
   local newScale=0.5
   local retVal = nil
   
   if playdate.buttonJustPressed(playdate.kButtonB) then
      retVal = "kButtonB"
   elseif playdate.buttonJustPressed(playdate.kButtonA) then
      retVal = 0.5
   end
   
   return retVal
end
