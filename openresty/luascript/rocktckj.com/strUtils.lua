package.path  = '/usr/local/openresty/luascript/rocktckj.com/?.lua;;./?.lua;/usr/local/openresty/luaconfig/?.lua;' .. package.path
local strUtils = function ()
	local self = {}
	self.construct = function()
        return
    end
	self.isNotEmpty = function (obj)
	  if (obj ~= nil and obj ~= ngx.null and obj ~= '') then
	    --local isTable = type(obj) == 'table'
	    --if ((isTable and table.getn(obj)>0) or not isTable) then
	    --  return true
	    --end
	    return true
	  end
	  return false
	end
	self.getIntPart = function (x)
        if x<= 0 then
            return math.ceil(x)
        end
        if math.ceil(x) == x then
            x = math.ceil(x)
        else
            x = math.ceil(x)-1
        end
        return x
    end

    self.split = function(s, p)
        local rt= {}
        string.gsub(s, '[^'..p..']+', function(w) table.insert(rt, w) end )
        return rt
    end


    self.urlEncode = function (s)
         s = string.gsub(s, "([^%w%.%- ])", function(c) return string.format("%%%02X", string.byte(c)) end)
        return string.gsub(s, " ", "+")
    end
    self.isOuNumber = function(num)      --是否是偶数
        local num1,num2=math.modf(num/2)--返回整数和小数部分
        if(num2==0)then
            return true
        else
            return false
        end
    end
	self.format_hgetall = function (hmap)
		local res = {};
		if(hmap ~= nil and hmap ~= '') then
			for i=1,#hmap,2 do
				res[hmap[i]] = hmap[i+1]
			end
		end
		return res
	end
	self.guid = function ()
	    local seed={'e','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'}
	    local tb={}
	    for i=1,32 do
	        table.insert(tb,seed[math.random(1,16)])
	    end
	    local sid=table.concat(tb)
	    return string.format('%s%s%s%s%s',
	        string.sub(sid,1,8),
	        string.sub(sid,9,12),
	        string.sub(sid,13,16),
	        string.sub(sid,17,20),
	        string.sub(sid,21,32)
	    )
	end



	self.matchStr = function (str,regexStr)
		if(self.isNotEmpty(str)) then
			
			-- return true
			return string.find(str,regexStr,0) ~= nil
		end
		return false;
	end
	local numRex = '^%d+$'
	self.isNumber =  function (str)
		-- local cjson=require("cjson")
		-- for i,v in ipairs(str) do
		-- 	ngx.say("isNumber:"..v)
		-- end
		-- ngx.say("isNumber:"..type(str))
		return self.matchStr(str,numRex);
	end
	self.replaceAll =  function (str,findstring,replacestring)
		return string.gsub(str,findstring,replacestring)
	end
	self.split = function ( tempStr,reps )
	    local resultStrList = {}
	    string.gsub(tempStr,'[^'..reps..']+',function ( w )
	        table.insert(resultStrList,w)
	    end)
	    return resultStrList
	end
	self.GetPreciseDecimal = function (nNum, n)
	    if type(nNum) ~= "number" then
	        return nNum;
	    end
	    n = n or 0;
	    n = math.floor(n)
	    if n < 0 then
	        n = 0;
	    end
	    local nDecimal = 10 ^ n
	    local nTemp = math.floor(nNum * nDecimal);
	    local nRet = nTemp / nDecimal;
	    return nRet;
	end
	return self

end
return strUtils
