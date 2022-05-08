/**
* @description Extension Controller for OnboardingGenerate CIF Component
*
* @author  Tracy de Bruin : Cloudsmiths
* @version v1.0
* @since   2020-08-14
*
*/
public class OnboardingGenerateCIFController { 

    /**
	 * @description onboarding cvsvalidation service used to validate client and addresses info: By Anka Ganta : 2020-02-06
	 * @param accId
	 * @return map<CvsValidationService_Resp_IB_v1,Sys_Log_Integration__c>
	 */
    @AuraEnabled
    public static map<CvsValidationService_Resp_IB_v1,Sys_Log_Integration__c> cvsValidateClientInfo(String accId){
    Map<CvsValidationService_Resp_IB_v1, Sys_Log_Integration__c> beanToLogMap = new Map<CvsValidationService_Resp_IB_v1, Sys_Log_Integration__c>();   
        
        List<Account> accountP = new AccountsSelector().selectCasaFieldsByIds(accId,1); 
        
        List<Address__c> addressList;
        AddressesSelector addrSelector = new AddressesSelector();
        addressList = addrSelector.addressesRelatedToAcc(accountP[0].Id);
        CvsValidationService_Req_IB_v1 requestBean;
        Sys_Log_Integration__c log = new Sys_Log_Integration__c();
        map<CvsValidationService_Resp_IB_v1,List<Sys_Log_Integration__c>> responseMap = new map<CvsValidationService_Resp_IB_v1,List<Sys_Log_Integration__c>>();
        CvsValidationService_Resp_IB_v1 responseBean = new CvsValidationService_Resp_IB_v1();
        requestBean = CvsValidationService_IU_v1.mapNonIndividualRequestFields(accountP[0],addressList);
        //CvsValidationService
        map<CvsValidationService_Resp_IB_v1,Sys_Log_Integration__c> validateResponseMap = CvsValidationService_IH_v1.validateClientMap(requestBean, false);
        List<CvsValidationService_Resp_IB_v1> cvsValidationBeanList = new List<CvsValidationService_Resp_IB_v1>(validateResponseMap.keySet());
        System.debug('cvsValidationBeanList[0].statusCode'+cvsValidationBeanList[0].statusCode);
        log = validateResponseMap.values()[0];
        beanToLogMap.put(cvsValidationBeanList[0],log);
        return beanToLogMap;   
    }  
    
    
    /**
     * @description Method that gets a an account
     *
     * @param oppId - opportunity Id  
     * @return Account - specific account related to account
     */
    @AuraEnabled
    public static Account getAccountData(Id oppId) {
       
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
        List<Account> accounts = new AccountsSelector().selectCasaFieldsByIds(opportunities[0].AccountId, 1);
        if(accounts.size() > 0 && accounts[0] != null){  
        
        
        if(accounts[0].RecordType.Name == 'Business Client' || accounts[0].RecordType.Name == 'Business Prospect'){
            accounts = new AccountsSelector().selectCasaFieldsJointAccountById(accounts[0].Id,1);
        }
        else if(accounts[0].RecordType.Name == 'Individual Client' || accounts[0].RecordType.Name == 'Individual Prospect'){
            accounts = new AccountsSelector().selectCasaFieldsByIds(accounts[0].Id, 1);
        }
        }
        return accounts[0];
    }
    
    /**
     * @description Method that gets the related party accounts from an account
     *
     * @param oppId - opportunity Id  
     * @return List of Accounts - specific accounts related to the primary account
     */
    @AuraEnabled
    public static List<Account> getPartcicpantAccountData(Id oppId) { 
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
        List<Account> accounts = new AccountsSelector().selectCasaFieldsByIds(opportunities.get(0).AccountId, 1);
        
        List<AccountContactRelation> acrList = [SELECT AccountId, Account.Country_of_Citizenship__c,Account.Country_of_Residence__c,Account.Country_of_Residence__pc,Account.ID_Number__pc,ContactId, account.CASA_Reference_Number__c, Account.CASA_Screening_Date__c, Account.CASA_Screening_Status__c,Account.CASA_Reference_Number__pc, Account.CASA_Screening_Date__pc, Account.CASA_Screening_Status__pc,Account.RecordType.Name,Primary_Entity_Id__c,UBO__c,Account.PEP_Status__pc FROM AccountContactRelation WHERE (Primary_Entity_Id__c =: opportunities.get(0).AccountId AND UBO__c='Yes') OR (AccountId =: opportunities.get(0).AccountId) ];//AccountId
        System.debug('** acrList: ' + acrList.size());
        
        Set<Id> relatedPartIdSet = new Set<Id>();
        for(AccountContactRelation acr : acrList){
            relatedPartIdSet.add(acr.ContactId);
        }
        
        List<Account> rpAccounts = new AccountsSelector().selectCasaFieldsByPersonContactSetId(relatedPartIdSet);
        System.debug('** rpAccounts: ' + rpAccounts.size());
    
        return rpAccounts;
    }
    
    /**
	 * @description TdB - Get Trading as Name details
	 * @param oppId
	 * @return List<Trading_as_Name__c>
	 */    
    @AuraEnabled
    public static List<Trading_as_Name__c> getTradingAsNameData(Id oppId) {
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
        List<Account> accounts = new AccountsSelector().selectCasaFieldsByIds(opportunities.get(0).AccountId, 1);
        
        Set<Id> accIdSets = new Set<Id>();
  
         List<Trading_as_Name__c> tradingAsNameRecords = new List<Trading_as_Name__c>();
        if(accounts != null && accounts.size() > 0) {
            accIdSets.add(accounts[0].id);
            tradingAsNameRecords = new TradingAsNamesSelector().selectByAccountId(accIdSets);
        }
        return tradingAsNameRecords;
    }

