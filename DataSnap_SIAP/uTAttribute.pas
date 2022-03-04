unit uTAttribute;

interface

uses classes;

type
  TTypeAttribute = (taString, taVideo, taInteger, taFloat, taBoolean, taDate,
    taMemo, taModel,taPassword);

  TAttribute = class(Tobject)
  private
    FTypeAttribute: TTypeAttribute;
    FAttribute: string;
    procedure setAttribute(const Value: String);
    procedure setTypeAttribute(const Value: TTypeAttribute);
  public
    constructor create;
    destructor destroy; override;

  published
    property Attribute: string read FAttribute write setAttribute;
    property TypeAttribute: TTypeAttribute read FTypeAttribute
      write setTypeAttribute;
  end;

implementation

{ TAttribute }

constructor TAttribute.create;
begin

end;

destructor TAttribute.destroy;
begin

  inherited destroy;
end;

procedure TAttribute.setAttribute(const Value: String);
begin
  FAttribute := Value;
end;

procedure TAttribute.setTypeAttribute(const Value: TTypeAttribute);
begin
  FTypeAttribute := Value;
end;

end.
