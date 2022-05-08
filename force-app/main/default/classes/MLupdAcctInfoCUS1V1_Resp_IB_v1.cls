/** 
 * @description Response Integration Bean for MLupdAcctInfoforCUS1V1Service Service
 * @author Simangaliso Mathenjwa
 * @created 16 May 2021 
 * @updated Koketso Mpshane 08-06-2021
 */
public  class MLupdAcctInfoCUS1V1_Resp_IB_v1 extends Base_IB {
    
    @AuraEnabled public String status;
    @AuraEnabled public Integer statusCode;
    @AuraEnabled public String message;
    
    @AuraEnabled public MLB855O MLB855O;
	@AuraEnabled public NBSAPDPO NBSAPDPO;
	@AuraEnabled public NBSMSGO3_Z NBSMSGO3;
	@AuraEnabled public String errorMessage;

    /**
	* @description NBSMSGO3_Z class
	*/
    public class NBSMSGO3_Z {
		@AuraEnabled public NBSMSGO3 NBSMSGO3;
	}

    /**
	* @description MLB855O class
	*/
	public class MLB855O {
		@AuraEnabled public MLB855O_OUTPUT_AREA MLB855O_OUTPUT_AREA;
	}

    /**
	* @description NBSAPLO class
	*/
	public class NBSAPLO {
		@AuraEnabled public Integer NBNAPLO_REASON_CODE;
		@AuraEnabled public Integer NBNAPLO_RETURN_CODE;
	}

    /**
	* @description NBSAPLO class
	*/
	public class NBSAPDPO {
		@AuraEnabled public NBSAPLO NBSAPLO;
	}

    /**
	* @description MLB855O_OUTPUT_AREA class
	*/
	public class MLB855O_OUTPUT_AREA {
		@AuraEnabled public Integer MLB855O_RETURN_CODE;
		@AuraEnabled public String returnCodeTranslated;
	}

    /**
	* @description NBSMSGO3 class
	*/
	public class NBSMSGO3 {
		@AuraEnabled public Integer NBNMSGO3_NBR_USER_ERRS;
		@AuraEnabled public String NBSMSGO3_VERSION;
		@AuraEnabled public String NBNMSGO3_SYS_ERR_TXT;
		@AuraEnabled public Integer NBNMSGO3_NBR_USER_MSGS;
		@AuraEnabled public List<NBNMSGO3_MSG_ENTRY> NBNMSGO3_MSG_ENTRY;
	}

    /**
	* @description NBNMSGO3_MSG_ENTRY class
	*/
	public class NBNMSGO3_MSG_ENTRY {
		@AuraEnabled public String NBNMSGO3_MSG_ERR_IND;
		@AuraEnabled public String NBNMSGO3_MSG_TXT;
		@AuraEnabled public String NBNMSGO3_MSG_CLASS;
		@AuraEnabled public String NBNMSGO3_MSG_CODE;
	}
}