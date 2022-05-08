/**
* Integration Handler for Create Opportunity function
* @author Danie Booysen and Jason Quevauvilliers
* @created 2018-08-22
* @Updated by Jason Quevauvilliers
* @Updated Date 2018-08-23
*/
public class CreateOpportunity_IH_v1 {

    /* Create Opportunity in SF
     * @param: CreateOpportunity_Req_IB_v1 instance / JSON String
     * @param: Transaction Id Header
     * @param: Initiator Header
     * @param: Sender Header
     * @return: CreateOpportunity_Resp_IB_v1 object*/
    public static CreateOpportunity_Resp_IB_v1 createOpportunity(CreateOpportunity_Req_IB_v1 wrpVals, String transactionIdP, String initiatorP, String senderP){
        
        //Validate that all the required parameters were sent
        String errorMessage = wrpVals.validate();
        
        if(String.isNotBlank(errorMessage)){
            //return bad response
            return CreateOpportunity_IU_v1.mapFieldsCreateOpportunityResponse(StringConstants.STATUS_CODE_400, 400, errorMessage, null);
        }
        
        //Try set the owner of the account to the advisor by BRID number
        List<User> advisorUsers = new UsersSelector().selectByBridNumber(wrpVals.adviserBRID);
        //Check if User Exists
        if(advisorUsers.size() == 1){
            
            Opportunity opp;
            Task task;
            String description;
            
            try{
                //Try get an account if it exists and create new linked opportunity
                /*List<Account> accountList = new AccountsSelector().selectAccountByIdNumber(wrpVals.clientIdNumber);
                
                if(accountList.size() == 1){
                    //Account Exists, Create Opportunity
                    opp = CreateOpportunity_IU_v1.mapFieldsOpportunity(accountList[0].id, wrpVals, transactionIdP, initiatorP, senderP, advisorUsers[0]);
                    task = CreateOpportunity_IU_v1.mapTaskFields(wrpVals);
                    description = StringConstants.MSG_CLIENT_EXISTS_OPP_CREATED;
                    
                }else if(accountList.size() == 0){
                    
                    //Creates account in AccountCreateGetInvolvedParty
                    AccountCreateGetInvolvedParty.GIPResponse gipResponse = AccountCreateGetInvolvedParty.createAccount('CIF', wrpVals.clientCIFCode);
                    if(gipResponse.response == 'Success'){
                        opp = CreateOpportunity_IU_v1.mapFieldsOpportunity(gipResponse.accountId, wrpVals, transactionIdP, initiatorP, senderP, advisorUsers[0]);
                        
                        task = CreateOpportunity_IU_v1.mapTaskFields(wrpVals);
                        description = StringConstants.MSG_CLIENT_CREATED_OPP_CREATED;
                    }else{
                        return CreateOpportunity_IU_v1.mapFieldsCreateOpportunityResponse(StringConstants.STATUS_CODE_400, 400, gipResponse.response, null);
                    }
                }else{
                    //Multiple Accounts found - return bad response
                    return CreateOpportunity_IU_v1.mapFieldsCreateOpportunityResponse(StringConstants.STATUS_CODE_500, 500, StringConstants.ERROR_MSG_COULD_NOT_CREATE_OPP_MULTIPLE_ACC_FOUND, null);
                } */
                
                //Creates account in AccountCreateGetInvolvedParty
                AccountCreateGetInvolvedParty.GIPResponse gipResponse = AccountCreateGetInvolvedParty.createAccount('SAID', wrpVals.clientIdNumber);
                System.debug('gipResponse ' + gipResponse);
                if(gipResponse.response == 'Success'){
                    opp = CreateOpportunity_IU_v1.mapFieldsOpportunity(gipResponse.accountId, wrpVals, transactionIdP, initiatorP, senderP, advisorUsers[0]);
                    
                    task = CreateOpportunity_IU_v1.mapTaskFields(wrpVals);
                    description = StringConstants.MSG_CLIENT_CREATED_OPP_CREATED;
                }else{
                    return CreateOpportunity_IU_v1.mapFieldsCreateOpportunityResponse(StringConstants.STATUS_CODE_400, 400, gipResponse.response, null);
                }
                
                insert opp;
                
                task.WhatId = opp.Id;
                task.OwnerId = advisorUsers[0].Id;
                insert task;
                
                //ToDo - Be removed once MDM email bug is fixed
                Account acc = [SELECT Id, PersonEmail FROM Account WHERE Id = :gipResponse.accountId LIMIT 1];
                acc.PersonEmail = wrpVals.clientEmail;
                update acc;
                //END ToDo
                
                doCasaScreeining(opp.Id);
                
                //return good response 
                return CreateOpportunity_IU_v1.mapFieldsCreateOpportunityResponse(StringConstants.STATUS_CODE_200, 200, description, opp.Id);
                
            }catch(Exception e){
                //return bad response
                description = StringConstants.ERROR_MSG_COULD_NOT_CREATE_RECORD + e.getMessage() + '. ' + e.getStackTraceString();
                return CreateOpportunity_IU_v1.mapFieldsCreateOpportunityResponse(StringConstants.STATUS_CODE_500, 500, description, null);
            }
            
        }else if(advisorUsers.size() == 0){
            //no user found - return bad response 
            return CreateOpportunity_IU_v1.mapFieldsCreateOpportunityResponse(StringConstants.STATUS_CODE_406, 406, StringConstants.ERROR_MSG_COULD_NOT_CREATE_ACC_FROM_BRID_NONE + wrpVals.adviserBRID, null);
        }else{
            //multiple users found - return bad response 
            return CreateOpportunity_IU_v1.mapFieldsCreateOpportunityResponse(StringConstants.STATUS_CODE_406, 406, StringConstants.ERROR_MSG_COULD_NOT_CREATE_ACC_FROM_BRID_MULTIPLE + wrpVals.adviserBRID, null);
        }
    }  
    
    @future(callout=true)
    public static void doCasaScreeining(Id oppId) {  
        CasaScreeningController.checkCasaFieldsAndDoCasaScreening(oppId);
    }    
}