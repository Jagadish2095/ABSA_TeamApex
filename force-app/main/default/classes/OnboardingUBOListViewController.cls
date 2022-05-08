/**
 * @description Class to get the list of Accounts and Contacts for the primary Account
 * @author Gopi
 * @date 08/07/2020
 * @work Id W-004935
 */
public class OnboardingUBOListViewController {

    /**
    * @description W-004935 Method to display the UBO structure of a company
    * @Owner: Masechaba Maseli, 26/07/2020
    * @param accountId
    * @return String
    */
    @AuraEnabled
    public static String getRelatedParties(Id accountId) {
     List<ParentAccountWrapper> ParentAccwrapperList = new List<ParentAccountWrapper>(); 
     Map<Id, List<AccountWrapper>> loadChildAccWrapper = new  Map<Id,List<AccountWrapper>>();
     Map<Id, List<AccountWrapper>> loadChildAccWrapper2 = new  Map<Id,List<AccountWrapper>>();
     Map<String, Decimal> controlInterestRecMap = new Map<String, Decimal>();
     Map<String, String> uboMap = new Map<String, String>();
     List<String> relatedAccAccIds = new List<String>();
     Map<Id,FinServ__AccountAccountRelation__c> allAccAccRecs = new Map<Id,FinServ__AccountAccountRelation__c>();
     Set<FinServ__AccountAccountRelation__c> deDupeSet = new Set<FinServ__AccountAccountRelation__c>();
     List<Id> storeSubIds = new List<Id>();
     List<Id> sortList = new List<Id>();
     List<Id> reverseSortList = new List<Id>();
     String shareholder = 'Shareholder/Controller';
     String inverseRelationship = 'Inverse Testing';
        
     List<Account> acclist = [Select Id,Name, Client_Type__c From Account WHERE Id =: accountId];   
     List<FinServ__AccountAccountRelation__c> firstLevel = new AccountAccountRelationSelector().selectbyPrimaryEntityIdFiltered(accountId,inverseRelationship);
     List<FinServ__AccountAccountRelation__c> loopAccAccList = new List<FinServ__AccountAccountRelation__c>();
 
        for(integer i = 0; i < firstLevel.size(); i ++) {
        storeSubIds.add(firstLevel[i].FinServ__RelatedAccount__c);  
        If(firstLevel[i].Primary_Entity_Id__c == firstLevel[i].FinServ__Account__c){
        sortList.add(firstLevel[i].Id);}}
     storeSubIds.add(accountId);  
     List<FinServ__AccountAccountRelation__c> subsequentLevels = new AccountAccountRelationSelector().selectbyPrimaryEntityListFiltered(storeSubIds,inverseRelationship);
     List<AccountContactRelation> allAccCons = new AccountContactRelationSelector().parentIn(storeSubIds);  
     firstLevel.AddAll(subsequentLevels); 

     deDupeSet.addAll(firstLevel);
     firstLevel.clear();
     firstLevel.addAll(deDupeSet);
               
     for(integer i = 0; i < firstLevel.size(); i ++) { 
         allAccAccRecs.put(firstLevel[i].Id, firstLevel[i]);
         If(sortList.contains(firstLevel[i].ParentRelationshipId__c) || allAccAccRecs.containsKey(firstLevel[i].FinServ__Account__c)){
         sortList.add(firstLevel[i].Id);
         }
     }
      
    for(integer i = sortList.size() - 1; i >=  0; i --) {
        loopAccAccList.add(allAccAccRecs.get(sortList[i]));
        reverseSortList.add(sortList[i]);}
        
        List<Controlling_Interest__c> existingConInterestList = [Select Primary_Entity__c, Parent_Account__c, Contact__c, Controlling_Interest__c, UBO__c, Related_Account__c, Other_Primary_Entity_Id__c
                                                                FROM Controlling_Interest__c 
                                                                WHERE Primary_Entity__c =: accountId];
        
        for(integer i = 0; i < existingConInterestList.size(); i ++) {
         If(existingConInterestList[i].Contact__c ==  null){
         String mapKeyCIRec =    existingConInterestList[i].Other_Primary_Entity_Id__c + '' + existingConInterestList[i].Parent_Account__c + '' + existingConInterestList[i].Related_Account__c;
         controlInterestRecMap.put(mapKeyCIRec,existingConInterestList[i].Controlling_Interest__c)  ;
         uboMap.put(mapKeyCIRec,existingConInterestList[i].UBO__c);}
         else{
         String mapKeyCIRec = existingConInterestList[i].Other_Primary_Entity_Id__c + '' + existingConInterestList[i].Parent_Account__c + '' + existingConInterestList[i].Contact__c;
         controlInterestRecMap.put(mapKeyCIRec,existingConInterestList[i].Controlling_Interest__c)  ; 
         uboMap.put(mapKeyCIRec,existingConInterestList[i].UBO__c);}}
  
    for (Account  acc : acclist){
    Integer count = 0;
        
        for(AccountContactRelation a : allAccCons){
         String mapKey = a.Primary_Entity_Id__c + '' + a.AccountId + '' + a.ContactId;
            AccountWrapper aWraper = new AccountWrapper() ; 
            aWraper.Shareholder =a.Contact.FirstName + ' ' +  a.Contact.LastName;
            aWraper.Type = a.Contact.Account.Client_Type__c;
            aWraper.idType = a.Contact.ID_Type__c;
            aWraper.ShareholderCount = 0;
            aWraper.ParentShareholding  = a.Share_Percentage__c;
            aWraper.Controllinginterest = controlInterestRecMap.get(mapKey);
            aWraper.UBO = uboMap.get(mapKey);   
            aWraper.recordId = a.Id;
            aWraper.relatedAccountId = a.AccountId;
            aWraper.primaryEntityId = a.Primary_Entity_Id__c;
            aWraper.parentAccountId = a.AccountId;
            aWraper.accType= 'AccountContact'; 
            If(loadChildAccWrapper.containsKey(a.AccountId)){     
            List<AccountWrapper> aooo2 = loadChildAccWrapper.get(a.AccountId);       
            aooo2.add(aWraper); loadChildAccWrapper.put(a.AccountId,aooo2) ;}   
            Else{loadChildAccWrapper.put(a.AccountId, New List<AccountWrapper>{aWraper}); }}  
     
          
            for(FinServ__AccountAccountRelation__c a : loopAccAccList){ 
            String mapKey = a.Primary_Entity_Id__c + '' + a.FinServ__Account__c + '' + a.FinServ__RelatedAccount__c;
            AccountWrapper aWraper = new AccountWrapper() ; 
            aWraper.Shareholder = a.FinServ__RelatedAccount__r.Name ; 
            aWraper.Type = a.FinServ__RelatedAccount__r.Client_Type__c;
            aWraper.idType = a.FinServ__RelatedAccount__r.ID_Type__c;
            aWraper.ShareholderCount = loadChildAccWrapper.get(a.FinServ__RelatedAccount__c) != Null? loadChildAccWrapper.get(a.FinServ__RelatedAccount__c).size():0;
            aWraper.ParentShareholding  = a.Shareholding_Percentage__c;
            aWraper.Controllinginterest = controlInterestRecMap.get(mapKey);
            aWraper.UBO = '';
            aWraper.recordId = a.Id;
            aWraper.relatedAccountId = a.FinServ__RelatedAccount__c;
            aWraper.primaryEntityId = a.Primary_Entity_Id__c;
            aWraper.parentAccountId = a.FinServ__Account__c;
            aWraper.accType= 'AccountAccount'; 
            aWraper.childwrplist = loadChildAccWrapper.get(a.FinServ__RelatedAccount__c);   
            If(loadChildAccWrapper2.containsKey(a.FinServ__Account__c)){      
            List<AccountWrapper> aooo2 = loadChildAccWrapper2.get(a.FinServ__Account__c);       
            aooo2.add(aWraper);  loadChildAccWrapper2.put(a.FinServ__Account__c,aooo2) ;}
            Else{loadChildAccWrapper2.put(a.FinServ__Account__c, New List<AccountWrapper>{aWraper}) ;}   
            If(loadChildAccWrapper.containsKey(a.FinServ__Account__c)){      
            List<AccountWrapper> aooo2 = loadChildAccWrapper.get(a.FinServ__Account__c);       
            aooo2.add(aWraper); loadChildAccWrapper.put(a.FinServ__Account__c,aooo2) ; }
            Else{loadChildAccWrapper.put(a.FinServ__Account__c, New List<AccountWrapper>{aWraper}) ;}}
     
          ParentAccountWrapper  paracc = new ParentAccountWrapper();
           paracc.Shareholder = acc.name ;
           paracc.Type =  acc.Client_Type__c;
           paracc.ParentShareholding =  100;
           paracc.Controllinginterest = 100; 
           paracc.accType= 'Account';
           paracc.recordId= accountId;
           paracc.ShareholderCount =  loadChildAccWrapper.get(accountId) != Null? loadChildAccWrapper.get(accountId).size() : 0 ;
           paracc.Accwrplist= loadChildAccWrapper.get(accountId);
           ParentAccwrapperList.clear();
           ParentAccwrapperList.add(paracc);

             
    }
     
        
		return JSON.serializePretty(ParentAccwrapperList) ;
    
    }

