/**
 * @description       : Controller class for Sanctioning Approval Request
 * @author            : Almas Aleem
 * @last modified on  : 2021-11-25
 * @last modified by  : almas.aleem@absa.africa
 * Modifications Log 
 * Ver   Date         Author        Modification
 * 1.0   2021-07-12   Almas Aleem   Initial Version
**/

public class SanctioningApprovalController {
    /**
    * @description : Method to get requested product
    * @author Almas Aleem | 2021-07-12 
    * @param oppId 
    * @return List<ProductDataWrapper> 
    **/
    @AuraEnabled
    public static List<ProductDataWrapper> getRequestedProduct(Id oppId) {
        List<ProductDataWrapper> applicationProductAccepted = new List<ProductDataWrapper>();
        
        List<Application_Product__c> appPrdList = [SELECT Id,System_Decision__c,Final_Decision__c,Temp_Account_Number__c,Application_Product_Parent__r.Product_Name__c,Product_Name__c, tolabel(Product_Type__c),Is_Sanctioning_Decision__c,
                                                   Account_Number__c,Product_Amount__c,Requested_facility_limit__c,
                                                   Opportunity__c, Name,Application_Product_Parent__r.Product_Status__c ,Product_State__c,Product_Status__c
                                                   ,Business_Credit_Card_Sub_Product_Type__c,Facility_account_number__c FROM Application_Product__c
                                                   where Opportunity__c = :oppId  AND Application_Product_Parent__c = null];
        
         if(appPrdList!=null){
             
              for(Application_Product__c appProd : appPrdList){
                
                 if(appProd.Product_Status__c.equalsIgnoreCase('Accepted')){
                ProductTermsOfBusinessController.saveTOB(appProd.Id);
            	}else if(appProd.Product_Status__c.equalsIgnoreCase('Declined')){
                ProductTermsOfBusinessController.updateDeclineTOB(appProd.Id);
            	}
              }     
            for(Application_Product__c appProd : appPrdList){
                
                 
                
                if(appProd.Product_Name__c.equalsIgnoreCase('cheque')){
                    //start making product wrapper for overdraft
                    List<ProductDataWrapper> overdraftWrapper  = getODWrapper(appProd);
                    applicationProductAccepted.addAll(overdraftWrapper);
                }else if(appProd.Product_Name__c.equalsIgnoreCase('Credit Card')){
                    //start making product wrapper for Credit Card  
                   
                    ProductDataWrapper CCWrapper  = getCCWrapper(appProd);
                    applicationProductAccepted.add(CCWrapper);               
                }//add similar condition for terms loans and ldp
                else if(appProd.Product_Name__c.equalsIgnoreCase('Bank Guarantee')){
                   
                    ProductDataWrapper BGWrapper  = getBGWrapper(appProd);
                    applicationProductAccepted.add(BGWrapper);               
                }else if(appProd.Product_Name__c.equalsIgnoreCase('Term Loan')){
                   
                    ProductDataWrapper TLWrapper  = getTLWrapper(appProd);
                    applicationProductAccepted.add(TLWrapper);               
                }
            }
        
       
             }
        
        return applicationProductAccepted;
         
    }
     /**
     * @description : Method to get wrapper for OD
     * @author Almas Aleem | 2021-07-12 
     * @param appProd 
     * @return List<ProductDataWrapper> 
     **/
     public static List<ProductDataWrapper> getODWrapper(Application_Product__c appProd){
        List<ProductDataWrapper> odwrapper = new List<ProductDataWrapper>();
        
        //Inline query used for the toLabel query function to be included to get the label value for the api value of the picklist
        List<Application_Product__c> applicationProductList = [SELECT Id, Application_Product_Parent__c,Application_Product_Parent__r.Final_Decision__c,Application_Product_Parent__r.Accept_TOB__c,System_Decision__c, Product_Name__c, Product_Amount__c, Application_Product_Parent__r.Product_Status__c, Agreement_Category__c,
                                                               tolabel(Application_Product_Parent__r.Product_Type__c) ,tolabel(Product_Type__c) prodtype, Account_Number__c,Application_Product_Parent__r.Account_Number__c,Secured_By_Mortgage_Bond__c,NCA_Appplicable__c,
                                                               Application_Product_Parent__r.Product_State__c,Application_Product_Parent__r.Product_Name__c,Temp_Account_Number__c,Application_Product_Parent__r.NCA_Appplicable__c,Application_Product_Parent__r.Temp_Account_Number__c
                                                               ,Application_Product_Parent__r.System_Decision__c,Facility_account_number__c
                                                               FROM Application_Product__c
                                                               WHERE  Application_Product_Parent__c =: appProd.Id ];
        
        for(Application_Product__c product : applicationProductList){
            //if(product.Application_Product_Parent__r.Product_Status__c == 'Accepted' && product.Application_Product_Parent__r.Accept_TOB__c == true ){ // add condition if accepted from accept tob list && product.Application_Product_Parent__r.Accept_TOB__c == true
                ProductDataWrapper productData = new ProductDataWrapper();
            String nameConcat = product.Product_Name__c + ' ' + product.Product_Name__c;// name parent....check and change later
            productData.productName = nameConcat;
            productData.productType = product.Application_Product_Parent__r.Product_Type__c;
            
           //added for account number
             if(product.Application_Product_Parent__r.Product_State__c != null && product.Application_Product_Parent__r.Product_State__c.equals('New')){
                    productData.productAccountNumber = 'CHQ-' + product.Application_Product_Parent__r.Temp_Account_Number__c; //  product.Temp_Account_Number__c Need to check
                } else if(product.Application_Product_Parent__r.Product_State__c != null && product.Application_Product_Parent__r.Product_State__c.equals('Existing')){
                    productData.productAccountNumber = product.Application_Product_Parent__r.Account_Number__c != null ? String.valueOf(product.Application_Product_Parent__r.Account_Number__c) : null;
                }
          //  productData.productAccountNumber = ''+product.Application_Product_Parent__r.Account_Number__c;
            productData.productAmount = ''+ product.Product_Amount__c; //child
            productData.sysDecision = product.Application_Product_Parent__r.System_Decision__c;
            productData.finalDecision = product.Application_Product_Parent__r.Final_Decision__c;
            productData.productStatus = product.Application_Product_Parent__r.Product_Status__c;
            productData.Id = product.Id;
                odwrapper.add(productData); 
            //}
        }
        return odwrapper;
    }
    
