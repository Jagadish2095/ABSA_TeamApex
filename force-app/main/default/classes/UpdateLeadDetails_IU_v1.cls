/**
	 * @description updateLeadDetails Service UI
	 * @author: Mbuyiseni Mbhokane(Absa)
	 * @created date: 28/04/2021
     * @Lastmodified: Monde Masiza
     * @Lastmodified Date: 05/14/2021
* */

public class UpdateLeadDetails_IU_v1 {

    private static final String POSTAL_ADDRESS = 'Postal';
    private static final String PHYSICAL_ADDRESS = 'Physical Address';

    /**
    * @description pass in the opportunity id or Account Id
    * @param oppId
    * @param accId
    * @return requestBean
    */
    public static UpdateLeadDetails_Req_IB_v1 mapRequestField(String oppId, String accId){

        UpdateLeadDetails_Req_IB_v1 requestBean = new UpdateLeadDetails_Req_IB_v1();
     
        UpdateLeadDetails_Req_IB_v1.Addresses shippingAddress = new UpdateLeadDetails_Req_IB_v1.Addresses();
        UpdateLeadDetails_Req_IB_v1.Addresses billingAddress = new UpdateLeadDetails_Req_IB_v1.Addresses();
        
        List<UpdateLeadDetails_Req_IB_v1.Addresses> addresses = new List<UpdateLeadDetails_Req_IB_v1.Addresses>();
    
        //use the custom address object
        List<Address__c> postalAddresses = new List<Address__c>();
        List<Address__c> physicalAddresses = new List<Address__c>();
        
        Account accountRecord = new Account();
        List<Opportunity> opportunities = new List<Opportunity>();
        String oppName;
        if(String.isNotBlank(oppId)){
            accountRecord = new AccountsSelector().selectIndvByOpportunityIdNew(oppId);
            opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
            if(accountRecord != null){
                postalAddresses = new AddressesSelector().selectByAccountAndType(accountRecord.Id, POSTAL_ADDRESS);
                physicalAddresses = new AddressesSelector().selectByAccountAndType(accountRecord.Id, PHYSICAL_ADDRESS);
            }

            if(!opportunities.isEmpty()){
                oppName = opportunities.get(0).Name;
            }
            
        }else if(String.isNotBlank(accId)){
            accountRecord = new AccountsSelector().selectByIdForIndividual(accId);
            if(accountRecord != null){
                postalAddresses = new AddressesSelector().selectByAccountAndType(accountRecord.Id, POSTAL_ADDRESS);
                physicalAddresses = new AddressesSelector().selectByAccountAndType(accountRecord.Id, PHYSICAL_ADDRESS);
            }
        }
   
        if(!postalAddresses.isEmpty()){
            billingAddress.addressLine1 = postalAddresses.get(0).Shipping_Street__c;//accountRecord.BillingStreet;
            billingAddress.addressLine2 = postalAddresses.get(0).Shipping_Street_2__c;//accountRecord.billing_address_line_2__c;//accountRecord.BillingStreet; // billing_address_line_2__c
            billingAddress.addressType = POSTAL_ADDRESS;
            billingAddress.city = postalAddresses.get(0).Shipping_City__c;//accountRecord.BillingCity;
            billingAddress.isPrimaryMVG = 'Yes';
            billingAddress.postalCode = postalAddresses.get(0).Shipping_Zip_Postal_Code__c;//accountRecord.BillingPostalCode;
            billingAddress.suburb = postalAddresses.get(0).Shipping_Suburb__c;//accountRecord.BillingState;
        }

        addresses.add(billingAddress);

        if(!physicalAddresses.isEmpty()){

            shippingAddress.addressLine1 = physicalAddresses.get(0).Shipping_Street__c;//accountRecord.ShippingStreet;//'Unit 32';
            shippingAddress.addressLine2 = physicalAddresses.get(0).Shipping_Street_2__c;//accountRecord.Physical_address_line_2_c__c;//accountRecord.ShippingStreet;//'01 Olienhought Street'; //Physical_address_line_2_c__c
            shippingAddress.addressType = 'Home';
            shippingAddress.city = physicalAddresses.get(0).Shipping_City__c;//accountRecord.ShippingCity;//'Kempton Park';
            shippingAddress.isPrimaryMVG = 'Yes';
            shippingAddress.postalCode = physicalAddresses.get(0).Shipping_Zip_Postal_Code__c;//accountRecord.ShippingPostalCode;//'1685';
            shippingAddress.suburb = physicalAddresses.get(0).Shipping_Suburb__c;//accountRecord.ShippingState;//'Birchleigh';
        }

        addresses.add(shippingAddress);
        
        requestBean.addresses = addresses; 
        
         //description:Concinnated marital status and marital contract type and handle null vale
        // @Author: Monde Masiza
        
        
        string conMaritalStatus = accountRecord.Marital_Status__pc + accountRecord.Marital_Contract_Type__pc;
        conMaritalStatus = conMaritalStatus.replaceAll( '\\s+', '');
        
        if(conMaritalStatus=='Singlenull'){
            conMaritalStatus = 'Single';
        }
        else if(conMaritalStatus=='Widowednull'){
            conMaritalStatus = 'Widowed';
            
        }
        else if(conMaritalStatus=='Separatednull'){
            conMaritalStatus = 'Separated'; 
        }
        else if(conMaritalStatus=='Divorcednull'){
            conMaritalStatus = 'Divorced';
        }
        else if(conMaritalStatus=='Widow/Widowernull'){
            conMaritalStatus = 'WidowWidower';
        }
        else if(conMaritalStatus=='MarriedOutOfCommunityOfPropertyWithAccrual'){
            conMaritalStatus = 'MarriedByANCwithaccrual';
        }
        else if(conMaritalStatus=='MarriedOutOfCommunityOfPropertyWithoutAccrual'){
            conMaritalStatus = 'MarriedByANCwithoutaccrual';
        }
         else if(conMaritalStatus=='MarriedInCommunityOfProperty'){
            conMaritalStatus = 'MarriedBycommunityofproperty';
        }
        
        requestBean.age = String.valueOf(Integer.valueOf(accountRecord.Rounded_Age__c));//string.valueOf(accountRecord.Age__pc);//'44';
        requestBean.casareferenceNumber = accountRecord.CASA_Reference_Number__pc;//'string';
        requestBean.cellPhoneNumber = accountRecord.PersonMobilePhone;//'+270739458109';
        requestBean.cifcode = accountRecord.CIF__c;// 'KOLOIKL001';
        requestBean.contactFirstName = accountRecord.FirstName;// 'Lerato';
        requestBean.contactIDNumber = accountRecord.ID_Number__pc;// '9612059280084';
        requestBean.contactIDType = accountRecord.ID_Type__pc;// 'SAIdentityDocument';
        requestBean.contactId = ''; 
        requestBean.contactLastName = accountRecord.LastName;//'Test';
        requestBean.country = accountRecord.Country_of_Residence__pc;// 'South Africa';
        requestBean.dateOfBirth = string.valueOf(accountRecord.PersonBirthdate);// '1974-08-27';
        requestBean.emailAddress = accountRecord.PersonEmail;// 'string';
        requestBean.gender = accountRecord.Gender__pc;// 'Female';
        requestBean.homePhoneNumber = accountRecord.PersonHomePhone;// 'string';
        requestBean.initials = accountRecord.Initials__pc;//'KL';
        requestBean.maritalStatus = conMaritalStatus;// 'Single';
        requestBean.marriageContractType = accountRecord.Marital_Contract_Type__pc;// 'string';
        requestBean.nationality = accountRecord.Nationality__pc;// 'South Africa';
        requestBean.occupationalCode = accountRecord.Occupation_Category__pc;// 'Architect';
        requestBean.occupationalStatus = accountRecord.Occupation_Status__pc;// 'FullTimeEmployed';
        requestBean.opportunityId = String.isNotBlank(oppId)? oppId: '';//'String';
        requestBean.opportunityName = String.isNotBlank(oppName)? oppName : '';// 'string';
        requestBean.title = accountRecord.PersonTitle;// 'Mr';
        requestBean.workPhoneNumber = accountRecord.Work_Phone__c;// '0614336309';
        
        return requestBean;
    }
}