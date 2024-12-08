package org.example.model;

import lombok.AllArgsConstructor;

@AllArgsConstructor
public class CreditAccount implements Account {
    private double balance;
    @Override
    public double getBalance() {return balance;}
}
