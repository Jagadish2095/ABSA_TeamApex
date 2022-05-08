/**
 * @description       : description Handler for the Application Security
 * @author            : Gulafsha
 * @last modified on  : 2021-06-12
 * @last modified by  : Gulafsha
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   2021-06-12  Gulafsha   Initial Version
**/

 
public class TriggerHandlerApplicationSecurity extends TriggerHandler{
/**
@description to execute After Insert logic
@param newRecords Map of new values
*/
    public virtual override void afterInsert(Map<Id, sObject> newRecords) {
        Map<Id, Application_Security__c> appsecTriggerNew = (Map<Id, Application_Security__c>)newRecords;
        Set<String> ApplicationIds = new Set<String>();
        Application__c app;
        list<Application__c> appList = new list<Application__c>();
        List<Application_Security__c> applicationSecList = new List<Application_Security__c>();
        for(Application_Security__c appsec:appsecTriggerNew.values()){
            //Added ASV_MASV__c condition for the total ASV_MASV__c calculation
            if((appsec.ASV__c!=Null && appsec.ASV__c!= 0) ||(appsec.MASV__c!=Null&& appsec.MASV__c!= 0) ||(appsec.ASV_MASV__c!=Null&& appsec.ASV_MASV__c!= 0)){
                ApplicationIds.add(appsec.Application_Id_Text__c);
                applicationSecList.add(appsec);
            }
        }
        List<Application_Profile__c> appProfile = new List<Application_Profile__c>();
        Map<id,String> appRelTomap = new map<id,string>();
        Map<String,String> ClientCodeRegMap = new map<String,string>();
        appProfile = new ApplicationProfileSelector().getApplicationProfilesbyAppIdSet(ApplicationIds);
          for(Application_Profile__c approf:appProfile){
            if(approf.Applicant_Type__c=='Main Applicant' && approf.Client_CIF_Code__c!=Null && approf.Related_to_Client_ID_or_Reg_Number__c!=Null){
                appRelTomap.put(approf.Application__c,approf.Related_to_Client_ID_or_Reg_Number__c); 
            }
            ClientCodeRegMap.put(approf.Client_CIF_Code__c,approf.Related_to_Client_ID_or_Reg_Number__c);
        }
         Map<ID, Application__c> appmap = new Map<ID, Application__c>(new ApplicationsSelector().selectAppWithIds(ApplicationIds));   
        for(Application_Security__c appsec: applicationSecList){
            if(appmap.containskey(appsec.Application_Id_Text__c) && appRelTomap.containskey(appsec.Application_Id_Text__c)){
                if(appRelTomap.get(appsec.Application_Id_Text__c)==ClientCodeRegMap.get(appsec.Client_Code__c)){
                    app = new Application__c();
                    app = appmap.get(appsec.Application_Id_Text__c);
                    if(appsec.MASV__c!=Null && appsec.MASV__c!=0){
                        app.MASV_Securities__c+= appsec.MASV__c;
                    }
                    if(appsec.Security_Type__c=='Bond'){
                        if(appsec.MASV__c!=Null && appsec.MASV__c!=0){
                            app.MASV_Bonds__c+= appsec.MASV__c;
                        }
                        else if(appsec.ASV_MASV__c!=Null && appsec.ASV_MASV__c!=0){
                            app.MASV_Bonds__c+= appsec.ASV_MASV__c;
                        }
                    }
                    else{
                        if(appsec.ASV__c!=Null && appsec.ASV__c!=0){
                            app.ASV_Securities__c+= appsec.ASV__c;
                        }
                        else if(appsec.ASV_MASV__c!=Null && appsec.ASV_MASV__c!=0){
                            app.ASV_Securities__c+= appsec.ASV_MASV__c;
                        }
                    }
                    appmap.put(appsec.Application_Id_Text__c,app);
                }
            }
        }
        if(appmap!=Null){
            update appmap.values();
        }
    }
/**
@description to execute After update logic
@param newRecords Map of new values
@param oldRecords Map of old values
*/
    public virtual override void afterUpdate(Map<Id, sObject> newRecords,Map<Id, sObject> oldRecords) {
        Map<Id, Application_Security__c> appsecTriggerNew = (Map<Id, Application_Security__c>)newRecords;
        Map<Id, Application_Security__c> appsecTriggerOld = (Map<Id, Application_Security__c>)oldRecords;
        Set<String> ApplicationIds = new Set<String>();
        Application__c app;
        list<Application__c> appList = new list<Application__c>();
        List<Application_Security__c> applicationSecList = new List<Application_Security__c>();
        for(Application_Security__c appsec:appsecTriggerNew.values()){
            if((appsecTriggerOld.get(appsec.id).ASV__c != appsec.ASV__c ) ||(appsecTriggerOld.get(appsec.id).MASV__c != appsec.MASV__c) ||(appsec.ASV_MASV__c!=Null&& appsec.ASV_MASV__c!= 0)){
                ApplicationIds.add(appsec.Application_Id_Text__c);
                applicationSecList.add(appsec);
            }
        }
        List<Application_Profile__c> appProfile = new List<Application_Profile__c>();
        Map<id,String> appRelTomap = new map<id,string>();
        Map<String,String> ClientCodeRegMap = new map<String,string>();
        //Map<id,Map<String,String>> appclientmap = new map<id,map<String,string>>();
        appProfile = new ApplicationProfileSelector().getApplicationProfilesbyAppIdSet(ApplicationIds);
        for(Application_Profile__c approf:appProfile){
            if(approf.Applicant_Type__c=='Main Applicant' && approf.Client_CIF_Code__c!=Null && approf.Related_to_Client_ID_or_Reg_Number__c!=Null){
                appRelTomap.put(approf.Application__c,approf.Related_to_Client_ID_or_Reg_Number__c); 
            }
            ClientCodeRegMap.put(approf.Client_CIF_Code__c,approf.Related_to_Client_ID_or_Reg_Number__c);
        }
        Map<ID, Application__c> appmap = new Map<ID, Application__c>(new ApplicationsSelector().selectAppWithIds(ApplicationIds));
        for(Application_Security__c appsec: applicationSecList){
            if(appmap.containskey(appsec.Application_Id_Text__c) && appRelTomap.containskey(appsec.Application_Id_Text__c)){
                if(appRelTomap.get(appsec.Application_Id_Text__c)==ClientCodeRegMap.get(appsec.Client_Code__c)){
                    app = new Application__c();
                    app = appmap.get(appsec.Application_Id_Text__c);
                    if((appsecTriggerOld.get(appsec.id).MASV__c != appsec.MASV__c ) ){
                        if(appsec.MASV__c!=Null){
                            app.MASV_Securities__c+= appsec.MASV__c;
                        }
                        if(appsecTriggerOld.get(appsec.id).MASV__c!=Null){
                            app.MASV_Securities__c-= appsecTriggerOld.get(appsec.id).MASV__c;
                        }
                    }
                    if(appsec.Security_Type__c=='Bond'){
                        if((appsecTriggerOld.get(appsec.id).MASV__c != appsec.MASV__c ) ){
                            if(appsec.MASV__c!=Null){
                                app.MASV_Bonds__c+= appsec.MASV__c;
                            }
                            if(appsecTriggerOld.get(appsec.id).MASV__c!=Null){
                                app.MASV_Bonds__c-= appsecTriggerOld.get(appsec.id).MASV__c;
                            }
                        }
                        else if((appsecTriggerOld.get(appsec.id).ASV_MASV__c != appsec.ASV_MASV__c ) ){
                            if(appsec.ASV_MASV__c!=Null){
                                app.MASV_Bonds__c+= appsec.ASV_MASV__c;
                            }
                            if(appsecTriggerOld.get(appsec.id).ASV_MASV__c!=Null){
                                app.MASV_Bonds__c-= appsecTriggerOld.get(appsec.id).ASV_MASV__c;
                            }
                        }
                    }
                    else{
                        if((appsecTriggerOld.get(appsec.id).ASV__c != appsec.ASV__c ) ){
                            if(appsec.ASV__c!=Null){
                                app.ASV_Securities__c+= appsec.ASV__c;
                            }
                            if(appsecTriggerOld.get(appsec.id).ASV__c!=Null){
                                app.ASV_Securities__c-= appsecTriggerOld.get(appsec.id).ASV__c;
                            }
                        }
                        else if((appsecTriggerOld.get(appsec.id).ASV_MASV__c != appsec.ASV_MASV__c ) ){
                            if(appsec.ASV_MASV__c!=Null){
                                app.ASV_Securities__c+= appsec.ASV_MASV__c;
                            }
                            if(appsecTriggerOld.get(appsec.id).ASV_MASV__c!=Null){
                                app.ASV_Securities__c-= appsecTriggerOld.get(appsec.id).ASV_MASV__c;
                            }
                        }
                    }
                    appmap.put(appsec.Application_Id_Text__c,app);
                }
            }
        }
        if(appmap!=Null){
            update appmap.values();
        }
    }
}