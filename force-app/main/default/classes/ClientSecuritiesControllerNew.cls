/**
 * @description       : Class to fetch existing securities from service and show it in UI
 * @author            : Gulafsha
 * @last modified on  : 2021-06-14
 * @last modified by  : 
 * Modifications Log 
 * Ver   Date         Author     Modification
 * 1.0   2021-06-08   Gulafsha   Initial Version
**/
public class ClientSecuritiesControllerNew implements Queueable{
    Set<Id> Appsecurityids = new Set<Id>();

    /**
    * @description Constructor to initialize variables
    * @author Gulafsha | 2021-06-10 
    * @param Appsecurityids 
    **/
    public ClientSecuritiesControllerNew(Set<ID> Appsecurityids) {
        this.Appsecurityids = Appsecurityids;
    }

    /**
    * @description This method is called from triggerhandler application profile class
    * @author Gulafsha | 2021-06-08 
    * @param context 
    **/
    public void execute(QueueableContext context) {
		
        //IncomeAndExpenseController.getCreditOrch(Appsecurityids);
         
    

        ClientSecuritiesControllerNew.securities(Appsecurityids);
        ClientSecuritiesControllerNew.securitiesSuretyS(Appsecurityids);
        ClientSecuritiesControllerNew.securitiesCLA(Appsecurityids);

        ClientSecuritiesControllerNew.securitiesCessionLLP(Appsecurityids);
        
        ClientSecuritiesControllerNew.securitiesCessionNoLLP(Appsecurityids);
        ClientSecuritiesControllerNew.securitiesCOD(Appsecurityids);
        ClientSecuritiesControllerNew.securitiesCogP(Appsecurityids);
        ClientSecuritiesControllerNew.securitiesCoiI(Appsecurityids);
        ClientSecuritiesControllerNew.securitiesCOS(Appsecurityids);
        ClientSecuritiesControllerNew.securitiesDematS(Appsecurityids);
        ClientSecuritiesControllerNew.securitiesLoU(Appsecurityids);
        ClientSecuritiesControllerNew.securitiesASVGCV1(Appsecurityids);
        ClientSecuritiesControllerNew.securitiesASVCessionS(Appsecurityids);
        ClientSecuritiesControllerNew.securitiesASVCessionFSTI(Appsecurityids);
        ClientSecuritiesControllerNew.securitiesASVCessionEI(Appsecurityids);
        ClientSecuritiesControllerNew.securitiesCOUT(Appsecurityids);
        ClientSecuritiesControllerNew.securitiesASVHoldsVI(Appsecurityids);
        ExposureController.getApplicationExposuresFutureCallQueue(Appsecurityids);

    }

    /**
    * @description getApplication records
    * @author Gulafsha | 2021-06-08 
    * @param OppId 
    * @return Application__c 
    **/
    @AuraEnabled
    public static Application__c  getApplication(String OppId){
        ApplicationsSelector app = new ApplicationsSelector();
        Application__c appRecord = new Application__c();
        appRecord = app.selectByCreditOpportunityId(OppId);

        return appRecord;
    }
    /**
    * @description This methods calculates fields sent to powercurve related to existing security on application level
    * @author Gulafsha | 2021-06-08 
    * @param OppId 
    * @param IsUpdate 
    * @return Map<String, Double> 
    **/
	@AuraEnabled
    public static Map<String,Double>  calculatePowerCurveSummary(String OppId,Boolean IsUpdate){
      Map<String,Double> applicationToReturnMap = new map<String,Double>();
      ApplicationsSelector app1 = new ApplicationsSelector();
      Application__c appRecord = app1.selectByCreditOpportunityId(OppId);  
      Set<String> ApplicationIds = new Set<String>();
      ApplicationIds.add(appRecord.Id);
        Application__c app;
        list<Application__c> appList = new list<Application__c>();
        List<Application_Security__c> applicationSecList = new List<Application_Security__c>();
        List<Application_Security__c> applicationSecListNew = new Applicationsecurityselector().selectByApplicationIdTextSet(new set<Id>{appRecord.Id});
        for(Application_Security__c appsec:applicationSecListNew){
            //Added ASV_MASV__c condition for the total ASV_MASV__c calculation
            if((appsec.ASV__c!=Null && appsec.ASV__c!= 0) ||(appsec.MASV__c!=Null&& appsec.MASV__c!= 0) ||(appsec.ASV_MASV__c!=Null&& appsec.ASV_MASV__c!= 0)){
                //ApplicationIds.add(appsec.Application_Id_Text__c);
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
            }else if(approf.Applicant_Type__c=='Main Applicant' && approf.Client_CIF_Code__c!=Null && approf.Related_to_Client_ID_or_Reg_Number__c ==Null){
                //if Related_to_Client_ID_or_Reg_Number__c null
                 appRelTomap.put(approf.Application__c,approf.Id); 
            }
             if(approf.Applicant_Type__c=='Main Applicant' && approf.Client_CIF_Code__c!=Null && approf.Related_to_Client_ID_or_Reg_Number__c ==Null){
                //if Related_to_Client_ID_or_Reg_Number__c null
              ClientCodeRegMap.put(approf.Client_CIF_Code__c,approf.Id);
             }else{
               ClientCodeRegMap.put(approf.Client_CIF_Code__c,approf.Related_to_Client_ID_or_Reg_Number__c);  
             } 
            
        }
         Map<ID, Application__c> appmap = new Map<ID, Application__c>(new ApplicationsSelector().selectAppWithIds(ApplicationIds));   
        app = new Application__c();
        Double asvSpecific = 0;
        //check ClientCodeRegMap if it is null
        //appRelTomap
        for(Application_Security__c appsec: applicationSecList){
            if(appmap.containskey(appsec.Application_Id_Text__c) && appRelTomap.containskey(appsec.Application_Id_Text__c)){
                if(appRelTomap.get(appsec.Application_Id_Text__c)==ClientCodeRegMap.get(appsec.Client_Code__c)){
                    
                    app.Id = appmap.get(appsec.Application_Id_Text__c).Id;
                    if(appsec.Specific__c !=null && appsec.Specific__c=='Y' && appsec.ASV__c !=null){
                        asvSpecific += appsec.ASV__c;
                    }
                    if(appsec.MASV__c!=Null && appsec.MASV__c!=0){
                        if(app.MASV_Securities__c==Null){
                             app.MASV_Securities__c = 0;   
                            }
                        app.MASV_Securities__c+= appsec.MASV__c;
                    }
                    if(appsec.Security_Type__c=='Bond'){
                        if(app.MASV_Bonds__c==Null){
                             app.MASV_Bonds__c = 0;   
                            }
                        if(appsec.MASV__c!=Null && appsec.MASV__c!=0){
                            app.MASV_Bonds__c+= appsec.MASV__c;
                        }
                        else if(appsec.ASV_MASV__c!=Null && appsec.ASV_MASV__c!=0){
                            app.MASV_Bonds__c+= appsec.ASV_MASV__c;
                        }
                    }
                    else{
                        if(app.ASV_Securities__c==Null){
                             app.ASV_Securities__c = 0;   
                            }
                        if(appsec.ASV__c!=Null && appsec.ASV__c!=0){
                            app.ASV_Securities__c+= appsec.ASV__c;
                        }
                        else if(appsec.ASV_MASV__c!=Null && appsec.ASV_MASV__c!=0){
                            app.ASV_Securities__c+= appsec.ASV_MASV__c;
                        }
                    }
                    //appmap.put(appsec.Application_Id_Text__c,app);
                }
            }
        }
        if(appmap!=Null && app.Id!=Null){
            if((appmap.get(app.Id).ASV_Securities__c!=app.ASV_Securities__c 
               || appmap.get(app.Id).MASV_Bonds__c!=app.MASV_Bonds__c
               || appmap.get(app.Id).MASV_Securities__c!=app.MASV_Securities__c) && IsUpdate){
                   
                  update app;
               }
            
            applicationToReturnMap.put('ASV_Securities',app.ASV_Securities__c!=null?app.ASV_Securities__c:0);
            applicationToReturnMap.put('MASV_Bonds',app.MASV_Bonds__c!=null?app.MASV_Bonds__c:0);
            applicationToReturnMap.put('MASV_Securities',app.MASV_Securities__c!=null?app.MASV_Securities__c:0);
            applicationToReturnMap.put('ASVSpecific_Securities',asvSpecific);
            return applicationToReturnMap;
        } 
        else if(appmap !=Null){
            applicationToReturnMap.put('ASV_Securities',appmap.values()[0].ASV_Securities__c!=null?appmap.values()[0].ASV_Securities__c:0);
            applicationToReturnMap.put('MASV_Bonds',appmap.values()[0].MASV_Bonds__c!=null?appmap.values()[0].MASV_Bonds__c:0);
            applicationToReturnMap.put('MASV_Securities',appmap.values()[0].MASV_Securities__c!=null?appmap.values()[0].MASV_Securities__c:0);
            applicationToReturnMap.put('ASVSpecific_Securities',asvSpecific);
            
            return applicationToReturnMap;
        }
        return null;
    }
    
    /**
    * @description Product level data to be sent to powercurve
    * @author Gulafsha | 2021-06-08 
    * @param OppId 
    * @param regNo 
    * @return Map<String, Double> 
    **/
    @AuraEnabled
    public static Map<String,Double>  calculatePowerCurveSummaryProducts(String OppId,String regNo){
      Map<String,Double> applicationToReturnMap = new map<String,Double>();
      ApplicationsSelector app1 = new ApplicationsSelector();
      Application__c appRecord = app1.selectByCreditOpportunityId(OppId);  
      Set<String> ApplicationIds = new Set<String>();
      ApplicationIds.add(appRecord.Id);
        Application__c app;
        list<Application__c> appList = new list<Application__c>();
        List<Application_Security__c> applicationSecList = new List<Application_Security__c>();
        List<Application_Security__c> applicationSecListNew = new Applicationsecurityselector().selectByApplicationIdTextSetReffAcc(new set<Id>{appRecord.Id},regNo);
        for(Application_Security__c appsec:applicationSecListNew){
            //Added ASV_MASV__c condition for the total ASV_MASV__c calculation
            if((appsec.ASV__c!=Null && appsec.ASV__c!= 0) ||(appsec.MASV__c!=Null&& appsec.MASV__c!= 0) ||(appsec.ASV_MASV__c!=Null&& appsec.ASV_MASV__c!= 0)){
                //ApplicationIds.add(appsec.Application_Id_Text__c);
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
            }else if(approf.Applicant_Type__c=='Main Applicant' && approf.Client_CIF_Code__c!=Null && approf.Related_to_Client_ID_or_Reg_Number__c ==Null){
                //if Related_to_Client_ID_or_Reg_Number__c null
                 appRelTomap.put(approf.Application__c,approf.Id); 
            }
             if(approf.Applicant_Type__c=='Main Applicant' && approf.Client_CIF_Code__c!=Null && approf.Related_to_Client_ID_or_Reg_Number__c ==Null){
                //if Related_to_Client_ID_or_Reg_Number__c null
              ClientCodeRegMap.put(approf.Client_CIF_Code__c,approf.Id);
             }else{
               ClientCodeRegMap.put(approf.Client_CIF_Code__c,approf.Related_to_Client_ID_or_Reg_Number__c);  
             } 
            
        }
         Map<ID, Application__c> appmap = new Map<ID, Application__c>(new ApplicationsSelector().selectAppWithIds(ApplicationIds));   
        app = new Application__c();
        Double asvSpecific = 0;
        //check ClientCodeRegMap if it is null
        //appRelTomap
        for(Application_Security__c appsec: applicationSecList){
            if(appmap.containskey(appsec.Application_Id_Text__c) && appRelTomap.containskey(appsec.Application_Id_Text__c)){
                if(appRelTomap.get(appsec.Application_Id_Text__c)==ClientCodeRegMap.get(appsec.Client_Code__c)){
                    
                    app.Id = appmap.get(appsec.Application_Id_Text__c).Id;
                    if(appsec.Specific__c !=null && appsec.Specific__c=='Y' && appsec.ASV__c !=null){
                        asvSpecific += appsec.ASV__c;
                    }
                    //appmap.put(appsec.Application_Id_Text__c,app);
                }
            }
        }
        if(appmap!=Null && app.Id!=Null){
            
            applicationToReturnMap.put('ASVSpecific_Securities',asvSpecific);
            return applicationToReturnMap;
        } 
        else if(appmap !=Null){
            
            applicationToReturnMap.put('ASVSpecific_Securities',asvSpecific);
            
            return applicationToReturnMap;
        }
         applicationToReturnMap.put('ASVSpecific_Securities',asvSpecific);
        return applicationToReturnMap;
    }
    /**
    * @description getSecurityBonds for UI
    * @author Gulafsha | 2021-06-08 
    * @param accountId 
    * @param OppId 
    * @return string 
    **/
    @AuraEnabled
    public static string  getSecurityBonds(String accountId,String OppId){
        // securities(accountId,OppId);
        ApplicationsSelector app = new ApplicationsSelector();
        Application__c appRecord = app.selectByCreditOpportunityId(OppId);
        List<sMgetAsVbondsV1_Resp_IB_v1.BondTable> bondsWrapperList = new  List<sMgetAsVbondsV1_Resp_IB_v1.BondTable>();
        List<Application_Security__c> applicationsecList=new ApplicationSecuritySelector().selectByApplicationIdAndSecTypefields(appRecord.id,'Bond');

        for(Application_Security__c apps:applicationsecList){
            sMgetAsVbondsV1_Resp_IB_v1.BondTable bondT = new sMgetAsVbondsV1_Resp_IB_v1.BondTable();
            bondT.specific = apps.Specific__c;
            bondT.status   = apps.Status__c;
            BondT.titleDeed = apps.Title_Deed_Number__c;
            bondT.propType  = apps.Bond_Type__c ;
            bondT.refNo =  apps.Reference_Account_Number__c;
            bondT.bondHoldCd  = apps.Holder_Code__c;
            bondT.bondRegnum = apps.Registration_Number__c;
            bondT.secVal = apps.Security_Value__c;
            bondT.propdesc = apps.Description__c;
            bondT.asecVal =apps.ASV_MASV__c!=null?String.valueof(apps.ASV_MASV__c):'';
            bondT.regdt = apps.Date_Signed__c!=null?String.valueof(apps.Date_Signed__c):'';
            bondT.valueBy = apps.Client_Name__c;
            bondT.clcd = apps.Client_Code__c;
            bondT.ApplicationId = apps.Id;

            if(apps.Ranking_Number__c!=null){
                bondT.bondRank = String.valueof(apps.Ranking_Number__c);
            } else{
                bondT.bondRank ='';
            }

            if(apps.Realistic_Market_Value__c!=null){
                bondT.realmv = String.valueof(apps.Realistic_Market_Value__c);
            } else{
                bondT.realmv ='';
            }

            if(apps.Amount__c!=Null){
                bondT.nomval = String.valueof(apps.Amount__c);
            } else{
                bondT.nomval = '';
            }

            bondsWrapperList.add(bondT);
        }
        if(bondsWrapperList.size()>0){
            system.debug(bondsWrapperList);
            return JSON.serialize(bondsWrapperList);
        }
        return null;
    }

