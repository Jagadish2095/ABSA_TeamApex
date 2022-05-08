/**
 * @description : Apex controller for AllocateStockNumberCmp Aura Component
 * @author Thabo Senkomane
 * @created 2020-06-02
 *
 * @update Englarmerdge Mongwe
 * @dateUpdated 2020-06-09
 * Added method to change stage name - W-004631
 *
 * @update Englarmerdge Mongwe
 * @dateUpdated 2020-08-24
 * Changed Application_Product_Credit__c to Application_Product__c object
 *
 * @update Englarmerdge Mongwe
 * @dateUpdated 2020-09-09
 * Save principal data as snapshot - W-005598
 *
 * @update Ephetehe Mokgopanyane
 * @dateUpdated 2020-12-18
 * Added code to relate Application Profile to Account - W-003771
 *
 * @update gulafsha
 * @dateUpdated 2021-01-14
 * Added code to relate EDF and Franchise
**/

public class AllocateStockNumberController {
    /**
    * @description : calls the stock number service to generate a unique
    *  application number for credit application
    * @author Thabo/Thulani | 06-07-2020
    * @param oppId
    * @return String
    **/
    @AuraEnabled
    public static String callToAllocateStockNo(Id oppId) {
        Try{
            String returnMessage = 'SUCCESS';
            List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
            List<Application__c> applicationLst = new ApplicationsSelector().selectByOpportunityOnboardId(oppId);
            List<User> userRec= new UsersSelector().userwithSiteCode(UserInfo.getUserId());
            HLallocateStockNumber_Resp_IB_v1 stockResponse = HLallocateStockNumber_IH_v1.hlAllocateStockNumber('CUST1','CREDIT','N','E','STD','','','001','470','WI',userRec[0].SiteCode__c);
            String resp = json.serialize(stockResponse);

            if(stockResponse.statusCode == 200) {
                returnMessage = ' ' + (stockResponse.message != null ? stockResponse.message : '');
            }
            else{
                returnMessage = ' ' + (stockResponse.message != null ? stockResponse.message : '');
            }

            if(applicationLst != null && applicationLst.size() > 0) {
                try{
                    applicationLst[0].Stock_Number__c = stockResponse.stockNumber;
                    update applicationLst[0];
                }catch(Exception e) {
                    throw new AuraHandledException( e.getMessage());
                }
            }

            return stockResponse.message;
        }
        catch (Exception e) {
            throw new AuraHandledException('Something went wrong:  ' +  e.getMessage());
        }
    }

    /**
    * @description : retrive the application object
    * @author Thabo/Thulani | 06-07-2020
    * @param oppId
    * @return Application__c
    **/
    @AuraEnabled
    public static Application__c getStockNumber(Id oppId) {
        // List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
        List<Application__c> applicationLst  = new ApplicationsSelector().selectByOpportunityId(oppId);
        Application__c app;
        if(applicationLst.size() > 0) {
            app = applicationLst[0];
        }
        return app;
    }

    /**
    * @description : retrive the application object
    * @author Thabo/Thulani | 06-07-2021
    * @param oppId
    * @return Application__c
    **/
    @AuraEnabled
    public static Application__c getApplicationDetails(Id oppId) {
        return new ApplicationsSelector().selectByCreditOpportunityId(oppId);
    }

    /**
    * @description : call the edf service and update the acc fields
    * @author Gulafsha | 06-01-2021
    * @param oppId
    **/
    @future(callout = true)
    public static void getEDFservice(Id oppId) {
       user u = new UsersSelector().selectById(userinfo.getUserId());
        //Map<String, Object> clientRelationsMap = new Map<String, Object>();
        Account acc1=new AccountsSelector().selectIndvByOpportunityId(oppId);
            Account acc =new Account();
            if(acc1!=Null && acc1.AccountNumber!=Null && acc1.AccountNumber!=''){
       // if(acc!=Null && acc.AccountNumber!=Null && acc.AccountNumber!='') {
            CIgetRelationshipsV1_Req_IB_v1 requestBean = new CIgetRelationshipsV1_Req_IB_v1();

            CIgetRelationshipsV1_Req_IB_v1.CIgetRelationshipsV1 CIgetRelationshipsV1 = new CIgetRelationshipsV1_Req_IB_v1.CIgetRelationshipsV1();

            CIgetRelationshipsV1_Req_IB_v1.Nbsapdpi nbsapdpi = new CIgetRelationshipsV1_Req_IB_v1.Nbsapdpi();
            nbsapdpi.channel = 'CIF';
            nbsapdpi.application = 'CIF';
            nbsapdpi.trace = 'N';

            CIgetRelationshipsV1_Req_IB_v1.Nbsmsgi nbsmsgi = new CIgetRelationshipsV1_Req_IB_v1.Nbsmsgi();
            nbsmsgi.msgLanguage = 'E';
            nbsmsgi.msgTarget = 'STD';

            CIgetRelationshipsV1_Req_IB_v1.cib128i cib128i = new CIgetRelationshipsV1_Req_IB_v1.cib128i();
            cib128i.clientKey='';
            cib128i.acno=acc1.AccountNumber!=Null && acc1.AccountNumber!=''?acc1.AccountNumber:'1000157283';//'3001532603';//1000157283
            cib128i.maxRetrieve='15';
            cib128i.restartKey='';
            cib128i.siteCode = u.SiteCode__c!=Null? u.SiteCode__c:'8392';
            cib128i.tellerCode= u.Teller_Operator_Code__c!=Null? u.Teller_Operator_Code__c:'042028';
            CIgetRelationshipsV1.nbsapdpi = nbsapdpi;
            CIgetRelationshipsV1.nbsmsgi = nbsmsgi;
            CIgetRelationshipsV1.cib128i = cib128i;

            requestBean.CIgetRelationshipsV1 = CIgetRelationshipsV1;
            boolean flag=false;
            CIgetRelationshipsV1_Resp_IB_v1 responsebean = CIgetRelationshipsV1_IH_v1.CIgetRelationshipsV1(requestBean);
            if(responseBean != null && responsebean.CIgetRelationshipsV1Response !=Null) {
                CIgetRelationshipsV1_Resp_IB_v1.CIgetRelationshipsV1Response CIgetRelationshipsV1Response = responsebean.CIgetRelationshipsV1Response;
                if( CIgetRelationshipsV1Response.cib128o!=Null){
                    CIgetRelationshipsV1_Resp_IB_v1.cib128o cib128o =  CIgetRelationshipsV1Response.cib128o;
                    //system.debug('%%CIgetRelationshipsV1Response.cib128o'+CIgetRelationshipsV1Response.cib128o);
                    //CIgetRelationshipsV1_Resp_IB_v1.relDetails relDetails = CIgetRelationshipsV1Response.cib128o.relDetails;
                    for(CIgetRelationshipsV1_Resp_IB_v1.relDetails reldet: cib128o.relDetails){
                        if(reldet.sourceRelaCode=='910' && reldet.relativeRelaCode=='900'){
                            acc.EDF_Code__c = reldet.relativeClientKey;
                            acc.EDF_Name__c = reldet.relativeClientName;
                            acc.id = acc1.id;
                            flag=true;
                            break;
                        }
                    }
                    if(flag==true){
                      update acc;
                    }

                }
            }
        }
    }

