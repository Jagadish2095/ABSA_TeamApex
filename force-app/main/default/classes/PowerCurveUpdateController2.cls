/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 2021-07-13
 * @last modified by  : Gulafsha
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   05-25-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public class PowerCurveUpdateController2 {
    public static Id opportunityId;
    public static Application__c application;
    public static Opportunity opportunity;
    public static Account spouseAccount;

    public static List<Application_Product__c> appProducts;
    public static List<Application_Profile__c> appProfiles;
    public static Map<String, Object> pcoNewEntity01;
    public static Map<String, Object> pcoNewEntity02;
    public static Map<String, Object> pcoNewEntity03;
    public static Map<String, Object> pcoNewEntity04;
    public static Map<String, Object> pcoNewEntity05;
    public static Map<String, Object> pcoNewEntity06;
    public static Map<String,String> translationMap;

/**
 * @description mapPowerCureveUpdateRequest
 * @param oppId
 * @param pcoNewRequestBean
 * @param pcoId
 * @param stage
 * @author  
 * @return 
 */
    public static PowerCurveUpdateApplication_Req_IB_v1 mapPowerCureveUpdateRequest(Id oppId, PowerCurveNewApplication_Req_IB_v1 pcoNewRequestBean,String pcoId, String stage){
        opportunity = [SELECT Id, Entity_Type__c, Spouse_Account_Id__c FROM Opportunity WHERE Id =: oppId];
        application = [SELECT Id, ASV_Securities__c, MASV_Securities__c, Number_of_Product_Types__c FROM Application__c WHERE Opportunity__c =: oppId LIMIT 1];
        appProfiles = [SELECT Id, Applicant_Type__c, Account__c, Client_Name__c, Client_CIF_Code__c FROM Application_Profile__c WHERE Application__c =: application.Id];
        appProducts = [SELECT Id, Name, Account_number__c, Enforced_Reducing_Limit__c, Secured_By_Mortgage_Bond__c, TL_Initiation_Fee_Payment_Method__c, Temp_Account_Number__c FROM Application_Product__c WHERE  Opportunity__c =: oppId];
        List<Integration_Translation__c> translationList = [SELECT Id, Direction__c, External_Value__c, Internal_Value__c, System_Name__c, Value_Type__c, Name FROM Integration_Translation__c WHERE Value_Type__c = 'Identity Type' and Direction__c = 'Outbound'];
        opportunityId = oppId;

        translationMap = new Map<String, String>();
        for(Integration_Translation__c trnsRecord : translationList) {
            translationMap.put(trnsRecord.Internal_Value__c, trnsRecord.External_Value__c);
        }

        if(application == null){
            return null;
        }

        PowerCurveUpdateApplication_Req_IB_v1 requestBean = mapStage1Fields(pcoNewRequestBean);

        //String pcoId = pcoNewResponseBean.Response.ApplicationDV.DERPCOUNIQUENUMBER;

        requestBean = mapStage2Fields(requestBean, pcoId, stage);

        return requestBean;
    }
/**
 * @description mapStage1Fields
 * @param pcoNewRequestBean
 * @author  
 * @return 
 */
    public static PowerCurveUpdateApplication_Req_IB_v1 mapStage1Fields(PowerCurveNewApplication_Req_IB_v1 pcoNewRequestBean){
        Map<String, Object> pcoNew = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(pcoNewRequestBean));
        Map<String, Object> pcoRequest = (Map<String, Object>) pcoNew.get('Request');
        Map<String, Object> pcoApplicationDv = (Map<String, Object>) pcoRequest.get('ApplicationDV');
        Map<String, Object> pcoAppData = (Map<String, Object>) pcoApplicationDv.get('AppData');
        Map<String, Object> pcoINTAPPNCAP = (Map<String, Object>) pcoAppData.get('INTAPPNCAP');
        Map<String, Object> pcoINTAPPCCLP = (Map<String, Object>) pcoAppData.get('INTAPPCCLP');
        Map<String, Object> pcoINTAPPEXPO = (Map<String, Object>) pcoAppData.get('INTAPPEXPO');

        PowerCurveUpdateApplication_Req_IB_v1 requestBean = new PowerCurveUpdateApplication_Req_IB_v1();
        requestBean.Request = new PowerCurveUpdateApplication_Req_IB_v1.Request();
        requestBean.Request.ApplicationDV = new PowerCurveUpdateApplication_Req_IB_v1.ApplicationDV();
        requestBean.Request.ApplicationDV.APPAPPAPPLICATIONDATE = String.valueOf(pcoApplicationDv.get('APPAPPAPPLICATIONDATE') != null ? pcoApplicationDv.get('APPAPPAPPLICATIONDATE') : '');
        requestBean.Request.ApplicationDV.APPAPPAPPLICATIONNUMBER = String.valueOf(pcoApplicationDv.get('APPAPPAPPLICATIONNUMBER') != null ? pcoApplicationDv.get('APPAPPAPPLICATIONNUMBER') : '');
        requestBean.Request.ApplicationDV.APPAPPAPPLICATIONTIME = String.valueOf(pcoApplicationDv.get('APPAPPAPPLICATIONTIME') != null ? pcoApplicationDv.get('APPAPPAPPLICATIONTIME') : '');
        requestBean.Request.ApplicationDV.APPAPPAPPLICATIONTYPE = String.valueOf(pcoApplicationDv.get('APPAPPAPPLICATIONTYPE') != null ? pcoApplicationDv.get('APPAPPAPPLICATIONTYPE') : '');
        requestBean.Request.ApplicationDV.INTAPPBRANCHCODE = String.valueOf(pcoApplicationDv.get('INTAPPBRANCHCODE') != null ? pcoApplicationDv.get('INTAPPBRANCHCODE') : '');
        requestBean.Request.ApplicationDV.INTAPPOVERALLCONTROLBRANCH = String.valueOf(pcoApplicationDv.get('INTAPPOVERALLCONTROLBRANCH') != null ? pcoApplicationDv.get('INTAPPOVERALLCONTROLBRANCH') : '');
        requestBean.Request.ApplicationDV.INTAPPBUSINESSSEGMENT = String.valueOf(pcoApplicationDv.get('INTAPPBUSINESSSEGMENT') != null ? pcoApplicationDv.get('INTAPPBUSINESSSEGMENT') : '');
        requestBean.Request.ApplicationDV.INTAPPBUSINESSSUBSEGMENT = String.valueOf(pcoApplicationDv.get('INTAPPBUSINESSSUBSEGMENT') != null ? pcoApplicationDv.get('INTAPPBUSINESSSUBSEGMENT') : '');
        requestBean.Request.ApplicationDV.INTAPPSICCODE = String.valueOf(pcoApplicationDv.get('INTAPPSICCODE') != null ? pcoApplicationDv.get('INTAPPSICCODE') : '');
        requestBean.Request.ApplicationDV.APPAPPTRADINGINDICATOR = String.valueOf(pcoApplicationDv.get('APPAPPTRADINGINDICATOR') != null ? pcoApplicationDv.get('APPAPPTRADINGINDICATOR') : '');
        requestBean.Request.ApplicationDV.APPAPPFOREIGNCONTROLLEDPERC = String.valueOf(pcoApplicationDv.get('APPAPPFOREIGNCONTROLLEDPERC') != null ? pcoApplicationDv.get('APPAPPFOREIGNCONTROLLEDPERC') : '');
        requestBean.Request.ApplicationDV.INTAPPENTERPRDEVFUNDEXISTING = String.valueOf(pcoApplicationDv.get('INTAPPENTERPRDEVFUNDEXISTING') != null ? pcoApplicationDv.get('INTAPPENTERPRDEVFUNDEXISTING') : '');
        requestBean.Request.ApplicationDV.APPAPPENTERPRDEVFUNDREQ = String.valueOf(pcoApplicationDv.get('APPAPPENTERPRDEVFUNDREQ') != null ? pcoApplicationDv.get('APPAPPENTERPRDEVFUNDREQ') : '');
        requestBean.Request.ApplicationDV.APPAPPSTOKVELAPPLICATION = String.valueOf(pcoApplicationDv.get('APPAPPSTOKVELAPPLICATION') != null ? pcoApplicationDv.get('APPAPPSTOKVELAPPLICATION') : '');
        requestBean.Request.ApplicationDV.INTAPPEXISTINGFRANCHISEFINANCING = String.valueOf(pcoApplicationDv.get('INTAPPEXISTINGFRANCHISEFINANCING') != null ? pcoApplicationDv.get('INTAPPEXISTINGFRANCHISEFINANCING') : '');
        requestBean.Request.ApplicationDV.APPAPPREQUESTEDFRANCHISEFINANCING = String.valueOf(pcoApplicationDv.get('APPAPPREQUESTEDFRANCHISEFINANCING') != null ? pcoApplicationDv.get('APPAPPREQUESTEDFRANCHISEFINANCING') : '');
        requestBean.Request.ApplicationDV.INTAPPEXISTINGFRANCHISORTYPE = String.valueOf(pcoApplicationDv.get('INTAPPEXISTINGFRANCHISORTYPE') != null ? pcoApplicationDv.get('INTAPPEXISTINGFRANCHISORTYPE') : '');
        requestBean.Request.ApplicationDV.APPAPPREQUESTEDFRANCHISORTYPE = String.valueOf(pcoApplicationDv.get('APPAPPREQUESTEDFRANCHISORTYPE') != null ? pcoApplicationDv.get('APPAPPREQUESTEDFRANCHISORTYPE') : '');
        requestBean.Request.ApplicationDV.APPAPPFORMALAPPINDICATOR = String.valueOf(pcoApplicationDv.get('APPAPPFORMALAPPINDICATOR') != null ? pcoApplicationDv.get('APPAPPFORMALAPPINDICATOR') : '');
        requestBean.Request.ApplicationDV.APPAPPAPPLICATIONSTATUS = String.valueOf(pcoApplicationDv.get('APPAPPAPPLICATIONSTATUS') != null ? pcoApplicationDv.get('APPAPPAPPLICATIONSTATUS') : '');
        requestBean.Request.ApplicationDV.APPAPPAPPLICATIONSUBSTATUS = String.valueOf(pcoApplicationDv.get('APPAPPAPPLICATIONSUBSTATUS') != null ? pcoApplicationDv.get('APPAPPAPPLICATIONSUBSTATUS') : '');
        requestBean.Request.ApplicationDV.APPAPPESPINSTRUCTION =  String.valueOf(pcoApplicationDv.get('APPAPPESPINSTRUCTION') != null ? pcoApplicationDv.get('APPAPPESPINSTRUCTION') : '');
        requestBean.Request.ApplicationDV.APPAPPEXTRTLAMNT = String.valueOf(pcoApplicationDv.get('APPAPPEXTRTLAMNT') != null ? pcoApplicationDv.get('APPAPPEXTRTLAMNT') : '');
        requestBean.Request.ApplicationDV.APPBANKERNUMBER = String.valueOf(pcoApplicationDv.get('APPBANKERNUMBER') != null ? pcoApplicationDv.get('APPBANKERNUMBER') : '');

        requestBean.Request.ApplicationDV.AppData = new PowerCurveUpdateApplication_Req_IB_v1.AppData();
        requestBean.Request.ApplicationDV.AppData.APPAPPNUMKEYPRINCIPALS = String.valueOf(pcoAppData.get('APPAPPNUMKEYPRINCIPALS') != null ? pcoAppData.get('APPAPPNUMKEYPRINCIPALS') : '');
        requestBean.Request.ApplicationDV.AppData.APPAPPNUMCOREPRINCIPALS = String.valueOf(pcoAppData.get('APPAPPNUMCOREPRINCIPALS') != null ? pcoAppData.get('APPAPPNUMCOREPRINCIPALS') : '');
        requestBean.Request.ApplicationDV.AppData.APPAPPNONRESPRINCIPALS = String.valueOf(pcoAppData.get('APPAPPNONRESPRINCIPALS') != null ? pcoAppData.get('APPAPPNONRESPRINCIPALS') : '');
        requestBean.Request.ApplicationDV.AppData.APPAPPNUMPARTICIPANTS = String.valueOf(pcoAppData.get('APPAPPNUMPARTICIPANTS') != null ? pcoAppData.get('APPAPPNUMPARTICIPANTS') : '');
        requestBean.Request.ApplicationDV.AppData.APPAPPMNTHSSINCEBUSESTABLISHED = String.valueOf(pcoAppData.get('APPAPPMNTHSSINCEBUSESTABLISHED') != null ? pcoAppData.get('APPAPPMNTHSSINCEBUSESTABLISHED') : '');
        requestBean.Request.ApplicationDV.AppData.INTAPPAFFECTEDPERSREG31F = String.valueOf(pcoAppData.get('INTAPPAFFECTEDPERSREG31F') != null ? pcoAppData.get('INTAPPAFFECTEDPERSREG31F') : '');

        requestBean.Request.ApplicationDV.AppData.INTAPPEXPO = new PowerCurveUpdateApplication_Req_IB_v1.INTAPPEXPO();
        requestBean.Request.ApplicationDV.AppData.INTAPPEXPO.POLICYIND = String.valueOf(pcoINTAPPEXPO.get('POLICYIND') != null ? pcoINTAPPEXPO.get('POLICYIND') : '');
        requestBean.Request.ApplicationDV.AppData.INTAPPEXPO.TGAE = String.valueOf(pcoINTAPPEXPO.get('TGAE') != null ? pcoINTAPPEXPO.get('TGAE') : '');
        requestBean.Request.ApplicationDV.AppData.INTAPPEXPO.TGBE = String.valueOf(pcoINTAPPEXPO.get('TGBE') != null ? pcoINTAPPEXPO.get('TGBE') : '');
        requestBean.Request.ApplicationDV.AppData.INTAPPEXPO.TGOE = String.valueOf(pcoINTAPPEXPO.get('TGOE') != null ? pcoINTAPPEXPO.get('TGOE') : '');
        requestBean.Request.ApplicationDV.AppData.INTAPPEXPO.TOTALGROUPEXPOSURE = String.valueOf(pcoINTAPPEXPO.get('TOTALGROUPEXPOSURE') != null ? pcoINTAPPEXPO.get('TOTALGROUPEXPOSURE') : '');

        // as of now term loan values are not needed
        /*  requestBean.Request.ApplicationDV.AppData.INTAPPTOT = new PowerCurveUpdateApplication_Req_IB_v1.INTAPPTOT();
        requestBean.Request.ApplicationDV.AppData.INTAPPTOT.INSTSETTLEMENTS ='';//d
        requestBean.Request.ApplicationDV.AppData.INTAPPTOT.LOANREQ ='';//d
        requestBean.Request.ApplicationDV.AppData.INTAPPTOT.SETTLEMENTSAMNT ='';//d*/

        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP = new PowerCurveUpdateApplication_Req_IB_v1.INTAPPNCAP();
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.MAINITFEESFIRST = String.valueOf(pcoINTAPPNCAP.get('MAINITFEESFIRST') != null ? pcoINTAPPNCAP.get('MAINITFEESFIRST') : '');
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.MAINITFEESNEXTPERC = String.valueOf(pcoINTAPPNCAP.get('MAINITFEESNEXTPERC') != null ? pcoINTAPPNCAP.get('MAINITFEESNEXTPERC') : '');
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.MAINITFEESMAX = String.valueOf(pcoINTAPPNCAP.get('MAINITFEESMAX') != null ? pcoINTAPPNCAP.get('MAINITFEESMAX') : '');
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.MAINITFEESTHRESHOLD = String.valueOf(pcoINTAPPNCAP.get('MAINITFEESTHRESHOLD') != null ? pcoINTAPPNCAP.get('MAINITFEESTHRESHOLD') : '');
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.MAMAXSERVICEFEES = String.valueOf(pcoINTAPPNCAP.get('MAMAXSERVICEFEES') != null ? pcoINTAPPNCAP.get('MAMAXSERVICEFEES') : '');
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.MAINTERESTRATE = String.valueOf(pcoINTAPPNCAP.get('MAINTERESTRATE') != null ? pcoINTAPPNCAP.get('MAINTERESTRATE') : '');
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.CAINITFEESFIRST = String.valueOf(pcoINTAPPNCAP.get('CAINITFEESFIRST') != null ? pcoINTAPPNCAP.get('CAINITFEESFIRST') : '');
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.CAINITFEESNEXTPERC = String.valueOf(pcoINTAPPNCAP.get('CAINITFEESNEXTPERC') != null ? pcoINTAPPNCAP.get('CAINITFEESNEXTPERC') : '');
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.CAINITFEESMAX = String.valueOf(pcoINTAPPNCAP.get('CAINITFEESMAX') != null ? pcoINTAPPNCAP.get('CAINITFEESMAX') : '');
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.CAINITFEESTHRESHOLD = String.valueOf(pcoINTAPPNCAP.get('CAINITFEESTHRESHOLD') != null ? pcoINTAPPNCAP.get('CAINITFEESTHRESHOLD') : '');
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.CAMAXSERVICEFEES = String.valueOf(pcoINTAPPNCAP.get('CAMAXSERVICEFEES') != null ? pcoINTAPPNCAP.get('CAMAXSERVICEFEES') : '');
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.CAINTERESTRATE = String.valueOf(pcoINTAPPNCAP.get('CAINTERESTRATE') != null ? pcoINTAPPNCAP.get('CAINTERESTRATE') : '');
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.UCTINITFEESFIRST = String.valueOf(pcoINTAPPNCAP.get('UCTINITFEESFIRST') != null ? pcoINTAPPNCAP.get('UCTINITFEESFIRST') : '');
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.UCTINITFEESNEXTPERC = String.valueOf(pcoINTAPPNCAP.get('UCTINITFEESNEXTPERC') != null ? pcoINTAPPNCAP.get('UCTINITFEESNEXTPERC') : '');
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.UCTINITFEESMAX = String.valueOf(pcoINTAPPNCAP.get('UCTINITFEESMAX') != null ? pcoINTAPPNCAP.get('UCTINITFEESMAX') : '');
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.UCTINITFEESTHRESHOLD = String.valueOf(pcoINTAPPNCAP.get('UCTINITFEESTHRESHOLD') != null ? pcoINTAPPNCAP.get('UCTINITFEESTHRESHOLD') : '');
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.UCTMAXSERVICEFEES = String.valueOf(pcoINTAPPNCAP.get('UCTMAXSERVICEFEES') != null ? pcoINTAPPNCAP.get('UCTMAXSERVICEFEES') : '');
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.UCTINTERESTRATE = String.valueOf(pcoINTAPPNCAP.get('UCTINTERESTRATE') != null ? pcoINTAPPNCAP.get('UCTINTERESTRATE') : '');
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.OCAINITFEESFIRST = String.valueOf(pcoINTAPPNCAP.get('OCAINITFEESFIRST') != null ? pcoINTAPPNCAP.get('OCAINITFEESFIRST') : '');
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.OCAINITFEESNEXTPERC = String.valueOf(pcoINTAPPNCAP.get('OCAINITFEESNEXTPERC') != null ? pcoINTAPPNCAP.get('OCAINITFEESNEXTPERC') : '');
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.OCAINITFEESMAX = String.valueOf(pcoINTAPPNCAP.get('OCAINITFEESMAX') != null ? pcoINTAPPNCAP.get('OCAINITFEESMAX') : '');
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.OCAINITFEESTHRESHOLD = String.valueOf(pcoINTAPPNCAP.get('OCAINITFEESTHRESHOLD') != null ? pcoINTAPPNCAP.get('OCAINITFEESTHRESHOLD') : '');
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.OCAMAXSERVICEFEES = String.valueOf(pcoINTAPPNCAP.get('OCAMAXSERVICEFEES') != null ? pcoINTAPPNCAP.get('OCAMAXSERVICEFEES') : '');
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.OCAINTERESTRATE = String.valueOf(pcoINTAPPNCAP.get('OCAINTERESTRATE') != null ? pcoINTAPPNCAP.get('OCAINTERESTRATE') : '');
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.STCTINITFEESFIRST = String.valueOf(pcoINTAPPNCAP.get('STCTINITFEESFIRST') != null ? pcoINTAPPNCAP.get('STCTINITFEESFIRST') : '');
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.STCTINITFEESNEXTPERC = String.valueOf(pcoINTAPPNCAP.get('STCTINITFEESNEXTPERC') != null ? pcoINTAPPNCAP.get('STCTINITFEESNEXTPERC') : '');
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.STCTINITFEESMAX = String.valueOf(pcoINTAPPNCAP.get('STCTINITFEESMAX') != null ? pcoINTAPPNCAP.get('STCTINITFEESMAX') : '');
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.STCTINITFEESTHRESHOLD = String.valueOf(pcoINTAPPNCAP.get('STCTINITFEESTHRESHOLD') != null ? pcoINTAPPNCAP.get('STCTINITFEESTHRESHOLD') : '');
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.STCTMAXSERVICEFEES = String.valueOf(pcoINTAPPNCAP.get('STCTMAXSERVICEFEES') != null ? pcoINTAPPNCAP.get('STCTMAXSERVICEFEES') : '');
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.STCTINTERESTRATE = String.valueOf(pcoINTAPPNCAP.get('STCTINTERESTRATE') != null ? pcoINTAPPNCAP.get('STCTINTERESTRATE') : '');
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.PRIMERATE = String.valueOf(pcoINTAPPNCAP.get('PRIMERATE') != null ? pcoINTAPPNCAP.get('PRIMERATE') : '');
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.REPORATE = String.valueOf(pcoINTAPPNCAP.get('REPORATE') != null ? pcoINTAPPNCAP.get('REPORATE') : '');

        //Not needed to map as of now
        requestBean.Request.ApplicationDV.AppData.INTAPPCCLP = new PowerCurveUpdateApplication_Req_IB_v1.INTAPPCCLP();
        requestBean.Request.ApplicationDV.AppData.INTAPPCCLP.TLCREDITLIFEMINAMNT = String.valueOf(pcoINTAPPCCLP.get('TLCREDITLIFEMINAMNT') != null ? pcoINTAPPCCLP.get('TLCREDITLIFEMINAMNT') : '');
        requestBean.Request.ApplicationDV.AppData.INTAPPCCLP.TLCREDITLIFEMAXAMNT = String.valueOf(pcoINTAPPCCLP.get('TLCREDITLIFEMAXAMNT') != null ? pcoINTAPPCCLP.get('TLCREDITLIFEMAXAMNT') : '');
        requestBean.Request.ApplicationDV.AppData.INTAPPCCLP.ODCREDITLIFEMINAMNT = String.valueOf(pcoINTAPPCCLP.get('ODCREDITLIFEMINAMNT') != null ? pcoINTAPPCCLP.get('ODCREDITLIFEMINAMNT') : '');
        requestBean.Request.ApplicationDV.AppData.INTAPPCCLP.ODCREDITLIFEMAXAMNT = String.valueOf(pcoINTAPPCCLP.get('ODCREDITLIFEMAXAMNT') != null ? pcoINTAPPCCLP.get('ODCREDITLIFEMAXAMNT') : '');

        requestBean = getEntityData(requestBean, pcoApplicationDv);
        requestBean =  mapExistingRequestedProducts(requestBean, pcoApplicationDv);

        return requestBean;
    }
