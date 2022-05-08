/**
 * @description Request Integration Bean for CreateLead
 * @Author: Mbuyiseni Mbhokane
 * @Since: 17/02/2021
 */
@SuppressWarnings('PMD')
public class CreateLead_Req_IB_v1 extends Base_IB {

    public String addressLine1;
	public String addressLine2;
	public String age;
	public String callBackTime;
	public String callStatus;
	public String campaignId;
	public String casareferenceNumber;
	public String cellphoneNumber;
	public String cifCode;
	public String city;
	public String contactId;
	public String country;
	public String dateCreated;
	public String dateOfBirth;
	public String emailAddress;
	public String employmentStatus;
	public String firstName;
	public String gender;
	public String homeNumber;
	public String idNumber;
	public String idType;
	public String initials;
	public String lastName;
	public String maritalStatus;
	public String memberId;
	public String nationality;
	public String occupationCategory;
	public String opportunityId;
	public String opportunityName;
	public String outcomeValueSetValue;
	public String postalAddressLine1;
	public String postalAddressLine2;
	public String postalCity;
	public String postalCode;
	public String postalPostalCode;
	public String postalSuburb;
	public String riskRating;
	public String staffMember;
	public String suburb;
	public String supervisor;
	public String title;
	public String username;
	public String workNumber;
    public String brokerCode;
	
	public static CreateLead_Req_IB_v1 dummyRequest(){

		CreateLead_Req_IB_v1 requestBean = new CreateLead_Req_IB_v1();

		requestBean.addressLine1 = '09 NORTH STREET1';
        requestBean.addressLine2 = '';
        requestBean.age = '0';
        requestBean.callBackTime = '';
        requestBean.callStatus = '';
        requestBean.campaignId = '7015r0000009YG3AAM';
        requestBean.casareferenceNumber = '';
        requestBean.cellphoneNumber = '270780557661';
        requestBean.cifCode = 'TCASET 002';
        requestBean.city = 'BLOEMFONTEIN';
        requestBean.contactId = '1-1L6DYMA';
        requestBean.country = 'South Africa';
        requestBean.dateCreated = '2021-01-08T12:20:55';
        requestBean.dateOfBirth = '2003-01-13';
        requestBean.emailAddress = '';
        requestBean.employmentStatus = 'Full time Employed';
        requestBean.firstName = 'testt';
        requestBean.gender = 'Female';
        requestBean.homeNumber ='';
        requestBean.idNumber = '87yut345678';
        requestBean.idType = 'Passport';
        requestBean.initials = 'T';
        requestBean.lastName = 'Test case';
        requestBean.maritalStatus = 'Single';
        requestBean.memberId = '1-1L6DYM9';
        requestBean.nationality = 'South Africa';
        requestBean.occupationCategory = 'Accountant';
        requestBean.opportunityId = '1-1L6F7GT';
        requestBean.opportunityName = 'TEST CASE08012021123305';
        requestBean.outcomeValueSetValue = 'true';
        requestBean.postalAddressLine1 = '09 NORTH STREET';
        requestBean.postalAddressLine2 = '';
        requestBean.postalCity = 'BLOEMFONTEIN';
        requestBean.postalCode = '9301';
        requestBean.postalPostalCode = '';
        requestBean.postalSuburb = 'AANDRUS';
        requestBean.riskRating = '';
        requestBean.staffMember = 'true';
        requestBean.suburb = 'AANDRUS';
        requestBean.supervisor = 'ABAM280';
        requestBean.title = 'Miss';
        requestBean.username  = 'ABSN571';
        requestBean.workNumber = '';

		return requestBean;
	}
}