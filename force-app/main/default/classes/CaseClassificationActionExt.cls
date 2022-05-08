/**
* Apex controller class for the Aura bundle CaseClassificationAction.
* Gives type ahead functionallity and auto classification for Cases
*
* @author  Rudolf Niehaus : CloudSmiths
* @since   2018-06-14
*
**/
public class CaseClassificationActionExt {
    /*
     * Get case values back
     *
     * @param  recId String Case object Id  
     * @return List<String> 
    */
    @AuraEnabled
    public static List<String> getCaseInfo(String recId) {
        
        //Get Case Record
        List<Case> caseRecord = new CasesSelector().selectByIdWithSLAInfo( recId, 1 );
        
        //Get all Service Groups that should have Service Group selection on Classidy quick action
        List<Org_Wide_Lookup_Value__mdt> mdt = [Select Value__c From Org_Wide_Lookup_Value__mdt Where DeveloperName = 'Case_Classify_Service_Groups'];
        
        List<String> caseInformation = new List<String>();
        String isClassifyServiceGroup = 'False';
        
        if(caseRecord.size() > 0){
            caseInformation.add(caseRecord[0].sd_Original_Service_Group__c);
            caseInformation.add(caseRecord[0].sd_Service_Group_Id__c);
            
            if(mdt.size() > 0){
                String strServiceGroups = mdt[0].Value__c;
				List<String> arrServiceGroup = strServiceGroups.split(';');
                
                for(String eachServiceGroup : arrServiceGroup) {
                    if(caseRecord[0].sd_Original_Service_Group__c == eachServiceGroup || caseRecord[0].sd_Service_Group__c == eachServiceGroup) {
                        isClassifyServiceGroup = 'True';
                        break;
                    } 
                }
            } 
            
             caseInformation.add(isClassifyServiceGroup); 
             caseInformation.add(caseRecord[0].Case_Record_Type_Name__c);
             caseInformation.add(caseRecord[0].sd_Service_Group__c);// Added to display the NBFS Service Group
        }
        
        return caseInformation;
    } 
    
	/*
     * Search case classification records                         
     * <p>
     * Search and return a single Service_Type__c object
     * based on the record Id
     *
     * @param  recId String Service_Type__c object Id  
     * @return A single Service_Type__c object 
    */
    @AuraEnabled
    public static Service_Type__c findRecord(String recId,String recName) {
        
        if(String.isNotBlank(recId)){
            
            Set<Id> idSet = new Set<Id>();
            idSet.add(recId);
            
            list<Service_Type__c> returnRec = new ServiceTypesSelector().selectById(idSet);
            
            if(returnRec.size() > 0){
                return returnRec[0];
            }else{
                return null;
            }
            
        } // Poulami - Added to fetch Service Type record based on service type name
        else if(String.isNotBlank(recName)){
             list<Service_Type__c> serviceType = [Select Id,Name,Type__c,Classification__c From Service_Type__c Where Name =:recName order by CreatedDate desc LIMIT 1];//added classification field for short term insurance
             if(serviceType.size() > 0){
                return serviceType[0];
            }else{
                return null;}
        }
        else{
            return null;
        }
    } 
    
    /*
     * Search case Service Group records                         
     * <p>
     * Search and return a single Service_Group__c object
     * based on the record Id
     *
     * @param  recId String Service_Group__c object Id  
     * @return A single Service_Group__c object 
    */
    @AuraEnabled
    public static Service_Group__c findServiceGroupRecord(String serviceGroupId) {
        
        //Add Id to a Set
        Set<Id> serviceGroupTypes = new Set<Id>();
        serviceGroupTypes.add(serviceGroupId);
        list<Service_Group__c> returnRec = new ServiceGroupsSelector().selectById(serviceGroupTypes);
        
        if(returnRec.size() > 0){
            return returnRec[0];
        }else{
            return null;
        }
    } 
    
