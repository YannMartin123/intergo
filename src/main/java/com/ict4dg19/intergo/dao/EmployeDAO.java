package com.ict4dg19.intergo.dao;

import com.ict4dg19.intergo.model.Employe;
import java.util.List;

public interface EmployeDAO {
    void create(Employe employe);
    Employe findById(Long id);
    Employe findByEmail(String email);
    List<Employe> findAll();
    void update(Employe employe);
    void delete(Long id);
    int countTotalEmployes();
}
