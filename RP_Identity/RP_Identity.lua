-- RP Tags
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
--
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license.

local addOnName, ns = ...;

local L = LibStub("AceLocale-3.0"):GetLocale(addOnName);

local RP_Identity = LibStub("AceAddon-3.0"):NewAddon(
                      addOnName
                      -- , "AceEvent-3.0",
                      -- , "AceLocale-3.0",
                      -- , "AceTimer-3.0"
                      );

RP_Identity.addOnName    = addOnName;
RP_Identity.addOnTitle   = GetAddOnMetadata(addOnName, "Title");
RP_Identity.addOnVersion = GetAddOnMetadata(addOnName, "Version");

local AceGUI = LibStub("AceGUI-3.0");

local Editor = AceGUI:Create("Window");

Editor:SetWidth(600);
Editor:SetHeight(400);
Editor:SetTitle(RP_Identity.addOnTitle);
Editor:SetLayout("Flow");
Editor:Hide();
Editor.pending = {};
Editor.currentFrames = {};

function Editor:GetFrame(frameName)
  if self.currentFrames[frameName] then return self.currentFrames[frameName] end;
end;

function Editor:GetMSP(msp)
  if self.pending[msp] then return self.pending[msp]
  else return RP_Identity:GetMSP(msp);
  end;
end;

function Editor:SetMSP(msp, value) self.pending[msp] = value; end;

function Editor:ClearPending() self.pending = {} end;

function Editor:ApplyPending() 
  for field, value in pairs(self.pending)
  do  RP_Identity:SetMSP(field, value);
  end;
  self:ClearPending();
end;

local function loadIdentity(self) self:SetText( Editor:GetMSP(self.MSP)); end;
local function saveIdentity(self) Editor:SetMSP(self.MSP, self:GetText()) end;
local function doNothing(self)                                            end;

local function loadIdentityDropdown(self) 
  local value = Editor:GetMSP(self.MSP);
  if   self.menu[value]
  then self:SetValue(value)
       self.custom:SetDisabled(true);
       self.custom:SetText("");
  else self:SetValue("-1");
       self.custom:SetDisabled(false)
       self.custom:SetText(value);
  end;
end;

local function saveIdentityDropdown(self)
  local value = self.currentValue;
  if   value == "-1"
  then Editor:SetMSP(self.MSP, self.custom:GetText());
  else Editor:SetMSP(self.MSP, value);
  end;
end;
  
local function dropdownValueChanged(self, key)
  self.custom:SetDisabled( key ~= "-1") 
  self.currentValue = key;
end;

local menu =
{ rpStyle =
  { ["-1"] = L["Custom Style"],
    ["0"]  = L["Undefined"],
    ["1"]  = L["Normal"],
    ["2"]  = L["Casual"],
    ["3"]  = L["Full-Time"],
    ["4"]  = L["Beginner"],
  },
  rpStyleOrder = { "0", "2", "1", "3", "4", "-1" },
  rpStatus =
  { ["-1"] = L["Custom Status"],
    ["0"]  = L["Undefined"],
    ["1"]  = L["Out of Character"],
    ["2"]  = L["In Character"],
    ["3"]  = L["Looking for Contact"],
    ["4"]  = L["Storyteller"],
  },
  rpStatusOrder = { "0", "2", "1", "3", "4", "-1" },
  pronouns =
  { ["-1"] = L["Custom Pronouns"],
    [""] = L["Undefined"],
    [L["Pronouns She/Her"]] = L["Pronouns She/Her"],
    [L["Pronouns He/Him"]] = L["Pronouns He/Him"],
    [L["Pronouns They/Them"]] = L["Pronouns They/Them"],
    [L["Pronouns It/Its"]] = L["Pronouns It/Its"],
  },
  pronounsOrder = { "", L["Pronouns She/Her"], L["Pronouns He/Him"], 
                        L["Pronouns They/Them"], L["Pronouns It/Its"] };
  honorifics =
  { ["-1"] = L["Custom Honorific"],
    [""] = L["None"],
  },
  honorificsOrder = { "", },
  icon =
  { ["-1"] = L["Custom Icon"],
    [""] = L["Undefined"],
  },
  iconOrder = { "" };
};