    /**
    * @description Related Accounts/Contact Wrapper W-004935
    */
        public Class AccountWrapper{
            /**
            * @description Shareholder
            */
			@AuraEnabled
			public String Shareholder {get;set;}
            /**
            * @description Type
            */
			@AuraEnabled
			public String Type {get;set;}
            /**
            * @description idType
            */
			@AuraEnabled
            public String idType {get;set;}
            /**
            * @description ShareholderCount
            */
			@AuraEnabled
			public Integer ShareholderCount {get;set;}
            /**
            * @description ParentShareholding
            */
			@AuraEnabled
			public Decimal ParentShareholding {get;set;}
            /**
            * @description Controllinginterest
            */
			@AuraEnabled
			public Decimal Controllinginterest {get;set;}
            /**
            * @description accType
            */
            @AuraEnabled
			public String accType {get;set;}
            /**
            * @description roles
            */
            @AuraEnabled
			public String roles {get;set;}
            /**
            * @description UBO
            */
            @AuraEnabled
			public String UBO {get;set;}
            /**
            * @description recordId
            */
            @AuraEnabled
			public String recordId {get;set;}
            /**
            * @description relatedAccountId
            */
            @AuraEnabled
			public String relatedAccountId {get;set;}
            /**
            * @description parentAccountId
            */
            @AuraEnabled
			public String parentAccountId {get;set;}
            /**
            * @description primaryEntityId
            */
			@AuraEnabled
			public String primaryEntityId {get;set;}
            /**
            * @description childwrplist
            */
			@AuraEnabled
			public List<AccountWrapper> childwrplist {get;set;}
        } 
        
