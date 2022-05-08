/**
 * @description GenerateCreditDocumentsTest Description
 * split generateDocuments class per stream
 */
@IsTest
public class GenerateCreditDocumentsTest {
    @TestSetup
    static void makeData() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Date todaysDate = System.today();

        Contact con = new Contact(FirstName='Test',Lastname='Test');
        insert con;

        Account acc = new Account(Name = 'Test New Bus Client', Client_Type__C = 'Private Company');
        insert acc;

        List<Address__c> addrList = new List<Address__c>();
        addrList.add(new Address__c(Account__c=acc.Id, Address_Type__c='Physical Address',Client_Entity_Type__c='Individual',Shipping_Country__c='South Africa', Shipping_State_Province__c='Gauteng',Shipping_Street__c='Street 37',Shipping_Suburb__c='Maboneng',Shipping_Zip_Postal_Code__c='1619',Shipping_City__c='City'));
        addrList.add(new Address__c(Account__c=acc.Id, Address_Type__c='Postal',Client_Entity_Type__c='Individual',Shipping_Country__c='South Africa', Shipping_State_Province__c='Gauteng',Shipping_Street__c='Street 37',Shipping_Suburb__c='Maboneng',Shipping_Zip_Postal_Code__c='1619',Shipping_City__c='City'));
        addrList.add(new Address__c(Account__c=acc.Id, Address_Type__c='OperatingAddress',Client_Entity_Type__c='Individual',Shipping_Country__c='South Africa', Shipping_State_Province__c='Gauteng',Shipping_Street__c='Street 37',Shipping_Suburb__c='Maboneng',Shipping_Zip_Postal_Code__c='1619',Shipping_City__c='City'));
        addrList.add(new Address__c(Account__c=acc.Id, Address_Type__c='Head Office',Client_Entity_Type__c='Company',Shipping_Country__c='South Africa', Shipping_State_Province__c='Gauteng',Shipping_Street__c='Street 37',Shipping_Suburb__c='Maboneng',Shipping_Zip_Postal_Code__c='1619',Shipping_City__c='City'));
        addrList.add(new Address__c(Account__c=acc.Id, Address_Type__c='Business Address',Client_Entity_Type__c='Company',Shipping_Country__c='South Africa', Shipping_State_Province__c='Gauteng',Shipping_Street__c='Street 37',Shipping_Suburb__c='Maboneng',Shipping_Zip_Postal_Code__c='1619',Shipping_City__c='City'));
        addrList.add(new Address__c(Account__c=acc.Id, Address_Type__c='Master of High Court',Client_Entity_Type__c='Individual',Shipping_Country__c='South Africa', Shipping_State_Province__c='Gauteng',Shipping_Street__c='Street 37',Shipping_Suburb__c='Maboneng',Shipping_Zip_Postal_Code__c='1619',Shipping_City__c='City'));
        addrList.add(new Address__c(Account__c=acc.Id, Address_Type__c='Head Office',Client_Entity_Type__c='Individual',Shipping_Country__c='South Africa', Shipping_State_Province__c='Gauteng',Shipping_Street__c='Street 37',Shipping_Suburb__c='Maboneng',Shipping_Zip_Postal_Code__c='1619',Shipping_City__c='City'));
        addrList.add(new Address__c(Account__c=acc.Id, Address_Type__c='Registered',Client_Entity_Type__c='Individual',Shipping_Country__c='South Africa', Shipping_State_Province__c='Gauteng',Shipping_Street__c='Street 37',Shipping_Suburb__c='Maboneng',Shipping_Zip_Postal_Code__c='1619',Shipping_City__c='City'));
        addrList.add(new Address__c(Account__c=acc.Id, Address_Type__c='Employers',Client_Entity_Type__c='Individual',Shipping_Country__c='South Africa', Shipping_State_Province__c='Gauteng',Shipping_Street__c='Street 37',Shipping_Suburb__c='Maboneng',Shipping_Zip_Postal_Code__c='1619',Shipping_City__c='City'));
        addrList.add(new Address__c(Account__c=acc.Id, Address_Type__c='Residential',Client_Entity_Type__c='Individual',Shipping_Country__c='South Africa', Shipping_State_Province__c='Gauteng',Shipping_Street__c='Street 37',Shipping_Suburb__c='Maboneng',Shipping_Zip_Postal_Code__c='1619',Shipping_City__c='City'));
        insert addrList;

        Map<String, Schema.RecordTypeInfo> opportunityRecordTypeMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        User userRec = new UsersSelector().selectById(UserInfo.getUserId());
        List<Site__c> sitecodes;
        if (userRec.SiteCode__c != null){
            sitecodes = new SitesSelector().selectBySiteCode(userRec.SiteCode__c);
        } else{
            sitecodes = new List<Site__c>();
        }

                    //Get Standard Pricebook Id
        PriceBook2 priceBookItem  = new Pricebook2(Name = 'Standard Price Book 2009', Description = 'Price Book 2009 Products', IsActive = true);
        insert priceBookItem;

        Opportunity cpfOpp = new Opportunity();
        cpfOpp.Name = 'CPF Onboarding';
        cpfOpp.RecordTypeId = opportunityRecordTypeMap.get('CPF_Onboarding').getRecordTypeId();
        cpfOpp.AccountId = acc.id;
        cpfOpp.StageName = 'Confirm Client Eligibility';
        cpfOpp.closeDate = todaysDate.addDays(7);
        cpfOpp.priceBook2Id = priceBookItem.id;

        //Capturing Sitecode of loggedin User while creating opportunity if user has site code
        if (!sitecodes.isEmpty()){
            cpfOpp.Site__c = sitecodes[0].Id;
        }

        // Added by Masechaba Maseli W-005224 get the ABSA region
        If (userRec.SiteCode__c != Null){
            Map<String, ABSASiteRegionMap__c> regionMapping = ABSASiteRegionMap__c.getAll();
            cpfOpp.ABSA_Region__c = regionMapping.get(userRec.SiteCode__c) != null ? regionMapping.get(userRec.SiteCode__c).ABSA_Region__c : Null;
        }

        insert cpfOpp;

