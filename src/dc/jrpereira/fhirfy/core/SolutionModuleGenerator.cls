Class dc.jrpereira.fhirfy.core.SolutionModuleGenerator Extends dc.jrpereira.fhirfy.core.LLMAgent
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
    import iris
    
    input = dataInput._Get("input")
    xmlData = self.GetLLMResponse(input)
    result = self.GenerateModule(xmlData)
    return result
}

Method GetSystemPrompt(data) As %String [ Language = python ]
{
    import iris

    solutionSuggestion = data._Get("solutionSuggestion")._ToJSON()
    rawDataOverview = data._Get("analysis")

    clean = iris.cls("dc.jrpereira.fhirfy.core.Utils").CleanTripleQuotesString
    return clean(f"""
# Problem statement

You have to implement a serie of Python modules following provided instructions in order to transform raw data into FHIR.
The instructions are formatted in JSON. The raw data overview is provided in markdown.
Implements all sub modules in the `subModules` key in the instructions JSON and the overview of the raw data.
Create a file called main.py which implements the pseudo code in the `pseudoCode` key in the instructions JSON.
Create a __init__.py file which imports all the required modules.
Use the Python library identiified in the PIP as "fhir.resources", to handle FHIR data.

Raw data overview:

```
{rawDataOverview}
```

Instructions JSON to your solution:

```json
{solutionSuggestion}
```

# Response expected format

Your answer must be a valid XML object which includes:
- the source code of the **whole** module into a XML CDATA block
- an object with information about each of the sub module functions, including:
    - the function name
    - the function description and purpose
    - a list with the input parameters with information about them
    - a description of the function return
- don't include any aditional formatting characters

Follow this template, replacing text between ## and ## with your answers:
<?xml version="1.0" encoding="UTF-8"?>
<module>
    <name>## module name formmated in snake case ##</name>
    <description>## modle high level description ##</description>
    <dependencies>
<![CDATA[
## File requirements.txt for Python dependencies ##
]]>
    </dependencies>
    <files>
        <!-- The Python package description -->
        <file>
            <name>__init__.py</name>
            <description></description>
            <source-code>
<![CDATA[
...
]]>
            </source-code>
        </file>
        <!-- The main files description -->
        <file>
            <name>main.py</name>
            <description></description>
            <source-code>
<![CDATA[
...
]]>
            </source-code>
        </file>
        <!-- Package sub modules -->
        <file>
            <name>sub-module-name.py</name>
            <description></description>
            <!-- sub module source code -->
            <source-code>
<![CDATA[
...
]]>
            </source-code>
            <!-- sub module functions metadata -->
            <functions>
                <function>
                    <name></name>
                    <description></description>
                    <input>
                        <parameter>
                            <name></name>
                            <type></type>
                            <description></description>
                        </parameter>
                        <!-- Additional input parameters if needed -->
                    </input>
                    <output></output>
                </function>
                <!-- Additional functions if needed -->
            </functions>
        </file>
        <!-- Additional sub-modules files if needed -->
    </files>
</module>
""")
}

Method GenerateModule(xmlData As %String) As %String [ Language = python ]
{
    import xmltodict
    import json
    import iris

    xmlData = xmlData.replace("```xml", "")
    xmlData = xmlData.replace("```", "")
    #; xmlData = xmlData.replace("                ", "")
    
    try:
        xmlDict = xmltodict.parse(xmlData)
    except Exception as e:
        raise Exception("Failed to parse XML data: " + str(e) + "\n XML data: " + xmlData)
    xmlDict = xmlDict["module"]
    # avoid the structure ["files"]["file"]
    xmlDict["files"] = xmlDict["files"]["file"]
    result = json.dumps(xmlDict)

    result = iris.cls("%Library.DynamicObject")._FromJSON(result)
    self.CreateSolutionModuleWrapper(result)

    return result
}

Method CreateSolutionModuleWrapper(moduleInfo As %String)
{
    $$$ThrowOnError(..CreateSolutionModule(moduleInfo))
}