    /**
    * @description Call service
    * @author Gulafsha | 2021-06-08 
    * @param Appsecurityids 
    **/
    @Future(callout = true)
    public static void securities(Set<id> Appsecurityids){
        List<sMgetAsVbondsV1_Resp_IB_v1.BondTable> bondsWrapperList=new  List<sMgetAsVbondsV1_Resp_IB_v1.BondTable>();
        List<Application_Profile__c> appprincipalList= new ApplicationProfileSelector().getApplicationProfilesbyId(Appsecurityids);

        for(Application_Profile__c appsec:appprincipalList){
            if( String.isNotBlank(appsec.Client_CIF_Code__c) ){
                Map<sMgetAsVbondsV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsVbondsV1_IH_v1.sMgetAsVbondsV1(appsec.Client_CIF_Code__c);
                sMgetAsVbondsV1_Resp_IB_v1 responseBean = (new List<sMgetAsVbondsV1_Resp_IB_v1>(responseMap.keySet()))[0];

                if(responseBean.statusCode == 200){
                    sMgetAsVbondsV1_Resp_IB_v1.sMgetAsVbondsV1Response wrapper = responseBean.sMgetAsVbondsV1Response;
                    List<sMgetAsVbondsV1_Resp_IB_v1.BondTable> cls_Smn145o = wrapper.Smn145o.bondTable;

                    for(sMgetAsVbondsV1_Resp_IB_v1.BondTable bondT : cls_Smn145o){
                        bondT.ApplicationId = appsec.application__c;
                        bondT.valueBy = appsec.Client_Name__c;
                        bondT.clcd = appsec.Client_CIF_Code__c;

                        if((bondT.regdt!=Null && bondT.regdt!='0') || (bondT.specific!=Null && bondT.specific!='0') || (bondT.status!=Null && bondT.status!='0') ||
                        (bondT.bondRank!=Null && bondT.bondRank!='0') || (bondT.titleDeed!=Null && bondT.titleDeed!='0' && bondT.titleDeed!='0110') || (bondT.propType!=Null && bondT.propType!='0') ||
                        (bondT.realmv!=Null && bondT.realmv!='0') || (bondT.refNo!=Null && bondT.refNo!='0') || (bondT.bondHoldCd!=Null && bondT.bondHoldCd!='0') ||
                        (bondT.bondRegnum!=Null && bondT.bondRegnum!='0') || (bondT.propdesc!=Null && bondT.propdesc!='0') || (bondT.nomval!=Null && bondT.nomval!='0') ||
                        (bondT.secVal!=Null && bondT.secVal!='0') || ((bondT.asecVal!=Null && bondT.asecVal!='0') || (bondT.masecVal!=Null && bondT.masecVal!='0'))){
                            bondsWrapperList.add(bondT);
                        }
                    }
                }
            }
        }

        if(bondsWrapperList.size()>0){
            insertAppSecurities(bondsWrapperList);
        }
    }

    
    /**
    * @description Insert existing security records
    * @author Gulafsha | 2021-06-08 
    * @param wrapperlist 
    * @return string 
    **/
    public static string insertAppSecurities(List<sMgetAsVbondsV1_Resp_IB_v1.BondTable> wrapperlist){
        if(wrapperlist.size () >0){
            List<Application_Security__c> appList = new List<Application_Security__c>();

            for(sMgetAsVbondsV1_Resp_IB_v1.BondTable bondT :wrapperlist){
                Application_Security__c apps = new Application_Security__c();
                apps.Name = 'Bond';
                apps.Security_Type__c = 'Bond';
                apps.Specific__c = bondT.specific;
                apps.Status__c = bondT.status;
                apps.Security_Value__c = bondT.secVal;
                apps.Ranking_Number__c = bondT.bondRank!=Null?decimal.valueof(bondT.bondRank):Null;
                apps.Title_Deed_Number__c = BondT.titleDeed;
                apps.Bond_Type__c = bondT.propType;
                apps.Realistic_Market_Value__c = bondT.realmv!=Null?decimal.valueof(bondT.realmv):Null;
                apps.Reference_Account_Number__c = bondT.refNo;
                apps.Holder_Code__c = bondT.bondHoldCd;
                apps.Registration_Number__c = bondT.bondRegnum;
                apps.Description__c = bondT.propdesc;
                apps.Amount__c = bondT.nomval!=Null?decimal.valueof(bondT.nomval):Null;
                apps.ASV_MASV__c = bondT.asecVal!=Null?decimal.valueof(bondT.asecVal):bondT.masecVal!=Null?decimal.valueof(bondT.masecVal):Null;
                apps.MASV__c = bondT.masecVal!=Null?decimal.valueof(bondT.masecVal):0;
                apps.ASV__c = bondT.asecVal!=Null?decimal.valueof(bondT.asecVal):0;
                apps.Client_Name__c =  bondT.valueBy;
                apps.Client_Code__c =  bondT.clcd ;

                if(bondT.regdt!=Null && bondT.regdt!='0'){
                   apps.Date_Signed__c= Date.parse(ChequeAndOverdraftController.getFormatedDate(bondT.regdt));
                }

                if(bondT.ApplicationId != null){
                    apps.Application_Id_Text__c = bondT.ApplicationId;
                }
                appList.add(apps);
            }

            if(appList.size() >0){
                insert appList;
            }
        }

        return null;
    }

    
    /**
    * @description Cession of Unit Trusts
    * @author Gulafsha | 2021-06-08 
    * @param accountId 
    * @param OppId 
    * @return string 
    **/
    @AuraEnabled
    public static string  getCessionofUnitTrusts(String accountId,String OppId){
        ApplicationsSelector app = new ApplicationsSelector();
        Application__c appRecord = app.selectByCreditOpportunityId(OppId);
        List<SMgetASVCessionOfUnitTrustsV1_Resp_IB_v1.outputTbl> bondsWrapperList = new  List<SMgetASVCessionOfUnitTrustsV1_Resp_IB_v1.outputTbl>();
        List<Application_Security__c> applicationsecList=new ApplicationSecuritySelector().selectByApplicationIdAndSecTypefields(appRecord.id,'Cession of Unit Trust');

        for(Application_Security__c apps:applicationsecList){
            SMgetASVCessionOfUnitTrustsV1_Resp_IB_v1.outputTbl bondT = new SMgetASVCessionOfUnitTrustsV1_Resp_IB_v1.outputTbl();
            bondT.status = apps.Client_Name__c;
            bondT.clcd = apps.Client_Code__c;
            bondT.refacc  = apps.Reference_Account_Number__c;
            bondT.specific = apps.Specific__c;
            bondT.nomval= apps.Amount__c !=Null?String.valueof(apps.Amount__c):Null;
            bondT.sharenm = apps.Share_Name__c;
            bondT.cessamt  = apps.X30_Days_Amount__c!=Null?String.valueof(apps.X30_Days_Amount__c):Null;
            bondT.ascVal = apps.ASV__c!=Null?string.valueof(apps.ASV__c):'0';
            bondT.ackndte = apps.Date_Analysis__c!=Null?string.valueof(apps.Date_Analysis__c):Null;
            bondT.signdte = apps.Date_Signed__c!=Null?string.valueof(apps.Date_Signed__c):Null;
            bondT.secVal = apps.Security_Value__c;
            bondT.noshares = apps.Number_of_Shares__c !=Null?String.valueof(apps.Number_of_Shares__c ):'0';
            bondT.redmFrmHeld = apps.Holder_Code__c;
            bondT.ApplicationId = apps.Id;
            bondsWrapperList.add(bondT);
        }

        if(bondsWrapperList.size()>0){
            return JSON.serialize(bondsWrapperList);
        }

        return null;
    }

    /**
    * @description call service
    * @author Gulafsha | 2021-06-10 
    * @param Appsecurityids 
    **/
    @Future(callout = true)
    public static void securitiesCOUT(Set<id> Appsecurityids){
        List<SMgetASVCessionOfUnitTrustsV1_Resp_IB_v1.outputTbl> bondsWrapperList=new  List<SMgetASVCessionOfUnitTrustsV1_Resp_IB_v1.outputTbl>();
        List<Application_Profile__c> appprincipalList= new ApplicationProfileSelector().getApplicationProfilesbyId(Appsecurityids);

        for(Application_Profile__c appsec:appprincipalList){
            if( String.isNotBlank(appsec.Client_CIF_Code__c) ){
                Map<SMgetASVCessionOfUnitTrustsV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = SMgetASVCessionOfUnitTrustsV1_IH_v1.SMgetASVCessionOfUnitTrustsV1(appsec.Client_CIF_Code__c);
                SMgetASVCessionOfUnitTrustsV1_Resp_IB_v1 responseBean = (new List<SMgetASVCessionOfUnitTrustsV1_Resp_IB_v1>(responseMap.keySet()))[0];

                if(responseBean.statusCode == 200){
                    SMgetASVCessionOfUnitTrustsV1_Resp_IB_v1.SMgetASVCessionOfUnitTrustsV1Response wrapper = responseBean.SMgetASVCessionOfUnitTrustsV1Response;
                    List<SMgetASVCessionOfUnitTrustsV1_Resp_IB_v1.outputTbl> cls_smn236o = wrapper.smn236o.outputTbl;
                    SMgetASVCessionOfUnitTrustsV1_Resp_IB_v1.smn236o smn236o = wrapper.smn236o;

                    for(SMgetASVCessionOfUnitTrustsV1_Resp_IB_v1.outputTbl bondT : cls_smn236o){
                        bondT.ApplicationId = appsec.application__c;
                        bondT.status = appsec.Client_Name__c;
                        bondT.clcd = appsec.Client_CIF_Code__c;

                        if((bondT.specific!=Null && bondT.specific!='0')||(bondT.refAcc!=Null && bondT.refAcc!='0') || (bondT.nomval!=Null && bondT.nomval!='0') ||
                            (bondT.redmFrmHeld!=Null && bondT.redmFrmHeld!='0') || (bondT.cessamt!=Null && bondT.cessamt!='0') ||
                            (bondT.shareNm!=Null && bondT.shareNm!='0') || (bondT.seqno!=Null && bondT.seqno!='0') || (bondT.noshares!=Null && bondT.noshares!='0') ||
                            (bondT.signdte!=Null && bondT.signdte!='0') || (bondT.ackndte!=Null && bondT.ackndte!='0') ||(bondT.secVal!=Null && bondT.sEcVal!='0') ||
                            ((bondT.ascVal!=Null && bondT.ascVal!='0'))){
                            bondsWrapperList.add(bondT);
                        }
                    }
                }
            }
        }

        if(bondsWrapperList.size()>0){
            insertAppSecuritiesCOUT(bondsWrapperList);
        }
    }

    
    /**
    * @description Insert existing securities record
    * @author Gulafsha | 2021-06-08 
    * @param wrapperlist 
    * @return string 
    **/
    public static string insertAppSecuritiesCOUT(List<SMgetASVCessionOfUnitTrustsV1_Resp_IB_v1.outputTbl> wrapperlist){
        if(wrapperlist.size () >0){
            List<Application_Security__c> appList = new List<Application_Security__c>();

            for(SMgetASVCessionOfUnitTrustsV1_Resp_IB_v1.outputTbl bondT :wrapperlist){
                Application_Security__c apps = new Application_Security__c();
                apps.Name = 'Cession of Unit Trust';
                apps.Security_Type__c = 'Cession of Unit Trust';
                apps.Client_Name__c =  bondT.status;
                apps.Client_Code__c =  bondT.clcd ;
                apps.Reference_Account_Number__c = bondT.refacc;
                apps.Specific__c = bondT.specific;
                apps.Amount__c = bondT.nomval!=Null?decimal.valueof(bondT.nomval):Null;
                apps.Share_Name__c = bondT.sharenm;
                apps.X30_Days_Amount__c = bondT.cessamt!=Null?decimal.valueof(bondT.cessamt):Null;
                apps.ASV_MASV__c = bondT.ascVal!=Null?decimal.valueof(bondT.ascVal):0;
                apps.ASV__c = bondT.ascVal!=Null?decimal.valueof(bondT.ascVal):0;
                apps.Security_Value__c = bondT.secVal;
                apps.Number_of_Shares__c = bondT.noshares!=Null?decimal.valueof(bondT.noshares):0;
                apps.Holder_Code__c = bondT.redmFrmHeld;

                if(bondT.ackndte!=Null && bondT.ackndte!='0'){
                   apps.Date_Analysis__c= Date.parse(ChequeAndOverdraftController.getFormatedDate(bondT.ackndte));
                }

                if(bondT.signdte!=Null && bondT.signdte!='0'){
                   apps.Date_Signed__c= Date.parse(ChequeAndOverdraftController.getFormatedDate(bondT.signdte));
                }

                if(bondT.ApplicationId != null){
                    apps.Application_Id_Text__c = bondT.ApplicationId;
                }

                appList.add(apps);
            }

            if(appList.size() >0){
                insert appList;
            }
        }
        return null;
    }

    
    /**
    * @description getSuretyships for component
    * @author Gulafsha | 2021-06-08 
    * @param accountId 
    * @param OppId 
    * @return string 
    **/
    @AuraEnabled
    public static string  getSuretyships(String accountId,String OppId){
        ApplicationsSelector app = new ApplicationsSelector();
        Application__c appRecord = app.selectByCreditOpportunityId(OppId);
        List<sMgetAsvSuretyshipsV1_Resp_IB_v1.SuretyTable> SuretyshipsWrapperList = new  List<sMgetAsvSuretyshipsV1_Resp_IB_v1.SuretyTable>();
        List<Application_Security__c> applicationsecList=new ApplicationSecuritySelector().selectByApplicationIdAndSecTypefields(appRecord.id,'Suretyship');

        for(Application_Security__c apps:applicationsecList){
            sMgetAsvSuretyshipsV1_Resp_IB_v1.SuretyTable SuretyS = new sMgetAsvSuretyshipsV1_Resp_IB_v1.SuretyTable();
            SuretyS.secVal  = apps.Client_Name__c;
            SuretyS.clcd = apps.Client_Code__c;
            SuretyS.status  = apps.Status__c ;
            SuretyS.suretyamt  = apps.Amount__c!=Null ? (apps.Limited_Surety__c == 'Y'? String.valueof(apps.Amount__c):'Unlimited'):'';
            //W: 12230: Saurabh  Changing the front end display wrapper //apps.Amount__c!=Null?String.valueOf(apps.Amount__c):'';
            SuretyS.asv  = apps.ASV_MASV__c!=Null?String.valueOf(apps.ASV_MASV__c):'';
            SuretyS.suretyclcd  = apps.Surety_Client_Code__c ;
            SuretyS.suretyname  = apps.Surety_Client_Name__c ;
            SuretyS.specifc  = apps.Specific__c ;
            SuretyS.nomVal  = apps.Nominal_Value__c ;
            SuretyS.dateSign  = apps.Date_Signed__c!=Null?String.valueof(apps.Date_Signed__c):'';
            SuretyS.refAcc  = apps.Reference_Account_Number__c ;
            SuretyS.suppSec  = apps.Limited_Surety__c;
            SuretyS.ApplicationId =  apps.id;
            SuretyshipsWrapperList.add(SuretyS);
        }

        if(SuretyshipsWrapperList.size()>0){
            return JSON.serialize(SuretyshipsWrapperList);
        }

        return null;
    }

    /**
    * @description call service
    * @author Gulafsha | 2021-06-08 
    * @param Appsecurityids 
    **/
    @Future(callout = true)
    public static void securitiesSuretyS(Set<id> Appsecurityids){
        List<sMgetAsvSuretyshipsV1_Resp_IB_v1.SuretyTable> SuretyshipsWrapperList = new  List<sMgetAsvSuretyshipsV1_Resp_IB_v1.SuretyTable>();
        List<Application_Profile__c> appprincipalList= new ApplicationProfileSelector().getApplicationProfilesbyId(Appsecurityids);

        for(Application_Profile__c appsec:appprincipalList){
            if( String.isNotBlank(appsec.Client_CIF_Code__c) ){
                Map<sMgetAsvSuretyshipsV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvSuretyshipsV1_IH_v1.sMgetAsvSuretyshipsV1(appsec.Client_CIF_Code__c);
                sMgetAsvSuretyshipsV1_Resp_IB_v1 responseBean = (new List<sMgetAsvSuretyshipsV1_Resp_IB_v1>(responseMap.keySet()))[0];

                if(responseBean.statusCode == 200){
                    sMgetAsvSuretyshipsV1_Resp_IB_v1.SMgetASVSuretyshipsV1Response wrapper = responseBean.SMgetASVSuretyshipsV1Response;
                    List<sMgetAsvSuretyshipsV1_Resp_IB_v1.SuretyTable> cls_smn152i = wrapper.Smn152o.suretyTable;

                    for(sMgetAsvSuretyshipsV1_Resp_IB_v1.SuretyTable SuretyS : cls_smn152i){
                        SuretyS.ApplicationId = appsec.application__c;
                        SuretyS.secVal = appsec.Client_Name__c;
                        SuretyS.clcd = appsec.Client_CIF_Code__c;

                        if((SuretyS.suretyname!=Null && SuretyS.suretyname!='0') || (SuretyS.specifc!=Null && SuretyS.specifc!='0') || (SuretyS.status!=Null && SuretyS.status!='0') ||
                        (SuretyS.suretyclcd!=Null && SuretyS.suretyclcd!='0') || (SuretyS.suretyamt!=Null && SuretyS.suretyamt!='0') || (SuretyS.dateSign!=Null && SuretyS.dateSign!='0') ||
                        (SuretyS.refAcc!=Null && SuretyS.refAcc!='0') || (SuretyS.nomVal!=Null && SuretyS.nomVal!='0') ||((SuretyS.asv!=Null && SuretyS.asv!='0')||(SuretyS.mortasv!=Null && SuretyS.mortasv!='0'))){
                            SuretyshipsWrapperList.add(SuretyS);
                        }
                    }
                }
            }
        }
        if(SuretyshipsWrapperList.size()>0){
            insertAppSecurities(SuretyshipsWrapperList);
        }
    }

    
    /**
    * @description Insert existing securities 
    * @author Gulafsha | 2021-06-08 
    * @param wrapperlist 
    * @return string 
    **/
    public static string insertAppSecurities(List<sMgetAsvSuretyshipsV1_Resp_IB_v1.SuretyTable> wrapperlist){
        if(wrapperlist.size () >0){
            List<Application_Security__c> appList = new List<Application_Security__c>();

            for(sMgetAsvSuretyshipsV1_Resp_IB_v1.SuretyTable SuretyS :wrapperlist){
                Application_Security__c apps = new Application_Security__c();
                apps.Name = 'Surety Ships';
                apps.Security_Type__c = 'Suretyship';
                apps.Client_Name__c = SuretyS.secVal;
				apps.Client_Code__c = SuretyS.clcd;
                apps.Surety_Client_Name__c = SuretyS.suretyname;
                apps.Status__c  = SuretyS.status;
                apps.Amount__c  = SuretyS.suretyamt!=Null?Decimal.valueOf(SuretyS.suretyamt):Null;
                apps.MASV__c = SuretyS.mortasv!=Null?decimal.valueof(SuretyS.mortasv):0;
                apps.ASV__c = SuretyS.asv!=Null?decimal.valueof(SuretyS.asv):0;
                apps.Surety_Client_Code__c  = SuretyS.suretyclcd;
                apps.Reference_Account_Number__c  = SuretyS.refAcc;
                apps.Specific__c = SuretyS.specifc;
                apps.Nominal_Value__c = SuretyS.nomVal;

                if(apps.Amount__c <9999999.00){
                   apps.Limited_Surety__c = 'Y';
                } else {
                   apps.Limited_Surety__c = 'N';
                }

                if(SuretyS.asv!=Null && Decimal.valueOf(SuretyS.asv)!=0){
                    apps.ASV_MASV__c  = Decimal.valueOf(SuretyS.asv);
                } else{
                    apps.ASV_MASV__c  = Decimal.valueOf(SuretyS.mortasv);
                }

                if(SuretyS.ApplicationId != null){
                    apps.Application_Id_Text__c = SuretyS.ApplicationId;
                }

				if(SuretyS.dateSign!=Null && SuretyS.dateSign!='0'){
                    apps.Date_Signed__c  = Date.parse(ChequeAndOverdraftController.getFormatedDate(SuretyS.dateSign));
                }

                appList.add(apps);
            }

            if(appList.size() >0){
                insert appList;
            }
        }

        return null;
    }

     

