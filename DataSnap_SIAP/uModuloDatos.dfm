object moduloDatos: TmoduloDatos
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 705
  Width = 892
  object Conexion: TFDConnection
    Params.Strings = (
      'Database=siap'
      'User_Name=postgres'
      'Password=5716f2746fdaf169c38b4b5d79f7d810'
      'CharacterSet=UTF8'
      'DriverID=PG')
    FetchOptions.AssignedValues = [evMode, evRowsetSize]
    FetchOptions.Mode = fmAll
    FetchOptions.RowsetSize = 1000000
    LoginPrompt = False
    Left = 40
    Top = 32
  end
  object Encriptador: TMD5
    Left = 280
    Top = 72
  end
end
