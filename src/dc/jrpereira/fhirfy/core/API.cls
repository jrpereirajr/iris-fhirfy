Class dc.jrpereira.fhirfy.core.API Extends %RegisteredObject
{

Property Analyzer As RawDataAnalyzer;

Property SolutionGenerator As SolutionGenerator;

Property ModuleGenerator As SolutionModuleGenerator;

Method %OnNew() As %Status
{
    Set ..Analyzer = ##class(RawDataAnalyzer).%New()
    Set ..SolutionGenerator = ##class(SolutionGenerator).%New()
    Set ..ModuleGenerator = ##class(SolutionModuleGenerator).%New()
    Return $$$OK
}

Method AnalyzeData(dataInput As %DynamicObject) As %DynamicObject
{
    Set analysis = ..Analyzer.GetResponse(dataInput)
    Return {
        "markdownResponse": (analysis)
    }
}

Method SuggestSolution(input As %DynamicObject) As %DynamicObject
{
    Set suggestedSolution = ..SolutionGenerator.GetResponse(input)
    Return suggestedSolution
}

Method GenerateModule(input As %DynamicObject) As %DynamicObject
{
    Set module = ..ModuleGenerator.GetResponse(input)
    Return module
}

}
