Class dc.jrpereira.fhirfy.core.LLMService Extends %RegisteredObject [ Abstract ]
{

Parameter ServiceID;

Method SendPrompt(prompt As %String, params As %DynamicObject = {{}}) As %DynamicObject [ Language = python ]
{
    raise Exception("Not implemented")
}

ClassMethod GetLLMService(provider As %String = "") As LLMService
{
    If ($ISOBJECT($GET(%llmProvider))) {
        Return %llmProvider
    }

    Set provider = ..GetProviderID(provider)
    If (provider = "") || (provider = ##class(dc.jrpereira.fhirfy.core.GoogleGeminiLLMService).#ServiceID) {
        Set instance = ##class(dc.jrpereira.fhirfy.core.GoogleGeminiLLMService).%New()
    } ElseIf (provider = ##class(dc.jrpereira.fhirfy.core.OpenAILLMService).#ServiceID) {
        Set instance = ##class(dc.jrpereira.fhirfy.core.OpenAILLMService).%New()
    } Else {
        Throw ##class(%Exception.General).%New("Invalid LLM provider")
    }
    Set %llmProvider = instance
    Return instance
}

ClassMethod GetProviderID(provider As %String) As %String
{
    If (provider = "") {
        Set requestProvider = ""
        #Dim %request As %CSP.Request
        If ($ISOBJECT($GET(%request))) {
            Set requestProvider = %request.GetCgiEnv("HTTP_X_FHIRFY_LLM_PROVIDER")
        }
        If (requestProvider '= "") {
            Set provider = requestProvider
        }
    }
    Return provider
}

ClassMethod GetAPIKey(defaultKey As %String) As %String
{
    Set requestKey = ""
    #Dim %request As %CSP.Request
    If ($ISOBJECT($GET(%request))) {
        Set requestKey = %request.GetCgiEnv("HTTP_X_FHIRFY_LLM_API_KEY")
    }
    If (requestKey '= "") {
        Return requestKey
    } Else {
        Return defaultKey
    }
}

Method IsProviderException(errorDesc As %String) As %Boolean
{
    Return 0
}

}
