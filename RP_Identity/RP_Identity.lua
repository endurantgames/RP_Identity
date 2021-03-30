-- rpIdentity
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
--
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license.

      --[[
            MSP Fields:
      
            AE = eye color
            AG = age
            AH = height
            AW = weight
            CO = ooc info
            CU = ic currently
            DE = description
            FC = status (ic/ooc/etc/custom)
            FR = rp style (/custom)
            GC = game class
            GF = game faction
            GR = game race
            GS = game gender
            GU = game GUID
            HB = birthplace
            HH = home
            IC = icon
            MO = motto
            NA = name
            NH = house
            NI = nickname
            NT = title
            PE = at first glance
            PN = pronouns
            PX = honorific
            RA = race
            RC = class
            TR = character is trial
            VA = addon version
            VP = MSP version
      
            support needed:
            RS = relationship status
      
            not supported:
            MU = music
            PS = personality traits
            LC = ...color?
      --]]
 
local addOnName, ns = ...;

local ALL_FIELDS = { 
  "AE", "AG", "AH", "AW", "CO", 
  "CU", "DE", "FC", "FR", "HB", 
  "HH", "IC", "MO", "NA", "NH", "NI", 
  "NT", "PE", "PN", "PX", "RA", "RC", 
  "TR", "VA", "VP" 
};

msp:AddFieldsToTooltip("CO", "RC", "IC", "PN", "PE")
local L = LibStub("AceLocale-3.0"):GetLocale(addOnName);
local AceGUI = LibStub("AceGUI-3.0");

local RP_Identity = LibStub("AceAddon-3.0"):NewAddon( addOnName, "AceConsole-3.0", "AceEvent-3.0"
                      -- , "AceTimer-3.0"
                      );

local maskIcon = "Interface\\ICONS\\Ability_Racial_Masquerade.PNG";
local maskIconNoPath = "Ability_Racial_Masquerade.PNG";

RP_Identity.addOnName    = addOnName;
RP_Identity.addOnTitle   = GetAddOnMetadata(addOnName, "Title");
RP_Identity.addOnVersion = GetAddOnMetadata(addOnName, "Version");
RP_Identity.addOnIcon    = maskIcon;
RP_Identity.addOnColor   = { 51 / 255, 1, 85 / 255, 1 };

local function notify(...) print("[" .. RP_Identity.addOnTitle .. "]", ...) end;

local myDataBroker = 
        LibStub("LibDataBroker-1.1"):NewDataObject(
            RP_Identity.addOnTitle,
            { type    = "data source",
              text    = RP_Identity.addOnTitle,
              icon    = maskIcon,
              OnClick = function() RP_Identity:ToggleEditorFrame() end,
            }
        );
        
local myDBicon = LibStub("LibDBIcon-1.0");

local myDefaults =
      { profile =
            { config =
                  { showIcon = true, 
                    lockFrame = false,
                    saveDimensions = false,
                    notifyProfile = false,
                    autoRequest = true,
                    mouseoverRequest = true,
                    hearSomeone = false,
                    partyRequest = true,
                    raidRequest = false,
                    targetRequest = true,
                    focusRequest = true,
                    editorTooltips = true,
                    autoSave = false,
                    tooltipsFadeOut = true,
                  },
              myMSP =
                  { 
                        AE = "",
                        AG = "",
                        AH = "",
                        AW = "",
                        CO = "",
                        CU = "",
                        DE = "",
                        FC = "0",
                        FR = "0",
                        HB = "",
                        HI = "",
                        IC = maskIconNoPath,
                        HO = "",
                        MO = "",
                        NA = UnitName("player"),
                        NH = "",
                        NI = "",
                        NT = "",
                        PN = "",
                        PX = "",
                        RA = UnitRace("player"),
                        RC = UnitClass("player"),
                        VA = RP_Identity.addOnTitle .. "/" .. RP_Identity.addOnVersion,
                        VP = "1",
                        -- TR = IsTrialAccount() and "1" or "0",
                        -- GC = UnitClass("player"),
                        -- GF = UnitFactionGroup("player") .. "",
                        -- GR = UnitRace("player"),
                        -- GS = UnitSex("player") .. "",
                        -- GU = UnitGUID("player"),
                        ["PE1-icon"] = "",
                        ["PE1-title"] = "",
                        ["PE1-text"] = "",
                        ["PE1-icon-custom"] = "",
                        ["PE2-icon"] = "",
                        ["PE2-title"] = "",
                        ["PE2-text"] = "",
                        ["PE2-icon-custom"] = "",
                        ["PE3-icon"] = "",
                        ["PE3-title"] = "",
                        ["PE3-text"] = "",
                        ["PE3-icon-custom"] = "",
                        ["PE4-icon"] = "",
                        ["PE4-title"] = "",
                        ["PE4-text"] = "",
                        ["PE4-icon-custom"] = "",
                        ["PE5-icon"] = "",
                        ["PE5-title"] = "",
                        ["PE5-text"] = "",
                        ["PE5-icon-custom"] = "",
                  },
            },
      };

local function setAutoSave(info, value)
  if value then RP_Identity.Editor:ApplyPending(); end;
  RP_Identity.db.profile.config.autoSave = value;
  RP_Identity.saveButton:SetShown(not value);
  RP_Identity.cancelButton:SetShown(not value);
  RP_Identity.closeButton:SetShown(value);
end;

local realm = GetNormalizedRealmName();
local me = UnitName("player") .. "-" .. realm;

