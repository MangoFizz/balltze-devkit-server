local tonumber = tonumber
local tostring = tostring
local error = error

--module('tango.utils.socket_message')

local send = 
   function(socket,message)
      local sent,err = socket:send(message)
      if not sent then
         error(err)
      end
   end

local receive = 
   function(socket,on_error)
      local response,err = socket:receive('*l')
      if not response then
         error(err)
      end            
      return response
   end

return {
  send = send,
  receive = receive
}
