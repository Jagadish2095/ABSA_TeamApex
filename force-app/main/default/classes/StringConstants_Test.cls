/**
 * @description       :  
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @last modified on  : 2021-11-23
 * @last modified by  : Vinod.Thupakula@absa.africa
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   2021-07-10   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
@IsTest

/**
 * @description  string constant test
  Author: Lithamsanqa
  Date: 30/08/2019
  JitterbitAuthRequest Test Class
***/
public with sharing class StringConstants_Test {
  /**
 * @description  testmethod
  Author: Lithamsanqa
  Date: 30/08/2019
  JitterbitAuthRequest Test Class
***/
@IsTest public static  void UnitTest(){
         //StringConstants.INBOUND_RECORD_TYPE='Inbound';
     StringConstants a = new StringConstants();
        // a.INBOUND_RECORD_TYPE = 'kskjdksd';
        System.assert('Test25102017105243'== 'Test25102017105243' , 'assert failed');
     }
}