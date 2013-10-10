<!--#include file="CreditCardFraudDetection.class.asp"-->
<pre>
<%
    dim ccfs
    set ccfs = new CreditCardFraudDetection

    dim h
    set h = CreateObject("Scripting.Dictionary")

    'Enter your license key here
   h.Add "license_key", "YOUR_LICENSE_KEY"

    ' Required fields
    h.Add "i", "24.24.24.24"                ' set the client ip address
    h.Add "city", "New York"                ' set the billing city
    h.Add "region", "NY"                    ' set the billing state
    h.Add "postal", "10011"                 ' set the billing zip code
    h.Add "country", "US"                   ' set the billing country'

    ' Shipping Address
    h.Add "shipAddr", "531 121st St."
    h.Add "shipCity", "New York"
    h.Add "shipRegion", "NY"
    h.Add "shipPostal", "10011"
    h.Add "shipCountry", "US"'

    ' User Data
    h.Add "domain", "gmail.com"
    h.Add "custPhone", "212-242"            ' Area-code and local prefix of customer phone number
    h.Add "emailMD5", "93942e96f5acd83e2e047ad8fe03114d"
    h.Add "usernameMD5", "098f6bcd4621d373cade4e832627b4f6"
    h.Add "passwordMD5", "098f6bcd4621d373cade4e832627b4f6"'

    ' Bank Data
    h.Add "bin", "549099"                   ' bank identification number (6 digits)
    h.Add "binName", "MBNA America Bank"    ' bank name
    h.Add "binPhone", "800-421-2110"        ' bank customer service phone number on back of credit card'

    ' Transaction Linking
    h.Add "sessionID", "id42352"
    h.Add "user_agent", "Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/30.0.1599.69 Safari/537.36"
    h.Add "accept_language", "da, en-gb;q=0.8, en;q=0.7"'

    ' Transaction Information
    h.Add "txnID", "txn32141"
    h.Add "order_amount", "432.21"
    h.Add "order_currency", "USD"
    h.Add "shopID", "shop identification"
    h.Add "txn_type", "creditcard"'

    ' Credit Card Check
    h.Add "avs_result", "Y"
    h.Add "cvv_result", "N"'

    ' Miscellaneous
    h.Add "requested_type", "premium"
    h.Add "forwardedIP", "24.24.24.23"


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
