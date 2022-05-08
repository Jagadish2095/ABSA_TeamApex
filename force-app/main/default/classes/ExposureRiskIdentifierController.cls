/**
 * @description       : Controller class for lightning component ApplicantExposureRiskIdentifier
 * @author            : Himani Joshi
 * @last modified on  : 2021-07-07
 * @last modified by  : Himani Joshi
 * Modifications Log 
 * Ver   Date         Author         Modification
 * 1.0   2021-07-07   Himani Joshi   Initial Version
**/

public class ExposureRiskIdentifierController {
    /**
    * @description : Method to get the risk identifiers
    * @author Himani Joshi | 2021-07-07 
    * @param oppID 
    **/
    @Future(callout=true)
    public static void getApplicationRiskIdentifiersfromServiceFuture(Id oppID){
        GetClientDetails_Resp_IB_v1 responseBean1;
        GetExposures_Resp_IB_v1 responseBean2 = new GetExposures_Resp_IB_v1();
        Application__c application=new ApplicationsSelector().selectByCreditOpportunityId(oppID);
        List<Application_Exposure_Risk__c> appRisk1=new ApplicationExposureRiskSelector().getAllApplicationExposureRisk(application.Id);
        List<Application_Exposure_Risk__c>updateexposureRisk=new List<Application_Exposure_Risk__c>();
        Account account = new AccountsSelector().selectIndvByOpportunityIdNew(oppID);
        for(Application_Exposure_Risk__c app:appRisk1){
            responseBean1=GetClientDetails_IH_v1.getClientDetails(app.client_code__c,'0', account.Sic);
            responseBean2=GetExposures_IH_v1.GetExposures(app.client_code__c);
            app.In_Business_Rescue__c=responseBean1.inBusinessRescue;
            app.Business_Rescue_Affected_Party__c=responseBean1.ibrAffected;
            app.In_Liquidation__c=responseBean1.insolventIndicator;
            app.Forensic_Fraud_Indicator__c=responseBean1.forensicHold;
            app.Worst_Collection_Risk_Type__c=responseBean2.GSB001O.GSB001O.GSB001O_OUTPUT_FIELDS.worstArmsRisk;
            app.Worst_Arms_Hold_Code__c=responseBean2.GSB001O.GSB001O.GSB001O_OUTPUT_FIELDS.worstArmsHold;
            app.Early_Warning_Listing__c=responseBean2.GSB001O.GSB001O.GSB001O_OUTPUT_FIELDS.armsEwlStatus;
            app.Risk_Identifier__c=true;
            updateexposureRisk.add(app);
        }
        try{
        update updateexposureRisk;
        }
        catch(Exception e)
        {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
        
    }
    /**
    * @description : Method to call getApplicationRiskIdentifiersfromServiceFuture method
    * @author Himani Joshi | 2021-07-07 
    * @param oppID 
    * @return Map<String, String> 
    **/
    @AuraEnabled
    public static Map<String,String> getApplicationRiskIdentifiersfromService(Id oppID) {
        getApplicationRiskIdentifiersfromServiceFuture(oppID);
        return (new Map<String,String>{'Status' => 'getApplicationRiskExposuresFromService Evoked'});
        
    }
    
    /**
    * @description : Method to get worst risk identifier
    * @author Himani Joshi | 2021-07-07 
    * @param oppID 
    * @return Map<String, List<sobject>> 
    **/
    @AuraEnabled
    public static Map<String,List<sobject>> getWorstRiskIdentifier(Id oppID){
        Application__c application=new ApplicationsSelector().selectByCreditOpportunityId(oppID);
        Map<string,List<sobject>>responseMap=new Map<string,List<sobject>>();
        Account account = new AccountsSelector().selectIndvByOpportunityIdNew(oppID);
        List<Application_Exposure_Risk__c> updatedExposureRisk=new List<Application_Exposure_Risk__c>();
        List<Application_Exposure_Risk__c> updatedExposureHold=new List<Application_Exposure_Risk__c>();
        List<Application_Exposure_Risk__c> updatedExposureCollectionRisk=new List<Application_Exposure_Risk__c>();
        List<Application_Exposure_Risk__c>exposureRiskApplicant=new List<Application_Exposure_Risk__c>();
        List<Application_Exposure_Risk__c>exposureRiskMainPrincipal=new List<Application_Exposure_Risk__c>();
        List<Application_Exposure_Risk__c>exposureRiskLinkedPrincipals=new List<Application_Exposure_Risk__c>();
        List<Application_Exposure_Risk__c>exposureHoldApplicant=new List<Application_Exposure_Risk__c>();
        List<Application_Exposure_Risk__c>exposureHoldMainPrincipal=new List<Application_Exposure_Risk__c>();
        List<Application_Exposure_Risk__c>exposureHoldLinkedPrincipals=new List<Application_Exposure_Risk__c>();
        List<Application_Exposure_Risk__c>exposureCollectionApplicant=new List<Application_Exposure_Risk__c>();
        List<Application_Exposure_Risk__c>exposureCollectionMainPrincipal=new List<Application_Exposure_Risk__c>();
        List<Application_Exposure_Risk__c>exposureCollectionLinkedPrincipals=new List<Application_Exposure_Risk__c>();
        List<Application_Principal__c> appPrinList =new ApplicationPrincipalsSelector().getApplicationPrincipals(application.Id);
        set<String>getAssociatedProfiles=new Set<String>();
        List<Application_Profile__c> newList=new List<Application_Profile__c>();
        List<Application_Exposure_Risk__c> appRisk=new ApplicationExposureRiskSelector().getAllApplicationExposureRisk(application.Id);
        List<Worst_Risk_Indicator__mdt>worstRisk=new WorstRiskSelector().getSequenceNumber();
        List<Application_Profile__c> profilesList =new List<Application_Profile__c>();
        profilesList = new ApplicationProfileSelector().getApplicationProfilesByRelatedClientCode(account.Registration_Number__c,application.Id);
        for(Application_Profile__c app:profilesList){
            getAssociatedProfiles.add(app.client_cif_code__c);
        }
        list<Application_Profile__c> appProfile=new ApplicationProfileSelector().getApplicationProfiles(application.Id);
        newList=ApplicationExposuresRiskController.returnnewApplicationProfile(appProfile,account.Registration_Number__c,appPrinList,application.Id);
        Map<String,String>metadataMap=new Map<String,String>();
        for(Application_Exposure_Risk__c app:appRisk)
        {           
            for(Worst_Risk_Indicator__mdt mdt:worstRisk){
                if(app.Early_Warning_Listing__c == mdt.Early_warning_Listing__c && mdt.Type__c=='Worst Risk PCO'){
                    app.SequenceNumber__c=mdt.Sequence_Number__c;
                    
                }
                if(app.Worst_Arms_Hold_Code__c==mdt.Worst_Risk_Hold_Code__c && mdt.Type__c=='Worst Hold Code'){
                    app.SeqNoWorstHoldCode__c=mdt.Sequence_Number__c;
                }
                if(app.Worst_Collection_Risk_Type__c==mdt.WorstColRiskType__c && mdt.Type__c=='Worst Collection Risk Type'){
                    app.SeqNoWorstColType__c=mdt.Sequence_Number__c;
                }
                if(app.Early_Warning_Listing__c==null || app.Early_Warning_Listing__c==''){ 
                    app.SequenceNumber__c='0';
                    
                }
                if(app.Worst_Arms_Hold_Code__c==null || app.Worst_Arms_Hold_Code__c==''){
                     app.SeqNoWorstHoldCode__c='0';  
                }
                if(app.Worst_Collection_Risk_Type__c==null || app.Worst_Collection_Risk_Type__c==''){
                     app.SeqNoWorstColType__c='0';  
                }
                
            }
        }
        try{
        update appRisk;
        }
        catch(Exception e)
        {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
        exposureRiskApplicant=new ApplicationExposureRiskSelector().orderBySequenceNumber(application.Id,getAssociatedProfiles);
        for(Application_Exposure_Risk__c fin:exposureRiskApplicant)
        {
            fin.Worst_risk_PCO__c=exposureRiskApplicant[0].Early_Warning_Listing__c;
            updatedExposureRisk.add(fin);
        }
        exposureHoldApplicant=new ApplicationExposureRiskSelector().orderByWorstHoldSeqNo(application.Id,getAssociatedProfiles);
        system.debug('exposureHoldApplicant'+json.serializePretty(exposureHoldApplicant));
        for(Application_Exposure_Risk__c fin:exposureHoldApplicant)
        {
            fin.Worst_Risk_Hold__c=exposureHoldApplicant[0].Worst_Arms_Hold_Code__c;
            updatedExposureHold.add(fin);
        }
        exposureCollectionApplicant=new ApplicationExposureRiskSelector().orderByWorstCollectionSeqNo(application.Id,getAssociatedProfiles);
        for(Application_Exposure_Risk__c fin:exposureCollectionApplicant)
        {
            fin.Worst_Risk_Collection__c=exposureCollectionApplicant[0].Worst_Collection_Risk_Type__c;
            updatedExposureCollectionRisk.add(fin);
        }
        
        List<Application_Principal__c>newAppPrincipals1=new List<Application_Principal__c>();
        List<Application_Principal__c>newAppPrincipals2=new List<Application_Principal__c>();
        for(Application_Principal__c prin:appPrinList){
            if(prin.main__c==true){
                newAppPrincipals1.add(prin);
            }
            else{
                newAppPrincipals2.add(prin);
            }
        }
        for(Application_Principal__c prin:newAppPrincipals1)
        {
            Set<String>getAssociatedPrincipals=new Set<String>();
            getAssociatedPrincipals.add(prin.CIF__c);
            List<Application_Profile__c> associatedPrincipals =new ApplicationProfileSelector().getLinkedPrincipals(prin.Id_Number__c,'',application.Id);
            for(Application_Profile__c prof:associatedPrincipals){
                getAssociatedPrincipals.add(prof.Client_CIF_Code__c);
            }
            exposureRiskMainPrincipal=new ApplicationExposureRiskSelector().orderBySequenceNumber(application.Id,getAssociatedPrincipals);
            for(Application_Exposure_Risk__c fin:exposureRiskMainPrincipal)
            {
                fin.Worst_risk_PCO__c=exposureRiskMainPrincipal[0].Early_Warning_Listing__c;
                updatedExposureRisk.add(fin);
            }
            exposureHoldMainPrincipal=new ApplicationExposureRiskSelector().orderByWorstHoldSeqNo(application.Id,getAssociatedPrincipals);
            for(Application_Exposure_Risk__c fin:exposureHoldMainPrincipal)
            {
                fin.Worst_Risk_Hold__c=exposureHoldMainPrincipal[0].Worst_Arms_Hold_Code__c;
                updatedExposureHold.add(fin);
            }
            exposureCollectionMainPrincipal=new ApplicationExposureRiskSelector().orderByWorstCollectionSeqNo(application.Id,getAssociatedPrincipals);
            for(Application_Exposure_Risk__c fin:exposureCollectionMainPrincipal)
            {
                fin.Worst_Risk_Collection__c=exposureCollectionMainPrincipal[0].Worst_Collection_Risk_Type__c;
                updatedExposureCollectionRisk.add(fin);
            }
        }
        for(Application_Principal__c prin:newAppPrincipals2)
        {
            Set<String>getAssociatedPrincipals=new Set<String>();
            getAssociatedPrincipals.add(prin.CIF__c);
            List<Application_Profile__c> associatedPrincipals =new ApplicationProfileSelector().getLinkedPrincipals(prin.Id_Number__c,'',application.Id);
            for(Application_Profile__c prof:associatedPrincipals){
                getAssociatedPrincipals.add(prof.Client_CIF_Code__c);
            }
            exposureRiskLinkedPrincipals=new ApplicationExposureRiskSelector().orderBySequenceNumber(application.Id,getAssociatedPrincipals);
            for(Application_Exposure_Risk__c fin:exposureRiskLinkedPrincipals)
            {
                fin.Worst_risk_PCO__c=exposureRiskLinkedPrincipals[0].Early_Warning_Listing__c;
                updatedExposureRisk.add(fin);
            }
            exposureHoldLinkedPrincipals=new ApplicationExposureRiskSelector().orderByWorstHoldSeqNo(application.Id,getAssociatedPrincipals);
            for(Application_Exposure_Risk__c fin:exposureHoldLinkedPrincipals)
            {
                fin.Worst_Risk_Hold__c =exposureHoldLinkedPrincipals[0].Early_Warning_Listing__c;
                updatedExposureHold.add(fin);
            }
            exposureCollectionLinkedPrincipals=new ApplicationExposureRiskSelector().orderByWorstCollectionSeqNo(application.Id,getAssociatedPrincipals);
            for(Application_Exposure_Risk__c fin:exposureCollectionLinkedPrincipals)
            {
                fin.Worst_Risk_Collection__c =exposureCollectionLinkedPrincipals[0].Worst_Collection_Risk_Type__c;
                updatedExposureCollectionRisk.add(fin);
            }
        }
        
        try{
        update updatedExposureRisk;
        update updatedExposureHold;
        update updatedExposureCollectionRisk;
        }
        catch(Exception e)
        {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
        system.debug('updatedExposureRisk'+json.serializePretty(updatedExposureRisk));
        responseMap.put('finalApplicationExposureRisk',updatedExposureRisk);
        responseMap.put('appProfile',newList);
        return responseMap;
    }
    
    
}