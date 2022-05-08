public class AddViewChargeController {
    
    public static Case currentCase {get;set;}
    public static List<Charge__c> chargeList {get;set;}
    public static List<ChargeWrapper> chargeWrapperList {get;set;}
    
    public static Boolean isSystemAdmin{get;set;}
    public static Integer CRID {get;set;}
    public static ID CurrentCaseId {get;set;}
    
    public static final String unableToEditMsg = Label.lbl_UnableToEditMsg;
    public static final String mustHaveValueErrorMsg = 'Must have a value ';
    public static String errorMsg = '';
    
    private static Response myResponse = new Response();
    private static List<Dictionery> transactionCodeList = null;
    private static List<Dictionery> corpCodeList = null;
    private static List<Dictionery> crAccountNoList = null;
    
    public class Response{
        public Case currentCase {get;set;}
        public List<Charge__c> chargeList{get;set;}
        @AuraEnabled
        public List<ChargeWrapper> chargeWrapperList {get;set;}
        
        public Integer CRID {get;set;}
        public Boolean isSystemAdmin {get;set;}
        public Id CurrentCaseId {get;set;}
        
        public String unableToEditMsg = Label.lbl_UnableToEditMsg;
        public String mustHaveValueErrorMsg = 'Must have a value ';
        public String errorMsg = '';
        
        public List<Dictionery> TransactionCodeList = null;
        public List<Dictionery> CorpCodeList = null;
        public List<Dictionery> CrAccountNoList = null;
    }
    
    public static Response parse(String json) {
        return (Response) System.JSON.deserialize(json, Response.class);
    }
    
    public static Response MapResponse() {
        MyResponse.currentCase = currentCase;
        MyResponse.chargeList = chargeList;
        MyResponse.chargeWrapperList = chargeWrapperList;
        
        MyResponse.CRID = CRID;
        MyResponse.isSystemAdmin = isSystemAdmin;
        MyResponse.currentCaseID = CurrentCaseID;
        
        
        MyResponse.unableToEditMsg = unableToEditMsg;
        MyResponse.mustHaveValueErrorMsg = mustHaveValueErrorMsg;
        MyResponse.errorMsg = errorMsg;
        
        MyResponse.transactionCodeList = transactionCodeList;
        MyResponse.corpCodeList = corpCodeList;
        MyResponse.crAccountNoList = crAccountNoList;
        return MyResponse;
    }
    
    public static void MapToInstance(Response instance) {
        currentCase = instance.currentCase;
        chargeList = instance.chargeList;
        chargeWrapperList = instance.chargeWrapperList;
        
        CRID = instance.CRID;
        isSystemAdmin = instance.isSystemAdmin;
        currentCaseId = instance.currentCaseId;
        
        transactionCodeList = instance.transactionCodeList;
        corpCodeList = instance.corpCodeList;
        crAccountNoList = instance.crAccountNoList;
        errorMsg = '';
        //UnableToEditMsg = instance.UnableToEditMsg;
        //MustHaveValueErrorMsg = instance.MustHaveValueErrorMsg;
    }
    
    @AuraEnabled 
    public static String AddViewChargeLoad(String model, String recordId) {	
        //Response instance = parse(model);
        try{
            List<String> caseFields = new List<String>();
            Charge__c charge = new Charge__c();
            transactionCodeList = getPickValues(charge, 'Transaction_Code__c', null);
            corpCodeList = getPickValues(charge, 'Corp_Code__c', null);
            crAccountNoList = getPickValues(charge, 'CR_Account_No__c', null);
            
            caseFields.add('Charge_Locked__c');
            
            currentCase = [select id, Charge_Locked__c, RecordTypeId from Case where ID=:recordId];//(Case)controller.getRecord();
            
            isSystemAdmin = isSystemAdminProfileById(UserInfo.getProfileId());
            getCaseCharge(currentCase.ID);
            
        }catch(exception e) {
            errorMsg = e.getMessage();
        }
        return JSON.serialize(MapResponse());
    }
    
    public static List<Dictionery> getPickValues(sObject object_name, String field_name, String first_val) {
        
        List<Dictionery> options = new List<Dictionery>(); //new list for holding all of the picklist options
        if (first_val != null) { //if there is a first value being provided
            options.add(new Dictionery(first_val, first_val)); //add the first option
        }
        Schema.sObjectType sobject_type = object_name.getSObjectType(); //grab the sobject that was passed
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        List<Schema.PicklistEntry> pick_list_values = field_map.get(field_name).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
            options.add(new Dictionery(a.getValue(), a.getLabel())); //add the value and label to our final list
        }
        return options; //return the List
    }
    
    private static boolean isSystemAdminProfileById(Id profileId) {
        
        String profileName = [Select Name from Profile where ID =:profileId limit 1].Name;
        
        if(profileName.equalsIgnoreCase('System Administrator (Custom)') || profileName.equalsIgnoreCase('System Administrator')) {
            return true;
        }else{
            return false;
        }
    }
    
    public static void getCaseCharge(ID CaseID) {
        chargeList = new List<Charge__c>();
        chargeWrapperList = new List<ChargeWrapper>();
        
        chargeList = [Select Id, Name, Charge_Account_No__c, Charge_Amount__c, Transaction_Code__c, Corp_Code__c, Cost_Centre__c, Case__c, 
                      CR_Ref__c, DR_Ref__c, CR_Account_No__c, Effective_Date__c, Sub_Ledger__c From Charge__c where Case__c =:CaseID];
        
        Integer index = 0;
        
        for(Charge__c c :chargeList) {
            chargeWrapperList.add(new ChargeWrapper(index,c));
            index+=1;
        }
    }
    
    @AuraEnabled
    public static string addnewLine1(string model){
        try{
            Response instance = parse(model);
            MapToInstance(instance);
            addnewLine();
        }catch(exception e) {
            errorMsg = e.getMessage();
        }
        return JSON.serialize(MapResponse());
    }
    
    @AuraEnabled
    public static string saveUpdates1(string recordId, string model){
        try{
            Response instance = parse(model);
            MapToInstance(instance);
            SaveUpdates();
        }catch(exception e) {
            errorMsg = e.getMessage();
        }
        return JSON.serialize(MapResponse());
    }
    
    @AuraEnabled
    public static boolean SaveNewCharges(String chargeList){
        try{
            Charge__c[] chargeLst = (Charge__c[])JSON.deserialize(chargeList, List<Charge__c>.class);
            upsert chargeLst id;
            return true;
        }catch(exception e) {
            return false;
        }
    }
    
    @AuraEnabled
    public static string unlock11(string recordId, string model){
        try{
            Response instance = parse(model);
            MapToInstance(instance);
            unlock();
            getCaseCharge(currentCase.ID);
        }catch(exception e) {
            errorMsg = e.getMessage();
        }
        return JSON.serialize(MapResponse());
    }
    
    @AuraEnabled
    public static string lockCharges1(string recordId, string model){
        try{
            Response instance = parse(model);
            
            MapToInstance(instance);
            LockCharges();
            getCaseCharge(currentCase.ID);
        }catch(exception e) {
            errorMsg = e.getMessage();
        }
        return JSON.serialize(MapResponse());
    }
    
    @AuraEnabled
    public static boolean lockCharges(string recordId) {
        try{
            Case existingcase = new Case(id = recordId);
            existingcase.Charge_Locked__c = true;
            
            update existingcase;
            return true;
        }catch(Exception exc){
            return false;
        }
    }
    
    @AuraEnabled
    public static boolean DeleteCharge(string chargeId){
        try{
            Charge__c existingCharge = new Charge__c(id = chargeId);
            
            delete existingCharge;
            return true;
        }catch(Exception exc){
            return false;
        }
    }
    
    @AuraEnabled
    public static string deleteItem1(string recordId, string model){
        try{
            Response instance = parse(model);
            MapToInstance(instance);
            if(!currentCase.Charge_Locked__c){
                Charge__c toDelete =  [SELECT Id FROM Charge__c WHERE Id=:recordId];
                delete toDelete;
                getCaseCharge(currentCase.ID);            
            }
        }catch(exception e) {
            
            errorMsg = e.getMessage();
        }
        return JSON.serialize(MapResponse());
    }
    
    public static void unlock() {
        currentCase.Charge_Locked__c = false;
        update currentCase;
    }
    
    public static void LockCharges(){
        if(currentCase.Charge_Locked__c){
            // To Do : Add message stating charges have already been locked
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,Label.lbl_ChargeAlreadyApproved));
        }else{
            currentCase.Charge_Locked__c = true;
            update currentCase;
        }
    }
    
    public static void SaveUpdates() {
        boolean errorFound  =false;
        if(!currentCase.Charge_Locked__c){
            List<Charge__c> chargeToInsert = new List<Charge__c>();
            for(ChargeWrapper currentCharge : chargeWrapperList){
                if(currentCharge.charge.Id == null){
                    Charge__c newCharge = new Charge__c();
                    newCharge.Case__c = currentCharge.charge.Case__c;
                    newCharge.Charge_Account_No__c = currentCharge.charge.Charge_Account_No__c;
                    newCharge.Charge_Amount__c = currentCharge.charge.Charge_Amount__c;
                    newCharge.Corp_Code__c = currentCharge.charge.Corp_Code__c;
                    newCharge.CR_Account_No__c = currentCharge.charge.CR_Account_No__c;
                    newCharge.CR_Ref__c = currentCharge.charge.CR_Ref__c;
                    newCharge.CR_Account_No__c = currentCharge.charge.CR_Account_No__c;
                    newCharge.Transaction_Code__c = currentCharge.charge.Transaction_Code__c;
                    newCharge.Cost_Centre__c = currentCharge.charge.Cost_Centre__c;
                    newCharge.DR_Ref__c = currentCharge.charge.DR_Ref__c;
                    newCharge.Effective_Date__c = currentCharge.charge.Effective_Date__c;
                    newCharge.sub_Ledger__c = currentCharge.charge.sub_Ledger__c;
                    
                    chargeToInsert.add(newCharge);
                }else{
                    chargeToInsert.add(currentCharge.charge);
                }
            }
            
            if(chargeToInsert.size()>0 && !errorFound){
                upsert chargeToInsert ID;
                getCaseCharge(CurrentCase.ID);
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.lbl_ChargeSuccessMsg));
            }else{
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Please review the below Error'));
            }
            
        }else{
            // To do : Add validation message that will show that once approved users can no longer update the charges
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, UnableToEditMsg));
        }
    }
    
    public static void DeleteItem() {
        if(!currentCase.Charge_Locked__c) {
            Charge__c chargeToDelete;
            if(!String.isBlank(String.valueOf(CRID))){
                ChargeWrapper CW = chargeWrapperList.get(CRID);
                
                if(String.ISBLANK(CW.charge.ID)){
                    chargeWrapperList.remove(CRID);
                }else{
                    chargeToDelete = new Charge__c(ID = chargeWrapperList.get(CRID).charge.Id);
                    delete chargeToDelete;
                    chargeWrapperList.remove(CRID);
                }
                updateSequence();
            }
        }else{
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, UnableToEditMsg));
        }
    }
    
    private static void addnewLine() {
        if(!currentCase.Charge_Locked__c) {
            Integer index=chargeWrapperList.size();
            
            chargeList.add(new Charge__c(Case__c =  currentCase.Id));
            
            chargeWrapperList.add(new ChargeWrapper(index++, new Charge__c(// Id = null,
                Case__c = currentCase.Id,
                Charge_Account_No__c = '',
                Charge_Amount__c = 0,
                Transaction_Code__c = '',
                Corp_Code__c = '',
                Cost_Centre__c = '',
                CR_Ref__c = '',
                DR_Ref__c = '',
                CR_Account_No__c = '',
                Effective_Date__c = system.today())));
        }else{
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,UnableToEditMsg));
        }
    }
    
    public static void updateSequence() {
        integer index = 0;
        for(ChargeWrapper chargeWR : chargeWrapperList){
            chargeWR.index=0;
            index +=1;
        }
    }
    
    public class ChargeWrapper {
        @AuraEnabled
        public Charge__c charge{get;set;}
        
        @AuraEnabled
        public Integer index{get;set;}
        
        public ChargeWrapper(Integer index,Charge__c CR) {
            this.charge = CR;
            this.index = index;
        }
    }
    
    
    public class Dictionery{
        public string label{get;set;}
        public string value{get;set;}
        public boolean valueSelected{get;set;}
        
        public Dictionery(string label, string value){
            this.label = label;
            this.value = value;
            this.valueSelected = false;
        }
    }
    
}