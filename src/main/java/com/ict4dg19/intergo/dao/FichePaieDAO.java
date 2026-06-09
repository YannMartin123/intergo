package com.ict4dg19.intergo.dao;

import com.ict4dg19.intergo.model.FichePaie;
import java.math.BigDecimal;
import java.util.List;

public interface FichePaieDAO {
    void create(FichePaie fiche);
    FichePaie findById(Long id);
    List<FichePaie> findAll();
    List<FichePaie> findByEmployeId(Long employeId);
    void update(FichePaie fiche);
    void delete(Long id);
    BigDecimal sumMasseSalariale();
}
