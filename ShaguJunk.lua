local gfind = string.gmatch or string.gfind

local function tContains(table, item)
  local index = 1;
  while table[index] do
    if ( item == table[index] ) then
      return 1;
    end
    index = index + 1;
  end
  return nil;
end


ShaguJunk = CreateFrame("Frame")

do -- config
  -- Saved vars
  ShaguJunk_vendor = ShaguJunk_vendor or {}
  ShaguJunk_delete = ShaguJunk_delete or {}
  ShaguJunk_dungeon = ShaguJunk_dungeon or {}
  ShaguJunk_greyValue = ShaguJunk_greyValue or nil

  -- Temp vars
  ShaguJunk_temp = {}
  ShaguJunk_dryRun = false


  SLASH_SHAGUJUNK1, SLASH_SHAGUJUNK2, SLASH_SHAGUJUNK3 = "/sjunk", "/junk", "/sj"
  SlashCmdList["SHAGUJUNK"] = function(message)
    local commandlist = { }
    local command

    for command in gfind(message, "[^ ]+") do
      table.insert(commandlist, string.lower(command))
    end

    -- add vendor entry
    if (commandlist[1] == "vendor" or commandlist[1] == "ven") then
      local addstring = table.concat(commandlist," ",2)
      if addstring == "" then return end

      -- support item links
      local _, _, itemLink = string.find(addstring, "(item:%d+:%d+:%d+:%d+)")
      local itemName = itemLink and GetItemInfo(itemLink)

      addstring = itemName or addstring

      if tContains(ShaguJunk_vendor, string.lower(addstring)) then
        DEFAULT_CHAT_FRAME:AddMessage("=> Vendor list already contains " .. addstring)
        return
      end

      table.insert(ShaguJunk_vendor, string.lower(addstring))
      DEFAULT_CHAT_FRAME:AddMessage("=> adding |cff33ffcc".. addstring .."|r to your vendor list")

    -- add delete entry
    elseif (commandlist[1] == "delete" or commandlist[1] == "del") then
      local addstring = table.concat(commandlist," ",2)
      if addstring == "" then return end

      -- support item links
      local _, _, itemLink = string.find(addstring, "(item:%d+:%d+:%d+:%d+)")
      local itemName = itemLink and GetItemInfo(itemLink)

      addstring = itemName or addstring

      if tContains(ShaguJunk_delete, string.lower(addstring)) then
        DEFAULT_CHAT_FRAME:AddMessage("=> Delete list already contains " .. addstring)
        return
      end

      table.insert(ShaguJunk_delete, string.lower(addstring))
      DEFAULT_CHAT_FRAME:AddMessage("=> adding |cff33ffcc".. addstring .."|r to your delete list")

    -- add dungeon entry
    elseif (commandlist[1] == "dungeon" or commandlist[1] == "instance" or commandlist[1] == "dun") then
      local addstring = table.concat(commandlist," ",2)
      if addstring == "" then return end

      -- support item links
      local _, _, itemLink = string.find(addstring, "(item:%d+:%d+:%d+:%d+)")
      local itemName = itemLink and GetItemInfo(itemLink)

      addstring = itemName or addstring

      if tContains(ShaguJunk_dungeon, string.lower(addstring)) then
        DEFAULT_CHAT_FRAME:AddMessage("=> Dungeon delete list already contains " .. addstring)
        return
      end

      table.insert(ShaguJunk_dungeon, string.lower(addstring))
      DEFAULT_CHAT_FRAME:AddMessage("=> adding |cff33ffcc".. addstring .."|r to your dungeon delete list")


    -- add temp entry
    elseif (commandlist[1] == "temp" or commandlist[1] == "tmp") then
      local addstring = table.concat(commandlist," ",2)
      if addstring == "" then return end

      -- support item links
      local _, _, itemLink = string.find(addstring, "(item:%d+:%d+:%d+:%d+)")
      local itemName = itemLink and GetItemInfo(itemLink)

      addstring = itemName or addstring

      if tContains(ShaguJunk_temp, string.lower(addstring)) then
        DEFAULT_CHAT_FRAME:AddMessage("=> Temp delete list already contains " .. addstring)
        return
      end

      table.insert(ShaguJunk_temp, string.lower(addstring))
      DEFAULT_CHAT_FRAME:AddMessage("=> adding |cff33ffcc".. addstring .."|r to your temp delete list")

      -- add greyvalue entry
    elseif (commandlist[1] == "grey" or commandlist[1] == "gray") then
      local numstring = table.concat(commandlist," ",2)
      if numstring == "" then return end

      local number = tonumber(numstring)
      if not number then
        DEFAULT_CHAT_FRAME:AddMessage("=> Unable to parse |cff33ffcc".. numstring .."|r to value")
        return
      end

      if number < 0 then
        DEFAULT_CHAT_FRAME:AddMessage("=> Grey value has to be positive number")
        return
      end

      ShaguJunk_greyValue = number
      DEFAULT_CHAT_FRAME:AddMessage("=> Setting grey auto-delete value to |cff33ffcc" .. number .."|r")

    -- remove entry
    elseif commandlist[1] == "rm" then
      local vendor = tonumber(commandlist[2])
      local delete = tonumber(commandlist[2]) - table.getn(ShaguJunk_vendor)
      local dungeon = tonumber(commandlist[2]) - table.getn(ShaguJunk_vendor) - table.getn(ShaguJunk_delete)
      local temp = tonumber(commandlist[2]) - table.getn(ShaguJunk_vendor) - table.getn(ShaguJunk_delete) - table.getn(ShaguJunk_dungeon)

      if ShaguJunk_vendor[vendor] then
        DEFAULT_CHAT_FRAME:AddMessage("=> Removing entry " .. commandlist[2]
          .. " (" .. ShaguJunk_vendor[vendor]
          .. ") from your vendor list")

        table.remove(ShaguJunk_vendor, vendor)

      elseif ShaguJunk_delete[delete] then
        DEFAULT_CHAT_FRAME:AddMessage("=> Removing entry " .. commandlist[2]
          .. " (" .. ShaguJunk_delete[delete]
          .. ") from your deletion list")
        table.remove(ShaguJunk_delete, delete)

      elseif ShaguJunk_dungeon[dungeon] then
        DEFAULT_CHAT_FRAME:AddMessage("=> Removing entry " .. commandlist[2]
                .. " (" .. ShaguJunk_dungeon[dungeon]
                .. ") from your dungeon deletion list")
        table.remove(ShaguJunk_dungeon, dungeon)

      elseif ShaguJunk_temp[temp] then
        DEFAULT_CHAT_FRAME:AddMessage("=> Removing entry " .. commandlist[2]
                .. " (" .. ShaguJunk_temp[temp]
                .. ") from your temp deletion list")
        table.remove(ShaguJunk_temp, temp)
      end
    elseif commandlist[1] == "ls" then
      local addstring = table.concat(commandlist," ",2)
      local printID = 0
      local tempID = 0
      DEFAULT_CHAT_FRAME:AddMessage("|cff33ee33Vendor Items:")
      for id, hl in pairs(ShaguJunk_vendor) do
        if string.find(hl, addstring) then
          DEFAULT_CHAT_FRAME:AddMessage(" |r[|cff33ee33"..id.."|r] "..hl)
        end
        tempID = id
      end
      printID = printID + tempID; tempID = 0

      DEFAULT_CHAT_FRAME:AddMessage("|cffaa3333Delete Items:")
      for id, hl in pairs(ShaguJunk_delete) do
        if string.find(hl, addstring) then
          DEFAULT_CHAT_FRAME:AddMessage(" |r[|cffee3333"..id+printID.."|r] "..hl)
        end
        tempID = id
      end
      printID = printID + tempID; tempID = 0

      DEFAULT_CHAT_FRAME:AddMessage("|cffaa3333Dungeon Items:")
      for id, hl in pairs(ShaguJunk_dungeon) do
        if string.find(hl, addstring) then
          DEFAULT_CHAT_FRAME:AddMessage(" |r[|cffee3333"..id+printID.."|r] "..hl)
        end
        tempID = id
      end

      printID = printID + tempID; tempID = 0

      DEFAULT_CHAT_FRAME:AddMessage("|cffaa3333Temp Items:")
      for id, hl in pairs(ShaguJunk_temp) do
        if string.find(hl, addstring) then
          DEFAULT_CHAT_FRAME:AddMessage(" |r[|cffee3333"..id+printID.."|r] "..hl)
        end
        tempID = id
      end

      if ShaguJunk_greyValue then
        DEFAULT_CHAT_FRAME:AddMessage("Grey stack value set to |r[|cffee3333 "..ShaguJunk_greyValue.."|r]")
      else
        DEFAULT_CHAT_FRAME:AddMessage("Grey stack value not set")
      end

    elseif (commandlist[1] == "dry" or commandlist[1] == "dryrun") then
      ShaguJunk_dryRun = (not ShaguJunk_dryRun)
      DEFAULT_CHAT_FRAME:AddMessage("Togglin dry run to " .. tostring(ShaguJunk_dryRun))
    else
      DEFAULT_CHAT_FRAME:AddMessage("ShaguJunk Usage:")
      DEFAULT_CHAT_FRAME:AddMessage("|cffaaffdd/sjunk vendor Fel Iron Blood Ring|cffaaaaaa - |rAutomatically vendors Fel Iron Rings")
      DEFAULT_CHAT_FRAME:AddMessage("|cffaaffdd/sjunk delete Light Hide|cffaaaaaa - |rAutomatically deletes Light Hide")
      DEFAULT_CHAT_FRAME:AddMessage("|cffaaffdd/sjunk dungeon Linen Cloth|cffaaaaaa - |rAutomatically deletes Linen Cloth when inside dungeon")
      DEFAULT_CHAT_FRAME:AddMessage("|cffaaffdd/sjunk temp Small Egg|cffaaaaaa - |rAutomatically deletes Small Egg in this game session")
      DEFAULT_CHAT_FRAME:AddMessage("|cffaaffdd/sjunk grey 10|cffaaaaaa - |rAutomatically deletes any grey item with stack value less than 10 silver")
      DEFAULT_CHAT_FRAME:AddMessage("|cffaaffdd/sjunk rm 3|cffaaaaaa - |rRemoves entry '3' of your list")
      DEFAULT_CHAT_FRAME:AddMessage("|cffaaffdd/sjunk ls|cffaaaaaa - |rDisplays your current list")
      DEFAULT_CHAT_FRAME:AddMessage("|cffaaffdd/sjunk ls <text>|cffaaaaaa - |rSearch your current list for text")
    end
  end
