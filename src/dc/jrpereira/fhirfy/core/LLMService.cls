Class dc.jrpereira.fhirfy.core.LLMService Extends %RegisteredObject [ Abstract ]
{

Method SendPrompt(prompt As %String, params As %DynamicObject = {{}}) As %DynamicObject [ Language = python ]
{
    raise Exception("Not implemented")
}

ClassMethod GetLLMService(provider As %String = "default") As LLMService
{
    // todo:
    Return ##class(GoogleGeminiService).%New()
}

}
