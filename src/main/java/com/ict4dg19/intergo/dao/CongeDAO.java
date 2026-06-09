package com.ict4dg19.intergo.dao;

import com.ict4dg19.intergo.model.Conge;
import java.util.List;

public interface CongeDAO {
    void create(Conge conge);
    Conge findById(Long id);
    List<Conge> findAll();
    List<Conge> findByEmployeId(Long employeId);
    void update(Conge conge);
    void delete(Long id);
    int countCongesEnAttente();
}