Method CreateSolutionModule(moduleInfo As %DynamicObject, baseDirectory As %String = "") As %Status
{
    Set status = $$$OK
    Try {
        If baseDirectory = "" {
            Set baseDirectory = ##class(%File).NormalizeDirectory("/home/irisowner/dev/python")
        }
        Set moduleDirectory = baseDirectory_"/"_moduleInfo.name
        $$$ThrowOnError(..CreateModuleDirectory(moduleInfo, baseDirectory))
        $$$ThrowOnError(..WriteRequirementsFile(moduleInfo, moduleDirectory))
        $$$ThrowOnError(..WritePythonFiles(moduleInfo, moduleDirectory))
    } Catch ex {
        Set status = ex.AsStatus()
        throw ex
    }
    Return status
}

Method CreateModuleDirectory(moduleInfo As %DynamicObject, baseDirectory As %String) As %Status
{
    Set status = $$$OK
    Try {
        If ('$IsObject(moduleInfo)) || ($ZSTRIP(moduleInfo.name, "<>W") = "") {
            Throw ##class(%Exception.General).%New("Module name is missing or invalid.")
        }

        Set moduleName = moduleInfo.name
        Set moduleDirectory = ##class(%File).NormalizeDirectory(baseDirectory_"/"_moduleName)
        
        Set isOK = ##class(%File).CreateDirectoryChain(moduleDirectory, .output)
        If 'isOK {
            Throw ##class(%Exception.General).%New("Unable to create module directory "_moduleDirectory_". Error: "_output)
        }
    } Catch ex {
        Set status = ex.AsStatus()
    }
    Return status
}

Method WritePythonFiles(moduleMetadata As %DynamicObject, baseDirectory As %String) As %Status
{
	Set status = $$$OK
    Try {
        If '$IsObject(moduleMetadata) {
            Throw ##class(%Exception.General).%New("Module metadata is missing or invalid.")
        }

        Set it = moduleMetadata.files.%GetIterator()
		While (it.%GetNext(.key, .file)){
            If ('$IsObject(file)) || (file.name = "") || (file."source-code" = "") {
                Throw ##class(%Exception.General).%New("File metadata is missing or invalid.")
            }

            Set pythonFilePath = baseDirectory_"/"_file.name

            Set status = ..WriteFile(pythonFilePath, file."source-code")
            If $$$ISERR(status) {
                Throw ##class(%Exception.General).%New("Error writing Python file: "_$System.Status.GetErrorText(status))
            }
        }
    } Catch ex {
        Set status = ex.AsStatus()
    }
    Quit status
}

Method WriteRequirementsFile(moduleMetadata As %DynamicObject, baseDirectory As %String) As %Status
{
	Set status = $$$OK
    Try {
        Set requirementsFilePath = baseDirectory_"/requirements.txt"
        $$$ThrowOnError(..WriteFile(requirementsFilePath, moduleMetadata.dependencies))
    } Catch ex {
        Set status = ex.AsStatus()
    }

    Quit status
}

Method WriteFile(filePath As %String, fileContent As %String) As %Status
{
	Set status = $$$OK
    Try {
        Set fileStream = ##class(%File).%New(filePath)
        Set status = fileStream.Open("WN")
        If $$$ISERR(status) {
            Throw ##class(%Exception.General).%New("Error opening file: "_$System.Status.GetErrorText(status))
        }

        Set status = fileStream.WriteLine(fileContent)
        If $$$ISERR(status) {
            Throw ##class(%Exception.General).%New("Error writing to file: "_$System.Status.GetErrorText(status))
        }
    } Catch ex {
        Set status = ex.AsStatus()
    }

    Quit status
}

Method CompressModule(moduleName) As %String [ Language = python ]
{
    import os
    import tempfile
    import shutil
    
    try:
        directory_to_compress = f"/home/irisowner/dev/python/{moduleName}"
        temp_dir = tempfile.mkdtemp()
        compressed_file = os.path.join(temp_dir, f'{moduleName}.tar.gz')
        shutil.make_archive(compressed_file[:-7], 'gztar', directory_to_compress)
    except Exception as e:
        raise Exception("Failed to compress module: " + str(e))
    #; finally:
    #;     shutil.rmtree(temp_dir)

    return compressed_file
}

}
