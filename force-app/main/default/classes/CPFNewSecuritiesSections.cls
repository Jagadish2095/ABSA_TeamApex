/**
 * @description       :Controller Class for New Securities section 
 * @author            :Diksha Wasekar 
 * @last modified on  : 2021-07-09
 * @last modified by  : 
 * Modifications Log 
 * Ver   Date         Author   Modification
 * 1.0   2021-07-09      Initial Version
**/
public class CPFNewSecuritiesSections {
    
    /**
    * @description 
    * @author  | 2021-07-09 
    * @param oppId 
    * @return Application_Product_CPF__c 
    **/
    @AuraEnabled
    public static Application_Product_CPF__c getAppProdctCpfRec(Id oppId) {
        List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(oppId);
        Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
        return appPrdctCpf;     
    }
    

    /**
    * @description 
    * @author  | 2021-07-09 
    * @param oppId 
    * @param SecurityType 
    * @param SecurityClass 
    * @return Application_Security_CPF__c 
    **/
    @AuraEnabled
    public static Application_Security_CPF__c getApplicationSecCpfRec(Id oppId , String SecurityType ,String SecurityClass) {
        List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(oppId);
        Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
        List<Application_Security_CPF__c> securityofferedList= new ApplicationSecurityCPFSelector().selectByAppPrdctwithtypecategoryandClass(appPrdctCpf.Id,'Other',SecurityType,SecurityClass);
        if(securityofferedList.size() > 0){
            return securityofferedList[0]; 
        }else{
            return null;
        }   
        
    }
    
    /**
    * @description 
    * @author  | 2021-07-09 
    * @param oppId 
    * @param SecurityType 
    * @param SecurityClass 
    * @return Application_Security_CPF__c 
    **/
    @AuraEnabled
    public static Application_Security_CPF__c getApplicationSecCpfRecExist(Id oppId , String SecurityType ,String SecurityClass) {
        List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(oppId);
        Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
        List<Application_Security_CPF__c> securityofferedList= new ApplicationSecurityCPFSelector().selectByAppPrdctwithtypecategoryandClass(appPrdctCpf.Id,'Other',SecurityType,SecurityClass);
        if(securityofferedList.size() > 0){
            return securityofferedList[0]; 
        }else{
            return null;
        }   
        
    } 

    /**
    * @description 
    * @author  | 2021-07-09 
    * @param recId 
    * @param SecurityProviderConsent 
    * @return Application_Product_CPF__c 
    **/
    @AuraEnabled
    public static Application_Product_CPF__c updateAppPrdctcpf(Id recId,string SecurityProviderConsent) {
        Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectById(recId);
        try{
            if(appPrdctCpf!=null){
                appPrdctCpf.Security_Provider_Consent__c=SecurityProviderConsent;
                appPrdctCpf.id=recId;
            }
            update appPrdctCpf;
            return appPrdctCpf;     
        }catch(Exception e){
            system.debug(e.getMessage());
            return null;
        } 
    }
    
    /**
    * @description 
    * @author  | 2021-07-09 
    * @param recId 
    * @param secprovided 
    * @param FacilitiesValue 
    * @param specificdetails 
    * @param crossCollOptionGiven 
    * @param SecurityClass 
    * @return Application_Security_CPF__c 
    **/
    @AuraEnabled
    public static Application_Security_CPF__c insertCrossCollRec(Id recId,string secprovided,string FacilitiesValue,string specificdetails,string crossCollOptionGiven,string SecurityClass) {
        Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectById(recId);
        Application_Security_CPF__c  secOffRec = new Application_Security_CPF__c();
        try{
            List<Application_Security_CPF__c> dellist = new ApplicationSecurityCPFSelector().selectByAppPrdctwithtypecategoryandClass(appPrdctCpf.Id,'Other','Cross Collateralisation',SecurityClass);
            if(!dellist.isEmpty()) {
                delete dellist;
            }
            if(appPrdctCpf!=null){
                
                secOffRec.Application_Product_CPF__c =appPrdctCpf.Id;
                secOffRec.Security_provided_by__c=secprovided;
                secOffRec.Facilities__c=FacilitiesValue;
                secOffRec.Specific_facility_detail__c=specificdetails;
                secOffRec.Cross_collateralisation__c=crossCollOptionGiven;
                secOffRec.Security_Class__c=SecurityClass;
                secOffRec.Category__c='Other';
                secOffRec.Type__c='Cross Collateralisation';

            }
            insert secOffRec;
            return secOffRec;     
        }catch(Exception e){
            system.debug(e.getMessage());
            return null;
        } 
    }
    
