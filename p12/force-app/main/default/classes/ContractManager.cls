@RestResource(urlMapping='/Contract/*')
global with sharing class ContractManager {
        
    @HttpPost
    global static ID createContract() {
        RestRequest req = RestContext.request;
        String requestBody = req.requestBody.toString();
        Contract contract = (Contract) JSON.deserialize(requestBody, SObject.class);           
            insert contract;
        	return contract.Id;          
        }           

	@HttpPatch
    global static ID updateContract() {
        RestRequest request = RestContext.request;
        String contractId = request.requestURI.substring(
        request.requestURI.lastIndexOf('/')+1);

    String requestBody = request.requestBody.toString();
    Contract contractUpdates = (Contract) JSON.deserialize(requestBody, Contract.class);

    Contract contractToUpdate = [SELECT Id FROM Contract WHERE Id = :contractId];
    contractUpdates.id = contractToUpdate.Id;
    update contractUpdates;
    return contractToUpdate.Id;   
        
        }           
}