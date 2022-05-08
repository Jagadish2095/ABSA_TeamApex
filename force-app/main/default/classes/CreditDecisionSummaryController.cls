/**
 * @description       : Lightning Component Controller for Decision Summary (Origination)
 * @UserStory W-005392, W-006316, W-008774, W-008800, W-005111, W-003820, W-005171, W-006299,  W-008775 , (W-006999)
 * @author            : Himanshu Nimje
 * @last modified on  : 2021-11-26
 * @last modified by  : luluwitney.rankwe@absa.africa
 * Modifications Log
 * Ver   Date         Author         Modification
 * 1.0   2021-07-12   Himani Joshi   Initial Version
**/

public class CreditDecisionSummaryController {

    /**
    * @description : Method to get application record
    * @author Himanshu Nimje | 2021-07-12
    * @param oppId
    * @return Application__c
    **/
    @AuraEnabled
    public static Application__c GetApplication(Id oppId) {
        Application__c applicationRec = [SELECT Id, Name, Credit_Application_Accepted__c, Credit_Application_Accepted_DateTime__c,Credit_Application_Acceptedby__c,
                                         Application_Number__c, External_Reference_Number__c
                                         FROM Application__c where Opportunity__c=:oppId  LIMIT 1  ];
        return applicationRec;
    }

    /**
    * @description : Method to get opportunity record
    * @author Himanshu Nimje | 2021-07-12
    * @param oppId
    * @return Opportunity
    **/
    @AuraEnabled
    public static Opportunity GetOpportunity(Id oppId) {
        Opportunity oppRec = [SELECT Id, Sanction_Region__c,Is_Submitted_FulFilment__c, Name,More_Info_Submitted_Date_Time__c,Pricing_Referred_By__c, Is_Submitted_Sanctioning__c,Credit_Application_Refferedby__c,
                              Sanctioning_Refer_DateTime__c,More_Info_Decision__c,Is_Referred_Pricing__c,Pricing_Refer_DateTime__c
                              from Opportunity where Id=:oppId LIMIT 1 ];
        return oppRec;
    }



    /**
    * @description : Method to get updated application
    * @author Himani Joshi | 2021-07-12
    * @param oppId
    * @return Application__c
    **/
    @AuraEnabled
    public static Application__c GetUpdatedApplication(Id oppId) {
        Application__c app = new ApplicationsSelector().selectByCreditOpportunityId(oppId);
        Application_scoring__c appScore = [select Id from application_scoring__c where stage__c='5' and Application_Number__c=:app.Id];
        Application_Scoring_Entity__c appEntity = [select Id,Enforce_Rework__c,Lookup_Period__c from Application_Scoring_Entity__c where Entity_Number__c='1' and Application_Scoring__c=:appScore.Id];
        List<String> bureauList = new List<String>();
        Application_profile__c appProfile = [select Bureau_JSON_Response__c from Application_profile__c where application__c=:app.Id and applicant_type__c='Main Applicant'];
        if(appProfile.Bureau_JSON_Response__c != null || String.isNotBlank(appProfile.Bureau_JSON_Response__c)){
            ConsumerBureauEnquiry_Resp_IB_v1 responseBean = (ConsumerBureauEnquiry_Resp_IB_v1) JSON.deserialize(appProfile.Bureau_JSON_Response__c, ConsumerBureauEnquiry_Resp_IB_v1.class);
            string appDate = responseBean.Response.ApplicationDV.APPDATE;
            app.Lookup_Period__c = appEntity.Lookup_Period__c;
            app.Enforce_Rework__c = appEntity.Enforce_Rework__c;
           if(appDate !=null)
           {app.Bureau_Date__c = date.valueOf(appDate);
            app.NoOfDaysSinceBureauDate__c = app.Bureau_Date__c.daysBetween(Date.today());
            
           }
        }
        try{
            update app;
        }
        catch(Exception e){
            throw new AuraHandledException('Error message to display in component'+e.getMessage());
        }
       // system.debug('app'+json.serializepretty(app));
        return app;

    }


