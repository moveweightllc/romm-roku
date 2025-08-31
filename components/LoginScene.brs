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
  m.global = m.top.getScene().global
  m.global.addFields({
    serverUrl: "https://romm.moveweight.com",
    username: "",
    password: "",
    token: "",
    cookies: []
  })

  m.titleLabel = m.top.findNode("titleLabel")
  m.serverButton = m.top.findNode("serverButton")
  m.serverLabel = m.top.findNode("serverLabel")
  m.userButton = m.top.findNode("userButton")
  m.userLabel = m.top.findNode("userLabel")
  m.passButton = m.top.findNode("passButton")
  m.passLabel = m.top.findNode("passLabel")
  m.loginButton = m.top.findNode("loginButton")

  m.serverButton.observeField("buttonSelected", "onSetServer")
  m.userButton.observeField("buttonSelected", "onSetUsername")
  m.passButton.observeField("buttonSelected", "onSetPassword")
  m.loginButton.observeField("buttonSelected", "onLogin")
  updateLabels()
end sub

sub updateLabels()
  m.serverLabel.text = m.global.serverUrl
  m.userLabel.text = m.global.username
  m.passLabel.text = m.global.password <> "" ? "(hidden)" : "Not set"
end sub

sub onSetServer()
  keyboard = CreateObject("roSGNode", "KeyboardDialog")
  keyboard.title = "Enter Server URL (e.g., https://romm.moveweight.com)"
  keyboard.text = m.global.serverUrl
  keyboard.buttons = ["OK", "Cancel"]
  m.top.dialog = keyboard
  keyboard.observeField("buttonSelected", "onServerDialogClosed")
end sub

sub onServerDialogClosed(msg)
  if m.top.dialog.buttonSelected = 0
    url = m.top.dialog.text
    if url <> "" and (url.left(7) = "http://" or url.left(8) = "https://")
      m.global.serverUrl = url
      updateLabels()
    else
      showDialog("Error", "Invalid URL. Use http:// or https://")
    end if
  end if
  m.top.dialog.close = true
end sub

sub onSetUsername()
  keyboard = CreateObject("roSGNode", "KeyboardDialog")
  keyboard.title = "Enter Username"
  keyboard.text = m.global.username
  keyboard.buttons = ["OK", "Cancel"]
  m.top.dialog = keyboard
  keyboard.observeField("buttonSelected", "onUsernameDialogClosed")
end sub

sub onUsernameDialogClosed(msg)
  if m.top.dialog.buttonSelected = 0
    m.global.username = m.top.dialog.text
    updateLabels()
  end if
  m.top.dialog.close = true
end sub

sub onSetPassword()
  keyboard = CreateObject("roSGNode", "KeyboardDialog")
  keyboard.title = "Enter Password"
  keyboard.text = m.global.password
  keyboard.buttons = ["OK", "Cancel"]
  keyboard.textEditBox.secureMode = true
  m.top.dialog = keyboard
  keyboard.observeField("buttonSelected", "onPasswordDialogClosed")
end sub

sub onPasswordDialogClosed(msg)
  if m.top.dialog.buttonSelected = 0
    m.global.password = m.top.dialog.text
    updateLabels()
  end if
  m.top.dialog.close = true
end sub

sub onLogin()
  if m.global.serverUrl = "" or m.global.username = "" or m.global.password = ""
    showDialog("Error", "All fields are required.")
    return
  end if

  m.loginTask = CreateObject("roSGNode", "HttpTask")
  m.loginTask.observeField("response", "onLoginResponse")
  m.loginTask.url = m.global.serverUrl + "/api/auth/signin"
  m.loginTask.method = "POST"
  m.loginTask.body = FormatJson({username: m.global.username, password: m.global.password})
  m.loginTask.headers = {"Content-Type": "application/json"}
  m.loginTask.control = "RUN"
end sub

sub onLoginResponse()
  response = m.loginTask.response
  if response.code = 200
    data = ParseJson(response.body)
    if data <> invalid and data.access_token <> invalid
      m.global.token = data.access_token
      cookies = []
      headers = response.headers
      for each header in headers
        if LCase(header) = "set-cookie"
          cookieParts = headers[header].Split(";")[0].Split("=")
          if cookieParts.count() > 1
            cookies.push({name: cookieParts[0].trim(), value: cookieParts[1].trim(), domain: ".moveweight.com", path: "/"})
          end if
        end if
      end for
      m.global.cookies = cookies
      showPlatformsScene()
    else
      showDialog("Login Failed", "Invalid response from server.")
    end if
  else
    showDialog("Login Failed", "Error " + StrI(response.code) + ": " + response.body)
  end if
  m.loginTask = invalid
end sub

sub showDialog(title as string, message as string)
  dialog = CreateObject("roSGNode", "Dialog")
  dialog.title = title
  dialog.message = message
  dialog.buttons = ["OK"]
  m.top.dialog = dialog
end sub

sub showPlatformsScene()
  screen = m.top.getScene()
  screen.createScene("PlatformsScene")
end sub