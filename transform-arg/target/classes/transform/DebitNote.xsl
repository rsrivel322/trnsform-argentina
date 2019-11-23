<?xml version="1.0" encoding="UTF-8"?>
<!--
       **************************************************************************

    XSLT transformación de Notas de Débito en formato UBL 2.1 a UBL 2.0

    título=             DebitNote.xsl   
    Creador=    Frank Huaylinos
    Creado=             2017-10-03
    Modificado= 2017-10-11 por Frank Huaylinos
    
    Notas: Esta transformación será temporal hasta que esté disponible las validaciones de UBL 2.1
    
  **************************************************************************
-->

<xsl:stylesheet version="3.0" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
	xmlns:xdt="http://www.w3.org/2005/xpath-datatypes"
	xmlns:err="http://www.w3.org/2005/xqt-errors"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="urn:oasis:names:specification:ubl:schema:xsd:DebitNote-2"
    xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
    xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
    xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"
    xmlns:sac="urn:sunat:names:specification:ubl:peru:schema:xsd:SunatAggregateComponents-1"
    exclude-result-prefixes="xs fn xdt err">
    
	<xsl:output method="xml" version="1.0" encoding="utf-8"
		omit-xml-declaration="no" indent="yes" media-type="text/xml" />
	<xsl:strip-space elements="*" />

	<xsl:mode on-no-match="shallow-copy" />
	<xsl:template match="/*">
		<xsl:element name="{local-name()}"
			namespace="urn:oasis:names:specification:ubl:schema:xsd:DebitNote-2">
			<xsl:copy-of select="namespace::*" />
			<xsl:apply-templates select="@*|node()" />
		</xsl:element>
	</xsl:template>
	
<!-- 	<xsl:template match="ext:UBLExtensions"> -->
<!-- 		<xsl:copy-of select="."/> -->
<!-- 		<xsl:element name="cbc:UBLVersionID"> -->
<!-- 			<xsl:value-of select="'2.0'" /> -->
<!-- 		</xsl:element> -->
<!-- 		<xsl:element name="cbc:CustomizationID"> -->
<!-- 			<xsl:value-of select="'1.0'" /> -->
<!-- 		</xsl:element> -->
<!-- 	</xsl:template> -->
	
	<xsl:template match="cbc:CustomizationID">
		<xsl:element name="cbc:CustomizationID">
			<xsl:value-of select="'1.0'"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="cbc:InvoiceTypeCode">
	</xsl:template>
	
	<xsl:template match="cbc:IssueDate">
		<xsl:variable name="date" select="."/>
		<xsl:element name="cbc:IssueDate">
			<xsl:value-of select="substring($date,1,10)"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="cac:AccountingSupplierParty">
		<xsl:element name="cac:Signature">
			<xsl:element name="cbc:ID">
				<xsl:value-of select="'20262463771'" />
			</xsl:element>
			<xsl:element name="cac:SignatoryParty">
				<xsl:element name="cac:PartyIdentification">
					<xsl:element name="cbc:ID">
						<xsl:value-of select="'20262463771'" />
					</xsl:element>
				</xsl:element>
				<xsl:element name="cac:PartyName">
					<xsl:element name="cbc:Name">
						<xsl:value-of select="'PUMA ENERGY PERU S.A.C.'" />
					</xsl:element>
				</xsl:element>
			</xsl:element>
			<xsl:element name="cac:DigitalSignatureAttachment">
				<xsl:element name="cac:ExternalReference">
					<xsl:element name="cbc:URI">
						<xsl:value-of select="'signatureKG'" />
					</xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:element>
		<xsl:copy-of select="."/>
	</xsl:template>
	
	<xsl:template match="cac:TaxScheme">
		<xsl:element name="cac:TaxScheme">
			<xsl:element name="cbc:ID">
				<xsl:value-of select="cbc:ID" />
			</xsl:element>
			<xsl:choose>
				<xsl:when test="cbc:ID = '1000'">
					<xsl:element name="cbc:Name">
						<xsl:value-of select="'IGV'"/>
					</xsl:element>
					<xsl:element name="cbc:TaxTypeCode">
						<xsl:value-of select="'VAT'"/>
					</xsl:element>
				</xsl:when>
				<xsl:when test="cbc:ID = '2000'">
					<xsl:element name="cbc:Name">
						<xsl:value-of select="'ISC'"/>
					</xsl:element>
					<xsl:element name="cbc:TaxTypeCode">
						<xsl:value-of select="'EXC'"/>
					</xsl:element>
				</xsl:when>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="cac:DebitNoteLine/cac:PricingReference">
