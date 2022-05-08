/*
 * Request Integration Bean for TransunionProcessRequest41 Service
 * @author Prashant Jain
 * @created 2020-05-20
*--------------------------------------
* @Updated By - Pitso Sekhu
* @Updated Date- 2021-03-18
* @Update Notes - Changes to EnquirerContactPhoneNo & EnquirerContactName from Hard coded value to Custom Label
*--------------------------------------
*/

public class TransunionProcessRequest41_Req_IB_v1 extends Base_IB {

	public ProcessRequestTrans41 ProcessRequestTrans41;

	public class ProcessRequestTrans41 {
		public BureauEnquiry41 BureauEnquiry41;
		public String Destination;
	}

	public class BureauEnquiry41 {
		public String ClientRequestID;
		public String SubscriberCode;
		public String ClientReference;
		public String BranchNumber;
		public String BatchNumber;
		public String SecurityCode;
		public String EnquirerContactName;
		public String EnquirerContactPhoneNo;
		public String EnquiryAmount;
		public String EnquiryType;
		public String Surname;
		public String Forename1;
		public String Forename2;
		public String Forename3;
		public String MaidenName;
		public String BirthDate;
		public String IdentityNo1;
		public String IdentityNo2;
		public String Sex;
		public String Title;
		public String MaritalStatus;
		public String NoOfDependants;
		public String AddressLine1;
		public String AddressLine2;
		public String Suburb;
		public String City;
		public String PostalCode;
		public String ProvinceCode;
		public String Address1Period;
		public String OwnerTenant;
		public String HomeTelCode;
		public String HomeTelNo;
		public String WorkTelCode;
		public String WorkTelNo;
		public String SpouseForename1;
		public String SpouseForename2;
		public String Address2Line1;
		public String Address2Line2;
		public String Address2Suburb;
		public String Address2City;
		public String Address2PostalCode;
		public String Address2ProvinceCode;
		public String Address2Period;
		public String Occupation;
		public String Employer;
		public String EmploymentPeriod;
		public String Salary;
		public String BankName;
		public String BankBranch;
		public String BankBranchCode;
		public String BankAccountNumber;
		public String OperatorIdentity;
		public String CellNo;
		public String EmailAddress;
	}

