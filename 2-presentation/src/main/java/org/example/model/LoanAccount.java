package org.example.model;

import lombok.AllArgsConstructor;

@AllArgsConstructor
public class LoanAccount implements Account {
    private double balance;
    @Override
    public double getBalance() {return balance;}
}
