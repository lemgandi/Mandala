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

local ChoiceKeys={}
local CurrentOnScreenTop=1
local YTop=24
local XLeft=30
local YStep=24
local ScrollAreaLinesMinusOne=7
local Cursor={ x1=1,y1=1,x2=(XLeft-2)/2,y2=(YTop-2)/2,x3=1,y3=YTop-2 }
local CurrentSlot=1


-- Set screen up to display a menu
function editConfigurationSetup(configTable,choices)
   
   local fileFont=gfx.font.new('Resources/configFont/Roobert-20-Medium')

   local banner="Front Shape"
   
   local w,h
   local yLocation=YTop
   
   gfx.setFont(fileFont)
   
   if 0 == #ChoiceKeys then
      for kk in pairs(choices) do
	 table.insert(ChoiceKeys,kk)
      end
      table.sort(ChoiceKeys)
   end
   
   
   CurrentOnScreenTop=1
   if #ChoiceKeys > ScrollAreaLinesMinusOne+1 then
      displayChoiceKeys(CurrentOnScreenTop,ScrollAreaLinesMinusOne+1)
   else
      displayChoiceKeys(CurrentOnScreenTop,#ChoiceKeys)
   end
   drawCursor(CurrentSlot)
   drawBanner("Front Shape")
end


-- Draw the banner indicating what menu we are on
function drawBanner(banner)
      
   local currentColor=gfx.getColor()
   
   gfx.setColor(gfx.kColorBlack)
   gfx.fillRect(0,0,400,YStep)
   gfx.setColor(gfx.kColorXOR)
   gfx.drawText(banner,XLeft,0)
   gfx.setColor(currentColor)

end

-- Prepare to Scroll!
function clearScrollArea()
   local scrollAreaRect=playdate.geometry.rect.new(XLeft,YTop,(playdate.display.getWidth() - XLeft),
						   (playdate.display.getHeight() - YTop))

   local currentColor=gfx.getColor()
   
   gfx.setColor(gfx.kColorWhite)
   gfx.fillRect(scrollAreaRect)
   gfx.setColor(currentColor)

end

-- Display menu choices on screen
function displayChoiceKeys(firstone,numshapes)
   local yLocation=YTop

   for key=firstone,numshapes do
      gfx.drawText(ChoiceKeys[key],XLeft,yLocation)
      yLocation=yLocation+YStep
   end
end

-- Scroll a menu if necessary, updown true = down, false = up
function scroll(updown)


   print("#ChoiceKeys:",#ChoiceKeys,"CurrentOnScreenTop",CurrentOnScreenTop,"ScrollAreaLinesMinusOne",ScrollAreaLinesMinusOne)

   if updown == true then
      
      if #ChoiceKeys > (CurrentOnScreenTop + ScrollAreaLinesMinusOne) then
	 clearScrollArea()
	 displayChoiceKeys(CurrentOnScreenTop+1,CurrentOnScreenTop + ScrollAreaLinesMinusOne+1)
	 CurrentOnScreenTop = CurrentOnScreenTop + 1	 
	 print("CurrentOnScreenTop:",CurrentOnScreenTop)
      end      
   else
      if CurrentOnScreenTop > 1 then	    
	 clearScrollArea()
	 displayChoiceKeys(CurrentOnScreenTop-1,CurrentOnScreenTop + ScrollAreaLinesMinusOne-1)
	 CurrentOnScreenTop = CurrentOnScreenTop - 1	 	 	 
      end	 
   end      
						 
end

-- Draw the cursor on the left side of the screen at slot; delete from current position if necessary.
-- Right now I have 8 slots at 24 px each plus a banner slot ( cursor never goes there) and a bottom space
-- ( cursor never goes there )
function drawCursor(slot,current)
   slot=slot*YTop
   
   if current then
      
      current=current*YTop

      local currentColor=gfx.getColor()
   
      gfx.setColor(gfx.kColorWhite)
      
      gfx.fillTriangle(Cursor.x1,
		       Cursor.y1+current,
		       Cursor.x2,
		       Cursor.y2+current,
		       Cursor.x3,
		       Cursor.y3+current)
      gfx.setColor(currentColor)
   end

   gfx.fillTriangle(Cursor.x1,
		    Cursor.y1+slot,
		    Cursor.x2,
		    Cursor.y2+slot,
		    Cursor.x3,
		    Cursor.y3+slot)   
end


-- Display and move cursor, return current value at cursor when kButtonB is pressed.
function editConfiguration()
   
   if playdate.buttonIsPressed(playdate.kButtonB) then      
      State = StateTable.DrawingShapes
      return ChoiceKeys[(CurrentOnScreenTop + CurrentSlot)-1]
   elseif playdate.buttonJustPressed(playdate.kButtonDown) then
      if(CurrentSlot < ScrollAreaLinesMinusOne + 1) then
	 drawCursor(CurrentSlot + 1,CurrentSlot)
	 CurrentSlot = CurrentSlot + 1
      else
	 scroll(true)
	 drawCursor((ScrollAreaLinesMinusOne + 1),ScrollAreaLinesMinusOne)
      end      	 
   elseif playdate.buttonJustPressed(playdate.kButtonUp) then
      if CurrentSlot > 1 then
	 drawCursor(CurrentSlot - 1, CurrentSlot)
	 CurrentSlot = CurrentSlot - 1
      else	 
	 scroll(false)
	 drawCursor(1,CurrentSlot)
	 CurrentSlot = 1
      end
   elseif playdate.buttonJustPressed(playdate.kButtonA) then
      print("Current Shape:",ChoiceKeys[(CurrentOnScreenTop + CurrentSlot)-1])
   end
end
