public with sharing class AccountHandler {
  public static void CreateNewOpportunity(List<Account> accts) {
    List<Opportunity> opps = new List<Opportunity>();
    for (Account a : accts) {
      Opportunity opp = new Opportunity();
      opp.Name = a.Name + ' Opportunity';
      opp.AccountId = a.Id;
      opp.StageName = 'Prospecting';
      opp.CloseDate = System.Today().addMonths(1);
      opps.add(opp);
    }
    if (opps.size() > 0) {
      insert opps;
    }
  }

  public static void insertAccount(integer value) {
    integer accNumber = 1;
    List<Account> addAccounts = new List<Account>();
    while (accNumber <= value) {
      addAccounts.add(
        new Account(
          Name = 'Acme Inc accCount' + accNumber,
          AccountNumber = 'A000' + accNumber
        )
      );
      accNumber++;
    }
    if (addAccounts.size() > 0) {
      insert addAccounts;
    }
  }
}