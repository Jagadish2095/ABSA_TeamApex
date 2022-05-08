/*
 * Request Integration Bean for PRICreationByCommSystem Service
 * @author Poulami Banerjee
 * @created 2021-28-06
 */

public class PRICreationByCommSystem_Req_IB_v1 extends Base_IB {
	
    public class PRIHistory {
		public String PRIStatus;
		public String PRIStatusCode;
		public String RejectionDescription;
		public String RejectionInfo;
		public String Timestamp;
	}
    
	public class ListOfPRI {
		//public List<PRI> PRI;
		public PRI PRI;
	}
	
	public class InsertOrUpdatePRI {
		public SiebelMessage SiebelMessage;
	}

	public Request Request;

	public class Header {
		public String Source;
		public String MessageId;
		public String TransactionId;
		public String ComponentName;
		public String Action;
		public String Version;
	}
	
	public class Message {
		public InsertOrUpdatePRI InsertOrUpdatePRI;
	}
	
	public class PRI {
		public String Created;
		public String Searchspec;
		public String Category;
		public String CommissionBrokerCode;
		public String CommissionInflationPercent;
		public String CommissionPaymentDate;
		public String CommissionPaymentMethod;
		public String CommissionPaymentMethodCode;
		public String ContactId;
		public String DealerCode;
		public String ExpectedCommission;
		public String FINSProduct;
		public String FINSProductCode;
		public String FinancialAccountNumber;
		public String InceptionDate;
		public String LineofBusiness;
		public String ManuallyCreatedFlag;
		public String PRINumber;
		public String PRIStatus;
		public String PRIStatusCode;
		public String PolicyBusinessType;
		public String PolicyNumber;
		public String PolicyType;
		public String PolicyTypeCode;
		public String PremiumFrequency;
		public String PremiumFrequencyCode;
		public String PreviousPRIStatusCode;
		public String ProductProviderCode;
		public String ProductProviderName;
		public String ProposalNumber;
		public String RejectionInformation;
		public String RejectionReason;
		public String SourceCode;
		public String SubmittedFlag;
		public String PolicyIncomeType;
		public String PolicyIncomeTypeCode;
		public String LeadId;
		public String CIFCode;
		public String CASClientFirstName;
		public String CASClientID;
		public String CASClientIDNumber;
		public String CASClientIDType;
		public String CASClientLastName;
		public ListOfPRI_Position ListOfPRI_Position;
		public Object ListOfPRI_Account;
		public ListOfPRI_Contact ListOfPRI_Contact;
		//public Object ListOfPRIShareInformation;
		public Object ListOfPRIHistory;
	}

	public class Request {
		public Header Header;
		public Message Message;
	}

	public class PRI_Position {
		public String Searchspec;
		public String SalesRep;
		public String Name;
		public String ActiveBrokerCode;
	}

	public class PRI_Contact {
		public String Searchspec;
		public String ContactCIFCode;
		public String ContactFirstName;
		public String ContactIdentityInformation;
		public String ContactIdentityType;
		public String ContactLastName;
		public String ContactCellularPhone;
		public String ContactHomePhone;
		public String ContactWorkPhone;
	}

	public class ListOfPRI_Contact {
		public List<PRI_Contact> PRI_Contact;
	}
    
    public class ListOfPRIHistory {
		public List<PRIHistory> PRIHistory;
	}

	public class ListOfPRI_Position {
		public List<PRI_Position> PRI_Position;
	}

	public class SiebelMessage {
		//public ListOfPRI ListOfPRI;
		public List<ListOfPRI> ListOfPRI;
	}

