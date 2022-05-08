/*
 * Integration Request for FraudSyncApplication Service
 * @author André Pietersen
 * @created 2020-11-04
 */
public class FraudSyncApplication_Req_IB_V1 extends Base_IB {
    public String applicationDateTime;
	public Header header;
	public ProductDetails productDetails;
    public List<CustomerDetails> customerDetails;
    
    public class Header {
		public Channel channel;
		public String channelReference;
    }
    
    public class Channel {
		public List<ChannelDetails> channelDetails;
		public String channelType;
		public String channelName;
    }
    
    public class ChannelDetails {
		public String fieldName;
		public String value;
    }
    
    public class ProductDetails {
		public Integer campaignReference;
		public Integer limitAmount;
		public String productSubType;
		public String productType;
    }
    
    public class CustomerDetails {
		public List<AddressDetails> addressDetails;
		public CreditDetails creditDetails;
		public String customerIndicator;
		public String customerType;
		public String dateOfBirth;
		public EmploymentDetails employmentDetails;
		public String firstName;
		public String gender;
		public Identity identity;
		public String language;
		public String lastName;
		public String maritalStatus;
		public Integer noOfDependants;
		public String qualification;
		public String residentialStatus;
		public String tempPermitNo;
		public List<ContactDetails> contactDetails;
    }
    
    public class AddressDetails {
		public Integer addressDateSince;
		public String addressType;
		public String buildingName;
		public Integer postalCode;
		public String streetName;
		public Integer streetNumber;
		public String suburbOrTown;
    }
    
    public class CreditDetails {
		public Integer grossIncome;
		public Integer totalExpenses;
    }
    
    public class EmploymentDetails {
		public String companyName;
		public String employmentSector;
		public String occupationLevel;
		public String occupationStatus;
		public String companyPhoneNumber;
		public String companyEmailAddress;
		public Integer occupationalStatusCode;
    }
    
    public class Identity {
		public Long idNumber;
		public String idType;
		public String passportNationality;
    }
    
    public class ContactDetails {
		public String contactDetailsType;
		public Integer preferenceOrder;
		public String contactDetailsDescription;
		public String correspondence;
    }
    
