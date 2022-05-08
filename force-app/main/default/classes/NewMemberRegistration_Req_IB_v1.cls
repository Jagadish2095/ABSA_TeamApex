/*
* Request Integration Bean for NewMemberRegistration Service
* @author Khaliq Abdul
* @created 2020-11-02
*/

public class NewMemberRegistration_Req_IB_v1 extends Base_IB{
    
    public NewMemberRegistration NewMemberRegistration{get;set;}
    
    public class NewMemberRegistration {
        public String source;
        public RegisterMember registerMember;
    }
    public class MemberAddress {
        public String AddressLine1;
        public String AddressLine2;
        public String Suburb;
        public String City;
        public String PostalCode;
    }
    
    public class RegisterMember {
        public String ClientKey;
        public String FirstName;
        public String Surname;
        public String Title;
        public String IdentityDocumentNumber;
        public String IdentityDocumentType;
        public String HomeLanguage;
        public String WorkTelephoneNumber;
        public String CellNumber;
        public String FaxNumber;
        public String EmailAddress;
        public String BankingSector;
        public String BankTelClientIndicator;
        public String Gender;
        public String CorrespondenceLanguage;
        public String DeceasedEstateHold;
        public String DeceasedSpouseHold;
        public String DateOfBirth;
        public String DateVerified;
        public String OccupationCode;
        public String OccupationStatus;
        public String OccupationLevel;
        public String SbuSegmentIndicator;
        public String SbuSubSegment;
        public String DebitOrderFrequency;
        public String DebitOrderDay;
        public String PreferredStatementNotificationMethod;
        public String MarketingConsentTel;
        public String MarketingConsentPost;
        public String MarketingConsentCell;
        public String MarketingConsentEmail;
        public MemberAddress PostalAddress;
        public MemberAddress PhysicalAddress;
        public String DebitOrderAccountNumber;
        public String DebitOrderAccountProduct;
        public String DebitOrderAccountProductType;
        public String RegistrationSiteCode;
        public String RegistrationEmployee;
    }   
    
    public static NewMemberRegistration_Req_IB_v1 createDummyRequest(){
        
        NewMemberRegistration_Req_IB_v1 requestBean = new NewMemberRegistration_Req_IB_v1();
        
        NewMemberRegistration_Req_IB_v1.MemberAddress postalAddress= new NewMemberRegistration_Req_IB_v1.MemberAddress();
        postalAddress.AddressLine1='123 Test Road';
        postalAddress.AddressLine2='Somewhere';
        postalAddress.Suburb='';
        postalAddress.City='FLORIDA';
        postalAddress.PostalCode='1001';        
        NewMemberRegistration_Req_IB_v1.MemberAddress physicalAddress= new NewMemberRegistration_Req_IB_v1.MemberAddress();
        physicalAddress.AddressLine1='412344 B ZONE 4';
        physicalAddress.AddressLine2='';
        physicalAddress.Suburb='';
        physicalAddress.City='SOWETO';
        physicalAddress.PostalCode='4452';
        
        NewMemberRegistration_Req_IB_v1.RegisterMember registerMemberRequest = new NewMemberRegistration_Req_IB_v1.RegisterMember();
        registerMemberRequest.ClientKey = 'ABBSC  001';
        registerMemberRequest.FirstName = 'PlaasPLOT';
        registerMemberRequest.Surname = 'ABBS';
        registerMemberRequest.Title = 'Mr';
        registerMemberRequest.IdentityDocumentNumber = '4701165169185';
        registerMemberRequest.IdentityDocumentType = 'SA Identity Document';
        registerMemberRequest.HomeLanguage = '1';//Check
        registerMemberRequest.WorkTelephoneNumber = '01112345678';
        registerMemberRequest.CellNumber = '1234567890';        
        registerMemberRequest.FaxNumber = '1234567890';
        registerMemberRequest.EmailAddress = 'x@y.com';
        registerMemberRequest.BankingSector = '';
        registerMemberRequest.BankTelClientIndicator = '';
        registerMemberRequest.Gender = 'Male';
        registerMemberRequest.CorrespondenceLanguage = 'English';//CLAENG
        registerMemberRequest.DeceasedEstateHold = '';//N
        registerMemberRequest.DeceasedSpouseHold = '';//N
        registerMemberRequest.DateOfBirth = '19461111';       
        registerMemberRequest.DateVerified = '14072010';
        registerMemberRequest.OccupationCode = 'Accountant';
        registerMemberRequest.OccupationStatus = 'Full Time Employed';
        registerMemberRequest.OccupationLevel = 'Management';
        registerMemberRequest.SbuSegmentIndicator = 'F';
        registerMemberRequest.SbuSubSegment = 'F';
        registerMemberRequest.DebitOrderFrequency = 'Monthly';
        registerMemberRequest.DebitOrderDay = '11';
        registerMemberRequest.PreferredStatementNotificationMethod = ''; //NOMEMA       
        registerMemberRequest.MarketingConsentTel = 'true';
        registerMemberRequest.MarketingConsentPost = 'true';
        registerMemberRequest.MarketingConsentCell = 'true';
        registerMemberRequest.MarketingConsentEmail = 'true';        
        registerMemberRequest.PostalAddress = postalAddress;
        registerMemberRequest.PhysicalAddress = physicalAddress;        
        registerMemberRequest.DebitOrderAccountNumber = '9051314433';
        registerMemberRequest.DebitOrderAccountProduct = '';
        registerMemberRequest.DebitOrderAccountProductType = '';
        registerMemberRequest.RegistrationSiteCode = '';
        registerMemberRequest.RegistrationEmployee = '';        
        
        NewMemberRegistration_Req_IB_v1.NewMemberRegistration NewMemberRegistrationbean = new NewMemberRegistration_Req_IB_v1.NewMemberRegistration();
        NewMemberRegistrationbean.source='SPEC';
        NewMemberRegistrationbean.RegisterMember = registerMemberRequest;
        requestBean.NewMemberRegistration = NewMemberRegistrationbean;
        
        return requestBean;
    }    
    
    public override void setIntegrationTranslations()
    {
        integrationTranslationsMap = new Map<String, String>();
        integrationTranslationsMap.put( 'NewMemberRegistration.registerMember.Title', 'CIFCodesList;Titles' );
        integrationTranslationsMap.put( 'NewMemberRegistration.registerMember.Gender', 'CIFCodesList;Gender' );
        integrationTranslationsMap.put( 'NewMemberRegistration.registerMember.IdentityDocumentType', 'CIFCodesList;Idtype' );   
        integrationTranslationsMap.put( 'NewMemberRegistration.registerMember.CorrespondenceLanguage', 'CIFCodesList;Lang' );
        integrationTranslationsMap.put( 'NewMemberRegistration.registerMember.OccupationCode', 'CIFCodesList;Occucode' ); 
        integrationTranslationsMap.put( 'NewMemberRegistration.registerMember.OccupationStatus', 'CIFCodesList;Emplstatus' );
        integrationTranslationsMap.put( 'NewMemberRegistration.registerMember.OccupationLevel', 'CIFCodesList;Occulvl' );
    }
}