local extraPronouns = L["Pronouns Extra"];
extraPronouns = { strsplit("|", extraPronouns) };
for p, pronoun in ipairs(extraPronouns)
do  menu.pronouns[pronoun] = pronoun
    table.insert(menu.pronounsOrder, pronoun);
end;
table.insert(menu.pronounsOrder, "-1");

local honorifics = L["Honorifics Extra"];
honorifics = { strsplit("|", honorifics) };
for t, title in ipairs(honorifics)
do  menu.honorifics[title] = title;
    table.insert(menu.honorificsOrder, title);
end;
table.insert(menu.honorificsOrder, "-1");

-- primarily adapted from totalRP3

local iconDB = { race = { }, class = { } };

iconDB.race["BloodElf"          ][1] = "Interface\\ICONS\\achievement_character_bloodelf_female";
iconDB.race["BloodElf"          ][2] = "Interface\\ICONS\\achievement_character_bloodelf_male";
iconDB.race["BloodElf"          ][3] = "Interface\\ICONS\\achievement_character_bloodelf_female";
iconDB.race["DarkIronDwarf"     ][1] = "Interface\\ICONS\\ability_racial_foregedinflames";
iconDB.race["DarkIronDwarf"     ][2] = "Interface\\ICONS\\ability_racial_fireblood";
iconDB.race["DarkIronDwarf"     ][3] = "Interface\\ICONS\\ability_racial_foregedinflames";
iconDB.race["Draenei"           ][1] = "Interface\\ICONS\\achievement_character_draenei_female";
iconDB.race["Draenei"           ][2] = "Interface\\ICONS\\achievement_character_draenei_male";
iconDB.race["Draenei"           ][3] = "Interface\\ICONS\\achievement_character_draenei_female";
iconDB.race["Dwarf"             ][1] = "Interface\\ICONS\\achievement_character_dwarf_female";
iconDB.race["Dwarf"             ][2] = "Interface\\ICONS\\achievement_character_dwarf_male";
iconDB.race["Dwarf"             ][3] = "Interface\\ICONS\\achievement_character_dwarf_female";
iconDB.race["Gnome"             ][1] = "Interface\\ICONS\\achievement_character_gnome_female";
iconDB.race["Gnome"             ][2] = "Interface\\ICONS\\achievement_character_gnome_male";
iconDB.race["Gnome"             ][3] = "Interface\\ICONS\\achievement_character_gnome_female";
iconDB.race["Goblin"            ][1] = "Interface\\ICONS\\ability_racial_rocketjump";
iconDB.race["Goblin"            ][2] = "Interface\\ICONS\\ability_racial_rocketjump";
iconDB.race["Goblin"            ][3] = "Interface\\ICONS\\ability_racial_rocketjump";
iconDB.race["HighmountainTauren"][1] = "Interface\\ICONS\\achievement_alliedrace_highmountaintauren";
iconDB.race["HighmountainTauren"][2] = "Interface\\ICONS\\ability_racial_bullrush";
iconDB.race["HighmountainTauren"][3] = "Interface\\ICONS\\achievement_alliedrace_highmountaintauren";
iconDB.race["Human"             ][1] = "Interface\\ICONS\\achievement_character_human_female";
iconDB.race["Human"             ][2] = "Interface\\ICONS\\achievement_character_human_male";
iconDB.race["Human"             ][3] = "Interface\\ICONS\\achievement_character_human_female";
iconDB.race["KulTiran"          ][1] = "Interface\\ICONS\\ability_racial_childofthesea";
iconDB.race["KulTiran"          ][2] = "Interface\\ICONS\\achievement_boss_zuldazar_manceroy_mestrah";
iconDB.race["KulTiran"          ][3] = "Interface\\ICONS\\ability_racial_childofthesea";
iconDB.race["LightforgedDraenei"][1] = "Interface\\ICONS\\achievement_alliedrace_lightforgeddraenei";
iconDB.race["LightforgedDraenei"][2] = "Interface\\ICONS\\ability_racial_finalverdict";
iconDB.race["LightforgedDraenei"][3] = "Interface\\ICONS\\achievement_alliedrace_lightforgeddraenei";
iconDB.race["MagharOrc"         ][1] = "Interface\\ICONS\\achievement_character_orc_female_brn";
iconDB.race["MagharOrc"         ][2] = "Interface\\ICONS\\achievement_character_orc_male_brn";
iconDB.race["MagharOrc"         ][3] = "Interface\\ICONS\\achievement_character_orc_female_brn";
iconDB.race["Mechagnome"        ][1] = "Interface\\ICONS\\inv_plate_mechagnome_c_01helm";
iconDB.race["Mechagnome"        ][2] = "Interface\\ICONS\\ability_racial_hyperorganiclightoriginator";
iconDB.race["Mechagnome"        ][3] = "Interface\\ICONS\\inv_plate_mechagnome_c_01helm";
iconDB.race["NightElf"          ][1] = "Interface\\ICONS\\achievement_character_nightelf_female";
iconDB.race["NightElf"          ][2] = "Interface\\ICONS\\achievement_character_nightelf_male";
iconDB.race["NightElf"          ][3] = "Interface\\ICONS\\achievement_character_nightelf_female";
iconDB.race["Nightborne"        ][1] = "Interface\\ICONS\\ability_racial_masquerade";
iconDB.race["Nightborne"        ][2] = "Interface\\ICONS\\ability_racial_dispelillusions";
iconDB.race["Nightborne"        ][3] = "Interface\\ICONS\\ability_racial_masquerade";
iconDB.race["Orc"               ][1] = "Interface\\ICONS\\achievement_character_orc_female";
iconDB.race["Orc"               ][2] = "Interface\\ICONS\\achievement_character_orc_male";
iconDB.race["Orc"               ][3] = "Interface\\ICONS\\achievement_character_orc_female";
iconDB.race["Pandaren"          ][1] = "Interface\\ICONS\\achievement_character_pandaren_female";
iconDB.race["Pandaren"          ][2] = "Interface\\ICONS\\achievement_guild_classypanda";
iconDB.race["Pandaren"          ][3] = "Interface\\ICONS\\achievement_character_pandaren_female";
iconDB.race["Scourge"           ][1] = "Interface\\ICONS\\achievement_character_undead_female";
iconDB.race["Scourge"           ][2] = "Interface\\ICONS\\achievement_character_undead_male";
iconDB.race["Scourge"           ][3] = "Interface\\ICONS\\achievement_character_undead_female";
iconDB.race["Tauren"            ][1] = "Interface\\ICONS\\achievement_character_tauren_female";
iconDB.race["Tauren"            ][2] = "Interface\\ICONS\\achievement_character_tauren_male";
iconDB.race["Tauren"            ][3] = "Interface\\ICONS\\achievement_character_tauren_female";
iconDB.race["Troll"             ][1] = "Interface\\ICONS\\achievement_character_troll_female";
iconDB.race["Troll"             ][2] = "Interface\\ICONS\\achievement_character_troll_male";
iconDB.race["Troll"             ][3] = "Interface\\ICONS\\achievement_character_troll_female";
iconDB.race["VoidElf"           ][1] = "Interface\\ICONS\\ability_racial_preturnaturalcalm";
iconDB.race["VoidElf"           ][2] = "Interface\\ICONS\\ability_racial_entropicembrace";
iconDB.race["VoidElf"           ][3] = "Interface\\ICONS\\ability_racial_preturnaturalcalm";
iconDB.race["Vulpera"           ][1] = "Interface\\ICONS\\ability_racial_nosefortrouble";
iconDB.race["Vulpera"           ][2] = "Interface\\ICONS\\ability_racial_nosefortrouble";
iconDB.race["Vulpera"           ][3] = "Interface\\ICONS\\ability_racial_nosefortrouble";
iconDB.race["Worgen"            ][1] = "Interface\\ICONS\\ability_racial_viciousness";
iconDB.race["Worgen"            ][2] = "Interface\\ICONS\\achievement_worganhead";
iconDB.race["Worgen"            ][3] = "Interface\\ICONS\\ability_racial_viciousness";
iconDB.race["ZandalariTroll"    ][1] = "Interface\\ICONS\\inv_zandalarifemalehead";
iconDB.race["ZandalariTroll"    ][2] = "Interface\\ICONS\\inv_zandalarimalehead";
iconDB.race["ZandalariTroll"    ][3] = "Interface\\ICONS\\inv_zandalarifemalehead";