function RP_Identity:OnInitialize()
            
      self.db = LibStub("AceDB-3.0"):New("RP_IdentityDB", myDefaults);

      function self:UpdateIdentity()
            for  field, value in pairs(self.db.profile.myMSP) 
            do   msp.my[field] = value; 
                 msp.char[me].field[field] = value;
            end;
            if self.Editor:IsShown() then self.Editor:ReloadTab(); end;
            msp:Update();
      end;

      self.db.RegisterCallback(self, "OnProfileChanged", "UpdateIdentity");
      self.db.RegisterCallback(self, "OnProfileCopied",  "UpdateIdentity");
      self.db.RegisterCallback(self, "OnProfileReset",   "UpdateIdentity");

      self.options        =
         { type           = "group",
           name           = RP_Identity.addOnTitle,
           order          = 1,
           args           =
           { versionInfo =
             { type = "description",
               name = L["Version Info"],
               order = 1,
             },
             support =
            { type = "group",
              name = L["Support Header"],
              order = 3,
              args =
              { supportHeader =
                { type = "description",
                  fontSize = "medium",
                  name = "|cffffff00" .. L["Support Header"] .. "|r",
                  order = 4,
               },
               supportInfo =
                { type = "description",
                  name = L["Support Info"],
                  order = 5,
                },
              },
            },
             configOptions       =
             { type       = "group",
               name       = L["Config Options"],
               order      = 1,
               args       =
               { showIcon =
                 { name   = L["Config Show Icon"],
                   type   = "toggle",
                   order  = 1,
                   desc   = L["Config Show Icon Tooltip"],
                   get    = function() return self.db.profile.config.showIcon end,
                   set    = "ToggleMinimapIcon",
                   width  = 1.5,
                 },
                 notifyProfileSent =
                 { name = L["Config Notify Profile Sent"],
                   type = "toggle",
                   order = 2,
                   desc = L["Config Notify Profile Sent Tooltip"],
                   get = function() return self.db.profile.config.notifyProfile end,
                   set = function(info, value) self.db.profile.config.notifyProfile = value end,
                   width = 1.5,
                 },
                 autoRequest =
                 { name = L["Config Auto-Request Profiles"],
                   type = "toggle",
                   order = 3,
                   desc = L["Config Auto-Request Profiles Tooltip"],
                   get = function() return self.db.profile.config.autoRequest end,
                   set = function(info, value) self.db.profile.config.autoRequest = value end,
                   width = 1.5,
                 },
                 mouseoverRequest =
                 { name = L["Config Mouseover Request"],
                   type = "toggle",
                   order = 4,
                   desc = L["Config Mouseover Request Tooltip"],
                   get = function() return self.db.profile.config.mouseoverRequest end,
                   set = function(info, value) self.db.profile.config.mouseoverRequest = value end,
                       width = 1.5,
                 },
                 hearSomeoneRequest =
                 { name = L["Config Hear Someone Request"],
                   type = "toggle",
                   order = 5,
                   desc = L["Config Hear Someone Request Tooltip"],
                   get = function() return self.db.profile.config.hearSomeone end,
                   set = function(info, value) self.db.profile.config.hearSomeone = value end,
                   width = 1.5,
                 },
                 targetRequest =
                 { name = L["Config Target Request"],
                   type = "toggle",
                   order = 6,
                   desc = L["Config Target Request Tooltip"],
                   get = function() return self.db.profile.config.targetRequest end,
                   set = function(info, value) self.db.profile.config.targetRequest = value end,
                   width = 1.5,
                 },
                 focusRequest =
                 { name = L["Config Focus Request"],
                   type = "toggle",
                   order = 7,
                   desc = L["Config Focus Request Tooltip"],
                   get = function() return self.db.profile.config.focusRequest end,
                   set = function(info, value) self.db.profile.config.focusRequest = value end,
                   width = 1.5,
                 },
                 partyRequest =
                 { name = L["Config Party Request"],
                   type = "toggle",
                   order = 8,
                   desc = L["Config Party Request Tooltip"],
                   get = function() return self.db.profile.config.partyRequest end,
                   set = function(info, value) self.db.profile.config.partyRequest = value end,
                   width = 1.5,
                 },
                 raidRequest =
                 { name = L["Config Raid Request"],
                   type = "toggle",
                   order = 9,
                   desc = L["Config Raid Request Tooltip"],
                   get = function() return self.db.profile.config.raidRequest end,
                   set = function(info, value) self.db.profile.config.raidRequest = value end,
                   width = 1.5,
                 },
                 autoSave =
                 { name = L["Config Auto Save"],
                   type = "toggle",
                   order = 10,
                   desc = L["Config Auto Save"],
                   get = function() return self.db.profile.config.autoSave end,
                   set = setAutoSave,
                 },
                 tooltipsFadeOut =
                 { name = L["Config Tooltips Fade Out"],
                   type = "toggle",
                   order = 11,
                   desc = L["Config Tooltips Fade Out Tooltip"],
                   get = function() return self.db.profile.config.tooltipsFadeOut end,
                   set = function(info, value) self.db.profile.config.tooltipsFadeOut = value end,
                 },
               },
             },
             profiles     = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db),
             credits =
               { type = "group",
                 name = L["Credits Header"],
                 order = 10,
                 args =
                 {
                   creditsHeader =
                   { type = "description",
                     name = "|cffffff00" .. L["Credits Header"] .. "|r",
                     order = 2,
                     fontSize = "medium",
                   },
                   creditsInfo =
                   { type = "description",
                     name = L["Credits Info"],
                     order = 3,
                   },
                },
              },
           },
         };
      
      myDBicon:Register(RP_Identity.addOnTitle, myDataBroker, RP_Identity.db.profile.config.ShowIcon);

      self:RegisterChatCommand("rpidicon", "ToggleMinimapIcon");

      LibStub("AceConfig-3.0"):RegisterOptionsTable(
          self.addOnName,                  
          self.options
      );
      LibStub("AceConfigDialog-3.0"):AddToBlizOptions(    
          self.addOnName, 
          self.addOnTitle, 
          self.options
      );

      self:UpdateIdentity();
end;

-- data broker
--
function RP_Identity:ToggleMinimapIcon()
      self.db.profile.config.showIcon = not self.db.profile.config.showIcon;
      if self.db.profile.config.showIcon then myDBicon:Show() else myDBicon:Hide(); end;
end;

function RP_Identity:ToggleEditorFrame() 
      if self.Editor
      then if   self.Editor:IsShown() 
           then self.Editor:Hide()
           else self.Editor:ReloadTab(); self.Editor:Show()
           end;
      end;
end;

_G[addOnName] = RP_Identity;

function RP_Identity:OnLoad() 
      self.Editor.tabGroup:SelectTab(groupOrder[1]);
end;

-- msp interactions
--
local playerRequested = "";

function RP_Identity.mspRequestNotifier(playerName)
  if RP_Identity.db.profile.config.notifyProfile and playerName ~= playerRequested
  then notify(string.format(L["Sent Profile To %s"], playerName));
  end;
  if RP_Identity.db.profile.config.autoRequest then msp:Request(playerName, ALL_FIELDS) end;
end;

tinsert(msp.callback.received, RP_Identity.mspRequestNotifier);

function RP_Identity:MouseoverRequestProfile(event)
  if self.db.profile.config.mouseoverRequest and UnitIsPlayer("mouseover")
  then local name, server = UnitFullName("mouseover");
       local playerName = name .. "-" .. (server or realm);
       msp:Request(playerName, ALL_FIELDS);
  end;
end;

RP_Identity:RegisterEvent("UPDATE_MOUSEOVER_UNIT", "MouseoverRequestProfile");

function RP_Identity:HearSomeoneRequestProfile(event, text, playerName, ...)
  if self.db.profile.config.hearSomeone then msp:Request(playerName, ALL_FIELDS); end;
end;

RP_Identity:RegisterEvent("CHAT_MSG_EMOTE",      "HearSomeoneRequestProfile");
RP_Identity:RegisterEvent("CHAT_MSG_SAY",        "HearSomeoneRequestProfile");
RP_Identity:RegisterEvent("CHAT_MSG_TEXT_EMOTE", "HearSomeoneRequestProfile");
RP_Identity:RegisterEvent("CHAT_MSG_WHISPER",    "HearSomeoneRequestProfile");
RP_Identity:RegisterEvent("CHAT_MSG_YELL",       "HearSomeoneRequestProfile");

function RP_Identity:TargetRequestProfile(event)
  if self.db.profile.config.targetRequest and UnitIsPlayer("target")
  then local name, server = UnitFullName("target");
       local playerName = name .. "-" .. (server or realm);
       msp:Request(playerName, ALL_FIELDS);
  end;
end;

RP_Identity:RegisterEvent("PLAYER_TARGET_CHANGED", "TargetRequestProfile");

function RP_Identity:FocusRequestProfile(event)
  if self.db.profile.config.focusRequest and UnitIsPlayer("focus")
  then local name, server = UnitFullName("focus")
       local playerName = name .. "-" .. (server or realm);
       msp:Request(playerName, ALL_FIELDS);
  end;
end;

RP_Identity:RegisterEvent("PLAYER_FOCUS_CHANGED", "FocusRequestProfile");

function RP_Identity:GroupRequestProfile(event)
  if self.db.profile.config.raidRequest and IsInRaid()
  then for i = 1, GetNumGroupMembers()
       do  local playerName, _ = GetRaidRosterInfo(i);
           msp:Request(playerName, ALL_FIELDS)
       end;
  elseif self.db.profile.config.partyRequest and IsInGroup()
  then   if IsInGroup(LE_PARTY_CATEGORY_INSTANCE)
         then for i = 1, 4
              do if UnitInParty("party" .. i)
                 then msp:Request("party" .. i, ALL_FIELDS)
                 end;
              end;
         end;
         if IsInGroup(LE_PARTY_CATEGORY_HOME)
         then for _, playerName in GetHomePartyInfo()
              do msp:Request(playerName, ALL_FIELDS)
              end;
         end;
  end;