    /**
    * @description : Method to update application
    * @author Himanshu Nimje | 2021-07-12
    * @param oppId
    * @return String
    **/
    @AuraEnabled
    public static String UpdateApplication(Id oppId) {
        Application__c updateApp=new Application__c();
        Application__c applicationRec = [SELECT Id,  Credit_Application_Accepted__c, Credit_Application_Accepted_DateTime__c,
                                         Credit_Application_Acceptedby__c FROM Application__c where Opportunity__c=:oppId  LIMIT 1 ];
        User u = [select id, Name from User where id = :userInfo.getUserId()];

        List<Application_Product__c> appPrdList = [Select id, Name ,Product_Name__c,Account_Number__c,Product_Status__c,Application_Product_Parent__c
                                                   from Application_Product__c Where opportunity__c= :oppId and  Application_Product_Parent__c = null ];


        if(appPrdList.size() > 0){
            for(Application_Product__c appProd:appPrdList){
                if(appProd.Product_Status__c=='Not Taken Up')
                    appProd.Product_Status__c = 'Withdraw';

            }
        }
        updateApp.Id=applicationRec.Id;
        updateApp.Credit_Application_Accepted__c=true;
        updateApp.Credit_Application_Accepted_DateTime__c=datetime.now();
        updateApp.Credit_Application_Acceptedby__c=u.Name;

        try {
            update updateApp;
            //Added by Himanshu -W-011453
            CreditDecisionSummaryController.submitActivityHistory(oppId, 'Activity History', 'Accept Decision',u.Name, '0');
            if(appPrdList.size() > 0){
                update appPrdList;
            }
            return 'Success';
        }
        catch (Exception ex) {
            //system.debug(' Meesage :' + +ex.getDmlMessage(0));
            return ' Please Try Again..Error in Updating the Application Status: ' + ex.getDmlMessage(0);
        }

    }


    /**
    * @description : Method to get appScoring record
    * @author Himanshu Nimje| 2021-07-12
    * @param oppId
    * @return List<Application_Scoring__c>
    **/
    @AuraEnabled
    public static List<Application_Scoring__c> GetDecisionSummary(Id oppId) {
        Application__c application = new ApplicationsSelector().selectByCreditOpportunityId(oppID);
        List<Application_Scoring__c> appScoring = [SELECT Id, stage__c, SYST_Decision__c,SYST_Decision_Date__c,SYST_Decision_Time__c, ASV_Shortfall_Amount__c,
                                                   ASV_Shortfall_Amount_after_Tolerance__c, ASV_Offered__c, Application_Number__c
                                                   from Application_Scoring__c
                                                   where Application_Number__c=:application.Id  and stage__c='7'];
        



        if(appScoring.size() > 0){
            return appScoring;
        }
        return null;
    }

    /**
    * @description : Method to get decision time
    * @author Himanshu Nimje| 2021-07-12
    * @param oppId
    * @return string
    **/
    @AuraEnabled
    public static string getDecisionTime(Id oppId) {
        Application__c application = new ApplicationsSelector().selectByCreditOpportunityId(oppID);
        List<Application_Scoring__c> appScoring = [SELECT Id, stage__c,SYST_Decision_Time__c ,Application_Number__c
                                                   from Application_Scoring__c
                                                   where Application_Number__c=:application.Id  and stage__c='7'];
        
        if(appScoring.size() > 0){
            string decTime=string.valueOf(appScoring[0].SYST_Decision_Time__c);
            
            return decTime;
        }
        return null;
    }