iconDB.class["WARRIOR"     ] = "Interface\\Icons\\ClassIcon_Warrior";
iconDB.class["PALADIN"     ] = "Interface\\Icons\\ClassIcon_Paladin";
iconDB.class["HUNTER"      ] = "Interface\\Icons\\ClassIcon_Hunter";
iconDB.class["ROGUE"       ] = "Interface\\Icons\\ClassIcon_Rogue";
iconDB.class["PRIEST"      ] = "Interface\\Icons\\ClassIcon_Priest";
iconDB.class["DEATHKNIGHT" ] = "Interface\\Icons\\ClassIcon_DeathKnight";
iconDB.class["SHAMAN"      ] = "Interface\\Icons\\ClassIcon_Shaman";
iconDB.class["MAGE"        ] = "Interface\\Icons\\ClassIcon_Mage";
iconDB.class["WARLOCK"     ] = "Interface\\Icons\\ClassIcon_Warlock";
iconDB.class["MONK"        ] = "Interface\\Icons\\ClassIcon_Monk";
iconDB.class["DRUID"       ] = "Interface\\Icons\\ClassIcon_Druid";
iconDB.class["DEMONHUNTER" ] = "Interface\\Icons\\ClassIcon_DemonHunter";

local localizedRace, playerRace = UnitRace("player");
local localizedClass, playerClass = UnitClass("player");
local raceIcons = iconDB.race[playerRace];
local classIcon = iconDB.class[playerClass];

