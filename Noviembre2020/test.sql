

DECLARE @IP varchar(15) = '123.131.132.123'
	
IF @IP LIKE '%(?:[0-9]{1,3}\.){3}[0-9]{1,3}%'
	SELECT @IP


IF @IP LIKE '([0-9]{1,3}\.){3}[0-9]{1,3}'
	SELECT @IP

DECLARE @IP varchar(15) = '1.1.1.1'


SELECT * 
FROM EQUIPOS
WHERE EqpIP LIKE     '%_.%_.%_.%_'  -- 3 periods and no empty octets 
    AND EqpIP NOT LIKE '%.%.%.%.%'  -- not 4 periods or more 
    AND EqpIP NOT LIKE '%[0-9][0-9][0-9][0-9]%'  -- not more than 3 digits per octet 
    AND EqpIP NOT LIKE '%[3-9][0-9][0-9]%'  -- NOT 300 - 999 
    AND EqpIP NOT LIKE '%2[6-9][0-9]%'  -- NOT 260 - 299 
    AND EqpIP NOT LIKE '%25[6-9]%'  -- NOT 256 - 259 


ALTER TABLE EQUIPOS add CONSTRAINT CK__EQUIPOS__EqpIP__440B1D61 CHECK( EqpIP LIKE     '%_.%_.%_.%_'  -- 3 periods and no empty octets 
		AND EqpIP NOT LIKE '%.%.%.%.%'  -- not 4 periods or more 
		AND EqpIP NOT LIKE '%[0-9][0-9][0-9][0-9]%'  -- not more than 3 digits per octet 
		AND EqpIP NOT LIKE '%[3-9][0-9][0-9]%'  -- NOT 300 - 999 
		AND EqpIP NOT LIKE '%2[6-9][0-9]%'  -- NOT 260 - 299 
		AND EqpIP NOT LIKE '%25[6-9]%')






