/**
 * @description       : Integration Utility for TotalGroupExposure Service
 * @author            : Thabo Senkomane
 * @last modified on  : 2021-06-11
 * @last modified by  : Thabo Senkomane
 * Modifications Log 
 * Ver   Date         Author            Modification
 * 1.0   2021-06-11   Thabo Senkomane   Initial Version
**/

public class TotalGroupExposure_IU_v1 {
    /**
    * @description :Method to map request fields
    * @author Thabo Senkomane | 2021-06-11 
    * @param appTotalGroup 
    * @param newAppProfList 
    * @return TotalGroupExposure_Req_IB_v1 
    **/
    public static TotalGroupExposure_Req_IB_v1 mapRequestFields(List<Application_Exposure_Total_Group__c> appTotalGroup, List<Application_Profile__c> newAppProfList) {
        TotalGroupExposure_Req_IB_v1 requestBean = new TotalGroupExposure_Req_IB_v1();
        requestBean.clientProfile = new List<TotalGroupExposure_Req_IB_v1.ClientProfile>();
        TotalGroupExposure_Req_IB_v1.ClientProfile tgeValues;

        String primaryClientCode;
        List<String> prevUltPriClientCodeList = new List<String>();
        string relatedToClientIdOrReg;
        for(Application_Profile__c appProfile : newAppProfList) {
            system.debug('appProfile'+appProfile);
            if(appProfile.Applicant_Type__c=='Spouse'){
            relatedToClientIdOrReg=appProfile.Related_to_Client_Id_Or_Reg_Number__c;
            }
            system.debug('relatedToClientIdOrReg'+relatedToClientIdOrReg);
            for(Application_Exposure_Total_Group__c appTotGrp : appTotalGroup) {
                if(appProfile.Applicant_Type__c == 'Main Applicant') {
                    primaryClientCode = appTotGrp.Primary_Client_of_Group__c;
                }

                if(appTotGrp.Client_Code__c == appProfile.Client_CIF_Code__c && appProfile.Applicant_Type__c!='Spouse') {
                    if(appProfile.Related_to_Client_Id_Or_Reg_Number__c!=relatedToClientIdOrReg){
                    system.debug('appProfile.Client_CIF_Code__c'+appProfile.Client_CIF_Code__c);
                    tgeValues = new TotalGroupExposure_Req_IB_v1.ClientProfile();
                    tgeValues.clientCode = appTotGrp.Client_Code__c;
                    tgeValues.primaryClientCode = appTotGrp.Primary_Client_of_Group__c;
                    tgeValues.tgae = appTotGrp.TGAE__c;
                    tgeValues.tgbe = appTotGrp.TGBE__c;
                    tgeValues.tge = appTotGrp.TGE__c;
                    tgeValues.tgie = appTotGrp.TGIE__c;
                    tgeValues.tgoe = appTotGrp.TGOE__c;
                    tgeValues.ultimatePrimaryClientCode = appTotGrp.Ultimate_Primary_Client__c;

                    if(((primaryClientCode != appTotGrp.Ultimate_Primary_Client__c || primaryClientCode == appTotGrp.Ultimate_Primary_Client__c)
                        && !prevUltPriClientCodeList.contains(tgeValues.primaryClientCode))
                        || (primaryClientCode == null && tgeValues.primaryClientCode == null && tgeValues.primaryClientCode == null)) {
                        requestBean.clientProfile.add(tgeValues);

                        if(tgeValues.primaryClientCode != null) {
                            prevUltPriClientCodeList.add(tgeValues.primaryClientCode);
                        }
                    }
                    break;
                }
                }
            }
        }
        return requestBean;
    }
}