package pe.efact.global.transform_arg.util;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringReader;
import java.io.StringWriter;

import javax.activation.DataHandler;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.TransformerFactoryConfigurationError;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.xml.sax.SAXException;

import net.sf.saxon.s9api.DocumentBuilder;
import net.sf.saxon.s9api.SaxonApiException;
import net.sf.saxon.s9api.Serializer;
import net.sf.saxon.s9api.XdmNode;
import net.sf.saxon.s9api.XsltTransformer;
import pe.efact.global.transform_arg.config.ConfigLoad;

public final class FilesUtil {

	private static final int INITIAL_SIZE = 1024 * 1024;
	private static final int BUFFER_SIZE = 1024;

	private FilesUtil() {

	}

	public static byte[] getBytes(DataHandler file) throws IOException {
		ByteArrayOutputStream bos = new ByteArrayOutputStream(INITIAL_SIZE);
		InputStream in = file.getInputStream();
		byte[] buffer = new byte[BUFFER_SIZE];
		int bytesRead;
		while ((bytesRead = in.read(buffer)) >= 0) {
			bos.write(buffer, 0, bytesRead);
		}

		return bos.toByteArray();
	}

	public static String[] getParameters(String xml) throws SAXException, IOException, ParserConfigurationException {
		Document doc = DocumentBuilderFactory.newInstance().newDocumentBuilder()
				.parse(new ByteArrayInputStream(xml.getBytes()));
		doc.getDocumentElement().normalize();

		String identifier = null;
		String emisor = null;
		String typeCode = null;

		for (int i = 0; i < doc.getDocumentElement().getChildNodes().getLength(); i++) {
			String nodeName = doc.getDocumentElement().getChildNodes().item(i).getNodeName();
			if (nodeName.equals("cbc:ID")) {
				identifier = doc.getDocumentElement().getChildNodes().item(i).getTextContent();
			}
			if (nodeName.equals("cbc:InvoiceTypeCode")) {
				typeCode = doc.getDocumentElement().getChildNodes().item(i).getTextContent();
			}
			if (nodeName.equals("cac:AccountingSupplierParty")) {
				for (int j = 0; j < doc.getDocumentElement().getChildNodes().item(i).getChildNodes().getLength(); j++) {
					String nodeName2 = doc.getDocumentElement().getChildNodes().item(i).getChildNodes().item(j)
							.getNodeName();
					if (nodeName2.equals("cbc:CustomerAssignedAccountID")) {
						emisor = doc.getDocumentElement().getChildNodes().item(i).getChildNodes().item(j)
								.getTextContent();
					}
				}
			}
		}
		return new String[] { emisor, typeCode, identifier };
	}
	
	public static String transformPerception(String xml) throws SAXException, IOException, ParserConfigurationException, TransformerFactoryConfigurationError, TransformerException {
		Document doc = DocumentBuilderFactory.newInstance().newDocumentBuilder()
				.parse(new ByteArrayInputStream(xml.getBytes()));
		doc.getDocumentElement().normalize();

		for (int i = 0; i < doc.getDocumentElement().getChildNodes().getLength(); i++) {
			String nodeName = doc.getDocumentElement().getChildNodes().item(i).getNodeName();
			if (nodeName.equals("ext:UBLExtensions")) {
				for (int j = 0; j < doc.getDocumentElement().getChildNodes().item(i).getChildNodes().getLength(); j++) {
					String nodeName2 = doc.getDocumentElement().getChildNodes().item(i).getChildNodes().item(j)
							.getNodeName();
					if (nodeName2.equals("ext:UBLExtension")) {
						for (int k = 0; k < doc.getDocumentElement().getChildNodes().item(i).getChildNodes().item(j).getChildNodes().getLength(); k++) {
							String nodeName3 = doc.getDocumentElement().getChildNodes().item(i).getChildNodes().item(j).getChildNodes().item(k)
									.getNodeName();
							if (nodeName3.equals("ext:ExtensionContent")) {
								for (int l = 0; l < doc.getDocumentElement().getChildNodes().item(i).getChildNodes().item(j).getChildNodes().item(k).getChildNodes().getLength(); l++) {
									String nodeName4 = doc.getDocumentElement().getChildNodes().item(i).getChildNodes().item(j).getChildNodes().item(k).getChildNodes().item(l)
											.getNodeName();
									if (nodeName4.equals("ns2:AdditionalInformation") || nodeName4.equals("sac:AdditionalInformation")) {
										for (int m = 0; m < doc.getDocumentElement().getChildNodes().item(i).getChildNodes().item(j).getChildNodes().item(k).getChildNodes().item(l).getChildNodes().getLength(); m++) {
										String nodeName5 = doc.getDocumentElement().getChildNodes().item(i).getChildNodes().item(j).getChildNodes().item(k).getChildNodes().item(l).getChildNodes().item(m)
												.getNodeName();
										if (nodeName5.equals("ns2:AdditionalMonetaryTotal") || nodeName5.equals("sac:AdditionalMonetaryTotal")) {
											for (int n = 0; n < doc.getDocumentElement().getChildNodes().item(i).getChildNodes().item(j).getChildNodes().item(k).getChildNodes().item(l).getChildNodes().item(m).getChildNodes().getLength(); n++) {
												String nodeName6 = doc.getDocumentElement().getChildNodes().item(i).getChildNodes().item(j).getChildNodes().item(k).getChildNodes().item(l).getChildNodes().item(m).getChildNodes().item(n)
														.getNodeName();
												if (nodeName6.equals("ID") || nodeName6.equals("cbc:ID")) {
													if (doc.getDocumentElement().getChildNodes().item(i).getChildNodes().item(j).getChildNodes().item(k).getChildNodes().item(l).getChildNodes().item(m).getChildNodes().item(n).getTextContent().equals("2001")) {
														Node node = doc.getDocumentElement().getChildNodes().item(i).getChildNodes().item(j).getChildNodes().item(k).getChildNodes().item(l).getChildNodes().item(m).getChildNodes().item(n);
														((Element) node).setAttribute("schemeID", "01");
														break;
													}
			
												}
													
											}
										}
											
										}
									}
								}
							}
						}
					}
				}
			}
		}		
		Transformer transformer = TransformerFactory.newInstance().newTransformer();
        transformer.setOutputProperty(OutputKeys.INDENT, "yes");
        transformer.setOutputProperty(OutputKeys.METHOD, "xml");
        transformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "5");
        DOMSource source = new DOMSource(doc);
        StringWriter writer = new StringWriter();
        StreamResult result = new StreamResult(writer);
        transformer.transform(source, result);
				
		return writer.toString();
	}
	
	public static String transformUBL(String xml, XsltTransformer transformer) throws SaxonApiException {
		StringReader reader = new StringReader(xml);
		DocumentBuilder builder = ConfigLoad.getInstance().getProcessor().newDocumentBuilder();
		builder.setLineNumbering(true);
		builder.setDTDValidation(false);
		XdmNode source = builder.build(new StreamSource(reader));
		StringWriter writer = new StringWriter();
		Serializer out = ConfigLoad.getInstance().getProcessor().newSerializer(writer);
		out.setOutputProperty(Serializer.Property.INDENT, "yes");
		
		transformer.setInitialContextNode(source);
		transformer.setDestination(out);
		transformer.transform();
		
		return writer.toString();
	}
	
}