    /**
    * @description : Method to get wrapper for credit card
    * @author Almas Aleem | 2021-07-12 
    * @param product 
    * @return ProductDataWrapper 
    **/
    public static ProductDataWrapper getCCWrapper(Application_Product__c product){
        ProductDataWrapper productData = new ProductDataWrapper();
            //String nameConcat = product.Product_Name__c + ' ' + product.Product_Name__c;// name parent....check and change later
            productData.productName = 'Credit Card';
            productData.productType = product.Business_Credit_Card_Sub_Product_Type__c;
        
            if(product.Product_State__c != null && product.Product_State__c.equals('New')){
                    if(product.Product_Name__c != null && product.Product_Name__c.equals('Credit Card')) {
                        productData.productAccountNumber = 'CC-' + product.Temp_Account_Number__c; //  product.Temp_Account_Number__c Need to check 
                    }
                } else if(product.Product_State__c != null && product.Product_State__c.equals('Existing')){
                    productData.productAccountNumber = product.Account_Number__c != null ? String.valueOf(product.Account_Number__c) : null;
                }
            productData.productAmount = product.Requested_facility_limit__c!=null?product.Requested_facility_limit__c: '0'; //child
            productData.sysDecision = product.System_Decision__c;
            productData.finalDecision = product.Final_Decision__c;
            productData.productStatus = product.Product_Status__c;
            productData.Id = product.Id;
        
        return productData;
    }
    
