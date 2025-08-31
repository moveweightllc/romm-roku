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
  m.top.functionName = "executeRequest"
end sub

sub executeRequest()
  urlTransfer = CreateObject("roUrlTransfer")
  urlTransfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
  urlTransfer.InitClientCertificates()
  urlTransfer.SetUrl(m.top.url)
  urlTransfer.SetRequest(m.top.method)

  if m.top.headers <> invalid
    for each key in m.top.headers
      urlTransfer.AddHeader(key, m.top.headers[key])
    end for
  end if

  code = -1
  body = ""
  headers = {}

  if m.top.method = "POST" or m.top.method = "PUT"
    success = urlTransfer.PostFromString(m.top.body)
    code = urlTransfer.GetResponseCode()
    body = urlTransfer.GetToString()
  else
    body = urlTransfer.GetToString()
    code = urlTransfer.GetResponseCode()
  end if

  headers = urlTransfer.GetResponseHeadersArray()
  m.top.response = {code: code, body: body, headers: headers}
end sub