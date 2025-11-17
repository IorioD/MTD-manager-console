package mtd.manager.controller;

import mtd.manager.dto.DeploymentDTO;
import mtd.manager.service.DeploymentService;
import mtd.manager.vo.DeploymentVO;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import javax.validation.constraints.NotNull;
import java.util.List;

@Validated
@RestController
@RequestMapping("/deployment")
public class DeploymentController {

    @Autowired
    private DeploymentService deploymentService;

    @PostMapping
    public String save(@Valid @RequestBody DeploymentVO vO) {
        return deploymentService.save(vO).toString();
    }

    @GetMapping("/{id}")
    public DeploymentDTO getById(@Valid @NotNull @PathVariable("id") Long id) {
        return deploymentService.getById(id);
    }

    @GetMapping("/all")
    public List<DeploymentDTO> getAllDeployments() {
        return deploymentService.findAll();
    }

    @PutMapping("/{id}/strategy")
    public void updateDeploymentStrategy(@PathVariable("id") Long id, @RequestParam Integer strategy) {
        deploymentService.updateDeploymentStrategy(id, strategy);
    }

    @PutMapping("/{id}/enabled")
    public void updateEnabled(@PathVariable("id") Long id, @RequestParam boolean enabled) {
        deploymentService.updateEnabled(id, enabled);
    }

    @PatchMapping("/{id}/toggle")
    public void toggleEnabled(@PathVariable("id") Long id) {
        deploymentService.toggleEnabled(id);
    }
}
