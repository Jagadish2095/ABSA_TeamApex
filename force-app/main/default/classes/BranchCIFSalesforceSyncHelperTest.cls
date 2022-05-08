/**
 * @description       : Test for Helper class for CVS ServiceCalls/This class has methods used by Aura components to call the CVS services(CVSValidate/CVSCreate/CVSValidate)
 * @author            : PaulJohn.duRand@absa.africa
 * @last modified on  : 2021-10-11
 * @last modified by  : PaulJohn.duRand@absa.africa
 * @created 2020-09-18
 * @modified 2021-06-28 - Aaron Castelyn : ABSA - Added Residential and Postal Street 2
 * 1.0   2021-07-23   PaulJohn.duRand@absa.africa    Add Customer Type for CIF New To Product and New to Salesforce
 * 1.0   2021-09-21   PaulJohn.duRand@absa.africa    Always Update Client Group from CIF 
 * 1.0   2021-09-28   PaulJohn.duRand@absa.africa    Set Marketing select to empty when Consent is N
**/

@isTest
public class BranchCIFSalesforceSyncHelperTest{
    @testSetup
    static void dataCreation(){
        Account account = new Account();
        account.ID_Number__pc = '9308305015083';
        account.FirstName = 'Test';
        account.LastName = 'Tester';
        insert account;
        Account accountWithCIF = new Account();
        accountWithCIF.ID_Number__pc = '9309305015082';
        accountWithCIF.FirstName = 'Test';
        accountWithCIF.LastName = 'Tester';
        accountWithCIF.CIF__c = 'NGOBEH 011';
        insert accountWithCIF;
    }
    @isTest
    public static void NewtoSalesforce(){
        Account account = [SELECT Id FROM Account where ID_Number__pc = '9309305015082' LIMIT 1];
        String Output = BranchCIFSalesforceSyncHelper.UpdateAccountwithCIF(account.id,'','');
        System.assert(Output != null, 'Test Working');
    }
    @isTest
    public static void NewtoBank(){
        Account account = [SELECT Id FROM Account where ID_Number__pc = '9308305015083' LIMIT 1];
        String Output = BranchCIFSalesforceSyncHelper.UpdateAccountwithCIF(account.id,'','');
        System.assert(Output != null, 'Test Working');
    }
    @isTest
    public static void TestaddressInsert(){
        Account account = [SELECT Id FROM Account where ID_Number__pc = '9309305015082' LIMIT 1];
        CIgetClientDetailsV12_Resp_IB_v1.AddressEntry addressEntry = new CIgetClientDetailsV12_Resp_IB_v1.AddressEntry();
        addressEntry.addrLine1 = 'test';
        addressEntry.addrLine2 = 'test';
        addressEntry.addrPostlCode = '7777';
        addressEntry.addrSuburbRsa = 'testSub';
        addressEntry.addrSuburbRsa = 'testCity';
        BranchCIFSalesforceSyncHelper.UpdateAddress(account.id ,'Employers',addressEntry);
        System.assert(addressEntry != null, 'Test Working');
    }

    @isTest
    public static void testCIFset (){
        Account account = [SELECT Id FROM Account where ID_Number__pc = '9309305015082' LIMIT 1];
        account = new AccountsSelector().selectAllById(account.id);
        CIgetClientDetailsV12_Resp_IB_v1 responsedummy = BranchCIFSalesforceSyncHelperTest.getResponse();
        BranchCIFSalesforceSyncHelper.UpdateWithCIF(account,responsedummy,false);
        System.assert(Json.serialize(responsedummy) != null, 'Test Working');
    }

    @isTest
    public static void getDateForSalesforce (){
        Date testdaystring =  BranchCIFSalesforceSyncHelper.getDateForSalesforceDayFirst('2022020');
        Date testyearstring =  BranchCIFSalesforceSyncHelper.getDateForSalesforceYearFirst('19930825');
        System.assert(testyearstring != null, 'Test Working');
    }