/**
 * @description mapStage2Fields
 * @param requestBean
 * @param pcoId
 * @param stage
 * @author  
 * @return 
 */
    public static PowerCurveUpdateApplication_Req_IB_v1 mapStage2Fields(PowerCurveUpdateApplication_Req_IB_v1 requestBean, String pcoId, String stage){
        if(requestBean.Request.ApplicationDV.AppData.INTAPPSECE == null){
            requestBean.Request.ApplicationDV.AppData.INTAPPSECE = new PowerCurveUpdateApplication_Req_IB_v1.INTAPPSECE();
        }

        if(requestBean.Request.ApplicationDV.AppData.APPAPPSECO == null){
            requestBean.Request.ApplicationDV.AppData.APPAPPSECO = new PowerCurveUpdateApplication_Req_IB_v1.APPAPPSECO();
        }

        if(requestBean.Request.ApplicationDV.AppData.INTAPPABSA == null){
            requestBean.Request.ApplicationDV.AppData.INTAPPABSA = new PowerCurveUpdateApplication_Req_IB_v1.INTAPPABSA();
        }

        requestBean.Request.ApplicationDV.DERPCOUNIQUENUMBER = pcoId;
        requestBean.Request.ApplicationDV.APPAPPSTAGEID = String.valueOf(stage);

        requestBean = mapExternalBankingRelationships(requestBean);
        Map<String,Double> ApplicationSecurityValues = new Map<String,Double>();
		ApplicationSecurityValues = clientsecuritiescontrollernew.calculatePowerCurveSummary(opportunityId,false);
        //requestBean.Request.ApplicationDV.AppData.INTAPPSECE.SPECASVALL = String.valueOf(application?.ASV_Securities__c).substringBefore('.');
		//requestBean.Request.ApplicationDV.AppData.INTAPPSECE.MASV = String.valueOf(application?.MASV_Securities__c).substringBefore('.');
        requestBean.Request.ApplicationDV.AppData.INTAPPSECE.SPECASVALL = (ApplicationSecurityValues!=Null && 
                                                                           ApplicationSecurityValues.containskey('ASVSpecific_Securities'))?String.valueof(ApplicationSecurityValues.get('ASVSpecific_Securities').longvalue()).substringBefore('.'):'0';
        requestBean.Request.ApplicationDV.AppData.INTAPPSECE.MASV = (ApplicationSecurityValues!=Null && 
                                                                           ApplicationSecurityValues.containskey('MASV_Bonds'))?String.valueof(ApplicationSecurityValues.get('MASV_Bonds').longvalue()).substringBefore('.'):'0';
        
        requestBean.Request.ApplicationDV.AppData.INTAPPSECE.ASVOC = (ApplicationSecurityValues!=Null && 
                                                                           ApplicationSecurityValues.containskey('ASV_Securities'))?String.valueof(ApplicationSecurityValues.get('ASV_Securities').longvalue()).substringBefore('.'):'0';
        
        //Leave the next 3 out as per spreadsheet
        requestBean.Request.ApplicationDV.AppData.INTAPPSECE.SPECASVACCSSETTLE = '0';
        requestBean.Request.ApplicationDV.AppData.INTAPPSECE.APPRSECVALUE = '0';
        requestBean.Request.ApplicationDV.AppData.INTAPPSECE.CASHCOVER = '0';

        //Leave the next 1 out as per spreadsheet
        requestBean.Request.ApplicationDV.AppData.INTAPPSECE.MASVAGRI = '0';

        //requestBean = mapSecuritiesExisting(requestBean);
        requestBean = mapSecuritiesOffered(requestBean);

        //Leave the next 1 out as per spreadsheet
        requestBean.Request.ApplicationDV.AppData.APPAPPSECO.ASVADDOFFERED = '0';

        requestBean.Request.ApplicationDV.AppData.INTAPPABSA.NUMBEROFPRODUCTS = String.valueOf(application?.Number_of_Product_Types__c);

        requestBean = getIsSecuredByMortage(requestBean);

        if(String.valueOf(opportunity.Entity_Type__c).equalsIgnoreCase('Sole Trader')){
            if(opportunity.Spouse_Account_Id__c != null){
                spouseAccount = [SELECT Id, Is_Spouse_Contribute__c FROM Account WHERE Id =: opportunity.Spouse_Account_Id__c];

                if(spouseAccount.Is_Spouse_Contribute__c){
                    requestBean.Request.ApplicationDV.AppData.APPAPPSPSESPOUSEDETAILSAVAILABLE = 'Y';
                } else {
                    requestBean.Request.ApplicationDV.AppData.APPAPPSPSESPOUSEDETAILSAVAILABLE = 'N';
                }
            }
        }

        requestBean = mapEntities(requestBean);

        return requestBean;
    }

    /**
     * @description mapExternalBankingRelationships
     * @param requestBean
     * @author  
     * @return 
     */
    public static PowerCurveUpdateApplication_Req_IB_v1 mapExternalBankingRelationships(PowerCurveUpdateApplication_Req_IB_v1 requestBean){
        List<Application_Financial_Account__c> appFinAccounts = new ApplicationFinancialAccountSelector().selectByApplicationId(application.Id);

        String hasChqAccs = 'N';
        String hasCrdtCard = 'N';
        String hasTrmLoans = 'N';
        String hasAssets = 'N';
        String hasMloans = 'N';
        String hasSavAcc = 'N';
        String hasInvAcc = 'N';
        Decimal invBalance = 0;
        Decimal savBalance = 0;
        Decimal crdtBalance = 0;
        Decimal assetOutBalance = 0;
        Decimal mLoanOutBalance = 0;
        Decimal cheqAccBalance = 0;
        Integer periodBankStat = 0;
        Integer numRetItems = 0;
        Decimal minBalance = 0;
        Decimal odLimits = 0;
        Decimal turnover = 0;
        Decimal numCheques = 0;
        Decimal numCrdCard = 0;
        Decimal numTLoans = 0;
        Decimal numAssets = 0;
        Decimal numInvst = 0;
        Decimal numSavAcc = 0;
        Decimal numMrtg = 0;

        if(appFinAccounts != null && appFinAccounts.size() > 0){
            for(Application_Financial_Account__c appFinAcc : appFinAccounts){
                if(appFinAcc.External_Banking_Relationship__c == 'External Cheque Account') {
                    numCheques++;
                    hasChqAccs = 'Y';
                    if(numCheques < 3){
                        cheqAccBalance += Integer.valueOf(appFinAcc.Balance__c != null ? appFinAcc.Balance__c : 0);
                    //}

                    //if(numCheques == 1){
                        periodBankStat += Integer.valueOf(appFinAcc.Period_Of_The_Bank_Statement_s__c);
                        numRetItems += Integer.valueOf(appFinAcc.Number_Of_Returned_Items__c);
                        minBalance += appFinAcc.Maximum_Debit_Balance__c;
                        odLimits += appFinAcc.Maximum_Overdraft_Limit__c;
                        turnover += appFinAcc.Turnover_For_The_Period__c;
                    }

                } else if(appFinAcc.External_Banking_Relationship__c == 'Business Credit Card') {
                    numCrdCard++;
                    hasCrdtCard = 'Y';
                    if(numCrdCard < 3){
                        crdtBalance += Integer.valueOf(appFinAcc.Current_Balance__c != null ? appFinAcc.Current_Balance__c : 0);
                    }
                } else if(appFinAcc.External_Banking_Relationship__c == 'External Term Loan') {
                    numTLoans++;
                    hasTrmLoans = 'Y';
                } else if(appFinAcc.External_Banking_Relationship__c == 'External Asset And Vehicle Finance') {
                    numAssets++;
                    hasAssets = 'Y';
                    if(numAssets < 3){
                        assetOutBalance += Integer.valueOf(appFinAcc.Outstanding_Balance__c != null ? appFinAcc.Outstanding_Balance__c : 0);
                    }
                } else if(appFinAcc.External_Banking_Relationship__c == 'External Investment') {
                    numInvst++;
                    hasInvAcc = 'Y';
                    if(numInvst < 3){
                        invBalance += Integer.valueOf(appFinAcc.Balance__c != null ? appFinAcc.Balance__c : 0);
                    }
                } else if(appFinAcc.External_Banking_Relationship__c == 'External Savings Account') {
                    numSavAcc++;
                    hasSavAcc = 'Y';
                    if(numSavAcc < 3){
                        savBalance += Integer.valueOf(appFinAcc.Balance__c != null ? appFinAcc.Balance__c : 0);
                    }
                } else if(appFinAcc.External_Banking_Relationship__c == 'External Mortgage Loan') {
                    numMrtg++;
                    hasMloans = 'Y';
                    if(numMrtg < 3){
                        mLoanOutBalance += Integer.valueOf(appFinAcc.Outstanding_Balance__c != null ? appFinAcc.Outstanding_Balance__c : 0);
                    }
                }
            }
        }

        if(requestBean.Request.ApplicationDV.AppData.APPAPPEXTR == null){
            requestBean.Request.ApplicationDV.AppData.APPAPPEXTR = new PowerCurveUpdateApplication_Req_IB_v1.APPAPPEXTR();
        }

        if(requestBean.Request.ApplicationDV.AppData.APPAPPBSTM == null){
            requestBean.Request.ApplicationDV.AppData.APPAPPBSTM = new PowerCurveUpdateApplication_Req_IB_v1.APPAPPBSTM();
        }

        requestBean.Request.ApplicationDV.AppData.APPAPPEXTR.CHEQACC = hasChqAccs;
        requestBean.Request.ApplicationDV.AppData.APPAPPEXTR.INVAMNT = String.valueOf(invBalance);
        requestBean.Request.ApplicationDV.AppData.APPAPPEXTR.SAVAMNT = String.valueOf(savBalance);
        requestBean.Request.ApplicationDV.AppData.APPAPPEXTR.CARDAMNT = String.valueOf(crdtBalance);
        requestBean.Request.ApplicationDV.AppData.APPAPPEXTR.ASSETAMNT = String.valueOf(assetOutBalance);
        requestBean.Request.ApplicationDV.AppData.APPAPPEXTR.MLOANAMNT = String.valueOf(mLoanOutBalance);
        requestBean.Request.ApplicationDV.AppData.APPAPPEXTR.CHEQAMNT = String.valueOf(cheqAccBalance);
        requestBean.Request.ApplicationDV.AppData.APPAPPEXTR.TLNACC = hasTrmLoans;
        requestBean.Request.ApplicationDV.AppData.APPAPPEXTR.INVACC = hasInvAcc;
        requestBean.Request.ApplicationDV.AppData.APPAPPEXTR.SAVACC = hasSavAcc;
        requestBean.Request.ApplicationDV.AppData.APPAPPEXTR.CARDACC = hasCrdtCard;
        requestBean.Request.ApplicationDV.AppData.APPAPPEXTR.ASSETACC = hasAssets;
        requestBean.Request.ApplicationDV.AppData.APPAPPEXTR.MLOANACC = hasMloans;
        requestBean.Request.ApplicationDV.AppData.APPAPPBSTM.PERIOD = String.valueOf(periodBankStat);
        requestBean.Request.ApplicationDV.AppData.APPAPPBSTM.NUMRDITEMS = String.valueOf(numRetItems);
        requestBean.Request.ApplicationDV.AppData.APPAPPBSTM.MINBALANCE = String.valueOf(minBalance).substringBefore('.');
        requestBean.Request.ApplicationDV.AppData.APPAPPBSTM.ODLIMITS = String.valueOf(odLimits).substringBefore('.');
        requestBean.Request.ApplicationDV.AppData.APPAPPBSTM.TURNOVER = String.valueOf(turnover).substringBefore('.');

        return requestBean;
    }

    /**
     * @description mapEntities
     * @param requestBean
     * @author  
     * @return 
     */
    public static PowerCurveUpdateApplication_Req_IB_v1 mapEntities(PowerCurveUpdateApplication_Req_IB_v1 requestBean){
        Integer numPrincipals = 0;

        if(appProfiles != null && appProfiles.size() > 0){
            Set<Id> accountIds = new Set<Id>();
            Set<String> accountIdsString = new Set<String>();

            for(Application_Profile__c appProfile : appProfiles){
                if(appProfile.Applicant_Type__c == 'Main Applicant' || appProfile.Applicant_Type__c == 'Spouse' || appProfile.Applicant_Type__c == 'Principal'){
                    accountIds.add(appProfile.Account__c);
                    accountIdsString.add(appProfile.Account__c);
                }
            }

            Map<Id, Account> accountsById = getAppProfileAccounts(accountIds);
            Map<Id, Address__c> addressesById = getAccountAddresses(accountIds);
            Map<String, String> clientUltimateGroup = getClientUltimateGroupIndicators();

            for(Application_Profile__c appProfile : appProfiles){
                Account appProfileAcc = accountsById?.get(appProfile.Account__c);
                Address__c appProfileAddress = addressesById?.get(appProfile.Account__c);

                if(appProfile.Applicant_Type__c == 'Main Applicant'){
                    requestBean.Request.ApplicationDV.Entity01 = mapPCOUpdateEntityData(requestBean.Request.ApplicationDV.Entity01, appProfileAcc, appProfileAddress, appProfile, clientUltimateGroup);
                } else if(appProfile.Applicant_Type__c == 'Spouse'){
                    requestBean.Request.ApplicationDV.Entity02 = mapPCOUpdateEntityData(requestBean.Request.ApplicationDV.Entity02, appProfileAcc, appProfileAddress, appProfile, clientUltimateGroup);
                } else if(appProfile.Applicant_Type__c == 'Principal'){
                    if(appProfile.Client_CIF_Code__c == requestBean.Request.ApplicationDV.Entity03.INTENTCLIENTCODE1){
                        requestBean.Request.ApplicationDV.Entity03 = mapPCOUpdateEntityData(requestBean.Request.ApplicationDV.Entity03, appProfileAcc, appProfileAddress, appProfile, clientUltimateGroup);
                    } else if(appProfile.Client_CIF_Code__c == requestBean.Request.ApplicationDV.Entity04.INTENTCLIENTCODE1){
                        requestBean.Request.ApplicationDV.Entity04 = mapPCOUpdateEntityData(requestBean.Request.ApplicationDV.Entity04, appProfileAcc, appProfileAddress, appProfile, clientUltimateGroup);
                    } else if(appProfile.Client_CIF_Code__c == requestBean.Request.ApplicationDV.Entity05.INTENTCLIENTCODE1){
                        requestBean.Request.ApplicationDV.Entity05 = mapPCOUpdateEntityData(requestBean.Request.ApplicationDV.Entity05, appProfileAcc, appProfileAddress, appProfile, clientUltimateGroup);
                    } else if(appProfile.Client_CIF_Code__c == requestBean.Request.ApplicationDV.Entity06.INTENTCLIENTCODE1){
                        requestBean.Request.ApplicationDV.Entity06 = mapPCOUpdateEntityData(requestBean.Request.ApplicationDV.Entity06, appProfileAcc, appProfileAddress, appProfile, clientUltimateGroup);
                    }
                }
            }
        }

        return requestBean;
    }

    /**
     * @description mapPCOUpdateEntityData
     * @param entity
     * @param appProfileAcc
     * @param appProfileAddress
     * @param appProfile
     * @param clientUltimateGroup
     * @author  
     * @return 
     */
    public static PowerCurveUpdateApplication_Req_IB_v1.Entity01 mapPCOUpdateEntityData(PowerCurveUpdateApplication_Req_IB_v1.Entity01 entity, Account appProfileAcc, Address__c appProfileAddress, Application_Profile__c appProfile, Map<String, String> clientUltimateGroup){
        entity.INTENTPARTOFCREDITGROUP = clientUltimateGroup.get(appProfile.Client_Name__c) == null? '' : clientUltimateGroup.get(appProfile.Client_Name__c);
        //entity.APPENTIDTYPE = appProfileAcc == null ? '' : getIdType(appProfileAcc.ID_Type__pc == null || appProfileAcc.ID_Type__pc == '' ? appProfileAcc.ID_Type__c : appProfileAcc.ID_Type__pc);
        entity.APPENTTEMPPERMITNUM = appProfileAcc == null ? '' : String.valueOf(appProfileAcc.Temporary_Resident_Permit_Number__c);
        entity.APPENTGENDER = appProfileAcc == null ? '' : getAccountGender(appProfileAcc.Gender__pc);
        entity.APPENTHOMECELLNUM = appProfileAcc == null ? '' : appProfileAcc.PersonHomePhone;
        entity.APPENTWORKADDRLINE1 = appProfileAcc == null ? '' : appProfileAcc.Business_Address_Line_1__c;
        entity.APPENTWORKADDRLINE2 = appProfileAcc == null ? '' : appProfileAcc.Business_Address_Line_2__c;
        entity.APPENTWORKADDRSUBURB = appProfileAddress == null ? '' : appProfileAddress.Shipping_Suburb__c;
        entity.APPENTWORKADDRCITY = appProfileAddress == null ? '' : appProfileAddress.Shipping_City__c;
        entity.APPENTWORKADDRPCODE = appProfileAddress == null ? '' : appProfileAddress.Shipping_Zip_Postal_Code__c;
        entity.APPENTPASSPORTNATIONALITY = appProfileAcc == null ? '' : appProfileAcc.Nationality__pc;
        entity.APPENTEMAIL = appProfileAcc == null ? '' : appProfileAcc.Active_Email__c;
        entity.APPENTRESIDENTIALSTATUS = appProfileAcc == null ? '' : appProfileAcc.Residential_Status__c == null ? appProfileAcc.Residential_Status__pc : appProfileAcc.Residential_Status__c;
        entity.APPENTGROSSINCOME = appProfileAcc == null ? '0' : String.valueOf(appProfileAcc.Annual_Gross_Income__pc);
        entity.APPENTINCOMETAXNUM = appProfileAcc == null ? '' : String.valueOf(appProfileAcc.Income_Tax_Number__c == null ? appProfileAcc.Income_Tax_Number__pc : appProfileAcc.Income_Tax_Number__c);
        entity.APPENTAPPLCATEGORY = '';

        return entity;
    }

    /**
     * @description mapSecuritiesExisting
     * @param RequestedProductObj
     * @author  Changes made by Tinashe M Shoko
     * @return 
     */
    public static PowerCurveUpdateApplication_Req_IB_v1.RequestedProducts01 mapSecuritiesExisting(PowerCurveUpdateApplication_Req_IB_v1.RequestedProducts01 RequestedProductObj){
        Decimal ASVAPPLICANT = 0;
        Decimal ASVPRINCIPAL = 0;
        Integer ASVOC = 0;
        Integer MASV = 0;
        String CESSIONDEBTORS = 'N';
        
        //List<Application_Security__c> appSecurities = new ApplicationSecuritySelector().selectByApplicationIdTextSet(new Set<ID>{application.Id});
        List<Application_Product__c> appList = [select id, name, Temp_Account_Number__c, Account_Number__c, Application__c,
                                                Opportunity__c from Application_Product__c where Name =: RequestedProductObj.APPPRDNEWF.UNIQUEPRODID];

        if(appList != null && appList.size() > 0){
            String acc = String.valueOf(appList.get(0).Account_Number__c) != null ? String.valueOf(appList.get(0).Account_Number__c) : 'CHQ-' + appList.get(0).Temp_Account_Number__c;
            List<Security_Offered__c> securitiesOffered = new securitiesOfferedSelector().selectByAppIdAndRefNum(application.Id, acc);
            
            if(securitiesOffered != null && securitiesOffered.size() > 0){
                for(Security_Offered__c appSecurity : securitiesOffered){
                    if(appSecurity.Security_Type__c == 'Cession of Debtors'){
                        CESSIONDEBTORS ='Y';
                    }
                    
                    ASVOC += Integer.valueOf(appSecurity.Approved_security_value__c != null? appSecurity.Approved_security_value__c : 0);
                    MASV += Integer.valueOf(appSecurity.Approved_security_value__c != null? appSecurity.Approved_security_value__c : 0);
                    
                    if(appSecurity.Specific_Security__c == 'Yes'){
                        if((appSecurity.Contact__c == null) && appSecurity.External_Entity_Linked__c == true){
                            ASVAPPLICANT += Integer.valueOf(appSecurity.Approved_security_value__c != null ? appSecurity.Approved_security_value__c : 0);
                        } else {
                            ASVPRINCIPAL += Integer.valueOf(appSecurity.Approved_security_value__c != null ? appSecurity.Approved_security_value__c : 0);
                        }
                    }
                }
            }
        }
        
        RequestedProductObj.APPPRDSECO = new PowerCurveUpdateApplication_Req_IB_v1.APPPRDSECO();
        RequestedProductObj.APPPRDSECO.SPECIFIC = String.valueOf(ASVAPPLICANT);
        RequestedProductObj.APPPRDSECO.SUPPORTINGSPECIFIC = String.valueOf(ASVPRINCIPAL);
        
        return RequestedProductObj;
    }
    /**
     * @description mapSecuritiesOffered
     * @param requestBean
     * @author  Changes made by Tinashe M Shoko
     * @return 
     */
    public static PowerCurveUpdateApplication_Req_IB_v1 mapSecuritiesOffered(PowerCurveUpdateApplication_Req_IB_v1 requestBean){
        //List<Security_Offered__c> securitiesOffered = [SELECT Id, Approved_security_value__c, ASV_approved_by_Credit__c, Security_Type__c, Limited_pledge__c, Specific_Security__c, Application__c FROM Security_Offered__c WHERE Application__c =: application.Id];
        List<Security_Offered__c> securitiesOffered = new securitiesOfferedSelector().selectByApplicationId(application.Id);
        String PERCNORMCHANGED = 'N';
        //String CESSIONDEBTORS = 'N';
        String OUSTANDINGSEC = 'N';
        Decimal ASVOFFERED = 0;
        Decimal SUPPORTINGSPECIFIC = 0;
        Decimal SUPPORTINGNONSPECIFIC = 0;

        for(Security_Offered__c securityOffered : securitiesOffered){
            // an external security provider not linked to an internal salesforce client/entity/account should have External_Entity_Linked__c == false
            if (securityOffered.Contact__c == null && securityOffered.External_Entity_Linked__c == true){
                ASVOFFERED += securityOffered.Approved_security_value__c != null ? securityOffered.Approved_security_value__c : 0;
            }

            if(securityOffered.ASV_approved_by_Credit__c != null){
                PERCNORMCHANGED = 'Y';
            }

            /*if(securityOffered.Security_Type__c.equals('Cession of Debtors')){
                CESSIONDEBTORS = 'Y';
            } else */if(securityOffered.Security_Type__c.equals('Security Outstanding')){
                OUSTANDINGSEC = securityOffered.Limited_pledge__c == null ? '' : securityOffered.Limited_pledge__c;
            }

            if(securityOffered.Specific_Security__c == 'Yes' && ((securityOffered.Contact__c != null && securityOffered.External_Entity_Linked__c == true)
                || (securityOffered.Contact__c == null && securityOffered.External_Entity_Linked__c == false))){
                SUPPORTINGSPECIFIC += securityOffered.Approved_security_value__c != null ? securityOffered.Approved_security_value__c : 0;
            } else if(securityOffered.Specific_Security__c == 'No' && ((securityOffered.Contact__c != null && securityOffered.External_Entity_Linked__c == true)
            || (securityOffered.Contact__c == null && securityOffered.External_Entity_Linked__c == false))){
                SUPPORTINGNONSPECIFIC += securityOffered.Approved_security_value__c != null ? securityOffered.Approved_security_value__c : 0;
            }

        }

        if(requestBean.Request.ApplicationDV.AppData.APPAPPSECO == null){
            requestBean.Request.ApplicationDV.AppData.APPAPPSECO = new PowerCurveUpdateApplication_Req_IB_v1.APPAPPSECO();
        }

        if(requestBean.Request.ApplicationDV.AppData.INTAPPSECE == null){
            requestBean.Request.ApplicationDV.AppData.INTAPPSECE = new PowerCurveUpdateApplication_Req_IB_v1.INTAPPSECE();
        }

        requestBean.Request.ApplicationDV.AppData.APPAPPSECO.ASVOFFERED = String.valueOf(ASVOFFERED).substringBefore('.');
        requestBean.Request.ApplicationDV.AppData.APPAPPSECO.SUPPORTINGNONSPECIFIC = String.valueOf(SUPPORTINGNONSPECIFIC).substringBefore('.');
        requestBean.Request.ApplicationDV.AppData.INTAPPSECE.PERCNORMCHANGED = PERCNORMCHANGED;
        //requestBean.Request.ApplicationDV.AppData.INTAPPSECE.CESSIONDEBTORS = CESSIONDEBTORS;
        requestBean.Request.ApplicationDV.AppData.INTAPPSECE.OUSTANDINGSEC = OUSTANDINGSEC;
        requestBean.Request.ApplicationDV.AppData.APPAPPSECO.SUPPORTINGSPECIFIC = String.valueOf(SUPPORTINGSPECIFIC).substringBefore('.');

        return requestBean;
    }

    /**
     * @description getIsSecuredByMortage
     * @param requestBean
     * @author  Changes made by Tinashe M Shoko
     * @return 
     */
    public static PowerCurveUpdateApplication_Req_IB_v1 getIsSecuredByMortage(PowerCurveUpdateApplication_Req_IB_v1 requestBean){
        String APPAPPSECUREDBYMORTGAGEBOND = 'N';
        String CHQACCRELATIONSHIP = '';

        if(appProducts != null && appProducts.size() > 0){

            for(Application_Product__c appProduct : appProducts){

                if(appProduct.Secured_By_Mortgage_Bond__c){
                    APPAPPSECUREDBYMORTGAGEBOND = 'Y';
                }

                if(appProduct.Account_number__c != null){
                    CHQACCRELATIONSHIP = 'S';
                }
            }
        }

        requestBean.Request.ApplicationDV.AppData.INTAPPABSA.CHQACCRELATIONSHIP = CHQACCRELATIONSHIP;
        requestBean.Request.ApplicationDV.AppData.APPAPPSECUREDBYMORTGAGEBOND = APPAPPSECUREDBYMORTGAGEBOND;

        return requestBean;
    }

    /**
     * @description mapExistingRequestedProducts
     * @param requestBean
     * @param pcoNewApplicationDv
     * @author  Changes made by Tinashe M Shoko
     * @return 
     */
    public static PowerCurveUpdateApplication_Req_IB_v1 mapExistingRequestedProducts(PowerCurveUpdateApplication_Req_IB_v1 requestBean, Map<String, Object> pcoNewApplicationDv){
        Map<String, Object> pcoNewExistProd01 = (Map<String, Object>) pcoNewApplicationDv?.get('ExistingProducts01');
        Map<String, Object> pcoNewExistProd02 = (Map<String, Object>) pcoNewApplicationDv?.get('ExistingProducts02');
        Map<String, Object> pcoNewExistProd03 = (Map<String, Object>) pcoNewApplicationDv?.get('ExistingProducts03');
        Map<String, Object> pcoNewExistProd04 = (Map<String, Object>) pcoNewApplicationDv?.get('ExistingProducts04');
        Map<String, Object> pcoNewExistProd05 = (Map<String, Object>) pcoNewApplicationDv?.get('ExistingProducts05');
        Map<String, Object> pcoNewExistProd06 = (Map<String, Object>) pcoNewApplicationDv?.get('ExistingProducts06');
        Map<String, Object> pcoNewExistProd07 = (Map<String, Object>) pcoNewApplicationDv?.get('ExistingProducts07');
        Map<String, Object> pcoNewExistProd08 = (Map<String, Object>) pcoNewApplicationDv?.get('ExistingProducts08');
        Map<String, Object> pcoNewExistProd09 = (Map<String, Object>) pcoNewApplicationDv?.get('ExistingProducts09');
        Map<String, Object> pcoNewExistProd10 = (Map<String, Object>) pcoNewApplicationDv?.get('ExistingProducts10');
        Map<String, Object> pcoNewExistProd11 = (Map<String, Object>) pcoNewApplicationDv?.get('ExistingProducts11');
        Map<String, Object> pcoNewExistProd12 = (Map<String, Object>) pcoNewApplicationDv?.get('ExistingProducts12');
        Map<String, Object> pcoNewExistProd13 = (Map<String, Object>) pcoNewApplicationDv?.get('ExistingProducts13');
        Map<String, Object> pcoNewExistProd14 = (Map<String, Object>) pcoNewApplicationDv?.get('ExistingProducts14');
        Map<String, Object> pcoNewExistProd15 = (Map<String, Object>) pcoNewApplicationDv?.get('ExistingProducts15');
        Map<String, Object> pcoNewExistProd16 = (Map<String, Object>) pcoNewApplicationDv?.get('ExistingProducts16');
        Map<String, Object> pcoNewExistProd17 = (Map<String, Object>) pcoNewApplicationDv?.get('ExistingProducts17');
        Map<String, Object> pcoNewExistProd18 = (Map<String, Object>) pcoNewApplicationDv?.get('ExistingProducts18');
        Map<String, Object> pcoNewExistProd19 = (Map<String, Object>) pcoNewApplicationDv?.get('ExistingProducts19');
        Map<String, Object> pcoNewExistProd20 = (Map<String, Object>) pcoNewApplicationDv?.get('ExistingProducts20');
        Map<String, Object> pcoNewExistProd21 = (Map<String, Object>) pcoNewApplicationDv?.get('ExistingProducts21');
        Map<String, Object> pcoNewExistProd22 = (Map<String, Object>) pcoNewApplicationDv?.get('ExistingProducts22');
        Map<String, Object> pcoNewExistProd23 = (Map<String, Object>) pcoNewApplicationDv?.get('ExistingProducts23');
        Map<String, Object> pcoNewExistProd24 = (Map<String, Object>) pcoNewApplicationDv?.get('ExistingProducts24');
        Map<String, Object> pcoNewExistProd25 = (Map<String, Object>) pcoNewApplicationDv?.get('ExistingProducts25');
        Map<String, Object> pcoNewExistProd26 = (Map<String, Object>) pcoNewApplicationDv?.get('ExistingProducts26');
        Map<String, Object> pcoNewExistProd27 = (Map<String, Object>) pcoNewApplicationDv?.get('ExistingProducts27');
        Map<String, Object> pcoNewExistProd28 = (Map<String, Object>) pcoNewApplicationDv?.get('ExistingProducts28');
        Map<String, Object> pcoNewExistProd29 = (Map<String, Object>) pcoNewApplicationDv?.get('ExistingProducts29');
        Map<String, Object> pcoNewExistProd30 = (Map<String, Object>) pcoNewApplicationDv?.get('ExistingProducts30');

        Map<String, Object> pcoNewReqProd01 = (Map<String, Object>) pcoNewApplicationDv?.get('RequestedProducts01');
        Map<String, Object> pcoNewReqProd02 = (Map<String, Object>) pcoNewApplicationDv?.get('RequestedProducts02');
        Map<String, Object> pcoNewReqProd03 = (Map<String, Object>) pcoNewApplicationDv?.get('RequestedProducts03');
        Map<String, Object> pcoNewReqProd04 = (Map<String, Object>) pcoNewApplicationDv?.get('RequestedProducts04');
        Map<String, Object> pcoNewReqProd05 = (Map<String, Object>) pcoNewApplicationDv?.get('RequestedProducts05');
        Map<String, Object> pcoNewReqProd06 = (Map<String, Object>) pcoNewApplicationDv?.get('RequestedProducts06');
        Map<String, Object> pcoNewReqProd07 = (Map<String, Object>) pcoNewApplicationDv?.get('RequestedProducts07');
        Map<String, Object> pcoNewReqProd08 = (Map<String, Object>) pcoNewApplicationDv?.get('RequestedProducts08');
        Map<String, Object> pcoNewReqProd09 = (Map<String, Object>) pcoNewApplicationDv?.get('RequestedProducts09');
        Map<String, Object> pcoNewReqProd10 = (Map<String, Object>) pcoNewApplicationDv?.get('RequestedProducts10');
        Map<String, Object> pcoNewReqProd11 = (Map<String, Object>) pcoNewApplicationDv?.get('RequestedProducts11');
        Map<String, Object> pcoNewReqProd12 = (Map<String, Object>) pcoNewApplicationDv?.get('RequestedProducts12');
        Map<String, Object> pcoNewReqProd13 = (Map<String, Object>) pcoNewApplicationDv?.get('RequestedProducts13');
        Map<String, Object> pcoNewReqProd14 = (Map<String, Object>) pcoNewApplicationDv?.get('RequestedProducts14');
        Map<String, Object> pcoNewReqProd15 = (Map<String, Object>) pcoNewApplicationDv?.get('RequestedProducts15');
        Map<String, Object> pcoNewReqProd16 = (Map<String, Object>) pcoNewApplicationDv?.get('RequestedProducts16');
        Map<String, Object> pcoNewReqProd17 = (Map<String, Object>) pcoNewApplicationDv?.get('RequestedProducts17');
        Map<String, Object> pcoNewReqProd18 = (Map<String, Object>) pcoNewApplicationDv?.get('RequestedProducts18');
        Map<String, Object> pcoNewReqProd19 = (Map<String, Object>) pcoNewApplicationDv?.get('RequestedProducts19');
        Map<String, Object> pcoNewReqProd20 = (Map<String, Object>) pcoNewApplicationDv?.get('RequestedProducts20');
        Map<String, Object> pcoNewReqProd21 = (Map<String, Object>) pcoNewApplicationDv?.get('RequestedProducts21');
        Map<String, Object> pcoNewReqProd22 = (Map<String, Object>) pcoNewApplicationDv?.get('RequestedProducts22');
        Map<String, Object> pcoNewReqProd23 = (Map<String, Object>) pcoNewApplicationDv?.get('RequestedProducts23');
        Map<String, Object> pcoNewReqProd24 = (Map<String, Object>) pcoNewApplicationDv?.get('RequestedProducts24');
        Map<String, Object> pcoNewReqProd25 = (Map<String, Object>) pcoNewApplicationDv?.get('RequestedProducts25');
        Map<String, Object> pcoNewReqProd26 = (Map<String, Object>) pcoNewApplicationDv?.get('RequestedProducts26');
        Map<String, Object> pcoNewReqProd27 = (Map<String, Object>) pcoNewApplicationDv?.get('RequestedProducts27');
        Map<String, Object> pcoNewReqProd28 = (Map<String, Object>) pcoNewApplicationDv?.get('RequestedProducts28');
        Map<String, Object> pcoNewReqProd29 = (Map<String, Object>) pcoNewApplicationDv?.get('RequestedProducts29');
        Map<String, Object> pcoNewReqProd30 = (Map<String, Object>) pcoNewApplicationDv?.get('RequestedProducts30');

        if(pcoNewExistProd01 != null){
            requestBean.Request.ApplicationDV.ExistingProducts01 = mapExistingProducts(pcoNewExistProd01);
        }

        if(pcoNewExistProd02 != null){
            requestBean.Request.ApplicationDV.ExistingProducts02 = mapExistingProducts(pcoNewExistProd02);
        }

        if(pcoNewExistProd03 != null){
            requestBean.Request.ApplicationDV.ExistingProducts03 = mapExistingProducts(pcoNewExistProd03);
        }

        if(pcoNewExistProd04 != null){
            requestBean.Request.ApplicationDV.ExistingProducts04 = mapExistingProducts(pcoNewExistProd04);
        }

        if(pcoNewExistProd05 != null){
            requestBean.Request.ApplicationDV.ExistingProducts05 = mapExistingProducts(pcoNewExistProd05);
        }

        if(pcoNewExistProd06 != null){
            requestBean.Request.ApplicationDV.ExistingProducts06 = mapExistingProducts(pcoNewExistProd06);
        }

        if(pcoNewExistProd07 != null){
            requestBean.Request.ApplicationDV.ExistingProducts07 = mapExistingProducts(pcoNewExistProd07);
        }

        if(pcoNewExistProd08 != null){
            requestBean.Request.ApplicationDV.ExistingProducts08 = mapExistingProducts(pcoNewExistProd08);
        }

        if(pcoNewExistProd09 != null){
            requestBean.Request.ApplicationDV.ExistingProducts09 = mapExistingProducts(pcoNewExistProd09);
        }

        if(pcoNewExistProd10 != null){
            requestBean.Request.ApplicationDV.ExistingProducts10 = mapExistingProducts(pcoNewExistProd10);
        }

        if(pcoNewExistProd11 != null){
            requestBean.Request.ApplicationDV.ExistingProducts11 = mapExistingProducts(pcoNewExistProd11);
        }

        if(pcoNewExistProd12 != null){
            requestBean.Request.ApplicationDV.ExistingProducts12 = mapExistingProducts(pcoNewExistProd12);
        }

        if(pcoNewExistProd13 != null){
            requestBean.Request.ApplicationDV.ExistingProducts13 = mapExistingProducts(pcoNewExistProd13);
        }

        if(pcoNewExistProd14 != null){
            requestBean.Request.ApplicationDV.ExistingProducts14 = mapExistingProducts(pcoNewExistProd14);
        }

        if(pcoNewExistProd15 != null){
            requestBean.Request.ApplicationDV.ExistingProducts15 = mapExistingProducts(pcoNewExistProd15);
        }

        if(pcoNewExistProd16 != null){
            requestBean.Request.ApplicationDV.ExistingProducts16 = mapExistingProducts(pcoNewExistProd16);
        }

        if(pcoNewExistProd17 != null){
            requestBean.Request.ApplicationDV.ExistingProducts17 = mapExistingProducts(pcoNewExistProd17);
        }

        if(pcoNewExistProd18 != null){
            requestBean.Request.ApplicationDV.ExistingProducts18 = mapExistingProducts(pcoNewExistProd18);
        }

        if(pcoNewExistProd19 != null){
            requestBean.Request.ApplicationDV.ExistingProducts19 = mapExistingProducts(pcoNewExistProd19);
        }

        if(pcoNewExistProd20 != null){
            requestBean.Request.ApplicationDV.ExistingProducts20 = mapExistingProducts(pcoNewExistProd20);
        }

        if(pcoNewExistProd21 != null){
            requestBean.Request.ApplicationDV.ExistingProducts21 = mapExistingProducts(pcoNewExistProd21);
        }

        if(pcoNewExistProd22 != null){
            requestBean.Request.ApplicationDV.ExistingProducts22 = mapExistingProducts(pcoNewExistProd22);
        }

        if(pcoNewExistProd23 != null){
            requestBean.Request.ApplicationDV.ExistingProducts23 = mapExistingProducts(pcoNewExistProd23);
        }

        if(pcoNewExistProd24 != null){
            requestBean.Request.ApplicationDV.ExistingProducts24 = mapExistingProducts(pcoNewExistProd24);
        }

        if(pcoNewExistProd25 != null){
            requestBean.Request.ApplicationDV.ExistingProducts25 = mapExistingProducts(pcoNewExistProd25);
        }

        if(pcoNewExistProd26 != null){
            requestBean.Request.ApplicationDV.ExistingProducts26 = mapExistingProducts(pcoNewExistProd26);
        }

        if(pcoNewExistProd27 != null){
            requestBean.Request.ApplicationDV.ExistingProducts27 = mapExistingProducts(pcoNewExistProd27);
        }

        if(pcoNewExistProd28 != null){
            requestBean.Request.ApplicationDV.ExistingProducts28 = mapExistingProducts(pcoNewExistProd28);
        }

        if(pcoNewExistProd29 != null){
            requestBean.Request.ApplicationDV.ExistingProducts29 = mapExistingProducts(pcoNewExistProd29);
        }

        if(pcoNewExistProd30 != null){
            requestBean.Request.ApplicationDV.ExistingProducts30 = mapExistingProducts(pcoNewExistProd30);
        }

        if(pcoNewReqProd01 != null){
            requestBean.Request.ApplicationDV.RequestedProducts01 = mapRequestedProducts(pcoNewReqProd01);
        }

        if(pcoNewReqProd02 != null){
            requestBean.Request.ApplicationDV.RequestedProducts02 = mapRequestedProducts(pcoNewReqProd02);
        }

        if(pcoNewReqProd03 != null){
            requestBean.Request.ApplicationDV.RequestedProducts03 = mapRequestedProducts(pcoNewReqProd03);
        }

        if(pcoNewReqProd04 != null){
            requestBean.Request.ApplicationDV.RequestedProducts04 = mapRequestedProducts(pcoNewReqProd04);
        }

        if(pcoNewReqProd05 != null){
            requestBean.Request.ApplicationDV.RequestedProducts05 = mapRequestedProducts(pcoNewReqProd05);
        }

        if(pcoNewReqProd06 != null){
            requestBean.Request.ApplicationDV.RequestedProducts06 = mapRequestedProducts(pcoNewReqProd06);
        }

        if(pcoNewReqProd07 != null){
            requestBean.Request.ApplicationDV.RequestedProducts07 = mapRequestedProducts(pcoNewReqProd07);
        }

        if(pcoNewReqProd08 != null){
            requestBean.Request.ApplicationDV.RequestedProducts08 = mapRequestedProducts(pcoNewReqProd08);
        }

        if(pcoNewReqProd09 != null){
            requestBean.Request.ApplicationDV.RequestedProducts09 = mapRequestedProducts(pcoNewReqProd09);
        }

        if(pcoNewReqProd10 != null){
            requestBean.Request.ApplicationDV.RequestedProducts10 = mapRequestedProducts(pcoNewReqProd10);
        }

        if(pcoNewReqProd11 != null){
            requestBean.Request.ApplicationDV.RequestedProducts11 = mapRequestedProducts(pcoNewReqProd11);
        }

        if(pcoNewReqProd12 != null){
            requestBean.Request.ApplicationDV.RequestedProducts12 = mapRequestedProducts(pcoNewReqProd12);
        }

        if(pcoNewReqProd13 != null){
            requestBean.Request.ApplicationDV.RequestedProducts13 = mapRequestedProducts(pcoNewReqProd13);
        }

        if(pcoNewReqProd14 != null){
            requestBean.Request.ApplicationDV.RequestedProducts14 = mapRequestedProducts(pcoNewReqProd14);
        }

        if(pcoNewReqProd15 != null){
            requestBean.Request.ApplicationDV.RequestedProducts15 = mapRequestedProducts(pcoNewReqProd15);
        }

        if(pcoNewReqProd16 != null){
            requestBean.Request.ApplicationDV.RequestedProducts16 = mapRequestedProducts(pcoNewReqProd16);
        }

        if(pcoNewReqProd17 != null){
            requestBean.Request.ApplicationDV.RequestedProducts17 = mapRequestedProducts(pcoNewReqProd17);
        }

        if(pcoNewReqProd18 != null){
            requestBean.Request.ApplicationDV.RequestedProducts18 = mapRequestedProducts(pcoNewReqProd18);
        }

        if(pcoNewReqProd19 != null){
            requestBean.Request.ApplicationDV.RequestedProducts19 = mapRequestedProducts(pcoNewReqProd19);
        }

        if(pcoNewReqProd20 != null){
            requestBean.Request.ApplicationDV.RequestedProducts20 = mapRequestedProducts(pcoNewReqProd20);
        }

        if(pcoNewReqProd21 != null){
            requestBean.Request.ApplicationDV.RequestedProducts21 = mapRequestedProducts(pcoNewReqProd21);
        }

        if(pcoNewReqProd22 != null){
            requestBean.Request.ApplicationDV.RequestedProducts22 = mapRequestedProducts(pcoNewReqProd22);
        }

        if(pcoNewReqProd23 != null){
            requestBean.Request.ApplicationDV.RequestedProducts23 = mapRequestedProducts(pcoNewReqProd23);
        }

        if(pcoNewReqProd24 != null){
            requestBean.Request.ApplicationDV.RequestedProducts24 = mapRequestedProducts(pcoNewReqProd24);
        }

        if(pcoNewReqProd25 != null){
            requestBean.Request.ApplicationDV.RequestedProducts25 = mapRequestedProducts(pcoNewReqProd25);
        }

        if(pcoNewReqProd26 != null){
            requestBean.Request.ApplicationDV.RequestedProducts26 = mapRequestedProducts(pcoNewReqProd26);
        }

        if(pcoNewReqProd27 != null){
            requestBean.Request.ApplicationDV.RequestedProducts27 = mapRequestedProducts(pcoNewReqProd27);
        }

        if(pcoNewReqProd28 != null){
            requestBean.Request.ApplicationDV.RequestedProducts28 = mapRequestedProducts(pcoNewReqProd28);
        }

        if(pcoNewReqProd29 != null){
            requestBean.Request.ApplicationDV.RequestedProducts29 = mapRequestedProducts(pcoNewReqProd29);
        }

        if(pcoNewReqProd30 != null){
            requestBean.Request.ApplicationDV.RequestedProducts30 = mapRequestedProducts(pcoNewReqProd30);
        }

        return requestBean;
    }

     /**
     * @description mapExistingProducts
     * @param pcoNewExistProd
     * @author  Changes made by 
     * @return 
     */
    public static PowerCurveUpdateApplication_Req_IB_v1.ExistingProducts01 mapExistingProducts(Map<String, Object> pcoNewExistProd){
        Map<String, Object> pcoNewINTPRDEXST = (Map<String, Object>) pcoNewExistProd?.get('INTPRDEXST');
        Map<String, Object> pcoNewAPPPRDEXST = (Map<String, Object>) pcoNewExistProd?.get('APPPRDEXST');

        PowerCurveUpdateApplication_Req_IB_v1.ExistingProducts01 ExistingProductObj = new PowerCurveUpdateApplication_Req_IB_v1.ExistingProducts01();
        ExistingProductObj.INTPRDEXST = new PowerCurveUpdateApplication_Req_IB_v1.INTPRDEXST();
        ExistingProductObj.INTPRDEXST.PRODUCT = String.valueOf(pcoNewINTPRDEXST?.get('PRODUCT'));
        ExistingProductObj.INTPRDEXST.PRODUCTTYPE = String.valueOf(pcoNewINTPRDEXST?.get('PRODUCTTYPE'));
        ExistingProductObj.INTPRDEXST.CURRBALANCE = String.valueOf(pcoNewINTPRDEXST?.get('CURRBALANCE'));
        ExistingProductObj.INTPRDEXST.CURRLIMIT = String.valueOf(pcoNewINTPRDEXST?.get('CURRLIMIT'));
        ExistingProductObj.INTPRDEXST.CURRINTRATEPRIMEOFFSET = String.valueOf(pcoNewINTPRDEXST?.get('CURRINTRATEPRIMEOFFSET'));
        ExistingProductObj.INTPRDEXST.CURRREDUCTIONAMNT = String.valueOf(pcoNewINTPRDEXST?.get('CURRREDUCTIONAMNT'));
        ExistingProductObj.INTPRDEXST.CURRREDUCTIONFREQ = String.valueOf(pcoNewINTPRDEXST?.get('CURRREDUCTIONFREQ'));
        ExistingProductObj.INTPRDEXST.CURRONCEOFFREDUCTION = String.valueOf(pcoNewINTPRDEXST?.get('CURRONCEOFFREDUCTION'));
        ExistingProductObj.INTPRDEXST.CURREXISTEMPOWERMNTFUNDIND = String.valueOf(pcoNewINTPRDEXST?.get('CURREXISTEMPOWERMNTFUNDIND'));
        ExistingProductObj.INTPRDEXST.CURREXISTEMPOWERMNTFUND = String.valueOf(pcoNewINTPRDEXST?.get('CURREXISTEMPOWERMNTFUND'));
        ExistingProductObj.INTPRDEXST.ACCOUNTNUMBER = String.valueOf(pcoNewINTPRDEXST?.get('ACCOUNTNUMBER'));
        ExistingProductObj.INTPRDEXST.CURRSUBPRODTYPE = String.valueOf(pcoNewINTPRDEXST?.get('CURRSUBPRODTYPE'));
        ExistingProductObj.INTPRDEXST.CURRINSTALLMENT = String.valueOf(pcoNewINTPRDEXST?.get('CURRINSTALLMENT'));
        ExistingProductObj.INTPRDEXST.CURRINSTALMNTFREQ = String.valueOf(pcoNewINTPRDEXST?.get('CURRINSTALMNTFREQ'));
        ExistingProductObj.INTPRDEXST.CURRSETTLEMENTAMNT = String.valueOf(pcoNewINTPRDEXST?.get('CURRSETTLEMENTAMNT'));
        ExistingProductObj.INTPRDEXST.CURRINITFEEPREVDEBITED = String.valueOf(pcoNewINTPRDEXST?.get('CURRINITFEEPREVDEBITED'));
        ExistingProductObj.INTPRDEXST.NCAMAXINITFEEAMNT = String.valueOf(pcoNewINTPRDEXST?.get('NCAMAXINITFEEAMNT'));
        ExistingProductObj.INTPRDEXST.ESPINSTRUCTION = String.valueOf(pcoNewINTPRDEXST?.get('ESPINSTRUCTION'));
        ExistingProductObj.INTPRDEXST.CARDTYPE = String.valueOf(pcoNewINTPRDEXST?.get('CARDTYPE'));

        ExistingProductObj.APPPRDEXST = new PowerCurveUpdateApplication_Req_IB_v1.APPPRDEXST();
        ExistingProductObj.APPPRDEXST.APPLICATIONSTATUS = String.valueOf(pcoNewAPPPRDEXST?.get('APPLICATIONSTATUS'));
        ExistingProductObj.APPPRDEXST.REQFACILITYTYPE = String.valueOf(pcoNewAPPPRDEXST?.get('REQFACILITYTYPE'));
        ExistingProductObj.APPPRDEXST.REQPRODTYPE = String.valueOf(pcoNewAPPPRDEXST?.get('REQPRODTYPE'));
        ExistingProductObj.APPPRDEXST.REQTOTALAMNT = String.valueOf(pcoNewAPPPRDEXST?.get('REQTOTALAMNT'));
        ExistingProductObj.APPPRDEXST.REQODLIMITTYPE = String.valueOf(pcoNewAPPPRDEXST?.get('REQODLIMITTYPE'));
        ExistingProductObj.APPPRDEXST.REQREDUCTIONAMNT = String.valueOf(pcoNewAPPPRDEXST?.get('REQREDUCTIONAMNT'));
        ExistingProductObj.APPPRDEXST.REQREDUCTIONFREQ = String.valueOf(pcoNewAPPPRDEXST?.get('REQREDUCTIONFREQ'));
        ExistingProductObj.APPPRDEXST.REQONCEOFFFREQAMNT = String.valueOf(pcoNewAPPPRDEXST?.get('REQONCEOFFFREQAMNT'));
        ExistingProductObj.APPPRDEXST.REQPURPOSEFACILITYORLOAN = String.valueOf(pcoNewAPPPRDEXST?.get('REQPURPOSEFACILITYORLOAN'));
        ExistingProductObj.APPPRDEXST.REQREQEMPOWERMNTFUNDIND = String.valueOf(pcoNewAPPPRDEXST?.get('REQREQEMPOWERMNTFUNDIND'));
        ExistingProductObj.APPPRDEXST.REQREQEMPOWERMNTFUND = String.valueOf(pcoNewAPPPRDEXST?.get('REQREQEMPOWERMNTFUND'));
        ExistingProductObj.APPPRDEXST.REQCAMPAIGNCODE = String.valueOf(pcoNewAPPPRDEXST?.get('REQCAMPAIGNCODE'));
        ExistingProductObj.APPPRDEXST.REQSUBPRODTYPE = String.valueOf(pcoNewAPPPRDEXST?.get('REQSUBPRODTYPE'));
        ExistingProductObj.APPPRDEXST.REQADDITIONALAMNT = String.valueOf(pcoNewAPPPRDEXST?.get('REQADDITIONALAMNT'));
        ExistingProductObj.APPPRDEXST.REQREPAYMNTOPTION = String.valueOf(pcoNewAPPPRDEXST?.get('REQREPAYMNTOPTION'));
        ExistingProductObj.APPPRDEXST.REQTERMOFLOAN = String.valueOf(pcoNewAPPPRDEXST?.get('REQTERMOFLOAN'));
        ExistingProductObj.APPPRDEXST.REQINSTALLMENTFREQ = String.valueOf(pcoNewAPPPRDEXST?.get('REQINSTALLMENTFREQ'));
        ExistingProductObj.APPPRDEXST.REQNUMSKIPPEDPAYMNTS = String.valueOf(pcoNewAPPPRDEXST?.get('REQNUMSKIPPEDPAYMNTS'));
        ExistingProductObj.APPPRDEXST.REQINITIATIONFEEPAYMNTMETHOD = String.valueOf(pcoNewAPPPRDEXST?.get('REQINITIATIONFEEPAYMNTMETHOD'));
        ExistingProductObj.APPPRDEXST.REQPAYMNTMETHOD = String.valueOf(pcoNewAPPPRDEXST?.get('REQPAYMNTMETHOD'));
        ExistingProductObj.APPPRDEXST.REQCREDLIFEPREMIUM = String.valueOf(pcoNewAPPPRDEXST?.get('REQCREDLIFEPREMIUM'));
        ExistingProductObj.APPPRDEXST.REQLIMITTYPEIND = String.valueOf(pcoNewAPPPRDEXST?.get('REQLIMITTYPEIND'));
        ExistingProductObj.APPPRDEXST.REQPRODCOMBINATIONNUM = String.valueOf(pcoNewAPPPRDEXST?.get('REQPRODCOMBINATIONNUM'));
        ExistingProductObj.INTPRDEXST.SECUREDBYMORTGAGEBOND = String.valueOf(pcoNewAPPPRDEXST?.get('SECUREDBYMORTGAGEBOND'));

        ExistingProductObj.INTPRDSECE = new PowerCurveUpdateApplication_Req_IB_v1.INTPRDSECE();

        Decimal SPECASVFULL = 0;
        if(!test.isRunningTest()){
        SPECASVFULL = ClientSecuritiesControllerNew.calculatePowerCurveSummaryProducts(opportunity.Id,String.valueOf(pcoNewINTPRDEXST?.get('ACCOUNTNUMBER'))).get('ASVSpecific_Securities');
        }
        //SPECASVFULL += Integer.valueOf(application.ASV_Securities__c != null? application.ASV_Securities__c : 0);

        ExistingProductObj.INTPRDSECE.SPECASVFULL = SPECASVFULL != null ? String.valueOf(SPECASVFULL).substringBefore('.'):'0';
        ExistingProductObj.INTPRDSECE.SPECASVLIMITED = '0';

        //ExistingProductObj = mapSecuritiesExisting(ExistingProductObj);

        for (Application_Product__c appProduct : appProducts) {
            if(String.valueOf(pcoNewINTPRDEXST?.get('ACCOUNTNUMBER')).equalsIgnoreCase(String.valueOf(appProduct.Account_Number__c))){
                ExistingProductObj.INTPRDEXST.CURRENFORCEDREDLIM = appProduct.Enforced_Reducing_Limit__c == null ? 'N' : 'Y';
                ExistingProductObj.APPPRDEXST.INITIATIONFEEPAYMNTMETHOD = '';
            }
        }

        return ExistingProductObj;
    }

     /**
     * @description mapRequestedProducts
     * @param pcoNewReqProd
     * @author  Changes made by Tinashe M Shoko
     * @return 
     */
    public static PowerCurveUpdateApplication_Req_IB_v1.RequestedProducts01 mapRequestedProducts(Map<String, Object> pcoNewReqProd){
        Map<String, Object> pcoNewAPPPRDNEWF = (Map<String, Object>) pcoNewReqProd?.get('APPPRDNEWF');
        Map<String, Object> pcoNewINTPRDNEWF = (Map<String, Object>) pcoNewReqProd?.get('INTPRDNEWF');

        PowerCurveUpdateApplication_Req_IB_v1.RequestedProducts01 RequestedProductObj = new PowerCurveUpdateApplication_Req_IB_v1.RequestedProducts01();

        if(RequestedProductObj.APPPRDNEWF == null){
            RequestedProductObj.APPPRDNEWF = new PowerCurveUpdateApplication_Req_IB_v1.APPPRDNEWF();
        }

        RequestedProductObj.APPPRDNEWF.SECUREDBYMORTGAGEBOND = String.valueOf(pcoNewAPPPRDNEWF?.get('SECUREDBYMORTGAGEBOND'));
        RequestedProductObj.APPPRDNEWF.UNIQUEPRODID = String.valueOf(pcoNewAPPPRDNEWF?.get('UNIQUEPRODID'));
        RequestedProductObj.APPPRDNEWF.APPLICATIONSTATUS = String.valueOf(pcoNewAPPPRDNEWF?.get('APPLICATIONSTATUS'));
        RequestedProductObj.APPPRDNEWF.REQPRODUCT = String.valueOf(pcoNewAPPPRDNEWF?.get('REQPRODUCT'));
        RequestedProductObj.APPPRDNEWF.REQFACILITYTYPE = String.valueOf(pcoNewAPPPRDNEWF?.get('REQFACILITYTYPE'));
        RequestedProductObj.APPPRDNEWF.REQPRODTYPE = String.valueOf(pcoNewAPPPRDNEWF?.get('REQPRODTYPE'));
        RequestedProductObj.APPPRDNEWF.REQADDITIONALAMNT = String.valueOf(pcoNewAPPPRDNEWF?.get('REQADDITIONALAMNT'));
        RequestedProductObj.APPPRDNEWF.REQTOTALAMNT = String.valueOf(pcoNewAPPPRDNEWF?.get('REQTOTALAMNT'));
        RequestedProductObj.APPPRDNEWF.REQODLIMITTYPE = String.valueOf(pcoNewAPPPRDNEWF?.get('REQODLIMITTYPE'));
        RequestedProductObj.APPPRDNEWF.REQREDUCTIONAMNT = String.valueOf(pcoNewAPPPRDNEWF?.get('REQREDUCTIONAMNT'));
        RequestedProductObj.APPPRDNEWF.REQREDUCTIONFREQ = String.valueOf(pcoNewAPPPRDNEWF?.get('REQREDUCTIONFREQ'));
        RequestedProductObj.APPPRDNEWF.REQONCEOFFFREQAMNT = String.valueOf(pcoNewAPPPRDNEWF?.get('REQONCEOFFFREQAMNT'));
        RequestedProductObj.APPPRDNEWF.REQPURPOSEFACILITYORLOAN = String.valueOf(pcoNewAPPPRDNEWF?.get('REQPURPOSEFACILITYORLOAN'));
        RequestedProductObj.APPPRDNEWF.REQTERMOFLOAN = String.valueOf(pcoNewAPPPRDNEWF?.get('REQTERMOFLOAN'));
        RequestedProductObj.APPPRDNEWF.REQINSTALLMENTFREQ = String.valueOf(pcoNewAPPPRDNEWF?.get('REQINSTALLMENTFREQ'));
        RequestedProductObj.APPPRDNEWF.REQNUMSKIPPEDPAYMNTS = String.valueOf(pcoNewAPPPRDNEWF?.get('REQNUMSKIPPEDPAYMNTS'));
        RequestedProductObj.APPPRDNEWF.REQINITIATIONFEEPAYMNTMETHOD = String.valueOf(pcoNewAPPPRDNEWF?.get('REQINITIATIONFEEPAYMNTMETHOD'));
        RequestedProductObj.APPPRDNEWF.REQPAYMNTMETHOD = String.valueOf(pcoNewAPPPRDNEWF?.get('REQPAYMNTMETHOD'));
        RequestedProductObj.APPPRDNEWF.REQREQEMPOWERMNTFUNDIND = String.valueOf(pcoNewAPPPRDNEWF?.get('REQREQEMPOWERMNTFUNDIND'));
        RequestedProductObj.APPPRDNEWF.REQREQEMPOWERMNTFUND = String.valueOf(pcoNewAPPPRDNEWF?.get('REQREQEMPOWERMNTFUND'));
        RequestedProductObj.APPPRDNEWF.REQCAMPAIGNCODE = String.valueOf(pcoNewAPPPRDNEWF?.get('REQCAMPAIGNCODE'));
        RequestedProductObj.APPPRDNEWF.SETTLEMENTSAMNT = String.valueOf(pcoNewAPPPRDNEWF?.get('SETTLEMENTSAMNT'));
        RequestedProductObj.APPPRDNEWF.REQLIMIT = String.valueOf(pcoNewAPPPRDNEWF?.get('REQLIMIT'));
        RequestedProductObj.APPPRDNEWF.REQREPAYMNTOPTION = String.valueOf(pcoNewAPPPRDNEWF?.get('REQREPAYMNTOPTION'));
        RequestedProductObj.APPPRDNEWF.REQCREDLIFEPREMIUM = String.valueOf(pcoNewAPPPRDNEWF?.get('REQCREDLIFEPREMIUM'));
        RequestedProductObj.APPPRDNEWF.REQLIMITTYPEIND = String.valueOf(pcoNewAPPPRDNEWF?.get('REQLIMITTYPEIND'));
        RequestedProductObj.APPPRDNEWF.REQPRODCOMBINATIONNUM = String.valueOf(pcoNewAPPPRDNEWF?.get('REQPRODCOMBINATIONNUM'));
        RequestedProductObj.APPPRDNEWF.ESPINSTRUCTION = String.valueOf(pcoNewAPPPRDNEWF?.get('ESPINSTRUCTION'));
        RequestedProductObj.APPPRDNEWF.CARDTYPE = String.valueOf(pcoNewAPPPRDNEWF?.get('CARDTYPE'));

        RequestedProductObj.INTPRDNEWF = new PowerCurveUpdateApplication_Req_IB_v1.INTPRDNEWF();
        RequestedProductObj.INTPRDNEWF.NCAMAXINITFEEAMNT = String.valueOf(pcoNewINTPRDNEWF?.get('REQPRODCOMBINATIONNUM'));
        RequestedProductObj.APPPRDNEWF.INSTSETTLEMENTS = '0';

        //RequestedProductObj.APPPRDSECO = new PowerCurveUpdateApplication_Req_IB_v1.APPPRDSECO();
        //RequestedProductObj.APPPRDSECO.SPECIFIC = String.valueOf(0);
        //RequestedProductObj.APPPRDSECO.SUPPORTINGSPECIFIC = String.valueOf(0);
        RequestedProductObj = mapSecuritiesExisting(RequestedProductObj);

        return RequestedProductObj;
    }

     /**
     * @description getEntityData
     * @param requestBean
     * @param pcoNewApplicationDv
     * @author  Changes made by
     * @return 
     */
    public static PowerCurveUpdateApplication_Req_IB_v1 getEntityData(PowerCurveUpdateApplication_Req_IB_v1 requestBean, Map<String, Object> pcoNewApplicationDv){
        pcoNewEntity01 = (Map<String, Object>) pcoNewApplicationDv?.get('Entity01');
        pcoNewEntity02 = (Map<String, Object>) pcoNewApplicationDv?.get('Entity02');
        pcoNewEntity03 = (Map<String, Object>) pcoNewApplicationDv?.get('Entity03');
        pcoNewEntity04 = (Map<String, Object>) pcoNewApplicationDv?.get('Entity04');
        pcoNewEntity05 = (Map<String, Object>) pcoNewApplicationDv?.get('Entity05');
        pcoNewEntity06 = (Map<String, Object>) pcoNewApplicationDv?.get('Entity06');

        if(pcoNewEntity01 != null){
            requestBean.Request.ApplicationDV.Entity01 = mapEntityFields(pcoNewEntity01);
        }

        if(pcoNewEntity02 != null){
            requestBean.Request.ApplicationDV.Entity02 = mapEntityFields(pcoNewEntity02);
        }

        if(pcoNewEntity03 != null){
            requestBean.Request.ApplicationDV.Entity03 = mapEntityFields(pcoNewEntity03);
        }

        if(pcoNewEntity04 != null){
            requestBean.Request.ApplicationDV.Entity04 = mapEntityFields(pcoNewEntity04);
        }

        if(pcoNewEntity05 != null){
            requestBean.Request.ApplicationDV.Entity05 = mapEntityFields(pcoNewEntity05);
        }

        if(pcoNewEntity06 != null){
            requestBean.Request.ApplicationDV.Entity06 = mapEntityFields(pcoNewEntity06);
        }

        return requestBean;
    }

     /**
     * @description mapEntityFields
     * @param pcoNewEntity
     * @author  Changes made by
     * @return 
     */
    public static PowerCurveUpdateApplication_Req_IB_v1.Entity01 mapEntityFields(Map<String, Object> pcoNewEntity){
        PowerCurveUpdateApplication_Req_IB_v1.Entity01 Entity = new PowerCurveUpdateApplication_Req_IB_v1.Entity01();
        Entity.INTENTNUMPARTICIPANTS1 = String.valueOf(pcoNewEntity?.get('INTENTNUMPARTICIPANTS1'));
        Entity.INTENTUNDERJUDICIALMNGMNT = String.valueOf(pcoNewEntity?.get('INTENTUNDERJUDICIALMNGMNT'));
        Entity.INTENTFINANCIALCRIMEHOLD = String.valueOf(pcoNewEntity?.get('INTENTFINANCIALCRIMEHOLD'));
        Entity.INTENTUNDERDEBTCOUNSELLING = String.valueOf(pcoNewEntity?.get('INTENTUNDERDEBTCOUNSELLING'));
        Entity.APPENTMNTHSSHAREHOLDINGPERC = String.valueOf(pcoNewEntity?.get('APPENTMNTHSSHAREHOLDINGPERC'));
        Entity.APPENTIDTYPE = String.valueOf(pcoNewEntity?.get('APPENTIDTYPE'));
        Entity.INTENTNUMPARTICIPANTS2 = String.valueOf(pcoNewEntity?.get('INTENTNUMPARTICIPANTS2'));
        Entity.INTENTNUMPARTICIPANTS3 = String.valueOf(pcoNewEntity?.get('INTENTNUMPARTICIPANTS3'));
        Entity.INTENTNUMPARTICIPANTS4 = String.valueOf(pcoNewEntity?.get('INTENTNUMPARTICIPANTS4'));
        Entity.INTENTNUMPARTICIPANTS5 = String.valueOf(pcoNewEntity?.get('INTENTNUMPARTICIPANTS5'));
        Entity.INTENTNUMPARTICIPANTS6 = String.valueOf(pcoNewEntity?.get('INTENTNUMPARTICIPANTS6'));
        Entity.INTENTCLIENTCODE1 = String.valueOf(pcoNewEntity?.get('INTENTCLIENTCODE1'));
        Entity.INTENTCLIENTCODE2 = String.valueOf(pcoNewEntity?.get('INTENTCLIENTCODE2'));
        Entity.INTENTCLIENTCODE3 = String.valueOf(pcoNewEntity?.get('INTENTCLIENTCODE3'));
        Entity.INTENTCLIENTCODE4 = String.valueOf(pcoNewEntity?.get('INTENTCLIENTCODE4'));
        Entity.INTENTCLIENTCODE5 = String.valueOf(pcoNewEntity?.get('INTENTCLIENTCODE5'));
        Entity.INTENTCLIENTCODE6 = String.valueOf(pcoNewEntity?.get('INTENTCLIENTCODE6'));
        Entity = getAccountDetails(Entity, pcoNewEntity);
        Entity = getExposuresRisk(Entity, pcoNewEntity);
        Entity = getExposures(Entity, pcoNewEntity);
        Entity = getCashAndInvestments(Entity, pcoNewEntity);
        Entity = getTriads(Entity, pcoNewEntity);
        Entity = getFacilities(Entity, pcoNewEntity);
        Entity = getFinancialConduct(Entity, pcoNewEntity);

        return Entity;
    }

     /**
     * @description getAccountDetails
     * @param Entity
     * @param pcoNewEntity
     * @author  Changes made by
     * @return 
     */
    public static PowerCurveUpdateApplication_Req_IB_v1.Entity01 getAccountDetails(PowerCurveUpdateApplication_Req_IB_v1.Entity01 Entity, Map<String, Object> pcoNewEntity){
        Map<String, Object> pcoINTENTBUR = (Map<String, Object>) pcoNewEntity?.get('INTENTBUR');
        Map<String, Object> pcoAPPENTBUR = (Map<String, Object>) pcoNewEntity?.get('APPENTBUR');

        if(Entity.INTENTBUR == null){
            Entity.INTENTBUR = new PowerCurveUpdateApplication_Req_IB_v1.INTENTBUR();
        }

        if(Entity.APPENTBUR == null){
            Entity.APPENTBUR = new PowerCurveUpdateApplication_Req_IB_v1.APPENTBUR();
        }

        Entity.INTENTCLIENTTYPE = string.valueof(pcoNewEntity?.get('INTENTCLIENTTYPE'));
        Entity.INTENTCLIENTCODE1 = string.valueof(pcoNewEntity?.get('INTENTCLIENTCODE1'));
        Entity.INTENTNONRESIDENT = string.valueof(pcoNewEntity?.get('INTENTNONRESIDENT'));
        Entity.APPENTAGE = string.valueof(pcoNewEntity?.get('APPENTAGE'));
        Entity.INTENTHIGHLEVELLIMITINDICATOR = string.valueof(pcoNewEntity?.get('INTENTHIGHLEVELLIMITINDICATOR'));
        Entity.APPENTSHAREHOLDINGPERC = string.valueof(pcoNewEntity?.get('APPENTSHAREHOLDINGPERC'));
        Entity.INTENTMARITALSTATUS = string.valueof(pcoNewEntity?.get('INTENTMARITALSTATUS'));
        Entity.INTENTMARITALCONTRACT = string.valueof(pcoNewEntity?.get('INTENTMARITALCONTRACT'));
        Entity.APPENTBUR.CONSINPNATID = string.valueof(pcoAPPENTBUR?.get('CONSINPNATID'));
        Entity.INTENTBUR.COMMINPREGNUMBER = string.valueof(pcoINTENTBUR?.get('COMMINPREGNUMBER'));
        Entity.INTENTINSOLVENT = string.valueof(pcoNewEntity?.get('INTENTINSOLVENT'));
        Entity.APPENTINTENTIONTOINSOLVENCY = string.valueof(pcoNewEntity?.get('APPENTINTENTIONTOINSOLVENCY'));

        return Entity;
    }

     /**
     * @description getExposuresRisk
     * @param Entity
     * @param pcoNewEntity
     * @author  Changes made by
     * @return 
     */
    public static PowerCurveUpdateApplication_Req_IB_v1.Entity01 getExposuresRisk(PowerCurveUpdateApplication_Req_IB_v1.Entity01 Entity, Map<String, Object> pcoNewEntity){
        Map<String, Object> pcoINTENTRDET = (Map<String, Object>) pcoNewEntity?.get('INTENTRDET');

        Entity.INTENTWRSTRISKGRADE = string.valueof(pcoNewEntity?.get('INTENTWRSTRISKGRADE'));
        Entity.INTENTUNDERDEBTCOUNSELLING = string.valueof(pcoNewEntity?.get('INTENTUNDERDEBTCOUNSELLING'));
        Entity.INTENTINLIQUIDATION = string.valueof(pcoNewEntity?.get('INTENTINLIQUIDATION'));
        Entity.INTENTFRAUDRISKMNGMNT = string.valueof(pcoNewEntity?.get('INTENTFRAUDRISKMNGMNT'));

        Entity.INTENTRDET = new PowerCurveUpdateApplication_Req_IB_v1.INTENTRDET();
        Entity.INTENTRDET.WRSTCOLLRISKTYPE = string.valueof(pcoINTENTRDET?.get('WRSTCOLLRISKTYPE'));
        Entity.INTENTRDET.WRSTARMSHOLD = string.valueof(pcoINTENTRDET?.get('WRSTARMSHOLD'));
        Entity.INTENTRDET.INBUSNRESC = string.valueof(pcoINTENTRDET?.get('INBUSNRESC'));
        Entity.INTENTRDET.BUSNRESCAFFECTEDPARTY = string.valueof(pcoINTENTRDET?.get('BUSNRESCAFFECTEDPARTY'));
        Entity.INTENTRDET.EWLLISTING = string.valueof(pcoINTENTRDET?.get('EWLLISTING'));
        Entity.INTENTRDET.INTENTBUSNRESC = string.valueof(pcoINTENTRDET?.get('INTENTBUSNRESC'));

        return Entity;
    }

     /**
     * @description getExposures
     * @param Entity
     * @param pcoNewEntity
     * @author  Changes made by
     * @return 
     */
    
    public static PowerCurveUpdateApplication_Req_IB_v1.Entity01 getExposures(PowerCurveUpdateApplication_Req_IB_v1.Entity01 Entity, Map<String, Object> pcoNewEntity){
        Map<String, Object> pcoINTENTEXPO = (Map<String, Object>) pcoNewEntity?.get('INTENTEXPO');
        Map<String, Object> pcoINTENTCMTM = (Map<String, Object>) pcoNewEntity?.get('INTENTCMTM');
        Map<String, Object> pcoINTENTARRS = (Map<String, Object>) pcoNewEntity?.get('INTENTARRS');
        Map<String, Object> pcoINTENTEXCS = (Map<String, Object>) pcoNewEntity?.get('INTENTEXCS');
        Map<String, Object> pcoINTENTINST = (Map<String, Object>) pcoNewEntity?.get('INTENTINST');
        Map<String, Object> pcoINTENTLMTS = (Map<String, Object>) pcoNewEntity?.get('INTENTLMTS');

        //Exposures
        //Objects Declaration
        Entity.INTENTEXPO = new PowerCurveUpdateApplication_Req_IB_v1.INTENTEXPO();
        Entity.INTENTCMTM = new PowerCurveUpdateApplication_Req_IB_v1.INTENTCMTM();
        Entity.INTENTARRS = new PowerCurveUpdateApplication_Req_IB_v1.INTENTARRS();
        Entity.INTENTEXCS = new PowerCurveUpdateApplication_Req_IB_v1.INTENTEXCS();
        Entity.INTENTINST = new PowerCurveUpdateApplication_Req_IB_v1.INTENTARRS();
        Entity.INTENTLMTS = new PowerCurveUpdateApplication_Req_IB_v1.INTENTLMTS();

        Entity.INTENTEXPO.CONTINGENTLIABILITY = string.valueof(pcoINTENTEXPO?.get('CONTINGENTLIABILITY'));
        Entity.INTENTEXPO.ORDCRED = string.valueof(pcoINTENTEXPO?.get('ORDCRED'));
        Entity.INTENTEXPO.MORTGRES = string.valueof(pcoINTENTEXPO?.get('MORTGRES'));
        Entity.INTENTCMTM.MORTGRES = string.valueof(pcoINTENTCMTM?.get('MORTGRES'));
        Entity.INTENTEXPO.MORTGCPF = string.valueof(pcoINTENTEXPO?.get('MORTGCPF'));
        Entity.INTENTCMTM.MORTGCPF = string.valueof(pcoINTENTCMTM?.get('MORTGCPF'));
        Entity.INTENTEXPO.MORTGAGRI = string.valueof(pcoINTENTEXPO?.get('MORTGAGRI'));
        Entity.INTENTCMTM.MORTGAGRI = string.valueof(pcoINTENTCMTM?.get('MORTGAGRI'));
        Entity.INTENTEXPO.MORTGTOTAL = string.valueof(pcoINTENTEXPO?.get('MORTGTOTAL'));
        Entity.INTENTCMTM.MORTGTOTAL = string.valueof(pcoINTENTCMTM?.get('MORTGTOTAL'));
        Entity.INTENTEXPO.TOTALDIRECTEXPOSURE = string.valueof(pcoINTENTEXPO?.get('TOTALDIRECTEXPOSURE'));
        Entity.INTENTEXPO.TOTALEXPOSURE = string.valueof(pcoINTENTEXPO?.get('TOTALEXPOSURE'));
        Entity.INTENTEXPO.RECOVERYEXPOSURE = string.valueof(pcoINTENTEXPO?.get('RECOVERYEXPOSURE'));
        Entity.INTENTCMTM.ORDCREDIT = string.valueof(pcoINTENTCMTM?.get('ORDCREDIT'));
        Entity.INTENTARRS.OTHEROC = string.valueof(pcoINTENTARRS?.get('OTHEROC'));
        Entity.INTENTEXCS.OTHEROC = string.valueof(pcoINTENTEXCS?.get('OTHEROC'));
        Entity.INTENTINST.OTHEROC = string.valueof(pcoINTENTINST?.get('OTHEROC'));
        Entity.INTENTLMTS.OTHEROC = string.valueof(pcoINTENTLMTS?.get('OTHEROC'));
        Entity.INTENTARRS.TL = string.valueof(pcoINTENTARRS?.get('TL'));
        Entity.INTENTINST.TL = string.valueof(pcoINTENTINST?.get('TL'));
        Entity.INTENTEXCS.CHEQACCS = string.valueof(pcoINTENTEXCS?.get('CHEQACCS'));
        Entity.INTENTLMTS.CHEQ = string.valueof(pcoINTENTLMTS?.get('CHEQ'));
        Entity.INTENTARRS.CC = string.valueof(pcoINTENTARRS?.get('CC'));
        Entity.INTENTEXCS.CC = string.valueof(pcoINTENTEXCS?.get('CC'));
        Entity.INTENTINST.CC = string.valueof(pcoINTENTINST?.get('CC'));
        Entity.INTENTLMTS.CC = string.valueof(pcoINTENTLMTS?.get('CC'));
        Entity.INTENTEXPO.ASSETFINANCE = string.valueof(pcoINTENTEXPO?.get('ASSETFINANCE'));
        Entity.INTENTCMTM.ASSETFINANCE = string.valueof(pcoINTENTCMTM?.get('ASSETFINANCE'));
        Entity.INTENTARRS.ASSETFINANCE = string.valueof(pcoINTENTARRS?.get('ASSETFINANCE'));
        Entity.INTENTINST.ASSETFINANCE = string.valueof(pcoINTENTINST?.get('ASSETFINANCE'));
        Entity.INTENTARRS.ML = string.valueof(pcoINTENTARRS?.get('ML'));
        Entity.INTENTINST.ML = string.valueof(pcoINTENTINST?.get('ML'));

        return Entity;
    }

     /**
     * @description getCashAndInvestments
     * @param Entity
     * @param pcoNewEntity
     * @author  Changes made by
     * @return 
     */
    public static PowerCurveUpdateApplication_Req_IB_v1.Entity01 getCashAndInvestments(PowerCurveUpdateApplication_Req_IB_v1.Entity01 Entity, Map<String, Object> pcoNewEntity){
        Entity.INTENTCTBALANCECHEQS=string.valueof(pcoNewEntity?.get('INTENTCTBALANCECHEQS'));
        Entity.INTENTCTBALANCESAVINGS = string.valueof(pcoNewEntity?.get('INTENTCTBALANCESAVINGS'));
        Entity.INTENTCTBALANCENOTICEDEPOSITS = string.valueof(pcoNewEntity?.get('INTENTCTBALANCENOTICEDEPOSITS'));
        Entity.INTENTCTBALANCETERMDEPOSITS = string.valueof(pcoNewEntity?.get('INTENTCTBALANCETERMDEPOSITS'));
        Entity.INTENTCTBALANCECUSTINVESTMENTS = string.valueof(pcoNewEntity?.get('INTENTCTBALANCECUSTINVESTMENTS'));
        Entity.INTENTCTBALANCECASHCOVER = string.valueof(pcoNewEntity?.get('INTENTCTBALANCECASHCOVER'));

        return Entity;
    }

     /**
     * @description getTriads
     * @param Entity
     * @param pcoNewEntity
     * @author  Changes made by
     * @return 
     */
    public static PowerCurveUpdateApplication_Req_IB_v1.Entity01 getTriads(PowerCurveUpdateApplication_Req_IB_v1.Entity01 Entity, Map<String, Object> pcoNewEntity){
        Map<String, Object> pcoINTENTTRID = (Map<String, Object>) pcoNewEntity?.get('INTENTTRID');

        Entity.INTENTTRID = new PowerCurveUpdateApplication_Req_IB_v1.INTENTTRID();
        Entity.INTENTTRID.MNTHSOLDESTCUSTREL = string.valueof(pcoINTENTTRID?.get('MNTHSOLDESTCUSTREL'));
        Entity.INTENTTRID.MNTHSOLDESTACCREL = string.valueof(pcoINTENTTRID?.get('MNTHSOLDESTACCREL'));
        Entity.INTENTTRID.MNTHSOLDESTCHACCREL = string.valueof(pcoINTENTTRID?.get('MNTHSOLDESTCHACCREL'));
        Entity.INTENTTRID.MNTHSOLDESTSAVACCREL = string.valueof(pcoINTENTTRID?.get('MNTHSOLDESTSAVACCREL'));
        Entity.APPENTAGEOLDESTRELATIONSHIP = string.valueof(pcoNewEntity?.get('APPENTAGEOLDESTRELATIONSHIP'));
        Entity.INTENTTRID.EXCLUSIONTYPE = string.valueof(pcoINTENTTRID?.get('EXCLUSIONTYPE'));
        Entity.INTENTTRID.EXCLUSIONCREDITFACILITY = string.valueof(pcoINTENTTRID?.get('EXCLUSIONCREDITFACILITY'));
        Entity.INTENTTRID.EXCLUSIONREASON= string.valueof(pcoINTENTTRID?.get('EXCLUSIONREASON'));
        Entity.INTENTTRID.BEHAVSCORECUSTALIGN = string.valueof(pcoINTENTTRID?.get('BEHAVSCORECUSTALIGN'));
        Entity.INTENTTRID.BEHAVSCORECHEQ = string.valueof(pcoINTENTTRID?.get('BEHAVSCORECHEQ'));
        Entity.INTENTTRID.BEHAVSCORECC = string.valueof(pcoINTENTTRID?.get('BEHAVSCORECC'));
        Entity.INTENTTRID.BEHAVSCOREMORTG = string.valueof(pcoINTENTTRID?.get('BEHAVSCOREMORTG'));
        Entity.INTENTTRID.BEHAVSCOREAVAF = string.valueof(pcoINTENTTRID?.get('BEHAVSCOREAVAF'));
        Entity.INTENTTRID.BEHAVSCORELOANS = string.valueof(pcoINTENTTRID?.get('BEHAVSCORELOANS'));
        Entity.INTENTTRID.EXPECTEDCREDTURNOVCHEQ = string.valueof(pcoINTENTTRID?.get('EXPECTEDCREDTURNOVCHEQ'));
        Entity.INTENTTRID.EXPECTEDCREDTURNOVCUST = string.valueof(pcoINTENTTRID?.get('EXPECTEDCREDTURNOVCUST'));
        Entity.INTENTTRID.AVGCTOL3ML6M = string.valueof(pcoINTENTTRID?.get('AVGCTOL3ML6M'));
        Entity.INTENTTRID.AVGCTOL6ML12M = string.valueof(pcoINTENTTRID?.get('AVGCTOL6ML12M'));
        Entity.INTENTTRID.NUMDAYSCREDITINL6M = string.valueof(pcoINTENTTRID?.get('NUMDAYSCREDITINL6M'));
        Entity.INTENTTRID.NUMDAYSDEBITINL6M = string.valueof(pcoINTENTTRID?.get('NUMDAYSDEBITINL6M'));
        Entity.INTENTTRID.NUMDEBITSL6M = string.valueof(pcoINTENTTRID?.get('NUMDEBITSL6M'));
        Entity.INTENTTRID.NUMMNTHSEXCESSBALL6M = string.valueof(pcoINTENTTRID?.get('NUMMNTHSEXCESSBALL6M'));
        Entity.INTENTTRID.MAXCONSECDAYSINEXCESS = string.valueof(pcoINTENTTRID?.get('MAXCONSECDAYSINEXCESS'));
        Entity.INTENTTRID.MAXOCSCORINGMANDATE = string.valueof(pcoINTENTTRID?.get('MAXOCSCORINGMANDATE'));
        Entity.INTENTTRID.AOL = string.valueof(pcoINTENTTRID?.get('AOL'));
        Entity.INTENTTRID.ACCL = string.valueof(pcoINTENTTRID?.get('ACCL'));
        Entity.INTENTTRID.AMLR = string.valueof(pcoINTENTTRID?.get('AMLR'));
        Entity.INTENTTRID.ABRA = string.valueof(pcoINTENTTRID?.get('ABRA'));
        Entity.INTENTTRID.AMMR = string.valueof(pcoINTENTTRID?.get('AMMR'));
        Entity.INTENTTRID.AMR = string.valueof(pcoINTENTTRID?.get('AMR'));
        Entity.INTENTTRID.NUMRDEVENTSSAVL3M = string.valueof(pcoINTENTTRID?.get('NUMRDEVENTSSAVL3M'));
        Entity.INTENTTRID.NUMRDEVENTSSAVL6M = string.valueof(pcoINTENTTRID?.get('NUMRDEVENTSSAVL6M'));
        Entity.INTENTTRID.NUMRDEVENTSCHEQL3M = string.valueof(pcoINTENTTRID?.get('NUMRDEVENTSCHEQL3M'));
        Entity.INTENTTRID.NUMRDEVENTSCHEQL6M = string.valueof(pcoINTENTTRID?.get('NUMRDEVENTSCHEQL6M'));
        Entity.INTENTTRID.TOTSAVRETPAYMNTSL6M = string.valueof(pcoINTENTTRID?.get('TOTSAVRETPAYMNTSL6M'));
        Entity.INTENTTRID.TOTCHEQRETPAYMNTSL6M = string.valueof(pcoINTENTTRID?.get('TOTCHEQRETPAYMNTSL6M'));

        return Entity;
    }

     /**
     * @description getFacilities
     * @param Entity
     * @param pcoNewEntity
     * @author  Changes made by
     * @return 
     */
    public static PowerCurveUpdateApplication_Req_IB_v1.Entity01 getFacilities(PowerCurveUpdateApplication_Req_IB_v1.Entity01 Entity, Map<String, Object> pcoNewEntity){
        Map<String, Object> pcoAPPENTEXPO = (Map<String, Object>) pcoNewEntity?.get('APPENTEXPO');
        Map<String, Object> pcoAPPENTAPRF = (Map<String, Object>) pcoNewEntity?.get('APPENTAPRF');

        Entity.APPENTEXPO = new PowerCurveUpdateApplication_Req_IB_v1.APPENTEXPO();
        Entity.APPENTAPRF = new PowerCurveUpdateApplication_Req_IB_v1.APPENTAPRF();

        Entity.APPENTEXPO.SETTLEMENTLIMITS = string.valueof(pcoAPPENTEXPO?.get('SETTLEMENTLIMITS'));
        Entity.APPENTEXPO.APPRFACILITIESODNONSCR = string.valueof(pcoAPPENTEXPO?.get('APPRFACILITIESODNONSCR'));
        Entity.APPENTEXPO.APPRFACILITIESAFINNONSCR = string.valueof(pcoAPPENTEXPO?.get('APPRFACILITIESAFINNONSCR'));
        Entity.APPENTEXPO.APPRFACILITIESMLNONSCR = string.valueof(pcoAPPENTEXPO?.get('APPRFACILITIESMLNONSCR'));
        Entity.APPENTAPRF.INSTORDCREDNONSCORED = string.valueof(pcoAPPENTAPRF?.get('INSTORDCREDNONSCORED'));
        Entity.APPENTAPRF.INSTASSETFINNONSCORED = string.valueof(pcoAPPENTAPRF?.get('INSTASSETFINNONSCORED'));
        Entity.APPENTAPRF.INSTMLOANNONSCORED = string.valueof(pcoAPPENTAPRF?.get('INSTMLOANNONSCORED'));

        return Entity;
    }

     /**
     * @description getFinancialConduct
     * @param Entity
     * @param pcoNewEntity
     * @author  Changes made by
     * @return 
     */
    public static PowerCurveUpdateApplication_Req_IB_v1.Entity01 getFinancialConduct(PowerCurveUpdateApplication_Req_IB_v1.Entity01 Entity, Map<String, Object> pcoNewEntity){
        Entity.INTENTCDUCTMAINPYTURNOVER = String.valueOf(pcoNewEntity?.get('INTENTCDUCTMAINPYTURNOVER'));

        return Entity;
    }

    /**
     * Method to get Account Address records
     *@description getAccountAddresses
     * @param accountIds - Set<Id> of Account record Ids
     * @return Map<Id, Address__c> - A map with a Id, Address__c pair
     **/
    private static Map<Id, Address__c> getAccountAddresses(Set<Id> accountIds){
        List<Address__c> addresses = [SELECT Id,Shipping_Suburb__c,Shipping_City__c,Shipping_Zip_Postal_Code__c,Account__c FROM Address__c WHERE Account__c IN: accountIds];
        Map<Id, Address__c> addressesById = new Map<Id, Address__c>();

        if(!addresses.isEmpty()){
            for(Address__c address : addresses){
                addressesById.put(address.Account__c, address);
            }
        }

        return addressesById;
    }

    /**
     * Method to get Accounts by their cif
     *@description getAppProfileAccounts
     * @param accountIds - Set<String> of CIF Codes
     * @return Map<String, Id> - A map with a String Id pair
     **/
    private static Map<Id, Account> getAppProfileAccounts(Set<Id> accountIds){
        List<Account> accounts = [SELECT Id,ID_Type__pc,ID_Type__c,Temporary_Resident_Permit_Number__c,Gender__pc,PersonHomePhone,Business_Address_Line_1__c,
                                  Business_Address_Line_2__c,Nationality__pc,Active_Email__c,Residential_Status__c, Residential_Status__pc,
                                  Annual_Gross_Income__pc,Income_Tax_Number__c, Income_Tax_Number__pc
                                  FROM Account WHERE Id IN: accountIds];
        Map<Id, Account> accountsById = new Map<Id, Account>();

        if(!accounts.isEmpty()){
            for(Account account : accounts){
                accountsById.put(account.Id, account);
            }
        }

        return accountsById;
    }

    /**
     * Method to get Application Group Exposure records
     *@description getClientUltimateGroupIndicators
     * @return Map<String, String> map with group exposure
     */
    private static Map<String, String> getClientUltimateGroupIndicators(){
        Map<String,List<GroupExposuresCTRL.GroupExposures>> groupExposures = GroupExposuresCTRL.getGroupExposureFromService(opportunityId);
        Map<String, String> clientUltimateGroup = new Map<String, String>();

        if(groupExposures != null){
            String prevClientName = '';
            String prevUltimateClientGroup = '';
            for(GroupExposuresCTRL.GroupExposures groupExposure : groupExposures.get('appGroupExposures')){
                if(prevClientName == groupExposure.ClientName){
                    if(prevUltimateClientGroup == groupExposure.UltimatePrimaryClientCode){
                        clientUltimateGroup.put(groupExposure.ClientName, 'Y');
                    } else {
                        clientUltimateGroup.put(groupExposure.ClientName, 'N');
                    }
                } else {
                    prevClientName = groupExposure.ClientName;
                    prevUltimateClientGroup = groupExposure.UltimatePrimaryClientCode;
                }
            }
        }

        return clientUltimateGroup;
    }

    /**
     * Method to change gender string to gender character
     *@description getAccountGender
     * @param gender - gender string
     * @return String - String with the first letter of the gender
     */
    public static String getAccountGender(String gender){
        String genderChar = '';

        if(gender != null){
            if(gender.equalsIgnoreCase('Female')){
                genderChar = 'F';
            } else if(gender.equalsIgnoreCase('Male')){
                genderChar = 'M';
            }
        }

        return genderChar;
    }

    /**
     * Method to change Salesforce Id Type to PCO Id Type
     * @description getIdType
     * @param idTypeSalesforce - Salesforce Id Type string
     * @return String - String with PCO Id Type
     */
    public static String getIdType(String idTypeSalesforce){
        String idTypePCO = '';

        if(idTypeSalesforce != null){
            if(idTypeSalesforce.equalsIgnoreCase('SA Identity Document') || idTypeSalesforce.equalsIgnoreCase('Registration Number') || idTypeSalesforce.equalsIgnoreCase('Passport')){
                idTypePCO = translationMap.get(idTypeSalesforce);
                if(idTypePCO.length() == 1){
                    idTypePCO = '0' + idTypePCO;
                }
            }
        }

        return idTypePCO;
    }
}