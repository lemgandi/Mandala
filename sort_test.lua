
foo={prompt="Enter the thing",{"aaa",1},{"ccc",2},{"bbb",3},{"ddd",4},{"kkk",5},{"eee",6}}
-- foo={{"aaa",1},{"ccc",2},{"bbb",3},{"kkk",4}  }

print("Before")
for kk,vv in ipairs(foo) do 
   print("Key:",kk,"Type:",type(vv),"value[1]:",vv[1],"value[2]:",vv[2])
end

function comp(vf,vs)
   local retVal=true
   
   if vf[1] >= vs[1] then
      retVal=false
   end
   
   return retVal
end

table.sort(foo,comp)
-- print(comp(foo[1],foo[2]))

print("After")
for kk,vv in ipairs(foo) do
 print("Key:",kk,"value[1]:",vv[1],"value[2]:",vv[2])
end
print("Prompt:",foo.prompt)
