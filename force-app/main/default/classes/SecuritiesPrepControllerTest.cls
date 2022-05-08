/**
 * @description       : Test class for SecuritiesPrepController
 * @author            : Himani Joshi
 * @last modified on  : 2021-10-19
 * @last modified by  : almas.aleem@absa.africa
 * Modifications Log
 * Ver   Date         Author         Modification
 * 1.0   2021-07-12   Himani Joshi   Initial Version
 **/
@IsTest
public class SecuritiesPrepControllerTest{
	@testSetup
	static void createData(){
		Account ac = new Account(Name = 'SOUTH AFRICAN COMPENSATORS (PTY) LTD',Registration_Number__c = '1997/05');
		insert ac;
		Opportunity opp = new Opportunity();
		opp.Name = 'EPP';
		opp.StageName = 'Not Interested';
		opp.accountid = ac.Id;
		opp.CloseDate = Date.today()+10;
		insert opp;
		Contact con = new Contact();
		con.AccountId = ac.Id;
		con.FirstName = 'alfie';
		con.lastname = 'Smithers';
		con.Email = 'takalani.ndou@absa.africa';
		con.Phone = '0782895686';
		con.MobilePhone = '0782895686';
		insert con;
		Address__c add = new Address__c();
		add.Account__c = ac.Id;
		add.Address_Type__c = 'Physical Address';
		add.Address1__c = '89 DEVONSHIRE AVENUE';
		add.Address2__c = 'BRYANSTON';
		add.Shipping_Suburb__c = 'BRYANSTON';
		add.Shipping_Zip_Postal_Code__c = '2021';
		add.Shipping_City__c = 'SANDTON';
		add.Shipping_Country__c = 'South Africa';
		insert add;
		Application__c application = new Application__c();
		application.Opportunity__c = opp.Id;
		insert application;
		List<Security_Offered__c> secList = new List<Security_Offered__c>();
		Security_Offered__c sc1 = new Security_Offered__c();
		sc1.Application__c = application.Id;
		sc1.Account__c = ac.Id;
		sc1.Physical_Address_line_1__c = null;
		sc1.Security_Type__c = 'General Pledge';
		sc1.Contact__c = con.id;
		sc1.Specific_Security__c = 'No';
		secList.add(sc1);
		Security_Offered__c sc2 = new Security_Offered__c();
		sc2.Application__c = application.Id;
		sc2.Account__c = ac.Id;
		sc2.Physical_Address_line_1__c = '89 DEVONSHIRE AVENUE';
		sc2.Security_Type__c = 'Suretyship';
		sc2.External_Entity_Linked__c = false;
		sc2.Client_Name__c = 'Test';
		sc2.Specific_Security__c = 'Yes';
		sc2.Securities_Offered_for_Facility__c = 'Existing';
		sc2.Reference_Account_Number__c = '1234567';
		secList.add(sc2);

		Security_Offered__c sc3 = new Security_Offered__c();
		sc3.Application__c = application.Id;
		sc3.Account__c = ac.Id;
		sc3.Physical_Address_line_1__c = '89 DEVONSHIRE AVENUE';
		sc3.Security_Type__c = 'Cession of Debtors';
		sc3.External_Entity_Linked__c = false;
		sc3.Client_Name__c = 'Test';
		sc3.Specific_Security__c = 'Yes';
		sc3.Securities_Offered_for_Facility__c = 'New';
		sc3.Reference_Account_Number__c = 'CHQ-1234567';
		secList.add(sc3);

		Security_Offered__c sc4 = new Security_Offered__c();
		sc4.Application__c = application.Id;
		sc4.Account__c = ac.Id;
		sc4.Physical_Address_line_1__c = '89 DEVONSHIRE AVENUE';
		sc4.Security_Type__c = 'Letter of Undertaking';
		sc4.External_Entity_Linked__c = false;
		sc4.Client_Name__c = 'Test';
		sc4.Specific_Security__c = 'Yes';
		sc4.Securities_Offered_for_Facility__c = 'New';
		sc4.Reference_Account_Number__c = 'CHQ-1234567';
		secList.add(sc4);

		Security_Offered__c sc5 = new Security_Offered__c();
		sc5.Application__c = application.Id;
		sc5.Account__c = ac.Id;
		sc5.Physical_Address_line_1__c = null;
		sc5.Security_Type__c = 'General Cession';
		sc5.Contact__c = con.id;
		sc5.Specific_Security__c = 'No';
		secList.add(sc5);

		Security_Offered__c sc6 = new Security_Offered__c();
		sc6.Application__c = application.Id;
		sc6.Account__c = ac.Id;
		sc6.Physical_Address_line_1__c = null;
		sc6.Security_Type__c = 'Cession of Fire/Short Term Insurance';
		sc6.Contact__c = con.id;
		sc6.Specific_Security__c = 'No';
		secList.add(sc6);

		Security_Offered__c sc7 = new Security_Offered__c();
		sc7.Application__c = application.Id;
		sc7.Account__c = ac.Id;
		sc7.Physical_Address_line_1__c = null;
		sc7.Security_Type__c = 'Excon Ruling';
		sc7.Contact__c = con.id;
		sc7.Specific_Security__c = 'No';
		secList.add(sc7);

		Security_Offered__c sc8 = new Security_Offered__c();
		sc8.Application__c = application.Id;
		sc8.Account__c = ac.Id;
		sc8.Physical_Address_line_1__c = null;
		sc8.Security_Type__c = 'Bonds and 99-year Leasehold';
		sc8.Contact__c = con.id;
		sc8.Specific_Security__c = 'Yes';
		secList.add(sc8);

		insert secList;
		BusinessHours businessHr = [SELECT Id
		                            FROM BusinessHours
		                            LIMIT 1];
		Service_Type__c serviceType = new Service_Type__c(Name = 'Test1', Case_Record_Type__c = 'New', Subtype__c = 'Sample', Type__c = 'T01');
		insert serviceType;

		Service_Group__c serviceGroup = new Service_Group__c(Name = 'Security Prep', Queue__c = 'Flight Centre', Business_Hours__c = businessHr.Id);
		insert serviceGroup;

		Service_Level__c serviceLevel = new Service_Level__c(Name = 'Test1', External_SLA_Time_Measure__c = 'Hour(s)', External_SLA_Units__c = '8', Default_Service_Level__c = true);
		insert serviceLevel;

		Service_Group_Type__c serviceGrType = new Service_Group_Type__c(Service_Type__c = serviceType.Id, Service_Group__c = serviceGroup.Id, Service_Level__c = serviceLevel.Id);
		insert serviceGrType;
        
        
        
        
        
        
        
        Service_Type__c serviceType1 = new Service_Type__c(Name = 'Test1', Case_Record_Type__c = 'New', Subtype__c = 'Sample', Type__c = 'T01');
		insert serviceType1;

		Service_Group__c serviceGroup1 = new Service_Group__c(Name = 'Bond Registration Flight Centre', Queue__c = 'Flight Centre', Business_Hours__c = businessHr.Id);
		insert serviceGroup1;

		Service_Level__c serviceLevel1 = new Service_Level__c(Name = 'Test1', External_SLA_Time_Measure__c = 'Hour(s)', External_SLA_Units__c = '8', Default_Service_Level__c = true);
		insert serviceLevel1;

		Service_Group_Type__c serviceGrType1 = new Service_Group_Type__c(Service_Type__c = serviceType1.Id, Service_Group__c = serviceGroup1.Id, Service_Level__c = serviceLevel1.Id);
		insert serviceGrType1;
	}