    /**
    * @description CreditLifePolicy
    * @author Gulafsha | 2021-06-08 
    * @param accountId 
    * @param OppId 
    * @return string 
    **/
    @AuraEnabled
    public static string  getCreditLifePolicy(String accountId,String OppId){
        ApplicationsSelector app = new ApplicationsSelector();
        Application__c appRecord = app.selectByCreditOpportunityId(OppId);
        List<sMgetAsvCreditLifePolicyV1_Resp_IB_v1.ClTable> CreditLifePolicyWrapperList = new  List<sMgetAsvCreditLifePolicyV1_Resp_IB_v1.ClTable>();
        List<Application_Security__c> applicationsecList=new ApplicationSecuritySelector().selectByApplicationIdAndSecTypefields(appRecord.id,'Credit Life Assurance');

        for(Application_Security__c apps:applicationsecList){
            sMgetAsvCreditLifePolicyV1_Resp_IB_v1.ClTable CLA = new sMgetAsvCreditLifePolicyV1_Resp_IB_v1.ClTable();
            CLA.Status   = apps.Status__c;
            CLA.polType = apps.Client_Name__c;
            CLA.clcd = apps.Client_Code__c;
            CLA.polno = apps.Policy_Number__c;
            CLA.tasvVal = apps.ASV_MASV__c!=Null?String.valueOf(apps.ASV_MASV__c):'';
            CLA.polamt = apps.Amount__c!=Null?String.valueOf(apps.Amount__c):'';
            CLA.refacc = apps.Reference_Account_Number__c;
            CLA.startDate = String.valueOf(apps.Date_Signed__c);
            CLA.assurco = apps.Surety_Client_Code__c;
            CLA.ApplicationId = apps.Id;
            CreditLifePolicyWrapperList.add(CLA);
        }

        if(CreditLifePolicyWrapperList.size()>0){
            return JSON.serialize(CreditLifePolicyWrapperList);
        }

        return null;
    }

    /**
    * @description CreditLifePolicy call service
    * @author Gulafsha | 2021-06-08 
    * @param Appsecurityids 
    **/
    @Future(callout = true)
    public static void securitiesCLA(Set<id> Appsecurityids){
        List<sMgetAsvCreditLifePolicyV1_Resp_IB_v1.ClTable> CreditLifePolicyWrapperList = new  List<sMgetAsvCreditLifePolicyV1_Resp_IB_v1.ClTable>();
        List<Application_Profile__c> appprincipalList= new ApplicationProfileSelector().getApplicationProfilesbyId(Appsecurityids);

        for(Application_Profile__c appsec:appprincipalList){if( String.isNotBlank(appsec.Client_CIF_Code__c) ){
                Map<sMgetAsvCreditLifePolicyV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvCreditLifePolicyV1_IH_v1.sMgetAsvCreditLifePolicyV1(appsec.Client_CIF_Code__c);
                sMgetAsvCreditLifePolicyV1_Resp_IB_v1 responseBean = (new List<sMgetAsvCreditLifePolicyV1_Resp_IB_v1>(responseMap.keySet()))[0];

                if(responseBean.statusCode == 200){
                    sMgetAsvCreditLifePolicyV1_Resp_IB_v1.SMgetASVcreditLifePoliciesV1Response wrapper = responseBean.SMgetASVcreditLifePoliciesV1Response;
                    List<sMgetAsvCreditLifePolicyV1_Resp_IB_v1.ClTable> cls_Smn151o = wrapper.Smn151o.ClTable;

                    for(sMgetAsvCreditLifePolicyV1_Resp_IB_v1.ClTable CLA : cls_smn151o){
                        CLA.ApplicationId = appsec.application__c;
                        CLA.polType = appsec.Client_Name__c;
                        CLA.clcd = appsec.Client_CIF_Code__c;

                        if((CLA.polno!=Null && CLA.polno!='0') || ((CLA.tasvVal!=Null && CLA.tasvVal!='0') ||
                           (CLA.totmasval!=Null && CLA.totmasval!='0')) ||
                           (CLA.status!=Null && CLA.status!='0') || (CLA.startDate!=Null && CLA.startDate!='0') ||
                   		   (CLA.polamt!=Null && CLA.polamt!='0') || (CLA.refacc!=Null && CLA.refacc!='0')){
                                CreditLifePolicyWrapperList.add(CLA);
                        }
                    }
                }
            }
        }

        if(CreditLifePolicyWrapperList.size()>0){
            insertAppSecurities(CreditLifePolicyWrapperList);
        }
    }

    
    /**
    * @description insert existing securities
    * @author Gulafsha | 2021-06-08 
    * @param wrapperlist 
    * @return string 
    **/
    public static string insertAppSecurities(List<sMgetAsvCreditLifePolicyV1_Resp_IB_v1.ClTable> wrapperlist){
        if(wrapperlist.size () >0){
            List<Application_Security__c> appList = new List<Application_Security__c>();
            for(sMgetAsvCreditLifePolicyV1_Resp_IB_v1.ClTable CLA :wrapperlist){
                Application_Security__c apps = new Application_Security__c();
                apps.Name = 'Credit Life Assurance';
                apps.Security_Type__c = 'Credit Life Assurance';
                apps.Status__c = CLA.Status;
                apps.Client_Name__c = CLA.polType;
				apps.Client_Code__c = CLA.clcd;
                apps.Policy_Number__c = CLA.polno;
                apps.Surety_Client_Code__c = CLA.assurco;
                 apps.Amount__c = CLA.polamt!=Null?Decimal.valueOf(CLA.polamt):Null;
                apps.Reference_Account_Number__c = CLA.refacc;

                if(CLA.tasvVal!=null && Decimal.valueof(CLA.tasvVal)!=0){
                    apps.ASV_MASV__c=  Decimal.valueof(CLA.tasvVal);
                    apps.ASV__c= Decimal.valueof(CLA.tasvVal);
                } else{
                    apps.ASV_MASV__c=  CLA.totmasval!=Null?Decimal.valueof(CLA.totmasval):Null;
                    Apps.MASV__c = CLA.totmasval!=Null?Decimal.valueof(CLA.totmasval):Null;
                }

                if(CLA.ApplicationId != null){
                    apps.Application_Id_Text__c = CLA.ApplicationId ;
                }

                if(CLA.startDate!=Null && CLA.startDate!='0'){
                    apps.Date_Signed__c =  Date.parse(ChequeAndOverdraftController.getFormatedDate(CLA.startDate));
                }

                appList.add(apps);
            }

            if(appList.size() >0){
                insert appList;
            }
        }

        return null;
    }


    
    /**
    * @description Cession of Link Life Policy
    * @author Gulafsha | 2021-06-08 
    * @param accountId 
    * @param OppId 
    * @return string 
    **/
    @AuraEnabled
    public static string  getCessionofLinkLifePolicy(String accountId,String OppId){

        ApplicationsSelector app = new ApplicationsSelector();
        Application__c appRecord = app.selectByCreditOpportunityId(OppId);
        List<sMgetAsvCessionOfLPLinkedV1_Resp_IB_v1.Table> cessionsWrapperList = new  List<sMgetAsvCessionOfLPLinkedV1_Resp_IB_v1.Table>();
        List<Application_Security__c> applicationsecList=new ApplicationSecuritySelector().selectByApplicationIdAndSecTypefields(appRecord.id,'Cession of Life Policy');

        for(Application_Security__c apps:applicationsecList){
            sMgetAsvCessionOfLPLinkedV1_Resp_IB_v1.Table CessionLLP = new sMgetAsvCessionOfLPLinkedV1_Resp_IB_v1.Table();
            CessionLLP.polnoout = apps.Policy_Number__c ;
            CessionLLP.seqnoOut = apps.Client_Name__c;
            CessionLLP.clcd = apps.Client_Code__c;
            CessionLLP.statusout = apps.Status__c ;
            //CessionLLP.lifassout = String.valueof(apps.Ranking_Number__c); Bond_Type__c
            CessionLLP.lifassout = apps.Bond_Type__c;
            CessionLLP.polamtout = apps.Amount__c!=Null?String.valueof(apps.Amount__c):'';
            CessionLLP.netvalOut = apps.Realistic_Market_Value__c!=Null?String.valueof(apps.Realistic_Market_Value__c):'';
            CessionLLP.refaccout = apps.Reference_Account_Number__c ;
            CessionLLP.asvamtout = apps.ASV_MASV__c!=Null?String.valueof(apps.ASV_MASV__c):'';
            CessionLLP.institOut = apps.Insurance_Company_Code__c ;
            CessionLLP.specifout = apps.Specific__c;
            CessionLLP.nomvalOut = apps.Free_Surrender_Value__c!=Null?String.valueof(apps.Free_Surrender_Value__c):'';
            CessionLLP.ApplicationId = apps.Id;
            cessionsWrapperList.add(CessionLLP);
        }

        if(cessionsWrapperList.size()>0){
            return JSON.serialize(cessionsWrapperList);
        }

        return null;
    }

    /**
    * @description Cession of Link Life Policy call service
    * @author Gulafsha | 2021-06-08 
    * @param Appsecurityids 
    **/
    @Future(callout = true)
    public static void securitiesCessionLLP(Set<id> Appsecurityids){
        List<sMgetAsvCessionOfLPLinkedV1_Resp_IB_v1.Table> cessionsWrapperList = new  List<sMgetAsvCessionOfLPLinkedV1_Resp_IB_v1.Table>();
        List<Application_Profile__c> appprincipalList= new ApplicationProfileSelector().getApplicationProfilesbyId(Appsecurityids);

        for(Application_Profile__c appsec:appprincipalList){
            if( String.isNotBlank(appsec.Client_CIF_Code__c) ){
                Map<sMgetAsvCessionOfLPLinkedV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvCessionOfLPLinkedV1_IH_v1.sMgetAsvCessionOfLPLinkedV1(appsec.Client_CIF_Code__c);
                sMgetAsvCessionOfLPLinkedV1_Resp_IB_v1 responseBean = (new List<sMgetAsvCessionOfLPLinkedV1_Resp_IB_v1>(responseMap.keySet()))[0];

                if(responseBean.statusCode == 200){
                    sMgetAsvCessionOfLPLinkedV1_Resp_IB_v1.SMgetASVCessionOfLifePoliciesLinkedV1Response wrapper = responseBean.SMgetASVCessionOfLifePoliciesLinkedV1Response;
                    system.debug('wrapper'+wrapper);
                    List<sMgetAsvCessionOfLPLinkedV1_Resp_IB_v1.Table> cls_smp232eo = wrapper.smp332eo.Table;
                    for(sMgetAsvCessionOfLPLinkedV1_Resp_IB_v1.Table CessionLLP : cls_smp232eo){
                        CessionLLP.ApplicationId = appsec.application__c;
                        CessionLLP.seqnoOut = appsec.Client_Name__c;
                        CessionLLP.clcd = appsec.Client_CIF_Code__c;

                        if((CessionLLP.polnoout!=Null && CessionLLP.polnoout!='0') || (CessionLLP.statusout!=Null && CessionLLP.statusout!='0') || (CessionLLP.polamtout!=Null && CessionLLP.polamtout!='0') ||
                            (CessionLLP.institOut!=Null && CessionLLP.institOut!='0') || (CessionLLP.nomvalOut!=Null && CessionLLP.nomvalOut!='0') || (CessionLLP.specifout!=Null && CessionLLP.specifout!='0')  ||
                           (CessionLLP.refaccout!=Null && CessionLLP.refaccout!='0') || (CessionLLP.netvalOut!=Null && CessionLLP.netvalOut!='0') || (CessionLLP.lifassout!=Null && CessionLLP.lifassout!='0')){
                            //((CessionLLP.asvamtout!=Null && CessionLLP.asvamtout!='0') || (CessionLLP.msvamtout!=Null && CessionLLP.msvamtout!='0'))  ) {
                                cessionsWrapperList.add(CessionLLP);
                        }
                    }
                }
            }
        }

        if(cessionsWrapperList.size()>0){
            insertAppSecurities(cessionsWrapperList);
        }
    }

    
    /**
    * @description Insert application security records
    * @author Gulafsha | 2021-06-08 
    * @param wrapperlist 
    * @return string 
    **/
    public static string insertAppSecurities(List<sMgetAsvCessionOfLPLinkedV1_Resp_IB_v1.Table> wrapperlist){
        if(wrapperlist.size () >0){
            List<Application_Security__c> appList = new List<Application_Security__c>();

            for(sMgetAsvCessionOfLPLinkedV1_Resp_IB_v1.Table CessionLLP :wrapperlist){
                Application_Security__c apps = new Application_Security__c();
                apps.Name = 'Cession of Life Policy';
                apps.Security_Type__c = 'Cession of Life Policy';
                apps.Policy_Number__c =  CessionLLP.polnoout;
                apps.Client_Name__c =  CessionLLP.seqnoOut;
				apps.Client_Code__c =  CessionLLP.clcd;
                apps.Status__c =  CessionLLP.statusout;
                apps.Bond_Type__c= CessionLLP.lifassout;
                //apps.Ranking_Number__c =  CessionLLP.lifassout!=Null?Decimal.valueof(CessionLLP.lifassout):Null;
                apps.Amount__c = CessionLLP.polamtout!=Null?Decimal.valueof(CessionLLP.polamtout):Null;
                apps.Realistic_Market_Value__c = CessionLLP.netvalOut!=Null?Decimal.valueof(CessionLLP.netvalOut):Null;
                apps.Insurance_Company_Code__c  = CessionLLP.institOut ;
                apps.Specific__c = CessionLLP.specifout;
                apps.Free_Surrender_Value__c = CessionLLP.nomvalOut!=Null?Decimal.valueof(CessionLLP.nomvalOut):Null;
                apps.Reference_Account_Number__c  = CessionLLP.refaccout ;
				apps.MASV__c = CessionLLP.msvamtout!=Null?decimal.valueof(CessionLLP.msvamtout):0;
                apps.ASV__c = CessionLLP.asvamtout!=Null?decimal.valueof(CessionLLP.asvamtout):0;

                if(CessionLLP.asvamtout!=null && Decimal.valueof(CessionLLP.asvamtout)!=0){
                    apps.ASV_MASV__c=  Decimal.valueof(CessionLLP.asvamtout);
                } else{
                    apps.ASV_MASV__c=  CessionLLP.msvamtout!=Null?Decimal.valueof(CessionLLP.msvamtout):Null;
                }

                if(CessionLLP.ApplicationId != null){
                    apps.Application_Id_Text__c = CessionLLP.ApplicationId;
                }

                appList.add(apps);
            }

            if(appList.size() >0){
                insert appList;
            }
        }
        return null;
    }
 
    
    /**
    * @description Cession  of No Link Life Policy
    * @author Gulafsha | 2021-06-08 
    * @param accountId 
    * @param OppId 
    * @return string 
    **/
    @AuraEnabled
    public static string  getCessionofNoLinkLifePolicy(String accountId,String OppId){
        ApplicationsSelector app = new ApplicationsSelector();
        Application__c appRecord = app.selectByCreditOpportunityId(OppId);
        List<sMgetAsvCessionOfLPNoLinkV1_Resp_IB_v1.Table> cessionsNoLinkWrapperList = new  List<sMgetAsvCessionOfLPNoLinkV1_Resp_IB_v1.Table>();
        List<Application_Security__c> applicationsecList=new ApplicationSecuritySelector().selectByApplicationIdAndSecTypefields(appRecord.id,'Cession of Life Policy (not Linked)');

        for(Application_Security__c apps:applicationsecList){
            sMgetAsvCessionOfLPNoLinkV1_Resp_IB_v1.Table CessionNoLLP = new sMgetAsvCessionOfLPNoLinkV1_Resp_IB_v1.Table();
            CessionNoLLP.polnoout = apps.Policy_Number__c ;
            CessionNoLLP.seqnoOut = apps.Client_Name__c;
            CessionNoLLP.clcd = apps.Client_Code__c;
            CessionNoLLP.statusout = apps.Status__c ;
            CessionNoLLP.specifOut = apps.Specific__c ;
            CessionNoLLP.refaccOut = apps.Reference_Account_Number__c ;
            CessionNoLLP.lifassOut = apps.Bond_Type__c;
            CessionNoLLP.polamtout = apps.Amount__c!=Null?String.valueof(apps.Amount__c):'';
            CessionNoLLP.asvamtout = apps.ASV_MASV__c!=Null?String.valueof(apps.ASV_MASV__c):'';
            CessionNoLLP.institOut = apps.Insurance_Company_Code__c!=Null?String.valueof(apps.Insurance_Company_Code__c):'';
            CessionNoLLP.netvalOut = apps.Realistic_Market_Value__c!=Null?String.valueof(apps.Realistic_Market_Value__c):'';
            CessionNoLLP.nomvalOut = apps.Nominal_Value__c;
            CessionNoLLP.ApplicationId = apps.Id;
            cessionsNoLinkWrapperList.add(CessionNoLLP);
        }

        if(cessionsNoLinkWrapperList.size()>0){
            return JSON.serialize(cessionsNoLinkWrapperList);
        }

        return null;
    }

