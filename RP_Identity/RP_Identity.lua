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

local RP_Identity = LibStub("AceAddon-3.0"):NewAddon( addOnName
                      -- , "AceEvent-3.0", "AceLocale-3.0", "AceTimer-3.0"
                      );

RP_Identity.addOnName    = addOnName;
RP_Identity.addOnTitle   = GetAddOnMetadata(addOnName, "Title");
RP_Identity.addOnVersion = GetAddOnMetadata(addOnName, "Version");

function RP_Identity:OnInitialize()
            
      self.defaults =
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
                        IC = raceIcons[UnitSex("player")],
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

      self.db = LibStub("AceDB-3.0"):New("RP_IdentityDB", self.defaults);

      -- :UpdateIdentity() reads the current config profile and sets msp.my accordingly
      function self:UpdateIdentity()
            for  field, value in pairs(self.db.profile.myMSP) do msp.my[field] = value; end;
            if   self.Editor
            then self.Editor:ClearPending();
                 if self.Editor:IsShown() then self.Editor:ReloadTab(); end;
            end;
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
           { config       =
             { type       = "group",
               name       = L["Config Options"],
               order      = 1,
               inline     = true,
               args       =
               { showIcon =
                 { name   = L["Config Show Icon"],
                   order  = 1,
                   desc   = L["Config Show Icon Tooltip"],
                   get    = function() return self.db.profile.config.showIcon end,
                   set    = function(info, value) RP_Identity.db.profile.config.showIcon = value; RP_Identity:ShowIcon(); end,
                   width  = "full",
                 },
               },
             },
             profiles     = function() return LibStub("AceDBOptions-3.0"):GetOptionsTable(RP_Identity.db) end,
           },
         };

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

