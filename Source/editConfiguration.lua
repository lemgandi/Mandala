--[[

   Edit config for Mandala

   copyright(c) Charles Shapiro August 2024
   
    This file is part of Mandala.  Mandala is free software: you can
    redistribute it and/or modify it under the terms of the GNU
    General Public License as published by the Free Software
    Foundation, either version 3 of the License, or (at your option)
    any later version.  Mandala is distributed in the hope that it
    will be useful, but WITHOUT ANY WARRANTY; without even the implied
    warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
    See the GNU General Public License for more details.  You should
    have received a copy of the GNU General Public License along with
    Mandala.  If not, see <http://www.gnu.org/licenses/>.

--]]
import "CoreLibs/graphics"
import "CoreLibs/strict"

gfx = playdate.graphics

local ShapeNames={}
local CurrentOnScreenTop=1
local YTop=24
local XLeft=30
local YStep=24
local ScrollAreaLinesMinusOne=7
local Cursor={ x1=1,y1=1,x2=(XLeft-2)/2,y2=(YTop-2)/2,x3=1,y3=YTop-2 }

function editConfigurationSetup(configTable,GFXTable)
   local myFont=gfx.font.new('Resources/configFont/Roobert-20-Medium')
   
   local w,h
   local yLocation=YTop
   
   gfx.setFont(myFont)
   
   if 0 == #ShapeNames then
      for kk in pairs(GFXTable) do
	 table.insert(ShapeNames,kk)
      end
      table.sort(ShapeNames)
   end
   
   
   CurrentOnScreenTop=1
   if #ShapeNames > ScrollAreaLinesMinusOne+1 then
      displayShapeNames(CurrentOnScreenTop,ScrollAreaLinesMinusOne+1)
   else
      displayShapeNames(CurrentOnScreenTop,#ShapeNames)
   end
   drawCursor(1)
   
end

function clearScrollArea()
   local scrollAreaRect=playdate.geometry.rect.new(XLeft,YTop,(playdate.display.getWidth() - XLeft),
						   (playdate.display.getHeight() - YTop))

   local currentColor=gfx.getColor()
   
   gfx.setColor(gfx.kColorWhite)
   gfx.fillRect(scrollAreaRect)
   gfx.setColor(currentColor)

end

-- Display shape names on screen
function displayShapeNames(firstone,numshapes)
   local yLocation=YTop

   for key=firstone,numshapes do
      gfx.drawText(ShapeNames[key],XLeft,yLocation)
      yLocation=yLocation+YStep
   end
end

function scroll(updown)

   -- updown true = down, false = up
   print("#ShapeNames:",#ShapeNames,"CurrentOnScreenTop",CurrentOnScreenTop,"ScrollAreaLinesMinusOne",ScrollAreaLinesMinusOne)

   if updown == true then
      
      if #ShapeNames > (CurrentOnScreenTop + ScrollAreaLinesMinusOne) then
	 clearScrollArea()
	 displayShapeNames(CurrentOnScreenTop+1,CurrentOnScreenTop + ScrollAreaLinesMinusOne+1)
	 CurrentOnScreenTop = CurrentOnScreenTop + 1	 
	 print("CurrentOnScreenTop:",CurrentOnScreenTop)
      end      
   else
      if CurrentOnScreenTop > 1 then	    
	 clearScrollArea()
	 displayShapeNames(CurrentOnScreenTop-1,CurrentOnScreenTop + ScrollAreaLinesMinusOne-1)
	 CurrentOnScreenTop = CurrentOnScreenTop - 1	 	 	 
      end	 
   end      
						 
end

function drawCursor(slot,current)
   slot=slot*YTop
   
   if current then
      
      current=current*YTop
      local currentColor=gfx.getColor()
   
      gfx.setColor(gfx.kColorWhite)
      
      gfx.fillTriangle(Cursor.x1,
		       Cursor.y1+slot,
		       Cursor.x2,
		       Cursor.y2+slot,
		       Cursor.x3,
		       Cursor.y3+slot)
      gfx.setColor(currentColor)
   end

   gfx.fillTriangle(Cursor.x1,
		    Cursor.y1+slot,
		    Cursor.x2,
		    Cursor.y2+slot,
		    Cursor.x3,
		    Cursor.y3+slot)   
end


function editConfiguration()
   
   if playdate.buttonIsPressed(playdate.kButtonB) then
      EditingConfig = false
   elseif playdate.buttonJustPressed(playdate.kButtonDown) then
      scroll(true)
   elseif playdate.buttonJustPressed(playdate.kButtonUp) then
      scroll(false)
   end
   
end