    /**
    * @description Call service
    * @author Gulafsha | 2021-06-08 
    * @param Appsecurityids 
    **/
    @Future(callout = true)
    public static void securitiesCessionNoLLP(Set<id> Appsecurityids){
        List<sMgetAsvCessionOfLPNoLinkV1_Resp_IB_v1.Table> cessionsNoLinkWrapperList = new  List<sMgetAsvCessionOfLPNoLinkV1_Resp_IB_v1.Table>();
		List<Application_Profile__c> appprincipalList= new ApplicationProfileSelector().getApplicationProfilesbyId(Appsecurityids);

        for(Application_Profile__c appsec:appprincipalList){
            if( String.isNotBlank(appsec.Client_CIF_Code__c) ){
                Map<sMgetAsvCessionOfLPNoLinkV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvCessionOfLPNoLinkV1_IH_v1.sMgetAsvCessionOfLPNoLinkV1(appsec.Client_CIF_Code__c);
                sMgetAsvCessionOfLPNoLinkV1_Resp_IB_v1 responseBean = (new List<sMgetAsvCessionOfLPNoLinkV1_Resp_IB_v1>(responseMap.keySet()))[0];

                if(responseBean.statusCode == 200){
                    sMgetAsvCessionOfLPNoLinkV1_Resp_IB_v1.SMgetASVCessionOfLifePoliciesNonLinkV1Response wrapper = responseBean.SMgetASVCessionOfLifePoliciesNonLinkV1Response;
                    List<sMgetAsvCessionOfLPNoLinkV1_Resp_IB_v1.Table> cls_smp232eo = wrapper.smp232eo.Table;

                    for(sMgetAsvCessionOfLPNoLinkV1_Resp_IB_v1.Table CessionNoLLP : cls_smp232eo){
                        CessionNoLLP.ApplicationId = appsec.application__c; // added by Manish for W-011781
                        CessionNoLLP.seqnoOut = appsec.Client_Name__c;
                        CessionNoLLP.clcd = appsec.Client_CIF_Code__c;

                        if((CessionNoLLP.polnoout!=Null && CessionNoLLP.polnoout!='0') || (CessionNoLLP.statusout!=Null && CessionNoLLP.statusout!='0') || (CessionNoLLP.polamtout!=Null && CessionNoLLP.polamtout!='0') ||
                            (CessionNoLLP.institOut!=Null && CessionNoLLP.institOut!='0') || (CessionNoLLP.netvalOut!=Null && CessionNoLLP.netvalOut!='0') || (CessionNoLLP.nomvalOut!=Null && CessionNoLLP.nomvalOut!='0') ||
                            ((CessionNoLLP.asvamtout!=Null && CessionNoLLP.asvamtout!='0') || (CessionNoLLP.msvamtout!=Null && CessionNoLLP.msvamtout!='0') ) || (CessionNoLLP.specifOut!=Null && CessionNoLLP.specifOut!='0') ||
                            (CessionNoLLP.refaccOut!=Null && CessionNoLLP.refaccOut!='0') ||  (CessionNoLLP.lifassOut!=Null && CessionNoLLP.lifassOut!='0') ) {
                                cessionsNoLinkWrapperList.add(CessionNoLLP);
                        }
                    }
                }
            }
        }

        if(cessionsNoLinkWrapperList.size()>0){
            insertAppSecurities(cessionsNoLinkWrapperList);
        }
    }

    
    /**
    * @description Insert application securities records
    * @author Gulafsha | 2021-06-08 
    * @param wrapperlist 
    * @return string 
    **/
    public static string insertAppSecurities(List<sMgetAsvCessionOfLPNoLinkV1_Resp_IB_v1.Table> wrapperlist){
        if(wrapperlist.size () >0){
            List<Application_Security__c> appList = new List<Application_Security__c>();

            for(sMgetAsvCessionOfLPNoLinkV1_Resp_IB_v1.Table CessionNoLLP :wrapperlist){
                Application_Security__c apps = new Application_Security__c();
                apps.Name = 'Cession of Life Policy (not Linked)';
                apps.Security_Type__c = 'Cession of Life Policy (not Linked)';
                apps.Policy_Number__c =  CessionNoLLP.polnoout;
                apps.Client_Name__c =  CessionNoLLP.seqnoOut;
				apps.Client_Code__c =  CessionNoLLP.clcd;
                apps.Status__c  =  CessionNoLLP.statusout;
                apps.Specific__c = CessionNoLLP.specifOut;
                apps.Reference_Account_Number__c = CessionNoLLP.refaccOut;
                apps.Bond_Type__c = CessionNoLLP.lifassOut;
                apps.Nominal_Value__c  =  CessionNoLLP.nomvalOut;
                apps.Amount__c  = CessionNoLLP.polamtout!=Null?Decimal.valueof(CessionNoLLP.polamtout):Null;
                apps.Insurance_Company_Code__c = CessionNoLLP.institOut ;
                apps.Realistic_Market_Value__c = CessionNoLLP.netvalOut!=Null?Decimal.valueof(CessionNoLLP.netvalOut):Null;
                apps.MASV__c = CessionNoLLP.msvamtout!=Null?decimal.valueof(CessionNoLLP.msvamtout):0;
                apps.ASV__c = CessionNoLLP.asvamtout!=Null?decimal.valueof(CessionNoLLP.asvamtout):0;

                if(CessionNoLLP.asvamtout!=Null && Decimal.valueof(CessionNoLLP.asvamtout)!=0){
                    apps.ASV_MASV__c = Decimal.valueof(CessionNoLLP.asvamtout);
                } else{
                    apps.ASV_MASV__c = CessionNoLLP.msvamtout!=Null?Decimal.valueof(CessionNoLLP.msvamtout):Null;
                }

                if(CessionNoLLP.ApplicationId != null){
                    apps.Application_Id_Text__c = CessionNoLLP.ApplicationId;
                }

                appList.add(apps);
            }

            if(appList.size() >0){
                insert appList;
            }
        }

        return null;
    }

    
    /**
    * @description Cession of Debtors
    * @author Gulafsha | 2021-06-08 
    * @param accountId 
    * @param OppId 
    * @return string 
    **/
    @AuraEnabled
    public static string  getCessionofDebtors(String accountId,String OppId){
        ApplicationsSelector app = new ApplicationsSelector();
        Application__c appRecord = app.selectByCreditOpportunityId(OppId);
        List<sMgetAsvCessionOfDebtorsV1_Resp_IB_v1.Table> cessionofDebtorsWrapperList = new  List<sMgetAsvCessionOfDebtorsV1_Resp_IB_v1.Table>();
        List<Application_Security__c> applicationsecList=new ApplicationSecuritySelector().selectByApplicationIdAndSecTypefields(appRecord.id,'Cession of Debtors');

        for(Application_Security__c apps:applicationsecList){
            sMgetAsvCessionOfDebtorsV1_Resp_IB_v1.Table COD = new sMgetAsvCessionOfDebtorsV1_Resp_IB_v1.Table();
            COD.statusout = apps.Status__c ;
            COD.cgicinOut = apps.Client_Name__c;
            COD.clcd = apps.Client_Code__c;
            COD.num0out = String.valueof(apps.Current_Net_Number_Debtors__c);
            COD.num30out =String.valueof(apps.X30_Days_Number_Debtors__c);
            COD.num60out = String.valueof(apps.X60_Days_Number_Debtors__c);
            COD.num90out = String.valueof(apps.X90_Days_Number_Debtors__c);
            COD.num120out = String.valueof(apps.X120_Days_Number_Debtors__c);
            COD.numtotOut = String.valueof(apps.Ranking_Number__c);
            COD.amt30out = String.valueof(apps.X30_Days_Amount__c) ;
            COD.amt60out = String.valueof(apps.X60_Days_Amount__c) ;
            COD.amt90out = String.valueof(apps.X90_Days_Amount__c) ;
            COD.amt120out = String.valueof(apps.X120_Days_Amount__c) ;
            COD.amttotOut = String.valueof(apps.Amount__c) ;
            COD.anldteout = String.valueof(apps.Date_Analysis__c);
            COD.cesdteOut = String.valueof(apps.Date_Signed__c);
            COD.amt0out = String.valueof(apps.Account_Balance__c) ;
            COD.asvamtout = String.valueof(apps.ASV_MASV__c) ;
            COD.specifout = apps.Specific__c;
            COD.refaccout = apps.Reference_Account_Number__c ;
            COD.nomvalOut = apps.Nominal_Value__c;
            COD.ApplicationId = apps.Id;
            cessionofDebtorsWrapperList.add(COD);
        }

        if(cessionofDebtorsWrapperList.size()>0){
            return JSON.serialize(cessionofDebtorsWrapperList);
        }

        return null;
    }

    /**
    * @description Cession of Debtors call service
    * @author Gulafsha | 2021-06-08 
    * @param Appsecurityids 
    **/
    @Future(callout = true)
    public static void securitiesCOD(Set<id> Appsecurityids){
        List<sMgetAsvCessionOfDebtorsV1_Resp_IB_v1.Table> cessionofDebtorsWrapperList = new  List<sMgetAsvCessionOfDebtorsV1_Resp_IB_v1.Table>();
		List<Application_Profile__c> appprincipalList= new ApplicationProfileSelector().getApplicationProfilesbyId(Appsecurityids);

        for(Application_Profile__c appsec:appprincipalList){
            if( String.isNotBlank(appsec.Client_CIF_Code__c) ){
                Map<sMgetAsvCessionOfDebtorsV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvCessionOfDebtorsV1_IH_v1.sMgetAsvCessionOfDebtorsV1(appsec.Client_CIF_Code__c);
                sMgetAsvCessionOfDebtorsV1_Resp_IB_v1 responseBean = (new List<sMgetAsvCessionOfDebtorsV1_Resp_IB_v1>(responseMap.keySet()))[0];

                if(responseBean.statusCode == 200){
                    sMgetAsvCessionOfDebtorsV1_Resp_IB_v1.SMgetASVCessionOfDebtorsV1Response wrapper = responseBean.SMgetASVCessionOfDebtorsV1Response;
                    List<sMgetAsvCessionOfDebtorsV1_Resp_IB_v1.Table> cls_smp170eo = wrapper.smp170eo.Table;

                    for(sMgetAsvCessionOfDebtorsV1_Resp_IB_v1.Table COD : cls_smp170eo){
                        COD.ApplicationId = appsec.application__c;
                        COD.cgicinOut = appsec.Client_Name__c;
                        COD.clcd = appsec.Client_CIF_Code__c;

                        if((COD.amt120Out!=Null && COD.amt120Out!='0') || (COD.statusout!=Null && COD.statusout!='0') || (COD.num0out!=Null && COD.num0out!='0') ||
                            (COD.amt60Out!=Null && COD.amt60Out!='0') || (COD.numtotOut!=Null && COD.numtotOut!='0') || (COD.num30Out!=Null && COD.num30Out!='0') ||
                            (COD.amt90Out!=Null && COD.amt90Out!='0') || (COD.num120Out!=Null && COD.num120Out!='0') || (COD.num60Out!=Null && COD.num60Out!='0') ||
                            (COD.amttotOut!=Null && COD.amttotOut!='0') || (COD.amt30Out!=Null && COD.amt30Out!='0') || (COD.num90Out!=Null && COD.num90Out!='0') ||
                            (COD.nomvalOut!=Null && COD.nomvalOut!='0') || (COD.cesdteOut!=Null && COD.cesdteOut!='0') ||
                            (COD.specifOut!=Null && COD.specifOut!='0') || (COD.amt0Out!=Null && COD.amt0Out!='0') || (COD.anldteOut!=Null && COD.anldteOut!='0') ||
                            (COD.refaccOut!=Null && COD.refaccOut!='0') || ((COD.asvamtOut!=Null && COD.asvamtOut!='0')||(COD.msvamtout!=Null && COD.msvamtout!='0'))) {
                            cessionofDebtorsWrapperList.add(COD);
                        }
                    }
                }
            }
        }

        if(cessionofDebtorsWrapperList.size()>0){
            insertAppSecurities(cessionofDebtorsWrapperList);
        }
    }

    
    /**
    * @description Insert Cession of Debtors securities
    * @author Gulafsha | 2021-06-08 
    * @param wrapperlist 
    * @return string 
    **/
    public static string insertAppSecurities(List<sMgetAsvCessionOfDebtorsV1_Resp_IB_v1.Table> wrapperlist){
        if(wrapperlist.size () >0){
            List<Application_Security__c> appList = new List<Application_Security__c>();

            for(sMgetAsvCessionOfDebtorsV1_Resp_IB_v1.Table COD :wrapperlist){
                Application_Security__c apps = new Application_Security__c();
                apps.Name = 'Cession of Debtors';
                apps.Security_Type__c = 'Cession of Debtors';
                apps.Status__c = COD.statusout;
                apps.Client_Name__c = COD.cgicinOut;
				apps.Client_Code__c = COD.clcd;
                apps.Nominal_Value__c = COD.nomvalOut;
                apps.Current_Net_Number_Debtors__c = Decimal.valueof(COD.num0out);
                apps.X30_Days_Number_Debtors__c = Decimal.valueof(COD.num30out);
                apps.X60_Days_Number_Debtors__c = Decimal.valueof(COD.num60out);
                apps.X90_Days_Number_Debtors__c = Decimal.valueof(COD.num90out);
                apps.X120_Days_Number_Debtors__c = Decimal.valueof(COD.num120out);
                apps.Ranking_Number__c = Decimal.valueof(COD.numtotout);
                apps.X30_Days_Amount__c = Decimal.valueof(COD.amt30out);
                apps.X60_Days_Amount__c = Decimal.valueof(COD.amt60out);
                apps.X90_Days_Amount__c = Decimal.valueof(COD.amt90out) ;
                apps.X120_Days_Amount__c = Decimal.valueof(COD.amt120out) ;
                apps.Amount__c = Decimal.valueof(COD.amttotout);
                apps.Account_Balance__c= Decimal.valueof(COD.amt0out) ;
                apps.MASV__c = COD.msvamtout!=Null?decimal.valueof(COD.msvamtout):0;
                apps.ASV__c = COD.asvamtout!=Null?decimal.valueof(COD.asvamtout):0;
                apps.Specific__c  = COD.specifout;
                apps.Reference_Account_Number__c = COD.refaccout;

                if(COD.asvamtout != null && Decimal.valueof(COD.asvamtout)!=0){
                    apps.ASV_MASV__c = Decimal.valueof(COD.asvamtout);
                } else{
                    apps.ASV_MASV__c = COD.msvamtout!=Null?Decimal.valueof(COD.msvamtout):Null;
                }

                if(COD.ApplicationId != null){
                    apps.Application_Id_Text__c = COD.ApplicationId;
                }

				if(COD.anldteout!=Null && COD.anldteout!='0'){
                    apps.Date_Analysis__c =  Date.parse(ChequeAndOverdraftController.getFormatedDate(COD.anldteout));
                }

                if(COD.cesdteOut!=Null && COD.cesdteOut!='0'){
                    apps.Date_Signed__c =  Date.parse(ChequeAndOverdraftController.getFormatedDate(COD.cesdteOut));
                }

                appList.add(apps);
            }

            if(appList.size() >0){
                insert appList;
            }
        }

        return null;
    } 
    
    /**
    * @description Cession of General Pledges
    * @author Gulafsha | 2021-06-08 
    * @param accountId 
    * @param OppId 
    * @return string 
    **/
    @AuraEnabled
    public static string  getCessionofGeneralpledges(String accountId,String OppId){
        ApplicationsSelector app = new ApplicationsSelector();
        Application__c appRecord = app.selectByCreditOpportunityId(OppId);
        List<sMgetAsvCessionOfPledgesV1_Resp_IB_v1.Table> cessionOfPledgeaWrapperList = new  List<sMgetAsvCessionOfPledgesV1_Resp_IB_v1.Table>();
        List<Application_Security__c> applicationsecList=new ApplicationSecuritySelector().selectByApplicationIdAndSecTypefields(appRecord.id,'Cession of General Pledges');

        for(Application_Security__c apps:applicationsecList){
            sMgetAsvCessionOfPledgesV1_Resp_IB_v1.Table CogP = new sMgetAsvCessionOfPledgesV1_Resp_IB_v1.Table();
            cogp.statusout = apps.Status__c ;
            cogp.seqnoOut = apps.Client_Name__c;
            cogp.clcd = apps.Client_Code__c;
            cogp.pldamtout = apps.Amount__c!=null ? (apps.Limited_pledge__c == 'Y'? String.valueof(apps.Amount__c):'Unlimited'):'';
            cogp.plddteout = String.valueof(apps.Date_Signed__c);
            cogp.valdteOut = String.valueof(apps.Date_Analysis__c);
            cogp.asvamtout = String.valueof(apps.ASV_MASV__c);
            cogp.clcdout = apps.Pledger_Client_code__c ;
            cogp.limitedout = apps.Limited_pledge__c;
            cogp.specifout = apps.Specific__c ;
            cogp.refaccout = apps.Reference_Account_Number__c ;
            cogp.asspldout = apps.Limited_Surety__c ;
            cogp.remvalout = String.valueof(apps.Realistic_Market_Value__c);
            cogp.nomvalOut = apps.Nominal_Value__c ;
            cogp.ApplicationId = apps.Id;
            cessionOfPledgeaWrapperList.add(CogP);
        }

        if(cessionOfPledgeaWrapperList.size()>0){
            return JSON.serialize(cessionOfPledgeaWrapperList);
        }

        return null;
    }

