<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
	xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
	xmlns:sac="urn:sunat:names:specification:ubl:peru:schema:xsd:SunatAggregateComponents-1"
	xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2">

	<xsl:output method="xml" version="1.0" encoding="ISO-8859-1" omit-xml-declaration="no" indent="yes" media-type="text/xml"/>
    <xsl:strip-space elements="*"/>
<!--     <xsl:include href="common.xsl"/> -->
    
	<xsl:template match="/*">
<!-- 		<xsl:element name="{local-name()}" namespace="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"> -->
<!--     		<xsl:copy-of select="namespace::*"/> -->
<!--     		<xsl:namespace name="ext" select="'urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2'"/> -->
<!--     		<xsl:namespace name="sac" select="'urn:sunat:names:specification:ubl:peru:schema:xsd:SunatAggregateComponents-1'"/> -->
			<xsl:apply-templates select="@*|node()"/>
<!-- 		</xsl:element> -->
	</xsl:template>
	<!--GLOBAL-->
	<xsl:variable name="TipoDoc" select="node()/cbc:DebitNoteTypeCode"/>
	<xsl:variable name="Electronica" select="'56'"/>
	<xsl:variable name="Exportacion" select="'111'"/>
	<xsl:template match="/">
	<!--SETDTE-->
		<xsl:element name="SetDTE">
			<xsl:attribute name="ID" select="'SetDoc'"/>
			<!--CARATULA-->
<!-- 			<xsl:element name="Caratula"> -->
<!-- 				<xsl:attribute name="version" select="'1.0'"/> -->
<!-- 				<xsl:element name="RutEmisor"> -->
<!-- 					<xsl:value-of select="node()/cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID"/> -->
<!-- 				</xsl:element> -->
<!-- 				<xsl:element name="RutEnvia"> -->
<!-- 					<xsl:value-of select="'FALTANTE'"/> -->
<!-- 				</xsl:element> -->
<!-- 				<xsl:element name="RutReceptor"> -->
<!-- 					<xsl:value-of select="node()/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID"/> -->
<!-- 				</xsl:element> -->
<!-- 				<xsl:element name="FchResol"> -->
<!-- 					<xsl:value-of select="'FALTANTE'"/> -->
<!-- 				</xsl:element> -->
<!-- 				<xsl:element name="NroResol"> -->
<!-- 					<xsl:value-of select="'FALTANTE'"/> -->
<!-- 				</xsl:element> -->
<!-- 				<xsl:element name="TmstFirmaEnv"> -->
<!-- 					<xsl:value-of select="'FALTANTE'"/> -->
<!-- 				</xsl:element> -->
<!-- 				<xsl:element name="SubTotDTE"> -->
<!-- 					<xsl:element name="TpoDTE"> -->
<!-- 						<xsl:value-of select="node()/cbc:InvoiceTypeCode"/> -->
<!-- 					</xsl:element> -->
<!-- 					<xsl:element name="NroDTE"> -->
<!-- 						<xsl:value-of select="'FALTANTE'"/> -->
<!-- 					</xsl:element> -->
<!-- 				</xsl:element> -->
<!-- 			</xsl:element> -->
			<!--DTE-->
			<xsl:element name="DTE">
				<xsl:attribute name="version" select="'1.0'"/>
				<xsl:element name="Documento">
					<xsl:attribute name="ID" select="node()/cbc:ID"/>
					<!--ENCABEZADO-->
					<xsl:element name="Encabezado">
						<!--IDDOC-->
						<xsl:element name="IdDoc">
							<xsl:element name="TipoDTE">
								<xsl:value-of select="node()/cbc:DebitNoteTypeCode"/>
							</xsl:element>
							<xsl:element name="Folio">
								<xsl:value-of select="'FALTANTE'"/>
							</xsl:element>
							<xsl:element name="FchEmis">
								<xsl:value-of select="node()/cbc:IssueDate"/>
							</xsl:element>
								<xsl:if test="$TipoDoc = $Electronica">
							<xsl:element name="IndNoRebaja">
								<xsl:value-of select="'FALTANTE'"/>
							</xsl:element>
								</xsl:if>
<!-- Condicional -->		<xsl:if test="string(node()/cac:SellerSupplierParty/cac:Party/cac:ServiceProviderParty/cbc:ServiceTypeCode)">
								<xsl:element name="IndServicio">
									<xsl:value-of select="node()/cac:SellerSupplierParty/cac:Party/cac:ServiceProviderParty/cbc:ServiceTypeCode"/>
								</xsl:element>
							</xsl:if>
								<xsl:if test="$TipoDoc = $Electronica">
<!-- Condicional				<xsl:element name="MntBruto"> -->
<!-- 								<xsl:value-of select="'FALTANTE'"/> -->
<!-- 							</xsl:element> -->
								</xsl:if>
							<xsl:choose>
								<xsl:when test="$TipoDoc = $Exportacion">
									<xsl:if test="string(node()/cac:PaymentMeans/cbc:PaymentMeansCode)">
										<xsl:element name="FmaPago">
											<xsl:value-of select="node()/cac:PaymentMeans/cbc:PaymentMeansCode"/>
										</xsl:element>
									</xsl:if>
								</xsl:when>
								<xsl:otherwise>
<!--  Condicional 						<xsl:if test=""> -->
<!-- 										<xsl:element name="FmaPago"> -->
<!-- 											<xsl:value-of select="node()/cac:PaymentMeans/cbc:PaymentMeansCode"/> -->
<!-- 										</xsl:element> -->
<!-- 									</xsl:if> -->
								</xsl:otherwise>
							</xsl:choose>
							<xsl:if test="$TipoDoc = $Exportacion">
									<xsl:if test="string()">
<!-- 										<xsl:element name="FmaPagExp"> -->
<!-- 											<xsl:value-of select="node()/"/> -->
<!-- 										</xsl:element> -->
									</xsl:if>
							</xsl:if>
							<xsl:if test="string(node()/cac:PrepaidPayment/cbc:PaidDate)">
								<xsl:element name="FchCancel">
									<xsl:value-of select="node()/cac:PrepaidPayment/cbc:PaidDate"/>
								</xsl:element>
							</xsl:if>
							<xsl:if test="string(node()/cac:PrepaidPayment/cbc:PaidAmount)">
							<xsl:element name="MntCancel">
								<xsl:value-of select="node()/cac:PrepaidPayment/cbc:PaidAmount"/>
							</xsl:element>
							</xsl:if>
<!-- 							<xsl:if test="string()"> -->
<!-- 							<xsl:element name="SaldoInsol"> -->
<!-- 								<xsl:value-of select="'FALTANTE'"/> -->
<!-- 							</xsl:element> -->
<!-- 							</xsl:if> -->
							<xsl:if test="string(node()/cac:PaymentMeans/cbc:PaymentDueDate)">
								<xsl:element name="MntPagos">
									<xsl:element name="FchPago">
										<xsl:value-of select="node()/cac:PaymentMeans/cbc:PaymentDueDate"/>
									</xsl:element>
									<xsl:element name="MntPago">
										<xsl:value-of select="node()/cac:LegalMonetaryTotal/cbc:PayableAmount"/>
									</xsl:element>
									<xsl:if test="string(node()/cac:PaymentMeans/cbc:InstructionNote)">
										<xsl:element name="GlosaPagos">
											<xsl:value-of select="node()/cac:PaymentMeans/cbc:InstructionNote"/>
										</xsl:element>
									</xsl:if>
								</xsl:element>
							</xsl:if>
							<xsl:if test="string(node()/cac:InvoicePeriod/cbc:StartDate)">
								<xsl:element name="PeriodoDesde">
									<xsl:value-of select="node()/cac:InvoicePeriod/cbc:StartDate"/>
								</xsl:element>
							</xsl:if>
							<xsl:if test="string(node()/cac:InvoicePeriod/cbc:EndDate)">
								<xsl:element name="PeriodoHasta">
									<xsl:value-of select="node()/cac:InvoicePeriod/cbc:EndDate"/>
								</xsl:element>
							</xsl:if>
							<xsl:if test="string(node()/cac:PaymentMeans/cbc:PaymentChannelCode)">
								<xsl:element name="MedioPago">
									<xsl:value-of select="node()/cac:PaymentMeans/cbc:PaymentChannelCode"/>
								</xsl:element>
							</xsl:if>
							<xsl:if test="string(node()/cac:PaymentMeans/cac:PayerFinancialAccount/cbc:AccountTypeCode)">
							<xsl:element name="TipoCtaPago">
								<xsl:value-of select="node()/cac:PaymentMeans/cac:PayerFinancialAccount/cbc:AccountTypeCode"/>
							</xsl:element>
							</xsl:if>
							<xsl:if test="string(node()/cac:AcountingSupplierParty/cac:Party/cac:FinancialAccount/cbc:ID)">
								<xsl:element name="NumCtaPago">
									<xsl:value-of select="node()/cac:AcountingSupplierParty/cac:Party/cac:FinancialAccount/cbc:ID"/>
								</xsl:element>
							</xsl:if>
							<xsl:if test="string(node()/cac:AcountingSupplierParty/cac:Party/cac:FinancialAccount/cac:FinancialInstitutionBranch)">
								<xsl:element name="BcoPago">
									<xsl:value-of select="node()/cac:AcountingSupplierParty/cac:Party/cac:FinancialAccount/cac:FinancialInstitutionBranch"/>
								</xsl:element>
							</xsl:if>
							<xsl:if test="string(node()/cac:PaymentTerms/cbc:ID)">
							<xsl:element name="TermPagoCdg">
								<xsl:value-of select="node()/cac:PaymentTerms/cbc:ID"/>
							</xsl:element>
							</xsl:if>
							<xsl:choose>
								<xsl:when test="$TipoDoc = $Electronica">
									<xsl:if test="string(node()/cac:PaymentMeans/cbc:InstructionNote)">
										<xsl:element name="TermPagoGlosa">
											<xsl:value-of select="node()/cac:PaymentMeans/cbc:InstructionNote"/>
										</xsl:element>
									</xsl:if>
								</xsl:when>
								<xsl:otherwise>
