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
geom = playdate.geometry

-- 30 x 400 block in middle of screen
local LineAreaTop=90
local LineAreaSize = 61

local Center=120
local CursorLine
local VPosition=Center

function SetupCenterChangeScreen(currentOffset)
   local limitRect = geom.rect.new(0,LineAreaTop,400,LineAreaSize)
   local banner="Up/Down to Change"
   
   DrawBanner(banner,32,30)
   CursorLine=geom.lineSegment.new(0,VPosition,400,VPosition)
   
   gfx.setColor(gfx.kColorBlack)
   gfx.fillRect(limitRect)
   gfx.setColor(gfx.kColorWhite)
   gfx.drawLine(CursorLine)
   
end

-- Redraw cursor at new position
function newPosition(line,newPosition)
   gfx.setColor(gfx.kColorBlack)
   gfx.drawLine(line)
   line.y1 = newPosition
   line.y2 = newPosition
   gfx.setColor(gfx.kColorWhite)
   gfx.drawLine(line)
end



-- Compute percentage change from cursor position
function computePctFromCursor(cursorPosition)
   
   local pct = nil
      
   pct = ((cursorPosition - Center) + 50) / 100
   
   print("computePctFromCursor Position:",cursorPosition,"Pct:",pct)
   return pct
end

-- Compute cursor position from gameconfig percentage

function computeCursorFromPct(pct)
   local cp = nil
   
   if pct < 50 then
      cp = pct + LineAreaTop
   elseif pct > 50 then
      cp = (pct - 50) + Center
   else
      cp = Center
   end
   print("computeCursorFromPct pct:",pct,"Position:",cp)
   return cp   
end


-- Change rotation center of front sprite ( main line )
function ReadCenterChangeScreen(gc)
   
   local retVal = nil
   local ticks = playdate.getCrankTicks(gc.crankticks)

   
   if ticks ~= 0 then
      if (VPosition + ticks > LineAreaTop) and (VPosition + ticks <  (LineAreaTop + LineAreaSize)) then	 
	 VPosition = VPosition + ticks	 
	 newPosition(CursorLine,VPosition)
      end      
   end
   					
   if playdate.buttonJustPressed(playdate.kButtonA) then
      retVal = computePctFromCursor(VPosition)
   elseif playdate.buttonJustPressed(playdate.kButtonLeft) or playdate.buttonJustPressed(playdate.kButtonRight)
   then
      VPosition=Center
      newPosition(CursorLine,VPosition)
   elseif playdate.buttonJustPressed(playdate.kButtonB) then
      VPosition = computeCursorFromPct(gc.offset)
      newPosition(CursorLine,VPosition)
   elseif playdate.buttonJustPressed(playdate.kButtonUp) then
      if VPosition - 1 > LineAreaTop then
	 VPosition = VPosition - 1
	 newPosition(CursorLine,VPosition)
      end
   elseif playdate.buttonJustPressed(playdate.kButtonDown) then
      if VPosition + 1 < (LineAreaTop + LineAreaSize) then
	 VPosition = VPosition + 1
	 newPosition(CursorLine,VPosition)
      end      
   end
   if retVal ~= nil then
      gfx.setColor(gfx.kColorBlack)
   end   
   return retVal
end
