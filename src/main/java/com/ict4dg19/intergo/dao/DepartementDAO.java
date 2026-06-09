package com.ict4dg19.intergo.dao;

import com.ict4dg19.intergo.model.Departement;
import java.util.List;

public interface DepartementDAO {
    void create(Departement departement);
    Departement findById(Long id);
    List<Departement> findAll();
    void update(Departement departement);
    void delete(Long id);
}