    /**
     * @description Method that checks what the Account record type is
     *
     * @param oppId - opportunity Id
     * @return String - account record type i.e. Individual/Business client
     */
    @AuraEnabled
    public static String getAccountRecordType(Id oppId) {
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
        List<Account> accounts = new AccountsSelector().selectCasaFieldsByIds(opportunities.get(0).AccountId, 1);
        if(accounts.size()>0 && accounts[0] !=null) {
        
            if(accounts[0].RecordType.Name != null){
                return accounts.get(0).RecordType.Name;
            }
        }    
        System.debug('record type'+accounts[0].RecordType.Name);
        return accounts[0].RecordType.Name;
       
    }
     /**
     * @description Haritha W-003702
     * @param oppid
     * @param accRecordTypeName
     * @return cifwrappercls
    */
    @AuraEnabled
      public static cifwrappercls callToCreateCIF(Id oppid, String accRecordTypeName){
        cifwrappercls cifAlreadyCreated = new cifwrappercls();
        List<string> message = new List<string>();
        Account accRec;
          List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
        if(accRecordTypeName == 'Client' || accRecordTypeName == 'Prospect') {
            accRec = new AccountsSelector().selectByOpportunityId(oppid);            
        } else {
            accRec = new AccountsSelector().selectIndvByOpportunityId(oppid);
        }       

       //Prevent creating duplicate CIF
        if(accRec.CIF__c != null && !String.isBlank(accRec.CIF__c)){  
           message.add('CIF Already exists for account');            
           cifAlreadyCreated.errormsglist = message;
           return cifAlreadyCreated;
        }
       
        Set<Id> userIds = new Set<Id>();
        userIds.add(UserInfo.getUserId());
        List<User> loggedInUserInfo = new UsersSelector().selectById(userIds); 
        String siteCode = loggedInUserInfo[0].SiteCode__c;
        
        //TdB - W-011878: Call getClientDetails Service to see if Client exist in Salesforce   
        String idTypeTranslated;
        String idRegValue;
        
        if(accRec.Registration_Number__c != null) {
            idTypeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Identity Type', accRec.ID_Type__c, StringConstants.OUTBOUND_RECORD_TYPE);
            String regVal = accRec.Registration_Number__c;
            idRegValue = regVal.replace('/', '');
        } else {
            idTypeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Identity Type', accRec.ID_Type__c, StringConstants.OUTBOUND_RECORD_TYPE);
            idRegValue = accRec.ID_Number__pc;
        }

        Map<GetClientDetailsByIdCIF_Resp_IB_v1, Sys_Log_Integration__c> getClientDetailsByIdMap = GetClientDetailsByIdCIF_IH_v1.getClientDetailsMap(idRegValue, idTypeTranslated ,siteCode);
        List<GetClientDetailsByIdCIF_Resp_IB_v1> getClientDetailsByIdList = new List<GetClientDetailsByIdCIF_Resp_IB_v1>(getClientDetailsByIdMap.keySet());
        Integer loopCounter = 0;
        String duplicateString;

        GetClientDetailsByIdCIF_Resp_IB_v1 getClientDetailsByIdResponseBean = getClientDetailsByIdList[0];
        System.debug('getClientDetailsByIdMap : ' + getClientDetailsByIdMap);
        if(opportunities[0].ExecutionLayerRequestID__c == null && getClientDetailsByIdResponseBean != null && getClientDetailsByIdResponseBean.tblEntry != null) {
            for(GetClientDetailsByIdCIF_Resp_IB_v1.cls_tblEntry eachResult : getClientDetailsByIdResponseBean.tblEntry) {
                String clientTypeVal = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(StringConstants.CIF_STRING, 'Client Type', eachResult.cifClntType , StringConstants.INBOUND_RECORD_TYPE );
				if(clientTypeVal == accRec.Client_Type__c) {
                    loopCounter = loopCounter +1;
                    if(loopCounter == 1) {
                       duplicateString = 'Client already exist in CIF - ' + eachResult.cifKey; 
                    } else {
                       duplicateString = duplicateString + ', ' + eachResult.cifKey; 
                    }      
                }
            }
        }
          if(loopCounter > 0) {
              message.add(duplicateString);     
              cifAlreadyCreated.errormsglist = message;
              insert getClientDetailsByIdMap.values();
              return cifAlreadyCreated;
          }
       map<CreateClientCIF_Resp_IB_v1,Sys_Log_Integration__c> generateCIFBean = new map<CreateClientCIF_Resp_IB_v1,Sys_Log_Integration__c>();
       List<string> reasonlist = new List<string>(); 
       cifwrappercls cifwrpr=new cifwrappercls();
       
       try {
           
           if(accRec.PersonTitle != null){
               String accTitleValue = accRec.PersonTitle;
               String accTitleUpperCaseValue = accTitleValue.toLowerCase().capitalize();
               System.debug('accTitleUpperCaseValue : ' + accTitleUpperCaseValue);
                System.debug('accTitleValue : ' + accTitleValue);
                   
               if(!accTitleUpperCaseValue.contains('.')){
                   accRec.PersonTitle = accTitleUpperCaseValue + '.';
               } else {
                   accRec.PersonTitle = accTitleUpperCaseValue;
               }
           }

           if(accRecordTypeName == 'Client' || accRecordTypeName == 'Prospect') {
                System.debug('In Business CIF');
               generateCIFBean = CreateClientCIF_IH_v1.createBusinessProspectClient(accRec,new List<Account>{},accRec.Id,'Business Prospect','RBB',UserInfo.getUserId(),null,null);
           } else {
               List<String> nonCreditIndicatorList;
               if(accRec.Non_Credit_Marketing_Indicator__pc != null){
                   nonCreditIndicatorList = accRec.Non_Credit_Marketing_Indicator__pc.split(';');
               }
               
               List<String> creditIndicatorList;
               if(accRec.Credit_Marketing_Indicator__pc != null){
                   creditIndicatorList = accRec.Credit_Marketing_Indicator__pc.split(';');
               }
               System.debug('In Individual CIF');
               generateCIFBean.put( CreateClientCIF_IH_v1.createIndividualClient(accRec, 'RBB', accRec.OwnerId, 'Individual Client', nonCreditIndicatorList, creditIndicatorList), null);
           }
           
           system.debug('generateCIFBean'+generateCIFBean);
           String retVal;
           String cifNumber;
           if(generateCIFBean != null && generateCIFBean.size() > 0) {
               for(CreateClientCIF_Resp_IB_v1 resp : generateCIFBean.keySet()){
                   System.debug('resp : ' + resp);
                   if(resp != null && resp.CIcreateClientV12Response != null) {
                       //Success response with CIF No
                       if(resp.StatusCode == 200 && resp.CIcreateClientV12Response.cib003o != null && String.isEmpty(resp.CIcreateClientV12Response.cib003o.outputCkey) == false ) {
                           cifNumber = resp.CIcreateClientV12Response.cib003o.outputCkey;
                           cifwrpr.cifoutput= cifNumber;
                           accRec.CIF__c = cifNumber;
                           
                           if(loggedInUserInfo[0].EmployeeNumber != null) {
                               accRec.Verified_by_Employee_Number__c = loggedInUserInfo[0].EmployeeNumber;
                           } else {
                               accRec.Verified_by_Employee_Number__c = loggedInUserInfo[0].BRID__c;
                           }
                           
                           accRec.Date_Verified__c = System.today(); 
                           /*
                           //START W-004413 - AG-2020-09-14 :Create Business Client and Individual Client records after CIF is successful
                           Map<String, Schema.RecordTypeInfo> accRecordTypeMap = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
                           if (accRec != null && cifNumber != null){
                               if(accRec.RecordType.Name == 'Business Prospect'){
                                   accRec.RecordTypeId = accRecordTypeMap.get('Client').getRecordTypeId();
                               }else if(accRec.RecordType.Name == 'Individual Prospect'){
                                   accRec.RecordTypeId = accRecordTypeMap.get('Individual_Client').getRecordTypeId();
                               }
                           }
                           
                           */
                       } 
                       //Multiple Error responses
                       else if ( resp.CIcreateClientV12Response.nbsmsgo3.msgEntries != null){
																		
                           for(CreateClientCIF_Resp_IB_v1.msgEntry eachError : resp.CIcreateClientV12Response.nbsmsgo3.msgEntries) {
                               if(eachError.msgTxt != null) {
                                   reasonlist.add(eachError.msgTxt);
                               }   
                           }
                           cifwrpr.errormsglist = new List<String>();
                           cifwrpr.errormsglist= reasonlist;
                       } 
                       //Single Error response
                       else if ( resp.CIcreateClientV12Response.nbsmsgo3.msgEntry != null && resp.CIcreateClientV12Response.nbsmsgo3.msgEntry.msgTxt != null) {
																	 
																								
                           reasonlist.add(resp.CIcreateClientV12Response.nbsmsgo3.msgEntry.msgTxt);
                           cifwrpr.errormsglist = new List<String>();
                           cifwrpr.errormsglist= reasonlist;
                       } else {
                           cifwrpr.cifoutputerror = 'An unknown error occurred. Please contact your System Administrator';
                       }
                   } else {
                       
                       //Error on reponse message
                       if (resp != null && resp.message != null) {
                           cifwrpr.cifoutputerror = resp.message;
                       }
                       
                       else {
                           cifwrpr.cifoutputerror = 'An unknown error occurred. Please contact your System Administrator';
                       }
                   }
                   
               }

               update accRec;
               ESP_Onboarded__c espRecord = new ESP_Onboarded__c();
               espRecord.Name = cifNumber;
               espRecord.ClientKey__c = cifNumber;
               insert espRecord;  
               insert getClientDetailsByIdMap.values();
           } else {
               cifwrpr.cifoutputerror = 'An unknown error occurred. Please contact your System Administrator';
           }
           
           
           system.debug('cifwrpr----'+cifwrpr);
           return cifwrpr;
           
       } catch (exception ex) {
           cifwrpr.cifoutputerror = 'An unknown error occurred. Line : ' + ex.getLineNumber() + ' Error: ' + ex;
           system.debug('cifwrpr in catch ----'+cifwrpr);
           return cifwrpr;
       }
   }
    
