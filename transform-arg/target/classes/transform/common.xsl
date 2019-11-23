<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
	xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
	xmlns:sac="urn:sunat:names:specification:ubl:peru:schema:xsd:SunatAggregateComponents-1"
	xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2">
	
	<xsl:mode on-no-match="shallow-copy" />
	
	<xsl:variable name="currency" select="*[local-name()]/cbc:DocumentCurrencyCode"/>
	<xsl:variable name="tipoOperacion" select="*[local-name()]/cbc:InvoiceTypeCode"/>
<!-- 	<xsl:variable name="tipoOperacion" select="*[local-name()]/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/sac:AdditionalInformation/sac:SUNATTransaction/cbc:ID"/> -->
	<xsl:variable name="cam" select="*[local-name()]/cac:AccountingCustomerParty/cbc:AdditionalAccountID"/>
	<xsl:variable name="perception" select="/*[local-name()]/ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/sac:AdditionalInformation/sac:AdditionalMonetaryTotal[cbc:ID[text()='2001']]"/>
	<!-- UBL version -->
	<xsl:template match="cbc:UBLVersionID[not(../ext:UBLExtensions)]">
		<xsl:element name="cbc:UBLVersionID">2.1</xsl:element>
	</xsl:template>
	
	<!-- Customization version -->
	<xsl:template match="cbc:CustomizationID[not(../ext:UBLExtensions)]">
		<xsl:element name="cbc:CustomizationID">
			<xsl:attribute name="schemeAgencyName">
		    	<xsl:value-of select="'PE:SUNAT'"/>
			</xsl:attribute>
			<xsl:value-of select="'2.0'"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="cbc:UBLVersionID[../ext:UBLExtensions]"/>
	<xsl:template match="cbc:CustomizationID[../ext:UBLExtensions]"/>
	<xsl:template match="ext:UBLExtensions">