    public static TransunionProcessRequest41_Req_IB_v1 createDummyRequest() {
        TransunionProcessRequest41_Req_IB_v1 requestBean = new TransunionProcessRequest41_Req_IB_v1();
		requestBean.ProcessRequestTrans41 = new TransunionProcessRequest41_Req_IB_v1.ProcessRequestTrans41();
		requestBean.ProcessRequestTrans41.BureauEnquiry41 = new TransunionProcessRequest41_Req_IB_v1.BureauEnquiry41();
		requestBean.ProcessRequestTrans41.Destination = 'Test';

		requestBean.ProcessRequestTrans41.BureauEnquiry41.ClientRequestID = '200310080706859';
		requestBean.ProcessRequestTrans41.BureauEnquiry41.SubscriberCode = '99761';
		requestBean.ProcessRequestTrans41.BureauEnquiry41.ClientReference = 'GN201910061';
		requestBean.ProcessRequestTrans41.BureauEnquiry41.BranchNumber = '';
		requestBean.ProcessRequestTrans41.BureauEnquiry41.BatchNumber = '';
		requestBean.ProcessRequestTrans41.BureauEnquiry41.SecurityCode = 'ABS61';
		requestBean.ProcessRequestTrans41.BureauEnquiry41.EnquirerContactName = 'Absa';
		requestBean.ProcessRequestTrans41.BureauEnquiry41.EnquirerContactPhoneNo = '0860111222';
		requestBean.ProcessRequestTrans41.BureauEnquiry41.EnquiryAmount = '';
		requestBean.ProcessRequestTrans41.BureauEnquiry41.EnquiryType = '';
		requestBean.ProcessRequestTrans41.BureauEnquiry41.Surname = 'NAIDOO';
		requestBean.ProcessRequestTrans41.BureauEnquiry41.Forename1 = 'ARMUGAM';
		requestBean.ProcessRequestTrans41.BureauEnquiry41.Forename2 = '';
		requestBean.ProcessRequestTrans41.BureauEnquiry41.Forename3 = '';
		requestBean.ProcessRequestTrans41.BureauEnquiry41.MaidenName = '';
		requestBean.ProcessRequestTrans41.BureauEnquiry41.BirthDate = '19541112';
		requestBean.ProcessRequestTrans41.BureauEnquiry41.IdentityNo1 = '5411129249086';
		requestBean.ProcessRequestTrans41.BureauEnquiry41.IdentityNo2 = '';
		requestBean.ProcessRequestTrans41.BureauEnquiry41.Sex = '';
		requestBean.ProcessRequestTrans41.BureauEnquiry41.Title = '';
		requestBean.ProcessRequestTrans41.BureauEnquiry41.MaritalStatus = '';
		requestBean.ProcessRequestTrans41.BureauEnquiry41.NoOfDependants = '';
		requestBean.ProcessRequestTrans41.BureauEnquiry41.AddressLine1 = '270 Republic Road';
		requestBean.ProcessRequestTrans41.BureauEnquiry41.AddressLine2 = '';
		requestBean.ProcessRequestTrans41.BureauEnquiry41.Suburb = '';
		requestBean.ProcessRequestTrans41.BureauEnquiry41.City = 'Johannesburg';
		requestBean.ProcessRequestTrans41.BureauEnquiry41.PostalCode = '2001';
		requestBean.ProcessRequestTrans41.BureauEnquiry41.ProvinceCode = '';
		requestBean.ProcessRequestTrans41.BureauEnquiry41.Address1Period = '';
		requestBean.ProcessRequestTrans41.BureauEnquiry41.OwnerTenant = '';
		requestBean.ProcessRequestTrans41.BureauEnquiry41.HomeTelCode = '';
		requestBean.ProcessRequestTrans41.BureauEnquiry41.HomeTelNo = '';
		requestBean.ProcessRequestTrans41.BureauEnquiry41.WorkTelCode = '';
		requestBean.ProcessRequestTrans41.BureauEnquiry41.WorkTelNo = '';
		requestBean.ProcessRequestTrans41.BureauEnquiry41.SpouseForename1 = '';
		requestBean.ProcessRequestTrans41.BureauEnquiry41.SpouseForename2 = '';
		requestBean.ProcessRequestTrans41.BureauEnquiry41.Address2Line1 = '';
		requestBean.ProcessRequestTrans41.BureauEnquiry41.Address2Line2 = '';
		requestBean.ProcessRequestTrans41.BureauEnquiry41.Address2Suburb = '';
		requestBean.ProcessRequestTrans41.BureauEnquiry41.Address2City = '';
		requestBean.ProcessRequestTrans41.BureauEnquiry41.Address2PostalCode = '';
		requestBean.ProcessRequestTrans41.BureauEnquiry41.Address2ProvinceCode = '';
		requestBean.ProcessRequestTrans41.BureauEnquiry41.Address2Period = '';
		requestBean.ProcessRequestTrans41.BureauEnquiry41.Occupation = '';
		requestBean.ProcessRequestTrans41.BureauEnquiry41.Employer = '';
		requestBean.ProcessRequestTrans41.BureauEnquiry41.EmploymentPeriod = '';
		requestBean.ProcessRequestTrans41.BureauEnquiry41.Salary = '';
		requestBean.ProcessRequestTrans41.BureauEnquiry41.BankName = '';
		requestBean.ProcessRequestTrans41.BureauEnquiry41.BankBranch = '';
		requestBean.ProcessRequestTrans41.BureauEnquiry41.BankBranchCode = '';
		requestBean.ProcessRequestTrans41.BureauEnquiry41.BankAccountNumber = '';
		requestBean.ProcessRequestTrans41.BureauEnquiry41.OperatorIdentity = '';
		requestBean.ProcessRequestTrans41.BureauEnquiry41.CellNo = '';
		requestBean.ProcessRequestTrans41.BureauEnquiry41.EmailAddress = '';

        return requestBean;
    }
}