   /**
     * @description CIF Wrapper class
     */
    public class cifwrappercls {
     /**
     * @description Error message list
     */
     @AuraEnabled 
     public list<String> errormsglist{get;set;}
      /**
     * @description CIF number
     */
     @AuraEnabled  
     public String cifoutput{get;set;}
      /**
     * @description Error message list
     */
     @AuraEnabled  
     public String cifoutputerror{get;set;}
      /**
     * @description Object error message
     */
     @AuraEnabled  
     public String errorObjMsg {get;set;}
      /**
     * @description Update client bean
     */
     @AuraEnabled  
     public ciupdateclientdetailV12_Resp_IB_v1 respBeanUpdateClient {get;set;}
    }

     /**
     * @description TdB - Method that gets Opportunity Details
     *
     * @param oppId - opportunity Id  
     * @return Opportunity - specific opportunity details
     */
    @AuraEnabled
    public static Opportunity getOpportunityData(Id oppId) {
       
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
        
        System.debug('opportunities : ' + opportunities);
        
        if(opportunities != null && opportunities.size() > 0) {
            return opportunities[0];
        } else {
            return null;
        }
        
    }
   
    /**
    * @description Anka Ganta: W-**** : docPack Orchestration
     *  SF make a call to 1. getDocuments service on Jitterbit
     *  Jitterbit make a call to service 2 and 3 internally and give consolidate response.
     * 2. WQconfirmDocumentReceiptV2(CASA Tier 1,2) 
     * 3. WQacknowledgeDocumentsV1 (CASA Tier 3)
     * @param oppId
     * @return String
     */
    @AuraEnabled
    public static String getDocumentsCasaTiers(Id oppId){
            
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
        List<Account> accRecP = new AccountsSelector().selectCasaFieldsById(opportunities.get(0).AccountId, 1);
        GetDocumentsv1_Req_IB_v1 requestBean = new GetDocumentsv1_Req_IB_v1();
        GetDocumentsv1_Req_IB_v1.GetDocsRequest GetDocsRequestbean  = new GetDocumentsv1_Req_IB_v1.GetDocsRequest();
        GetDocumentsv1_Req_IB_v1.RequestMessage RequestMessagebean = new GetDocumentsv1_Req_IB_v1.RequestMessage();
        GetDocumentsv1_Req_IB_v1.Header Headerbean = new GetDocumentsv1_Req_IB_v1.Header();
        GetDocumentsv1_Req_IB_v1.GenerateDocument GenerateDocumentbean = new GetDocumentsv1_Req_IB_v1.GenerateDocument();
        
        Usersselector us = new Usersselector();
        List<User> userP = us.userwithSiteCode(UserInfo.getUserId());
        if(accRecP[0].Client_Group__c == 'Individual' || accRecP[0].Client_Group__c == 'SOLE TRADER CLIENT'){
        GetDocsRequestbean.RefNumber = accRecP[0].CASA_Reference_Number__pc;
        }else{
           GetDocsRequestbean.RefNumber = accRecP[0].CASA_Reference_Number__c; 
        }
        GetDocsRequestbean.SBU = '0';
        GetDocsRequestbean.OriginatingSystem = 'ESP';
        if(userP[0].SiteCode__c != null && userP[0].AB_Number__c != null){
            GetDocsRequestbean.Branch = userP[0].SiteCode__c;
            GetDocsRequestbean.InitialAB = userP[0].AB_Number__c;
        }    
        GetDocsRequestbean.Additional_Docs = ''; 
        RequestMessagebean.GetDocsRequest = GetDocsRequestbean;
        Headerbean.transID = '12344';
        Headerbean.sourceApp = 'Salesforce';
        GenerateDocumentbean.Header = Headerbean;
        GenerateDocumentbean.RequestMessage = RequestMessagebean;
        requestBean.GenerateDocument = GenerateDocumentbean;
        System.debug('requestBean++'+requestBean);
        GetDocumentsv1_IH_v1.getDocuments(requestbean);

        return 'success';
        
    }    
    /**
     * @description Anka Ganta: W-005025 : 
     * 1. Generatedocumentsv7 2. WQconfirmDocumentReceiptV2(CASA Tier 1,2) 
     * 3. WQacknowledgeDocumentsV1 (CASA Tier 3)
     * @ create confirmDocumentReceiptLog(System log of above services) - 
     * @param oppId
     * @return String
     */
     @AuraEnabled
     public static String confirmDocumentReceipt(Id oppId){
            List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
            List<Account> accountP = new AccountsSelector().selectCasaFieldsById(opportunities.get(0).AccountId, 1); 
            //Generic variables 
            List<Sys_Log_Integration__c> confirmDocumentReceiptLog = new List<Sys_Log_Integration__c>();
            //Generatedocumentsv7 related variables
            Map<Generatedocumentsv7_Resp_IB_v1, Sys_Log_Integration__c> Generatedocumentsv7beanToLogMap;
            
            
            Generatedocumentsv7_Resp_IB_v1.Envelope Envelopebean = new Generatedocumentsv7_Resp_IB_v1.Envelope();
            Generatedocumentsv7_Resp_IB_v1.Body Bodybean = new Generatedocumentsv7_Resp_IB_v1.Body();
            Generatedocumentsv7_Resp_IB_v1.GetDocsResponse GetDocsResponsebean = new Generatedocumentsv7_Resp_IB_v1.GetDocsResponse();
            List<Generatedocumentsv7_Resp_IB_v1.Documentation> DocumentationListbean = new List<Generatedocumentsv7_Resp_IB_v1.Documentation>();
             
             //WQconfirmDocumentReceiptV2 related variables
            Map<WQconfirmDocumentReceiptV2_Resp_IB_v1, Sys_Log_Integration__c> WQconfirmDocumentReceiptV2beanToLogMap;
            WQconfirmDocumentReceiptV2_Resp_IB_v1 WQconfirmDocumentReceiptV2RespBean;
            
            //WQacknowledgeDocumentsV1 related variables
            Map<WQacknowledgeDocumentsV1_Resp_IB_v1, Sys_Log_Integration__c> WQacknowledgeDocumentsV1beanToLogMap;
            WQacknowledgeDocumentsV1_Resp_IB_v1 WQacknowledgeDocumentsV1RespBean;

            List<String> docCodeList = new List<String>();
            String docNoP;
            String VersionNoP;
            
            // Calling document hub services starts here
            Generatedocumentsv7beanToLogMap = Generatedocumentsv7_IH_v1.generateDocuments(accountP[0],false);
            System.debug('Generatedocumentsv7beanToLogMap466'+Generatedocumentsv7beanToLogMap);
            
            //Add Generatedocumentsv7 log to  main DocPackServiceLogList Sys log
            if(Generatedocumentsv7beanToLogMap.values().size() >0){
                confirmDocumentReceiptLog.add(Generatedocumentsv7beanToLogMap.values()[0]);
                System.debug('Generatedocumentsv7beanToLogMap values474++'+Generatedocumentsv7beanToLogMap.values()[0]); 
            } 
            System.debug('Generatedocumentsv7beanToLogMap keys489++'+Generatedocumentsv7beanToLogMap.keySet()); 
            // If Generatedocumentsv7 service has valid response 
            if(Generatedocumentsv7beanToLogMap.keySet().size() >0 ){ 
                List<Generatedocumentsv7_Resp_IB_v1> Generatedocumentsv7RespBean = new List<Generatedocumentsv7_Resp_IB_v1>(Generatedocumentsv7beanToLogMap.keySet());
                if(Generatedocumentsv7RespBean[0].StatusCode == 200 && Generatedocumentsv7RespBean[0] != null && !Generatedocumentsv7RespBean.isEmpty() && Generatedocumentsv7RespBean.size() > 0){
                Envelopebean = Generatedocumentsv7RespBean[0].Envelope;
                Bodybean = Envelopebean.Body;
                GetDocsResponsebean = Bodybean.GetDocsResponse;
                System.debug('GetDocsResponsebean++'+GetDocsResponsebean);
                if(GetDocsResponsebean.msgNo == '0' && GetDocsResponsebean.DocNo != '0'){
                    DocumentationListbean = GetDocsResponsebean.documentation;
                    docNoP = GetDocsResponsebean.docNo;
                    VersionNoP = GetDocsResponsebean.VersionNo;
                    System.debug('DocumentationListbean++'+DocumentationListbean);
                    if(!DocumentationListbean.isEmpty() && DocumentationListbean.size() >0 && DocumentationListbean != null){
                        for(Generatedocumentsv7_Resp_IB_v1.Documentation docBean:DocumentationListbean){
                            docCodeList.add(docBean.docCode);
                        }
                    }
                    System.debug('docCodeList++'+docCodeList);
                    
                    if(!docCodeList.isEmpty() && docCodeList.size()>0){
                        try{
                            
                            WQconfirmDocumentReceiptV2beanToLogMap=WQconfirmDocumentReceiptV2_IH_v1.confirmDocumentReceipt(accountP[0],docCodeList,docNoP,VersionNoP,false);
                            if(WQconfirmDocumentReceiptV2beanToLogMap.values().size()>0){
                                confirmDocumentReceiptLog.add(WQconfirmDocumentReceiptV2beanToLogMap.values()[0]);
                                System.debug('WQconfirmDocumentReceiptV2beanToLogMap values512++'+WQconfirmDocumentReceiptV2beanToLogMap.values()[0]);    
                            }
                             WQacknowledgeDocumentsV1beanToLogMap=WQacknowledgeDocumentsV1_IH_v1.acknowledgeDocuments(accountP[0],docCodeList,docNoP,VersionNoP,false);
                            if(WQacknowledgeDocumentsV1beanToLogMap.values().size()>0){
                                confirmDocumentReceiptLog.add(WQacknowledgeDocumentsV1beanToLogMap.values()[0]);
                                System.debug('WQacknowledgeDocumentsV1beanToLogMap values512++'+WQacknowledgeDocumentsV1beanToLogMap.values()[0]);    
                            }
                        }
                        catch(Exception e){
                            throw new AuraHandledException( e.getMessage());
                        }
                    }
                    System.debug('confirmDocumentReceiptLog++'+confirmDocumentReceiptLog);
                }
                else if(GetDocsResponsebean.msgNo == '0' && GetDocsResponsebean.DocNo == '0'){
                    System.debug('docCodeList527++'+docCodeList + '' +GetDocsResponsebean.VersionNo);
                    docNoP = GetDocsResponsebean.docNo;
                    VersionNoP = GetDocsResponsebean.VersionNo;
                          
                    WQconfirmDocumentReceiptV2beanToLogMap=WQconfirmDocumentReceiptV2_IH_v1.confirmDocumentReceipt(accountP[0],docCodeList,docNoP,VersionNoP,false);
                    if(WQconfirmDocumentReceiptV2beanToLogMap.values().size()>0){
                        confirmDocumentReceiptLog.add(WQconfirmDocumentReceiptV2beanToLogMap.values()[0]);
                        System.debug('WQconfirmDocumentReceiptV2beanToLogMap values534++'+WQconfirmDocumentReceiptV2beanToLogMap.values()[0]);    
                    }
                    WQacknowledgeDocumentsV1beanToLogMap=WQacknowledgeDocumentsV1_IH_v1.acknowledgeDocuments(accountP[0],docCodeList,docNoP,VersionNoP,false);
                    if(WQacknowledgeDocumentsV1beanToLogMap.values().size()>0){
                        confirmDocumentReceiptLog.add(WQacknowledgeDocumentsV1beanToLogMap.values()[0]);
                        System.debug('WQacknowledgeDocumentsV1beanToLogMap values512++'+WQacknowledgeDocumentsV1beanToLogMap.values()[0]);    
                    }
                }
                else if(GetDocsResponsebean.msgNo != '0' && GetDocsResponsebean.DocNo == '0'){
                    System.debug('docCodeList527++'+docCodeList + '' +GetDocsResponsebean.VersionNo);
                    docNoP = GetDocsResponsebean.docNo;
                    VersionNoP = GetDocsResponsebean.VersionNo;
                    
                     WQconfirmDocumentReceiptV2beanToLogMap=WQconfirmDocumentReceiptV2_IH_v1.confirmDocumentReceipt(accountP[0],docCodeList,docNoP,VersionNoP,false);
                        if(WQconfirmDocumentReceiptV2beanToLogMap.values().size()>0){
                            confirmDocumentReceiptLog.add(WQconfirmDocumentReceiptV2beanToLogMap.values()[0]);
                            System.debug('WQconfirmDocumentReceiptV2beanToLogMap values534++'+WQconfirmDocumentReceiptV2beanToLogMap.values()[0]);    
                        }
                    WQacknowledgeDocumentsV1beanToLogMap=WQacknowledgeDocumentsV1_IH_v1.acknowledgeDocuments(accountP[0],docCodeList,docNoP,VersionNoP,false);
                    if(WQacknowledgeDocumentsV1beanToLogMap.values().size()>0){
                        confirmDocumentReceiptLog.add(WQacknowledgeDocumentsV1beanToLogMap.values()[0]);
                        System.debug('WQacknowledgeDocumentsV1beanToLogMap values512++'+WQacknowledgeDocumentsV1beanToLogMap.values()[0]);    
                    }
                }
            }  
            }
         if(confirmDocumentReceiptLog.size() > 0 && !confirmDocumentReceiptLog.isEmpty()) {
             insert confirmDocumentReceiptLog;
         }
         
         System.debug('confirmDocumentReceiptLog++'+confirmDocumentReceiptLog.size());
            return 'success';
        }  
    