    /**
    * @description : Method to get requested product
    * @author Himanshu Nimje | 2021-07-12
    * @param oppId
    * @return List<ProductDataWrapper>
    **/
    @AuraEnabled
    public static List<ProductDataWrapper> getRequestedProduct(Id oppId) {
        // for Cheque and OverDraft , Doing Operation on Draft child  records for updation of Status
        List<Application_Product__c> appPrdList = [SELECT Id, Application_Product_Parent__c, Product_Name__c, Product_Amount__c, Temp_Account_Number__c, Product_State__c, System_Decision__c, Final_Decision__c, Product_Status__c,Product_Type__c,Account_Number__c,
                                                   Application_Product_Parent__r.Product_Name__c,Business_Credit_Card_Sub_Product_Type__c,
                                                   Requested_facility_limit__c,
                                                   toLabel(Application_Product_Parent__r.Product_Type__c), Application_Product_Parent__r.Temp_Account_Number__c,
                                                   Application_Product_Parent__r.Product_State__c,
                                                   Application_Product_Parent__r.System_Decision__c,
                                                   Application_Product_Parent__r.Final_Decision__c,
                                                   Application_Product_Parent__r.Product_Status__c,
                                                   Application_Product_Parent__r.Account_Number__c,
                                                   Opportunity__c,Facility_account_number__c,Facility_limit__c
                                                   FROM Application_Product__c
                                                   WHERE Opportunity__c = :oppId and (Application_Product_Parent__c != null OR Product_Name__c = 'Credit Card' OR Product_Name__c = 'Bank Guarantee' OR Product_Name__c = 'Term Loan')]; //
        
        List<ProductDataWrapper> RequestedApplicationProduct = new List<ProductDataWrapper>();
        for(Application_Product__c product : appPrdList){
           
            String nameConcat = '';
            ProductDataWrapper productData = new ProductDataWrapper();

            if(product.Application_Product_Parent__c != null){
                nameConcat = product.Application_Product_Parent__r.Product_Name__c + ' ' + product.Product_Name__c;
                productData.productType = product.Application_Product_Parent__r.Product_Type__c;
                productData.systemDecision = product.Application_Product_Parent__r.System_Decision__c;
                productData.finalDecision = product.Application_Product_Parent__r.Final_Decision__c;
                productData.productStatus = product.Application_Product_Parent__r.Product_Status__c;
                productData.productState = product.Application_Product_Parent__r.Product_State__c;

                if(product.Application_Product_Parent__r.Product_State__c != null && product.Application_Product_Parent__r.Product_State__c.equals('New')){
                    productData.productAccountNumber = 'CHQ-' + product.Application_Product_Parent__r.Temp_Account_Number__c; //  product.Temp_Account_Number__c Need to check
                } else if(product.Application_Product_Parent__r.Product_State__c != null && product.Application_Product_Parent__r.Product_State__c.equals('Existing')){
                    productData.productAccountNumber = product.Application_Product_Parent__r.Account_Number__c != null ? String.valueOf(product.Application_Product_Parent__r.Account_Number__c) : null;
                }
            } else {
                nameConcat = product.Product_Name__c;
                productData.productType = product.Business_Credit_Card_Sub_Product_Type__c;
                productData.systemDecision = product.System_Decision__c;
                productData.finalDecision = product.Final_Decision__c;
                productData.productStatus = product.Product_Status__c;
                productData.productState = product.Product_State__c;
                productData.productAmount = product.Product_Amount__c;

                if(product.Product_State__c != null && product.Product_State__c.equals('New')){
                    if(product.Product_Name__c != null && product.Product_Name__c.equals('Credit Card')) {
                        productData.productAccountNumber = 'CC-' + product.Temp_Account_Number__c; //  product.Temp_Account_Number__c Need to check
                    }if(product.Product_Name__c != null && product.Product_Name__c.equals('Bank Guarantee')) {
                        productData.productAccountNumber = 'BG-' + product.Temp_Account_Number__c; //  product.Temp_Account_Number__c Need to check
                    	productData.productAmount = product.Facility_limit__c !=null ?  Decimal.valueOf(product.Facility_limit__c): null;
                    }if(product.Product_Name__c != null && product.Product_Name__c.equals('Term Loan')) {
                        productData.productAccountNumber =  product.Account_Number__c != null ? String.valueOf(product.Account_Number__c) : null; //'TL-' + product.Temp_Account_Number__c; //  product.Temp_Account_Number__c Need to check
                    	productData.productAmount = product.TL_Total_Loan_Amount__c !=null ? product.TL_Total_Loan_Amount__c: null;
                        //productData.productType = product.
                        
                    }
                } else if(product.Product_State__c != null && product.Product_State__c.equals('Existing')){
                     if(product.Product_Name__c == 'Bank Guarantee'){
                         
                         productData.productAccountNumber = product.Facility_account_number__c != null ? String.valueOf(product.Facility_account_number__c) : null;
                    	 productData.productAmount = product.Requested_facility_limit__c !=null ?  Decimal.valueOf(product.Requested_facility_limit__c): null;	
                     }else{
                         
                     
                    productData.productAccountNumber = product.Account_Number__c != null ? String.valueOf(product.Account_Number__c) : null;
                         
                     }
                }
            }
            
            
           

            productData.productName = nameConcat;
            
            productData.Id = product.Application_Product_Parent__c; // Parent Id
            if(product.Product_Name__c == 'Credit Card'){
                 productData.productType = product.Business_Credit_Card_Sub_Product_Type__c;
                 productData.productAmount = product.Requested_facility_limit__c!=null?Decimal.valueof(product.Requested_facility_limit__c):0;
            }
            
            
            RequestedApplicationProduct.add(productData);
        }

        return RequestedApplicationProduct;
    }


    /**
    * @description : Method to get reasons and exceptions
    * @author Himanshu Nimje | 2021-07-12
    * @param oppId
    * @return Map<String, List<String>>
    **/
    @AuraEnabled
    public static Map<String,List<String>> GetReasonsAndExceptions(Id oppId) {
        Map<String,List<String>> responseMap=new Map<String,List<String>>();
        Application__c application = new ApplicationsSelector().selectByCreditOpportunityId(oppId);
        List<Application_Scoring__c>appScoring=new List<Application_Scoring__c>();
        appScoring=[select id,stage__c,Reason__c,Reason_Description__c,Exception__c,Exception_Description__c from Application_Scoring__c where Application_Number__c=:application.Id and stage__c='7' ];
        List<String>ReasonList=new List<String>();
        List<String>ReasonDescriptionList=new List<String>();
        List<String>ExceptionList=new List<String>();
        List<String>ExceptionDescriptionList=new List<String>();
        ReasonList=appScoring[0].Reason__c.split(',');
        ReasonDescriptionList=appScoring[0].Reason_Description__c.split(',');

        if(ReasonDescriptionList.size()>0){
            for(integer i=0;i<ReasonDescriptionList.size();i++){
                if(ReasonDescriptionList[i].contains('&lt;')) {
                    string removeHTMl = ReasonDescriptionList[i];
                    ReasonDescriptionList[i] = removeHTMl.unescapeHtml4();
                }
            }
        }
        ExceptionList=appScoring[0].Exception__c.split(',');
        ExceptionDescriptionList=appScoring[0].Exception_Description__c.split(',');

        if(ExceptionDescriptionList.size()>0){
            for(integer i=0;i<ExceptionDescriptionList.size();i++){
                if(ExceptionDescriptionList[i].contains('&lt;')) {
                    string removeHTMl = ExceptionDescriptionList[i];
                    ExceptionDescriptionList[i] = removeHTMl.unescapeHtml4();
                }
            }
        }

        responseMap.put('ReasonList',ReasonList);
        responseMap.put('ReasonDescriptionList',ReasonDescriptionList);
        responseMap.put('ExceptionList',ExceptionList);
        responseMap.put('ExceptionDescriptionList',ExceptionDescriptionList);
        return responseMap;
    }

