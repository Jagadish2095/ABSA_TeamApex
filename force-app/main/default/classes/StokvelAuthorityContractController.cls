/**
 * @description       :
 * @author            : Khaliq ABdul
 * @group             :   
 * 1.0   14-10-2021   Khaliq ABdul   Initial Version
 **/
public without sharing class StokvelAuthorityContractController 
{
    
    /**
	 * @description Method update Account insertDocumentInformation
	 * @param currentScannedDocuments
     * @param customerContractData
	 * @param accountRecId
	 * @param opportunityId
	 */
	
    @AuraEnabled
	public static void insertDocumentInformation(string currentScannedDocuments,string customerContractData, string accountRecId, string opportunityId) 
    {
        EcmDocuments scannedDocuments = new EcmDocuments();       
        List<Document__c> listDocument = new List<Document__c>();
        
        try {
            if(currentScannedDocuments != null && currentScannedDocuments !='')
            {
                scannedDocuments = EcmDocuments.parse(currentScannedDocuments);                
                Document__c document = new Document__c();
                document.Account__c = accountRecId;
                document.Opportunity__c = opportunityId;
                document.ECM_Type__c =  scannedDocuments.DocumentType;
                document.Reference__c = scannedDocuments.DocumentGUID;
                //document.File_Id__c = documentList.ECMPID;//File_Id__c error toolarge
                document.Case_External_Reference__c = scannedDocuments.ECMPID;
                document.Document_Sub_Type__c = scannedDocuments.DocumentCode;
                listDocument.add(document);                
            }
            if(customerContractData != null && customerContractData !='')
            {
                scannedDocuments = EcmDocuments.parse(customerContractData);                
                Document__c document = new Document__c();
                document.Account__c = accountRecId;
                document.Opportunity__c = opportunityId;
                document.ECM_Type__c =  scannedDocuments.DocumentType;
                document.Reference__c = scannedDocuments.DocumentGUID;
                //document.File_Id__c = documentList.ECMPID;//File_Id__c error toolarge
                document.Case_External_Reference__c = scannedDocuments.ECMPID;
                document.Document_Sub_Type__c = scannedDocuments.DocumentCode;
                listDocument.add(document);                 
            }
            insert listDocument;
        } 
        catch (Exception e) 
        {
            listDocument=null;
        }
    }
    
    /**
	 * @description Method update Account updateOpportunityStage
	 * @param opportunityId
	 */
	
    @AuraEnabled
	public static void updateOpportunityStage(string opportunityId) 
    {
         Opportunity opportunity;
        try {
            opportunity = [
			SELECT ID, StageName,Name,AccountId,closeDate 
			FROM Opportunity
			WHERE id = :opportunityId WITH SECURITY_ENFORCED LIMIT 1];
           List<User> userList = new Usersselector().userwithSiteCode(UserInfo.getUserId());

            opportunity.StageName='Closed Won';
            opportunity.closeDate = System.today();
           	//opportunity.Opportunity_Closed_Date__c = System.now();
            //opportunity.SiteCode__c = userList[0].SiteCode__c;
            update opportunity;
        } 
        catch (Exception e) 
        {
            opportunity=null;
        }
    }
}