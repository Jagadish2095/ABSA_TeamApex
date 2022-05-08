/**
 * @description       : 
 * @author            : muvhuso.nekhubvi@absa.africa
 * @last modified on  : 2021-12-07
 * @last modified by  : muvhuso.nekhubvi@absa.africa
**/

/** 
 *
 * @author  Kamil Rega
 * @since   2021-05-10
 * @description : FIC_Case_OrderDocumentsController
**/
public with sharing class FIC_Case_OrderDocumentsController {

    /**
    * @description  : update
                 *@comment : Update documents
                 *@param id
                 *@param whichTab
                *@param choosenValue
                 *
         **/
    @AuraEnabled
    public static void updateInOrder(String id, String whichTab, Boolean choosenValue) {

        List<Document__c> documents = new List<Document__c>();
        if(Document__c.SObjectType.getDescribe().isAccessible()){
            documents = [SELECT Id, Name, Fic_Document_No_Consent_Reason__c, Is_Fic_Document_Consent__c, Type__c
                                       FROM Document__c
                                       WHERE Case__c =:id];
        }
        List<Document__c> docs = new List<Document__c>();
            for (Document__c doc : documents) {
                    if (doc.Type__c == whichTab) {
                        doc.Is_Fic_Document_Consent__c = choosenValue;
                            docs.add(doc);

                    }
        }
        if( Document__c.SObjectType.getDescribe().isUpdateable()){
        update docs;
        }
    }

    /**
    * @description 
    * @author 
    * @param caseId 
    * @return List<Document__c> 
             **/
    @AuraEnabled
    public static List<Document__c> getDocuments(String caseId) {
        List<Document__c> listOfDocuments = new List<Document__c>();
        if(Document__c.SObjectType.getDescribe().isAccessible()) {
            listOfDocuments = [
                    SELECT Id, Type__c, Name, Fic_Document_No_Consent_Reason__c, Is_Fic_Document_Consent__c
                    FROM Document__c WHERE Case__c =: caseId
            ];
        } else {
            return null;
        }
        /*
        for(Document__c d : listOfDocuments) {
            if(d.Fic_Document_No_Consent_Reason__c == null) {
                d.Fic_Document_No_Consent_Reason__c = 'Permit not certified';
            }
        }*/
        if (!listOfDocuments.isEmpty()) {
            //System.debug(listOfDocuments);
            return listOfDocuments;
        } else {
            throw new ApplicationException('There is no Documents for this case');
        }
    }

    /**
    * @description : getcase
              *@comment : Get Case
              *@return listCases
              *@param caseId
      **/
    @AuraEnabled
    public static Case getCase(String caseId) {
        List<Case> listCases = new List<Case>();
        if(Case.SObjectType.getDescribe().isAccessible()) {
             listCases = [
                    SELECT Type, FiC_Additional_Information__c, Additional_Information__c,
                            Credit_Card_Quotation_In_Order__c, Proof_Of_Income_In_Order__c,Transaction_Type__c,
                            Account_Application_Fail_Reason__c, Credit_Card_Quotation_Fail_Reason__c,
                           Proof_Of_Identification_Fail_Reason__c, Signing_Instructions_Fail_Reason__c,
                            First_Name__c,ClientSurname__c,Customer_ID__c, Birth_Date__c, Nationality__c, Status, Approval_Status__c,
                            FIC_PreviousQueue__c, Owner_Queue_Name__c
                    FROM Case
                    WHERE Id = :caseId
            ];
        } else {
            return null;
        }
        if (!listCases.isEmpty()) {
            return listCases[0];
        } else {
            throw new ApplicationException('There is no Case for this Id');
        }
    }

    /**
    * @description : isUnassignedQueue
              *@comment : get Queue
              *@return isUnassignedQueue
              *@param caseId
      **/
    @AuraEnabled
    public static Boolean isUnassignedQueue(String caseId) {
        Boolean isUnassignedQueue = false;
        Case cas = new Case();
        Group prevQueue = new Group();
        if(Case.SObjectType.getDescribe().isAccessible()) {
            cas = [
                    SELECT FIC_PreviousQueue__c, Owner_Queue_Name__c
                    FROM Case
                    WHERE Id = :caseId
            ];
        }
        if(cas.FIC_PreviousQueue__c!=null && Case.SObjectType.getDescribe().isAccessible()) {
            prevQueue = [SELECT DeveloperName FROM Group WHERE Id =:cas.FIC_PreviousQueue__c ];
        }
         if(prevQueue.DeveloperName == 'New_Request' || prevQueue.DeveloperName == 'Unassigned' || prevQueue.DeveloperName == 'Unassigned_AIC' || prevQueue.DeveloperName == 'FIC_Remediation' || prevQueue.DeveloperName == 'Verification_AIC' ||  
           cas.Owner_Queue_Name__c == 'New Request'|| cas.Owner_Queue_Name__c == 'Unassigned' || cas.Owner_Queue_Name__c == 'Unassigned AIC' ||cas.Owner_Queue_Name__c == 'FIC Remediation' ||cas.Owner_Queue_Name__c == 'Verification AIC'){
            isUnassignedQueue = true;
        }
      //  system.debug('isUnassignedQueue....'+isUnassignedQueue);
       return isUnassignedQueue;
    }
     /**
    * @description 
    * @author 
    * @param docId 
    * @param reason 
    * @param order 
    * @param type 
    *@return
    **/
    @AuraEnabled
    public static String updateDocument(String docId, String reason, Boolean order, String type) {
        String message;
        string jointCIF;
        Document__c document = new Document__c();
        if(Document__c.SObjectType.getDescribe().isAccessible()) {
           document = [
                    SELECT Id, Name , Account__c , Reference__c ,Case__c,File_Id__c,ContentVersionID__c ,Fic_Document_No_Consent_Reason__c, Is_Fic_Document_Consent__c, Type__c , ConfidenceLevel__c
                    FROM Document__c
                    WHERE Id = :docId
            ];
        }
        document.Fic_Document_No_Consent_Reason__c = reason;
        document.Is_Fic_Document_Consent__c = order ;
        document.Type__c = type;

        ContentVersion cv = new ContentVersion();
        String sBody;
        if (Schema.sObjectType.ContentVersion.fields.ContentDocumentId.isAccessible() && !Test.isRunningTest() && document.ConfidenceLevel__c == 'UnKnown') {
                cv = [SELECT id, VersionData,Title,ContentDocumentId FROM ContentVersion WHERE ContentDocumentId =: document.File_Id__c];
                sBody = EncodingUtil.base64Encode(cv.VersionData);
        }
        
        if(order){
          Case caseObjv1 = [select Id , Customer_Type__c,Client_Number__c  from Case where id=:document.Case__c];
          jointCIF = caseObjv1.Customer_Type__c == 'Joints and Several' ? caseObjv1.Client_Number__c : '';

          if(document.ConfidenceLevel__c == 'Low') { 
           CIS_VerifyDocument_IB_Resp_v1 response =  CIS_IH_v1.verifyDocument(document.Reference__c,order);
            if(response.UpdateResult != null){
                if(response.UpdateResult.Status == 'OK'){
                    message = 'Success:' +  response.UpdateResult.Detail;
                    if(type == 'ProofOfId'){
                        updateCIF(jointCIF, 'N','Y', document.Case__c);
                    }else if(type =='ProofOfAddress'){
                        updateCIF(jointCIF, 'U','N', document.Case__c);
                   }
                }
                
            }else{
                    document.Is_Fic_Document_Consent__c = false;
                    message = 'Error: Something went wrong , Document Tracking: No Document Found For PID: ' + document.Reference__c;
             }
          }else if(document.ConfidenceLevel__c == 'UnKnown'){
            Case caseObj = [Select Id, AccountId from Case where Id =:document.Case__c];
            if(caseObj.AccountId != null){
                 Account acc = new AccountsSelector().selectAllById(caseObj.AccountId);
                 CIS_AddDocResult_IB_v1 addDocRequest = CIS_IH_v1.uploadDocument(document.Name , type , null ,acc,'','true', sBody , jointCIF);
                 if(addDocRequest.Pid!=null){
                      document.Reference__c = addDocRequest.Pid;
                      document.Is_Fic_Document_Consent__c = true;
                      message = 'Success: ' + 'Document uploaded to amber successfully';
                      if(type == 'ProofOfId'){
                        updateCIF(jointCIF, 'N','Y', document.Case__c);
                      }else if(type =='ProofOfAddress'){
                        updateCIF(jointCIF, 'U','N', document.Case__c);
                      }
                 }else{
                     document.Reference__c = 'No PID -'+system.now();
                     message = 'Error: ' + 'An error occurred while uploading the document';
                     document.Is_Fic_Document_Consent__c = false;
                 }
            }else{
                   message = 'Error: ' + 'No Account linked to the case';
                   document.Is_Fic_Document_Consent__c = false;
            }
          }

        }
        if( Document__c.SObjectType.getDescribe().isUpdateable()){

           update document;
        }
         else {
            message = 'Error: here is no Case for this Id';
        }
        return message;
    }

    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-11-15 
    * @param accountId 
    * @param docType 
    **/
    public static void updateAccount(String accountId , string docType){
        Account acc = [select Id ,Date_Verified__c ,Date_Identified__c  from Account where Id =:accountId];
        //Account acc = new Account(Id=accountId);
        if(docType == 'ProofOfId'){
           acc.Date_Identified__c = System.Today();
        }else if(docType =='ProofOfAddress'){
           acc.Date_Verified__c = System.Today(); 
        }
        
        update acc;
        
    }
    /**
    * @description  : getpick
              *@comment : get PickList Values Into List
              *@return pickListValuesList
              *@param docName
      **/
    @AuraEnabled
    public static List<String> getPickListValuesIntoList(String docName) {
        List<String> pickListValuesList = new List<String>();
        List<String> failReasons = new List<String>{ '','Permit not certified',
                                                    'No reason for using secondary means of Identification',
                                                    'Surname on ID does not correspond with cif- different surnames/ spelling error',
                                                    'Smart card id 1 side attached', 'No death certificate and id of the executor- split',
                                                    'Birth certificate outstanding', 'Birth Certificate not certified',
                                                    'Guardian ID unclear', 'Date of birth unclear on id document',
                                                     'Primary Customer ID Document Unclear' , 'Primary Customer ID Not Certified',
                                                     'Primary Customer ID Photo Unclear' ,  'Primary Customer ID Outstanding', 'Primary Customer ID Doc Not Barcoded',              
                           'Primary Customer Passport Photo Unclear' , 'Primary Customer Passport Expired', 'Primary Customer Passport Has No Expiry Date',
                           'Id Required If Client Older Than 18 Years','ID Document not compliant','Commissioner Of Oaths Designation Not Stated',
                           'No Documents To Be Acknowledged',                  
                           'Name On Id Does Not Correspond With Cif',           
						   'Related Party/s ID Outstanding',
                           'No Client information on HANIS',
                           'Marriage/ Divorce Certificate Outstanding',    
                           'Reason For Accept Secondary Means Of Id Not Recorded',    
                           'Birth Certificate Outstanding',                     
                           'The Date Of Issue On The I.D. Does Not Correspond', 
                           'Secondary Proof Of Identification Used - No Reason',
                           'Executor Id Outstanding',                          
                           'Executor Id Non Conforming',                        
                           'Documents Not Signed At Amendments',                
                           'Guardians Id Outstanding',                          
                           'Not Parent Or Guardian That Opened The Account',
                            'Absa 3121 Incomplete / Completed Incorrectly', 'Absa 3122 Incomplete / Completed Incorrectly',
                            'Absa 3122 Relationship Not Completed' ,
                            'Absa 3122 Not Certified By Commissioner Of Oath',   
                            'Absa 3122 Not Signed By Client',                    
                            'Absa 3122 Not Signed By Third Party Declarant',     
                            'Absa 3874 Incomplete / Completed Incorrectly',
                            'Application Form Not Accepted As Prf Of Add',       
                            'Cert Of Ownership Not Accepted As Prf Of Add',      
                            'Cif Printout Not Acceptable As Proof Of Address',   
                            'Commissioner Of Oaths Address Not Stated',          
                            'Commissioner Of Oaths Designation Not Stated',      
                            'Delivery Note Not Accepted As Prf Of Add',          
                            'Documents Not Signed At Amendments',                
                            'Executors Proof Of Address Non Conforming',         
                            'Executors Proof Of Address Oustanding',             
                            'Guardians Prf Of Add Outstanding',                  
                            'Lease Agreement - All Pages Not Received',      
                            'Lease Agreement - Has No Residential Address Verified',   
                            'Lease Agreement - Has No Termination Date',           
                            'Lease Agreement - Not Certified On All Pages',        
                            'Lease Agreement Expired',                           
                            'Letter From Employer Non-Compliant',     
                            'Letter From Est Agent Non-Compliant',        
                            'Letter From Municipality Non-Compliant',
                            'Medical Account Not Accepted As Prf Of Add',      
                            'No Documents To Be Acknowledged',                   
                            'No Fsp Number On Prf Of Add',
                            'No Name On Proof Of Address To Verify Client',      
                            'No Ncr Number On Prf Of Add',   
                            'Occupation Letter Not Accepted As Prf Of Add',      
                            'Po Box Not Accepted As Prf Of Add',                    
                            'Postdated Prf Of Add Not Accept', 
                            'Prf Of Add For All Trustees Oustanding',            
                            'Prf Of Add For Declarant (Absa3874) Outstanding',   
                            'Prf Of Add For Executor Outstanding',               
                            'Prf Of Add Not In Business Name',                   
                            'Prf Of Add Not In Guardians Name',                  
                            'Prf Of Add Not In Primary Customers Name',          
                            'Prf Of Add Only In One Clients Name',               
                            'Prim Cust Prf Of Add Not Correspond To Cif',        
                            'Primary Cust Payslip Not Accept As Prf Of Add',        
                            'Primary Customer Prf Of Add Has No Dates To Verify',
                            'Primary Customer Prf Of Add Non Conforming',        
                            'Primary Customer Prf Of Add Not Certified',         
                            'Primary Customer Prf Of Add Older Than 3 Months',   
                            'Primary Customer Prf Of Add Unclear',               
                            'Proof Of Address For Minor Outstanding',            
                            'Proof Of Address For Parent And Minor Non Conformi',
                            'Proof of Address Provided Non-Compliant',
                            'Secondary Prf Of Add Outstanding',
                            'Self Affidavit Not Accepted As Prf Of Add',         
                            'Title Deed Not Accept As Prf Of Add',
                            'Tribal Letter Not Stamped',
                            'Trust Deed Not Certified', 'Documents Not Applicable For Fic Centre',           
                            'Certification Stamp Not According Bus Rules',       
                            'Business Documents Not Certified',                  
                            'Proof Of Student Registration Outstanding',         
                            'Proof Of Student Registration Unacceptable Not',    
                            'Cost Of Course Fees Statement Outstanding',         
                            'Cost Of Course Fees Statement Unacceptable Not',    
                            'Academic Records Results Outstanding',              
                            'Academic Records Results Unacceptable Not Clear',   
                            'Lastest Payslip Is Required',
                            'Employment Confirmation Outstanding',               
                            'Declaration Of Marriage Status Outstanding',        
                            'Application Form Not Signed By Customer',           
                            'Application From Not Signed By Witnesses',
                            'Proof Of Income Is Post Dated',                     
                            'Bank Statement Outstanding',                        
                            'Bank Statement Unacceptable Not Clear',             
                            'Proof Of Income Outstanding',                       
                            'Proof Of Income Unacceptable Not Clear',            
                            'SOF Not Recorded / Recorded Incorrectly',                        
                            'Id & v dated not updated after 29/08/2009 of the fire.',
                            'The wording on the credit card quote is unclear.',
                            'Consultants signature & employee number outstanding on the credit card quote.',
                            'Witness signature & id number outstanding on the credit card quote.',
                            'Credit card quote is incomplete.',
                            'clients still on FIC control listing on option 7',
                            'clients still on FIC control listing on option 7 and soft lock not removed',
                            'latest 3 months proof of  income  not attached.',
                            'Credit card quotation form not attached',
                            'Credit card quotation form not signed', 
                            'Date identified not updated',
                            'Date verified not updated',
                            'client name not on bank statement', 
                            'Clients id number outstanding on the credit card quote'
        };
        List<String> quotationReasons = new List<String>{ 'The wording on the credit card quote is unclear',
                                                    'Consultants signature & employee number outstanding on the credit card quote',
                                                    'Witness signature & id number outstanding on the credit card quote',
                                                    'Credit card quote is incomplete', 'Credit card quotation form not attached',
                                                    'Credit card quotation form not signed', 'Clients id number outstanding on the credit card quote'
        };
        List<String> incomeReasons = new List<String>{ 'Proof Of Income Is Post Dated', 'Proof Of Income Outstanding',
                                                    'Proof Of Income Unacceptable Not Clear', 'latest 3 months proof of  income  not attached',
                                                    'Proof Of Student Registration Outstanding', 'Proof Of Student Registration Unacceptable Not'
        };

        Schema.DescribeFieldResult fieldResult;
        if(docName == 'Credit card quotation'){
            pickListValuesList = quotationReasons;
        } else if(docName == 'Proof of income (latest 3 months)') {
            pickListValuesList = incomeReasons;
        } else {
            pickListValuesList = failReasons;
        }
        return pickListValuesList;
    }
    
    /**
    * @description
    * @author muvhuso.nekhubvi@absa.africa | 2021-07-18
    * @param docId
    * @return String
    **/
    @AuraEnabled
    public static String getDocumentContent(String docId){
        //System.debug('Document Id ------> ' + docId);
        return DocumentController.getDocumentContent(docId);
    }

    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-11-29 
    * @param jointsParentCode 
    * @param idIndicator 
    * @param addIndicator 
    * @param caseId 
    **/
    public static void updateCIF (String jointsParentCode , String idIndicator,String addIndicator , String caseId){
        Case caseObj = [Select Id , AccountId from Case where Id=:caseId];
        getUpdateCIFParser CIFRespBean;
        account acc = new AccountsSelector().selectAllById(caseObj.AccountId);
        CIFRespBean = getUpdateCIF_IH_v1.getCIFResponse(acc, acc.ShippingStreet,'', acc.ShippingState, acc.ShippingCity,acc.ShippingCountry, acc.ShippingPostalCode, addIndicator,idIndicator,acc.Income_Source__pc,acc.Occupation_Status__pc,jointsParentCode);
 }

}