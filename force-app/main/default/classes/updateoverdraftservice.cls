public with sharing class updateoverdraftservice {
    public static String getFormattedDate(Date dt) {
		String formattedDate = '';
		if (dt.year() < 10) {
			formattedDate += '0' + dt.year();
		}
		else {
			formattedDate += '' + dt.year();
		}
		if (dt.month() < 10) {
			formattedDate += '0' + dt.month();
		}
		else {
			formattedDate += '' + dt.month();
		}
		if (dt.day() < 10) {
			formattedDate += '0' + dt.day();
		}
		else {
			formattedDate += '' + dt.day();
		}

		return formattedDate;
	}
    public static Cqupdautooverdraftloadv2_Resp_IB_v1 updateoverdraft(String productid, String caseid,integer mandateNumber){
        Case cs = [Select Id, AccountId, CaseNumber from Case where Id=:caseid];
        List<Account> acc = [Select Id, CIF__c, Does_the_Client_fall_under_the_NCA__c, Client_NCA_Status__c from Account where id=:cs.AccountId];
        User u = [Select Id, EmployeeNumber, SiteType__c, SiteCode__c, Supervisor__c from User where Id=:userinfo.getUserId()];
        Application_Product__c app = [Select Id, Application__c, Account_Number__c, Expiry_Date__c, Review_Date__c, Overdraft_Limit__c, 
                                      Reduction_Amount__c, Enforced_Reducing_Limit__c,Action_Required__c,
                                      Reduction_Date__c, Reduction_Frequency__c, Once_Off_Amount__c, Once_Off_Date__c, Regular_Payday__c,
                                      Opportunity__c, Overdraft_Type__c, Annual_Turnover__c, Number_or_Trustees__c,
                                      Scoring_required__c, Debit_interest_Type__c, Initiation_Fee__c, Effective_Rate__c, Teller_Number__c, Asset_Value__c,
                                      Security_Cession_Indicator__c, Limit_Type__c, Debit_Order_Required__c, 
                                      Alternative_Fund_Code__c,Domicible_Branch_Code__c from Application_Product__c where Id=:productid];
		//application__c application = new ApplicationsSelector().selectByCreditOpportunityId(app.Opportunity__c);
		list<Terms_Of_Business__c> termslist = [Select Id, Final_Offered_Number__c from Terms_Of_Business__c where Application_Product__c=:productid];					  
        Cqupdautooverdraftloadv2_Req_IB_v1 requestnew = new Cqupdautooverdraftloadv2_Req_IB_v1();
        list<Cqupdautooverdraftloadv2_Req_IB_v1.VariableDetailTable> vartablist = new list<Cqupdautooverdraftloadv2_Req_IB_v1.VariableDetailTable>();
        Cqupdautooverdraftloadv2_Req_IB_v1.VariableDetailTable vartab = new Cqupdautooverdraftloadv2_Req_IB_v1.VariableDetailTable();
        vartab.variableLimit = 0;
        vartab.variableEffectiveDate = 0;
        vartablist.add(vartab);
        
        list<Cqupdautooverdraftloadv2_Req_IB_v1.DebitInfoTable> debttablist = new list<Cqupdautooverdraftloadv2_Req_IB_v1.DebitInfoTable>();
        Cqupdautooverdraftloadv2_Req_IB_v1.DebitInfoTable debttab = new Cqupdautooverdraftloadv2_Req_IB_v1.DebitInfoTable();
        debttab.debitBalance = 0;
        debttab.debitOffset = 0.0;
        debttab.debitEffectiveRate = 0.0;
        debttablist.add(debttab);
        
        Cqupdautooverdraftloadv2_Req_IB_v1.InputAreaCopybook req = new Cqupdautooverdraftloadv2_Req_IB_v1.InputAreaCopybook();
        if(app.Account_Number__c!=NULL){
           req.accountNumber = long.valueof(String.valueof(app.Account_Number__c));
        }
        req.processingSite = u.SiteCode__c!=NULL?Integer.valueof(u.SiteCode__c):8392; // (Need to Check - Domicile)
        req.branchCode= app.Domicible_Branch_Code__c!=NULL?Integer.valueof(app.Domicible_Branch_Code__c):8392;
        
        req.processingSiteType = u.SiteType__c!=Null?u.SiteType__c:'034';
        req.agencyCode=8392; // Optional Default is 34 (Problem)//Use 113 if 34 is not working
        req.workstationNumber= '99'; // Default is 99
        req.supervisorCode= u.Supervisor__c!=NULL?Integer.valueof(u.Supervisor__c):1; 
        req.overdraftLimitRequiredAmount= app.Overdraft_Limit__c!=NULL?Integer.valueof(app.Overdraft_Limit__c):0; //need more information
        String expdate;
        if(app.Expiry_Date__c!=NULL){
             expdate = getFormattedDate(app.Expiry_Date__c);
        }
        req.expiryDate= expdate!=Null?Integer.valueof(expdate):99999999;
        String revdate;
        if(app.Review_Date__c!=NULL){
            revdate = getFormattedDate(app.Review_Date__c);
        }
        req.reviewDate= revdate!=Null?Integer.valueof(revdate):0;
        req.securityRequiredIndicator= 'N'; //Default is "N"
        req.securityAmount= 0; //Default is 0;
        req.overdraftStatus= 'GRNT'; //Default is GRNT
        req.dayLimitRequiredAmount= 0; //Default is 0
        req.dayLimitExpiryDate= 0; //Default is 0
        if(app.Overdraft_Type__c =='Reducing' && app.Reduction_Amount__c!=NULL){
           req.reductionAmount= Integer.valueof(app.Reduction_Amount__c); //Need to check
        }
        else{
           req.reductionAmount=0; 
        }
        req.reductionFrequency= app.Reduction_Frequency__c!=NULL?app.Reduction_Frequency__c:''; //Need to check
         String reddate;
        if(app.Reduction_Date__c!=NULL){
            reddate = getFormattedDate(app.Reduction_Date__c);
         }
        req.reductionEffectiveDate= reddate!=Null?Integer.valueOf(reddate):0;
        req.onceOffReductionAmount= app.Once_Off_Amount__c!=NULL?Integer.valueof(app.Once_Off_Amount__c):0;
        String onceoffdate;
        if(app.Once_Off_Date__c!=NULL){
           onceoffdate = getFormattedDate(app.Once_Off_Date__c);
           
        }
        req.onceOffReductionEffectiveDate= onceoffdate!=Null?Integer.valueof(onceoffdate):0;
       /* if(termslist!=NULL && termslist.size()>0 && termslist[0].Final_Offered_Number__c!=NULL){
           req.overdraftGranted= Integer.valueof(termslist[0].Final_Offered_Number__c);
        }
        else{
           req.overdraftGranted=50000; 
        }*/
        req.overdraftGranted = app.Overdraft_Limit__c!=NULL?Integer.valueof(app.Overdraft_Limit__c):0;
        req.reductionLimitEnforced= app.Enforced_Reducing_Limit__c!=Null?app.Enforced_Reducing_Limit__c:'N';
        req.employeeNumber= u.EmployeeNumber!=NULL?Integer.valueof(u.EmployeeNumber):1189895;
        
        req.mandateNumber= mandateNumber!=NULL?mandateNumber:113;
        
        req.regularPayDay= 0;
        
        req.repaymentEffectiveDate= 0; //Default is 0
        req.repaymentFrequency = ''; //Default is empty string
        req.tellerNumber= app.Teller_Number__c!=NULL?Integer.valueof(app.Teller_Number__c):60;//Integer.valueof(app.Teller_Number__c);//Need to check again
       
        req.controllerNumber= 6;  //Leave it blank 
        req.corpCode= 'ABS'; //default is ABS
        // req.applicationNumber= Application.Stock_Number__c!=NULL?Long.valueof(Application.Stock_Number__c):0;
        //req.quoteNumber= cs.CaseNumber!=NULL?Integer.valueof(cs.CaseNumber.replaceAll('C-', '')):0;
        req.applicationNumber=0;
        req.quoteNumber= 0; 
        if(app.Action_Required__c=='Increase Overdraft'){
          req.action= '4'; //1 is add overdraft, 4 is increase overdraft need more info  
        }
        else if(app.Action_Required__c=='Add New Overdraft'){
          req.action= '1'; //1 is add overdraft, 4 is increase overdraft need more info  
        }
        
        if(app.Overdraft_Type__c =='Fixed'){
           req.overdraftType= 2;
        }
        else if(app.Overdraft_Type__c =='Indefinite'){
           req.overdraftType= 1;
        }
        else if(app.Overdraft_Type__c.contains('REDUCING')){//need to verify again
           req.overdraftType= 3;
        }
       /* else if(app.Overdraft_Type__c =='Reducing - Once Off And Recurring'){
           req.overdraftType= 3;
        }*/
        else if(app.Overdraft_Type__c =='Variable'){
           req.overdraftType= 4;
        }
        req.armsLengthIndicator= 'N'; //Default is Y
        if(acc!=NULL && acc.size()>0){
          req.stateOrOrganIndicator= 'N';//Default is N
          req.allTrusteesPrivateIndividuals= 'N';
          req.ncaRequiredIndicator= acc[0].Does_the_Client_fall_under_the_NCA__c?'Y':'N';
        }else{
            req.stateOrOrganIndicator= 'N';
            req.allTrusteesPrivateIndividuals= 'N';
            req.ncaRequiredIndicator = 'N';
        }
        req.annualTurnover= app.Annual_Turnover__c!=Null?Integer.valueof(app.Annual_Turnover__c):0;
        
        req.netAssetValue= app.Asset_Value__c!=Null?Integer.valueof(app.Asset_Value__c):0;
        
        req.numberOfTrustees= app.Number_or_Trustees__c!=Null?Integer.valueOf(app.Number_or_Trustees__c):0;
        
        req.defaultedOverdraft= 'N'; //Default is N
        req.pricingIndicator= 0;// Need to recheck 
        if(acc!=NULL && acc.size()>0 && String.isNotBlank(acc[0].Client_NCA_Status__c)){
            req.ncaInOutIndicator = acc[0].Client_NCA_Status__c=='Yes'?'I':'O';
        }else{
          req.ncaInOutIndicator= 'O';
        }
        req.espIndicator= 'Y';
        req.scoringRequiredIndicator= 'N';//default to Y
        req.paymentStructure= 'N';//default to N
        req.factor= 0;
        req.fixedAmount= 0;
        req.creditLifeIndicator= 'N'; //default is N
        req.debitOrderIndicator= 'N'; //default is N
        req.instalmentAmount= 0;
        req.creditLifePremium= 0; //default is 0
        req.overdraftLedgerFee= 0;//Need to check again
        req.debitInterestType= 'P';
        req.initiationFee= app.Initiation_Fee__c!=NULL?Integer.valueof(app.Initiation_Fee__c):0;
        
        req.debitPrimeRate= app.Effective_Rate__c!=null?app.Effective_Rate__c:10.35;
        req.numberOccurance= 1; //default is 1 
        req.settlementTotal=0;
        if(acc!=NULL && acc.size()>0 && String.isNotBlank(acc[0].CIF__c)){
           req.clientKey=acc[0].CIF__c;
        }
        else{
            req.clientKey='BLACK  025';
        }
        req.agreementType='S';
       req.creditLifeNetPremium=0; //default is 0
        req.creditLifeCommission=0; //default is 0
       req.creditLifePolicyFee=0; //default is 0
        req.debitIntBalanceMethod='M';
        req.debitIntRateStructure='S';
        req.pnlInterestType='F';
        req.pnlInterestRatePercentage=10.0000;
        req.effectiveRate=app.Effective_Rate__c!=Null?app.Effective_Rate__c:20.000;
        req.securityProvided='N'; //default to N need to discuss
        req.excessFee=69;
        req.empowermentFund=app.Alternative_Fund_Code__c!=Null?app.Alternative_Fund_Code__c:'';
        req.overdraftFacilityFee=0;
        req.variableDetailTable = vartablist;
        system.debug('vartablist'+vartablist);
        req.debitInfoTable = debttablist;
        system.debug('debitInfoTable'+debttablist);
        
        Cqupdautooverdraftloadv2_Req_IB_v1.InputHeaders inputhead = new Cqupdautooverdraftloadv2_Req_IB_v1.InputHeaders();
        inputhead.channelName = 'ESP'; 
        inputhead.applicationName = 'ESP';
        inputhead.traceIndicator = 'Y';
        
        Cqupdautooverdraftloadv2_Req_IB_v1.ErrorMessageCopybook errcopybook = new Cqupdautooverdraftloadv2_Req_IB_v1.ErrorMessageCopybook();
        errcopybook.errorMessageLanguage = 'E';
        errcopybook.errorMessageTarget = 'STD';
        
        Cqupdautooverdraftloadv2_Req_IB_v1.NBSAPDPI reqmain1 = new Cqupdautooverdraftloadv2_Req_IB_v1.NBSAPDPI();
        reqmain1.inputHeaders = inputhead;
        
        Cqupdautooverdraftloadv2_Req_IB_v1.NBSMSGI reqmain2 = new Cqupdautooverdraftloadv2_Req_IB_v1.NBSMSGI();
        reqmain2.ErrorMessageCopybook = errcopybook;
        
        Cqupdautooverdraftloadv2_Req_IB_v1.CQS573I reqmain3 = new Cqupdautooverdraftloadv2_Req_IB_v1.CQS573I();
        reqmain3.inputAreaCopybook = req;
        
        requestnew.NBSAPDPI = reqmain1;
        requestnew.NBSMSGI = reqmain2;
        requestnew.CQS573I = reqmain3;
        system.debug('reqmain1'+reqmain1);
        system.debug('reqmain2'+reqmain2);
        system.debug('reqmain3'+reqmain3);
        system.debug('test '+JSON.serializePretty(requestnew));
        Cqupdautooverdraftloadv2_Resp_IB_v1 resp = Cqupdautooverdraftloadv2_IH_v1.executeService(requestnew);
        system.debug('test '+JSON.serializePretty(resp));
        
        return resp;
    }
}