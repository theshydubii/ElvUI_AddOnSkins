local E, _, _, _, _ = unpack(ElvUI)
local S = E:GetModule("Skins")
local AS = E:GetModule("AddOnSkins")

if not AS:IsAddonLODorEnabled("!PFPSave") then return end

S:AddCallbackForAddon("!PFPSave", "Skin_PFPSave", function()
	_G.PFPSave_SkinDialog = function(frame)
		if frame.PFPSaveSkinned then return end
		frame.PFPSaveSkinned = true

		frame:StripTextures()
		frame:SetTemplate("Transparent")

		S:HandleCheckBox(frame.PFPSaveAccountCheck)
		S:HandleCheckBox(frame.PFPSaveCharacterCheck)
		S:HandleCheckBox(frame.PFPSaveMacroCheck)
		S:HandleCheckBox(frame.PFPSaveBindingCheck)
		S:HandleButton(frame.PFPSaveApply)
		S:HandleButton(frame.PFPSaveCancel)
	end
end, true)