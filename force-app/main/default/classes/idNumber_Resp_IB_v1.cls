/*
* Response Integration Bean for idNumber Service for package linking
* @author Satya Boyenepalli
* @created 2021-02-26
*/
public class idNumber_Resp_IB_v1 extends Base_IB {
    public class CreditAccountDetails {
		public String creditAccountNumber;
		public String fiidNumber;
		public String accountType;
		public String productType;
		public String accountStatus;
	}

	public Object customerDetails;
	public Object currentCustomerPackages;
	public List<QualifyingPackages> qualifyingPackages;

	public class AvailablePricingScheme {
		public String pricingSchemeIndicator;
		public String schemeDescription;
		public String schemeCode;
	}

	public class QualifyingProducts {
		public ChequeAccountDetails chequeAccountDetails;
		public CreditAccountDetails creditAccountDetails;
	}

	public class QualifyingPackages {
		public String packageName;
		public QualifyingProducts qualifyingProducts;
		public List<AvailablePricingScheme> availablePricingScheme;
	}

	public class ChequeAccountDetails {
		public Object clientFullName;
		public String accountNumber;
		public String availableBalance;
		public String accountStatus;
		public String accountType;
		public String accountBalance;
	}
    public static idNumber_Resp_IB_v1 dummyResponse(){
        idNumber_Resp_IB_v1 responseBean = new idNumber_Resp_IB_v1();
        responseBean.status='OK';
        responseBean.statusCode=200;
        responseBean.message='SUCCESS';
        idNumber_Resp_IB_v1.ChequeAccountDetails chequeAccountDetails = new  idNumber_Resp_IB_v1.ChequeAccountDetails();
        chequeAccountDetails.clientFullName='satya';
        chequeAccountDetails.accountNumber ='4048286349';
        chequeAccountDetails.availableBalance='1087022.51';
        chequeAccountDetails.accountType ='32';
           chequeAccountDetails.accountBalance='1087022.51';
        chequeAccountDetails.accountStatus='1';
        idNumber_Resp_IB_v1.CreditAccountDetails creditAccountDetails = new   idNumber_Resp_IB_v1.CreditAccountDetails ();
        creditAccountDetails.accountStatus='';
        creditAccountDetails.accountType='';
		return responseBean;
}
}