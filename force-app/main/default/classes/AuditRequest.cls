public class AuditRequest {
    public list<list<Signatory>> listOfSteps {get;set;}
    public string requestID {get;set;}
    public string docName {get;set;}
    public string docID {get;set;}
  
    public auditRequest(list<list<Signatory>> stps) {
        this.listOfSteps = stps;
    }

    public auditRequest() {
        listOfSteps = new list<list<Signatory>>();
    }

    public string getRequestId() {
        return this.requestID;
    }
    public string getDateMade() {
        impressionRequest__c ir = [Select CreatedDate From impressionRequest__c Where requestid__c = :requestId];
        return string.valueOf(ir.CreatedDate);
    }
    public string getDocName() {
        return this.docName;
    }

    public void add(list<Signatory> ls) {
        listOfSteps.add(ls);
    }

    public void set(integer index, list<Signatory> ls) {
        while (listOfSteps.size() < index){
            list<signatory> l = new list<signatory>();
            listOfSteps.add(l);
        }
        
        try {
            listOfSteps.set(index, ls);
        } catch (Exception ex) {
            system.debug(ex);
        }
    }

    public integer size() {
        return listOfSteps.size();
    }
    public list<Signatory> get(integer index) {
        list<Signatory> theList = new list<Signatory>();
        try {
            theList = listOfSteps.get(index);
        } catch (Exception ex) {
            system.debug(ex);
        }

        return theList;
    }
    public boolean allComplete() {
        for (list<Signatory> step : listOfSteps) {
            for (Signatory sig : step)
                if (sig.signedStatus != 'SIGNED')
                    return false;
        }
        return true;
    }

    public string getLastSigRequest() {
        list<signatory> lastStep = listOfSteps[listOfSteps.size()-1];
        signatory lastSig = lastStep[lastStep.size() -1];
        return lastSig.signatureRequestId;
    }
}