    /**
    * @description 
    * @author  | 2021-07-09 
    * @param recId 
    * @param secprovided 
    * @param FacilitiesValue 
    * @param specificdetails 
    * @param crossCollOptionGiven 
    * @param SecurityClass 
    * @return Application_Security_CPF__c 
    **/
    @AuraEnabled
    public static Application_Security_CPF__c insertCrossCollRecExist(Id recId,string secprovided,string FacilitiesValue,string specificdetails,string crossCollOptionGiven,string SecurityClass) {
        Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectById(recId);
        Application_Security_CPF__c  secOffRec = new Application_Security_CPF__c();
        try{
            List<Application_Security_CPF__c> dellist = new ApplicationSecurityCPFSelector().selectByAppPrdctwithtypecategoryandClass(appPrdctCpf.Id,'Other','Cross Collateralisation',SecurityClass);
            if(!dellist.isEmpty()) {
                delete dellist;
            }
            if(appPrdctCpf!=null){
                
                secOffRec.Application_Product_CPF__c =appPrdctCpf.Id;
                secOffRec.Security_provided_by__c=secprovided;
                secOffRec.Facilities__c=FacilitiesValue;
                secOffRec.Specific_facility_detail__c=specificdetails;
                secOffRec.Cross_collateralisation__c=crossCollOptionGiven;
                secOffRec.Security_Class__c=SecurityClass;
                secOffRec.Category__c='Other';
                secOffRec.Type__c='Cross Collateralisation';

            }
            insert secOffRec;
            return secOffRec;     
        }catch(Exception e){
            system.debug(e.getMessage());
            return null;
        } 
    }

    
    /**
    * @description 
    * @author  | 2021-07-09 
    * @param recId 
    * @param SubordinationAgreementofLoanAccounts 
    * @param claimsby 
    * @param CPAdocumentversion 
    * @param SecurityClass 
    * @return Application_Security_CPF__c 
    **/
    @AuraEnabled                       
    public static Application_Security_CPF__c insertSubAgreeforLoanAcct(Id recId,string SubordinationAgreementofLoanAccounts,string claimsby,string CPAdocumentversion,string SecurityClass ) {
        system.debug('recId'+recId);
        Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectById(recId);
        Application_Security_CPF__c  secOffRec = new Application_Security_CPF__c();
        
        try{
            List<Application_Security_CPF__c> dellist = new ApplicationSecurityCPFSelector().selectByAppPrdctwithtypecategoryandClass(appPrdctCpf.Id,'Other','Subordination Agreement of Loan Accounts',SecurityClass);
            if(!dellist.isEmpty()) {
                delete dellist;
            }
            if(appPrdctCpf!=null){
                secOffRec.Application_Product_CPF__c =appPrdctCpf.Id;
                secOffRec.Subordination_Agreement_of_Loan_Accounts__c=SubordinationAgreementofLoanAccounts;
                secOffRec.Claims_By__c=claimsby;
                secOffRec.CPA_document_version__c=CPAdocumentversion;
                secOffRec.Security_Class__c=SecurityClass;
                secOffRec.Category__c='Other';  //category;
                secOffRec.Type__c= 'Subordination Agreement of Loan Accounts'; //inputtype; 
                
            }
            insert secOffRec;
            return secOffRec;     
        }catch(Exception e){
            system.debug(e.getMessage());
            return null;
        } 
    } 
    
