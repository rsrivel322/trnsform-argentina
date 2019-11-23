package pe.efact.global.transform_arg.worker;

import java.io.IOException;
import java.util.concurrent.Callable;
import java.util.concurrent.TimeUnit;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.ParseException;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.util.EntityUtils;
import org.apache.log4j.Logger;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import pe.efact.global.transform_arg.config.ParameterConfigBean;
import pe.efact.global.transform_arg.constants.DocumentType;
import pe.efact.global.transform_arg.rest.RestClient;

/**
 * This class represent the request for GET document, it would be a request for
 * XML, PDF or CDR
 * 
 * @author adiaz
 *
 */
public class DocumentWorker implements Callable<String> {

	static Logger LOG = Logger.getLogger(DocumentWorker.class);
	
	private String token;
	private String ticket;
	private DocumentType documentType;

	public DocumentWorker(String token, String ticket, DocumentType documentType) {
		this.token = token;
		this.ticket = ticket;
		this.documentType = documentType;
	}

	@Override
	public String call() throws Exception {
		return getDocument();
	}

	private String getDocument() throws ParseException, IOException {
		String document = "";
		CloseableHttpClient httpClient = RestClient.getInstance().getHttpClient();
		HttpGet httpget = getURI(documentType);
		httpget.setHeader("Authorization", "Bearer " + token);
		int status = 99;
		HttpResponse response = null;
		int code = 99;
		do {
			LOG.info(" Waiting for  " + documentType);
//			try {
//				TimeUnit.SECONDS.sleep(2);
				response = httpClient.execute(httpget);
				status = response.getStatusLine().getStatusCode();
				LOG.info("STATUS " + documentType + ": " + status);
				if (status != 200) {
					ObjectMapper mapper = new ObjectMapper();
					String jsonResponse = response.getEntity() != null ? EntityUtils.toString(response.getEntity()) : null;
					JsonNode rootNodeResponse = mapper.readTree(jsonResponse);
					code = rootNodeResponse.get("code").asInt();
					LOG.info("Code: " + code);
				}
				
				
//			} catch (InterruptedException e) {
//				LOG.error(""+e);
//			}
		} while (status == 202);
		

		HttpEntity entity = response.getEntity();
		document = EntityUtils.toString(entity, "UTF-8");
		return document;
	}

	private HttpGet getURI(DocumentType documentType) {
		switch (documentType) {
		case XML:
			return new HttpGet(ParameterConfigBean.getInstance().getUrlXml() + ticket);
		case PDF:
			return new HttpGet(ParameterConfigBean.getInstance().getUrlPdf() + ticket);
		default:
			return new HttpGet(ParameterConfigBean.getInstance().getUrlCdr() + ticket);
		}
	}

}
