public class RegSer_InvolvedParties_Resp_IB_v1 extends Base_IB{

    public String status;
    public Integer statusCode;
    public String message;
    public cls_content content;
    public cls_links[] links;
    
    public class cls_content {
       
        public String suin ;
        public String created;
        public String updated ;
		public cls_Individual individual;
        public cls_formalOrganisation formalOrganisation;
        public cls_informalOrganisation informalOrganisation ;
        public cls_organisationUnit organisationUnit ;
        public cls_sourcesOfIncome[] sourcesOfIncome ;
        public cls_sourcesOfWealth[] sourcesOfWealth ;
        public cls_activeInIndustries[] activeInIndustries ;
		public cls_flags[] flags ;
		public cls_countries[] countries ;
		public cls_identifications[] identifications;
		public cls_addresses addresses ;
		public cls_relationships[] relationships ;
		public cls_relatedDocuments[] relatedDocuments ;
		public String riskRating; 
		public String name ; 
        public cls_primaryId primaryId;
    }
    
    public class cls_links{
        public String href;
        public String rel;
        public Boolean templated;
    }

    public class cls_organisationUnit{
        
        public cls_organisationUnit_manager manager;
        public String name;
    }
    
    public class cls_organisationUnit_manager {
        
       public String designation;
       public cls_organisationUnit_manager_employmentPosition employmentPosition;
       public String name;
       public String partySuin;
       public String surname ;
       public cls_organisationUnit_manager_type type;
    }
    
    public class cls_organisationUnit_manager_employmentPosition {
        
        public String code;
        public String description;
    }  
     public class cls_organisationUnit_manager_type {
        
        public String code;
        public String description;
    } 

    public class cls_primaryId{    
        
        public String numbers;
        public cls_primaryId_type type;
        
    }
    
    public class cls_primaryId_type {
        
        public String code;
        public String description;
    }  
    
//Individual ***********
        public class cls_Individual{

		public String	dateOfBirth ;   
		public String surname ;
		public String  initials ;
        public String  knownAs ;
        public String  occupation ;
        public String  occupationStatus ;
        public String  notificationOfDeathDate ;
        public cls_salutation  salutation ;
		public String  givenNames ;
        public cls_gender  gender ;
        public cls_raceClassification  raceClassification ;
        public cls_maritalContractType  maritalContractType ;
		public cls_maritalStatus  maritalStatus;
		public cls_residentialStatus residentialStatus ;
        public cls_clientClassification clientClassification;
 		public String name ;
        public cls_pepStatus pepStatus ;
        public cls_subStatus subStatus ;
        public cls_status status ;
        public String ficaAddressUpdateDate ;
        public String ficaAddressAttestedDate ;
        public String sourceOfIncomeAttestedDate ;
        public String nextRefreshDate ;
        public String identificationUpdateDate ;
        public String identificationAttestedDate ;
              
        
        }
    
//cls_status ***********
   public class cls_subStatus{
     	public String code;
        public String description;
          }     
    
//cls_status ***********
    public class cls_status{
     	public String code;
        public String description;
          }     
//residentialStatus ***********
    public class cls_residentialStatus{
     	public String code;
        public String description;
          } 
    
//raceClassification ***********
    public class cls_raceClassification{
     	public String code;
        public String description;
          }     
    
 //pepStatus ***********
    public class cls_pepStatus{
     	public String code;
        public String description;
          }        
 
    
//maritalContractType ***********
    public class cls_maritalContractType{
     	public String code;
        public String description;
          }     
    
//formalOrganisation ***********
    public class cls_formalOrganisation{
        
       public String ficaAddressAttestedDate ;
       public String ficaAddressUpdateDate ;
       public String identificationAttestedDate ;
       public String identificationUpdateDate ;
    //   public String jointParticipanCount ;
       public cls_formalOrganisation_manager manager; 
       public String  name ;
       public String partySuin ;
       public String surname ;
       public cls_formalOrganisation_type type;
       public cls_formalOrganisation_natureOfBusiness natureOfBusiness;
       public String nextRefreshDate;
       public cls_formalOrganisation_pepStatus pepStatus;
       public cls_formalOrganisation_primaryContact  primaryContact;
       public String registeredName;
       public cls_formalOrganisation_revenueSegment revenueSegment;
       public String sourceOfIncomeAttestedDate ;
       public cls_formalOrganisation_status status;
       public cls_formalOrganisation_subStatus subStatus;
      
    }
    
    public class cls_informalOrganisation{
        
