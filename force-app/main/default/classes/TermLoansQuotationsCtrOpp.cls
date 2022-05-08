public class TermLoansQuotationsCtrOpp {

    @auraEnabled 
    public static id getAppProduct(Id oppId){
        List<Application_Product__c > prodlist = new ApplicationproductSelector().selectByOpportunityId(oppId);
        
        
        return prodlist[0].id;
        
        
    }
    
    @AuraEnabled
    public static String getPrimeRates() { 
        IPlistNCARatesV1_Req_IB_v1 dummyBean = IPlistNCARatesV1_Req_IB_v1.createDummyRequest();
        IPlistNCARatesV1_Resp_IB_v1 responseBean = IPlistNCARatesV1_IH_v1.IPlistNCARatesV1(dummyBean);
        System.debug('IPlistNCARatesV1Response Bean '+ responseBean.serialize(responseBean));
        
        return JSON.serialize(responseBean.IPlistNCARatesV1Response.ipb100o.primeRate);
    }
    
   /* @AuraEnabled
    public static case getCaseRecord(Id caseId) { 
        System.debug('caseId:'+ caseId);
        List<Case> caseList = new CasesSelector().selectByIdWithComplaintInfoTOM(caseId,1);
        System.debug('Doinit CaseRecord:'+ caseList);
        return caseList[0];
    }*/
    
    @AuraEnabled
    public static opportunity getOpportunityRecord(Id opportunityId) { 
        System.debug('opportunityId:'+ opportunityId);
        List<Opportunity> opportunityList = new OpportunitiesSelector().selectByOpportunityId(opportunityId,1);
        System.debug('Doinit OpportunityRecord:'+ opportunityList);
        return opportunityList[0];
    }     

   @AuraEnabled
    public static Application_Product__c getOpportunityApplicationProductRecord(Id RecId){
       String sObjName = RecId.getSObjectType().getDescribe().getName();
        Application_Product__c appProdRec=new Application_Product__c();
        if(sObjName =='Opportunity'){
        Opportunity OppRec = new OpportunitiesSelector().selectByOpptId(RecId);
         appProdRec = [select id,Name,Opportunity__c,Quotes_Input_Request__c,Account_Number__c from Application_Product__c where Opportunity__c=:OppRec.Id];
         }else if(sObjName =='Case'){
            Case caseRec= [select id,Subject,Opportunity__c from case where Id= :RecId];
             appProdRec = [select id,Name,Opportunity__c,Account_Number__c from Application_Product__c where Opportunity__c=:caseRec.Opportunity__c];
         }
             return appProdRec;
    	}
    
    
    @AuraEnabled
    public static String getCalculateQuotes(Id RecId, String loanAmountP, String contractDateP, String firstRepayDateP ,String repayFreqP,
                                            String contractTermP, String mortgageP, String ratePrimeP, String rateFixedP, String interestRateP, String initiationFeeP, String serviceFeeP,
                                            String skipMonthsP, String creditLifeP, String debitOrderP, String quoteNumberP, String complexStrP, String initMethodP, String applicationNumberP,
                                            String purposeOfLoanP, String maxRateTypeP, String totalSettleAmountP, String loanAccToSettleP, String loanSettleAmountP, String termLoanTypeP, 
                                            String quoteCreatedByP,String inpmargin,String inpRate)
    { 
        String sObjName = RecId.getSObjectType().getDescribe().getName();
        String clientCodeP ;
        Application_Product__c appProdRec =new Application_Product__c();
        
        if(sObjName =='Opportunity'){
        Opportunity OppRec = new OpportunitiesSelector().selectByOpptId(RecId);
         appProdRec = [select id,Name,Opportunity__c,Account_Number__c from Application_Product__c where Opportunity__c=:OppRec.Id];
        System.debug('OppRec.CIF_Number__c' + OppRec.CIF_Number__c);
        
        if(OppRec.CIF_Number__c!=null){ 
            clientCodeP=OppRec.CIF_Number__c; 
        }}else if(sObjName =='Case'){
            Case caseRec= [select id,Subject,Opportunity__c,Application_Product_Id__c,Case.Opportunity__r.CIF_Number__c from case where Id= :RecId];
             appProdRec = [select id,Name,Opportunity__c,Account_Number__c from Application_Product__c where Opportunity__c=:caseRec.Opportunity__c];
        System.debug('OppRec.CIF_Number__c' + caseRec.Opportunity__r.CIF_Number__c);
		system.debug('caseRec'+caseRec);   
            system.debug('appProdRec'+appProdRec); 
        if(caseRec.Opportunity__r.CIF_Number__c!=null){ 
            clientCodeP=caseRec.Opportunity__r.CIF_Number__c; 
        }
        }
        String accountNoP = String.valueof(appProdRec.Account_Number__c);            //'3001537580';
        
        String financeTypeP = '01';
        clientCodeP = clientCodeP ;                                            //'WCC    451';                                                  
        String empowermentCodeP='';
        String schemeTypeP='';
        
       If(contractDateP!= null){contractDateP=contractDateP.replace('-', '');}
        If(firstRepayDateP!= null){firstRepayDateP=firstRepayDateP.replace('-', ''); } 
       //Creatng the Request Beam
        ABFgetQuoteInfoForEspV5_Req_IB_V1 requestBean = new ABFgetQuoteInfoForEspV5_Req_IB_V1();
        
        requestBean.NBSAPDPI = new ABFgetQuoteInfoForEspV5_Req_IB_V1.NBSAPDPI();
        requestBean.NBSMSGI = new ABFgetQuoteInfoForEspV5_Req_IB_V1.NBSMSGI();
        requestBean.PLSA71I = new ABFgetQuoteInfoForEspV5_Req_IB_V1.PLSA71I();
        
        requestBean.NBSAPDPI.inputHeader  = new ABFgetQuoteInfoForEspV5_Req_IB_V1.inputHeader();
        requestBean.NBSMSGI.inputErrorMessage= new ABFgetQuoteInfoForEspV5_Req_IB_V1.inputErrorMessage();
        requestBean.PLSA71I.inputCopybookLayout = new ABFgetQuoteInfoForEspV5_Req_IB_V1.inputCopybookLayout();
        requestBean.PLSA71I.inputCopybookLayout.inputLoanToSettleInfo = new  ABFgetQuoteInfoForEspV5_Req_IB_V1.inputLoanToSettleInfo();
        
        requestBean.NBSAPDPI.inputHeader.channelName = 'DP';
        requestBean.NBSAPDPI.inputHeader.applicationName = 'DP';
        requestBean.NBSAPDPI.inputHeader.traceIndicator = 'Y';
        
        requestBean.NBSMSGI.inputErrorMessage.inputMessageLanguage = 'E';
        requestBean.NBSMSGI.inputErrorMessage.inputMessageTarget = 'STD';
        
        
        requestBean.PLSA71I.inputCopybookLayout.inputLoanToSettleInfo.inputLoanAccountToSettle = loanAccToSettleP;
        requestBean.PLSA71I.inputCopybookLayout.inputLoanToSettleInfo.inputLoanSettlementAmount = loanSettleAmountP;
        
        requestBean.PLSA71I.inputCopybookLayout.inputClientCode = clientCodeP;
        requestBean.PLSA71I.inputCopybookLayout.inputAccountNbr = accountNoP;
        requestBean.PLSA71I.inputCopybookLayout.inputFinanceType = financeTypeP;
        requestBean.PLSA71I.inputCopybookLayout.inputLoanAmount = loanAmountP;                                  
        requestBean.PLSA71I.inputCopybookLayout.inputContractDate  = contractDateP;
        requestBean.PLSA71I.inputCopybookLayout.inputFirstRepaymentDate = firstRepayDateP;
        requestBean.PLSA71I.inputCopybookLayout.inputRepaymentFrequency = repayFreqP;
        requestBean.PLSA71I.inputCopybookLayout.inputContractTerm = contractTermP;
        requestBean.PLSA71I.inputCopybookLayout.inputMortgageIndicator = mortgageP;
        requestBean.PLSA71I.inputCopybookLayout.inputRatePrimeIndicator = ratePrimeP;
        requestBean.PLSA71I.inputCopybookLayout.inputRateFixedIndicator = rateFixedP;
        requestBean.PLSA71I.inputCopybookLayout.inputInterestRate = interestRateP;
        requestBean.PLSA71I.inputCopybookLayout.inputInitiationFee = initiationFeeP;
        requestBean.PLSA71I.inputCopybookLayout.inputServiceFee = serviceFeeP;
        requestBean.PLSA71I.inputCopybookLayout.inputSkipMonths = skipMonthsP;
        requestBean.PLSA71I.inputCopybookLayout.inputCreditLifeIndicator = creditLifeP;
        requestBean.PLSA71I.inputCopybookLayout.inputDebitOrderIndicator = debitOrderP;
        requestBean.PLSA71I.inputCopybookLayout.inputQuoteNumber = quoteNumberP;
        requestBean.PLSA71I.inputCopybookLayout.inputComplexStructureIndicator = complexStrP;
        requestBean.PLSA71I.inputCopybookLayout.inputInitiationFeeMethod = initMethodP;
        requestBean.PLSA71I.inputCopybookLayout.inputApplicationNbr = applicationNumberP;
        requestBean.PLSA71I.inputCopybookLayout.inputPurposeOfLoanCode = purposeOfLoanP;
        requestBean.PLSA71I.inputCopybookLayout.inputEmpowermentCode = empowermentCodeP;
        requestBean.PLSA71I.inputCopybookLayout.inputMaxRateType = maxRateTypeP;
        requestBean.PLSA71I.inputCopybookLayout.inputTotalSettlementAmount = totalSettleAmountP;
        requestBean.PLSA71I.inputCopybookLayout.inputTermLoanType = termLoanTypeP;
        requestBean.PLSA71I.inputCopybookLayout.inputChannelQuoteCreated = quoteCreatedByP;
        requestBean.PLSA71I.inputCopybookLayout.inputSchemeType = schemeTypeP;
        requestBean.PLSA71I.inputCopybookLayout.inputSchemeCode = '0';
        requestBean.PLSA71I.inputCopybookLayout.inputCreditlifeSchemeCode = '0';
        requestBean.PLSA71I.inputCopybookLayout.inputCreditlifePremium ='0';
        requestBean.PLSA71I.inputCopybookLayout.inputNLRReferenceNbr ='0';
        requestBean.PLSA71I.inputCopybookLayout.inputNCAIndicator = '0';
        requestBean.PLSA71I.inputCopybookLayout.inputVisibleCreditIndicator ='N';
        requestBean.PLSA71I.inputCopybookLayout.inputMargin =inpmargin;
        requestBean.PLSA71I.inputCopybookLayout.inputRateAbovebelow =inpRate;

        
        System.debug('-=-=@@@@@  ABFgetQuoteInfoForEspV5 Request : ' + requestBean); 
       
         
       
        
        ABFgetQuoteInfoForEspV5_Resp_IB_V1 responseCalculate = ABFgetQuoteInfoForEspV5_IH_V1.ABFgetQuoteInfoForEspV5(requestBean);    
        System.debug('-=-=@@@@@ ABFgetQuoteInfoForEspV5 Response : ' + responseCalculate); 
        
        //Calling Future Method to Insert Request Bean to App Prod object
        TermLoansQuoationsController.insertReqBean(JSON.serialize(requestBean),appProdRec.Id);
        TermLoansQuoationsController.insertRespBean(JSON.serialize(responseCalculate),appProdRec.id);
          
        return JSON.serialize(responseCalculate);
    }
    
       
    
    @future 
    public static void insertReqBean(String reqBean,string appProdId)  
        {     
            Application_Product__c appProdReq = new ApplicationProductSelector().selectApplicationProductById(appProdId);
            System.debug('-=-=@@@@@  appProdReq : ' + appProdReq);
            
            Application_Product__c appPrdUpdateReq = new Application_Product__c();
            
            if(appProdReq !=null){
                appPrdUpdateReq.id = appProdReq.Id;
                appPrdUpdateReq.Quotes_Input_Request__c = reqBean;
                try{
                    update appPrdUpdateReq;
                    System.debug('appPrdUpdateReq ' + appPrdUpdateReq);
                    
                }
                catch(Exception ex) {
                    
                    System.debug('Error appPrdUpdateReq: ' + ex.getDmlMessage(0));
                    
                }
            }   
            
        }   
     @future 
    public static void insertRespBean(String respBean,string appProdId)  
        {                
            Application_Product__c appProdResp = new ApplicationProductSelector().selectApplicationProductById(appProdId);
            Application_Product__c appPrdUpdateResp = new Application_Product__c();
            if(appProdResp !=null){
                appPrdUpdateResp.id = appProdResp.Id;
               // appPrdUpdateResp.Quotes_Output_Response__c = respBean;
                try{
                    update appPrdUpdateResp;
                    System.debug('appPrdUpdateResp ' + appPrdUpdateResp);
                }
                catch(Exception ex) {
                    
                    System.debug('Error appPrdUpdateResp: ' + ex.getDmlMessage(0));  
                }
            }      
            
        } 
    @AuraEnabled
    public static string QuoteResponseData(Id RecId) {                
           String sObjName = RecId.getSObjectType().getDescribe().getName();
        	Application_Product__c appProdRec=new Application_Product__c();
        	if(sObjName =='Opportunity'){
        	Opportunity OppRec = new OpportunitiesSelector().selectByOpptId(RecId);
         	appProdRec = [select id,Name,Opportunity__c,Quotes_Output_Response__c,Account_Number__c from Application_Product__c where Opportunity__c=:OppRec.Id];
         	}else if(sObjName =='Case'){
            Case caseRec= [select id,Subject,Opportunity__c from case where Id= :RecId];
            appProdRec = [select id,Name,Quotes_Output_Response__c,Opportunity__c,Account_Number__c from Application_Product__c where Opportunity__c=:caseRec.Opportunity__c];
        	}
			if(appProdRec.Quotes_Output_Response__c!=null){
            ABFgetQuoteInfoForEspV5_Resp_IB_V1 respbean = (ABFgetQuoteInfoForEspV5_Resp_IB_V1)Json.deserialize(appProdRec.Quotes_Output_Response__c , ABFgetQuoteInfoForEspV5_Resp_IB_V1.class); 
            return JSON.serialize(respbean);
            }
            return null;
        }  
    @AuraEnabled
    public static string QuoteRequestData(Id RecId) {                
            String sObjName = RecId.getSObjectType().getDescribe().getName();
       		Application_Product__c appProdRec=new Application_Product__c();
        	if(sObjName =='Opportunity'){
        		Opportunity OppRec = new OpportunitiesSelector().selectByOpptId(RecId);
         		appProdRec = [select id,Name,Opportunity__c,Quotes_Input_Request__c,Account_Number__c from Application_Product__c where Opportunity__c=:OppRec.Id];
         	}else if(sObjName =='Case'){
            	Case caseRec= [select id,Subject,Opportunity__c from case where Id= :RecId];
             	appProdRec = [select id,Name,Opportunity__c,Quotes_Input_Request__c,Account_Number__c from Application_Product__c where Opportunity__c=:caseRec.Opportunity__c];}
           if(appProdRec.Quotes_Input_Request__c!=null){
                ABFgetQuoteInfoForEspV5_Req_IB_V1 reqBean=(ABFgetQuoteInfoForEspV5_Req_IB_V1)Json.deserialize(appProdRec.Quotes_Input_Request__c , ABFgetQuoteInfoForEspV5_Req_IB_V1.class); 
            	return JSON.serialize(reqBean);
            }
            	return null;
        }  
}