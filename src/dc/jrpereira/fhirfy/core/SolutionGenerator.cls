Class dc.jrpereira.fhirfy.core.SolutionGenerator Extends dc.jrpereira.fhirfy.core.LLMAgent
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
    xmlData = self.GetLLMResponse(input)
    
    xmlData = xmlData.replace("```xml", "")
    xmlData = xmlData.replace("```", "")
    try:
        result = xmltodict.parse(xmlData)
    except Exception as e:
        raise Exception("Failed to parse XML data: " + str(e) + "\n XML data: " + xmlData)
    return json.dumps(result)
}

Method GetSystemPrompt(data) As %String [ Language = python ]
{
    import iris

    analysis = data._Get("analysis")
    rawData = data._Get("rawData")

    clean = iris.cls("dc.jrpereira.fhirfy.core.Utils").CleanTripleQuotesString
    return clean(f"""
# Problem statement

You have the to think how to create a code that transform raw data into a FHIR Bundle resource.
This is an analysis of the raw data:

```
{analysis}
```

Here is a sample of the data:

```
{rawData}
```

# Your task

Think step by step and suggest me a serie of Python sub modules which solve the problem.
You don't have to send me the sub modules implementations, just the name of the Python sub-modules and a description of its responsabilities.
Send me just custom sub modules with their file names; ommit third-party modules.
Send me a high-level, language-independent, pseudo code on how to organize the sub modules suggested by you in order to solve the problem.
Try to base you answer just by using the sub modules suggested by you in a concise way. Improve its readibility using markdown.
Send me a general description of you solution, understandable for a human developer.
Format your answer in XML.
Follow this template, replacing text between ## and ## with your answers:

<solutionSuggestion>
    <name>## A name which reflects na solution purpose ##</name>
    <description>## A general description of your solution understandable for a human developer ##</description>
    <subModules>
        <subModule>
            <name>## A name which reflects na solution purpose ##</name>
            <description>## Sub module description and responsibilities ##</description>
        </subModule>
    </subModules>
    <pseudoCode><![CDATA[
## Pseudo code ##
    ]]></pseudoCode>
</solutionSuggestion>
""")
}

}