<!-- 		<xsl:copy-of select="." /> -->
		<xsl:variable name="descripcion" select="../cac:Item/cbc:Description"/>
		<xsl:element name="cac:BillingReference">
			<xsl:element name="cac:AdditionalDocumentReference">
				<xsl:element name="cbc:ID">
					<xsl:attribute name="schemeID"><xsl:value-of select="'Y'"/></xsl:attribute>
					<xsl:value-of select="$descripcion[2]"/>
				</xsl:element>
			</xsl:element>
		</xsl:element>
		<xsl:element name="cac:BillingReference">
			<xsl:element name="cac:AdditionalDocumentReference">
				<xsl:element name="cbc:ID">
					<xsl:attribute name="schemeID"><xsl:value-of select="'Z'"/></xsl:attribute>
					<xsl:value-of select="$descripcion[3]"/>
				</xsl:element>
			</xsl:element>
		</xsl:element>
		<xsl:copy-of select="." />
	</xsl:template>
	
<!-- 	<xsl:template match="cac:DebitNoteLine/cac:Item/cac:SellersItemIdentification"> -->
<!-- 		<xsl:variable name="id"> -->
<!-- 			<xsl:element name="cac:SellersItemIdentification"> -->
<!-- 				<xsl:value-of select="cbc:ID"/> -->
<!-- 			</xsl:element> -->
<!-- 		</xsl:variable> -->
<!-- 		<xsl:element name="cac:SellersItemIdentification"> -->
<!-- 			<xsl:element name="cbc:ID"> -->
<!-- 				<xsl:value-of select="cbc:ID"/> -->
<!-- 			</xsl:element> -->
<!-- 		</xsl:element> -->
<!-- 		<xsl:element name="cac:CommodityClassification"> -->
<!-- 			<xsl:element name="cbc:ItemClassificationCode "> -->
<!-- 						<xsl:value-of select="document('codes/codigo_clientes.xml')/cliente[@id='20551093035']/codigo[@id=$id]" /> -->
<!-- 			</xsl:element> -->
<!-- 		</xsl:element> -->
<!-- 	</xsl:template> -->
    
    <xsl:template match="cac:DebitNoteLine/cac:Item">
		<xsl:variable name="id">
			<xsl:element name="cac:SellersItemIdentification">
				<xsl:value-of select="cac:SellersItemIdentification/cbc:ID"/>
			</xsl:element>
		</xsl:variable>
		
		<xsl:element name="cac:Item">
			<xsl:element name="cbc:Description">
				<xsl:value-of select="cbc:Description[1]"/>
			</xsl:element>
			
			<xsl:if test="cac:SellersItemIdentification/cbc:ID">
				<xsl:element name="cac:SellersItemIdentification">
					<xsl:element name="cbc:ID">
						<xsl:value-of select="cac:SellersItemIdentification/cbc:ID"/>
					</xsl:element>
				</xsl:element>
				<xsl:element name="cac:CommodityClassification">
					<xsl:element name="cbc:ItemClassificationCode ">
								<xsl:value-of select="document('codes/codigo_clientes.xml')/cliente[@id='20551093035']/codigo[@id=$id]" />
					</xsl:element>
				</xsl:element>
			</xsl:if>
		</xsl:element>
		
	</xsl:template>
    
</xsl:stylesheet>
