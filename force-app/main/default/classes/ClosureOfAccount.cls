/**
 * @description       : 
 * @author            : mohammedjunaid.usman@absa.africa
 * @last modified on  : 2021-09-27
 * @last modified by  : mohammedjunaid.usman@absa.africa
**/
public class ClosureOfAccount {
    
    /**
    * @description 
    * @author mohammedjunaid.usman@absa.africa | 2021-09-27 
    * @param objectId 
    * @return String 
    **/
    @AuraEnabled
    public static String getExtendedData(string objectId) {
        List<Case> caseRecord = new CasesSelector().selectByCaseId(objectId);
        String extendedData = caseRecord[0].Extended_Request_Data__c;
        if(extendedData == null || extendedData == '' || string.isblank(extendedData) ){
            return null;
        }
        else{
            accountClosure accClosure = new accountClosure();
            accClosure = (accountClosure)JSON.deserialize(extendedData, accountClosure.class);
            return JSON.serialize(accClosure);
        }
    }
    
    /**
    * @description 
    * @author mohammedjunaid.usman@absa.africa | 2021-09-27 
    * @param caseId 
    * @param closedProduct 
    * @param accountHold 
    * @param accountHoldReason 
    * @param debitDetails 
    * @param creditDetails 
    * @param referenceNumber 
    * @param fileName 
    * @param base64Data 
    * @param contentType 
    * @param isFileUploaded 
    * @return string 
    **/
    @AuraEnabled
    public static string upsertAccountClosure(String caseId, String closedProduct, String accountHold, String accountHoldReason, String debitDetails, String creditDetails, String referenceNumber, String fileName, String base64Data, String contentType,Boolean isFileUploaded) {
        try {
            List<Case> caseRec = new CasesSelector().selectByCaseId(caseId);
            Account accRec = new AccountsSelector().selectAllById(caseRec[0].AccountId);
            //system.debug('The Debit details are : '+debitDetails);
            string queueName;
            accountClosure accClosure = new accountClosure();
            accClosure.closedProduct = closedProduct;
            accClosure.accountHold = accountHold;
            accClosure.reasonForHold = accountHoldReason;
            accClosure.debitDetails = (List<journalDetails>)JSON.deserialize(debitDetails, List<journalDetails>.class);
            accClosure.creditDetails = (List<journalDetails>)JSON.deserialize(creditDetails, List<journalDetails>.class);
            accClosure.referenceNumber = referenceNumber;
            String jSONString = JSON.serialize(accClosure);
            List<Group> grp = new List<Group>();
            if(accountHold == 'Yes'){
                if(accRec.Owner.RBB_Super_Region__c == 'Cape'){
                    queueName = 'Service Centre Credit Cape';
                }else if(accRec.Owner.RBB_Super_Region__c == 'Central'){
                    queueName = 'Service Centre Credit Central';
                }else if(accRec.Owner.RBB_Super_Region__c == 'Gauteng & Limpopo'){
                    queueName = 'Service Centre Credit Gauteng & Limpopo';
                }else if(accRec.Owner.RBB_Super_Region__c == 'KwaZulu-Natal &Mpumalanga'){
                    queueName = 'Service Centre Credit KZN & MP';
                }else{
                    queueName = 'Service Centre Credit Central';
                }
               grp = new GroupsSelector().selectByNameType(queueName, 'Queue');}
            else{
                if(accRec.Owner.RBB_Super_Region__c == 'Cape'){
                    queueName = 'Journal SC Cape';
                }else if(accRec.Owner.RBB_Super_Region__c == 'Central'){
                    queueName = 'Journal SC Central';
                }else if(accRec.Owner.RBB_Super_Region__c == 'Gauteng & Limpopo'){
                    queueName = 'Journal SC Gauteng & Limpopo';
                }else if(accRec.Owner.RBB_Super_Region__c == 'KwaZulu-Natal &Mpumalanga'){
                    queueName = 'Journal SC KZN & MP';
                }else{
                    queueName = 'Journal SC Central';
                }
                grp = new GroupsSelector().selectByNameType(queueName, 'Queue');
            }
            if(grp.size()>0 && grp[0].Id != null) {
                caseRec[0].ownerId = grp[0].Id;
                caseRec[0].Extended_Request_Data__c = jSONString;
                update caseRec;
                if(isFileUploaded) {
                    base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
                    Attachment oAttachment = new Attachment();
                    oAttachment.parentId = caseId;
                    oAttachment.Body = EncodingUtil.base64Decode(base64Data);
                    oAttachment.Name = fileName;
                    oAttachment.ContentType = contentType;
                    insert oAttachment;
                }
                return 'SUCCESS';
            }
            else{
                return 'Failed to Assign the case to Queue. Queue not Found' ;
            }
        } catch(Exception e) {
            //System.debug('Exception Occured' + e.getMessage()+'At Line number' + e.getLineNumber());
            throw new AuraHandledException('Something went wrong: ' + e.getMessage());
        }
    }
    /**
* @description Container class that stores the Account Closure Data to be displayed in the UI
*/
    public class accountClosure{
        /**
* @description
*/
        Public String closedProduct{get;set;}
        /**
* @description
*/
        Public String accountHold{get;set;}
        /**
* @description
*/
        Public String reasonForHold{get;set;}
        /**
* @description
*/
        Public List<journalDetails> debitDetails{get;set;}
        /**
* @description
*/
        Public List<journalDetails> creditDetails{get;set;}
        /**
* @description
*/
        Public String referenceNumber{get;set;}
    }
    
    /**
* @description Container class that stores the Journal Details Data to be displayed in the UI
*/
    public class journalDetails{
        /**
* @description
*/
        Public String name{get;set;}
        /**
* @description
*/
        Public String accountNumber{get;set;}
        /**
* @description
*/
        public decimal amount{get;set;}
        /**
* @description
*/
        public integer count{get;set;}
    }

}