end;

RP_Identity:RegisterEvent("GROUP_FORMED",                "GroupRequestProfile");
RP_Identity:RegisterEvent("GROUP_JOINED",                "GroupRequestProfile");
RP_Identity:RegisterEvent("GROUP_ROSTER_UPDATE",         "GroupRequestProfile");
RP_Identity:RegisterEvent("INSTANCE_GROUP_SIZE_CHANGED", "GroupRequestProfile");
RP_Identity:RegisterEvent("RAID_ROSTER_UPDATE",          "GroupRequestProfile");
          
-- db
function RP_Identity:GetMSP(fieldName) return self.db.profile.myMSP[fieldName] or nil  end;
function RP_Identity:SetMSP(fieldName, value) self.db.profile.myMSP[fieldName] = value end;

function RP_Identity:ResetIdentity()
  for field, value in pairs(myDefaults.profile.myMSP) do self:SetMSP(field, value); end;
  self:UpdateIdentity();
end; 

local function generatePE(self)
  print("here we are about to generate some PE");
  local recordSeparator = "\n\n---\n\n"; -- who thought this up?
  local questionMark = "|TInterface\\Icons\\INV_Misc_QuestionMark:32:32|t";
  local glanceList = { "PE1", "PE2", "PE3", "PE4", "PE5" };
  local holder = {};

  local function helper(title, text, icon, custom)
    local newline = "\n";
    local record = {};
    if     icon and icon ~= "-1" and icon ~= ""
    then   table.insert(record, "|TInterface\\Icons\\" .. icon .. ":32:32|t");
    elseif icon == "-1" and custom and custom ~= ""
    then   table.insert(record, "|TInterface\\Icons\\" .. custom .. ":32:32|t");
    else   table.insert(record, questionMark);
    end;
    table.insert(record, newline);
    table.insert(record, "#");
    table.insert(record, title ~= "" or "...");
    table.insert(record, newline);
    table.insert(record, newline);
    table.insert(record, text ~= "" or "...");
    return table.concat(record);
  end;

  for _, glance in ipairs(glanceList)
  do  
      print("creating glance", glance);
      local title  = self:GetMSP(glance .. "-title");
      print("title is: [" .. (title or "nil") .. "]");
      local text   = self:GetMSP(glance .. "-text");
      print("text is: [" .. (text or "nil") .. "]");
      local icon   = self:GetMSP(glance .. "-icon");
      print("icon is: [" .. (icon or "nil") .. "]");
      local custom = self:GetMSP(glance .. "-icon-custom");
      print("custom is: [" .. (custom or "nil") .. "]");
      if title ~= "" or text ~= "" or icon ~= "" or custom ~= ""
      then table.insert(holder, helper(title, text, icon, custom))
      end;
  end;
  self:SetMSP("PE", table.concat(holder, recordSeparator));
end;

RP_Identity.GeneratePE = generatePE;

-- menu data
--
local menu =
{ FR =
      { ["-1"] = L["Custom Style"],
        ["0" ] = L["Style Undefined"   ],
        ["1" ] = L["Normal"      ],
        ["2" ] = L["Casual"      ],
        ["3" ] = L["Full-Time"   ],
        ["4" ] = L["Beginner"    ],
      },

  FROrder = { "0", "2", "1", "3", "4", "-1" },

  FC =
      { ["-1"] = L["Custom Status"      ],
        ["0" ] = L["Status Undefined"          ],
        ["1" ] = L["Out of Character"   ],
        ["2" ] = L["In Character"       ],
        ["3" ] = L["Looking for Contact"],
        ["4" ] = L["Storyteller"        ],
      },

  FCOrder = { "0", "2", "1", "3", "4", "-1" },

  PN =
      { [ "-1"                    ] = L["Custom Pronouns"   ],
        [ ""                      ] = L["No Pronouns"       ],
        [ L["Pronouns She/Her"  ] ] = L["Pronouns She/Her"  ],
        [ L["Pronouns He/Him"   ] ] = L["Pronouns He/Him"   ],
  },

  PNOrder = 
      { "", 
        L["Pronouns She/Her"], 
        L["Pronouns He/Him"], 
  },

  PX =
      { ["-1"] = L["Custom Honorific"],
        [""  ] = L["No Honorific"    ],
      },

  PXOrder = { "", },

  IC =
      { ["-1"          ] = L["Custom Icon"],
        [""            ] = L["Undefined"  ],
        [maskIconNoPath] = L["rpIdentity Icon"],
      },

  ICOrder = { "", maskIconNoPath },

};

local extraPronouns = L["Pronouns List"];
      extraPronouns = { strsplit("|", extraPronouns) };
for   p, pronoun in ipairs(extraPronouns)
do    menu.PN[pronoun] = pronoun; table.insert(menu.PNOrder, pronoun); 
end;
table.insert(menu.PNOrder, "-1");

local honorifics = L["Honorifics List"];
      honorifics = { strsplit("|", honorifics) };
for   t, title in ipairs(honorifics) 
do    menu.PX[title] = title; table.insert(menu.PXOrder, title); 
end;

table.insert(menu.PXOrder, "-1");
 
