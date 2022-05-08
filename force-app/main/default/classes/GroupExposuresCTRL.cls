/**
 * @description       : Controller class for GroupExposures
 * @author            : Thabo Senkomane
 * @last modified on  : 2021-06-11
 * @last modified by  : Thabo Senkomane
 * Modifications Log 
 * Ver   Date         Author            Modification
 * 1.0   2021-01-12   Gulafsha   Initial Version
**/

public class GroupExposuresCTRL {
    /**
 * @description       : Inner class with params
 * @author            : Thabo Senkomane
 
**/
    public class GroupExposures {
        /** @description : ClientName property */
        @auraEnabled public String ClientName { get;set; }
        /** @description : ClientCode property */
        @auraEnabled public String ClientCode { get;set; }
        /** @description : PrimaryClientCode property */
        @auraEnabled public String PrimaryClientCode { get;set; }
        /** @description : UltimatePrimaryClientCode property */
        @auraEnabled public String UltimatePrimaryClientCode { get;set; }
        /** @description : TGOE property */
        @auraEnabled public Decimal TGOE { get;set; }
        /** @description : TGAE property */
        @auraEnabled public Decimal TGAE { get;set; }
        /** @description : TGE property */
        @auraEnabled public Decimal TGE { get;set; }
        /** @description : TGBE property */
        @auraEnabled public Decimal TGBE { get;set; }
        /** @description : TGIE property */
        @auraEnabled public Decimal TGIE { get;set; }
        /** @description : ControlBranch property */
        @auraEnabled public String ControlBranch  { get;set; }
        /** @description : OverallControlBranch property */
        @auraEnabled public String OverallControlBranch  { get;set; }
        /** @description : IsFirstNameVis property */
        @auraEnabled public Boolean IsFirstNameVis { get;set; }
        /** @description : LastModifiedDate property */
        @auraEnabled public Datetime LastModifiedDate { get;set; }

        /**
        * @description :Constructor with params
        * @author Thabo Senkomane | 2021-06-11 
        **/
        public GroupExposures() {
            ClientName = null;
            ClientCode = null;
            PrimaryClientCode = null;
            UltimatePrimaryClientCode = null;
            TGOE = 0.00;
            TGAE = 0.00;
            TGE = 0.00;
            TGBE = 0.00;
            TGIE = 0.00;
            ControlBranch = null;
            OverallControlBranch = null;
            IsFirstNameVis = false;
            LastModifiedDate = null;
        }
    }


