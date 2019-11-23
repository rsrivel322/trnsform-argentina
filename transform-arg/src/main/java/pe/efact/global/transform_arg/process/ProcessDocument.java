package pe.efact.global.transform_arg.process;

import java.io.IOException;
import java.io.StringReader;
import java.io.StringWriter;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

import javax.activation.DataHandler;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.stream.StreamSource;

import org.apache.log4j.Logger;
import org.xml.sax.SAXException;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import net.sf.saxon.s9api.DocumentBuilder;
import net.sf.saxon.s9api.SaxonApiException;
import net.sf.saxon.s9api.Serializer;
import net.sf.saxon.s9api.XdmNode;
import net.sf.saxon.s9api.XsltTransformer;
import pe.efact.global.transform_arg.bean.Authorization;
import pe.efact.global.transform_arg.bean.RestParametersBean;
import pe.efact.global.transform_arg.bean.TransactionResponse;
import pe.efact.global.transform_arg.config.ConfigLoad;
import pe.efact.global.transform_arg.constants.DocumentType;
import pe.efact.global.transform_arg.constants.NameConstants;
import pe.efact.global.transform_arg.rest.RestClient;
import pe.efact.global.transform_arg.util.FilesUtil;
import pe.efact.global.transform_arg.worker.DocumentWorker;

public class ProcessDocument {

	static Logger LOG = Logger.getLogger(ProcessDocument.class);
	
	private static ProcessDocument instance;
	private ExecutorService executor;
	private static final DocumentType[] type = { DocumentType.CDR, DocumentType.XML, DocumentType.PDF};
	
	public static ProcessDocument getInstance() {
		if (instance == null)
			instance = new ProcessDocument();
		return instance;
	}
	
	private ProcessDocument() {
		executor = Executors.newFixedThreadPool(3);
	}
	
	
	public TransactionResponse process(Authorization aut, DataHandler file, String docType) throws Exception {
		TransactionResponse txResponse = new TransactionResponse();
		byte[] content = FilesUtil.getBytes(file);
		String xml = new String(content);
		try {
			String[] values = FilesUtil.getParameters(xml);
			
			if (!docType.equals(values[1]) || values[1] == null) {
				values[1] = docType;
			}
			
 			String fileName = values[0]+"-"+values[1]+"-"+values[2]+".xml";
 			LOG.info("fileName " + fileName);
 			
 			
 			if (docType.equals(values[1])) {
 				LOG.info("FileName: "+ fileName);
 	 			LOG.info("XML Enviado: \n" + xml);
 	 			
 	 			
 	 			String transformXml = null;
 	 			
 	 			if (docType.equals(NameConstants.INVOICE)) {
 	 				LOG.info("Transform INVOICE");
 	 				String transform1 = transformUBL(xml, ConfigLoad.getInstance().getXsltTransformInvoiceT());
 	 				String transformXml20 = FilesUtil.transformPerception(transform1);
 	 				
 	 				/**
 	 				 * Transform to UBL 2.1
 	 				 */
 	 				transformXml = transformUBL(transformXml20, ConfigLoad.getInstance().getXsltTransformInvoice21());
 	 				
 	 			} else if (docType.equals(NameConstants.CREDIT_NOTE)) {
 	 				LOG.info("Transform CREDIT_NOTE");
 	 				String transform1 = transformUBL(xml, ConfigLoad.getInstance().getXsltTransformCreditNote());
 	 				String transformXml20 = FilesUtil.transformPerception(transform1);
 	 				
 	 				/**
 	 				 * Transform to UBL 2.1
 	 				 */
 	 				transformXml = transformUBL(transformXml20, ConfigLoad.getInstance().getXsltTransformCreditNote21());
 	 			} else if (docType.equals(NameConstants.DEBIT_NOTE)) {
 	 				LOG.info("Transform DEBIT_NOTE");
 	 				xml = new String(content, StandardCharsets.UTF_16);
 	 				String transform1 = transformUBL(xml, ConfigLoad.getInstance().getXsltTransformDebitNote());
 	 				String transformXml20 = FilesUtil.transformPerception(transform1);
 	 				
 	 				/**
 	 				 * Transform to UBL 2.1
 	 				 */
 	 				transformXml = transformUBL(transformXml20, ConfigLoad.getInstance().getXsltTransformDebitNote21());
 	 				
 	 			}
 	 		 	 			
 	 			LOG.info("XML Transformado: \n" + transformXml);
 	 			
 	 			LOG.info("================== SENDING TO REST API ===============");
 	 			LOG.info("User: " + aut.getUser());
 	 			LOG.info("Password: " + aut.getPassword());

 	 			LOG.info("Obtain Token");
 				RestParametersBean tokenBean = RestClient.getInstance().getToken(aut);
 				if (tokenBean.getCode() != 200) {
 					LOG.info(tokenBean.getCode());
 					LOG.info(tokenBean.getDescription());
 					txResponse.setResponseCode(tokenBean.getCode());
 					txResponse.setOutString(tokenBean.getDescription());
 					return txResponse;
 				}
 				LOG.info("Token: Bearer " + tokenBean.getToken());
 				
 				LOG.info("Post Document");
 				RestParametersBean documentBean= RestClient.getInstance().postDocument(tokenBean.getToken(), transformXml.getBytes(), fileName);
 				
 				LOG.info("Response Post Document");
 				LOG.info("Code : " + documentBean.getCode());
 				if (documentBean.getCode() != 0) {
 					txResponse.setResponseCode(tokenBean.getCode());
 					LOG.info("Error Descripcion : " + documentBean.getDescription());
 					txResponse.setOutString(tokenBean.getDescription());
 					return txResponse;
 				}
 				LOG.info("Ticket:" + documentBean.getTicket());
 				
 				List<Future<String>> response = new ArrayList<>();
 				for (int i = 0; i < 1; i++) {
 					Future<String> state = executor.submit(new DocumentWorker(tokenBean.getToken(), documentBean.getTicket(), type[i]));
 					response.add(state);
 				}
// 				String xmlSigned = response.get(0).get();
 				String cdr = response.get(0).get();
// 				String pdf = response.get(2).get();

 				txResponse.setUuid(documentBean.getTicket());
 				txResponse.setIdentifier(values[2]);
 				try {
 					ObjectMapper mapper = new ObjectMapper();
 	 				JsonNode root = mapper.readTree(cdr);
 	 				txResponse.setResponseCode(root.get("code").asInt());
 	 				txResponse.setOutString(root.get("description").asText());
 	 				
 				} catch (IOException e) {	
 	 				txResponse.setCdrFile(cdr.getBytes());
 				}
 			
 			} else {
 				txResponse.setOutString("El documento a enviar debe ser " + docType);
 			}
		} catch (SAXException | ParserConfigurationException e) {
			txResponse.setOutString("Ocurrio un error");
		}
		return txResponse;
	}
	
	public String transformUBL(String xml, XsltTransformer transformer) throws SaxonApiException {
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
