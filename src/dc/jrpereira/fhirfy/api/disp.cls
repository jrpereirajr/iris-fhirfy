/// Dispatch class defined by RESTSpec in dc.jrpereira.fhirfy.api.spec
Class dc.jrpereira.fhirfy.api.disp Extends %CSP.REST [ GeneratedBy = dc.jrpereira.fhirfy.api.spec.cls, ProcedureBlock ]
{

/// The class containing the RESTSpec which generated this class
Parameter SpecificationClass = "dc.jrpereira.fhirfy.api.spec";

/// Ignore any writes done directly by the REST method.
Parameter IgnoreWrites = 1;

/// By default convert the input stream to Unicode
Parameter CONVERTINPUTSTREAM = 1;

/// The default response charset is utf-8
Parameter CHARSET = "utf-8";

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
  <!-- Analyze Data -->
  <Route Url="/analyze-data" Method="post" Call="analyzeData" />
  <!-- Suggest a solution -->
  <Route Url="/suggest-solution" Method="post" Call="suggestSolution" />
  <!-- Generates the code for a solution suggestion. -->
  <Route Url="/generate-module" Method="post" Call="generateModule" />
  <!-- Download the code generated for a solution. -->
  <Route Url="/download" Method="get" Call="download" />
  <!-- Mock data for a simple CSV as input -->
  <Route Url="/mock/simple-csv" Method="get" Call="mockSimpleCSV" />
  <!-- Return the OpenAPI 2.0 specification -->
  <Route Url="/_spec" Method="get" Call="getOpenAPISpec" />
</Routes>
}

/// Analyze Data
ClassMethod analyzeData() As %Status
{
    Try {
        If $case(%request.ContentType,"application/json":0,:1) Do ##class(%REST.Impl).%ReportRESTError(..#HTTP415UNSUPPORTEDMEDIATYPE,$$$ERROR($$$RESTContentType,%request.ContentType)) Quit
        Do ##class(%REST.Impl).%SetContentType("application/json")
        If '##class(%REST.Impl).%CheckAccepts("application/json") Do ##class(%REST.Impl).%ReportRESTError(..#HTTP406NOTACCEPTABLE,$$$ERROR($$$RESTBadAccepts)) Quit
        If '$isobject(%request.Content) || (%request.Content.Size=0) Do ##class(%REST.Impl).%ReportRESTError(..#HTTP400BADREQUEST,$$$ERROR($$$RESTRequired,"input")) Quit
        Set pinput=##class(%DynamicAbstractObject).%FromJSON(%request.Content)
        If $data(%request.Data("mockName",2)) {
            Do ##class(%REST.Impl).%ReportRESTError(..#HTTP400BADREQUEST,$$$ERROR($$$RESTDuplicate,"mockName")) Quit
        }
        If $data(%request.Data("mockName",1)) {
            Set pmockName=%request.Data("mockName",1)
        }
        Set response=##class(dc.jrpereira.fhirfy.api.impl).analyzeData(pinput,.pmockName)
        Do ##class(dc.jrpereira.fhirfy.api.impl).%WriteResponse(response)
    } Catch (ex) {
        Do ##class(%REST.Impl).%ReportRESTError(..#HTTP500INTERNALSERVERERROR,ex.AsStatus(),$parameter("dc.jrpereira.fhirfy.api.impl","ExposeServerExceptions"))
        Do ..LogInBackground(ex)
    }
    Quit $$$OK
}

/// Suggest a solution
ClassMethod suggestSolution() As %Status
{
    Try {
        If $case(%request.ContentType,"application/json":0,:1) Do ##class(%REST.Impl).%ReportRESTError(..#HTTP415UNSUPPORTEDMEDIATYPE,$$$ERROR($$$RESTContentType,%request.ContentType)) Quit
        Do ##class(%REST.Impl).%SetContentType("application/json")
        If '##class(%REST.Impl).%CheckAccepts("application/json") Do ##class(%REST.Impl).%ReportRESTError(..#HTTP406NOTACCEPTABLE,$$$ERROR($$$RESTBadAccepts)) Quit
        If '$isobject(%request.Content) || (%request.Content.Size=0) Do ##class(%REST.Impl).%ReportRESTError(..#HTTP400BADREQUEST,$$$ERROR($$$RESTRequired,"input")) Quit
        Set pinput=##class(%DynamicAbstractObject).%FromJSON(%request.Content)
        If $data(%request.Data("mockName",2)) {
            Do ##class(%REST.Impl).%ReportRESTError(..#HTTP400BADREQUEST,$$$ERROR($$$RESTDuplicate,"mockName")) Quit
        }
        If $data(%request.Data("mockName",1)) {
            Set pmockName=%request.Data("mockName",1)
        }
        Set response=##class(dc.jrpereira.fhirfy.api.impl).suggestSolution(pinput,.pmockName)
        Do ##class(dc.jrpereira.fhirfy.api.impl).%WriteResponse(response)
    } Catch (ex) {
        Do ##class(%REST.Impl).%ReportRESTError(..#HTTP500INTERNALSERVERERROR,ex.AsStatus(),$parameter("dc.jrpereira.fhirfy.api.impl","ExposeServerExceptions"))
        Do ..LogInBackground(ex)
    }
    Quit $$$OK
}

