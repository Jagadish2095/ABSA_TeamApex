/**
 * @description Integration Utility class for InstinctRiskFraud Service
 * @author Manoj Danthala 
 * @created 2020-08-04
 */

public class InstinctRiskFraud_IU_v1 {

    /**
	 * @description The following request needs to be updated by Anka's Story - Mapping the fields - W-004530
	 * @param oppRec
	 * @return InstinctRiskFraud_Req_IB_v1
	 */
    public static InstinctRiskFraud_Req_IB_v1 mapRequestFields(Opportunity oppRec){

            //Get Primary Account Details
            List<Account> accounts = new AccountsSelector().selectCasaFieldsByIds(oppRec.AccountId, 1);
            Account accountRec = accounts[0];
            
            //Get Primary Address details
            List<Address__c> primaryAddressList = new AddressesSelector().addressesRelatedToAcc(accountRec.Id);
            
            //Get UBO Hierarchy
            List<Account> relatedParties = new List<Account>();
            List<Account> relatedPartiesBusinessEntities = new List<Account>();
         	String accountHierarchy = accounts[0].UBO_ParentAccountWrapper__c;
             if(accountHierarchy != null ) {
                relatedParties = OnboardingCASAScreeningController.getParticipants(accountRec.Id,'AccountContact',accountHierarchy);
                relatedPartiesBusinessEntities = OnboardingCASAScreeningController.getPartcicpantBusinessAccountData(oppRec.Id);
            }

            //Get Related Party Address details
            Set<String> relatedPartyAccIds = new Set<String>();
            for(Account eachAcc : relatedParties) {
                relatedPartyAccIds.add(eachAcc.Id);
            }
            for(Account eachAcc : relatedPartiesBusinessEntities) {
                relatedPartyAccIds.add(eachAcc.Id);
            }

            List<Address__c> relatedPartyAddressList = new AddressesSelector().selectByAccountIds(relatedPartyAccIds);
            //Create a Map o split Address by Related Party
            Map<String, Map<String, Address__c>> relatedPartyAddressMap = new Map<String, Map<String, Address__c>>();
            for(Address__c eachAddress : relatedPartyAddressList) {
                
                if(!relatedPartyAddressMap.containsKey(eachAddress.Account__c)) {
                    relatedPartyAddressMap.put(eachAddress.Account__c, new Map<String, Address__c>()); 
                } 
                
                if(eachAddress.Address_Type__c == 'Residential' || eachAddress.Address_Type__c == 'Physical Address' || eachAddress.Address_Type__c == 'Business Address') {
                   relatedPartyAddressMap.get(eachAddress.Account__c).put('homeAddress', eachAddress);
                } else if (eachAddress.Address_Type__c == 'Employers' || eachAddress.Address_Type__c == 'Head Office') {
                    relatedPartyAddressMap.get(eachAddress.Account__c).put('workAddress', eachAddress);
                }
            }
            
            InstinctRiskFraud_Req_IB_v1 requestBean = new InstinctRiskFraud_Req_IB_v1();
            requestBean.InstinctFraudCheck_XMLString = new InstinctRiskFraud_Req_IB_v1.InstinctFraudCheck_XMLString();
                
            
            String XmlString;
            String nameSpace = 'http://input.dectechsolutions.com';
            String name = 'ApplicationSchema';
            DOM.Document doc = new DOM.Document();
            dom.XmlNode Schema = doc.createRootElement(name,nameSpace,'');
            dom.xmlNode base = Schema.addchildElement('Application',null,null);
            
            //Application Mappings
            base.addChildElement('Organisation', null, null).addTextNode('ABS');
            base.addChildElement('Country_Code', null, null).addTextNode('ZA');		
            base.addChildElement('Group_Member_Code', null, null);
            base.addChildElement('Application_Number', null, null).addTextNode(oppRec.Opportunity_Number__c);
            base.addChildElement('Capture_Date', null, null);
            base.addChildElement('Capture_Time', null, null);
            base.addChildElement('Expiry_Date', null, null);
            base.addChildElement('Application_Date', null, null).addTextNode(oppRec.CreatedDate.format('dd/MM/yyyy'));
            base.addChildElement('Application_Type', null, null).addTextNode('RBCQ');	
            base.addChildElement('Amount_Limit', null, null).addTextNode('0');	
            base.addChildElement('Branch', null, null).addTextNode(oppRec.SiteCode__c!=null ? oppRec.SiteCode__c : '');			
            base.addChildElement('Decision', null, null).addTextNode('');
            base.addChildElement('Decision_Reason', null, null);
            base.addChildElement('Decision_Date', null, null);
            base.addChildElement('User_Field1', null, null).addTextNode('');
            base.addChildElement('User_Field2', null, null).addTextNode('');
            base.addChildElement('User_Field3', null, null).addTextNode('');
            base.addChildElement('User_Field4', null, null).addTextNode('');
            base.addChildElement('User_Field5', null, null).addTextNode('');
            base.addChildElement('User_Field6', null, null).addTextNode('');
            base.addChildElement('User_Field7', null, null);
            base.addChildElement('User_Field8', null, null).addTextNode('');
            base.addChildElement('User_Field9', null, null).addTextNode(oppRec.ExecutionLayerRequestID_Text__c!=null ? oppRec.ExecutionLayerRequestID_Text__c : '');
            base.addChildElement('User_Field10', null, null).addTextNode('');
            base.addChildElement('User_Field11', null, null).addTextNode('');
            base.addChildElement('User_Field12', null, null);
            base.addChildElement('User_Field13', null, null);
            base.addChildElement('User_Field14', null, null).addTextNode('');
            base.addChildElement('User_Field15', null, null);
            base.addChildElement('User_Field16', null, null).addTextNode('');
            base.addChildElement('User_Field17', null, null).addTextNode('');
            base.addChildElement('User_Field18', null, null).addTextNode('');
            base.addChildElement('User_Field19', null, null).addTextNode('');
            base.addChildElement('User_Field20', null, null).addTextNode('');
            
            //Primary Account Details
            dom.xmlNode primapplicant = base.addchildElement('Applicant',null,null); 
            
            if(accountRec.ID_Number__pc != null) {
                primapplicant.addChildElement('Id_Number1', null, null).addTextNode(accountRec.ID_Number__pc != null ? accountRec.ID_Number__pc : '');
            } else {
                primapplicant.addChildElement('Id_Number1', null, null).addTextNode(accountRec.Passport_Number__pc != null ? accountRec.Passport_Number__pc : '');
            }
            
            primapplicant.addChildElement('Id_Number2', null, null).addTextNode( accountRec.ID_Type__c != null ? accountRec.ID_Type__c : '');
            primapplicant.addChildElement('Id_Number3', null, null).addTextNode( accountRec.Registration_Number__c != null ? accountRec.Registration_Number__c : '');
            primapplicant.addChildElement('Surname', null, null).addTextNode( accountRec.LastName != null ?  accountRec.LastName : accountRec.Name);
            primapplicant.addChildElement('First_Name', null, null).addTextNode( accountRec.FirstName != null ? accountRec.FirstName : ''); 
            primapplicant.addChildElement('Middle_Name', null, null).addTextNode( accountRec.MiddleName != null ? accountRec.MiddleName : ''); 
            primapplicant.addChildElement('Sex', null, null).addTextNode( accountRec.Gender__pc != null ? accountRec.Gender__pc : '');
            primapplicant.addChildElement('Date_Of_Birth', null, null).addTextNode(accountRec.PersonBirthdate != null ? String.ValueOf(accountRec.PersonBirthdate) : '');	

            String clientGroup = accountRec.Client_Group__c.toUpperCase();
            Address__c homeAdd = new Address__c();
            Address__c companyAdd = new Address__c();
            for(Address__c eachAddress : primaryAddressList) {
                //Individual Entity
                if(eachAddress.Address_Type__c == 'Physical Address') {
                    homeAdd = eachAddress;
                } 
                //Business Entity
                else if (eachAddress.Address_Type__c == 'Business Address'){
                    homeAdd = eachAddress;
                }
                
                if (eachAddress.Address_Type__c == 'Employers'){
                    companyAdd = eachAddress;
                }
            }

            primapplicant.addChildElement('Home_Address1', null, null).addTextNode(homeAdd.Shipping_Street__c != null ? homeAdd.Shipping_Street__c : '');
            primapplicant.addChildElement('Home_Address2', null, null).addTextNode(homeAdd.Shipping_Street_2__c != null ? homeAdd.Shipping_Street_2__c : '');
            primapplicant.addChildElement('Home_Address3', null, null).addTextNode(homeAdd.Shipping_Suburb__c != null ? homeAdd.Shipping_Suburb__c : '');
            primapplicant.addChildElement('Home_Address4', null, null).addTextNode(homeAdd.Shipping_City__c != null ? homeAdd.Shipping_City__c : '');
            primapplicant.addChildElement('Home_Address5', null, null);
            primapplicant.addChildElement('Home_Address6', null, null).addTextNode('');
            primapplicant.addChildElement('Home_Postcode', null, null).addTextNode(homeAdd.Shipping_Zip_Postal_Code__c != null ? homeAdd.Shipping_Zip_Postal_Code__c : '');
            primapplicant.addChildElement('Home_Phone_Number', null, null).addTextNode(accountRec.PersonHomePhone != null ? accountRec.PersonHomePhone : '');
            primapplicant.addChildElement('Mobile_Phone_Number', null, null).addTextNode(accountRec.PersonMobilePhone != null ? accountRec.PersonMobilePhone : '');		
            primapplicant.addChildElement('Company_Name', null, null).addTextNode(accountRec.Employer_Name__pc != null ? accountRec.Employer_Name__pc : '');
            primapplicant.addChildElement('Company_Address1', null, null).addTextNode(companyAdd.Shipping_Street__c != null ? companyAdd.Shipping_Street__c : '');
            primapplicant.addChildElement('Company_Address2', null, null).addTextNode(companyAdd.Shipping_Street__c != null ? companyAdd.Shipping_Street__c : '');
            primapplicant.addChildElement('Company_Address3', null, null).addTextNode(companyAdd.Shipping_Street__c != null ? companyAdd.Shipping_Street__c : '');
            primapplicant.addChildElement('Company_Address4', null, null).addTextNode(companyAdd.Shipping_Street__c != null ? companyAdd.Shipping_Street__c : '');
            primapplicant.addChildElement('Company_Address5', null, null);
            primapplicant.addChildElement('Company_Address6', null, null);
            primapplicant.addChildElement('Company_Postcode', null, null).addTextNode(companyAdd.Shipping_Street__c != null ? companyAdd.Shipping_Street__c : '');
            primapplicant.addChildElement('Company_Phone_Number', null, null).addTextNode('');
            primapplicant.addChildElement('User_Field1', null, null).addTextNode(accountRec.Occupation_Status__pc != null ? accountRec.Occupation_Status__pc : '');		
            primapplicant.addChildElement('User_Field2', null, null).addTextNode(accountRec.Standard_Industry_SIC_Code__c != null ? accountRec.Standard_Industry_SIC_Code__c : '');				
            primapplicant.addChildElement('User_Field3', null, null).addTextNode(accountRec.Occupation_Level__pc != null ? accountRec.Occupation_Level__pc : '');	
            primapplicant.addChildElement('User_Field4', null, null).addTextNode(accountRec.Occupation_Category__pc != null ? accountRec.Occupation_Category__pc : '');
            primapplicant.addChildElement('User_Field5', null, null).addTextNode(accountRec.Country_Passport_Issued__pc != null ? accountRec.Country_Passport_Issued__pc : '');
            primapplicant.addChildElement('User_Field6', null, null).addTextNode(accountRec.Residential_Status__pc != null ? accountRec.Residential_Status__pc : '');
            primapplicant.addChildElement('User_Field7', null, null).addTextNode('');
            primapplicant.addChildElement('User_Field8', null, null).addTextNode(accountRec.PersonEmail != null ? accountRec.PersonEmail : '');	
            
            String languageVal = '';
            if(accountRec.Language__c != null) {
                languageVal = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Language', accountRec.Language__c, StringConstants.OUTBOUND_RECORD_TYPE);
            } else {
                languageVal = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Language', accountRec.Communication_Language__pc, StringConstants.OUTBOUND_RECORD_TYPE);
            }

            primapplicant.addChildElement('User_Field9', null, null).addTextNode(languageVal != null ? languageVal : '');
            primapplicant.addChildElement('User_Field10', null, null).addTextNode(accountRec.Monthly_Income__c != null ? accountRec.Monthly_Income__c : '');	
            primapplicant.addChildElement('User_Field11', null, null).addTextNode('');
            primapplicant.addChildElement('User_Field12', null, null).addTextNode('');
            primapplicant.addChildElement('User_Field13', null, null).addTextNode(accountRec.Marital_Status__pc != null ? accountRec.Marital_Status__pc : '');	
            primapplicant.addChildElement('User_Field14', null, null).addTextNode(accountRec.Number_Of_Dependents__c != null ? String.valueOf(accountRec.Number_Of_Dependents__c) : '');	
            primapplicant.addChildElement('User_Field15', null, null).addTextNode(accountRec.Income_Tax_Number__c != null ? String.valueOf(accountRec.Income_Tax_Number__c) : '');	
            primapplicant.addChildElement('User_Field16', null, null).addTextNode(accountRec.Temporary_resident_permit_number__c != null ? String.valueOf(accountRec.Temporary_resident_permit_number__c) : '');
            primapplicant.addChildElement('User_Field17', null, null).addTextNode('');
            primapplicant.addChildElement('User_Field18', null, null).addTextNode(accountRec.Post_Matric_Qualification__pc != null ? String.valueOf(accountRec.Post_Matric_Qualification__pc) : '');
            primapplicant.addChildElement('User_Field19', null, null);
            primapplicant.addChildElement('User_Field20', null, null);
            
            //Related Party Mappings
            if(!relatedParties.isEmpty()){
                for(Integer i=0; i<relatedParties.size(); i++){
                    dom.xmlNode applicant = base.addchildElement('Applicant',null,null);
                    applicant.addChildElement('Id_Number1', null, null).addTextNode(relatedParties[i].ID_Number__pc!=null ? relatedParties[i].ID_Number__pc : ''); 		//relatedParties[i].ID_Number__pc
                    applicant.addChildElement('Id_Number2', null, null).addTextNode(relatedParties[i].ID_Type__pc!=null ? relatedParties[i].ID_Type__pc : '');
                    applicant.addChildElement('Id_Number3', null, null).addTextNode( relatedParties[i].Registration_Number__c != null ? relatedParties[i].Registration_Number__c : '');
                    applicant.addChildElement('Surname', null, null).addTextNode(relatedParties[i].LastName != null ? relatedParties[i].LastName : relatedParties[i].Name);
                    applicant.addChildElement('First_Name', null, null).addTextNode(relatedParties[i].FirstName!=null ? relatedParties[i].FirstName : ''); 
                    applicant.addChildElement('Middle_Name', null, null).addTextNode(relatedParties[i].MiddleName!=null ? relatedParties[i].MiddleName : '');
                    applicant.addChildElement('Sex', null, null).addTextNode(relatedParties[i].Gender__pc!=null ? relatedParties[i].Gender__pc : '');
                    applicant.addChildElement('Date_Of_Birth', null, null).addTextNode(relatedParties[i].PersonBirthdate != null ? String.ValueOf(relatedParties[i].PersonBirthdate) : '');	
                    
                    Address__c homeAddRelatedParty = new Address__c();
                    Address__c workAddRelatedParty = new Address__c();
                    
                    if(relatedPartyAddressMap.containsKey(relatedParties[i].id)) {
                        if(relatedPartyAddressMap.get(relatedParties[i].id).containskey('homeAddress')) {
                            homeAddRelatedParty = relatedPartyAddressMap.get(relatedParties[i].id).get('homeAddress');
                        } else if (relatedPartyAddressMap.get(relatedParties[i].id).containskey('workAddress')) {
                            workAddRelatedParty = relatedPartyAddressMap.get(relatedParties[i].id).get('workAddress');
                        }
                    }
                    
                    applicant.addChildElement('Home_Address1', null, null).addTextNode(homeAddRelatedParty.Shipping_Street__c != null ? homeAddRelatedParty.Shipping_Street__c : '');
                    applicant.addChildElement('Home_Address2', null, null).addTextNode(homeAddRelatedParty.Shipping_Street_2__c != null ? homeAddRelatedParty.Shipping_Street_2__c : '');
                    applicant.addChildElement('Home_Address3', null, null).addTextNode(homeAddRelatedParty.Shipping_Suburb__c != null ? homeAddRelatedParty.Shipping_Suburb__c : '');
                    applicant.addChildElement('Home_Address4', null, null).addTextNode(homeAddRelatedParty.Shipping_City__c != null ? homeAddRelatedParty.Shipping_City__c : '');
                    applicant.addChildElement('Home_Address5', null, null);
                    applicant.addChildElement('Home_Address6', null, null).addTextNode('');
                    applicant.addChildElement('Home_Postcode', null, null).addTextNode(homeAddRelatedParty.Shipping_Zip_Postal_Code__c != null ? homeAddRelatedParty.Shipping_Zip_Postal_Code__c : '');
                    applicant.addChildElement('Home_Phone_Number', null, null).addTextNode(relatedParties[i].PersonHomePhone != null ? relatedParties[i].PersonHomePhone : '');
                    applicant.addChildElement('Mobile_Phone_Number', null, null).addTextNode(relatedParties[i].PersonMobilePhone!=null ? relatedParties[i].PersonMobilePhone : '');
                    applicant.addChildElement('Company_Name', null, null).addTextNode(relatedParties[i].Employer_Name__pc != null ? relatedParties[i].Employer_Name__pc : '');
                    
                    applicant.addChildElement('Company_Address1', null, null).addTextNode(workAddRelatedParty.Shipping_Street__c != null ? workAddRelatedParty.Shipping_Street__c : '');
                    applicant.addChildElement('Company_Address2', null, null).addTextNode(workAddRelatedParty.Shipping_Street_2__c != null ? workAddRelatedParty.Shipping_Street_2__c : '');
                    applicant.addChildElement('Company_Address3', null, null).addTextNode(workAddRelatedParty.Shipping_Suburb__c != null ? workAddRelatedParty.Shipping_Suburb__c : '');
                    applicant.addChildElement('Company_Address4', null, null).addTextNode(workAddRelatedParty.Shipping_City__c != null ? workAddRelatedParty.Shipping_City__c : '');
                    applicant.addChildElement('Company_Address5', null, null);
                    applicant.addChildElement('Company_Address6', null, null);
                    
                    applicant.addChildElement('Company_Postcode', null, null).addTextNode(workAddRelatedParty.Shipping_Zip_Postal_Code__c != null ? workAddRelatedParty.Shipping_Zip_Postal_Code__c : '');
                    applicant.addChildElement('Company_Phone_Number', null, null).addTextNode('');
                    applicant.addChildElement('User_Field1', null, null).addTextNode(relatedParties[i].Occupation_Status__pc != null ? relatedParties[i].Occupation_Status__pc : '');
                    applicant.addChildElement('User_Field2', null, null).addTextNode(relatedParties[i].Occupation__pc!=null ? relatedParties[i].Occupation__pc : '');
                    applicant.addChildElement('User_Field3', null, null).addTextNode(relatedParties[i].Occupation_Level__pc != null ? relatedParties[i].Occupation_Level__pc : '');
                    applicant.addChildElement('User_Field4', null, null).addTextNode(accountRec.Occupation_Category__pc != null ? accountRec.Occupation_Category__pc : '');
                    applicant.addChildElement('User_Field5', null, null).addTextNode(accountRec.Country_Passport_Issued__pc != null ? accountRec.Country_Passport_Issued__pc : '');
                    applicant.addChildElement('User_Field6', null, null).addTextNode(accountRec.Residential_Status__pc != null ? accountRec.Residential_Status__pc : '');
                    applicant.addChildElement('User_Field7', null, null).addTextNode('');
                    applicant.addChildElement('User_Field8', null, null).addTextNode(relatedParties[i].PersonEmail!=null ? relatedParties[i].PersonEmail : '');
                    
                    String languageValParty = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Language', accountRec.Communication_Language__pc, StringConstants.OUTBOUND_RECORD_TYPE);
                    applicant.addChildElement('User_Field9', null, null).addTextNode(languageValParty != null ? languageValParty : '');
                    applicant.addChildElement('User_Field10', null, null).addTextNode('');
                    applicant.addChildElement('User_Field11', null, null).addTextNode('');
                    applicant.addChildElement('User_Field12', null, null).addTextNode('');
                    applicant.addChildElement('User_Field13', null, null).addTextNode(accountRec.Marital_Status__pc != null ? accountRec.Marital_Status__pc : '');	
                    applicant.addChildElement('User_Field14', null, null).addTextNode('');
                    applicant.addChildElement('User_Field15', null, null).addTextNode('');
                    applicant.addChildElement('User_Field16', null, null);
                    applicant.addChildElement('User_Field17', null, null).addTextNode('');
                    applicant.addChildElement('User_Field18', null, null);
                    applicant.addChildElement('User_Field19', null, null);
                    applicant.addChildElement('User_Field20', null, null);
                }
            }
            
             //Business Entities - Related Party Mappings
             if(!relatedPartiesBusinessEntities.isEmpty()){
                for(Integer i=0; i<relatedPartiesBusinessEntities.size(); i++){
                    dom.xmlNode applicant = base.addchildElement('Applicant',null,null);
                    applicant.addChildElement('Id_Number1', null, null).addTextNode('');
                    applicant.addChildElement('Id_Number2', null, null).addTextNode(relatedPartiesBusinessEntities[i].ID_Type__c!=null ? relatedPartiesBusinessEntities[i].ID_Type__c : '');
                    applicant.addChildElement('Id_Number3', null, null).addTextNode( relatedPartiesBusinessEntities[i].Registration_Number__c != null ? relatedPartiesBusinessEntities[i].Registration_Number__c : '');
                    applicant.addChildElement('Surname', null, null).addTextNode(relatedPartiesBusinessEntities[i].Name != null ? relatedPartiesBusinessEntities[i].Name : '');
                    applicant.addChildElement('First_Name', null, null).addTextNode(''); 
                    applicant.addChildElement('Middle_Name', null, null).addTextNode('');
                    applicant.addChildElement('Sex', null, null).addTextNode('');
                    applicant.addChildElement('Date_Of_Birth', null, null).addTextNode('');	
                    
                    Address__c homeAddRelatedParty = new Address__c();
                    Address__c workAddRelatedParty = new Address__c();
                    
                    if(relatedPartyAddressMap.containsKey(relatedPartiesBusinessEntities[i].id)) {
                        if(relatedPartyAddressMap.get(relatedPartiesBusinessEntities[i].id).containskey('homeAddress')) {
                            homeAddRelatedParty = relatedPartyAddressMap.get(relatedPartiesBusinessEntities[i].id).get('homeAddress');
                        } else if (relatedPartyAddressMap.get(relatedPartiesBusinessEntities[i].id).containskey('workAddress')) {
                            workAddRelatedParty = relatedPartyAddressMap.get(relatedPartiesBusinessEntities[i].id).get('workAddress');
                        }
                    }
                    
                    applicant.addChildElement('Home_Address1', null, null).addTextNode(homeAddRelatedParty.Shipping_Street__c != null ? homeAddRelatedParty.Shipping_Street__c : '');
                    applicant.addChildElement('Home_Address2', null, null).addTextNode(homeAddRelatedParty.Shipping_Street_2__c != null ? homeAddRelatedParty.Shipping_Street_2__c : '');
                    applicant.addChildElement('Home_Address3', null, null).addTextNode(homeAddRelatedParty.Shipping_Suburb__c != null ? homeAddRelatedParty.Shipping_Suburb__c : '');
                    applicant.addChildElement('Home_Address4', null, null).addTextNode(homeAddRelatedParty.Shipping_City__c != null ? homeAddRelatedParty.Shipping_City__c : '');
                    applicant.addChildElement('Home_Address5', null, null);
                    applicant.addChildElement('Home_Address6', null, null).addTextNode('');
                    applicant.addChildElement('Home_Postcode', null, null).addTextNode(homeAddRelatedParty.Shipping_Zip_Postal_Code__c != null ? homeAddRelatedParty.Shipping_Zip_Postal_Code__c : '');
                    applicant.addChildElement('Home_Phone_Number', null, null).addTextNode('');
                    applicant.addChildElement('Mobile_Phone_Number', null, null).addTextNode('');
                    applicant.addChildElement('Company_Name', null, null).addTextNode('');
                    
                    applicant.addChildElement('Company_Address1', null, null).addTextNode(workAddRelatedParty.Shipping_Street__c != null ? workAddRelatedParty.Shipping_Street__c : '');
                    applicant.addChildElement('Company_Address2', null, null).addTextNode(workAddRelatedParty.Shipping_Street_2__c != null ? workAddRelatedParty.Shipping_Street_2__c : '');
                    applicant.addChildElement('Company_Address3', null, null).addTextNode(workAddRelatedParty.Shipping_Suburb__c != null ? workAddRelatedParty.Shipping_Suburb__c : '');
                    applicant.addChildElement('Company_Address4', null, null).addTextNode(workAddRelatedParty.Shipping_City__c != null ? workAddRelatedParty.Shipping_City__c : '');
                    applicant.addChildElement('Company_Address5', null, null);
                    applicant.addChildElement('Company_Address6', null, null);
                    
                    applicant.addChildElement('Company_Postcode', null, null).addTextNode(workAddRelatedParty.Shipping_Zip_Postal_Code__c != null ? workAddRelatedParty.Shipping_Zip_Postal_Code__c : '');
                    applicant.addChildElement('Company_Phone_Number', null, null).addTextNode('');
                    applicant.addChildElement('User_Field1', null, null).addTextNode('');
                    applicant.addChildElement('User_Field2', null, null).addTextNode('');
                    applicant.addChildElement('User_Field3', null, null).addTextNode('');
                    applicant.addChildElement('User_Field4', null, null).addTextNode('');
                    applicant.addChildElement('User_Field5', null, null).addTextNode('');
                    applicant.addChildElement('User_Field6', null, null).addTextNode('');
                    applicant.addChildElement('User_Field7', null, null).addTextNode('');
                    applicant.addChildElement('User_Field8', null, null).addTextNode('');
                    
                    applicant.addChildElement('User_Field9', null, null).addTextNode('');
                    applicant.addChildElement('User_Field10', null, null).addTextNode('');
                    applicant.addChildElement('User_Field11', null, null).addTextNode('');
                    applicant.addChildElement('User_Field12', null, null).addTextNode('');
                    applicant.addChildElement('User_Field13', null, null).addTextNode('');	
                    applicant.addChildElement('User_Field14', null, null).addTextNode('');
                    applicant.addChildElement('User_Field15', null, null).addTextNode('');
                    applicant.addChildElement('User_Field16', null, null);
                    applicant.addChildElement('User_Field17', null, null).addTextNode('');
                    applicant.addChildElement('User_Field18', null, null);
                    applicant.addChildElement('User_Field19', null, null);
                    applicant.addChildElement('User_Field20', null, null);
                }
            }
            
            XmlString = doc.toXmlString();            
            
            /*
            String inputString = '<![CDATA[<?xml version=\'1.0\' encoding=\'UTF-8\'?>'+
                                    '<ApplicationSchema xmlns=\'http://input.dectechsolutions.com\'>'+
                                    '<Application><Organisation>ABS</Organisation><Country_Code>ZA</Country_Code>'+
                                        '<Group_Member_Code/><Application_Number>101802091503411703</Application_Number>'+
                                        '<Capture_Date/><Capture_Time/><Expiry_Date/><Application_Date>09/02/2018</Application_Date>'+
                                        '<Application_Type>CFTS</Application_Type><Amount_Limit>65000</Amount_Limit><Branch>4512</Branch>'+
                                        '<Decision>Approve</Decision><Decision_Reason/><Decision_Date/>'+
                                        '<User_Field1>TELESALES</User_Field1><User_Field2></User_Field2><User_Field3></User_Field3>'+
                                        '<User_Field4>INBOUND</User_Field4><User_Field5>PRIV INDIV - TEMPORARY RESIDENT</User_Field5><User_Field6>ABSA</User_Field6>'+
                                        '<User_Field7/><User_Field8>Quote Accepted</User_Field8><User_Field9>ISS</User_Field9><User_Field10>Capture Wrap up Details</User_Field10>'+
                                        '<User_Field11>Quote Issued</User_Field11><User_Field12/><User_Field13/><User_Field14></User_Field14><User_Field15/>'+
                                        '<User_Field16></User_Field16><User_Field17>VISA PRIVATE BANK CREDIT CARD</User_Field17><User_Field18></User_Field18>'+
                                        '<User_Field19>VISA Card</User_Field19><User_Field20>Credit Card</User_Field20>'+
                                        '<Applicant><Id_Number1>RUSS2341IA</Id_Number1><Id_Number2>PASSPORT</Id_Number2><Id_Number3/>'+
                                        '<Surname>HOGANIT</Surname><First_Name>JESEF</First_Name><Middle_Name/><Sex>M</Sex>'+
                                        '<Date_Of_Birth>01/03/1975</Date_Of_Birth><Home_Address1>270 REPUBLIC ROAD</Home_Address1><Home_Address2></Home_Address2><Home_Address3></Home_Address3>'+
                                        '<Home_Address4>RANDBURG</Home_Address4><Home_Address5/><Home_Address6>SOUTH AFRICA</Home_Address6><Home_Postcode>2194</Home_Postcode>'+
                                        '<Home_Phone_Number/><Mobile_Phone_Number>0834086492</Mobile_Phone_Number><Company_Name>ABSA</Company_Name><Company_Address1>270 REPUBLIC ROAD</Company_Address1>'+
                                        '<Company_Address2></Company_Address2><Company_Address3></Company_Address3><Company_Address4>RANDBURG</Company_Address4><Company_Address5/>'+
                                        '<Company_Address6/><Company_Postcode>2194</Company_Postcode><Company_Phone_Number></Company_Phone_Number><User_Field1>FULL TIME EMPLOYED</User_Field1>'+
                                        '<User_Field2>FINANCE</User_Field2><User_Field3/><User_Field4></User_Field4><User_Field5>PA001</User_Field5><User_Field6>OWNER</User_Field6>'+
                                        '<User_Field7></User_Field7><User_Field8>ANNEJ@ABSA.CO.ZA</User_Field8><User_Field9>ENGLISH</User_Field9>'+
                                        '<User_Field10>120000</User_Field10><User_Field11>51000</User_Field11><User_Field12>08/02/2018</User_Field12><User_Field13>SINGLE - </User_Field13>'+
                                        '<User_Field14>0</User_Field14><User_Field15>0</User_Field15><User_Field16/><User_Field17>PRIM</User_Field17>'+
                                        '<User_Field18/><User_Field19/><User_Field20/></Applicant>'+
                                        '</Application></ApplicationSchema>'+
                                    ']]>';
            */
            requestBean.InstinctFraudCheck_XMLString.inputXMLString = XmlString.replaceAll('"', '\'');
            return requestBean;
    }
}