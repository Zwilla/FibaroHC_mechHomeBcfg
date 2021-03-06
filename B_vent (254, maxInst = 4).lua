--[[
%% properties
36 value
%% globals
--]]
--301 value


-- CONSTS

local debugMode = true;

-- Devices ID's
local doorBath_ID = 307;
local TBL_rGbw_B_ID = 36;
local TB_vent_ID = 12;


-- PROCESS

fibaro:sleep(50); -- to prevent to kill all instances
if ( fibaro:countScenes() > 1 ) then
  if ( debugMode ) then fibaro:debug("Double start"
    .. " (" .. tostring(fibaro:countScenes()) .. ").. Abort dup!"); end
  fibaro:abort();
end

if ( (fibaro:getValue(TB_vent_ID, "value") == "0")
  and (fibaro:getGlobalValue("B_vent") == "0") ) then
  
  fibaro:sleep(4000); -- 4 second timeout to prevent trigger on the door close
  	-- and light slow dimming off
  
  if ( --(fibaro:getValue(doorBath_ID, "value") == "0") and
    (tonumber(fibaro:getValue(TBL_rGbw_B_ID, "value")) > 0) ) then
    
    fibaro:setGlobal("B_vent", "1");
    
    if ( debugMode ) then
      fibaro:debug("Somebody in bathroom ("
        --.. "door is closed and "
        .. "light is on) - set B_vent status"); end
    
    local startTime = os.time();
    
    while ( --(fibaro:getValue(doorBath_ID, "value") == "0")
        (tonumber(fibaro:getValue(TBL_rGbw_B_ID, "value")) > 0)
      and ((os.time() - startTime) <= (3 * 60)) ) do
      
      fibaro:sleep(1500);
      
    end
    
    if --( fibaro:getValue(doorBath_ID, "value") == "0" ) then
      ( (fibaro:getValue(TB_vent_ID, "value") == "0")
      and (tonumber(fibaro:getValue(TBL_rGbw_B_ID, "value")) > 0) ) then
      
      if ( debugMode ) then
        fibaro:debug("It's took 3 min - turn ON vent in MAX!");
      end
      
      fibaro:call(TB_vent_ID, "setValue", "100");
      
      startTime = os.time();
      
      while ( --(fibaro:getValue(doorBath_ID, "value") == "0")
          (tonumber(fibaro:getValue(TBL_rGbw_B_ID, "value")) > 0)
        and ((os.time() - startTime) <= (1 * 60)) ) do
        
        fibaro:sleep(1500);
        
      end
      
      if ( debugMode ) then
        fibaro:debug("Turn OFF vent and wait auto-on by humidity sensor..");
      end
      
      fibaro:call(TB_vent_ID, "setValue", "0");
      
      startTime = os.time();
      
      while ( --(fibaro:getValue(doorBath_ID, "value") == "0")
          (tonumber(fibaro:getValue(TBL_rGbw_B_ID, "value")) > 0)
        and ((os.time() - startTime) <= (3 * 60 * 60)) ) do
        
        fibaro:sleep(3000);
        
      end
      
      if ( (fibaro:getValue(TB_vent_ID, "value") ~= "0") ) then
        
        while ( (fibaro:getValue(TB_vent_ID, "value") ~= "0")
          and ((os.time() - startTime) <= (6 * 60 * 60)) ) do
          
          fibaro:sleep(3000);
          
        end
        
        if ( fibaro:getValue(TB_vent_ID, "value") ~= "0" ) then
          
          if ( debugMode ) then
            fibaro:debug("Turn OFF vent (too long time is on)!");
          end
          fibaro:call(TB_vent_ID, "setValue", "0");
          
        else
          
          if ( debugMode ) then
            fibaro:debug("Auto OFF vent (by hum. sens.)");
          end
          
        end
        
      end
      
    end
    
    if ( debugMode ) then fibaro:debug("CLEAR B_vent status"); end
    
    fibaro:setGlobal("B_vent", "0");
    
  end
  
end
