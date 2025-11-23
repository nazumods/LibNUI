local _, ns = ...
local max = math.max
local ui = ns.ui

local insert = table.insert
local Class, CleanFrame, Frame, Label = ns.lua.Class, ui.CleanFrame, ui.Frame, ui.Label

local Tooltip = Class(CleanFrame, function(self)
  self:Hide()

  local w = 0
  local h = 0
  local lines = self.lines
  self.lines = {}
  for i,line in ipairs(lines) do
    local l = Frame:new{
      parent = self,
      position = {
        TopLeft = i == 1 and {self.inset, -self.inset} or {self.lines[i-1], ui.edge.BottomLeft},
        Right = {},
        Height = 20,
      },
      background = line.background,
    }
    l.label = Label:new{
      parent = l,
      text = line.text,
      position = { All = true },
      justifyH = ui.edge.Left,
    }
    w = max(w, l.label._widget:GetUnboundedStringWidth())
    if line.onClick then l:SetScript("OnMouseUp", function() line.onClick(l) end) end
    if line.onEnter then l:SetScript("OnEnter", function() line.onEnter(l) end) end
    if line.onLeave then l:SetScript("OnLeave", function() line.onLeave(l) end) end
    insert(self.lines, l)
    h = h + l:Height()
  end
  self:Height(h + 2 * self.inset)
  self:Width(w + 2 * self.inset)
end, {
  strata = "DIALOG",
  background = {0, 0, 0, 0.7},
  inset = 3,
})
ui.Tooltip = Tooltip
