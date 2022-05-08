/**
 * @description       :
 * @author            : Taras Kuliievych
 * @last modified on  : 09-03-2021
 * @last modified by  : Taras Kuliievych
**/

public with sharing class EnquiryReportProcessor {
    /**
    * @description
    * @author Taras Kuliievych | 08-24-2021
    * @param enquiryDataJSON
    * @return String
    **/
    public String generateEnquiryReport(String enquiryDataJSON) {
		String encodedPDF;
		Map<String, String> enquiryData = (Map<String, String>) JSON.deserialize(enquiryDataJSON, Map<String, String>.class);
		String enquiryType = enquiryData.get('enquiryType');

		switch on enquiryType {
			when 'CBP_Tariff_Enquiry' {
				auraExceptionHandling('CBP Tariff Enquiry report still in development');
			}
			when 'CBP_Charge_Enquiry' {
				encodedPDF = procesChargeEnquiry(enquiryData);
			}
			when else {
				auraExceptionHandling('Enquiry type does not exist');
			}
		 }

		return encodedPDF;
	}

	/**
	* @description
	* @author Taras Kuliievych | 09-03-2021
	* @param enquiryData
	* @return String
	**/
	private String procesChargeEnquiry(Map<String, String> enquiryData) {
		CC_GenerateContentResponse docFusionresponse;

		try {
			String externalResponse;
			String chargeBelowDetailsValue = enquiryData.get('belowDetails');
			String accountNumber = enquiryData.get('selectedChequeAccount');
			String firstDate = enquiryData.get('dateFrom');
			String lastDate = enquiryData.get('dateTo');
			String clientName = enquiryData.get('customerName');
			String accountType = enquiryData.get('accountType');
			String accountName = enquiryData.get('accountName');

			String currencyCode = [SELECT CurrencyIsoCode FROM Account WHERE CIF__c = : enquiryData.get('CIF') LIMIT 1].CurrencyIsoCode;
			Document_Template__c documentTemplate;

			if(chargeBelowDetailsValue == 'detail') {
				externalResponse = IPCQChargeEnquiry_IH_v1.callToIPCQChargeEnquiry(accountNumber, firstDate, lastDate, currencyCode, accountType, accountName, clientName);
				documentTemplate = new DocumentTemplateSelector().selectTemplateByName('CBP Charge Enquiry Detail');
			} else if(chargeBelowDetailsValue == 'summary') {
				externalResponse = IPCQChargeEnquirySummary_IH_v1.callToIPCQChargeEnquirySummary(accountNumber, firstDate, lastDate, currencyCode, accountType, clientName);
				documentTemplate = new DocumentTemplateSelector().selectTemplateByName('CBP Charge Enquiry Summary');
			}

			if(String.isEmpty(externalResponse)) {
				auraExceptionHandling('External Service Error');
			}

			if(externalResponse.contains('No Transactions found for the given period')) {
				auraExceptionHandling('No Transactions found for the given period');
			}

			if(externalResponse.contains('Invalid Account Id')) {
				auraExceptionHandling('Invalid Account Id');
			}

			DocFusionJSONProcessor docFusionJSONProcessor = new DocFusionJSONProcessor();

			docFusionresponse = docFusionJSONProcessor.generateEnquiryReport(documentTemplate, externalResponse, new Map<String, String>());

			if(String.isEmpty(docFusionresponse.transformedData)) {
				auraExceptionHandling('DOCFusion Service Error');
			}
		} catch (Exception e) {
			auraExceptionHandling(e.getMessage());
		}

		return docFusionresponse.transformedData;
	}

	/**
	* @description
	* @author Taras Kuliievych | 09-03-2021
	* @param message
	* @return String
	**/
	private String auraExceptionHandling(String message) {
		AuraHandledException auraException = new AuraHandledException(message);
        auraException.setMessage(message);

        throw auraException;
	}
}