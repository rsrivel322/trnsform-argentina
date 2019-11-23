package pe.efact.global.transform_arg.config;

public class ParameterConfigBean {

	private static ParameterConfigBean instance;
	
	private String baseUrl;
	private String urlToken;
	private String urlPost;
	private String urlCdr;
	private String urlXml;
	private String urlPdf;
	
	
	private ParameterConfigBean() {}
	
	public static ParameterConfigBean getInstance() {
		if (instance == null) {
			instance = new ParameterConfigBean();
		}
		return instance;
	}

	public String getBaseUrl() {
		return baseUrl;
	}

	public void setBaseUrl(String baseUrl) {
		this.baseUrl = baseUrl;
	}

	public String getUrlToken() {
		return urlToken;
	}

	public void setUrlToken(String urlToken) {
		this.urlToken = baseUrl + urlToken;
	}

	public String getUrlPost() {
		return urlPost;
	}

	public void setUrlPost(String urlPost) {
		this.urlPost = baseUrl + urlPost;
	}

	public String getUrlCdr() {
		return urlCdr;
	}

	public void setUrlCdr(String urlCdr) {
		this.urlCdr = baseUrl + urlCdr;
	}

	public String getUrlXml() {
		return urlXml;
	}

	public void setUrlXml(String urlXml) {
		this.urlXml = baseUrl + urlXml;
	}

	public String getUrlPdf() {
		return urlPdf;
	}

	public void setUrlPdf(String urlPdf) {
		this.urlPdf = baseUrl + urlPdf;
	}	
}
