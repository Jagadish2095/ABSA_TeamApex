/**
 * @description Integration Response Bean for EBSBeneficiaries Service
 * @author Koketso Mpshane
 * @created 2021-07-19
 */
public class EBSBeneficiaries_Resp_IB_v1 extends Base_IB {
    
    @AuraEnabled public String status;
    @AuraEnabled public Integer statusCode;
    @AuraEnabled public String message;
    
    @AuraEnabled public EbsBeneficiariesResponse ebsBeneficiariesResponse;
	@AuraEnabled public Boolean error;
	@AuraEnabled public List<ErrorList> errorList;
	@AuraEnabled public Object additionalInfo;
    
	/**
	 * @description wrapper class OutputCopybook
	 */
	public class OutputCopybook {
		@AuraEnabled public String responseOther;
		@AuraEnabled public String maxRetrieve;
		@AuraEnabled public String timeNow;
		@AuraEnabled public String channel;
		@AuraEnabled public String altTieb;
		@AuraEnabled public String responseCode;
		@AuraEnabled public String origType;
		@AuraEnabled public String origStatus;
		@AuraEnabled public String todaysDate;
		@AuraEnabled public String responseDescription;
		@AuraEnabled public String tacAccountCount;
		@AuraEnabled public List<InstructionTable> instructionTable;
		@AuraEnabled public String accessAccount;
		@AuraEnabled public Integer recsReturn;
	}
	/**
	 * @description wrapper class ErrorList
	 */
	public class ErrorList {
        @AuraEnabled public String field;
		@AuraEnabled public String description;
	}
	/**
	 * @description wrapper class NBSMSGO3
	 */
	public class NBSMSGO3 {
		@AuraEnabled public OutputErrorMessage outputErrorMessage;
	}
	/**
	 * @description wrapper class InstructionTable
	 */
	public class InstructionTable {
		@AuraEnabled public String targetBusinessCode;
		@AuraEnabled public String endDate;
		@AuraEnabled public String sourceClrCode;
		@AuraEnabled public String uniqueEFT;
		@AuraEnabled public String targetStatementRef;
		@AuraEnabled public String ivrNominate;
		@AuraEnabled public String sourceInstCode;
		@AuraEnabled public String sourceStatementRef;
		@AuraEnabled public String actDate;
		@AuraEnabled public String frequency;
		@AuraEnabled public String mandNumber;
		@AuraEnabled public String clientType;
		@AuraEnabled public String lastMaintDate;
		@AuraEnabled public String cifKey;
		@AuraEnabled public String targetAccountType;
		@AuraEnabled public String timeRange;
		@AuraEnabled public String iipAllowIndicator;
		@AuraEnabled public String amount;
		@AuraEnabled public String freeBankIndicator;
		@AuraEnabled public String tieb;
		@AuraEnabled public String sourceAccount;
		@AuraEnabled public String instrStatus;
		@AuraEnabled public String instrType;
		@AuraEnabled public String multiNumber;
		@AuraEnabled public String targetInstCode;
		@AuraEnabled public String intExtBenIndicator;
		@AuraEnabled public String targetClrCode;
		@AuraEnabled public String priNumber;
		@AuraEnabled public String lastMaintTeller;
		@AuraEnabled public String instrNumber;
		@AuraEnabled public String payDay;
		@AuraEnabled public String targetAccount;
		@AuraEnabled public String startDate;
	}
	/**
	 * @description wrapper class OutputErrorMessage
	 */
	public class OutputErrorMessage {
		@AuraEnabled public Integer numberUserErrors;
		@AuraEnabled public Integer numberUserMessages;
		@AuraEnabled public Object errorMessageTable;
	}
	/**
	 * @description wrapper class EbsBeneficiariesResponse
	 */
	public class EbsBeneficiariesResponse {
		@AuraEnabled public MBS326O MBS326O;
		@AuraEnabled public NBSMSGO3 NBSMSGO3;
	}
	/**
	 * @description wrapper class MBS326O
	 */
	public class MBS326O {
		@AuraEnabled public OutputCopybook outputCopybook;
	}

}