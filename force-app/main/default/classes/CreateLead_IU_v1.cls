/**
	 * @description class for createLead service
	 * @param oppId Opp Id
	 * @author: Mbuyiseni Mbhokane(Absa)
	 * @created date: 17/02/2021
     * @modified: Monde Masiza
     * @Since: 05/14/2021
* */
public class CreateLead_IU_v1 {

    private static final String POSTAL_ADDRESS = 'Postal';
    private static final String PHYSICAL_ADDRESS = 'Physical Address';

    /**
	 *@description get the opportunity and map service fileds
	 * @param oppId
     * * @return the requestBean
	 */

    public static CreateLead_Req_IB_v1 mapRequestFields(String oppId){

        String callStatus = '';
        String callBackTime = '';
        String outcomeValueSetValue = '';
        String contactId = '';

        //get the current user
        User currentUser = new UsersSelector().selectById(Userinfo.getUserId());

        //get the opportunity record
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);

        //get account details
        Account accountRecord = new AccountsSelector().selectIndvByOpportunityIdUpdate(oppId);

        List<Account> accounts = new List<Account>();
        List<Address__c> postalAddresses = new List<Address__c>();
        List<Address__c> physicalAddresses = new List<Address__c>();

        if(!opportunities.isEmpty()){
            accounts = new AccountsSelector().selectRelatedPartyCASAByAccountId(opportunities.get(0).AccountId);
        }

        if (!accounts.isEmpty()) {
        //get the account related address
         postalAddresses = new AddressesSelector().selectByAccountAndType(accounts.get(0).Id, POSTAL_ADDRESS);
         physicalAddresses = new AddressesSelector().selectByAccountAndType(accounts.get(0).Id, PHYSICAL_ADDRESS);
        }

        
		system.debug('maritalStatus testing');
        String maritalStatus;
        
        String conMaritalStatus = opportunities.get(0).Marital_Status__c + opportunities.get(0).STIMarital_Contract_Type__c;
        conMaritalStatus = conMaritalStatus.replaceAll( '\\s+', '');
       
		system.debug('maritalStatus:' + maritalStatus);
        
        system.debug('conMaritalStatus:' + conMaritalStatus);
        
        if(conMaritalStatus=='Singlenull'){
            maritalStatus = 'Single';
        }
        else if(conMaritalStatus=='Widowednull'){
            maritalStatus = 'Widowed';
            
        }
        else if(conMaritalStatus=='Separatednull'){
            maritalStatus = 'Separated'; 
        }
        else if(conMaritalStatus=='Divorcednull'){
            maritalStatus = 'Divorced';
        }
        else if(conMaritalStatus=='Widow/Widowernull'){
            maritalStatus = 'WidowWidower';
        }
        else{
            maritalStatus = conMaritalStatus;
        }

        //format the datetime
        String createdDate = DateTime.now().format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
		String CASARefNumber = accounts.get(0).CASA_Reference_Number__pc;
        
       
        CreateLead_Req_IB_v1 requestBean = new CreateLead_Req_IB_v1();
        requestBean.addressLine1 = physicalAddresses.get(0).Shipping_Street__c;
        requestBean.addressLine2 = physicalAddresses.get(0).Shipping_Street_2__c;
        requestBean.age = String.valueOf(opportunities.get(0).Person_Account_Age__c);//age;
        requestBean.callBackTime = callBackTime;
        requestBean.callStatus = callStatus;
        requestBean.campaignId = opportunities.get(0).CampaignId;
        requestBean.casareferenceNumber = accounts.get(0).CASA_Reference_Number__pc;//opportunities.get(0).CASA_Reference_Number__c;//casareferenceNumber;
        requestBean.cellphoneNumber = accounts.get(0).PersonMobilePhone;
        requestBean.cifCode = accountRecord.CIF__c;
        requestBean.city = physicalAddresses.get(0).Shipping_City__c;
        requestBean.contactId = opportunities.get(0).AccountId.to15();//contactId;
        requestBean.country = 'South Africa';//this value has been set to defaul to SA
        requestBean.dateCreated = createdDate;//String.valueOf(Date.today()).removeEnd(' 00:00:00');//String.valueOf(datetime.now()); // need to look at this added this value becase I need testing to continue
        requestBean.dateOfBirth = String.valueOf(opportunities.get(0).Person_BirthDate__c);
        requestBean.emailAddress = opportunities.get(0).Selected_Email__c;
        requestBean.employmentStatus = accounts.get(0).Occupation_Status__pc;
        requestBean.firstName = opportunities.get(0).Person_Account_First_Name__c;
        requestBean.gender = accounts.get(0).FinServ__Gender__pc;
        requestBean.homeNumber = accounts.get(0).PersonHomePhone;
        requestBean.idNumber = accounts.get(0).ID_Number__pc;//opportunities.get(0).ID_Number__c;
        requestBean.idType = accounts.get(0).ID_Type__pc;
        requestBean.initials = accounts.get(0).Initials__pc;
        requestBean.lastName = opportunities.get(0).Person_Account_Last_Name__c;
        requestBean.maritalStatus = maritalStatus;
        requestBean.memberId = opportunities.get(0).Lead_Id__c;
        requestBean.nationality = accounts.get(0).Nationality__pc;
        requestBean.occupationCategory = accounts.get(0).Occupation__pc;
        requestBean.opportunityId = opportunities.get(0).Id;
        requestBean.opportunityName = opportunities.get(0).Name;
        requestBean.outcomeValueSetValue = outcomeValueSetValue;

        requestBean.postalAddressLine1 = postalAddresses.get(0).Shipping_Street__c;
        requestBean.postalAddressLine2 = postalAddresses.get(0).Shipping_Street_2__c;
        requestBean.postalCity = postalAddresses.get(0).Shipping_City__c;
        requestBean.postalCode = physicalAddresses.get(0).Shipping_Zip_Postal_Code__c;
        requestBean.postalPostalCode = postalAddresses.get(0).Shipping_Zip_Postal_Code__c;
        requestBean.postalSuburb = postalAddresses.get(0).Shipping_Suburb__c;

        requestBean.riskRating = accountRecord.Risk_Rating__c;
        requestBean.staffMember = String.valueOf(opportunities.get(0).Staff_Flag__c);
        requestBean.suburb = physicalAddresses.get(0).Shipping_Suburb__c;
        requestBean.supervisor = currentUser.Supervisor__c;
        requestBean.title = opportunities.get(0).Person_Title__c;
        requestBean.username = currentUser.AB_Number__c;
        requestBean.workNumber = accountRecord.Work_Phone__c;
        requestBean.brokerCode = currentUser.Advisor_Code__c;

        return requestBean;
        }
    }