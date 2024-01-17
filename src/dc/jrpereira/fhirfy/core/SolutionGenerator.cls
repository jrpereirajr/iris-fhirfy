Class dc.jrpereira.fhirfy.core.SolutionGenerator Extends %RegisteredObject
{

Method GetResponse(dataInput As %DynamicObject) As %String [ Language = python ]
{
    import iris
    import json
    raw = iris.cls("tests.dc.jrpereira.fhirfy.unittests.core.MocksData").GetSolutionGeneratorMockData()
    jsonData = json.loads(raw)
    result = json.dumps(jsonData)
    return result
}

}
