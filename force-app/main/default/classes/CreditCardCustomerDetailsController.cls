public without sharing class CreditCardCustomerDetailsController {
    
    /**
    * @description Get all Account linked to Client in Salesforce
    * Added by : Mariyappan to get the accounts
    * @param  accountId
    * @return List<Account>
    */
    @AuraEnabled
    public static List<Account> retriveAccountsById(String accountId) {
        return new AccountsSelector().selectById(new Set<Id>{accountId}, 1);
    }
    
    /**
    * @description Get CPB details for Account
    * Added by : Hitendra to get CPB details
    * @param  accountId
    * @return CPBValidate_Resp_IB_v1.ResidentialAddress Object
    */
    @AuraEnabled
    public static CPBValidate_Resp_IB_v1 getCPBInfoById(Id accountId) {
        String idNumber, lastName;
        Account acctRecord = new AccountsSelector().selectAllById(accountId);
        
        if( acctRecord != null ){
            idNumber= acctRecord.ID_Number__pc;
            lastName= acctRecord.LastName;
        }
        Map<CPBValidate_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CPBValidate_IH_v1.CPBValidate(idNumber, lastName);
		CPBValidate_Resp_IB_v1 responseBean = (new List<CPBValidate_Resp_IB_v1>(responseMap.keySet()))[0];
		List<Sys_Log_Integration__c> cpbLogs = responseMap.values()[0];

		return responseBean;
       
    }

    /**
    * @description This is a method to retrieve a serialized Adapt360 Client Profile Bean
    * @param   searchType      The given search type
    * @param   searchValue     The search input by the user
    * @return  String          The serialized Client Profile Bean
    */
    @SuppressWarnings('PMD.AvoidDebugStatements')
    @AuraEnabled
    public static String getClientDetailsBean(String searchType, String searchValue) {
       return ClientFinderExt.getClientDetailsBean(searchType, searchValue);
    }

    /**
    * @description This is a method to retrieve a serialized MDM Client Profile Bean
    *
    * @param   searchType      The given search type
    * @param   searchValue     The search input by the user
    *
    * @return  String          The serialized Client Profile Bean
    */
    @SuppressWarnings('PMD.AvoidDebugStatements')
    @AuraEnabled
    public static String getMDMClientDetailsBean(String searchType, String searchValue) {
        return ClientFinderExt.getMDMClientDetailsBean(searchType, searchValue);
    }

    /**
    * @description Get all Account linked to Client in Salesforce
    * Added by : Mariyappan to get the accounts
    * @param  accountId
    * @return List<Account>
    */
    @AuraEnabled
    public static List<Account> getGIResponseAccount(String cifKey, String accountIdNumber) {
        return ClientFinderExt.getGIResponseAccount(cifKey, accountIdNumber);
    }

    /**
    * @description update CIF Account on the CIF service
    * Added by : Mariyappan to get the accounts
    * @param  accountId
    * @return String
    */
    @AuraEnabled
    public static String updateClientCIF(Id accountId) {
        List<Application__c> applications = [SELECT Id, Application_Number__c, Account__c, Name FROM Application__c WHERE Account__c = :accountId];
        return JSON.serialize(CCApplicationServiceHelper.applyClientUpdate(accountId, applications[0].Id, applications[0].Application_Number__c));
    }

    /**
    * @description Get all pick lists from Salesforce objects
    * Added by : Mariyappan to get the accounts
    * @param  objectName, fieldName
    * @return List<String>
    */
    @AuraEnabled
    public static List<String> getPicklistByObject(String objectName, String fieldName) {  
        List<String> pickListValues = new List<String>();      
        Schema.SObjectType s = Schema.getGlobalDescribe().get(objectName) ;
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        Map<String,Schema.SObjectField> fields = r.fields.getMap() ;
        Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple) {
            pickListValues.add(pickListVal.getValue());
        } 
        return pickListValues;
    }

    
    /**
    * @description Get all Account linked to Client in Salesforce
    * Added by : Mariyappan to get the accounts
    * @param  idNumber
    * @return List<Account>
    */
    @AuraEnabled
    public static List<Account> getAccountByIdNumber(String recordId, String idNumber) {
        Id accountId = new OpportunitiesSelector().selectByOpportunityId(Id.valueOf(recordId), 1).get(0).AccountId;
        return [
            SELECT 
                Id, 
                PersonTitle,
            	Initials__pc,
                FirstName,
                LastName,
                ID_Number__pc,
                Gender__pc,
                Nationality__pc,
                Country_of_Residence__pc,
                Country_of_Residence__c,
                Country_of_Birth__pc,
                PersonBirthdate,
                ID_Type__c,
                ID_Type__pc,
                PersonEmail,
                Phone,
                PersonMobilePhone,
                Work_Phone__pc,
                Work_Phone__c,
                PersonHomePhone,
                Statement_Preference__pc,
                Marital_Status__pc,
                Marital_Contract_Type__pc,
                Home_Language__pc,
                Communication_Language__pc,
                Preferred_Communication_Method__pc,
                Next_of_Kin_First_Name_s__pc,
                Next_of_Kin_Initial__pc,
                Next_of_Kin_Last_Name__pc,
                Next_of_Kin_Relationship__pc,
                Next_of_Kin_Telephone_Number__pc,
                Next_of_Kin_Email_Address__pc,
                Next_of_Kin_Cellphone_Number__pc,
            	//Added Kabelo
            	Occupation_Status__pc,
                Employer_Sector__pc,
                Occupation_Category__pc,
                Occupation_Level__pc,
                Number_Of_YearIn_The_Specific_Industry__c,
                Has_Post_Matric_Qualification__pc,
                Income_Source__pc,
                Highest_Qualification__pc,
                Number_of_dependants__c,
                DD_Source_of_Funds__pc,
                Employer_Name__pc,
                Employer_Phone__c,
                Business_Address_Line_1__c,
                Physical_Address_Suburb__c,
                Physical_Address_City__c,
                Postal_Code__c,
                (SELECT Id, Account__c, Account__r.Name, Shipping_City__c, Shipping_Country__c, Shipping_State_Province__c, Shipping_Street__c, Shipping_Suburb__c, Shipping_Zip_Postal_Code__c, Shipping_Street_2__c, Address_Type__c FROM Addresses__r WHERE Address_Type__c = 'Residential')	
                FROM Account WHERE Id =: accountId];
    }

    /**
    * @description Get all Account linked to Client in Salesforce
    * Added by : Mariyappan to get the accounts
    * @param  accountId
    * @return List<Account>
    */ 
    @AuraEnabled
    public static List<Account> updateCustomerDetails(String recordId, String modifiedData, String applicationNumber) {
        String applicationRecordId;
        customerDetailsWrapper customerWrapper = (customerDetailsWrapper) System.JSON.deserialize(modifiedData, customerDetailsWrapper.class);
       List<Application__c> applications = [SELECT Id FROM Application__c WHERE Account__c = :recordId];
       if(!applications.isEmpty()){
        applicationRecordId = applications[0].Id;
       }
        Account account = new Account();
        account.Id = recordId;
        account.PersonTitle = customerWrapper.identityInformation.personTitle;
        account.FirstName =  customerWrapper.identityInformation.firstName;
        account.LastName = customerWrapper.identityInformation.lastName;
        account.Initials__pc = customerWrapper.identityInformation.initials;
        account.ID_Number__pc = customerWrapper.identityInformation.idNumber;
        account.Gender__pc = customerWrapper.identityInformation.genderValue;
        account.Nationality__pc = customerWrapper.identityInformation.nationality;
        account.Country_of_Residence__pc = customerWrapper.identityInformation.countryOfResidence;
        account.Country_of_Residence__c = customerWrapper.identityInformation.countryOfResidence;
        account.Country_of_Birth__pc = customerWrapper.identityInformation.countryOfBirth;
        account.PersonBirthdate = Date.valueOf(customerWrapper.identityInformation.personBirthDate);
        account.ID_Type__pc = customerWrapper.identityInformation.idType;
        //account.ID_Type__c = customerWrapper.identityInformation.idType;

        account.Next_of_Kin_First_Name_s__pc = customerWrapper.nextKinInformation.kinFirstName;
        account.Next_of_Kin_Last_Name__pc = customerWrapper.nextKinInformation.kinSurname;
        account.Next_of_Kin_Relationship__pc = customerWrapper.nextKinInformation.kinRelationShip;
        account.Next_of_Kin_Telephone_Number__pc = customerWrapper.nextKinInformation.kinHomePhone;
        account.Next_of_Kin_Email_Address__pc = customerWrapper.nextKinInformation.kinEmailAddress;
        account.Next_of_Kin_Cellphone_Number__pc = customerWrapper.nextKinInformation.kinMobilePhone;	
        //account.Next_of_Kin_Initial__pc = customerWrapper.nextKinInformation.idType;

        account.PersonEmail = customerWrapper.contactInformation.personEmail;
        account.Phone = customerWrapper.contactInformation.personMobilePhone;
        account.PersonMobilePhone = customerWrapper.contactInformation.personMobilePhone;
        account.Work_Phone__pc = customerWrapper.contactInformation.personWorkPhone;
        account.PersonHomePhone = customerWrapper.contactInformation.personHomePhone;
        account.Statement_Preference__pc = (customerWrapper.contactInformation.statementDeliveryMethod == 'email' ? 'Email' : 'Post') ;
        
        account.Marital_Status__pc = customerWrapper.maritalInformation.maritalStatus;
        account.Marital_Contract_Type__pc = customerWrapper.maritalInformation.maritalContractType;

        account.Home_Language__pc = customerWrapper.personalInformation.homeLanguage;
        account.Communication_Language__pc = customerWrapper.personalInformation.communicationLanguage;
        account.Preferred_Communication_Method__pc = customerWrapper.personalInformation.communicationChannel;
        
        if(account != null) {
            Database.update(account, false);
        }
        if(String.isNotBlank(applicationRecordId)) {
            updateApplication(applicationRecordId, modifiedData);
            CCDebitOrderMandateServiceHelper.applyClientUpdate(account.Id, applicationRecordId, applicationNumber);
        }
        //update account;
        return new List<Account>{account};
    }

    public static List<Application__c> updateApplication(String recordId, String modifiedData) {
        customerDetailsWrapper customerWrapper = (customerDetailsWrapper) System.JSON.deserialize(modifiedData, customerDetailsWrapper.class);
        Application__c application = new Application__c();
        application.First_Name__c = customerWrapper.identityInformation.firstName;
        application.FirstNameSignature__c = customerWrapper.identityInformation.firstName;
        application.Surname__c = customerWrapper.identityInformation.lastName;
        application.SurnameSignature__c = customerWrapper.identityInformation.lastName;
        application.Title__c = customerWrapper.identityInformation.personTitle;
        application.ID_Number__c = customerWrapper.identityInformation.idNumber;
        application.Id = recordId;
        if(application != null) {
            Database.update(application, false);
        }
        return new List<Application__c>{application};
    }

    //
    //Generated by AdminBooster
    //
    public class customerDetailsWrapper{
        public cls_identityInformation identityInformation;
        public cls_residentialInformation residentialInformation;
        public cls_contactInformation contactInformation;
        public cls_nextKinInformation nextKinInformation;
        public cls_maritalInformation maritalInformation;
        public cls_personalInformation personalInformation;
    }
	public class cls_identityInformation {
		public String personTitle;	//Dr.
		public String firstName;	//Mariyappan
		public String idNumber;	//1234567890
		public String genderValue;	//
		public String nationality;	//Indian
		public String countryOfResidence;	//India
		public String initials;	//Mariyappan
		public String lastName;	//Sivathanu
		public String personBirthDate;	//2022-03-01
		public String idType;	//Type
		public String countryOfBirth;	//India
	}
	public class cls_residentialInformation {
		public String timeLivedInAddress;	//61-A, Mappillainayakan tank street
		public String residentialStatus;	//61-A, Mappillainayakan tank street
		public String postalAddress1;	//61-A, Mappillainayakan tank street
		public String postalForeignTown;	//Trichy
		public String postalCode;	//620008
		public String postalAddress2;	//61-A, Mappillainayakan tank street
		public String postalCountry;	//Trichy
	}
	public class cls_contactInformation {
		public String personEmail;	//vanvmari@gmail.com
		public String personWorkPhone;	//1234567
		public String personHomePhone;	//1234567
		public String personMobilePhone;	//1234567
		public String statementDeliveryMethod;	//email
	}
	public class cls_nextKinInformation {
		public String kinFirstName;	//Mariyappan
		public String kinRelationShip;	//Sivathanu
		public String kinWorkPhone;	//1212121212121
		public String kinEmailAddress;	//vanvmari@gmail.com
		public String kinSurname;	//Siva
		public String kinHomePhone;	//121212121212
		public String kinMobilePhone;	//124579
	}
	public class cls_maritalInformation {
		public String maritalStatus;	//Nope
		public String maritalContractType;	//Contract
	}
	public class cls_personalInformation {
		public String homeLanguage;	//ENG
		public String communicationLanguage;	//BBC
		public String communicationChannel;	//ENg
	}
}