
local function LoadLocales(nation_prefix)
    local lang <const> = GetConvar("sl_lang", nation_prefix or "fr")
    local currentfile <const> = sl.string.split(sl.string.split(debug.getinfo(2, "Sl").source, "@")[3], "/" )
    local content <const> = LoadResourceFile(currentfile[1], ("locales/lang_%s.lua"):format(lang))
    if not content then
        return error(("Could not load [Local file (%s)] or not exist !"):format(lang), 3)
    end
    local func, err = load(content)
    if not func or err then
        return error(("Erreur pendant le chargement du module [LOCALE] (%s)"):format(err), 3)
    end
    return func()
end

return {
    load = LoadLocales
}