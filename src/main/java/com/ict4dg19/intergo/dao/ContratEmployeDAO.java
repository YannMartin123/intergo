package com.ict4dg19.intergo.dao;

import com.ict4dg19.intergo.model.ContratEmploye;
import java.util.List;

public interface ContratEmployeDAO {
    void create(ContratEmploye contrat);
    ContratEmploye findById(Long id);
    List<ContratEmploye> findAll();
    List<ContratEmploye> findByEmployeId(Long employeId);
    void update(ContratEmploye contrat);
    void delete(Long id);
}
