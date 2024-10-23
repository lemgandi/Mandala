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


local MenuItems
local Debug_timescalled=0

local debug=false

-- Write config data iff dirty
function writeConfiguration(old,new)
   local dirtyFlag=false
   
   for kk,vv in pairs(new) do
      if old[kk] ~= vv then
	 dirtyFlag=true
      end
   end
   
-- Check for deleted keys in new config table e.g. rearshapekey   
   for kk in pairs(old) do
      if new[kk] == nil then
	 dirtyFlag = true
      end
   end
   
   if dirtyFlag then
      playdate.datastore.write(new)      
      old = table.deepcopy(new)      
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
function SearchTableByPrompt(p,t)
   
   local retVal = nil
   
   for kk,vv in pairs(t) do
      if vv.prompt == p then
	 retVal = kk
	 break
      end
   end
   return retVal
end


-- Draw a banner indicating what menu we are on
function DrawBanner(banner,bannerBottom,leftJ)
   
   local currentColor=gfx.getColor()
   
   if bannerBottom == nil then
      bannerBottom = _G.allFont:getHeight()
   end
   
   gfx.setColor(gfx.kColorBlack)
   gfx.fillRect(0,0,400,bannerBottom)
   gfx.setColor(gfx.kColorXOR)
   gfx.drawText(banner,leftJ,0)
   gfx.setColor(currentColor)

end

function playdate.keyPressed(k)
   
   if k == 't' then
       debug = not debug
   end
   
end

function playdate.debugDraw()
   if debug == true then
      gfx.fillRect(150,90,150,90)
   end   
end

-- Print iff debug is true.
function Debug_print(...)
   
   if (debug == true) then
      local kk,vv,fmtstr,fs
      local prtstr=""
      for kk,vv in ipairs({...}) do
	 fmtstr="%s "
	 if type(vv) == 'number' then 
	    fmtstr="%f "
	 elseif type(vv) ~= 'string' and type(vv) ~= 'boolean' then
	    fmtstr="%p "
	 end
	 fs = string.format(fmtstr,vv)
	 prtstr = prtstr .. fs
      end
      print(prtstr)            
   end   
end

-- Compute upper left corner of scaled image to draw.  This is a function so we can call it from
-- changeScale.
function computeScaleXY(scale)
   local xPlace
   local yPlace

   xPlace = (400 - (400 * scale)) / 2
   yPlace = (240 - (240 * scale)) / 2
   
   return xPlace,yPlace
end
