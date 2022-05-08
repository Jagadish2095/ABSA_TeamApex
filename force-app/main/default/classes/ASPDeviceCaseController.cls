/**
 * @description       :
 * @author            : Thomas
 * @group             :
 * @last modified on  : 2021-09-12
 * @last modified by  : Khaliq Abdul
 * Modifications Log
 */
public class ASPDeviceCaseController {

    /**
	 * @description GetCaseDataString description
	 * @param opportunityID 
     * @param  customerVerificationData
     * @param  documentScanningData
     * @param  customerContractData
	 * @return string
	 */
    @AuraEnabled
    public static string GetCaseDataString(string opportunityID, string customerVerificationData, string documentScanningData, string customerContractData)
    {
        try{
            SrmCase srmCase = GetCaseData(opportunityID, customerVerificationData, documentScanningData, customerContractData);
            return JSON.serialize(srmCase);
        }
        catch(Exception ex)
        {
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
	/**
	 * @description GetCaseData
	 * @param oppId 
     * @param  customerVerificationData
     * @param  documentScanningData
     * @param  customerContractData
	 * @return SrmCase
	 */
    
    @AuraEnabled
    public static SrmCase GetCaseData(string oppId, string customerVerificationData, string documentScanningData, string customerContractData)
    {
        Opportunity opportunity = [select AccountId from Opportunity where Id = :oppId];
        Account acc = new AccountsSelector().selectAllById(opportunity.AccountId);
        SrmCase srmCase = new SrmCase();
        srmCase.Customer = new SrmCase.SrmCustomer();
        srmCase.Customer.CustomerID = String.valueOf(opportunity.AccountId);
        srmCase.Customer = GetSrmCustomer(acc);
        srmCase.AbsaAgreements = GetSrmAbsaAgreement(oppId);
        srmCase.BasicCaseInfo = GetBasicCaseInfo(acc);  
        srmCase.CommunicationInfo = GetCommunicationInfo(acc);
        srmCase.DHACPBResult = GetASPDeviceCustomerVerificationResponse(customerVerificationData);
        srmCase.SupportingMaterials = GetSupportingMaterial(documentScanningData, customerContractData,acc);
        srmCase.SrmCaseInfoFields = GetCaseInfoFields(acc,oppId);
        if (BranchFunctions.isBusinessProspect(acc.Id))
        {
            srmCase.RelatedParties = GetRelatedParty(acc.Id);
        }
        return srmCase;
    }
    
	/**
	 * @description GetSrmCustomer
	 * @param account 
	 * @return SrmCase.SrmCustomer
	 */
    
    public static SrmCase.SrmCustomer GetSrmCustomer(Account account)
    {
        SrmCase.SrmCustomer srmCustomer = new SrmCase.SrmCustomer();

        String idType = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Identity Type', account.ID_Type__pc, StringConstants.OUTBOUND_RECORD_TYPE);

        srmCustomer.CustomerID = account.CIF__c;
        srmCustomer.CustomerSourceCode = 'CIF';
        srmCustomer.IdType = idType;
        srmCustomer.IdNumber = account.ID_Number__pc;
        srmCustomer.CaseCustomerID = '';

        return srmCustomer;
    }

    /**
	 * @description GetBasicCaseInfo
	 * @param account 
    * @return SrmCase.SrmBasicCaseInfo
	 */
    
    public static SrmCase.SrmBasicCaseInfo GetBasicCaseInfo(Account account)
    {  
        SrmCase srmCase1 = new SrmCase();      
        SrmCase.SrmBasicCaseInfo caseInfo = new SrmCase.SrmBasicCaseInfo();

        string usr = System.UserInfo.getUserId();        
        User userInfo = [SELECT SiteCode__c,Teller_Operator_Code__c,AB_Number__c FROM User WHERE Id = :usr];

        caseInfo.CaseDescription = 'FIC Case';
        caseInfo.OriginatingChannel = 'SF';
        caseInfo.OriginatingSiteCode = userInfo.SiteCode__c;
        caseInfo.ResolutionAreaCode = '';
        caseInfo.ResolutionWorkCategory = 'APPLICATION';
        caseInfo.CaseCategoryCode = 'APPL';
        caseInfo.CaseClassificationType = 'Account Opening';
        caseInfo.CaseClassificationSubType = 'MAINTENANCE';
        caseInfo.CaseResolutionSiteCode = userInfo.SiteCode__c;
        caseInfo.PriorityCode = 'NONE';
        caseInfo.ProductOrServiceArea = '';
        caseInfo.ProductCode = '';
        caseInfo.SensitivityCode = 'N';
        caseInfo.CaseStatusCode = 'Closed';
        caseInfo.CaseResolutionChannel = 'BNCH';
        caseInfo.CaseResolutionPointCode = 'POC';
        caseInfo.CasaRefNumber = account.CASA_Reference_Number__pc;
        caseInfo.CasaSequenceNumber = account.Casa_Sequence_Number__c;
        caseInfo.FicCaseType = 'KYC';
        caseInfo.SbuCode = 'F';
        caseInfo.TellerAbNumber = userInfo.AB_Number__c;
        caseInfo.TransactionType = '';
        caseInfo.CaseClientType = 'I';
        
        if (BranchFunctions.isBusinessProspect(account.Id)) {
            caseInfo.CasaRefNumber = account.CASA_Reference_Number__c;
            caseInfo.CaseClientType = 'B';
            //caseInfo.CasaSequenceNumber = account.Casa_Sequence_Number__c;
        }
        return caseInfo;
    }
    
    /**
	 * @description GetSrmAbsaAgreement
	 * @param oppId
	 * @return List<SrmCase.SrmAbsaAgreement>
	 */
    
    public static List<SrmCase.SrmAbsaAgreement> GetSrmAbsaAgreement(String oppId)
    {
        List<SrmCase.SrmAbsaAgreement> agreements = new List<SrmCase.SrmAbsaAgreement>();
        OpportunityLineItemsSelector oppLineIteminstnce = new OpportunityLineItemsSelector();        
        List<OpportunityLineItem> oppLineItem = oppLineIteminstnce.selectByOpportunityId(oppId);
		
		List<Product2> p = [SELECT Id,ProductCode, Price_Scheme_Code__c FROM Product2 WHERE Id IN (SELECT Product2Id FROM OpportunityLineItem WHERE ProductCode != NULL)];
       
        for(OpportunityLineItem Item : oppLineItem){
            for(Product2 product : p)
            {
                if(Item.Product2Id == product.Id)
                {
                    SrmCase.SrmAbsaAgreement agreement = new SrmCase.SrmAbsaAgreement();                
                    agreement.AbsaReferenceNumber = ASPDeviceCaseController.GetAbsaReferenceNumber(oppId, product.ProductCode, Item.Policy_Number__c);
                    agreement.AbsaReferenceSourceApplCode = 'SF';
                    agreement.AgreementType = 'F'; //F - fulfil for accounts
                    agreement.ProductCode = product.ProductCode;
                    
                    agreements.add(agreement);
                }
            }
        }
        
        return agreements;
    }
    
    /**
	 * @description GetRelatedParty
	 * @param accountId     
     * @return List<SrmCase.RelatedParty>
	 */
    
    public static List<SrmCase.RelatedParty> GetRelatedParty(String accountId)
    {
        List<SrmCase.RelatedParty> relatedParties = new List<SrmCase.RelatedParty>();
        List<AccountContactRelation> accountlist = AccountContactController.getRelatedAccounts(accountId);
        
        for(AccountContactRelation Item : accountlist){
            
            SrmCase.RelatedParty relatedParty = new SrmCase.RelatedParty();                
            relatedParty.IndividualCasaReferenceNumber = '0';
            relatedParty.IndividualCasaSequenceNumber = '0';
            relatedParty.RelatedPartyCasaReferenceNumber = Item.Contact.CASA_Reference_Number__c;
            relatedParty.RelatedPartyCasaSequenceNumber = '0';
            relatedParty.NonConforming = false;
            relatedParty.RelatedPartyId = '0';
            
            SrmCase.RelatedCustomer relatedCustomer = new SrmCase.RelatedCustomer();
            relatedCustomer.CustomerId='';
            relatedCustomer.IdType='';
            relatedCustomer.IdNumber=Item.Contact.ID_Number__c;
            relatedParty.RelatedCustomer = relatedCustomer;
            relatedParties.add(relatedParty);            
        }
        
        return relatedParties;
    }
    
    /**
	 * @description GetAbsaReferenceNumber
	 * @param oppId
     * @param  productCode
     * @param  accountNumber
     * @return GetAbsaReferenceNumber
	 */
    
    public static string GetAbsaReferenceNumber(String oppId, string productCode, string accountNumber)
    {
        if(productCode == 'icc001') {
            List<Application__c> application = [select Account_Number__c from Application__c where Opportunity__c = :oppId];
            if(application.size() > 0){
                return application.get(0).Account_Number__c;
            }
            return 'No CC reference number available';
        }
        return accountNumber;
    }

    /**
	 * @description GetCommunicationInfo
	 * @param account
	 * @return SrmCase.SrmCommunicationInfo
	 */
    public static SrmCase.SrmCommunicationInfo GetCommunicationInfo(Account account)
    {
        SrmCase.SrmCommunicationInfo commInfo = new SrmCase.SrmCommunicationInfo();
        
        String contactTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Contact Method', account.Contact_Method__pc, StringConstants.OUTBOUND_RECORD_TYPE);
        String comMethodTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Preferred Communication Method', account.Preferred_Communication_Method__c, StringConstants.OUTBOUND_RECORD_TYPE);
        Map<string,string> address;
        Address__c adress;
        if (!BranchFunctions.isBusinessProspect(account.Id)) 
        {
            address = BranchCustomerAddressHelper.getAddresses(account.Id, new List<String>{'Residential'});
            adress = [SELECT Id, Address1__c, Address2__c, Address3__c, Shipping_Suburb__c, Shipping_City__c, Shipping_Zip_Postal_Code__c FROM Address__c WHERE Id = :address.Get('Residential')];
        }
        commInfo.ContactMethod = contactTranslated;
        commInfo.CommunicationType = comMethodTranslated;
        commInfo.TelephoneCode = '';
        commInfo.TelephoneNumber = '';
        commInfo.EmailAddress = '';
        if(adress != null)
        {
            commInfo.AddressLine1 = adress.Address1__c;
            commInfo.AddressLine2 = adress.Address2__c;
            commInfo.AddressLine3 = adress.Address3__c;
            commInfo.Suburb = adress.Shipping_Suburb__c;
            commInfo.City = adress.Shipping_City__c;
            commInfo.PostalCode = adress.Shipping_Zip_Postal_Code__c;
        }
        commInfo.FaxCode = '';
        commInfo.FaxNumber = '';

        return commInfo;
    }
    
	/**
	 * @description GetASPDeviceCustomerVerificationResponse
	 * @param customerVerificationData
	 * @return ASPDeviceCustomerVerificationResponse
	 */
    public static ASPDeviceCustomerVerificationResponse GetASPDeviceCustomerVerificationResponse(string customerVerificationData)
    {      
        if(customerVerificationData != null && customerVerificationData != '')
        {
            return (ASPDeviceCustomerVerificationResponse)JSON.deserialize(customerVerificationData, ASPDeviceCustomerVerificationResponse.class);
        }
        else
        {
            ASPDeviceCustomerVerificationResponse deviceCustomerVerificationResponse = new ASPDeviceCustomerVerificationResponse();
            ASPDeviceCustomerVerificationResponse dummyResponseBean = deviceCustomerVerificationResponse.Dummyresponse();
            return dummyResponseBean;
        }
    }
    
	/**
	 * @description GetSupportingMaterial
	 * @param documentScanningData
     * @param customerContractData
     * @param account
	 * @return ASPDeviceDocumentScanningResponse
	 */
    public static ASPDeviceDocumentScanningResponse GetSupportingMaterial(string documentScanningData, string customerContractData,Account account)
    { 
       ASPDeviceDocumentScanningResponse docResponse;       
        if(documentScanningData != null && documentScanningData != '')
        {
            docResponse = (ASPDeviceDocumentScanningResponse)JSON.deserialize(documentScanningData, ASPDeviceDocumentScanningResponse.class);
            
        }
        else
        {
            if (BranchFunctions.isBusinessProspect(account.Id)) 
            {
                docResponse = new ASPDeviceDocumentScanningResponse();
                docResponse.DocumentList = new List<ASPDeviceDocumentScanningResponse.Document>();
                List<Document__c> listDocuments =  [SELECT ECM_Type__c,Reference__c,Case_External_Reference__c,
                                                    Document_Sub_Type__c FROM Document__c 
                                                    WHERE Account__c = :account.Id WITH SECURITY_ENFORCED]; 
                
                for( Document__c itemDocument :listDocuments)
                {
                    ASPDeviceDocumentScanningResponse.Document docResp = new ASPDeviceDocumentScanningResponse.Document();
                    docResp.DocumentCode = itemDocument.Document_Sub_Type__c;
                    docResp.DocumentType = itemDocument.ECM_Type__c;
                    docResp.DocumentSubType = '1';
                    docResp.DocumentGUID = itemDocument.Reference__c;
                    docResp.UploadMSG = 'OK';
                    docResp.ECMPID = itemDocument.Case_External_Reference__c;
                    docResponse.DocumentList.add(docResp);                  
                }   
                
                ASPDeviceDocumentScanningResponse.Document docResp = new ASPDeviceDocumentScanningResponse.Document();
                docResp.DocumentCode = '000038';//itemDocument.Document_Sub_Type__c;
                docResp.DocumentType = 'Ent_ProofOfID';//itemDocument.ECM_Type__c;
                docResp.DocumentSubType = '1';
                docResp.DocumentGUID = 'c9894008-1c04-41f1-a60e-0bb815ff5eda';//itemDocument.Reference__c;
                docResp.UploadMSG = 'OK';
                docResp.ECMPID = '';//itemDocument.Case_External_Reference__c;
                docResponse.DocumentList.add(docResp);  
            }
        }
        
        if(customerContractData != null && customerContractData != '')
        {
            ASPDeviceDocumentScanningResponse.Document contractDoc = (ASPDeviceDocumentScanningResponse.Document)JSON.deserialize(customerContractData, ASPDeviceDocumentScanningResponse.Document.class);            
           if(contractDoc != null)
            {
                    ASPDeviceDocumentScanningResponse.Document doc = new ASPDeviceDocumentScanningResponse.Document();
                    doc.DocumentCode = contractDoc.DocumentCode;
                    doc.DocumentType = contractDoc.DocumentType;
                    doc.DocumentSubType = contractDoc.DocumentSubType;
                    doc.DocumentGUID = contractDoc.DocumentGUID;
                    doc.UploadMSG = contractDoc.UploadMSG;
                    doc.ECMPID = contractDoc.ECMPID;
                    docResponse.DocumentList.add(doc);
            }
        }
        
        return docResponse;
    }
    
	/**
	 * @description GetCaseInfoFields
	 * @param account
	 * @param oppId
	 * @return List<SrmCase.SrmCaseInfoField>
	 */
    public static List<SrmCase.SrmCaseInfoField> GetCaseInfoFields(Account account,String oppId)
    {
        List<SrmCase.SrmCaseInfoField> fields = new List<SrmCase.SrmCaseInfoField>();
        SrmCase.SrmCaseInfoField riskField = new SrmCase.SrmCaseInfoField();
        riskField.CaseInfoFieldDescription = 'CustomerRiskRating';
        riskField.CaseInfoFieldValue = GetCaseRiskRating(account.CASA_Risk_Status__c);
        
		if (BranchFunctions.isBusinessProspect(account.Id)) {
            Opportunity opportunity = [SELECT Risk_Rating__c FROM opportunity where id=:oppId];
            riskField.CaseInfoFieldValue = GetCaseRiskRating(opportunity.Risk_Rating__c);
        }
       
        fields.add(riskField);
        return fields;
    }
    
	/**
	 * @description GetCaseRiskRating
	 * @param rating
	 * @return string
	 */
    public static string GetCaseRiskRating(string rating)
    {
        switch on rating{
            when 'Very Low'{
                return 'VL';
            }
            when 'Low'{
                return 'L';
            }
            when 'Medium'{
                return 'M';
            }
            when 'High'{
                return 'H';
            }
            when 'Very High'{
                return 'VH';
            }
            when else{
                return '';
            }
        }
    }
}