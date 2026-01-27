
SELECT FORMAT(GETDATE(), 'yyyy-MM-dd') endTime,
			FORMAT(DATEADD(MONTH, -1, GETDATE()), 'yyyy-MM-dd') AS startTime,
			FORMAT(GETDATE(), 'yyyy-MM-dd')+'^'+FORMAT(DATEADD(MONTH, -1, GETDATE()), 'yyyy-MM-dd') start2end,
			'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:drgs="http://drgs.service.mediway.com.cn" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"> <soapenv:Header> <wsse:Security> <wsse:UsernameToken>  <wsse:Username>dhwebservice</wsse:Username> <wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">F24UmUb%3C</wsse:Password> </wsse:UsernameToken>  </wsse:Security> </soapenv:Header> <soapenv:Body> <drgs:QryAdmByUnionDate> <drgs:param>'+FORMAT(GETDATE(), 'yyyy-MM-dd')+'^'+FORMAT(DATEADD(MONTH, -1, GETDATE()), 'yyyy-MM-dd')+'</drgs:param> </drgs:QryAdmByUnionDate> </soapenv:Body></soapenv:Envelope>' xmlParam
;