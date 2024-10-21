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
import "CoreLibs/ui"

-- for printTable()
import "CoreLibs/object"

import "makeGFXTable"
import "editConfiguration"
import "utility"
import "changeMandalaCenter"
import "changeCrankRate"

gfx = playdate.graphics

ImageDir="Resources/shapes/"

_G.allFont = gfx.font.new('Resources/configFont/Roobert-20-Medium')
_G.debug = true
MandalaGFX = {}

local StateTable = {
   DrawingShapes = "DrawingShapes",
   ReadingFrontMenu = "ReadingFrontMenu",
   DrawingFrontMenu = "DrawingFrontMenu",
   ReadingTopMenu = "ReadingTopMenu",
   DrawingTopMenu = "DrawingTopMenu",
   DrawingRearMenu = "DrawingRearMenu",
   ReadingRearMenu = "ReadingRearMenu",
   DrawingCenterChange = "DrawingCenterChange",
   ReadingCenterChange = "ReadingCenterChange",
   DrawingCrankRate = "DrawingCrankRate",
   ReadingCrankRate = "ReadingCrankRate"
}

local State =  StateTable.DrawingShapes

function SetupSystemMenu()
   local menu=playdate.getSystemMenu()
   
   menu:addMenuItem("Game Config",function() State=StateTable.DrawingTopMenu end)
   menu:addMenuItem("Save Config",SaveOldConfiguration)
   menu:addMenuItem("Rstore Cnfig",RestoreOldConfiguration)

end

function RemoveSystemMenu()
   local menu = playdate.getSystemMenu()
   menu:removeAllMenuItems()
end

local CurrentRotation = 1
-- local ShapeName="Line"
local FrontShapeKey=nil
local RearShapeKey=nil

local TopMenuTable={
   {prompt='Choose Moving Shape', nextState = StateTable.DrawingFrontMenu},
   {prompt='Choose Still Shape',nextState = StateTable.DrawingRearMenu},
   {prompt="Change Rotation Center",nextState=StateTable.DrawingCenterChange},
   {prompt="Change Crank Rate",nextState=StateTable.DrawingCrankRate}
}

local GameConfig = {}
local GameConfigAtStart = {}
local OldFN = "old_data"

local debugPrinted=0

local NilRearPrompt="Same as Front"

-- Add nil choice to rear shape menu
function InsertNilChoice(shapemenu,nilprompt)
   local nilChoice={prompt=nilprompt,gfx.image.new(1,1),gfx.sprite.new()}
   table.insert(shapemenu,nilChoice)
end

-- Remove nil choice from rear shape menu
function RemoveNilChoice(shapemenu,nilprompt)
   
   local nilChoice = SearchTableByPrompt(nilprompt,shapemenu)
   
   if nilChoice ~= nil then
      shapemenu[nilChoice]=nil
   end   
end

-- Save config file to reserve
function SaveOldConfiguration()
   playdate.datastore.write(GameConfig,OldFN,false)
end

-- Draw the background shape
function drawRearShape(shape)
   -- Oof. How to draw an image both scaled and flipped. Affine transform? TODO
   
   if GameConfig["rearscale"] ~= nil then
      local xPlace,yPlace
      if GameConfig.rearscale < 1 then
	 xPlace = 200 * GameConfig.rearscale
	 yPlace = 120 * GameConfig.rearscale
      else
	 xPlace = ((GameConfig.rearscale * 400) - 200) / GameConfig.rearscale
	 yPlace = ((GameConfig.rearscale * 120) - 120) / GameConfig.rearscale
      end
      Update_debug_print("xPlace:",xPlace,"yPlace:",yPlace)
      shape:drawScaled(xPlace,yPlace,GameConfig.rearscale)
   else      
      shape:draw(0,0,GameConfig.ImageFlip)
   end
   
end