<!-- COndicional							<xsl:if test=""> -->
<!-- 										<xsl:element name="TermPagoGlosa"> -->
<!-- 											<xsl:value-of select="node()/cac:PaymentMeans/cbc:InstructionNote"/> -->
<!-- 										</xsl:element> -->
<!-- 									</xsl:if> -->
								</xsl:otherwise>
							</xsl:choose>
							<xsl:if test="string(node()/cac:InvoicePeriod/cbc:EndDate)">
								<xsl:element name="TermPagoDias">
									<xsl:value-of select="node()/cac:InvoicePeriod/cbc:EndDate"/>
								</xsl:element>
							</xsl:if>
							<xsl:if test="string(node()/cac:PaymentMeans/cbc:PaymentDueDate)">
								<xsl:element name="FchVenc">
									<xsl:value-of select="node()/cac:PaymentMeans/cbc:PaymentDueDate"/>
								</xsl:element>
							</xsl:if>
						</xsl:element>
						<!--EMISOR-->
						<xsl:element name="Emisor">
							<xsl:element name="RUTEmisor">
								<xsl:value-of select="node()/cac:AcountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID"/>
							</xsl:element>
							<xsl:element name="RznSoc">
								<xsl:value-of select="node()/cac:AcountingSupplierParty/cac:Party/cac:PartyName/cbc:Name"/>
							</xsl:element>
							<xsl:element name="GiroEmis">
								<xsl:value-of select="node()/cac:AcountingSupplierParty/cac:Party/cac:ServiceProviderParty/cbc:ServiceType"/>
							</xsl:element>
							<xsl:if test="string(node()/cac:AccountingSupplierParty/cac:Party/cac:Contact/cac:SellerContact/cbc:Teléfono)">
								<xsl:element name="Telefono">
									<xsl:value-of select="node()/cac:AccountingSupplierParty/cac:Party/cac:Contact/cac:SellerContact/cbc:Teléfono"/>
								</xsl:element>
							</xsl:if>
							<xsl:if test="string(node()/cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:ElectronicMail)">
								<xsl:element name="CorreoEmisor">
									<xsl:value-of select="node()/cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:ElectronicMail"/>
								</xsl:element>
							</xsl:if>
							<xsl:element name="Acteco">
								<xsl:value-of select="'FALTANTE'"/>
							</xsl:element>
							<xsl:if test="string(node()/cac:AcountingSupplierParty/cac:Party/cac:PartyName/cbc:Name)">
								<xsl:element name="Sucursal">
									<xsl:value-of select="node()/cac:AcountingSupplierParty/cac:Party/cac:PartyName/cbc:Name"/>
								</xsl:element>
							</xsl:if>
<!-- 							<xsl:if test=""> -->
<!--  Condicional					<xsl:element name="CdgSIISucur"> -->
<!-- 									<xsl:value-of select="'FALTANTE'"/> -->
<!-- 								</xsl:element> -->
<!-- 							</xsl:if> -->
<!-- 							<xsl:if test="$TipoDoc = $Exportacion"> -->
<!-- 								<xsl:if test="string()"> -->
<!-- 									<xsl:element name="CodAdicSucur"> -->
<!-- 										<xsl:value-of select="node()/"/> -->
<!-- 									</xsl:element> -->
<!-- 								</xsl:if> -->
<!-- 							</xsl:if> -->
							<xsl:if test="string(node()/cac:AcountingSupplierParty/cac:Party/cac:PostalAddress/StreetName)">
								<xsl:element name="DirOrigen">
									<xsl:value-of select="node()/cac:AcountingSupplierParty/cac:Party/cac:PostalAddress/StreetName"/>
								</xsl:element>
							</xsl:if>
							<xsl:if test="string(node()/cac:AcountingSupplierParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName)">
								<xsl:element name="CmnaOrigen">
									<xsl:value-of select="node()/cac:AcountingSupplierParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName"/>
								</xsl:element>
							</xsl:if>
							<xsl:if test="string(node()/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName)">
								<xsl:element name="CiudadOrigen">
									<xsl:value-of select="node()/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName"/>
								</xsl:element>
							</xsl:if>
							<xsl:if test="string(node()/cac:AcountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID)">
								<xsl:element name="CdgVendedor">
									<xsl:value-of select="node()/cac:AcountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID"/>
								</xsl:element>
							</xsl:if>
<!-- 							<xsl:if test="$TipoDoc = $Exportacion"> -->
<!-- 								<xsl:if test="string()"> -->
<!-- 									<xsl:element name="IdAdicEmisor"> -->
<!-- 										<xsl:value-of select=""/> -->
<!-- 									</xsl:element> -->
<!-- 								</xsl:if> -->
<!-- 							</xsl:if> -->
						</xsl:element>
						<!-- RUT MANDANTE -->
						<xsl:if test="$TipoDoc = $Electronica">
<!-- Condicional					<xsl:if test=""> -->
<!-- 								<xsl:element name="RUTMandante"> -->
<!-- 									<xsl:value-of select="node()/cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID"/> -->
<!-- 								</xsl:element> -->
<!-- 							</xsl:if> -->
						</xsl:if>
						<!--RECEPTOR-->
						<xsl:element name="Receptor">
							<xsl:element name="RUTRecep">
								<xsl:value-of select="node()/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID"/>
							</xsl:element>
							<xsl:if test="string(node()/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID)">
								<xsl:element name="CdgIntRecep">
									<xsl:value-of select="node()/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID"/>
								</xsl:element>
							</xsl:if>
							<xsl:element name="RznSocRecep">
								<xsl:value-of select="node()/cac:AccountingCustomerParty/cac:Party/cac:PartyName/cbc:Name"/>
							</xsl:element>
							<xsl:if test="string(node()/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID)">
								<xsl:element name="NumId">
									<xsl:value-of select="node()/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID"/>
								</xsl:element>
							</xsl:if>
							<xsl:if test="string(node()/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)">
								<xsl:element name="Nacionalidad">
									<xsl:value-of select="node()/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode"/>
								</xsl:element>
							</xsl:if>
							<xsl:if test="$TipoDoc = $Exportacion">
								<xsl:if test="string()">
									<xsl:element name="IdAdicRecep">
										<xsl:value-of select="'FALTANTE'"/>
									</xsl:element>
								</xsl:if>
							</xsl:if>
							<xsl:if test="string()">
								<xsl:element name="GiroRecep">
									<xsl:value-of select="node()/cac:AccountingCustomerParty/cac:Party/cac:ServiceProviderParty/cbc:ServiceType"/>
								</xsl:element>
							</xsl:if>
							<xsl:if test="string(node()/cac:AccountingCustomerParty/cac:Party/cac:Contact)">
								<xsl:element name="Contacto">
									<xsl:value-of select="node()/cac:AccountingCustomerParty/cac:Party/cac:Contact"/>
								</xsl:element>
							</xsl:if>
							<xsl:if test="string(node()/cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:ElectronicMail)">
								<xsl:element name="CorreoRecep">
									<xsl:value-of select="node()/cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:ElectronicMail"/>
								</xsl:element>
							</xsl:if>
							<xsl:if test="string(node()/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName)">
								<xsl:element name="DirRecep">
									<xsl:value-of select="node()/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName"/>
								</xsl:element>
							</xsl:if>
							<xsl:if test="string(node()/cac:AccountingCustomerParty/cac:Party/cac:PhysicalLocation/cbc:Description)">
								<xsl:element name="CmnaRecep">
									<xsl:value-of select="node()/cac:AccountingCustomerParty/cac:Party/cac:PhysicalLocation/cbc:Description"/>
								</xsl:element>
							</xsl:if>
							<xsl:if test="string(node()/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName)">
								<xsl:element name="CiudadRecep">
									<xsl:value-of select="node()/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName"/>
								</xsl:element>
							</xsl:if>
							<xsl:if test="string(node()/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName)">
								<xsl:element name="DirPostal">
									<xsl:value-of select="node()/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName"/>
								</xsl:element>
							</xsl:if>
							<xsl:if test="string(node()/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName)">
								<xsl:element name="CmnaPostal">
									<xsl:value-of select="node()/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName"/>
								</xsl:element>
							</xsl:if>
							<xsl:if test="string(node()/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName)">
								<xsl:element name="CiudadPostal">
									<xsl:value-of select="node()/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName"/>
								</xsl:element>
							</xsl:if>
						</xsl:element>
						<!-- RUT SOLICITA -->
						<xsl:if test="$TipoDoc = $Electronica">
