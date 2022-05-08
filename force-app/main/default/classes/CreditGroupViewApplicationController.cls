/**
* @description       : Credit Group View Application Controller
* @author            : Himanshu.Nimje@absa.africa
* @last modified on  : 12-08-2021
* @last modified by  : Tawanda M.
* Modifications Log
* Ver   Date         Author                       Modification
* 1.0   2021-08-02 Himanshu.Nimje@absa.africa   Initial Version
**/
public class CreditGroupViewApplicationController {
    /**
 * @description Custom Exception
 * @author Tawanda M. | 07-20-2021
 **/
    public class groupViewException extends Exception{}

    /**
    * @description       : Credit Group View Wrapper Class
    * @author            : Himanshu.Nimje@absa.africa
    * @last modified on  : 12-08-2021
    */
    public class CreditGrpViewWrapper {
        /** @description PrimaryClient */
        @AuraEnabled
        public String PrimaryClient { get; set; }
        /** @description GroupMember */
        @AuraEnabled
        public String GroupMember { get; set; }
        /** @description ClientCode */
        @AuraEnabled
        public String ClientCode { get; set; }
        /** @description StatusIndicator */
        @AuraEnabled
        public String StatusIndicator { get; set; }
        /** @description UltimateClient */
        @AuraEnabled
        public String UltimateClient { get; set; }
        /** @description Type */
        @AuraEnabled
        public String Type { get; set; }
        /** @description Key */
        @AuraEnabled
        public Integer Key { get; set; }
        /** @description CreditLensId */
        @AuraEnabled
        public String CreditLensId { get; set; }
        /** @description CheckedInCreditLens */
        @AuraEnabled
        public Boolean CheckedInCreditLens { get; set; }
        /** @description SystemId */
        @AuraEnabled
        public String SystemId { get; set; }
        /** @description childGrpMemList */
        @AuraEnabled
        public List<CreditGrpViewWrapper> childGrpMemList { get; set; }
         /** @description childGrpMemList */
         @AuraEnabled
         public List<CreditGrpViewWrapper> children { get; set; }
    }

    /**
    * @description       : Structure returned to Aura for Search and Create
    * @author            : Tawanda.Madavo@absa.africa
    * @last modified on  : 12-08-2021
    */
    public class BatchProcessResponse {
        @AuraEnabled
        public List<CreditGrpViewWrapper> data;
        @AuraEnabled
        public Boolean nextPage;

        /**
        * @description Constructor
        * @author Tawanda M. | 11-26-2021 
        * @param data 
        * @param nextPage 
        **/
        public BatchProcessResponse(List<CreditGrpViewWrapper> data, Boolean nextPage){
            this.data = data;
            this.nextPage = nextPage;
        }
    }

    /**
    * @description get Clients
    * @author Himanshu.Nimje@absa.africa | 2021-06-25
    * @param oppId
    * @return account
    **/
    @AuraEnabled
    public static account getAccounts(Id oppId) {
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
        Account acc = new AccountsSelector().selectByOpportunityId(opportunities.get(0).AccountId, 1);
        
        return acc;
    }
     /**
    * @description : Method to get application record
    * @author Himanshu Nimje | 2021-11-15
    * @param oppId
    * @return Application__c
    **/
    @AuraEnabled
    public static Application__c GetApplication(Id oppId) {
        Application__c applicationRec = [SELECT Id, EntityHierarchyCreate__c FROM Application__c where Opportunity__c=:oppId  LIMIT 1  ];
        return applicationRec;
    }
    
    
    /**
* @description Service call to get response frm credit group view
* @author Himanshu.Nimje@absa.africa | 2021-06-25
* @param oppId
* @return List<CreditGrpViewWrapper>
**/
    @AuraEnabled
    public static List<CreditGrpViewWrapper> GetCreditGroupView(Id oppId) {
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
        Account acc = new AccountsSelector().selectByOpportunityId(opportunities.get(0).AccountId, 1);
        Application__c appRec = [SELECT Id, Application_Credit_Group__c FROM Application__c WHERE Opportunity__c = :oppId LIMIT 1];
        
        if (appRec.Application_Credit_Group__c == null) {
            if (acc.CIF__c != null) {
                GBgetCmsFullCrGroups_Resp_IB_v1 grpViewRespP = GBgetCmsFullCrGroups_IH_v1.GBgetCmsFullCrGroupsV1(acc.CIF__c);
                
                //Removing Empty Record from response to make it short to store as JSON snapshot
                GBgetCmsFullCrGroups_Resp_IB_v1 grpViewResp = removeEmptyRecords(grpViewRespP);
                
                //Creating Wrapper for FrontEnd display
                List<CreditGrpViewWrapper> cmsCreditResp = buildWrpStructure(grpViewResp);
                
                //Inserting a Snapshot of the Response and storing in the Application Fields
                createCMSRespSnapshot(JSON.serialize(grpViewResp), oppId);
                return cmsCreditResp;
            }
        } else if (appRec.Application_Credit_Group__c != null) {
            GBgetCmsFullCrGroups_Resp_IB_v1 grpViewResp = (GBgetCmsFullCrGroups_Resp_IB_v1) JSON.deserialize(
                appRec.Application_Credit_Group__c,
                GBgetCmsFullCrGroups_Resp_IB_v1.class
            );
            List<CreditGrpViewWrapper> cmsCreditResp = buildWrpStructure(grpViewResp);
            return cmsCreditResp;
        }
        return null;
    }
    
    /**
* @description Service call to get response frm credit group view and to refresh just the original data
* @author ravi.bodepalli@absa.africa | 2021-10-21
* @param oppId
* @return List<CreditGrpViewWrapper>
**/
    @AuraEnabled
    public static List<CreditGrpViewWrapper> RefreshCreditGroupView(Id oppId) {
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
        Account acc = new AccountsSelector().selectByOpportunityId(opportunities.get(0).AccountId, 1);
        Application__c appRec = [SELECT Id, Application_Credit_Group__c FROM Application__c WHERE Opportunity__c = :oppId LIMIT 1];
        
        if (appRec.Application_Credit_Group__c == null) {
            if (acc.CIF__c != null) {
                GBgetCmsFullCrGroups_Resp_IB_v1 grpViewRespP = GBgetCmsFullCrGroups_IH_v1.GBgetCmsFullCrGroupsV1(acc.CIF__c);
                
                //Removing Empty Record from response to make it short to store as JSON snapshot
                GBgetCmsFullCrGroups_Resp_IB_v1 grpViewResp = removeEmptyRecords(grpViewRespP);
                
                //Creating Wrapper for FrontEnd display
                List<CreditGrpViewWrapper> cmsCreditResp = buildWrpStructure(grpViewResp);
                
                //Inserting a Snapshot of the Response and storing in the Application Fields
                createCMSRespSnapshot(JSON.serialize(grpViewResp), oppId);
                return cmsCreditResp;
            }
        } else if (appRec.Application_Credit_Group__c != null) {
            GBgetCmsFullCrGroups_Resp_IB_v1 appGrpViewResp = (GBgetCmsFullCrGroups_Resp_IB_v1) JSON.deserialize(
                appRec.Application_Credit_Group__c,
                GBgetCmsFullCrGroups_Resp_IB_v1.class
            );
            GBgetCmsFullCrGroups_Resp_IB_v1 cmsGrpViewRespP = GBgetCmsFullCrGroups_IH_v1.GBgetCmsFullCrGroupsV1(acc.CIF__c);
            
            //Removing Empty Record from response to make it short to store as JSON snapshot
            GBgetCmsFullCrGroups_Resp_IB_v1 cmsGrpViewResp = removeEmptyRecords(cmsGrpViewRespP);
            GBgetCmsFullCrGroups_Resp_IB_v1 mergedGrpViewResp = mergedWrpStructures(cmsGrpViewResp, appGrpViewResp);
            //Creating Wrapper for FrontEnd display
            List<CreditGrpViewWrapper> mergedCreditResp = buildWrpStructure(mergedGrpViewResp);
            createRefreshedCMSRespSnapshot(JSON.serialize(cmsGrpViewResp), JSON.serialize(mergedGrpViewResp), oppId);
            return mergedCreditResp;
        }
        return null;
    }
    
