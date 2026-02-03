-- 1. CONFIGURATION
-- List of frames to manage. These are the likely names for the new UI elements.
local framesToManage = {
    "EssentialCooldownViewer",
    "UtilityCooldownViewer",
    "TrackedBuffsViewer", -- Sometimes used for the buff/debuff tracking part
    "TrackedBarsViewer"   -- Sometimes used for the bar tracking part
}

-- 2. MAIN LOGIC
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_REGEN_DISABLED")     -- Entering Combat
f:RegisterEvent("PLAYER_REGEN_ENABLED")      -- Leaving Combat
f:RegisterEvent("PLAYER_MOUNT_DISPLAY_CHANGED") -- Mounting/Dismounting
f:RegisterEvent("PLAYER_ENTERING_WORLD")     -- Login/Reload

f:SetScript("OnEvent", function(self, event)
    -- Check status
    local inCombat = UnitAffectingCombat("player")
    local isMounted = IsMounted()

    -- LOGIC: Show ONLY if we are in combat AND not mounted.
    -- (This means it hides if you are mounted, OR if you are just standing around)
    local shouldShow = inCombat and not isMounted

    -- Apply visibility to all frames
    for _, frameName in ipairs(framesToManage) do
        local frame = _G[frameName]
        if frame then
            if shouldShow then
                frame:Show()
            else
                frame:Hide()
            end
        end
    end
end)

SLASH_SMARTCOOLDOWNS1 = "/cdmv"
SlashCmdList["CDMVisibility"] = function(msg)
    local inCombat = UnitAffectingCombat("player")
    local isMounted = IsMounted()
    print("|cff00ff00CDMV:|r Status Update - Combat:", inCombat, "Mounted:", isMounted)
    f:GetScript("OnEvent")(f, "PLAYER_ENTERING_WORLD") -- Re-run the logic
end
