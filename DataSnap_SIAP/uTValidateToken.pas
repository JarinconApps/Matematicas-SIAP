unit uTValidateToken;

interface

uses classes, System.SysUtils, System.json, IdHashMessageDigest, idHash,
  IdGlobal, dialogs, Vcl.ExtCtrls;

type
  /// <author>Julián Andrés Rincón Penagos</author>
  TValidateToken = class(tobject)
  private
    FSecret: string;
    FCodeExpire: string;
    FExpiresIn: integer;
    FHeader: TJSONObject;
    tokenExpire: TTimer;
    countExpire: integer;

    procedure setSecret(const Value: string);
    procedure setExpiresIn(const Value: integer);

    procedure timeExpire(Sender: tobject);

    function toMd5(ss: string): string;
    function Encode64(S: string): string;
    function Decode64(S: string): string;
  public
    constructor create(App, Author: string);
    destructor destroy; override;

    function generateToken(payload: TJSONObject): string;
    function compare(Token: string): boolean;
    function generateNewRules: string;
    function generatePayload(id, nombre, correo: string): TJSONObject;
  published
    property Secret: string read FSecret write setSecret;
    property ExpiresIn: integer read FExpiresIn write setExpiresIn;
  end;

const
  Codes64 = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz+/';

implementation

{ TValidateToken }

constructor TValidateToken.create(App, Author: string);
begin
  FHeader := TJSONObject.create;
  FHeader.AddPair('Application', App);
  FHeader.AddPair('Author', Author);

  tokenExpire := TTimer.create(nil);
  tokenExpire.Interval := 1000;
  tokenExpire.OnTimer := timeExpire;
  countExpire := 0;

  generateNewRules;
end;

destructor TValidateToken.destroy;
begin

  inherited create;
end;

function TValidateToken.generateNewRules: string;
var
  i: integer;
begin
  Result := '';

  for i := 1 to 32 do
  begin
    Result := Result + Codes64[Random(length(Codes64))];
  end;

  FCodeExpire := Result;
end;

function TValidateToken.generatePayload(id, nombre, correo: string)
  : TJSONObject;
begin
  Result := TJSONObject.create;
  Result.AddPair('Id', id);
  Result.AddPair('Nombre', nombre);
  Result.AddPair('Correo', correo);
end;

function TValidateToken.generateToken(payload: TJSONObject): string;
var
  Header, sPayLoad, Signature: string;
begin
  Header := Encode64(FHeader.ToString);
  sPayLoad := Encode64(payload.ToString);
  Signature := toMd5(Header + sPayLoad + FSecret + FCodeExpire);
  Result := Header + '.' + sPayLoad + '.' + Signature;
end;

procedure TValidateToken.setExpiresIn(const Value: integer);
begin
  FExpiresIn := Value;
end;

procedure TValidateToken.setSecret(const Value: string);
begin
  FSecret := Value;
end;

procedure TValidateToken.timeExpire(Sender: tobject);
begin
  Inc(countExpire);

  if countExpire > FExpiresIn then
  begin

  end;

end;

function TValidateToken.toMd5(ss: string): string;
var
  hashMessageDigest5: TIdHashMessageDigest5;
begin
  hashMessageDigest5 := nil;
  try
    hashMessageDigest5 := TIdHashMessageDigest5.create;
    Result := IdGlobal.IndyLowerCase(hashMessageDigest5.HashStringAsHex(ss));
  finally
    hashMessageDigest5.Free;
  end;
end;

function TValidateToken.compare(Token: string): boolean;
var
  Parts: TStringList;
  Header, payload, Signature, Validated: string;
begin
  if Token = '' then
  begin
    Result := false;
    exit;
  end;

  Parts := TStringList.create;
  Parts.Delimiter := '.';
  Parts.DelimitedText := Token;

  Header := Parts[0];
  payload := Parts[1];
  Signature := Parts[2];

  Validated := toMd5(Header + payload + FSecret + FCodeExpire);

  Result := Signature = Validated;
end;

function TValidateToken.Encode64(S: string): string;
var
  i: integer;
  a: integer;
  x: integer;
  b: integer;
begin
  Result := '';
  a := 0;
  b := 0;
  for i := 1 to length(S) do
  begin
    x := Ord(S[i]);
    b := b * 256 + x;
    a := a + 8;
    while a >= 6 do
    begin
      a := a - 6;
      x := b div (1 shl a);
      b := b mod (1 shl a);
      Result := Result + Codes64[x + 1];
    end;
  end;
  if a > 0 then
  begin
    x := b shl (6 - a);
    Result := Result + Codes64[x + 1];
  end;
end;

function TValidateToken.Decode64(S: string): string;
var
  i: integer;
  a: integer;
  x: integer;
  b: integer;
begin
  Result := '';
  a := 0;
  b := 0;
  for i := 1 to length(S) do
  begin
    x := Pos(S[i], Codes64) - 1;
    if x >= 0 then
    begin
      b := b * 64 + x;
      a := a + 6;
      if a >= 8 then
      begin
        a := a - 8;
        x := b shr a;
        b := b mod (1 shl a);
        x := x mod 256;
        Result := Result + chr(x);
      end;
    end
    else
      exit;
  end;
end;

end.