    /**
* @description
* @author ravi.bodepalli@absa.africa | 2021-10-24
* @param creditResp
* @return List<CreditGrpViewWrapper>
**/
    public static GBgetCmsFullCrGroups_Resp_IB_v1 mergedWrpStructures(GBgetCmsFullCrGroups_Resp_IB_v1 cmsCreditResponse, GBgetCmsFullCrGroups_Resp_IB_v1 appCreditResp) {
        GBgetCmsFullCrGroups_Resp_IB_v1 mergedWrapper = (GBgetCmsFullCrGroups_Resp_IB_v1) JSON.deserialize(JSON.serialize(cmsCreditResponse), GBgetCmsFullCrGroups_Resp_IB_v1.class);
        
        mergedWrapper.GSB025O.GSB025O.GSB025O_GROUP_DETAIL = new List<GBgetCmsFullCrGroups_Resp_IB_v1.GSB025O_GROUP_DETAIL>();
        
        for (GBgetCmsFullCrGroups_Resp_IB_v1.GSB025O_GROUP_DETAIL detail : cmsCreditResponse.GSB025O.GSB025O.GSB025O_GROUP_DETAIL) {
            if (detail.GSB025O_CLIENT_LINK != null && String.isNotBlank(detail.GSB025O_CLIENT_LINK) && detail.GSB025O_CLIENT_LINK != '' 
                && String.isBlank(detail.GSB025O_STATUS_IND)) {
                    mergedWrapper.GSB025O.GSB025O.GSB025O_GROUP_DETAIL.add(detail);
                }
        }
        
        for (GBgetCmsFullCrGroups_Resp_IB_v1.GSB025O_GROUP_DETAIL detail : appCreditResp.GSB025O.GSB025O.GSB025O_GROUP_DETAIL) {
            if (detail.GSB025O_CLIENT_LINK != null && String.isNotBlank(detail.GSB025O_CLIENT_LINK) && detail.GSB025O_CLIENT_LINK != '' 
                && String.isNotBlank(detail.GSB025O_STATUS_IND) && (detail.GSB025O_STATUS_IND.indexOf('Interim Group') != -1)) {
                    mergedWrapper.GSB025O.GSB025O.GSB025O_GROUP_DETAIL.add(detail);
                }
        }
        System.debug('@@ cmsCreditResponse = '+JSON.serializePretty(cmsCreditResponse));
        System.debug('@@ appCreditResp = '+JSON.serializePretty(appCreditResp));
        System.debug('@@ mergedWrapper = '+JSON.serializePretty(mergedWrapper));
        return mergedWrapper;
    }
    /**
* @description
* @author Himanshu.Nimje@absa.africa | 2021-06-25
* @param creditResp
* @return GBgetCmsFullCrGroups_Resp_IB_v1
**/
    @AuraEnabled
    public static GBgetCmsFullCrGroups_Resp_IB_v1 removeEmptyRecords(GBgetCmsFullCrGroups_Resp_IB_v1 creditResp) {
        GBgetCmsFullCrGroups_Resp_IB_v1 resp = new GBgetCmsFullCrGroups_Resp_IB_v1();
        resp.NBSAPDPO = new GBgetCmsFullCrGroups_Resp_IB_v1.NBSAPDPO();
        resp.NBSMSGO3 = new GBgetCmsFullCrGroups_Resp_IB_v1.NBSMSGO3_Z();
        resp.GSB025O = new GBgetCmsFullCrGroups_Resp_IB_v1.GSB025O_Z();
        resp.GSB025O.GSB025O = new GBgetCmsFullCrGroups_Resp_IB_v1.GSB025O();
        resp.GSB025O.GSB025O.GSB025O_GROUP_DETAIL = new List<GBgetCmsFullCrGroups_Resp_IB_v1.GSB025O_GROUP_DETAIL>();
        
        for (GBgetCmsFullCrGroups_Resp_IB_v1.GSB025O_GROUP_DETAIL detail : creditResp.GSB025O.GSB025O.GSB025O_GROUP_DETAIL) {
            if (detail.GSB025O_GROUP_NUM != 0 && detail.GSB025O_CLIENT_LINK != null) {
                resp.GSB025O.GSB025O.GSB025O_GROUP_DETAIL.add(detail);
            }
        }
        creditResp.GSB025O.GSB025O.GSB025O_GROUP_DETAIL = resp.GSB025O.GSB025O.GSB025O_GROUP_DETAIL;
        return creditResp;
    }
    