-- primarily adapted from totalRP3:
local ICONS = "Interface\\ICONS\\";
local iconDB = 
{ 
  race = {
    
    ["BloodElf"] = { 
      [1] = "achievement_character_bloodelf_female",
      [2] = "achievement_character_bloodelf_male",
      [3] = "achievement_character_bloodelf_female",
    },

    ["DarkIronDwarf"] = { 
      [1] = "ability_racial_foregedinflames",
      [2] = "ability_racial_fireblood",
      [3] = "ability_racial_foregedinflames",
    },

    ["Draenei"] = {
      [1] = "achievement_character_draenei_female",
      [2] = "achievement_character_draenei_male",
      [3] = "achievement_character_draenei_female",
    },

    ["Dwarf"] = {
    [1] = "achievement_character_dwarf_female",
      [2] = "achievement_character_dwarf_male",
      [3] = "achievement_character_dwarf_female",
    },

    ["Gnome"] = {
      [1] = "achievement_character_gnome_female",
      [2] = "achievement_character_gnome_male",
      [3] = "achievement_character_gnome_female",
    },

    ["Goblin"] = {
      [1] = "ability_racial_rocketjump",
      [2] = "ability_racial_rocketjump",
      [3] = "ability_racial_rocketjump",
    },

    ["HighmountainTauren"] = {
      [1] = "achievement_alliedrace_highmountaintauren",
      [2] = "ability_racial_bullrush",
      [3] = "achievement_alliedrace_highmountaintauren",
    },

    ["Human"] = {
      [1] = "achievement_character_human_female",
      [2] = "achievement_character_human_male",
      [3] = "achievement_character_human_female",
    },

    ["KulTiran"] = {
      [1] = "ability_racial_childofthesea",
      [2] = "achievement_boss_zuldazar_manceroy_mestrah",
      [3] = "ability_racial_childofthesea",
    },

    ["LightforgedDraenei"] = {
      [1] = "achievement_alliedrace_lightforgeddraenei",
      [2] = "ability_racial_finalverdict",
      [3] = "achievement_alliedrace_lightforgeddraenei",
    },

    ["MagharOrc"] = {
      [1] = "achievement_character_orc_female_brn",
      [2] = "achievement_character_orc_male_brn",
      [3] = "achievement_character_orc_female_brn",
    },

    ["Mechagnome"] = {
      [1] = "inv_plate_mechagnome_c_01helm",
      [2] = "ability_racial_hyperorganiclightoriginator",
      [3] = "inv_plate_mechagnome_c_01helm",
    },

    ["NightElf"] = {
      [1] = "achievement_character_nightelf_female",
      [2] = "achievement_character_nightelf_male",
      [3] = "achievement_character_nightelf_female",
    },

    ["Nightborne"] = {
      [1] = "ability_racial_masquerade",
      [2] = "ability_racial_dispelillusions",
      [3] = "ability_racial_masquerade",
    },

    ["Orc"] = {
      [1] = "achievement_character_orc_female",
      [2] = "achievement_character_orc_male",
      [3] = "achievement_character_orc_female",
    },

    ["Pandaren"] = {
      [1] = "achievement_character_pandaren_female",
      [2] = "achievement_guild_classypanda",
      [3] = "achievement_character_pandaren_female",
    },

    ["Scourge"] = {
      [1] = "achievement_character_undead_female",
      [2] = "achievement_character_undead_male",
      [3] = "achievement_character_undead_female",
    },

    ["Tauren"] = {
      [1] = "achievement_character_tauren_female",
      [2] = "achievement_character_tauren_male",
      [3] = "achievement_character_tauren_female",
    },

    ["Troll"] = {
      [1] = "achievement_character_troll_female",
      [2] = "achievement_character_troll_male",
      [3] = "achievement_character_troll_female",
    },

    ["VoidElf"] = {
      [1] = "ability_racial_preturnaturalcalm",
      [2] = "ability_racial_entropicembrace",
      [3] = "ability_racial_preturnaturalcalm",
    },

    ["Vulpera"] = {
      [1] = "ability_racial_nosefortrouble",
      [2] = "ability_racial_nosefortrouble",
      [3] = "ability_racial_nosefortrouble",
    },

    ["Worgen"] = {
      [1] = "ability_racial_viciousness",
      [2] = "achievement_worganhead",
      [3] = "ability_racial_viciousness",
    },

    ["ZandalariTroll"] = {
      [1] = "inv_zandalarifemalehead",
      [2] = "inv_zandalarimalehead",
      [3] = "inv_zandalarifemalehead",
    },
    
  }, -- race
  
class =
  { 
    ["WARRIOR"     ] = "ClassIcon_Warrior",
    ["PALADIN"     ] = "ClassIcon_Paladin",
    ["HUNTER"      ] = "ClassIcon_Hunter",
    ["ROGUE"       ] = "ClassIcon_Rogue",
    ["PRIEST"      ] = "ClassIcon_Priest",
    ["DEATHKNIGHT" ] = "ClassIcon_DeathKnight",
    ["SHAMAN"      ] = "ClassIcon_Shaman",
    ["MAGE"        ] = "ClassIcon_Mage",
    ["WARLOCK"     ] = "ClassIcon_Warlock",
    ["MONK"        ] = "ClassIcon_Monk",
    ["DRUID"       ] = "ClassIcon_Druid",
    ["DEMONHUNTER" ] = "ClassIcon_DemonHunter",
  }, -- class
glance = 
  {
    ["-1"                                    ] = L["Custom Icon"],
    [""                                      ] = L["Undefined"  ],
    [maskIconNoPath                          ] = L["rpIdentity Icon"],
    ["Ability_Hunter_BeastCall"              ] = L["Ability_Hunter_BeastCall"              ],
    ["INV_Inscription_ScrollOfWisdom_01"     ] = L["INV_Inscription_ScrollOfWisdom_01"     ],
    ["inv_jewelry_ring_14"                   ] = L["inv_jewelry_ring_14"                   ],
    ["INV_Inscription_inkblack01"            ] = L["INV_Inscription_inkblack01"            ],
    ["vas_namechange"                        ] = L["vas_namechange"                        ],
    ["inv_misc_kingsring1"                   ] = L["inv_misc_kingsring1"                   ],
    ["spell_shadow_mindsteal"                ] = L["spell_shadow_mindsteal"                ],
    ["INV_Misc_QuestionMark"                 ] = L["INV_Misc_QuestionMark"                 ],
    ["Achievement_Character_Human_Female"    ] = L["Achievement_Character_Human_Female"    ],
    ["achievement_halloween_smiley_01"       ] = L["achievement_halloween_smiley_01"       ],
    ["Achievement_Character_Nightelf_Female" ] = L["Achievement_Character_Nightelf_Female" ],
    ["achievement_doublerainbow"             ] = L["achievement_doublerainbow"             ],
    ["trade_archaeology_delicatemusicbox"    ] = L["trade_archaeology_delicatemusicbox"    ],
    ["achievement_worganhead"                ] = L["achievement_worganhead"                ],
    ["Achievement_Character_Human_Male"      ] = L["Achievement_Character_Human_Male"      ],
    ["ability_priest_heavanlyvoice"          ] = L["ability_priest_heavanlyvoice"          ],
    ["ui_rankedpvp_02_small"                 ] = L["ui_rankedpvp_02_small"                 ],
    ["Ability_Warrior_StrengthOfArms"        ] = L["Ability_Warrior_StrengthOfArms"        ],
    ["ui_rankedpvp_03_small"                 ] = L["ui_rankedpvp_03_small"                 ],
    ["achievement_character_human_female"    ] = L["achievement_character_human_female"    ],
    ["Ability_Racial_PreturnaturalCalm"      ] = L["Ability_Racial_PreturnaturalCalm"      ],
    ["ability_bossashvane_icon02"            ] = L["ability_bossashvane_icon02"            ],
    ["ui_rankedpvp_04_small"                 ] = L["ui_rankedpvp_04_small"                 ],
    ["petbattle_health"                      ] = L["petbattle_health"                      ],
    ["achievement_character_bloodelf_female" ] = L["achievement_character_bloodelf_female" ],
    
  },
};

-- iconDB
--
local localizedRace,  playerRace  = UnitRace("player");
local localizedClass, playerClass = UnitClass("player");

local raceIcons = iconDB.race[playerRace];
local classIcon = iconDB.class[playerClass];

menu.IC[raceIcons[1]] = localizedRace .. L["Gender (Neutral)"];
table.insert(menu.ICOrder, raceIcons[1]);

if   raceIcons[3] ~= raceIcons[1]
then menu.IC[raceIcons[3]] = localizedRace .. L["Gender (Female)"];
     table.insert(menu.ICOrder, raceIcons[3]);
end;

if   raceIcons[2] ~= raceIcons[1]
then menu.IC[raceIcons[2]] = localizedRace .. L["Gender (Male)"];
     table.insert(menu.ICOrder, raceIcons[2]);
end;

menu.IC[classIcon] = localizedClass;
table.insert(menu.ICOrder, classIcon);
table.insert(menu.ICOrder, "-1");

for i = 1, 5 do menu["PE" .. i .. "-icon"] = iconDB.glance; end;

--     
-- editor
--
--
local Editor = AceGUI:Create("Window");

Editor:SetWidth( 600);
Editor:SetHeight(400);
Editor.frame:SetMinResize(395, 320);
local maxW, maxH = UIParent:GetSize();
Editor.frame:SetMaxResize( maxW * 2/3, maxH * 3/4);
Editor.content:ClearAllPoints();
Editor.content:SetPoint("BOTTOMLEFT", Editor.frame, "BOTTOMLEFT",  20,  50);
Editor.content:SetPoint("TOPRIGHT",   Editor.frame, "TOPRIGHT",   -20, -40);
Editor:SetTitle(RP_Identity.addOnTitle)
Editor.frame:SetClampedToScreen(true);
Editor:SetLayout("Flow");
Editor:Hide();
Editor.pending = {};

local EditorFrameName = "RP_Identity_Editor_Frame";
_G[EditorFrameName]   = Editor.frame;
tinsert(UISpecialFrames, EditorFrameName);
RP_Identity.Editor = Editor;

function RP_Identity:EditIdentity() self.Editor:ReloadTab(); self.Editor:Show(); end;

