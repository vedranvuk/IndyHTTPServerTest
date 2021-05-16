program IndyHTTPServerTest;

uses
  System.SysUtils,
  IdContext,
  IdCustomHTTPServer,
  WinAPi.Windows;

type
  TMyHTTPServer = class(TIdCustomHTTPServer)
  protected
    procedure DoCommandGet(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo); override;
  end;

var
  StopEvent: THandle;

  { TMyHTTPServer }

procedure TMyHTTPServer.DoCommandGet(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
begin
  inherited;
  if (ARequestInfo.URI = '/stop') then
  begin
    SetEvent(StopEvent);
    Exit;
  end;
  AResponseInfo.ContentText := 'Hello World!';
end;

var
  LHTTPServer: TMyHTTPServer;

begin
  if (ParamCount < 1) then
  begin
    Writeln('Usage:');
    Writeln('IndyHTTPServerTest.exe <ListenPort>');
    Exit;
  end;
  LHTTPServer := TMyHTTPServer.Create(nil);
  try
    StopEvent := CreateEvent(nil, False, False, 'StopEvent');
    LHTTPServer.DefaultPort := ParamStr(1).ToInteger;
    LHTTPServer.Active := True;
    WaitForSingleObject(StopEvent, INFINITE);
    LHTTPServer.Active := False;
  finally
    LHTTPServer.Free;
  end;
end.
