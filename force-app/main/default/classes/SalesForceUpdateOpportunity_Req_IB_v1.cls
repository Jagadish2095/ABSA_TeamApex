/**
* Apex Integration Request Bean class for updating salesforce opportunity
* @author  Muvhuso Nekhubvi : Absa
* @since   2019-05-21
*
**/
global class SalesForceUpdateOpportunity_Req_IB_v1 extends Base_IB  {
    
    public string leadNumber;
    public string opportunityStage;
    public string externalReference;
    public string extenalSystem;
    public string comments;
    
    public string leadValueTemp; //for testing
    
    public void createDummyRequest(){
        
        Opportunity newOpp = new Opportunity();

        newOpp.Lead_Number__c = 'Absa - 0000555';
        newOpp.LeadSource = 'Internal Propensity';
        newOpp.RecordTypeId = '0121r000000eE5WAAU';
        newOpp.Name = 'Muvhuso Opp Test';
        newOpp.StageName = 'Open';
        newOpp.CloseDate = Date.today();
        insert newOpp;
        leadValueTemp = newOpp.Lead_Number__c;
        this.leadNumber = newOpp.Lead_Number__c;
        this.opportunityStage = 'Completed';
        this.externalReference = 'ESP';
        this.extenalSystem = 'ESP';
        this.comments = ' UPDATE OPP Test';
        
    }
    
    public void createDummyRequestOpportunityAlreadyExist(){
        this.leadNumber = 'Absa - 0000555';
        this.opportunityStage = 'Completed';
        this.externalReference = 'ESP';
        this.extenalSystem = 'ESP';
        this.comments = 'Test Muvhuso';
    }
    
    public void createDummyRequestRequiredFields(){
        this.leadNumber = '';
        this.opportunityStage = '';
        this.externalReference = '';
        this.extenalSystem = '';
        this.comments = '';
    }
    
    public void createDummyRequestInvalidStatus(){
        this.leadNumber = 'Absa2 - ';
        this.opportunityStage = 'Rej';
        this.externalReference = 'ESP';
        this.extenalSystem = 'ESP';
        this.comments = ' UPDATE OPP Test';
        
        
    }
    
    
}