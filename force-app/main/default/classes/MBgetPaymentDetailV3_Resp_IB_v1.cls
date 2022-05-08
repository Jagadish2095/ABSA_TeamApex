/**
* @description Response Integration Bean for MBgetPaymentDetailV3 Service
* @author Chandra bhushan
* @created 2021-03-20

 * @updated 2021-04-09
 */

public class MBgetPaymentDetailV3_Resp_IB_v1 extends Base_IB {
	@AuraEnabled
	public String status;
	@AuraEnabled
	public Integer statusCode;
	@AuraEnabled
	public String message;

    /**
* @description wrapper class MBgetPaymentDetailV3Response
*/
    public class MBgetPaymentDetailV3Response {

		@AuraEnabled
		public Nbsapdpo nbsapdpo;
		@AuraEnabled
		public Nbsmsgo3 nbsmsgo3;
		@AuraEnabled
		public Mbp323o mbp323o;

    }
    /**
* @description wrapper class Nbsapdpo
*/
    public class Nbsapdpo {
        //@AuraEnabled public Object version;

		@AuraEnabled
		public String returnCode;
		@AuraEnabled
		public String reasonCode;
		@AuraEnabled
		public String serviceVersion;
		//@AuraEnabled public Object echoKey;

    }
    /**
* @description wrapper class Payment
*/
    public class Payment {
        //@AuraEnabled public Object instrStatus;
        //@AuraEnabled public Object intExtBenInd;

		@AuraEnabled
		public String actDate;
		@AuraEnabled
		public String trigDate;
		@AuraEnabled
		public Decimal amount;
		@AuraEnabled
		public String srcAcc;
		@AuraEnabled
		public String srcAccType;
		@AuraEnabled
		public String srcClrCode;
		@AuraEnabled
		public String srcInstCode;
		@AuraEnabled
		public String srcStmtRef;
		@AuraEnabled
		public String trgAcc;
		@AuraEnabled
		public String trgAccType;
		@AuraEnabled
		public String trgClrCode;
		@AuraEnabled
		public String trgInstCode;
		@AuraEnabled
		public String trgStmtRef;
		@AuraEnabled
		public String corpCode;
		@AuraEnabled
		public String sbu;
		@AuraEnabled
		public String payDay;
		//@AuraEnabled public Object doType;
		//@AuraEnabled public Object cardAuth;
		//@AuraEnabled public Object notifInd;
		@AuraEnabled
		public String srcNotifMed;
		@AuraEnabled
		public String trgNotifMed;
		//@AuraEnabled public Object changeOverride;
		//@AuraEnabled public Object changeOverride2;
		//@AuraEnabled public Object lastMaintOvr2Id;
		@AuraEnabled
		public String paymStatus;
		@AuraEnabled
		public String paymTime;
		@AuraEnabled
		public Decimal paymProcessAmnt;
		@AuraEnabled
		public String paymErrCode;
		@AuraEnabled
		public String iipInd;
		//@AuraEnabled public Object iipAuth;
		@AuraEnabled
		public String busRef;
		//@AuraEnabled public Object paymNotes;
	}

	@AuraEnabled
	public MBgetPaymentDetailV3Response MBgetPaymentDetailV3Response;

    /**
* @description wrapper class Nbsmsgo3
*/
    public class Nbsmsgo3 {
        //@AuraEnabled public Object version;
        //@AuraEnabled public Object sysErrTxt;

		@AuraEnabled
		public String nbrUserMsgs;
		@AuraEnabled
		public String nbrUserErrs;
		@AuraEnabled
		public MsgEntry msgEntry;

    }
    /**
* @description wrapper class PaymentExtraV3
*/
    public class PaymentExtraV3 {

		@AuraEnabled
		public String paymNo;
		@AuraEnabled
		public String branch;
		@AuraEnabled
		public String teller;
		@AuraEnabled
		public String trgBusCode;
		@AuraEnabled
		public Decimal retryAmount;
		@AuraEnabled
		public String nsp1stInstall;
		@AuraEnabled
		public String nsp1stDate;
		@AuraEnabled
		public Decimal nsp2ndInstall;
		@AuraEnabled
		public String nsp2ndDate;

        //@AuraEnabled public Object nsp2ndErrc;
    }
    /**
* @description wrapper class Mbp323o
*/
    public class Mbp323o {

		@AuraEnabled
		public String procMode;
		@AuraEnabled
		public String todaysDate;
		@AuraEnabled
		public String timeNow;
		@AuraEnabled
		public String respCode;
		@AuraEnabled
		public String respOther;
		@AuraEnabled
		public String recsReturn;
		@AuraEnabled
		public String respDesc;
		//@AuraEnabled public Object fwWarnInd;
		@AuraEnabled
		public List<Payment> payment;
		@AuraEnabled
		public List<PaymentExtraV3> paymentExtraV3;

    }
    /**
* @description wrapper class MsgEntry
*/
    public class MsgEntry {
        //@AuraEnabled public Object msgClass;
        //@AuraEnabled public Object msgCode;
        //@AuraEnabled public Object msgErrInd;
        //@AuraEnabled public Object msgTxt;
    }


}