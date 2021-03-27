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
 
local addOnName, ns = ...;

local L = LibStub("AceLocale-3.0"):GetLocale(addOnName);
local AceGUI = LibStub("AceGUI-3.0");

local RP_Identity = LibStub("AceAddon-3.0"):NewAddon( addOnName, "AceConsole-3.0"
                     
                      -- , "AceEvent-3.0", "AceLocale-3.0", "AceTimer-3.0"
                      );

local maskIcon = "Interface\\ICONS\\Ability_Racial_Masquerade";

RP_Identity.addOnName    = addOnName;
RP_Identity.addOnTitle   = GetAddOnMetadata(addOnName, "Title");
RP_Identity.addOnVersion = GetAddOnMetadata(addOnName, "Version");
RP_Identity.addOnIcon    = maskIcon;
RP_Identity.addOnColor   = { 51 / 255, 1, 85 / 255, 1 };

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
                        GC = UnitClass("player"),
                        GF = UnitFactionGroup("player") .. "",
                        GR = UnitRace("player"),
                        GS = UnitSex("player") .. "",
                        GU = UnitGUID("player"),
                        HB = "",
                        HI = "",
                        IC = maskIcon,
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
                        TR = IsTrialAccount() and "1" or "0",
                        VA = RP_Identity.addOnTitle .. "/" .. RP_Identity.addOnVersion,
                        VP = "1",
                  },
            },
      };

