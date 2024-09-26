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

gfx = playdate.graphics
ImageDir="Images/shapes/"

MandalaGFX = {}

local CurrentRotation = 0
local ShapeName="Line"
local CurrentChoice=nil
StateTable={DrawingShapes="DrawingShapes",DrawingMenus="DrawingMenus",
	    ReadingMenus="ReadingMenus"}

State=StateTable.DrawingShapes


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
   for kk,vv in ipairs(GameConfig) do
      if GameConfigAtStart[kk] ~= GameConfig[kk] then
	 dirtyFlag=true
      end
   end
   if dirtyFlag then
      GameConfigAtStart = deepcopy(GameConfig)
      playdate.datastore.write(GameConfig)
   end
   
end

-- Set up before update calls
   
function setupMandala()

   MandalaGFX=makeGFXTable(ImageDir)
   GameConfig = playdate.datastore.read()
   
   if nil == GameConfig then
      GameConfig={}
      GameConfig["which"]="Line"
      GameConfigAtStart=deepcopy(GameConfig)
      playdate.datastore.write(GameConfig)
      State = StateTable.DrawingMenus
   else
      GameConfigAtStart = deepcopy(GameConfig)
      State = StateTable.DrawingShapes      
   end
      
   local menu=playdate.getSystemMenu()
   menu:addMenuItem("Configure",function() State=StateTable.DrawingMenus end)
   
   ShapeName=GameConfig["which"]
   
   drawNewMandala()
   
   gfx.setImageDrawMode(gfx.kDrawModeNXOR)

   
end

-- Remove moving sprite from screen
function deleteOldMandala()
   MandalaGFX[ShapeName][2]:remove()
end

-- Draw new moving sprite on screen
function drawNewMandala()
   MandalaGFX[ShapeName][2]:moveTo(200,120)
   MandalaGFX[ShapeName][2]:add()
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
	 local crankTicks=playdate.getCrankTicks(180)

	 if crankTicks ~= 0 then
	    CurrentRotation = CurrentRotation + crankTicks	 
	    MandalaGFX[ShapeName][2]:setRotation(CurrentRotation,400/240)
	 end      
	 gfx.sprite.update()
	 MandalaGFX[ShapeName][1]:draw(0,0)
      elseif State == StateTable.ReadingMenus then	 
	 CurrentChoice = editConfiguration()
	 if (CurrentChoice ~= nil) and (CurrentChoice ~= ShapeName) then
	    deleteOldMandala()
	    ShapeName = CurrentChoice
	    writeConfiguration()
	    GameConfig["which"] = ShapeName
	    drawNewMandala()
	    State=StateTable.DrawingShapes
	 end	 
      elseif State == StateTable.DrawingMenus then
	 playdate.graphics.clear()   
	 editConfigurationSetup(GameConfig,MandalaGFX)
	 State=StateTable.ReadingMenus	 
      end      
   end
   
end