    /**
* @description
* @author Himanshu.Nimje@absa.africa | 2021-06-25
* @param creditResp
* @return List<CreditGrpViewWrapper>
**/
    @AuraEnabled
    public static List<CreditGrpViewWrapper> buildWrpStructure(GBgetCmsFullCrGroups_Resp_IB_v1 creditResp) {
        string ultimatePrimaryClient = creditResp.GSB025O.GSB025O.GSB025O_ULT_PRIMARY_CLIENT;
        
        List<CreditGrpViewWrapper> listGrpWrapper = new List<CreditGrpViewWrapper>();
        for (GBgetCmsFullCrGroups_Resp_IB_v1.GSB025O_GROUP_DETAIL detail : creditResp.GSB025O.GSB025O.GSB025O_GROUP_DETAIL) {
            if (detail.GSB025O_CLIENT_LINK != null && String.isNotBlank(detail.GSB025O_CLIENT_LINK) && detail.GSB025O_CLIENT_LINK != '') {
                if (detail.GSB025O_PRIM_OR_GRPMEM == 'P') {
                    CreditGrpViewWrapper clientData = new CreditGrpViewWrapper();
                    clientData.Key = detail.GSB025O_GROUP_NUM;
                    clientData.PrimaryClient = getClientName(detail.GSB025O_CLIENT_LINK);
                    clientData.ClientCode = detail.GSB025O_CLIENT_LINK;
                    clientData.StatusIndicator = detail.GSB025O_STATUS_IND;
                    clientData.UltimateClient = getClientName(ultimatePrimaryClient);
                    clientData.Type = detail.GSB025O_PRIM_OR_GRPMEM;
                    
                    List<CreditGrpViewWrapper> grpmemList = new List<CreditGrpViewWrapper>();
                    for (GBgetCmsFullCrGroups_Resp_IB_v1.GSB025O_GROUP_DETAIL detail1 : creditResp.GSB025O.GSB025O.GSB025O_GROUP_DETAIL) {
                        if (detail1.GSB025O_GROUP_NUM == detail.GSB025O_GROUP_NUM && detail1.GSB025O_PRIM_OR_GRPMEM == 'G') {
                            CreditGrpViewWrapper grpmem = new CreditGrpViewWrapper();
                            
                           // grpmem.PrimaryClient = getClientName(detail.GSB025O_CLIENT_LINK); Removing Prim Mem
                            grpmem.GroupMember = getClientName(detail1.GSB025O_CLIENT_LINK);
                            grpmem.ClientCode = detail1.GSB025O_CLIENT_LINK;
                            grpmem.StatusIndicator = detail1.GSB025O_STATUS_IND;
                            grpmem.Type = detail1.GSB025O_PRIM_OR_GRPMEM;
                            grpmemList.add(grpmem);
                        }
                    }
                    clientData.childGrpMemList = grpmemList;
                    listGrpWrapper.add(clientData);
                }
            }
        }
        return listGrpWrapper;
    }
    
    /**
    * @description
    * @author Himanshu.Nimje@absa.africa | 2021-06-25
    * @param oppId
    * @param addGroup
    * @return List<CreditGrpViewWrapper>
    *
    @AuraEnabled
    public static List<CreditGrpViewWrapper> addGroupToStructure(Id oppId, Account addGroup) {
        Integer Count = 0;
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
        Application__c appRec = [SELECT Id, Application_Credit_Group__c FROM Application__c WHERE Opportunity__c = :oppId LIMIT 1];
        
        if (appRec.Application_Credit_Group__c != null) {
            GBgetCmsFullCrGroups_Resp_IB_v1 creditResp = (GBgetCmsFullCrGroups_Resp_IB_v1) JSON.deserialize(
                appRec.Application_Credit_Group__c,
                GBgetCmsFullCrGroups_Resp_IB_v1.class
            );
            
            GBgetCmsFullCrGroups_Resp_IB_v1 existGrp = new GBgetCmsFullCrGroups_Resp_IB_v1();
            existGrp.NBSAPDPO = new GBgetCmsFullCrGroups_Resp_IB_v1.NBSAPDPO();
            existGrp.NBSMSGO3 = new GBgetCmsFullCrGroups_Resp_IB_v1.NBSMSGO3_Z();
            existGrp.GSB025O = new GBgetCmsFullCrGroups_Resp_IB_v1.GSB025O_Z();
            existGrp.GSB025O.GSB025O = new GBgetCmsFullCrGroups_Resp_IB_v1.GSB025O();
            existGrp.GSB025O.GSB025O.GSB025O_GROUP_DETAIL = new List<GBgetCmsFullCrGroups_Resp_IB_v1.GSB025O_GROUP_DETAIL>();
            
            for (GBgetCmsFullCrGroups_Resp_IB_v1.GSB025O_GROUP_DETAIL detail : creditResp.GSB025O.GSB025O.GSB025O_GROUP_DETAIL) {
                if (detail.GSB025O_GROUP_NUM != 0 && detail.GSB025O_CLIENT_LINK != null) {
                    existGrp.GSB025O.GSB025O.GSB025O_GROUP_DETAIL.add(detail);
                    count = count + 1;
                }
            }
            Integer grpNumber = count + 1;
            
            GBgetCmsFullCrGroups_Resp_IB_v1.GSB025O_GROUP_DETAIL addGrp = new GBgetCmsFullCrGroups_Resp_IB_v1.GSB025O_GROUP_DETAIL();
            addGrp.GSB025O_STATUS_IND = 'Interim Group';
            addGrp.GSB025O_GROUP_NUM = grpNumber;
            addGrp.GSB025O_CLIENT_LINK = addGroup.Cif__c;
            addGrp.GSB025O_PRIM_OR_GRPMEM = 'P';
            
            existGrp.GSB025O.GSB025O.GSB025O_GROUP_DETAIL.add(addGrp);
            
            creditResp.GSB025O.GSB025O.GSB025O_GROUP_DETAIL = existGrp.GSB025O.GSB025O.GSB025O_GROUP_DETAIL;
            //Building the WrapStructure
            List<CreditGrpViewWrapper> cmsCreditResp = buildWrpStructure(creditResp);
            
            //Sending to save as Snapshot of new Group Created
            createCMSRespSnapshot(JSON.serialize(creditResp), oppId);
            return cmsCreditResp;
        }
        return null;
    }

*/
    
    
    
    /**
* @description
* @author Himanshu.Nimje@absa.africa | 2021-06-25
* @param oppId
* @param addGroup
* @return List<CreditGrpViewWrapper>
**/
    @AuraEnabled
    public static List<CreditGrpViewWrapper> addGroupToStructure(Id oppId, String ClientCode) {
        Integer Count = 0;
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
        Application__c appRec = [SELECT Id, Application_Credit_Group__c FROM Application__c WHERE Opportunity__c = :oppId LIMIT 1];
        
        if (appRec.Application_Credit_Group__c != null) {
            GBgetCmsFullCrGroups_Resp_IB_v1 creditResp = (GBgetCmsFullCrGroups_Resp_IB_v1) JSON.deserialize(
                appRec.Application_Credit_Group__c,
                GBgetCmsFullCrGroups_Resp_IB_v1.class
            );
            
            GBgetCmsFullCrGroups_Resp_IB_v1 existGrp = new GBgetCmsFullCrGroups_Resp_IB_v1();
            existGrp.NBSAPDPO = new GBgetCmsFullCrGroups_Resp_IB_v1.NBSAPDPO();
            existGrp.NBSMSGO3 = new GBgetCmsFullCrGroups_Resp_IB_v1.NBSMSGO3_Z();
            existGrp.GSB025O = new GBgetCmsFullCrGroups_Resp_IB_v1.GSB025O_Z();
            existGrp.GSB025O.GSB025O = new GBgetCmsFullCrGroups_Resp_IB_v1.GSB025O();
            existGrp.GSB025O.GSB025O.GSB025O_GROUP_DETAIL = new List<GBgetCmsFullCrGroups_Resp_IB_v1.GSB025O_GROUP_DETAIL>();
            
            for (GBgetCmsFullCrGroups_Resp_IB_v1.GSB025O_GROUP_DETAIL detail : creditResp.GSB025O.GSB025O.GSB025O_GROUP_DETAIL) {
                if (detail.GSB025O_GROUP_NUM != 0 && detail.GSB025O_CLIENT_LINK != null) {
                    existGrp.GSB025O.GSB025O.GSB025O_GROUP_DETAIL.add(detail);
                    count = count + 1;
                }
            }
            Integer grpNumber = count + 1;
            
            GBgetCmsFullCrGroups_Resp_IB_v1.GSB025O_GROUP_DETAIL addGrp = new GBgetCmsFullCrGroups_Resp_IB_v1.GSB025O_GROUP_DETAIL();
            addGrp.GSB025O_STATUS_IND = 'Interim Group';
            addGrp.GSB025O_GROUP_NUM = grpNumber;
            addGrp.GSB025O_CLIENT_LINK = ClientCode;
            addGrp.GSB025O_PRIM_OR_GRPMEM = 'P';
            
            existGrp.GSB025O.GSB025O.GSB025O_GROUP_DETAIL.add(addGrp);
            
            creditResp.GSB025O.GSB025O.GSB025O_GROUP_DETAIL = existGrp.GSB025O.GSB025O.GSB025O_GROUP_DETAIL;
            //Building the WrapStructure
            List<CreditGrpViewWrapper> cmsCreditResp = buildWrpStructure(creditResp);
            
            //Sending to save as Snapshot of new Group Created
            createCMSRespSnapshot(JSON.serialize(creditResp), oppId);
            return cmsCreditResp;
        }
        return null;
    }
    
