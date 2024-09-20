--[[
   Create base table of images and sprites.

   copyright(c) Charles Shapiro September 2024

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

]]


import "CoreLibs/string"
import "CoreLibs/strict"

function makeGFXTable(tableDir)
   local fileList=playdate.file.listFiles(tableDir)
   local fnKey=nil
   local retVal = {}
   local searchExtension = "%.pdi$"
   
   for kk,vv in pairs(fileList) do
      if nil ~= string.find(vv,searchExtension) then
	 fnKey=string.gsub(vv,searchExtension,"")
	 local theSprite=gfx.sprite.new()
	 retVal[fnKey]={gfx.image.new(tableDir .. vv)}      
	 theSprite:setImage(retVal[fnKey][1],0,400/240)
	 table.insert(retVal[fnKey],theSprite)
      end      
   end
   
--[[   
   for kk,vv in pairs(retVal) do      
      print(kk,type(vv[1]),type(vv[2]))
   end
]]
   
   return retVal
end
