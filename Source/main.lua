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

gfx = playdate.graphics
ImageDir="Images/shapes/"

MandalaGFX = {}

local CurrentRotation = 0
local ShapeName="Line"

local GameState = {}


function setupMandala()

   MandalaGFX=makeGFXTable(ImageDir)
--[[   
   for kk,vv in pairs(MandalaGFX)
   do
      local theSprite=gfx.sprite.new()
      theSprite:setImage(vv[1],0,400/240)
      table.insert(vv,theSprite)
   end
]]   
--[[   GameState["which"]="Line"
   playdate.datastore.write(GameState)
]]
   
   GameState=playdate.datastore.read()
   ShapeName=GameState["which"]
   
   MandalaGFX[ShapeName][2]:moveTo(200,120)
   MandalaGFX[ShapeName][2]:add()

   gfx.setImageDrawMode(gfx.kDrawModeNXOR)

   
end
-- Main Line starts Here

setupMandala()

function playdate.update()
   do
      local crankTicks=playdate.getCrankTicks(180)

      if crankTicks ~= 0 then
	 CurrentRotation = CurrentRotation + crankTicks	 
	 MandalaGFX[ShapeName][2]:setRotation(CurrentRotation,400/240)
      end      
      gfx.sprite.update()
      MandalaGFX[ShapeName][1]:draw(0,0)
   end   
end
