--[[
Copyright 2013 Wiremod Developers
https://github.com/wiremod/

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
]]--

if VERSION < 140403 and VERSION > 5 then
	-- VERSION > 5 check added June 2013, to address issues regarding the Steampipe update sometimes setting VERSION to 1.
	ErrorNoHalt("WireMod: This branch of wiremod only supports Gmod13+.\n")
	return
end

if SERVER then
	-- this file
	AddCSLuaFile("autorun/wire_load.lua")

	-- shared includes
	AddCSLuaFile("wire/wire_paths.lua")
	AddCSLuaFile("wire/wireshared.lua")
	AddCSLuaFile("wire/wiregates.lua")
	AddCSLuaFile("wire/wiremonitors.lua")
	AddCSLuaFile("wire/gpulib.lua")
	AddCSLuaFile("wire/timedpairs.lua")
	AddCSLuaFile("wire/flir.lua")
	AddCSLuaFile("wire/von.lua")
	AddCSLuaFile("wire/sh_modelplug.lua")

	-- client includes
	AddCSLuaFile("wire/client/cl_wirelib.lua")
	AddCSLuaFile("wire/client/cl_modelplug.lua")
	AddCSLuaFile("wire/client/cl_wire_map_interface.lua")
	AddCSLuaFile("wire/client/wiredermaexts.lua")
	AddCSLuaFile("wire/client/wiremenus.lua")
	AddCSLuaFile("wire/client/wire_expression2_browser.lua")
	AddCSLuaFile("wire/client/wire_filebrowser.lua")
	AddCSLuaFile("wire/client/wire_listeditor.lua")
	AddCSLuaFile("wire/client/wire_soundpropertylist.lua")
	AddCSLuaFile("wire/client/e2helper.lua")
	AddCSLuaFile("wire/client/e2descriptions.lua")
	AddCSLuaFile("wire/client/e2_extension_menu.lua")
	AddCSLuaFile("wire/client/e2_viewrequest_menu.lua")
	AddCSLuaFile("wire/client/gmod_tool_auto.lua")
	AddCSLuaFile("wire/client/sound_browser.lua")
	AddCSLuaFile("wire/client/thrusterlib.lua")
	AddCSLuaFile("wire/client/rendertarget_fix.lua")
	AddCSLuaFile("wire/client/customspawnmenu.lua")

	-- text editor
	AddCSLuaFile("wire/client/text_editor/issue_viewer.lua")
	AddCSLuaFile("wire/client/text_editor/texteditor.lua")
	AddCSLuaFile("wire/client/text_editor/wire_expression2_editor.lua")

	for _, filename in ipairs(file.Find("wire/client/text_editor/modes/*.lua","LUA")) do
		AddCSLuaFile("wire/client/text_editor/modes/" .. filename)
	end

	if CreateConVar("wire_force_workshop", 1, {FCVAR_ARCHIVE}, "Should Wire force all clients to download the Workshop edition of Wire, for models? (requires restart to disable)"):GetBool() then
		resource.AddWorkshop("160250458")
	end
  	resource.AddFile("resource/fonts/alphalcd.ttf")
end

-- shared includes
include("wire/sh_modelplug.lua")
include("wire/wireshared.lua")
include("wire/wire_paths.lua")
include("wire/wiregates.lua")
include("wire/wiremonitors.lua")
include("wire/gpulib.lua")
include("wire/timedpairs.lua")
include("wire/flir.lua")
include("wire/von.lua")

-- server includes
if SERVER then
	include("wire/server/wirelib.lua")
	include("wire/server/modelplug.lua")
	include("wire/server/debuggerlib.lua")
end

-- client includes
if CLIENT then
	include("wire/client/cl_wirelib.lua")
	include("wire/client/cl_modelplug.lua")
	include("wire/client/cl_wire_map_interface.lua")
	include("wire/client/wiredermaexts.lua")
	include("wire/client/wiremenus.lua")
	include("wire/client/text_editor/texteditor.lua")
	include("wire/client/wire_expression2_browser.lua")
	include("wire/client/text_editor/issue_viewer.lua")
	include("wire/client/text_editor/wire_expression2_editor.lua")
	include("wire/client/wire_filebrowser.lua")
	include("wire/client/wire_listeditor.lua")
	include("wire/client/wire_soundpropertylist.lua")
	include("wire/client/e2helper.lua")
	include("wire/client/e2descriptions.lua")
	include("wire/client/e2_extension_menu.lua")
	include("wire/client/e2_viewrequest_menu.lua")
	include("wire/client/gmod_tool_auto.lua")
	include("wire/client/sound_browser.lua")
	include("wire/client/thrusterlib.lua")
	include("wire/client/rendertarget_fix.lua")
	include("wire/client/customspawnmenu.lua")
end

-- Load UWSVN, done here so its definitely after Wire is loaded.
if file.Find("wire/uwsvn_load.lua","LUA")[1] then
	if SERVER then AddCSLuaFile( "wire/uwsvn_load.lua" ) end
	include("wire/uwsvn_load.lua")
end

if SERVER then print("Wiremod Version '"..WireLib.GetVersion().."' loaded") end
