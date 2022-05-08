/**
 * @description Response Integration Bean for DealerVerification Service
 * @author manideep kenche
 * @created 2021-10-15
 * @work W-014039
 */
public class AuthenticateDealer_Resp_IB_v1 extends Base_IB {
    @AuraEnabled
    public BAPI_SF_DLR_DETAILS BAPI_SF_DLR_DETAILS;
    /**
   * @description BAPI_SF_DLR_DETAILS
   */
    public class BAPI_SF_DLR_DETAILS {
        @AuraEnabled
        public E_DLR_DETAILS E_DLR_DETAILS;
        public Integer E_RESPONSE;	
        public String E_RESPONSE_DESC;	
    }
    /**
   * @description E_DLR_DETAILS
   */
    public class E_DLR_DETAILS {
        public String PARTNER;
        @AuraEnabled
        public String NAME_ORG1;	
        @AuraEnabled
        public String DEALER_TELEPHONE;
        @AuraEnabled
        public String STREET1;	
        @AuraEnabled
        public String STREET2;
        @AuraEnabled
        public String CITY1;
        @AuraEnabled
        public CITY2 CITY2;
        @AuraEnabled
        public String POST_CODE;
        @AuraEnabled
        public String REGION;
        @AuraEnabled
        public String COUNTRY;
        @AuraEnabled
        public String ZAPPROVED_IND;
        @AuraEnabled
        public NOTES NOTES;
    }
   
    /**
   * @description CITY2
   */
    public class CITY2 {
    }
    /**
   * @description NOTES
   */
    public class NOTES {
    }
}