Class dc.jrpereira.fhirfy.unittests.core.SolutionModuleGenerator Extends %UnitTest.TestCase
{

Property generator As dc.jrpereira.fhirfy.core.SolutionModuleGenerator;

Property MyTestDirectory As %String;

Method OnBeforeAllTests() As %Status
{
    Set ..generator = ##class(dc.jrpereira.fhirfy.core.SolutionModuleGenerator).%New()
    Set ..MyTestDirectory = "/tmp"
    Quit $$$OK
}

Method OnAfterAllTests() As %Status
{
	Set status = $$$OK
	Try {
    	Do ..TearDown()
	} Catch ex {
		Set status = ex.AsStatus()
		zw ex
	}
    Quit status
}

Method TearDown() [ Language = python ]
{
	import os
	import shutil

	directory_path = f'{self.MyTestDirectory}/csv_to_hl7_fhir_converter'
	if os.path.exists(directory_path):
		shutil.rmtree(directory_path)
}

Method TestCreateModuleDirectory()
{
    Set moduleInfo = {"name": "csv_to_hl7_fhir_converter"}
    Set status = ..generator.CreateModuleDirectory(.moduleInfo, ..MyTestDirectory)
	Do $$$AssertStatusOK(status, "Expected no errors on creating a valid module directory; got "_status)

    Set directoryExists = ##class(%File).DirectoryExists(..MyTestDirectory_"/csv_to_hl7_fhir_converter")
    Do $$$AssertTrue(directoryExists, "Expected directory to exist")
}

Method TestWritePythonFiles()
{
	Set baseDirectory = ..MyTestDirectory

	Set moduleMetadata = {}
	Set status = ..generator.WritePythonFiles(.moduleMetadata, baseDirectory)
	Do $$$AssertStatusNotOK(status, "Expected exception for missing or invalid module metadata")

	Set moduleMetadata = {"files": [{"name": "", "source-code": ""}]}
	Set status = ..generator.WritePythonFiles(.moduleMetadata, baseDirectory)
	Do $$$AssertStatusNotOK(status, "Expected exception for missing or invalid file metadata")

	Set moduleMetadata = {
		"files": [
			{"name": "test_file.py", "source-code": "print('Hello, World!')"}
		]
	}
	Set status = ..generator.WritePythonFiles(.moduleMetadata, baseDirectory)
	Do $$$AssertEquals(status, $$$OK, "Expected no error when writing a valid Python file; got "_status)

	Set filePath = baseDirectory_"/test_file.py"
	Set fileExists = ##class(%File).Exists(filePath)
	Do $$$AssertTrue(fileExists, "Expected Python file to exist")
	
	// Cleanup: Delete the test file
	Set deleteStatus = ##class(%File).Delete(filePath)
	Do $$$AssertEquals(deleteStatus, $$$OK, "Error deleting test file")
}

Method TestWriteFile()
{
	Set filePath = ..MyTestDirectory_"/YourTestFile.txt"

	Set fileContent = "This is a test content."
	Set status = ..generator.WriteFile(filePath, fileContent)
	Do $$$AssertEquals(status, $$$OK, "Expected no error when writing to a valid file")

	Set fileExists = ##class(%File).Exists(filePath)
	Do $$$AssertTrue(fileExists, "Expected file to exist")
	
	Set readFileStream = ##class(%File).%New(filePath)
	Set readStatus = readFileStream.Open("R")
	Do $$$AssertEquals(readStatus, $$$OK, "Error opening the file for reading")

	Set readContent = ""
	While 'readFileStream.AtEnd {
		Set readLine = readFileStream.ReadLine()
		Set readContent = readContent _ readLine
	}
	Do $$$AssertEquals(fileContent, readContent, "File content does not match expected content")

	// Cleanup: Delete the test file
	Set deleteStatus = ##class(%File).Delete(filePath)
	Do $$$AssertEquals(deleteStatus, $$$OK, "Error deleting test file")
}

Method TestCreateSolutionModule()
{
	Set nl = $Char(13, 10)
	Set moduleInfo = {
		"name": "csv_to_hl7_fhir_converter",
		"description": "This solution converts CSV data with patient information into the HL7 FHIR protocol.",
		"files": [
			{
				"name": "__init__.py",
				"source-code": ("from .CSVParser import CSVParser"_nl_"from .FHIRBuilder import FHIRBuilder")
			},
			{
				"name": "main.py",
				"source-code": (
					"from CSVParser import CSVParser"_nl_"from FHIRBuilder import FHIRBuilder"_nl_""_nl_""_
					"csv_data = ""Patient ID,Patient Name\n42,Armstrong51\n43,Gusikowski974\n50,Stanton715\n66,Sawayn19\n919,Halvorson124"""_nl_
					"csv_parser = CSVParser(csv_data)"_nl_"parsed_data = csv_parser.parse()"_nl_
					"fhir_builder = FHIRBuilder()"_nl_"fhir_data = fhir_builder.build(parsed_data)"_nl_
					"print(fhir_data)"
				)
			}
		]
	}

	Set baseDirectory = ..MyTestDirectory

	Set status = ..generator.CreateSolutionModule(.moduleInfo, baseDirectory)
	Do $$$AssertStatusOK(status, "Expected no error during module creation")

	Set moduleDirectory = baseDirectory_"/"_moduleInfo.name
	Set moduleExists = ##class(%File).DirectoryExists(moduleDirectory)
	Do $$$AssertTrue(moduleExists, "Expected module directory to exist")

	Set it = moduleInfo.files.%GetIterator()
	While it.%GetNext(.key, .file) {
		Set pythonFilePath = moduleDirectory_"/"_file.name
		Set pythonFileExists = ##class(%File).Exists(pythonFilePath)
		Do $$$AssertTrue(pythonFileExists, "Expected Python file to exist: "_file.name)
	}
}

Method TestWriteRequirementsFile()
{
    Set moduleMetadata = {}
    Set moduleMetadata.dependencies = $LTS($LFS("numpy==1.21.2,pandas==1.3.3,matplotlib==3.4.3"), $CHAR(10))

    Set baseDirectory = ..MyTestDirectory

    Set status = ..generator.WriteRequirementsFile(moduleMetadata, baseDirectory)
    Do $$$AssertEquals(status, $$$OK, "Status should be OK")

    Set requirementsFilePath = baseDirectory_"/requirements.txt"
    Do $$$AssertTrue(##class(%File).Exists(requirementsFilePath), "Requirements file should exist")

    Set fileContents = ""
    If ##class(%File).Exists(requirementsFilePath) {
		Set stream = ##class(%Stream.FileCharacter).%New()
		$$$ThrowOnError(stream.LinkToFile(requirementsFilePath))
		Set fileContents =  stream.Read()
    }
    Do $$$AssertEquals(fileContents, moduleMetadata.dependencies_$CHAR(10), "File contents should match dependencies")
}

}
