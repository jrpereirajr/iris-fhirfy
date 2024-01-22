Class dc.jrpereira.fhirfy.mock.simplecsv.SolutionGenerator Extends dc.jrpereira.fhirfy.core.SolutionGenerator
{

Method GetLLMResponse(input) As %String [ Language = python ]
{
    import iris
    xmlData = iris.cls("dc.jrpereira.fhirfy.mock.simplecsv.MockData").GetSolutionGeneratorMockData()
    return xmlData
}

}