-- Restore config file from reserve
function RestoreOldConfiguration()
   
   local oldTable = playdate.datastore.read(OldFN)
   if oldTable ~= nil then
      gfx.clear()
      GameConfig = table.deepcopy(oldTable)
      FrontShapeKey = SearchTableByPrompt(GameConfig["frontshape"],MandalaGFX)
      if GameConfig["rearshape"] ~= nil then
	 RearShapeKey = SearchTableByPrompt(GameConfig["rearshape"],MandalaGFX)
      else
	 RearShapeKey = nil
      end
      
      if RearShapeKey ~= nil then
	 drawRearShape(MandalaGFX[RearShapeKey][1])
      else	    
	 drawRearShape(MandalaGFX[FrontShapeKey][1])
      end	       
      drawNewMandala(FrontShapeKey)
   end
   
end


-- Set up before update calls
   
function setupMandala()

   MandalaGFX=makeGFXTable(ImageDir)
   --   testGFXTable()
   -- testSearchTableByPrompt()
   
   gfx.setFont(_G.allFont)

   GameConfig = playdate.datastore.read()
      
   if nil == GameConfig then
      GameConfig={}
      GameConfig["frontshape"]="Line"
      GameConfig["offset"]=0.5
      GameConfig["crankticks"]=180
      GameConfig["imageflip"]=gfx.kImageUnflipped
      writeConfiguration(GameConfigAtStart,GameConfig)
      State = StateTable.DrawingTopMenu
   else
      GameConfigAtStart=table.deepcopy(GameConfig)
      FrontShapeKey=SearchTableByPrompt(GameConfig["frontshape"],MandalaGFX)
      RearShapeKey = nil
      if GameConfig["rearshape"] ~= nil then
	 RearShapeKey = SearchTableByPrompt(GameConfig["rearshape"],MandalaGFX)
      end      
      State = StateTable.DrawingShapes      
   end
   
   -- SetupSystemMenu()
      
   FrontShapeKey=SearchTableByPrompt(GameConfig["frontshape"],MandalaGFX)
   
   gfx.setImageDrawMode(gfx.kDrawModeNXOR)

   drawNewMandala(FrontShapeKey)
   
end

-- Remove moving sprite from screen
function deleteOldMandala(frontkey)
   MandalaGFX[frontkey][2]:remove()
end


-- Draw new moving sprite on screen
-- Back is drawn in DrawingShapes state
function drawNewMandala(frontkey)
   MandalaGFX[frontkey][2]:moveTo(200,120)
   MandalaGFX[frontkey][2]:setRotation(1)
   MandalaGFX[frontkey][2]:add()
   MandalaGFX[frontkey][2]:setCenter(0.5,GameConfig.offset)

end

----------------------------- Main Line starts Here ----------------------------------------------


setupMandala()

-- Loop until force stop
function playdate.update()
   