    /**
    * @description call Cession of General Pledges service
    * @author Gulafsha | 2021-06-08 
    * @param Appsecurityids 
    **/
    @Future(callout = true)
    public static void securitiesCogP(Set<id> Appsecurityids){
        List<sMgetAsvCessionOfPledgesV1_Resp_IB_v1.Table> cessionOfPledgeaWrapperList = new List<sMgetAsvCessionOfPledgesV1_Resp_IB_v1.Table>();
		List<Application_Profile__c> appprincipalList= new ApplicationProfileSelector().getApplicationProfilesbyId(Appsecurityids);

        for(Application_Profile__c appsec:appprincipalList){
            if( String.isNotBlank(appsec.Client_CIF_Code__c) ){
                Map<sMgetAsvCessionOfPledgesV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvCessionOfPledgesV1_IH_v1.sMgetAsvCessionOfPledgesV1(appsec.Client_CIF_Code__c);
                sMgetAsvCessionOfPledgesV1_Resp_IB_v1 responseBean = (new List<sMgetAsvCessionOfPledgesV1_Resp_IB_v1>(responseMap.keySet()))[0];

                if(responseBean.statusCode == 200){
                    sMgetAsvCessionOfPledgesV1_Resp_IB_v1.SMgetASVCessionOfGeneralPledgesV1Response wrapper = responseBean.SMgetASVCessionOfGeneralPledgesV1Response;
                    List<sMgetAsvCessionOfPledgesV1_Resp_IB_v1.Table> cls_smp149eo = wrapper.Smp149eo.table;

                    for(sMgetAsvCessionOfPledgesV1_Resp_IB_v1.Table cogp : cls_smp149eo){
                        cogp.ApplicationId = appsec.application__c;
                        cogp.seqnoOut = appsec.Client_Name__c;
                        cogp.clcd = appsec.Client_CIF_Code__c;
                        if((cogp.pldamtout!=Null && cogp.pldamtout!='0') || (cogp.statusout!=Null && cogp.statusout!='0') || (cogp.plddteout!=Null && cogp.plddteout!='0') ||
                            (cogp.asspldout!=Null && cogp.asspldout!='0') || (cogp.remvalout!=Null && cogp.remvalout!='0') || (cogp.valdteOut!=Null && cogp.valdteOut!='0') ||
                            ((cogp.msvamtout!=Null && cogp.msvamtout!='0') || (cogp.asvamtout!=Null && cogp.asvamtout!='0')) || (cogp.specifout!=Null && cogp.specifout!='0') ||
                            (cogp.refaccout!=Null && cogp.refaccout!='0') || (cogp.limitedout!=Null && cogp.limitedout!='0') || (cogp.nomvalOut!=Null && cogp.nomvalOut!='0')) {
                            cessionOfPledgeaWrapperList.add(cogp);
                        }
                    }
                }
            }
        }

        if(cessionOfPledgeaWrapperList.size()>0){
            insertAppSecurities(cessionOfPledgeaWrapperList);
        }
    }

    
    /**
    * @description insert Cession of General Pledges
    * @author Gulafsha | 2021-06-08 
    * @param wrapperlist 
    * @return string 
    **/
    public static string insertAppSecurities(List<sMgetAsvCessionOfPledgesV1_Resp_IB_v1.Table> wrapperlist){
        if(wrapperlist.size () >0){
            List<Application_Security__c> appList = new List<Application_Security__c>();

            for(sMgetAsvCessionOfPledgesV1_Resp_IB_v1.Table CogP :wrapperlist){
                Application_Security__c apps = new Application_Security__c();
                apps.Name = 'Cession of General Pledges';
                apps.Security_Type__c = 'Cession of General Pledges';
                apps.Status__c =  cogp.statusout;
                apps.Nominal_Value__c =  cogp.nomvalOut;
                apps.Amount__c = cogp.pldamtout!=Null?Decimal.valueof(cogp.pldamtout):Null;
                apps.MASV__c = cogp.msvamtout!=Null?decimal.valueof(cogp.msvamtout):0;
                apps.ASV__c = cogp.asvamtout!=Null?decimal.valueof(cogp.asvamtout):0;
                apps.Pledger_Client_code__c =  cogp.clcdout ;
                apps.Limited_pledge__c =  cogp.limitedout ;
                apps.Realistic_Market_Value__c = Decimal.valueof(cogp.remvalout);
                apps.Specific__c  = cogp.specifout ;
                apps.Reference_Account_Number__c  = cogp.refaccout ;
                apps.Limited_Surety__c =  cogp.asspldout ;
                apps.Client_Name__c = cogp.seqnoOut;
				apps.Client_Code__c = cogp.clcd;

                if(Cogp.ApplicationId != null){
                    apps.Application_Id_Text__c = Cogp.ApplicationId;
                }

                if(cogp.plddteout!=Null && cogp.plddteout!='0'){
                    apps.Date_Signed__c = Date.parse(ChequeAndOverdraftController.getFormatedDate(cogp.plddteout));
                }

                if(cogp.valdteOut!=Null && cogp.valdteOut!='0'){
                    apps.Date_Analysis__c = Date.parse(ChequeAndOverdraftController.getFormatedDate(cogp.valdteOut));
                }

                if(cogp.asvamtout!=null && Decimal.valueof(cogp.asvamtout)!=0){
                    apps.ASV_MASV__c = Decimal.valueof(cogp.asvamtout);
                } else{
                    apps.ASV_MASV__c = cogp.msvamtout!=Null?Decimal.valueof(cogp.msvamtout):Null;
                }
                appList.add(apps);
            }

            if(appList.size() >0){
                insert appList;
            }
        }

        return null;
    }


    
    /**
    * @description Cession of Internal Investments
    * @author Gulafsha | 2021-06-08 
    * @param accountId 
    * @param OppId 
    * @return string 
    **/
    @AuraEnabled
    public static string  getCessionofInternalInvestments(String accountId,String OppId){
        ApplicationsSelector app = new ApplicationsSelector();
        Application__c appRecord = app.selectByCreditOpportunityId(OppId);
        List<sMgetAsvCessionOfInvstmntV1_Resp_IB_v1.Smn146oTable> cessionOfInternalInvestmentWrapperList = new  List<sMgetAsvCessionOfInvstmntV1_Resp_IB_v1.Smn146oTable>();
        List<Application_Security__c> applicationsecList=new ApplicationSecuritySelector().selectByApplicationIdAndSecTypefields(appRecord.id,'Cession of Internal Investments');

        for(Application_Security__c apps:applicationsecList){
            sMgetAsvCessionOfInvstmntV1_Resp_IB_v1.Smn146oTable CoiI = new sMgetAsvCessionOfInvstmntV1_Resp_IB_v1.Smn146oTable();
            CoiI.refaccnoout = apps.Reference_Account_Number__c ;
            CoiI.ainvnoOut = apps.Account_Number__c ;
            CoiI.totcesout = String.valueof(apps.Free_Surrender_Value__c);
            CoiI.dtesignedOut = String.valueof(apps.Date_Signed__c) ;
            CoiI.matdteOut = String.valueof(apps.Date_Analysis__c) ;
            CoiI.chold1Out = String.valueof(apps.Bond_Type__c);
            CoiI.chold2Out = String.valueof(apps.Holder_Code__c);
            CoiI.chold3Out = String.valueof(apps.Insurance_Company_Code__c);
            CoiI.chold4Out = String.valueof(apps.Sec_Information_Code__c);
            CoiI.chold5Out = String.valueof(apps.Share_Name__c);
            CoiI.camt1Out = String.valueof(apps.X30_Days_Amount__c);
            CoiI.camt2Out = String.valueof(apps.X60_Days_Amount__c);
            CoiI.camt3Out = String.valueof(apps.X90_Days_Amount__c);
            CoiI.camt4Out = String.valueof(apps.X120_Days_Amount__c);
            CoiI.camt5Out = String.valueof(apps.Realistic_Market_Value__c);
            CoiI.avlamtOut = apps.Client_Name__c;
            CoiI.clcd = apps.Client_Code__c;
            CoiI.astatusout = apps.Status__c ;
            CoiI.accbalout = apps.Account_Balance__c!=Null?String.valueof(apps.Account_Balance__c):'';
            CoiI.cessamtout = apps.Amount__c!=Null?(apps.Limited_pledge__c == 'Y'? String.valueof(apps.Amount__c):'Unlimited'):'';
            CoiI.appsecvalOut = apps.ASV_MASV__c!=Null?String.valueof(apps.ASV_MASV__c):'';
            CoiI.limcesout = apps.Limited_pledge__c;
            CoiI.nomvalOut = apps.Nominal_Value__c;
            CoiI.ApplicationId = apps.Id;
            cessionOfInternalInvestmentWrapperList.add(CoiI);
        }
        if(cessionOfInternalInvestmentWrapperList.size()>0){
            return JSON.serialize(cessionOfInternalInvestmentWrapperList);
        }

        return null;
    }

    
    /**
    * @description call Cession of Internal Investments service 
    * @author Gulafsha | 2021-06-08 
    * @param Appsecurityids 
    **/
    @Future(callout = true)
    public static void securitiesCoiI(Set<id> Appsecurityids){
        List<sMgetAsvCessionOfInvstmntV1_Resp_IB_v1.Smn146oTable> cessionOfInternalInvestmentWrapperList = new  List<sMgetAsvCessionOfInvstmntV1_Resp_IB_v1.Smn146oTable>();
		List<Application_Profile__c> appprincipalList= new ApplicationProfileSelector().getApplicationProfilesbyId(Appsecurityids);

        for(Application_Profile__c appsec:appprincipalList){
            if( String.isNotBlank(appsec.Client_CIF_Code__c) ){
                Map<sMgetAsvCessionOfInvstmntV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvCessionOfInvstmntV1_IH_v1.sMgetAsvCessionOfInvstmntV1(appsec.Client_CIF_Code__c);
                sMgetAsvCessionOfInvstmntV1_Resp_IB_v1 responseBean = (new List<sMgetAsvCessionOfInvstmntV1_Resp_IB_v1>(responseMap.keySet()))[0];

                if(responseBean.statusCode == 200){
                    sMgetAsvCessionOfInvstmntV1_Resp_IB_v1.SMgetASVCessionOfInternalInvestmentsV1Response wrapper = responseBean.SMgetASVCessionOfInternalInvestmentsV1Response;
                    List<sMgetAsvCessionOfInvstmntV1_Resp_IB_v1.Smn146oTable> cls_smn146o = wrapper.Smn146o.Smn146oTable;

					for(sMgetAsvCessionOfInvstmntV1_Resp_IB_v1.Smn146oTable CoiI : cls_Smn146o){
                        CoiI.ApplicationId = appsec.application__c;
                        CoiI.avlamtOut = appsec.Client_Name__c;
                        CoiI.clcd = appsec.Client_CIF_Code__c;

                        if((CoiI.refaccnoout!=Null && CoiI.refaccnoout!='00000000000000000') || (CoiI.astatusout!=Null && CoiI.astatusout!='0') || (CoiI.limcesout!=Null && CoiI.limcesout!='0') ||
                        (CoiI.accbalout!=Null && CoiI.accbalout!='0') || (CoiI.cessamtout!=Null && CoiI.cessamtout!='0') || (CoiI.nomvalOut!=Null && CoiI.nomvalOut!='0') ||
                        (CoiI.ainvnoOut!=Null && CoiI.ainvnoOut!='0') || (CoiI.chold4Out!=Null && CoiI.chold4Out!='0') || (CoiI.camt3Out!=Null && CoiI.camt3Out!='0') ||
                        (CoiI.chold1Out!=Null && CoiI.chold1Out!='0') || (CoiI.chold5Out!=Null && CoiI.chold5Out!='0') || (CoiI.camt4Out!=Null && CoiI.camt4Out!='0') ||
                        (CoiI.chold2Out!=Null && CoiI.chold2Out!='0') || (CoiI.camt1Out!=Null && CoiI.camt1Out!='0') || (CoiI.camt5Out!=Null && CoiI.camt5Out!='0') ||
                        (CoiI.chold3Out!=Null && CoiI.chold3Out!='0') || (CoiI.camt2Out!=Null && CoiI.camt2Out!='0') || (CoiI.totcesout!=Null && CoiI.totcesout!='0') ||
                        (CoiI.dtesignedOut!=Null && CoiI.dtesignedOut!='0') || (CoiI.matdteOut!=Null && CoiI.matdteOut!='0')  ||
                        ((CoiI.appsecvalOut!=Null && CoiI.appsecvalOut!='0') || (CoiI.mappsecvalOut!=Null && CoiI.mappsecvalOut!='0'))) {
                        cessionOfInternalInvestmentWrapperList.add(CoiI);
                        }
                    }
                }
            }
        }

        if(cessionOfInternalInvestmentWrapperList.size()>0){
            insertAppSecurities(cessionOfInternalInvestmentWrapperList);
        }
    }

    // Inserting the Application Security records


    /**
    * @description Cession of Internal Investments insert
    * @author Gulafsha | 2021-06-08 
    * @param wrapperlist 
    * @return string 
    **/
    public static string insertAppSecurities(List<sMgetAsvCessionOfInvstmntV1_Resp_IB_v1.Smn146oTable> wrapperlist){
        if(wrapperlist.size () >0){
            List<Application_Security__c> appList = new List<Application_Security__c>();

            for(sMgetAsvCessionOfInvstmntV1_Resp_IB_v1.Smn146oTable CoiI :wrapperlist){
                if(CoiI.astatusout!=null && !String.valueOf(CoiI.astatusout).equals('')){
                    Application_Security__c apps = new Application_Security__c();
                    apps.Name = 'Cession of Internal Investments';
                    apps.Security_Type__c = 'Cession of Internal Investments';
                    apps.Reference_Account_Number__c =  CoiI.refaccnoout;
                    apps.Client_Name__c = CoiI.avlamtOut;
                    apps.Client_Code__c = CoiI.clcd;
                    apps.Status__c  =  CoiI.astatusout;
                    apps.Limited_pledge__c = CoiI.limcesout;
                    apps.Account_Balance__c = CoiI.accbalout!=Null?Decimal.valueof(CoiI.accbalout):0;
                    apps.Amount__c = CoiI.cessamtout!=Null?Decimal.valueof(CoiI.cessamtout):0;
                    apps.Nominal_Value__c = CoiI.nomvalOut;
                    apps.Account_Number__c = CoiI.ainvnoOut;
                    apps.Free_Surrender_Value__c = CoiI.totcesout!=Null?Decimal.valueof(CoiI.totcesout):0;
                    apps.Bond_Type__c = CoiI.chold1Out;
                    apps.Holder_Code__c = CoiI.chold2Out;
                    apps.Insurance_Company_Code__c = CoiI.chold3Out;
                    apps.Sec_Information_Code__c = CoiI.chold4Out;
                    apps.Share_Name__c = CoiI.chold5Out;
                    apps.X30_Days_Amount__c = CoiI.camt1Out!=Null?Decimal.valueof(CoiI.camt1Out):0;
                    apps.X60_Days_Amount__c = CoiI.camt2Out!=Null?Decimal.valueof(CoiI.camt2Out):0;
                    apps.X90_Days_Amount__c = CoiI.camt3Out!=Null?Decimal.valueof(CoiI.camt3Out):0;
                    apps.X120_Days_Amount__c = CoiI.camt4Out!=Null?Decimal.valueof(CoiI.camt4Out):0;
                    apps.Realistic_Market_Value__c = CoiI.camt5Out!=Null?Decimal.valueof(CoiI.camt5Out):0;
                    apps.MASV__c = CoiI.mappsecvalOut!=Null?decimal.valueof(CoiI.mappsecvalOut):0;
                    apps.ASV__c = CoiI.appsecvalOut!=Null?decimal.valueof(CoiI.appsecvalOut):0;
					apps.Specific__c = CoiI.specificout;
                    if(CoiI.ApplicationId!= null){
                        apps.Application_Id_Text__c = CoiI.ApplicationId;
                    }

                    if(CoiI.dtesignedOut!=Null && CoiI.dtesignedOut!='0'){
                        apps.Date_Signed__c =  Date.parse(ChequeAndOverdraftController.getFormatedDate(CoiI.dtesignedOut));
                    }

                    if(CoiI.matdteOut!=Null && CoiI.matdteOut!='0'){
                        apps.Date_Analysis__c =  Date.parse(ChequeAndOverdraftController.getFormatedDate(CoiI.matdteOut));
                    }

                    if(CoiI.appsecvalOut!=Null && Decimal.valueof(CoiI.appsecvalOut)!=0){
                        apps.ASV_MASV__c = Decimal.valueof(CoiI.appsecvalOut);
                    } else{
                        apps.ASV_MASV__c = CoiI.mappsecvalOut!=Null?Decimal.valueof(CoiI.mappsecvalOut):Null;
                    }

                    appList.add(apps);
                }
            }

            if(appList.size() >0){
                insert appList;
            }
        }

        return null;
    }
    
    /**
    * @description Cession Of Schemes
    * @author Gulafsha | 2021-06-08 
    * @param accountId 
    * @param OppId 
    * @return string 
    **/
    @AuraEnabled
    public static string  getCessionOfSchemes(String accountId,String OppId){
        ApplicationsSelector app = new ApplicationsSelector();
        Application__c appRecord = app.selectByCreditOpportunityId(OppId);
        List<sMgetAsvCessionOfSchemesV1_Resp_IB_v1.Table> cessionOfSchemesWrapperList = new  List<sMgetAsvCessionOfSchemesV1_Resp_IB_v1.Table>();
        List<Application_Security__c> applicationsecList=new ApplicationSecuritySelector().selectByApplicationIdAndSecTypefields(appRecord.id,'Cession of Schemes');

        for(Application_Security__c apps:applicationsecList){
            sMgetAsvCessionOfSchemesV1_Resp_IB_v1.Table COS = new sMgetAsvCessionOfSchemesV1_Resp_IB_v1.Table();
            COS.refaccout = apps.Reference_Account_Number__c ;
            COS.seqnoOut = apps.Client_Name__c;
            COS.clcd = apps.Client_Code__c;
            COS.nomvalOut = apps.Nominal_Value__c ;
            COS.schtypOut = apps.Bond_Type__c ;
            COS.schnumOut = apps.Account_Number__c;
            COS.schamtOut = String.valueof(apps.Realistic_Market_Value__c) ;
            COS.origlnOut = String.valueof(apps.Amount__c) ;
            COS.guarntOut = String.valueof(apps.Hold_Indication__c) ;  // Guarantee Recieve -W-011780
            COS.specifout = apps.Specific__c ;
            COS.crisdtOut = apps.ASV_MASV__c!=Null?String.valueof(apps.ASV_MASV__c):'';
            COS.ApplicationId = apps.Id;
            COS.statusOut = apps.Status__c;
            cessionOfSchemesWrapperList.add(COS);
        }

        if(cessionOfSchemesWrapperList.size()>0){
            return JSON.serialize(cessionOfSchemesWrapperList);
        }

        return null;
    }