    /**
    * @description :Future Method to get group exposures
    * @author Thabo Senkomane | 2021-06-11 
    * @param mapClientDetails 
    * @param appId 
    **/
    @Future(callout=true)
    public static void getGroupExposureFromServiceFuture(Map<String,String> mapClientDetails, Id appId) {
        List<Application_Exposure_Total_Group__c> aeTotGrLstIns = new List<Application_Exposure_Total_Group__c>();

        for (String code :mapClientDetails.keyset()) {
            String clientCode = code;
            String cmscode = code; // added for w-12676 
            String clientNameType = mapClientDetails.get(code);
            String clientName = clientNameType.substringBefore(';');
            String applicantType = clientNameType.substringAfter(';');

            List<Application_Exposure_Total_Group__c> aeTotGrLst = new ApplicationsTotalGroupSelector().getApplicationTotalGroupByClientCode(clientCode, appId);

            if(aeTotGrLst.size() == 0) {
                //call cms service
                GBgetCmsCreditGroupsDetV1_Resp_IB_v1 cmsResp = gbGetCmsCreditGroupsDetV1Service(clientCode);
                Application_Exposure_Total_Group__c atg = new Application_Exposure_Total_Group__c();
                atg.Application__c = appId;
                atg.Client_Name__c = clientName;
                atg.Client_Code__c = clientCode;
                atg.Application_Total_Group__c = 'Client Total Group Exposure';

                if(cmsResp?.GSB014O != null) {
                    String partOfCreditGroup = cmsResp.GSB014O.GSB014O.GSB014O_PART_OF_GROUP;
                    atg.Primary_Client_of_Group__c = cmsResp.GSB014O.GSB014O.GSB014O_PRIMARY_CLIENT;
                    atg.Ultimate_Primary_Client__c = cmsResp.GSB014O.GSB014O.GSB014O_ULT_PRIMARY_CLIENT;
                    atg.Part_of_Credit_Group__c = (partOfCreditGroup.equalsIgnoreCase('Y') ? 'Yes' : 'No');

                    if(applicantType == 'Main Applicant' && partOfCreditGroup.equalsIgnoreCase('Y')) {
                        clientCode = cmsResp.GSB014O.GSB014O.GSB014O_ULT_PRIMARY_CLIENT;
                    }
                }

                //call control branch service
                GBGetContBranchDetV1_Resp_IB_v1 controlBranchResp = gbGetContBranchDetV1Service(cmscode); //added for w-012676 instead ult primary client consider main applicant 

                if(controlBranchResp?.GSB021O != null) {
                    GBGetContBranchDetV1_Resp_IB_v1.GSB021O_Z var = controlBranchResp.GSB021O;
                    atg.Overall_Control_Branch__c = String.valueOf(var.GSB021O.GSB021O_OVERALL_CONTROL);
                    atg.Control_Branch__c = String.valueOf(var.GSB021O.GSB021O_CONTROL_BRANCH);
                    atg.Branch_code__c = String.valueOf(var.GSB021O.GSB021O_CONTROL_BRANCH);
                    atg.Overall_Control_Branch_Code__c = String.valueOf(var.GSB021O.GSB021O_OVERALL_CONTROL);
                    atg.Business_Segment__c = var.GSB021O.GSB021O_BUSINESS_SEG;
                    atg.Business_Sub_Segment__c = var.GSB021O.GSB021O_BUSINESS_SUB_SEG;
                    atg.Existing_Franchisor_Type_Code__c = String.valueOf(var.GSB021O.GSB021O_FRANCHISOR_CODE);
                    atg.Existing_Franchise_Name__c = String.valueOf(var.GSB021O.GSB021O_FRANCH_CODE_DESC);
                    atg.Exposure_Policy_Indicator__c = var.GSB021O.GSB021O_EXPOSURE_POLICY;
                }

                //call total group service
                GBgetTotalGroupExposureV3_Resp_IB_v1 respBean = GBgetTotalGroupExposureV3Service(clientCode);
                if(respBean?.GSB002O != null ) {
                    atg.TGOE__c = Decimal.valueOf(respBean.GSB002O.GSB002O.GSB002O_TGOE);
                    atg.TGAE__c = Decimal.valueOf(respBean.GSB002O.GSB002O.GSB002O_TGAE);
                    atg.TGE__c = Decimal.valueOf(respBean.GSB002O.GSB002O.GSB002O_TGE);
                    atg.TGBE__c = Decimal.valueOf(respBean.GSB002O.GSB002O.GSB002O_TGBE);
                    atg.TGIE__c = Decimal.valueOf((respBean.GSB002O.GSB002O.GSB002O_TGE - respBean.GSB002O.GSB002O.GSB002O_TGBE));
                }

                aeTotGrLstIns.add(atg);
            }
        }

        try{
            if(aeTotGrLstIns.size() >= 1) {
                insert aeTotGrLstIns;
            }
        }
        catch(Exception ex) {
            throw new AuraException('Save Group Exposures failed: ' + ex.getMessage() + ' ' + ex.getStackTraceString());
        }
    }

    
    /**
    * @description :Future method to save group exposure aggregations
    * @author Thabo Senkomane | 2021-06-11 
    * @param OppID 
    **/
    @Future(callout=true)
    public static void getAndSaveGroupExposureAggregationsFuture(String OppID) {
        Application__c app = new ApplicationsSelector().selectByCreditOpportunityId(OppID);
        List<Application_Profile__c> appProfile = new ApplicationProfileSelector().getApplicationProfiles(app.Id);
        List<Application_Exposure_Total_Group__c> appExpTotList = new ApplicationsTotalGroupSelector().getApplicationTotalGroup(app.Id,'Total Group Exposure');

        if(!isNotNullOrEmpty(appExpTotList)) {
            List<Application_Profile__c> orderedAppProfiles = ExposureController.orderedProfilesList(appProfile,OppID);
            List<Application_Exposure_Total_Group__c> appAllExpTotList = new ApplicationsTotalGroupSelector().getAllApplicationsTotalGroup(app.Id);

            TotalGroupExposure_Resp_IB_v1 totGroupResponse = GetTotalGroupService(appAllExpTotList, orderedAppProfiles);

            Application_Exposure_Total_Group__c appGrpExp = new Application_Exposure_Total_Group__c();

            if(totGroupResponse != null) {
                appGrpExp.Application__c = app.Id;
                appGrpExp.Application_Total_Group__c = 'Total Group Exposure';
                appGrpExp.TGOE__c = Decimal.valueOf(totGroupResponse.totalGroupExposure.tgoe);
                appGrpExp.TGAE__c = Decimal.valueOf(totGroupResponse.totalGroupExposure.tgae);
                appGrpExp.TGE__c = Decimal.valueOf(totGroupResponse.totalGroupExposure.tge);
                appGrpExp.TGBE__c = Decimal.valueOf(totGroupResponse.totalGroupExposure.tgbe);
                appGrpExp.TGIE__c = Decimal.valueOf(totGroupResponse.totalGroupExposure.tgie);
            }

            try{
                insert appGrpExp;
            }
            catch(Exception ex) {
                throw new AuraException('Save Group Exposures Aggregation failed: ' + ex.getMessage() + ' ' + ex.getStackTraceString());
            }
        }
    }

