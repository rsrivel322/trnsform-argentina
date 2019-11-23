package pe.efact.global.transform_arg.constants;

public final class UriConstants {

	private UriConstants() {
	}

	public static final String BASE_URL = "https://ose-gw1.efact.pe/api-efact-ose/";
	public static final String TOKEN = BASE_URL + "oauth/token";
	public static final String POST_DOCUMENT = BASE_URL + "v1/document";
	
	public static final String CDR = BASE_URL + "v1/cdr/";
	public static final String XML = BASE_URL + "v1/xml/";
	public static final String PDF = BASE_URL + "v1/pdf/";
}
