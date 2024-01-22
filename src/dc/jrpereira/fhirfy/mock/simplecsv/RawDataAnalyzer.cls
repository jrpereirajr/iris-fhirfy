Class dc.jrpereira.fhirfy.mock.simplecsv.MockData.RawDataAnalyzer Extends dc.jrpereira.fhirfy.core.RawDataAnalyzer
{

Method GetLLMResponse(input) As %String [ Language = python ]
{
    import iris
    xmlData = iris.cls("dc.jrpereira.fhirfy.mock.simplecsv.MockData").GetRawDataAnalyzerMockData()
    return xmlData
}

}
