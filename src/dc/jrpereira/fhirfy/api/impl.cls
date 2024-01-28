/// Business logic class defined by OpenAPI in dc.jrpereira.fhirfy.api.spec<br/>
/// Updated Jan 27, 2024 15:04:00
Class dc.jrpereira.fhirfy.api.impl Extends %REST.Impl [ ProcedureBlock ]
{

/// If ExposeServerExceptions is true, then details of internal errors will be exposed.
Parameter ExposeServerExceptions = 0;

ClassMethod %ReportRESTError(statusCode As %String, sc As %Status, exposeServerExceptions As %Boolean = 0)
{
    Set ex = ##class(%Exception.StatusException).CreateFromStatus(sc)

    Set errorDesc = ex.DisplayString()
    Set llmService = ##class(dc.jrpereira.fhirfy.core.LLMService).GetLLMService()
    If (llmService).IsProviderException(errorDesc) {
        Set exposeServerExceptions = 1
    }

    JOB ..Log(ex.DisplayString())
    Do ##super(statusCode, sc, exposeServerExceptions)
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

ClassMethod GetAPI(mockName As %String) As dc.jrpereira.fhirfy.core.API
{
    Set mockName = $GET(mockName)
    If (mockName = "") {
        Return ##class(dc.jrpereira.fhirfy.core.API).%New()
    } Else {
        Return ##class(dc.jrpereira.fhirfy.mock.API).GetInstance(mockName)
    }
}

/// Analyzes raw data and returns an analysis report.<br/>
/// The method arguments hold values for:<br/>
///     input<br/>
///     mockName<br/>
///     X-FHIRFY-LLM-PROVIDER<br/>
///     X-FHIRFY-LLM-API-KEY<br/>
/// WARNING: This method's signature has changed.
ClassMethod analyzeData(input As %DynamicObject, mockName As %String, XFHIRFYLLMPROVIDER As %String, XFHIRFYLLMAPIKEY As %String) As %DynamicObject
{
    Do ..%SetStatusCode(200)
    Set mockName = $GET(mockName)
    Set api = ..GetAPI(mockName)
    Return api.AnalyzeData(input)
}

/// Suggest a solution based on the analysis report.<br/>
/// The method arguments hold values for:<br/>
///     input<br/>
///     mockName<br/>
///     X-FHIRFY-LLM-PROVIDER<br/>
///     X-FHIRFY-LLM-API-KEY<br/>
/// WARNING: This method's signature has changed.
ClassMethod suggestSolution(input As %DynamicObject, mockName As %String, XFHIRFYLLMPROVIDER As %String, XFHIRFYLLMAPIKEY As %String) As %DynamicObject
{
    Do ..%SetStatusCode(200)
    Set mockName = $GET(mockName)
    Set api = ..GetAPI(mockName)
    Return api.SuggestSolution(input)
}

/// Generates the code for a solution suggestion encapsulated as a ZPM module.<br/>
/// The method arguments hold values for:<br/>
///     input<br/>
///     mockName<br/>
///     X-FHIRFY-LLM-PROVIDER<br/>
///     X-FHIRFY-LLM-API-KEY<br/>
/// WARNING: This method's signature has changed.
ClassMethod generateModule(input As %DynamicObject, mockName As %String, XFHIRFYLLMPROVIDER As %String, XFHIRFYLLMAPIKEY As %String) As %DynamicObject
{
    Do ..%SetStatusCode(200)
    Set mockName = $GET(mockName)
    Set api = ..GetAPI(mockName)
    Return api.GenerateModule(input)
}

/// Get the mock data for sample of system process of a simple CSV containg basic patient information.
ClassMethod mockSimpleCSV() As %DynamicObject
{
    Do ..%SetStatusCode(200)
    Set api = ..GetAPI("simple-csv")
    Return api.GetMockData()
}

/// Return the OpenAPI 2.0 specification.
ClassMethod getOpenAPISpec() As %DynamicObject
{
    Do ..%SetStatusCode(200)
    //Do ..%SetHeader(<name>,<value>)
    $$$ThrowOnError(##class(%REST.API).GetApplication("dc.jrpereira.fhirfy.api", .obj))
    Return obj
}

/// Download the code generated for a solution.<br/>
/// The method arguments hold values for:<br/>
///     moduleName<br/>
ClassMethod download(moduleName As %String) As %Stream.Object
{
    Set compressedFile = ##class(dc.jrpereira.fhirfy.core.SolutionModuleGenerator).%New().CompressModule(moduleName)
    Set filepath = $PIECE(compressedFile, "/", 1, *-1)_"/"
    Set filename = $PIECE(compressedFile, "/", *)

    Do ..%SetStatusCode(200)
    Do ..%SetHeader("Content-Disposition"," attachment;filename="""_$p(filename,"\",*)_"""")    
    Set %response.NoCharSetConvert = 1
    Do ..%SetHeader("Access-Control-Allow-Origin", "*")
    
    Set file = ##class(%Stream.FileBinary).%New()
    Set file.Filename = filepath_filename
    #; $$$ThrowOnError(##class(%File).RemoveDirectoryTree(filepath))

    Return file
}

}
