# MaxMind minFraud ASP API

## Example

See `Example.asp` for complete example how to use this API. This script can be
run from the shell or from IIS.

## API Documentation

```
set ccfs = new CreditCardFraudDetection
```

This creates a new CreditCardFraudDetection object. `set` is required since it
is an object

```
ccfs.isSecure
```

If isSecure is set to 0 then it uses regular HTTP. If isSecure is set to 1
then it uses Secure HTTPS.

```
ccfs.input(dictionary)
```

Takes a dictionary object and uses it as input for the server. See
http://dev.maxmind.com/minfraud for details on input fields.

```
ccfs.query()
```

Queries the server with the fields passed to the input method and stores the
output.

```
set dictionary = ccfs.output()
```

Returns the output from the server as a dictionary object. `set` is required
since it is an object. See http://dev.maxmind.com/minfraud for details on
output fields.

## Secure HTTPS

This script uses Microsoft's `Msxml2.ServerXMLHTTP` which has full support for
SSL. SSL is enabled by default. You may disable it by setting:

```
ccfs.isSecure = 0
```

where `ccfs` is the `CreditCardFraudDetection` object.

## Error Handling

Errors will be placed into a string value in the output dictionary object
which can then be checked before processing the returned data.

Example:

```
    Dim ret
    Set ret = ccfs.output()
    if(ret.Item("err") <> "") then
        'handle error here
    else
        'Process data
    end if
```

A quick way to test the error handler is to modify the host list (Unable to
find host), web-service URO (404 file not found or Invalid data returned), or
set the timeout (Connection timed out) to a very low value (i.e. 0.01
seconds).

---------------------------------------
Copyright (c) 2004, [Raging Creations Ltd.](http://www.ragingcreations.com/).
Original PHP Code Copyright (c) 2004, MaxMind, Inc.

Converted by: Shaun Hawkes (shawkes@ragingcreations.com), August 15, 2004.

All rights reserved.  This package is licensed under the GPL. For details see
the LICENSE file.