<!-- 	Condicional 			<xsl:if test=""> -->
<!-- 								<xsl:element name="RUTSolicita"> -->
<!-- 									<xsl:value-of select="node()/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID"/> -->
<!-- 								</xsl:element> -->
<!-- 							</xsl:if> -->
						</xsl:if>
						<!--TRANSPORTE-->
<!-- 						<xsl:if test=""> -->
<!-- Condicional			<xsl:element name="Transporte"> -->
								<xsl:if test="string()">
									<xsl:element name="RUTChofer">
										<xsl:value-of select="'FALTANTE'"/>
									</xsl:element>
								</xsl:if>
							<xsl:choose>
								<xsl:when test="$TipoDoc = $Electronica">
<!-- 	Condicional						<xsl:if test=""> -->
<!-- 										<xsl:element name="NombreChofer"> -->
<!-- 											<xsl:value-of select="'FALTANTE'"/> -->
<!-- 										</xsl:element> -->
<!-- 									</xsl:if> -->
								</xsl:when>
								<xsl:otherwise>
									<xsl:if test="string()">
										<xsl:element name="NombreChofer">
											<xsl:value-of select="'FALTANTE'"/>
										</xsl:element>
									</xsl:if>
								</xsl:otherwise>	
							</xsl:choose>
								<xsl:if test="string()">
									<xsl:element name="DirDest">
										<xsl:value-of select="'FALTANTE'"/>
									</xsl:element>
								</xsl:if>
								<xsl:if test="string()">
									<xsl:element name="CmnaDest">
										<xsl:value-of select="'FALTANTE'"/>
									</xsl:element>
								</xsl:if>
								<xsl:if test="string()">
									<xsl:element name="CiudadDest">
										<xsl:value-of select="'FALTANTE'"/>
									</xsl:element>
								</xsl:if>
								<xsl:if test="$TipoDoc = $Exportacion">
									<xsl:if test="string()">
										<xsl:element name="SubArea">
											<xsl:if test="string()">
												<xsl:element name="CodModVenta">
													<xsl:value-of select="'FALTANTE'"/>
												</xsl:element>
											</xsl:if>
											<xsl:if test="string()">
												<xsl:element name="CodClauVenta">
													<xsl:value-of select="'FALTANTE'"/>
												</xsl:element>
											</xsl:if>
											<xsl:if test="string()">
												<xsl:element name="TotClauVenta">
													<xsl:value-of select="'FALTANTE'"/>
												</xsl:element>
											</xsl:if>
											<xsl:if test="string()">
												<xsl:element name="CodViaTransp">
													<xsl:value-of select="'FALTANTE'"/>
												</xsl:element>
											</xsl:if>
											<xsl:if test="string()">
												<xsl:element name="NombreTransp">
													<xsl:value-of select="'FALTANTE'"/>
												</xsl:element>
											</xsl:if>
											<xsl:if test="string()">
												<xsl:element name="RUTCiaTransp">
													<xsl:value-of select="'FALTANTE'"/>
												</xsl:element>
											</xsl:if>
											<xsl:if test="string()">
												<xsl:element name="NomCiaTransp">
													<xsl:value-of select="'FALTANTE'"/>
												</xsl:element>
											</xsl:if>
											<xsl:if test="string()">
												<xsl:element name="IdAdicTransp">
													<xsl:value-of select="'FALTANTE'"/>
												</xsl:element>
											</xsl:if>
											<xsl:if test="string()">
												<xsl:element name="Booking">
													<xsl:value-of select="'FALTANTE'"/>
												</xsl:element>
											</xsl:if>
											<xsl:if test="string()">
												<xsl:element name="Operador">
													<xsl:value-of select="'FALTANTE'"/>
												</xsl:element>
											</xsl:if>
											<xsl:if test="string()">
												<xsl:element name="CodPtoEmbarque">
													<xsl:value-of select="'FALTANTE'"/>
												</xsl:element>
											</xsl:if>
											<xsl:if test="string()">
												<xsl:element name="IdAdicPtoEmb">
													<xsl:value-of select="'FALTANTE'"/>
												</xsl:element>
											</xsl:if>
											<xsl:if test="string()">
												<xsl:element name="CodPtoDesemb">
													<xsl:value-of select="'FALTANTE'"/>
												</xsl:element>
											</xsl:if>
											<xsl:if test="string()">
												<xsl:element name="IdAdicPtoDesemb">
													<xsl:value-of select="'FALTANTE'"/>
												</xsl:element>
											</xsl:if>
											<xsl:if test="string()">
												<xsl:element name="Tara">
													<xsl:value-of select="'FALTANTE'"/>
												</xsl:element>
											</xsl:if>
											<xsl:if test="string()">
												<xsl:element name="CodUnidMedTara">
													<xsl:value-of select="'FALTANTE'"/>
												</xsl:element>
											</xsl:if>
											<xsl:if test="string()">
												<xsl:element name="PesoBruto">
													<xsl:value-of select="'FALTANTE'"/>
												</xsl:element>
											</xsl:if>
											<xsl:if test="string()">
												<xsl:element name="CodUnidPesoBruto">
													<xsl:value-of select="'FALTANTE'"/>
												</xsl:element>
											</xsl:if>
											<xsl:if test="string()">
												<xsl:element name="PesoNeto">
													<xsl:value-of select="'FALTANTE'"/>
												</xsl:element>
											</xsl:if>
											<xsl:if test="string()">
												<xsl:element name="CodUnidPesoNeto">
													<xsl:value-of select="'FALTANTE'"/>
												</xsl:element>
											</xsl:if>
											<xsl:if test="string()">
												<xsl:element name="TotItems">
													<xsl:value-of select="'FALTANTE'"/>
												</xsl:element>
											</xsl:if>
											<xsl:element name="TotBultos">
												<xsl:value-of select="'FALTANTE'"/>
											</xsl:element>
											<xsl:if test="string()">
												<xsl:element name="TipoBultos">
													<xsl:if test="string()">
														<xsl:element name="CodTpoBultos">
															<xsl:value-of select="'FALTANTE'"/>
														</xsl:element>
													</xsl:if>
													<xsl:if test="string()">
														<xsl:element name="CantBultos">
															<xsl:value-of select="'FALTANTE'"/>
														</xsl:element>
													</xsl:if>
													<xsl:if test="string()">
														<xsl:element name="Marcas">
															<xsl:value-of select="'FALTANTE'"/>
														</xsl:element>
													</xsl:if>
													<xsl:if test="string()">
														<xsl:element name="IdContainer">
															<xsl:value-of select="'FALTANTE'"/>
														</xsl:element>
													</xsl:if>
													<xsl:if test="string()">
														<xsl:element name="Sello">
															<xsl:value-of select="'FALTANTE'"/>
														</xsl:element>
													</xsl:if>
													<xsl:if test="string()">
														<xsl:element name="EmisorSello">
															<xsl:value-of select="'FALTANTE'"/>
														</xsl:element>
													</xsl:if>
													<xsl:if test="string()">
														<xsl:element name="MntFlete">
															<xsl:value-of select="'FALTANTE'"/>
														</xsl:element>
													</xsl:if>
													<xsl:if test="string()">
														<xsl:element name="MntSeguro">
															<xsl:value-of select="'FALTANTE'"/>
														</xsl:element>
													</xsl:if>
													<xsl:if test="string()">
														<xsl:element name="CodPaisRecep">
															<xsl:value-of select="'FALTANTE'"/>
														</xsl:element>
													</xsl:if>
													<xsl:if test="string()">
														<xsl:element name="CodPaisDestin">
															<xsl:value-of select="'FALTANTE'"/>
														</xsl:element>
													</xsl:if>
												</xsl:element>
											</xsl:if>
										</xsl:element>
									</xsl:if>
								</xsl:if>