    /**
    * @description : retrive edf fields from account object
    * @author Gulafsha | 06-07-2021
    * @param oppId
    * @return Account
    **/
    @AuraEnabled
    public static Account getEnDevFundDetails(Id oppId) {
        Map<String, Object> clientRelationsMap = new Map<String, Object>();
        Account acc=new AccountsSelector().selectIndvByOpportunityId(oppId);
        //if(acc!=Null && acc.AccountNumber!=Null){
        if(acc!=Null){
           /*clientRelationsMap.put('EDFName',acc.EDF_Name__c);
            clientRelationsMap.put('EDFCode',acc.EDF_Code__c);
            clientRelationsMap.put('ReqEDFName',acc.EDF_ReqName__c);
            clientRelationsMap.put('ReqEDFCode',acc.EDF_ReqCode__c);*/
            return acc;
        }
        else{
           /* clientRelationsMap.put('EDFName',Null);
            clientRelationsMap.put('EDFCode',Null);
            clientRelationsMap.put('EDFName',Null);
            clientRelationsMap.put('EDFCode',Null);*/
        }
        return null;
        //return null;
    }

    /**
    * @description : update edf details from user input
    * @author Gulafsha | 06-07-2021
    * @param oppId
    * @param reqEDFName
    * @param reqEDFCode
    * @param FranchiseName
    * @param FarnchiseCode
    * @param ReqEDFIndicator
    * @param ReqFranchiseIndicator
    **/
    @AuraEnabled
    public static void updateEnDevFundDetails(String oppId,String reqEDFName,String reqEDFCode,String FranchiseName,String FarnchiseCode,Boolean ReqEDFIndicator,Boolean ReqFranchiseIndicator) {
        Map<String, Object> clientRelationsMap = new Map<String, Object>();
        boolean flag=false;
        try{
            //Account acc1=new AccountsSelector().selectIndvByOpportunityId(oppId);
            Application__c apprec1 = new ApplicationsSelector().selectByCreditOpportunityId(oppId);
           system.debug('application###'+apprec1);
           Application__c apprec = new Application__c();
            //Account acc =new Account();
            if(apprec1!=Null){
                apprec.id=apprec1.id;
                system.debug('apprec after id###'+apprec);
                if(reqEDFCode!=Null && reqEDFCode!='' && reqEDFName!=Null && reqEDFName!='' && ReqEDFIndicator){
                    apprec.EDF_ReqCode__c = reqEDFCode;
                    apprec.EDF_ReqName__c = reqEDFName;
                    flag=true;
                }
                else if(!ReqEDFIndicator){
                    apprec.EDF_ReqCode__c = '';
                    apprec.EDF_ReqName__c = '';
                    flag=true;
                }
                if(FranchiseName!=Null && FranchiseName!='' && FarnchiseCode!=Null && FarnchiseCode!='' && ReqFranchiseIndicator){
                    apprec.Requested_Franchise_Code__c = FarnchiseCode;
                    apprec.Requested_Franchise_Name__c = FranchiseName;
                    flag=true;
                }
                else if(!ReqFranchiseIndicator){
                   apprec.Requested_Franchise_Code__c = '';
                   apprec.Requested_Franchise_Name__c = '';
                   flag=true;
                }
                if(flag==true){
                system.debug('apprec after code ###'+apprec);
                update apprec;
                }



            }
        }  catch (Exception ex){
            system.debug('get msg ' + ex.getMessage());
            system.debug('get line number ' + ex.getLineNumber());
        }
    }
    /*
    @AuraEnabled
    public static Application_Exposure_Total_Group__c getFranchiseDetails(Id oppId) {
        List<opportunity> opplist = new OpportunitiesSelector().selectByOpportunityId(oppId,1);
        map<String,String> franchisemap = new map<String,String>();
        system.debug('opplist'+opplist);
        application__c app = new ApplicationsSelector().selectByCreditOpportunityId(oppId);
        if(opplist != Null && opplist.size()>0){
            //  List<Account> accounts = new AccountsSelector().selectById(new Set<Id>{opplist[0].AccountId}, 1);
            String FranchiseCodeName = '';
            if(app!=Null){

                if( String.isNotBlank(opplist[0].CIF_Number__c) ){
                    List<Application_Exposure_Total_Group__c> aetg = new ApplicationsTotalGroupSelector().getApplicationTotalGroupbyGrpTypeClientCode(app.id,opplist[0].CIF_Number__c,'Client Total Group Exposure');

                    if(aetg!=Null && aetg.size()>0){
                          /* franchisemap.put('FranchiseCode',aetg[0].Existing_Franchisor_Type_Code__c!=Null?aetg[0].Existing_Franchisor_Type_Code__c:'');
                           franchisemap.put('FranchiseName',aetg[0].Existing_Franchise_Name__c!=Null?aetg[0].Existing_Franchise_Name__c:'');
                           franchisemap.put('ReqFranchiseCode',aetg[0].Requested_Franchise_Code__c!=Null?aetg[0].Requested_Franchise_Code__c:'');
                           franchisemap.put('ReqFranchiseName',aetg[0].RequestedFranchiseName__c!=Null?aetg[0].RequestedFranchiseName__c:'');
                           return franchisemap;*/
                      //   return aetg[0];
                  //   }
                   // else{
                        /*   franchisemap.put('FranchiseCode','');
                           franchisemap.put('FranchiseName','');
                           franchisemap.put('ReqFranchiseCode','');
                           franchisemap.put('ReqFranchiseName','');
                           return franchisemap;
                        return null;
                    }

                }
            }
        }

        return null;
    }
    /* not removing as we are not sure if it would be needed in future
    @AuraEnabled
    public static String saveTotalGroupExposureData(Id oppId,String FarnchiseCode, String FranchiseName) {
        List<opportunity> opplist = new OpportunitiesSelector().selectByOpportunityId(oppId,1);
        system.debug('opplist'+opplist);
        application__c app = new ApplicationsSelector().selectByCreditOpportunityId(oppId);
        if(opplist != Null && opplist.size()>0){
            if(app!=Null){

                if( String.isNotBlank(opplist[0].CIF_Number__c) ){
                    List<Application_Exposure_Total_Group__c> aetg = new ApplicationsTotalGroupSelector().getApplicationTotalGroupbyGrpTypeClientCode(app.id,opplist[0].CIF_Number__c,'Client Total Group Exposure');
                    if(aetg!=Null && aetg.size()>0){
                        aetg[0].Requested_Franchise_Code__c = FarnchiseCode;
                            aetg[0].RequestedFranchiseName__c = FranchiseName;
                            update aetg[0];

                    }
                }
            }
        }
        return null;
    }  */

