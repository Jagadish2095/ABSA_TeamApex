/**
 * @description Controller for onboardingSPMRiskProfileCalculation Component
 * @author  Diksha Wasekar : Absa
 * @version v1.0
 * @since   2020-11-11
 * @modified Haritha P
 */
public class onboardingSPMRiskProfileCalculation {
    /** 
    * @description get Account Record
    * @param oppId
    * @return Account
    */
    @AuraEnabled
    public static Account getAccount(Id oppId) {
        Account acc=new AccountsSelector().selectByOpportunityId(oppId);
        return acc;     
        
    }
    /** 
    * @description get Opportuntiy Record
    * @param recId
    * @return Opportunity
    */
    @AuraEnabled
    public static Opportunity getOpp(Id recId) {
        Opportunity opp=new OpportunitiesSelector().selectByOppId(recId);
        return opp;     
        
    }  
    /** 
    * @description get Opportuntiy Record
    * @param oppId
    * @return Opportunity
    */
    @AuraEnabled
    public static Application__c getAppRec(Id oppId) {
        List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(oppId);
        return app[0];     
        
    }   
    /** 
    * @description get Application_Product__c Record
    * @param oppId
    * @return Application_Product__c
    */
    @AuraEnabled
    public static Application_Product__c getAppPrdctRec(Id oppId) {
        List<Application_Product__c> appPrdctRec= new ApplicationProductSelector().selectByOpportunityId(oppId);
        return appPrdctRec[0];    
        
    }   
    /** 
    * @description updating application record
    * @param intendedInvestmentTerm
    * @param investmentExperience
    * @param understandFinancialMarketsandInvest
    * @param investmentOpportunities
    * @param numberOfDependants
    * @param relationToInflation
    * @param liquidityToCoverEmergencies
    * @param appRecid
    * @return Application_Product__c
    */
    @AuraEnabled
    public static string updateAppDetails(string intendedInvestmentTerm, string investmentExperience,string understandFinancialMarketsandInvest,
                                          string investmentOpportunities, string numberOfDependants,string relationToInflation,
                                          string liquidityToCoverEmergencies,Id appRecid)
    {
        
        try{
            Application__c app=new ApplicationsSelector().selectById(appRecid);
            if(app!=null){
               app.What_is_the_intended_investment_term__c= intendedInvestmentTerm;
                app.What_investment_experience_do_you_have__c= investmentExperience;
                app.understand_financial_markets_and_investm__c= understandFinancialMarketsandInvest;
                app.investment_opportunities__c= investmentOpportunities;
                app.Number_of_dependants__c= numberOfDependants;
                app.income_grow_in_relation_to_inflation__c= relationToInflation;
                app.liquidity_to_cover_emergencies__c= liquidityToCoverEmergencies;
                Update app;
            }
            return 'SUCCESS';
        }catch(Exception e){
            system.debug(e.getMessage());
            return 'FAILURE';
        }
        
    }
    /** 
    * @description get Opportunity Record
    * @param oppId
    * @return Opportunity
    */
  @AuraEnabled 
    public static Opportunity getradiobtn(String oppId){ 
        opportunity opprec=[select Id,Name,Client_Or_Person_On_US_Citizenship__c from Opportunity where Id=:oppId];
        return opprec;
    }
    /** 
    * @description get List<User> Record
    * @param 
    * @return List<User>
    */
    @AuraEnabled 
    public static List<User> getWealthManagerlist(){ 
        List<User>   wmuserList =NEW UsersSelector().selectByroleId(UserInfo.getUserId(),'Banker');
        
        return wmuserList;
    }
    /** 
    * @description get List<User> Record
    * @param 
    * @return List<User>
    */
    @AuraEnabled 
    public static List<User> getFinancialInvestmentAdvisorlist(){ 
        List<User>   lfuserList =NEW UsersSelector().selectByroleId(UserInfo.getUserId(),'RB Advisory-Financial Adviser-Adviser-KwaZulu Natal');
        
        return lfuserList;
    }
    
    /*@AuraEnabled
    public static Opportunity updateOpp(String recId, string spmregion,Date pasportexpiry,string appSource,string platform,string productwrapper,string housePortfolio,string inFinAdvisor,string prinumber,Boolean cmplxapp){
       Opportunity opp=new OpportunitiesSelector().selectByOppId(recId);
        Account acc=new AccountsSelector().selectAllById(opp.AccountId);
        acc.SPM_region__c= spmregion;
        acc.Passport_Expiry_Date__c=pasportexpiry;
        update acc;
        try{
        if(opp!=null){
            opp.Application_Source__c = appSource;
           // opp.Platform__c = platform;
            opp.Product_Wrapper__c = productwrapper;
            opp.House_Portfolio__c = housePortfolio;
            opp.Independent_Financial_Advisor__c = inFinAdvisor;
            opp.PRI_Number__c =prinumber;
            opp.Account.Id= acc.Id;
            opp.Account.SPM_region__c= acc.SPM_region__c;
            opp.Account.Passport_Expiry_Date__c= acc.Passport_Expiry_Date__c;
           if(cmplxapp== True){
                opp.Complex_Application_Approval__c = True;
                SendEmailforpassportExpiry(opp.Id);
            }else if(cmplxapp== false){
                opp.Complex_Application_Approval__c = False;
            }*/
            //system.debug('platform'+opp.Platform__c);
            
