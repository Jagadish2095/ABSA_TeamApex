/*
* Utility Bean for NCA Retrive Service
* @author Almas Aleem
* @created 2020-11-26
*/
public class GetNCARetrieve_IU_v1 {
    
    public static GetNCARetrieve_Req_IB_v1 mapRequestFields(Integer assetValue,Integer turnOver){
        GetNCARetrieve_Req_IB_v1 requestBean = new GetNCARetrieve_Req_IB_v1();
        requestBean.lookup = 'ksession-nca';
        
        GetNCARetrieve_Req_IB_v1.Set_global setglobal = new  GetNCARetrieve_Req_IB_v1.Set_global ();
        
        setglobal.identifier ='ncaDecision';
        setglobal.out_identifier ='NcaDecision';
        setglobal.object_X = new GetNCARetrieve_Req_IB_v1.Object_X();
        setglobal.object_X.NcaDecision = new GetNCARetrieve_Req_IB_v1.NcaDecision();
        GetNCARetrieve_Req_IB_v1.Object_Y   objecty= new GetNCARetrieve_Req_IB_v1.Object_Y();
        objecty.Client = new GetNCARetrieve_Req_IB_v1.Client();
        // objecty.Client.agreementSize=500000;
        //objecty.Client.agreementType='CR';
        objecty.Client.assetValue =assetValue;
        objecty.Client.turnOver =turnOver;
        objecty.Client.clientType=78;
        objecty.Client.securedByMortgage=false;
        
        
        
        GetNCARetrieve_Req_IB_v1.Insert_Z insertZ =new GetNCARetrieve_Req_IB_v1.Insert_Z();
        insertZ.object_Y = objecty;
        
        GetNCARetrieve_Req_IB_v1.Commands command = new GetNCARetrieve_Req_IB_v1.Commands();
        command.insert_Z = insertZ;
        command.set_global = setglobal;
        
        
        requestBean.commands = new List<GetNCARetrieve_Req_IB_v1.Commands>();
        requestBean.commands.add(command);
        
        return requestBean;
    }
    
    public static GetNCARetrieve_Req_IB_v1 mapRequestFields(Integer assetValue,Integer turnOver,Integer clientType,Integer agreementSize,String agreementType,Integer trustees,Boolean anyJuristicTrustee,Boolean securedByMortgage){
        GetNCARetrieve_Req_IB_v1 requestBean = new GetNCARetrieve_Req_IB_v1();
        requestBean.lookup = 'ksession-nca';
        
        GetNCARetrieve_Req_IB_v1.Set_global setglobal = new  GetNCARetrieve_Req_IB_v1.Set_global ();
        
        setglobal.identifier ='ncaDecision';
        setglobal.out_identifier ='NcaDecision';
        setglobal.object_X = new GetNCARetrieve_Req_IB_v1.Object_X();
        setglobal.object_X.NcaDecision = new GetNCARetrieve_Req_IB_v1.NcaDecision();
        GetNCARetrieve_Req_IB_v1.Object_Y   objecty= new GetNCARetrieve_Req_IB_v1.Object_Y();
        objecty.Client = new GetNCARetrieve_Req_IB_v1.Client();
        objecty.Client.agreementSize=agreementSize;
        objecty.Client.agreementType='CR';
        objecty.Client.assetValue =assetValue;
        objecty.Client.turnOver =turnOver;
        objecty.Client.clientType=clientType;
        objecty.Client.trustees=trustees;
        objecty.Client.anyJuristicTrustee=anyJuristicTrustee;
        objecty.Client.securedByMortgage=false;
        
        
        
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