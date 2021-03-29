-- RP Tags 
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
-- This work is licensed under the Creative Commons Attribution 4.0 International (CC BY 4.0) license. 

local addOnName, ns = ...
local RPTAGS        = RPTAGS;
local Module        = RPTAGS.queue:GetModule(addOnName);
local Target = GetAddOnMetadata(addOnName, "X-RPQModuleTarget");

Module:WaitUntil("MODULE_G",
function(self, event, ...)
  local build_keybind = RPTAGS.utils.options.keybind;
  local addOptions    = RPTAGS.utils.modules.addOptions;

  addOptions(addOnName, "general.keybind",
    { ic_ooc = build_keybind("ic_ooc"), }
    );
end);

Module:WaitUntil("CORE_KEYBIND",
function(self, event, ...)
  local registerKeybind = RPTAGS.utils.keybind.register;
  local linkHandler = RPTAGS.utils.links.handler;
  local run = RPTAGS.utils.modules.runFunction;
  
  registerKeybind("IC_OOC", 
    function()
      if msp.my.FC == "1" -- ooc
         then linkHandler("addon://RP_Identity?setic")
         else linkHandler("addon://RP_Identity?setooc")
      end;
    end
  );
  
end);
