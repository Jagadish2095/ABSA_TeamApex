/**
 * @description generateCPFDocumentsTest Description
 *
 *push
 */
@isTest
public class generateCPFDocumentsTest {
    @TestSetup
    static void makeData() {
        Date todaysDate = System.today();
        Account acc = new Account(Name = 'Test New Bus Client', Client_Type__C = 'Private Company');
        insert acc;
        Map<String, Schema.RecordTypeInfo> opportunityRecordTypeMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        system.debug('opportunityRecordTypeMap.get(CPF_Onboarding).getRecordTypeId() ' + opportunityRecordTypeMap.get('CPF_Onboarding').getRecordTypeId());
        User userRec = new UsersSelector().selectById(UserInfo.getUserId());
        List<Site__c> sitecodes;
        if (userRec.SiteCode__c != null){
            sitecodes = new SitesSelector().selectBySiteCode(userRec.SiteCode__c);
        } else{
            sitecodes = new List<Site__c>();
        }

        Address__c testBusinessAddress = new Address__c(Account__c = acc.Id, Address_Type__c = 'Business Address',Client_Entity_Type__c = 'Private Company',Shipping_Country__c = 'South Africa', Shipping_State_Province__c = 'Gauteng',Shipping_Street__c = 'Street 37',Shipping_Suburb__c = 'Maboneng',Shipping_Zip_Postal_Code__c = '1619',Shipping_City__c = 'City', Shipping_Street_2__c='Shipping_Street_2__c');
        insert testBusinessAddress;

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

        cpfOpp.Adviser__c = userRec.Id;
        cpfOpp.Regional_Manager__c = userRec.Id;
        insert cpfOpp;

        Application__c cpfApp = new Application__c();
        cpfApp.Opportunity__c = cpfOpp.Id;
        cpfApp.Preferred_Communication_Method__c='himanshu.nimje@absa.africa';
        cpfApp.Preferred_SMS__c='065892600';
        cpfApp.Preferred_Communication_Method__c='Email';
        cpfApp.Fees_Waived__c = true;
        cpfApp.Application_Status__c = 'Pending'; // Tinashe W-004373
        cpfApp.Products_And_Services__c = 'NotifyMe';
        insert cpfApp;

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
        appPrdctCpf.Multiple_phases_applicable__c = 'No';
        appPrdctCpf.Proof_of_Pre_sales__c = 'Yes';
        appPrdctCpf.Covenants_applicable_to_the_Borrower__c = 'the Borrower and its subsidiaries';
        appPrdctCpf.Covenants_applicable_to_the_Parent__c = 'the Parent and its subsidiaries';
        appPrdctCpf.Covenants_applicable_to_the_Guarantor_s__c = 'the Guarantor(s) and its subsidiaries';
        appPrdctCpf.Covenants_applicable_to_the_Security_Pro__c = 'the Security Provider(s) and its subsidiaries';
        appPrdctCpf.Interest_Cover_Ratio__c = 'Ratcheting';
        insert appPrdctcpf;

        LIST<Document_Template__c> docTemplates = new LIST<Document_Template__c>();
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
        test6171DocumentTemplate.Opportunity_Record_Types__c = 'Merchant Onboarding';
        test6171DocumentTemplate.Parent_Document_Type__c = 'Business Client Agreement';
        docTemplates.add(test6171DocumentTemplate);

        test6171DocumentTemplate = new Document_Template__c();
        test6171DocumentTemplate.Name = 'Absa 6094 - CPF Development Loan Commercial Terms - Word - Multi Phase';
        test6171DocumentTemplate.XML__c = '<Schema>  <ABSA3121_SiteVerificationDetails>    <SiteVerificationDetails></SiteVerificationDetails>    <Id>4074</Id>  </ABSA3121_SiteVerificationDetails>  {{#AccountList}}  <ABSA3121_AccountNumbers>    <AccountNumber>{{AccountNumber}}</AccountNumber>    <ParentId>3039</ParentId>    <Id>781</Id>  </ABSA3121_AccountNumbers> {{/AccountList}}  <AISxMetaData>    <IsCPA>0</IsCPA>    <IsNCA>false</IsNCA>    <Language>E</Language>    <IsDigitalSignature>false</IsDigitalSignature>  </AISxMetaData>  <ABSA3121>    <FormalInformalSettlement>{{Application.Settlement_type__c}}</FormalInformalSettlement>    <SiteVisitDate>{{Application.Site_visit_date__c | format_date}}</SiteVisitDate>    <SiteVisitCPFullName>{{Application.First_Name__c}}{{Application.Surname__c}}</SiteVisitCPFullName>    <CSARefNo>{{Application.Application_Number__c}}</CSARefNo>    <AccountNumber>{{Account.AccountNumber}}</AccountNumber>    <ClientCIF>{{Account.CIF__c}}</ClientCIF>    <InitiatorAbNo>{{User.AB_Number__c}}</InitiatorAbNo>    <SurnameOrEntityName>{{Account.Trading_Name__c}}{{Account.LastName}}</SurnameOrEntityName>    <TradingSurnameOrEntityName>{{Account.Trading_Name__c}}{{Account.LastName}}</TradingSurnameOrEntityName>    <InitiatorName>{{User.Name}}</InitiatorName>    <InitiatorSurname>{{User.LastName}}</InitiatorSurname>   <IdNo>{{Account.ID_Number__c}}</IdNo>    <IdType>{{Account.ID_Type__c}}</IdType>    <Id>1642</Id>    <PhysicalAddressCity>{{TradingAddress.Shipping_City__c}}</PhysicalAddressCity>    <PhysicalAddressCode>{{TradingAddress.Shipping_Zip_Postal_Code__c}}</PhysicalAddressCode>    <PhysicalAddressSuburb>{{TradingAddress.Shipping_Suburb__c}}</PhysicalAddressSuburb>    <PhysicalAddressLine2>{{TradingAddress.Shipping_State_Province__c}}</PhysicalAddressLine2>    <PhysicalAddressLine1>{{TradingAddress.Shipping_Street__c}}</PhysicalAddressLine1>    <SiteVerificationDetails></SiteVerificationDetails>	<!-- where do we capture than an address was verified-->    <VerifiedAddressInfo></VerifiedAddressInfo>    <PhysicalAddressCountry>{{TradingAddress.Shipping_Country__c}}</PhysicalAddressCountry>    <PhysicalAddressType>{{TradingAddress.Address_Type__c}}</PhysicalAddressType>    <InitiatorTitle>{{User.Title}}</InitiatorTitle>    <Title></Title>    <FullName>{{Account.Name}}</FullName>    <SiteVisitCPTitle>{{Application.Title__c}}</SiteVisitCPTitle>    <SiteVisitCPSurnameOrEntityName>{{Account.Trading_Name__c}}{{Account.LastName}}</SiteVisitCPSurnameOrEntityName>    <TradingFullName>{{Application.First_Name__c}}{{Application.Surname__c}}</TradingFullName>    <TradingTitle></TradingTitle>  </ABSA3121>  <LSOIAddress>  <!-- Not sure what row we talking of here-->    <Row></Row>  </LSOIAddress></Schema>';
        test6171DocumentTemplate.Document_Type__c = 'Absa 6094 - CPF Development Loan Commercial Terms - Word - Multi Phase';
        test6171DocumentTemplate.Signature_Required__c = True;
        test6171DocumentTemplate.ECM_Account_Number_Metadata__c=true;
        test6171DocumentTemplate.ECM_Business_Unit_Metadata__c=true;
        test6171DocumentTemplate.ECM_CIF_Code_Metadata__c=true;
        test6171DocumentTemplate.ECM_Filing_Date_Metadata__c=true;  
        test6171DocumentTemplate.ECM_ID_Number_Metadata__c=true;
        test6171DocumentTemplate.ECM_Item_Type__c = 'Ent_AccountApplication';
        test6171DocumentTemplate.ECM_Origin_Metadata__c = true;
        test6171DocumentTemplate.Opportunity_Record_Types__c = 'Merchant Onboarding';
        test6171DocumentTemplate.Parent_Document_Type__c = 'Business Client Agreement';
        docTemplates.add(test6171DocumentTemplate);

        test6171DocumentTemplate = new Document_Template__c();
        test6171DocumentTemplate.Name = 'Absa 6094 - CPF Development Loan Commercial Terms - PDF - Multi Phase';
        test6171DocumentTemplate.XML__c = '<Schema>  <ABSA3121_SiteVerificationDetails>    <SiteVerificationDetails></SiteVerificationDetails>    <Id>4074</Id>  </ABSA3121_SiteVerificationDetails>  {{#AccountList}}  <ABSA3121_AccountNumbers>    <AccountNumber>{{AccountNumber}}</AccountNumber>    <ParentId>3039</ParentId>    <Id>781</Id>  </ABSA3121_AccountNumbers> {{/AccountList}}  <AISxMetaData>    <IsCPA>0</IsCPA>    <IsNCA>false</IsNCA>    <Language>E</Language>    <IsDigitalSignature>false</IsDigitalSignature>  </AISxMetaData>  <ABSA3121>    <FormalInformalSettlement>{{Application.Settlement_type__c}}</FormalInformalSettlement>    <SiteVisitDate>{{Application.Site_visit_date__c | format_date}}</SiteVisitDate>    <SiteVisitCPFullName>{{Application.First_Name__c}}{{Application.Surname__c}}</SiteVisitCPFullName>    <CSARefNo>{{Application.Application_Number__c}}</CSARefNo>    <AccountNumber>{{Account.AccountNumber}}</AccountNumber>    <ClientCIF>{{Account.CIF__c}}</ClientCIF>    <InitiatorAbNo>{{User.AB_Number__c}}</InitiatorAbNo>    <SurnameOrEntityName>{{Account.Trading_Name__c}}{{Account.LastName}}</SurnameOrEntityName>    <TradingSurnameOrEntityName>{{Account.Trading_Name__c}}{{Account.LastName}}</TradingSurnameOrEntityName>    <InitiatorName>{{User.Name}}</InitiatorName>    <InitiatorSurname>{{User.LastName}}</InitiatorSurname>   <IdNo>{{Account.ID_Number__c}}</IdNo>    <IdType>{{Account.ID_Type__c}}</IdType>    <Id>1642</Id>    <PhysicalAddressCity>{{TradingAddress.Shipping_City__c}}</PhysicalAddressCity>    <PhysicalAddressCode>{{TradingAddress.Shipping_Zip_Postal_Code__c}}</PhysicalAddressCode>    <PhysicalAddressSuburb>{{TradingAddress.Shipping_Suburb__c}}</PhysicalAddressSuburb>    <PhysicalAddressLine2>{{TradingAddress.Shipping_State_Province__c}}</PhysicalAddressLine2>    <PhysicalAddressLine1>{{TradingAddress.Shipping_Street__c}}</PhysicalAddressLine1>    <SiteVerificationDetails></SiteVerificationDetails>	<!-- where do we capture than an address was verified-->    <VerifiedAddressInfo></VerifiedAddressInfo>    <PhysicalAddressCountry>{{TradingAddress.Shipping_Country__c}}</PhysicalAddressCountry>    <PhysicalAddressType>{{TradingAddress.Address_Type__c}}</PhysicalAddressType>    <InitiatorTitle>{{User.Title}}</InitiatorTitle>    <Title></Title>    <FullName>{{Account.Name}}</FullName>    <SiteVisitCPTitle>{{Application.Title__c}}</SiteVisitCPTitle>    <SiteVisitCPSurnameOrEntityName>{{Account.Trading_Name__c}}{{Account.LastName}}</SiteVisitCPSurnameOrEntityName>    <TradingFullName>{{Application.First_Name__c}}{{Application.Surname__c}}</TradingFullName>    <TradingTitle></TradingTitle>  </ABSA3121>  <LSOIAddress>  <!-- Not sure what row we talking of here-->    <Row></Row>  </LSOIAddress></Schema>';
        test6171DocumentTemplate.Document_Type__c = 'Absa 6094 - CPF Development Loan Commercial Terms - Word - Multi Phase';
        test6171DocumentTemplate.Signature_Required__c = True;
        test6171DocumentTemplate.ECM_Account_Number_Metadata__c=true;
        test6171DocumentTemplate.ECM_Business_Unit_Metadata__c=true;
        test6171DocumentTemplate.ECM_CIF_Code_Metadata__c=true;
        test6171DocumentTemplate.ECM_Filing_Date_Metadata__c=true;  
        test6171DocumentTemplate.ECM_ID_Number_Metadata__c=true;
        test6171DocumentTemplate.ECM_Item_Type__c = 'Ent_AccountApplication';
        test6171DocumentTemplate.ECM_Origin_Metadata__c = true;
        test6171DocumentTemplate.Opportunity_Record_Types__c = 'Merchant Onboarding';
        test6171DocumentTemplate.Parent_Document_Type__c = 'Business Client Agreement';
        docTemplates.add(test6171DocumentTemplate);
        insert docTemplates;

        LIST<Application_Security_CPF__c> securities = new LIST<Application_Security_CPF__c>();
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='New', Category__c='Limited Guarantee', To_be_released__c='Yes', Include_address__c='Yes'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='New', Category__c='Limited Suretyship', To_be_released__c='Yes', Include_address__c='Yes'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='Existing', Category__c='Limited Guarantee', To_be_released__c='Yes', Include_address__c='Yes'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='Existing', Category__c='UnLimited Suretyship', To_be_released__c='Yes', Include_address__c='Yes'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='Existing', Category__c='Limited Suretyship', To_be_released__c='Yes', Include_address__c='Yes'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='Existing', Category__c='Unlimited Guarantee', To_be_released__c='Yes', Include_address__c='Yes'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='New', Category__c='Unlimited Guarantee', To_be_released__c='Yes', Include_address__c='Yes'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='Existing', Category__c='Existing Mortgage Bond', To_be_released__c='Yes', Include_address__c='Yes',Mortgage_bond_type__c='Registration of mortgage bond by borrower'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='New', Category__c='Existing Mortgage Bond', To_be_released__c='Yes', Include_address__c='Yes',Mortgage_bond_type__c='Registration of mortgage bond by third party'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='New', Category__c='Existing Mortgage Bond', To_be_released__c='Yes', Include_address__c='Yes',Mortgage_bond_type__c='Registration over notarial lease'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='New', Category__c='Existing Mortgage Bond', To_be_released__c='Yes', Include_address__c='Yes',Mortgage_bond_type__c='Additional bond'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='Existing', Category__c='New Mortgage Bond', To_be_released__c='Yes', Include_address__c='Yes'));

        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='Existing', Category__c='Other', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Undertaking to Inject Cost Overrun Funds'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='Existing', Category__c='Other', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Cross Guarantee'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='Existing', Category__c='Other', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Cross Default Clause'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='Existing', Category__c='Other', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Cross Collateralisation'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='Existing', Category__c='Other', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Subordination Agreement of Loan Accounts',Claims_By__c='Borrower'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='Existing', Category__c='Other', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Subordination Agreement of Loan Accounts',Claims_By__c='Guarantor'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='Existing', Category__c='Other', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Subordination Agreement of Loan Accounts',Claims_By__c='Borrower and Guarantor'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='Existing', Category__c='Other', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Other security'));

        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='Existing', Category__c='Mortgage Bond', To_be_released__c='Yes', Include_address__c='Yes',Mortgage_bond_type__c='Registration of mortgage bond by borrower'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='New', Category__c='New Mortgage Bond', To_be_released__c='Yes', Include_address__c='Yes',Mortgage_bond_type__c='Registration of mortgage bond by borrower'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='New', Category__c='New Mortgage Bond', To_be_released__c='Yes', Include_address__c='Yes',Mortgage_bond_type__c='Registration of mortgage bond by third party'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='New', Category__c='New Mortgage Bond', To_be_released__c='Yes', Include_address__c='Yes',Mortgage_bond_type__c='Registration over notarial lease'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='New', Category__c='New Mortgage Bond', To_be_released__c='Yes', Include_address__c='Yes',Mortgage_bond_type__c='Additional bond'));

        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='Existing', Category__c='Security Cession', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Multiple dates Borrower cession'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='Existing', Category__c='Security Cession', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Single date Borrower cession'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='Existing', Category__c='Security Cession', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Single date other cedent cession'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='Existing', Category__c='Security Cession', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Multiple dates other cedent cession'));

        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='Existing', Category__c='Security Cession Existing', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Multiple dates other cedent cession'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='Existing', Category__c='Security Cession Existing', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Single date other cedent cession'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='Existing', Category__c='Security Cession Existing', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Multiple dates Borrower cession'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='Existing', Category__c='Security Cession Existing', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Single date Borrower cession'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='Existing', Category__c='Security Cession Existing', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Pledges and cession'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='Existing', Category__c='Security Cession Existing', To_be_released__c='Yes', Include_address__c='Yes',Type__c='shareholder(s)/member(s) cession'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='Existing', Category__c='Security Cession Existing', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Other cession'));

        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='New', Category__c='Security Cession', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Other cedent cession'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='New', Category__c='Security Cession', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Borrower cession'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='New', Category__c='Security Cession', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Shareholders / members cessions'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='New', Category__c='Security Cession', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Pledges and cession'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='New', Category__c='Security Cession', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Other cession'));

        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='New', Category__c='Other', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Subordination Agreement of Loan Accounts',Claims_By__c='member(s) of the Borrower'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='New', Category__c='Other', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Subordination Agreement of Loan Accounts',Claims_By__c='Borrower'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='New', Category__c='Other', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Subordination Agreement of Loan Accounts',Claims_By__c='Borrower and Guarantor'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='New', Category__c='Other', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Subordination Agreement of Loan Accounts',Claims_By__c='Guarantor'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='New', Category__c='Other', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Subordination Agreement of Loan Accounts',Claims_By__c='member(s) of the Guarantor(s)'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='New', Category__c='Other', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Subordination Agreement of Loan Accounts'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='New', Category__c='Other', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Other security'));

        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='New', Category__c='Other', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Undertaking to inject cost overrun funds'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='New', Category__c='Other', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Cross Guarantee',Cross_guarantee__c='Not applicable'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='New', Category__c='Other', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Cross Guarantee',Cross_guarantee__c='Unlimited'));
        securities.add(new Application_Security_CPF__c(Application_Product_CPF__c=appPrdctcpf.id, Security_Class__c='New', Category__c='Other', To_be_released__c='Yes', Include_address__c='Yes',Type__c='Cross Guarantee',Cross_guarantee__c='Limited'));

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
        covenants.add(new Application_Contract_Clause__c(Application_Product_CPF__c=appPrdctcpf.id,Category__c='CPF Application',Type__c='Interest Service Cover Ratio'));
        covenants.add(new Application_Contract_Clause__c(Application_Product_CPF__c=appPrdctcpf.id,Category__c='CPF Application',Type__c='Other Corporate Covenants'));
        covenants.add(new Application_Contract_Clause__c(Application_Product_CPF__c=appPrdctcpf.id,Category__c='CPF Application',Type__c='Other Pre-Lodgement Conditions'));
        covenants.add(new Application_Contract_Clause__c(Application_Product_CPF__c=appPrdctcpf.id,Category__c='CPF Application',Type__c='Other Final Drawdown Conditions'));
        covenants.add(new Application_Contract_Clause__c(Application_Product_CPF__c=appPrdctcpf.id,Category__c='CPF Application',Type__c='Conversion'));
        covenants.add(new Application_Contract_Clause__c(Application_Product_CPF__c=appPrdctcpf.id,Category__c='CPF Application',Type__c='Other Pre-Disbursement Conditions'));
        covenants.add(new Application_Contract_Clause__c(Application_Product_CPF__c=appPrdctcpf.id,Category__c='CPF Application',Type__c='other entities'));
        covenants.add(new Application_Contract_Clause__c(Application_Product_CPF__c=appPrdctcpf.id,Category__c='CPF Application',Type__c='Other Drawdown conditions'));
        insert covenants;

        List<Application_Fees__c> appFees = new List<Application_Fees__c>();
        appFees.add(new Application_Fees__c(Application_Product_CPF__c=appPrdctcpf.id,Type__c='Conversion',Fees_value__c=99,Fees_description__c='a description'));
        appFees.add(new Application_Fees__c(Application_Product_CPF__c=appPrdctcpf.id,Type__c='Fees Details',Fees_value__c=99,Fees_description__c='a description'));
        appFees.add(new Application_Fees__c(Application_Product_CPF__c=appPrdctcpf.id,Type__c='Facility',Fees_value__c=99,Fees_description__c='a description'));
        insert appFees;

        Application_Portfolio__c appPortfolio= new Application_Portfolio__c(Application_Product_CPF__c=appPrdctcpf.id);
        insert appPortfolio;

        List<Application_Phase_CPF__c> appPhaseCPF = new List<Application_Phase_CPF__c>();
        appPhaseCPF.add(new Application_Phase_CPF__c(Application_Product_CPF__c=appPrdctcpf.id,Type__c='Per Phase',Final_repayment_date__c='after the Signature Date'));
        appPhaseCPF.add(new Application_Phase_CPF__c(Application_Product_CPF__c=appPrdctcpf.id,Type__c='Multiple Phase',Final_repayment_date__c='after the date of first drawdown'));
        appPhaseCPF.add(new Application_Phase_CPF__c(Application_Product_CPF__c=appPrdctcpf.id,Type__c='Single Phase',Final_repayment_date__c='Date'));
        insert appPhaseCPF;

        LIST<Application_Lease_CPF__c> leases = new LIST<Application_Lease_CPF__c>();
        leases.add(new Application_Lease_CPF__c(Application_Product_CPF__c=appPrdctcpf.id,Other_Lease__c='Other Lease'));
        leases.add(new Application_Lease_CPF__c(Application_Product_CPF__c=appPrdctcpf.id));
        insert leases;

        List<Application_Repayment_Account_CPF__c> aralist = new List<Application_Repayment_Account_CPF__c>();
        aralist.add(new Application_Repayment_Account_CPF__c(Application_Product_CPF__c=appPrdctcpf.id,Final_repayment_date__c='Date',Type__c='Primary',Repayment_options__c='Equal Instalment'));
        aralist.add(new Application_Repayment_Account_CPF__c(Application_Product_CPF__c=appPrdctcpf.id,Final_repayment_date__c='after the Signature Date',Type__c='Primary',Repayment_options__c='Equal instalment (Bullet)'));
        aralist.add(new Application_Repayment_Account_CPF__c(Application_Product_CPF__c=appPrdctcpf.id,Final_repayment_date__c='after the date of first drawdown',Type__c='Primary',Repayment_options__c='Interest only (Bullet)'));
        aralist.add(new Application_Repayment_Account_CPF__c(Application_Product_CPF__c=appPrdctcpf.id,Final_repayment_date__c='Date',Type__c='Primary',Repayment_options__c='Capitalised interest (Bullet)'));
        aralist.add(new Application_Repayment_Account_CPF__c(Application_Product_CPF__c=appPrdctcpf.id,Final_repayment_date__c='after the Signature Date',Type__c='Primary',Repayment_options__c='Interest only period with equal instalment period thereafter (Amortising)'));
        aralist.add(new Application_Repayment_Account_CPF__c(Application_Product_CPF__c=appPrdctcpf.id,Final_repayment_date__c='after the date of first drawdown',Type__c='Primary',Repayment_options__c='Interest only period with equal instalment period thereafter (Bullet)'));
        aralist.add(new Application_Repayment_Account_CPF__c(Application_Product_CPF__c=appPrdctcpf.id,Final_repayment_date__c='Date',Type__c='Primary',Repayment_options__c='Stepped capital (Amortising)'));
        aralist.add(new Application_Repayment_Account_CPF__c(Application_Product_CPF__c=appPrdctcpf.id,Final_repayment_date__c='Date',Type__c='Primary',Repayment_options__c='Interest only period with stepped instalment period thereafter (Amortising)'));
        aralist.add(new Application_Repayment_Account_CPF__c(Application_Product_CPF__c=appPrdctcpf.id,Final_repayment_date__c='Date',Type__c='Primary',Repayment_options__c='Interest only period with stepped instalment period thereafter (Bullet)'));
        aralist.add(new Application_Repayment_Account_CPF__c(Application_Product_CPF__c=appPrdctcpf.id,Final_repayment_date__c='Date',Type__c='Primary',Repayment_options__c='Interest only period with stepped capital period thereafter (Amortising)'));
        aralist.add(new Application_Repayment_Account_CPF__c(Application_Product_CPF__c=appPrdctcpf.id,Final_repayment_date__c='Date',Type__c='Primary',Repayment_options__c='Interest only period with stepped capital period thereafter (Bullet)'));
        aralist.add(new Application_Repayment_Account_CPF__c(Application_Product_CPF__c=appPrdctcpf.id,Final_repayment_date__c='Date',Type__c='Primary',Repayment_options__c='Stepped capital (Bullet)'));
        aralist.add(new Application_Repayment_Account_CPF__c(Application_Product_CPF__c=appPrdctcpf.id,Final_repayment_date__c='Date',Type__c='Primary',Repayment_options__c='Stepped instalment (Amortising)'));
        aralist.add(new Application_Repayment_Account_CPF__c(Application_Product_CPF__c=appPrdctcpf.id,Final_repayment_date__c='Date',Type__c='Primary',Repayment_options__c='Stepped instalment (Bullet)'));

        aralist.add(new Application_Repayment_Account_CPF__c(Application_Product_CPF__c=appPrdctcpf.id,Final_repayment_date__c='Date',Type__c='Secondary',Repayment_options__c='Equal Instalment'));
        aralist.add(new Application_Repayment_Account_CPF__c(Application_Product_CPF__c=appPrdctcpf.id,Final_repayment_date__c='after the Signature Date',Type__c='Secondary',Repayment_options__c='Equal instalment (Bullet)'));
        aralist.add(new Application_Repayment_Account_CPF__c(Application_Product_CPF__c=appPrdctcpf.id,Final_repayment_date__c='after the date of first drawdown',Type__c='Secondary',Repayment_options__c='Interest only (Bullet)'));
        aralist.add(new Application_Repayment_Account_CPF__c(Application_Product_CPF__c=appPrdctcpf.id,Final_repayment_date__c='Date',Type__c='Secondary',Repayment_options__c='Capitalised interest (Bullet)'));
        aralist.add(new Application_Repayment_Account_CPF__c(Application_Product_CPF__c=appPrdctcpf.id,Final_repayment_date__c='after the Signature Date',Type__c='Secondary',Repayment_options__c='Interest only period with equal instalment period thereafter (Amortising)'));
        aralist.add(new Application_Repayment_Account_CPF__c(Application_Product_CPF__c=appPrdctcpf.id,Final_repayment_date__c='after the date of first drawdown',Type__c='Secondary',Repayment_options__c='Interest only period with equal instalment period thereafter (Bullet)'));
        aralist.add(new Application_Repayment_Account_CPF__c(Application_Product_CPF__c=appPrdctcpf.id,Final_repayment_date__c='Date',Type__c='Secondary',Repayment_options__c='Stepped capital (Amortising)'));
        aralist.add(new Application_Repayment_Account_CPF__c(Application_Product_CPF__c=appPrdctcpf.id,Final_repayment_date__c='Date',Type__c='Secondary',Repayment_options__c='Interest only period with stepped instalment period thereafter (Amortising)'));
        aralist.add(new Application_Repayment_Account_CPF__c(Application_Product_CPF__c=appPrdctcpf.id,Final_repayment_date__c='Date',Type__c='Secondary',Repayment_options__c='Interest only period with stepped instalment period thereafter (Bullet)'));
        aralist.add(new Application_Repayment_Account_CPF__c(Application_Product_CPF__c=appPrdctcpf.id,Final_repayment_date__c='Date',Type__c='Secondary',Repayment_options__c='Interest only period with stepped capital period thereafter (Amortising)'));
        aralist.add(new Application_Repayment_Account_CPF__c(Application_Product_CPF__c=appPrdctcpf.id,Final_repayment_date__c='Date',Type__c='Secondary',Repayment_options__c='Interest only period with stepped capital period thereafter (Bullet)'));
        aralist.add(new Application_Repayment_Account_CPF__c(Application_Product_CPF__c=appPrdctcpf.id,Final_repayment_date__c='Date',Type__c='Secondary',Repayment_options__c='Stepped capital (Bullet)'));
        aralist.add(new Application_Repayment_Account_CPF__c(Application_Product_CPF__c=appPrdctcpf.id,Final_repayment_date__c='Date',Type__c='Secondary',Repayment_options__c='Stepped instalment (Amortising)'));
        aralist.add(new Application_Repayment_Account_CPF__c(Application_Product_CPF__c=appPrdctcpf.id,Final_repayment_date__c='Date',Type__c='Secondary',Repayment_options__c='Stepped instalment (Bullet)'));
        insert aralist;

        Application_Team_Member__c appTeamMembers= new Application_Team_Member__c(Application_Product_CPF__c=appPrdctcpf.id,Type__c='Profession',Category__c='CPF');
        insert appTeamMembers;

        List<String> endpoints = new List<String>();
		endpoints.add('ECM Query Path');
		endpoints.add('ECM Authenication Path');
		endpoints.add('ECM Add Path');
		endpoints.add('ECM Logout Path');
		endpoints.add('ECM GetItemType Path');
		endpoints.add('ECM Get Path');
		endpoints.add('ECM GetItemTypes Path');
		IntegrationTestDataFactory.insertIntegrationSettings('API Manager', endpoints);

		List<String> endpoints2 = new List<String>();
		endpoints2.add('Document Template Processor');
		IntegrationTestDataFactory.insertIntegrationSettings('Jitterbit2', endpoints2);
    }

    @isTest
    public static void testgetSingleOrMultiPhase() {
        Opportunity cpfOpp = [Select id, Name from Opportunity where Name = 'CPF Onboarding'];
        test.startTest();
        generateCPFDocuments.generateDoc(cpfOpp.Id,'Absa 6094 - CPF Development Loan Commercial Terms - PDF - Multi Phase');
            System.assertNotEquals(null,generateCPFDocuments.getSingleOrMultiPhase(cpfOpp.Id),'not null');
            List<Application__c> applicationDetails = new ApplicationsSelector().selectByOpportunityId(cpfOpp.Id);
            List<Application_Product_CPF__c> appPrdctCpfList = new ApplicationProductCPFSelector().selectListByAppId(applicationDetails.get(0).Id);
            appPrdctCpfList.get(0).Multiple_phases_applicable__c = 'Yes';
            appPrdctCpfList.get(0).Measurement_period__c = 'each period of six months ending on the last day of each financial half year';
            appPrdctCpfList.get(0).Loan_To_Value_Covenant__c = 'No Ratcheting';
            appPrdctCpfList.get(0).Debt_service_cover_ratio__c = 'No Ratcheting';
            appPrdctCpfList.get(0).Interest_Cover_Ratio__c = 'No Ratcheting';
            update appPrdctCpfList.get(0);
            System.assertNotEquals(null,generateCPFDocuments.getSingleOrMultiPhase(cpfOpp.Id),'not null');
            generateCPFDocuments.generateDoc(cpfOpp.Id,'Absa 6094 - CPF Development Loan Commercial Terms - Word - Multi Phase');
        test.stopTest();
    }

    @isTest
    public static void testupdateOppFormStatus() {
        Opportunity cpfOpp = [Select id, Name from Opportunity where Name = 'CPF Onboarding'];
        test.startTest();
        generateCPFDocuments.updateOppFormStatus('Credit Approved',cpfOpp.Id, 'ABSA 6171 EX - Commercial Property Finance Loan');
        System.assertNotEquals(null,generateCPFDocuments.generateDoc(cpfOpp.Id, 'ABSA 6171 EX - Commercial Property Finance Loan'),'not null');
        generateCPFDocuments.getDocumentList(cpfOpp.Id);
        test.stopTest();
    }
    @isTest
    public static void testgetprodName() {
        Opportunity cpfOpp = [Select id, Name from Opportunity where Name = 'CPF Onboarding'];
        test.startTest();
        generateCPFDocuments.getprodName(cpfOpp.Id);
        System.assertNotEquals(generateCPFDocuments.getprodName(cpfOpp.Id), null, 'not null');
        generateCPFDocuments.enableWordDocGen();
        test.stopTest();
    }

	@isTest
	public static void shouldSaveChunk() {
		Test.startTest();
        Document_Template__c dt = new Document_Template__c();
        dt.Name = 'EPP ROA';
        dt.Document_Type__c = 'Credit Approval Document';
        insert dt;
		ECM_IH_V1Test.insertSettings();
		QueueHttpMock mock = new QueueHttpMock();
		mock.addResponse(JSON.serialize(HotDocsToken.getExample()));
        mock.addResponse(JSON.serialize(ECM_AddResult_IB_V1.getExample()));
        Test.setMock(HttpCalloutMock.class, mock);
		//add a document
		Id objectId = [Select id, Name from Opportunity where Name = 'CPF Onboarding'].Id;
		System.assertNotEquals(null,objectId,'not null');
		String chunk1 = EncodingUtil.base64Encode(Blob.valueOf('This is a test '));
		Id fileId = generateCPFDocuments.saveChunk(objectId, 'Test.txt', chunk1, 'txt', '', false,'Will', true, '');
        System.assertNotEquals(fileId,null,'not null');
		Test.stopTest();
    }

    /**
     * @description QueueHttpMock Description
     *
     */
	public class QueueHttpMock implements HttpCalloutMock {

        HttpResponse[] responses = new HttpResponse[0];
/**
 * @description addResponse description
 *
 * @param response (HttpResponse): response
 */
        public void addResponse(HttpResponse response) {
            responses.add(response);
        }
/**
 * @description addResponse description
 *
 * @param response (String): response
 */
        public void addResponse(String response) {
            addResponse(response, 200, 'application/json');
        }
/**
 * @description addResponse description
 *
 * @param response (String): response
 * @param code (Integer): code
 * @param contentType (String): contentType
 */
        public void addResponse(String response, Integer code, String contentType) {
            HttpResponse res = new HttpResponse();
            res.setBody(response);
            res.setStatusCode(code);
            res.setHeader('Content-Type', contentType);
            responses.add(res);
        }
/**
 * @description respond description
 *
 * @param request (HttpRequest): request
 * @return HttpResponse: Return description
 */
        public HttpResponse respond(HttpRequest request) {
            return responses.remove(0);
        }
	}
}