    /**
    * @description : Update franchise details on Acc from user input
    * @author Gulafsha | 06-07-2021
    * @param Franchisecode
    * @param FranchiseName
    * @param AccId
    **/
    @future
    public static void updateFranchiseDetailsOnaAcc(String Franchisecode, String FranchiseName,String AccId) {
       Account acc=new account();
       acc.id=AccId;
       acc.Franchise_Code__c=Franchisecode;
       acc.Franchise_Name__c=FranchiseName;
       update acc;
    }

    /**
    * @description : Retrive franchise codes from metadata object
    * @author Gulafsha | 06-07-2021
    * @param FranchCode
    * @return ABSA_Franchise_Code__mdt
    **/
    @AuraEnabled
    public static ABSA_Franchise_Code__mdt getReqFranchiseDetails(String FranchCode) {
        list<ABSA_Franchise_Code__mdt> francList= new list<ABSA_Franchise_Code__mdt>();
        francList = LookupController.fetchFranchiserCodeValues(FranchCode);
        if(francList.size()>0){
            return francList[0];
        }
        return null;
    }

    /**
    * @description : Link the generate stock number with client CIF
    * @author THabo | 06-07-2021
    * @param oppId
    * @return String
    **/
    @AuraEnabled
    public static String linkStockNumberToCIF(Id oppId) {
        String response;
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
        List<Application__c> applicationLst = new ApplicationsSelector().selectByOpportunityOnboardId(oppId);
        List<User> userRec = new UsersSelector().userwithSiteCode(UserInfo.getUserId());

        if(applicationLst.size() > 0 && applicationLst != null)
        {
            CIlinkAccounttoClientV4_Req_IB_v1 requestBean = CIlinkAccounttoClientV4_IU_V1.mapRequestFields(applicationLst[0].Stock_Number__c, opportunities[0].CIF_Number__c, userRec[0].SiteCode__c, userRec[0].Teller_Operator_Code__c);
            CIlinkAccounttoClientV4_Resp_IB_V1 stockResponse = CIlinkAccounttoClientV4_IH_V1.CIlinkAccounttoClientV4(requestBean);

            if(stockResponse != null) {
                CIlinkAccounttoClientV4_Resp_IB_V1.CIlinkAccountToClientV4Response wrapper = (stockResponse.CIlinkAccountToClientV4Response != null ? stockResponse.CIlinkAccountToClientV4Response : null);
                CIlinkAccounttoClientV4_Resp_IB_V1.Nbsmsgo3 nbsmsgo3 = (wrapper != null ? wrapper.Nbsmsgo3 : null);

                response = JSON.serialize(stockResponse.message);

                if(stockResponse.statusCode == 200) {
                    response = stockResponse.statusCode + ' ' + (nbsmsgo3.msgEntry != null ? JSON.serialize(nbsmsgo3.msgEntry[0].msgTxt) : 'Service Returned No Messsage');
                }
                else{
                    response = stockResponse.statusCode + ' ' + (nbsmsgo3 != null ? JSON.serialize(nbsmsgo3.msgEntry[0].msgTxt) : stockResponse.status + ' ' + stockResponse.faultstring);
                }
            }
            else {
                response = 'Service callout failed!';
            }
        }
        else {
            response = 'No Application Record Found';
        }
        return response;
    }

    /**
    * @description : get application Product record linked to opp
    * @author Thabo | 06-07-2021
    * @param opportunityId
    * @return Application_Product__c
    * PS: Saurabh : I think this method will need refactoring as its randomly returning the first Item
    **/
    @AuraEnabled
    public static Application_Product__c getApplicationProduct(Id opportunityId) {
        List<Application__c> appList = new ApplicationsSelector().selectByOpportunityId(opportunityId);
        List<Application_Product__c> appProdCredList = new ApplicationProductSelector().selectByOpportunityId(opportunityId);

        if(appProdCredList.size() > 0 && appProdCredList != null) {
            Application_Product__c appProdCred = new Application_Product__c();
            if(appProdCredList.size() > 1) {
                for(Application_Product__c output: appProdCredList) {
                    if(output.Annual_Turnover__c != null && output.Asset_Value__c != null) {
                        appProdCred = output;
                    }
                }
                return appProdCred;
            }

            return appProdCredList[0];
        }
        else {
            return null;
        }
    }


    /**
    * @description : update the opp stage after the client details are saved
    * @author E.Mongwe/Thulani | 06-07-2021
    * @param oppId
    * @return String
     * W-004631
     * E.Mongwe need to change this to a void to be called on updateNCAsection when done testing
    **/
    @AuraEnabled
    public static String updateOpportunityStage(Id oppId) {
        String returnMessage = 'SUCCESS';
        try {
            List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
            if(opportunities != null && opportunities.size() > 0) {
                opportunities[0].StageName = StringConstants.OPPORTUNITY_STAGE_COMPLETE_PRODUCT_DETAILS;
                update opportunities;
            }
        }
        catch (Exception e) {
            throw new AuraHandledException('Something went wrong: ' +  e.getMessage());
        }
        return returnMessage;
    }


