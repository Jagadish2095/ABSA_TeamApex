public class QuotesAgreementsAdditionalDetailsCTRL {
    
    @AuraEnabled 
    public static Application_Product__c getAppProduct(Id oppId){
       String sObjName = oppId.getSObjectType().getDescribe().getName();
       if(sObjName =='Case'){
            Case caseRec= [select id,Opportunity__c from case where Id= :oppId];
            oppId = caseRec.Opportunity__c;
       }
        List<Application_Product__c > prodlist = new ApplicationproductSelector().selectByOpportunityId(oppId);
        return prodlist[0];       
        
    }    
    @AuraEnabled
    public static String getSavedValues(String caseId){
        Case caseRec= [select id,Application_Product_Id__c from case where Id= :caseId];
        Application_Product__c appProdRec = new ApplicationProductSelector().selectApplicationProductById(caseRec.Application_Product_Id__c);
        system.debug('appProdRec'+appProdRec);
        if(appProdRec != null ) {
           ABFgetAndCalcConfDetailV4_Req_IB_V1 reqbean = (ABFgetAndCalcConfDetailV4_Req_IB_V1)Json.deserialize(appProdRec.ABFgetAndCalcConfirmationDetailV4_Req__c , ABFgetAndCalcConfDetailV4_Req_IB_V1.class); 
            if(reqbean!=Null){
                if(reqbean.PLPA01I!=Null){
                    if(reqbean.PLPA01I.PLPA01I!=Null){
                        return JSON.serialize(reqbean.PLPA01I.PLPA01I);                         
                    }
                    
                }
               
            }
        }
        return null;
    }
    @AuraEnabled
    public static String getCalculateQuotesService1(Id OppId,String contractDate, String termLoanType,String securityReq, 
                                                    String selectMarketSector ,String selectedPermitWD,
                                            String selectedElectronicTransfer, String mandateNumber,
                                                    String selectLoanPurposes, String selectSchemeType, String selectPaymentMethod,
                                                    String selectAgreementCategory, String selectFinanceType)
    {
        system.debug('OppId'+OppId);
        //Opportunity OppRec = new OpportunitiesSelector().selectByOpptId(OppId);
       String sObjName = OppId.getSObjectType().getDescribe().getName();
       if(sObjName =='Case'){
            Case caseRec= [select id,Opportunity__c from case where Id= :oppId];
            OppId = caseRec.Opportunity__c;
       }
        list<Application_Product__c> appProdRec = new ApplicationProductSelector().selectByOpportunityId(OppId);
        // term loan account number 
        If(contractDate!= null){contractDate=contractDate.replace('-', '');}
        
        System.debug(' contractDate' + contractDate);
        String accountNo = String.valueof(appProdRec[0].Account_Number__c); 
        user u = new UsersSelector().selectById(userinfo.getUserId());
        //user u= [SELECT Id, SiteCode__c, Supervisor__c, SiteType__c,EmployeeNumber, Teller_Operator_Code__c FROM User where id=:userinfo.getUserId()];                                        
         System.debug(' appProdRec' + appProdRec[0]);
        
          if(appProdRec[0] != null ) {
              System.debug(' appProdRec.Account_Number__c' + appProdRec[0].Account_Number__c);
            if(appProdRec[0].Account_Number__c != null){
        //Creatng the Request Beam
        ABFgetAndCalcConfDetailV4_Req_IB_V1 requestBean = new ABFgetAndCalcConfDetailV4_Req_IB_V1();
        requestBean.NBSAPDPI = new ABFgetAndCalcConfDetailV4_Req_IB_V1.NBSAPDPI();
        requestBean.NBSAPDPI.NBSAPLI = new ABFgetAndCalcConfDetailV4_Req_IB_V1.NBSAPLI();
        
        requestBean.NBSAPDPI.NBSAPLI.NBNAPLI_CHANNEL = 'Salesforce';
        requestBean.NBSAPDPI.NBSAPLI.NBNAPLI_APPLICATION='Salesforce';
        requestBean.NBSAPDPI.NBSAPLI.NBNAPLI_TRACE = 'Y';
        
        requestBean.MSGI = new ABFgetAndCalcConfDetailV4_Req_IB_V1.MSGI();
        requestBean.MSGI.NBSMSGI = new ABFgetAndCalcConfDetailV4_Req_IB_V1.NBSMSGI();
        
        requestBean.MSGI.NBSMSGI.NBNMSGI_MSG_LANGUAGE = 'E';
        requestBean.MSGI.NBSMSGI.NBNMSGI_MSG_TARGET='STD';
        
        requestBean.PLPA01I = new ABFgetAndCalcConfDetailV4_Req_IB_V1.PLPA01I();
        requestBean.PLPA01I.PLPA01I = new ABFgetAndCalcConfDetailV4_Req_IB_V1.PLPA01Iz();
        
        requestBean.PLPA01I.PLPA01I.corpCode='ABS';
        requestBean.PLPA01I.PLPA01I.branchCode = u.SiteCode__c!=Null? u.SiteCode__c:'';
        requestBean.PLPA01I.PLPA01I.accountNbr= accountNo!=Null?accountNo:'';
        requestBean.PLPA01I.PLPA01I.contractEffectiveDate=contractDate!=Null?contractDate:'';
        requestBean.PLPA01I.PLPA01I.marketSector= selectMarketSector!=Null?selectMarketSector:'';
        requestBean.PLPA01I.PLPA01I.electronicTransferReq= selectedElectronicTransfer!=Null?selectedElectronicTransfer:'';
        requestBean.PLPA01I.PLPA01I.employerCode= u.EmployeeNumber!=Null? u.EmployeeNumber:'';
        requestBean.PLPA01I.PLPA01I.securityReqInd= securityReq!=Null?securityReq:'';
        requestBean.PLPA01I.PLPA01I.permitWithdrawalInd= selectedPermitWD!=Null?selectedPermitWD:'';
        requestBean.PLPA01I.PLPA01I.cpfMarketerCode='';
        requestBean.PLPA01I.PLPA01I.welcomePrintLetter='Y';
        requestBean.PLPA01I.PLPA01I.autoCapiAdvAmt='N';
        requestBean.PLPA01I.PLPA01I.TermLoanType= termLoanType!=Null?termLoanType:'';
        
        System.debug('-=-=@@@@@  ABFgetQuoteInfoForEspV4 Request : ' + requestBean);    
        ABFgetAndCalcConfDetailV4_Resp_IB_V1 responseCalculate = ABFgetAndCalcConfDetailV4_IH_V1.ABFgetAndCalcConfDetailV4(requestBean);    
        System.debug('-=-=@@@@@ ABFgetQuoteInfoForEspV4 Response : ' + responseCalculate); 
                
        //saving other UI values
        requestBean.PLPA01I.PLPA01I.mandateNumber= mandateNumber!=Null?mandateNumber:'';
        requestBean.PLPA01I.PLPA01I.selectLoanPurposes= selectLoanPurposes!=Null?selectLoanPurposes:'';
        requestBean.PLPA01I.PLPA01I.selectSchemeType= selectSchemeType!=Null?selectSchemeType:'';
        requestBean.PLPA01I.PLPA01I.selectPaymentMethod= selectPaymentMethod!=Null?selectPaymentMethod:'';
        requestBean.PLPA01I.PLPA01I.selectAgreementCategory= selectAgreementCategory!=Null?selectAgreementCategory:'';
        requestBean.PLPA01I.PLPA01I.selectFinanceType= selectFinanceType!=Null?selectFinanceType:'';
        QuotesAgreementsAdditionalDetailsCTRL.insertReqBean(JSON.serialize(requestBean),JSON.serialize(responseCalculate),
                                                            'ABFgetAndCalcConfirmationDetailV4_Req__c','ABFgetAndCalcConfirmationDetailV4_Resp__c',    
                                                            appProdRec[0]?.Id);   
         if(responseCalculate.statuscode==200){
                 return 'Success';   
           }
                else{
                    return 'Error';
                }
         // return JSON.serialize(responseCalculate);
        
    }
          }
        return Null;
    }
    @AuraEnabled
    public static String getCalculateQuotesService2(Id OppId,String contractDate,String securityReq, String selectMarketSector ,String selectedPermitWD,
                                            String selectedElectronicTransfer)
    {
     If(contractDate!= null){contractDate=contractDate.replace('-', '');}
        
        System.debug(' contractDate' + contractDate);
        String sObjName = OppId.getSObjectType().getDescribe().getName();
       if(sObjName =='Case'){
            Case caseRec= [select id,Opportunity__c from case where Id= :oppId];
            OppId = caseRec.Opportunity__c;
       }
         list<Application_Product__c> appProdRec = new ApplicationProductSelector().selectByOpportunityId(OppId);
         //Application_Product__c appProdRec = new ApplicationProductSelector().selectApplicationProductById(string.valueOf(appProdId));
        // term loan account number 
        
        String accountNo = String.valueof(appProdRec[0].Account_Number__c); 
        user u = new UsersSelector().selectById(userinfo.getUserId());
        //user u= [SELECT Id, SiteCode__c, Supervisor__c, SiteType__c,EmployeeNumber, Teller_Operator_Code__c FROM User where id=:userinfo.getUserId()];                                        
         
          if(appProdRec[0] != null ) {
            if(appProdRec[0].Account_Number__c != null){
                ABFupdAgreementDetailsV2_Req_IB_V1 requestBean1 = new ABFupdAgreementDetailsV2_Req_IB_V1();
        ABFupdAgreementDetailsV2_Req_IB_V1 ABFupdAgreementDetailsV2  = new ABFupdAgreementDetailsV2_Req_IB_V1();
        ABFupdAgreementDetailsV2.nbsapdpi = new ABFupdAgreementDetailsV2_Req_IB_V1.nbsapdpi();
        ABFupdAgreementDetailsV2.nbsmsgi = new ABFupdAgreementDetailsV2_Req_IB_V1.nbsmsgi();
        ABFupdAgreementDetailsV2.plpa05i = new ABFupdAgreementDetailsV2_Req_IB_V1.plpa05i();
        ABFupdAgreementDetailsV2.nbsapdpi.channel = 'Salesforce';
        ABFupdAgreementDetailsV2.nbsapdpi.application = 'Salesforce';
        ABFupdAgreementDetailsV2.nbsapdpi.trace = 'Y';
         
        ABFupdAgreementDetailsV2.nbsmsgi.msgLanguage = 'E';
        ABFupdAgreementDetailsV2.nbsmsgi.msgTarget = 'STD';
        ABFupdAgreementDetailsV2.nbsmsgi.finalMsgId = new ABFupdAgreementDetailsV2_Req_IB_V1.finalMsgId(); 
        ABFupdAgreementDetailsV2.nbsmsgi.finalMsgId.finalMsgClass = '';
        ABFupdAgreementDetailsV2.nbsmsgi.finalMsgId.finalMsgCode = '';
       
      
      
        ABFupdAgreementDetailsV2.plpa05i.corpCode = 'ABS';
        //ABFupdAgreementDetailsV2.plpa05i.branchCode = '4927';
        ABFupdAgreementDetailsV2.plpa05i.branchCode = u.SiteCode__c!=Null? u.SiteCode__c:'4927';
        ABFupdAgreementDetailsV2.plpa05i.accountNbr = accountNo;
        ABFupdAgreementDetailsV2.plpa05i.contractEffectiveDate = contractDate;
        ABFupdAgreementDetailsV2.plpa05i.marketSector = selectMarketSector;
        ABFupdAgreementDetailsV2.plpa05i.electronicTransferReq = selectedElectronicTransfer;
        ABFupdAgreementDetailsV2.plpa05i.employerCode = u.EmployeeNumber!=Null? u.EmployeeNumber:'5037348';
        ABFupdAgreementDetailsV2.plpa05i.securityReqInd = securityReq;
        ABFupdAgreementDetailsV2.plpa05i.permitWithdrawalInd = selectedPermitWD;
        ABFupdAgreementDetailsV2.plpa05i.cpfMarketerCode = '';
        ABFupdAgreementDetailsV2.plpa05i.welcomePrintLetter = 'Y';
        ABFupdAgreementDetailsV2.plpa05i.agencyCode = u.SiteType__c!=Null? u.SiteType__c:'034';
        ABFupdAgreementDetailsV2.plpa05i.tellerCode = u.Teller_Operator_Code__c!=Null? u.Teller_Operator_Code__c:'042028';
        ABFupdAgreementDetailsV2.plpa05i.supervisorCode =  u.Supervisor__c!=Null? u.Supervisor__c:'042028';
        ABFupdAgreementDetailsV2.plpa05i.branchSiteType = u.SiteType__c!=Null? u.SiteType__c:'034';
        ABFupdAgreementDetailsV2.plpa05i.siteTypeAgency = u.SiteType__c!=Null? u.SiteType__c:'034';
        ABFupdAgreementDetailsV2.plpa05i.creditLife = '0';
        ABFupdAgreementDetailsV2.plpa05i.schemeType = '';
        ABFupdAgreementDetailsV2.plpa05i.schemeCode = '0';
        ABFupdAgreementDetailsV2.plpa05i.autoCapiAdvAmt = 'N';
       
        requestBean1 = ABFupdAgreementDetailsV2;
        ABFupdAgreementDetailsV2_Resp_IB_V1 responseCalculate1 = ABFupdAgreementDetailsV2_IH_V1.ABFupdAgreementDetailsV2(requestBean1);
        QuotesAgreementsAdditionalDetailsCTRL.insertReqBean(JSON.serialize(requestBean1),JSON.serialize(responseCalculate1),
                                                                'ABFupdAgreementDetailsV2Req__c','ABFupdAgreementDetailsV2Resp__c',
                                                                appProdRec[0]?.Id);
         //return JSON.serialize(responseCalculate1);
         if(responseCalculate1.statuscode==200){
                 return 'Success';   
           }
                else{
                    return 'Error';
                }
            }
          }
        return null;
    }
    
    @AuraEnabled
    public static String getCalculateQuotesService3(Id OppId)
    {
       String sObjName = OppId.getSObjectType().getDescribe().getName();
       if(sObjName =='Case'){
            Case caseRec= [select id,Opportunity__c from case where Id= :oppId];
            OppId = caseRec.Opportunity__c;
       }
        list<Application_Product__c> appProdRec = new ApplicationProductSelector().selectByOpportunityId(OppId);
         //Application_Product__c appProdRec = new ApplicationProductSelector().selectApplicationProductById(string.valueOf(appProdId));
        // term loan account number 
        
        String accountNo = String.valueof(appProdRec[0].Account_Number__c); 
        user u = new UsersSelector().selectById(userinfo.getUserId());
          //  [SELECT Id, SiteCode__c, Supervisor__c, SiteType__c,EmployeeNumber, Teller_Operator_Code__c FROM User where id=:userinfo.getUserId()];                                        
         
          if(appProdRec != null ) {
            if(appProdRec[0].Account_Number__c != null){
                ABFgetAccountStatusInfoV1_Req_IB_V1 requestBean2 = new ABFgetAccountStatusInfoV1_Req_IB_V1();
        //requestBean2 = new ABFgetAccountStatusInfoV1_Req_IB_V1.ABFgetAccountStatusInfoV1();
        requestBean2.channel='Salesforce' ;
        requestBean2.application= 'Salesforce' ;
        requestBean2.trace= 'Y';
        requestBean2.msgLanguage= 'E';
        requestBean2.msgTarget= 'STD';
        requestBean2.corpCode= 'ABS';
        requestBean2.accountNbr= accountNo;
        
        System.debug('-=-=@@@@@   ABFgetAccountStatusInfoV1 Request : ' + requestBean2);    
        ABFgetAccountStatusInfoV1_Resp_IB_V1 responseCalculate2 = ABFgetAccountStatusInfoV1_IH_V1.ABFgetAccountStatusInfoV1(requestBean2);    
        System.debug('-=-=@@@@@ ABFgetAccountStatusInfoV1 Response : ' + responseCalculate2);
        QuotesAgreementsAdditionalDetailsCTRL.insertReqBean(JSON.serialize(requestBean2),JSON.serialize(responseCalculate2),
                                                            'ABFgetAccountDetailsInfo_Request__c','ABFgetAccountDetailsInfo_Response__c',
                                                                appProdRec[0]?.Id);
                if(responseCalculate2.statuscode==200){
                    if(responseCalculate2!=Null && responseCalculate2.plpa18o!=Null && responseCalculate2.plpa18o.accountStatus!=Null){
                 //return JSON.serialize(responseCalculate2.plpa18o.accountStatus); 
                 return '003';   
                }
                 return '003';   
           }
                else{
                    return 'Error';
                }
       
          
            }
          }
        return null;
    }
    @AuraEnabled
    public static String getCalculateQuotesService4(Id OppId,String mandateNumber,String accountstatus)
    {
       String sObjName = OppId.getSObjectType().getDescribe().getName();
       if(sObjName =='Case'){
            Case caseRec= [select id,Opportunity__c from case where Id= :oppId];
            OppId = caseRec.Opportunity__c;
       }   
        list<Application_Product__c> appProdRec = new ApplicationProductSelector().selectByOpportunityId(OppId);
        // Application_Product__c appProdRec = new ApplicationProductSelector().selectApplicationProductById(string.valueOf(appProdId));
        // term loan account number 
        
        String accountNo = String.valueof(appProdRec[0].Account_Number__c); 
        user u = new UsersSelector().selectById(userinfo.getUserId());
        //user u= [SELECT Id, SiteCode__c, Supervisor__c, SiteType__c,EmployeeNumber, Teller_Operator_Code__c FROM User where id=:userinfo.getUserId()];                                        
         
          if(appProdRec[0] != null ) {
            if(appProdRec[0].Account_Number__c != null){
                ABFupdAccountStatusV1_Req_IB_v1 requestBean3 = new ABFupdAccountStatusV1_Req_IB_v1();
        //requestBean3 = new ABFupdAccountStatusV1_Req_IB_v1();
        requestBean3.channel = 'Salesforce';
        requestBean3.application = 'Salesforce';
        requestBean3.trace = 'Y';
        requestBean3.msgLanguage = 'E';
        requestBean3.msgTarget = 'STD'; 
        requestBean3.finalMsgClass = '';
        requestBean3.finalMsgCode = '';
        requestBean3.corpCode = 'ABS';
        //requestBean3.branchCode = '4927';
        requestBean3.branchCode =  u.SiteCode__c!=Null? u.SiteCode__c:'4927';
        requestBean3.workstationId = '99';
        requestBean3.agencyCode =  u.SiteType__c!=Null? u.SiteType__c:'034';
        requestBean3.tellerCode =  u.Teller_Operator_Code__c!=Null? u.Teller_Operator_Code__c:'042028';
        requestBean3.supervisorCode =  u.Supervisor__c!=Null? u.Supervisor__c:'042028';
        requestBean3.branchSiteType =  u.SiteType__c!=Null? u.SiteType__c:'034';
        requestBean3.siteTypeAgency = u.SiteType__c!=Null? u.SiteType__c:'034';
        requestBean3.accountNbr = accountNo;
        requestBean3.accountStatus = accountstatus;
            //responseCalculate2plpa18oaccountStatus;
        requestBean3.mandate = mandateNumber;
        
        System.debug('-=-=@@@@@   ABFupdAccountStatusV1 Request : ' + requestBean3);    
        ABFupdAccountStatusV1_Resp_IB_V1 responseCalculate3 = ABFupdAccountStatusV1_IH_V1.ABFupdAccountStatusV1(requestBean3);    
        System.debug('-=-=@@@@@ ABFupdAccountStatusV1 Response : ' + responseCalculate3); 
        QuotesAgreementsAdditionalDetailsCTRL.insertReqBean(JSON.serialize(requestBean3),
                                                            JSON.serialize(responseCalculate3),
                                                            'ABFupdAccountDetails_Request__c','ABFupdAccountDetails_Response__c',
                                                            appProdRec[0]?.Id);
                if(responseCalculate3.statuscode==200){
                 return 'Success';   
           }
                else{
                    return 'Error';
                }

                 //return JSON.serialize(responseCalculate3);
            }
          }
        return null;
    }
     @future 
    public static void insertReqBean(String reqBean,String respBean,String reqBeanField,String respBeanField,string appProdId)  
        {     
           Application_Product__c appProdResp = new ApplicationProductSelector().selectApplicationProductById(appProdId);
            Application_Product__c appPrdUpdateResp = new Application_Product__c();
            if(appProdResp !=null){
                appPrdUpdateResp.id = appProdResp.Id;
                appPrdUpdateResp.put(reqBeanField,reqBean);
                 appPrdUpdateResp.put(respBeanField,respBean);
                
                try{
                    update appPrdUpdateResp;
                    System.debug('appPrdUpdateResp ' + appPrdUpdateResp);
                }
                catch(Exception ex) {
                    
                    System.debug('Error appPrdUpdateResp: ' + ex.getDmlMessage(0));  
                }
            }      
            
        }   
  /*   @AuraEnabled
    public static String getCalculateQuotes(String appProdId,String contractDate, String termLoanType, String securityReq, String selectMarketSector ,String selectedPermitWD,
                                            String selectedElectronicTransfer, String mandateNumber)
    { 
         //String accountNo ='3001534477';
         
        If(contractDate!= null){contractDate=contractDate.replace('-', '');}
        
        System.debug(' contractDate' + contractDate);
         Application_Product__c appProdRec = new ApplicationProductSelector().selectApplicationProductById(string.valueOf(appProdId));
        // term loan account number 
        
        String accountNo = String.valueof(appProdRec.Account_Number__c); 
        user u= [SELECT Id, SiteCode__c, Supervisor__c, SiteType__c,EmployeeNumber, Teller_Operator_Code__c FROM User where id=:userinfo.getUserId()];                                        
         
          if(appProdRec != null ) {
            if(appProdRec.Account_Number__c == null){
        //Creatng the Request Beam
        ABFgetAndCalcConfDetailV4_Req_IB_V1 requestBean = new ABFgetAndCalcConfDetailV4_Req_IB_V1();
        requestBean.NBSAPDPI = new ABFgetAndCalcConfDetailV4_Req_IB_V1.NBSAPDPI();
        requestBean.NBSAPDPI.NBSAPLI = new ABFgetAndCalcConfDetailV4_Req_IB_V1.NBSAPLI();
        
        requestBean.NBSAPDPI.NBSAPLI.NBNAPLI_CHANNEL = 'Salesforce';
        requestBean.NBSAPDPI.NBSAPLI.NBNAPLI_APPLICATION='Salesforce';
        requestBean.NBSAPDPI.NBSAPLI.NBNAPLI_TRACE = 'Y';
        
        requestBean.MSGI = new ABFgetAndCalcConfDetailV4_Req_IB_V1.MSGI();
        requestBean.MSGI.NBSMSGI = new ABFgetAndCalcConfDetailV4_Req_IB_V1.NBSMSGI();
        
        requestBean.MSGI.NBSMSGI.NBNMSGI_MSG_LANGUAGE = 'E';
        requestBean.MSGI.NBSMSGI.NBNMSGI_MSG_TARGET='STD';
        
        requestBean.PLPA01I = new ABFgetAndCalcConfDetailV4_Req_IB_V1.PLPA01I();
        requestBean.PLPA01I.PLPA01I = new ABFgetAndCalcConfDetailV4_Req_IB_V1.PLPA01Iz();
        
        requestBean.PLPA01I.PLPA01I.corpCode='ABS';
        requestBean.PLPA01I.PLPA01I.branchCode = u.SiteCode__c!=Null? u.SiteCode__c:'';
        requestBean.PLPA01I.PLPA01I.accountNbr= accountNo;
        requestBean.PLPA01I.PLPA01I.contractEffectiveDate=contractDate;
        requestBean.PLPA01I.PLPA01I.marketSector= selectMarketSector;
        requestBean.PLPA01I.PLPA01I.electronicTransferReq= selectedElectronicTransfer;
        requestBean.PLPA01I.PLPA01I.employerCode= u.EmployeeNumber!=Null? u.EmployeeNumber:'';
        requestBean.PLPA01I.PLPA01I.securityReqInd= securityReq;
        requestBean.PLPA01I.PLPA01I.permitWithdrawalInd= selectedPermitWD;
        requestBean.PLPA01I.PLPA01I.cpfMarketerCode='';
        requestBean.PLPA01I.PLPA01I.welcomePrintLetter='Y';
        requestBean.PLPA01I.PLPA01I.autoCapiAdvAmt='N';
        requestBean.PLPA01I.PLPA01I.TermLoanType= termLoanType;
        
        System.debug('-=-=@@@@@  ABFgetQuoteInfoForEspV4 Request : ' + requestBean);    
        ABFgetAndCalcConfDetailV4_Resp_IB_V1 responseCalculate = ABFgetAndCalcConfDetailV4_IH_V1.ABFgetAndCalcConfDetailV4(requestBean);    
        System.debug('-=-=@@@@@ ABFgetQuoteInfoForEspV4 Response : ' + responseCalculate); 
        
        ABFupdAgreementDetailsV2_Req_IB_V1 requestBean1 = new ABFupdAgreementDetailsV2_Req_IB_V1();
        ABFupdAgreementDetailsV2_Req_IB_V1 ABFupdAgreementDetailsV2  = new ABFupdAgreementDetailsV2_Req_IB_V1();
        ABFupdAgreementDetailsV2.nbsapdpi = new ABFupdAgreementDetailsV2_Req_IB_V1.nbsapdpi();
        ABFupdAgreementDetailsV2.nbsmsgi = new ABFupdAgreementDetailsV2_Req_IB_V1.nbsmsgi();
        ABFupdAgreementDetailsV2.plpa05i = new ABFupdAgreementDetailsV2_Req_IB_V1.plpa05i();
        ABFupdAgreementDetailsV2.nbsapdpi.channel = 'Salesforce';
        ABFupdAgreementDetailsV2.nbsapdpi.application = 'Salesforce';
        ABFupdAgreementDetailsV2.nbsapdpi.trace = 'Y';
         
        ABFupdAgreementDetailsV2.nbsmsgi.msgLanguage = 'E';
        ABFupdAgreementDetailsV2.nbsmsgi.msgTarget = 'STD';
        ABFupdAgreementDetailsV2.nbsmsgi.finalMsgId = new ABFupdAgreementDetailsV2_Req_IB_V1.finalMsgId(); 
        ABFupdAgreementDetailsV2.nbsmsgi.finalMsgId.finalMsgClass = '';
        ABFupdAgreementDetailsV2.nbsmsgi.finalMsgId.finalMsgCode = '';
       
      
      
        ABFupdAgreementDetailsV2.plpa05i.corpCode = 'ABS';
        ABFupdAgreementDetailsV2.plpa05i.branchCode = u.SiteCode__c!=Null? u.SiteCode__c:'';
        ABFupdAgreementDetailsV2.plpa05i.accountNbr = accountNo;
        ABFupdAgreementDetailsV2.plpa05i.contractEffectiveDate = contractDate;
        ABFupdAgreementDetailsV2.plpa05i.marketSector = selectMarketSector;
        ABFupdAgreementDetailsV2.plpa05i.electronicTransferReq = selectedElectronicTransfer;
        ABFupdAgreementDetailsV2.plpa05i.employerCode = u.EmployeeNumber!=Null? u.EmployeeNumber:'';
        ABFupdAgreementDetailsV2.plpa05i.securityReqInd = securityReq;
        ABFupdAgreementDetailsV2.plpa05i.permitWithdrawalInd = selectedPermitWD;
        ABFupdAgreementDetailsV2.plpa05i.cpfMarketerCode = '';
        ABFupdAgreementDetailsV2.plpa05i.welcomePrintLetter = 'Y';
        ABFupdAgreementDetailsV2.plpa05i.agencyCode = u.SiteType__c!=Null? u.SiteType__c:'';
        ABFupdAgreementDetailsV2.plpa05i.tellerCode = u.Teller_Operator_Code__c!=Null? u.Teller_Operator_Code__c:'';
        ABFupdAgreementDetailsV2.plpa05i.supervisorCode =  u.Supervisor__c!=Null? u.Supervisor__c:'';
        ABFupdAgreementDetailsV2.plpa05i.branchSiteType = u.SiteType__c!=Null? u.SiteType__c:'';
        ABFupdAgreementDetailsV2.plpa05i.siteTypeAgency = u.SiteType__c!=Null? u.SiteType__c:'';
        ABFupdAgreementDetailsV2.plpa05i.creditLife = '0';
        ABFupdAgreementDetailsV2.plpa05i.schemeType = '';
        ABFupdAgreementDetailsV2.plpa05i.schemeCode = '0';
        ABFupdAgreementDetailsV2.plpa05i.autoCapiAdvAmt = 'N';
       
        requestBean1 = ABFupdAgreementDetailsV2;
        ABFupdAgreementDetailsV2_Resp_IB_V1 responseCalculate1 = ABFupdAgreementDetailsV2_IH_V1.ABFupdAgreementDetailsV2(requestBean1);
        
        ABFgetAccountStatusInfoV1_Req_IB_V1 requestBean2 = new ABFgetAccountStatusInfoV1_Req_IB_V1();
        //requestBean2 = new ABFgetAccountStatusInfoV1_Req_IB_V1.ABFgetAccountStatusInfoV1();
        requestBean2.channel='Salesforce' ;
        requestBean2.application= 'Salesforce' ;
        requestBean2.trace= 'Y';
        requestBean2.msgLanguage= 'E';
        requestBean2.msgTarget= 'STD';
        requestBean2.corpCode= 'ABS';
        requestBean2.accountNbr= accountNo;
        
        System.debug('-=-=@@@@@   ABFgetAccountStatusInfoV1 Request : ' + requestBean2);    
        ABFgetAccountStatusInfoV1_Resp_IB_V1 responseCalculate2 = ABFgetAccountStatusInfoV1_IH_V1.ABFgetAccountStatusInfoV1(requestBean2);    
        System.debug('-=-=@@@@@ ABFgetAccountStatusInfoV1 Response : ' + responseCalculate2);        
        
        ABFupdAccountStatusV1_Req_IB_v1 requestBean3 = new ABFupdAccountStatusV1_Req_IB_v1();
        //requestBean3 = new ABFupdAccountStatusV1_Req_IB_v1();
        requestBean3.channel = 'Salesforce';
        requestBean3.application = 'Salesforce';
        requestBean3.trace = 'Y';
        requestBean3.msgLanguage = 'E';
        requestBean3.msgTarget = 'STD'; 
        requestBean3.finalMsgClass = '?';
        requestBean3.finalMsgCode = '?';
        requestBean3.corpCode = 'ABS';
        requestBean3.branchCode =  u.SiteCode__c!=Null? u.SiteCode__c:'';
        requestBean3.workstationId = '99';
        requestBean3.agencyCode =  u.SiteType__c!=Null? u.SiteType__c:'';
        requestBean3.tellerCode =  u.Teller_Operator_Code__c!=Null? u.Teller_Operator_Code__c:'';
        requestBean3.supervisorCode =  u.Supervisor__c!=Null? u.Supervisor__c:'';
        requestBean3.branchSiteType =  u.SiteType__c!=Null? u.SiteType__c:'';
        requestBean3.siteTypeAgency = u.SiteType__c!=Null? u.SiteType__c:'';
        requestBean3.accountNbr = accountNo;
        requestBean3.accountStatus = responseCalculate2.plpa18o.accountStatus!=Null?responseCalculate2.plpa18o.accountStatus:'';
        requestBean3.mandate = mandateNumber;
        
        System.debug('-=-=@@@@@   ABFupdAccountStatusV1 Request : ' + requestBean3);    
        ABFupdAccountStatusV1_Resp_IB_V1 responseCalculate3 = ABFupdAccountStatusV1_IH_V1.ABFupdAccountStatusV1(requestBean3);    
        System.debug('-=-=@@@@@ ABFupdAccountStatusV1 Response : ' + responseCalculate3); 
        //Calling Future Method to Insert Request Bean to App Prod object
        QuotesAgreementsAdditionalDetailsCTRL.insertRespReqBean(JSON.serialize(requestBean),JSON.serialize(responseCalculate),
                                                                JSON.serialize(requestBean1),JSON.serialize(responseCalculate1),
                                                                JSON.serialize(requestBean2),JSON.serialize(responseCalculate2),
                                                                JSON.serialize(requestBean3),JSON.serialize(responseCalculate3),appProdRec?.Id);
       /* TermLoansQuoationsController.insertRespReqBean(JSON.serialize(responseCalculate),appProductId);
        TermLoansQuoationsController.insertRespReqBean(JSON.serialize(requestBean2),appProductId);
        TermLoansQuoationsController.insertRespReqBean(JSON.serialize(responseCalculate2),appProductId);
        TermLoansQuoationsController.insertRespReqBean(JSON.serialize(requestBean3),appProductId);
        TermLoansQuoationsController.insertRespReqBean(JSON.serialize(responseCalculate3),appProductId);
        
        return JSON.serialize(responseCalculate3);
            }} return 'No Application Product Record.';
        }*/
   
  /*  @future 
    public static void insertRespReqBean(String reqBean1,String respBean1,
                                         String reqBean,String respBean,
                                         String reqBean2,String respBean2,
                                         String reqBean3,String respBean3,
                                         string appProdId)  
        {   
            
            Application_Product__c appProdResp = new ApplicationProductSelector().selectApplicationProductById(appProdId);
            Application_Product__c appPrdUpdateResp = new Application_Product__c();
            if(appProdResp !=null){
                appPrdUpdateResp.id = appProdResp.Id;
                //appPrdUpdateResp.put(fieldName,respreqBean);
                appPrdUpdateResp.ABFgetAndCalcConfirmationDetailV4_Req__c = reqBean1 ;
                appPrdUpdateResp.ABFgetAndCalcConfirmationDetailV4_Resp__c =respBean1 ;
                
                appPrdUpdateResp.ABFupdAgreementDetailsV2Req__c = reqBean ;
                appPrdUpdateResp.ABFupdAgreementDetailsV2Resp__c  =respBean ;
                
                appPrdUpdateResp.ABFgetAccountDetailsInfo_Request__c = reqBean2;
                appPrdUpdateResp.ABFgetAccountDetailsInfo_Response__c = respBean2;
                
                appPrdUpdateResp.ABFupdAccountDetails_Request__c = reqBean3;
                appPrdUpdateResp.ABFupdAccountDetails_Response__c = respBean3;
                try{
                    update appPrdUpdateResp;
                    System.debug('appPrdUpdateResp ' + appPrdUpdateResp);
                }
                catch(Exception ex) {
                    
                    System.debug('Error appPrdUpdateResp: ' + ex.getDmlMessage(0));  
                }
            }      
            
        }*/
}