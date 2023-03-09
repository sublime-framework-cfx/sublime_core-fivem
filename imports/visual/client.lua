
--- sl.visual.float_text : create floating information notification
---@param text string
---@param pos vector3
local function FloatHelpText(text, pos)
    AddTextEntry("FloatHelpText", text)
    SetFloatingHelpTextWorldPosition(1, pos)
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
    BeginTextCommandDisplayHelp("FloatHelpText")
    EndTextCommandDisplayHelp(2, false, false, -1)
end

--- sl.visual.help_text : create help notification
---@param text string
local function HelpText(text)
    AddTextEntry("HelpText", text)
    DisplayHelpTextThisFrame("HelpText", false)
end

--- sl.visual.help_subtext : create 2d text in bottom of screen 
---@param text string
---@param time number
local function HelpSubText(text, time)
    ClearPrints()
    BeginTextCommandPrint("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandPrint(time and math.ceil(time) or 0, true)
end

--- sl.visual.keyboard : create keyboard input
---@param textEntry string
---@param exampleText string
---@param maxInputLength number
---@return string
local function KeyboardInput(textEntry, exampleText, maxInputLength)
    ---@type promise
    local p = promise.new() 
    AddTextEntry("FMMC_KEY_TIP1", textEntry)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", exampleText, "", "", "", maxInputLength)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Wait(0)
    end
    if UpdateOnscreenKeyboard() ~= 2 then
        local result <const> = GetOnscreenKeyboardResult()
        p:resolve(result)
    else
        p:resolve(nil)
    end
    return Citizen.Await(p)
end

--- sl.visual.draw3d_text : create 3d native text 
---@param coords vector3
---@param text string
---@param size number
---@param font number
local function Draw3DText(coords, text, size, font)
    local camCoords <const> = GetFinalRenderedCamCoord()
    local distance <const> = #(coords - camCoords)
    local scale = (size or 1 / distance) * 2
    local fov <const> = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov
    SetTextScale(0.0 * scale, 0.55 * scale)
    SetTextFont(font or 0)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    BeginTextCommandDisplayText('STRING')
    SetTextCentre(true)
    AddTextComponentSubstringPlayerName(text)
    SetDrawOrigin(coords, 0)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()
end

--- sl.visual.loading : create loading notification
---@param show boolean
---@param loadingText string
---@param spinnerType number
local function Loading(show, loadingText, spinnerType)
    if show then
        if IsLoadingPromptBeingDisplayed() then
            RemoveLoadingPrompt()
        end
        BeginTextCommandBusyString("STRING" and loadingText or nil)
        AddTextComponentSubstringPlayerName(loadingText or nil)
        EndTextCommandBusyString(spinnerType or 4)
    else
        RemoveLoadingPrompt()
    end
end

--- sl.visual.screen_fade : fade in or out the screen
---@param show boolean
---@param duration number
---@param waitUntilFinished boolean
local function ScreenFade(show, duration, waitUntilFinished)
    if show then
        DoScreenFadeOut(duration or 0)
        while waitUntilFinished and not IsScreenFadedOut() do
            Wait(0)
        end
    else
        DoScreenFadeIn(duration or 0)
        while waitUntilFinished and not IsScreenFadedIn() do
            Wait(0)
        end
    end
end

return {
    float_text = FloatHelpText,
    help_text = HelpText,
    help_subtext = HelpSubText,
    keyboard = KeyboardInput,
    draw3d_text = Draw3DText,
    loading = Loading,
    screen_fade = ScreenFade,
}