<!-- 						</xsl:element> -->
<!-- 						</xsl:if> -->
						<!--TOTALES-->
						<xsl:element name="Totales">
							<xsl:if test="$TipoDoc = $Exportacion">
								<xsl:element name="TpoMoneda">
									<xsl:value-of select="node()/cbc:DocumentCurrencyCode"/>
								</xsl:element>
							</xsl:if>
							<xsl:if test="$TipoDoc = $Electronica">
<!--  Condicional		 			<xsl:if test=""> -->
<!-- 									<xsl:element name="MntNeto"> -->
<!-- 										<xsl:value-of select="node()/cac:LegalMonetaryTotal/cbc:LineExtensionAmount"/> -->
<!-- 									</xsl:element> -->
<!-- 								</xsl:if> -->
							</xsl:if>
							<xsl:choose>
								<xsl:when test="$TipoDoc = $Exportacion">
									<xsl:element name="MntExe">
										<xsl:value-of select="node()/cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount"/>
		 							</xsl:element>
								</xsl:when>
								<xsl:otherwise>
<!--  Condicional 						<xsl:if test=""> -->
<!-- 										<xsl:element name="MntExe"> -->
<!-- 											<xsl:value-of select="node()/cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount"/> -->
<!-- 			 							</xsl:element> -->
<!-- 									</xsl:if> -->
								</xsl:otherwise>
							</xsl:choose>
							<xsl:if test="$TipoDoc = $Electronica">
<!-- Condicional				<xsl:if test=""> -->
<!--  							<xsl:element name="MntBase"> -->
<!-- 								<xsl:value-of select="cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount"/> -->
<!-- 							</xsl:element> -->
<!-- 							</xsl:if> -->
<!-- 							<xsl:if test=""> -->
<!-- Condicional				<xsl:element name="MntMargenCom"> -->
<!-- 								<xsl:value-of select="'FALTANTE'"/> -->
<!-- 							</xsl:element> -->
<!-- 							</xsl:if> -->
<!-- 							<xsl:if test=""> -->
<!-- COndicional				<xsl:element name="TasaIVA"> -->
<!-- 								<xsl:value-of select="'FALTANTE'"/> Confirmar el dato-->
<!-- 							</xsl:element> -->
<!-- 							</xsl:if> -->
<!-- 							<xsl:if test=""> -->
<!-- COndicional				<xsl:element name="IVA"> -->
<!-- 								<xsl:value-of select="'FALTANTE'"/> -->
<!-- 							</xsl:eleent> -->
<!-- 							</xsl:if> -->
								<xsl:if test="string()">
									<xsl:element name="IVAProp">
										<xsl:value-of select="'FALTANTE'"/>
									</xsl:element>
								</xsl:if>
								<xsl:if test="string()">
									<xsl:element name="IVATerc">
										<xsl:value-of select="'FALTANTE'"/>
									</xsl:element>
								</xsl:if>
<!-- 	COndicional					<xsl:if test=""> -->
<!-- 									<xsl:element name="ImptoReten"> -->
<!-- 									<xsl:if test=""> -->
<!-- 										<xsl:element name="TipoImp"> -->
<!-- 											<xsl:value-of select="'FALTANTE'"/> -->
<!-- 										</xsl:element> -->
<!-- 									</xsl:if> -->
<!-- 									<xsl:if test=""> -->
<!-- 										<xsl:element name="TasaImp"> -->
<!-- 											<xsl:value-of select="node()/cac:TaxTotal/cac:TaxSubtotal/cbc:Percent"/> -->
<!-- 										</xsl:element> -->
<!-- 									</xsl:if> -->
<!-- 									<xsl:if test=""> -->
<!-- 										<xsl:element name="MontoImp"> -->
<!-- 											<xsl:value-of select="'FALTANTE'"/> -->
<!-- 										</xsl:element> -->
<!-- 									</xsl:if> -->
<!-- 									</xsl:element> -->
<!-- 								</xsl:if> -->
<!-- Condicional					<xsl:if test=""> -->
<!-- 									<xsl:element name="IVANoRet"> -->
<!-- 										<xsl:value-of select=""/> -->
<!-- 									</xsl:element> -->
<!-- 								</xsl:if> -->
<!-- Condicional					<xsl:if test=""> -->
<!-- 									<xsl:element name="CredEC"> -->
<!-- 										<xsl:value-of select="'FALTANTE'"/> -->
<!-- 									</xsl:element> -->
<!-- 								</xsl:if> -->
<!-- Condicional					<xsl:if test=""> -->
<!-- 									<xsl:element name="GrntDep"> -->
<!-- 										<xsl:value-of select="'FALTANTE'"/> -->
<!-- 									</xsl:element> -->
<!-- 								</xsl:if> -->
<!-- 								<xsl:if test=""> -->
<!-- Condicional						<xsl:element name="ValComNeto"> -->
<!-- 										<xsl:value-of select=""/> -->
<!-- 									</xsl:element> -->
<!-- 								</xsl:if> -->
<!-- Condicional					<xsl:if test=""> -->
<!-- 									<xsl:element name="ValComExe"> -->
<!-- 										<xsl:value-of select=""/> -->
<!-- 									</xsl:element> -->
<!-- 								</xsl:if> -->
<!-- Condicional					<xsl:if test=""> -->
<!-- 									<xsl:element name="ValComIVA"> -->
<!-- 										<xsl:value-of select=""/> -->
<!-- 									</xsl:element> -->
<!-- 								</xsl:if> -->
							</xsl:if>
							<xsl:element name="MntTotal">
								<xsl:value-of select="node()/cac:LegalMonetaryTotal/cbc:PayableAmount"/>
							</xsl:element>
							<xsl:if test="$TipoDoc = $Electronica">
<!-- Condicional					<xsl:if test=""> -->
<!-- 									<xsl:element name="MontoNF"> -->
<!-- 										<xsl:value-of select="'FALTANTE'"/> -->
<!-- 									</xsl:element> -->
<!-- 								</xsl:if> -->
							<xsl:if test="string()">
								<xsl:element name="MontoPeriodo">
									<xsl:value-of select="'FALTANTE'"/>
								</xsl:element>
							</xsl:if>
							<xsl:if test="string()">
								<xsl:element name="SaldoAnterior">
									<xsl:value-of select="'FALTANTE'"/>
								</xsl:element>
							</xsl:if>
							<xsl:if test="string()">
								<xsl:element name="VlrPagar">
									<xsl:value-of select="'FALTANTE'"/>
								</xsl:element>
							</xsl:if>
							</xsl:if>
						</xsl:element>
						<!--OTRAMONEDA-->
						<xsl:if test="string()">
							<xsl:element name="OtraMoneda">
<!-- 	COndicional					<xsl_if test=""> -->
<!-- 									<xsl:element name="TpoMoneda"> -->
<!-- 										<xsl:value-of select="node()/cbc:PaymentAlternativeCurrencyCode"/> -->
<!-- 									</xsl:element> -->
<!-- 								</xsl_if> -->
								<xsl:if test="string()">
									<xsl:element name="TpoCambio">
										<xsl:value-of select="'FALTANTE'"/>
									</xsl:element>
								</xsl:if>
								<xsl:if test="$TipoDoc = $Electronica">
									<xsl:if test="string()">
										<xsl:element name="MntNetoOtrMnda">
											<xsl:value-of select="'FALTANTE'"/>
										</xsl:element>
									</xsl:if>
								</xsl:if>
								<xsl:if test="string()">
									<xsl:element name="MntExeOtrMnda">
										<xsl:value-of select="'FALTANTE'"/>
									</xsl:element>
								</xsl:if>
									<xsl:if test="$TipoDoc = $Electronica">
										<xsl:if test="string()">
											<xsl:element name="MntFaeCarneOtrMnda">
												<xsl:value-of select="'FALTANTE'"/>
											</xsl:element>
										</xsl:if>
<!-- Condicional							<xsl:if test=""> -->
<!-- 											<xsl:element name="MntMargComOtrMnda"> -->
<!-- 												<xsl:value-of select="'FALTANTE'"/> -->
<!-- 											</xsl:element> -->
<!-- 										</xsl:if> -->
<!-- 	Condicional							<xsl:if test=""> -->
<!-- 											<xsl:element name="IVAOtrMnda"> -->
<!-- 												<xsl:value-of select="'FALTANTE'"/> -->
<!-- 											</xsl:element> -->
<!-- 										</xsl:if> -->
<!-- 										<xsl:if test=""> -->
<!-- 	Condicional								<xsl:element name="ImpRetOtrMnda"> -->
<!-- 	COndicional										<xsl:if test=""> -->
<!-- 														<xsl:element name="TipoImpOtrMnda"> -->
<!-- 															<xsl:value-of select="'FALTANTE'"/> -->
<!-- 														</xsl:element> -->
<!-- 													</xsl:if> -->
<!-- 	COndicional										<xsl:if test=""> -->
<!-- 														<xsl:element name="TasaImpOtrMnda"> -->
<!-- 															<xsl:value-of select="'FALTANTE'"/> -->
<!-- 														</xsl:element> -->
<!-- 													</xsl:if> -->
<!-- 	Condicional										<xsl:if test=""> -->
<!-- 														<xsl:element name="VlrImpOtrMnda"> -->
<!-- 															<xsl:value-of select="'FALTANTE'"/> -->
<!-- 														</xsl:element> -->
<!-- 													</xsl:if> -->
<!-- 											</xsl:element> -->
<!-- 										</xsl:if> -->
										<xsl:if test="string()">
											<xsl:element name="IVANoRetOtrMnda">
												<xsl:value-of select="'FALTANTE'"/>
											</xsl:element>
										</xsl:if>
									</xsl:if>