    /**
    * @description :Method to get Group Exposures from service
    * @author Thabo Senkomane | 2021-06-11 
    * @param OppID 
    * @return Map<String, List<GroupExposures>> 
    **/
    @AuraEnabled
    public static Map<String,List<GroupExposures>> getGroupExposureFromService(String OppID) {
        Map<String,List<GroupExposures>> responseMap = new Map<String,List<GroupExposures>>();
        Application__c app = new ApplicationsSelector().selectByCreditOpportunityId(OppID);
        List<Application_Profile__c> appProfile = new ApplicationProfileSelector().getApplicationProfiles(app.Id);
        List<Application_Profile__c> orderedAppProfiles = ExposureController.orderedProfilesList(appProfile,OppID);
        List<Application_Exposure_Total_Group__c> aeTotGrLst = new ApplicationsTotalGroupSelector().getAllApplicationsTotalGroup(app.Id);
        List<GroupExposures> grpExpList = new List<GroupExposures>();

        String primaryClientCode;
        List<String> prevUltPriClientCodeList = new List<String>();

        if(isNotNullOrEmpty(aeTotGrLst)) {
            for(Application_Profile__c appProf : orderedAppProfiles) {
                for(Application_Exposure_Total_Group__c output: aeTotGrLst) {
                    if(appProf.Applicant_Type__c == 'Main Applicant') {
                        primaryClientCode = output.Primary_Client_of_Group__c;
                    }

                    if(output.Client_Code__c == appProf.Client_CIF_Code__c) {
                        String appType = appProf.Applicant_Type__c;
                        GroupExposures grpExp = new GroupExposures();

                        grpExp.ClientName = output.Client_Name__c;
                        grpExp.ClientCode = output.Client_Code__c;
                        grpExp.PrimaryClientCode = output.Primary_Client_of_Group__c;
                        grpExp.UltimatePrimaryClientCode = output.Ultimate_Primary_Client__c;
                        grpExp.OverallControlBranch = output.Overall_Control_Branch__c;
                        grpExp.ControlBranch = output.Control_Branch__c;
                        grpExp.TGOE = output.TGOE__c;
                        grpExp.TGAE = output.TGAE__c;
                        grpExp.TGE = output.TGE__c;
                        grpExp.TGBE = output.TGBE__c;
                        grpExp.TGIE = output.TGIE__c;
                        grpExp.IsFirstNameVis = ((appType == 'Main Applicant' || appType == 'Principal' || appType=='Spouse' ) ? true : false);  // added Spouse for w-12729
                        grpExpList.add(grpExp);
                        break;
                    }
                }
            }
        }

        responseMap.put('appGroupExposures', grpExpList);

        return responseMap;
    }

