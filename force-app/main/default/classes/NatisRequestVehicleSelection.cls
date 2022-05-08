/**
* Retrieve and list all the Natis documentation for a secific client
*
* @author  Rudolf Niehaus : CloudSmiths
* @since   2020-02-09
*
**/
public class NatisRequestVehicleSelection {
    
    
    @AuraEnabled
    public static Map<String, List<String>> getNatisDocs(String accId){

        Map<String, List<String>> docMap = new  Map<String, List<String>>();

        String token = login();
        //String cif = 'bboys001';
        String cif = getCIF(accId);

        ECM_QueryRequest request = new ECM_QueryRequest();
        request.QueryRequest = new ECM_QueryRequest.QueryRequest();
        request.QueryRequest.Token = token;
        request.QueryRequest.Query = '/NATISDoc[@CIFNr = \"' + cif + '\"]';

        ECM_QueryResult res = ECM_IH_V1.query(request);

        if(res != NULL){
            
            try {
                
                for(ECM_QueryResult.Document doc : res.Documents.document) {
                    
                    List<String> docInfo = new List<String>();

                    ECM_GetResult_IB_V1 getResult = ECM_IH_V1.getDocument(token, doc.PID);    

                    docInfo.add(doc.getField('VehRegNr'));
                    docInfo.add(doc.getField('VINNr'));
                    docInfo.add(doc.getField('AcctNr'));
                    docInfo.add('0.00');
                    docMap.put(doc.PID, docInfo);
    

                }

            } catch (Exception ex) {
                throw ex;
            }
        }

        return docMap;
        
    }

    @AuraEnabled
    public static String sendNatisDocs(String[] docList, String emailAddress, Id caseRecordId){

        String returnString = 'success';

        if(docList.size() > 0){
               
            String token = login();
            List<Attachment> attachmentList = new List<Attachment>();

            for(String pid : docList){

                List<String> attName = pid.split(' ');
            
                ECM_GetResult_IB_V1 getResult = ECM_IH_V1.getDocument(token, pid);

                Attachment attach = new Attachment();

                attach.contentType = 'application/pdf';
                attach.name = attName[7] + '.pdf';

                
                if(!Test.isRunningTest()){
                    attach.body = EncodingUtil.base64Decode(getResult.Content.data);
                }else{ 
                    attach.body = blob.valueOf('Test Result Body');
                }

                attachmentList.add(attach);
            }

            

            try{   
                
                Case currentCase = [SELECT Id, CaseNumber, AccountId, Account.Name FROM Case WHERE Id =: caseRecordId];
                
                String contactId = [Select PersonContactId From Account Where Id = :currentCase.AccountId].PersonContactId;

                if( String.isNotBlank(contactId) ){

                    Contact con = [Select Email From Contact Where Id =:contactId];

                    if(String.isBlank(con.email)){
                        
                        con.email = emailAddress;

                        try{
                            update con;
                        }catch(DMLException ex){
                            throw ex;
                        }
                    }

                }else{
                    
                    List<Contact> contList = [Select Id, Email From Contact Where Email = :emailAddress and AccountId = :currentCase.AccountId];

                    if(contList.size() > 0){

                        if(String.isBlank( contList[0].Email )){
                            
                            contList[0].Email = emailAddress;

                            try{
                                update contList[0];
                            }catch(DmlException ex){
                                throw ex;
                            }
                        }

                        contactId = contList[0].Id;

                    }else{

                        String[] contNames = emailAddress.split('@');

                        Contact newCon = new Contact();
                        newCon.Email = emailAddress;
                        newCon.LastName = contNames[0];
                        newCon.AccountId = currentCase.AccountId;

                        try{

                            insert newCon;
                            contactId = newCon.Id;

                        }catch(DmlException ex){

                            throw ex;
                        }
                    }

                }

                List<Messaging.SingleEmailMessage> constructEmail = EmailHandler.ComposeEmail(caseRecordId, contactId, emailAddress,'Natis_Request');
                Messaging.SingleEmailMessage email = constructEmail.get(0);
                
                String htmlBody = email.getPlainTextBody();
                
                htmlBody = htmlBody.replace('{!Case.CaseNumber}', currentCase.CaseNumber).replace('{!Case.ClientName__c}', currentCase.Account.Name);
                email.setPlainTextBody(htmlBody);

                sendEmailwithPDFAttachments(email, emailAddress,email.getHTMLBody(),attachmentList);
                
            }catch(exception ex){
                system.debug(ex);
                system.debug(ex.getMessage());
                returnString = '' + ex.getMessage();
                throw ex;
            }

        }

        try{
            
            if(caseRecordId!=null){
                Case caseObj = new Case(Id=caseRecordId);
                caseObj.Email__c = emailAddress;
                caseObj.Status = 'Closed';
                Update caseObj;
            }

        }catch(DmlException ex){
            throw ex;
        }
 
        return returnString;

    }
    
    private static void sendEmailwithPDFAttachments(Messaging.SingleEmailMessage constructEmail, String emailAddress, string emailBody, List<Attachment> attachmentList ){
        
        List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
        
        for(Attachment attach: attachmentList ){
            Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
            efa.setFileName(attach.Name);
            efa.setBody(attach.Body);
            fileAttachments.add(efa);
        }
        
        Set<String> orgemailaddress=new Set<String>();
        
        orgemailaddress.add('businessbanking@absa.africa');

        List<OrgWideEmailAddress> orgwideaddress=new OrgWideEmailAddressesSelector().selectByAddress(orgemailaddress);
        
        if(!orgwideaddress.isEmpty()){
            constructEmail.setOrgWideEmailAddressId(orgwideaddress[0].Id);
        }
        
        constructEmail.setFileAttachments(fileAttachments);
        constructEmail.setSaveAsActivity(true);
        
        System.debug('RN## To Addresses : ' + constructEmail.getToAddresses());
        
        try{
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { constructEmail });
        }catch(exception e){
            apexpages.addmessage(new apexpages.message(apexpages.severity.error,e.getMessage()));
        }
    }

    private static String login(){

        Map<String, String> credentials = ECM_IH_V1.getCredentials();
        ECM_LoginResult_IB_V1 login = ECM_IH_V1.login(credentials.get('store'), credentials.get('username'), credentials.get('password'));

        return login.Token;
    }

    private static String getCIF(String accId){

        Set<Id> ids = new Set<Id>();
        ids.add(accId);

        List<Account> acc = new AccountsSelector().selectById(ids);

        if(acc.size() > 0){
            return acc[0].CIF__c;
        }else{
            return '';
        }

    }
}