package pe.efact.global.transform_arg.rest;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.ResponseHandler;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.mime.HttpMultipartMode;
import org.apache.http.entity.mime.MultipartEntityBuilder;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import org.apache.log4j.Logger;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import pe.efact.global.transform_arg.bean.Authorization;
import pe.efact.global.transform_arg.bean.HTTPStatusResponse;
import pe.efact.global.transform_arg.bean.RestParametersBean;
import pe.efact.global.transform_arg.config.ParameterConfigBean;

public class RestClient {

	static Logger LOG = Logger.getLogger(RestClient.class);
	
	private static RestClient instance;
	
	private CloseableHttpClient httpClient;
	private RestParametersBean restBean;
	
	private RestClient() {}
	
	public static RestClient getInstance() {
		if (instance == null)
			instance = new RestClient();
		return instance;
	}
	
	public void init() {
		httpClient = HttpClients.createDefault();
		restBean = new RestParametersBean();
	}
	
	
	public RestParametersBean getToken(Authorization auth) throws Exception {
		HttpPost httpPost = new HttpPost(ParameterConfigBean.getInstance().getUrlToken());
		String credentials = Base64.getEncoder().encodeToString("client:secret".getBytes("UTF-8"));
		httpPost.setHeader("Authorization", "Basic " + credentials);
		List<NameValuePair> params = new ArrayList<>();
		params.add(new BasicNameValuePair("grant_type", "password"));
		params.add(new BasicNameValuePair("username", auth.getUser()));
		params.add(new BasicNameValuePair("password", auth.getPassword()));
		httpPost.setEntity(new UrlEncodedFormEntity(params));

		HTTPStatusResponse httpResponse = null;
		try {
			LOG.info("Executing request");
			httpResponse = httpClient.execute(httpPost, new StringResponseHandler());
			LOG.info("Response : " + httpResponse.getJsonResponse());
			ObjectMapper mapper = new ObjectMapper();
			JsonNode rootNodeToker = mapper.readTree(httpResponse.getJsonResponse());
			if (httpResponse.getStatus() == 200) {
				String token = rootNodeToker.path("access_token").asText();
				restBean.setCode(httpResponse.getStatus());
				restBean.setToken(token);
			} else {
				restBean.setCode(httpResponse.getStatus());
				restBean.setDescription(rootNodeToker.path("error_description").asText());
			}
			
		} catch (Exception e) {
			LOG.error(e);
			restBean.setCode(99);
			restBean.setDescription("Ocurrio un error");
		}
		return restBean;
	}
	
	public RestParametersBean postDocument(String token, byte[] content, String fileName) throws ClientProtocolException, IOException {
		HttpPost post = new HttpPost(ParameterConfigBean.getInstance().getUrlPost());
		post.setHeader("Authorization", "Bearer " + token);

		MultipartEntityBuilder builder = MultipartEntityBuilder.create();
		builder.setMode(HttpMultipartMode.BROWSER_COMPATIBLE);

		builder.addBinaryBody("file", content, ContentType.create("text/xml"), fileName);
		HttpEntity entity = builder.build();
		post.setEntity(entity);

		HttpResponse response = httpClient.execute(post);

		int status = response.getStatusLine().getStatusCode();

		ObjectMapper mapper = new ObjectMapper();

		HttpEntity entity2 = response.getEntity();
		String code = null;
		
		String jsonResponse = entity2 != null ? EntityUtils.toString(entity2) : null;
		JsonNode rootNodeResponse = mapper.readTree(jsonResponse);
		
		if (status == 200) {
			code = rootNodeResponse.path("code").asText();
			String ticket = rootNodeResponse.path("description").asText();
			restBean.setCode(Integer.parseInt(code));
			restBean.setTicket(ticket);
		} else {
			code = rootNodeResponse.path("code").asText();
			String description = rootNodeResponse.path("description").asText();
			restBean.setCode(Integer.parseInt(code));
			restBean.setDescription(description);
		}
		return restBean;
	}
	
	public CloseableHttpClient getHttpClient() {
		return httpClient;
	}
	
	private static class StringResponseHandler implements ResponseHandler<HTTPStatusResponse> {
		@Override
		public HTTPStatusResponse handleResponse(HttpResponse response) throws IOException {
			HTTPStatusResponse httpResponse = new HTTPStatusResponse();
			int status = response.getStatusLine().getStatusCode();
			HttpEntity entity = response.getEntity();
			httpResponse.setStatus(status);
			httpResponse.setJsonResponse(entity != null ? EntityUtils.toString(entity) : null);
			return httpResponse;
		}
	}
}