    public static FraudSyncApplication_Req_IB_V1 createDummyRequest() {
		FraudSyncApplication_Req_IB_V1 requestBean = new FraudSyncApplication_Req_IB_V1();
		requestBean.applicationDateTime = '2020-07-12T08:30:09+10:00';

		requestBean.header = new FraudSyncApplication_Req_IB_V1.Header();
		requestBean.header.channelReference = '0986532222';

		requestBean.header.channel = new FraudSyncApplication_Req_IB_V1.Channel();
		requestBean.header.channel.channelDetails = new List<FraudSyncApplication_Req_IB_V1.ChannelDetails>();
		ChannelDetails a = new ChannelDetails();
		a.fieldName = 'SITE_CODE';
		a.value = '9082';
		requestBean.header.channel.channelDetails.add(a);

		ChannelDetails b = new ChannelDetails();
		b.fieldName = 'USER_ID';
		b.value = '123456';
		requestBean.header.channel.channelDetails.add(b);

		ChannelDetails c = new ChannelDetails();
		c.fieldName = 'USER_TYPE';
		c.value = 'Employee';
		requestBean.header.channel.channelDetails.add(c);

		ChannelDetails d = new ChannelDetails();
		d.fieldName = 'BRANCH_NAME';
		d.value = 'cresta';
		requestBean.header.channel.channelDetails.add(d);

		ChannelDetails e = new ChannelDetails();
		e.fieldName = 'IP_ADDRESS';
		e.value = '190.90.92';
		requestBean.header.channel.channelDetails.add(e);

		ChannelDetails f = new ChannelDetails();
		f.fieldName = 'TERMINAL_ID';
		f.value = '23456';
		requestBean.header.channel.channelDetails.add(f);

		ChannelDetails g = new ChannelDetails();
		g.fieldName = 'OS';
		g.value = 'android';
		requestBean.header.channel.channelDetails.add(g);

		requestBean.header.channel.channelType = 'BRANCH';
		requestBean.header.channel.channelName = 'DSP';

		requestBean.productDetails = new FraudSyncApplication_Req_IB_V1.ProductDetails();
		requestBean.productDetails.campaignReference = 98765;
		requestBean.productDetails.limitAmount = 0;
		requestBean.productDetails.productSubType = 'Cheque';
		requestBean.productDetails.productType = 'SAVINGS';

		requestBean.customerDetails = new List<FraudSyncApplication_Req_IB_V1.CustomerDetails>();
		FraudSyncApplication_Req_IB_V1.CustomerDetails customerDetail = new FraudSyncApplication_Req_IB_V1.CustomerDetails();

		customerDetail.addressDetails = new List<FraudSyncApplication_Req_IB_V1.AddressDetails>();

		FraudSyncApplication_Req_IB_V1.AddressDetails addressDetail = new FraudSyncApplication_Req_IB_V1.AddressDetails();
		addressDetail.addressDateSince = 8;
		addressDetail.addressType = 'HOME_ADDRESS';
		addressDetail.buildingName = 'Absa building';
		addressDetail.postalCode = 2194;
		addressDetail.streetName = 'Republic road';
		addressDetail.streetNumber = 270;
		addressDetail.suburbOrTown = 'Randburg';

		customerDetail.addressDetails.add(addressDetail);

		customerDetail.creditDetails = new FraudSyncApplication_Req_IB_V1.CreditDetails();
		customerDetail.creditDetails.grossIncome = 0;
		customerDetail.creditDetails.totalExpenses = 0;

		customerDetail.customerIndicator = 'PRIMARY';
		customerDetail.customerType = 'NEW_TO_BANK';
		customerDetail.dateOfBirth = '1994-03-25';

		customerDetail.employmentDetails = new FraudSyncApplication_Req_IB_V1.EmploymentDetails();
		customerDetail.employmentDetails.companyName = 'Absa';
		customerDetail.employmentDetails.employmentSector = 'Information and communication';
		customerDetail.employmentDetails.occupationLevel = 'Manager';
		customerDetail.employmentDetails.occupationStatus = 'Full Time Employed';
		customerDetail.employmentDetails.companyPhoneNumber = '0511234567';
		customerDetail.employmentDetails.companyEmailAddress = 'test@test.com';
		customerDetail.employmentDetails.occupationalStatusCode = 0;

		customerDetail.firstName = 'Cynthia';
		customerDetail.gender = 'MALE';

		customerDetail.identity = new FraudSyncApplication_Req_IB_V1.Identity();
		customerDetail.identity.idNumber = 9403250985081L;
		customerDetail.identity.idType = 'PASSPORT';
		customerDetail.identity.passportNationality = 'ZIM';

		customerDetail.language = 'english';
		customerDetail.lastName = 'Test';
		customerDetail.maritalStatus = 'MARRIED';
		customerDetail.noOfDependants = 0;
		customerDetail.qualification = 'Matric';
		customerDetail.residentialStatus = 'Renter';
		customerDetail.tempPermitNo = '';

		customerDetail.contactDetails = new List<FraudSyncApplication_Req_IB_V1.ContactDetails>();
		FraudSyncApplication_Req_IB_V1.ContactDetails contactDetail = new FraudSyncApplication_Req_IB_V1.ContactDetails();

		contactDetail.contactDetailsType = 'EMAIL_ADDRESS';
		contactDetail.preferenceOrder = 0;
		contactDetail.contactDetailsDescription = 'PERSONAL_EMAIL';
		contactDetail.correspondence = 'test@absa.africa';

		customerDetail.contactDetails.add(contactDetail);

		requestBean.customerDetails.add(customerDetail);

		return requestBean;
    }
}