    /**
    * @description : update the client details from map returned from UI
    * @author Thulani Maseko | 06-07-2021
    * @param oppId
    * @param accountObj
    * @return Map<String, String>
    *
    **/
    @AuraEnabled
    public static Map<String, String> updateClientDetails(Id oppId, String accountObj) {
        Map<String, Object> mapObj = (Map<String, Object>)JSON.deserializeUntyped(accountObj);
        Map<String, String> updateResult = new Map<String, String>();

        List<Opportunity> opprunityList = new OpportunitiesSelector().selectByOpportunityId(oppId);
        Account account = new AccountsSelector().selectIndvByOpportunityIdUpdate(oppId);
        List<AccountContactRelation> acrList = new AccountContactRelationSelector().selectbyAccount(opprunityList[0].AccountId);

        if(!isEmptyOrNull(account)) {
            account.Date_Established__c = Date.parse(getFormatedDate((String)mapObj.get('DateEstablished')));
            account.Standard_Industry_SIC_Code__c = (String)mapObj.get('StandardIndustryCodeDesc');
            account.Client_Intent_To_Go_Into_Business_Rescue__c = (Boolean)mapObj.get('IsClientIntendsToGoIntoBusinessRescue');
            account.Client_intends_to_declare_insolvency__c = (Boolean)mapObj.get('IsClientIntendsInsolvencyLiquidation');
            account.Client_ever_been_declared_Insolvent__c = (Boolean)mapObj.get('IsClientDeclaredInsolvencyLiquidationPast');
            account.Client_is_a_stokvel__c = (Boolean)mapObj.get('IsClientIsStokvel');
            account.Client_is_a_municipality__c = (Boolean)mapObj.get('IsClientIsAMunicipality');
            account.Trading_indicator__c = (Boolean)mapObj.get('IsTradingIndicator');
            //account.Business_Start_Date__c = Date.parse(getFormatedDate((String)mapObj.get('BusinessStartDate')));
            /*account.Is_Marketing_Consent_Email__c = (Boolean)mapObj.get('IsEmailCredit');
            account.Is_Marketing_Consent_SMS__c = (Boolean)mapObj.get('IsSMSCredit');
            account.Is_Marketing_Consent_Phone__c = (Boolean)mapObj.get('IsPhoneCredit');
            account.Marketing_Consent_Info__c = (String)mapObj.get('emailCredit');
            account.Marketing_Consent_SMS__c = (String)mapObj.get('SMSCredit');
            account.Marketing_Consent_Phone__c = (String)mapObj.get('phoneCredit');
            account.Is_Non_Credit_Marketing_Consent_Email__c = (Boolean)mapObj.get('IsEmailNonCredit');
            account.Is_Non_Credit_Marketing_Consent_SMS__c = (Boolean)mapObj.get('IsSMSNonCredit');
            account.Is_Non_Credit_Marketing_Consent_Phone__c = (Boolean)mapObj.get('IsPhoneNonCredit');
            account.Non_Credit_Marketing_Consent_Email__c = (String)mapObj.get('emailNonCredit');
            account.Non_Credit_Marketing_Consent_SMS__c = (String)mapObj.get('SMSNonCredit');
            account.Non_Credit_Marketing_Consent_Phone__c = (String)mapObj.get('phoneNonCredit');*/

            if(((String)mapObj.get('ClientType')).toLowerCase() == 'sole trader') {
                account.Is_the_Client_a_Non_resident__c = (Boolean)mapObj.get('IsClientANonResident');
                account.Is_the_Client_a_Temporary_Resident__c = (Boolean)mapObj.get('IsClientATemporaryResident');
                account.Temporary_Resident_Permit_Number__c = (Decimal)mapObj.get('TemporaryResidentPermitNumber');
                account.Temporary_Resident_Permit_Expiry_Date__c = ((String)mapObj.get('TemporaryResidentPermitExpiryDate') == '' ? null : Date.parse(getFormatedDate((String)mapObj.get('TemporaryResidentPermitExpiryDate'))));
                account.Residential_Status_Address__c = (String)mapObj.get('ResidentialStatusAddress');
                account.Residential_Status__c = (String)mapObj.get('ResidentialStatusBorder');
                account.Date_Current_Address_Since__c = (mapObj.get('DateCurrentAddressSince') == '' ? null : Date.parse(getFormatedDate((String)mapObj.get('DateCurrentAddressSince'))));
                account.Financial_Year_End__c = (String)mapObj.get('FinancialYearEnd');
                account.Is_Client_Part_Of_Enter_Development_Fund__c = (Boolean)mapObj.get('IsClientPartOfAnEnterpriseDevelopmentFund');
                account.Development_Fund_Partner_Client_Code__c = (String)mapObj.get('DevelopmentFundPartnerClientCode');
                account.Development_Fund_Name__c = (String)mapObj.get('DevelopmentFundName');
                account.Is_Part_of_Franchise__c = (Boolean)mapObj.get('ClientOperatesUnderAnExistingFranchiseContractAgreement');
                account.Franchise_Code__c = (String)mapObj.get('FranchiseCode');
                account.Franchise_Name__c = (String)mapObj.get('FranchiseName');
                account.Business_Rescue_Affected_Party__c = (String)mapObj.get('BusinessRescueAffectedParty');
            }

            try {
                update account;
                updateResult.put('accountUpdate', 'Updated');
            }
            catch(Exception ex) {
                updateResult.put('accountUpdate', 'Error Updating: ' + ex.getDmlMessage(0));
            }
        }

        if(!isNullOrEmpty(acrList)) {
            AccountContactRelation acr = acrList[0];
            //acr.StartDate = businessStartDate;

            try {
                update acr;
                updateResult.put('acrUpdate', 'Updated');
            }
            catch(Exception ex) {
                updateResult.put('acrUpdate', 'Error Updating');
            }
        }
        return updateResult;
    }


    /**
    * @description : Update NCA fields from UI input
    * @author Thabo Senkomane | 06-07-2021
    * @param creditAgreement
    * @param numberOfTrustees
    * @param anyJuristicTrustee
    * @param annualTurnover
    * @param assetValue
    * @param clientState
    * @param underExistingFranchise
    * @param partOfEnterpriseDevFund
    * @param opportunityId
    * @return String
    * @ Update : Saurabh : 011629 Storing the fields on App record Now
    **/
    @AuraEnabled
    public static String updateNCAsection(Boolean creditAgreement,Double numberOfTrustees,String anyJuristicTrustee,
                                          Double annualTurnover,Double assetValue,String clientState,Boolean underExistingFranchise,
                                          Boolean partOfEnterpriseDevFund, id opportunityId) {
        String returnReponse = null;
        Application__c appCredit = new ApplicationsSelector().selectByCreditOpportunityId(opportunityId);
          if(appCredit != null) {
                appCredit.Credit_Agreement_at_Arms_Length__c = creditAgreement;
                appCredit.Number_of_Trustees__c = numberOfTrustees;
                appCredit.Any_Juristic_Trustees__c = anyJuristicTrustee;
                appCredit.Annual_Turnover__c = annualTurnover;
                appCredit.Asset_Value__c = assetValue;
                appCredit.Organ_of_State__c = clientState;
                appCredit.Client_Operates_Under_Existing_Franchise__c = underExistingFranchise;
                appCredit.Part_of_Enterprise_Development_Fund__c = partOfEnterpriseDevFund;
            }

            try {
                update appCredit;
                returnReponse = 'SUCCESS';
                //method to update opportunity stage
                //updateOpportunityStage(oppId);

                //insert Application Profile Records upon Success
                createAppProfileRecords(opportunityId);
            }
            catch(exception e) {
                returnReponse = 'ERROR';
            }
        return returnReponse;
    }