menu.icon[raceIcons[1]] = localizedRace .. L["Gender (Neutral)"];
menu.icon[raceIcons[2]] = localizedRace .. L["Gender (Male)"];
menu.icon[raceIcons[3]] = localizedRace .. L["Gender (Female)"];
menu.icon[classIcon] = localizedClass;
table.insert(menu.iconOrder, raceIcons[1]);
table.insert(menu.iconOrder, raceIcons[3]);
table.insert(menu.iconOrder, raceIcons[2]);
table.insert(menu.iconOrder, classIcon);

Editor.uiFields = {};

local f = Editor.uiFields;

local function extractColor(str)
  local r, g, b, name = str:match("^|cff(%x%x)(%x%x)(%x%x)(.+)|r$");
  if r then 
  return tonumber(r, 16) / 255, 
         tonumber(g, 16) / 255, 
         tonumber(b, 16) / 255,
         name
  else return nil, nil, nil, str
  end;
end;

local function makeLabel(msp, width)
  local w = AceGUI:Create("Label");
  w.MSP = msp;
  w:SetText(L["Label " .. msp]);
  w:SetRelativeWidth(width)
  return w;
end;

local function makeEditBox(msp, width)
  local w = AceGUI:Create("EditBox");
  w:SetRelativeWidth(width);
  w.MSP = msp;
  w.LoadIdentity = loadIdentity;
  w.SaveIdentity = saveIdentity;
  return w;
