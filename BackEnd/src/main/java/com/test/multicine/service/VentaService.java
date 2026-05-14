package com.test.multicine.service;

import com.test.multicine.model.*;
import com.test.multicine.repository.IVentaRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Queue;
import java.util.concurrent.ConcurrentLinkedQueue;

@Service
public class VentaService {

    private final IVentaRepository ventaRepository;
    private final Queue<Venta> queue = new ConcurrentLinkedQueue<>();


    public VentaService(IVentaRepository ventaRepository){
        this.ventaRepository = ventaRepository;
    }

    public Venta    createVenta(Venta venta) {

        LocalDateTime fech = LocalDateTime.now();
        LocalTime now = LocalTime.now();
        LocalTime start = LocalTime.of(22, 0);
        LocalTime end = LocalTime.of(23, 59);

        boolean esCierreNocturno = !now.isBefore(start) && !now.isAfter(end);

        if (esCierreNocturno) {
            queue.add(venta);
        }

        for (ItemVenta item : venta.getItems()) {
            item.setVenta(venta);
        }

        venta.setTimestamp(fech);

        venta.setNumfactura("001-001-0000"+now.getHour()+now.getMinute());

        return ventaRepository.save(venta);
    }

    public List<Venta> getAllVentas() {
        return ventaRepository.findAll();
    }

    public Venta getVentaById(Long id) {
        return ventaRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Venta no encontrado con el  id: " + id));
    }


}
