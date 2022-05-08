/**
 * @description       : Integration Response bean for GetExposures service
 * @author            : Himani Joshi
 * @last modified on  : 2021-06-11
 * @last modified by  : Himani Joshi
 * Modifications Log 
 * Ver   Date         Author         Modification
 * 1.0   2021-06-10   Himani Joshi   Initial Version
**/

public class GetExposures_Resp_IB_v1 extends Base_IB{
    @AuraEnabled public String status;
    @AuraEnabled public Integer statusCode;
    @AuraEnabled public String message;

    public GSB001O_Z GSB001O;
    public NBSAPDPO NBSAPDPO;
    public NBSMSGO3_Z NBSMSGO3;
    /**
 * @description       : Class GSB001O_Z
 * @author            : Himani Joshi
 **/
    public class GSB001O_Z {
        public GSB001O GSB001O;
    }
     /**
 * @description       : class GSB001O
 * @author            : Himani Joshi
 **/
    public class GSB001O {
        public GSB001O_OUTPUT_FIELDS GSB001O_OUTPUT_FIELDS;
    }
     /**
 * @description       : class GSB001O_OUTPUT_FIELDS
 * @author            : Himani Joshi
 **/
    public class GSB001O_OUTPUT_FIELDS {
        public Long controlOffNum;
        public Long participationBond;
        public String clientName;
        public Long termDeposits;
        public Long mortgagePrePaid;
        public Long overControlSite;
        public Long cpfPrePaid;
        public String custInvAccInd;
        public Long controlBranch;
        public String contOffEmployeeName;
        public String riskGradeOrig;
        public String worstArmsRisk;
        public String cheqInCredit;
        public Long savings;
        public Long custInvestAcc;
        public Long otherCash;
        public String worstArmsHold;
        public String contOffEmployeeNum;
        public String armsEwlStatus;
        public Long fleetInCredit;
        public Long noticeDeposits;
        public Long pensBackPrePaid;
        public String otherCashTrea;
        public Long fleetCashAdvance;
        public String controlOff;
        public Long afcInCredit;
        public Long noOfOccurences;
        public List<ProdDetail> prodDetail;
        public Long creditCard;
        public String riskGrade;
    }
     /**
 * @description       : class ProdDetail
 * @author            : Himani Joshi
 **/
    public class ProdDetail {
        public Long excessArrears;
        public String productOrTotal;
        public Long exposure;
        public Long liability;
        public Long installment;
        public Long limit_Z;// in json: limit
        public String subHeaderInd;
        public String arrearsInd;
        public Long prodAreaLimit;
    }
     /**
 * @description       : Property NBSMSGO3_Z
 * @author            : Himani Joshi
 **/
    public class NBSMSGO3_Z {
        public NBSMSGO3 NBSMSGO3;
    }
     /**
 * @description       : Property NBSAPDPO
 * @author            : Himani Joshi
 **/
    public class NBSAPDPO {
        public NBSAPLO NBSAPLO;
    }
     /**
 * @description       : Property NBSAPLO
 * @author            : Himani Joshi
 **/
    public class NBSAPLO {
        public String NBNAPLO_ECHO_KEY;
        public Integer NBNAPLO_REASON_CODE;
        public Integer NBNAPLO_RETURN_CODE;
        public String NBNAPLO_VERSION;
        public String NBNAPLO_SERVICE_VERSION;
    }
     /**
 * @description       : Property NBSMSGO3
 * @author            : Himani Joshi
 **/
    public class NBSMSGO3 {
        public Integer NBNMSGO3_NBR_USER_ERRS;
        public String NBSMSGO3_VERSION;
        public String NBNMSGO3_SYS_ERR_TXT;
        public Integer NBNMSGO3_NBR_USER_MSGS;
        public List<NBNMSGO3_MSG_ENTRY> NBNMSGO3_MSG_ENTRY;
    }
     /**
 * @description       : Property NBNMSGO3_MSG_ENTRY
 * @author            : Himani Joshi
 **/
    public class NBNMSGO3_MSG_ENTRY {
        public String NBNMSGO3_MSG_ERR_IND;
        public String NBNMSGO3_MSG_TXT;
        public String NBNMSGO3_MSG_CLASS;
        public String NBNMSGO3_MSG_CODE;
    }
     /**
 * @description       : Method to set field names
 * @author            : Himani Joshi
 **/
    public override void setFieldNameSubstitutions() {
        fieldNameSubstitutionMap = new Map<String, String>();
        fieldNameSubstitutionMap.put('"limit":', '"limit_z":');
    }
}