        /**
        * @description Primary Account Wrapper W-004935
        */
    	public Class ParentAccountWrapper{
            /**
            * @description Shareholder
            */
			@AuraEnabled				
			public String Shareholder {get;set;}
            /**
            * @description Type
            */
			@AuraEnabled
			public String Type {get;set;}
            /**
            * @description ShareholderCount
            */
			@AuraEnabled
			public Integer ShareholderCount {get;set;}
            /**
            * @description ParentShareholding
            */
			@AuraEnabled
			public Decimal ParentShareholding {get;set;}
            /**
            * @description Controllinginterest
            */
			@AuraEnabled
			public Decimal Controllinginterest {get;set;}            
            /**
            * @description accType
            */
		    @AuraEnabled
			public String accType {get;set;}
            /**
            * @description recordId
            */
            @AuraEnabled
			public String recordId {get;set;}
            /**
            * @description Accwrplist
            */
			@AuraEnabled
			public List<AccountWrapper> Accwrplist {get;set;}
       
    }
    
    /**
    * @description W-004945 Method to calculate ControllingPercentage on Account Account Relationship
    * @Owner: Chandra, 16/07/2020
    * @param accAccRelId
    * @param sharePercentage
    * @param roles
    */
    @AuraEnabled
    public static void calculateControllingPercentageforAccAccRel(Id accAccRelId, Decimal sharePercentage, String roles){
        
        FinServ__AccountAccountRelation__c accAccRelObj = new AccountAccountRelationSelector().selectbyAccAccRelId(accAccRelId);
        List<AccountContactRelation> acr = new AccountContactRelationSelector().selectbyPrimaryEntityId(accAccRelObj.Primary_Entity_Id__c);
        accAccRelObj.Shareholding_Percentage__c=sharePercentage;
        accAccRelObj.Roles__c=roles;
        try {
          //  AccountAccountRelationController.calculateControllingPercentageValOnUpdate(accAccRelObj);
            AccountAccountRelationController.calculateControllingPercentageVal2(accAccRelObj, accAccRelObj.Primary_Entity_Id__c);
           // AccountContactRelationController.calculateControllingPercentageVal2(acr[0],accAccRelObj.Primary_Entity_Id__c);
        } catch (Exception e) {            
            throw new AuraHandledException('An unexpected error has occurred: '+ e.getMessage());            
        }   
    }
    
