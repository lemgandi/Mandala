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

-- Are two GFXTable entries equivalent (for sort by prompt)
function GFXTableCompareEntries(vf,vs)
   local retVal=true
   if vf.prompt >= vs.prompt then
      retVal=false
   end
   return retVal
end

-- Make global graphics table from pictures in tableDir
function makeGFXTable(tableDir)
   local fileList=playdate.file.listFiles(tableDir)
   local retVal = {}
   local gfxEntry={}
   local searchExtension = "%.pdi$"
   local prompt
   
--[[
   GFX table. Each entry contains:
   * Prompt (filename of png)
   * Image from png
   * Sprite from image of png
]]
   
   for kk,vv in pairs(fileList) do
      if nil ~= string.find(vv,searchExtension) then
	 prompt = string.gsub(vv,searchExtension,"")
	 local theSprite=gfx.sprite.new()
	 gfxEntry = {gfx.image.new(tableDir .. vv)}      
	 theSprite:setImage(gfxEntry[1],gfx.kImageUnflipped)
	 table.insert(gfxEntry,theSprite)
	 gfxEntry["prompt"]=prompt
	 table.insert(retVal,gfxEntry)
      end      
   end
   
   -- Sort GFX table by prompt so menu displays in alpha order.
   table.sort(retVal,GFXTableCompareEntries)
   
   return retVal
end
--[[
-- Is GFX table valid?
function testGFXTable()
   local theTable=makeGFXTable(ImageDir)
   printTable(theTable)
end

-- Does GFX table search by prompt actually workee?
function testSearchGFXTable()
   local theTable=makeGFXTable(ImageDir)
   local tableKey=searchGFXTable("Line",theTable)   
   printTable( theTable[tableKey] )	      
end
]]


-- Find a GFX table entry by its prompt from menu
function searchGFXTable(p,t)
   for kk,vv in pairs(t) do
      if vv.prompt == p then
	 return kk
      end
   end   
end