    /*
     * Update a Case object                         
     * <p>
     * Updates a Case object with the Case Classifiction 
     * search result
     *
     * @param  recId String Case object Id
     * @param  serviceTypeRec Service_Type__c
    */
    @AuraEnabled
    public static void updateCase(String recId, Service_Type__c serviceTypeRec, String serviceGroupId , String subTypeSearch,
                                  String servicetype , String serviceSubType, String product, String subProduct, String classification, String subclassification) { 
        
        //Get Case Record
        List<Case> caseRecord = new CasesSelector().selectByIdWithSLAInfo( recId, 1 );
        System.debug('servicetype'+servicetype); 
        System.debug('serviceTypeRec'+serviceTypeRec); 
        System.debug('serviceGroupId'+serviceGroupId); 
        //Service Type update
        if(serviceTypeRec != null || servicetype != null){
            
            List<Service_Group_Type__c> serviceGroupTypes = new ServiceGroupTypesSelector().selectByServiceTypeAndServiceGroupWithRelatedInfo( serviceGroupId , serviceTypeRec.Id );
            
            if(!serviceGroupTypes.isEmpty()){
                
                //caseRecord[0].sd_Service_Group_Type_Id__c = serviceGroupTypes[0].id;
                //caseRecord[0].sd_Service_Group_Id__c = serviceGroupTypes[0].Service_Group__c;
                caseRecord[0].sd_Service_Type_Id__c = serviceTypeRec.Id;
                caseRecord[0].sd_Service_Level_Id__c = serviceGroupTypes[0].Service_Level__c;
                caseRecord[0].Classify_Service_Group__c = serviceGroupTypes[0].Service_Group__r.Name;
                
                
            }
            // Added by Poulami to store servicetype and servicesubtype for NBFS Service Groups
            if(servicetype != '' && serviceSubType != '' && servicetype != null && serviceSubType != null){
                Service_Group__c serviceGroup = findServiceGroupRecord(serviceGroupId);
                //caseRecord[0].Type__c = servicetype;
                //Added for Phase 2 NBFS change
                System.debug('serviceTypeRec.Type__c'+serviceTypeRec.Type__c);
                caseRecord[0].Type__c = serviceTypeRec.Type__c;
                caseRecord[0].Subtype__c = serviceSubType;
                caseRecord[0].Classify_Service_Group__c = serviceGroup.Name;
                //caseRecord[0].sd_Service_Group_Id__c = caseRecord[0].sd_Original_Service_Group__c;
                caseRecord[0].Product__c = serviceGroup.Name;
                caseRecord[0].sd_Service_Type__c = servicetype;
                 
                //added by Mbuyiseni Mbhokane: for Short term insurance
                if(String.isNotBlank(product) && String.isNotBlank(subProduct)){
                    caseRecord[0].Product_Area__c = product;
                    caseRecord[0].Sub_Product_Area__c = subProduct;
                    
                    if(String.isNotBlank(classification)){
                        caseRecord[0].Classification__c = classification;
                    }
                    
                    if(String.isNotBlank(subclassification)){
                        caseRecord[0].Sub_Classification__c = subclassification;
                    }
                }


                // Check if the current owner is a queue, if yes,throw error for NBFS Case Record Type
                if(!String.valueOf( caseRecord[0].OwnerId ).startsWith('005') && caseRecord[0].RecordType.Name == 'NBFS Dispute Resolution'){
                    System.debug('You cannot Classify a Case. Please change the Case Owner.');
                    throw new AuraHandledException('You cannot Classify a Case. Please change the Case Owner.');
                }
                else if(caseRecord[0].OwnerId != UserInfo.getUserId() && caseRecord[0].RecordType.Name == 'NBFS Dispute Resolution'){
              	    System.debug('You cannot Classify a Case. Please change the Case Owner.');
              		throw new AuraHandledException('You cannot Classify a Case.');
        		}
                else if(caseRecord[0].ClosedDate != null && caseRecord[0].RecordType.Name == 'NBFS Dispute Resolution'){
            		System.debug('The Case is already closed.');
              		throw new AuraHandledException('The Case is already closed.');
       			}
                	 
             }
             else{
            	caseRecord[0].Type__c = serviceTypeRec.Type__c;
            	caseRecord[0].Subtype__c = serviceTypeRec.Subtype__c;
            	caseRecord[0].Product__c = serviceTypeRec.Product__c;
            	caseRecord[0].sd_Service_Type__c = serviceTypeRec.Name;
             }
            	caseRecord[0].FAIS_NCA__c = serviceTypeRec.FAIS_NCA__c;
            
            if(subTypeSearch !='Test' && subTypeSearch !=''){
                caseRecord[0].Sub_Type_Search__c = subTypeSearch; // Added by Simangaliso Mathenjwa
               }

        }
        
        
        try{
           
            update caseRecord[0];
            
        }catch(DMLException ex){
            System.debug('There was an error trying to update the case classification -> CaseClassificationActionExt -> updateCase');
            System.debug(ex.getMessage());
        }
        
    }
    
