
--- Loading
---@param show boolean
---@param loadingText string
---@param spinnerType number
local function Loading(show, loadingText, spinnerType)
    if show then
        if IsLoadingPromptBeingDisplayed() then
            RemoveLoadingPrompt()
        end
        if (loadingText == nil) then
            BeginTextCommandBusyString(nil)
        else
            BeginTextCommandBusyString("STRING")
            AddTextComponentSubstringPlayerName(loadingText)
        end
        EndTextCommandBusyString(spinnerType or 4)
    else
        RemoveLoadingPrompt()
    end
end

return {
    loading = Loading,
}