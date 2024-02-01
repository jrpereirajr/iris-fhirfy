Class dc.jrpereira.fhirfy.core.RawDataAnalyzer Extends dc.jrpereira.fhirfy.core.LLMAgent
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
    import json

    input = dataInput._Get("input")
    rawData = input._Get("rawData")
    xmlData = self.GetLLMResponse(rawData)

    xmlData = xmlData.replace("```xml\n", "")
    xmlData = xmlData.replace("```xml", "")
    xmlData = xmlData.replace("```\n", "")
    xmlData = xmlData.replace("```", "")
    try:
        result = xmltodict.parse(xmlData)["result"]
    except Exception as e:
        raise Exception("Failed to parse XML data: " + str(e) + "\n XML data: " + xmlData)
    
    result = {"markdownResponse": result}
    result = json.dumps(result)
    return result
}

Method GetSystemPrompt(data) As %String [ Language = python ]
{
    import iris
    clean = iris.cls("dc.jrpereira.fhirfy.core.Utils").CleanTripleQuotesString
    return clean(f"""You are a helpful interoperability assistant, specialist in healthcare data exchange using FHIR standard. 
As such, you'll be interested in explain the structure of the target raw data to work with it effectively.
Explain the following healthcare data to a human interoperability developer.
A sample of the data for your analysis:
```
{data}
```
Return the text of you analysis into a XML document like this:

<result><![CDATA[
your text
]]><result>

The text string must be formatted using markdown.""")
}

}