	@isTest
	static void testgetSecuritiesOffered(){
		Opportunity opp = [SELECT Id, accountId
		                   FROM Opportunity
		                   LIMIT 1];
		Security_Offered__c scc = [SELECT Id
		                           FROM Security_Offered__c
		                           LIMIT 1];
		List<String> selectedNames = new List<String>{'alfie Smithers'};
		test.startTest();

		Map<string, List<object>> securityPrep = SecuritiesPrepController.getSecuritiesOffered(opp.Id);

		SecuritiesPrepController.createCaseForFlightCentre(opp.Id, opp.accountId,scc.Id ,'Security Prep');

		List<Address__c> ads = SecuritiesPrepController.getAddresses(opp.accountId);

		System.assertNotEquals(null, securityPrep);
		SecuritiesPrepController.getAccountContactRelationData('1234567890', opp.Id);
		SecuritiesPrepController.getSecurityOfferedDocuments(scc.id);
		test.stopTest();
	}

	@isTest
	private static void testSelectAccountByIdPassportRegNumber(){
		Account testAcc = [SELECT Id, Registration_Number__c
		                   FROM Account
		                   LIMIT 1];

		Test.startTest();
		List<Account> testAccountList = SecuritiesPrepController.getAccountData(testAcc.Registration_Number__c);
		System.assertNotEquals(0, testAccountList.size());
		Test.stopTest();
	}

	@isTest
	private static void testgetSecurityDocumentTypes(){
		Test.startTest();
		List<Security_Documents__mdt> docList = SecuritiesPrepController.getSecurityDocumentTypes('Suretyship', 'SECURITY ON BEHALF OF A COMPANY WITHOUT A RESOLUTION', 'N');
		system.assertNotEquals(null, docList);
		Test.stopTest();
	}
    
    @isTest
	private static void testBondRegCase(){
		Opportunity opp = [SELECT Id, accountId
		                   FROM Opportunity
		                   LIMIT 1];
		Security_Offered__c scc = [SELECT Id
		                           FROM Security_Offered__c
		                           LIMIT 1];
		List<String> selectedNames = new List<String>{'alfie Smithers'};
		test.startTest();

		Map<string, List<object>> securityPrep = SecuritiesPrepController.getSecuritiesOffered(opp.Id);

		SecuritiesPrepController.createBondRegistrationCase(opp.Id, opp.accountId,scc.Id ,'Bond Registration Flight Centre');

		SecuritiesPrepController.updateSecurities(scc.Id);

		System.assertNotEquals(null, securityPrep);

		Test.stopTest();
	}
    
    @isTest
	private static void testcaseSecurities(){
        
        Opportunity opp = [SELECT Id, accountId
		                   FROM Opportunity
		                   LIMIT 1];
		Security_Offered__c scc = [SELECT Id
		                           FROM Security_Offered__c
		                           LIMIT 1];
		List<String> selectedNames = new List<String>{'alfie Smithers'};
		

		Map<string, List<object>> securityPrep = SecuritiesPrepController.getSecuritiesOffered(opp.Id);

		SecuritiesPrepController.createBondRegistrationCase(opp.Id, opp.accountId,scc.Id ,'Bond Registration Flight Centre');
		
        Case cs = [Select Id From Case LIMIT 1];
        
        
		Test.startTest();
		securitiesOnCaseController.updateSecurities(cs.Id);
		Test.stopTest();
        System.assertNotEquals(null, securityPrep);
	}
}