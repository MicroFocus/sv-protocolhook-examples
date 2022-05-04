
# Using Protocol Hook Script to Fix Security Tokens

## Motivation

Security tokens are often protected against a man-in-the-middle attack. But virtualizing endpoints always means putting SV in the middle of the client-endpoint communication. After you create a virtual endpoint the client will send messages to the virtual endpoint, which will either generate a simulated response right away (Simulation Mode) or forward the request to the original real endpoint (Learning or Passthrough Mode). Often the accessed Url is used as one of the arguments to calculate security tokens, and since the virtual endpoint Url will always be different from the real endpoint Url, you need to recalculate the security token value when passing messages towards the real endpoint.

## Resources to Download
- [SV Project](/Project) (requires SV version 2022 or higher)
- [TinyOAuth1 Library](https://www.nuget.org/api/v2/package/TinyOAuth1/1.1.0) (you need to unzip the nupkg file and find the TinyOAuth1.dll file to use in \lib\netstandard2.0 )

## Virtualizing OAuth 1.0 Token

This is the Url to virtualize, used to add a new status on Twitter: 

POST https://localhost:7205/1.1/statuses/update.json?status=Hello%20world

The request will be forwarded to the real endpoint:

POST https://api.twitter.com/1.1/statuses/update.json?status=Hello%20world

The algorithm calculating OAuth 1.0 token uses the resource Url as one of the arguments. The following script uses [the TinyOAuth1 library](https://github.com/johot/TinyOAuth1) to recalculate the OAuth token value before forwarding the request to the real Twitter endpoint. 

```
using HP.SV.DotNetRuleApi.Hook.Processing;
using HP.SV.DotNetRuleApi.Hook.Processing.Attributes;
using HP.SV.DotNetRuleApi.Hook.Processing.ProtocolMetadata;

using TinyOAuth1;
using System.Net.Http;

namespace HP.SV
{
    [DefaultMessageMetadataProtocol(HttpProtocolMetadata.Namespace)]
    public class ProcessingHook : ProcessingHookBase
    {
        private const string ConsumerKeyValue = "Fill in the consumer key here...";
        private const string ConsumerSecretValue = "Fill in the consumer secret here...";
        private const string TokenKeyValue = "Fill in the token key here...";
        private const string TokenSecretValue = "Fill in the token secret here...";

        [MessageMetadataAccess(HttpProtocolMetadata.AuthorizationHeaderKey)]
        [MessageMetadataAccess(HttpProtocolMetadata.RealResourceUriKey)]
        public override PostprocessMetadataResult PostprocessMetadata(PostprocessMetadataContext context)
        {
            var realResourceUri = context.GetMessageMetadataValue<string>(HttpProtocolMetadata.RealResourceUriKey);

            if (context.IsRequest)
            {
                var config = new TinyOAuthConfig
                {
                    ConsumerKey = ConsumerKeyValue,
                    ConsumerSecret = ConsumerSecretValue
                };

                var tinyOAuth = new TinyOAuth(config);
                var authorizationHeader = tinyOAuth.GetAuthorizationHeader(TokenKeyValue,
                                                                           TokenSecretValue,
                                                                           realResourceUri,
                                                                           HttpMethod.Post);

                var authorizationHeaderString = $"{authorizationHeader.Scheme} {authorizationHeader.Parameter}";
                
                return new PostprocessMetadataResult()
                        .SetMessageMetadataValue(HttpProtocolMetadata.AuthorizationHeaderKey, authorizationHeaderString);
            }
            else
            {
                return new PostprocessMetadataResult();
            }
        }
    }
}

```

**To make it work:**
- Create a Twitter developer account and fill in real values to ConsumerKeyValue, ConsumerSecretValue, TokenKeyValue, and TokenSecretValue constants in the script above.
- Download the TinyOAuth1.dll and place it in a dedicated folder (the name is arbitrary) in \Service Virtualization Designer\Designer\Extensions or \Service Virtualization Server\Server\Extensions
- Before using an external DLL, you need to restart the SV Designer or the SV Server (for the SV Server, make sure [the security mode is off in the config file](https://admhelp.microfocus.com/sv/en/2022/Help/Content/UG/t_scripted_rule_Csharp.htm#mt-item-1))

**The key takeaways from the above script:**
- Out of the 3 methods to customize (Preprocess, PostprocessMetadata, PostprocessPayload) we need to override just the PostprocessMetadata method since we will modify the Authorization header when the request leaves SV for the real endpoint.
- By testing for context.IsRequest we make sure to modify the Authorization header only for requests leaving SV processing. 
- The else clause leaves the message unchanged by returning new PostprocessMetadataResult() without calling any method on it.
- The PostprocessMetadata method is annotated with the MessageMetadataAccess attribute. For performance reasons we have to specify, which metadata values we intend to use inside the method. 
- Since we defined the default namespace HttpProtocolMetadata.Namespace on the class level using the DefaultMessageMetadataProtocol attribute, we can specify just the metadata name in the MessageMetadataAccess attribute (the namespace is an optional second argument).
- We use the GetMessageMetadataValue to retrieve the RealResourceUri metadata. We feed it into the TinyOAuth1 lib, and we store the recalculated Authorization header value using the SetMessageMetadataValue method called on the PostprocessMetadataResult object.

**Get more information about the Protocol Hook script:**
- See this [section in SV Help](https://admhelp.microfocus.com/sv/en/2022/Help/Content/UG/Scripting-main.htm).
- See the [API Reference](https://admhelp.microfocus.com/documents/sv/DotNetRuleApi/2022/html/d39d71c9-e338-47d4-14ca-2019ef1e5184.htm), especially the section on which [metadata you can read, update or delete](https://admhelp.microfocus.com/documents/sv/DotNetRuleApi/2022/html/54af2bdb-1d17-3ee8-89f7-41919463ea3e.htm).

Are you missing a feature or functionality in the Protocol Hook script? Post your suggestions to our [community forum](https://community.microfocus.com/adtd/sv/i/svideas).