-- popups
--
local POPUP_CLEAR = "RP_IDENTITY_CLEAR_AND_PRESENT_DANGER";

StaticPopupDialogs[POPUP_CLEAR] =
{ button1      = YES,
  button2      = NO,
  hideOnEscape = 1,
  timeout      = 60,
  whileDead    = 1,
  text         = L[POPUP_CLEAR];
  OnShow       = function(self) self:SetFrameStrata("FULLSCREEN_DIALOG"); end,
  OnClose      = function(self) self:SetFrameStrata("DIALOG"); end,
  OnAccept     = function(self) RP_Identity:ResetIdentity(); end,
};

-- editor config 
--
local groupOrder = { "basics", "appearance", "glance", "bio", "status"};

Editor.groups =
{ 
  basics = 
      { fields = { "name", "title", 
                   "race", "class", 
                   "honorific", "pronouns", 
                   "nickname", "house",
                   "icon",
                   "motto",
                 },

        title  = L["Group Basics"],
      },

  status =
      { fields = { "rpStyle", "rpStatus", "currently", "oocInfo" },
        title  = L["Group Status"],
      },

  appearance =
      { fields = { "eyes", 
                   "height", "weight", 
                   "desc", },
        title  = L["Group Appearance"],
      },

  bio =
      { fields = { "age", "birthPlace", "home", "history" },
        title  = L["Group Bio"],
      },

  glance =
      { -- fields = { "glance1", "glance2", "glance3", "glance4", "glance5" },
        fields = { "glances" },
        title = L["Group Glance"],
      },
};

-- initialization
--
local tabList = {};
for _, groupName in ipairs(groupOrder)
do  local groupData = Editor.groups[groupName];
    table.insert(tabList, { value = groupName, text = groupData.title });
end;

-- pending changes

function Editor:GetMSP(msp) 
  return self.pending[msp] 
     and self.pending[msp] 
      or RP_Identity:GetMSP(msp); 
end; 
function Editor:SetMSP(msp, value) 
      if RP_Identity.db.profile.config.autoSave
      then RP_Identity:SetMSP(msp, value);
      else self.pending[msp] = value; 
           self:SetTitle(RP_Identity.addOnTitle .. " - " .. RP_Identity.db:GetCurrentProfile() .. L["(not saved)"]);
      end;
end;

Editor.GeneratePE = generatePE;

function Editor:ClearPending() 
  self.pending = {} 
   self:SetTitle(RP_Identity.addOnTitle .. " - " .. RP_Identity.db:GetCurrentProfile())
end;

function Editor:ApplyPending() 
      for field, value in pairs(self.pending) 
      do RP_Identity:SetMSP(field, value); 
      end;
      self:ClearPending();
      RP_Identity:UpdateIdentity();
end;

local Cursor = {};

local function showTooltip(self, event, msp)
  if not RP_Identity.db.profile.config.editorTooltips then return end;
  if Cursor[msp or self.MSP] then SetCursor(msp or self.MSP) end;
  GameTooltip:ClearLines();
  GameTooltip:SetOwner(self.frame, "ANCHOR_CURSOR");
  GameTooltip:SetOwner(self.frame, "ANCHOR_PRESERVE");
  GameTooltip:AddLine(L["Label " .. (msp or self.MSP)]);
  GameTooltip:AddLine(L["Tooltip " .. (msp or self.MSP)], 1, 1, 1, true);
  GameTooltip:Show();
end;
  
local function hideTooltip(self, event)
  if RP_Identity.db.profile.config.tooltipsFadeOut then GameTooltip:FadeOut()
  else GameTooltip:Hide(); end;
  ResetCursor();
end;

local function fixEditBox(widget)
  local sides = { "Left", "Right", "Middle" };
  local function hide() 
    hideTooltip()
    if widget.editbox:HasFocus() then return end;
    for _, side in ipairs(sides) 
    do widget.editbox[side]:SetVertexColor(1, 1, 1, 0); 
    end; 
  end;
  local function show() 
    for _, side in ipairs(sides) 
    do widget.editbox[side]:SetVertexColor(unpack(RP_Identity.addOnColor)) 
    end;  
  end;
  local function hover() 
    showTooltip(widget, "OnEnter", widget.tooltipMSP or widget.MSP);
    if widget.editbox:HasFocus() then return end;
    for _, side in ipairs(sides) 
    do widget.editbox[side]:SetVertexColor(1, 1, 0, 1); 
    end 
  end;
  hide();
  widget.editbox:SetScript("OnEditFocusGained", show)
  widget.editbox:SetScript("OnEditFocusLost", hide)
  widget:SetCallback("OnEnter", hover);
  widget:SetCallback("OnLeave", hide);
end;
    
local function makeInstruct(text)
  local widget = AceGUI:Create("Label");
  widget:SetText(text);
  widget:SetColor(1, 1, 1, 1);
  widget:SetFullWidth(true);
  return { widget };
end;

local function makeLabel(msp, width)
      local w = AceGUI:Create("Label");
      w.MSP = msp;
      w:SetText(L["Label " .. msp] .. "   ");
      w:SetColor(1, 1, 0, 1);
      w:SetRelativeWidth(width)
      return w;
end;

local function makeEditBox(msp, width, labelWidth)
      local label = makeLabel(msp, labelWidth);
      local main = AceGUI:Create("EditBox");
      fixEditBox(main);
      main:SetRelativeWidth(width);
      main.MSP = msp;
      main:SetText(Editor:GetMSP(msp));
      main:SetCallback("OnEnterPressed", function(self, event, text) Editor:SetMSP(self.MSP, text); end);
      return { label, main };
end;

local function makeDropdown(msp, width, labelW, customW)
      local label = makeLabel(msp, labelW > 0 and labelW or 0.1);

      local custom = AceGUI:Create("EditBox");
      fixEditBox(custom);

      custom:SetRelativeWidth(customW > 0 and customW or 0.1)
      custom.MSP = msp;
      custom.tooltipMSP = msp .. "-custom";
      custom:SetCallback("OnEnterPressed", 
        function(self, event, text) 
          Editor:SetMSP(self.MSP, text) 
        end);
      
      local main = AceGUI:Create("Dropdown");
      main:SetRelativeWidth(width > 0 and width or 0.1);
      main.MSP = msp;
      main:SetCallback("OnEnter", showTooltip);
      main:SetCallback("OnLeave", hideTooltip);

      main.custom = custom;

      local myMenu = menu[msp];
      local initialValue = Editor:GetMSP(msp);

      if   myMenu[initialValue]
      then main:SetValue(initialValue);
           main:SetText(myMenu[initialValue]);
           custom:SetDisabled(true); 
      else main:SetValue("-1"); 
           main:SetText(myMenu["-1"]);
           custom:SetDisabled(false); 
           custom:SetText(initialValue);
      end;

      main:SetList(myMenu, menu[msp .. "Order"]);

      main:SetCallback("OnValueChanged", 
                  function(self, event, key)
                           if key == "-1"
                           then custom:SetDisabled(false);
                                custom:SetFocus();
                                Editor:SetMSP(self.MSP, custom:GetText())
                           else custom:SetDisabled(true);
                                Editor:SetMSP(self.MSP, key);
                           end;
                  end);
      local widgets = {}
      if labelW  > 0 then table.insert(widgets, label) end;
      if width   > 0 then table.insert(widgets, main) end;
      if customW > 0 then table.insert(widgets, custom) end;
      return widgets;
end;

local function makeMultiLine(msp, lines, width)
      local main = AceGUI:Create("MultiLineEditBox");
      main:SetLabel(L["Label " .. msp]);
      main:SetNumLines(lines or 3);
      if not width then main:SetFullWidth(true); else main:SetRelativeWidth(width) end;
      main.MSP = msp;
      main:SetCallback("OnEnter", showTooltip);
      main:SetCallback("OnLeave", hideTooltip);
      main:SetText( Editor:GetMSP(msp) );
      main:SetCallback("OnEnterPressed", function(self, event, text) Editor:SetMSP(self.MSP, text); end);
      return { main };
