--[[
   Utility functions

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
      GameConfigAtStart = table.deepcopy(GameConfig)      
   end
   
end


-- Are two GFXTable entries equivalent (for sort by prompt)
function CompareMenuTableEntries(vf,vs)
   local retVal=true
   if vf.prompt >= vs.prompt then
      retVal=false
   end
   return retVal
end

-- Find a table entry by its prompt from menu
function searchTableByPrompt(p,t)
   for kk,vv in pairs(t) do
      if vv.prompt == p then
	 return kk
      end
   end   
end

function SearchMenuTable(p,t)
   for kk,vv in pairs(t) do
      if vv.prompt == p then
	 return kk
      end
   end   
end
