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

sub Main(args as dynamic)
  screen = CreateObject("roSGScreen")
  m.port = CreateObject("roMessagePort")
  screen.setMessagePort(m.port)
  m.scene = screen.createScene("LoginScene")
  screen.show()

  while (true)
    msg = wait(0, m.port)
    if (type(msg) = "roSGScreenEvent")
      if (msg.isScreenClosed()) return
    end if
  end while
end sub