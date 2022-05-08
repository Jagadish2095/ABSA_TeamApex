/**
 * @description       : This class handles authentication and session storage for CreditLens comms
 * @author            : Tawanda M.
 * @group             :
 * @last modified on  : 09-11-2021
 * @last modified by  : Tawanda M.
 **/
public class CreditLensViewController {

  /**
  * @description Method to return the correct endpoint to point to based on environment
  * @author Tawanda M. | 11-03-2021 
  * @return String 
  **/
  @AuraEnabled
  public static String getMoodysEnvironment() {
    //Target
    String liveTarget;
    String qaTarget;
    //Get setting from metadata
    List<Credit_Lens_Setting__mdt> settingsData = [Select URI__c, MasterLabel from Credit_Lens_Setting__mdt];
    for(Credit_Lens_Setting__mdt setting : settingsData){
      if(setting.MasterLabel == 'CreditLens_LIVE'){
        liveTarget = setting.URI__c;
      }
      else{
        qaTarget = setting.URI__c;
      }
    }
    //If sandbox target staging, else production
    if ([SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox != true) {
      return liveTarget;
    } else {
      return qaTarget;
    }
  }
}