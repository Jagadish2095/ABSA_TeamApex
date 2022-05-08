/**
* Lightning Component for Fulfillment -Term Loans  Quotations and Agreements Controller (For Non Scored)
*
* @author  Himanshu Nimje
* @since   2020-11-17
* UserStory W-007430, W-007431
*/

Public class TermLoansQuoationsController {


    
    


    @AuraEnabled
    public static String getPrimeRates() { 
        IPlistNCARatesV1_Req_IB_v1 dummyBean = IPlistNCARatesV1_Req_IB_v1.createDummyRequest();
        IPlistNCARatesV1_Resp_IB_v1 responseBean = IPlistNCARatesV1_IH_v1.IPlistNCARatesV1(dummyBean);
        System.debug('IPlistNCARatesV1Response Bean '+ responseBean.serialize(responseBean));
        
        return JSON.serialize(responseBean.IPlistNCARatesV1Response.ipb100o.primeRate);
    }
    
    @AuraEnabled
    public static case getCaseRecord(Id caseId) { 
        System.debug('caseId:'+ caseId);
        List<Case> caseList = new CasesSelector().selectByIdWithComplaintInfoTOM(caseId,1);
        System.debug('Doinit CaseRecord:'+ caseList);
        return caseList[0];
    }
    




    @AuraEnabled
    public static Application_Product__c getCaseApplicationProductRecord(Id caseId){
        List<Case>caseList=new CasesSelector().selectByIdWithSLAInfo(caseId,1);
        Id appProductId=caseList[0].Application_Product_Id__c;
        Application_Product__c appProdRec = new ApplicationProductSelector().selectApplicationProductById(string.valueOf(appProductId));
        System.debug('Doinit appProdRec'+ appProdRec);
        return appProdRec;
    }
    




    
    
    @AuraEnabled
    public static String getCalculateQuotes(String caseIdP, String loanAmountP, String contractDateP, String firstRepayDateP ,String repayFreqP,
                                            String contractTermP, String mortgageP, String ratePrimeP, String rateFixedP, String interestRateP, String initiationFeeP, String serviceFeeP,
                                            String skipMonthsP, String creditLifeP, String debitOrderP, String quoteNumberP, String complexStrP, String initMethodP, String applicationNumberP,
                                            String purposeOfLoanP, String maxRateTypeP, String totalSettleAmountP, String loanAccToSettleP, String loanSettleAmountP, String termLoanTypeP, 
                                            String quoteCreatedByP, String schemeCodeP, String clifeSchemeCodeP, String clifePremiumP, String nlrRefNoP, String ncaIndP, String visibleCreditP)
    { 
        
        String clientCodeP ;
        List<Case> cs = new CasesSelector().selectByIdWithComplaintInfoTOM(caseIdP,1);


        Account acc= new AccountsSelector().selectIndvByOpportunityId(cs[0].opportunity__c);
        // serviceFeeP =if (If NCA IN (Sole Prop) = R69, if Juristic NCA IN/OUT = R200, default to R69 )
        System.debug('acc.CIF__C' + acc.CIF__C);
        if(acc.CIF__C!=null){ 
            clientCodeP=acc.CIF__C;


        }
        
        List<Case>caseList=new CasesSelector().selectByIdWithSLAInfo(caseIdP,1);
        Id appProductId=caseList[0].Application_Product_Id__c;
        Application_Product__c appProdRec = new ApplicationProductSelector().selectApplicationProductById(string.valueOf(appProductId));
        
        String accountNoP = String.valueof(appProdRec.Account_Number__c); 			 //'3001537580';
        
        String financeTypeP = '01';
        clientCodeP = clientCodeP ;                                            //'WCC    451'; 													
        String empowermentCodeP='';
        String schemeTypeP='';
		
        System.debug('------ @@@@@@@@@@@@ accountNoP' + accountNoP);
        System.debug('------ @@@@@@@@@@@@ clientCodeP' + clientCodeP);        
        
        If(contractDateP!= null){contractDateP=contractDateP.replace('-', '');}
        If(firstRepayDateP!= null){firstRepayDateP=firstRepayDateP.replace('-', ''); } 
        System.debug(' contractDateP' + contractDateP);
        System.debug(' firstRepayDateP' + firstRepayDateP);
        
        
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
        requestBean.PLSA71I.inputCopybookLayout.inputSchemeCode = schemeCodeP;
        requestBean.PLSA71I.inputCopybookLayout.inputCreditlifeSchemeCode = clifeSchemeCodeP;
        requestBean.PLSA71I.inputCopybookLayout.inputCreditlifePremium = clifePremiumP;
        requestBean.PLSA71I.inputCopybookLayout.inputNLRReferenceNbr = nlrRefNoP;
        requestBean.PLSA71I.inputCopybookLayout.inputNCAIndicator = ncaIndP;
        requestBean.PLSA71I.inputCopybookLayout.inputVisibleCreditIndicator = visibleCreditP;
        
        System.debug('-=-=@@@@@  ABFgetQuoteInfoForEspV5 Request : ' + requestBean); 
       
         
       
        
        ABFgetQuoteInfoForEspV5_Resp_IB_V1 responseCalculate = ABFgetQuoteInfoForEspV5_IH_V1.ABFgetQuoteInfoForEspV5(requestBean);    
        System.debug('-=-=@@@@@ ABFgetQuoteInfoForEspV5 Response : ' + responseCalculate); 
        
        //Calling Future Method to Insert Request Bean to App Prod object
        TermLoansQuoationsController.insertReqBean(JSON.serialize(requestBean),appProductId);
        TermLoansQuoationsController.insertRespBean(JSON.serialize(responseCalculate),appProductId);


       // if(responseCalculate !=null ){ 
            return JSON.serialize(responseCalculate);
      /*  }else{
            return JSON.serialize(responseCalculate.NBSMSGO3.outputErrorMessage.outputErrorMessageTable[0].errorMessageText);
        }*/
        


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
                appPrdUpdateResp.Quotes_Output_Response__c = respBean;
                try{
                    update appPrdUpdateResp;
                    System.debug('appPrdUpdateResp ' + appPrdUpdateResp);
                }
                catch(Exception ex) {
                    
                    System.debug('Error appPrdUpdateResp: ' + ex.getDmlMessage(0));  
                }
            }      
            
        }   
     
     
    
}