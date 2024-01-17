Class dc.jrpereira.fhirfy.core.SolutionModuleGenerator Extends %RegisteredObject
{

Method GetResponse(dataInput As %DynamicObject) As %String [ Language = python ]
{
    import xmltodict
    import json
    xmlData = r"""<?xml version="1.0" encoding="UTF-8"?>
<module>
    <name>csv_to_hl7_fhir_converter</name>
    <description>This solution converts CSV data with patient information into the HL7 FHIR protocol.</description>
    <files>
        <file>
            <name>__init__.py</name>
            <description></description>
            <source-code>
            <![CDATA[
                from .CSVParser import CSVParser
                from .FHIRBuilder import FHIRBuilder
            ]]>
            </source-code>
        </file>
        <file>
            <name>main.py</name>
            <description></description>
            <source-code>
            <![CDATA[
                from CSVParser import CSVParser
                from FHIRBuilder import FHIRBuilder

                csv_data = "Patient ID,Patient Name\n42,Armstrong51\n43,Gusikowski974\n50,Stanton715\n66,Sawayn19\n919,Halvorson124"
                csv_parser = CSVParser(csv_data)
                parsed_data = csv_parser.parse()

                fhir_builder = FHIRBuilder()
                fhir_data = fhir_builder.build(parsed_data)

                print(fhir_data)
            ]]>
            </source-code>
        </file>
        <file>
            <name>CSVParser.py</name>
            <description></description>
            <source-code>
            <![CDATA[
                class CSVParser:
                    def __init__(self, csv_data):
                        self.csv_data = csv_data

                    def parse(self):
                        lines = self.csv_data.split('\n')
                        headers = lines[0].split(',')
                        data = []
                        for line in lines[1:]:
                            values = line.split(',')
                            patient = {}
                            for i, value in enumerate(values):
                                patient[headers[i]] = value
                            data.append(patient)
                        return data
            ]]>
            </source-code>
            <functions>
                <function>
                    <name>__init__</name>
                    <description>Initializes the CSVParser object with the CSV data.</description>
                    <input>
                        <parameter>
                            <name>csv_data</name>
                            <type>str</type>
                            <description>The CSV data to be parsed.</description>
                        </parameter>
                    </input>
                    <output></output>
                </function>
                <function>
                    <name>parse</name>
                    <description>Parses the CSV data into a list of dictionaries, where each dictionary represents a patient.</description>
                    <input></input>
                    <output>list</output>
                </function>
            </functions>
        </file>
        <file>
            <name>FHIRBuilder.py</name>
            <description></description>
            <source-code>
            <![CDATA[
                class FHIRBuilder:
                    def build(self, data):
                        fhir_data = []
                        for patient in data:
                            fhir_patient = {}
                            fhir_patient["resourceType"] = "Patient"
                            fhir_patient["id"] = patient["Patient ID"]
                            fhir_patient["name"] = [{"family": patient["Patient Name"]}]
                            fhir_data.append(fhir_patient)
                        return fhir_data
            ]]>
            </source-code>
            <functions>
                <function>
                    <name>__init__</name>
                    <description>Initializes the FHIRBuilder object.</description>
                    <input></input>
                    <output></output>
                </function>
                <function>
                    <name>build</name>
                    <description>Builds the HL7 FHIR representation of the patient data.</description>
                    <input>
                        <parameter>
                            <name>data</name>
                            <type>list</type>
                            <description>The list of dictionaries representing the patient data.</description>
                        </parameter>
                    </input>
                    <output>list</output>
                </function>
            </functions>
        </file>
    </files>
</module>
    """
    xmlData = xmlData.replace("\t\t                ", "")
    xmlDict = xmltodict.parse(xmlData)["module"]
    # avoid the structure ["files"]["file"]
    xmlDict["files"] = xmlDict["files"]["file"]
    result = json.dumps(xmlDict)

    import iris
    result = iris.cls("%Library.DynamicObject")._FromJSON(result)
    self.CreateSolutionModuleWrapper(result)

    return result
}

Method CreateSolutionModuleWrapper(moduleInfo As %DynamicObject)
{
    $$$ThrowOnError(..CreateSolutionModule(moduleInfo))
}

Method CreateSolutionModule(moduleInfo As %DynamicObject) As %Status
{
    Set status = $$$OK
    Try {
        #; Set baseDirectory = ##class(%File).NormalizeDirectory("/tmp")
        Set baseDirectory = ##class(%File).NormalizeDirectory("/home/irisowner/dev/python")
        $$$ThrowOnError(..CreateModuleDirectory(moduleInfo, baseDirectory))
        $$$ThrowOnError(..WritePythonFiles(moduleInfo, baseDirectory_"/"_moduleInfo.name))
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

}