<!-- 	COndicional					<xsl:if test=""> -->
<!-- 									<xsl:element name="MntTotOtrMnda"> -->
<!-- 										<xsl:value-of select="'FALTANTE'"/> -->
<!-- 									</xsl:element> -->
<!-- 								</xsl:if> -->
							</xsl:element>
						</xsl:if>
					</xsl:element>
					
					<!--DETALLE-->
					<xsl:for-each select="node()/cac:DebitNoteLine">
					<xsl:element name="Detalle">
							<xsl:element name="NroLinDet">
								<xsl:value-of select="cbc:ID"/>
							</xsl:element>
							<xsl:element name="CdgItem">
								<xsl:if test="string()">
									<xsl:element name="TpoCodigo">
										<xsl:value-of select="'FALTANTE'"/>
									</xsl:element>
								</xsl:if>
								<xsl:if test="string()">
									<xsl:element name="VlrCodigo">
										<xsl:value-of select="'FALTANTE'"/>
									</xsl:element>
								</xsl:if>
							</xsl:element>
<!-- 	Condicional				<xsl:if test=""> -->
<!-- 								<xsl:element name="IndExe"> -->
<!-- 									<xsl:value-of select="'FALTANTE'"/> -->
<!-- 								</xsl:element> -->
<!-- 							</xsl:if> -->
							<xsl:if test="$TipoDoc = $Electronica">
								<xsl:element name="Retenedor">
<!-- COndicional						<xsl:if test=""> -->
<!-- 										<xsl:element name="IndAgente"> -->
<!-- 											<xsl:value-of select="'FALTANTE'"/> -->
<!-- 										</xsl:element> -->
<!-- 									</xsl:if> -->
<!-- COndicional						<xsl:if test=""> -->
<!-- 										<xsl:element name="MntBaseFaena"> -->
<!-- 											<xsl:value-of select="'FALTANTE'"/> -->
<!-- 										</xsl:element> -->
<!-- 									</xsl:if> -->
<!-- COndicional						<xsl:if test=""> -->
<!-- 										<xsl:element name="MntMargComer"> -->
<!-- 											<xsl:value-of select="'FALTANTE'"/> -->
<!-- 										</xsl:element> -->
<!-- 									</xsl:if> -->
<!-- Condicional						<xsl:if test=""> -->
<!-- 										<xsl:element name="PrcConsFinal"> -->
<!-- 											<xsl:value-of select="node()/cac:InvoiceLine/cbc:LineExtensionAmount"/> -->
<!-- 										</xsl:element> -->
<!-- 									</xsl:if> -->
								</xsl:element>
							</xsl:if>
							<xsl:element name="NmbItem">
								<xsl:value-of select="cac:Item/cbc:Name"/>
							</xsl:element>
							<xsl:if test="string(cac:Item/cbc:Description)">
								<xsl:element name="DscItem">
									<xsl:value-of select="cac:Item/cbc:Description"/>
								</xsl:element>
							</xsl:if>
							<xsl:choose>
								<xsl:when test="$TipoDoc = $Electronica">
<!-- COndicional						<xsl:if test=""> -->
<!-- 										<xsl:element name="QtyRef"> -->
<!-- 											<xsl:value-of select="cbc:InvoicedQuantity"/> -->
<!-- 										</xsl:element> -->
<!-- 									</xsl:if> -->
<!-- Condicional						<xsl:if test=""> -->
<!-- 										<xsl:element name="UnmdRef"> -->
<!-- 											<xsl:value-of select="cac:Item/cac:Dimension/cbc:Measure"/> -->
<!-- 										</xsl:element> -->
<!-- 									</xsl:if> -->
<!-- Condicional						<xsl:if test="cac:Price/cbc:PriceAmount"> -->
<!-- 										<xsl:element name="PrcRef"> -->
<!-- 											<xsl:value-of select="cac:Price/cbc:PriceAmount"/> -->
<!-- 										</xsl:element> -->
<!-- 									</xsl:if> -->
								</xsl:when>
								<xsl:otherwise>
									<xsl:if test="string(cbc:InvoicedQuantity)">
										<xsl:element name="QtyRef">
											<xsl:value-of select="cbc:InvoicedQuantity"/>
										</xsl:element>
									</xsl:if>
									<xsl:if test="string(cac:Item/cac:Dimension/cbc:Measure)">
										<xsl:element name="UnmdRef">
											<xsl:value-of select="cac:Item/cac:Dimension/cbc:Measure"/>
										</xsl:element>
									</xsl:if>
									<xsl:if test="string(cac:Price/cbc:PriceAmount)">
										<xsl:element name="PrcRef">
											<xsl:value-of select="cac:Price/cbc:PriceAmount"/>
										</xsl:element>
									</xsl:if>
								</xsl:otherwise>
							</xsl:choose>
<!-- COndicional					<xsl:if test=""> -->
<!-- 									<xsl:element name="QtyItem"> -->
<!-- 										<xsl:value-of select="cbc:InvoicedQuantity"/> -->
<!-- 									</xsl:element> -->
<!-- 								</xsl:if> -->
							<xsl:if test="string(cbc:InvoicedQuantity)">
								<xsl:element name="SubCantidad">
									<xsl:if test="$TipoDoc = $Exportacion">
										<xsl:if test="string(cbc:InvoicedQuantity)">
											<xsl:element name="SubQty">
												<xsl:value-of select="cbc:InvoicedQuantity"/>
											</xsl:element>
										</xsl:if>
										<xsl:if test="string()">
											<xsl:element name="SubCod">
												<xsl:value-of select="'FALTANTE'"/>
											</xsl:element>
										</xsl:if>
										<xsl:if test="string()">
											<xsl:element name="TipCodSubQty">
												<xsl:value-of select="'FALTANTE'"/>
											</xsl:element>
										</xsl:if>
									</xsl:if>
								</xsl:element>
							</xsl:if>
							<xsl:if test="$TipoDoc = $Exportacion">
								<xsl:if test="string(cac:Item/cac:ItemInstance/cac:ItemInstance/cbc:ManufactureDate)">
									<xsl:element name="FchElabor">
										<xsl:value-of select="cac:Item/cac:ItemInstance/cac:ItemInstance/cbc:ManufactureDate"/>
									</xsl:element>
								</xsl:if>
								<xsl:if test="string(node()/cac:ItemInstance/cac:ItemInstance/cbc:BestBeforeDate)">
									<xsl:element name="FchVencim">
										<xsl:value-of select="node()/cac:ItemInstance/cac:ItemInstance/cbc:BestBeforeDate"/>
									</xsl:element>
								</xsl:if>
							</xsl:if>
<!-- Condicional					<xsl:if test=""> -->
<!-- 									<xsl:element name="UnmdItem"> -->
<!-- 										<xsl:value-of select="cac:Item/cac:Dimension/cbc:Measure"/> -->
<!-- 									</xsl:element> -->
<!-- 								</xsl:if> -->
							<xsl:choose>
								<xsl:when test="$TipoDoc = $Exportacion">
									<xsl:if test="cac:Price/cbc:PriceAmount">
										<xsl:element name="PrcItem">
											<xsl:value-of select="cac:Price/cbc:PriceAmount"/>
										</xsl:element>
									</xsl:if>
								</xsl:when>
								<xsl:otherwise>