    /**
    * @description
    * @author E. Mongwe | 06-07-2021 | @ W-005598
    * @param oppId
    * @param selectedIDs
    * @param selectedMainID
    * @param isInfoCorrect
    * @return String
    **/
    @AuraEnabled
    public static String updatePrincipal(Id oppId, List<Id> selectedIDs, Id selectedMainID, Boolean isInfoCorrect) {
        return principalShareholderDetails.updatePrincipals(oppId, selectedIDs, selectedMainID, isInfoCorrect);
    }


    /**
    * @description Method to query all the linked CIF codes with Main Client and Principals and Create Application Profile records for the
    * @author Saurabh /Fano/ Englarmerdge : W-006981
    * @param OppId
    **/
    @Future(callout=true) //will have to do better handling later
    public static void createAppProfileRecords(Id OppId) {

        try{
            List<Account> accNoIdReg = new List<Account>();
            Set<String> existingIdList = new Set<String>();
            Set<String> appPrincipalIdRegList = new Set<String>();
            Set<sobject> ClientDetails = new Set<sobject>(); // will have to later map for each client Type ie : ID_Number__pc when soleProp is finalised
            Map<String,String> translationMap = new Map<String, String>();
            List<Integration_Translation__c> translationList = [SELECT Id, Direction__c, External_Value__c, Internal_Value__c, System_Name__c, Value_Type__c, Name FROM Integration_Translation__c WHERE Value_Type__c = 'Identity Type' and Direction__c = 'Outbound' and system_name__c='CIF'];

            for(Integration_Translation__c trnsRecord : translationList) {
                translationMap.put(trnsRecord.Internal_Value__c, trnsRecord.External_Value__c);
            }

            //move this to selector once Sole Prop Changes from Onboarding is finalised
            Opportunity oppRecord = [SELECT Id,AccountId,Account.Name,Account.Company_Registration_Number__c,Account.ID_Type__c, Account.Client_Type__c, Account.ID_Type__pc, Account.Registration_Number__c,Account.Passport_Number__pc,Account.ID_Number__pc,Account.CIF__c,Is_Spouse_Captured__c,Spouse_Account_Id__c from Opportunity WHERE id =:OppId ]; //
            oppRecord.Account.Registration_Number__c = (oppRecord.Account.Registration_Number__c != null ? oppRecord.Account.Registration_Number__c : oppRecord.Account.Company_Registration_Number__c);
            if(oppRecord.AccountId != Null && (oppRecord.Account.Registration_Number__c != null || (oppRecord.Account.ID_Number__pc != Null ||oppRecord.Account.Passport_Number__pc != Null ))) {
            	ClientDetails.add(oppRecord);
            } else if(oppRecord.AccountId != Null && oppRecord.Account.Registration_Number__c == null && oppRecord.Account.ID_Number__pc == Null && oppRecord.Account.Passport_Number__pc == Null){
            	accNoIdReg.add(new Account(Id=oppRecord.AccountId, Name=oppRecord.Account.Name, Company_Registration_Number__c=oppRecord.Account.Company_Registration_Number__c, ID_Type__c=oppRecord.Account.ID_Type__c, Client_Type__c=oppRecord.Account.Client_Type__c, ID_Type__pc=oppRecord.Account.ID_Type__pc, Registration_Number__c=oppRecord.Account.Registration_Number__c, Passport_Number__pc=oppRecord.Account.Passport_Number__pc, ID_Number__pc=oppRecord.Account.ID_Number__pc, CIF__c=oppRecord.Account.CIF__c));
            }

            //check if Spouse is Captured then add the Spouse Account Record also
            if(oppRecord.AccountId != Null && oppRecord.Is_Spouse_Captured__c == true && oppRecord.Spouse_Account_Id__c != Null) {
                Account spouseAcc = [Select id, CIF__c, ID_Type__pc, Passport_Number__pc, ID_Number__pc,name from Account WHERE id =:oppRecord.Spouse_Account_Id__c ];
                ClientDetails.add(spouseAcc);

                if(spouseAcc.CIF__c == null){
                    String idPassNum = spouseAcc.ID_Number__pc != null ? spouseAcc.ID_Number__pc : spouseAcc.Passport_Number__pc;

                    if(idPassNum != null){
                        appPrincipalIdRegList.add(idPassNum);
                    }
                }
            }

            Application__c appRec = new ApplicationsSelector().selectByCreditOpportunityId(OppId);
            List<Application_Principal__c> appPrinList = new ApplicationPrincipalsSelector().getApplicationPrincipals(appRec.Id);
            List<SObject> nonAllocateCIFs = new List<SObject>();
            List<String> appPrincipalCIFList = new List<String>();

            if(appPrinList != null) {
                for (Application_Principal__c appPrin :appPrinList) {
                    if(appPrin.Id_Number__c != Null || appPrin.Id_Number__c != '') {
                        ClientDetails.add(appPrin);
                        if(appPrin.CIF__c != null){
                            appPrincipalCIFList.add(appPrin.CIF__c);
                        } else if(appPrin.Id_Number__c != null){
                            appPrincipalIdRegList.add(appPrin.Id_Number__c);
                        }
                    }
                }
            }

            Map<GetClientDetailsByIdCIF_Resp_IB_v1, Sys_Log_Integration__c> responseMap = new Map<GetClientDetailsByIdCIF_Resp_IB_v1, Sys_Log_Integration__c> ();
            List<Application_Profile__c> recordsToInsert = new List<Application_Profile__c>();
            String siteCodeP = '6520'; String idNumberP; String idDocTypeP; String relatedToClientCode ; String spouseIdNumber = '' ; Boolean spouseIdentified = False ;//replace with userSiteCode Later
            List<String> existingAccNameList = new List<String>();
            List<Application_Profile__c> existingAprList = new ApplicationProfileSelector().getApplicationProfiles(appRec.Id);

            for(Application_Profile__c existAppProf : existingAprList){
                existingAccNameList.add(existAppProf.Account__r.Name);
            }
            system.debug('ClientDetails list'+ClientDetails);
            for (SObject clientRecord : ClientDetails) {
				Boolean isAppPrincAllocated = true;

                if(clientRecord instanceof Opportunity) {
                    //checking for Sole Trader
                    if((String)clientRecord.getSObject('Account').get('Client_Type__c') == 'Sole Trader') {
                        idDocTypeP =  (String)clientRecord.getSObject('Account').get('ID_Type__pc');
                        idNumberP = (String)clientRecord.getSObject('Account').get('Passport_Number__pc') != Null ? (String)clientRecord.getSObject('Account').get('Passport_Number__pc'):(String)clientRecord.getSObject('Account').get('ID_Number__pc')  ;
                        responseMap = GetClientDetailsByIdCIF_IH_v1.getClientDetailsMap(String.valueOf(idNumberP.replaceAll('[\\/]','')), translationMap.get(idDocTypeP), siteCodeP);
                    }
                    // Not checking for Trust as per the comments from SA
                    /*if((String)clientRecord.getSObject('Account').get('Client_Type__c') == 'Trusts') {
                    idNumberP = (String)clientRecord.getSObject('Account').get('Passport_Number__pc') != Null ? (String)clientRecord.getSObject('Account').get('Passport_Number__pc'):(String)clientRecord.getSObject('Account').get('ID_Number__pc')  ;
                    } */
                    // for Clients Other than Sole Trader use Reg Number
                    else {
                        idDocTypeP =  (String)clientRecord.getSObject('Account').get('ID_Type__c');
                        idNumberP = (String)clientRecord.getSObject('Account').get('Registration_Number__c');
                        responseMap = GetClientDetailsByIdCIF_IH_v1.getClientDetailsMap(String.valueOf(idNumberP.replaceAll('[\\/]','')), translationMap.get(idDocTypeP), siteCodeP);

                        for(GetClientDetailsByIdCIF_Resp_IB_v1 responseBean : responseMap.keySet()) {
                            Opportunity opp = (Opportunity) clientRecord;

                            if(oppRecord.Account.CIF__c != null){
                                Account mainAcc = new Account(Id = oppRecord.AccountId, CIF__c = oppRecord.Account.CIF__c, ID_Type__pc = oppRecord.Account.Id_Type__pc, Passport_Number__pc = oppRecord.Account.Passport_Number__pc, ID_Number__pc = oppRecord.Account.ID_Number__pc);

                                if(responseBean.tblEntry != null){
                                    String tblEntryString = String.valueOf(responseBean.tblEntry);

                                    if(!tblEntryString.contains(mainAcc.CIF__c)){
                                        nonAllocateCIFs.add(mainAcc);
                                        isAppPrincAllocated = false;
                                    }
                                } else {
                                    nonAllocateCIFs.add(mainAcc);
                                    isAppPrincAllocated = false;
                                }
                            }
                        }
                    }
                    system.debug('nonAllocateCIFs0'+nonAllocateCIFs);
                }
                else if(clientRecord instanceof Application_Principal__c) {
                    idDocTypeP = (String)clientRecord.get('ID_Type__c');
                    system.debug('idDocTypeP'+idDocTypeP);
                    idNumberP = (String)clientRecord.get('Id_Number__c');
                    system.debug('idNumberP'+idNumberP);
                    system.debug('translationMap.get(idDocTypeP)'+translationMap.get(idDocTypeP));
                    system.debug('siteCodeP'+siteCodeP);
                    responseMap = GetClientDetailsByIdCIF_IH_v1.getClientDetailsMap(String.valueOf(idNumberP.replaceAll('[\\/]','')), translationMap.get(idDocTypeP), siteCodeP);
                    system.debug('responseMap'+responseMap.keySet());
                    for(GetClientDetailsByIdCIF_Resp_IB_v1 responseBean : responseMap.keySet()) {
                        system.debug('responseBean'+responseBean);
                        Application_Principal__c appPrinc = (Application_Principal__c) clientRecord;
                        system.debug('appPrinc'+appPrinc);
                        if(appPrinc.CIF__c != null){
                            system.debug('responseBean.tblEntry'+responseBean.tblEntry);
                            if(responseBean.tblEntry != null){
                                String tblEntryString = String.valueOf(responseBean.tblEntry);
                                system.debug('tblEntryString'+tblEntryString);
                                if(!tblEntryString.contains(appPrinc.CIF__c)){
                                    nonAllocateCIFs.add(appPrinc);
                                    isAppPrincAllocated = false;
                                }
                            } else {
                                system.debug('appPrinc1'+appPrinc);
                                nonAllocateCIFs.add(appPrinc);
                                system.debug('nonAllocateCIFsL'+nonAllocateCIFs);
                                isAppPrincAllocated = false;
                            }
                        }
                    }
                    system.debug('nonAllocateCIFs1'+nonAllocateCIFs);
                }
                //Call the Service for Spouse also
                else if(clientRecord instanceof Account) {
                    idDocTypeP = (String)clientRecord.get('ID_Type__pc');
                    idNumberP = (String)clientRecord.get('Passport_Number__pc') != Null ? (String)clientRecord.get('Passport_Number__pc'):(String)clientRecord.get('ID_Number__pc')  ;
                    spouseIdNumber = idNumberP ; //copying the Id number for Matching
                    responseMap = GetClientDetailsByIdCIF_IH_v1.getClientDetailsMap(String.valueOf(idNumberP.replaceAll('[\\/]','')), translationMap.get(idDocTypeP), siteCodeP);

                    for(GetClientDetailsByIdCIF_Resp_IB_v1 responseBean : responseMap.keySet()) {
                        Account spouseAcc = (Account) clientRecord;

                        if(responseBean.tblEntry != null){
                            if(spouseAcc.CIF__c != null){
                                String tblEntryString = String.valueOf(responseBean.tblEntry);

                                if(!tblEntryString.contains(spouseAcc.CIF__c)){
                                    nonAllocateCIFs.add(spouseAcc);
                                    isAppPrincAllocated = false;
                                }
                            } else {
                                String idPassNum = spouseAcc.ID_Number__pc != null ? spouseAcc.ID_Number__pc : spouseAcc.Passport_Number__pc;

                                if(idPassNum != null){
                                    appPrincipalIdRegList.add(idPassNum);
                                }
                            }
                        } else {
                            nonAllocateCIFs.add(spouseAcc);
                            isAppPrincAllocated = false;
                        }
                    }
                    system.debug('nonAllocateCIFs2'+nonAllocateCIFs);
                }

                //get the list of existing CIF Codes to avoid duplication
                List<String> existingCIFList = new List<String>();

                if(!existingAprList.isEmpty()) {
                    for(Application_Profile__c apr : existingAprList ) {
                        existingCIFList.add(apr.Client_CIF_Code__c);

                        if(apr.Client_CIF_Code__c == null){
                            String idRegPass = apr.Account__r.ID_Number__pc != null ? apr.Account__r.ID_Number__pc : apr.Account__r.Passport_Number__pc != null ? apr.Account__r.Passport_Number__pc : apr.Account__r.Registration_Number__c != null ? apr.Account__r.Registration_Number__c : null;

                            if(idRegPass != null){
                                existingIdList.add(idRegPass);
                            }
                        }
                    }
                }

                //need to check if records already exist and principal Section Update
                for(GetClientDetailsByIdCIF_Resp_IB_v1 responseBean : responseMap.keySet()) {
                    String applicantType;

                    if(responseBean.tblEntry != null){
                        for(GetClientDetailsByIdCIF_Resp_IB_v1.cls_tblEntry record : responseBean.tblEntry) {
                            system.debug('record.cifKey'+record.cifKey);
                            Application_Profile__c appProfile = new Application_Profile__c();

                            if(!existingCIFList.contains(record.cifKey)) {
                                //check for main applicant and spouse
                                if(oppRecord.account.CIF__c != null && oppRecord.account.CIF__c == record.cifKey) {
                                    appProfile.Applicant_Type__c = 'Main Applicant'; //this logic should be questioned for clients with No CIF ie : Lite Onboarding
                                    appProfile.Is_Main_Applicant__c = true;
                                }
                                //Putting this Client Type Code based check to identify the spouse from Response
                                else if(oppRecord.Is_Spouse_Captured__c && spouseIdNumber == idNumberP) {
                                    if(record.cifClntType.endswith('01') && !spouseIdentified ) {
                                        appProfile.Applicant_Type__c = 'Spouse';
                                        spouseIdentified = true;
                                    }
                                    else if(record.cifClntType.endswith('04') && !spouseIdentified ) {
                                        appProfile.Applicant_Type__c = 'Spouse';
                                        spouseIdentified = true;
                                    }
                                    else if(record.cifClntType.endswith('081') && !spouseIdentified ) {
                                        appProfile.Applicant_Type__c = 'Spouse';
                                        spouseIdentified = true;
                                    }
                                }
                                else if (appPrincipalCIFList.contains(record.cifKey)) { //Matching Principal CIF
                                    appProfile.Applicant_Type__c = 'Principal';
                                }
                                appProfile.Related_to_Client_Id_Or_Reg_Number__c = idNumberP; // relating the child record with Id/reg Number for Aggregation
                                appProfile.Client_CIF_Code__c = record.cifKey;
                                appProfile.Client_Name__c = record.cifSurname;
                                appProfile.Application__c = appRec.Id;
                                recordsToInsert.add(appProfile);
                            }
                        }
                    }
                    system.debug('isAppPrincAllocated'+isAppPrincAllocated);
                    if(!isAppPrincAllocated) {
                        for(SObject nonAllocateCIF : nonAllocateCIFs){
                            Application_Profile__c appProfile = new Application_Profile__c();
                            String cifNum = '';
                            String clientName = '';
                            String idRegPass = '';

                            if(nonAllocateCIF instanceof Account){
                                Account nonAllocateCIFAcc = (Account) nonAllocateCIF;
                                appProfile.Account__c = nonAllocateCIFAcc.Id;
                                cifNum = nonAllocateCIFAcc.CIF__c;
                            	clientName = nonAllocateCIFAcc.Name;
                            	idRegPass = nonAllocateCIFAcc.ID_Number__pc != null ? nonAllocateCIFAcc.ID_Number__pc : nonAllocateCIFAcc.Passport_Number__pc != null ? nonAllocateCIFAcc.Passport_Number__pc : null;
                            } else if(nonAllocateCIF instanceof Application_Principal__c){
                                Application_Principal__c nonAllocateCIFAppPrinc = (Application_Principal__c) nonAllocateCIF;
                                cifNum = nonAllocateCIFAppPrinc.CIF__c;
                            	clientName = nonAllocateCIFAppPrinc.Principal_Shareholder_Name__c;
                            	idRegPass = nonAllocateCIFAppPrinc.Id_Number__c;
                            }

                            if(!existingCIFList.contains(cifNum)) {
                                if(oppRecord.account.CIF__c != null && oppRecord.account.CIF__c == cifNum) {
                                    appProfile.Applicant_Type__c = 'Main Applicant';
                                    appProfile.Is_Main_Applicant__c = true;
                                } else if (appPrincipalCIFList.contains(cifNum)) { //Matching Principal CIF
                                    appProfile.Applicant_Type__c = 'Principal';
                                }

                                appProfile.Related_to_Client_Id_Or_Reg_Number__c = idRegPass;
                                system.debug('cifNum'+cifNum);
                                appProfile.Client_CIF_Code__c = cifNum;
                                appProfile.Client_Name__c = clientName;
                                appProfile.Application__c = appRec.Id;
                                recordsToInsert.add(appProfile);
                            }
                        }
                    }
                }//response Bean iteration end
            }//client record iteration end

            if(accNoIdReg != null && accNoIdReg.size() > 0){

                for(Account account : accNoIdReg){
                    if(!existingAccNameList.contains(account.Name)){
                        Application_Profile__c appProfile = new Application_Profile__c();

                        if(oppRecord.Account.Name == account.Name) {
                            appProfile.Applicant_Type__c = 'Main Applicant';
                            appProfile.Is_Main_Applicant__c = true;
                            appProfile.Client_Name__c = account.Name;
                            appProfile.Client_CIF_Code__c = account.CIF__c != null ? account.CIF__c : null;
                            appProfile.Application__c = appRec.Id;
                            appProfile.Account__c = account.Id;
                            recordsToInsert.add(appProfile);
                        }
                    }
                }
            }

            if(appPrincipalIdRegList != null && appPrincipalIdRegList.size() > 0){
                List<Account> appPrincipalAccounts = new AccountsSelector().selectAccountByIdPassportRegNumber(appPrincipalIdRegList);
                Set<String> insertedIds = new Set<String>();

                if(appPrincipalAccounts != null && appPrincipalAccounts.size() > 0){
                    for(Account appPrincipalAccount : appPrincipalAccounts){
                        String idRegPass = appPrincipalAccount.ID_Number__pc != null ? appPrincipalAccount.ID_Number__pc : appPrincipalAccount.Passport_Number__pc != null ? appPrincipalAccount.Passport_Number__pc : appPrincipalAccount.Registration_Number__c != null ? appPrincipalAccount.Registration_Number__c : null;

                        if(idRegPass != null){
                            if(!insertedIds.contains(idRegPass) && !existingIdList.contains(idRegPass)){
                                Application_Profile__c appProfile = new Application_Profile__c();
                                insertedIds.add(idRegPass);

                                if(oppRecord.account.ID_Number__pc == idRegPass) {
                                    appProfile.Applicant_Type__c = 'Main Applicant';
                                    appProfile.Is_Main_Applicant__c = true;
                                } else if(oppRecord.Is_Spouse_Captured__c && spouseIdNumber == idRegPass) {
                                    appProfile.Applicant_Type__c = 'Spouse';
                                    spouseIdentified = true;
                                } else {
                                    appProfile.Applicant_Type__c = 'Principal';
                                }

                                appProfile.Related_to_Client_Id_Or_Reg_Number__c = idRegPass; // relating the child record with Id/reg Number for Aggregation
                                appProfile.Client_Name__c = appPrincipalAccount.Name;
                                appProfile.Application__c = appRec.Id;
                                appProfile.Account__c = appPrincipalAccount.Id;
                                recordsToInsert.add(appProfile);
                            }
                        }
                    }
                }
            }

            if(!recordsToInsert.isEmpty()){
                //Added by Ephetehe - This allows us to easily reference data on the account for Application_Profile__c records that are related to accounts
                Set<String> clientCIFs = new Set<String>();

                for(Application_Profile__c appProfile : recordsToInsert){
                    if((appProfile.Applicant_Type__c == 'Main Applicant' || appProfile.Applicant_Type__c == 'Spouse' || appProfile.Applicant_Type__c == 'Principal') && appProfile.Client_CIF_Code__c != null){
                        clientCIFs.add(appProfile.Client_CIF_Code__c);
                    }
                }

                Map<String, Id> clientTypesByCIF = getAppProfileAccounts(clientCIFs);

                if(clientTypesByCIF != null){
                    for(Application_Profile__c appProfile : recordsToInsert){
                    	if((appProfile.Applicant_Type__c == 'Main Applicant' || appProfile.Applicant_Type__c == 'Spouse' || appProfile.Applicant_Type__c == 'Principal') && appProfile.Client_CIF_Code__c != null){
                            appProfile.Account__c = clientTypesByCIF.get(appProfile.Client_CIF_Code__c);
                        }
                    }
                }
                //End added by Ephetehe

				//insert application profiles
                insert recordsToInsert;
            }

            //logging for service call
            if(!responseMap.values().isEmpty()) {
                insert responseMap.values();

                //call the GBgetCmsLimitsDetV1_Request here
                //2021-02-05
                /* not removing as this might be needed after mvp1
                if (oppRecord.Account.CIF__c != null && appRec.Id != null){
                    //mapHighLevelLimitIndicatorForProfile(appRec.Id, oppRecord.Account.CIF__c);
                } */
            }
        } catch (Exception e) {
            //Aura Handled Exceptions wont work in Asynchronus Mode so changing it to debug
            //throw new AuraHandledException('! Something went wrong while creating Client Profile Records'
            System.debug('Exception occured: ' + e.getMessage() + ' Line Number: ' + e.getLineNumber());
        }
    }