    /**
     * @description Get Opportunity Products
     * @param oppId
     * @return String
    */
    @AuraEnabled
    public static String getOpportunityProduct(String oppId){
        OpportunityLineItemsSelector oppLineIteminstnce = new OpportunityLineItemsSelector();
        List<OpportunityLineItem> oppLineItem = oppLineIteminstnce.selectByOpportunityId(oppId);
        
        if(oppLineItem.size() > 0 && oppLineItem[0].product2 != null){
                return oppLineItem[0].product2.Name;
        }else return 'undefined';
    }
    
     /**
     * @description Anka Ganta W-005017 : used to get EDD Procees required documents
     * @param opportunityId
     * @return List<String>
    */
    @AuraEnabled
    public static List<String> getDocsByOppId(Id opportunityId) {        
        List<Document__c> docList = new DocumentsSelector().selectDocumentsByOppId(opportunityId);
        Set<String> requiredDocs = new Set<String>();
        for(Document__c doc:docList){
            if(doc.Type__c == StringConstants.EDD_level_ll_report_STRING){
                requiredDocs.add(doc.Type__c);
            }
            if(doc.Type__c == StringConstants.Management_sign_off_STRING){
                requiredDocs.add(doc.Type__c);
            }
            if(doc.Type__c == StringConstants.POS_of_Income_funds_STRING){
                requiredDocs.add(doc.Type__c);
            }
        }
        return new List<String>(requiredDocs) ;
    }

