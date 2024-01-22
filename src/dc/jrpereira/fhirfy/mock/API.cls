Class dc.jrpereira.fhirfy.mock.API Extends dc.jrpereira.fhirfy.core.API
{

ClassMethod GetInstance(mockName As %String) As dc.jrpereira.fhirfy.mock.API
{
    If (mockName = "simple-csv") {
        Return ##class(dc.jrpereira.fhirfy.mock.simplecsv.API).%New()
    } Else {
        Throw ##class(%Exception.General).%New("Mock not found")
    }
}

}