    /**
    * @description : Method to get wrapper for Bank Guarantee
    * @author Almas Aleem | 2021-07-12 
    * @param product 
    * @return ProductDataWrapper 
    **/
    public static ProductDataWrapper getBGWrapper(Application_Product__c product){
        ProductDataWrapper productData = new ProductDataWrapper();
            //String nameConcat = product.Product_Name__c + ' ' + product.Product_Name__c;// name parent....check and change later
            productData.productName = 'Bank Guarantee';
            //productData.productType = product.Business_Credit_Card_Sub_Product_Type__c;
        
            if(product.Product_State__c != null && product.Product_State__c.equals('New')){
                    if(product.Product_Name__c != null && product.Product_Name__c.equals('Bank Guarantee')) {
                        productData.productAccountNumber = 'BG-' + product.Temp_Account_Number__c; //  product.Temp_Account_Number__c Need to check 
                    }
                } else if(product.Product_State__c != null && product.Product_State__c.equals('Existing')){
                    productData.productAccountNumber = product.Facility_account_number__c != null ? 'BG-' +String.valueOf(product.Facility_account_number__c) : null;
                }
            productData.productAmount = '' +product.Product_Amount__c ;//.Requested_facility_limit__c!=null?product.Requested_facility_limit__c: '0'; //child
            productData.sysDecision = product.System_Decision__c;
            productData.finalDecision = product.Final_Decision__c;
            productData.productStatus = product.Product_Status__c;
            productData.Id = product.Id;
        
        return productData;
    }
    
    /**
    * @description 
    * @author almas.aleem@absa.africa | 2021-11-25 
    * @param product 
    * @return ProductDataWrapper 
    **/
    public static ProductDataWrapper getTLWrapper(Application_Product__c product){
        ProductDataWrapper productData = new ProductDataWrapper();
            //String nameConcat = product.Product_Name__c + ' ' + product.Product_Name__c;// name parent....check and change later
            productData.productName = 'Term Loan';
            //productData.productType = product.Business_Credit_Card_Sub_Product_Type__c;
        
            if(product.Product_State__c != null && product.Product_State__c.equals('New')){
                    if(product.Product_Name__c != null && product.Product_Name__c.equals('Term Loan')) {
                        productData.productAccountNumber = 'TL-' + product.Temp_Account_Number__c; //  product.Temp_Account_Number__c Need to check 
                    }
                } else if(product.Product_State__c != null && product.Product_State__c.equals('Existing')){
                    productData.productAccountNumber = product.Facility_account_number__c != null ? 'TL-' +String.valueOf(product.Facility_account_number__c) : null;
                }
            productData.productAmount = '' +product.Product_Amount__c ;//.Requested_facility_limit__c!=null?product.Requested_facility_limit__c: '0'; //child
            productData.sysDecision = product.System_Decision__c;
            productData.finalDecision = product.Final_Decision__c;
            productData.productStatus = product.Product_Status__c;
            productData.Id = product.Id;
        
        return productData; 
    }  
    /**
    * @description : Method to get list view ID
    * @author Almas Aleem | 2021-07-12 
    * @return ListView 
    **/
    @auraEnabled 
    public static ListView  getListViewId(){
        
        
        ListView ListView = [ SELECT Id, Name FROM ListView WHERE SobjectType = 'Opportunity' and Name='My Worklist Sanctioning Opportunities'];
        
        return listview;
    }
    
   
    /**
    * @description : Method to submit approval process
    * @author Almas Aleem | 2021-07-12 
    * @param oppId 
     **/
    @auraEnabled
    public static void submitApprovalProcess(Id oppId){//send credit opp for sanctioning approval process
        //update opportunity
        Opportunity opp =new OpportunitiesSelector().selectBySanctioningSLAInfoById(oppId);
        User u = [select id, Name from User where id = :userInfo.getUserId()];
        opp.Trigger_Approval_Process__c = 'Sanctioning';
        opp.Sanctioning_Refer_DateTime__c = system.now();
        opp.Is_Final_Sanctioning_Decision__c = false;
        
        if(opp.Sanctioning_SLA_Start_Date__c == null){
            opp.Sanctioning_SLA_Start_Date__c = system.now();
        }
        opp.More_Info_Decision__c = false;
        
        if(opp.More_Info_Comment__c !=null ){
            opp.Sanctioning_SLA_Temp_Start_Date__c = system.now();
        }
        opp.Is_Submitted_Sanctioning__c = true;
        opp.Credit_Application_Refferedby__c=u.Name;
        
        
        //use selector later
        List<Application_Product__c> existingProductList = [Select id, Accept_TOB__c,Name ,Product_Name__c,Account_Number__c,Product_State__c,Product_Status__c,Limit_Type__c,Temp_Account_Number__c,
                                                            toLabel(Product_Type__c) producttype,Review_Date__c, Expiry_Date__c,  NCA_Appplicable__c, Maximum_NCA_Rate_Type__c,Maximum_NCA_Rate__c
                                                            from Application_Product__c Where 
                                                            Application_Product_Parent__c = null  AND Opportunity__c=:oppId  ];
        
        
        
        for(Application_Product__c appProd: existingProductList){
            appProd.Accept_TOB__c = false;
        }
        try{
            update opp;
            update existingProductList;
            
            
            PCOStatusCall(Opp.Id);
            
            
        }catch(DMLException e){
            e.getMessage();
            
        }
        // Create an approval request for the Opportunity
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for sanctioning');
        req1.setObjectId(oppId);
        if(opp.Approval_Owner__c !=null){
            req1.setNextApproverIds(new Id[] {opp.Approval_Owner__c});
        }
        //req1.setNextApproverIds(new Id[] {opp.Next_Approver__c});
        
        // Submit the approval request for the Opportunity
        Approval.ProcessResult result = Approval.process(req1);
        
    }
    
