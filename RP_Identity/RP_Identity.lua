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

local RP_Identity = LibStub("AceAddon-3.0"):NewAddon( 
        addOnName, 
        "AceConsole-3.0", 
        "AceEvent-3.0"
        -- , "AceTimer-3.0"
      );

local maskIcon = "Interface\\ICONS\\Ability_Racial_Masquerade.PNG";
local maskIconNoPath = "Ability_Racial_Masquerade.PNG";

RP_Identity.addOnName    = addOnName;
RP_Identity.addOnTitle   = GetAddOnMetadata(addOnName, "Title");
RP_Identity.addOnVersion = GetAddOnMetadata(addOnName, "Version");
RP_Identity.addOnIcon    = maskIcon;
RP_Identity.addOnColor   = { 51 / 255, 1, 85 / 255, 1 };

local NUM_RACES = 37 + 10;

local function notify(...) print("[" .. RP_Identity.addOnTitle .. "]", ...) end;

local col = {};
function col.gray(text)   return LIGHTGRAY_FONT_COLOR:WrapTextInColorCode(text) end;
function col.orange(text) return LEGENDARY_ORANGE_COLOR:WrapTextInColorCode(text)    end;
function col.white(text)  return WHITE_FONT_COLOR:WrapTextInColorCode(text) end;

local ORANGE = LEGENDARY_ORANGE_COLOR:GenerateHexColor();
local WHITE  = WHITE_FONT_COLOR:GenerateHexColor();

local forwardArrow = "|A:common-icon-forwardarrow:0|a";
local sortingMenu

local function sortMenu(a, b)
  local colorA, textA = sortingMenu[a]:match("^|c(ff%x%x%x%x%x%x)(.+)|r$")
  local colorB, textB = sortingMenu[b]:match("^|c(ff%x%x%x%x%x%x)(.+)|r$")

  if     colorA and not colorB then return true
  elseif colorB and not colorA then return false
  elseif not colorA and not colorB then return sortingMenu[a] < sortingMenu[b]
  elseif colorA == colorB then return textA < textB
  elseif colorA == ORANGE then return true
  elseif colorB == ORANGE then return false
  elseif colorA == WHITE then return true
  elseif colorB == WHITE then return false
  else return textA < textB
  end;
end;

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
    { showIcon             = true,
      lockFrame            = false,
      saveDimensions       = false,
      notifyProfile        = false,
      autoRequest          = true,
      mouseoverRequest     = true,
      hearSomeone          = false,
      partyRequest         = true,
      raidRequest          = false,
      targetRequest        = true,
      focusRequest         = true,
      editorTooltips       = true,
      autoSave             = false,
      tooltipsFadeOut      = true,
    },
    myMSP =
    { -- GC                = UnitClass("player"),
      -- GF                = UnitFactionGroup("player") .. "",
      -- GR                = UnitRace("player"),
      -- GS                = UnitSex("player") .. "",
      -- GU                = UnitGUID("player"),
      -- TR                = IsTrialAccount() and "1" or "0",
      -- VP                = "1",
      AE                   = "",
      AG                   = "",
      AH                   = "",
      AW                   = "",
      CO                   = "",
      CU                   = "",
      DE                   = "",
      FC                   = "0",
      FR                   = "0",
      HB                   = "",
      HI                   = "",
      HO                   = "",
      IC                   = maskIconNoPath,
      MO                   = "",
      NA                   = UnitName("player"),
      NH                   = "",
      NI                   = "",
      NT                   = "",
      PN                   = "",
      PX                   = "",
      RA                   = UnitRace("player"),
      RC                   = UnitClass("player"),
      VA                   = RP_Identity.addOnTitle .. "/" .. RP_Identity.addOnVersion,
      ["PE1-icon"        ] = "",
      ["PE1-icon-custom" ] = "",
      ["PE1-text"        ] = "",
      ["PE1-title"       ] = "",
      ["PE2-icon"        ] = "",
      ["PE2-icon-custom" ] = "",
      ["PE2-text"        ] = "",
      ["PE2-title"       ] = "",
      ["PE3-icon"        ] = "",
      ["PE3-icon-custom" ] = "",
      ["PE3-text"        ] = "",
      ["PE3-title"       ] = "",
      ["PE4-icon"        ] = "",
      ["PE4-icon-custom" ] = "",
      ["PE4-text"        ] = "",
      ["PE4-title"       ] = "",
      ["PE5-icon"        ] = "",
      ["PE5-icon-custom" ] = "",
      ["PE5-text"        ] = "",
      ["PE5-title"       ] = "",
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

local me, realm;

function RP_Identity:OnInitialize()
    
  self.db = LibStub("AceDB-3.0"):New("RP_IdentityDB", myDefaults);
    
  function self:UpdateIdentity()
    realm = GetNormalizedRealmName();
    me    = UnitName("player") .. "-" .. realm;
    for  field, value in pairs(self.db.profile.myMSP) 
    do   msp.my[field]             = value; 
         msp.char[me].field[field] = value;
    end;
    if self.Editor:IsShown() then self.Editor:ReloadTab(); end;
       msp:Update();
       self:SendMessage("RP_IDENTITY_UPDATE_IDENTITY");
  end;
    
  self.db.RegisterCallback(self, "OnProfileChanged", "UpdateIdentity");
  self.db.RegisterCallback(self, "OnProfileCopied",  "UpdateIdentity");
  self.db.RegisterCallback(self, "OnProfileReset",   "UpdateIdentity");
  
  self.options               =
  { type                     = "group",
    name                     = RP_Identity.addOnTitle,
    order                    = 1,
    args                     =
    { versionInfo            =
      { type                 = "description",
        name                 = L["Version Info"],
        order                = 1,
      },
      support                =
     { type                  = "group",
       name                  = L["Support Header"],
       order                 = 3,
       args                  =
       { supportHeader       =
         { type              = "description",
           fontSize          = "medium",
           name              = "|cffffff00" .. L["Support Header"] .. "|r",
           order             = 4,
        },
        supportInfo          =
         { type              = "description",
           name              = L["Support Info"],
           order             = 5,
         },
       },
     },
      configOptions          =
      { type                 = "group",
        name                 = L["Config Options"],
        order                = 1,
        args                 =
        { showIcon           =
          { name             = L["Config Show Icon"],
            type             = "toggle",
            order            = 1,
            desc             = L["Config Show Icon Tooltip"],
            get              = function() return self.db.profile.config.showIcon end,
            set              = "ToggleMinimapIcon",
            width            = 1.5,
          },
          notifyProfileSent  =
          { name             = L["Config Notify Profile Sent"],
            type             = "toggle",
            order            = 2,
            desc             = L["Config Notify Profile Sent Tooltip"],
            get              = function() return self.db.profile.config.notifyProfile end,
            set              = function(info, value) self.db.profile.config.notifyProfile = value end,
            width            = 1.5,
          },
          autoRequest        =
          { name             = L["Config Auto-Request Profiles"],
            type             = "toggle",
            order            = 3,
            desc             = L["Config Auto-Request Profiles Tooltip"],
            get              = function() return self.db.profile.config.autoRequest end,
            set              = function(info, value) self.db.profile.config.autoRequest = value end,
            width            = 1.5,
          },
          mouseoverRequest   =
          { name             = L["Config Mouseover Request"],
            type             = "toggle",
            order            = 4,
            desc             = L["Config Mouseover Request Tooltip"],
            get              = function() return self.db.profile.config.mouseoverRequest end,
            set              = function(info, value) self.db.profile.config.mouseoverRequest = value end,
                width        = 1.5,
          },
          hearSomeoneRequest =
          { name             = L["Config Hear Someone Request"],
            type             = "toggle",
            order            = 5,
            desc             = L["Config Hear Someone Request Tooltip"],
            get              = function() return self.db.profile.config.hearSomeone end,
            set              = function(info, value) self.db.profile.config.hearSomeone = value end,
            width            = 1.5,
          },
          targetRequest      =
          { name             = L["Config Target Request"],
            type             = "toggle",
            order            = 6,
            desc             = L["Config Target Request Tooltip"],
            get              = function() return self.db.profile.config.targetRequest end,
            set              = function(info, value) self.db.profile.config.targetRequest = value end,
            width            = 1.5,
          },
          focusRequest       =
          { name             = L["Config Focus Request"],
            type             = "toggle",
            order            = 7,
            desc             = L["Config Focus Request Tooltip"],
            get              = function() return self.db.profile.config.focusRequest end,
            set              = function(info, value) self.db.profile.config.focusRequest = value end,
            width            = 1.5,
          },
          partyRequest       =
          { name             = L["Config Party Request"],
            type             = "toggle",
            order            = 8,
            desc             = L["Config Party Request Tooltip"],
            get              = function() return self.db.profile.config.partyRequest end,
            set              = function(info, value) self.db.profile.config.partyRequest = value end,
            width            = 1.5,
          },
          raidRequest        =
          { name             = L["Config Raid Request"],
            type             = "toggle",
            order            = 9,
            desc             = L["Config Raid Request Tooltip"],
            get              = function() return self.db.profile.config.raidRequest end,
            set              = function(info, value) self.db.profile.config.raidRequest = value end,
            width            = 1.5,
          },
          autoSave           =
          { name             = L["Config Auto Save"],
            type             = "toggle",
            order            = 10,
            desc             = L["Config Auto Save"],
            get              = function() return self.db.profile.config.autoSave end,
            set              = setAutoSave,
          },
          tooltipsFadeOut    =
          { name             = L["Config Tooltips Fade Out"],
            type             = "toggle",
            order            = 11,
            desc             = L["Config Tooltips Fade Out Tooltip"],
            get              = function() return self.db.profile.config.tooltipsFadeOut end,
            set              = function(info, value) self.db.profile.config.tooltipsFadeOut = value end,
          },
        },
      },
      profiles               = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db),
      credits                =
        { type               = "group",
          name               = L["Credits Header"],
          order              = 10,
          args               =
          {
            creditsHeader    =
            { type           = "description",
              name           = "|cffffff00" .. L["Credits Header"] .. "|r",
              order          = 2,
              fontSize       = "medium",
            },
            creditsInfo      =
            { type           = "description",
              name           = L["Credits Info"],
              order          = 3,
            },
         },
       },
    },
  };

  myDBicon:Register(RP_Identity.addOnTitle, myDataBroker, RP_Identity.db.profile.config.ShowIcon);
  self:RegisterChatCommand("rpidicon", "ToggleMinimapIcon");
  LibStub("AceConfig-3.0"):RegisterOptionsTable( self.addOnName, self.options);
  LibStub("AceConfigDialog-3.0"):AddToBlizOptions(self.addOnName, self.addOnTitle, self.options);
  self:SendMessage("RP_IDENTITY_READY");
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
   self.Editor.TabGroup:SelectTab(groupOrder[1]);
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