end;

local function makeIcon(msp, iconSize, iconWidth, dropdownWidth, customWidth)
  local icon = AceGUI:Create("Icon");
  icon.MSP = msp;
  icon.tooltipMSP = msp .. "-icon";
  icon:SetImageSize(iconSize, iconSize);
  icon:SetRelativeWidth(iconWidth);

  function icon.SetIcon(self, iconFile) 
    if not iconFile or iconFile == ""
    then self:SetImage();
    else self:SetImage("Interface\\ICONS\\" .. iconFile); 
    end;
  end;
  icon:SetIcon(Editor:GetMSP(msp));

  local dropdown, custom = unpack(makeDropdown(msp, dropdownWidth, 0, customWidth));

  custom:SetCallback("OnEnterPressed",
    function(self, event, text)
      Editor:SetMSP(self.MSP, text) 
      icon:SetIcon(text)
    end);
  dropdown:SetCallback("OnValueChanged",
    function(self, event, key)
      if key == "-1"
      then custom:SetDisabled(false);
           custom:SetFocus();
           icon:SetIcon(custom:GetText());
           Editor:SetMSP(self.MSP, key);
      else custom:SetDisabled(true);
           Editor:SetMSP(self.MSP, key);
           icon:SetIcon(key);
      end;
    end);
  return { icon, dropdown, custom };
end;

local function makeColorfulEditBox(msp, width, labelWidth)
      local ADD_FMT = "|cff%02x%02x%02x%s|r";
      local EXTRACT_FMT = "^|cff(%x%x)(%x%x)(%x%x)(.+)|r$";

      local function addColor(r, g, b, name) 
        if r then return string.format(ADD_FMT, r * 255, g * 255, b  * 255, name) 
        else return name;
        end;
      end;

      local function extractColor(str)
            local r, g, b, name = str:match(EXTRACT_FMT)
            return r and tonumber(r, 16) / 255 or nil, 
                                 g and tonumber(g, 16) / 255 or nil, 
                                 b and tonumber(b, 16) / 255 or nil,
                                 name or str
      end;

      local label = makeLabel(msp, labelWidth);

      local main = AceGUI:Create("EditBox");
      fixEditBox(main);
      main:SetRelativeWidth(width); 
      main.MSP = msp;
      main:SetCallback("OnEnter", showTooltip);
      main:SetCallback("OnLeave", hideTooltip);

      local picker = AceGUI:Create("ColorPicker");
      picker.MSP = msp;
      picker:SetHasAlpha(false);
      picker:SetRelativeWidth(0.1);
      picker.main = main;
      picker.tooltipMSP = "Color";
      picker:SetCallback("OnEnter", showTooltip);
      picker:SetCallback("OnLeave", hideTooltip);

      picker:SetCallback("OnValueConfirmed",
            function(self, event, r, g, b, a)
                  Editor:SetMSP(self.MSP, addColor(r, g, b, self.main:GetText() ));
                  self.r, self.g, self.b = r, g, b;
            end);
                  
      main.picker = picker;

      local initialValue = Editor:GetMSP(msp);
      local r, g, b, name = extractColor(initialValue);
      r, g, b = r or 1, g or 1, b or 1;
      picker:SetColor(r, g, b, 1);
      picker.r, picker.g, picker.b = r, g, b;
      main:SetText(name);

      main:SetCallback("OnEnterPressed",
            function(self, event, text)
                  Editor:SetMSP(self.MSP, addColor(self.picker.r, self.picker.g, self.picker.b, text));
            end);

      return { label, main, picker };
end;


local function makeGlances()
  local widgets = {};
  local preview = {};
  local groupOrder = { "PE1", "PE2", "PE3", "PE4", "PE5" };
  local glancesGroup = AceGUI:Create("SimpleGroup");

  local function createPreviewIcon(msp)
    local frameGlow = "Interface\\Buttons\\ButtonHilight-SquareQuickslot";
    local bigNumbers = "Interface\\Timer\\BigTimerNumbers";
    local glowNumbers = "Interface\\Timer\\BigTimerNumbersGlow";
    local numberCoords = 
    { PE1 = { L = 1/4, R = 2/4, T = 0/3, B = 1/3 },
      PE2 = { L = 2/4, R = 3/4, T = 0/3, B = 1/3 },
      PE3 = { L = 3/4, R = 4/4, T = 0/3, B = 1/3 },
      PE4 = { L = 0/4, R = 1/4, T = 1/3, B = 2/3 },
      PE5 = { L = 1/4, R = 2/4, T = 1/3, B = 2/3 },
    }
    local icon = AceGUI:Create("IconNoHighlight")

    local r, g, b, a = unpack(RP_Identity.addOnColor);

    icon.MSP        = msp;
    icon.tooltipMSP = msp .. "-icon";
    icon:SetRelativeWidth(0.19);
    icon:SetImageSize(64, 64);

    icon.buttonglow = icon:CreateTexture(nil, "HIGHLIGHT");
    icon.buttonglow:SetSize(69, 69);
    icon.buttonglow:SetPoint("TOP", -2, -5);
    icon.buttonglow:SetTexture(frameGlow);
    icon.buttonglow:SetBlendMode("ADD")
    icon.buttonglow:SetDesaturated(true);

    local edge = numberCoords[msp];
    icon.numberglow = icon:CreateTexture(nil, "HIGHLIGHT");
    icon.numberglow:SetSize(64, 64);
    icon.numberglow:SetPoint("TOP", 0, -5);
    icon.numberglow:SetTexture(glowNumbers);
    icon.numberglow:SetTexCoord(edge.L, edge.R, edge.T, edge.B);
    icon.numberglow:SetVertexColor(r, g, b, 0.5);
    icon.numberglow:SetBlendMode("BLEND")

    for _, highlight in ipairs({ icon.numberglow, icon.buttonglow })
    do function highlight:MakeVisible()   self:SetVertexColor(r, g, b, 0.5) end;
       function highlight:MakeInvisible() self:SetVertexColor(r, g, b, 0) end;
       function highlight:MakeBright()    self:SetVertexColor(r, g, b, 1) end;
    end;

    function icon:SetIcon(useThisIcon)
      local iconFile   = useThisIcon or Editor:GetMSP(self.MSP .. "-icon");
      local customIcon = Editor:GetMSP(self.MSP .. "-icon-custom");
      if     iconFile == "-1" and customIcon ~= ""
      then   self:SetImage("Interface\\ICONS\\" .. customIcon)
             self.highlight = self.buttonglow;
      elseif iconFile ~= ""
      then   self:SetImage("Interface\\ICONS\\" .. iconFile);
             self.highlight = self.buttonglow;
      else   self:SetImage(bigNumbers, edge.L, edge.R, edge.T, edge.B);
             self.image:SetDesaturated(true);
             self.image:SetVertexColor(r, g, b, 0.5);
             self.highlight = self.numberglow;
      end;
      self.numberglow:MakeInvisible();
      self.buttonglow:MakeInvisible();
      if glancesGroup.current == self.MSP
      then self.highlight:MakeBright();
      else self.highlight:MakeVisible();
      end;
    end;

    local function icon_OnClick(self, event)
      glancesGroup:SelectGlance(self.MSP) 
    end;
    icon:SetCallback("OnClick", icon_OnClick);
    icon:SetIcon();
    table.insert(widgets, icon);
    preview[msp] = icon;

  end;

  function glancesGroup:SelectGlance(msp)
    local items;
    glancesGroup.current = msp;
    for iconMSP, icon in pairs(preview)
    do if iconMSP == msp 
       then icon:LockHighlight() 
            icon.highlight:MakeBright();
       else icon:UnlockHighlight(); 
            icon.highlight:MakeVisible();
       end;
    end;
    self:ReleaseChildren();

    local heading = AceGUI:Create("Heading");
    heading:SetFullWidth(true);
    heading:SetText(L["Label " .. msp]);
    self:AddChild(heading);

    items = makeEditBox(msp .. "-title", 0.85, 0.15);
    for _, item in ipairs(items) do self:AddChild(item); end;

    local left = AceGUI:Create("SimpleGroup");
    local middle = AceGUI:Create("Label");
    local right = AceGUI:Create("SimpleGroup");
    left:SetRelativeWidth(0.45);
    middle:SetRelativeWidth(0.05);
    right:SetRelativeWidth(0.45);
    self:AddChild(left);
    self:AddChild(middle);
    self:AddChild(right);
    
    local function custom_OnEnterPressed(self, event, text)
      Editor:SetMSP(self.MSP, text) 
      Editor:GeneratePE();
      self.icon:SetIcon()
    end;

    local function dropdown_OnValueChanged(self, event, key)
      Editor:SetMSP(self.MSP, key);
      Editor:GeneratePE();
      if key == "-1"
      then self.custom:SetDisabled(false);
           self.custom:SetFocus();
           local customValue = self.custom:GetText();
           if not customValue or customValue == ""
           then self.custom:SetText("INV_Misc_QuestionMark");
           end;
           self.icon:SetIcon(self.custom:GetText());
      else self.custom:SetDisabled(true);
           self.icon:SetIcon();
      end;
    end;

    local dropdown, custom = unpack(makeDropdown(msp .. "-icon", 0.95, 0.00, 0.95));

    custom:SetCallback("OnEnterPressed", custom_OnEnterPressed);
    custom.icon = preview[msp];

    dropdown:SetCallback("OnValueChanged", dropdown_OnValueChanged);
    dropdown.custom = custom;
    dropdown.icon    = preview[msp];

    left:AddChild(dropdown);
    left:AddChild(custom);

    items = makeMultiLine(msp .. "-text", 3);
    for _, item in ipairs(items) do right:AddChild(item); end;

  end;

  for _, msp in ipairs(groupOrder) do createPreviewIcon(msp) end;

  glancesGroup:SetFullWidth(true);
  glancesGroup:SetFullHeight(true);
  glancesGroup:SetLayout("Flow");

  table.insert(widgets, glancesGroup);

  glancesGroup:SelectGlance("PE1");

  return widgets;
