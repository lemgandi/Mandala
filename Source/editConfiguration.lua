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

function editConfiguration(configTable,GFXTable)
   local myFont=gfx.font.new('Resources/configFont/Roobert-20-Medium')
   print("myFont:",myFont)
   
   local yLocation=0
   local yStep=24
   local w,h
   

   
   gfx.setFont(myFont)
  
   for kk in pairs(GFXTable) do
      w,h = gfx.drawText(kk,30,yLocation)
      print("Width:",w,"Height:",h)
      yLocation = yLocation + yStep
   end
         
end
