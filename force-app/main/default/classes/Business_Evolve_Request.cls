public class Business_Evolve_Request {
    
    public Header header {get; set;}
    public Individual individual { get; set; }
    public NonIndividual nonIndividual { get; set; }
    
    
    public class Header {
        public String ExecutionLayerRequestID {get; set;}
        public String Timestamp {get; set;}
    }
    
    public class Individual {
        public Account acc {get; set;}
        public List<Address__c> addresses {get; set;}  
        public List<Trading_as_Name__c> tradingAsNames {get; set;} 
        public List<OpportunityLineItem> lineItems {get; set;} 
        public Application__c application {get; set;} 
        public Application_Product__c appProduct {get; set;} 
        public List<relatedParty> relatedParties {get; set;}
        
    }
    
    public class NonIndividual {
        public Account acc {get; set;}
        public List<Address__c> addresses  {get; set;} 
        public List<Trading_as_Name__c> tradingAsNames  {get; set;} 
        public List<OpportunityLineItem> lineItems  {get; set;} 
        public Application__c application {get; set;} 
        public Application_Product__c appProduct {get; set;} 
        public List<relatedParty> relatedParties {get; set;} 
    }
    
    public class relatedParty {
        public String Type {get; set;}
        public Account acc {get; set;}
        public List<Address__c> addresses  {get; set;} 
        public AccountContactRelation accConRel {get; set;}
    }
    
    public static final Map<String, String> propertyMappings = new Map<String, String>{
        'Account' => 'acc',
        'Address__c' => 'addresses',
        'Trading_as_Name__c' => 'tradingAsNames', 
        'OpportunityLineItem' => 'lineItems',
        'Application__c' => 'application',
        'Product2' => 'Product2Id',
        'AccountContactRelation' => 'accConRel',
        'Lead' => 'lead',
        'Type' => 'type'
        
    };

}