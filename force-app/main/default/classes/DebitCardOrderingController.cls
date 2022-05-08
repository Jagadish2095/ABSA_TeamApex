/*
* Extension Controller for DebitCardOrderingController
*
* @author  Tracy de Bruin
* @version v1.0
* @since   2020-08-06
*
*/

public class DebitCardOrderingController {
    
    //TdB - Method to call CVS and CIF to create MINI CIF
    @AuraEnabled
    public static cifwrappercls createCIFMiniClient(Id accId) {
        
        map<CreateClientCIF_Resp_IB_v1,Sys_Log_Integration__c> generateCIFBean = new map<CreateClientCIF_Resp_IB_v1,Sys_Log_Integration__c>();
        List<string> reasonlist = new List<string>(); 
        cifwrappercls cifwrpr=new cifwrappercls();
        String retVal;
        
        try {   
            Account accRec = new AccountsSelector().selectByIdForIndividual(accId);        
            
            //Call to create Individual in CIF
            generateCIFBean.put( CreateClientCIF_IH_v1.createMiniIndividualClient(accRec, 'RBB Mini', accRec.OwnerId, 'Individual Client', null, null), null);
            system.debug('generateCIFBean'+generateCIFBean);
            
            if(generateCIFBean != null && generateCIFBean.size() > 0) {
                for(CreateClientCIF_Resp_IB_v1 resp : generateCIFBean.keySet()){
                    if(resp != null && resp.CIcreateClientV12Response != null) {
                        //Success response with CIF No
                        if(resp.StatusCode == 200 && resp.CIcreateClientV12Response.cib003o != null && String.isEmpty(resp.CIcreateClientV12Response.cib003o.outputCkey) == false ) {
                            String cifNumber = resp.CIcreateClientV12Response.cib003o.outputCkey;
                            cifwrpr.cifoutput= cifNumber;
                            accRec.CIF__c = cifNumber;
                            
                            //Get logged in User Brid to populate ID&V
                            Set<Id> userIds = new Set<Id>();
                            userIds.add(UserInfo.getUserId());
                            List<User> loggedInUserInfo = new UsersSelector().selectById(userIds);  
                            
                            if(loggedInUserInfo[0].EmployeeNumber != null) {
                                accRec.Verified_by_Employee_Number__c = loggedInUserInfo[0].EmployeeNumber;
                            } else {
                                accRec.Verified_by_Employee_Number__c = loggedInUserInfo[0].BRID__c;
                            }
                            
                            accRec.Date_Verified__c = System.today();
                            
                            update accRec;
                        } 
                        //Multiple Error responses
                        else if (resp.CIcreateClientV12Response.nbsmsgo3.msgEntries != null && resp.CIcreateClientV12Response.nbsmsgo3.msgEntry != null){
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
    
    public class cifwrappercls {
     @AuraEnabled public list<String> errormsglist{get;set;}
     @AuraEnabled  public String cifoutput{get;set;}
     @AuraEnabled  public String cifoutputerror{get;set;}
     @AuraEnabled  public String errorObjMsg {get;set;}
    }
        
    //added by Mbuyiseni: Get related party details
    @AuraEnabled
    public static List<Map<String, Object>> getRelatedParties(Id oppId) {
        List<Map<String,Object>> listParties = new List<Map<String,Object>>();
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
        List<Account> accounts = new AccountsSelector().selectCasaFieldsByIds(opportunities.get(0).AccountId, 1);
        
        List<AccountContactRelation> acrList = [SELECT AccountId, Account.Country_of_Citizenship__c,Account.Country_of_Residence__c,Account.Country_of_Residence__pc,Account.ID_Number__pc,ContactId, account.CASA_Reference_Number__c, Account.CASA_Screening_Date__c, Account.CASA_Screening_Status__c,Account.CASA_Reference_Number__pc, Account.CASA_Screening_Date__pc, Account.CASA_Screening_Status__pc,Account.RecordType.Name,Primary_Entity_Id__c,UBO__c FROM AccountContactRelation WHERE (Primary_Entity_Id__c =: opportunities.get(0).AccountId AND UBO__c='Yes') OR (AccountId =: opportunities.get(0).AccountId) ];//AccountId
        System.debug('** acrList: ' + acrList.size());
        
        Set<Id> relatedPartIdSet = new Set<Id>();
        
                if(!acrList.isEmpty() && acrList.size() > 0){
                    
                    for(AccountContactRelation acr : acrList){
                        relatedPartIdSet.add(acr.ContactId);
                    }
                    
                }else{
                    
                    relatedPartIdSet.add(accounts.get(0).PersonContactId);
                }
        
        System.debug('Person Account : '+ accounts.get(0).PersonContactId);
        List<Account> rpAccounts = new AccountsSelector().selectCasaFieldsByPersonContactSetIds(relatedPartIdSet);
        System.debug('** rpAccounts: ' + rpAccounts.size());
        
        if(rpAccounts != null && rpAccounts.size() > 0) {
            
            for(Account accnRel : rpAccounts) {
                Map<String,Object> mapObj = new Map<String,Object>();   
                mapObj.put('Id', accnRel.Id);
                mapObj.put('Name', accnRel.FirstName + ' '+accnRel.LastName);
                mapObj.put('FirstName', accnRel.FirstName);
                mapObj.put('LastName', accnRel.LastName);
                mapObj.put('CIF', accnRel.CIF__c);
                mapObj.put('IDType', accnRel.ID_Type__pc);
                mapObj.put('IDNumber', accnRel.ID_Number__pc);
                mapObj.put('PassportNumber', accnRel.Passport_Number__pc);
                mapObj.put('Title', accnRel.PersonTitle);
                mapObj.put('Initials', accnRel.Initials__pc);
                mapObj.put('ClientType', accnRel.Client_Type__c);
                listParties.add(mapObj);
            }
        }
        
        return listParties;
    }
    
    
    //added by Mbuyiseni
    @AuraEnabled
    public static List<Map<String, String>> getOpportunityLineItems(Id opportunityId){
        
        List<Map<String, String>> oppLineItems = new List<Map<String, String>>();
        //get the opportunity product
        List<OpportunityLineItem> opportunityLineItems = new OpportunityLineItemsSelector().selectByOpportunityId(opportunityId);
        for(OpportunityLineItem opportunityLineItem : opportunityLineItems){
            oppLineItems.add(new Map<String, String>{'value' => opportunityLineItem.Id, 'label' => opportunityLineItem.ProductCode});
        }
        return oppLineItems;
    }
    
    //added by Mbuyiseni
    @AuraEnabled
    public static List<OpportunityLineItem> getOpportunityLineItemDetails(Id opportunityId){
        List<OpportunityLineItem> opportunityLineItemDetails = new OpportunityLineItemsSelector().selectByOpportunityId(opportunityId);
        return opportunityLineItemDetails;
    }
    
    //Added by Mbuyiseni Mbhokane
    @AuraEnabled
    public static String updateDailyLimits(String telerCode , String workStation, String supervisor , String branchCode, String combiNbr, String cardCshLim, String cardTrfLim, String cardPosLim, String cardCntLim, String cheqNomAcc, String cheqApplNo, String cheqCshLim, String cheqTrfLim, String cheqPosLim,String savsNomAcc,String savsApplNo, String savsCshLim, String savsTrfLim, String savsPosLim){
        String returnedDailyLimitResponse;
        try{
            Map<CCupdDailyTransactionLimitsV2_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CCupdDailyTransactionLimitsV2_IH_v1.CCupdateDailyLimits(telerCode, workStation, supervisor, branchCode, combiNbr, cardCshLim, cardTrfLim, cardPosLim, cardCntLim, cheqNomAcc, cheqApplNo, cheqCshLim, cheqTrfLim, cheqPosLim, savsNomAcc, savsApplNo, savsCshLim, savsTrfLim, savsPosLim);
            CCupdDailyTransactionLimitsV2_Resp_IB_v1 responseBean = (new List<CCupdDailyTransactionLimitsV2_Resp_IB_v1>(responseMap.keySet()))[0];
            if((responseBean != null) && (responseBean.statusCode == 200)){
                CCupdDailyTransactionLimitsV2_Resp_IB_v1.ccUpdDailyTransactionLimitsV2Response dailyTrans = responseBean.ccUpdDailyTransactionLimitsV2Response;
                returnedDailyLimitResponse = JSON.serialize(dailyTrans);
            }else {
    
                returnedDailyLimitResponse = JSON.serialize(responseBean.ccUpdDailyTransactionLimitsV2Response);
                system.debug('Response'+returnedDailyLimitResponse);
            }
        }catch(Exception excep){

            System.debug('Exception Occured'+excep.getMessage()+ 'At Line number'+excep.getLineNumber());
            throw new AuraHandledException('Something went wrong: '+ excep.getMessage());
        }

        return returnedDailyLimitResponse;
        
    }

    //Get the brand numbers and related product.
    @AuraEnabled
    public static List<Card_Ordering_Brand_Number__mdt> brandNumbers(){
        //Get the brand numbers
        List<Card_Ordering_Brand_Number__mdt> brandNumberList = [SELECT DeveloperName, MasterLabel, Brand_Number__c FROM Card_Ordering_Brand_Number__mdt];
         return brandNumberList;                                                                         

    }
      
    // Added By Mbuyiseni Mbhokane: Method to update Application Product record with selected values from the services.
    @AuraEnabled
    public static String createApplicationProductRecord(Application_Product__c applcationProductRecord, Id opportunityId){

        //Get the latest application product record.
        Application_Product__c applicationRecord = [SELECT Id, Opportunity__c,Product_Account_Number__c,Product_Brand__c,Product_Code__c,Product_Type__c, Combi_Card_Number__c FROM Application_Product__c WHERE Opportunity__c =: opportunityId ORDER BY CreatedDate LIMIT 1];

        String message;

        try {
            
            if(applicationRecord != null){

                applicationRecord.Product_Account_Number__c = applcationProductRecord.Product_Account_Number__c;
                applicationRecord.Product_Brand__c = applcationProductRecord.Product_Brand__c;
                applicationRecord.Product_Code__c = applcationProductRecord.Product_Code__c;
                applicationRecord.Product_Type__c = applcationProductRecord.Product_Type__c;
                applicationRecord.Combi_Card_Number__c = applcationProductRecord.Combi_Card_Number__c;

                //Update the existing application record.
                update applicationRecord;
                message = 'The record has been successfully updated';

            }
            else{

                //upsert applcationProductRecord;
                message = 'New application record has been created';
                throw new AuraHandledException('Something went wrong');
            }

        } catch (Exception ex) {

            message = 'Something went wrong: ' + ex.getMessage();
            System.debug('Exception Occured'+ex.getMessage()+ 'At Line number'+ex.getLineNumber());
            throw new AuraHandledException('Something went wrong: '+ ex.getMessage());
        }
        
        return message;
        
    }

    //added by Mbuyiseni Mbhokane: Address for selected related  party.
    @AuraEnabled
    public static List<Address__c> selectedRelatedPartyAddress(Id accountId){
        //Physical Address
        Set<String> addressTypes = new Set<String>{'Residential', 'Physical Address'};
         List<Address__c> relatedPartyAddress = new AddressesSelector().selectByAccountAndTypes(accountId,addressTypes, 10);
         return relatedPartyAddress;
    }
    
     //added by Mbuyiseni Mbhokane: CCIssueV2 service rewrapped.
    @AuraEnabled
    public static String ccIssueCard(String agencyCode, String cardReqdIndicator, String persIndicator, String persName, String cardNumber, String clientCode, String brandNumber,
                                    String prodCode, String autoLink, String nomCheq, String nomSavs, String nomCred, String pinReqdIndicator, String cardFee, String lostFee,
                                    String idPspIndicator, String idPspNumber, String cardTypeIndicator){
       String cardIssueResponse;
       try{
        CCIssueV2_Req_IB_v2 cardIssueRequestBean = CCIssueV2_IU_v2.mapRequestFields(agencyCode, cardReqdIndicator, persIndicator, persName, cardNumber, clientCode, brandNumber, prodCode, autoLink, nomCheq, nomSavs, nomCred, pinReqdIndicator, cardFee, lostFee, idPspIndicator, idPspNumber, cardTypeIndicator);
        CCIssueV2_Resp_IB_v2 cardIssueResponseBean = CCIssueV2_IH_v2.ccissue(cardIssueRequestBean);
        
        if((cardIssueResponseBean != null) && (cardIssueResponseBean.statusCode == 200)){

         cardIssueResponse = cardIssueResponseBean.serialize(cardIssueResponseBean);
         system.debug('cardIssueResponse : '+ cardIssueResponse);

        }else {

            cardIssueResponse = cardIssueResponseBean.serialize(cardIssueResponseBean);
            system.debug('cardIssueResponse : '+ cardIssueResponse);
        }
       }catch(Exception e){

        System.debug('Exception Occured'+e.getMessage()+ 'At Line number'+e.getLineNumber());
        throw new AuraHandledException('Something went wrong: '+ e.getMessage());
       }
       return cardIssueResponse;

    }

    //added by Mbuyiseni Mbhokane: CCissueBBCombiCardV1 service rewrapped.
    @AuraEnabled
    public static String ccIssueCombiCard(String consumerID, String clientCode, String accountNumber, String productCode, String brandNumber,
                                        String issueBranch, String sbuCode, String secClientCode, String nameIndicator, String persName, String nomCheq,
                                        String nomSavs, String deliveryMethod, String persIndicator){

    String combiCardResponse;

    try{
        CCissueBBCombiCardV1_Req_IB_v2 issueCombiCardRequestBean = CCissueBBCombiCardV1_IU_v2.mapRequestFields(consumerID, clientCode, accountNumber, productCode, brandNumber, issueBranch, sbuCode, secClientCode, nameIndicator, persName, nomCheq, nomSavs, deliveryMethod, persIndicator);
        CCissueBBCombiCardV1_Resp_IB_v2 issueCombiCardResponseBean = CCissueBBCombiCardV1_IH_v2.issueCombiCard(issueCombiCardRequestBean);

        if((issueCombiCardResponseBean != null) && (issueCombiCardResponseBean.statusCode == 200)){
            combiCardResponse = issueCombiCardResponseBean.serialize(issueCombiCardResponseBean);
            System.debug('combiCardResponse: '+ combiCardResponse);
        }else{

            combiCardResponse = issueCombiCardResponseBean.serialize(issueCombiCardResponseBean);
            System.debug('combiCardResponse: '+ combiCardResponse);
        }
    }catch(Exception ex){

        System.debug('Exception Occured'+ex.getMessage()+ 'At Line number'+ex.getLineNumber());
        throw new AuraHandledException('Something went wrong: '+ ex.getMessage());
    }
        return combiCardResponse;
    }

    //added by Mbuyiseni Mbhokane: CClistPrefProductForClientV2 service rewrapped.
    @AuraEnabled
    public static String productForClient(String clientCode, String accountNumber, String cardType){

        String prodForClientList;

        try{
            CClistPrefProductForClientV2_Req_IB_v2 prefProdForClientRequestBean = CClistPrefProductForClientV2_IU_v2.mapRequestFields(clientCode, accountNumber, cardType);
            CClistPrefProductForClientV2_Resp_IB_v2 prefProdForClientResponseBean = CClistPrefProductForClientV2_IH_v2.cclistprefproductsforclient(prefProdForClientRequestBean);
            if((prefProdForClientResponseBean != null) && (prefProdForClientResponseBean.statusCode == 200)){

                prodForClientList = prefProdForClientResponseBean.serialize(prefProdForClientResponseBean);
                System.debug('prodForClientList : '+ prodForClientList);

            }else {

                prodForClientList = prefProdForClientResponseBean.serialize(prefProdForClientResponseBean);
                System.debug('prodForClientList : '+ prodForClientList);
            }
        }catch(Exception exc){

            System.debug('Exception Occured'+exc.getMessage()+ 'At Line number'+exc.getLineNumber());
            throw new AuraHandledException('Something went wrong: '+ exc.getMessage());  
        }

        return prodForClientList;
    }
}