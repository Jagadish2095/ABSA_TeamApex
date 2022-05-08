/*
* Request Bean for NCA Retrive Service
* @author Almas Aleem
* @created 2020-11-26
*/
public class GetNCARetrieve_Req_IB_v1 extends Base_IB {
    
    public class Set_global {
        public String identifier ;
        public String out_identifier ; // in json: out-identifier
        public Object_X object_X ;// in json: object
    }
    
    public class Insert_Z {
        public Object_Y object_Y ;// in json: object
        
    }
    
    public String lookup ;
    public List<Commands> commands ;
    
    public class Object_X {
        public NcaDecision NcaDecision ;
    }
    
    public class Object_Y {
        public Client Client ;
    }
    
    public class Commands {
        public Set_global set_global ;// in json: set-global
        public Insert_Z insert_Z ;// in json: insert
    }
    
    public class Client {
        public Integer clientType ;
        public Integer turnOver ;
        public Integer assetValue ;
        public Integer agreementSize ;
        public String agreementType ;
        public Integer trustees ;
        public Boolean anyJuristicTrustee;
        public Boolean securedByMortgage ;
    }
    
    public class NcaDecision {
    }
    
    public override void setFieldNameSubstitutions() {
        fieldNameSubstitutionMap = new Map<String, String>();
        fieldNameSubstitutionMap.put('"set-global":', '"set_global":');
        fieldNameSubstitutionMap.put('"out-identifier":', '"out_identifier":');
        fieldNameSubstitutionMap.put('"object_Y":', '"object_X":');
        // fieldNameSubstitutionMap.put('"object":', '"Object_Z":');
        fieldNameSubstitutionMap.put('"object":', '"object_Y":');
        fieldNameSubstitutionMap.put('"insert":', '"insert_Z":');
        // fieldNameSubstitutionMap.put('"model-namespace":', '"model_namespace":');
    }
    
    public static GetNCARetrieve_Req_IB_v1 createDummyRequest() {
        GetNCARetrieve_Req_IB_v1 requestBean = new GetNCARetrieve_Req_IB_v1();
        requestBean.lookup = 'ksession-nca';
        
        GetNCARetrieve_Req_IB_v1.Set_global setglobal = new  GetNCARetrieve_Req_IB_v1.Set_global ();
        
        setglobal.identifier ='ncaDecision';
        setglobal.out_identifier ='NcaDecision';
        setglobal.object_X = new GetNCARetrieve_Req_IB_v1.Object_X();
        setglobal.object_X.NcaDecision = new GetNCARetrieve_Req_IB_v1.NcaDecision();
        GetNCARetrieve_Req_IB_v1.Object_Y   objecty= new GetNCARetrieve_Req_IB_v1.Object_Y();
        objecty.Client = new GetNCARetrieve_Req_IB_v1.Client();
        objecty.Client.agreementSize=500000;
        objecty.Client.agreementType='CR';
        objecty.Client.assetValue =800000;
        objecty.Client.clientType=78;
        objecty.Client.securedByMortgage=false;
        objecty.Client.turnOver =800000;
        objecty.Client.trustees =2;
        objecty.Client.anyJuristicTrustee =false;

        
        
        GetNCARetrieve_Req_IB_v1.Insert_Z insertZ =new GetNCARetrieve_Req_IB_v1.Insert_Z();
        insertZ.object_Y = objecty;
        
        GetNCARetrieve_Req_IB_v1.Commands command = new GetNCARetrieve_Req_IB_v1.Commands();
        command.insert_Z = insertZ;
        command.set_global = setglobal;
        
        
        requestBean.commands = new List<GetNCARetrieve_Req_IB_v1.Commands>();
        requestBean.commands.add(command);
        
        return requestBean;
    }
}