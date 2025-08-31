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
  playerUrl = m.global.serverUrl + "/player/emulatorjs/" + m.top.rom.platform_slug + "/" + m.top.rom.file_name
  m.htmlWidget = CreateObject("roHtmlWidget", 0, 0, 1920, 1080)
  m.htmlWidget.SetUrl(playerUrl)
  headers = {"Authorization": "Bearer " + m.global.token}
  m.htmlWidget.SetHeaders(headers)
  if m.global.cookies.count() > 0
    m.htmlWidget.AddCookies(m.global.cookies)
  end if
  m.htmlWidget.EnableJavascript(true)
  m.htmlWidget.EnableCookies(true)
  m.htmlWidget.Show()
  m.top.appendChild(m.htmlWidget)
  m.htmlWidget.setFocus(true)
end sub