    /**
    * @description : Method to reject approval process
    * @author Almas Aleem | 2021-07-12 
    * @param oppId 
    * @return Opportunity 
    **/
    @auraEnabled
    public static Opportunity rejectApprovalProcessforMoreInfo(Id oppId){
        
        
        Opportunity opp =new OpportunitiesSelector().selectBySanctioningSLAInfoById(oppId);
        User u = [select id, Name from User where id = :userInfo.getUserId()];
        
        opp.Is_Submitted_Sanctioning__c = false;
        opp.More_Info_Decision__c = true;
        opp.Pricing_Referred_By__c = u.name;
        opp.More_Info_Submitted_Date_Time__c = system.now();
        
        opp.Sanctioning_Refer_DateTime__c = null;
        
        //update sla's 
        List<BusinessHours> bhList =  new BusinessHoursSelector().selectSanctioningBusinessHours();
        Long CalculatedSLA = BusinessHours.diff(bhList[0].Id, opp.Sanctioning_SLA_Start_Date__c, system.now());   //calculate sla till pause  	
        Integer CalculatedSLAhour = CalculatedSLA.intValue() / (1000 * 60 ); //total minutes 
        
        opp.Sanctioning_SLA_Hours_Calculated__c = CalculatedSLAhour;
        Long hours = opp.Sanctioning_SLA_Hours_Calculated__c.longValue() / 60;
        Long minutes = Math.mod(opp.Sanctioning_SLA_Hours_Calculated__c.longValue(), 60);
        //Show hours in hh:mm format on ui
        
        opp.Sanctioning_SLA_Hours__c =hours +'h:'+minutes+'m'; 
        
        //Added by Himanshu -W-011453
        CreditDecisionSummaryController.submitActivityHistory(oppId, 'Activity History', 'Request info', u.Name, '0');
        
        //add feed for banker to get notified ,application require more info
        String body =' Application require more info to proceed \n Decision:more info required \n Decision Reason:'+opp.More_Info_Comment__c  ;
        if(!Test.isRunningTest()){
            ConnectApi.FeedItem fi = (ConnectApi.FeedItem) ConnectApiHelper.postFeedItemWithMentions(Network.getNetworkId(), opp.Id ,'Hello {'+opp.OwnerId+'}'+body+'');
        } 
        
        try{
            update opp;
        }catch(DMLException e){
            e.getCause();
        }
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        req.setComments('rejecting ,more info needed');
        req.setAction('Reject');
        //req.setNextApproverIds(new Id[] {opp.Next_Approver__c});
        
        
        //Added By Himani Joshi
        Application__c app=CreditDecisionSummaryController.GetUpdatedApplication(oppId);
        if(app.NoOfDaysSinceBureauDate__c>=app.Lookup_Period__c && app.Enforce_Rework__c=='Y'){
            opp.IsAmendmentRequired__c=true;
            app.IsAmendmentRequired__c=true;
            app.acceptedProductsCount__c='F';
            
        }
        else{
            opp.IsAmendmentRequired__c=false;
            app.IsAmendmentRequired__c=false;
            app.acceptedProductsCount__c='T';
        }
        update opp;
        update app;
        Id workItemId = getWorkItemId(oppId); 
        
        
        if(workItemId != null)
        {
            req.setWorkitemId(workItemId);
            // Submit the request for approval
            Approval.ProcessResult result =  Approval.process(req);
        }
        
        return opp;
    }
    