           /* Application__c   application = new Application__c();
            application.Opportunity__c = opp.Id;
            INSERT application;*/
            /*update opp;
         }
        system.debug('opp'+opp.House_Portfolio__c);
        system.debug('acc'+acc);
        return opp;
            }catch(Exception e){
            system.debug(e.getMessage());
            return null;
        }
        
    }*/
    /** 
    * @description get Opportunity Record
    * @param recId
    * @param IsstageClosed
    * @param Isotherbankoptiongiven
    * @return Opportunity
    */
    @AuraEnabled
    public static Opportunity updateOppStage(String recId,Boolean IsstageClosed,Boolean Isotherbankoptiongiven){
        system.debug('IsstageClosed'+IsstageClosed);
        Opportunity opp=new OpportunitiesSelector().selectByOppId(recId);
        try{
        if(opp!=null && IsstageClosed ==True ){
            opp.StageName ='Closed Lost';
            opp.Client_Or_Person_On_US_Citizenship__c='Yes';
            opp.Loss_Reason_Type__c = 'Client is a US citizen or has relations with US citizens';
        }else If(opp!=null && IsstageClosed ==False){
            opp.StageName ='Confirm Client Eligibility';
            opp.Client_Or_Person_On_US_Citizenship__c='No';
            opp.Loss_Reason_Type__c = '';
        }
         if(opp!=null && Isotherbankoptiongiven ==True && IsstageClosed ==False ){
            opp.StageName ='Closed Lost';
            opp.Client_Has_Accs_Prdcts_Relationship_Bank__c='Yes';
             opp.Loss_Reason_Type__c = 'Client has had their bank accounts / products / relationships closed on instruction from their banks';
        }else If(opp!=null && Isotherbankoptiongiven ==False && IsstageClosed ==False){
            opp.StageName ='Confirm Client Eligibility';
            opp.Client_Has_Accs_Prdcts_Relationship_Bank__c='No';
            opp.Loss_Reason_Type__c = '';
        }
        system.debug('opp last'+opp.StageName);
            update opp;
        return opp;
        }catch(Exception e){
            system.debug(e.getMessage());
            return null;
        }

        
    }
    /** 
    * @description get Application__c Record
    * @param oppId
    * @return Application__c
    */
    @AuraEnabled
    public static Application__c CalculateScore(string oppId){
        
        String messageText ; //to store Service Response message
      List< Application__c> app=new ApplicationsSelector().selectByOpportunityOnboardId(oppId);
         system.debug('app'+app);
        List<Sys_Log_Integration__c> SysLog =[SELECT Id, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastReferencedDate, Destination_System__c, Initiator__c, Log_Type__c, Method_Name__c, Request_Timestamp__c, Response_Timestamp__c, Response__c, Sender__c, Source_System__c, Status_Code__c, Status__c, User_Name__c FROM Sys_Log_Integration__c where 
                                              Method_Name__c='Risk Profile Score' And Status_Code__c=200];
        system.debug('SysLog'+SysLog);
        if(!app.isEmpty() && app !=null){
        String questionOne=app[0].What_is_the_intended_investment_term__c.SubString(0,1) ;
        if(questionOne == null){
            questionOne = '';
        }
        system.debug('questionOne'+questionOne);
        String questionTwo=app[0].What_investment_experience_do_you_have__c.SubString(0,1) ;
        if(questionTwo == null){
            questionTwo = '';
        }
        system.debug('questionTwo'+questionTwo);
        
        String questionThree=app[0].understand_financial_markets_and_investm__c.SubString(0,1) ;
        if(questionThree == null){
            questionThree = '';
        }
        system.debug('questionThree'+questionThree);
        
        String questionFour=app[0].investment_opportunities__c.SubString(0,1) ;
        if(questionFour == null){
            questionFour = '';
        }
        String questionFive=app[0].Number_of_dependants__c.SubString(0,1) ;
        if(questionFive == null){
            questionFive = '';
        }
        String questionSix=app[0].income_grow_in_relation_to_inflation__c.SubString(0,1) ;
        if(questionSix == null){
            questionSix = '';
        }
        String questionSeven=app[0].liquidity_to_cover_emergencies__c.SubString(0,1) ;
        if(questionSeven == null){
            questionSeven = '';
        }
        
        
        try{
            RiskProfileScore_Resp_IB_V1 responseBean = RiskProfileScore_IH_V1.RiskProfileScore(questionOne, questionTwo, questionThree, questionFour, questionFive, questionSix, questionSeven);
            
            // String messageText ; //to store Service Response message
            if((responseBean != Null ) && (responseBean.statusCode == 200) ){
                System.debug('#####' + responseBean.serialize(responseBean) + '#####');
                messageText = responseBean.Body[0].result;
                
            }
            else{
                messageText = 'Risk Profile Score service failed';
            }
            app[0].Total_Score__c=messageText;
            for(Sys_Log_Integration__c sys:SysLog ){
            system.debug('sys.Response_Timestamp__c.date()'+sys.Response_Timestamp__c.date());
            app[0].Date_of_Completion__c= sys.Response_Timestamp__c.date();
            }
            update app[0];
            
        } 
        
        catch(Exception e){
            System.debug('Exception Occured' + e.getMessage() + 'At Line number' + e.getLineNumber());
            throw new AuraHandledException('Something went wrong: '+ e.getMessage());
        }
        }
        return app[0];
 
    }
    
