/**
* This class gets all overdue tasks and 
* sends email to task owner every morning 8AM
*
* @author Diksha Wasekar
*
*/
global class TaskOverdueEmailBatch implements Database.Batchable<Sobject>,Database.Stateful {

    
    Map<String,string> ownerIdVsBodyString=new Map<String,string>();
    
    
           
    global Database.QueryLocator start(Database.BatchableContext BC) {

       Database.QueryLocator overdueTasks = new TasksSelector().
                                        selectByStatusAndActivityDate('Completed','Cancelled');
                                                                                   

        return overdueTasks;
        
        
    }
   

    global void execute(Database.BatchableContext BC, List<Task> scope){
 
        String domain = URL.getSalesforceBaseUrl().toExternalForm();
        String htmlBody= '';
        
        for(task task:scope){
            htmlBody= '';
        String dueDate = task.ActivityDate.format();
        String Subject =task.Subject;
        DateTime dt=task.CreatedDate;
        String what=task.What.Id;
        String who=task.Who.name;
        String status=task.Status;
        String link=domain + '/' + task.id;
		 htmlBody +='<tr><td>' + who+ '</td><td>' + Subject +'</td><td >'+ dt + '</td><td >'+ dueDate +'</td><td >'+ status + '</td><td ><a href="'+ link +'">Click Here</a></td></tr>';

        if(!ownerIdVsBodyString.containsKey(task.OwnerId))
        {
            system.debug('htmlbody for new user----'+htmlbody);
            ownerIdVsBodyString.put(task.OwnerId,htmlBody);
        }else{
            system.debug('htmlbody for existing user in map----'+htmlbody);
            ownerIdVsBodyString.put(task.OwnerId, ownerIdVsBodyString.get(task.OwnerId)+htmlBody);
           
        }
        }
            
       
    }
    
    global void finish(Database.BatchableContext bc)
{
    // We can send at max 10 emails in a transaction. So we would be using a helper batch to send emails
//EmailSenderBatch emailsend=new EmailSenderBatch();
    Database.executeBatch(new EmailSenderBatch(ownerIdVsBodyString),10 ); //Scope as 10
}
}