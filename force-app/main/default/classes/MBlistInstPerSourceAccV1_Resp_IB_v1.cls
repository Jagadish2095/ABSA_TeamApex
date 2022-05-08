/**
* @description Response Integration Bean for MBlistInstructionsPerSourceAccV1 Service
* @author Chandra bhushan
* @created 2020-03-12
*/

public class MBlistInstPerSourceAccV1_Resp_IB_v1 extends Base_IB {

	@AuraEnabled public String status;
    @AuraEnabled public Integer statusCode;
    @AuraEnabled public String message;

	@AuraEnabled public NBSAPDPO NBSAPDPO;
	@AuraEnabled public NBSMSGO3 NBSMSGO3;
	@AuraEnabled public MBS326O MBS326O;

	/**
	 * @description OutputHeaders class
	 */
	public class OutputHeaders {
		@AuraEnabled public String serviceVersion;
		@AuraEnabled public Integer returnCode;
		@AuraEnabled public Integer reasonCode;
	}

	/**
	 * @description OutputCopybook class
	 */
	public class OutputCopybook {
		@AuraEnabled public Integer responseOther;
		@AuraEnabled public Integer maxRetrieve;
		@AuraEnabled public Integer timeNow;
		@AuraEnabled public String channel;
		@AuraEnabled public Integer altTieb;
		@AuraEnabled public Integer responseCode;
		@AuraEnabled public String origType;
		@AuraEnabled public String origStatus;
		@AuraEnabled public Integer todaysDate;
		@AuraEnabled public String responseDescription;
		@AuraEnabled public Integer tacAccountCount;
		@AuraEnabled public List<InstructionTable> instructionTable;
		@AuraEnabled public Integer recsReturn;
		@AuraEnabled public String accessAccount;
	}

	/**
	 * @description NBSAPDPO class
	 */
	public class NBSAPDPO {
		@AuraEnabled public OutputHeaders outputHeaders;
	}

	/**
	 * @description NBSMSGO3 class
	 */
	public class NBSMSGO3 {
		@AuraEnabled public OutputErrorMessage outputErrorMessage;
	}

	/**
	 * @description InstructionTable class
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
		@AuraEnabled public String instrRefName;
		@AuraEnabled public String priNumber;
		@AuraEnabled public String lastMaintTeller;
		@AuraEnabled public String instrNumber;
		@AuraEnabled public String payDay;
		@AuraEnabled public String targetAccount;
		@AuraEnabled public String startDate;
	}

	/**
	 * @description OutputErrorMessage class
	 */
	public class OutputErrorMessage {
		@AuraEnabled public Integer numberUserErrors;
		@AuraEnabled public Integer numberUserMessages;
	}

	/**
	 * @description MBS326O class
	 */
	public class MBS326O {
		@AuraEnabled public OutputCopybook outputCopybook;
	}

    /**
	 * @description setIntegrationTranslations method for translation mapping
	 */
    public override void setIntegrationTranslations(){
        integrationTranslationsMap = new Map<String,String>();
        integrationTranslationsMap.put('MBS326O.outputCopybook.instructionTable.targetAccountType', 'CIF;Account Type');
    }

}