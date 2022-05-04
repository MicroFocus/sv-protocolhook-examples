
using System.IO;
using System.Text;
using System.Xml;
using System.Xml.Xsl;

namespace XsltLibrary
{
    public class XsltProcessor
    {
        public sealed class StringWriterWithEncoding : StringWriter
        {
            private readonly Encoding encoding;

            public StringWriterWithEncoding(Encoding encoding)
            {
                this.encoding = encoding;
            }

            public override Encoding Encoding 
            {
                get 
                {
                    return encoding; 
                }
            }
        }

        private static readonly XslCompiledTransform XsltBeforeProcessing;
        private static readonly XslCompiledTransform XsltAfterProcessing;

        static XsltProcessor() 
        {
            using (XmlReader reader = XmlReader.Create(new StringReader(Resources.XsltBeforeProcessing)))
            {
                XsltBeforeProcessing = new XslCompiledTransform();
                XsltBeforeProcessing.Load(reader);
            }
            using (XmlReader reader = XmlReader.Create(new StringReader(Resources.XsltAfterProcessing)))
            {
                XsltAfterProcessing = new XslCompiledTransform();
                XsltAfterProcessing.Load(reader);
            }
        }

        private static byte[] TransformBytesWithXlst(XslCompiledTransform transformation, byte[] payload)
        {
            XmlDocument doc = new XmlDocument();
            doc.Load(new MemoryStream(payload));

            XmlWriterSettings writerSettings = new XmlWriterSettings();
            writerSettings.OmitXmlDeclaration = doc.FirstChild?.NodeType != XmlNodeType.XmlDeclaration;
            writerSettings.Indent = true;

            if (!writerSettings.OmitXmlDeclaration) 
            {
                writerSettings.Encoding = Encoding.GetEncoding(((XmlDeclaration)doc.FirstChild).Encoding);
            } 
            else 
            {
                writerSettings.Encoding = Encoding.UTF8;
            }

            using (var output = new StringWriterWithEncoding(writerSettings.Encoding))
            {
                using (XmlWriter writer = XmlWriter.Create(output, writerSettings))
                {
                    transformation.Transform(doc, null, writer);
                }
                return writerSettings.Encoding.GetBytes(output.ToString());
            }
        }

        public static byte[] TransformBeforeProcessing(byte[] payload)
        {
            return TransformBytesWithXlst(XsltBeforeProcessing, payload);
        }

        public static byte[] TransformAfterProcessing(byte[] payload)
        {
            return TransformBytesWithXlst(XsltAfterProcessing, payload);
        }
    }
}