    /**
     * @description Start changes for W-004683 By Himani 
     * @param opportunityId
     * @return List<Opportunity>
    */
    @AuraEnabled
    public static List<Opportunity> getentitytype(Id opportunityId) { 
    list<opportunity> entitytype=[select Entity_Type__c from opportunity where id=:opportunityId limit 1];
    return entitytype;
    }     

    /**
     * @description story :: W-005270 By Himani 
     * Method that gets a list of documents uploaded
     * @Updated by Thulani W-005273
     * @param opportunityId
     * @return List<string>
    */
    @AuraEnabled
    public static List<string> getDocs(Id opportunityId) {
        return DocumentManagementControler.getDocs(opportunityId);
    }
    
    /**
     * @description Mandatory Documents
     * @param Entitytype
     * @return List<Mandatory_Doc__mdt>
    */
     @AuraEnabled
    public static List<Mandatory_Doc__mdt> getAllMandatoryDocuments(string Entitytype) 
    { 
        return DocumentManagementControler.getAllMandatoryDocuments(Entitytype);
    }
    
    /**
     * @description @story :: W-005222 By Masechaba Maseli
     * Method verifies mandatory documents for related parties
     * @param Entitytype
     * @param OppId
     * @return List<String>
    */
      @AuraEnabled
    public static List<String> getAllRelatedMandatoryDocuments(string Entitytype, String OppId) 
    {     
      List<Document__c> docList = new DocumentsSelector().selectDocumentsByOppId(OppId); 
        
      return DocumentManagementControler.getAllRelMandatoryDocuments(Entitytype, OppId, docList);
    
     
    }

