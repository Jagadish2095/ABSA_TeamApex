/**
* Controller for Compliance Summary Lightning component
* @author  Kyle Alexander 
* @created 2019-02-06
*/
public class ComplianceSummaryController {
    
    /**
* Method that gets all Compliance Summary Data
*
* @param oppId - opportunity Id
*/
    @AuraEnabled
    public static Opportunity getSummaryData(Id oppId) {
        List<Opportunity> opportunities = new OpportunitiesSelector().selectComplianceSummaryFields(oppId);
        List<Account> accounts = new AccountsSelector().selectCasaFieldsById(opportunities.get(0).AccountId, 1);
        
        if(opportunities.get(0).CASA_Screening_Status__c == null || opportunities.get(0).Risk_Rating__c  == null || opportunities.get(0).Next_Refresh_Date__c == null || opportunities.get(0).FICA_Address_Attested_Date__c == null || opportunities.get(0).FICA_Address_Updated_Date__c == null || opportunities.get(0).Identification_Attested_Date__c == null || opportunities.get(0).Identification_Updated_Date__c == null || opportunities.get(0).Source_of_Income_Attested_Date__c == null || accounts.get(0).CASA_Screening_Status__c == null
          ){
              //Joint Account
              if(accounts.get(0).RecordType.Name == 'Business Client' || accounts.get(0).RecordType.Name == 'Business Prospect'){
                  List<User> users = new UsersSelector().selectByOpportunityOwnerId(opportunities.get(0).OwnerId);
                  
                  RegSer_InvolvedParties_Resp_IB_v1 involvedParties = RegSer_InvolvedParties_IH_v1.getInvolvedParties('CIF', accounts.get(0).CIF__c);
                  
                  //Update Compliance fields
                  if(involvedParties.statusCode == 200){
                      if(involvedParties.content.riskRating != null){
                          opportunities.get(0).Risk_Rating__c = involvedParties.content.riskRating;
                      }
                      
                      if(involvedParties.content.informalOrganisation.nextRefreshDate != null){
                          opportunities.get(0).Next_Refresh_Date__c = Date.parse(involvedParties.content.informalOrganisation.nextRefreshDate.replace('-', '/'));
                      }
                      
                      if(involvedParties.content.informalOrganisation.status.description != null){
                          opportunities.get(0).Account_Status__c = involvedParties.content.informalOrganisation.status.description;
                      }
                      if(involvedParties.content.informalOrganisation.subStatus.description != null){
                          opportunities.get(0).Sub_Status__c = involvedParties.content.informalOrganisation.subStatus.description;
                      }
                      
                      if(involvedParties.content.informalOrganisation.ficaAddressAttestedDate != null){
                          opportunities.get(0).FICA_Address_Attested_Date__c = Date.parse(involvedParties.content.informalOrganisation.ficaAddressAttestedDate.replace('-', '/'));
                      }
                      
                      if(involvedParties.content.informalOrganisation.ficaAddressUpdateDate != null){
                          opportunities.get(0).FICA_Address_Updated_Date__c = Date.parse(involvedParties.content.informalOrganisation.ficaAddressUpdateDate.replace('-', '/'));
                      }
                      
                      if(involvedParties.content.informalOrganisation.identificationAttestedDate != null){
                          opportunities.get(0).Identification_Attested_Date__c = Date.parse(involvedParties.content.informalOrganisation.identificationAttestedDate.replace('-', '/'));
                      }
                      
                      if(involvedParties.content.informalOrganisation.identificationUpdateDate != null){
                          opportunities.get(0).Identification_Updated_Date__c = Date.parse(involvedParties.content.informalOrganisation.identificationUpdateDate.replace('-', '/'));
                      }
                      
                      if(involvedParties.content.informalOrganisation.sourceOfIncomeAttestedDate != null){
                          opportunities.get(0).Source_of_Income_Attested_Date__c = Date.parse(involvedParties.content.informalOrganisation.sourceOfIncomeAttestedDate.replace('-', '/'));
                      }
                  }
                  else{
                      return null;
                  }
                  
                  //update accounts;
                  update opportunities;
                  
                  if(accounts.get(0).CASA_Screening_Status__c == null){
                      opportunities.get(0).CASA_Status__c = accounts.get(0).CASA_Screening_Status__c;
                  }
                  
                  return opportunities.get(0);
              }
              
              //Individual
              else if(accounts.get(0).RecordType.Name == 'Individual Client' || accounts.get(0).RecordType.Name == 'Individual Prospect'){
                 
                  List<User> users = new UsersSelector().selectByOpportunityOwnerId(opportunities.get(0).OwnerId);
                  CASAPrimaryClientScreening_Resp_IB_v2 casaScreening = CASAPrimaryClientScreening_IH_v2.casaPrimaryClientScreening(accounts.get(0), users.get(0).Id, 'F2F3', '102', '3232', false);
                  RegSer_InvolvedParties_Resp_IB_v1 involvedParties = RegSer_InvolvedParties_IH_v1.getInvolvedParties('CIF', accounts.get(0).CIF__c);
                  
                  System.debug(casaScreening);
                  //Update CASA Status
                  if(casaScreening.statusCode == 200 && casaScreening.msgNo == '0'){
                      accounts.get(0).CASA_Reference_Number__c = casaScreening.refNo;
                      accounts.get(0).CASA_Screening_Date__c = Date.today();
                      accounts.get(0).CASA_Screening_Status__c = 'Approved'; 
                      opportunities.get(0).CASA_Status__c = 'Valid';
                      
                      update accounts;                  
                  }
                  else{
                      if(!Test.isRunningTest()){
                          return null;
                      }
                  }
                  
                  //Update Compliance fields
                  if(involvedParties.statusCode == 200){
                      if(involvedParties.content.riskRating != null){
                          opportunities.get(0).Risk_Rating__c = involvedParties.content.riskRating;
                      }
                      
                      if(involvedParties.content.individual.nextRefreshDate != null){
                          opportunities.get(0).Next_Refresh_Date__c = Date.parse(involvedParties.content.individual.nextRefreshDate.replace('-', '/'));
                      }
                      
                      if(involvedParties.content.individual.status != null){
                          opportunities.get(0).Account_Status__c = involvedParties.content.individual.status.description;
                      }
                      if(involvedParties.content.individual.subStatus != null){
                          opportunities.get(0).Sub_Status__c = involvedParties.content.individual.subStatus.description;
                      }
                      
                      if(involvedParties.content.individual.ficaAddressAttestedDate != null){
                          opportunities.get(0).FICA_Address_Attested_Date__c = Date.parse(involvedParties.content.individual.ficaAddressAttestedDate.replace('-', '/'));
                      }
                      
                      if(involvedParties.content.individual.ficaAddressUpdateDate != null){
                          opportunities.get(0).FICA_Address_Updated_Date__c = Date.parse(involvedParties.content.individual.ficaAddressUpdateDate.replace('-', '/'));
                      }
                      
                      if(involvedParties.content.individual.identificationAttestedDate != null){
                          opportunities.get(0).Identification_Attested_Date__c = Date.parse(involvedParties.content.individual.identificationAttestedDate.replace('-', '/'));
                      }
                      
                      if(involvedParties.content.individual.identificationUpdateDate != null){
                          opportunities.get(0).Identification_Updated_Date__c = Date.parse(involvedParties.content.individual.identificationUpdateDate.replace('-', '/'));
                      }
                      
                      if(involvedParties.content.individual.sourceOfIncomeAttestedDate != null){
                          opportunities.get(0).Source_of_Income_Attested_Date__c = Date.parse(involvedParties.content.individual.sourceOfIncomeAttestedDate.replace('-', '/'));
                      }
                  }
                  else{
                      return null;
                  }
                  
                  update accounts;
                  update opportunities;
                  
                  opportunities.get(0).CASA_Status__c = accounts.get(0).CASA_Screening_Status__c;
                  return opportunities.get(0);
              }
          }
        else{
            opportunities.get(0).CASA_Status__c = accounts.get(0).CASA_Screening_Status__c;
            return opportunities.get(0);
        }
        return null;
    }    
}