

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.Writer;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactoryConfigurationError;

import org.junit.BeforeClass;
import org.junit.Test;
import org.xml.sax.SAXException;

import net.sf.saxon.s9api.SaxonApiException;
import pe.efact.global.transform_arg.config.ConfigLoad;
import pe.efact.global.transform_arg.process.ProcessDocument;
import pe.efact.global.transform_arg.util.FilesUtil;

public class TransformDocumentTest {

	private static ProcessDocument process;
	
	@BeforeClass
	public static void init() {
		process = ProcessDocument.getInstance();
		ConfigLoad.getInstance().init("src/main/resources");
	}
	
	@Test
	public void testTransformInvoice() throws SaxonApiException, IOException, SAXException, ParserConfigurationException, TransformerFactoryConfigurationError, TransformerException {
		byte[] content = Files.readAllBytes(Paths.get("src/test/resources/SGS/F710-00156898.xml"));
		String xml = new String(content);
		System.out.println("================= AFTER =================");
		String transformXml = process.transformUBL(xml, ConfigLoad.getInstance().getXsltTransformInvoiceT());
		String finalxML = FilesUtil.transformPerception(transformXml);
		System.out.println(finalxML);

		BufferedWriter bufferedWriter = null;
		
//		byte[] content2 = Files.readAllBytes(Paths.get("src/test/resources/SGS/F710-00157953.xml"));
//		String finalXML = new String(content2);
		
		/**
		 * Transform to UBL 2.1
		 */
		String xml21 = process.transformUBL(finalxML, ConfigLoad.getInstance().getXsltTransformInvoiceT());
				
		System.out.println("-------------------------");
		System.out.println(xml21);
		
//		File file = new File("/home/efactadmin/Descargas/Casos_SGS/BOLETA/20100114349-03-F710-00156898-2.xml");
//		Writer writer = new FileWriter(file);
//		bufferedWriter = new BufferedWriter(writer);
//		bufferedWriter.write(xml21);
		
//       if(bufferedWriter != null) bufferedWriter.close();
	}
	
	
//	@Test
	public void testTransformCreditNote() throws SaxonApiException, IOException, SAXException, ParserConfigurationException, TransformerFactoryConfigurationError, TransformerException {
		byte[] content = Files.readAllBytes(Paths.get("src/test/resources/SGS/F712-00006462.xml"));
		String xml = new String(content);
		System.out.println("================= AFTER =================");
		String transformXml = process.transformUBL(xml, ConfigLoad.getInstance().getXsltTransformCreditNote());
		String finalxML = FilesUtil.transformPerception(transformXml);
		System.out.println(finalxML);
		
		BufferedWriter bufferedWriter = null;
		
		/**
		 * Transform to UBL 2.1
		 */
		String xml21 = process.transformUBL(finalxML, ConfigLoad.getInstance().getXsltTransformCreditNote21());
				
		System.out.println("-------------------------");
		System.out.println(xml21);
		
		File file = new File("/home/efactadmin/Descargas/Casos_SGS/CREDITO/20100114349-07-F712-00006462-2.xml");
		Writer writer = new FileWriter(file);
		bufferedWriter = new BufferedWriter(writer);
		bufferedWriter.write(xml21);
		
        if(bufferedWriter != null) bufferedWriter.close();
	}
	
//	@Test
	public void testTransformDebitNote() throws SaxonApiException, IOException, SAXException, ParserConfigurationException, TransformerFactoryConfigurationError, TransformerException {
		byte[] content = Files.readAllBytes(Paths.get("src/test/resources/20262463771-08-FD13-00000002_utf16.xml"));
		String xml = new String(content, StandardCharsets.UTF_16);
		System.out.println("================= AFTER =================");
		String transformXml = process.transformUBL(xml, ConfigLoad.getInstance().getXsltTransformDebitNote());
		String finalxML = FilesUtil.transformPerception(transformXml);
		
		/**
		 * Transform to UBL 2.1
		 */
		String xml21 = process.transformUBL(finalxML, ConfigLoad.getInstance().getXsltTransformDebitNote21());
		
		System.out.println("2.0");
		System.out.println(finalxML);
		
		System.out.println("-------------------------");
		System.out.println(xml21);
	}
}
