@IsTest
public class ContractManagerTest {

    @IsTest
    static void testCreateContract() {
        
        Account testAccount = TestDataFactory.createAccount();
        Id recordID = TestAccount.Id;  
        
        // Vérification de la création du compte et de ces attributs
        Account createdAccount = [SELECT Id, Name FROM Account WHERE Name = 'Test' LIMIT 1];
        Assert.AreEqual(createdAccount.Id, recordId);
        Assert.AreEqual(createdAccount.Name, 'Test');
        
        // Simuler une requête HTTP POST
        RestRequest req = new RestRequest();
        
        // Préparer du contrat en JSON
        String jsonContract = '{"attributes": {"type": "Contract"}, "AccountId": "' + createdAccount.Id + '", "Status": "Draft", "StartDate": "2024-04-29", "ContractTerm": "36"}';

        // Simulation la requête REST
        req.requestBody = Blob.valueOf(jsonContract);
        RestContext.request = req;       

        Test.startTest();

        ID contractId = ContractManager.createContract();
        
        Test.stopTest();
        
        // Vérification si l'enregistrement a bien été créé
        Contract createdContract = [SELECT Id, AccountId, Status, StartDate, ContractTerm FROM Contract WHERE Id = :contractId];
        Assert.AreEqual(createdAccount.Id, createdContract.AccountId);
        Assert.AreEqual('Draft', createdContract.Status);
        Assert.AreEqual(Date.valueOf('2024-04-29'), createdContract.StartDate);
        Assert.AreEqual(36, createdContract.ContractTerm);
    }
    
    @IsTest
    static void testUpdateContract() {
 
        // Création des données de test    
        Account testAccount = TestDataFactory.createAccount();
        Contract testContract = TestDataFactory.createContract(testAccount.Id);
        ID recordAccountId = testAccount.Id;
        ID recordId = testContract.Id;

        // Vérification de la création du contrat et de ces attributs
        Contract createdContract = [SELECT Id, AccountId, Status, StartDate, ContractTerm FROM Contract WHERE Id = :recordId];
        Assert.AreEqual(createdContract.AccountId, recordAccountId);
        Assert.AreEqual(createdContract.Id, recordId);
        Assert.AreEqual(createdContract.Status, 'Draft');
        Assert.AreEqual(createdContract.StartDate, Date.valueOf('2024-04-29'));
        Assert.AreEqual(createdContract.ContractTerm, 36);

        // Configuration de la requête HTTP PATCH
        RestRequest request = new RestRequest();
        request.requestUri = '/services/apexrest/Contact/' + recordId;
        request.httpMethod = 'PATCH';
        RestContext.request = request;
        
        // Préparer un contract JSON
        String jsonContract = '{"Status": "Activated", "StartDate": "2024-04-30", "ContractTerm": 24}';
        request.requestBody = Blob.valueOf(jsonContract);
        
        Test.startTest();
        
        ContractManager.updateContract();
        
        Test.stopTest();

        // Vérification que l'enregistrement a été mis à jour
        Contract updatedContract = [SELECT Id, AccountId, Status, StartDate, ContractTerm FROM Contract WHERE Id = :recordId];
        Assert.AreEqual('Activated', updatedContract.Status);
        Assert.AreEqual(Date.valueOf('2024-04-30'), updatedContract.StartDate);
        Assert.AreEqual(24, updatedContract.ContractTerm);
        Assert.AreEqual(testAccount.Id, updatedContract.AccountId);
    }
    
}