    /** Method to map high level limit indicator for 'Main Applicant' OR 'Principal'.
     *
     * @param application profiles
     * @param CIF
    **  commenting this method for MVP1 will be used later
    @Future(callout=true)
    public static void mapHighLevelLimitIndicatorForProfile(String appRecId, String cifCode) {
        List<Application_Profile__c> appProfileUpdateList = new List<Application_Profile__c>();
        List<Application_Profile__c> existingAppProfileList = new ApplicationProfileSelector().getApplicationProfiles(appRecId);
        Boolean highLimitcheck = GBgetCmsLimitsDetV1_Request.GBgetCmsLimitsDetV1_Request(cifCode);

        for (Application_Profile__c appProfile : existingAppProfileList){


            if (appProfile.Applicant_Type__c == 'Main Applicant' || appProfile.Applicant_Type__c == 'Principal'){

                if (highLimitcheck){
                    appProfile.HighLevelLimitIndicator__c = 'Y';
                    appProfileUpdateList.add(appProfile);
                }
                else{
                    appProfile.HighLevelLimitIndicator__c = 'N';
                    appProfileUpdateList.add(appProfile);
                }
            }

            if (appProfileUpdateList.size() > 0 && appProfileUpdateList != null){
                update appProfileUpdateList;
            }
        }
    } */


