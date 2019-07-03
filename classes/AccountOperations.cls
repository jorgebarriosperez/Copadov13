public class AccountOperations {
    public static Account setDefaultDescription(Account a) {        
         a.Description = 'Default Description o no';
         return a;
    }
    public static Account setDefaultPhone(Account a){ //Dev01
        a.Phone = '987654321';
        return a;
    }
}