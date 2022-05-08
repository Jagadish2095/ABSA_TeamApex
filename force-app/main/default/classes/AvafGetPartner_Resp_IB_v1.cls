/*
 * Response Integration Bean for AvafGetPartner Service
 * @author Danie Booysen
 * @created 2020-11-18
 */
public class AvafGetPartner_Resp_IB_v1 extends Base_IB{

    @AuraEnabled public String status;
    @AuraEnabled public Integer statusCode;
    @AuraEnabled public String message;

    @AuraEnabled public BAPI_SF_PARTNER_GET[] BAPI_SF_PARTNER_GET;

    public class BAPI_SF_PARTNER_GET{
        @AuraEnabled public String E_SOLD_TO;
        @AuraEnabled public String E_ABSA_BRANCH;
        @AuraEnabled public String E_ALLIANCE;
        @AuraEnabled public String E_DATA_CAPTURER;
        @AuraEnabled public String E_MAIN_DEALER;
        @AuraEnabled public String E_MAIN_LIFE;
        @AuraEnabled public String E_MARKETER;
        @AuraEnabled public String E_SALESPERSON;
        @AuraEnabled public String E_SCHEMES;
        @AuraEnabled public String E_SENIOR_CONTROLLER;
        @AuraEnabled public String E_RESPONSE;
        @AuraEnabled public String E_RESPONSE_DESC;
    }
}