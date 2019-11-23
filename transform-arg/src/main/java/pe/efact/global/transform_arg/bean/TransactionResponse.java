package pe.efact.global.transform_arg.bean;

import java.util.UUID;

public class TransactionResponse {
	private String uuid;
	private String identifier;
	private int responseCode;
	private String outString;
	private String sunatError;
	private String digestValue;
	private byte[] xmlSigned;
	private byte[] pdfFile;
	private byte[] cdrFile;

	public TransactionResponse() {
		// TODO Auto-generated constructor stub
	}

	public TransactionResponse(String uuid, String identifier, int responseCode, String outString) {
		super();
		this.uuid = uuid;
		this.identifier = identifier;
		this.responseCode = responseCode;
		this.outString = outString;
	}

	int typeOfMessageConstant = 0;

	public TransactionResponse(UUID transactionUuid, int typeOfMessageConstant) {
		super();
		this.typeOfMessageConstant = typeOfMessageConstant;
	}

	/**
	 * Constructor for TransactionResponse class
	 * 
	 * @param identifier
	 * @param responseCode
	 * @param outString
	 * @param xmlSigned
	 * @param pdfFile
	 * @param cdrFile
	 */
	public TransactionResponse(String identifier, int responseCode, String outString, byte[] xmlSigned, byte[] pdfFile,
			byte[] cdrFile, String sunatError, String digestValue) {
		this.identifier = identifier;
		this.responseCode = responseCode;
		this.outString = outString;
		this.xmlSigned = xmlSigned;
		this.pdfFile = pdfFile;
		this.cdrFile = cdrFile;
		this.sunatError = sunatError;
		this.digestValue = digestValue;
	} // TransactionResponse

	/**
	 * Constructor for TransactionResponse class
	 * 
	 * @param identifier
	 * @param responseCode
	 * @param outString
	 */
	public TransactionResponse(String identifier, int responseCode, String outString) {
		this.identifier = identifier;
		this.responseCode = responseCode;
		this.outString = outString;
	} // TransactionResponse

	/**
	 * Constructor for TransactionResponse class
	 * 
	 * @param responseCode
	 * @param outString
	 */
	public TransactionResponse(int responseCode, String outString) {
		this.responseCode = responseCode;
		this.outString = outString;
	} // TransactionResponse

	public String getIdentifier() {
		return identifier;
	}

	public void setIdentifier(String identifier) {
		this.identifier = identifier;
	}

	public int getResponseCode() {
		return responseCode;
	}

	public void setResponseCode(int responseCode) {
		this.responseCode = responseCode;
	}

	public String getOutString() {
		return outString;
	}

	public void setOutString(String outString) {
		this.outString = outString;
	}

	public byte[] getXmlSigned() {
		return xmlSigned;
	}

	public void setXmlSigned(byte[] xmlSigned) {
		this.xmlSigned = xmlSigned;
	}

	public byte[] getPdfFile() {
		return pdfFile;
	}

	public void setPdfFile(byte[] pdfFile) {
		this.pdfFile = pdfFile;
	}

	public byte[] getCdrFile() {
		return cdrFile;
	}

	public void setCdrFile(byte[] cdrFile) {
		this.cdrFile = cdrFile;
	}

	public String getSunatError() {
		return sunatError;
	}

	public void setSunatError(String sunatError) {
		this.sunatError = sunatError;
	}

	public String getDigestValue() {
		return digestValue;
	}

	public void setDigestValue(String digestValue) {
		this.digestValue = digestValue;
	}

	public String getUuid() {
		return uuid;
	}

	public void setUuid(String uuid) {
		this.uuid = uuid;
	}

} // TransactionResponse