    /**
    * @description :Method to get group exposure record
    * @author Thabo Senkomane | 2021-06-11 
    * @param OppID 
    * @return String 
    **/
    @AuraEnabled
    public static String getGroupExposureRecord(String OppID) {
        Application__c app = new ApplicationsSelector().selectByCreditOpportunityId(OppID);
        List<Application_Exposure_Total_Group__c> appExpTotList = new ApplicationsTotalGroupSelector().getApplicationTotalGroup(app.Id,'Total Group Exposure');

        GroupExposures groupExp = new GroupExposures();

        if(isNotNullOrEmpty(appExpTotList)) {
            groupExp.TGOE = appExpTotList[0].TGOE__c;
            groupExp.TGAE = appExpTotList[0].TGAE__c;
            groupExp.TGE = appExpTotList[0].TGE__c;
            groupExp.TGBE = appExpTotList[0].TGBE__c;
            groupExp.TGIE = appExpTotList[0].TGIE__c;
        }

        return JSON.serialize(groupExp);
    }

    
      /**
      * @description :Future Method to get group exposures from service
      * @author Thabo Senkomane | 2021-06-11 
      * @param orderedAppProfiles 
      * @param appId 
      * @return Boolean 
      **/
      public static Boolean getInvokeGroupExposureFromServiceFuture(List<Application_Profile__c> orderedAppProfiles, Id appId) {
        String clientCode, clientName, applicantType;
        Map<String,String> mapClientDetails = new Map<String,String>();

        Integer countBatch = 0;
        for(Application_Profile__c appProf : orderedAppProfiles) {
            countBatch++;
            if(appProf.Applicant_Type__c == 'Main Applicant') {
                clientName = appProf.Client_Name__c;
            }

            if(appProf.Applicant_Type__c == 'Principal') {
                clientName = appProf.Client_Name__c;
            }
            if(appProf.Applicant_Type__c == 'Spouse') {
                clientName = appProf.Client_Name__c;
            }

            clientCode = appProf.Client_CIF_Code__c;
            applicantType = appProf.Applicant_Type__c;
            mapClientDetails.put(clientCode, clientName + ';' + applicantType);

            if(Math.mod(countBatch,2) == 0 && orderedAppProfiles.size() > 1) {
                getGroupExposureFromServiceFuture(mapClientDetails,appId);
                mapClientDetails.clear();
                countBatch = 0;
            }
        }

        if(Math.mod(countBatch,2) == 1 && orderedAppProfiles.size() > 1) {
            getGroupExposureFromServiceFuture(mapClientDetails,appId);
        }

        return true;
    }

    
    /**
    * @description :Method to get and save group exposures aggregations
    * @author Thabo Senkomane | 2021-06-11 
    * @param OppID 
    * @param appId 
    * @return Boolean 
    **/
    public static Boolean getAndSaveGroupExposureAggregations(Id OppID, Id appId){
        List<Application_Profile__c> appProfile = new ApplicationProfileSelector().getApplicationProfiles(appId);
        List<Application_Profile__c> orderedAppProfiles = ExposureController.orderedProfilesList(appProfile,OppID);
        List<Application_Exposure_Total_Group__c> appExpTotList = new ApplicationsTotalGroupSelector().getApplicationTotalGroup(appId,'Total Group Exposure');

        if(isNotNullOrEmpty(appExpTotList)) {
            return true;
        }
        else {
            Integer clientCodeCount = getClientCodeCount(appId);

            if(clientCodeCount == orderedAppProfiles.size()) {
                getAndSaveGroupExposureAggregationsFuture(OppID);
                return true;
            }
        }

        return false;
    }

    
    /**
    * @description :Method to check if the list is null or empty 
    * @author Thabo Senkomane | 2021-06-11 
    * @param objList 
    * @return Boolean 
    **/
    private static Boolean isNotNullOrEmpty(List<sObject> objList) {
        return objList != null && objList.size() > 0;
    }

    
    /**
    * @description :Method to get the client code count 
    * @author Thabo Senkomane | 2021-06-11 
    * @param appId 
    * @return Integer 
    **/
    private static Integer getClientCodeCount(Id appId) {
        List<Application_Exposure_Total_Group__c> appGrpExpList = new ApplicationsTotalGroupSelector().getAllApplicationsTotalGroup(appId);

        Integer clientCodes = 0;
        for(Application_Exposure_Total_Group__c appExp : appGrpExpList) {
            clientCodes++;
        }
        return clientCodes;
    }

    
    /**
    * @description :Method to get data from cms service 
    * @author Thabo Senkomane | 2021-06-11 
    * @param clientCode 
    * @return GBgetCmsCreditGroupsDetV1_Resp_IB_v1 
    **/
    public static GBgetCmsCreditGroupsDetV1_Resp_IB_v1 gbGetCmsCreditGroupsDetV1Service(String clientCode) {
        if(Test.isRunningTest()) {
            GBgetCmsCreditGroupsDetV1_IH_v1_Test.cmsCreditGroupTestMock();
        }

        GBgetCmsCreditGroupsDetV1_Resp_IB_v1 cmsResp  = GBgetCmsCreditGroupsDetV1_IH_v1.gbGetCmsCreditGroupsDetV1(clientCode);

        if(cmsResp?.statusCode == 200) {
            if(cmsResp?.GSB014O != null) {
                return cmsResp;
            }
        }

        return null;
    }

