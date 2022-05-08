/*
 * Response bean for LAupdateBankingDetailsV3 response
 * @author Humbelani Denge
 * @created 2020-10-09
 */
public class LAupdateBankingDetailsV3_Resp_IB_v1 extends Base_IB{
    @AuraEnabled public String status;
    @AuraEnabled public Integer statusCode;
    @AuraEnabled public String message;

    public class Nbsapdpo {
       @AuraEnabled public String echoKey;
       @AuraEnabled public Integer reasonCode;
       @AuraEnabled public Integer returnCode;
       //@AuraEnabled public Object serviceVersion;
       //@AuraEnabled public Object version;
    }

    @AuraEnabled public LAupdateBankingDetailsV3Response LAupdateBankingDetailsV3Response;

    public class LAupdateBankingDetailsV3Response {
       @AuraEnabled public La950p5o la950p5o;
       @AuraEnabled public Nbsapdpo nbsapdpo;
    }

    public class La950p5o {
       @AuraEnabled public String effectiveDate;
       @AuraEnabled public String errorDescription;
       @AuraEnabled public String policyNumber;
       @AuraEnabled public String responseDescription;
       @AuraEnabled public String responseNumber;
    }
}