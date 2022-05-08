/*
 * Apex Controller for Displaying AccountNumber in Summary tab
 * by CQcreateAndLinkAccountV7 Service
 * @author Diksha Wasekar
 * @created 2020-02-22
 */
public class OnboardingProductCQcreateAcctSummaryCon {
    public static Account acc;
    public static OpportunityLineItem oppproduct;

    @AuraEnabled
    public static List<DisplayProducts> getOppData(String oppId) {
        Opportunity opp = new OpportunitiesSelector().selectByOpptId(oppId);
        acc = new AccountsSelector().selectByOpportunityId(oppId);
        List<User> userRec = new UsersSelector().userwithSiteCode(UserInfo.getUserId());
        oppproduct = new OpportunityLineItemsSelector().selectByOppId(oppId, 1);
        List<Application__c> app = new ApplicationsSelector().selectByOpportunityOnboardId(oppId);
        String errorMessage = '';
        String accountNbr = '0';
        String openSite = userRec[0].SiteCode__c;
        String controlSite = opp.site__r.site_code__c;
        String cifKey = opp.CIF_Number__c;
        String tellerNbr = userRec[0].Teller_Operator_Code__c;
        String controllerNbr = '9999999';
        String workstationNbr = '0';
        String product = oppproduct.ProductCode;
        String applicationNbr = '0';
        String controlSiteType = '034';
        String openSiteType = '034';
        String effectiveDate = (string.valueof(System.today())).replace('-', '');
        String marketersCode = '0';
        String provChqBookInd = 'N';
        String cbpSchemeCode = '?';
        String cbpPrimaryAccount = '0';
        String srcOfFnds1 = app[0].Source_of_Funds_Savings__c.substring(0, 2);
        String srcOfFnds2 = app[0].Source_of_Funds_Savings__c.substring(0, 2);
        String srcOfFnds3 = app[0].Source_of_Funds_Savings__c.substring(0, 2);
        String srcOfFnds4 = app[0].Source_of_Funds_Savings__c.substring(0, 2);
        String srcOfFnds5 = app[0].Source_of_Funds_Savings__c.substring(0, 2);
        String digitalChannel = 'B';
        String rbaEdd = '';
        List<DisplayProducts> displayproductList = new List<DisplayProducts>();
        DisplayProducts dspr = new DisplayProducts();
        dspr.Client = acc.Name;
        dspr.Account = oppproduct.Name;
        if (oppproduct.Product2.family == 'cheque') {
            opportunityLineItem AcctnumberCQ = callCQcreateAcct(
                accountNbr,
                openSite,
                controlSite,
                cifKey,
                tellerNbr,
                controllerNbr,
                workstationNbr,
                product,
                applicationNbr,
                controlSiteType,
                openSiteType,
                effectiveDate,
                marketersCode,
                provChqBookInd,
                cbpSchemeCode,
                cbpPrimaryAccount,
                srcOfFnds1,
                srcOfFnds2,
                srcOfFnds3,
                srcOfFnds4,
                srcOfFnds5,
                digitalChannel,
                rbaEdd
            );
            if (AcctnumberCQ != null) {
                update AcctnumberCQ;
                dspr.AccountNumber = AcctnumberCQ.Policy_Number__c;
            }
        } else if (oppproduct.Product2.family == 'SAVINGS') {
            opportunityLineItem UpdatedLineItem = getAccountNumber(opp.id, oppproduct.Id, srcOfFnds1, srcOfFnds2, srcOfFnds3, srcOfFnds4, srcOfFnds5, rbaEdd);
            if (UpdatedLineItem != null) {
                update UpdatedLineItem;
                dspr.AccountNumber = UpdatedLineItem.Policy_Number__c;
            }
        }
        displayproductList.add(dspr);
        return displayproductList;
    }