function RP_Identity:OnInitialize()
            
      self.db = LibStub("AceDB-3.0"):New("RP_IdentityDB", myDefaults);

      function self:UpdateIdentity()
            for  field, value in pairs(self.db.profile.myMSP) do msp.my[field] = value; end;
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
             config       =
             { type       = "group",
               name       = L["Config Options"],
               order      = 1,
               inline     = true,
               args       =
               { showIcon =
                 { name   = L["Config Show Icon"],
                   type   = "toggle",
                   order  = 1,
                   desc   = L["Config Show Icon Tooltip"],
                   get    = function() return self.db.profile.config.showIcon end,
                   set    = "ToggleMinimapIcon",
                   width  = "full",
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

      -- db

      function RP_Identity:GetMSP(fieldName) return self.db.profile.myMSP[fieldName] or nil  end;
      function RP_Identity:SetMSP(fieldName, value) self.db.profile.myMSP[fieldName] = value end;
      
      function RP_Identity:ResetIdentity()
        for field, value in pairs(myDefaults.profile.myMSP) do self:SetMSP(field, value); end;
        self:UpdateIdentity();
      end; 

      -- menu data
      --
      local menu =
      { FR =
            { ["-1"] = L["Custom Style"],
              ["0" ] = L["Undefined"   ],
              ["1" ] = L["Normal"      ],
              ["2" ] = L["Casual"      ],
              ["3" ] = L["Full-Time"   ],
              ["4" ] = L["Beginner"    ],
            },

        FROrder = { "0", "2", "1", "3", "4", "-1" },

        FC =
            { ["-1"] = L["Custom Status"      ],
              ["0" ] = L["Undefined"          ],
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
              [ L["Pronouns They/Them"] ] = L["Pronouns They/Them"],
              [ L["Pronouns It/Its"   ] ] = L["Pronouns It/Its"   ],
        },

        PNOrder = 
            { "", 
              L["Pronouns She/Her"], 
              L["Pronouns He/Him"], 
              L["Pronouns They/Them"], 
              L["Pronouns It/Its"] 
        },

        PX =
            { ["-1"] = L["Custom Honorific"],
              [""  ] = L["No Honorific"    ],
            },

        PXOrder = { "", },

        IC =
            { ["-1"    ] = L["Custom Icon"],
              [""      ] = L["Undefined"  ],
              [maskIcon] = L["rpIdentity Icon"],
            },

        ICOrder = { "" },

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
            [1] = ICONS.."achievement_character_bloodelf_female",
            [2] = ICONS.."achievement_character_bloodelf_male",
            [3] = ICONS.."achievement_character_bloodelf_female",
          },

          ["DarkIronDwarf"] = { 
            [1] = ICONS.."ability_racial_foregedinflames",
            [2] = ICONS.."ability_racial_fireblood",
            [3] = ICONS.."ability_racial_foregedinflames",
          },

          ["Draenei"] = {
            [1] = ICONS.."achievement_character_draenei_female",
            [2] = ICONS.."achievement_character_draenei_male",
            [3] = ICONS.."achievement_character_draenei_female",
          },

          ["Dwarf"] = {
          [1] = ICONS.."achievement_character_dwarf_female",
            [2] = ICONS.."achievement_character_dwarf_male",
            [3] = ICONS.."achievement_character_dwarf_female",
          },

          ["Gnome"] = {
            [1] = ICONS.."achievement_character_gnome_female",
            [2] = ICONS.."achievement_character_gnome_male",
            [3] = ICONS.."achievement_character_gnome_female",
          },

          ["Goblin"] = {
            [1] = ICONS.."ability_racial_rocketjump",
            [2] = ICONS.."ability_racial_rocketjump",
            [3] = ICONS.."ability_racial_rocketjump",
          },

          ["HighmountainTauren"] = {
            [1] = ICONS.."achievement_alliedrace_highmountaintauren",
            [2] = ICONS.."ability_racial_bullrush",
            [3] = ICONS.."achievement_alliedrace_highmountaintauren",
          },

          ["Human"] = {
            [1] = ICONS.."achievement_character_human_female",
            [2] = ICONS.."achievement_character_human_male",
            [3] = ICONS.."achievement_character_human_female",
          },

          ["KulTiran"] = {
            [1] = ICONS.."ability_racial_childofthesea",
            [2] = ICONS.."achievement_boss_zuldazar_manceroy_mestrah",
            [3] = ICONS.."ability_racial_childofthesea",
          },

          ["LightforgedDraenei"] = {
            [1] = ICONS.."achievement_alliedrace_lightforgeddraenei",
            [2] = ICONS.."ability_racial_finalverdict",
            [3] = ICONS.."achievement_alliedrace_lightforgeddraenei",
          },

          ["MagharOrc"] = {
            [1] = ICONS.."achievement_character_orc_female_brn",
            [2] = ICONS.."achievement_character_orc_male_brn",
            [3] = ICONS.."achievement_character_orc_female_brn",
          },

          ["Mechagnome"] = {
            [1] = ICONS.."inv_plate_mechagnome_c_01helm",
            [2] = ICONS.."ability_racial_hyperorganiclightoriginator",
            [3] = ICONS.."inv_plate_mechagnome_c_01helm",
          },

          ["NightElf"] = {
            [1] = ICONS.."achievement_character_nightelf_female",
            [2] = ICONS.."achievement_character_nightelf_male",
            [3] = ICONS.."achievement_character_nightelf_female",
          },

          ["Nightborne"] = {
            [1] = ICONS.."ability_racial_masquerade",
            [2] = ICONS.."ability_racial_dispelillusions",
            [3] = ICONS.."ability_racial_masquerade",
          },

          ["Orc"] = {
            [1] = ICONS.."achievement_character_orc_female",
            [2] = ICONS.."achievement_character_orc_male",
            [3] = ICONS.."achievement_character_orc_female",
          },

          ["Pandaren"] = {
            [1] = ICONS.."achievement_character_pandaren_female",
            [2] = ICONS.."achievement_guild_classypanda",
            [3] = ICONS.."achievement_character_pandaren_female",
          },

          ["Scourge"] = {
            [1] = ICONS.."achievement_character_undead_female",
            [2] = ICONS.."achievement_character_undead_male",
            [3] = ICONS.."achievement_character_undead_female",
          },

          ["Tauren"] = {
            [1] = ICONS.."achievement_character_tauren_female",
            [2] = ICONS.."achievement_character_tauren_male",
            [3] = ICONS.."achievement_character_tauren_female",
          },

          ["Troll"] = {
            [1] = ICONS.."achievement_character_troll_female",
            [2] = ICONS.."achievement_character_troll_male",
            [3] = ICONS.."achievement_character_troll_female",
          },

          ["VoidElf"] = {
            [1] = ICONS.."ability_racial_preturnaturalcalm",
            [2] = ICONS.."ability_racial_entropicembrace",
            [3] = ICONS.."ability_racial_preturnaturalcalm",
          },

          ["Vulpera"] = {
            [1] = ICONS.."ability_racial_nosefortrouble",
            [2] = ICONS.."ability_racial_nosefortrouble",
            [3] = ICONS.."ability_racial_nosefortrouble",
          },

          ["Worgen"] = {
            [1] = ICONS.."ability_racial_viciousness",
            [2] = ICONS.."achievement_worganhead",
            [3] = ICONS.."ability_racial_viciousness",
          },

          ["ZandalariTroll"] = {
            [1] = ICONS.."inv_zandalarifemalehead",
            [2] = ICONS.."inv_zandalarimalehead",
            [3] = ICONS.."inv_zandalarifemalehead",
          },
          
        }, -- race
  
      class =
        { 
          ["WARRIOR"     ] = ICONS.."ClassIcon_Warrior",
          ["PALADIN"     ] = ICONS.."ClassIcon_Paladin",
          ["HUNTER"      ] = ICONS.."ClassIcon_Hunter",
          ["ROGUE"       ] = ICONS.."ClassIcon_Rogue",
          ["PRIEST"      ] = ICONS.."ClassIcon_Priest",
          ["DEATHKNIGHT" ] = ICONS.."ClassIcon_DeathKnight",
          ["SHAMAN"      ] = ICONS.."ClassIcon_Shaman",
          ["MAGE"        ] = ICONS.."ClassIcon_Mage",
          ["WARLOCK"     ] = ICONS.."ClassIcon_Warlock",
          ["MONK"        ] = ICONS.."ClassIcon_Monk",
          ["DRUID"       ] = ICONS.."ClassIcon_Druid",
          ["DEMONHUNTER" ] = ICONS.."ClassIcon_DemonHunter",
        }, -- class
      };
      
      -- iconDB
      --
      local localizedRace,  playerRace  = UnitRace("player");
      local localizedClass, playerClass = UnitClass("player");

      local raceIcons = iconDB.race[playerRace];
      local classIcon = iconDB.class[playerClass];
      
      menu.IC[raceIcons[1]] = localizedRace .. L["Gender (Neutral)"];
      menu.IC[raceIcons[2]] = localizedRace .. L["Gender (Male)"];
      menu.IC[raceIcons[3]] = localizedRace .. L["Gender (Female)"];
      menu.IC[classIcon] = localizedClass;

      table.insert(menu.ICOrder, raceIcons[1]);
      table.insert(menu.ICOrder, raceIcons[3]);
      table.insert(menu.ICOrder, raceIcons[2]);
      table.insert(menu.ICOrder, classIcon);
      
      --     
      -- editor
      --
      --
      local Editor = AceGUI:Create("Window");
      
      Editor:SetWidth( 600);
      Editor:SetHeight(400);
      Editor.frame:SetMinResize(395, 320);
      local maxW, maxH = UIParent:GetSize();
      Editor.frame:SetMaxResize( maxW * 2/3, maxH * 2/3);
      Editor.content:ClearAllPoints();
      Editor.content:SetPoint("BOTTOMLEFT", Editor.frame, "BOTTOMLEFT",  20,  50);
      Editor.content:SetPoint("TOPRIGHT",   Editor.frame, "TOPRIGHT",   -20, -35);
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
      local groupOrder = { "basics", "appearance", "bio", "status", };

      Editor.groups =
      { 
        basics = 
            { fields = { "name", 
                         "title", 
                         "race", 
                         "class", 
                         "honorific", "pronouns", 
                         "nickname", 
                         "house",
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
      };
      
      -- initialization
      --
      local tabList = {};
      for _, groupName in ipairs(groupOrder)
      do  local groupData = Editor.groups[groupName];
          table.insert(tabList, { value = groupName, text = groupData.title });
      end;
      
      -- pending changes
      --
      function Editor:GetMSP(msp) return self.pending[msp] and self.pending[msp] or RP_Identity:GetMSP(msp); end; 
      function Editor:SetMSP(msp, value) 
            self.pending[msp] = value; 
            self:SetTitle(RP_Identity.addOnTitle .. " - " .. RP_Identity.db:GetCurrentProfile() .. L["(not saved)"]);
      end;

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
      
      local function fixEditBox(widget)
        local sides = { "Left", "Right", "Middle" };
        local function hide() 
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
            custom:SetCallback("OnEnterPressed", function(self, event, text) Editor:SetMSP(self.MSP, text) end);
            
            local main = AceGUI:Create("Dropdown");
            main:SetRelativeWidth(width > 0 and width or 0.1);
            main.MSP = msp;
      
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
                                      custom:SetText("");
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
            if not width then main:SetFullWidth(true);
                         else main:SetRelativeWidth(width)
            end;
            main.MSP = msp;
            main:SetText( Editor:GetMSP(msp) );
            main:SetCallback("OnEnterPressed", function(self, event, text) Editor:SetMSP(self.MSP, text); end);
            return { main };
      end;
      
      local function makeColorfulEditBox(msp, width, labelWidth)
            local ADDFMT = "|cff%02x%02x%02x%s|r";
            local EXTRFMT = "^|cff(%x%x)(%x%x)(%x%x)(.+)|r$";

            local function addColor(r, g, b, name) 
              if r then return string.format(ADDFMT, r * 255, g * 255, b  * 255, name) 
              else return name;
              end;
            end;
      
            local function extractColor(str)
                  local r, g, b, name = str:match(EXTRFMT)
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
      
            local picker = AceGUI:Create("ColorPicker");
            picker.MSP = msp;
            picker:SetHasAlpha(false);
            picker:SetRelativeWidth(0.1);
            picker.main = main;
      
            picker:SetCallback("OnValueConfirmed",
                  function(self, event, r, g, b, a)
                        print("r, g, b", r, g, b);
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
      
      local frameConstructor = 
      { 
            --  makeEditBox(msp, width, labelWidth)
            --  makeDropdown(msp, width, labelW, customW)
            --  makeColorfulEditBox(msp, width, labelWidth)
            --  makeMultiLine(msp, lines)
            name       = function() return makeColorfulEditBox("NA", 0.75, 0.15     ) end,

            race       = function() return makeEditBox("RA", 0.85, 0.15            ) end,
            class      = function() return makeEditBox("RC", 0.85, 0.15            ) end,

            title      = function() return makeEditBox("NT", 0.85, 0.15            ) end,
            house      = function() return makeEditBox("NH", 0.35, 0.15             ) end,

            nickname   = function() return makeEditBox("NI", 0.35, 0.15             ) end,

            pronouns   = function() return makeDropdown("PN", 0.25, 0, 0.25       ) end,
            honorific  = function() return makeDropdown("PX", 0.25, 0, 0.20       ) end,

            motto      = function() return makeEditBox("MO", 0.85, 0.15             ) end,


            rpStatus   = function() return makeDropdown("FC", 0.25, 0, 0.25       ) end,
            rpStyle    = function() return makeDropdown("FR", 0.25, 0, 0.25       ) end,
            currently  = function() return makeMultiLine("CU", 12, 0.5             ) end,
            oocInfo    = function() return makeMultiLine("CO", 12, 0.5             ) end,

            eyes       = function() return makeColorfulEditBox("AE", 0.75, 0.15     ) end,
            height     = function() return makeEditBox("AH", 0.75, 0.15             ) end,
            weight     = function() return makeEditBox("AW", 0.75, 0.15            ) end,
            desc       = function() return makeMultiLine("DE", 12                 ) end,

            age        = function() return makeEditBox("AG", 0.85, 0.15             ) end,
            birthPlace = function() return makeEditBox("HB", 0.85, 0.15            ) end,
            home       = function() return makeEditBox("HH", 0.85, 0.15             ) end,
            history    = function() return makeMultiLine("HI", 12                  ) end,
      
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

local function openOptions()
    InterfaceOptionsFrame:Show();
    InterfaceOptionsFrame_OpenToCategory(RP_Identity.addOnTitle)
    RP_Identity.Editor:Hide();
end;
      -- editor buttons
      --
      local buttonSize = 85;

      local resetButton  = CreateFrame("Button", nil, Editor.frame, "UIPanelButtonTemplate");
      resetButton:SetText(L["Button Clear"]);
      resetButton:ClearAllPoints();
      resetButton:SetPoint("BOTTOMRIGHT", Editor.frame, "BOTTOMRIGHT", -20 - buttonSize * 1 - 5 * 1, 20);
      resetButton:SetWidth(buttonSize);
      resetButton:SetScript("OnClick", function(self) StaticPopup_Show(POPUP_CLEAR); end);

      local cancelButton  = CreateFrame("Button", nil, Editor.frame, "UIPanelButtonTemplate");
      cancelButton:SetText( L["Button Cancel"]);
      cancelButton:ClearAllPoints();
      cancelButton:SetPoint("BOTTOMRIGHT", Editor.frame, "BOTTOMRIGHT",  -20, 20);
      cancelButton:SetWidth(buttonSize);
      cancelButton:SetScript("OnClick", function(self) Editor:ClearPending(); Editor:Hide() end);

      local saveButton  = CreateFrame("Button", nil, Editor.frame, "UIPanelButtonTemplate");
      saveButton:SetText(L["Button Save"]);
      saveButton:ClearAllPoints();
      saveButton:SetPoint("BOTTOMRIGHT", Editor.frame, "BOTTOMRIGHT", -20 - buttonSize * 2 - 5 * 2, 20);
      saveButton:SetWidth(buttonSize);
      saveButton:SetScript("OnClick", function(self) Editor:ApplyPending(); Editor:Hide(); end);

      local configButton = CreateFrame("Button", nil, Editor.frame, "UIPanelButtonTemplate");
      configButton:SetText(L["Button Config"]);
      configButton:ClearAllPoints();
      configButton:SetPoint("BOTTOMLEFT", Editor.frame, "BOTTOMLEFT", 20, 20);
      configButton:SetWidth(buttonSize);
      configButton:SetScript("OnClick", openOptions);

local function notify(...)
  print("[" .. RP_Identity.addOnTitle .. "]", ...)
end;

_G["SLASH_RP_IDENTITY1"] = "/rpid";
SlashCmdList["RP_IDENTITY"] = 
  function(a)
    if a == "" or a:match("help")
    then notify("Hey, you found the help command.");
    elseif a:match("option") or a:match("config") or a:match("setting") or a:match("profile")
    then openOptions();
    elseif a:match("toggle")
    then RP_Identity:ToggleEditorFrame();
    elseif a:match("open")
    then RP_Identity.Editor:ReloadTab();
         RP_Identity.Editor.frame:Show();
    end;
  end;
    
