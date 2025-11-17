package mtd.manager.controller;

import mtd.manager.dto.PodDTO;
import mtd.manager.service.PodService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import javax.validation.constraints.NotNull;
import java.util.List;

@Validated
@RestController
@RequestMapping("/pods")
public class PodController {

    @Autowired
    private PodService podService;

    @GetMapping("/{id}")
    public PodDTO getById(@Valid @NotNull @PathVariable("id") Long id) {
        return podService.getById(id);
    }

    @GetMapping("/all")
    public List<PodDTO> getAllPods() {
        return podService.findAll();
    }

    @PutMapping("/{id}/enabled")
    public void updateEnabled(@PathVariable("id") Long id, @RequestParam boolean enabled) {
        podService.updateEnabled(id, enabled);
    }

    @PatchMapping("/{id}/toggle")
    public void toggleEnabled(@PathVariable("id") Long id) {
        podService.toggleEnabled(id);
    }
}
