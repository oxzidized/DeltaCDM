-- 1. CONFIGURATION & DEFAULTS
local addonName = "CDMVisibility"
local framesToManage = {
    "EssentialCooldownViewer",
    "UtilityCooldownViewer",
    "BuffIconCooldownViewer",
    "BuffBarCooldownViewer"
}

-- Default settings (if none exist yet)
local defaults = {
    hideInCombat = false, -- Default: Do NOT hide in combat
    hideMounted = true    -- Default: DO hide when mounted
}

-- 2. MAIN FRAME & EVENTS
local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_REGEN_DISABLED")
f:RegisterEvent("PLAYER_REGEN_ENABLED")
f:RegisterEvent("PLAYER_MOUNT_DISPLAY_CHANGED")
f:RegisterEvent("PLAYER_ENTERING_WORLD")

-- 3. LOGIC
local function UpdateVisibility()
    if not CDMVisibilityDB then return end -- Safety check

    local inCombat = UnitAffectingCombat("player")
    local isMounted = IsMounted()

    -- Determine if we should HIDE based on settings
    local shouldHide = false

    if CDMVisibilityDB.hideInCombat and inCombat then
        shouldHide = true
    end

    if CDMVisibilityDB.hideMounted and isMounted then
        shouldHide = true
    end

    -- Apply visibility
    for _, frameName in ipairs(framesToManage) do
        local frame = _G[frameName]
        if frame then
            if shouldHide then
                frame:Hide()
            else
                frame:Show()
            end
        end
    end
end

f:SetScript("OnEvent", function(_, event, arg1)
    -- Load SavedVariables when addon loads
    if event == "ADDON_LOADED" and arg1 == addonName then
        if CDMVisibilityDB == nil then
            CDMVisibilityDB = CopyTable(defaults)
        end
        UpdateVisibility()

    -- Run check on all other events
    elseif event ~= "ADDON_LOADED" then
        UpdateVisibility()
    end
end)

-- 4. SLASH COMMANDS
SLASH_CDMVISIBILITY1 = "/cdmv"

SlashCmdList["CDMVISIBILITY"] = function(msg)
    msg = msg:lower():trim()

    if msg == "combat" then
        CDMVisibilityDB.hideInCombat = not CDMVisibilityDB.hideInCombat
        print("|cff00ccffCDM:|r Hide in Combat is now: " .. (CDMVisibilityDB.hideInCombat and "|cffff0000ON|r" or "|cff00ff00OFF|r"))
        UpdateVisibility()

    elseif msg == "mounted" then
        CDMVisibilityDB.hideMounted = not CDMVisibilityDB.hideMounted
        print("|cff00ccffCDM:|r Hide while Mounted is now: " .. (CDMVisibilityDB.hideMounted and "|cffff0000ON|r" or "|cff00ff00OFF|r"))
        UpdateVisibility()

    else
        -- Status / Help
        print("|cff00ccffCDMVisibility Status:|r")
        print("  Hide in Combat: " .. (CDMVisibilityDB.hideInCombat and "|cffff0000ON|r" or "|cff00ff00OFF|r") .. " (Type '/cdmv combat' to toggle)")
        print("  Hide Mounted:   " .. (CDMVisibilityDB.hideMounted and "|cffff0000ON|r" or "|cff00ff00OFF|r") .. " (Type '/cdmv mounted' to toggle)")
    end
end
