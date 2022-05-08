@isTest
public class DynamicPicklistValueRendererTest {
      static testMethod void test1() { 

        Application_Security_CPF__c CPFRec = new Application_Security_CPF__c(); 
        CPFRec.Name = 'testM1'; 
        CPFRec.Cross_collateralisation__c = 'Yes'; 
        insert CPFRec; 
       Map<string,string> MapValues= DynamicPicklistValueRenderer.getpickListValue('Application_Security_CPF__c','Cross_collateralisation__c');
        System.assertnotEquals(null, MapValues.isEmpty()); 
    }

}