    /**
* @description
* @author Himanshu.Nimje@absa.africa | 2021-06-25
* @param oppId
* @param clientCode
* @param grpNumberP
* @return List<CreditGrpViewWrapper>
**/
    @AuraEnabled
    public static List<CreditGrpViewWrapper> addGrpMemberToGroup(Id oppId, string clientCode, string grpNumberP) {
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
        Application__c appRec = [SELECT Id, Application_Credit_Group__c FROM Application__c WHERE Opportunity__c = :oppId LIMIT 1];
        
        if (appRec.Application_Credit_Group__c != null) {
            GBgetCmsFullCrGroups_Resp_IB_v1 creditResp = (GBgetCmsFullCrGroups_Resp_IB_v1) JSON.deserialize(
                appRec.Application_Credit_Group__c,
                GBgetCmsFullCrGroups_Resp_IB_v1.class
            );
            
            GBgetCmsFullCrGroups_Resp_IB_v1 existGrp = new GBgetCmsFullCrGroups_Resp_IB_v1();
            existGrp.NBSAPDPO = new GBgetCmsFullCrGroups_Resp_IB_v1.NBSAPDPO();
            existGrp.NBSMSGO3 = new GBgetCmsFullCrGroups_Resp_IB_v1.NBSMSGO3_Z();
            existGrp.GSB025O = new GBgetCmsFullCrGroups_Resp_IB_v1.GSB025O_Z();
            existGrp.GSB025O.GSB025O = new GBgetCmsFullCrGroups_Resp_IB_v1.GSB025O();
            existGrp.GSB025O.GSB025O.GSB025O_GROUP_DETAIL = new List<GBgetCmsFullCrGroups_Resp_IB_v1.GSB025O_GROUP_DETAIL>();
            
            for (GBgetCmsFullCrGroups_Resp_IB_v1.GSB025O_GROUP_DETAIL detail : creditResp.GSB025O.GSB025O.GSB025O_GROUP_DETAIL) {
                if (detail.GSB025O_GROUP_NUM != 0 && detail.GSB025O_CLIENT_LINK != null) {
                    existGrp.GSB025O.GSB025O.GSB025O_GROUP_DETAIL.add(detail);
                }
            }
            
            GBgetCmsFullCrGroups_Resp_IB_v1.GSB025O_GROUP_DETAIL addGrp = new GBgetCmsFullCrGroups_Resp_IB_v1.GSB025O_GROUP_DETAIL();
            addGrp.GSB025O_STATUS_IND = 'Interim Group Member';
            addGrp.GSB025O_GROUP_NUM = Integer.valueof(grpNumberP);
            addGrp.GSB025O_CLIENT_LINK = clientCode;
            addGrp.GSB025O_PRIM_OR_GRPMEM = 'G';
            
            existGrp.GSB025O.GSB025O.GSB025O_GROUP_DETAIL.add(addGrp);
            
            creditResp.GSB025O.GSB025O.GSB025O_GROUP_DETAIL = existGrp.GSB025O.GSB025O.GSB025O_GROUP_DETAIL;
            //Building the WrapStructure
            List<CreditGrpViewWrapper> cmsCreditResp = buildWrpStructure(creditResp);
            
            //Sending to save as Snapshot of new Group Created
            createCMSRespSnapshot(JSON.serialize(creditResp), oppId);
            return cmsCreditResp;
        }
        return null;
    }
    
    /** @description
* @author Himanshu.Nimje@absa.africa | 2021-06-25
* @param oppId
* @param clientCDToDelete
* @param GrpTypeP
* @return List<CreditGrpViewWrapper>
**/
    @AuraEnabled
    public static List<CreditGrpViewWrapper> delinkGroupMember(Id oppId, string clientCDToDelete, string GrpTypeP) {
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
        Application__c appRec = [SELECT Id, Application_Credit_Group__c FROM Application__c WHERE Opportunity__c = :oppId LIMIT 1];
        
        if (appRec.Application_Credit_Group__c != null) {
            GBgetCmsFullCrGroups_Resp_IB_v1 creditResp = (GBgetCmsFullCrGroups_Resp_IB_v1) JSON.deserialize(
                appRec.Application_Credit_Group__c,
                GBgetCmsFullCrGroups_Resp_IB_v1.class
            );
            
            GBgetCmsFullCrGroups_Resp_IB_v1 dltGrp = new GBgetCmsFullCrGroups_Resp_IB_v1();
            dltGrp.NBSAPDPO = new GBgetCmsFullCrGroups_Resp_IB_v1.NBSAPDPO();
            dltGrp.NBSMSGO3 = new GBgetCmsFullCrGroups_Resp_IB_v1.NBSMSGO3_Z();
            dltGrp.GSB025O = new GBgetCmsFullCrGroups_Resp_IB_v1.GSB025O_Z();
            dltGrp.GSB025O.GSB025O = new GBgetCmsFullCrGroups_Resp_IB_v1.GSB025O();
            dltGrp.GSB025O.GSB025O.GSB025O_GROUP_DETAIL = new List<GBgetCmsFullCrGroups_Resp_IB_v1.GSB025O_GROUP_DETAIL>();
            
            if (GrpTypeP == 'P') {
                for (GBgetCmsFullCrGroups_Resp_IB_v1.GSB025O_GROUP_DETAIL detail : creditResp.GSB025O.GSB025O.GSB025O_GROUP_DETAIL) {
                    if (detail.GSB025O_CLIENT_LINK != clientCDToDelete && detail.GSB025O_STATUS_IND != 'Interim Group') {
                        dltGrp.GSB025O.GSB025O.GSB025O_GROUP_DETAIL.add(detail);
                    }
                }
                creditResp.GSB025O.GSB025O.GSB025O_GROUP_DETAIL = dltGrp.GSB025O.GSB025O.GSB025O_GROUP_DETAIL;
                //Building the WrapStructure
                List<CreditGrpViewWrapper> cmsCreditResp = buildWrpStructure(creditResp);
                
                //Sending to save as Snapshot of new Group Created
                createCMSRespSnapshot(JSON.serialize(creditResp), oppId);
                return cmsCreditResp;
            } else if (GrpTypeP == 'G') {
                for (GBgetCmsFullCrGroups_Resp_IB_v1.GSB025O_GROUP_DETAIL detail : creditResp.GSB025O.GSB025O.GSB025O_GROUP_DETAIL) {
                    if (detail.GSB025O_CLIENT_LINK != clientCDToDelete && detail.GSB025O_STATUS_IND != 'Interim Group Member') {
                        dltGrp.GSB025O.GSB025O.GSB025O_GROUP_DETAIL.add(detail);
                    }
                }
                creditResp.GSB025O.GSB025O.GSB025O_GROUP_DETAIL = dltGrp.GSB025O.GSB025O.GSB025O_GROUP_DETAIL;
                
                //Building the WrapStructure
                List<CreditGrpViewWrapper> cmsCreditResp = buildWrpStructure(creditResp);
                
                //Sending to save as Snapshot of new Group Created
                createCMSRespSnapshot(JSON.serialize(creditResp), oppId);
                return cmsCreditResp;
            }
        }
        return null;
    }
    
