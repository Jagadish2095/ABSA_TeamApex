/**
 * @description       : VASEStamntDeliveryController
 * @author            : Khaliq Abdul
 * @last modified on  : 2021-06-24
 * @last modified by  : André Pietersen (IQ Business)
 * Modifications Log
 * Ver   Date         Author                          Modification
 * 1.0   2021-06-23   André Pietersen (IQ Business)   Initial Version
**/
public without sharing class VASEStamntDeliveryController
{
    public static Account acc;
    public static OpportunityLineItem oppproduct;
    public static List<Application__c> app;

    /**
    * @description getEStamntDelivery
    * @author André Pietersen (IQ Business) | 2021-06-23
    * @param oppId
    * @param isEnquiry
    * @param productFamily
    * @return EImaintainESDDetailsV3_Resp_IB_v1
    **/
    @AuraEnabled
    public static EImaintainESDDetailsV3_Resp_IB_v1 getEStamntDelivery(String oppId, Boolean isEnquiry, String productFamily)
    {
        String errorMessage;
        //get user Info
        Opportunity opp = [SELECT Id, AccountId FROM Opportunity WHERE Id =: oppId];
        Account account = [SELECT Id, CIF__c, Name, PersonEmail, PersonMobilePhone, Phone, Active_Email__c, RecordType.Name
            FROM Account WHERE Id =: opp.AccountId];
        User loggedInUserInfo = [SELECT Id, SiteCode__c, Teller_Operator_Code__c, EmployeeNumber FROM USER WHERE Id =: UserInfo.getUserId()];

        List<OpportunityLineItem> oppproducts = new  OpportunityLineItemsSelector().selectByOpportunityId(oppId);
        //find first cheque item linked to opportunity
        for (OpportunityLineItem olineItems : oppproducts) {
            if (olineItems.Product_Family__c == productFamily) {
                oppproduct = olineItems;
                break;
            }
        }
        String productCode = '0';
        String product = '';
        String accoNumber = '0';
        String request = isEnquiry ? 'E' : 'C';

        string email = '';
        string phone = '';

        if (account.RecordType.Name == 'Business Prospect') {
            email = account.Active_Email__c;
            phone = account.Phone;
        } else {
            email = account.PersonEmail;
            phone = account.PersonMobilePhone;
        }

        if(oppproduct != null)
            {
                productCode = oppproduct.ProductCode;
                accoNumber = oppproduct.Policy_Number__c;
                switch on oppproduct.Product_Family__c {
                    when 'Cheque' {
                        product = 'CQ';
                    }
                    when 'Savings' {
                        product = 'SV';
                    }
                    when 'Credit' {
                        product = 'CC';
                    }
                }
            }
        EImaintainESDDetailsV3_Resp_IB_v1 responseBean;

        try{
            EImaintainESDDetailsV3_Req_IB_v1 requestBean =  new  EImaintainESDDetailsV3_Req_IB_v1();
            requestBean.EImaintainESDDetailsV3 = new EImaintainESDDetailsV3_Req_IB_v1.EImaintainESDDetailsV3();
            requestBean.EImaintainESDDetailsV3.Nbsapdpi = new EImaintainESDDetailsV3_Req_IB_v1.Nbsapdpi();
            requestBean.EImaintainESDDetailsV3.Nbsapdpi.application = 'SF';
            requestBean.EImaintainESDDetailsV3.Nbsapdpi.channel = 'SF';
            requestBean.EImaintainESDDetailsV3.Nbsapdpi.trace = 'N';

            requestBean.EImaintainESDDetailsV3.nbsmsgi  = new EImaintainESDDetailsV3_Req_IB_v1.nbsmsgi();
            requestBean.EImaintainESDDetailsV3.nbsmsgi.FinalMsgId  = new EImaintainESDDetailsV3_Req_IB_v1.FinalMsgId();
            requestBean.EImaintainESDDetailsV3.nbsmsgi.FinalMsgId.finalMsgClass = '0';
            requestBean.EImaintainESDDetailsV3.nbsmsgi.FinalMsgId.finalMsgCode = '0';
            requestBean.EImaintainESDDetailsV3.nbsmsgi.msgLanguage = 'E';
            requestBean.EImaintainESDDetailsV3.nbsmsgi.msgTarget = 'STD';

            requestBean.EImaintainESDDetailsV3.eip103i = new EImaintainESDDetailsV3_Req_IB_v1.eip103i();
            requestBean.EImaintainESDDetailsV3.eip103i.acn =  accoNumber;
            requestBean.EImaintainESDDetailsV3.eip103i.site = loggedInUserInfo.SiteCode__c;
            requestBean.EImaintainESDDetailsV3.eip103i.teller =  loggedInUserInfo.Teller_Operator_Code__c;
            requestBean.EImaintainESDDetailsV3.eip103i.request =  request;
            requestBean.EImaintainESDDetailsV3.eip103i.eCount =  '1';
            requestBean.EImaintainESDDetailsV3.eip103i.marketerCodeInit = loggedInUserInfo.EmployeeNumber;
            requestBean.EImaintainESDDetailsV3.eip103i.marketerCodeAmend =  loggedInUserInfo.SiteCode__c;
            requestBean.EImaintainESDDetailsV3.eip103i.ichannel =  'B';
            requestBean.EImaintainESDDetailsV3.eip103i.product = product;
            requestBean.EImaintainESDDetailsV3.eip103i.prodCode =  productCode;
            requestBean.EImaintainESDDetailsV3.eip103i.prefInd =  'E';

            List<EImaintainESDDetailsV3_Req_IB_v1.entry> entryList = new List<EImaintainESDDetailsV3_Req_IB_v1.entry>();
            EImaintainESDDetailsV3_Req_IB_v1.entry entry = new EImaintainESDDetailsV3_Req_IB_v1.entry();
            if (email == '') {
                errorMessage = 'Email required for Estatement';
                throw new ApplicationException(errorMessage);
            }
            entry.email = email;
            entry.wm = 'Y';
            entryList.add(entry);
            requestBean.EImaintainESDDetailsV3.eip103i.entry = entryList;

            responseBean =  EImaintainESDDetailsV3_IH_v2.EImaintainESDDetails(requestBean);
        } catch(Exception exc){
            throw new ApplicationException('Something went wrong: '+ exc.getMessage());
        }
        if(!isEnquiry)
        {
            app = new ApplicationsSelector().selectByOpportunityBranchId(oppId);
            app[0].Electronic_Statements__c = true;
            try {
                update app;
            }
            catch(Exception e) {
                throw new ApplicationException('Something went wrong: '+ e.getMessage());
            }
        }
        return responseBean;
    }
}