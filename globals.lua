local ns = LibNAddOn(...)

ns.ui = {}
LibNUI = ns.ui

ns:registerCommand("version", nil, function(self, msg)
  ns.Print("LibNUI version " .. ns:GetMetadata("Version"))
  local v,_,d,n = GetBuildInfo()
  ns.Print("WoW " .. v .. " (" .. d .. ") " .. n)
end)
