/**
 * @description       : Controller class for ApplicantExposures component
 * @author            : Himani Joshi
 * @last modified on  : 06-24-2021
 * @last modified by  : englarmerdge.mongwe@absa.africa
 * Modifications Log
 * Ver   Date         Author         Modification
 * 1.0   2021-06-09   Himani Joshi   Initial Version
**/
public class ApplicationExposuresController {
    /**
     * @description : Method to get application exposures
     * @author Himani Joshi | 2021-06-09
     * @param oppID
     * @return Map<String, List<SObject>>
    **/
    @AuraEnabled
    public static Map<String,List<SObject>> getApplicationExposures(String oppID) {
        Map<String,List<SObject>> responseMap = new Map<String,List<SObject>>();
        Application__c application = new ApplicationsSelector().selectByCreditOpportunityId(oppID);
        Account account = new AccountsSelector().selectIndvByOpportunityIdNew(oppID);

        List<Application_Profile__c> appProfile = new ApplicationProfileSelector().getApplicationProfiles(application.Id);
        List<Application_Profile__c> newAppProfList = ExposureController.orderedProfilesList(appProfile,oppID);
        List<Application_Exposure__c> appExp1 = [select client_code__c,client_name__c,Arrears__c,Application__c,Excess__c,Exposure__c,Exposure_Data_Type__c,Installment__c,Liability__c,Limit__c,Product__c from Application_Exposure__c where application__c=:application.Id and Exposure_Data_Type__c='Product'];
         List<Application_Exposure__c> appExp2 = [select client_code__c,client_name__c,Arrears__c,Application__c,Excess__c,Exposure__c,Exposure_Data_Type__c,Installment__c,Liability__c,Limit__c,Product__c from Application_Exposure__c where application__c=:application.Id and Exposure_Data_Type__c='Client Profile Product Total'];
        List<Application_Exposure__c> applicationExposures = new list<Application_Exposure__c>();
         Double totalarr=0.0;
         Double totallmt=0.0;
         Double totalexcess=0.0;

        for(Application_profile__c exp : newAppProfList){
            //List<Application_Exposure__c> appExp1 = [select client_code__c,client_name__c,Arrears__c,Application__c,Excess__c,Exposure__c,Exposure_Data_Type__c,Installment__c,Liability__c,Limit__c,Product__c from Application_Exposure__c where application__c=:application.Id and Exposure_Data_Type__c='Product' and client_code__c=:exp.Client_CIF_Code__c];
              totalarr=0.0;
              totallmt=0.0;
              totalexcess=0.0;


            for(Application_Exposure__c fin : appExp1){
                if(fin.client_code__c==exp.Client_CIF_Code__c){
                applicationExposures.add(fin);
                totalarr=totalarr+double.valueOf(fin.Arrears__c);
                totallmt=totallmt+double.valueOf(fin.Limit__c);
                totalexcess=totalexcess+ double.valueOf(fin.Excess__c);
                }
            }

            //List<Application_Exposure__c> appExp2 = [select client_code__c,client_name__c,Arrears__c,Application__c,Excess__c,Exposure__c,Exposure_Data_Type__c,Installment__c,Liability__c,Limit__c,Product__c from Application_Exposure__c where application__c=:application.Id and Exposure_Data_Type__c='Client Profile Product Total' and client_code__c=:exp.Client_CIF_Code__c];

            for(Application_Exposure__c fin1 : appExp2){
                if(fin1.client_code__c==exp.Client_CIF_Code__c){
                fin1.Arrears__c=string.valueOf(totalarr);
                fin1.Excess__c=string.valueOf(totalexcess);
                fin1.Limit__c=string.valueOf(totallmt);
                applicationExposures.add(fin1);
                }
            }
        }

        if((applicationExposures != null && applicationExposures.size() > 0) && (newAppProfList != null && newAppProfList.size() > 0)){
            responseMap.put('applicationExposures', applicationExposures);
            responseMap.put('clientCodesandNames', newAppProfList);
        }

        return responseMap;
    }
}