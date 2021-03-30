local addOnName, ns = ...;
local L = LibStub("AceLocale-3.0"):NewLocale(addOnName, "enUS", true);

local addOnTitle = GetAddOnMetadata(addOnName, "Title");
local addOnVersion = GetAddOnMetadata(addOnName, "Version");
local addOnDate = GetAddOnMetadata(addOnName, "X-VersionDate");
  
local SLASH                = "|cff00ffff/rpid|r ";
local POPUP_CLEAR          = "RP_IDENTITY_CLEAR_AND_PRESENT_DANGER";
local TOOLTIP_ICON         = "Select a pre-defined icon, or set a custom icon.";
local TOOLTIP_ICON_CUSTOM  = "Enter filename of an icon in the |cff00ffffInterface\\\\ICONS\\\\|r directory.";
local TOOLTIP_ICON_ICON    = "Icon preview";
local TOOLTIP_GLANCE       = "Detail";
local TOOLTIP_GLANCE_TITLE = "Set the name of the detail.";
local TOOLTIP_GLANCE_TEXT  = "Set the text of the detail.";
local LABEL_GLANCE_TITLE   = "Detail Name";
local LABEL_GLANCE_TEXT    = "Detail Description";
local LABEL_GLANCE_ICON    = "Icon";
local LABEL_CUSTOM_ICON    = "Custom Icon";