<!-- Condicional						<xsl:if test=""> -->
<!-- 										<xsl:element name="PrcItem"> -->
<!-- 											<xsl:value-of select="cac:Price/cbc:PriceAmount"/> -->
<!-- 										</xsl:element> -->
<!-- 									</xsl:if> -->
								</xsl:otherwise>
							</xsl:choose>
								<xsl:if test="string()">
									<xsl:element name="OtrMnda">
	<!-- COndicional						<xsl:if test=""> -->
	<!-- 										<xsl:element name="PrcOtrMon"> -->
	<!-- 											<xsl:value-of select="'FALTANTE'"/> -->
	<!-- 										</xsl:element> -->
	<!-- 									</xsl:if> -->
	<!-- Condicional						<xsl:if test=""> -->
	<!-- 										<xsl:element name="Moneda"> -->
	<!-- 											<xsl:value-of select="'FALTANTE'"/> -->
	<!-- 										</xsl:element> -->
	<!-- 									</xsl:if> -->
	<!-- Condicional						<xsl:if test=""> -->
	<!-- 										<xsl:element name="FctConv"> -->
	<!-- 											<xsl:value-of select="'FALTANTE'"/> -->
	<!-- 										</xsl:element> -->
	<!-- 									</xsl:if> -->
										<xsl:if test="string()">
											<xsl:element name="DctoOtrMnda">
												<xsl:value-of select="'FALTANTE'"/>
											</xsl:element>
										</xsl:if>
										<xsl:if test="string()">
											<xsl:element name="RecargoOtrMnda">
												<xsl:value-of select="'FALTANTE'"/>
											</xsl:element>
										</xsl:if>
	<!-- Condicional						<xsl:if test=""> -->
	<!-- 										<xsl:element name="MontoItemOtrMnda"> -->
	<!-- 											<xsl:value-of select="'FALTANTE'"/> -->
	<!-- 										</xsl:element> -->
	<!-- 									</xsl:if> -->
									</xsl:element>
								</xsl:if>
								<xsl:if test="string()">
									<xsl:element name="DescuentoPct">
										<xsl:value-of select="'FALTANTE'"/>
									</xsl:element>
								</xsl:if>
								<xsl:choose>
									<xsl:when test="$TipoDoc = $Exportacion">
										<xsl:if test="string()">
											<xsl:element name="DescuentoMonto">
												<xsl:value-of select="'FALTANTE'"/>
											</xsl:element>
										</xsl:if>
									</xsl:when>
									<xsl:otherwise>
<!-- Condicional							<xsl:if test=""> -->
<!-- 											<xsl:element name="DescuentoMonto"> -->
<!-- 												<xsl:value-of select="'FALTANTE'"/> -->
<!-- 											</xsl:element> -->
<!-- 										</xsl:if> -->
									</xsl:otherwise>
								</xsl:choose>
								<xsl:if test="string()">
									<xsl:element name="TablaDistribucionDescuento">
										<xsl:if test="string()">
											<xsl:element name="TipoDscto">
												<xsl:value-of select="'FALTANTE'"/>
											</xsl:element>
										</xsl:if>
										<xsl:if test="string()">
											<xsl:element name="ValorDscto">
												<xsl:value-of select="'FALTANTE'"/>
											</xsl:element>
										</xsl:if>
										<xsl:if test="string()">
											<xsl:element name="RecargoPct">
												<xsl:value-of select="'FALTANTE'"/>
											</xsl:element>
										</xsl:if>
									</xsl:element>
								</xsl:if>
								<xsl:choose>
									<xsl:when test="$TipoDoc = $Exportacion">
										<xsl:if test="string()">
											<xsl:element name="RecargoMonto">
												<xsl:value-of select="'FALTANTE'"/>
											</xsl:element>
										</xsl:if>
									</xsl:when>
									<xsl:otherwise>
<!-- Condicional							<xsl:if test=""> -->
<!-- 											<xsl:element name="RecargoMonto"> -->
<!-- 												<xsl:value-of select="'FALTANTE'"/> -->
<!-- 											</xsl:element> -->
<!-- 										</xsl:if> -->
									</xsl:otherwise>
								</xsl:choose>
								<xsl:if test="string()">
									<xsl:element name="SubRecargo">
										<xsl:if test="string()">
											<xsl:element name="TipoRecargo">
												<xsl:value-of select="'FALTANTE'"/>
											</xsl:element>
										</xsl:if>
										<xsl:if test="string()">
											<xsl:element name="ValorRecargo">
												<xsl:value-of select="'FALTANTE'"/>
											</xsl:element>
										</xsl:if>
									</xsl:element>
								</xsl:if>
							<xsl:if test="$TipoDoc = $Electronica">
								<xsl:if test="string()">
									<xsl:element name="CodigosImpuestoAdicinalYRetenciones">
<!-- 	Condicional							<xsl:if test=""> -->
<!-- 											<xsl:element name="CodImpAdic"> -->
<!-- 												<xsl:value-of select="'FALTANTE'"/> -->
<!-- 											</xsl:element> -->
<!-- 										</xsl:if> -->
									</xsl:element>
								</xsl:if>
							</xsl:if>
							<xsl:element name="MontoItem">
								<xsl:value-of select="'FALTANTE'"/>
							</xsl:element>
					</xsl:element>
					</xsl:for-each>
					<!--SUBTOTALESINFORMATIVOS-->
					<xsl:for-each select="node()/cac:DebitNoteLine">
						<xsl:element name="SubTotalesInformativos">
								<xsl:element name="NroSTI">
									<xsl:value-of select="cbc:ID"/>
								</xsl:element>
								<xsl:element name="GlosaSTI">
									<xsl:value-of select="cac:Item/cbc:Name"/>
								</xsl:element>
								<xsl:if test="string()">
								<xsl:element name="OrdenSTI">
									<xsl:value-of select="'FALTANTE'"/>
								</xsl:element>
								</xsl:if>
								<xsl:if test="$TipoDoc = $Electronica">
									<xsl:if test="string()">
										<xsl:element name="SubTotNetoSTI">
											<xsl:value-of select="'FALTANTE'"/>
										</xsl:element>
									</xsl:if>
									<xsl:if test="string(cac:TaxTotal/cbc:TaxAmount)">
										<xsl:element name="SubTotaIVASTI">
											<xsl:value-of select="cac:TaxTotal/cbc:TaxAmount"/>
										</xsl:element>
									</xsl:if>
									<xsl:if test="string()">
										<xsl:element name="SubTotAdicSTI">
											<xsl:value-of select="'FALTANTE'"/>
										</xsl:element>
									</xsl:if>
								</xsl:if>
								<xsl:if test="string()">
								<xsl:element name="SubTotExeSTI">
									<xsl:value-of select="'FALTANTE'"/>
								</xsl:element>
								</xsl:if>
								<xsl:if test="string()">
								<xsl:element name="ValSubtotSTI">
									<xsl:value-of select="'FALTANTE'"/>
								</xsl:element>
								</xsl:if>
								<xsl:if test="string(cac:Item/cbc:Description)">
								<xsl:element name="LineasDeta">
									<xsl:value-of select="cac:Item/cbc:Description"/>
								</xsl:element>
								</xsl:if>
						</xsl:element>
					</xsl:for-each>
					<!--DESCUENTOS DE RECARGO GLOBAL-->
						<xsl:element name="DscRcgGlobal">
								<xsl:element name="NroLinDR">
									<xsl:value-of select="'FALTANTE'"/>
								</xsl:element>
								<xsl:element name="TpoMov">
									<xsl:value-of select="'FALTANTE'"/>
								</xsl:element>
								<xsl:if test="string()">
									<xsl:element name="GlosaDR">
										<xsl:value-of select="'FALTANTE'"/>
									</xsl:element>
								</xsl:if>
								<xsl:element name="TpoValor">
									<xsl:value-of select="'FALTANTE'"/>
								</xsl:element>
								<xsl:choose>
									<xsl:when test="$TipoDoc = $Exportacion">
										<xsl:if test="string()">
											<xsl:element name="ValorDR">
												<xsl:value-of select="'FALTANTE'"/>
											</xsl:element>
										</xsl:if>
										<xsl:element name="ValorDROtrMnda">
											<xsl:value-of select="'FALTANTE'"/>
										</xsl:element>
									</xsl:when>
									<xsl:otherwise>
										<xsl:element name="ValorDR">
											<xsl:value-of select="'FALTANTE'"/>
										</xsl:element>
										<xsl:if test="string()">
											<xsl:element name="ValorDROtrMnda">
												<xsl:value-of select="'FALTANTE'"/>
											</xsl:element>
										</xsl:if>
									</xsl:otherwise>
								</xsl:choose>
