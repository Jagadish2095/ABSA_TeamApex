/**
 * @description       : Controller class for ApplicationExposureRisk component
 * @author            : Himani Joshi
 * @last modified on  : 2021-06-11
 * @last modified by  : Himani Joshi
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   2021-06-07   Himani Joshi   Initial Version
**/

public class ApplicationExposuresRiskController {
 
    /**
    * @description : Future Method to get application exposures risk from service
    * @author Himani Joshi | 2021-06-07 
    * @param oppID 
    **/
    @Future(callout=true)
    public static void getApplicationRiskExposuresfromServiceFuture(Id oppID) {

        string clientCode;
        String clientName;
        boolean isExisting=false;
        GetTriads_Resp_IB_v1 response=new GetTriads_Resp_IB_v1();
        GetTriads_Req_IB_v1 requestBean = new GetTriads_Req_IB_v1();
        List<Application_Exposure_Risk__c> appExposureRisks=new List<Application_Exposure_Risk__c> ();
        Application__c application = new ApplicationsSelector().selectByCreditOpportunityId(oppID);
        Account account = new AccountsSelector().selectIndvByOpportunityIdNew(oppID);
        List<Application_Principal__c> appPrinList =new ApplicationPrincipalsSelector().getApplicationPrincipals(application.Id);
        GetClientDetails_Resp_IB_v1 responseBean1;
        GetExposures_Resp_IB_v1 responseBean2 = new GetExposures_Resp_IB_v1();
        list<Application_Profile__c> appProfile = new ApplicationProfileSelector().getApplicationProfiles(application.Id);
        list<Application_Profile__c> newList = returnnewApplicationProfile(appProfile,account.Registration_Number__c,appPrinList,application.Id);
        List<Application_Exposure_Risk__c> appRisks = new ApplicationExposureRiskSelector().getAllApplicationExposureRisk(application.Id);
        
        for(Application_Profile__c app1:newList) {
            clientCode=app1.Client_CIF_Code__c;

            for(Application_Exposure_Risk__c expRisk:appRisks){
                if(expRisk.client_code__c == clientCode){
                    isExisting=true;
                    break;
                }
            }

            if(!isExisting && clientCode != null) {
                response=GetTriads_IH_v1.GetTriads(clientCode);
                GetTriads_Resp_IB_v1.TRC519O_COND_ACCOUNT_DETAILS getRiskGrades=response.TRC519O.TRC519O_OUTPUT_DATA.TRC519O_COND_ACCOUNT_DETAILS[0];

                Application_Exposure_Risk__c app=new Application_Exposure_Risk__c();
                app.Application__c=application.Id;
                app.Client_Code__c=clientCode;
                app.Risk_Grade__c=string.valueof(getRiskGrades.TRC519O_COND_CLNT_RISK_GRADE);
                app.Client_Name__c=app1.Client_Name__c;
                appExposureRisks.add(app);
            }
        }

        try {
            insert appExposureRisks;
        } catch(DmlException e) {
            System.debug(e);
        }
    }

    
    /**
    * @description : Method to call future method getApplicationRiskExposuresfromServiceFuture 
    * @author Himani Joshi | 2021-06-07 
    * @param oppID 
    * @return Map<string, String> 
    **/
    @AuraEnabled
    public static Map<string,String> getApplicationRiskExposuresfromService(Id oppID) {
        getApplicationRiskExposuresfromServiceFuture(oppID);
        return (new Map<String,String>{'Status' => 'getApplicationRiskExposuresFromService Evoked'});
    }

