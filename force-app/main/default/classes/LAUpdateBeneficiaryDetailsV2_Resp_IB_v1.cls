/*
 * Response Integration Bean for LAupdateBeneficiaryDetailsV2 Service
 * @author Nelson Chisoko
 * @created 2020-10-15
 */
public class LAUpdateBeneficiaryDetailsV2_Resp_IB_v1 extends Base_IB {

    @AuraEnabled public String status;
    @AuraEnabled public Integer statusCode;
    @AuraEnabled public String message;

    public class Nbsapdpo {
        // public Object echoKey;
        @AuraEnabled public Integer reasonCode;
        @AuraEnabled public Integer returnCode;
        // public Object serviceVersion;
        // public Object version;
    }

    public class LAupdateBeneficiaryDetailsV2Response {
        @AuraEnabled public La950p9o la950p9o;
        @AuraEnabled public Nbsapdpo nbsapdpo;
    }

    @AuraEnabled public LAupdateBeneficiaryDetailsV2Response LAupdateBeneficiaryDetailsV2Response;

    public class La950p9o {
        @AuraEnabled public String effectiveDate;
        @AuraEnabled public String errorDescription;
        @AuraEnabled public Long policyNumber;
        @AuraEnabled public String responseDescription;
        @AuraEnabled public Integer responseNumber;
    }
}