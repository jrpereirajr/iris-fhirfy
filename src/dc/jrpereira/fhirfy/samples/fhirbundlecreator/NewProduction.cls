Class dc.jrpereira.fhirfy.samples.fhirbundlecreator.NewProduction Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="dc.jrpereira.fhirfy.samples.fhirbundlecreator.NewProduction" TestingEnabled="true" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="PatientCSVLandingBS" Category="" ClassName="EnsLib.File.PassthroughService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="TargetConfigNames">FhirBundleCreatorBP</Setting>
    <Setting Target="Adapter" Name="FilePath">/tmp</Setting>
    <Setting Target="Adapter" Name="FileSpec">*.csv</Setting>
    <Setting Target="Adapter" Name="DeleteFromServer">1</Setting>
  </Item>
  <Item Name="FhirBundleCreatorBP" Category="" ClassName="dc.jrpereira.fhirfy.samples.fhirbundlecreator.FhirBundleCreatorBP" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="FhirBundleCreatorBO" Category="" ClassName="dc.jrpereira.fhirfy.samples.fhirbundlecreator.FhirBundleCreatorBO" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="SendFHIRBundleToServerBO" Category="" ClassName="EnsLib.REST.GenericOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="HTTPPort">52773</Setting>
    <Setting Target="Adapter" Name="HTTPServer">localhost</Setting>
    <Setting Target="Adapter" Name="URL">/fhir/r4/</Setting>
  </Item>
</Production>
}

}
