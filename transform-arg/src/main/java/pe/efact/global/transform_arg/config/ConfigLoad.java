package pe.efact.global.transform_arg.config;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.net.URISyntaxException;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Properties;

import javax.xml.transform.stream.StreamSource;

import net.sf.saxon.s9api.Processor;
import net.sf.saxon.s9api.SaxonApiException;
import net.sf.saxon.s9api.XsltCompiler;
import net.sf.saxon.s9api.XsltExecutable;
import net.sf.saxon.s9api.XsltTransformer;
import pe.efact.global.transform_arg.constants.NameConstants;

/**
 * 
 * @author adiaz
 *
 */
public class ConfigLoad {

	private static ConfigLoad instance;
	Processor processor = new Processor(false);

	private XsltExecutable executableTransformInvoice;
	private XsltExecutable executableTransformCreditNote;
	private XsltExecutable executableTransformDebitNote;
	
	private XsltExecutable executableTransformInvoice21;
	private XsltExecutable executableTransformCreditNote21;
	private XsltExecutable executableTransformDebitNote21;
	
	private Properties properties;
	

	private ConfigLoad() {
		if (instance != null) {
			throw new IllegalStateException("Already initialized.");
		}
	}

	public static ConfigLoad getInstance() {
		if (instance == null) {
			instance = new ConfigLoad();
		}
		return instance;
	}

	public void init(String url) {
		try {
			loadProperties("/opt/efact/ose/config/parameterConfig.properties");
			
			executableTransformInvoice = 
					getXsltExecutable(new File(url+ "/transform/" + NameConstants.NAME_INVOICE_TRANSFORM));
			
			executableTransformCreditNote = 
					getXsltExecutable(new File(url+ "/transform/" + NameConstants.NAME_CREDIT_NOTE_TRANSFORM));
			
			executableTransformDebitNote = 
					getXsltExecutable(new File(url+ "/transform/" +  NameConstants.NAME_DEBIT_NOTE_TRANSFORM));
			
			executableTransformInvoice21 =
					getXsltExecutable(new File(url+ "/transform/" + NameConstants.NAME_INVOICE_TRANSFORM_21));
			
			executableTransformCreditNote21 =
					getXsltExecutable(new File(url+ "/transform/" + NameConstants.NAME_CREDIT_NOTE_TRANSFORM_21));
			
			executableTransformDebitNote21 =
					getXsltExecutable(new File(url + "/transform/" + NameConstants.NAME_DEBIT_NOTE_TRANSFORM_21));
			
		} catch (Exception e) {
			
		}
	}
	
	private XsltExecutable getXsltExecutable(File transform) throws SaxonApiException {
		XsltCompiler comp = processor.newXsltCompiler();
		return comp.compile(new StreamSource(transform));
	}

	public Processor getProcessor() {
		return processor;
	}

	public XsltTransformer getXsltTransformInvoiceT() {
		return executableTransformInvoice.load();
	}
	
	public XsltTransformer getXsltTransformCreditNote() {
		return executableTransformCreditNote.load();
	}
	
	public XsltTransformer getXsltTransformDebitNote() {
		return executableTransformDebitNote.load();
	}
	
	public XsltTransformer getXsltTransformInvoice21() {
		return executableTransformInvoice21.load();
	}
	
	public XsltTransformer getXsltTransformCreditNote21() {
		return executableTransformCreditNote21.load();
	}
	
	public XsltTransformer getXsltTransformDebitNote21() {
		return executableTransformDebitNote21.load();
	}
	
	
	public void loadProperties(String propFileName) throws IOException {
		try (InputStream inputStream = new FileInputStream(new File(propFileName));){
			Properties prop = new Properties();

			if (inputStream != null) {
				prop.load(inputStream);
			} else {
				
			}
			ParameterConfigBean.getInstance().setBaseUrl(prop.getProperty("url-base"));
			ParameterConfigBean.getInstance().setUrlToken(prop.getProperty("url-token"));
			ParameterConfigBean.getInstance().setUrlPost(prop.getProperty("url-post"));
			ParameterConfigBean.getInstance().setUrlCdr(prop.getProperty("url-cdr"));
			ParameterConfigBean.getInstance().setUrlXml(prop.getProperty("url-xml"));
			ParameterConfigBean.getInstance().setUrlPdf(prop.getProperty("url-pdf"));
			
		} catch (Exception e) {
			
		}
	}
	
	public Properties getProperties() {
		return this.properties;
	}
		
}
