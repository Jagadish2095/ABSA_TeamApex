/*
    * @description  Request Integration Bean for Quote Service for Absa Instant Life
    * @author Satya Boyenepalli
    * @created 2021-07-28
    */
   /**
 * @description  Quote Request class
 */
    public  with sharing class  Quote_Req_IB_v1 extends Base_IB{
        /**
 * @description  CampaignId
 */
        public String CampaignId;
        /**
    * @description  ContactDetails   
    */
        public ContactDetails ContactDetails;
        /**
    * @description  InsuredLines; 
    */
        public List<InsuredLines> InsuredLines;
        /**
    * @description  KeyFactors 
    */
        public KeyFactors KeyFactors;
        /**
    * @description PartyId    
    */
        public String PartyId;
        /**
    * @description  Password
    */
        public String Password;
        /**
    * @description  UserName
    */
        public String UserName;
        /**
    * @description  KeyFactors    
    */
        public class KeyFactors {
            public String DateOfBirth;
            public String Education;
            public String EffectiveDate;
            public String Gender;
            public String IsSmoker;
            public String Location;
            public String MonthlyIncomeAmount;
        }
        /**
    * @description  ContactDetails    
    */
        public class ContactDetails {
            public String Email;
            public String FirstName;
            public String HomePhoneNumber;
            public String LastName;
            public String MobileNumber;
        }
        /**
    * @description  InsuredLines    
    */
        public class InsuredLines {
            public String InsuredAmount;
            public String ProductCode;
        }
        /**
    * @description  Quote Request    
    * @return Quote_Req_IB_v1
    */
        public static Quote_Req_IB_v1 createDummyRequest() {
            Quote_Req_IB_v1 requestBean = new Quote_Req_IB_v1();
            requestBean.ContactDetails = new Quote_Req_IB_v1.ContactDetails(); 
            requestBean.KeyFactors = new Quote_Req_IB_v1.KeyFactors();
            requestBean.InsuredLines = new List<Quote_Req_IB_v1.InsuredLines>();
            InsuredLines inlines = new  InsuredLines();
            inlines.InsuredAmount='600000';
            inlines.ProductCode='LIFE_COVER';
            requestBean.InsuredLines.add(inlines);
            requestBean.CampaignId='8474-EXSB149';
            requestBean.Password='FredSmith1'; 
            requestBean.PartyId='133963';
            requestBean.UserName='leo@intellimin.com';
            requestBean.ContactDetails.Email='satya.boyenepalli@absa.africa';
            requestBean.ContactDetails.FirstName='CHRISTO';
            requestBean.ContactDetails.HomePhoneNumber='0726631180';
            requestBean.ContactDetails.LastName='PIENAAR';
            requestBean.ContactDetails.MobileNumber='0726631180';
              requestBean.KeyFactors.DateOfBirth='2000-02-02';
            return requestBean;
        }
        
    }