    /**
    * @description : Method to accept approval process
    * @author Almas Aleem | 2021-07-12 
    * @param oppId 
    * @return Opportunity 
    **/
    @auraEnabled   
    public static Opportunity acceptApprovalProcessforSanctioning(Id oppId){
        //add check if all of the products has approved or rejected based on it approve or reject
        //call pco8 for update...
        //update opportunity
        Opportunity opp =new OpportunitiesSelector().selectBySanctioningSLAInfoById(oppId);
        opp.Sanctioning_SLA_End_Date__c = system.now();
        opp.Is_Submitted_Sanctioning__c = false;
        // opp.Allocated__c = false;
        
        Boolean isApprove ;
        Boolean isdecisionmade = true;
        
        Application__c application = new ApplicationsSelector().selectByCreditOpportunityId(opp.Id);
        
        //List<Application_Product__c> appPrdList = new ApplicationProductSelector().selectByOpportunityId(oppId);
        
        // use selector later...in future ...
        List<Application_Product__c> appPrdList = [SELECT Product_Name__c,Is_Sanctioning_Decision__c, Product_Type__c, Temp_Account_Number__c,Product_Amount__c,Product_Status__c,
                                                   System_Decision__c, Final_Decision__c, Opportunity__c, Name, Id, Product_State__c
                                                   FROM Application_Product__c
                                                   where Opportunity__c = :oppId  AND Application_Product_Parent__c = null];
        
        /*for(Application_Product__c appProd :appPrdList){
            system.debug('calling SAVETOOB');
            if(appProd.Product_Status__c.equalsIgnoreCase('Accepted')){
                ProductTermsOfBusinessController.saveTOB(appProd.Id);
            }else if(appProd.Product_Status__c.equalsIgnoreCase('Declined')){
                ProductTermsOfBusinessController.updateDeclineTOB(appProd.Id);
            }
            appProd.Final_Decision_Date_Time__c = system.now();
        }*/
        for(Application_Product__c appProd :appPrdList){
             appProd.Final_Decision_Date_Time__c = system.now();
            
            if(appProd.Product_Status__c.equalsIgnoreCase('Accepted')){
                
                isApprove = true;
                
                break;
            }else if(appProd.Product_Status__c.equalsIgnoreCase('Declined')){
                isApprove = false;
                
                
            }
            
        }
        
        for(Application_Product__c appProd :appPrdList){
            if(appProd.Is_Sanctioning_Decision__c == true){
                isdecisionmade = true;
            }else{
                isdecisionmade = false; 
                break;
            }
        }
        
        if(isdecisionmade == false) {
            // How rude! Gracefully return an error...
            throw new AuraHandledException('The decisions are pending for products please check!');
        }
        
        try{
            update appPrdList;
            update application;
            update opp;
            
            //Added by Himanshu -W-011453	
            User u = [select id, Name from User where id = :userInfo.getUserId()];
            CreditDecisionSummaryController.submitActivityHistory(oppId, 'Activity History', 'Return Final Decision',u.Name, '0');
            
            
        }catch(DMLException e){
            e.getCause();
        }
        
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        req.setComments('Product Level Decision');
        if(isApprove){
            req.setAction('Approve');
            application.Credit_Application_Status__c = 'Accepted';
            
        }else{
            req.setAction('Reject'); 
            application.Credit_Application_Status__c = 'Declined';
        }
        
        //req.setNextApproverIds(new Id[] {opp.Next_Approver__c});
        Id workItemId = getWorkItemId(oppId); 
        
        
        
        if(workItemId != null)
        {
            req.setWorkitemId(workItemId);
            // Submit the request for approval
            Approval.ProcessResult result =  Approval.process(req);
        }
        
        //call pco8 here 
        //
        //Changes By Himani start
        Application__c app=CreditDecisionSummaryController.GetUpdatedApplication(oppId);
        app.acceptedProductsCount__c='T';
        update app;
        for(Application_Product__c appProd :appPrdList){
            if(appProd.Final_Decision__c.equalsIgnoreCase('Accepted')){
                app.acceptedProductsCount__c='F';
            }
            
        }
        update app;
        if(app.NoOfDaysSinceBureauDate__c>=app.Lookup_Period__c && app.Enforce_Rework__c=='Y' && app.acceptedProductsCount__c=='F'){
            opp.IsAmendmentRequired__c=true;
            app.IsAmendmentRequired__c=true;
            
        }
        else{
            opp.IsAmendmentRequired__c=false;
            app.IsAmendmentRequired__c=false;
            app.acceptedProductsCount__c='T';
            if(!Test.isRunningTest()){
                PCOCall8(oppId);
            }
            
        }
        
        //add feed for banker to get notified ,application require more info
        String body =' Application returned sucessfully from Sanctioning.';
        if(!Test.isRunningTest()){
            ConnectApi.FeedItem fi = (ConnectApi.FeedItem) ConnectApiHelper.postFeedItemWithMentions(Network.getNetworkId(), opp.Id ,'Hello {'+opp.OwnerId+'}'+body+'');
        } 
        
        
        update opp;
        update app;
        
       
        
        
        //updateCall8Return(oppId);
        return opp;
        
    } 
    /**

* Get ProcessInstanceWorkItemId using SOQL

**/
    