    /**
    * @description call Cession Of Schemes service
    * @author Gulafsha | 2021-06-08 
    * @param Appsecurityids 
    **/
    @Future(callout = true)
    public static void securitiesCOS(Set<id> Appsecurityids){
        List<sMgetAsvCessionOfSchemesV1_Resp_IB_v1.Table> cessionOfSchemesWrapperList = new  List<sMgetAsvCessionOfSchemesV1_Resp_IB_v1.Table>();
        List<Application_Profile__c> appprincipalList= new ApplicationProfileSelector().getApplicationProfilesbyId(Appsecurityids);

        for(Application_Profile__c appsec:appprincipalList){
            if( String.isNotBlank(appsec.Client_CIF_Code__c) ){
                Map<sMgetAsvCessionOfSchemesV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvCessionOfSchemesV1_IH_v1.sMgetAsvCessionOfSchemesV1(appsec.Client_CIF_Code__c);
                sMgetAsvCessionOfSchemesV1_Resp_IB_v1 responseBean = (new List<sMgetAsvCessionOfSchemesV1_Resp_IB_v1>(responseMap.keySet()))[0];

                if(responseBean.statusCode == 200){
                    sMgetAsvCessionOfSchemesV1_Resp_IB_v1.SMgetASVCessionOfSchemesV1Response wrapper = responseBean.SMgetASVCessionOfSchemesV1Response;
                    List<sMgetAsvCessionOfSchemesV1_Resp_IB_v1.Table> cls_smp135eo = wrapper.Smp135eo.Table;

                    for(sMgetAsvCessionOfSchemesV1_Resp_IB_v1.Table COS : cls_Smp135eo){
                        COS.ApplicationId = appsec.application__c;
                        COS.seqnoOut = appsec.Client_Name__c;
                        COS.clcd = appsec.Client_CIF_Code__c;

                        if((COS.refaccout!=Null && COS.refaccout!='0')
                        || (COS.Status!=Null && COS.Status!='0') || (COS.specifout!=Null && COS.specifout!='0')
                        || (COS.nomvalOut!=Null && COS.nomvalOut!='0') || (COS.schtypOut!=Null && COS.schtypOut!='0')
                        || (COS.schnumOut!=Null && COS.schnumOut!='00000000000000000') || (COS.origlnOut!=Null && COS.origlnOut!='0')
                        || (COS.schamtOut!=Null && COS.schamtOut!='0') || (COS.guarntOut!=Null && COS.guarntOut!='0')||
                        ((COS.crisdtOut!=Null && COS.crisdtOut!='0') || (COS.msvamtTotOut!=Null && COS.msvamtTotOut!='0'))) {
                            cessionOfSchemesWrapperList.add(COS);
                        }
                    }
                }
            }
        }

        if(cessionOfSchemesWrapperList.size()>0){
            insertAppSecurities(cessionOfSchemesWrapperList);
        }
    }

    
    /**
    * @description insert Cession Of Schemes records
    * @author Gulafsha | 2021-06-08 
    * @param wrapperlist 
    * @return string 
    **/
    public static string insertAppSecurities(List<sMgetAsvCessionOfSchemesV1_Resp_IB_v1.Table> wrapperlist){
        if(wrapperlist.size () >0){
            List<Application_Security__c> appList = new List<Application_Security__c>();

            for(sMgetAsvCessionOfSchemesV1_Resp_IB_v1.Table COS :wrapperlist){
                Application_Security__c apps = new Application_Security__c();
                apps.Name = 'Cession of Schemes';
                apps.Security_Type__c = 'Cession of Schemes';
                apps.Reference_Account_Number__c =  COS.refaccout;
                apps.Status__c  = COS.statusOut;
                apps.Specific__c = COS.specifout ;
                apps.Client_Name__c = COS.seqnoOut;
                apps.Nominal_Value__c = COS.schamtOut; //W: 12250 Changing nomValOut to schamtOut as per feedback
                apps.Bond_Type__c = COS.schtypOut;
                apps.Account_Number__c = COS.schnumOut;
                apps.Realistic_Market_Value__c = COS.schamtOut!=Null?Decimal.valueof(COS.schamtOut):0;
                apps.Amount__c = COS.origlnOut!=Null?Decimal.valueof(COS.origlnOut):0;
                apps.Hold_Indication__c = COS.guarntOut!=Null ? COS.guarntOut : Null; // Guarantee Recieve -W-011780
				apps.Client_Code__c = COS.clcd;
                apps.ASV_MASV__c = COS.crisdtOut!=nULL?Decimal.valueof(COS.crisdtOut):0;

                if(COS.ApplicationId != null){
                    apps.Application_Id_Text__c = COS.ApplicationId;
                }

                appList.add(apps);
            }

            if(appList.size() >0){
                insert appList;
            }
        }

        return null;
    }
    
    /**
    * @description Demat Shares
    * @author Gulafsha | 2021-06-08 
    * @param accountId 
    * @param OppId 
    * @return string 
    **/
    @AuraEnabled
    public static string  getDematShares(String accountId,String OppId){
        ApplicationsSelector app = new ApplicationsSelector();
        Application__c appRecord = app.selectByCreditOpportunityId(OppId);
        List<sMgetAsvDematSharesV1_Resp_IB_v1.OutputTbl> dematSharesWrapperList = new  List<sMgetAsvDematSharesV1_Resp_IB_v1.OutputTbl>();
        List<Application_Security__c> applicationsecList=new ApplicationSecuritySelector().selectByApplicationIdAndSecTypefields(appRecord.id,'Dematerialized Shares');

        for(Application_Security__c apps:applicationsecList){
            sMgetAsvDematSharesV1_Resp_IB_v1.OutputTbl DematS = new sMgetAsvDematSharesV1_Resp_IB_v1.OutputTbl();
            DematS.refacc = apps.Reference_Account_Number__c ;
            DematS.seqno = apps.Client_Name__c;
            DematS.clcd = apps.Client_Code__c;
            DematS.status = apps.Status__c ;
            DematS.specific = apps.Specific__c ;
            DematS.ascVal = apps.ASV_MASV__c!=Null?String.valueof(apps.ASV_MASV__c):'';
            DematS.shareNm = apps.Share_Name__c ;
            DematS.noshares = apps.Number_of_Shares__c!=Null?String.valueof(apps.Number_of_Shares__c):'';
            DematS.cessamt = apps.Amount__c!=Null?(apps.Limited_Surety__c=='Y' ?String.valueof(apps.Amount__c):'Unlimited'):'';
            DematS.limited = apps.Limited_Surety__c ;
            DematS.nomVal = apps.Nominal_Value__c;
            DematS.accNo   = apps.Registration_Number__c;
            DematS.signDte   = String.Valueof(apps.Date_Signed__c);
            DematS.ApplicationId = apps.Id;
            dematSharesWrapperList.add(DematS);
        }

        if(dematSharesWrapperList.size()>0){
            return JSON.serialize(dematSharesWrapperList);
        }

        return null;
    }

    /**
    * @description Demat Shares call service
    * @author Gulafsha | 2021-06-08 
    * @param Appsecurityids 
    **/
    @Future(callout = true)
    public static void securitiesDematS(Set<id> Appsecurityids){
        List<sMgetAsvDematSharesV1_Resp_IB_v1.OutputTbl> dematSharesWrapperList = new  List<sMgetAsvDematSharesV1_Resp_IB_v1.OutputTbl>();
        List<Application_Profile__c> appprincipalList= new ApplicationProfileSelector().getApplicationProfilesbyId(Appsecurityids);

        for(Application_Profile__c appsec:appprincipalList){
            if( String.isNotBlank(appsec.Client_CIF_Code__c) ){
                Map<sMgetAsvDematSharesV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvDematSharesV1_IH_v1.sMgetAsvDematSharesV1(appsec.Client_CIF_Code__c);
                sMgetAsvDematSharesV1_Resp_IB_v1 responseBean = (new List<sMgetAsvDematSharesV1_Resp_IB_v1>(responseMap.keySet()))[0];

                if(responseBean.statusCode == 200){
                    sMgetAsvDematSharesV1_Resp_IB_v1.SMgetASVDematerializedSharesV1Response wrapper = responseBean.SMgetASVDematerializedSharesV1Response;
                    List<sMgetAsvDematSharesV1_Resp_IB_v1.OutputTbl> cls_smn336o = wrapper.Smn336o.OutputTbl;

                    for(sMgetAsvDematSharesV1_Resp_IB_v1.OutputTbl DematS : cls_smn336o){
                        DematS.ApplicationId = appsec.application__c;
                        DematS.seqno = appsec.Client_Name__c;
                        DematS.clcd = appsec.Client_CIF_Code__c;

                        if((DematS.refacc!=Null && DematS.refacc!='0')
                            || (DematS.status!=Null && DematS.status!='0')
                            || (DematS.nomVal!=Null && DematS.nomVal!='0')
                            || (DematS.shareNm!=Null && DematS.shareNm!='0')
                            || (DematS.signDte!=Null && DematS.signDte!='0')
                            || (DematS.accNo!=Null && DematS.accNo!='0')
                            || (DematS.specific!=Null && DematS.specific!='0')
                            || ((DematS.ascVal!=Null && DematS.ascVal!='0')
                            || (DematS.mascVal!=Null && DematS.mascVal!='0'))
                            || (DematS.noshares!=Null && DematS.noshares!='0') ||
                            (DematS.cessamt!=Null && DematS.cessamt!='0') || (DematS.limited!=Null && DematS.limited!='0')) {
                            dematSharesWrapperList.add(DematS);
                        }
                    }
                }
            }
        }

        if(dematSharesWrapperList.size()>0){
            insertAppSecurities(dematSharesWrapperList);
        }
    }

    /**
    * @description Inserting the Application Security records
    * @author Gulafsha | 2021-06-08 
    * @param wrapperlist 
    * @return string 
    **/
    public static string insertAppSecurities(List<sMgetAsvDematSharesV1_Resp_IB_v1.OutputTbl> wrapperlist){
        if(wrapperlist.size () >0){
            List<Application_Security__c> appList = new List<Application_Security__c>();

            for(sMgetAsvDematSharesV1_Resp_IB_v1.OutputTbl DematS :wrapperlist){
                Application_Security__c apps = new Application_Security__c();
                apps.Name = 'Dematerialized Shares';
                apps.Security_Type__c = 'Dematerialized Shares';
                apps.Reference_Account_Number__c = DematS.refacc;
				apps.Registration_Number__c = DematS.accNo;
                apps.Status__c = DematS.status;
                apps.Specific__c = DematS.specific;
                apps.MASV__c = DematS.mascVal!=Null?decimal.valueof(DematS.mascVal):0;
                apps.ASV__c = DematS.ascVal!=Null?decimal.valueof(DematS.ascVal):0;
                apps.Share_Name__c  = DematS.shareNm;
                apps.Number_of_Shares__c  = DematS.cessamt!=Null?Decimal.valueof(DematS.noshares):Null;
                apps.Amount__c  = DematS.cessamt!=Null?Decimal.valueof(DematS.cessamt):Null;
                apps.Limited_Surety__c  =  DematS.limited ;
                apps.Client_Name__c = DematS.seqno;
			    apps.Client_Code__c = DematS.clcd;
                apps.Nominal_Value__c = DematS.nomVal;

                if(DematS.ApplicationId != null){
                    apps.Application_Id_Text__c = DematS.ApplicationId;
                }

                if(DematS.ascVal!=null && Decimal.valueof(DematS.ascVal) !=0){
                    apps.ASV_MASV__c = Decimal.valueof(DematS.ascVal);
                } else{
                    apps.ASV_MASV__c =  DematS.mascVal!=Null?Decimal.valueof(DematS.mascVal):Null;
                }

                if(DematS.signDte!=Null && DematS.signDte!='0'){
                    apps.Date_Signed__c =  Date.parse(ChequeAndOverdraftController.getFormatedDate(DematS.signDte));
                }
                appList.add(apps);
            }

            if(appList.size() >0){
                insert appList;
            }
        }

        return null;
    }
    
    /**
    * @description ASV Letters V1
    * @author Gulafsha | 2021-06-08 
    * @param accountId 
    * @param OppId 
    * @return string 
    **/
    @AuraEnabled
    public static string  getAsvLettersV1(String accountId,String OppId){
        ApplicationsSelector app = new ApplicationsSelector();
        Application__c appRecord = app.selectByCreditOpportunityId(OppId);
        List<sMgetAsvLettersV1_Resp_IB_v1.LettersTable> lettesTableWrapperList = new  List<sMgetAsvLettersV1_Resp_IB_v1.LettersTable>();
        List<Application_Security__c> applicationsecList=new ApplicationSecuritySelector().selectByApplicationIdAndSecTypefields(appRecord.id,'Letter of Undertaking');

        for(Application_Security__c apps:applicationsecList){
            sMgetAsvLettersV1_Resp_IB_v1.LettersTable LoU = new sMgetAsvLettersV1_Resp_IB_v1.LettersTable();
            LoU.refacc = apps.Reference_Account_Number__c;
            LoU.specific = apps.Specific__c;
            LoU.status   = apps.Status__c;
            LoU.nomVal   = apps.Nominal_Value__c;
            LoU.ocasVal   = String.valueof(apps.ASV_MASV__c);
            LoU.seqno = apps.Client_Name__c;
            LoU.clcd = apps.Client_Code__c;
            LoU.ApplicationId = apps.Id;
            lettesTableWrapperList.add(LoU);
        }

        if(lettesTableWrapperList.size()>0){
            system.debug(lettesTableWrapperList);
            return JSON.serialize(lettesTableWrapperList);
        }

        return null;
    }

    /**
    * @description call ASV Letters V1 service
    * @author Gulafsha | 2021-06-08 
    * @param Appsecurityids 
    **/
    @Future(callout = true)
    public static void securitiesLoU(Set<id> Appsecurityids){
        List<sMgetAsvLettersV1_Resp_IB_v1.LettersTable> lettesTableWrapperList  = new  List<sMgetAsvLettersV1_Resp_IB_v1.LettersTable>();
        List<Application_Profile__c> appprincipalList= new ApplicationProfileSelector().getApplicationProfilesbyId(Appsecurityids);

        for(Application_Profile__c appsec:appprincipalList){
            if( String.isNotBlank(appsec.Client_CIF_Code__c) ){
                Map<sMgetAsvLettersV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvLettersV1_IH_v1.sMgetAsvLettersV1(appsec.Client_CIF_Code__c);
                sMgetAsvLettersV1_Resp_IB_v1 responseBean = (new List<sMgetAsvLettersV1_Resp_IB_v1>(responseMap.keySet()))[0];

                if(responseBean.statusCode == 200){
                    sMgetAsvLettersV1_Resp_IB_v1.SMgetASVLettersV1Response wrapper = responseBean.SMgetASVLettersV1Response;
                    List<sMgetAsvLettersV1_Resp_IB_v1.LettersTable> cls_smn140o = wrapper.Smn140o.LettersTable;

                    for(sMgetAsvLettersV1_Resp_IB_v1.LettersTable LoU : cls_Smn140o){
                        LoU.ApplicationId = appsec.application__c;
                        LoU.seqno = appsec.Client_Name__c;
                        LoU.clcd = appsec.Client_CIF_Code__c;

                        if((LoU.refacc!=Null && LoU.refacc!='0') || (LoU.status!=Null && LoU.status!='0') || (LoU.specific!=Null && LoU.specific!='0')
                            || (LoU.nomval!=Null && LoU.nomVal!='0') || (LoU.ocasVal!=Null && LoU.ocasVal!='0')) {
                            lettesTableWrapperList.add(LoU);
                        }
                    }
                }
            }
        }

        if(lettesTableWrapperList.size()>0){
            insertAppSecurities(lettesTableWrapperList);
        }
    }

    
    /**
    * @description Insert ASV Letters V1 
    * @author Gulafsha | 2021-06-08 
    * @param wrapperlist 
    * @return string 
    **/
    public static string insertAppSecurities(List<sMgetAsvLettersV1_Resp_IB_v1.LettersTable> wrapperlist){
        if(wrapperlist.size () >0){
            List<Application_Security__c> appList = new List<Application_Security__c>();

            for(sMgetAsvLettersV1_Resp_IB_v1.LettersTable LoU :wrapperlist){
                Application_Security__c apps = new Application_Security__c();
                apps.Name = 'Letter of Undertaking';
                apps.Security_Type__c = 'Letter of Undertaking';
                apps.Reference_Account_Number__c =  LoU.refacc;
                apps.Specific__c = LoU.specific;
                apps.Status__c = LoU.status;
                apps.ASV_MASV__c = LoU.ocasVal!=Null?Decimal.valueof(LoU.ocasVal):null;
                apps.ASV__c = LoU.ocasVal!=Null?Decimal.valueof(LoU.ocasVal):null;
                apps.Nominal_Value__c = LoU.nomVal;
                apps.Client_Name__c = LoU.seqno;
                apps.Client_Code__c = LoU.clcd;

                if(LoU.ApplicationId != null){
                    apps.Application_Id_Text__c = LoU.ApplicationId;
                }

                appList.add(apps);
            }

            if(appList.size() >0){
                insert appList;
            }
        }

        return null;
    }


    
    /**
    * @description ASV General Cessions V1
    * @author Gulafsha | 2021-06-08 
    * @param accountId 
    * @param OppId 
    * @return string 
    **/
    @AuraEnabled
    public static string  getASVGeneralCessionsV1(String accountId,String OppId){
        ApplicationsSelector app = new ApplicationsSelector();
        Application__c appRecord = app.selectByCreditOpportunityId(OppId);
        List<sMgetAsvGeneralCessionsV1_Resp_IB_v1.GcessTable> cessionOfGeneralCessionsWrapperList = new  List<sMgetAsvGeneralCessionsV1_Resp_IB_v1.GcessTable>();
        List<Application_Security__c> applicationsecList=new ApplicationSecuritySelector().selectByApplicationIdAndSecTypefields(appRecord.id,'General Session');

        for(Application_Security__c apps:applicationsecList){
            sMgetAsvGeneralCessionsV1_Resp_IB_v1.GcessTable ASVGCV1 = new sMgetAsvGeneralCessionsV1_Resp_IB_v1.GcessTable();
            ASVGCV1.specific = apps.Specific__c;
            ASVGCV1.seqno = apps.Client_Name__c;
            ASVGCV1.clcd = apps.Client_Code__c;
            ASVGCV1.status   = apps.Status__c;
            ASVGCV1.nomVal   = apps.Nominal_Value__c;
            ASVGCV1.datesign   = String.valueof(apps.Date_Signed__c);
            ASVGCV1.valDate   = String.valueof(apps.Date_Analysis__c);
            ASVGCV1.cessionType   = apps.Bond_Type__c;
            ASVGCV1.asvval = apps.ASV_MASV__c!=Null?String.valueof(apps.ASV_MASV__c):'';
            ASVGCV1.cessionAmnt   = apps.Amount__c!=Null?(apps.Limited_Surety__c=='Y'?string.valueof(apps.Amount__c):'Unlimited'):'';
            ASVGCV1.realmv   = apps.Realistic_Market_Value__c!=Null?string.valueof(apps.Realistic_Market_Value__c):'';
            ASVGCV1.limited = apps.Limited_Surety__c;
            ASVGCV1.refacc   = apps.Reference_Account_Number__c;
            ASVGCV1.ApplicationId = apps.Id;
            cessionOfGeneralCessionsWrapperList.add(ASVGCV1);
        }

        if(cessionOfGeneralCessionsWrapperList.size()>0){
            return JSON.serialize(cessionOfGeneralCessionsWrapperList);
        }

        return null;
    }

