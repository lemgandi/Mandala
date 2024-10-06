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
local CurrentChoice=nil
StateTable={DrawingShapes="DrawingShapes",ReadingMenus="ReadingMenus"}

State=StateTable.DrawingShapes

menuState={TopShape="TopShape",
	   BottomShape="BottomShape",
	   Offset="Offset",
	   ScaleBottomShape="ScaleBottomShape",
	   End="End"}

menuTable={
   {prompt='Choose Top Shape',returns=menuState.TopShape},
   {prompt='Choose Bottom Shape',returns=menuState.BottomShape},
   {prompt='Set Offset',returns=menuState.Offset},
   {prompt='Scale Bottom Shape', returns=menuState.ScaleBottomShape}
}

-- In global table
EditingConfig=false

local GameConfig
local GameConfigAtStart

local debugPrinted=0

-- Simple copy to reserve table so we can see if current GameState table is Dirty
function deepcopy(src)
   local dest={}
   for kk,vv in pairs(src) do
      dest[kk] = vv
   end
   return dest
end

-- Write config data iff dirty
function writeConfiguration()
   local dirtyFlag=false

   for kk,vv in pairs(GameConfig) do
      if GameConfigAtStart[kk] ~= vv then
	 dirtyFlag=true
      end
   end

   if dirtyFlag then
      playdate.datastore.write(GameConfig)
      GameConfigAtStart = deepcopy(GameConfig)      
   end
   
end

-- Set up before update calls
   
function setupMandala()

   MandalaGFX=makeGFXTable(ImageDir)
   --   testGFXTable()
   -- testSearchMenuTable()
   
   GameConfig = playdate.datastore.read()
      
   if nil == GameConfig then
      GameConfig={}
      GameConfig["which"]="Line"
      GameConfig["offset"]=0.5
      GameConfig["crankticks"]=180
      GameConfigAtStart=deepcopy(GameConfig)
      playdate.datastore.write(GameConfig)
      State = StateTable.DrawingMenus
   else
      GameConfigAtStart = deepcopy(GameConfig)
      State = StateTable.DrawingShapes      
   end
      
   local menu=playdate.getSystemMenu()
   menu:addMenuItem("Configure",function() State=StateTable.DrawingMenus end)
   
   ShapeKey=SearchMenuTable(GameConfig["which"],MandalaGFX)
   
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
   MandalaGFX[key][1]:draw(0,0)   
end

----------------------------- Main Line starts Here ----------------------------------------------


setupMandala()

-- Loop until force stop
function playdate.update()
   do      
      if debugPrinted > 60 then
	 print("State:",StateTable[State],"CurrentChoice:",CurrentChoice)
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
	 MandalaGFX[ShapeKey][1]:draw(0,0)
      elseif State == StateTable.ReadingMenus then
	 
	 CurrentChoice = editConfiguration()
	 if (CurrentChoice ~= nil) and (CurrentChoice ~= MandalaGFX[ShapeKey].prompt) then
	    deleteOldMandala(ShapeKey)	    
	    ShapeKey = SearchMenuTable(CurrentChoice,MandalaGFX)	    
	    GameConfig["which"] = CurrentChoice
	    writeConfiguration()	    
	    drawNewMandala(ShapeKey)
	    State=StateTable.DrawingShapes
	 end	 
      elseif State == StateTable.DrawingMenus then
	 playdate.graphics.clear()   
	 editConfigurationSetup(MandalaGFX,"Front Shape",GameConfig["which"])
	 State=StateTable.ReadingMenus	 
      end      
   end   
end
