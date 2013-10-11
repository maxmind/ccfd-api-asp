# Release Notes

## 1.50.0 (2013-10-11)
* Updated minFraud inputs for minFraud 1.3.
* Brought versioning in line with other minFraud APIs.

## 1.2.5 (2013-03-13)
* Check countryMatch instead of score. Score is only available for
  minfraud_version <= 1.2 ( Boris Zentner )

## 1.2.4 (2011-01-16)
* Add minfraud2 back to the server list ( Boris Zentner )

## 1.2.3 (2009-07-24)
* Add new fields requested_type, forwardedIP, emailMD5, usernameMD5,
  passwordMD5, shipAddr, shipCity, shipRegion, shipPosta,l shipCountry, txnID,
  sessionID, user_agent, accept_language. ( Boris Zentner )
* Use minfraud servers minfraud1 and minfraud3. __Not__ minfraud2 ( Boris
  Zentner )

## 1.2.2 (2008-01-10)
* Updated code to use new minfraud1.maxmind.com server

## 1.2.1 (2004-08-15)
* Converted PHP code to ASP using Msxml2.ServerXMLHTTP in place of Curl and
  Dictionary Objects in place of Hashed Arrays.
* Added in better error handling, script will not die on connection/invalid
  data failures, instead it will add an item err with a description of the
  error.