end

do -- autovendor
  local autovendor = CreateFrame("Frame")
  autovendor:Hide()

  autovendor:RegisterEvent("MERCHANT_SHOW")
  autovendor:RegisterEvent("MERCHANT_CLOSED")
  autovendor:SetScript("OnEvent", function()
    if event == "MERCHANT_CLOSED" then
      autovendor.merchant = nil
      autovendor:Hide()
    elseif event == "MERCHANT_SHOW" then
      autovendor.merchant = true
      autovendor:Show()
    end
  end)

  autovendor:SetScript("OnUpdate", function()
    -- throttle to to one item per .1 second
    if ( this.tick or 1) > GetTime() then return else this.tick = GetTime() + .1 end

    -- iterate through bag
    for bag = 0, 4, 1 do
      for slot = 1, GetContainerNumSlots(bag), 1 do
        local rawlink = GetContainerItemLink(bag, slot)
        local _, _, link = string.find((rawlink or ""), "(item:%d+:%d+:%d+:%d+)")
        local name = link and GetItemInfo(link)
        name = name and string.lower(name)

        if name then
          for i, vendor in pairs(ShaguJunk_vendor) do
            -- abort if the merchant window disappeared
            if not this.merchant then return end

            if name == vendor then
              -- clear cursor and sell the item
              ClearCursor()
              UseContainerItem(bag, slot)
              -- continue next update
              return
            end
          end
        end
      end
    end

    -- stop processing
    this:Hide()
  end)
