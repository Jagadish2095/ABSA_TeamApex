/**
 * @description       : 
 * @author            : Mbuyiseni Mbhokane
 * @last modified on  : 2021-12-08
 * @last modified by  : muvhuso.nekhubvi@absa.africa
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   2021-07-15   Mbuyiseni Mbhokane   Initial Version
**/
public class ciupdateclientdetailV12_IU_v1 {
    

    
    /**
    * @description  ciUpdate Sole Trader
    * @author Monde Masiza | 2021-07-15 
    * @param acc
    * @param addressList 
    * @param translations 
    * @param clientType
    * @param siteCode 
    * @param employeeNumber 
    * @param respBean 
    * @return ciupdateclientdetailV12_Req_IB_v1 
    **/
    public static ciupdateclientdetailV12_Req_IB_v1 ciUpdateSoleTrader(Account acc, List<Address__c> addressList , Map<String,String> translations ,String clientType, String siteCode,String employeeNumber, GetClientDetailsCIF_Resp_IB_v1 respBean){  
       ciupdateclientdetailV12_Req_IB_v1 requestBean = new ciupdateclientdetailV12_Req_IB_v1();
        requestBean.CIupdateClientDetailV12 = new ciupdateclientdetailV12_Req_IB_v1.CIupdateClientDetailV12();
        requestBean.CIupdateClientDetailV12.cib003i = new ciupdateclientdetailV12_Req_IB_v1.Cib004i();
        
        String brid = [Select Id, BRID__c from User where EmployeeNumber =:employeeNumber Limit 1].BRID__c;
        
    List<AccountContactRelation> acrList = [SELECT id,AccountId,Designation__c,ContactId,Contact.Name,Contact.FirstName,Contact.LastName,Roles,Contact.MobilePhone,Contact.Email,Contact.Phone FROM AccountContactRelation WHERE AccountId =: acc.Id AND Roles INCLUDES ('Contact Person')];
    Map<String,String> addressMap = new Map<String,String>();
    for(Address__c add : addressList){
    addressMap.put(add.Address_Type__c+''+'Street',add.Shipping_Street__c) ;  
    addressMap.put(add.Address_Type__c+''+'Street2',add.Shipping_Street_2__c) ;     
    addressMap.put(add.Address_Type__c+''+'Suburb',add.Shipping_Suburb__c) ;     
    addressMap.put(add.Address_Type__c+''+'City',add.Shipping_City__c) ; 
    addressMap.put(add.Address_Type__c+''+'Zip',add.Shipping_Zip_Postal_Code__c) ; 
        
    
    }

        
        If(clientType == 'Sole Trader'){
       requestBean.CIupdateClientDetailV12.cib003i.initials= acc.Initials__pc;         
       requestBean.CIupdateClientDetailV12.cib003i.language = translations.get(acc.Language__c+''+'CIF'+''+'Language'+''+'Outbound');					//Translation
       requestBean.CIupdateClientDetailV12.cib003i.titleCode= translations.get(acc.PersonTitle+''+'CIF'+''+'Title'+''+'Outbound');
       requestBean.CIupdateClientDetailV12.cib003i.surname= acc.LastName.toUpperCase();  
       requestBean.CIupdateClientDetailV12.cib003i.idDocType=  translations.get(acc.ID_Type__pc+''+'CIF'+''+'Identity Type'+''+'Outbound');  
       requestBean.CIupdateClientDetailV12.cib003i.idNumber= acc.ID_Number__pc;  
       requestBean.CIupdateClientDetailV12.cib003i.birthDate = String.valueOf(acc.PersonBirthdate).replace('-','');
       requestBean.CIupdateClientDetailV12.cib003i.maritalStatus = translations.get(acc.Marital_Status__pc+''+'CIF'+''+'Marital Status'+''+'Outbound'); //Translation
       requestBean.CIupdateClientDetailV12.cib003i.smsMarketInd= acc.Is_Marketing_Consent_SMS__c == true? 'Y': 'N';
       requestBean.CIupdateClientDetailV12.cib003i.gender = translations.get(acc.Gender__pc+''+'CIF'+''+'Gender'+''+'Outbound');						//Translation
       requestBean.CIupdateClientDetailV12.cib003i.minorChildren = String.valueOf(acc.Number_Of_Dependents__c);
       requestBean.CIupdateClientDetailV12.cib003i.occupationCode = translations.get(acc.Gender__pc+''+'CIF'+''+'Occupation Category'+''+'Outbound');			//Translation
       requestBean.CIupdateClientDetailV12.cib003i.incomeGroup= translations.get(acc.Monthly_Income__pc+''+'CIF'+''+'Monthly Income'+''+'Outbound');       
        requestBean.CIupdateClientDetailV12.cib003i.mariageContrctType = translations.get(acc.Marital_Contract_Type__pc+''+'CIF'+''+'Marital Contract Type'+''+'Outbound');		//Translation
       requestBean.CIupdateClientDetailV12.cib003i.homeLanguage = translations.get(acc.Home_Language__pc+''+'CIF'+''+'Language'+''+'Outbound');			//Translation
       requestBean.CIupdateClientDetailV12.cib003i.marketingConcent= translations.get(acc.Non_Credit_Marketing_Consent__pc+''+'CIF'+''+'Non-Credit Marketing Consent'+''+'Outbound');
       requestBean.CIupdateClientDetailV12.cib003i.miltaryComtmntInd=  requestBean.CIupdateClientDetailV12.cib003i.miltaryComtmntInd; 
       requestBean.CIupdateClientDetailV12.cib003i.occupancyType= translations.get(acc.Residential_Status__pc+''+'CIF'+''+'Residential Status'+''+'Outbound'); 
        requestBean.CIupdateClientDetailV12.cib003i.firstNames = acc.FirstName.toUpperCase();
       requestBean.CIupdateClientDetailV12.cib003i.occupationStatus = translations.get(acc.Occupation_Status__pc+''+'CIF'+''+'Occupation Status'+''+'Outbound');		//Translation
       requestBean.CIupdateClientDetailV12.cib003i.employmentSector=respBean.employmentSector;    
       requestBean.CIupdateClientDetailV12.cib003i.occupationLevel= translations.get(acc.Occupation_Level__pc+''+'CIF'+''+'Occupation Level'+''+'Outbound');
         requestBean.CIupdateClientDetailV12.cib003i.prefrdCommtionMthd =  translations.get(acc.Preferred_Communication_Method__pc+''+'CIF'+''+'Preferred Communication Method'+''+'Outbound');		//Translation  
         requestBean.CIupdateClientDetailV12.cib003i.countryOfOrigin = translations.get(acc.Country_of_Origin__pc+''+'CIF'+''+'Country'+''+'Outbound');   
        requestBean.CIupdateClientDetailV12.cib003i.casaRefNum= acc.CASA_Reference_Number__pc;
         
        requestBean.CIupdateClientDetailV12.cib003i.clientNationality = translations.get(acc.Nationality__pc+''+'eCasa'+''+'Nationality'+''+'Outbound');
       if(acc.PersonHomePhone != null){
            Integer homeNumberSize = acc.PersonHomePhone.length();
            requestBean.CIupdateClientDetailV12.cib003i.homeTelCode = acc.PersonHomePhone.Substring(0, 3);
            requestBean.CIupdateClientDetailV12.cib003i.homeTelephone = acc.PersonHomePhone.Substring(3, homeNumberSize);
        }
            
       String affectedPersonTranslated ;
           if(acc.Q1a_Client_affected_by_Regulation_3_1_F__c == true) {
                affectedPersonTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Affected Person', String.valueOf(acc.Q1b_How_is_the_Client_Affected__c), StringConstants.OUTBOUND_RECORD_TYPE); 
                   if(String.IsBlank(affectedPersonTranslated) == false){
                       requestBean.CIupdateClientDetailV12.cib003i.affectedPerson = affectedPersonTranslated;					
                   }
                   if(acc.Q1c_Exchange_Control_Expiry_date__c != null) {
                       requestBean.CIupdateClientDetailV12.cib003i.exconExpiryDate = String.valueOf(acc.Q1c_Exchange_Control_Expiry_date__c).replace('-','');
                   }
           }
           if(acc.Q2a_Client_affected_by_Regulation_3_1_F__c == true) {
                affectedPersonTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Affected Person', String.valueOf(acc.Q2b_How_is_the_Client_Affected__c), StringConstants.OUTBOUND_RECORD_TYPE);
                   if(String.IsBlank(affectedPersonTranslated) == false){
                       requestBean.CIupdateClientDetailV12.cib003i.affectedPerson = affectedPersonTranslated;					
                   }
                   if(acc.Q2c_Exchange_Control_Expiry_date__c != null) {
                       requestBean.CIupdateClientDetailV12.cib003i.exconExpiryDate = String.valueOf(acc.Q2c_Exchange_Control_Expiry_date__c).replace('-','');
                   }
           }
            
           if(acc.Q2a_Client_affected_by_Regulation_3_1_F__c == false && acc.Q1a_Client_affected_by_Regulation_3_1_F__c == false){
             
           requestBean.CIupdateClientDetailV12.cib003i.affectedPerson = '0';  
           requestBean.CIupdateClientDetailV12.cib003i.exconExpiryDate = '0';  
         }
            
          
        requestBean.CIupdateClientDetailV12.cib003i.dateIssued= acc.Date_Issued__pc != null? String.valueOf(acc.Date_Issued__pc).replace('-','') : '';  
            
          requestBean.CIupdateClientDetailV12.cib003i.nkinSurname = acc.Next_of_Kin_Last_Name__pc;
          requestBean.CIupdateClientDetailV12.cib003i.nkinFname = acc.Next_of_Kin_First_Name_s__pc;
          requestBean.CIupdateClientDetailV12.cib003i.nkinRela = translations.get(acc.Next_of_Kin_Relationship__pc+''+'CIF'+''+'Relationship'+''+'Outbound'); 
          requestBean.CIupdateClientDetailV12.cib003i.nkinTelh = acc.Next_of_Kin_Telephone_Number__pc;
          requestBean.CIupdateClientDetailV12.cib003i.nkinCell = acc.Next_of_Kin_Cellphone_Number__pc;
          requestBean.CIupdateClientDetailV12.cib003i.nkinEmail = acc.Next_of_Kin_Email_Address__pc;
          requestBean.CIupdateClientDetailV12.cib003i.nkinTitle = '00';
          requestBean.CIupdateClientDetailV12.cib003i.nkinInitials = acc.Next_of_Kin_Initial__pc;
           requestBean.CIupdateClientDetailV12.cib003i.countryOfBirth = translations.get(acc.Country_of_Birth__pc+''+'CIF'+''+'Country'+''+'Outbound');
            
             List<String> nonCreditMarketIndP;
              if(acc.Non_Credit_Marketing_Indicator__pc != null){
                  nonCreditMarketIndP = acc.Non_Credit_Marketing_Indicator__pc.split(';');
              }
              
              List<String> creditMarketIndP;
              if(acc.Credit_Marketing_Indicator__pc != null){
                  creditMarketIndP = acc.Credit_Marketing_Indicator__pc.split(';');
              }
            
            String nonCreditMarketConsentTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Non-Credit Marketing Consent', acc.Non_Credit_Marketing_Consent__pc, StringConstants.OUTBOUND_RECORD_TYPE);
            String creditMarketConsentTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Credit Marketing Consent', acc.Credit_Marketing_Consent__pc, StringConstants.OUTBOUND_RECORD_TYPE);
            
        if(nonCreditMarketConsentTranslated != null){
           requestBean.CIupdateClientDetailV12.Cib003i.ncrInd = nonCreditMarketConsentTranslated; //Translation
           
           requestBean.CIupdateClientDetailV12.Cib003i.ncrEmail = 'N';
           requestBean.CIupdateClientDetailV12.Cib003i.ncrPost = 'N';
           requestBean.CIupdateClientDetailV12.Cib003i.ncrTel = 'N';
           requestBean.CIupdateClientDetailV12.Cib003i.ncrSms = 'N';
           
           if(nonCreditMarketIndP != null){
               for(String indicator : nonCreditMarketIndP){
                   switch on indicator {
                       when 'Email'{
                           requestBean.CIupdateClientDetailV12.Cib003i.ncrEmail = 'Y';
                       }
                       when 'Mail'{
                           requestBean.CIupdateClientDetailV12.Cib003i.ncrPost = 'Y';
                       }
                       when 'Phone'{
                           requestBean.CIupdateClientDetailV12.Cib003i.ncrTel = 'Y';
                       }
                       when 'SMS'{
                           requestBean.CIupdateClientDetailV12.Cib003i.ncrSms = 'Y';
                       }
                   }//End of switch case
               }//End of for loop
           }
       }//End of IF
       
       //Credit Marketing Consent
       if(creditMarketConsentTranslated != null){
           requestBean.CIupdateClientDetailV12.Cib003i.crInd = creditMarketConsentTranslated;					//Translation
           
           requestBean.CIupdateClientDetailV12.Cib003i.crPost = 'N';
           requestBean.CIupdateClientDetailV12.Cib003i.crTel = 'N';
           requestBean.CIupdateClientDetailV12.Cib003i.crAvoice = 'N';
           requestBean.CIupdateClientDetailV12.Cib003i.crEmail = 'N';
           requestBean.CIupdateClientDetailV12.Cib003i.crSms = 'N';
           
           if(creditMarketIndP != null){
               for(String indicator : creditMarketIndP){
                   switch on indicator {
                       when 'Mail'{
                           requestBean.CIupdateClientDetailV12.Cib003i.crPost = 'Y';
                       }
                       when 'Phone'{
                           requestBean.CIupdateClientDetailV12.Cib003i.crTel = 'Y';
                       }
                       when 'Voice Recording'{
                           requestBean.CIupdateClientDetailV12.Cib003i.crAvoice = 'Y';
                       }
                       when 'Email'{
                           requestBean.CIupdateClientDetailV12.Cib003i.crEmail = 'Y';
                       }
                       when 'SMS'{
                           requestBean.CIupdateClientDetailV12.Cib003i.crSms = 'Y';
                       }
                   }//End of switch case
               }//End of for loop
           }
       }//End of IF
         
        }
        
        
        If(clientType != 'Sole Trader'){    
       requestBean.CIupdateClientDetailV12.cib003i.initials= respBean.initials;   
       requestBean.CIupdateClientDetailV12.cib003i.language = translations.get(acc.Language__c+''+'CIF'+''+'Language'+''+'Outbound');					//Translation
       requestBean.CIupdateClientDetailV12.cib003i.surname= acc.Name.toUpperCase();
       requestBean.CIupdateClientDetailV12.cib003i.idDocType=  translations.get(acc.ID_Type__c+''+'CIF'+''+'Identity Type'+''+'Outbound');  
       requestBean.CIupdateClientDetailV12.cib003i.idNumber= acc.Registration_Number__c; 
       requestBean.CIupdateClientDetailV12.cib003i.birthDate = '0';
       requestBean.CIupdateClientDetailV12.cib003i.maritalStatus = '0';//Translation  
       requestBean.CIupdateClientDetailV12.cib003i.smsMarketInd= acc.Is_Marketing_Consent_SMS__c == true? 'Y': 'N';
       requestBean.CIupdateClientDetailV12.cib003i.gender = '0';					//Translation
       requestBean.CIupdateClientDetailV12.cib003i.minorChildren = '0';
       requestBean.CIupdateClientDetailV12.cib003i.occupationCode = '0';		//Translation
       requestBean.CIupdateClientDetailV12.cib003i.incomeGroup= translations.get(acc.Monthly_Income__c+''+'CIF'+''+'Monthly Income'+''+'Outbound');
       requestBean.CIupdateClientDetailV12.cib003i.bankingSector= respBean.bankingSector;  
       requestBean.CIupdateClientDetailV12.cib003i.mariageContrctType = '0'; 
        requestBean.CIupdateClientDetailV12.cib003i.homeLanguage = respBean.homeLanguage;  
       requestBean.CIupdateClientDetailV12.cib003i.prefrdCommtionMthd =  translations.get(acc.Preferred_Communication_Method__c+''+'CIF'+''+'Preferred Communication Method'+''+'Outbound');		//Translation     
      requestBean.CIupdateClientDetailV12.cib003i.casaRefNum= acc.CASA_Reference_Number__c;
            
        String affectedPersonTranslated ;
           if(acc.Q4a_Client_affected_by_Regulation_3_1_F__c  == true) {
                affectedPersonTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Affected Person', String.valueOf(acc.Q4b_How_is_the_Client_Affected__c), StringConstants.OUTBOUND_RECORD_TYPE); 
                   if(String.IsBlank(affectedPersonTranslated) == false){
                       requestBean.CIupdateClientDetailV12.cib003i.affectedPerson = affectedPersonTranslated;					
                   }
                   if(acc.Q4c_Exchange_Control_Expiry_date__c  != null) {
                       requestBean.CIupdateClientDetailV12.cib003i.exconExpiryDate = String.valueOf(acc.Q4c_Exchange_Control_Expiry_date__c).replace('-','');
                   }
           }
         Else{
             
           requestBean.CIupdateClientDetailV12.cib003i.affectedPerson = '0';  
           requestBean.CIupdateClientDetailV12.cib003i.exconExpiryDate = '0';  
         }
        
        }     
       
       requestBean.CIupdateClientDetailV12.cib003i.clientType= translations.get(acc.Client_Type__c+''+'CIF'+''+'Client Type'+''+'Outbound'); 
       
      // requestBean.CIupdateClientDetailV12.cib003i.sec129DeliveryAddr= '0';
       requestBean.CIupdateClientDetailV12.cib003i.clientCode= acc.CIF__c;  
       requestBean.CIupdateClientDetailV12.cib003i.bankingSector= respBean.bankingSector; 
       requestBean.CIupdateClientDetailV12.cib003i.securityIndicator= respBean.securityIndicator;
       requestBean.CIupdateClientDetailV12.cib003i.liabilityIndicator= respBean.liabilityIndicator;
       requestBean.CIupdateClientDetailV12.cib003i.telebankIndicator= respBean.telebankIndicator;
       requestBean.CIupdateClientDetailV12.cib003i.unclaimedFundsInd= respBean.unclaimedFundsInd;                                                                
       requestBean.CIupdateClientDetailV12.cib003i.branchClientOpen= siteCode;
       requestBean.CIupdateClientDetailV12.cib003i.dateClientOpened = respBean.dateClientOpened;  
       requestBean.CIupdateClientDetailV12.cib003i.changeNumber= respBean.changeNumber; 
       requestBean.CIupdateClientDetailV12.cib003i.dateLastChanged= string.valueOf(System.Today().format().replace('/',''));  
       requestBean.CIupdateClientDetailV12.cib003i.siteLastChanged= siteCode; 
       if(brid != null){
           requestBean.CIupdateClientDetailV12.cib003i.tellerLastChanged = brid.subString(2);//'09999996'
       }
       requestBean.CIupdateClientDetailV12.cib003i.nbrOfAccounts= respBean.nbrOfAccounts; 
       requestBean.CIupdateClientDetailV12.cib003i.prohibitedInd= respBean.prohibitedInd; 
       requestBean.CIupdateClientDetailV12.cib003i.postalAddrHold= respBean.postalAddrHold;  
      // requestBean.CIupdateClientDetailV12.cib003i.absaRewardIndctor = respBean.absaRewardIndctor;    
       requestBean.CIupdateClientDetailV12.cib003i.idRequiredHold= respBean.idRequiredHold;
       requestBean.CIupdateClientDetailV12.cib003i.deceasedEstateHld= respBean.deceasedEstateHld;  
       requestBean.CIupdateClientDetailV12.cib003i.deceasedSpouseHld= respBean.deceasedSpouseHld;  
       requestBean.CIupdateClientDetailV12.cib003i.insolvntEstateHld= respBean.insolvntEstateHld;   
       requestBean.CIupdateClientDetailV12.cib003i.curatorshipHold= respBean.curatorshipHold;     
       requestBean.CIupdateClientDetailV12.cib003i.savngStatementHold=respBean.savngStatementHold;   
       requestBean.CIupdateClientDetailV12.cib003i.courtAuthrityHold= respBean.courtAuthrityHold;  
       requestBean.CIupdateClientDetailV12.cib003i.thirdPartyInd= respBean.thirdPartyInd;    
       requestBean.CIupdateClientDetailV12.cib003i.mandateCaptureHld= respBean.mandateCaptureHld;   
       requestBean.CIupdateClientDetailV12.cib003i.powerAttornyHold= respBean.powerAttornyHold;  
       requestBean.CIupdateClientDetailV12.cib003i.sbuSegment=  respBean.sbuSegment;  
      requestBean.CIupdateClientDetailV12.cib003i.casaRefNum= acc.CASA_Reference_Number__c;
      
       requestBean.CIupdateClientDetailV12.cib003i.noOfJointPartcpnt= respBean.noOfJointPartcpnt ; 
       requestBean.CIupdateClientDetailV12.cib003i.taxNumber = String.valueOf(acc.Income_Tax_Number__c);     
       requestBean.CIupdateClientDetailV12.cib003i.sicCode = translations.get(acc.Standard_Industry_SIC_Code__c+''+'CIF'+''+'Standard Industry SIC Code'+''+'Outbound'); 
       
       requestBean.CIupdateClientDetailV12.cib003i.insolventIndicator= respBean.insolventIndicator;  
       requestBean.CIupdateClientDetailV12.cib003i.companyYearEnd= translations.get(acc.Financial_Year_End__c+''+'CIF'+''+'Financial Year End'+''+'Outbound');
        
        if(acc.Phone != null){
            Integer workNumberSize = acc.Phone.length();
            requestBean.CIupdateClientDetailV12.cib003i.workTelCode = acc.Phone.Substring(0, 3);
            requestBean.CIupdateClientDetailV12.cib003i.workTelephone = acc.Phone.Substring(3, workNumberSize);
        }
        
       requestBean.CIupdateClientDetailV12.cib003i.physicalAddrHold = respBean.physicalAddrHold ; 
       requestBean.CIupdateClientDetailV12.cib003i.employerAddrHold = respBean.employerAddrHold;
       if(acc.PersonMobilePhone != null){
           String phoneNumber = acc.PersonMobilePhone;
           
           if(phoneNumber.length() > 10){
               //Take last 10 Digits
               Integer numberLength = phoneNumber.length();
               requestBean.CIupdateClientDetailV12.cib003i.cellphone = phoneNumber.Substring(numberLength - 10, numberLength);
               
           }else if(phoneNumber.length() < 10){
               //Add 0 infront until number is 10 digits
               while(phoneNumber.length() < 10){
                   phoneNumber = '0' + phoneNumber;
               }
               requestBean.CIupdateClientDetailV12.cib003i.cellphone = phoneNumber;
           }else{
               //Number is the correct length
               requestBean.CIupdateClientDetailV12.cib003i.cellphone = phoneNumber;
           }
       }
       
       requestBean.CIupdateClientDetailV12.cib003i.faxWorkCode= respBean.faxWorkCode;    
       requestBean.CIupdateClientDetailV12.cib003i.faxWorkNumber= respBean.faxWorkNumber;  
       requestBean.CIupdateClientDetailV12.cib003i.faxHomeCode= respBean.faxHomeCode;   
       requestBean.CIupdateClientDetailV12.cib003i.faxHomeNumber=respBean.faxHomeNumber;  
       requestBean.CIupdateClientDetailV12.cib003i.designation=  respBean.designation;  
       requestBean.CIupdateClientDetailV12.cib003i.emailAddress = acc.PersonEmail;
       requestBean.CIupdateClientDetailV12.cib003i.inliPolicy= respBean.inliPolicy;   
       requestBean.CIupdateClientDetailV12.cib003i.exliPolicy= respBean.exliPolicy;  
       requestBean.CIupdateClientDetailV12.cib003i.instPolicy= respBean.instPolicy;   
       requestBean.CIupdateClientDetailV12.cib003i.exstPolicy= respBean.exstPolicy;    
       requestBean.CIupdateClientDetailV12.cib003i.inivPolicy= respBean.inivPolicy;  
       requestBean.CIupdateClientDetailV12.cib003i.flexiFuneralPolicy= respBean.flexiFuneralPolicy;   
      
       requestBean.CIupdateClientDetailV12.cib003i.cellphoneBankInd=respBean.cellphoneBankInd;  
       requestBean.CIupdateClientDetailV12.cib003i.siccCode5= translations.get(acc.Standard_Industry_SIC_Code__c+''+'CIF'+''+'Standard Industry SIC Code'+''+'Outbound');
       requestBean.CIupdateClientDetailV12.cib003i.subSegment= respBean.subSegment; 
       requestBean.CIupdateClientDetailV12.cib003i.emailMarkInd=respBean.emailMarkInd; 
       requestBean.CIupdateClientDetailV12.cib003i.teleMarkInd=respBean.teleMarkInd;    
       requestBean.CIupdateClientDetailV12.cib003i.internetBankinInd=respBean.internetBankinInd; 

      String srcOfincomeTranslated;
        List<String> sourceOfincomelist = new List<String>(); 
          if(acc.Source_of_Income__c != null){
        	String[] sourceOfincomes = acc.Source_of_Income__c.split(';');
          	 
        	for(String srcOfincome:sourceOfincomes){
            	srcOfincomeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_SOURCE_OF_INCOME_STRING, srcOfincome, StringConstants.OUTBOUND_RECORD_TYPE);
            	sourceOfincomelist.add(srcOfincomeTranslated);
        	} 
          }else{
                srcOfincomeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_SOURCE_OF_INCOME_STRING, acc.Source_of_Income__pc, StringConstants.OUTBOUND_RECORD_TYPE);
          }
        
         if(sourceOfincomelist.size() > 0 && sourceOfincomelist != null){
         	requestBean.CIupdateClientDetailV12.cib003i.sourceOfIncome = sourceOfincomelist[0];
         }else{
            requestBean.CIupdateClientDetailV12.cib003i.sourceOfIncome =  srcOfincomeTranslated;
         }
       
    If(sourceOfincomelist.size() > 0 && sourceOfincomelist != null){
        requestBean.CIupdateClientDetailV12.cib003i.sourceOfIncome = sourceOfincomelist[0]; }
        requestBean.CIupdateClientDetailV12.cib003i.dateIdentified= respBean.dateIdentified;//String.valueOf(acc.Date_Identified__c).replace('-','');
        requestBean.CIupdateClientDetailV12.cib003i.dateVerified = respBean.dateVerified;//acc.Date_Verified__c != null ? String.valueOf(acc.Date_Verified__c).replace('-','') : string.valueOf(System.Today().format().replace('/',''));  
        requestBean.CIupdateClientDetailV12.cib003i.employeeIdentified  = employeeNumber;
        requestBean.CIupdateClientDetailV12.cib003i.employeeVerified   = employeeNumber;
      
        requestBean.CIupdateClientDetailV12.cib003i.dateExempted= requestBean.CIupdateClientDetailV12.cib003i.dateExempted; // defaulted <<>>>>
        requestBean.CIupdateClientDetailV12.cib003i.exemptionStatus= requestBean.CIupdateClientDetailV12.cib003i.exemptionStatus; //<<>>>>
        requestBean.CIupdateClientDetailV12.cib003i.exemptionIndicator=  requestBean.CIupdateClientDetailV12.cib003i.exemptionIndicator; 
        requestBean.CIupdateClientDetailV12.cib003i.corporateDivision= requestBean.CIupdateClientDetailV12.cib003i.corporateDivision; // defaulted
        requestBean.CIupdateClientDetailV12.cib003i.haveQualification= requestBean.CIupdateClientDetailV12.cib003i.haveQualification; //<<>>>>>
        requestBean.CIupdateClientDetailV12.cib003i.whatQualification= requestBean.CIupdateClientDetailV12.cib003i.whatQualification;  //<<>>>>
        requestBean.CIupdateClientDetailV12.cib003i.socialGrant= requestBean.CIupdateClientDetailV12.cib003i.socialGrant;  //defaulted <<<<>>>>
        requestBean.CIupdateClientDetailV12.cib003i.notificationInd= requestBean.CIupdateClientDetailV12.cib003i.notificationInd; //<<>>>
        requestBean.CIupdateClientDetailV12.cib003i.mailInd= requestBean.CIupdateClientDetailV12.cib003i.mailInd; // defaulted
        requestBean.CIupdateClientDetailV12.cib003i.applyDebtCounsel= requestBean.CIupdateClientDetailV12.cib003i.applyDebtCounsel; 
        requestBean.CIupdateClientDetailV12.cib003i.dteApplyCounsel= requestBean.CIupdateClientDetailV12.cib003i.dteApplyCounsel;  
        requestBean.CIupdateClientDetailV12.cib003i.counselOrderIssue= requestBean.CIupdateClientDetailV12.cib003i.counselOrderIssue;
        requestBean.CIupdateClientDetailV12.cib003i.dteOrderIssue= requestBean.CIupdateClientDetailV12.cib003i.dteOrderIssue; 
        requestBean.CIupdateClientDetailV12.cib003i.groupScheme= requestBean.CIupdateClientDetailV12.cib003i.groupScheme; 
        requestBean.CIupdateClientDetailV12.cib003i.secondaryCard= requestBean.CIupdateClientDetailV12.cib003i.secondaryCard; 
      //  requestBean.CIupdateClientDetailV12.cib003i.affectedPerson = translations.get(String.valueOf(accountList[0].Q4a_Client_affected_by_Regulation_3_1_F__c)+''+'CIF'+''+'Affected Person'+''+'Outbound');		
    
         
        requestBean.CIupdateClientDetailV12.cib003i.ibrAffected= respBean.ibrAffected; 
       // requestBean.CIupdateClientDetailV12.cib003i.clientGroup= respBean.clientGroup; 
        requestBean.CIupdateClientDetailV12.cib003i.employerAddrSeqNbr= requestBean.CIupdateClientDetailV12.cib003i.employerAddrSeqNbr;
        requestBean.CIupdateClientDetailV12.cib003i.physicalAddrType= '0';
        requestBean.CIupdateClientDetailV12.cib003i.physicalAddrSeqNbr='0'; //defaulted 
        requestBean.CIupdateClientDetailV12.cib003i.physicalPostal= addressMap.get(StringConstants.PHYSICAL_ADDR_STRING+''+'Zip');
        requestBean.CIupdateClientDetailV12.cib003i.businessAddrType= '20';
        requestBean.CIupdateClientDetailV12.cib003i.businessAddrSeqNbr= '0'; // from get
        requestBean.CIupdateClientDetailV12.cib003i.businessPostal= addressMap.get(StringConstants.BUSINESS_ADDR_STRING+''+'Zip'); //this
        
        requestBean.CIupdateClientDetailV12.cib003i.employerAdd1 = addressMap.get(StringConstants.EMPLOYER_ADDR_STRING+''+'Street');
        requestBean.CIupdateClientDetailV12.cib003i.employerAdd2 = addressMap.get(StringConstants.EMPLOYER_ADDR_STRING+''+'Street2');
        requestBean.CIupdateClientDetailV12.cib003i.employerSuburb = addressMap.get(StringConstants.EMPLOYER_ADDR_STRING+''+'Suburb');
        requestBean.CIupdateClientDetailV12.cib003i.employerTown= addressMap.get(StringConstants.EMPLOYER_ADDR_STRING+''+'City');
        requestBean.CIupdateClientDetailV12.cib003i.employerPostal = addressMap.get(StringConstants.EMPLOYER_ADDR_STRING+''+'Zip');
        
        
        requestBean.CIupdateClientDetailV12.cib003i.physicalAdd1 = addressMap.get(StringConstants.PHYSICAL_ADDR_STRING+''+'Street');
        requestBean.CIupdateClientDetailV12.cib003i.physicalAdd2 = addressMap.get(StringConstants.PHYSICAL_ADDR_STRING+''+'Street2');
        requestBean.CIupdateClientDetailV12.cib003i.physicalSuburb = addressMap.get(StringConstants.PHYSICAL_ADDR_STRING+''+'Suburb');
        requestBean.CIupdateClientDetailV12.cib003i.physicalTown = addressMap.get(StringConstants.PHYSICAL_ADDR_STRING+''+'City');
        requestBean.CIupdateClientDetailV12.cib003i.physicalPostal = addressMap.get(StringConstants.PHYSICAL_ADDR_STRING+''+'Zip');
        
        requestBean.CIupdateClientDetailV12.cib003i.businessAdd1 = addressMap.get(StringConstants.BUSINESS_ADDR_STRING+''+'Street');
        requestBean.CIupdateClientDetailV12.cib003i.businessAdd2 = addressMap.get(StringConstants.BUSINESS_ADDR_STRING+''+'Street2');
        requestBean.CIupdateClientDetailV12.cib003i.businessSuburb = addressMap.get(StringConstants.BUSINESS_ADDR_STRING+''+'Suburb');
        requestBean.CIupdateClientDetailV12.cib003i.businessTown = addressMap.get(StringConstants.BUSINESS_ADDR_STRING+''+'City');
        requestBean.CIupdateClientDetailV12.cib003i.businessPostal = addressMap.get(StringConstants.BUSINESS_ADDR_STRING+''+'Zip');
        
        
       
        requestBean.CIupdateClientDetailV12.cib003i.postlAddrLine1 = addressMap.get(StringConstants.POSTAL_STRING+''+'Street');
        requestBean.CIupdateClientDetailV12.cib003i.postlAddrLine2 = addressMap.get(StringConstants.POSTAL_STRING+''+'Street2');
        requestBean.CIupdateClientDetailV12.cib003i.postlSuburb = addressMap.get(StringConstants.POSTAL_STRING+''+'Suburb');
        requestBean.CIupdateClientDetailV12.cib003i.postlTown = addressMap.get(StringConstants.POSTAL_STRING+''+'City');
        requestBean.CIupdateClientDetailV12.cib003i.postlCodeRsa = addressMap.get(StringConstants.POSTAL_STRING+''+'Zip');
        
        
        requestBean.CIupdateClientDetailV12.cib003i.hoAddrLine1 = addressMap.get(StringConstants.HEAD_OFFICE_ADDR_STRING+''+'Street');
         requestBean.CIupdateClientDetailV12.cib003i.hoAddrLine2 = addressMap.get(StringConstants.HEAD_OFFICE_ADDR_STRING+''+'Street2');
         requestBean.CIupdateClientDetailV12.cib003i.hoSuburb = addressMap.get(StringConstants.HEAD_OFFICE_ADDR_STRING+''+'Suburb');
         requestBean.CIupdateClientDetailV12.cib003i.hoTown = addressMap.get(StringConstants.HEAD_OFFICE_ADDR_STRING+''+'City');
         requestBean.CIupdateClientDetailV12.cib003i.hoCodeRsa = addressMap.get(StringConstants.HEAD_OFFICE_ADDR_STRING+''+'Zip');
         
        
         requestBean.CIupdateClientDetailV12.cib003i.regAddrLine1 = addressMap.get(StringConstants.REGISTERED_ADDR_STRING+''+'Street');
         requestBean.CIupdateClientDetailV12.cib003i.regAddrLine2 = addressMap.get(StringConstants.REGISTERED_ADDR_STRING+''+'Street2');
         requestBean.CIupdateClientDetailV12.cib003i.regSuburb = addressMap.get(StringConstants.REGISTERED_ADDR_STRING+''+'Suburb');
         requestBean.CIupdateClientDetailV12.cib003i.regTown = addressMap.get(StringConstants.REGISTERED_ADDR_STRING+''+'City');
         requestBean.CIupdateClientDetailV12.cib003i.regCodeRsa = addressMap.get(StringConstants.REGISTERED_ADDR_STRING+''+'Zip');
 
       
        
        String SICClassification1Translated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'SIC Classification',acc.SIC_Classification_1__c, StringConstants.OUTBOUND_RECORD_TYPE);
        String SICClassification2Translated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'SIC Classification',acc.SIC_Classification_2__c, StringConstants.OUTBOUND_RECORD_TYPE);
        String SICClassification3Translated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'SIC Classification',acc.SIC_Classification_3__c, StringConstants.OUTBOUND_RECORD_TYPE);
       
        List<ciupdateclientdetailV12_Req_IB_v1.agriData> agriDatalist = new List<ciupdateclientdetailV12_Req_IB_v1.agriData>();
        if(SICClassification1Translated != null){
           ciupdateclientdetailV12_Req_IB_v1.agriData AgriData1 = new ciupdateclientdetailV12_Req_IB_v1.agriData();
            AgriData1.agriClass = SICClassification1Translated;
            if(acc.SIC_Classification_1_Percentage__c!=null){
                AgriData1.percentage = String.ValueOf(acc.SIC_Classification_1_Percentage__c);
            }
            agriDatalist.add(AgriData1);
        }
        if(SICClassification2Translated != null){
            ciupdateclientdetailV12_Req_IB_v1.agriData AgriData2 = new ciupdateclientdetailV12_Req_IB_v1.agriData();
            AgriData2.agriClass = SICClassification2Translated;
            if(acc.SIC_Classification_2_Percentage__c!=null){
                AgriData2.percentage = String.ValueOf(acc.SIC_Classification_2_Percentage__c);
            }
            agriDatalist.add(AgriData2);
        }
        if(SICClassification3Translated != null){
            ciupdateclientdetailV12_Req_IB_v1.agriData AgriData3 = new ciupdateclientdetailV12_Req_IB_v1.agriData();
            AgriData3.agriClass = SICClassification3Translated;
            if(acc.SIC_Classification_3_Percentage__c!=null){
                AgriData3.percentage =String.ValueOf(acc.SIC_Classification_3_Percentage__c);
            }
            agriDatalist.add(AgriData3);
        }
        
        If(SICClassification1Translated == null && SICClassification2Translated == null && SICClassification3Translated == null){
          for(integer i = 0; i < 3; i ++) {
        
            ciupdateclientdetailV12_Req_IB_v1.agriData AgriData3 = new ciupdateclientdetailV12_Req_IB_v1.agriData();
            AgriData3.agriClass = '';
            AgriData3.percentage = '0';
              agriDatalist.add(AgriData3); }}

        requestBean.CIupdateClientDetailV12.cib003i.agriData = agriDatalist;
        requestBean.CIupdateClientDetailV12.cib003i.permitExpDte= respBean.permitExpDte;  
        requestBean.CIupdateClientDetailV12.cib003i.placedBy= respBean.placedBy;       
        requestBean.CIupdateClientDetailV12.cib003i.dateBusRescueIss= respBean.dateBusRescueIss;       
        requestBean.CIupdateClientDetailV12.cib003i.contOride= requestBean.CIupdateClientDetailV12.cib003i.contOride;        
        requestBean.CIupdateClientDetailV12.cib003i.updAddressInd=respBean.updAddressInd; 
        requestBean.CIupdateClientDetailV12.cib003i.updTelephoneInd=respBean.updTelephoneInd;   
        requestBean.CIupdateClientDetailV12.cib003i.updEmailInd= respBean.updEmailInd;  
        requestBean.CIupdateClientDetailV12.cib003i.updDateInd= respBean.updDateInd;       
       requestBean.CIupdateClientDetailV12.cib003i.pingitWallet= respBean.pingitWallet;   
       requestBean.CIupdateClientDetailV12.cib003i.pingitReceive= respBean.pingitReceive;  
         requestBean.CIupdateClientDetailV12.cib003i.vatRegistrationNo = String.valueOf(acc.VAT_Registration_Number__c);
         requestBean.CIupdateClientDetailV12.cib003i.groupSchemeEmp = respBean.groupSchemeEmp;
         requestBean.CIupdateClientDetailV12.cib003i.subClassCde = respBean.subClassCde;
         requestBean.CIupdateClientDetailV12.cib003i.countryIncorp = translations.get(acc.Country_of_Incorporation__c+''+'CIF'+''+'Country'+''+'Outbound');
         requestBean.CIupdateClientDetailV12.cib003i.inBusinessRescue =respBean.inBusinessRescue;
         requestBean.CIupdateClientDetailV12.cib003i.ncaThreshold =  Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Boolean Value', String.valueOf(acc.Does_the_Client_fall_under_the_NCA__c), StringConstants.OUTBOUND_RECORD_TYPE);
         requestBean.CIupdateClientDetailV12.cib003i.cpaThreshold = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Boolean Value', String.valueOf(acc.Does_the_Client_fall_under_the_CPA__c), StringConstants.OUTBOUND_RECORD_TYPE);
         
         
          requestBean.CIupdateClientDetailV12.cib003i.clntAgrmntIssued =respBean.clntAgrmntIssued;
          requestBean.CIupdateClientDetailV12.cib003i.sec129DeliveryAddr= translations.get(acc.Preferred_delivery_method_Legal_Notices__c+''+'CIF'+''+'Section 129 Delivery'+''+'Outbound');
          requestBean.CIupdateClientDetailV12.cib003i.rsonSaTaxNotGiven = translations.get(acc.Reason_For_Not_Providing_SA_Tax_Number__c+''+'CIF'+''+'Reason Tax Not Given'+''+'Outbound');
          requestBean.CIupdateClientDetailV12.cib003i.foreignTaxRegis = acc.Foreign_Tax_Number__c != Null? 'Y': 'N';
        
       
       String[] countryEntoprt = new String[]{};
           if(acc.Country_of_Operation__c != null && acc.Country_of_Operation__c !=''){
               countryEntoprt = acc.Country_of_Operation__c.split(';');
           }
       List<ciupdateclientdetailV12_Req_IB_v1.CountryEntOprtData> countryEntoprtlist = new List<ciupdateclientdetailV12_Req_IB_v1.CountryEntOprtData>();
       
       for(String countryofopt:countryEntoprt){
           ciupdateclientdetailV12_Req_IB_v1.CountryEntOprtData tempcountryEntoprt = new ciupdateclientdetailV12_Req_IB_v1.CountryEntOprtData();
           String countryOfOperationTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country',acc.Country_of_Operation__c, StringConstants.OUTBOUND_RECORD_TYPE);
           if(countryOfOperationTranslated != null) {
               tempcountryEntoprt.countryEntOprt = countryOfOperationTranslated;
                countryEntoprtlist.add(tempcountryEntoprt);
           }
          // countryEntoprtlist.add(countryOfOperationTranslated);
       }
         
          requestBean.CIupdateClientDetailV12.cib003i.countryEntOprtData = countryEntoprtlist;
         List<ciupdateclientdetailV12_Req_IB_v1.ForeignTaxData> ForeignTaxlist = new List<ciupdateclientdetailV12_Req_IB_v1.ForeignTaxData>();
          if(acc.Foreign_Tax_Number__c!=null){
           ciupdateclientdetailV12_Req_IB_v1.ForeignTaxData tempForeignTaxData = new ciupdateclientdetailV12_Req_IB_v1.ForeignTaxData();
           tempForeignTaxData.foreignTaxNo = String.valueOf(acc.Foreign_Tax_Number__c);
           if(acc.Country_of_Foreign_tax__c!=null){
               tempForeignTaxData.foreignTaxCtry = translations.get(acc.Country_of_Foreign_tax__c+''+'CIF'+''+'Country'+''+'Outbound');
           }
           requestBean.CIupdateClientDetailV12.cib003i.foreignTaxRegis ='Y';   
           ForeignTaxlist.add(tempForeignTaxData);
       }
         
         If(ForeignTaxlist.size()>0 && ForeignTaxlist != null){
            requestBean.CIupdateClientDetailV12.cib003i.foreignTaxData = ForeignTaxlist;}
         else{
           requestBean.CIupdateClientDetailV12.cib003i.foreignTaxRegis ='N';
       }
        
           if(!acrList.isEmpty()){
          
           for(AccountContactRelation accconRel : acrList){
              
               if((accconRel.Roles).contains(';')){
                   
                   for(String roleValue : (accconRel.Roles).split(';')){
                       if(roleValue != 'Contact person'){
                           
                           requestBean.CIupdateClientDetailV12.Cib003i.contactPerson= accconRel.Contact.Name;
                           requestBean.CIupdateClientDetailV12.Cib003i.emailAddress= accconRel.Contact.Email;
                           requestBean.CIupdateClientDetailV12.Cib003i.Cellphone = accconRel.Contact.MobilePhone;
                           
                           if(accconRel.Contact.Phone != null){
                               Integer workNumberSize = accconRel.Contact.Phone.length();
                               requestBean.CIupdateClientDetailV12.Cib003i.workTelCode = accconRel.Contact.Phone.Substring(0, 3);
                               requestBean.CIupdateClientDetailV12.Cib003i.workTelephone = accconRel.Contact.Phone.Substring(3, workNumberSize);
                           }
                           
                          
                           requestBean.CIupdateClientDetailV12.Cib003i.designation = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Designation', accconRel.Designation__c, StringConstants.OUTBOUND_RECORD_TYPE);                        }
                   }
               }/*else{
                   requestBean.CIcreateClientV12.Cib003i.contactPerson= accconRel.Contact.Name;
                   requestBean.CIcreateClientV12.Cib003i.emailAddress= accconRel.Contact.Email;
                   requestBean.CIcreateClientV12.Cib003i.Cellphone = accconRel.Contact.MobilePhone;
                   }*/
               //requestBean.CIcreateClientV12.Cib003i.designation = acrList[0].Roles;
           }
       }
        
        
                 if(acc.Is_Marketing_Consent_Phone__c!=null && acc.Is_Marketing_Consent_Phone__c==true){
           requestBean.CIupdateClientDetailV12.Cib003i.nCRTel='Y';
       }else if(acc.Is_Marketing_Consent_Phone__c!=null && acc.Is_Marketing_Consent_Phone__c==false){
           requestBean.CIupdateClientDetailV12.Cib003i.nCRTel='N';
       }
       if(acc.Is_Marketing_Consent_Email__c!=null && acc.Is_Marketing_Consent_Email__c==true){
           requestBean.CIupdateClientDetailV12.Cib003i.nCREmail='Y';
       }else if(acc.Is_Marketing_Consent_Email__c!=null && acc.Is_Marketing_Consent_Email__c==false){
           requestBean.CIupdateClientDetailV12.Cib003i.nCREmail='N';
       }
       if(acc.Is_Marketing_Consent_SMS__c!=null && acc.Is_Marketing_Consent_SMS__c==true){
           requestBean.CIupdateClientDetailV12.Cib003i.nCRSMS='Y';
       }else if(acc.Is_Marketing_Consent_SMS__c!=null && acc.Is_Marketing_Consent_SMS__c==false){
           requestBean.CIupdateClientDetailV12.Cib003i.nCRSMS='N';
       }
       if(acc.Is_Marketing_Consent_Post__c!=null && acc.Is_Marketing_Consent_Post__c==true){
           requestBean.CIupdateClientDetailV12.Cib003i.nCRPost='Y';
       }else if(acc.Is_Marketing_Consent_Post__c!=null && acc.Is_Marketing_Consent_Post__c==false){
           requestBean.CIupdateClientDetailV12.Cib003i.nCRPost='N';
       }
        if(acc.Is_Marketing_Consent_voice_rec__c!=null && acc.Is_Marketing_Consent_voice_rec__c==true){
           requestBean.CIupdateClientDetailV12.Cib003i.ncrAvoice='Y';
       }else if(acc.Is_Marketing_Consent_voice_rec__c!=null && acc.Is_Marketing_Consent_voice_rec__c==false){
           requestBean.CIupdateClientDetailV12.Cib003i.ncrAvoice='N';
       }
       if(acc.Is_Marketing_Consent_Phone__c==true || acc.Is_Marketing_Consent_Email__c==true || acc.Is_Marketing_Consent_SMS__c==true ||
          acc.Is_Marketing_Consent_Post__c==true ||   acc.Is_Marketing_Consent_voice_rec__c==true){
              requestBean.CIupdateClientDetailV12.Cib003i.nCRInd='Y'; 
          }else{
              requestBean.CIupdateClientDetailV12.Cib003i.nCRInd='N'; 
          }
        
        
   
     return requestBean;
    }
   
      
        /**
        * @description  Calling the CIF GET to Get the Mapping
        * @author Monde Masiza | 2021-07-15 
        * @param clientCodeP 
        * @param accNumberP 
        * @param siteCodeP 
        * @return GetClientDetails_Resp_IB_v1 
        **/
        public static GetClientDetails_Resp_IB_v1 getClientDetails(String clientCodeP, String accNumberP, String siteCodeP){
       
       GetClientDetails_Resp_IB_v1 getClientDetailsResponse;
       Sys_Log_Integration__c log;
       
       try{
           //Query Objects
           Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.GET_CLIENT_DETAILS);
           
           if(integrationSettings != null){
               //Map Request Fields
               GetClientDetails_Req_IB_v1 getClientDetailsRequest = GetClientDetails_IU_v1.mapRequestFields(clientCodeP, accNumberP, siteCodeP);
               
               String jsonString = getClientDetailsRequest.serialize( getClientDetailsRequest );
               
               //Send Request
               HttpResponse response = Sys_Utilities_Integration.serviceCallout(Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString));
               
               ///Map Response Fields
               getClientDetailsResponse = GetClientDetails_IU_v1.mapResponseFields(response);
               
             
                     string json = response.getBody();
            
             //  Map<String, String> values = (Map<String, String>)JSON.
               
              
          
               
           }else{
               //No Integration Settings Found
               String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.GET_CLIENT_DETAILS + '. Environment: ' + Sys_Utilities_General.getEnvironment();
               log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_GET_CLIENT_DETAILS, StringConstants.CIF_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
               getClientDetailsResponse = GetClientDetails_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
           }
           
       }catch(Exception e){
           //Map bad response and create a log
           String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
           log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_GET_CLIENT_DETAILS, StringConstants.CIF_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
           getClientDetailsResponse = GetClientDetails_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
       }
      
       return getClientDetailsResponse;
   }
   
   
    /**
    * @description map Response Fields
    * @author Monde Masiza | 2021-07-15 
    * @param respP 
    * @return ciupdateclientdetailV12_Resp_IB_v1 
    **/
    public static ciupdateclientdetailV12_Resp_IB_v1 mapResponseFields(HttpResponse respP){
       
       ciupdateclientdetailV12_Resp_IB_v1 responseBean = (ciupdateclientdetailV12_Resp_IB_v1)JSON.deserialize( respP.getBody(), ciupdateclientdetailV12_Resp_IB_v1.class);
       responseBean.Status = respP.getStatus();
       responseBean.statusCode = respP.getStatusCode();
       
       return responseBean;
   }
       /** END **/

   /**
   * @description TdB SuretOnboarding for all types on Customer Entities
   * @author Monde Masiza | 2021-07-15 
   * @param acc 
   * @param addressList 
   * @param siteCode 
   * @param getClientRespBean 
   * @return ciupdateclientdetailV12_Req_IB_v1 
   **/
   public static ciupdateclientdetailV12_Req_IB_v1 updateClientDetailsSurety(Account acc, List<Address__c> addressList, String siteCode, GetClientDetailsCIF_Resp_IB_v1 getClientRespBean){  
       ciupdateclientdetailV12_Req_IB_v1 requestBean = new ciupdateclientdetailV12_Req_IB_v1();
       requestBean.CIupdateClientDetailV12 = new ciupdateclientdetailV12_Req_IB_v1.CIupdateClientDetailV12();
       requestBean.CIupdateClientDetailV12.cib003i = new ciupdateclientdetailV12_Req_IB_v1.Cib004i();
       
       requestBean.CIupdateClientDetailV12.cib003i.clientCode= getClientRespBean.clientCode;
       requestBean.CIupdateClientDetailV12.cib003i.initials= getClientRespBean.initials;         
       requestBean.CIupdateClientDetailV12.cib003i.language= getClientRespBean.language;
       requestBean.CIupdateClientDetailV12.cib003i.titleCode= getClientRespBean.titleCode;
       requestBean.CIupdateClientDetailV12.cib003i.surname= getClientRespBean.surname;
       requestBean.CIupdateClientDetailV12.cib003i.postlAddrLine1= getClientRespBean.postlAddrLine1;
       requestBean.CIupdateClientDetailV12.cib003i.postlAddrLine2= getClientRespBean.postlAddrLine2;
       requestBean.CIupdateClientDetailV12.cib003i.postlSuburb= getClientRespBean.postlSuburb;
       requestBean.CIupdateClientDetailV12.cib003i.postlTown= getClientRespBean.postlTown;
       requestBean.CIupdateClientDetailV12.cib003i.postlCodeRsa= getClientRespBean.postlCodeRsa;
       requestBean.CIupdateClientDetailV12.cib003i.idDocType= getClientRespBean.idDocType;
       requestBean.CIupdateClientDetailV12.cib003i.idNumber= getClientRespBean.idNumber;
       requestBean.CIupdateClientDetailV12.cib003i.birthDate= getClientRespBean.birthDate;
       requestBean.CIupdateClientDetailV12.cib003i.maritalStatus= getClientRespBean.maritalStatus;
       requestBean.CIupdateClientDetailV12.cib003i.smsMarketInd= 'N';
       requestBean.CIupdateClientDetailV12.cib003i.gender= getClientRespBean.gender;
       requestBean.CIupdateClientDetailV12.cib003i.minorChildren= getClientRespBean.minorChildren;
       requestBean.CIupdateClientDetailV12.cib003i.occupationCode= getClientRespBean.occupationCode;
       requestBean.CIupdateClientDetailV12.cib003i.incomeGroup= getClientRespBean.incomeGroup;
       requestBean.CIupdateClientDetailV12.cib003i.bankingSector= getClientRespBean.bankingSector;
       requestBean.CIupdateClientDetailV12.cib003i.securityIndicator= getClientRespBean.securityIndicator;
       requestBean.CIupdateClientDetailV12.cib003i.liabilityIndicator= 'Y';
       requestBean.CIupdateClientDetailV12.cib003i.telebankIndicator= getClientRespBean.telebankIndicator;
       requestBean.CIupdateClientDetailV12.cib003i.unclaimedFundsInd= getClientRespBean.unclaimedFundsInd;
       requestBean.CIupdateClientDetailV12.cib003i.branchClientOpen= siteCode;
       requestBean.CIupdateClientDetailV12.cib003i.dateClientOpened= getClientRespBean.dateClientOpened;
       requestBean.CIupdateClientDetailV12.cib003i.changeNumber= getClientRespBean.changeNumber;
       requestBean.CIupdateClientDetailV12.cib003i.dateLastChanged= getClientRespBean.dateLastChanged;
       requestBean.CIupdateClientDetailV12.cib003i.siteLastChanged= getClientRespBean.siteLastChanged;
       requestBean.CIupdateClientDetailV12.cib003i.tellerLastChanged= getClientRespBean.tellerLastChanged;
       requestBean.CIupdateClientDetailV12.cib003i.nbrOfAccounts= getClientRespBean.nbrOfAccounts;
       requestBean.CIupdateClientDetailV12.cib003i.prohibitedInd= getClientRespBean.prohibitedInd;
       requestBean.CIupdateClientDetailV12.cib003i.postalAddrHold= getClientRespBean.postalAddrHold;
       //requestBean.CIupdateClientDetailV12.cib003i.absaRewardInd= getClientRespBean.absaRewardInd;
       requestBean.CIupdateClientDetailV12.cib003i.idRequiredHold= getClientRespBean.idRequiredHold;
       requestBean.CIupdateClientDetailV12.cib003i.deceasedEstateHld= getClientRespBean.deceasedEstateHld;
       requestBean.CIupdateClientDetailV12.cib003i.deceasedSpouseHld= getClientRespBean.deceasedSpouseHld;
       requestBean.CIupdateClientDetailV12.cib003i.insolvntEstateHld= getClientRespBean.insolvntEstateHld;
       requestBean.CIupdateClientDetailV12.cib003i.curatorshipHold= getClientRespBean.curatorshipHold;
       requestBean.CIupdateClientDetailV12.cib003i.savngStatementHold= getClientRespBean.savngStatementHold;
       requestBean.CIupdateClientDetailV12.cib003i.courtAuthrityHold= getClientRespBean.courtAuthrityHold;
       requestBean.CIupdateClientDetailV12.cib003i.thirdPartyInd= getClientRespBean.thirdPartyInd;
       requestBean.CIupdateClientDetailV12.cib003i.mandateCaptureHld= getClientRespBean.mandateCaptureHld;
       requestBean.CIupdateClientDetailV12.cib003i.powerAttornyHold= getClientRespBean.powerAttornyHold;
       requestBean.CIupdateClientDetailV12.cib003i.sbuSegment= getClientRespBean.sbuSegment;
       requestBean.CIupdateClientDetailV12.cib003i.mariageContrctType= getClientRespBean.mariageContrctType;
       requestBean.CIupdateClientDetailV12.cib003i.homeLanguage= getClientRespBean.homeLanguage;
       requestBean.CIupdateClientDetailV12.cib003i.marketingConcent= getClientRespBean.marketingConcent;
       requestBean.CIupdateClientDetailV12.cib003i.clientType= getClientRespBean.clientType;
       requestBean.CIupdateClientDetailV12.cib003i.miltaryComtmntInd= getClientRespBean.miltaryComtmntInd;
       requestBean.CIupdateClientDetailV12.cib003i.occupancyType= getClientRespBean.occupationType;
       requestBean.CIupdateClientDetailV12.cib003i.noOfJointPartcpnt= getClientRespBean.noOfJointPartcpnt;
       requestBean.CIupdateClientDetailV12.cib003i.taxNumber= getClientRespBean.taxNumber;
       requestBean.CIupdateClientDetailV12.cib003i.sicCode= getClientRespBean.sicCode;
       requestBean.CIupdateClientDetailV12.cib003i.firstNames= getClientRespBean.firstNames;
       requestBean.CIupdateClientDetailV12.cib003i.insolventIndicator= getClientRespBean.insolventIndicator;
       requestBean.CIupdateClientDetailV12.cib003i.companyYearEnd= getClientRespBean.companyYearEnd;
       requestBean.CIupdateClientDetailV12.cib003i.homeTelCode= getClientRespBean.homeTelCode;
       requestBean.CIupdateClientDetailV12.cib003i.homeTelephone= getClientRespBean.homeTelephone;
       requestBean.CIupdateClientDetailV12.cib003i.workTelCode= getClientRespBean.workTelCode;
       requestBean.CIupdateClientDetailV12.cib003i.workTelephone= getClientRespBean.workTelephone;
       requestBean.CIupdateClientDetailV12.cib003i.physicalAddrHold= getClientRespBean.physicalAddrHold;
       requestBean.CIupdateClientDetailV12.cib003i.employerAddrHold= getClientRespBean.employerAddrHold;
       requestBean.CIupdateClientDetailV12.cib003i.cellphone= getClientRespBean.cellphone;
       requestBean.CIupdateClientDetailV12.cib003i.faxWorkCode= getClientRespBean.faxWorkCode;
       requestBean.CIupdateClientDetailV12.cib003i.faxWorkNumber= getClientRespBean.faxWorkNumber;
       requestBean.CIupdateClientDetailV12.cib003i.faxHomeCode= getClientRespBean.faxHomeCode;
       requestBean.CIupdateClientDetailV12.cib003i.faxHomeNumber= getClientRespBean.faxHomeNumber;
       requestBean.CIupdateClientDetailV12.cib003i.occupationStatus= getClientRespBean.occupationStatus;
       requestBean.CIupdateClientDetailV12.cib003i.employmentSector= getClientRespBean.employmentSector;
       requestBean.CIupdateClientDetailV12.cib003i.occupationLevel= getClientRespBean.occupationLevel;
       requestBean.CIupdateClientDetailV12.cib003i.practiceNumber= getClientRespBean.practiceNumber;
       requestBean.CIupdateClientDetailV12.cib003i.clientWebsite= getClientRespBean.clientWebsite;
       requestBean.CIupdateClientDetailV12.cib003i.contactPerson= getClientRespBean.contactPerson;
       requestBean.CIupdateClientDetailV12.cib003i.designation= getClientRespBean.designation;
       requestBean.CIupdateClientDetailV12.cib003i.emailAddress= getClientRespBean.emailAddress;
       requestBean.CIupdateClientDetailV12.cib003i.inliPolicy= getClientRespBean.inliPolicy;
       requestBean.CIupdateClientDetailV12.cib003i.exliPolicy= getClientRespBean.exliPolicy;
       requestBean.CIupdateClientDetailV12.cib003i.instPolicy= getClientRespBean.instPolicy;
       requestBean.CIupdateClientDetailV12.cib003i.exstPolicy= getClientRespBean.exstPolicy;
       requestBean.CIupdateClientDetailV12.cib003i.inivPolicy= getClientRespBean.inivPolicy;
       requestBean.CIupdateClientDetailV12.cib003i.flexiFuneralPolicy= getClientRespBean.flexiFuneralPolicy;
       requestBean.CIupdateClientDetailV12.cib003i.prefrdCommtionMthd= getClientRespBean.prefrdCommtionMthd;
       requestBean.CIupdateClientDetailV12.cib003i.cellphoneBankInd= getClientRespBean.cellphoneBankInd;
       requestBean.CIupdateClientDetailV12.cib003i.siccCode5= getClientRespBean.siccCode5;
       requestBean.CIupdateClientDetailV12.cib003i.subSegment= getClientRespBean.subSegment;
       requestBean.CIupdateClientDetailV12.cib003i.emailMarkInd= getClientRespBean.emailMarkInd;
       requestBean.CIupdateClientDetailV12.cib003i.teleMarkInd= getClientRespBean.teleMarkInd;
       requestBean.CIupdateClientDetailV12.cib003i.internetBankinInd= getClientRespBean.internetBankinInd;
       requestBean.CIupdateClientDetailV12.cib003i.sourceOfIncome= getClientRespBean.sourceOfIncome;
       requestBean.CIupdateClientDetailV12.cib003i.dateIdentified= getClientRespBean.dateIdentified;
       requestBean.CIupdateClientDetailV12.cib003i.dateVerified= getClientRespBean.dateVerified;
       requestBean.CIupdateClientDetailV12.cib003i.employeeIdentified= getClientRespBean.employeeIdentified;
       requestBean.CIupdateClientDetailV12.cib003i.employeeVerified= getClientRespBean.employeeVerified;
       requestBean.CIupdateClientDetailV12.cib003i.vatRegistrationNo= getClientRespBean.vatRegistrationNo;
       requestBean.CIupdateClientDetailV12.cib003i.clientNationality= getClientRespBean.clientNationality;
       requestBean.CIupdateClientDetailV12.cib003i.countryOfOrigin= getClientRespBean.countryOfOrigin;
       requestBean.CIupdateClientDetailV12.cib003i.dateExempted= getClientRespBean.dateExempted;
       //requestBean.CIupdateClientDetailV12.cib003i.employeeExempted= getClientRespBean.employeeExempted;
       requestBean.CIupdateClientDetailV12.cib003i.exemptionStatus= getClientRespBean.statusOfExemption;
       requestBean.CIupdateClientDetailV12.cib003i.exemptionIndicator= getClientRespBean.exemptionIndicator;
       requestBean.CIupdateClientDetailV12.cib003i.corporateDivision= getClientRespBean.corporateDivision;
       requestBean.CIupdateClientDetailV12.cib003i.haveQualification= getClientRespBean.postMatricQualifd;
       requestBean.CIupdateClientDetailV12.cib003i.whatQualification= getClientRespBean.postMatricQualfton;
       requestBean.CIupdateClientDetailV12.cib003i.socialGrant= getClientRespBean.receiveSocialGrant;
       requestBean.CIupdateClientDetailV12.cib003i.notificationInd= getClientRespBean.notifyMeIndicator;
       requestBean.CIupdateClientDetailV12.cib003i.mailInd= getClientRespBean.mailInd;
       requestBean.CIupdateClientDetailV12.cib003i.applyDebtCounsel= getClientRespBean.applyDebtCounsel;
       requestBean.CIupdateClientDetailV12.cib003i.dteApplyCounsel= getClientRespBean.dteApplyCounsel;
       requestBean.CIupdateClientDetailV12.cib003i.counselOrderIssue= getClientRespBean.counselOrderIssue;
       requestBean.CIupdateClientDetailV12.cib003i.dteOrderIssue= getClientRespBean.dteOrderIssue;
       requestBean.CIupdateClientDetailV12.cib003i.groupScheme= getClientRespBean.groupScheme;
       requestBean.CIupdateClientDetailV12.cib003i.groupSchemeEmp= getClientRespBean.groupSchemeEmp;
       requestBean.CIupdateClientDetailV12.cib003i.secondaryCard= getClientRespBean.secondaryCard;
       requestBean.CIupdateClientDetailV12.cib003i.affectedPerson= getClientRespBean.affectedPerson;
       requestBean.CIupdateClientDetailV12.cib003i.exconExpiryDate= getClientRespBean.exconExpiryDate;
       requestBean.CIupdateClientDetailV12.cib003i.dateIssued= getClientRespBean.dateIssued;
       requestBean.CIupdateClientDetailV12.cib003i.ibrAffected= getClientRespBean.ibrAffected;
       requestBean.CIupdateClientDetailV12.cib003i.employerAddrType= getClientRespBean.employerAddrType;
       requestBean.CIupdateClientDetailV12.cib003i.employerAddrSeqNbr= requestBean.CIupdateClientDetailV12.cib003i.employerAddrSeqNbr;
       requestBean.CIupdateClientDetailV12.cib003i.employerAdd1= getClientRespBean.employerAdd1;
       requestBean.CIupdateClientDetailV12.cib003i.employerAdd2= getClientRespBean.employerAdd2;
       requestBean.CIupdateClientDetailV12.cib003i.employerSuburb= getClientRespBean.employerSuburb;
       requestBean.CIupdateClientDetailV12.cib003i.employerTown= getClientRespBean.employerTown;
       requestBean.CIupdateClientDetailV12.cib003i.employerPostal= getClientRespBean.employerPostal;
       
       //Address Mappings
       for(Address__c add : addressList){
           if(add.Account__c == acc.Id){
               if(add.Address_Type__c == StringConstants.EMPLOYER_ADDR_STRING){
                   requestBean.CIupdateClientDetailV12.Cib003i.employerAdd1 = add.Shipping_Street__c;
                   requestBean.CIupdateClientDetailV12.Cib003i.employerAdd2 = add.Shipping_Street_2__c;
                   requestBean.CIupdateClientDetailV12.Cib003i.employerSuburb = add.Shipping_Suburb__c;
                   requestBean.CIupdateClientDetailV12.Cib003i.employerTown = add.Shipping_City__c;
                   requestBean.CIupdateClientDetailV12.Cib003i.employerPostal = add.Shipping_Zip_Postal_Code__c;
               }
               
               if(add.Address_Type__c == StringConstants.PHYSICAL_ADDR_STRING){
                   requestBean.CIupdateClientDetailV12.Cib003i.physicalAdd1 = add.Shipping_Street__c;
                   requestBean.CIupdateClientDetailV12.Cib003i.physicalAdd2 = add.Shipping_Street_2__c;
                   requestBean.CIupdateClientDetailV12.Cib003i.physicalSuburb = add.Shipping_Suburb__c;
                   requestBean.CIupdateClientDetailV12.Cib003i.physicalTown = add.Shipping_City__c;
                   requestBean.CIupdateClientDetailV12.Cib003i.physicalPostal = add.Shipping_Zip_Postal_Code__c;
               }
               
               if(add.Address_Type__c == StringConstants.POSTAL_STRING){
                   requestBean.CIupdateClientDetailV12.Cib003i.postlAddrLine1 = add.Shipping_Street__c;
                   requestBean.CIupdateClientDetailV12.Cib003i.postlAddrLine2 = add.Shipping_Street_2__c;
                   requestBean.CIupdateClientDetailV12.Cib003i.postlSuburb = add.Shipping_Suburb__c;
                   requestBean.CIupdateClientDetailV12.Cib003i.postlTown = add.Shipping_City__c;
                   requestBean.CIupdateClientDetailV12.Cib003i.postlCodeRsa = add.Shipping_Zip_Postal_Code__c;
               }
               
               if(add.Address_Type__c == StringConstants.BUSINESS_ADDR_STRING){
                   requestBean.CIupdateClientDetailV12.Cib003i.businessSuburb = requestBean.CIupdateClientDetailV12.Cib003i.businessSuburb;
                   requestBean.CIupdateClientDetailV12.Cib003i.businessAdd1 = add.Shipping_Street__c;
                   requestBean.CIupdateClientDetailV12.Cib003i.businessAdd2 = add.Shipping_Street_2__c;
                   requestBean.CIupdateClientDetailV12.Cib003i.businessSuburb = add.Shipping_Suburb__c;
                   requestBean.CIupdateClientDetailV12.Cib003i.businessTown = add.Shipping_City__c;
                   requestBean.CIupdateClientDetailV12.Cib003i.businessPostal = add.Shipping_Zip_Postal_Code__c;
               }
               
               if(add.Address_Type__c == StringConstants.REGISTERED_ADDR_STRING){
                   requestBean.CIupdateClientDetailV12.Cib003i.regAddrLine1 = add.Shipping_Street__c;
                   requestBean.CIupdateClientDetailV12.Cib003i.regAddrLine2 = add.Shipping_Street_2__c;
                   requestBean.CIupdateClientDetailV12.Cib003i.regSuburb = add.Shipping_Suburb__c;
                   requestBean.CIupdateClientDetailV12.Cib003i.regTown = add.Shipping_City__c;
                   requestBean.CIupdateClientDetailV12.Cib003i.regCodeRsa = add.Shipping_Zip_Postal_Code__c;
                   
                   String addCountry = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country', acc.Country_of_Registration__c, StringConstants.OUTBOUND_RECORD_TYPE);
                   
                   if(addCountry != null) {
                       requestBean.CIupdateClientDetailV12.Cib003i.countryRegAddress = addCountry;
                   } else {
                       requestBean.CIupdateClientDetailV12.Cib003i.countryRegAddress = ''; 
                   }
                   
               }                                
               
               if(add.Address_Type__c == StringConstants.HEAD_OFFICE_ADDR_STRING){
                   requestBean.CIupdateClientDetailV12.Cib003i.hoAddrLine1 = add.Shipping_Street__c;
                   requestBean.CIupdateClientDetailV12.Cib003i.hoAddrLine2 = add.Shipping_Street_2__c;
                   requestBean.CIupdateClientDetailV12.Cib003i.hoSuburb = add.Shipping_Suburb__c;
                   requestBean.CIupdateClientDetailV12.Cib003i.hoTown = add.Shipping_City__c;
                   requestBean.CIupdateClientDetailV12.Cib003i.hoCodeRsa = add.Shipping_Zip_Postal_Code__c;
                   
                   String addCountry = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country', acc.Country_of_Registration__c, StringConstants.OUTBOUND_RECORD_TYPE);
                   
                   if(addCountry != null) {
                       requestBean.CIupdateClientDetailV12.Cib003i.countryHoAddress = addCountry;
                   } else {
                       requestBean.CIupdateClientDetailV12.Cib003i.countryHoAddress = ''; 
                   }
                   
               }
           }
       }
       
       String SICClassification1Translated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'SIC Classification',acc.SIC_Classification_1__c, StringConstants.OUTBOUND_RECORD_TYPE);
       String SICClassification2Translated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'SIC Classification',acc.SIC_Classification_2__c, StringConstants.OUTBOUND_RECORD_TYPE);
       String SICClassification3Translated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'SIC Classification',acc.SIC_Classification_3__c, StringConstants.OUTBOUND_RECORD_TYPE);
       
       List<ciupdateclientdetailV12_Req_IB_v1.agriData> agriDatalist = new List<ciupdateclientdetailV12_Req_IB_v1.agriData>();
       if(SICClassification1Translated != null){
           ciupdateclientdetailV12_Req_IB_v1.agriData AgriData1 = new ciupdateclientdetailV12_Req_IB_v1.agriData();
           AgriData1.agriClass = SICClassification1Translated;
           if(acc.SIC_Classification_1_Percentage__c!=null){
               AgriData1.percentage = String.ValueOf(acc.SIC_Classification_1_Percentage__c);
           }
           agriDatalist.add(AgriData1);
       }
       if(SICClassification2Translated != null){
           ciupdateclientdetailV12_Req_IB_v1.agriData AgriData2 = new ciupdateclientdetailV12_Req_IB_v1.agriData();
           AgriData2.agriClass = SICClassification2Translated;
           if(acc.SIC_Classification_2_Percentage__c!=null){
               AgriData2.percentage = String.ValueOf(acc.SIC_Classification_2_Percentage__c);
           }
           agriDatalist.add(AgriData2);
       }
       if(SICClassification3Translated != null){
           ciupdateclientdetailV12_Req_IB_v1.agriData AgriData3 = new ciupdateclientdetailV12_Req_IB_v1.agriData();
           AgriData3.agriClass = SICClassification3Translated;
           if(acc.SIC_Classification_3_Percentage__c!=null){
               AgriData3.percentage =String.ValueOf(acc.SIC_Classification_3_Percentage__c);
           }
           agriDatalist.add(AgriData3);
       }
       
       If(SICClassification1Translated == null && SICClassification2Translated == null && SICClassification3Translated == null){
           for(integer i = 0; i < 3; i ++) {
               
               ciupdateclientdetailV12_Req_IB_v1.agriData AgriData3 = new ciupdateclientdetailV12_Req_IB_v1.agriData();
               AgriData3.agriClass = '';
               AgriData3.percentage = '0';
               agriDatalist.add(AgriData3); }}
       
       requestBean.CIupdateClientDetailV12.cib003i.agriData= agriDatalist;
       requestBean.CIupdateClientDetailV12.cib003i.resPermitNbr= getClientRespBean.tempPermitNbr;
       requestBean.CIupdateClientDetailV12.cib003i.permitExpDte= getClientRespBean.permitExpDte;
       requestBean.CIupdateClientDetailV12.cib003i.subClassCde= getClientRespBean.subClassCde;
       requestBean.CIupdateClientDetailV12.cib003i.countryIncorp= getClientRespBean.countryIncorp;
       requestBean.CIupdateClientDetailV12.cib003i.inBusinessRescue= getClientRespBean.inBusinessRescue;
       requestBean.CIupdateClientDetailV12.cib003i.placedBy= getClientRespBean.placedBy;
       requestBean.CIupdateClientDetailV12.cib003i.dateBusRescueIss= getClientRespBean.dateBusRescueIss;
       requestBean.CIupdateClientDetailV12.cib003i.ncaThreshold= getClientRespBean.ncaThreshold;
       requestBean.CIupdateClientDetailV12.cib003i.cpaThreshold= getClientRespBean.cpaThreshold;
       requestBean.CIupdateClientDetailV12.cib003i.nkinSurname= getClientRespBean.nkinSurname;
       requestBean.CIupdateClientDetailV12.cib003i.nkinFname= getClientRespBean.nkinFname;
       requestBean.CIupdateClientDetailV12.cib003i.nkinRela= getClientRespBean.nkinRela;
       requestBean.CIupdateClientDetailV12.cib003i.nkinDcdh= getClientRespBean.nkinDcdh;
       requestBean.CIupdateClientDetailV12.cib003i.nkinTelh= getClientRespBean.nkinTelh;
       requestBean.CIupdateClientDetailV12.cib003i.nkinDcdw= getClientRespBean.nkinDcdw;
       requestBean.CIupdateClientDetailV12.cib003i.nkinTelw= getClientRespBean.nkinTelw;
       requestBean.CIupdateClientDetailV12.cib003i.nkinCell= getClientRespBean.nkinCell;
       requestBean.CIupdateClientDetailV12.cib003i.nkinEmail= getClientRespBean.nkinEmail;
       requestBean.CIupdateClientDetailV12.cib003i.nkinTitle= getClientRespBean.nkinTitle;
       requestBean.CIupdateClientDetailV12.cib003i.nkinInitials= getClientRespBean.nkinInitials;
       requestBean.CIupdateClientDetailV12.cib003i.nkinJntSurname= getClientRespBean.nkinJntSurname;
       requestBean.CIupdateClientDetailV12.cib003i.contOride= requestBean.CIupdateClientDetailV12.cib003i.contOride;
       requestBean.CIupdateClientDetailV12.cib003i.updAddressInd= getClientRespBean.updAddressInd;
       requestBean.CIupdateClientDetailV12.cib003i.updTelephoneInd= getClientRespBean.updTelephoneInd;
       requestBean.CIupdateClientDetailV12.cib003i.updEmailInd= getClientRespBean.updEmailInd;
       requestBean.CIupdateClientDetailV12.cib003i.updDateInd= getClientRespBean.updDateInd;
       //requestBean.CIupdateClientDetailV12.cib003i.casaRefNum= getClientRespBean.casaRefNum;
       requestBean.CIupdateClientDetailV12.cib003i.pingitWallet= getClientRespBean.pingitWallet;
       requestBean.CIupdateClientDetailV12.cib003i.pingitReceive= getClientRespBean.pingitReceive;
       requestBean.CIupdateClientDetailV12.cib003i.regAddrLine1= getClientRespBean.regAddrLine1;
       requestBean.CIupdateClientDetailV12.cib003i.regAddrLine2= getClientRespBean.regAddrLine2;
       requestBean.CIupdateClientDetailV12.cib003i.regSuburb= getClientRespBean.regSuburb;
       requestBean.CIupdateClientDetailV12.cib003i.regTown= getClientRespBean.regTown;
       requestBean.CIupdateClientDetailV12.cib003i.regCodeRsa= getClientRespBean.regCodeRsa;
       requestBean.CIupdateClientDetailV12.cib003i.hoAddrLine1= getClientRespBean.hoAddrLine1;
       requestBean.CIupdateClientDetailV12.cib003i.hoAddrLine2= getClientRespBean.hoAddrLine2;
       requestBean.CIupdateClientDetailV12.cib003i.hoSuburb= getClientRespBean.hoSuburb;
       requestBean.CIupdateClientDetailV12.cib003i.hoTown= getClientRespBean.hoTown;
       requestBean.CIupdateClientDetailV12.cib003i.hoCodeRsa= getClientRespBean.hoCodeRsa;
       requestBean.CIupdateClientDetailV12.cib003i.countryResAddress= getClientRespBean.countryResAddress;
       requestBean.CIupdateClientDetailV12.cib003i.countryHoAddress= getClientRespBean.countryHoAddress;
       requestBean.CIupdateClientDetailV12.cib003i.countryRegAddress= getClientRespBean.countryRegAddress;
       
       String[] countryEntoprt = new String[]{};
           if(acc.Country_of_Operation__c != null && acc.Country_of_Operation__c !=''){
               countryEntoprt = acc.Country_of_Operation__c.split(';');
           }
       List<ciupdateclientdetailV12_Req_IB_v1.CountryEntOprtData> countryEntoprtlist = new List<ciupdateclientdetailV12_Req_IB_v1.CountryEntOprtData>();
       
       for(String countryofopt:countryEntoprt){
           ciupdateclientdetailV12_Req_IB_v1.CountryEntOprtData tempcountryEntoprt = new ciupdateclientdetailV12_Req_IB_v1.CountryEntOprtData();
           String countryOfOperationTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country',acc.Country_of_Operation__c, StringConstants.OUTBOUND_RECORD_TYPE);
           if(countryOfOperationTranslated != null) {
               tempcountryEntoprt.countryEntOprt = countryOfOperationTranslated;
               countryEntoprtlist.add(tempcountryEntoprt);
           }
           // countryEntoprtlist.add(countryOfOperationTranslated);
       }
       
       requestBean.CIupdateClientDetailV12.cib003i.countryEntOprtData = countryEntoprtlist;
       
       requestBean.CIupdateClientDetailV12.cib003i.countryOfBirth= getClientRespBean.countryOfBirth;
       requestBean.CIupdateClientDetailV12.cib003i.mclInd= getClientRespBean.mclInd;
       requestBean.CIupdateClientDetailV12.cib003i.clntAgrmntIssued= getClientRespBean.clntAgrmntIssued;
       requestBean.CIupdateClientDetailV12.cib003i.sec129DeliveryAddr= getClientRespBean.sec129DeliveryAddr;
       requestBean.CIupdateClientDetailV12.cib003i.saTaxRegis= getClientRespBean.saTaxRegis;
       requestBean.CIupdateClientDetailV12.cib003i.rsonSaTaxNotGiven= getClientRespBean.rsonSaTaxNotGiven;
       requestBean.CIupdateClientDetailV12.cib003i.countryEntOprtData = countryEntoprtlist;
       
       List<ciupdateclientdetailV12_Req_IB_v1.ForeignTaxData> ForeignTaxlist = new List<ciupdateclientdetailV12_Req_IB_v1.ForeignTaxData>();
       if(acc.Foreign_Tax_Number__c!=null){
           ciupdateclientdetailV12_Req_IB_v1.ForeignTaxData tempForeignTaxData = new ciupdateclientdetailV12_Req_IB_v1.ForeignTaxData();
           tempForeignTaxData.foreignTaxNo = String.valueOf(acc.Foreign_Tax_Number__c);
           if(acc.Country_of_Foreign_tax__c!=null){
               tempForeignTaxData.foreignTaxCtry = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country',acc.Country_of_Foreign_tax__c, StringConstants.OUTBOUND_RECORD_TYPE);
           }
           requestBean.CIupdateClientDetailV12.cib003i.foreignTaxRegis ='Y';   
           ForeignTaxlist.add(tempForeignTaxData);
       }
       
       If(ForeignTaxlist.size()>0 && ForeignTaxlist != null){
           requestBean.CIupdateClientDetailV12.cib003i.foreignTaxData = ForeignTaxlist;}
       else{
           requestBean.CIupdateClientDetailV12.cib003i.foreignTaxRegis ='N';
       }
       
       requestBean.CIupdateClientDetailV12.cib003i.ncrInd= 'N';
       requestBean.CIupdateClientDetailV12.cib003i.ncrSms= 'N';
       requestBean.CIupdateClientDetailV12.cib003i.ncrEmail= 'N';
       requestBean.CIupdateClientDetailV12.cib003i.ncrAvoice= 'N';
       requestBean.CIupdateClientDetailV12.cib003i.ncrTel= 'N';
       requestBean.CIupdateClientDetailV12.cib003i.ncrPost= 'N';
       requestBean.CIupdateClientDetailV12.cib003i.crInd= 'N';
       requestBean.CIupdateClientDetailV12.cib003i.crSms= 'N';
       requestBean.CIupdateClientDetailV12.cib003i.crEmail= 'N';
       requestBean.CIupdateClientDetailV12.cib003i.crAvoice= 'N';
       requestBean.CIupdateClientDetailV12.cib003i.crTel= 'N';
       requestBean.CIupdateClientDetailV12.cib003i.crPost= 'N';


       return requestBean;
   }
   
   

     /**
     * @description Anka Ganta - 2021-03-04 - W-006976 - Remediate Existing Customer Onboading 
     * @author Monde Masiza | 2021-07-15 
     * @param acc 
     * @param addressList 
     * @param translations 
     * @param clientType 
     * @param siteCode 
     * @param employeeNumber 
     * @param respBean 
     * @return ciupdateclientdetailV12_Req_IB_v1 
     **/
     public static ciupdateclientdetailV12_Req_IB_v1 ciUpdateRemediateCustomer(Account acc, List<Address__c> addressList , Map<String,String> translations ,String clientType, String siteCode,String employeeNumber, GetClientDetailsCIF_Resp_IB_v1 respBean){  
       ciupdateclientdetailV12_Req_IB_v1 requestBean = new ciupdateclientdetailV12_Req_IB_v1();
        requestBean.CIupdateClientDetailV12 = new ciupdateclientdetailV12_Req_IB_v1.CIupdateClientDetailV12();
        requestBean.CIupdateClientDetailV12.cib003i = new ciupdateclientdetailV12_Req_IB_v1.Cib004i();
        
        String brid = [Select Id, BRID__c from User where EmployeeNumber =:employeeNumber Limit 1].BRID__c;
        
    List<AccountContactRelation> acrList = [SELECT id,AccountId,Designation__c,ContactId,Contact.Name,Contact.FirstName,Contact.LastName,Roles,Contact.MobilePhone,Contact.Email,Contact.Phone FROM AccountContactRelation WHERE AccountId =: acc.Id AND Roles INCLUDES ('Contact Person')];
    Map<String,String> addressMap = new Map<String,String>();
    for(Address__c add : addressList){
    addressMap.put(add.Address_Type__c+''+'Street',add.Shipping_Street__c) ;  
    addressMap.put(add.Address_Type__c+''+'Street2',add.Shipping_Street_2__c) ;     
    addressMap.put(add.Address_Type__c+''+'Suburb',add.Shipping_Suburb__c) ;     
    addressMap.put(add.Address_Type__c+''+'City',add.Shipping_City__c) ; 
    addressMap.put(add.Address_Type__c+''+'Zip',add.Shipping_Zip_Postal_Code__c) ; 
         
    }

        
        If(clientType == 'Sole Trader' || clientType == 'Private Individual' || clientType == 'Individual'){//short term insurance added || clientType == 'Individual'
       requestBean.CIupdateClientDetailV12.cib003i.initials= acc.Initials__pc;         
       requestBean.CIupdateClientDetailV12.cib003i.language = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Language', acc.Language__c, StringConstants.OUTBOUND_RECORD_TYPE);				//Translation
       requestBean.CIupdateClientDetailV12.cib003i.titleCode= translations.get(acc.PersonTitle+''+'CIF'+''+'Title'+''+'Outbound');
       requestBean.CIupdateClientDetailV12.cib003i.surname= acc.LastName != null ? acc.LastName.toUpperCase() : ''; 
       requestBean.CIupdateClientDetailV12.cib003i.idDocType=  Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, StringConstants.FIELD_IDENTITY_TYPE_STRING, acc.ID_Type__pc, StringConstants.OUTBOUND_RECORD_TYPE);
       if(acc.ID_Number__pc != null){
           requestBean.CIupdateClientDetailV12.cib003i.idNumber= acc.ID_Number__pc; 
       }else{requestBean.CIupdateClientDetailV12.cib003i.idNumber= '0';  }
        
       requestBean.CIupdateClientDetailV12.cib003i.birthDate = acc.PersonBirthdate != null ? String.valueOf(acc.PersonBirthdate).replace('-','') : '';
       requestBean.CIupdateClientDetailV12.cib003i.maritalStatus = translations.get(acc.Marital_Status__pc+''+'CIF'+''+'Marital Status'+''+'Outbound'); //Translation
       requestBean.CIupdateClientDetailV12.cib003i.smsMarketInd= acc.Is_Marketing_Consent_SMS__c == true? 'Y': 'N';
       requestBean.CIupdateClientDetailV12.cib003i.gender = translations.get(acc.Gender__pc+''+'CIF'+''+'Gender'+''+'Outbound');						//Translation
       requestBean.CIupdateClientDetailV12.cib003i.minorChildren = String.valueOf(acc.Number_Of_Dependents__c);
       requestBean.CIupdateClientDetailV12.cib003i.occupationCode = translations.get(acc.Gender__pc+''+'CIF'+''+'Occupation Category'+''+'Outbound');			//Translation
       requestBean.CIupdateClientDetailV12.cib003i.incomeGroup= translations.get(acc.Monthly_Income__pc+''+'CIF'+''+'Monthly Income'+''+'Outbound');       
        requestBean.CIupdateClientDetailV12.cib003i.mariageContrctType = translations.get(acc.Marital_Contract_Type__pc+''+'CIF'+''+'Marital Contract Type'+''+'Outbound');		//Translation
       requestBean.CIupdateClientDetailV12.cib003i.homeLanguage = translations.get(acc.Home_Language__pc+''+'CIF'+''+'Language'+''+'Outbound');			//Translation
       requestBean.CIupdateClientDetailV12.cib003i.marketingConcent= translations.get(acc.Non_Credit_Marketing_Consent__pc+''+'CIF'+''+'Non-Credit Marketing Consent'+''+'Outbound');
       requestBean.CIupdateClientDetailV12.cib003i.miltaryComtmntInd=  requestBean.CIupdateClientDetailV12.cib003i.miltaryComtmntInd; 
       requestBean.CIupdateClientDetailV12.cib003i.occupancyType= translations.get(acc.Residential_Status__pc+''+'CIF'+''+'Residential Status'+''+'Outbound'); 
        requestBean.CIupdateClientDetailV12.cib003i.firstNames = acc.FirstName != null ? acc.FirstName.toUpperCase() : '';
       requestBean.CIupdateClientDetailV12.cib003i.occupationStatus = translations.get(acc.Occupation_Status__pc+''+'CIF'+''+'Occupation Status'+''+'Outbound');		//Translation
       requestBean.CIupdateClientDetailV12.cib003i.employmentSector=respBean.employmentSector;    
       requestBean.CIupdateClientDetailV12.cib003i.occupationLevel= translations.get(acc.Occupation_Level__pc+''+'CIF'+''+'Occupation Level'+''+'Outbound');
         requestBean.CIupdateClientDetailV12.cib003i.prefrdCommtionMthd =  translations.get(acc.Preferred_Communication_Method__pc+''+'CIF'+''+'Preferred Communication Method'+''+'Outbound');		//Translation  
         requestBean.CIupdateClientDetailV12.cib003i.countryOfOrigin = translations.get(acc.Country_of_Origin__pc+''+'CIF'+''+'Country'+''+'Outbound');   
        requestBean.CIupdateClientDetailV12.cib003i.casaRefNum= acc.CASA_Reference_Number__pc;
         
        requestBean.CIupdateClientDetailV12.cib003i.clientNationality = translations.get(acc.Nationality__pc+''+'eCasa'+''+'Nationality'+''+'Outbound');
       if(acc.PersonHomePhone != null){
            Integer homeNumberSize = acc.PersonHomePhone.length();
            requestBean.CIupdateClientDetailV12.cib003i.homeTelCode = acc.PersonHomePhone.Substring(0, 3);
            requestBean.CIupdateClientDetailV12.cib003i.homeTelephone = acc.PersonHomePhone.Substring(3, homeNumberSize);
        }
            
       String affectedPersonTranslated ;
           if(acc.Q1a_Client_affected_by_Regulation_3_1_F__c == true) {
                affectedPersonTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Affected Person', String.valueOf(acc.Q1b_How_is_the_Client_Affected__c), StringConstants.OUTBOUND_RECORD_TYPE); 
                   if(String.IsBlank(affectedPersonTranslated) == false){
                       requestBean.CIupdateClientDetailV12.cib003i.affectedPerson = affectedPersonTranslated;					
                   }
                   if(acc.Q1c_Exchange_Control_Expiry_date__c != null) {
                       requestBean.CIupdateClientDetailV12.cib003i.exconExpiryDate = String.valueOf(acc.Q1c_Exchange_Control_Expiry_date__c).replace('-','');
                   }
           }
           if(acc.Q2a_Client_affected_by_Regulation_3_1_F__c == true) {
                affectedPersonTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Affected Person', String.valueOf(acc.Q2b_How_is_the_Client_Affected__c), StringConstants.OUTBOUND_RECORD_TYPE);
                   if(String.IsBlank(affectedPersonTranslated) == false){
                       requestBean.CIupdateClientDetailV12.cib003i.affectedPerson = affectedPersonTranslated;					
                   }
                   if(acc.Q2c_Exchange_Control_Expiry_date__c != null) {
                       requestBean.CIupdateClientDetailV12.cib003i.exconExpiryDate = String.valueOf(acc.Q2c_Exchange_Control_Expiry_date__c).replace('-','');
                   }
           }
            
           if(acc.Q2a_Client_affected_by_Regulation_3_1_F__c == false && acc.Q1a_Client_affected_by_Regulation_3_1_F__c == false){
             
           requestBean.CIupdateClientDetailV12.cib003i.affectedPerson = '0';  
           requestBean.CIupdateClientDetailV12.cib003i.exconExpiryDate = '0';  
         }
            
          
        requestBean.CIupdateClientDetailV12.cib003i.dateIssued= acc.Date_Issued__pc != null? String.valueOf(acc.Date_Issued__pc).replace('-','') : '';  
            
          requestBean.CIupdateClientDetailV12.cib003i.nkinSurname = acc.Next_of_Kin_Last_Name__pc;
          requestBean.CIupdateClientDetailV12.cib003i.nkinFname = acc.Next_of_Kin_First_Name_s__pc;
          requestBean.CIupdateClientDetailV12.cib003i.nkinRela = translations.get(acc.Next_of_Kin_Relationship__pc+''+'CIF'+''+'Relationship'+''+'Outbound'); 
          requestBean.CIupdateClientDetailV12.cib003i.nkinTelh = acc.Next_of_Kin_Telephone_Number__pc;
          requestBean.CIupdateClientDetailV12.cib003i.nkinCell = acc.Next_of_Kin_Cellphone_Number__pc;
          requestBean.CIupdateClientDetailV12.cib003i.nkinEmail = acc.Next_of_Kin_Email_Address__pc;
          requestBean.CIupdateClientDetailV12.cib003i.nkinTitle = '00';
          requestBean.CIupdateClientDetailV12.cib003i.nkinInitials = acc.Next_of_Kin_Initial__pc;
           requestBean.CIupdateClientDetailV12.cib003i.countryOfBirth = translations.get(acc.Country_of_Birth__pc+''+'CIF'+''+'Country'+''+'Outbound');
            
             List<String> nonCreditMarketIndP;
              if(acc.Non_Credit_Marketing_Indicator__pc != null){
                  nonCreditMarketIndP = acc.Non_Credit_Marketing_Indicator__pc.split(';');
              }
              
              List<String> creditMarketIndP;
              if(acc.Credit_Marketing_Indicator__pc != null){
                  creditMarketIndP = acc.Credit_Marketing_Indicator__pc.split(';');
              }
            
            String nonCreditMarketConsentTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Non-Credit Marketing Consent', acc.Non_Credit_Marketing_Consent__pc, StringConstants.OUTBOUND_RECORD_TYPE);
            String creditMarketConsentTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Credit Marketing Consent', acc.Credit_Marketing_Consent__pc, StringConstants.OUTBOUND_RECORD_TYPE);
            
        if(nonCreditMarketConsentTranslated != null){
           requestBean.CIupdateClientDetailV12.Cib003i.ncrInd = nonCreditMarketConsentTranslated; //Translation
           
           requestBean.CIupdateClientDetailV12.Cib003i.ncrEmail = 'N';
           requestBean.CIupdateClientDetailV12.Cib003i.ncrPost = 'N';
           requestBean.CIupdateClientDetailV12.Cib003i.ncrTel = 'N';
           requestBean.CIupdateClientDetailV12.Cib003i.ncrSms = 'N';
           
           if(nonCreditMarketIndP != null){
               for(String indicator : nonCreditMarketIndP){
                   switch on indicator {
                       when 'Email'{
                           requestBean.CIupdateClientDetailV12.Cib003i.ncrEmail = 'Y';
                       }
                       when 'Mail'{
                           requestBean.CIupdateClientDetailV12.Cib003i.ncrPost = 'Y';
                       }
                       when 'Phone'{
                           requestBean.CIupdateClientDetailV12.Cib003i.ncrTel = 'Y';
                       }
                       when 'SMS'{
                           requestBean.CIupdateClientDetailV12.Cib003i.ncrSms = 'Y';
                       }
                   }//End of switch case
               }//End of for loop
           }
       }//End of IF
       
       //Credit Marketing Consent
       if(creditMarketConsentTranslated != null){
           requestBean.CIupdateClientDetailV12.Cib003i.crInd = creditMarketConsentTranslated;					//Translation
           
           requestBean.CIupdateClientDetailV12.Cib003i.crPost = 'N';
           requestBean.CIupdateClientDetailV12.Cib003i.crTel = 'N';
           requestBean.CIupdateClientDetailV12.Cib003i.crAvoice = 'N';
           requestBean.CIupdateClientDetailV12.Cib003i.crEmail = 'N';
           requestBean.CIupdateClientDetailV12.Cib003i.crSms = 'N';
           
           if(creditMarketIndP != null){
               for(String indicator : creditMarketIndP){
                   switch on indicator {
                       when 'Mail'{
                           requestBean.CIupdateClientDetailV12.Cib003i.crPost = 'Y';
                       }
                       when 'Phone'{
                           requestBean.CIupdateClientDetailV12.Cib003i.crTel = 'Y';
                       }
                       when 'Voice Recording'{
                           requestBean.CIupdateClientDetailV12.Cib003i.crAvoice = 'Y';
                       }
                       when 'Email'{
                           requestBean.CIupdateClientDetailV12.Cib003i.crEmail = 'Y';
                       }
                       when 'SMS'{
                           requestBean.CIupdateClientDetailV12.Cib003i.crSms = 'Y';
                       }
                   }//End of switch case
               }//End of for loop
           }
       }//End of IF
         
        }
        
        
        If(clientType != 'Sole Trader' && clientType != 'Private Individual' && clientType != 'Individual'){ //short term insurance added && clientType == 'Individual'   
       requestBean.CIupdateClientDetailV12.cib003i.initials= respBean.initials;   
       requestBean.CIupdateClientDetailV12.cib003i.language = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Language', acc.Language__c, StringConstants.OUTBOUND_RECORD_TYPE);
       requestBean.CIupdateClientDetailV12.cib003i.surname= acc.Name.toUpperCase();
       requestBean.CIupdateClientDetailV12.cib003i.idDocType=  Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, StringConstants.FIELD_IDENTITY_TYPE_STRING, acc.ID_Type__c, StringConstants.OUTBOUND_RECORD_TYPE);  
        if(acc.ID_Type__c == 'Registration Number' && acc.Registration_Number__c != null ) {
                requestBean.CIupdateClientDetailV12.cib003i.idNumber= string.valueOf(acc.Registration_Number__c.replace('/','')); 
        }else{
            requestBean.CIupdateClientDetailV12.cib003i.idNumber= '0';
        }
        requestBean.CIupdateClientDetailV12.cib003i.birthDate = '0';
       requestBean.CIupdateClientDetailV12.cib003i.maritalStatus = '0';//Translation  
       requestBean.CIupdateClientDetailV12.cib003i.smsMarketInd= acc.Is_Marketing_Consent_SMS__c == true? 'Y': 'N';
       requestBean.CIupdateClientDetailV12.cib003i.gender = '0';					//Translation
       requestBean.CIupdateClientDetailV12.cib003i.minorChildren = '0';
       requestBean.CIupdateClientDetailV12.cib003i.occupationCode = '0';		//Translation
       requestBean.CIupdateClientDetailV12.cib003i.incomeGroup= translations.get(acc.Monthly_Income__c+''+'CIF'+''+'Monthly Income'+''+'Outbound');
       requestBean.CIupdateClientDetailV12.cib003i.bankingSector= respBean.bankingSector;  
       requestBean.CIupdateClientDetailV12.cib003i.mariageContrctType = '0'; 
        requestBean.CIupdateClientDetailV12.cib003i.homeLanguage = respBean.homeLanguage;  
       requestBean.CIupdateClientDetailV12.cib003i.prefrdCommtionMthd =  translations.get(acc.Preferred_Communication_Method__c+''+'CIF'+''+'Preferred Communication Method'+''+'Outbound');		//Translation     
      requestBean.CIupdateClientDetailV12.cib003i.casaRefNum= acc.CASA_Reference_Number__c;
            
        String affectedPersonTranslated ;
           if(acc.Q4a_Client_affected_by_Regulation_3_1_F__c  == true) {
                affectedPersonTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Affected Person', String.valueOf(acc.Q4b_How_is_the_Client_Affected__c), StringConstants.OUTBOUND_RECORD_TYPE); 
                   if(String.IsBlank(affectedPersonTranslated) == false){
                       requestBean.CIupdateClientDetailV12.cib003i.affectedPerson = affectedPersonTranslated;					
                   }
                   if(acc.Q4c_Exchange_Control_Expiry_date__c  != null) {
                       requestBean.CIupdateClientDetailV12.cib003i.exconExpiryDate = String.valueOf(acc.Q4c_Exchange_Control_Expiry_date__c).replace('-','');
                   }
           }
         Else{
             
           requestBean.CIupdateClientDetailV12.cib003i.affectedPerson = '0';  
           requestBean.CIupdateClientDetailV12.cib003i.exconExpiryDate = '0';  
         }
        
        }     
       
       requestBean.CIupdateClientDetailV12.cib003i.clientType= Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Client Type', acc.Client_Type__c , StringConstants.OUTBOUND_RECORD_TYPE);
       
      // requestBean.CIupdateClientDetailV12.cib003i.sec129DeliveryAddr= '0';
       requestBean.CIupdateClientDetailV12.cib003i.clientCode= acc.CIF__c;  
       requestBean.CIupdateClientDetailV12.cib003i.bankingSector= respBean.bankingSector; 
       requestBean.CIupdateClientDetailV12.cib003i.securityIndicator= respBean.securityIndicator;
       requestBean.CIupdateClientDetailV12.cib003i.liabilityIndicator= respBean.liabilityIndicator;
       requestBean.CIupdateClientDetailV12.cib003i.telebankIndicator= respBean.telebankIndicator;
       requestBean.CIupdateClientDetailV12.cib003i.unclaimedFundsInd= respBean.unclaimedFundsInd;                                                                
       requestBean.CIupdateClientDetailV12.cib003i.branchClientOpen= siteCode;
       requestBean.CIupdateClientDetailV12.cib003i.dateClientOpened = respBean.dateClientOpened;  
       requestBean.CIupdateClientDetailV12.cib003i.changeNumber= respBean.changeNumber; 
       requestBean.CIupdateClientDetailV12.cib003i.dateLastChanged= string.valueOf(System.Today().format().replace('/',''));  
       requestBean.CIupdateClientDetailV12.cib003i.siteLastChanged= siteCode; 
       if(brid != null){
           requestBean.CIupdateClientDetailV12.cib003i.tellerLastChanged = brid.subString(2);//'09999996'
       }
       requestBean.CIupdateClientDetailV12.cib003i.nbrOfAccounts= respBean.nbrOfAccounts; 
       requestBean.CIupdateClientDetailV12.cib003i.prohibitedInd= respBean.prohibitedInd; 
       requestBean.CIupdateClientDetailV12.cib003i.postalAddrHold= respBean.postalAddrHold;  
      // requestBean.CIupdateClientDetailV12.cib003i.absaRewardIndctor = respBean.absaRewardIndctor;    
       requestBean.CIupdateClientDetailV12.cib003i.idRequiredHold= respBean.idRequiredHold;
       requestBean.CIupdateClientDetailV12.cib003i.deceasedEstateHld= respBean.deceasedEstateHld;  
       requestBean.CIupdateClientDetailV12.cib003i.deceasedSpouseHld= respBean.deceasedSpouseHld;  
       requestBean.CIupdateClientDetailV12.cib003i.insolvntEstateHld= respBean.insolvntEstateHld;   
       requestBean.CIupdateClientDetailV12.cib003i.curatorshipHold= respBean.curatorshipHold;     
       requestBean.CIupdateClientDetailV12.cib003i.savngStatementHold=respBean.savngStatementHold;   
       requestBean.CIupdateClientDetailV12.cib003i.courtAuthrityHold= respBean.courtAuthrityHold;  
       requestBean.CIupdateClientDetailV12.cib003i.thirdPartyInd= respBean.thirdPartyInd;    
       requestBean.CIupdateClientDetailV12.cib003i.mandateCaptureHld= respBean.mandateCaptureHld;   
       requestBean.CIupdateClientDetailV12.cib003i.powerAttornyHold= respBean.powerAttornyHold;  
       requestBean.CIupdateClientDetailV12.cib003i.sbuSegment=  respBean.sbuSegment;  
      requestBean.CIupdateClientDetailV12.cib003i.casaRefNum= acc.CASA_Reference_Number__c;
      
       requestBean.CIupdateClientDetailV12.cib003i.noOfJointPartcpnt= respBean.noOfJointPartcpnt ; 
       requestBean.CIupdateClientDetailV12.cib003i.taxNumber = String.valueOf(acc.Income_Tax_Number__c);     
       requestBean.CIupdateClientDetailV12.cib003i.sicCode = translations.get(acc.Standard_Industry_SIC_Code__c+''+'CIF'+''+'Standard Industry SIC Code'+''+'Outbound'); 
       
       requestBean.CIupdateClientDetailV12.cib003i.insolventIndicator= respBean.insolventIndicator;  
       requestBean.CIupdateClientDetailV12.cib003i.companyYearEnd= translations.get(acc.Financial_Year_End__c+''+'CIF'+''+'Financial Year End'+''+'Outbound');
        
        if(acc.Phone != null){
            Integer workNumberSize = acc.Phone.length();
            requestBean.CIupdateClientDetailV12.cib003i.workTelCode = acc.Phone.Substring(0, 3);
            requestBean.CIupdateClientDetailV12.cib003i.workTelephone = acc.Phone.Substring(3, workNumberSize);
        }
        
       requestBean.CIupdateClientDetailV12.cib003i.physicalAddrHold = respBean.physicalAddrHold ; 
       requestBean.CIupdateClientDetailV12.cib003i.employerAddrHold = respBean.employerAddrHold;
       if(acc.PersonMobilePhone != null){
           String phoneNumber = acc.PersonMobilePhone;
           
           if(phoneNumber.length() > 10){
               //Take last 10 Digits
               Integer numberLength = phoneNumber.length();
               requestBean.CIupdateClientDetailV12.cib003i.cellphone = phoneNumber.Substring(numberLength - 10, numberLength);
               
           }else if(phoneNumber.length() < 10){
               //Add 0 infront until number is 10 digits
               while(phoneNumber.length() < 10){
                   phoneNumber = '0' + phoneNumber;
               }
               requestBean.CIupdateClientDetailV12.cib003i.cellphone = phoneNumber;
           }else{
               //Number is the correct length
               requestBean.CIupdateClientDetailV12.cib003i.cellphone = phoneNumber;
           }
       }
       
       requestBean.CIupdateClientDetailV12.cib003i.faxWorkCode= respBean.faxWorkCode;    
       requestBean.CIupdateClientDetailV12.cib003i.faxWorkNumber= respBean.faxWorkNumber;  
       requestBean.CIupdateClientDetailV12.cib003i.faxHomeCode= respBean.faxHomeCode;   
       requestBean.CIupdateClientDetailV12.cib003i.faxHomeNumber=respBean.faxHomeNumber;  
       requestBean.CIupdateClientDetailV12.cib003i.designation=  respBean.designation;  
       requestBean.CIupdateClientDetailV12.cib003i.emailAddress = acc.PersonEmail;
       requestBean.CIupdateClientDetailV12.cib003i.inliPolicy= respBean.inliPolicy;   
       requestBean.CIupdateClientDetailV12.cib003i.exliPolicy= respBean.exliPolicy;  
       requestBean.CIupdateClientDetailV12.cib003i.instPolicy= respBean.instPolicy;   
       requestBean.CIupdateClientDetailV12.cib003i.exstPolicy= respBean.exstPolicy;    
       requestBean.CIupdateClientDetailV12.cib003i.inivPolicy= respBean.inivPolicy;  
       requestBean.CIupdateClientDetailV12.cib003i.flexiFuneralPolicy= respBean.flexiFuneralPolicy;   
      
       requestBean.CIupdateClientDetailV12.cib003i.cellphoneBankInd=respBean.cellphoneBankInd;  
       requestBean.CIupdateClientDetailV12.cib003i.siccCode5= translations.get(acc.Standard_Industry_SIC_Code__c+''+'CIF'+''+'Standard Industry SIC Code'+''+'Outbound');
       requestBean.CIupdateClientDetailV12.cib003i.subSegment= respBean.subSegment; 
       requestBean.CIupdateClientDetailV12.cib003i.emailMarkInd=respBean.emailMarkInd; 
       requestBean.CIupdateClientDetailV12.cib003i.teleMarkInd=respBean.teleMarkInd;    
       requestBean.CIupdateClientDetailV12.cib003i.internetBankinInd=respBean.internetBankinInd;  
       String srcOfincomeTranslated;
       List<String> sourceOfincomelist = new List<String>(); 
         if(acc.Source_of_Income__c != null){
           String[] sourceOfincomes = acc.Source_of_Income__c.split(';');
              
           for(String srcOfincome:sourceOfincomes){
               srcOfincomeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_SOURCE_OF_INCOME_STRING, srcOfincome, StringConstants.OUTBOUND_RECORD_TYPE);
               sourceOfincomelist.add(srcOfincomeTranslated);
           } 
         }else{
               srcOfincomeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_SOURCE_OF_INCOME_STRING, acc.Source_of_Income__pc, StringConstants.OUTBOUND_RECORD_TYPE);
         }
       
        if(sourceOfincomelist.size() > 0 && sourceOfincomelist != null){
            requestBean.CIupdateClientDetailV12.cib003i.sourceOfIncome = sourceOfincomelist[0];
        }else{
           requestBean.CIupdateClientDetailV12.cib003i.sourceOfIncome =  srcOfincomeTranslated;
        }
        requestBean.CIupdateClientDetailV12.cib003i.dateIdentified= String.valueOf(acc.Date_Identified__c).replace('-','');
        requestBean.CIupdateClientDetailV12.cib003i.dateVerified= acc.Date_Verified__c != null ? String.valueOf(acc.Date_Verified__c).replace('-','') : string.valueOf(System.Today().format().replace('/',''));
        requestBean.CIupdateClientDetailV12.cib003i.employeeIdentified  = employeeNumber;
        requestBean.CIupdateClientDetailV12.cib003i.employeeVerified   = employeeNumber;
      
        requestBean.CIupdateClientDetailV12.cib003i.dateExempted= requestBean.CIupdateClientDetailV12.cib003i.dateExempted; // defaulted <<>>>>
        requestBean.CIupdateClientDetailV12.cib003i.exemptionStatus= requestBean.CIupdateClientDetailV12.cib003i.exemptionStatus; //<<>>>>
        requestBean.CIupdateClientDetailV12.cib003i.exemptionIndicator=  requestBean.CIupdateClientDetailV12.cib003i.exemptionIndicator; 
        requestBean.CIupdateClientDetailV12.cib003i.corporateDivision= requestBean.CIupdateClientDetailV12.cib003i.corporateDivision; // defaulted
        requestBean.CIupdateClientDetailV12.cib003i.haveQualification= requestBean.CIupdateClientDetailV12.cib003i.haveQualification; //<<>>>>>
        requestBean.CIupdateClientDetailV12.cib003i.whatQualification= requestBean.CIupdateClientDetailV12.cib003i.whatQualification;  //<<>>>>
        requestBean.CIupdateClientDetailV12.cib003i.socialGrant= requestBean.CIupdateClientDetailV12.cib003i.socialGrant;  //defaulted <<<<>>>>
        requestBean.CIupdateClientDetailV12.cib003i.notificationInd= requestBean.CIupdateClientDetailV12.cib003i.notificationInd; //<<>>>
        requestBean.CIupdateClientDetailV12.cib003i.mailInd= requestBean.CIupdateClientDetailV12.cib003i.mailInd; // defaulted
        requestBean.CIupdateClientDetailV12.cib003i.applyDebtCounsel= requestBean.CIupdateClientDetailV12.cib003i.applyDebtCounsel; 
        requestBean.CIupdateClientDetailV12.cib003i.dteApplyCounsel= requestBean.CIupdateClientDetailV12.cib003i.dteApplyCounsel;  
        requestBean.CIupdateClientDetailV12.cib003i.counselOrderIssue= requestBean.CIupdateClientDetailV12.cib003i.counselOrderIssue;
        requestBean.CIupdateClientDetailV12.cib003i.dteOrderIssue= requestBean.CIupdateClientDetailV12.cib003i.dteOrderIssue; 
        requestBean.CIupdateClientDetailV12.cib003i.groupScheme= requestBean.CIupdateClientDetailV12.cib003i.groupScheme; 
        requestBean.CIupdateClientDetailV12.cib003i.secondaryCard= requestBean.CIupdateClientDetailV12.cib003i.secondaryCard; 
      //  requestBean.CIupdateClientDetailV12.cib003i.affectedPerson = translations.get(String.valueOf(accountList[0].Q4a_Client_affected_by_Regulation_3_1_F__c)+''+'CIF'+''+'Affected Person'+''+'Outbound');		
    
         
        requestBean.CIupdateClientDetailV12.cib003i.ibrAffected= respBean.ibrAffected; 
       // requestBean.CIupdateClientDetailV12.cib003i.clientGroup= respBean.clientGroup; 
        requestBean.CIupdateClientDetailV12.cib003i.employerAddrSeqNbr= requestBean.CIupdateClientDetailV12.cib003i.employerAddrSeqNbr;
        requestBean.CIupdateClientDetailV12.cib003i.physicalAddrType= '0';
        requestBean.CIupdateClientDetailV12.cib003i.physicalAddrSeqNbr='0'; //defaulted 
        requestBean.CIupdateClientDetailV12.cib003i.physicalPostal= addressMap.get(StringConstants.PHYSICAL_ADDR_STRING+''+'Zip');
        requestBean.CIupdateClientDetailV12.cib003i.businessAddrType= '20';
        requestBean.CIupdateClientDetailV12.cib003i.businessAddrSeqNbr= '0'; // from get
        requestBean.CIupdateClientDetailV12.cib003i.businessPostal= addressMap.get(StringConstants.BUSINESS_ADDR_STRING+''+'Zip'); //this
        
        requestBean.CIupdateClientDetailV12.cib003i.employerAdd1 = addressMap.get(StringConstants.EMPLOYER_ADDR_STRING+''+'Street');
        requestBean.CIupdateClientDetailV12.cib003i.employerAdd2 = addressMap.get(StringConstants.EMPLOYER_ADDR_STRING+''+'Street2');
        requestBean.CIupdateClientDetailV12.cib003i.employerSuburb = addressMap.get(StringConstants.EMPLOYER_ADDR_STRING+''+'Suburb');
        requestBean.CIupdateClientDetailV12.cib003i.employerTown= addressMap.get(StringConstants.EMPLOYER_ADDR_STRING+''+'City');
        requestBean.CIupdateClientDetailV12.cib003i.employerPostal = addressMap.get(StringConstants.EMPLOYER_ADDR_STRING+''+'Zip');
        
        
        requestBean.CIupdateClientDetailV12.cib003i.physicalAdd1 = addressMap.get(StringConstants.PHYSICAL_ADDR_STRING+''+'Street');
        requestBean.CIupdateClientDetailV12.cib003i.physicalAdd2 = addressMap.get(StringConstants.PHYSICAL_ADDR_STRING+''+'Street2');
        requestBean.CIupdateClientDetailV12.cib003i.physicalSuburb = addressMap.get(StringConstants.PHYSICAL_ADDR_STRING+''+'Suburb');
        requestBean.CIupdateClientDetailV12.cib003i.physicalTown = addressMap.get(StringConstants.PHYSICAL_ADDR_STRING+''+'City');
        requestBean.CIupdateClientDetailV12.cib003i.physicalPostal = addressMap.get(StringConstants.PHYSICAL_ADDR_STRING+''+'Zip');
        
        requestBean.CIupdateClientDetailV12.cib003i.businessAdd1 = addressMap.get(StringConstants.BUSINESS_ADDR_STRING+''+'Street');
        requestBean.CIupdateClientDetailV12.cib003i.businessAdd2 = addressMap.get(StringConstants.BUSINESS_ADDR_STRING+''+'Street2');
        requestBean.CIupdateClientDetailV12.cib003i.businessSuburb = addressMap.get(StringConstants.BUSINESS_ADDR_STRING+''+'Suburb');
        requestBean.CIupdateClientDetailV12.cib003i.businessTown = addressMap.get(StringConstants.BUSINESS_ADDR_STRING+''+'City');
        requestBean.CIupdateClientDetailV12.cib003i.businessPostal = addressMap.get(StringConstants.BUSINESS_ADDR_STRING+''+'Zip');
        
        
        
        requestBean.CIupdateClientDetailV12.cib003i.postlAddrLine1 = addressMap.get(StringConstants.POSTAL_STRING+''+'Street');
        requestBean.CIupdateClientDetailV12.cib003i.postlAddrLine2 = addressMap.get(StringConstants.POSTAL_STRING+''+'Street2');
        requestBean.CIupdateClientDetailV12.cib003i.postlSuburb = addressMap.get(StringConstants.POSTAL_STRING+''+'Suburb');
        requestBean.CIupdateClientDetailV12.cib003i.postlTown = addressMap.get(StringConstants.POSTAL_STRING+''+'City');
        requestBean.CIupdateClientDetailV12.cib003i.postlCodeRsa = addressMap.get(StringConstants.POSTAL_STRING+''+'Zip');
        
        
        requestBean.CIupdateClientDetailV12.cib003i.hoAddrLine1 = addressMap.get(StringConstants.HEAD_OFFICE_ADDR_STRING+''+'Street');
         requestBean.CIupdateClientDetailV12.cib003i.hoAddrLine2 = addressMap.get(StringConstants.HEAD_OFFICE_ADDR_STRING+''+'Street2');
         requestBean.CIupdateClientDetailV12.cib003i.hoSuburb = addressMap.get(StringConstants.HEAD_OFFICE_ADDR_STRING+''+'Suburb');
         requestBean.CIupdateClientDetailV12.cib003i.hoTown = addressMap.get(StringConstants.HEAD_OFFICE_ADDR_STRING+''+'City');
         requestBean.CIupdateClientDetailV12.cib003i.hoCodeRsa = addressMap.get(StringConstants.HEAD_OFFICE_ADDR_STRING+''+'Zip');
         
        
         requestBean.CIupdateClientDetailV12.cib003i.regAddrLine1 = addressMap.get(StringConstants.REGISTERED_ADDR_STRING+''+'Street');
         requestBean.CIupdateClientDetailV12.cib003i.regAddrLine2 = addressMap.get(StringConstants.REGISTERED_ADDR_STRING+''+'Street2');
         requestBean.CIupdateClientDetailV12.cib003i.regSuburb = addressMap.get(StringConstants.REGISTERED_ADDR_STRING+''+'Suburb');
         requestBean.CIupdateClientDetailV12.cib003i.regTown = addressMap.get(StringConstants.REGISTERED_ADDR_STRING+''+'City');
         requestBean.CIupdateClientDetailV12.cib003i.regCodeRsa = addressMap.get(StringConstants.REGISTERED_ADDR_STRING+''+'Zip');
 
       
        
        String SICClassification1Translated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'SIC Classification',acc.SIC_Classification_1__c, StringConstants.OUTBOUND_RECORD_TYPE);
        String SICClassification2Translated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'SIC Classification',acc.SIC_Classification_2__c, StringConstants.OUTBOUND_RECORD_TYPE);
        String SICClassification3Translated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'SIC Classification',acc.SIC_Classification_3__c, StringConstants.OUTBOUND_RECORD_TYPE);
       
        List<ciupdateclientdetailV12_Req_IB_v1.agriData> agriDatalist = new List<ciupdateclientdetailV12_Req_IB_v1.agriData>();
        if(SICClassification1Translated != null){
           ciupdateclientdetailV12_Req_IB_v1.agriData AgriData1 = new ciupdateclientdetailV12_Req_IB_v1.agriData();
            AgriData1.agriClass = SICClassification1Translated;
            if(acc.SIC_Classification_1_Percentage__c!=null){
                AgriData1.percentage = String.ValueOf(acc.SIC_Classification_1_Percentage__c);
            }
            agriDatalist.add(AgriData1);
        }
        if(SICClassification2Translated != null){
            ciupdateclientdetailV12_Req_IB_v1.agriData AgriData2 = new ciupdateclientdetailV12_Req_IB_v1.agriData();
            AgriData2.agriClass = SICClassification2Translated;
            if(acc.SIC_Classification_2_Percentage__c!=null){
                AgriData2.percentage = String.ValueOf(acc.SIC_Classification_2_Percentage__c);
            }
            agriDatalist.add(AgriData2);
        }
        if(SICClassification3Translated != null){
            ciupdateclientdetailV12_Req_IB_v1.agriData AgriData3 = new ciupdateclientdetailV12_Req_IB_v1.agriData();
            AgriData3.agriClass = SICClassification3Translated;
            if(acc.SIC_Classification_3_Percentage__c!=null){
                AgriData3.percentage =String.ValueOf(acc.SIC_Classification_3_Percentage__c);
            }
            agriDatalist.add(AgriData3);
        }
        
        If(SICClassification1Translated == null && SICClassification2Translated == null && SICClassification3Translated == null){
          for(integer i = 0; i < 3; i ++) {
        
            ciupdateclientdetailV12_Req_IB_v1.agriData AgriData3 = new ciupdateclientdetailV12_Req_IB_v1.agriData();
            AgriData3.agriClass = '';
            AgriData3.percentage = '0';
              agriDatalist.add(AgriData3); }}

        requestBean.CIupdateClientDetailV12.cib003i.agriData = agriDatalist;
        requestBean.CIupdateClientDetailV12.cib003i.permitExpDte= respBean.permitExpDte;  
        requestBean.CIupdateClientDetailV12.cib003i.placedBy= respBean.placedBy;       
        requestBean.CIupdateClientDetailV12.cib003i.dateBusRescueIss= respBean.dateBusRescueIss;       
        requestBean.CIupdateClientDetailV12.cib003i.contOride= requestBean.CIupdateClientDetailV12.cib003i.contOride;        
        requestBean.CIupdateClientDetailV12.cib003i.updAddressInd=respBean.updAddressInd; 
        requestBean.CIupdateClientDetailV12.cib003i.updTelephoneInd=respBean.updTelephoneInd;   
        requestBean.CIupdateClientDetailV12.cib003i.updEmailInd= respBean.updEmailInd;  
        requestBean.CIupdateClientDetailV12.cib003i.updDateInd= respBean.updDateInd;       
       requestBean.CIupdateClientDetailV12.cib003i.pingitWallet= respBean.pingitWallet;   
       requestBean.CIupdateClientDetailV12.cib003i.pingitReceive= respBean.pingitReceive;  
         requestBean.CIupdateClientDetailV12.cib003i.vatRegistrationNo = String.valueOf(acc.VAT_Registration_Number__c);
         requestBean.CIupdateClientDetailV12.cib003i.groupSchemeEmp = respBean.groupSchemeEmp;
         requestBean.CIupdateClientDetailV12.cib003i.subClassCde = respBean.subClassCde;
         requestBean.CIupdateClientDetailV12.cib003i.countryIncorp = translations.get(acc.Country_of_Incorporation__c+''+'CIF'+''+'Country'+''+'Outbound');
         requestBean.CIupdateClientDetailV12.cib003i.inBusinessRescue =respBean.inBusinessRescue;
         requestBean.CIupdateClientDetailV12.cib003i.ncaThreshold =  Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Boolean Value', String.valueOf(acc.Does_the_Client_fall_under_the_NCA__c), StringConstants.OUTBOUND_RECORD_TYPE);
         requestBean.CIupdateClientDetailV12.cib003i.cpaThreshold = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Boolean Value', String.valueOf(acc.Does_the_Client_fall_under_the_CPA__c), StringConstants.OUTBOUND_RECORD_TYPE);
         
         
          requestBean.CIupdateClientDetailV12.cib003i.clntAgrmntIssued =respBean.clntAgrmntIssued;
          requestBean.CIupdateClientDetailV12.cib003i.sec129DeliveryAddr= respBean.sec129DeliveryAddr;
          requestBean.CIupdateClientDetailV12.cib003i.rsonSaTaxNotGiven = translations.get(acc.Reason_For_Not_Providing_SA_Tax_Number__c+''+'CIF'+''+'Reason Tax Not Given'+''+'Outbound');
          requestBean.CIupdateClientDetailV12.cib003i.foreignTaxRegis = acc.Foreign_Tax_Number__c != Null? 'Y': 'N';
        
       
       String[] countryEntoprt = new String[]{};
           if(acc.Country_of_Operation__c != null && acc.Country_of_Operation__c !=''){
               countryEntoprt = acc.Country_of_Operation__c.split(';');
           }
       List<ciupdateclientdetailV12_Req_IB_v1.CountryEntOprtData> countryEntoprtlist = new List<ciupdateclientdetailV12_Req_IB_v1.CountryEntOprtData>();
       
       for(String countryofopt:countryEntoprt){
           ciupdateclientdetailV12_Req_IB_v1.CountryEntOprtData tempcountryEntoprt = new ciupdateclientdetailV12_Req_IB_v1.CountryEntOprtData();
           String countryOfOperationTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country',acc.Country_of_Operation__c, StringConstants.OUTBOUND_RECORD_TYPE);
           if(countryOfOperationTranslated != null) {
               tempcountryEntoprt.countryEntOprt = countryOfOperationTranslated;
                countryEntoprtlist.add(tempcountryEntoprt);
           }
          // countryEntoprtlist.add(countryOfOperationTranslated);
       }
         
          requestBean.CIupdateClientDetailV12.cib003i.countryEntOprtData = countryEntoprtlist;
         List<ciupdateclientdetailV12_Req_IB_v1.ForeignTaxData> ForeignTaxlist = new List<ciupdateclientdetailV12_Req_IB_v1.ForeignTaxData>();
          if(acc.Foreign_Tax_Number__c!=null){
           ciupdateclientdetailV12_Req_IB_v1.ForeignTaxData tempForeignTaxData = new ciupdateclientdetailV12_Req_IB_v1.ForeignTaxData();
           tempForeignTaxData.foreignTaxNo = String.valueOf(acc.Foreign_Tax_Number__c);
           if(acc.Country_of_Foreign_tax__c!=null){
               tempForeignTaxData.foreignTaxCtry = translations.get(acc.Country_of_Foreign_tax__c+''+'CIF'+''+'Country'+''+'Outbound');
           }
           requestBean.CIupdateClientDetailV12.cib003i.foreignTaxRegis ='Y';   
           ForeignTaxlist.add(tempForeignTaxData);
       }
         
         If(ForeignTaxlist.size()>0 && ForeignTaxlist != null){
            requestBean.CIupdateClientDetailV12.cib003i.foreignTaxData = ForeignTaxlist;}
         else{
           requestBean.CIupdateClientDetailV12.cib003i.foreignTaxRegis ='N';
       }
        
           if(!acrList.isEmpty()){
           for(AccountContactRelation accconRel : acrList){
               if((accconRel.Roles).contains(';')){
                   for(String roleValue : (accconRel.Roles).split(';')){
                       if(roleValue != 'Contact person'){
                           requestBean.CIupdateClientDetailV12.Cib003i.contactPerson= accconRel.Contact.Name;
                           requestBean.CIupdateClientDetailV12.Cib003i.emailAddress= accconRel.Contact.Email;
                           requestBean.CIupdateClientDetailV12.Cib003i.Cellphone = accconRel.Contact.MobilePhone;
                           
                           if(accconRel.Contact.Phone != null){
                               Integer workNumberSize = accconRel.Contact.Phone.length();
                               requestBean.CIupdateClientDetailV12.Cib003i.workTelCode = accconRel.Contact.Phone.Substring(0, 3);
                               requestBean.CIupdateClientDetailV12.Cib003i.workTelephone = accconRel.Contact.Phone.Substring(3, workNumberSize);
                           }
                           
                           requestBean.CIupdateClientDetailV12.Cib003i.designation = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Designation', accconRel.Designation__c, StringConstants.OUTBOUND_RECORD_TYPE);                        }
                   }
               }/*else{
                   requestBean.CIcreateClientV12.Cib003i.contactPerson= accconRel.Contact.Name;
                   requestBean.CIcreateClientV12.Cib003i.emailAddress= accconRel.Contact.Email;
                   requestBean.CIcreateClientV12.Cib003i.Cellphone = accconRel.Contact.MobilePhone;
                   }*/
               //requestBean.CIcreateClientV12.Cib003i.designation = acrList[0].Roles;
           }
       }
        
        
                 if(acc.Is_Marketing_Consent_Phone__c!=null && acc.Is_Marketing_Consent_Phone__c==true){
           requestBean.CIupdateClientDetailV12.Cib003i.nCRTel='Y';
       }else if(acc.Is_Marketing_Consent_Phone__c!=null && acc.Is_Marketing_Consent_Phone__c==false){
           requestBean.CIupdateClientDetailV12.Cib003i.nCRTel='N';
       }
       if(acc.Is_Marketing_Consent_Email__c!=null && acc.Is_Marketing_Consent_Email__c==true){
           requestBean.CIupdateClientDetailV12.Cib003i.nCREmail='Y';
       }else if(acc.Is_Marketing_Consent_Email__c!=null && acc.Is_Marketing_Consent_Email__c==false){
           requestBean.CIupdateClientDetailV12.Cib003i.nCREmail='N';
       }
       if(acc.Is_Marketing_Consent_SMS__c!=null && acc.Is_Marketing_Consent_SMS__c==true){
           requestBean.CIupdateClientDetailV12.Cib003i.nCRSMS='Y';
       }else if(acc.Is_Marketing_Consent_SMS__c!=null && acc.Is_Marketing_Consent_SMS__c==false){
           requestBean.CIupdateClientDetailV12.Cib003i.nCRSMS='N';
       }
       if(acc.Is_Marketing_Consent_Post__c!=null && acc.Is_Marketing_Consent_Post__c==true){
           requestBean.CIupdateClientDetailV12.Cib003i.nCRPost='Y';
       }else if(acc.Is_Marketing_Consent_Post__c!=null && acc.Is_Marketing_Consent_Post__c==false){
           requestBean.CIupdateClientDetailV12.Cib003i.nCRPost='N';
       }
        if(acc.Is_Marketing_Consent_voice_rec__c!=null && acc.Is_Marketing_Consent_voice_rec__c==true){
           requestBean.CIupdateClientDetailV12.Cib003i.ncrAvoice='Y';
       }else if(acc.Is_Marketing_Consent_voice_rec__c!=null && acc.Is_Marketing_Consent_voice_rec__c==false){
           requestBean.CIupdateClientDetailV12.Cib003i.ncrAvoice='N';
       }
       if(acc.Is_Marketing_Consent_Phone__c==true || acc.Is_Marketing_Consent_Email__c==true || acc.Is_Marketing_Consent_SMS__c==true ||
          acc.Is_Marketing_Consent_Post__c==true ||   acc.Is_Marketing_Consent_voice_rec__c==true){
              requestBean.CIupdateClientDetailV12.Cib003i.nCRInd='Y'; 
          }else{
              requestBean.CIupdateClientDetailV12.Cib003i.nCRInd='N'; 
          }
        
        
   
     return requestBean;
    }
}