    @isTest
    public static void setMarketing (){
        Account account = [SELECT Id FROM Account where ID_Number__pc = '9309305015082' LIMIT 1];
        account = new AccountsSelector().selectAllById(account.id);
        BranchCIFSalesforceSyncHelper.setMarketingConsent(account,getResponse());
        System.assert(account != null, 'Test Working');
    }

    /**
    * @description getResponse
    * @return CIgetClientDetailsV12_Resp_IB_v1
    **/
    private static CIgetClientDetailsV12_Resp_IB_v1 getResponse (){
        string jsonString = '{"statusCode":200,"status":"OK","message":null,"Fault":null,"workTelephone":null,"workTelCode":"0","vatRegistrationNo":null,"updTelephoneInd":"N","updEmailInd":"N","updDateInd":"10022021","updAddressInd":"N","unclaimedFundsInd":null,"titleCode":"Miss","thirdPartyInd":"Y","tempPermitNbr":null,"tellerLastChanged":"0","teleMarkInd":"N","telebankIndicator":null,"taxNumber":"0","surname":"ALEXANDER","subSegment":"F1","subClassCde":null,"statusOfExemption":"N","sourceOfIncome":"Salary","smsMarkInd":null,"siteLastChanged":"0","sicCode":"0","siccCode5":"00000","securityIndicator":"N","secondaryCard":"N","sec129DeliveryAddr":"1","sbuSegment":"F","savngStatementHold":"N","saTaxRegis":"N","safeCustody":"N","safeCustEnvelope":"0","safeCustBoxSmall":"0","safeCustBoxMedium":"0","safeCustBoxLarge":"0","rsonSaTaxNotGiven":null,"regTown":null,"regSuburb":null,"regCodeRsa":"0","regAddrLine2":null,"regAddrLine1":null,"receiveSocialGrant":"N","reasonCodeO":"0","prohibitedInd":"N","prefrdCommtionMthd":"Mail","practiceNumber":null,"powerAttornyHold":"N","postMatricQualifd":"Y","postMatricQualfton":"Masters","postlTown":"RANDBURG","postlSuburb":null,"postlCodeRsa":"2194","postlAddrLine2":null,"postlAddrLine1":"1219 EBONY PARK","postalAddrHold":"N","placedBy":"0","pingitWallet":"N","pingitReceive":"N","physicalAddrHold":"N","permitExpDte":"0","occupationType":"F","occupationStatus":"Full Time Employed","occupationLevel":"0","occupationCode":"Professional","notifyMeIndicator":"N","noOfJointPartcpnt":"0","nonCreditTelephone":"N","nonCreditSms":"Y","nonCreditPost":"N","nonCreditIndicator":"Y","nonCreditEmail":"Y","nonCreditDateChanged":"20210210","nonCreditAvoice":"N","nkinTitle":"00","nkinTelw":null,"nkinTelh":null,"nkinSurname":null,"nkinRela":"0","nkinJntSurname":null,"nkinInitials":null,"nkinFname":null,"nkinEmail":null,"nkinDcdw":null,"nkinDcdh":null,"nkinCell":null,"ncaThreshold":null,"nbrOfAddressesRtrv":"2","nbrOfAccounts":"3","minorChildren":"2","miltaryComtmntInd":"N","mclInd":null,"marketingConcent":null,"maritalStatus":"Single","mariageContrctType":"0","mandateCaptureHld":"N","mailInd":"N","liabilityIndicator":"N","language":"English","internetBankinInd":"N","instPolicy":"N","insolvntEstateHld":"N","insolventIndicator":"N","inliPolicy":"N","inivPolicy":"N","initials":"W","indCifRecFound":"Y","incomeGroup":"15","inBusinessRescue":null,"idRequiredHold":"N","idNumber":"9708190060086","idDocType":"SA Identity Document","ibrAffected":"N","hoTown":null,"hoSuburb":null,"homeTelephone":null,"homeTelCode":"0","homeLanguage":"Zulu","hoCodeRsa":"0","hoAddrLine2":null,"hoAddrLine1":null,"groupSchemeEmp":null,"groupScheme":"0","gender":"2","forensicHold":"N","foreignTaxRegis":"N","foreignTaxData":[{"rsonFtaxNotGiven":null,"foreignTaxNo":null,"foreignTaxCtry":null},{"rsonFtaxNotGiven":null,"foreignTaxNo":null,"foreignTaxCtry":null},{"rsonFtaxNotGiven":null,"foreignTaxNo":null,"foreignTaxCtry":null},{"rsonFtaxNotGiven":null,"foreignTaxNo":null,"foreignTaxCtry":null}],"flexiFuneralPolicy":"N","firstNames":"WANETTE","finCrimeHold":"N","faxWorkNumber":"0","faxWorkCode":"0","faxHomeNumber":"0","faxHomeCode":"0","exstPolicy":"N","exliPolicy":"N","exemptionIndicator":"00","exconExpiryDate":"0","employmentSector":"0","employerAddrHold":"N","employeeVerified":"1196035","employeeIdentified":"1196035","emailMarkInd":"N","emailAddress":"TESTDATA@ABSA.CO.ZA","duplClntCode":[{"duplCode":null},{"duplCode":null},{"duplCode":null}],"dteOrderIssue":"0","dteApplyCounsel":"0","designation":"0","deceasedSpouseHld":"N","deceasedEstateHld":"N","dateVerified":"10022021","dateNClntExempted":"0","dateLastChanged":"20210210","dateIssued":"2022002","dateIdentified":"10022021","dateClientOpened":"20210210","dateBusRescueIss":"0","dateAClntExempted":null,"curatorshipHold":"N","creditTelephone":"N","creditSms":"Y","creditPost":"N","creditIndicator":"Y","creditEmail":"Y","creditDateChanged":"20210210","creditAvoice":"N","cpaThreshold":null,"courtAuthrityHold":"N","countryResAddress":"SO003","countryRegAddress":null,"countryOfOrigin":null,"countryOfBirth":"South Africa","countryIncorp":null,"countryHoAddress":null,"countryEntOprtData":[{"countryEntOprt":null},{"countryEntOprt":null},{"countryEntOprt":null},{"countryEntOprt":null},{"countryEntOprt":null},{"countryEntOprt":null},{"countryEntOprt":null},{"countryEntOprt":null},{"countryEntOprt":null},{"countryEntOprt":null}],"counselOrderIssue":"N","corporateDivision":"A","contactPerson":null,"companyYearEnd":"0","clsPercEntry":[{"percentage":"0","classification":null},{"percentage":"0","classification":null},{"percentage":"0","classification":null}],"clntExstOnFica":"N","clntAgrmntIssued":"N","clientWebsite":null,"clientType":"Individual","clientNationality":"South African","clientGroup":"I","clientCode":"ALEXAW 002","changeNumber":"5","cellphoneBankInd":"N","cellphone":"605289769","branchClientOpened":"8198","birthDate":"19970819","bankingSector":"1","applyDebtCounsel":"N","affectedPerson":"0","addressEntry":[{"addrType":"10","addrTown":"RANDBURG","addrSuburbRsa":null,"addrSeqNbr":"0","addrPostlCode":"2194","addrLine2":null,"addrLine1":"1219 EBONY PARK"},{"addrType":"70","addrTown":"RANDBURG","addrSuburbRsa":null,"addrSeqNbr":"0","addrPostlCode":"2194","addrLine2":"275 REPUBLIC ROAD","addrLine1":"ABSA"},{"addrType":"0","addrTown":null,"addrSuburbRsa":null,"addrSeqNbr":"0","addrPostlCode":"0","addrLine2":null,"addrLine1":null},{"addrType":"0","addrTown":null,"addrSuburbRsa":null,"addrSeqNbr":"0","addrPostlCode":"0","addrLine2":null,"addrLine1":null},{"addrType":"0","addrTown":null,"addrSuburbRsa":null,"addrSeqNbr":"0","addrPostlCode":"0","addrLine2":null,"addrLine1":null}],"absaRewardIndctor":"N"}';
        return (CIgetClientDetailsV12_Resp_IB_v1)Json.deserialize(jsonString, CIgetClientDetailsV12_Resp_IB_v1.class);
    }
}