    /**
    * @description : Method to get workitemId
    * @author Almas Aleem | 2021-07-12 
    * @param targetObjectId 
    * @return Id 
    **/
    public static Id getWorkItemId(Id targetObjectId)
        
    {
        
        Id retVal = null;
        //later use selector
        
        for(ProcessInstanceWorkitem workItem  : [Select p.Id from ProcessInstanceWorkitem p
                                                 
                                                 where p.ProcessInstance.TargetObjectId =: targetObjectId])
            
        {
            
            retVal  =  workItem.Id;
            
        }
        
        return retVal;
        
    }
    
    
    /**
    * @description : Method to update call 8
    * @author Almas Aleem | 2021-07-12 
    * @param oppId 
    **/
    public static void updateCall8Return(Id oppId){
        List<Application_Product__c> appPrdList = [SELECT Product_Name__c, Product_Type__c, Temp_Account_Number__c,Product_Amount__c,Product_Status__c,
                                                   System_Decision__c, Final_Decision__c, Opportunity__c, Name, Id, Product_State__c
                                                   FROM Application_Product__c
                                                   where Opportunity__c = :oppId  AND Application_Product_Parent__c = null];
        
        
        SetProductTOBController.mapFromPCOResponse(appPrdList,'8');   //map fields
        
        
    }  
    
    
    /**
    * @description : Future method to call PCOStatus
    * @author Almas Aleem | 2021-07-12 
    * @param oppId 
    **/
    @future(callout = true)
    public static void PCOStatusCall(Id oppId){
        if(!Test.isRunningTest()){
            PowerCurveStatusUpdate.pcoCallout(oppId);
        }
    }
    
    /**
    * @description : Method to do PCO 8 call
    * @author Almas Aleem | 2021-07-12 
    * @param oppId 
    **/
    @future(callout = true)
    public static void PCOCall8(Id oppId){
        if(!Test.isRunningTest()){
            PowerCurveController.pcoStageHandler(oppId, '08', false); 
        }
    }
    /**
    * @description : Inner wrapper class for Product
    * @author Almas Aleem | 2021-07-12 
    * @param oppId 
    **/
    public class ProductDataWrapper{
        @AuraEnabled public String Id;
        @AuraEnabled public String productName;
        @AuraEnabled public String productType;
        @AuraEnabled public String productAccountNumber;
        @AuraEnabled public String productAmount;
        @AuraEnabled public String productStatus;
        @AuraEnabled public String productState;
        @AuraEnabled public String sysDecision;
        @AuraEnabled public String finalDecision;
    }
}