package com.test.multicine.repository;

import com.test.multicine.model.Venta;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface IVentaRepository  extends JpaRepository<Venta,Long> {
    Optional<Venta> findByIdVenta(String IdVenta);
}