        /**Application__c App = new Application__c();
        App.Opportunity__c = cpfOpp.Id;
        App.Preferred_Communication_Method__c='himanshu.nimje@absa.africa';
        App.Preferred_SMS__c='065892600';
        App.Preferred_Communication_Method__c='Email';
        App.Fees_Waived__c = true;
        App.Products_And_Services__c = 'NotifyMe';
        insert App;**/
        Application__c cpfApp = new Application__c();
        cpfApp.Opportunity__c = cpfOpp.Id;
        cpfApp.Preferred_Communication_Method__c='himanshu.nimje@absa.africa';
        cpfApp.Preferred_SMS__c='065892600';
        cpfApp.Preferred_Communication_Method__c='Email';
        cpfApp.Fees_Waived__c = true;
        cpfApp.Application_Status__c = 'Pending'; // Tinashe W-004373
        cpfApp.Products_And_Services__c = 'NotifyMe';
        insert cpfApp;

        Application_Product__c appPrdct=new Application_Product__c();
        appPrdct.Application__c=cpfApp.Id;
        appPrdct.Opportunity__c = cpfOpp.Id;
        appPrdct.Agreement_Category__c='M';
        appPrdct.Opportunity_Product_Id__c = '001';
        appPrdct.Product_Facility_Json__c = '{"Unutilisedfacilityfee":0,"totalamount":1000,"targetamount":1200,"Surname":"NA","specialConditionsSelected":"Subordination Agreement in terms of which all claims by your shareholder(s)/director(s) [INSERT NAME OF SHAREHOLDER OR DIRECTOR(S)] are subordinated in favour of any claims by us.,Negative Pledge: You shall not create or agree to create or permit to subsist (other than in our favour) any Security over assets that have been secured to us.","siteCode":"6953","ReviewType":null,"Reviewfees":1290,"ReviewDate":"2021-03-23","RegularpaymentDate":null,"RegistrationNumber":"1998/016806/23","quoteDate":"2021-03-15","productName":"Cheque","Primeinterestrate":6.00,"penaltyinterest":null,"otherConditions":"Other Conditions","ODLimitType":"Reducing - Once Off Only","Monthlyadministrationfee":69.00,"isGeneralFacilitySelected":"Yes","InterestrateType":"Variable","Interestrate":12.00,"interestMargin":2.15,"instructionId":null,"Initiationfees":0.00,"fullname":"CPS SEEDLINGS CC","facilityTypeSelected":"Overdraft Facility, Local Guarantees Facility, Foreign Guarantees Facility, Revolving Loan Facility, Overnight Facility, Letters of Credit Facility (sight or usance), Business Credit Card Facility, Offshore Loans, Fleet Card Facility, Daylight Limit, ACB Facility, Forward Exchange Contracts Facility, Customer Foreign Currency Account","facilityreduced":"Monthly","facilityAmount":100000.00,"facilitiesSelected":"This Agreement signed by both parties., A copy of your board resolution and constitutional documents., A signed copy of the electronic communication indemnity., In a form acceptable to us, the Security., Certified copies of any resolutions required in terms of applicable laws to make the Security effective., Any information or documentation as required by us, including any Financial Intelligence Centre Act, 2001 (FICA) information.","decreasemap":[{"DecreaseDate1":"2021-06-30","DecreaseAmount1":10000.00}],"creditLimitAvail":100000.00,"creditApplicationReference":"None","classificationSelected":"None","AnnualInterestRate":13,"Addresseetitle":"Dear Sir(s) / Madam(s)","AddresseeOther":"Drs","Addressee":"The Partner(s)","accountNumber":"4048457031"}';
        appPrdct.Product_Quote_Json__c = '{"QuoteNumber":"123456", "Initiationfees":1234, "IntetrestAggre": 10, "ServicefeeAggre": 12, "CreditInsurAggre": 120 ,"creditcostmultiple": 32, "creditInsurMonth": 251.23, "ODLedgerFee": 1200, "ExODLedgerFee": 500, "AnnualInterestRate": 12.5 , "AnnualInterestRateDiscount": 2.12,"discountedIntersetRate": 5.43, "UpfrontInitiationfees": 900, "monthlyinstalment": 457.90, "totalinterest": 27.5, "totalinterestandfees": 1221, "totaltoberepaid": 12000, "additionalCharges": "123", "creditinsurancemonthly":124.3, "Commision": "120", "creditLimit": 20000, "creditLimitAvail": 20000}';
        insert appPrdct;

        Application_Product_CPF__c appPrdctcpf=new Application_Product_CPF__c();
        appPrdctcpf.Application__c=cpfApp.Id;
        appPrdctcpf.Name='Test CPF Docs';
        appPrdctcpf.Parent_to_provide_the_bank_with_financia__c='Yes';
        appPrdctcpf.Guarantor_s_has_have_subsidiaries__c='yes';
        appPrdctcpf.Guarantor_s_to_provide_the_bank_with_fi__c='yes';
        appPrdctcpf.Borrower_has_subsidiaries__c='yes';
        appPrdctcpf.Available__c=1;
        appPrdctcpf.Period__c='monthly';
        appPrdctcpf.Financial_statements_available_no_later__c='test';
        appPrdctcpf.Include_balance_sheet_profit_loss_acc__c='yes';
        appPrdctcpf.Other_financial_information__c='test';
        appPrdctCpf.Facility_purpose__c = 'PURPOSE AS APPROVED BY CREDIT';
        appPrdctCpf.Late_bond_registration_penalty__c = 'Yes';
        appPrdctCpf.Include_guarantor_s__c = 'Yes';
        appPrdctCpf.Including_financial_statements_of_guaran__c = 'Yes';
        appPrdctCpf.Measurement_period__c = 'each consecutive period';
        appPrdctCpf.Loan_To_Value_Covenant__c = 'Ratcheting';
        appPrdctCpf.Debt_service_cover_ratio__c = 'Ratcheting';
        appPrdctCpf.Final_repayment_date__c = 'Date';
        appPrdctCpf.Notarially_Tied_Consolidation__c = 'Notarially Tied';
        appPrdctCpf.Secondary_Account_Applicable__c = 'YES';
        insert appPrdctcpf;