    public static OpportunityLineItem callCQcreateAcct(
        string accountNbr,
        String openSite,
        String controlSite,
        String cifKey,
        String tellerNbr,
        String controllerNbr,
        String workstationNbr,
        String product,
        String applicationNbr,
        String controlSiteType,
        String openSiteType,
        String effectiveDate,
        String marketersCode,
        String provChqBookInd,
        String cbpSchemeCode,
        String cbpPrimaryAccount,
        String srcOfFnds1,
        String srcOfFnds2,
        String srcOfFnds3,
        String srcOfFnds4,
        String srcOfFnds5,
        String digitalChannel,
        String rbaEdd
    ) {
        Map<CQcreateAndLinkAccountV7_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CQcreateAndLinkAccountV7_IH_v1.CQcreateAndLinkAccountV7(
            accountNbr,
            openSite,
            controlSite,
            cifKey,
            tellerNbr,
            controllerNbr,
            workstationNbr,
            product,
            applicationNbr,
            controlSiteType,
            openSiteType,
            effectiveDate,
            marketersCode,
            provChqBookInd,
            cbpSchemeCode,
            cbpPrimaryAccount,
            srcOfFnds1,
            srcOfFnds2,
            srcOfFnds3,
            srcOfFnds4,
            srcOfFnds5,
            digitalChannel,
            rbaEdd
        );
        if (responseMap != null) {
            CQcreateAndLinkAccountV7_Resp_IB_v1 responseBean = (new List<CQcreateAndLinkAccountV7_Resp_IB_v1>(responseMap.keySet()))[0];
            List<Sys_Log_Integration__c> sysLog = responseMap.values()[0];
            if (sysLog != null && !sysLog.isEmpty()) {
                insert sysLog;
            }
            if (responseBean.statusCode == 200) {
                if (responseBean.CQcreateAndLinkAccountV7Response != null) {
                    string Accountnumber = responseBean.CQcreateAndLinkAccountV7Response.cqh411o.accountNbrOut;
                    oppproduct.Policy_Number__c = Accountnumber.replaceFirst('^0+', '');
                }
            }
        }
        return oppproduct;
    }

    /** Wrapper Class To display product in Account Information
     *
     *
     */
    public class DisplayProducts {
        @auraEnabled
        public String Client { get; set; }
        @auraEnabled
        public String Account { get; set; }
        @auraEnabled
        public string AccountNumber { get; set; }
    }

    //Added By Srikanth
    @AuraEnabled
    public static OpportunityLineItem getAccountNumber(
        String oppId,
        String lineItemId,
        String srcOfFnds1,
        String srcOfFnds2,
        String srcOfFnds3,
        String srcOfFnds4,
        String srcOfFnds5,
        String rbaEddRating
    ) {
        Opportunity currentOpp = [SELECT Id, AccountId, Account.CIF__c FROM Opportunity WHERE id = :oppId];
        OpportunityLineItem lineItem = new OpportunityLineItem(Id = lineItemId);
        Map<SVcreateLinkSavingsDepAccount_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = SVcreateLinkSavingsDepAccount_IH_v1.callToSVcreateLinkSavingsDepAccount(
            oppId,
            lineItemId,
            srcOfFnds1,
            srcOfFnds2,
            srcOfFnds3,
            srcOfFnds4,
            srcOfFnds5,
            rbaEddRating
        );
        if (responseMap != null) {
            SVcreateLinkSavingsDepAccount_Resp_IB_v1 responseBean = (new List<SVcreateLinkSavingsDepAccount_Resp_IB_v1>(responseMap.keySet()))[0];
            if (responseBean != null) {
                List<Sys_Log_Integration__c> sysLog = responseMap.values()[0];
                if (sysLog != null && !sysLog.isEmpty()) {
                    update sysLog;
                }
                if (responseBean.statusCode == 200) {
                    lineItem.Policy_Number__c = responseBean.SVcreateLinkSavingsNoticeDepAccountV6Response.svpp15o.accountNumber;
                }
            }
        }
        return lineItem;
    }
}