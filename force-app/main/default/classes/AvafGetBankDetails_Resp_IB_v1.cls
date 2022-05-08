/*
 * Response Integration Bean for AvafGetBankDetails Service
 * @author Humbelani Denge
 * @created 2020-11-19
 */
public class AvafGetBankDetails_Resp_IB_v1 extends Base_IB {
    @AuraEnabled public String status;
    @AuraEnabled public Integer statusCode;
    @AuraEnabled public String message;

    @AuraEnabled public BAPI_BUPA_BANKDETAILS_GET BAPI_BUPA_BANKDETAILS_GET;

    public class BANKDETAILS {
        @AuraEnabled public String BANKDETAILID;
        @AuraEnabled public String BANK_CTRY;
        @AuraEnabled public String BANK_KEY;
        @AuraEnabled public String CTRL_KEY;
        @AuraEnabled public String BANK_ACCT;

        // @AuraEnabled public Object BANK_REF;
        // @AuraEnabled public Object ACCOUNTHOLDER;
        // @AuraEnabled public Object BANKACCOUNTNAME;
        // @AuraEnabled public Object BANKACCOUNTTYPE;

    }

    public class BAPI_BUPA_BANKDETAILS_GET {
        @AuraEnabled public List<BANKDETAILS> BANKDETAILS;
    }
}