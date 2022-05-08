public class ROTImportRestrictionController {
    
    @AuraEnabled
    public static String getRestrictionHierarchy(String customerKey){
        
        ROTGetGrpRestriHierForCu_IB_Req_v1 requestBean = new ROTGetGrpRestriHierForCu_IB_Req_v1(); 
        requestBean.GetGroupRestrictionHierarchiesForCustomer = new ROTGetGrpRestriHierForCu_IB_Req_v1.GetGroupRestrictionHierarchiesForCustomer();
        requestBean.GetGroupRestrictionHierarchiesForCustomer.customerKey = customerKey;//'CTMETRO001';
        requestBean.GetGroupRestrictionHierarchiesForCustomer.forestType = 'Production';
        requestBean.GetGroupRestrictionHierarchiesForCustomer.user = 'SALESFORCE';
        
        
        ROTGetGrpRestriHierForCu_IB_Resp_v1 responseBean = ROTGetGrpRestriHierarchiesForCu_IH_v1.getRestrictionHierarchy(requestBean);
        if(responseBean != null){
            if(responseBean.GetGroupRestrictionHierarchiesForCustomerResponse.GetGroupRestrictionHierarchiesForCustomerResult != null){
                if(responseBean.GetGroupRestrictionHierarchiesForCustomerResponse.GetGroupRestrictionHierarchiesForCustomerResult.HasErrors == 'false'){
                    
                    return JSON.serialize(responseBean);
                    
                }else{
                    return JSON.serialize(responseBean);
                }
            }
        }
        return null;
    }
    
    @AuraEnabled
    public Static String bulkImportNodes(String caseId, String records){
        
        List<Object> selectedRecords = (List<Object>)JSON.deserializeUntyped(records);
        Map<String,Object> recordMap = new Map<String,Object>(); 
        Map<String, String> schemeNodeIdMap = new Map<String, String>();
        Set<String> pendingRestrictionGroups = new Set<String>();
        List<RestrictionGroup__c> restrictionsToInsert = new List<RestrictionGroup__c>();
        List<sObject> recordsToInsert = new List<sObject>();
        integer count= 0,restrictionsCount=0,insertedRestrictionsCount=0,count1=0;
        
        for(RestrictionGroup__c restrictionGrp : [Select id, Restriction_ID__c,Case__r.Rot_Approval_Status__c ,Case__r.Status  from RestrictionGroup__c where Case__r.Rot_Approval_Status__c != 'Leg2 Approved' and ( Case__r.Status != 'Closed' or Case__r.Status !='Resolved')]){
            pendingRestrictionGroups.add(restrictionGrp.Restriction_ID__c);
        }
        
        for (Object record :selectedRecords) {           
            count++;
            recordMap = new Map<String,Object>{String.valueOf(count) => record};
                Map<String,Object> mapEntityTypes = (Map<String,Object>)recordMap.get(String.valueOf(count));
            
            if(String.valueOf(mapEntityTypes.get('EntityType')) =='GroupRestriction' ){
                restrictionsCount++;
                if(pendingRestrictionGroups.size() > 0 && !pendingRestrictionGroups.contains(String.valueOf(mapEntityTypes.get('ObjectID')))){
                    insertedRestrictionsCount++;
                    RestrictionGroup__c restrictGroup = new RestrictionGroup__c();
                    
                    String effectiveStartDate = String.valueOf(mapEntityTypes.get('EffectiveStartDate'));
                    effectiveStartDate =  effectiveStartDate.substringBefore('T');  
                    restrictGroup.EffectiveStartDate__c = Date.parse(effectiveStartDate.replace('-','/'));
                    
                    String effectiveEndDate = String.valueOf(mapEntityTypes.get('EffectiveEndDate'));
                    effectiveEndDate =  effectiveEndDate.substringBefore('T');  
                    effectiveEndDate = effectiveEndDate.replace('9999', '4000');
                    restrictGroup.EffectiveEndDate__c = Date.parse(effectiveEndDate.replace('-','/'));              
                    
                    restrictGroup.Description__c = String.valueOf(mapEntityTypes.get('Description')); 
                    restrictGroup.IsEffectiveEndDateInfinity__c = String.valueOf(mapEntityTypes.get('IsEffectiveEndDateInfinity'));  
                    restrictGroup.Status__c = 'Unchanged';
                    restrictGroup.Restriction_ID__c = String.valueOf(mapEntityTypes.get('ObjectID'));  
                    restrictGroup.EntityType__c = String.valueOf(mapEntityTypes.get('EntityType'));  
                    restrictGroup.Case__c = caseId;
                    restrictGroup.GroupID__c = 'Import';  
                    restrictGroup.ParentSchemeNodeID__c = String.valueOf(mapEntityTypes.get('ParentSchemeNodeID'));  
                    restrictGroup.SchemeNodeID__c = String.valueOf(mapEntityTypes.get('SchemeNodeID'));  
                    restrictGroup.GroupRestrictionClusterID__c = String.valueOf(mapEntityTypes.get('ClusterID'));  
                    restrictionsToInsert.add(restrictGroup);
                } 
            }
        }
        
        if(restrictionsToInsert.size() > 0){
            insert restrictionsToInsert;
        }
        
        for(RestrictionGroup__c restrictionGrp : restrictionsToInsert){
            schemeNodeIdMap.put(restrictionGrp.SchemeNodeID__c, restrictionGrp.Id);
        }
        
        for (Object record :selectedRecords) {           
            count1++;
            recordMap = new Map<String,Object>{String.valueOf(count1) => record};
                Map<String,Object> mapEntityTypes = (Map<String,Object>)recordMap.get(String.valueOf(count1));
            
            if(String.valueOf(mapEntityTypes.get('EntityType')) =='Account' && schemeNodeIdMap.get(String.valueOf(mapEntityTypes.get('ParentSchemeNodeID'))) != null){
                RestrictionGroupAccount__c restrictionGroupAccount = new RestrictionGroupAccount__c();
                restrictionGroupAccount.RestrictionGroupId__c = schemeNodeIdMap.get(String.valueOf(mapEntityTypes.get('ParentSchemeNodeID'))); 
                restrictionGroupAccount.SchemeNodeID__c = String.valueOf(mapEntityTypes.get('SchemeNodeID'));  
                restrictionGroupAccount.ParentSchemeNodeID__c = String.valueOf(mapEntityTypes.get('ParentSchemeNodeID'));
                restrictionGroupAccount.ObjectID__c = String.valueOf(mapEntityTypes.get('ObjectID'));   
                restrictionGroupAccount.IsEffectiveEndDateInfinity__c = String.valueOf(mapEntityTypes.get('IsEffectiveEndDateInfinity'));  
                restrictionGroupAccount.AccountNumber__c = String.valueOf(mapEntityTypes.get('ObjectID'));
                
                String effectiveStartDate = String.valueOf(mapEntityTypes.get('EffectiveStartDate'));
                effectiveStartDate =  effectiveStartDate.substringBefore('T');  
                restrictionGroupAccount.EffectiveStartDate__c = Date.parse(effectiveStartDate.replace('-','/'));
                
                String effectiveEndDate = String.valueOf(mapEntityTypes.get('EffectiveEndDate'));
                effectiveEndDate =  effectiveEndDate.substringBefore('T');  
                effectiveEndDate = effectiveEndDate.replace('9999', '4000');
                restrictionGroupAccount.EffectiveEndDate__c = Date.parse(effectiveEndDate.replace('-','/'));
                
                restrictionGroupAccount.Description__c = String.valueOf(mapEntityTypes.get('Description')); 
                restrictionGroupAccount.Excluded_Account__c = false;
                restrictionGroupAccount.Status__c = 'Unchanged';
                recordsToInsert.add(restrictionGroupAccount);
            }
            
            if(String.valueOf(mapEntityTypes.get('EntityType')) =='ExcludedAccount' && schemeNodeIdMap.get(String.valueOf(mapEntityTypes.get('ParentSchemeNodeID'))) != null){
                RestrictionGroupAccount__c restrictionGroupExAccount = new RestrictionGroupAccount__c();
                restrictionGroupExAccount.RestrictionGroupId__c = schemeNodeIdMap.get(String.valueOf(mapEntityTypes.get('ParentSchemeNodeID'))); 
                restrictionGroupExAccount.SchemeNodeID__c = String.valueOf(mapEntityTypes.get('SchemeNodeID'));  
                restrictionGroupExAccount.ParentSchemeNodeID__c = String.valueOf(mapEntityTypes.get('ParentSchemeNodeID'));
                restrictionGroupExAccount.ObjectID__c = String.valueOf(mapEntityTypes.get('ObjectID'));   
                restrictionGroupExAccount.IsEffectiveEndDateInfinity__c = String.valueOf(mapEntityTypes.get('IsEffectiveEndDateInfinity'));  
                restrictionGroupExAccount.AccountNumber__c = String.valueOf(mapEntityTypes.get('ObjectID'));    
                
                String effectiveStartDate = String.valueOf(mapEntityTypes.get('EffectiveStartDate'));
                effectiveStartDate =  effectiveStartDate.substringBefore('T');  
                restrictionGroupExAccount.EffectiveStartDate__c = Date.parse(effectiveStartDate.replace('-','/'));
                
                String effectiveEndDate = String.valueOf(mapEntityTypes.get('EffectiveEndDate'));
                effectiveEndDate =  effectiveEndDate.substringBefore('T'); 
                effectiveEndDate = effectiveEndDate.replace('9999', '4000');
                restrictionGroupExAccount.EffectiveEndDate__c = Date.parse(effectiveEndDate.replace('-','/'));
                
                restrictionGroupExAccount.Description__c = String.valueOf(mapEntityTypes.get('Description')); 
                restrictionGroupExAccount.Excluded_Account__c = true;
                restrictionGroupExAccount.Status__c = 'Unchanged';   
                recordsToInsert.add(restrictionGroupExAccount);
            }
            
            if(String.valueOf(mapEntityTypes.get('EntityType')) =='TransactionType' && schemeNodeIdMap.get(String.valueOf(mapEntityTypes.get('ParentSchemeNodeID'))) != null){
                RestrictionGroupTransactionType__c restrictionGroupTransactionType = new RestrictionGroupTransactionType__c();
                restrictionGroupTransactionType.Restriction_Group_ID__c = schemeNodeIdMap.get(String.valueOf(mapEntityTypes.get('ParentSchemeNodeID'))); 
                restrictionGroupTransactionType.SchemeNodeID__c = String.valueOf(mapEntityTypes.get('SchemeNodeID'));  
                restrictionGroupTransactionType.ParentSchemeNodeID__c = String.valueOf(mapEntityTypes.get('ParentSchemeNodeID'));  
                restrictionGroupTransactionType.IsEffective_End_Date_Infinity__c = true;  
                
                String effectiveStartDate = String.valueOf(mapEntityTypes.get('EffectiveStartDate'));
                effectiveStartDate =  effectiveStartDate.substringBefore('T');  
                restrictionGroupTransactionType.Effective_Start_Date__c = Date.parse(effectiveStartDate.replace('-','/'));
                
                String effectiveEndDate = String.valueOf(mapEntityTypes.get('EffectiveEndDate'));
                effectiveEndDate =  effectiveEndDate.substringBefore('T');  
                effectiveEndDate = effectiveEndDate.replace('9999', '4000');
                restrictionGroupTransactionType.Effective_End_Date__c = Date.parse(effectiveEndDate.replace('-','/'));
                restrictionGroupTransactionType.Name = String.valueOf(mapEntityTypes.get('ObjectID'));
                restrictionGroupTransactionType.Description__c = String.valueOf(mapEntityTypes.get('Description')); 
                restrictionGroupTransactionType.Status__c = 'Unchanged';   
                recordsToInsert.add(restrictionGroupTransactionType);
            }
            
            if(String.valueOf(mapEntityTypes.get('EntityType')) =='Customer' && schemeNodeIdMap.get(String.valueOf(mapEntityTypes.get('ParentSchemeNodeID'))) != null){
                
                RestrictionGroupCustomer__c restrictionGroupCustomer = new RestrictionGroupCustomer__c();
                restrictionGroupCustomer.RestrictionGroupId__c = schemeNodeIdMap.get(String.valueOf(mapEntityTypes.get('ParentSchemeNodeID'))); 
                restrictionGroupCustomer.SchemeNodeID__c = String.valueOf(mapEntityTypes.get('SchemeNodeID'));  
                restrictionGroupCustomer.ParentSchemeNodeID__c = String.valueOf(mapEntityTypes.get('ParentSchemeNodeID'));
                restrictionGroupCustomer.ObjectID__c = String.valueOf(mapEntityTypes.get('ObjectID')); 
                restrictionGroupCustomer.CustomerKey__c = String.valueOf(mapEntityTypes.get('ObjectID'));
                restrictionGroupCustomer.IsEffectiveEndDateInfinity__c = String.valueOf(mapEntityTypes.get('IsEffectiveEndDateInfinity'));  
                
                String effectiveStartDate = String.valueOf(mapEntityTypes.get('EffectiveStartDate'));
                effectiveStartDate =  effectiveStartDate.substringBefore('T');  
                restrictionGroupCustomer.EffectiveStartDate__c = Date.parse(effectiveStartDate.replace('-','/'));
                
                String effectiveEndDate = String.valueOf(mapEntityTypes.get('EffectiveEndDate'));
                effectiveEndDate =  effectiveEndDate.substringBefore('T');  
                effectiveEndDate = effectiveEndDate.replace('9999', '4000');
                restrictionGroupCustomer.EffectiveEndDate__c = Date.parse(effectiveEndDate.replace('-','/'));
                
                restrictionGroupCustomer.Description__c = String.valueOf(mapEntityTypes.get('Description')); 
                restrictionGroupCustomer.Status__c = 'Unchanged';
                recordsToInsert.add(restrictionGroupCustomer);
            }
            
        }
        if(recordsToInsert.size() > 0){
            Database.SaveResult[] results = Database.insert(recordsToInsert);
        }
        
        if(restrictionsCount == insertedRestrictionsCount){
            return 'All Restrictions Imported successfully';
        }
        else{
            return 'Out of '+restrictionsCount+' Restrictions '+insertedRestrictionsCount+' were Imported successfully' ;
        }
        //return null; 
        
    }
}