    /**
    * @description W-004939 Method to delete Hierarchy records when Account Account Relationship record is deleted 
    * @Owner: Chandra, 16/07/2020
    * @param accAccRelId
    */
    @AuraEnabled
    public static void deleteRelatedHierarchyRecords(Id accAccRelId){
        List<FinServ__AccountAccountRelation__c> accAccRelList = new List<FinServ__AccountAccountRelation__c>();
        Set<Id> relAccIdSet = new Set<Id>();
		List<AccountContactRelation> accConRelList = new List<AccountContactRelation>();
        String primaryEntityId;
        Id currentAccAccRelId;
        FinServ__AccountAccountRelation__c accAccRelObj = new AccountAccountRelationSelector().selectbyAccAccRelId(accAccRelId);
        primaryEntityId = accAccRelObj.Primary_Entity_Id__c;
        currentAccAccRelId = accAccRelObj.Id;
        relAccIdSet.add(accAccRelObj.FinServ__RelatedAccount__c);
        
        List<FinServ__AccountAccountRelation__c> accAccRelObjectList = new AccountAccountRelationSelector().selectbyPrimaryEntityId(primaryEntityId);
        
        if(!accAccRelObjectList.isEmpty()){
            for(FinServ__AccountAccountRelation__c accAccRelObject : accAccRelObjectList){
                if(relAccIdSet.contains(accAccRelObject.FinServ__Account__c)){
                    if(accAccRelObject.Id != currentAccAccRelId){
                    	accAccRelList.add(accAccRelObject);
                    }
                    if(String.isNotBlank(accAccRelObject.FinServ__RelatedAccount__c)){
                    	relAccIdSet.add(accAccRelObject.FinServ__RelatedAccount__c);    
                    }
                    
                }
            }
        }
        
        if(!relAccIdSet.isEmpty()){
			for(List<AccountContactRelation> accConList : [SELECT Id FROM AccountContactRelation WHERE AccountId IN :relAccIdSet 
															AND Primary_Entity_Id__c = :primaryEntityId]){
				if(!accConList.isEmpty()){
					accConRelList.addAll(accConList);
				}
			}
		}
		
        try {
			Database.delete(accConRelList,false);
            Database.delete(accAccRelList,false);
            
        } catch (Exception e) {            
            throw new AuraHandledException('An unexpected error has occurred: '+ e.getMessage());            
        }   
    }

    /**
    * @description Method to calculate ControllingPercentage on Account Account Relationship on deletion
    * @Owner: Masechaba Maseli, 16/07/2020
    * @param relPartyId
    * @param deletionRec
    * @param primaryEntityId
    */
    @AuraEnabled
        public static void calculateControllingInterest(Id relPartyId, String deletionRec, Id primaryEntityId){
        
    try {
    String stringId = relPartyId; 
     String inverseRelationship = 'Inverse Testing';
     List<id> allrelatedIds = new List<id>();
     List<FinServ__AccountAccountRelation__c> accAccDelList = new List<FinServ__AccountAccountRelation__c>();
     List<AccountContactRelation> accConDelList = new List<AccountContactRelation>();
     List<id> allchildrenRelatedIds = new List<id>();
     List<id> allchildrenAccCon = new List<id>();
     List<Controlling_Interest__c> deleteListCiRec = new List<Controlling_Interest__c>();
    // List<FinServ__AccountAccountRelation__c> accAccDelList = new List<FinServ__AccountAccountRelation__c>();
        
     Map<String, String> controlInterestRecMap = new Map<String, String>();    
        
        
        
      List<Controlling_Interest__c> existingConInterestList2 = [Select Primary_Entity__c, Parent_Account__c, Contact__c, Controlling_Interest__c, UBO__c, Related_Account__c, Other_Primary_Entity_Id__c
                                                                FROM Controlling_Interest__c 
                                                                WHERE Primary_Entity__c =: PrimaryEntityId];
        
         for(integer i = 0; i < existingConInterestList2.size(); i ++) {
                
                If(existingConInterestList2[i].Contact__c ==  null){
               String mapKeyCIRec =    existingConInterestList2[i].Primary_Entity__c + '' + existingConInterestList2[i].Parent_Account__c + '' + existingConInterestList2[i].Related_Account__c;
               controlInterestRecMap.put(mapKeyCIRec,existingConInterestList2[i].Id)  ;}
                else{
                 
               String mapKeyCIRec =    existingConInterestList2[i].Primary_Entity__c + '' + existingConInterestList2[i].Parent_Account__c + '' + existingConInterestList2[i].Contact__c;
               controlInterestRecMap.put(mapKeyCIRec,existingConInterestList2[i].Id)  ;   
                    
                } 
                           
                
            }
               
      
    If(deletionRec != null && !stringId.startsWith('07k')){
        
     FinServ__AccountAccountRelation__c deleteAccRec = new AccountAccountRelationSelector().selectbyAccAccRelId(deletionRec);
        
        accAccDelList.add(deleteAccRec);
     
     String relatedId = deleteAccRec.FinServ__RelatedAccount__c;
        
      for(integer i = 0; i < existingConInterestList2.size(); i ++) {
         
      If(existingConInterestList2[i].Other_Primary_Entity_Id__c == relatedId || 
         (existingConInterestList2[i].Related_Account__c == relatedId && existingConInterestList2[i].Other_Primary_Entity_Id__c == primaryEntityId )){
            
       deleteListCiRec.add(existingConInterestList2[i]);    }   }
        
    }
        
    else if(deletionRec != null && stringId.startsWith('07k')){       
      AccountContactRelation deleteAccConRec = new AccountContactRelationSelector().selectbyAccountContactRelationId(deletionRec) ;    
      accConDelList.add(deleteAccConRec) ;
        
     for(integer i = 0; i < existingConInterestList2.size(); i ++) {
         
      If(existingConInterestList2[i].Other_Primary_Entity_Id__c == deleteAccConRec.Primary_Entity_Id__c && 
         existingConInterestList2[i].Contact__c == deleteAccConRec.ContactId && 
         existingConInterestList2[i].Parent_Account__c == deleteAccConRec.AccountId ){
            
       deleteListCiRec.add(existingConInterestList2[i]);    }   } 
        
        
            
        }
        
     delete accAccDelList;
     delete accConDelList;
     delete deleteListCiRec;
        
                
     List<FinServ__AccountAccountRelation__c> accountAccountRelationshipList = new AccountAccountRelationSelector().selectbyPrimaryEntityIdFiltered(primaryEntityId, inverseRelationship); 
        
        If(accountAccountRelationshipList.size()>0){
            
      //AccountAccountRelationController.calculateControllingPercentageVal2(accountAccountRelationshipList[0], primaryEntityId);      
      parentAccountWrapper(primaryEntityId, true);
    }        
    
        Else{
        List<AccountContactRelation> accountContactRelationshipList = new AccountContactRelationSelector().selectbyPrimaryEntityId(primaryEntityId);    
       If(accountContactRelationshipList.size()>0){
            //AccountContactRelationController.calculateControllingPercentageVal2(accountContactRelationshipList[0],primaryEntityId);
            parentAccountWrapper(primaryEntityId, true);
        }
        }  
    } catch (Exception e) {            
            throw new AuraHandledException('An unexpected error has occurred: '+ e.getLineNumber()+ e.getMessage());            
        }   
    }
    