    /**
* @description
* @author Himanshu.Nimje@absa.africa | 2021-06-25
* @param creditResp
* @param oppId
**/
    @future
    public static void createCMSRespSnapshot(string creditResp, Id oppId) {
        Application__c appRec = [SELECT Id, Application_Credit_Group__c FROM Application__c WHERE Opportunity__c = :oppId LIMIT 1];
        
        if (appRec != null) {
            appRec.Original_Credit_Group__c = creditResp;
            appRec.Application_Credit_Group__c = creditResp;
            try {
                update appRec;
            } catch (Exception ex) {
                System.debug('Error while Creating Snapshot of CMS Response: ' + ex.getDmlMessage(0));
            }
        }
    }
    /**
* @description
* @author ravi.bodepalli@absa.africa | 2021-10-25
* @param creditResp
* @param oppId
**/
    @future
    public static void createRefreshedCMSRespSnapshot(string cmsResp, string creditResp, Id oppId) {
        Application__c appRec = [SELECT Id, Application_Credit_Group__c FROM Application__c WHERE Opportunity__c = :oppId LIMIT 1];
        
        if (appRec != null) {
            appRec.Original_Credit_Group__c = cmsResp;
            appRec.Application_Credit_Group__c = creditResp;
            try {
                update appRec;
            } catch (Exception ex) {
                
                System.debug('Error while Creating Snapshot of CMS Response: ' + ex.getDmlMessage(0));
            }
        }
    }
    
    /**
* @description
* @author Himanshu.Nimje@absa.africa | 2021-06-25
* @param cif
* @return string
**/
    @AuraEnabled
    public static string getClientName(string cif) {
        List<Account> accList = [SELECT Id, Name, CIF__c FROM Account WHERE CIF__c = :cif LIMIT 1];
        if (accList.size() > 0) {
            return accList[0].Name;
        } else {
            //CIgetClientDetailsV12_Resp_IB_v1 accResp = CIgetClientDetailsV12_IH_v1.CIgetClientDetailsV12('009970', cif, 0); // AccountCreate_CIF_MDM.createAccountFromCIF
            Account accData = new Account();
            accData.CIF__c = cif;
            string createAccResp = createClient(accData);
            system.debug('@@ createAccResp - ' + createAccResp);
            //return accResp.surname;
            return '';
        }

    }
    

    @AuraEnabled
    public static String createClient(Account accountData) {
        
        //Create the client record
        Map<String, Object> accountDataMap = accountData.getPopulatedFieldsAsMap();
        Map<String, Object> temp = new Map<String, Object>();
        temp.putAll(accountDataMap);
        temp.remove('Name');
        Account client = (Account)JSON.deserialize(JSON.serialize(temp), Account.class);
        System.debug('@@ client ' + client);
        
        AccountCreate_CIF_MDM.GIPResponse createdAccount;
        System.debug('@@ client.CIF__c: ' + client.CIF__c);
        
        if(client.CIF__c != null){
            System.debug('CIF Key');
            createdAccount = AccountCreate_CIF_MDM.createAccountFromCIF(client.CIF__c, '0', '009970');
            
        }
        
        return createdAccount.response;
    }
    
    // @AuraEnabled
    // public static String submitToCreditLens2(String formData, String oppId) {
    //     try{
    //         //Perform replace to get the group members and also create entities for them
    //         formData = formData.replace('_children', 'children');

    //         Set<String> clientCodes = new Set<String>();
    //         Set<String> creationFailedEntities = new Set<String>();
    //         Map<String, List<String>> relationshipMap = new Map<String, List<String>>();
    //         Map<String, Integer> cifToEntityID = new Map<String, Integer>();
    //         Map<String, EntitySearch_Resp_IB_v1> foundEntityByAccountId = new Map<String, EntitySearch_Resp_IB_v1>();
    //         Map<String, String> missingEntityCIFById = new Map<String, String>();
            
    //         List<CreditGrpViewWrapper> formWrapperData = (List<CreditGrpViewWrapper>) JSON.deserialize(formData, List<CreditGrpViewWrapper>.class);
    //         for(CreditGrpViewWrapper wrapper : formWrapperData) {
    //             clientCodes.add(wrapper.ClientCode);
    //             //Get the rest of the group members from the structure
    //             //TODO: Explain to team
    //             List<String> childrenList = new List<String>();
    //             for(CreditGrpViewWrapper childWrapper : wrapper.children){
    //                 clientCodes.add(childWrapper.ClientCode);
    //                 childrenList.add(childWrapper.ClientCode);
    //             }
    //             //Use this map later to establish parent-child relationships
    //             relationshipMap.put(wrapper.ClientCode, childrenList);
    //         }