   /**
     * @description Update by Thulani  W-005273
     * @param recordId
     * @param docFlag
     * @return List<String>
    */
    @AuraEnabled
    public static List<String> updateOpportunity(String recordId, String docFlag) {      
        return DocumentManagementControler.updateOpportunity(recordId, docFlag);
    }  

    /**
     * @description W-005715 : Anka Ganta : 2020-08-18
     *if any Related party/ TradingAsName / Primary Client CASA status is not 'Approved' or 'Proceed' Stop user to do Risk Profiling
     * @param oppId
     * @return Boolean
    */
     @AuraEnabled
    public static Boolean CheckRelatedPartyCasaStatus(Id oppId) { 
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
        List<Account> accounts = new AccountsSelector().selectCasaFieldsById(opportunities.get(0).AccountId, 1);
        Set<Id> accIdSets = new Set<Id>();
        accIdSets.add(accounts[0].id);
        
        List<Account> participants = new AccountContactRelationSelector().selectListByAccId(opportunities.get(0).AccountId);
        List<Trading_as_Name__c> tradingAsNameRecords = new TradingAsNamesSelector().selectByAccountId(accIdSets);
        List<String> participantStatuses = new List<String>();
        if(participants != null && participants.size() > 0) {
            for(Account participant : participants){
                participantStatuses.add(participant.CASA_Screening_Status__pc);
                System.debug('participant Id++'+participant.Id);
            }    
        }
        if(tradingAsNameRecords != null && tradingAsNameRecords.size() > 0) {
            for(Trading_as_Name__c eachTradingName : tradingAsNameRecords) {
                participantStatuses.add(eachTradingName.CASA_Screening_Status__c);
            }
        }
        if(accounts.get(0).CASA_Screening_Status__c != null){
            participantStatuses.add(accounts.get(0).CASA_Screening_Status__c);
        }else{
            participantStatuses.add(accounts.get(0).CASA_Screening_Status__pc);
        }
        
        System.debug('participantStatuses++'+participantStatuses);
        // if Related party status is not 'Approved' or 'Proceed'  Stop user to do Risk Profiling
        Boolean relPartyInvalidStatusFlag = false;
        for(String status : participantStatuses){
            if(status == 'Matched'){
                relPartyInvalidStatusFlag = true;
                break;
            }else if(status == 'Pending'){
                relPartyInvalidStatusFlag = true;
                break;
            }else if(status == 'Declined'){
                relPartyInvalidStatusFlag = true;
                break;
            }else if(status == 'Cancelled'){
                relPartyInvalidStatusFlag = true;
                break;
            }
        }
        System.debug('relPartyInvalidStatusFlag++'+relPartyInvalidStatusFlag); 
        return relPartyInvalidStatusFlag;
        
   }   