    /**
    * @description : Method to get account by CIF
    * @author unknown | 06-07-2021
    * @param cifCodes
    * @return Map<String, Id>
    **/
    @testVisible
    private static Map<String, Id> getAppProfileAccounts(Set<String> cifCodes){
        List<Account> accounts = new AccountsSelector().selectByCIF(cifCodes, 20);
        Map<String, Id> clientTypesByCIF = new Map<String, String>();

        if(!accounts.isEmpty()){
            for(Account account : accounts){
                clientTypesByCIF.put(account.CIF__c, account.Id);
            }

            return clientTypesByCIF;
        }

        return null;
    }
    /**
    * @description : get formatted date from string
    * @author Thabo | 06-07-2021
    * @param inputDate
    * @return String
    **/
    @testVisible
    private static String getFormatedDate(String inputDate) {
        if(inputDate?.length() >= 10) {
            String stringDate = inputDate.substring(0,4) + '/' + inputDate.substring(5,7) + '/' + inputDate.substring(8,10);
            return stringDate;
        }
        else if(inputDate?.length() == 8) {
            String stringDate = inputDate.substring(0,4) + '/' + inputDate.substring(4,6) + '/' + inputDate.substring(6,8);
            return stringDate;
        }
        return '';
    }

    /**
    * @description : Not sure if this cant be done via standard methods
    * @author unknown | 06-07-2021
    * @param obj
    * @return Boolean
    **/
    private static Boolean isEmptyOrNull(sObject obj) {
        return obj == null;
    }

    /**
    * @description : Not sure if this cant be done via standard methods
    * @author unknown | 06-07-2021
    * @param objList
    * @return Boolean
    **/
    private static Boolean isNullOrEmpty(List<sObject> objList) {
        return objList == null || objList.size() == 0;
    }
}