    	public static PRICreationByCommSystem_Req_IB_v1 createDummyRequest() {
        	PRICreationByCommSystem_Req_IB_v1 requestBean = new PRICreationByCommSystem_Req_IB_v1();
        	requestBean.Request = new PRICreationByCommSystem_Req_IB_v1.Request();
			requestBean.Request.Header = new PRICreationByCommSystem_Req_IB_v1.Header();
            requestBean.Request.Message = new PRICreationByCommSystem_Req_IB_v1.Message();
            requestBean.Request.Message.InsertOrUpdatePRI = new PRICreationByCommSystem_Req_IB_v1.InsertOrUpdatePRI();
            requestBean.Request.Message.InsertOrUpdatePRI.SiebelMessage = new PRICreationByCommSystem_Req_IB_v1.SiebelMessage();
            requestBean.Request.Message.InsertOrUpdatePRI.SiebelMessage.ListOfPRI = new List<PRICreationByCommSystem_Req_IB_v1.ListOfPRI>();
            PRICreationByCommSystem_Req_IB_v1.ListOfPRI SinglePRI = new PRICreationByCommSystem_Req_IB_v1.ListOfPRI();
            SinglePRI.PRI = new PRICreationByCommSystem_Req_IB_v1.PRI();
            SinglePRI.PRI.ListOfPRI_Position = new PRICreationByCommSystem_Req_IB_v1.ListOfPRI_Position();
            SinglePRI.PRI.ListOfPRI_Position.PRI_Position = new List<PRICreationByCommSystem_Req_IB_v1.PRI_Position>();
            PRICreationByCommSystem_Req_IB_v1.PRI_Position priposition = new PRICreationByCommSystem_Req_IB_v1.PRI_Position();
            SinglePRI.PRI.ListOfPRI_Contact = new PRICreationByCommSystem_Req_IB_v1.ListOfPRI_Contact();
            SinglePRI.PRI.ListOfPRI_Contact.PRI_Contact = new List<PRICreationByCommSystem_Req_IB_v1.PRI_Contact>();
            PRICreationByCommSystem_Req_IB_v1.PRI_Contact pricontact = new PRICreationByCommSystem_Req_IB_v1.PRI_Contact();
            requestBean.Request.Header.Source = 'Salesforce';
            requestBean.Request.Header.MessageId = '4635-6457-5765-7689';
            requestBean.Request.Header.TransactionId = '66666465354654';
            requestBean.Request.Header.ComponentName = 'Test';
            requestBean.Request.Header.Action = 'InsertOrUpdatePRI';
            requestBean.Request.Header.Version = '1.0';
            SinglePRI.PRI.Created = '';
            SinglePRI.PRI.Searchspec = '';
            SinglePRI.PRI.Category = '';
            SinglePRI.PRI.CommissionBrokerCode = '232930';
            SinglePRI.PRI.CommissionInflationPercent = '';
            SinglePRI.PRI.CommissionPaymentMethod = '';
            SinglePRI.PRI.CommissionPaymentMethodCode = '';
            SinglePRI.PRI.DealerCode = '';
            SinglePRI.PRI.ExpectedCommission = '';
            SinglePRI.PRI.FINSProduct = '';
            SinglePRI.PRI.FINSProductCode = '';
            SinglePRI.PRI.FinancialAccountNumber = '';
            SinglePRI.PRI.InceptionDate = '05/19/2021';
            SinglePRI.PRI.LineofBusiness = '';
            SinglePRI.PRI.ManuallyCreatedFlag = 'N';
            SinglePRI.PRI.PRINumber = '';
            SinglePRI.PRI.PRIStatus = '';
            SinglePRI.PRI.PRIStatusCode = '';
            SinglePRI.PRI.PolicyBusinessType = '';
            SinglePRI.PRI.PolicyNumber = '98575734';
            SinglePRI.PRI.PolicyType = '';
            SinglePRI.PRI.PolicyTypeCode = '';
            SinglePRI.PRI.PremiumFrequency = '';
            SinglePRI.PRI.PremiumFrequencyCode = '';
            SinglePRI.PRI.PreviousPRIStatusCode = '';
            SinglePRI.PRI.ProductProviderCode = '110';
            SinglePRI.PRI.ProductProviderName = '';
            SinglePRI.PRI.ProposalNumber = '00009';
            SinglePRI.PRI.RejectionInformation = '';
            SinglePRI.PRI.RejectionReason = '';
            SinglePRI.PRI.SourceCode = '999999';
            SinglePRI.PRI.SubmittedFlag = '';
            SinglePRI.PRI.PolicyIncomeType = '';
            SinglePRI.PRI.PreviousPRIStatusCode = '';
            SinglePRI.PRI.PolicyIncomeTypeCode = '54';
            SinglePRI.PRI.LeadId = '0067Z00000OJcKLQA1';
            SinglePRI.PRI.CIFCode = '';
            SinglePRI.PRI.CASClientFirstName = '';
            SinglePRI.PRI.CASClientID = '';
            SinglePRI.PRI.CASClientIDNumber = '';
            SinglePRI.PRI.CASClientIDType = '';
            SinglePRI.PRI.CASClientLastName = '';
            //priposition.Searchspec = '';
            //priposition.SalesRep = '';
            //priposition.Name = '';
            //priposition.ActiveBrokerCode = '';
            //SinglePRI.PRI.ListOfPRI_Position.PRI_Position.add(priposition);
            pricontact.Searchspec = '';
            pricontact.ContactCIFCode = 'TESTPT 797';
            pricontact.ContactFirstName = '';
            pricontact.ContactIdentityInformation = '2001015800085';
            pricontact.ContactIdentityType = 'SA Identity Document';
            pricontact.ContactLastName = '';
            pricontact.ContactCellularPhone = '';
            pricontact.ContactHomePhone = '';
            pricontact.ContactWorkPhone = '';
            SinglePRI.PRI.ListOfPRI_Contact.PRI_Contact.add(pricontact);
			requestBean.Request.Message.InsertOrUpdatePRI.SiebelMessage.ListOfPRI.add(SinglePRI);
        	return requestBean;
    }
}