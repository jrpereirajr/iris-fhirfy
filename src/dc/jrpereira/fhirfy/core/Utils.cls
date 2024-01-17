Class dc.jrpereira.fhirfy.core.Utils Extends %RegisteredObject
{

ClassMethod LoadPatientData(path, namespace, appKey) As %Status
{
    If $GET(^IRIS.TEMP("dc.jrpereira.fhirfy.core.Utils.LoadPatientData")) {
        Return $$$OK
    }

    Set exception = ""
    Set currNS = $NAMESPACE
    Try {
        Set $NAMESPACE = namespace
        $$$ThrowOnError(##class(HS.FHIRServer.Tools.DataLoader).SubmitResourceFiles(path, namespace, appKey))
    } Catch (e) {
        Set exception = e
    }
    Set $NAMESPACE = currNS
    If ($ISOBJECT(exception)) {
        Throw exception
    }
    
    Set ^IRIS.TEMP("dc.jrpereira.fhirfy.core.Utils.LoadPatientData") = 1
}

ClassMethod CleanTripleQuotesString(stringValue As %String) As %String
{
    Return $REPLACE(stringValue, $CHAR(9,9), "")
}

}