--      Update_debug_print("State:",StateTable[State],"FrontShapeKey:",FrontShapeKey,"GameConfig.rearscale",GameConfig["rearscale"])

      
      
   if State == StateTable.DrawingShapes  then
      SetupSystemMenu()
      local crankTicks=playdate.getCrankTicks(GameConfig.crankticks)
      
      if crankTicks ~= 0 then
	 CurrentRotation = CurrentRotation + crankTicks	 
	 MandalaGFX[FrontShapeKey][2]:setRotation(CurrentRotation)
      end      
      gfx.sprite.update()
      
      if RearShapeKey ~= nil then
	 drawRearShape(MandalaGFX[RearShapeKey][1])
      else	    
	 drawRearShape(MandalaGFX[FrontShapeKey][1])
      end	 
   elseif State == StateTable.ReadingFrontMenu then
      local currentChoice
      currentChoice = editConfiguration()
      if (currentChoice ~= nil) then
	 if currentChoice == playdate.kButtonB then
	    State = StateTable.DrawingTopMenu
	 else	       
	    deleteOldMandala(FrontShapeKey)
	    if currentChoice ~= MandalaGFX[FrontShapeKey].prompt then
	       FrontShapeKey = SearchTableByPrompt(currentChoice,MandalaGFX)	    
	       GameConfig["frontshape"] = currentChoice
	       writeConfiguration(GameConfigAtStart,GameConfig)	    
	    end
	    drawNewMandala(FrontShapeKey)
	    State = StateTable.DrawingShapes
	 end	    
      end
   elseif State == StateTable.ReadingTopMenu then
      local chosenPrompt	 
      chosenPrompt = editConfiguration()
      if (chosenPrompt ~= nil) then
	 if chosenPrompt == playdate.kButtonB then
	    State=StateTable.DrawingShapes
	 else	       
	    local menuChoice=SearchTableByPrompt(chosenPrompt,TopMenuTable)
	    State=TopMenuTable[menuChoice].nextState
	 end
      end	 
   elseif State == StateTable.DrawingFrontMenu then
      gfx.clear()   
      editConfigurationSetup(MandalaGFX,"Front Shape",GameConfig["frontshape"])
      State=StateTable.ReadingFrontMenu
   elseif State == StateTable.DrawingRearMenu then
      gfx.clear()
      InsertNilChoice(MandalaGFX,NilRearPrompt)
      local topChoice=NilRearPrompt
      if GameConfig["rearshape"] ~= nil then
	 topChoice=GameConfig["rearshape"]
      end	 
      editConfigurationSetup(MandalaGFX,"Rear Shape",topChoice)
      State = StateTable.ReadingRearMenu
      
   elseif State == StateTable.ReadingRearMenu then
      local currentRearChoice
      
      currentRearChoice=editConfiguration()
      
      if currentRearChoice ~= nil then
	 if currentRearChoice == playdate.kButtonB then
	    RemoveNilChoice(MandalaGFX,NilRearPrompt)
	    State=StateTable.DrawingTopMenu
	 else
	    RemoveNilChoice(MandalaGFX,NilRearPrompt)	    
	    deleteOldMandala(FrontShapeKey)
	    RearShapeKey = SearchTableByPrompt(currentRearChoice,MandalaGFX)
	    if currentRearChoice == NilRearPrompt then
	       RearShapeKey = nil
	       GameConfig["rearshape"] = nil
	    else	       
	       GameConfig["rearshape"]=currentRearChoice
	    end	    
	    writeConfiguration(GameConfigAtStart,GameConfig)
	    drawNewMandala(FrontShapeKey)
	    State=StateTable.DrawingShapes
	 end
      end
   elseif State == StateTable.DrawingTopMenu then
      gfx.clear()
      RemoveSystemMenu()
      editConfigurationSetup(TopMenuTable,"Top Menu",TopMenuTable[1].prompt)
      State=StateTable.ReadingTopMenu
   elseif State == StateTable.DrawingCenterChange then
      gfx.clear()
      RemoveSystemMenu()
      SetupCenterChangeScreen(GameConfig["offset"])
      State = StateTable.ReadingCenterChange
   elseif State == StateTable.ReadingCenterChange then
      local centerPct
      centerPct = ReadCenterChangeScreen(GameConfig)
      if centerPct ~= nil then
	 centerPct = math.floor((centerPct*100) + 0.5) / 100
	 GameConfig["offset"] = centerPct
	 writeConfiguration(GameConfigAtStart,GameConfig)
	 drawNewMandala(FrontShapeKey)
	 State = StateTable.DrawingShapes
	 SetupSystemMenu()
      end
   elseif State == StateTable.DrawingCrankRate then
      DrawCrankRateScreen(GameConfig)
      State = StateTable.ReadingCrankRate
   elseif State == StateTable.ReadingCrankRate then
      local crankRate = HandleCrankRateScreen(GameConfig)
      if crankRate ~= nil then

	 Debug_print("crankRate:",crankRate)
	 GameConfig["crankticks"] = crankRate
	 writeConfiguration(GameConfigAtStart,GameConfig)
	 State = StateTable.DrawingShapes	    
      end
   end      
end