    /**
    * @description :Method to get data from control branch service
    * @author Thabo Senkomane | 2021-06-11 
    * @param clientCode 
    * @return GBGetContBranchDetV1_Resp_IB_v1 
    **/
    public static GBGetContBranchDetV1_Resp_IB_v1 gbGetContBranchDetV1Service(String clientCode) {
        if(Test.isRunningTest()) {
            GBGetContBranchDetV1_IH_v1_Test.gbGetContBranchTestMock();
        }

        GBGetContBranchDetV1_Resp_IB_v1 controlBranchResp = GBGetContBranchDetV1_IH_v1.GBGetContBranchDetV1(clientCode);

        if(controlBranchResp?.statusCode == 200) {
            if(controlBranchResp?.GSB021O != null) {
                return controlBranchResp;
            }
        }

        return null;
    }

    /**
    * @description :Method to get data from Totalgrouoexposureservice
    * @author Thabo Senkomane | 2021-06-11 
    * @param clientCode 
    * @return GBgetTotalGroupExposureV3_Resp_IB_v1 
    **/
    public static GBgetTotalGroupExposureV3_Resp_IB_v1 GBgetTotalGroupExposureV3Service(String clientCode) {
        if(Test.isRunningTest()) {
            GBgetTotalGroupExposureV3_IH_v1_Test.totalGroupTestMock();
        }

        GBgetTotalGroupExposureV3_Resp_IB_v1 respBean = GBgetTotalGroupExposureV3_IH_v1.GBgetTotalGroupExposureV3(clientCode);

        if(respBean?.statusCode == 200) {
            if(respBean?.GSB002O != null) {
                return respBean;
            }
        }

        return null;
    }

    
    /**
    * @description :Method to get total group service  
    * @author Thabo Senkomane | 2021-06-11 
    * @param appTotalGroup 
    * @param newAppProfList 
    * @return TotalGroupExposure_Resp_IB_v1 
    **/
    public static TotalGroupExposure_Resp_IB_v1 GetTotalGroupService(List<Application_Exposure_Total_Group__c> appTotalGroup, List<Application_Profile__c> newAppProfList) {
        if(Test.isRunningTest()) {
            TotalGroupExposure_IH_V1_Test.totalGroupTestMock();
        }

        TotalGroupExposure_Req_IB_v1 totRequestBean = TotalGroupExposure_IU_v1.mapRequestFields(appTotalGroup, newAppProfList);
        TotalGroupExposure_Resp_IB_v1 totGroupResponse = TotalGroupExposure_IH_v1.GetTotalGroup(totRequestBean);

        if(totGroupResponse?.statusCode == 200) {
            if(totGroupResponse?.totalGroupExposure != null) {
                return totGroupResponse;
            }
        }

        return null;
    }
}