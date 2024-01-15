# Steps to create an API from OpenAPI specification

```
FHIRSERVER>Do ^%REST

REST Command Line Interface (CLI) helps you CREATE or DELETE a REST application.
Enter an application name or (L)ist all REST applications (L): dc.jrpereira.fhirfy.api
REST application not found: dc.jrpereira.fhirfy.api
Do you want to create a new REST application? Y or N (Y): y

File path or absolute URL of a swagger document.
If no document specified, then create an empty application.
OpenAPI 2.0 swagger: /home/irisowner/dev/openapi/api.json

OpenAPI 2.0 swagger document: /home/irisowner/dev/openapi/api.json
Confirm operation, Y or N (Y): y

-----Creating REST application: dc.jrpereira.fhirfy.api-----
CREATE dc.jrpereira.fhirfy.api.spec
GENERATE dc.jrpereira.fhirfy.api.disp
CREATE dc.jrpereira.fhirfy.api.impl
REST application successfully created.

Create a web application for the REST application? Y or N (Y): y
Specify a web application name beginning with a single '/'. Default is /csp/dc/jrpereira/fhirfy/api
Web application name: /csp/dc/jrpereira/fhirfy/api

-----Deploying REST application: dc.jrpereira.fhirfy.api-----
Application dc.jrpereira.fhirfy.api deployed to /csp/dc/jrpereira/fhirfy/api
```

```
set file = "/home/irisowner/dev/openapi/api.json"
set obj = ##class(%DynamicAbstractObject).%FromJSONFile(file)
do ##class(%REST.API).CreateApplication("dc.jrpereira.fhirfy.api",.obj,,.new,.error)
zw new, error
```