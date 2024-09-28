public class TestDataFactory {
    
    // Création d'un compte
    public static Account createAccount() {
        Account testAccount = new Account(
            Name = 'Test'
        );
        insert testAccount;
        return testAccount;
    }
     
    // Création d'un contact
    public static Contact createContact() {
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'test@openclassroom.com'
        );
        insert testContact;
        return testContact;
    }
    
    // Création d'un contrat
    public static Contract createContract(Id accountId) {
            Contract testContract = new Contract(
                AccountId = accountId,
                Status = 'Draft',
                StartDate = Date.valueOf('2024-04-29'),
                ContractTerm = 36
            );
        insert testContract;
        return testContract;
    }

}