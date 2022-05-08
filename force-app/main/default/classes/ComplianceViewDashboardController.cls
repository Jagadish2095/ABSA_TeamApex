/**
* @description       : ComplianceViewDashboardController for Compliance view dashboard(W-009448)
* @author            : Sharath Chandra
* @group             :
* @last modified on  : 2021-11-30
* @last modified by  : muvhuso.nekhubvi@absa.africa
* Modifications Log
* Ver   Date         Author            Modification
* 1.0   05-25-2021   Sharath Chandra   Initial Version
**/

public class ComplianceViewDashboardController {
    
    private static final string APINAME = 'Jitterbit2';
    private static final string LOGIN_PATH = 'Channel Integration Login';
    private static final string DOC_UPLOAD_PATH = 'Channel Integration Add';
    private static final string GET_DOC_PATH = 'Channel Integration Get';
    private static final string LOGOUT_PATH = 'Channel Integration Logout';
	public static Boolean updatingAccount = false;
    public static final map<string, string> NAMapValues =  new map<string, string>();
    
    /**
    * @description 
    * @author mohammedjunaid.usman@absa.africa | 2021-08-16 
    * @param objectId 
    * @param address1 
    * @param address2 
    * @param suburbName 
    * @param cityName 
    * @param countryName 
    * @param postalCode 
    * @param indicator 
    * @param sourceIncome 
    * @param occupationStatus 
    * @return string 
    **/
    @AuraEnabled
    public static string updateCIF(string objectId, string address1, string address2, string suburbName, string cityName, string countryName, string postalCode, string indicator, string sourceIncome, string occupationStatus) {
        account acc = new AccountsSelector().selectAllById(objectId);
        getUpdateCIFParser CIFRespBean;
        //system.debug('The Occupation and Income are : ' +sourceIncome+','+occupationStatus);
        try{
            if(acc.CIF__c != Null && acc.CIF__c != ''){
                if(indicator == 'U'){
                    //CIFRespBean = getUpdateCIF_IH_v1.getCIFResponse(acc, address1, address2, suburbName, cityName, countryName, postalCode, indicator,sourceIncome, occupationStatus );}
                    CIFRespBean = getUpdateCIF_IH_v1.getCIFResponse(acc, address1,address2, suburbName, cityName, countryName, postalCode,'N','N',sourceIncome,occupationStatus,'');

                }else{
                   //CIFRespBean = getUpdateCIF_IH_v1.getCIFResponse(acc, '', '', '', '', '', '', indicator,sourceIncome, occupationStatus );
                   CIFRespBean = getUpdateCIF_IH_v1.getCIFResponse(acc, address1,address2, suburbName, cityName, countryName, postalCode,'N','N',sourceIncome,occupationStatus,'');

                }
                if(CIFRespBean.CIupdClientAttestationV20Response.outputArea.returnCode == 0 ){
                    updateAccount(acc, '', '', '', sourceIncome,'');
                    if (acc.Client_Type__c == 'Individual' || acc.Client_Type__c =='Individual - Minor' || acc.Client_Type__c == 'Non - Resident Entity' || acc.Client_Type__c == 'Private Individual' || acc.Client_Type__c == 'Staff' || acc.Client_Type__c == 'Staff Joint and Several'){
                        updateAddress(acc,'Individual','Postal',address1,address2,suburbName,cityName,countryName,postalCode);
                    }else if(acc.Client_Type__c == 'Joint & Several'){
                        updateAddress(acc,'Joint & Several','Postal',address1,address2,suburbName,cityName,countryName,postalCode);
                    }else{
                        updateAddress(acc,'Company','Business Address',address1,address2,suburbName,cityName,countryName,postalCode);
                    }
                }
             }else{
                String message = 'Please Update the CIF Number of the client';
                //system.debug(message);
                if(!test.isRunningTest()){
                    AuraHandledException e = new AuraHandledException(message);
                    e.setMessage(message);
                    throw e;
                }
            } 
        }catch(exception ex){
            //system.debug('The update CIF Service is not working correctly');
            //system.debug('the exception is --> '+ex.getMessage());
            if(!test.isRunningTest()){
                throw new AuraHandledException(ex.getMessage());
            }
        }
        //system.debug('the CIFRespBean is --> '+CIFRespBean);
        string responseReturned = JSON.serialize(CIFRespBean);
        return responseReturned;
    } 
    