        /**
        * @description 
        * @author  | 2021-07-09 
        * @param recId 
        * @param SubordinationAgreementofLoanAccounts 
        * @param claimsby 
        * @param dateRegistered 
        * @param SecurityClass 
        * @return Application_Security_CPF__c 
        **/
        @AuraEnabled                       
    public static Application_Security_CPF__c insertSubAgreeforLoanAcctExist(Id recId,string SubordinationAgreementofLoanAccounts,string claimsby,Date dateRegistered,string SecurityClass) {
        Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectById(recId);
        Application_Security_CPF__c  secOffRec = new Application_Security_CPF__c();
        
        try{
            List<Application_Security_CPF__c> dellist = new ApplicationSecurityCPFSelector().selectByAppPrdctwithtypecategoryandClass(appPrdctCpf.Id,'Other','Subordination Agreement of Loan Accounts',SecurityClass);
            if(!dellist.isEmpty()) {
                delete dellist;
            }
            if(appPrdctCpf!=null){
                secOffRec.Application_Product_CPF__c =appPrdctCpf.Id;
                secOffRec.Subordination_Agreement_of_Loan_Accounts__c=SubordinationAgreementofLoanAccounts;
                secOffRec.Claims_By__c=claimsby;
                secOffRec.Date_registered__c =dateRegistered;
                secOffRec.Security_Class__c= SecurityClass;
                secOffRec.Category__c='Other';  //category;
                secOffRec.Type__c= 'Subordination Agreement of Loan Accounts'; //inputtype; 
                
            }
            insert secOffRec;
            return secOffRec;     
        }catch(Exception e){
            system.debug(e.getMessage());
            return null;
        } 
    }  

    
    
    /**
    * @description 
    * @author  | 2021-07-09 
    * @param recId 
    * @param Undertakingtoinjectcostoverrunfunds 
    * @param whowillberesponsiblepay 
    * @param SecurityClass 
    * @return Application_Security_CPF__c 
    **/
    @AuraEnabled                       
    public static Application_Security_CPF__c insertUndertakingtoinjectcostoverrunfunds(Id recId,string Undertakingtoinjectcostoverrunfunds,string whowillberesponsiblepay,string SecurityClass) {
        Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectById(recId);
        Application_Security_CPF__c  secOffRec = new Application_Security_CPF__c();
        
        try{
            List<Application_Security_CPF__c> dellist = new ApplicationSecurityCPFSelector().selectByAppPrdctwithtypecategoryandClass(appPrdctCpf.Id,'Other','Undertaking to inject cost overrun funds',SecurityClass);
            if(!dellist.isEmpty()) {
                delete dellist;
            }
            if(appPrdctCpf!=null){
                secOffRec.Application_Product_CPF__c =appPrdctCpf.Id;
                secOffRec.Undertaking_to_inject_cost_overrun_funds__c=Undertakingtoinjectcostoverrunfunds;
                secOffRec.Who_will_be_responsible_pay__c=whowillberesponsiblepay;
                secOffRec.Security_Class__c=SecurityClass;
                secOffRec.Category__c='Other';  //category;
                secOffRec.Type__c= 'Undertaking to inject cost overrun funds'; //inputtype; 
                
            }
            insert secOffRec;
            return secOffRec;     
        }catch(Exception e){
            system.debug(e.getMessage());
            return null;
        } 
    }  
    
