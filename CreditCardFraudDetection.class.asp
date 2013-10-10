<%
    ' CreditCardFraudDetection.asp
    '
    ' Copyright (C) 2004 Raging Creations Ltd. (http://www.ragingcreations.com)
    ' Based on original PHP code Copyright (C) 2004 MaxMind LLC
    '
    ' Converted by: Shaun Hawkes (shawkes@ragingcreations.com)
    ' Date: August 15, 2004
    '
    ' This library is free software; you can redistribute it and/or
    ' modify it under the terms of the GNU General Public
    ' License as published by the Free Software Foundation; either
    ' version 2.1 of the License, or (at your option) any later version.
    '
    ' This library is distributed in the hope that it will be useful,
    ' but WITHOUT ANY WARRANTY; without even the implied warranty of
    ' MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    ' Lesser General Public License for more details.
    '
    ' You should have received a copy of the GNU General Public
    ' License along with this library; if not, write to the Free Software
    ' Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

    'Global Configuration Varliables
    dim ccfdServerList, ccfdAPIVersion, ccfdURL, ccfdSecure, ccfdDebug, ccfdLicenseKey
    ccfdServerList    = "minfraud3.maxmind.com,minfraud1.maxmind.com,minfraud2.maxmind.com"
    ccfdAPIVersion    = "ASP/1.2.5" 'Version of the API
    ccfdURL            = "app/ccv2r" 'URL of the webservice
    ccfdSecure        = 1 'Use HTTPS By Default
    ccfdTimeout        = 5 'Set default connection timeout to 5 seconds.
    ccfdDebug        = 0 'Enable/Disable debugging mode.
    ccfdLicenseKey    = "" 'Default MaxMind License Key to use.

    class CreditCardFraudDetection
        public serverlist
        public numservers
        public url
        public queries
        public allowed_fields
        public num_allowed_fields
        public outputstr
        public isSecure
        public timeout
        public debug
        public API_VERSION

        private sub Class_Initialize()
            timeout = ccfdTimeout
            debug = ccfdDebug

            serverlist = split(ccfdServerList,",")
            numservers = uBound(serverlist)+1 'Note: Array's are 0 based.
            API_VERSION = ccfdAPIVersion

            'use HTTPS by default
            isSecure = ccfdSecure

            dim tempDictionary
            set tempDictionary = CreateObject("Scripting.Dictionary")

            'set the allowed_fields hash
            tempDictionary.Add "i", 1
            tempDictionary.Add "city", 1
            tempDictionary.Add "region", 1
            tempDictionary.Add "postal", 1
            tempDictionary.Add "country", 1
            tempDictionary.Add "license_key", 1

            tempDictionary.Add "shipAddr", 1
            tempDictionary.Add "shipCity", 1
            tempDictionary.Add "shipRegion", 1
            tempDictionary.Add "shipPostal", 1
            tempDictionary.Add "shipCountry", 1

            tempDictionary.Add "domain", 1
            tempDictionary.Add "custPhone", 1
            tempDictionary.Add "emailMD5", 1
            tempDictionary.Add "usernameMD5", 1
            tempDictionary.Add "passwordMD5", 1

            tempDictionary.Add "bin", 1
            tempDictionary.Add "binName", 1
            tempDictionary.Add "binPhone", 1

            tempDictionary.Add "sessionID", 1
            tempDictionary.Add "user_agent", 1
            tempDictionary.Add "accept_language", 1

            tempDictionary.Add "txnID", 1
            tempDictionary.Add "order_amount", 1
            tempDictionary.Add "order_currency", 1
            tempDictionary.Add "shopID", 1
            tempDictionary.Add "txn_type", 1

            tempDictionary.Add "avs_result", 1
            tempDictionary.Add "cvv_result", 1

            tempDictionary.Add "requested_type", 1
            tempDictionary.Add "forwardedIP", 1


            num_allowed_fields = tempDictionary.Count
            set allowed_fields = tempDictionary

            set queries = CreateObject("Scripting.Dictionary")
            set outputstr = CreateObject("Scripting.Dictionary")

            'set the url of the web service
            url = ccfdURL
        end sub

        private sub Class_Terminate()
        end sub

        public function set_allowed_fields(fieldDictionary)
            num_allowed_fields = fieldDictionary.Count
            set allowed_fields = fieldDictionary
        end function

        public function query()
            dim ret
            ret = 0

            'Reset OutputStr Dictionary Object
            Set outputstr =  CreateObject("Scripting.Dictionary")

            'query every server in the list
            for i = lbound(serverlist) to ubound(serverlist)
                result = querySingleServer(ServerList(i))

                if(debug = 1) then
                    response.write("Server: "&ServerList(i)&vbCrlf&"Result: "&result&vbCrlf)
                end if
                if(result) then
                    ret = result
                    exit for
                end if
            next

            query = ret
        end function

        public function input(inputDictionary)
            dim ret
            ret = 0

            Set queries = CreateObject("Scripting.Dictionary")

            'Use default License key, if avaliable (can be overridden by input value)
            if(ccfdLicenseKey<>"") then
                queries.Add "license_key", ccfdLicenseKey
            end if

            ' get the number of keys in the input hash
            numinputkeys = inputDictionary.Count
            ' get a array of keys in the input hash
            inputkeys = inputDictionary.keys
            for i = 0 to numinputkeys-1
                dim key
                key = inputkeys(i)

                if (allowed_fields.Item(key) = 1) then
                    'if key is a allowed field then store it in
                    'the hash named queries
                    if (debug = 1) then
            response.write("Input " & key & " = " & inputDictionary.Item(key) & vbCrlf)
                    end if

                    'Check for duplicate values (Not likely to happen, but you never know)
                    if(queries.Exists(key)) then
            queries.Item(key) = Server.UrlEncode(inputDictionary.Item(key))
                    else
            queries.Add key, Server.UrlEncode(inputDictionary.Item(key))
                    end if

                    ret = 1
                else
                    response.write("Invalid input key - perhaps misspelled field?")
                end if
            next

            queries.Add "clientAPI", API_VERSION
        end function

        public function output()
            set output = outputstr
        end function

        public function querySingleServer(serverString)
            dim ret, scheme, content, query_string, tempUrl, objXmlHttp, strHTML
            ret = 0

            'check if we using the Secure HTTPS proctol
            if(isSecure = 1) then
                scheme = "https://"    'Secure HTTPS proctol
            else
                scheme = "http://"        'Regular HTTP proctol
            end if

            'build a query string from the hash called queries
            numquerieskeys = queries.Count    'get the number of keys in the hash called queries
            querieskeys = queries.Keys        'get a array of keys in the hash called queries

            if (debug = 1) then
                response.write("number of query keys " & numquerieskeys & vbCrlf)
            end if

            query_string = ""
            for i = 0 to numquerieskeys-1
                'for each element in the hash called queries
                'append the key and value of the element to the query string
                key = querieskeys(i)
                value = queries.Item(key)

                'encode the key and value before adding it to the string
                'key = urlencode(key)
                'value = urlencode(value)
                if (debug = 1) then
                    response.write(" query key " & key & " query value " & value & vbCrlf)
                end if

                query_string = query_string & key & "=" & value
                if (i < numquerieskeys - 1) then
                    query_string = query_string & "&"
                end if
            next

            content = ""

            'Disable Error Handler
            'We will handle timeout and other script errors ourselves.
            Err.Clear
            On Error Resume Next

            dim myTimeout
            myTimeout = timeout*1000 'Timeout time in millisecond, 1000 ms = 1 second

            'This is the server safe version from MSXML3.
            Set objXmlHttp = Server.CreateObject("Msxml2.ServerXMLHTTP")

            'Check if ServerXMLHTTP object was created correctly
            if(Err.number <> 0) then
                content = Replace("err="&Err.Source&": "&Err.description&" ["&Err.number&"]", vbCrlf, "") 'Set Error Value
            else
                objXmlHttp.setTimeouts myTimeout,myTimeout,myTimeout,myTimeout

                'use Msxml2.ServerXMLHTTP
                if (debug = 1) then
                    response.write("using Msxml2.ServerXMLHTTP"&vbCrlf)
                end if

                tempUrl = scheme & serverString & "/" & url & "?" & query_string

                'Here we get the request ready to be sent.
                'objXmlHttp.open(bstrMethod, bstrUrl, bAsync, bstrUser, bstrPassword)
                'objXmlHttp.open "GET", "http://www.asp101.com/samples/httpsamp.asp", False
                objXmlHttp.open "GET", tempUrl, False
                objXmlHttp.send

                if(Err.number <> 0) then 'If object or connection error (i.e. connection timeout)
                    content = Replace("err="&Err.Source&": ["&Err.number&"] "&Err.description, vbCrlf, "") 'Set Error Value
                elseif(objXmlHttp.Status >= 400 And objXmlHttp.Status <= 599) then 'If HTTP/HTTPS error
                    content = Replace("err=Status: "&objXmlHttp.Status&" - "&objXmlHttp.statusText, vbCrlf, "") 'Set Error Value
                else 'If all is well
                    content = objXmlHttp.responseText
                end if
            end if

            Set objXmlHttp = Nothing

            'ReEnable Error Handler
            Err.Clear
            On Error Goto 0

            if(debug = 1) then
                response.write("content = " & content & vbCrlf)
            end if

            ' split content into pairs containing both
            ' the key and the value
            keyvaluepairs = split(content,";")

            'for each pair store key and value into the
            'hash named outputstr

            if(typename(keyvaluepairs)="Variant()") then
                for i = lBound(keyvaluepairs) to uBound(keyvaluepairs)
                    dim tempArray,key,value

                    'split the pair into a key and a value
                    tempArray = split(keyvaluepairs(i),"=")

                    if(typename(tempArray)="Variant()") then
            if(uBound(tempArray)=1) then
                key = tempArray(0)
                value = tempArray(1)

                if (debug = 1) then
                    response.write(" output " & key & " = " & value & vbCrlf)
                end if

                'store the key and the value into the
                'hash named outputstr
                if(outputstr.Exists(key)) then
                    outputstr.Item(key) = value
                else
                    outputstr.Add key, value
                end if
            end if
                    end if
                next
            end if

            'check if outputstr has the countryMatch if outputstr does not have
            'the countryMatch return 0
            if(outputstr.Exists("countryMatch")) then
                if(outputstr.Item("countryMatch") <> "") then
                    ret = 1
                end if
            end if

            if(outputstr.Count=0) then
                outputstr.Add "err", "Unknown, or invalid data returned."
            end if

            querySingleServer = ret
        end function
    end class
%>
