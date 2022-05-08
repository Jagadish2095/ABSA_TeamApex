/**
 * Controller class for CovidBankGuarantee aura component
 *
 * @author Ketelo Makalela
 * @created 2020-12-01
 */
public class CovidBankGuaranteeController {
    
    @AuraEnabled
    public static String callToAllocateStockNo(Id oppId) {
        AccountsSelector accountSelector = new AccountsSelector();
        Account account = accountSelector.selectByOpportunityId(oppId);
        User user = new UsersSelector().selectById(UserInfo.getUserId());
        //List<Application__c> applicationLst = new ApplicationsSelector().selectByOpportunityOnboardId(oppId);
        ApplicationProductSelector appProductSelector = new ApplicationProductSelector();
        List<Application_Product__c> appProducts = appProductSelector.selectByOpportunityId(oppId);
        
        String accNumber;
        String msg;
        
        if(appProducts != null && appProducts.size() > 0) {
            if(appProducts[0].Account_Number__c == null) {
        		ABFCreateAndLinkAccount_Resp_IB_v1 responseBean = ABFCreateAndLinkAccount_IH_v1.createAndLinkAccount(user,account.CIF__c);
                List<ABFCreateAndLinkAccount_Resp_IB_v1.MsgEntry> msgEntry = responseBean.nbsmsgo3.msgEntry;
                
                accNumber = responseBean.Plpa00o.accountNumber;
                
                if(accNumber != '00000000000000000' && msgEntry == null){
                    appProducts[0].Account_Number__c = Decimal.valueOf(accNumber);
                	
                    try {
                        update appProducts[0];
                    } catch(Exception e) {
                        throw new AuraHandledException( e.getMessage());
                    }
                } else {
                    msg = responseBean.nbsmsgo3.msgEntry[0].msgTxt;
                    return msg;
                }
                
            } else{
                accNumber = String.valueOf(appProducts[0].Account_Number__c);
            }
        }
        
        return accNumber;
    }
    
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
	
    @AuraEnabled
    public static String linkStockNumberToCIF(Id oppId) {
        String response;
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
        List<Application__c> applicationLst = new ApplicationsSelector().selectByOpportunityOnboardId(oppId);
        List<User> userRec= new UsersSelector().userwithSiteCode(UserInfo.getUserId());

        if(applicationLst.size() > 0 && applicationLst != null) {
            CIlinkAccounttoClientV4_Req_IB_v1 requestBean = CIlinkAccounttoClientV4_IU_V1.mapRequestFields(applicationLst[0].Stock_Number__c, opportunities[0].CIF_Number__c, userRec[0].SiteCode__c, userRec[0].Teller_Operator_Code__c);
            CIlinkAccounttoClientV4_Resp_IB_V1 stockResponse = CIlinkAccounttoClientV4_IH_V1.CIlinkAccounttoClientV4(requestBean);

            if(stockResponse != null) {
                CIlinkAccounttoClientV4_Resp_IB_V1.CIlinkAccountToClientV4Response wrapper = (stockResponse.CIlinkAccountToClientV4Response != null ? stockResponse.CIlinkAccountToClientV4Response : null);
                CIlinkAccounttoClientV4_Resp_IB_V1.Nbsmsgo3 nbsmsgo3 = (wrapper != null ? wrapper.Nbsmsgo3 : null);

                response = JSON.serialize(stockResponse.message);

                if(stockResponse.statusCode == 200) {
                    response = stockResponse.statusCode + ' ' + (nbsmsgo3.msgEntry != null ? JSON.serialize(nbsmsgo3.msgEntry[0].msgTxt) : 'Service Returned No Messsage');
                } else {
                    response = stockResponse.statusCode + ' ' + (nbsmsgo3 != null ? JSON.serialize(nbsmsgo3.msgEntry[0].msgTxt) : stockResponse.status + ' ' + stockResponse.faultstring);
                }
            } else {
                response = 'Service callout failed!';
            }
        } else {
            response = 'No Application Record Found';
        }
        return response;
    }
    @AuraEnabled 
    public static Application_Product__c getAppProductdetails(Id oppId){
        List<Application_Product__c > prodlist = new ApplicationproductSelector().selectByOpportunityId(oppId);
        return prodlist[0];
        }
}