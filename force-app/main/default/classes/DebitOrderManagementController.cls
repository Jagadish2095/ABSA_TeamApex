/**
* Controller for Debit Order Lightning component
* @author  Himanshu
* @created 2018-10-10
* @edited by Kyle Alexander - created getAccountInfoData method
*/
public class DebitOrderManagementController {
     
    @AuraEnabled
    public static List<AccountData> getAccountInfoData(Id oppId){
        List<AccountData> accDatalist = new List<AccountData>();
        
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
        Account account = new AccountsSelector().selectByOpportunityId(opportunities.get(0).AccountId, 1);
        
        if(account.CIF__c != null){
            CIgetAcctLinkedToClientCode_Resp_IB_v1 resp = CIgetAcctLinkedToClientCode_IH_v1.ciGetAcctLinkedToClientCode('SALESFORCE', account.CIF__c);
            
            if(resp.statusCode == 200){
                for(CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_OutputTable output : resp.cip047o.outputTable){
                    if(isValidAccount(output.product, output.productType, output.status, output.balance)){
                        AccountData accData = new AccountData();
                        accData.accNum = output.oaccntnbr;
                        accData.product = output.product;
                        accData.productType = output.productType;
                        accData.corp = output.corp;
                        accData.status = output.status;
                        accData.balance = output.balance;
                        
                        accDatalist.add(accData);
                    }
                }
                
                if(accDatalist.size() >= 1){
                    return accDatalist;
                }
            }
        }
        return null;
    }
    
    private static Boolean isValidAccount(String product, String productType, String status, String balance){
        //W-001876
        Boolean isAllValid = false;
        List<WIMI_Valid_Bank_Account__mdt> validAccounts = [SELECT Id, Account_Type__c, Bank_Product__c, Bank_Status__c FROM WIMI_Valid_Bank_Account__mdt LIMIT 1];
        if(product != null){
            if(validAccounts.get(0).Bank_Product__c.contains(product)){
                isAllValid = true;
            } else{
                return false;
            } 
        }
        if(productType != null){
            if(validAccounts.get(0).Account_Type__c.contains(productType)){
                isAllValid = true;
            } else{
                return false;
            }
        }
        if(status != null){
            if(validAccounts.get(0).Bank_Status__c.contains(status)){
                isAllValid = true;
            } else{
                return false;
            } 
        }
        if(isAllValid){
            return true;
        } else{
            return false;
        }
    }
    
    @AuraEnabled
    public static opportunity getDebitOrderDetails(Id OppId){
        return [SELECT Id, RecordType.Name,Debit_Order_Bank_Name__c, Debit_Order_Branch_Name__c, Debit_Order_Account_Number__c, Debit_Order_Account_Type__c, Debit_Order_Date__c,Debit_Order_Debit_Day__c,Debit_Order_Salary_Day__c,Debit_Order_Gross_Monthly_Income__c FROM Opportunity where id=:OppId limit 1]; 
        //return [SELECT Id, Debit_Order_Status__c FROM Opportunity where id=:OppId limit 1];
    }
            
    @AuraEnabled
    public static Boolean checkBankAccount(string accountNumber, String branchCode, String accountType, String transactionType, String cdvRequired, String expiryDate, String channel, String application, String msgLanguage, String msgTarget, String trace){
        // call the CheckDigitVerification_IH_v1 to check if account details are valid or not 
        CheckDigitVerification_Resp_IB_v1 accountResponse = CheckDigitVerification_IH_v1.checkDigitVerification( accountNumber, branchCode, accountType, transactionType, cdvRequired, expiryDate , channel, application,  msgLanguage,  msgTarget, trace);
        if(accountResponse.rc== '0'){
            System.debug('success in verification account :' +accountResponse.message + accountResponse.status+accountResponse.statusCode);
            return true;
        } else{
            System.debug('Error in verification account :' +accountResponse.message);
            return false ;
        }
    }
    
    @AuraEnabled
    public static void  createDebitOrder(opportunity Opp,Id OppId){
        opportunity Opps= new opportunity();
        Opps=opp;
        Opps.Id=OppId;
        Opps.StageName = 'Submission';
        
        System.debug('Opportunity to update '+Opps); 
        try{
            update Opps;            
        }
        catch(exception e){
            System.debug('Error while updating Opportunity with Bank Debit Order details :' +e);
            
        }
        
    }
        
    @AuraEnabled
    public static List <String> getselectOptions(sObject objObject, string fld) {
        List <String> allOpts = new list <String> ();
        Schema.sObjectType objType = objObject.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        
        map <String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        
        list <Schema.PicklistEntry> values = fieldMap.get(fld).getDescribe().getPickListValues();
        
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        allOpts.sort();
        return allOpts;
    }
    
