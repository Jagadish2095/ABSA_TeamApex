/*
* Response Bean class for GetCasaDetailsByRef
* @author Danie Booysen & Jason Quevauvilliers
* @created 2019-07-05
*/

public class GetCasaDetailsByRef_Resp_IB_v1 extends Base_IB{
    
    public String status;
    public Integer statusCode;
    public String message;
    
    public String msgNo;
    public String msg;
    public String firstName;
    public String surnameComp;
    public String idType;
    public String idRegNo;
    public String clientTypeGrp;
    public String dob;
    public String nationality;
    public String cntryOfRes;
    public String casaStatus;//status
    public String approvedSts;
    public String documentSts;
    public String pepSts;
    public String sbu;
    public String riskRequired;
    public String primaryClient;
    public String noParticipants;
    public String casaDateTime;
    public String countryOfBirth;
    
    public override void setFieldNameSubstitutions()
    {
        fieldNameSubstitutionMap = new Map<String, String>();
        fieldNameSubstitutionMap.put('"dateTime":', '"casaDateTime":');
        fieldNameSubstitutionMap.put('"status":', '"casaStatus":');
    }
    
}