/**
 * @description: Request Integration Bean for updateLeadDetails service
 * @Author: Mbuyiseni Mbhokane
 * @Since: 28/04/2021
 */
@SuppressWarnings('PMD')
public class UpdateLeadDetails_Req_IB_v1 extends Base_IB{

	public class Addresses {
		public String addressLine1;
		public String addressLine2;
		public String addressType;
		public String city;
		public String isPrimaryMVG;
		public String postalCode;
		public String suburb;
	}

	public List<Addresses> addresses;
	public String age;
	public String casareferenceNumber;
	public String cellPhoneNumber;
	public String cifcode;
	public String contactFirstName;
	public String contactIDNumber;
	public String contactIDType;
	public String contactId;
	public String contactLastName;
	public String country;
	public String dateOfBirth;
	public String emailAddress;
	public String gender;
	public String homePhoneNumber;
	public String initials;
	public String maritalStatus;
	public String marriageContractType;
	public String nationality;
	public String occupationalCode;
	public String occupationalStatus;
	public String opportunityId;
	public String opportunityName;
	public String title;
	public String workPhoneNumber;

	
	public static UpdateLeadDetails_Req_IB_v1 dummyRequest() {
		UpdateLeadDetails_Req_IB_v1 requestBean = new UpdateLeadDetails_Req_IB_v1();

		UpdateLeadDetails_Req_IB_v1.Addresses address = new UpdateLeadDetails_Req_IB_v1.Addresses();
		List<UpdateLeadDetails_Req_IB_v1.Addresses> addresses = new List<UpdateLeadDetails_Req_IB_v1.Addresses>();

		address.addressLine1 = 'Unit 32';
		address.addressLine2 = '01 Olienhought Street';
		address.addressType = 'Home';
		address.city = 'Kempton Park';
		address.isPrimaryMVG = 'Yes';
		address.postalCode = '1685';
		address.suburb = 'Birchleigh';
		addresses.add(address);

		requestBean.addresses = addresses;
		requestBean.age = '44';
		requestBean.casareferenceNumber = 'string';
		requestBean.cellPhoneNumber = '+270739458109';
		requestBean.cifcode = 'KOLOIKL001';
		requestBean.contactFirstName = 'Lerato';
		requestBean.contactIDNumber = '9612059280084';
		requestBean.contactIDType = 'SAIdentityDocument';
		requestBean.contactId = 'string';
		requestBean.contactLastName = 'Test';
		requestBean.country = 'South Africa';
		requestBean.dateOfBirth = '1974-08-27';
		requestBean.emailAddress = 'string';
		requestBean.gender = 'Female';
		requestBean.homePhoneNumber = 'string';
		requestBean.initials = 'KL';
		requestBean.maritalStatus = 'Single';
		requestBean.marriageContractType = 'string';
		requestBean.nationality = 'South Africa';
		requestBean.occupationalCode = 'Architect';
		requestBean.occupationalStatus = 'FullTimeEmployed';
		requestBean.opportunityId = 'String';
		requestBean.opportunityName = 'string';
		requestBean.title = 'Mr';
		requestBean.workPhoneNumber = '0614336309';

		return requestBean;

	}
}