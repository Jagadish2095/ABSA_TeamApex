/**
* @description Response Bean class for the ContractAddComponent
*
* @author  Kabelo Aphane
* @since   16 July 2021
* @updated Koketso Mpshane 12/08/2021
*/
public class ContractAddComponent_Req_IB_v1 extends Base_IB {
	/**
	* @description DependentInformantAddress
	*/
	public class DependentInformantAddress {
		public String AddressLine1;
		public String AddressLine2;
		public Integer AddressTypeID;
		public String CountryID;
		public String PostalCode;
	}
	/**
	* @description V3_DC2_LoggedMsg
	*/
	public class V3_DC2_LoggedMsg {
		public Integer CreatedBy;
		public String CreatedDate;
		public String GID;
		public String Level;
		public Integer LevelID;
		public String Message;
		public Integer MessageID;
		public Integer OverRideLevelID;
		public String OverRideReason;
		public String OverrideLevel;
	}
	/**
	* @description Request
	*/
	public class Request {
		public MemberAdd_Capture_Request MemberAdd_Capture_Request;
	}
	/**
	* @description Contract_Add_Component
	*/
	public class Contract_Add_Component {
		public String pstrSessionGID;
		public String pstrContractGID;
		public Request Request;
		public PcolValidationMessages pcolValidationMessages;
	}
	/**
	* @description Dependent
	*/
	public class Dependent {
		public String Cellphone;
		public String DateOfBirth;
		public DependentInformantAddress DependentInformantAddress;
		public String EmailAddress;
		public String FirstName;
		public Integer GenderID;
		public String IDDescription;
		public Integer IDTypeID;
		public String Surname;
		public Integer TitleID;
	}
	/**
	* @description MemberAdd_Capture_Request
	*/
	public class MemberAdd_Capture_Request {
		public String ClientGID;
		public Integer Cover;
		public Dependent Dependent;
		public Integer ProductID;
		public Integer RelationshipToMainMember;
	}
	/**
	* @description PcolValidationMessages
	*/
	public class PcolValidationMessages {
		public List<V3_DC2_LoggedMsg> V3_DC2_LoggedMsg;
	}

	public Contract_Add_Component Contract_Add_Component;
    
}