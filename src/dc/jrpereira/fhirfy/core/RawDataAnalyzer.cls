Class dc.jrpereira.fhirfy.core.RawDataAnalyzer Extends %RegisteredObject
{

Property llm As LLMService;

Method %OnNew() As %Status
{
    Set ..llm = ##class(LLMService).GetLLMService()
    Return $$$OK
}

Method GetResponse(dataInput As %DynamicObject) As %String [ Language = python ]
{
    import xmltodict

    #; import iris
    #; xmlData = iris.cls("tests.dc.jrpereira.fhirfy.unittests.core.MocksData").GetRawDataAnalyzerMockData()
    
    rawData = dataInput._Get("input")._Get("rawData")
    prompt = self.GetSystemPrompt(rawData)
    xmlData = self.llm.SendPrompt(prompt)
    try:
        result = xmltodict.parse(xmlData)["result"]
    except Exception as e:
        raise Exception("Failed to parse XML data: " + str(e) + "\n XML data: " + xmlData)
    return result
}

Method GetSystemPrompt(data) As %String [ Language = python ]
{
    import iris
    clean = iris.cls("dc.jrpereira.fhirfy.core.Utils").CleanTripleQuotesString
    return clean(f"""You are a helpful interoperability assistant. 
As such, you'll be interested in explain the structure and content of the data to work with it effectively.
Explain the following data to a human interoperability developer.
Return the text into a XML document like this:
<result>
<![CDATA[
your text
]]><result>
The text string must be formatted using markdown.
A sample of the data for your analysis:
{data}""")
}

}
