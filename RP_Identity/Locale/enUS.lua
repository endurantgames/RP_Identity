local addOnName, ns = ...;
local L = LibStub("AceLocale-3.0"):NewLocale(addOnName, "enUS", true);

local addOnTitle = GetAddOnMetadata(addOnName, "Title");
local addOnVersion = GetAddOnMetadata(addOnName, "Version");
local addOnDate = GetAddOnMetadata(addOnName, "X-VersionDate");
  
local SLASH = "|cff00ffff/rpid|r ";
local POPUP_CLEAR = "RP_IDENTITY_CLEAR_AND_PRESENT_DANGER";

L["Beginner"                 ] = "Beginner";
L["Button Cancel"            ] = "Cancel";
L["Button Config"            ] = "Options";
L["Button Clear"             ] = "Defaults";
L["Button Save"              ] = "Save";
L["Casual"                   ] = "Casual";
L["Config Options"           ] = "Configuration Options";
L["Config Show Icon Tooltip" ] = "Show or hide the minimap icon.";
L["Config Show Icon"         ] = "Show Icon";
L["Config Notify Profile Sent"] = "Notify Profile Sent";
L["Config Notify Profile Sent Tooltip"] = "Check to get a notification in the text window when your profile is sent to someone.";
L["Config Auto-Request Profiles"] = "Auto-Request Profiles";
L["Config Auto-Request Profiles Tooltip"] = "Check to automatically request someone's profile when they request yours.";
L["Config Mouseover Request"] = "Request Profile on Mouseover";
L["Config Mouseover Request Tooltip"] = "Check to automatically request someone's profile when you mouse over them.";
L["Config Hear Someone Request"] = "Request Profile when Heard";
L["Config Hear Someone Request Tooltip"] = "Check to automatically request someone's profile when you hear them speak or emote.";
L["Config Target Request" ] = "Request Target's Profile";
L["Config Target Request Tooltip"] = "Check to automatically request someone's profile when you target them.";
L["Config Focus Request" ] = "Request Focus Target's Profile";
L["Config Focus Request Tooltip"] = "Check to automatically request someone's profile when you set them as your focus target.";
L["Config Party Request"] = "Request Party Members' Profiles";
L["Config Party Request Tooltip"] = "Check to automatically request the profiles of anyone in a party that you join.";
L["Config Raid Request"] = "Request Raid Members' Profiles";
L["Config Raid Request Tooltip"] = "Check to automatically request the profiles of anyone in a raid that you join.";
L["Custom Honorific"         ] = "Custom Honorific";
L["Custom Icon"              ] = "Custom Icon";
L["Custom Pronouns"          ] = "Custom Pronouns";
L["Custom Status"            ] = "Custom Status"
L["Custom Style"             ] = "Custom Style";
L["Full-Time"                ] = "Full-Time";
L["Gender (Female)"          ] = " (Female)";
L["Gender (Male)"            ] = " (Male)";
L["Gender (Neutral)"         ] = "";
L["Group Appearance"         ] = "Appearance";
L["Group Basics"             ] = "Basic Details";
L["Group Bio"                ] = "Biography";
L["Group Name"               ] = "Name";
L["Group Social"             ] = "Social";
L["Group Status"             ] = "Status";
L["Honorifics List"          ] = "Mrs.|Ms.|Miss|Mx.|Mr.|Lord|Lady|Sir|Ser|Dr.|Prof.";
L["In Character"             ] = "In Character";
L["Label AE"                 ] = "Eye Color";
L["Label AG"                 ] = "Age";
L["Label AH"                 ] = "Height";
L["Label AW"                 ] = "Weight";
L["Label CO"                 ] = "OOC Info";
L["Label CU"                 ] = "Currently";
L["Label Color"              ] = "Color";
L["Label DE"                 ] = "Description";
L["Label FC"                 ] = "Character Status";
L["Label FC-custom"          ] = "Custom Status";
L["Label FR"                 ] = "Roleplaying Style";
L["Label FR-custom"          ] = "Custom Style";
L["Label HB"                 ] = "Birthplace";
L["Label HH"                 ] = "Home";
L["Label HI"                 ] = "History";
L["Label MO"                 ] = "Motto";
L["Label NA"                 ] = "Name";
L["Label NH"                 ] = "Affiliation";
L["Label NI"                 ] = "Nickname";
L["Label NT"                 ] = "Title";
L["Label PN"                 ] = "Pronouns";
L["Label PN-custom"          ] = "Custom Pronouns";
L["Label PX"                 ] = "Honorific";
L["Label PX"                 ] = "Honorific";
L["Label PX-custom"          ] = "Custom Honorific";
L["Label RA"                 ] = "Race";
L["Label RC"                 ] = "Class";
L["Looking for Contact"      ] = "Looking for Contact";
L["Normal"                   ] = "Normal";
L["(not saved)"]               = " (not saved)";
L["Out of Character"         ] = "Out of Character";
L["No Pronouns"              ] = "No Pronouns";
L["No Honorific"             ] = "No Honorific";
L["Pronouns He/Him"          ] = "He/Him";
L["Pronouns It/Its"          ] = "It/Its";
L["Pronouns She/Her"         ] = "She/Her";
L["Pronouns They/Them"       ] = "They/Them";
L["Pronouns List"            ] = "Fae/Faer|Xe/Xem";
L["Slash Options"            ] = SLASH .. "|cffffff00options|r - Open the options panel";
L["Slash Open"               ] = SLASH .. "|cffffff00open|r - Open the profile editor";
L["Slash Toggle Editor"      ] = SLASH .. "|cffffff00toggle editor|r -- Toggle the profile editor";
L["Slash IC"                 ] = SLASH .. "|cffffff00ic|r - Set your status to in character";
L["Slash OOC"                ] = SLASH .. "|cffffff00ooc|r - Set your status to out of character";
L["Slash Toggle Status"      ] = SLASH .. "|cffffff00toggle status|r - Toggle between IC and OOC status";
L["Slash Status"             ] = SLASH .. "|cffffff00status [value]|r - Set your status";
L["Slash Currently"          ] = SLASH .. "|cffffff00currently [value]|r - Set your currently";
L["Slash Info"               ] = SLASH .. "|cffffff00info [value]|r - Set your OOC info";
L["Slash Commands"           ] = "Slash Commands";
L["Your Current Status Is"   ] = "Your current status is:";
L["Your Currently Is"        ] = "Your currently is:";
L["Your OOC Info Is"        ] = "Your OOC info is:";
L["Sent Profile To %s"       ] = "You sent your profile info to |cffffff00%s|r.";

