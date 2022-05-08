/**
* This class is called from the batch class and used
* to process the communication tasks. We use a Queueable interface
* as we are calling a future method from the batach which are not allowed 
*
* @author  Rudolf Niehaus - CloudSmiths
* @since   2019-04-01
*/
public without sharing class CommunicationPlanActionQueueable implements System.Queueable{

    private List<Task> taskLst;

    public CommunicationPlanActionQueueable(List<Task> tasksToAction) {
        this.taskLst = tasksToAction;
    }

    public void execute(System.QueueableContext objContext) {
        
        List<Task> updatedTasks = CommunicationPlanFunctions.actionTasks(taskLst);
        
        try{

            update updatedTasks;
            
        }catch(DMLException ex){
            System.debug(ex.getMessage());
            throw ex;
        }
    }
}