    /**
    * @description : Method to get worst risk grade
    * @author Himani Joshi | 2021-06-07 
    * @param oppID 
    * @return Map<String, List<sobject>> 
    **/
    @AuraEnabled
    public static Map<String,List<sobject>> getWorstRiskGrade(Id oppID){
        List<Application_Exposure_Risk__c> exposureRisk=new List<Application_Exposure_Risk__c>();
        List<Application_Exposure_Risk__c> updatedExposureRisk=new List<Application_Exposure_Risk__c>();
        Application__c application=new ApplicationsSelector().selectByCreditOpportunityId(oppID);
        Account account = new AccountsSelector().selectIndvByOpportunityIdNew(oppID);
        List<Application_Principal__c> appPrinList =new ApplicationPrincipalsSelector().getApplicationPrincipals(application.Id);
        Map<string,List<sobject>>responseMap=new Map<string,List<sobject>>();
        list<Application_Profile__c> appProfile=new ApplicationProfileSelector().getApplicationProfiles(application.Id);
        Set<String>getAssociatedProfiles=new Set<String>();
        string highestRiskGrade;
        List<Application_Profile__c> newList=returnnewApplicationProfile(appProfile,account.Registration_Number__c,appPrinList,application.Id);
        List<Application_Profile__c> profilesList = new ApplicationProfileSelector().getApplicationProfilesByRelatedClientCode(account.Registration_Number__c,application.Id);

        for(Application_Profile__c app:profilesList){
            if(app.client_cif_code__c != null){
              getAssociatedProfiles.add(app.client_cif_code__c);  
            }
        }

        exposureRisk=new ApplicationExposureRiskSelector().orderByRiskGrade(application.Id,getAssociatedProfiles);

        if(exposureRisk.size()>0){
           highestRiskGrade=exposureRisk[0].Risk_Grade__c; 

            for(Application_Exposure_Risk__c app:exposureRisk){
                if(highestRiskGrade=='0'){
                    app.Worst_Risk_Grade__c='0';
                } else if(highestRiskGrade==null){
                    app.Worst_Risk_Grade__c='5';
                } else if(highestRiskGrade=='1'){
                    app.Worst_Risk_Grade__c='1';
                } else if(highestRiskGrade=='2'){
                    app.Worst_Risk_Grade__c='2';
                } else if(highestRiskGrade=='3'){
                    app.Worst_Risk_Grade__c='3';
                } else if(highestRiskGrade=='4'){
                    app.Worst_Risk_Grade__c='4';
                } else if(highestRiskGrade=='5'){
                    app.Worst_Risk_Grade__c='5';
                }

                updatedExposureRisk.add(app);
            }
        }

        List<Application_Principal__c>newAppPrincipals1=new List<Application_Principal__c>();
        List<Application_Principal__c>newAppPrincipals2=new List<Application_Principal__c>();
        
        for(Application_Principal__c prin:appPrinList){
            if(prin.main__c==true && prin.CIF__c != null){
                newAppPrincipals1.add(prin);
            } else if(prin.CIF__c != null){
                newAppPrincipals2.add(prin);
            }
        }

        Set<String>getAssociatedPrincipals=new Set<String>();
        Set<String> idNos = new Set<String>();

        for(Application_Principal__c prin:newAppPrincipals1) {
            getAssociatedPrincipals.add(prin.CIF__c);
            idNos.add(prin.Id_Number__c);
        }

        List<Application_Profile__c> associatedPrincipals =new ApplicationProfileSelector().getLinkedPrincipals(idNos,'',application.Id);

        for(Application_Profile__c prof:associatedPrincipals){
            if(prof.Client_CIF_Code__c != null){
            getAssociatedPrincipals.add(prof.Client_CIF_Code__c);
            }
        }

        exposureRisk=new ApplicationExposureRiskSelector().orderByRiskGrade(application.Id,getAssociatedPrincipals);

        if(exposureRisk.size()>0){
            highestRiskGrade=exposureRisk[0].Risk_Grade__c;

            for(Application_Exposure_Risk__c app:exposureRisk) {
                if(highestRiskGrade=='0'){
                    app.Worst_Risk_Grade__c='0';
                } else if(highestRiskGrade==null){
                    app.Worst_Risk_Grade__c='5';
                } else if(highestRiskGrade=='1'){
                    app.Worst_Risk_Grade__c='1';
                } else if(highestRiskGrade=='2'){
                    app.Worst_Risk_Grade__c='2';
                } else if(highestRiskGrade=='3'){
                    app.Worst_Risk_Grade__c='3';
                } else if(highestRiskGrade=='4'){
                    app.Worst_Risk_Grade__c='4';
                } else if(highestRiskGrade=='5'){
                    app.Worst_Risk_Grade__c='5';
                }
                updatedExposureRisk.add(app);
            }
        }

        getAssociatedPrincipals=new Set<String>();
        idNos = new Set<String>();

        for(Application_Principal__c prin:newAppPrincipals2) {
            if(prin.CIF__c!=null){
            getAssociatedPrincipals.add(prin.CIF__c);
            idNos.add(prin.Id_Number__c);
        }
        }
        associatedPrincipals =new ApplicationProfileSelector().getLinkedPrincipals(idNos,'',application.Id);

        for(Application_Profile__c prof:associatedPrincipals){
            if(prof.Client_CIF_Code__c != null){
            getAssociatedPrincipals.add(prof.Client_CIF_Code__c);
        }
        }
        exposureRisk=new ApplicationExposureRiskSelector().orderByRiskGrade(application.Id,getAssociatedPrincipals);

        if(exposureRisk.size()>0){
            highestRiskGrade=exposureRisk[0].Risk_Grade__c;

            for(Application_Exposure_Risk__c app:exposureRisk) {
                if(highestRiskGrade=='0'){
                    app.Worst_Risk_Grade__c='0';
                } else if(highestRiskGrade==null){
                    app.Worst_Risk_Grade__c='5';
                } else if(highestRiskGrade=='1'){
                    app.Worst_Risk_Grade__c='1';
                } else if(highestRiskGrade=='2'){
                    app.Worst_Risk_Grade__c='2';
                } else if(highestRiskGrade=='3'){
                    app.Worst_Risk_Grade__c='3';
                } else if(highestRiskGrade=='4'){
                    app.Worst_Risk_Grade__c='4';
                } else if(highestRiskGrade=='5'){
                    app.Worst_Risk_Grade__c='5';
                }

                updatedExposureRisk.add(app);
            }
        }

        try {
            map<id,Application_Exposure_Risk__c> appExpRskMap = new map<id,Application_Exposure_Risk__c>();
            appExpRskMap.putall(updatedExposureRisk);
            update appExpRskMap.values();
        } catch(DmlException e) {
            throw new AuraHandledException(String.valueOf(e));
        }
        
        responseMap.put('appRisk',updatedExposureRisk);
        responseMap.put('appProfile',newList);
        return responseMap;
    }