    /**
    * @description : Method to get total potential group exposures
    * @author Himanshu Nimje | 2021-07-12
    * @param oppId
    * @return Map<String, List<String>>
    **/
    @AuraEnabled
    public static Map<String,List<String>> getPotTotalGrpExps(Id oppId) {
        Map<String,List<String>> responseMap=new Map<String,List<String>>();
        Application__c application = new ApplicationsSelector().selectByCreditOpportunityId(oppId);
        List<Application_Scoring__c> appScoringReq =[select ReqTotAddPotentialOc__c,ReqPotentialTotGroup__c,ReqPotentialTgae__c,ReqPotentialTgbe__c,ReqPotentialTfl__c from Application_Scoring__c where Application_Number__c=:application.Id and stage__c='1' ];
        List<Application_Scoring__c> appScoringOffered =[select Potential_OC_Offered__c,Potential_TGE_Offered__c,Potential_TGAE_Offered__c,Potential_TGBE_Offered__c,Potential_TGBOE_Offered__c,Offered_Total_Financing_Limit__c from Application_Scoring__c where Application_Number__c=:application.Id and stage__c='7' ];
        List<Application_Scoring__c> appScoringFinal =[select Potential_OC_Final__c,Potential_TGE_Final__c,Potential_TGAE_Final__c,Potential_TGBE_Final__c,Potential_TGBOE_Final__c,Final_Total_Financing_Limit__c from Application_Scoring__c where Application_Number__c=:application.Id and stage__c='7' ];
        
        List<String> RequestedExpList= new  List<String>() ;
        List<String> OfferedExpList = new List<String>();
        List<String> FinalExpnList = new  List<String>();
        RequestedExpList.add(String.valueof(appScoringOffered[0].Potential_OC_Offered__c));
        RequestedExpList.add(String.valueof(appScoringReq[0].ReqPotentialTotGroup__c));
        RequestedExpList.add(String.valueof(appScoringReq[0].ReqPotentialTgae__c));
        RequestedExpList.add(String.valueof(appScoringReq[0].ReqPotentialTgbe__c));
        RequestedExpList.add(String.valueof(appScoringReq[0].ReqPotentialTfl__c));
        OfferedExpList.add(String.valueof(appScoringOffered[0].Potential_OC_Offered__c));
        OfferedExpList.add(String.valueof(appScoringOffered[0].Potential_TGE_Offered__c));
        OfferedExpList.add(String.valueof(appScoringOffered[0].Potential_TGAE_Offered__c));
        OfferedExpList.add(String.valueof(appScoringOffered[0].Potential_TGBE_Offered__c));
        OfferedExpList.add(String.valueof(appScoringOffered[0].Offered_Total_Financing_Limit__c));
        FinalExpnList.add(String.valueof(appScoringFinal[0].Potential_OC_Final__c));
        FinalExpnList.add(String.valueof(appScoringFinal[0].Potential_TGE_Final__c));
        FinalExpnList.add(String.valueof(appScoringFinal[0].Potential_TGAE_Final__c));
        FinalExpnList.add(String.valueof(appScoringFinal[0].Potential_TGBE_Final__c));
        FinalExpnList.add(String.valueof(appScoringFinal[0].Final_Total_Financing_Limit__c));

        responseMap.put('RequestedExpList',RequestedExpList);
        responseMap.put('OfferedExpList',OfferedExpList);
        responseMap.put('FinalExpnList',FinalExpnList);
        return responseMap;
    }

