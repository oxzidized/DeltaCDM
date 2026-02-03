-- 1. CONFIGURATION & DEFAULTS
local addonName = "DeltaCDM"
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
    if not DeltaCDMDB then return end -- Safety check

    local outCombat = not UnitAffectingCombat("player")
    local isMounted = IsMounted()

    -- Determine if we should HIDE based on settings
    local shouldHide = false

    if DeltaCDMDB.hideOutCombat and outCombat then
        shouldHide = true
    end

    if DeltaCDMDB.hideMounted and isMounted then
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
        if DeltaCDMDB == nil then
            DeltaCDMDB = CopyTable(defaults)
        end
        UpdateVisibility()

    -- Run check on all other events
    elseif event ~= "ADDON_LOADED" then
        UpdateVisibility()
    end
end)

-- TODO: add options ui

-- 4. SLASH COMMANDS
SLASH_DELTACDM1 = "/dcdm"

SlashCmdList["DELTACDM"] = function(msg)
    msg = msg:lower():trim()

    if msg == "combat" then
        DeltaCDMDB.hideOutCombat = not DeltaCDMDB.hideOutCombat
        print("|cff00ccffCDM:|r Hide out of Combat is now: " .. (DeltaCDMDB.hideOutCombat and "|cffff0000ON|r" or "|cff00ff00OFF|r"))
        UpdateVisibility()

    elseif msg == "mounted" then
        DeltaCDMDB.hideMounted = not DeltaCDMDB.hideMounted
        print("|cff00ccffCDM:|r Hide while Mounted is now: " .. (DeltaCDMDB.hideMounted and "|cffff0000ON|r" or "|cff00ff00OFF|r"))
        UpdateVisibility()

    else
        -- Status / Help
        print("|cff00ccffDeltaCDM Status:|r")
        print("  Hide in Combat: " .. (DeltaCDMDB.hideOutCombat and "|cffff0000ON|r" or "|cff00ff00OFF|r") .. " (Type '/dcdm combat' to toggle)")
        print("  Hide Mounted:   " .. (DeltaCDMDB.hideMounted and "|cffff0000ON|r" or "|cff00ff00OFF|r") .. " (Type '/dcdm mounted' to toggle)")
    end
end
