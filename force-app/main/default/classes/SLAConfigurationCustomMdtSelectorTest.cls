@isTest
public class SLAConfigurationCustomMdtSelectorTest {
    
    @isTest static void sLAConfigurationSelectorTest(){
        List<SLA_Configuration__mdt> slaConfiguration = new  SLAConfigurationCustomMdtSelector().selectByLabel('WealthAdvisory2Media'); 
        System.assertNotEquals(slaConfiguration, null);
    }

}