    /**
    * @description : Method to get submission history
    * @author Himanshu Nimje | 2021-07-12
    * @param oppId
    * @return List<Submission_History__c>
    **/
    @AuraEnabled
    public static List<Submission_History__c> GetSubmissionHistory(Id oppId) {
        string version='1';
        List<Submission_History__c> responseSubHistList =new List<Submission_History__c> ();
        List<Submission_History__c> lstofSubHist =new List<Submission_History__c> ();
        Application__c application = new ApplicationsSelector().selectByCreditOpportunityId(oppID);
        List<Application_Scoring__c>appScoring=[select id,stage__c,SYST_Decision__c from Application_Scoring__c where stage__c='7' and Application_Number__c=:application.Id];
        lstofSubHist= [SELECT Id, Name,System_Decision__c FROM Submission_History__c where  type__c='Decision Summary' and Application__c=:application.Id order by Version__c desc];
        if(lstofSubHist.size()==0){
            Submission_History__c sh=new Submission_History__c();
            sh.application__c=application.Id;
            sh.StageId__c=application.name;
            sh.Type__c='Decision Summary';
            sh.Version__c=version;
            sh.Submitted_By__c=application.createdby.name;
            sh.Submitted__c=application.LastModifiedDate;
            sh.System_Decision__c=appScoring[0].SYST_Decision__c;
            insert sh;
        }
        responseSubHistList= [SELECT  Id, Name,StageId__c,Type__c,Version__c,application__c,Submitted_By__c,Submitted__c,System_Decision__c FROM Submission_History__c where Application__c=:application.Id  and type__c='Decision Summary' order by Version__c desc];
        
        return responseSubHistList;
    }


    /**
    * @description : Method is used to get the activity Hostory for Snctioning
    * @author Himanshu Nimje | 2021-07-12
    * @param oppId
    * @return List<Submission_History__c>
    **/
    @AuraEnabled
    public static List<Submission_History__c> GetActivityHistory(Id oppId) {
        string version='1';
        List<Submission_History__c> resActHist = new List<Submission_History__c> ();
        List<Submission_History__c> lstofSubHist = new List<Submission_History__c> ();
        Application__c application = new ApplicationsSelector().selectByCreditOpportunityId(oppId);
        List<Application_Scoring__c> appScoring = [select id,stage__c,SYST_Decision__c from Application_Scoring__c where stage__c='7' and Application_Number__c=:application.Id];
        // if(appScoring.size() > 0){
        lstofSubHist= [SELECT Id, Name,System_Decision__c FROM Submission_History__c where  type__c='Activity History' and Application__c=:application.Id order by Version__c desc];
        if(lstofSubHist.size() == 0){
            Submission_History__c sh = new Submission_History__c();
            sh.application__c = application.Id;
            sh.StageId__c = application.name;
            sh.Type__c = 'Activity History';
            sh.Version__c = version;
            sh.Submitted_By__c = 'PowerCurve';
            sh.Submitted__c = application.LastModifiedDate;
            sh.Action__c = 'System Decison' +' '+appScoring[0].SYST_Decision__c;
            insert sh;
        }
        resActHist = [SELECT  Id, Action__c, Type__c, Version__c,application__c,Submitted_By__c,Submitted__c FROM Submission_History__c
                      where Application__c=:application.Id  and type__c='Activity History' order by Submitted__c desc];
        
        return resActHist;
        /*  }
else{
return null;
} */
    }

    /**
    * @description : Method to submit activity history
    * @author Himanshu Nimje | 2021-07-12
    * @param oppId
    * @param type
    * @param Action
    * @param submittedBy
    * @param version
    **/
    @AuraEnabled
    public static void submitActivityHistory(Id oppId, string type, string Action, string submittedBy, string version) {

        Application__c application = new ApplicationsSelector().selectByCreditOpportunityId(oppId);
        if(version == '0'){
            version ='1';
            List<Submission_History__c> lstofSubHist = [SELECT Id, Version__c FROM Submission_History__c where  type__c='Activity History' and Application__c=:application.Id order by Version__c desc];
            for(Submission_History__c sh : lstofSubHist ){
                if(sh.Version__c == '2'){
                    version='2';
                }else if(sh.Version__c == '3'){
                    version='3';
                }
            }
        }
        Submission_History__c sh = new Submission_History__c();
        sh.application__c = application.Id;
        sh.StageId__c = application.name;
        sh.Type__c = type;
        sh.Version__c = version;
        sh.Submitted_By__c = submittedBy;
        sh.Submitted__c = System.now();
        sh.Action__c = Action;
        insert sh;

    }




    /**
    * @description : Method to fetch user
    * @author Himanshu Nimje | 2021-07-12
    * @return user
    **/
    @AuraEnabled
    public static user fetchUser() {
        User u = [select id, Name
                  from User
                  where id = :userInfo.getUserId()];
        return u;
    }


