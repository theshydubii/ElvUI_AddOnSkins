local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")
local AS = E:GetModule("AddOnSkins")

if not AS:IsAddonLODorEnabled("WeakAuras") then return end

S:AddCallbackForAddon("WeakAuras", "WeakAuras", function()
	if WeakAuras.IsCorrectVersion then return end
	if not E.private.addOnSkins.WeakAuras then return end

	local function Skin_WeakAuras(frame, ftype)
		if not frame.backdrop then
			frame:CreateBackdrop("Transparent")
			frame.icon:SetTexCoord(unpack(E.TexCoords))
			frame.icon.SetTexCoord = E.noop
		end

		if ftype == "aurabar" then
			if not E.db.addOnSkins.weakAuraAuraBar then
				frame.backdrop:Hide()
			else
				frame.backdrop:Show()
			end
		elseif ftype == "icon" then
			if E.db.addOnSkins.weakAuraIconCooldown then
				frame.cooldown.CooldownOverride = "global"
				E:RegisterCooldown(frame.cooldown)
			end
		end
	end

	local Create_Icon, Modify_Icon = WeakAuras.regionTypes.icon.create, WeakAuras.regionTypes.icon.modify
	local Create_AuraBar, Modify_AuraBar = WeakAuras.regionTypes.aurabar.create, WeakAuras.regionTypes.aurabar.modify

	WeakAuras.regionTypes.icon.create = function(parent, data)
		local region = Create_Icon(parent, data)
		Skin_WeakAuras(region, "icon")
		return region
	end

	WeakAuras.regionTypes.aurabar.create = function(parent)
		local region = Create_AuraBar(parent)
		Skin_WeakAuras(region, "aurabar")
		return region
	end

	WeakAuras.regionTypes.icon.modify = function(parent, region, data)
		Modify_Icon(parent, region, data)
		Skin_WeakAuras(region, "icon")
	end

	WeakAuras.regionTypes.aurabar.modify = function(parent, region, data)
		Modify_AuraBar(parent, region, data)
		Skin_WeakAuras(region, "aurabar")
	end

	for weakAura in pairs(WeakAuras.regions) do
		if WeakAuras.regions[weakAura].regionType == "icon"
		or WeakAuras.regions[weakAura].regionType == "aurabar"
		then
			Skin_WeakAuras(WeakAuras.regions[weakAura].region, WeakAuras.regions[weakAura].regionType)
		end
	end
end)

local function Skin_WeakAurasOptions()
	if WeakAuras.IsCorrectVersion or not E.private.addOnSkins.WeakAuras then return end

	local function SkinDisplayButton(button)
		if button and button.frame then
			S:HandleButton(button.frame, false, nil, true)
		end
	end

	local function SkinGroup(group)
		if not group or not group.frame then return end

		group.frame:StripTextures()
		group.frame:SetTemplate("Transparent")

		local border = group.content and group.content:GetParent()
		if border then
			border:StripTextures()
			border:SetTemplate("Transparent")
		end
	end

	local function SkinOptionsFrame()
		local frame = WeakAurasOptions
		if not frame or frame.addOnSkinsSkinned then return end

		frame:StripTextures()
		frame:SetTemplate("Transparent")
		frame.addOnSkinsSkinned = true

		if frame.CloseButton then
			S:HandleCloseButton(frame.CloseButton)
		end

		if frame.filterInput then
			S:HandleEditBox(frame.filterInput)
		end

		SkinGroup(frame.buttonsContainer)
		SkinGroup(frame.container)

		if frame.toolbarContainer then
			for _, button in ipairs({frame.toolbarContainer:GetChildren()}) do
				S:HandleButton(button, false, nil, true)
			end
		end

		if frame.buttonsScroll and not frame.buttonsScroll.addOnSkinsHooked then
			frame.buttonsScroll.addOnSkinsHooked = true
			hooksecurefunc(frame.buttonsScroll, "AddChild", function(_, button)
				SkinDisplayButton(button)
			end)
		end

		for _, button in ipairs(frame.buttonsScroll and frame.buttonsScroll.children or {}) do
			SkinDisplayButton(button)
		end
	end

	hooksecurefunc(WeakAuras, "ShowOptions", SkinOptionsFrame)
	SkinOptionsFrame()
end

S:AddCallbackForAddon("WeakAurasOptions", "WeakAurasOptions", Skin_WeakAurasOptions)