end


local function GetItemStackValue(id)
  if ShaguJunk.SellValueDB[id] and ShaguJunk.SellValueDB[id] > 0 then

    local singleValue = ShaguJunk.SellValueDB[id]

    local _, _, quality, _, type, subType, stackCount, invType = GetItemInfo(id)

    return singleValue * stackCount
  end

  return nil
end

do -- autodelete
  local autodelete = CreateFrame("Frame")
  autodelete:Hide()

  autodelete:RegisterEvent("ITEM_PUSH")
  autodelete:SetScript("OnEvent", function()
    autodelete:Show()
  end)

  ShaguJunk_dryProcessed = {}

  autodelete:SetScript("OnUpdate", function()
    -- throttle to to one item per .1 second
    if ( this.tick or 1) > GetTime() then return else this.tick = GetTime() + .1 end

    inInstance, instanceType = IsInInstance()

    -- iterate through bag
    for bag = 0, 4, 1 do
      for slot = 1, GetContainerNumSlots(bag), 1 do
        local rawlink = GetContainerItemLink(bag, slot)
        local _, _, link = string.find((rawlink or ""), "(item:%d+:%d+:%d+:%d+)")
        local name = link and GetItemInfo(link)
        name = name and string.lower(name)

        if name and (tContains(ShaguJunk_dryProcessed, string.lower(name)) == nil) then

          -- Delete items from global delete list
          for i, delete in pairs(ShaguJunk_delete) do
            if name == delete then
              if ShaguJunk_dryRun then
                DEFAULT_CHAT_FRAME:AddMessage("Want to delete " .. name .. " from delete list")
                table.insert(ShaguJunk_dryProcessed, string.lower(name))
              else
                -- clear cursor and delete the item
                ClearCursor()
                PickupContainerItem(bag, slot)
                DeleteCursorItem()
                -- continue next update
              end
              return
            end
          end

          -- Delete items from temporary delete list
          for i, temp in pairs(ShaguJunk_temp) do
            if name == temp then
              if ShaguJunk_dryRun then
                DEFAULT_CHAT_FRAME:AddMessage("Want to delete " .. name .. " from temp list")
                table.insert(ShaguJunk_dryProcessed, string.lower(name))
              else
                -- clear cursor and delete the item
                ClearCursor()
                PickupContainerItem(bag, slot)
                DeleteCursorItem()
                -- continue next update
              end
              return
            end
          end

          -- Delete items from dungeon delete list
          if inInstance then
            for i, dungeon in pairs(ShaguJunk_dungeon) do
              if name == dungeon then
                if ShaguJunk_dryRun then
                  DEFAULT_CHAT_FRAME:AddMessage("Want to delete " .. name .. " from dungeon list")
                  table.insert(ShaguJunk_dryProcessed, string.lower(name))
                else
                  -- clear cursor and delete the item
                  ClearCursor()
                  PickupContainerItem(bag, slot)
                  DeleteCursorItem()
                  -- continue next update
                end
                return
              end
            end
          end

          -- Delete grey items with vendor value below threshold
          if ShaguJunk_greyValue then
            local _,_,itemRarity = GetItemInfo(link)
            if itemRarity == 0 then

              --DEFAULT_CHAT_FRAME:AddMessage("Testing ShaguJunk.SellValueDB value @ [3171] " .. ShaguJunk.SellValueDB[3171])

              --DEFAULT_CHAT_FRAME:AddMessage("Checking item link " .. link)
              local _, _, id = string.find(link, "item:(%d+):%d+:%d+:%d+")

              if id then
                --DEFAULT_CHAT_FRAME:AddMessage("Found id " .. id)
                local stackValue = GetItemStackValue(tonumber(id))
                if stackValue then

                  local silverValue = stackValue / 100

                  if silverValue < ShaguJunk_greyValue then
                    if ShaguJunk_dryRun then
                      DEFAULT_CHAT_FRAME:AddMessage("Want to delete " .. name .. " with calculated value " .. silverValue .. " which is less than limit " .. ShaguJunk_greyValue)
                      table.insert(ShaguJunk_dryProcessed, string.lower(name))
                    else
                      ClearCursor()
                      PickupContainerItem(bag, slot)
                      DeleteCursorItem()
                    end

                  end

                else
                  DEFAULT_CHAT_FRAME:AddMessage("Item " .. itemName .. " doesn't exist in database, not gonna delete to be safe")
                end
              end
            end
          end

        end
      end
    end

    -- stop processing
    ShaguJunk_dryProcessed = {}
    this:Hide()
  end)
end