    /*
     * Koketso Mpshane - Get Products based on the service group Id
     * @param  String productId 
     * @return List<SelectOptionWrapper> 
     */
	@AuraEnabled    
    public static List<SelectOptionWrapper> findProductsByServiceGroup(String serviceGroupId){
        
        List<SelectOptionWrapper> selectOptionList = new List<SelectOptionWrapper>();
        List<Service_Group_Type__c> linkedProducts = new ServiceGroupTypesSelector().getProductsByServiceGroupId(serviceGroupId);
        //Get all Service Groups that should have NBFS Service Group selection
        //Add Id to a Set
        Set<Id> serviceGroupTypes = new Set<Id>();
        serviceGroupTypes.add(serviceGroupId);
        list<Service_Group__c> servicegroupRec = new ServiceGroupsSelector().selectById(serviceGroupTypes);
        List<NBFS_Dispute_Resolution_Configuration__mdt> mdt = [Select  Service_Group__c,Region__c From NBFS_Dispute_Resolution_Configuration__mdt Where MasterLabel = 'NBFS Service Groups'];
        Boolean isNBFSServiceGroup = false;
        
        if(servicegroupRec.size() > 0){
            if(mdt.size() > 0){
                String strServiceGroups = mdt[0].Service_Group__c;
                List<String> arrServiceGroup = strServiceGroups.split(';');
                for(String eachServiceGroup : arrServiceGroup) {
                    if(servicegroupRec[0].Name == eachServiceGroup){
                        isNBFSServiceGroup = true;
                        break;
                    }
                }
            }
        }
        
        Set<String> productIds = new Set<String>(); 
        Map<String, String> productIdMap = new Map<String, String>();
        
        if(linkedProducts.size() > 0){

            for(Service_Group_Type__c sgt: linkedProducts){

                productIds.add(sgt.Service_Type__r.Linked_Product__c);
                productIdMap.put(sgt.Service_Type__r.Linked_Product__c, sgt.Service_Type__r.Linked_Product__r.Name);
            }
        }
        if(isNBFSServiceGroup){
             //productIdMap.put('NBFSServiceGroup', 'true');
             selectOptionList.add(new SelectOptionWrapper('true', 'NBFSServiceGroup',null));
        }
        if(productIds.size() > 0){

            for(String pId: productIds){

                if(productIdMap.containsKey(pId) && String.isNotBlank(pId)){
                    selectOptionList.add(new SelectOptionWrapper(productIdMap.get(pId), pId,null));
                    System.debug('RN: ' + productIdMap.get(pId) + '-' + pId);
                }else{
                    System.debug('RN: Product Map is Empty');
                }
                
            }
        }
        
        return selectOptionList;
    }
    
    /*
     * Koketso Mpshane - Get Service Types based on the product Id
     * @param  String productId 
     * @return List<SelectOptionWrapper> 
     */
	@AuraEnabled    
    public static List<SelectOptionWrapper> findServiceTypesByProductAndServiceGroup(String caseId, String productId, String serviceGroupId){
        
        List<SelectOptionWrapper> selectOptionList = new List<SelectOptionWrapper>();
        
        if(serviceGroupId == null){
            String serviceGroupName = [Select sd_Service_Group__c From Case Where Id =:caseId].sd_Service_Group__c;
            Service_Group__c serviceGroup = [Select Id From Service_Group__c Where Name =:serviceGroupName];
            if(serviceGroup != null){
                serviceGroupId = serviceGroup.Id;
            }
        }
        system.debug(LoggingLevel.FINE, 'serviceGroupId:'+serviceGroupId);
        
        List<Service_Group_Type__c> linkedProductServiceTypes = new ServiceGroupTypesSelector().selectByProductIdAndServiceGroup(productId, serviceGroupId);
		system.debug(LoggingLevel.FINE, 'linkedProductServiceTypes:'+linkedProductServiceTypes);
        
        for(Service_Group_Type__c sgt: linkedProductServiceTypes){
            selectOptionList.add(new SelectOptionWrapper(sgt.Service_Type__r.Name, sgt.Service_Type__c, sgt.Service_Type__r.Case_Record_Type__c));
        }
        
        return selectOptionList;
    }
    
    public class SelectOptionWrapper{
        
        @AuraEnabled
        public String name{get;set;}
        @AuraEnabled
        public String id{get;set;}
         @AuraEnabled
        public String recordtype{get;set;}
        public selectOptionWrapper(String name, String id,String recordtype){
            this.name = name;
            this.id = id;
            this.recordtype = recordtype;
        }
    }
}