        public String ficaAddressAttestedDate ;
        public String ficaAddressUpdateDate ;
        public String identificationAttestedDate ;
        public String identificationUpdateDate ;
        public integer jointParticipanCount ;
        public cls_informalOrganisation_manager manager;
        public String name ;
        public cls_informalOrganisation_natureOfBusiness natureOfBusiness;
        public String nextRefreshDate;
        public cls_informalOrganisation_pepStatus pepStatus;
        public cls_informalOrganisation_primaryContact primaryContact;
        public cls_informalOrganisation_revenueSegment revenueSegment;
        public String sourceOfIncomeAttestedDate ;
        public cls_informalOrganisation_status status;
        public cls_informalOrganisation_subStatus subStatus;
		public cls_informalOrganisation_type type;        
    }  
    
    
//informalOrganisation_type ***********
    public class cls_informalOrganisation_type{
     	public String code;
        public String description;
       }   
    
//informalOrganisation_subStatus **********
    public class cls_informalOrganisation_subStatus{
     	public String code;
        public String description;
          }   
    
//informalOrganisation_status ***********
    public class cls_informalOrganisation_status{
     	public String code;
        public String description;
          }      
    
//informalOrganisation_sourceOfIncomeAttestedDate ***********
    public class cls_informalOrganisation_sourceOfIncomeAttestedDate{
     	public String code;
        public String description;
          }  
 
    
//informalOrganisation_revenueSegment ***********
    public class cls_informalOrganisation_revenueSegment{
     	public String code;
        public String description;
          }  
 
 //informalOrganisation_primaryContact ***********
    public class cls_informalOrganisation_primaryContact{
     	public String designation;
        public String name;
        public String partySuin;
        public String surname;
          } 
    
//cls_informalOrganisation_pepStatus **********
    public class cls_informalOrganisation_pepStatus{
     	public String code;
        public String description;
          } 
        
//cls_informalOrganisation_natureOfBusiness **********
    public class cls_informalOrganisation_natureOfBusiness{
     	public String code;
        public String description;
          }   
              
//cls_informalOrganisation_manager ***********
    public class cls_informalOrganisation_manager{
        
      public String designation ;
       public cls_informalOrganisation_manager_employmentPosition employmentPosition ;
       public String name;
       public String partySuin;
       public String surname ;
       public cls_informalOrganisation_manager_type type;
 
    }  
    
//cls_informalOrganisation_manager_type **********
    public class cls_informalOrganisation_manager_type{
     	public String code;
        public String description;
          }     
    
//cls_informalOrganisation_manager_employmentPosition **********
    public class cls_informalOrganisation_manager_employmentPosition{
     	public String code;
        public String description;
          }     
      
//formalOrganisation_subStatus **********
    public class cls_formalOrganisation_subStatus{
     	public String code;
        public String description;
          }   
    
//formalOrganisation_status ***********
    public class cls_formalOrganisation_status{
     	public String code;
        public String description;
          }      
 /*   
//cls_formalOrganisation_sourceOfIncomeAttestedDate ***********
    public class cls_formalOrganisation_sourceOfIncomeAttestedDate{
     	public String code;
        public String description;
          }  
           
*/

//formalOrganisation_revenueSegment ***********
    public class cls_formalOrganisation_revenueSegment{
     	public String code;
        public String description;
          }  
        
//formalOrganisation_primaryContact ***********
    public class cls_formalOrganisation_primaryContact{
     	public String designation;
        public String name;
        public String partySuin;
        public String surname;
          }  
    
//formalOrganisation_pepStatus ***********
    public class cls_formalOrganisation_pepStatus{
     	public String code;
        public String description;
          }  
    
    
 //formalOrganisation_natureOfBusiness ***********
    public class cls_formalOrganisation_natureOfBusiness{
     	public String code;
        public String description;
          }     
    
//formalOrganisation_type ***********
    public class cls_formalOrganisation_type{
     	public String code;
        public String description;
       }    
    
//formalOrganisation_manager ***********
    public class cls_formalOrganisation_manager{
        public String designation ;
        public cls_formalOrganisation_manager_employmentPosition employmentPosition ;
        public String name;
        public String partySuin;
        public String surname ;
        public cls_formalOrganisation_manager_type type;
    }

//cls_formalOrganisation_manager_type **********
    public class cls_formalOrganisation_manager_type{
     	public String code;
        public String description;
          }      
    
//cls_formalOrganisation_manager_employmentPosition **********
    public class cls_formalOrganisation_manager_employmentPosition{
        public String code;
        public String description;
    }     
    
    public class cls_salutation{
        public String code;
        public String description;
    }
    public class cls_gender{
        public String code;
        public String description;
    }
    public class cls_maritalStatus{
        public String code;
        public String description;
    }
    public class cls_clientClassification{
        public String code;
        public String description;
    }


//sourcesOfIncome ***********
    public class cls_sourcesOfIncome{
        
        public String code;
        public String description;
    }
    
//sourcesOfWealth ***********
    public class cls_sourcesOfWealth{
        
        public String code;
        public String description;
    }
    
//activeInIndustries ***********
        public class cls_activeInIndustries{
        
        }   
    
//flags ***********
    public class cls_flags{
        
        public String  effectiveDate;
        public String status ;
        public cls_flags_type type ; 
        public Boolean yesNoFlag;
        
    }    
    
//countries ***********
    public class cls_countries{
        
