/** 
* @description - Apex class for RemediateCustomer Lightning Component
* @author  Saiteja : Absa
* @version v1.0
* @since   2021-04-28
*/

public with sharing class RemediateCustomerController {

/**
* @description - Method that to get Existing opportunity.
* @param accountId 
* @return - Wrapper 
**/
        @AuraEnabled
        public static oppRecWrapper getOpportunity(Id accountId){
            try{
                Opportunity oppt = new Opportunity();
                oppRecWrapper oppRec = new oppRecWrapper();
                
                oppt = new OpportunitiesSelector().selectOppByAccount(accountId);
                //system.debug('oppList'+oppt);
                if(oppt!=null){
                    Integer Days = date.valueof(oppt.CreatedDate).daysBetween(Date.today());
                    if(Days<14){
                        oppRec.extOppId = oppt.id;
                    }
                    else{
                        oppRec.exstOppAssignId = oppt.id; 
                    }
                }
                //system.debug('oppRec'+oppRec);
                return oppRec; 
                
            }
            
            catch (Exception exc){
                //System.debug('Exception Occured' + exc.getMessage()+'At Line number' + exc.getLineNumber());
                throw new AuraHandledException('Something went wrong: ' + exc.getMessage());
            }
        }
    /** 
    *@description - Method that get Create New opportunity
    * @param accountId
    * @return - opportunity record
    **/
        @AuraEnabled
        public static Opportunity createOpp(Id accountId){
            Opportunity  opptny = new Opportunity();
            
            if (accountId != null){
                Date todaysDate = System.today();
                Map<String, Schema.RecordTypeInfo> OpportunityRecordTypeMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
                User userRec = new UsersSelector().selectById(UserInfo.getUserId());
                List<Site__c> sitecodes;
                if (userRec.SiteCode__c != null){
                    sitecodes = new SitesSelector().selectBySiteCode(userRec.SiteCode__c);
                } else{
                    sitecodes = new List<Site__c>();
                }
                
                //Get Standard Pricebook Id
                
                PriceBook2 priceBookItem = new PriceBook2();
                if(!Test.isRunningTest()){
                    priceBookItem = [select id
                                     from priceBook2
                                     where name = 'Standard Price Book'];
                }
                
                //Create Opportunity
                Opportunity onboardOpportunity = new Opportunity();
                onboardOpportunity.Name = 'Remediation Opportunity for Manual Refresh';
                onboardOpportunity.AccountId = accountId;
                onboardOpportunity.StageName = 'Open';
                onboardOpportunity.closeDate = todaysDate.addDays(7);
                onboardOpportunity.RecordTypeId =OpportunityRecordTypeMap.get('Customer_Remediation').getRecordTypeId();
                onboardOpportunity.priceBook2Id = priceBookItem.id;
                onboardOpportunity.Process_Type__c = 'Remediate Existing Customer'; 
                
                
                If (userRec.SiteCode__c != Null){
                    Map<String, ABSASiteRegionMap__c> regionMapping = ABSASiteRegionMap__c.getAll();
                    onboardOpportunity.ABSA_Region__c = regionMapping.get(userRec.SiteCode__c) != null ? regionMapping.get(userRec.SiteCode__c).ABSA_Region__c : Null;
                }
                
                //Capturing Sitecode of loggedin User while creating opportunity if user has site code
                if (!sitecodes.isEmpty()){
                    onboardOpportunity.Site__c = sitecodes[0].Id;
                }
                insert onboardOpportunity;
                //System.debug('=======onboardOpportunity====>' + onboardOpportunity);
                updateCertDocs(accountId,onboardOpportunity.id);
                
                String ProductName = 'REFRESH';
                ProductsSelector prodSelector = new ProductsSelector();
                Product2 Refreshproduct = prodSelector.selectByName(ProductName, 1);
                //createOpportunityProduct(onboardOpportunity.id,ProductName);
                OnboardingProductInformationController.saveOpportunityLineItem(onboardOpportunity.id,Refreshproduct.Id);
                //oppRec.newOpp = onboardOpportunity;
                //opptny = [select Id,Name,Entity_Type__c,ExecutionLayerRequestID_Text__c,AccountId from Opportunity where Id=:onboardOpportunity.id];
                List<Opportunity> oppList = new OpportunitiesSelector().selectByOpportunityId(onboardOpportunity.id);
                opptny = oppList[0];
                //system.debug('opptny'+opptny);
            }  
            
            return opptny;
            
        }
    /**
    * @description - Method that update owner for Existing Opportunity
    * @param oppId - Opportunity
    * @return opportunity record
    **/
        @AuraEnabled
        public static Opportunity updateOwner(Id oppId){
            Opportunity opptOwnerAssign = new Opportunity();
            if(oppId != null){
                List<Opportunity> oppList = new OpportunitiesSelector().selectByOpportunityId(oppId);
                opptOwnerAssign = oppList[0];
                //opptOwnerAssign  = [select Id,Name,Entity_Type__c,ExecutionLayerRequestID_Text__c,AccountId from Opportunity where Id=:oppId];
                opptOwnerAssign.OwnerId = UserInfo.getUserId();
                update opptOwnerAssign;
            } 
            return opptOwnerAssign;
            
        }
    /**
    * @description - Method that update CertDocs
    * @param accountId - Account
    *@param oppId -Opportunity
    **/
        public static void updateCertDocs(Id accountId,Id oppId){
            Set<String> docTypeSet = new Set<String>{'Experian Certificate','HANISCertificate', 'CPBCertificate'};
                List<Document__c> docList = new DocumentsSelector().selectCerts(accountId,docTypeSet);
            for (Document__c doc : docList) {
                doc.Opportunity__c = oppId;
            }
            update docList;
            //system.debug('docList-->'+docList);
        }
    /**
    * @description - Wrapper class to get opportunity Ids
    **/
        public class oppRecWrapper{
            @AuraEnabled
            public String extOppId;
            @AuraEnabled
            public String exstOppAssignId;
        }
    
}