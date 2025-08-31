' RomM Viewer
' Copyright (C) 2025 MoveWeight LLC
'
' This program is free software: you can redistribute it and/or modify
' it under the terms of the GNU General Public License as published by
' the Free Software Foundation, either version 3 of the License, or
' (at your option) any later version.
'
' This program is distributed in the hope that it will be useful,
' but WITHOUT ANY WARRANTY; without even the implied warranty of
' MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
' GNU General Public License for more details.
'
' You should have received a copy of the GNU General Public License
' along with this program.  If not, see <https://www.gnu.org/licenses/>.

sub init()
  m.grid = m.top.findNode("grid")
  m.grid.observeField("itemSelected", "onRomSelected")
  loadRoms()
end sub

sub loadRoms()
  m.task = CreateObject("roSGNode", "HttpTask")
  m.task.observeField("response", "onRomsLoaded")
  m.task.url = m.global.serverUrl + "/api/roms?platform=" + m.top.platform.slug
  m.task.headers = {"Authorization": "Bearer " + m.global.token}
  m.task.control = "RUN"
end sub

sub onRomsLoaded()
  response = m.task.response
  if response.code = 200
    roms = ParseJson(response.body)
    if roms <> invalid
      content = CreateObject("roSGNode", "ContentNode")
      for each rom in roms
        item = content.createChild("ContentNode")
        item.title = rom.name
        item.HDPosterUrl = m.global.serverUrl + "/assets/cover/small/" + m.top.platform.slug + "/" + rom.file_name + ".png"
        item.addFields({rom: rom})
      end for
      m.grid.content = content
    else
      showDialog("Error", "Invalid ROMs data.")
    end if
  else
    showDialog("Error", "Failed to load ROMs: " + StrI(response.code))
  end if
  m.task = invalid
end sub

sub onRomSelected()
  selectedIndex = m.grid.itemSelected
  rom = m.grid.content.getChild(selectedIndex).rom
  showEmulatorScene(rom)
end sub

sub showDialog(title as string, message as string)
  dialog = CreateObject("roSGNode", "Dialog")
  dialog.title = title
  dialog.message = message
  dialog.buttons = ["OK"]
  m.top.dialog = dialog
end sub

sub showEmulatorScene(rom as object)
  emulatorScene = m.top.getScene().createScene("EmulatorScene")
  emulatorScene.rom = rom
end sub