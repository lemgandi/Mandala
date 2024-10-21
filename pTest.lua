#! lua

function pTest(...)
   
	local kk,vv,fmtstr,fs
	local prtstr=""
	for kk,vv in ipairs({...}) do
		fmtstr="%s "
   		if type(vv) == 'number' then 
			fmtstr="%d "
		elseif type(vv) ~= 'string' and type(vv) ~= 'boolean' then
			fmtstr="%p "
		end
		fs = string.format(fmtstr,vv)
		prtstr = prtstr .. fs
	end
	print(prtstr)

	
end
