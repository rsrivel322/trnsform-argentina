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
	
<xsl:template match="/">
 <xsl:element name="Invoice" namespace="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2">
      <xsl:namespace name="cac" select="'urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2'"/>
      <xsl:namespace name="cbc" select="'urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2'"/>
      <xsl:namespace name="ext" select="'urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2'"/>
  <xsl:apply-templates select="/*" mode="invoiceA"/>
  
    
 </xsl:element>
</xsl:template>

<xsl:template match="*" mode="invoiceA">
    
    		
	    	<xsl:element name="cbc:ID">----------</xsl:element>
	    	<xsl:element name="cbc:IssueDate">
	    	<xsl:value-of select="Comprobante/FechaEmision"/>
	    	</xsl:element>
	    	<xsl:element name="cbc:InvoiceTypeCode">
	    		<xsl:value-of select="Comprobante/Tipo"/>
	    	</xsl:element>
	    	<xsl:element name="cbc:DocumentCurrencyCode">
	    	<xsl:value-of select="Comprobante/Moneda"/>
	    	</xsl:element>
	    	
	    	<xsl:element name="cac:DespatchDocumentReference">
	    	<xsl:element name="cbc:LanguageID">
	    	<xsl:value-of select="Comprobante/Idioma"/>
	    	</xsl:element>
	    	</xsl:element>
	    	
	    	<xsl:element name="cac:AdditionalDocumentReference">
	    	<xsl:element name="cbc:ID">
	    	<xsl:value-of select="Comprobante/CmpAsociados/CmpAsociados/NroAsoc"/>
	    	</xsl:element>
	    	<xsl:element name="cbc:DocumentTypeCode">
	    	 <xsl:value-of select="Comprobante/CmpAsociados/CmpAsociados/TipoAsoc"/>
	    	</xsl:element>
	    	<xsl:element name="cac:IssuerParty">
	    	<xsl:element name="cac:PhysicalLocation">
	    	<xsl:element name="cbc:ID">
	    	<xsl:value-of select="Comprobante/CmpAsociados/CmpAsociados/PtoVtaAsoc"/>
	    	</xsl:element>
	    	</xsl:element>
	    	</xsl:element>
	    	</xsl:element>
	    	
	    	<xsl:element name="cac:AccountingSupplierParty">
	    	<xsl:element name="cac:Party">
	    	<xsl:element name="cac:PhysicalLocation">
	    	<xsl:element name="cbc:ID">
	    	<xsl:value-of select="Comprobante/PtoVta"/></xsl:element>
	    	</xsl:element>
	    	<xsl:element name="cac:PartyName">
	    	<xsl:element name="cbc:Name">-------------</xsl:element>
	    	</xsl:element>
	    	<xsl:element name="cac:PartyIdentification">
	    	<xsl:element name="cbc:ID">
	    	<xsl:value-of select="Comprobante/CuitEmisor"/>
	    	</xsl:element>
	    	</xsl:element>
	    	<xsl:element name="cac:ServiceProviderParty">
	    	<xsl:element name="cbc:ServiceTypeCode">
	    	<xsl:value-of select="Comprobante/Concepto"/>
	    	</xsl:element>
	    	</xsl:element>
	    	</xsl:element>
	    	<xsl:element name="cac:ServiceProviderParty">
	    	<xsl:element name="cbc:ServiceTypeCode">
	    	<xsl:value-of select="Comprobante/Concepto"/>
	    	</xsl:element>
	    	</xsl:element>
	    	</xsl:element>
	    	
	    	<xsl:element name="cac:AccountingCustomerParty">
	    	<xsl:element name="cbc:AdditionalAccountID">
	    	<xsl:value-of select="Comprobante/IdImpositivoReceptor"/>
	    	</xsl:element>
	    	<xsl:element name="cac:Party">
	    	<xsl:element name="cac:PartyIdentification">
	    	<xsl:element name="cbc:ID">
	    	<xsl:attribute name="schemeID" select="Comprobante/TipoDocReceptor"/>
	    	<xsl:value-of select="Comprobante/NroDocReceptor"/>
	    	</xsl:element>
	    	</xsl:element>
	    	<xsl:element name="cac:PartyName">
	    	<xsl:element name="cac:Name">
	    	<xsl:value-of select="Comprobante/Receptor" />
	    	</xsl:element>
	    	</xsl:element>
	    	<xsl:element name="cac:PostalAddress">
	    	<xsl:element name="cbc:StreetName">
	    	<xsl:value-of select="Comprobante/DomicilioReceptor"/>
	    	</xsl:element>
	    	</xsl:element>
	    	</xsl:element>
	    	</xsl:element>
	    	
	    	<xsl:element name="cac:Delivery">
	    	<xsl:element name="cac:DeliveryLocation">
	    	<xsl:element name="cac:Address">
	    	<xsl:element name="cac:Country">
	    	<xsl:value-of select="Comprobante/DestinoCmp"/>
	    	</xsl:element>
	    	</xsl:element>
	    	</xsl:element>
	    	<xsl:element name="cac:DeliveryTerms">
	    	<xsl:element name="cbc:ID">
	    	<xsl:value-of select="Comprobante/PermisosDestinos/PermisoDestino/PermisoEmb"/>
	    	</xsl:element>
	    	<xsl:element name="cac:DeliveryLocation">
	    	<xsl:element name="cac:Address">
	    	<xsl:element name="cac:Country">
	    	<xsl:element name="cbc:IdentificationCode">
	    	<xsl:value-of select="Comprobante/PermisosDestinos/PermisoDestino/Destino"/>
	    	</xsl:element>
	    	</xsl:element>
	    	</xsl:element>
	    	</xsl:element>
	    	</xsl:element>
	    	<xsl:element name="cac:Shipment">
	    	<xsl:element name="cbc:Information">
	    	<xsl:value-of select="Comprobante/OtrosDatosComerciales"/>
	    	</xsl:element>
	    	<xsl:element name="cac:Delivery">
	    	<xsl:element name="cac:DeliveryTerms">
	    	<xsl:element name="cbc:ID">
	    	<xsl:value-of select="Comprobante/IncoTerms"/>
	    	</xsl:element>
	    	<xsl:element name="cbc:SpecialTerms">
	    	<xsl:value-of select="Comprobante/DetalleIncoterms"/>
	    	</xsl:element>
	    	</xsl:element>
	    	</xsl:element>
	    	</xsl:element>
	    	</xsl:element>
	    	
	    	<xsl:element name="cac:PaymentMeans">
	    	<xsl:element name="cac:PaymentMeansCode">
	    	<xsl:value-of select="Comprobante/FormasPago/FormaPago/Codigo"/>
	    	</xsl:element>
	    	<xsl:element name="cac:InstruccionNote">
	    	<xsl:value-of select="Comprobante/FormasPago/FormaPago/Descripcion"/>
	    	</xsl:element>
	    	</xsl:element>
	    	
	    	<xsl:element name="cac:LegalMonetaryTotal">
	    	<xsl:element name="cbc:PayableAmount">
	    	<xsl:value-of select="Comprobante/ImporteTotal"/>
	    	</xsl:element>
	    	</xsl:element>
	    	
	    	<xsl:element name="cac:InvoiceLine">
	    	<xsl:element name="cbc:ID">
	    	<xsl:value-of select="Comprobante/Detalles/Detalle/Cod"/>
	    	</xsl:element>
	    	<xsl:element name="cbc:InvoicedQuantity">
	    	<xsl:value-of select="Comprobante/Detalles/Detalle/Cant"/>
	    	</xsl:element>
	    	<xsl:element name="cbc:LineExtensionAmount">
	    	<xsl:value-of select="Comprobante/Detalles/Detalle/Importe"/>
	    	</xsl:element>
	    	<xsl:element name="cac:Item">
	    	<xsl:element name="cbc:Description">
	    	<xsl:value-of select="Comprobante/Detalles/Detalle/Desc"/>
	    	</xsl:element>
	    	<xsl:element name="cac:Dimension">
	    	<xsl:element name="cbc:AttributeID">
	    	<xsl:value-of select="Comprobante/Detalles/Detalle/Unimed"/>
	    	</xsl:element>
	    	</xsl:element>
	    	</xsl:element>
	    	<xsl:element name="cac:Price">
	    	<xsl:element name="cbc:PriceAmount">
	    	<xsl:value-of select="Comprobante/Detalles/Detalle/PrecioUnit"/>
	    	</xsl:element>
	    	</xsl:element>
	    	</xsl:element>
	    	
	    	<xsl:element name="cbc:Note">
	    	<xsl:value-of select="Comprobante/OtrosDatosGenerales"/>
	    	</xsl:element>
	    	
    	
    </xsl:template>
   
</xsl:stylesheet>