end;

local frameConstructor = 
{ 
      --  makeEditBox(msp, width, labelWidth)
      --  makeDropdown(msp, width, labelW, customW)
      --  makeColorfulEditBox(msp, width, labelWidth)
      --  makeMultiLine(msp, lines)
      --  makeIcon(msp, iconSize, iconWidth, dropdownWidth, customWidth)
      --  makeInstruct(text)

      instructBasics = function() return makeInstruct(L["Instruct Basics"]) end,
      name       = function() return makeColorfulEditBox("NA", 0.75, 0.15     ) end,
      race       = function() return makeEditBox("RA", 0.85, 0.15            ) end,
      class      = function() return makeEditBox("RC", 0.85, 0.15            ) end,
      title      = function() return makeEditBox("NT", 0.85, 0.15            ) end,
      house      = function() return makeEditBox("NH", 0.35, 0.15             ) end,
      nickname   = function() return makeEditBox("NI", 0.35, 0.15             ) end,
      pronouns   = function() return makeDropdown("PN", 0.25, 0, 0.25       ) end,
      honorific  = function() return makeDropdown("PX", 0.25, 0, 0.20       ) end,
      motto      = function() return makeEditBox("MO", 0.85, 0.15             ) end,
      icon        = function() return makeIcon("IC", 50, 0.15, 0.30, 0.50    ) end, 

      instructStatus = function() return makeInstruct(L["Instruct Status"]) end,
      rpStatus   = function() return makeDropdown("FC", 0.25, 0, 0.25       ) end,
      rpStyle    = function() return makeDropdown("FR", 0.25, 0, 0.25       ) end,
      currently  = function() return makeMultiLine("CU", 12, 0.5             ) end,
      oocInfo    = function() return makeMultiLine("CO", 12, 0.5             ) end,

      instructAppearance = function() return makeInstruct(L["Instruct Appearance"]) end,
      eyes       = function() return makeColorfulEditBox("AE", 0.75, 0.15     ) end,
      height     = function() return makeEditBox("AH", 0.85, 0.15             ) end,
      weight     = function() return makeEditBox("AW", 0.85, 0.15            ) end,
      desc       = function() return makeMultiLine("DE", 12                 ) end,

      instructBio = function() return makeInstruct(L["Instruct Bio"]) end,
      age        = function() return makeEditBox("AG", 0.85, 0.15             ) end,
      birthPlace = function() return makeEditBox("HB", 0.85, 0.15            ) end,
      home       = function() return makeEditBox("HH", 0.85, 0.15             ) end,
      history    = function() return makeMultiLine("HI", 12                  ) end,

      instructGlance = function() return makeInstruct(L["Instruct Glance"]) end,
      glances = function() return makeGlances() end,
};

Editor.tabGroup = AceGUI:Create("TabGroup");
Editor.tabGroup:SetFullWidth(true);
Editor.tabGroup:SetFullHeight(true);
Editor.tabGroup:SetLayout("Flow");
Editor.tabGroup:SetTabs(tabList);
Editor.tabGroup.Editor = Editor;
Editor:AddChild(Editor.tabGroup);

function Editor.tabGroup:LoadTab(tab)
  self:ReleaseChildren();

  self.scrollContainer = AceGUI:Create("SimpleGroup");
  self.scrollContainer:SetFullWidth(true);
  self.scrollContainer:SetFullHeight(true);
  self.scrollContainer:SetLayout("Fill");

  self:AddChild(self.scrollContainer);

  self.scrollFrame = AceGUI:Create("ScrollFrame");
  self.scrollFrame:SetLayout("Flow");

  self.scrollContainer:AddChild(self.scrollFrame);

  local groupData = self.Editor.groups[tab];
  for _, fieldName in ipairs(groupData.fields)
  do  local constructor = frameConstructor[fieldName];
      for _, widget in ipairs(constructor())
      do  self.scrollFrame:AddChild(widget);
      end;
  end;

  self.Editor.currentGroup = tab;
end;

Editor.tabGroup:SetCallback("OnGroupSelected",
    function(self, event, group)
       self.Editor:ApplyPending();
       self:LoadTab(group);
    end);

function Editor:ReloadTab()
  self.tabGroup:LoadTab(self.currentGroup or groupOrder[1]);
  self:SetTitle(RP_Identity.addOnTitle .. " - " .. RP_Identity.db:GetCurrentProfile() );
end;

function RP_Identity:OpenOptions()
    InterfaceOptionsFrame:Show();
    InterfaceOptionsFrame_OpenToCategory(self.addOnTitle)
    self.Editor:Hide();
end;
-- editor buttons
--
local buttonSize = 85;

RP_Identity.resetButton  = CreateFrame("Button", nil, Editor.frame, "UIPanelButtonTemplate");
RP_Identity.resetButton:SetText(L["Button Clear"]);
RP_Identity.resetButton:ClearAllPoints();
RP_Identity.resetButton:SetPoint("BOTTOMRIGHT", Editor.frame, "BOTTOMRIGHT", -20 - buttonSize * 1 - 5 * 1, 20);
RP_Identity.resetButton:SetWidth(buttonSize);
RP_Identity.resetButton:SetScript("OnClick", function(self) StaticPopup_Show(POPUP_CLEAR); end);

