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

-- In global table
EditingConfig=false

local GameState
local debugPrinted=false

function runConfigEditor()
   gfx.clear()
   EditingConfig=true
   editConfigurationSetup(GameState,MandalaGFX)
   editConfiguration()
   playdate.datastore.write(GameState)   
end


function setupMandala()

   MandalaGFX=makeGFXTable(ImageDir)
   

   GameState=playdate.datastore.read()
   print("GameState:",GameState)

   if nil == GameState then
      GameState={}
      GameState["which"]="Line"
      playdate.datastore.write(GameState)
      editConfigurationSetup(GameState,MandalaGFX)      
      EditingConfig=true
   end
   
   local menu=playdate.getSystemMenu()
   menu:addMenuItem("Configure",runConfigEditor)
   
   ShapeName=GameState["which"]
   
   MandalaGFX[ShapeName][2]:moveTo(200,120)
   MandalaGFX[ShapeName][2]:add()

   gfx.setImageDrawMode(gfx.kDrawModeNXOR)

   
end
-- Main Line starts Here

setupMandala()

function playdate.update()
   do
      if not debugPrinted then
	 print("EditingConfig:",EditingConfig)
	 debugPrinted=true
      end
      
      if not EditingConfig then
	 local crankTicks=playdate.getCrankTicks(180)

	 if crankTicks ~= 0 then
	    CurrentRotation = CurrentRotation + crankTicks	 
	    MandalaGFX[ShapeName][2]:setRotation(CurrentRotation,400/240)
	 end      
	 gfx.sprite.update()
	 MandalaGFX[ShapeName][1]:draw(0,0)
      else
	 editConfiguration()
      end
   end
   
end
