package com.test.multicine.service;

import com.test.multicine.model.Cliente;
import com.test.multicine.repository.IClienteRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ClienteService {
    private final IClienteRepository clienteRepository;

    public ClienteService(IClienteRepository clienteRepository){
        this.clienteRepository = clienteRepository;
    }

    public Cliente createCliente(Cliente cliente) {
        return clienteRepository.save(cliente);
    }

    public List<Cliente> getAllClientes() {
        return clienteRepository.findAll();
    }

    public Cliente getClienteById(Long id) {
        return clienteRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Cliente no encontrado con el  id: " + id));
    }

    public Cliente updateCliente(Long id, Cliente clienteData) {
        Cliente cliente = getClienteById(id);
        cliente.setIdentificacion(clienteData.getIdentificacion());
        cliente.setNombre(clienteData.getNombre());
        cliente.setTelefono(clienteData.getTelefono());
        cliente.setEmail(clienteData.getEmail());
        cliente.setDireccion(clienteData.getDireccion());
        return clienteRepository.save(cliente);
    }

    public boolean deleteCliente(Long id) {
        Cliente cliente = getClienteById(id);
        clienteRepository.delete(cliente);
        return true;
    }
}