L["(not saved)"                          ] = " (not saved)";
L["Beginner"                             ] = "Status: Beginner";
L["Button Cancel Tooltip"                ] = "Exit the profile editor without saving.";
L["Button Cancel"                        ] = "Cancel";
L["Button Clear Tooltip"                 ] = "Reset your profile to its original values. |cffff0000Warning:|r This can't be undone.";
L["Button Clear"                         ] = "Reset";
L["Button Close Tooltip"                 ] = "Close the profile editor.";
L["Button Close"                         ] = "Close";
L["Button Config Tooltip"                ] = "Save your character and open the " .. addOnTitle .. " configuration options.";
L["Button Config"                        ] = "Options";
L["Button Save Tooltip"                  ] = "Save your character and exit the profile editor.";
L["Button Save"                          ] = "Save";
L["Casual"                               ] = "RP Style: Casual";
L["Config Auto Save Tooltip"             ] = "Check to automatically save your profile whenever you make a change.";
L["Config Auto Save"                     ] = "Auto Save";
L["Config Auto-Request Profiles Tooltip" ] = "Check to automatically request someone's profile when they request yours.";
L["Config Auto-Request Profiles"         ] = "Auto-Request Profiles";
L["Config Editor Tooltips Tooltip"       ] = "Uncheck to hide the tooltips in the profile editor.";
L["Config Editor Tooltips"               ] = "Editor Tooltips";
L["Config Focus Request Tooltip"         ] = "Check to automatically request someone's profile when you set them as your focus target.";
L["Config Focus Request"                 ] = "Request Focus Target's Profile";
L["Config Hear Someone Request Tooltip"  ] = "Check to automatically request someone's profile when you hear them speak or emote.";
L["Config Hear Someone Request"          ] = "Request Profile when Heard";
L["Config Mouseover Request Tooltip"     ] = "Check to automatically request someone's profile when you mouse over them.";
L["Config Mouseover Request"             ] = "Request Profile on Mouseover";
L["Config Notify Profile Sent Tooltip"   ] = "Check to get a notification in the text window when your profile is sent to someone.";
L["Config Notify Profile Sent"           ] = "Notify Profile Sent";
L["Config Options"                       ] = "Configuration Options";
L["Config Party Request Tooltip"         ] = "Check to automatically request the profiles of anyone in a party that you join.";
L["Config Party Request"                 ] = "Request Party Members' Profiles";
L["Config Raid Request Tooltip"          ] = "Check to automatically request the profiles of anyone in a raid that you join.";
L["Config Raid Request"                  ] = "Request Raid Members' Profiles";
L["Config Show Icon Tooltip"             ] = "Show or hide the minimap icon.";
L["Config Show Icon"                     ] = "Show Icon";
L["Config Target Request Tooltip"        ] = "Check to automatically request someone's profile when you target them.";
L["Config Target Request"                ] = "Request Target's Profile";
L["Config Tooltips Fade Out Tooltip"     ] = "Uncheck to have " .. addOnTitle .. " tooltips disappear instantly instead of fading out slowly.";
L["Config Tooltips Fade Out"             ] = "Tooltips Fade Slowly";
L["Credits Header"                       ] = "Credits";
L["Custom Honorific"                     ] = "Custom Honorific";
L["Custom Icon"                          ] = "Custom Icon";
L["Custom Pronouns"                      ] = "Custom Pronouns";
L["Custom Status"                        ] = "Custom Status"
L["Custom Style"                         ] = "Custom Style";
L["Full-Time"                            ] = "RP Style: Full-Time";
L["Gender (Female)"                      ] = " (Female)";
L["Gender (Male)"                        ] = " (Male)";
L["Gender (Neutral)"                     ] = "";
L["Group Appearance"                     ] = "Appearance";
L["Instruct Appearance"                  ] = "You can describe your character's appearance.";
L["Group Basics"                         ] = "Basic";
L["Instruct Basics"                      ] = "These are the basic details about your character -- their name, pronouns, race, profession, and so on.";
L["Group Bio"                            ] = "Biography";
L["Instruct Bio"                         ] = "You can use this part of the profile to describe your character's backstory.";
L["Group Status"                         ] = "Status";
L["Instruct Status"                      ] = "You can set yourself in-character or out-of-character on this panel, and record what you're currently doing."
L["Group Glance"                         ] = "Details";
L["Instruct Details"                     ] = "You can set up to five details that describe what someone would immediately at first glance.";
L["Honorifics List"                      ] = "Mrs.|Ms.|Miss|Mx.|Mr.|Lord|Lady|Sir|Ser|Dr.|Prof.";
L["In Character"                         ] = "Status: In Character";
L["Label AE"                             ] = "Eye Color";
L["Label AG"                             ] = "Age";
L["Label AH"                             ] = "Height";
L["Label AW"                             ] = "Weight";
L["Label CO"                             ] = "OOC Info";
L["Label CU"                             ] = "Currently";
L["Label Color"                          ] = "Color";
L["Label DE"                             ] = "Character Description";
L["Label Editor Tooltips"                ] = "Tooltips";
L["Label FC"                             ] = "Character Status";
L["Label FC-custom"                      ] = "Custom Status";
L["Label FR"                             ] = "Roleplaying Style";
L["Label FR-custom"                      ] = "Custom Style";
L["Label HB"                             ] = "Birthplace";
L["Label HH"                             ] = "Home";
L["Label HI"                             ] = "Character History";
L["Label IC"                             ] = "Icon";
L["Label IC-custom"                      ] = "Custom Icon";
L["Label IC-icon"                        ] = "Icon";
L["Label MO"                             ] = "Catchphrase";
L["Label NA"                             ] = "Name";
L["Label NH"                             ] = "Affiliation";
L["Label NI"                             ] = "Nickname";
L["Label NT"                             ] = "Title";
L["Label PN"                             ] = "Pronouns";
L["Label PN-custom"                      ] = "Custom Pronouns";
L["Label PX"                             ] = "Honorific";
L["Label PX-custom"                      ] = "Custom Honorific";
L["Label RA"                             ] = "Race";
L["Label RC"                             ] = "Profession";
L["Label PE1"                            ] = "Detail #1";
L["Label PE1-title"                      ] = LABEL_GLANCE_TITLE;
L["Label PE1-text"                       ] = LABEL_GLANCE_TEXT;
L["Label PE1-icon"                       ] = LABEL_GLANCE_ICON;
L["Label PE1-icon-custom"                ] = LABEL_CUSTOM_ICON;
L["Label PE2"                            ] = "Detail #2";
L["Label PE2-title"                      ] = LABEL_GLANCE_TITLE;
L["Label PE2-text"                       ] = LABEL_GLANCE_TEXT;
L["Label PE2-icon"                       ] = LABEL_GLANCE_ICON;
L["Label PE2-icon-custom"                ] = LABEL_CUSTOM_ICON;
L["Label PE3"                            ] = "Detail #3";
L["Label PE3-title"                      ] = LABEL_GLANCE_TITLE;
L["Label PE3-text"                       ] = LABEL_GLANCE_TEXT;
L["Label PE3-icon"                       ] = LABEL_GLANCE_ICON;
L["Label PE3-icon-custom"                ] = LABEL_CUSTOM_ICON;
L["Label PE4"                            ] = "Detail #4";
L["Label PE4-title"                      ] = LABEL_GLANCE_TITLE;
L["Label PE4-text"                       ] = LABEL_GLANCE_TEXT;
L["Label PE4-icon"                       ] = LABEL_GLANCE_ICON;
L["Label PE4-icon-custom"                ] = LABEL_CUSTOM_ICON;
L["Label PE5"                            ] = "Detail #5";
L["Label PE5-title"                      ] = LABEL_GLANCE_TITLE;
L["Label PE5-text"                       ] = LABEL_GLANCE_TEXT;
L["Label PE5-icon"                       ] = LABEL_GLANCE_ICON;
L["Label PE5-icon-custom"                ] = LABEL_CUSTOM_ICON;
L["Tooltip PE1"                          ] = TOOLTIP_GLANCE;
L["Tooltip PE1-title"                    ] = TOOLTIP_GLANCE_TITLE;
L["Tooltip PE1-text"                     ] = TOOLTIP_GLANCE_TEXT;
L["Tooltip PE1-icon"                     ] = TOOLTIP_ICON;
L["Tooltip PE1-icon-custom"              ] = TOOLTIP_CUSTOM_ICON;
L["Tooltip PE2"                          ] = TOOLTIP_GLANCE;
L["Tooltip PE2-title"                    ] = TOOLTIP_GLANCE_TITLE;
L["Tooltip PE2-text"                     ] = TOOLTIP_GLANCE_TEXT;
L["Tooltip PE2-icon"                     ] = TOOLTIP_ICON;
L["Tooltip PE2-icon-custom"              ] = TOOLTIP_CUSTOM_ICON;
L["Tooltip PE3"                          ] = TOOLTIP_GLANCE;
L["Tooltip PE3-title"                    ] = TOOLTIP_GLANCE_TITLE;
L["Tooltip PE3-text"                     ] = TOOLTIP_GLANCE_TEXT;
L["Tooltip PE3-icon"                     ] = TOOLTIP_ICON;
L["Tooltip PE3-icon-custom"              ] = TOOLTIP_CUSTOM_ICON;
L["Tooltip PE4"                          ] = TOOLTIP_GLANCE;
L["Tooltip PE4-title"                    ] = TOOLTIP_GLANCE_TITLE;
L["Tooltip PE4-text"                     ] = TOOLTIP_GLANCE_TEXT;
L["Tooltip PE4-icon"                     ] = TOOLTIP_ICON;
L["Tooltip PE4-icon-custom"              ] = TOOLTIP_CUSTOM_ICON;
L["Tooltip PE5"                          ] = TOOLTIP_GLANCE;
L["Tooltip PE5-title"                    ] = TOOLTIP_GLANCE_TITLE;
L["Tooltip PE5-text"                     ] = TOOLTIP_GLANCE_TEXT;
L["Tooltip PE5-icon"                     ] = TOOLTIP_ICON;
L["Tooltip PE5-icon-custom"              ] = TOOLTIP_CUSTOM_ICON;
L["Looking for Contact"                  ] = "Status: Looking for Contact";
L["No Honorific"                         ] = "No Honorific";
L["No Pronouns"                          ] = "No Pronouns";
L["None"                                 ] = "None";
L["Normal"                               ] = "Style: Normal";
L["Out of Character"                     ] = "Status: Out of Character";
L["Pronouns He/Him"                      ] = "He/Him";
L["Pronouns List"                        ] = "They/Them|It/Its|Fae/Faer|Xe/Xem";
L["Pronouns She/Her"                     ] = "She/Her";
L["Sent Profile To %s"                   ] = "You sent your profile info to |cffffff00%s|r.";
L["Slash Commands"                       ] = "Slash Commands";
L["Slash Currently"                      ] = SLASH .. "|cffffff00currently|r |cff00ffffvalue|r - Set your currently";
L["Slash IC"                             ] = SLASH .. "|cffffff00ic|r - Set your status to in character";
L["Slash Info"                           ] = SLASH .. "|cffffff00info|r |cff00ffffvalue|r - Set your OOC info";
L["Slash OOC"                            ] = SLASH .. "|cffffff00ooc|r - Set your status to out of character";
L["Slash Open"                           ] = SLASH .. "|cffffff00open|r - Open the profile editor";
L["Slash Options"                        ] = SLASH .. "|cffffff00options|r - Open the options panel";
L["Slash Status"                         ] = SLASH .. "|cffffff00status|r |cff00ffffvalue|r - Set your status";
L["Slash Toggle Editor"                  ] = SLASH .. "|cffffff00toggle editor|r -- Toggle the profile editor";
L["Slash Toggle Status"                  ] = SLASH .. "|cffffff00toggle status|r - Toggle between IC and OOC status";
L["Status Undefined"                     ] = "Status: Undefined";
L["Storyteller"                          ] = "Status: Storyteller";
L["Style Undefined"                      ] = "RP Style: Undefined";
L["Support Header"                       ] = "MSP Support";
L["Tooltip AE"                           ] = "Set your character's eye color.";
L["Tooltip AG"                           ] = "Set your character's age, either in years or a descriptive phrase.";
L["Tooltip AH"                           ] = "Set your character's height, either a number of centimeters, a number and units, or a descriptive phrase.";
L["Tooltip AW"                           ] = "Set your character's weight, either a number of kilograms, a number and units, or a descriptive phrase.";
L["Tooltip CO"                           ] = "Set your OOC information.";
L["Tooltip CU"                           ] = "Set your currently.";
L["Tooltip Color"                        ] = "Pick a color.";
L["Tooltip DE"                           ] = "Describe your character's appearance.";
L["Tooltip FC"                           ] = "Pick your character's status.";
L["Tooltip FC-custom"                    ] = "Enter a custom status.";
L["Tooltip FR"                           ] = "Choose your roleplaying style.";
L["Tooltip FR-custom"                    ] = "Enter a custom RP style.";
L["Tooltip HB"                           ] = "Enter your character's birthplace.";
L["Tooltip HH"                           ] = "Set your character's current home.";
L["Tooltip HI"                           ] = "Give your character's history and backstory.";
L["Tooltip IC"                           ] = "Select a pre-defined icon, or set a custom icon.";
L["Tooltip IC-custom"                    ] = "Enter filename of an icon in the |cff00ffffInterface\\\\ICONS\\\\|r directory.";
L["Tooltip IC-icon"                      ] = "Icon preview";
L["Tooltip MO"                           ] = "Set a motto or catchphrase for your character.";
L["Tooltip NA"                           ] = "Set your character's full name.";
L["Tooltip NH"                           ] = "Set your character's house affiliation, or other in-character affiliation.";
L["Tooltip NI"                           ] = "Enter your character's nickname(s).";
L["Tooltip NT"                           ] = "Set your character's long title.";
L["Tooltip PN"                           ] = "Choose a set of preferred pronouns for your character.";
L["Tooltip PN-custom"                    ] = "Enter a custom set of preferred pronouns.";
L["Tooltip PX"                           ] = "Choose an honorific; i.e., a short title used before your character's name.";
L["Tooltip PX-custom"                    ] = "Enter a custom honorific.";
L["Tooltip RA"                           ] = "Enter the roleplayed race for your character.";
L["Tooltip RC"                           ] = "Enter the roleplayed class for your character.";
L["Undefined"                            ] = "Undefined";
L["Version Info"                         ] = "You're running " .. addOnTitle .. " version " .. addOnVersion .. " (" .. addOnDate .. ").";
L["Your Current Status Is"               ] = "Your current status is:";
L["Your Currently Is"                    ] = "Your currently is:";
L["Your OOC Info Is"                     ] = "Your OOC info is:";
L["rpIdentity Icon"                      ] = addOnTitle .. " Mask";
L[POPUP_CLEAR                            ] = "|cffff0000Warning!|r\n\nThis will reset your saved identity. Are you sure that's what you want to do?";

