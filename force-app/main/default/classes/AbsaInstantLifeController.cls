/**
* @description Controller for Absa Instant Life
* @author  Satya Boyenepalli
* @created 2021-08-04
* @modified Haritha Police 2021-08-26
*/

public  with sharing class  AbsaInstantLifeController {
    /**
* @description ABSA Instant Life Quote service
* @param   recordId
* @param   InsuredAmount
* @param   Education
* @param   IsSmoker
* @param   MonthlyIncomeAmount
* @return  The Quote service response
*/
    @AuraEnabled
    public static string getAbsaInstantLifeQuote( Id recordId,String InsuredAmount,String Education,
                                                 String IsSmoker,String MonthlyIncomeAmount)
    { 
        string usr = System.UserInfo.getUserId();
        User userInfo = [SELECT SiteCode__c,AB_Number__c,Teller_Operator_Code__c FROM User WHERE Id = :usr];
        Quote_Res_IB_v1  responseBean;
        Account accounts = new AccountsSelector().selectAllById(recordId);
        String responseBeanStr='';
        try
        {
            Quote_Req_IB_v1 requestBean = new Quote_Req_IB_v1();
            if(userInfo.SiteCode__c != null && userInfo.AB_Number__c != null)
            {
                requestBean.CampaignId=userInfo.SiteCode__c +'-'+ userInfo.AB_Number__c;
            } else {
                requestBean.CampaignId = '';
            }
            requestBean.Password='FredSmith1';   		 /*static password for absa instant life */
            requestBean.PartyId='132999';				/* static PartyId for salesforce for absa instant life */		
            requestBean.UserName='leo@intellimin.com';	/* static UserName for absa instant life */
            requestBean.ContactDetails = new Quote_Req_IB_v1.ContactDetails();
            requestBean.ContactDetails.Email=accounts.PersonEmail;
            requestBean.ContactDetails.FirstName=accounts.FirstName;
            requestBean.ContactDetails.HomePhoneNumber=accounts.Alternate_Phone1__pc;
            requestBean.ContactDetails.LastName=accounts.LastName;
            requestBean.ContactDetails.MobileNumber=accounts.PersonMobilePhone;
            requestBean.KeyFactors = new Quote_Req_IB_v1.KeyFactors();
            requestBean.KeyFactors.DateOfBirth=String.valueof(accounts.PersonBirthdate);
            requestBean.KeyFactors.Education=Education;
            requestBean.KeyFactors.EffectiveDate= String.valueof(Datetime.now().format('yyyy-MM-dd'));
            requestBean.KeyFactors.Gender= accounts.Gender__pc.substring(0,1) ;
            requestBean.KeyFactors.IsSmoker=IsSmoker;
            requestBean.KeyFactors.Location='ZA';  /* static Location for absa instant life */
            requestBean.KeyFactors.MonthlyIncomeAmount=MonthlyIncomeAmount;
            requestBean.InsuredLines = new List<Quote_Req_IB_v1.InsuredLines>();
            Quote_Req_IB_v1.InsuredLines inlines = new  Quote_Req_IB_v1.InsuredLines();
            inlines.InsuredAmount=InsuredAmount;
            inlines.ProductCode='LIFE_COVER';  /* static Product Code for absa instant life */
            requestBean.InsuredLines.add(inlines);
            responseBean = Quote_IH_v1.AbsaInstantLifeQuote(requestBean);
            responseBeanStr  = responseBean.serialize(responseBean);
        }
        catch(Exception exc){
            throw new ApplicationException('Something went wrong: '+ exc.getMessage());
        }
        
        return responseBeanStr;
    }
    /**
* Added by Satya Boyenepalli
* @description ABSA Instant Life Lead Tracker service
* @return  The Lead Tracker service response
*/
    @AuraEnabled
    public static string getAbsaInstantLifLeadTracker()
    {
        string usr = System.UserInfo.getUserId();        
        User userInfo = [SELECT SiteCode__c,AB_Number__c,Teller_Operator_Code__c FROM User WHERE Id = :usr];
        
        Tracker_Res_IB_v1 response = new Tracker_Res_IB_v1() ;
        String responseBeanStr='';
        try
        {
            Tracker_Req_IB_v1 requestBean = new Tracker_Req_IB_v1();
            if(userInfo.SiteCode__c != null && userInfo.AB_Number__c != null)
            {
                requestBean.CampaignId=userInfo.SiteCode__c +'-'+ userInfo.AB_Number__c.toUppercase();
            } else {
                requestBean.CampaignId = '';
            }
            requestBean.PartyId='132999';     										/* static PartyId for salesforce for absa instant life */
            requestBean.Password='FredSmith1';										 /*static password for absa instant life */
            requestBean.UserName='leo@intellimin.com';	             /* static UserName for absa instant life */
            response =  Tracker_IH_v1.AbsaInstantLifeTracker(requestBean);
            responseBeanStr = response.serialize(response);
        } catch(Exception exc){
            throw new ApplicationException('Something went wrong: '+ exc.getMessage());
        }
        return responseBeanStr;
    }
    /**
* @description Method that returns an Account details
* @param   recordId
* @return  The Account string record
*/
    @AuraEnabled
    public static String getAccountInfo(Id recordId) {
        String result = '';
        Account account = [SELECT  FirstName,LastName,ID_Number__pc,PersonEmail,PersonMobilePhone ,Alternate_Phone1__pc,Age__pc,Gender__pc,PersonBirthdate FROM Account WHERE Id = :recordId ];
        result = account.FirstName +','+account.LastName+','+account.ID_Number__pc+','+account.PersonEmail+','+account.PersonMobilePhone+','+
            account.Alternate_Phone1__pc+','+account.Age__pc+','+account.Gender__pc+','+ account.PersonBirthdate ;
        return result;
    }
    /**
  /**
* @description getting Agent Name
* @return  The user agent name
*/
    @AuraEnabled
    public static string getAgentName()
    {
        string usr = System.UserInfo.getUserId();
        User userInfo = [SELECT Name ,AB_Number__c FROM User WHERE Id = :usr];
        string agentName = userInfo.Name + ' ' + userInfo.AB_Number__c;
        return agentName;
    }
    
    /**
* Added By Haritha Police
* @description Method that returns an Account details
* @param   recordId
* @return  The Contact object record
*/
    @AuraEnabled
    public static Contact getAccount(Id recordId) {

       Contact con= [Select id,Name,OtherPhone,AccountId,Account.FirstName,Account.LastName,Account.ID_Number__pc,Account.PersonEmail,Account.PersonMobilePhone,
                           Account.Age__pc,Account.Gender__pc,Account.PersonBirthdate from Contact where AccountId=:recordId];

        return con;
    }
    
    /**
* Added By Haritha Police
* @description ABSA Instant Life Lead submission service
* @param   recordId
* @param   CallbackDate
* @param   CallbackTime
* @return  The Lead submission service response
*/
    @AuraEnabled
    public static string submitAbsaInstantLifeLead( Id recordId, String CallbackDate,string CallbackTime)
    {
        string usr = System.UserInfo.getUserId();
        User userInfo = [SELECT SiteCode__c,userName,AB_Number__c,Teller_Operator_Code__c FROM User WHERE Id = :usr];
        Account accountRec = new AccountsSelector().selectAllById(recordId);
        Address__c postalAddress = [
            SELECT Shipping_Street__c, Shipping_Street_2__c, Shipping_Suburb__c, Shipping_City__c, Shipping_Country__c, Shipping_Zip_Postal_Code__c
            FROM Address__c
            WHERE Account__c = :accountRec.Id AND Address_TYpe__c = 'Postal'
            LIMIT 1
        ];
        Lead_Res_IB_v1 responseBean;
        String responseBeanStr='';
        try
        {
            Lead_Req_IB_v1 requestBean = new Lead_Req_IB_v1();
            if(userInfo.SiteCode__c != null && userInfo.AB_Number__c != null)
            {
                requestBean.CampaignId=userInfo.SiteCode__c +'-'+ userInfo.AB_Number__c;
            } else {
                requestBean.CampaignId = '';
            }
            requestBean.PartyId='132999';     										/* static PartyId for salesforce for absa instant life */
            requestBean.Password='FredSmith1';										 /*static password for absa instant life */
            requestBean.UserName='leads133963@absabranch.co.za';	             /* static UserName for absa instant life */
            requestBean.Address1=(postalAddress.Shipping_Street__c != null)
                ? postalAddress.Shipping_Street__c : '';
            requestBean.Address2=(postalAddress.Shipping_Suburb__c != null) ? postalAddress.Shipping_Suburb__c : '';
            requestBean.Address3=(postalAddress.Shipping_City__c != null) ? postalAddress.Shipping_City__c : '';
            requestBean.AltPhone=accountRec.Alternate_Phone1__pc;
            requestBean.City=(postalAddress.Shipping_City__c != null) ? postalAddress.Shipping_City__c : '';
            requestBean.Comments='tyuiop';
            requestBean.DateOfBirth=string.valueOf(accountRec.PersonBirthdate);
            requestBean.Email=accountRec.PersonEmail;
            requestBean.FirstName=accountRec.FirstName;
            requestBean.Gender=accountRec.Gender__pc.substring(0,1);
            requestBean.SouthAfricanId=accountRec.ID_Number__pc;//SouthAfricanId;
            requestBean.LastName=accountRec.LastName;
            requestBean.MiddleInitial=accountRec.MiddleName;
            requestBean.PhoneNumber=accountRec.PersonMobilePhone;
            requestBean.PostalCode=(postalAddress.Shipping_Zip_Postal_Code__c != null) ? postalAddress.Shipping_Zip_Postal_Code__c : '';
            requestBean.Province=(postalAddress.Shipping_Suburb__c != null) ? postalAddress.Shipping_Suburb__c : '';
            requestBean.Title=accountRec.Titles__pc;
            requestBean.CallbackDateTime=CallbackDate+'T'+CallbackTime;
            responseBean = Lead_IH_v1.AbsaInstantLifeLead(requestBean);
            if(responseBean.ValidationErrors.size()>0)
            {
                if (responseBean.statusCode == 200 && responseBean.ValidationErrors[0].Message != null) {
                    responseBeanStr= responseBean.ValidationErrors[0].Message;
                }}else{
                    responseBeanStr = 'Success';
                }
        }catch(Exception exc){
            throw new ApplicationException('Something went wrong: '+ exc.getMessage());
        }
        return responseBeanStr;
    }
}