    /**
    * @description : Method to get ordered application profiles
    * @author Himani Joshi | 2021-06-07 
    * @param appProfile 
    * @param RegNo 
    * @param appPrincipals 
    * @param appId 
    * @return List<Application_Profile__c> 
    **/
    @AuraEnabled
    public static List<Application_Profile__c>  returnnewApplicationProfile(List<Application_Profile__c> appProfile,String RegNo, List<Application_Principal__c> appPrincipals, Id appId) {
        List<Application_Profile__c> newList=new List<Application_Profile__c> ();
        List<Application_Profile__c> newMainAssoClientCodesList=new List<Application_Profile__c>();
        List<Application_Profile__c> newPrincipalsList=new List<Application_Profile__c>();
        List<Application_Profile__c> newPrinAssoClientCodesList=new List<Application_Profile__c>();
        List<Application_Principal__c>newAppPrincipals1=new List<Application_Principal__c>();
        List<Application_Principal__c>newAppPrincipals2=new List<Application_Principal__c>();

        for(Application_Principal__c prin:appPrincipals){
            if(prin.main__c==true && prin.CIF__c != null){
                newAppPrincipals1.add(prin);
            } else if(prin.CIF__c != null){
                newAppPrincipals2.add(prin);
            }
        }

        for(Application_Profile__c appProf:appProfile) {
            if(appProf.Applicant_Type__c == 'Main Applicant' && appProf.client_cif_code__c != null) {
                newList.add(appProf);
            }

            Application_Profile__c prof;
            
            if(appProf.client_cif_code__c != null && appProf.Related_to_Client_ID_or_Reg_Number__c == RegNo && appProf.Applicant_Type__c == null) {
                prof = new Application_Profile__c();
                prof.client_cif_code__c = appProf.client_cif_code__c;
                prof.Client_Name__c = appProf.Client_Name__c;
                newMainAssoClientCodesList.add(prof);
            }
        }

        for(Application_Profile__c appProf:appProfile){
            if(appProf.client_cif_code__c != null)
            {
            Application_Profile__c prof;
            for(Application_Principal__c appPrin :newAppPrincipals1) {
                if(appProf.client_cif_code__c == appPrin.CIF__c) {
                    prof = new Application_Profile__c();
                    prof.Related_to_Client_ID_or_Reg_Number__c = appPrin.Id_Number__c;
                    prof.client_cif_code__c = appProf.client_cif_code__c;
                    prof.Client_Name__c = appProf.Client_Name__c;
                    newPrincipalsList.add(prof);
                }

                if(appProf.Related_to_Client_ID_or_Reg_Number__c == appPrin.Id_Number__c && appProf.Applicant_Type__c == null) {
                    prof = new Application_Profile__c();
                    prof.Related_to_Client_ID_or_Reg_Number__c = appProf.Related_to_Client_ID_or_Reg_Number__c;
                    prof.client_cif_code__c = appProf.client_cif_code__c;
                    prof.Client_Name__c = appProf.Client_Name__c;
                    newPrinAssoClientCodesList.add(prof);
                }
            }
        }
        }

        for(Application_Profile__c appProf:appProfile){
            if(appProf.client_cif_code__c != null)
            {
            Application_Profile__c prof;

            for(Application_Principal__c appPrin :newAppPrincipals2) {
                if(appProf.client_cif_code__c == appPrin.CIF__c) {
                    prof = new Application_Profile__c();
                    prof.Related_to_Client_ID_or_Reg_Number__c	 = appPrin.Id_Number__c;
                    prof.client_cif_code__c = appProf.client_cif_code__c;
                    prof.Client_Name__c = appProf.Client_Name__c;
                    newPrincipalsList.add(prof);
                }

                if(appProf.Related_to_Client_ID_or_Reg_Number__c == appPrin.Id_Number__c && appProf.Applicant_Type__c == null) {
                    prof = new Application_Profile__c();
                    prof.Related_to_Client_ID_or_Reg_Number__c	 = appProf.Related_to_Client_ID_or_Reg_Number__c;
                    prof.client_cif_code__c = appProf.client_cif_code__c;
                    prof.Client_Name__c = appProf.Client_Name__c;
                    newPrinAssoClientCodesList.add(prof);
                }
            }
        }
        }
        //add Associated Clients to Main Client
        for(Application_Profile__c appR:newMainAssoClientCodesList){
            newList.add(appR);
        }

        //add Principals
        for(Application_Profile__c appPrinProf: newPrincipalsList) {
            newList.add(appPrinProf);

            for(Application_Profile__c appProf: newPrinAssoClientCodesList) {
                if(appPrinProf.Related_to_Client_ID_or_Reg_Number__c == appProf.Related_to_Client_ID_or_Reg_Number__c && appProf.Applicant_Type__c == null) {
                    newList.add(appProf);
                }
            }
        }

        return newList;
    }
}