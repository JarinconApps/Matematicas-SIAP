object moduloPracticaDocente: TmoduloPracticaDocente
  OldCreateOrder = False
  Height = 410
  Width = 393
  object toMD5: TMD5
    Left = 80
    Top = 64
  end
  object SMTP: TIdSMTP
    IOHandler = SSL
    Host = 'smtp.gmail.com'
    Password = 'donmatematicas'
    Port = 587
    SASLMechanisms = <>
    UseTLS = utUseExplicitTLS
    Username = 'jarincon@uniquindio.edu.co'
    Left = 80
    Top = 120
  end
  object DATA: TIdMessage
    AttachmentEncoding = 'UUE'
    BccList = <>
    CCList = <>
    Encoding = meDefault
    FromList = <
      item
      end>
    Recipients = <
      item
      end>
    ReplyTo = <>
    ConvertPreamble = True
    Left = 81
    Top = 192
  end
  object SSL: TIdSSLIOHandlerSocketOpenSSL
    Destination = 'smtp.gmail.com:587'
    Host = 'smtp.gmail.com'
    MaxLineAction = maException
    Port = 587
    DefaultPort = 0
    SSLOptions.Mode = sslmUnassigned
    SSLOptions.VerifyMode = []
    SSLOptions.VerifyDepth = 0
    Left = 81
    Top = 264
  end
end