<!-- Condicional					<xsl:if test=""> -->
<!-- 									<xsl:element name="IndExeDR"> -->
<!-- 										<xsl:value-of select="'FALTANTE'"/> -->
<!-- 									</xsl:element> -->
<!-- 								</xsl:if> -->
						</xsl:element>
					<!--INFORMACIONDEREFERENCIA-->
						<xsl:element name="InformacionReferencia">
								<xsl:element name="NroLinRef">
									<xsl:value-of select="'FALTANTE'"/>
								</xsl:element>
								<xsl:element name="TpoDocRef">
									<xsl:value-of select="cbc:InvoiceTypeCode"/>
								</xsl:element>
	<!-- Condicional				<xsl:if test=""> -->
	<!-- 								<xsl:element name="IndGlobal"> -->
	<!-- 									<xsl:value-of select="cbc:InvoiceTypeCode"/> -->
	<!-- 								</xsl:element> -->
	<!-- 							</xsl:if> -->
								<xsl:element name="FolioRef">
									<xsl:value-of select="'FALTANTE'"/>
								</xsl:element>
								<xsl:choose>
									<xsl:when test="$TipoDoc = $Exportacion">
										<xsl:if test="string()">
											<xsl:element name="RUTOtr">
												<xsl:value-of select="'FALTANTE'"/>
											</xsl:element>
										</xsl:if>
										<xsl:if test="string()">
											<xsl:element name="IdAdicOtr">
												<xsl:value-of select="'FALTANTE'"/>
											</xsl:element>
										</xsl:if>
									</xsl:when>
									<xsl:otherwise>
		<!-- Condicional					<xsl:if test=""> -->
		<!-- 									<xsl:element name="RUTOtr"> -->
		<!-- 										<xsl:value-of select=""/> -->
		<!-- 									</xsl:element> -->
		<!-- 								</xsl:if> -->
									</xsl:otherwise>
								</xsl:choose>
								<xsl:element name="FchRef">
									<xsl:value-of select="'cbc:IssueDate'"/>
								</xsl:element>
								<xsl:element name="CodRef">
									<xsl:value-of select="'FALTANTE'"/>
								</xsl:element>
								<xsl:if test="string()">
									<xsl:element name="RazonRef">
										<xsl:value-of select="'FALTANTE'"/>
									</xsl:element>
								</xsl:if>
						</xsl:element>
					<!-- COMISIONES Y OTROS CARGOS -->
					<xsl:if test="$TipoDoc = $Electronica">
						<xsl:element name="ComisOtrosCargos">
							<xsl:element name="NroLinCom">
								<xsl:value-of select="'FALTANTE'"/>
							</xsl:element>
							<xsl:element name="TipoMovim">
								<xsl:value-of select="'FALTANTE'"/>
							</xsl:element>
							<xsl:element name="Glosa">
								<xsl:value-of select="'FALTANTE'"/>
							</xsl:element>
							<xsl:if test="string()">
								<xsl:element name="TasaComision">
									<xsl:value-of select="'FALTANTE'"/>
								</xsl:element>
							</xsl:if>
							<xsl:element name="ValComNeto">
								<xsl:value-of select="'FALTANTE'"/>
							</xsl:element>
							<xsl:element name="ValComExe">
								<xsl:value-of select="'FALTANTE'"/>
							</xsl:element>
<!-- Condicional				<xsl:if test=""> -->
<!-- 								<xsl:element name="ValComIVA"> -->
<!-- 									<xsl:value-of select=""/> -->
<!-- 								</xsl:element> -->
<!-- 							</xsl:if> -->
						</xsl:element>
					</xsl:if>
					
					
					
					
					
					
					<!-- NO LOCALIZADO -->
<!-- 					<xsl:element name="TED"> -->
<!-- 					<xsl:attribute name="version" select="'1.0'"/> -->
<!-- 							<xsl:element name="DD"> -->
<!-- 								<xsl:element name="RE"> -->
<!-- 									<xsl:value-of select="'FALTANTE'"/> -->
<!-- 								</xsl:element> -->
<!-- 								<xsl:element name="TD"> -->
<!-- 									<xsl:value-of select="'FALTANTE'"/> -->
<!-- 								</xsl:element> -->
<!-- 								<xsl:element name="F"> -->
<!-- 									<xsl:value-of select="'FALTANTE'"/> -->
<!-- 								</xsl:element> -->
<!-- 								<xsl:element name="FE"> -->
<!-- 									<xsl:value-of select="'FALTANTE'"/> -->
<!-- 								</xsl:element> -->
<!-- 								<xsl:element name="RR"> -->
<!-- 									<xsl:value-of select="'FALTANTE'"/> -->
<!-- 								</xsl:element> -->
<!-- 								<xsl:element name="RSR"> -->
<!-- 									<xsl:value-of select="'FALTANTE'"/> -->
<!-- 								</xsl:element> -->
<!-- 								<xsl:element name="MNT"> -->
<!-- 									<xsl:value-of select="'FALTANTE'"/> -->
<!-- 								</xsl:element> -->
<!-- 								<xsl:element name="IT1"> -->
<!-- 									<xsl:value-of select="'FALTANTE'"/> -->
<!-- 								</xsl:element> -->
<!-- 								<xsl:element name="CAF"> -->
<!-- 								<xsl:attribute name="version" select="'1.0'"/> -->
<!-- 									<xsl:element name="DA"> -->
<!-- 										<xsl:element name="RA"> -->
<!-- 											<xsl:value-of select="'FALTANTE'"/> -->
<!-- 										</xsl:element> -->
<!-- 										<xsl:element name="RS"> -->
<!-- 											<xsl:value-of select="'FALTANTE'"/> -->
<!-- 										</xsl:element> -->
<!-- 										<xsl:element name="TD"> -->
<!-- 											<xsl:value-of select="'FALTANTE'"/> -->
<!-- 										</xsl:element> -->
<!-- 										<xsl:element name="RNG"> -->
<!-- 											<xsl:element name="D"> -->
<!-- 												<xsl:value-of select="'FALTANTE'"/> -->
<!-- 											</xsl:element> -->
<!-- 											<xsl:element name="H"> -->
<!-- 												<xsl:value-of select="'FALTANTE'"/> -->
<!-- 											</xsl:element> -->
<!-- 										</xsl:element> -->
<!-- 										<xsl:element name="FA"> -->
<!-- 											<xsl:value-of select="'FALTANTE'"/> -->
<!-- 										</xsl:element> -->
<!-- 										<xsl:element name="RSAPK"> -->
<!-- 											<xsl:element name="M"> -->
<!-- 												<xsl:value-of select="'FALTANTE'"/> -->
<!-- 											</xsl:element> -->
<!-- 											<xsl:element name="E"> -->
<!-- 												<xsl:value-of select="'FALTANTE'"/> -->
<!-- 											</xsl:element> -->
<!-- 										</xsl:element> -->
<!-- 										<xsl:element name="RSAPK"> -->
<!-- 											<xsl:value-of select="'FALTANTE'"/> -->
<!-- 										</xsl:element> -->
<!-- 									</xsl:element> -->
<!-- 									<xsl:element name="FRMA"> -->
<!-- 									<xsl:attribute name="algoritmo" select="'FALTANTE'"/> -->
<!-- 										<xsl:value-of select="'FALTANTE'"/> -->
<!-- 									</xsl:element> -->
<!-- 								</xsl:element> -->
<!-- 								<xsl:element name="TSTED"> -->
<!-- 									<xsl:value-of select="'FALTANTE'"/> -->
<!-- 								</xsl:element> -->
<!-- 							</xsl:element> -->
<!-- 							<xsl:element name="FRMT"> -->
<!-- 							<xsl:attribute name="algoritmo" select="'FALTANTE'"/> -->
<!-- 								<xsl:value-of select="'FALTANTE'"/> -->
<!-- 							</xsl:element> -->
<!-- 					</xsl:element> -->
					<xsl:element name="TmstFirma">
						<xsl:value-of select="'FALTANTE'"/>
					</xsl:element>
				</xsl:element>
