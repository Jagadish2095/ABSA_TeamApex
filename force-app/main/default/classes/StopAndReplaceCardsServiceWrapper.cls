/*
* Wrapper Class to store request details from UI to StopaAndReplaceCards Service
* @author Madhava Palla
* @created 2019-09-17
*/
public class StopAndReplaceCardsServiceWrapper {
    
    @AuraEnabled Public String plasticNbr;
    @AuraEnabled Public String reason;
    @AuraEnabled Public Date cardLostDate;
    @AuraEnabled Public Time cardLostTime;
    @AuraEnabled Public Date cardLastUsedDate; 
    @AuraEnabled Public String cardLastUsedPlace;
    @AuraEnabled Public String homePhone;
    @AuraEnabled Public String officePhone;    
    @AuraEnabled Public String distSiteCode;
    @AuraEnabled Public String distReasCode;// Check how it comes from UI
    @AuraEnabled Public Boolean wasCardSigned;
    @AuraEnabled Public Boolean didCardHaveSafePin;    
    @AuraEnabled Public Boolean doNotUseCard;
    @AuraEnabled Public String circumstances;
    @AuraEnabled Public String cardLostPlace;
    @AuraEnabled Public String cardLostDiscription;
    @AuraEnabled Public Boolean sof1;//
    @AuraEnabled Public Boolean replaceCard;
    @AuraEnabled Public String agentSiteCode;
    @AuraEnabled Public String accHolderName;
    
   public static StopAndReplaceCardsServiceWrapper dummyWrapper(){
       StopAndReplaceCardsServiceWrapper wrapper = new StopAndReplaceCardsServiceWrapper();
       wrapper.accHolderName ='Test';
       wrapper.agentSiteCode ='1234';
       wrapper.cardLastUsedDate =system.today();
       wrapper.cardLastUsedPlace ='CBD';
       wrapper.cardLostDate =system.today();
       wrapper.cardLostDiscription ='Lost';
       wrapper.cardLostPlace ='CBD';
       wrapper.cardLostTime =Time.newInstance(1, 2, 3, 4);
       wrapper.circumstances ='Test';
       wrapper.didCardHaveSafePin =true;
       wrapper.distReasCode ='Delivery Method';
       wrapper.distSiteCode='124';
       wrapper.doNotUseCard =false;
       wrapper.homePhone='1234567890';
       wrapper.officePhone ='1234567890';
       wrapper.plasticNbr ='54321';
       wrapper.reason ='Lost';
       wrapper.replaceCard =true;
       wrapper.sof1 =true;
       wrapper.wasCardSigned = false;
       return wrapper;
   } 
   
}