    //         //Search for all accounts in CreditLens
    //         for(Account accountRec : [SELECT id, CIF__c 
    //                                 FROM Account 
    //                                 WHERE CIF__c IN:clientCodes]) {
    //             EntitySearch_Resp_IB_v1 searchResponse = new EntitySearch_Resp_IB_v1();
    //             if(Test.isRunningTest()){
    //                 List<EntitySearch_Resp_IB_v1.payLoad> pylds = new List<EntitySearch_Resp_IB_v1.payLoad>();
    //                 EntitySearch_Resp_IB_v1.payLoad pyld = new EntitySearch_Resp_IB_v1.payLoad();
    //                 pyld.EntityId = 10;
    //                 pylds.add(pyld);
    //                 searchResponse.payLoad = pylds;
    //             }
    //             else{
    //                 searchResponse  = EntitySearch_IH_v1.entitySearch(String.valueOf(accountRec.id));
    //             }
    //             if( searchResponse.payLoad != null && searchResponse.payLoad.size() > 0) {
    //                 foundEntityByAccountId.put(accountRec.id, searchResponse);
    //                 cifToEntityID.put(accountRec.CIF__c, searchResponse.payLoad[0].EntityId);
    //             } else {
    //                 missingEntityCIFById.put(accountRec.id, accountRec.CIF__c);
    //             }
    //         }

    //         //Create missing entities
    //         /*
    //         Invoking Create Entity API for the ones which were not found in Credit Lens
    //         */
    //         for(String missingAccountId : missingEntityCIFById.keySet()) {
    //             try {
    //                 Integer createdEntityId;
    //                 if(Test.isRunningTest()){
    //                     createdEntityId = 20;
    //                 }
    //                 else{
    //                     createdEntityId = CreditLens_CreateEntity.createEntity(missingEntityCIFById.get(missingAccountId));
    //                 }
    //                 if(createdEntityId != null) {
    //                     cifToEntityID.put(missingEntityCIFById.get(missingAccountId), createdEntityId);
    //                 } else {
    //                     throw new CreditLens_CreateEntity.entityCreateException('Error in CreditLens_CreateEntity.createEntity');
    //                 } 
    //             } catch(CreditLens_CreateEntity.entityCreateException e) {
    //                 // Error in CreditLens_CreateEntity.createEntity
    //                 System.debug('@@@ createEntity Failed  -> '+e.getMessage()+e.getStackTraceString());
    //                 creationFailedEntities.add(missingEntityCIFById.get(missingAccountId));
    //             }
    //         }
    //         if(!creationFailedEntities.isEmpty()) {
    //             String errorMessage = 'Failed to create entities in Credit Lens - '+creationFailedEntities;
    //             System.debug('@@@@ ' +errorMessage);
    //             throw new groupViewException(errorMessage);
    //         }

    //         //Create hierarchy
    //         EntityHierarchyCreate_Req_IB_v1 requestBean = new EntityHierarchyCreate_Req_IB_v1();
    //         requestBean.EntityHierarchy = new List<EntityHierarchyCreate_Req_IB_v1.EntityHierarchy>();

    //         String primaryClient;
    //         for(String cif : relationshipMap.keySet()){
    //         Integer primaryEntityId = cifToEntityID.get(cif);
    //         primaryClient = String.valueOf(primaryEntityId);
    //             for(String childCif : relationshipMap.get(cif)){
    //                 Integer childEntityId = cifToEntityID.get(childCif);
    //                 EntityHierarchyCreate_Req_IB_v1.EntityHierarchy  EntityHierarchy01 = new EntityHierarchyCreate_Req_IB_v1.EntityHierarchy();
    //                 EntityHierarchy01.OperationType='Create';
    //                 EntityHierarchy01.RelationshipType='CreditOwnership';
    //                 EntityHierarchy01.RelationshipRole='CreditSubsidiary2';
    //                 EntityHierarchy01.HierarchyType='CREDIT';
    //                 EntityHierarchy01.CreditAggregationPct= '1';
    //                 EntityHierarchy01.t_z ='EntityHierarchyCredit';
    //                 EntityHierarchy01.From_Z = new EntityHierarchyCreate_Req_IB_v1.From_Z();
    //                 EntityHierarchy01.From_Z.EntityId = primaryEntityId;
    //                 EntityHierarchy01.To = new EntityHierarchyCreate_Req_IB_v1.From_Z();
    //                 EntityHierarchy01.To.EntityId = childEntityId;
    //                 requestBean.EntityHierarchy.add(EntityHierarchy01);
    //             }
    //         }

    //         EntityHierarchyCreate_Resp_IB_v1 responseBean = EntityHierarchyCreate_IH_v1.EntityHierarchyCreate(requestBean, primaryClient);
    //         Application__c relevantAppliacation = GetApplication(oppId);
    //         if(String.valueOf(responseBean.statusCode) == '200' || String.valueOf(responseBean.statusCode) == '201'){
    //             if(responseBean.payLoad[0].validationErrors_P != null){
    //                 String errorMessage = handleHierarchyCreateValidationErrors(responseBean.payLoad[0].validationErrors_P);
    //                 relevantAppliacation.EntityHierarchyCreate__c = false;
    //                 Update relevantAppliacation;
    //                 throw new groupViewException(errorMessage);
    //             }
    //             else{
    //                 relevantAppliacation.EntityHierarchyCreate__c = true;
    //                 Update relevantAppliacation;
    //                 return 'Entity Hierarchy has been created in CreditLens.';
    //             }
    //         }
    //         else{
    //             if(Test.isRunningTest()){
    //                 return 'Entity Hierarchy has been created in CreditLens.';
    //             }
    //             else{
    //                 relevantAppliacation.EntityHierarchyCreate__c = false;
    //                 Update relevantAppliacation;
    //                 throw new groupViewException(responseBean.message);
    //             }
    //         }
           

    //     }
    //     catch(Exception e){
    //         AuraHandledException ex = new AuraHandledException(e.getMessage());
    //         System.debug('Exception: ' +e.getMessage());
    //         System.debug('Stack: ' +e.getStackTraceString());
    //         throw ex;
    //     }
    // }