    /**
    * @description call ASV General Cessions V1 service
    * @author Gulafsha | 2021-06-08 
    * @param Appsecurityids 
    **/
    @Future(callout = true)
    public static void securitiesASVGCV1(Set<id> Appsecurityids){
        List<sMgetAsvGeneralCessionsV1_Resp_IB_v1.GcessTable> cessionOfGeneralCessionsWrapperList  = new  List<sMgetAsvGeneralCessionsV1_Resp_IB_v1.GcessTable>();
        List<Application_Profile__c> appprincipalList= new ApplicationProfileSelector().getApplicationProfilesbyId(Appsecurityids);

        for(Application_Profile__c appsec:appprincipalList){
            if( String.isNotBlank(appsec.Client_CIF_Code__c) ){
                Map<sMgetAsvGeneralCessionsV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvGeneralCessionsV1_IH_v1.sMgetAsvGeneralCessionsV1(appsec.Client_CIF_Code__c);
                sMgetAsvGeneralCessionsV1_Resp_IB_v1 responseBean = (new List<sMgetAsvGeneralCessionsV1_Resp_IB_v1>(responseMap.keySet()))[0];

                if(responseBean.statusCode == 200){
                    sMgetAsvGeneralCessionsV1_Resp_IB_v1.SMgetASVGeneralCessionsV1Response wrapper = responseBean.SMgetASVGeneralCessionsV1Response;
                    List<sMgetAsvGeneralCessionsV1_Resp_IB_v1.GcessTable> cls_sms148o = wrapper.Sms148o.GcessTable;

                    for(sMgetAsvGeneralCessionsV1_Resp_IB_v1.GcessTable ASVGCV1 : cls_Sms148o){
                        ASVGCV1.ApplicationId = appsec.application__c;
                        ASVGCV1.seqno = appsec.Client_Name__c;
                        ASVGCV1.clcd = appsec.Client_CIF_Code__c;

                        if(((ASVGCV1.asvval!=Null && ASVGCV1.asvval!='0')
                        || (ASVGCV1.masvval!=Null && ASVGCV1.masvval!='0') )
                        || (ASVGCV1.status!=Null && ASVGCV1.status!='0')
                        || (ASVGCV1.nomval!=Null && ASVGCV1.nomval!='0')
                        || (ASVGCV1.specific!=Null && ASVGCV1.specific!='0')
                        || (ASVGCV1.cessionAmnt!=Null && ASVGCV1.cessionAmnt!='0')
                        || (ASVGCV1.limited!=Null && ASVGCV1.limited!='0')
                        || (ASVGCV1.refAcc!=Null && ASVGCV1.refacc!='0')
                        || (ASVGCV1.realmv!=Null && ASVGCV1.realmv!='0')
                        || (ASVGCV1.datesign!=Null && ASVGCV1.datesign!='0')
                        || (ASVGCV1.valDate!=Null && ASVGCV1.valDate!='0')
                        || (ASVGCV1.cessionType!=Null && ASVGCV1.cessionType!='0')) {
                            cessionOfGeneralCessionsWrapperList.add(ASVGCV1);
                        }
                    }
                }
            }
        }

        if(cessionOfGeneralCessionsWrapperList.size()>0){
            insertAppSecurities(cessionOfGeneralCessionsWrapperList);
        }
    }

    
    /**
    * @description insert ASV General Cessions V1
    * @author Gulafsha | 2021-06-08 
    * @param wrapperlist 
    * @return string 
    **/
    public static string insertAppSecurities(List<sMgetAsvGeneralCessionsV1_Resp_IB_v1.GcessTable> wrapperlist){
        if(wrapperlist.size () >0){
            List<Application_Security__c> appList = new List<Application_Security__c>();

            for(sMgetAsvGeneralCessionsV1_Resp_IB_v1.GcessTable ASVGCV1 :wrapperlist){
                Application_Security__c apps = new Application_Security__c();
                apps.Name = 'General Session';
                apps.Security_Type__c = 'General Session';
                apps.Specific__c = ASVGCV1.specific;
                apps.Status__c = ASVGCV1.status;
                apps.Nominal_Value__c = ASVGCV1.nomVal;
                apps.MASV__c = ASVGCV1.masvval!=Null?decimal.valueof(ASVGCV1.masvval):0;
                apps.ASV__c = ASVGCV1.asvval!=Null?decimal.valueof(ASVGCV1.asvval):0;
                apps.Amount__c   = ASVGCV1.cessionAmnt!=Null?decimal.valueof(ASVGCV1.cessionAmnt):Null;
                apps.Limited_Surety__c = ASVGCV1.limited;
                apps.Reference_Account_Number__c  =  ASVGCV1.refacc;
                apps.Client_Name__c = ASVGCV1.seqno;
				apps.Client_Code__c = ASVGCV1.clcd;
                apps.Realistic_Market_Value__c = ASVGCV1.realmv!=Null?decimal.valueof(ASVGCV1.realmv):Null;
                apps.Bond_Type__c = ASVGCV1.cessionType;

                if(ASVGCV1.ApplicationId != null){
                    apps.Application_Id_Text__c = ASVGCV1.ApplicationId;
                }

                if(ASVGCV1.asvval!=null && decimal.valueof(ASVGCV1.asvval)!=0){
                    apps.ASV_MASV__c = decimal.valueof(ASVGCV1.asvval);
                } else{
                    apps.ASV_MASV__c = ASVGCV1.masvval!=Null?decimal.valueof(ASVGCV1.masvval):Null;
                }

                if(ASVGCV1.datesign!=Null && ASVGCV1.datesign!='0'){
                    apps.Date_Signed__c =  Date.parse(ChequeAndOverdraftController.getFormatedDate(ASVGCV1.datesign));
                }

                if(ASVGCV1.valDate!=Null && ASVGCV1.valDate!='0'){
                    apps.Date_Analysis__c =  Date.parse(ChequeAndOverdraftController.getFormatedDate(ASVGCV1.valDate));
                }

                appList.add(apps);
            }

            if(appList.size() >0){
                insert appList;
            }
        }

        return null;
    }
    
    /**
    * @description ASV Securities ASV CessionS
    * @author Gulafsha | 2021-06-08 
    * @param accountId 
    * @param OppId 
    * @return string 
    **/
    @AuraEnabled
    public static string  getAsvCessionOfShares(String accountId,String OppId){
        ApplicationsSelector app = new ApplicationsSelector();
        Application__c appRecord = app.selectByCreditOpportunityId(OppId);
        List<sMgetAsvCessionOfSharesV1_Resp_IB_v1.OutputTbl> cessionOfSharesWrapperList = new  List<sMgetAsvCessionOfSharesV1_Resp_IB_v1.OutputTbl>();
        List<Application_Security__c> applicationsecList=new ApplicationSecuritySelector().selectByApplicationIdAndSecTypefields(appRecord.id,'Cession of Stock and Shares');

        for(Application_Security__c apps:applicationsecList){
            sMgetAsvCessionOfSharesV1_Resp_IB_v1.OutputTbl ASVCessionS = new sMgetAsvCessionOfSharesV1_Resp_IB_v1.OutputTbl();
            ASVCessionS.specific = apps.Specific__c;
            ASVCessionS.seqno = apps.Client_Name__c;
            ASVCessionS.clcd = apps.Client_Code__c;
            ASVCessionS.status = apps.Status__c;
            ASVCessionS.cessAmt = apps.Amount__c!=Null?String.valueof(apps.Amount__c):'';
            ASVCessionS.signDte = String.valueof(apps.Date_Signed__c);
            ASVCessionS.nomVal = apps.Nominal_Value__c;
            ASVCessionS.refAcc = apps.Reference_Account_Number__c;
            ASVCessionS.shareNm = apps.Share_Name__c;
            ASVCessionS.noshares = apps.Number_of_Shares__c!=Null?String.valueof(apps.Number_of_Shares__c):'';
            ASVCessionS.ascVal = apps.ASV_MASV__c!=Null?String.valueof(apps.ASV_MASV__c):'';
            ASVCessionS.ApplicationId = apps.Id;
            cessionOfSharesWrapperList.add(ASVCessionS);
        }

        if(cessionOfSharesWrapperList.size()>0){
            return JSON.serialize(cessionOfSharesWrapperList);
        }

        return null;
    }

    /**
    * @description call ASV Securities ASV CessionS service
    * @author Gulafsha | 2021-06-08 
    * @param Appsecurityids 
    **/
    @Future(callout = true)
    public static void securitiesASVCessionS(Set<id> Appsecurityids){
        List<sMgetAsvCessionOfSharesV1_Resp_IB_v1.OutputTbl> cessionOfSharesWrapperList = new  List<sMgetAsvCessionOfSharesV1_Resp_IB_v1.OutputTbl>();
        List<Application_Profile__c> appprincipalList= new ApplicationProfileSelector().getApplicationProfilesbyId(Appsecurityids);

        for(Application_Profile__c appsec:appprincipalList){
            if( String.isNotBlank(appsec.Client_CIF_Code__c) ){
                Map<sMgetAsvCessionOfSharesV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvCessionOfSharesV1_IH_v1.sMgetAsvCessionOfSharesV1(appsec.Client_CIF_Code__c);
                sMgetAsvCessionOfSharesV1_Resp_IB_v1 responseBean = (new List<sMgetAsvCessionOfSharesV1_Resp_IB_v1>(responseMap.keySet()))[0];

                if(responseBean.statusCode == 200){
                    sMgetAsvCessionOfSharesV1_Resp_IB_v1.SMgetASVCessionOfSharesV1Response wrapper = responseBean.SMgetASVCessionOfSharesV1Response;
                    List<sMgetAsvCessionOfSharesV1_Resp_IB_v1.OutputTbl> cls_smn136o = wrapper.smn136o.OutputTbl;

                    for(sMgetAsvCessionOfSharesV1_Resp_IB_v1.OutputTbl ASVCessionS : cls_smn136o){
                        ASVCessionS.ApplicationId = appsec.application__c;
                        ASVCessionS.seqno = appsec.Client_Name__c;
                        ASVCessionS.clcd = appsec.Client_CIF_Code__c;

                        if((ASVCessionS.specific!=Null && ASVCessionS.specific!='0')
                        || (ASVCessionS.status!=Null && ASVCessionS.status!='0')
                        || (ASVCessionS.nomVal!=Null && ASVCessionS.nomVal!='0')
                        || (ASVCessionS.refacc!=Null && ASVCessionS.refacc!='0')
                        || (ASVCessionS.shareNm!=Null && ASVCessionS.shareNm!='0')
                        || (ASVCessionS.noshares!=Null && ASVCessionS.noshares!='0')
                        || (ASVCessionS.cessAmt!=Null && ASVCessionS.cessAmt!='0')
                        || (ASVCessionS.signDte!=Null && ASVCessionS.signDte!='0')
                        || ((ASVCessionS.ascVal!=Null && ASVCessionS.ascVal!='0')
                        || (ASVCessionS.mascVal!=Null && ASVCessionS.mascVal!='0'))) {
                            cessionOfSharesWrapperList.add(ASVCessionS);
                        }
                    }
                }
            }
        }

        if(cessionOfSharesWrapperList.size()>0){
            insertAppSecurities(cessionOfSharesWrapperList);
        }
    }

    /**
    * @description Inserting the Application Security records
    * @author Gulafsha | 2021-06-08 
    * @param wrapperlist 
    * @return string 
    **/
    public static string insertAppSecurities(List<sMgetAsvCessionOfSharesV1_Resp_IB_v1.OutputTbl> wrapperlist){
        if(wrapperlist.size () >0){
            List<Application_Security__c> appList = new List<Application_Security__c>();

            for(sMgetAsvCessionOfSharesV1_Resp_IB_v1.OutputTbl ASVCessionS :wrapperlist){
                Application_Security__c apps = new Application_Security__c();

                apps.Name = 'Cession of Stock and Shares';
                apps.Security_Type__c = 'Cession of Stock and Shares';
                apps.Specific__c = ASVCessionS.specific;
                apps.Status__c = ASVCessionS.status;
                apps.Nominal_Value__c = ASVCessionS.nomVal;
                apps.Client_Name__c = ASVCessionS.seqno;
				apps.Client_Code__c = ASVCessionS.clcd;
                apps.Reference_Account_Number__c = ASVCessionS.refAcc;
                apps.Share_Name__c = ASVCessionS.shareNm;
                apps.Number_of_Shares__c = ASVCessionS.noshares!=Null?Decimal.valueof(ASVCessionS.noshares):Null;
                apps.Amount__c = ASVCessionS.cessAmt!=Null?Decimal.valueof(ASVCessionS.cessAmt):Null;
                apps.MASV__c = ASVCessionS.mascVal!=Null?decimal.valueof(ASVCessionS.mascVal):0;
                apps.ASV__c = ASVCessionS.ascVal!=Null?decimal.valueof(ASVCessionS.ascVal):0;

                if(ASVCessionS.ApplicationId != null){
                    apps.Application_Id_Text__c = ASVCessionS.ApplicationId;
                }

                if(ASVCessionS.ascVal!=null && Decimal.valueof(ASVCessionS.ascVal)!=0){
                    apps.ASV_MASV__c = Decimal.valueof(ASVCessionS.ascVal);
                } else{
                    apps.ASV_MASV__c = ASVCessionS.mascVal!=Null?Decimal.valueof(ASVCessionS.mascVal):Null;
                }

                if(ASVCessionS.signDte!=Null && ASVCessionS.signDte!='0'){
                    apps.Date_Signed__c =  Date.parse(ChequeAndOverdraftController.getFormatedDate(ASVCessionS.signDte));
                }

                appList.add(apps);
            }

            if(appList.size() >0){
                insert appList;
            }
        }
        return null;
    }
    
    /**
    * @description ASV Cession Of Fire Short Term Insurance V1
    * @author Gulafsha | 2021-06-08 
    * @param accountId 
    * @param OppId 
    * @return string 
    **/
    @AuraEnabled
    public static string  getASVCessionOfFireShortTermInsuranceV1(String accountId,String OppId){
        ApplicationsSelector app = new ApplicationsSelector();
        Application__c appRecord = app.selectByCreditOpportunityId(OppId);
        List<SMgetASVCessionOfFireShortV1_Resp_IB_v1.Table> cessionOfFireShortWrapperList = new  List<SMgetASVCessionOfFireShortV1_Resp_IB_v1.Table>();
        List<Application_Security__c> applicationsecList=new ApplicationSecuritySelector().selectByApplicationIdAndSecTypefields(appRecord.id,'Cession of Fire Short-Term Insurance');

        for(Application_Security__c apps:applicationsecList){
            SMgetASVCessionOfFireShortV1_Resp_IB_v1.Table ASVCessionFSTI = new SMgetASVCessionOfFireShortV1_Resp_IB_v1.Table();
            ASVCessionFSTI.polnoOut = apps.Policy_Number__c;
            ASVCessionFSTI.statusOut = apps.Status__c;
            ASVCessionFSTI.poltypOut = apps.Client_Name__c;
            ASVCessionFSTI.clcd = apps.Client_Code__c;
            ASVCessionFSTI.specifOut = apps.Specific__c;
            ASVCessionFSTI.peotdaOut = apps.Nominal_Value__c;
            ASVCessionFSTI.institOut = apps.Insurance_Company_Code__c;
            ASVCessionFSTI.polamtOut = apps.Amount__c!=Null?String.valueof(apps.Amount__c):'';
            ASVCessionFSTI.refaccOut = apps.Reference_Account_Number__c;
            ASVCessionFSTI.ackdteOut = apps.ASV_MASV__c!=Null?String.valueof(apps.ASV_MASV__c):'';
            ASVCessionFSTI.ApplicationId = apps.Id;
            cessionOfFireShortWrapperList.add(ASVCessionFSTI);
        }

        if(cessionOfFireShortWrapperList.size()>0){
            return JSON.serialize(cessionOfFireShortWrapperList);
        }

        return null;
    }