        /**
        * @description 
        * @author  | 2021-07-09 
        * @param recId 
        * @param Undertakingtoinjectcostoverrunfunds 
        * @param whowillberesponsiblepay 
        * @param dateRegisteredunder 
        * @param SecurityClass 
        * @return Application_Security_CPF__c 
        **/
        @AuraEnabled                       
        public static Application_Security_CPF__c insertUndertakingtoinjectcostoverrunfundsExist(Id recId,string Undertakingtoinjectcostoverrunfunds,string whowillberesponsiblepay,date dateRegisteredunder,string SecurityClass) {
        Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectById(recId);
        Application_Security_CPF__c  secOffRec = new Application_Security_CPF__c();
        
        try{
            List<Application_Security_CPF__c> dellist = new ApplicationSecurityCPFSelector().selectByAppPrdctwithtypecategoryandClass(appPrdctCpf.Id,'Other','Undertaking to inject cost overrun funds',SecurityClass);

            if(!dellist.isEmpty()) {
                delete dellist;
            }
            if(appPrdctCpf!=null){
                secOffRec.Application_Product_CPF__c =appPrdctCpf.Id;
                secOffRec.Undertaking_to_inject_cost_overrun_funds__c=Undertakingtoinjectcostoverrunfunds;
                secOffRec.Who_will_be_responsible_pay__c=whowillberesponsiblepay;
                secOffRec.Date_registered__c=dateRegisteredunder;
                secOffRec.Security_Class__c=SecurityClass;
                secOffRec.Category__c='Other';  //category;
                secOffRec.Type__c= 'Undertaking to inject cost overrun funds'; //inputtype; 
                
            }
            insert secOffRec;
            return secOffRec;     
        }catch(Exception e){
            system.debug(e.getMessage());
            return null;
        } 
    }  

    
    /**
    * @description 
    * @author  | 2021-07-09 
    * @param recId 
    * @param CrossDefaultClause 
    * @param crossdefaultclauseparty 
    * @param SecurityClass 
    * @return Application_Security_CPF__c 
    **/
    @AuraEnabled                      
    public static Application_Security_CPF__c insertCrossDefaultClause(Id recId,string CrossDefaultClause,string crossdefaultclauseparty,string SecurityClass ) {

        Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectById(recId);
        Application_Security_CPF__c  secOffRec = new Application_Security_CPF__c();
        
        try{
            List<Application_Security_CPF__c> dellist = new ApplicationSecurityCPFSelector().selectByAppPrdctwithtypecategoryandClass(appPrdctCpf.Id,'Other','Cross Default Clause',SecurityClass);

            if(!dellist.isEmpty()) {
                delete dellist;
            }
            if(appPrdctCpf!=null){
                secOffRec.Application_Product_CPF__c =appPrdctCpf.Id;
                secOffRec.Cross_default_clause__c=CrossDefaultClause;
                secOffRec.Cross_default_clause_party__c=crossdefaultclauseparty;
                secOffRec.Security_Class__c=SecurityClass;
                secOffRec.Category__c='Other';  //category;
                secOffRec.Type__c= 'Cross Default Clause'; //inputtype; 
                
            }
            insert secOffRec;
            return secOffRec;     
        }catch(Exception e){
            system.debug(e.getMessage());
            return null;
        } 
    }  
    
    /**
    * @description 
    * @author  | 2021-07-09 
    * @param recId 
    * @param CrossDefaultClause 
    * @param crossdefaultclauseparty 
    * @param SecurityClass 
    * @return Application_Security_CPF__c 
    **/
    @AuraEnabled                      
    public static Application_Security_CPF__c insertCrossDefaultClauseExist(Id recId,string CrossDefaultClause,string crossdefaultclauseparty,string SecurityClass ) {

        Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectById(recId);
        Application_Security_CPF__c  secOffRec = new Application_Security_CPF__c();
        
        try{
            List<Application_Security_CPF__c> dellist = new ApplicationSecurityCPFSelector().selectByAppPrdctwithtypecategoryandClass(appPrdctCpf.Id,'Other','Cross Default Clause',SecurityClass);

            if(!dellist.isEmpty()) {
                delete dellist;
            }
            if(appPrdctCpf!=null){
                secOffRec.Application_Product_CPF__c =appPrdctCpf.Id;
                secOffRec.Cross_default_clause__c=CrossDefaultClause;
                secOffRec.Cross_default_clause_party__c=crossdefaultclauseparty;
                secOffRec.Security_Class__c=SecurityClass;
                secOffRec.Category__c='Other';  //category;
                secOffRec.Type__c= 'Cross Default Clause'; //inputtype; 
                
            }
            insert secOffRec;
            return secOffRec;     
        }catch(Exception e){
            system.debug(e.getMessage());
            return null;
        } 
    }  

    
    