<!-- 				<xsl:element name="Signature" xmlns="http://www.w3.org/2000/09/xmldsig#"> -->
<!-- 					<xsl:element name="SignedInfo"> -->
<!-- 						<xsl:element name="CanonicalizationMethod"> -->
<!-- 						<xsl:attribute name="Algorithm" select="'http://www.w3.org/TR/2001/REC-xml-c14n-20010315'"/> -->
<!-- 							<xsl:value-of select="'FALTANTE'"/> -->
<!-- 						</xsl:element> -->
<!-- 						<xsl:element name="SignatureMethod"> -->
<!-- 						<xsl:attribute name="Algorithm" select="'http://www.w3.org/2000/09/xmldsig#rsa-sha1'"/> -->
<!-- 							<xsl:value-of select="'FALTANTE'"/> -->
<!-- 						</xsl:element> -->
<!-- 						<xsl:element name="Reference"> -->
<!-- 							<xsl:attribute name="URI" select="'#F60T33'"/> -->
<!-- 							<xsl:element name="Transforms"> -->
<!-- 								<xsl:element name="Transform"> -->
<!-- 								<xsl:attribute name="Algorithm" select="'http://www.w3.org/TR/2001/REC-xml-c14n-20010315'"/> -->
<!-- 									<xsl:value-of select="'FALTANTE'"/> -->
<!-- 								</xsl:element> -->
<!-- 							</xsl:element> -->
<!-- 							<xsl:element name="DigestMethod"> -->
<!-- 							<xsl:attribute name="Algorithm" select="'http://www.w3.org/2000/09/xmldsig#sha1'"/> -->
<!-- 								<xsl:value-of select="'FALTANTE'"/> -->
<!-- 							</xsl:element> -->
<!-- 							<xsl:element name="DigestValue"> -->
<!-- 								<xsl:value-of select="'FALTANTE'"/> -->
<!-- 							</xsl:element> -->
<!-- 						</xsl:element> -->
<!-- 					</xsl:element> -->
<!-- 					<xsl:element name="SignatureValue"> -->
<!-- 						<xsl:value-of select="'FALTANTE'"/> -->
<!-- 					</xsl:element> -->
<!-- 					<xsl:element name="KeyInfo"> -->
<!-- 						<xsl:element name="KeyValue"> -->
<!-- 							<xsl:element name="RSAKeyValue"> -->
<!-- 								<xsl:element name="Modulus"> -->
<!-- 									<xsl:value-of select="'FALTANTE'"/> -->
<!-- 								</xsl:element> -->
<!-- 								<xsl:element name="Exponent"> -->
<!-- 									<xsl:value-of select="'FALTANTE'"/> -->
<!-- 								</xsl:element> -->
<!-- 							</xsl:element> -->
<!-- 						</xsl:element> -->
<!-- 						<xsl:element name="X509Data"> -->
<!-- 							<xsl:element name="X509Certificate"> -->
<!-- 								<xsl:value-of select="'FALTANTE'"/> -->
<!-- 							</xsl:element> -->
<!-- 						</xsl:element> -->
<!-- 					</xsl:element> -->
<!-- 				</xsl:element> -->
			</xsl:element>
		</xsl:element>
<!-- 		<xsl:element name="Signature" xmlns="http://www.w3.org/2000/09/xmldsig#"> -->
<!-- 			<xsl:element name="SignedInfo"> -->
<!-- 				<xsl:element name="CanonicalizationMethod"> -->
<!-- 				<xsl:attribute name="Algorithm" select="'http://www.w3.org/TR/2001/REC-xml-c14n-20010315'"/> -->
<!-- 					<xsl:value-of select="'FALTANTE'"/> -->
<!-- 				</xsl:element> -->
<!-- 				<xsl:element name="SignatureMethod"> -->
<!-- 				<xsl:attribute name="Algorithm" select="'http://www.w3.org/2000/09/xmldsig#rsa-sha1'"/> -->
<!-- 					<xsl:value-of select="'FALTANTE'"/> -->
<!-- 				</xsl:element> -->
<!-- 				<xsl:element name="Reference"> -->
<!-- 					<xsl:attribute name="URI" select="'#F60T33'"/> -->
<!-- 					<xsl:element name="Transforms"> -->
<!-- 						<xsl:element name="Transform"> -->
<!-- 						<xsl:attribute name="Algorithm" select="'http://www.w3.org/TR/2001/REC-xml-c14n-20010315'"/> -->
<!-- 							<xsl:value-of select="'FALTANTE'"/> -->
<!-- 						</xsl:element> -->
<!-- 					</xsl:element> -->
<!-- 					<xsl:element name="DigestMethod"> -->
<!-- 					<xsl:attribute name="Algorithm" select="'http://www.w3.org/2000/09/xmldsig#sha1'"/> -->
<!-- 						<xsl:value-of select="'FALTANTE'"/> -->
<!-- 					</xsl:element> -->
<!-- 					<xsl:element name="DigestValue"> -->
<!-- 						<xsl:value-of select="'FALTANTE'"/> -->
<!-- 					</xsl:element> -->
<!-- 				</xsl:element> -->
<!-- 			</xsl:element> -->
<!-- 			<xsl:element name="SignatureValue"> -->
<!-- 				<xsl:value-of select="'FALTANTE'"/> -->
<!-- 			</xsl:element> -->
<!-- 			<xsl:element name="KeyInfo"> -->
<!-- 				<xsl:element name="KeyValue"> -->
<!-- 					<xsl:element name="RSAKeyValue"> -->
<!-- 						<xsl:element name="Modulus"> -->
<!-- 							<xsl:value-of select="'FALTANTE'"/> -->
<!-- 						</xsl:element> -->
<!-- 						<xsl:element name="Exponent"> -->
<!-- 							<xsl:value-of select="'FALTANTE'"/> -->
<!-- 						</xsl:element> -->
<!-- 					</xsl:element> -->
<!-- 				</xsl:element> -->
<!-- 				<xsl:element name="X509Data"> -->
<!-- 					<xsl:element name="X509Certificate"> -->
<!-- 						<xsl:value-of select="'FALTANTE'"/> -->
<!-- 					</xsl:element> -->
<!-- 				</xsl:element> -->
<!-- 			</xsl:element> -->
<!-- 		</xsl:element> -->
	</xsl:template>
	
	
	
<!-- DATOS AYUDA -->	

<!-- 	Si es exportación debe tener ID:9995, Name: EXP, Taxtypecode:FRE -->
<!-- 	<xsl:template match="cac:TaxScheme"> -->
<!-- 		<xsl:element name="cac:TaxScheme"> -->
<!-- 			<xsl:choose> -->
<!-- 				<xsl:when test="$tipoOperacion='01' or $tipoOperacion='03'"> -->
<!-- 					<xsl:element name="cbc:ID"> -->
<!-- 						<xsl:value-of select="'1000'" /> -->
<!-- 					</xsl:element> -->
<!-- 					<xsl:element name="cbc:Name"> -->
<!-- 						<xsl:value-of select="'IGV'"/> -->
<!-- 					</xsl:element> -->
<!-- 					<xsl:element name="cbc:TaxTypeCode"> -->
<!-- 						<xsl:value-of select="'VAT'"/> -->
<!-- 					</xsl:element> -->
<!-- 				</xsl:when> -->
<!-- 				<xsl:when test="$tipoOperacion='02' or $cam='0'"> -->
<!-- 					<xsl:element name="cbc:ID"> -->
<!-- 						<xsl:value-of select="'9995'" /> -->
<!-- 					</xsl:element> -->
<!-- 					<xsl:element name="cbc:Name"> -->
<!-- 						<xsl:value-of select="'EXP'"/> -->
<!-- 					</xsl:element> -->
<!-- 					<xsl:element name="cbc:TaxTypeCode"> -->
<!-- 						<xsl:value-of select="'FRE'"/> -->
<!-- 					</xsl:element> -->
<!-- 				</xsl:when> -->
<!-- 			</xsl:choose> -->
<!-- 		</xsl:element> -->
<!-- 	</xsl:template> -->
	
<!-- 	Si es exportación debe contener el tag CommodityClasification -->
<!-- 	<xsl:template match="cac:InvoiceLine/cac:Item/cbc:Description"> -->
<!-- 		<xsl:variable name="descripcion"> -->
<!-- 			<xsl:element name="cbc:Description"> -->
<!-- 				<xsl:value-of select="node()" /> -->
<!-- 			</xsl:element> -->
<!-- 		</xsl:variable> -->
<!-- 			<xsl:element name="cbc:Description"> -->
<!-- 				<xsl:value-of select="$descripcion" /> -->
<!-- 			</xsl:element> -->
<!-- 			<xsl:choose> -->
<!-- 				<xsl:when test="$tipoOperacion='02' or $cam='0'"> -->
<!-- 			<xsl:element name="cac:CommodityClassification"> -->
<!-- 				<cbc:ItemClassificationCode listAgencyID="113" listID="UNSPSC">10101502</cbc:ItemClassificationCode> -->
<!-- 			</xsl:element> -->
<!-- 				</xsl:when> -->
<!-- 			</xsl:choose> -->
<!-- 	</xsl:template> -->

	
	<!-- Descuentos por línea - Si no contiene código de motivo colocar codigo del cargo a descuento que afecta la base -->
<!-- 	<xsl:template match="cac:InvoiceLine/cac:AllowanceCharge[not(cbc:AllowanceChargeReasonCode)]/cbc:ChargeIndicator"> -->
<!-- 		<xsl:copy> -->
<!-- 			<xsl:value-of select="node()"/> -->
<!-- 		</xsl:copy> -->
<!-- 		<cbc:AllowanceChargeReasonCode>00</cbc:AllowanceChargeReasonCode> -->
<!-- 	</xsl:template> -->
	
	<!-- Anticipos -->
<!-- 	<xsl:template match="cac:PrepaidPayment/cbc:ID"/> -->
<!-- 	<xsl:template match="cac:PrepaidPayment"> -->
<!-- 		<xsl:copy> -->
<!-- 		    <cbc:ID><xsl:value-of select="count(preceding-sibling::cac:PrepaidPayment) + 1"/></cbc:ID> -->
<!-- 			<xsl:apply-templates select="node()"/> -->
<!-- 		</xsl:copy> -->
<!-- 	</xsl:template> -->
	
</xsl:stylesheet>