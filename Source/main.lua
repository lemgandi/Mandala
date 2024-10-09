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
ShapeKey=nil

StateTable={
   DrawingShapes="DrawingShapes",
   ReadingFrontMenu="ReadingFrontMenu",
   DrawingFrontMenu="DrawingFrontMenu",
   ReadingTopMenu="ReadingTopMenu",
   DrawingTopMenu="DrawingTopMenu",
   DrawingBottomMenu="DrawingBottomMenu",
   ReadingBottomMenu="ReadingBottomMenu"   
}

State=StateTable.DrawingShapes

TopMenuTable={
   {prompt='Choose Top Shape',nextState=StateTable.DrawingFrontMenu},
   {prompt='Choose Bottom Shape',nextState=StateTable.DrawingBottomMenu}
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
   
   ShapeKey=SearchTableByPrompt(GameConfig["frontshape"],MandalaGFX)
   
   gfx.setImageDrawMode(gfx.kDrawModeNXOR)

   drawNewMandala(ShapeKey)   
end

-- Remove moving sprite from screen
function deleteOldMandala(key)
   MandalaGFX[key][2]:remove()
end

-- Draw new moving sprite on screen
function drawNewMandala(key)
   MandalaGFX[key][2]:moveTo(200,120)
   MandalaGFX[key][2]:add()
   MandalaGFX[key][2]:setCenter(0.5,GameConfig.offset)
   MandalaGFX[key][1]:draw(0,0,GameConfig.imageflip)   
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
	    MandalaGFX[ShapeKey][2]:setRotation(CurrentRotation)
	 end      
	 gfx.sprite.update()
	 MandalaGFX[ShapeKey][1]:draw(0,0,GameConfig.ImageFlip)
      elseif State == StateTable.ReadingFrontMenu then
	 local currentChoice
	 currentChoice = editConfiguration()
	 if (currentChoice ~= nil) and (currentChoice ~= MandalaGFX[ShapeKey].prompt) then
	    deleteOldMandala(ShapeKey)	    
	    ShapeKey = SearchTableByPrompt(currentChoice,MandalaGFX)	    
	    GameConfig["frontshape"] = currentChoice
	    writeConfiguration(GameConfigAtStart,GameConfig)	    
	    drawNewMandala(ShapeKey)
	    State=StateTable.DrawingShapes
	 end
      elseif State == StateTable.ReadingTopMenu then
	 local chosenPrompt	 
	 chosenPrompt = editConfiguration()
	 if (chosenPrompt ~= nil) then
	    local menuChoice=SearchTableByPrompt(chosenPrompt,TopMenuTable)
	    State=TopMenuTable[menuChoice].nextState
	 end	 
      elseif State == StateTable.DrawingFrontMenu then
	 gfx.clear()   
	 editConfigurationSetup(MandalaGFX,"Front Shape",GameConfig["frontshape"])
	 State=StateTable.ReadingFrontMenu
      elseif State == StateTable.DrawingTopMenu then
	 gfx.clear()
	 editConfigurationSetup(TopMenuTable,"Top Menu",TopMenuTable[1].prompt)
	 State=StateTable.ReadingTopMenu
      end      
   end   
end