    /** 
    * @description get recId Record
    * @param recId
    */
    public static void SendEmailforpassportExpiry(Id recId){
      Messaging.SingleEmailMessage message = new   Messaging.SingleEmailMessage();
        Id targetObjectId = [Select id from Contact where Email != '' limit 1].Id; //get any dummy contact just for sake of passing it
        message.setTargetObjectId(targetObjectId); 
        message.setTreatTargetObjectAsRecipient(false);
        EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name = 'SPM Passport Expiry Date'];
        message.setTemplateID(emailTemplate.Id); 
        message.setWhatId(recId); //This is important for the merge fields in template to work
        
        message.toAddresses = new String[] {'RMS@absa.co.za','spmfica@absa.co.za'};
            String htmlBody1 = message.getHTMLBody();
        // string addMaskedPassportExpiryInEmailBody =  htmlBody.replace('[passportExpiryDate]', passportExpiryDate);
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        
        if (results[0].success) 
        {
            System.debug('The email was sent successfully.');
        } else {
            System.debug('The email failed to send: ' +  results[0].errors[0].message);
        }
    }
    /** 
    * @description dummy refresh
    * @param
    */
     @AuraEnabled
    public static void dummyRefresh() {
        //this is a dummy refresh
    }
     /** 
    * @description Diksha W-007104 11/9/2020
    * @param purposeOfAcc
    * @param purposeOfAcctText
    * @param accActTracker
    * @param appRecid
    * @return applicationRecord
    */ 
    @AuraEnabled
    public static string updateAppRec(string purposeOfAcc, string purposeOfAcctText,string accActTracker,
                                      Id appRecid)
    {
        
        try{
            Application__c app=new ApplicationsSelector().selectById(appRecid);
            if(app!=null){
                app.Purpose_of_Account__c  = purposeOfAcc;
                app.Purpose_of_Account_Text__c= purposeOfAcctText;
                app.Account_Activity_Calculator__c= accActTracker;
                Update app;
            }
            return 'SUCCESS';
        }catch(Exception e){
            system.debug(e.getMessage());
            return 'FAILURE';
        }
        
    }
     /** 
    * @description Application_Product__c
    * @param oppId
    * @param managmenttype
    * @param spmregion
    * @param pasportexpiry
    * @param appSource
    * @param productwrapper
    * @param housePortfolio
    * @param inFinAdvisor
    * @param prinumber
    * @param cmplxapp
    * @return Application_Product__c
    */ 
     @AuraEnabled
    public static Application_Product__c updateAppPrdctRec(Id oppId,string managmenttype,string spmregion,Date pasportexpiry,string appSource,string productwrapper,string housePortfolio,string inFinAdvisor,string prinumber,Boolean cmplxapp)
    {
        system.debug('oppId'+oppId);
        try{
            Opportunity opp=new OpportunitiesSelector().selectByOppId(oppId);
            List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(oppId);
            List<Application_Product__c> appPrdctRec= new ApplicationProductSelector().selectByOpportunityId(oppId);
             Account acc=new AccountsSelector().selectAllById(opp.AccountId);
        	 acc.SPM_region__c= spmregion;
        	 acc.Passport_Expiry_Date__c=pasportexpiry;
        	 update acc;
            if(appPrdctRec[0]!=null){
                appPrdctRec[0].Management_Type_Managed_Code__c  = managmenttype;
                appPrdctRec[0].Application_Source__c = appSource;
               appPrdctRec[0].Independent_Financial_Advisor__c = inFinAdvisor;
                appPrdctRec[0].PRI_Number__c =prinumber;
                opp.Account.Id= acc.Id;
                opp.Account.SPM_region__c= acc.SPM_region__c;
                opp.Account.Passport_Expiry_Date__c= acc.Passport_Expiry_Date__c;
               if(cmplxapp== True){
                    opp.Complex_Application_Approval__c = True;
                    SendEmailforpassportExpiry(opp.Id);
                }else if(cmplxapp== false){
                    opp.Complex_Application_Approval__c = False;
                }
				app[0].Platform__c=acc.SPM_Platform_Type__c;
                app[0].Product_Wrapper__c = productwrapper;
                app[0].House_Portfolio__c = housePortfolio;
                update app[0];
                Update appPrdctRec[0];
                update opp;
            }
            system.debug('app[0]'+app[0]);
            return appPrdctRec[0];
        }catch(Exception e){
            system.debug(e.getMessage());
            return null;
        }
    } 
}