        List<Document_Template__c> docTempList = new List<Document_Template__c>();
        Document_Template__c test6171DocumentTemplate = new Document_Template__c();
        test6171DocumentTemplate.Name = 'ABSA 6171 EX - Commercial Property Finance Loan';
        test6171DocumentTemplate.XML__c = '<Schema>  <ABSA3121_SiteVerificationDetails>    <SiteVerificationDetails></SiteVerificationDetails>    <Id>4074</Id>  </ABSA3121_SiteVerificationDetails>  {{#AccountList}}  <ABSA3121_AccountNumbers>    <AccountNumber>{{AccountNumber}}</AccountNumber>    <ParentId>3039</ParentId>    <Id>781</Id>  </ABSA3121_AccountNumbers> {{/AccountList}}  <AISxMetaData>    <IsCPA>0</IsCPA>    <IsNCA>false</IsNCA>    <Language>E</Language>    <IsDigitalSignature>false</IsDigitalSignature>  </AISxMetaData>  <ABSA3121>    <FormalInformalSettlement>{{Application.Settlement_type__c}}</FormalInformalSettlement>    <SiteVisitDate>{{Application.Site_visit_date__c | format_date}}</SiteVisitDate>    <SiteVisitCPFullName>{{Application.First_Name__c}}{{Application.Surname__c}}</SiteVisitCPFullName>    <CSARefNo>{{Application.Application_Number__c}}</CSARefNo>    <AccountNumber>{{Account.AccountNumber}}</AccountNumber>    <ClientCIF>{{Account.CIF__c}}</ClientCIF>    <InitiatorAbNo>{{User.AB_Number__c}}</InitiatorAbNo>    <SurnameOrEntityName>{{Account.Trading_Name__c}}{{Account.LastName}}</SurnameOrEntityName>    <TradingSurnameOrEntityName>{{Account.Trading_Name__c}}{{Account.LastName}}</TradingSurnameOrEntityName>    <InitiatorName>{{User.Name}}</InitiatorName>    <InitiatorSurname>{{User.LastName}}</InitiatorSurname>   <IdNo>{{Account.ID_Number__c}}</IdNo>    <IdType>{{Account.ID_Type__c}}</IdType>    <Id>1642</Id>    <PhysicalAddressCity>{{TradingAddress.Shipping_City__c}}</PhysicalAddressCity>    <PhysicalAddressCode>{{TradingAddress.Shipping_Zip_Postal_Code__c}}</PhysicalAddressCode>    <PhysicalAddressSuburb>{{TradingAddress.Shipping_Suburb__c}}</PhysicalAddressSuburb>    <PhysicalAddressLine2>{{TradingAddress.Shipping_State_Province__c}}</PhysicalAddressLine2>    <PhysicalAddressLine1>{{TradingAddress.Shipping_Street__c}}</PhysicalAddressLine1>    <SiteVerificationDetails></SiteVerificationDetails>	<!-- where do we capture than an address was verified-->    <VerifiedAddressInfo></VerifiedAddressInfo>    <PhysicalAddressCountry>{{TradingAddress.Shipping_Country__c}}</PhysicalAddressCountry>    <PhysicalAddressType>{{TradingAddress.Address_Type__c}}</PhysicalAddressType>    <InitiatorTitle>{{User.Title}}</InitiatorTitle>    <Title></Title>    <FullName>{{Account.Name}}</FullName>    <SiteVisitCPTitle>{{Application.Title__c}}</SiteVisitCPTitle>    <SiteVisitCPSurnameOrEntityName>{{Account.Trading_Name__c}}{{Account.LastName}}</SiteVisitCPSurnameOrEntityName>    <TradingFullName>{{Application.First_Name__c}}{{Application.Surname__c}}</TradingFullName>    <TradingTitle></TradingTitle>  </ABSA3121>  <LSOIAddress>  <!-- Not sure what row we talking of here-->    <Row></Row>  </LSOIAddress></Schema>';
        test6171DocumentTemplate.Document_Type__c = 'ABSA 6171 EX - Commercial Property Finance Loan';
        test6171DocumentTemplate.Signature_Required__c = True;
        test6171DocumentTemplate.ECM_Account_Number_Metadata__c=true;
        test6171DocumentTemplate.ECM_Business_Unit_Metadata__c=true;
        test6171DocumentTemplate.ECM_CIF_Code_Metadata__c=true;
        test6171DocumentTemplate.ECM_Filing_Date_Metadata__c=true;
        test6171DocumentTemplate.ECM_ID_Number_Metadata__c=true;
        test6171DocumentTemplate.ECM_Item_Type__c = 'Ent_AccountApplication';
        test6171DocumentTemplate.ECM_Origin_Metadata__c = true;
        test6171DocumentTemplate.Template_Id__c = '244';
        test6171DocumentTemplate.Parent_Document_Type__c = 'Business Client Agreement';
        docTempList.add(test6171DocumentTemplate);