local function computePE(self)
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
    table.insert(record, title);
    table.insert(record, newline);
    table.insert(record, newline);
    table.insert(record, text);
    table.insert(record, newline);
    return table.concat(record);
  end;

  for _, glance in ipairs(glanceList)
  do  
      local title  = self:GetMSP(glance .. "-title");
      local text   = self:GetMSP(glance .. "-text");
      local icon   = self:GetMSP(glance .. "-icon");
      local custom = self:GetMSP(glance .. "-icon-custom");
      if title ~= "" or text ~= "" or (icon == "-1" and custom ~= "") or (icon ~= "-1" and icon ~= "")
      then table.insert(holder, helper(title, text, icon, custom))
      end;
  end;

  local glancesText = table.concat(holder, recordSeparator);
  return glancesText
end;


-- menu data
--
local menu =
{ FR =
  { ["-1"                   ] = col.orange(L["Custom Style"]),
    ["0"                    ] = L["Style Undefined"   ],
    ["1"                    ] = L["Normal"      ],
    ["2"                    ] = L["Casual"      ],
    ["3"                    ] = L["Full-Time"   ],
    ["4"                    ] = L["Beginner"    ],
  },
  FC =
  { ["-1"                   ] = col.orange(L["Custom Status"      ]),
    ["0"                    ] = L["Status Undefined"          ],
    ["1"                    ] = L["Out of Character"   ],
    ["2"                    ] = L["In Character"       ],
    ["3"                    ] = L["Looking for Contact"],
    ["4"                    ] = L["Storyteller"        ],
  },
  PN =
  { [ "-1"                  ] = col.orange(L["Custom Pronouns"   ]),
    [ ""                    ] = L["No Pronouns"       ],
    [ L["Pronouns She/Her"] ] = L["Pronouns She/Her"  ],
    [ L["Pronouns He/Him"]  ] = L["Pronouns He/Him"   ],
  },
  PX =
  { ["-1"                   ] = col.orange(L["Custom Honorific"]),
    [""                     ] = L["No Honorific"    ],
  },
  IC =
  { ["-1"                   ] = col.orange(L["Custom Icon"]),
    [""                     ] = L["Undefined"  ],
    [maskIconNoPath         ] = L["rpIdentity Icon"],
  },
  ICOrder = { "", maskIconNoPath, "-1"                         },
  PXOrder = { "",                                              },
  PNOrder = { "", L["Pronouns She/Her"], L["Pronouns He/Him"], },
  FCOrder = { "0", "2", "1", "3", "4", "-1"                    },
  FROrder = { "0", "2", "1", "3", "4", "-1"                    },
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
  race = 
  { ["BloodElf"] = { 
      [1] = "inv_misc_tournaments_symbol_bloodelf",
      [2] = "achievement_character_bloodelf_male",
      [3] = "achievement_character_bloodelf_female", },
    ["DarkIronDwarf"] = { 
      [1] = "inv_faction_alliancewarfront_round_darkirondwarf",
      [2] = "ability_racial_fireblood",
      [3] = "ability_racial_foregedinflames", },
    ["Draenei"] = {
      [1] = "inv_misc_tournaments_symbol_draenei",
      [2] = "achievement_character_draenei_male",
      [3] = "achievement_character_draenei_female", }, 
    ["Dwarf"] = {
      [1] = "inv_misc_tournaments_symbol_dwarf",
      [2] = "achievement_character_dwarf_male",
      [3] = "achievement_character_dwarf_female", }, 
    ["Gnome"] = {
      [1] = "inv_misc_tournaments_symbol_gnome",
      [2] = "achievement_character_gnome_male",
      [3] = "achievement_character_gnome_female", }, 
    ["Goblin"] = {
      [1] = "ability_racial_rocketjump",
      [2] = "achievement_goblinhead",
      [3] = "achievement_femalegoblinhead", }, 
    ["HighmountainTauren"] = {
      [1] = "inv_faction_hordewarfront_round_highmountaintauren",
      [2] = "ability_racial_bullrush",
      [3] = "achievement_alliedrace_highmountaintauren", }, 
    ["Human"] = {
      [1] = "inf_misc_tournaments_symbol_human",
      [2] = "achievement_character_human_male",
      [3] = "achievement_character_human_female", }, 
    ["KulTiran"] = {
      [1] = "inv_faction_alliancewarfront_round_proudmooreadmiralty",
      [2] = "achievement_boss_zuldazar_manceroy_mestrah",
      [3] = "ability_racial_childofthesea", }, 
    ["LightforgedDraenei"] = {
      [1] = "inv_faction_alliancewarfront_round_lightforgeddraenei",
      [2] = "ability_racial_finalverdict",
      [3] = "achievement_alliedrace_lightforgeddraenei", }, 
    ["MagharOrc"] = {
      [1] = "inv_faction_hordewarfront_round_magharorc",
      [2] = "achievement_character_orc_male_brn",
      [3] = "achievement_character_orc_female_brn", }, 
    ["Mechagnome"] = {
      [1] = "inv_plate_mechagnome_c_01helm",
      [2] = "ability_racial_hyperorganiclightoriginator",
      [3] = "inv_plate_mechagnome_c_01helm", }, 
    ["NightElf"] = {
      [1] = "inv_misc_tournaments_symbol_nightelf",
      [2] = "achievement_character_nightelf_male",
      [3] = "achievement_character_nightelf_female", }, 
    ["Nightborne"] = {
      [1] = "inv_faction_hordewarfront_round_nightborne",
      [2] = "ability_racial_dispelillusions",
      [3] = "ability_racial_masquerade", }, 
    ["Orc"] = {
      [1] = "inv_misc_tournaments_symbol_orc",
      [2] = "achievement_character_orc_male",
      [3] = "achievement_character_orc_female", }, 
    ["Pandaren"] = {
      [1] = "achievement_character_pandaren_female",
      [2] = "achievement_guild_classypanda",
      [3] = "achievement_character_pandaren_female", }, 
    ["Scourge"] = {
      [1] = "inv_misc_tournaments_symbol_scourge",
      [2] = "achievement_character_undead_male",
      [3] = "achievement_character_undead_female", }, 
    ["Tauren"] = {
      [1] = "inv_misc_tournaments_symbol_tauren",
      [2] = "achievement_character_tauren_male",
      [3] = "achievement_character_tauren_female", }, 
    ["Troll"] = {
      [1] = "inv_misc_tournaments_symbol_troll",
      [2] = "achievement_character_troll_male",
      [3] = "achievement_character_troll_female", }, 
    ["VoidElf"] = {
      [1] = "inv_faction_alliancewarfront_round_voidelf",
      [2] = "ability_racial_entropicembrace",
      [3] = "ability_racial_preturnaturalcalm", }, 
    ["Vulpera"] = {
      [1] = "ability_racial_fireresist",
      [2] = "ability_racial_nosefortrouble",
      [3] = "ability_racial_nosefortrouble", }, 
    ["Worgen"] = {
      [1] = "ability_racial_twoforms",
      [2] = "achievement_worganhead",
      [3] = "ability_racial_viciousness", }, 
    ["ZandalariTroll"] = {
      [1] = "inv_faction_talanjisexpedition_round",
      [2] = "inv_zandalarimalehead",
      [3] = "inv_zandalarifemalehead", }, 
  }, -- race
  
class =
  { ["WARRIOR"     ] = "ClassIcon_Warrior",
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

popularIcons = 
  { ["70_inscription_steamy_romance_novel_kit" ] = L["70_inscription_steamy_romance_novel_kit" ] ,
    ["ability_bossashvane_icon02"              ] = L["ability_bossashvane_icon02"              ] ,
    ["ability_deathknight_heartstopaura"       ] = L["ability_deathknight_heartstopaura"       ] ,
    ["ability_hunter_beastcall"                ] = L["ability_hunter_beastcall"                ] ,
    ["ability_priest_heavanlyvoice"            ] = L["ability_priest_heavanlyvoice"            ] ,
    ["ability_rogue_bloodyeye"                 ] = L["ability_rogue_bloodyeye"                 ] ,
    ["ability_warrior_strengthofarms"          ] = L["ability_warrior_strengthofarms"          ] ,
    ["achievement_doublerainbow"               ] = L["achievement_doublerainbow"               ] ,
    ["achievement_halloween_smiley_01"         ] = L["achievement_halloween_smiley_01"         ] ,
    ["inv_inscription_inkblack01"              ] = L["inv_inscription_inkblack01"              ] ,
    ["inv_inscription_scrollofwisdom_01"       ] = L["inv_inscription_scrollofwisdom_01"       ] ,
    ["inv_jewelry_ring_14"                     ] = L["inv_jewelry_ring_14"                     ] ,
    ["inv_legendary_gun"                       ] = L["inv_legendary_gun"                       ] ,
    ["inv_misc_book_12"                        ] = L["inv_misc_book_12"                        ] ,
    ["inv_misc_food_147_cake"                  ] = L["inv_misc_food_147_cake"                  ] ,
    ["inv_misc_grouplooking"                   ] = L["inv_misc_grouplooking"                   ] ,
    ["inv_misc_kingsring1"                     ] = L["inv_misc_kingsring1"                     ] ,
    ["inv_misc_questionmark"                   ] = L["inv_misc_questionmark"                   ] ,
    ["pet_type_magical"                        ] = L["pet_type_magical"                        ] ,
    ["petbattle_health"                        ] = L["petbattle_health"                        ] ,
    ["spell_shadow_mindsteal"                  ] = L["spell_shadow_mindsteal"                  ] ,
    ["trade_archaeology_delicatemusicbox"      ] = L["trade_archaeology_delicatemusicbox"      ] ,
    ["ui_rankedpvp_01_small"                   ] = L["ui_rankedpvp_01_small"                   ] ,
    ["ui_rankedpvp_02_small"                   ] = L["ui_rankedpvp_02_small"                   ] ,
    ["ui_rankedpvp_03_small"                   ] = L["ui_rankedpvp_03_small"                   ] ,
    ["ui_rankedpvp_04_small"                   ] = L["ui_rankedpvp_04_small"                   ] ,
    ["vas_namechange"                          ] = L["vas_namechange"                          ] ,
    ["warrior_disruptingshout"                 ] = L["warrior_disruptingshout"                 ] ,
  }, -- popularIcons
}; -- iconDB

local localizedRace,  playerRace  = UnitRace("player");
local raceIcons = iconDB.race[playerRace];
menu.IC[raceIcons[2]] = localizedRace .. L["Gender (Male)"];
menu.IC[raceIcons[3]] = localizedRace .. L["Gender (Female)"];
menu.IC[raceIcons[1]] = localizedRace .. L["Gender (Neutral)"];

table.insert(menu.ICOrder, raceIcons[1]);

if raceIcons[1] ~= raceIcons[3] then table.insert(menu.ICOrder, raceIcons[3]); end;
if raceIcons[1] ~= raceIcons[2] and raceIcons[2] ~= raceIcons[3] then table.insert(menu.ICOrder, raceIcons[2]); end;

local localizedClass, playerClass = UnitClass("player");
local classIcon = iconDB.class[playerClass];
menu.IC[classIcon] = localizedClass;
table.insert(menu.ICOrder, classIcon);

for iconFile, iconDesc in pairs(iconDB.popularIcons)
do  menu.IC[iconFile] = col.white(iconDesc);
    table.insert(menu.ICOrder, iconFile)
end;

--[===[
for className, classIcon in pairs(iconDB.class)
do  if className ~= playerClass
    then local localizedClassMale   = LOCALIZED_CLASS_NAMES_MALE[className];
         local localizedClassFemale = LOCALIZED_CLASS_NAMES_FEMALE[className];
         if localizedClassMale ~= localizedClassFemale
         then menu.IC[classIcon] = col.gray(localizedClassFemale);
              table.insert(menu.ICOrder, classIcon);

              menu.IC[classIcon:lower()] = col.gray(localizedClassMale);
              table.insert(menu.ICOrder, classIcon:lower());

         else menu.IC[classIcon] = col.gray(localizedClassFemale);
              table.insert(menu.ICOrder, classIcon);
         end;
    end;
end;

--     
for raceID = 1, NUM_RACES
do  local r = C_CreatureInfo.GetRaceInfo(raceID);
    if r and iconDB.race[r.clientFileString] and r.clientFileString ~= playerRace
    then local raceIcons = iconDB.race[r.clientFileString] 
         menu.IC[raceIcons[1]] = col.gray(r.raceName .. L["Gender (Neutral)"]);
         menu.IC[raceIcons[2]] = col.gray(r.raceName .. L["Gender (Male)"]);
         menu.IC[raceIcons[3]] = col.gray(r.raceName .. L["Gender (Female)"]);
         table.insert(menu.ICOrder, raceIcons[1]);
         table.insert(menu.ICOrder, raceIcons[2]);
         table.insert(menu.ICOrder, raceIcons[3]);
    end;
end;

--]===]
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
--[===[
Editor.TabOrder = { "Basics", "Appearance", "Glance", "Social", "Bio", "Status"};

Editor.groups = {
  appearance = { fields = { "iAppearance", "eyes", "height", "weight", "desc",       }, title = L["Group Appearance" ], },
  basics =     { fields = { "iBasics", "icon", "detachedIcon", "honorific", "name",
                            "honorificCustom", "race", "class", "pronouns"           }, title = L["Group Basics"     ], },
  bio =        { fields = { "iBio", "age", "birthPlace", "home", "history"           }, title = L["Group Bio"        ], },
  glance =     { fields = { "iGlance", "glances"                                     }, title = L["Group Glance"     ], },
  social =     { fields = { "iSocial", "nickname", "house", "motto", "title "        }, title = L["Group Social"     ], },
  status =     { fields = { "iStatus", "rpStyle", "rpStatus", "currently", "oocInfo" }, title = L["Group Status"     ], },
};
--]===]

-- initialization
--
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

function Editor:ClearPending() 
  self.pending = {} 
  self:SetTitle(RP_Identity.addOnTitle .. " - " .. RP_Identity.db:GetCurrentProfile())
end;

function Editor:ApplyPending() 
  for field, value in pairs(self.pending) 
  do RP_Identity:SetMSP(field, value); 
  end;
  self:GeneratePE();
  self:ClearPending();
  RP_Identity:UpdateIdentity();
end;

Editor.ComputePE = computePE;

function Editor:GeneratePE() self:SetMSP("PE", self:ComputePE()); end;

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

local function makeLabel(msp, width)
  local label = AceGUI:Create("Label");
  label.MSP = msp;
  label:SetText(L["Label " .. msp] .. "   ");
  label:SetColor(1, 1, 0, 1);
  label:SetRelativeWidth(width)
  return label;
end;

local function makeSpacer(width)
  local spacer = AceGUI:Create("Label");
  spacer:SetText("");
  spacer:SetRelativeWidth(width or 0.05)
  return spacer;
end;

local function makeEditBox(msp, width)
  local editbox = AceGUI:Create("EditBox");

  local sides = { "Left", "Right", "Middle" };

  -- helper functions
  local function hide() 
    hideTooltip();
    if editbox.editbox:HasFocus() then return end;
    for _, side in ipairs(sides) 
    do editbox.editbox[side]:SetVertexColor(1, 1, 1, 0); 
    end; 
  end;

  local function show() 
    for _, side in ipairs(sides) 
    do editbox.editbox[side]:SetVertexColor(unpack(RP_Identity.addOnColor)) 
    end;  
  end;

  local function hover() 
    showTooltip(editbox, "OnEnter", editbox.tooltipMSP or editbox.MSP);
    if editbox.editbox:HasFocus() then return end;
    for _, side in ipairs(sides) 
    do editbox.editbox[side]:SetVertexColor(1, 1, 0, 1); 
    end 
  end;

  editbox:SetRelativeWidth(width);
  editbox.MSP = msp;
  editbox:SetText(Editor:GetMSP(msp));
  hide();

  editbox.editbox:SetScript("OnEditFocusGained", show)
  editbox.editbox:SetScript("OnEditFocusLost",   hide)
  editbox:SetCallback("OnEnter", hover);
  editbox:SetCallback("OnLeave", hide);

  editbox.PlaceHolder = editbox.editbox:CreateFontString(nil, "BORDER", "GameFontNormalGraySmall");
  editbox.PlaceHolder:SetPoint("LEFT");

  function editbox:HidePlaceholder() self.PlaceHolder:SetText(); end;
  function editbox:ShowPlaceholder() self.PlaceHolder:SetText(self.placeHolderText) end;

  function editbox:SetPlaceholder(text)
    self.placeHolderText = text;
    -- editbox:ApplyPlaceholder();
  end;

  function editbox:ApplyPlaceholder()
    -- local text = self:GetText();
    -- if text and text ~= "" then self:HidePlaceholder() else self:ShowPlaceholder(); end;
  end;

  editbox:SetCallback("OnTextChanged", 
    function(self, event, text)
      self:ApplyPlaceholder();
    end);

  local function editbox_OnEnterPressed(self, event, text)
    if self.linkedColorPicker
    then text = self.linkedColorPicker:ApplyColor(text);
    end;
    self:ApplyPlaceholder(text);
    self:ClearFocus();

    Editor:SetMSP(self.MSP, text);
  end;

  editbox:SetCallback("OnEnterPressed", editbox_OnEnterPressed);

  return editbox;
end;
    
local function makeInstruct(category)
  local widget = AceGUI:Create("Label");
  widget:SetText(L["Instruct " .. category]);
  widget:SetColor(1, 1, 1, 1);
  widget:SetFullWidth(true);
  return widget;
end;

local function makeDropdown(msp, width, menuID)

  menuID = menuID or msp;

  local dropdown = AceGUI:Create("Dropdown");
  dropdown:SetRelativeWidth(width)
  dropdown.MSP = msp;

  dropdown:SetLabel(L["Label " .. msp]);

  local function Dropdown_setValueFromKey(self, event, key, not_interactive)
    if     self.hasCustom and (key == "-1")
    then   self.custom:SetDisabled(false);
           if not not_interactive then self.custom:SetFocus() end;
           self:SetText(self.menu["-1"]);
           self:SetValue("-1");
           Editor:SetMSP(self.MSP, self.custom:GetText());
    elseif self.hasCustom and not self.menu[key]
    then   self.custom:SetDisabled(false);
           if not not_interactive then self.custom:SetFocus() end;
           self:SetText(self.menu["-1"]);
           self:SetValue("-1");
           Editor:SetMSP(self.MSP, self.custom:GetText());
    elseif self.hasCustom and self.menu[key]
    then   self.custom:SetDisabled(true);
           self:SetText(self.menu[key]);
           self:SetValue(key);
           Editor:SetMSP(self.MSP, key);
    elseif self.menu[key]
    then   self:SetValue(key);
           self:SetText(self.menu[key])
           Editor:SetMSP(self.MSP, key);
    else   self:SetValue("");
           self:SetText(self.menu[""]);
           Editor:SetMSP(self.MSP, "");
    end;
    if self.linkedIcon then self.linkedIcon:SetIcon(); end;
  end;

  dropdown.SetValueFromKey = Dropdown_setValueFromKey;

  local function Dropdown_runInitialize(self, custom)
    self.menu = menu[menuID];
    self.order = menu[menuID .. "Order"];

    if not menu[menuID .. "Sorted"]
    then sortingMenu = self.menu;
         table.sort(self.order, sortMenu);
         menu[menuID .. "Sorted"] = true;
    end;

    self:SetList(self.menu, self.order);

    if  custom then self.hasCustom = true; self.custom = custom; end;

    self:SetValueFromKey( nil, Editor:GetMSP(self.MSP) , true);
    
  end;

  dropdown.RunInitialize = Dropdown_runInitialize;

  dropdown:SetCallback("OnValueChanged", Dropdown_setValueFromKey);
  dropdown:SetCallback("OnEnter", showTooltip);
  dropdown:SetCallback("OnLeave", hideTooltip);

  return dropdown;
end;

local function makeCustom(msp, width)
  local custom = AceGUI:Create("EditBox");
  local sides = { "Left", "Right", "Middle" };

  custom.labelText = L["Label " .. msp .. "-custom"];

  -- helper functions
  local function hide() 
    hideTooltip();
    if custom.editbox:HasFocus() then return end;
    for _, side in ipairs(sides) 
    do custom.editbox[side]:SetVertexColor(1, 1, 1, 0); 
    end; 
  end;

  local function show() 
    for _, side in ipairs(sides) 
    do custom.editbox[side]:SetVertexColor(unpack(RP_Identity.addOnColor)) 
    end;  
  end;

  local function hover() 
    showTooltip(custom, "OnEnter", custom.tooltipMSP or custom.MSP);
    if custom.editbox:HasFocus() then return end;
    for _, side in ipairs(sides) 
    do custom.editbox[side]:SetVertexColor(1, 1, 0, 1); 
    end 
  end;

  custom:SetRelativeWidth(width);
  custom.MSP = msp;
  custom.tooltipMSP = msp .. "-custom";
  hide();

  custom.editbox:SetScript("OnEditFocusGained", show)
  custom.editbox:SetScript("OnEditFocusLost",   hide)
  custom:SetCallback("OnEnter", hover);
  custom:SetCallback("OnLeave", hide);

  local function Custom_onEnterPressed(self, event, text)
    Editor:SetMSP(self.MSP, text);
    if self.linkedIcon then self.linkedIcon:SetIcon(); end;
  end;

  custom:SetCallback("OnEnterPressed", Custom_onEnterPressed);
  custom:SetLabel(L["Label " .. msp .. "-custom"]) 

  return custom;
end;

local function makeMultiLine(msp, lines, width)
  local mleditbox = AceGUI:Create("MultiLineEditBox");

  mleditbox:SetLabel(L["Label " .. msp]);
  mleditbox:SetNumLines(lines or 3);

  if not width then mleditbox:SetFullWidth(true); else mleditbox:SetRelativeWidth(width) end;

  mleditbox.MSP = msp;
  mleditbox:SetCallback("OnEnter", showTooltip);
  mleditbox:SetCallback("OnLeave", hideTooltip);

  mleditbox:SetText( Editor:GetMSP(msp) );

  local function MultiLine_onEnterPressed(self, event, text)
    Editor:SetMSP(self.MSP, text)
  end;
  mleditbox:SetCallback("OnEnterPressed", MultiLine_onEnterPressed);

  return mleditbox;
end;

local function makeColorPicker(msp)

  local ADD_FMT     = "|cff%02x%02x%02x%s|r";
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

  local picker = AceGUI:Create("ColorPicker");
  picker.MSP = msp;
  picker:SetHasAlpha(false);
  picker:SetRelativeWidth(0.05);
  picker.tooltipMSP = "Color";
  picker:SetCallback("OnEnter", showTooltip);
  picker:SetCallback("OnLeave", hideTooltip);
  
  local function picker_runInitialize(self, linkedEditBox)
    self.linkedEditBox = linkedEditBox;
    linkedEditBox.linkedColorPicker = self;
    local initialValue = Editor:GetMSP(msp);
    local r, g, b, text = extractColor(initialValue);
    r, g, b = r or 1, g or 1, b or 1;
    self:SetColor(r, g, b, 1);
    self.r, self.g, self.b = r, g, b;
    linkedEditBox:SetText(text);
  end;

  picker.RunInitialize = picker_runInitialize;

  local function picker_applyColor(self, text) return addColor(self.r, self.g, self.b, text) end;

  picker.ApplyColor = picker_applyColor;

  local function picker_OnValueConfirmed(self, event, r, g, b, a)
      Editor:SetMSP(self.MSP, addColor(r, g, b, self.main:GetText() ));
      self.r, self.g, self.b = r, g, b;
  end;

  picker:SetCallback("OnValueConfirmed", picker_OnValueComfirmed);

  return picker;

end;

Editor.Make = {};

function Editor.Make:Glances()
  local panelFrame = AceGUI:Create("SimpleGroup");
  panelFrame:SetLayout("Flow");
  panelFrame:SetFullWidth(true);

  panelFrame:AddChild(makeInstruct("Glances"));

  local groupOrder = { "PE1", "PE2", "PE3", "PE4", "PE5" };
  local glancesGroup = AceGUI:Create("SimpleGroup");

  local function createPreviewIcon(msp)

    local bigNumbers = "Interface\\Timer\\BigTimerNumbers";
    local numberCoords = 
    { PE1 = { L = 1/4, R = 2/4, T = 0/3, B = 1/3 },
      PE2 = { L = 2/4, R = 3/4, T = 0/3, B = 1/3 },
      PE3 = { L = 3/4, R = 4/4, T = 0/3, B = 1/3 },
      PE4 = { L = 0/4, R = 1/4, T = 1/3, B = 2/3 },
      PE5 = { L = 1/4, R = 2/4, T = 1/3, B = 2/3 },
    }

    local icon = AceGUI:Create("IconNoHighlight")

    icon.MSP        = msp;
    icon.tooltipMSP = msp .. "-icon";

    icon:SetRelativeWidth(0.20);
    icon:SetImageSize(64, 64);

    local edge = numberCoords[msp];

    function icon:SetIcon(useThisIcon)
      local iconFile   = useThisIcon or Editor:GetMSP(self.MSP .. "-icon");
      local customIcon = Editor:GetMSP(self.MSP .. "-icon-custom");

      if     iconFile == "-1" and customIcon ~= ""
      then   self:SetImage("Interface\\ICONS\\" .. customIcon)
      elseif iconFile ~= ""
      then   self:SetImage("Interface\\ICONS\\" .. iconFile);
      else   self:SetImage(bigNumbers, edge.L, edge.R, edge.T, edge.B);
      end;
    end;

    local function icon_OnClick(self, event) glancesGroup:SelectGlance(self.MSP) end;
    icon:SetCallback("OnClick", icon_OnClick);
    icon:SetIcon();

    return icon;
  end;

  local previewIcon = {};
  for _, msp in ipairs(groupOrder) 
  do  previewIcon[msp] = createPreviewIcon(msp); 
      panelFrame:AddChild(previewIcon[msp]);
  end;

  function glancesGroup:SelectGlance(msp)

    self:ReleaseChildren();

    local heading = AceGUI:Create("Heading");
    heading:SetFullWidth(true);
    heading:SetText(L["Label " .. msp]);

    self:AddChild(heading);

    local custom = makeCustom(msp .. "-icon", 0.5);
    custom:SetLabel(L["Label " .. msp .. "-icon-custom"]);
    custom.linkedIcon = previewIcon[msp];

    custom:SetCallback("OnEnterPressed", 
      function(self, event, text) 
        Editor:SetMSP(self.MSP, text) 
        Editor:GeneratePE();
        self.linkedIcon:SetIcon();
      end);
      
    local dropdown = makeDropdown(msp .. "-icon", 0.5, "IC");
    dropdown:SetLabel(L["Label " .. msp .. "-icon"]);
    dropdown.linkedIcon = previewIcon[msp];

    dropdown:RunInitialize(custom);

    dropdown:SetCallback("OnValueChanged",
      function(self, event, key)
        dropdown:SetValueFromKey(event, key);
        Editor:GeneratePE();
      end);

    self:AddChild(makeLabel(msp .. "-title", 0.15));


    local title = makeEditBox(msp .. "-title", 0.85);
    title:SetCallback("OnEnterPressed", 
      function(self, event, text) 
        Editor:SetMSP(self.MSP, text); 
        self:ApplyPlaceholder();
        Editor:GeneratePE();
        self:ClearFocus();
      end);

    title:SetPlaceholder(L["Placeholder " .. msp .. "-title"]);

    self:AddChild(title);

    self:AddChild(dropdown);
    self:AddChild(custom);

    local multiLine = makeMultiLine(msp .. "-text", 6);
    multiLine:SetCallback("OnEnterPressed", 
      function(self, event, text) 
        Editor:SetMSP(self.MSP, text); 
        Editor:GeneratePE();
      end);

    self:AddChild(multiLine)

  end;

  glancesGroup:SetFullWidth(true);
  glancesGroup:SetFullHeight(true);
  glancesGroup:SetLayout("Flow");
  glancesGroup:SelectGlance("PE1");

  panelFrame:AddChild(glancesGroup);

  return panelFrame;
end;

function Editor.Make:Appearance()
  local panelFrame = AceGUI:Create("SimpleGroup");
  panelFrame:SetLayout("Flow");
  panelFrame:SetFullWidth(true);
  panelFrame:AddChild(makeInstruct("Appearance"))

  panelFrame:AddChild(makeLabel("AE", 0.15));      -- eyes
  local eyesEditBox = makeEditBox("AE", 0.75);
  eyesEditBox:SetPlaceholder(L["Placeholder AE"]);
  local eyesColorPicker = makeColorPicker("AE");
  eyesColorPicker:RunInitialize(eyesEditBox);
  panelFrame:AddChild(eyesEditBox);
  panelFrame:AddChild(eyesColorPicker);

  panelFrame:AddChild(makeLabel("AH", 0.15));      -- height
  local heightEditBox = makeEditBox("AH", 0.85);
  heightEditBox:SetPlaceholder(L["Placeholder AH"]);
  panelFrame:AddChild(heightEditBox);
  panelFrame:AddChild(makeLabel("AW", 0.15));      -- weight
  local weightEditBox = makeEditBox("AW", 0.85);
  weightEditBox:SetPlaceholder(L["Placeholder AW"]);
  panelFrame:AddChild(weightEditBox);
  panelFrame:AddChild(makeMultiLine("DE", 18));    -- description

  return panelFrame;

end;

function Editor.Make:Basics()
  local panelFrame = AceGUI:Create("SimpleGroup");
  panelFrame:SetLayout("Flow");
  panelFrame:SetFullWidth(true);
  panelFrame:AddChild(makeInstruct("Basics"));

  local playerIcon = AceGUI:Create("IconNoHighlight");               -- icon
  playerIcon.MSP = "IC";
  playerIcon.tooltipMSP = "IC-icon";
  playerIcon:SetCallback("OnEnter", showTooltip);
  playerIcon:SetCallback("OnLeave", hideTooltip);

  playerIcon:SetImageSize(64, 64);
  playerIcon:SetRelativeWidth(0.20);

  function playerIcon:SetIcon(useThisIcon)
    local iconFile   = useThisIcon or Editor:GetMSP("IC");
    local customIcon = Editor:GetMSP("IC-icon-custom");

    if     iconFile == "-1" and customIcon ~= ""
    then   self:SetImage("Interface\\ICONS\\" .. customIcon)
    elseif iconFile ~= ""
    then   self:SetImage("Interface\\ICONS\\" .. iconFile);
    end;
  end;

  playerIcon:SetIcon();
  panelFrame:AddChild(playerIcon);

  local iconDropdown = makeDropdown("IC", 0.40);
  local iconCustom = makeCustom("IC", 0.40);
  iconDropdown:RunInitialize(iconCustom);
  iconDropdown.linkedIcon = playerIcon;
  iconCustom.linkedIcon = playerIcon;
  panelFrame:AddChild(iconDropdown);
  panelFrame:AddChild(iconCustom);

  local nameHeader = AceGUI:Create("Heading");
  nameHeader:SetText("Character Name");
  nameHeader:SetFullWidth(true);

  panelFrame:AddChild(nameHeader);

  local honorificDropdown = makeDropdown("PX", 0.20);
  local honorificCustom = makeCustom("PX", 0.20);
  honorificDropdown:RunInitialize(honorificCustom);
  panelFrame:AddChild(honorificDropdown);

  honorificDropdown:SetLabel();
  honorificCustom:SetLabel();

  panelFrame:AddChild(makeSpacer(0.02));
  local nameEditBox = makeEditBox("NA", 0.73);
  local nameColorPicker = makeColorPicker("NA");
  nameColorPicker:RunInitialize(nameEditBox);

  panelFrame:AddChild(nameEditBox);
  panelFrame:AddChild(nameColorPicker);

  panelFrame:AddChild(honorificCustom);

  panelFrame:AddChild(makeSpacer(0.02));
  panelFrame:AddChild(makeLabel("RA", 0.10))
  panelFrame:AddChild(makeEditBox("RA", 0.68));

  local pronounDropdown = makeDropdown("PN", 0.20);
  local pronounCustom = makeCustom("PN", 0.20);
  pronounDropdown:RunInitialize(pronounCustom);
  pronounDropdown:SetLabel();

  panelFrame:AddChild(pronounDropdown);

  panelFrame:AddChild(makeSpacer(0.02));
  panelFrame:AddChild(makeLabel("RC", 0.10));
  panelFrame:AddChild(makeEditBox("RC", 0.68));

  panelFrame:AddChild(pronounCustom);
  pronounCustom:SetLabel();

  return panelFrame;
end;

function Editor.Make:Bio()
  local panelFrame = AceGUI:Create("SimpleGroup");

  panelFrame:SetLayout("Flow");
  panelFrame:SetFullWidth(true);
  panelFrame:AddChild(makeInstruct("Bio"));
  panelFrame:AddChild(makeLabel("AG", 0.15));

  local ageEditBox = makeEditBox("AG", 0.85);
  ageEditBox:SetPlaceholder(L["Placeholder AG"]);
  panelFrame:AddChild(ageEditBox);

  panelFrame:AddChild(makeLabel("HB", 0.15));
  local birthplaceEditBox = makeEditBox("HB", 0.85);
  birthplaceEditBox:SetPlaceholder(L["Placeholder HB"]);
  panelFrame:AddChild(birthplaceEditBox);

  panelFrame:AddChild(makeLabel("HH", 0.15));
  local homeEditBox = makeEditBox("HH", 0.85);
  homeEditBox:SetPlaceholder(L["Placeholder HH"]);
  panelFrame:AddChild(homeEditBox);

  panelFrame:AddChild(makeMultiLine("HI", 18));

  return panelFrame;
end;

function Editor.Make:Social()
  local panelFrame = AceGUI:Create("SimpleGroup");
  panelFrame:SetLayout("Flow");
  panelFrame:SetFullWidth(true);
  panelFrame:AddChild(makeInstruct("Social"));

  panelFrame:AddChild(makeLabel("NI", 0.15));    -- nickname
  local nicknameEditBox = makeEditBox("NI", 0.85);
  nicknameEditBox:SetPlaceholder(L["Placeholder NI"]);
  panelFrame:AddChild(nicknameEditBox);

  panelFrame:AddChild(makeLabel("NT", 0.15));    -- (long) title
  local titleEditBox = makeEditBox("NT", 0.85);
  titleEditBox:SetPlaceholder(L["Placeholder NT"]);
  panelFrame:AddChild(titleEditBox);

  panelFrame:AddChild(makeLabel("NH", 0.15));    -- house name
  local houseEditBox = makeEditBox("NH", 0.85);
  houseEditBox:SetPlaceholder(L["Placeholder NH"]);
  panelFrame:AddChild(houseEditBox);

  panelFrame:AddChild(makeLabel("MO", 0.15));    -- motto
  local mottoEditBox = makeEditBox("MO", 0.85);
  mottoEditBox:SetPlaceholder(L["Placeholder MO"]);
  panelFrame:AddChild(mottoEditBox);

  return panelFrame;
end;

function Editor.Make:Status()
  local panelFrame = AceGUI:Create("SimpleGroup");
  panelFrame:SetLayout("Flow");
  panelFrame:SetFullWidth(true);
  panelFrame:AddChild(makeInstruct("Status"));

  local left = AceGUI:Create("SimpleGroup");
  left:SetRelativeWidth(0.49);
  panelFrame:AddChild(left);

  panelFrame:AddChild(makeSpacer(0.02));

  local right = AceGUI:Create("SimpleGroup");
  right:SetRelativeWidth(0.49);
  panelFrame:AddChild(right);

  local statusDropdown = makeDropdown("FC", 1) -- rpStatus
  local statusCustom = makeCustom("FC", 1)
  statusCustom:SetLabel();
  statusDropdown:RunInitialize(statusCustom);

  left:AddChild(statusDropdown);
  left:AddChild(statusCustom);

  local styleDropdown = makeDropdown("FR", 1) -- rpStyle
  local styleCustom = makeCustom("FC", 1);
  styleCustom:SetLabel();
  styleDropdown:RunInitialize(styleCustom);

  right:AddChild(styleDropdown);
  right:AddChild(styleCustom);

  left:AddChild(makeMultiLine("CU", 12, 1))
  right:AddChild(makeMultiLine("CO", 12, 1))
  return panelFrame;
end;

Editor.TabOrder = { "Basics", "Appearance", "Glances", "Social", "Bio", "Status" };
Editor.TabList =
{ { value = "Basics",     text = L["Group Basics"     ] },
  { value = "Appearance", text = L["Group Appearance" ] },
  { value = "Glances",     text = L["Group Glances"     ] },
  { value = "Social",     text = L["Group Social"     ] },
  { value = "Bio",        text = L["Group Bio"        ] },
  { value = "Status",     text = L["Group Status"     ] },
};

Editor.TabGroup = AceGUI:Create("TabGroup");
Editor.TabGroup:SetFullWidth(true);
Editor.TabGroup:SetFullHeight(true);
Editor.TabGroup:SetLayout("Flow");
Editor.TabGroup:SetTabs(Editor.TabList);
Editor.TabGroup.Editor = Editor;

Editor:AddChild(Editor.TabGroup);

function Editor.TabGroup:LoadTab(tab)
  self:ReleaseChildren();

  self.scrollContainer = AceGUI:Create("SimpleGroup");
  self.scrollContainer:SetFullWidth(true);
  self.scrollContainer:SetFullHeight(true);
  self.scrollContainer:SetLayout("Fill");
  self:AddChild(self.scrollContainer);
  self.scrollFrame = AceGUI:Create("ScrollFrame");
  self.scrollFrame:SetLayout("Flow");
  self.scrollContainer:AddChild(self.scrollFrame);
  local panelFrame = Editor.Make[tab](Editor);
  self.scrollFrame:AddChild(panelFrame);
  self.Editor.currentGroup = tab;
end;

Editor.TabGroup:SetCallback("OnGroupSelected",
  function(self, event, group)
    self.Editor:ApplyPending();
    self:LoadTab(group);
  end);

function Editor:ReloadTab()
  self.TabGroup:LoadTab(self.currentGroup or self.TabOrder[1]);
  self:SetTitle(RP_Identity.addOnTitle .. " - " .. RP_Identity.db:GetCurrentProfile() );
end;

function RP_Identity:OpenOptions()
  InterfaceOptionsFrame:Show();
  InterfaceOptionsFrame_OpenToCategory(self.addOnTitle)
  self.Editor:Hide();
end;

--[===[
local groupOrder = { "basics", "appearance", "glance", "social", "bio", "status"};

Editor.groups = {
  appearance = { fields = { "eyes", "height", "weight", "desc",            }, title = L["Group Appearance" ], },
  basics =     { fields = { "icon", "detachedIcon", "honorific", "name", 
                            "honorificCustom", "race", "class", "pronouns" }, title = L["Group Basics"     ], },
  bio =        { fields = { "age", "birthPlace", "home", "history"         }, title = L["Group Bio"        ], },
  social =     { fields = { "nickname", "house", "motto", "title "         }, title = L["Group Social"     ], },

  status =     { fields = { "rpStyle", "rpStatus", "currently", "oocInfo"  }, title = L["Group Status"     ], },
  glance =     { fields = { "glances"                                      }, title = L["Group Glance"     ], },
};
--]===]

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
  if     self.db.profile.myMSP.FC == "1"
  then   self:SetStatus("2");
  elseif self.db.profile.myMSP.FC == "2"
  then   self:SetStatus("1")
  else   self:NotifyStatus();
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

    if     cmd == "" or cmd == "help"                   then RP_Identity:HelpCommand();
    elseif cmd:match("^option") or cmd:match("^config") then RP_Identity:OpenOptions();
    elseif cmd == "toggle" and param[1] == "status"     then RP_Identity:ToggleStatus();
    elseif cmd == "toggle"                              then RP_Identity:ToggleEditorFrame();
    elseif cmd == "open"                                then RP_Identity.Editor:ReloadTab(); 
                                                             RP_Identity.Editor.frame:Show();
    elseif cmd == "status" and param[1] == "ooc"        then RP_Identity:SetStatus("1");
    elseif cmd == "status" and param[1] == "ic"         then RP_Identity:SetStatus("2");
    elseif cmd == "status" and not param[1]             then RP_Identity:NotifyStatus();
    elseif cmd == "status"                              then RP_Identity:SetStatus(table.concat(param, " "))
    elseif cmd:match("^curr") and not param[1]          then RP_Identity:NotifyCurrently()
    elseif cmd:match("^curr")                           then RP_Identity:SetCurrently(table.concat(param, " "));
    elseif cmd:match("^info") and not param[1]          then RP_Identity:NotifyInfo()
    elseif cmd:match("^info")                           then RP_Identity:SetInfo(table.concat(param, " "));

    end;
  end;
