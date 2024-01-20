/// Business logic class defined by OpenAPI in dc.jrpereira.fhirfy.api.spec<br/>
/// Updated Jan 20, 2024 21:13:51
Class dc.jrpereira.fhirfy.api.impl Extends %REST.Impl [ ProcedureBlock ]
{

/// If ExposeServerExceptions is true, then details of internal errors will be exposed.
Parameter ExposeServerExceptions = 0;

/// Analyzes raw data and returns an analysis report.<br/>
/// The method arguments hold values for:<br/>
///     input<br/>
ClassMethod analyzeData(input As %DynamicObject) As %DynamicObject
{
    Do ..%SetStatusCode(200)
    //Do ..%SetHeader(<name>,<value>)
    Set api = ##class(dc.jrpereira.fhirfy.core.API).%New()
    Return api.AnalyzeData(input)
}

/// Suggest a solution based on the analysis report.<br/>
/// The method arguments hold values for:<br/>
///     input<br/>
ClassMethod suggestSolution(input As %DynamicObject) As %DynamicObject
{
    Do ..%SetStatusCode(200)
    //Do ..%SetHeader(<name>,<value>)
    Set api = ##class(dc.jrpereira.fhirfy.core.API).%New()
    Return api.SuggestSolution(input)
}

/// Generates the code for a solution suggestion encapsulated as a ZPM module.<br/>
/// The method arguments hold values for:<br/>
///     input<br/>
ClassMethod generateModule(input As %DynamicObject) As %DynamicObject
{
    Do ..%SetStatusCode(200)
    //Do ..%SetHeader(<name>,<value>)
    Set api = ##class(dc.jrpereira.fhirfy.core.API).%New()
    Return api.GenerateModule(input)
}

/// Get the mock data for sample of system process of a simple CSV containg basic patient infor.
ClassMethod mockSimpleCSV() As %DynamicObject
{
    Do ..%SetStatusCode(200)
    //Do ..%SetHeader(<name>,<value>)
    Set api = ##class(dc.jrpereira.fhirfy.mock.API).%New()
    Return api.GetSimpleCSVMockData()
}

}