        Document_Template__c test6173DocumentTemplate = new Document_Template__c();
        test6173DocumentTemplate.Name = 'ABSA 6173 Suretyship/Credit Guarantee';
        test6173DocumentTemplate.XML__c = '<Schema>  <ABSA3121_SiteVerificationDetails>    <SiteVerificationDetails></SiteVerificationDetails>    <Id>4074</Id>  </ABSA3121_SiteVerificationDetails>  {{#AccountList}}  <ABSA3121_AccountNumbers>    <AccountNumber>{{AccountNumber}}</AccountNumber>    <ParentId>3039</ParentId>    <Id>781</Id>  </ABSA3121_AccountNumbers> {{/AccountList}}  <AISxMetaData>    <IsCPA>0</IsCPA>    <IsNCA>false</IsNCA>    <Language>E</Language>    <IsDigitalSignature>false</IsDigitalSignature>  </AISxMetaData>  <ABSA3121>    <FormalInformalSettlement>{{Application.Settlement_type__c}}</FormalInformalSettlement>    <SiteVisitDate>{{Application.Site_visit_date__c | format_date}}</SiteVisitDate>    <SiteVisitCPFullName>{{Application.First_Name__c}}{{Application.Surname__c}}</SiteVisitCPFullName>    <CSARefNo>{{Application.Application_Number__c}}</CSARefNo>    <AccountNumber>{{Account.AccountNumber}}</AccountNumber>    <ClientCIF>{{Account.CIF__c}}</ClientCIF>    <InitiatorAbNo>{{User.AB_Number__c}}</InitiatorAbNo>    <SurnameOrEntityName>{{Account.Trading_Name__c}}{{Account.LastName}}</SurnameOrEntityName>    <TradingSurnameOrEntityName>{{Account.Trading_Name__c}}{{Account.LastName}}</TradingSurnameOrEntityName>    <InitiatorName>{{User.Name}}</InitiatorName>    <InitiatorSurname>{{User.LastName}}</InitiatorSurname>   <IdNo>{{Account.ID_Number__c}}</IdNo>    <IdType>{{Account.ID_Type__c}}</IdType>    <Id>1642</Id>    <PhysicalAddressCity>{{TradingAddress.Shipping_City__c}}</PhysicalAddressCity>    <PhysicalAddressCode>{{TradingAddress.Shipping_Zip_Postal_Code__c}}</PhysicalAddressCode>    <PhysicalAddressSuburb>{{TradingAddress.Shipping_Suburb__c}}</PhysicalAddressSuburb>    <PhysicalAddressLine2>{{TradingAddress.Shipping_State_Province__c}}</PhysicalAddressLine2>    <PhysicalAddressLine1>{{TradingAddress.Shipping_Street__c}}</PhysicalAddressLine1>    <SiteVerificationDetails></SiteVerificationDetails>	<!-- where do we capture than an address was verified-->    <VerifiedAddressInfo></VerifiedAddressInfo>    <PhysicalAddressCountry>{{TradingAddress.Shipping_Country__c}}</PhysicalAddressCountry>    <PhysicalAddressType>{{TradingAddress.Address_Type__c}}</PhysicalAddressType>    <InitiatorTitle>{{User.Title}}</InitiatorTitle>    <Title></Title>    <FullName>{{Account.Name}}</FullName>    <SiteVisitCPTitle>{{Application.Title__c}}</SiteVisitCPTitle>    <SiteVisitCPSurnameOrEntityName>{{Account.Trading_Name__c}}{{Account.LastName}}</SiteVisitCPSurnameOrEntityName>    <TradingFullName>{{Application.First_Name__c}}{{Application.Surname__c}}</TradingFullName>    <TradingTitle></TradingTitle>  </ABSA3121>  <LSOIAddress>  <!-- Not sure what row we talking of here-->    <Row></Row>  </LSOIAddress></Schema>';
        test6173DocumentTemplate.Document_Type__c = 'ABSA 6173 Suretyship/Credit Guarantee';
        test6173DocumentTemplate.Signature_Required__c = True;
        test6173DocumentTemplate.ECM_Account_Number_Metadata__c=true;
        test6173DocumentTemplate.ECM_Business_Unit_Metadata__c=true;
        test6173DocumentTemplate.ECM_CIF_Code_Metadata__c=true;
        test6173DocumentTemplate.ECM_Filing_Date_Metadata__c=true;
        test6173DocumentTemplate.ECM_ID_Number_Metadata__c=true;
        test6173DocumentTemplate.ECM_Item_Type__c = 'Ent_Suretyship';
        test6173DocumentTemplate.ECM_Origin_Metadata__c = true;
        test6173DocumentTemplate.Template_Id__c = '200';
        test6173DocumentTemplate.Parent_Document_Type__c = 'Business Client Agreement';
        docTempList.add(test6173DocumentTemplate);

        Document_Template__c absa6157 = new Document_Template__c();
        absa6157.Name = 'ABSA 6157 EX - OD Facility Letter';
        absa6157.XML__c = '<Schema>  <ABSA3121_SiteVerificationDetails>    <SiteVerificationDetails></SiteVerificationDetails>    <Id>4074</Id>  </ABSA3121_SiteVerificationDetails>  {{#AccountList}}  <ABSA3121_AccountNumbers>    <AccountNumber>{{AccountNumber}}</AccountNumber>    <ParentId>3039</ParentId>    <Id>781</Id>  </ABSA3121_AccountNumbers> {{/AccountList}}  <AISxMetaData>    <IsCPA>0</IsCPA>    <IsNCA>false</IsNCA>    <Language>E</Language>    <IsDigitalSignature>false</IsDigitalSignature>  </AISxMetaData>  <ABSA3121>    <FormalInformalSettlement>{{Application.Settlement_type__c}}</FormalInformalSettlement>    <SiteVisitDate>{{Application.Site_visit_date__c | format_date}}</SiteVisitDate>    <SiteVisitCPFullName>{{Application.First_Name__c}}{{Application.Surname__c}}</SiteVisitCPFullName>    <CSARefNo>{{Application.Application_Number__c}}</CSARefNo>    <AccountNumber>{{Account.AccountNumber}}</AccountNumber>    <ClientCIF>{{Account.CIF__c}}</ClientCIF>    <InitiatorAbNo>{{User.AB_Number__c}}</InitiatorAbNo>    <SurnameOrEntityName>{{Account.Trading_Name__c}}{{Account.LastName}}</SurnameOrEntityName>    <TradingSurnameOrEntityName>{{Account.Trading_Name__c}}{{Account.LastName}}</TradingSurnameOrEntityName>    <InitiatorName>{{User.Name}}</InitiatorName>    <InitiatorSurname>{{User.LastName}}</InitiatorSurname>   <IdNo>{{Account.ID_Number__c}}</IdNo>    <IdType>{{Account.ID_Type__c}}</IdType>    <Id>1642</Id>    <PhysicalAddressCity>{{TradingAddress.Shipping_City__c}}</PhysicalAddressCity>    <PhysicalAddressCode>{{TradingAddress.Shipping_Zip_Postal_Code__c}}</PhysicalAddressCode>    <PhysicalAddressSuburb>{{TradingAddress.Shipping_Suburb__c}}</PhysicalAddressSuburb>    <PhysicalAddressLine2>{{TradingAddress.Shipping_State_Province__c}}</PhysicalAddressLine2>    <PhysicalAddressLine1>{{TradingAddress.Shipping_Street__c}}</PhysicalAddressLine1>    <SiteVerificationDetails></SiteVerificationDetails>	<!-- where do we capture than an address was verified-->    <VerifiedAddressInfo></VerifiedAddressInfo>    <PhysicalAddressCountry>{{TradingAddress.Shipping_Country__c}}</PhysicalAddressCountry>    <PhysicalAddressType>{{TradingAddress.Address_Type__c}}</PhysicalAddressType>    <InitiatorTitle>{{User.Title}}</InitiatorTitle>    <Title></Title>    <FullName>{{Account.Name}}</FullName>    <SiteVisitCPTitle>{{Application.Title__c}}</SiteVisitCPTitle>    <SiteVisitCPSurnameOrEntityName>{{Account.Trading_Name__c}}{{Account.LastName}}</SiteVisitCPSurnameOrEntityName>    <TradingFullName>{{Application.First_Name__c}}{{Application.Surname__c}}</TradingFullName>    <TradingTitle></TradingTitle>  </ABSA3121>  <LSOIAddress>  <!-- Not sure what row we talking of here-->    <Row></Row>  </LSOIAddress></Schema>';
        absa6157.Document_Type__c = 'ABSA 6157 EX - OD Facility Letter';
        absa6157.Signature_Required__c = True;
        absa6157.ECM_Account_Number_Metadata__c=true;
        absa6157.ECM_Business_Unit_Metadata__c=true;
        absa6157.ECM_CIF_Code_Metadata__c=true;
        absa6157.ECM_Filing_Date_Metadata__c=true;
        absa6157.ECM_ID_Number_Metadata__c=true;
        absa6157.ECM_Item_Type__c = 'Ent_Agreement';
        absa6157.ECM_Origin_Metadata__c = true;
        absa6157.Parent_Document_Type__c = 'Agreements';
        absa6157.Template_Id__c = '105';
        docTempList.add(absa6157);

