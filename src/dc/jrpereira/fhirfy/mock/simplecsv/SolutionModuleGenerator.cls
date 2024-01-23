Class dc.jrpereira.fhirfy.mock.simplecsv.SolutionModuleGenerator Extends dc.jrpereira.fhirfy.core.SolutionModuleGenerator
{

Method GetLLMResponse(input) As %String [ Language = python ]
{
    import iris
    xmlData = iris.cls("dc.jrpereira.fhirfy.mock.simplecsv.MockData").GetSolutionModuleGeneratorMockData()
    return xmlData
}

}