    /**
    * @description W-004939 Method to Re-Evaluate Controlling Interest when Account Contact Relationships record is deleted 
    * @Owner: Chandra, 03/08/2020
    * @param recordId
    */
    @AuraEnabled
    public static void reEvaluateControllingPercentage(Id recordId){
        Decimal controllingPerctToDecrease;
        List<AccountContactRelation> accConListToUpdate = new List<AccountContactRelation>();
        AccountContactRelation accContactRelObj = new AccountContactRelationSelector().selectbyaccConRelId(recordId);
        List<FinServ__AccountAccountRelation__c> accAccRelObj = new AccountAccountRelationSelector().selectbyPrimaryEntityIdAndRelatedAccId(accContactRelObj.Primary_Entity_Id__c,accContactRelObj.AccountId);
        List<AccountContactRelation> accConRelList = new AccountContactRelationSelector().selectbyPrimaryEntityIdAndContactId(accContactRelObj.Primary_Entity_Id__c,accContactRelObj.ContactId);
        
        if(accContactRelObj.Share_Percentage__c != null && accAccRelObj[0].Controlling_Percentage__c != null){
            controllingPerctToDecrease = (accContactRelObj.Share_Percentage__c * accAccRelObj[0].Controlling_Percentage__c) / 100;
        }
        
        if(!accConRelList.isEmpty()){
            for(AccountContactRelation accConRel : accConRelList){
                if(accConRel.Id != accContactRelObj.Id){
                    accConRel.Controlling_Percentage__c = accConRel.Controlling_Percentage__c - controllingPerctToDecrease;
                    accConListToUpdate.add(accConRel);
                }
            }
        }
        
        try {
            if(!accConListToUpdate.isEmpty()){
                update accConListToUpdate;
            }
        } catch (Exception e) {            
            throw new AuraHandledException('An unexpected error has occurred: '+ e.getMessage());            
        }   
    }

    /**
    * @description Added by Rajesh for the Roles Issue
    * @param recordId
    * @return FinServ__AccountAccountRelation__c
    */
    @AuraEnabled
    public static FinServ__AccountAccountRelation__c fetchClientType(String recordId){
        FinServ__AccountAccountRelation__c acc = [Select Id,FinServ__RelatedAccount__r.Client_Type__c,Name,FinServ__Account__r.Client_Type__c,Client_Type__c  From FinServ__AccountAccountRelation__c Where Id=:recordId LIMIT 1];
        return acc;
    }

    /**
    * @description Fetch Client Type
    * @param recordId
    * @return AccountContactRelation
    */
    @AuraEnabled
    public static AccountContactRelation fetchClientTypeEdit(String recordId){
        AccountContactRelation accConRel = [ Select Id,AccountId,Account.Client_Type__c From AccountContactRelation Where Id=:recordId LIMIT 1];
        return accConRel;
    } 
    