        Document_Template__c absa5701 = new Document_Template__c();
        absa5701.Name = 'ABSA 5701 - Overdraft Quotation and Agreement (Intermediate and Large)';
        absa5701.XML__c = '<Schema>  <ABSA3121_SiteVerificationDetails>    <SiteVerificationDetails></SiteVerificationDetails>    <Id>4074</Id>  </ABSA3121_SiteVerificationDetails>  {{#AccountList}}  <ABSA3121_AccountNumbers>    <AccountNumber>{{AccountNumber}}</AccountNumber>    <ParentId>3039</ParentId>    <Id>781</Id>  </ABSA3121_AccountNumbers> {{/AccountList}}  <AISxMetaData>    <IsCPA>0</IsCPA>    <IsNCA>false</IsNCA>    <Language>E</Language>    <IsDigitalSignature>false</IsDigitalSignature>  </AISxMetaData>  <ABSA3121>    <FormalInformalSettlement>{{Application.Settlement_type__c}}</FormalInformalSettlement>    <SiteVisitDate>{{Application.Site_visit_date__c | format_date}}</SiteVisitDate>    <SiteVisitCPFullName>{{Application.First_Name__c}}{{Application.Surname__c}}</SiteVisitCPFullName>    <CSARefNo>{{Application.Application_Number__c}}</CSARefNo>    <AccountNumber>{{Account.AccountNumber}}</AccountNumber>    <ClientCIF>{{Account.CIF__c}}</ClientCIF>    <InitiatorAbNo>{{User.AB_Number__c}}</InitiatorAbNo>    <SurnameOrEntityName>{{Account.Trading_Name__c}}{{Account.LastName}}</SurnameOrEntityName>    <TradingSurnameOrEntityName>{{Account.Trading_Name__c}}{{Account.LastName}}</TradingSurnameOrEntityName>    <InitiatorName>{{User.Name}}</InitiatorName>    <InitiatorSurname>{{User.LastName}}</InitiatorSurname>   <IdNo>{{Account.ID_Number__c}}</IdNo>    <IdType>{{Account.ID_Type__c}}</IdType>    <Id>1642</Id>    <PhysicalAddressCity>{{TradingAddress.Shipping_City__c}}</PhysicalAddressCity>    <PhysicalAddressCode>{{TradingAddress.Shipping_Zip_Postal_Code__c}}</PhysicalAddressCode>    <PhysicalAddressSuburb>{{TradingAddress.Shipping_Suburb__c}}</PhysicalAddressSuburb>    <PhysicalAddressLine2>{{TradingAddress.Shipping_State_Province__c}}</PhysicalAddressLine2>    <PhysicalAddressLine1>{{TradingAddress.Shipping_Street__c}}</PhysicalAddressLine1>    <SiteVerificationDetails></SiteVerificationDetails>	<!-- where do we capture than an address was verified-->    <VerifiedAddressInfo></VerifiedAddressInfo>    <PhysicalAddressCountry>{{TradingAddress.Shipping_Country__c}}</PhysicalAddressCountry>    <PhysicalAddressType>{{TradingAddress.Address_Type__c}}</PhysicalAddressType>    <InitiatorTitle>{{User.Title}}</InitiatorTitle>    <Title></Title>    <FullName>{{Account.Name}}</FullName>    <SiteVisitCPTitle>{{Application.Title__c}}</SiteVisitCPTitle>    <SiteVisitCPSurnameOrEntityName>{{Account.Trading_Name__c}}{{Account.LastName}}</SiteVisitCPSurnameOrEntityName>    <TradingFullName>{{Application.First_Name__c}}{{Application.Surname__c}}</TradingFullName>    <TradingTitle></TradingTitle>  </ABSA3121>  <LSOIAddress>  <!-- Not sure what row we talking of here-->    <Row></Row>  </LSOIAddress></Schema>';
        absa5701.Document_Type__c = 'ABSA 5701 - Overdraft Quotation and Agreement (Intermediate and Large)';
        absa5701.Signature_Required__c = True;
        absa5701.ECM_Account_Number_Metadata__c=true;
        absa5701.ECM_Business_Unit_Metadata__c=true;
        absa5701.ECM_CIF_Code_Metadata__c=true;
        absa5701.ECM_Filing_Date_Metadata__c=true;
        absa5701.ECM_ID_Number_Metadata__c=true;
        absa5701.ECM_Item_Type__c = 'Ent_Agreement';
        absa5701.ECM_Origin_Metadata__c = true;
        absa5701.Parent_Document_Type__c = 'Agreements';
        absa5701.Template_Id__c = '98';
        docTempList.add(absa5701);

