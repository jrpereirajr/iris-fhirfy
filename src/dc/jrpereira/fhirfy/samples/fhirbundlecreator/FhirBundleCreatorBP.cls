/// 
Class dc.jrpereira.fhirfy.samples.fhirbundlecreator.FhirBundleCreatorBP Extends Ens.BusinessProcessBPL
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Ens.StreamContainer' response='Ens.StringResponse' height='2000' width='2000' >
<sequence xend='200' yend='450' >
<call name='FhirBundleCreatorBO' target='FhirBundleCreatorBO' async='0' xpos='200' ypos='250' >
<request type='Ens.StreamContainer' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.StreamContainer' >
<assign property="request.Stream" value="callresponse.Stream" action="set" />
<assign property="request.OriginalFilename" value="callresponse.OriginalFilename" action="set" />
</response>
</call>
<call name='SendFHIRBundleToServerBO' target='SendFHIRBundleToServerBO' async='0' xpos='200' ypos='350' >
<request type='EnsLib.REST.GenericMessage' >
<assign property="callrequest.Stream" value="request.Stream" action="set" />
<assign property="callrequest.OriginalFilename" value="request.OriginalFilename" action="set" />
<assign property="callrequest.HTTPHeaders" value="&quot;application/fhir+json;charset=utf-8&quot;" action="set" key="&quot;Content-Type&quot;" />
<assign property="callrequest.HTTPHeaders" value="&quot;application/fhir+json;charset=utf-8&quot;" action="set" key="&quot;Accept&quot;" />
</request>
<response type='EnsLib.REST.GenericMessage' >
<assign property="response.StringValue" value="callresponse.HTTPHeaders.GetAt(&quot;StatusLine&quot;)" action="set" />
</response>
</call>
</sequence>
</process>
}

}