   /**
     * @description W-005661 - Anka Ganta- 2020-09-18 -Validate Primay Client Documents to each Entity : Private Company / Close Corporation /Trusts
     * make Resolution document optional based on Roles
     * if any Related party/ TradingAsName / Primary Client CASA status is not 'Approved' or 'Proceed' Stop user to do Risk Profiling
     * @param Entitytype
     * @param OppId
     * @return List<String>
    */
    @AuraEnabled
    public static List<String> getPrimaryClientMandatoryDocuments(String Entitytype, String OppId){
      return DocumentManagementControler.getPrimaryClientMandatoryDocuments(Entitytype, OppId);
         }    

     /**
     * @description TdB - Sureties Onboarding - Call getClientDetails and updateClientDetails to update Liability indicator
     * @param oppId
     * @param accRecordTypeName
     * @return ciupdateclientdetailV12_Resp_IB_v1
    */
    @AuraEnabled
    public static ciupdateclientdetailV12_Resp_IB_v1 updateClientDetailsCIF(Id oppId, String accRecordTypeName){
        
        Account accRec;
        String siteCode;
        if(accRecordTypeName == 'Client' || accRecordTypeName == 'Prospect') {
            accRec = new AccountsSelector().selectByOpportunityId(oppid);            
        } else {
            accRec = new AccountsSelector().selectIndvByOpportunityId(oppid);
        }
        
        Set<Id> userIds = new Set<Id>();
        userIds.add(UserInfo.getUserId());
        List<User> loggedInUserInfo = new UsersSelector().selectById(userIds); 
        siteCode = loggedInUserInfo[0].SiteCode__c;
        
        //Call CIGetClientDetailsCIF Service
        GetClientDetailsCIF_Resp_IB_v1 respBeanGetClient = new GetClientDetailsCIF_Resp_IB_v1();
        respBeanGetClient = GetClientDetailsCIF_IH_v1.getClientDetails(accRec.CIF__c,'0',siteCode, false);
        
        String respBeanGetClientString = JSON.serialize(respBeanGetClient);
        System.debug('respBeanGetClientString : ' + respBeanGetClient.liabilityIndicator);
        List<Address__c> addressList = new AddressesSelector().addressesRelatedToAcc(accRec.Id);  
        
        //Call CIUpdateClientDetailsCIF Service
        ciupdateclientdetailV12_Resp_IB_v1 respBeanUpdateClient = new ciupdateclientdetailV12_Resp_IB_v1();
        respBeanUpdateClient =  ciupdateclientdetailV12_IH_v1.ciupdateclientdetailv12Onboarding(accRec,addressList,siteCode,respBeanGetClient);
        return respBeanUpdateClient; 

    }

    /**
     * @description Anka Ganta - W-006976 - Remediate Existing Customer Onboarding - Call getClientDetails and updateClientDetails to update Client details
     * @param oppId
     * @param accRecordTypeName
     * @return cifwrappercls
    */
    @AuraEnabled
    public static cifwrappercls updateCIFRemediate(Id oppId, String accRecordTypeName){
        
        Account accRec;
        String siteCode;
        cifwrappercls cifwrpr=new cifwrappercls();
        
        List<String> reasonList = new List<String>();
        if(accRecordTypeName == 'Client' || accRecordTypeName == 'Prospect') {
            accRec = new AccountsSelector().selectByOpportunityId(oppid);            
        } else {
            accRec = new AccountsSelector().selectIndvByOpportunityId(oppid);
        }
        Set<Id> userIds = new Set<Id>();
        userIds.add(UserInfo.getUserId());
        List<User> loggedInUserInfo = new UsersSelector().selectById(userIds); 
        siteCode = loggedInUserInfo[0].SiteCode__c;
        
        //Call CIGetClientDetailsCIF Service
        GetClientDetailsCIF_Resp_IB_v1 respBeanGetClient = new GetClientDetailsCIF_Resp_IB_v1();
        respBeanGetClient = GetClientDetailsCIF_IH_v1.getClientDetails(accRec.CIF__c,'0',siteCode, false);
        String respBeanGetClientString = JSON.serialize(respBeanGetClient);
        System.debug('respBeanGetClientString : ' + respBeanGetClient.liabilityIndicator);
        List<Address__c> addressList = new AddressesSelector().addressesRelatedToAcc(accRec.Id);  
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId,1);
        //Call CIUpdateClientDetailsCIF Service
        ciupdateclientdetailV12_Resp_IB_v1 respBeanUpdateClient = new ciupdateclientdetailV12_Resp_IB_v1();
        map<ciupdateclientdetailV12_Resp_IB_v1,Sys_Log_Integration__c>  respBeanUpdateClientMap= new map<ciupdateclientdetailV12_Resp_IB_v1,Sys_Log_Integration__c>();
        
        List<Integration_Translation__c> translation = [SELECT Direction__c, External_Value__c, System_Name__c, Value_Type__c ,Internal_Value__c 
                                                        FROM Integration_Translation__c 
                                                        WHERE Direction__c = :'Outbound' 
                                                        AND (System_Name__c =:'CIF'
                                                             OR System_Name__c =:'eCasa')];
        
