/* 
* This class used to trigger escalation mail to line manager if case is dont ave activity for 30 days   
* @author   Vitthal Jivrag
* @since    2021-01-05
*/
public class caseEscalationCheckBatch implements Database.Batchable<sObject> {
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        
        return Database.getQueryLocator([SELECT id,RecordType.DeveloperName,Owner.Name,Owner.id,CaseNumber,LastModifiedDate,status,Case_Age__c,Adviser_code__c,CreatedDate from case WHERE RecordType.DeveloperName = 'Broker_Note']);
        
    }
    public void execute(Database.BatchableContext bc,list<Case> Records){
        
        list<case> listofCase = new list<case>(); 
        List<Messaging.Email> mails=new List<Messaging.Email>();
        String Linemanager='';
        String CamManager=System.label.BrokerNoteEscalationCM;
        Integer esacalationAge=0;
        if(!Test.isRunningTest()){
            esacalationAge=Integer.valueOf(system.label.BrokerNoteEscalationAge);
        }
        else{
            esacalationAge=1;
        }
        for(Case caseObj:Records){            
            if(esacalationAge == caseObj.Case_Age__c && (caseObj.Status =='New' || caseObj.Status =='In Progress' )){
                listofCase.add(caseObj);
            }
        }
        if(listofCase.size()>0){
            UsersSelector uSelector=new UsersSelector();
            user owener=uSelector.selectUserById(listofCase[0].Owner.id);
           //  user owener=[select id,Email, ManagerId from user where id=:listofCase[0].Owner.id];
            user adviser=uSelector.selectByAdviserCode(listofCase[0].Adviser_code__c);
           // user adviser=[select id ,name,Advisor_code__c from user where Advisor_code__c =: listofCase[0].Adviser_code__c LIMIT 1];
            user manager =new user();
            string managerEmail='';
            if(owener.ManagerId != null){
                manager=uSelector.selectUserById(owener.ManagerId);
            // manager=[select id,Email,FirstName, ManagerId from user where id=:owener.ManagerId];            
                managerEmail = manager.Email;
            }
            else{
                managerEmail = system.label.BrokerNoteEscalationLM;
            }
            
            Messaging.SingleEmailMessage mail =new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[]{managerEmail});
          //  mail.setCcAddresses(new String[]{CamManager});
            mail.setSubject('Escalation : Broker note service case outstanding '+listofCase[0].CaseNumber); 
            
            String emailBody='<table border="0" cellpadding="0" cellspacing="0" width="100%">'+
                '<tr>'+
                '<td style="padding: 20px 25px 20px 25px">'+
                '<p style="font: 15px/20px Calibri, Cambria, Arial, Verdana; color:#000000; margin: 0px 0px 10px 0px; padding: 0px 0px 0px 0px">Dear Team Manager,</p>'+
                '<p style="font: 15px/20px Calibri, Cambria, Arial, Verdana; color:#000000; margin: 0px 0px 10px 0px; padding: 0px 0px 0px 0px; text-align:justify">This serves to notify you that the respective agent <b>'+listofCase[0].Owner.Name+
                '</b> has not worked on the following Broker Note service case for the last 30 days. '+
                'The objective for this service case is for the adviser to contact the relevant customer and to conclude the adviser appointment broker appointment letter.'+
                'Please can you intervene so that we can close this service case.'+
                ' We still recommend that the adviser must please make the necessary agreed effort to contact customer before the adviser closes this service case as uncontactable.'+
                '</p></br>'+
                '<table cellspacing="0" cellpadding="4" width="100%" style="font: 15px/20px Calibri, Cambria, Arial, Verdana; color:#000000; border:1px solid #CCCCCC">'+
                '<tbody>'+
                '<tr bgcolor="#183884">'+
                '<th align="center" colspan="2"  style="font: 15px/20px Calibri, Verdana, Geneva, sans-serif; color:#FFFFFF; border-bottom:1px solid #CCCCCC; border-right:1px solid #CCCCCC"><b>Case No</b></th>'+
                '<th align="center" colspan="2"  style="font: 15px/20px Calibri, Verdana, Geneva, sans-serif; color:#FFFFFF; border-bottom:1px solid #CCCCCC; border-right:1px solid #CCCCCC"><b>Owner</b></th>'+
                '<th align="center" colspan="2"  style="font: 15px/20px Calibri, Verdana, Geneva, sans-serif; color:#FFFFFF; border-bottom:1px solid #CCCCCC; border-right:1px solid #CCCCCC"><b>Status</b></th>'+
                '<th align="center" colspan="2"  style="font: 15px/20px Calibri, Verdana, Geneva, sans-serif; color:#FFFFFF; border-bottom:1px solid #CCCCCC; border-right:1px solid #CCCCCC"><b>Advisor Name</b></th>'+
                '<th align="center" colspan="2"  style="font: 15px/20px Calibri, Verdana, Geneva, sans-serif; color:#FFFFFF; border-bottom:1px solid #CCCCCC; border-right:1px solid #CCCCCC"><b>Created Date</b></th>'+
                '<th align="center" colspan="2"  style="font: 15px/20px Calibri, Verdana, Geneva, sans-serif; color:#FFFFFF; border-bottom:1px solid #CCCCCC; border-right:1px solid #CCCCCC"><b>Last Modified Date</b></th>'+
                '</tr>'+
                '<tr>'+
                '<td colspan="2" style="font: 15px/20px Calibri, Cambria, Arial, Verdana; color:#000000; border-right:1px solid #CCCCCC">'+listofCase[0].CaseNumber+'</td>'+
                '<td colspan="2" style="font: 15px/20px Calibri, Cambria, Arial, Verdana; color:#000000; border-right:1px solid #CCCCCC">'+listofCase[0].Owner.Name+'</td>'+															
                '<td colspan="2" style="font: 15px/20px Calibri, Cambria, Arial, Verdana; color:#000000; border-right:1px solid #CCCCCC">'+listofCase[0].status+'</td>'+
                '<td colspan="2" style="font: 15px/20px Calibri, Cambria, Arial, Verdana; color:#000000; border-right:1px solid #CCCCCC">'+adviser.Name+'</td>'+                                                                
                '<td colspan="2" style="font: 15px/20px Calibri, Cambria, Arial, Verdana; color:#000000; border-right:1px solid #CCCCCC">'+listofCase[0].CreatedDate.date()+'</td>'+
                '<td colspan="2" style="font: 15px/20px Calibri, Cambria, Arial, Verdana; color:#000000; border-right:1px solid #CCCCCC">'+listofCase[0].LastModifiedDate.date()+'</td>'+
                '</tr>'+
                '</tbody>'+
                '</table></br>'+
                '<p style="font: 15px/20px Calibri, Cambria, Arial, Verdana; color:#000000; margin: 0px 0px 10px 0px; padding: 0px 0px 0px 0px; text-align:justify">Kind regards</br>Absa Virtual Advice Support</br>Absa Insurance and Financial Advisers (Pty) Ltd is an Authorised Financial Services Provider. FSP 4012</br></p>'+
                '<tr>'+
                '</table>'; 
            
            mail.setHtmlBody(emailBody); 
            mails.add(mail);
            if(!Test.isRunningTest()){
                Messaging.sendEmail(mails);
            }
            
        }
        
        
    }
    public void finish(Database.BatchableContext bc){
        
    }
    
}