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


function editConfigurationSetup(configTable,GFXTable)
   local myFont=gfx.font.new('Resources/configFont/Roobert-20-Medium')
   print("myFont:",myFont)
   
   local yLocation=24
   local yStep=24
   local w,h
   local shapeNames={}
   
   gfx.setFont(myFont)
  
   for kk in pairs(GFXTable) do
      table.insert(shapeNames,kk)
   end
   table.sort(shapeNames)
   
   for kk,vv in ipairs(shapeNames) do
      w,h = gfx.drawText(vv,30,yLocation)
      yLocation = yLocation + yStep
   end
   
end

function editConfiguration()
         if playdate.buttonIsPressed(playdate.kButtonB) then
	 EditingConfig = false
      end      
end
