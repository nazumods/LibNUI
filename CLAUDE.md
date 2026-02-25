# CLAUDE.md — LibNUI

## Environment

- WoW addon library — no build step, no test runner, no package manager
- Changes cannot be verified from the CLI; they must be loaded in-game (`/reload`)
- Target: WoW Retail (Interface version in `LibNUI.toc`)
- Depends on `LibNAddOn` (`ns.lua.Class`, `ns.lua.maps`, etc.)

## Adding a New Class

Follow the established pattern exactly:

```lua
local _, ns = ...
local ui = ns.ui
local Class = ns.lua.Class
local Frame = ui.Frame  -- or whichever parent

local MyWidget = Class(Frame, function(self)
  -- constructor body; self fields are the options passed to :new{}
end, {
  -- default option values (optional)
})
ui.MyWidget = MyWidget

function MyWidget:SomeMethod() end
```

- Register on `ui` so it's accessible via `LibNUI.MyWidget`
- Add the file to `LibNUI.toc` in the appropriate section

## Conventions

| Thing | Convention |
|---|---|
| Public methods | `PascalCase` |
| Lifecycle hooks / callbacks | `camelCase` (`onLoad`, `onUpdate`, `OnLogin`) |
| Constructor init fields | `camelCase` (`cellWidth`, `headerHeight`) |
| Constants | `ui.edge`, `ui.layer`, `ui.justify`, `ui.wrap` |
| Backing widget | Always `self._widget` |

## Getter/Setter pattern

Methods that read or write a single value should follow the nil-check pattern:

```lua
function MyWidget:Value(v)
  if v == nil then return self._widget:GetValue() end
  self._widget:SetValue(v)
  return self  -- allow chaining when setting
end
```

## What to avoid

- **Don't add standalone utility functions** — everything belongs on a class
- **Don't add defensive nil-checks for internal invariants** — trust that callers pass valid options
- **Don't add error handling for WoW API calls** — let errors surface naturally in-game
- **Don't create new files for one-off helpers** — put it on the relevant class
- **Don't use `self._widget` from outside a class** — expose a method instead
- **Don't break the getter/setter pattern** — no separate `GetFoo`/`SetFoo` pairs

## Secure frames

`SecureButton` uses `SecureActionButtonTemplate`. Never call `SetAttribute` on it during combat (taint). `special = true` on `Frame` registers it as a `UISpecialFrame` (Escape key closes it) and puts the widget in `_G` — only use for top-level addon windows.

## position table reference

```lua
position = {
  TopLeft  = {target, "TOPLEFT", x, y},  -- SetPoint args
  Width    = 100,                          -- scalar → called as self:Width(100)
  All      = true,                         -- SetAllPoints
  Hide     = true,                         -- Hide after anchoring
}
```

Any key that maps to a method on `Region` is valid. Values are unpacked if a table, called directly if scalar, skipped if `false`.
