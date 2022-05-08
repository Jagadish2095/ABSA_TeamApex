global class InvocableAddBusinessHours {

    global class Request {
        @InvocableVariable
            global String businessHoursId;
        @InvocableVariable
            global DateTime startDate;
        @InvocableVariable
            global Long intervalMS;
    }

    global class Result {
        @InvocableVariable
            global DateTime endDate;
    } 
    
    @InvocableMethod(label='Add Business Hours' 
                     description='Returns an end date when given a start date and time interval (in milliseconds), taking into account business hours') 
    global static List<Result> calculateBusinessHours(List<Request> varsList) {
        List<Result> results = new List<Result>();
         for (Request vars : varsList)
        {
            Result thisResult = new Result();

            thisResult.endDate = BusinessHours.add(vars.businessHoursId, vars.startDate, vars.intervalMS);
            results.add(thisResult);
        }
        return results;
    }
}