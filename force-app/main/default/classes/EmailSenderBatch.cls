global class  EmailSenderBatch implements Database.Batchable<Sobject>, Database.Stateful{
    Map<String,String> ownerIdVsBodyString=new Map<String,String>();

    public EmailSenderBatch(Map<String,String> ownerIdVsBodyString){
        this.ownerIdVsBodyString = ownerIdVsBodyString;

    }


    global  list<User> Start(Database.BatchableContext bc)
    {

     
        List<User> userwithTask = new UsersSelector().
                                        selectuserfortask(ownerIdVsBodyString.keyset());
                                                                                   

        return userwithTask;
    // return [Select id,UserName,Email,Name from User where id in :ownerIdVsBodyString.keySet()];
        
     


    }

    global void execute(Database.BatchableContext bc, List<User>userList){
        List<Messaging.SingleEmailMessage> pendingTaskEmailAlert = new List<Messaging.SingleEmailMessage>();
        string EmailFailure;
        list<OrgWideEmailAddress> owea =new OrgWideEmailAddressesSelector().selectAAActivity();
       
 		system.debug('org wide address '+owea.get(0).Id); //need to add logic not to hardcode
        
        for(User user: userList){
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
           

            email.setSubject('Details of overdue task');
            email.setTargetObjectId(user.id); //This is free Unlimited email day. As sending email to user is free
            email.setSaveAsActivity(false);
            email.setOrgWideEmailAddressId(owea.get(0).Id);
           // email.setSenderDisplayName('AAActivity Tracking Test');
            String userName=user.UserName;
            String htmlBody= '';

            htmlBody = '<table width="100%" border="0" cellspacing="0" cellpadding="10" align="center" bgcolor="#F7F7F7">'+
            +'<tr>'+
            +'<td style="font-size: 14px; font-weight: normal; font-family:Calibri;line-height: 20px; color: #333;"><br />'+
            +'<br />'+
            +'Dear '+user.Name+',</td>'+
            +'</tr>'+
            +'<tr>'+
            +'<td style="font-size: 14px; font-weight: normal; font-family:Calibri; line-height: 18px; color: #333;">The task below is overdue. Please action the task or mark the task as complete if already actioned.</td>'+
            +'</tr>'+
            +'</table> </br>';

         //   htmlBody +='<tr><td>' + who+ '</td><td>' + Subject +'</td><td>'+ dt + '</td><td>'+ dueDate +'</td><td>'+ status + '</td><td>'+ link +'</td></tr>';

            htmlBody +='<table border="1" style="border-collapse: collapse"><tr><th>Related To</th><th>Subject</th><th>Created Date</th><th> Due Date</th><th> Status</th><th> Click Here For Record</th></tr>'+ownerIdVsBodyString.get(User.Id); //Seting the body
            htmlBody += '</table><br>';
            email.setHtmlBody(htmlBody);
            pendingTaskEmailAlert.add(email);
        }
        try{
        Messaging.sendEmail(pendingTaskEmailAlert);
        }
        catch(System.EmailException emlEx){
           EmailFailure = 'Email Failed: ' + emlEx;
        }


    }
    
    global void finish(Database.BatchableContext BC){
    }
}