-- L["Pronouns List"         ] = ""; -- leave blank if none extra needed
L[POPUP_CLEAR                      ] = "|cffff0000Warning!|r\n\nThis will reset your saved identity. Are you sure that's what you want to do?";
L["Storyteller"              ] = "Storyteller";
L["Undefined"                ] = "Undefined";
L["Version Info"             ] = "You're running " .. addOnTitle .. " version " .. addOnVersion .. " (" .. addOnDate .. ").";
L["Credits Header"           ] = "Credits";
L["Credits Info" ] =
[===[


The coding was done by |cffff33ffOraibi-MoonGuard|r. 

Several standard libraries were used:

- LibMSP by Etarna Moonsyne, Morgane "Ellypse" Parize, Justin Snelgrove

- Ace3 by Ace3 Development Team

- LibDataBroker by tekkub, Elkano

- LibDBIcon by funkehdude

]===];
L["Support Header"] = "MSP Support";
L["Support Info" ] =
[===[
rpIdentity is obviously a very minimalist implementation of the Mary Sue Protocol (MSP) that's the basis of interoperative RP addons.

The biggest thing lacking is:

|cff33ff33No UI for displaying other peoples' profiles.|r.

That's not a bug; it's intended that way. Once I finish the RP_Tags_RP_Identity module (or is it RP_Identity_RP_Tags?), the idea is that you could use rpIdentity instead of another rpClient, and use rpUnitFrames (or, I guess, ElvUI) to display the data.

More specifics:

- Everything from original Mary Sue Protocol standard is supported.

- A few additional fields that are ubiquitous (i.e. in MyRolePlay, totalRP3, and/or XRP, among others) are supported: ooc Info, colors for names and eyes, "honorifics" (i.e. short prefixed titles such as "Lady" or "Mx."), and pronoun fields.

- These are planned for support: relationship status, icons.

- The following are NOT supported, and likely will not be supported: at first glance fields; "PS" attributes (personality traits); music.

]===];
L["None"                     ] = "None";
L["rpIdentity Icon"          ] = addOnTitle .. " Mask";
