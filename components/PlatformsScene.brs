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
  m.grid.observeField("itemSelected", "onPlatformSelected")
  loadPlatforms()
end sub

sub loadPlatforms()
  m.task = CreateObject("roSGNode", "HttpTask")
  m.task.observeField("response", "onPlatformsLoaded")
  m.task.url = m.global.serverUrl + "/api/platforms"
  m.task.headers = {"Authorization": "Bearer " + m.global.token}
  m.task.control = "RUN"
end sub

sub onPlatformsLoaded()
  response = m.task.response
  if response.code = 200
    platforms = ParseJson(response.body)
    if platforms <> invalid
      content = CreateObject("roSGNode", "ContentNode")
      for each platform in platforms
        item = content.createChild("ContentNode")
        item.title = platform.name
        item.HDPosterUrl = m.global.serverUrl + "/assets/platform/" + platform.slug + "/logo.png"
        item.addFields({platform: platform})
      end for
      m.grid.content = content
    else
      showDialog("Error", "Invalid platforms data.")
    end if
  else
    showDialog("Error", "Failed to load platforms: " + StrI(response.code))
  end if
  m.task = invalid
end sub

sub onPlatformSelected()
  selectedIndex = m.grid.itemSelected
  platform = m.grid.content.getChild(selectedIndex).platform
  showRomsScene(platform)
end sub

sub showDialog(title as string, message as string)
  dialog = CreateObject("roSGNode", "Dialog")
  dialog.title = title
  dialog.message = message
  dialog.buttons = ["OK"]
  m.top.dialog = dialog
end sub

sub showRomsScene(platform as object)
  romsScene = m.top.getScene().createScene("RomsScene")
  romsScene.platform = platform
end sub