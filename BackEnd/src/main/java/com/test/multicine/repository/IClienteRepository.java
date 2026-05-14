package com.test.multicine.repository;

import com.test.multicine.model.Cliente;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface IClienteRepository extends JpaRepository<Cliente,Long> {
    Optional<Cliente> findByNombre(String nombre);
}
