<?xml version="1.0" encoding="utf-8"?>
<vs:virtualService version="5.5.0.6315" id="45c16942-37bb-4904-9965-9d434c87b5b7" name="Details Retrieval Service" description="Virtual service using REST" activeConfiguration="aaa9fdf1-fbc7-4766-bf40-ad5ead0b46f8" nonExistentRealService="true" xmlns:vs="http://hp.com/SOAQ/ServiceVirtualization/2010/">
  <vs:projectId ref="{18280BF7-C984-4758-9F74-8156B42A666D}" />
  <vs:projectName>Xslt Transformation Sample</vs:projectName>
  <vs:serviceDescription ref="968cd1d8-a1af-4c1d-96ce-53beaf976e90" />
  <vs:virtualEndpoint type="HTTP" address="test" realAddress="" isTemporary="false" isDiscovered="false" useRealService="false" id="6a01d5d3-9adf-4cf8-82f7-d04639c40993" name=" Endpoint">
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
  <vs:dataModel ref="661b95d5-5acf-413a-ba91-84a1119d9f33" />
  <vs:performanceModel ref="abe5dcc6-d090-42bc-a997-21e4a0f30589" />
  <vs:performanceModel ref="56f42ad6-5903-4964-9433-356765d78241" />
  <vs:performanceModel ref="d1396120-0612-4a40-a0f6-773e3b7fa257" />
  <vs:configuration id="aaa9fdf1-fbc7-4766-bf40-ad5ead0b46f8" name="Details Retrieval Service Configuration">
    <vs:httpAuthentication>None</vs:httpAuthentication>
    <vs:httpAuthenticationAutodetect>True</vs:httpAuthenticationAutodetect>
    <vs:messageSchemaLocked>False</vs:messageSchemaLocked>
    <vs:enableTrackLearning>True</vs:enableTrackLearning>
    <vs:logMessages>False</vs:logMessages>
  </vs:configuration>
</vs:virtualService>