    /**
* @description Method that gets all Compliance Data
* @param objectId - Account Record ID
* @return complianceData  object
**/
    @AuraEnabled
    public static ComplianceData getData(string objectId) {
        String message;
        Account accRec;
        list<Regulatory_Financial_Account__c> appRecList = new list<Regulatory_Financial_Account__c>();
        GetCompliancePackInfo_Resp_Parse compliancePackResponse;
        ComplianceData DataToBeSent;
        //system.debug('/* In getData Method');
        
        try{
            if( !string.isEmpty(objectId) ){
                accRec = new AccountsSelector().selectAllById(objectId);
                if(accRec != null){
                    if((accRec.CASA_Reference_Number__c == null || accRec.CASA_Reference_Number__c == '0') && (accRec.CASA_Reference_Number__pc == null || accRec.CASA_Reference_Number__pc == '0')){
                        CASAPrimaryClientScreening_Resp_IB_v3 casaPrimaryClientScreeningResponse = CVDashboardRiskRating_IH_v1.casaPrimaryClientScreeningBusinessAcc(accRec);
                        //System.debug('casaPrimaryClientScreeningResponse++'+casaPrimaryClientScreeningResponse);
                        if(casaPrimaryClientScreeningResponse != null && casaPrimaryClientScreeningResponse.statusCode == 200){
                            if(casaPrimaryClientScreeningResponse.refNo != Null && casaPrimaryClientScreeningResponse.refNo != '0' ){
                                updatingAccount = true;
                                if(accRec.RecordType.DeveloperName == 'Client' || accRec.RecordType.DeveloperName == 'Prospect'){
                                    accRec.CASA_Reference_Number__c = casaPrimaryClientScreeningResponse.refNo;
                                }else{
                                    accRec.CASA_Reference_Number__pc = casaPrimaryClientScreeningResponse.refNo;
                                }
                                GetRiskProfileClient_Resp_IB_v2 respBean = CVDashboardRiskRating_IH_v1.getRiskProfileClient(accRec, UserInfo.getUserId());
                                if(respBean == null || respBean.WQriskProfileClientV7Response == null || respBean.WQriskProfileClientV7Response.msgNo != 200){
                                    message = respBean.WQriskProfileClientV7Response.msg;
                                    message = message + 'Please try again after sometime if the error persists please call system Administrator';
                                    if(!test.isRunningTest()){
                                        AuraHandledException e = new AuraHandledException(message);
                                        e.setMessage(message);
                                        throw e; 
                                    }
                                }
                            }else{
                                message = casaPrimaryClientScreeningResponse.msg;
                                //system.debug(message);
                                if(!test.isRunningTest()){
                                    AuraHandledException e = new AuraHandledException(message);
                                    e.setMessage(message);
                                    throw e; 
                                }
                            }
                        }else{
                            message = casaPrimaryClientScreeningResponse.message;
                            //system.debug(message);
                            if(!test.isRunningTest()){
                                AuraHandledException e = new AuraHandledException(message);
                                e.setMessage(message);
                                throw e;
                            }
                        }
                    }
                    CVDashboardRiskRatingResponse_IB_v1 riskratingResponse  = CVDashboardRiskRating_IH_v1.getRiskRatingService(accRec);
                    //system.debug('%$ The RiskRating Response is: ' + riskratingResponse);
                    if(riskratingResponse.statusCode == 200){
                        String riskRatingValue = riskratingResponse.comments;
                        if(riskRatingValue != Null && riskRatingValue != ''){
                            String riskRating =riskRatingValue.SubStringBefore('-');
                            riskRating = RiskRating.trim();
                            String riskRatingTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_RISK_RATING_STRING, riskRating, StringConstants.INBOUND_RECORD_TYPE);
        					//System.debug('===riskRatingTranslated=====>'+riskRatingTranslated);
                            if(riskRatingTranslated != accRec.Risk_Rating__c && riskRatingTranslated != null){
                                updatingAccount = true;
                                accRec.Risk_Rating__c = riskRatingTranslated;
                            }
                        } 
                    }else{
                        message = 'The Risk Rating response is '+riskratingResponse.statusCode +' Please try again after sometime if the error persist conrtact System Aminsitrator';
                        if(!test.isRunningTest()){
                            AuraHandledException e = new AuraHandledException(message);
                            e.setMessage(message);
                            throw e;
                        }
                    } 
                    appRecList = new RegulatoryFinancialAccountsSelector().selectByAccountId(accRec.id);
                    compliancePackResponse = GetCompliancePackInfo_IH_v1.getComplianceInfo(accRec);
                    //system.debug('/* the response is --> ' +compliancePackResponse);
                    if(compliancePackResponse.statusCode == 200){
                        dataToBeSent = validateResponse(compliancePackResponse, appRecList, accRec);
                        if(dataToBeSent.message == null && dataToBeSent != null ){
                            updateAccount(accRec, dataToBeSent.nextRefreshDate, dataToBeSent.complianceStatus , dataToBeSent.FICLockStatus ,dataToBeSent.missingDocField,dataToBeSent.riskRating);}
                    }else{ //Exception Handling for different status code by Mohammed Junaid U -- start
                        message = 'The Compliance Pack Service response code is '+compliancePackResponse.statusCode;
                        //message = message +  compliancePackResponse.message;
                        
                        if(compliancePackResponse.statusCode == 500){
                            message = message +  '\n' + StringConstants.Sevice500InternalErrorMessage;
                        }
                        else if(compliancePackResponse.statusCode == 503){
                            message = message +  '\n' + StringConstants.Sevice500InternalErrorMessage;
                        }
                        else if(compliancePackResponse.statusCode == 400){
                            message = message +  '\n' + 'Bad Request please contact System Administrator';
                        }
                        else if(compliancePackResponse.statusCode == 401){
                            message = message +  '\n' + 'Unauthorized Error please contact System Administrator';
                        }
                        else if(compliancePackResponse.statusCode == 504){
                            message = message +  '\n' + 'Gateway Timeout the Jitterbit server is waiting too long to respond';
                        }
                        else{
                            message = message +  '\n' + 'Service temporarily unavailable please try again after sometime if the Error persist please call system administrator';
                        }
                        //system.debug(message);
                        if(!test.isRunningTest()){
                            //System.debug('Not test');
                            AuraHandledException e = new AuraHandledException(message);
                            e.setMessage(message);
                            throw e;
                            // throw new AuraHandledException(message);
                            //Exception Handling for different status code by Mohammed Junaid U -- End
                        } 
                    }
                }
                else{
                    message = 'There Is No Account In Salesforce';
                    //system.debug(message);
                    if(!test.isRunningTest()){
                        AuraHandledException e = new AuraHandledException(message);
                        e.setMessage(message);
                        throw e;
                    }
                }
            }
            else{
                message = 'There Is No Account In Salesforce';
                //system.debug(message);
                if(!test.isRunningTest()){
                    AuraHandledException e = new AuraHandledException(message);
                    e.setMessage(message);
                    throw e;
                }
            }
        }catch(exception ex){
            //system.debug('The Compliance Pack Service is not working correctly');
            //system.debug('the exception is --> '+ex.getMessage());
            if(!test.isRunningTest()){
                throw new AuraHandledException(ex.getMessage());
            }
        }
        