    /**
    * @description : Method to start the sanctioning process
    * @author Himanshu Nimje | 2021-07-12
    * @param oppId
    * @param region
    **/
    @AuraEnabled
    public static void startSanctioningProcess(Id oppId, String region) {
        //start sanctioning
        User u = [select id, Name from User where id = :userInfo.getUserId()];
        //Update opportunity region
        Opportunity opp = new Opportunity(Id=oppId);
        opp.Sanction_Region__c = region;
        database.update(opp, false);

        Application__c updateApp = [SELECT Id, Name, Credit_Application_Accepted__c, Credit_Application_Accepted_DateTime__c,Credit_Application_Acceptedby__c
                                    FROM Application__c where Opportunity__c=:oppId  LIMIT 1  ];

        List<Application_Product__c> appPrdNTUList = [SELECT Id, Application_Product_Parent__r.Product_Status__c,
                                                      Secured_By_Mortgage_Bond__c, Product_Amount__c
                                                      FROM Application_Product__c
                                                      where Opportunity__c = :oppId and  Application_Product_Parent__c != null ];


        if(appPrdNTUList.size() > 0){
            for(Application_Product__c ntu:appPrdNTUList){
                if(ntu.Application_Product_Parent__r.Product_Status__c=='Not Taken Up'){
                    ntu.Application_Product_Parent__r.Product_Status__c = 'Withdraw';
                }else if(ntu.Application_Product_Parent__r.Product_Status__c=='Declined'){
                    ntu.Application_Product_Parent__r.Product_Status__c = 'Pending';
                }

                if(ntu.Secured_By_Mortgage_Bond__c==true){
                    ntu.Agreement_Category__c = 'L' ;
                }else{
                    if(ntu.Product_Amount__c <15000 && ntu.Product_Amount__c>0 ){
                        ntu.Agreement_Category__c = 'S' ;
                    }else if(ntu.Product_Amount__c>=15000 && ntu.Product_Amount__c< 250000){
                        ntu.Agreement_Category__c = 'I' ;
                    }else if(ntu.Product_Amount__c> =250000 ){
                        ntu.Agreement_Category__c = 'L' ;
                    }
                }

            }
            updateApp.Credit_Application_Accepted__c=false;
            updateApp.Credit_Application_Accepted_DateTime__c=null;
            updateApp.Credit_Application_Acceptedby__c='';

            try {
                update updateApp;
                update appPrdNTUList;
                //Added by Himanshu -W-011453
                CreditDecisionSummaryController.submitActivityHistory(oppId, 'Activity History', 'Refer to Sanctioning',u.Name, '0');
            }
            catch (Exception ex) {
                throw new AuraHandledException('Error message to display in component'+ex.getMessage());
            }

        }
        if(!test.isRunningTest()){
            SanctioningApprovalController.submitApprovalProcess(oppId);
        }
    }
   /**
    * @description : Custom wrapper class to consolidate product Cheque and OverDraft data
    * @author Himanshu Nimje | 2021-07-12
    * @param oppId
    * @param region
    **/
     public class ProductDataWrapper{
        @AuraEnabled public String Id;
        @AuraEnabled public String productName;
        @AuraEnabled public String productType;
        @AuraEnabled public String productAccountNumber;
        @AuraEnabled public Decimal productAmount;
        @AuraEnabled public String systemDecision;
        @AuraEnabled public String finalDecision;
        @AuraEnabled public String productStatus;
        @AuraEnabled public String productState;
    }





    /**
    * @description : Method to update NTU status
    * @author Himanshu Nimje | 2021-07-12
    * @param oppId
    * @param parentAppProdId
    * @param NTUComment
    * @param NTUReason
    * @return String
    **/
    @AuraEnabled
    public static String updateNTUStatus(Id oppId, Id parentAppProdId, String NTUComment , string NTUReason) {
        Application_Product__c updateAppProd = new Application_Product__c();
        List<Application_Product__c> appPrdList = [SELECT Id,Is_Not_Taken_Up__c, Product_Status__c,Product_NTU_Comment__c,NTU_Withdrawal_Reason__c
                                                   FROM Application_Product__c where Id=:parentAppProdId];

        
        if(appPrdList.size() > 0){
            updateAppProd.Id = appPrdList[0].Id;
            updateAppProd.Is_Not_Taken_Up__c = true;
            updateAppProd.Product_Status__c = 'Not Taken Up';
            updateAppProd.Product_NTU_Comment__c = NTUComment;
            updateAppProd.NTU_Withdrawal_Reason__c=NTUReason;

            
            try {
                update updateAppProd;
                return 'Success';
            }
            catch (Exception ex) {
               // system.debug(' Meesage :' + +ex.getDmlMessage(0));
                return ' Please Try Again...NTU Update Failed!: ' + ex.getDmlMessage(0);
            }
        }
        return null;
    }



    /**
    * @description : Method to uodate withdrawal status
    * @author Himanshu Nimje| 2021-07-12
    * @param oppId
    * @param parentAppProdId
    * @param NTUComment
    * @param NTUReason
    * @return String
    **/
    @AuraEnabled
    public static String updateWithdrawalStatus(Id oppId, Id parentAppProdId, String NTUComment , string NTUReason) {
        Application_Product__c updateAppProd = new Application_Product__c();
        List<Application_Product__c> appPrdList = [SELECT Id,Is_Not_Taken_Up__c, Product_Status__c,Product_NTU_Comment__c,NTU_Withdrawal_Reason__c
                                                   FROM Application_Product__c where Id=:parentAppProdId];

        
        if(appPrdList.size() > 0){
            updateAppProd.Id = appPrdList[0].Id;
            updateAppProd.Is_Not_Taken_Up__c = true;
            updateAppProd.Product_Status__c = 'Withdraw';
            updateAppProd.Product_NTU_Comment__c = NTUComment;
            updateAppProd.NTU_Withdrawal_Reason__c=NTUReason;

           
            try {
                update updateAppProd;
                return 'Success';
            }
            catch (Exception ex) {
                
                return ' Please Try Again...Withdraw Update Failed!: ' + ex.getDmlMessage(0);
            }
        }
        return null;
    }


