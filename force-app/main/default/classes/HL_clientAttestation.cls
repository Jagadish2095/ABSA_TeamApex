/**@description HL_clientAttestation
* @author  Prasanth & Manju V
* @since 2021-05-20
* **/
public with sharing class HL_clientAttestation {
    /***
* @comment : accountRecord
* @description accountRecord    
* **/ 
    @AuraEnabled
    public Account accountRecord{get;set;}
    /***
* @comment : daysdue
* @description : daysdue    
* **/ 
    @AuraEnabled
    public string daysdue {get;set;}
    /***
* @comment : missingDocumentsString    
* @description : missingDocumentsString    
* **/
    @AuraEnabled
    public string missingDocumentsString{get;set;}
    
    /***
* @comment : HL_clientAttestation 
* @description Constructor
* @param accountID   
* @param days
* @param missingDocList
* @return HL_clientAttestation 
* **/  
    @AuraEnabled
    public  static HL_clientAttestation initClientAttestation(string accountID, string days, list<string> missingDocList){
        Map<string, string> docMsgMap = New Map<string, string>{'ProofOfId'=>'Proof Of Identification','ProofOfAddress'=>'Proof Of Address','ProofOfAuthority'=>'Proof Of Authority','ProofOfIncome'=>'Proof Of Income'};
            HL_clientAttestation ca=new HL_clientAttestation();
        if(accountID!=NULL){           
            ca.accountRecord=getAccount(accountID);            
        }
        if(days!=NULL){           
            ca.daysdue=days;
        }
        if(missingDocList!=NULL){
            ca.missingDocumentsString ='';
            for(string dc: missingDocList){
                if(docMsgMap.containsKey(dc)){
                    //ca.missingDocumentsString +='●'+'  '+docMsgMap.get(dc)+'\n';
                    ca.missingDocumentsString +='&#8226; &nbsp; &nbsp; &nbsp;'.unescapeHtml4()+'  '+docMsgMap.get(dc)+'\n';
                }
            }
            ca.missingDocumentsString = ca.missingDocumentsString.removeEnd('\n');
        }
        
        return ca;
    }
    /***
* @comment : missingDocsList
* @description missing Doc List
* @param missingDocList
* @return missingDocsVar    
* **/ 
    @AuraEnabled
    public static string missingDocsList(list<string> missingDocList){
        Map<string, string> docMsgMap = New Map<string, string>{'ProofOfId'=>'Proof Of Identification','ProofOfAddress'=>'Proof Of Address','ProofOfAuthority'=>'Proof Of Authority','ProofOfIncome'=>'Proof Of Income'};
            string missingDocsVar='';
        if(missingDocList!=NULL){
            for(string dc: missingDocList){
                if(docMsgMap.containsKey(dc)){
                    missingDocsVar +=docMsgMap.get(dc)+',';
                }
            }
            missingDocsVar = missingDocsVar.removeEnd(',');
        }
        return missingDocsVar;
    }
    
    /***
* @comment : getAccount
* @description some descr
* @param accountID
* @return account    
* **/    
    @AuraEnabled
    Public static Account getAccount(ID accountID) {
        iF (Account.sObjectType.getDescribe().isAccessible()) {
            Account acc = [Select Id,Stage__c,PersonContactId,PersonContact.Email,Customer_Compliant__c
                           from Account where ID = :accountID LIMIT 1];
            return acc;
        } else {
            return null;
        } 
    }
    
    /*** 
* @comment : updateStage    
* @description update account Stage field
* @param stage 
* @param caInstance
* @param complianceStatus
* @return HL_clientAttestation
* **/
    @AuraEnabled
    public static HL_clientAttestation updateStage(string stage, HL_clientAttestation caInstance,string complianceStatus) {        
        Map<string, string> cmpStsMap = New Map<string, string>{'Compliant'=>'Compliant','NonCompliant'=>'Non Compliant','PartialCompliant'=>'Partial Compliant'};
            If(caInstance.accountRecord!=NULL){                                   
                caInstance.accountRecord.Stage__c = stage;
                if(complianceStatus!=NULL && cmpStsMap.containsKey(complianceStatus)) { 
                    caInstance.accountRecord.Customer_Compliant__c = cmpStsMap.get(complianceStatus);
                }                 
                if(Account.sObjectType.getDescribe().isUpdateable()) {               
                    update caInstance.accountRecord;
                }
            }        
        return caInstance;
    }
    
 
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-11-30 
    * @param emailId 
    * @param caInstance 
    * @param attestationType 
    * @param jointCIF 
    * @return String 
    **/
    @AuraEnabled
    public static String casecreation(string emailId, HL_clientAttestation caInstance,string attestationType,String jointCIF) {
        Id queueId = null;
        string emailTemplateName = getEmailTemplateRecord(caInstance.missingDocumentsString, attestationType);
        
        if(Group.sObjectType.getDescribe().isAccessible()) {
            queueId = [select Id from Group where Name = 'Awaiting Documents'].id;
        }                   
        String jointsCIF = jointCIF != null ? 'Joints and Several' : '';
        Id homeLoansCaseRecordTypeId = Schema.SObjectType.case.getRecordTypeInfosByName().get('Home Loans').getRecordTypeId();
        case newcase = new case(status = 'new', accountId = caInstance.accountRecord.Id, RecordtypeId = homeLoansCaseRecordTypeId,Client_Number__c=jointCIF,
                                OwnerId = queueId,subject = attestationType+' Attestation-Awaiting Home Loan required Documents',Skip_Auto_Response__c=false,
                                ContactId=caInstance.accountRecord.PersonContactId,sd_Communication_Plan_Id__c=NULL,Customer_Type__c = jointsCIF,
                                Email_From_Address__c=emailId,MissingDocuments__c=caInstance.missingDocumentsString,Type='Home Loans', Origin = 'Home Loans',
                                sd_Email_Rule_Template__c = emailTemplateName,sd_Response_Email_Address__c='Ficahelp@absa.co.za');
        
        if(caInstance.daysdue!=NULL){
            newcase.DocumentsSubmissionDueDate__c = System.today().addDays(Integer.valueOf(caInstance.daysdue));
        }
        if(string.isBlank(caInstance.missingDocumentsString) ){
            newcase.MissingDocuments__c='No Documents Required';
        }
        if(emailId==NULL){
            newcase.Email_From_Address__c = caInstance.accountRecord.PersonContact.Email;
        }        
        if (newcase != null && case.sObjectType.getDescribe().isCreateable()) {
            try {                
                insert newcase;                                                
            }catch (exception ex) {
                return 'Error ' + ex;
            }           
        }
        return newcase.id; 
    }
    
    /***
* @method : getEmailTemplateRecord
* @description This method will return the Email template name based on the missing doc type.
* @param missingDocumentsString 
* @param attestationType
* @return emailTemplateName  
**/
    @testVisible 
    private static String getEmailTemplateRecord(String missingDocumentsString,String attestationType) {
        string emailTemplateName = NULL;
        if (missingDocumentsString != null && attestationType=='TELEPHONIC') {
            emailTemplateName ='HL Missing Documents';  
        } else if(attestationType=='EMAIL'){
            emailTemplateName ='HL Email process';
        }                
        return emailTemplateName;
    } 
    
    /**
    * @description  This method will call CIF service to update client attentastion.
    * @author muvhuso.nekhubvi@absa.africa | 2021-11-30 
    * @param accId 
    * @param jointsParentCode 
    **/
    @AuraEnabled
    public static void updateClientAttenstation(id accId,String jointsParentCode){
        updateCIF(accId,jointsParentCode , 'N' , 'N');
         
    }
    
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-11-30 
    * @param accId 
    * @param jointsParentCode 
    * @param addressInd 
    * @param idIndicator 
    **/
    @future(callout=true)
    public static void updateCIF (id accId,String jointsParentCode , String addressInd , String idIndicator){
        getUpdateCIFParser CIFRespBean;
        account acc = new AccountsSelector().selectAllById(accId);
        CIFRespBean = getUpdateCIF_IH_v1.getCIFResponse(acc, '', '', '', '','', '',idIndicator,addressInd,acc.Income_Source__pc,acc.Occupation_Status__pc,jointsParentCode);
    }
    
}