    @AuraEnabled
    public static void  createBankDebitOrder(opportunity Opp,Id OppId,String productName){
        opportunity Opps= new opportunity();
        Opps=opp;
        List<Quote> quotesToUpdate = new List<Quote>();
        system.debug('Opps@@'+Opps);
        List<Quote> quotes = new QuotesSelector().selectByProductName(OppId,productName); 
        for(Quote qt : quotes){
           	qt.Debit_Order_Account_Number__c =Opps.Debit_Order_Account_Number__c;
        	qt.Debit_Order_Account_Type__c =Opps.Debit_Order_Account_Type__c;
       	 	qt.Debit_Order_Bank_Name__c =Opps.Debit_Order_Bank_Name__c;
        	qt.Debit_Order_Branch_Code__c =Opps.Debit_Order_Branch_Code__c;
        	qt.Debit_Order_Branch_Name__c =Opps.Debit_Order_Branch_Name__c;
        	qt.Debit_Order_Date__c =Opps.Debit_Order_Date__c;
            qt.Debit_Order_Salary_Day__c =Opps.Debit_Order_Salary_Day__c;
            qt.Payment_Method__c =Opps.Payment_Method__c;
            qt.Commencement_Date__c =Opps.Commencement_Date__c;
            qt.Material_Disclosure_Status__c ='New';
            quotesToUpdate.add(qt);
        }
        
        try{
            update quotesToUpdate;            
        }
        catch(exception e){
            System.debug('Error while updating Opportunity with Bank Debit Order details :' +e);
            
        }
        
    }
    
    @AuraEnabled
    public static List<BankData> getBankData(Id oppId){
        List<BankData> accDatalist = new List<BankData>();
        
        List<Quote> quotes = new QuotesSelector().selectQuoteByOpportunityId(oppId);
        Map<String,BankData> QuotesWithAccNumber =  new Map<String,BankData>();        
        if(!quotes.isEmpty() && quotes != null){ 
                for(Quote output : quotes){
                    if(output.Debit_Order_Account_Number__c != '' && output.Debit_Order_Account_Number__c != null){
                        BankData accData = new BankData();
                        accData.bankNum = output.Debit_Order_Account_Number__c;
                        accData.aType = output.Debit_Order_Account_Type__c;
                        accData.bName = output.Debit_Order_Bank_Name__c;
                        accData.bCode = output.Debit_Order_Branch_Code__c;
                        accData.brName = output.Debit_Order_Branch_Name__c;
                        QuotesWithAccNumber.put(accData.bankNum,accData);                        
                        accDatalist.add(accData);
                    }
                }
                
                if(accDatalist.size() >= 1){
                    return QuotesWithAccNumber.values();
                }
            
        }
        return null;
    }
    
   /* @AuraEnabled
    public static void createBankDebitOrderForQuote(Id OppId,String productName,String bNumber,String bName,Integer bCode,String brName,String accType){
        
        List<Quote> quotesToUpdate = new List<Quote>();
        
        List<Quote> quotes = new QuotesSelector().selectByProductName(OppId,productName); 
        for(Quote qt : quotes){
           	qt.Debit_Order_Account_Number__c =bNumber;
        	qt.Debit_Order_Account_Type__c =accType;
       	 	qt.Debit_Order_Bank_Name__c =bName;
        	qt.Debit_Order_Branch_Code__c =bCode;
        	qt.Debit_Order_Branch_Name__c =brName;
        	
            quotesToUpdate.add(qt);
        }
        
        try{
            update quotesToUpdate;            
        }
        catch(exception e){
            System.debug('Error while updating Opportunity with Bank Debit Order details :' +e);
            
        }
        
    }*/
    
    @AuraEnabled
    public static Quote getQuotesId(Id oppId,String productName){

        List<Quote> quotes = new QuotesSelector().selectByProductName(oppId,productName);
        return quotes[0];
    }
    
    public class AccountData{
        @AuraEnabled public String accNum;
        @AuraEnabled public String product;
        @AuraEnabled public String productType;
        @AuraEnabled public String corp;
        @AuraEnabled public String status;
        @AuraEnabled public String balance;
    }
    
    public class BankData{
        @AuraEnabled public String bankNum;
        @AuraEnabled public String bName;
        @AuraEnabled public String brName;
        @AuraEnabled public Decimal bCode;
        @AuraEnabled public String aType;
        
    }
}