    /**
    * @description 
    * @author  | 2021-07-09 
    * @param recId 
    * @param Crossguarantee 
    * @param Includingcessionofclaimsandloanaccount 
    * @param cpfreleased 
    * @param Amount 
    * @param Inpwentoreleasemht 
    * @param releasecondition 
    * @param SecurityClass 
    * @param buyWho 
    * @return Application_Security_CPF__c 
    **/
    @AuraEnabled                        
    public static Application_Security_CPF__c insertCrossguarantee(Id recId,string Crossguarantee,string Includingcessionofclaimsandloanaccount, 
                                                                   string cpfreleased,decimal Amount, decimal Inpwentoreleasemht,
                                                                   string releasecondition ,string SecurityClass,string buyWho) {

        Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectById(recId);
        Application_Security_CPF__c  secOffRec = new Application_Security_CPF__c();
        
        try{
            List<Application_Security_CPF__c> dellist = new ApplicationSecurityCPFSelector().selectByAppPrdctwithtypecategoryandClass(appPrdctCpf.Id,'Other','Cross Guarantee',SecurityClass);
            if(!dellist.isEmpty()) {
                delete dellist;
            }
            
            if(appPrdctCpf!=null){
                secOffRec.Application_Product_CPF__c =appPrdctCpf.Id;
                secOffRec.Cross_guarantee__c=Crossguarantee;
                secOffRec.Including_cession_of_claims_and_loan_acc__c=Includingcessionofclaimsandloanaccount;
                secOffRec.To_be_released__c=cpfreleased;
                secOffRec.Amount__c=Amount;
                secOffRec.When_to_release_months__c=Inpwentoreleasemht;
                secOffRec.Release_condition__c=releasecondition;
                secOffRec.By_who__c=buyWho;
                secOffRec.Security_Class__c=SecurityClass;
                secOffRec.Category__c='Other';  //category;
                secOffRec.Type__c= 'Cross Guarantee'; //inputtype; 
            }
            insert secOffRec;
            return secOffRec;     
        }catch(Exception e){
            system.debug(e.getMessage());
            return null;
        } 
    }
    
    /**
    * @description 
    * @author  | 2021-07-09 
    * @param recId 
    * @param Crossguarantee 
    * @param Includingcessionofclaimsandloanaccount 
    * @param cpfreleased 
    * @param Amount 
    * @param Inpwentoreleasemht 
    * @param releasecondition 
    * @param SecurityClass 
    * @param byWho 
    * @return Application_Security_CPF__c 
    **/
    @AuraEnabled                        
    public static Application_Security_CPF__c insertCrossguaranteeexist(Id recId,string Crossguarantee,string Includingcessionofclaimsandloanaccount, 
                                                                   string cpfreleased,decimal Amount, decimal Inpwentoreleasemht,
                                                                   string releasecondition ,string SecurityClass,string byWho) {

        Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectById(recId);
        Application_Security_CPF__c  secOffRec = new Application_Security_CPF__c();
        
        try{
            List<Application_Security_CPF__c> dellist = new ApplicationSecurityCPFSelector().selectByAppPrdctwithtypecategoryandClass(appPrdctCpf.Id,'Other','Cross Guarantee',SecurityClass);
            if(!dellist.isEmpty()) {
                delete dellist;
            }
            
            if(appPrdctCpf!=null){
                secOffRec.Application_Product_CPF__c =appPrdctCpf.Id;
                secOffRec.Cross_guarantee__c=Crossguarantee;
                secOffRec.Including_cession_of_claims_and_loan_acc__c=Includingcessionofclaimsandloanaccount;
                secOffRec.To_be_released__c=cpfreleased;
                secOffRec.Amount__c=Amount;
                secOffRec.When_to_release_months__c=Inpwentoreleasemht;
                secOffRec.Release_condition__c=releasecondition;
                secOffRec.By_who__c=byWho;
                secOffRec.Security_Class__c=SecurityClass;
                secOffRec.Category__c='Other';  //category;
                secOffRec.Type__c= 'Cross Guarantee'; //inputtype; 
            }
            insert secOffRec;
            return secOffRec;     
        }catch(Exception e){
            system.debug(e.getMessage());
            return null;
        } 
    }
    
    /**
    * @description Method to get product name
    * @author  | 2021-07-09 
    * @param oppId 
    * @return List<OpportunityLineItem> 
    **/
    @AuraEnabled
    public static List<OpportunityLineItem> getprodName(Id oppId) {
        List<OpportunityLineItem> opplineitemlst =new OpportunityLineItemsSelector().selectByOpportunityId(oppId);
        return opplineitemlst;     
    }   

}