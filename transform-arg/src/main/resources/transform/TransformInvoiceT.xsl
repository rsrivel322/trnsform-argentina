<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"
xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
xmlns:sac="urn:sunat:names:specification:ubl:peru:schema:xsd:SunatAggregateComponents-1"
xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2">

<xsl:output method="xml" version="1.0" encoding="utf-8" omit-xml-declaration="no" indent="yes" media-type="text/xml"/>
    <xsl:strip-space elements="*"/>
	
<xsl:template match="/*">
 <xsl:element name="Invoice" namespace="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2">
      <xsl:namespace name="cac" select="'urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2'"/>
      <xsl:namespace name="cbc" select="'urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2'"/>
<!--       <xsl:namespace name="ext" select="'urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2'"/> -->
  <xsl:apply-templates select="/*" mode="InvoiceT"/>
  
    
 </xsl:element>
</xsl:template>

    <xsl:template match="/*" mode="InvoiceT">
    
    	<xsl:element name="cbc:ID">
    	    <xsl:attribute name="schemeID" select="Documento/Cabecera/NumFormulario"/>
    	    <xsl:attribute name="schemeVersionID" select="Documento/Cabecera/VersionSistema"/>
    	    <xsl:value-of select="Documento/DatosComprobante/NumeroComprobante"/>
    	</xsl:element>
    	
    	<xsl:element name="cbc:IssueDate">
	    	<xsl:value-of select="Documento/DatosComprobante/FechaEmision"/>
	    </xsl:element>
	    
    	<xsl:element name="cbc:InvoiceTypeCode">
    	    <xsl:value-of select="Documento/DatosComprobante/TipoComprobante"/>
    	</xsl:element>
	     
	    <xsl:element name="cbc:PaymentCurrencyCode">
	        <xsl:value-of select="Documento/DatosComprobante/CodMoneda"/>
	    </xsl:element>
	     
	     <xsl:element name="cac:BillingReference">
	     <xsl:element name="cac:AdditionalDocumentReference">
	     <xsl:element name="cbc:ID">
	     <xsl:value-of select="Documento/DatosReintegro/NumComprobante"/>
	     </xsl:element>
	     <xsl:element name="cbc:IssueDate">
	     <xsl:value-of select="Documento/DatosReintegro/FechaComprobante"/>
	     </xsl:element>
	     <xsl:element name="cbc:DocumentTypeCode">
	     <xsl:value-of select="Documento/DatosReintegro/TipoComprobante"/>
	     </xsl:element>
	     <xsl:element name="cbc:DocumentStatusCode">
	     <xsl:attribute name="ListID" select="Documento/DatosReintegro/TipoCodAutorizacion"/>
	     <xsl:value-of select="Documento/DatosReintegro/CodAutorizacion"/>
	     </xsl:element>
	     <xsl:element name="cac:IssuerParty">
	     <xsl:element name="cac:PartyIdentification">
	     <xsl:element name="cbc:ID">
	     <xsl:value-of select="Documento/DatosReintegro/CUITEmisoraReintegro"/>
	     </xsl:element>
	     </xsl:element>
	     <xsl:element name="cac:PhysicalLocation">
	     <xsl:element name="cbc:ID">
	     <xsl:value-of select="Documento/DatosReintegro/PuntoVenta"/>
	     </xsl:element>
	     </xsl:element>
	     </xsl:element>
	     </xsl:element>
	     
	     </xsl:element>
	     
	     <xsl:element name="cac:AccountingSupplierParty">
	        <xsl:element name="cac:Party">
	           <xsl:element name="cac:PartyIdentification">
	              <xsl:element name="cbc:ID">
	                <xsl:value-of select="Documento/Cabecera/CUITInformante"/>
	              </xsl:element>
	           </xsl:element>
	            <xsl:element name="cac:PartyName">
	                <xsl:element name="cbc:Name"></xsl:element>
	            </xsl:element>
	            <xsl:element name="cac:Language ">s</xsl:element>
	            <xsl:element name="cac:PostalAddress">s</xsl:element>
	            <xsl:element name="cac:PhysicalLocation">
	                <xsl:element name="cbc:ID">
	                   <xsl:value-of select="Documento/DatosComprobante/PuntoVenta"/>
	                </xsl:element>
	            </xsl:element>
	        </xsl:element>
	     </xsl:element>
	        
	            
	    <xsl:element name="cac:AccountingCustomerParty">
	       <xsl:element name="cac:Party">
	         <xsl:element name="cac:PartyIdentification">
	           <xsl:element name="cbc:ID">
	             <xsl:attribute name="schemeID" select="Documento/DatosComprobante/CodDocReceptor"/>
	             <xsl:value-of select="Documento/DatosComprobante/NumDocReceptor"/>
	           </xsl:element>
	         </xsl:element>
	         <xsl:element name="cac:PartyName">
	           <xsl:element name="cbc:Name"></xsl:element>
	         </xsl:element>
	         <xsl:element name="cac:PostalAddress">
	           <xsl:element name="cac:Country">
	           <xsl:element name="cbc:IdentificationCode">
	             <xsl:value-of select="Documento/DatosTurista/PaisEmisorDoc"/>
	           </xsl:element>
	           </xsl:element>
	         </xsl:element>
	         <xsl:element name="cac:PartyTaxScheme">
	           <xsl:element name="cbc:TaxLevelCode">
	             <xsl:value-of select="Documento/DatosComprobante/IDImpositivoReceptor"/>
	           </xsl:element>
	         </xsl:element>
	         <xsl:element name="cac:Person">
	           <xsl:element name="cbc:FirstName">
	             <xsl:value-of select="Documento/DatosTurista/ApellidoYNombre" />
	           </xsl:element>
	         <xsl:element name="cbc:FamilyName">
	           <xsl:value-of select="Documento/DatosTurista/ApellidoYNombre" />
	         </xsl:element>
	         <xsl:element name="cac:IdentityDocumentReference">
	           <xsl:element name="cbc:ID">
	             <xsl:attribute name="schemeID" select="Documento/DatosTurista/TipoDocUsuario"/>
	             <xsl:value-of select="Documento/DatosTurista/NumDocUsuario"/>
	           </xsl:element>
	         </xsl:element>
	         <xsl:element name="cbc:NationalityID">
	           <xsl:value-of select="Documento/DatosTurista/PaisNacionalidad"/>
	         </xsl:element>
	         <xsl:element name="cac:ResidenceAddress">
	           <xsl:element name="cac:Country">
	             <xsl:element name="cbc:IdentificationCode">
	               <xsl:value-of select="Documento/DatosTurista/PaisResidencia"/>
	             </xsl:element>
	           </xsl:element>
	         </xsl:element>
	         </xsl:element>
	        </xsl:element>
	    </xsl:element>
	    
	    <xsl:element name="cac:PaymentMeans">
	      <xsl:element name="cbc:PaymentMeansCode">
	        <xsl:value-of select="Documento/FormaPago/TipoFormaPago"/>
	      </xsl:element>
	      <xsl:element name="cac:CardAccount">
	        <xsl:element name="cbc:PrimaryAccountNumberID">
	          <xsl:value-of select="Documento/FormaPago/NumTarjetaCreditoExtranjero"/>
	        </xsl:element>
	        <xsl:element name="cbc:CardTypeCode">
	          <xsl:value-of select="Documento/FormaPago/TipoCuenta"/>
	        </xsl:element>
	        <xsl:element name="cbc:IssuerID">
	          <xsl:value-of select="Documento/FormaPago/SwiftCodeEntidadBancaria"/>
	        </xsl:element>
	      </xsl:element>
	      <xsl:element name="cac:PayerFinancialAccount">
	          <xsl:element name="cbc:ID">
	            <xsl:value-of select="Documento/FormaPago/NumCuentaExtranjero"/>
	          </xsl:element>
	      </xsl:element>
	    </xsl:element>
	    
	    <xsl:element name="cac:TaxExchangeRate">
	      <xsl:element name="cbc:TargetCurrencyBaseRate">
	        <xsl:value-of select="Documento/DatosComprobante/CotizacionMoneda"/>
	      </xsl:element>
	    </xsl:element>
	    
	    <xsl:element name="cac:TaxTotal">
	        <xsl:element name="cac:TaxSubtotal">
	           <xsl:element name="cac:TaxCategory">
	              <xsl:element name="cbc:ID">
	                 <xsl:value-of select="Documento/Cabecera/CodImpuesto"></xsl:value-of>
	              </xsl:element>
	              <xsl:element name="cbc:ExemptionReasonCode">
	                <xsl:value-of select="Documento/Cabecera/CodConcepto"></xsl:value-of>
	              </xsl:element>
	           </xsl:element>
	        </xsl:element>
	    </xsl:element>
	    
	    <xsl:element name="cac:TaxTotal">
	      <xsl:element name="cbc:TaxAmount">
	        <xsl:value-of select="Documento/DatosComprobante/ImporteGravado"/>
	      </xsl:element>
	    </xsl:element>
	    
	    <xsl:element name="cac:TaxTotal">
	      <xsl:element name="cbc:TaxtAmount">
	        <xsl:value-of select="Documento/DatosComprobante/ImporteNoGravado"/>
	      </xsl:element>
	    </xsl:element>
	    
	    <xsl:element name="cac:TaxTotal">
	      <xsl:element name="cbc:TaxAmount">
	        <xsl:value-of select="Documento/DatosComprobante/ImporteExento"/>
	      </xsl:element>
	    </xsl:element>
	    
	    <xsl:element name="cac:TaxTotal">
	      <xsl:element name="cbc:TaxtAmount">
	        <xsl:value-of select="Documento/DatosComprobante/ImporteReintegro"/>
	      </xsl:element>
	    </xsl:element>
	    
	    <xsl:element name="cac:TaxTotal">
	      <xsl:element name="cbc:TaxSubtotal">
	        <xsl:element name="cbc:TaxableAmount">
	          <xsl:value-of select="Documento/SubTotalIVA/BaseImponible"/>
	        </xsl:element>
	    <xsl:element name="cbc:TaxAmount">
	      <xsl:value-of select="Documento/SubTotalIVA/Importe"/>
	    </xsl:element>
	    <xsl:element name="cbc:Percent">
	      <xsl:value-of select="Documento/SubTotalIVA/PorcentajeIVA"/>
	    </xsl:element>
	      </xsl:element>
	    </xsl:element>
	             
	    <xsl:element name="cac:LegalMonetaryTotal">
	        <xsl:element name="cbc:PayableAmount">
	          <xsl:value-of select="Documento/DatosComprobante/ImporteTotal"/>
	        </xsl:element>
	    </xsl:element>
	    
	    <xsl:element name="cac:InvoiceLine">
	      <xsl:element name="cbc:ID">
	        <xsl:attribute name="schemeID" select="Documento/DatosItem/TipoRegistroItem"/>
	        <xsl:value-of select="Documento/DatosItem/TipoItem"/>
	      </xsl:element>
	      <xsl:element name="cbc:InvoicedQuantity">
	        <xsl:attribute name="unitCode" select="Documento/DatosItem/TipoUnidad"/>
	        <xsl:value-of select="Documento/DatosItem/Unidad"/>
	      </xsl:element>
	      <xsl:element name="cbc:LineExtensionAmount">
	        <xsl:value-of select="Documento/DatosItem/ImporteTotalItem"/>
	      </xsl:element>
	      <xsl:element name="cbc:TaxPointDate">
	        <xsl:value-of select="Documento/DatosItem/FechaIngreso"/>
	      </xsl:element>
	      <xsl:element name="cac:TaxTotal">
	        <xsl:element name="cbc:TaxAmount">
	          <xsl:value-of select="Documento/DatosItem/ImporteIVA"/>
	        </xsl:element>
	        <xsl:element name="cac:TaxSubtotal">
	          <xsl:element name="cac:TaxCategory">
	            <xsl:element name="cbc:ID">
	              <xsl:value-of select="Documento/DatosItem/CodCondicionIVA"/>
	            </xsl:element>
	          </xsl:element>
	        </xsl:element>
	      </xsl:element>
	        <xsl:element name="cac:Item">
	          <xsl:element name="cbc:PackQuantity">
	          <xsl:value-of select="Documento/DatosItem/CantidadNoches"/>
	          </xsl:element>
	          <xsl:element name="cbc:PackSizeNumeric">
	          <xsl:value-of select="Documento/DatosItem/CantPersonas"/>
	          </xsl:element>
	          <xsl:element name="cac:AdditionalItemIdentification">
	         <xsl:element name="cbc:ID">
	         <xsl:value-of select="Documento/DatosItem/CodProductoServicio"/>
	         </xsl:element>
	         <xsl:element name="cbc:Description">
	         <xsl:value-of select="Documento/DatosItem/DescripcionProductoServicio"/>
	         </xsl:element>
	          </xsl:element>
	        </xsl:element>
	        <xsl:element name="cac:Price">
	        <xsl:element name="cbc:PriceAmount">
	        <xsl:value-of select="Documento/DatosItem/PrecioUnitario"/>
	        </xsl:element>
	        </xsl:element>
	    </xsl:element>
	   
    	
    </xsl:template>
   
</xsl:stylesheet>
