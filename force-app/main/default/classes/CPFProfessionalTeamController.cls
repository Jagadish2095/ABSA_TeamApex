/**
* @description Class for CPFPRofessionalTeamSection to store its fieldsand repetators
* @author Diksha Wasekar
* @Date 26/05/2021
* */
public class CPFProfessionalTeamController {

/**
* @description Method to get all the ApplicationCPFProduct Rec.
* @param oppId
* @return Application_Product_CPF__c
*/
@AuraEnabled
public static Application_Product_CPF__c getAppProdctCpfRec(Id oppId) {
List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(oppId);
Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
return appPrdctCpf;     
}

/**
* @description Method to get the list of Application Team Members.
* @param oppId
* @return List<Application_Team_Member__c>
*/
@AuraEnabled
public static List<Application_Team_Member__c> getAppTeamMemberRec(Id oppId) {
List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(oppId);
Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
List<Application_Team_Member__c> AppTeamMemberlist = new ApplicationTeamMembersSelector().selectteamMemberwithtypeandCategory(appPrdctCpf.Id,'Profession','CPF');
return AppTeamMemberlist;     

}

/**
* @description Method to update Application Product CPF Rec.
* @param recId
* @param objData
* @return Application_Product_CPF__c
*/
@AuraEnabled
public static Application_Product_CPF__c updateAppPrdctcpf(Id recId,String objData
                                            ) {
                                                appProductcpf responseBean=new appProductcpf ();
                                                responseBean= (appProductcpf)JSON.deserialize(objData,appProductcpf.class);
                                                
                                                Application_Product_CPF__c appPrdctCpf= new Application_Product_CPF__c(); 
                                                
                                                if(appPrdctCpf!=null){
                                                    appPrdctCpf.Id =recId;
                                                    appPrdctCpf.Quantity_surveyor__c = responseBean.quantitysurveyor;
                                                    appPrdctCpf.Architect__c = responseBean.architect;
                                                    appPrdctCpf.Land_surveyor__c = responseBean.landsurveyor;
                                                    appPrdctCpf.Civil_Engineer__c = responseBean.civilengineer;
                                                    appPrdctCpf.Structural_Engineer__c = responseBean.structuralengineer;
                                                    appPrdctCpf.Mechanical_Engineer__c= responseBean.mechanicalengineer;
                                                    appPrdctCpf.Electrical_Engineer__c = responseBean.electricalengineer;
                                                    appPrdctCpf.Town_Planner__c = responseBean.townplanner;
                                                    appPrdctCpf.Project_Manager__c = responseBean.projectmanager;
                                                    appPrdctCpf.Wet_Services_Engineer__c = responseBean.wetserviceengineer;
                                                    
                                                    List<Application_Team_Member__c> dellist = new ApplicationTeamMembersSelector().selectteamMemberwithtypeandCategory(recId,'Profession','CPF');
                                                    if(!dellist.isEmpty() && !dellist.isEmpty() && dellist.size()>0) {
                                                        delete dellist;
                                                    }
                                                    for(Application_Team_Member__c teamMembers : responseBean.newProfessionalTeamMember) {
                                                        teamMembers.Id= null;
                                                        teamMembers.Application_Product_CPF__c=recId;
                                                        teamMembers.Type__c='Profession';
                                                        teamMembers.Category__c='CPF';
                                                    }
                                                    insert responseBean.newProfessionalTeamMember;
                                                    
                                                    
                                                    
                                                }
                                                
                                                update appPrdctCpf;
                                                return appPrdctCpf;
                                            }





/**@description Wrapper Class To Map the response from json
*/
public class appProductcpf{
/**@description Wrapper Class To Map the field value to App Product CPF Rec
*/
@auraEnabled public String quantitysurveyor {get;set;}
/**@description Wrapper Class To Map the field value to App Product CPF Rec
*/
@auraEnabled public String architect {get;set;}
/**@description Wrapper Class To Map the field value to App Product CPF Rec
*/
@auraEnabled public String landsurveyor {get;set;}
/**@description Wrapper Class To Map the field value to App Product CPF Rec
*/
@auraEnabled public String civilengineer {get;set;}
/**@description Wrapper Class To Map the field value to App Product CPF Rec
*/
@auraEnabled public String structuralengineer {get;set;}
/**@description Wrapper Class To Map the field value to App Product CPF Rec
*/
@auraEnabled public String mechanicalengineer {get;set;}
/**@description Wrapper Class To Map the field value to App Product CPF Rec
*/
@auraEnabled public String electricalengineer {get;set;}
/**@description Wrapper Class To Map the field value to App Product CPF Rec
*/
@auraEnabled public String townplanner {get;set;}
/**@description Wrapper Class To Map the field value to App Product CPF Rec
*/
@auraEnabled public String projectmanager {get;set;}
/**@description Wrapper Class To Map the field value to App Product CPF Rec
*/
@auraEnabled public String wetserviceengineer {get;set;}
/**@description Wrapper Class To Map the field value to App Product CPF Rec
*/
@auraEnabled public List<Application_Team_Member__c> newProfessionalTeamMember {get;set;}

}
}