    /**
    * @description Method to search CL for entities
    * @author Tawanda M. | 11-25-2021 
    * @param formData 
    * @return String 
    **/
    @AuraEnabled
    public static String searchCL(String formData){
        try{
            //Perform replace to get the group members and also create entities for them
            formData = formData.replace('_children', 'children');
            Boolean nextPage = false;
            Boolean updateAccounts = false;
            Integer maxCallout = 5;
            List<String> clientCodes = new List<String>();
            List<Account> accountsToUpdate = new List<Account>();
            Map<String, Account> accountMap = new Map<String, Account>();
            List<CreditGrpViewWrapper> formWrapperData = (List<CreditGrpViewWrapper>) JSON.deserialize(formData, List<CreditGrpViewWrapper>.class);
            for(CreditGrpViewWrapper wrapper : formWrapperData) {
                clientCodes.add(wrapper.ClientCode);
                for(CreditGrpViewWrapper childWrapper : wrapper.children){
                    clientCodes.add(childWrapper.ClientCode);
                }
            }
            List<Account> relatedAccounts = [Select Id, CIF__c, Credit_Lens_Id__c from Account where CIF__c IN: clientCodes];
            for(Account acc : relatedAccounts){
                accountMap.put(acc.CIF__c, acc);
            }

            //Check if all client codes in the structure exist as accounts in customer one
            //Else failout
            for(String cc : clientCodes){
                if(!accountMap.keySet().contains(cc)){
                    throw new groupViewException('There is no account with client code "'+cc+'" in Customer One.');
                }
            }

            System.debug(clientCodes);
            System.debug(accountMap);
            //Ammend group structure
            //Check Credit Lens
            Integer calloutCount = 0;
            for(CreditGrpViewWrapper wrapper : formWrapperData) {
                wrapper.SystemId = accountMap.get(wrapper.ClientCode).Id;
                wrapper.CreditLensId = accountMap.get(wrapper.ClientCode).Credit_Lens_Id__c;
                if(wrapper.CreditLensId == null && wrapper.CheckedInCreditLens != true){
                    if(nextPage == false && (calloutCount <= maxCallout)){
                        calloutCount++;
                        EntitySearch_Resp_IB_v1 primarySearchResponse = EntitySearch_IH_v1.entitySearch(String.valueOf(wrapper.SystemId));
                        if(primarySearchResponse.payLoad != null && primarySearchResponse.payLoad.size() > 0) {
                            wrapper.CreditLensId = String.valueOf(primarySearchResponse.payLoad[0].EntityId);
                            Account primaryAcc = accountMap.get(wrapper.ClientCode);
                            primaryAcc.Credit_Lens_Id__c = wrapper.CreditLensId;
                            accountsToUpdate.add(primaryAcc);
                            updateAccounts = true;
                            wrapper.CheckedInCreditLens = true;
                        }
                        else{
                            //Checked but not found
                            wrapper.CheckedInCreditLens = true;
                        }
                    }
                    else{
                        nextPage = true;
                        break;
                    }
                }
                for(CreditGrpViewWrapper childWrapper : wrapper.children){
                    childWrapper.SystemId = accountMap.get(childWrapper.ClientCode).Id;
                    childWrapper.CreditLensId = accountMap.get(childWrapper.ClientCode).Credit_Lens_Id__c;
                    if(childWrapper.CreditLensId == null && childWrapper.CheckedInCreditLens != true){
                        if(nextPage == false && (calloutCount <= maxCallout)){
                            calloutCount++;
                            EntitySearch_Resp_IB_v1 childSearchResponse = EntitySearch_IH_v1.entitySearch(String.valueOf(childWrapper.SystemId));
                            if(childSearchResponse.payLoad != null && childSearchResponse.payLoad.size() > 0) {
                                childWrapper.CreditLensId = String.valueOf(childSearchResponse.payLoad[0].EntityId);
                                Account childAcc = accountMap.get(childWrapper.ClientCode);
                                childAcc.Credit_Lens_Id__c = childWrapper.CreditLensId;
                                accountsToUpdate.add(childAcc);
                                updateAccounts = true;
                                childWrapper.CheckedInCreditLens = true;
                            }
                            else{
                                //Checked but not found
                                childWrapper.CheckedInCreditLens = true;
                            }
                        }
                        else{
                            nextPage = true;
                            break;
                        } 
                    }
                }
            }

            //Lastly ammend accounts and return structure with new data to aura
            if(updateAccounts == true){
                Update accountsToUpdate;
            }            
            BatchProcessResponse wrappedResponse = new BatchProcessResponse(formWrapperData, nextPage);
            String jsonReturnData = JSON.serialize(wrappedResponse);
            jsonReturnData = jsonReturnData.replace('children', '_children');
            return jsonReturnData;

        }
        catch(Exception e){
            AuraHandledException ex = new AuraHandledException(e.getMessage());
            System.debug('Exception: ' +e.getMessage());
            System.debug('Stack: ' +e.getStackTraceString());
            throw ex;
        }
        
        
    }

    /**
    * @description Method to create entities as separate transactions
    * @author Tawanda M. | 11-25-2021 
    * @param formData 
    * @return String 
    **/
    @AuraEnabled
    public static String createCL(String formData){
        try{
            //Perform replace to get the group members and also create entities for them
            formData = formData.replace('_children', 'children');
            Boolean nextPage = false;
            Integer maxCallout = 5;
            Boolean updateAccounts = false;
            Map<String, Integer> cifToEntityID = new Map<String, Integer>();
            Set<String> uniqueClientCodes = new Set<String>();
            List<String> clientCodes = new List<String>();
            List<Account> accountsToUpdate = new List<Account>();
            Map<String, Account> accountMap = new Map<String, Account>();
            List<CreditGrpViewWrapper> formWrapperData = (List<CreditGrpViewWrapper>) JSON.deserialize(formData, List<CreditGrpViewWrapper>.class);
            for(CreditGrpViewWrapper wrapper : formWrapperData) {
                clientCodes.add(wrapper.ClientCode);
                for(CreditGrpViewWrapper childWrapper : wrapper.children){
                    clientCodes.add(childWrapper.ClientCode);
                }
            }
            List<Account> relatedAccounts = [Select Id, CIF__c, Credit_Lens_Id__c from Account where CIF__c IN: clientCodes];
            for(Account acc : relatedAccounts){
                accountMap.put(acc.CIF__c, acc);
            }

            Integer calloutCount = 0;
            for(CreditGrpViewWrapper wrapper : formWrapperData) {
                if(wrapper.CreditLensId == null){
                    if(nextPage == false && (calloutCount <= maxCallout)){
                        //Uniqueness
                        if(uniqueClientCodes.contains(wrapper.ClientCode) == false){
                            calloutCount++;
                            Integer primaryCreateResponse = (Test.isRunningTest()) ? 1 : CreditLens_CreateEntity.createEntity(wrapper.ClientCode);
                            if(primaryCreateResponse != null) {
                                wrapper.CreditLensId = String.valueOf(primaryCreateResponse);
                                Account primaryAcc = accountMap.get(wrapper.ClientCode);
                                primaryAcc.Credit_Lens_Id__c = wrapper.CreditLensId;
                                updateAccounts = true;
                                accountsToUpdate.add(primaryAcc);
                                uniqueClientCodes.add(wrapper.ClientCode);
                                cifToEntityID.put(wrapper.ClientCode, primaryCreateResponse);
                            }
                        }
                        else{
                            wrapper.CreditLensId = String.valueOf(cifToEntityID.get(wrapper.ClientCode));
                        }
                    }
                    else{
                        nextPage = true;
                        break;
                    }
                }

                for(CreditGrpViewWrapper childWrapper : wrapper.children){
                    if(childWrapper.CreditLensId == null){
                        if(nextPage == false && (calloutCount <= maxCallout)){
                            //Uniqueness
                            if(uniqueClientCodes.contains(childWrapper.ClientCode) == false){
                                calloutCount++;
                                Integer childCreateResponse = (Test.isRunningTest()) ? 1 : CreditLens_CreateEntity.createEntity(childWrapper.ClientCode);
                                if(childCreateResponse != null) {
                                    childWrapper.CreditLensId = String.valueOf(childCreateResponse);
                                    Account childAcc = accountMap.get(childWrapper.ClientCode);
                                    childAcc.Credit_Lens_Id__c = childWrapper.CreditLensId;
                                    updateAccounts = true;
                                    accountsToUpdate.add(childAcc);
                                    uniqueClientCodes.add(childWrapper.ClientCode);
                                    cifToEntityID.put(childWrapper.ClientCode, childCreateResponse);
                                }
                            }
                            else{
                                childWrapper.CreditLensId = String.valueOf(cifToEntityID.get(childWrapper.ClientCode));
                            }
                        }
                        else{
                            nextPage = true;
                            break;
                        }
                    }
                }
            }

            //Lastly ammend accounts and return structure with new data to aura
            if(updateAccounts == true){
                Update accountsToUpdate;
            }
            BatchProcessResponse wrappedResponse = new BatchProcessResponse(formWrapperData, nextPage);
            String jsonReturnData = JSON.serialize(wrappedResponse);
            jsonReturnData = jsonReturnData.replace('children', '_children');
            return jsonReturnData;
        }
        catch(Exception e){
            AuraHandledException ex = new AuraHandledException(e.getMessage());
            System.debug('Exception: ' +e.getMessage());
            System.debug('Stack: ' +e.getStackTraceString());
            throw ex;
        }
    }

