unit uSEO;

interface

type
  TSeoType = (stSite, stLink, stKeyword, stSpider);

  TSEO = class(TObject)
  public
    FName: string;
    FTarget: string;
    FCharSet: string;
    FSiteUrl: string;
    FSiteExpr: string;
    FLinkUrl: string;
    FLinkExpr: string;
    FKeyUrl: string;
    FKeyExpr: string;
    FKeyPages: integer;
  end;

implementation

end.
