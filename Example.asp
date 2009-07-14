<!--#include file="CreditCardFraudDetection.class.asp"-->
<pre>
<%
	dim ccfs
	set ccfs = new CreditCardFraudDetection

	dim h
	set h = CreateObject("Scripting.Dictionary")

	'Enter your license key here
'	h.Add "license_key", ""

	' Required fields
	h.Add "i", "24.24.24.24"				' set the client ip address
	h.Add "city", "New York"				' set the billing city
	h.Add "region", "NY"					' set the billing state
	h.Add "postal", "10011"					' set the billing zip code
	h.Add "country", "US"					' set the billing country

	' Recommended fields
	h.Add "domain", "yahoo.com"				' Email domain
	h.Add "bin", "549099"					' bank identification number (6 digits)
	h.Add "binName", "MBNA America Bank"	' bank name
	h.Add "binPhone", "800-421-2110"		' bank customer service phone number on back of credit card
	h.Add "custPhone", "212-242"			' Area-code and local prefix of customer phone number

	ccfs.debug = 0
	ccfs.isSecure = 1
	ccfs.timeout = 5
	ccfs.input(h)
	ccfs.query()

	'Print out the result
	dim ret, outputkeys, numoutputkeys
	Set ret = ccfs.output()
	outputkeys = ret.Keys
	numoutputkeys = ret.Count

	for i = 0 to numoutputkeys-1
		key = outputkeys(i)
		value = ret.Item(key)

		response.write(key&" = "&value&vbCrlf)
	next
%>
</pre>