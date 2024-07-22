package mtd.manager.controller;

import mtd.manager.dto.StrategyDTO;
import mtd.manager.service.StrategyService;
import mtd.manager.vo.StrategyQueryVO;
import mtd.manager.vo.StrategyUpdateVO;
import mtd.manager.vo.StrategyVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import javax.validation.constraints.NotNull;
import java.util.List;

@Validated
@RestController
@RequestMapping("/strategy")
public class StrategyController {

    @Autowired
    private StrategyService strategyService;

    @PostMapping
    public String save(@Valid @RequestBody StrategyVO vO) {
        return strategyService.save(vO).toString();
    }

    @DeleteMapping("/{id}")
    public void delete(@Valid @NotNull @PathVariable("id") Long id) {
        strategyService.delete(id);
    }

    @PutMapping
    public void update(@Valid @RequestBody StrategyUpdateVO vO) {
        strategyService.update(vO);
    }

    @GetMapping("/{id}")
    public StrategyDTO getById(@Valid @NotNull @PathVariable("id") Long id) {
        return strategyService.getById(id);
    }

    @GetMapping
    public Page<StrategyDTO> query(@Valid StrategyQueryVO vO) {
        return strategyService.query(vO);
    }

    @GetMapping("/all")
    public List<StrategyDTO> findAll() {
        return strategyService.findAll();
    }

    @PutMapping("/enable/{id}")
    public ResponseEntity<Void> toggleStrategy(@PathVariable Long id, @RequestParam Boolean enabled) {
        try {
            strategyService.enableStrategy(id, enabled);
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @PutMapping("/enable/all")
    public void enableAll(@RequestBody Boolean bool) {
        strategyService.enableAll(bool);
    }
}