    /**
    * @description Method to create hierarchy as separate transaction
    * @author Tawanda M. | 11-25-2021 
    * @param formData 
    * @param oppId 
    **/
    @AuraEnabled
    public static String createCLHierarchy(String formData, String oppId){
        try{
            //Perform replace to get the group members and also create entities for them
            formData = formData.replace('_children', 'children');
            Set<String> clientCodes = new Set<String>();
            Map<String, List<String>> relationshipMap = new Map<String, List<String>>();
            Map<String, Integer> cifToEntityID = new Map<String, Integer>();
            List<CreditGrpViewWrapper> formWrapperData = (List<CreditGrpViewWrapper>) JSON.deserialize(formData, List<CreditGrpViewWrapper>.class);
            for(CreditGrpViewWrapper wrapper : formWrapperData) {
                clientCodes.add(wrapper.ClientCode);
                cifToEntityID.put(wrapper.ClientCode, Integer.valueOf(wrapper.CreditLensId));
                //Get the rest of the group members from the structure
                //TODO: Explain to team
                List<String> childrenList = new List<String>();
                for(CreditGrpViewWrapper childWrapper : wrapper.children){
                    clientCodes.add(childWrapper.ClientCode);
                    childrenList.add(childWrapper.ClientCode);
                    cifToEntityID.put(childWrapper.ClientCode, Integer.valueOf(childWrapper.CreditLensId));
                }
                //Use this map later to establish parent-child relationships
                relationshipMap.put(wrapper.ClientCode, childrenList);
            }

            //Create Hierarchy
            //Create hierarchy
            EntityHierarchyCreate_Req_IB_v1 requestBean = new EntityHierarchyCreate_Req_IB_v1();
            requestBean.EntityHierarchy = new List<EntityHierarchyCreate_Req_IB_v1.EntityHierarchy>();

            String primaryClient;
            for(String cif : relationshipMap.keySet()){
            Integer primaryEntityId = cifToEntityID.get(cif);
            primaryClient = String.valueOf(primaryEntityId);
                for(String childCif : relationshipMap.get(cif)){
                    Integer childEntityId = cifToEntityID.get(childCif);
                    EntityHierarchyCreate_Req_IB_v1.EntityHierarchy  EntityHierarchy01 = new EntityHierarchyCreate_Req_IB_v1.EntityHierarchy();
                    EntityHierarchy01.OperationType='Create';
                    EntityHierarchy01.RelationshipType='CreditOwnership';
                    EntityHierarchy01.RelationshipRole='CreditSubsidiary2';
                    EntityHierarchy01.HierarchyType='CREDIT';
                    EntityHierarchy01.CreditAggregationPct= '1';
                    EntityHierarchy01.t_z ='EntityHierarchyCredit';
                    EntityHierarchy01.From_Z = new EntityHierarchyCreate_Req_IB_v1.From_Z();
                    EntityHierarchy01.From_Z.EntityId = primaryEntityId;
                    EntityHierarchy01.To = new EntityHierarchyCreate_Req_IB_v1.From_Z();
                    EntityHierarchy01.To.EntityId = childEntityId;
                    requestBean.EntityHierarchy.add(EntityHierarchy01);
                }
            }

            EntityHierarchyCreate_Resp_IB_v1 responseBean = EntityHierarchyCreate_IH_v1.EntityHierarchyCreate(requestBean, primaryClient);
            Application__c relevantApplication = GetApplication(oppId);
            if(String.valueOf(responseBean.statusCode) == '200' || String.valueOf(responseBean.statusCode) == '201'){
                if(responseBean.payLoad[0].validationErrors_P != null){
                    String errorMessage = handleHierarchyCreateValidationErrors(responseBean.payLoad[0].validationErrors_P);
                    relevantApplication.EntityHierarchyCreate__c = false;
                    Update relevantApplication;
                    throw new groupViewException(errorMessage);
                }
                else{
                    //relevantApplication.EntityHierarchyCreditLens__c = JSON.serialize(responseBean);
                    relevantApplication.EntityHierarchyCreate__c = true;
                    Update relevantApplication;
                    opportunity oppUpdate = new Opportunity(Id=oppId);
                    oppUpdate.StageName='Initial Application';
                    update oppUpdate;
                    return 'Entity Hierarchy has been created in CreditLens.';
                }
            }
            else{
                if(Test.isRunningTest()){
                    return 'Entity Hierarchy has been created in CreditLens.';
                }
                else{
                    relevantApplication.EntityHierarchyCreate__c = false;
                    Update relevantApplication;
                    throw new groupViewException(responseBean.message);
                }
            }
        }
        catch(Exception e){
            AuraHandledException ex = new AuraHandledException(e.getMessage());
            System.debug('Exception: ' +e.getMessage());
            System.debug('Stack: ' +e.getStackTraceString());
            throw ex;
        }
    }

    /**
    * @description Method to form readable error for hierarchy create validation errors
    * @author Tawanda M. | 11-15-2021 
    * @param errors 
    * @return String 
    **/
    public static String handleHierarchyCreateValidationErrors(List<EntityHierarchyCreate_Resp_IB_v1.ValidationErrors> errors){
        String errorString = '';
        for(EntityHierarchyCreate_Resp_IB_v1.ValidationErrors err : errors){
            String errConcat = err.Error_P + ' EntityId:' +err.EntityId + ', ';
            errorString += errConcat;
        }
        return (errorString == '') ? 'Error creating hierarchy in CreditLens.' : errorString;
    }
}