        Document_Template__c absa5702 = new Document_Template__c();
        absa5702.Name = 'ABSA 5702 - Overdraft Quotation and Agreement (Small)';
        absa5702.XML__c = '<Schema>  <ABSA3121_SiteVerificationDetails>    <SiteVerificationDetails></SiteVerificationDetails>    <Id>4074</Id>  </ABSA3121_SiteVerificationDetails>  {{#AccountList}}  <ABSA3121_AccountNumbers>    <AccountNumber>{{AccountNumber}}</AccountNumber>    <ParentId>3039</ParentId>    <Id>781</Id>  </ABSA3121_AccountNumbers> {{/AccountList}}  <AISxMetaData>    <IsCPA>0</IsCPA>    <IsNCA>false</IsNCA>    <Language>E</Language>    <IsDigitalSignature>false</IsDigitalSignature>  </AISxMetaData>  <ABSA3121>    <FormalInformalSettlement>{{Application.Settlement_type__c}}</FormalInformalSettlement>    <SiteVisitDate>{{Application.Site_visit_date__c | format_date}}</SiteVisitDate>    <SiteVisitCPFullName>{{Application.First_Name__c}}{{Application.Surname__c}}</SiteVisitCPFullName>    <CSARefNo>{{Application.Application_Number__c}}</CSARefNo>    <AccountNumber>{{Account.AccountNumber}}</AccountNumber>    <ClientCIF>{{Account.CIF__c}}</ClientCIF>    <InitiatorAbNo>{{User.AB_Number__c}}</InitiatorAbNo>    <SurnameOrEntityName>{{Account.Trading_Name__c}}{{Account.LastName}}</SurnameOrEntityName>    <TradingSurnameOrEntityName>{{Account.Trading_Name__c}}{{Account.LastName}}</TradingSurnameOrEntityName>    <InitiatorName>{{User.Name}}</InitiatorName>    <InitiatorSurname>{{User.LastName}}</InitiatorSurname>   <IdNo>{{Account.ID_Number__c}}</IdNo>    <IdType>{{Account.ID_Type__c}}</IdType>    <Id>1642</Id>    <PhysicalAddressCity>{{TradingAddress.Shipping_City__c}}</PhysicalAddressCity>    <PhysicalAddressCode>{{TradingAddress.Shipping_Zip_Postal_Code__c}}</PhysicalAddressCode>    <PhysicalAddressSuburb>{{TradingAddress.Shipping_Suburb__c}}</PhysicalAddressSuburb>    <PhysicalAddressLine2>{{TradingAddress.Shipping_State_Province__c}}</PhysicalAddressLine2>    <PhysicalAddressLine1>{{TradingAddress.Shipping_Street__c}}</PhysicalAddressLine1>    <SiteVerificationDetails></SiteVerificationDetails>	<!-- where do we capture than an address was verified-->    <VerifiedAddressInfo></VerifiedAddressInfo>    <PhysicalAddressCountry>{{TradingAddress.Shipping_Country__c}}</PhysicalAddressCountry>    <PhysicalAddressType>{{TradingAddress.Address_Type__c}}</PhysicalAddressType>    <InitiatorTitle>{{User.Title}}</InitiatorTitle>    <Title></Title>    <FullName>{{Account.Name}}</FullName>    <SiteVisitCPTitle>{{Application.Title__c}}</SiteVisitCPTitle>    <SiteVisitCPSurnameOrEntityName>{{Account.Trading_Name__c}}{{Account.LastName}}</SiteVisitCPSurnameOrEntityName>    <TradingFullName>{{Application.First_Name__c}}{{Application.Surname__c}}</TradingFullName>    <TradingTitle></TradingTitle>  </ABSA3121>  <LSOIAddress>  <!-- Not sure what row we talking of here-->    <Row></Row>  </LSOIAddress></Schema>';
        absa5702.Document_Type__c = 'ABSA 5702 - Overdraft Quotation and Agreement (Small)';
        absa5702.Signature_Required__c = True;
        absa5702.ECM_Account_Number_Metadata__c=true;
        absa5702.ECM_Business_Unit_Metadata__c=true;
        absa5702.ECM_CIF_Code_Metadata__c=true;
        absa5702.ECM_Filing_Date_Metadata__c=true;
        absa5702.ECM_ID_Number_Metadata__c=true;
        absa5702.ECM_Item_Type__c = 'Ent_Agreement';
        absa5702.ECM_Origin_Metadata__c = true;
        absa5702.Parent_Document_Type__c = 'Agreements';
        absa5702.Template_Id__c = '318';

        Document_Template__c absa5122 = new Document_Template__c();
        absa5702.Name = 'Absa 5122 EX - Merchant Application Form';
        absa5702.XML__c = '<Schema>  <ABSA3121_SiteVerificationDetails>    <SiteVerificationDetails></SiteVerificationDetails>    <Id>4074</Id>  </ABSA3121_SiteVerificationDetails>  {{#AccountList}}  <ABSA3121_AccountNumbers>    <AccountNumber>{{AccountNumber}}</AccountNumber>    <ParentId>3039</ParentId>    <Id>781</Id>  </ABSA3121_AccountNumbers> {{/AccountList}}  <AISxMetaData>    <IsCPA>0</IsCPA>    <IsNCA>false</IsNCA>    <Language>E</Language>    <IsDigitalSignature>false</IsDigitalSignature>  </AISxMetaData>  <ABSA3121>    <FormalInformalSettlement>{{Application.Settlement_type__c}}</FormalInformalSettlement>    <SiteVisitDate>{{Application.Site_visit_date__c | format_date}}</SiteVisitDate>    <SiteVisitCPFullName>{{Application.First_Name__c}}{{Application.Surname__c}}</SiteVisitCPFullName>    <CSARefNo>{{Application.Application_Number__c}}</CSARefNo>    <AccountNumber>{{Account.AccountNumber}}</AccountNumber>    <ClientCIF>{{Account.CIF__c}}</ClientCIF>    <InitiatorAbNo>{{User.AB_Number__c}}</InitiatorAbNo>    <SurnameOrEntityName>{{Account.Trading_Name__c}}{{Account.LastName}}</SurnameOrEntityName>    <TradingSurnameOrEntityName>{{Account.Trading_Name__c}}{{Account.LastName}}</TradingSurnameOrEntityName>    <InitiatorName>{{User.Name}}</InitiatorName>    <InitiatorSurname>{{User.LastName}}</InitiatorSurname>   <IdNo>{{Account.ID_Number__c}}</IdNo>    <IdType>{{Account.ID_Type__c}}</IdType>    <Id>1642</Id>    <PhysicalAddressCity>{{TradingAddress.Shipping_City__c}}</PhysicalAddressCity>    <PhysicalAddressCode>{{TradingAddress.Shipping_Zip_Postal_Code__c}}</PhysicalAddressCode>    <PhysicalAddressSuburb>{{TradingAddress.Shipping_Suburb__c}}</PhysicalAddressSuburb>    <PhysicalAddressLine2>{{TradingAddress.Shipping_State_Province__c}}</PhysicalAddressLine2>    <PhysicalAddressLine1>{{TradingAddress.Shipping_Street__c}}</PhysicalAddressLine1>    <SiteVerificationDetails></SiteVerificationDetails>	<!-- where do we capture than an address was verified-->    <VerifiedAddressInfo></VerifiedAddressInfo>    <PhysicalAddressCountry>{{TradingAddress.Shipping_Country__c}}</PhysicalAddressCountry>    <PhysicalAddressType>{{TradingAddress.Address_Type__c}}</PhysicalAddressType>    <InitiatorTitle>{{User.Title}}</InitiatorTitle>    <Title></Title>    <FullName>{{Account.Name}}</FullName>    <SiteVisitCPTitle>{{Application.Title__c}}</SiteVisitCPTitle>    <SiteVisitCPSurnameOrEntityName>{{Account.Trading_Name__c}}{{Account.LastName}}</SiteVisitCPSurnameOrEntityName>    <TradingFullName>{{Application.First_Name__c}}{{Application.Surname__c}}</TradingFullName>    <TradingTitle></TradingTitle>  </ABSA3121>  <LSOIAddress>  <!-- Not sure what row we talking of here-->    <Row></Row>  </LSOIAddress></Schema>';
        absa5702.Document_Type__c = 'Absa 5122 EX - Merchant Application Form';
        absa5702.Signature_Required__c = True;
        absa5702.ECM_Account_Number_Metadata__c=true;
        absa5702.ECM_Business_Unit_Metadata__c=true;
        absa5702.ECM_CIF_Code_Metadata__c=true;
        absa5702.ECM_Filing_Date_Metadata__c=true;
        absa5702.ECM_ID_Number_Metadata__c=true;
        absa5702.ECM_Item_Type__c = 'Ent_AccountApplication';
        absa5702.ECM_Origin_Metadata__c = true;
        absa5702.Parent_Document_Type__c = 'Agreements';
        absa5702.Template_Id__c = '140';
        docTempList.add(absa5702);

