/**
* Controller for Will Registration Lightning component
* Calling Multiple Services like :Stock Service,CreateWillRecord,CreateTracker,GetWillDetail,UpdateWillDetail,DebitOrderInstructions,
*                                  createWillBankingDetail,UpdateToCIF Services,CreateTrackerAfterRegistration,AssetLiabilities etc  
* @author      -Himanshu Nimje (Mphatek)
* @created     -2019-01-28
*
* @updated by  -Himanshu nimje (Mphatek)
* @Updated On 03-04-2019
* @update - Revision of the Will when there is no Salesforce Opp/Asset found.
*           calling Services -GetWillDetail,DebitOrderInstructions,GetWillBankingDetails,UpdateWillBankingDetails,CreateWillBankingDetails,GetAssetsLiabilities,
*           CreateAssetsLiabilities,CreateTrackerEntry,UpdateWillDetails
*/
public class WillRegistrationController {
    static final String traceDefault = 'N';
    
    public static Map <String, Schema.RecordTypeInfo> assetRecordTypeMap = Asset.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();    
    
    /**
    * Method that validate previous checks were done or not on load
    *
    * @param oppId - opportunity Id
    * 
    * @return List<String> list.
    */
    @AuraEnabled
    public static List<String> checkInitValidity(Id oppId) {
        Opportunity opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId).get(0);
        List<Application__c> application = new ApplicationsSelector().selectByOpportunityId(oppId);
        List<String> validityMessages = new List<String>();
        String invalidComponents = 'The following have not yet been completed: \r\n';
        String validity = 'Valid';
        if(application.size()==0) {
            validity='Invalid';
            if(opportunities.CASA_Status__c != 'Valid'){
                validity = 'Invalid';
                invalidComponents += '- CASA \r\n';
            }
            if(opportunities.Risk_Status__c != 'Valid'){
                validity = 'Invalid';
                invalidComponents += '- Risk Rating \r\n';
            }
            invalidComponents += '- Drafting Fee \r\n';
            invalidComponents += '- Communication Preference \r\n';
            invalidComponents += '- Safe Custody \r\n';
        }else if(application.size() > 0){
            System.debug('checkInitValidity :Application Data : '+application.get(0));
            if(opportunities.CASA_Status__c != 'Valid'){
                validity = 'Invalid';
                invalidComponents += '- CASA \r\n';
            }
            if(opportunities.Risk_Status__c != 'Valid'){
                validity = 'Invalid';
                invalidComponents += '- Risk Rating \r\n';
            }
            if(application.get(0).Drafting_Fee_Status__c != 'Valid'){
                validity = 'Invalid';
                invalidComponents += '- Drafting Fee \r\n';
            }
            if(application.get(0).Communication_Preference_Status__c != 'Valid'){
                validity = 'Invalid';
                invalidComponents += '- Communication Preference \r\n';
            }
            if(application.get(0).Safe_Custody_Status__c != 'Valid'){
                validity = 'Invalid';
                invalidComponents += '- Safe Custody \r\n';
            }
            if(opportunities.CASA_Status__c == 'Valid' && opportunities.Risk_Status__c == 'Valid'
               && application.get(0).Drafting_Fee_Status__c == 'Valid'
               && application.get(0).Communication_Preference_Status__c == 'Valid'
               && application.get(0).Safe_Custody_Status__c == 'Valid'){
                   validity = 'Valid';
                   invalidComponents = ' ';
               }
        }
        validityMessages.add(validity);
        validityMessages.add(invalidComponents);
        System.debug('############  validityMessages : '+validityMessages);
        return validityMessages;
    }
    
    /**
    * Method that checks Registration Error on load
    *
    * @param oppId - opportunity Id
    */
    @AuraEnabled
    public static List<String> checkRegistrationError(Id oppId) {        
        Opportunity opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId).get(0);
        List<Application__c> application = new ApplicationsSelector().selectByOpportunityId(oppId);
        List<String> ErrorMessages = new List<String>();
        String validity = 'PreviousError';
        String invalidComponents =' Registration Status : - \r\n ';
        System.debug('checkRegistrationError :Application Data : '+application.get(0));
        if(application.size() > 0){
            //Registration is already done 
            if(application.get(0).Registration_Status__c == 'Submitted'){
                validity ='Done';
                invalidComponents='';
                System.debug('Registration is already done ');
            }
            //Registration Process not Started but Previous validatin done
            if(application.get(0).Registration_Status__c == 'New' && application.get(0).Drafting_Fee_Status__c=='Valid' && application.get(0).Communication_Preference_Status__c=='Valid' && application.get(0).Safe_Custody_Status__c=='Valid' && opportunities.Risk_Status__c == 'Valid' && opportunities.CASA_Status__c == 'Valid') { 
                validity ='Not Started';
                invalidComponents='Please click to start registration  : - \r\n  ';
                System.debug('Registration Process not Started but Previous validatin done');
            } 
            //If no error Log and still we need to show confirmation button to go ahead with Registration :
            if(application.get(0).Will_Stock_Confirmation__c==true && application.get(0).Registration_Status__c != 'Submitted' ){
                validity = 'Invalid'; 
                System.debug('If no error Log and still we need to show confirmation button to go ahead with Registration');
            }
            //Stock Service
            if(!String.isBlank(application.get(0).Will_Reg_Stock_Service_Error__c) && application.get(0).Will_Reg_Stock_Service_Error__c !=null && application.get(0).Registration_Status__c != 'Submitted' && application.get(0).Registration_Status__c == 'Incomplete'){
                validity = 'Invalid';
                invalidComponents += '- Stock Service :'+ application.get(0).Will_Reg_Stock_Service_Error__c +' \r\n';
                System.debug('Stock Service');
            }
            //Asset creation in SF
            if(!String.isBlank(application.get(0).Will_Reg_Asset_creation_in_SF_Error__c )&& application.get(0).Will_Reg_Asset_creation_in_SF_Error__c !=null  && application.get(0).Registration_Status__c != 'Submitted' && application.get(0).Registration_Status__c == 'Incomplete'){
                validity = 'Invalid';
                invalidComponents += '- Asset Creation in Salesforce :'+ application.get(0).Will_Reg_Asset_creation_in_SF_Error__c +' \r\n';
                System.debug('Asset creation in SF');
            }
            //Asset creation in Will
            if(!String.isBlank(application.get(0).Will_Reg_Asset_creation_in_Will_Sy_Error__c) && application.get(0).Will_Reg_Asset_creation_in_Will_Sy_Error__c !=null   && application.get(0).Registration_Status__c != 'Submitted' && application.get(0).Registration_Status__c == 'Incomplete'){
                validity = 'Invalid';
                invalidComponents += '- Asset Creation in Will :'+ application.get(0).Will_Reg_Asset_creation_in_Will_Sy_Error__c +' \r\n';
                System.debug('Asset creation in Will');
            }
            //Create Tracker
            if(!String.isBlank(application.get(0).Will_Initialise_Tracker_Created_Error__c) && application.get(0).Will_Initialise_Tracker_Created_Error__c !=null   && application.get(0).Registration_Status__c != 'Submitted' && application.get(0).Registration_Status__c == 'Incomplete'){
                validity = 'Invalid';
                invalidComponents += '- Asset Creation Tracker :'+ application.get(0).Will_Initialise_Tracker_Created_Error__c +' \r\n';
                System.debug('Create Tracker');
            } 
            //Get Will Detail
            if(!String.isBlank(application.get(0).Will_Reg_Get_Asset_from_Will_Error__c) && application.get(0).Will_Reg_Get_Asset_from_Will_Error__c !=null   && application.get(0).Registration_Status__c != 'Submitted' && application.get(0).Registration_Status__c == 'Incomplete'){
                validity = 'Invalid';
                invalidComponents += '- Asset Get Wills Detail :'+ application.get(0).Will_Reg_Get_Asset_from_Will_Error__c +' \r\n';
                System.debug('Get Will Detail');
            }
            //Update Will Detail
            if(!String.isBlank(application.get(0).Will_Reg_Asset_update_in_Will_Sys_Error__c) && application.get(0).Will_Reg_Asset_update_in_Will_Sys_Error__c !=null  && application.get(0).Registration_Status__c != 'Submitted' && application.get(0).Registration_Status__c == 'Incomplete'){
                validity = 'Invalid';
                invalidComponents += '- Asset Updation in WIll :'+ application.get(0).Will_Reg_Asset_update_in_Will_Sys_Error__c +' \r\n';
                System.debug('Update Will Detail');
            }
            //Create Debit Order Instructions -Drafting fee
            if(!String.isBlank(application.get(0).Will_Drafting_Banking_Detail_Error__c) && application.get(0).Will_Drafting_Banking_Detail_Error__c !=null  && application.get(0).Registration_Status__c != 'Submitted'  && application.get(0).Registration_Status__c == 'Incomplete'){  
                validity = 'Invalid';
                invalidComponents += '- Drafting Banking Detail  :'+ application.get(0).Will_Drafting_Banking_Detail_Error__c +' \r\n';
                System.debug('Create Debit Order Instructions -Drafting fee');
            }
            //Create Will banking Detail - safe Custody fee
            if(!String.isBlank(application.get(0).Will_Reg_Crete_Will_Banking_Detail_Error__c) && application.get(0).Will_Reg_Crete_Will_Banking_Detail_Error__c !=null  && application.get(0).Registration_Status__c != 'Submitted'  && application.get(0).Registration_Status__c == 'Incomplete'){  
                validity = 'Invalid';
                invalidComponents += '- SCF Banking Detail:'+ application.get(0).Will_Reg_Crete_Will_Banking_Detail_Error__c +' \r\n';
                System.debug('Create Will banking Detail - safe Custody fee');
            }
            //Update will to CIF
            if(!String.isBlank(application.get(0).Will_Reg_Asset_update_In_CIF_Sys_Error__c) && application.get(0).Will_Reg_Asset_update_In_CIF_Sys_Error__c !=null && application.get(0).Registration_Status__c != 'Submitted'  && application.get(0).Registration_Status__c == 'Incomplete'){
                validity = 'Invalid';
                invalidComponents += '- Asset Updation in CIF :'+ application.get(0).Will_Reg_Asset_update_In_CIF_Sys_Error__c +' \r\n';
                System.debug('Update will to CIF');
            }
            //Send Communication 
            if(!String.isBlank(application.get(0).Will_Communication_Sent_Error__c) && application.get(0).Will_Communication_Sent_Error__c !=null && application.get(0).Registration_Status__c != 'Submitted'  && application.get(0).Registration_Status__c == 'Incomplete'){
                validity = 'Invalid';
                invalidComponents += '- Communication failed :'+ application.get(0).Will_Communication_Sent_Error__c +' \r\n';
                System.debug('Send Communication');
            }
            //Create asset n Liabilities
            if(!String.isBlank(application.get(0).Will_Asset_Liabilities_Created_Error__c) && application.get(0).Will_Asset_Liabilities_Created_Error__c !=null && application.get(0).Registration_Status__c != 'Submitted'  && application.get(0).Registration_Status__c == 'Incomplete'){
                validity = 'Invalid';
                invalidComponents += '- Asset N Liabilities :'+ application.get(0).Will_Asset_Liabilities_Created_Error__c +' \r\n';
                System.debug('Create asset n Liabilities');
            }
            //Create Tracker After Registration 
            if(!String.isBlank(application.get(0).Will_Registration_Tracker_Created_Error__c) && application.get(0).Will_Registration_Tracker_Created_Error__c !=null && application.get(0).Registration_Status__c != 'Submitted'  && application.get(0).Registration_Status__c == 'Incomplete'){
                validity = 'Invalid';
                invalidComponents += '- Tracker Creation After Registration:'+ application.get(0).Will_Registration_Tracker_Created_Error__c +' \r\n';
                System.debug('Create Tracker After Registration');
            }
            /************************************************************  Revision Errors Strats ***********************************************************/
            //Create get asset will  
            if(!String.isBlank(application.get(0).Revision_Get_Asset_from_Will_Error__c) && application.get(0).Revision_Get_Asset_from_Will_Error__c !=null && application.get(0).Registration_Status__c != 'Submitted'  && application.get(0).Registration_Status__c == 'Incomplete'){
                validity = 'Invalid';
                invalidComponents += '- Tracker Creation After Registration:'+ application.get(0).Revision_Get_Asset_from_Will_Error__c +' \r\n';
            }
            //Create Drafting Banking details  
            if(!String.isBlank(application.get(0).Revision_Drafting_Banking_Detail_Error__c) && application.get(0).Revision_Drafting_Banking_Detail_Error__c !=null && application.get(0).Registration_Status__c != 'Submitted'  && application.get(0).Registration_Status__c == 'Incomplete'){
                validity = 'Invalid';
                invalidComponents += '- Tracker Creation After Registration:'+ application.get(0).Revision_Drafting_Banking_Detail_Error__c +' \r\n';
            }
            //Create Banking details   
            if(!String.isBlank(application.get(0).Revision_Crete_Will_Banking_Detail_Error__c) && application.get(0).Revision_Crete_Will_Banking_Detail_Error__c !=null && application.get(0).Registration_Status__c != 'Submitted'  && application.get(0).Registration_Status__c == 'Incomplete'){
                validity = 'Invalid';
                invalidComponents += '- Tracker Creation After Registration:'+ application.get(0).Revision_Crete_Will_Banking_Detail_Error__c +' \r\n';
            }
            //Create Asset n liabilities   
            if(!String.isBlank(application.get(0).Revision_Asset_Liabilities_Created_Error__c) && application.get(0).Revision_Asset_Liabilities_Created_Error__c !=null && application.get(0).Registration_Status__c != 'Submitted'  && application.get(0).Registration_Status__c == 'Incomplete'){
                validity = 'Invalid';
                invalidComponents += '- Tracker Creation After Registration:'+ application.get(0).Revision_Asset_Liabilities_Created_Error__c +' \r\n';
            }
            //Update Will  
            if(!String.isBlank(application.get(0).Revision_Will_Update_Error__c) && application.get(0).Revision_Will_Update_Error__c !=null && application.get(0).Registration_Status__c != 'Submitted'  && application.get(0).Registration_Status__c == 'Incomplete'){
                validity = 'Invalid';
                invalidComponents += '- Tracker Creation After Registration:'+ application.get(0).Revision_Will_Update_Error__c +' \r\n';
            }
            //Create Tracker  
            if(!String.isBlank(application.get(0).Revision_Reg_Tracker_Created_Error__c) && application.get(0).Revision_Reg_Tracker_Created_Error__c !=null && application.get(0).Registration_Status__c != 'Submitted'  && application.get(0).Registration_Status__c == 'Incomplete'){
                validity = 'Invalid';
                invalidComponents += '- Tracker Creation After Registration:'+ application.get(0).Revision_Reg_Tracker_Created_Error__c +' \r\n';
            }
        }
        ErrorMessages.add(validity);
        ErrorMessages.add(invalidComponents);
        System.debug('############  ErrorMessages : '+ErrorMessages);
        return ErrorMessages;
    }  
    
    /**
    * Method that Get a single Account record 
    *
    * @param oppId - opportunity Id
    * 
    * @return Account record.
    */
    @AuraEnabled
    public static Account getAccountData(Id oppId) {
        Account account = new AccountsSelector().selectByOpportunityId(oppId);
        System.debug('getAccountData: ' + account);
        return account;
    }
    
    /**
    * Method that Get a single opportunity record 
    *
    * @param oppId - opportunity Id
    * 
    * @return Opportunity record.
    */
    @AuraEnabled
    public static Opportunity getOpportunityData(Id oppId) {
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId,1);
        System.debug('getOpportunityData: ' + opportunities);
        return opportunities.get(0);
    }
    
    /**
    * Method that Get a single Asset record 
    *
    * @param oppId - opportunity Id
    * 
    * @return Asset record.
    */
    @AuraEnabled
    public static Asset getAssetData(Id oppId) {
        System.debug('getAssetData');
        Account account = new AccountsSelector().selectByOpportunityId(oppId);
        System.debug(' getAssetData account: ' + account);
        List<Asset> assets =new AssetsSelector().selectAssetByAccId(account.Id);
        System.debug('getAssetData assets: ' + assets.get(0));
        if(assets.isEmpty()){
            return null;
        }
        else{
            return assets.get(0);
        }
    }
    
    /**
    * Method that Get a single Application record 
    *
    * @param oppId - opportunity Id
    * 
    * @return Application record.
    */
    @AuraEnabled
    public static Application__c getApplicationData(Id oppId) {        
        List<Application__c> application = new ApplicationsSelector().selectByOpportunityId(oppId);        
        return application.get(0);        
    }
    
    /**
    * Method that make a callout to Stock service to get a new will number
    * 
    * @param Opportunity -oppId
    * @param prodCategory
    * @param prodType
    * @param prodCode
    * @param siteCode
    * 
    * @return Stock number/Will Number
    */
    @AuraEnabled
    public static String getStockService(Id oppId,String channelP, String applicationP, String msgLanguageP, String msgTargetP, String finalMsgClassP, String finalMsgCodeP, String prodCategoryP, String prodTypeP, String prodCodeP, String siteCodeP){
        Integration_API__c integrationSettings = Sys_Utilities_Integration.getMultipleIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.WILLS_SYSTEM);
        Map<String, List<Integration_Service__c>> willsIntegrationServicesMap = Sys_Utilities_General.convertListToMapWithStringKey(integrationSettings.Integration_Services__r, StringConstants.FIELD_NAME_STRING);
        List<Application__c> application = new ApplicationsSelector().selectByOpportunityId(oppId);
        String traceP = traceDefault;
        if(application.size() > 0){
            traceP = application.get(0).StockServiceTrace__c;
        }
        HLallocateStockNumber_Resp_IB_v1 stockResponse = HLallocateStockNumber_IH_v1.hlAllocateStockNumber(channelP,applicationP,traceP,msgLanguageP,msgTargetP,finalMsgClassP,finalMsgCodeP,prodCategoryP,prodTypeP,prodCodeP,siteCodeP);
        if(stockResponse.statusCode== 200){
            System.debug('success in stock service:' +stockResponse.message + stockResponse.status+stockResponse.statusCode+stockResponse.stockNumber);
            Application__c app =new Application__c();
            app.Id=application.get(0).Id;
            app.Will_Stock_Confirmation__c=true;
            app.Will_Reg_Stock_Service_Error__c='';
            app.Registration_Status__c='Incomplete';
            update app;
            return stockResponse.stockNumber;
        } else{
            System.debug('Error in stock service:' +stockResponse.message);
            Application__c app =new Application__c();
            app.Id=application.get(0).Id;
            app.Will_Stock_Confirmation__c=false;
            app.Will_Reg_Stock_Service_Error__c=stockResponse.message;
            app.Registration_Status__c='Incomplete';
            update app;
            return 'false' ;
        }
    }
    
    /**
    * Method that Create Will record in SF 
    *
    * @param Opp - Opportunity
    * @param oppId - opportunity Id
    * @param Asse - Asset
    * 
    * @return String - Success	.
    */ 
    @AuraEnabled
    public static String createAssetInSf(opportunity opp,Id oppId,Asset asse){
        system.debug('Asset parameter:'+asse);
        Account account = new AccountsSelector().selectByOpportunityId(oppId);
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId,1);
        List<Application__c> application = new ApplicationsSelector().selectByOpportunityId(oppId);
        List<user> users = new UsersSelector().selectByOpportunityOwnerId(opportunities.get(0).OwnerId);
        List<OpportunityLineItem> OpportunityLineItem=new OpportunityLineItemsSelector().selectByOpportunityId(oppId); // must have product attached to opportunity 
        system.debug('account record: '+account);
        system.debug('opportunities record :'+opportunities.get(0));
        system.debug('application record: '+application.get(0));
        system.debug('users record :'+users.get(0));
        system.debug('OpportunityLineItem record:'+OpportunityLineItem.get(0));
        system.debug('Asset parameter:'+asse);
        String result;
        Asset assetP = Asse;
        try{
            asset a =new asset();
            a.SerialNumber=assetP.SerialNumber;
            a.Name=assetP.Name;
            a.RecordTypeId=assetRecordTypeMap.get('Will').getRecordTypeId();
            a.AccountId=account.Id;
            a.Opportunity__c=oppId;
            a.Preferred_Communication_Method__c=application.get(0).Preferred_Communication_Method__c;
            if(a.Preferred_Communication_Method__c=='Email'){
                a.Preferred_Email__c=application.get(0).Preferred_Email__c;   
            }else {
                a.Preferred_SMS__c=application.get(0).Preferred_SMS__c;  
            }
            a.Adviser_Code__c=users.get(0).Advisor_Code__c;
            a.Product2Id=OpportunityLineItem.get(0).Product2Id;
            Insert a;
            System.debug('Asset Created Successfully in SF: '+a);
            Application__c app =new Application__c();
            app.Id=application.get(0).Id;
            app.Will_Record_Created_In_SF__c=true;
            app.Will_Reg_Asset_creation_in_SF_Error__c='';
            update app;
            result='Success';   
        }
        catch(exception e){
            Application__c app =new Application__c();
            app.Id=application.get(0).Id;
            app.Will_Stock_Confirmation__c=false;
            app.Will_Record_Created_In_SF__c=false;
            app.Will_Reg_Asset_creation_in_SF_Error__c= 'Error:'+e;
            update app;
            system.debug('Error While Creating the Asset Record in SF :' +e);
            result='Failed'+e;
        }
        return result; 
    }
    
    /**
    * Method that create will in will system 
    *
    * @param willNoP - Asset Numer(SerialNumber) :Will Number
    * @Param cifKeyP - Cif Key
    *  
    * @return String.
    */
    @AuraEnabled
    public static string createAssetInWillSystem(Id oppId, String willNoP, String cifKeyP, String corpCodeP, Integer TransactionSiteP, Integer tellerNoP) {
        Integration_API__c integrationSettings = Sys_Utilities_Integration.getMultipleIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.WILLS_SYSTEM);
        System.debug('WILLS_SYSTEM integrationSettings' +integrationSettings);
        Map<String, List<Integration_Service__c>> willsIntegrationServicesMap = Sys_Utilities_General.convertListToMapWithStringKey(integrationSettings.Integration_Services__r, StringConstants.FIELD_NAME_STRING);
        System.debug('WILLS_SYSTEM willsIntegrationServicesMap' +willsIntegrationServicesMap);
        List<Application__c> application = new ApplicationsSelector().selectByOpportunityId(oppId);
        Account account = new AccountsSelector().selectByOpportunityId(oppId);
        List<Asset> asset = new AssetsSelector().selectAssetByAccId(account.Id);
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId,1);
        Site__c site = new SitesSelector().selectById(opportunities.get(0).Site__c);
        //domicileSiteP
        Integer domicileSiteP = Integer.valueof(site.Site_Code__c);
        //effectiveDateP
        Date d = Date.today();
        Integer effectiveDateP= Integer.valueOf(Datetime.newInstance(d.year(), d.month(), d.day()).format('yyyyMMdd'));
        System.debug('effectiveDateP' +effectiveDateP );
        CreateWillRecord_Resp_IB_v1 Response = CreateWillRecord_IH_v1.createRecord(willNoP,cifKeyP,domicileSiteP,corpCodeP,TransactionSiteP,tellerNoP,EffectiveDateP);
        system.debug('Response'+Response);
        if(Response.RC== '0'){
            System.debug('success in createWillRecord ' +Response.message + Response.status + Response.statusCode + Response.RCMessage + Response.WillNo);
            Application__c app =new Application__c();
            app.Id=application.get(0).Id;
            app.Will_Created_In_Will_System__c=true;
            app.Will_Reg_Asset_creation_in_Will_Sy_Error__c='';
            update app;
            return 'Success';
        } 
        else{
            Application__c app =new Application__c();
            app.Id=application.get(0).Id;
            app.Will_Created_In_Will_System__c=false;
            app.Will_Reg_Asset_creation_in_Will_Sy_Error__c= Response.RCMessage;
            update app;
            System.debug('Error in createWillRecord ' +Response.RCMessage);
            return Response.RCMessage ;
        }
    }
    
    /**
    * Method that call Create Tracker Service Application Recieved 
    *
    * @param willNoP - Asset Numer(SerialNumber) :Will Number
    * 
    * @return String.
    */
    @AuraEnabled
    public static string createTracker(Id oppId,String channel,String application,String willNo,String tstatus,String sstatus,String statCd,String filLoc,String prevId,String actionP,String comments,String branchCd) {
        List<Application__c> application1 = new ApplicationsSelector().selectByOpportunityId(oppId);
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId,1);
        List<user> users = new UsersSelector().selectByOpportunityOwnerId(opportunities.get(0).OwnerId);
        String trace = traceDefault;
        if(application1.size() > 0){
            trace = application1.get(0).TrackerTrace__c;
        }
        //Check for Lucy Ab number, if user is Lucy then BranchCd will be '7283' else default to '3232'
        if(Users.get(0).AB_Number__c=='ABLS109'){
            branchCd='7283';
        }
        //Efectivedate
        Date d = Date.today();
        string dateCreatedP= string.valueOf(Datetime.newInstance(d.year(), d.month(), d.day()).format('yyyyMMdd'));
        System.debug('dateCreatedP' +dateCreatedP );
        string dateCreated = dateCreatedP;
        //timecreated
        DateTime dT = System.now();
        String timeCreatedP = string.valueOf(dT.format('HHmm'));
        string timeCreated =timeCreatedP;  
        System.debug('timeCreated' +timeCreated );
        //UserId -AB Number
        string userId = Users.get(0).AB_Number__c;
        CreateTracker_Resp_IB_v1 CreateTrackerResponse = CreateTracker_IH_v1.createTracker(channel,application,trace,willNo,tstatus,dateCreated,timeCreated,userId,sstatus,statCd,filLoc,prevId,actionP,comments,branchCd);
        system.debug('CreateTrackerResponse'+CreateTrackerResponse);
        if(CreateTrackerResponse.awp200so != NULL){
            if( CreateTrackerResponse.awp200so.rc== '0'){
                System.debug('###########  Inside createTracker Service Controller $$$$$$$$$$ :');
                Application__c app =new Application__c();
                app.Id=application1.get(0).Id;
                app.Will_Initialise_Tracker_Create__c=true;
                app.Will_Initialise_Tracker_Created_Error__c='';
                update app;
                System.debug('success in createTracker Service :' + CreateTrackerResponse.awp200so.rcMessage);
                return 'Success';
            } else{
                System.debug('Error in createTracker Service :' + CreateTrackerResponse.awp200so.rcMessage);
                Application__c app =new Application__c();
                app.Id=application1.get(0).Id;
                app.Will_Initialise_Tracker_Create__c=false;
                app.Will_Initialise_Tracker_Created_Error__c= CreateTrackerResponse.awp200so.rcMessage;
                update app;
                return  CreateTrackerResponse.awp200so.rcMessage ;
            }
        }
        return null;
    }
    
    /**
    * Method that Gets  Will from Will System for Fresh Will
    *
    * @param willNoP - Asset Numer(SerialNumber) :Will Number
    * 
    * @return String .
    */
    @AuraEnabled
    public static string getAssetFromWillSystem(Id oppId,String willNoP) {   
        system.debug('  willNoP ' + willNoP);
        GetWillDetails_Resp_IB_v1 GetWillResponse = GetWillDetails_IH_v1.getWillDetails(willNoP);
        system.debug(' ###### GetWillResponse ' + GetWillResponse);
        string varData = JSON.serialize(GetWillResponse);
        return varData;
    }
    
    /**
    * Method that Update Will Details for Fresh Will
    * 
    * @param OppId - Opportunity Id
    * @param willNoP - Asset Numer(SerialNumber) :Will Number
    * 
    * @return String .
    */
    @AuraEnabled
    public static string UpdateWill(Id oppId, String willNoP, string GetWillResponse1) {
        system.debug(' Inside Update Apex GetWillResponse1 String: '+ GetWillResponse1);
        GetWillDetails_Resp_IB_v1 bean = new GetWillDetails_Resp_IB_v1();
        GetWillDetails_Resp_IB_v1 GetWillResponse = (GetWillDetails_Resp_IB_v1)bean.deserialize(GetWillResponse1, GetWillDetails_Resp_IB_v1.class);
        Account account = new AccountsSelector().selectByOpportunityId(oppId);
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId,1);
        List<Application__c> application = new ApplicationsSelector().selectByOpportunityId(oppId);
        String trace =traceDefault;
        if(application.size() > 0){
            trace = application.get(0).UpdateWillTrace__c;
        }
        List<user> users = new UsersSelector().selectByOpportunityOwnerId(opportunities.get(0).OwnerId);
        List<Asset> asset = new AssetsSelector().selectAssetNumber(willNoP);
        Employee__c adviser = new EmployeesSelector().selectById(opportunities.get(0).Adviser_Employee__c);
        Site__c site = new SitesSelector().selectById(opportunities.get(0).Site__c);
        system.debug('account record: '+account);
        system.debug('opportunities record :'+ opportunities.get(0));
        system.debug('application record: '+ application.get(0));
        system.debug('users record :'+ users.get(0));
        system.debug('Asset record:'+ asset.get(0));
        system.debug('advisor record:'+ adviser);
        system.debug('site record:'+ site);
        //Efectivedate
        Date d = Date.today();
        string dateCreatedP= string.valueOf(Datetime.newInstance(d.year(), d.month(), d.day()).format('yyyyMMdd'));
        string registrationdate = dateCreatedP;
        System.debug('registrationdate' + registrationdate );
        UpdateWillsDetails_Req_IB_v1 UpdateReqBean = new UpdateWillsDetails_Req_IB_v1();
        UpdateReqBean.channel='WILLS';
        UpdateReqBean.application='WILLS';
        UpdateReqBean.trace=trace;
        UpdateReqBean.functioni='DRAFT';
        UpdateReqBean.WillNo = willNoP;
        UpdateReqBean.languageCode = GetWillResponse.LanguageCode;
        UpdateReqBean.bigPrint = GetWillResponse.BigPrint;
        UpdateReqBean.cifkey = 	account.CIF__c;	
        UpdateReqBean.usrid = Users.get(0).AB_Number__c; 
        UpdateReqBean.testator = GetWillResponse.Testator;
        UpdateReqBean.testatrix = GetWillResponse.Testatrix;
        UpdateReqBean.deliverMethod = GetWillResponse.DeliverMethod;
        UpdateReqBean.advisorCode = adviser.Advisor_Code__c;
        UpdateReqBean.BrokerCode = adviser.Advisor_Code__c;
        if(GetWillResponse.SpecialistCode != null){
            UpdateReqBean.specialistCode = String.valueof(GetWillResponse.SpecialistCode);
        }
        UpdateReqBean.submittedBy = GetWillResponse.SubmittedBy;
        UpdateReqBean.submitterTelno = GetWillResponse.SubmitterTelno;
        UpdateReqBean.oldWillNo = GetWillResponse.OldWillNo;
        UpdateReqBean.oldFilingNumber = GetWillResponse.OldFilingNumber;
        UpdateReqBean.willFiled = GetWillResponse.WillFiled;
        UpdateReqBean.willLegal = GetWillResponse.WillLegal;
        UpdateReqBean.fillNo = GetWillResponse.FillNo;
        if(GetWillResponse.DateSigned != null){
            UpdateReqBean.dateSigned = String.valueof(GetWillResponse.DateSigned);
        }
        if(GetWillResponse.DateFiled != null){
            UpdateReqBean.dateFiled = String.valueof(GetWillResponse.DateFiled);
        }
        if(GetWillResponse.DateWithdrawn != null){
            UpdateReqBean.dateWithdrawn = String.valueof(GetWillResponse.DateWithdrawn);
        }
        UpdateReqBean.timeWithdrawn = '0';
        UpdateReqBean.reasonWithdrawn = GetWillResponse.ReasonWithdrawn;
        UpdateReqBean.withdrawnCode = GetWillResponse.WithdrawnCode;
        if(GetWillResponse.WithdrawUserId != null){
            UpdateReqBean.withdrawUserId = String.valueof(GetWillResponse.WithdrawUserId);
        }
        UpdateReqBean.referalReason = GetWillResponse.ReferalReason;
        UpdateReqBean.whoDied = GetWillResponse.WhoDied;
        if(GetWillResponse.DomicileSite != null){
            UpdateReqBean.domicileSite = String.valueof(GetWillResponse.DomicileSite) ; // site object code (Site_Code__c)
        }
        UpdateReqBean.corpCode = GetWillResponse.CorpCode;
        UpdateReqBean.transactionSite = GetWillResponse.TransactionSite;
        UpdateReqBean.tellerNo = '0';
        UpdateReqBean.effectiveDate = '20990401';
        if(GetWillResponse.CurrentBalance != null){
            UpdateReqBean.currentBalance = String.valueof(GetWillResponse.CurrentBalance); 
        }
        UpdateReqBean.productType = GetWillResponse.ProductType;
        UpdateReqBean.productStatus = 'OPEN';
        UpdateReqBean.branchCode = site.Site_Code__c ;  // site object code (Site_Code__c)
        if(GetWillResponse.DeceasedDate != null){
            UpdateReqBean.deceasedDate = String.valueof(GetWillResponse.DeceasedDate);
        }
        UpdateReqBean.registrationDate = registrationdate;
        UpdateReqBean.willStatus = GetWillResponse.WillStatus;
        UpdateReqBean.willError = GetWillResponse.WillError;
        UpdateReqBean.newAmendRevise = 'N' ;   //N- New , R-Revision  
        UpdateReqBean.willOrigin = GetWillResponse.WillOrigin;
        UpdateReqBean.acknowledgeLetter = GetWillResponse.AcknowledgeLetter;
        UpdateReqBean.trackerStatus = 'R';  //Registration
        String PricingFlag;
        if(application.get(0).Fees_Waived__c==true){
            PricingFlag='N';
        }else{
            PricingFlag='Y';
        }
        UpdateReqBean.pricingFlag = PricingFlag;  //Drafting fees charged or not ('Y' or 'N')
        if(adviser.Initials__c==null){
            UpdateReqBean.advisorName = adviser.Surname__c;
        }else {
            UpdateReqBean.advisorName = adviser.Initials__c + adviser.Surname__c;	
        }
        if(adviser.Initials__c==null){
            UpdateReqBean.brokerName = adviser.Surname__c;
        }else{
            UpdateReqBean.brokerName = adviser.Initials__c + adviser.Surname__c;	
        }
        UpdateReqBean.specialistName = GetWillResponse.SpecialistName;
        if(GetWillResponse.caseNo != null){
            UpdateReqBean.caseNo = String.valueof(GetWillResponse.caseNo);
        }
        if(GetWillResponse.SalaryNo != null){
            UpdateReqBean.salaryNo = String.valueof(GetWillResponse.SalaryNo);
        }
        if(GetWillResponse.DispatchDate != null){
            UpdateReqBean.dispatchDate = String.valueof(GetWillResponse.DispatchDate);
        }
        if(GetWillResponse.DraftingBranch != null){
            UpdateReqBean.draftingBranch = String.valueof(GetWillResponse.DraftingBranch);
        }
        UpdateReqBean.correction = GetWillResponse.Correction;
        UpdateReqBean.revisionDate = '0';
        UpdateReqBean.executorFeePlan = GetWillResponse.ExecutorFeePlan;
        if(GetWillResponse.FirstFileDate != null){
            UpdateReqBean.firstFileDate = String.valueof(GetWillResponse.FirstFileDate);
        }
        String safeCustodyFee;
        if(application.get(0).Safe_Custody_Is_Required__c=='Yes'){
            safeCustodyFee='Y';
        }else{
            safeCustodyFee='N';
        }
        UpdateReqBean.safeCustodyFee = safeCustodyFee;    //safe custody fees charged or not ('Y' or 'N') 
        UpdateReqBean.emergencyWill = GetWillResponse.EmergencyWill;
        if(GetWillResponse.DateReturned != null){
            UpdateReqBean.dateReturned = String.valueof(GetWillResponse.DateReturned);  
        }
        UpdateReqBean.standAlone = GetWillResponse.StandAlone;
        if(GetWillResponse.Date1stScfLetter != null){
            UpdateReqBean.date1stScfLetter = String.valueof(GetWillResponse.Date1stScfLetter); 
        }
        UpdateReqBean.eisDate = registrationdate;
        if(GetWillResponse.LeadCode != null){
            UpdateReqBean.leadCode = String.valueof(GetWillResponse.LeadCode);
        }
        UpdateReqBean.leadName = GetWillResponse.LeadName;
        UpdateReqBean.csaSent = GetWillResponse.CSASent;
        UpdateReqBean.trustIndicator = GetWillResponse.TrustIndicator;
        if(GetWillResponse.SpecialBequestVal != null){
            UpdateReqBean.specialBequestVal = String.valueof(GetWillResponse.SpecialBequestVal);
        }
        UpdateReqBean.casaNo = account.CASA_Reference_Number__c;
        String CasaDateO;
        //CasaDate
        if(account.CASA_Screening_Date__c != null){
            Date dt = account.CASA_Screening_Date__c;
            string casaDateP= string.valueOf(Datetime.newInstance(dt.year(), dt.month(), dt.day()).format('yyyyMMdd'));
            CasaDateO = casaDateP;
        }
        if(account.CASA_Screening_Date__pc != null){
            date dtpc = account.CASA_Screening_Date__pc;
            string casaDatepc= string.valueOf(Datetime.newInstance(dtpc.year(), dtpc.month(), dtpc.day()).format('yyyyMMdd'));
            CasaDateO = casaDatepc;
        }
        //string casaDateP= string.valueOf(Datetime.newInstance(dt.year(), dt.month(), dt.day()).format('yyyyMMdd'));
        string casaDate = CasaDateO;
        System.debug('casaDate' +casaDate );
        UpdateReqBean.casaDate = casaDate;
        String CasaIndicator ='C';
        if(account.CASA_Screening_Status__c=='Approved'){
            CasaIndicator='C';
        }else{
            CasaIndicator='D';
        }
        UpdateReqBean.casaIndicator = CasaIndicator;  // check status -> (approved -'C', failed -'D')
        UpdateReqBean.feePaid = GetWillResponse.FeePaid; 
        if(GetWillResponse.AmountDue != null){
            UpdateReqBean.amountDue = String.valueof(GetWillResponse.AmountDue);
        }
        UpdateReqBean.payDate = '0';
        System.debug('#### UpdateReqBean ### : ' +UpdateReqBean);
        UpdateWillsDetails_Resp_IB_v1 UpdateWillResponse = UpdateWillsDetails_IH_v1.updateWillsDetails(UpdateReqBean);
        if(UpdateWillResponse.rc== '0'){
            Application__c app1 =new Application__c();
            app1.Id=application.get(0).Id;
            app1.Will_Updated_In_Will_System__c=true;
            app1.Will_Reg_Asset_update_in_Will_Sys_Error__c='';
            update app1;
            return 'Success';
        } else{
            Application__c app1 =new Application__c();
            app1.Id=application.get(0).Id;
            app1.Will_Updated_In_Will_System__c=false;
            app1.Will_Reg_Asset_update_in_Will_Sys_Error__c=UpdateWillResponse.RCMessage;
            update app1;
            return UpdateWillResponse.RCMessage  ;
        }    
    }
    
    /**
    * Method that create Debit Order Instruction
    *
    * @param willNoP - Asset Numer(SerialNumber) :Will Number
    * @Param cifKeyP - Cif Key
    *  
    * @return String .
    */
    @AuraEnabled
    public static String debitOrderInstruction(Id oppId,String willNoP) {
        Opportunity opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId).get(0);
        Account account = new AccountsSelector().selectByOpportunityId(oppId);
        List<Application__c> application = new ApplicationsSelector().selectByOpportunityId(oppId);
        List<Payment_Plan__c> paymentPlan = new  PaymentPlansSelector().selectByTypeByMethodByApplicationId(application.get(0).Id, 'Will Drafting Fee', 1, 'Debit Instruction');
        System.debug('Drafting fee payment plan' +paymentPlan );
        if(paymentPlan.size() > 0){
            Integer branchCode = Integer.valueof(paymentPlan.get(0).Branch_Code__c);
            String branchName = paymentPlan.get(0).Branch_Name__c;
            String bankName = paymentPlan.get(0).Bank_Name__c;
            String siteCode = '8443';  // check on this 
            String accountType = paymentPlan.get(0).Account_Type__c;
            String accountNumber = paymentPlan.get(0).Account_Number__c;
            Integer FeeCode= Integer.valueof(paymentPlan.get(0).Fee_Code__c);
            Decimal Amount=paymentPlan.get(0).Amount__c;
            String clientNameP = account.Name;
            Date d = Date.today();
            string dateCreatedP= string.valueOf(Datetime.newInstance(d.year(), d.month(), d.day()).format('MM/dd/yyyy'));
            System.debug('dateCreatedP' +dateCreatedP );
            string PaymentDate = dateCreatedP;
            DebitOrderInstruction_Resp_IB_v1 DebitOrderInstructionResponse = DebitOrderInstruction_IH_v1.debitOrderInstruction(willNoP,FeeCode,Amount,PaymentDate,BankName,BranchCode,BranchName,AccountNumber,AccountType);
            system.debug('DebitOrderInstructionResponse'+DebitOrderInstructionResponse);
            if(DebitOrderInstructionResponse.RC== 0){
                Application__c app =new Application__c();
                app.Id=application.get(0).Id;
                app.Will_Drafting_Banking_Detail_Created__c=true;
                app.Will_Drafting_Banking_Detail_Error__c='';
                update app;
                return 'Success';
            } else if(DebitOrderInstructionResponse.statusCode != 200){
                Application__c app =new Application__c();
                app.Id=application.get(0).Id;
                app.Will_Drafting_Banking_Detail_Created__c=false;
                app.Will_Drafting_Banking_Detail_Error__c=DebitOrderInstructionResponse.status;
                update app;
                return 'ServiceDown' ;
            }
            else  {
                Application__c app =new Application__c();
                app.Id=application.get(0).Id;
                app.Will_Drafting_Banking_Detail_Created__c=false;
                app.Will_Drafting_Banking_Detail_Error__c=DebitOrderInstructionResponse.RCMessage;
                update app;
                return DebitOrderInstructionResponse.RCMessage ;
            }    
        }
        else {
            return 'BranchPaymentDone' ;
        }
    } 
    
    /**
    * Method that create Will banking detail 
    *
    * @param willNoP - Asset Numer(SerialNumber) :Will Number
    * @Param cifKeyP - Cif Key 
    * 
    * @return String .
    */
    @AuraEnabled
    public static String createWillBankingDetail(Id oppId,String willNoP) {
        Opportunity opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId).get(0);
        Account account = new AccountsSelector().selectByOpportunityId(oppId);
        List<Application__c> application = new ApplicationsSelector().selectByOpportunityId(oppId);
        List<Payment_Plan__c> paymentPlan = new  PaymentPlansSelector().selectByTypeByApplicationId(application.get(0).Id, 'Will Safe Custody Fee', 1);
        System.debug('Safe custody fee payment plan' +paymentPlan );
        String branchCodeP = String.valueof(paymentPlan.get(0).Branch_Code__c);
        String branchNameP = paymentPlan.get(0).Branch_Name__c;
        String bankNameP = paymentPlan.get(0).Bank_Name__c;
        String siteCodeP = '8443';
        String accountTypeP = paymentPlan.get(0).Account_Type__c;
        String accountNumberP = paymentPlan.get(0).Account_Number__c;
        String clientNameP = account.Name;
        string effectiveDateP='20990401';
        WillBankingDetails_IB_v1 createWillBankingResponse = CreateWillBankingDetails_IH_v1.createWillBankingDetails(willNoP,branchCodeP,branchNameP,bankNameP,siteCodeP,accountTypeP,accountNumberP, clientNameP, effectiveDateP);
        system.debug('createWillBankingResponse'+createWillBankingResponse);
        if(createWillBankingResponse.BankingDetailsResponse.RC== '0'){
            Application__c app =new Application__c();
            app.Id=application.get(0).Id;
            app.Will_Banking_Detail_Created__c=true;
            app.Will_Reg_Crete_Will_Banking_Detail_Error__c='';
            update app;
            return 'Success';
        } else if(createWillBankingResponse.BankingDetailsResponse.RCMessage.contains('WILL ALREADY IN SCF')){
            Application__c app =new Application__c();
            app.Id=application.get(0).Id;
            app.Will_Banking_Detail_Created__c=true;
            app.Will_Reg_Crete_Will_Banking_Detail_Error__c='';
            update app;
            return 'AlreadyExists';
        }else{
            Application__c app =new Application__c();
            app.Id=application.get(0).Id;
            app.Will_Banking_Detail_Created__c=false;
            app.Will_Reg_Crete_Will_Banking_Detail_Error__c=createWillBankingResponse.BankingDetailsResponse.RCMessage;
            update app;
            return createWillBankingResponse.BankingDetailsResponse.RCMessage ;
        }
    }
    
    /**
    * Method that Update will Number in CIF 
    *
    * @param willNoP - Asset Numer(SerialNumber) :Will Number
    * @Param cifKeyP - Cif Key 
    * 
    * @return String .
    */
    
    @AuraEnabled
    public static String updateWillToCIF(Id oppId,string clientCodeP, string accountNoP,string siteAccOpenP, string tellerNoP, string productP, string srcOfFnds2P, string srcOfFnds3P, string srcOfFnds4P, string srcOfFnds5P, string sec129DeliveryAddrP) {
        List<Application__c> application = new ApplicationsSelector().selectByOpportunityId(oppId);
        Account account = new AccountsSelector().selectByOpportunityId(oppId);
        Date d = Date.today();
        string dateCreatedP= string.valueOf(Datetime.newInstance(d.year(), d.month(), d.day()).format('yyyyMMdd'));
        System.debug('dateCreatedP' +dateCreatedP );
        string dateAccOpenP = dateCreatedP;
        string casaRefNumP= account.CASA_Reference_Number__c;
        string srcOfFnds1P='20';
        AddAccountToPortfolio_Resp_IB_v1 cifResponse = AddAccountToPortfolio_IH_v1.AddAccountToPortfolio(clientCodeP,accountNoP,dateAccOpenP,siteAccOpenP,tellerNoP,productP,casaRefNumP,srcOfFnds1P,srcOfFnds2P,srcOfFnds3P,srcOfFnds4P,srcOfFnds5P,sec129DeliveryAddrP);
        system.debug('cifResponse'+cifResponse);
        if(cifResponse.statusCode== 200){
            Application__c app =new Application__c();
            app.Id=application.get(0).Id;
            app.Will_Update_To_CIF__c=true;
            app.Will_Reg_Asset_update_In_CIF_Sys_Error__c='';
            update app;
            return 'Success';
        } else{
            Application__c app =new Application__c();
            app.Id=application.get(0).Id;
            app.Will_Update_To_CIF__c=false;
            app.Will_Reg_Asset_update_In_CIF_Sys_Error__c=cifResponse.status;
            update app;
            return cifResponse.status ;
        }
    }
    
    /**
    * Method that send Communication to advisor and Client    *
    * 
    * @Param oppId - opportunity Id
    * 
    * @return String .
    */    
    @AuraEnabled
    public static String sendWillRegCommunication(Id oppId) {
        system.debug('<<<<< sendWillRegCommunication Start Datetime : '+ DateTime.now());
        List<Application__c> application = new ApplicationsSelector().selectByOpportunityId(oppId);
        String message;
        Application__c app =new Application__c();
        app.Id=application.get(0).Id;
        app.Will_Communication_Sent_Error__c = null;
        try{
            WillsCommunicationsHandler.sendWillRegisteredCommunication(oppId);
            message = 'Success';
            app.Will_Communication_Sent__c=true;
        }
        catch(exception e){
            app.Will_Communication_Sent_Error__c = e.getMessage();
            app.Will_Communication_Sent__c=false;
            if(e.getMessage() == 'SendEmail failed. First exception on row 0; first error: REQUIRED_FIELD_MISSING, Missing targetObjectId with template: []'){
                message = 'The Account or Contact is missing and email address. Please rectify and try again.';
            } else {
                message = e.getMessage();
            }            
            System.debug('Error in sending Communication: '+e.getMessage());
        }
        system.debug('<<<<< Message : '+ message);
        system.debug('<<<<< sendWillRegCommunication Finish Datetime : '+ DateTime.now());
        update app;
        return message;
    }
    
    /**
    * Method that create asset and liabilities
    *
    * @param willNoP - Asset Numer(SerialNumber) :Will Number
    * @Param cifKeyP - Cif Key
    * 
    * @return String .
    */    
    @AuraEnabled
    public static String createAssetLiabilities(Id oppId,string willNoP) {
        List<Application__c> application = new ApplicationsSelector().selectByOpportunityId(oppId);
        Opportunity opportunity = new OpportunitiesSelector().selectByActivityId(oppId, 1);
        List<Financial_Needs_Analysis__c> fna = new FinancialNeedsAnalysisSelector().selectLatestById(opportunity.Financial_Needs_Analysis__c, 1);
        List<OpportunityLineItem> opportunityLineItem = new  OpportunityLineItemsSelector().selectByOpportunityId(oppId);
        System.debug('Financial_Needs_Analysis__c FNA :'+ fna);
        CreateAssetsLiabilities_Req_IB_v1 reqBean = new CreateAssetsLiabilities_Req_IB_v1();
        reqBean.operation = '';
        reqbean.WillNo=willNoP;
        if(!Test.isRunningTest()){
            reqbean.OtherAssTestator=String.valueof(fna.get(0).Assets__c.round(System.RoundingMode.CEILING)); //single 
            reqbean.OtherLTestator= String.valueof(fna.get(0).Liabilities__c.round(System.RoundingMode.CEILING)); //single
        }else{
            reqbean.OtherAssTestator='0';
            reqbean.OtherLTestator='0';     
        }
        reqbean.Assets='Y';
        reqBean.FarmingTestator =  '0';
        reqBean.FarmingTestatrix =  '0';
        reqBean.FixedPropTestator =  '0';
        reqBean.FixedPropTestatrix =  '0';
        reqBean.MineralTestator =  '0';
        reqBean.MineralTestatrix =  '0';
        reqBean.MovAssetsTestator =  '0';
        reqBean.MovAssetsTestatrix =  '0';
        reqBean.BusIntTestator =  '0';
        reqBean.BusIntTestatrix =  '0';
        reqBean.LiquidAssTestator =  '0';
        reqBean.LiquidAssTestatrix =  '0';
        reqBean.AssetsPayTestator =  '0';
        reqBean.AssetsPayTestatrix =  '0';
        reqBean.OtherAssTestatrix =  '0';
        reqBean.Liabilities =  'Y';
        reqBean.MortgaugeTestator =  '0';
        reqBean.MortgaugeTestatrix =  '0';
        reqBean.OverDraftTestator =  '0';
        reqBean.OverDraftTestatrix =  '0';
        reqBean.CreditTestator =  '0';
        reqBean.CreditTestatrix =  '0';
        reqBean.TaxTestator =  '0';
        reqBean.TaxTestatrix =  '0';
        reqBean.SuretyTestator =  '0';
        reqBean.SuretyTestatrix =  '0';
        reqBean.LoanLTestator='0';
        reqBean.LoanLTestatrix =  '0';
        reqBean.OtherLTestatrix =  '0';
        reqBean.Assurance =  'N';
        reqBean.MortgageAssTestator =  '0';
        reqBean.MortgageAssTestatrix =  '0';
        reqBean.OutCededAssTestator =  '0';
        reqBean.OutCededAssTestatrix =  '0';
        reqBean.AssetAmt =  '0';
        reqBean.LiabilAmt =  '0';
        reqBean.FeeCode =  opportunityLineItem.get(0).ProductCode;
        String feeDescription = (opportunityLineItem.get(0).Name).substringAfter('-');
        feeDescription = feeDescription.trim();
        reqBean.FeeDescription = feeDescription;
        reqBean.FeeAmount = String.valueof(opportunityLineItem.get(0).UnitPrice);
        System.debug('reqBean :'+reqBean);       
        CreateAssetsLiabilities_Resp_IB_v1 responseBean = CreateAssetsLiabilities_IH_v1.createAssetsLiability(reqBean);
        System.debug('Create Assets Liabilities responseBean : '+ responseBean);
        if(responseBean.RC== 0){
            Application__c app =new Application__c();
            app.Id=application.get(0).Id;
            app.Will_Asset_Liabilities_Created__c=true;
            app.Will_Asset_Liabilities_Created_Error__c='';
            update app;
            return 'Success';
        } else if(responseBean.statusCode != 200 ){
            Application__c app =new Application__c();
            app.Id=application.get(0).Id;
            app.Will_Asset_Liabilities_Created__c=false;
            app.Will_Asset_Liabilities_Created_Error__c=responseBean.message;
            update app;
            return responseBean.message;
        } else{
            Application__c app =new Application__c();
            app.Id=application.get(0).Id;
            app.Will_Asset_Liabilities_Created__c=false;
            app.Will_Asset_Liabilities_Created_Error__c=responseBean.RCMessage;
            update app;
            return responseBean.RCMessage ;
        }
    }
    
    /**
    * Method that call Create Tracker Service Registration Done 
    *
    * @param willNoP - Asset Numer(SerialNumber) :Will Number
    * 
    * @return String.
    */
    @AuraEnabled
    public static string createRegistrationTracker(Id oppId,String channel,String application,String willNo,String tstatus,String sstatus,String statCd,String filLoc,String prevId,String actionP,String comments,String branchCd) {
        List<Application__c> application1 = new ApplicationsSelector().selectByOpportunityId(oppId);
        String trace = traceDefault;
        if(application1.size() > 0){
            trace = application1.get(0).TrackerTrace__c;
        }
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId,1);
        List<user> users = new UsersSelector().selectByOpportunityOwnerId(opportunities.get(0).OwnerId);
        if(Users.get(0).AB_Number__c=='ABLS109'){
            branchCd='7283';
        }
        Date d = Date.today();
        string dateCreatedP= string.valueOf(Datetime.newInstance(d.year(), d.month(), d.day()).format('yyyyMMdd'));
        System.debug('dateCreatedP' +dateCreatedP );
        string dateCreated = dateCreatedP;
        DateTime dT = System.now();
        String timeCreatedP = string.valueOf(dT.format('HHmm'));
        string timeCreated =timeCreatedP;  
        System.debug('timeCreated' +timeCreated );
        string userId = Users.get(0).AB_Number__c;
        CreateTracker_Resp_IB_v1 CreateTrackerResponse = CreateTracker_IH_v1.createTracker(channel,application,trace,willNo,tstatus,dateCreated,timeCreated,userId,sstatus,statCd,filLoc,prevId,actionP,comments,branchCd);
        system.debug('CreateTrackerResponse'+CreateTrackerResponse);
        if(CreateTrackerResponse.awp200so != NULL){
            if(CreateTrackerResponse.awp200so.rc== '0'){
                Application__c app =new Application__c();
                app.Id=application1.get(0).Id;
                app.Will_Registration_Tracker_Created__c=true;
                app.Registration_Status__c='Submitted';
                app.Will_Registration_Tracker_Created_Error__c='';
                update app;
                Opportunity op=new Opportunity();
                op.id=oppId;
                op.StageName='Drafting';
                update op;
                System.debug('success in createTracker Service :' + CreateTrackerResponse.awp200so.rcMessage);
                return 'Success';
            } 
            else
            {
                System.debug('Error in createTracker Service :' + CreateTrackerResponse.awp200so.rcMessage);
                Application__c app =new Application__c();
                app.Id=application1.get(0).Id;
                app.Will_Registration_Tracker_Created__c=false;
                app.Will_Registration_Tracker_Created_Error__c= CreateTrackerResponse.awp200so.rcMessage;
                update app;
                return  CreateTrackerResponse.awp200so.rcMessage ;
            }
        }
        return null;  
    }
    
    /*#####################################################   REVISION STARTS   ##################################################*/
    
    /**
    * Method that create Debit Order Instruction -Revision
    * @param oppId -  Opportunity Id
    * @param willNoP - Asset Numer(SerialNumber) :Will Number
    * 
    * @return String .
    */
    @AuraEnabled
    public static String revisionDebitOrderInstruction(Id oppId,String willNoP) {
        Opportunity opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId).get(0);
        Account account = new AccountsSelector().selectByOpportunityId(oppId);
        List<Application__c> application = new ApplicationsSelector().selectByOpportunityId(oppId);
        List<Payment_Plan__c> paymentPlan = new  PaymentPlansSelector().selectByTypeByMethodByApplicationId(application.get(0).Id, 'Will Drafting Fee', 1, 'Debit Instruction');
        System.debug('Drafting fee payment plan' +paymentPlan );
        if(paymentPlan.size() > 0){
            Integer branchCode = Integer.valueof(paymentPlan.get(0).Branch_Code__c);
            String branchName = paymentPlan.get(0).Branch_Name__c;
            String bankName = paymentPlan.get(0).Bank_Name__c;
            String siteCode = '8443';  // check on this 
            String accountType = paymentPlan.get(0).Account_Type__c;
            String accountNumber = paymentPlan.get(0).Account_Number__c;
            Integer FeeCode= Integer.valueof(paymentPlan.get(0).Fee_Code__c);
            Decimal Amount=paymentPlan.get(0).Amount__c;
            String clientNameP = account.Name;
            Date d = Date.today();
            string dateCreatedP= string.valueOf(Datetime.newInstance(d.year(), d.month(), d.day()).format('MM/dd/yyyy'));
            System.debug('dateCreatedP' +dateCreatedP );
            string PaymentDate = dateCreatedP;
            DebitOrderInstruction_Resp_IB_v1 revisionDebitOrderInstructionResponse = DebitOrderInstruction_IH_v1.debitOrderInstruction(willNoP,FeeCode,Amount,PaymentDate,BankName,BranchCode,BranchName,AccountNumber,AccountType);
            system.debug('revisionDebitOrderInstructionResponse' + revisionDebitOrderInstructionResponse);
            if(revisionDebitOrderInstructionResponse.RC== 0){
                Application__c app =new Application__c();
                app.Id=application.get(0).Id;
                app.Revision_Drafting_Banking_Detail_Created__c=true;
                app.Revision_Drafting_Banking_Detail_Error__c='';
                update app;
                return 'Success';
            } else{
                Application__c app =new Application__c();
                app.Id=application.get(0).Id;
                app.Revision_Drafting_Banking_Detail_Created__c=false;
                app.Revision_Drafting_Banking_Detail_Error__c=revisionDebitOrderInstructionResponse.RCMessage;
                update app;
                return revisionDebitOrderInstructionResponse.RCMessage ;
            }    
        } else {
            return 'BranchPaymentDone' ;
        }
    }  
    
    /**
    * Method that Gets Will banking Detail for Revision
    * @param oppId - Opportunity Id
    * @param willNoP - Asset Numer(SerialNumber) :Will Number
    * 
    * @return String .
    */
    @AuraEnabled
    public static string revisionGetWillBankingDetail(Id oppId,String willNoP) {
        List<Application__c> application = new ApplicationsSelector().selectByOpportunityId(oppId);
        WillBankingDetails_IB_v1 revisionGetWillBankingResponse = GetWillBankingDetails_IH_v1.getWillBankingDetails(willNoP);
        system.debug('*** revisionGetWillBankingResponse =' + revisionGetWillBankingResponse);
        string ret;
        if(revisionGetWillBankingResponse.BankingDetailsResponse.RC == '0'){
            Application__c app =new Application__c();
            app.Id=application.get(0).Id;
            app.Revision_Will_Banking_Detail_Created__c=true;
            app.Revision_Crete_Will_Banking_Detail_Error__c='';
            update app;
            ret= 'Success';
        }else {
            Application__c app =new Application__c();
            app.Id=application.get(0).Id;
            app.Revision_Will_Banking_Detail_Created__c= false;
            app.Revision_Crete_Will_Banking_Detail_Error__c=revisionGetWillBankingResponse.BankingDetailsResponse.RCMessage;
            update app;
            ret='Failed';
        }
        return ret;
    }
    
    /**
    * Method that Update Will banking Detail for SCF- Revision
    * @param oppId - Opportunity Id
    * @param willNoP - Asset Numer(SerialNumber) :Will Number
    * 
    * @return String .
    */    
    @AuraEnabled
    public static string revisionUpdateWillbankingDetail(Id oppId,String willNoP) {
        Opportunity opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId).get(0);
        Account account = new AccountsSelector().selectByOpportunityId(oppId);
        List<Application__c> application = new ApplicationsSelector().selectByOpportunityId(oppId);
        List<Payment_Plan__c> paymentPlan = new  PaymentPlansSelector().selectByTypeByApplicationId(application.get(0).Id, 'Will Safe Custody Fee', 1);
        System.debug('Safe custody fee payment plan' +paymentPlan );
        String branchCodeP = String.valueof(paymentPlan.get(0).Branch_Code__c);
        String branchNameP = paymentPlan.get(0).Branch_Name__c;
        String bankNameP = paymentPlan.get(0).Bank_Name__c;
        String siteCodeP = '8443';
        String accountTypeP = paymentPlan.get(0).Account_Type__c;
        String accountNumberP = paymentPlan.get(0).Account_Number__c;
        String clientNameP = account.Name;
        Date d = Date.today();
        string dateCreatedP= string.valueOf(Datetime.newInstance(d.year(), d.month(), d.day()).format('yyyyMMdd'));
        System.debug('dateCreatedP' +dateCreatedP );
        string effectiveDateP = dateCreatedP;
        WillBankingDetails_IB_v1 revisionUpdateWillBankingResponse = UpdateWillBankingDetails_IH_v1.updateWillBankingDetails(willNoP,branchCodeP,bankNameP,siteCodeP,branchNameP,accountTypeP,accountNumberP, clientNameP, effectiveDateP);
        system.debug('revisionUpdateWillBankingResponse'+revisionUpdateWillBankingResponse);
        if(revisionUpdateWillBankingResponse.BankingDetailsResponse.RC== '0'){
            return 'Success';
        }else{
            return revisionUpdateWillBankingResponse.BankingDetailsResponse.RCMessage ;
        }    
    }
    
    /**
    * Method that create Will banking detail for SCF -Revision
    *
    * @param willNoP - Asset Numer(SerialNumber) :Will Number
    * @Param cifKeyP - Cif Key
    * 
    * @return String .
    */
    @AuraEnabled
    public static String revisionCreateWillBankingDetail(Id oppId,String willNoP) {
        Opportunity opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId).get(0);
        Account account = new AccountsSelector().selectByOpportunityId(oppId);
        List<Application__c> application = new ApplicationsSelector().selectByOpportunityId(oppId);
        List<Payment_Plan__c> paymentPlan = new  PaymentPlansSelector().selectByTypeByApplicationId(application.get(0).Id, 'Will Safe Custody Fee', 1);
        System.debug('Safe custody fee payment plan' +paymentPlan );
        String branchCodeP = String.valueof(paymentPlan.get(0).Branch_Code__c);
        String branchNameP = paymentPlan.get(0).Branch_Name__c;
        String bankNameP = paymentPlan.get(0).Bank_Name__c;
        String siteCodeP = '8443';
        String accountTypeP = paymentPlan.get(0).Account_Type__c;
        String accountNumberP = paymentPlan.get(0).Account_Number__c;
        String clientNameP = account.Name;
        Date d = Date.today();
        string dateCreatedP= string.valueOf(Datetime.newInstance(d.year(), d.month(), d.day()).format('yyyyMMdd'));
        System.debug('dateCreatedP' +dateCreatedP );
        string effectiveDateP = dateCreatedP;
        WillBankingDetails_IB_v1 createWillBankingResponse = CreateWillBankingDetails_IH_v1.createWillBankingDetails(willNoP,branchCodeP,branchNameP,bankNameP,siteCodeP,accountTypeP,accountNumberP, clientNameP, effectiveDateP);
        system.debug('createWillBankingResponse'+createWillBankingResponse);
        if(createWillBankingResponse.BankingDetailsResponse.RC== '0'){
            Application__c app =new Application__c();
            app.Id=application.get(0).Id;
            app.Revision_Will_Banking_Detail_Created__c=true;
            app.Revision_Crete_Will_Banking_Detail_Error__c='';
            update app;
            return 'Success';
        }else{
            Application__c app =new Application__c();
            app.Id=application.get(0).Id;
            app.Revision_Will_Banking_Detail_Created__c=false;
            app.Revision_Crete_Will_Banking_Detail_Error__c=createWillBankingResponse.BankingDetailsResponse.RCMessage;
            update app;
            return createWillBankingResponse.BankingDetailsResponse.RCMessage ;
        }
    }        
    
    /**
    * Method that create /Update  asset and liabilities -Revision
    *
    * @param willNoP - Asset Numer(SerialNumber) :Will Number
    * @Param cifKeyP - Cif Key 
    * 
    * @return String .
    */    
    @AuraEnabled
    public static String revisionCreateAssetLiabilities(Id oppId,string willNoP) {
        List<Application__c> application = new ApplicationsSelector().selectByOpportunityId(oppId);
        Opportunity opportunity = new OpportunitiesSelector().selectByActivityId(oppId, 1);
        List<Financial_Needs_Analysis__c> fna = new FinancialNeedsAnalysisSelector().selectLatestById(opportunity.Financial_Needs_Analysis__c, 1);
        List<OpportunityLineItem> opportunityLineItem = new  OpportunityLineItemsSelector().selectByOpportunityId(oppId);
        System.debug('Financial_Needs_Analysis__c FNA :'+ fna);
        CreateAssetsLiabilities_Req_IB_v1 reqBean = new CreateAssetsLiabilities_Req_IB_v1();
        reqBean.operation = '';
        reqbean.WillNo=willNoP;
        if(!Test.isRunningTest()){
            reqbean.OtherAssTestator=String.valueof(fna.get(0).Assets__c.round(System.RoundingMode.CEILING)); //single 
            reqbean.OtherLTestator= String.valueof(fna.get(0).Liabilities__c.round(System.RoundingMode.CEILING)); //single
        }else{
            reqbean.OtherAssTestator='0';
            reqbean.OtherLTestator='0';     
        }
        reqbean.Assets='Y';
        reqBean.FarmingTestator =  '0';
        reqBean.FarmingTestatrix =  '0';
        reqBean.FixedPropTestator =  '0';
        reqBean.FixedPropTestatrix =  '0';
        reqBean.MineralTestator =  '0';
        reqBean.MineralTestatrix =  '0';
        reqBean.MovAssetsTestator =  '0';
        reqBean.MovAssetsTestatrix =  '0';
        reqBean.BusIntTestator =  '0';
        reqBean.BusIntTestatrix =  '0';
        reqBean.LiquidAssTestator =  '0';
        reqBean.LiquidAssTestatrix =  '0';
        reqBean.AssetsPayTestator =  '0';
        reqBean.AssetsPayTestatrix =  '0';
        reqBean.OtherAssTestatrix =  '0';
        reqBean.Liabilities =  'Y';
        reqBean.MortgaugeTestator =  '0';
        reqBean.MortgaugeTestatrix =  '0';
        reqBean.OverDraftTestator =  '0';
        reqBean.OverDraftTestatrix =  '0';
        reqBean.CreditTestator =  '0';
        reqBean.CreditTestatrix =  '0';
        reqBean.TaxTestator =  '0';
        reqBean.TaxTestatrix =  '0';
        reqBean.SuretyTestator =  '0';
        reqBean.SuretyTestatrix =  '0';
        reqBean.LoanLTestator='0';
        reqBean.LoanLTestatrix =  '0';
        reqBean.OtherLTestatrix =  '0';
        reqBean.Assurance =  'N';
        reqBean.MortgageAssTestator =  '0';
        reqBean.MortgageAssTestatrix =  '0';
        reqBean.OutCededAssTestator =  '0';
        reqBean.OutCededAssTestatrix =  '0';
        reqBean.AssetAmt =  '0';
        reqBean.LiabilAmt =  '0';
        reqBean.FeeCode =  opportunityLineItem.get(0).ProductCode;
        String feeDescription = (opportunityLineItem.get(0).Name).substringAfter('-');
        feeDescription = feeDescription.trim();
        reqBean.FeeDescription = feeDescription;
        reqBean.FeeAmount = String.valueof(opportunityLineItem.get(0).UnitPrice);
        System.debug('reqBean :'+reqBean);       
        CreateAssetsLiabilities_Resp_IB_v1 revisionResponseBean = CreateAssetsLiabilities_IH_v1.createAssetsLiability(reqBean);
        System.debug('Create Assets Liabilities revisionResponseBean : '+ revisionResponseBean);
        if(revisionResponseBean.RC== 0){
            Application__c app =new Application__c();
            app.Id=application.get(0).Id;
            app.Revision_Asset_Liabilities_Created_Error__c='';
            update app;
            return 'Success';
        } else if(revisionResponseBean.statusCode != 200 ){
            Application__c app =new Application__c();
            app.Id=application.get(0).Id;
            app.Revision_Asset_Liabilities_Created_Error__c=revisionResponseBean.message;
            update app;
            return revisionResponseBean.message ;
        } else{
            Application__c app =new Application__c();
            app.Id=application.get(0).Id;
            app.Revision_Asset_Liabilities_Created_Error__c=revisionResponseBean.RCMessage;
            update app;
            return revisionResponseBean.RCMessage ;
        }
    } 
    
    /**
    * Method that Gets  Will from Will System for Revision
    *
    * @param willNoP - Asset Numer(SerialNumber) :Will Number
    * 
    * @return String .
    */
    @AuraEnabled
    public static string revisionGetAssetFromWillSystem(Id oppId,String willNoP) {   
        system.debug('  willNoP ' + willNoP);
        GetWillDetails_Resp_IB_v1 revisionGetWillResponse = GetWillDetails_IH_v1.getWillDetails(willNoP);
        system.debug(' ###### revisionGetWillResponse ' + revisionGetWillResponse);
        string varData = JSON.serialize(revisionGetWillResponse);
        return varData;
    }
    
    /**
    * Method that Update Will Details for Revision
    * @param OppId - Opportunity Id
    * @param willNoP - Asset Numer(SerialNumber) :Will Number
    * 
    * @return String .
    */
    @AuraEnabled
    public static string revisionUpdateWill(Id oppId, String willNoP, string revisionGetWillResponse1) {
        system.debug(' Inside Update Apex revisionGetWillResponse String: '+ revisionGetWillResponse1);
        GetWillDetails_Resp_IB_v1 bean = new GetWillDetails_Resp_IB_v1();
        GetWillDetails_Resp_IB_v1 revisionGetWillResponse = (GetWillDetails_Resp_IB_v1)bean.deserialize(revisionGetWillResponse1, GetWillDetails_Resp_IB_v1.class);
        Account account = new AccountsSelector().selectByOpportunityId(oppId);
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId,1);
        List<Application__c> application = new ApplicationsSelector().selectByOpportunityId(oppId);
        String trace =traceDefault;
        if(application.size() > 0){
            trace = application.get(0).UpdateWillTrace__c;
        }
        List<user> users = new UsersSelector().selectByOpportunityOwnerId(opportunities.get(0).OwnerId);
        List<Asset> asset = new AssetsSelector().selectAssetNumber(willNoP);
        Employee__c adviser = new EmployeesSelector().selectById(opportunities.get(0).Adviser_Employee__c);
        Site__c site = new SitesSelector().selectById(opportunities.get(0).Site__c);
        system.debug('account record: '+account);
        system.debug('opportunities record :'+ opportunities.get(0));
        system.debug('application record: '+ application.get(0));
        system.debug('users record :'+ users.get(0));
        system.debug('Asset record:'+ asset.get(0));
        system.debug('advisor record:'+ adviser);
        system.debug('site record:'+ site);
        Date d = Date.today();
        string dateCreatedP= string.valueOf(Datetime.newInstance(d.year(), d.month(), d.day()).format('yyyyMMdd'));
        string revisiondateP = dateCreatedP;
        System.debug('revisiondateP' +revisiondateP );
        UpdateWillsDetails_Req_IB_v1 UpdateReqBean = new UpdateWillsDetails_Req_IB_v1();
        UpdateReqBean.channel='WILLS';
        UpdateReqBean.application='WILLS';
        UpdateReqBean.trace=trace;
        UpdateReqBean.functioni='DRAFT';
        UpdateReqBean.WillNo = willNoP;
        UpdateReqBean.languageCode = revisionGetWillResponse.LanguageCode;
        UpdateReqBean.bigPrint = revisionGetWillResponse.BigPrint;
        UpdateReqBean.cifkey = 	account.CIF__c;	
        UpdateReqBean.usrid = Users.get(0).AB_Number__c; 
        UpdateReqBean.testator = revisionGetWillResponse.Testator;
        UpdateReqBean.testatrix = revisionGetWillResponse.Testatrix;
        UpdateReqBean.deliverMethod = revisionGetWillResponse.DeliverMethod;
        if(revisionGetWillResponse.SpecialistCode != null){
            UpdateReqBean.specialistCode = String.valueof(revisionGetWillResponse.SpecialistCode);
        }
        UpdateReqBean.submittedBy = revisionGetWillResponse.SubmittedBy;
        UpdateReqBean.submitterTelno = revisionGetWillResponse.SubmitterTelno;
        UpdateReqBean.oldWillNo = revisionGetWillResponse.OldWillNo;
        UpdateReqBean.oldFilingNumber = revisionGetWillResponse.OldFilingNumber;
        UpdateReqBean.willFiled = revisionGetWillResponse.WillFiled;
        UpdateReqBean.willLegal = revisionGetWillResponse.WillLegal;
        UpdateReqBean.fillNo = revisionGetWillResponse.FillNo;
        if(revisionGetWillResponse.DateSigned != null){
            System.debug('revisionGetWillResponse.DateSigned' + revisionGetWillResponse.DateSigned);
            UpdateReqBean.DateSigned = String.valueof(revisionGetWillResponse.DateSigned);
        }
        if(revisionGetWillResponse.DateFiled != null){
            UpdateReqBean.dateFiled = String.valueof(revisionGetWillResponse.DateFiled);
        }
        if(revisionGetWillResponse.DateWithdrawn != null){
            UpdateReqBean.dateWithdrawn = String.valueof(revisionGetWillResponse.DateWithdrawn);
        }
        UpdateReqBean.timeWithdrawn = '0';
        UpdateReqBean.reasonWithdrawn = revisionGetWillResponse.ReasonWithdrawn;
        UpdateReqBean.withdrawnCode = revisionGetWillResponse.WithdrawnCode;
        if(revisionGetWillResponse.WithdrawUserId != null){
            UpdateReqBean.withdrawUserId = String.valueof(revisionGetWillResponse.WithdrawUserId);
        }
        UpdateReqBean.referalReason = revisionGetWillResponse.ReferalReason;
        UpdateReqBean.whoDied = revisionGetWillResponse.WhoDied;
        UpdateReqBean.corpCode = revisionGetWillResponse.CorpCode;
        UpdateReqBean.transactionSite = revisionGetWillResponse.TransactionSite;
        UpdateReqBean.tellerNo = '0';
        if(revisionGetWillResponse.EffectiveDate != null){
            UpdateReqBean.effectiveDate = String.valueof(revisionGetWillResponse.EffectiveDate);
        }
        if(revisionGetWillResponse.CurrentBalance != null){
            UpdateReqBean.currentBalance = String.valueof(revisionGetWillResponse.CurrentBalance); 
        }
        UpdateReqBean.productType = revisionGetWillResponse.ProductType;
        UpdateReqBean.productStatus = 'OPEN';
        UpdateReqBean.branchCode = site.Site_Code__c ;
        if(revisionGetWillResponse.DeceasedDate != null){
            UpdateReqBean.deceasedDate = String.valueof(revisionGetWillResponse.DeceasedDate);
        }
        UpdateReqBean.willStatus = revisionGetWillResponse.WillStatus;
        UpdateReqBean.willError = revisionGetWillResponse.WillError;
        UpdateReqBean.willOrigin = revisionGetWillResponse.WillOrigin;
        UpdateReqBean.acknowledgeLetter = revisionGetWillResponse.AcknowledgeLetter;
        UpdateReqBean.trackerStatus = 'R';
        String strRegDate = String.valueof(revisionGetWillResponse.RegistrationDate);
        String yyyy=strRegDate.left(4);
        System.debug('yyyy'+yyyy);
        String temp=strRegDate.substring(4);
        String mm=temp.left(2);
        System.debug('mm'+mm);
        String dd=strRegDate.right(2);
        System.debug('dd'+dd);
        string stringDate = yyyy + '-' + mm + '-' + dd ;
        boolean isRevision =true;
        date RegistraionDate = date.valueOf(stringDate);
        date DayAddedDateThirty = date.valueOf(stringDate);
        date DaysAfterRegistraionThirty = DayAddedDateThirty.addDays(30);
        Integer numberDaysDue = RegistraionDate.daysBetween(DaysAfterRegistraionThirty);
        System.debug('RegistraionDate : '+RegistraionDate);
        System.debug('DaysAfterRegistraionThirty :'+DaysAfterRegistraionThirty);
        System.debug('numberDaysDue :'+numberDaysDue);
        Date TodaysDate = Date.today();
        if(TodaysDate > DaysAfterRegistraionThirty)
        {
            isRevision=true;
        }else {
            isRevision=false;
        }
            if(isRevision){ //after 30 days of reg date 
                system.debug('Inside isRevision');
                UpdateReqBean.domicileSite = String.valueof(site.Site_Code__c) ;
                UpdateReqBean.newAmendRevise = 'R';    //R- Revision
                UpdateReqBean.registrationDate = revisiondateP;
                UpdateReqBean.revisionDate = revisiondateP;
                UpdateReqBean.branchCode = site.Site_Code__c ;
                if(adviser.Initials__c==null){
                    UpdateReqBean.advisorName = adviser.Surname__c;
                }else {
                    UpdateReqBean.advisorName = adviser.Initials__c + adviser.Surname__c;	
                }
                if(adviser.Initials__c==null){
                    UpdateReqBean.brokerName = adviser.Surname__c;
                }else{
                    UpdateReqBean.brokerName = adviser.Initials__c + adviser.Surname__c;	
                }
                    UpdateReqBean.advisorCode = adviser.Advisor_Code__c;  
                    UpdateReqBean.BrokerCode = adviser.Advisor_Code__c;
            }else if(!isrevision){// within 30 days 
                system.debug('Inside Not isRevision');
                if(revisionGetWillResponse.DomicileSite != null){
                    UpdateReqBean.domicileSite = String.valueof(revisionGetWillResponse.DomicileSite);
                }
                UpdateReqBean.newAmendRevise = String.valueof(revisionGetWillResponse.NewAmendRevise);
                UpdateReqBean.registrationDate = String.valueof(revisionGetWillResponse.RegistrationDate);
                UpdateReqBean.revisionDate = String.valueof(revisionGetWillResponse.RevisionDate);
                if(revisionGetWillResponse.BranchCode != null){
                    UpdateReqBean.branchCode = revisionGetWillResponse.BranchCode ; 
                }
                if(revisionGetWillResponse.AdvisorCode != 0){
                    UpdateReqBean.advisorName = revisionGetWillResponse.advisorName;
                    UpdateReqBean.advisorCode = String.valueof(revisionGetWillResponse.AdvisorCode);      
                } else{ 
                    if(adviser.Initials__c==null){
                        UpdateReqBean.advisorName = adviser.Surname__c;
                    }else {
                        UpdateReqBean.advisorName = adviser.Initials__c + adviser.Surname__c;	
                    }
                    UpdateReqBean.advisorCode = adviser.Advisor_Code__c;  
                }
                if(revisionGetWillResponse.AdvisorCode != 0){
                    UpdateReqBean.brokerName = revisionGetWillResponse.brokerName;
                    UpdateReqBean.brokerCode = String.valueof(revisionGetWillResponse.BrokerCode);    
                } else{ 
                    if(adviser.Initials__c==null){
                        UpdateReqBean.brokerName = adviser.Surname__c;
                    }else{
                        UpdateReqBean.brokerName = adviser.Initials__c + adviser.Surname__c;	
                    }
                    UpdateReqBean.BrokerCode = adviser.Advisor_Code__c;
                }
            }
        String PricingFlag;
        if(application.get(0).Fees_Waived__c==true){
            PricingFlag='N';
        }else{
            PricingFlag='Y';
        }
        UpdateReqBean.pricingFlag = PricingFlag;
        UpdateReqBean.specialistName = revisionGetWillResponse.SpecialistName;
        if(revisionGetWillResponse.caseNo != null){
            UpdateReqBean.caseNo = String.valueof(revisionGetWillResponse.caseNo);
        }
        if(revisionGetWillResponse.SalaryNo != null){
            UpdateReqBean.salaryNo = String.valueof(revisionGetWillResponse.SalaryNo);
        }
        if(revisionGetWillResponse.DispatchDate != null){
            UpdateReqBean.dispatchDate = String.valueof(revisionGetWillResponse.DispatchDate);
        }
        if(revisionGetWillResponse.DraftingBranch != null){
            UpdateReqBean.draftingBranch = String.valueof(revisionGetWillResponse.DraftingBranch);
        }
        UpdateReqBean.correction = revisionGetWillResponse.Correction;
        
        UpdateReqBean.executorFeePlan = revisionGetWillResponse.ExecutorFeePlan;
        
        if(revisionGetWillResponse.FirstFileDate != null){
            UpdateReqBean.firstFileDate = String.valueof(revisionGetWillResponse.FirstFileDate);
        }
        String safeCustodyFee;
        if(application.get(0).Safe_Custody_Is_Required__c=='Yes'){
            safeCustodyFee='Y';
        }else{
            safeCustodyFee='N';
        }
        UpdateReqBean.safeCustodyFee = safeCustodyFee;
        UpdateReqBean.emergencyWill = revisionGetWillResponse.EmergencyWill;
        if(revisionGetWillResponse.DateReturned != null){
            UpdateReqBean.dateReturned = String.valueof(revisionGetWillResponse.DateReturned);  
        }
        UpdateReqBean.standAlone = revisionGetWillResponse.StandAlone;
        if(revisionGetWillResponse.Date1stScfLetter != null){
            UpdateReqBean.date1stScfLetter = String.valueof(revisionGetWillResponse.Date1stScfLetter); 
        }
        if(revisionGetWillResponse.eisDate != null){
            UpdateReqBean.eisDate = String.valueof(revisionGetWillResponse.EisDate);
        }
        if(revisionGetWillResponse.LeadCode != null){
            UpdateReqBean.leadCode = String.valueof(revisionGetWillResponse.LeadCode);
        }
        UpdateReqBean.leadName = revisionGetWillResponse.LeadName;
        UpdateReqBean.csaSent = revisionGetWillResponse.CSASent;
        UpdateReqBean.trustIndicator = revisionGetWillResponse.TrustIndicator;
        if(revisionGetWillResponse.SpecialBequestVal != null){
            UpdateReqBean.specialBequestVal = String.valueof(revisionGetWillResponse.SpecialBequestVal);
        }
        UpdateReqBean.casaNo = account.CASA_Reference_Number__c;
        String CasaDateO;
        if(account.CASA_Screening_Date__c != null){
            Date dt = account.CASA_Screening_Date__c;
            string casaDateP= string.valueOf(Datetime.newInstance(dt.year(), dt.month(), dt.day()).format('yyyyMMdd'));
            CasaDateO = casaDateP;
        }
        if(account.CASA_Screening_Date__pc != null){
            date dtpc = account.CASA_Screening_Date__pc;
            string casaDatepc= string.valueOf(Datetime.newInstance(dtpc.year(), dtpc.month(), dtpc.day()).format('yyyyMMdd'));
            CasaDateO = casaDatepc;
        }
        string casaDate = CasaDateO;
        System.debug('casaDate' +casaDate );
        UpdateReqBean.casaDate = casaDate;
        String CasaIndicator ='C';
        if(account.CASA_Screening_Status__c=='Approved'){
            CasaIndicator='C';
        }else{
            CasaIndicator='D';
        }
        UpdateReqBean.casaIndicator = CasaIndicator;
        UpdateReqBean.feePaid = revisionGetWillResponse.FeePaid; 
        if(revisionGetWillResponse.AmountDue != null){
            UpdateReqBean.amountDue = String.valueof(revisionGetWillResponse.AmountDue);
        }
        if(revisionGetWillResponse.PayDate != null){
            UpdateReqBean.payDate = String.valueof(revisionGetWillResponse.PayDate);
        }
        System.debug('#### UpdateReqBean ### : ' +UpdateReqBean);
        UpdateWillsDetails_Resp_IB_v1 revsionUpdateWillResponse = UpdateWillsDetails_IH_v1.updateWillsDetails(UpdateReqBean);
        if(revsionUpdateWillResponse.rc== '0'){
            Application__c app =new Application__c();
            app.Id=application.get(0).Id;
            app.Revision_Will_Update__c=true;
            app.Revision_Will_Update_Error__c='';
            update app;
            return 'Success';
        } else{
            Application__c app =new Application__c();
            app.Id=application.get(0).Id;
            app.Revision_Will_Update__c=false;
            app.Revision_Will_Update_Error__c=revsionUpdateWillResponse.RCMessage ;
            update app;
            return revsionUpdateWillResponse.RCMessage  ;
        }    
    }
    
    /**
    * Method that call Create Tracker Service for Revision
    *
    * @param willNoP - Asset Numer(SerialNumber) :Will Number
    * 
    * @return String.
    */
    @AuraEnabled
    public static string revisionCreateRegistrationTrackerApplication(Id oppId,String channel,String application,String willNo,String tstatus,String sstatus,String statCd,String filLoc,String prevId,String actionP,String comments,String branchCd) {
        List<Application__c> application1 = new ApplicationsSelector().selectByOpportunityId(oppId);
        String trace = traceDefault;
        if(application1.size() > 0){
            trace = application1.get(0).TrackerTrace__c;
        }
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId,1);
        List<user> users = new UsersSelector().selectByOpportunityOwnerId(opportunities.get(0).OwnerId);
        if(Users.get(0).AB_Number__c=='ABLS109'){
            branchCd='7283';
        }
        Date d = Date.today();
        string dateCreatedP= string.valueOf(Datetime.newInstance(d.year(), d.month(), d.day()).format('yyyyMMdd'));
        System.debug('dateCreatedP' +dateCreatedP );
        string dateCreated = dateCreatedP;
        DateTime dT = System.now();
        String timeCreatedP = string.valueOf(dT.format('HHmm'));
        string timeCreated =timeCreatedP;  
        System.debug('timeCreated' +timeCreated );
        string userId = Users.get(0).AB_Number__c;
        CreateTracker_Resp_IB_v1 revisionCreateAppTrackerResponse = CreateTracker_IH_v1.createTracker(channel,application,trace,willNo,tstatus,dateCreated,timeCreated,userId,sstatus,statCd,filLoc,prevId,actionP,comments,branchCd);
        system.debug('revisionCreateAppTrackerResponse' + revisionCreateAppTrackerResponse);
        if(revisionCreateAppTrackerResponse.awp200so.rc== '0'){
            Application__c app =new Application__c();
            app.Id=application1.get(0).Id;
            app.Revision_Registration_AppTracker_Created__c=true;
            app.Rev_Reg_App_Tracker_Created_Error__c='';
            update app;
            System.debug('success in createTracker Service :' + revisionCreateAppTrackerResponse.awp200so.rcMessage);
            return 'Success';
        } 
        else
        {
            System.debug('Error in createTracker Service :' + revisionCreateAppTrackerResponse.awp200so.rcMessage);
            Application__c app =new Application__c();
            app.Id=application1.get(0).Id;
            app.Revision_Registration_AppTracker_Created__c=false;
            app.Rev_Reg_App_Tracker_Created_Error__c= revisionCreateAppTrackerResponse.awp200so.rcMessage;
            update app;
            return  revisionCreateAppTrackerResponse.awp200so.rcMessage ;
        }
    }
    
    /**
    * Method that call Create Tracker Service for Revision
    *
    * @param willNoP - Asset Numer(SerialNumber) :Will Number
    * 
    * @return String.
    */
    @AuraEnabled
    public static string revisionCreateRegistrationTracker(Id oppId,String channel,String application,String willNo,String tstatus,String sstatus,String statCd,String filLoc,String prevId,String actionP,String comments,String branchCd) {
        List<Application__c> application1 = new ApplicationsSelector().selectByOpportunityId(oppId);
        String trace = traceDefault;
        if(application1.size() > 0){
            trace = application1.get(0).TrackerTrace__c;
        }
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId,1);
        List<user> users = new UsersSelector().selectByOpportunityOwnerId(opportunities.get(0).OwnerId);
        if(Users.get(0).AB_Number__c=='ABLS109'){
            branchCd='7283';
        }
        Date d = Date.today();
        string dateCreatedP= string.valueOf(Datetime.newInstance(d.year(), d.month(), d.day()).format('yyyyMMdd'));
        System.debug('dateCreatedP' +dateCreatedP );
        string dateCreated = dateCreatedP;
        DateTime dT = System.now();
        String timeCreatedP = string.valueOf(dT.format('HHmm'));
        string timeCreated =timeCreatedP;  
        System.debug('timeCreated' +timeCreated );
        string userId = Users.get(0).AB_Number__c;
        CreateTracker_Resp_IB_v1 revisionCreateTrackerResponse = CreateTracker_IH_v1.createTracker(channel,application,trace,willNo,tstatus,dateCreated,timeCreated,userId,sstatus,statCd,filLoc,prevId,actionP,comments,branchCd);
        system.debug('revisionCreateTrackerResponse'+revisionCreateTrackerResponse);
        if(revisionCreateTrackerResponse.awp200so != NULL){
            if(revisionCreateTrackerResponse.awp200so.rc== '0'){
                Application__c app =new Application__c();
                app.Id=application1.get(0).Id;
                app.Revision_Registration_Tracker_Created__c=true;
                app.Registration_Status__c='Submitted';
                app.Revision_Reg_Tracker_Created_Error__c='';
                update app;
                Opportunity op=new Opportunity();
                op.id=oppId;
                op.StageName='Drafting';
                update op;
                System.debug('success in createTracker Service :' + revisionCreateTrackerResponse.awp200so.rcMessage);
                return 'Success';
            } 
            else
            {
                System.debug('Error in createTracker Service :' + revisionCreateTrackerResponse.awp200so.rcMessage);
                Application__c app =new Application__c();
                app.Id=application1.get(0).Id;
                app.Revision_Registration_Tracker_Created__c=false;
                app.Revision_Reg_Tracker_Created_Error__c= revisionCreateTrackerResponse.awp200so.rcMessage;
                update app;
                return  revisionCreateTrackerResponse.awp200so.rcMessage ;
            }
        }
        return null;  
    }
}