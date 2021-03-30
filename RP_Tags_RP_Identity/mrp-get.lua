    local function getGlance(u, slot, args)
      local showTitle, showText, showIcon = args.title or args.all, args.text or args.all, args.icon or args.all;
      local unitID         = getUnitID(u);      if not unitID  then return "" end;
      local glances        = getField(u, "PE"); if not glances then return "" end; 
      glances              = RPTAGS.utils.parse.mrpGlance(glances);           -- { { icon = icon, title = title, text = text }+ }
      RPTAGS.cache.glances = glances;
      local delimiter      = Config.get("GLANCE_DELIM"); 
      local separator      = Config.get("GLANCE_COLON");
      local value          = "";
      
      if   slot == 0
      then local allGlances = {};
           for   i = 1, #glances
           do    local glance = getGlance(u, i, showTitle, showText, showIcon) 
                 if    glance and glance ~= "" 
                 then  table.insert(allGlances, glance) 
                 end; 
           end;
           return table.concat(allGlances, delimiter or "")
      else local glance = glances[tonumber(slot)];
           if not glance                then return ""                                       end;
           if showIcon                  then value = value..ico("ICONS\\"..glance.icon).." " end;
           if showTitle                 then value = value..glance.title                     end;
           if showTitle   and showText  then value = value..separator                        end;
           if showText                  then value = value..glance.text                      end;
           if value == "" and showTitle then value = "..."                                   end;
           return value;
      end;
    end; -- function

    RPTAGS.utils.get.text.glance       = getGlance;


