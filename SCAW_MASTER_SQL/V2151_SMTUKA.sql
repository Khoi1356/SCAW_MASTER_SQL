
CREATE VIEW [dbo].[V2151_SMTUKA]
AS
SELECT                      'RRC' AS FCOMPANYCD, Currency_Code AS FTUKACD, 'en' AS FLNGKB, Currency_Name AS FTUKAMEI, Currency_Code AS FKIGO, FGAIKAFLG, FGAIKAHASUSHORIKB, FGAIKASHOSUKETAKB
FROM                         dbo.[2151_Currency]