        if(dataToBeSent != null ){
            //system.debug('the data to be sent to UI is --> '+dataToBeSent);
            return dataToBeSent;
        }else{
            return null;
        }
    }
    
    /**
* @description Method to process the compliance view service response and create the data object for the UI to consume
* @param compliancePackResponse of type GetCompliancePackInfo_Resp_Parse
* @param appRecList of type Application__C
* @param accRec of type Account
* @return complianceData  object
**/
    public static ComplianceData validateResponse(GetCompliancePackInfo_Resp_Parse compliancePackResponse, list<Regulatory_Financial_Account__c> appRecList, account accRec){
        if(compliancePackResponse.statusCode == 200 && compliancePackResponse.code == null ){
            ComplianceData data = new ComplianceData();
            data.sourcesOfWealth = new list<string>();
            data.missingData = new list<string>();
            data.missingDocuments = new list<string>();
            data.refreshableDocuments = new list<string>();
            data.titleMap = new map<string, string>();
            data.accRec = accRec;
            //Getting all the NA Values from Custom Metadata and storing it in Map so that it can be used if the values are Null From responses by Mohammed Junaid U
            List<Compliance_Dashboard_NA_value__mdt> DashboardNaValues = [Select MasterLabel, Value__c from Compliance_Dashboard_NA_value__mdt];
            for(Compliance_Dashboard_NA_value__mdt CDM : DashboardNaValues){
                NAMapValues.put(CDM.MasterLabel,CDM.Value__c);
            }
            //system.debug('%$ The NA Map values are: ' + NAMapValues);
            data.IDNum = accRec.ID_Number__pc;
            //added beliw query to render the  compliance view dashboard between RB and HL
            //if current login user is in Homeloans service groups display HL_CVD parts else RB CVD
            if( ![Select id, Service_Group__r.Active__c from Service_Group_User_Entry__c Where User__c=:UserInfo.getUserId() AND Service_Group__c =: Label.HomeLoansServiceGroup AND Service_Group__r.Active__c=True LIMIT 1].isEmpty()){
                data.serviceGroup = true;
            }
            else{
                data.serviceGroup = false;
            }
            
            if(compliancePackResponse.content.riskRating == Null || compliancePackResponse.content.riskRating == ''){
                data.riskRating = compliancePackResponse.content.Party.riskRating;
            }else{
                data.riskRating = compliancePackResponse.content.riskRating;
            }
            data.partyType = compliancePackResponse.content.partyType;
            data.partySubType =  (compliancePackResponse.content.party.formalOrganisation != null) ? compliancePackResponse.content.party.formalOrganisation.Type.code : '';
            /*for(GetCompliancePackInfo_Resp_Parse.Relationships rel :compliancePackResponse.content.party.relationships){
                data.partyRelationship = rel.role.code;
            }
            system.debug('the partyRelationship -->' +data.partyRelationship);*/
            
            data.IDNumber = compliancePackResponse.content.primaryID.number_Z;
            //system.debug('the IDNumber -->' +data.IDNumber);
            //system.debug('at 109');
            if(compliancePackResponse.content.attestation != null && compliancePackResponse.content.attestation.address != null){
                //system.debug('at 111');
                /*for(GetCompliancePackInfo_Resp_Parse.address add : compliancePackResponse.content.attestation.address){*/
                //system.debug('at 115');
                
                GetCompliancePackInfo_Resp_Parse.address add = compliancePackResponse.content.attestation.address;
                //system.debug('the address is --> '+add);
                if(add.attestedAddress != Null){
                    data.cifAddress = (add.attestedAddress.addressName1 != null && add.attestedAddress.addressName1 != '')? add.attestedAddress.addressName1 + ', ' : data.cifAddress;
                    data.cifAddress = (add.attestedAddress.addressName2 != null && add.attestedAddress.addressName2 != '')? data.cifAddress + add.attestedAddress.addressName2 + ', ' : data.cifAddress ;
                    data.cifAddress = (add.attestedAddress.suburbName != null && add.attestedAddress.suburbName != '')? data.cifAddress + add.attestedAddress.suburbName + ', ' : data.cifAddress ;
                    data.cifAddress = (add.attestedAddress.cityName != null && add.attestedAddress.cityName != '')? data.cifAddress + add.attestedAddress.cityName + ', ' : data.cifAddress ;
                    data.cifAddress = (add.attestedAddress.countryName != null && add.attestedAddress.countryName != '')? data.cifAddress + add.attestedAddress.countryName + ', ' : data.cifAddress ;
                    data.cifAddress = (add.attestedAddress.postalCode != null && add.attestedAddress.postalCode != '')? data.cifAddress + add.attestedAddress.postalCode + ', ' : data.cifAddress ;
                    data.cifAddress = data.cifAddress.removeEnd(', ');
                    
                    data.addressName1 = add.attestedAddress.addressName1 != null ? add.attestedAddress.addressName1 : '';
                    data.addressName2 = add.attestedAddress.addressName2 != null ? add.attestedAddress.addressName2 : '' ;
                    data.suburbName = add.attestedAddress.suburbName != null ? add.attestedAddress.suburbName : '' ;
                    data.cityName = add.attestedAddress.cityName != null ? add.attestedAddress.cityName : '' ;
                    data.countryName = add.attestedAddress.countryName != null ? add.attestedAddress.countryName : '' ;
                    data.postalCode = add.attestedAddress.postalCode != null ? add.attestedAddress.postalCode : '' ;
                    
                    //system.debug('cifAddress is -->  '+data.cifAddress);
                }
                /*for(GetCompliancePackInfo_Resp_Parse.address add : compliancePackResponse.content.attestation.address){*/
                //system.debug('at 123');
                if(add.goldenSourceCachedAddresses != null){
                    data.goldenSourceAddress = add.goldenSourceCachedAddresses.addressName1 != null ? add.goldenSourceCachedAddresses.addressName1 + ', ' : '';
                    data.goldenSourceAddress = (add.goldenSourceCachedAddresses.addressName2 != null  && add.goldenSourceCachedAddresses.addressName2 != '')? data.goldenSourceAddress + add.goldenSourceCachedAddresses.addressName2  + ', ': '' ;
                    data.goldenSourceAddress = (add.goldenSourceCachedAddresses.suburbName != null && add.goldenSourceCachedAddresses.suburbName != '')? data.goldenSourceAddress + add.goldenSourceCachedAddresses.suburbName + ', ': data.goldenSourceAddress ;
                    data.goldenSourceAddress = (add.goldenSourceCachedAddresses.cityName != null && add.goldenSourceCachedAddresses.cityName != '')? data.goldenSourceAddress + add.goldenSourceCachedAddresses.cityName + ', ': data.goldenSourceAddress ;
                    data.goldenSourceAddress = (add.goldenSourceCachedAddresses.countryName != null && add.goldenSourceCachedAddresses.countryName != '')? data.goldenSourceAddress + add.goldenSourceCachedAddresses.countryName + ', ': data.goldenSourceAddress ;
                    data.goldenSourceAddress =  (add.goldenSourceCachedAddresses.postalCode != null && add.goldenSourceCachedAddresses.postalCode != '')? data.goldenSourceAddress + add.goldenSourceCachedAddresses.postalCode + ', ': data.goldenSourceAddress ;
                    data.goldenSourceAddress = data.goldenSourceAddress.removeEnd(', ');
                    //system.debug('thegoldenSourceAddress is -->  '+data.goldenSourceAddress);
                    
                    data.gAddressName1 = add.goldenSourceCachedAddresses.addressName1 != null ? add.goldenSourceCachedAddresses.addressName1 : '';
                    data.gAddressName2 = add.goldenSourceCachedAddresses.addressName2 != null ? add.goldenSourceCachedAddresses.addressName2 : '' ;
                    data.gSuburbName = add.goldenSourceCachedAddresses.suburbName != null ? add.goldenSourceCachedAddresses.suburbName : '' ;
                    data.gCityName = add.goldenSourceCachedAddresses.cityName != null ? add.goldenSourceCachedAddresses.cityName : '' ;
                    data.gCountryName = add.goldenSourceCachedAddresses.countryName != null ? add.goldenSourceCachedAddresses.countryName : '' ;
                    data.gpostalCode = add.goldenSourceCachedAddresses.postalCode != null ? add.goldenSourceCachedAddresses.postalCode : '' ;
                }
                
                //}
                
            }
            
            if(compliancePackResponse.content.complianceRequirements != null){
                if(compliancePackResponse.content.complianceRequirements.missingData != null){
                    for(string s: compliancePackResponse.content.complianceRequirements.missingData){
                        data.missingData.add(s);
                    }
                }
                if(compliancePackResponse.content.complianceRequirements.missingDocuments != null){
                    for(GetCompliancePackInfo_Resp_Parse.ArrangementType md: compliancePackResponse.content.complianceRequirements.missingDocuments ){
                        data.missingDocuments.add(md.code);
                    }
                }
                if(compliancePackResponse.content.complianceRequirements.refreshableDocuments != null){
                    for( GetCompliancePackInfo_Resp_Parse.AttestedAddressDocument ref: compliancePackResponse.content.complianceRequirements.refreshableDocuments ){
                        data.refreshableDocuments.add(ref.type.code);
                    }
                }
                MisssingFICARequirement.documentData missingFICA= new MisssingFICARequirement.documentData();
                missingFICA.missingDocuments = new List<string>();
            	missingFICA.refreshableDocuments = new List<string>();
            	missingFICA.missingFields = new List<string>();
                missingFICA.missingDocuments.addAll(data.missingDocuments);
                missingFICA.refreshableDocuments.addAll(data.refreshableDocuments);
                missingFICA.missingFields.addAll(data.missingData);
                String jSONString = JSON.serialize(missingFICA);
                //system.debug('!@#The Serialized String is : '+jSONString);
                data.missingDocField = jSONString;
                data.complianceStatus = compliancePackResponse.content.complianceRequirements.complianceStatus;
                //system.debug('the complianceStatus -->' +data.complianceStatus);
                
                data.nextRefreshDate = compliancePackResponse.content.complianceRequirements.nextRefreshDate;
                //system.debug('the nextRefreshDate is --> '+data.nextRefreshDate);
            }
            //For Days of Anniversary the logic is as given below Replacing the NA value by Mohammed Junaid U
            if(data.nextRefreshDate != Null && data.nextRefreshDate != ''){
                date NextDate = Date.valueOf(data.nextRefreshDate);
                date LastDate = Date.today();
                Integer difference = LastDate.daysBetween(NextDate) ;
                //system.debug('%$ the date difference is: '+difference);
                data.daysDue = string.valueof(difference);
            }
            
            //system.debug('%$ the lastrefreshdate is --> '+data.lastrefreshDate);
            
            for(GetCompliancePackInfo_Resp_Parse.ArrangementType d : compliancePackResponse.Content.party.sourcesOfIncome ){
                data.sourcesOfWealth.add(d.description);
            }
            //system.debug('the sourcesOfWealth -->' +data.sourcesOfWealth);
            
            if(compliancePackResponse.content.party.individual != null){
                if(compliancePackResponse.content.party.individual.name != null
                   && compliancePackResponse.content.party.individual.surname != null
                   && compliancePackResponse.content.party.individual.initials != null){
                       data.fullName = compliancePackResponse.content.party.individual.name +' '+ compliancePackResponse.content.party.individual.surname +' '+ compliancePackResponse.content.party.individual.initials;
                       //system.debug('the fullName -->' +data.fullName);
                       
                       if(compliancePackResponse.content.party.individual.salutation.description != null){
                           data.titleMap.put(data.fullname, compliancePackResponse.content.party.individual.salutation.description);
                           //system.debug('the titleMap -->' +data.titleMap);
                       }
                   }
                
                data.subStatus = compliancePackResponse.content.party.individual.subStatus != null ? compliancePackResponse.content.party.individual.subStatus.description : '';
                //system.debug('the subStatus -->' +data.subStatus);
                
                //data.FICAAddressAttestedDate = compliancePackResponse.content.party.individual.ficaAddressAttestedDate != null && compliancePackResponse.content.party.individual.ficaAddressAttestedDate != '' ? compliancePackResponse.content.party.individual.ficaAddressAttestedDate : NAMapValues.get('FICA Attested Address') ; //Replacing NA values by System label as suggested by BA by Mohammed Junaid U
                //system.debug('the FICAAddressAttestedDate -->' +data.FICAAddressAttestedDate);
                
                data.occupation = compliancePackResponse.content.party.individual.occupationStatus != null ? compliancePackResponse.content.party.individual.occupationStatus : '';
                //system.debug('the occupation -->' +data.occupation);
                
                /*data.FICLockStatus = compliancePackResponse.content.party.individual.subStatus != null ?  compliancePackResponse.content.party.individual.subStatus.code : NAMapValues.get('FIC Lock Status'); //Replacing NA values by system label values as suggested by BA by Mohammed Junaid U
                //system.debug('the FICLockStatus -->' +data.FICLockStatus); */
                
                //data.IdentificationAttestedDate = compliancePackResponse.content.party.individual.identificationAttestedDate != null && compliancePackResponse.content.party.individual.identificationAttestedDate != '' ? compliancePackResponse.content.party.individual.identificationAttestedDate : NAMapValues.get('Identification Address attested'); //Replacing NA values by system label as suggested by BA by Mohammed Junaid U
                //system.debug('the IdentificationAttestedDate -->' +data.IdentificationAttestedDate);
                
                /*data.PEPStatus = compliancePackResponse.content.party.individual.PEPStatus != null ? compliancePackResponse.content.party.individual.PEPStatus.code : NAMapValues.get('Pep Status');  //Replacing NA values by system label values as suggested by BA by Mohammed Junaid U
                //system.debug('the PEPStatus -->' +data.PEPStatus); */
            }
			if(compliancePackResponse.content.party.individual != null){
                if(compliancePackResponse.content.party.individual.PEPStatus != null){
                    data.PEPStatus = compliancePackResponse.content.party.individual.PEPStatus.Code;
                }
                if(compliancePackResponse.content.party.individual.subStatus != null){
                    data.FICLockStatus = compliancePackResponse.content.party.individual.subStatus.Code;
                }
                data.FICAAddressAttestedDate = compliancePackResponse.content.party.individual.ficaAddressUpdateDate != null && compliancePackResponse.content.party.individual.ficaAddressUpdateDate != '' ? compliancePackResponse.content.party.individual.ficaAddressUpdateDate : NAMapValues.get('Identification Address attested'); //Replacing NA values by system label as suggested by BA by Mohammed Junaid U
                data.IdentificationAttestedDate = compliancePackResponse.content.party.individual.identificationUpdateDate != null && compliancePackResponse.content.party.individual.identificationUpdateDate != '' ? compliancePackResponse.content.party.individual.identificationUpdateDate : NAMapValues.get('Identification Address attested'); //Replacing NA values by system label as suggested by BA by Mohammed Junaid U
            }
            if(compliancePackResponse.content.party.informalOrganisation != null){
                if(compliancePackResponse.content.party.informalOrganisation.PEPStatus != null){
                    data.PEPStatus = compliancePackResponse.content.party.informalOrganisation.PEPStatus.Code;
                }
                if(compliancePackResponse.content.party.informalOrganisation.subStatus != null){
                    data.FICLockStatus = compliancePackResponse.content.party.informalOrganisation.subStatus.Code;
                }
                data.FICAAddressAttestedDate = compliancePackResponse.content.party.informalOrganisation.ficaAddressUpdateDate != null && compliancePackResponse.content.party.informalOrganisation.ficaAddressUpdateDate != '' ? compliancePackResponse.content.party.informalOrganisation.ficaAddressUpdateDate : NAMapValues.get('Identification Address attested'); //Replacing NA values by system label as suggested by BA by Mohammed Junaid U
                data.IdentificationAttestedDate = compliancePackResponse.content.party.informalOrganisation.identificationUpdateDate != null && compliancePackResponse.content.party.informalOrganisation.identificationUpdateDate != '' ? compliancePackResponse.content.party.informalOrganisation.identificationUpdateDate : NAMapValues.get('Identification Address attested'); //Replacing NA values by system label as suggested by BA by Mohammed Junaid U
                
            }
            if(compliancePackResponse.content.party.formalOrganisation != null){
                if(compliancePackResponse.content.party.formalOrganisation.PEPStatus != null){
                    data.PEPStatus = compliancePackResponse.content.party.formalOrganisation.PEPStatus.Code;
                }
                if(compliancePackResponse.content.party.formalOrganisation.subStatus != null){
                    data.FICLockStatus = compliancePackResponse.content.party.formalOrganisation.subStatus.Code;
                }
                data.FICAAddressAttestedDate = compliancePackResponse.content.party.formalOrganisation.ficaAddressUpdateDate != null && compliancePackResponse.content.party.formalOrganisation.ficaAddressUpdateDate != '' ? compliancePackResponse.content.party.formalOrganisation.ficaAddressUpdateDate : NAMapValues.get('Identification Address attested'); //Replacing NA values by system label as suggested by BA by Mohammed Junaid U
                data.IdentificationAttestedDate = compliancePackResponse.content.party.formalOrganisation.identificationUpdateDate != null && compliancePackResponse.content.party.formalOrganisation.identificationUpdateDate != '' ? compliancePackResponse.content.party.formalOrganisation.identificationUpdateDate : NAMapValues.get('Identification Address attested'); //Replacing NA values by system label as suggested by BA by Mohammed Junaid U
                
            }
			
            if(data.FICAAddressAttestedDate == Null || data.FICAAddressAttestedDate == ''){
                data.FICAAddressAttestedDate = NAMapValues.get('FICA Attested Address');
            }
            if(data.IdentificationAttestedDate == Null || data.IdentificationAttestedDate == ''){
                data.IdentificationAttestedDate = NAMapValues.get('Identification Address attested');
            }
            if(data.PEPStatus == Null || data.PEPStatus == ''){
                data.PEPStatus = NAMapValues.get('Pep Status');
            }
            if(data.FICLockStatus == Null || data.FICLockStatus == ''){
                data.FICLockStatus = NAMapValues.get('FIC Lock Status');
            }
            if(data.partySubType == Null || data.partySubType == ''){
                data.partySubType = NAMapValues.get('Party subType');
            }
            if(data.occupation == Null || data.occupation == ''){
                data.occupation = NAMapValues.get('Occupation');
            }
            if(data.complianceStatus == Null || data.complianceStatus == ''){
                data.complianceStatus = NAMapValues.get('Compliance Status');
            }
            if(data.riskRating == Null || data.riskRating == ''){
                data.riskRating = NAMapValues.get('Risk Category');
            }
            if(data.nextRefreshDate == Null || data.nextRefreshDate == ''){
                data.nextRefreshDate = NAMapValues.get('Next Refresh Date');
            }
            /*if(data.lastrefreshDate == Null || data.lastrefreshDate == ''){
data.lastRefreshDate = NAMapValues.get('Last Refresh Date'); //Replacing NA values by system label values as suggested by BA by Mohammed Junaid U
} */
            if(data.partyType == Null || data.partyType == ''){
                data.partyType = NAMapValues.get('Party Relationship'); //Replacing NA values by system label values as suggested by BA by Mohammed Junaid U
            }
            
            data.purposeOfAccount = (appRecList != null && appRecList.size() > 0 && appRecList[0].purpose_of_account__c != null && appRecList[0].purpose_of_account__c != '' ? appRecList[0].purpose_of_account__c : NAMapValues.get('Purpose of Account') );
            data.sourceOfFunds = (appRecList != null && appRecList.size() > 0 && appRecList[0].source_of_funds__c != null && appRecList[0].source_of_funds__c != '' ? appRecList[0].source_of_funds__c : NAMapValues.get('Source Of Funds') );
            data.notificationSent = ( accRec.Notification_sent__c != null && accRec.Notification_sent__c != '' ? accRec.Notification_sent__c : NAMapValues.get('Party Engagement') ); //Replacing NA values by system label values as suggested by BA by Mohammed Junaid U
            //data.daysDue = (accRec.Days_Due_F__c != null ? string.valueof(accRec.Days_Due_F__c) : '') ;
            data.expectedTransactionActivity = (appRecList != null && appRecList.size() > 0 && appRecList[0].Account_Activity_Calculator__c != null && appRecList[0].Account_Activity_Calculator__c != '' ? appRecList[0].Account_Activity_Calculator__c : NAMapValues.get('Expected Account Activity'));
            data.DataLightning = getTableFields(accRec.Id,compliancePackResponse);
            // To check if the current logged in User is same as Relationship Banker and to hide or display the PEP status accordingly by Mohammed Junaid U
            if(accRec.Relationship_Banker_Name__c == UserInfo.getUserId()){
                //('/* The Banker are same');
                data.IsRBBBanker = True;
            }
            else{
                data.IsRBBBanker = False;
            }
            data.NADashboardValues = NAMapValues;
            //system.debug('/* It is the RBBBanker:  '+data.IsRBBBanker);
            //system.debug('the data object is --> '+data);
            if(compliancePackResponse.content.attestation != null){
                if(compliancePackResponse.content.complianceRequirements.complianceStatus != 'Compliant'){
                    data.attestation = true;
                }else{
                    data.attestation = false;
                }
                if(compliancePackResponse.content.attestation.sourcesOfIncome != null){
                    for(GetCompliancePackInfo_Resp_Parse.ArrangementType md: compliancePackResponse.content.attestation.sourcesOfIncome ){
                        data.attestationSourceOfIncome = md.code;
                    }
                    //data.attestationSourceOfIncome = compliancePackResponse.content.attestation.sourcesOfIncome.description;
                }
                data.attestationstatus = compliancePackResponse.content.attestation.status;
            }else{
                data.attestation = false; 
            }
            return data;
        } else if(compliancePackResponse.statusCode == 200 && compliancePackResponse.code != null ) {
            ComplianceData data = new ComplianceData();
            data.message = compliancePackResponse.description;
            //system.debug('the data object is --> '+data);
            return data;
        }
        else{
            //system.debug('the compliance pack service response code is not 200');
            return null;
        }
    }
    
    /**
* @description 
* @author mohammedjunaid.usman@absa.africa | 2021-06-25 
* @param Acc 
* @param nextRefreshDate 
* @param complianceStatus 
* @param FICLockStatus 
* @param mandatoryRequirements
* @param riskStatus
**/
    public static void updateAccount(account Acc, string nextRefreshDate, string complianceStatus, string FICLockStatus,string mandatoryRequirements ,string riskStatus ){
        try{
            string previousComplianceStatus = Acc.Compliance_Status__c;
            if(nextRefreshDate != null && !string.isblank(nextRefreshDate)  && nextRefreshDate != NAMapValues.get('Next Refresh Date') && Acc.Next_Refresh_Date__c != date.valueOf(nextRefreshDate) ){
                Acc.Next_Refresh_Date__c = date.valueOf(nextRefreshDate);
                updatingAccount = True;
            }
            if(complianceStatus != null && !string.isblank(complianceStatus) && Acc.Compliance_Status__c != complianceStatus){
                Acc.Compliance_Status__c = complianceStatus;
                updatingAccount = True;
            }
            if(FICLockStatus != null && !string.isblank(FICLockStatus) && Acc.Lock_Status__c != FICLockStatus){
                Acc.Lock_Status__c = FICLockStatus;
                updatingAccount = True;
            }
            /*if(riskStatus != null && !string.isblank(riskStatus) && Acc.Risk_Rating__pc != riskStatus){
                Acc.Risk_Rating__pc = riskStatus;
                updatingAccount = True;
            }*/
            if(mandatoryRequirements != null && !string.isblank(mandatoryRequirements) && Acc.FICA_Requirements__c != mandatoryRequirements){
				Acc.FICA_Requirements__c = mandatoryRequirements;
				updatingAccount = True;
			}
            if(updatingAccount){
                Acc.Valid_Update_Bypass__c= True; //To bypass the Validation set
                //system.debug('Updating the nextRefreshDate on the Accont Object');
                database.update(acc, False); }
            if(complianceStatus == 'Compliant' && complianceStatus != previousComplianceStatus ){
                set<string> statusVal = new set<string>();
                statusVal.add('Resolved');
                statusVal.add('Unwanted');
                List<case> ficCaseList = new CasesSelector().selectCaseByFICStatusAndSubject(Acc.Id,statusVal,'FIC Refresh');
                For(Case c : ficCaseList ){
                    c.status = 'Resolved';
                }
                if(ficCaseList.size()>0){
                    database.update(ficCaseList, False);}}
            
        }catch(DmlException ex) {
            if(!test.isRunningTest()){
                throw new AuraHandledException(ex.getMessage());
            }
        }    
    }
    
    /**
* @description Makes the callout to Hanis service
* @param idNumber
* @return String HanisValidate_Resp_IB_v1 bean object
**/
    @AuraEnabled
    public static String callHanisService(String idNumber){
        try{
            Map<HanisValidate_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = HanisValidate_IH_v1.HanisValidate(idNumber);
            HanisValidate_Resp_IB_v1 responseBean = (new List<HanisValidate_Resp_IB_v1>(responseMap.keySet()))[0];
            List<Sys_Log_Integration__c> hanisLogs = responseMap.values()[0];
            //System.debug('#####' + responseBean.serialize(responseBean) + '#####');
            if(hanisLogs!=null && !hanisLogs.isEmpty()){
                Insert hanisLogs;
            }
            return responseBean.serialize(responseBean);
        } catch(Exception exc){
            //System.debug('Exception Occured'+exc.getMessage()+ 'At Line number'+exc.getLineNumber());
            throw new AuraHandledException('Something went wrong: '+ exc.getMessage());
        }
    }
    
    /**
* @description Method to send the missing data and missing documents to the lightning data table
* @param objectId
* @param compliancePackResponse
* @return List<DataTableColumns>
**/
    @AuraEnabled
    public static List<DataTableColumns> getTableFields(string objectId, GetCompliancePackInfo_Resp_Parse compliancePackResponse ){
        string message;
        string source;
        //GetCompliancePackInfo_Resp_Parse compliancePackResponse;
        //To hold the table columns
        List<DataTableColumns> lstDataColumns = new List<DataTableColumns>();
        Account accRec = new AccountsSelector().selectAllById(objectId);
        //system.debug('Before Adding the missing Data --> ' +lstDataColumns);
        if(compliancePackResponse.content.complianceRequirements != null){
            // Hidding the conflicting Address Scenario as the Compliance status in FICA Engine Depends only on the documents By Mohammed Junaid U
            /*   if(compliancePackResponse.content.complianceRequirements.missingData != null){
for(string s: compliancePackResponse.content.complianceRequirements.missingData){
DataTableColumns datacolumn = new DataTableColumns( s, 'Missing Information', 'Yes', '', '' );
lstDataColumns.add(dataColumn);
}
} */
            //system.debug('After Adding the missing Data --> ' +lstDataColumns);
            
            //system.debug('before missing documents -->' +lstDataColumns);
            
            if(compliancePackResponse.content.complianceRequirements.missingDocuments != null){
                for(GetCompliancePackInfo_Resp_Parse.ArrangementType md: compliancePackResponse.content.complianceRequirements.missingDocuments ){
                    //DataTableColumns datacolumn = new DataTableColumns( md.code, 'Missing Document', 'Yes', '', '' );
                    DataTableColumns datacolumn = new DataTableColumns('--', md.code, 'Yes', '', 'Missing Document' /*, 'Upload', 'Download'*/);
                    lstDataColumns.add(dataColumn);
                }
            }
            //system.debug('after missing documents --> '+lstDataColumns);
            // Hidding the conflicting Address Scenario as the Compliance status in FICA Engine Depends only on the documents By Mohammed Junaid U
            /*    if(compliancePackResponse.content.attestation != null && compliancePackResponse.content.attestation.address != null){
GetCompliancePackInfo_Resp_Parse.address add = compliancePackResponse.content.attestation.address;
if(add.attestedAddress != null && add.goldenSourceCachedAddresses != null){
source = 'CIF / Golden Source';
}else if(add.goldenSourceCachedAddresses != null ){
source = 'Golden Source';
}else if(add.attestedAddress != null ){
source = 'CIF';
}
DataTableColumns datacolumn = new DataTableColumns( 'Address', 'Conflicting Information', 'Yes', source, '' );
lstDataColumns.add(dataColumn);
} */
            
            //system.debug('before reusable documents -->' +lstDataColumns);
            /* if(compliancePackResponse.content.complianceRequirements.reusableDocuments != null){
for( GetCompliancePackInfo_Resp_Parse.AttestedAddressDocument rd: compliancePackResponse.content.complianceRequirements.reusableDocuments ){
//DataTableColumns datacolumn = new DataTableColumns( rd.type.code, 'Reusable Document', 'Yes', rd.source, rd.subType.code );
DataTableColumns datacolumn = new DataTableColumns('--', rd.type.code, 'Yes', rd.source, 'Reusable Document');
lstDataColumns.add(dataColumn);
}
}
system.debug('after reusable documents -->' +lstDataColumns);  */
            
            //system.debug('before refreshable documents -->' +lstDataColumns);
            if(compliancePackResponse.content.complianceRequirements.refreshableDocuments != null){
                for( GetCompliancePackInfo_Resp_Parse.AttestedAddressDocument ref: compliancePackResponse.content.complianceRequirements.refreshableDocuments ){
                    //DataTableColumns datacolumn = new DataTableColumns( ref.type.code,'Refreshable Document', 'Yes', ref.source, ref.subType.code );
                    DataTableColumns datacolumn = new DataTableColumns('--', ref.type.code, 'Yes', ref.source, 'Refreshable Document' /*, 'Upload', 'Download'*/);
                    lstDataColumns.add(dataColumn);
                }
            }
            // }
        }
        //system.debug('after refreshable documents -->' +lstDataColumns);
        
        return lstDataColumns;
    }
    
    /**
* @description method used to save the document uploaded from the fileUpload component
* @param parentId
* @param fileName
* @param base64Data
* @param contentType
* @param fileId
* @param documentType
* @return Id Attachement Record ID
**/
    @AuraEnabled
    public static Id saveInChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId, string documentType) {
        // check if fileId id ''(Always blank in first chunk), then call the saveTheFile method,
        //  which is save the check data and return the attachemnt Id after insert,
        //  next time (in else) we are call the appentTOFile() method
        //   for update the attachment with reamins chunks
        string attachID = fileId;
        try{
            if(attachID == ''){
                attachID = saveTheFile(parentId, fileName, base64Data, contentType);
            }else{
                appendToFile(attachID, base64Data);
            }
            
            /*if(done){
completeUpload(attachID, documentType);
} */
        }catch (exception e){
            //system.debug('the exception message is --> ' +e);
            throw new AuraHandledException(e.getMessage());
        }
        
        return Id.valueOf(attachID);
    }
    
    /**
* @description A method to save to an uploaded file in the attachment object.
* @param parentId
* @param fileName
* @param base64Data
* @param contentType
* @return Id Atttachment Record ID
**/
    public static Id saveTheFile(Id parentId, String fileName, String base64Data, String contentType) {
        Attachment oAttachment = new Attachment();
        try{
            base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
            oAttachment.parentId = parentId;
            oAttachment.Body = EncodingUtil.base64Decode(base64Data);
            oAttachment.Name = fileName;
            oAttachment.ContentType = contentType;
            insert oAttachment;
            return oAttachment.Id;
        }catch(DmlException ex) {
            if(!test.isRunningTest()){
                throw new AuraHandledException(ex.getMessage());
            }
        }
        return Null;
    }
    
    /**
* @description A method to append to an existing file in the attachment object.
* @param fileId Id of existing file that has already been saved to Attachment object.
* @param base64Data body of the file.
**/
    public static void appendToFile(Id fileId, String base64Data) {
        try{
            base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
            //system.Debug('the file id is --> '+fileId);
            Attachment a = [SELECT Id, Body FROM Attachment WHERE Id =: fileId];
            //system.Debug('before string asssingment');
            String existingBody = EncodingUtil.base64Encode(a.Body);
            a.Body = EncodingUtil.base64Decode(existingBody + base64Data);
            //('before updating the attachment');
            update a;
        }catch(DmlException ex) {
            if(!test.isRunningTest()){
                throw new AuraHandledException(ex.getMessage());
            }
        } 
    }
    
    /**
* @description A method to retrieve to an uploaded file from the AMBER
* @param parentId
* @param documentType
* @return map<string, string>
**/
    @AuraEnabled
    public static map<string, string> getUploadedDoc(String parentId, String documentType) {
        string PID;
        map<string, string> getDocResult = new map<string, string>();
        ECM_LoginResult_IB_V1 login;
        List<Document__c> documentsList = new DocumentsSelector().selectByTypeAndaccId(parentId,documentType);
        For(document__c doc : documentsList){
            //System.debug('The Document id is: '+doc.Id);
            if(doc.type__c.deleteWhitespace().equalsIgnoreCase(documentType) || doc.type__c.equalsIgnoreCase(documentType)){
                PID = doc.reference__c;
            }
        }
        
        //Getting the login credentials from integration service and getting request token from the endpoint url
        if(PID == Null){
            //system.debug('There is no document for the selected document Type');
            string message = 'there is no document in AMBER for the selected Document Type';
            if(!test.isRunningTest()){
                throw new AuraHandledException(message);
            }
        }else{
            
            CIS_GetDocResult_IB_V1 getDocResultclass = CIS_IH_v1.downloadDocument(PID);
            if(getDocResultclass.statusCode == 200){
                //Object contentData = getDocResultclass.Content;
                if(getDocResultclass.Content != Null){
                    getDocResult.put('Data',getDocResultclass.Content.Data);
                    getDocResult.put('FileName',getDocResultclass.Content.FileName);
                }}
            else{
                string message = 'The Amber Service Response was '+getDocResultclass.statusCode+ ' Please contact system administrator if the error persists';    
                if(!test.isRunningTest()){
                    throw new AuraHandledException(message);}
            }
        }
        
        if (getDocResult != null && getDocResult.get('Data') != Null){
            return getDocResult;
        } else{
            
            return null;
        }
    }
    
    /**
* @description Async call to make the callout to login and upload the document to the Amber
* @param fileId
* @param documentType
* @param subDocumentType1
* @return String pID
**/
    @AuraEnabled
    public static String completeUpload(String fileId, String documentType, string subDocumentType1) {
        String fileReference;
        Attachment attach = [SELECT Id, Body, Name, ParentId FROM Attachment WHERE Id =: fileId];
        String fileName = attach.Name;
        Id parentId = attach.ParentId;
        //Account acc = [SELECT Id, Registration_Number__c, ID_Number__pc, CIF__c FROM Account WHERE Id =:parentId];
        Account acc = new AccountsSelector().selectAllById(parentId);
        //Getting the login credentials from integration service and getting request token from the Jitterbit login endpoint url
        // Change the code to follow absa framework.
        //system.debug('*% The Document subtype is: '+subDocumentType1);
        CIS_AddDocResult_IB_v1 addDocRequest = CIS_IH_v1.UploadDocument(fileName,documentType,attach,acc,subDocumentType1,'false','','');
        //system.debug('*$ The Addrequest Response is: '+addDocRequest);
        if(addDocRequest.statusCode == 200){
            if( addDocRequest.AddResult.Status != 'ERROR' )  {
                if(documentType == 'ProofOfAddress' || documentType == 'ProofOfId'){
                    if(addDocRequest.OcrDocResults != Null){
                        string confidenceMessage = addDocRequest.OcrDocResults.ConfidenceMessage;
                        confidenceMessage.toLowercase();
                        if(confidenceMessage.contains('exception')){
                            String message = addDocRequest.OcrDocResults.ConfidenceMessage.substringBefore('Please');
                            if(message.toLowerCase().contains('no dha')){
                                message = message + 'Please advise customer to contact the DHA to update their details';
                            }else{
                                message = message +'Please obtain acceptable/valid documents from customer';
                            }
                            if(!test.isRunningTest()){
                                throw new AuraHandledException(message);}
                        }else if(addDocRequest.OcrDocResults.Confidence == 'Low'){
                            String message = addDocRequest.OcrDocResults.ConfidenceMessage;
                            message = message +'Please obtain acceptable/valid documents from customer';
                            if(!test.isRunningTest()){
                                throw new AuraHandledException(message);}}
                        else{
                            fileReference = addDocRequest.Pid;
                        }
                    }else{
                        String message = 'OCR Process failed please upload the document again';
                        if(!test.isRunningTest()){
                            throw new AuraHandledException(message);}
                    }
                }else{
                    fileReference = addDocRequest.Pid;}
            }else{
                String message = addDocRequest.AddResult.Detail;
                if(!test.isRunningTest()){
                    throw new AuraHandledException(message);}
            }
        }else{
            string message = 'The Amber Service Response was '+addDocRequest.statusCode+ ' Please contact system administrator if the error persists';    
            if(!test.isRunningTest()){
                throw new AuraHandledException(message);}
        }
        //system.debug('the pid is--> '+filereference);
        
        //adding the document record in Salesforce with the PID received as the response from AMBER
        if(filereference != null){
            addDocumentItem(fileName, parentId, fileReference, documentType,subDocumentType1);
            return fileReference;
        }else{
            string msg = 'There was a problem uploading the document to Amber';
            if(!test.isRunningTest()){
                throw new AuraHandledException(msg);}
            return Null;
        }
    }
    
    /**
* @description creates a document in salesforce with the file reference from AMBER.
* @param fileName
* @param parentId
* @param fileReference
* @param documentType
* @param documentSubType
**/
    @AuraEnabled
    public static void addDocumentItem(String fileName, Id parentId, String fileReference, String documentType, String documentSubType) {
        List<Document__c> documentsList = new DocumentsSelector().selectByTypeAndaccId(parentId,documentType);
        try{
            if(documentsList.size()>0){
                documentsList[0].Name = fileName;
                documentsList[0].Reference__c = fileReference;
                documentsList[0].Document_Sub_Type__c = documentSubType;
                Update documentsList;
            }else{
                Document__c doc = new Document__c();
                doc.Name = fileName;
                doc.Type__c = documentType;
                doc.Account__c = parentId;
                doc.Reference__c = fileReference;
                doc.Document_Sub_Type__c = documentSubType;  
                insert doc;}
        }catch(DmlException ex) {
            if(!test.isRunningTest()){
                throw new AuraHandledException(ex.getMessage());
            }
        } 
    }
    /**
* @description Wrapper class to hold Column values of missing data and missing documents
*/
    public class DataTableColumns {
        
        /**
* @description
*/
        @AuraEnabled
        public String missingData {get;set;}
        /**
* @description
*/
        @AuraEnabled
        public String missingDoc {get;set;}
        /**
* @description
*/
        @AuraEnabled
        public String required {get;set;}
        /**
* @description
*/
        @AuraEnabled
        public String source {get;set;}
        /**
* @description
*/
        @AuraEnabled
        public String status {get;set;}
        
        /**
* @description Create and set three variables label, fieldname and type as required by the lightning:datatable
* @param missingData
* @param missingDoc
* @param required
* @param source
* @param status
**/
        public DataTableColumns(String missingData, String missingDoc, String required, String source, String status/*, String upload, String view*/){
            this.missingData = missingData;
            this.missingDoc = missingDoc;
            this.required = required;
            this.source = source;
            this.status = status;
        }
    }
    /**
* @description Container class that stores the Compliance Data to be displayed in the UI
*/
    public class ComplianceData{
        /**
* @description
*/
        @AuraEnabled public Account accRec {get;set;}
        /**
* @description
*/
        @AuraEnabled public string message {get;set;}
        /**
* @description serviceGroup is used in HL part
*/
        @AuraEnabled public Boolean serviceGroup {get;set;}
        /**
* @description
*/
        @AuraEnabled public string riskRating {get;set;}
        /**
* @description
*/
        @AuraEnabled public string fullName {get;set;}
        /**
* @description
*/
        @AuraEnabled public string partyType {get;set;}
        /**
* @description
*/
        @AuraEnabled public string partySubType {get;set;}
        /**
* @description
*/
        @AuraEnabled Public string IDNumber {get;set;}
        /**
* @description
*/
        @AuraEnabled Public string IDNum {get;set;}
        /**
* @description
*/
        @AuraEnabled Public map<string, string> titleMap {get;set;}
        /**
* @description
*/
        @AuraEnabled Public string[] sourcesOfWealth {get;set;}
        /**
* @description
*/
        @AuraEnabled Public string occupation {get;set;}
        /**
* @description
*/
        @AuraEnabled Public string FICAAddressAttestedDate {get;set;}
        /**
* @description
*/
        @AuraEnabled Public string IdentificationAttestedDate {get;set;}
        /**
* @description
*/
        @AuraEnabled Public string subStatus {get;set;}
        /**
* @description
*/
        @AuraEnabled Public string nextRefreshDate {get;set;}
        /**
* @description
*/
        @AuraEnabled Public string FICLockStatus {get;set;}
        /**
* @description
*/
        @AuraEnabled Public string PEPStatus {get;set;}
        /**
* @description
*/
        @AuraEnabled public string purposeOfAccount {get;set;}
        /**
* @description
*/
        @AuraEnabled public string sourceOfFunds {get;set;}
        /**
* @description
*/
        @AuraEnabled public string notificationSent {get;set;}
        /**
* @description
*/
        @AuraEnabled public string daysDue {get;set;}
        /**
* @description
*/
        @AuraEnabled public string expectedTransactionActivity {get;set;}
        /**
* @description
*/
        @AuraEnabled Public string complianceStatus {get;set;}
        /**
* @description
*/
        @AuraEnabled Public string addressName1 {get;set;}
        /**
* @description
*/
        @AuraEnabled Public string addressName2 {get;set;}
        /**
* @description
*/
        @AuraEnabled Public string suburbName {get;set;}
        /**
* @description
*/
        @AuraEnabled Public string cityName {get;set;}
        /**
* @description
*/
        @AuraEnabled Public string countryName {get;set;}
        /**
* @description
*/
        @AuraEnabled Public string postalCode {get;set;}
        /**
* @description
*/
        @AuraEnabled Public string cifAddress {get;set;}
        /**
* @description
*/
        @AuraEnabled Public string gAddressName1 {get;set;}
        /**
* @description
*/
        @AuraEnabled Public string gAddressName2 {get;set;}
        /**
* @description
*/
        @AuraEnabled Public string gSuburbName {get;set;}
        /**
* @description
*/
        @AuraEnabled Public string gCityName {get;set;}
        /**
* @description
*/
        @AuraEnabled Public string gCountryName {get;set;}
        /**
* @description
*/
        @AuraEnabled Public string gPostalCode {get;set;}
        /**
* @description
*/
        @AuraEnabled Public string goldenSourceAddress {get;set;}
        /**
* @description
*/
        @AuraEnabled Public string[] missingData {get;set;}
        /**
* @description
*/
        @AuraEnabled Public string[] missingDocuments {get;set;}
        /**
* @description
*/
        @AuraEnabled Public List<DataTableColumns> DataLightning {get;set;}
        /**
* @description
*/
        @AuraEnabled Public Boolean IsRBBBanker {get;set;}
        /**
* @description
*/
        @AuraEnabled Public map<string, string> NADashboardValues {get;set;}
        /**
* @description
*/
        @AuraEnabled Public string attestationstatus {get;set;}
        /**
* @description
*/
        @AuraEnabled Public string attestationSourceOfIncome {get;set;}
        /**
* @description
*/
        @AuraEnabled Public Boolean attestation {get;set;}
        /**
* @description
*/
@AuraEnabled Public string[] refreshableDocuments {get;set;}
/**
* @description
*/
@AuraEnabled Public string missingDocField {get;set;}
        
    }
    /**
* @description getting Document Subtypes
* @param ParentDocumentType
* @return List<String>
**/
    @AuraEnabled
    public static List<String> getDocumentSubType(string ParentDocumentType) {
        List<String> childDocumentPicklistValues = new List<String>();
        ParentDocumentType = ParentDocumentType.deleteWhitespace();
        ParentDocumentType = 'Ent_' + ParentDocumentType;
        //system.debug('the parent Document type is: '+ParentDocumentType);
        List<Document_Template__c> documentTemplates = new  DocumentTemplateSelector().selectTemplateByECMItemType(ParentDocumentType);
        //system.debug('&% The Document Size is:'+documentTemplates.size());
        for(Document_Template__c documentTemplate: documentTemplates){
            childDocumentPicklistValues.add(documentTemplate.Document_Type__c);
        }
        return childDocumentPicklistValues;
    } 
    /**
* @description calling CPB service to get the Certificate
* @param idNumber
* @param lastName
* @return String
**/
    @AuraEnabled
    public static String callCPBService(String idNumber, String lastName){
        Map<CPBValidate_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CPBValidate_IH_v1.CPBValidate(idNumber, lastName);
        CPBValidate_Resp_IB_v1 responseBean = (new List<CPBValidate_Resp_IB_v1>(responseMap.keySet()))[0];
        List<Sys_Log_Integration__c> cpbLogs = responseMap.values()[0];
        //System.debug('#####' + responseBean.serialize(responseBean)+'#####');
        if (cpbLogs != null && !cpbLogs.isEmpty()){
            Insert cpbLogs;
        }
        return responseBean.serialize(responseBean);
    }
    
    
    /**
* @description Experian Service Callout
* @param registrationNumber 
* @return String 
**/
    @AuraEnabled
    public static String callExperianHandler(String registrationNumber){
        try{
            registrationNumber = registrationNumber.replace('/', '');
            ExperianBusinessDetailsGet_Resp_IB_v1 responseBean = ExperianBusinessDetailsGet_IH_v1.ExperianBusinessDetailsGet(registrationNumber);
            return responseBean.serialize(responseBean);
        } catch (Exception exc){
            //System.debug('Exception Occurred' + exc.getMessage()+'At Line number' + exc.getLineNumber());
            throw new AuraHandledException('Something went wrong: ' + exc.getMessage());
        }
    }
    
    /**
* @description Async call to make the callout to login and upload the goldenSourcedocument to the Amber
* @param hanisResponse
* @param cpbResponse
* @param experianResponse
* @param documentType
* @param subDocumentType
* @param accountId
* @return String pID
**/
    @AuraEnabled
    @SuppressWarnings('PMD.ApexOpenRedirect')
    public static String goldenSourceUpload(String hanisResponse, String cpbResponse, String experianResponse ,String documentType, string subDocumentType, string accountId) {
        String fileReference;
        string body;
        HanisValidate_Resp_IB_v1 hanisDataClass;
        CPBValidate_Resp_IB_v1 cpbDataClass;
        ExperianBusinessDetailsGet_Resp_IB_v1 experianData;
        if(hanisResponse != ''){
            hanisDataClass = (HanisValidate_Resp_IB_v1)JSON.deserialize(hanisResponse, HanisValidate_Resp_IB_v1.class);
            body = hanisDataClass.Cert;
        }
        if(cpbResponse != ''){
            cpbDataClass = (CPBValidate_Resp_IB_v1)JSON.deserialize(cpbResponse, CPBValidate_Resp_IB_v1.class);
            body = cpbDataClass.Person.AddressInformation.ResidentialAddress.AddCert;
        }
        if(experianResponse != ''){
            experianData = (ExperianBusinessDetailsGet_Resp_IB_v1)JSON.deserialize(experianResponse, ExperianBusinessDetailsGet_Resp_IB_v1.class);
            blob body1 = !test.isRunningTest() ? new PageReference(experianData.pdf).getContentAsPDF() : Blob.valueOf('test');
            body = EncodingUtil.base64Encode(body1);
        }
        Account acc = new AccountsSelector().selectAllById(accountId);
        string fileName = subDocumentType+'.pdf';
        CIS_AddDocResult_IB_v1 addDocRequest = CIS_IH_v1.uploadDocument(fileName,documentType,null,acc,subDocumentType,'true',body,'');
        if(addDocRequest.statusCode == 200){
            if( addDocRequest.AddResult.Status != 'ERROR' )  {
                fileReference = addDocRequest.Pid;
            }else{
                String message = addDocRequest.AddResult.Detail;
                if(!test.isRunningTest()){
                    throw new AuraHandledException(message);}
            }
        }else{
            string message = 'The Amber Service Response was '+addDocRequest.statusCode+ ' Please contact system administrator if the error persists';    
            if(!test.isRunningTest()){
                throw new AuraHandledException(message);}
        }
        if(filereference != null){
            addDocumentItem(fileName, accountId, fileReference, documentType,subDocumentType);
            return fileReference;
        }else{
            string msg = 'There was a problem uploading the document to Amber';
            if(!test.isRunningTest()){
                throw new AuraHandledException(msg);}
            return Null;
        }
    }
    /**
* @description pass the name of the object and the name of the field.
* @param objectName name of the object.
* @param selectedField name of the field on the object.
* @return List<String> returns Picklist Values
**/
    @AuraEnabled
    public static List<String> getPickListValues(String objectName, String selectedField){
        List<String> picklistValues = new List<String>();
        List<String> finalPicklistValues = new List<String>();
        picklistValues = PickListController.getPickListValuesUsingObjectName(objectName,selectedField);
        for(String s : picklistValues){
            if(s != 'Donation' && s != 'Salary' && s != 'Sale of Business' &&  s != 'Sale of Property'  &&  s != 'Sale of Vehicle' && s != 'Tax Rebate' && s != 'Winnings' && s != 'Other'){
                finalPicklistValues.add(s);
            }
        }
        return finalPicklistValues;
    }
    
    /**
* @description creates a document in salesforce with the file reference from AMBER.
* @param acc
* @param clientType
* @param AddressType
* @param address1
* @param address2
* @param suburbName
* @param cityName
* @param countryName
* @param postalCode
**/
    @AuraEnabled
    public static void updateAddress(Account acc, String clientType, String AddressType, string address1, string address2,string suburbName,string cityName,string countryName,string postalCode){
        Address__c add = new Address__c();
        add.Account__c = acc.Id;
        add.Client_Entity_Type__c = clientType;
        add.Address_Type__c = AddressType;
        string street;
        if(address1 != null && address1 != ''){
            street = address1 + ' ';}
        if(address2 != null && address2 != ''){
            street = street + address2;}
        add.Shipping_Street__c = street;
        add.Shipping_Suburb__c = suburbName;
        add.Shipping_City__c = cityName;
        add.Shipping_Country__c = countryName;
        add.Shipping_Zip_Postal_Code__c = postalCode;
        insert add;
    } 
        /**
* @description : This method is crreated to check AIC User permission.
* @param 	   : void
* @param 	   : 
* @return  : Boolean
**/    
    @AuraEnabled
    public static boolean checkAICUser() {
        Boolean hasCustomPermission = FeatureManagement.checkPermission('AIC_User');
        return hasCustomPermission;
    }
}