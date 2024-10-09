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

import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/crank"
import "CoreLibs/strict"

import "makeGFXTable"
import "editConfiguration"
import "utility"

gfx = playdate.graphics
ImageDir="Images/shapes/"

MandalaGFX = {}

local CurrentRotation = 1
-- local ShapeName="Line"
FrontShapeKey=nil
RearShapeKey=nil

StateTable={
   DrawingShapes="DrawingShapes",
   ReadingFrontMenu="ReadingFrontMenu",
   DrawingFrontMenu="DrawingFrontMenu",
   ReadingTopMenu="ReadingTopMenu",
   DrawingTopMenu="DrawingTopMenu",
   DrawingRearMenu="DrawingRearMenu",
   ReadingBottomMenu="ReadingRearMenu"   
}

local State=StateTable.DrawingShapes

TopMenuTable={
   {prompt='Choose Top Shape', nextState = StateTable.DrawingFrontMenu},
   {prompt='Choose Bottom Shape',nextState = StateTable.DrawingRearMenu}
}

-- In global table
EditingConfig=false

local GameConfig = {}
local GameConfigAtStart = {}

local debugPrinted=0



-- Set up before update calls
   
function setupMandala()

   MandalaGFX=makeGFXTable(ImageDir)
   --   testGFXTable()
   -- testSearchTableByPrompt()
   
   GameConfig = playdate.datastore.read()
      
   if nil == GameConfig then
      GameConfig={}
      GameConfig["frontshape"]="Line"
      GameConfig["offset"]=0.5
      GameConfig["crankticks"]=180
      GameConfig["imageflip"]=gfx.kImageUnflipped
      writeConfiguration(GameConfigAtStart,GameConfig)
      playdate.datastore.write(GameConfig)
      State = StateTable.DrawingTopMenu
   else
      GameConfigAtStart=table.deepcopy(GameConfig)      
      State = StateTable.DrawingShapes      
   end
   

   
   local menu=playdate.getSystemMenu()
   menu:addMenuItem("Configure",function() State=StateTable.DrawingTopMenu end)
   
   FrontShapeKey=SearchTableByPrompt(GameConfig["frontshape"],MandalaGFX)
   
   gfx.setImageDrawMode(gfx.kDrawModeNXOR)

   drawNewMandala(FrontShapeKey,RearShapeKey)   
end

-- Remove moving sprite from screen
function deleteOldMandala(frontkey,rearkey)
   MandalaGFX[frontkey][2]:remove()
   if rearkey ~= nil then
      MandalaGFX[rearkey][1]:clear(gfx.kColorWhite)
   end
   
end

-- Draw new moving sprite on screen
function drawNewMandala(frontkey,rearkey)
   MandalaGFX[frontkey][2]:moveTo(200,120)
   MandalaGFX[frontkey][2]:add()
   MandalaGFX[frontkey][2]:setCenter(0.5,GameConfig.offset)
   if rearkey ~= nil then
      MandalaGFX[rearkey][1]:draw(0,0,GameConfig.imageflip)
   else      
      MandalaGFX[frontkey][1]:draw(0,0,GameConfig.imageflip)
   end   
end

----------------------------- Main Line starts Here ----------------------------------------------


setupMandala()

-- Loop until force stop
function playdate.update()
   do      
      if debugPrinted > 60 then
	 print("State:",StateTable[State])
	 debugPrinted=0
      else
	 debugPrinted = debugPrinted+1
      end
      
      
      if State == StateTable.DrawingShapes  then
	 local crankTicks=playdate.getCrankTicks(GameConfig.crankticks)

	 if crankTicks ~= 0 then
	    CurrentRotation = CurrentRotation + crankTicks	 
	    MandalaGFX[FrontShapeKey][2]:setRotation(CurrentRotation)
	 end      
	 gfx.sprite.update()
	 if RearShapeKey ~= nil then
	    MandalaGFX[RearShapeKey][1]:draw(0,0,GameConfig.ImageFlip)
	 else	    
	    MandalaGFX[FrontShapeKey][1]:draw(0,0,GameConfig.ImageFlip)
	 end	 
      elseif State == StateTable.ReadingFrontMenu then
	 local currentChoice
	 currentChoice = editConfiguration()
	 if (currentChoice ~= nil) then
	    deleteOldMandala(FrontShapeKey,RearShapeKey)
	    if currentChoice ~= MandalaGFX[FrontShapeKey].prompt then
	       FrontShapeKey = SearchTableByPrompt(currentChoice,MandalaGFX)	    
	       GameConfig["frontshape"] = currentChoice
	       writeConfiguration(GameConfigAtStart,GameConfig)	    
	    end
	    drawNewMandala(FrontShapeKey,RearShapeKey)
	    State = StateTable.DrawingShapes
	 end
      elseif State == StateTable.ReadingTopMenu then
	 local chosenPrompt	 
	 chosenPrompt = editConfiguration()
	 if (chosenPrompt ~= nil) then
	    local menuChoice=SearchTableByPrompt(chosenPrompt,TopMenuTable)
	    print("chosenPrompt:",chosenPrompt,"menuChoice:",menuChoice,"State:",TopMenuTable[menuChoice].nextState)
	    State=TopMenuTable[menuChoice].nextState
	 end	 
      elseif State == StateTable.DrawingFrontMenu then
	 gfx.clear()   
	 editConfigurationSetup(MandalaGFX,"Front Shape",GameConfig["frontshape"])
	 State=StateTable.ReadingFrontMenu
      elseif State == StateTable.DrawingRearMenu then
	 gfx.clear()
	 local topChoice=MandalaGFX[1].prompt
	 if GameConfig["rearshape"] ~= nil then
	    topChoice=MandalaGFX[GameConfig["rearshape"]]
	 end	 
	 editConfigurationSetup(MandalaGFX,"Rear Shape",topChoice)
	 State = StateTable.ReadingRearMenu
      elseif State == StateTable.ReadingRearMenu then
	 local currentRearChoice
	 currentRearChoice=editConfiguration()
	 
	 if currentRearChoice ~= nil then
	    deleteOldMandala(FrontShapeKey,RearShapeKey)
	    RearShapeKey=SearchTableByPrompt(currentRearChoice,MandalaGFX)
	    GameConfig["rearshape"]=currentRearChoice
	    writeConfiguration(GameConfigAtStart,GameConfig)
	    drawNewMandala(FrontShapeKey,RearShapeKey)
	    State=StateTable.DrawingShapes
	 end
      elseif State == StateTable.DrawingTopMenu then
	 gfx.clear()
	 editConfigurationSetup(TopMenuTable,"Top Menu",TopMenuTable[1].prompt)
	 State=StateTable.ReadingTopMenu
      end      
   end   
end