    /**
    * @description call ASV Cession Of Fire Short Term Insurance V1 service
    * @author Gulafsha | 2021-06-08 
    * @param Appsecurityids 
    **/
    @Future(callout = true)
    public static void securitiesASVCessionFSTI(Set<id> Appsecurityids){
        List<SMgetASVCessionOfFireShortV1_Resp_IB_v1.Table> cessionOfFireShortWrapperList = new  List<SMgetASVCessionOfFireShortV1_Resp_IB_v1.Table>();
        List<Application_Profile__c> appprincipalList= new ApplicationProfileSelector().getApplicationProfilesbyId(Appsecurityids);

        for(Application_Profile__c appsec:appprincipalList){
            if( String.isNotBlank(appsec.Client_CIF_Code__c) ){
                Map<SMgetASVCessionOfFireShortV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = SMgetASVCessionOfFireShortV1_IH_v1.getASVCessionOfFireShortV1(appsec.Client_CIF_Code__c);
                SMgetASVCessionOfFireShortV1_Resp_IB_v1 responseBean = (new List<SMgetASVCessionOfFireShortV1_Resp_IB_v1>(responseMap.keySet()))[0];

                if(responseBean.statusCode == 200){
                    SMgetASVCessionOfFireShortV1_Resp_IB_v1.SMgetASVCessionOfFireShortTermInsuranceV1Response wrapper = responseBean.SMgetASVCessionOfFireShortTermInsuranceV1Response;
                    List<SMgetASVCessionOfFireShortV1_Resp_IB_v1.Table> cls_smp132eo = wrapper.smp132eo.Table;

                    for(SMgetASVCessionOfFireShortV1_Resp_IB_v1.Table ASVCessionFSTI : cls_smp132eo){
                        ASVCessionFSTI.ApplicationId = appsec.application__c;
                        ASVCessionFSTI.poltypOut = appsec.Client_Name__c;
                        ASVCessionFSTI.clcd = appsec.Client_CIF_Code__c;
                        ASVCessionFSTI.peotdaOut =  wrapper.smp132eo.nomvalTotOut;
                        ASVCessionFSTI.ackdteOut =  wrapper.smp132eo.asvamtTotOut;

                        if((ASVCessionFSTI.polnoOut!=Null && ASVCessionFSTI.polnoOut!='0')
                        || (ASVCessionFSTI.statusOut!=Null && ASVCessionFSTI.statusOut!='0')
                        || (ASVCessionFSTI.institOut!=Null && ASVCessionFSTI.institOut!='0')
                        || (ASVCessionFSTI.specifOut!=Null && ASVCessionFSTI.specifOut!='0')
                        || (ASVCessionFSTI.ackdteOut!=Null && ASVCessionFSTI.ackdteOut!='0')
                        || (ASVCessionFSTI.refaccOut!=Null && ASVCessionFSTI.refaccOut!='0')
                        || (ASVCessionFSTI.polamtOut!=Null && ASVCessionFSTI.polamtOut!='0')) {
                            cessionOfFireShortWrapperList.add(ASVCessionFSTI);
                        }
                    }
                }
            }
        }

        if(cessionOfFireShortWrapperList.size()>0){
            insertAppSecurities(cessionOfFireShortWrapperList);
        }
    }

    
    /**
    * @description insert ASV Cession Of Fire Short Term Insurance V1 
    * @author Gulafsha | 2021-06-08 
    * @param wrapperlist 
    * @return string  
    **/
    public static string insertAppSecurities(List<SMgetASVCessionOfFireShortV1_Resp_IB_v1.Table> wrapperlist){
        if(wrapperlist.size () >0){
            List<Application_Security__c> appList = new List<Application_Security__c>();

            for(SMgetASVCessionOfFireShortV1_Resp_IB_v1.Table ASVCessionFSTI :wrapperlist){
                Application_Security__c apps = new Application_Security__c();
                apps.Name = 'Fire Short-Term Insurance';
                apps.Security_Type__c = 'Cession of Fire Short-Term Insurance';
                apps.Policy_Number__c = ASVCessionFSTI.polnoOut;
                apps.Status__c = ASVCessionFSTI.statusOut;
                apps.Client_Name__c = ASVCessionFSTI.poltypOut;
				apps.Client_Code__c = ASVCessionFSTI.clcd;
                apps.Specific__c = ASVCessionFSTI.specifOut;
                apps.Nominal_Value__c = ASVCessionFSTI.nomvalTotOut;
                apps.Insurance_Company_Code__c = ASVCessionFSTI.institOut;
                apps.Amount__c = Decimal.valueof(ASVCessionFSTI.polamtOut);
                apps.Reference_Account_Number__c = ASVCessionFSTI.refaccOut;
                apps.ASV_MASV__c = Decimal.valueof(ASVCessionFSTI.ackdteOut);
                apps.ASV__c = ASVCessionFSTI.msvamtTotOut!=Null?decimal.valueof(ASVCessionFSTI.msvamtTotOut):0;
                apps.MASV__c = ASVCessionFSTI.msvamtTotOut!=Null?decimal.valueof(ASVCessionFSTI.msvamtTotOut):0;

                if(ASVCessionFSTI.ApplicationId!= null){
                    apps.Application_Id_Text__c = ASVCessionFSTI.ApplicationId;
                }

                appList.add(apps);
            }

            if(appList.size() >0){
                insert appList;
            }
        }
        return null;
    }

    /**
    * @description getASVCessionOfExternalInvestmentsV1
    * @author Gulafsha | 2021-06-08 
    * @param accountId 
    * @param OppId 
    * @return string 
    **/
    @AuraEnabled
    public static string  getASVCessionOfExternalInvestmentsV1(String accountId,String OppId){
        ApplicationsSelector app = new ApplicationsSelector();
        Application__c appRecord = app.selectByCreditOpportunityId(OppId);
        List<sMgetAsvCessionOfExtInv_Resp_IB_v1.Table> cessionOfOfExtInvWrapperList = new  List<sMgetAsvCessionOfExtInv_Resp_IB_v1.Table>();
        List<Application_Security__c> applicationsecList=new ApplicationSecuritySelector().selectByApplicationIdAndSecTypefields(appRecord.id,'Cession of External Investments');

        for(Application_Security__c apps:applicationsecList){
            sMgetAsvCessionOfExtInv_Resp_IB_v1.Table ASVCessionEI = new sMgetAsvCessionOfExtInv_Resp_IB_v1.Table();
            ASVCessionEI.refaccnoOut = apps.Reference_Account_Number__c;
            ASVCessionEI.invaccnoOut = apps.Registration_Number__c;
            ASVCessionEI.specificOut = apps.Specific__c;
            ASVCessionEI.dtesignedOut = String.valueof(apps.Date_Signed__c);
            ASVCessionEI.cessamtOut   = apps.Amount__c!=Null?String.valueof(apps.Amount__c):'';
            ASVCessionEI.invtypeOut   = apps.Bond_Type__c;
            ASVCessionEI.acchldcdOut   = apps.Surety_Client_Code__c;
            ASVCessionEI.matdteOut   = String.valueof(apps.Date_Analysis__c);
            ASVCessionEI.aStatusOut   = apps.Status__c;
            ASVCessionEI.seqnoOut = apps.Client_Name__c;
            ASVCessionEI.clcd = apps.Client_Code__c;
            ASVCessionEI.nomvalOut = apps.Nominal_Value__c;
            ASVCessionEI.appsecvalOut = apps.ASV_MASV__c!=Null?String.valueof(apps.ASV_MASV__c):'';
            ASVCessionEI.ApplicationId = apps.Id;
            cessionOfOfExtInvWrapperList.add(ASVCessionEI);
        }

        if(cessionOfOfExtInvWrapperList.size()>0){
            return JSON.serialize(cessionOfOfExtInvWrapperList);
        }

        return null;
    }

    /**
    * @description call getASVCessionOfExternalInvestmentsV1 service
    * @author Gulafsha | 2021-06-08 
    * @param Appsecurityids 
    **/
    @Future(callout = true)
    public static void securitiesASVCessionEI(Set<id> Appsecurityids){
        List<sMgetAsvCessionOfExtInv_Resp_IB_v1.Table> cessionOfOfExtInvWrapperList=new List<sMgetAsvCessionOfExtInv_Resp_IB_v1.Table>();
        List<Application_Profile__c> appprincipalList= new ApplicationProfileSelector().getApplicationProfilesbyId(Appsecurityids);

        for(Application_Profile__c appsec:appprincipalList){
            if( String.isNotBlank(appsec.Client_CIF_Code__c) ){
                Map<sMgetAsvCessionOfExtInv_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvCessionOfExtInv_IH_v1.getAsvCessionOfExtInvestment(appsec.Client_CIF_Code__c);
                sMgetAsvCessionOfExtInv_Resp_IB_v1 responseBean = (new List<sMgetAsvCessionOfExtInv_Resp_IB_v1>(responseMap.keySet()))[0];
                system.debug('responseBean'+json.serializePretty(responseBean));
                if(responseBean.statusCode == 200){
                    sMgetAsvCessionOfExtInv_Resp_IB_v1.SMgetASVCessionOfExternalInvestmentsV1Response wrapper = responseBean.SMgetASVCessionOfExternalInvestmentsV1Response;
                    List<sMgetAsvCessionOfExtInv_Resp_IB_v1.Table> cls_smp147eo = wrapper.Smp147eo.Table;

                    for(sMgetAsvCessionOfExtInv_Resp_IB_v1.Table ASVCessionEI : cls_smp147eo){
                        ASVCessionEI.ApplicationId = appsec.application__c;
                        ASVCessionEI.seqnoOut = appsec.Client_Name__c;
                        ASVCessionEI.clcd = appsec.Client_CIF_Code__c;

                        if((ASVCessionEI.invaccnoOut!=Null && ASVCessionEI.invaccnoOut!='0')
                        || (ASVCessionEI.aStatusOut!=Null && ASVCessionEI.aStatusOut!='0')
                        || (ASVCessionEI.dtesignedOut!=Null && ASVCessionEI.dtesignedOut!='0')
                        || (ASVCessionEI.specificOut!=Null && ASVCessionEI.specificOut!='0')
                        || (ASVCessionEI.refaccnoOut!=Null && ASVCessionEI.refaccnoOut!='0')
                        || (ASVCessionEI.cessamtOut!=Null && ASVCessionEI.cessamtOut!='0')
                        || (ASVCessionEI.invtypeOut!=Null && ASVCessionEI.invtypeOut!='0')
                        || (ASVCessionEI.acchldcdOut!=Null && ASVCessionEI.acchldcdOut!='0')
                        || (ASVCessionEI.matdteOut!=Null && ASVCessionEI.matdteOut!='0')
                        || (ASVCessionEI.nomvalOut!=Null && ASVCessionEI.nomvalOut!='0')
                        || ((ASVCessionEI.appsecvalOut!=Null && ASVCessionEI.appsecvalOut!='0')
                            || (ASVCessionEI.mappsecvalOut!=Null && ASVCessionEI.mappsecvalOut!='0'))){
                        if(ASVCessionEI.aStatusOut!=Null && ASVCessionEI.aStatusOut!='0')        
                        {
                            cessionOfOfExtInvWrapperList.add(ASVCessionEI);
                        }
                            }
                    }
                }
            }
        }

        if(cessionOfOfExtInvWrapperList.size()>0){
            insertAppSecurities(cessionOfOfExtInvWrapperList);
        }
    }

    
    /**
    * @description insert getASVCessionOfExternalInvestmentsV1
    * @author Gulafsha | 2021-06-08 
    * @param wrapperlist 
    * @return string 
    **/
    public static string insertAppSecurities(List<sMgetAsvCessionOfExtInv_Resp_IB_v1.Table> wrapperlist){
        if(wrapperlist.size () >0){
            List<Application_Security__c> appList = new List<Application_Security__c>();

            for(sMgetAsvCessionOfExtInv_Resp_IB_v1.Table ASVCessionEI :wrapperlist){
                Application_Security__c apps = new Application_Security__c();
                apps.Name = 'Cession of External Investments';
                apps.Security_Type__c = 'Cession of External Investments';
                apps.Reference_Account_Number__c = ASVCessionEI.refaccnoOut;
                apps.Client_Name__c = ASVCessionEI.seqnoOut;
				apps.Client_Code__c = ASVCessionEI.clcd;
                apps.Nominal_Value__c = ASVCessionEI.nomvalOut;
                apps.Status__c = ASVCessionEI.aStatusOut;
                apps.Registration_Number__c = ASVCessionEI.invaccnoOut;
                apps.Specific__c = ASVCessionEI.specificOut;
                apps.Amount__c = ASVCessionEI.cessamtOut!=Null?Decimal.valueof(ASVCessionEI.cessamtOut):0;
                apps.Bond_Type__c = ASVCessionEI.invtypeOut;
                apps.Surety_Client_Code__c = ASVCessionEI.acchldcdOut;
                apps.MASV__c = ASVCessionEI.mappsecvalOut!=Null?decimal.valueof(ASVCessionEI.mappsecvalOut):0;
                apps.ASV__c = ASVCessionEI.appsecvalOut!=Null?decimal.valueof(ASVCessionEI.appsecvalOut):0;

                if(ASVCessionEI.ApplicationId != null){
                    apps.Application_Id_Text__c = ASVCessionEI.ApplicationId;
                }

                if(ASVCessionEI.dtesignedOut!=Null && ASVCessionEI.dtesignedOut!='0'){
                    apps.Date_Signed__c =  Date.parse(ChequeAndOverdraftController.getFormatedDate(ASVCessionEI.dtesignedOut));
                }

                if(ASVCessionEI.matdteOut!=Null && ASVCessionEI.matdteOut!='0'){
                    apps.Date_Analysis__c =  Date.parse(ChequeAndOverdraftController.getFormatedDate(ASVCessionEI.matdteOut));
                }

                if(ASVCessionEI.appsecvalOut!=null && Decimal.valueof(ASVCessionEI.appsecvalOut)!=0){
                    apps.ASV_MASV__c = Decimal.valueof(ASVCessionEI.appsecvalOut);
                } else{
                    apps.ASV_MASV__c = ASVCessionEI.mappsecvalOut!=Null?Decimal.valueof(ASVCessionEI.mappsecvalOut):Null;
                }

                appList.add(apps);
            }

            if(appList.size() >0){
                insert appList;
            }
        }

        return null;
    }

    /**
    * @description call securitiesASVHoldsVI
    * @author Gulafsha | 2021-06-08 
    * @param Appsecurityids 
    **/
    @Future(callout = true)
    public static void securitiesASVHoldsVI(Set<id> Appsecurityids){
        sMgetAsvSecurityAndHoldsV1_Resp_IB_v1.smp155eo cls_smp155eo = new sMgetAsvSecurityAndHoldsV1_Resp_IB_v1.smp155eo();
        List<sMgetAsvSecurityAndHoldsV1_Resp_IB_v1.smp155eo> cls_smp155eoList = new List<sMgetAsvSecurityAndHoldsV1_Resp_IB_v1.smp155eo>();
        List<Application_Profile__c> appprincipalList= new ApplicationProfileSelector().getApplicationProfilesbyId(Appsecurityids);

        for(Application_Profile__c appsec:appprincipalList){system.debug(appsec.Client_CIF_Code__c);
            if(String.isNotBlank(appsec.Client_CIF_Code__c) ){
                Map<sMgetAsvSecurityAndHoldsV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = sMgetAsvSecurityAndHoldsV1_IH_v1.sMgetAsvSecurityAndHoldsV1(appsec.Client_CIF_Code__c);
                sMgetAsvSecurityAndHoldsV1_Resp_IB_v1 responseBean = (new List<sMgetAsvSecurityAndHoldsV1_Resp_IB_v1>(responseMap.keySet()))[0];

                if(responseBean.statusCode == 200){
                    sMgetAsvSecurityAndHoldsV1_Resp_IB_v1.SMgetASVOutstandingSecurityAndHoldsV1Response wrapper = responseBean.SMgetASVOutstandingSecurityAndHoldsV1Response;
                    cls_smp155eo = wrapper.smp155eo;
                    cls_smp155eo.ApplicationId = appsec.application__c;
                    cls_smp155eoList.add(cls_smp155eo);
                }
            }
        }

        if(cls_smp155eoList.size()>0){
            insertAppSecurities(cls_smp155eoList);
        }
    }

    
    /**
    * @description insert securitiesASVHoldsVI 
    * @author Gulafsha | 2021-06-08 
    * @param wrapperlist 
    * @return string 
    **/
    public static string insertAppSecurities(List<sMgetAsvSecurityAndHoldsV1_Resp_IB_v1.smp155eo> wrapperlist){
        if(wrapperlist.size () >0){
            List<Application_Security__c> appList = new List<Application_Security__c>();
            map<id,Application_Security__c> mapAppSec = new map<id,Application_Security__c>();

            for(sMgetAsvSecurityAndHoldsV1_Resp_IB_v1.smp155eo ASVSAH :wrapperlist){
                Application_Security__c apps = new Application_Security__c();
                apps.Name = 'Security Outstanding';
                apps.Security_Type__c = 'Security Outstanding';
                apps.Status__c = ASVSAH.status;
                apps.Client_Code__c = ASVSAH.clcd;
                apps.Client_Name__c = ASVSAH.osv;
                apps.Hold_Indication__c =  ASVSAH.holdInd;
                apps.Limited_pledge__c = ASVSAH.outsecind;

                if(ASVSAH.ApplicationId != null){
                    apps.Application_Id_Text__c = ASVSAH.ApplicationId;
                }

                appList.add(apps);
            }
            if(appList.size() >0){
                insert appList;
            }
        }
        return null;
    }
}