        insert docTempList;

        LIST<Application_Security_CPF__c> securities = new LIST<Application_Security_CPF__c>();
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='New', Category__c='Limited Guarantee', To_be_released__c='Yes', Include_address__c='Yes'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='Existing', Category__c='Limited Guarantee', To_be_released__c='Yes', Include_address__c='Yes'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='Existing', Category__c='UnLimited Suretyship', To_be_released__c='Yes', Include_address__c='Yes'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='Existing', Category__c='Limited Suretyship', To_be_released__c='Yes', Include_address__c='Yes'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='Existing', Category__c='Unlimited Guarantee', To_be_released__c='Yes', Include_address__c='Yes'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='New', Category__c='Unlimited Guarantee', To_be_released__c='Yes', Include_address__c='Yes'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='Existing', Category__c='Existing Mortgage Bond', To_be_released__c='Yes', Include_address__c='Yes',Mortgage_bond_type__c='Registration of mortgage bond by borrower'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='Existing', Category__c='New Mortgage Bond', To_be_released__c='Yes', Include_address__c='Yes'));

        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='Existing', Category__c='Other', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Undertaking to Inject Cost Overrun Funds'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='Existing', Category__c='Other', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Cross Guarantee'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='Existing', Category__c='Other', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Cross Default Clause'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='Existing', Category__c='Other', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Cross Collateralisation'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='Existing', Category__c='Other', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Subordination Agreement of Loan Accounts'));

        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='Existing', Category__c='Mortgage Bond', To_be_released__c='Yes', Include_address__c='Yes',Mortgage_bond_type__c='Registration of mortgage bond by borrower'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='New', Category__c='New Mortgage Bond', To_be_released__c='Yes', Include_address__c='Yes',Mortgage_bond_type__c='Registration of mortgage bond by borrower'));

        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='Existing', Category__c='Security Cession', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Multiple dates Borrower cession'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='Existing', Category__c='Security Cession', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Single date Borrower cession'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='Existing', Category__c='Security Cession', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Single date other cedent cession'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='Existing', Category__c='Security Cession', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Multiple dates other cedent cession'));

        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='Existing', Category__c='Security Cession Existing', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Multiple dates other cedent cession'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='Existing', Category__c='Security Cession Existing', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Single date other cedent cession'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='Existing', Category__c='Security Cession Existing', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Multiple dates Borrower cession'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='Existing', Category__c='Security Cession Existing', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Single date Borrower cession'));

        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='New', Category__c='Security Cession', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Other cedent cession'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='New', Category__c='Security Cession', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Borrower cession'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='New', Category__c='Security Cession', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Shareholders / members cessions'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='New', Category__c='Security Cession', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Pledges and cession'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='New', Category__c='Security Cession', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Other cession'));

        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='New', Category__c='Other', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Subordination Agreement of Loan Accounts',Claims_By__c='member(s) of the Borrower'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='New', Category__c='Other', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Subordination Agreement of Loan Accounts',Claims_By__c='member(s) of the Guarantor(s)'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='New', Category__c='Other', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Subordination Agreement of Loan Accounts'));

        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='New', Category__c='Other', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Undertaking to inject cost overrun funds'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='New', Category__c='Other', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Cross Guarantee'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='New', Category__c='Other', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Cross Default Clause'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='New', Category__c='Other', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Cross Collateralisation'));

        insert securities;
        Application_Financial_Account__c afa = new Application_Financial_Account__c(Application_Product_CPF__c=appPrdctcpf.id);
        insert afa;

        List<Application_Contract_Clause__c> covenants = new List<Application_Contract_Clause__c>();
        covenants.add(new Application_Contract_Clause__c(Application_Product_CPF__c=appPrdctcpf.id,Category__c='CPF Application',Type__c='Other Transactional Covenants'));
        covenants.add(new Application_Contract_Clause__c(Application_Product_CPF__c=appPrdctcpf.id,Category__c='CPF Application',Type__c='Loan and Value Covenants'));
        covenants.add(new Application_Contract_Clause__c(Application_Product_CPF__c=appPrdctcpf.id,Category__c='CPF Application',Type__c='Debit Service Cover Ratio'));
        covenants.add(new Application_Contract_Clause__c(Application_Product_CPF__c=appPrdctcpf.id,Category__c='CPF Application',Type__c='Other Entity'));
        covenants.add(new Application_Contract_Clause__c(Application_Product_CPF__c=appPrdctcpf.id,Category__c='CPF Application',Type__c='Further Condition Precedent'));
        covenants.add(new Application_Contract_Clause__c(Application_Product_CPF__c=appPrdctcpf.id,Category__c='CPF Application',Type__c='Special Condition'));
        covenants.add(new Application_Contract_Clause__c(Application_Product_CPF__c=appPrdctcpf.id,Category__c='CPF Application',Type__c='Lease'));
        insert covenants;

        LIST<Application_Lease_CPF__c> leases = new LIST<Application_Lease_CPF__c>();
        leases.add(new Application_Lease_CPF__c(Application_Product_CPF__c=appPrdctcpf.id,Other_Lease__c='Other Lease'));
        leases.add(new Application_Lease_CPF__c(Application_Product_CPF__c=appPrdctcpf.id));
        insert leases;

        Application_Repayment_Account_CPF__c ara = new Application_Repayment_Account_CPF__c(Application_Product_CPF__c=appPrdctcpf.id);
        insert ara;

        List<Security_Offered__c> securitiesOffered = new List<Security_Offered__c>();
        securitiesOffered.add(new Security_Offered__c(Account__c=acc.id, Application__c=cpfApp.id, Security_Type__c='Bonds and 99-year Leasehold', Bond_type__c = 'MBOND - MORTGAGE BOND'));
        securitiesOffered.add(new Security_Offered__c(Account__c=acc.id, Application__c=cpfApp.id, Security_Type__c='Bonds and 99-year Leasehold', Bond_type__c = 'GNBOND - GENERAL NOTARIAL BOND'));
        securitiesOffered.add(new Security_Offered__c(Account__c=acc.id, Contact__c=con.id, Application__c=cpfApp.id, Security_Type__c='Bonds and 99-year Leasehold', Bond_type__c = 'SNBOND - SPECIAL NOTARIAL BOND'));
        securitiesOffered.add(new Security_Offered__c(Account__c=acc.id, Client_Name__c='External', External_Entity_Linked__c=false, Application__c=cpfApp.id,Security_Type__c='Cession of Internal Investments'));
        securitiesOffered.add(new Security_Offered__c(Account__c=acc.id, Application__c=cpfApp.id, Security_Type__c='Cession of External Investments'));
        securitiesOffered.add(new Security_Offered__c(Account__c=acc.id, Application__c=cpfApp.id, Security_Type__c='Cession of Life Policy (Not Link)'));
        securitiesOffered.add(new Security_Offered__c(Account__c=acc.id, Application__c=cpfApp.id, Security_Type__c='Cession of Life Policy (Link) (Sanlam)'));
        securitiesOffered.add(new Security_Offered__c(Account__c=acc.id, Application__c=cpfApp.id, Security_Type__c='Suretyship', Security_Provider_Type__c='SECURITY BY / IN FAVOUR OF A SOLE PROPRIETOR'));
        securitiesOffered.add(new Security_Offered__c(Account__c=acc.id, Application__c=cpfApp.id, Security_Type__c='General Pledge'));
        securitiesOffered.add(new Security_Offered__c(Account__c=acc.id, Application__c=cpfApp.id, Security_Type__c='Cession of Debtors'));
        securitiesOffered.add(new Security_Offered__c(Account__c=acc.id, Application__c=cpfApp.id, Security_Type__c='Cession of Unit Trusts'));
        securitiesOffered.add(new Security_Offered__c(Account__c=acc.id, Application__c=cpfApp.id, Security_Type__c='Cession of Dematerialised Shares'));
        securitiesOffered.add(new Security_Offered__c(Account__c=acc.id, Application__c=cpfApp.id, Security_Type__c='Cession of Fire/Short Term Insurance'));
        securitiesOffered.add(new Security_Offered__c(Account__c=acc.id, Application__c=cpfApp.id, Security_Type__c='General Cession'));
        securitiesOffered.add(new Security_Offered__c(Account__c=acc.id, Application__c=cpfApp.id, Security_Type__c='Letter of Undertaking'));
        securitiesOffered.add(new Security_Offered__c(Account__c=acc.id, Application__c=cpfApp.id, Security_Type__c='Excon Ruling'));
        insert securitiesOffered;
    }

    /**
     * @description testgenerateCreditDocs description
     *
     */
    @IsTest
    public static void testgenerateCreditDocs() {
        Security_Offered__c secOff=[Select id, Security_Provider_Type__c from Security_Offered__c Where Security_Type__c='Suretyship' LIMIT 1];
        Id addId = [Select id from Address__c where Address_Type__c='Physical Address' LIMIT 1].Id;

        test.startTest();
        system.assertNotEquals(null, GenerateCreditDocuments.generateCreditDocs(secOff.Id, 'ABSA 6173 Suretyship/Credit Guarantee'),'cannot be null');
        test.stopTest();
    }

    @IsTest
    public static void testgenerateCreditDocs2() {
        Security_Offered__c secOff=[Select id, Security_Provider_Type__c from Security_Offered__c Where Security_Type__c='Suretyship' LIMIT 1];
        Id addId = [Select id from Address__c where Address_Type__c='Physical Address' LIMIT 1].Id;

        test.startTest();
        secOff.Address__c = addId;
        secOff.Security_Provider_Type__c = 'SECURITY BY A CLOSE CORPORATION BY VIRTUE OF A RESOLUTION';
        update secOff;
        system.assertNotEquals(null, GenerateCreditDocuments.generateCreditDocs(secOff.Id, 'ABSA 6173 Suretyship/Credit Guarantee'),'cannot be null');
        test.stopTest();
    }

    @IsTest
    public static void testgenerateCreditDocs3() {
        Security_Offered__c secOff=[Select id, Security_Provider_Type__c from Security_Offered__c Where Security_Type__c='Suretyship' LIMIT 1];
        Id addId = [Select id from Address__c where Address_Type__c='Physical Address' LIMIT 1].Id;

        test.startTest();
        secOff.Security_Provider_Type__c='SECURITY BY A TRUST AS A MEMBER OF THE CLOSE CORPORATION BY VIRTUE OF A RESOLUTION';
        update secOff;
        system.assertNotEquals(null, GenerateCreditDocuments.generateCreditDocs(secOff.Id, 'ABSA 6173 Suretyship/Credit Guarantee'),'cannot be null');
        test.stopTest();
    }

        /**
     * @description testGenerate6157 description
     *
     * @@ Return testMethodvoid: Return description
     */
    @IsTest
    public static void testGenerate6157() {
        Application_Product__c appPrdct=[Select id, Name, Final_repayment_date__c from Application_Product__c Where Agreement_Category__c='M'];

        test.startTest();
        Map<String, String> ss = GenerateCreditDocuments.generateFacilityLetter(appPrdct.Id, 'ABSA 6157 EX - OD Facility Letter');
        System.assertNotEquals(ss, null,'SOmething should be returned if it is an error');
        test.stopTest();
    }

    @IsTest
    public static void testGenerate61572() {
        Application_Product__c appPrdct=[Select id, Name, Final_repayment_date__c from Application_Product__c Where Agreement_Category__c='M'];

        test.startTest();
        System.assertNotEquals(null,GenerateCreditDocuments.generateOverdraftQuoteAgreement(appPrdct.Id, 'Credit Onboarding Quote'),'not null');
        test.stopTest();
    }
}