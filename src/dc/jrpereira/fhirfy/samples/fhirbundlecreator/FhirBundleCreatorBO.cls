Class dc.jrpereira.fhirfy.samples.fhirbundlecreator.FhirBundleCreatorBO Extends Ens.BusinessOperation
{

/// This is the default message handler.  All request types not declared in the message map are delivered here
Method OnMessage(pRequest As Ens.StreamContainer, Output pResponse As Ens.StreamContainer) As %Status
{
	Set tSC = $$$OK
	Try {
        Set response = ..FhirBundleCreator(pRequest.OriginalFilename)
        Set pResponse = ##class(Ens.StreamContainer).%New()
        Set pResponse.OriginalFilename = response
        Set pResponse.Stream = ##class(%Stream.FileBinary).%New()
        $$$TOE(tSC, pResponse.Stream.LinkToFile(response))
	}
	Catch (ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

ClassMethod FhirBundleCreator(data As %String) As %String [ Language = python ]
{
    import iris
    inst = iris.cls("dc.jrpereira.fhirfy.samples.fhirbundlecreator.Main")._New()
    json = inst.FhirBundleCreator(data)
    return json.replace("'", "\"")
}

}
