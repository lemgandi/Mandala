--[[

   Read crank ticks from user.

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
import "CoreLibs/crank"
import "CoreLibs/strict"
import "utility"

gfx = playdate.graphics
geom = playdate.geometry

local CrankBarLeft = 20
local CrankBarVPos = 100
local CrankBarHeight = 30

local StepTable = {1,10,20,30,40}

local CurrentStep = 1
local CrankMax = 359
local CrankMin = 1
local NewCrankRate = 0


function drawCurrentStep(step)
   
   local theText=string.format("Current Step (U/D): %d",step)   
   local clearing_rect = geom.rect.new(CrankBarLeft,CrankBarVPos+CrankBarHeight+40,380,_G.allFont:getHeight())   
   local oldColor = gfx.getColor()
   
   gfx.setColor(gfx.kColorWhite)
   gfx.fillRect(clearing_rect)
   gfx.setColor(oldColor)
   gfx.drawText(theText,CrankBarLeft,CrankBarVPos+CrankBarHeight+40)
 
end

-- Draw crankbar background screen
function drawCrankBackground()
   local lessStr="Slower (L)"
   local moreStr="Faster (R)"

   local moreMargin = _G.allFont:getTextWidth(moreStr)+2
   
   gfx.drawLine(CrankBarLeft,32,CrankBarLeft,CrankBarVPos)
   gfx.drawLine((CrankMax-7),32,(CrankMax-7),CrankBarVPos)
   
   gfx.drawText(lessStr,CrankBarLeft,CrankBarVPos+CrankBarHeight+15)
   gfx.drawText(moreStr,CrankMax - moreMargin,CrankBarVPos+CrankBarHeight+15)
   
end

function drawCrankBar(len)
   
   local oldColor=gfx.getColor()
   
   gfx.setColor(gfx.kColorWhite)
   gfx.fillRect(CrankBarLeft,CrankBarVPos,CrankMax,CrankBarHeight)
   gfx.setColor(oldColor)
   gfx.fillRect(CrankBarLeft,CrankBarVPos,len,CrankBarHeight)
   
end

-- Draw the screen to input ticks
function DrawCrankRateScreen(gc)
   gfx.clear()
   DrawBanner("Change Crank Rate",nil,30)
   drawCrankBackground()
   NewCrankRate = gc.crankticks
   drawCrankBar(NewCrankRate)
   drawCurrentStep(StepTable[CurrentStep])
end

-- Read ticks from crank rate screen
function HandleCrankRateScreen(gc)   
   local retVal = nil

   if playdate.buttonJustPressed(playdate.kButtonB) then
      NewCrankRate = gc.crankticks
      drawCrankBar(NewCrankRate)
   elseif playdate.buttonJustPressed(playdate.kButtonA) then
      retVal = NewCrankRate
   elseif playdate.buttonJustPressed(playdate.kButtonRight) then      
      if (NewCrankRate + StepTable[CurrentStep] ) < CrankMax then
	 NewCrankRate = NewCrankRate + StepTable[CurrentStep]
	 drawCrankBar(NewCrankRate)
      end
      Debug_print(
	 "NewCrankRate:",NewCrankRate,"CrankMax:",CrankMax,"StepTable[CurrentStep]:",StepTable[CurrentStep])
   elseif playdate.buttonJustPressed(playdate.kButtonLeft) then
      if (NewCrankRate - StepTable[CurrentStep] ) > 1 then
	 NewCrankRate = NewCrankRate - StepTable[CurrentStep]
	 drawCrankBar(NewCrankRate)
      end
   elseif playdate.buttonJustPressed(playdate.kButtonUp) then
      if CurrentStep < #StepTable then
	 CurrentStep = CurrentStep + 1
      else
	 CurrentStep = 1
      end
      drawCurrentStep(StepTable[CurrentStep])
   elseif playdate.buttonJustPressed(playdate.kButtonDown) then
      if CurrentStep > 1 then
	 CurrentStep = CurrentStep - 1
      end
      drawCurrentStep(StepTable[CurrentStep])
   end
   
   if retVal ~= nil then
      Debug_print("retVal:",retVal)
   end
   
   return retVal
   
end