function RP_Identity:OnLoad() 

      -- db

      function self:GetMSP(fieldName) return fieldName and self.db.profile.myMSP[fieldName] or nil end;
      
      function self:SetMSP(fieldName, value)
            if fieldName 
            then self.db.profile.myMSP[fieldName] = value;
            end;
      end;
      
      function self:ResetIdentity()
        for field, value in pairs(self.defaults.profile.myMSP) do self:SetMSP(field, value); end;
        self:UpdateIdentity();
      end; 

      -- data broker
      --
      local myDataBroker = 
              LibStub("LibDataBroker-1.1"):NewDataObject(
                  RP_Identity.addOnTitle,
                  { type    = "data source",
                    text    = RP_Identity.addOnTitle,
                    icon    = "Interface\\ICONS\\Ability_Racial_Masquerade",
                    OnClick = function() RP_Identity:ToggleEditorFrame() end,
                  }
              );
      self.icon = LibStub("LibDBIcon-1.0");

      self.icon:Register(self.addOnTitle, myDataBroker, self.db.profile.config.ShowIcon);

      function self:ShowIcon() return self.db.config.showIcon and self.icon:Show() or self.icon:Hide() end; end;

      function self:ToggleMinimapIcon()
            self.db.profile.config.showIcon = not self.db.profile.config.showIcon;
            self:ShowIcon();
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
              [ ""                      ] = L["Undefined"         ],
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
              [""  ] = L["None"            ],
            },

        PXOrder = { "", },

        IC =
            { ["-1"] = L["Custom Icon"],
              [""  ] = L["Undefined"  ],
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
      Editor.frame:SetMinResize(350, 300);
      Editor.content:ClearAllPoints();
      Editor.content:SetPoint("BOTTOMLEFT", Editor.frame, "BOTTOMLEFT",  20,  50);
      Editor.content:SetPoint("TOPRIGHT",   Editor.frame, "TOPRIGHT",   -20, -50);
      Editor:SetTitle(self.addOnTitle);
      Editor:SetLayout("Flow");
      Editor:Hide();
      Editor.pending = {};
      
      local EditorFrameName = "RP_Identity_Editor_Frame";
      _G[EditorFrameName]   = Editor.frame;
      tinsert(UISpecialFrames, EditorFrameName);
      self.Editor = Editor;

      function self:ToggleEditorFrame() 
            if   self.Editor:IsShown() 
            then self.Editor:Hide()
            else self.Editor:ReloadTab(); self.Editor:Show()
            end;
      end;

      function self:EditIdentity() self.Editor:ReloadTab(); self.Editor:Show(); end;

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
        OnAccept     = function(self) RP_Identity:ResetIdentity(); Editor:ClearPending(); end,
      };

      -- editor config 
      --
      Editor.groups =
      { 
        name = 
            { fields = { "honorific", "name", "nickname" },
              title  = L["Group Name"],
            },

        social =
            { fields = { "title", "house", "motto", }, 
              title  = L["Group Social"],
            },

        status =
            { fields = { "rpStatus", "rpStyle", "currently", "oocInfo" },
              title  = L["Group Status"],
            },

        basics = 
            { fields = { "race", "class", "pronouns", }, 
              title  = L["Group Basics"],
            },

        appearance =
            { fields = { "height", "weight", "eyes", "desc", },
              title  = L["Group Appearance"],
            },

        bio =
            { fields = { "age", "birthPlace", "home", "history" },
              title  = L["Group Bio"],
            },
      };
      
      local groupOrder = { "name", "basics", "social", "status", "bio", "appearance" };

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
            self:SetTitle(RP_Identity.addOnTitle .. L["(not saved)"]);
      end;
      function Editor:ClearPending() self.pending = {} self:SetTitle(RP_Identity.addOnTitle); end;
      function Editor:ApplyPending() 
            for field, value in pairs(self.pending) do RP_Identity:SetMSP(field, value); end;
            self:ClearPending();
      end;

      
      local function makeLabel(msp, width)
            local w = AceGUI:Create("Label");
            w.MSP = msp;
            w:SetText(L["Label " .. msp] .. "   ");
            w:SetRelativeWidth(width)
            w:SetJustifyH("RIGHT");
            return w;
      end;
      
      local function makeEditBox(msp, width, labelWidth)
            local label = makeLabel(msp, labelWidth);
            local main = AceGUI:Create("EditBox");
            main:SetRelativeWidth(width);
            main.MSP = msp;
            main:SetText(Editor:GetMSP(msp));
            main:SetCallback("OnEnterPressed", function(self, event, text) Editor:SetMSP(self.MSP, text); end);
            return { label, main };
      end;
      
      local function makeDropdown(msp, width, labelW, customW, customLW)
            local label       = makeLabel(msp,                labelW);
            local customLabel = makeLabel(msp .. "-custom", customLW);
      
            local custom = AceGUI:Create("EditBox");
            custom:SetRelativeWidth(customW)
            custom.MSP = msp;
            custom:SetCallback("OnEnterPressed", 
                  function(self, event, text) 
                        Editor:SetMSP(self.MSP, text) 
                  end);
            
            local main = AceGUI:Create("Dropdown");
            main:SetRelativeWidth(width);
            main.MSP = msp;
      
            main.custom = custom;
      
            local myMenu = menu[msp];
      
            local initialValue = Editor:GetMSP(msp);
      
            if myMenu[initialValue]
            then main:SetValue(initialValue); custom:SetDisabled(true);
            else main:SetValue("-1"); custom:SetDisabled(false); custom:SetValue(initialValue);
            end;
      
            main:SetList(myMenu, menu[msp .. "Order"]);
      
            main:SetCallback("OnValueChanged", 
                        function(self, event, key)
                                 if key == "-1"
                                 then self.custom:SetDisabled("false");
                                                Editor:SetMSP(self.MSP, self.custom:GetValue());
                                 else self.custom:SetDisabled("true");
                                                Editor:SetMSP(self.MSP, key);
                                 end;
                        end);
            return { label, main, customLabel, custom };
      end;
      
      local function makeMultiLine(msp, lines)
            local main = AceGUI:Create("MultiLineEditBox");
            main:SetLabel(L["Label " .. msp]);
            main:SetFullWidth(true);
            main.MSP = msp;
            main:SetText( Editor:GetMSP(msp) );
            main:SetCallback("OnEnterPressed", function(self, event, text) Editor:SetMSP(self.MSP, text); end);
            return { main };
      end;
      
      local function makeColorfulEditBox(msp, width, labelWidth)
            local ADDFMT = "|cff%02x%02x%02x%s|r";
            local EXTRFMT = "^|cff(%x%x)(%x%x)(%x%x)(.+)|r$";
            local function addColor(r, g, b, name) return string.format(COLORFMT, r * 255, g * 255, b * 255, name) end;
      
            local function extractColor(str)
                  local r, g, b, name = str:match(EXTRFMT)
                  return r and tonumber(r, 16) / 255 or nil, 
                                       g and tonumber(g, 16) / 255 or nil, 
                                       b and tonumber(b, 16) / 255 or nil,
                                       name or str
            end;
      
            local label = makeLabel(msp, labelWidth);
      
            local main = AceGUI:Create("EditBox");
            main:SetRelativeWidth(width); 
            main.MSP = msp;
      
            local picker = AceGUI:Create("ColorPicker");
            picker.MSP = msp;
            picker:SetHasAlpha(false);
            picker:SetRelativeWidth(0.1);
            picker.main = main;
      
            picker:SetCallback("OnValueConfirmed",
                  function(self, event, r, g, b, a)
                        Editor:SetMSP(self.MSP, addColor(r, g, b, self.main:GetText() ));
                        self.r, self.g, self.b = r, g, b;
                  end);
                        
            main.picker = picker;
      
            local initialValue = Editor:GetMSP(self.MSP);
            local r, g, b, name = extractColor(initialValue);
            picker:SetColor(r or 1, g or 1, b or 1, 1);
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
            --                             makeEditBox(msp, width, labelWidth)
            age        = function() return makeEditBox("AG", 0.5, 0.1             ) end,
            birthPlace = function() return makeEditBox("HB", 0.5, 0.25            ) end,
            class      = function() return makeEditBox("RC", 0.5, 0.25            ) end,
            height     = function() return makeEditBox("AH", 0.5, 0.1             ) end,
            home       = function() return makeEditBox("HH", 0.5, 0.1             ) end,
            house      = function() return makeEditBox("NH", 0.5, 0.1             ) end,
            motto      = function() return makeEditBox("MO", 0.5, 0.1             ) end,
            title      = function() return makeEditBox("NT", 0.5, 0.1             ) end,
            nickname   = function() return makeEditBox("NI", 0.5, 0.1             ) end,
            race       = function() return makeEditBox("RA", 0.5, 0.1             ) end,
            weight     = function() return makeEditBox("AW", 0.5, 0.1             ) end,
            --                             makeMultiLine(msp, lines);
            currently  = function() return makeMultiLine("CU", 3                  ) end,
            desc       = function() return makeMultiLine("DE", 3                  ) end,
            history    = function() return makeMultiLine("HI", 3                  ) end,
            oocInfo    = function() return makeMultiLine("CO", 3                  ) end,
            --                             makeColorfulEditBox(msp, width, labelWidth)
            eyes       = function() return makeColorfulEditBox("AE", 0.5, 0.1     ) end,
            name       = function() return makeColorfulEditBox("NA", 0.7, 0.1     ) end,
            --                             makeDropdown(msp, width, labelW, customW, customLW);
            pronouns   = function() return makeDropdown("PN", 0.5, 0.1, 0.5, 0.2  ) end,
            honorific  = function() return makeDropdown("PX", 0.5, 0.1, 0.5, 0.2  ) end,
            rpStatus   = function() return makeDropdown("FC", 0.5, 0.2, 0.5, 0.2  ) end,
            rpStyle    = function() return makeDropdown("FR", 0.5, 0.2, 0.5, 0.2  ) end,
      
      };

      Editor.tabGroup = AceGUI:Create("TabGroup");
      Editor.tabGroup:SetFullWidth(true);
      Editor.tabGroup:SetFullHeight(true);
      Editor.tabGroup:SetLayout("Flow");
      Editor.tabGroup:SetTabs(tabList);
      Editor.tabGroup.Editor = Editor;
      Editor:AddChild(Editor.tabGroup);

      function tabGroup:LoadTab(tab)
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
        self:ApplyPending();
        self.tabGroup:LoadTab(self.currentGroup or groupOrder[1]);
      end;

      Editor.tabGroup:SelectTab(groupOrder[1]);
      
      -- editor buttons
      --
      local saveButton   = AceGUI:Create("Button");
      local clearButton  = AceGUI:Create("Button");
      local cancelButton = AceGUI:Create("Button");
      
      Editor:AddChild(saveButton  );
      Editor:AddChild(clearButton );
      Editor:AddChild(cancelButton);
      
      saveButton:ClearAllPoints();
      clearButton:ClearAllPoints();
      cancelButton:ClearAllPoints();
      
      saveButton:SetWidth(  100);
      clearButton:SetWidth( 100);
      cancelButton:SetWidth(100);
      
      saveButton:SetPoint(  "BOTTOMRIGHT", Editor.frame, "BOTTOMRIGHT", -220, 20);
      clearButton:SetPoint( "BOTTOMRIGHT", Editor.frame, "BOTTOMRIGHT", -120, 20);
      cancelButton:SetPoint("BOTTOMRIGHT", Editor.frame, "BOTTOMRIGHT",  -20, 20);
      
      saveButton:SetCallback("OnClick", 
        function(self, event, button) 
          Editor:ApplyPending(); 
          Editor:Hide(); 
        end);

      clearButton:SetCallback( "OnClick",
        function(self, event, button) 
          StaticPopup_Show(POPUP); 
        end);

      cancelButton:SetCallback("OnClick", 
        function(self, event, button) 
          Editor:ClearPending(); 
          Editor:Hide() 
        end);
      
      saveButton:SetText(   L["Button Save"  ]);
      clearButton:SetText(  L["Button Clear" ]);
      cancelButton:SetText( L["Button Cancel"]);

end;

