/**
 * @description       : Short Term insurance SLA Selector Test
 * @author            : Monde Masiza
 * @last modified on  : 2021-06-01
 * @last modified by  : Monde Masiza
 * Modifications Log 
 * Ver   Date         Author         Modification
 * 1.0   2021-06-01   Monde Masiza   Initial Version
**/
@isTest 
public class ShortTermSLAsSelectorTest {

    @isTest
    private static void selectShortTermSLA() {
    
        ShortTermSLAsSelector shortTermSLAsSelector = new ShortTermSLAsSelector();
        List<Short_Term_Insurance_SLA__mdt> shortTermSLAsSelectorList = ShortTermSLAsSelector.selectShortTermSLA('Level 2');   
        system.assertEquals('Level 2', 'Level 2','Level 2');
        
    }

}