end;

local function makeDropdown(msp, width, menu, custom)
  local w = AceGUI:Create("Dropdown");
  w:SetRelativeWidth(width);
  w.MSP = msp;
  w.menu = menu;
  w.getFrame = { "custom", custom };
  w:SetList(menu[menu], menu[menu .. "Order"]);
  w:SetCallback("OnValueChanged", dropdownValueChanged);
  w.LoadIdentity = loadIdentityDropdown;
  w.SaveIdentity = saveIdentityDropdown;
  return w;
end;

local function makeCustom(msp, width)
  local w = AceGUI:Create("EditBox");
  w:SetRelativeWidth(width);
  w:SetDisabled(true);
  w.MSP = msp;
  w.LoadIdentity = doNothing;
  w.SaveIdentity = doNothing;
  return w;
end;

local function makeMultiLine(msp, lines)
  local w = AceGUI:Create("MultiLineEditBox");
  w:SetFullWidth(true);
  w.MSP = msp;
  w.LoadIdentity = loadIdentity;
  w.SaveIdentity = saveIdentity;
  return w;

local function makeColorPicker(msp, textField)
  local w = AceGUI:Create("ColorPicker");
  w.MSP = msp;
  w:SetHasAlpha(false);
  w:SetRelativeWidth(0.1);
  w.LoadIdentity = doNothing;
  w.SaveIdentity = doNothing;
  w:SetCallback("OnValueConfirmed", function(r, g, b, a) w.r, w.g, w.b = r, g, b end);
  return w;
end;

local function makeEditBoxWithColor(msp, colorField, width)
  local w = AceGUI:Create("EditBox");
  w:SetRelativeWidth(width); w.MSP = msp;
  w.getFrame("color", colorField);
  function w:LoadIdentity()
     local value = Editor:GetMSP(self.MSP);
     local r, g, b, name = extractColor(value);
     if r then self.color:SetColor(r, g, b, 1)
          else self.color:SetColor(1, 1, 1, 1)
     end;
     self:SetText(name);
  end;
  function w:SaveIdentity()
     local r, g, b = self.color.r, self.color.g, self.color,b;
     if r then Editor:SetMSP(
                 string.format(
                   "|cff%02x%02x%02x%s|r",
                   r * 255,
                   g * 255,
                   b * 255,
                 self:GetText()))
     else Editor:SetMSP( self:GetText())
  end;
  return w;
end;