    /**
    * @description Fetch Client Type
    * @param recordId
    * @param deletionRec
    * @param primaryEntityId
    */
    @AuraEnabled
    public static void deleteAccConRecord(String recordId, String deletionRec, String primaryEntityId){
     
   //  AccountContactRelationController.calculateControllingPercentageVal(recordId,deletionRec,primaryEntityId) ;
       
    } 
    
    private List<AccountWrapper> accWrapperList;
    
    /**
    * @description Get Account Account Hierarchy
    * @param primaryClientId 
    * @param accountId 
    * @param inverseRelationship 
    * @param accWraperList 
    * @param parentControllingInterest 
    * @param controllingInterestMap 
    * @param controllingInterestExistingMap 
    * @param includeControllingInterest 
    * @return List<AccountWrapper> 
    **/
    @AuraEnabled
    public static List<AccountWrapper> getAccAccRelationHierarchy(Id primaryClientId, Id accountId,String inverseRelationship,
                                                                  List<AccountWrapper> accWraperList,
                                                                  Decimal parentControllingInterest,
                                                                  Map<Id,Decimal> controllingInterestMap,
                                                                  Map<Id, Controlling_Interest__c> controllingInterestExistingMap,
                                                                 Boolean includeControllingInterest){
         
        List<FinServ__AccountAccountRelation__c> accAccRelations = new AccountAccountRelationSelector().selectbyPrimaryEntityIdFiltered(accountId,inverseRelationship);
        List<AccountWrapper> accWrapperList = new List<AccountWrapper>(); 
        List<AccountWrapper> conWrapperList = new List<AccountWrapper>(); 
        if(accAccRelations != null && accAccRelations.size() > 0){
            
            for(FinServ__AccountAccountRelation__c accAccRel : accAccRelations){ 
                String mapKey = accAccRel.Primary_Entity_Id__c + '' + accAccRel.FinServ__Account__c + '' + accAccRel.FinServ__RelatedAccount__c;
                Decimal controllingInterest = 0;
                AccountWrapper accWrapper = new AccountWrapper() ; 
                accWrapper.Shareholder = accAccRel.FinServ__RelatedAccount__r.Name ; 
                accWrapper.Type = accAccRel.FinServ__RelatedAccount__r.Client_Type__c;
                accWrapper.idType = accAccRel.FinServ__RelatedAccount__r.ID_Type__c;
                accWrapper.ParentShareholding  = accAccRel.Shareholding_Percentage__c;
                controllingInterest = (parentControllingInterest * accAccRel.Shareholding_Percentage__c) / 100;
                accWrapper.Controllinginterest = controllingInterest.setScale(2);
                accWrapper.UBO = '';
                accWrapper.roles = accAccRel.Roles__c;
                accWrapper.recordId = accAccRel.Id;
                accWrapper.relatedAccountId = accAccRel.FinServ__RelatedAccount__c;
                accWrapper.primaryEntityId = accAccRel.Primary_Entity_Id__c;
                accWrapper.parentAccountId = accAccRel.FinServ__Account__c;
                accWrapper.accType= 'AccountAccount'; 

                conWrapperList = getAccConRelationHierarchy(primaryClientId, accAccRel.FinServ__RelatedAccount__c,
                                                            conWrapperList,controllingInterest,controllingInterestMap,
                                                       controllingInterestExistingMap,includeControllingInterest);
                if(!Test.isRunningTest()){
                    conWrapperList.addAll(getAccAccRelationHierarchy(primaryClientId, accAccRel.FinServ__RelatedAccount__c,
                                                                 inverseRelationship,accWrapperList,controllingInterest,
                                                                 controllingInterestMap,controllingInterestExistingMap,
                                                                includeControllingInterest)); 
                }  
               
                
                
                accWrapper.childwrplist = conWrapperList;
                
                accWrapper.ShareholderCount = accWrapper.childwrplist != null ? accWrapper.childwrplist.size(): 0;
                accWrapperList.add(accWrapper);     
            }
        }
    
        return accWrapperList;
    }
    private List<AccountWrapper> conWrapperList;
    
