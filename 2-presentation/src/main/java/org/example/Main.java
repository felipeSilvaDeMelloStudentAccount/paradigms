package org.example;

import org.example.service.AccountManagerService;

public class Main {
    public static void main(String[] args) {

        System.out.println("Hello class mates\n");

        AccountManagerService accountManagerService = new AccountManagerService();
        System.out.println("Bank Account Balance: " + accountManagerService.getBalance("BankAccount", 1000.0));
        System.out.println("Loan Account Balance: " + accountManagerService.getBalance("LoanAccount", -30000.0));
        System.out.println("Credit Account Balance: " + accountManagerService.getBalance("CreditAccount", 9000.0));
        System.out.println("Mortgage Account Balance: " + accountManagerService.getBalance("MortgageAccount", 700000.0));

        // Attempt to access an unknown account type
        try {
            System.out.println("Account Balance Not Found: " + accountManagerService.getBalance("RandomAccount", 0.0));
        } catch (IllegalArgumentException e) {
            System.out.println(e.getMessage());
        }
    }
}