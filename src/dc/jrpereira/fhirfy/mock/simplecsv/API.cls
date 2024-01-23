Class dc.jrpereira.fhirfy.mock.simplecsv.API Extends dc.jrpereira.fhirfy.mock.API
{

Property MockData As dc.jrpereira.fhirfy.mock.simplecsv.MockData;

Method %OnNew(mockName As %String) As %Status
{
    Set ..Analyzer = ##class(dc.jrpereira.fhirfy.mock.simplecsv.RawDataAnalyzer).%New()
    Set ..SolutionGenerator = ##class(dc.jrpereira.fhirfy.mock.simplecsv.SolutionGenerator).%New()
    Set ..ModuleGenerator = ##class(dc.jrpereira.fhirfy.mock.simplecsv.SolutionModuleGenerator).%New()
    Set ..MockData = ##class(dc.jrpereira.fhirfy.mock.simplecsv.MockData).%New()
    Return $$$OK
}

Method GetMockData() As %DynamicObject
{
    Set module = ..MockData.GetResponse()
    Return module
}

}
