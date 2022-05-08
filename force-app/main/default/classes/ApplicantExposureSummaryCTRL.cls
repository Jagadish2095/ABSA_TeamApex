/**
 * @description       : Controller class for ApplicantExposureSummary component
 * @author            : Ketelo
 * @last modified on  : 2021-06-11
 **/

public class ApplicantExposureSummaryCTRL {

    /**
    * @description : Method to get application exposure summary
    * @author Ketelo | 2021-06-10 
    * @param opportunityId 
    * @return List<Map<String, Object>> 
    **/
    @AuraEnabled
    public static List<Map<String,Object>> getApplicationExposureSummary(Id opportunityId){
        String condition = 'Application__c =:applicationId AND Exposure_Data_Type_Order__c < 999';
        List<Map<String,Object>> appClientExpFacilities = new List<Map<String,Object>>();

        Application__c application = new ApplicationsSelector().selectByCreditOpportunityId(opportunityId);
        List<Application_Exposure__c> applicationExposures = new ApplicationExposureSelector().getAllApplicationExposureSummary(application.id);
        if(applicationExposures.size() > 0) {
            Boolean hasExposureRecords = false;

            for(Application_Exposure__c applicationExposure : applicationExposures){
                if(applicationExposure.Exposure_Data_Type__c == StringConstants.APPLICATION_EXPOSURE_EXPOSURE_DATA_TYPE_ORDINARY_CREDIT_TOTAL){
                    hasExposureRecords = true;
                }
            }

            if(!hasExposureRecords){
                applicationExposures = new ApplicationExposureSelector().getAllApplicationExposureSummary(application.id);
            }
            List<Application_Profile__c> appProfileList = new ApplicationProfileSelector().getApplicationProfiles(application.Id);
            List<Application_Profile__c> newOrdProList = ExposureController.orderedProfilesList(appProfileList, opportunityId);
            for(Application_Profile__c appProfile : newOrdProList) {

                for(Application_Exposure__c applicationExposure : applicationExposures) {
                    if(applicationExposure.Exposure_Data_Type_Order__c != 0 && appProfile.Client_CIF_Code__c == applicationExposure.Client_Code__c){
                        Map<String,String> mapObj = new Map<String,String>();
                        mapObj.put('clientName',appProfile.Client_Name__c);
                        mapObj.put('clientCode', appProfile.Client_CIF_Code__c);
                        mapObj.put('product', applicationExposure.Exposure_Data_Type__c);
                        mapObj.put('liability', (applicationExposure.Liability__c == null ? '0.00' : applicationExposure.Liability__c));
                        mapObj.put('exposure', (applicationExposure.Exposure__c == null ? '0.00' : applicationExposure.Exposure__c));
                        mapObj.put('limit', (applicationExposure.Limit__c == null ? '0.00' : applicationExposure.Limit__c));
                        mapObj.put('arrears', (applicationExposure.Arrears__c == null ? '0.00' : applicationExposure.Arrears__c));
                        mapObj.put('excess', (applicationExposure.Excess__c == null ? '0.00' : applicationExposure.Excess__c));
                        mapObj.put('installment', (applicationExposure.Installment__c == null ? '0.00' : applicationExposure.Installment__c));
                        mapObj.put('Id', applicationExposure.Id);
                        mapObj.put('lastUpdatedDate', String.valueOf(applicationExposure.LastModifiedDate));
                        appClientExpFacilities.add(mapObj);
                    }
                }
            }
        }
        return appClientExpFacilities;
    }

    
}