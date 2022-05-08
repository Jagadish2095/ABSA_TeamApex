/**
 * @description       : VASNotifyMeController
 * @author            : Satya Boyenepalli: Absa
 * @last modified on  : 2021-06-24
 * @last modified by  : André Pietersen (IQ Business)
 * Modifications Log
 * Ver   Date         Author                          Modification
 * 1.0   2021-06-23   André Pietersen (IQ Business)   Initial Version
**/

public with sharing class VASNotifyMeController
{
    public static Account acc;
    public static OpportunityLineItem oppproduct;
    public static List<Application__c> app;
    /**
    * @description CheckNotifyMe
    * @author André Pietersen (IQ Business) | 2021-06-23
    * @param oppId
    * @return String
    **/
    @AuraEnabled
    public static String checkNotifyMe(String oppId)
    {
        NQlistRecipientsRegForCustV1_Resp_IB_v1 notifyMeResponse = new  NQlistRecipientsRegForCustV1_Resp_IB_v1();
        try{
            Opportunity opp = [SELECT Id, AccountId FROM Opportunity WHERE Id =: oppId];
            Account account = [SELECT Id, CIF__c FROM Account WHERE Id = :opp.AccountId];
            User loggedInUserInfo = [SELECT Id, SiteCode__c FROM USER WHERE Id =: UserInfo.getUserId()];

            NQlistRecipientsRegForCustV1_Req_IB_v1 requestBean = new NQlistRecipientsRegForCustV1_Req_IB_v1();
            NQlistRecipientsRegForCustV1_Req_IB_v1.nbsapdpi nbsapdpiRequest = new NQlistRecipientsRegForCustV1_Req_IB_v1.nbsapdpi();
            nbsapdpiRequest.application = 'SF';
            nbsapdpiRequest.channel = 'SF';
            nbsapdpiRequest.trace = 'N';

            NQlistRecipientsRegForCustV1_Req_IB_v1.nbsmsgi nbsmsgiRequest = new NQlistRecipientsRegForCustV1_Req_IB_v1.nbsmsgi();
            nbsmsgiRequest.msgLanguage = 'E';
            nbsmsgiRequest.msgTarget = 'STD';

            NQlistRecipientsRegForCustV1_Req_IB_v1.finalMsgId finalMsgIdRequest = new NQlistRecipientsRegForCustV1_Req_IB_v1.finalMsgId();
            finalMsgIdRequest.finalMsgClass = '';
            finalMsgIdRequest.finalMsgCode = '';

            NQlistRecipientsRegForCustV1_Req_IB_v1.nqp904i nqp904iRequest = new NQlistRecipientsRegForCustV1_Req_IB_v1.nqp904i();
            Nqp904iRequest.cif = account.CIF__c;
            Nqp904iRequest.registeringSite = loggedInUserInfo.SiteCode__c;

            NQlistRecipientsRegForCustV1_Req_IB_v1.NQlistRecipientsRegisteredForCustV1 nqListRecipientsRegisteredForCustV1bean = new NQlistRecipientsRegForCustV1_Req_IB_v1.NQlistRecipientsRegisteredForCustV1();
            nqListRecipientsRegisteredForCustV1bean.nbsapdpi = nbsapdpiRequest;
            nqListRecipientsRegisteredForCustV1bean.nbsmsgi = nbsmsgiRequest;
            nqListRecipientsRegisteredForCustV1bean.nqp904i = nqp904iRequest;

            requestBean.NQlistRecipientsRegisteredForCustV1 = nqListRecipientsRegisteredForCustV1bean;
            notifyMeResponse = NQlistRecipientsRegForCustV1_IH_v1.NQlistRecipientsRegForCustV1(requestBean);
        } catch (Exception exc) {
            throw new AuraHandledException('Something went wrong: '+ exc.getMessage());
        }
        return notifyMeResponse.serialize(notifyMeResponse);
    }

    /**
    * @description RegisterForNotifyMe
    * @author André Pietersen (IQ Business) | 2021-06-23
    * @param oppId
    * @param productFamily
    * @return String
    **/
    @AuraEnabled
    public static String registerForNotifyMe(String oppId, String productFamily)
    {
        Opportunity opp = [SELECT Id, AccountId FROM Opportunity WHERE Id =: oppId];
        Account account = [SELECT Id, CIF__c, Name, PersonEmail, PersonMobilePhone, Phone, Active_Email__c, RecordType.Name
            FROM Account WHERE Id =: opp.AccountId];
        User loggedInUserInfo = [SELECT Id, SiteCode__c, Teller_Operator_Code__c, EmployeeNumber FROM USER WHERE Id =: UserInfo.getUserId()];

        string email = '';
        string phone = '';

        if (account.RecordType.Name == 'Business Prospect') {
            email = account.Active_Email__c;
            phone = account.Phone;
        } else {
            email = account.PersonEmail;
            phone = account.PersonMobilePhone;
        }

        List<OpportunityLineItem> oppproducts = new  OpportunityLineItemsSelector().selectByOpportunityId(oppId);
        //find first cheque item linked to opportunity
        for (OpportunityLineItem olineItems : oppproducts) {
            if (olineItems.Product_Family__c == productFamily) {
                oppproduct = olineItems;
                break;
            }
        }
        string productType;
        if (oppproduct != null)
        {
            switch on oppproduct.Product_Family__c {
                when 'Cheque' {
                    productType = 'CHEQUE';
                }
                when 'Savings' {
                    productType = 'SAVINGS';
                }
                when 'Credit' {
                    productType = 'CREDITCARD';
                }
            }
        }

        NQcreateneworaddrecipientv22_Resp_IB_v1 createneworaddrecipientv2responsebean = new  NQcreateneworaddrecipientv22_Resp_IB_v1();

        try{
            NQcreateneworaddrecipientv22_Req_IB_v1 requestbean = new NQcreateneworaddrecipientv22_Req_IB_v1();
            NQcreateneworaddrecipientv22_Req_IB_v1.NQcreateNewOrAddRecipientV2 nqCreateNewOrAddRecipientV2bean = new NQcreateneworaddrecipientv22_Req_IB_v1.NQcreateNewOrAddRecipientV2();
            NQcreateneworaddrecipientv22_Req_IB_v1.nqp906i nqp906ibean  = new NQcreateneworaddrecipientv22_Req_IB_v1.nqp906i();
            NQcreateneworaddrecipientv22_Req_IB_v1.finalMsgId finalMsgIdbean  = new NQcreateneworaddrecipientv22_Req_IB_v1.finalMsgId();
            NQcreateneworaddrecipientv22_Req_IB_v1.nbsapdpi nbsapdpibean  = new NQcreateneworaddrecipientv22_Req_IB_v1.nbsapdpi();
            NQcreateneworaddrecipientv22_Req_IB_v1.nbsmsgi nbsmsgibean  = new NQcreateneworaddrecipientv22_Req_IB_v1.nbsmsgi();
            NQcreateneworaddrecipientv22_Req_IB_v1.keyFields keyFieldsbean = new NQcreateneworaddrecipientv22_Req_IB_v1.keyFields();
            NQcreateneworaddrecipientv22_Req_IB_v1.recipientAcnData recipientAcnDatabean = new NQcreateneworaddrecipientv22_Req_IB_v1.recipientAcnData();
            NQcreateneworaddrecipientv22_Req_IB_v1.trnSelX trnSelXbean = new NQcreateneworaddrecipientv22_Req_IB_v1.trnSelX();
            NQcreateneworaddrecipientv22_Req_IB_v1.balFreqs balFreqsbean = new NQcreateneworaddrecipientv22_Req_IB_v1.balFreqs();
            List<NQcreateneworaddrecipientv22_Req_IB_v1.trnSelX> trnSelXlistbean = new List<NQcreateneworaddrecipientv22_Req_IB_v1.trnSelX>();
            List<NQcreateneworaddrecipientv22_Req_IB_v1.balFreqs> balFreqslistbean = new List<NQcreateneworaddrecipientv22_Req_IB_v1.balFreqs>();
            NQcreateneworaddrecipientv22_Req_IB_v1.recipientData recipientDatabean = new NQcreateneworaddrecipientv22_Req_IB_v1.recipientData();

            nbsapdpibean.channel = 'SF';
            nbsapdpibean.application = 'SF';
            nbsapdpibean.trace = 'N';

            nbsmsgibean.msgLanguage = 'E';
            nbsmsgibean.msgTarget = 'STD';

            finalMsgIdbean.finalMsgClass = '';
            finalMsgIdbean.finalMsgCode = '';
            nbsmsgibean.finalMsgId = finalMsgIdbean;

            keyFieldsbean.acn = oppproduct.Policy_Number__c;
            keyFieldsbean.cif = account.CIF__c;
            keyFieldsbean.pnsRecipientId = '0';
            nqp906ibean.keyFields = keyFieldsbean;

            nqp906ibean.registeringSite = loggedInUserInfo.SiteCode__c;
            nqp906ibean.clientNotif = '901';
            nqp906ibean.sbuCd = 'F';
            nqp906ibean.teller = loggedInUserInfo.Teller_Operator_Code__c;
            nqp906ibean.notifyCifInd = 'N';

            recipientDatabean.recipNm = account.Name;
            recipientDatabean.contactPref = 'S';
            recipientDatabean.lng = 'E';
            recipientDatabean.email = email;
            recipientDatabean.cellPhone = phone == '' ? '0' : phone;
            nqp906ibean.recipientData = recipientDatabean;

            trnSelXbean.trnSel = '19';
            trnSelXlistbean.add(trnSelXbean);
            recipientAcnDatabean.trnSelX = trnSelXlistbean;
            recipientAcnDatabean.prodArea = productType;
            recipientAcnDatabean.minAm = '0';
            recipientAcnDatabean.transmitWindow = 'A';
            recipientAcnDatabean.balFreqs = balFreqslistbean;
            recipientAcnDatabean.delInd = 'N';

            balFreqsbean.balDay='Y';
            //add 8 entries for daily updates
            balFreqslistbean.add(balFreqsbean);
            balFreqslistbean.add(balFreqsbean);
            balFreqslistbean.add(balFreqsbean);
            balFreqslistbean.add(balFreqsbean);
            balFreqslistbean.add(balFreqsbean);
            balFreqslistbean.add(balFreqsbean);
            balFreqslistbean.add(balFreqsbean);
            balFreqslistbean.add(balFreqsbean);

            nqp906ibean.marketerCode = loggedInUserInfo.EmployeeNumber;
            nqp906ibean.marketerCodeAmend = loggedInUserInfo.EmployeeNumber;

            nqp906ibean.recipientAcnData = recipientAcnDatabean;
            nqCreateNewOrAddRecipientV2bean.nbsapdpi = nbsapdpibean;
            nqCreateNewOrAddRecipientV2bean.nbsmsgi = nbsmsgibean;
            nqCreateNewOrAddRecipientV2bean.nqp906i = nqp906ibean;
            requestBean.NQcreateNewOrAddRecipientV2 = nqCreateNewOrAddRecipientV2bean;
            createneworaddrecipientv2responsebean = (NQcreateneworaddrecipientv22_Resp_IB_v1)NQcreateneworaddrecipientv22_IH_v1.Nqcreateneworaddrecipientv2(requestbean);

        } catch(Exception exc) {
            system.debug('Error Message: ' + exc.getMessage() + 'Error Cause: ' + exc.getCause() + 'Error Where: ' + exc.getLineNumber());
            throw new AuraHandledException('Something went wrong: '+ exc.getMessage());
        }
         return createneworaddrecipientv2responsebean.serialize(createneworaddrecipientv2responsebean);
    }
}