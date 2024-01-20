Class dc.jrpereira.fhirfy.mock.API Extends %RegisteredObject
{

Property SimpleCSV As dc.jrpereira.fhirfy.mock.SimpleCSV;

Method %OnNew() As %Status
{
    Set ..SimpleCSV = ##class(dc.jrpereira.fhirfy.mock.SimpleCSV).%New()
    Return $$$OK
}

Method GetSimpleCSVMockData() As %DynamicObject
{
    Set module = ..SimpleCSV.GetResponse()
    Return module
}

}