f = 
{ 
  age                 = function() return makeEditBox("AG", 0.5                       )   end,
  ageLabel            = function() return makeLabel("AG", 0.1                         )   end,
  birthPlace          = function() return makeEditBox("HB", 0.5                       )   end,
  birthPlaceLabel     = function() return makeLabel("HB", 0.25                        )   end,
  class               = function() return makeEditBox("RC", 0.5,                      )   end,
  classLabel          = function() return makeLabel("RC". 0.1                         )   end,
  currently           = function() return makeMultiLine("CU", 3                       )   end,
  currentlyLabel      = function() return makeLabel("CU", 0.25                        )   end,
  desc                = function() return makeMultiLine("DE", 3                       )   end,
  descLabel           = function() return makeLabel("DE", 0.25                        )   end,
  eyes                = function() return makeEditBoxWithColor("AE", "eyeColor", 0.5  )   end,
  eyesLabel           = function() return makeLabel("AE", 0.25                        )   end,
  eyeColor            = function() return makeColorPicker("AE", "eyes"                )   end,
  eyeColorLabel       = function() return makeLabel("Color", 0.1                      )   end,
  height              = function() return makeEditBox("AH", 0.5                       )   end,
  heightLabel         = function() return makeLabel("AH", 0.1                         )   end,
  history             = function() return makeMultiLine("HI", 3                       )   end,
  historyLabel        = function() return makeLabel("HI", 0.1                         )   end,
  home                = function() return makeEditBox("HH", 0.5                       )   end,
  homeLabel           = function() return makeLabel("HH", 0.1                         )   end,
  honorific           = function() return makeDropdown("PX", 0.5, "honorifics"        )   end,
  honorificLabel      = function() return makeLabel("PX", 0.25                        )   end,
  honorificCustom     = function() return makeCustom("PX", 0.5                        )   end,
  honorificCustomLabel = function() return makeLabel("PX-custom", 0.25                 )   end,
  house               = function() return makeEditBox("NH", 0.5                       )   end,
  houseLabel          = function() return makeLabel("NH", 0.25                        )   end,
  motto               = function() return makeEditBox("MO", 0.5                       )   end,
  mottoLabel          = function() return makeLabel("MO", 0.1                         )   end,
  name                = function() return makeEditBoxWithColor("NA", "nameColor", 0.7 )   end,
  nameLabel           = function() return makeLabel("NA", 0.1                         )   end,
  nameColor           = function() return makeColorPicker("NA", "name"                )   end,
  nameColorLabel      = function() return makeLabel("Color", 0.1                      )   end,
  nickname            = function() return makeEditBox("NI", 0.5                       )   end,
  nicknameLabel       = function() return makeLabel("NI", 0.25                        )   end,
  oocInfo             = function() return makeMultiLine("CO", 3                       )   end,
  oocInfoLabel        = function() return makeLabel("CO", 0.25                        )   end,
  pronouns            = function() return makeDropdown("PN", 0.5, "pronouns"          )   end,
  pronounsLabel       = function() return makeLabel("PN", 0.1                         )   end,
  pronounsCustom      = function() return makeCustom("PN", 0.5                        )   end,
  pronounsCustomLabel = function() return makeLabel("PN-custom", 0.5                  )   end,
  race                = function() return makeEditBox("RA", 0.5                       )   end,
  raceLabel           = function() return makeLabel("RA", 0.1                         )   end,
  rpStatus            = function() return makeDropdown("FC", 0.5, "rpStatus"          )   end,
  rpStatusLabel       = function() return makeLabel("FC", 0.25                        )   end,
  rpStatusCustom      = function() return makeCustom("FC", 0.5                        )   end,
  rpStatusCustomLabel = function() return makeLabel("FC-custom", 0.25                 )   end,
  rpStyle             = function() return makeDropdown("FR", 0.5, "rpStyle"           )   end,
  rpStyleLabel        = function() return makeLabel("FR", 0.25                        )   end,
  rpStyleCustom       = function() return makeCustom("FR", 0.5                        )   end,
  rpStyleCustomLabel  = function() return makeLabel("FR-custom", 0.25                 )   end,
  title               = function() return makeEditBox("NT", 0.5                       )   end,
  titleLabel          = function() return makeLabel("NT", 0.25                        )   end,
  weight              = function() return makeEditBox("AW", 0.5                       )   end,
  weightLabel         = function() return makeLabel("AW", 0.1                         )   end,
};

Editor.groups =
{ 
  name = 
  { key = "name",
    fields = { "name", "nameColor", "nickname" },
    title = L["Group Name"],
  },
  social =
  { key = "social",
    fields = { "house", "title", }, 
    title = L["Group Social"],
  },
  status =
  { key = "status",
    fields = { "rpStatus", "rpStatusCustom", "rpStyle", "rpStyleCustom", "currently" },
    title = L["Group Status"],
  },
  basics = 
  { key = "basics",
    fields = { "race", "class", }, 
    title = L["Group Basics"],
  },
  appearance =
  { key = "appearance",
    fields = { "height", "weight", "eyes", "eyeColor", "desc", },
    title = L["Group Appearance"],
  },
  bio =
  { key = "bio",
    fields = { "age", "home", "birthPlace", },
    title = L["Group Bio"],
  },
};

