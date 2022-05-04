
# Using Protocol Hook Script to Modify Payload using XSLT

The following example shows how you can use the Protocol Hook script to modify the message payload.

**Motivation to modify payload:**
- **General**: Imagine you need to process a payload serialized in an unusual manner, perhaps some kind of binary form. You can use a Protocol Hook script to convert such a message into a well-known payload format like XML. If you transform the message before it enters SV processing, and also after it leaves SV processing, the messages will appear to SV as if it was XML. In such a case, SV will be able to process the unknown message type without issues.
- **In this example**: Sometimes even ordinary XML messages can look impractical when represented inside the SV data model. This often happens for message structures that were designed in a too generic manner. In these cases, you very often come across generic arrays where node values contain what would normally be represented via XML element names. See the sample messages below.

## Resources to Download
- [SV Project](/Project) (requires SV version 2022 or higher)
- [XSLT Library Extenstion](/XsltExtension)

## Sample Request

This is the request message we need to virtualize:

```
<?xml version="1.0" encoding="utf-8"?>
<GetPersonalDetailsRequest>
   <PersonID>123456</PersonID>
   <DetailsToRetrieve>
      <Detail>Address</Detail>
      <Detail>Job</Detail>
      <Detail>Hobby</Detail>
   </DetailsToRetrieve>
</GetPersonalDetailsRequest>
```

Notice that for a person (given by the PersonID) the set of details requested to be retrieved is specified by an array of Detail elements. An equivalent, but less generic implementation could look like this:

```
<?xml version="1.0" encoding="utf-8"?>
<GetPersonalDetailsRequest>
   <PersonID>123456</PersonID>
   <DetailsToRetrieve>
      <Address>true</Address>
      <Job>true</Job>
      <Hobby>true</Hobby>
   </DetailsToRetrieve>
</GetPersonalDetailsRequest>
```

The structure above is less generic and thus SV can understand it better. In the SV data model, you can specify a different row matching condition for Address retrieval, or Job retrieval since Job and Address are different XML elements, not items of the same array. Setting up conditions on array items is much more complicated, you would likely have to use scripting.

We will use an XSLT transformation applied [before](XsltExtension/XsltLibrary/Resources/XsltBeforeProcessing.xslt) and [after](XsltExtension/XsltLibrary/Resources/XsltAfterProcessing.xslt) SV processing. In this way the message will appear as the latter, rather than the former one during SV processing.


## Sample Response

This is the response message we need to virtualize:

```
<?xml version="1.0" encoding="utf-8"?>
<GetPersonalDetailsResponse>
  <PersonalDetail type="FirstName">John</PersonalDetail>
  <PersonalDetail type="Surname">Doe</PersonalDetail>
  <PersonalDetail type="Street">Main Street</PersonalDetail>
  <PersonalDetail type="Town">New Town</PersonalDetail>
  <PersonalDetail type="ZipCode">987654</PersonalDetail>
  <PersonalDetail type="Job">Artist</PersonalDetail>
  <PersonalDetail type="Hobby">Programming</PersonalDetail>
</GetPersonalDetailsResponse>
```

Notice that instead of XML elements named FirstName, Surname, etc. we have a generic PersonalDetail element with a type attribute. A less generic implementation would look like this:

```
<?xml version="1.0" encoding="utf-8"?>
<GetPersonalDetailsResponse>
   <FirstName>John</FirstName>
   <Surname>Doe</Surname>
   <Street>Main Street</Street>
   <Town>New Town</Town>
   <ZipCode>987654</ZipCode>
   <Job>Artist</Job>
   <Hobby>Programming</Hobby>
</GetPersonalDetailsResponse>
```

The structure above is simpler to process in SV since you can set different action functions to generate values of different elements. In the original message, you would have to script the generation of PersonalDetail elements depending on its type attribute.

We will use an XSLT transformation applied [before](XsltExtension/XsltLibrary/Resources/XsltBeforeProcessing.xslt) and [after](XsltExtension/XsltLibrary/Resources/XsltAfterProcessing.xslt) SV processing. In this way the message will appear as the latter, rather than the former one during SV processing.


## Using XSLT Transformation in SV

We will use the REST protocol, create a simple service, and in the Service Description editor, we will create the following Protocol Hook script, which will modify the payload by applying an XSLT transformation [before](XsltExtension/XsltLibrary/Resources/XsltBeforeProcessing.xslt) and [after](XsltExtension/XsltLibrary/Resources/XsltAfterProcessing.xslt) SV processing. 

```
using System;
using System.Text;

using HP.SV.DotNetRuleApi.Hook.Processing;
using HP.SV.DotNetRuleApi.Hook.Processing.Attributes;
using HP.SV.DotNetRuleApi.Hook.Processing.ProtocolMetadata;

using XsltLibrary;

namespace HP.SV
{
    public class ProcessingHook : ProcessingHookBase
    {
        public override PreprocessResult Preprocess(PreprocessContext context) 
        {
            var payload = context.GetMessagePayload(); 
            payload = XsltProcessor.TransformBeforeProcessing(payload);
            return new PreprocessResult()  
                .SetMessagePayload(payload); 
        }

        public override PostprocessPayloadResult PostprocessPayload(PostprocessPayloadContext context)
        {
            var payload = context.GetMessagePayload(); 
            payload = XsltProcessor.TransformAfterProcessing(payload);        	
            return new PostprocessPayloadResult()
                .SetMessagePayload(payload);
        }
    }
}
```

**The key takeaways from the above script:**
- We use the XsltProcessor class from the XsltLibrary to perform XSLT. We moved the code into a separate C# project which builds into an external extension DLL.
- The XSLT files are incorporated using DLL resources. 
- **You can use this C# library project for your purposes and just specify your custom XSLT transformation files.**

Using an external library from SV C# code has the following specifics:
- You have the lifespan of the instantiated objects completely under control (static data are guaranteed to be initialized just once).
- To use an external DLL, you need to create a dedicated folder for it (the name is arbitrary) in \Service Virtualization Designer\Designer\Extensions or \Service Virtualization Server\Server\Extensions
- Before using an external DLL, you need to restart the SV Designer or the SV Server (for the SV Server, make sure [the security mode is off in the config file](https://admhelp.microfocus.com/sv/en/2022/Help/Content/UG/t_scripted_rule_Csharp.htm#mt-item-1))


**Get more information about the Protocol Hook script:**
- See this [section in SV Help](https://admhelp.microfocus.com/sv/en/2022/Help/Content/UG/Scripting-main.htm).

Are you missing a feature or functionality in the Protocol Hook script? Post your suggestions to our [community forum](https://community.microfocus.com/adtd/sv/i/svideas).