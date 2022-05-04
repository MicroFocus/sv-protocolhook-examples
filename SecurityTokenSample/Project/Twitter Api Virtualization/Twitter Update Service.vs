<?xml version="1.0" encoding="utf-8"?>
<vs:virtualService version="5.5.0.6315" id="7689d232-8b5b-4aaa-a04a-34836f359bd4" name="Twitter Update Service" description="Virtual service using REST" activeConfiguration="ed58d739-d97f-416d-931c-b40cbf331fce" nonExistentRealService="false" xmlns:vs="http://hp.com/SOAQ/ServiceVirtualization/2010/">
  <vs:projectId ref="{21C2D668-E386-4601-9854-27094B7DA7E1}" />
  <vs:projectName>Twitter Api Virtualization</vs:projectName>
  <vs:serviceDescription ref="c2df1f60-b29e-41ea-b08f-197a10dce54b" />
  <vs:virtualEndpoint type="HTTP" address="1.1/statuses" realAddress="https://api.twitter.com/1.1/statuses" isTemporary="false" isDiscovered="false" useRealService="true" id="e78d9b4e-0439-4a91-8ea1-447dd075bae5" name=" Endpoint">
    <vs:virtualInputAgent ref="HttpsAgent" name="HTTPS Gateway" />
    <vs:virtualOutputAgent ref="HttpsAgent" name="HTTPS Gateway" />
    <vs:realInputAgent ref="HttpsAgent" name="HTTPS Gateway" />
    <vs:realOutputAgent ref="HttpsAgent" name="HTTPS Gateway" />
    <vs:properties>
      <entry key="HTTP.AuthenticationAutodetect">True</entry>
      <entry key="HTTP.Custom401UnauthorizedHandling">False</entry>
      <entry key="REST.StrictUriSpecification">False</entry>
    </vs:properties>
  </vs:virtualEndpoint>
  <vs:dataModel ref="9f56ea79-c546-4874-a2f8-de4acf2d820d" />
  <vs:performanceModel ref="85607658-9436-4d46-9bdf-1399b716e1cd" />
  <vs:performanceModel ref="8433f056-1c78-4780-8c56-97c3fc47a739" />
  <vs:performanceModel ref="27ba98ca-0dbf-4d1a-85c8-858fc0802aeb" />
  <vs:configuration id="ed58d739-d97f-416d-931c-b40cbf331fce" name="Twitter Update Service Configuration">
    <vs:httpAuthentication>None</vs:httpAuthentication>
    <vs:httpAuthenticationAutodetect>True</vs:httpAuthenticationAutodetect>
    <vs:messageSchemaLocked>False</vs:messageSchemaLocked>
    <vs:enableTrackLearning>True</vs:enableTrackLearning>
    <vs:logMessages>False</vs:logMessages>
  </vs:configuration>
</vs:virtualService>