Editor.groupOrder = { "name", "basics", "social", "status", "bio", "appearance" };

Editor.tabGroup = AceGUI:Create("TabGroup");
Editor.tabGroup:SetFullWidth(true);
Editor.tabGroup:SetTabs(Editor.groupOrder);
Editor.tabGroup:SelectTab(Editor.groupOrder[1]);

Editor:AddChild(tabGroup);

tabGroup:SetCallback("OnGroupSelected",
    function(container, event, group)
      container:ReleaseChildren();
      print("group is", group);
      local groupData = Editor.groups[group];
      Editor.currentGroup = group;
      Editor.currentFrames = {};
      local getFrame = {};
      for _, fieldName in ipairs(groupData.fields)
      do  local constructor = f[fieldName];
          local label_constructor = f[fieldName .. "Label"];
          local widget = constructor();
          local label = label_constructor();
          container:AddChild(label);
          container:AddChild(widget);
          Editor.currentFrames[frameName] = widget;
          local gf = widget.getFrame;
          if gf
          then local gfData = { frameName = frameName,
                                attr = gf[1],
                                target = gf[2], };
               table.insert(getFrame, gfData);
          end;
      end;

      for _, gfData in ipairs(getFrame)
      do  local frame = Editor:GetFrame(gfData.frameName);
          local targetFrame = Editor:GetFrame(gfData.target);
          frame[attr] = targetFrame;
      end;

      Editor:LoadIdentity();

    end);

local buttonBar = AceGUI:Create("InlineGroup");
buttonBar:SetTitle("");
Editor:AddChild(buttonBar);
Editor.buttons = {};

local b = Editor.buttons;

b.save = AceGUI:Create("Button");
b.save:SetText(L["Button Save"]);
b.save:SetRelativeWidth(0.25);
b.save:SetCallback("OnClick", 
    function() 
      Editor:SaveIdentity(); 
      Editor:ApplyPending();
      Editor:Hide(); 
    end);

b.cancel = AceGUI:Create("Button");
b.cancel:SetText(L["Button Cancel"]);
b.cancel:SetRelativeWidth(0.25);
b.cancel:SetCallback("OnClick", 
    function() 
      Editor:ClearPending();
      Editor:Hide() 
    end);

local POPUP = "RP_IDENTITY_CLEAR_AND_PRESENT_DANGER";

StaticPopupDialogs[POPUP] =
{ button1 = YES,
  button2 = NO,
  hideOnEscape = 1,
  timeout = 60,
  whileDead = 1,
  text = L[POPUP];
  OnCancel = doNothing,
  OnAccept =
    function(self)
      RP_Identity:ResetIdentity();
      Editor:ClearPending();
      Editor:LoadIdentity();
    end,
};

b.clear = AceGUI:Create("Button");
b.clear:SetText(L["Button Clear"]);
b.clear:SetRelativeWidth(0.5);
b.clear:SetCallback("OnClick", function() StaticPopup_Show(popup); end);

for _, button in ipairs({"save", "cancel", "clear"})
do  buttonBar:AddChild(b[button]);
end;

function Editor:LoadIdentity()
  if   self.currentGroup
  then for frameName, frame in pairs(self.currentFrames)
       do  frame:LoadIdentity();
  end;
end;

function Editor:SaveIdentity()
  if self.currentGroup
  then for frameName, frame in pairs(self.currentFrames)
       do frame:SaveIdentity();
       end;
  end;
end;

RP_Identity.Editor = Editor;

--[[
  Fields:

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
  MO = motto
  NA = name
  NH = house
  NI = nickname
  NT = title
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
  PE = at first glance
  IC = icon
  PS = personality traits
  LC = ...color?
--]]
  
