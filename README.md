
# Protocol Hook Script Samples

The purpose of the Protocol Hook script is to access and modify message payload and metadata.
Below you will find examples of the practical benefits of applying the Protocol Hook script before or after message processing in SV.

## Using Protocol Hook to Change Metadata

This Twitter API example shows how to modify the HTTP Authorization header in a REST service to make OAuth 1.0 tokens work in recording and passthrough.
For OAuth 1.0 request URL is one of the arguments of token calculation to protect against a man-in-the-middle attack. When you put a virtual service in the middle of the communication between the client application and the real endpoint, the client application will send requests to a different URL (the virtual endpoint URL listening on SV Server), thus you need to recalculate the OAuth 1.0 token when the request is passing through the virtual service towards the real endpoint.
A similar modification may be needed to fix other types of metadata (before or after SV processing) to make simulation, learning, or passthrough work in many other scenarios.

**Sample:** [Using Protocol Hook script to make OAuth 1.0 work when virtualizing Twitter API](SecurityTokenSample/README.md)

## Using Protocol Hook to Change Payload

There are multiple scenarios where you can benefit from modifying the message payload before or after SV processing.
- You can fix a broken message before it enters SV.
- You can convert an unsupported message type to a supported one (like XML) to make processing of the unsupported type of payload possible.
- You can modify the message so that it looks more conveniently represented in the SV data model as shown in the example below.

**Sample:** [Using Protocol Hook script to pivot XML array items to make them easier to process in SV data mode](XsltSample/README.md)

## Protocol Hook in SV Help

Get more information about the Protocol Hook script:
- See this [section in SV Help](https://admhelp.microfocus.com/sv/en/2022/Help/Content/UG/Scripting-main.htm).
- See the [API Reference](https://admhelp.microfocus.com/documents/sv/DotNetRuleApi/2022/html/d39d71c9-e338-47d4-14ca-2019ef1e5184.htm), especially the section on which [metadata you can read, update or delete](https://admhelp.microfocus.com/documents/sv/DotNetRuleApi/2022/html/54af2bdb-1d17-3ee8-89f7-41919463ea3e.htm).

Are you missing a feature or functionality in the Protocol Hook scrit? Write your suggestions to our [community forum](https://community.microfocus.com/adtd/sv/i/svideas).