/// Generates the code for a solution suggestion.
ClassMethod generateModule() As %Status
{
    Try {
        If $case(%request.ContentType,"application/json":0,:1) Do ##class(%REST.Impl).%ReportRESTError(..#HTTP415UNSUPPORTEDMEDIATYPE,$$$ERROR($$$RESTContentType,%request.ContentType)) Quit
        Do ##class(%REST.Impl).%SetContentType("application/json")
        If '##class(%REST.Impl).%CheckAccepts("application/json") Do ##class(%REST.Impl).%ReportRESTError(..#HTTP406NOTACCEPTABLE,$$$ERROR($$$RESTBadAccepts)) Quit
        If '$isobject(%request.Content) || (%request.Content.Size=0) Do ##class(%REST.Impl).%ReportRESTError(..#HTTP400BADREQUEST,$$$ERROR($$$RESTRequired,"input")) Quit
        Set pinput=##class(%DynamicAbstractObject).%FromJSON(%request.Content)
        If $data(%request.Data("mockName",2)) {
            Do ##class(%REST.Impl).%ReportRESTError(..#HTTP400BADREQUEST,$$$ERROR($$$RESTDuplicate,"mockName")) Quit
        }
        If $data(%request.Data("mockName",1)) {
            Set pmockName=%request.Data("mockName",1)
        }
        Set response=##class(dc.jrpereira.fhirfy.api.impl).generateModule(pinput,.pmockName)
        Do ##class(dc.jrpereira.fhirfy.api.impl).%WriteResponse(response)
    } Catch (ex) {
        Do ##class(%REST.Impl).%ReportRESTError(..#HTTP500INTERNALSERVERERROR,ex.AsStatus(),$parameter("dc.jrpereira.fhirfy.api.impl","ExposeServerExceptions"))
        Do ..LogInBackground(ex)
    }
    Quit $$$OK
}

/// Download the code generated for a solution.
ClassMethod download() As %Status
{
    Try {
        Do ##class(%REST.Impl).%SetContentType("application/octet-stream")
        If '##class(%REST.Impl).%CheckAccepts("application/octet-stream") Do ##class(%REST.Impl).%ReportRESTError(..#HTTP406NOTACCEPTABLE,$$$ERROR($$$RESTBadAccepts)) Quit
        If '$data(%request.Data("moduleName",1)) Do ##class(%REST.Impl).%ReportRESTError(..#HTTP400BADREQUEST,$$$ERROR($$$RESTRequired,"moduleName")) Quit
        If $data(%request.Data("moduleName",2)) {
            Do ##class(%REST.Impl).%ReportRESTError(..#HTTP400BADREQUEST,$$$ERROR($$$RESTDuplicate,"moduleName")) Quit
        }
        Set pmoduleName=%request.Data("moduleName",1)
        Set response=##class(dc.jrpereira.fhirfy.api.impl).download(pmoduleName)
        Do ##class(dc.jrpereira.fhirfy.api.impl).%WriteResponse(response)
    } Catch (ex) {
        Do ##class(%REST.Impl).%ReportRESTError(..#HTTP500INTERNALSERVERERROR,ex.AsStatus(),$parameter("dc.jrpereira.fhirfy.api.impl","ExposeServerExceptions"))
        Do ..LogInBackground(ex)
    }
    Quit $$$OK
}

/// Mock data for a simple CSV as input
ClassMethod mockSimpleCSV() As %Status
{
    Try {
        Do ##class(%REST.Impl).%SetContentType("application/json")
        If '##class(%REST.Impl).%CheckAccepts("application/json") Do ##class(%REST.Impl).%ReportRESTError(..#HTTP406NOTACCEPTABLE,$$$ERROR($$$RESTBadAccepts)) Quit
        Set response=##class(dc.jrpereira.fhirfy.api.impl).mockSimpleCSV()
        Do ##class(dc.jrpereira.fhirfy.api.impl).%WriteResponse(response)
    } Catch (ex) {
        Do ##class(%REST.Impl).%ReportRESTError(..#HTTP500INTERNALSERVERERROR,ex.AsStatus(),$parameter("dc.jrpereira.fhirfy.api.impl","ExposeServerExceptions"))
        Do ..LogInBackground(ex)
    }
    Quit $$$OK
}

/// Return the OpenAPI 2.0 specification
ClassMethod getOpenAPISpec() As %Status
{
    Try {
        Do ##class(%REST.Impl).%SetContentType("application/json")
        If '##class(%REST.Impl).%CheckAccepts("application/json") Do ##class(%REST.Impl).%ReportRESTError(..#HTTP406NOTACCEPTABLE,$$$ERROR($$$RESTBadAccepts)) Quit
        Set response=##class(dc.jrpereira.fhirfy.api.impl).getOpenAPISpec()
        Do ##class(dc.jrpereira.fhirfy.api.impl).%WriteResponse(response)
    } Catch (ex) {
        Do ##class(%REST.Impl).%ReportRESTError(..#HTTP500INTERNALSERVERERROR,ex.AsStatus(),$parameter("dc.jrpereira.fhirfy.api.impl","ExposeServerExceptions"))
        Do ..LogInBackground(ex)
    }
    Quit $$$OK
}

ClassMethod LogInBackground(ex As %Exception.AbstractException)
{
    JOB ..Log(ex.DisplayString())
}

/// Copied from %Exception.AbstractException
/// Call the log function (LOG^%ETN) to log this exception.
/// You can view this log at the terminal with 'Do ^%ER' utility or from the system management portal.
ClassMethod Log(msg) As %Status
{
	try {
		do LOG^%ETN(msg)
		set sc=$$$OK
	} catch err {
		set sc=err.AsStatus()
	}
	quit sc
}

}