    /**
    * @description : Method to do powercurvestatusupdatecall
    * @author Himanshu Nimje| 2021-07-12
    * @param oppId
    * @return String
    **/
    @AuraEnabled
    public static String powerCurveStatusUpdateCall(Id oppId) {
        PowerCurveStatusUpdate_Resp_IB_v1 responseBean = PowerCurveStatusUpdate.pcoCallout(oppId);
        if(responseBean.Response.ApplicationDV.APPERRMSG.contains('000')){
            return 'Success';
        }else{
            return responseBean.Response.ApplicationDV.APPERRMSG;
        }
    }


    /**
    * @description : Method to do PCO callout
    * @author Himanshu Nimje| 2021-07-12
    * @param oppId
    **/
    @future(callout = true)
    public static void PCOStatusCall(Id oppId){

        PowerCurveStatusUpdate.pcoCallout(oppId);
    }


    /**
    * @description : Method to do amendment
    * @author Himanshu Nimje| 2021-07-12
    * @param oppId
    * @return String
    **/
    @AuraEnabled
    public static String AmendmentProcess(Id oppId) {
        string isSuccess;
        User u = [select id, Name from User where id = :userInfo.getUserId()];

        //Update opportunity Credit Refer
        Opportunity opp = new Opportunity(Id=oppId);

        opp.Is_Submitted_Sanctioning__c=false;
        opp.Credit_Application_Refferedby__c='';
        opp.Sanctioning_Refer_DateTime__c=null;
        opp.Is_Referred_Pricing__c=false;
        opp.More_Info_Decision__c=false;


        //Update Application
        Application__c updateApp = [SELECT Id, Name, Credit_Application_Status__c, Credit_Application_Accepted__c, Credit_Application_Accepted_DateTime__c,Credit_Application_Acceptedby__c
                                    FROM Application__c where Opportunity__c=:oppId  LIMIT 1  ];

        
        updateApp.Credit_Application_Status__c='Pending';
        updateApp.Credit_Application_Accepted__c = false;
        updateApp.Credit_Application_Accepted_DateTime__c = null;
        updateApp.Credit_Application_Acceptedby__c = '';
        updateApp.Credit_Application_Amended__c = true;
        updateApp.Credit_Application_Amended_DateTime__c = system.now();
        updateApp.Credit_Application_Amendedby__c = u.Name;

       


        //Update Products
        List<Application_Product__c> appPrdList = [Select id, Name ,Product_Name__c,Account_Number__c,Product_Status__c,Application_Product_Parent__c
                                                   from Application_Product__c Where opportunity__c= :oppId and  Application_Product_Parent__c = null ];

        

        if(appPrdList.size() > 0){

            for(Application_Product__c ntu:appPrdList){
                ntu.Product_Status__c = 'Pending';
            }


            try{
                update opp;
                update updateApp;
                update appPrdList;
               
                PCOStatusCall(Opp.Id);
                string isDeleted = amendDeleteRecord(Opp.Id);
                //Added by Himanshu -W-011453
                CreditDecisionSummaryController.submitActivityHistory(oppId, 'Activity History', 'Amend Application',u.Name, '2');

            }catch(DMLException exc){
               
                throw new AuraHandledException(String.valueOf(exc));
            }

        }

        return 'Success';
    }

