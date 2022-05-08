/**
 * @description       : Test Class for credit lens view controller
 * @author            : Tawanda M.
 * @group             : 
 * @last modified on  : 09-11-2021
 * @last modified by  : Tawanda M.
**/
@isTest
public class CreditLensViewController_Test {
    @isTest
    public static void testEnvironment(){
        String target = CreditLensViewController.getMoodysEnvironment();
        System.assert(target != null);
    }
    
}