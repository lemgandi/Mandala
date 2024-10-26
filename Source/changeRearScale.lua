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

local gfx = playdate.graphics

local myShape
local NewScale=0.5

function drawShape(sh,sc)

   local xPlace,yPlace = computeScaleXY(sc)
   sh:drawScaled(xPlace,yPlace,sc,sc)
   
end

function drawScaleScreenBackground()
   local textHeight = _G.allFont:getHeight()
   
   DrawBanner("Change Still Shape Size",nil,0)
   gfx.drawText("U/D change size,",0,textHeight)
   gfx.drawText("L scale=1,R scale=start",0,(textHeight * 2))
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

function redrawShape(shape,scale)
   gfx.clear()
   drawScaleScreenBackground()
   drawShape(shape,scale)
end

function readScaleScreen(cf)
   
   local retVal = nil
   
   if playdate.buttonJustPressed(playdate.kButtonB) then
      retVal = "kButtonB"
   elseif playdate.buttonJustPressed(playdate.kButtonUp) then
      NewScale = NewScale + 0.01
      redrawShape(myShape,NewScale)
      Debug_print("kButtonUp NewScale:",NewScale)
   elseif playdate.buttonJustPressed(playdate.kButtonDown) then
      NewScale = NewScale - 0.01
      if NewScale < 0.5 then
	 NewScale = 0.5
      end
      redrawShape(myShape,NewScale)
      Debug_print("kButtonDown NewScale:",NewScale)
   elseif playdate.buttonJustPressed(playdate.kButtonLeft) then
      NewScale = 1
      Debug_print("kButtonLeft NewScale:",NewScale)
      redrawShape(myShape,NewScale)
   elseif playdate.buttonJustPressed(playdate.kButtonRight) then
      if cf["rearscale"] then	 
	 NewScale = cf["rearscale"]
      else
	 NewScale = 1
      end      
      redrawShape(myShape,NewScale)
      Debug_print("kButtonRight NewScale:",NewScale)
   elseif playdate.buttonJustPressed(playdate.kButtonA) then
      retVal = NewScale
   end
   
   if retVal ~= nil then
      Debug_print("RetVal:", retVal)
   end
   
   return retVal
end