    /**
    * @description : Amendment method to delete record
    * @author Himanshu Nimje| 2021-07-12
    * @param oppId
    * @return String
    **/
    @AuraEnabled
    public static String amendDeleteRecord(Id oppId) {
        Application__c application = new ApplicationsSelector().selectByCreditOpportunityId(oppId);
        
        //For Existing Securities
        application.asv_securities__c=0;
        application.masv_bonds__c=0;
        update application;
        List<Application_Security__c>appSecurityList=[select Id from Application_Security__c where Application_Id_Text__c=:application.Id];
        
        if(appSecurityList.size()>0)
        {
            delete appSecurityList;
            Database.emptyRecycleBin(appSecurityList);
        }

        //For Spouse Deletion
        Opportunity opp=[select Id,Spouse_Account_Id__c,Is_Spouse_Captured__c from opportunity where Id=:oppId];
        List<Account>accSpouse=[select Id from account where Id=:opp.Spouse_Account_Id__c];
        if(accSpouse.size()>0){
            opp.Is_Spouse_Captured__c=false;
            update opp;
        }
        List<Application_Profile__c>appProfileList=[select Id from application_profile__c where application__c=:application.Id];

        if(appProfileList.size()>0){
            delete appProfileList;
            Database.emptyRecycleBin(appProfileList);
            AllocateStockNumberController.createAppProfileRecords(oppId);
        }

        //For Exposures
        List<Application_Exposure_Risk__c>appExpRisk=[select Id from Application_Exposure_Risk__c where application__c=:application.Id];
        if(appExpRisk.size()>0){
            delete appExpRisk;
            Database.emptyRecycleBin(appExpRisk);
        }
        List<Application_Exposure__c>appExposureList=[select Id from application_exposure__c where application__c=:application.Id];
        if(appExposureList.size()>0){
            delete appExposureList;
            Database.emptyRecycleBin(appExposureList);
        }
        List<Application_Exposure_Cash_and_Investment__c>appCash=[select Id from Application_Exposure_Cash_and_Investment__c where Application__c=:application.Id];
        if(appCash.size()>0){
            delete appCash;
            Database.emptyRecycleBin(appCash);
        }
        List<Application_Exposure_Total_Group__c>appTotalGroup=[select Id from Application_Exposure_Total_Group__c where Application__c=:application.Id];
        if(appTotalGroup.size()>0){
            delete appTotalGroup;
            Database.emptyRecycleBin(appTotalGroup);
        }
        List<Application_Exposure_Facility__c>appFacility=[select Id from Application_Exposure_Facility__c where Application__c=:application.Id];
        upsert appFacility;

        List<Application_Triad__c>appTriad=[select Id from Application_Triad__c where application__c=:application.Id];
        List<Application_Triad_Detail__c>appTriadDetails1=[select Id,Application_Triad__c from Application_Triad_Detail__c];
        List<Application_Triad_Detail__c>appTriadDetails=new List<Application_Triad_Detail__c>();
        for(Application_Triad__c atrd:appTriad){
            for(Application_Triad_Detail__c app:appTriadDetails1){
                if(app.Application_Triad__c==atrd.Id){
                    appTriadDetails.add(app);
                }
            }
            //appTriadDetails=[select Id from Application_Triad_Detail__c where Application_Triad__c=:atrd.Id];
        }
        if(appTriad.size()>0){
            delete appTriad;
            Database.emptyRecycleBin(appTriad);
        }
        if(appTriadDetails.size()>0){
            delete appTriadDetails;
            Database.emptyRecycleBin(appTriadDetails);
        }

        //Principal Financials
        List<Application_Assets_and_Liabilities__c>prinFinList=[select Id from Application_Assets_and_Liabilities__c where Application__c=:application.Id];
        if(prinFinList.size()>0){
            delete prinFinList;
            Database.emptyRecycleBin(prinFinList);
        }

        //PCO related records
        List<Application_Scoring__c>appScore = [select Id from Application_Scoring__c where Application_Number__c= :application.Id];
       
        List<Application_Scoring_Product__c>scoreProduct = new List<Application_Scoring_Product__c>();
        List<Application_Scoring_Entity__c>scoringEntity = new List<Application_Scoring_Entity__c>();
        set<Id> appScoreIds = new set<Id>();
        if(appScore.size()>0){
            for(Application_Scoring__c var:appScore){
                appScoreIds.add(var.Id);

            }
        }

        scoreProduct=[select Id from Application_Scoring_Product__c where Application_Scoring__c =:appScoreIds];
        scoringEntity=[select Id from Application_Scoring_Entity__c where Application_Scoring__c=:appScoreIds];
        

        if(scoreProduct.size()>0){
            delete scoreProduct;
            Database.emptyRecycleBin(scoreProduct);
        }

        if(scoringEntity.size()>0){
            delete scoringEntity;
            Database.emptyRecycleBin(scoringEntity);
        }

        if(appScore.size()>0){
            delete appScore;
            Database.emptyRecycleBin(appScore);
        }

        List<Validations__c> validations = [SELECT Id, Related_to_Object_Record_Id__c, Validation_Value__c, Related_to_Object_Api_Name__c, Name
		                                            FROM Validations__c
		                                            WHERE Related_to_Object_Record_Id__c = :oppId];

        if(validations.size() > 0){
            delete validations;
            Database.emptyRecycleBin(validations);
        }

        opp.Reprocessing__c=true;
        update opp;

        return 'Success';

    }
        /**
    * @description : check whether account is sole trader
    * @param oppId
    * @return Boolean
    **/
    @AuraEnabled
    public static Boolean isSoleTraderAccount(Id oppId) {
        Boolean isSoleTrader = false;
        Opportunity opp = [SELECT Id, AccountId FROM Opportunity WHERE Id = :oppId];
        Account acc = [SELECT Id, RecordType.Name, Client_Type__c FROM Account WHERE Id = :opp.AccountId];
        
        if (acc.Client_Type__c.equalsIgnoreCase('Sole Trader') || acc.Client_Type__c.equalsIgnoreCase('Sole Proprietor')){
            isSoleTrader = true;
        }
        
        return isSoleTrader;
    }

}