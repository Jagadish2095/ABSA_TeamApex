/*
 * Request Integration Bean for InsertOrUpdatePRICASA Service
 * @author
 * @updated 2019-03-16 - Pitso (InceptionDate addition)
 * @updated 2019-10-10 - Vladimir (5 new priContact fields)
 */
/**
 * @description InsertOrUpdatePRICASA_Req_IB_v1 Description
 *
 */
public class InsertOrUpdatePRICASA_Req_IB_v1 extends Base_IB {
	public cls_InsertOrUpdatePRICASA_Input InsertOrUpdatePRICASA_Input;
	/**
	 * @description cls_InsertOrUpdatePRICASA_Input Description
	 *
	 */
	public class cls_InsertOrUpdatePRICASA_Input {
		public cls_ListOfPRI ListOfPRI;
		public cls_OperationalDetail OperationalDetail;
	}

	/**
	 * @description cls_ListOfPRI Description
	 *
	 */
	public class cls_ListOfPRI {
		public cls_PRI[] PRI;
	}
	/**
	 * @description cls_PRI Description
	 *
	 */
	public class cls_PRI {
		public String CommissionBrokerCode;
		public String ExpectedCommission;
		public String PolicyIncomeTypeCode;
		public String InceptionDate;
		public String ProductProviderCode;
		public String PolicyNumber;
		public String SourceCode;
		public String ProposalNumber;
		public cls_ListOfPRI_contact ListOfPRI_Contact;
	}
	/**
	 * @description cls_ListOfPRI_contact
	 *
	 */
	public class cls_ListOfPRI_contact {
		public cls_PRI_Contact[] PRI_Contact;
	}
	/**
	 * @description cls_PRI_Contact Description
	 *
	 */
	public class cls_PRI_Contact {
		public String IsPrimaryMVG;
		public String ContactIdenInformation;
		public String ContactIdenType;
		//Vladimir start
		public String ContactFirstName;
		public String ContactLastName;
		public String ContactHomePhone;
		public String ContactWorkPhone;
		public String ContactMobilePhone;
		//Vladimir end
		//added prnav
		public String ContactBirthDate;
	}
	/**
	 * @description cls_OperationalDetail Description
	 *
	 */
	public class cls_OperationalDetail {
		public String BusinessProcess;
		public String CASAAnalystComments;
		public String CASAReferenceNumber;
		public String CASAScreeningDate;
		public String CASAScreeningStatus;
		public String RiskProfilingDate;
		public String RiskProfilingStatus;
		public String Source;
	}
	/**
	 * @description createDummyRequest description
	 *
	 */
	public void createDummyRequest() {
		cls_PRI_Contact priContact = new cls_PRI_Contact();
		priContact.IsPrimaryMVG = 'Y';
		priContact.ContactIdenInformation = '7507080190082';
		priContact.ContactIdenType = 'SA Identity Document';
		List<cls_PRI_Contact> priContactList = new List<cls_PRI_Contact>();
		priContactList.add(priContact);

		cls_ListOfPRI_contact listOfPriCls = new cls_ListOfPRI_contact();
		listOfPriCls.PRI_Contact = priContactList;

		cls_PRI pri = new cls_PRI();
		pri.CommissionBrokerCode = '900028';
		pri.ExpectedCommission = '100';
		pri.PolicyIncomeTypeCode = '1';
		pri.InceptionDate = '03/15/2019';
		pri.ProductProviderCode = '002';
		pri.PolicyNumber = '6521143141';
		pri.SourceCode = '999999';
		pri.ListOfPRI_Contact = listOfPriCls;
		List<cls_PRI> priList = new List<cls_PRI>();
		priList.add(pri);

		cls_ListOfPRI priListCls = new cls_ListOfPRI();
		priListCls.PRI = priList;

		cls_OperationalDetail operationalDetail = new cls_OperationalDetail();
		operationalDetail.BusinessProcess = 'Estate Provider Plan';
		operationalDetail.CASAAnalystComments = 'Analyst comments';
		operationalDetail.CASAReferenceNumber = '1796633';
		operationalDetail.CASAScreeningDate = '2018-05-15 13:20:09';
		operationalDetail.CASAScreeningStatus = 'Approved';
		operationalDetail.RiskProfilingDate = '2018-09-05 13:20:19';
		operationalDetail.RiskProfilingStatus = 'Low';
		operationalDetail.Source = 'Salesforce';

		cls_InsertOrUpdatePRICASA_Input PRICASA = new cls_InsertOrUpdatePRICASA_Input();
		PRICASA.ListOfPRI = priListCls;
		PRICASA.OperationalDetail = operationalDetail;

		this.InsertOrUpdatePRICASA_Input = PRICASA;
		//InsertOrUpdatePRICASA_Req_IB_v1 bean = new InsertOrUpdatePRICASA_Req_IB_v1();
		//bean.InsertOrUpdatePRICASA_Input = PRICASA;

		System.debug('bean: ' + this);
	}
}