<!-- 		<xsl:copy-of select="../ext:UBLExtensions"/> -->
		<!-- UBL version -->
		<xsl:element name="cbc:UBLVersionID">2.1</xsl:element>
		<!-- Customization version -->
		<xsl:element name="cbc:CustomizationID">
			<xsl:attribute name="schemeAgencyName">
		    	<xsl:value-of select="'PE:SUNAT'"/>
			</xsl:attribute>
			<xsl:value-of select="'2.0'"/>
		</xsl:element>
	</xsl:template>
	
	
	<!-- The element cbc:DueDate must go after cbc:IssueTime, but it cbc:IssueTime does not exits then must be after cbc:IssueDate-->
	<xsl:template match="cbc:IssueDate[not(../cbc:IssueTime)]">
		<xsl:copy-of select="../cbc:IssueDate"/>
		<xsl:if test="../cac:PaymentMeans/cbc:PaymentDueDate">
			<cbc:DueDate><xsl:value-of select="../cac:PaymentMeans/cbc:PaymentDueDate"/></cbc:DueDate>
		</xsl:if>
	</xsl:template>
	<xsl:template match="cbc:IssueTime">
		<xsl:copy-of select="../cbc:IssueTime"/>
		<xsl:if test="../cac:PaymentMeans/cbc:PaymentDueDate">
			<cbc:DueDate><xsl:value-of select="../cac:PaymentMeans/cbc:PaymentDueDate"/></cbc:DueDate>
		</xsl:if>
	</xsl:template>
	
	<!--Complete prepaid payment if it exist  -->
	<xsl:template match="cac:Signature">
		<xsl:if test="../cac:PrepaidPayment">
		    <xsl:for-each select="../cac:PrepaidPayment">
		        <xsl:element name="cac:AdditionalDocumentReference">
		            <xsl:element name="cbc:ID">
		                <xsl:value-of select="cbc:ID"/>
		            </xsl:element>
		            <xsl:element name="cbc:DocumentTypeCode">
		                <xsl:attribute name="listName">
		                    <xsl:value-of select="'Documento Relacionado'"/>
		                </xsl:attribute>
		                <xsl:attribute name="listAgencyName">
		                    <xsl:value-of select="'PE:SUNAT'"/>
		                </xsl:attribute>
		                <xsl:attribute name="listURI">
		                    <xsl:value-of select="'urn:pe:gob:sunat:cpe:see:gem:catalogos:catalogo07'"/>
		                </xsl:attribute>
		                <xsl:value-of select="cbc:ID/@schemeID"/>
		            </xsl:element>
		            <xsl:element name="cbc:DocumentStatusCode">
		                <xsl:value-of select="count(preceding-sibling::cac:PrepaidPayment) + 1"/>
		            </xsl:element>
		            <xsl:element name="cac:IssuerParty">
		                <xsl:element name="cac:PartyIdentification">
		                    <xsl:element name="cbc:ID">
		                        <xsl:attribute name="schemeID">
		                            <xsl:value-of select="cbc:InstructionID/@schemeID"/>
		                        </xsl:attribute>
		                        <xsl:attribute name="schemeName">
		                            <xsl:value-of select="'Documento de Identidad'"/>
		                        </xsl:attribute>
		                        <xsl:attribute name="schemeAgencyName">
		                            <xsl:value-of select="'PE:SUNAT'"/>
		                        </xsl:attribute>
		                        <xsl:attribute name="schemeURI">
		                            <xsl:value-of select="'urn:pe:gob:sunat:cpe:see:gem:catalogos:catalogo07'"/>
		                        </xsl:attribute>
		                        <xsl:value-of select="cbc:InstructionID"/>
		                    </xsl:element>
		                </xsl:element>
		            </xsl:element>
		        </xsl:element>
		    </xsl:for-each>
		</xsl:if>
		<xsl:next-match/>
	</xsl:template>
	
	<!-- Put Signature if it doesn't exist -->
	<!-- Modify tag cac:AccountingSupplierParty to version UBL 2.1-->
	<xsl:template match="cac:AccountingSupplierParty">
		<xsl:if test="not(../cac:Signature)">
		    <xsl:if test="../cac:PrepaidPayment">
				<xsl:for-each select="../cac:PrepaidPayment">
					<xsl:element name="cac:AdditionalDocumentReference">
						<xsl:element name="cbc:ID">
							<xsl:value-of select="cbc:ID"/>
						</xsl:element>
						<xsl:element name="cbc:DocumentTypeCode">
							<xsl:attribute name="listName">
								<xsl:value-of select="'Documento Relacionado'"/>
							</xsl:attribute>
							<xsl:attribute name="listAgencyName">
								<xsl:value-of select="'PE:SUNAT'"/>
							</xsl:attribute>
							<xsl:attribute name="listURI">
								<xsl:value-of select="'urn:pe:gob:sunat:cpe:see:gem:catalogos:catalogo07'"/>
							</xsl:attribute>
							<xsl:value-of select="cbc:ID/@schemeID"/>
						</xsl:element>
						<xsl:element name="cbc:DocumentStatusCode">
							<xsl:value-of select="count(preceding-sibling::cac:PrepaidPayment) + 1"/>
						</xsl:element>
						<xsl:element name="cac:IssuerParty">
							<xsl:element name="cac:PartyIdentification">
								<xsl:element name="cbc:ID">
									<xsl:attribute name="schemeID">
										<xsl:value-of select="cbc:InstructionID/@schemeID"/>
									</xsl:attribute>
									<xsl:attribute name="schemeName">
										<xsl:value-of select="'Documento de Identidad'"/>
									</xsl:attribute>
									<xsl:attribute name="schemeAgencyName">
										<xsl:value-of select="'PE:SUNAT'"/>
									</xsl:attribute>
									<xsl:attribute name="schemeURI">
										<xsl:value-of select="'urn:pe:gob:sunat:cpe:see:gem:catalogos:catalogo07'"/>
									</xsl:attribute>
									<xsl:value-of select="cbc:InstructionID"/>
								</xsl:element>
							</xsl:element>
						</xsl:element>
					</xsl:element>
				</xsl:for-each>
			</xsl:if>
			<cac:Signature>
				<cbc:ID>IDSign</cbc:ID>
				<cac:SignatoryParty>
					<cac:PartyIdentification>
						<cbc:ID><xsl:value-of select="../cac:AccountingSupplierParty/cbc:CustomerAssignedAccountID"/></cbc:ID>
					</cac:PartyIdentification>
					<cac:PartyName>
						<cbc:Name><xsl:value-of select="../cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName"/></cbc:Name>
					</cac:PartyName>
				</cac:SignatoryParty>
				<cac:DigitalSignatureAttachment>
					<cac:ExternalReference>
						<cbc:URI><xsl:value-of select="../cbc:ID"/></cbc:URI>
					</cac:ExternalReference>
				</cac:DigitalSignatureAttachment>
			</cac:Signature>
		</xsl:if>
		<xsl:copy>
			<xsl:element name="cac:Party">
				<xsl:element name="cac:PartyIdentification">
					<xsl:element name="cbc:ID">
						<xsl:attribute name="schemeID">
					    	<xsl:value-of select="cbc:AdditionalAccountID"/>
						</xsl:attribute>
						<xsl:attribute name="schemeName">
					    	<xsl:value-of select="'Documento de Identidad'"/>
						</xsl:attribute>
						<xsl:attribute name="schemeAgencyName">
					    	<xsl:value-of select="'PE:SUNAT'"/>
						</xsl:attribute>
						<xsl:attribute name="schemeURI">
					    	<xsl:value-of select="'urn:pe:gob:sunat:cpe:see:gem:catalogos:catalogo06'"/>
						</xsl:attribute>
						<xsl:value-of select="cbc:CustomerAssignedAccountID"/>
					</xsl:element>
				</xsl:element>
				<!-- makes a copy of content cac:Party -->
				<xsl:copy-of select="cac:Party/node()"/>
			</xsl:element>
			<xsl:apply-templates select="*[not(self::cac:Party)][not(self::cbc:CustomerAssignedAccountID)][not(self::cbc:AdditionalAccountID)]"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- Modify tag cac:AccountingSupplierParty to version UBL 2.1-->
	<xsl:template match="cac:AccountingCustomerParty">
		<xsl:copy>
			<xsl:element name="cac:Party">
				<xsl:element name="cac:PartyIdentification">
					<xsl:element name="cbc:ID">
						<xsl:attribute name="schemeID">
					    	<xsl:value-of select="cbc:AdditionalAccountID"/>
						</xsl:attribute>
						<xsl:attribute name="schemeName">
					    	<xsl:value-of select="'Documento de Identidad'"/>
						</xsl:attribute>
						<xsl:attribute name="schemeAgencyName">
					    	<xsl:value-of select="'PE:SUNAT'"/>
						</xsl:attribute>
						<xsl:attribute name="schemeURI">
					    	<xsl:value-of select="'urn:pe:gob:sunat:cpe:see:gem:catalogos:catalogo06'"/>
						</xsl:attribute>
						<xsl:value-of select="cbc:CustomerAssignedAccountID"/>
					</xsl:element>
				</xsl:element>
				<!-- makes a copy from content of cac:Party -->
				<xsl:copy-of select="cac:Party/node()"/>
			</xsl:element>
			<xsl:apply-templates select="*[not(self::cac:Party)][not(self::cbc:CustomerAssignedAccountID)][not(self::cbc:AdditionalAccountID)]"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- Modify tag cac:TaxTotal. There must be only one tag -->
	<xsl:template match="cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID[text()!='1000']]" priority="5"/>
	<!-- Total taxes -->
	<xsl:template match="/*[local-name()]/cac:TaxTotal">
		<!-- Perception -->
		<xsl:if test="$perception">
			<xsl:if test="not(../cac:PrepaidPayment)">
				<xsl:element name="cac:PaymentTerms">
					<xsl:element name="cbc:ID">
						<xsl:value-of select="51"/>
					</xsl:element>
					<xsl:element name="cbc:Amount">
						<xsl:attribute name="currencyID">
							<xsl:value-of select="'PEN'"/>
						</xsl:attribute>
						<xsl:value-of select="$perception/sac:TotalAmount"/>
					</xsl:element>
				</xsl:element>
			</xsl:if>
			<xsl:element name="cac:AllowanceCharge">
				<xsl:element name="cbc:ChargeIndicator">
					<xsl:value-of select="'true'"/>
				</xsl:element>
				<xsl:element name="cbc:AllowanceChargeReasonCode">
					<xsl:value-of select="'51'"/>
				</xsl:element>
				<xsl:element name="cbc:MultiplierFactorNumeric">
					<xsl:copy-of select="format-number($perception/cbc:PayableAmount div $perception/cbc:ReferenceAmount, '0.00000')"/>
				</xsl:element>
				<xsl:element name="cbc:Amount">
					<xsl:attribute name="currencyID">
						<xsl:value-of select="'PEN'"/>
					</xsl:attribute>
					<xsl:value-of select="$perception/cbc:PayableAmount"/>
				</xsl:element>
				<xsl:element name="cbc:BaseAmount">
					<xsl:attribute name="currencyID">
						<xsl:value-of select="'PEN'"/>
					</xsl:attribute>
					<xsl:value-of select="$perception/cbc:ReferenceAmount"/>
				</xsl:element>
			</xsl:element>
		</xsl:if>
		
		<xsl:variable name="taxTotal" select="../cac:TaxTotal"/>
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="$taxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID[text()='1000']">
					<xsl:copy-of select="$taxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID[text()='1000']][1]/cbc:TaxAmount"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="$taxTotal[1]/cbc:TaxAmount"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:for-each select="$taxTotal">
				<xsl:if test="cac:TaxSubtotal">
					<cac:TaxSubtotal>
				        <xsl:if test="not(cac:TaxSubtotal/cbc:TaxableAmount)">
				            <xsl:choose>
	    			            <xsl:when test="cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID[text()='1000']">
	    			            	<xsl:choose>
	    			            		<xsl:when test="/*[local-name()]/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionContent/sac:AdditionalInformation/sac:AdditionalMonetaryTotal/cbc:ID[text()='1001']]/ext:ExtensionContent/sac:AdditionalInformation/sac:AdditionalMonetaryTotal/cbc:PayableAmount">
	    			            			<xsl:element name="cbc:TaxableAmount">
			        			                <xsl:attribute name="currencyID">
			            					    	<xsl:value-of select="$currency"/>
			            						</xsl:attribute>
			            						<xsl:value-of select="/*[local-name()]/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionContent/sac:AdditionalInformation/sac:AdditionalMonetaryTotal/cbc:ID[text()='1001']][1]/ext:ExtensionContent/sac:AdditionalInformation/sac:AdditionalMonetaryTotal[cbc:ID[text()='1001']][1]/cbc:PayableAmount"/>
			        			            </xsl:element>
	    			            		</xsl:when>
	    			            		<xsl:otherwise>
	    			            			<xsl:element name="cbc:TaxableAmount">
			        			                <xsl:attribute name="currencyID">
			            					    	<xsl:value-of select="$currency"/>
			            						</xsl:attribute>
			            						<xsl:value-of select="'0.00'"/>
			        			            </xsl:element>
	    			            		</xsl:otherwise>
	    			            	</xsl:choose>
	    			            </xsl:when>
	    			            <xsl:when test="cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID[text()='2000']">
	    			            	<xsl:element name="cbc:TaxableAmount">
									    <xsl:attribute name="currencyID">
									        <xsl:value-of select="$currency"/>
									    </xsl:attribute>
									    <xsl:value-of select="'0.00'"/>
									</xsl:element>
	    			            </xsl:when>
	    			            <xsl:when test="cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID[text()='9995']">
	        			            <xsl:choose>
	    			            		<xsl:when test="/*[local-name()]/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionContent/sac:AdditionalInformation/sac:AdditionalMonetaryTotal/cbc:ID[text()='1000']]/ext:ExtensionContent/sac:AdditionalInformation/sac:AdditionalMonetaryTotal/cbc:PayableAmount">
	    			            			<xsl:element name="cbc:TaxableAmount">
			        			                <xsl:attribute name="currencyID">
			            					    	<xsl:value-of select="$currency"/>
			            						</xsl:attribute>
			            						<xsl:value-of select="/*[local-name()]/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionContent/sac:AdditionalInformation/sac:AdditionalMonetaryTotal/cbc:ID[text()='1000']][1]/ext:ExtensionContent/sac:AdditionalInformation/sac:AdditionalMonetaryTotal[cbc:ID[text()='1000']][1]/cbc:PayableAmount"/>
			        			            </xsl:element>
	    			            		</xsl:when>
	    			            		<xsl:otherwise>
	    			            			<xsl:element name="cbc:TaxableAmount">
			        			                <xsl:attribute name="currencyID">
			            					    	<xsl:value-of select="$currency"/>
			            						</xsl:attribute>
			            						<xsl:value-of select="'0.00'"/>
			        			            </xsl:element>
	    			            		</xsl:otherwise>
	    			            	</xsl:choose>
	    			            </xsl:when>
	    			            <xsl:when test="cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID[text()='9996']">
	        			            <xsl:choose>
	    			            		<xsl:when test="/*[local-name()]/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionContent/sac:AdditionalInformation/sac:AdditionalMonetaryTotal/cbc:ID[text()='1004']]/ext:ExtensionContent/sac:AdditionalInformation/sac:AdditionalMonetaryTotal/cbc:PayableAmount">
	    			            			<xsl:element name="cbc:TaxableAmount">
			        			                <xsl:attribute name="currencyID">
			            					    	<xsl:value-of select="$currency"/>
			            						</xsl:attribute>
			            						<xsl:value-of select="/*[local-name()]/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionContent/sac:AdditionalInformation/sac:AdditionalMonetaryTotal/cbc:ID[text()='1004']][1]/ext:ExtensionContent/sac:AdditionalInformation/sac:AdditionalMonetaryTotal[cbc:ID[text()='1004']][1]/cbc:PayableAmount"/>
			        			            </xsl:element>
	    			            		</xsl:when>
	    			            		<xsl:otherwise>
	    			            			<xsl:element name="cbc:TaxableAmount">
			        			                <xsl:attribute name="currencyID">
			            					    	<xsl:value-of select="$currency"/>
			            						</xsl:attribute>
			            						<xsl:value-of select="'0.00'"/>
			        			            </xsl:element>
	    			            		</xsl:otherwise>
	    			            	</xsl:choose>
	    			            </xsl:when>
	    			            <xsl:when test="cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID[text()='9997']">
	        			            <xsl:choose>
	    			            		<xsl:when test="/*[local-name()]/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionContent/sac:AdditionalInformation/sac:AdditionalMonetaryTotal/cbc:ID[text()='1003']]/ext:ExtensionContent/sac:AdditionalInformation/sac:AdditionalMonetaryTotal/cbc:PayableAmount">
	    			            			<xsl:element name="cbc:TaxableAmount">
			        			                <xsl:attribute name="currencyID">
			            					    	<xsl:value-of select="$currency"/>
			            						</xsl:attribute>
			            						<xsl:value-of select="/*[local-name()]/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionContent/sac:AdditionalInformation/sac:AdditionalMonetaryTotal/cbc:ID[text()='1003']][1]/ext:ExtensionContent/sac:AdditionalInformation/sac:AdditionalMonetaryTotal[cbc:ID[text()='1003']][1]/cbc:PayableAmount"/>
			        			            </xsl:element>
	    			            		</xsl:when>
	    			            		<xsl:otherwise>
	    			            			<xsl:element name="cbc:TaxableAmount">
			        			                <xsl:attribute name="currencyID">
			            					    	<xsl:value-of select="$currency"/>
			            						</xsl:attribute>
			            						<xsl:value-of select="'0.00'"/>
			        			            </xsl:element>
	    			            		</xsl:otherwise>
	    			            	</xsl:choose>
	    			            </xsl:when>
	    			            <xsl:when test="cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID[text()='9998']">
	        			            <xsl:choose>
	    			            		<xsl:when test="/*[local-name()]/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionContent/sac:AdditionalInformation/sac:AdditionalMonetaryTotal/cbc:ID[text()='1002']]/ext:ExtensionContent/sac:AdditionalInformation/sac:AdditionalMonetaryTotal/cbc:PayableAmount">
	    			            			<xsl:element name="cbc:TaxableAmount">
			        			                <xsl:attribute name="currencyID">
			            					    	<xsl:value-of select="$currency"/>
			            						</xsl:attribute>
			            						<xsl:value-of select="/*[local-name()]/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionContent/sac:AdditionalInformation/sac:AdditionalMonetaryTotal/cbc:ID[text()='1002']][1]/ext:ExtensionContent/sac:AdditionalInformation/sac:AdditionalMonetaryTotal[cbc:ID[text()='1002']][1]/cbc:PayableAmount"/>
			        			            </xsl:element>
	    			            		</xsl:when>
	    			            		<xsl:otherwise>
	    			            			<xsl:element name="cbc:TaxableAmount">
			        			                <xsl:attribute name="currencyID">
			            					    	<xsl:value-of select="$currency"/>
			            						</xsl:attribute>
			            						<xsl:value-of select="'0.00'"/>
			        			            </xsl:element>
	    			            		</xsl:otherwise>
	    			            	</xsl:choose>
	    			            </xsl:when>
	    			        </xsl:choose>
				        </xsl:if>
				        <xsl:choose>
				        	<xsl:when test="cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID[text()='1000'] and $tipoOperacion='02'">
				        		<xsl:element name="cbc:TaxAmount">
								    <xsl:attribute name="currencyID">
								        <xsl:value-of select="$currency"/>
								    </xsl:attribute>
								    <xsl:value-of select="'0.00'"/>
								</xsl:element>
				        		<cac:TaxCategory>
								    <cac:TaxScheme>
								        <cbc:ID>9995</cbc:ID>
								        <cbc:Name>EXP</cbc:Name>
								        <cbc:TaxTypeCode>FRE</cbc:TaxTypeCode>
								    </cac:TaxScheme>
								</cac:TaxCategory>
				        	</xsl:when>
				        	<xsl:otherwise>
				        		<xsl:apply-templates select="cac:TaxSubtotal/node()"/>
				        	</xsl:otherwise>
				        </xsl:choose>
				    </cac:TaxSubtotal>
				</xsl:if>
			</xsl:for-each>
		</xsl:copy>
	</xsl:template>
	<!-- Taxes by item -->
	<xsl:template match="/*[local-name()]/*/cac:TaxTotal">
		<xsl:variable name="taxTotal" select="../cac:TaxTotal"/>
		<xsl:variable name="lineAmount" select="../cbc:LineExtensionAmount"/>
		<xsl:variable name="cantInvoice" select="../cbc:InvoicedQuantity"/>
		<xsl:variable name="subTotal" select="$lineAmount * $cantInvoice"/>
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="$taxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID[text()='1000']">
					<xsl:copy-of select="$taxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID[text()='1000']][1]/cbc:TaxAmount"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="$taxTotal[1]/cbc:TaxAmount"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:for-each select="$taxTotal">
				<xsl:if test="cac:TaxSubtotal">
					<cac:TaxSubtotal>
				        <xsl:if test="not(cac:TaxSubtotal/cbc:TaxableAmount)">
				            <xsl:choose>
	    			            <xsl:when test="cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID[text()='1000']">
	    			                <xsl:element name="cbc:TaxableAmount">
	        			                <xsl:attribute name="currencyID">
	            					    	<xsl:value-of select="$currency"/>
	            						</xsl:attribute>
	            						<xsl:value-of select="$subTotal"/>
	        			            </xsl:element>
	    			            </xsl:when>
	    			            <xsl:when test="cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID[text()='9995']">
	    			                <xsl:element name="cbc:TaxableAmount">
	        			                <xsl:attribute name="currencyID">
	            					    	<xsl:value-of select="$currency"/>
	            						</xsl:attribute>
	            						<xsl:value-of select="$subTotal"/>
	        			            </xsl:element>
	    			            </xsl:when>
	    			            <xsl:when test="cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID[text()='9996']">
	    			                <xsl:element name="cbc:TaxableAmount">
	        			                <xsl:attribute name="currencyID">
	            					    	<xsl:value-of select="$currency"/>
	            						</xsl:attribute>
	            						<xsl:value-of select="$subTotal"/>
	        			            </xsl:element>
	    			            </xsl:when>
	    			            <xsl:when test="cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID[text()='9997']">
	    			                <xsl:element name="cbc:TaxableAmount">
	        			                <xsl:attribute name="currencyID">
	            					    	<xsl:value-of select="$currency"/>
	            						</xsl:attribute>
	            						<xsl:value-of select="$subTotal"/>
	        			            </xsl:element>
	    			            </xsl:when>
	    			            <xsl:when test="cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID[text()='9998']">
	    			                <xsl:element name="cbc:TaxableAmount">
	        			                <xsl:attribute name="currencyID">
	            					    	<xsl:value-of select="$currency"/>
	            						</xsl:attribute>
	            						<xsl:value-of select="$subTotal"/>
	        			            </xsl:element>
	    			            </xsl:when>
	    			        </xsl:choose>
				        </xsl:if>
				        <xsl:apply-templates select="cac:TaxSubtotal/node()"/>
				    </cac:TaxSubtotal>
				</xsl:if>
			</xsl:for-each>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="/*[local-name()]/*/cac:TaxTotal">
		<xsl:variable name="taxTotal" select="../cac:TaxTotal"/>
		<xsl:variable name="lineAmount" select="../cbc:LineExtensionAmount"/>
		<xsl:variable name="cantCredit" select="../cbc:CreditedQuantity"/>
		<xsl:variable name="subTotal2" select="$lineAmount * $cantCredit"/>
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="$taxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID[text()='1000']">
					<xsl:copy-of select="$taxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID[text()='1000']][1]/cbc:TaxAmount"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="$taxTotal[1]/cbc:TaxAmount"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:for-each select="$taxTotal">
				<xsl:if test="cac:TaxSubtotal">
					<cac:TaxSubtotal>
				        <xsl:if test="not(cac:TaxSubtotal/cbc:TaxableAmount)">
				            <xsl:choose>
	    			            <xsl:when test="cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID[text()='1000']">
	    			                <xsl:element name="cbc:TaxableAmount">
	        			                <xsl:attribute name="currencyID">
	            					    	<xsl:value-of select="$currency"/>
	            						</xsl:attribute>
	            						<xsl:value-of select="$subTotal2"/>
	        			            </xsl:element>
	    			            </xsl:when>
	    			            <xsl:when test="cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID[text()='9995']">
	    			                <xsl:element name="cbc:TaxableAmount">
	        			                <xsl:attribute name="currencyID">
	            					    	<xsl:value-of select="$currency"/>
	            						</xsl:attribute>
	            						<xsl:value-of select="$subTotal2"/>
	        			            </xsl:element>
	    			            </xsl:when>
	    			            <xsl:when test="cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID[text()='9996']">
	    			                <xsl:element name="cbc:TaxableAmount">
	        			                <xsl:attribute name="currencyID">
	            					    	<xsl:value-of select="$currency"/>
	            						</xsl:attribute>
	            						<xsl:value-of select="$subTotal2"/>
	        			            </xsl:element>
	    			            </xsl:when>
	    			            <xsl:when test="cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID[text()='9997']">
	    			                <xsl:element name="cbc:TaxableAmount">
	        			                <xsl:attribute name="currencyID">
	            					    	<xsl:value-of select="$currency"/>
	            						</xsl:attribute>
	            						<xsl:value-of select="$subTotal2"/>
	        			            </xsl:element>
	    			            </xsl:when>
	    			            <xsl:when test="cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID[text()='9998']">
	    			                <xsl:element name="cbc:TaxableAmount">
	        			                <xsl:attribute name="currencyID">
	            					    	<xsl:value-of select="$currency"/>
	            						</xsl:attribute>
	            						<xsl:value-of select="$subTotal2"/>
	        			            </xsl:element>
	    			            </xsl:when>
	    			        </xsl:choose>
				        </xsl:if>
				        <xsl:apply-templates select="cac:TaxSubtotal/node()"/>
				    </cac:TaxSubtotal>
				</xsl:if>
			</xsl:for-each>
		</xsl:copy>
	</xsl:template>
	
	<!-- Put node cbc:Percent if it doesn't exist -->
	<xsl:template match="/*[local-name()]/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[not(cbc:Percent)]/cbc:TaxExemptionReasonCode">
	    <xsl:choose>
	        <xsl:when test="text()='10'">
	            <cbc:Percent>18.00</cbc:Percent>
	        </xsl:when>
	        <xsl:otherwise>
	            <cbc:Percent>0.00</cbc:Percent>
	        </xsl:otherwise>
	    </xsl:choose>
	    <xsl:next-match/>
	</xsl:template>
	<xsl:template match="/*[local-name()]/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[not(cbc:TaxExemptionReasonCode)][not(cbc:Percent)]/cbc:TierRange">
	    <cbc:Percent>0.00</cbc:Percent>
	    <xsl:next-match/>
	</xsl:template>
	<xsl:template match="/*[local-name()]/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[not(cbc:TaxExemptionReasonCode)][not(cbc:TierRange)][not(cbc:Percent)]/cac:TaxScheme">
	    <cbc:Percent>0.00</cbc:Percent>
	    <xsl:next-match/>
	</xsl:template>
	
	<xsl:template match="cac:TaxScheme[../cbc:TaxExemptionReasonCode[matches(text(), '^(11|12|13|14|15|16|21|31|32|33|34|35|36|37)$')]]">
		<xsl:copy>
			<cbc:ID>9996</cbc:ID>
			<cbc:Name>GRA</cbc:Name>
			<cbc:TaxTypeCode>FRE</cbc:TaxTypeCode>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="cac:TaxScheme[../cbc:TaxExemptionReasonCode[matches(text(), '^(17)$')]]">
		<xsl:copy>
			<cbc:ID>1016</cbc:ID>
			<cbc:Name>IVAP</cbc:Name>
			<cbc:TaxTypeCode>VAT</cbc:TaxTypeCode>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="cac:TaxScheme[../cbc:TaxExemptionReasonCode[matches(text(), '^(20)$')]]">
		<xsl:copy>
			<cbc:ID>9997</cbc:ID>
			<cbc:Name>EXO</cbc:Name>
			<cbc:TaxTypeCode>VAT</cbc:TaxTypeCode>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="cac:TaxScheme[../cbc:TaxExemptionReasonCode[matches(text(), '^(40)$')]]">
		<xsl:copy>
			<cbc:ID>9995</cbc:ID>
			<cbc:Name>EXP</cbc:Name>
			<cbc:TaxTypeCode>FRE</cbc:TaxTypeCode>
		</xsl:copy>
	</xsl:template>
	
	<!-- Legends -->
	<xsl:template match="cbc:DocumentCurrencyCode">
		<xsl:variable name="legends" select="../ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/sac:AdditionalInformation/sac:AdditionalProperty"/>
		<xsl:for-each select="$legends">
			<xsl:if test="matches(cbc:ID, '^(1000|1002|2000|2001|2002|2003|2004|2005|2006|2007|2008|2009|2010)$')">
				<xsl:element name="cbc:Note">
					<xsl:attribute name="languageLocaleID">
						<xsl:value-of select="cbc:ID"/>
					</xsl:attribute>
					<xsl:value-of select="cbc:Value"/>
				</xsl:element>
			</xsl:if>
		</xsl:for-each>
        <xsl:next-match/>
    </xsl:template>
    
    <!--  -->
    <xsl:template match="/*[local-name()]/cac:AllowanceCharge"/>
	
</xsl:stylesheet>