        public cls_countries_context context;
        public String isoCode;
        public String name;
        public cls_countries_type type; 
        
        
    } 
        
//identifications ***********
        public class cls_identifications{
        public String numbers;
        public cls_identifications_type type;
        public String expiryDate;  
        public String issueDate;
        
        } 
        
//addresses ***********
    public class cls_addresses{
        public cls_addresses_addresses[]   addresses ;
        public cls_addresses_electronicAddresses[] electronicAddresses;
        public cls_addresses_preferredCommunicationChannel preferredCommunicationChannel;
        public cls_addresses_telephonicAddress[] telephonicAddress;
        
    } 
        
    

    
//relationships ***********
    public class cls_relationships{
        
        public cls_relationships_arrangement arrangement;
        public String internalIdType;
        public String internalIdValue;
        public String suin;
        public cls_relationships_type type;
        
    } 
            
//relatedDocuments ***********
    public class cls_relatedDocuments{
        
        public cls_relatedDocuments_context context;
        public String lastRefreshDate;   
        public String nextRefreshDate;
        public String receivedDate;
        public String source;
        public cls_relatedDocuments_subType subType;
        public cls_relatedDocuments_type type;
        public String uniqueIdInSourceSystem;
        public String vettedDate;
        
    } 

    
//relatedDocuments_context ***********
    public class cls_relatedDocuments_context{
        
        public String code;
        public String description;
    }   
     
//relatedDocuments_subType ***********
    public class cls_relatedDocuments_subType{
        
        public String code;
        public String description;
    }   
 
//relatedDocuments_type ***********
    public class cls_relatedDocuments_type{
        
        public String code;
        public String description;
    }   

//flags_type ***********
    public class cls_flags_type{   
        public String code;
        public String description;
        } 

//countries_type ***********
    public class cls_countries_type{   
        public String code;
        public String description;
        } 
    
//countries_context ***********
    public class cls_countries_context{   
        public String code;
        public String description;
    } 
    
//identifications_type ***********
    public class cls_identifications_type{   
        public String code;
        public String description;
    }    
    
//addresses_telephonicAddress ***********
    public class cls_addresses_telephonicAddress{   
        public String countryCode;
        public String diallingCode;
        public String numbers;     // numbers will replaced with "number" while deserialisation in IU using setFieldNameSubstitutions method 
        public cls_addresses_telephonicAddress_context context;
        public cls_addresses_telephonicAddress_type type;
        
    }    
    
//addresses_telephonicAddress_context ***********
    public class cls_addresses_telephonicAddress_context{   
        public String code;
        public String description;
    }     

//addresses_preferredCommunicationChannel ***********
    public class cls_addresses_preferredCommunicationChannel{
        public String code;
        public String description;  
        
    } 
    
//addresses_telephonicAddress_type ***********
    public class cls_addresses_telephonicAddress_type{   
        public String code;
        public String description;
    } 
    

//addresses_addresses ***********
    public class cls_addresses_addresses{   
        public String addressName1;
        public String addressName2; 
        public String suburbName;
        public String cityName; 
        public String countryName;
        public String postalCode; 
        public cls_addresses_addresses_context context;
        public cls_addresses_gpsCoordinates gpsCoordinates; 
        public cls_addresses_addresses_type type;
    } 
    
    
 //addresses_electronicAddresses ***********
    public class cls_addresses_electronicAddresses{   
        public String address;
        public cls_addresses_electronicAddresses_context context; 
        public cls_addresses_electronicAddresses_type type;
      
            }  

//addresses_electronicAddresses_context ***********
        public class cls_addresses_electronicAddresses_context{   
           public String code;
           public String description;
          
   }      
        
//addresses_electronicAddresses_type ***********
        public class cls_addresses_electronicAddresses_type{   
           public String code;
           public String description;
          
   } 
        
    
//addresses_gpsCoordinates ***********
    public class cls_addresses_gpsCoordinates{   
        public String latitude;
        public String longitude;     
    }     
    
     
//addresses_addresses_context ***********
    public class cls_addresses_addresses_context{   
        public String code;
        public String description;
    }   
    
    
//claddresses_addresses_type ***********
    public class cls_addresses_addresses_type{   
        public String code;
        public String description;
    }    
    
        
//relationships_type ***********
    public class cls_relationships_type{   
        public String code;
        public String description;
    }            
        
 //relationships_arrangement ***********
    public class cls_relationships_arrangement{ 
        
        public Boolean accountActive;
        public String arrangementCloseDate;
        public String arrangementOpenDate;
        public cls_arrangementType arrangementType;
        public cls_brand brand;
        public String initiatingPartySuin;
        public String lifecycleStatus;
        public String lifecycleStatusDate;
        public String uniqueIdInSourceSystem;
              
    } 
    
//arrangementType ***********
    public class cls_arrangementType{   
        public String code;
        public String description;
    }            
    
//brand ***********
    public class cls_brand{   
        public String code;
        public String description;
    }           
    
    public override void setFieldNameSubstitutions(){
        
        fieldNameSubstitutionMap = new Map<String, String>();
        fieldNameSubstitutionMap.put('number', 'numbers');
        
    }
    
}