L["70_inscription_steamy_romance_novel_kit" ] = "Steamy romance novel kit";
L["ability_bossashvane_icon02"              ] = "Ashvane symbol";
L["ability_deathknight_heartstopaura"       ] = "Broken heart";
L["ability_hunter_beastcall"                ] = "Wooden whistle";
L["ability_priest_heavanlyvoice"            ] = "Draenei (female, alternate)";
L["ability_rogue_bloodyeye"                 ] = "Bloody eye";
L["ability_warrior_strengthofarms"          ] = "Biceps";
L["achievement_doublerainbow"               ] = "Rainbows";
L["achievement_halloween_smiley_01"         ] = "Toothy grin";
L["inv_inscription_inkblack01"              ] = "Bottle of ink";
L["inv_inscription_scrollofwisdom_01"       ] = "Scroll";
L["inv_jewelry_ring_14"                     ] = "Golden ring";
L["inv_legendary_gun"                       ] = "Flintlock gun";
L["inv_misc_book_12"                        ] = "Alliance book";
L["inv_misc_food_147_cake"                  ] = "Birthday cake";
L["inv_misc_grouplooking"                   ] = "Little silhouetto of a man";
L["inv_misc_kingsring1"                     ] = "Red ring";
L["inv_misc_questionmark"                   ] = "Question mark";
L["pet_type_magical"                        ] = "Purple starburst";
L["petbattle_health"                        ] = "Red heart";
L["spell_shadow_mindsteal"                  ] = "Single eye";
L["trade_archaeology_delicatemusicbox"      ] = "Music box";
L["ui_rankedpvp_01_small"                   ] = "Copper blade";
L["ui_rankedpvp_02_small"                   ] = "Silver blade";
L["ui_rankedpvp_03_small"                   ] = "Golden blade";
L["ui_rankedpvp_04_small"                   ] = "Platinum blade";
L["vas_namechange"                          ] = "Pandaren (male, alternate)";
L["warrior_disruptingshout"                 ] = "Open mouth";

-- long entries ------------------------------------------------------------------------
--
L["Credits Info" ] =
[===[
The coding was done by |cffff33ffOraibi-MoonGuard|r. 

Several standard libraries were used:

- LibMSP by Etarna Moonsyne, Morgane "Ellypse" Parize, Justin Snelgrove

- Ace3 by Ace3 Development Team

- LibDataBroker by tekkub, Elkano

- LibDBIcon by funkehdude

]===];
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