    /**
    * @description Get Account Contact Hierarchy
    * @param primaryClientId 
    * @param accountId 
    * @param conWraperList 
    * @param parentControllingInterest 
    * @param controllingInterestMap 
    * @param controllingInterestExistingMap 
    * @param includeControllingInterest 
    * @return List<AccountWrapper> 
    **/
    @AuraEnabled
    public static List<AccountWrapper> getAccConRelationHierarchy(Id primaryClientId, Id accountId, 
                                                                  List<AccountWrapper> conWraperList,
                                                                  Decimal parentControllingInterest,
                                                                  Map<Id,Decimal> controllingInterestMap,
                                                                 Map<Id, Controlling_Interest__c> controllingInterestExistingMap,
                                                                 Boolean includeControllingInterest){
        List<AccountContactRelation> accConRelations = new AccountContactRelationSelector().selectRelationByAccountId(accountId); 
        List<AccountContactRelation> accConRelationsUpdated = new List<AccountContactRelation>();
        //TO DO - Remove the for loop and limit in the selector class
        for(AccountContactRelation acr:accConRelations){
            if(acr.Share_Percentage__c > 0){
                accConRelationsUpdated.add(acr);
            }
        }
        List<AccountContactRelation> toUpdateAccConRelations = new List<AccountContactRelation>();
        List<Controlling_Interest__c> controllingInterestUpdate = new List<Controlling_Interest__c>();
         List<Controlling_Interest__c> controllingInterestList;                                                            
         /*if(includeControllingInterest == true){
              //Get all existing Controlling Interest records
             controllingInterestList = new ControllingInterestsSelector().getByPrimary(primaryClientId);
            //Map<Id, Controlling_Interest__c> controllingInterestExistingMap = new Map<Id, Controlling_Interest__c>();
            for(Controlling_Interest__c eachControllingInterest : controllingInterestList) {
                if(!controllingInterestExistingMap.containsKey(eachControllingInterest.Contact__c)) {
                    controllingInterestExistingMap.put(eachControllingInterest.Contact__c, eachControllingInterest);
                }
            }
                                                                         
           }  */                                                          
       
 
        Decimal controllingInterestCumutative = 0 ;
        List<AccountWrapper> conWrapperList = new List<AccountWrapper>(); 
        if(accConRelationsUpdated != null && accConRelationsUpdated.size() >0){
            for(AccountContactRelation accConRel : accConRelationsUpdated){ 
                String mapKey = accConRel.ContactId;
                Decimal controllingInterest = 0 ;
                AccountWrapper conWrapper = new AccountWrapper(); 
                conWrapper.Shareholder = accConRel.Contact.FirstName + ' ' +  accConRel.Contact.LastName;
                conWrapper.Type = accConRel.Contact.Account.Client_Type__c;
                conWrapper.idType = accConRel.Contact.ID_Type__c;
                conWrapper.ShareholderCount = 0;
                conWrapper.ParentShareholding  = accConRel.Share_Percentage__c;
                controllingInterest = (parentControllingInterest * accConRel.Share_Percentage__c) / 100;
                
                if(controllingInterestMap.containsKey(accConRel.ContactId)) {
                    controllingInterestCumutative = controllingInterestMap.get(accConRel.ContactId) + controllingInterest;
                } else {
                    controllingInterestCumutative = controllingInterest;
                }
                
                controllingInterestMap.put(accConRel.ContactId,controllingInterestCumutative);
               
                
                //Create/Update Controlling Interest record based on Controlling Percentage
                Controlling_Interest__c controllingInterestItem = new Controlling_Interest__c();
                if(controllingInterestExistingMap.containsKey(accConRel.ContactId)) {
                    controllingInterestItem = controllingInterestExistingMap.get(accConRel.ContactId);
                } else {
                    controllingInterestItem.Contact__c = accConRel.ContactId;
                    controllingInterestItem.Primary_Entity__c = primaryClientId;  
                }
                controllingInterestItem.Controlling_Interest__c = controllingInterestCumutative;
                if(controllingInterestCumutative >=  Decimal.valueOf(Label.UBO_Controlling_Interest)) {
                    controllingInterestItem.UBO__c = 'Yes';
                } else {
                    controllingInterestItem.UBO__c = 'No';
                }

                controllingInterestUpdate.add(controllingInterestItem);
                controllingInterestExistingMap.put(accConRel.ContactId, controllingInterestItem);
                
                conWrapper.Controllinginterest = controllingInterestItem.Controlling_Interest__c.setScale(2);
                conWrapper.UBO = controllingInterestItem.UBO__c;
                conWrapper.roles = accConRel.Roles;
                conWrapper.recordId = accConRel.Id;
                conWrapper.relatedAccountId = accConRel.ContactId;
                conWrapper.primaryEntityId = accConRel.Primary_Entity_Id__c;
                conWrapper.parentAccountId = accConRel.AccountId;
                conWrapper.accType= 'AccountContact'; 
                
                conWrapperList.add(conWrapper); 

            }
        }
         if(includeControllingInterest == true){
              upsert controllingInterestUpdate;
         }                                                            
       
        return conWrapperList;
    }
    
    private static Map<Id, Controlling_Interest__c> controllingInterestExistingMap;
    