        Map<String,String> translations = new Map<String,String>();
        for(Integration_Translation__c translatedVars: translation ){ 
            String mapKey = translatedVars.External_Value__c+''+translatedVars.System_Name__c+''+translatedVars.Value_Type__c+''+translatedVars.Direction__c;
            String mapKey1 = translatedVars.Internal_value__c+''+translatedVars.System_Name__c+''+translatedVars.Value_Type__c+''+translatedVars.Direction__c;
            translations.put(mapKey, translatedVars.Internal_value__c); 
            translations.put(mapKey1, translatedVars.External_Value__c); }
        User usr = [Select Id, EmployeeNumber from User where Id =:UserInfo.getUserId() LIMIT 1];
        System.debug('process type----'+opportunities.get(0).Process_Type__c + ' ' + usr.EmployeeNumber);
        CvsValidationService_Req_IB_v1 cvsValidateBean = new CvsValidationService_Req_IB_v1();
        Map<String, String> translationMap = CreateClientCIF_IH_v1.getTranslations(accRec, addressList);
        //if (opportunities.get(0).Process_Type__c == 'Remediate Existing Customer') {
        // call cvs validation service
        map<CvsValidationService_Resp_IB_v1,Sys_Log_Integration__c> cvsResponseBeanMap;
        if(accRec.Client_Group__c == 'Non Individual') {
            cvsResponseBeanMap = OnboardingGenerateCIFController.cvsValidateClientInfo(accRec.Id);
        }else if(accRec.Client_Group__c == 'SOLE TRADER CLIENT'){
            //Call Validate Method (cvsValidate & ValidateAddress)
            cvsValidateBean = CvsValidationService_IU_v1.mapRBBIndividualRequestFields(accRec, addressList, 'S', translationMap);
            cvsResponseBeanMap = CvsValidationService_IH_v1.validateClientMap(cvsValidateBean, false);  
        } else if(accRec.Client_Group__c == 'Individual'){
            //Call Validate Method (cvsValidate & ValidateAddress)
            cvsValidateBean = CvsValidationService_IU_v1.mapRBBIndividualRequestFields(accRec, addressList, 'I', translationMap);
            cvsResponseBeanMap = CvsValidationService_IH_v1.validateClientMap(cvsValidateBean, false);  
        }  
        List<CvsValidationService_Resp_IB_v1> cvsResponseBeanList = new List<CvsValidationService_Resp_IB_v1>(cvsResponseBeanMap.keySet());  
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        logList.add(cvsResponseBeanMap.values()[0]); 
        CvsValidationService_Resp_IB_v1 cvsResponseBean = new CvsValidationService_Resp_IB_v1();
        cvsResponseBean = cvsResponseBeanList[0];
        List<CvsValidationService_Resp_IB_v1.cls_Error> errorListbean = new List<CvsValidationService_Resp_IB_v1.cls_Error>();
        CvsValidationService_Resp_IB_v1.cls_Error errorobjbean = new CvsValidationService_Resp_IB_v1.cls_Error();
        CvsValidationService_Resp_IB_v1.cls_StatusMessage StatusMessagebean = new CvsValidationService_Resp_IB_v1.cls_StatusMessage();
        //Call ciupdateclientdetail service on cvs validation success
        if(cvsResponseBean.statusCode == 200 && cvsResponseBean.valStatusCode == '0'){
            //if(cvsResponseBean.statusCode == 200 ){
            respBeanUpdateClientMap = ciupdateclientdetailV12_IH_v1.ciUpdateRemediateCustomer(accRec, addressList, translations ,accRec.Client_Type__c, siteCode,usr.EmployeeNumber,respBeanGetClient);
            List<ciupdateclientdetailV12_Resp_IB_v1> respBeanUpdateClientList = new List<ciupdateclientdetailV12_Resp_IB_v1>(respBeanUpdateClientMap.keySet()); 
            respBeanUpdateClient = respBeanUpdateClientList[0];
            ciupdateclientdetailV12_Resp_IB_v1.CIupdateClientDetailV12Response CIupdateClientDetailV12ResponseBean = new ciupdateclientdetailV12_Resp_IB_v1.CIupdateClientDetailV12Response();
            ciupdateclientdetailV12_Resp_IB_v1.Nbsapdpo Nbsapdpobean = new ciupdateclientdetailV12_Resp_IB_v1.Nbsapdpo();
            ciupdateclientdetailV12_Resp_IB_v1.Nbsmsgo3 Nbsmsgo3Bean = new ciupdateclientdetailV12_Resp_IB_v1.Nbsmsgo3();
            ciupdateclientdetailV12_Resp_IB_v1.Cib004o Cib004oBean = new ciupdateclientdetailV12_Resp_IB_v1.Cib004o();
            ciupdateclientdetailV12_Resp_IB_v1.MsgEntry MsgEntryBean = new ciupdateclientdetailV12_Resp_IB_v1.MsgEntry();
            List<ciupdateclientdetailV12_Resp_IB_v1.MsgEntry> MsgEntryBeanList = new List<ciupdateclientdetailV12_Resp_IB_v1.MsgEntry>();
            
            CIupdateClientDetailV12ResponseBean =  respBeanUpdateClient.CIupdateClientDetailV12Response ;
            Cib004oBean = CIupdateClientDetailV12ResponseBean.Cib004o;
            if(Cib004oBean.retCode != '0'){
                Nbsmsgo3Bean = CIupdateClientDetailV12ResponseBean.Nbsmsgo3;
                MsgEntryBeanList = Nbsmsgo3Bean.msgEntry;
                for(ciupdateclientdetailV12_Resp_IB_v1.MsgEntry MsgEntryItem : MsgEntryBeanList){
                    reasonlist.add(MsgEntryItem.msgTxt);
                }
                
            }
        }else if(cvsResponseBean.statusCode == 200 && cvsResponseBean.valStatusCode != '0'){
            StatusMessagebean = cvsResponseBean.statusMessage;
            errorListbean = StatusMessagebean.error;
            errorobjbean = StatusMessagebean.errorObj;
            if(errorListbean != null){   
                for(CvsValidationService_Resp_IB_v1.cls_Error errorbean:errorListbean){
                    reasonList.add(errorbean.reason);
                }
            }
            if(errorobjbean != null){
                reasonlist.add(errorobjbean.reason);
                if(errorobjbean.reasonList != null) {
                    for(String str:errorobjbean.reasonList){
                        reasonlist.add(str); 
                    }
                }  
            }
            
        }
        cifwrpr.errormsglist = new List<String>();
        cifwrpr.errormsglist= reasonlist;
        if(respBeanUpdateClientMap.values().size() > 0 && !respBeanUpdateClientMap.values().isEmpty()){
            logList.add(respBeanUpdateClientMap.values()[0]);
        }
        
        if(logList.size() >0 && !logList.isEmpty()){
            insert logList;
        }
        //}    
        System.debug('#####' + respBeanUpdateClient.serialize(respBeanUpdateClient) + '#####');
        System.debug('cifwrpr--'+cifwrpr.errormsglist);
        return cifwrpr;
    }
}