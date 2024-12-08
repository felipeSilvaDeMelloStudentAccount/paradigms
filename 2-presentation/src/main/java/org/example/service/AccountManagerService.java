package org.example.service;

import org.example.model.CurrentAccount;
import org.example.model.CreditAccount;
import org.example.model.LoanAccount;
import org.example.model.MortgageAccount;

public class AccountManagerService {

    public double getBalance(String accountType, double initialBalance) {
        switch (accountType) {
            case "BankAccount":
                return new CurrentAccount(initialBalance).getBalance();
            case "LoanAccount":
                return new LoanAccount(initialBalance).getBalance();
            case "CreditAccount":
                return new CreditAccount(initialBalance).getBalance();
            case "MortgageAccount":
                return new MortgageAccount(initialBalance).getBalance();
            default:
                throw new IllegalArgumentException("Account type '" + accountType + "' not found");

        }
    }
}