RP_Identity.cancelButton  = CreateFrame("Button", nil, Editor.frame, "UIPanelButtonTemplate");
RP_Identity.cancelButton:SetText( L["Button Cancel"]);
RP_Identity.cancelButton:ClearAllPoints();
RP_Identity.cancelButton:SetPoint("BOTTOMRIGHT", Editor.frame, "BOTTOMRIGHT",  -20, 20);
RP_Identity.cancelButton:SetWidth(buttonSize);
RP_Identity.cancelButton:SetScript("OnClick", function(self) Editor:ClearPending(); Editor:Hide() end);

RP_Identity.saveButton  = CreateFrame("Button", nil, Editor.frame, "UIPanelButtonTemplate");
RP_Identity.saveButton:SetText(L["Button Save"]);
RP_Identity.saveButton:ClearAllPoints();
RP_Identity.saveButton:SetPoint("BOTTOMRIGHT", Editor.frame, "BOTTOMRIGHT", -20 - buttonSize * 2 - 5 * 2, 20);
RP_Identity.saveButton:SetWidth(buttonSize);
RP_Identity.saveButton:SetScript("OnClick", function(self) Editor:ApplyPending(); Editor:Hide(); end);

RP_Identity.closeButton  = CreateFrame("Button", nil, Editor.frame, "UIPanelButtonTemplate");
RP_Identity.closeButton:SetText(L["Button Close"]);
RP_Identity.closeButton:ClearAllPoints();
RP_Identity.closeButton:SetPoint("BOTTOMRIGHT", Editor.frame, "BOTTOMRIGHT", -20, 20);
RP_Identity.closeButton:SetWidth(buttonSize);
RP_Identity.closeButton:SetScript("OnClick", function(self) Editor:Hide(); end);
RP_Identity.closeButton:Hide();

RP_Identity.configButton = CreateFrame("Button", nil, Editor.frame, "UIPanelButtonTemplate");
RP_Identity.configButton:SetText(L["Button Config"]);
RP_Identity.configButton:ClearAllPoints();
RP_Identity.configButton:SetPoint("BOTTOMLEFT", Editor.frame, "BOTTOMLEFT", 20, 20);
RP_Identity.configButton:SetWidth(buttonSize);
RP_Identity.configButton:SetScript("OnClick", function() Editor:ApplyPending(); RP_Identity:OpenOptions() end);
RP_Identity.configButton:SetScript("OnShow",
  function()
    local autoSave = RP_Identity.db.profile.config.autoSave;
    RP_Identity.cancelButton:SetShown(not autoSave);
    RP_Identity.saveButton:SetShown(not autoSave);
    RP_Identity.closeButton:SetShown(autoSave);
  end);

local editorTooltipsCheckbox = CreateFrame("Checkbutton", nil, Editor.frame, "ChatConfigCheckButtonTemplate");
editorTooltipsCheckbox:ClearAllPoints();
editorTooltipsCheckbox:SetSize(20,20);
editorTooltipsCheckbox:SetPoint("TOPRIGHT", Editor.frame, "TOPRIGHT", -72, -28);

local function editorTooltipsTooltip()
  if not RP_Identity.db.profile.config.editorTooltips then return end;
  GameTooltip:ClearLines();
  GameTooltip:SetOwner(editorTooltipsCheckbox, "ANCHOR_TOP");
  GameTooltip:AddLine(L["Config Editor Tooltips"]);
  GameTooltip:AddLine(L["Config Editor Tooltips Tooltip"], 1, 1, 1, true);
  GameTooltip:Show();
end;

editorTooltipsCheckbox:SetScript("OnEnter", editorTooltipsTooltip);
editorTooltipsCheckbox:SetScript("OnLeave", hideTooltip);
editorTooltipsCheckbox:SetScript("OnShow", 
  function(self)
    self:SetChecked(RP_Identity.db.profile.config.editorTooltips);
  end);
editorTooltipsCheckbox:SetScript("OnClick",
  function(self)
    RP_Identity.db.profile.config.editorTooltips = self:GetChecked();
    self:SetChecked(RP_Identity.db.profile.config.editorTooltips);
  end);

local editorTooltipsLabel = Editor.frame:CreateFontString(nil, "OVERLAY", "GameFontNormalGraySmall");
editorTooltipsLabel:SetText(L["Label Editor Tooltips"]);
editorTooltipsLabel:SetPoint("LEFT", editorTooltipsCheckbox, "RIGHT", 2, 0);

local SLASH = "/rpid";
_G["SLASH_RP_IDENTITY1"] = SLASH;

function RP_Identity:HelpCommand()
  notify(L["Slash Commands"]);
  notify(L["Slash Options"]);
  notify(L["Slash Open"]);
  notify(L["Slash Toggle Editor"]);
  notify(L["Slash IC"]);
  notify(L["Slash OOC"]);
  notify(L["Slash Toggle Status"]);
  notify(L["Slash Status"]);
  notify(L["Slash Currently"]);
  notify(L["Slash Info"]);
end;

function RP_Identity:SetStatus(value)
  self.db.profile.myMSP.FC = value;
  self:UpdateIdentity();
  self:NotifyStatus()
end;

function RP_Identity:ToggleStatus(value)
  if self.db.profile.myMSP.FC == "1"
  then self:SetStatus("2");
  elseif self.db.profile.myMSP.FC == "2"
  then self:SetStatus("1")
  else self:NotifyStatus();
  end;
end;

function RP_Identity:NotifyStatus()
  local status = self.db.profile.myMSP.FC;
  notify(L["Your Current Status Is"], menu.FC[status] or status);
end;

function RP_Identity:NotifyCurrently() notify(L["Your Currently Is"], self.db.profile.myMSP.CU); end;

function RP_Identity:NotifyInfo() notify(L["Your OOC Info Is"], self.db.profile.myMSP.CO); end;

function RP_Identity:SetCurrently(value)
  self.db.profile.myMSP.CU = value;
  self:UpdateIdentity();
  self:NotifyCurrently();
end;

function RP_Identity:SetInfo(value)
  self.db.profile.myMSP.CO = value;
  self:UpdateIdentity();
  self:NotifyInfo();
end;

SlashCmdList["RP_IDENTITY"] = 
  function(a)
    local  param = { strsplit(" ", a); };
    local  cmd = table.remove(param, 1);
    if     cmd == "" or cmd == "help"
    then   RP_Identity:HelpCommand();
    elseif cmd:match("^option") or cmd:match("^config")
    then   RP_Identity:OpenOptions();
    elseif cmd == "toggle" and param[1] == "status"
    then   RP_Identity:ToggleStatus();
    elseif cmd == "toggle" 
    then   RP_Identity:ToggleEditorFrame();
    elseif cmd == "open"
    then   RP_Identity.Editor:ReloadTab();
           RP_Identity.Editor.frame:Show();
    elseif cmd == "status" and param[1] == "ooc"
    then   RP_Identity:SetStatus("1");
    elseif cmd == "status" and param[1] == "ic"
    then   RP_Identity:SetStatus("2");
    elseif cmd == "status" and not param[1]
    then   RP_Identity:NotifyStatus();
    elseif cmd == "status"
    then   RP_Identity:SetStatus(table.concat(param, " "))
    elseif cmd:match("^curr") and not param[1]
    then   RP_Identity:NotifyCurrently()
    elseif cmd:match("^curr")
    then   RP_Identity:SetCurrently(table.concat(param, " "));
    elseif cmd:match("^info") and not param[1]
    then   RP_Identity:NotifyInfo()
    elseif cmd:match("^info")
    then   RP_Identity:SetInfo(table.concat(param, " "));
    end;
  end;
