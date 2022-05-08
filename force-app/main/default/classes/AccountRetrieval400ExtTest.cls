/**
 * @description Test class for AccountRetrieval400Ext Class
 * @author Prashant Jain
 * @created 09/03/2021
 * @updated 2021-10-22 Koketso Mpshane
 */
@isTest
public class AccountRetrieval400ExtTest {
	@TestSetup
	static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ ChewyAgentStatus_IH_v1.INTEGRATION_SERVICE_NAME, ChewyAgentLookup_IH_v1.INTEGRATION_SERVICE_NAME }
		);
		IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(StringConstants.API_MANAGER, new List<String>{ 'Get Client Details' });
		User currentUser = new User(Id = userInfo.getUserId(), Agent_ID__c = null);
		update currentUser;
	}

	@isTest
	static void testGetCIFData() {
		StaticResource sr = [SELECT Id, Body FROM StaticResource WHERE Name = :ChewyAgentLookup_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE LIMIT 1];
		String responseChewyAgentLookup = sr.Body.toString();
		sr = [SELECT Id, Body FROM StaticResource WHERE Name = :ChewyAgentStatus_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE LIMIT 1];
		String responseChewyAgentStatus = sr.Body.toString();
		String responseCIFGetClient = '{"indCifRecFound":"Y","clientCode":"LEBOTL 001","initials":"L","language":"E","titleCode":"2","surname":"LEBOTSE","postlAddrLine1":"123 WF NKOMO","postlAddrLine2":"","postlSuburb":"","postlTown":"CENTRAL","postlCodeRsa":"2","idDocType":"1","idNumber":"9012090586088","birthDate":"19901209","maritalStatus":"1","smsMarkInd":"N","gender":"2","minorChildren":"1","occupationCode":"15","incomeGroup":"16","bankingSector":"1","securityIndicator":"","liabilityIndicator":"","telebankIndicator":"","unclaimedFundsInd":"","branchClientOpened":"4512","dateClientOpened":"20181008","changeNumber":"21","dateLastChanged":"20190712","siteLastChanged":"0","tellerLastChanged":"0","nbrOfAccounts":"3","prohibitedInd":"N","postalAddrHold":"N","absaRewardIndctor":"","idRequiredHold":"N","deceasedEstateHld":"N","deceasedSpouseHld":"N","insolvntEstateHld":"N","curatorshipHold":"N","savngStatementHold":"N","courtAuthrityHold":"N","thirdPartyInd":"Y","mandateCaptureHld":"","powerAttornyHold":"","sbuSegment":"F","mariageContrctType":"3","homeLanguage":"N","marketingConcent":"N","clientType":"101","miltaryComtmntInd":"N","occupationType":"O","noOfJointPartcpnt":"0","taxNumber":"0","sicCode":"0","firstNames":"LESEGO","insolventIndicator":"N","companyYearEnd":"0","homeTelCode":"0","homeTelephone":"","workTelCode":"11","workTelephone":"5563232","physicalAddrHold":"N","employerAddrHold":"N","cellphone":"66000000000","faxWorkCode":"0","faxWorkNumber":"0","faxHomeCode":"0","faxHomeNumber":"0","occupationStatus":"1","employmentSector":"6","occupationLevel":"4","practiceNumber":"","clientWebsite":"","contactPerson":"","designation":"0","emailAddress":"","inliPolicy":"","exliPolicy":"","instPolicy":"","exstPolicy":"","inivPolicy":"","flexiFuneralPolicy":"","prefrdCommtionMthd":"4","cellphoneBankInd":"","siccCode5":"00000","subSegment":"F1","emailMarkInd":"N","teleMarkInd":"N","internetBankinInd":"","sourceOfIncome":"20","dateIdentified":"15032019","dateVerified":"15032019","employeeIdentified":"9130622","employeeVerified":"9130622","vatRegistrationNo":"","clientNationality":"SOU01","countryOfOrigin":"","dateNClntExempted":"0","dateAClntExempted":"","statusOfExemption":"N","exemptionIndicator":"00","corporateDivision":"A","postMatricQualifd":"N","postMatricQualfton":"0","receiveSocialGrant":"N","notifyMeIndicator":"","mailInd":"N","applyDebtCounsel":"N","dteApplyCounsel":"0","counselOrderIssue":"N","dteOrderIssue":"0","groupScheme":"99999","groupSchemeEmp":"","secondaryCard":"N","affectedPerson":"0","exconExpiryDate":"0","dateIssued":"15032019","ibrAffected":"N","clientGroup":"I","nbrOfAddressesRtrv":"2","addressEntry":[{"addrType":"10","addrSeqNbr":"0","addrLine1":"123 WF NKOMO","addrLine2":"","addrSuburbRsa":"","addrTown":"CENTRAL","addrPostlCode":"2"},{"addrType":"70","addrSeqNbr":"0","addrLine1":"NAPPIES","addrLine2":"270 MAGGS STREET","addrSuburbRsa":"","addrTown":"WALTLOO","addrPostlCode":"184"},{"addrType":"0","addrSeqNbr":"0","addrLine1":"","addrLine2":"","addrSuburbRsa":"","addrTown":"","addrPostlCode":"0"},{"addrType":"0","addrSeqNbr":"0","addrLine1":"","addrLine2":"","addrSuburbRsa":"","addrTown":"","addrPostlCode":"0"},{"addrType":"0","addrSeqNbr":"0","addrLine1":"","addrLine2":"","addrSuburbRsa":"","addrTown":"","addrPostlCode":"0"}],"clsPercEntry":[{"classification":"","percentage":"0"},{"classification":"","percentage":"0"},{"classification":"","percentage":"0"}],"tempPermitNbr":"","permitExpDte":"0","subClassCde":"","countryIncorp":"","inBusinessRescue":"N","placedBy":"0","dateBusRescueIss":"0","ncaThreshold":"","cpaThreshold":"","nkinSurname":"LEBOTSE","nkinFname":"THABO","nkinRela":"8","nkinDcdh":"","nkinTelh":"","nkinDcdw":"","nkinTelw":"","nkinCell":"0710000000","nkinEmail":"","nkinTitle":"00","nkinInitials":"","nkinJntSurname":"","reasonCodeO":"0","duplClntCode":[{"duplCode":""},{"duplCode":""},{"duplCode":""}],"forensicHold":"N","updAddressInd":"Y","updTelephoneInd":"Y","updEmailInd":"N","updDateInd":"8102018","pingitWallet":"N","pingitReceive":"N","clntExstOnFica":"N","regAddrLine1":"","regAddrLine2":"","regSuburb":"","regTown":"","regCodeRsa":"0","hoAddrLine1":"","hoAddrLine2":"","hoSuburb":"","hoTown":"","hoCodeRsa":"0","countryResAddress":"SO003","countryHoAddress":"","countryRegAddress":"","countryEntOprtData":[{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""},{"countryEntOprt":""}],"countryOfBirth":"SO003","mclInd":"","finCrimeHold":"N","clntAgrmntIssued":"Y","sec129DeliveryAddr":"2","saTaxRegis":"N","rsonSaTaxNotGiven":"","foreignTaxRegis":"N","foreignTaxData":[{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotGiven":"0"},{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotGiven":"0"},{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotGiven":"0"},{"foreignTaxCtry":"","foreignTaxNo":"","rsonFtaxNotGiven":"0"}],"safeCustody":"N","safeCustBoxSmall":"0","safeCustBoxMedium":"0","safeCustBoxLarge":"0","safeCustEnvelope":"0","nonCreditIndicator":"Y","nonCreditDateChanged":"20190712","nonCreditSms":"Y","nonCreditEmail":"Y","nonCreditAvoice":"Y","nonCreditTelephone":"Y","nonCreditPost":"Y","creditIndicator":"Y","creditDateChanged":"20190712","creditSms":"Y","creditEmail":"Y","creditAvoice":"Y","creditTelephone":"Y","creditPost":"Y"}';

		// Set mock callout
		RestClientUtils.QueueHttpMock queueHttpMock = new RestClientUtils.QueueHttpMock();
		queueHttpMock.addResponse(responseChewyAgentLookup);
		queueHttpMock.addResponse('{}'); // Mock response for SystemLogger.insertLog callout
		queueHttpMock.addResponse(responseChewyAgentStatus);
		queueHttpMock.addResponse('{}'); // Mock response for SystemLogger.insertLog callout
		queueHttpMock.addResponse(responseCIFGetClient);
		Test.setMock(HttpCalloutMock.class, queueHttpMock);

		Test.startTest();
		List<List<SObject>> queryList = AccountRetrieval400Ext.getCIFData();
		System.assertNotEquals(null, queryList, 'Assert Failed');
		System.assert(!queryList.isEmpty(), 'Assert Failed');
		System.assert(!queryList.get(0).isEmpty(), 'Assert Failed');
		Test.stopTest();
	}

	@isTest
	static void testMaintainSessionCache() {
		// Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
				StringConstants.POSITIVE_STRING,
				ChewyAgentStatus_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
			)
		);

		Test.startTest();
		AccountRetrieval400Ext.maintainSessionCache('', 'agentId');
		System.assert(Cache.Session.contains('local.Customer1Cache.clientIDnVSessionObject'), 'Assert Failed');
		AccountRetrieval400Ext.updateTaskIdInSessionCache('taskId');
		ClientIDnVPollingApex.ClientIDnVSessionObject clientIDnVSessionObj = (ClientIDnVPollingApex.ClientIDnVSessionObject) Cache.Session.get(
			'local.Customer1Cache.clientIDnVSessionObject'
		);
		System.assert(String.isNotBlank(clientIDnVSessionObj.taskId), 'Assert Failed');
		Test.stopTest();
	}

	@isTest
	static void testGetAgentId() {
		// Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
				StringConstants.POSITIVE_STRING,
				ChewyAgentLookup_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
			)
		);

		Test.startTest();
		String agentId = AccountRetrieval400Ext.getAgentId();
		System.assert(String.isNotBlank(agentId), 'Assert Failed');
		Test.stopTest();
	}

	@isTest
	static void testUpdateAgentIdForUser() {
		// Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
				StringConstants.POSITIVE_STRING,
				ChewyAgentLookup_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
			)
		);

		Test.startTest();
		AccountRetrieval400Ext.updateAgentIdForUser();
		Test.stopTest();

		User usrRecord = new UsersSelector().selectById(UserInfo.getUserId());
		System.assert(String.isNotBlank(usrRecord.Agent_ID__c), 'Assert Failed');
	}

	@isTest
	static void testsetUCIDInSessionCache() {
		Test.startTest();
		AccountRetrieval400Ext.setUCIDInSessionCache('354365466565');
		Test.stopTest();

		ClientIDnVPollingApex.ClientIDnVSessionObject sessionObj = (ClientIDnVPollingApex.ClientIDnVSessionObject) Cache.Session.get(
			'local.Customer1Cache.clientIDnVSessionObject'
		);
		System.assert(String.isNotBlank(sessionObj.ucId), 'Assert Failed');
	}
}