Class dc.jrpereira.fhirfy.core.API Extends %RegisteredObject
{

Property Analyzer As dc.jrpereira.fhirfy.core.RawDataAnalyzer;

Property SolutionGenerator As dc.jrpereira.fhirfy.core.SolutionGenerator;

Property ModuleGenerator As dc.jrpereira.fhirfy.core.SolutionModuleGenerator;

Method %OnNew() As %Status
{
    Set ..Analyzer = ##class(dc.jrpereira.fhirfy.core.RawDataAnalyzer).%New()
    Set ..SolutionGenerator = ##class(dc.jrpereira.fhirfy.core.SolutionGenerator).%New()
    Set ..ModuleGenerator = ##class(dc.jrpereira.fhirfy.core.SolutionModuleGenerator).%New()
    Return $$$OK
}

Method AnalyzeData(dataInput As %DynamicObject) As %DynamicObject
{
    Set analysis = ..Analyzer.GetResponse(dataInput)
    Return analysis
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