local options =
  { type = "group",
    name = RP_Identity.addOnTitle,
    order = 1,
    args = 
    { config = 
      { type = "group",
        name = L["Config Options"],
        order = 1,
        inline = true,
        args =
        { showIcon = 
          { name = L["Config Show Icon"],
            order = 1,
            desc = L["Config Show Icon Tooltip"],
            get = function() return self.db.profile.config.showIcon end,
            set = function(info, value) 
                    RP_Identity.db.profile.config.showIcon = value;
                    RP_Identity:ShowIcon();
                  end,
            width = "full",
          },
        },
      },
      profiles = function() return LibStub("AceDBOptions-3.0"):GetOptionsTable(RP_Identity.db) end,
    },
  };

local defaults =
{ profile =
  { config =
    { showIcon = true, },
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
      GC = UnitClass("player"),
      GF = UnitFactionGroup("player") .. "",
      GR = UnitRace("player"),
      GS = UnitSex("player") .. "",
      GU = UnitGUID("player"),
      HB = "",
      HI = "",
      IC = RaceIcons[UnitSex("player")],
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
      TR = IsTrialAccount and "1" or "0",
      VA = RP_Identity.addOnTitle .. "/" .. RP_Identity.addOnVersion,
      VP = "1",
    },
  },
};

-- :UpdateIdentity() reads the current config profile and sets msp.my accordingly
function RP_Identity:UpdateIdentity()
  for field, value in pairs(self.db.profile.myMSP)
  do  msp.my[field] = value;
  end;
  if Editor:IsShown() then Editor:LoadIdentity() end;
  msp:Update();
end;

local RP_IdentityLDB = LibStub("LibDataBroker-1.1"):NewDataObject(RP_Identity.addOnTitle,
    { type = "data source",
      text = RP_Identity.addOnTitle,
      icon = "Interface\\ICONS\\Ability_Racial_Masquerade",
      OnClick = function() RP_Identity:ToggleFrame() end,
    });

local icon = LibStub("LibDBIcon-1.0");

function RP_Identity:OnInitialize()
  self.db = LibStub("AceDB-3.0"):New("RP_IdentityDB", defaults);
  self.db.RegisterCallback(self, "OnProfileChanged", "UpdateIdentity");
  self.db.RegisterCallback(self, "OnProfileCopied",  "UpdateIdentity");
  self.db.RegisterCallback(self, "OnProfileReset",   "UpdateIdentity");


  LibStub("AceConfig-3.0"):RegisterOptionsTable(self.addOnName, options);
  LibStub("AceConfigDialog-3.0"):AddToBlizOptions(
    self.addOnName,
    self.addOnTitle,
    options);
  icon:Register(self.addOnTitle, RP_IdentityLDB, self.db.profile.config.ShowIcon);

end;

function RP_Identity:ShowIcon()
  if self.db.profile.config.showIcon then icon:Show() else icon:Hide(); end;
end;

function RP_Identity:ToggleFrame()
  if   self.Editor:IsShown() then self.Editor:Hide()
  else self.Editor:LoadIdentity(); self.Editor:Show()
  end;
end;

function RP_Identity:ToggleMinimapIcon()
  self.db.profile.config.showIcon = not self.db.profile.config.showIcon;
  self:ShowIcon();
end;

function RP_Identity:OnLoad()
  self:UpdateIdentity();
  self:ShowIcon();
end;

function RP_Identity:GetMSP(fieldName)
  return fieldName and self.db.profile.myMSP[fieldName] or nil
end;

function RP_Identity:SetMSP(fieldName, value)
  if fieldName 
  then self.db.profile.myMSP[fieldName] = value;
  end;
end;

function RP_Identity:EditIdentity()
  self.Editor:LoadIdentity();
  self.Editor:Show();
end;

function RP_Identity:ResetIdentity()
  for field, value in pairs(defaults.profile.myMSP)
  do  self:SetMSP(field, value);
  end;
  self:UpdateIdentity();
  if self.Editor:IsShown() then self.Editor:LoadIdentity() end;
end;

