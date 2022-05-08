/**
 * @description       : Test Class for WCC Controller
 * @author            : Ravi B, Srinivas G,Vara
 * @group             : 
 * @last modified on  : 2021-09-03
 * @last modified by  : Tawanda M.
**/
@isTest
public class CalculatorsSectionControllerTest {
  /**
  * @description Test Setup
  * @author Tawanda M. | 09-01-2021 
  **/
  @testSetup
  public static void setUpTestData() {
    //insertUser();

    
    Account accountRecord = new Account();
    accountRecord.Name = 'Test Account';
    insert accountRecord;

    Opportunity testOpp = new Opportunity();
    testOpp.Name = 'Test Opp Onboarding 1';
    testOpp.CloseDate = Date.today();
    testOpp.StageName = 'New';
    testOpp.AccountId = accountRecord.Id;
    insert testOpp;

    Application__c app = new Application__c();
    app.Opportunity__c = testOpp.id;
    insert app;

    List<Financial_Information__c> financialInfoRecords = new List<Financial_Information__c>();
    Integer fiCount = 4;
    for (Integer i = 0; i < fiCount; i++) {
      Financial_Information__c fi = new Financial_Information__c();
      fi.Application__c = app.id;
      fi.Client_Name__c = accountRecord.Name;
      fi.Financial_Statement_Qualified_Issue__c = 'NO';
      fi.Financial_Statement_Type__c = 'Unaudited';
      fi.Year_Selection__c = 'Forecast';
      fi.Statement_Date_Year_end__c = System.today().addYears(i);
      fi.No_of_Days__c = 365;
      fi.Net_Sales__c = 1200000.00;
      fi.Cost_of_Goods_Sold__c = 300000.00;
      fi.Cash_Marketable_Securities__c = 50000.00;
      fi.Stock__c = 20000.00;
      fi.Trade_Debtors__c = 35000;
      fi.Trade_Creditors__c = 10000;
      financialInfoRecords.add(fi);
    }
    insert financialInfoRecords;
  }

  @isTest
  public static void testFetchTableData() {
    final Id opportunityId = [SELECT id FROM Opportunity LIMIT 1].id;

    CalculatorsSectionController.TableDataWrapper data = CalculatorsSectionController.fetchTableData(opportunityId);
    //CalculatorsSectionController.fetchTableData(null);
    String jsonString =
      '[ { "year": 0,"date": "string",' +
      '"turnOver": 0,"costOfSales": 0, "cash": 0,  "inventories": 0,"receivables": 0,"payables": 0,"useInCalc": true' +
      '}  ]';
    CalculatorsSectionController.saveTableData(opportunityId, jsonString);
    //CalculatorsSectionController.saveTableData(null, jsonString);
    System.assert(data != null);
  }

  @future
  private static void insertUser() {
    Profile p = [
      SELECT Id
      FROM Profile
      WHERE Name = 'System Administrator'
      LIMIT 1
    ];
    UserRole r = [SELECT Id, Name FROM UserRole WHERE DeveloperName = 'Banker'];
    User futureUser = new User(
      ProfileId = p.Id,
      LastName = 'last',
      Email = 'testUser@abc.com',
      Username = 'Test123' + System.currentTimeMillis(),
      CompanyName = 'TEST',
      Title = 'title',
      Alias = 'alias',
      TimeZoneSidKey = 'America/Los_Angeles',
      EmailEncodingKey = 'UTF-8',
      LanguageLocaleKey = 'en_US',
      LocaleSidKey = 'en_US',
      SiteCode__c = '8198',
      SiteType__c = '034',
      Teller_Operator_Code__c = '12345',
      Supervisor__c = '0',
      Division__c = 'RBB',
      UserRoleId = r.Id
    );
    insert (futureUser);
  }
}