    /**
    * @description Calculate Controlling Interest per Entity
    * @param conWraperList 
    * @param controllingInterestExistingMap 
    * @return List<AccountWrapper> 
    **/
    @AuraEnabled
    public static List<AccountWrapper> getControllingInterest(List<AccountWrapper> conWraperList,Map<Id, Controlling_Interest__c> controllingInterestExistingMap){
        for(AccountWrapper eachWrapper : conWraperList) {
            if(controllingInterestExistingMap != null && controllingInterestExistingMap.size() > 0 && controllingInterestExistingMap.containsKey(eachWrapper.relatedAccountId)) {
                eachWrapper.Controllinginterest = controllingInterestExistingMap.get(eachWrapper.relatedAccountId).Controlling_Interest__c.setScale(2);
                eachWrapper.UBO = controllingInterestExistingMap.get(eachWrapper.relatedAccountId).UBO__c;
            }
            if(eachWrapper.childwrplist != null && eachWrapper.childwrplist.size() > 0) {
                conWraperList = getControllingInterest(eachWrapper.childwrplist,controllingInterestExistingMap);
            }
            
        }
        return conWraperList;
    }
    
    /**
    * @description Create JSON String for Account UBO Structure
    * @param accountId 
    * @param includeControllingInterest
    * @return String 
    **/
    @AuraEnabled
    public static String parentAccountWrapper(Id accountId, Boolean includeControllingInterest){
        String inverseRelationship = 'Inverse Testing';
        Account acc = [Select Name,Client_Type__c,Id from Account where id =:accountId];
        String primaryClientId = accountId;
        List<ParentAccountWrapper> paraccList = new List<ParentAccountWrapper>();
        ParentAccountWrapper parAcc = new ParentAccountWrapper();
        parAcc.Shareholder = acc.name;
        parAcc.Type = acc.Client_Type__c;
        parAcc.ParentShareholding = 100;
        parAcc.Controllinginterest = 100; 
        parAcc.accType = 'Account';
        parAcc.recordId = accountId;
        Map<Id,Decimal> controllingInterestMap = new Map<Id,Decimal>();
        List<AccountWrapper> accWrapperList = new List<AccountWrapper>();
        Set<AccountWrapper> accWrapperSet = new Set<AccountWrapper>();
        Map<Id, Controlling_Interest__c> controllingInterestExistingMap = new Map<Id, Controlling_Interest__c>();
        
       
       
        //parAcc.Accwrplist =  getAccAccRelationHierarchy(accountId, inverseRelationship, accWrapperListP);
        accWrapperList =  getAccAccRelationHierarchy(primaryClientId, accountId, inverseRelationship, accWrapperList,
                                                      parAcc.Controllinginterest,controllingInterestMap,
                                                     controllingInterestExistingMap,includeControllingInterest);
        
        //accountContact Relation warpper
        List<AccountWrapper> conWrapperList = new List<AccountWrapper>();
        conWrapperList =  getAccConRelationHierarchy(primaryClientId, accountId, conWrapperList,parAcc.Controllinginterest,
                                                     controllingInterestMap,controllingInterestExistingMap,includeControllingInterest);
        
        accWrapperList.addAll(conWrapperList);
        
        List<Controlling_Interest__c> controllingInterestList = new ControllingInterestsSelector().getByPrimary(primaryClientId);
        //Map<Id, Controlling_Interest__c> controllingInterestExistingMap = new Map<Id, Controlling_Interest__c>();
        for(Controlling_Interest__c eachControllingInterest : controllingInterestList) {
            if(!controllingInterestExistingMap.containsKey(eachControllingInterest.Contact__c)) {
                controllingInterestExistingMap.put(eachControllingInterest.Contact__c, eachControllingInterest);
            }
        }
        
        if(includeControllingInterest == true) {
            List<AccountWrapper> controllingInterestWrapper = new List<AccountWrapper>();
            for(AccountWrapper accWrapper:accWrapperList){
                if(accWrapper.childwrplist != null && accWrapper.childwrplist.size() > 0){
                    controllingInterestWrapper = getControllingInterest(accWrapper.childwrplist,
                                                                        controllingInterestExistingMap);
                }
                
            }
        }
        
        parAcc.Accwrplist = accWrapperList;
        parAcc.ShareholderCount = parAcc.Accwrplist != null ? parAcc.Accwrplist.size(): 0;
        paraccList.add(parAcc);
        
        //Update Account to store JSON
        acc.UBO_ParentAccountWrapper__c = JSON.serialize(paraccList);
        acc.Valid_Update_Bypass__c = true;
        update acc;
        
        return JSON.serializePretty(paraccList);
    }
         
}