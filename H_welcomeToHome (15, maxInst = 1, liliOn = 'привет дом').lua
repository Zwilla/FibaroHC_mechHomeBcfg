--[[
%% properties
187 value
%% globals
--]]


local vdLightHllID        = 207;
local vdLightHllSwitchBtn = "5";

local startSource = fibaro:getSourceTrigger();

local intDoorVal, intDoorMT = fibaro:get(248, "value");
local extDoorVal, extDoorMT = fibaro:get(187, "value");

if (
  (
    (extDoorVal == "1")
    and (
      (intDoorVal == "0") or (os.time() - intDoorMT > 60)
    )
    and (fibaro:getGlobalValue("twilightMode") == "1")
    and (
      (fibaro:getValue(150, "value") == "0")
      or (fibaro:getValue(150, "dead") >= "1")
    )
  )
  or
  (startSource["type"] == "other")
) then
  
  --[[
  local isLightInRoom = -- simple sleep detection
    ( tonumber(fibaro:getValue(40, "value")) > 0 ) -- ctrlBigRoom:��������
  --  or ( tonumber(fibaro:getValue(228, "value")) > 0 ) -- ��:��������� (- ��� �����.)
    or ( tonumber(fibaro:getValue(230, "value")) > 0 ) -- ��:���(������.)
  
  if not isLightInRoom then
    fibaro:setGlobal("lightsQueue", fibaro:getGlobalValue("lightsQueue")
      .. "150,110;");
  else  
    fibaro:setGlobal("lightsQueue", fibaro:getGlobalValue("lightsQueue")
      .. "150,200;");
  end
  --]]
  
  fibaro:call(vdLightHllID, "pressButton", vdLightHllSwitchBtn);
  
  fibaro:debug("Hall illumination ON");
  
end
