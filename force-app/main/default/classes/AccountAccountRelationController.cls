/**
* @description AccountAccountRelationController for calculating controlling percentage
*
* @author  Chandra Bhushan Singh : ABSA
* @version v1.0
* @since   2020-15-07
* @W-004945
*/

public class AccountAccountRelationController {
    /** 
     * @description calculate controlling percentage
     * @param accAccRelation
    */
    public static void calculateControllingPercentageVal (FinServ__AccountAccountRelation__c accAccRelation) {
        try{
            List<FinServ__AccountAccountRelation__c> accAccRelUpdateList = new List<FinServ__AccountAccountRelation__c>();
            List<FinServ__AccountAccountRelation__c> accountAccountRelationshipList = new List<FinServ__AccountAccountRelation__c>();
            List<FinServ__AccountAccountRelation__c> accountAccountRelationshipRelList = new List<FinServ__AccountAccountRelation__c>();
            
            if(String.isNotBlank(accAccRelation.Primary_Entity_Id__c) && String.isNotBlank(accAccRelation.FinServ__Account__c)){
                accountAccountRelationshipList = new AccountAccountRelationSelector().selectbyPrimaryEntityIdAndRelatedAccId(accAccRelation.Primary_Entity_Id__c,accAccRelation.FinServ__Account__c);
            }
            
            if(String.isNotBlank(accAccRelation.Primary_Entity_Id__c) && String.isNotBlank(accAccRelation.FinServ__RelatedAccount__c)){
                accountAccountRelationshipRelList = new AccountAccountRelationSelector().selectbyPrimaryEntityIdAndRelatedAccId(accAccRelation.Primary_Entity_Id__c,accAccRelation.FinServ__RelatedAccount__c);
            }
            
            if(String.isNotBlank(accAccRelation.FinServ__Account__c) && String.isNotBlank(accAccRelation.Primary_Entity_Id__c) && accAccRelation.Shareholding_Percentage__c != null){
                if(accAccRelation.FinServ__Account__c == accAccRelation.Primary_Entity_Id__c){
                    accAccRelation.Controlling_Percentage__c = accAccRelation.Shareholding_Percentage__c;
                    accAccRelUpdateList.add(accAccRelation);
                }else{
                    if(!accountAccountRelationshipList.isEmpty()){
                        if(!accountAccountRelationshipRelList.isEmpty()){
                            accAccRelation.Controlling_Percentage__c = accountAccountRelationshipRelList[0].Controlling_Percentage__c+((accAccRelation.Shareholding_Percentage__c * accountAccountRelationshipList[0].Controlling_Percentage__c)/100);
                            accountAccountRelationshipRelList.add(accAccRelation);
                            accAccRelUpdateList.addAll(processRelatedAccAccRecord(accountAccountRelationshipRelList,accAccRelation.Controlling_Percentage__c));
                        }else{
                            accAccRelation.Controlling_Percentage__c = (accAccRelation.Shareholding_Percentage__c * accountAccountRelationshipList[0].Controlling_Percentage__c)/100;
                            accAccRelUpdateList.add(accAccRelation);
                        }
                    }
                }
            }
            if(!accAccRelUpdateList.isEmpty()){
                upsert accAccRelUpdateList;
            }
            
        } catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
        }
    }
    
    /** 
     * @description Method to process related AccountAccountRelationship records
     * @param accAccRelListToProcess
     * @param controllingPercentage
     * @return List<FinServ__AccountAccountRelation__c>
    */
    public static List<FinServ__AccountAccountRelation__c> processRelatedAccAccRecord(List<FinServ__AccountAccountRelation__c> accAccRelListToProcess, Decimal controllingPercentage){
        List<FinServ__AccountAccountRelation__c> accAccRelProcessList = new List<FinServ__AccountAccountRelation__c>();
        for(FinServ__AccountAccountRelation__c accAccRel: accAccRelListToProcess){
            if(controllingPercentage != null){
                accAccRel.Controlling_Percentage__c = controllingPercentage;
                accAccRelProcessList.add(accAccRel); 
            }
        }
        return accAccRelProcessList;
    }
    
    /** 
     * @description Masechaba Maseli : ABSA Method to calculate controlling interest on  Account Account Relationship when added or edited 
     * @param accAccRelation
     * @param primaryEntityId
    */
    public static void calculateControllingPercentageVal2 (FinServ__AccountAccountRelation__c accAccRelation, String primaryEntityId) {
        try{
        
        Decimal sharePercPrimary; 
        primaryEntityId = PrimaryEntityId;
        String inverseRelationship = 'Inverse Testing';
        Map<String, Decimal> shareholderMap = new Map<String, Decimal>();
        Map<String, Decimal> shareholderMap2 = new Map<String, Decimal>();
        Map<String, Decimal> controlInterestMap = new Map<String, Decimal>();
        List<AccountContactRelation> accConRelList = new List<AccountContactRelation>();
        List<AccountContactRelation> updateaccConRelList = new List<AccountContactRelation>();  
        List<Controlling_Interest__c> conInterestList = new List<Controlling_Interest__c>();
        Map<String, String> controlInterestRecMap = new Map<String, String>(); 
       List<Id> storeSubIds = new List<Id>();
        List<Id> storeSubIds2 = new List<Id>();
       List<Id> storeSubIds3 = new List<Id>();
        List<Id> sortList = new List<Id>();
       List<Controlling_Interest__c> conInterestInsertList = new List<Controlling_Interest__c>();
        Map<Id,FinServ__AccountAccountRelation__c> allAccAccRecs = new Map<Id,FinServ__AccountAccountRelation__c>();
        Decimal minControllingPercentage = Decimal.valueOf(Label.UBO_Controlling_Interest);
        List<Controlling_Interest__c> controllingInterestInsert = new List<Controlling_Interest__c>();
       
        upsert accAccRelation; 
         system.debug('primaryEntityId ='+ PrimaryEntityId);
        List<FinServ__AccountAccountRelation__c> firstLevel = new AccountAccountRelationSelector().selectbyPrimaryEntityIdFiltered(PrimaryEntityId,inverseRelationship);
        List<FinServ__AccountAccountRelation__c> orderedList = new List<FinServ__AccountAccountRelation__c>();      
        
        for(integer i = 0; i < firstLevel.size(); i ++) {
        system.debug('firstLevel Id---->'+firstLevel[i].Id); 
        storeSubIds.add(firstLevel[i].FinServ__RelatedAccount__c);  
        If(firstLevel[i].Primary_Entity_Id__c == firstLevel[i].FinServ__Account__c){
        sortList.add(firstLevel[i].Id);}}
        storeSubIds.add(PrimaryEntityId);
       List<FinServ__AccountAccountRelation__c> subsequentLevels = new AccountAccountRelationSelector().selectbyPrimaryEntityListFiltered(storeSubIds,inverseRelationship);
       List<AccountContactRelation> allAccCons = new AccountContactRelationSelector().parentIn(storeSubIds);  
       firstLevel.AddAll(subsequentLevels);
       
      for(integer i = 0; i < firstLevel.size(); i ++) { 
      allAccAccRecs.put(firstLevel[i].Id, firstLevel[i]);
      shareholderMap.put(firstLevel[i].Id, firstLevel[i].Shareholding_Percentage__c);
      If(sortList.contains(firstLevel[i].ParentRelationshipId__c)){sortList.add(firstLevel[i].Id);}}
       
      List<Controlling_Interest__c> existingConInterestList = [Select Primary_Entity__c, Parent_Account__c, Contact__c, Controlling_Interest__c, UBO__c, Related_Account__c, Other_Primary_Entity_Id__c
                                                                FROM Controlling_Interest__c 
                                                                WHERE Primary_Entity__c =: PrimaryEntityId];
  
       for(integer i = 0; i < existingConInterestList.size(); i ++) {
       If(existingConInterestList[i].Contact__c ==  null){
       String mapKeyCIRec =    PrimaryEntityId + '' + existingConInterestList[i].Parent_Account__c + '' + existingConInterestList[i].Related_Account__c;
       controlInterestRecMap.put(mapKeyCIRec, existingConInterestList[i].Id)  ;}
       else{String mapKeyCIRec =    PrimaryEntityId + '' + existingConInterestList[i].Parent_Account__c + '' + existingConInterestList[i].Contact__c;
       controlInterestRecMap.put(mapKeyCIRec,existingConInterestList[i].Id);}}
       
       String mapKey = PrimaryEntityId + '' + accAccRelation.FinServ__Account__c + '' + accAccRelation.FinServ__RelatedAccount__c;
       If(accAccRelation.Id != null && !controlInterestRecMap.containsKey(mapKey)){
        
        Controlling_Interest__c controllingInterestRec = new Controlling_Interest__c();
        controllingInterestRec.Primary_Entity__c = PrimaryEntityId;
        controllingInterestRec.Parent_Account__c = accAccRelation.FinServ__Account__c;
	    controllingInterestRec.Related_Account__c = accAccRelation.FinServ__RelatedAccount__c;
        controllingInterestRec.Controlling_Interest__c = 0;
        controllingInterestRec.UBO__c = 'No';
        controllingInterestRec.Other_Primary_Entity_Id__c = accAccRelation.Primary_Entity_Id__c;
        insert controllingInterestRec;
        existingConInterestList.add(controllingInterestRec);
        controlInterestRecMap.put(mapKey,controllingInterestRec.Id );
       }      
       Decimal controllingInterest = 0 ;
       set<Id> dedupeAccAcc = new Set<Id>();
        dedupeAccAcc.addAll(sortList);
        (sortList).clear();
        sortList.addAll(dedupeAccAcc);
       for(integer i = 0; i < sortList.size(); i ++) {    
       FinServ__AccountAccountRelation__c accAccRec = allAccAccRecs.get(sortList[i]);       
       String mapKeyAccAcc = PrimaryEntityId + '' + accAccRec.FinServ__Account__c + '' + accAccRec.FinServ__RelatedAccount__c;
       If(!controlInterestRecMap.containsKey(mapKeyAccAcc)){
       Controlling_Interest__c controllingInterestRec = new Controlling_Interest__c();
       controllingInterestRec.Primary_Entity__c = PrimaryEntityId;
       controllingInterestRec.Parent_Account__c = accAccRec.FinServ__Account__c;
	   controllingInterestRec.Related_Account__c = accAccRec.FinServ__RelatedAccount__c;
       controllingInterestRec.Controlling_Interest__c = 0;
       controllingInterestRec.Other_Primary_Entity_Id__c = accAccRec.Primary_Entity_Id__c; 
       controllingInterestInsert.add(controllingInterestRec);
       existingConInterestList.add(controllingInterestRec);
       controlInterestRecMap.put(mapKey,controllingInterestRec.Id );}
       
       system.debug('accAccRecId'+accAccRec.Id);
       system.debug('related Account'+accAccRec.FinServ__RelatedAccount__c);
       system.debug('account'+accAccRec.FinServ__Account__c);
       system.debug('accAccRecId'+accAccRec.Id);
       sharePercPrimary = accAccRec.Shareholding_Percentage__c; system.debug('sharePercPrimary'+sharePercPrimary);
       Decimal parentPerc;
       //Decimal controllingInterest = 0 ;
       If(accAccRec.ParentRelationshipId__c == null && 
          accAccRec.Primary_Entity_Id__c == PrimaryEntityId){parentPerc = 100;}
        else if(accAccRec.ParentRelationshipId__c == null && 
         accAccRec.Primary_Entity_Id__c != PrimaryEntityId){
        parentPerc = controlInterestMap.get(accAccRec.FinServ__RelatedAccount__c);}
        else{parentPerc = controlInterestMap.get(accAccRec.FinServ__Account__c);}
        system.debug('parentPerc'+parentPerc);
           
       Decimal levelControl  =  (sharePercPrimary *  parentPerc)/100 ; system.debug('levelControl'+levelControl);
       If(controlInterestMap.get(accAccRec.FinServ__RelatedAccount__c) == null){controllingInterest = levelControl;}
       else{ controllingInterest = controlInterestMap.get(accAccRec.FinServ__RelatedAccount__c) + levelControl;}
       system.debug('controllingInterest'+controllingInterest);
      If(!controlInterestMap.containsKey(accAccRec.FinServ__RelatedAccount__c)){
      controlInterestMap.put(accAccRec.FinServ__RelatedAccount__c, controllingInterest); }
      else{controlInterestMap.remove(accAccRec.FinServ__RelatedAccount__c); 
      controlInterestMap.put(accAccRec.FinServ__RelatedAccount__c, controllingInterest); }
           system.debug('controlInterestMap'+controlInterestMap); 
}
       
       set<AccountContactRelation> dedupe = new Set<AccountContactRelation>();
        dedupe.addAll(allAccCons);
        (allAccCons).clear();
        allAccCons.addAll(dedupe);
         for(integer i = 0; i < allAccCons.size(); i ++) {
           String mapKeyAccCon = PrimaryEntityId + '' + allAccCons[i].AccountId + '' + allAccCons[i].ContactId;  
           If(!controlInterestRecMap.containsKey(mapKeyAccCon)){
           Controlling_Interest__c controllingInterestRec = new Controlling_Interest__c();
           controllingInterestRec.Primary_Entity__c = PrimaryEntityId;
           controllingInterestRec.Parent_Account__c = allAccCons[i].AccountId;
           controllingInterestRec.Contact__c = allAccCons[i].ContactId;
           controllingInterestRec.Controlling_Interest__c = 0;
           controllingInterestRec.Other_Primary_Entity_Id__c = allAccCons[i].Primary_Entity_Id__c; 
           controllingInterestInsert.add(controllingInterestRec);
           existingConInterestList.add(controllingInterestRec);
           controlInterestRecMap.pUT(mapKeyAccCon,controllingInterestRec.Id );               
           }    
            
           sharePercPrimary = allAccCons[i].Share_Percentage__c; system.debug('sharePercPrimary2'+sharePercPrimary);
           Decimal parentPerc; 
           system.debug('primary Entity'+allAccCons[i].Primary_Entity_Id__c); 
           system.debug('primary Entity 2'+PrimaryEntityId);
           system.debug('AccountId'+allAccCons[i].AccountId);
           system.debug('ParentId'+allAccCons[i].ParentRelationshipId__c);
           system.debug('Else if Map'+shareholderMap.get(allAccCons[i].AccountId));
           system.debug('Else Map'+shareholderMap.get(allAccCons[i].ParentRelationshipId__c));
           system.debug('Id'+allAccCons[i].Id);
           If(allAccCons[i].ParentRelationshipId__c == null && 
           allAccCons[i].Primary_Entity_Id__c == PrimaryEntityId){
               system.debug('In If');
               parentPerc = 100;}
           else if(allAccCons[i].ParentRelationshipId__c == null && 
           allAccCons[i].Primary_Entity_Id__c != PrimaryEntityId){
               system.debug('In Else If');
           parentPerc = controlInterestMap.get(allAccCons[i].Primary_Entity_Id__c);}
           else{
               system.debug('In Else');
               parentPerc = shareholderMap.get(allAccCons[i].ParentRelationshipId__c);}
          system.debug('parentPerc'+parentPerc);   
          Decimal levelControl  =  (sharePercPrimary *  parentPerc)/100 ;   
          controllingInterest = controlInterestMap.get(allAccCons[i].ContactId) == null? levelControl : controlInterestMap.get(allAccCons[i].ContactId) + levelControl;
          If(!controlInterestMap.containsKey(allAccCons[i].ContactId)){controlInterestMap.put(allAccCons[i].ContactId, controllingInterest); }
          else{controlInterestMap.remove(allAccCons[i].ContactId); controlInterestMap.put(allAccCons[i].ContactId, controllingInterest);} }
       
       for(integer i = 0; i < existingConInterestList.size(); i ++){
       If(existingConInterestList[i].Contact__c != null){
       existingConInterestList[i].Controlling_Interest__c = controlInterestMap.get(existingConInterestList[i].Contact__c);  
       if(existingConInterestList[i].Controlling_Interest__c >= minControllingPercentage){
       existingConInterestList[i].UBO__c = StringConstants.UBO_YES;}
       else{existingConInterestList[i].UBO__c = StringConstants.UBO_NO;}}
       else {existingConInterestList[i].Controlling_Interest__c = controlInterestMap.get(existingConInterestList[i].Related_Account__c);}
       conInterestList.add(existingConInterestList[i]) ;}
          
       update conInterestList;  

       if(controllingInterestInsert != null && controllingInterestInsert.size() > 0) {
           insert controllingInterestInsert;
       }
      
       } catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage() + e.getLineNumber());
        }
    }
    
    /** 
     * @description Method to process AccountAccountRelationship update
     * @param accAccRelation
    */
    public static void calculateControllingPercentageValOnUpdate (FinServ__AccountAccountRelation__c accAccRelation) {
        try{
            Decimal controllingPercentage;
            List<FinServ__AccountAccountRelation__c> accAccRelListToProcess = new List<FinServ__AccountAccountRelation__c>();
            List<FinServ__AccountAccountRelation__c> accAccRelUpdateList = new List<FinServ__AccountAccountRelation__c>();
            List<FinServ__AccountAccountRelation__c> accountAccountRelationshipList = new List<FinServ__AccountAccountRelation__c>();
            
            if(String.isNotBlank(accAccRelation.Primary_Entity_Id__c) && String.isNotBlank(accAccRelation.FinServ__Account__c)){
                accountAccountRelationshipList = new AccountAccountRelationSelector().selectbyPrimaryEntityIdAndRelatedAccId(accAccRelation.Primary_Entity_Id__c,accAccRelation.FinServ__Account__c);
            }
            
            if(String.isNotBlank(accAccRelation.FinServ__Account__c) && String.isNotBlank(accAccRelation.Primary_Entity_Id__c) && accAccRelation.Shareholding_Percentage__c != null){
                if(accAccRelation.FinServ__Account__c == accAccRelation.Primary_Entity_Id__c){
                    accAccRelation.Controlling_Percentage__c = accAccRelation.Shareholding_Percentage__c;
                    accAccRelUpdateList.add(accAccRelation);
                }else{
                    accAccRelation.Controlling_Percentage__c = (accAccRelation.Shareholding_Percentage__c * accountAccountRelationshipList[0].Controlling_Percentage__c)/100;
                    accAccRelUpdateList.add(accAccRelation);
                }
            }
            
            
            if(!accAccRelUpdateList.isEmpty()){
                upsert accAccRelUpdateList;
            }
            
        } catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
        }
    }
}