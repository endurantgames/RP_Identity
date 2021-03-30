-- RP Tags 
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license.
--
local addOnName, ns = ...;
local RPTAGS        = RPTAGS;
local Module        = RPTAGS.queue:NewModule(addOnName, "rpClient");
local AceEvent = LibStub("AceEvent-3.0");

Module:WaitUntil("ADDON_LOAD",
function(self, event, ...)
    local getUnitID = RPTAGS.utils.get.core.unitID;
    local refreshFrame = RPTAGS.utils.tags.refreshFrame;
      table.insert(msp.callback.received, 
        function(unitID)
          RPTAGS.utils.frames.refreshAll();
        end);
end);

Module:WaitUntil("ADDON_LOAD",
function(self, event, ...)
  AceEvent.RegisterMessage(self, "RP_IDENTITY_READY",
    function(self, event, ...)
      print("variables loaded");
      if RP_Identity.db.profile.myMSP.VA
      and not RP_Identity.db.profile.msp.my.VA:match(RPTAGS.metadata.Title)
      then print("no rptags found");
           RP_Identity.db.profile.myMSP.VA =
           RPTAGS.metadata.Title .. "/" .. RPTAGS.metadata.Version .. " + " ..
           RP_Identity.db.profile.myMSP.VA
      end;
  end)
end);

Module:WaitUntil("MODULE_D",
function(self, event, ...)
  AceEvent.RegisterMessage(self, "RP_IDENTITY_UPDATE_IDENTITY", function(self, event, ...) RPTAGS.utils.frames.refreshAll() end);
end);

Module:WaitUntil("MODULE_C",
function(self, event, ...)
  local registerFunction = RPTAGS.utils.modules.registerFunction;
  local rpIdentityTitle = GetAddOnMetadata("RP_Identity", "Title");

  local function openRpIdentityConfig()
    InterfaceOptionsFrame:Show();
    InterfaceOptionsFrame_OpenToCategory(rpIdentityTitle);
  end;

  local function openRpIdentityEditor()
    RP_Identity.Editor:ReloadTab();
    RP_Identity.Editor.frame:Show();
  end;

  registerFunction("RP_Identity", "open",       openRpIdentityEditor);
  registerFunction("RP_Identity", "options",    openRpIdentityConfig);
  registerFunction("RP_Identity", "version",    openRpIdentityConfig);
  registerFunction("RP_Identity", "help",       openRpIdentityConfig);
  registerFunction("RP_Identity", "about",      openRpIdentityConfig);

  -- registerFunction("RP_Identity", "setcurr",    mapMrpSlash("currently" ));
  -- registerFunction("RP_Identity", "setic",      mapMrpSlash("ic"        ));
  -- registerFunction("RP_Identity", "setooc",     mapMrpSlash("ooc"       ));

end);

