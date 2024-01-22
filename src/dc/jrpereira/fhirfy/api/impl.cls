/// Business logic class defined by OpenAPI in dc.jrpereira.fhirfy.api.spec<br/>
/// Updated Jan 22, 2024 02:49:00
Class dc.jrpereira.fhirfy.api.impl Extends %REST.Impl [ ProcedureBlock ]
{

/// If ExposeServerExceptions is true, then details of internal errors will be exposed.
Parameter ExposeServerExceptions = 0;

ClassMethod GetAPI(mockName As %String) As dc.jrpereira.fhirfy.core.API
{
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
ClassMethod analyzeData(input As %DynamicObject, mockName As %String = "") As %DynamicObject
{
    Do ..%SetStatusCode(200)
    //Do ..%SetHeader(<name>,<value>)
    Set api = ..GetAPI(mockName)
    Return api.AnalyzeData(input)
}

/// Suggest a solution based on the analysis report.<br/>
/// The method arguments hold values for:<br/>
///     input<br/>
///     mockName<br/>
ClassMethod suggestSolution(input As %DynamicObject, mockName As %String = "") As %DynamicObject
{
    Do ..%SetStatusCode(200)
    //Do ..%SetHeader(<name>,<value>)
    Set api = ..GetAPI(mockName)
    Return api.SuggestSolution(input)
}

/// Generates the code for a solution suggestion encapsulated as a ZPM module.<br/>
/// The method arguments hold values for:<br/>
///     input<br/>
///     mockName<br/>
ClassMethod generateModule(input As %DynamicObject, mockName As %String = "") As %DynamicObject
{
    Do ..%SetStatusCode(200)
    //Do ..%SetHeader(<name>,<value>)
    Set api = ..GetAPI(mockName)
    Return api.GenerateModule(input)
}

/// Get the mock data for sample of system process of a simple CSV containg basic patient information.
ClassMethod mockSimpleCSV() As %DynamicObject
{
    Do ..%SetStatusCode(200)
    //Do ..%SetHeader(<name>,<value>)
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

}
